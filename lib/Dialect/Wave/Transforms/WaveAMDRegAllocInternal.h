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

namespace mlir::wave::regalloc {

inline constexpr llvm::StringLiteral kRegAllocTempAttr =
    "waveamdmachine.regalloc_debug_temp";
inline constexpr llvm::StringLiteral kLDSSpillBytesAttr =
    "waveamdmachine.lds_spill_bytes";
inline constexpr llvm::StringLiteral kPrivateSegmentFixedSizeAttr =
    "waveamdmachine.private_segment_fixed_size";
inline constexpr llvm::StringLiteral kScratchSpillBytesAttr =
    "waveamdmachine.scratch_spill_bytes";
inline constexpr llvm::StringLiteral kSGPRSpillCountAttr =
    "waveamdmachine.sgpr_spill_count";
inline constexpr llvm::StringLiteral kVGPRSpillCountAttr =
    "waveamdmachine.vgpr_spill_count";
inline constexpr llvm::StringLiteral kMemorySpillRejectAttr =
    "waveamdmachine.regalloc_debug_memory_spill_reject";
inline constexpr llvm::StringLiteral kMemorySpillRejectDetailAttr =
    "waveamdmachine.regalloc_debug_memory_spill_reject_detail";
inline constexpr llvm::StringLiteral kRegAllocRemarkCategory =
    "waveamdmachine-regalloc";

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

struct Inventory {
  SmallVector<Operation *> ops;
  DenseMap<Operation *, unsigned> positions;
  DenseMap<Value, Interval *> intervalFor;
  ::mlir::wave::WaveAMDKernelEntryRegs entryRegs;
  SmallVector<std::unique_ptr<Interval>> intervals;
  SmallVector<std::unique_ptr<IntervalGroup>> groups;
  wave::WaveAMDPressureReliefPlanList plannedReliefPlans;
  SmallVector<PlannedPressureReliefTempInterval, 16> plannedReliefTemps;
  DenseMap<StringRef, unsigned> plannedProviderBytes;
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

inline bool isMemoryIssuerOp(Operation *op) {
  if (!op)
    return false;
  waveamdmachine::WaitcntInfoOpInterface info =
      dyn_cast<waveamdmachine::WaitcntInfoOpInterface>(op);
  return info && info.getWaitcntInfo().isIssuer();
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
  if (group->storageClass == waveamdmachine::RegClass::VGPR)
    return {-static_cast<int64_t>(reliefDwords), 0};
  if (group->storageClass == waveamdmachine::RegClass::AGPR)
    return {0, -static_cast<int64_t>(reliefDwords)};
  return {};
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
  waveamdmachine::RegType type = cast<waveamdmachine::RegType>(value.getType());
  if (Operation *def = value.getDefiningOp()) {
    if (!getMemorySpillOpPosition(def, inventory))
      return false;
    if (type.getRegClass() == waveamdmachine::RegClass::AGPR)
      return !isMemoryIssuerOp(def);
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
    if (!getMemorySpillOpPosition(user, inventory))
      return false;
    uses.push_back(&use);
  }
  return !uses.empty();
}

inline bool
collectSimpleMemorySpillAGPRUses(Value value, const Inventory &inventory,
                                 SmallVectorImpl<OpOperand *> &uses) {
  if (!hasMemorySpillStoreAnchor(value, inventory))
    return false;
  for (OpOperand &use : value.getUses()) {
    Operation *user = use.getOwner();
    if (isRegAllocTempOp(user))
      continue;
    if (!isa<waveamdmachine::VAccvgprReadB32TupleOp>(user))
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
  waveamdmachine::RegType type = cast<waveamdmachine::RegType>(value.getType());
  if (type.getRegClass() == waveamdmachine::RegClass::AGPR)
    return collectSimpleMemorySpillAGPRUses(value, inventory, uses);
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

inline bool hasMemorySpillUseAtPressure(ArrayRef<OpOperand *> uses,
                                        const Inventory &inventory,
                                        unsigned position) {
  for (OpOperand *use : uses) {
    std::optional<unsigned> usePosition =
        getMemorySpillOpPosition(use->getOwner(), inventory);
    if (usePosition && *usePosition == position)
      return true;
  }
  return false;
}

inline std::optional<unsigned> getMemorySpillPressureRelief(
    Value value, unsigned width, ArrayRef<OpOperand *> uses,
    const Inventory &inventory, const PressureFailure *pressureFailure) {
  if (!pressureFailure || !pressureFailure->combinedVGPRAGPR)
    return width;
  if (isMemorySpillSuppressedVGPRExpr(value.getDefiningOp()))
    return 0;
  if (hasMemorySpillUseAtPressure(uses, inventory, pressureFailure->position))
    return 0;
  return width;
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

inline unsigned getMemorySpillValuePosition(Value value,
                                            const Inventory &inventory) {
  std::optional<unsigned> position =
      getMemorySpillValuePositionIfKnown(value, inventory);
  assert(position && "spill value must have a known position");
  return *position;
}

inline waveamdmachine::RegClass getMemorySpillLoadRegClass(Value value) {
  waveamdmachine::RegType type = cast<waveamdmachine::RegType>(value.getType());
  if (type.getRegClass() == waveamdmachine::RegClass::AGPR)
    return waveamdmachine::RegClass::VGPR;
  return type.getRegClass();
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

template <typename CollectAddressTempsFn>
static void collectMemorySpillValueTempIntervals(
    const Inventory &inventory, Value value,
    SmallVectorImpl<wave::WaveAMDPressureReliefTempInterval> &intervals,
    CollectAddressTempsFn collectAddressTemps) {
  if (!value)
    return;
  SmallVector<OpOperand *> uses;
  (void)collectSimpleMemorySpillUses(value, inventory, uses);
  waveamdmachine::RegType type = cast<waveamdmachine::RegType>(value.getType());
  unsigned valueWidth = static_cast<unsigned>(type.getWidth());
  unsigned defPosition = getMemorySpillValuePosition(value, inventory);
  unsigned bridgeStart =
      getTupleFromElementsBridgeStart(value, inventory, defPosition);
  appendMemorySpillTemp(intervals, type.getRegClass(), bridgeStart, defPosition,
                        valueWidth);
  if (type.getRegClass() == waveamdmachine::RegClass::AGPR)
    appendMemorySpillPointTemp(intervals, waveamdmachine::RegClass::VGPR,
                               defPosition, valueWidth);
  collectAddressTemps(intervals, defPosition, valueWidth);

  waveamdmachine::RegClass loadClass = getMemorySpillLoadRegClass(value);
  for (OpOperand *use : uses) {
    std::optional<unsigned> position =
        getMemorySpillOpPosition(use->getOwner(), inventory);
    if (!position)
      continue;
    unsigned usePosition = *position;
    unsigned loadEnd = usePosition;
    if (auto split =
            dyn_cast<waveamdmachine::TupleToElementsOp>(use->getOwner())) {
      for (Value element : split.getElements()) {
        Interval *interval = inventory.intervalFor.lookup(element);
        if (interval)
          loadEnd = std::max(loadEnd, interval->end);
      }
    }
    wave::WaveAMDPressureReliefTempInterval loadTemp;
    loadTemp.regClass = loadClass;
    loadTemp.start = usePosition;
    loadTemp.end = loadEnd;
    loadTemp.width = valueWidth;
    intervals.push_back(loadTemp);
    collectAddressTemps(intervals, usePosition, valueWidth);
  }
}

inline Type getMemorySpillLoadType(Value value) {
  waveamdmachine::RegType type = cast<waveamdmachine::RegType>(value.getType());
  if (type.getRegClass() != waveamdmachine::RegClass::AGPR)
    return value.getType();
  return waveamdmachine::RegType::get(value.getContext(),
                                      waveamdmachine::RegClass::VGPR,
                                      type.getWidth(), /*index=*/-1);
}

inline SmallVector<Type> getMemorySpillScalarRegTypes(Type tupleType);

inline FailureOr<Value> materializeMemorySpillStoreValue(
    Value value, const wave::WaveAMDPressureReliefPlan &plan,
    wave::WaveAMDPressureReliefMaterializationContext &context,
    OpBuilder &builder, Operation *diagOp) {
  waveamdmachine::RegType type = cast<waveamdmachine::RegType>(value.getType());
  if (type.getRegClass() != waveamdmachine::RegClass::AGPR)
    return value;
  FailureOr<waveamdmachine::RegType> readType =
      consumePressureReliefTempRegType(plan, context,
                                       waveamdmachine::RegClass::VGPR,
                                       type.getWidth(), diagOp);
  if (failed(readType))
    return failure();
  waveamdmachine::VAccvgprReadB32TupleOp read =
      waveamdmachine::VAccvgprReadB32TupleOp::create(builder, value.getLoc(),
                                                     *readType, value);
  read->setAttr(kRegAllocTempAttr, builder.getUnitAttr());
  return read.getResult();
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
             << "waveamd-reg-alloc cannot replace mismatched split spill";
    unsigned width = static_cast<unsigned>(elementType.getWidth());
    if (offset + width > static_cast<unsigned>(loadedType.getWidth()))
      return split.emitError()
             << "waveamd-reg-alloc cannot replace mismatched split spill";
    int64_t index = -1;
    if (loadedType.getIndex() >= 0)
      index = loadedType.getIndex() + offset;
    elementTypes.push_back(waveamdmachine::RegType::get(
        loadedType.getContext(), loadedType.getRegClass(), width, index));
    offset += width;
  }
  if (offset != static_cast<unsigned>(loadedType.getWidth()))
    return split.emitError()
           << "waveamd-reg-alloc cannot replace mismatched split spill";
  for (auto [element, elementType] :
       llvm::zip(split.getElements(), elementTypes))
    element.setType(elementType);
  return success();
}

inline LogicalResult replaceMemorySpillUseWithLoad(
    Value value, OpOperand *use, Value loaded,
    const wave::WaveAMDPressureReliefPlan &plan,
    wave::WaveAMDPressureReliefMaterializationContext &context) {
  waveamdmachine::RegType type = cast<waveamdmachine::RegType>(value.getType());
  if (type.getRegClass() != waveamdmachine::RegClass::AGPR) {
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
  waveamdmachine::VAccvgprReadB32TupleOp read =
      dyn_cast<waveamdmachine::VAccvgprReadB32TupleOp>(use->getOwner());
  if (!read)
    return failure();
  read.getResult().replaceAllUsesWith(loaded);
  read.erase();
  return success();
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
      waveamdmachine::VLshrrevB32Op, waveamdmachine::VLshlrevB32Op,
      waveamdmachine::VLshlAddU32Op, waveamdmachine::VAddU32Op,
      waveamdmachine::VAdd3U32Op, waveamdmachine::VAndB32Op,
      waveamdmachine::VMulLoU32Op, waveamdmachine::VAddLshlU32Op,
      waveamdmachine::VXorB32Op, waveamdmachine::VAndOrB32Op,
      waveamdmachine::VAccvgprReadB32TupleOp,
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
  return regClass == waveamdmachine::RegClass::VGPR ||
         regClass == waveamdmachine::RegClass::AGPR;
}

inline bool isMemorySpillTempGroup(IntervalGroup *group) {
  if (!group)
    return false;
  bool sawValue = false;
  for (Interval *interval : group->intervals) {
    for (Value value : interval->values) {
      sawValue = true;
      if (!isRegAllocTempOp(value.getDefiningOp()))
        return false;
    }
  }
  return sawValue;
}

inline bool isMemorySpillProviderCandidateGroup(IntervalGroup *group,
                                                unsigned position) {
  if (!group || group->plannedPressureRelief || group->reserved ||
      isFixedRegisterGroup(group))
    return false;
  if (!isMemorySpillProviderRegClass(group->storageClass))
    return false;
  if (group->storageClass == waveamdmachine::RegClass::AGPR &&
      !isMemorySpillTempGroup(group))
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
  return isMemorySpillTempGroup(group);
}

inline bool isMemorySpillEligibleGroup(IntervalGroup *group,
                                       unsigned position) {
  return isMemorySpillVGPRGroup(group) &&
         hasLiveMemorySpillLane(group, position);
}

struct MemorySpillRejectStats {
  unsigned eligible = 0;
  unsigned fixed = 0;
  unsigned memoryIssuer = 0;
  unsigned noUse = 0;
  unsigned nonPromotable = 0;
  unsigned temp = 0;
  unsigned total = 0;
};

enum class MemorySpillRejectKind : uint8_t {
  Eligible,
  Fixed,
  MemoryIssuer,
  NoUse,
  NonPromotable,
  Temp,
};

inline bool memorySpillRejectGroupLiveAt(IntervalGroup *group,
                                         unsigned position) {
  if (!group || group->plannedPressureRelief)
    return false;
  for (Interval *lane : group->intervals)
    if (lane->start <= position && position <= lane->end)
      return true;
  return false;
}

inline bool groupHasTempValue(IntervalGroup *group) {
  if (!group)
    return false;
  for (Interval *lane : group->intervals)
    for (Value value : lane->values)
      if (Operation *def = value.getDefiningOp())
        if (isRegAllocTempOp(def))
          return true;
  return false;
}

inline bool groupHasMemoryIssuerValue(IntervalGroup *group) {
  if (!group)
    return false;
  for (Interval *lane : group->intervals)
    for (Value value : lane->values)
      if (isMemoryIssuerOp(value.getDefiningOp()))
        return true;
  return false;
}

inline bool groupHasNonTempUse(IntervalGroup *group) {
  if (!group)
    return false;
  for (Interval *lane : group->intervals)
    for (Value value : lane->values)
      for (OpOperand &use : value.getUses())
        if (!isRegAllocTempOp(use.getOwner()))
          return true;
  return false;
}

inline bool shouldInspectMemorySpillReject(IntervalGroup *group,
                                           unsigned position) {
  if (!memorySpillRejectGroupLiveAt(group, position))
    return false;
  return group->storageClass == waveamdmachine::RegClass::VGPR &&
         group->preferredClass == waveamdmachine::RegClass::VGPR;
}

inline MemorySpillRejectKind getMemorySpillUseRejectKind(IntervalGroup *group,
                                                         unsigned position) {
  assert(hasLiveMemorySpillLane(group, position) &&
         "caller handles non-live spill lanes");
  if (groupHasMemoryIssuerValue(group))
    return MemorySpillRejectKind::MemoryIssuer;
  if (!groupHasNonTempUse(group))
    return MemorySpillRejectKind::NoUse;
  return MemorySpillRejectKind::Eligible;
}

inline MemorySpillRejectKind getMemorySpillRejectKind(IntervalGroup *group,
                                                      unsigned position) {
  if (group->reserved || isFixedRegisterGroup(group))
    return MemorySpillRejectKind::Fixed;
  if (groupHasTempValue(group))
    return MemorySpillRejectKind::Temp;
  if (group->nonPromotable || !hasLiveMemorySpillLane(group, position))
    return MemorySpillRejectKind::NonPromotable;
  return getMemorySpillUseRejectKind(group, position);
}

inline void incrementMemorySpillReject(MemorySpillRejectStats &stats,
                                       MemorySpillRejectKind kind) {
  switch (kind) {
  case MemorySpillRejectKind::Eligible:
    ++stats.eligible;
    break;
  case MemorySpillRejectKind::Fixed:
    ++stats.fixed;
    break;
  case MemorySpillRejectKind::MemoryIssuer:
    ++stats.memoryIssuer;
    break;
  case MemorySpillRejectKind::NoUse:
    ++stats.noUse;
    break;
  case MemorySpillRejectKind::NonPromotable:
    ++stats.nonPromotable;
    break;
  case MemorySpillRejectKind::Temp:
    ++stats.temp;
    break;
  }
}

inline void classifyMemorySpillReject(IntervalGroup *group, unsigned position,
                                      MemorySpillRejectStats &stats) {
  if (!shouldInspectMemorySpillReject(group, position))
    return;
  ++stats.total;
  incrementMemorySpillReject(stats, getMemorySpillRejectKind(group, position));
}

inline void addMemorySpillRejectCount(Builder &builder, NamedAttrList &attrs,
                                      StringRef name, unsigned count) {
  if (count == 0)
    return;
  attrs.set(name, builder.getI64IntegerAttr(count));
}

inline void clearMemorySpillRejectDiagnostics(func::FuncOp func) {
  func->removeAttr(kMemorySpillRejectAttr);
  func->removeAttr(kMemorySpillRejectDetailAttr);
}

inline void setMemorySpillRejectDiagnostics(func::FuncOp func,
                                            ArrayRef<IntervalGroup *> groups,
                                            IntervalGroup *request,
                                            unsigned position) {
  MemorySpillRejectStats stats;
  classifyMemorySpillReject(request, position, stats);
  for (IntervalGroup *group : groups)
    classifyMemorySpillReject(group, position, stats);
  if (stats.total == 0)
    return;

  Builder builder(func.getContext());
  NamedAttrList attrs;
  attrs.set("total", builder.getI64IntegerAttr(stats.total));
  addMemorySpillRejectCount(builder, attrs, "eligible", stats.eligible);
  addMemorySpillRejectCount(builder, attrs, "fixed", stats.fixed);
  addMemorySpillRejectCount(builder, attrs, "memory_issuer",
                            stats.memoryIssuer);
  addMemorySpillRejectCount(builder, attrs, "no_use", stats.noUse);
  addMemorySpillRejectCount(builder, attrs, "non_promotable",
                            stats.nonPromotable);
  addMemorySpillRejectCount(builder, attrs, "temp", stats.temp);
  func->setAttr(kMemorySpillRejectDetailAttr, builder.getDictionaryAttr(attrs));
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

std::unique_ptr<wave::WaveAMDPressureReliefProvider>
createBankPromotionProvider(ArrayRef<IntervalGroup *> groups,
                            IntervalGroup *request, unsigned position,
                            RegisterBudgets budgets, Inventory &inventory);
std::unique_ptr<wave::WaveAMDPressureReliefProvider>
createRematerializeProvider(ArrayRef<IntervalGroup *> groups,
                            IntervalGroup *request, unsigned position,
                            Inventory &inventory);
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
