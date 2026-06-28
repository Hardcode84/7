//===- WaveAMDRegAllocMemoryReliefUtils.h - Memory relief utils -*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef MLIR_DIALECT_WAVE_TRANSFORMS_WAVEAMDREGALLOCMEMORYRELIEFUTILS_H
#define MLIR_DIALECT_WAVE_TRANSFORMS_WAVEAMDREGALLOCMEMORYRELIEFUTILS_H

#include "WaveAMDRegAllocInternal.h"
#include "WaveAMDRegAllocTransformState.h"
#include "WaveAMDRegAllocTransformUtils.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachine.h"
#include "mlir/IR/Builders.h"
#include "mlir/IR/IRMapping.h"
#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/DenseSet.h"
#include "llvm/ADT/STLExtras.h"
#include <iterator>
#include <optional>

namespace mlir::wave::regalloc_detail {

template <typename PlanT> struct MemoryReliefSlot {
  SmallVector<OpOperand *> uses;
  PlanT plan;
  Value value;
  waveamdmachine::RegType type;
  const wave::RegAllocTransformValue *stateValue = nullptr;
  std::optional<wave::regalloc::MemorySpillLoopCarrySlot> loopCarry;
  int64_t cost = 0;
};

template <typename SlotT> struct MemoryReliefCandidate {
  SmallVector<SlotT, 4> slots;
  const wave::RegAllocTransformAliasSet *set = nullptr;
  int64_t cost = 0;
  unsigned reservedBytes = 0;
};

template <typename SlotT> struct MemoryStoredSlot {
  const SlotT *slot = nullptr;
  Value token;
};

struct MemoryReliefSetIndex {
  llvm::SmallDenseMap<unsigned, const wave::RegAllocTransformAliasSet *, 1024>
      setsById;
};

struct MemoryReliefValueIndex {
  ArrayRef<ResolvedRegAllocValue> valuesById;
};

struct MemoryReliefSetEligibilityCache {
  llvm::SmallDenseMap<unsigned, bool, 1024> candidateBySetId;
};

struct LDSReliefPlanningState {
  wave::regalloc::RegisterBudgets budgets;
  wave::regalloc::LDSSpillPlanningInfo ldsPlanning;
  unsigned committedBytes = 0;
  unsigned fixedLDS = 0;
  unsigned dynamicLDS = 0;
};

struct ScratchReliefPlanningState {
  unsigned committedBytes = 0;
  unsigned existingPrivateBytes = 0;
};

using LDSReliefPlan = SmallVector<wave::regalloc::LDSSpillPlan, 4>;
using LDSReliefSlot = MemoryReliefSlot<LDSReliefPlan>;
using LDSReliefCandidate = MemoryReliefCandidate<LDSReliefSlot>;
using ScratchReliefSlot = MemoryReliefSlot<wave::regalloc::ScratchSpillPlan>;
using ScratchReliefCandidate = MemoryReliefCandidate<ScratchReliefSlot>;

static bool isRegAllocTransformTempOp(Operation *op) {
  return op && op->hasAttr(wave::regalloc::kRegAllocTempAttr);
}

static bool isRegAllocTransformTempValue(Value value) {
  return isRegAllocTransformTempOp(value.getDefiningOp());
}

static bool opUsesValue(Operation *op, Value value) {
  bool found = false;
  op->walk([&](Operation *nested) {
    if (llvm::is_contained(nested->getOperands(), value)) {
      found = true;
      return WalkResult::interrupt();
    }
    return WalkResult::advance();
  });
  return found;
}

static bool
isInternalPlannedTupleFromElementsUse(OpOperand *use,
                                      const DenseSet<Value> &plannedValues) {
  auto fromElements =
      dyn_cast<waveamdmachine::TupleFromElementsOp>(use->getOwner());
  return fromElements && plannedValues.contains(fromElements.getTuple());
}

static FailureOr<SmallVector<OpOperand *>> collectMemoryReliefUses(
    Value value, const RegAllocTransformFailure &failureRecord,
    const RematReliefContext &context, const DenseSet<Value> &plannedValues) {
  SmallVector<OpOperand *> uses;
  for (OpOperand &use : value.getUses()) {
    Operation *user = use.getOwner();
    if (isRegAllocTransformTempOp(user))
      continue;
    if (isa<waveamdmachine::ContinueIfOp>(user)) {
      uses.clear();
      return uses;
    }
    std::optional<unsigned> position = getRematOpPosition(user, context);
    if (!position)
      return failure();
    if (*position == failureRecord.position) {
      uses.clear();
      return uses;
    }
    if (*position > failureRecord.position &&
        !isInternalPlannedTupleFromElementsUse(&use, plannedValues))
      uses.push_back(&use);
  }
  llvm::stable_sort(uses, [&](OpOperand *lhs, OpOperand *rhs) {
    return context.positions.lookup(lhs->getOwner()) <
           context.positions.lookup(rhs->getOwner());
  });
  return uses;
}

static bool
computeMemoryReliefCandidateSet(const wave::RegAllocTransformAliasSet &set,
                                ArrayRef<wave::RegAllocTransformValue> values,
                                unsigned position) {
  if (set.regClass != waveamdmachine::RegClass::VGPR)
    return false;

  bool liveAcrossFailure = false;
  for (unsigned valueId : set.members) {
    const wave::RegAllocTransformValue &value = values[valueId];
    if (value.fixed)
      return false;
    if (!liveAcrossFailure)
      liveAcrossFailure = valueLiveAcrossPosition(value, position);
  }
  return liveAcrossFailure;
}

static bool
isMemoryReliefCandidateSet(const wave::RegAllocTransformAliasSet &set,
                           ArrayRef<wave::RegAllocTransformValue> values,
                           unsigned position,
                           MemoryReliefSetEligibilityCache &cache) {
  llvm::SmallDenseMap<unsigned, bool, 1024>::iterator cached =
      cache.candidateBySetId.find(set.id);
  if (cached != cache.candidateBySetId.end())
    return cached->second;

  bool candidate = computeMemoryReliefCandidateSet(set, values, position);
  cache.candidateBySetId.insert({set.id, candidate});
  return candidate;
}

static bool
isMemoryValueLiveAcrossFailure(const wave::RegAllocTransformValue &stateValue,
                               unsigned position) {
  return valueLiveAcrossPosition(stateValue, position);
}

static void addPlannedMemoryReliefValues(ArrayRef<ResolvedRegAllocValue> values,
                                         unsigned position,
                                         DenseSet<Value> &plannedValues) {
  for (ResolvedRegAllocValue resolved : values)
    if (isMemoryValueLiveAcrossFailure(*resolved.second, position))
      plannedValues.insert(resolved.first);
}

static Operation *getValueAnchorOp(Value value) {
  if (Operation *def = value.getDefiningOp())
    return def;
  auto arg = cast<BlockArgument>(value);
  return arg.getOwner()->getParentOp();
}

static int64_t getMemoryLoopCarryInitStoreCost(
    Value init, wave::regalloc::MemorySpillLoopCarrySlot loopCarry,
    unsigned accessOps) {
  OpOperand *loopUse = &loopCarry.loop.getInitsMutable()[loopCarry.index];
  Operation *anchor = wave::regalloc::getLoopCarryInitStoreDiagOp(
      init, loopUse, loopCarry.loop);
  return accessOps * getMemoryBridgeCostScale(
                         anchor, anchor == loopCarry.loop.getOperation());
}

static int64_t getMemoryLoopCarryExtraInitUseCost(
    Value init, wave::regalloc::MemorySpillLoopCarrySlot loopCarry,
    unsigned accessOps) {
  OpOperand *loopUse = &loopCarry.loop.getInitsMutable()[loopCarry.index];
  int64_t cost = 0;
  for (OpOperand &use : init.getUses()) {
    Operation *user = use.getOwner();
    if (&use == loopUse || isRegAllocTransformTempOp(user))
      continue;
    if (!wave::regalloc::canRewriteExtraLoopInitUse(use, loopUse,
                                                    loopCarry.loop))
      continue;
    cost += accessOps * getMemoryBridgeCostScale(user, /*beforeAnchor=*/true);
  }
  return cost;
}

static int64_t getMemoryLoopCarryBodyUseCost(
    wave::regalloc::MemorySpillLoopCarrySlot loopCarry, unsigned accessOps) {
  Block &body = loopCarry.loop.getBody().front();
  BlockArgument arg = body.getArgument(loopCarry.index);
  llvm::SmallDenseSet<Operation *, 8> users;
  int64_t cost = 0;
  for (OpOperand &use : arg.getUses()) {
    if (isa<waveamdmachine::ContinueIfOp>(use.getOwner()))
      continue;
    Operation *anchor =
        wave::regalloc::getAncestorInBlock(use.getOwner(), &body);
    if (!anchor || !users.insert(anchor).second)
      continue;
    cost += accessOps * getMemoryBridgeCostScale(anchor, /*beforeAnchor=*/true);
  }
  return cost;
}

static int64_t getMemoryLoopCarryTerminatorStoreCost(
    wave::regalloc::MemorySpillLoopCarrySlot loopCarry, unsigned accessOps) {
  Block &body = loopCarry.loop.getBody().front();
  auto term = cast<waveamdmachine::ContinueIfOp>(body.getTerminator());
  BlockArgument arg = body.getArgument(loopCarry.index);
  if (term.getCarries()[loopCarry.index] == arg)
    return 0;
  return accessOps *
         getMemoryBridgeCostScale(term.getOperation(), /*beforeAnchor=*/true);
}

static int64_t getMemoryLoopCarryResultUseCost(
    wave::regalloc::MemorySpillLoopCarrySlot loopCarry, unsigned accessOps) {
  if (loopCarry.loop.getResult(loopCarry.index).use_empty())
    return 0;
  return accessOps * getParentLoopCostScale(loopCarry.loop.getOperation());
}

static int64_t
getMemoryLoopCarryReliefCost(Value init,
                             wave::regalloc::MemorySpillLoopCarrySlot loopCarry,
                             unsigned accessOps) {
  int64_t cost = getMemoryLoopCarryInitStoreCost(init, loopCarry, accessOps);
  cost += getMemoryLoopCarryExtraInitUseCost(init, loopCarry, accessOps);
  cost += getMemoryLoopCarryBodyUseCost(loopCarry, accessOps);
  cost += getMemoryLoopCarryTerminatorStoreCost(loopCarry, accessOps);
  cost += getMemoryLoopCarryResultUseCost(loopCarry, accessOps);
  return cost;
}

template <typename Traits>
static FailureOr<std::optional<typename Traits::Slot>>
buildMemoryReliefSlot(func::FuncOp func, Value value,
                      const wave::RegAllocTransformValue &stateValue,
                      const RegAllocTransformFailure &failureRecord,
                      const RematReliefContext &context,
                      const typename Traits::PlanningState &planning,
                      const DenseSet<Value> &plannedValues,
                      unsigned extraReservedBytes) {
  if (!isMemoryValueLiveAcrossFailure(stateValue, failureRecord.position) ||
      stateValue.fixed || isRegAllocTransformTempValue(value))
    return std::optional<typename Traits::Slot>();
  auto type = dyn_cast<waveamdmachine::RegType>(value.getType());
  if (!type || type.getRegClass() != waveamdmachine::RegClass::VGPR ||
      type.getWidth() == 0)
    return std::optional<typename Traits::Slot>();
  FailureOr<SmallVector<OpOperand *>> uses =
      collectMemoryReliefUses(value, failureRecord, context, plannedValues);
  if (failed(uses))
    return failure();
  if (uses->empty())
    return std::optional<typename Traits::Slot>();
  std::optional<typename Traits::Plan> plan =
      Traits::getPlanForValue(func, planning, type, extraReservedBytes);
  if (!plan)
    return std::optional<typename Traits::Slot>();
  typename Traits::Slot slot;
  slot.uses = std::move(*uses);
  slot.plan = std::move(*plan);
  slot.value = value;
  slot.type = type;
  slot.stateValue = &stateValue;
  slot.cost = Traits::getCost(value, slot.plan, type, slot.uses);
  return std::optional<typename Traits::Slot>(std::move(slot));
}

static std::optional<wave::regalloc::MemorySpillLoopCarrySlot>
getMemoryReliefLoopCarrySlot(ArrayRef<ResolvedRegAllocValue> values) {
  std::optional<wave::regalloc::MemorySpillLoopCarrySlot> slot;
  for (ResolvedRegAllocValue resolved : values)
    if (failed(wave::regalloc::mergeLoopCarrySlot(resolved.first, slot)))
      return std::nullopt;
  return slot;
}

static const wave::RegAllocTransformValue *
findMemoryReliefStateValue(ArrayRef<ResolvedRegAllocValue> values,
                           Value value) {
  for (ResolvedRegAllocValue resolved : values)
    if (resolved.first == value)
      return resolved.second;
  return nullptr;
}

static bool
canStoreLoopCarryBeforeFailure(wave::regalloc::MemorySpillLoopCarrySlot slot,
                               Value init,
                               const RegAllocTransformFailure &failureRecord,
                               const RematReliefContext &context) {
  OpOperand *loopUse = &slot.loop.getInitsMutable()[slot.index];
  Operation *storeAnchor =
      wave::regalloc::getLoopCarryInitStoreDiagOp(init, loopUse, slot.loop);
  std::optional<unsigned> storePosition =
      getRematOpPosition(storeAnchor, context);
  return storePosition && *storePosition < failureRecord.position;
}

static bool canMaterializeMemoryLoopCarryRelief(
    wave::regalloc::MemorySpillLoopCarrySlot slot, Value init,
    const RegAllocTransformFailure &failureRecord,
    const RematReliefContext &context) {
  return canStoreLoopCarryBeforeFailure(slot, init, failureRecord, context) &&
         wave::regalloc::hasLocalLoopCarryUses(slot) &&
         wave::regalloc::canRewriteExtraLoopInitUses(slot);
}

static bool isMemoryLoopCarryReliefStateValue(
    const wave::RegAllocTransformAliasSet &set,
    const wave::RegAllocTransformValue *stateValue, Value init) {
  if (!stateValue)
    return false;
  return stateValue->offset == 0 && stateValue->width == set.width &&
         !stateValue->fixed && !isRegAllocTransformTempValue(init);
}

static std::optional<waveamdmachine::RegType>
getMemoryLoopCarryReliefRegType(const wave::RegAllocTransformAliasSet &set,
                                Value init) {
  auto type = dyn_cast<waveamdmachine::RegType>(init.getType());
  if (!type || type.getRegClass() != waveamdmachine::RegClass::VGPR ||
      type.getWidth() != set.width || type.getWidth() == 0)
    return std::nullopt;
  return type;
}

template <typename Traits>
static FailureOr<std::optional<typename Traits::Candidate>>
buildMemoryLoopCarryReliefCandidate(
    func::FuncOp func, const wave::RegAllocTransformAliasSet &set,
    ArrayRef<ResolvedRegAllocValue> resolvedValues,
    const RegAllocTransformFailure &failureRecord,
    const RematReliefContext &context,
    const typename Traits::PlanningState &planning,
    unsigned extraReservedBytes) {
  std::optional<wave::regalloc::MemorySpillLoopCarrySlot> loopCarry =
      getMemoryReliefLoopCarrySlot(resolvedValues);
  if (!loopCarry)
    return std::optional<typename Traits::Candidate>();

  Value init = loopCarry->loop.getInits()[loopCarry->index];
  const wave::RegAllocTransformValue *stateValue =
      findMemoryReliefStateValue(resolvedValues, init);
  if (!isMemoryLoopCarryReliefStateValue(set, stateValue, init))
    return std::optional<typename Traits::Candidate>();
  std::optional<waveamdmachine::RegType> type =
      getMemoryLoopCarryReliefRegType(set, init);
  if (!type)
    return std::optional<typename Traits::Candidate>();
  if (!canMaterializeMemoryLoopCarryRelief(*loopCarry, init, failureRecord,
                                           context))
    return std::optional<typename Traits::Candidate>();

  std::optional<typename Traits::Plan> plan =
      Traits::getPlanForValue(func, planning, *type, extraReservedBytes);
  if (!plan)
    return std::optional<typename Traits::Candidate>();

  typename Traits::Slot slot;
  slot.plan = std::move(*plan);
  slot.value = init;
  slot.type = *type;
  slot.stateValue = stateValue;
  slot.loopCarry = *loopCarry;
  slot.cost = Traits::getLoopCarryCost(init, slot.plan, *type, *loopCarry);

  typename Traits::Candidate candidate;
  candidate.set = &set;
  candidate.reservedBytes = Traits::getSlotBytes(slot.plan);
  candidate.cost = slot.cost;
  candidate.slots.push_back(std::move(slot));
  return std::optional<typename Traits::Candidate>(std::move(candidate));
}

template <typename Traits>
static FailureOr<bool>
addMemoryReliefSlot(func::FuncOp func, ResolvedRegAllocValue resolved,
                    const RegAllocTransformFailure &failureRecord,
                    const RematReliefContext &context,
                    const typename Traits::PlanningState &planning,
                    const DenseSet<Value> &plannedValues,
                    typename Traits::Candidate &candidate) {
  const wave::RegAllocTransformValue &stateValue = *resolved.second;
  if (!isMemoryValueLiveAcrossFailure(stateValue, failureRecord.position))
    return true;
  FailureOr<std::optional<typename Traits::Slot>> slot =
      buildMemoryReliefSlot<Traits>(func, resolved.first, stateValue,
                                    failureRecord, context, planning,
                                    plannedValues, candidate.reservedBytes);
  if (failed(slot))
    return failure();
  if (!*slot)
    return false;
  candidate.cost += (*slot)->cost;
  candidate.reservedBytes += Traits::getSlotBytes((*slot)->plan);
  candidate.slots.push_back(std::move(**slot));
  return true;
}

template <typename SlotT>
static void sortMemoryReliefSlots(SmallVectorImpl<SlotT> &slots) {
  llvm::stable_sort(slots, [](const SlotT &lhs, const SlotT &rhs) {
    return lhs.stateValue->id < rhs.stateValue->id;
  });
}

static FailureOr<MemoryReliefSetIndex>
buildMemoryReliefSetIndex(func::FuncOp func,
                          ArrayRef<wave::RegAllocTransformAliasSet> sets) {
  MemoryReliefSetIndex index;
  for (const wave::RegAllocTransformAliasSet &set : sets) {
    auto inserted = index.setsById.insert({set.id, &set});
    if (!inserted.second) {
      func.emitError("regalloc state has duplicate alias set id");
      return failure();
    }
  }
  return std::move(index);
}

static const wave::RegAllocTransformAliasSet *
findMemoryReliefSet(const MemoryReliefSetIndex &index, unsigned setId) {
  return index.setsById.lookup(setId);
}

static FailureOr<SmallVector<ResolvedRegAllocValue>>
getMemoryReliefSetValues(func::FuncOp func,
                         const wave::RegAllocTransformAliasSet &set,
                         const MemoryReliefValueIndex &valueIndex) {
  SmallVector<ResolvedRegAllocValue> values;
  values.reserve(set.members.size());
  for (unsigned valueId : set.members) {
    if (valueId >= valueIndex.valuesById.size()) {
      func.emitError("regalloc state member value id is invalid");
      return failure();
    }
    ResolvedRegAllocValue resolved = valueIndex.valuesById[valueId];
    if (!resolved.second || resolved.second->id != valueId) {
      func.emitError("regalloc state value identity no longer matches IR");
      return failure();
    }
    values.push_back(resolved);
  }
  return values;
}

template <typename Traits>
static FailureOr<std::optional<typename Traits::Candidate>>
buildMemoryReliefCandidate(func::FuncOp func, unsigned setId,
                           const RegAllocTransformFailure &failureRecord,
                           const MemoryReliefSetIndex &setIndex,
                           const MemoryReliefValueIndex &valueIndex,
                           MemoryReliefSetEligibilityCache &eligibilityCache,
                           ArrayRef<wave::RegAllocTransformValue> values,
                           const RematReliefContext &context,
                           const typename Traits::PlanningState &planning) {
  const wave::RegAllocTransformAliasSet *set =
      findMemoryReliefSet(setIndex, setId);
  if (!set || !isMemoryReliefCandidateSet(*set, values, failureRecord.position,
                                          eligibilityCache))
    return std::optional<typename Traits::Candidate>();
  FailureOr<SmallVector<ResolvedRegAllocValue>> resolvedValues =
      getMemoryReliefSetValues(func, *set, valueIndex);
  if (failed(resolvedValues))
    return failure();

  FailureOr<std::optional<typename Traits::Candidate>> loopCarryCandidate =
      buildMemoryLoopCarryReliefCandidate<Traits>(
          func, *set, *resolvedValues, failureRecord, context, planning,
          /*extraReservedBytes=*/0);
  if (failed(loopCarryCandidate))
    return failure();
  if (*loopCarryCandidate)
    return loopCarryCandidate;

  DenseSet<Value> plannedValues;
  addPlannedMemoryReliefValues(*resolvedValues, failureRecord.position,
                               plannedValues);
  typename Traits::Candidate candidate;
  candidate.set = set;
  for (ResolvedRegAllocValue resolved : *resolvedValues) {
    FailureOr<bool> added =
        addMemoryReliefSlot<Traits>(func, resolved, failureRecord, context,
                                    planning, plannedValues, candidate);
    if (failed(added))
      return failure();
    if (!*added)
      return std::optional<typename Traits::Candidate>();
  }
  if (candidate.slots.empty())
    return std::optional<typename Traits::Candidate>();
  sortMemoryReliefSlots(candidate.slots);
  return std::optional<typename Traits::Candidate>(std::move(candidate));
}

template <typename CandidateT>
static bool
isBetterMemoryReliefCandidate(const CandidateT &candidate,
                              const std::optional<CandidateT> &best) {
  if (!best)
    return true;
  if (candidate.cost != best->cost)
    return candidate.cost < best->cost;
  return candidate.set->id < best->set->id;
}

template <typename CandidateT>
static bool isMemoryLoopCarryReliefCandidate(const CandidateT &candidate) {
  return !candidate.slots.empty() && candidate.slots.front().loopCarry;
}

template <typename CandidateT>
static bool hasMemoryLoopCarrySlotIndex(const CandidateT &candidate,
                                        unsigned index) {
  return llvm::any_of(candidate.slots, [index](const auto &slot) {
    return slot.loopCarry && slot.loopCarry->index == index;
  });
}

template <typename CandidateT>
static void appendMemoryLoopCarryReliefCandidate(CandidateT &candidate,
                                                 CandidateT next) {
  candidate.cost += next.cost;
  candidate.reservedBytes += next.reservedBytes;
  candidate.slots.append(std::make_move_iterator(next.slots.begin()),
                         std::make_move_iterator(next.slots.end()));
}

template <typename Traits>
static FailureOr<std::optional<typename Traits::Candidate>>
buildExtraMemoryLoopCarryReliefCandidate(
    func::FuncOp func, unsigned setId, const typename Traits::Candidate &base,
    waveamdmachine::UniformLoopOp loop,
    const RegAllocTransformFailure &failureRecord,
    const MemoryReliefSetIndex &setIndex,
    const MemoryReliefValueIndex &valueIndex,
    MemoryReliefSetEligibilityCache &eligibilityCache,
    ArrayRef<wave::RegAllocTransformValue> values,
    const RematReliefContext &context,
    const typename Traits::PlanningState &planning) {
  if (setId == base.set->id)
    return std::optional<typename Traits::Candidate>();
  const wave::RegAllocTransformAliasSet *set =
      findMemoryReliefSet(setIndex, setId);
  if (!set || !isMemoryReliefCandidateSet(*set, values, failureRecord.position,
                                          eligibilityCache))
    return std::optional<typename Traits::Candidate>();
  FailureOr<SmallVector<ResolvedRegAllocValue>> resolvedValues =
      getMemoryReliefSetValues(func, *set, valueIndex);
  if (failed(resolvedValues))
    return failure();
  FailureOr<std::optional<typename Traits::Candidate>> next =
      buildMemoryLoopCarryReliefCandidate<Traits>(func, *set, *resolvedValues,
                                                  failureRecord, context,
                                                  planning, base.reservedBytes);
  if (failed(next))
    return failure();
  if (!*next || !isMemoryLoopCarryReliefCandidate(**next))
    return std::optional<typename Traits::Candidate>();
  const typename Traits::Slot &slot = (*next)->slots.front();
  if (slot.loopCarry->loop != loop ||
      hasMemoryLoopCarrySlotIndex(base, slot.loopCarry->index))
    return std::optional<typename Traits::Candidate>();
  return std::optional<typename Traits::Candidate>(std::move(**next));
}

template <typename Traits>
static FailureOr<typename Traits::Candidate>
expandMemoryLoopCarryReliefCandidate(
    func::FuncOp func, typename Traits::Candidate candidate,
    ArrayRef<unsigned> candidateIds,
    const RegAllocTransformFailure &failureRecord,
    const MemoryReliefSetIndex &setIndex,
    const MemoryReliefValueIndex &valueIndex,
    MemoryReliefSetEligibilityCache &eligibilityCache,
    ArrayRef<wave::RegAllocTransformValue> values,
    const RematReliefContext &context,
    const typename Traits::PlanningState &planning) {
  assert(isMemoryLoopCarryReliefCandidate(candidate) &&
         "expected loop-carry memory relief candidate");
  waveamdmachine::UniformLoopOp loop = candidate.slots.front().loopCarry->loop;
  for (unsigned setId : candidateIds) {
    FailureOr<std::optional<typename Traits::Candidate>> next =
        buildExtraMemoryLoopCarryReliefCandidate<Traits>(
            func, setId, candidate, loop, failureRecord, setIndex, valueIndex,
            eligibilityCache, values, context, planning);
    if (failed(next))
      return failure();
    if (!*next)
      continue;
    appendMemoryLoopCarryReliefCandidate(candidate, std::move(**next));
  }
  sortMemoryReliefSlots(candidate.slots);
  return candidate;
}

template <typename Traits>
static FailureOr<std::optional<typename Traits::Candidate>>
selectMemoryReliefCandidate(func::FuncOp func,
                            const RegAllocTransformFailure &failureRecord,
                            const MemoryReliefSetIndex &setIndex,
                            const MemoryReliefValueIndex &valueIndex,
                            ArrayRef<wave::RegAllocTransformValue> values,
                            const RematReliefContext &context,
                            const typename Traits::PlanningState &planning) {
  std::optional<typename Traits::Candidate> best;
  SmallVector<unsigned> candidateIds =
      collectVGPRReliefCandidateIds(failureRecord);
  MemoryReliefSetEligibilityCache eligibilityCache;
  for (unsigned setId : candidateIds) {
    FailureOr<std::optional<typename Traits::Candidate>> candidate =
        buildMemoryReliefCandidate<Traits>(func, setId, failureRecord, setIndex,
                                           valueIndex, eligibilityCache, values,
                                           context, planning);
    if (failed(candidate))
      return failure();
    if (!*candidate)
      continue;
    if (isMemoryLoopCarryReliefCandidate(**candidate)) {
      FailureOr<typename Traits::Candidate> expanded =
          expandMemoryLoopCarryReliefCandidate<Traits>(
              func, std::move(**candidate), candidateIds, failureRecord,
              setIndex, valueIndex, eligibilityCache, values, context,
              planning);
      if (failed(expanded))
        return failure();
      *candidate =
          std::optional<typename Traits::Candidate>(std::move(*expanded));
    }
    if (isBetterMemoryReliefCandidate(**candidate, best))
      best = std::move(**candidate);
  }
  return best;
}

template <typename Traits>
static FailureOr<std::optional<typename Traits::Candidate>>
selectMemoryReliefCandidateFromState(
    func::FuncOp func, const RegAllocTransformFailure &failureRecord,
    const typename Traits::PlanningState &planning) {
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
  FailureOr<MemoryReliefSetIndex> setIndex =
      buildMemoryReliefSetIndex(func, *sets);
  if (failed(setIndex))
    return failure();
  FailureOr<SmallVector<ResolvedRegAllocValue>> resolvedValues =
      resolveRegAllocStateValues(func, *values);
  if (failed(resolvedValues))
    return failure();
  MemoryReliefValueIndex valueIndex{*resolvedValues};

  RematReliefContext context = buildRematReliefContext(func, *resolvedValues);
  return selectMemoryReliefCandidate<Traits>(
      func, failureRecord, *setIndex, valueIndex, *values, context, planning);
}

template <typename SlotT, typename LoadFn>
static LogicalResult
replaceMemoryReliefUses(OpBuilder &builder,
                        const MemoryStoredSlot<SlotT> &stored,
                        const DenseSet<Value> &plannedValues, LoadFn loadFn) {
  const SlotT &slot = *stored.slot;
  for (OpOperand *use : slot.uses) {
    if (use->get() != slot.value)
      continue;
    if (isInternalPlannedTupleFromElementsUse(use, plannedValues))
      continue;
    Operation *user = use->getOwner();
    builder.setInsertionPoint(user);
    FailureOr<wave::regalloc::MemorySpillLoadResult> loaded =
        loadFn(user->getLoc(), slot.type, stored.token, slot.plan);
    if (failed(loaded))
      return failure();
    use->set(loaded->value);
  }
  return success();
}

template <typename SlotT, typename StoreFn, typename LoadFn>
class TransformMemoryLoopCarryMaterializer {
public:
  TransformMemoryLoopCarryMaterializer(OpBuilder &builder,
                                       ArrayRef<const SlotT *> slots,
                                       StoreFn storeFn, LoadFn loadFn)
      : slots(slots), builder(builder), storeFn(storeFn), loadFn(loadFn) {}

