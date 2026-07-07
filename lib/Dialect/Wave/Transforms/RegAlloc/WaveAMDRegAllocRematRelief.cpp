//===- WaveAMDRegAllocRematRelief.cpp - Remat pressure relief -------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "WaveAMDRegAllocInternal.h"
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

struct RematReliefSlot {
  SmallVector<OpOperand *> uses;
  SmallVector<Value> extendedLeaves;
  Value value;
  Operation *rebuildOp = nullptr;
  const wave::RegAllocTransformValue *stateValue = nullptr;
  int64_t cost = 0;
  unsigned opCount = 0;
  unsigned rebuildPosition = 0;
};

struct RematReliefCandidate {
  SmallVector<RematReliefSlot> slots;
  SmallVector<Value> rematValues;
  const wave::RegAllocTransformAliasSet *set = nullptr;
  int64_t cost = 0;
};

static bool isRematRelievableFailureClass(StringRef className) {
  return className == "sgpr" || className == "vgpr" || className == "vgpr_agpr";
}

static bool isRematRelievableFailureReason(StringRef reason) {
  return reason == "pressure" || reason == "allocated-footprint";
}

static bool isRematRelievableFailure(const RegAllocTransformFailure &failure) {
  return isRematRelievableFailureClass(failure.className) &&
         isRematRelievableFailureReason(failure.reason);
}

static bool insertionBeforeDominatesUse(Operation *anchor, Operation *user) {
  if (anchor == user)
    return true;
  if (anchor->getBlock() == user->getBlock())
    return anchor->isBeforeInBlock(user);
  Operation *ancestor = getAncestorInBlock(user, anchor->getBlock());
  return ancestor && (ancestor == anchor || anchor->isBeforeInBlock(ancestor));
}

static bool isTrackedRegValue(Value value) {
  return wave::getRegAllocTransformTrackedRegType(value).has_value();
}

static bool isAnchoredRematSource(Value value) {
  Operation *def = value.getDefiningOp();
  return isa_and_nonnull<
      waveamdmachine::KernargPreloadOp, waveamdmachine::SWorkgroupIdXOp,
      waveamdmachine::SWorkgroupIdYOp, waveamdmachine::SWorkgroupIdZOp,
      waveamdmachine::VWorkitemIdXOp>(def);
}

static bool isCheapRematRoot(Operation *op) {
  return isa_and_nonnull<
             waveamdmachine::SAddI32Op, waveamdmachine::SMulI32Op,
             waveamdmachine::SLshlB32Op, waveamdmachine::SLshrB32Op,
             waveamdmachine::SAndB32Op, waveamdmachine::SOrB32Op,
             waveamdmachine::SXorB32Op, waveamdmachine::UninitOp,
             waveamdmachine::VMovB32TupleOp, waveamdmachine::CopyTupleOp,
             waveamdmachine::VLshrrevB32Op, waveamdmachine::VLshlrevB32Op,
             waveamdmachine::VLshlAddU32Op, waveamdmachine::VAddU32Op,
             waveamdmachine::VAdd3U32Op, waveamdmachine::VAndB32Op,
             waveamdmachine::VMulLoU32Op, waveamdmachine::VAddLshlU32Op,
             waveamdmachine::VXorB32Op, waveamdmachine::VAndOrB32Op,
             waveamdmachine::VBitOp3B32Op>(op) ||
         (op && op->hasTrait<OpTrait::waveamdmachine::TupleAliasOp>());
}

static bool isRematRootValue(Value value) {
  Operation *def = value.getDefiningOp();
  auto type = dyn_cast<waveamdmachine::RegType>(value.getType());
  return def && type && type.getIndex() < 0 && !isAnchoredRematSource(value) &&
         !wave::regalloc::isRegAllocRematTempOp(def) && isCheapRematRoot(def) &&
         !isRegAllocTransformBridgeRelated(value);
}

static bool mustRematValue(Value value,
                           const DenseSet<Value> *forcedRematValues) {
  return forcedRematValues && forcedRematValues->contains(value);
}

