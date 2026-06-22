//===- WaveAMDRegAllocRemat.cpp - Rematerialization relief -----*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "WaveAMDRegAllocInternal.h"

#include "mlir/IR/Builders.h"
#include "mlir/IR/BuiltinAttributes.h"
#include "mlir/IR/IRMapping.h"
#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/DenseSet.h"
#include "llvm/Support/raw_ostream.h"

#include <algorithm>

using namespace mlir;
using namespace mlir::wave::regalloc;

namespace {

static bool isLiveAt(Interval *interval, unsigned position) {
  return !interval->values.empty() && interval->start <= position &&
         position <= interval->end;
}

static bool isRematCandidateGroup(IntervalGroup *group, unsigned position) {
  return isMemorySpillVGPRGroup(group) &&
         hasLiveMemorySpillLane(group, position);
}

static bool isTrackedRegClass(waveamdmachine::RegClass regClass) {
  return regClass == waveamdmachine::RegClass::SGPR ||
         regClass == waveamdmachine::RegClass::VGPR ||
         regClass == waveamdmachine::RegClass::AGPR;
}

static unsigned getLoopDepth(Operation *op) {
  unsigned depth = 0;
  for (Operation *cur = op; cur; cur = cur->getParentOp())
    if (isa<waveamdmachine::UniformLoopOp>(cur))
      ++depth;
  return depth;
}

static int64_t getValueOrder(Value value, Inventory &inventory) {
  if (Operation *def = value.getDefiningOp()) {
    int64_t pos = inventory.positions.lookup(def);
    return pos * 1024 + cast<OpResult>(value).getResultNumber();
  }
  auto arg = cast<BlockArgument>(value);
  Operation *parent = arg.getOwner()->getParentOp();
  int64_t pos = isa_and_nonnull<func::FuncOp>(parent)
                    ? 0
                    : inventory.positions.lookup(parent);
  return pos * 1024 + arg.getArgNumber();
}

static SmallVector<Value> getGroupValues(IntervalGroup *group,
                                         Inventory &inventory) {
  SmallVector<Value> values;
  llvm::SmallDenseSet<Value, 8> seen;
  for (Interval *lane : group->intervals)
    for (Value value : lane->values)
      if (seen.insert(value).second)
        values.push_back(value);
  llvm::stable_sort(values, [&](Value lhs, Value rhs) {
    return getValueOrder(lhs, inventory) < getValueOrder(rhs, inventory);
  });
  return values;
}

class RematPlan final : public wave::WaveAMDPressureReliefPlan {
public:
  RematPlan(IntervalGroup *group, Value value, unsigned useCount,
            unsigned reliefDwords)
      : group(group), value(value), useCount(useCount),
        reliefDwords(reliefDwords) {}

  wave::WaveAMDPressureReliefProviderKind getProviderKind() const override {
    return wave::WaveAMDPressureReliefProviderKind::Rematerialize;
  }

  StringRef getProviderName() const override { return "remat"; }
  unsigned getReliefDwords() const override { return reliefDwords; }

  IntervalGroup *getGroup() const { return group; }
  unsigned getUseCount() const { return useCount; }
  Value getValue() const { return value; }

private:
  IntervalGroup *group = nullptr;
  Value value;
  unsigned useCount = 0;
  unsigned reliefDwords = 0;
};

class RematCandidate final : public wave::WaveAMDPressureReliefCandidate {
public:
  RematCandidate(IntervalGroup *group, Value value, unsigned useCount,
                 unsigned reliefDwords, wave::WaveAMDPressureReliefCost cost)
      : cost(cost), group(group), value(value), useCount(useCount),
        reliefDwords(reliefDwords) {}

  StringRef getProviderName() const override { return "remat"; }
  wave::WaveAMDPressureReliefCost getCost() const override { return cost; }
  unsigned getReliefDwords() const override { return reliefDwords; }

  IntervalGroup *getGroup() const { return group; }
  unsigned getUseCount() const { return useCount; }
  Value getValue() const { return value; }
  std::unique_ptr<wave::WaveAMDPressureReliefPlan> getPlan() const {
    return std::make_unique<RematPlan>(group, value, useCount, reliefDwords);
  }

protected:
  void printExtra(llvm::raw_ostream &os) const override {
    os << ", uses=" << useCount;
  }

