//===- WaveAMDRegAllocLDS.cpp - LDS spill planning ------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "WaveAMDRegAllocInternal.h"
#include "WaveAMDRegAllocMemorySpillDiagnostics.h"

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

static bool canFoldSlotBaseIntoDSOffset(unsigned slotBase) {
  std::pair<int64_t, int64_t> range = waveamdmachine::instOffsetRange(
      waveamdmachine::DsStoreB32Op::getAddressFieldSpec());
  return slotBase >= static_cast<uint64_t>(range.first) &&
         slotBase <= static_cast<uint64_t>(range.second);
}

static unsigned getAddressOpsPerAccess(const LDSSpillPlan &plan) {
  return canFoldSlotBaseIntoDSOffset(plan.slotBase) ? 1 : 2;
}

using LDSLoadResult = MemorySpillLoadResult;
using LoopCarrySlot = MemorySpillLoopCarrySlot;

static unsigned getTotalLDSSlotBytes(ArrayRef<LDSSpillPlan> plans) {
  unsigned total = 0;
  for (LDSSpillPlan plan : plans)
    total += plan.slotBytes;
  return total;
}

struct LDSMemorySpillTraits {
  using SlotPlan = SmallVector<LDSSpillPlan, 4>;

  static constexpr wave::WaveAMDPressureReliefProviderKind providerKind =
      wave::WaveAMDPressureReliefProviderKind::LDSSpill;

  static StringRef getProviderName() { return "lds-spill"; }

  static unsigned getSlotBase(ArrayRef<LDSSpillPlan> plans) {
    assert(!plans.empty() && "LDS spill needs a slot");
    return plans.front().slotBase;
  }

  static unsigned getSlotBytes(ArrayRef<LDSSpillPlan> plans) {
    return getTotalLDSSlotBytes(plans);
  }

  static unsigned
  getTotalSlotBytes(ArrayRef<MemorySpillValueSlot<SlotPlan>> slots) {
    unsigned total = 0;
    for (const MemorySpillValueSlot<SlotPlan> &slot : slots)
      total += getSlotBytes(slot.plan);
    return total;
  }
};

using LDSValueSlot = MemorySpillValueSlot<LDSMemorySpillTraits::SlotPlan>;
using LDSPressurePlan = MemorySpillPressurePlan<LDSMemorySpillTraits>;
using LDSSpillCandidate = MemorySpillCandidate<LDSMemorySpillTraits>;