static bool
isRematValueLiveAtFailure(Value value,
                          const RegAllocTransformFailure &failureRecord,
                          const RematReliefContext &context) {
  auto it = context.values.find(value);
  if (it == context.values.end())
    return false;
  const wave::RegAllocTransformValue &stateValue = *it->second;
  unsigned position = failureRecord.position;
  return valueLiveAcrossPosition(stateValue, position);
}

static bool
canUseOriginalRematLeaf(Value value, Operation *user,
                        const RegAllocTransformFailure &failureRecord,
                        const RematReliefContext &context,
                        const DenseSet<Value> *forcedRematValues) {
  if (mustRematValue(value, forcedRematValues))
    return false;
  if (!valueIsAvailableAt(value, user))
    return false;
  if (isRematRootValue(value) &&
      isRematValueLiveAtFailure(value, failureRecord, context))
    return false;
  if (!isTrackedRegValue(value))
    return true;
  std::optional<unsigned> position = getRematOpPosition(user, context);
  return position && isStateValueLiveAt(value, *position, context);
}

static bool
canExtendOriginalRematLeaf(Value value, Operation *user,
                           const RematReliefContext &context,
                           const DenseSet<Value> *forcedRematValues) {
  return !mustRematValue(value, forcedRematValues) &&
         isTrackedRegValue(value) && context.values.contains(value) &&
         valueIsAvailableAt(value, user);
}

static bool collectExtendedRematLeaves(
    Value value, Operation *user, const RegAllocTransformFailure &failureRecord,
    const RematReliefContext &context, DenseSet<Value> &visiting,
    const DenseSet<Value> *forcedRematValues, DenseSet<Value> &extendedLeaves);

static bool collectExtendedRematOperandLeaves(
    Value operand, Operation *user,
    const RegAllocTransformFailure &failureRecord,
    const RematReliefContext &context, DenseSet<Value> &visiting,
    const DenseSet<Value> *forcedRematValues, DenseSet<Value> &extendedLeaves) {
  if (canUseOriginalRematLeaf(operand, user, failureRecord, context,
                              forcedRematValues))
    return true;
  DenseSet<Value> rematLeaves = extendedLeaves;
  if (collectExtendedRematLeaves(operand, user, failureRecord, context,
                                 visiting, forcedRematValues, rematLeaves)) {
    extendedLeaves = std::move(rematLeaves);
    return true;
  }
  if (canExtendOriginalRematLeaf(operand, user, context, forcedRematValues)) {
    extendedLeaves.insert(operand);
    return true;
  }
  return false;
}

static bool collectExtendedRematLeaves(
    Value value, Operation *user, const RegAllocTransformFailure &failureRecord,
    const RematReliefContext &context, DenseSet<Value> &visiting,
    const DenseSet<Value> *forcedRematValues, DenseSet<Value> &extendedLeaves) {
  Operation *def = value.getDefiningOp();
  if (!isRematRootValue(value) || !valueIsAvailableAt(value, user))
    return false;
  if (!visiting.insert(value).second)
    return false;
  bool ok = llvm::all_of(def->getOperands(), [&](Value operand) {
    return collectExtendedRematOperandLeaves(operand, user, failureRecord,
                                             context, visiting,
                                             forcedRematValues, extendedLeaves);
  });
  visiting.erase(value);
  return ok;
}

static FailureOr<SmallVector<Value>>
collectExtendedRematLeaves(Value value, Operation *user,
                           const RegAllocTransformFailure &failureRecord,
                           const RematReliefContext &context,
                           const DenseSet<Value> *forcedRematValues) {
  DenseSet<Value> visiting;
  DenseSet<Value> extendedLeaves;
  if (!collectExtendedRematLeaves(value, user, failureRecord, context, visiting,
                                  forcedRematValues, extendedLeaves))
    return failure();
  SmallVector<Value> leaves(extendedLeaves.begin(), extendedLeaves.end());
  llvm::sort(leaves, [&](Value lhs, Value rhs) {
    return context.values.lookup(lhs)->id < context.values.lookup(rhs)->id;
  });
  return leaves;
}