  void setExtraDiagnosticAttrs(Builder &builder,
                               NamedAttrList &attrs) const override {
    attrs.set("pressure_relief", builder.getI64IntegerAttr(reliefDwords));
    attrs.set("uses", builder.getI64IntegerAttr(useCount));
  }

private:
  wave::WaveAMDPressureReliefCost cost;
  IntervalGroup *group = nullptr;
  Value value;
  unsigned useCount = 0;
  unsigned reliefDwords = 0;
};

class RematProvider final : public wave::WaveAMDPressureReliefProvider {
public:
  RematProvider(ArrayRef<IntervalGroup *> groups, IntervalGroup *request,
                unsigned position, Inventory &inventory)
      : groups(groups), inventory(inventory), request(request),
        position(position) {}

  StringRef getName() const override { return "remat"; }
  wave::WaveAMDPressureReliefProviderKind getKind() const override {
    return wave::WaveAMDPressureReliefProviderKind::Rematerialize;
  }

  LogicalResult collectCandidates(
      const wave::WaveAMDPressureReliefQuery &query,
      wave::WaveAMDPressureReliefCandidateList &candidates) const override {
    pressureFailure = query.failure;
    if (!isCombinedPressure())
      return success();
    for (IntervalGroup *group : groups)
      collect(group, candidates);
    collect(request, candidates);
    return success();
  }

  std::unique_ptr<wave::WaveAMDPressureReliefPlan> createPlan(
      const wave::WaveAMDPressureReliefCandidate &candidate) const override {
    const RematCandidate &remat =
        static_cast<const RematCandidate &>(candidate);
    return remat.getPlan();
  }

  void applyPlan(const wave::WaveAMDPressureReliefPlan &plan) const override {
    const RematPlan &remat = static_cast<const RematPlan &>(plan);
    if (!remat.getGroup())
      return;
    remat.getGroup()->plannedPressureRelief = true;
    remat.getGroup()->assignedBase.reset();
  }

  LogicalResult materializePlan(const wave::WaveAMDPressureReliefPlan &plan,
                                OpBuilder &builder) const override {
    const RematPlan &remat = static_cast<const RematPlan &>(plan);
    return materializeValue(remat.getValue(), builder);
  }

  bool isBetterCandidate(
      const wave::WaveAMDPressureReliefCandidate &lhs,
      const wave::WaveAMDPressureReliefCandidate &rhs) const override {
    if (lhs.isLegal() != rhs.isLegal())
      return lhs.isLegal();
    const RematCandidate &lhsRemat = static_cast<const RematCandidate &>(lhs);
    const RematCandidate &rhsRemat = static_cast<const RematCandidate &>(rhs);
    if (lhsRemat.getGroup()->intervals.front()->end !=
        rhsRemat.getGroup()->intervals.front()->end)
      return lhsRemat.getGroup()->intervals.front()->end >
             rhsRemat.getGroup()->intervals.front()->end;
    return wave::isBetterWaveAMDPressureReliefCandidate(lhs, rhs);
  }

private:
  bool isCombinedPressure() const {
    return pressureFailure && pressureFailure->combinedVGPRAGPR;
  }

  bool hasUseNearPressure(ArrayRef<OpOperand *> uses) const {
    for (OpOperand *use : uses) {
      unsigned usePosition = inventory.positions.lookup(use->getOwner());
      if (pressureFailure->position <= usePosition &&
          usePosition <= pressureFailure->position + 1)
        return true;
    }
    return false;
  }

  bool hasSimpleUses(Value value, SmallVectorImpl<OpOperand *> &uses) const {
    Operation *def = value.getDefiningOp();
    if (!def || isMemoryIssuerOp(def) || def->getNumResults() != 1)
      return false;
    Block *block = def->getBlock();
    for (OpOperand &use : value.getUses()) {
      Operation *user = use.getOwner();
      if (isLoopCarryUseOp(user))
        return false;
      if (user->getBlock() != block)
        return false;
      uses.push_back(&use);
    }
    return !uses.empty();
  }

  bool isTrackedRegValue(Value value) const {
    auto type = dyn_cast<waveamdmachine::RegType>(value.getType());
    return type && isTrackedRegClass(type.getRegClass());
  }

  bool isFixedRegValue(Value value) const {
    auto type = dyn_cast<waveamdmachine::RegType>(value.getType());
    return type && type.getIndex() >= 0;
  }

