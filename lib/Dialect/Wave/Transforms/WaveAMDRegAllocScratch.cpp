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

class ScratchSpillCandidate final
    : public wave::WaveAMDPressureReliefCandidate {
public:
  ScratchSpillCandidate(IntervalGroup *group, Value value,
                        ScratchSpillPlan plan, unsigned useCount,
                        StringRef rejectReason = StringRef())
      : rejectReason(rejectReason.str()), plan(plan), group(group),
        value(value), useCount(useCount) {}

  StringRef getProviderName() const override { return "scratch-spill"; }

  wave::WaveAMDPressureReliefCost getCost() const override {
    wave::WaveAMDPressureReliefCost cost;
    cost.materializationOps = 2 + static_cast<int64_t>(useCount);
    cost.latencyPenalty = static_cast<int64_t>(useCount) * 8;
    return cost;
  }

  unsigned getReliefDwords() const override { return plan.valueBytes / 4; }

  std::optional<StringRef> getRejectReason() const override {
    if (rejectReason.empty())
      return std::nullopt;
    return StringRef(rejectReason);
  }

  IntervalGroup *getGroup() const { return group; }
  ScratchSpillPlan getPlan() const { return plan; }
  unsigned getUseCount() const { return useCount; }
  Value getValue() const { return value; }

protected:
  void printExtra(llvm::raw_ostream &os) const override {
    os << ", slot_base=" << plan.slotBase << ", slot_bytes=" << plan.slotBytes
       << ", uses=" << useCount;
  }

  void setExtraDiagnosticAttrs(Builder &builder,
                               NamedAttrList &attrs) const override {
    attrs.set("slot_base", builder.getI64IntegerAttr(plan.slotBase));
    attrs.set("slot_bytes", builder.getI64IntegerAttr(plan.slotBytes));
    attrs.set("uses", builder.getI64IntegerAttr(useCount));
  }

private:
  std::string rejectReason;
  ScratchSpillPlan plan;
  IntervalGroup *group = nullptr;
  Value value;
  unsigned useCount = 0;
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
    (void)query;
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
    if (failed(materializeValue(spill, builder)))
      return failure();
    reserveSlot(spill.getPlan(), builder);
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

  bool hasSimpleUses(Value value, SmallVectorImpl<OpOperand *> &uses) const {
    Operation *def = value.getDefiningOp();
    if (!def || isTempOp(def) || isMemoryIssuer(def))
      return false;
    Block *block = def->getBlock();
    for (OpOperand &use : value.getUses()) {
      if (isTempOp(use.getOwner()))
        continue;
      if (use.getOwner()->getBlock() != block)
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

  void
  collectValue(IntervalGroup *group, Value value,
               wave::WaveAMDPressureReliefCandidateList &candidates) const {
    waveamdmachine::RegType type =
        cast<waveamdmachine::RegType>(value.getType());
    if (type.getRegClass() != waveamdmachine::RegClass::VGPR ||
        type.getWidth() == 0)
      return;
    SmallVector<OpOperand *> uses;
    if (!hasSimpleUses(value, uses) || !isValueLiveAt(value, uses))
      return;
    unsigned reservedBytes =
        getUnsignedAttr(func, kScratchSpillBytesAttr).value_or(0);
    ScratchSpillPlan plan =
        planScratchSpillSlot(func, type.getWidth() * 4, reservedBytes);
    if (plan.status != ScratchSpillPlanStatus::Available)
      return;
    candidates.push_back(std::make_unique<ScratchSpillCandidate>(
        group, value, plan, uses.size()));
  }

  void collect(IntervalGroup *group,
               wave::WaveAMDPressureReliefCandidateList &candidates) const {
    if (!isEligibleGroup(group, position))
      return;
    llvm::SmallDenseSet<Value, 8> seen;
    for (Interval *lane : group->intervals)
      for (Value value : lane->values)
        if (seen.insert(value).second)
          collectValue(group, value, candidates);
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

  SmallVector<Type> getScalarVGPRTypes(unsigned width) const {
    MLIRContext *ctx = func->getContext();
    Type type = waveamdmachine::RegType::get(
        ctx, waveamdmachine::RegClass::VGPR, /*width=*/1, /*index=*/-1);
    return SmallVector<Type>(width, type);
  }

  SmallVector<Value> splitValue(Value value, OpBuilder &builder,
                                Location loc) const {
    waveamdmachine::RegType type =
        cast<waveamdmachine::RegType>(value.getType());
    if (type.getWidth() == 1)
      return {value};
    waveamdmachine::TupleToElementsOp split =
        waveamdmachine::TupleToElementsOp::create(
            builder, loc, getScalarVGPRTypes(type.getWidth()), value);
    split->setAttr(kRegAllocTempAttr, builder.getUnitAttr());
    return SmallVector<Value>(split.getElements().begin(),
                              split.getElements().end());
  }

  Value joinValue(Type type, ArrayRef<Value> values, OpBuilder &builder,
                  Location loc) const {
    if (values.size() == 1)
      return values.front();
    waveamdmachine::TupleFromElementsOp join =
        waveamdmachine::TupleFromElementsOp::create(builder, loc, type, values);
    join->setAttr(kRegAllocTempAttr, builder.getUnitAttr());
    return join.getTuple();
  }

  LogicalResult materializeValue(const ScratchSpillCandidate &spill,
                                 OpBuilder &builder) const {
    Value value = spill.getValue();
    Operation *def = value.getDefiningOp();
    SmallVector<OpOperand *> uses;
    if (!hasSimpleUses(value, uses))
      return mlir::emitError(value.getLoc())
             << "waveamd-reg-alloc cannot materialize scratch spill for value";

    ScratchSpillPlan plan = spill.getPlan();
    Type tokenType = waveamdmachine::MemTokenType::get(builder.getContext());
    builder.setInsertionPointAfter(def);
    SmallVector<Value> storeValues = splitValue(value, builder, def->getLoc());
    Value storeToken;
    for (auto [index, storeValue] : llvm::enumerate(storeValues)) {
      Value storeVaddr;
      Value storeSaddr;
      int64_t storeOffset = 0;
      materializeAddress(builder, def->getLoc(), plan.slotBase + index * 4,
                         storeVaddr, storeSaddr, storeOffset);
      waveamdmachine::ScratchStoreB32Op store =
          waveamdmachine::ScratchStoreB32Op::create(
              builder, def->getLoc(), tokenType, storeVaddr, storeValue,
              storeSaddr, storeToken, storeOffset);
      store->setAttr(kRegAllocTempAttr, builder.getUnitAttr());
      storeToken = store.getToken();
    }

    for (OpOperand *use : uses) {
      if (use->get() != value)
        continue;
      Operation *user = use->getOwner();
      builder.setInsertionPoint(user);
      SmallVector<Value> loadValues;
      for (unsigned index : llvm::seq<unsigned>(0, storeValues.size())) {
        Value loadVaddr;
        Value loadSaddr;
        int64_t loadOffset = 0;
        materializeAddress(builder, user->getLoc(), plan.slotBase + index * 4,
                           loadVaddr, loadSaddr, loadOffset);
        waveamdmachine::ScratchLoadB32Op load =
            waveamdmachine::ScratchLoadB32Op::create(
                builder, user->getLoc(), storeValues[index].getType(),
                tokenType, loadVaddr, loadSaddr, storeToken, loadOffset);
        load->setAttr(kRegAllocTempAttr, builder.getUnitAttr());
        loadValues.push_back(load.getResult());
      }
      use->set(joinValue(value.getType(), loadValues, builder, user->getLoc()));
    }
    return success();
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

FailureOr<bool> mlir::wave::regalloc::applyScratchSpillProvider(
    func::FuncOp func, ArrayRef<IntervalGroup *> groups, IntervalGroup *request,
    unsigned position, Inventory &inventory) {
  ScratchSpillProvider provider(func, groups, request, position, inventory);
  wave::WaveAMDPressureReliefCandidateList candidates;
  wave::WaveAMDPressureReliefQuery query;
  query.scope = func;
  if (failed(provider.collectCandidates(query, candidates)))
    return failure();
  if (candidates.empty())
    return false;

  unsigned selected = 0;
  for (size_t index : llvm::seq<size_t>(1, candidates.size()))
    if (provider.isBetterCandidate(*candidates[index], *candidates[selected]))
      selected = index;

  OpBuilder builder(func.getContext());
  if (failed(provider.materialize(*candidates[selected], builder)))
    return failure();
  return true;
}