  LogicalResult run() {
    if (slots.empty())
      return success();
    SmallVector<const SlotT *, 8> sorted(slots.begin(), slots.end());
    llvm::stable_sort(sorted, [](const SlotT *lhs, const SlotT *rhs) {
      return lhs->loopCarry->index < rhs->loopCarry->index;
    });
    slots = sorted;

    waveamdmachine::UniformLoopOp loop = slots.front()->loopCarry->loop;
    for (const SlotT *slot : slots)
      assert(slot->loopCarry->loop == loop && "expected one loop group");

    SmallVector<Value, 8> initTokens;
    if (failed(materializeInitStores(loop, initTokens)))
      return failure();
    for (auto [index, slot] : llvm::enumerate(slots))
      if (failed(rewriteExtraLoopInitUses(loop, *slot->loopCarry,
                                          initTokens[index])))
        return failure();

    FailureOr<waveamdmachine::UniformLoopOp> newLoop =
        cloneLoopWithoutCarries(loop, initTokens);
    if (failed(newLoop))
      return failure();
    if (failed(replaceLoopResults(loop, *newLoop)))
      return failure();
    loop.erase();
    return success();
  }

private:
  bool isSpilledIndex(unsigned index) const {
    return llvm::any_of(slots, [index](const SlotT *slot) {
      return slot->loopCarry->index == index;
    });
  }

