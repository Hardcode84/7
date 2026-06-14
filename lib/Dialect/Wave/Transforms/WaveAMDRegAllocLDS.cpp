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

static bool isCheapVGPRExpr(Operation *op) {
  return isa_and_nonnull<
      waveamdmachine::VWorkitemIdXOp, waveamdmachine::VMovB32TupleOp,
      waveamdmachine::VLshrrevB32Op, waveamdmachine::VLshlrevB32Op,
      waveamdmachine::VLshlAddU32Op, waveamdmachine::VAddU32Op,
      waveamdmachine::VAdd3U32Op, waveamdmachine::VAndB32Op,
      waveamdmachine::VXorB32Op, waveamdmachine::VAndOrB32Op>(op);
}

class LDSSpillCandidate final : public wave::WaveAMDPressureReliefCandidate {
public:
  LDSSpillCandidate(IntervalGroup *group, Value value, LDSSpillPlan plan,
                    unsigned useCount, unsigned pressureRelief,
                    StringRef rejectReason = StringRef())
      : group(group), value(value), rejectReason(rejectReason.str()),
        plan(plan), useCount(useCount), pressureRelief(pressureRelief) {}

  StringRef getProviderName() const override { return "lds-spill"; }

  wave::WaveAMDPressureReliefCost getCost() const override {
    wave::WaveAMDPressureReliefCost cost;
    cost.materializationOps = 2 + static_cast<int64_t>(useCount) * 2;
    cost.latencyPenalty = static_cast<int64_t>(useCount) * 2;
    return cost;
  }

  unsigned getReliefDwords() const override { return pressureRelief; }

  std::optional<StringRef> getRejectReason() const override {
    if (rejectReason.empty())
      return std::nullopt;
    return StringRef(rejectReason);
  }

