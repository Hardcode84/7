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

static constexpr int64_t kFallbackRootPenalty = 1000000000;
static constexpr llvm::StringLiteral kFixedResultsAttr =
    "waveamdmachine.regalloc_fixed_results";

static bool isAuthoredFixedResult(Value value) {
  OpResult result = dyn_cast<OpResult>(value);
  if (!result)
    return false;
  Operation *op = result.getOwner();
  if (isa<waveamdmachine::KernargPreloadOp, waveamdmachine::SWorkgroupIdXOp,
          waveamdmachine::SWorkgroupIdYOp, waveamdmachine::SWorkgroupIdZOp,
          waveamdmachine::UninitOp, waveamdmachine::VWorkitemIdXOp>(op))
    return true;
  DenseI64ArrayAttr fixedResults =
      op->getAttrOfType<DenseI64ArrayAttr>(kFixedResultsAttr);
  return fixedResults && llvm::is_contained(fixedResults.asArrayRef(),
                                            int64_t{result.getResultNumber()});
}

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

static void eraseDeadRematTree(Operation *op) {
  if (!op || op->getNumResults() == 0)
    return;
  if (!std::all_of(op->result_begin(), op->result_end(),
                   [](Value result) { return result.use_empty(); }))
    return;
  if (isRegAllocTempOp(op) || isMemoryIssuerOp(op) ||
      !isCheapVGPRPressureReliefExpr(op))
    return;
  SmallVector<Value> operands(op->getOperands());
  op->erase();
  for (Value operand : operands)
    eraseDeadRematTree(operand.getDefiningOp());
}

struct RematValueSlot {
  Value value;
  wave::WaveAMDPressureReliefCost cost;
  unsigned useCount = 0;
};

class RematPlan final : public wave::WaveAMDPressureReliefPlan {
public:
  RematPlan(IntervalGroup *group, ArrayRef<RematValueSlot> valueSlots,
            unsigned reliefDwords)
      : valueSlots(valueSlots), group(group), reliefDwords(reliefDwords) {}

  wave::WaveAMDPressureReliefProviderKind getProviderKind() const override {
    return wave::WaveAMDPressureReliefProviderKind::Rematerialize;
  }

  StringRef getProviderName() const override { return "remat"; }
  unsigned getReliefDwords() const override { return reliefDwords; }

  IntervalGroup *getGroup() const { return group; }
  unsigned getUseCount() const {
    return getMemorySpillTotalUseCount(valueSlots);
  }
  ArrayRef<RematValueSlot> getValueSlots() const { return valueSlots; }

private:
  SmallVector<RematValueSlot, 4> valueSlots;
  IntervalGroup *group = nullptr;
  unsigned reliefDwords = 0;
};

class RematCandidate final : public wave::WaveAMDPressureReliefCandidate {
public:
  RematCandidate(IntervalGroup *group, ArrayRef<RematValueSlot> valueSlots,
                 unsigned reliefDwords, wave::WaveAMDPressureReliefCost cost)
      : valueSlots(valueSlots), cost(cost), group(group),
        reliefDwords(reliefDwords) {}

  StringRef getProviderName() const override { return "remat"; }
  wave::WaveAMDPressureReliefCost getCost() const override { return cost; }
  unsigned getReliefDwords() const override { return reliefDwords; }

  IntervalGroup *getGroup() const { return group; }
  unsigned getUseCount() const {
    return getMemorySpillTotalUseCount(valueSlots);
  }
  ArrayRef<RematValueSlot> getValueSlots() const { return valueSlots; }
  std::unique_ptr<wave::WaveAMDPressureReliefPlan> getPlan() const {
    return std::make_unique<RematPlan>(group, valueSlots, reliefDwords);
  }

protected:
  void printExtra(llvm::raw_ostream &os) const override {
    os << ", uses=" << getUseCount();
  }

  void setExtraDiagnosticAttrs(Builder &builder,
                               NamedAttrList &attrs) const override {
    attrs.set("pressure_relief", builder.getI64IntegerAttr(reliefDwords));
    attrs.set("uses", builder.getI64IntegerAttr(getUseCount()));
  }

private:
  SmallVector<RematValueSlot, 4> valueSlots;
  wave::WaveAMDPressureReliefCost cost;
  IntervalGroup *group = nullptr;
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