static unsigned getRematOpCountAt(Value value, Operation *user,
                                  const RegAllocTransformFailure &failureRecord,
                                  const RematReliefContext &context,
                                  DenseSet<Value> &counted,
                                  const DenseSet<Value> *forcedRematValues) {
  if (!counted.insert(value).second)
    return 0;
  unsigned count = 1;
  Operation *def = value.getDefiningOp();
  for (Value operand : def->getOperands()) {
    if (canUseOriginalRematLeaf(operand, user, failureRecord, context,
                                forcedRematValues))
      continue;
    FailureOr<SmallVector<Value>> extendedLeaves = collectExtendedRematLeaves(
        operand, user, failureRecord, context, forcedRematValues);
    if (succeeded(extendedLeaves))
      count += getRematOpCountAt(operand, user, failureRecord, context, counted,
                                 forcedRematValues);
  }
  return count;
}

static unsigned getRematOpCountAt(Value value, Operation *user,
                                  const RegAllocTransformFailure &failureRecord,
                                  const RematReliefContext &context,
                                  const DenseSet<Value> *forcedRematValues) {
  DenseSet<Value> counted;
  return getRematOpCountAt(value, user, failureRecord, context, counted,
                           forcedRematValues);
}

static FailureOr<SmallVector<OpOperand *>>
collectSortedRematPostFailureUses(Value value,
                                  const RegAllocTransformFailure &failureRecord,
                                  const RematReliefContext &context) {
  SmallVector<OpOperand *> uses;
  for (OpOperand &use : value.getUses()) {
    std::optional<unsigned> position =
        getRematOpPosition(use.getOwner(), context);
    if (!position)
      return failure();
    if (*position >= failureRecord.position)
      uses.push_back(&use);
  }
  llvm::stable_sort(uses, [&](OpOperand *lhs, OpOperand *rhs) {
    return context.positions.lookup(lhs->getOwner()) <
           context.positions.lookup(rhs->getOwner());
  });
  return uses;
}

static FailureOr<SmallVector<SmallVector<OpOperand *>>>
collectRematPostFailureUseGroups(Value value,
                                 const RegAllocTransformFailure &failureRecord,
                                 const RematReliefContext &context) {
  FailureOr<SmallVector<OpOperand *>> sortedUses =
      collectSortedRematPostFailureUses(value, failureRecord, context);
  if (failed(sortedUses))
    return failure();

  SmallVector<SmallVector<OpOperand *>> groups;
  while (!sortedUses->empty()) {
    Operation *anchor = sortedUses->front()->getOwner();
    SmallVector<OpOperand *> group;
    SmallVector<OpOperand *> remaining;
    for (OpOperand *use : *sortedUses) {
      if (insertionBeforeDominatesUse(anchor, use->getOwner()))
        group.push_back(use);
      else
        remaining.push_back(use);
    }
    groups.push_back(std::move(group));
    *sortedUses = std::move(remaining);
  }
  return groups;
}

static bool isRematCandidateRegClass(waveamdmachine::RegClass regClass,
                                     StringRef failureClassName) {
  if (failureClassName == "sgpr")
    return regClass == waveamdmachine::RegClass::SGPR;
  if (failureClassName == "vgpr" || failureClassName == "vgpr_agpr")
    return regClass == waveamdmachine::RegClass::VGPR;
  return false;
}

static bool isRematCandidateSet(const wave::RegAllocTransformAliasSet &set,
                                ArrayRef<wave::RegAllocTransformValue> values,
                                const RegAllocTransformFailure &failureRecord) {
  unsigned position = failureRecord.position;
  if (!isRematCandidateRegClass(set.regClass, failureRecord.className) ||
      hasFixedRegAllocValue(set, values))
    return false;
  return llvm::any_of(set.members, [&](unsigned valueId) {
    const wave::RegAllocTransformValue &value = values[valueId];
    if (set.id == failureRecord.set)
      return llvm::any_of(value.ranges, [&](auto range) {
        return range.start <= position && position < range.end;
      });
    return valueLiveAcrossPosition(value, position);
  });
}

