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
static bool isAuthoredFixedResult(Value value) {
  OpResult result = dyn_cast<OpResult>(value);
  if (!result)
    return false;
  Operation *op = result.getOwner();
  return isa<waveamdmachine::KernargPreloadOp, waveamdmachine::SWorkgroupIdXOp,
             waveamdmachine::SWorkgroupIdYOp, waveamdmachine::SWorkgroupIdZOp,
             waveamdmachine::VWorkitemIdXOp>(op);
}

static bool isLiveAt(Interval *interval, unsigned position) {
  return !interval->values.empty() && interval->start <= position &&
         position <= interval->end;
}

static bool isRematerializablePlannedTempGroup(IntervalGroup *group,
                                               unsigned position) {
  if (!group || group->plannedPressureRelief || group->reserved ||
      isFixedRegisterGroup(group))
    return false;
  if (group->storageClass != waveamdmachine::RegClass::VGPR ||
      group->preferredClass != waveamdmachine::RegClass::VGPR)
    return false;
  return llvm::any_of(group->intervals, [&](Interval *lane) {
    return lane->rematerializableTemp && !lane->values.empty() &&
           lane->start <= position && position <= lane->end;
  });
}

static bool isRematCandidateGroup(IntervalGroup *group, unsigned position) {
  if (isMemorySpillVGPRGroup(group) && hasLiveMemorySpillLane(group, position))
    return true;
  return isRematerializablePlannedTempGroup(group, position);
}

static bool isTrackedRegClass(waveamdmachine::RegClass regClass) {
  return regClass == waveamdmachine::RegClass::SGPR ||
         regClass == waveamdmachine::RegClass::VGPR ||
         regClass == waveamdmachine::RegClass::AGPR;
}

