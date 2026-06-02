//===- WaveAMDRegisterLimits.cpp - AMDGPU register budgets ----------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "WaveAMDRegisterLimits.h"

#include "Utils/AMDGPUBaseInfo.h"
#include "mlir/Dialect/Wave/IR/Wave.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachineTarget.h"
#include "llvm/ADT/Twine.h"
#include "llvm/MC/MCSubtargetInfo.h"
#include "llvm/MC/TargetRegistry.h"
#include "llvm/Support/TargetSelect.h"
#include "llvm/TargetParser/TargetParser.h"
#include "llvm/TargetParser/Triple.h"

#include <limits>

using namespace mlir;

namespace mlir::wave {

StringRef getWaveAMDKernargPreloadLengthAttrName() {
  return "waveamdmachine.kernarg_preload_length";
}

StringRef getWaveAMDKernargPreloadOffsetAttrName() {
  return "waveamdmachine.kernarg_preload_offset";
}

static unsigned getUnsignedIntegerAttr(Operation *op, StringRef name) {
  auto attr = op->getAttrOfType<IntegerAttr>(name);
  if (!attr)
    return 0;
  int64_t value = attr.getInt();
  if (value <= 0)
    return 0;
  if (value > std::numeric_limits<unsigned>::max())
    return std::numeric_limits<unsigned>::max();
  return static_cast<unsigned>(value);
}

bool hasWaveAMDKernargPreloadRequest(func::FuncOp func) {
  if (!func)
    return false;
  return getUnsignedIntegerAttr(func.getOperation(),
                                getWaveAMDKernargPreloadLengthAttrName()) > 0;
}

WaveAMDKernelEntryRegs getWaveAMDKernelEntryRegs(func::FuncOp func) {
  WaveAMDKernelEntryRegs regs;
  if (!func || !func->hasAttr(wave::WaveDialect::getKernelAttrName()))
    return regs;

  regs.kernargSegmentPtrSGPR = 0;
  regs.kernargSegmentPtrWidth = 2;
  regs.kernargPreloadDwords = getUnsignedIntegerAttr(
      func.getOperation(), getWaveAMDKernargPreloadLengthAttrName());
  regs.kernargPreloadOffsetDwords = getUnsignedIntegerAttr(
      func.getOperation(), getWaveAMDKernargPreloadOffsetAttrName());
  regs.userSGPRCount = regs.kernargSegmentPtrWidth + regs.kernargPreloadDwords;

  unsigned workgroupBase = regs.userSGPRCount;
  regs.workgroupIdSGPRs = {workgroupBase, workgroupBase + 1, workgroupBase + 2};
  regs.reservedSGPRs = regs.userSGPRCount + regs.workgroupIdSGPRs.size();
  regs.workitemIdXVGPR = 0;
  regs.reservedVGPRs = 1;
  return regs;
}

unsigned getWaveAMDReservedSGPRs(func::FuncOp func) {
  return getWaveAMDKernelEntryRegs(func).reservedSGPRs;
}

unsigned getWaveAMDReservedVGPRs(func::FuncOp func) {
  return getWaveAMDKernelEntryRegs(func).reservedVGPRs;
}

std::string getWaveAMDSGPRName(unsigned index, unsigned width) {
  assert(width > 0 && "SGPR tuple must be non-empty");
  if (width == 1)
    return ("s" + llvm::Twine(index)).str();
  return ("s[" + llvm::Twine(index) + ":" + llvm::Twine(index + width - 1) +
          "]")
      .str();
}

static FailureOr<std::unique_ptr<llvm::MCSubtargetInfo>>
createSubtargetInfo(Operation *op, StringRef consumer) {
  FailureOr<waveamdmachine::AMDGPUTarget> target =
      waveamdmachine::getAMDGPUTarget(op, consumer);
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
  if (llvm::AMDGPU::getIsaVersion(target->chip).Major == 0)
    return op->emitError("unsupported AMDGPU target: ")
           << target->triple << "--" << target->chip;
  return sti;
}

FailureOr<bool> supportsWaveAMDKernargPreload(Operation *op,
                                              StringRef consumer) {
  FailureOr<std::unique_ptr<llvm::MCSubtargetInfo>> sti =
      createSubtargetInfo(op, consumer);
  if (failed(sti))
    return failure();
  return llvm::AMDGPU::hasKernargPreload(**sti);
}

LogicalResult verifyWaveAMDKernargPreloadTarget(func::FuncOp func,
                                                StringRef consumer) {
  if (!hasWaveAMDKernargPreloadRequest(func))
    return success();
  FailureOr<bool> supported = supportsWaveAMDKernargPreload(func, consumer);
  if (failed(supported))
    return failure();
  if (*supported)
    return success();
  return func.emitError(consumer)
         << " kernarg preload requires target with kernarg-preload feature";
}

FailureOr<WaveAMDRegisterLimits> getWaveAMDRegisterLimits(Operation *op) {
  FailureOr<std::unique_ptr<llvm::MCSubtargetInfo>> sti =
      createSubtargetInfo(op, "waveamd register limits");
  if (failed(sti))
    return failure();

  WaveAMDRegisterLimits limits;
  limits.addressableSGPRs =
      llvm::AMDGPU::IsaInfo::getAddressableNumSGPRs(sti->get());
  limits.addressableVGPRs = llvm::AMDGPU::IsaInfo::getAddressableNumVGPRs(
      sti->get(), /*DynamicVGPRBlockSize=*/0);
  limits.sgprAllocGranule =
      llvm::AMDGPU::IsaInfo::getSGPRAllocGranule(sti->get());
  limits.vgprAllocGranule = llvm::AMDGPU::IsaInfo::getVGPRAllocGranule(
      sti->get(), /*DynamicVGPRBlockSize=*/0);
  limits.maxWavesPerEU = llvm::AMDGPU::IsaInfo::getMaxWavesPerEU(sti->get());
  limits.maxSGPRsForWaves.assign(limits.maxWavesPerEU + 1, 0);
  limits.maxVGPRsForWaves.assign(limits.maxWavesPerEU + 1, 0);
  for (unsigned waves = 1; waves <= limits.maxWavesPerEU; ++waves) {
    limits.maxSGPRsForWaves[waves] =
        llvm::AMDGPU::IsaInfo::getMaxNumSGPRs(sti->get(), waves,
                                              /*Addressable=*/true);
    limits.maxVGPRsForWaves[waves] = llvm::AMDGPU::IsaInfo::getMaxNumVGPRs(
        sti->get(), waves, /*DynamicVGPRBlockSize=*/0);
  }
  return limits;
}

unsigned getEffectiveWaveAMDRegisterBudget(unsigned budget, unsigned reserved) {
  if (budget <= reserved)
    return 0;
  return budget - reserved;
}

unsigned getMaxWaveAMDRegisterBudgetForWaves(ArrayRef<unsigned> budgets,
                                             unsigned targetWaves) {
  if (targetWaves >= budgets.size())
    return 0;
  return budgets[targetWaves];
}

} // namespace mlir::wave
