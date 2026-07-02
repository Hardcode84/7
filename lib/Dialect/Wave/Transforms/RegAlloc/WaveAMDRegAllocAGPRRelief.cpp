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
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachineInstrInfo.h"
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
  unsigned promotedDwords = 0;
};

struct AGPRReliefSelection {
  AGPRReliefCandidate candidate;
  llvm::AMDGPU::IsaVersion isa;
};

struct AGPRReliefSetGroup {
  SmallVector<const wave::RegAllocTransformAliasSet *, 4> sets;
  const wave::RegAllocTransformAliasSet *primary = nullptr;
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

struct AGPRReliefFitState {
  SmallVector<AGPRReliefInterval> intervals;
  wave::RegAllocTransformBudget budget;
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

static bool lessAGPRReliefInterval(const AGPRReliefInterval &lhs,
                                   const AGPRReliefInterval &rhs) {
  return std::tie(lhs.start, lhs.id) < std::tie(rhs.start, rhs.id);
}

static bool assignAGPRReliefInterval(
    const AGPRReliefInterval &interval,
    SmallVectorImpl<wave::RegAllocTransformAssignment> &active, unsigned limit,
    unsigned &footprint) {
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
    return true;
  }
  std::optional<unsigned> base = findFreeAGPRBase(interval, active, limit);
  if (!base)
    return false;
  active.push_back({waveamdmachine::RegClass::AGPR, interval.id, *base,
                    interval.width, interval.start, interval.end});
  footprint = std::max(footprint, *base + interval.width);
  return true;
}

static bool
canAllocateAGPRReliefIntervals(ArrayRef<AGPRReliefInterval> intervals,
                               ArrayRef<AGPRReliefInterval> overlayIntervals,
                               unsigned limit, unsigned &footprint) {
  SmallVector<wave::RegAllocTransformAssignment> active;
  footprint = 0;
  size_t index = 0;
  size_t overlayIndex = 0;
  while (index < intervals.size() || overlayIndex < overlayIntervals.size()) {
    bool useOverlay = index == intervals.size() ||
                      (overlayIndex < overlayIntervals.size() &&
                       lessAGPRReliefInterval(overlayIntervals[overlayIndex],
                                              intervals[index]));
    const AGPRReliefInterval &interval =
        useOverlay ? overlayIntervals[overlayIndex++] : intervals[index++];
    if (!assignAGPRReliefInterval(interval, active, limit, footprint))
      return false;
  }
  return !overlayIntervals.empty();
}

static void
addAGPRReliefIntervals(SmallVectorImpl<AGPRReliefInterval> &intervals,
                       const wave::RegAllocTransformAliasSet &set,
                       std::optional<unsigned> fixedBase) {
  for (wave::RegAllocTransformLiveRange range : set.ranges)
    intervals.push_back({fixedBase, set.id, range.start, range.end, set.width});
}

static AGPRReliefFitState
buildAGPRReliefFitState(func::FuncOp func,
                        ArrayRef<wave::RegAllocTransformAliasSet> sets,
                        ArrayRef<wave::RegAllocTransformValue> values) {
  AGPRReliefFitState state;
  state.budget =
      wave::getRegAllocTransformBudget(func, waveamdmachine::RegClass::AGPR);
  for (const wave::RegAllocTransformAliasSet &set : sets) {
    if (set.regClass != waveamdmachine::RegClass::AGPR)
      continue;
    addAGPRReliefIntervals(state.intervals, set,
                           getRegAllocTransformFixedBase(set, values));
  }
  llvm::stable_sort(state.intervals, lessAGPRReliefInterval);
  return state;
}

static bool canAllocateAGPRReliefCandidate(const AGPRReliefSetGroup &candidate,
                                           const AGPRReliefFitState &fitState,
                                           unsigned &agprFootprint) {
  SmallVector<AGPRReliefInterval, 8> overlayIntervals;
  for (const wave::RegAllocTransformAliasSet *set : candidate.sets)
    addAGPRReliefIntervals(overlayIntervals, *set, std::nullopt);
  llvm::stable_sort(overlayIntervals, lessAGPRReliefInterval);
  return canAllocateAGPRReliefIntervals(fitState.intervals, overlayIntervals,
                                        fitState.budget.limit, agprFootprint);
}

static bool
containsAGPRReliefSet(ArrayRef<const wave::RegAllocTransformAliasSet *> sets,
                      unsigned setId) {
  return llvm::any_of(sets,
                      [setId](const wave::RegAllocTransformAliasSet *set) {
                        return set->id == setId;
                      });
}

static unsigned getVGPRFootprintAfterRemovingSets(
    ArrayRef<wave::RegAllocTransformAssignment> assignments,
    ArrayRef<const wave::RegAllocTransformAliasSet *> removedSets) {
  unsigned footprint = 0;
  for (const wave::RegAllocTransformAssignment &assignment : assignments) {
    if (assignment.regClass != waveamdmachine::RegClass::VGPR ||
        containsAGPRReliefSet(removedSets, assignment.set))
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
    func::FuncOp func, const AGPRReliefSetGroup &candidate,
    const RegAllocTransformFailure &failureRecord,
    const AGPRReliefSetIndex &setIndex, unsigned agprFootprint) {
  FailureOr<std::optional<wave::RegAllocTransformBudget>> familyBudget =
      wave::getRegAllocTransformVGPRFamilyBudget(func);
  if (failed(familyBudget))
    return failure();
  if (!*familyBudget)
    return true;

  unsigned vgprFootprint =
      getVGPRFootprintAfterRemovingSets(failureRecord.overlaps, candidate.sets);
  if (!containsAGPRReliefSet(candidate.sets, failureRecord.set)) {
    const wave::RegAllocTransformAssignment *moved =
        findFailureOverlap(failureRecord, candidate.primary->id);
    if (!moved)
      return false;
    const wave::RegAllocTransformAliasSet *request =
        setIndex.setsById.lookup(failureRecord.set);
    if (!request || request->width > moved->width)
      return false;
    vgprFootprint = std::max(getVGPRFootprintAfterRemovingSets(
                                 failureRecord.overlaps, candidate.sets),
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

static bool
canDefineAGPRThroughInterface(Value value,
                              const llvm::AMDGPU::IsaVersion &isaVersion) {
  auto result = dyn_cast<OpResult>(value);
  if (!result)
    return false;
  auto banking =
      dyn_cast<waveamdmachine::AGPRBankingOpInterface>(result.getOwner());
  return banking && banking.isResultAGPRValid(isaVersion, result);
}

static bool
canConsumeAGPRThroughInterface(OpOperand &use,
                               const llvm::AMDGPU::IsaVersion &isaVersion) {
  auto banking =
      dyn_cast<waveamdmachine::AGPRBankingOpInterface>(use.getOwner());
  return banking && banking.isOperandAGPRValid(isaVersion, use);
}

static bool canDefineAGPR(Value value, const DenseSet<Value> &groupValues,
                          const llvm::AMDGPU::IsaVersion &isaVersion) {
  if (auto arg = dyn_cast<BlockArgument>(value))
    return isa_and_nonnull<waveamdmachine::UniformLoopOp>(
        arg.getOwner()->getParentOp());
  Operation *def = value.getDefiningOp();
  if (!def)
    return false;
  if (isa<waveamdmachine::UninitOp, waveamdmachine::UniformLoopOp>(def))
    return true;
  if (canDefineAGPRThroughInterface(value, isaVersion))
    return true;
  auto mma = dyn_cast<waveamdmachine::MMAOpInterface>(def);
  if (!mma)
    return false;
  Value acc = mma.getAcc();
  return hasRegAllocTransformClass(acc, waveamdmachine::RegClass::AGPR) ||
         groupValues.contains(acc);
}

static bool isTupleAliasOp(Operation *op) {
  return op && op->hasTrait<OpTrait::waveamdmachine::TupleAliasOp>();
}

static bool isReliefGroupValue(Value value,
                               const DenseSet<Value> &groupValues) {
  return groupValues.contains(value);
}

static bool
isAGPRReliefReplacement(Value value,
                        const DenseMap<Value, Value> &replacements) {
  return llvm::any_of(replacements, [value](const auto &entry) {
    return entry.second == value;
  });
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

static bool canRebankTupleAliasOp(Operation *op,
                                  const DenseSet<Value> &groupValues,
                                  const DenseMap<Value, Value> &replacements) {
  if (!isTupleAliasOp(op))
    return false;
  auto canRebankValue = [&](Value value) {
    return isReliefGroupValue(value, groupValues) ||
           isAGPRReliefReplacement(value, replacements);
  };
  if (!llvm::all_of(op->getOperands(), canRebankValue))
    return false;
  return llvm::all_of(op->getResults(), canRebankValue);
}

static void rebankTupleAliasResults(Operation *op,
                                    waveamdmachine::RegClass regClass) {
  if (!isTupleAliasOp(op))
    return;
  for (Value result : op->getResults())
    setRegAllocTransformClass(result, regClass);
}

static bool
canConsumeAGPRAfterRelief(OpOperand &use, const DenseSet<Value> &groupValues,
                          const llvm::AMDGPU::IsaVersion &isaVersion) {
  Operation *user = use.getOwner();
  if (waveamdmachine::MMAOpInterface mfma =
          dyn_cast<waveamdmachine::MMAOpInterface>(user)) {
    if (isMFMAInputUse(mfma, use))
      return true;
    if (isMFMAAccumulatorUse(mfma, use) &&
        (hasRegAllocTransformClass(mfma.getAccResult(),
                                   waveamdmachine::RegClass::AGPR) ||
         isReliefGroupValue(mfma.getAccResult(), groupValues)))
      return true;
  }
  if (isStructuralLoopCarryUse(user))
    return true;
  if (canRebankTupleAliasOp(user, groupValues))
    return true;
  if (canConsumeAGPRThroughInterface(use, isaVersion))
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
                        const DenseSet<Value> &groupValues,
                        const llvm::AMDGPU::IsaVersion &isaVersion) {
  AGPRReliefBridgeCost cost;
  for (const ResolvedRegAllocValue &value : values) {
    Operation *def = value.first.getDefiningOp();
    if (def && !canDefineAGPR(value.first, groupValues, isaVersion) &&
        !canRebankTupleAliasOp(def, groupValues))
      cost.add(def);
    for (OpOperand &use : value.first.getUses()) {
      if (isa<waveamdmachine::VAccvgprWriteB32TupleOp>(use.getOwner()))
        continue;
      if (!canConsumeAGPRAfterRelief(use, groupValues, isaVersion))
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
getAGPRReliefScore(const AGPRReliefSetGroup &group,
                   ArrayRef<wave::RegAllocTransformValue> values,
                   ArrayRef<ResolvedRegAllocValue> resolvedValues,
                   unsigned position,
                   const llvm::AMDGPU::IsaVersion &isaVersion) {
  DenseSet<Value> groupValues;
  for (const ResolvedRegAllocValue &value : resolvedValues)
    groupValues.insert(value.first);
  AGPRReliefBridgeCost bridgeCost =
      getAGPRReliefBridgeCost(resolvedValues, groupValues, isaVersion);
  unsigned liveDwords = 0;
  unsigned end = 0;
  for (const wave::RegAllocTransformAliasSet *set : group.sets) {
    liveDwords += getAGPRReliefLiveDwords(*set, values, position);
    end = std::max(end, getAGPRReliefEnd(*set, values));
  }
  return {liveDwords, bridgeCost.cost, bridgeCost.count, bridgeCost.loopCost,
          end};
}

static unsigned getAGPRReliefPromotedDwords(const AGPRReliefSetGroup &group) {
  unsigned dwords = 0;
  for (const wave::RegAllocTransformAliasSet *set : group.sets)
    dwords += set->width;
  return dwords;
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

static DenseMap<Value, unsigned>
buildAGPRReliefValueIndex(ArrayRef<ResolvedRegAllocValue> resolvedValues) {
  DenseMap<Value, unsigned> index;
  index.reserve(resolvedValues.size());
  for (auto [valueId, resolved] : llvm::enumerate(resolvedValues))
    index[resolved.first] = valueId;
  return index;
}

static std::optional<unsigned>
lookupAGPRReliefSetId(Value value, const DenseMap<Value, unsigned> &valueIndex,
                      ArrayRef<wave::RegAllocTransformValue> values) {
  auto it = valueIndex.find(value);
  if (it == valueIndex.end() || it->second >= values.size())
    return std::nullopt;
  return values[it->second].set;
}

static void
addAGPRReliefPartnerSet(Value value, const AGPRReliefSetIndex &setIndex,
                        const DenseMap<Value, unsigned> &valueIndex,
                        ArrayRef<wave::RegAllocTransformValue> values,
                        DenseSet<unsigned> &seen,
                        SmallVectorImpl<unsigned> &worklist) {
  std::optional<unsigned> setId =
      lookupAGPRReliefSetId(value, valueIndex, values);
  if (!setId)
    return;
  const wave::RegAllocTransformAliasSet *set = setIndex.setsById.lookup(*setId);
  if (!set || set->regClass != waveamdmachine::RegClass::VGPR)
    return;
  if (seen.insert(set->id).second)
    worklist.push_back(set->id);
}

static void collectMFMAAGPRReliefPartnerSets(
    Value value, const AGPRReliefSetIndex &setIndex,
    const DenseMap<Value, unsigned> &valueIndex,
    ArrayRef<wave::RegAllocTransformValue> values, DenseSet<unsigned> &seen,
    SmallVectorImpl<unsigned> &worklist) {
  if (Operation *def = value.getDefiningOp()) {
    auto mfma = dyn_cast<waveamdmachine::MMAOpInterface>(def);
    if (mfma && def->hasTrait<OpTrait::waveamdmachine::MFMAOp>() &&
        mfma.getAccResult() == value)
      addAGPRReliefPartnerSet(mfma.getAcc(), setIndex, valueIndex, values, seen,
                              worklist);
  }
  for (OpOperand &use : value.getUses()) {
    auto mfma = dyn_cast<waveamdmachine::MMAOpInterface>(use.getOwner());
    if (!mfma || !use.getOwner()->hasTrait<OpTrait::waveamdmachine::MFMAOp>() ||
        !isMFMAAccumulatorUse(mfma, use))
      continue;
    addAGPRReliefPartnerSet(mfma.getAccResult(), setIndex, valueIndex, values,
                            seen, worklist);
  }
}

static AGPRReliefSetGroup
buildAGPRReliefSetGroup(const wave::RegAllocTransformAliasSet &primary,
                        const AGPRReliefSetIndex &setIndex,
                        ArrayRef<wave::RegAllocTransformAliasSet> sets,
                        ArrayRef<wave::RegAllocTransformValue> values,
                        ArrayRef<ResolvedRegAllocValue> resolvedValues,
                        const DenseMap<Value, unsigned> &valueIndex) {
  DenseSet<unsigned> seen;
  SmallVector<unsigned, 4> worklist;
  seen.insert(primary.id);
  worklist.push_back(primary.id);
  for (unsigned cursor = 0; cursor < worklist.size(); ++cursor) {
    const wave::RegAllocTransformAliasSet *set =
        setIndex.setsById.lookup(worklist[cursor]);
    if (!set)
      continue;
    for (unsigned valueId : set->members)
      collectMFMAAGPRReliefPartnerSets(resolvedValues[valueId].first, setIndex,
                                       valueIndex, values, seen, worklist);
  }

  AGPRReliefSetGroup group;
  group.primary = &primary;
  for (const wave::RegAllocTransformAliasSet &set : sets)
    if (seen.contains(set.id))
      group.sets.push_back(&set);
  return group;
}

static bool
isAGPRReliefCompatibleSet(const wave::RegAllocTransformAliasSet &set,
                          ArrayRef<wave::RegAllocTransformValue> values,
                          ArrayRef<ResolvedRegAllocValue> resolvedValues) {
  if (set.regClass != waveamdmachine::RegClass::VGPR ||
      hasFixedRegAllocValue(set, values))
    return false;
  return llvm::none_of(resolvedValues, [](ResolvedRegAllocValue resolved) {
    return isRegAllocTransformBridgeRelated(resolved.first);
  });
}

static FailureOr<std::optional<AGPRReliefCandidate>>
buildAGPRReliefCandidate(func::FuncOp func, unsigned setId,
                         const RegAllocTransformFailure &failureRecord,
                         const AGPRReliefSetIndex &setIndex,
                         const AGPRReliefFitState &fitState,
                         ArrayRef<wave::RegAllocTransformAliasSet> sets,
                         ArrayRef<wave::RegAllocTransformValue> values,
                         ArrayRef<ResolvedRegAllocValue> resolvedValues,
                         const DenseMap<Value, unsigned> &valueIndex,
                         const llvm::AMDGPU::IsaVersion &isaVersion) {
  const wave::RegAllocTransformAliasSet *set = setIndex.setsById.lookup(setId);
  if (!set)
    return std::optional<AGPRReliefCandidate>();
  AGPRReliefSetGroup group = buildAGPRReliefSetGroup(
      *set, setIndex, sets, values, resolvedValues, valueIndex);
  SmallVector<ResolvedRegAllocValue> groupValues;
  for (const wave::RegAllocTransformAliasSet *groupSet : group.sets) {
    FailureOr<SmallVector<ResolvedRegAllocValue>> setValues =
        getResolvedAGPRReliefSetValues(func, *groupSet, resolvedValues);
    if (failed(setValues))
      return failure();
    bool eligible =
        groupSet == group.primary
            ? isAGPRReliefEligibleSet(*groupSet, values, *setValues,
                                      failureRecord.position)
            : isAGPRReliefCompatibleSet(*groupSet, values, *setValues);
    if (!eligible)
      return std::optional<AGPRReliefCandidate>();
    groupValues.append(setValues->begin(), setValues->end());
  }
  if (groupValues.empty())
    return std::optional<AGPRReliefCandidate>();
  unsigned agprFootprint = 0;
  if (!canAllocateAGPRReliefCandidate(group, fitState, agprFootprint))
    return std::optional<AGPRReliefCandidate>();
  FailureOr<bool> respectsFamilyBudget = respectsCombinedVGPRFamilyBudget(
      func, group, failureRecord, setIndex, agprFootprint);
  if (failed(respectsFamilyBudget))
    return failure();
  if (!*respectsFamilyBudget)
    return std::optional<AGPRReliefCandidate>();

  AGPRReliefScore score = getAGPRReliefScore(
      group, values, groupValues, failureRecord.position, isaVersion);
  AGPRReliefCandidate candidate;
  candidate.set = set;
  candidate.values = std::move(groupValues);
  candidate.score = score;
  candidate.promotedDwords = getAGPRReliefPromotedDwords(group);
  return std::optional<AGPRReliefCandidate>(std::move(candidate));
}

static FailureOr<std::optional<AGPRReliefCandidate>> selectAGPRReliefCandidate(
    func::FuncOp func, const RegAllocTransformFailure &failureRecord,
    const AGPRReliefSetIndex &setIndex, const AGPRReliefFitState &fitState,
    ArrayRef<wave::RegAllocTransformAliasSet> sets,
    ArrayRef<wave::RegAllocTransformValue> values,
    ArrayRef<ResolvedRegAllocValue> resolvedValues,
    const DenseMap<Value, unsigned> &valueIndex,
    const llvm::AMDGPU::IsaVersion &isaVersion) {
  std::optional<AGPRReliefCandidate> best;
  for (unsigned setId : collectVGPRReliefCandidateIds(failureRecord)) {
    FailureOr<std::optional<AGPRReliefCandidate>> candidate =
        buildAGPRReliefCandidate(func, setId, failureRecord, setIndex, fitState,
                                 sets, values, resolvedValues, valueIndex,
                                 isaVersion);
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

static Value getAGPRReliefWriteSource(Value value) {
  auto mov = value.getDefiningOp<waveamdmachine::VMovB32TupleOp>();
  if (!mov)
    return value;
  Value source = mov.getSource();
  if (waveamdmachine::isInlineImm32(source))
    return source;
  return value;
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
  Value source = getAGPRReliefWriteSource(value);
  auto write = waveamdmachine::VAccvgprWriteB32TupleOp::create(
      builder, value.getLoc(), agprType, source);
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

static Value
getAGPRReliefReplacement(OpBuilder &builder, Value value,
                         const DenseSet<Value> &groupValues,
                         DenseMap<Value, Value> &replacements,
                         const llvm::AMDGPU::IsaVersion &isaVersion) {
  if (Value replacement = replacements.lookup(value))
    return replacement;
  if (hasRegAllocTransformClass(value, waveamdmachine::RegClass::AGPR)) {
    setRegAllocTransformClass(value, waveamdmachine::RegClass::AGPR);
    replacements[value] = value;
    return value;
  }
  if (Operation *def = value.getDefiningOp())
    if (canRebankTupleAliasOp(def, groupValues, replacements)) {
      setRegAllocTransformClass(value, waveamdmachine::RegClass::AGPR);
      rebankTupleAliasResults(def, waveamdmachine::RegClass::AGPR);
      replacements[value] = value;
      return value;
    }
  if (canDefineAGPR(value, groupValues, isaVersion)) {
    setRegAllocTransformClass(value, waveamdmachine::RegClass::AGPR);
    replacements[value] = value;
    return value;
  }
  Value replacement = createAGPRReliefWrite(builder, value).getResult();
  replacements[value] = replacement;
  return replacement;
}

static bool
rewriteAGPRReliefAliasUse(OpOperand &use, Value agpr,
                          const DenseSet<Value> &groupValues,
                          const DenseMap<Value, Value> &replacements) {
  Operation *user = use.getOwner();
  if (!canRebankTupleAliasOp(user, groupValues, replacements))
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
      (!hasRegAllocTransformClass(mfma.getAccResult(),
                                  waveamdmachine::RegClass::AGPR) &&
       !isReliefGroupValue(mfma.getAccResult(), groupValues)))
    return false;
  setRegAllocTransformClass(mfma.getAccResult(),
                            waveamdmachine::RegClass::AGPR);
  mfma.setAcc(agpr);
  return true;
}

static void rewriteAGPRReliefUse(OpBuilder &builder, OpOperand &use, Value agpr,
                                 const DenseSet<Value> &groupValues,
                                 const DenseMap<Value, Value> &replacements,
                                 const llvm::AMDGPU::IsaVersion &isaVersion) {
  if (rewriteAGPRReliefAliasUse(use, agpr, groupValues, replacements))
    return;
  if (rewriteAGPRReliefMFMAUse(use, agpr, groupValues))
    return;
  if (isStructuralLoopCarryUse(use.getOwner())) {
    use.set(agpr);
    return;
  }
  if (canConsumeAGPRThroughInterface(use, isaVersion)) {
    use.set(agpr);
    return;
  }
  use.set(createAGPRReliefRead(builder, agpr, use));
}

static void
materializeAGPRReliefValue(OpBuilder &builder, Value value,
                           const DenseSet<Value> &groupValues,
                           DenseMap<Value, Value> &replacements,
                           const llvm::AMDGPU::IsaVersion &isaVersion) {
  Value agpr = getAGPRReliefReplacement(builder, value, groupValues,
                                        replacements, isaVersion);
  SmallVector<OpOperand *> uses;
  for (OpOperand &use : value.getUses())
    if (agpr == value || use.getOwner() != agpr.getDefiningOp())
      uses.push_back(&use);
  for (OpOperand *use : uses)
    if (use->get() == value)
      rewriteAGPRReliefUse(builder, *use, agpr, groupValues, replacements,
                           isaVersion);
}

static void materializeAGPRRelief(OpBuilder &builder,
                                  const AGPRReliefCandidate &candidate,
                                  const llvm::AMDGPU::IsaVersion &isaVersion) {
  DenseSet<Value> groupValues;
  DenseMap<Value, Value> replacements;
  for (const ResolvedRegAllocValue &value : candidate.values)
    groupValues.insert(value.first);
  for (const ResolvedRegAllocValue &value : candidate.values)
    materializeAGPRReliefValue(builder, value.first, groupValues, replacements,
                               isaVersion);
}

static unsigned countAGPRReliefDwords(const AGPRReliefCandidate &candidate) {
  return candidate.promotedDwords;
}

static FailureOr<std::optional<AGPRReliefSelection>>
selectAGPRReliefCandidateFromFunc(
    func::FuncOp func, const RegAllocTransformFailure &failureRecord) {
  FailureOr<llvm::AMDGPU::IsaVersion> isaVersion =
      waveamdmachine::getAMDGPUTargetIsaVersion(
          func, "regalloc transform AGPR relief");
  if (failed(isaVersion))
    return failure();
  if (!waveamdmachine::supportsAGPRs(*isaVersion))
    return std::optional<AGPRReliefSelection>();

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
  AGPRReliefFitState fitState = buildAGPRReliefFitState(func, *sets, *values);
  FailureOr<SmallVector<ResolvedRegAllocValue>> resolvedValues =
      resolveRegAllocStateValues(func, *values);
  if (failed(resolvedValues))
    return failure();
  DenseMap<Value, unsigned> valueIndex =
      buildAGPRReliefValueIndex(*resolvedValues);
  FailureOr<std::optional<AGPRReliefCandidate>> candidate =
      selectAGPRReliefCandidate(func, failureRecord, *setIndex, fitState, *sets,
                                *values, *resolvedValues, valueIndex,
                                *isaVersion);
  if (failed(candidate))
    return failure();
  if (!*candidate)
    return std::optional<AGPRReliefSelection>();
  return std::optional<AGPRReliefSelection>(
      AGPRReliefSelection{std::move(**candidate), *isaVersion});
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

  FailureOr<std::optional<AGPRReliefSelection>> selection =
      selectAGPRReliefCandidateFromFunc(func, **failureRecord);
  if (failed(selection))
    return failure();
  if (!*selection)
    return success();

  OpBuilder builder(func.getContext());
  const AGPRReliefCandidate &candidate = (*selection)->candidate;
  materializeAGPRRelief(builder, candidate, (*selection)->isa);
  if (failed(wave::addRegAllocTransformProviderMetadata(
          func, builder, "agpr", countAGPRReliefDwords(candidate))))
    return failure();
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