static SmallVector<unsigned>
collectRematReliefCandidateIds(const RegAllocTransformFailure &failure) {
  SmallVector<unsigned> ids;
  DenseSet<unsigned> seen;
  auto add = [&](unsigned id) {
    if (seen.insert(id).second)
      ids.push_back(id);
  };
  add(failure.set);
  for (const wave::RegAllocTransformAssignment &overlap : failure.overlaps)
    if (isRematCandidateRegClass(overlap.regClass, failure.className))
      add(overlap.set);
  return ids;
}

static bool
hasStructuralLoopCarryUse(ArrayRef<ResolvedRegAllocValue> resolvedValues) {
  return llvm::any_of(resolvedValues, [](ResolvedRegAllocValue resolved) {
    return mlir::wave::regalloc_detail::hasStructuralLoopCarryUse(
        resolved.first);
  });
}

static bool
isRematValueLiveAcrossFailure(const wave::RegAllocTransformValue &stateValue,
                              unsigned position) {
  return valueLiveAcrossPosition(stateValue, position);
}

static bool
canRematValueRelieveFailure(const wave::RegAllocTransformValue &stateValue,
                            const RegAllocTransformFailure &failureRecord) {
  unsigned position = failureRecord.position;
  if (stateValue.set == failureRecord.set)
    return llvm::any_of(stateValue.ranges, [&](auto range) {
      return range.start <= position && position < range.end;
    });
  return isRematValueLiveAcrossFailure(stateValue, position);
}

static bool aliasSetLiveAtPosition(const wave::RegAllocTransformAliasSet &set,
                                   unsigned position) {
  return llvm::any_of(set.ranges, [&](wave::RegAllocTransformLiveRange range) {
    return range.start <= position && position <= range.end;
  });
}

static RegClassPressure
getRegClassPressureAtPosition(ArrayRef<wave::RegAllocTransformAliasSet> sets,
                              unsigned position) {
  RegClassPressure pressure = {};
  for (const wave::RegAllocTransformAliasSet &set : sets)
    if (aliasSetLiveAtPosition(set, position))
      addRegClassPressure(pressure, set.regClass, set.width);
  return pressure;
}

static bool
extendedLeafAddsPressureAtFailure(Value leaf, const RematReliefSlot &slot,
                                  const RegAllocTransformFailure &failureRecord,
                                  const RematReliefContext &context) {
  auto it = context.values.find(leaf);
  if (it == context.values.end())
    return false;
  const wave::RegAllocTransformValue &stateValue = *it->second;
  unsigned position = failureRecord.position;
  if (stateValue.start > position || slot.rebuildPosition < position)
    return false;
  return !isStateValueLiveAt(leaf, position, context);
}

static RegClassPressure
getRematExtendedLeafPressure(const RematReliefCandidate &candidate,
                             const RegAllocTransformFailure &failureRecord,
                             ArrayRef<wave::RegAllocTransformAliasSet> sets,
                             const RematReliefContext &context) {
  RegClassPressure pressure = {};
  DenseSet<unsigned> countedSets;
  for (const RematReliefSlot &slot : candidate.slots) {
    for (Value leaf : slot.extendedLeaves) {
      auto it = context.values.find(leaf);
      if (it == context.values.end())
        continue;
      const wave::RegAllocTransformValue &stateValue = *it->second;
      if (!extendedLeafAddsPressureAtFailure(leaf, slot, failureRecord,
                                             context) ||
          !countedSets.insert(stateValue.set).second)
        continue;
      const wave::RegAllocTransformAliasSet *set =
          findRegAllocTransformSet(sets, stateValue.set);
      addRegClassPressure(pressure, stateValue.regClass,
                          set ? set->width : stateValue.width);
    }
  }
  return pressure;
}