  void collectPlanTempIntervals(
      const wave::WaveAMDPressureReliefPlan &plan,
      SmallVectorImpl<wave::WaveAMDPressureReliefTempInterval> &intervals)
      const override {
    const RematPlan &remat = static_cast<const RematPlan &>(plan);
    for (const RematValueSlot &slot : remat.getValueSlots()) {
      SmallVector<OpOperand *> uses;
      if (!hasSimpleUses(slot.value, uses))
        return;
      llvm::stable_sort(uses, [&](OpOperand *lhs, OpOperand *rhs) {
        return inventory.positions.lookup(lhs->getOwner()) <
               inventory.positions.lookup(rhs->getOwner());
      });
      for (OpOperand *use : uses) {
        DenseSet<Value> materialized;
        collectTreeTempIntervalsAt(slot.value, use->getOwner(), materialized,
                                   intervals);
      }
    }
  }

  LogicalResult
  materializePlan(const wave::WaveAMDPressureReliefPlan &plan,
                  wave::WaveAMDPressureReliefMaterializationContext &context,
                  OpBuilder &builder) const override {
    const RematPlan &remat = static_cast<const RematPlan &>(plan);
    for (const RematValueSlot &slot : remat.getValueSlots())
      if (failed(materializeValue(slot.value, plan, context, builder)))
        return failure();
    return success();
  }

  bool isBetterCandidate(
      const wave::WaveAMDPressureReliefCandidate &lhs,
      const wave::WaveAMDPressureReliefCandidate &rhs) const override {
    if (lhs.isLegal() != rhs.isLegal())
      return lhs.isLegal();
    const RematCandidate &lhsRemat = static_cast<const RematCandidate &>(lhs);
    const RematCandidate &rhsRemat = static_cast<const RematCandidate &>(rhs);
    if (wave::isBetterWaveAMDPressureReliefCandidate(lhs, rhs))
      return true;
    if (wave::isBetterWaveAMDPressureReliefCandidate(rhs, lhs))
      return false;
    if (lhsRemat.getGroup()->intervals.front()->end !=
        rhsRemat.getGroup()->intervals.front()->end)
      return lhsRemat.getGroup()->intervals.front()->end >
             rhsRemat.getGroup()->intervals.front()->end;
    return false;
  }

private:
  bool isCombinedPressure() const {
    return pressureFailure && pressureFailure->combinedVGPRAGPR;
  }

  bool hasSimpleUses(Value value, SmallVectorImpl<OpOperand *> &uses) const {
    Operation *def = value.getDefiningOp();
    if (!def || isMemoryIssuerOp(def) || def->getNumResults() == 0)
      return false;
    for (OpOperand &use : value.getUses()) {
      Operation *user = use.getOwner();
      if (isRegAllocTempOp(user))
        continue;
      if (!useIsDominatedByDef(def, user))
        return false;
      uses.push_back(&use);
    }
    return !uses.empty();
  }

  bool isTrackedRegValue(Value value) const {
    auto type = dyn_cast<waveamdmachine::RegType>(value.getType());
    return type && isTrackedRegClass(type.getRegClass());
  }

  bool isFixedRegValue(Value value, bool materializing = false) const {
    auto type = dyn_cast<waveamdmachine::RegType>(value.getType());
    if (!type || type.getIndex() < 0)
      return false;
    return !materializing || isAuthoredFixedResult(value);
  }

  bool isValueLiveAt(Value value, unsigned position,
                     bool materializing = false) const {
    if (isFixedRegValue(value, materializing))
      return true;
    Interval *interval = inventory.intervalFor.lookup(value);
    return interval && isLiveAt(interval, position);
  }

  Operation *getDominatingCheapDef(Value value, Operation *user,
                                   bool materializing = false) const {
    Operation *def = value.getDefiningOp();
    if (!def || def->getNumResults() == 0)
      return nullptr;
    if (isFixedRegValue(value, materializing))
      return nullptr;
    if (!useIsDominatedByDef(def, user))
      return nullptr;
    if (isRegAllocTempOp(def) || isMemoryIssuerOp(def))
      return nullptr;
    return isCheapVGPRPressureReliefExpr(def) ? def : nullptr;
  }

  bool leafLiveAtConsumer(Value value, Operation *consumer,
                          bool materializing = false) const {
    if (!isTrackedRegValue(value))
      return true;
    return isValueLiveAt(value, inventory.positions.lookup(consumer),
                         materializing);
  }

