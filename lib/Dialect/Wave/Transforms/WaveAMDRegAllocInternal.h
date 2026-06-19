//===- WaveAMDRegAllocInternal.h - Regalloc internals ----------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef MLIR_DIALECT_WAVE_TRANSFORMS_WAVEAMDREGALLOCINTERNAL_H
#define MLIR_DIALECT_WAVE_TRANSFORMS_WAVEAMDREGALLOCINTERNAL_H

#include "WaveAMDRegPressureRelief.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/Wave/Transforms/WaveAMDEntryRegs.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachine.h"
#include "mlir/IR/Operation.h"
#include "mlir/IR/Value.h"
#include "mlir/Support/LLVM.h"
#include "mlir/Support/LogicalResult.h"
#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/DenseSet.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/ADT/StringRef.h"
#include <cstdint>
#include <memory>
#include <optional>

namespace mlir::wave::regalloc {

inline constexpr llvm::StringLiteral kRegAllocTempAttr =
    "waveamdmachine.regalloc_debug_temp";
inline constexpr llvm::StringLiteral kLDSSpillBytesAttr =
    "waveamdmachine.lds_spill_bytes";
inline constexpr llvm::StringLiteral kPrivateSegmentFixedSizeAttr =
    "waveamdmachine.private_segment_fixed_size";
inline constexpr llvm::StringLiteral kScratchSpillBytesAttr =
    "waveamdmachine.scratch_spill_bytes";
inline constexpr llvm::StringLiteral kMemorySpillRejectAttr =
    "waveamdmachine.regalloc_debug_memory_spill_reject";
inline constexpr llvm::StringLiteral kMemorySpillRejectDetailAttr =
    "waveamdmachine.regalloc_debug_memory_spill_reject_detail";
inline constexpr llvm::StringLiteral kMemorySpillLoopCarryReject = "loop_carry";

struct IntervalGroup;

struct Interval {
  llvm::SmallDenseSet<Value, 1> values;
  IntervalGroup *group = nullptr;
  waveamdmachine::RegType type;
  unsigned start = 0;
  unsigned end = 0;
  bool reserved = false;
  bool nonPromotable = false;
};

struct IntervalGroup {
  SmallVector<Interval *> intervals;
  waveamdmachine::RegClass preferredClass;
  waveamdmachine::RegClass storageClass;
  std::optional<unsigned> assignedBase;
  std::optional<unsigned> fixedBase;
  unsigned order = 0;
  bool reserved = false;
  bool nonPromotable = false;
  bool allocatable = true;
  bool plannedPressureRelief = false;
};

struct AllocationProbeStats {
  int64_t findFreeBaseCalls = 0;
  int64_t baseFitsCalls = 0;
  int64_t assignedLaneQueries = 0;
  int64_t assignedLaneChecks = 0;
};

struct Inventory {
  SmallVector<Operation *> ops;
  DenseMap<Operation *, unsigned> positions;
  DenseMap<Value, Interval *> intervalFor;
  ::mlir::wave::WaveAMDKernelEntryRegs entryRegs;
  SmallVector<std::unique_ptr<Interval>> intervals;
  SmallVector<std::unique_ptr<IntervalGroup>> groups;
  wave::WaveAMDPressureReliefPlanList plannedReliefPlans;
  DenseMap<StringRef, unsigned> plannedProviderBytes;
  AllocationProbeStats probeStats;
  unsigned peakSGPR = 0;
  unsigned peakVGPR = 0;
  unsigned peakAGPR = 0;
  unsigned scalarIntervals = 0;
  unsigned promotedGroups = 0;
};

inline bool isRegAllocTempOp(Operation *op) {
  return op && op->hasAttr(kRegAllocTempAttr);
}

inline bool isMemoryIssuerOp(Operation *op) {
  if (!op)
    return false;
  waveamdmachine::WaitcntInfoOpInterface info =
      dyn_cast<waveamdmachine::WaitcntInfoOpInterface>(op);
  return info && info.getWaitcntInfo().isIssuer();
}

inline bool isLoopCarryUseOp(Operation *op) {
  return isa<waveamdmachine::UniformLoopOp, waveamdmachine::ContinueIfOp>(op);
}

inline bool isFixedRegisterGroup(IntervalGroup *group) {
  if (!group)
    return false;
  if (group->fixedBase)
    return true;
  for (Interval *lane : group->intervals)
    for (Value value : lane->values)
      if (auto type = dyn_cast<waveamdmachine::RegType>(value.getType()))
        if (type.getIndex() >= 0)
          return true;
  return false;
}

inline bool isMemorySpillVGPRGroup(IntervalGroup *group) {
  if (!group || group->plannedPressureRelief || group->reserved ||
      group->nonPromotable || isFixedRegisterGroup(group))
    return false;
  return group->storageClass == waveamdmachine::RegClass::VGPR &&
         group->preferredClass == waveamdmachine::RegClass::VGPR;
}

inline bool hasLiveMemorySpillLane(IntervalGroup *group, unsigned position) {
  if (!group)
    return false;
  return llvm::any_of(group->intervals, [&](Interval *lane) {
    return !lane->nonPromotable && lane->start <= position &&
           position <= lane->end;
  });
}

inline bool isMemorySpillEligibleGroup(IntervalGroup *group,
                                       unsigned position) {
  return isMemorySpillVGPRGroup(group) &&
         hasLiveMemorySpillLane(group, position);
}

using PressureFailure = ::mlir::wave::WaveAMDPressureFailure;
using PressureIntervalRef = ::mlir::wave::WaveAMDPressureIntervalRef;

struct RegisterBudgets {
  SmallVector<unsigned, 32> maxSGPRsForWaves;
  SmallVector<unsigned, 32> maxVGPRsForWaves;
  std::optional<unsigned> totalVGPRLimit;
  unsigned addressableSGPR = 0;
  unsigned addressableVGPR = 0;
  unsigned addressableAGPR = 0;
  unsigned sgpr = 0;
  unsigned vgpr = 0;
  unsigned agpr = 0;
  unsigned maxWavesPerEU = 0;
  unsigned targetWaves = 0;
  bool agprCountsAgainstVGPRs = false;
};

enum class LDSSpillPlanStatus : uint8_t {
  Available,
  NotKernel,
  MissingTargetWaves,
  MissingWorkgroupShape,
  InvalidWorkgroupShape,
  UnsupportedWorkgroupShape,
  UnsupportedSlotBase,
  UnsupportedWavesPerWorkgroup,
  InvalidValueBytes,
  InsufficientLDS,
};

struct LDSSpillPlan {
  unsigned existingFixedBytes = 0;
  unsigned existingDynamicBytes = 0;
  unsigned reservedSpillBytes = 0;
  unsigned limitBytes = 0;
  unsigned availableBytes = 0;
  unsigned slotBase = 0;
  unsigned slotBytes = 0;
  unsigned waveStride = 0;
  unsigned valueBytes = 0;
  unsigned wavesPerWorkgroup = 0;
  unsigned wavefrontSize = 0;
  LDSSpillPlanStatus status = LDSSpillPlanStatus::NotKernel;
};

enum class ScratchSpillPlanStatus : uint8_t {
  Available,
  NotKernel,
  UnsupportedTarget,
  InvalidValueBytes,
  PrivateSegmentOverflow,
};

struct ScratchSpillPlan {
  unsigned existingPrivateBytes = 0;
  unsigned reservedSpillBytes = 0;
  unsigned slotBase = 0;
  unsigned slotBytes = 0;
  unsigned valueBytes = 0;
  bool usesFlatScratch = false;
  ScratchSpillPlanStatus status = ScratchSpillPlanStatus::NotKernel;
};

struct PromotionScore {
  unsigned liveDwords = 0;
  unsigned bridgeCost = 0;
  unsigned end = 0;
};

struct BankPromotionStep {
  IntervalGroup *group = nullptr;
  waveamdmachine::RegClass sourceClass;
  waveamdmachine::RegClass targetClass;
};

struct BankPromotionHooks {
  StringRef (*getRegClassName)(waveamdmachine::RegClass) = nullptr;
  std::optional<waveamdmachine::RegClass> (*getNextRegClass)(
      waveamdmachine::RegClass) = nullptr;
  PromotionScore (*getPromotionScore)(IntervalGroup *, unsigned,
                                      Inventory &) = nullptr;
  bool (*isBetterPromotionScore)(PromotionScore, PromotionScore) = nullptr;
  bool (*isLiveAt)(IntervalGroup *, unsigned) = nullptr;
  bool (*canPromote)(IntervalGroup *, RegisterBudgets) = nullptr;
  bool (*canFitPromotionTarget)(
      IntervalGroup *, ArrayRef<IntervalGroup *>, RegisterBudgets,
      const ::mlir::wave::WaveAMDKernelEntryRegs &) = nullptr;
  LogicalResult (*materializePlans)(ArrayRef<BankPromotionStep>, Inventory &,
                                    OpBuilder &) = nullptr;
  LogicalResult (*materialize)(IntervalGroup *, Inventory &,
                               OpBuilder &) = nullptr;
};

std::unique_ptr<wave::WaveAMDPressureReliefProvider>
createBankPromotionProvider(ArrayRef<IntervalGroup *> groups,
                            IntervalGroup *request, unsigned position,
                            RegisterBudgets budgets, Inventory &inventory,
                            const BankPromotionHooks &hooks);
std::unique_ptr<wave::WaveAMDPressureReliefProvider>
createLDSSpillProvider(func::FuncOp func, ArrayRef<IntervalGroup *> groups,
                       IntervalGroup *request, unsigned position,
                       RegisterBudgets budgets, Inventory &inventory);
std::unique_ptr<wave::WaveAMDPressureReliefProvider>
createScratchSpillProvider(func::FuncOp func, ArrayRef<IntervalGroup *> groups,
                           IntervalGroup *request, unsigned position,
                           Inventory &inventory);
unsigned getPlannedProviderBytes(Inventory &inventory, StringRef provider);
void addPlannedProviderBytes(Inventory &inventory, StringRef provider,
                             unsigned bytes);
void recordPlannedPressureRelief(
    Inventory &inventory,
    std::unique_ptr<wave::WaveAMDPressureReliefPlan> plan);

StringRef getLDSSpillPlanStatusName(LDSSpillPlanStatus status);
LDSSpillPlan planLDSSpillSlot(func::FuncOp func, RegisterBudgets budgets,
                              unsigned valueBytes,
                              unsigned reservedSpillBytes = 0);
StringRef getScratchSpillPlanStatusName(ScratchSpillPlanStatus status);
ScratchSpillPlan planScratchSpillSlot(func::FuncOp func, unsigned valueBytes,
                                      unsigned reservedSpillBytes = 0);

} // namespace mlir::wave::regalloc

#endif // MLIR_DIALECT_WAVE_TRANSFORMS_WAVEAMDREGALLOCINTERNAL_H