static RegClassPressure
getRematRemovedPressure(const RematReliefCandidate &candidate) {
  RegClassPressure pressure = {};
  addRegClassPressure(pressure, candidate.set->regClass, candidate.set->width);
  return pressure;
}

static bool pressureFitsRegClassBudgets(func::FuncOp func,
                                        RegClassPressure pressure) {
  for (waveamdmachine::RegClass regClass : kRegClasses) {
    int64_t dwords = pressure[getRegClassIndex(regClass)];
    if (dwords < 0)
      return false;
    wave::RegAllocTransformBudget budget =
        wave::getRegAllocTransformBudget(func, regClass);
    if (static_cast<uint64_t>(dwords) > budget.limit)
      return false;
  }
  return true;
}

static bool rematCandidateReducesFailurePressure(
    func::FuncOp func, const RematReliefCandidate &candidate,
    const RegAllocTransformFailure &failureRecord,
    ArrayRef<wave::RegAllocTransformAliasSet> sets,
    ArrayRef<wave::RegAllocTransformValue> values,
    const RematReliefContext &context) {
  RegClassPressure added =
      getRematExtendedLeafPressure(candidate, failureRecord, sets, context);
  RegClassPressure removed = getRematRemovedPressure(candidate);
  if (getTotalPressure(removed) <= getTotalPressure(added))
    return false;
  RegClassPressure pressure =
      getRegClassPressureAtPosition(sets, failureRecord.position);
  for (waveamdmachine::RegClass regClass : kRegClasses)
    pressure[getRegClassIndex(regClass)] +=
        added[getRegClassIndex(regClass)] - removed[getRegClassIndex(regClass)];
  return pressureFitsRegClassBudgets(func, pressure);
}

static bool
rematCandidateUsesFailurePosition(const RematReliefCandidate &candidate,
                                  const RegAllocTransformFailure &failureRecord,
                                  const RematReliefContext &context) {
  return llvm::any_of(candidate.slots, [&](const RematReliefSlot &slot) {
    return llvm::any_of(slot.uses, [&](OpOperand *use) {
      return context.positions.lookup(use->getOwner()) ==
             failureRecord.position;
    });
  });
}

static FailureOr<RematReliefSlot> buildRematReliefSlot(
    Value value, const wave::RegAllocTransformValue &stateValue,
    const RegAllocTransformFailure &failureRecord,
    const RematReliefContext &context, const DenseSet<Value> &forcedRematValues,
    SmallVector<OpOperand *> uses) {
  Operation *rebuildOp = uses.front()->getOwner();
  FailureOr<SmallVector<Value>> extendedLeaves = collectExtendedRematLeaves(
      value, rebuildOp, failureRecord, context, &forcedRematValues);
  if (failed(extendedLeaves))
    return failure();
  unsigned opCount = getRematOpCountAt(value, rebuildOp, failureRecord, context,
                                       &forcedRematValues);
  int64_t cost = opCount * getRematReliefLoopCostScale(rebuildOp) + uses.size();
  RematReliefSlot slot;
  slot.uses = std::move(uses);
  slot.extendedLeaves = std::move(*extendedLeaves);
  slot.value = value;
  slot.rebuildOp = rebuildOp;
  slot.stateValue = &stateValue;
  slot.cost = cost;
  slot.opCount = opCount;
  slot.rebuildPosition = context.positions.lookup(rebuildOp);
  return slot;
}

static void sortRematReliefSlots(MutableArrayRef<RematReliefSlot> slots) {
  llvm::stable_sort(slots,
                    [](const RematReliefSlot &lhs, const RematReliefSlot &rhs) {
                      return std::tie(lhs.rebuildPosition, lhs.stateValue->id) <
                             std::tie(rhs.rebuildPosition, rhs.stateValue->id);
                    });
}

static void addForcedRematValues(ArrayRef<ResolvedRegAllocValue> values,
                                 const RegAllocTransformFailure &failureRecord,
                                 SmallVectorImpl<Value> &rematValues,
                                 DenseSet<Value> &forcedRematValues) {
  for (ResolvedRegAllocValue resolved : values)
    if (canRematValueRelieveFailure(*resolved.second, failureRecord)) {
      rematValues.push_back(resolved.first);
      forcedRematValues.insert(resolved.first);
    }
}

