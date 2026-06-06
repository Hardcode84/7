//===- WaveAMDRegAlloc.cpp - WaveAMD register allocation -*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/Wave/Transforms/Passes.h"

#include "WaveAMDHardwareResources.h"
#include "WaveAMDRegAllocPrep.h"
#include "WaveAMDRegLiveIntervals.h"
#include "WaveAMDRegisterLimits.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/Wave/Transforms/WaveAMDRegAllocVerification.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachine.h"
#include "mlir/IR/Builders.h"
#include "mlir/IR/BuiltinOps.h"
#include "llvm/ADT/BitVector.h"
#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/DenseSet.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/Support/MathExtras.h"
#include "llvm/Support/raw_ostream.h"
#include <algorithm>
#include <cstdint>
#include <limits>
#include <optional>
#include <string>

namespace mlir::wave {
#define GEN_PASS_DEF_WAVEAMDREGALLOC
#include "mlir/Dialect/Wave/Transforms/Passes.h.inc"
} // namespace mlir::wave

using namespace mlir;

namespace {

static constexpr llvm::StringLiteral kPassName = "waveamd-reg-alloc";
static constexpr llvm::StringLiteral kPressureClassAttr =
    "waveamdmachine.regalloc_pressure_class";
static constexpr llvm::StringLiteral kPressureLimitAttr =
    "waveamdmachine.regalloc_pressure_limit";
static constexpr llvm::StringLiteral kPressureLiveDwordsAttr =
    "waveamdmachine.regalloc_pressure_live_dwords";
static constexpr llvm::StringLiteral kPressureOverlapsAttr =
    "waveamdmachine.regalloc_pressure_overlaps";
static constexpr llvm::StringLiteral kPressurePositionAttr =
    "waveamdmachine.regalloc_pressure_position";
static constexpr llvm::StringLiteral kPressureReliefAttr =
    "waveamdmachine.regalloc_pressure_required_relief";
static constexpr llvm::StringLiteral kPressureRequestAttr =
    "waveamdmachine.regalloc_pressure_request";
static constexpr llvm::StringLiteral kPressureReservedAttr =
    "waveamdmachine.regalloc_pressure_reserved";
static constexpr llvm::StringLiteral kAGPRCandidatesAttr =
    "waveamdmachine.regalloc_agpr_candidates";
static constexpr llvm::StringLiteral kTargetWavesAttr =
    "waveamdmachine.target_waves";

struct RegisterLimits {
  SmallVector<unsigned, 32> maxSGPRsForWaves;
  SmallVector<unsigned, 32> maxVGPRsForWaves;
  std::optional<unsigned> totalVGPRLimit;
  unsigned addressableSGPR = 0;
  unsigned addressableVGPR = 0;
  unsigned addressableAGPR = 0;
  unsigned numSGPR = 0;
  unsigned numVGPR = 0;
  unsigned numAGPR = 0;
  unsigned maxWavesPerEU = 0;
  unsigned targetWaves = 0;
  bool agprCountsAgainstVGPRs = false;
};

struct AllocatedRegisterCounts {
  unsigned sgpr = 0;
  unsigned vgpr = 0;
  unsigned agpr = 0;
};

struct PressureIntervalRef {
  SmallVector<int64_t> resultIndices;
  SmallVector<int64_t> slotOffsets;
  SmallVector<int64_t> valuePositions;
  unsigned start = 0;
  unsigned end = 0;
  unsigned width = 0;
};

struct AGPRConversionCandidate {
  SmallVector<PressureIntervalRef, 2> intervals;
  SmallVector<Value, 4> values;
  unsigned agprDwords = 0;
  unsigned bridgeCount = 0;
  unsigned overlapDwords = 0;
  unsigned order = 0;
  unsigned reliefDwords = 0;
  bool mfmaAccumulator = false;
};

struct RegisterPressurePoint {
  SmallVector<AGPRConversionCandidate, 4> agprCandidates;
  SmallVector<PressureIntervalRef> overlaps;
  PressureIntervalRef request;
  StringRef regClass;
  unsigned limit = 0;
  unsigned liveDwords = 0;
  unsigned position = 0;
  unsigned requiredRelief = 0;
  unsigned reserved = 0;
};

struct StorageGroup {
  SmallVector<Value> values;
  SmallVector<unsigned> slotOffsets;
  SmallVector<unsigned> valueStarts;
  SmallVector<unsigned> valueEnds;
  SmallVector<unsigned> valueWidths;
  SmallVector<llvm::BitVector> slotLive;
  waveamdmachine::RegClass regClass;
  std::optional<unsigned> assignedBase;
  std::optional<unsigned> fixedBase;
  unsigned start = std::numeric_limits<unsigned>::max();
  unsigned end = 0;
  unsigned width = 0;
  unsigned order = 0;
  bool hasVirtual = false;
};

struct ClassProblem {
  SmallVector<StorageGroup, 0> groups;
  waveamdmachine::RegClass regClass;
  StringRef name;
  unsigned budget = 0;
  unsigned addressable = 0;
  unsigned reserved = 0;
};

struct RegAllocProblem {
  ClassProblem sgprs;
  ClassProblem vgprs;
  ClassProblem agprs;
  unsigned positionCount = 1;
};

static bool isAllocatedClass(waveamdmachine::RegClass regClass) {
  return regClass == waveamdmachine::RegClass::SGPR ||
         regClass == waveamdmachine::RegClass::VGPR ||
         regClass == waveamdmachine::RegClass::AGPR;
}

static StringRef getRegClassName(waveamdmachine::RegClass regClass) {
  if (regClass == waveamdmachine::RegClass::SGPR)
    return "SGPR";
  if (regClass == waveamdmachine::RegClass::VGPR)
    return "VGPR";
  if (regClass == waveamdmachine::RegClass::AGPR)
    return "AGPR";
  return "unsupported";
}

static unsigned getClassAddressable(const RegisterLimits &limits,
                                    waveamdmachine::RegClass regClass) {
  if (regClass == waveamdmachine::RegClass::SGPR)
    return limits.addressableSGPR;
  if (regClass == waveamdmachine::RegClass::VGPR)
    return limits.addressableVGPR;
  if (regClass == waveamdmachine::RegClass::AGPR)
    return limits.addressableAGPR;
  return 0;
}

static unsigned getClassBudget(const RegisterLimits &limits,
                               waveamdmachine::RegClass regClass) {
  if (regClass == waveamdmachine::RegClass::SGPR)
    return limits.numSGPR;
  if (regClass == waveamdmachine::RegClass::VGPR)
    return limits.numVGPR;
  if (regClass == waveamdmachine::RegClass::AGPR)
    return limits.numAGPR;
  return 0;
}

static void setRegPhys(Value value, unsigned phys) {
  waveamdmachine::RegType type = cast<waveamdmachine::RegType>(value.getType());
  value.setType(waveamdmachine::RegType::get(
      type.getContext(), type.getRegClass(), type.getWidth(),
      static_cast<int64_t>(phys)));
}

static waveamdmachine::RegType
getVirtualRegType(Value value, waveamdmachine::RegClass regClass) {
  waveamdmachine::RegType type = cast<waveamdmachine::RegType>(value.getType());
  return waveamdmachine::RegType::get(type.getContext(), regClass,
                                      type.getWidth(), /*index=*/-1);
}

static void setRegClass(Value value, waveamdmachine::RegClass regClass) {
  value.setType(getVirtualRegType(value, regClass));
}

static bool isVirtualVGPRValue(Value value) {
  auto type = dyn_cast<waveamdmachine::RegType>(value.getType());
  return type && type.getRegClass() == waveamdmachine::RegClass::VGPR &&
         type.getIndex() < 0;
}

static unsigned countVirtualVGPRValues(Operation *op) {
  unsigned count = 0;
  for (Value result : op->getResults())
    if (isVirtualVGPRValue(result))
      ++count;
  for (Region &region : op->getRegions()) {
    for (Block &block : region) {
      for (BlockArgument arg : block.getArguments())
        if (isVirtualVGPRValue(arg))
          ++count;
      for (Operation &nested : block)
        count += countVirtualVGPRValues(&nested);
    }
  }
  return count;
}

static unsigned alignUp(unsigned value, unsigned granule) {
  return ((value + granule - 1) / granule) * granule;
}

static unsigned alignDown(unsigned value, unsigned granule) {
  return (value / granule) * granule;
}

static Operation *diagOpForValue(Value value, func::FuncOp func) {
  if (Operation *def = value.getDefiningOp())
    return def;
  if (auto arg = dyn_cast<BlockArgument>(value))
    if (Operation *parent = arg.getOwner()->getParentOp())
      return parent;
  return func;
}

static Attribute findTargetWavesAttr(Operation *op) {
  for (Operation *cur = op; cur; cur = cur->getParentOp())
    if (Attribute attr = cur->getAttr(kTargetWavesAttr))
      return attr;
  return {};
}

static FailureOr<unsigned> getTargetWaves(func::FuncOp func,
                                          const RegisterLimits &limits) {
  Attribute attr = findTargetWavesAttr(func);
  if (!attr)
    return 0;
  auto intAttr = dyn_cast<IntegerAttr>(attr);
  if (!intAttr)
    return func.emitError(kPassName)
           << " " << kTargetWavesAttr << " must be an integer attribute";
  int64_t value = intAttr.getInt();
  if (value <= 0)
    return func.emitError(kPassName)
           << " " << kTargetWavesAttr << " must be positive";
  if (static_cast<uint64_t>(value) > limits.maxWavesPerEU)
    return func.emitError(kPassName)
           << " " << kTargetWavesAttr << " exceeds target wave capacity";
  return static_cast<unsigned>(value);
}

static FailureOr<RegisterLimits> getRegisterLimits(ModuleOp module) {
  if (!module->hasAttr("waveamdmachine.target"))
    return module.emitError(kPassName)
           << " requires a waveamdmachine.target attribute";
  FailureOr<wave::WaveAMDRegisterLimits> targetLimits =
      wave::getWaveAMDRegisterLimits(module);
  if (failed(targetLimits))
    return failure();

  RegisterLimits limits;
  limits.addressableSGPR = targetLimits->addressableSGPRs;
  limits.addressableVGPR = targetLimits->addressableVGPRs;
  limits.addressableAGPR = targetLimits->addressableAGPRs;
  limits.numSGPR = targetLimits->addressableSGPRs;
  limits.numVGPR = targetLimits->addressableVGPRs;
  limits.numAGPR = targetLimits->addressableAGPRs;
  limits.maxWavesPerEU = targetLimits->maxWavesPerEU;
  limits.maxSGPRsForWaves = targetLimits->maxSGPRsForWaves;
  limits.maxVGPRsForWaves = targetLimits->maxVGPRsForWaves;
  limits.agprCountsAgainstVGPRs = targetLimits->agprCountsAgainstVGPRs;
  return limits;
}

static LogicalResult applyTargetWavesLimits(func::FuncOp func,
                                            RegisterLimits &limits) {
  FailureOr<unsigned> targetWaves = getTargetWaves(func, limits);
  if (failed(targetWaves))
    return failure();
  if (*targetWaves == 0)
    return success();

  unsigned vgprBudget = wave::getMaxWaveAMDRegisterBudgetForWaves(
      limits.maxVGPRsForWaves, *targetWaves);
  unsigned sgprBudget = wave::getMaxWaveAMDRegisterBudgetForWaves(
      limits.maxSGPRsForWaves, *targetWaves);
  if (vgprBudget == 0 || sgprBudget == 0)
    return func.emitError(kPassName)
           << " " << kTargetWavesAttr
           << " has no register budget for this target";

  limits.totalVGPRLimit = vgprBudget;
  limits.numVGPR = std::min(limits.numVGPR, vgprBudget);
  limits.numSGPR = std::min(limits.numSGPR, sgprBudget);
  limits.targetWaves = *targetWaves;
  return success();
}

static LogicalResult validateReservedLimit(func::FuncOp func, StringRef cls,
                                           unsigned numPhys,
                                           unsigned reserved) {
  if (numPhys >= reserved)
    return success();
  return func.emitError()
         << kPassName << " " << cls
         << " limit leaves fewer registers than reserved kernel ABI prefix "
         << "(available=" << numPhys << ", reserved=" << reserved << ")";
}

static LogicalResult validateReservedLimits(func::FuncOp func,
                                            const RegisterLimits &limits,
                                            unsigned sgprReserved,
                                            unsigned vgprReserved) {
  if (failed(validateReservedLimit(func, "SGPR", limits.numSGPR, sgprReserved)))
    return failure();
  return validateReservedLimit(func, "VGPR", limits.numVGPR, vgprReserved);
}

static bool
isAllowedKernargPreloadValue(unsigned index, unsigned width,
                             const wave::WaveAMDKernelEntryRegs &regs) {
  unsigned begin = index;
  unsigned end = begin + width;
  unsigned preloadBegin = regs.kernargSegmentPtrWidth;
  unsigned preloadEnd = preloadBegin + regs.kernargPreloadDwords;
  return preloadBegin <= begin && end <= preloadEnd;
}

static bool isAllowedEntryRegValue(Operation *def, unsigned index,
                                   unsigned width,
                                   const wave::WaveAMDKernelEntryRegs &regs) {
  if (width != 1)
    return false;
  if (isa<waveamdmachine::VWorkitemIdXOp>(def))
    return index == regs.workitemIdXVGPR;
  if (isa<waveamdmachine::SWorkgroupIdXOp>(def))
    return index == regs.workgroupIdSGPR(0);
  if (isa<waveamdmachine::SWorkgroupIdYOp>(def))
    return index == regs.workgroupIdSGPR(1);
  if (isa<waveamdmachine::SWorkgroupIdZOp>(def))
    return index == regs.workgroupIdSGPR(2);
  return false;
}

static bool isAllowedReservedValue(Value value, unsigned index, unsigned width,
                                   const wave::WaveAMDKernelEntryRegs &regs) {
  Operation *def = value.getDefiningOp();
  if (!def)
    return false;
  auto type = cast<waveamdmachine::RegType>(value.getType());
  if (isa<waveamdmachine::KernargPreloadOp>(def)) {
    if (type.getRegClass() != waveamdmachine::RegClass::SGPR)
      return false;
    return isAllowedKernargPreloadValue(index, width, regs);
  }
  return isAllowedEntryRegValue(def, index, width, regs);
}

static LogicalResult
validateReservedRange(func::FuncOp func, Value value,
                      waveamdmachine::RegClass regClass, unsigned assignedIndex,
                      unsigned width, unsigned reserved,
                      const wave::WaveAMDKernelEntryRegs &regs) {
  if (reserved == 0 || assignedIndex >= reserved)
    return success();
  if (isAllowedReservedValue(value, assignedIndex, width, regs))
    return success();
  return diagOpForValue(value, func)->emitError()
         << kPassName << " found " << getRegClassName(regClass)
         << " value allocated in reserved kernel ABI registers";
}

static unsigned valuePosition(Value value,
                              const DenseMap<Operation *, unsigned> &positions,
                              unsigned fallback) {
  if (Operation *def = value.getDefiningOp()) {
    auto it = positions.find(def);
    if (it != positions.end())
      return it->second;
  }
  return fallback;
}

static int64_t resultIndex(Value value) {
  if (auto result = dyn_cast<OpResult>(value))
    return result.getResultNumber();
  return -1;
}

static FailureOr<unsigned> checkedUnsigned(int64_t value, Operation *diagOp,
                                           StringRef what) {
  if (value < 0 ||
      static_cast<uint64_t>(value) > std::numeric_limits<unsigned>::max())
    return diagOp->emitError()
           << kPassName << " " << what << " exceeds supported range";
  return static_cast<unsigned>(value);
}

static LogicalResult noteFixedBase(func::FuncOp func, StorageGroup &group,
                                   Value value, waveamdmachine::RegType type,
                                   unsigned slotOffset) {
  if (type.getIndex() < 0)
    return success();
  if (type.getIndex() < static_cast<int64_t>(slotOffset))
    return diagOpForValue(value, func)->emitError()
           << kPassName << " found register alias below physical zero";
  FailureOr<unsigned> index = checkedUnsigned(
      type.getIndex(), diagOpForValue(value, func), "fixed register index");
  if (failed(index))
    return failure();
  unsigned requiredBase = *index - slotOffset;
  if (!group.fixedBase) {
    group.fixedBase = requiredBase;
    return success();
  }
  if (*group.fixedBase == requiredBase)
    return success();
  return diagOpForValue(value, func)->emitError()
         << kPassName << " found inconsistent fixed register aliases";
}

static LogicalResult appendGroupValue(func::FuncOp func, StorageGroup &group,
                                      Value value, unsigned slotOffset,
                                      unsigned start, unsigned end) {
  auto type = dyn_cast<waveamdmachine::RegType>(value.getType());
  if (!type)
    return diagOpForValue(value, func)->emitError(kPassName)
           << " found non-register value in register interval";
  if (type.getRegClass() != group.regClass)
    return diagOpForValue(value, func)->emitError(kPassName)
           << " found alias group with mixed register classes";

  FailureOr<unsigned> maybeWidth = checkedUnsigned(
      type.getWidth(), diagOpForValue(value, func), "register width");
  if (failed(maybeWidth))
    return failure();
  unsigned width = *maybeWidth;
  group.values.push_back(value);
  group.slotOffsets.push_back(slotOffset);
  group.valueStarts.push_back(start);
  group.valueEnds.push_back(end);
  group.valueWidths.push_back(width);
  group.width = std::max(group.width, slotOffset + width);
  group.hasVirtual |= type.getIndex() < 0;
  return noteFixedBase(func, group, value, type, slotOffset);
}

static unsigned getReservedPrefix(waveamdmachine::RegClass regClass,
                                  const wave::WaveAMDKernelEntryRegs &regs) {
  if (regClass == waveamdmachine::RegClass::SGPR)
    return regs.reservedSGPRs;
  if (regClass == waveamdmachine::RegClass::VGPR)
    return regs.reservedVGPRs;
  return 0;
}

static LogicalResult
validateFixedGroup(func::FuncOp func, const StorageGroup &group,
                   const RegisterLimits &limits,
                   const wave::WaveAMDKernelEntryRegs &entryRegs) {
  if (!group.fixedBase)
    return success();
  unsigned addressable = getClassAddressable(limits, group.regClass);
  if (*group.fixedBase + group.width > addressable)
    return func.emitError()
           << kPassName << " fixed " << getRegClassName(group.regClass)
           << " register range exceeds addressable namespace (end="
           << (*group.fixedBase + group.width) << ", limit=" << addressable
           << ")";
  unsigned reserved = getReservedPrefix(group.regClass, entryRegs);
  for (auto [value, slot, width] :
       llvm::zip(group.values, group.slotOffsets, group.valueWidths))
    if (failed(validateReservedRange(func, value, group.regClass,
                                     *group.fixedBase + slot, width, reserved,
                                     entryRegs)))
      return failure();
  return success();
}

static FailureOr<StorageGroup>
buildStorageGroup(func::FuncOp func, const wave::WaveAMDLiveInterval &interval,
                  unsigned order, const RegisterLimits &limits,
                  const wave::WaveAMDKernelEntryRegs &entryRegs) {
  StorageGroup group;
  group.regClass = interval.type.getRegClass();
  group.start = interval.start;
  group.end = interval.end;
  group.order = order;

  if (!isAllocatedClass(group.regClass))
    return func.emitError(kPassName)
           << " supports only SGPR, VGPR, and AGPR register classes";
  FailureOr<unsigned> intervalWidth =
      checkedUnsigned(interval.type.getWidth(), func, "register width");
  if (failed(intervalWidth))
    return failure();
  group.width = *intervalWidth;

  for (auto [value, slotOffset, start, end] :
       llvm::zip(interval.values, interval.slotOffsets, interval.valueStarts,
                 interval.valueEnds)) {
    if (failed(appendGroupValue(func, group, value, slotOffset, start, end)))
      return failure();
  }

  if (failed(validateFixedGroup(func, group, limits, entryRegs)))
    return failure();
  return group;
}

static void populateSlotLiveness(StorageGroup &group, unsigned positionCount) {
  group.slotLive.clear();
  group.slotLive.resize(group.width);
  for (llvm::BitVector &bits : group.slotLive)
    bits.resize(positionCount);

  for (auto [slotOffset, start, end, valueWidth] :
       llvm::zip(group.slotOffsets, group.valueStarts, group.valueEnds,
                 group.valueWidths)) {
    for (unsigned slot :
         llvm::seq<unsigned>(slotOffset, slotOffset + valueWidth)) {
      if (slot >= group.slotLive.size())
        continue;
      for (unsigned pos : llvm::seq<unsigned>(start, end + 1))
        group.slotLive[slot].set(pos);
    }
  }
}

static ClassProblem makeClassProblem(waveamdmachine::RegClass regClass,
                                     const RegisterLimits &limits,
                                     unsigned reserved) {
  ClassProblem problem;
  problem.regClass = regClass;
  problem.name = getRegClassName(regClass);
  problem.budget = getClassBudget(limits, regClass);
  problem.addressable = getClassAddressable(limits, regClass);
  problem.reserved = reserved;
  return problem;
}

static ClassProblem &getClassProblem(RegAllocProblem &problem,
                                     waveamdmachine::RegClass regClass) {
  if (regClass == waveamdmachine::RegClass::SGPR)
    return problem.sgprs;
  if (regClass == waveamdmachine::RegClass::VGPR)
    return problem.vgprs;
  return problem.agprs;
}

static LogicalResult appendIntervals(
    func::FuncOp func, ArrayRef<wave::WaveAMDLiveInterval> intervals,
    RegAllocProblem &problem, unsigned &order, const RegisterLimits &limits,
    const wave::WaveAMDKernelEntryRegs &entryRegs) {
  for (const wave::WaveAMDLiveInterval &interval : intervals) {
    if (interval.values.empty())
      continue;
    FailureOr<StorageGroup> group =
        buildStorageGroup(func, interval, order++, limits, entryRegs);
    if (failed(group))
      return failure();
    if (group->end != std::numeric_limits<unsigned>::max())
      problem.positionCount = std::max(problem.positionCount, group->end + 1);
    getClassProblem(problem, group->regClass)
        .groups.push_back(std::move(*group));
  }
  return success();
}

static FailureOr<RegAllocProblem>
buildProblem(func::FuncOp func, const wave::WaveAMDLiveIntervalSet &intervals,
             const RegisterLimits &limits) {
  wave::WaveAMDKernelEntryRegs entryRegs =
      wave::getWaveAMDKernelEntryRegs(func);
  RegAllocProblem problem;
  problem.sgprs = makeClassProblem(waveamdmachine::RegClass::SGPR, limits,
                                   entryRegs.reservedSGPRs);
  problem.vgprs = makeClassProblem(waveamdmachine::RegClass::VGPR, limits,
                                   entryRegs.reservedVGPRs);
  problem.agprs = makeClassProblem(waveamdmachine::RegClass::AGPR, limits,
                                   /*reserved=*/0);

  unsigned order = 0;
  if (failed(appendIntervals(func, intervals.sgprs, problem, order, limits,
                             entryRegs)))
    return failure();
  if (failed(appendIntervals(func, intervals.vgprs, problem, order, limits,
                             entryRegs)))
    return failure();
  if (failed(appendIntervals(func, intervals.agprs, problem, order, limits,
                             entryRegs)))
    return failure();

  for (ClassProblem *klass : {&problem.sgprs, &problem.vgprs, &problem.agprs})
    for (StorageGroup &group : klass->groups)
      populateSlotLiveness(group, problem.positionCount);
  return problem;
}

static unsigned liveDwordsAt(const StorageGroup &group, unsigned position) {
  unsigned dwords = 0;
  for (const llvm::BitVector &slot : group.slotLive)
    if (position < slot.size() && slot.test(position))
      ++dwords;
  return dwords;
}

static bool isLiveAt(const StorageGroup &group, unsigned position) {
  return liveDwordsAt(group, position) != 0;
}

static unsigned maxAggregateLiveDwords(ArrayRef<StorageGroup> groups) {
  unsigned maxDwords = 0;
  for (const StorageGroup &group : groups)
    for (unsigned position : llvm::seq<unsigned>(group.start, group.end + 1)) {
      unsigned live = 0;
      for (const StorageGroup &other : groups)
        live += liveDwordsAt(other, position);
      maxDwords = std::max(maxDwords, live);
    }
  return maxDwords;
}

static PressureIntervalRef
buildIntervalRef(const StorageGroup &group,
                 const DenseMap<Operation *, unsigned> &positions) {
  PressureIntervalRef ref;
  ref.start = group.start;
  ref.end = group.end;
  ref.width = group.width;
  for (auto [value, slot] : llvm::zip(group.values, group.slotOffsets)) {
    ref.valuePositions.push_back(valuePosition(value, positions, ref.start));
    ref.resultIndices.push_back(resultIndex(value));
    ref.slotOffsets.push_back(slot);
  }
  return ref;
}

static bool timeOverlap(unsigned lhsStart, unsigned lhsEnd, unsigned rhsStart,
                        unsigned rhsEnd) {
  return lhsStart <= rhsEnd && rhsStart <= lhsEnd;
}

static bool groupsOverlap(const StorageGroup &lhs, const StorageGroup &rhs) {
  for (auto [lhsStart, lhsEnd] : llvm::zip(lhs.valueStarts, lhs.valueEnds))
    for (auto [rhsStart, rhsEnd] : llvm::zip(rhs.valueStarts, rhs.valueEnds))
      if (timeOverlap(lhsStart, lhsEnd, rhsStart, rhsEnd))
        return true;
  return false;
}

static DenseMap<Value, unsigned>
buildValueGroupMap(ArrayRef<StorageGroup> groups) {
  DenseMap<Value, unsigned> valueToGroup;
  for (auto [index, group] : llvm::enumerate(groups))
    for (Value value : group.values)
      valueToGroup[value] = index;
  return valueToGroup;
}

static bool isMovableVGPRGroup(const StorageGroup &group) {
  return group.regClass == waveamdmachine::RegClass::VGPR && group.hasVirtual &&
         !group.fixedBase;
}

static void addGroupByValue(Value value,
                            const DenseMap<Value, unsigned> &valueToGroup,
                            llvm::DenseSet<unsigned> &seen,
                            SmallVectorImpl<unsigned> &worklist) {
  auto it = valueToGroup.find(value);
  if (it == valueToGroup.end())
    return;
  if (seen.insert(it->second).second)
    worklist.push_back(it->second);
}

static bool isMFMA(Operation *op) {
  return op && op->hasTrait<OpTrait::waveamdmachine::MFMAOp>();
}

static bool isMFMAResult(Value value) {
  Operation *def = value.getDefiningOp();
  return isMFMA(def) && def->getNumResults() == 1 && value == def->getResult(0);
}

static bool isTupleRename(Operation *op) {
  return isa_and_nonnull<waveamdmachine::TupleFromElementsOp,
                         waveamdmachine::TupleToElementsOp>(op);
}

static bool
allRegisterEndpointsInGroup(Operation *op,
                            const llvm::DenseSet<Value> &groupValues) {
  for (Value operand : op->getOperands())
    if (isa<waveamdmachine::RegType>(operand.getType()) &&
        !groupValues.contains(operand))
      return false;
  for (Value result : op->getResults())
    if (isa<waveamdmachine::RegType>(result.getType()) &&
        !groupValues.contains(result))
      return false;
  return true;
}

static void
collectMFMAAccumulatorClosure(unsigned seed, ArrayRef<StorageGroup> groups,
                              const DenseMap<Value, unsigned> &valueToGroup,
                              SmallVectorImpl<unsigned> &group) {
  llvm::DenseSet<unsigned> seen;
  SmallVector<unsigned> worklist;
  seen.insert(seed);
  worklist.push_back(seed);

  while (!worklist.empty()) {
    unsigned groupIndex = worklist.pop_back_val();
    group.push_back(groupIndex);
    for (Value value : groups[groupIndex].values) {
      if (isMFMAResult(value))
        addGroupByValue(value.getDefiningOp()->getOperand(2), valueToGroup,
                        seen, worklist);
      for (OpOperand &use : value.getUses()) {
        Operation *user = use.getOwner();
        if (isMFMA(user) && use.getOperandNumber() == 2 &&
            user->getNumResults() == 1)
          addGroupByValue(user->getResult(0), valueToGroup, seen, worklist);
      }
    }
  }
  llvm::sort(group);
}

static bool hasGroup(ArrayRef<SmallVector<unsigned>> groups,
                     ArrayRef<unsigned> candidate) {
  return llvm::any_of(
      groups, [&](ArrayRef<unsigned> group) { return group == candidate; });
}

static llvm::DenseSet<Value> collectGroupValues(ArrayRef<unsigned> group,
                                                ArrayRef<StorageGroup> groups) {
  llvm::DenseSet<Value> values;
  for (unsigned groupIndex : group)
    for (Value value : groups[groupIndex].values)
      values.insert(value);
  return values;
}

static std::optional<unsigned> getUniformLoopBodyArgIndex(Value value) {
  auto arg = dyn_cast<BlockArgument>(value);
  if (!arg)
    return std::nullopt;
  auto loop =
      dyn_cast<waveamdmachine::UniformLoopOp>(arg.getOwner()->getParentOp());
  if (!loop || arg.getOwner() != &loop.getBody().front())
    return std::nullopt;
  return arg.getArgNumber();
}

static std::optional<unsigned> getUniformLoopResultIndex(Value value) {
  auto result = dyn_cast<OpResult>(value);
  if (!result)
    return std::nullopt;
  if (!isa<waveamdmachine::UniformLoopOp>(result.getOwner()))
    return std::nullopt;
  return result.getResultNumber();
}

static std::optional<unsigned> getUniformLoopInitIndex(OpOperand &use) {
  auto loop = dyn_cast<waveamdmachine::UniformLoopOp>(use.getOwner());
  if (!loop)
    return std::nullopt;
  MutableOperandRange inits = loop.getInitsMutable();
  for (unsigned i : llvm::seq<unsigned>(0, inits.size()))
    if (&inits[i] == &use)
      return i;
  return std::nullopt;
}

static std::optional<unsigned> getUniformLoopCarryIndex(OpOperand &use) {
  auto term = dyn_cast<waveamdmachine::ContinueIfOp>(use.getOwner());
  if (!term)
    return std::nullopt;
  MutableOperandRange carries = term.getCarriesMutable();
  for (unsigned i : llvm::seq<unsigned>(0, carries.size()))
    if (&carries[i] == &use)
      return i;
  return std::nullopt;
}

static waveamdmachine::UniformLoopOp getParentUniformLoop(Operation *op) {
  if (auto loop = dyn_cast<waveamdmachine::UniformLoopOp>(op))
    return loop;
  if (auto term = dyn_cast<waveamdmachine::ContinueIfOp>(op))
    return term->getParentOfType<waveamdmachine::UniformLoopOp>();
  return {};
}

static bool uniformLoopSlotInGroup(waveamdmachine::UniformLoopOp loop,
                                   unsigned index,
                                   const llvm::DenseSet<Value> &groupValues) {
  if (!loop || index >= loop.getInits().size())
    return false;
  Block &body = loop.getBody().front();
  auto term = dyn_cast<waveamdmachine::ContinueIfOp>(body.getTerminator());
  if (!term || index >= term.getCarries().size())
    return false;
  return groupValues.contains(loop.getInits()[index]) ||
         groupValues.contains(body.getArgument(index)) ||
         groupValues.contains(loop.getResult(index)) ||
         groupValues.contains(term.getCarries()[index]);
}

static bool isUniformLoopAGPREndpoint(Value value,
                                      const llvm::DenseSet<Value> &groupValues,
                                      bool allowLoopCarriedAGPR) {
  if (!allowLoopCarriedAGPR)
    return false;
  if (std::optional<unsigned> index = getUniformLoopBodyArgIndex(value)) {
    auto arg = cast<BlockArgument>(value);
    auto loop =
        cast<waveamdmachine::UniformLoopOp>(arg.getOwner()->getParentOp());
    return uniformLoopSlotInGroup(loop, *index, groupValues);
  }
  if (std::optional<unsigned> index = getUniformLoopResultIndex(value)) {
    auto result = cast<OpResult>(value);
    auto loop = cast<waveamdmachine::UniformLoopOp>(result.getOwner());
    return uniformLoopSlotInGroup(loop, *index, groupValues);
  }
  return false;
}

static bool isUniformLoopAGPRUse(OpOperand &use,
                                 const llvm::DenseSet<Value> &groupValues,
                                 bool allowLoopCarriedAGPR) {
  if (!allowLoopCarriedAGPR)
    return false;
  if (std::optional<unsigned> index = getUniformLoopInitIndex(use))
    return uniformLoopSlotInGroup(
        cast<waveamdmachine::UniformLoopOp>(use.getOwner()), *index,
        groupValues);
  if (std::optional<unsigned> index = getUniformLoopCarryIndex(use))
    return uniformLoopSlotInGroup(getParentUniformLoop(use.getOwner()), *index,
                                  groupValues);
  return false;
}

static bool hasMFMAAccumulatorGroup(const llvm::DenseSet<Value> &groupValues) {
  for (Value value : groupValues) {
    if (isMFMAResult(value))
      return true;
    for (OpOperand &use : value.getUses()) {
      Operation *user = use.getOwner();
      if (isMFMA(user) && use.getOperandNumber() == 2 &&
          user->getNumResults() == 1 &&
          groupValues.contains(user->getResult(0)))
        return true;
    }
  }
  return false;
}

static bool canDefineAGPR(Value value, const llvm::DenseSet<Value> &groupValues,
                          bool allowLoopCarriedAGPR) {
  if (isUniformLoopAGPREndpoint(value, groupValues, allowLoopCarriedAGPR))
    return true;
  Operation *def = value.getDefiningOp();
  if (!def)
    return false;
  if (isa<waveamdmachine::UninitOp>(def))
    return true;
  if (isTupleRename(def))
    return allRegisterEndpointsInGroup(def, groupValues);
  if (isMFMA(def) && def->getNumResults() == 1 && value == def->getResult(0))
    return def->getNumOperands() > 2 &&
           groupValues.contains(def->getOperand(2));
  return false;
}

static bool canConsumeAGPR(OpOperand &use,
                           const llvm::DenseSet<Value> &groupValues,
                           bool allowLoopCarriedAGPR) {
  if (isUniformLoopAGPRUse(use, groupValues, allowLoopCarriedAGPR))
    return true;
  Operation *user = use.getOwner();
  unsigned operandNumber = use.getOperandNumber();
  if (isMFMA(user)) {
    if (operandNumber < 2 &&
        !isa<waveamdmachine::MfmaScaleF32_16x16x128_F4F4Op>(user))
      return true;
    if (operandNumber == 2 && user->getNumResults() == 1)
      return groupValues.contains(user->getResult(0));
    return false;
  }
  if (isa<waveamdmachine::VAccvgprReadB32TupleOp>(user) && operandNumber == 0)
    return true;
  if (isTupleRename(user))
    return allRegisterEndpointsInGroup(user, groupValues);
  return false;
}

static bool hasNonAGPRWriteUse(Value value) {
  return llvm::any_of(value.getUses(), [](OpOperand &use) {
    return !isa<waveamdmachine::VAccvgprWriteB32TupleOp>(use.getOwner());
  });
}

static bool isAGPRReload(Value value) {
  return isa_and_nonnull<waveamdmachine::VAccvgprReadB32TupleOp>(
      value.getDefiningOp());
}

static bool
canMaterializeAndProgressAGPRCandidate(ArrayRef<unsigned> group,
                                       ArrayRef<StorageGroup> groups) {
  llvm::DenseSet<Value> groupValues = collectGroupValues(group, groups);
  bool allowLoopCarriedAGPR = hasMFMAAccumulatorGroup(groupValues);
  bool canProgress = false;
  for (unsigned groupIndex : group) {
    const StorageGroup &candidateGroup = groups[groupIndex];
    if (!isMovableVGPRGroup(candidateGroup))
      return false;
    for (Value value : candidateGroup.values) {
      if (isAGPRReload(value))
        return false;
      if (canDefineAGPR(value, groupValues, allowLoopCarriedAGPR)) {
        canProgress = true;
        continue;
      }
      if (!value.getDefiningOp())
        return false;
      canProgress |= hasNonAGPRWriteUse(value);
    }
  }
  return canProgress;
}

static unsigned countAGPRBridgeBoundaries(ArrayRef<unsigned> group,
                                          ArrayRef<StorageGroup> groups) {
  llvm::DenseSet<Value> groupValues = collectGroupValues(group, groups);
  bool allowLoopCarriedAGPR = hasMFMAAccumulatorGroup(groupValues);
  unsigned bridges = 0;
  for (unsigned groupIndex : group) {
    for (Value value : groups[groupIndex].values) {
      if (!canDefineAGPR(value, groupValues, allowLoopCarriedAGPR))
        ++bridges;
      for (OpOperand &use : value.getUses())
        if (!canConsumeAGPR(use, groupValues, allowLoopCarriedAGPR))
          ++bridges;
    }
  }
  return bridges;
}

static unsigned liveDwordsAt(ArrayRef<unsigned> group,
                             ArrayRef<StorageGroup> groups, unsigned position) {
  unsigned dwords = 0;
  for (unsigned groupIndex : group)
    dwords += liveDwordsAt(groups[groupIndex], position);
  return dwords;
}

static unsigned liveDwordsAt(ArrayRef<StorageGroup> groups, unsigned position) {
  unsigned dwords = 0;
  for (const StorageGroup &group : groups)
    dwords += liveDwordsAt(group, position);
  return dwords;
}

static void appendLivePoints(const StorageGroup &group,
                             SmallVectorImpl<unsigned> &points) {
  points.append(group.valueStarts.begin(), group.valueStarts.end());
  points.append(group.valueEnds.begin(), group.valueEnds.end());
}

static unsigned maxGroupLiveDwords(ArrayRef<unsigned> group,
                                   ArrayRef<StorageGroup> groups) {
  unsigned maxDwords = 0;
  SmallVector<unsigned> points;
  for (unsigned groupIndex : group)
    appendLivePoints(groups[groupIndex], points);
  llvm::sort(points);
  points.erase(std::unique(points.begin(), points.end()), points.end());
  for (unsigned position : points)
    maxDwords = std::max(maxDwords, liveDwordsAt(group, groups, position));
  return maxDwords;
}

static uint64_t intervalOverlapDwords(const StorageGroup &group) {
  uint64_t overlap = 0;
  for (const llvm::BitVector &slot : group.slotLive)
    overlap += slot.count();
  return overlap;
}

static uint64_t overlapDwords(ArrayRef<unsigned> group,
                              ArrayRef<StorageGroup> groups) {
  uint64_t overlap = 0;
  for (unsigned groupIndex : group)
    overlap += intervalOverlapDwords(groups[groupIndex]);
  return overlap;
}

static bool fitsAGPRSpace(ArrayRef<unsigned> group,
                          ArrayRef<StorageGroup> vgprs,
                          ArrayRef<StorageGroup> agprs, unsigned agprLimit) {
  if (maxGroupLiveDwords(group, vgprs) > agprLimit)
    return false;

  SmallVector<unsigned> points;
  for (unsigned groupIndex : group)
    appendLivePoints(vgprs[groupIndex], points);
  for (const StorageGroup &agpr : agprs) {
    bool overlapsGroup = llvm::any_of(group, [&](unsigned groupIndex) {
      return groupsOverlap(agpr, vgprs[groupIndex]);
    });
    if (!overlapsGroup)
      continue;
    appendLivePoints(agpr, points);
  }
  llvm::sort(points);
  points.erase(std::unique(points.begin(), points.end()), points.end());

  return llvm::all_of(points, [&](unsigned position) {
    return liveDwordsAt(group, vgprs, position) +
               liveDwordsAt(agprs, position) <=
           agprLimit;
  });
}

static AGPRConversionCandidate
buildAGPRCandidate(ArrayRef<unsigned> group, ArrayRef<StorageGroup> groups,
                   const DenseMap<Operation *, unsigned> &positions,
                   unsigned pressurePosition, unsigned order) {
  AGPRConversionCandidate candidate;
  candidate.order = order;
  candidate.bridgeCount = countAGPRBridgeBoundaries(group, groups);
  candidate.reliefDwords = liveDwordsAt(group, groups, pressurePosition);
  candidate.overlapDwords = overlapDwords(group, groups);
  candidate.agprDwords = maxGroupLiveDwords(group, groups);
  candidate.mfmaAccumulator =
      hasMFMAAccumulatorGroup(collectGroupValues(group, groups));
  for (unsigned groupIndex : group) {
    const StorageGroup &storageGroup = groups[groupIndex];
    candidate.values.append(storageGroup.values);
    candidate.intervals.push_back(buildIntervalRef(storageGroup, positions));
  }
  return candidate;
}

static bool betterAGPRCandidate(const AGPRConversionCandidate &lhs,
                                const AGPRConversionCandidate &rhs) {
  if (lhs.mfmaAccumulator != rhs.mfmaAccumulator)
    return lhs.mfmaAccumulator;
  if (lhs.bridgeCount != rhs.bridgeCount)
    return lhs.bridgeCount < rhs.bridgeCount;
  if (lhs.reliefDwords != rhs.reliefDwords)
    return lhs.reliefDwords > rhs.reliefDwords;
  if (lhs.overlapDwords != rhs.overlapDwords)
    return lhs.overlapDwords > rhs.overlapDwords;
  if (lhs.agprDwords != rhs.agprDwords)
    return lhs.agprDwords < rhs.agprDwords;
  return lhs.order < rhs.order;
}

static SmallVector<AGPRConversionCandidate, 4> buildAGPRCandidates(
    ArrayRef<StorageGroup> groups, ArrayRef<StorageGroup *> active,
    const StorageGroup &request, ArrayRef<StorageGroup> agprGroups,
    const DenseMap<Operation *, unsigned> &positions, unsigned pressurePosition,
    unsigned agprLimit) {
  DenseMap<Value, unsigned> valueToGroup = buildValueGroupMap(groups);
  SmallVector<SmallVector<unsigned>> candidateGroups;
  auto addSeed = [&](const StorageGroup &group) {
    if (group.values.empty() || !isMovableVGPRGroup(group))
      return;
    auto it = valueToGroup.find(group.values.front());
    if (it == valueToGroup.end())
      return;
    SmallVector<unsigned> candidateGroup;
    collectMFMAAccumulatorClosure(it->second, groups, valueToGroup,
                                  candidateGroup);
    if (!hasGroup(candidateGroups, candidateGroup))
      candidateGroups.push_back(std::move(candidateGroup));
  };

  for (StorageGroup *group : active)
    addSeed(*group);
  addSeed(request);

  SmallVector<AGPRConversionCandidate, 4> candidates;
  for (auto [order, candidateGroup] : llvm::enumerate(candidateGroups)) {
    if (!fitsAGPRSpace(candidateGroup, groups, agprGroups, agprLimit))
      continue;
    if (!canMaterializeAndProgressAGPRCandidate(candidateGroup, groups))
      continue;
    candidates.push_back(buildAGPRCandidate(candidateGroup, groups, positions,
                                            pressurePosition, order));
  }
  llvm::stable_sort(candidates, betterAGPRCandidate);
  return candidates;
}

static unsigned estimateRelief(unsigned liveWidth, unsigned requestWidth,
                               unsigned limit) {
  if (liveWidth + requestWidth > limit)
    return liveWidth + requestWidth - limit;
  return 1;
}

static bool pressureIntervalLess(const PressureIntervalRef &lhs,
                                 const PressureIntervalRef &rhs) {
  if (lhs.start != rhs.start)
    return lhs.start < rhs.start;
  if (lhs.end != rhs.end)
    return lhs.end < rhs.end;
  if (lhs.width != rhs.width)
    return lhs.width < rhs.width;
  return std::lexicographical_compare(
      lhs.valuePositions.begin(), lhs.valuePositions.end(),
      rhs.valuePositions.begin(), rhs.valuePositions.end());
}

static RegisterPressurePoint
buildPressurePoint(const ClassProblem &klass, const StorageGroup &request,
                   ArrayRef<StorageGroup *> assigned,
                   const DenseMap<Operation *, unsigned> &positions,
                   unsigned position) {
  RegisterPressurePoint point;
  point.regClass = klass.name;
  point.limit = klass.budget;
  point.position = position;
  point.reserved = klass.reserved;
  point.request = buildIntervalRef(request, positions);
  point.liveDwords = klass.reserved;
  for (StorageGroup *group : assigned) {
    if (!isLiveAt(*group, position))
      continue;
    if (group->fixedBase && *group->fixedBase < klass.reserved)
      continue;
    point.liveDwords += liveDwordsAt(*group, position);
    point.overlaps.push_back(buildIntervalRef(*group, positions));
  }
  point.requiredRelief = estimateRelief(
      point.liveDwords, liveDwordsAt(request, position), klass.budget);
  llvm::stable_sort(point.overlaps, pressureIntervalLess);
  return point;
}

static std::string formatInterval(const PressureIntervalRef &interval) {
  std::string out;
  llvm::raw_string_ostream os(out);
  os << "{start=" << interval.start << ", end=" << interval.end
     << ", width=" << interval.width << ", values=[";
  llvm::interleaveComma(
      llvm::seq<size_t>(0, interval.valuePositions.size()), os, [&](size_t i) {
        os << interval.valuePositions[i] << "." << interval.resultIndices[i]
           << "+" << interval.slotOffsets[i];
      });
  os << "]}";
  return out;
}

static std::string formatIntervals(ArrayRef<PressureIntervalRef> intervals) {
  std::string out;
  llvm::raw_string_ostream os(out);
  os << "[";
  llvm::interleaveComma(intervals, os,
                        [&](const PressureIntervalRef &interval) {
                          os << formatInterval(interval);
                        });
  os << "]";
  return out;
}

static LogicalResult handleAllocationFailure(
    func::FuncOp func, const ClassProblem &klass, const StorageGroup &request,
    ArrayRef<StorageGroup *> assigned, bool softFail, bool &overflow,
    std::optional<RegisterPressurePoint> &pressure,
    const DenseMap<Operation *, unsigned> &positions,
    ArrayRef<StorageGroup> agprGroups, unsigned agprCandidateLimit) {
  if (!pressure)
    pressure =
        buildPressurePoint(klass, request, assigned, positions, request.start);
  if (agprCandidateLimit > 0 &&
      klass.regClass == waveamdmachine::RegClass::VGPR) {
    SmallVector<StorageGroup *> liveAssigned;
    for (StorageGroup *group : assigned)
      if (isLiveAt(*group, request.start))
        liveAssigned.push_back(group);
    pressure->agprCandidates =
        buildAGPRCandidates(klass.groups, liveAssigned, request, agprGroups,
                            positions, request.start, agprCandidateLimit);
  }
  if (softFail) {
    overflow = true;
    return success();
  }
  InFlightDiagnostic diag = func.emitError()
                            << kPassName << " ran out of " << pressure->regClass
                            << " registers at position " << pressure->position
                            << " (limit=" << pressure->limit
                            << ", live_dwords=" << pressure->liveDwords
                            << ", required_relief=" << pressure->requiredRelief
                            << ")";
  diag << "; request=" << formatInterval(pressure->request)
       << "; overlaps=" << formatIntervals(pressure->overlaps);
  return failure();
}

class PhysicalClassAllocator {
public:
  PhysicalClassAllocator(ClassProblem &klass,
                         const DenseMap<Operation *, unsigned> &positions,
                         ArrayRef<StorageGroup> agprGroups = {},
                         unsigned agprCandidateLimit = 0)
      : klass(klass), positions(positions), agprGroups(agprGroups),
        agprCandidateLimit(agprCandidateLimit) {
    physLive.resize(klass.addressable);
    for (llvm::BitVector &bits : physLive)
      bits.resize(getPositionCount());
  }