  IntervalGroup *getGroup() const { return group; }
  LDSSpillPlan getPlan() const { return plan; }
  unsigned getUseCount() const { return useCount; }
  Value getValue() const { return value; }
  std::unique_ptr<wave::WaveAMDPressureReliefPlan> getPlannedSpill() const {
    PlannedMemorySpill spill;
    spill.kind = PlannedMemorySpillKind::LDSValue;
    spill.group = group;
    spill.value = value;
    spill.ldsPlan = plan;
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
  IntervalGroup *group = nullptr;
  Value value;
  std::string rejectReason;
  LDSSpillPlan plan;
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

  LogicalResult collectCandidates(
      const wave::WaveAMDPressureReliefQuery &query,
      wave::WaveAMDPressureReliefCandidateList &candidates) const override {
    pressureFailure = query.failure;
    sawLoopCarryReject = false;
    unsigned committedBytes =
        getUnsignedAttr(func, kLDSSpillBytesAttr).value_or(0);
    unsigned fixedLDS = 0;
    unsigned dynamicLDS = 0;
    getExistingLDSBytes(func, fixedLDS, dynamicLDS, committedBytes);
    unsigned reservedBytes =
        committedBytes + getPlannedProviderBytes(inventory, getName());
    LDSSpillPlan plan = buildLDSSpillPlan(func, budgets, /*valueBytes=*/4,
                                          reservedBytes, fixedLDS, dynamicLDS);
    if (plan.status != LDSSpillPlanStatus::Available)
      return success();
    if (plan.wavesPerWorkgroup != 1)
      return success();
    if (plan.slotBase > waveamdmachine::instOffsetRange(
                            waveamdmachine::DsStoreB32Op::getAddressFieldSpec())
                            .second)
      return success();

    for (IntervalGroup *group : groups)
      collect(group, plan, candidates);
    collect(request, plan, candidates);
    return success();
  }

  LogicalResult
  materialize(const wave::WaveAMDPressureReliefCandidate &candidate,
              OpBuilder &builder) const override {
    const LDSSpillCandidate &spill =
        static_cast<const LDSSpillCandidate &>(candidate);
    if (failed(materializeValue(spill, builder)))
      return failure();
    reserveSlot(spill.getPlan(), builder);
    return success();
  }

  std::unique_ptr<wave::WaveAMDPressureReliefPlan> createPlan(
      const wave::WaveAMDPressureReliefCandidate &candidate) const override {
    const LDSSpillCandidate &spill =
        static_cast<const LDSSpillCandidate &>(candidate);
    return spill.getPlannedSpill();
  }

  void applyPlan(const wave::WaveAMDPressureReliefPlan &plan) const override {
    const PlannedMemorySpill &spill =
        static_cast<const PlannedMemorySpill &>(plan);
    if (spill.group) {
      spill.group->plannedPressureRelief = true;
      spill.group->assignedBase.reset();
    }
    addPlannedProviderBytes(inventory, getName(), spill.ldsPlan.slotBytes);
  }

  LogicalResult materializePlan(const wave::WaveAMDPressureReliefPlan &plan,
                                OpBuilder &builder) const override {
    const PlannedMemorySpill &spill =
        static_cast<const PlannedMemorySpill &>(plan);
    assert(spill.kind == PlannedMemorySpillKind::LDSValue &&
           "expected LDS spill");
    LDSSpillCandidate candidate(spill.group, spill.value, spill.ldsPlan,
                                spill.useCount, spill.reliefDwords);
    if (failed(materializeValue(candidate, builder)))
      return failure();
    reserveSlot(spill.ldsPlan, builder);
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
  static std::optional<unsigned> getUnsignedAttr(Operation *op, StringRef name);

  static Value getSimpleValue(IntervalGroup *group) {
    if (!group || group->intervals.size() != 1)
      return {};
    Interval *interval = group->intervals.front();
    if (interval->values.size() != 1)
      return {};
    return *interval->values.begin();
  }

  static bool isEligibleScalarGroup(IntervalGroup *group, unsigned position) {
    if (!isMemorySpillEligibleGroup(group, position) ||
        group->intervals.size() != 1)
      return false;
    return true;
  }

  bool hasSimpleUses(Value value, SmallVectorImpl<OpOperand *> &uses) const {
    Operation *def = value.getDefiningOp();
    if (!def || isRegAllocTempOp(def) || isMemoryIssuerOp(def))
      return false;
    Block *block = def->getBlock();
    for (OpOperand &use : value.getUses()) {
      if (isRegAllocTempOp(use.getOwner()))
        continue;
      if (isLoopCarryUseOp(use.getOwner())) {
        sawLoopCarryReject = true;
        return false;
      }
      if (use.getOwner()->getBlock() != block)
        return false;
      uses.push_back(&use);
    }
    return !uses.empty();
  }

  void collect(IntervalGroup *group, LDSSpillPlan plan,
               wave::WaveAMDPressureReliefCandidateList &candidates) const {
    if (!isEligibleScalarGroup(group, position))
      return;
    Value value = getSimpleValue(group);
    if (!value)
      return;
    waveamdmachine::RegType type =
        cast<waveamdmachine::RegType>(value.getType());
    if (type.getWidth() != 1)
      return;
    SmallVector<OpOperand *> uses;
    if (!hasSimpleUses(value, uses))
      return;
    std::optional<unsigned> pressureRelief =
        getPressureRelief(value, group, uses);
    if (!pressureRelief || *pressureRelief == 0)
      return;
    candidates.push_back(std::make_unique<LDSSpillCandidate>(
        group, value, plan, uses.size(), *pressureRelief));
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

  std::optional<unsigned> getPressureRelief(Value value, IntervalGroup *group,
                                            ArrayRef<OpOperand *> uses) const {
    if (!isCombinedPressure())
      return 1;
    if (isCheapVGPRExpr(value.getDefiningOp()))
      return 0;
    if (group->intervals.front()->start >= pressureFailure->position)
      return 0;
    if (hasUseAtPressure(uses))
      return 0;
    return 1;
  }

  Value createImm(OpBuilder &builder, Location loc, int64_t value) const {
    return waveamdmachine::ImmOp::create(
        builder, loc, waveamdmachine::ImmType::get(builder.getContext()),
        static_cast<uint64_t>(value));
  }

  Value materializeAddress(OpBuilder &builder, Location loc,
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
    return addr.getResult();
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

  LogicalResult materializeValue(const LDSSpillCandidate &spill,
                                 OpBuilder &builder) const {
    Value value = spill.getValue();
    Operation *def = value.getDefiningOp();
    SmallVector<OpOperand *> uses;
    if (!hasSimpleUses(value, uses))
      return mlir::emitError(value.getLoc())
             << "waveamd-reg-alloc cannot materialize LDS spill for value";

    LDSSpillPlan plan = spill.getPlan();
    Type tokenType = waveamdmachine::MemTokenType::get(builder.getContext());
    builder.setInsertionPointAfter(def);
    Value storeAddr = materializeAddress(builder, def->getLoc(), plan);
    waveamdmachine::DsStoreB32Op store = waveamdmachine::DsStoreB32Op::create(
        builder, def->getLoc(), tokenType, storeAddr, value, Value{},
        static_cast<int64_t>(plan.slotBase));
    store->setAttr(kRegAllocTempAttr, builder.getUnitAttr());

    for (OpOperand *use : uses) {
      if (use->get() != value)
        continue;
      Operation *user = use->getOwner();
      builder.setInsertionPoint(user);
      Value loadAddr = materializeAddress(builder, user->getLoc(), plan);
      waveamdmachine::DsLoadB32Op load = waveamdmachine::DsLoadB32Op::create(
          builder, user->getLoc(), value.getType(), tokenType, loadAddr,
          store.getToken(), static_cast<int64_t>(plan.slotBase));
      load->setAttr(kRegAllocTempAttr, builder.getUnitAttr());
      use->set(load.getResult());
    }
    return success();
  }

  void reserveSlot(const LDSSpillPlan &plan, OpBuilder &builder) const {
    unsigned reserved = getUnsignedAttr(func, kLDSSpillBytesAttr).value_or(0);
    func->setAttr(kLDSSpillBytesAttr,
                  builder.getI64IntegerAttr(reserved + plan.slotBytes));
  }

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
  info.localMemorySize = llvm::AMDGPU::IsaInfo::getLocalMemorySize(sti->get());
  info.addressableLocalMemorySize =
      llvm::AMDGPU::IsaInfo::getAddressableLocalMemorySize(sti->get());
  info.wavefrontSize = *wavefrontSize;
  info.eusPerCU = llvm::AMDGPU::IsaInfo::getEUsPerCU(sti->get());
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
getBasicReject(func::FuncOp func, RegisterBudgets budgets, unsigned fixedBytes,
               unsigned dynamicBytes, unsigned reservedBytes,
               unsigned valueBytes) {
  if (!func->hasAttr(wave::WaveDialect::getKernelAttrName()))
    return reject(LDSSpillPlanStatus::NotKernel, fixedBytes, dynamicBytes,
                  reservedBytes, valueBytes);
  if (valueBytes == 0)
    return reject(LDSSpillPlanStatus::InvalidValueBytes, fixedBytes,
                  dynamicBytes, reservedBytes, valueBytes);
  if (budgets.targetWaves == 0)
    return reject(LDSSpillPlanStatus::MissingTargetWaves, fixedBytes,
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
  uint64_t workgroupsPerCU = std::max<uint64_t>(
      1, (static_cast<uint64_t>(budgets.targetWaves) * targetInfo.eusPerCU) /
             wavesPerWorkgroup);
  uint64_t limitBytes = targetInfo.localMemorySize / workgroupsPerCU;
  if (targetInfo.addressableLocalMemorySize == 0)
    return limitBytes;
  return std::min<uint64_t>(limitBytes, targetInfo.addressableLocalMemorySize);
}

static LDSSpillPlan
buildAvailablePlan(unsigned fixedBytes, unsigned dynamicBytes,
                   unsigned reservedBytes, unsigned valueBytes,
                   const LDSTargetInfo &targetInfo, unsigned wavesPerWorkgroup,
                   uint64_t limitBytes, uint64_t usedBytes) {
  uint64_t waveStride =
      static_cast<uint64_t>(targetInfo.wavefrontSize) * valueBytes;
  LDSSpillPlan plan;
  plan.status = LDSSpillPlanStatus::Available;
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
          func, budgets, fixedLDS, dynamicLDS, reservedSpillBytes, valueBytes))
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

  return buildAvailablePlan(fixedLDS, dynamicLDS, reservedSpillBytes,
                            valueBytes, *targetInfo, wavesPerWorkgroup,
                            limitBytes, usedBytes);
}

} // namespace

StringRef
mlir::wave::regalloc::getLDSSpillPlanStatusName(LDSSpillPlanStatus status) {
  switch (status) {
  case LDSSpillPlanStatus::Available:
    return "available";
  case LDSSpillPlanStatus::NotKernel:
    return "not_kernel";
  case LDSSpillPlanStatus::MissingTargetWaves:
    return "missing_target_waves";
  case LDSSpillPlanStatus::MissingWorkgroupShape:
    return "missing_workgroup_shape";
  case LDSSpillPlanStatus::InvalidWorkgroupShape:
    return "invalid_workgroup_shape";
  case LDSSpillPlanStatus::UnsupportedWorkgroupShape:
    return "unsupported_workgroup_shape";
  case LDSSpillPlanStatus::InvalidValueBytes:
    return "invalid_value_bytes";
  case LDSSpillPlanStatus::InsufficientLDS:
    return "insufficient_lds";
  }
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