  bool canRematerializeOperandsAt(Operation *def, Operation *user,
                                  DenseSet<Value> &visiting,
                                  bool materializing = false) const {
    for (Value operand : def->getOperands()) {
      if (canRematerializeTreeAt(operand, user, visiting, materializing))
        continue;
      if (!leafLiveAtConsumer(operand, user, materializing))
        return false;
    }
    return true;
  }

  bool canRematerializeTreeAt(Value value, Operation *user,
                              DenseSet<Value> &visiting,
                              bool materializing = false) const {
    Operation *def = getDominatingCheapDef(value, user, materializing);
    if (!def)
      return false;
    if (!visiting.insert(value).second)
      return false;
    bool canRemat =
        canRematerializeOperandsAt(def, user, visiting, materializing);
    visiting.erase(value);
    return canRemat;
  }

  bool canRematerializeTreeAt(Value value, Operation *user,
                              bool materializing = false) const {
    DenseSet<Value> visiting;
    return canRematerializeTreeAt(value, user, visiting, materializing);
  }

  bool canRematerializeAtUses(Value value, ArrayRef<OpOperand *> uses) const {
    for (OpOperand *use : uses)
      if (!canRematerializeTreeAt(value, use->getOwner()))
        return false;
    return true;
  }

  void collectTreeTempIntervalsAt(
      Value value, Operation *user, DenseSet<Value> &materialized,
      SmallVectorImpl<wave::WaveAMDPressureReliefTempInterval> &intervals)
      const {
    if (!materialized.insert(value).second)
      return;
    Operation *def = getDominatingCheapDef(value, user);
    if (!def)
      return;
    for (Value operand : def->getOperands())
      if (canRematerializeTreeAt(operand, user))
        collectTreeTempIntervalsAt(operand, user, materialized, intervals);
    unsigned position = inventory.positions.lookup(user);
    for (Value result : def->getResults()) {
      auto type = dyn_cast<waveamdmachine::RegType>(result.getType());
      if (!type || !isTrackedRegClass(type.getRegClass()))
        continue;
      wave::WaveAMDPressureReliefTempInterval temp;
      temp.regClass = type.getRegClass();
      temp.start = position;
      temp.end = position;
      temp.width = static_cast<unsigned>(type.getWidth());
      intervals.push_back(temp);
    }
  }