  bool isValueLiveAt(Value value, unsigned position) const {
    if (isFixedRegValue(value))
      return true;
    Interval *interval = inventory.intervalFor.lookup(value);
    return interval && isLiveAt(interval, position);
  }

  Operation *getLocalCheapDef(Value value, Operation *user) const {
    Operation *def = value.getDefiningOp();
    if (!def || def->getNumResults() != 1)
      return nullptr;
    if (def->getBlock() != user->getBlock())
      return nullptr;
    if (isRegAllocTempOp(def) || isMemoryIssuerOp(def))
      return nullptr;
    return isCheapVGPRExpr(def) ? def : nullptr;
  }

  bool needsOperandRemat(Value operand, unsigned userPosition) const {
    return isTrackedRegValue(operand) && !isValueLiveAt(operand, userPosition);
  }

  bool canRematerializeOperandsAt(Operation *def, Operation *user,
                                  DenseSet<Value> &visiting) const {
    unsigned userPosition = inventory.positions.lookup(user);
    for (Value operand : def->getOperands())
      if (needsOperandRemat(operand, userPosition) &&
          !canRematerializeTreeAt(operand, user, visiting))
        return false;
    return true;
  }

  bool canRematerializeTreeAt(Value value, Operation *user,
                              DenseSet<Value> &visiting) const {
    Operation *def = getLocalCheapDef(value, user);
    if (!def)
      return false;
    if (!visiting.insert(value).second)
      return false;
    bool canRemat = canRematerializeOperandsAt(def, user, visiting);
    visiting.erase(value);
    return canRemat;
  }

  bool canRematerializeTreeAt(Value value, Operation *user) const {
    DenseSet<Value> visiting;
    return canRematerializeTreeAt(value, user, visiting);
  }

  bool canRematerializeAtUses(Value value, ArrayRef<OpOperand *> uses) const {
    for (OpOperand *use : uses)
      if (!canRematerializeTreeAt(value, use->getOwner()))
        return false;
    return true;
  }

  unsigned getRematOpCountAt(Value value, Operation *user,
                             DenseSet<Value> &materialized) const {
    if (!materialized.insert(value).second)
      return 0;
    Operation *def = value.getDefiningOp();
    assert(def && "remat candidate must have defining op");
    unsigned count = 1;
    unsigned userPosition = inventory.positions.lookup(user);
    for (Value operand : def->getOperands()) {
      if (!isTrackedRegValue(operand) || isValueLiveAt(operand, userPosition))
        continue;
      count += getRematOpCountAt(operand, user, materialized);
    }
    return count;
  }

  bool valueCoversWholeGroup(IntervalGroup *group, Value value) const {
    auto type = dyn_cast<waveamdmachine::RegType>(value.getType());
    if (!type ||
        static_cast<unsigned>(type.getWidth()) != group->intervals.size())
      return false;
    Interval *first = inventory.intervalFor.lookup(value);
    return first && first->group == group && first == group->intervals.front();
  }

  unsigned getLiveLaneCount(IntervalGroup *group) const {
    unsigned count = 0;
    for (Interval *lane : group->intervals)
      if (isLiveAt(lane, position))
        ++count;
    return count;
  }

  bool valueStartsBeforePressure(Value value) const {
    Interval *interval = inventory.intervalFor.lookup(value);
    return interval && interval->start < position;
  }

  std::optional<unsigned> getPressureRelief(IntervalGroup *group, Value value,
                                            ArrayRef<OpOperand *> uses) const {
    unsigned liveLanes = getLiveLaneCount(group);
    if (!valueStartsBeforePressure(value))
      return 0;
    if (hasUseNearPressure(uses))
      return 0;
    return liveLanes;
  }

  wave::WaveAMDPressureReliefCost
  getRematCost(Value value, ArrayRef<OpOperand *> uses) const {
    wave::WaveAMDPressureReliefCost cost;
    cost.loopWeightedOps = getLoopDepth(value.getDefiningOp());
    for (OpOperand *use : uses) {
      DenseSet<Value> materialized;
      cost.materializationOps +=
          getRematOpCountAt(value, use->getOwner(), materialized);
      cost.loopWeightedOps += getLoopDepth(use->getOwner());
    }
    return cost;
  }