  LogicalResult allocate(func::FuncOp func, bool softFail, bool &overflow,
                         std::optional<RegisterPressurePoint> &pressure) {
    SmallVector<StorageGroup *> assigned;
    if (failed(seedFixedGroups(func, assigned)))
      return failure();
    return allocateVirtualGroups(func, assigned, softFail, overflow, pressure);
  }

private:
  unsigned getPositionCount() const {
    unsigned count = 1;
    for (const StorageGroup &group : klass.groups)
      count = std::max(count, group.end + 1);
    return count;
  }

  bool baseFits(const StorageGroup &group, unsigned base) const {
    if (base + group.width > physLive.size())
      return false;
    for (unsigned slot : llvm::seq<unsigned>(0, group.width)) {
      const llvm::BitVector &live = group.slotLive[slot];
      if (live.none())
        continue;
      if (physLive[base + slot].anyCommon(live))
        return false;
    }
    return true;
  }

  void insert(StorageGroup &group, unsigned base) {
    group.assignedBase = base;
    for (unsigned slot : llvm::seq<unsigned>(0, group.width))
      physLive[base + slot] |= group.slotLive[slot];
  }

  LogicalResult seedFixedGroups(func::FuncOp func,
                                SmallVectorImpl<StorageGroup *> &assigned) {
    for (StorageGroup &group : klass.groups) {
      if (!group.fixedBase)
        continue;
      if (!baseFits(group, *group.fixedBase))
        return func.emitError() << kPassName << " found interfering fixed "
                                << klass.name << " register live ranges";
      insert(group, *group.fixedBase);
      assigned.push_back(&group);
    }
    return success();
  }

