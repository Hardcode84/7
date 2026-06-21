//===- WaveAMDRegAllocScratch.cpp - Scratch spill planning -----*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "WaveAMDRegAllocInternal.h"

#include "mlir/Dialect/Wave/IR/Wave.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachineTarget.h"
#include "mlir/IR/Builders.h"
#include "mlir/IR/BuiltinAttributes.h"
#include "mlir/IR/IRMapping.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/TargetParser/TargetParser.h"

#include <limits>

using namespace mlir;
using namespace mlir::wave::regalloc;

namespace {

static constexpr llvm::StringLiteral kWavePrivateSegmentFixedSizeAttr =
    "wave.private_segment_fixed_size";
static constexpr llvm::StringLiteral kUsesFlatScratchAttr =
    "waveamdmachine.uses_flat_scratch";
static constexpr unsigned kScratchImmediateOffsetMax = 4095;

static unsigned alignDown(unsigned value, unsigned granule) {
  return (value / granule) * granule;
}

static unsigned getOverage(unsigned liveDwords, unsigned limit) {
  if (liveDwords <= limit)
    return 0;
  return liveDwords - limit;
}

static std::optional<unsigned> getUnsignedAttr(Operation *op, StringRef name);
static unsigned getPrivateSegmentBytes(func::FuncOp func,
                                       unsigned reservedBytes);
static ScratchSpillPlan buildScratchSpillPlan(func::FuncOp func,
                                              unsigned valueBytes,
                                              unsigned reservedSpillBytes,
                                              unsigned existingBytes);

static bool isScratchSpillRegClass(waveamdmachine::RegClass regClass) {
  return regClass == waveamdmachine::RegClass::VGPR ||
         regClass == waveamdmachine::RegClass::AGPR;
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

static bool isScratchSpillCandidateGroup(IntervalGroup *group,
                                         unsigned position) {
  if (!group || group->plannedPressureRelief || group->reserved ||
      isFixedRegisterGroup(group))
    return false;
  if (!isScratchSpillRegClass(group->storageClass))
    return false;
  if (group->storageClass == waveamdmachine::RegClass::AGPR &&
      !isTempGroup(group))
    return false;
  if (!llvm::any_of(group->intervals,
                    [&](Interval *lane) { return isLiveAt(lane, position); }))
    return false;
  return true;
}

static bool isScratchSpillEligibleGroup(IntervalGroup *group,
                                        unsigned position) {
  if (!isScratchSpillCandidateGroup(group, position))
    return false;
  if (!group->nonPromotable &&
      llvm::all_of(group->intervals,
                   [](Interval *lane) { return !lane->nonPromotable; }))
    return true;
  return isTempGroup(group);
}

struct ScratchLoadResult {
  Value value;
  Value token;
};

struct LoopCarrySlot {
  waveamdmachine::UniformLoopOp loop;
  unsigned index = 0;
};

struct ScratchValueSlot {
  Value value;
  ScratchSpillPlan plan;
  wave::WaveAMDPressureReliefCost cost;
  unsigned useCount = 0;
};

static unsigned getTotalUseCount(ArrayRef<ScratchValueSlot> slots) {
  unsigned total = 0;
  for (const ScratchValueSlot &slot : slots)
    total += slot.useCount;
  return total;
}

static unsigned getTotalSlotBytes(ArrayRef<ScratchValueSlot> slots) {
  unsigned total = 0;
  for (const ScratchValueSlot &slot : slots)
    total += slot.plan.slotBytes;
  return total;
}

static wave::WaveAMDPressureReliefCost
getTotalCost(ArrayRef<ScratchValueSlot> slots) {
  wave::WaveAMDPressureReliefCost total;
  for (const ScratchValueSlot &slot : slots) {
    total.materializationOps += slot.cost.materializationOps;
    total.loopWeightedOps += slot.cost.loopWeightedOps;
    total.latencyPenalty += slot.cost.latencyPenalty;
    total.instabilityPenalty += slot.cost.instabilityPenalty;
  }
  return total;
}

class ScratchPressurePlan : public wave::WaveAMDPressureReliefPlan {
public:
  StringRef getProviderName() const override { return "scratch-spill"; }

  virtual IntervalGroup *getGroup() const = 0;
  virtual ScratchSpillPlan getPlan() const = 0;
  virtual unsigned getUseCount() const = 0;
  virtual Value getValue() const { return {}; }
  virtual ArrayRef<ScratchValueSlot> getValueSlots() const { return {}; }
  virtual unsigned getReservedBytes() const { return getPlan().slotBytes; }
  virtual std::optional<LoopCarrySlot> getLoopCarry() const {
    return std::nullopt;
  }
};

class ScratchValuePressurePlan final : public ScratchPressurePlan {
public:
  ScratchValuePressurePlan(IntervalGroup *group, Value value,
                           ScratchSpillPlan plan, unsigned useCount,
                           unsigned reliefDwords)
      : group(group), reliefDwords(reliefDwords) {
    valueSlots.push_back({value, plan, {}, useCount});
  }

  ScratchValuePressurePlan(IntervalGroup *group,
                           ArrayRef<ScratchValueSlot> valueSlots,
                           unsigned reliefDwords)
      : valueSlots(valueSlots), group(group), reliefDwords(reliefDwords) {}

  unsigned getReliefDwords() const override { return reliefDwords; }
  wave::WaveAMDPressureReliefProviderKind getProviderKind() const override {
    return wave::WaveAMDPressureReliefProviderKind::ScratchSpill;
  }
  IntervalGroup *getGroup() const override { return group; }
  ScratchSpillPlan getPlan() const override {
    assert(!valueSlots.empty() && "scratch value plan needs a slot");
    return valueSlots.front().plan;
  }
  unsigned getUseCount() const override { return getTotalUseCount(valueSlots); }
  Value getValue() const override {
    return valueSlots.size() == 1 ? valueSlots.front().value : Value{};
  }
  ArrayRef<ScratchValueSlot> getValueSlots() const override {
    return valueSlots;
  }
  unsigned getReservedBytes() const override {
    return getTotalSlotBytes(valueSlots);
  }

private:
  SmallVector<ScratchValueSlot, 4> valueSlots;
  IntervalGroup *group = nullptr;
  unsigned reliefDwords = 0;
};

class ScratchLoopCarryPressurePlan final : public ScratchPressurePlan {
public:
  ScratchLoopCarryPressurePlan(IntervalGroup *group, LoopCarrySlot slot,
                               ScratchSpillPlan plan, unsigned useCount,
                               unsigned reliefDwords)
      : plan(plan), slot(slot), group(group), useCount(useCount),
        reliefDwords(reliefDwords) {}

  unsigned getReliefDwords() const override { return reliefDwords; }
  wave::WaveAMDPressureReliefProviderKind getProviderKind() const override {
    return wave::WaveAMDPressureReliefProviderKind::ScratchSpill;
  }
  IntervalGroup *getGroup() const override { return group; }
  ScratchSpillPlan getPlan() const override { return plan; }
  unsigned getUseCount() const override { return useCount; }
  std::optional<LoopCarrySlot> getLoopCarry() const override { return slot; }

private:
  ScratchSpillPlan plan;
  LoopCarrySlot slot;
  IntervalGroup *group = nullptr;
  unsigned useCount = 0;
  unsigned reliefDwords = 0;
};

static LoopCarrySlot getPlanLoopCarrySlot(const ScratchPressurePlan &spill) {
  std::optional<LoopCarrySlot> slot = spill.getLoopCarry();
  assert(slot && "expected loop-carry scratch spill");
  return *slot;
}

class ScratchSpillCandidate final
    : public wave::WaveAMDPressureReliefCandidate {
public:
  ScratchSpillCandidate(IntervalGroup *group, Value value,
                        ScratchSpillPlan plan, unsigned useCount,
                        unsigned pressureRelief,
                        wave::WaveAMDPressureReliefCost cost,
                        StringRef rejectReason = StringRef())
      : rejectReason(rejectReason.str()), cost(cost), group(group),
        pressureRelief(pressureRelief) {
    valueSlots.push_back({value, plan, cost, useCount});
  }

  ScratchSpillCandidate(IntervalGroup *group,
                        ArrayRef<ScratchValueSlot> valueSlots,
                        unsigned pressureRelief,
                        wave::WaveAMDPressureReliefCost cost)
      : valueSlots(valueSlots), cost(cost), group(group),
        pressureRelief(pressureRelief) {}

  ScratchSpillCandidate(IntervalGroup *group, LoopCarrySlot slot,
                        ScratchSpillPlan plan, unsigned useCount,
                        unsigned pressureRelief,
                        wave::WaveAMDPressureReliefCost cost)
      : cost(cost), group(group), loopCarry(slot), useCount(useCount),
        pressureRelief(pressureRelief) {
    valueSlots.push_back({{}, plan, cost, useCount});
  }

  StringRef getProviderName() const override { return "scratch-spill"; }

  wave::WaveAMDPressureReliefCost getCost() const override { return cost; }

  unsigned getReliefDwords() const override { return pressureRelief; }

  bool reducesPressureFailure(
      const wave::WaveAMDPressureFailure &failure) const override {
    if (!failure.combinedVGPRAGPR)
      return pressureRelief != 0;
    if (!group || pressureRelief == 0)
      return false;

    unsigned oldOverage = getOverage(failure.liveDwords, failure.limit);
    if (group->storageClass == waveamdmachine::RegClass::VGPR) {
      if (pressureRelief > failure.liveDwords)
        return false;
      return getOverage(failure.liveDwords - pressureRelief, failure.limit) <
             oldOverage;
    }
    if (group->storageClass != waveamdmachine::RegClass::AGPR ||
        pressureRelief > failure.combinedAGPRLiveDwords)
      return false;
    unsigned newAGPRLive = failure.combinedAGPRLiveDwords - pressureRelief;
    unsigned newVGPRLimit = 0;
    if (newAGPRLive < failure.combinedVGPRFamilyLimit)
      newVGPRLimit =
          alignDown(failure.combinedVGPRFamilyLimit - newAGPRLive, 4);
    return getOverage(failure.liveDwords, newVGPRLimit) < oldOverage;
  }

  std::optional<StringRef> getRejectReason() const override {
    if (rejectReason.empty())
      return std::nullopt;
    return StringRef(rejectReason);
  }

  IntervalGroup *getGroup() const { return group; }
  std::optional<LoopCarrySlot> getLoopCarry() const { return loopCarry; }
  ScratchSpillPlan getPlan() const {
    assert(!valueSlots.empty() && "scratch candidate needs a slot");
    return valueSlots.front().plan;
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
  std::unique_ptr<wave::WaveAMDPressureReliefPlan> getPlannedSpill() const {
    if (loopCarry)
      return std::make_unique<ScratchLoopCarryPressurePlan>(
          group, *loopCarry, getPlan(), useCount, pressureRelief);
    return std::make_unique<ScratchValuePressurePlan>(group, valueSlots,
                                                      pressureRelief);
  }

protected:
  void printExtra(llvm::raw_ostream &os) const override {
    ScratchSpillPlan firstPlan = getPlan();
    os << ", slot_base=" << firstPlan.slotBase
       << ", slot_bytes=" << getTotalSlotBytes(valueSlots)
       << ", uses=" << getUseCount();
  }

  void setExtraDiagnosticAttrs(Builder &builder,
                               NamedAttrList &attrs) const override {
    ScratchSpillPlan firstPlan = getPlan();
    attrs.set("slot_base", builder.getI64IntegerAttr(firstPlan.slotBase));
    attrs.set("slot_bytes",
              builder.getI64IntegerAttr(getTotalSlotBytes(valueSlots)));
    attrs.set("pressure_relief", builder.getI64IntegerAttr(pressureRelief));
    attrs.set("uses", builder.getI64IntegerAttr(getUseCount()));
  }

private:
  std::string rejectReason;
  SmallVector<ScratchValueSlot, 4> valueSlots;
  wave::WaveAMDPressureReliefCost cost;
  IntervalGroup *group = nullptr;
  std::optional<LoopCarrySlot> loopCarry;
  unsigned useCount = 0;
  unsigned pressureRelief = 0;
};

class ScratchSpillProvider final : public wave::WaveAMDPressureReliefProvider {
public:
  ScratchSpillProvider(func::FuncOp func, ArrayRef<IntervalGroup *> groups,
                       IntervalGroup *request, unsigned position,
                       Inventory &inventory)
      : groups(groups), inventory(inventory), func(func), request(request),
        position(position) {}

  StringRef getName() const override { return "scratch-spill"; }
  wave::WaveAMDPressureReliefProviderKind getKind() const override {
    return wave::WaveAMDPressureReliefProviderKind::ScratchSpill;
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
    const ScratchSpillCandidate &spill =
        static_cast<const ScratchSpillCandidate &>(candidate);
    return spill.getPlannedSpill();
  }

  void applyPlan(const wave::WaveAMDPressureReliefPlan &plan) const override {
    const ScratchPressurePlan &spill =
        static_cast<const ScratchPressurePlan &>(plan);
    if (spill.getGroup()) {
      spill.getGroup()->plannedPressureRelief = true;
      spill.getGroup()->assignedBase.reset();
    }
    addPlannedProviderBytes(inventory, getName(), spill.getReservedBytes());
  }

  LogicalResult materializePlan(const wave::WaveAMDPressureReliefPlan &plan,
                                OpBuilder &builder) const override {
    const ScratchPressurePlan &spill =
        static_cast<const ScratchPressurePlan &>(plan);
    if (spill.getLoopCarry()) {
      SmallVector<const ScratchPressurePlan *, 1> spills{&spill};
      return materializeLoopCarryPlans(spills, builder);
    }
    assert(!spill.getValueSlots().empty() && "expected scratch value spill");
    for (const ScratchValueSlot &slot : spill.getValueSlots())
      if (failed(materializeValue(slot.value, slot.plan, builder)))
        return failure();
    for (const ScratchValueSlot &slot : spill.getValueSlots())
      reserveSlot(slot.plan, builder);
    return success();
  }

  LogicalResult
  materializePlans(ArrayRef<const wave::WaveAMDPressureReliefPlan *> plans,
                   OpBuilder &builder) const override {
    SmallVector<SmallVector<const ScratchPressurePlan *, 2>, 8> loopCarryGroups;
    for (const wave::WaveAMDPressureReliefPlan *plan : plans) {
      const ScratchPressurePlan &spill =
          static_cast<const ScratchPressurePlan &>(*plan);
      std::optional<LoopCarrySlot> slot = spill.getLoopCarry();
      if (!slot) {
        if (failed(materializePlan(*plan, builder)))
          return failure();
        continue;
      }
      waveamdmachine::UniformLoopOp spillLoop = slot->loop;
      Operation *loop = spillLoop.getOperation();
      auto it = llvm::find_if(loopCarryGroups, [&](const auto &group) {
        LoopCarrySlot groupSlot = getPlanLoopCarrySlot(*group.front());
        waveamdmachine::UniformLoopOp groupLoop = groupSlot.loop;
        return groupLoop.getOperation() == loop;
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
    for (ArrayRef<const ScratchPressurePlan *> group : loopCarryGroups)
      if (failed(materializeLoopCarryPlans(group, builder)))
        return failure();
    return success();
  }

  bool isBetterCandidate(
      const wave::WaveAMDPressureReliefCandidate &lhs,
      const wave::WaveAMDPressureReliefCandidate &rhs) const override {
    if (lhs.isLegal() != rhs.isLegal())
      return lhs.isLegal();
    const ScratchSpillCandidate &lhsSpill =
        static_cast<const ScratchSpillCandidate &>(lhs);
    const ScratchSpillCandidate &rhsSpill =
        static_cast<const ScratchSpillCandidate &>(rhs);
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
  void setPlanRejectReason(ScratchSpillPlanStatus status) const {
    if (!planRejectReason.empty())
      return;
    planRejectReason = "scratch_spill_";
    planRejectReason += getScratchSpillPlanStatusName(status);
  }

  static bool isEligibleGroup(IntervalGroup *group, unsigned position) {
    return isScratchSpillEligibleGroup(group, position);
  }

  static bool isCandidateGroup(IntervalGroup *group, unsigned position) {
    return isScratchSpillCandidateGroup(group, position);
  }

  static unsigned getLoopDepth(Operation *op) {
    unsigned depth = 0;
    for (Operation *cur = op; cur; cur = cur->getParentOp())
      if (isa<waveamdmachine::UniformLoopOp>(cur))
        ++depth;
    return depth;
  }

  static unsigned getScratchMemoryOps(ScratchSpillPlan plan, unsigned width) {
    if (width > 1 && !tupleFitsImmediate(plan.slotBase, width))
      return width;
    return 1;
  }

  static unsigned getScratchMaterializationOps(ScratchSpillPlan plan,
                                               unsigned width) {
    if (width > 1 && !tupleFitsImmediate(plan.slotBase, width))
      return width + 2;
    return 1;
  }

  wave::WaveAMDPressureReliefCost
  getValueSpillCost(Value value, ScratchSpillPlan plan,
                    ArrayRef<OpOperand *> uses) const {
    unsigned width = cast<waveamdmachine::RegType>(value.getType()).getWidth();
    unsigned opCount = getScratchMaterializationOps(plan, width);
    unsigned memoryOps = getScratchMemoryOps(plan, width);
    wave::WaveAMDPressureReliefCost cost;
    cost.materializationOps = static_cast<int64_t>(opCount) * (1 + uses.size());
    cost.loopWeightedOps =
        static_cast<int64_t>(opCount) * getLoopDepth(value.getDefiningOp());
    for (OpOperand *use : uses)
      cost.loopWeightedOps +=
          static_cast<int64_t>(opCount) * getLoopDepth(use->getOwner());
    cost.latencyPenalty = static_cast<int64_t>(memoryOps) * uses.size() * 8;
    return cost;
  }

  static wave::WaveAMDPressureReliefCost
  getLoopCarrySpillCost(LoopCarrySlot slot, ScratchSpillPlan plan,
                        unsigned width, unsigned useCount) {
    unsigned opCount = getScratchMaterializationOps(plan, width);
    unsigned memoryOps = getScratchMemoryOps(plan, width);
    unsigned loopDepth = getLoopDepth(slot.loop.getOperation());
    wave::WaveAMDPressureReliefCost cost;
    cost.materializationOps = static_cast<int64_t>(opCount) * (1 + useCount);
    cost.loopWeightedOps = static_cast<int64_t>(opCount) * useCount * loopDepth;
    cost.latencyPenalty = static_cast<int64_t>(memoryOps) * useCount * 8;
    return cost;
  }

  static Operation *getAncestorInBlock(Operation *op, Block *block) {
    for (Operation *cur = op; cur; cur = cur->getParentOp())
      if (cur->getBlock() == block)
        return cur;
    return nullptr;
  }

  static bool useIsDominatedByDef(Operation *def, Operation *user) {
    if (user->getBlock() == def->getBlock())
      return true;
    Operation *ancestor = getAncestorInBlock(user, def->getBlock());
    return ancestor && def->isBeforeInBlock(ancestor);
  }

  bool hasSimpleVGPRUses(Value value,
                         SmallVectorImpl<OpOperand *> &uses) const {
    Operation *def = value.getDefiningOp();
    if (!def || isMemoryIssuerOp(def))
      return false;
    for (OpOperand &use : value.getUses()) {
      if (isRegAllocTempOp(use.getOwner()))
        continue;
      if (isLoopCarryUseOp(use.getOwner())) {
        sawLoopCarryReject = true;
        return false;
      }
      if (!useIsDominatedByDef(def, use.getOwner()))
        return false;
      uses.push_back(&use);
    }
    return !uses.empty();
  }

  bool hasSimpleAGPRUses(Value value,
                         SmallVectorImpl<OpOperand *> &uses) const {
    Operation *def = value.getDefiningOp();
    if (!def || isMemoryIssuerOp(def))
      return false;
    for (OpOperand &use : value.getUses()) {
      if (!useIsDominatedByDef(def, use.getOwner()))
        return false;
      if (isa<waveamdmachine::VAccvgprReadB32TupleOp>(use.getOwner())) {
        uses.push_back(&use);
        continue;
      }
      if (isRegAllocTempOp(use.getOwner()))
        continue;
      return false;
    }
    return !uses.empty();
  }

  bool hasSimpleUses(Value value, SmallVectorImpl<OpOperand *> &uses) const {
    waveamdmachine::RegType type =
        cast<waveamdmachine::RegType>(value.getType());
    if (type.getRegClass() == waveamdmachine::RegClass::AGPR)
      return hasSimpleAGPRUses(value, uses);
    return hasSimpleVGPRUses(value, uses);
  }

  bool isValueLiveAt(Value value, ArrayRef<OpOperand *> uses) const {
    Operation *def = value.getDefiningOp();
    if (!def)
      return false;
    unsigned start = inventory.positions.lookup(def);
    if (start >= position)
      return false;
    unsigned end = start;
    for (OpOperand *use : uses)
      end = std::max(end, inventory.positions.lookup(use->getOwner()));
    return position <= end;
  }

  bool valueCoversWholeGroup(IntervalGroup *group, Value value) const {
    auto type = dyn_cast<waveamdmachine::RegType>(value.getType());
    if (!type ||
        static_cast<unsigned>(type.getWidth()) != group->intervals.size())
      return false;
    Interval *first = inventory.intervalFor.lookup(value);
    return first && first->group == group && first == group->intervals.front();
  }

  ScratchSpillPlan getPlanForBytes(unsigned valueBytes,
                                   unsigned extraReservedBytes = 0) const {
    unsigned committedBytes =
        getUnsignedAttr(func, kScratchSpillBytesAttr).value_or(0);
    unsigned existingBytes = getPrivateSegmentBytes(func, committedBytes);
    unsigned reservedBytes = committedBytes +
                             getPlannedProviderBytes(inventory, getName()) +
                             extraReservedBytes;
    return buildScratchSpillPlan(func, valueBytes, reservedBytes,
                                 existingBytes);
  }

  ScratchSpillPlan getPlanForValue(waveamdmachine::RegType type) const {
    return getPlanForBytes(type.getWidth() * 4);
  }

  bool isCombinedPressure() const {
    return pressureFailure && pressureFailure->combinedVGPRAGPR;
  }

  bool hasUseAtPressure(ArrayRef<OpOperand *> uses) const {
    for (OpOperand *use : uses)
      if (inventory.positions.lookup(use->getOwner()) ==
          pressureFailure->position)
        return true;
    return false;
  }

  std::optional<unsigned> getPressureRelief(Value value, unsigned width,
                                            ArrayRef<OpOperand *> uses) const {
    if (!isCombinedPressure())
      return width;
    if (isCheapVGPRExpr(value.getDefiningOp()))
      return 0;
    if (hasUseAtPressure(uses))
      return 0;
    return width;
  }

  void
  collectValue(IntervalGroup *group, Value value,
               wave::WaveAMDPressureReliefCandidateList &candidates) const {
    waveamdmachine::RegType type =
        cast<waveamdmachine::RegType>(value.getType());
    if (!isScratchSpillRegClass(type.getRegClass()) || type.getWidth() == 0 ||
        !valueCoversWholeGroup(group, value))
      return;
    SmallVector<OpOperand *> uses;
    if (!hasSimpleUses(value, uses) || !isValueLiveAt(value, uses))
      return;
    ScratchSpillPlan plan = getPlanForValue(type);
    if (plan.status != ScratchSpillPlanStatus::Available) {
      setPlanRejectReason(plan.status);
      return;
    }
    std::optional<unsigned> pressureRelief =
        getPressureRelief(value, type.getWidth(), uses);
    if (!pressureRelief || *pressureRelief == 0)
      return;
    candidates.push_back(std::make_unique<ScratchSpillCandidate>(
        group, value, plan, uses.size(), *pressureRelief,
        getValueSpillCost(value, plan, uses)));
  }

  unsigned getLiveLaneCount(IntervalGroup *group) const {
    unsigned count = 0;
    for (Interval *lane : group->intervals)
      if (isLiveAt(lane, position))
        ++count;
    return count;
  }

  bool liveLanesStartBeforePressure(IntervalGroup *group) const {
    for (Interval *lane : group->intervals)
      if (isLiveAt(lane, position) && lane->start >= position)
        return false;
    return true;
  }

  FailureOr<ScratchValueSlot>
  getGroupValueSlot(Value value, unsigned extraReservedBytes) const {
    auto type = dyn_cast<waveamdmachine::RegType>(value.getType());
    if (!type || !isScratchSpillRegClass(type.getRegClass()) ||
        type.getWidth() == 0)
      return failure();
    if (isCombinedPressure() && isCheapVGPRExpr(value.getDefiningOp()))
      return failure();
    SmallVector<OpOperand *> uses;
    if (!hasSimpleUses(value, uses) || !isValueLiveAt(value, uses))
      return failure();
    ScratchSpillPlan plan =
        getPlanForBytes(type.getWidth() * 4, extraReservedBytes);
    if (plan.status != ScratchSpillPlanStatus::Available) {
      setPlanRejectReason(plan.status);
      return failure();
    }
    return ScratchValueSlot{value, plan, getValueSpillCost(value, plan, uses),
                            static_cast<unsigned>(uses.size())};
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

    SmallVector<ScratchValueSlot, 8> slots;
    unsigned extraReservedBytes = 0;
    for (Value value : getGroupValues(group)) {
      FailureOr<ScratchValueSlot> slot =
          getGroupValueSlot(value, extraReservedBytes);
      if (failed(slot))
        continue;
      extraReservedBytes += slot->plan.slotBytes;
      slots.push_back(*slot);
    }
    if (slots.empty())
      return;
    candidates.push_back(std::make_unique<ScratchSpillCandidate>(
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
    std::optional<LoopCarrySlot> slot = getLoopCarrySlot(group);
    if (!slot)
      return false;
    if (!canMaterializeLoopCarrySpill(*slot)) {
      sawLoopCarryReject = true;
      return false;
    }
    Value init = slot->loop.getInits()[slot->index];
    waveamdmachine::RegType type =
        dyn_cast<waveamdmachine::RegType>(init.getType());
    if (!type || type.getRegClass() != waveamdmachine::RegClass::VGPR ||
        !valueCoversWholeGroup(group, init))
      return false;
    if (type.getWidth() <= 1) {
      sawLoopCarryReject = true;
      return false;
    }
    if (loopCarryTouchesPressure(*slot))
      return false;
    ScratchSpillPlan plan = getPlanForValue(type);
    if (plan.status != ScratchSpillPlanStatus::Available) {
      setPlanRejectReason(plan.status);
      return false;
    }
    unsigned useCount = getLoopCarryUseCount(*slot);
    candidates.push_back(std::make_unique<ScratchSpillCandidate>(
        group, *slot, plan, useCount, type.getWidth(),
        getLoopCarrySpillCost(*slot, plan, type.getWidth(), useCount)));
    return true;
  }

  bool canMaterializeLoopCarrySpill(LoopCarrySlot slot) const {
    return canSpillLoopCarryAtPosition(slot) && hasLocalLoopCarryUses(slot) &&
           canRewriteExtraLoopInitUses(slot);
  }

  std::optional<LoopCarrySlot> getLoopCarrySlot(IntervalGroup *group) const {
    std::optional<LoopCarrySlot> slot;
    for (Value value : getGroupValues(group))
      if (failed(mergeLoopCarrySlot(value, slot)))
        return std::nullopt;
    return slot;
  }

  SmallVector<Value> getGroupValues(IntervalGroup *group) const {
    SmallVector<Value> values;
    llvm::SmallDenseSet<Value, 8> seen;
    for (Interval *lane : group->intervals)
      for (Value value : lane->values)
        if (seen.insert(value).second)
          values.push_back(value);
    llvm::stable_sort(values, [&](Value lhs, Value rhs) {
      return getValueOrder(lhs) < getValueOrder(rhs);
    });
    return values;
  }

  int64_t getValueOrder(Value value) const {
    int64_t resultIndex = -1;
    if (OpResult result = dyn_cast<OpResult>(value)) {
      resultIndex = result.getResultNumber();
      return inventory.positions.lookup(result.getOwner()) * 1024 + resultIndex;
    }
    BlockArgument arg = cast<BlockArgument>(value);
    resultIndex = arg.getArgNumber();
    Operation *parent = arg.getOwner()->getParentOp();
    if (isa_and_nonnull<func::FuncOp>(parent))
      return resultIndex;
    return inventory.positions.lookup(parent) * 1024 + resultIndex;
  }

  LogicalResult mergeLoopCarrySlot(Value value,
                                   std::optional<LoopCarrySlot> &slot) const {
    if (std::optional<LoopCarrySlot> valueSlot = getValueLoopCarrySlot(value))
      return mergeLoopCarrySlot(*valueSlot, slot);
    return success();
  }

  LogicalResult mergeLoopCarrySlot(LoopCarrySlot next,
                                   std::optional<LoopCarrySlot> &slot) const {
    if (!slot) {
      slot = next;
      return success();
    }
    if (slot->loop == next.loop && slot->index == next.index)
      return success();
    return failure();
  }

  std::optional<LoopCarrySlot> getValueLoopCarrySlot(Value value) const {
    if (BlockArgument arg = dyn_cast<BlockArgument>(value))
      if (waveamdmachine::UniformLoopOp loop =
              dyn_cast<waveamdmachine::UniformLoopOp>(
                  arg.getOwner()->getParentOp()))
        return LoopCarrySlot{loop, arg.getArgNumber()};
    if (waveamdmachine::UniformLoopOp loop =
            value.getDefiningOp<waveamdmachine::UniformLoopOp>())
      return LoopCarrySlot{loop, cast<OpResult>(value).getResultNumber()};
    for (OpOperand &use : value.getUses()) {
      Operation *owner = use.getOwner();
      if (waveamdmachine::UniformLoopOp loop =
              dyn_cast<waveamdmachine::UniformLoopOp>(owner))
        for (auto [index, init] : llvm::enumerate(loop.getInits()))
          if (init == value)
            return LoopCarrySlot{loop, static_cast<unsigned>(index)};
      if (waveamdmachine::ContinueIfOp term =
              dyn_cast<waveamdmachine::ContinueIfOp>(owner))
        if (use.getOperandNumber() != 0)
          return LoopCarrySlot{
              term->getParentOfType<waveamdmachine::UniformLoopOp>(),
              use.getOperandNumber() - 1};
    }
    return std::nullopt;
  }

  bool hasLocalLoopCarryUses(LoopCarrySlot slot) const {
    Block &body = slot.loop.getBody().front();
    BlockArgument arg = body.getArgument(slot.index);
    for (OpOperand &use : arg.getUses())
      if (!getAncestorInBlock(use.getOwner(), &body))
        return false;
    return true;
  }

  bool canSpillLoopCarryAtPosition(LoopCarrySlot slot) const {
    DenseMap<Operation *, unsigned>::iterator loopPos =
        inventory.positions.find(slot.loop);
    if (loopPos == inventory.positions.end())
      return false;
    if (position > loopPos->second)
      return true;
    return isSplatInit(slot);
  }

  bool canRewriteExtraLoopInitUse(OpOperand &use, OpOperand *loopUse,
                                  waveamdmachine::UniformLoopOp loop) const {
    if (&use == loopUse || isRegAllocTempOp(use.getOwner()))
      return true;
    Operation *user = use.getOwner();
    return user->getBlock() == loop->getBlock() && user->isBeforeInBlock(loop);
  }

  bool canRewriteExtraLoopInitUses(LoopCarrySlot slot) const {
    OpOperand *loopUse = &slot.loop.getInitsMutable()[slot.index];
    Value init = loopUse->get();
    for (OpOperand &use : init.getUses())
      if (!canRewriteExtraLoopInitUse(use, loopUse, slot.loop))
        return false;
    return true;
  }

  bool isSplatInit(LoopCarrySlot slot) const {
    waveamdmachine::VMovB32TupleOp splat =
        slot.loop.getInits()[slot.index]
            .getDefiningOp<waveamdmachine::VMovB32TupleOp>();
    return splat && splat.getSource().getDefiningOp<waveamdmachine::ImmOp>();
  }

  bool loopCarryTouchesPressure(LoopCarrySlot slot) const {
    Block &body = slot.loop.getBody().front();
    BlockArgument arg = body.getArgument(slot.index);
    for (OpOperand &use : arg.getUses())
      if (inventory.positions.lookup(use.getOwner()) == position)
        return true;
    Operation *term = body.getTerminator();
    return term && inventory.positions.lookup(term) == position;
  }

  unsigned getLoopCarryUseCount(LoopCarrySlot slot) const {
    Block &body = slot.loop.getBody().front();
    BlockArgument arg = body.getArgument(slot.index);
    unsigned count = llvm::range_size(arg.getUses());
    count += llvm::range_size(slot.loop.getResult(slot.index).getUses());
    return count + 1;
  }

  Value createImm(OpBuilder &builder, Location loc, int64_t value) const {
    return waveamdmachine::ImmOp::create(
        builder, loc, waveamdmachine::ImmType::get(builder.getContext()),
        static_cast<uint64_t>(value));
  }

  Value materializeSGPRAddress(OpBuilder &builder, Location loc,
                               unsigned offset) const {
    MLIRContext *ctx = builder.getContext();
    waveamdmachine::RegType type =
        waveamdmachine::RegType::get(ctx, waveamdmachine::RegClass::SGPR,
                                     /*width=*/1, /*index=*/-1);
    waveamdmachine::SMovB32ValueOp addr =
        waveamdmachine::SMovB32ValueOp::create(builder, loc, type,
                                               createImm(builder, loc, offset));
    addr->setAttr(kRegAllocTempAttr, builder.getUnitAttr());
    return addr.getResult();
  }

  void materializeAddress(OpBuilder &builder, Location loc, unsigned byteOffset,
                          Value &vaddr, Value &saddr,
                          int64_t &instOffset) const {
    Value zero = createImm(builder, loc, 0);
    vaddr = zero;
    if (byteOffset <= kScratchImmediateOffsetMax) {
      saddr = materializeSGPRAddress(builder, loc, 0);
      instOffset = byteOffset;
      return;
    }
    saddr = materializeSGPRAddress(builder, loc, byteOffset);
    instOffset = 0;
  }

  static bool tupleFitsImmediate(unsigned slotBase, unsigned width) {
    if (width == 0)
      return false;
    uint64_t lastOffset =
        static_cast<uint64_t>(slotBase) + static_cast<uint64_t>(width - 1) * 4;
    return lastOffset <= kScratchImmediateOffsetMax;
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

  LogicalResult materializeValue(Value value, ScratchSpillPlan plan,
                                 OpBuilder &builder) const {
    Operation *def = value.getDefiningOp();
    SmallVector<OpOperand *> uses;
    if (!hasSimpleUses(value, uses))
      return mlir::emitError(value.getLoc())
             << "waveamd-reg-alloc cannot materialize scratch spill for value";

    builder.setInsertionPointAfter(def);
    Value storeValue = materializeStoreValue(value, builder);
    Value storeToken =
        storeSpillValue(storeValue, Value{}, plan, builder, def->getLoc());

    for (OpOperand *use : uses) {
      if (use->get() != value)
        continue;
      Operation *user = use->getOwner();
      builder.setInsertionPoint(user);
      ScratchLoadResult load = loadSpillValue(getLoadType(value), storeToken,
                                              plan, builder, user->getLoc());
      if (failed(replaceUseWithLoad(value, use, load.value)))
        return failure();
    }
    return success();
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

  Value storeSpillValue(Value value, Value token, ScratchSpillPlan plan,
                        OpBuilder &builder, Location loc) const {
    unsigned width = cast<waveamdmachine::RegType>(value.getType()).getWidth();
    if (width > 1 && tupleFitsImmediate(plan.slotBase, width))
      return storeTupleValue(value, token, plan, builder, loc);
    if (width > 1)
      return storeScalarizedValue(value, token, plan, builder, loc);
    return storeScalarValue(value, token, plan, builder, loc);
  }

  ScratchLoadResult loadSpillValue(Type type, Value token,
                                   ScratchSpillPlan plan, OpBuilder &builder,
                                   Location loc) const {
    unsigned width = cast<waveamdmachine::RegType>(type).getWidth();
    if (width > 1 && tupleFitsImmediate(plan.slotBase, width))
      return loadTupleValue(type, token, plan, builder, loc);
    if (width > 1)
      return loadScalarizedValue(type, token, plan, builder, loc);
    return loadScalarValue(type, token, plan, builder, loc);
  }

  Value storeScalarValue(Value value, Value token, ScratchSpillPlan plan,
                         OpBuilder &builder, Location loc) const {
    return storeScalarValue(value, token, plan.slotBase, builder, loc);
  }

  Value storeScalarValue(Value value, Value token, unsigned byteOffset,
                         OpBuilder &builder, Location loc) const {
    Type tokenType = waveamdmachine::MemTokenType::get(builder.getContext());
    Value storeVaddr;
    Value storeSaddr;
    int64_t storeOffset = 0;
    materializeAddress(builder, loc, byteOffset, storeVaddr, storeSaddr,
                       storeOffset);
    waveamdmachine::ScratchStoreB32Op store =
        waveamdmachine::ScratchStoreB32Op::create(builder, loc, tokenType,
                                                  storeVaddr, value, storeSaddr,
                                                  token, storeOffset);
    store->setAttr(kRegAllocTempAttr, builder.getUnitAttr());
    return store.getToken();
  }

  ScratchLoadResult loadScalarValue(Type type, Value token,
                                    ScratchSpillPlan plan, OpBuilder &builder,
                                    Location loc) const {
    return loadScalarValue(type, token, plan.slotBase, builder, loc);
  }

  ScratchLoadResult loadScalarValue(Type type, Value token, unsigned byteOffset,
                                    OpBuilder &builder, Location loc) const {
    Type tokenType = waveamdmachine::MemTokenType::get(builder.getContext());
    Value loadVaddr;
    Value loadSaddr;
    int64_t loadOffset = 0;
    materializeAddress(builder, loc, byteOffset, loadVaddr, loadSaddr,
                       loadOffset);
    waveamdmachine::ScratchLoadB32Op load =
        waveamdmachine::ScratchLoadB32Op::create(builder, loc, type, tokenType,
                                                 loadVaddr, loadSaddr, token,
                                                 loadOffset);
    load->setAttr(kRegAllocTempAttr, builder.getUnitAttr());
    return {load.getResult(), load.getToken()};
  }

  Value storeScalarizedValue(Value value, Value token, ScratchSpillPlan plan,
                             OpBuilder &builder, Location loc) const {
    Type tokenType = waveamdmachine::MemTokenType::get(builder.getContext());
    SmallVector<Value> elements = splitValue(value, builder, loc);
    SmallVector<Value> tokens;
    tokens.reserve(elements.size());
    for (auto [index, element] : llvm::enumerate(elements))
      tokens.push_back(storeScalarValue(
          element, token, plan.slotBase + static_cast<unsigned>(index) * 4,
          builder, loc));
    return joinTokens(tokenType, tokens, builder, loc);
  }

  ScratchLoadResult loadScalarizedValue(Type type, Value token,
                                        ScratchSpillPlan plan,
                                        OpBuilder &builder,
                                        Location loc) const {
    Type tokenType = waveamdmachine::MemTokenType::get(builder.getContext());
    SmallVector<Type> elementTypes = getScalarRegTypes(type);
    SmallVector<Value> elements;
    SmallVector<Value> tokens;
    elements.reserve(elementTypes.size());
    tokens.reserve(elementTypes.size());
    for (auto [index, elementType] : llvm::enumerate(elementTypes)) {
      ScratchLoadResult load = loadScalarValue(
          elementType, token, plan.slotBase + static_cast<unsigned>(index) * 4,
          builder, loc);
      elements.push_back(load.value);
      tokens.push_back(load.token);
    }
    return {joinValue(type, elements, builder, loc),
            joinTokens(tokenType, tokens, builder, loc)};
  }

  Value storeTupleValue(Value value, Value token, ScratchSpillPlan plan,
                        OpBuilder &builder, Location loc) const {
    Type tokenType = waveamdmachine::MemTokenType::get(builder.getContext());
    Value storeVaddr;
    Value storeSaddr;
    int64_t storeOffset = 0;
    materializeAddress(builder, loc, plan.slotBase, storeVaddr, storeSaddr,
                       storeOffset);
    waveamdmachine::ScratchStoreTupleB32Op store =
        waveamdmachine::ScratchStoreTupleB32Op::create(
            builder, loc, tokenType, storeVaddr, value, storeSaddr, token,
            storeOffset);
    store->setAttr(kRegAllocTempAttr, builder.getUnitAttr());
    return store.getToken();
  }

  ScratchLoadResult loadTupleValue(Type type, Value token,
                                   ScratchSpillPlan plan, OpBuilder &builder,
                                   Location loc) const {
    Type tokenType = waveamdmachine::MemTokenType::get(builder.getContext());
    Value loadVaddr;
    Value loadSaddr;
    int64_t loadOffset = 0;
    materializeAddress(builder, loc, plan.slotBase, loadVaddr, loadSaddr,
                       loadOffset);
    waveamdmachine::ScratchLoadTupleB32Op load =
        waveamdmachine::ScratchLoadTupleB32Op::create(
            builder, loc, type, tokenType, loadVaddr, loadSaddr, token,
            loadOffset);
    load->setAttr(kRegAllocTempAttr, builder.getUnitAttr());
    return {load.getResult(), load.getToken()};
  }

  static bool isSpilledIndex(ArrayRef<const ScratchPressurePlan *> spills,
                             unsigned index) {
    return llvm::any_of(spills, [&](const ScratchPressurePlan *spill) {
      return getPlanLoopCarrySlot(*spill).index == index;
    });
  }

  static std::optional<unsigned>
  getSpillOrdinal(ArrayRef<const ScratchPressurePlan *> spills,
                  unsigned index) {
    for (auto [ordinal, spill] : llvm::enumerate(spills))
      if (getPlanLoopCarrySlot(*spill).index == index)
        return ordinal;
    return std::nullopt;
  }

  LogicalResult
  materializeLoopCarryPlans(ArrayRef<const ScratchPressurePlan *> spills,
                            OpBuilder &builder) const {
    if (failed(materializeLoopCarries(spills, builder)))
      return failure();
    for (const ScratchPressurePlan *spill : spills)
      reserveSlot(spill->getPlan(), builder);
    return success();
  }

  LogicalResult
  materializeLoopCarries(ArrayRef<const ScratchPressurePlan *> input,
                         OpBuilder &builder) const {
    if (input.empty())
      return success();
    SmallVector<const ScratchPressurePlan *, 4> spills(input.begin(),
                                                       input.end());
    llvm::stable_sort(spills, [](const ScratchPressurePlan *lhs,
                                 const ScratchPressurePlan *rhs) {
      return getPlanLoopCarrySlot(*lhs).index <
             getPlanLoopCarrySlot(*rhs).index;
    });

    waveamdmachine::UniformLoopOp loop =
        getPlanLoopCarrySlot(*spills.front()).loop;
    for (const ScratchPressurePlan *spill : spills)
      assert(getPlanLoopCarrySlot(*spill).loop == loop &&
             "expected one loop carry group");

    SmallVector<Value, 4> initTokens;
    for (const ScratchPressurePlan *spill : spills) {
      LoopCarrySlot slot = getPlanLoopCarrySlot(*spill);
      Value init = loop.getInits()[slot.index];
      setInsertionPointForInitStore(init, loop, builder);
      initTokens.push_back(storeSpillValue(init, Value{}, spill->getPlan(),
                                           builder, loop.getLoc()));
    }
    for (auto [index, spill] : llvm::enumerate(spills))
      if (failed(rewriteExtraLoopInitUses(*spill, initTokens[index], builder)))
        return failure();

    waveamdmachine::UniformLoopOp newLoop =
        cloneLoopWithoutCarries(loop, spills, initTokens, builder);
    replaceLoopResults(loop, newLoop, spills, builder);
    loop.erase();
    return success();
  }

  void setInsertionPointForInitStore(Value init,
                                     waveamdmachine::UniformLoopOp loop,
                                     OpBuilder &builder) const {
    Operation *def = init.getDefiningOp();
    if (!def || def->getBlock() != loop->getBlock() ||
        !def->isBeforeInBlock(loop)) {
      builder.setInsertionPoint(loop);
      return;
    }
    builder.setInsertionPointAfter(def);
  }

  LogicalResult rewriteExtraLoopInitUses(const ScratchPressurePlan &spill,
                                         Value initToken,
                                         OpBuilder &builder) const {
    LoopCarrySlot slot = getPlanLoopCarrySlot(spill);
    waveamdmachine::UniformLoopOp loop = slot.loop;
    OpOperand *loopUse = &loop.getInitsMutable()[slot.index];
    Value init = loopUse->get();
    SmallVector<OpOperand *> uses;
    for (OpOperand &use : init.getUses()) {
      if (&use == loopUse || isRegAllocTempOp(use.getOwner()))
        continue;
      uses.push_back(&use);
    }

    for (OpOperand *use : uses) {
      Operation *user = use->getOwner();
      if (!canRewriteExtraLoopInitUse(*use, loopUse, loop))
        return mlir::emitError(init.getLoc())
               << "waveamd-reg-alloc cannot materialize scratch spill for "
                  "loop init use outside loop preheader";
      builder.setInsertionPoint(user);
      ScratchLoadResult load = loadSpillValue(
          init.getType(), initToken, spill.getPlan(), builder, user->getLoc());
      use->set(load.value);
    }
    return success();
  }

  waveamdmachine::UniformLoopOp
  cloneLoopWithoutCarries(waveamdmachine::UniformLoopOp loop,
                          ArrayRef<const ScratchPressurePlan *> spills,
                          ArrayRef<Value> initTokens,
                          OpBuilder &builder) const {
    Type tokenType = waveamdmachine::MemTokenType::get(builder.getContext());
    SmallVector<Type> resultTypes;
    SmallVector<Value> inits;
    for (unsigned index : llvm::seq<unsigned>(0, loop.getInits().size())) {
      if (isSpilledIndex(spills, index))
        continue;
      resultTypes.push_back(loop.getResult(index).getType());
      inits.push_back(loop.getInits()[index]);
    }
    for (Value initToken : initTokens) {
      resultTypes.push_back(tokenType);
      inits.push_back(initToken);
    }

    builder.setInsertionPoint(loop);
    waveamdmachine::UniformLoopOp newLoop =
        waveamdmachine::UniformLoopOp::create(
            builder, loop.getLoc(), resultTypes, loop.getEntryCond(), inits);
    cloneLoopBody(loop, newLoop, spills, builder);
    return newLoop;
  }

  void cloneLoopBody(waveamdmachine::UniformLoopOp oldLoop,
                     waveamdmachine::UniformLoopOp newLoop,
                     ArrayRef<const ScratchPressurePlan *> spills,
                     OpBuilder &builder) const {
    Block &oldBody = oldLoop.getBody().front();
    Block *newBody = new Block;
    newLoop.getBody().push_back(newBody);
    for (Value init : newLoop.getInits())
      newBody->addArgument(init.getType(), oldLoop.getLoc());

    IRMapping mapper;
    unsigned newArgIndex = 0;
    for (unsigned index : llvm::seq<unsigned>(0, oldLoop.getInits().size())) {
      if (isSpilledIndex(spills, index))
        continue;
      mapper.map(oldBody.getArgument(index),
                 newBody->getArgument(newArgIndex++));
    }
    SmallVector<Value, 4> tokens;
    for ([[maybe_unused]] const ScratchPressurePlan *spill : spills)
      tokens.push_back(newBody->getArgument(newArgIndex++));
    cloneLoopBodyOps(oldLoop, newBody, spills, tokens, mapper, builder);
  }

  void cloneLoopBodyOps(waveamdmachine::UniformLoopOp oldLoop, Block *newBody,
                        ArrayRef<const ScratchPressurePlan *> spills,
                        SmallVectorImpl<Value> &tokens, IRMapping &mapper,
                        OpBuilder &builder) const {
    Block &oldBody = oldLoop.getBody().front();
    builder.setInsertionPointToEnd(newBody);
    for (Operation &op : oldBody.without_terminator()) {
      for (const ScratchPressurePlan *spill : spills) {
        BlockArgument oldArg =
            oldBody.getArgument(getPlanLoopCarrySlot(*spill).index);
        if (!opUsesValue(&op, oldArg))
          continue;
        (void)getMappedValue(oldLoop, oldArg, spills, tokens, mapper, builder,
                             op.getLoc());
      }
      builder.clone(op, mapper);
    }
    cloneLoopTerminator(oldLoop, spills, tokens, mapper, builder);
  }

  static bool opUsesValue(Operation *op, Value value) {
    bool found = false;
    op->walk([&](Operation *nested) {
      if (found)
        return WalkResult::interrupt();
      if (llvm::any_of(nested->getOperands(),
                       [&](Value operand) { return operand == value; })) {
        found = true;
        return WalkResult::interrupt();
      }
      return WalkResult::advance();
    });
    return found;
  }

  std::optional<unsigned>
  getSpillOrdinalForValue(waveamdmachine::UniformLoopOp loop, Value value,
                          ArrayRef<const ScratchPressurePlan *> spills) const {
    BlockArgument arg = dyn_cast<BlockArgument>(value);
    if (!arg || arg.getOwner() != &loop.getBody().front())
      return std::nullopt;
    return getSpillOrdinal(spills, arg.getArgNumber());
  }

  Value getMappedValue(waveamdmachine::UniformLoopOp loop, Value value,
                       ArrayRef<const ScratchPressurePlan *> spills,
                       SmallVectorImpl<Value> &tokens, IRMapping &mapper,
                       OpBuilder &builder, Location loc) const {
    if (Value mapped = mapper.lookupOrNull(value))
      return mapped;
    std::optional<unsigned> ordinal =
        getSpillOrdinalForValue(loop, value, spills);
    if (!ordinal)
      return mapper.lookupOrDefault(value);
    const ScratchPressurePlan &spill = *spills[*ordinal];
    ScratchLoadResult load = loadSpillValue(value.getType(), tokens[*ordinal],
                                            spill.getPlan(), builder, loc);
    tokens[*ordinal] = load.token;
    mapper.map(value, load.value);
    return load.value;
  }

  bool
  needsTerminatorPreload(waveamdmachine::UniformLoopOp loop,
                         unsigned carryIndex, Value carry,
                         ArrayRef<const ScratchPressurePlan *> spills) const {
    std::optional<unsigned> source =
        getSpillOrdinalForValue(loop, carry, spills);
    if (!source)
      return false;
    std::optional<unsigned> dest = getSpillOrdinal(spills, carryIndex);
    if (!dest || *dest != *source)
      return true;
    BlockArgument arg = cast<BlockArgument>(carry);
    return arg.getArgNumber() != carryIndex;
  }

  void cloneLoopTerminator(waveamdmachine::UniformLoopOp loop,
                           ArrayRef<const ScratchPressurePlan *> spills,
                           SmallVectorImpl<Value> &tokens, IRMapping &mapper,
                           OpBuilder &builder) const {
    waveamdmachine::ContinueIfOp oldTerm = cast<waveamdmachine::ContinueIfOp>(
        loop.getBody().front().getTerminator());
    for (auto [index, carry] : llvm::enumerate(oldTerm.getCarries()))
      if (needsTerminatorPreload(loop, index, carry, spills))
        (void)getMappedValue(loop, carry, spills, tokens, mapper, builder,
                             oldTerm.getLoc());

    SmallVector<Value> carries;
    for (unsigned index : llvm::seq<unsigned>(0, oldTerm.getCarries().size())) {
      Value carry = oldTerm.getCarries()[index];
      std::optional<unsigned> spillIndex = getSpillOrdinal(spills, index);
      if (spillIndex) {
        const ScratchPressurePlan &spill = *spills[*spillIndex];
        BlockArgument oldArg = loop.getBody().front().getArgument(
            getPlanLoopCarrySlot(spill).index);
        if (carry != oldArg)
          tokens[*spillIndex] = storeSpillValue(
              getMappedValue(loop, carry, spills, tokens, mapper, builder,
                             oldTerm.getLoc()),
              tokens[*spillIndex], spill.getPlan(), builder, oldTerm.getLoc());
        continue;
      }
      carries.push_back(getMappedValue(loop, carry, spills, tokens, mapper,
                                       builder, oldTerm.getLoc()));
    }
    carries.append(tokens.begin(), tokens.end());
    waveamdmachine::ContinueIfOp::create(
        builder, oldTerm.getLoc(), mapper.lookupOrDefault(oldTerm.getCond()),
        carries);
  }

  void replaceLoopResults(waveamdmachine::UniformLoopOp oldLoop,
                          waveamdmachine::UniformLoopOp newLoop,
                          ArrayRef<const ScratchPressurePlan *> spills,
                          OpBuilder &builder) const {
    builder.setInsertionPointAfter(newLoop);
    unsigned newResultIndex = 0;
    for (unsigned index : llvm::seq<unsigned>(0, oldLoop.getResults().size())) {
      if (isSpilledIndex(spills, index))
        continue;
      oldLoop.getResult(index).replaceAllUsesWith(
          newLoop.getResult(newResultIndex++));
    }
    for (const ScratchPressurePlan *spill : spills) {
      Value token = newLoop.getResult(newResultIndex++);
      unsigned oldIndex = getPlanLoopCarrySlot(*spill).index;
      if (oldLoop.getResult(oldIndex).use_empty())
        continue;
      ScratchLoadResult load =
          loadSpillValue(oldLoop.getResult(oldIndex).getType(), token,
                         spill->getPlan(), builder, oldLoop.getLoc());
      oldLoop.getResult(oldIndex).replaceAllUsesWith(load.value);
    }
  }

  void reserveSlot(const ScratchSpillPlan &plan, OpBuilder &builder) const {
    unsigned reserved =
        getUnsignedAttr(func, kScratchSpillBytesAttr).value_or(0);
    unsigned existingPrivate = getPrivateSegmentBytes(func, reserved);
    unsigned newReserved = reserved + plan.slotBytes;
    func->setAttr(kScratchSpillBytesAttr,
                  builder.getI64IntegerAttr(newReserved));
    func->setAttr(kPrivateSegmentFixedSizeAttr,
                  builder.getI64IntegerAttr(existingPrivate + newReserved));
    func->setAttr(kUsesFlatScratchAttr, builder.getBoolAttr(true));
  }

  mutable std::string planRejectReason;
  ArrayRef<IntervalGroup *> groups;
  Inventory &inventory;
  func::FuncOp func;
  IntervalGroup *request = nullptr;
  unsigned position = 0;
  mutable const PressureFailure *pressureFailure = nullptr;
  mutable bool sawLoopCarryReject = false;
};

static bool supportsScratchSpillTarget(const llvm::AMDGPU::IsaVersion &isa) {
  return isa.Major == 11 || isa.Major == 12 ||
         (isa.Major == 9 && isa.Minor >= 4);
}

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

static unsigned getPrivateSegmentBytes(func::FuncOp func,
                                       unsigned reservedBytes) {
  if (std::optional<unsigned> fixed =
          getUnsignedAttr(func, kWavePrivateSegmentFixedSizeAttr))
    return *fixed;

  unsigned total =
      getUnsignedAttr(func, kPrivateSegmentFixedSizeAttr).value_or(0);
  if (total >= reservedBytes)
    return total - reservedBytes;
  return 0;
}

static ScratchSpillPlan reject(ScratchSpillPlanStatus status,
                               unsigned existingBytes, unsigned reservedBytes,
                               unsigned valueBytes) {
  ScratchSpillPlan plan;
  plan.status = status;
  plan.existingPrivateBytes = existingBytes;
  plan.reservedSpillBytes = reservedBytes;
  plan.valueBytes = valueBytes;
  return plan;
}

static ScratchSpillPlan available(unsigned existingBytes,
                                  unsigned reservedBytes, unsigned valueBytes) {
  ScratchSpillPlan plan;
  plan.status = ScratchSpillPlanStatus::Available;
  plan.existingPrivateBytes = existingBytes;
  plan.reservedSpillBytes = reservedBytes;
  plan.slotBase = existingBytes + reservedBytes;
  plan.slotBytes = valueBytes;
  plan.valueBytes = valueBytes;
  plan.usesFlatScratch = true;
  return plan;
}

static bool checkedAdd(unsigned lhs, unsigned rhs, unsigned &result) {
  if (std::numeric_limits<unsigned>::max() - lhs < rhs)
    return true;
  result = lhs + rhs;
  return false;
}

static ScratchSpillPlan buildScratchSpillPlan(func::FuncOp func,
                                              unsigned valueBytes,
                                              unsigned reservedSpillBytes,
                                              unsigned existingBytes) {
  if (!func->hasAttr(wave::WaveDialect::getKernelAttrName()))
    return reject(ScratchSpillPlanStatus::NotKernel, existingBytes,
                  reservedSpillBytes, valueBytes);
  if (valueBytes == 0)
    return reject(ScratchSpillPlanStatus::InvalidValueBytes, existingBytes,
                  reservedSpillBytes, valueBytes);

  FailureOr<waveamdmachine::AMDGPUTarget> target =
      waveamdmachine::getAMDGPUTarget(func, "waveamd-reg-alloc scratch "
                                            "planning");
  if (failed(target))
    return reject(ScratchSpillPlanStatus::UnsupportedTarget, existingBytes,
                  reservedSpillBytes, valueBytes);
  if (!supportsScratchSpillTarget(llvm::AMDGPU::getIsaVersion(target->chip)))
    return reject(ScratchSpillPlanStatus::UnsupportedTarget, existingBytes,
                  reservedSpillBytes, valueBytes);

  unsigned usedBytes = 0;
  unsigned nextBytes = 0;
  if (checkedAdd(existingBytes, reservedSpillBytes, usedBytes) ||
      checkedAdd(usedBytes, valueBytes, nextBytes))
    return reject(ScratchSpillPlanStatus::PrivateSegmentOverflow, existingBytes,
                  reservedSpillBytes, valueBytes);
  return available(existingBytes, reservedSpillBytes, valueBytes);
}

} // namespace

StringRef mlir::wave::regalloc::getScratchSpillPlanStatusName(
    ScratchSpillPlanStatus status) {
  switch (status) {
  case ScratchSpillPlanStatus::Available:
    return "available";
  case ScratchSpillPlanStatus::NotKernel:
    return "not_kernel";
  case ScratchSpillPlanStatus::UnsupportedTarget:
    return "unsupported_target";
  case ScratchSpillPlanStatus::InvalidValueBytes:
    return "invalid_value_bytes";
  case ScratchSpillPlanStatus::PrivateSegmentOverflow:
    return "private_segment_overflow";
  }
  llvm_unreachable("unknown scratch spill plan status");
}

ScratchSpillPlan mlir::wave::regalloc::planScratchSpillSlot(
    func::FuncOp func, unsigned valueBytes, unsigned reservedSpillBytes) {
  unsigned existingBytes = getPrivateSegmentBytes(func, reservedSpillBytes);
  return buildScratchSpillPlan(func, valueBytes, reservedSpillBytes,
                               existingBytes);
}

std::unique_ptr<wave::WaveAMDPressureReliefProvider>
mlir::wave::regalloc::createScratchSpillProvider(
    func::FuncOp func, ArrayRef<IntervalGroup *> groups, IntervalGroup *request,
    unsigned position, Inventory &inventory) {
  return std::make_unique<ScratchSpillProvider>(func, groups, request, position,
                                                inventory);
}
