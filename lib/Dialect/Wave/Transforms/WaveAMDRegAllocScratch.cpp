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

static std::optional<unsigned> getUnsignedAttr(Operation *op, StringRef name);
static unsigned getPrivateSegmentBytes(func::FuncOp func,
                                       unsigned reservedBytes);
static ScratchSpillPlan buildScratchSpillPlan(func::FuncOp func,
                                              unsigned valueBytes,
                                              unsigned reservedSpillBytes,
                                              unsigned existingBytes);

using ScratchLoadResult = MemorySpillLoadResult;

struct ScratchValueSlot {
  Value value;
  ScratchSpillPlan plan;
  wave::WaveAMDPressureReliefCost cost;
  unsigned useCount = 0;
};

static unsigned getTotalSlotBytes(ArrayRef<ScratchValueSlot> slots) {
  unsigned total = 0;
  for (const ScratchValueSlot &slot : slots)
    total += slot.plan.slotBytes;
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
  unsigned getUseCount() const override {
    return getMemorySpillTotalUseCount(valueSlots);
  }
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

  StringRef getProviderName() const override { return "scratch-spill"; }

  wave::WaveAMDPressureReliefCost getCost() const override { return cost; }

  unsigned getReliefDwords() const override { return pressureRelief; }

  wave::WaveAMDPressureReliefEffect
  getPressureEffect(const wave::WaveAMDPressureFailure &) const override {
    return getMemorySpillPressureEffect(group, pressureRelief);
  }

  std::optional<StringRef> getRejectReason() const override {
    if (rejectReason.empty())
      return std::nullopt;
    return StringRef(rejectReason);
  }

  IntervalGroup *getGroup() const { return group; }
  ScratchSpillPlan getPlan() const {
    assert(!valueSlots.empty() && "scratch candidate needs a slot");
    return valueSlots.front().plan;
  }
  unsigned getUseCount() const {
    return getMemorySpillTotalUseCount(valueSlots);
  }
  Value getValue() const {
    if (valueSlots.size() != 1)
      return {};
    return valueSlots.front().value;
  }
  std::unique_ptr<wave::WaveAMDPressureReliefPlan> getPlannedSpill() const {
    return std::make_unique<ScratchValuePressurePlan>(group, valueSlots,
                                                      pressureRelief);
  }

protected:
  void printExtra(llvm::raw_ostream &os) const override {
    ScratchSpillPlan firstPlan = getPlan();
    os << ", reg_class=" << getRegClassName(group->storageClass);
    os << ", slot_base=" << firstPlan.slotBase
       << ", slot_bytes=" << getTotalSlotBytes(valueSlots)
       << ", uses=" << getUseCount();
  }

  void setExtraDiagnosticAttrs(Builder &builder,
                               NamedAttrList &attrs) const override {
    ScratchSpillPlan firstPlan = getPlan();
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
  SmallVector<ScratchValueSlot, 4> valueSlots;
  wave::WaveAMDPressureReliefCost cost;
  IntervalGroup *group = nullptr;
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

  void collectPlanTempIntervals(
      const wave::WaveAMDPressureReliefPlan &plan,
      SmallVectorImpl<wave::WaveAMDPressureReliefTempInterval> &intervals)
      const override {
    const ScratchPressurePlan &spill =
        static_cast<const ScratchPressurePlan &>(plan);
    for (const ScratchValueSlot &slot : spill.getValueSlots())
      collectValueTempIntervals(slot, intervals);
  }

  LogicalResult
  materializePlan(const wave::WaveAMDPressureReliefPlan &plan,
                  wave::WaveAMDPressureReliefMaterializationContext &context,
                  OpBuilder &builder) const override {
    const ScratchPressurePlan &spill =
        static_cast<const ScratchPressurePlan &>(plan);
    assert(!spill.getValueSlots().empty() && "expected scratch value spill");
    llvm::SmallDenseSet<Value, 8> plannedValues;
    for (const ScratchValueSlot &slot : spill.getValueSlots())
      plannedValues.insert(slot.value);
    for (const ScratchValueSlot &slot : spill.getValueSlots())
      if (failed(materializeValue(slot.value, slot.plan, plan, context, builder,
                                  plannedValues)))
        return failure();
    propagateMemorySpillGroupTupleAliases(spill.getGroup(), inventory);
    for (const ScratchValueSlot &slot : spill.getValueSlots())
      reserveSlot(slot.plan, builder);
    return success();
  }

  void emitRemarks() const override {
    func::FuncOp func = this->func;
    unsigned reservedBytes =
        getUnsignedAttr(func, kScratchSpillBytesAttr).value_or(0);
    ScratchSpillPlan plan =
        planScratchSpillSlot(func, /*valueBytes=*/4, reservedBytes);
    if (plan.status == ScratchSpillPlanStatus::NotKernel)
      return;
    auto remark = mlir::remark::analysis(
        func.getLoc(),
        getWaveAMDRegAllocRemarkOpts(func, "regalloc-scratch-plan"));
    if (!remark)
      return;
    emitRegAllocIntegerMetric(remark, "existing_private_bytes",
                              plan.existingPrivateBytes);
    emitRegAllocIntegerMetric(remark, "reserved_spill_bytes",
                              plan.reservedSpillBytes);
    emitRegAllocStringMetric(remark, "status",
                             getScratchSpillPlanStatusName(plan.status));
    remark << mlir::remark::metric("uses_flat_scratch", plan.usesFlatScratch);
    emitRegAllocIntegerMetric(remark, "value_bytes", plan.valueBytes);
    if (plan.status != ScratchSpillPlanStatus::Available)
      return;
    emitRegAllocIntegerMetric(remark, "slot_base", plan.slotBase);
    emitRegAllocIntegerMetric(remark, "slot_bytes", plan.slotBytes);
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
    if (wave::isBetterWaveAMDPressureReliefCandidate(lhs, rhs))
      return true;
    if (wave::isBetterWaveAMDPressureReliefCandidate(rhs, lhs))
      return false;
    if (lhsSpill.getGroup()->intervals.front()->end !=
        rhsSpill.getGroup()->intervals.front()->end)
      return lhsSpill.getGroup()->intervals.front()->end >
             rhsSpill.getGroup()->intervals.front()->end;
    return false;
  }

  std::optional<StringRef> getRejectReason() const override {
    if (!planRejectReason.empty())
      return StringRef(planRejectReason);
    return std::nullopt;
  }

  void setNoCandidateDiagnostic() const {
    setMemorySpillRejectDiagnostics(func, groups, request, position);
    std::optional<StringRef> reason = getRejectReason();
    if (!reason)
      return;
    Builder builder(func->getContext());
    func->setAttr(kMemorySpillRejectAttr, builder.getStringAttr(*reason));
  }

  void notifyAttemptStarted() const override {
    clearMemorySpillRejectDiagnostics(func);
  }

  void notifyNoCandidate() const override { setNoCandidateDiagnostic(); }

  void notifyPlanApplied() const override {
    clearMemorySpillRejectDiagnostics(func);
  }

private:
  void collectAddressTemps(
      SmallVectorImpl<wave::WaveAMDPressureReliefTempInterval> &intervals,
      unsigned position, ScratchSpillPlan plan, unsigned valueWidth) const {
    for ([[maybe_unused]] unsigned index :
         llvm::seq<unsigned>(0, getScratchMemoryOps(plan, valueWidth)))
      appendMemorySpillPointTemp(intervals, waveamdmachine::RegClass::SGPR,
                                 position, /*width=*/1);
  }

  void collectValueTempIntervals(
      const ScratchValueSlot &slot,
      SmallVectorImpl<wave::WaveAMDPressureReliefTempInterval> &intervals)
      const {
    collectMemorySpillValueTempIntervals(
        inventory, slot.value, intervals,
        [&](SmallVectorImpl<wave::WaveAMDPressureReliefTempInterval> &intervals,
            unsigned position, unsigned valueWidth) {
          collectAddressTemps(intervals, position, slot.plan, valueWidth);
        });
  }

  void setPlanRejectReason(ScratchSpillPlanStatus status) const {
    if (!planRejectReason.empty())
      return;
    planRejectReason = "scratch_spill_";
    planRejectReason += getScratchSpillPlanStatusName(status);
  }

  static bool isEligibleGroup(IntervalGroup *group, unsigned position) {
    return isMemorySpillProviderEligibleGroup(group, position);
  }

  static bool isCandidateGroup(IntervalGroup *group, unsigned position) {
    return isMemorySpillProviderCandidateGroup(group, position);
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
    cost.loopWeightedOps = static_cast<int64_t>(opCount) *
                           getLoopDepth(getMemorySpillValueAnchorOp(value));
    for (OpOperand *use : uses)
      cost.loopWeightedOps +=
          static_cast<int64_t>(opCount) * getLoopDepth(use->getOwner());
    cost.latencyPenalty = static_cast<int64_t>(memoryOps) * uses.size() * 8;
    return cost;
  }

  bool hasSimpleUses(Value value, SmallVectorImpl<OpOperand *> &uses) const {
    return collectSimpleMemorySpillUses(value, inventory, uses);
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

  unsigned getLiveLaneCount(IntervalGroup *group) const {
    return mlir::wave::regalloc::getLiveLaneCount(group, position);
  }

  bool hasLiveLaneAtPressure(IntervalGroup *group) const {
    return mlir::wave::regalloc::hasLiveLaneAtPressure(group, position);
  }

  FailureOr<ScratchValueSlot>
  getGroupValueSlot(Value value, unsigned extraReservedBytes) const {
    auto type = dyn_cast<waveamdmachine::RegType>(value.getType());
    if (!type || !isMemorySpillProviderRegClass(type.getRegClass()) ||
        type.getWidth() == 0)
      return failure();
    SmallVector<OpOperand *> uses;
    if (!hasSimpleUses(value, uses))
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
    if (!hasLiveLaneAtPressure(group))
      return;
    unsigned relief = getLiveLaneCount(group);

    SmallVector<ScratchValueSlot, 8> slots;
    unsigned extraReservedBytes = 0;
    for (Value value : getGroupValues(group)) {
      if (!hasNonTempUse(value))
        continue;
      FailureOr<ScratchValueSlot> slot =
          getGroupValueSlot(value, extraReservedBytes);
      if (failed(slot))
        return;
      extraReservedBytes += slot->plan.slotBytes;
      slots.push_back(*slot);
    }
    if (slots.empty())
      return;
    candidates.push_back(std::make_unique<ScratchSpillCandidate>(
        group, slots, relief, getMemorySpillTotalCost(slots)));
  }

  void collect(IntervalGroup *group,
               wave::WaveAMDPressureReliefCandidateList &candidates) const {
    if (!isCandidateGroup(group, position))
      return;
    if (!isEligibleGroup(group, position))
      return;
    collectGroupValue(group, candidates);
  }

  SmallVector<Value> getGroupValues(IntervalGroup *group) const {
    return getMemorySpillGroupValues(group, inventory);
  }

  Value createImm(OpBuilder &builder, Location loc, int64_t value) const {
    return waveamdmachine::ImmOp::create(
        builder, loc, waveamdmachine::ImmType::get(builder.getContext()),
        static_cast<uint64_t>(value));
  }

  FailureOr<Value> materializeSGPRAddress(
      OpBuilder &builder, Location loc, unsigned offset,
      const wave::WaveAMDPressureReliefPlan &reliefPlan,
      wave::WaveAMDPressureReliefMaterializationContext &context,
      Operation *diagOp) const {
    FailureOr<waveamdmachine::RegType> type = consumePressureReliefTempRegType(
        reliefPlan, context, waveamdmachine::RegClass::SGPR, /*width=*/1,
        diagOp);
    if (failed(type))
      return failure();
    waveamdmachine::SMovB32ValueOp addr =
        waveamdmachine::SMovB32ValueOp::create(builder, loc, *type,
                                               createImm(builder, loc, offset));
    addr->setAttr(kRegAllocTempAttr, builder.getUnitAttr());
    return addr.getResult();
  }

  LogicalResult
  materializeAddress(OpBuilder &builder, Location loc, unsigned byteOffset,
                     Value &vaddr, Value &saddr, int64_t &instOffset,
                     const wave::WaveAMDPressureReliefPlan &reliefPlan,
                     wave::WaveAMDPressureReliefMaterializationContext &context,
                     Operation *diagOp) const {
    Value zero = createImm(builder, loc, 0);
    vaddr = zero;
    if (byteOffset <= kScratchImmediateOffsetMax) {
      FailureOr<Value> addr =
          materializeSGPRAddress(builder, loc, 0, reliefPlan, context, diagOp);
      if (failed(addr))
        return failure();
      saddr = *addr;
      instOffset = byteOffset;
      return success();
    }
    FailureOr<Value> addr = materializeSGPRAddress(builder, loc, byteOffset,
                                                   reliefPlan, context, diagOp);
    if (failed(addr))
      return failure();
    saddr = *addr;
    instOffset = 0;
    return success();
  }

  static bool tupleFitsImmediate(unsigned slotBase, unsigned width) {
    if (width == 0)
      return false;
    uint64_t lastOffset =
        static_cast<uint64_t>(slotBase) + static_cast<uint64_t>(width - 1) * 4;
    return lastOffset <= kScratchImmediateOffsetMax;
  }

  FailureOr<Value> materializeValueStoreToken(
      Value value, ScratchSpillPlan spillPlan,
      const wave::WaveAMDPressureReliefPlan &reliefPlan,
      wave::WaveAMDPressureReliefMaterializationContext &context,
      OpBuilder &builder) const {
    Operation *diagOp = getMemorySpillValueDiagOp(value);
    if (!diagOp)
      return mlir::emitError(value.getLoc())
             << "waveamd-reg-alloc cannot materialize scratch spill for value";
    setInsertionPointForMemorySpillStore(value, builder);
    waveamdmachine::RegType valueType =
        cast<waveamdmachine::RegType>(value.getType());
    FailureOr<wave::WaveAMDPressureReliefTempAssignment> valueAssignment =
        context.consumeTempAssignment(reliefPlan, valueType.getRegClass(),
                                      valueType.getWidth(), diagOp);
    if (failed(valueAssignment))
      return failure();
    assignValueToTempAssignment(value, *valueAssignment);
    assignTupleFromElementsBridgeValues(value, *valueAssignment, inventory);
    FailureOr<Value> storeValue = materializeMemorySpillStoreValue(
        value, reliefPlan, context, builder, diagOp);
    if (failed(storeValue))
      return failure();
    Value storeDependency;
    if (Operation *def = value.getDefiningOp())
      storeDependency = getMemoryIssuerToken(def);
    return storeSpillValue(*storeValue, storeDependency, spillPlan, reliefPlan,
                           context, builder, value.getLoc(), diagOp);
  }

  LogicalResult replaceValueUsesWithLoads(
      Value value, Value storeToken, ScratchSpillPlan spillPlan,
      ArrayRef<OpOperand *> uses,
      const wave::WaveAMDPressureReliefPlan &reliefPlan,
      wave::WaveAMDPressureReliefMaterializationContext &context,
      OpBuilder &builder,
      const llvm::SmallDenseSet<Value, 8> &plannedValues) const {
    for (OpOperand *use : uses) {
      if (use->get() != value)
        continue;
      if (isInternalTupleFromElementsUse(use, plannedValues))
        continue;
      Operation *user = use->getOwner();
      builder.setInsertionPoint(user);
      FailureOr<ScratchLoadResult> load =
          loadSpillValue(getMemorySpillLoadType(value), storeToken, spillPlan,
                         reliefPlan, context, builder, user->getLoc(), user);
      if (failed(load))
        return failure();
      if (failed(replaceMemorySpillUseWithLoad(value, use, load->value,
                                               reliefPlan, context)))
        return failure();
    }
    return success();
  }

  LogicalResult
  materializeValue(Value value, ScratchSpillPlan plan,
                   const wave::WaveAMDPressureReliefPlan &reliefPlan,
                   wave::WaveAMDPressureReliefMaterializationContext &context,
                   OpBuilder &builder,
                   const llvm::SmallDenseSet<Value, 8> &plannedValues) const {
    SmallVector<OpOperand *> uses;
    if (!hasSimpleUses(value, uses)) {
      if (hasOnlyRegAllocTempUses(value))
        return success();
      return mlir::emitError(value.getLoc())
             << "waveamd-reg-alloc cannot materialize scratch spill for value";
    }

    FailureOr<Value> storeToken =
        materializeValueStoreToken(value, plan, reliefPlan, context, builder);
    if (failed(storeToken))
      return failure();
    return replaceValueUsesWithLoads(value, *storeToken, plan, uses, reliefPlan,
                                     context, builder, plannedValues);
  }

  FailureOr<Value>
  storeSpillValue(Value value, Value token, ScratchSpillPlan plan,
                  const wave::WaveAMDPressureReliefPlan &reliefPlan,
                  wave::WaveAMDPressureReliefMaterializationContext &context,
                  OpBuilder &builder, Location loc, Operation *diagOp) const {
    unsigned width = cast<waveamdmachine::RegType>(value.getType()).getWidth();
    recordVGPRSpillSave(width, builder);
    if (width > 1 && tupleFitsImmediate(plan.slotBase, width))
      return storeTupleValue(value, token, plan, reliefPlan, context, builder,
                             loc, diagOp);
    if (width > 1)
      return storeScalarizedValue(value, token, plan, reliefPlan, context,
                                  builder, loc, diagOp);
    return storeScalarValue(value, token, plan, reliefPlan, context, builder,
                            loc, diagOp);
  }

  FailureOr<ScratchLoadResult>
  loadSpillValue(Type type, Value token, ScratchSpillPlan plan,
                 const wave::WaveAMDPressureReliefPlan &reliefPlan,
                 wave::WaveAMDPressureReliefMaterializationContext &context,
                 OpBuilder &builder, Location loc, Operation *diagOp) const {
    unsigned width = cast<waveamdmachine::RegType>(type).getWidth();
    waveamdmachine::RegClass regClass =
        cast<waveamdmachine::RegType>(type).getRegClass();
    FailureOr<waveamdmachine::RegType> assignedType =
        consumePressureReliefTempRegType(reliefPlan, context, regClass, width,
                                         diagOp);
    if (failed(assignedType))
      return failure();
    if (width > 1 && tupleFitsImmediate(plan.slotBase, width))
      return loadTupleValue(*assignedType, token, plan, reliefPlan, context,
                            builder, loc, diagOp);
    if (width > 1)
      return loadScalarizedValue(*assignedType, token, plan, reliefPlan,
                                 context, builder, loc, diagOp);
    return loadScalarValue(*assignedType, token, plan, reliefPlan, context,
                           builder, loc, diagOp);
  }

  FailureOr<Value>
  storeScalarValue(Value value, Value token, ScratchSpillPlan plan,
                   const wave::WaveAMDPressureReliefPlan &reliefPlan,
                   wave::WaveAMDPressureReliefMaterializationContext &context,
                   OpBuilder &builder, Location loc, Operation *diagOp) const {
    return storeScalarValue(value, token, plan.slotBase, reliefPlan, context,
                            builder, loc, diagOp);
  }

  FailureOr<Value>
  storeScalarValue(Value value, Value token, unsigned byteOffset,
                   const wave::WaveAMDPressureReliefPlan &reliefPlan,
                   wave::WaveAMDPressureReliefMaterializationContext &context,
                   OpBuilder &builder, Location loc, Operation *diagOp) const {
    Type tokenType = waveamdmachine::MemTokenType::get(builder.getContext());
    Value storeVaddr;
    Value storeSaddr;
    int64_t storeOffset = 0;
    if (failed(materializeAddress(builder, loc, byteOffset, storeVaddr,
                                  storeSaddr, storeOffset, reliefPlan, context,
                                  diagOp)))
      return failure();
    waveamdmachine::ScratchStoreB32Op store =
        waveamdmachine::ScratchStoreB32Op::create(builder, loc, tokenType,
                                                  storeVaddr, value, storeSaddr,
                                                  token, storeOffset);
    store->setAttr(kRegAllocTempAttr, builder.getUnitAttr());
    return store.getToken();
  }

  FailureOr<ScratchLoadResult>
  loadScalarValue(Type type, Value token, ScratchSpillPlan plan,
                  const wave::WaveAMDPressureReliefPlan &reliefPlan,
                  wave::WaveAMDPressureReliefMaterializationContext &context,
                  OpBuilder &builder, Location loc, Operation *diagOp) const {
    return loadScalarValue(type, token, plan.slotBase, reliefPlan, context,
                           builder, loc, diagOp);
  }

  FailureOr<ScratchLoadResult>
  loadScalarValue(Type type, Value token, unsigned byteOffset,
                  const wave::WaveAMDPressureReliefPlan &reliefPlan,
                  wave::WaveAMDPressureReliefMaterializationContext &context,
                  OpBuilder &builder, Location loc, Operation *diagOp) const {
    Type tokenType = waveamdmachine::MemTokenType::get(builder.getContext());
    Value loadVaddr;
    Value loadSaddr;
    int64_t loadOffset = 0;
    if (failed(materializeAddress(builder, loc, byteOffset, loadVaddr,
                                  loadSaddr, loadOffset, reliefPlan, context,
                                  diagOp)))
      return failure();
    waveamdmachine::ScratchLoadB32Op load =
        waveamdmachine::ScratchLoadB32Op::create(builder, loc, type, tokenType,
                                                 loadVaddr, loadSaddr, token,
                                                 loadOffset);
    load->setAttr(kRegAllocTempAttr, builder.getUnitAttr());
    return ScratchLoadResult{load.getResult(), load.getToken()};
  }

  FailureOr<Value> storeScalarizedValue(
      Value value, Value token, ScratchSpillPlan plan,
      const wave::WaveAMDPressureReliefPlan &reliefPlan,
      wave::WaveAMDPressureReliefMaterializationContext &context,
      OpBuilder &builder, Location loc, Operation *diagOp) const {
    Type tokenType = waveamdmachine::MemTokenType::get(builder.getContext());
    SmallVector<Value> elements = splitMemorySpillValue(value, builder, loc);
    SmallVector<Value> tokens;
    tokens.reserve(elements.size());
    for (auto [index, element] : llvm::enumerate(elements)) {
      FailureOr<Value> stored = storeScalarValue(
          element, token, plan.slotBase + static_cast<unsigned>(index) * 4,
          reliefPlan, context, builder, loc, diagOp);
      if (failed(stored))
        return failure();
      tokens.push_back(*stored);
    }
    return joinMemorySpillTokens(tokenType, tokens, builder, loc);
  }

  FailureOr<ScratchLoadResult> loadScalarizedValue(
      Type type, Value token, ScratchSpillPlan plan,
      const wave::WaveAMDPressureReliefPlan &reliefPlan,
      wave::WaveAMDPressureReliefMaterializationContext &context,
      OpBuilder &builder, Location loc, Operation *diagOp) const {
    Type tokenType = waveamdmachine::MemTokenType::get(builder.getContext());
    SmallVector<Type> elementTypes = getMemorySpillScalarRegTypes(type);
    SmallVector<Value> elements;
    SmallVector<Value> tokens;
    elements.reserve(elementTypes.size());
    tokens.reserve(elementTypes.size());
    for (auto [index, elementType] : llvm::enumerate(elementTypes)) {
      FailureOr<ScratchLoadResult> load = loadScalarValue(
          elementType, token, plan.slotBase + static_cast<unsigned>(index) * 4,
          reliefPlan, context, builder, loc, diagOp);
      if (failed(load))
        return failure();
      elements.push_back(load->value);
      tokens.push_back(load->token);
    }
    return ScratchLoadResult{
        joinMemorySpillValue(type, elements, builder, loc),
        joinMemorySpillTokens(tokenType, tokens, builder, loc)};
  }

  FailureOr<Value>
  storeTupleValue(Value value, Value token, ScratchSpillPlan plan,
                  const wave::WaveAMDPressureReliefPlan &reliefPlan,
                  wave::WaveAMDPressureReliefMaterializationContext &context,
                  OpBuilder &builder, Location loc, Operation *diagOp) const {
    Type tokenType = waveamdmachine::MemTokenType::get(builder.getContext());
    Value storeVaddr;
    Value storeSaddr;
    int64_t storeOffset = 0;
    if (failed(materializeAddress(builder, loc, plan.slotBase, storeVaddr,
                                  storeSaddr, storeOffset, reliefPlan, context,
                                  diagOp)))
      return failure();
    waveamdmachine::ScratchStoreTupleB32Op store =
        waveamdmachine::ScratchStoreTupleB32Op::create(
            builder, loc, tokenType, storeVaddr, value, storeSaddr, token,
            storeOffset);
    store->setAttr(kRegAllocTempAttr, builder.getUnitAttr());
    return store.getToken();
  }

  FailureOr<ScratchLoadResult>
  loadTupleValue(Type type, Value token, ScratchSpillPlan plan,
                 const wave::WaveAMDPressureReliefPlan &reliefPlan,
                 wave::WaveAMDPressureReliefMaterializationContext &context,
                 OpBuilder &builder, Location loc, Operation *diagOp) const {
    Type tokenType = waveamdmachine::MemTokenType::get(builder.getContext());
    Value loadVaddr;
    Value loadSaddr;
    int64_t loadOffset = 0;
    if (failed(materializeAddress(builder, loc, plan.slotBase, loadVaddr,
                                  loadSaddr, loadOffset, reliefPlan, context,
                                  diagOp)))
      return failure();
    waveamdmachine::ScratchLoadTupleB32Op load =
        waveamdmachine::ScratchLoadTupleB32Op::create(
            builder, loc, type, tokenType, loadVaddr, loadSaddr, token,
            loadOffset);
    load->setAttr(kRegAllocTempAttr, builder.getUnitAttr());
    return ScratchLoadResult{load.getResult(), load.getToken()};
  }

  void reserveSlot(const ScratchSpillPlan &plan, OpBuilder &builder) const {
    assert(plan.slotBytes % 4 == 0 && "scratch spill slots are dwords");
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

  void recordVGPRSpillSave(unsigned dwords, OpBuilder &builder) const {
    unsigned spilledVGPRs =
        getUnsignedAttr(func, kVGPRSpillCountAttr).value_or(0);
    func->setAttr(kVGPRSpillCountAttr,
                  builder.getI64IntegerAttr(spilledVGPRs + dwords));
  }

  mutable std::string planRejectReason;
  ArrayRef<IntervalGroup *> groups;
  Inventory &inventory;
  func::FuncOp func;
  IntervalGroup *request = nullptr;
  unsigned position = 0;
  mutable const PressureFailure *pressureFailure = nullptr;
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
