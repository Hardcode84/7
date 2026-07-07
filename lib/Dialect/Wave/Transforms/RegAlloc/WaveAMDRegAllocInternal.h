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
#include "mlir/IR/Block.h"
#include "mlir/IR/Builders.h"
#include "mlir/IR/IRMapping.h"
#include "mlir/IR/Operation.h"
#include "mlir/IR/Remarks.h"
#include "mlir/IR/Value.h"
#include "mlir/Support/LLVM.h"
#include "mlir/Support/LogicalResult.h"
#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/DenseSet.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/ADT/StringRef.h"
#include <algorithm>
#include <cstdint>
#include <memory>
#include <optional>
#include <string>
#include <utility>

namespace mlir::wave::regalloc {

inline constexpr llvm::StringLiteral kRegAllocTempAttr =
    "waveamdmachine.regalloc_debug_temp";
inline constexpr llvm::StringLiteral kRegAllocRematTempAttr =
    "waveamdmachine.regalloc_remat_temp";
inline constexpr llvm::StringLiteral kLDSSpillBytesAttr =
    "waveamdmachine.lds_spill_bytes";
inline constexpr llvm::StringLiteral kPrivateSegmentFixedSizeAttr =
    "waveamdmachine.private_segment_fixed_size";
inline constexpr llvm::StringLiteral kScratchSpillBytesAttr =
    "waveamdmachine.scratch_spill_bytes";
inline constexpr llvm::StringLiteral kUsesFlatScratchAttr =
    "waveamdmachine.uses_flat_scratch";
inline constexpr llvm::StringLiteral kSGPRSpillCountAttr =
    "waveamdmachine.sgpr_spill_count";
inline constexpr llvm::StringLiteral kVGPRSpillCountAttr =
    "waveamdmachine.vgpr_spill_count";
inline constexpr llvm::StringLiteral kRegAllocRemarkCategory =
    "waveamdmachine-regalloc";
inline constexpr llvm::StringLiteral kRegAllocCoalesceMFMAAccResultAttr =
    "waveamdmachine.regalloc_coalesce_mfma_acc_result";

struct IntervalGroup;

inline StringRef getRegClassName(waveamdmachine::RegClass regClass) {
  if (regClass == waveamdmachine::RegClass::SGPR)
    return "SGPR";
  if (regClass == waveamdmachine::RegClass::VGPR)
    return "VGPR";
  if (regClass == waveamdmachine::RegClass::AGPR)
    return "AGPR";
  return "";
}

inline remark::RemarkOpts getWaveAMDRegAllocRemarkOpts(func::FuncOp func,
                                                       StringRef name) {
  return remark::RemarkOpts::name(name)
      .category(kRegAllocRemarkCategory)
      .function(func.getSymName());
}

inline void emitRegAllocIntegerMetric(remark::detail::InFlightRemark &remark,
                                      StringRef name, int64_t value) {
  if (remark)
    remark << mlir::remark::metric(name, value);
}

inline void emitRegAllocStringMetric(remark::detail::InFlightRemark &remark,
                                     StringRef name, StringRef value) {
  if (remark)
    remark << mlir::remark::detail::Remark::Arg(name, value);
}

struct Interval {
  llvm::SmallDenseSet<Value, 1> values;
  IntervalGroup *group = nullptr;
  waveamdmachine::RegType type;
  unsigned start = 0;
  unsigned end = 0;
  bool reserved = false;
  bool nonPromotable = false;
  bool plannedTemp = false;
  bool rematerializableTemp = false;
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

struct PlannedPressureReliefTempInterval {
  const wave::WaveAMDPressureReliefPlan *plan = nullptr;
  wave::WaveAMDPressureReliefTempInterval interval;
  IntervalGroup *group = nullptr;
};

struct AllocationProbeStats {
  int64_t findFreeBaseCalls = 0;
  int64_t baseFitsCalls = 0;
  int64_t assignedLaneQueries = 0;
  int64_t assignedLaneChecks = 0;
};

struct LoopCarryLoopRemap {
  SmallVector<int64_t, 4> indexMap;
  Operation *loop = nullptr;
};

struct Inventory {
  SmallVector<Operation *> ops;
  DenseMap<Operation *, unsigned> positions;
  DenseMap<Value, Interval *> intervalFor;
  ::mlir::wave::WaveAMDKernelEntryRegs entryRegs;
  SmallVector<std::unique_ptr<Interval>> intervals;
  SmallVector<std::unique_ptr<IntervalGroup>> groups;
  wave::WaveAMDPressureReliefPlanList plannedReliefPlans;
  SmallVector<PlannedPressureReliefTempInterval, 16> plannedReliefTemps;
  SmallVector<PlannedPressureReliefTempInterval, 16> plannedReliefFixedTemps;
  DenseMap<StringRef, unsigned> plannedProviderBytes;
  DenseMap<Operation *, LoopCarryLoopRemap> loopCarryRemaps;
  AllocationProbeStats probeStats;
  unsigned peakSGPR = 0;
  unsigned peakVGPR = 0;
  unsigned peakAGPR = 0;
  unsigned scalarIntervals = 0;
  unsigned promotedGroups = 0;
};

using PressureFailure = ::mlir::wave::WaveAMDPressureFailure;
using PressureIntervalRef = ::mlir::wave::WaveAMDPressureIntervalRef;

inline bool isRegAllocTempOp(Operation *op) {
  return op && op->hasAttr(kRegAllocTempAttr);
}

inline bool isRegAllocRematTempOp(Operation *op) {
  return op && op->hasAttr(kRegAllocRematTempAttr);
}

inline bool isRegAllocGeneratedOp(Operation *op) {
  return isRegAllocTempOp(op) || isRegAllocRematTempOp(op);
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

inline Value getMemoryIssuerToken(Operation *op) {
  if (!isMemoryIssuerOp(op))
    return {};
  for (Value result : op->getResults())
    if (isa<waveamdmachine::MemTokenType>(result.getType()))
      return result;
  return {};
}

inline Operation *getAncestorInBlock(Operation *op, Block *block) {
  for (Operation *cur = op; cur; cur = cur->getParentOp())
    if (cur->getBlock() == block)
      return cur;
  return nullptr;
}

inline bool useIsDominatedByDef(Operation *def, Operation *user) {
  if (user->getBlock() == def->getBlock())
    return true;
  Operation *ancestor = getAncestorInBlock(user, def->getBlock());
  return ancestor && def->isBeforeInBlock(ancestor);
}

inline unsigned getPressureOverage(unsigned liveDwords, unsigned limit) {
  if (liveDwords <= limit)
    return 0;
  return liveDwords - limit;
}

inline unsigned alignDownTo(unsigned value, unsigned granule) {
  return (value / granule) * granule;
}

inline wave::WaveAMDPressureReliefEffect
getMemorySpillPressureEffect(IntervalGroup *group, unsigned reliefDwords) {
  if (!group || reliefDwords == 0)
    return {};
  wave::WaveAMDPressureReliefEffect effect;
  if (group->storageClass == waveamdmachine::RegClass::VGPR)
    effect.vgprLiveDelta = -static_cast<int64_t>(reliefDwords);
  if (group->storageClass == waveamdmachine::RegClass::AGPR)
    effect.agprLiveDelta = -static_cast<int64_t>(reliefDwords);
  return effect;
}

inline wave::WaveAMDPressureReliefEffect
getMemorySpillPressureEffect(IntervalGroup *group, unsigned reliefDwords,
                             const PressureFailure &failure) {
  if (failure.placementFailure)
    return {};
  if (failure.combinedVGPRAGPR && group &&
      group->storageClass == waveamdmachine::RegClass::AGPR)
    return {};
  return getMemorySpillPressureEffect(group, reliefDwords);
}

inline bool isCheapVGPRPressureReliefExpr(Operation *op);
inline bool isCheapVGPRPressureReliefRootExpr(Operation *op);
inline bool isMemorySpillSuppressedVGPRExpr(Operation *op);

struct MemorySpillLoadResult {
  Value value;
  Value token;
};

inline unsigned getLoopDepth(Operation *op) {
  unsigned depth = 0;
  for (Operation *cur = op; cur; cur = cur->getParentOp())
    if (isa<waveamdmachine::UniformLoopOp>(cur))
      ++depth;
  return depth;
}

inline int64_t getLoopCostScale(Operation *op) {
  unsigned depth = getLoopDepth(op);
  if (depth == 0)
    return 1;
  return int64_t{1} << std::min<unsigned>(depth * 4, 20);
}

inline void addLoopScaledCost(wave::WaveAMDPressureReliefCost &cost,
                              Operation *op, int64_t opCost) {
  int64_t scale = getLoopCostScale(op);
  if (scale == 1) {
    cost.materializationOps += opCost;
    return;
  }
  cost.loopWeightedOps += opCost * scale;
}

inline void addLoopScaledLatency(wave::WaveAMDPressureReliefCost &cost,
                                 Operation *op, int64_t latencyCost) {
  cost.latencyPenalty += latencyCost * getLoopCostScale(op);
}

inline Operation *getMemorySpillValueAnchorOp(Value value) {
  if (Operation *def = value.getDefiningOp())
    return def;
  auto arg = dyn_cast<BlockArgument>(value);
  if (!arg)
    return nullptr;
  return arg.getOwner()->getParentOp();
}

inline Operation *getMemorySpillValueDiagOp(Value value) {
  return getMemorySpillValueAnchorOp(value);
}

inline std::optional<unsigned>
getMemorySpillOpPosition(Operation *op, const Inventory &inventory) {
  if (!op)
    return std::nullopt;
  DenseMap<Operation *, unsigned>::const_iterator it =
      inventory.positions.find(op);
  if (it == inventory.positions.end())
    return std::nullopt;
  return it->second;
}

inline std::optional<unsigned>
getMemorySpillValuePositionIfKnown(Value value, const Inventory &inventory) {
  if (Operation *def = value.getDefiningOp())
    return getMemorySpillOpPosition(def, inventory);
  auto arg = dyn_cast<BlockArgument>(value);
  if (!arg)
    return std::nullopt;
  Operation *parent = arg.getOwner()->getParentOp();
  if (isa_and_nonnull<func::FuncOp>(parent))
    return 0;
  return getMemorySpillOpPosition(parent, inventory);
}

inline bool hasMemorySpillStoreAnchor(Value value, const Inventory &inventory) {
  if (Operation *def = value.getDefiningOp()) {
    if (!getMemorySpillOpPosition(def, inventory))
      return false;
    return !isMemoryIssuerOp(def) || getMemoryIssuerToken(def);
  }

  auto arg = dyn_cast<BlockArgument>(value);
  if (!arg)
    return false;
  Operation *parent = arg.getOwner()->getParentOp();
  if (!parent || isa<func::FuncOp>(parent))
    return false;
  return getMemorySpillOpPosition(parent, inventory).has_value();
}

inline bool hasNonTempUse(Value value) {
  for (OpOperand &use : value.getUses())
    if (!isRegAllocTempOp(use.getOwner()))
      return true;
  return false;
}

inline bool
collectSimpleMemorySpillVGPRUses(Value value, const Inventory &inventory,
                                 SmallVectorImpl<OpOperand *> &uses) {
  if (!hasMemorySpillStoreAnchor(value, inventory))
    return false;
  for (OpOperand &use : value.getUses()) {
    Operation *user = use.getOwner();
    if (isRegAllocTempOp(user))
      continue;
    if (isLoopCarryUseOp(user))
      return false;
    if (!getMemorySpillOpPosition(user, inventory))
      return false;
    uses.push_back(&use);
  }
  return !uses.empty();
}

inline bool collectSimpleMemorySpillUses(Value value,
                                         const Inventory &inventory,
                                         SmallVectorImpl<OpOperand *> &uses) {
  waveamdmachine::RegType type =
      dyn_cast<waveamdmachine::RegType>(value.getType());
  if (!type || type.getRegClass() != waveamdmachine::RegClass::VGPR)
    return false;
  return collectSimpleMemorySpillVGPRUses(value, inventory, uses);
}

inline bool hasOnlyRegAllocTempUses(Value value) {
  return llvm::all_of(value.getUses(), [](OpOperand &use) {
    return isRegAllocTempOp(use.getOwner());
  });
}

inline bool isValueLiveAtPressure(Value value, ArrayRef<OpOperand *> uses,
                                  const Inventory &inventory,
                                  unsigned position) {
  std::optional<unsigned> valuePosition =
      getMemorySpillValuePositionIfKnown(value, inventory);
  if (!valuePosition)
    return false;
  unsigned start = *valuePosition;
  if (start > position)
    return false;
  unsigned end = start;
  for (OpOperand *use : uses) {
    std::optional<unsigned> usePosition =
        getMemorySpillOpPosition(use->getOwner(), inventory);
    if (!usePosition)
      return false;
    end = std::max(end, *usePosition);
  }
  return position <= end;
}

inline bool valueCoversWholeGroup(IntervalGroup *group, Value value,
                                  const Inventory &inventory) {
  auto type = dyn_cast<waveamdmachine::RegType>(value.getType());
  if (!type ||
      static_cast<unsigned>(type.getWidth()) != group->intervals.size())
    return false;
  Interval *first = inventory.intervalFor.lookup(value);
  return first && first->group == group && first == group->intervals.front();
}

inline unsigned getLiveLaneCount(IntervalGroup *group, unsigned position) {
  unsigned count = 0;
  for (Interval *lane : group->intervals)
    if (!lane->values.empty() && lane->start <= position &&
        position <= lane->end)
      ++count;
  return count;
}

inline bool hasLiveLaneAtPressure(IntervalGroup *group, unsigned position) {
  for (Interval *lane : group->intervals)
    if (!lane->values.empty() && lane->start <= position &&
        position <= lane->end)
      return true;
  return false;
}

inline int64_t getMemorySpillValueOrder(Value value,
                                        const Inventory &inventory) {
  int64_t resultIndex = -1;
  if (OpResult result = dyn_cast<OpResult>(value)) {
    resultIndex = result.getResultNumber();
    std::optional<unsigned> position =
        getMemorySpillOpPosition(result.getOwner(), inventory);
    return static_cast<int64_t>(position.value_or(0)) * 2048 + resultIndex;
  }
  BlockArgument arg = cast<BlockArgument>(value);
  resultIndex = arg.getArgNumber();
  Operation *parent = arg.getOwner()->getParentOp();
  if (isa_and_nonnull<func::FuncOp>(parent))
    return resultIndex;
  std::optional<unsigned> position =
      getMemorySpillOpPosition(parent, inventory);
  return static_cast<int64_t>(position.value_or(0)) * 2048 + 1024 + resultIndex;
}

inline SmallVector<Value>
getMemorySpillGroupValues(IntervalGroup *group, const Inventory &inventory) {
  SmallVector<Value> values;
  llvm::SmallDenseSet<Value, 8> seen;
  for (Interval *lane : group->intervals)
    for (Value value : lane->values)
      if (seen.insert(value).second)
        values.push_back(value);
  llvm::stable_sort(values, [&](Value lhs, Value rhs) {
    return getMemorySpillValueOrder(lhs, inventory) <
           getMemorySpillValueOrder(rhs, inventory);
  });
  return values;
}

struct MemorySpillLoopCarrySlot {
  waveamdmachine::UniformLoopOp loop;
  unsigned index = 0;
};

inline std::optional<MemorySpillLoopCarrySlot>
resolveLoopCarrySlot(MemorySpillLoopCarrySlot slot,
                     const Inventory &inventory) {
  Operation *loopOp = slot.loop.getOperation();
  unsigned index = slot.index;
  llvm::SmallDenseSet<Operation *, 4> visited;
  while (loopOp && visited.insert(loopOp).second) {
    auto it = inventory.loopCarryRemaps.find(loopOp);
    if (it == inventory.loopCarryRemaps.end())
      break;
    const LoopCarryLoopRemap &remap = it->second;
    if (index >= remap.indexMap.size() || remap.indexMap[index] < 0)
      return std::nullopt;
    index = static_cast<unsigned>(remap.indexMap[index]);
    loopOp = remap.loop;
  }
  auto loop = dyn_cast_if_present<waveamdmachine::UniformLoopOp>(loopOp);
  if (!loop || index >= loop.getInits().size())
    return std::nullopt;
  return MemorySpillLoopCarrySlot{loop, index};
}

inline LogicalResult
mergeLoopCarrySlot(MemorySpillLoopCarrySlot next,
                   std::optional<MemorySpillLoopCarrySlot> &slot) {
  if (!slot) {
    slot = next;
    return success();
  }
  if (slot->loop == next.loop && slot->index == next.index)
    return success();
  return failure();
}

inline std::optional<MemorySpillLoopCarrySlot>
getValueLoopCarrySlot(Value value) {
  if (BlockArgument arg = dyn_cast<BlockArgument>(value))
    if (waveamdmachine::UniformLoopOp loop =
            dyn_cast<waveamdmachine::UniformLoopOp>(
                arg.getOwner()->getParentOp()))
      return MemorySpillLoopCarrySlot{loop, arg.getArgNumber()};
  if (waveamdmachine::UniformLoopOp loop =
          value.getDefiningOp<waveamdmachine::UniformLoopOp>())
    return MemorySpillLoopCarrySlot{loop,
                                    cast<OpResult>(value).getResultNumber()};
  for (OpOperand &use : value.getUses()) {
    Operation *owner = use.getOwner();
    if (waveamdmachine::UniformLoopOp loop =
            dyn_cast<waveamdmachine::UniformLoopOp>(owner))
      for (auto [index, init] : llvm::enumerate(loop.getInits()))
        if (init == value)
          return MemorySpillLoopCarrySlot{loop, static_cast<unsigned>(index)};
    if (waveamdmachine::ContinueIfOp term =
            dyn_cast<waveamdmachine::ContinueIfOp>(owner))
      if (use.getOperandNumber() != 0)
        return MemorySpillLoopCarrySlot{
            term->getParentOfType<waveamdmachine::UniformLoopOp>(),
            use.getOperandNumber() - 1};
  }
  return std::nullopt;
}

inline LogicalResult
mergeLoopCarrySlot(Value value, std::optional<MemorySpillLoopCarrySlot> &slot) {
  if (std::optional<MemorySpillLoopCarrySlot> valueSlot =
          getValueLoopCarrySlot(value))
    return mergeLoopCarrySlot(*valueSlot, slot);
  return success();
}

inline std::optional<MemorySpillLoopCarrySlot>
getLoopCarrySlot(IntervalGroup *group, const Inventory &inventory) {
  std::optional<MemorySpillLoopCarrySlot> slot;
  for (Value value : getMemorySpillGroupValues(group, inventory))
    if (failed(mergeLoopCarrySlot(value, slot)))
      return std::nullopt;
  return slot;
}

inline bool hasLocalLoopCarryUses(MemorySpillLoopCarrySlot slot) {
  Block &body = slot.loop.getBody().front();
  BlockArgument arg = body.getArgument(slot.index);
  for (OpOperand &use : arg.getUses())
    if (!getAncestorInBlock(use.getOwner(), &body))
      return false;
  return true;
}

inline bool isSplatInit(MemorySpillLoopCarrySlot slot) {
  waveamdmachine::VMovB32TupleOp splat =
      slot.loop.getInits()[slot.index]
          .getDefiningOp<waveamdmachine::VMovB32TupleOp>();
  return splat && splat.getSource().getDefiningOp<waveamdmachine::ImmOp>();
}

inline bool canSpillLoopCarryAtPosition(MemorySpillLoopCarrySlot slot,
                                        const Inventory &inventory,
                                        unsigned position) {
  std::optional<unsigned> loopPos =
      getMemorySpillOpPosition(slot.loop, inventory);
  if (!loopPos)
    return false;
  if (position > *loopPos)
    return true;
  return isSplatInit(slot);
}

inline bool canRewriteExtraLoopInitUse(OpOperand &use, OpOperand *loopUse,
                                       waveamdmachine::UniformLoopOp loop) {
  if (&use == loopUse || isRegAllocGeneratedOp(use.getOwner()))
    return true;
  Operation *user = use.getOwner();
  return user->getBlock() == loop->getBlock() && user->isBeforeInBlock(loop);
}

inline bool canRewriteExtraLoopInitUses(MemorySpillLoopCarrySlot slot) {
  OpOperand *loopUse = &slot.loop.getInitsMutable()[slot.index];
  Value init = loopUse->get();
  for (OpOperand &use : init.getUses())
    if (!canRewriteExtraLoopInitUse(use, loopUse, slot.loop))
      return false;
  return true;
}

inline Operation *
getLoopCarryFirstPreheaderUse(Value init, OpOperand *loopUse,
                              waveamdmachine::UniformLoopOp loop) {
  Operation *first = nullptr;
  for (OpOperand &use : init.getUses()) {
    Operation *user = use.getOwner();
    if (&use == loopUse || isRegAllocGeneratedOp(user))
      continue;
    if (!canRewriteExtraLoopInitUse(use, loopUse, loop))
      continue;
    if (user->getBlock() != loop->getBlock() || !user->isBeforeInBlock(loop))
      continue;
    if (!first || user->isBeforeInBlock(first))
      first = user;
  }
  return first;
}

inline Operation *
getLoopCarryInitStoreDiagOp(Value init, OpOperand *loopUse,
                            waveamdmachine::UniformLoopOp loop) {
  Operation *def = init.getDefiningOp();
  Operation *firstPreheaderUse =
      getLoopCarryFirstPreheaderUse(init, loopUse, loop);
  if (firstPreheaderUse && (!def || def->getBlock() != loop->getBlock() ||
                            def->isBeforeInBlock(firstPreheaderUse)))
    return firstPreheaderUse;
  if (!def || def->getBlock() != loop->getBlock() ||
      !def->isBeforeInBlock(loop))
    return loop.getOperation();
  return def;
}

inline unsigned getLoopCarryUseCount(MemorySpillLoopCarrySlot slot) {
  Block &body = slot.loop.getBody().front();
  BlockArgument arg = body.getArgument(slot.index);
  unsigned count = llvm::range_size(arg.getUses());
  count += llvm::range_size(slot.loop.getResult(slot.index).getUses());
  return count + 1;
}

inline bool canMaterializeLoopCarrySpill(MemorySpillLoopCarrySlot slot,
                                         const Inventory &inventory,
                                         unsigned position) {
  return canSpillLoopCarryAtPosition(slot, inventory, position) &&
         hasLocalLoopCarryUses(slot) && canRewriteExtraLoopInitUses(slot);
}

inline bool isMemorySpillProviderRegClass(waveamdmachine::RegClass regClass);

template <typename SlotPlanT> struct MemorySpillValueSlot {
  Value value;
  waveamdmachine::RegType type;
  SlotPlanT plan;
  wave::WaveAMDPressureReliefCost cost;
  unsigned useCount = 0;
};

template <typename SlotsT>
static unsigned getMemorySpillTotalUseCount(const SlotsT &slots) {
  unsigned total = 0;
  for (const typename SlotsT::value_type &slot : slots)
    total += slot.useCount;
  return total;
}

template <typename SlotsT>
static wave::WaveAMDPressureReliefCost
getMemorySpillTotalCost(const SlotsT &slots) {
  wave::WaveAMDPressureReliefCost total;
  for (const typename SlotsT::value_type &slot : slots) {
    total.materializationOps += slot.cost.materializationOps;
    total.loopWeightedOps += slot.cost.loopWeightedOps;
    total.latencyPenalty += slot.cost.latencyPenalty;
    total.instabilityPenalty += slot.cost.instabilityPenalty;
  }
  return total;
}

template <typename Traits>
class MemorySpillPressurePlan final : public wave::WaveAMDPressureReliefPlan {
public:
  using Slot = MemorySpillValueSlot<typename Traits::SlotPlan>;

  MemorySpillPressurePlan(IntervalGroup *group, ArrayRef<Slot> valueSlots,
                          unsigned reliefDwords)
      : valueSlots(valueSlots), group(group), reliefDwords(reliefDwords) {}

  MemorySpillPressurePlan(IntervalGroup *group,
                          MemorySpillLoopCarrySlot loopCarry, Slot valueSlot,
                          unsigned useCount, unsigned reliefDwords)
      : group(group), loopCarry(loopCarry), loopCarryUseCount(useCount),
        reliefDwords(reliefDwords) {
    valueSlots.push_back(std::move(valueSlot));
  }

  StringRef getProviderName() const override {
    return Traits::getProviderName();
  }

  wave::WaveAMDPressureReliefProviderKind getProviderKind() const override {
    return Traits::providerKind;
  }

  unsigned getReliefDwords() const override { return reliefDwords; }

  IntervalGroup *getGroup() const { return group; }
  typename Traits::SlotPlan getPlan() const {
    assert(!valueSlots.empty() && "memory spill plan needs a slot");
    return valueSlots.front().plan;
  }
  unsigned getUseCount() const {
    if (loopCarry)
      return loopCarryUseCount;
    return getMemorySpillTotalUseCount(valueSlots);
  }
  Value getValue() const {
    if (loopCarry)
      return {};
    return valueSlots.size() == 1 ? valueSlots.front().value : Value{};
  }
  ArrayRef<Slot> getValueSlots() const { return valueSlots; }
  unsigned getReservedBytes() const {
    return Traits::getTotalSlotBytes(valueSlots);
  }
  std::optional<MemorySpillLoopCarrySlot> getLoopCarry() const {
    return loopCarry;
  }

private:
  SmallVector<Slot, 4> valueSlots;
  IntervalGroup *group = nullptr;
  std::optional<MemorySpillLoopCarrySlot> loopCarry;
  unsigned loopCarryUseCount = 0;
  unsigned reliefDwords = 0;
};

template <typename Traits>
class MemorySpillCandidate final : public wave::WaveAMDPressureReliefCandidate {
public:
  using Slot = MemorySpillValueSlot<typename Traits::SlotPlan>;
  using Plan = MemorySpillPressurePlan<Traits>;

  MemorySpillCandidate(IntervalGroup *group, ArrayRef<Slot> valueSlots,
                       unsigned pressureRelief,
                       wave::WaveAMDPressureReliefCost cost)
      : valueSlots(valueSlots), cost(cost), group(group),
        pressureRelief(pressureRelief) {}

  MemorySpillCandidate(IntervalGroup *group, MemorySpillLoopCarrySlot loopCarry,
                       Slot valueSlot, unsigned useCount,
                       unsigned pressureRelief,
                       wave::WaveAMDPressureReliefCost cost)
      : cost(cost), group(group), loopCarry(loopCarry),
        loopCarryUseCount(useCount), pressureRelief(pressureRelief) {
    valueSlots.push_back(std::move(valueSlot));
  }

  StringRef getProviderName() const override {
    return Traits::getProviderName();
  }

  wave::WaveAMDPressureReliefCost getCost() const override { return cost; }

  unsigned getReliefDwords() const override { return pressureRelief; }

  wave::WaveAMDPressureReliefEffect getPressureEffect(
      const wave::WaveAMDPressureFailure &failure) const override {
    return getMemorySpillPressureEffect(group, pressureRelief, failure);
  }

  IntervalGroup *getGroup() const { return group; }
  typename Traits::SlotPlan getPlan() const {
    assert(!valueSlots.empty() && "memory spill candidate needs a slot");
    return valueSlots.front().plan;
  }
  unsigned getUseCount() const {
    if (loopCarry)
      return loopCarryUseCount;
    return getMemorySpillTotalUseCount(valueSlots);
  }
  Value getValue() const {
    if (loopCarry)
      return {};
    return valueSlots.size() == 1 ? valueSlots.front().value : Value{};
  }
  ArrayRef<Slot> getValueSlots() const { return valueSlots; }
  std::optional<MemorySpillLoopCarrySlot> getLoopCarry() const {
    return loopCarry;
  }
  std::unique_ptr<wave::WaveAMDPressureReliefPlan> getPlannedSpill() const {
    if (loopCarry) {
      assert(valueSlots.size() == 1 && "loop-carry spill uses one slot");
      return std::make_unique<Plan>(group, *loopCarry, valueSlots.front(),
                                    loopCarryUseCount, pressureRelief);
    }
    return std::make_unique<Plan>(group, valueSlots, pressureRelief);
  }

protected:
  void printExtra(llvm::raw_ostream &os) const override {
    typename Traits::SlotPlan firstPlan = getPlan();
    os << ", reg_class=" << getRegClassName(group->storageClass);
    os << ", slot_base=" << Traits::getSlotBase(firstPlan)
       << ", slot_bytes=" << Traits::getTotalSlotBytes(valueSlots)
       << ", uses=" << getUseCount();
  }

  void setExtraDiagnosticAttrs(Builder &builder,
                               NamedAttrList &attrs) const override {
    typename Traits::SlotPlan firstPlan = getPlan();
    attrs.set("reg_class",
              builder.getStringAttr(getRegClassName(group->storageClass)));
    attrs.set("slot_base",
              builder.getI64IntegerAttr(Traits::getSlotBase(firstPlan)));
    attrs.set("slot_bytes",
              builder.getI64IntegerAttr(Traits::getTotalSlotBytes(valueSlots)));
    attrs.set("pressure_relief", builder.getI64IntegerAttr(pressureRelief));
    attrs.set("uses", builder.getI64IntegerAttr(getUseCount()));
  }

private:
  SmallVector<Slot, 4> valueSlots;
  wave::WaveAMDPressureReliefCost cost;
  IntervalGroup *group = nullptr;
  std::optional<MemorySpillLoopCarrySlot> loopCarry;
  unsigned loopCarryUseCount = 0;
  unsigned pressureRelief = 0;
};

template <typename CandidateT>
static bool
isBetterMemorySpillCandidate(const wave::WaveAMDPressureReliefCandidate &lhs,
                             const wave::WaveAMDPressureReliefCandidate &rhs) {
  if (lhs.isLegal() != rhs.isLegal())
    return lhs.isLegal();
  const CandidateT &lhsSpill = static_cast<const CandidateT &>(lhs);
  const CandidateT &rhsSpill = static_cast<const CandidateT &>(rhs);
  if (wave::isBetterWaveAMDPressureReliefCandidate(lhs, rhs))
    return true;
  if (wave::isBetterWaveAMDPressureReliefCandidate(rhs, lhs))
    return false;
  if (lhsSpill.getGroup()->intervals.front()->end !=
      rhsSpill.getGroup()->intervals.front()->end)
    return lhsSpill.getGroup()->intervals.front()->end >
           rhsSpill.getGroup()->intervals.front()->end;
  return false;
}

template <typename Traits, typename GetValueSlotFn>
static void collectWholeAliasSetMemorySpillCandidate(
    IntervalGroup *group, unsigned position, const Inventory &inventory,
    wave::WaveAMDPressureReliefCandidateList &candidates,
    GetValueSlotFn getValueSlot) {
  if (!hasLiveLaneAtPressure(group, position))
    return;
  unsigned relief = getLiveLaneCount(group, position);

  using Slot = MemorySpillValueSlot<typename Traits::SlotPlan>;
  SmallVector<Slot, 8> slots;
  unsigned extraReservedBytes = 0;
  for (Value value : getMemorySpillGroupValues(group, inventory)) {
    if (!hasNonTempUse(value))
      continue;
    FailureOr<Slot> slot = getValueSlot(value, extraReservedBytes);
    if (failed(slot))
      return;
    extraReservedBytes += Traits::getSlotBytes(slot->plan);
    slots.push_back(*slot);
  }
  if (slots.empty())
    return;
  candidates.push_back(std::make_unique<MemorySpillCandidate<Traits>>(
      group, slots, relief, getMemorySpillTotalCost(slots)));
}

template <typename Traits, typename GetLoopCarrySlotFn>
static bool collectLoopCarryMemorySpillCandidate(
    IntervalGroup *group, unsigned position, const Inventory &inventory,
    wave::WaveAMDPressureReliefCandidateList &candidates,
    GetLoopCarrySlotFn getLoopCarrySlot) {
  if (!hasLiveLaneAtPressure(group, position))
    return false;
  std::optional<MemorySpillLoopCarrySlot> loopCarry =
      mlir::wave::regalloc::getLoopCarrySlot(group, inventory);
  if (!loopCarry)
    return false;
  if (!canMaterializeLoopCarrySpill(*loopCarry, inventory, position))
    return false;
  Value init = loopCarry->loop.getInits()[loopCarry->index];
  auto type = dyn_cast<waveamdmachine::RegType>(init.getType());
  if (!type || !isMemorySpillProviderRegClass(type.getRegClass()) ||
      type.getWidth() == 0 || !valueCoversWholeGroup(group, init, inventory))
    return false;
  unsigned useCount = mlir::wave::regalloc::getLoopCarryUseCount(*loopCarry);
  using Slot = MemorySpillValueSlot<typename Traits::SlotPlan>;
  FailureOr<Slot> slot = getLoopCarrySlot(*loopCarry, init, type, useCount);
  if (failed(slot))
    return false;
  wave::WaveAMDPressureReliefCost cost = slot->cost;
  candidates.push_back(std::make_unique<MemorySpillCandidate<Traits>>(
      group, *loopCarry, std::move(*slot), useCount, type.getWidth(), cost));
  return true;
}

template <typename Traits, typename GetValueSlotFn, typename GetLoopCarrySlotFn>
static void collectMemorySpillCandidate(
    IntervalGroup *group, unsigned position, const Inventory &inventory,
    wave::WaveAMDPressureReliefCandidateList &candidates,
    GetValueSlotFn getValueSlot, GetLoopCarrySlotFn getLoopCarrySlot) {
  if (collectLoopCarryMemorySpillCandidate<Traits>(
          group, position, inventory, candidates, getLoopCarrySlot))
    return;
  collectWholeAliasSetMemorySpillCandidate<Traits>(group, position, inventory,
                                                   candidates, getValueSlot);
}

inline unsigned getMemorySpillValuePosition(Value value,
                                            const Inventory &inventory) {
  std::optional<unsigned> position =
      getMemorySpillValuePositionIfKnown(value, inventory);
  assert(position && "spill value must have a known position");
  return *position;
}

inline waveamdmachine::RegType getTempAssignmentRegType(
    const wave::WaveAMDPressureReliefTempAssignment &assignment,
    MLIRContext *ctx) {
  return waveamdmachine::RegType::get(ctx, assignment.regClass,
                                      assignment.width, assignment.base);
}

inline SmallVector<Type> getTempAssignmentScalarRegTypes(
    const wave::WaveAMDPressureReliefTempAssignment &assignment,
    MLIRContext *ctx) {
  SmallVector<Type> types;
  types.reserve(assignment.width);
  for (unsigned lane : llvm::seq<unsigned>(0, assignment.width))
    types.push_back(waveamdmachine::RegType::get(
        ctx, assignment.regClass, /*width=*/1, assignment.base + lane));
  return types;
}

inline FailureOr<waveamdmachine::RegType> consumePressureReliefTempRegType(
    const wave::WaveAMDPressureReliefPlan &plan,
    wave::WaveAMDPressureReliefMaterializationContext &context,
    waveamdmachine::RegClass regClass, unsigned width, Operation *diagOp) {
  FailureOr<wave::WaveAMDPressureReliefTempAssignment> assignment =
      context.consumeTempAssignment(plan, regClass, width, diagOp);
  if (failed(assignment))
    return failure();
  return getTempAssignmentRegType(*assignment, diagOp->getContext());
}

inline void assignValueToTempAssignment(
    Value value, const wave::WaveAMDPressureReliefTempAssignment &assignment) {
  value.setType(getTempAssignmentRegType(assignment, value.getContext()));
}

inline bool valuesShareIntervalGroup(Value lhs, Value rhs,
                                     const Inventory &inventory) {
  Interval *lhsInterval = inventory.intervalFor.lookup(lhs);
  Interval *rhsInterval = inventory.intervalFor.lookup(rhs);
  return lhsInterval && rhsInterval && lhsInterval->group == rhsInterval->group;
}

inline bool setRegTypeIfUnallocated(Value value,
                                    waveamdmachine::RegClass regClass,
                                    unsigned width, int64_t index) {
  auto type = dyn_cast<waveamdmachine::RegType>(value.getType());
  if (!type || type.getRegClass() != regClass ||
      static_cast<unsigned>(type.getWidth()) != width || type.getIndex() >= 0)
    return false;
  value.setType(
      waveamdmachine::RegType::get(value.getContext(), regClass, width, index));
  return true;
}

template <typename ElementsT>
static bool
propagateTupleAliasTypesFromTuple(Value tuple, ElementsT elements,
                                  waveamdmachine::RegType tupleType) {
  bool changed = false;
  unsigned offset = 0;
  for (Value element : elements) {
    auto elementType = dyn_cast<waveamdmachine::RegType>(element.getType());
    if (!elementType || elementType.getRegClass() != tupleType.getRegClass())
      return changed;
    unsigned width = static_cast<unsigned>(elementType.getWidth());
    changed |= setRegTypeIfUnallocated(element, tupleType.getRegClass(), width,
                                       tupleType.getIndex() + offset);
    offset += width;
  }
  return changed;
}

template <typename ElementsT>
static std::optional<int64_t> getTupleAliasBaseFromElements(
    ElementsT elements, waveamdmachine::RegType tupleType, unsigned &width) {
  std::optional<int64_t> base;
  width = 0;
  for (Value element : elements) {
    auto elementType = dyn_cast<waveamdmachine::RegType>(element.getType());
    if (!elementType || elementType.getRegClass() != tupleType.getRegClass() ||
        elementType.getIndex() < 0)
      return std::nullopt;
    int64_t candidate = elementType.getIndex() - static_cast<int64_t>(width);
    if (base && *base != candidate)
      return std::nullopt;
    base = candidate;
    width += static_cast<unsigned>(elementType.getWidth());
  }
  return base;
}

template <typename ElementsT>
static bool propagateTupleAliasTypes(Value tuple, ElementsT elements) {
  auto tupleType = dyn_cast<waveamdmachine::RegType>(tuple.getType());
  if (!tupleType)
    return false;
  if (tupleType.getIndex() >= 0)
    return propagateTupleAliasTypesFromTuple(tuple, elements, tupleType);

  unsigned width = 0;
  std::optional<int64_t> base =
      getTupleAliasBaseFromElements(elements, tupleType, width);
  if (!base || width != static_cast<unsigned>(tupleType.getWidth()))
    return false;
  return setRegTypeIfUnallocated(tuple, tupleType.getRegClass(), width, *base);
}

static bool propagateSameTupleAliasTypes(Value lhs, Value rhs) {
  auto lhsType = dyn_cast<waveamdmachine::RegType>(lhs.getType());
  auto rhsType = dyn_cast<waveamdmachine::RegType>(rhs.getType());
  if (!lhsType || !rhsType || lhsType.getRegClass() != rhsType.getRegClass() ||
      lhsType.getWidth() != rhsType.getWidth())
    return false;
  if (lhsType.getIndex() >= 0)
    return setRegTypeIfUnallocated(rhs, lhsType.getRegClass(),
                                   static_cast<unsigned>(lhsType.getWidth()),
                                   lhsType.getIndex());
  if (rhsType.getIndex() >= 0)
    return setRegTypeIfUnallocated(lhs, rhsType.getRegClass(),
                                   static_cast<unsigned>(rhsType.getWidth()),
                                   rhsType.getIndex());
  return false;
}

static bool
propagateUpdateTupleAliasTypes(waveamdmachine::UpdateTupleOp update) {
  bool changed =
      propagateSameTupleAliasTypes(update.getResult(), update.getBase());
  auto resultType =
      dyn_cast<waveamdmachine::RegType>(update.getResult().getType());
  if (!resultType || resultType.getIndex() < 0)
    return changed;
  for (auto [value, offset] :
       llvm::zip_equal(update.getUpdates(), update.getOffsets())) {
    auto valueType = dyn_cast<waveamdmachine::RegType>(value.getType());
    if (!valueType)
      continue;
    changed |= setRegTypeIfUnallocated(
        value, resultType.getRegClass(),
        static_cast<unsigned>(valueType.getWidth()),
        resultType.getIndex() + cast<IntegerAttr>(offset).getInt());
  }
  return changed;
}

inline bool isInternalTupleFromElementsUse(
    OpOperand *use, const llvm::SmallDenseSet<Value, 8> &plannedValues) {
  auto fromElements =
      dyn_cast<waveamdmachine::TupleFromElementsOp>(use->getOwner());
  return fromElements && plannedValues.contains(fromElements.getTuple());
}

inline bool propagateTupleAliasesForValue(Value value) {
  Operation *def = value.getDefiningOp();
  if (!def)
    return false;
  if (auto fromElements = dyn_cast<waveamdmachine::TupleFromElementsOp>(def))
    return propagateTupleAliasTypes(fromElements.getTuple(),
                                    fromElements.getElements());
  if (auto toElements = dyn_cast<waveamdmachine::TupleToElementsOp>(def))
    return propagateTupleAliasTypes(toElements.getTuple(),
                                    toElements.getElements());
  if (auto update = dyn_cast<waveamdmachine::UpdateTupleOp>(def))
    return propagateUpdateTupleAliasTypes(update);
  return false;
}

inline void propagateMemorySpillGroupTupleAliases(IntervalGroup *group,
                                                  const Inventory &inventory) {
  if (!group)
    return;
  SmallVector<Value> values = getMemorySpillGroupValues(group, inventory);
  for ([[maybe_unused]] unsigned iteration :
       llvm::seq<unsigned>(0, values.size() + 1)) {
    bool changed = false;
    for (Value value : values)
      changed |= propagateTupleAliasesForValue(value);
    if (!changed)
      return;
  }
}

inline void assignTupleFromElementsBridgeValues(
    Value value, const wave::WaveAMDPressureReliefTempAssignment &assignment,
    const Inventory &inventory) {
  Operation *def = value.getDefiningOp();
  auto fromElements =
      dyn_cast_or_null<waveamdmachine::TupleFromElementsOp>(def);
  if (!fromElements)
    return;

  unsigned offset = 0;
  for (Value element : fromElements.getElements()) {
    auto elementType = dyn_cast<waveamdmachine::RegType>(element.getType());
    if (!elementType || elementType.getRegClass() != assignment.regClass ||
        !valuesShareIntervalGroup(value, element, inventory))
      return;
    unsigned width = static_cast<unsigned>(elementType.getWidth());
    element.setType(waveamdmachine::RegType::get(value.getContext(),
                                                 assignment.regClass, width,
                                                 assignment.base + offset));
    offset += width;
  }
}

inline void appendMemorySpillPointTemp(
    SmallVectorImpl<wave::WaveAMDPressureReliefTempInterval> &intervals,
    waveamdmachine::RegClass regClass, unsigned position, unsigned width) {
  wave::WaveAMDPressureReliefTempInterval interval;
  interval.regClass = regClass;
  interval.start = position;
  interval.end = position;
  interval.width = width;
  intervals.push_back(interval);
}

inline void appendMemorySpillTemp(
    SmallVectorImpl<wave::WaveAMDPressureReliefTempInterval> &intervals,
    waveamdmachine::RegClass regClass, unsigned start, unsigned end,
    unsigned width) {
  wave::WaveAMDPressureReliefTempInterval interval;
  interval.regClass = regClass;
  interval.start = start;
  interval.end = end;
  interval.width = width;
  intervals.push_back(interval);
}

inline unsigned getTupleFromElementsBridgeStart(Value value,
                                                const Inventory &inventory,
                                                unsigned defPosition) {
  Operation *def = value.getDefiningOp();
  auto fromElements =
      dyn_cast_or_null<waveamdmachine::TupleFromElementsOp>(def);
  if (!fromElements)
    return defPosition;
  unsigned start = defPosition;
  for (Value element : fromElements.getElements()) {
    if (!valuesShareIntervalGroup(value, element, inventory))
      return defPosition;
    start = std::min(start, getMemorySpillValuePosition(element, inventory));
  }
  return start;
}

inline unsigned getMemorySpillUseEnd(OpOperand &use, const Inventory &inventory,
                                     unsigned usePosition);

template <typename CollectAddressTempsFn>
static void collectMemorySpillValueTempIntervals(
    const Inventory &inventory, Value value, waveamdmachine::RegType type,
    SmallVectorImpl<wave::WaveAMDPressureReliefTempInterval> &intervals,
    CollectAddressTempsFn collectAddressTemps) {
  if (!value)
    return;
  SmallVector<OpOperand *> uses;
  (void)collectSimpleMemorySpillVGPRUses(value, inventory, uses);
  unsigned valueWidth = static_cast<unsigned>(type.getWidth());
  unsigned defPosition = getMemorySpillValuePosition(value, inventory);
  unsigned bridgeStart =
      getTupleFromElementsBridgeStart(value, inventory, defPosition);
  appendMemorySpillTemp(intervals, type.getRegClass(), bridgeStart, defPosition,
                        valueWidth);
  collectAddressTemps(intervals, defPosition, valueWidth);

  for (OpOperand *use : uses) {
    std::optional<unsigned> position =
        getMemorySpillOpPosition(use->getOwner(), inventory);
    if (!position)
      continue;
    unsigned usePosition = *position;
    unsigned loadEnd = getMemorySpillUseEnd(*use, inventory, usePosition);
    wave::WaveAMDPressureReliefTempInterval loadTemp;
    loadTemp.regClass = type.getRegClass();
    loadTemp.start = usePosition;
    loadTemp.end = loadEnd;
    loadTemp.width = valueWidth;
    intervals.push_back(loadTemp);
    collectAddressTemps(intervals, usePosition, valueWidth);
  }
  SmallVector<wave::WaveAMDPressureReliefGeneratedUse, 4> generatedUses;
  for (const std::unique_ptr<wave::WaveAMDPressureReliefPlan> &plan :
       inventory.plannedReliefPlans)
    plan->collectGeneratedUses(value, generatedUses);
  for (wave::WaveAMDPressureReliefGeneratedUse use : generatedUses)
    collectMemorySpillLoadTempIntervals(type, use.position, use.position,
                                        intervals, collectAddressTemps);
}

template <typename SlotT, typename CollectAddressTempsFn>
static void collectMemorySpillSlotTempIntervals(
    const Inventory &inventory, const SlotT &slot,
    SmallVectorImpl<wave::WaveAMDPressureReliefTempInterval> &intervals,
    CollectAddressTempsFn collectAddressTemps) {
  collectMemorySpillValueTempIntervals(
      inventory, slot.value, slot.type, intervals,
      [&](SmallVectorImpl<wave::WaveAMDPressureReliefTempInterval> &intervals,
          unsigned position, unsigned valueWidth) {
        collectAddressTemps(intervals, position, slot.plan, valueWidth);
      });
}

inline void collectMemorySpillStoreInputTempIntervals(
    const Inventory &inventory, Value value, unsigned storePosition,
    SmallVectorImpl<wave::WaveAMDPressureReliefTempInterval> &intervals) {
  auto type = dyn_cast<waveamdmachine::RegType>(value.getType());
  if (!type || type.getIndex() >= 0)
    return;
  std::optional<unsigned> valuePosition =
      getMemorySpillValuePositionIfKnown(value, inventory);
  if (!valuePosition)
    return;
  unsigned bridgeStart =
      getTupleFromElementsBridgeStart(value, inventory, *valuePosition);
  appendMemorySpillTemp(intervals, type.getRegClass(),
                        std::min(bridgeStart, storePosition), storePosition,
                        type.getWidth());
}

template <typename CollectAddressTempsFn>
static void collectMemorySpillLoadTempIntervals(
    waveamdmachine::RegType type, unsigned start, unsigned end,
    SmallVectorImpl<wave::WaveAMDPressureReliefTempInterval> &intervals,
    CollectAddressTempsFn collectAddressTemps) {
  unsigned width = type.getWidth();
  if (width == 0)
    return;
  appendMemorySpillTemp(intervals, type.getRegClass(), start,
                        std::max(start, end), width);
  collectAddressTemps(intervals, start, width);
}

inline unsigned getMemorySpillUseEnd(OpOperand &use, const Inventory &inventory,
                                     unsigned usePosition) {
  unsigned end = usePosition;
  Operation *user = use.getOwner();
  if (isCheapVGPRPressureReliefExpr(user) &&
      llvm::any_of(user->getResults(), [&](Value result) {
        return !inventory.intervalFor.lookup(result);
      }))
    if (Interval *interval = inventory.intervalFor.lookup(use.get()))
      end = std::max(end, interval->end);
  if (auto split =
          dyn_cast<waveamdmachine::TupleToElementsOp>(use.getOwner())) {
    for (Value element : split.getElements()) {
      Interval *interval = inventory.intervalFor.lookup(element);
      if (interval)
        end = std::max(end, interval->end);
    }
  }
  return end;
}

inline Operation *getFirstNonTempUseOp(Value value,
                                       const Inventory &inventory) {
  Operation *first = nullptr;
  unsigned firstPosition = 0;
  for (OpOperand &use : value.getUses()) {
    Operation *user = use.getOwner();
    if (isRegAllocTempOp(user))
      continue;
    std::optional<unsigned> position =
        getMemorySpillOpPosition(user, inventory);
    if (!position)
      continue;
    if (!first || *position < firstPosition) {
      first = user;
      firstPosition = *position;
    }
  }
  return first;
}

inline bool isSameSlotLoopBackedgeUse(OpOperand &use,
                                      MemorySpillLoopCarrySlot slot) {
  waveamdmachine::ContinueIfOp term =
      dyn_cast<waveamdmachine::ContinueIfOp>(use.getOwner());
  return term && use.getOperandNumber() == slot.index + 1;
}

template <typename CollectAddressTempsFn>
static void collectLoopCarryExtraInitUseTempIntervals(
    const Inventory &inventory, MemorySpillLoopCarrySlot slot,
    waveamdmachine::RegType type,
    SmallVectorImpl<wave::WaveAMDPressureReliefTempInterval> &intervals,
    CollectAddressTempsFn collectAddressTemps) {
  OpOperand *loopUse = &slot.loop.getInitsMutable()[slot.index];
  Value init = loopUse->get();
  for (OpOperand &use : init.getUses()) {
    if (&use == loopUse || isRegAllocGeneratedOp(use.getOwner()))
      continue;
    std::optional<unsigned> position =
        getMemorySpillOpPosition(use.getOwner(), inventory);
    if (!position)
      continue;
    collectMemorySpillLoadTempIntervals(
        type, *position, getMemorySpillUseEnd(use, inventory, *position),
        intervals, collectAddressTemps);
  }
}

template <typename CollectAddressTempsFn>
static void collectLoopCarryBodyUseTempIntervals(
    const Inventory &inventory, MemorySpillLoopCarrySlot slot,
    waveamdmachine::RegType type,
    SmallVectorImpl<wave::WaveAMDPressureReliefTempInterval> &intervals,
    CollectAddressTempsFn collectAddressTemps) {
  Block &body = slot.loop.getBody().front();
  BlockArgument arg = body.getArgument(slot.index);
  std::optional<unsigned> firstUse;
  std::optional<unsigned> lastUse;
  for (OpOperand &use : arg.getUses()) {
    if (isRegAllocGeneratedOp(use.getOwner()))
      continue;
    if (isSameSlotLoopBackedgeUse(use, slot))
      continue;
    std::optional<unsigned> position =
        getMemorySpillOpPosition(use.getOwner(), inventory);
    if (!position)
      continue;
    firstUse = firstUse ? std::min(*firstUse, *position) : *position;
    unsigned end = getMemorySpillUseEnd(use, inventory, *position);
    lastUse = lastUse ? std::max(*lastUse, end) : end;
  }
  if (!firstUse)
    return;
  collectMemorySpillLoadTempIntervals(type, *firstUse, *lastUse, intervals,
                                      collectAddressTemps);
}

template <typename CollectAddressTempsFn>
static void collectLoopCarryTerminatorStoreTempIntervals(
    const Inventory &inventory, MemorySpillLoopCarrySlot slot,
    waveamdmachine::RegType type,
    SmallVectorImpl<wave::WaveAMDPressureReliefTempInterval> &intervals,
    CollectAddressTempsFn collectAddressTemps) {
  Block &body = slot.loop.getBody().front();
  waveamdmachine::ContinueIfOp term =
      cast<waveamdmachine::ContinueIfOp>(body.getTerminator());
  Value carry = term.getCarries()[slot.index];
  if (carry == body.getArgument(slot.index))
    return;
  std::optional<unsigned> termPosition =
      getMemorySpillOpPosition(term, inventory);
  if (!termPosition)
    return;
  if (!isa<BlockArgument>(carry))
    collectMemorySpillStoreInputTempIntervals(inventory, carry, *termPosition,
                                              intervals);
  collectAddressTemps(intervals, *termPosition, type.getWidth());
}

template <typename CollectAddressTempsFn>
static void collectLoopCarryResultUseTempIntervals(
    const Inventory &inventory, MemorySpillLoopCarrySlot slot,
    waveamdmachine::RegType type,
    SmallVectorImpl<wave::WaveAMDPressureReliefTempInterval> &intervals,
    CollectAddressTempsFn collectAddressTemps) {
  Value result = slot.loop.getResult(slot.index);
  if (result.use_empty())
    return;
  Operation *firstUse = getFirstNonTempUseOp(result, inventory);
  if (!firstUse)
    return;
  std::optional<unsigned> firstUsePosition =
      getMemorySpillOpPosition(firstUse, inventory);
  if (!firstUsePosition)
    return;
  unsigned end = *firstUsePosition;
  for (OpOperand &use : result.getUses()) {
    if (isRegAllocTempOp(use.getOwner()))
      continue;
    std::optional<unsigned> position =
        getMemorySpillOpPosition(use.getOwner(), inventory);
    if (!position)
      continue;
    end = std::max(end, getMemorySpillUseEnd(use, inventory, *position));
  }
  collectMemorySpillLoadTempIntervals(type, *firstUsePosition, end, intervals,
                                      collectAddressTemps);
}

template <typename CollectAddressTempsFn>
static void collectMemorySpillLoopCarryTempIntervals(
    const Inventory &inventory, MemorySpillLoopCarrySlot slot, Value init,
    waveamdmachine::RegType type,
    SmallVectorImpl<wave::WaveAMDPressureReliefTempInterval> &intervals,
    CollectAddressTempsFn collectAddressTemps) {
  if (type.getWidth() == 0)
    return;
  OpOperand *loopUse = &slot.loop.getInitsMutable()[slot.index];
  Operation *initStoreDiag =
      getLoopCarryInitStoreDiagOp(init, loopUse, slot.loop);
  std::optional<unsigned> initStorePosition =
      getMemorySpillOpPosition(initStoreDiag, inventory);
  if (!initStorePosition)
    return;
  collectMemorySpillStoreInputTempIntervals(inventory, init, *initStorePosition,
                                            intervals);
  collectAddressTemps(intervals, *initStorePosition, type.getWidth());
  collectLoopCarryExtraInitUseTempIntervals(inventory, slot, type, intervals,
                                            collectAddressTemps);
  collectLoopCarryBodyUseTempIntervals(inventory, slot, type, intervals,
                                       collectAddressTemps);
  collectLoopCarryTerminatorStoreTempIntervals(inventory, slot, type, intervals,
                                               collectAddressTemps);
  collectLoopCarryResultUseTempIntervals(inventory, slot, type, intervals,
                                         collectAddressTemps);
}

inline SmallVector<Type> getMemorySpillScalarRegTypes(Type tupleType);

inline FailureOr<Value> materializeMemorySpillStoreValue(
    Value value, const wave::WaveAMDPressureReliefPlan &,
    wave::WaveAMDPressureReliefMaterializationContext &, OpBuilder &,
    Operation *) {
  return value;
}

inline FailureOr<Value> materializeMemorySpillStoreInput(
    const Inventory &inventory, Value value, waveamdmachine::RegType type,
    const wave::WaveAMDPressureReliefPlan &reliefPlan,
    wave::WaveAMDPressureReliefMaterializationContext &context,
    OpBuilder &builder, Operation *diagOp) {
  if (type.getIndex() < 0) {
    FailureOr<wave::WaveAMDPressureReliefTempAssignment> assignment =
        context.consumeTempAssignment(reliefPlan, type.getRegClass(),
                                      type.getWidth(), diagOp);
    if (failed(assignment))
      return failure();
    assignValueToTempAssignment(value, *assignment);
    assignTupleFromElementsBridgeValues(value, *assignment, inventory);
  }
  return materializeMemorySpillStoreValue(value, reliefPlan, context, builder,
                                          diagOp);
}

inline void setInsertionPointForMemorySpillStore(Value value,
                                                 OpBuilder &builder) {
  if (Operation *def = value.getDefiningOp()) {
    builder.setInsertionPointAfter(def);
    return;
  }
  BlockArgument arg = cast<BlockArgument>(value);
  builder.setInsertionPointToStart(arg.getOwner());
}

inline LogicalResult
retypeLoadedMemorySpillSplit(waveamdmachine::TupleToElementsOp split,
                             waveamdmachine::RegType loadedType) {
  SmallVector<Type> elementTypes;
  elementTypes.reserve(split.getElements().size());
  unsigned offset = 0;
  for (Value element : split.getElements()) {
    auto elementType = dyn_cast<waveamdmachine::RegType>(element.getType());
    if (!elementType || elementType.getRegClass() != loadedType.getRegClass())
      return split.emitError()
             << "waveamd regalloc cannot replace mismatched split spill";
    unsigned width = static_cast<unsigned>(elementType.getWidth());
    if (offset + width > static_cast<unsigned>(loadedType.getWidth()))
      return split.emitError()
             << "waveamd regalloc cannot replace mismatched split spill";
    int64_t index = -1;
    if (loadedType.getIndex() >= 0)
      index = loadedType.getIndex() + offset;
    elementTypes.push_back(waveamdmachine::RegType::get(
        loadedType.getContext(), loadedType.getRegClass(), width, index));
    offset += width;
  }
  if (offset != static_cast<unsigned>(loadedType.getWidth()))
    return split.emitError()
           << "waveamd regalloc cannot replace mismatched split spill";
  for (auto [element, elementType] :
       llvm::zip(split.getElements(), elementTypes))
    element.setType(elementType);
  return success();
}

inline LogicalResult replaceMemorySpillUseWithLoad(
    Value, OpOperand *use, Value loaded,
    const wave::WaveAMDPressureReliefPlan &,
    wave::WaveAMDPressureReliefMaterializationContext &) {
  if (auto split =
          dyn_cast<waveamdmachine::TupleToElementsOp>(use->getOwner())) {
    waveamdmachine::RegType loadedType =
        cast<waveamdmachine::RegType>(loaded.getType());
    if (failed(retypeLoadedMemorySpillSplit(split, loadedType)))
      return failure();
  }
  use->set(loaded);
  return success();
}

template <typename SlotPlanT, typename StoreSpillValueFn>
static FailureOr<Value> materializeMemorySpillValueStoreToken(
    const Inventory &inventory, Value value, waveamdmachine::RegType valueType,
    const SlotPlanT &slotPlan,
    const wave::WaveAMDPressureReliefPlan &reliefPlan,
    wave::WaveAMDPressureReliefMaterializationContext &context,
    OpBuilder &builder, StringRef providerName,
    StoreSpillValueFn storeSpillValue) {
  Operation *diagOp = getMemorySpillValueDiagOp(value);
  if (!diagOp)
    return mlir::emitError(value.getLoc())
           << "waveamd regalloc cannot materialize " << providerName
           << " for value";
  setInsertionPointForMemorySpillStore(value, builder);
  FailureOr<wave::WaveAMDPressureReliefTempAssignment> valueAssignment =
      context.consumeTempAssignment(reliefPlan, valueType.getRegClass(),
                                    valueType.getWidth(), diagOp);
  if (failed(valueAssignment))
    return failure();
  assignValueToTempAssignment(value, *valueAssignment);
  assignTupleFromElementsBridgeValues(value, *valueAssignment, inventory);
  FailureOr<Value> storeValue = materializeMemorySpillStoreValue(
      value, reliefPlan, context, builder, diagOp);
  if (failed(storeValue))
    return failure();
  Value storeDependency;
  if (Operation *def = value.getDefiningOp())
    storeDependency = getMemoryIssuerToken(def);
  return storeSpillValue(*storeValue, storeDependency, slotPlan, reliefPlan,
                         context, builder, value.getLoc(), diagOp);
}

template <typename SlotPlanT, typename LoadSpillValueFn>
static LogicalResult replaceMemorySpillValueUsesWithLoads(
    Value value, Type loadType, Value storeToken, const SlotPlanT &slotPlan,
    ArrayRef<OpOperand *> uses,
    const wave::WaveAMDPressureReliefPlan &reliefPlan,
    wave::WaveAMDPressureReliefMaterializationContext &context,
    OpBuilder &builder, const llvm::SmallDenseSet<Value, 8> &plannedValues,
    LoadSpillValueFn loadSpillValue) {
  for (OpOperand *use : uses) {
    if (use->get() != value)
      continue;
    if (isInternalTupleFromElementsUse(use, plannedValues))
      continue;
    Operation *user = use->getOwner();
    builder.setInsertionPoint(user);
    FailureOr<MemorySpillLoadResult> load =
        loadSpillValue(loadType, storeToken, slotPlan, reliefPlan, context,
                       builder, user->getLoc(), user);
    if (failed(load))
      return failure();
    if (failed(replaceMemorySpillUseWithLoad(value, use, load->value,
                                             reliefPlan, context)))
      return failure();
  }
  return success();
}

template <typename SlotPlanT, typename StoreSpillValueFn,
          typename LoadSpillValueFn>
static LogicalResult materializeMemorySpillValue(
    const Inventory &inventory, Value value, waveamdmachine::RegType valueType,
    const SlotPlanT &slotPlan,
    const wave::WaveAMDPressureReliefPlan &reliefPlan,
    wave::WaveAMDPressureReliefMaterializationContext &context,
    OpBuilder &builder, StringRef providerName,
    const llvm::SmallDenseSet<Value, 8> &plannedValues,
    StoreSpillValueFn storeSpillValue, LoadSpillValueFn loadSpillValue) {
  SmallVector<OpOperand *> uses;
  if (!collectSimpleMemorySpillVGPRUses(value, inventory, uses)) {
    if (hasOnlyRegAllocTempUses(value))
      return success();
    return mlir::emitError(value.getLoc())
           << "waveamd regalloc cannot materialize " << providerName
           << " for value";
  }

  FailureOr<Value> storeToken = materializeMemorySpillValueStoreToken(
      inventory, value, valueType, slotPlan, reliefPlan, context, builder,
      providerName, storeSpillValue);
  if (failed(storeToken))
    return failure();
  return replaceMemorySpillValueUsesWithLoads(
      value, valueType, *storeToken, slotPlan, uses, reliefPlan, context,
      builder, plannedValues, loadSpillValue);
}

template <typename PlanT, typename MaterializeSlotFn, typename ReserveSlotFn>
static LogicalResult materializeWholeAliasSetMemorySpillPlan(
    const Inventory &inventory, const PlanT &spill, OpBuilder &builder,
    MaterializeSlotFn materializeSlot, ReserveSlotFn reserveSlot) {
  assert(!spill.getValueSlots().empty() && "expected memory spill value slot");
  llvm::SmallDenseSet<Value, 8> plannedValues;
  for (const typename PlanT::Slot &slot : spill.getValueSlots())
    plannedValues.insert(slot.value);
  for (const typename PlanT::Slot &slot : spill.getValueSlots())
    if (failed(materializeSlot(slot, plannedValues)))
      return failure();
  propagateMemorySpillGroupTupleAliases(spill.getGroup(), inventory);
  for (const typename PlanT::Slot &slot : spill.getValueSlots())
    reserveSlot(slot);
  return success();
}

template <typename SpillPlanT, typename GetSlotFn, typename PrepareStoreValueFn,
          typename StoreValueFn, typename LoadValueFn, typename CopyInitFn,
          typename ReserveFn>
struct MemorySpillLoopCarryMaterializer {
  ArrayRef<const SpillPlanT *> input;
  Inventory &inventory;
  OpBuilder &builder;
  StringRef provider;
  GetSlotFn getSlot;
  PrepareStoreValueFn prepareStoreValue;
  StoreValueFn storeValue;
  LoadValueFn loadValue;
  CopyInitFn copyInitValue;
  ReserveFn reservePlan;

  bool isSpilledIndex(ArrayRef<const SpillPlanT *> spills,
                      unsigned index) const {
    return llvm::any_of(spills, [&](const SpillPlanT *spill) {
      return getSlot(*spill).index == index;
    });
  }

  std::optional<unsigned> getSpillOrdinal(ArrayRef<const SpillPlanT *> spills,
                                          unsigned index) const {
    for (auto [ordinal, spill] : llvm::enumerate(spills))
      if (getSlot(*spill).index == index)
        return ordinal;
    return std::nullopt;
  }

  LogicalResult run() const {
    if (failed(materializeCarries()))
      return failure();
    for (const SpillPlanT *spill : input)
      reservePlan(*spill, builder);
    return success();
  }

  LogicalResult materializeCarries() const {
    if (input.empty())
      return success();
    SmallVector<const SpillPlanT *, 4> spills(input.begin(), input.end());
    llvm::stable_sort(spills,
                      [&](const SpillPlanT *lhs, const SpillPlanT *rhs) {
                        return getSlot(*lhs).index < getSlot(*rhs).index;
                      });

    waveamdmachine::UniformLoopOp loop = getSlot(*spills.front()).loop;
    for (const SpillPlanT *spill : spills)
      assert(getSlot(*spill).loop == loop && "expected one loop carry group");

    SmallVector<Value, 4> initTokens;
    if (failed(materializeInitStores(loop, spills, initTokens)))
      return failure();
    for (auto [index, spill] : llvm::enumerate(spills))
      if (failed(rewriteExtraLoopInitUses(*spill, initTokens[index])))
        return failure();

    FailureOr<waveamdmachine::UniformLoopOp> newLoop =
        cloneLoopWithoutCarries(loop, spills, initTokens);
    if (failed(newLoop))
      return failure();
    if (failed(replaceLoopResults(loop, *newLoop, spills)))
      return failure();
    recordLoopCarryRemap(loop, *newLoop, spills);
    loop.erase();
    return success();
  }

  static Value getInitStoreToken(Value init) {
    if (Operation *def = init.getDefiningOp())
      return getMemoryIssuerToken(def);
    return {};
  }

  LogicalResult
  materializeInitStores(waveamdmachine::UniformLoopOp loop,
                        ArrayRef<const SpillPlanT *> spills,
                        SmallVectorImpl<Value> &initTokens) const {
    for (const SpillPlanT *spill : spills) {
      FailureOr<Value> stored = materializeInitStore(loop, *spill);
      if (failed(stored))
        return failure();
      initTokens.push_back(*stored);
    }
    return success();
  }

  FailureOr<Value> materializeInitStore(waveamdmachine::UniformLoopOp loop,
                                        const SpillPlanT &spill) const {
    MemorySpillLoopCarrySlot slot = getSlot(spill);
    Value init = loop.getInits()[slot.index];
    OpOperand *loopUse = &loop.getInitsMutable()[slot.index];
    setInsertionPointForInitStore(init, loopUse, loop);
    Operation *diagOp = getLoopCarryInitStoreDiagOp(init, loopUse, loop);
    FailureOr<Value> storeInput =
        prepareStoreValue(init, spill, builder, diagOp);
    if (failed(storeInput))
      return failure();
    return storeValue(*storeInput, getInitStoreToken(init), spill, builder,
                      loop.getLoc(), diagOp);
  }

  void setInsertionPointForInitStore(Value init, OpOperand *loopUse,
                                     waveamdmachine::UniformLoopOp loop) const {
    Operation *def = init.getDefiningOp();
    Operation *firstPreheaderUse =
        getLoopCarryFirstPreheaderUse(init, loopUse, loop);
    if (firstPreheaderUse && (!def || def->getBlock() != loop->getBlock() ||
                              def->isBeforeInBlock(firstPreheaderUse))) {
      builder.setInsertionPoint(firstPreheaderUse);
      return;
    }
    if (!def || def->getBlock() != loop->getBlock() ||
        !def->isBeforeInBlock(loop)) {
      builder.setInsertionPoint(loop);
      return;
    }
    builder.setInsertionPointAfter(def);
  }

  LogicalResult rewriteExtraLoopInitUses(const SpillPlanT &spill,
                                         Value initToken) const {
    MemorySpillLoopCarrySlot slot = getSlot(spill);
    waveamdmachine::UniformLoopOp loop = slot.loop;
    OpOperand *loopUse = &loop.getInitsMutable()[slot.index];
    Value init = loopUse->get();
    SmallVector<OpOperand *> uses;
    for (OpOperand &use : init.getUses()) {
      if (&use == loopUse || isRegAllocGeneratedOp(use.getOwner()))
        continue;
      uses.push_back(&use);
    }

    for (OpOperand *use : uses) {
      Operation *user = use->getOwner();
      if (!canRewriteExtraLoopInitUse(*use, loopUse, loop))
        return mlir::emitError(init.getLoc())
               << "waveamd regalloc cannot materialize " << provider
               << " spill for loop init use outside loop preheader";
      builder.setInsertionPoint(user);
      FailureOr<MemorySpillLoadResult> load =
          copyInitValue(init, initToken, spill, builder, user->getLoc(), user);
      if (failed(load))
        return failure();
      use->set(load->value);
    }
    return success();
  }

  void recordLoopCarryRemap(waveamdmachine::UniformLoopOp oldLoop,
                            waveamdmachine::UniformLoopOp newLoop,
                            ArrayRef<const SpillPlanT *> spills) const {
    LoopCarryLoopRemap remap;
    remap.indexMap.resize(oldLoop.getInits().size(), -1);
    unsigned newIndex = 0;
    for (unsigned index : llvm::seq<unsigned>(0, oldLoop.getInits().size())) {
      if (isSpilledIndex(spills, index))
        continue;
      remap.indexMap[index] = newIndex++;
    }
    remap.loop = newLoop.getOperation();
    inventory.loopCarryRemaps[oldLoop.getOperation()] = std::move(remap);
  }

  FailureOr<waveamdmachine::UniformLoopOp>
  cloneLoopWithoutCarries(waveamdmachine::UniformLoopOp loop,
                          ArrayRef<const SpillPlanT *> spills,
                          ArrayRef<Value> initTokens) const {
    Type tokenType = waveamdmachine::MemTokenType::get(builder.getContext());
    SmallVector<Type> resultTypes;
    SmallVector<Value> inits;
    for (unsigned index : llvm::seq<unsigned>(0, loop.getInits().size())) {
      if (isSpilledIndex(spills, index))
        continue;
      resultTypes.push_back(loop.getResult(index).getType());
      inits.push_back(loop.getInits()[index]);
    }
    for (Value initToken : initTokens) {
      resultTypes.push_back(tokenType);
      inits.push_back(initToken);
    }

    builder.setInsertionPoint(loop);
    waveamdmachine::UniformLoopOp newLoop =
        waveamdmachine::UniformLoopOp::create(
            builder, loop.getLoc(), resultTypes, loop.getEntryCond(), inits);
    if (failed(cloneLoopBody(loop, newLoop, spills))) {
      newLoop.erase();
      return failure();
    }
    return newLoop;
  }

  LogicalResult cloneLoopBody(waveamdmachine::UniformLoopOp oldLoop,
                              waveamdmachine::UniformLoopOp newLoop,
                              ArrayRef<const SpillPlanT *> spills) const {
    Block &oldBody = oldLoop.getBody().front();
    Block *newBody = new Block;
    newLoop.getBody().push_back(newBody);
    for (Value init : newLoop.getInits())
      newBody->addArgument(init.getType(), oldLoop.getLoc());

    IRMapping mapper;
    unsigned newArgIndex = 0;
    for (unsigned index : llvm::seq<unsigned>(0, oldLoop.getInits().size())) {
      if (isSpilledIndex(spills, index))
        continue;
      mapper.map(oldBody.getArgument(index),
                 newBody->getArgument(newArgIndex++));
    }
    SmallVector<Value, 4> tokens;
    for ([[maybe_unused]] const SpillPlanT *spill : spills)
      tokens.push_back(newBody->getArgument(newArgIndex++));
    return cloneLoopBodyOps(oldLoop, newBody, spills, tokens, mapper);
  }

  LogicalResult cloneLoopBodyOps(waveamdmachine::UniformLoopOp oldLoop,
                                 Block *newBody,
                                 ArrayRef<const SpillPlanT *> spills,
                                 SmallVectorImpl<Value> &tokens,
                                 IRMapping &mapper) const {
    Block &oldBody = oldLoop.getBody().front();
    builder.setInsertionPointToEnd(newBody);
    for (Operation &op : oldBody.without_terminator()) {
      for (const SpillPlanT *spill : spills) {
        BlockArgument oldArg = oldBody.getArgument(getSlot(*spill).index);
        if (!opUsesValue(&op, oldArg))
          continue;
        FailureOr<Value> mapped = getMappedValue(
            oldLoop, oldArg, spills, tokens, mapper, op.getLoc(), &op);
        if (failed(mapped))
          return failure();
      }
      builder.clone(op, mapper);
    }
    return cloneLoopTerminator(oldLoop, spills, tokens, mapper);
  }

  static bool opUsesValue(Operation *op, Value value) {
    bool found = false;
    op->walk([&](Operation *nested) {
      if (found)
        return WalkResult::interrupt();
      if (llvm::any_of(nested->getOperands(),
                       [&](Value operand) { return operand == value; })) {
        found = true;
        return WalkResult::interrupt();
      }
      return WalkResult::advance();
    });
    return found;
  }

  std::optional<unsigned>
  getSpillOrdinalForValue(waveamdmachine::UniformLoopOp loop, Value value,
                          ArrayRef<const SpillPlanT *> spills) const {
    BlockArgument arg = dyn_cast<BlockArgument>(value);
    if (!arg || arg.getOwner() != &loop.getBody().front())
      return std::nullopt;
    return getSpillOrdinal(spills, arg.getArgNumber());
  }

  FailureOr<Value> getMappedValue(waveamdmachine::UniformLoopOp loop,
                                  Value value,
                                  ArrayRef<const SpillPlanT *> spills,
                                  SmallVectorImpl<Value> &tokens,
                                  IRMapping &mapper, Location loc,
                                  Operation *diagOp) const {
    if (Value mapped = mapper.lookupOrNull(value))
      return mapped;
    std::optional<unsigned> ordinal =
        getSpillOrdinalForValue(loop, value, spills);
    if (!ordinal)
      return mapper.lookupOrDefault(value);
    const SpillPlanT &spill = *spills[*ordinal];
    Type loadType = spill.getValueSlots().front().type;
    FailureOr<MemorySpillLoadResult> load =
        loadValue(loadType, tokens[*ordinal], spill, builder, loc, diagOp);
    if (failed(load))
      return failure();
    tokens[*ordinal] = load->token;
    mapper.map(value, load->value);
    return load->value;
  }

  bool needsTerminatorPreload(waveamdmachine::UniformLoopOp loop,
                              unsigned carryIndex, Value carry,
                              ArrayRef<const SpillPlanT *> spills) const {
    std::optional<unsigned> source =
        getSpillOrdinalForValue(loop, carry, spills);
    if (!source)
      return false;
    std::optional<unsigned> dest = getSpillOrdinal(spills, carryIndex);
    if (!dest || *dest != *source)
      return true;
    BlockArgument arg = cast<BlockArgument>(carry);
    return arg.getArgNumber() != carryIndex;
  }

  LogicalResult cloneLoopTerminator(waveamdmachine::UniformLoopOp loop,
                                    ArrayRef<const SpillPlanT *> spills,
                                    SmallVectorImpl<Value> &tokens,
                                    IRMapping &mapper) const {
    waveamdmachine::ContinueIfOp oldTerm = cast<waveamdmachine::ContinueIfOp>(
        loop.getBody().front().getTerminator());
    if (failed(preloadTerminatorCarries(loop, oldTerm, spills, tokens, mapper)))
      return failure();

    SmallVector<Value> carries;
    for (unsigned index : llvm::seq<unsigned>(0, oldTerm.getCarries().size())) {
      if (failed(appendTerminatorCarry(loop, oldTerm, index, spills, tokens,
                                       mapper, carries)))
        return failure();
    }
    carries.append(tokens.begin(), tokens.end());
    waveamdmachine::ContinueIfOp::create(
        builder, oldTerm.getLoc(), mapper.lookupOrDefault(oldTerm.getCond()),
        carries);
    return success();
  }

  LogicalResult preloadTerminatorCarries(waveamdmachine::UniformLoopOp loop,
                                         waveamdmachine::ContinueIfOp oldTerm,
                                         ArrayRef<const SpillPlanT *> spills,
                                         SmallVectorImpl<Value> &tokens,
                                         IRMapping &mapper) const {
    for (auto [index, carry] : llvm::enumerate(oldTerm.getCarries())) {
      if (!needsTerminatorPreload(loop, index, carry, spills))
        continue;
      FailureOr<Value> mapped =
          getMappedValue(loop, carry, spills, tokens, mapper, oldTerm.getLoc(),
                         oldTerm.getOperation());
      if (failed(mapped))
        return failure();
    }
    return success();
  }

  LogicalResult appendTerminatorCarry(waveamdmachine::UniformLoopOp loop,
                                      waveamdmachine::ContinueIfOp oldTerm,
                                      unsigned index,
                                      ArrayRef<const SpillPlanT *> spills,
                                      SmallVectorImpl<Value> &tokens,
                                      IRMapping &mapper,
                                      SmallVectorImpl<Value> &carries) const {
    Value carry = oldTerm.getCarries()[index];
    std::optional<unsigned> spillIndex = getSpillOrdinal(spills, index);
    if (spillIndex)
      return storeTerminatorCarry(loop, oldTerm, carry, *spillIndex, spills,
                                  tokens, mapper);
    FailureOr<Value> mapped =
        getMappedValue(loop, carry, spills, tokens, mapper, oldTerm.getLoc(),
                       oldTerm.getOperation());
    if (failed(mapped))
      return failure();
    carries.push_back(*mapped);
    return success();
  }

  LogicalResult storeTerminatorCarry(waveamdmachine::UniformLoopOp loop,
                                     waveamdmachine::ContinueIfOp oldTerm,
                                     Value carry, unsigned spillIndex,
                                     ArrayRef<const SpillPlanT *> spills,
                                     SmallVectorImpl<Value> &tokens,
                                     IRMapping &mapper) const {
    const SpillPlanT &spill = *spills[spillIndex];
    BlockArgument oldArg =
        loop.getBody().front().getArgument(getSlot(spill).index);
    if (carry == oldArg)
      return success();
    FailureOr<Value> mapped =
        getMappedValue(loop, carry, spills, tokens, mapper, oldTerm.getLoc(),
                       oldTerm.getOperation());
    if (failed(mapped))
      return failure();
    FailureOr<Value> storeInput =
        prepareStoreValue(*mapped, spill, builder, oldTerm.getOperation());
    if (failed(storeInput))
      return failure();
    FailureOr<Value> stored =
        storeValue(*storeInput, tokens[spillIndex], spill, builder,
                   oldTerm.getLoc(), oldTerm.getOperation());
    if (failed(stored))
      return failure();
    tokens[spillIndex] = *stored;
    return success();
  }

  LogicalResult replaceLoopResults(waveamdmachine::UniformLoopOp oldLoop,
                                   waveamdmachine::UniformLoopOp newLoop,
                                   ArrayRef<const SpillPlanT *> spills) const {
    builder.setInsertionPointAfter(newLoop);
    unsigned newResultIndex = 0;
    for (unsigned index : llvm::seq<unsigned>(0, oldLoop.getResults().size())) {
      if (isSpilledIndex(spills, index))
        continue;
      oldLoop.getResult(index).replaceAllUsesWith(
          newLoop.getResult(newResultIndex++));
    }
    for (const SpillPlanT *spill : spills) {
      Value token = newLoop.getResult(newResultIndex++);
      unsigned oldIndex = getSlot(*spill).index;
      if (oldLoop.getResult(oldIndex).use_empty())
        continue;
      Operation *diagOp =
          getFirstNonTempUseOp(oldLoop.getResult(oldIndex), inventory);
      if (!diagOp)
        diagOp = oldLoop.getOperation();
      Type loadType = spill->getValueSlots().front().type;
      FailureOr<MemorySpillLoadResult> load =
          loadValue(loadType, token, *spill, builder, oldLoop.getLoc(), diagOp);
      if (failed(load))
        return failure();
      oldLoop.getResult(oldIndex).replaceAllUsesWith(load->value);
    }
    return success();
  }
};

template <typename SpillPlanT, typename GetSlotFn, typename PrepareStoreValueFn,
          typename StoreValueFn, typename LoadValueFn, typename CopyInitFn,
          typename ReserveFn>
LogicalResult materializeMemorySpillLoopCarryPlans(
    ArrayRef<const SpillPlanT *> input, Inventory &inventory,
    OpBuilder &builder, StringRef provider, GetSlotFn getSlot,
    PrepareStoreValueFn prepareStoreValue, StoreValueFn storeValue,
    LoadValueFn loadValue, CopyInitFn copyInitValue, ReserveFn reservePlan) {
  return MemorySpillLoopCarryMaterializer<SpillPlanT, GetSlotFn,
                                          PrepareStoreValueFn, StoreValueFn,
                                          LoadValueFn, CopyInitFn, ReserveFn>{
      input,         inventory,         builder,    provider,
      getSlot,       prepareStoreValue, storeValue, loadValue,
      copyInitValue, reservePlan}
      .run();
}

inline SmallVector<Type> getMemorySpillScalarRegTypes(Type tupleType) {
  waveamdmachine::RegType regType = cast<waveamdmachine::RegType>(tupleType);
  SmallVector<Type> types;
  types.reserve(regType.getWidth());
  for (unsigned lane : llvm::seq<unsigned>(0, regType.getWidth())) {
    int64_t index = -1;
    if (regType.getIndex() >= 0)
      index = regType.getIndex() + lane;
    types.push_back(waveamdmachine::RegType::get(
        tupleType.getContext(), regType.getRegClass(), /*width=*/1, index));
  }
  return types;
}

inline SmallVector<Value> splitMemorySpillValue(Value value, OpBuilder &builder,
                                                Location loc) {
  SmallVector<Type> elementTypes =
      getMemorySpillScalarRegTypes(value.getType());
  waveamdmachine::TupleToElementsOp split =
      waveamdmachine::TupleToElementsOp::create(builder, loc, elementTypes,
                                                value);
  split->setAttr(kRegAllocTempAttr, builder.getUnitAttr());
  return SmallVector<Value>(split.getElements().begin(),
                            split.getElements().end());
}

inline Value joinMemorySpillValue(Type type, ArrayRef<Value> elements,
                                  OpBuilder &builder, Location loc) {
  waveamdmachine::TupleFromElementsOp joined =
      waveamdmachine::TupleFromElementsOp::create(builder, loc, type, elements);
  joined->setAttr(kRegAllocTempAttr, builder.getUnitAttr());
  return joined.getTuple();
}

inline Value joinMemorySpillTokens(Type tokenType, ArrayRef<Value> tokens,
                                   OpBuilder &builder, Location loc) {
  if (tokens.size() == 1)
    return tokens.front();
  waveamdmachine::TokenJoinOp join =
      waveamdmachine::TokenJoinOp::create(builder, loc, tokenType, tokens);
  join->setAttr(kRegAllocTempAttr, builder.getUnitAttr());
  return join.getResult();
}

inline bool isMemorySpillSuppressedVGPRExpr(Operation *op) {
  return isa_and_nonnull<
      waveamdmachine::VWorkitemIdXOp, waveamdmachine::VMovB32TupleOp,
      waveamdmachine::CopyTupleOp, waveamdmachine::UpdateTupleOp,
      waveamdmachine::VLshrrevB32Op, waveamdmachine::VLshlrevB32Op,
      waveamdmachine::VLshlAddU32Op, waveamdmachine::VAddU32Op,
      waveamdmachine::VAdd3U32Op, waveamdmachine::VAndB32Op,
      waveamdmachine::VMulLoU32Op, waveamdmachine::VAddLshlU32Op,
      waveamdmachine::VXorB32Op, waveamdmachine::VAndOrB32Op,
      waveamdmachine::VBitOp3B32Op, waveamdmachine::VCndmaskB32TupleOp,
      waveamdmachine::VCndmaskB32VccOp, waveamdmachine::VAccvgprReadB32TupleOp,
      waveamdmachine::VAccvgprWriteB32TupleOp>(op);
}

inline bool isCheapVGPRPressureReliefExpr(Operation *op) {
  return isCheapVGPRPressureReliefRootExpr(op) ||
         isa_and_nonnull<waveamdmachine::TupleFromElementsOp>(op);
}

inline bool isCheapVGPRPressureReliefRootExpr(Operation *op) {
  return isMemorySpillSuppressedVGPRExpr(op) ||
         isa_and_nonnull<waveamdmachine::VMulU64Op, waveamdmachine::VAddU64Op>(
             op);
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

inline bool memorySpillLaneLiveAt(Interval *interval, unsigned position) {
  return !interval->values.empty() && interval->start <= position &&
         position <= interval->end;
}

inline bool isMemorySpillProviderRegClass(waveamdmachine::RegClass regClass) {
  return regClass == waveamdmachine::RegClass::VGPR;
}

inline bool isMemorySpillProviderCandidateGroup(IntervalGroup *group,
                                                unsigned position) {
  if (!group || group->plannedPressureRelief || group->reserved ||
      isFixedRegisterGroup(group))
    return false;
  if (!isMemorySpillProviderRegClass(group->storageClass))
    return false;
  return llvm::any_of(group->intervals, [&](Interval *lane) {
    return memorySpillLaneLiveAt(lane, position);
  });
}

inline bool isMemorySpillProviderEligibleGroup(IntervalGroup *group,
                                               unsigned position) {
  if (!isMemorySpillProviderCandidateGroup(group, position))
    return false;
  if (!group->nonPromotable &&
      llvm::all_of(group->intervals,
                   [](Interval *lane) { return !lane->nonPromotable; }))
    return true;
  return false;
}

inline bool isMemorySpillEligibleGroup(IntervalGroup *group,
                                       unsigned position) {
  return isMemorySpillVGPRGroup(group) &&
         hasLiveMemorySpillLane(group, position);
}

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
  bool combinedPlacementVGPRLimit = false;
};

enum class LDSSpillPlanStatus : uint8_t {
  Available,
  NotKernel,
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

struct LDSSpillPlanningInfo {
  uint64_t limitBytes = 0;
  unsigned localMemorySize = 0;
  unsigned addressableLocalMemorySize = 0;
  unsigned wavefrontSize = 0;
  unsigned eusPerCU = 0;
  unsigned wavesPerWorkgroup = 0;
  LDSSpillPlanStatus status = LDSSpillPlanStatus::InsufficientLDS;
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

StringRef getLDSSpillPlanStatusName(LDSSpillPlanStatus status);
void getExistingLDSBytes(func::FuncOp func, unsigned &fixedBytes,
                         unsigned &dynamicBytes, unsigned reservedSpillBytes);
LDSSpillPlanningInfo getLDSSpillPlanningInfo(func::FuncOp func,
                                             RegisterBudgets budgets);
LDSSpillPlan planLDSSpillSlot(const LDSSpillPlanningInfo &planning,
                              unsigned valueBytes, unsigned reservedSpillBytes,
                              unsigned fixedLDS, unsigned dynamicLDS);
LDSSpillPlan planLDSSpillSlot(func::FuncOp func, RegisterBudgets budgets,
                              unsigned valueBytes,
                              unsigned reservedSpillBytes = 0);
LDSSpillPlan planLDSSpillSlot(func::FuncOp func, RegisterBudgets budgets,
                              unsigned valueBytes, unsigned reservedSpillBytes,
                              unsigned fixedLDS, unsigned dynamicLDS);
StringRef getScratchSpillPlanStatusName(ScratchSpillPlanStatus status);
unsigned getExistingPrivateSegmentBytes(func::FuncOp func,
                                        unsigned reservedSpillBytes);
ScratchSpillPlan planScratchSpillSlot(func::FuncOp func, unsigned valueBytes,
                                      unsigned reservedSpillBytes = 0);
ScratchSpillPlan planScratchSpillSlot(func::FuncOp func, unsigned valueBytes,
                                      unsigned reservedSpillBytes,
                                      unsigned existingPrivateBytes);

} // namespace mlir::wave::regalloc

#endif // MLIR_DIALECT_WAVE_TRANSFORMS_WAVEAMDREGALLOCINTERNAL_H
