//===- WaveAMDRegAllocAGPRRelief.cpp - AGPR pressure relief --------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "WaveAMDRegAllocTransformLoop.h"
#include "WaveAMDRegAllocTransformState.h"
#include "WaveAMDRegAllocTransformUtils.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachine.h"
#include "mlir/IR/Builders.h"
#include "mlir/IR/BuiltinTypes.h"
#include "mlir/IR/IRMapping.h"
#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/DenseSet.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/Support/MathExtras.h"
#include <array>
#include <limits>
#include <optional>

using namespace mlir;
using namespace mlir::wave::regalloc_detail;

namespace {

struct AGPRReliefScore {
  unsigned liveDwords = 0;
  int64_t bridgeCost = 0;
  int64_t bridgeCount = 0;
  int64_t loopBridgeCost = 0;
  unsigned end = 0;
};

struct AGPRReliefCandidate {
  SmallVector<ResolvedRegAllocValue> values;
  const wave::RegAllocTransformAliasSet *set = nullptr;
  AGPRReliefScore score;
};

struct AGPRReliefSetIndex {
  llvm::SmallDenseMap<unsigned, const wave::RegAllocTransformAliasSet *, 1024>
      setsById;
};

struct AGPRReliefInterval {
  std::optional<unsigned> fixedBase;
  unsigned id = 0;
  unsigned start = 0;
  unsigned end = 0;
  unsigned width = 0;
};

static bool
assignedRangesOverlap(const wave::RegAllocTransformAssignment &assignment,
                      unsigned base, unsigned width) {
  unsigned end = base + width;
  unsigned assignedEnd = assignment.base + assignment.width;
  return base < assignedEnd && assignment.base < end;
}

static std::optional<unsigned>
findFreeAGPRBase(const AGPRReliefInterval &interval,
                 ArrayRef<wave::RegAllocTransformAssignment> active,
                 unsigned limit) {
  if (interval.width > limit)
    return std::nullopt;
  unsigned align = std::max<unsigned>(1, llvm::PowerOf2Ceil(interval.width));
  for (unsigned base = 0; base <= limit - interval.width; base += align) {
    bool blocked = llvm::any_of(
        active, [&](const wave::RegAllocTransformAssignment &assigned) {
          return assignedRangesOverlap(assigned, base, interval.width);
        });
    if (!blocked)
      return base;
  }
  return std::nullopt;
}

static bool
canAllocateAGPRReliefIntervals(ArrayRef<AGPRReliefInterval> intervals,
                               unsigned candidateId, unsigned limit,
                               unsigned &footprint) {
  SmallVector<wave::RegAllocTransformAssignment> active;
  bool allocatedCandidate = false;
  footprint = 0;
  for (const AGPRReliefInterval &interval : intervals) {
    llvm::erase_if(active,
                   [&](const wave::RegAllocTransformAssignment &assigned) {
                     return assigned.end < interval.start;
                   });
    if (interval.fixedBase) {
      if (*interval.fixedBase + interval.width > limit)
        return false;
      if (llvm::any_of(active,
                       [&](const wave::RegAllocTransformAssignment &assigned) {
                         return assignedRangesOverlap(
                             assigned, *interval.fixedBase, interval.width);
                       }))
        return false;
      active.push_back({waveamdmachine::RegClass::AGPR, interval.id,
                        *interval.fixedBase, interval.width, interval.start,
                        interval.end});
      footprint = std::max(footprint, *interval.fixedBase + interval.width);
      allocatedCandidate |= interval.id == candidateId;
      continue;
    }
    std::optional<unsigned> base = findFreeAGPRBase(interval, active, limit);
    if (!base)
      return false;
    active.push_back({waveamdmachine::RegClass::AGPR, interval.id, *base,
                      interval.width, interval.start, interval.end});
    footprint = std::max(footprint, *base + interval.width);
    allocatedCandidate |= interval.id == candidateId;
  }
  return allocatedCandidate;
}

static bool lessAGPRReliefInterval(const AGPRReliefInterval &lhs,
                                   const AGPRReliefInterval &rhs) {
  return std::tie(lhs.start, lhs.id) < std::tie(rhs.start, rhs.id);
}

static void
addAGPRReliefIntervals(SmallVectorImpl<AGPRReliefInterval> &intervals,
                       const wave::RegAllocTransformAliasSet &set,
                       std::optional<unsigned> fixedBase) {
  for (wave::RegAllocTransformLiveRange range : set.ranges)
    intervals.push_back({fixedBase, set.id, range.start, range.end, set.width});
}

static bool canAllocateAGPRReliefCandidate(
    func::FuncOp func, const wave::RegAllocTransformAliasSet &candidate,
    ArrayRef<wave::RegAllocTransformAliasSet> sets,
    ArrayRef<wave::RegAllocTransformValue> values, unsigned &agprFootprint) {
  wave::RegAllocTransformBudget budget =
      wave::getRegAllocTransformBudget(func, waveamdmachine::RegClass::AGPR);
  SmallVector<AGPRReliefInterval> intervals;
  for (const wave::RegAllocTransformAliasSet &set : sets) {
    if (set.regClass != waveamdmachine::RegClass::AGPR)
      continue;
    addAGPRReliefIntervals(intervals, set,
                           getRegAllocTransformFixedBase(set, values));
  }
  addAGPRReliefIntervals(intervals, candidate, std::nullopt);
  llvm::stable_sort(intervals, lessAGPRReliefInterval);
  return canAllocateAGPRReliefIntervals(intervals, candidate.id, budget.limit,
                                        agprFootprint);
}

static unsigned getVGPRFootprintAfterRemovingSet(
    ArrayRef<wave::RegAllocTransformAssignment> assignments,
    std::optional<unsigned> removedSet) {
  unsigned footprint = 0;
  for (const wave::RegAllocTransformAssignment &assignment : assignments) {
    if (assignment.regClass != waveamdmachine::RegClass::VGPR ||
        (removedSet && assignment.set == *removedSet))
      continue;
    footprint = std::max(footprint, assignment.base + assignment.width);
  }
  return footprint;
}

static const wave::RegAllocTransformAssignment *
findFailureOverlap(const RegAllocTransformFailure &failureRecord,
                   unsigned setId) {
  for (const wave::RegAllocTransformAssignment &overlap :
       failureRecord.overlaps)
    if (overlap.set == setId)
      return &overlap;
  return nullptr;
}

static FailureOr<bool> respectsCombinedVGPRFamilyBudget(
    func::FuncOp func, const wave::RegAllocTransformAliasSet &candidate,
    const RegAllocTransformFailure &failureRecord,
    ArrayRef<wave::RegAllocTransformAliasSet> sets, unsigned agprFootprint) {
  FailureOr<std::optional<wave::RegAllocTransformBudget>> familyBudget =
      wave::getRegAllocTransformVGPRFamilyBudget(func);
  if (failed(familyBudget))
    return failure();
  if (!*familyBudget)
    return true;

  unsigned vgprFootprint = getVGPRFootprintAfterRemovingSet(
      failureRecord.overlaps, /*removedSet=*/std::nullopt);
  if (candidate.id != failureRecord.set) {
    const wave::RegAllocTransformAssignment *moved =
        findFailureOverlap(failureRecord, candidate.id);
    if (!moved)
      return false;
    const wave::RegAllocTransformAliasSet *request = nullptr;
    for (const wave::RegAllocTransformAliasSet &set : sets)
      if (set.id == failureRecord.set) {
        request = &set;
        break;
      }
    if (!request || request->width > moved->width)
      return false;
    vgprFootprint = std::max(
        getVGPRFootprintAfterRemovingSet(failureRecord.overlaps, candidate.id),
        moved->base + request->width);
  }

  unsigned pressure =
      getCombinedVGPRFamilyPressure(agprFootprint, vgprFootprint);
  return pressure <= (*familyBudget)->limit;
}

static bool
setCanRelieveAtPosition(const wave::RegAllocTransformAliasSet &set,
                        ArrayRef<wave::RegAllocTransformValue> values,
                        unsigned position) {
  return llvm::any_of(set.members, [&](unsigned valueId) {
    return valueLiveBeforeAtPosition(values[valueId], position);
  });
}

static bool
liveValuesCanRelieveAtPosition(ArrayRef<ResolvedRegAllocValue> resolvedValues,
                               unsigned position) {
  return llvm::all_of(resolvedValues, [position](ResolvedRegAllocValue value) {
    const wave::RegAllocTransformValue &stateValue = *value.second;
    if (!valueLiveAtPosition(stateValue, position))
      return true;
    return valueLiveBeforeAtPosition(stateValue, position);
  });
}

static bool hasRegAllocTransformClass(Value value,
                                      waveamdmachine::RegClass regClass) {
  auto type = dyn_cast<waveamdmachine::RegType>(value.getType());
  return type && type.getRegClass() == regClass;
}

static void setRegAllocTransformClass(Value value,
                                      waveamdmachine::RegClass regClass) {
  auto type = dyn_cast<waveamdmachine::RegType>(value.getType());
  if (!type)
    return;
  value.setType(waveamdmachine::RegType::get(type.getContext(), regClass,
                                             type.getWidth(), /*index=*/-1));
}

static bool isMFMAInputUse(waveamdmachine::MMAOpInterface mfma,
                           OpOperand &use) {
  return &use == &mfma.getAMutable() || &use == &mfma.getBMutable();
}

static bool isMFMAAccumulatorUse(waveamdmachine::MMAOpInterface mfma,
                                 OpOperand &use) {
  return &use == &mfma.getAccMutable();
}

static bool canDefineAGPR(Value value, const DenseSet<Value> &groupValues) {
  if (auto arg = dyn_cast<BlockArgument>(value))
    return isa_and_nonnull<waveamdmachine::UniformLoopOp>(
        arg.getOwner()->getParentOp());
  Operation *def = value.getDefiningOp();
  if (!def)
    return false;
  if (isa<waveamdmachine::UninitOp, waveamdmachine::UniformLoopOp>(def))
    return true;
  auto mma = dyn_cast<waveamdmachine::MMAOpInterface>(def);
  if (!mma)
    return false;
  Value acc = mma.getAcc();
  return hasRegAllocTransformClass(acc, waveamdmachine::RegClass::AGPR) ||
         groupValues.contains(acc);
}

static bool isTupleAliasOp(Operation *op) {
  return isa_and_nonnull<waveamdmachine::TupleToElementsOp,
                         waveamdmachine::TupleFromElementsOp>(op);
}

static bool isReliefGroupValue(Value value,
                               const DenseSet<Value> &groupValues) {
  return groupValues.contains(value);
}

static bool canRebankTupleAliasOp(Operation *op,
                                  const DenseSet<Value> &groupValues) {
  if (!isTupleAliasOp(op))
    return false;
  if (!llvm::all_of(op->getOperands(), [&](Value value) {
        return isReliefGroupValue(value, groupValues);
      }))
    return false;
  return llvm::all_of(op->getResults(), [&](Value value) {
    return isReliefGroupValue(value, groupValues);
  });
}

static void rebankTupleAliasResults(Operation *op,
                                    waveamdmachine::RegClass regClass) {
  if (!isTupleAliasOp(op))
    return;
  for (Value result : op->getResults())
    setRegAllocTransformClass(result, regClass);
}

static bool canConsumeAGPRAfterRelief(OpOperand &use,
                                      const DenseSet<Value> &groupValues) {
  Operation *user = use.getOwner();
  if (waveamdmachine::MMAOpInterface mfma =
          dyn_cast<waveamdmachine::MMAOpInterface>(user)) {
    if (isMFMAInputUse(mfma, use))
      return true;
    if (isMFMAAccumulatorUse(mfma, use) &&
        isReliefGroupValue(mfma.getAccResult(), groupValues))
      return true;
  }
  if (isStructuralLoopCarryUse(user))
    return true;
  if (canRebankTupleAliasOp(user, groupValues))
    return true;
  auto read = dyn_cast<waveamdmachine::VAccvgprReadB32TupleOp>(user);
  return read && use.getOperandNumber() == 0;
}

static bool
isAGPRReliefEligibleSet(const wave::RegAllocTransformAliasSet &set,
                        ArrayRef<wave::RegAllocTransformValue> values,
                        ArrayRef<ResolvedRegAllocValue> resolvedValues,
                        unsigned position) {
  if (set.regClass != waveamdmachine::RegClass::VGPR ||
      !setCanRelieveAtPosition(set, values, position) ||
      !liveValuesCanRelieveAtPosition(resolvedValues, position) ||
      hasFixedRegAllocValue(set, values))
    return false;
  return llvm::none_of(resolvedValues, [](ResolvedRegAllocValue resolved) {
    return isRegAllocTransformBridgeRelated(resolved.first);
  });
}

static int64_t getAGPRReliefLoopCostScale(Operation *op) {
  unsigned depth = 0;
  for (Operation *cur = op; cur; cur = cur->getParentOp())
    if (isa<waveamdmachine::UniformLoopOp>(cur))
      ++depth;
  if (depth == 0)
    return 1;
  return int64_t{1} << std::min<unsigned>(depth * 4, 20);
}

struct AGPRReliefBridgeCost {
  int64_t cost = 0;
  int64_t count = 0;
  int64_t loopCost = 0;

