//===- WaveAMDRegAllocLDS.cpp - LDS spill planning ------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "WaveAMDRegAllocInternal.h"

#include "Utils/AMDGPUBaseInfo.h"
#include "mlir/Dialect/Wave/IR/Wave.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachineTarget.h"
#include "mlir/IR/Builders.h"
#include "mlir/IR/BuiltinAttributes.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/MC/MCSubtargetInfo.h"
#include "llvm/MC/TargetRegistry.h"
#include "llvm/Support/MathExtras.h"
#include "llvm/Support/TargetSelect.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/TargetParser/Triple.h"

#include <algorithm>
#include <array>
#include <limits>

using namespace mlir;
using namespace mlir::wave::regalloc;

namespace {

struct LDSTargetInfo {
  unsigned localMemorySize = 0;
  unsigned addressableLocalMemorySize = 0;
  unsigned wavefrontSize = 0;
  unsigned eusPerCU = 0;
};

struct WorkgroupShape {
  std::array<unsigned, 3> dims = {1, 1, 1};
  unsigned flatSize = 1;

  bool isXLinear() const { return dims[1] == 1 && dims[2] == 1; }
};

static void getExistingLDSBytes(func::FuncOp func, unsigned &fixedBytes,
                                unsigned &dynamicBytes, unsigned reservedBytes);
static LDSSpillPlan buildLDSSpillPlan(func::FuncOp func,
                                      RegisterBudgets budgets,
                                      unsigned valueBytes,
                                      unsigned reservedSpillBytes,
                                      unsigned fixedLDS, unsigned dynamicLDS);

static bool canFoldSlotBaseIntoDSOffset(unsigned slotBase) {
  std::pair<int64_t, int64_t> range = waveamdmachine::instOffsetRange(
      waveamdmachine::DsStoreB32Op::getAddressFieldSpec());
  return slotBase >= static_cast<uint64_t>(range.first) &&
         slotBase <= static_cast<uint64_t>(range.second);
}

static unsigned getAddressOpsPerAccess(const LDSSpillPlan &plan) {
  return canFoldSlotBaseIntoDSOffset(plan.slotBase) ? 1 : 2;
}

static bool isLiveAt(Interval *interval, unsigned position) {
  return !interval->values.empty() && interval->start <= position &&
         position <= interval->end;
}

static bool isTempGroup(IntervalGroup *group) {
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

static bool isLDSSpillRegClass(waveamdmachine::RegClass regClass) {
  return regClass == waveamdmachine::RegClass::VGPR ||
         regClass == waveamdmachine::RegClass::AGPR;
}

static bool isOpenSpillGroup(IntervalGroup *group) {
  if (!group || group->plannedPressureRelief || group->reserved ||
      isFixedRegisterGroup(group))
    return false;
  return !group->intervals.empty();
}

static bool hasLDSSpillRegClass(IntervalGroup *group) {
  return isLDSSpillRegClass(group->storageClass);
}

static bool isLDSSpillCandidateGroup(IntervalGroup *group, unsigned position) {
  if (!isOpenSpillGroup(group) || !hasLDSSpillRegClass(group))
    return false;
  if (group->storageClass == waveamdmachine::RegClass::AGPR &&
      !isTempGroup(group))
    return false;
  if (!llvm::any_of(group->intervals,
                    [&](Interval *lane) { return isLiveAt(lane, position); }))
    return false;
  return true;
}

static bool isLDSSpillEligibleGroup(IntervalGroup *group, unsigned position) {
  if (!isLDSSpillCandidateGroup(group, position))
    return false;
  if (!group->nonPromotable &&
      llvm::all_of(group->intervals,
                   [](Interval *lane) { return !lane->nonPromotable; }))
    return true;
  return isTempGroup(group);
}

struct LDSValueSlot {
  Value value;
  SmallVector<LDSSpillPlan, 4> plans;
  wave::WaveAMDPressureReliefCost cost;
  unsigned useCount = 0;
};

using LDSLoadResult = MemorySpillLoadResult;
using LoopCarrySlot = MemorySpillLoopCarrySlot;

static unsigned getTotalUseCount(ArrayRef<LDSValueSlot> slots) {
  unsigned total = 0;
  for (const LDSValueSlot &slot : slots)
    total += slot.useCount;
  return total;
}

static unsigned getTotalSlotBytes(ArrayRef<LDSSpillPlan> plans) {
  unsigned total = 0;
  for (LDSSpillPlan plan : plans)
    total += plan.slotBytes;
  return total;
}

static unsigned getTotalSlotBytes(ArrayRef<LDSValueSlot> slots) {
  unsigned total = 0;
  for (const LDSValueSlot &slot : slots)
    total += getTotalSlotBytes(slot.plans);
  return total;
}

static wave::WaveAMDPressureReliefCost
getTotalCost(ArrayRef<LDSValueSlot> slots) {
  wave::WaveAMDPressureReliefCost total;
  for (const LDSValueSlot &slot : slots) {
    total.materializationOps += slot.cost.materializationOps;
    total.loopWeightedOps += slot.cost.loopWeightedOps;
    total.latencyPenalty += slot.cost.latencyPenalty;
    total.instabilityPenalty += slot.cost.instabilityPenalty;
  }
  return total;
}

class LDSPressurePlan : public wave::WaveAMDPressureReliefPlan {
public:
  StringRef getProviderName() const override { return "lds-spill"; }

  virtual IntervalGroup *getGroup() const = 0;
  virtual LDSSpillPlan getPlan() const = 0;
  virtual unsigned getUseCount() const = 0;
  virtual Value getValue() const { return {}; }
  virtual ArrayRef<LDSValueSlot> getValueSlots() const { return {}; }
  virtual unsigned getReservedBytes() const {
    return getTotalSlotBytes(getValueSlots());
  }
  virtual std::optional<LoopCarrySlot> getLoopCarry() const {
    return std::nullopt;
  }
};

class LDSValuePressurePlan final : public LDSPressurePlan {
public:
  LDSValuePressurePlan(IntervalGroup *group, ArrayRef<LDSValueSlot> valueSlots,
                       unsigned reliefDwords)
      : valueSlots(valueSlots), group(group), reliefDwords(reliefDwords) {}

  wave::WaveAMDPressureReliefProviderKind getProviderKind() const override {
    return wave::WaveAMDPressureReliefProviderKind::LDSSpill;
  }
  unsigned getReliefDwords() const override { return reliefDwords; }

  IntervalGroup *getGroup() const override { return group; }
  LDSSpillPlan getPlan() const override {
    assert(!valueSlots.empty() && !valueSlots.front().plans.empty() &&
           "LDS value plan needs a slot");
    return valueSlots.front().plans.front();
  }
  unsigned getUseCount() const override { return getTotalUseCount(valueSlots); }
  Value getValue() const override {
    return valueSlots.size() == 1 ? valueSlots.front().value : Value{};
  }
  ArrayRef<LDSValueSlot> getValueSlots() const override { return valueSlots; }
  unsigned getReservedBytes() const override {
    return getTotalSlotBytes(valueSlots);
  }

private:
  SmallVector<LDSValueSlot, 4> valueSlots;
  IntervalGroup *group = nullptr;
  unsigned reliefDwords = 0;
};

class LDSLoopCarryPressurePlan final : public LDSPressurePlan {
public:
  LDSLoopCarryPressurePlan(IntervalGroup *group, LoopCarrySlot loopCarry,
                           LDSValueSlot valueSlot, unsigned useCount,
                           unsigned reliefDwords)
      : valueSlot(std::move(valueSlot)), loopCarry(loopCarry), group(group),
        useCount(useCount), reliefDwords(reliefDwords) {}

  wave::WaveAMDPressureReliefProviderKind getProviderKind() const override {
    return wave::WaveAMDPressureReliefProviderKind::LDSSpill;
  }
  unsigned getReliefDwords() const override { return reliefDwords; }

  IntervalGroup *getGroup() const override { return group; }
  LDSSpillPlan getPlan() const override {
    assert(!valueSlot.plans.empty() && "LDS loop-carry plan needs a slot");
    return valueSlot.plans.front();
  }
  unsigned getUseCount() const override { return useCount; }
  ArrayRef<LDSValueSlot> getValueSlots() const override { return valueSlot; }
  unsigned getReservedBytes() const override {
    return getTotalSlotBytes(valueSlot.plans);
  }
  std::optional<LoopCarrySlot> getLoopCarry() const override {
    return loopCarry;
  }

private:
  LDSValueSlot valueSlot;
  LoopCarrySlot loopCarry;
  IntervalGroup *group = nullptr;
  unsigned useCount = 0;
  unsigned reliefDwords = 0;
};

static LoopCarrySlot getPlanLoopCarrySlot(const LDSPressurePlan &spill) {
  std::optional<LoopCarrySlot> slot = spill.getLoopCarry();
  assert(slot && "expected loop-carry LDS spill");
  return *slot;
}

static const LDSValueSlot &getPlanValueSlot(const LDSPressurePlan &spill) {
  assert(!spill.getValueSlots().empty() && "expected LDS value slot");
  return spill.getValueSlots().front();
}

class LDSSpillCandidate final : public wave::WaveAMDPressureReliefCandidate {
public:
  LDSSpillCandidate(IntervalGroup *group, LDSValueSlot valueSlot,
                    unsigned pressureRelief,
                    wave::WaveAMDPressureReliefCost cost,
                    StringRef rejectReason = StringRef())
      : rejectReason(rejectReason.str()), cost(cost), group(group),
        pressureRelief(pressureRelief) {
    valueSlots.push_back(std::move(valueSlot));
  }

  LDSSpillCandidate(IntervalGroup *group, ArrayRef<LDSValueSlot> valueSlots,
                    unsigned pressureRelief,
                    wave::WaveAMDPressureReliefCost cost)
      : valueSlots(valueSlots), cost(cost), group(group),
        pressureRelief(pressureRelief) {}

  LDSSpillCandidate(IntervalGroup *group, LoopCarrySlot loopCarry,
                    LDSValueSlot valueSlot, unsigned useCount,
                    unsigned pressureRelief,
                    wave::WaveAMDPressureReliefCost cost)
      : cost(cost), group(group), loopCarry(loopCarry), useCount(useCount),
        pressureRelief(pressureRelief) {
    valueSlots.push_back(std::move(valueSlot));
  }

  StringRef getProviderName() const override { return "lds-spill"; }

  wave::WaveAMDPressureReliefCost getCost() const override { return cost; }

  unsigned getReliefDwords() const override { return pressureRelief; }

  wave::WaveAMDPressureReliefEffect getPressureEffect(
      const wave::WaveAMDPressureFailure &failure) const override {
    if (failure.placementFailure)
      return {};
    if (failure.combinedVGPRAGPR && group &&
        group->storageClass == waveamdmachine::RegClass::AGPR)
      return {};
    return getMemorySpillPressureEffect(group, pressureRelief);
  }

  std::optional<StringRef> getRejectReason() const override {
    if (rejectReason.empty())
      return std::nullopt;
    return StringRef(rejectReason);
  }

  IntervalGroup *getGroup() const { return group; }
  LDSSpillPlan getPlan() const {
    assert(!valueSlots.empty() && !valueSlots.front().plans.empty() &&
           "LDS candidate needs a slot");
    return valueSlots.front().plans.front();
  }
  unsigned getUseCount() const {
    if (loopCarry)
      return useCount;
    return getTotalUseCount(valueSlots);
  }
  Value getValue() const {
    if (loopCarry || valueSlots.size() != 1)
      return {};
    return valueSlots.front().value;
  }
  ArrayRef<LDSValueSlot> getValueSlots() const { return valueSlots; }
  std::optional<LoopCarrySlot> getLoopCarry() const { return loopCarry; }
  std::unique_ptr<wave::WaveAMDPressureReliefPlan> getPlannedSpill() const {
    if (loopCarry) {
      assert(valueSlots.size() == 1 && "loop-carry LDS uses one value slot");
      return std::make_unique<LDSLoopCarryPressurePlan>(
          group, *loopCarry, valueSlots.front(), useCount, pressureRelief);
    }
    return std::make_unique<LDSValuePressurePlan>(group, valueSlots,
                                                  pressureRelief);
  }

protected:
  void printExtra(llvm::raw_ostream &os) const override {
    LDSSpillPlan firstPlan = getPlan();
    os << ", reg_class=" << getRegClassName(group->storageClass);
    os << ", slot_base=" << firstPlan.slotBase
       << ", slot_bytes=" << getTotalSlotBytes(valueSlots)
       << ", uses=" << getUseCount();
  }

  void setExtraDiagnosticAttrs(Builder &builder,
                               NamedAttrList &attrs) const override {
    LDSSpillPlan firstPlan = getPlan();
    attrs.set("reg_class",
              builder.getStringAttr(getRegClassName(group->storageClass)));
    attrs.set("slot_base", builder.getI64IntegerAttr(firstPlan.slotBase));
    attrs.set("slot_bytes",
              builder.getI64IntegerAttr(getTotalSlotBytes(valueSlots)));
    attrs.set("pressure_relief", builder.getI64IntegerAttr(pressureRelief));
    attrs.set("uses", builder.getI64IntegerAttr(getUseCount()));
  }

private:
  std::string rejectReason;
  SmallVector<LDSValueSlot, 4> valueSlots;
  wave::WaveAMDPressureReliefCost cost;
  IntervalGroup *group = nullptr;
  std::optional<LoopCarrySlot> loopCarry;
  unsigned useCount = 0;
  unsigned pressureRelief = 0;
};

class LDSSpillProvider final : public wave::WaveAMDPressureReliefProvider {
public:
  LDSSpillProvider(func::FuncOp func, ArrayRef<IntervalGroup *> groups,
                   IntervalGroup *request, unsigned position,
                   RegisterBudgets budgets, Inventory &inventory)
      : func(func), groups(groups), budgets(budgets), inventory(inventory),
        request(request), position(position) {}

  StringRef getName() const override { return "lds-spill"; }
  wave::WaveAMDPressureReliefProviderKind getKind() const override {
    return wave::WaveAMDPressureReliefProviderKind::LDSSpill;
  }

  LogicalResult collectCandidates(
      const wave::WaveAMDPressureReliefQuery &query,
      wave::WaveAMDPressureReliefCandidateList &candidates) const override {
    pressureFailure = query.failure;
    sawLoopCarryReject = false;
    planRejectReason.clear();
    for (IntervalGroup *group : groups)
      collect(group, candidates);
    collect(request, candidates);
    return success();
  }

  std::unique_ptr<wave::WaveAMDPressureReliefPlan> createPlan(
      const wave::WaveAMDPressureReliefCandidate &candidate) const override {
    const LDSSpillCandidate &spill =
        static_cast<const LDSSpillCandidate &>(candidate);
    return spill.getPlannedSpill();
  }

  void applyPlan(const wave::WaveAMDPressureReliefPlan &plan) const override {
    const LDSPressurePlan &spill = static_cast<const LDSPressurePlan &>(plan);
    if (spill.getGroup()) {
      spill.getGroup()->plannedPressureRelief = true;
      spill.getGroup()->assignedBase.reset();
    }
    addPlannedProviderBytes(inventory, getName(), spill.getReservedBytes());
  }

  LogicalResult materializePlan(const wave::WaveAMDPressureReliefPlan &plan,
                                OpBuilder &builder) const override {
    const LDSPressurePlan &spill = static_cast<const LDSPressurePlan &>(plan);
    if (spill.getLoopCarry()) {
      SmallVector<const LDSPressurePlan *, 1> spills{&spill};
      return materializeLoopCarryPlans(spills, builder);
    }
    assert(!spill.getValueSlots().empty() && "expected LDS value spill");
    for (const LDSValueSlot &slot : spill.getValueSlots())
      if (failed(materializeValue(slot.value, slot.plans, builder)))
        return failure();
    for (const LDSValueSlot &slot : spill.getValueSlots())
      reserveSlots(slot.plans, builder);
    return success();
  }

  LogicalResult
  materializePlans(ArrayRef<const wave::WaveAMDPressureReliefPlan *> plans,
                   OpBuilder &builder) const override {
    SmallVector<SmallVector<const LDSPressurePlan *, 2>, 8> loopCarryGroups;
    for (const wave::WaveAMDPressureReliefPlan *plan : plans) {
      const LDSPressurePlan &spill =
          static_cast<const LDSPressurePlan &>(*plan);
      std::optional<LoopCarrySlot> slot = spill.getLoopCarry();
      if (!slot) {
        if (failed(materializePlan(*plan, builder)))
          return failure();
        continue;
      }
      Operation *loop = slot->loop.getOperation();
      auto it = llvm::find_if(loopCarryGroups, [&](const auto &group) {
        LoopCarrySlot groupSlot = getPlanLoopCarrySlot(*group.front());
        return groupSlot.loop.getOperation() == loop;
      });
      if (it == loopCarryGroups.end())
        loopCarryGroups.push_back({&spill});
      else
        it->push_back(&spill);
    }
    llvm::stable_sort(loopCarryGroups, [](const auto &lhs, const auto &rhs) {
      waveamdmachine::UniformLoopOp lhsLoop =
          getPlanLoopCarrySlot(*lhs.front()).loop;
      waveamdmachine::UniformLoopOp rhsLoop =
          getPlanLoopCarrySlot(*rhs.front()).loop;
      return getLoopDepth(lhsLoop.getOperation()) >
             getLoopDepth(rhsLoop.getOperation());
    });
    for (ArrayRef<const LDSPressurePlan *> group : loopCarryGroups)
      if (failed(materializeLoopCarryPlans(group, builder)))
        return failure();
    return success();
  }

  bool isBetterCandidate(
      const wave::WaveAMDPressureReliefCandidate &lhs,
      const wave::WaveAMDPressureReliefCandidate &rhs) const override {
    if (lhs.isLegal() != rhs.isLegal())
      return lhs.isLegal();
    const LDSSpillCandidate &lhsSpill =
        static_cast<const LDSSpillCandidate &>(lhs);
    const LDSSpillCandidate &rhsSpill =
        static_cast<const LDSSpillCandidate &>(rhs);
    if (lhs.getReliefDwords() != rhs.getReliefDwords())
      return lhs.getReliefDwords() > rhs.getReliefDwords();
    if (lhsSpill.getGroup()->intervals.front()->end !=
        rhsSpill.getGroup()->intervals.front()->end)
      return lhsSpill.getGroup()->intervals.front()->end >
             rhsSpill.getGroup()->intervals.front()->end;
    return wave::isBetterWaveAMDPressureReliefCandidate(lhs, rhs);
  }

  std::optional<StringRef> getRejectReason() const override {
    if (sawLoopCarryReject)
      return kMemorySpillLoopCarryReject;
    if (!planRejectReason.empty())
      return StringRef(planRejectReason);
    return std::nullopt;
  }

  void clearNoCandidateDiagnostic() const {
    func->removeAttr(kMemorySpillRejectAttr);
    func->removeAttr(kMemorySpillRejectDetailAttr);
  }

  void setNoCandidateDiagnostic() const {
    std::optional<StringRef> reason = getRejectReason();
    if (!reason)
      return;
    Builder builder(func->getContext());
    func->setAttr(kMemorySpillRejectAttr, builder.getStringAttr(*reason));
  }

  void notifyNoCandidate() const override { setNoCandidateDiagnostic(); }

  void notifyPlanApplied() const override { clearNoCandidateDiagnostic(); }

private:
  static std::optional<unsigned> getUnsignedAttr(Operation *op, StringRef name);

  void setPlanRejectReason(LDSSpillPlanStatus status) const {
    planRejectReason = "lds_spill_";
    planRejectReason += getLDSSpillPlanStatusName(status);
  }

  static bool isEligibleGroup(IntervalGroup *group, unsigned position) {
    return isLDSSpillEligibleGroup(group, position);
  }

  static bool isCandidateGroup(IntervalGroup *group, unsigned position) {
    return isLDSSpillCandidateGroup(group, position);
  }

  static unsigned getLDSMaterializationOps(ArrayRef<LDSSpillPlan> plans) {
    unsigned total = 0;
    for (LDSSpillPlan plan : plans)
      total += 1 + getAddressOpsPerAccess(plan);
    return total;
  }

  static wave::WaveAMDPressureReliefCost
  getLoopCarrySpillCost(LoopCarrySlot slot, ArrayRef<LDSSpillPlan> plans,
                        unsigned useCount) {
    unsigned opCount = getLDSMaterializationOps(plans);
    unsigned loopDepth = getLoopDepth(slot.loop.getOperation());
    wave::WaveAMDPressureReliefCost cost;
    cost.materializationOps = static_cast<int64_t>(opCount) * (1 + useCount);
    cost.loopWeightedOps = static_cast<int64_t>(opCount) * useCount * loopDepth;
    cost.latencyPenalty = static_cast<int64_t>(plans.size()) * useCount * 2;
    return cost;
  }

  wave::WaveAMDPressureReliefCost
  getValueSpillCost(Value value, ArrayRef<LDSSpillPlan> plans,
                    ArrayRef<OpOperand *> uses) const {
    unsigned opCount = getLDSMaterializationOps(plans);
    wave::WaveAMDPressureReliefCost cost;
    cost.materializationOps = static_cast<int64_t>(opCount) * (1 + uses.size());
    cost.loopWeightedOps =
        static_cast<int64_t>(opCount) * getLoopDepth(value.getDefiningOp());
    for (OpOperand *use : uses)
      cost.loopWeightedOps +=
          static_cast<int64_t>(opCount) * getLoopDepth(use->getOwner());
    cost.latencyPenalty = static_cast<int64_t>(plans.size()) * uses.size() * 2;
    return cost;
  }

  bool hasSimpleUses(Value value, SmallVectorImpl<OpOperand *> &uses) const {
    return collectSimpleMemorySpillUses(value, uses, sawLoopCarryReject);
  }

  bool isValueLiveAt(Value value, ArrayRef<OpOperand *> uses) const {
    return isValueLiveAtPressure(value, uses, inventory, position);
  }

  bool isCombinedPressure() const {
    return pressureFailure && pressureFailure->combinedVGPRAGPR;
  }

  std::optional<unsigned> getPressureRelief(Value value, unsigned width,
                                            ArrayRef<OpOperand *> uses) const {
    return getMemorySpillPressureRelief(value, width, uses, inventory,
                                        pressureFailure);
  }

  bool valueCoversWholeGroup(IntervalGroup *group, Value value) const {
    return mlir::wave::regalloc::valueCoversWholeGroup(group, value, inventory);
  }

  LDSSpillPlan getPlanForBytes(unsigned valueBytes,
                               unsigned extraReservedBytes = 0) const {
    unsigned committedBytes =
        getUnsignedAttr(func, kLDSSpillBytesAttr).value_or(0);
    unsigned fixedLDS = 0;
    unsigned dynamicLDS = 0;
    getExistingLDSBytes(func, fixedLDS, dynamicLDS, committedBytes);
    unsigned reservedBytes = committedBytes +
                             getPlannedProviderBytes(inventory, getName()) +
                             extraReservedBytes;
    return buildLDSSpillPlan(func, budgets, valueBytes, reservedBytes, fixedLDS,
                             dynamicLDS);
  }

  std::optional<SmallVector<LDSSpillPlan, 4>>
  getPlansForValue(waveamdmachine::RegType type,
                   unsigned extraReservedBytes = 0) const {
    if (type.getWidth() == 0)
      return std::nullopt;
    SmallVector<LDSSpillPlan, 4> plans;
    plans.reserve(type.getWidth());
    unsigned reserved = extraReservedBytes;
    for ([[maybe_unused]] unsigned index :
         llvm::seq<unsigned>(0, type.getWidth())) {
      LDSSpillPlan plan = getPlanForBytes(/*valueBytes=*/4, reserved);
      if (plan.status != LDSSpillPlanStatus::Available) {
        setPlanRejectReason(plan.status);
        return std::nullopt;
      }
      reserved += plan.slotBytes;
      plans.push_back(plan);
    }
    return plans;
  }

  FailureOr<LDSValueSlot> getGroupValueSlot(Value value,
                                            unsigned extraReservedBytes) const {
    auto type = dyn_cast<waveamdmachine::RegType>(value.getType());
    if (!type || !isLDSSpillRegClass(type.getRegClass()) ||
        type.getWidth() == 0)
      return failure();
    if (isCombinedPressure() &&
        isCheapVGPRPressureReliefExpr(value.getDefiningOp()))
      return failure();
    SmallVector<OpOperand *> uses;
    if (!hasSimpleUses(value, uses) || !isValueLiveAt(value, uses))
      return failure();
    std::optional<SmallVector<LDSSpillPlan, 4>> plans =
        getPlansForValue(type, extraReservedBytes);
    if (!plans)
      return failure();
    return LDSValueSlot{value, *plans, getValueSpillCost(value, *plans, uses),
                        static_cast<unsigned>(uses.size())};
  }

  void
  collectValue(IntervalGroup *group, Value value,
               wave::WaveAMDPressureReliefCandidateList &candidates) const {
    waveamdmachine::RegType type =
        cast<waveamdmachine::RegType>(value.getType());
    if (!isLDSSpillRegClass(type.getRegClass()) || type.getWidth() == 0 ||
        !valueCoversWholeGroup(group, value))
      return;
    SmallVector<OpOperand *> uses;
    if (!hasSimpleUses(value, uses) || !isValueLiveAt(value, uses))
      return;
    std::optional<SmallVector<LDSSpillPlan, 4>> plans = getPlansForValue(type);
    if (!plans)
      return;
    std::optional<unsigned> pressureRelief =
        getPressureRelief(value, type.getWidth(), uses);
    if (!pressureRelief || *pressureRelief == 0)
      return;
    wave::WaveAMDPressureReliefCost cost =
        getValueSpillCost(value, *plans, uses);
    LDSValueSlot slot{value, *plans, cost, static_cast<unsigned>(uses.size())};
    candidates.push_back(std::make_unique<LDSSpillCandidate>(
        group, std::move(slot), *pressureRelief, cost));
  }

  unsigned getLiveLaneCount(IntervalGroup *group) const {
    return mlir::wave::regalloc::getLiveLaneCount(group, position);
  }

  bool liveLanesStartBeforePressure(IntervalGroup *group) const {
    return mlir::wave::regalloc::liveLanesStartBeforePressure(group, position);
  }

  void collectGroupValue(
      IntervalGroup *group,
      wave::WaveAMDPressureReliefCandidateList &candidates) const {
    if (!isCombinedPressure() || group->intervals.size() <= 1 ||
        !liveLanesStartBeforePressure(group))
      return;
    unsigned relief = getLiveLaneCount(group);
    if (relief == 0)
      return;

    SmallVector<LDSValueSlot, 8> slots;
    unsigned extraReservedBytes = 0;
    for (Value value : getGroupValues(group)) {
      FailureOr<LDSValueSlot> slot =
          getGroupValueSlot(value, extraReservedBytes);
      if (failed(slot))
        continue;
      extraReservedBytes += getTotalSlotBytes(slot->plans);
      slots.push_back(*slot);
    }
    if (slots.empty())
      return;
    candidates.push_back(std::make_unique<LDSSpillCandidate>(
        group, slots, relief, getTotalCost(slots)));
  }

  void collect(IntervalGroup *group,
               wave::WaveAMDPressureReliefCandidateList &candidates) const {
    if (!isCandidateGroup(group, position))
      return;
    if (isEligibleGroup(group, position)) {
      if (collectLoopCarry(group, candidates))
        return;
      llvm::SmallDenseSet<Value, 8> seen;
      for (Interval *lane : group->intervals)
        for (Value value : lane->values)
          if (seen.insert(value).second)
            collectValue(group, value, candidates);
    }
    collectGroupValue(group, candidates);
  }

  bool
  collectLoopCarry(IntervalGroup *group,
                   wave::WaveAMDPressureReliefCandidateList &candidates) const {
    std::optional<LoopCarrySlot> loopCarry =
        mlir::wave::regalloc::getLoopCarrySlot(group, inventory);
    if (!loopCarry)
      return false;
    if (!canMaterializeLoopCarrySpill(*loopCarry, inventory, position)) {
      sawLoopCarryReject = true;
      return false;
    }
    Value init = loopCarry->loop.getInits()[loopCarry->index];
    waveamdmachine::RegType type =
        dyn_cast<waveamdmachine::RegType>(init.getType());
    if (!type || type.getRegClass() != waveamdmachine::RegClass::VGPR ||
        !valueCoversWholeGroup(group, init))
      return false;
    if (type.getWidth() <= 1) {
      sawLoopCarryReject = true;
      return false;
    }
    if (loopCarryTouchesPressure(*loopCarry, inventory, position))
      return false;
    std::optional<SmallVector<LDSSpillPlan, 4>> plans = getPlansForValue(type);
    if (!plans)
      return false;
    unsigned useCount = mlir::wave::regalloc::getLoopCarryUseCount(*loopCarry);
    wave::WaveAMDPressureReliefCost cost =
        getLoopCarrySpillCost(*loopCarry, *plans, useCount);
    LDSValueSlot valueSlot{init, *plans, cost, useCount};
    candidates.push_back(std::make_unique<LDSSpillCandidate>(
        group, *loopCarry, std::move(valueSlot), useCount, type.getWidth(),
        cost));
    return true;
  }

  SmallVector<Value> getGroupValues(IntervalGroup *group) const {
    return getMemorySpillGroupValues(group, inventory);
  }

  Value createImm(OpBuilder &builder, Location loc, int64_t value) const {
    return waveamdmachine::ImmOp::create(
        builder, loc, waveamdmachine::ImmType::get(builder.getContext()),
        static_cast<uint64_t>(value));
  }

  std::pair<Value, int64_t> materializeAddress(OpBuilder &builder, Location loc,
                                               const LDSSpillPlan &plan) const {
    MLIRContext *ctx = builder.getContext();
    Value workitem = findWorkitemId(builder);
    if (!workitem) {
      waveamdmachine::RegType workitemType = waveamdmachine::RegType::get(
          ctx, waveamdmachine::RegClass::VGPR, /*width=*/1,
          inventory.entryRegs.workitemIdXVGPR);
      workitem =
          waveamdmachine::VWorkitemIdXOp::create(builder, loc, workitemType)
              .getResult();
    }
    waveamdmachine::VLshlrevB32Op addr = waveamdmachine::VLshlrevB32Op::create(
        builder, loc,
        waveamdmachine::RegType::get(ctx, waveamdmachine::RegClass::VGPR,
                                     /*width=*/1, /*index=*/-1),
        workitem, createImm(builder, loc, llvm::Log2_32(plan.valueBytes)));
    addr->setAttr(kRegAllocTempAttr, builder.getUnitAttr());
    if (canFoldSlotBaseIntoDSOffset(plan.slotBase))
      return {addr.getResult(), static_cast<int64_t>(plan.slotBase)};

    waveamdmachine::VAddU32Op fullAddr = waveamdmachine::VAddU32Op::create(
        builder, loc,
        waveamdmachine::RegType::get(ctx, waveamdmachine::RegClass::VGPR,
                                     /*width=*/1, /*index=*/-1),
        addr.getResult(), createImm(builder, loc, plan.slotBase));
    fullAddr->setAttr(kRegAllocTempAttr, builder.getUnitAttr());
    return {fullAddr.getResult(), 0};
  }

  Value findWorkitemId(OpBuilder &builder) const {
    Block *block = builder.getInsertionBlock();
    if (!block)
      return {};
    Block::iterator stop = builder.getInsertionPoint();
    while (block) {
      if (Value workitem = findWorkitemIdBefore(block, stop))
        return workitem;
      Operation *parent = block->getParentOp();
      if (!parent)
        return {};
      block = parent->getBlock();
      if (!block)
        return {};
      stop = parent->getIterator();
    }
    return {};
  }

  Value findWorkitemIdBefore(Block *block, Block::iterator stop) const {
    for (auto it = block->begin(); it != stop; ++it) {
      Operation &op = *it;
      waveamdmachine::VWorkitemIdXOp workitem =
          dyn_cast<waveamdmachine::VWorkitemIdXOp>(&op);
      if (!workitem)
        continue;
      waveamdmachine::RegType type =
          cast<waveamdmachine::RegType>(workitem.getType());
      if (type.getIndex() == inventory.entryRegs.workitemIdXVGPR)
        return workitem.getResult();
    }
    return {};
  }

  Type getLoadType(Value value) const {
    waveamdmachine::RegType type =
        cast<waveamdmachine::RegType>(value.getType());
    if (type.getRegClass() != waveamdmachine::RegClass::AGPR)
      return value.getType();
    return waveamdmachine::RegType::get(value.getContext(),
                                        waveamdmachine::RegClass::VGPR,
                                        type.getWidth(), /*index=*/-1);
  }

  Value materializeStoreValue(Value value, OpBuilder &builder) const {
    waveamdmachine::RegType type =
        cast<waveamdmachine::RegType>(value.getType());
    if (type.getRegClass() != waveamdmachine::RegClass::AGPR)
      return value;
    waveamdmachine::VAccvgprReadB32TupleOp read =
        waveamdmachine::VAccvgprReadB32TupleOp::create(
            builder, value.getLoc(), getLoadType(value), value);
    read->setAttr(kRegAllocTempAttr, builder.getUnitAttr());
    return read.getResult();
  }

  LogicalResult replaceUseWithLoad(Value value, OpOperand *use,
                                   Value loaded) const {
    waveamdmachine::RegType type =
        cast<waveamdmachine::RegType>(value.getType());
    if (type.getRegClass() != waveamdmachine::RegClass::AGPR) {
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

  SmallVector<Type> getScalarRegTypes(Type tupleType) const {
    waveamdmachine::RegType regType = cast<waveamdmachine::RegType>(tupleType);
    Type laneType = waveamdmachine::RegType::get(
        tupleType.getContext(), regType.getRegClass(), /*width=*/1,
        /*index=*/-1);
    return SmallVector<Type>(regType.getWidth(), laneType);
  }

  SmallVector<Value> splitValue(Value value, OpBuilder &builder,
                                Location loc) const {
    SmallVector<Type> elementTypes = getScalarRegTypes(value.getType());
    waveamdmachine::TupleToElementsOp split =
        waveamdmachine::TupleToElementsOp::create(builder, loc, elementTypes,
                                                  value);
    split->setAttr(kRegAllocTempAttr, builder.getUnitAttr());
    return SmallVector<Value>(split.getElements().begin(),
                              split.getElements().end());
  }

  Value joinValue(Type type, ArrayRef<Value> elements, OpBuilder &builder,
                  Location loc) const {
    waveamdmachine::TupleFromElementsOp joined =
        waveamdmachine::TupleFromElementsOp::create(builder, loc, type,
                                                    elements);
    joined->setAttr(kRegAllocTempAttr, builder.getUnitAttr());
    return joined.getTuple();
  }

  Value joinTokens(Type tokenType, ArrayRef<Value> tokens, OpBuilder &builder,
                   Location loc) const {
    if (tokens.size() == 1)
      return tokens.front();
    waveamdmachine::TokenJoinOp join =
        waveamdmachine::TokenJoinOp::create(builder, loc, tokenType, tokens);
    join->setAttr(kRegAllocTempAttr, builder.getUnitAttr());
    return join.getResult();
  }

  Value storeScalarValue(Value value, Value token, LDSSpillPlan plan,
                         OpBuilder &builder, Location loc) const {
    Type tokenType = waveamdmachine::MemTokenType::get(builder.getContext());
    std::pair<Value, int64_t> addr = materializeAddress(builder, loc, plan);
    waveamdmachine::DsStoreB32Op store = waveamdmachine::DsStoreB32Op::create(
        builder, loc, tokenType, addr.first, value, token, addr.second);
    store->setAttr(kRegAllocTempAttr, builder.getUnitAttr());
    return store.getToken();
  }

  LDSLoadResult loadScalarValue(Type type, Value token, LDSSpillPlan plan,
                                OpBuilder &builder, Location loc) const {
    Type tokenType = waveamdmachine::MemTokenType::get(builder.getContext());
    std::pair<Value, int64_t> addr = materializeAddress(builder, loc, plan);
    waveamdmachine::DsLoadB32Op load = waveamdmachine::DsLoadB32Op::create(
        builder, loc, type, tokenType, addr.first, token, addr.second);
    load->setAttr(kRegAllocTempAttr, builder.getUnitAttr());
    return {load.getResult(), load.getToken()};
  }

  Value storeSpillValue(Value value, Value token, ArrayRef<LDSSpillPlan> plans,
                        OpBuilder &builder, Location loc) const {
    unsigned width = cast<waveamdmachine::RegType>(value.getType()).getWidth();
    assert(width == plans.size() && "LDS plans must match value width");
    if (width == 1)
      return storeScalarValue(value, token, plans.front(), builder, loc);

    Type tokenType = waveamdmachine::MemTokenType::get(builder.getContext());
    SmallVector<Value> elements = splitValue(value, builder, loc);
    SmallVector<Value> tokens;
    tokens.reserve(elements.size());
    for (auto [index, element] : llvm::enumerate(elements))
      tokens.push_back(
          storeScalarValue(element, token, plans[index], builder, loc));
    return joinTokens(tokenType, tokens, builder, loc);
  }

  LDSLoadResult loadSpillValue(Type type, Value token,
                               ArrayRef<LDSSpillPlan> plans, OpBuilder &builder,
                               Location loc) const {
    unsigned width = cast<waveamdmachine::RegType>(type).getWidth();
    assert(width == plans.size() && "LDS plans must match value width");
    if (width == 1)
      return loadScalarValue(type, token, plans.front(), builder, loc);

    Type tokenType = waveamdmachine::MemTokenType::get(builder.getContext());
    SmallVector<Type> elementTypes = getScalarRegTypes(type);
    SmallVector<Value> elements;
    SmallVector<Value> tokens;
    elements.reserve(elementTypes.size());
    tokens.reserve(elementTypes.size());
    for (auto [index, elementType] : llvm::enumerate(elementTypes)) {
      LDSLoadResult load =
          loadScalarValue(elementType, token, plans[index], builder, loc);
      elements.push_back(load.value);
      tokens.push_back(load.token);
    }
    return {joinValue(type, elements, builder, loc),
            joinTokens(tokenType, tokens, builder, loc)};
  }

  LogicalResult materializeValue(Value value, ArrayRef<LDSSpillPlan> plans,
                                 OpBuilder &builder) const {
    Operation *def = value.getDefiningOp();
    SmallVector<OpOperand *> uses;
    if (!hasSimpleUses(value, uses))
      return mlir::emitError(value.getLoc())
             << "waveamd-reg-alloc cannot materialize LDS spill for value";

    builder.setInsertionPointAfter(def);
    Value storeValue = materializeStoreValue(value, builder);
    Value storeToken =
        storeSpillValue(storeValue, Value{}, plans, builder, def->getLoc());

    for (OpOperand *use : uses) {
      if (use->get() != value)
        continue;
      Operation *user = use->getOwner();
      builder.setInsertionPoint(user);
      LDSLoadResult load = loadSpillValue(getLoadType(value), storeToken, plans,
                                          builder, user->getLoc());
      if (failed(replaceUseWithLoad(value, use, load.value)))
        return failure();
    }
    return success();
  }

  LDSLoadResult copyLoopInitValue(Value init, Value token,
                                  const LDSPressurePlan &spill,
                                  OpBuilder &builder, Location loc) const {
    if (isRematerializableMemorySpillInitTree(init)) {
      DenseMap<Value, Value> cache;
      FailureOr<Value> replacement =
          materializeMemorySpillInitTree(init, builder, cache);
      if (succeeded(replacement))
        return {*replacement, token};
    }
    return loadSpillValue(init.getType(), token, getPlanValueSlot(spill).plans,
                          builder, loc);
  }

  LogicalResult
  materializeLoopCarryPlans(ArrayRef<const LDSPressurePlan *> input,
                            OpBuilder &builder) const {
    auto getSlot = [](const LDSPressurePlan &spill) {
      return getPlanLoopCarrySlot(spill);
    };
    auto storeValue = [&](Value value, Value token,
                          const LDSPressurePlan &spill, OpBuilder &builder,
                          Location loc) {
      return storeSpillValue(value, token, getPlanValueSlot(spill).plans,
                             builder, loc);
    };
    auto loadValue = [&](Type type, Value token, const LDSPressurePlan &spill,
                         OpBuilder &builder, Location loc) {
      return loadSpillValue(type, token, getPlanValueSlot(spill).plans, builder,
                            loc);
    };
    auto copyInitValue = [&](Value init, Value token,
                             const LDSPressurePlan &spill, OpBuilder &builder,
                             Location loc) {
      return copyLoopInitValue(init, token, spill, builder, loc);
    };
    auto reserve = [&](const LDSPressurePlan &spill, OpBuilder &builder) {
      reserveSlots(getPlanValueSlot(spill).plans, builder);
    };
    return materializeMemorySpillLoopCarryPlans<LDSPressurePlan>(
        input, builder, getName(), getSlot, storeValue, loadValue,
        copyInitValue, reserve);
  }

  void reserveSlot(LDSSpillPlan plan, OpBuilder &builder) const {
    unsigned reserved = getUnsignedAttr(func, kLDSSpillBytesAttr).value_or(0);
    func->setAttr(kLDSSpillBytesAttr,
                  builder.getI64IntegerAttr(reserved + plan.slotBytes));
  }

  void reserveSlots(ArrayRef<LDSSpillPlan> plans, OpBuilder &builder) const {
    for (LDSSpillPlan plan : plans)
      reserveSlot(plan, builder);
  }

  mutable std::string planRejectReason;
  func::FuncOp func;
  ArrayRef<IntervalGroup *> groups;
  RegisterBudgets budgets;
  Inventory &inventory;
  IntervalGroup *request = nullptr;
  unsigned position = 0;
  mutable const PressureFailure *pressureFailure = nullptr;
  mutable bool sawLoopCarryReject = false;
};

static std::optional<unsigned> getUnsignedAttr(Operation *op, StringRef name) {
  IntegerAttr attr = op->getAttrOfType<IntegerAttr>(name);
  if (!attr)
    return std::nullopt;
  int64_t value = attr.getInt();
  if (value < 0 ||
      static_cast<uint64_t>(value) > std::numeric_limits<unsigned>::max())
    return std::nullopt;
  return static_cast<unsigned>(value);
}

static unsigned getLDSAttr(func::FuncOp func, StringRef machineName,
                           StringRef waveName) {
  if (std::optional<unsigned> value =
          getUnsignedAttr(func.getOperation(), machineName))
    return *value;
  if (std::optional<unsigned> value =
          getUnsignedAttr(func.getOperation(), waveName))
    return *value;
  return 0;
}

static FailureOr<std::unique_ptr<llvm::MCSubtargetInfo>>
createSubtargetInfo(Operation *op) {
  FailureOr<waveamdmachine::AMDGPUTarget> target =
      waveamdmachine::getAMDGPUTarget(op, "waveamd-reg-alloc LDS planning");
  if (failed(target))
    return failure();

  static llvm::once_flag initializeBackendOnce;
  llvm::call_once(initializeBackendOnce, []() {
    llvm::InitializeAllTargetInfos();
    llvm::InitializeAllTargetMCs();
  });

  llvm::Triple triple(target->triple);
  std::string error;
  const llvm::Target *llvmTarget =
      llvm::TargetRegistry::lookupTarget(triple, error);
  if (!llvmTarget)
    return op->emitError("failed to lookup AMDGPU target: ") << error;

  std::unique_ptr<llvm::MCSubtargetInfo> sti(
      llvmTarget->createMCSubtargetInfo(triple, target->chip, /*Features=*/""));
  if (!sti)
    return op->emitError("unsupported AMDGPU target: ")
           << target->triple << "--" << target->chip;
  return sti;
}

static std::optional<LDSTargetInfo> getLDSTargetInfo(func::FuncOp func) {
  FailureOr<std::unique_ptr<llvm::MCSubtargetInfo>> sti =
      createSubtargetInfo(func);
  FailureOr<unsigned> wavefrontSize = waveamdmachine::getAMDGPUWavefrontSize(
      func, "waveamd-reg-alloc LDS planning");
  if (failed(sti) || failed(wavefrontSize))
    return std::nullopt;

  LDSTargetInfo info;
  info.localMemorySize = llvm::AMDGPU::IsaInfo::getLocalMemorySize(**sti);
  info.addressableLocalMemorySize =
      llvm::AMDGPU::IsaInfo::getAddressableLocalMemorySize(**sti);
  info.wavefrontSize = *wavefrontSize;
  info.eusPerCU = llvm::AMDGPU::IsaInfo::getEUsPerCU(**sti);
  return info;
}

static void getExistingLDSBytes(func::FuncOp func, unsigned &fixedBytes,
                                unsigned &dynamicBytes,
                                unsigned reservedBytes) {
  Operation *op = func.getOperation();
  dynamicBytes = getLDSAttr(func, "waveamdmachine.dynamic_lds_size",
                            "wave.dynamic_lds_size");
  if (std::optional<unsigned> totalBytes =
          getUnsignedAttr(op, "waveamdmachine.lds_size")) {
    unsigned compilerBytes = dynamicBytes + reservedBytes;
    fixedBytes = *totalBytes >= compilerBytes ? *totalBytes - compilerBytes : 0;
    return;
  }
  fixedBytes = getUnsignedAttr(op, "wave.lds_size").value_or(0);
}

static std::optional<WorkgroupShape>
getWorkgroupShape(Operation *op, StringRef name, bool &invalid) {
  DenseI32ArrayAttr attr = op->getAttrOfType<DenseI32ArrayAttr>(name);
  if (!attr)
    return std::nullopt;
  if (attr.empty() || attr.size() > 3) {
    invalid = true;
    return std::nullopt;
  }

  WorkgroupShape shape;
  uint64_t product = 1;
  for (auto indexed : llvm::enumerate(attr.asArrayRef())) {
    int32_t dim = indexed.value();
    if (dim <= 0) {
      invalid = true;
      return std::nullopt;
    }
    unsigned axis = indexed.index();
    shape.dims[axis] = static_cast<uint32_t>(dim);
    product *= shape.dims[axis];
    if (product > std::numeric_limits<unsigned>::max()) {
      invalid = true;
      return std::nullopt;
    }
  }
  shape.flatSize = static_cast<unsigned>(product);
  return shape;
}

static std::optional<WorkgroupShape> getWorkgroupShape(func::FuncOp func,
                                                       bool &invalid) {
  Operation *op = func.getOperation();
  if (std::optional<WorkgroupShape> shape =
          getWorkgroupShape(op, "wave.workgroup_size", invalid))
    return shape;
  return getWorkgroupShape(op, "gpu.known_block_size", invalid);
}

static LDSSpillPlan reject(LDSSpillPlanStatus status, unsigned fixedBytes,
                           unsigned dynamicBytes, unsigned reservedBytes,
                           unsigned valueBytes) {
  LDSSpillPlan plan;
  plan.status = status;
  plan.existingFixedBytes = fixedBytes;
  plan.existingDynamicBytes = dynamicBytes;
  plan.reservedSpillBytes = reservedBytes;
  plan.valueBytes = valueBytes;
  return plan;
}

static std::optional<LDSSpillPlan>
getBasicReject(func::FuncOp func, unsigned fixedBytes, unsigned dynamicBytes,
               unsigned reservedBytes, unsigned valueBytes) {
  if (!func->hasAttr(wave::WaveDialect::getKernelAttrName()))
    return reject(LDSSpillPlanStatus::NotKernel, fixedBytes, dynamicBytes,
                  reservedBytes, valueBytes);
  if (valueBytes == 0)
    return reject(LDSSpillPlanStatus::InvalidValueBytes, fixedBytes,
                  dynamicBytes, reservedBytes, valueBytes);
  return std::nullopt;
}

static bool hasUsableTargetInfo(const std::optional<LDSTargetInfo> &info) {
  return info && info->localMemorySize != 0 && info->wavefrontSize != 0 &&
         info->eusPerCU != 0;
}

static std::optional<LDSSpillPlan>
getWorkgroupReject(func::FuncOp func, const LDSTargetInfo &targetInfo,
                   unsigned fixedBytes, unsigned dynamicBytes,
                   unsigned reservedBytes, unsigned valueBytes,
                   unsigned &wavesPerWorkgroup) {
  bool invalidShape = false;
  std::optional<WorkgroupShape> workgroupShape =
      getWorkgroupShape(func, invalidShape);
  if (invalidShape)
    return reject(LDSSpillPlanStatus::InvalidWorkgroupShape, fixedBytes,
                  dynamicBytes, reservedBytes, valueBytes);
  if (!workgroupShape)
    return reject(LDSSpillPlanStatus::MissingWorkgroupShape, fixedBytes,
                  dynamicBytes, reservedBytes, valueBytes);

  wavesPerWorkgroup =
      llvm::divideCeil(workgroupShape->flatSize, targetInfo.wavefrontSize);
  std::optional<unsigned> explicitWaves =
      getUnsignedAttr(func.getOperation(), "wave.waves_per_workgroup");
  if (explicitWaves &&
      (*explicitWaves == 0 || *explicitWaves != wavesPerWorkgroup))
    return reject(LDSSpillPlanStatus::InvalidWorkgroupShape, fixedBytes,
                  dynamicBytes, reservedBytes, valueBytes);
  if (!workgroupShape->isXLinear())
    return reject(LDSSpillPlanStatus::UnsupportedWorkgroupShape, fixedBytes,
                  dynamicBytes, reservedBytes, valueBytes);
  return std::nullopt;
}

static uint64_t getLDSLimitBytes(RegisterBudgets budgets,
                                 const LDSTargetInfo &targetInfo,
                                 unsigned wavesPerWorkgroup) {
  if (budgets.targetWaves == 0) {
    if (targetInfo.addressableLocalMemorySize == 0)
      return targetInfo.localMemorySize;
    return std::min<uint64_t>(targetInfo.localMemorySize,
                              targetInfo.addressableLocalMemorySize);
  }
  uint64_t workgroupsPerCU = std::max<uint64_t>(
      1, (static_cast<uint64_t>(budgets.targetWaves) * targetInfo.eusPerCU) /
             wavesPerWorkgroup);
  uint64_t limitBytes = targetInfo.localMemorySize / workgroupsPerCU;
  if (targetInfo.addressableLocalMemorySize == 0)
    return limitBytes;
  return std::min<uint64_t>(limitBytes, targetInfo.addressableLocalMemorySize);
}

static LDSSpillPlan
buildCapacityPlan(LDSSpillPlanStatus status, unsigned fixedBytes,
                  unsigned dynamicBytes, unsigned reservedBytes,
                  unsigned valueBytes, const LDSTargetInfo &targetInfo,
                  unsigned wavesPerWorkgroup, uint64_t limitBytes,
                  uint64_t usedBytes) {
  uint64_t waveStride =
      static_cast<uint64_t>(targetInfo.wavefrontSize) * valueBytes;
  LDSSpillPlan plan;
  plan.status = status;
  plan.existingFixedBytes = fixedBytes;
  plan.existingDynamicBytes = dynamicBytes;
  plan.reservedSpillBytes = reservedBytes;
  plan.limitBytes = static_cast<unsigned>(limitBytes);
  plan.availableBytes = static_cast<unsigned>(limitBytes - usedBytes);
  plan.slotBase = fixedBytes + reservedBytes;
  plan.slotBytes = static_cast<unsigned>(waveStride * wavesPerWorkgroup);
  plan.waveStride = static_cast<unsigned>(waveStride);
  plan.valueBytes = valueBytes;
  plan.wavesPerWorkgroup = wavesPerWorkgroup;
  plan.wavefrontSize = targetInfo.wavefrontSize;
  return plan;
}

static LDSSpillPlan buildLDSSpillPlan(func::FuncOp func,
                                      RegisterBudgets budgets,
                                      unsigned valueBytes,
                                      unsigned reservedSpillBytes,
                                      unsigned fixedLDS, unsigned dynamicLDS) {
  if (std::optional<LDSSpillPlan> plan = getBasicReject(
          func, fixedLDS, dynamicLDS, reservedSpillBytes, valueBytes))
    return *plan;

  std::optional<LDSTargetInfo> targetInfo = getLDSTargetInfo(func);
  if (!hasUsableTargetInfo(targetInfo))
    return reject(LDSSpillPlanStatus::InsufficientLDS, fixedLDS, dynamicLDS,
                  reservedSpillBytes, valueBytes);

  unsigned wavesPerWorkgroup = 0;
  if (std::optional<LDSSpillPlan> plan =
          getWorkgroupReject(func, *targetInfo, fixedLDS, dynamicLDS,
                             reservedSpillBytes, valueBytes, wavesPerWorkgroup))
    return *plan;

  uint64_t limitBytes =
      getLDSLimitBytes(budgets, *targetInfo, wavesPerWorkgroup);
  uint64_t usedBytes =
      static_cast<uint64_t>(fixedLDS) + dynamicLDS + reservedSpillBytes;
  uint64_t waveStride =
      static_cast<uint64_t>(targetInfo->wavefrontSize) * valueBytes;
  uint64_t slotBytes = waveStride * wavesPerWorkgroup;
  if (usedBytes + slotBytes > limitBytes)
    return reject(LDSSpillPlanStatus::InsufficientLDS, fixedLDS, dynamicLDS,
                  reservedSpillBytes, valueBytes);

  return buildCapacityPlan(LDSSpillPlanStatus::Available, fixedLDS, dynamicLDS,
                           reservedSpillBytes, valueBytes, *targetInfo,
                           wavesPerWorkgroup, limitBytes, usedBytes);
}

} // namespace

StringRef
mlir::wave::regalloc::getLDSSpillPlanStatusName(LDSSpillPlanStatus status) {
  static constexpr std::array<llvm::StringLiteral, 9> names = {
      "available",
      "not_kernel",
      "missing_workgroup_shape",
      "invalid_workgroup_shape",
      "unsupported_workgroup_shape",
      "unsupported_slot_base",
      "unsupported_waves_per_workgroup",
      "invalid_value_bytes",
      "insufficient_lds",
  };
  unsigned index = static_cast<unsigned>(status);
  if (index < names.size())
    return names[index];
  llvm_unreachable("unknown LDS spill plan status");
}

LDSSpillPlan mlir::wave::regalloc::planLDSSpillSlot(
    func::FuncOp func, RegisterBudgets budgets, unsigned valueBytes,
    unsigned reservedSpillBytes) {
  unsigned fixedLDS = 0;
  unsigned dynamicLDS = 0;
  getExistingLDSBytes(func, fixedLDS, dynamicLDS, reservedSpillBytes);
  return buildLDSSpillPlan(func, budgets, valueBytes, reservedSpillBytes,
                           fixedLDS, dynamicLDS);
}

std::optional<unsigned> LDSSpillProvider::getUnsignedAttr(Operation *op,
                                                          StringRef name) {
  return ::getUnsignedAttr(op, name);
}

std::unique_ptr<wave::WaveAMDPressureReliefProvider>
mlir::wave::regalloc::createLDSSpillProvider(
    func::FuncOp func, ArrayRef<IntervalGroup *> groups, IntervalGroup *request,
    unsigned position, RegisterBudgets budgets, Inventory &inventory) {
  return std::make_unique<LDSSpillProvider>(func, groups, request, position,
                                            budgets, inventory);
}