static FailureOr<bool>
addRematReliefSlot(Value value, const wave::RegAllocTransformValue &stateValue,
                   const RegAllocTransformFailure &failureRecord,
                   const RematReliefContext &context,
                   const DenseSet<Value> &forcedRematValues,
                   RematReliefCandidate &candidate) {
  if (!canRematValueRelieveFailure(stateValue, failureRecord))
    return true;
  if (stateValue.fixed || !isRematRootValue(value))
    return false;
  FailureOr<SmallVector<SmallVector<OpOperand *>>> useGroups =
      collectRematPostFailureUseGroups(value, failureRecord, context);
  if (failed(useGroups))
    return failure();
  if (useGroups->empty())
    return false;
  for (SmallVector<OpOperand *> &uses : *useGroups) {
    FailureOr<RematReliefSlot> slot =
        buildRematReliefSlot(value, stateValue, failureRecord, context,
                             forcedRematValues, std::move(uses));
    if (failed(slot))
      return false;
    candidate.cost += slot->cost;
    candidate.slots.push_back(std::move(*slot));
  }
  return true;
}

static void
eraseDeadRematProducerTree(Operation *op,
                           const DenseSet<Operation *> &protectedDefs) {
  if (!op || !isOpTriviallyDead(op))
    return;
  SmallVector<Operation *> producers;
  for (Value operand : op->getOperands())
    if (Operation *producer = operand.getDefiningOp())
      if (!protectedDefs.contains(producer))
        producers.push_back(producer);
  op->erase();
  for (Operation *producer : producers)
    eraseDeadRematProducerTree(producer, protectedDefs);
}

static void eraseDeadRematDefs(ArrayRef<RematReliefSlot> slots) {
  SmallVector<Operation *> defs;
  DenseSet<Operation *> seen;
  for (const RematReliefSlot &slot : slots) {
    Operation *def = slot.value.getDefiningOp();
    if (def && seen.insert(def).second)
      defs.push_back(def);
  }
  for (Operation *def : llvm::reverse(defs))
    eraseDeadRematProducerTree(def, seen);
}

static unsigned countRematReliefDwords(const RematReliefCandidate &candidate) {
  unsigned dwords = 0;
  for (const RematReliefSlot &slot : candidate.slots)
    dwords += slot.stateValue->width;
  return dwords;
}

static FailureOr<bool>
addRematReliefSlotsForSet(ArrayRef<ResolvedRegAllocValue> resolvedValues,
                          const RegAllocTransformFailure &failureRecord,
                          const RematReliefContext &context,
                          const DenseSet<Value> &forcedRematValues,
                          RematReliefCandidate &candidate) {
  for (ResolvedRegAllocValue resolved : resolvedValues) {
    FailureOr<bool> added =
        addRematReliefSlot(resolved.first, *resolved.second, failureRecord,
                           context, forcedRematValues, candidate);
    if (failed(added))
      return failure();
    if (!*added)
      return false;
  }
  return true;
}

static bool rematCandidatePassesPressureCheck(
    func::FuncOp func, const RematReliefCandidate &candidate,
    const RegAllocTransformFailure &failureRecord,
    ArrayRef<wave::RegAllocTransformAliasSet> sets,
    ArrayRef<wave::RegAllocTransformValue> values,
    const RematReliefContext &context) {
  if (rematCandidateUsesFailurePosition(candidate, failureRecord, context))
    return true;
  return rematCandidateReducesFailurePressure(func, candidate, failureRecord,
                                              sets, values, context);
}