static LoopCarrySlot getPlanLoopCarrySlot(const LDSPressurePlan &spill) {
  std::optional<LoopCarrySlot> slot = spill.getLoopCarry();
  assert(slot && "expected loop-carry LDS spill");
  return *slot;
}

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

  bool hasRegAllocState() const override {
    return func->hasAttr(kLDSSpillBytesAttr);
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

  void collectPlanTempIntervals(
      const wave::WaveAMDPressureReliefPlan &plan,
      SmallVectorImpl<wave::WaveAMDPressureReliefTempInterval> &intervals)
      const override {
    const LDSPressurePlan &spill = static_cast<const LDSPressurePlan &>(plan);
    if (std::optional<LoopCarrySlot> loopCarry = spill.getLoopCarry()) {
      assert(!spill.getValueSlots().empty() &&
             "loop-carry LDS spill needs a value slot");
      const LDSValueSlot &slot = spill.getValueSlots().front();
      collectMemorySpillLoopCarryTempIntervals(
          inventory, *loopCarry, slot.value, slot.type, intervals,
          [&](SmallVectorImpl<wave::WaveAMDPressureReliefTempInterval>
                  &intervals,
              unsigned position, unsigned valueWidth) {
            collectAddressTemps(intervals, position, slot.plan, valueWidth);
          });
      return;
    }
    for (const LDSValueSlot &slot : spill.getValueSlots())
      collectMemorySpillSlotTempIntervals(
          inventory, slot, intervals,
          [&](SmallVectorImpl<wave::WaveAMDPressureReliefTempInterval>
                  &intervals,
              unsigned position, ArrayRef<LDSSpillPlan> plans,
              unsigned valueWidth) {
            collectAddressTemps(intervals, position, plans, valueWidth);
          });
  }

  LogicalResult
  materializePlan(const wave::WaveAMDPressureReliefPlan &plan,
                  wave::WaveAMDPressureReliefMaterializationContext &context,
                  OpBuilder &builder) const override {
    const LDSPressurePlan &spill = static_cast<const LDSPressurePlan &>(plan);
    if (spill.getLoopCarry()) {
      SmallVector<const LDSPressurePlan *, 1> spills{&spill};
      return materializeLoopCarryPlans(spills, context, builder);
    }
    return materializeWholeAliasSetMemorySpillPlan(
        inventory, spill, builder,
        [&](const LDSValueSlot &slot,
            const llvm::SmallDenseSet<Value, 8> &plannedValues) {
          return materializeMemorySpillValue(
              inventory, slot.value, slot.type, slot.plan, plan, context,
              builder, getName(), plannedValues,
              [&](Value value, Value token, ArrayRef<LDSSpillPlan> slotPlan,
                  const wave::WaveAMDPressureReliefPlan &reliefPlan,
                  wave::WaveAMDPressureReliefMaterializationContext &context,
                  OpBuilder &builder, Location loc, Operation *diagOp) {
                return storeSpillValue(value, token, slotPlan, reliefPlan,
                                       context, builder, loc, diagOp);
              },
              [&](Type type, Value token, ArrayRef<LDSSpillPlan> slotPlan,
                  const wave::WaveAMDPressureReliefPlan &reliefPlan,
                  wave::WaveAMDPressureReliefMaterializationContext &context,
                  OpBuilder &builder, Location loc,
                  Operation *diagOp) -> FailureOr<MemorySpillLoadResult> {
                return loadSpillValue(type, token, slotPlan, reliefPlan,
                                      context, builder, loc, diagOp);
              });
        },
        [&](const LDSValueSlot &slot) { reserveSlots(slot.plan, builder); });
  }

  LogicalResult
  materializePlans(ArrayRef<const wave::WaveAMDPressureReliefPlan *> plans,
                   wave::WaveAMDPressureReliefMaterializationContext &context,
                   OpBuilder &builder) const override {
    SmallVector<SmallVector<const LDSPressurePlan *, 2>, 8> loopGroups;
    for (const wave::WaveAMDPressureReliefPlan *plan : plans) {
      const LDSPressurePlan &spill =
          static_cast<const LDSPressurePlan &>(*plan);
      if (!spill.getLoopCarry()) {
        if (failed(materializePlan(*plan, context, builder)))
          return failure();
        continue;
      }
      if (failed(appendLoopCarryPlanGroup(spill, loopGroups)))
        return failure();
    }
    sortLoopCarryPlanGroups(loopGroups);
    return materializeLoopCarryPlanGroups(loopGroups, context, builder);
  }

  void emitRemarks() const override {
    func::FuncOp func = this->func;
    unsigned reservedBytes =
        getUnsignedAttr(func.getOperation(), kLDSSpillBytesAttr).value_or(0);
    LDSSpillPlan plan =
        planLDSSpillSlot(func, budgets, /*valueBytes=*/4, reservedBytes);
    if (plan.status == LDSSpillPlanStatus::NotKernel)
      return;
    auto remark = mlir::remark::analysis(
        func.getLoc(), getWaveAMDRegAllocRemarkOpts(func, "regalloc-lds-plan"));
    if (!remark)
      return;
    emitRegAllocIntegerMetric(remark, "existing_dynamic_bytes",
                              plan.existingDynamicBytes);
    emitRegAllocIntegerMetric(remark, "existing_fixed_bytes",
                              plan.existingFixedBytes);
    emitRegAllocIntegerMetric(remark, "reserved_spill_bytes",
                              plan.reservedSpillBytes);
    emitRegAllocStringMetric(remark, "status",
                             getLDSSpillPlanStatusName(plan.status));
    emitRegAllocIntegerMetric(remark, "value_bytes", plan.valueBytes);
    if (plan.wavefrontSize == 0)
      return;
    emitRegAllocIntegerMetric(remark, "available_bytes", plan.availableBytes);
    emitRegAllocIntegerMetric(remark, "limit_bytes", plan.limitBytes);
    emitRegAllocIntegerMetric(remark, "slot_base", plan.slotBase);
    emitRegAllocIntegerMetric(remark, "slot_bytes", plan.slotBytes);
    emitRegAllocIntegerMetric(remark, "wave_stride", plan.waveStride);
    emitRegAllocIntegerMetric(remark, "wavefront_size", plan.wavefrontSize);
    emitRegAllocIntegerMetric(remark, "waves_per_workgroup",
                              plan.wavesPerWorkgroup);
  }

  bool isBetterCandidate(
      const wave::WaveAMDPressureReliefCandidate &lhs,
      const wave::WaveAMDPressureReliefCandidate &rhs) const override {
    return isBetterMemorySpillCandidate<LDSSpillCandidate>(lhs, rhs);
  }

  std::optional<StringRef> getRejectReason() const override {
    if (!planRejectReason.empty())
      return StringRef(planRejectReason);
    return std::nullopt;
  }

  void collectFailureDiagnostics(
      SmallVectorImpl<wave::WaveAMDPressureReliefProviderDiagnostic>
          &diagnostics) const override {
    collectMemorySpillRejectDiagnostics(diagnostics, groups, request, position,
                                        getRejectReason());
  }

private:
  static std::optional<unsigned> getUnsignedAttr(Operation *op, StringRef name);

  static unsigned getAddressTempCount(ArrayRef<LDSSpillPlan> plans) {
    unsigned total = 0;
    for (LDSSpillPlan plan : plans)
      total += getAddressOpsPerAccess(plan);
    return total;
  }

  void collectAddressTemps(
      SmallVectorImpl<wave::WaveAMDPressureReliefTempInterval> &intervals,
      unsigned position, ArrayRef<LDSSpillPlan> plans, unsigned) const {
    if (getAddressTempCount(plans) != 0) {
      wave::WaveAMDPressureReliefTempInterval workitem;
      workitem.fixedBase = inventory.entryRegs.workitemIdXVGPR;
      workitem.regClass = waveamdmachine::RegClass::VGPR;
      workitem.start = 0;
      workitem.end = position;
      workitem.width = 1;
      intervals.push_back(workitem);
    }
    for ([[maybe_unused]] unsigned index :
         llvm::seq<unsigned>(0, getAddressTempCount(plans)))
      appendMemorySpillPointTemp(intervals, waveamdmachine::RegClass::VGPR,
                                 position, /*width=*/1);
  }

  void setPlanRejectReason(LDSSpillPlanStatus status) const {
    planRejectReason = "lds_spill_";
    planRejectReason += getLDSSpillPlanStatusName(status);
  }

  static bool isEligibleGroup(IntervalGroup *group, unsigned position) {
    return isMemorySpillProviderEligibleGroup(group, position);
  }

  static bool isCandidateGroup(IntervalGroup *group, unsigned position) {
    return isMemorySpillProviderCandidateGroup(group, position);
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
    wave::WaveAMDPressureReliefCost cost;
    cost.materializationOps = opCount;
    addLoopScaledCost(cost, slot.loop,
                      static_cast<int64_t>(opCount) * useCount);
    addLoopScaledLatency(cost, slot.loop,
                         static_cast<int64_t>(plans.size()) * useCount * 2);
    return cost;
  }

  wave::WaveAMDPressureReliefCost
  getValueSpillCost(Value value, ArrayRef<LDSSpillPlan> plans,
                    ArrayRef<OpOperand *> uses) const {
    unsigned opCount = getLDSMaterializationOps(plans);
    wave::WaveAMDPressureReliefCost cost;
    addLoopScaledCost(cost, getMemorySpillValueAnchorOp(value), opCount);
    for (OpOperand *use : uses) {
      addLoopScaledCost(cost, use->getOwner(), opCount);
      addLoopScaledLatency(cost, use->getOwner(),
                           static_cast<int64_t>(plans.size()) * 2);
    }
    return cost;
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
    return planLDSSpillSlot(func, budgets, valueBytes, reservedBytes, fixedLDS,
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
    if (!type || !isMemorySpillProviderRegClass(type.getRegClass()) ||
        type.getWidth() == 0)
      return failure();
    SmallVector<OpOperand *> uses;
    if (!collectSimpleMemorySpillUses(value, inventory, uses))
      return failure();
    std::optional<SmallVector<LDSSpillPlan, 4>> plans =
        getPlansForValue(type, extraReservedBytes);
    if (!plans)
      return failure();
    return LDSValueSlot{value, type, *plans,
                        getValueSpillCost(value, *plans, uses),
                        static_cast<unsigned>(uses.size())};
  }

  FailureOr<LDSValueSlot> getLoopCarryValueSlot(LoopCarrySlot loopCarry,
                                                Value init,
                                                waveamdmachine::RegType type,
                                                unsigned useCount) const {
    std::optional<SmallVector<LDSSpillPlan, 4>> plans = getPlansForValue(type);
    if (!plans)
      return failure();
    wave::WaveAMDPressureReliefCost cost =
        getLoopCarrySpillCost(loopCarry, *plans, useCount);
    return LDSValueSlot{init, type, *plans, cost, useCount};
  }

  void collectGroupValue(
      IntervalGroup *group,
      wave::WaveAMDPressureReliefCandidateList &candidates) const {
    collectMemorySpillCandidate<LDSMemorySpillTraits>(
        group, position, inventory, candidates,
        [&](Value value, unsigned extraReservedBytes) {
          return getGroupValueSlot(value, extraReservedBytes);
        },
        [&](LoopCarrySlot loopCarry, Value init, waveamdmachine::RegType type,
            unsigned useCount) {
          return getLoopCarryValueSlot(loopCarry, init, type, useCount);
        });
  }

  void collect(IntervalGroup *group,
               wave::WaveAMDPressureReliefCandidateList &candidates) const {
    if (!isCandidateGroup(group, position))
      return;
    if (!isEligibleGroup(group, position))
      return;
    collectGroupValue(group, candidates);
  }

  Value createImm(OpBuilder &builder, Location loc, int64_t value) const {
    return waveamdmachine::ImmOp::create(
        builder, loc, waveamdmachine::ImmType::get(builder.getContext()),
        static_cast<uint64_t>(value));
  }

  FailureOr<std::pair<Value, int64_t>>
  materializeAddress(OpBuilder &builder, Location loc, const LDSSpillPlan &plan,
                     const wave::WaveAMDPressureReliefPlan &reliefPlan,
                     wave::WaveAMDPressureReliefMaterializationContext &context,
                     Operation *diagOp) const {
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
    FailureOr<waveamdmachine::RegType> addrType =
        consumePressureReliefTempRegType(reliefPlan, context,
                                         waveamdmachine::RegClass::VGPR,
                                         /*width=*/1, diagOp);
    if (failed(addrType))
      return failure();
    waveamdmachine::VLshlrevB32Op addr = waveamdmachine::VLshlrevB32Op::create(
        builder, loc, *addrType, workitem,
        createImm(builder, loc, llvm::Log2_32(plan.valueBytes)));
    addr->setAttr(kRegAllocTempAttr, builder.getUnitAttr());
    if (canFoldSlotBaseIntoDSOffset(plan.slotBase))
      return std::make_pair(addr.getResult(),
                            static_cast<int64_t>(plan.slotBase));

    FailureOr<waveamdmachine::RegType> fullAddrType =
        consumePressureReliefTempRegType(reliefPlan, context,
                                         waveamdmachine::RegClass::VGPR,
                                         /*width=*/1, diagOp);
    if (failed(fullAddrType))
      return failure();
    waveamdmachine::VAddU32Op fullAddr = waveamdmachine::VAddU32Op::create(
        builder, loc, *fullAddrType, addr.getResult(),
        createImm(builder, loc, plan.slotBase));
    fullAddr->setAttr(kRegAllocTempAttr, builder.getUnitAttr());
    return std::make_pair(fullAddr.getResult(), int64_t{0});
  }

  Value findWorkitemId(OpBuilder &builder) const {
    Block *block = builder.getInsertionBlock();
    if (!block)
      return {};
    Block::iterator stop = builder.getInsertionPoint();
    if (Value workitem = findWorkitemIdBefore(block, stop))
      return workitem;
    if (Value workitem = moveWorkitemIdBefore(block, stop, builder))
      return workitem;
    while (block) {
      Operation *parent = block->getParentOp();
      if (!parent)
        return {};
      block = parent->getBlock();
      if (!block)
        return {};
      stop = parent->getIterator();
      if (Value workitem = findWorkitemIdBefore(block, stop))
        return workitem;
    }
    return {};
  }

  waveamdmachine::VWorkitemIdXOp getEntryWorkitemId(Operation &op) const {
    waveamdmachine::VWorkitemIdXOp workitem =
        dyn_cast<waveamdmachine::VWorkitemIdXOp>(&op);
    if (!workitem)
      return {};
    waveamdmachine::RegType type =
        cast<waveamdmachine::RegType>(workitem.getType());
    if (type.getIndex() != inventory.entryRegs.workitemIdXVGPR)
      return {};
    return workitem;
  }

  Value findWorkitemIdBefore(Block *block, Block::iterator stop) const {
    for (auto it = block->begin(); it != stop; ++it) {
      Operation &op = *it;
      waveamdmachine::VWorkitemIdXOp workitem = getEntryWorkitemId(op);
      if (workitem)
        return workitem.getResult();
    }
    return {};
  }

  Value moveWorkitemIdBefore(Block *block, Block::iterator stop,
                             OpBuilder &builder) const {
    for (auto it = stop; it != block->end(); ++it) {
      Operation &op = *it;
      waveamdmachine::VWorkitemIdXOp workitem = getEntryWorkitemId(op);
      if (!workitem)
        continue;
      workitem->moveBefore(block, stop);
      builder.setInsertionPointAfter(workitem);
      return workitem.getResult();
    }
    return {};
  }

  FailureOr<Value>
  storeScalarValue(Value value, Value token, LDSSpillPlan plan,
                   const wave::WaveAMDPressureReliefPlan &reliefPlan,
                   wave::WaveAMDPressureReliefMaterializationContext &context,
                   OpBuilder &builder, Location loc, Operation *diagOp) const {
    Type tokenType = waveamdmachine::MemTokenType::get(builder.getContext());
    FailureOr<std::pair<Value, int64_t>> addr =
        materializeAddress(builder, loc, plan, reliefPlan, context, diagOp);
    if (failed(addr))
      return failure();
    waveamdmachine::DsStoreB32Op store = waveamdmachine::DsStoreB32Op::create(
        builder, loc, tokenType, addr->first, value, token, addr->second);
    store->setAttr(kRegAllocTempAttr, builder.getUnitAttr());
    return store.getToken();
  }

  FailureOr<LDSLoadResult>
  loadScalarValue(Type type, Value token, LDSSpillPlan plan,
                  const wave::WaveAMDPressureReliefPlan &reliefPlan,
                  wave::WaveAMDPressureReliefMaterializationContext &context,
                  OpBuilder &builder, Location loc, Operation *diagOp) const {
    Type tokenType = waveamdmachine::MemTokenType::get(builder.getContext());
    FailureOr<std::pair<Value, int64_t>> addr =
        materializeAddress(builder, loc, plan, reliefPlan, context, diagOp);
    if (failed(addr))
      return failure();
    waveamdmachine::DsLoadB32Op load = waveamdmachine::DsLoadB32Op::create(
        builder, loc, type, tokenType, addr->first, token, addr->second);
    load->setAttr(kRegAllocTempAttr, builder.getUnitAttr());
    return LDSLoadResult{load.getResult(), load.getToken()};
  }

  FailureOr<Value>
  storeSpillValue(Value value, Value token, ArrayRef<LDSSpillPlan> plans,
                  const wave::WaveAMDPressureReliefPlan &reliefPlan,
                  wave::WaveAMDPressureReliefMaterializationContext &context,
                  OpBuilder &builder, Location loc, Operation *diagOp) const {
    unsigned width = cast<waveamdmachine::RegType>(value.getType()).getWidth();
    assert(width == plans.size() && "LDS plans must match value width");
    if (width == 1)
      return storeScalarValue(value, token, plans.front(), reliefPlan, context,
                              builder, loc, diagOp);

    Type tokenType = waveamdmachine::MemTokenType::get(builder.getContext());
    SmallVector<Value> elements = splitMemorySpillValue(value, builder, loc);
    SmallVector<Value> tokens;
    tokens.reserve(elements.size());
    for (auto [index, element] : llvm::enumerate(elements)) {
      FailureOr<Value> stored =
          storeScalarValue(element, token, plans[index], reliefPlan, context,
                           builder, loc, diagOp);
      if (failed(stored))
        return failure();
      tokens.push_back(*stored);
    }
    return joinMemorySpillTokens(tokenType, tokens, builder, loc);
  }

  FailureOr<LDSLoadResult>
  loadSpillValue(Type type, Value token, ArrayRef<LDSSpillPlan> plans,
                 const wave::WaveAMDPressureReliefPlan &reliefPlan,
                 wave::WaveAMDPressureReliefMaterializationContext &context,
                 OpBuilder &builder, Location loc, Operation *diagOp) const {
    unsigned width = cast<waveamdmachine::RegType>(type).getWidth();
    assert(width == plans.size() && "LDS plans must match value width");
    waveamdmachine::RegClass regClass =
        cast<waveamdmachine::RegType>(type).getRegClass();
    FailureOr<waveamdmachine::RegType> assignedType =
        consumePressureReliefTempRegType(reliefPlan, context, regClass, width,
                                         diagOp);
    if (failed(assignedType))
      return failure();
    if (width == 1)
      return loadScalarValue(*assignedType, token, plans.front(), reliefPlan,
                             context, builder, loc, diagOp);

    Type tokenType = waveamdmachine::MemTokenType::get(builder.getContext());
    SmallVector<Type> elementTypes =
        getMemorySpillScalarRegTypes(*assignedType);
    SmallVector<Value> elements;
    SmallVector<Value> tokens;
    elements.reserve(elementTypes.size());
    tokens.reserve(elementTypes.size());
    for (auto [index, elementType] : llvm::enumerate(elementTypes)) {
      FailureOr<LDSLoadResult> load =
          loadScalarValue(elementType, token, plans[index], reliefPlan, context,
                          builder, loc, diagOp);
      if (failed(load))
        return failure();
      elements.push_back(load->value);
      tokens.push_back(load->token);
    }
    return LDSLoadResult{
        joinMemorySpillValue(*assignedType, elements, builder, loc),
        joinMemorySpillTokens(tokenType, tokens, builder, loc)};
  }

  LogicalResult materializeLoopCarryPlans(
      ArrayRef<const LDSPressurePlan *> spills,
      wave::WaveAMDPressureReliefMaterializationContext &context,
      OpBuilder &builder) const {
    for (const LDSPressurePlan *spill : spills)
      if (failed(getCurrentPlanLoopCarrySlot(*spill)))
        return failure();
    auto getSlot = [&](const LDSPressurePlan &spill) {
      FailureOr<LoopCarrySlot> slot = getCurrentPlanLoopCarrySlot(spill);
      assert(succeeded(slot) && "expected resolved loop-carry LDS spill");
      return *slot;
    };
    auto prepareStoreValue = [&](Value value, const LDSPressurePlan &spill,
                                 OpBuilder &builder,
                                 Operation *diagOp) -> FailureOr<Value> {
      waveamdmachine::RegType type = spill.getValueSlots().front().type;
      return materializeMemorySpillStoreInput(inventory, value, type, spill,
                                              context, builder, diagOp);
    };
    auto storeValue = [&](Value value, Value token,
                          const LDSPressurePlan &spill, OpBuilder &builder,
                          Location loc, Operation *diagOp) -> FailureOr<Value> {
      return storeSpillValue(value, token, spill.getPlan(), spill, context,
                             builder, loc, diagOp);
    };
    auto loadValue =
        [&](Type type, Value token, const LDSPressurePlan &spill,
            OpBuilder &builder, Location loc,
            Operation *diagOp) -> FailureOr<MemorySpillLoadResult> {
      return loadSpillValue(type, token, spill.getPlan(), spill, context,
                            builder, loc, diagOp);
    };
    auto copyInitValue =
        [&](Value init, Value token, const LDSPressurePlan &spill,
            OpBuilder &builder, Location loc,
            Operation *diagOp) -> FailureOr<MemorySpillLoadResult> {
      Type type = spill.getValueSlots().front().type;
      return loadSpillValue(type, token, spill.getPlan(), spill, context,
                            builder, loc, diagOp);
    };
    auto reserve = [&](const LDSPressurePlan &spill, OpBuilder &builder) {
      reserveSlots(spill.getPlan(), builder);
    };
    return materializeMemorySpillLoopCarryPlans<LDSPressurePlan>(
        spills, inventory, builder, getName(), getSlot, prepareStoreValue,
        storeValue, loadValue, copyInitValue, reserve);
  }

  LogicalResult appendLoopCarryPlanGroup(
      const LDSPressurePlan &spill,
      SmallVectorImpl<SmallVector<const LDSPressurePlan *, 2>> &loopGroups)
      const {
    FailureOr<LoopCarrySlot> slot = getCurrentPlanLoopCarrySlot(spill);
    if (failed(slot))
      return failure();
    Operation *loop = slot->loop.getOperation();
    auto it = llvm::find_if(loopGroups, [&](const auto &group) {
      FailureOr<LoopCarrySlot> groupSlot =
          getCurrentPlanLoopCarrySlot(*group.front());
      assert(succeeded(groupSlot) && "expected resolved LDS loop group");
      return groupSlot->loop.getOperation() == loop;
    });
    if (it == loopGroups.end())
      loopGroups.push_back({&spill});
    else
      it->push_back(&spill);
    return success();
  }

  void sortLoopCarryPlanGroups(
      MutableArrayRef<SmallVector<const LDSPressurePlan *, 2>> loopGroups)
      const {
    llvm::stable_sort(loopGroups, [&](const auto &lhs, const auto &rhs) {
      FailureOr<LoopCarrySlot> lhsSlot =
          getCurrentPlanLoopCarrySlot(*lhs.front());
      FailureOr<LoopCarrySlot> rhsSlot =
          getCurrentPlanLoopCarrySlot(*rhs.front());
      assert(succeeded(lhsSlot) && succeeded(rhsSlot) &&
             "expected resolved LDS loop groups");
      return getLoopDepth(lhsSlot->loop) > getLoopDepth(rhsSlot->loop);
    });
  }

  LogicalResult materializeLoopCarryPlanGroups(
      ArrayRef<SmallVector<const LDSPressurePlan *, 2>> loopGroups,
      wave::WaveAMDPressureReliefMaterializationContext &context,
      OpBuilder &builder) const {
    for (ArrayRef<const LDSPressurePlan *> group : loopGroups)
      if (failed(materializeLoopCarryPlans(group, context, builder)))
        return failure();
    return success();
  }

  FailureOr<LoopCarrySlot>
  getCurrentPlanLoopCarrySlot(const LDSPressurePlan &spill) const {
    std::optional<LoopCarrySlot> slot =
        resolveLoopCarrySlot(getPlanLoopCarrySlot(spill), inventory);
    if (slot)
      return *slot;
    func::FuncOp op = func;
    op.emitError()
        << "waveamd-reg-alloc cannot materialize stale LDS loop-carry spill";
    return failure();
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
};

} // namespace

std::optional<unsigned> LDSSpillProvider::getUnsignedAttr(Operation *op,
                                                          StringRef name) {
  IntegerAttr attr = op->getAttrOfType<IntegerAttr>(name);
  if (!attr)
    return std::nullopt;
  int64_t value = attr.getInt();
  if (value < 0 ||
      static_cast<uint64_t>(value) > std::numeric_limits<unsigned>::max())
    return std::nullopt;
  return static_cast<unsigned>(value);
}

std::unique_ptr<wave::WaveAMDPressureReliefProvider>
mlir::wave::regalloc::createLDSSpillProvider(
    func::FuncOp func, ArrayRef<IntervalGroup *> groups, IntervalGroup *request,
    unsigned position, RegisterBudgets budgets, Inventory &inventory) {
  return std::make_unique<LDSSpillProvider>(func, groups, request, position,
                                            budgets, inventory);
}