  void add(Operation *op) {
    ++count;
    int64_t scale = getAGPRReliefLoopCostScale(op);
    if (scale == 1)
      ++cost;
    else
      loopCost += scale;
  }
};

static AGPRReliefBridgeCost
getAGPRReliefBridgeCost(ArrayRef<ResolvedRegAllocValue> values,
                        const DenseSet<Value> &groupValues) {
  AGPRReliefBridgeCost cost;
  for (const ResolvedRegAllocValue &value : values) {
    Operation *def = value.first.getDefiningOp();
    if (def && !canDefineAGPR(value.first, groupValues) &&
        !canRebankTupleAliasOp(def, groupValues))
      cost.add(def);
    for (OpOperand &use : value.first.getUses()) {
      if (isa<waveamdmachine::VAccvgprWriteB32TupleOp>(use.getOwner()))
        continue;
      if (!canConsumeAGPRAfterRelief(use, groupValues))
        cost.add(use.getOwner());
    }
  }
  return cost;
}

static unsigned
getAGPRReliefLiveDwords(const wave::RegAllocTransformAliasSet &set,
                        ArrayRef<wave::RegAllocTransformValue> values,
                        unsigned position) {
  SmallVector<char, 8> live(set.width, 0);
  unsigned count = 0;
  for (unsigned valueId : set.members) {
    const wave::RegAllocTransformValue &value = values[valueId];
    if (!valueLiveAtPosition(value, position))
      continue;
    unsigned begin = static_cast<unsigned>(value.offset);
    if (begin >= set.width)
      continue;
    unsigned end = std::min<unsigned>(set.width, begin + value.width);
    for (unsigned lane : llvm::seq(begin, end)) {
      if (live[lane])
        continue;
      live[lane] = 1;
      ++count;
    }
  }
  return count;
}

static unsigned
getAGPRReliefEnd(const wave::RegAllocTransformAliasSet &set,
                 ArrayRef<wave::RegAllocTransformValue> values) {
  unsigned end = 0;
  for (unsigned valueId : set.members)
    end = std::max(end, values[valueId].end);
  return end;
}

static int64_t getAGPRReliefPrimaryCost(AGPRReliefScore score) {
  return score.bridgeCost + score.loopBridgeCost;
}

static AGPRReliefScore
getAGPRReliefScore(const wave::RegAllocTransformAliasSet &set,
                   ArrayRef<wave::RegAllocTransformValue> values,
                   ArrayRef<ResolvedRegAllocValue> resolvedValues,
                   unsigned position) {
  DenseSet<Value> groupValues;
  for (const ResolvedRegAllocValue &value : resolvedValues)
    groupValues.insert(value.first);
  AGPRReliefBridgeCost bridgeCost =
      getAGPRReliefBridgeCost(resolvedValues, groupValues);
  return {getAGPRReliefLiveDwords(set, values, position), bridgeCost.cost,
          bridgeCost.count, bridgeCost.loopCost, getAGPRReliefEnd(set, values)};
}

static bool isBetterAGPRReliefScore(AGPRReliefScore lhs, AGPRReliefScore rhs) {
  int64_t lhsCost = getAGPRReliefPrimaryCost(lhs);
  int64_t rhsCost = getAGPRReliefPrimaryCost(rhs);
  if (lhsCost != rhsCost)
    return lhsCost < rhsCost;
  if (lhs.bridgeCost != rhs.bridgeCost)
    return lhs.bridgeCost < rhs.bridgeCost;
  if (lhs.bridgeCount != rhs.bridgeCount)
    return lhs.bridgeCount < rhs.bridgeCount;
  if (lhs.loopBridgeCost != rhs.loopBridgeCost)
    return lhs.loopBridgeCost < rhs.loopBridgeCost;
  if (lhs.liveDwords != rhs.liveDwords)
    return lhs.liveDwords > rhs.liveDwords;
  return lhs.end > rhs.end;
}

static FailureOr<SmallVector<ResolvedRegAllocValue>>
getResolvedAGPRReliefSetValues(func::FuncOp func,
                               const wave::RegAllocTransformAliasSet &set,
                               ArrayRef<ResolvedRegAllocValue> resolvedValues) {
  SmallVector<ResolvedRegAllocValue> setValues;
  setValues.reserve(set.members.size());
  for (unsigned valueId : set.members) {
    if (valueId >= resolvedValues.size() ||
        resolvedValues[valueId].second->id != valueId)
      return func.emitError("regalloc state member value id is invalid");
    setValues.push_back(resolvedValues[valueId]);
  }
  return setValues;
}

static FailureOr<AGPRReliefSetIndex>
buildAGPRReliefSetIndex(func::FuncOp func,
                        ArrayRef<wave::RegAllocTransformAliasSet> sets) {
  AGPRReliefSetIndex index;
  for (const wave::RegAllocTransformAliasSet &set : sets) {
    auto inserted = index.setsById.insert({set.id, &set});
    if (!inserted.second) {
      func.emitError("regalloc state has duplicate alias set id");
      return failure();
    }
  }
  return std::move(index);
}

static FailureOr<std::optional<AGPRReliefCandidate>>
buildAGPRReliefCandidate(func::FuncOp func, unsigned setId,
                         const RegAllocTransformFailure &failureRecord,
                         const AGPRReliefSetIndex &setIndex,
                         ArrayRef<wave::RegAllocTransformAliasSet> sets,
                         ArrayRef<wave::RegAllocTransformValue> values,
                         ArrayRef<ResolvedRegAllocValue> resolvedValues) {
  const wave::RegAllocTransformAliasSet *set = setIndex.setsById.lookup(setId);
  if (!set)
    return std::optional<AGPRReliefCandidate>();
  FailureOr<SmallVector<ResolvedRegAllocValue>> setValues =
      getResolvedAGPRReliefSetValues(func, *set, resolvedValues);
  if (failed(setValues))
    return failure();
  if (!isAGPRReliefEligibleSet(*set, values, *setValues,
                               failureRecord.position))
    return std::optional<AGPRReliefCandidate>();
  unsigned agprFootprint = 0;
  if (!canAllocateAGPRReliefCandidate(func, *set, sets, values, agprFootprint))
    return std::optional<AGPRReliefCandidate>();
  FailureOr<bool> respectsFamilyBudget = respectsCombinedVGPRFamilyBudget(
      func, *set, failureRecord, sets, agprFootprint);
  if (failed(respectsFamilyBudget))
    return failure();
  if (!*respectsFamilyBudget)
    return std::optional<AGPRReliefCandidate>();

  AGPRReliefCandidate candidate;
  candidate.set = set;
  candidate.values = std::move(*setValues);
  candidate.score = getAGPRReliefScore(*set, values, candidate.values,
                                       failureRecord.position);
  return std::optional<AGPRReliefCandidate>(std::move(candidate));
}

static FailureOr<std::optional<AGPRReliefCandidate>>
selectAGPRReliefCandidate(func::FuncOp func,
                          const RegAllocTransformFailure &failureRecord,
                          const AGPRReliefSetIndex &setIndex,
                          ArrayRef<wave::RegAllocTransformAliasSet> sets,
                          ArrayRef<wave::RegAllocTransformValue> values,
                          ArrayRef<ResolvedRegAllocValue> resolvedValues) {
  std::optional<AGPRReliefCandidate> best;
  for (unsigned setId : collectVGPRReliefCandidateIds(failureRecord)) {
    FailureOr<std::optional<AGPRReliefCandidate>> candidate =
        buildAGPRReliefCandidate(func, setId, failureRecord, setIndex, sets,
                                 values, resolvedValues);
    if (failed(candidate))
      return failure();
    if (!*candidate)
      continue;
    if (!best || isBetterAGPRReliefScore((*candidate)->score, best->score) ||
        (!isBetterAGPRReliefScore(best->score, (*candidate)->score) &&
         (*candidate)->set->id < best->set->id))
      best = std::move(**candidate);
  }
  return best;
}

static waveamdmachine::RegType
getRegAllocTransformClassType(Value value, waveamdmachine::RegClass regClass) {
  auto type = cast<waveamdmachine::RegType>(value.getType());
  return waveamdmachine::RegType::get(type.getContext(), regClass,
                                      type.getWidth(), /*index=*/-1);
}

static waveamdmachine::VAccvgprWriteB32TupleOp
createAGPRReliefWrite(OpBuilder &builder, Value value) {
  if (Operation *def = value.getDefiningOp()) {
    builder.setInsertionPointAfter(def);
  } else {
    Block *block = cast<BlockArgument>(value).getOwner();
    builder.setInsertionPointToStart(block);
  }
  auto agprType =
      getRegAllocTransformClassType(value, waveamdmachine::RegClass::AGPR);
  auto write = waveamdmachine::VAccvgprWriteB32TupleOp::create(
      builder, value.getLoc(), agprType, value);
  write->setAttr("waveamdmachine.regalloc_debug_temp", builder.getUnitAttr());
  return write;
}

static Value createAGPRReliefRead(OpBuilder &builder, Value agpr,
                                  OpOperand &use) {
  builder.setInsertionPoint(use.getOwner());
  auto vgprType =
      getRegAllocTransformClassType(use.get(), waveamdmachine::RegClass::VGPR);
  auto read = waveamdmachine::VAccvgprReadB32TupleOp::create(
      builder, use.getOwner()->getLoc(), vgprType, agpr);
  read->setAttr("waveamdmachine.regalloc_debug_temp", builder.getUnitAttr());
  return read.getResult();
}

static Value getAGPRReliefReplacement(OpBuilder &builder, Value value,
                                      const DenseSet<Value> &groupValues,
                                      DenseMap<Value, Value> &replacements) {
  if (Value replacement = replacements.lookup(value))
    return replacement;
  if (hasRegAllocTransformClass(value, waveamdmachine::RegClass::AGPR)) {
    setRegAllocTransformClass(value, waveamdmachine::RegClass::AGPR);
    replacements[value] = value;
    return value;
  }
  if (Operation *def = value.getDefiningOp())
    if (canRebankTupleAliasOp(def, groupValues)) {
      setRegAllocTransformClass(value, waveamdmachine::RegClass::AGPR);
      rebankTupleAliasResults(def, waveamdmachine::RegClass::AGPR);
      replacements[value] = value;
      return value;
    }
  if (canDefineAGPR(value, groupValues)) {
    setRegAllocTransformClass(value, waveamdmachine::RegClass::AGPR);
    replacements[value] = value;
    return value;
  }
  Value replacement = createAGPRReliefWrite(builder, value).getResult();
  replacements[value] = replacement;
  return replacement;
}

static bool rewriteAGPRReliefAliasUse(OpOperand &use, Value agpr,
                                      const DenseSet<Value> &groupValues) {
  Operation *user = use.getOwner();
  if (!canRebankTupleAliasOp(user, groupValues))
    return false;
  use.set(agpr);
  rebankTupleAliasResults(user, waveamdmachine::RegClass::AGPR);
  return true;
}

static bool rewriteAGPRReliefMFMAUse(OpOperand &use, Value agpr,
                                     const DenseSet<Value> &groupValues) {
  auto mfma = dyn_cast<waveamdmachine::MMAOpInterface>(use.getOwner());
  if (!mfma)
    return false;
  if (isMFMAInputUse(mfma, use)) {
    use.set(agpr);
    return true;
  }
  if (!isMFMAAccumulatorUse(mfma, use) ||
      !isReliefGroupValue(mfma.getAccResult(), groupValues))
    return false;
  setRegAllocTransformClass(mfma.getAccResult(),
                            waveamdmachine::RegClass::AGPR);
  mfma.setAcc(agpr);
  return true;
}

static void rewriteAGPRReliefUse(OpBuilder &builder, OpOperand &use, Value agpr,
                                 const DenseSet<Value> &groupValues) {
  if (rewriteAGPRReliefAliasUse(use, agpr, groupValues))
    return;
  if (rewriteAGPRReliefMFMAUse(use, agpr, groupValues))
    return;
  if (isStructuralLoopCarryUse(use.getOwner())) {
    use.set(agpr);
    return;
  }
  use.set(createAGPRReliefRead(builder, agpr, use));
}

static void materializeAGPRReliefValue(OpBuilder &builder, Value value,
                                       const DenseSet<Value> &groupValues,
                                       DenseMap<Value, Value> &replacements) {
  Value agpr =
      getAGPRReliefReplacement(builder, value, groupValues, replacements);
  SmallVector<OpOperand *> uses;
  for (OpOperand &use : value.getUses())
    if (agpr == value || use.getOwner() != agpr.getDefiningOp())
      uses.push_back(&use);
  for (OpOperand *use : uses)
    if (use->get() == value)
      rewriteAGPRReliefUse(builder, *use, agpr, groupValues);
}

static void materializeAGPRRelief(OpBuilder &builder,
                                  const AGPRReliefCandidate &candidate) {
  DenseSet<Value> groupValues;
  DenseMap<Value, Value> replacements;
  for (const ResolvedRegAllocValue &value : candidate.values)
    groupValues.insert(value.first);
  for (const ResolvedRegAllocValue &value : candidate.values)
    materializeAGPRReliefValue(builder, value.first, groupValues, replacements);
}

static FailureOr<std::optional<AGPRReliefCandidate>>
selectAGPRReliefCandidateFromFunc(
    func::FuncOp func, const RegAllocTransformFailure &failureRecord) {
  FailureOr<llvm::AMDGPU::IsaVersion> isa =
      waveamdmachine::getAMDGPUTargetIsaVersion(
          func, "regalloc transform AGPR relief");
  if (failed(isa))
    return failure();
  if (!waveamdmachine::supportsAGPRs(*isa))
    return std::optional<AGPRReliefCandidate>();

  DictionaryAttr state = func->getAttrOfType<DictionaryAttr>(
      wave::getRegAllocTransformStateAttrName());
  FailureOr<SmallVector<wave::RegAllocTransformValue>> values =
      wave::parseRegAllocTransformValues(state, func.getOperation());
  if (failed(values))
    return failure();
  FailureOr<SmallVector<wave::RegAllocTransformAliasSet>> sets =
      wave::parseRegAllocTransformAliasSets(state, *values,
                                            func.getOperation());
  if (failed(sets))
    return failure();
  FailureOr<AGPRReliefSetIndex> setIndex = buildAGPRReliefSetIndex(func, *sets);
  if (failed(setIndex))
    return failure();
  FailureOr<SmallVector<ResolvedRegAllocValue>> resolvedValues =
      resolveRegAllocStateValues(func, *values);
  if (failed(resolvedValues))
    return failure();
  return selectAGPRReliefCandidate(func, failureRecord, *setIndex, *sets,
                                   *values, *resolvedValues);
}

static FailureOr<bool> shouldSkipAGPRRelief(func::FuncOp func) {
  FailureOr<std::optional<wave::RegAllocTransformBudget>> familyBudget =
      wave::getRegAllocTransformVGPRFamilyBudget(func);
  if (failed(familyBudget))
    return failure();
  if (!*familyBudget)
    return false;
  unsigned vgprLimit = wave::getRegAllocTransformDefaultBudgetLimit(
      waveamdmachine::RegClass::VGPR);
  return (*familyBudget)->limit <= vgprLimit;
}

static LogicalResult runRegAllocAGPRRelief(func::FuncOp func) {
  FailureOr<bool> skip = shouldSkipAGPRRelief(func);
  if (failed(skip))
    return failure();
  if (*skip)
    return success();

  FailureOr<std::optional<RegAllocTransformFailure>> failureRecord =
      parseRegAllocTransformFailure(func);
  if (failed(failureRecord))
    return failure();
  if (!*failureRecord)
    return success();
  if (!isAGPRRelievableFailure(**failureRecord))
    return success();
  if ((*failureRecord)->className == "vgpr_agpr")
    return success();

  FailureOr<std::optional<AGPRReliefCandidate>> candidate =
      selectAGPRReliefCandidateFromFunc(func, **failureRecord);
  if (failed(candidate))
    return failure();
  if (!*candidate)
    return success();

  OpBuilder builder(func.getContext());
  materializeAGPRRelief(builder, **candidate);
  func->removeAttr(wave::getRegAllocTransformAssignmentsAttrName());
  func->removeAttr(wave::getRegAllocTransformStateAttrName());
  return success();
}

} // namespace

LogicalResult wave::runRegAllocTransformAGPRRelief(Operation *target,
                                                   Builder &builder) {
  if (func::FuncOp func = dyn_cast<func::FuncOp>(target))
    return runRegAllocAGPRRelief(func);
  WalkResult walk = target->walk([&](func::FuncOp func) {
    return failed(runRegAllocAGPRRelief(func)) ? WalkResult::interrupt()
                                               : WalkResult::advance();
  });
  return failure(walk.wasInterrupted());
}