  bool isCandidateRoot(IntervalGroup *group, Value value) const {
    auto type = dyn_cast<waveamdmachine::RegType>(value.getType());
    Operation *def = value.getDefiningOp();
    if (!type || type.getRegClass() != waveamdmachine::RegClass::VGPR)
      return false;
    if (type.getWidth() == 0 || !def)
      return false;
    if (isRegAllocTempOp(def) || !isCheapVGPRExpr(def))
      return false;
    return valueCoversWholeGroup(group, value);
  }

  void
  collectValue(IntervalGroup *group, Value value,
               wave::WaveAMDPressureReliefCandidateList &candidates) const {
    if (!isCandidateRoot(group, value))
      return;
    SmallVector<OpOperand *> uses;
    if (!hasSimpleUses(value, uses))
      return;
    if (!canRematerializeAtUses(value, uses))
      return;
    std::optional<unsigned> pressureRelief =
        getPressureRelief(group, value, uses);
    if (!pressureRelief || *pressureRelief == 0)
      return;
    candidates.push_back(std::make_unique<RematCandidate>(
        group, value, uses.size(), *pressureRelief, getRematCost(value, uses)));
  }

  void collect(IntervalGroup *group,
               wave::WaveAMDPressureReliefCandidateList &candidates) const {
    if (!isRematCandidateGroup(group, position))
      return;
    for (Value value : getGroupValues(group, inventory))
      collectValue(group, value, candidates);
  }

  FailureOr<Value> materializeTreeAt(Value value, Operation *user,
                                     OpBuilder &builder,
                                     DenseMap<Value, Value> &cache) const {
    if (Value cached = cache.lookup(value))
      return cached;
    Operation *def = value.getDefiningOp();
    if (!def || !canRematerializeTreeAt(value, user))
      return mlir::emitError(value.getLoc())
             << "waveamd-reg-alloc cannot rematerialize value tree";

    IRMapping mapper;
    unsigned userPosition = inventory.positions.lookup(user);
    for (Value operand : def->getOperands()) {
      Value replacement = operand;
      if (isTrackedRegValue(operand) && !isValueLiveAt(operand, userPosition)) {
        FailureOr<Value> rematOperand =
            materializeTreeAt(operand, user, builder, cache);
        if (failed(rematOperand))
          return failure();
        replacement = *rematOperand;
      }
      mapper.map(operand, replacement);
    }

    builder.setInsertionPoint(user);
    Operation *clone = builder.clone(*def, mapper);
    clone->setAttr(kRegAllocTempAttr, builder.getUnitAttr());
    Value replacement = clone->getResult(0);
    cache[value] = replacement;
    return replacement;
  }

  LogicalResult materializeValue(Value value, OpBuilder &builder) const {
    Operation *def = value.getDefiningOp();
    if (!def || def->getNumResults() != 1)
      return mlir::emitError(value.getLoc())
             << "waveamd-reg-alloc cannot rematerialize value";
    SmallVector<OpOperand *> uses;
    if (!hasSimpleUses(value, uses))
      return mlir::emitError(value.getLoc())
             << "waveamd-reg-alloc cannot rematerialize value uses";
    if (!canRematerializeAtUses(value, uses))
      return mlir::emitError(value.getLoc())
             << "waveamd-reg-alloc cannot rematerialize value tree";

    llvm::stable_sort(uses, [&](OpOperand *lhs, OpOperand *rhs) {
      return inventory.positions.lookup(lhs->getOwner()) <
             inventory.positions.lookup(rhs->getOwner());
    });

    DenseMap<Operation *, DenseMap<Value, Value>> rematForUser;
    for (OpOperand *use : uses) {
      if (use->get() != value)
        continue;
      Operation *user = use->getOwner();
      FailureOr<Value> replacement =
          materializeTreeAt(value, user, builder, rematForUser[user]);
      if (failed(replacement))
        return failure();
      use->set(*replacement);
    }
    if (def->use_empty())
      def->erase();
    return success();
  }

  ArrayRef<IntervalGroup *> groups;
  Inventory &inventory;
  IntervalGroup *request = nullptr;
  unsigned position = 0;
  mutable const PressureFailure *pressureFailure = nullptr;
};

} // namespace

std::unique_ptr<wave::WaveAMDPressureReliefProvider>
mlir::wave::regalloc::createRematerializeProvider(
    ArrayRef<IntervalGroup *> groups, IntervalGroup *request, unsigned position,
    Inventory &inventory) {
  return std::make_unique<RematProvider>(groups, request, position, inventory);
}
