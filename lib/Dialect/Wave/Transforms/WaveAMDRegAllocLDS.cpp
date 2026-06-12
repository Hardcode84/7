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
#include "mlir/IR/BuiltinAttributes.h"
#include "llvm/MC/MCSubtargetInfo.h"
#include "llvm/MC/TargetRegistry.h"
#include "llvm/Support/MathExtras.h"
#include "llvm/Support/TargetSelect.h"
#include "llvm/TargetParser/Triple.h"

#include <algorithm>
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
                                unsigned &dynamicBytes) {
  Operation *op = func.getOperation();
  dynamicBytes = getLDSAttr(func, "waveamdmachine.dynamic_lds_size",
                            "wave.dynamic_lds_size");
  if (std::optional<unsigned> totalBytes =
          getUnsignedAttr(op, "waveamdmachine.lds_size")) {
    fixedBytes = *totalBytes >= dynamicBytes ? *totalBytes - dynamicBytes : 0;
    return;
  }
  fixedBytes = getUnsignedAttr(op, "wave.lds_size").value_or(0);
}

static std::optional<unsigned>
getFlatWorkgroupSize(Operation *op, StringRef name, bool &invalid) {
  DenseI32ArrayAttr attr = op->getAttrOfType<DenseI32ArrayAttr>(name);
  if (!attr)
    return std::nullopt;
  uint64_t product = 1;
  for (int32_t dim : attr.asArrayRef()) {
    if (dim <= 0) {
      invalid = true;
      return std::nullopt;
    }
    product *= static_cast<uint32_t>(dim);
    if (product > std::numeric_limits<unsigned>::max()) {
      invalid = true;
      return std::nullopt;
    }
  }
  return static_cast<unsigned>(product);
}

static std::optional<unsigned> getFlatWorkgroupSize(func::FuncOp func,
                                                    bool &invalid) {
  Operation *op = func.getOperation();
  if (std::optional<unsigned> size =
          getFlatWorkgroupSize(op, "wave.workgroup_size", invalid))
    return size;
  return getFlatWorkgroupSize(op, "gpu.known_block_size", invalid);
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
  std::optional<unsigned> workgroupSize =
      getFlatWorkgroupSize(func, invalidShape);
  if (invalidShape)
    return reject(LDSSpillPlanStatus::InvalidWorkgroupShape, fixedBytes,
                  dynamicBytes, reservedBytes, valueBytes);
  if (!workgroupSize)
    return reject(LDSSpillPlanStatus::MissingWorkgroupShape, fixedBytes,
                  dynamicBytes, reservedBytes, valueBytes);

  wavesPerWorkgroup =
      llvm::divideCeil(*workgroupSize, targetInfo.wavefrontSize);
  std::optional<unsigned> explicitWaves =
      getUnsignedAttr(func.getOperation(), "wave.waves_per_workgroup");
  if (explicitWaves &&
      (*explicitWaves == 0 || *explicitWaves != wavesPerWorkgroup))
    return reject(LDSSpillPlanStatus::InvalidWorkgroupShape, fixedBytes,
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
  getExistingLDSBytes(func, fixedLDS, dynamicLDS);

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