  std::optional<unsigned> getSpillOrdinal(unsigned index) const {
    for (auto [ordinal, slot] : llvm::enumerate(slots))
      if (slot->loopCarry->index == index)
        return ordinal;
    return std::nullopt;
  }

  static Value getInitStoreToken(Value init) {
    if (Operation *def = init.getDefiningOp())
      return wave::regalloc::getMemoryIssuerToken(def);
    return {};
  }

  void setInsertionPointForInitStore(Value init, OpOperand *loopUse,
                                     waveamdmachine::UniformLoopOp loop) const {
    Operation *def = init.getDefiningOp();
    Operation *firstPreheaderUse =
        wave::regalloc::getLoopCarryFirstPreheaderUse(init, loopUse, loop);
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

  LogicalResult
  materializeInitStores(waveamdmachine::UniformLoopOp loop,
                        SmallVectorImpl<Value> &initTokens) const {
    for (const SlotT *slot : slots) {
      Value initToken;
      if (failed(materializeInitStore(loop, *slot, initToken)))
        return failure();
      initTokens.push_back(initToken);
    }
    return success();
  }

  LogicalResult materializeInitStore(waveamdmachine::UniformLoopOp loop,
                                     const SlotT &slot,
                                     Value &initToken) const {
    unsigned index = slot.loopCarry->index;
    Value init = loop.getInits()[index];
    OpOperand *loopUse = &loop.getInitsMutable()[index];
    setInsertionPointForInitStore(init, loopUse, loop);
    FailureOr<Value> stored =
        storeFn(init, getInitStoreToken(init), slot, loop.getLoc());
    if (failed(stored))
      return failure();
    initToken = *stored;
    return success();
  }

  LogicalResult
  rewriteExtraLoopInitUses(waveamdmachine::UniformLoopOp loop,
                           wave::regalloc::MemorySpillLoopCarrySlot carry,
                           Value initToken) const {
    OpOperand *loopUse = &loop.getInitsMutable()[carry.index];
    Value init = loopUse->get();
    SmallVector<OpOperand *> uses;
    for (OpOperand &use : init.getUses()) {
      if (&use == loopUse || isRegAllocTransformTempOp(use.getOwner()))
        continue;
      uses.push_back(&use);
    }

    const SlotT &slot = *slots[*getSpillOrdinal(carry.index)];
    for (OpOperand *use : uses) {
      if (!wave::regalloc::canRewriteExtraLoopInitUse(*use, loopUse, loop))
        return failure();
      Operation *user = use->getOwner();
      builder.setInsertionPoint(user);
      FailureOr<wave::regalloc::MemorySpillLoadResult> loaded =
          loadFn(user->getLoc(), slot.type, initToken, slot.plan);
      if (failed(loaded))
        return failure();
      use->set(loaded->value);
    }
    return success();
  }

  FailureOr<waveamdmachine::UniformLoopOp>
  cloneLoopWithoutCarries(waveamdmachine::UniformLoopOp loop,
                          ArrayRef<Value> initTokens) const {
    SmallVector<Type> resultTypes;
    SmallVector<Value> inits;
    for (unsigned index : llvm::seq<unsigned>(0, loop.getInits().size())) {
      if (isSpilledIndex(index))
        continue;
      resultTypes.push_back(loop.getResult(index).getType());
      inits.push_back(loop.getInits()[index]);
    }
    for (Value initToken : initTokens) {
      resultTypes.push_back(initToken.getType());
      inits.push_back(initToken);
    }

    builder.setInsertionPoint(loop);
    waveamdmachine::UniformLoopOp newLoop =
        waveamdmachine::UniformLoopOp::create(
            builder, loop.getLoc(), resultTypes, loop.getEntryCond(), inits);
    if (failed(cloneLoopBody(loop, newLoop))) {
      newLoop.erase();
      return failure();
    }
    return newLoop;
  }

  LogicalResult cloneLoopBody(waveamdmachine::UniformLoopOp oldLoop,
                              waveamdmachine::UniformLoopOp newLoop) const {
    Block &oldBody = oldLoop.getBody().front();
    Block *newBody = new Block;
    newLoop.getBody().push_back(newBody);
    for (Value init : newLoop.getInits())
      newBody->addArgument(init.getType(), oldLoop.getLoc());

    IRMapping mapper;
    unsigned newArgIndex = 0;
    for (unsigned index : llvm::seq<unsigned>(0, oldLoop.getInits().size())) {
      if (isSpilledIndex(index))
        continue;
      mapper.map(oldBody.getArgument(index),
                 newBody->getArgument(newArgIndex++));
    }
    SmallVector<Value, 8> tokens;
    for ([[maybe_unused]] const SlotT *slot : slots)
      tokens.push_back(newBody->getArgument(newArgIndex++));
    return cloneLoopBodyOps(oldLoop, newBody, tokens, mapper);
  }

  LogicalResult cloneLoopBodyOps(waveamdmachine::UniformLoopOp oldLoop,
                                 Block *newBody, SmallVectorImpl<Value> &tokens,
                                 IRMapping &mapper) const {
    Block &oldBody = oldLoop.getBody().front();
    builder.setInsertionPointToEnd(newBody);
    for (Operation &op : oldBody.without_terminator()) {
      SmallVector<Value, 4> mappedCarries;
      for (const SlotT *slot : slots) {
        BlockArgument oldArg = oldBody.getArgument(slot->loopCarry->index);
        if (!opUsesValue(&op, oldArg))
          continue;
        FailureOr<Value> mapped =
            getMappedValue(oldLoop, oldArg, tokens, mapper, op.getLoc());
        if (failed(mapped))
          return failure();
        mappedCarries.push_back(oldArg);
      }
      builder.clone(op, mapper);
      for (Value carry : mappedCarries)
        mapper.erase(carry);
    }
    return cloneLoopTerminator(oldLoop, tokens, mapper);
  }

  std::optional<unsigned>
  getSpillOrdinalForValue(waveamdmachine::UniformLoopOp loop,
                          Value value) const {
    BlockArgument arg = dyn_cast<BlockArgument>(value);
    if (!arg || arg.getOwner() != &loop.getBody().front())
      return std::nullopt;
    return getSpillOrdinal(arg.getArgNumber());
  }

  FailureOr<Value> getMappedValue(waveamdmachine::UniformLoopOp loop,
                                  Value value, SmallVectorImpl<Value> &tokens,
                                  IRMapping &mapper, Location loc) const {
    if (Value mapped = mapper.lookupOrNull(value))
      return mapped;
    std::optional<unsigned> ordinal = getSpillOrdinalForValue(loop, value);
    if (!ordinal)
      return mapper.lookupOrDefault(value);
    const SlotT &slot = *slots[*ordinal];
    FailureOr<wave::regalloc::MemorySpillLoadResult> loaded =
        loadFn(loc, slot.type, tokens[*ordinal], slot.plan);
    if (failed(loaded))
      return failure();
    tokens[*ordinal] = loaded->token;
    mapper.map(value, loaded->value);
    return loaded->value;
  }

  LogicalResult cloneLoopTerminator(waveamdmachine::UniformLoopOp loop,
                                    SmallVectorImpl<Value> &tokens,
                                    IRMapping &mapper) const {
    waveamdmachine::ContinueIfOp oldTerm = cast<waveamdmachine::ContinueIfOp>(
        loop.getBody().front().getTerminator());

    SmallVector<Value> carries;
    for (unsigned index : llvm::seq<unsigned>(0, oldTerm.getCarries().size())) {
      Value oldCarry = oldTerm.getCarries()[index];
      if (std::optional<unsigned> ordinal = getSpillOrdinal(index)) {
        if (failed(storeTerminatorCarry(loop, oldCarry, *ordinal, tokens,
                                        mapper, oldTerm.getLoc())))
          return failure();
        continue;
      }
      FailureOr<Value> mapped =
          getMappedValue(loop, oldCarry, tokens, mapper, oldTerm.getLoc());
      if (failed(mapped))
        return failure();
      carries.push_back(*mapped);
    }
    carries.append(tokens.begin(), tokens.end());
    waveamdmachine::ContinueIfOp::create(
        builder, oldTerm.getLoc(), mapper.lookupOrDefault(oldTerm.getCond()),
        carries);
    return success();
  }

  LogicalResult storeTerminatorCarry(waveamdmachine::UniformLoopOp loop,
                                     Value oldCarry, unsigned ordinal,
                                     SmallVectorImpl<Value> &tokens,
                                     IRMapping &mapper, Location loc) const {
    const SlotT &slot = *slots[ordinal];
    BlockArgument oldArg =
        loop.getBody().front().getArgument(slot.loopCarry->index);
    if (oldCarry == oldArg)
      return success();
    FailureOr<Value> mapped =
        getMappedValue(loop, oldCarry, tokens, mapper, loc);
    if (failed(mapped))
      return failure();
    FailureOr<Value> stored = storeFn(*mapped, tokens[ordinal], slot, loc);
    if (failed(stored))
      return failure();
    tokens[ordinal] = *stored;
    return success();
  }

  LogicalResult
  replaceLoopResults(waveamdmachine::UniformLoopOp oldLoop,
                     waveamdmachine::UniformLoopOp newLoop) const {
    builder.setInsertionPointAfter(newLoop);
    unsigned newResultIndex = 0;
    for (unsigned index : llvm::seq<unsigned>(0, oldLoop.getResults().size())) {
      if (isSpilledIndex(index))
        continue;
      oldLoop.getResult(index).replaceAllUsesWith(
          newLoop.getResult(newResultIndex++));
    }
    for (const SlotT *slot : slots) {
      Value token = newLoop.getResult(newResultIndex++);
      Value oldResult = oldLoop.getResult(slot->loopCarry->index);
      if (oldResult.use_empty())
        continue;
      FailureOr<wave::regalloc::MemorySpillLoadResult> loaded =
          loadFn(oldLoop.getLoc(), slot->type, token, slot->plan);
      if (failed(loaded))
        return failure();
      oldResult.replaceAllUsesWith(loaded->value);
    }
    return success();
  }

  ArrayRef<const SlotT *> slots;
  OpBuilder &builder;
  StoreFn storeFn;
  LoadFn loadFn;
};

template <typename SlotT, typename StoreFn, typename LoadFn>
static LogicalResult
materializeMemoryLoopCarryRelief(OpBuilder &builder, ArrayRef<SlotT> slots,
                                 StoreFn storeFn, LoadFn loadFn) {
  SmallVector<const SlotT *, 8> slotPtrs;
  slotPtrs.reserve(slots.size());
  for (const SlotT &slot : slots)
    slotPtrs.push_back(&slot);
  return TransformMemoryLoopCarryMaterializer<SlotT, StoreFn, LoadFn>(
             builder, slotPtrs, storeFn, loadFn)
      .run();
}

template <typename SlotT, typename CandidateT, typename StoreFn,
          typename LoadFn, typename ReserveFn, typename LoopStoreFn>
static LogicalResult
materializeMemoryRelief(OpBuilder &builder, const CandidateT &candidate,
                        StoreFn storeFn, LoadFn loadFn, ReserveFn reserveFn,
                        LoopStoreFn loopStoreFn) {
  if (!candidate.slots.empty() && candidate.slots.front().loopCarry) {
    if (failed(materializeMemoryLoopCarryRelief(
            builder, ArrayRef<SlotT>(candidate.slots), loopStoreFn, loadFn)))
      return failure();
    reserveFn(candidate.reservedBytes);
    return success();
  }

  DenseSet<Value> plannedValues;
  for (const SlotT &slot : candidate.slots)
    plannedValues.insert(slot.value);

  SmallVector<MemoryStoredSlot<SlotT>> storedSlots;
  storedSlots.reserve(candidate.slots.size());
  for (const SlotT &slot : candidate.slots) {
    Value token =
        wave::regalloc::getMemoryIssuerToken(slot.value.getDefiningOp());
    FailureOr<Value> stored = storeFn(slot, token);
    if (failed(stored))
      return failure();
    storedSlots.push_back({&slot, *stored});
  }
  for (const MemoryStoredSlot<SlotT> &stored : storedSlots)
    if (failed(replaceMemoryReliefUses(builder, stored, plannedValues, loadFn)))
      return failure();
  reserveFn(candidate.reservedBytes);
  return success();
}

} // namespace mlir::wave::regalloc_detail

#endif // MLIR_DIALECT_WAVE_TRANSFORMS_WAVEAMDREGALLOCMEMORYRELIEFUTILS_H