  std::optional<unsigned> findFreeBase(const StorageGroup &group) const {
    if (group.width > klass.budget)
      return std::nullopt;
    unsigned align = std::max<unsigned>(1, llvm::PowerOf2Ceil(group.width));
    unsigned first = alignUp(klass.reserved, align);
    if (first + group.width > klass.budget)
      return std::nullopt;
    for (unsigned base = first; base <= klass.budget - group.width;
         base += align)
      if (baseFits(group, base))
        return base;
    return std::nullopt;
  }

  LogicalResult
  allocateVirtualGroups(func::FuncOp func,
                        SmallVectorImpl<StorageGroup *> &assigned,
                        bool softFail, bool &overflow,
                        std::optional<RegisterPressurePoint> &pressure) {
    SmallVector<unsigned> virtualGroups;
    for (auto [index, group] : llvm::enumerate(klass.groups))
      if (!group.fixedBase && group.hasVirtual)
        virtualGroups.push_back(index);
    llvm::stable_sort(virtualGroups, [&](unsigned lhs, unsigned rhs) {
      const StorageGroup &lhsGroup = klass.groups[lhs];
      const StorageGroup &rhsGroup = klass.groups[rhs];
      if (lhsGroup.start != rhsGroup.start)
        return lhsGroup.start < rhsGroup.start;
      return lhsGroup.order < rhsGroup.order;
    });

    for (unsigned index : virtualGroups) {
      StorageGroup &group = klass.groups[index];
      std::optional<unsigned> base = findFreeBase(group);
      if (!base)
        return handleAllocationFailure(func, klass, group, assigned, softFail,
                                       overflow, pressure, positions,
                                       agprGroups, agprCandidateLimit);
      insert(group, *base);
      assigned.push_back(&group);
    }
    return success();
  }