static FailureOr<std::optional<RematReliefCandidate>>
buildRematReliefCandidate(func::FuncOp func, unsigned setId,
                          const RegAllocTransformFailure &failureRecord,
                          ArrayRef<wave::RegAllocTransformAliasSet> sets,
                          ArrayRef<wave::RegAllocTransformValue> values,
                          const RematReliefContext &context) {
  const wave::RegAllocTransformAliasSet *set =
      findRegAllocTransformSet(sets, setId);
  if (!set || !isRematCandidateSet(*set, values, failureRecord))
    return std::optional<RematReliefCandidate>();
  FailureOr<SmallVector<ResolvedRegAllocValue>> resolvedValues =
      resolveSetValues(func, *set, values);
  if (failed(resolvedValues))
    return failure();
  if (hasStructuralLoopCarryUse(*resolvedValues))
    return std::optional<RematReliefCandidate>();

  RematReliefCandidate candidate;
  DenseSet<Value> forcedRematValues;
  candidate.set = set;
  addForcedRematValues(*resolvedValues, failureRecord, candidate.rematValues,
                       forcedRematValues);
  FailureOr<bool> added = addRematReliefSlotsForSet(
      *resolvedValues, failureRecord, context, forcedRematValues, candidate);
  if (failed(added))
    return failure();
  if (!*added)
    return std::optional<RematReliefCandidate>();
  if (candidate.slots.empty())
    return std::optional<RematReliefCandidate>();
  sortRematReliefSlots(candidate.slots);
  if (!rematCandidatePassesPressureCheck(func, candidate, failureRecord, sets,
                                         values, context))
    return std::optional<RematReliefCandidate>();
  return std::optional<RematReliefCandidate>(std::move(candidate));
}

static bool
isBetterRematSetCandidate(const RematReliefCandidate &candidate,
                          const std::optional<RematReliefCandidate> &best) {
  if (!best)
    return true;
  if (candidate.cost != best->cost)
    return candidate.cost < best->cost;
  return candidate.set->id < best->set->id;
}

static FailureOr<std::optional<RematReliefCandidate>>
selectRematReliefCandidate(func::FuncOp func,
                           const RegAllocTransformFailure &failureRecord,
                           ArrayRef<wave::RegAllocTransformAliasSet> sets,
                           ArrayRef<wave::RegAllocTransformValue> values,
                           const RematReliefContext &context) {
  std::optional<RematReliefCandidate> best;
  for (unsigned setId : collectRematReliefCandidateIds(failureRecord)) {
    FailureOr<std::optional<RematReliefCandidate>> candidate =
        buildRematReliefCandidate(func, setId, failureRecord, sets, values,
                                  context);
    if (failed(candidate))
      return failure();
    if (!*candidate)
      continue;
    if (isBetterRematSetCandidate(**candidate, best))
      best = std::move(**candidate);
  }
  return best;
}

static FailureOr<Value>
materializeRematValueAt(OpBuilder &builder, Value value, Operation *user,
                        const RegAllocTransformFailure &failureRecord,
                        const RematReliefContext &context,
                        DenseMap<Value, Value> &cache,
                        const DenseSet<Value> &forcedRematValues) {
  auto cached = cache.find(value);
  if (cached != cache.end())
    return cached->second;
  Operation *def = value.getDefiningOp();
  if (!def || !isRematRootValue(value))
    return failure();

  IRMapping mapping;
  for (Value operand : def->getOperands()) {
    Value mapped = operand;
    if (!canUseOriginalRematLeaf(operand, user, failureRecord, context,
                                 &forcedRematValues)) {
      FailureOr<SmallVector<Value>> extendedLeaves = collectExtendedRematLeaves(
          operand, user, failureRecord, context, &forcedRematValues);
      if (succeeded(extendedLeaves)) {
        FailureOr<Value> rematOperand =
            materializeRematValueAt(builder, operand, user, failureRecord,
                                    context, cache, forcedRematValues);
        if (failed(rematOperand))
          return failure();
        mapped = *rematOperand;
      } else if (canExtendOriginalRematLeaf(operand, user, context,
                                            &forcedRematValues)) {
        mapped = operand;
      } else {
        return failure();
      }
    }
    mapping.map(operand, mapped);
  }

  Operation *clone = builder.clone(*def, mapping);
  clone->setAttr(wave::regalloc::kRegAllocRematTempAttr, builder.getUnitAttr());
  Value result = clone->getResult(cast<OpResult>(value).getResultNumber());
  cache[value] = result;
  return result;
}