static int64_t
getPressureDeltaForClass(wave::WaveAMDPressureReliefEffect effect,
                         waveamdmachine::RegClass regClass) {
  if (regClass == waveamdmachine::RegClass::SGPR)
    return effect.sgprLiveDelta;
  if (regClass == waveamdmachine::RegClass::VGPR)
    return effect.vgprLiveDelta;
  if (regClass == waveamdmachine::RegClass::AGPR)
    return effect.agprLiveDelta;
  return 0;
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

static bool allResultsDead(Operation *op) {
  return llvm::all_of(op->getResults(),
                      [](Value result) { return result.use_empty(); });
}

static bool isDeadRematOp(Operation *op) {
  return op && op->getNumResults() != 0 && allResultsDead(op) &&
         !isRegAllocTempOp(op) && !isMemoryIssuerOp(op) &&
         isCheapVGPRPressureReliefExpr(op);
}

static void eraseDeadRematTrees(ArrayRef<Operation *> roots) {
  SmallVector<Operation *> worklist(roots);
  DenseSet<Operation *> erased;
  while (!worklist.empty()) {
    Operation *op = worklist.pop_back_val();
    if (!op || erased.contains(op) || !isDeadRematOp(op))
      continue;
    SmallVector<Value> operands(op->getOperands());
    erased.insert(op);
    op->erase();
    for (Value operand : operands)
      if (Operation *def = operand.getDefiningOp())
        worklist.push_back(def);
  }
}

struct RematValueSlot {
  Value value;
  SmallVector<OpOperand *, 4> postCutUses;
  SmallVector<Value, 4> originalLeaves;
  wave::WaveAMDPressureReliefCost cost;
  Operation *rebuildOp = nullptr;
  unsigned rebuildPosition = 0;
  unsigned endPosition = 0;
  unsigned useCount = 0;
  unsigned generatedUseCount = 0;
};

struct RematPostCutUse {
  OpOperand *operand = nullptr;
  Operation *anchor = nullptr;
  unsigned position = 0;
};

struct RematPostCutUseSet {
  SmallVector<OpOperand *, 4> operands;
  SmallVector<Operation *, 4> generatedUsers;
  Operation *rebuildOp = nullptr;
  unsigned rebuildPosition = 0;

  bool empty() const { return operands.empty() && generatedUsers.empty(); }
  unsigned size() const { return operands.size() + generatedUsers.size(); }
};

struct RematLeafExtension {
  Value value;
  unsigned endPosition = 0;
};

struct RematPlannedType {
  Value value;
  waveamdmachine::RegType type;
};

struct RematRejectDiagnostic {
  std::string reason;
  std::string rootOp;
  int64_t defPosition = -1;
  int64_t failurePosition = -1;
  int64_t rebuildPosition = -1;
  int64_t firstUsePosition = -1;
  int64_t reliefDwords = 0;
  int64_t addedSGPRPressure = 0;
  int64_t addedVGPRPressure = 0;
  int64_t addedAGPRPressure = 0;
  bool crossesLoopUnused = false;
};

struct MaterializedRematReplacement {
  const wave::WaveAMDPressureReliefPlan *plan = nullptr;
  Value original;
  Value replacement;
  unsigned startPosition = 0;
  unsigned endPosition = 0;
};

class RematPlan final : public wave::WaveAMDPressureReliefPlan {
public:
  RematPlan(IntervalGroup *group, ArrayRef<RematValueSlot> valueSlots,
            ArrayRef<Value> plannedValues,
            ArrayRef<RematPlannedType> plannedTypes,
            ArrayRef<RematLeafExtension> leafExtensions, unsigned position,
            unsigned reliefDwords)
      : valueSlots(valueSlots), plannedValues(plannedValues),
        plannedTypes(plannedTypes), leafExtensions(leafExtensions),
        group(group), position(position), reliefDwords(reliefDwords) {}

  wave::WaveAMDPressureReliefProviderKind getProviderKind() const override {
    return wave::WaveAMDPressureReliefProviderKind::Rematerialize;
  }

  StringRef getProviderName() const override { return "remat"; }
  unsigned getReliefDwords() const override { return reliefDwords; }
  void
  collectGeneratedUses(Value value,
                       SmallVectorImpl<wave::WaveAMDPressureReliefGeneratedUse>
                           &uses) const override {
    for (const RematValueSlot &slot : valueSlots)
      for (Value leaf : slot.originalLeaves)
        if (leaf == value)
          uses.push_back({slot.rebuildOp, slot.rebuildPosition});
  }

  IntervalGroup *getGroup() const { return group; }
  unsigned getUseCount() const {
    return getMemorySpillTotalUseCount(valueSlots);
  }
  ArrayRef<RematValueSlot> getValueSlots() const { return valueSlots; }
  ArrayRef<Value> getPlannedValues() const { return plannedValues; }
  ArrayRef<RematPlannedType> getPlannedTypes() const { return plannedTypes; }
  ArrayRef<RematLeafExtension> getLeafExtensions() const {
    return leafExtensions;
  }
  unsigned getPosition() const { return position; }

private:
  SmallVector<RematValueSlot, 4> valueSlots;
  SmallVector<Value, 8> plannedValues;
  SmallVector<RematPlannedType, 8> plannedTypes;
  SmallVector<RematLeafExtension, 8> leafExtensions;
  IntervalGroup *group = nullptr;
  unsigned position = 0;
  unsigned reliefDwords = 0;
};

class RematCandidate final : public wave::WaveAMDPressureReliefCandidate {
public:
  RematCandidate(IntervalGroup *group, ArrayRef<RematValueSlot> valueSlots,
                 ArrayRef<Value> plannedValues,
                 ArrayRef<RematPlannedType> plannedTypes,
                 ArrayRef<RematLeafExtension> leafExtensions,
                 wave::WaveAMDPressureReliefEffect leafPressureEffect,
                 unsigned position, unsigned reliefDwords,
                 wave::WaveAMDPressureReliefCost cost)
      : valueSlots(valueSlots), plannedValues(plannedValues),
        plannedTypes(plannedTypes), leafExtensions(leafExtensions),
        leafPressureEffect(leafPressureEffect), cost(cost), group(group),
        position(position), reliefDwords(reliefDwords) {}

  StringRef getProviderName() const override { return "remat"; }
  wave::WaveAMDPressureReliefCost getCost() const override { return cost; }
  unsigned getReliefDwords() const override { return reliefDwords; }

  IntervalGroup *getGroup() const { return group; }
  unsigned getUseCount() const {
    return getMemorySpillTotalUseCount(valueSlots);
  }
  ArrayRef<RematValueSlot> getValueSlots() const { return valueSlots; }
  std::unique_ptr<wave::WaveAMDPressureReliefPlan> getPlan() const {
    return std::make_unique<RematPlan>(group, valueSlots, plannedValues,
                                       plannedTypes, leafExtensions, position,
                                       reliefDwords);
  }

  wave::WaveAMDPressureReliefEffect
  getPressureEffect(const PressureFailure &failure) const override {
    return wave::combineWaveAMDPressureReliefEffects(
        getMemorySpillPressureEffect(group, reliefDwords, failure),
        leafPressureEffect);
  }

protected:
  void printExtra(llvm::raw_ostream &os) const override {
    os << ", uses=" << getUseCount();
    os << ", generated_uses=" << getGeneratedUseCount();
    os << ", rebuild_pos=" << getFirstRebuildPosition();
    os << ", added_pressure={sgpr=" << leafPressureEffect.sgprLiveDelta
       << ",vgpr=" << leafPressureEffect.vgprLiveDelta
       << ",agpr=" << leafPressureEffect.agprLiveDelta << "}";
  }

  void setExtraDiagnosticAttrs(Builder &builder,
                               NamedAttrList &attrs) const override {
    attrs.set("pressure_relief", builder.getI64IntegerAttr(reliefDwords));
    attrs.set("uses", builder.getI64IntegerAttr(getUseCount()));
    attrs.set("generated_uses",
              builder.getI64IntegerAttr(getGeneratedUseCount()));
    attrs.set("rebuild_position",
              builder.getI64IntegerAttr(getFirstRebuildPosition()));
    attrs.set("added_sgpr_pressure",
              builder.getI64IntegerAttr(leafPressureEffect.sgprLiveDelta));
    attrs.set("added_vgpr_pressure",
              builder.getI64IntegerAttr(leafPressureEffect.vgprLiveDelta));
    attrs.set("added_agpr_pressure",
              builder.getI64IntegerAttr(leafPressureEffect.agprLiveDelta));
  }

private:
  unsigned getFirstRebuildPosition() const {
    unsigned first = 0;
    for (const RematValueSlot &slot : valueSlots)
      first =
          first ? std::min(first, slot.rebuildPosition) : slot.rebuildPosition;
    return first;
  }

  unsigned getGeneratedUseCount() const {
    unsigned count = 0;
    for (const RematValueSlot &slot : valueSlots)
      count += slot.generatedUseCount;
    return count;
  }

  SmallVector<RematValueSlot, 4> valueSlots;
  SmallVector<Value, 8> plannedValues;
  SmallVector<RematPlannedType, 8> plannedTypes;
  SmallVector<RematLeafExtension, 8> leafExtensions;
  wave::WaveAMDPressureReliefEffect leafPressureEffect;
  wave::WaveAMDPressureReliefCost cost;
  IntervalGroup *group = nullptr;
  unsigned position = 0;
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
    (void)query;
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
    for (const RematLeafExtension &extension : remat.getLeafExtensions())
      applyLeafExtension(extension);
    cutGroupAtPosition(remat.getGroup(), remat.getPosition());
    remat.getGroup()->assignedBase.reset();
  }

  void collectPlanTempIntervals(
      const wave::WaveAMDPressureReliefPlan &plan,
      SmallVectorImpl<wave::WaveAMDPressureReliefTempInterval> &intervals)
      const override {
    const RematPlan &remat = static_cast<const RematPlan &>(plan);
    for (const RematValueSlot &slot : remat.getValueSlots()) {
      DenseSet<Value> materialized;
      collectTreeTempIntervalsAt(slot.value, slot.rebuildOp, slot.endPosition,
                                 remat.getPlannedTypes(), materialized,
                                 intervals);
    }
  }

  LogicalResult
  materializePlan(const wave::WaveAMDPressureReliefPlan &plan,
                  wave::WaveAMDPressureReliefMaterializationContext &context,
                  OpBuilder &builder) const override {
    const RematPlan &remat = static_cast<const RematPlan &>(plan);
    llvm::SmallDenseSet<Value, 8> plannedValues = getPlannedValues(remat);
    llvm::SmallDenseSet<Value, 8> leafValues = getLeafValues(remat);
    llvm::SmallDenseSet<Operation *, 8> protectedTemplateOps =
        getProtectedTemplateOps(remat);
    SmallVector<Operation *> cleanupRoots;
    for (Value value : remat.getPlannedValues())
      if (Operation *def = value.getDefiningOp())
        cleanupRoots.push_back(def);
    SmallVector<MaterializedRematReplacement, 8> replacements;
    for (const RematValueSlot &slot : remat.getValueSlots())
      if (failed(materializeValue(slot, plan, context, builder, plannedValues,
                                  leafValues, replacements,
                                  protectedTemplateOps)))
        return failure();
    eraseDeadRematTrees(cleanupRoots);
    return success();
  }

  LogicalResult
  materializePlans(ArrayRef<const wave::WaveAMDPressureReliefPlan *> plans,
                   wave::WaveAMDPressureReliefMaterializationContext &context,
                   OpBuilder &builder) const override {
    SmallVector<Operation *> cleanupRoots;
    llvm::SmallDenseSet<Operation *, 8> protectedTemplateOps =
        getProtectedTemplateOps(plans);
    for (const wave::WaveAMDPressureReliefPlan *plan : plans) {
      const RematPlan &remat = static_cast<const RematPlan &>(*plan);
      for (Value value : remat.getPlannedValues())
        if (Operation *def = value.getDefiningOp())
          cleanupRoots.push_back(def);
    }
    SmallVector<MaterializedRematReplacement, 8> replacements;
    for (const wave::WaveAMDPressureReliefPlan *plan : llvm::reverse(plans)) {
      const RematPlan &remat = static_cast<const RematPlan &>(*plan);
      llvm::SmallDenseSet<Value, 8> plannedValues = getPlannedValues(remat);
      llvm::SmallDenseSet<Value, 8> leafValues = getLeafValues(remat);
      for (const RematValueSlot &slot : remat.getValueSlots())
        if (failed(materializeValue(slot, *plan, context, builder,
                                    plannedValues, leafValues, replacements,
                                    protectedTemplateOps)))
          return failure();
    }
    eraseDeadRematTrees(cleanupRoots);
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

  void collectFailureDiagnostics(
      SmallVectorImpl<wave::WaveAMDPressureReliefProviderDiagnostic>
          &diagnostics) const override {
    if (!rejectDiagnostic)
      return;
    wave::WaveAMDPressureReliefProviderDiagnostic diagnostic;
    diagnostic.message =
        "remat reject: reason=" + rejectDiagnostic->reason +
        ", root=" + rejectDiagnostic->rootOp +
        ", def=" + std::to_string(rejectDiagnostic->defPosition) +
        ", failure=" + std::to_string(rejectDiagnostic->failurePosition) +
        ", rebuild=" + std::to_string(rejectDiagnostic->rebuildPosition) +
        ", first_use=" + std::to_string(rejectDiagnostic->firstUsePosition) +
        ", relief=" + std::to_string(rejectDiagnostic->reliefDwords) +
        ", added_pressure=" +
        std::to_string(rejectDiagnostic->addedSGPRPressure) + "/" +
        std::to_string(rejectDiagnostic->addedVGPRPressure) + "/" +
        std::to_string(rejectDiagnostic->addedAGPRPressure) +
        ", crosses_loop_unused=" +
        (rejectDiagnostic->crossesLoopUnused ? "1" : "0");
    diagnostic.stringMetrics.push_back(
        {"remat_reject_reason", rejectDiagnostic->reason});
    diagnostic.stringMetrics.push_back(
        {"remat_root_op", rejectDiagnostic->rootOp});
    diagnostic.integerMetrics.push_back(
        {"remat_def_position", rejectDiagnostic->defPosition});
    diagnostic.integerMetrics.push_back(
        {"remat_failure_position", rejectDiagnostic->failurePosition});
    diagnostic.integerMetrics.push_back(
        {"remat_rebuild_position", rejectDiagnostic->rebuildPosition});
    diagnostic.integerMetrics.push_back(
        {"remat_first_post_cut_use", rejectDiagnostic->firstUsePosition});
    diagnostic.integerMetrics.push_back(
        {"remat_relief_dwords", rejectDiagnostic->reliefDwords});
    diagnostic.integerMetrics.push_back(
        {"remat_added_sgpr_pressure", rejectDiagnostic->addedSGPRPressure});
    diagnostic.integerMetrics.push_back(
        {"remat_added_vgpr_pressure", rejectDiagnostic->addedVGPRPressure});
    diagnostic.integerMetrics.push_back(
        {"remat_added_agpr_pressure", rejectDiagnostic->addedAGPRPressure});
    diagnostic.integerMetrics.push_back(
        {"remat_crosses_loop_unused",
         rejectDiagnostic->crossesLoopUnused ? 1 : 0});
    diagnostics.push_back(std::move(diagnostic));
  }

  void notifyAttemptStarted() const override { rejectDiagnostic.reset(); }

private:
  enum class RematOperandPlan { UseOriginal, Rematerialize, Invalid };

  llvm::SmallDenseSet<Value, 8> getPlannedValues(const RematPlan &remat) const {
    llvm::SmallDenseSet<Value, 8> plannedValues;
    for (Value value : remat.getPlannedValues())
      plannedValues.insert(value);
    return plannedValues;
  }

  llvm::SmallDenseSet<Value, 8> getLeafValues(const RematPlan &remat) const {
    llvm::SmallDenseSet<Value, 8> leafValues;
    for (RematLeafExtension extension : remat.getLeafExtensions())
      leafValues.insert(extension.value);
    return leafValues;
  }

  llvm::SmallDenseSet<Value, 8> getPlannedValues(ArrayRef<Value> values) const {
    llvm::SmallDenseSet<Value, 8> plannedValues;
    for (Value value : values)
      plannedValues.insert(value);
    return plannedValues;
  }

  llvm::SmallDenseSet<Operation *, 8>
  getProtectedTemplateOps(ArrayRef<Value> plannedValues) const {
    llvm::SmallDenseSet<Operation *, 8> protectedOps;
    for (Value value : plannedValues) {
      Operation *def = value.getDefiningOp();
      if (def && isCheapVGPRPressureReliefExpr(def))
        protectedOps.insert(def);
    }
    return protectedOps;
  }

  llvm::SmallDenseSet<Operation *, 8>
  getProtectedTemplateOps(const RematPlan &remat) const {
    return getProtectedTemplateOps(remat.getPlannedValues());
  }

  llvm::SmallDenseSet<Operation *, 8> getProtectedTemplateOps(
      ArrayRef<const wave::WaveAMDPressureReliefPlan *> plans) const {
    SmallVector<Value, 16> plannedValues;
    for (const wave::WaveAMDPressureReliefPlan *plan : plans) {
      const RematPlan &remat = static_cast<const RematPlan &>(*plan);
      llvm::append_range(plannedValues, remat.getPlannedValues());
    }
    return getProtectedTemplateOps(plannedValues);
  }

  std::optional<waveamdmachine::RegType>
  getPlannedType(Value value, ArrayRef<RematPlannedType> plannedTypes) const {
    for (const RematPlannedType &planned : plannedTypes)
      if (planned.value == value)
        return planned.type;
    return std::nullopt;
  }

  bool isInternalPlannedUse(
      OpOperand *use,
      const llvm::SmallDenseSet<Value, 8> &plannedValues) const {
    if (isInternalTupleFromElementsUse(use, plannedValues))
      return true;
    Operation *user = use->getOwner();
    if (!isCheapVGPRPressureReliefExpr(user))
      return false;
    return llvm::any_of(user->getResults(), [&](Value result) {
      return plannedValues.contains(result);
    });
  }

  bool collectExternalUses(Value value,
                           const llvm::SmallDenseSet<Value, 8> &plannedValues,
                           SmallVectorImpl<OpOperand *> &uses) const {
    Operation *def = value.getDefiningOp();
    if (!def || isMemoryIssuerOp(def) || def->getNumResults() == 0)
      return false;
    for (OpOperand &use : value.getUses()) {
      Operation *user = use.getOwner();
      if (isRegAllocGeneratedOp(user))
        continue;
      if (isInternalPlannedUse(&use, plannedValues))
        continue;
      if (!useIsDominatedByDef(def, user))
        return false;
      if (!getMemorySpillOpPosition(user, inventory))
        return false;
      uses.push_back(&use);
    }
    llvm::stable_sort(uses, [&](OpOperand *lhs, OpOperand *rhs) {
      return inventory.positions.lookup(lhs->getOwner()) <
             inventory.positions.lookup(rhs->getOwner());
    });
    return true;
  }

  bool isTrackedRegValue(Value value) const {
    auto type = dyn_cast<waveamdmachine::RegType>(value.getType());
    return type && isTrackedRegClass(type.getRegClass());
  }

  bool isAnchoredFixedSourceValue(Value value) const {
    auto type = dyn_cast<waveamdmachine::RegType>(value.getType());
    if (!type || type.getIndex() < 0)
      return false;
    return isAuthoredFixedResult(value);
  }

  bool isValueLiveAt(Value value, unsigned position) const {
    if (isAnchoredFixedSourceValue(value))
      return true;
    Interval *interval = inventory.intervalFor.lookup(value);
    return interval && isLiveAt(interval, position);
  }

  Operation *getDominatingCheapDef(Value value, Operation *user,
                                   bool materializing = false) const {
    Operation *def = value.getDefiningOp();
    if (!def || def->getNumResults() == 0)
      return nullptr;
    if (isAnchoredFixedSourceValue(value))
      return nullptr;
    if (!useIsDominatedByDef(def, user))
      return nullptr;
    if ((!materializing && isRegAllocTempOp(def)) || isMemoryIssuerOp(def))
      return nullptr;
    return isCheapVGPRPressureReliefExpr(def) ? def : nullptr;
  }

  bool isValueAvailableAt(Value value, Operation *user) const {
    if (Operation *def = value.getDefiningOp())
      return useIsDominatedByDef(def, user);
    auto arg = dyn_cast<BlockArgument>(value);
    if (!arg)
      return false;
    Operation *parent = arg.getOwner()->getParentOp();
    if (isa_and_nonnull<func::FuncOp>(parent))
      return true;
    return getAncestorInBlock(user, arg.getOwner()) != nullptr;
  }

  std::optional<unsigned> getLaneIndex(IntervalGroup *group,
                                       Interval *interval) const {
    for (auto [index, lane] : llvm::enumerate(group->intervals))
      if (lane == interval)
        return index;
    return std::nullopt;
  }

  void addLeafExtension(Value value, unsigned endPosition,
                        SmallVectorImpl<RematLeafExtension> &extensions) const {
    for (RematLeafExtension &extension : extensions) {
      if (extension.value != value)
        continue;
      extension.endPosition = std::max(extension.endPosition, endPosition);
      return;
    }
    extensions.push_back({value, endPosition});
  }

  bool canUseOriginalLeafAt(Value value, Operation *consumer,
                            const llvm::SmallDenseSet<Value, 8> &plannedValues,
                            SmallVectorImpl<RematLeafExtension> &extensions,
                            bool materializing = false) const {
    if (plannedValues.contains(value))
      return false;
    if (!isValueAvailableAt(value, consumer))
      return false;
    if (!isTrackedRegValue(value))
      return true;
    auto it = inventory.positions.find(consumer);
    if (it == inventory.positions.end())
      return false;
    Interval *interval = inventory.intervalFor.lookup(value);
    if (!interval || interval->group->plannedPressureRelief)
      return false;
    unsigned consumerPosition = it->second;
    if (interval->start > consumerPosition)
      return false;
    if (!isValueLiveAt(value, consumerPosition) &&
        getDominatingCheapDef(value, consumer, materializing))
      return false;
    addLeafExtension(value, consumerPosition, extensions);
    return true;
  }

  bool
  shouldPreferRemat(Value value, Operation *user,
                    const llvm::SmallDenseSet<Value, 8> &plannedValues) const {
    if (plannedValues.contains(value))
      return true;
    if (!isTrackedRegValue(value))
      return false;
    return !isValueLiveAt(value, inventory.positions.lookup(user));
  }

  bool isUnplannedGeneratedValue(
      Value value, const llvm::SmallDenseSet<Value, 8> &plannedValues) const {
    Operation *def = value.getDefiningOp();
    return isRegAllocGeneratedOp(def) && !plannedValues.contains(value);
  }

  std::optional<unsigned>
  getCurrentPlannedTempEnd(const PlannedPressureReliefTempInterval &temp,
                           Value value) const {
    if (!temp.group)
      return std::nullopt;
    std::optional<unsigned> end;
    for (Interval *lane : temp.group->intervals) {
      if (!lane->values.contains(value))
        continue;
      if (lane->start != temp.interval.start)
        continue;
      end = end ? std::min(*end, lane->end) : lane->end;
    }
    return end;
  }

  std::optional<unsigned> getCurrentReplacementEnd(
      const MaterializedRematReplacement &replacement) const {
    bool matchedPlanTemp = false;
    std::optional<unsigned> end;
    for (const PlannedPressureReliefTempInterval &temp :
         inventory.plannedReliefTemps) {
      if (temp.plan != replacement.plan ||
          temp.interval.value != replacement.original ||
          temp.interval.start != replacement.startPosition)
        continue;
      matchedPlanTemp = true;
      std::optional<unsigned> currentEnd =
          getCurrentPlannedTempEnd(temp, replacement.original);
      if (currentEnd)
        end = end ? std::min(*end, *currentEnd) : *currentEnd;
    }
    if (matchedPlanTemp)
      return end;
    return replacement.endPosition;
  }

  Value lookupMaterializedReplacementAt(
      Value value, Operation *user,
      ArrayRef<MaterializedRematReplacement> replacements) const {
    DenseMap<Operation *, unsigned>::const_iterator it =
        inventory.positions.find(user);
    if (it == inventory.positions.end())
      return {};
    unsigned position = it->second;
    for (MaterializedRematReplacement replacement :
         llvm::reverse(replacements)) {
      std::optional<unsigned> endPosition =
          getCurrentReplacementEnd(replacement);
      if (!endPosition)
        continue;
      if (replacement.original == value &&
          replacement.startPosition <= position && position <= *endPosition)
        return replacement.replacement;
    }
    return {};
  }

  bool
  tryRematerializeOperandAt(Value value, Operation *user,
                            DenseSet<Value> &visiting,
                            const llvm::SmallDenseSet<Value, 8> &plannedValues,
                            SmallVectorImpl<RematLeafExtension> &extensions,
                            bool materializing) const {
    SmallVector<RematLeafExtension, 4> trialExtensions(extensions.begin(),
                                                       extensions.end());
    if (!canRematerializeTreeAt(value, user, visiting, plannedValues,
                                trialExtensions, materializing))
      return false;
    extensions.clear();
    extensions.append(trialExtensions);
    return true;
  }

  RematOperandPlan
  getOperandPlanAt(Value value, Operation *user, DenseSet<Value> &visiting,
                   const llvm::SmallDenseSet<Value, 8> &plannedValues,
                   SmallVectorImpl<RematLeafExtension> &extensions,
                   bool materializing = false) const {
    bool unplannedGenerated = isUnplannedGeneratedValue(value, plannedValues);
    if (!unplannedGenerated) {
      bool prefer = shouldPreferRemat(value, user, plannedValues);
      if (prefer &&
          tryRematerializeOperandAt(value, user, visiting, plannedValues,
                                    extensions, materializing))
        return RematOperandPlan::Rematerialize;
      if (getDominatingCheapDef(value, user, materializing) &&
          tryRematerializeOperandAt(value, user, visiting, plannedValues,
                                    extensions, materializing))
        return RematOperandPlan::Rematerialize;
    }
    if (canUseOriginalLeafAt(value, user, plannedValues, extensions,
                             materializing))
      return RematOperandPlan::UseOriginal;
    if (!unplannedGenerated &&
        tryRematerializeOperandAt(value, user, visiting, plannedValues,
                                  extensions, materializing))
      return RematOperandPlan::Rematerialize;
    return RematOperandPlan::Invalid;
  }

  RematOperandPlan
  getOperandPlanAt(Value value, Operation *user,
                   const llvm::SmallDenseSet<Value, 8> &plannedValues,
                   SmallVectorImpl<RematLeafExtension> &extensions,
                   bool materializing = false) const {
    DenseSet<Value> visiting;
    return getOperandPlanAt(value, user, visiting, plannedValues, extensions,
                            materializing);
  }

  bool
  canRematerializeOperandsAt(Operation *def, Operation *user,
                             DenseSet<Value> &visiting,
                             const llvm::SmallDenseSet<Value, 8> &plannedValues,
                             SmallVectorImpl<RematLeafExtension> &extensions,
                             bool materializing = false) const {
    SmallVector<RematLeafExtension, 4> trialExtensions(extensions.begin(),
                                                       extensions.end());
    for (Value operand : def->getOperands()) {
      RematOperandPlan plan =
          getOperandPlanAt(operand, user, visiting, plannedValues,
                           trialExtensions, materializing);
      if (plan == RematOperandPlan::Invalid)
        return false;
    }
    extensions.clear();
    extensions.append(trialExtensions);
    return true;
  }

  bool
  canRematerializeTreeAt(Value value, Operation *user,
                         DenseSet<Value> &visiting,
                         const llvm::SmallDenseSet<Value, 8> &plannedValues,
                         SmallVectorImpl<RematLeafExtension> &extensions,
                         bool materializing = false) const {
    Operation *def = getDominatingCheapDef(value, user, materializing);
    if (!def)
      return false;
    if (!visiting.insert(value).second)
      return false;
    bool canRemat = canRematerializeOperandsAt(
        def, user, visiting, plannedValues, extensions, materializing);
    visiting.erase(value);
    return canRemat;
  }

  bool
  canRematerializeTreeAt(Value value, Operation *user,
                         const llvm::SmallDenseSet<Value, 8> &plannedValues,
                         SmallVectorImpl<RematLeafExtension> &extensions,
                         bool materializing = false) const {
    DenseSet<Value> visiting;
    return canRematerializeTreeAt(value, user, visiting, plannedValues,
                                  extensions, materializing);
  }

  LogicalResult
  collectOriginalLeavesAt(Value value, Operation *user,
                          DenseSet<Value> &visiting,
                          const llvm::SmallDenseSet<Value, 8> &plannedValues,
                          SmallVectorImpl<Value> &leaves) const {
    Operation *def = getDominatingCheapDef(value, user, /*materializing=*/true);
    if (!def)
      return failure();
    if (!visiting.insert(value).second)
      return failure();
    for (Value operand : def->getOperands()) {
      SmallVector<RematLeafExtension, 4> extensions;
      RematOperandPlan plan =
          getOperandPlanAt(operand, user, visiting, plannedValues, extensions,
                           /*materializing=*/true);
      if (plan == RematOperandPlan::Invalid) {
        visiting.erase(value);
        return failure();
      }
      if (plan == RematOperandPlan::UseOriginal) {
        leaves.push_back(operand);
        continue;
      }
      if (failed(collectOriginalLeavesAt(operand, user, visiting, plannedValues,
                                         leaves))) {
        visiting.erase(value);
        return failure();
      }
    }
    visiting.erase(value);
    return success();
  }

  LogicalResult
  collectOriginalLeavesAt(Value value, Operation *user,
                          const llvm::SmallDenseSet<Value, 8> &plannedValues,
                          SmallVectorImpl<Value> &leaves) const {
    DenseSet<Value> visiting;
    return collectOriginalLeavesAt(value, user, visiting, plannedValues,
                                   leaves);
  }

  void collectTreeTempIntervalsAt(
      Value value, Operation *user, unsigned endPosition,
      ArrayRef<RematPlannedType> plannedTypes, DenseSet<Value> &materialized,
      SmallVectorImpl<wave::WaveAMDPressureReliefTempInterval> &intervals)
      const {
    if (!materialized.insert(value).second)
      return;
    Operation *def = getDominatingCheapDef(value, user, /*materializing=*/true);
    if (!def)
      return;
    for (Value operand : def->getOperands()) {
      if (getPlannedType(operand, plannedTypes))
        collectTreeTempIntervalsAt(operand, user,
                                   inventory.positions.lookup(user),
                                   plannedTypes, materialized, intervals);
    }
    unsigned position = inventory.positions.lookup(user);
    for (Value result : def->getResults()) {
      std::optional<waveamdmachine::RegType> type =
          getPlannedType(result, plannedTypes);
      if (!type || !isTrackedRegClass(type->getRegClass()))
        continue;
      wave::WaveAMDPressureReliefTempInterval temp;
      temp.value = result;
      temp.regClass = type->getRegClass();
      temp.start = position;
      temp.end = result == value ? endPosition : position;
      temp.width = static_cast<unsigned>(type->getWidth());
      intervals.push_back(temp);
    }
  }

  void collectTreePlannedTypesAt(
      Value value, Operation *user,
      const llvm::SmallDenseSet<Value, 8> &plannedValues,
      DenseSet<Value> &materialized,
      SmallVectorImpl<RematPlannedType> &plannedTypes) const {
    if (!materialized.insert(value).second)
      return;
    Operation *def = getDominatingCheapDef(value, user, /*materializing=*/true);
    if (!def)
      return;
    for (Value operand : def->getOperands()) {
      SmallVector<RematLeafExtension, 4> extensions;
      RematOperandPlan plan =
          getOperandPlanAt(operand, user, plannedValues, extensions,
                           /*materializing=*/true);
      if (plan == RematOperandPlan::Rematerialize)
        collectTreePlannedTypesAt(operand, user, plannedValues, materialized,
                                  plannedTypes);
      else
        assert(plan != RematOperandPlan::Invalid &&
               "planned type collection requires a legal remat tree");
    }
    for (Value result : def->getResults()) {
      auto type = dyn_cast<waveamdmachine::RegType>(result.getType());
      if (type && isTrackedRegClass(type.getRegClass()))
        plannedTypes.push_back({result, type});
    }
  }

  unsigned getRematOpCountAt(Value value, Operation *user,
                             const llvm::SmallDenseSet<Value, 8> &plannedValues,
                             SmallVectorImpl<RematLeafExtension> &extensions,
                             DenseSet<Value> &materialized) const {
    if (!materialized.insert(value).second)
      return 0;
    Operation *def = getDominatingCheapDef(value, user, /*materializing=*/true);
    assert(def && "remat candidate must have defining op");
    unsigned count = 1;
    for (Value operand : def->getOperands()) {
      RematOperandPlan plan =
          getOperandPlanAt(operand, user, plannedValues, extensions,
                           /*materializing=*/true);
      if (plan == RematOperandPlan::Rematerialize)
        count += getRematOpCountAt(operand, user, plannedValues, extensions,
                                   materialized);
      else
        assert(plan != RematOperandPlan::Invalid &&
               "op count requested for illegal remat tree");
    }
    return count;
  }

  bool valueBelongsToGroup(IntervalGroup *group, Value value) const {
    Interval *first = inventory.intervalFor.lookup(value);
    if (first && first->group == group)
      return true;
    if (!isRematerializablePlannedTempGroup(group, position))
      return false;
    return llvm::any_of(group->intervals, [&](Interval *lane) {
      return lane->values.contains(value);
    });
  }

  unsigned getLiveLaneCount(IntervalGroup *group) const {
    unsigned count = 0;
    for (Interval *lane : group->intervals)
      if (isLiveAt(lane, position))
        ++count;
    return count;
  }

  int64_t getOperationPosition(Operation *op) const {
    if (!op)
      return -1;
    DenseMap<Operation *, unsigned>::const_iterator it =
        inventory.positions.find(op);
    if (it == inventory.positions.end())
      return -1;
    return it->second;
  }

  Operation *getFirstPostCutUser(ArrayRef<OpOperand *> uses) const {
    Operation *first = nullptr;
    for (OpOperand *use : uses) {
      Operation *user = use->getOwner();
      unsigned usePosition = inventory.positions.lookup(user);
      if (usePosition < position)
        continue;
      if (!first || usePosition < inventory.positions.lookup(first))
        first = user;
    }
    return first;
  }

  Operation *getFirstPostCutUser(const RematPostCutUseSet &uses) const {
    if (uses.rebuildOp)
      return uses.rebuildOp;
    return getFirstPostCutUser(uses.operands);
  }

  bool valueUsedInside(Value value, Operation *scope) const {
    for (OpOperand &use : value.getUses())
      if (scope->isAncestor(use.getOwner()))
        return true;
    return false;
  }

  Operation *getPostCutUserInDefBlock(Operation *def,
                                      Operation *postCutUser) const {
    if (!def || !postCutUser)
      return nullptr;
    Operation *userInDefBlock =
        getAncestorInBlock(postCutUser, def->getBlock());
    if (!userInDefBlock || userInDefBlock == def ||
        userInDefBlock->isBeforeInBlock(def))
      return nullptr;
    return userInDefBlock;
  }

  bool hasUnusedLoopBetween(Value value, Operation *def,
                            Operation *limit) const {
    for (Operation &op : *def->getBlock()) {
      if (&op == def)
        continue;
      if (!def->isBeforeInBlock(&op))
        continue;
      if (&op == limit)
        return false;
      auto loop = dyn_cast<waveamdmachine::UniformLoopOp>(&op);
      if (loop && !valueUsedInside(value, loop))
        return true;
    }
    return false;
  }

  bool crossesUnusedLoop(Value value, Operation *postCutUser) const {
    Operation *def = value.getDefiningOp();
    Operation *limit = getPostCutUserInDefBlock(def, postCutUser);
    return limit && hasUnusedLoopBetween(value, def, limit);
  }

  void recordReject(IntervalGroup *group, Value value, StringRef reason,
                    ArrayRef<OpOperand *> uses = {},
                    ArrayRef<RematLeafExtension> extensions = {},
                    Operation *firstPostCutUser = nullptr) const {
    if (rejectDiagnostic)
      return;
    Operation *def = value.getDefiningOp();
    if (!firstPostCutUser)
      firstPostCutUser = getFirstPostCutUser(uses);
    wave::WaveAMDPressureReliefEffect effect =
        getLeafPressureEffect(mergeLeafExtensions(extensions));
    RematRejectDiagnostic diagnostic;
    diagnostic.reason = reason.str();
    diagnostic.rootOp =
        def ? def->getName().getStringRef().str() : "block_argument";
    diagnostic.defPosition = getOperationPosition(def);
    diagnostic.failurePosition = position;
    diagnostic.rebuildPosition = getOperationPosition(firstPostCutUser);
    diagnostic.firstUsePosition = getOperationPosition(firstPostCutUser);
    diagnostic.reliefDwords = group ? getLiveLaneCount(group) : 0;
    diagnostic.addedSGPRPressure = effect.sgprLiveDelta;
    diagnostic.addedVGPRPressure = effect.vgprLiveDelta;
    diagnostic.addedAGPRPressure = effect.agprLiveDelta;
    diagnostic.crossesLoopUnused = crossesUnusedLoop(value, firstPostCutUser);
    rejectDiagnostic = std::move(diagnostic);
  }

  void recordReject(IntervalGroup *group, Value value, StringRef reason,
                    const RematPostCutUseSet &uses,
                    ArrayRef<RematLeafExtension> extensions = {}) const {
    recordReject(group, value, reason, uses.operands, extensions,
                 getFirstPostCutUser(uses));
  }

  void applyLeafExtension(RematLeafExtension extension) const {
    auto type = dyn_cast<waveamdmachine::RegType>(extension.value.getType());
    Interval *interval = inventory.intervalFor.lookup(extension.value);
    if (!type || !interval)
      return;
    std::optional<unsigned> firstLane = getLaneIndex(interval->group, interval);
    if (!firstLane)
      return;
    unsigned width = static_cast<unsigned>(type.getWidth());
    for (unsigned offset : llvm::seq<unsigned>(0, width)) {
      unsigned laneIndex = *firstLane + offset;
      if (laneIndex >= interval->group->intervals.size())
        return;
      Interval *lane = interval->group->intervals[laneIndex];
      lane->end = std::max(lane->end, extension.endPosition);
    }
  }

  void eraseIntervalValue(Value value, Interval *lane) const {
    lane->values.erase(value);
    auto it = inventory.intervalFor.find(value);
    if (it != inventory.intervalFor.end() && it->second == lane)
      inventory.intervalFor.erase(it);
  }

  void cutLaneAtPosition(Interval *lane, unsigned cutPosition) const {
    if (lane->end < cutPosition)
      return;
    if (lane->start < cutPosition) {
      lane->end = std::min(lane->end, cutPosition - 1);
      return;
    }
    SmallVector<Value> values(lane->values.begin(), lane->values.end());
    for (Value value : values)
      eraseIntervalValue(value, lane);
    lane->start = 0;
    lane->end = 0;
  }

  void cutGroupAtPosition(IntervalGroup *group, unsigned cutPosition) const {
    for (Interval *lane : group->intervals)
      cutLaneAtPosition(lane, cutPosition);
  }

  void mergeLeafExtension(SmallVectorImpl<RematLeafExtension> &extensions,
                          RematLeafExtension extension) const {
    addLeafExtension(extension.value, extension.endPosition, extensions);
  }

  SmallVector<RematLeafExtension, 8>
  mergeLeafExtensions(ArrayRef<RematLeafExtension> extensions) const {
    SmallVector<RematLeafExtension, 8> merged;
    for (RematLeafExtension extension : extensions)
      mergeLeafExtension(merged, extension);
    return merged;
  }

  bool shouldCountLeafLane(Interval *lane, RematLeafExtension extension,
                           DenseSet<Interval *> &counted) const {
    if (isLiveAt(lane, position) || lane->start > position)
      return false;
    if (extension.endPosition < position)
      return false;
    return counted.insert(lane).second;
  }

  void addLeafLanePressure(waveamdmachine::RegClass regClass,
                           wave::WaveAMDPressureReliefEffect &effect) const {
    if (regClass == waveamdmachine::RegClass::SGPR)
      ++effect.sgprLiveDelta;
    if (regClass == waveamdmachine::RegClass::VGPR)
      ++effect.vgprLiveDelta;
    if (regClass == waveamdmachine::RegClass::AGPR)
      ++effect.agprLiveDelta;
  }

  void
  addLeafExtensionPressure(RematLeafExtension extension,
                           DenseSet<Interval *> &counted,
                           wave::WaveAMDPressureReliefEffect &effect) const {
    auto type = dyn_cast<waveamdmachine::RegType>(extension.value.getType());
    Interval *interval = inventory.intervalFor.lookup(extension.value);
    if (!type || !interval)
      return;
    std::optional<unsigned> firstLane = getLaneIndex(interval->group, interval);
    if (!firstLane)
      return;
    unsigned width = static_cast<unsigned>(type.getWidth());
    for (unsigned offset : llvm::seq<unsigned>(0, width)) {
      unsigned laneIndex = *firstLane + offset;
      if (laneIndex >= interval->group->intervals.size())
        break;
      Interval *lane = interval->group->intervals[laneIndex];
      if (shouldCountLeafLane(lane, extension, counted))
        addLeafLanePressure(interval->group->storageClass, effect);
    }
  }

  wave::WaveAMDPressureReliefEffect
  getLeafPressureEffect(ArrayRef<RematLeafExtension> extensions) const {
    DenseSet<Interval *> counted;
    wave::WaveAMDPressureReliefEffect effect;
    for (RematLeafExtension extension : extensions)
      addLeafExtensionPressure(extension, counted, effect);
    return effect;
  }

  bool insertionPointDominates(Operation *anchor, Operation *user) const {
    if (anchor->getBlock() == user->getBlock())
      return inventory.positions.lookup(anchor) <=
             inventory.positions.lookup(user);
    Operation *ancestor = getAncestorInBlock(user, anchor->getBlock());
    return ancestor && anchor->isBeforeInBlock(ancestor);
  }

  void
  collectGeneratedPostCutUses(Value value,
                              SmallVectorImpl<RematPostCutUse> &uses) const {
    SmallVector<wave::WaveAMDPressureReliefGeneratedUse, 4> generatedUses;
    for (const std::unique_ptr<wave::WaveAMDPressureReliefPlan> &plan :
         inventory.plannedReliefPlans)
      plan->collectGeneratedUses(value, generatedUses);
    for (wave::WaveAMDPressureReliefGeneratedUse use : generatedUses) {
      if (!use.anchor)
        continue;
      if (!inventory.positions.count(use.anchor))
        continue;
      uses.push_back({nullptr, use.anchor, use.position});
    }
  }

  FailureOr<RematPostCutUseSet>
  getPostCutUses(Value value, ArrayRef<OpOperand *> uses) const {
    SmallVector<RematPostCutUse, 8> candidates;
    for (OpOperand *use : uses) {
      Operation *owner = use->getOwner();
      candidates.push_back({use, owner, inventory.positions.lookup(owner)});
    }
    collectGeneratedPostCutUses(value, candidates);
    llvm::stable_sort(
        candidates, [](const RematPostCutUse &lhs, const RematPostCutUse &rhs) {
          return lhs.position < rhs.position;
        });

    RematPostCutUseSet postCutUses;
    for (RematPostCutUse use : candidates) {
      if (use.position == position)
        return failure();
      if (use.position < position)
        continue;
      if (!postCutUses.rebuildOp) {
        postCutUses.rebuildOp = use.anchor;
        postCutUses.rebuildPosition = use.position;
      }
      if (!insertionPointDominates(postCutUses.rebuildOp, use.anchor))
        return failure();
      if (use.operand)
        postCutUses.operands.push_back(use.operand);
      else
        postCutUses.generatedUsers.push_back(use.anchor);
    }
    return postCutUses;
  }

  unsigned getGroupStart(IntervalGroup *group) const {
    unsigned start = std::numeric_limits<unsigned>::max();
    for (Interval *lane : group->intervals)
      if (!lane->values.empty())
        start = std::min(start, lane->start);
    return start;
  }

  bool
  repeatsExistingRematPlacement(IntervalGroup *group, Value value,
                                const RematPostCutUseSet &postCutUses) const {
    if (postCutUses.empty())
      return false;
    unsigned rebuildPosition = postCutUses.rebuildPosition;
    Interval *interval = inventory.intervalFor.lookup(value);
    if (isRematerializablePlannedTempGroup(group, position) &&
        ((interval && interval->group == group) ||
         llvm::any_of(group->intervals, [&](Interval *lane) {
           return lane->values.contains(value);
         })))
      return rebuildPosition <= getGroupStart(group) + 1;
    Operation *def = value.getDefiningOp();
    if (!isRegAllocRematTempOp(def))
      return false;
    unsigned defPosition = inventory.positions.lookup(def);
    return rebuildPosition <= defPosition + 1;
  }

  wave::WaveAMDPressureReliefCost
  getRematCost(Value value, Operation *rebuildOp,
               const llvm::SmallDenseSet<Value, 8> &plannedValues,
               SmallVectorImpl<RematLeafExtension> &extensions) const {
    wave::WaveAMDPressureReliefCost cost;
    if (!isMemorySpillSuppressedVGPRExpr(value.getDefiningOp()))
      cost.instabilityPenalty = kFallbackRootPenalty;
    DenseSet<Value> materialized;
    unsigned opCount = getRematOpCountAt(value, rebuildOp, plannedValues,
                                         extensions, materialized);
    addLoopScaledCost(cost, rebuildOp, opCount);
    return cost;
  }

  bool isCandidateSlotValue(IntervalGroup *group, Value value) const {
    auto type = dyn_cast<waveamdmachine::RegType>(value.getType());
    Operation *def = value.getDefiningOp();
    if (!type || type.getRegClass() != waveamdmachine::RegClass::VGPR)
      return false;
    if (type.getWidth() == 0 || !def)
      return false;
    if (isRegAllocTempOp(def) || !isCheapVGPRPressureReliefExpr(def))
      return false;
    return valueBelongsToGroup(group, value);
  }

  FailureOr<std::optional<RematValueSlot>>
  getGroupValueSlot(IntervalGroup *group, Value value,
                    const llvm::SmallDenseSet<Value, 8> &plannedValues,
                    SmallVectorImpl<RematLeafExtension> &leafExtensions) const {
    SmallVector<OpOperand *> uses;
    if (!collectExternalUses(value, plannedValues, uses)) {
      recordReject(group, value, "external_uses_unavailable");
      return failure();
    }
    FailureOr<RematPostCutUseSet> postCutUses = getPostCutUses(value, uses);
    if (failed(postCutUses)) {
      recordReject(group, value, "post_cut_uses_invalid", uses);
      return failure();
    }
    if (postCutUses->empty())
      return std::optional<RematValueSlot>{};
    if (repeatsExistingRematPlacement(group, value, *postCutUses)) {
      recordReject(group, value, "existing_remat_placement", *postCutUses);
      return failure();
    }
    if (!isCandidateSlotValue(group, value)) {
      recordReject(group, value, "not_cheap_vgpr_root", *postCutUses);
      return failure();
    }
    Operation *rebuildOp = postCutUses->rebuildOp;
    if (!canRematerializeTreeAt(value, rebuildOp, plannedValues, leafExtensions,
                                /*materializing=*/true)) {
      recordReject(group, value, "dag_not_rematerializable", *postCutUses,
                   leafExtensions);
      return failure();
    }
    SmallVector<Value, 4> originalLeaves;
    if (failed(collectOriginalLeavesAt(value, rebuildOp, plannedValues,
                                       originalLeaves))) {
      recordReject(group, value, "dag_not_rematerializable", *postCutUses,
                   leafExtensions);
      return failure();
    }
    unsigned endPosition = postCutUses->rebuildPosition;
    for (OpOperand *use : postCutUses->operands) {
      unsigned usePosition = inventory.positions.lookup(use->getOwner());
      endPosition = std::max(
          endPosition, getMemorySpillUseEnd(*use, inventory, usePosition));
    }
    for (Operation *user : postCutUses->generatedUsers)
      endPosition = std::max(endPosition, inventory.positions.lookup(user));
    RematValueSlot slot;
    slot.value = value;
    slot.postCutUses = postCutUses->operands;
    slot.originalLeaves = std::move(originalLeaves);
    slot.cost = getRematCost(value, rebuildOp, plannedValues, leafExtensions);
    slot.rebuildOp = rebuildOp;
    slot.rebuildPosition = postCutUses->rebuildPosition;
    slot.endPosition = endPosition;
    slot.useCount = postCutUses->size();
    slot.generatedUseCount = postCutUses->generatedUsers.size();
    return std::optional<RematValueSlot>{slot};
  }

  void collect(IntervalGroup *group,
               wave::WaveAMDPressureReliefCandidateList &candidates) const {
    if (!isRematCandidateGroup(group, position))
      return;
    unsigned reliefDwords = getLiveLaneCount(group);
    if (reliefDwords == 0)
      return;
    SmallVector<RematValueSlot, 4> valueSlots;
    SmallVector<Value> groupValues = getGroupValues(group, inventory);
    llvm::SmallDenseSet<Value, 8> plannedValues = getPlannedValues(groupValues);
    SmallVector<RematLeafExtension, 8> leafExtensions;
    for (Value value : groupValues) {
      FailureOr<std::optional<RematValueSlot>> slot =
          getGroupValueSlot(group, value, plannedValues, leafExtensions);
      if (failed(slot))
        return;
      if (*slot)
        valueSlots.push_back(**slot);
    }
    if (valueSlots.empty())
      return;
    SmallVector<RematLeafExtension, 8> mergedLeafExtensions =
        mergeLeafExtensions(leafExtensions);
    wave::WaveAMDPressureReliefEffect leafPressureEffect =
        getLeafPressureEffect(mergedLeafExtensions);
    if (getPressureDeltaForClass(leafPressureEffect, group->storageClass) >=
        static_cast<int64_t>(reliefDwords)) {
      recordReject(group, valueSlots.front().value,
                   "added_pressure_not_profitable",
                   valueSlots.front().postCutUses, mergedLeafExtensions);
      return;
    }
    SmallVector<RematPlannedType, 8> plannedTypes;
    DenseSet<Value> materialized;
    for (const RematValueSlot &slot : valueSlots) {
      collectTreePlannedTypesAt(slot.value, slot.rebuildOp, plannedValues,
                                materialized, plannedTypes);
    }
    candidates.push_back(std::make_unique<RematCandidate>(
        group, valueSlots, groupValues, plannedTypes, mergedLeafExtensions,
        leafPressureEffect, position, reliefDwords,
        getMemorySpillTotalCost(valueSlots)));
  }

  LogicalResult
  mapRematOperands(Operation *def, Operation *user,
                   const wave::WaveAMDPressureReliefPlan &plan,
                   wave::WaveAMDPressureReliefMaterializationContext &context,
                   OpBuilder &builder, DenseMap<Value, Value> &cache,
                   IRMapping &mapper,
                   const llvm::SmallDenseSet<Value, 8> &plannedValues,
                   const llvm::SmallDenseSet<Value, 8> &leafValues,
                   ArrayRef<MaterializedRematReplacement> replacements,
                   ArrayRef<RematPlannedType> plannedTypes) const {
    for (Value operand : def->getOperands()) {
      Value replacement = operand;
      if (leafValues.contains(operand)) {
        if (Value rematReplacement =
                lookupMaterializedReplacementAt(operand, user, replacements))
          replacement = rematReplacement;
        mapper.map(operand, replacement);
        continue;
      }
      SmallVector<RematLeafExtension, 4> materializedExtensions;
      RematOperandPlan operandPlan =
          getOperandPlanAt(operand, user, plannedValues, materializedExtensions,
                           /*materializing=*/true);
      if (operandPlan == RematOperandPlan::Invalid)
        return mlir::emitError(user->getLoc())
               << "waveamd-reg-alloc cannot rematerialize operand tree for "
               << operand;
      if (operandPlan == RematOperandPlan::Rematerialize) {
        FailureOr<Value> rematOperand = materializeTreeAt(
            operand, user, plan, context, builder, cache, plannedValues,
            leafValues, replacements, plannedTypes);
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
      Operation *user, ArrayRef<RematPlannedType> plannedTypes) const {
    for (auto [originalResult, clonedResult] :
         llvm::zip(def->getResults(), clone->getResults())) {
      auto originalType =
          dyn_cast<waveamdmachine::RegType>(originalResult.getType());
      if (!originalType || !isTrackedRegClass(originalType.getRegClass()))
        continue;
      std::optional<waveamdmachine::RegType> type =
          getPlannedType(originalResult, plannedTypes);
      if (!type)
        return clone->emitError()
               << "waveamd-reg-alloc missing remat temp for cloned result";
      FailureOr<waveamdmachine::RegType> assignedType =
          consumePressureReliefTempRegType(plan, context, type->getRegClass(),
                                           type->getWidth(), user);
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
                    OpBuilder &builder, DenseMap<Value, Value> &cache,
                    const llvm::SmallDenseSet<Value, 8> &plannedValues,
                    const llvm::SmallDenseSet<Value, 8> &leafValues,
                    ArrayRef<MaterializedRematReplacement> replacements,
                    ArrayRef<RematPlannedType> plannedTypes) const {
    if (Value cached = cache.lookup(value))
      return cached;
    Operation *def = getDominatingCheapDef(value, user, /*materializing=*/true);
    if (!def)
      return mlir::emitError(value.getLoc())
             << "waveamd-reg-alloc cannot rematerialize value tree";

    IRMapping mapper;
    if (failed(mapRematOperands(def, user, plan, context, builder, cache,
                                mapper, plannedValues, leafValues, replacements,
                                plannedTypes)))
      return failure();

    builder.setInsertionPoint(user);
    Operation *clone = builder.clone(*def, mapper);
    clone->setAttr(kRegAllocRematTempAttr, builder.getUnitAttr());
    if (failed(assignRematCloneResultTypes(def, clone, plan, context, user,
                                           plannedTypes)))
      return failure();
    inventory.positions[clone] = inventory.positions.lookup(user);
    return cacheRematCloneResults(value, def, clone, cache);
  }

  LogicalResult materializeValue(
      const RematValueSlot &slot, const wave::WaveAMDPressureReliefPlan &plan,
      wave::WaveAMDPressureReliefMaterializationContext &context,
      OpBuilder &builder, const llvm::SmallDenseSet<Value, 8> &plannedValues,
      const llvm::SmallDenseSet<Value, 8> &leafValues,
      SmallVectorImpl<MaterializedRematReplacement> &replacements,
      const llvm::SmallDenseSet<Operation *, 8> &protectedTemplateOps) const {
    Value value = slot.value;
    Operation *def = value.getDefiningOp();
    if (!def || def->getNumResults() == 0)
      return mlir::emitError(value.getLoc())
             << "waveamd-reg-alloc cannot rematerialize value";
    if (!slot.rebuildOp)
      return mlir::emitError(value.getLoc())
             << "waveamd-reg-alloc cannot rematerialize without post-cut uses";

    DenseMap<Value, Value> cache;
    const RematPlan &remat = static_cast<const RematPlan &>(plan);
    FailureOr<Value> replacement = materializeTreeAt(
        value, slot.rebuildOp, plan, context, builder, cache, plannedValues,
        leafValues, replacements, remat.getPlannedTypes());
    if (failed(replacement))
      return failure();
    replacements.push_back(
        {&plan, value, *replacement, slot.rebuildPosition, slot.endPosition});

    for (OpOperand *use : slot.postCutUses) {
      if (use->get() != value)
        continue;
      if (protectedTemplateOps.contains(use->getOwner()))
        continue;
      use->set(*replacement);
    }
    return success();
  }

  ArrayRef<IntervalGroup *> groups;
  Inventory &inventory;
  IntervalGroup *request = nullptr;
  unsigned position = 0;
  mutable std::optional<RematRejectDiagnostic> rejectDiagnostic;
};

} // namespace

std::unique_ptr<wave::WaveAMDPressureReliefProvider>
mlir::wave::regalloc::createRematerializeProvider(
    ArrayRef<IntervalGroup *> groups, IntervalGroup *request, unsigned position,
    Inventory &inventory) {
  return std::make_unique<RematProvider>(groups, request, position, inventory);
}
