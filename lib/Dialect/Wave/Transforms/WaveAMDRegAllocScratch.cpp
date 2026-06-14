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

static std::optional<unsigned> getUnsignedAttr(Operation *op, StringRef name);
static unsigned getPrivateSegmentBytes(func::FuncOp func,
                                       unsigned reservedBytes);
static ScratchSpillPlan buildScratchSpillPlan(func::FuncOp func,
                                              unsigned valueBytes,
                                              unsigned reservedSpillBytes,
                                              unsigned existingBytes);

static bool isCheapVGPRExpr(Operation *op) {
  return isa_and_nonnull<
      waveamdmachine::VWorkitemIdXOp, waveamdmachine::VMovB32TupleOp,
      waveamdmachine::VLshrrevB32Op, waveamdmachine::VLshlrevB32Op,
      waveamdmachine::VLshlAddU32Op, waveamdmachine::VAddU32Op,
      waveamdmachine::VAdd3U32Op, waveamdmachine::VAndB32Op,
      waveamdmachine::VXorB32Op, waveamdmachine::VAndOrB32Op>(op);
}

struct ScratchLoadResult {
  Value value;
  Value token;
};

struct LoopCarrySlot {
  waveamdmachine::UniformLoopOp loop;
  unsigned index = 0;
};

class ScratchSpillCandidate final
    : public wave::WaveAMDPressureReliefCandidate {
public:
  ScratchSpillCandidate(IntervalGroup *group, Value value,
                        ScratchSpillPlan plan, unsigned useCount,
                        unsigned pressureRelief,
                        StringRef rejectReason = StringRef())
      : rejectReason(rejectReason.str()), plan(plan), group(group),
        value(value), useCount(useCount), pressureRelief(pressureRelief) {}

  ScratchSpillCandidate(IntervalGroup *group, LoopCarrySlot slot,
                        ScratchSpillPlan plan, unsigned useCount,
                        unsigned pressureRelief)
      : plan(plan), group(group), loopCarry(slot), useCount(useCount),
        pressureRelief(pressureRelief) {}

  StringRef getProviderName() const override { return "scratch-spill"; }

  wave::WaveAMDPressureReliefCost getCost() const override {
    wave::WaveAMDPressureReliefCost cost;
    cost.materializationOps = 2 + static_cast<int64_t>(useCount);
    cost.latencyPenalty = static_cast<int64_t>(useCount) * 8;
    return cost;
  }

  unsigned getReliefDwords() const override { return pressureRelief; }

  std::optional<StringRef> getRejectReason() const override {
    if (rejectReason.empty())
      return std::nullopt;
    return StringRef(rejectReason);
  }

  IntervalGroup *getGroup() const { return group; }
  std::optional<LoopCarrySlot> getLoopCarry() const { return loopCarry; }
  ScratchSpillPlan getPlan() const { return plan; }
  unsigned getUseCount() const { return useCount; }
  Value getValue() const { return value; }
  std::unique_ptr<wave::WaveAMDPressureReliefPlan> getPlannedSpill() const {
    PlannedMemorySpill spill;
    spill.kind = loopCarry ? PlannedMemorySpillKind::ScratchLoopCarry
                           : PlannedMemorySpillKind::ScratchValue;
    spill.group = group;
    spill.value = value;
    if (loopCarry)
      spill.loopCarry = {loopCarry->loop, loopCarry->index};
    spill.scratchPlan = plan;
    spill.useCount = useCount;
    spill.reliefDwords = pressureRelief;
    return std::make_unique<PlannedMemorySpill>(spill);
  }

protected:
  void printExtra(llvm::raw_ostream &os) const override {
    os << ", slot_base=" << plan.slotBase << ", slot_bytes=" << plan.slotBytes
       << ", uses=" << useCount;
  }

  void setExtraDiagnosticAttrs(Builder &builder,
                               NamedAttrList &attrs) const override {
    attrs.set("slot_base", builder.getI64IntegerAttr(plan.slotBase));
    attrs.set("slot_bytes", builder.getI64IntegerAttr(plan.slotBytes));
    attrs.set("pressure_relief", builder.getI64IntegerAttr(pressureRelief));
    attrs.set("uses", builder.getI64IntegerAttr(useCount));
  }

private:
  std::string rejectReason;
  ScratchSpillPlan plan;
  IntervalGroup *group = nullptr;
  std::optional<LoopCarrySlot> loopCarry;
  Value value;
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

  LogicalResult collectCandidates(
      const wave::WaveAMDPressureReliefQuery &query,
      wave::WaveAMDPressureReliefCandidateList &candidates) const override {
    pressureFailure = query.failure;
    sawLoopCarryReject = false;
    for (IntervalGroup *group : groups)
      collect(group, candidates);
    collect(request, candidates);
    return success();
  }

  LogicalResult
  materialize(const wave::WaveAMDPressureReliefCandidate &candidate,
              OpBuilder &builder) const override {
    const ScratchSpillCandidate &spill =
        static_cast<const ScratchSpillCandidate &>(candidate);
    if (spill.getLoopCarry()) {
      std::unique_ptr<wave::WaveAMDPressureReliefPlan> plan =
          spill.getPlannedSpill();
      SmallVector<PlannedMemorySpill, 1> spills{
          static_cast<const PlannedMemorySpill &>(*plan)};
      if (failed(materializeLoopCarries(spills, builder)))
        return failure();
      reserveSlot(spill.getPlan(), builder);
      return success();
    }
    if (failed(materializeValue(spill.getValue(), spill.getPlan(), builder)))
      return failure();
    reserveSlot(spill.getPlan(), builder);
    return success();
  }

  std::unique_ptr<wave::WaveAMDPressureReliefPlan> createPlan(
      const wave::WaveAMDPressureReliefCandidate &candidate) const override {
    const ScratchSpillCandidate &spill =
        static_cast<const ScratchSpillCandidate &>(candidate);
    return spill.getPlannedSpill();
  }

  void applyPlan(const wave::WaveAMDPressureReliefPlan &plan) const override {
    const PlannedMemorySpill &spill =
        static_cast<const PlannedMemorySpill &>(plan);
    if (spill.group) {
      spill.group->plannedPressureRelief = true;
      spill.group->assignedBase.reset();
    }
    addPlannedProviderBytes(inventory, getName(), spill.scratchPlan.slotBytes);
  }

  LogicalResult materializePlan(const wave::WaveAMDPressureReliefPlan &plan,
                                OpBuilder &builder) const override {
    const PlannedMemorySpill &spill =
        static_cast<const PlannedMemorySpill &>(plan);
    if (spill.kind == PlannedMemorySpillKind::ScratchLoopCarry) {
      SmallVector<PlannedMemorySpill, 1> spills{spill};
      return materializeLoopCarryPlans(spills, builder);
    }
    assert(spill.kind == PlannedMemorySpillKind::ScratchValue &&
           "expected scratch spill");
    if (failed(materializeValue(spill.value, spill.scratchPlan, builder)))
      return failure();
    reserveSlot(spill.scratchPlan, builder);
    return success();
  }

  LogicalResult
  materializePlans(ArrayRef<const wave::WaveAMDPressureReliefPlan *> plans,
                   OpBuilder &builder) const override {
    SmallVector<SmallVector<PlannedMemorySpill, 2>, 8> loopCarryGroups;
    for (const wave::WaveAMDPressureReliefPlan *plan : plans) {
      const PlannedMemorySpill &spill =
          static_cast<const PlannedMemorySpill &>(*plan);
      if (spill.kind != PlannedMemorySpillKind::ScratchLoopCarry) {
        if (failed(materializePlan(*plan, builder)))
          return failure();
        continue;
      }
      waveamdmachine::UniformLoopOp spillLoop = spill.loopCarry.loop;
      Operation *loop = spillLoop.getOperation();
      auto it = llvm::find_if(loopCarryGroups, [&](const auto &group) {
        waveamdmachine::UniformLoopOp groupLoop = group.front().loopCarry.loop;
        return groupLoop.getOperation() == loop;
      });
      if (it == loopCarryGroups.end())
        loopCarryGroups.push_back({spill});
      else
        it->push_back(spill);
    }
    llvm::stable_sort(loopCarryGroups, [](const auto &lhs, const auto &rhs) {
      waveamdmachine::UniformLoopOp lhsLoop = lhs.front().loopCarry.loop;
      waveamdmachine::UniformLoopOp rhsLoop = rhs.front().loopCarry.loop;
      return getLoopDepth(lhsLoop.getOperation()) >
             getLoopDepth(rhsLoop.getOperation());
    });
    for (ArrayRef<PlannedMemorySpill> group : loopCarryGroups)
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

  void clearNoCandidateDiagnostic() const {
    func->removeAttr(kMemorySpillRejectAttr);
    func->removeAttr(kMemorySpillRejectDetailAttr);
  }

  void setNoCandidateDiagnostic() const {
    if (!sawLoopCarryReject)
      return;
    Builder builder(func->getContext());
    func->setAttr(kMemorySpillRejectAttr,
                  builder.getStringAttr(kMemorySpillLoopCarryReject));
  }

  void notifyNoCandidate() const override { setNoCandidateDiagnostic(); }

  void notifyPlanApplied() const override { clearNoCandidateDiagnostic(); }

private:
  static bool hasFixedRegister(IntervalGroup *group) {
    if (group->fixedBase)
      return true;
    for (Interval *lane : group->intervals)
      for (Value value : lane->values)
        if (cast<waveamdmachine::RegType>(value.getType()).getIndex() >= 0)
          return true;
    return false;
  }

  static bool isSpillableGroup(IntervalGroup *group) {
    if (!group || group->reserved || group->nonPromotable ||
        hasFixedRegister(group))
      return false;
    return group->storageClass == waveamdmachine::RegClass::VGPR &&
           group->preferredClass == waveamdmachine::RegClass::VGPR;
  }

  static bool isEligibleGroup(IntervalGroup *group, unsigned position) {
    if (!isSpillableGroup(group))
      return false;
    return llvm::any_of(group->intervals, [&](Interval *lane) {
      return !lane->nonPromotable && lane->start <= position &&
             position <= lane->end;
    });
  }

  static bool isTempOp(Operation *op) {
    return op && op->hasAttr(kRegAllocTempAttr);
  }

  static bool isMemoryIssuer(Operation *op) {
    waveamdmachine::WaitcntInfoOpInterface info =
        dyn_cast<waveamdmachine::WaitcntInfoOpInterface>(op);
    return info && info.getWaitcntInfo().isIssuer();
  }

  static bool isLoopCarryUse(Operation *op) {
    return isa<waveamdmachine::UniformLoopOp, waveamdmachine::ContinueIfOp>(op);
  }

  static unsigned getLoopDepth(Operation *op) {
    unsigned depth = 0;
    for (Operation *cur = op; cur; cur = cur->getParentOp())
      if (isa<waveamdmachine::UniformLoopOp>(cur))
        ++depth;
    return depth;
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

  bool hasSimpleUses(Value value, SmallVectorImpl<OpOperand *> &uses) const {
    Operation *def = value.getDefiningOp();
    if (!def || isTempOp(def) || isMemoryIssuer(def))
      return false;
    for (OpOperand &use : value.getUses()) {
      if (isTempOp(use.getOwner()))
        continue;
      if (isLoopCarryUse(use.getOwner())) {
        sawLoopCarryReject = true;
        return false;
      }
      if (!useIsDominatedByDef(def, use.getOwner()))
        return false;
      uses.push_back(&use);
    }
    return !uses.empty();
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

  ScratchSpillPlan getPlanForValue(waveamdmachine::RegType type) const {
    unsigned committedBytes =
        getUnsignedAttr(func, kScratchSpillBytesAttr).value_or(0);
    unsigned existingBytes = getPrivateSegmentBytes(func, committedBytes);
    unsigned reservedBytes =
        committedBytes + getPlannedProviderBytes(inventory, getName());
    return buildScratchSpillPlan(func, type.getWidth() * 4, reservedBytes,
                                 existingBytes);
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
    if (type.getRegClass() != waveamdmachine::RegClass::VGPR ||
        type.getWidth() == 0 || !valueCoversWholeGroup(group, value))
      return;
    SmallVector<OpOperand *> uses;
    if (!hasSimpleUses(value, uses) || !isValueLiveAt(value, uses))
      return;
    ScratchSpillPlan plan = getPlanForValue(type);
    if (plan.status != ScratchSpillPlanStatus::Available)
      return;
    std::optional<unsigned> pressureRelief =
        getPressureRelief(value, type.getWidth(), uses);
    if (!pressureRelief || *pressureRelief == 0)
      return;
    candidates.push_back(std::make_unique<ScratchSpillCandidate>(
        group, value, plan, uses.size(), *pressureRelief));
  }

  void collect(IntervalGroup *group,
               wave::WaveAMDPressureReliefCandidateList &candidates) const {
    if (!isEligibleGroup(group, position))
      return;
    if (collectLoopCarry(group, candidates))
      return;
    llvm::SmallDenseSet<Value, 8> seen;
    for (Interval *lane : group->intervals)
      for (Value value : lane->values)
        if (seen.insert(value).second)
          collectValue(group, value, candidates);
  }

  bool
  collectLoopCarry(IntervalGroup *group,
                   wave::WaveAMDPressureReliefCandidateList &candidates) const {
    std::optional<LoopCarrySlot> slot = getLoopCarrySlot(group);
    if (!slot || !canSpillLoopCarryAtPosition(*slot) ||
        !hasLocalLoopCarryUses(*slot))
      return false;
    Value init = slot->loop.getInits()[slot->index];
    waveamdmachine::RegType type =
        dyn_cast<waveamdmachine::RegType>(init.getType());
    if (!type || type.getRegClass() != waveamdmachine::RegClass::VGPR ||
        type.getWidth() <= 1 || !valueCoversWholeGroup(group, init))
      return false;
    if (loopCarryTouchesPressure(*slot))
      return false;
    ScratchSpillPlan plan = getPlanForValue(type);
    if (plan.status != ScratchSpillPlanStatus::Available)
      return false;
    candidates.push_back(std::make_unique<ScratchSpillCandidate>(
        group, *slot, plan, getLoopCarryUseCount(*slot), type.getWidth()));
    return true;
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
    return values;
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
    Value storeToken =
        storeSpillValue(value, Value{}, plan, builder, def->getLoc());

    for (OpOperand *use : uses) {
      if (use->get() != value)
        continue;
      Operation *user = use->getOwner();
      builder.setInsertionPoint(user);
      ScratchLoadResult load = loadSpillValue(value.getType(), storeToken, plan,
                                              builder, user->getLoc());
      use->set(load.value);
    }
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

  static bool isSpilledIndex(ArrayRef<PlannedMemorySpill> spills,
                             unsigned index) {
    return llvm::any_of(spills, [&](const PlannedMemorySpill &spill) {
      return spill.loopCarry.index == index;
    });
  }

  static std::optional<unsigned>
  getSpillOrdinal(ArrayRef<PlannedMemorySpill> spills, unsigned index) {
    for (auto [ordinal, spill] : llvm::enumerate(spills))
      if (spill.loopCarry.index == index)
        return ordinal;
    return std::nullopt;
  }

  LogicalResult materializeLoopCarryPlans(ArrayRef<PlannedMemorySpill> spills,
                                          OpBuilder &builder) const {
    if (failed(materializeLoopCarries(spills, builder)))
      return failure();
    for (const PlannedMemorySpill &spill : spills)
      reserveSlot(spill.scratchPlan, builder);
    return success();
  }

  LogicalResult materializeLoopCarries(ArrayRef<PlannedMemorySpill> input,
                                       OpBuilder &builder) const {
    if (input.empty())
      return success();
    SmallVector<PlannedMemorySpill, 4> spills(input.begin(), input.end());
    llvm::stable_sort(spills, [](const PlannedMemorySpill &lhs,
                                 const PlannedMemorySpill &rhs) {
      return lhs.loopCarry.index < rhs.loopCarry.index;
    });

    waveamdmachine::UniformLoopOp loop = spills.front().loopCarry.loop;
    for (const PlannedMemorySpill &spill : spills)
      assert(spill.kind == PlannedMemorySpillKind::ScratchLoopCarry &&
             spill.loopCarry.loop == loop && "expected one loop carry group");

    SmallVector<Value, 4> initTokens;
    for (const PlannedMemorySpill &spill : spills) {
      Value init = loop.getInits()[spill.loopCarry.index];
      setInsertionPointForInitStore(init, loop, builder);
      initTokens.push_back(storeSpillValue(init, Value{}, spill.scratchPlan,
                                           builder, loop.getLoc()));
    }
    for (auto [index, spill] : llvm::enumerate(spills))
      if (failed(rewriteExtraLoopInitUses(spill, initTokens[index], builder)))
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

  LogicalResult rewriteExtraLoopInitUses(const PlannedMemorySpill &spill,
                                         Value initToken,
                                         OpBuilder &builder) const {
    waveamdmachine::UniformLoopOp loop = spill.loopCarry.loop;
    OpOperand *loopUse = &loop.getInitsMutable()[spill.loopCarry.index];
    Value init = loopUse->get();
    SmallVector<OpOperand *> uses;
    for (OpOperand &use : init.getUses()) {
      if (&use == loopUse || isTempOp(use.getOwner()))
        continue;
      uses.push_back(&use);
    }

    for (OpOperand *use : uses) {
      Operation *user = use->getOwner();
      if (user->getBlock() != loop->getBlock() || !user->isBeforeInBlock(loop))
        return mlir::emitError(init.getLoc())
               << "waveamd-reg-alloc cannot materialize scratch spill for "
                  "loop init use outside loop preheader";
      builder.setInsertionPoint(user);
      ScratchLoadResult load =
          loadSpillValue(init.getType(), initToken, spill.scratchPlan, builder,
                         user->getLoc());
      use->set(load.value);
    }
    return success();
  }

  waveamdmachine::UniformLoopOp cloneLoopWithoutCarries(
      waveamdmachine::UniformLoopOp loop, ArrayRef<PlannedMemorySpill> spills,
      ArrayRef<Value> initTokens, OpBuilder &builder) const {
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
                     ArrayRef<PlannedMemorySpill> spills,
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
    for ([[maybe_unused]] const PlannedMemorySpill &spill : spills)
      tokens.push_back(newBody->getArgument(newArgIndex++));
    cloneLoopBodyOps(oldLoop, newBody, spills, tokens, mapper, builder);
  }

  void cloneLoopBodyOps(waveamdmachine::UniformLoopOp oldLoop, Block *newBody,
                        ArrayRef<PlannedMemorySpill> spills,
                        SmallVectorImpl<Value> &tokens, IRMapping &mapper,
                        OpBuilder &builder) const {
    Block &oldBody = oldLoop.getBody().front();
    builder.setInsertionPointToEnd(newBody);
    for (Operation &op : oldBody.without_terminator()) {
      for (const PlannedMemorySpill &spill : spills) {
        BlockArgument oldArg = oldBody.getArgument(spill.loopCarry.index);
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
                          ArrayRef<PlannedMemorySpill> spills) const {
    BlockArgument arg = dyn_cast<BlockArgument>(value);
    if (!arg || arg.getOwner() != &loop.getBody().front())
      return std::nullopt;
    return getSpillOrdinal(spills, arg.getArgNumber());
  }

  Value getMappedValue(waveamdmachine::UniformLoopOp loop, Value value,
                       ArrayRef<PlannedMemorySpill> spills,
                       SmallVectorImpl<Value> &tokens, IRMapping &mapper,
                       OpBuilder &builder, Location loc) const {
    if (Value mapped = mapper.lookupOrNull(value))
      return mapped;
    std::optional<unsigned> ordinal =
        getSpillOrdinalForValue(loop, value, spills);
    if (!ordinal)
      return mapper.lookupOrDefault(value);
    const PlannedMemorySpill &spill = spills[*ordinal];
    ScratchLoadResult load = loadSpillValue(value.getType(), tokens[*ordinal],
                                            spill.scratchPlan, builder, loc);
    tokens[*ordinal] = load.token;
    mapper.map(value, load.value);
    return load.value;
  }

  bool needsTerminatorPreload(waveamdmachine::UniformLoopOp loop,
                              unsigned carryIndex, Value carry,
                              ArrayRef<PlannedMemorySpill> spills) const {
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
                           ArrayRef<PlannedMemorySpill> spills,
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
        const PlannedMemorySpill &spill = spills[*spillIndex];
        BlockArgument oldArg =
            loop.getBody().front().getArgument(spill.loopCarry.index);
        if (carry != oldArg)
          tokens[*spillIndex] =
              storeSpillValue(getMappedValue(loop, carry, spills, tokens,
                                             mapper, builder, oldTerm.getLoc()),
                              tokens[*spillIndex], spill.scratchPlan, builder,
                              oldTerm.getLoc());
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
                          ArrayRef<PlannedMemorySpill> spills,
                          OpBuilder &builder) const {
    builder.setInsertionPointAfter(newLoop);
    unsigned newResultIndex = 0;
    for (unsigned index : llvm::seq<unsigned>(0, oldLoop.getResults().size())) {
      if (isSpilledIndex(spills, index))
        continue;
      oldLoop.getResult(index).replaceAllUsesWith(
          newLoop.getResult(newResultIndex++));
    }
    for (const PlannedMemorySpill &spill : spills) {
      Value token = newLoop.getResult(newResultIndex++);
      unsigned oldIndex = spill.loopCarry.index;
      if (oldLoop.getResult(oldIndex).use_empty())
        continue;
      ScratchLoadResult load =
          loadSpillValue(oldLoop.getResult(oldIndex).getType(), token,
                         spill.scratchPlan, builder, oldLoop.getLoc());
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

  ArrayRef<IntervalGroup *> groups;
  Inventory &inventory;
  func::FuncOp func;
  IntervalGroup *request = nullptr;
  unsigned position = 0;
  mutable const PressureFailure *pressureFailure = nullptr;
  mutable bool sawLoopCarryReject = false;
};

static bool supportsScratchSpillTarget(const llvm::AMDGPU::IsaVersion &isa) {
  return isa.Major == 11 || (isa.Major == 9 && isa.Minor >= 4);
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

FailureOr<bool> mlir::wave::regalloc::applyScratchSpillProvider(
    func::FuncOp func, ArrayRef<IntervalGroup *> groups, IntervalGroup *request,
    unsigned position, Inventory &inventory,
    const PressureFailure *pressureFailure) {
  std::unique_ptr<wave::WaveAMDPressureReliefProvider> provider =
      createScratchSpillProvider(func, groups, request, position, inventory);
  wave::WaveAMDPressureReliefCandidateList candidates;
  wave::WaveAMDPressureReliefQuery query;
  query.scope = func;
  query.failure = pressureFailure;
  if (failed(provider->collectCandidates(query, candidates)))
    return failure();
  if (candidates.empty()) {
    provider->notifyNoCandidate();
    return false;
  }

  unsigned selected = 0;
  for (size_t index : llvm::seq<size_t>(1, candidates.size()))
    if (provider->isBetterCandidate(*candidates[index], *candidates[selected]))
      selected = index;

  std::unique_ptr<wave::WaveAMDPressureReliefPlan> plan =
      provider->createPlan(*candidates[selected]);
  if (!plan)
    return failure();
  provider->applyPlan(*plan);
  provider->notifyPlanApplied();
  recordPlannedPressureRelief(inventory, std::move(plan));
  return true;
}
