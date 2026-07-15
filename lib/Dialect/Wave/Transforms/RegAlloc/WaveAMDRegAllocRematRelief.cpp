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
#include <algorithm>
#include <array>
#include <optional>

using namespace mlir;
using namespace mlir::wave::regalloc_detail;

namespace {

struct RematReliefSlot {
  SmallVector<OpOperand *> uses;
  SmallVector<Value> extendedLeaves;
  SmallVector<Value> dagValues;
  Value value;
  Operation *rebuildOp = nullptr;
  const wave::RegAllocTransformValue *stateValue = nullptr;
  unsigned rebuildPosition = 0;
};

struct RematReliefRoot {
  DenseMap<Operation *, DenseSet<Value>> siteValues;
  SmallVector<RematReliefSlot> slots;
  SmallVector<Value> rematValues;
  SmallVector<unsigned> pressureLeafSets;
  const wave::RegAllocTransformAliasSet *set = nullptr;
  int64_t cost = 0;
  int64_t useCost = 0;
  bool usesFailurePosition = false;
};

struct RematReliefPlan {
  SmallVector<RematReliefRoot, 0> roots;
  int64_t cost = 0;
};

struct RematRootExtension {
  int64_t gain = 0;
  int64_t cost = 0;
  unsigned index = 0;
};

struct RematBundleState {
  DenseMap<Operation *, DenseSet<Value>> siteValues;
  DenseSet<unsigned> selectedRoots;
  DenseSet<unsigned> pressureLeafSets;
  SmallVector<unsigned> indices;
  RegClassPressure added = {};
  RegClassPressure removed = {};
  int64_t cost = 0;
  bool usesFailurePosition = false;
};

struct RematBundleSearchContext {
  DenseMap<unsigned, const wave::RegAllocTransformAliasSet *> sets;
  RegClassPressure before = {};
  RegClassPressure allowed = {};
  StringRef failureClassName;
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
      waveamdmachine::VWorkitemIdXOp, waveamdmachine::VWorkitemIdYOp,
      waveamdmachine::VWorkitemIdZOp>(def);
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
             waveamdmachine::VBfeU32Op, waveamdmachine::VMulLoU32Op,
             waveamdmachine::VAddLshlU32Op, waveamdmachine::VXorB32Op,
             waveamdmachine::VAndOrB32Op, waveamdmachine::VPermB32Op,
             waveamdmachine::VBitOp3B32Op>(op) ||
         (op && op->hasTrait<OpTrait::waveamdmachine::TupleAliasOp>());
}

static bool isRematRootValue(Value value) {
  Operation *def = value.getDefiningOp();
  auto type = dyn_cast<waveamdmachine::RegType>(value.getType());
  return def && type && type.getIndex() < 0 && !isAnchoredRematSource(value) &&
         !wave::regalloc::isRegAllocRematTempOp(def) && isCheapRematRoot(def) &&
         !def->hasAttr(wave::regalloc::kRegAllocSGPRToVGPRPinnedAttr) &&
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

static void collectRematDAGValuesAt(
    Value value, Operation *user, const RegAllocTransformFailure &failureRecord,
    const RematReliefContext &context, DenseSet<Value> &values,
    const DenseSet<Value> *forcedRematValues) {
  if (!values.insert(value).second)
    return;
  Operation *def = value.getDefiningOp();
  for (Value operand : def->getOperands()) {
    if (canUseOriginalRematLeaf(operand, user, failureRecord, context,
                                forcedRematValues))
      continue;
    FailureOr<SmallVector<Value>> extendedLeaves = collectExtendedRematLeaves(
        operand, user, failureRecord, context, forcedRematValues);
    if (succeeded(extendedLeaves))
      collectRematDAGValuesAt(operand, user, failureRecord, context, values,
                              forcedRematValues);
  }
}

static SmallVector<Value>
collectRematDAGValuesAt(Value value, Operation *user,
                        const RegAllocTransformFailure &failureRecord,
                        const RematReliefContext &context,
                        const DenseSet<Value> *forcedRematValues) {
  DenseSet<Value> values;
  collectRematDAGValuesAt(value, user, failureRecord, context, values,
                          forcedRematValues);
  SmallVector<Value> ordered(values.begin(), values.end());
  llvm::sort(ordered, [&](Value lhs, Value rhs) {
    return context.values.lookup(lhs)->id < context.values.lookup(rhs)->id;
  });
  return ordered;
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

static SmallVector<unsigned>
collectRematPressureLeafSets(ArrayRef<const RematReliefRoot *> roots,
                             const RegAllocTransformFailure &failureRecord,
                             const RematReliefContext &context) {
  DenseSet<unsigned> countedSets;
  for (const RematReliefRoot *root : roots)
    for (const RematReliefSlot &slot : root->slots)
      for (Value leaf : slot.extendedLeaves) {
        auto it = context.values.find(leaf);
        if (it == context.values.end())
          continue;
        if (extendedLeafAddsPressureAtFailure(leaf, slot, failureRecord,
                                              context))
          countedSets.insert(it->second->set);
      }
  SmallVector<unsigned> result(countedSets.begin(), countedSets.end());
  llvm::sort(result);
  return result;
}

static RegClassPressure
getRematExtendedLeafPressure(ArrayRef<const RematReliefRoot *> roots,
                             ArrayRef<wave::RegAllocTransformAliasSet> sets) {
  RegClassPressure pressure = {};
  DenseSet<unsigned> countedSets;
  for (const RematReliefRoot *root : roots)
    for (unsigned setId : root->pressureLeafSets) {
      if (!countedSets.insert(setId).second)
        continue;
      const wave::RegAllocTransformAliasSet *set =
          findRegAllocTransformSet(sets, setId);
      assert(set && "remat leaf alias set missing");
      addRegClassPressure(pressure, set->regClass, set->width);
    }
  return pressure;
}

static RegClassPressure
getRematRemovedPressure(ArrayRef<const RematReliefRoot *> roots) {
  RegClassPressure pressure = {};
  DenseSet<unsigned> countedSets;
  for (const RematReliefRoot *root : roots)
    if (countedSets.insert(root->set->id).second)
      addRegClassPressure(pressure, root->set->regClass, root->set->width);
  return pressure;
}

static bool isFailurePressureClass(waveamdmachine::RegClass regClass,
                                   StringRef failureClassName) {
  if (failureClassName == "sgpr")
    return regClass == waveamdmachine::RegClass::SGPR;
  if (failureClassName == "vgpr")
    return regClass == waveamdmachine::RegClass::VGPR;
  if (failureClassName == "vgpr_agpr")
    return regClass == waveamdmachine::RegClass::VGPR ||
           regClass == waveamdmachine::RegClass::AGPR;
  return false;
}

static int64_t getFailurePressure(RegClassPressure pressure,
                                  StringRef failureClassName) {
  int64_t result = 0;
  for (waveamdmachine::RegClass regClass : kRegClasses)
    if (isFailurePressureClass(regClass, failureClassName))
      result += pressure[getRegClassIndex(regClass)];
  return result;
}

static bool rematRootsReduceFailurePressure(
    func::FuncOp func, ArrayRef<const RematReliefRoot *> roots,
    const RegAllocTransformFailure &failureRecord,
    ArrayRef<wave::RegAllocTransformAliasSet> sets) {
  RegClassPressure added = getRematExtendedLeafPressure(roots, sets);
  RegClassPressure removed = getRematRemovedPressure(roots);
  RegClassPressure before =
      getRegClassPressureAtPosition(sets, failureRecord.position);
  RegClassPressure after = before;
  for (waveamdmachine::RegClass regClass : kRegClasses)
    after[getRegClassIndex(regClass)] +=
        added[getRegClassIndex(regClass)] - removed[getRegClassIndex(regClass)];
  if (getFailurePressure(after, failureRecord.className) >=
      getFailurePressure(before, failureRecord.className))
    return false;
  for (waveamdmachine::RegClass regClass : kRegClasses) {
    unsigned index = getRegClassIndex(regClass);
    if (after[index] < 0)
      return false;
    if (isFailurePressureClass(regClass, failureRecord.className))
      continue;
    wave::RegAllocTransformBudget budget =
        wave::getRegAllocTransformBudget(func, regClass);
    int64_t allowed =
        std::max(before[index], static_cast<int64_t>(budget.limit));
    if (after[index] > allowed)
      return false;
  }
  return true;
}

static bool
rematRootUsesFailurePosition(const RematReliefRoot &root,
                             const RegAllocTransformFailure &failureRecord,
                             const RematReliefContext &context) {
  return llvm::any_of(root.slots, [&](const RematReliefSlot &slot) {
    return llvm::any_of(slot.uses, [&](OpOperand *use) {
      return context.positions.lookup(use->getOwner()) ==
             failureRecord.position;
    });
  });
}

static bool
rematRootsUseFailurePosition(ArrayRef<const RematReliefRoot *> roots) {
  return llvm::any_of(roots, [](const RematReliefRoot *root) {
    return root->usesFailurePosition;
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
  RematReliefSlot slot;
  slot.uses = std::move(uses);
  slot.extendedLeaves = std::move(*extendedLeaves);
  slot.dagValues = collectRematDAGValuesAt(value, rebuildOp, failureRecord,
                                           context, &forcedRematValues);
  slot.value = value;
  slot.rebuildOp = rebuildOp;
  slot.stateValue = &stateValue;
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

static void collectRematRootCost(RematReliefRoot &root) {
  for (const RematReliefSlot &slot : root.slots) {
    root.useCost += slot.uses.size();
    DenseSet<Value> &values = root.siteValues[slot.rebuildOp];
    values.insert(slot.dagValues.begin(), slot.dagValues.end());
  }
  root.cost = root.useCost;
  for (auto &[site, values] : root.siteValues)
    root.cost += values.size() * getRematReliefLoopCostScale(site);
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
                   RematReliefRoot &root) {
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
    root.slots.push_back(std::move(*slot));
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

static void eraseDeadRematDefs(const RematReliefPlan &plan) {
  SmallVector<Operation *> defs;
  DenseSet<Operation *> seen;
  for (const RematReliefRoot &root : plan.roots)
    for (const RematReliefSlot &slot : root.slots) {
      Operation *def = slot.value.getDefiningOp();
      if (def && seen.insert(def).second)
        defs.push_back(def);
    }
  for (Operation *def : llvm::reverse(defs))
    eraseDeadRematProducerTree(def, seen);
}

static unsigned countRematReliefDwords(const RematReliefPlan &plan) {
  unsigned dwords = 0;
  for (const RematReliefRoot &root : plan.roots)
    dwords += root.set->width;
  return dwords;
}

static FailureOr<bool>
addRematReliefSlotsForSet(ArrayRef<ResolvedRegAllocValue> resolvedValues,
                          const RegAllocTransformFailure &failureRecord,
                          const RematReliefContext &context,
                          const DenseSet<Value> &forcedRematValues,
                          RematReliefRoot &root) {
  for (ResolvedRegAllocValue resolved : resolvedValues) {
    FailureOr<bool> added =
        addRematReliefSlot(resolved.first, *resolved.second, failureRecord,
                           context, forcedRematValues, root);
    if (failed(added))
      return failure();
    if (!*added)
      return false;
  }
  return true;
}

static bool
rematRootsPassPressureCheck(func::FuncOp func,
                            ArrayRef<const RematReliefRoot *> roots,
                            const RegAllocTransformFailure &failureRecord,
                            ArrayRef<wave::RegAllocTransformAliasSet> sets) {
  if (rematRootsUseFailurePosition(roots))
    return true;
  return rematRootsReduceFailurePressure(func, roots, failureRecord, sets);
}

static FailureOr<std::optional<RematReliefRoot>>
buildRematReliefRoot(func::FuncOp func, unsigned setId,
                     const RegAllocTransformFailure &failureRecord,
                     ArrayRef<wave::RegAllocTransformAliasSet> sets,
                     ArrayRef<wave::RegAllocTransformValue> values,
                     const RematReliefContext &context) {
  const wave::RegAllocTransformAliasSet *set =
      findRegAllocTransformSet(sets, setId);
  if (!set || !isRematCandidateSet(*set, values, failureRecord))
    return std::optional<RematReliefRoot>();
  FailureOr<SmallVector<ResolvedRegAllocValue>> resolvedValues =
      resolveSetValues(func, *set, values);
  if (failed(resolvedValues))
    return failure();
  if (hasStructuralLoopCarryUse(*resolvedValues))
    return std::optional<RematReliefRoot>();

  RematReliefRoot root;
  DenseSet<Value> forcedRematValues;
  root.set = set;
  addForcedRematValues(*resolvedValues, failureRecord, root.rematValues,
                       forcedRematValues);
  FailureOr<bool> added = addRematReliefSlotsForSet(
      *resolvedValues, failureRecord, context, forcedRematValues, root);
  if (failed(added))
    return failure();
  if (!*added)
    return std::optional<RematReliefRoot>();
  if (root.slots.empty())
    return std::optional<RematReliefRoot>();
  sortRematReliefSlots(root.slots);
  collectRematRootCost(root);
  std::array<const RematReliefRoot *, 1> roots = {&root};
  root.pressureLeafSets =
      collectRematPressureLeafSets(roots, failureRecord, context);
  root.usesFailurePosition =
      rematRootUsesFailurePosition(root, failureRecord, context);
  return std::optional<RematReliefRoot>(std::move(root));
}

static int64_t getRematPlanCost(ArrayRef<const RematReliefRoot *> roots) {
  DenseMap<Operation *, DenseSet<Value>> siteValues;
  int64_t cost = 0;
  for (const RematReliefRoot *root : roots) {
    cost += root->useCost;
    for (auto &[site, rootValues] : root->siteValues) {
      DenseSet<Value> &values = siteValues[site];
      values.insert(rootValues.begin(), rootValues.end());
    }
  }
  for (auto &[site, values] : siteValues)
    cost += values.size() * getRematReliefLoopCostScale(site);
  return cost;
}

static RematBundleSearchContext
buildRematBundleSearchContext(func::FuncOp func,
                              const RegAllocTransformFailure &failureRecord,
                              ArrayRef<wave::RegAllocTransformAliasSet> sets) {
  RematBundleSearchContext context;
  context.before = getRegClassPressureAtPosition(sets, failureRecord.position);
  context.failureClassName = failureRecord.className;
  for (const wave::RegAllocTransformAliasSet &set : sets) {
    assert(!context.sets.contains(set.id) && "duplicate remat alias set ID");
    context.sets[set.id] = &set;
  }
  for (waveamdmachine::RegClass regClass : kRegClasses) {
    unsigned index = getRegClassIndex(regClass);
    wave::RegAllocTransformBudget budget =
        wave::getRegAllocTransformBudget(func, regClass);
    context.allowed[index] =
        std::max(context.before[index], static_cast<int64_t>(budget.limit));
  }
  return context;
}

static const wave::RegAllocTransformAliasSet &
getRematBundleSet(const RematBundleSearchContext &context, unsigned setId) {
  const wave::RegAllocTransformAliasSet *set = context.sets.lookup(setId);
  assert(set && "remat bundle alias set missing");
  return *set;
}

static int64_t getRematRootIncrementalCost(const RematReliefRoot &root,
                                           const RematBundleState &state) {
  int64_t cost = root.useCost;
  for (auto &[site, values] : root.siteValues) {
    int64_t scale = getRematReliefLoopCostScale(site);
    auto existing = state.siteValues.find(site);
    for (Value value : values)
      if (existing == state.siteValues.end() ||
          !existing->second.contains(value))
        cost += scale;
  }
  return cost;
}

static RegClassPressure
getRematRootExtensionAddedPressure(const RematReliefRoot &root,
                                   const RematBundleState &state,
                                   const RematBundleSearchContext &context) {
  RegClassPressure added = state.added;
  for (unsigned setId : root.pressureLeafSets) {
    if (state.pressureLeafSets.contains(setId))
      continue;
    const wave::RegAllocTransformAliasSet &set =
        getRematBundleSet(context, setId);
    addRegClassPressure(added, set.regClass, set.width);
  }
  return added;
}

static RegClassPressure
getRematRootExtensionRemovedPressure(const RematReliefRoot &root,
                                     const RematBundleState &state) {
  RegClassPressure removed = state.removed;
  addRegClassPressure(removed, root.set->regClass, root.set->width);
  return removed;
}

static bool rematPressuresRespectOtherClassBudgets(
    RegClassPressure added, RegClassPressure removed,
    const RematBundleSearchContext &context) {
  for (waveamdmachine::RegClass regClass : kRegClasses) {
    unsigned index = getRegClassIndex(regClass);
    int64_t after = context.before[index] + added[index] - removed[index];
    if (after < 0)
      return false;
    if (!isFailurePressureClass(regClass, context.failureClassName) &&
        after > context.allowed[index])
      return false;
  }
  return true;
}

static int64_t
getRematBundleFailurePressureGain(RegClassPressure added,
                                  RegClassPressure removed,
                                  const RematBundleSearchContext &context) {
  return getFailurePressure(removed, context.failureClassName) -
         getFailurePressure(added, context.failureClassName);
}

static bool rootConnectsToBundle(const RematReliefRoot &root,
                                 const RematBundleState &state) {
  if (state.indices.empty())
    return true;
  return llvm::any_of(root.pressureLeafSets, [&](unsigned setId) {
    return state.pressureLeafSets.contains(setId);
  });
}

static std::optional<RematRootExtension>
getRematRootExtension(unsigned index, ArrayRef<RematReliefRoot> roots,
                      const RematBundleState &state,
                      const RematBundleSearchContext &context) {
  const RematReliefRoot &root = roots[index];
  if (state.selectedRoots.contains(index) || !rootConnectsToBundle(root, state))
    return std::nullopt;
  assert(isFailurePressureClass(root.set->regClass, context.failureClassName) &&
         "remat root outside failure class");
  RegClassPressure added =
      getRematRootExtensionAddedPressure(root, state, context);
  RegClassPressure removed = getRematRootExtensionRemovedPressure(root, state);
  bool usesFailurePosition =
      state.usesFailurePosition || root.usesFailurePosition;
  // Other-class overflow cannot recover: roots remove failure-class pressure.
  if (!usesFailurePosition &&
      !rematPressuresRespectOtherClassBudgets(added, removed, context))
    return std::nullopt;
  return RematRootExtension{
      getRematBundleFailurePressureGain(added, removed, context),
      state.cost + getRematRootIncrementalCost(root, state), index};
}

static void addRematRootToBundle(unsigned index,
                                 ArrayRef<RematReliefRoot> roots,
                                 const RematBundleSearchContext &context,
                                 RematBundleState &state) {
  const RematReliefRoot &root = roots[index];
  assert(state.selectedRoots.insert(index).second &&
         "duplicate remat bundle root");
  state.indices.push_back(index);
  state.cost += getRematRootIncrementalCost(root, state);
  for (auto &[site, values] : root.siteValues) {
    DenseSet<Value> &siteValues = state.siteValues[site];
    siteValues.insert(values.begin(), values.end());
  }
  addRegClassPressure(state.removed, root.set->regClass, root.set->width);
  for (unsigned setId : root.pressureLeafSets) {
    if (!state.pressureLeafSets.insert(setId).second)
      continue;
    const wave::RegAllocTransformAliasSet &set =
        getRematBundleSet(context, setId);
    addRegClassPressure(state.added, set.regClass, set.width);
  }
  state.usesFailurePosition |= root.usesFailurePosition;
}

static bool
rematBundlePassesPressureCheck(const RematBundleState &state,
                               const RematBundleSearchContext &context) {
  if (state.usesFailurePosition)
    return true;
  return getRematBundleFailurePressureGain(state.added, state.removed,
                                           context) > 0 &&
         rematPressuresRespectOtherClassBudgets(state.added, state.removed,
                                                context);
}

static bool rematRootsAreConnected(ArrayRef<const RematReliefRoot *> roots) {
  if (roots.size() < 2)
    return true;
  DenseMap<unsigned, SmallVector<unsigned>> rootsByLeaf;
  for (auto [index, root] : llvm::enumerate(roots))
    for (unsigned setId : root->pressureLeafSets)
      rootsByLeaf[setId].push_back(static_cast<unsigned>(index));
  SmallVector<char> reached(roots.size(), false);
  SmallVector<unsigned> worklist = {0};
  reached.front() = true;
  for (unsigned cursor = 0; cursor < worklist.size(); ++cursor) {
    unsigned index = worklist[cursor];
    for (unsigned setId : roots[index]->pressureLeafSets) {
      auto neighbors = rootsByLeaf.find(setId);
      assert(neighbors != rootsByLeaf.end() && "remat leaf has no roots");
      for (unsigned neighbor : neighbors->second)
        if (!reached[neighbor]) {
          reached[neighbor] = true;
          worklist.push_back(neighbor);
        }
    }
  }
  return llvm::all_of(reached, [](char value) { return value; });
}

static bool
isBetterRematRootExtension(const RematRootExtension &candidate,
                           const std::optional<RematRootExtension> &best,
                           ArrayRef<RematReliefRoot> roots) {
  if (!best)
    return true;
  if (candidate.gain != best->gain)
    return candidate.gain > best->gain;
  if (candidate.cost != best->cost)
    return candidate.cost < best->cost;
  return roots[candidate.index].set->id < roots[best->index].set->id;
}

static SmallVector<const RematReliefRoot *>
getRematRootRefs(ArrayRef<RematReliefRoot> roots, ArrayRef<unsigned> indices) {
  SmallVector<const RematReliefRoot *> result;
  result.reserve(indices.size());
  for (unsigned index : indices)
    result.push_back(&roots[index]);
  return result;
}

static void
pruneRematRootIndices(func::FuncOp func, SmallVectorImpl<unsigned> &indices,
                      ArrayRef<RematReliefRoot> roots,
                      const RegAllocTransformFailure &failureRecord,
                      ArrayRef<wave::RegAllocTransformAliasSet> sets) {
  while (indices.size() > 1) {
    SmallVector<unsigned> removalOrder(indices.begin(), indices.end());
    llvm::stable_sort(removalOrder, [&](unsigned lhs, unsigned rhs) {
      return std::tie(roots[lhs].cost, roots[lhs].set->id) >
             std::tie(roots[rhs].cost, roots[rhs].set->id);
    });
    bool removed = false;
    for (unsigned remove : removalOrder) {
      SmallVector<unsigned> trial;
      for (unsigned index : indices)
        if (index != remove)
          trial.push_back(index);
      SmallVector<const RematReliefRoot *> refs =
          getRematRootRefs(roots, trial);
      if (!rematRootsAreConnected(refs) ||
          !rematRootsPassPressureCheck(func, refs, failureRecord, sets))
        continue;
      indices.assign(trial.begin(), trial.end());
      removed = true;
      break;
    }
    if (!removed)
      return;
  }
}

static std::optional<SmallVector<unsigned>>
growRematRootBundle(func::FuncOp func, unsigned seed,
                    ArrayRef<RematReliefRoot> roots,
                    const RegAllocTransformFailure &failureRecord,
                    ArrayRef<wave::RegAllocTransformAliasSet> sets,
                    const RematBundleSearchContext &context) {
  RematBundleState state;
  std::optional<RematRootExtension> seedExtension =
      getRematRootExtension(seed, roots, state, context);
  if (!seedExtension)
    return std::nullopt;
  addRematRootToBundle(seed, roots, context, state);
  while (true) {
    if (rematBundlePassesPressureCheck(state, context)) {
      pruneRematRootIndices(func, state.indices, roots, failureRecord, sets);
      return state.indices;
    }

    std::optional<RematRootExtension> next;
    for (unsigned index : llvm::seq<unsigned>(roots.size())) {
      std::optional<RematRootExtension> candidate =
          getRematRootExtension(index, roots, state, context);
      if (!candidate)
        continue;
      if (isBetterRematRootExtension(*candidate, next, roots))
        next = *candidate;
    }
    if (!next)
      return std::nullopt;
    addRematRootToBundle(next->index, roots, context, state);
  }
}

static RematReliefPlan buildRematReliefPlan(ArrayRef<RematReliefRoot> roots,
                                            ArrayRef<unsigned> indices) {
  RematReliefPlan plan;
  SmallVector<const RematReliefRoot *> refs = getRematRootRefs(roots, indices);
  plan.cost = getRematPlanCost(refs);
  for (unsigned index : indices)
    plan.roots.push_back(roots[index]);
  llvm::sort(plan.roots,
             [](const RematReliefRoot &lhs, const RematReliefRoot &rhs) {
               return lhs.set->id < rhs.set->id;
             });
  return plan;
}

static bool isBetterRematPlan(const RematReliefPlan &candidate,
                              const std::optional<RematReliefPlan> &best) {
  if (!best)
    return true;
  if (candidate.cost != best->cost)
    return candidate.cost < best->cost;
  if (candidate.roots.size() != best->roots.size())
    return candidate.roots.size() < best->roots.size();
  for (auto [candidateRoot, bestRoot] :
       llvm::zip_equal(candidate.roots, best->roots))
    if (candidateRoot.set->id != bestRoot.set->id)
      return candidateRoot.set->id < bestRoot.set->id;
  return false;
}

static FailureOr<std::optional<RematReliefPlan>>
selectRematReliefPlan(func::FuncOp func,
                      const RegAllocTransformFailure &failureRecord,
                      ArrayRef<wave::RegAllocTransformAliasSet> sets,
                      ArrayRef<wave::RegAllocTransformValue> values,
                      const RematReliefContext &context) {
  SmallVector<RematReliefRoot, 0> roots;
  for (unsigned setId : collectRematReliefCandidateIds(failureRecord)) {
    FailureOr<std::optional<RematReliefRoot>> root =
        buildRematReliefRoot(func, setId, failureRecord, sets, values, context);
    if (failed(root))
      return failure();
    if (*root)
      roots.push_back(std::move(**root));
  }
  llvm::sort(roots, [](const RematReliefRoot &lhs, const RematReliefRoot &rhs) {
    return lhs.set->id < rhs.set->id;
  });

  RematBundleSearchContext searchContext =
      buildRematBundleSearchContext(func, failureRecord, sets);
  std::optional<RematReliefPlan> best;
  for (unsigned seed : llvm::seq<unsigned>(roots.size())) {
    std::optional<SmallVector<unsigned>> indices = growRematRootBundle(
        func, seed, roots, failureRecord, sets, searchContext);
    if (!indices)
      continue;
    RematReliefPlan candidate = buildRematReliefPlan(roots, *indices);
    if (isBetterRematPlan(candidate, best))
      best = std::move(candidate);
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
    DenseMap<Value, Value> &cache,
    SmallVectorImpl<std::pair<const RematReliefSlot *, Value>> &rebuiltSlots) {
  builder.setInsertionPoint(slot.rebuildOp);
  FailureOr<Value> rebuilt =
      materializeRematValueAt(builder, slot.value, slot.rebuildOp,
                              failureRecord, context, cache, forcedRematValues);
  if (failed(rebuilt))
    return failure();
  rebuiltSlots.push_back({&slot, *rebuilt});
  return success();
}

static LogicalResult
materializeRematRelief(OpBuilder &builder, const RematReliefPlan &plan,
                       const RegAllocTransformFailure &failureRecord,
                       const RematReliefContext &context) {
  DenseMap<Operation *, DenseMap<Value, Value>> siteCaches;
  SmallVector<std::pair<const RematReliefSlot *, Value>> rebuiltSlots;
  for (const RematReliefRoot &root : plan.roots) {
    DenseSet<Value> forcedRematValues(root.rematValues.begin(),
                                      root.rematValues.end());
    for (const RematReliefSlot &slot : root.slots) {
      DenseMap<Value, Value> &cache = siteCaches[slot.rebuildOp];
      if (failed(materializeRematReliefSlot(builder, slot, failureRecord,
                                            context, forcedRematValues, cache,
                                            rebuiltSlots)))
        return failure();
    }
  }
  for (auto [slot, rebuilt] : rebuiltSlots)
    for (OpOperand *use : slot->uses)
      use->set(rebuilt);
  eraseDeadRematDefs(plan);
  return success();
}

static LogicalResult
materializeSelectedRematRelief(OpBuilder &builder, func::FuncOp func,
                               const RematReliefPlan &plan,
                               const RegAllocTransformFailure &failureRecord,
                               const RematReliefContext &context) {
  if (failed(materializeRematRelief(builder, plan, failureRecord, context)))
    return failure();
  return wave::addRegAllocTransformProviderMetadata(
      func, builder, "remat", countRematReliefDwords(plan));
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
  FailureOr<std::optional<RematReliefPlan>> plan =
      selectRematReliefPlan(func, **failureRecord, *sets, *values, context);
  if (failed(plan))
    return failure();
  if (!*plan)
    return success();

  OpBuilder builder(func.getContext());
  if (failed(materializeSelectedRematRelief(builder, func, **plan,
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