  unsigned getRematOpCountAt(Value value, Operation *user,
                             DenseSet<Value> &materialized) const {
    if (!materialized.insert(value).second)
      return 0;
    Operation *def = value.getDefiningOp();
    assert(def && "remat candidate must have defining op");
    unsigned count = 1;
    for (Value operand : def->getOperands()) {
      if (canRematerializeTreeAt(operand, user))
        count += getRematOpCountAt(operand, user, materialized);
      else if (leafLiveAtConsumer(operand, user))
        continue;
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

  wave::WaveAMDPressureReliefCost
  getRematCost(Value value, ArrayRef<OpOperand *> uses) const {
    wave::WaveAMDPressureReliefCost cost;
    if (!isMemorySpillSuppressedVGPRExpr(value.getDefiningOp()))
      cost.instabilityPenalty = kFallbackRootPenalty;
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
    if (isRegAllocTempOp(def) || !isCheapVGPRPressureReliefRootExpr(def))
      return false;
    return valueCoversWholeGroup(group, value);
  }

  FailureOr<RematValueSlot> getGroupValueSlot(IntervalGroup *group,
                                              Value value) const {
    if (!isCandidateRoot(group, value))
      return failure();
    SmallVector<OpOperand *> uses;
    if (!hasSimpleUses(value, uses))
      return failure();
    if (!canRematerializeAtUses(value, uses))
      return failure();
    return RematValueSlot{value, getRematCost(value, uses),
                          static_cast<unsigned>(uses.size())};
  }

  void collect(IntervalGroup *group,
               wave::WaveAMDPressureReliefCandidateList &candidates) const {
    if (!isRematCandidateGroup(group, position))
      return;
    unsigned reliefDwords = getLiveLaneCount(group);
    if (reliefDwords == 0)
      return;
    SmallVector<RematValueSlot, 4> valueSlots;
    for (Value value : getGroupValues(group, inventory)) {
      FailureOr<RematValueSlot> slot = getGroupValueSlot(group, value);
      if (failed(slot))
        return;
      valueSlots.push_back(*slot);
    }
    if (valueSlots.empty())
      return;
    candidates.push_back(std::make_unique<RematCandidate>(
        group, valueSlots, reliefDwords, getMemorySpillTotalCost(valueSlots)));
  }

  LogicalResult
  mapRematOperands(Operation *def, Operation *user,
                   const wave::WaveAMDPressureReliefPlan &plan,
                   wave::WaveAMDPressureReliefMaterializationContext &context,
                   OpBuilder &builder, DenseMap<Value, Value> &cache,
                   IRMapping &mapper) const {
    for (Value operand : def->getOperands()) {
      Value replacement = operand;
      if (canRematerializeTreeAt(operand, user, /*materializing=*/true)) {
        FailureOr<Value> rematOperand =
            materializeTreeAt(operand, user, plan, context, builder, cache);
        if (failed(rematOperand))
          return failure();
        replacement = *rematOperand;
      }
      mapper.map(operand, replacement);
    }
    return success();
  }

  LogicalResult assignRematCloneResultTypes(
      Operation *def, Operation *clone,
      const wave::WaveAMDPressureReliefPlan &plan,
      wave::WaveAMDPressureReliefMaterializationContext &context,
      Operation *user) const {
    for (auto [originalResult, clonedResult] :
         llvm::zip(def->getResults(), clone->getResults())) {
      auto type = dyn_cast<waveamdmachine::RegType>(originalResult.getType());
      if (!type || !isTrackedRegClass(type.getRegClass()))
        continue;
      FailureOr<waveamdmachine::RegType> assignedType =
          consumePressureReliefTempRegType(plan, context, type.getRegClass(),
                                           type.getWidth(), user);
      if (failed(assignedType))
        return failure();
      clonedResult.setType(*assignedType);
    }
    return success();
  }

  Value cacheRematCloneResults(Value value, Operation *def, Operation *clone,
                               DenseMap<Value, Value> &cache) const {
    OpResult original = cast<OpResult>(value);
    for (OpResult result : def->getOpResults())
      cache[result] = clone->getResult(result.getResultNumber());
    Value replacement = clone->getResult(original.getResultNumber());
    cache[value] = replacement;
    return replacement;
  }

  FailureOr<Value>
  materializeTreeAt(Value value, Operation *user,
                    const wave::WaveAMDPressureReliefPlan &plan,
                    wave::WaveAMDPressureReliefMaterializationContext &context,
                    OpBuilder &builder, DenseMap<Value, Value> &cache) const {
    if (Value cached = cache.lookup(value))
      return cached;
    Operation *def = getDominatingCheapDef(value, user, /*materializing=*/true);
    if (!def)
      return mlir::emitError(value.getLoc())
             << "waveamd-reg-alloc cannot rematerialize value tree";

    IRMapping mapper;
    if (failed(
            mapRematOperands(def, user, plan, context, builder, cache, mapper)))
      return failure();

    builder.setInsertionPoint(user);
    Operation *clone = builder.clone(*def, mapper);
    clone->setAttr(kRegAllocTempAttr, builder.getUnitAttr());
    if (failed(assignRematCloneResultTypes(def, clone, plan, context, user)))
      return failure();
    return cacheRematCloneResults(value, def, clone, cache);
  }

  LogicalResult
  materializeValue(Value value, const wave::WaveAMDPressureReliefPlan &plan,
                   wave::WaveAMDPressureReliefMaterializationContext &context,
                   OpBuilder &builder) const {
    Operation *def = value.getDefiningOp();
    if (!def || def->getNumResults() == 0)
      return mlir::emitError(value.getLoc())
             << "waveamd-reg-alloc cannot rematerialize value";
    SmallVector<OpOperand *> uses;
    if (!hasSimpleUses(value, uses))
      return mlir::emitError(value.getLoc())
             << "waveamd-reg-alloc cannot rematerialize value uses";
    llvm::stable_sort(uses, [&](OpOperand *lhs, OpOperand *rhs) {
      return inventory.positions.lookup(lhs->getOwner()) <
             inventory.positions.lookup(rhs->getOwner());
    });

    DenseMap<Operation *, DenseMap<Value, Value>> rematForUser;
    for (OpOperand *use : uses) {
      if (use->get() != value)
        continue;
      Operation *user = use->getOwner();
      FailureOr<Value> replacement = materializeTreeAt(
          value, user, plan, context, builder, rematForUser[user]);
      if (failed(replacement))
        return failure();
      use->set(*replacement);
    }
    eraseDeadRematTree(def);
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
