//===- WaveAMDRegAllocLDSPlanning.cpp - LDS spill slots -------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "WaveAMDRegAllocInternal.h"

#include "Utils/AMDGPUBaseInfo.h"
#include "mlir/Dialect/Wave/IR/Wave.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachine.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachineTarget.h"
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

static uint64_t getLDSAddTidOffsetWindowBytes() {
  std::pair<int64_t, int64_t> range = waveamdmachine::instOffsetRange(
      waveamdmachine::DsStoreAddTidB32Op::getAddressFieldSpec());
  if (range.first < 0 || range.second < range.first)
    return 0;
  return static_cast<uint64_t>(range.second - range.first) + 1;
}

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

static std::optional<unsigned> getUnsignedAttr(Operation *op, StringRef name) {
  IntegerAttr attr = op->getAttrOfType<IntegerAttr>(name);
  if (!attr)
    return std::nullopt;
  const APInt &value = attr.getValue();
  if ((!attr.getType().isUnsignedInteger() && value.isNegative()) ||
      value.getActiveBits() > std::numeric_limits<unsigned>::digits)
    return std::nullopt;
  return static_cast<unsigned>(value.getZExtValue());
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
      waveamdmachine::getAMDGPUTarget(op, "waveamd regalloc LDS planning");
  if (failed(target))
    return failure();

  static llvm::once_flag initializeBackendOnce;
  llvm::call_once(initializeBackendOnce, []() {
    LLVMInitializeAMDGPUTargetInfo();
    LLVMInitializeAMDGPUTargetMC();
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
      func, "waveamd regalloc LDS planning");
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
getPlanningReject(const LDSSpillPlanningInfo &planning, unsigned fixedBytes,
                  unsigned dynamicBytes, unsigned reservedBytes,
                  unsigned valueBytes) {
  if (planning.status == LDSSpillPlanStatus::NotKernel)
    return reject(planning.status, fixedBytes, dynamicBytes, reservedBytes,
                  valueBytes);
  if (valueBytes == 0)
    return reject(LDSSpillPlanStatus::InvalidValueBytes, fixedBytes,
                  dynamicBytes, reservedBytes, valueBytes);
  if (planning.status != LDSSpillPlanStatus::Available)
    return reject(planning.status, fixedBytes, dynamicBytes, reservedBytes,
                  valueBytes);
  return std::nullopt;
}

static bool hasUsableTargetInfo(const std::optional<LDSTargetInfo> &info) {
  return info && info->localMemorySize != 0 && info->wavefrontSize != 0 &&
         info->eusPerCU != 0;
}

static std::optional<LDSSpillPlanStatus>
getWorkgroupRejectStatus(func::FuncOp func, const LDSTargetInfo &targetInfo,
                         unsigned &wavesPerWorkgroup) {
  bool invalidShape = false;
  std::optional<WorkgroupShape> workgroupShape =
      getWorkgroupShape(func, invalidShape);
  if (invalidShape)
    return LDSSpillPlanStatus::InvalidWorkgroupShape;
  if (!workgroupShape)
    return LDSSpillPlanStatus::MissingWorkgroupShape;

  wavesPerWorkgroup =
      llvm::divideCeil(workgroupShape->flatSize, targetInfo.wavefrontSize);
  std::optional<unsigned> explicitWaves =
      getUnsignedAttr(func.getOperation(), "wave.waves_per_workgroup");
  if (explicitWaves &&
      (*explicitWaves == 0 || *explicitWaves != wavesPerWorkgroup))
    return LDSSpillPlanStatus::InvalidWorkgroupShape;
  if (!workgroupShape->isXLinear())
    return LDSSpillPlanStatus::UnsupportedWorkgroupShape;
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
  uint64_t requiredWavesPerCU =
      static_cast<uint64_t>(budgets.targetWaves) * targetInfo.eusPerCU;
  uint64_t workgroupsPerCU = std::max<uint64_t>(
      1, llvm::divideCeil(requiredWavesPerCU,
                          static_cast<uint64_t>(wavesPerWorkgroup)));
  uint64_t limitBytes = targetInfo.localMemorySize / workgroupsPerCU;
  if (targetInfo.addressableLocalMemorySize == 0)
    return limitBytes;
  return std::min<uint64_t>(limitBytes, targetInfo.addressableLocalMemorySize);
}

static LDSSpillPlan buildCapacityPlan(
    LDSSpillPlanStatus status, unsigned fixedBytes, unsigned dynamicBytes,
    unsigned reservedBytes, unsigned valueBytes, unsigned wavefrontSize,
    unsigned wavesPerWorkgroup, uint64_t limitBytes, uint64_t usedBytes) {
  uint64_t waveStride = static_cast<uint64_t>(wavefrontSize) * valueBytes;
  LDSSpillPlan plan;
  plan.status = status;
  plan.existingFixedBytes = fixedBytes;
  plan.existingDynamicBytes = dynamicBytes;
  plan.reservedSpillBytes = reservedBytes;
  plan.limitBytes = static_cast<unsigned>(limitBytes);
  plan.availableBytes = static_cast<unsigned>(limitBytes - usedBytes);
  unsigned spillBase = fixedBytes;
  if (fixedBytes != 0 && dynamicBytes != 0)
    spillBase += dynamicBytes;
  plan.slotBase = spillBase + reservedBytes;
  plan.slotBytes = static_cast<unsigned>(waveStride * wavesPerWorkgroup);
  plan.waveStride = static_cast<unsigned>(waveStride);
  plan.valueBytes = valueBytes;
  plan.wavesPerWorkgroup = wavesPerWorkgroup;
  plan.wavefrontSize = wavefrontSize;
  return plan;
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

void mlir::wave::regalloc::getExistingLDSBytes(func::FuncOp func,
                                               unsigned &fixedBytes,
                                               unsigned &dynamicBytes,
                                               unsigned reservedSpillBytes) {
  Operation *op = func.getOperation();
  dynamicBytes = getLDSAttr(func, "waveamdmachine.dynamic_lds_size",
                            "wave.dynamic_lds_size");
  if (std::optional<unsigned> totalBytes =
          getUnsignedAttr(op, "waveamdmachine.lds_size")) {
    unsigned compilerBytes = dynamicBytes + reservedSpillBytes;
    fixedBytes = *totalBytes >= compilerBytes ? *totalBytes - compilerBytes : 0;
    return;
  }
  fixedBytes = getUnsignedAttr(op, "wave.lds_size").value_or(0);
}

LDSSpillPlanningInfo
mlir::wave::regalloc::getLDSSpillPlanningInfo(func::FuncOp func,
                                              RegisterBudgets budgets) {
  LDSSpillPlanningInfo planning;
  if (!func->hasAttr(wave::WaveDialect::getKernelAttrName())) {
    planning.status = LDSSpillPlanStatus::NotKernel;
    return planning;
  }

  std::optional<LDSTargetInfo> targetInfo = getLDSTargetInfo(func);
  if (!hasUsableTargetInfo(targetInfo)) {
    planning.status = LDSSpillPlanStatus::InsufficientLDS;
    return planning;
  }

  unsigned wavesPerWorkgroup = 0;
  if (std::optional<LDSSpillPlanStatus> status =
          getWorkgroupRejectStatus(func, *targetInfo, wavesPerWorkgroup)) {
    planning.status = *status;
    return planning;
  }

  planning.localMemorySize = targetInfo->localMemorySize;
  planning.addressableLocalMemorySize = targetInfo->addressableLocalMemorySize;
  planning.wavefrontSize = targetInfo->wavefrontSize;
  planning.eusPerCU = targetInfo->eusPerCU;
  planning.wavesPerWorkgroup = wavesPerWorkgroup;
  planning.limitBytes =
      getLDSLimitBytes(budgets, *targetInfo, wavesPerWorkgroup);
  planning.status = LDSSpillPlanStatus::Available;
  return planning;
}

LDSSpillPlan mlir::wave::regalloc::planLDSSpillSlot(
    const LDSSpillPlanningInfo &planning, unsigned valueBytes,
    unsigned reservedSpillBytes, unsigned fixedLDS, unsigned dynamicLDS) {
  if (std::optional<LDSSpillPlan> plan = getPlanningReject(
          planning, fixedLDS, dynamicLDS, reservedSpillBytes, valueBytes))
    return *plan;

  uint64_t usedBytes =
      static_cast<uint64_t>(fixedLDS) + dynamicLDS + reservedSpillBytes;
  uint64_t waveStride =
      static_cast<uint64_t>(planning.wavefrontSize) * valueBytes;
  uint64_t slotBytes = waveStride * planning.wavesPerWorkgroup;
  uint64_t offsetWindowBytes = getLDSAddTidOffsetWindowBytes();
  if (static_cast<uint64_t>(reservedSpillBytes) + slotBytes > offsetWindowBytes)
    return reject(LDSSpillPlanStatus::UnsupportedSlotBase, fixedLDS, dynamicLDS,
                  reservedSpillBytes, valueBytes);
  if (usedBytes + slotBytes > planning.limitBytes)
    return reject(LDSSpillPlanStatus::InsufficientLDS, fixedLDS, dynamicLDS,
                  reservedSpillBytes, valueBytes);

  return buildCapacityPlan(LDSSpillPlanStatus::Available, fixedLDS, dynamicLDS,
                           reservedSpillBytes, valueBytes,
                           planning.wavefrontSize, planning.wavesPerWorkgroup,
                           planning.limitBytes, usedBytes);
}

LDSSpillPlan mlir::wave::regalloc::planLDSSpillSlot(
    func::FuncOp func, RegisterBudgets budgets, unsigned valueBytes,
    unsigned reservedSpillBytes, unsigned fixedLDS, unsigned dynamicLDS) {
  LDSSpillPlanningInfo planning = getLDSSpillPlanningInfo(func, budgets);
  return planLDSSpillSlot(planning, valueBytes, reservedSpillBytes, fixedLDS,
                          dynamicLDS);
}

LDSSpillPlan mlir::wave::regalloc::planLDSSpillSlot(
    func::FuncOp func, RegisterBudgets budgets, unsigned valueBytes,
    unsigned reservedSpillBytes) {
  unsigned fixedLDS = 0;
  unsigned dynamicLDS = 0;
  getExistingLDSBytes(func, fixedLDS, dynamicLDS, reservedSpillBytes);
  return planLDSSpillSlot(func, budgets, valueBytes, reservedSpillBytes,
                          fixedLDS, dynamicLDS);
}