  ClassProblem &klass;
  const DenseMap<Operation *, unsigned> &positions;
  ArrayRef<StorageGroup> agprGroups;
  unsigned agprCandidateLimit = 0;
  SmallVector<llvm::BitVector> physLive;
};

static bool hasVirtualAGPR(const RegAllocProblem &problem) {
  return llvm::any_of(problem.agprs.groups, [](const StorageGroup &group) {
    return group.hasVirtual;
  });
}

static LogicalResult applyAGPRTotalVGPRLimit(func::FuncOp func,
                                             RegAllocProblem &problem,
                                             RegisterLimits &limits,
                                             bool softFail, bool &overflow) {
  if (!limits.totalVGPRLimit || !limits.agprCountsAgainstVGPRs ||
      problem.agprs.groups.empty())
    return success();

  unsigned agprPressure = maxAggregateLiveDwords(problem.agprs.groups);
  if (agprPressure == 0)
    return success();
  if (agprPressure >= *limits.totalVGPRLimit) {
    if (softFail) {
      overflow = true;
      return success();
    }
    return func.emitError()
           << kPassName
           << " AGPR pressure exceeds total VGPR budget (agpr=" << agprPressure
           << ", limit=" << *limits.totalVGPRLimit
           << ", target_waves=" << limits.targetWaves << ")";
  }

  unsigned vgprBudget =
      alignDown(*limits.totalVGPRLimit - agprPressure, /*granule=*/4);
  limits.numVGPR = std::min(limits.numVGPR, vgprBudget);
  problem.vgprs.budget = limits.numVGPR;
  return success();
}

static LogicalResult
allocateProblem(func::FuncOp func, RegAllocProblem &problem, bool softFail,
                bool &overflow, std::optional<RegisterPressurePoint> &pressure,
                const DenseMap<Operation *, unsigned> &positions,
                bool buildAgprCandidates) {
  PhysicalClassAllocator sgprAllocator(problem.sgprs, positions);
  if (failed(sgprAllocator.allocate(func, softFail, overflow, pressure)))
    return failure();
  if (overflow)
    return success();

  unsigned agprCandidateLimit = buildAgprCandidates ? problem.agprs.budget : 0;
  PhysicalClassAllocator vgprAllocator(
      problem.vgprs, positions, problem.agprs.groups, agprCandidateLimit);
  if (failed(vgprAllocator.allocate(func, softFail, overflow, pressure)))
    return failure();
  if (overflow)
    return success();

  PhysicalClassAllocator agprAllocator(problem.agprs, positions);
  return agprAllocator.allocate(func, softFail, overflow, pressure);
}

static void updateCountFromGroups(unsigned &count,
                                  ArrayRef<StorageGroup> groups) {
  for (const StorageGroup &group : groups)
    if (group.assignedBase)
      count = std::max(count, *group.assignedBase + group.width);
}

static AllocatedRegisterCounts
getAllocatedRegisterCounts(const RegAllocProblem &problem) {
  AllocatedRegisterCounts counts;
  counts.sgpr = problem.sgprs.reserved;
  counts.vgpr = problem.vgprs.reserved;
  updateCountFromGroups(counts.sgpr, problem.sgprs.groups);
  updateCountFromGroups(counts.vgpr, problem.vgprs.groups);
  updateCountFromGroups(counts.agpr, problem.agprs.groups);
  return counts;
}

static unsigned getTotalVGPRCount(const RegisterLimits &limits,
                                  AllocatedRegisterCounts counts) {
  if (limits.agprCountsAgainstVGPRs && counts.agpr != 0)
    return alignUp(counts.vgpr, 4) + counts.agpr;
  return std::max(counts.vgpr, counts.agpr);
}

static LogicalResult reportBudgetOverflow(func::FuncOp func, StringRef name,
                                          unsigned count, unsigned limit,
                                          unsigned targetWaves, bool softFail,
                                          bool &overflow) {
  if (count <= limit)
    return success();
  if (softFail) {
    overflow = true;
    return success();
  }
  return func.emitError() << kPassName << " " << name
                          << " count exceeds register budget (count=" << count
                          << ", limit=" << limit
                          << ", target_waves=" << targetWaves << ")";
}

static LogicalResult
enforceAllocatedRegisterBudgets(func::FuncOp func, const RegisterLimits &limits,
                                const RegAllocProblem &problem, bool softFail,
                                bool &overflow) {
  AllocatedRegisterCounts counts = getAllocatedRegisterCounts(problem);
  if (failed(reportBudgetOverflow(func, "SGPR", counts.sgpr, limits.numSGPR,
                                  limits.targetWaves, softFail, overflow)))
    return failure();
  if (overflow)
    return success();
  if (failed(reportBudgetOverflow(func, "VGPR", counts.vgpr, limits.numVGPR,
                                  limits.targetWaves, softFail, overflow)))
    return failure();
  if (overflow || !limits.totalVGPRLimit)
    return success();
  unsigned total = getTotalVGPRCount(limits, counts);
  if (total <= *limits.totalVGPRLimit)
    return success();
  if (softFail) {
    overflow = true;
    return success();
  }
  return func.emitError() << kPassName
                          << " total VGPR count exceeds target-waves budget "
                          << "(total=" << total
                          << ", limit=" << *limits.totalVGPRLimit
                          << ", vgpr=" << counts.vgpr
                          << ", agpr=" << counts.agpr
                          << ", target_waves=" << limits.targetWaves << ")";
}

static void commitClassAssignments(ClassProblem &klass) {
  for (StorageGroup &group : klass.groups) {
    if (!group.assignedBase)
      continue;
    for (auto [value, slot] : llvm::zip(group.values, group.slotOffsets))
      setRegPhys(value, *group.assignedBase + slot);
  }
}

static void commitAssignments(RegAllocProblem &problem) {
  commitClassAssignments(problem.sgprs);
  commitClassAssignments(problem.vgprs);
  commitClassAssignments(problem.agprs);
}

static void clearOverflowAttrs(func::FuncOp func) {
  func->removeAttr(wave::getWaveAMDRegAllocOverflowedAttrName());
  func->removeAttr(kPressureClassAttr);
  func->removeAttr(kPressureLimitAttr);
  func->removeAttr(kPressureLiveDwordsAttr);
  func->removeAttr(kPressureOverlapsAttr);
  func->removeAttr(kPressurePositionAttr);
  func->removeAttr(kPressureReliefAttr);
  func->removeAttr(kPressureRequestAttr);
  func->removeAttr(kPressureReservedAttr);
  func->removeAttr(kAGPRCandidatesAttr);
}

static DictionaryAttr intervalAttr(Builder &builder,
                                   const PressureIntervalRef &interval) {
  return builder.getDictionaryAttr({
      builder.getNamedAttr("end", builder.getI64IntegerAttr(interval.end)),
      builder.getNamedAttr("result_indices", builder.getDenseI64ArrayAttr(
                                                 interval.resultIndices)),
      builder.getNamedAttr("slot_offsets",
                           builder.getDenseI64ArrayAttr(interval.slotOffsets)),
      builder.getNamedAttr("start", builder.getI64IntegerAttr(interval.start)),
      builder.getNamedAttr("value_positions", builder.getDenseI64ArrayAttr(
                                                  interval.valuePositions)),
      builder.getNamedAttr("width", builder.getI64IntegerAttr(interval.width)),
  });
}

static ArrayAttr intervalArrayAttr(Builder &builder,
                                   ArrayRef<PressureIntervalRef> intervals) {
  SmallVector<Attribute> attrs;
  for (const PressureIntervalRef &interval : intervals)
    attrs.push_back(intervalAttr(builder, interval));
  return builder.getArrayAttr(attrs);
}

static DictionaryAttr candidateAttr(Builder &builder,
                                    const AGPRConversionCandidate &candidate) {
  return builder.getDictionaryAttr({
      builder.getNamedAttr("agpr_dwords",
                           builder.getI64IntegerAttr(candidate.agprDwords)),
      builder.getNamedAttr("bridge_count",
                           builder.getI64IntegerAttr(candidate.bridgeCount)),
      builder.getNamedAttr("intervals",
                           intervalArrayAttr(builder, candidate.intervals)),
      builder.getNamedAttr("mfma_accumulator",
                           builder.getBoolAttr(candidate.mfmaAccumulator)),
      builder.getNamedAttr("overlap_dwords",
                           builder.getI64IntegerAttr(candidate.overlapDwords)),
      builder.getNamedAttr("relief_dwords",
                           builder.getI64IntegerAttr(candidate.reliefDwords)),
  });
}

static ArrayAttr
candidateArrayAttr(Builder &builder,
                   ArrayRef<AGPRConversionCandidate> candidates) {
  SmallVector<Attribute> attrs;
  for (const AGPRConversionCandidate &candidate : candidates)
    attrs.push_back(candidateAttr(builder, candidate));
  return builder.getArrayAttr(attrs);
}

static void setPressureAttrs(func::FuncOp func,
                             const RegisterPressurePoint &pressure,
                             Builder &builder) {
  func->setAttr(kPressureClassAttr, builder.getStringAttr(pressure.regClass));
  func->setAttr(kPressureLimitAttr, builder.getI64IntegerAttr(pressure.limit));
  func->setAttr(kPressureLiveDwordsAttr,
                builder.getI64IntegerAttr(pressure.liveDwords));
  func->setAttr(kPressureOverlapsAttr,
                intervalArrayAttr(builder, pressure.overlaps));
  func->setAttr(kPressurePositionAttr,
                builder.getI64IntegerAttr(pressure.position));
  func->setAttr(kPressureReliefAttr,
                builder.getI64IntegerAttr(pressure.requiredRelief));
  func->setAttr(kPressureRequestAttr, intervalAttr(builder, pressure.request));
  func->setAttr(kPressureReservedAttr,
                builder.getI64IntegerAttr(pressure.reserved));
  if (!pressure.agprCandidates.empty())
    func->setAttr(kAGPRCandidatesAttr,
                  candidateArrayAttr(builder, pressure.agprCandidates));
}

static void markOverflowed(func::FuncOp func,
                           const std::optional<RegisterPressurePoint> &pressure,
                           Builder &builder) {
  func->setAttr(wave::getWaveAMDRegAllocOverflowedAttrName(),
                builder.getI64IntegerAttr(1));
  if (pressure)
    setPressureAttrs(func, *pressure, builder);
}

struct WaveAMDRegAllocPass
    : public wave::impl::WaveAMDRegAllocBase<WaveAMDRegAllocPass> {
  using WaveAMDRegAllocBase::WaveAMDRegAllocBase;

  void runOnOperation() override {
    FailureOr<RegisterLimits> limits = getRegisterLimits(getOperation());
    if (failed(limits))
      return signalPassFailure();

    Builder builder(&getContext());
    int64_t overflowedCount = 0;
    getOperation()->removeAttr(
        wave::getWaveAMDRegAllocOverflowedCountAttrName());
    for (func::FuncOp func : collectFunctions())
      if (failed(processFunction(func, *limits, builder, overflowedCount)))
        return signalPassFailure();

    if (markOverflow)
      getOperation()->setAttr(wave::getWaveAMDRegAllocOverflowedCountAttrName(),
                              builder.getI64IntegerAttr(overflowedCount));
  }

  void applyLimitOverrides(RegisterLimits &limits) {
    if (vgprLimitOverride >= 0)
      limits.numVGPR =
          std::min(limits.numVGPR, static_cast<unsigned>(vgprLimitOverride));
    if (sgprLimitOverride >= 0)
      limits.numSGPR =
          std::min(limits.numSGPR, static_cast<unsigned>(sgprLimitOverride));
  }

  SmallVector<func::FuncOp> collectFunctions() {
    SmallVector<func::FuncOp> funcs;
    getOperation().walk([&](func::FuncOp func) {
      if (!func.isExternal())
        funcs.push_back(func);
    });
    return funcs;
  }

  LogicalResult processFunction(func::FuncOp func, RegisterLimits limits,
                                Builder &builder, int64_t &overflowedCount) {
    bool overflow = false;
    std::optional<RegisterPressurePoint> pressure;
    if (failed(applyTargetWavesLimits(func, limits)))
      return failure();
    applyLimitOverrides(limits);
    clearOverflowAttrs(func);

    if (failed(
            allocateFunction(func, limits, markOverflow, overflow, pressure)))
      return failure();
    if (overflow) {
      markOverflowed(func, pressure, builder);
      ++overflowedCount;
      return success();
    }
    return wave::verifyWaveAMDRegAllocation(
        func, kPassName, wave::WaveAMDRegAllocVerificationScope::Results);
  }

  LogicalResult prepareFunctionIR(func::FuncOp func) {
    if (failed(wave::prepareWaveAMDRegAllocIR(func)))
      return failure();
    return wave::verifyNoHardwareResourceLiveRangeOverlap(func, kPassName);
  }

  LogicalResult validateAGPRSupport(func::FuncOp func,
                                    const RegisterLimits &limits,
                                    const RegAllocProblem &problem) {
    if (limits.addressableAGPR != 0 || !hasVirtualAGPR(problem))
      return success();
    return func.emitError()
           << kPassName << " AGPR registers require target with AGPR support";
  }

  LogicalResult finishAllocatedProblem(func::FuncOp func,
                                       const RegisterLimits &limits,
                                       RegAllocProblem &problem, bool softFail,
                                       bool &overflow) {
    if (failed(enforceAllocatedRegisterBudgets(func, limits, problem, softFail,
                                               overflow)))
      return failure();
    if (!overflow)
      commitAssignments(problem);
    return success();
  }

  FailureOr<RegAllocProblem>
  buildAndAllocateAttempt(func::FuncOp func, RegisterLimits &limits,
                          bool softFail, bool &overflow,
                          std::optional<RegisterPressurePoint> &pressure,
                          bool buildAgprCandidates) {
    FailureOr<wave::WaveAMDLiveIntervalBuildResult> builtIntervals =
        wave::buildAllocatedWaveAMDLiveIntervals(func);
    if (failed(builtIntervals))
      return failure();

    unsigned sgprReserved = wave::getWaveAMDReservedSGPRs(func);
    unsigned vgprReserved = wave::getWaveAMDReservedVGPRs(func);
    if (failed(
            validateReservedLimits(func, limits, sgprReserved, vgprReserved)))
      return failure();

    FailureOr<RegAllocProblem> problem =
        buildProblem(func, builtIntervals->intervals, limits);
    if (failed(problem))
      return failure();

    if (failed(validateAGPRSupport(func, limits, *problem)))
      return failure();
    if (failed(applyAGPRTotalVGPRLimit(func, *problem, limits, softFail,
                                       overflow)))
      return failure();
    if (overflow)
      return std::move(*problem);
    if (failed(
            validateReservedLimits(func, limits, sgprReserved, vgprReserved)))
      return failure();

    if (failed(allocateProblem(func, *problem, softFail, overflow, pressure,
                               builtIntervals->positions, buildAgprCandidates)))
      return failure();
    return std::move(*problem);
  }

  LogicalResult
  allocateFunctionAttempt(func::FuncOp func, RegisterLimits limits,
                          bool softFail, bool &overflow,
                          std::optional<RegisterPressurePoint> &pressure,
                          bool buildAgprCandidates, bool enforceFinalBudgets) {
    FailureOr<RegAllocProblem> problem = buildAndAllocateAttempt(
        func, limits, softFail, overflow, pressure, buildAgprCandidates);
    if (failed(problem))
      return failure();
    if (overflow || !enforceFinalBudgets)
      return success();
    return finishAllocatedProblem(func, limits, *problem, softFail, overflow);
  }

  LogicalResult finishUnrelievedOverflow(
      func::FuncOp func, bool softFail, bool &overflow,
      const std::optional<RegisterPressurePoint> &pressure) {
    if (softFail) {
      overflow = true;
      return success();
    }
    if (!pressure)
      return func.emitError(kPassName)
             << " overflowed without pressure diagnostics";
    InFlightDiagnostic diag =
        func.emitError()
        << kPassName << " could not find a legal AGPR bank-spill candidate for "
        << pressure->regClass << " pressure at position " << pressure->position
        << " (limit=" << pressure->limit
        << ", live_dwords=" << pressure->liveDwords
        << ", required_relief=" << pressure->requiredRelief << ")";
    diag << "; request=" << formatInterval(pressure->request)
         << "; overlaps=" << formatIntervals(pressure->overlaps);
    return failure();
  }

  LogicalResult
  finishAGPRProgressBound(func::FuncOp func, bool softFail, bool &overflow,
                          const std::optional<RegisterPressurePoint> &pressure,
                          unsigned progressBound) {
    if (softFail) {
      overflow = true;
      return success();
    }
    if (!pressure)
      return func.emitError(kPassName)
             << " hit AGPR bank-spill progress bound without pressure "
                "diagnostics";
    return func.emitError()
           << kPassName << " hit AGPR bank-spill progress bound "
           << "(bound=" << progressBound
           << ") before relieving VGPR pressure at position "
           << pressure->position;
  }

  LogicalResult applyAGPRCandidate(func::FuncOp func,
                                   const AGPRConversionCandidate &candidate,
                                   OpBuilder &builder) {
    llvm::DenseSet<Value> groupValues(candidate.values.begin(),
                                      candidate.values.end());
    bool allowLoopCarriedAGPR = hasMFMAAccumulatorGroup(groupValues);
    SmallVector<std::pair<Value, Value>, 4> agprValues;
    for (Value value : candidate.values) {
      if (!isa<waveamdmachine::RegType>(value.getType()))
        continue;
      if (canDefineAGPR(value, groupValues, allowLoopCarriedAGPR)) {
        setRegClass(value, waveamdmachine::RegClass::AGPR);
        agprValues.push_back({value, value});
        continue;
      }
      Operation *def = value.getDefiningOp();
      if (!def)
        return func.emitError()
               << kPassName << " cannot bank-spill block argument " << value;
      builder.setInsertionPointAfter(def);
      auto write = waveamdmachine::VAccvgprWriteB32TupleOp::create(
          builder, def->getLoc(),
          getVirtualRegType(value, waveamdmachine::RegClass::AGPR), value);
      agprValues.push_back({value, write.getResult()});
    }

    for (const std::pair<Value, Value> &mapping : agprValues)
      rewriteAGPRUses(mapping.first, mapping.second, groupValues,
                      allowLoopCarriedAGPR, builder);
    return success();
  }

  static void rewriteAGPRUses(Value original, Value agpr,
                              const llvm::DenseSet<Value> &groupValues,
                              bool allowLoopCarriedAGPR, OpBuilder &builder) {
    SmallVector<OpOperand *> uses;
    for (OpOperand &use : original.getUses())
      uses.push_back(&use);
    for (OpOperand *use : uses) {
      if (use->get() != original)
        continue;
      Operation *user = use->getOwner();
      if (auto write =
              dyn_cast<waveamdmachine::VAccvgprWriteB32TupleOp>(user)) {
        if (write.getResult() != agpr) {
          write.getResult().replaceAllUsesWith(agpr);
          write.erase();
        }
        continue;
      }
      if (canConsumeAGPR(*use, groupValues, allowLoopCarriedAGPR)) {
        use->set(agpr);
        continue;
      }
      builder.setInsertionPoint(user);
      auto read = waveamdmachine::VAccvgprReadB32TupleOp::create(
          builder, user->getLoc(),
          getVirtualRegType(agpr, waveamdmachine::RegClass::VGPR), agpr);
      use->set(read.getResult());
    }
  }

  LogicalResult allocateFunctionWithAGPRBankSpill(
      func::FuncOp func, RegisterLimits limits, bool softFail, bool &overflow,
      std::optional<RegisterPressurePoint> &pressure) {
    unsigned progressBound = countVirtualVGPRValues(func.getOperation());
    for (unsigned iter : llvm::seq<unsigned>(0, progressBound + 1)) {
      bool attemptOverflow = false;
      std::optional<RegisterPressurePoint> attemptPressure;
      RegisterLimits attemptLimits = limits;
      FailureOr<RegAllocProblem> problem = buildAndAllocateAttempt(
          func, attemptLimits, /*softFail=*/true, attemptOverflow,
          attemptPressure, /*buildAgprCandidates=*/true);
      if (failed(problem))
        return failure();
      if (!attemptOverflow)
        return finishAllocatedProblem(func, attemptLimits, *problem, softFail,
                                      overflow);
      pressure = std::move(attemptPressure);
      if (!pressure || pressure->regClass != "VGPR" ||
          pressure->agprCandidates.empty())
        return finishUnrelievedOverflow(func, softFail, overflow, pressure);
      if (iter == progressBound)
        return finishAGPRProgressBound(func, softFail, overflow, pressure,
                                       progressBound);
      OpBuilder builder(func.getContext());
      if (failed(applyAGPRCandidate(func, pressure->agprCandidates.front(),
                                    builder)))
        return failure();
    }
    llvm_unreachable("loop exits through success or overflow handling");
  }

  LogicalResult
  allocateFunction(func::FuncOp func, RegisterLimits limits, bool softFail,
                   bool &overflow,
                   std::optional<RegisterPressurePoint> &pressure) {
    if (failed(prepareFunctionIR(func)))
      return failure();
    if (agprBankSpill)
      return allocateFunctionWithAGPRBankSpill(func, limits, softFail, overflow,
                                               pressure);
    return allocateFunctionAttempt(func, limits, softFail, overflow, pressure,
                                   rankAgprCandidates,
                                   /*enforceFinalBudgets=*/true);
  }
};

} // namespace