static LogicalResult materializeRematReliefSlot(
    OpBuilder &builder, const RematReliefSlot &slot,
    const RegAllocTransformFailure &failureRecord,
    const RematReliefContext &context, const DenseSet<Value> &forcedRematValues,
    SmallVectorImpl<std::pair<const RematReliefSlot *, Value>> &rebuiltSlots) {
  builder.setInsertionPoint(slot.rebuildOp);
  DenseMap<Value, Value> cache;
  FailureOr<Value> rebuilt =
      materializeRematValueAt(builder, slot.value, slot.rebuildOp,
                              failureRecord, context, cache, forcedRematValues);
  if (failed(rebuilt))
    return failure();
  rebuiltSlots.push_back({&slot, *rebuilt});
  return success();
}

static LogicalResult
materializeRematRelief(OpBuilder &builder,
                       const RematReliefCandidate &candidate,
                       const RegAllocTransformFailure &failureRecord,
                       const RematReliefContext &context) {
  DenseSet<Value> forcedRematValues(candidate.rematValues.begin(),
                                    candidate.rematValues.end());
  SmallVector<std::pair<const RematReliefSlot *, Value>> rebuiltSlots;
  rebuiltSlots.reserve(candidate.slots.size());
  for (const RematReliefSlot &slot : candidate.slots)
    if (failed(materializeRematReliefSlot(builder, slot, failureRecord, context,
                                          forcedRematValues, rebuiltSlots)))
      return failure();
  for (auto [slot, rebuilt] : rebuiltSlots)
    for (OpOperand *use : slot->uses)
      use->set(rebuilt);
  eraseDeadRematDefs(candidate.slots);
  return success();
}

static LogicalResult
materializeSelectedRematRelief(OpBuilder &builder, func::FuncOp func,
                               const RematReliefCandidate &candidate,
                               const RegAllocTransformFailure &failureRecord,
                               const RematReliefContext &context) {
  if (failed(
          materializeRematRelief(builder, candidate, failureRecord, context)))
    return failure();
  return wave::addRegAllocTransformProviderMetadata(
      func, builder, "remat", countRematReliefDwords(candidate));
}

static LogicalResult runRegAllocRematRelief(func::FuncOp func) {
  FailureOr<std::optional<RegAllocTransformFailure>> failureRecord =
      parseRegAllocTransformFailure(func);
  if (failed(failureRecord))
    return failure();
  if (!*failureRecord)
    return success();
  if (!isRematRelievableFailure(**failureRecord))
    return success();

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
  FailureOr<SmallVector<ResolvedRegAllocValue>> resolvedValues =
      resolveRegAllocStateValues(func, *values);
  if (failed(resolvedValues))
    return failure();

  RematReliefContext context = buildRematReliefContext(func, *resolvedValues);
  FailureOr<std::optional<RematReliefCandidate>> candidate =
      selectRematReliefCandidate(func, **failureRecord, *sets, *values,
                                 context);
  if (failed(candidate))
    return failure();
  if (!*candidate)
    return success();

  OpBuilder builder(func.getContext());
  if (failed(materializeSelectedRematRelief(builder, func, **candidate,
                                            **failureRecord, context)))
    return failure();
  func->removeAttr(wave::getRegAllocTransformAssignmentsAttrName());
  func->removeAttr(wave::getRegAllocTransformStateAttrName());
  return success();
}

} // namespace

LogicalResult wave::runRegAllocTransformRematRelief(Operation *target,
                                                    Builder &builder) {
  if (func::FuncOp func = dyn_cast<func::FuncOp>(target))
    return runRegAllocRematRelief(func);
  WalkResult walk = target->walk([&](func::FuncOp func) {
    return failed(runRegAllocRematRelief(func)) ? WalkResult::interrupt()
                                                : WalkResult::advance();
  });
  return failure(walk.wasInterrupted());
}
