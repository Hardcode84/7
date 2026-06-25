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

using LDSLoadResult = MemorySpillLoadResult;

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
    return materializeWholeAliasSetMemorySpillPlan(
        inventory, spill, builder,
        [&](const LDSValueSlot &slot,
            const llvm::SmallDenseSet<Value, 8> &plannedValues) {
          return materializeMemorySpillValue(
              inventory, slot.value, slot.plan, plan, context, builder,
              getName(), plannedValues,
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

  wave::WaveAMDPressureReliefCost
  getValueSpillCost(Value value, ArrayRef<LDSSpillPlan> plans,
                    ArrayRef<OpOperand *> uses) const {
    unsigned opCount = getLDSMaterializationOps(plans);
    wave::WaveAMDPressureReliefCost cost;
    cost.materializationOps = static_cast<int64_t>(opCount) * (1 + uses.size());
    cost.loopWeightedOps = static_cast<int64_t>(opCount) *
                           getLoopDepth(getMemorySpillValueAnchorOp(value));
    for (OpOperand *use : uses)
      cost.loopWeightedOps +=
          static_cast<int64_t>(opCount) * getLoopDepth(use->getOwner());
    cost.latencyPenalty = static_cast<int64_t>(plans.size()) * uses.size() * 2;
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
    return LDSValueSlot{value, *plans, getValueSpillCost(value, *plans, uses),
                        static_cast<unsigned>(uses.size())};
  }

  void collectGroupValue(
      IntervalGroup *group,
      wave::WaveAMDPressureReliefCandidateList &candidates) const {
    collectWholeAliasSetMemorySpillCandidate<LDSMemorySpillTraits>(
        group, position, inventory, candidates,
        [&](Value value, unsigned extraReservedBytes) {
          return getGroupValueSlot(value, extraReservedBytes);
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
