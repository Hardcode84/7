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
#include "llvm/MC/MCSubtargetInfo.h"
#include "llvm/MC/TargetRegistry.h"
#include "llvm/Support/TargetSelect.h"
#include "llvm/TargetParser/TargetParser.h"
#include "llvm/TargetParser/Triple.h"

using namespace mlir;

namespace mlir::wave {

static ModuleOp findTargetModule(Operation *op) {
  ModuleOp mod = op->getParentOfType<ModuleOp>();
  if (!mod)
    mod = dyn_cast<ModuleOp>(op);
  while (mod && !mod->hasAttr("waveamdmachine.target"))
    mod = mod->getParentOfType<ModuleOp>();
  return mod;
}

static FailureOr<std::unique_ptr<llvm::MCSubtargetInfo>>
createSubtargetInfo(Operation *op) {
  ModuleOp mod = findTargetModule(op);
  if (!mod)
    return op->emitError("requires a waveamdmachine.target module attribute");

  StringAttr targetAttr =
      mod->getAttrOfType<StringAttr>("waveamdmachine.target");
  StringRef target = targetAttr.getValue();
  std::pair<StringRef, StringRef> split = target.rsplit("--");
  StringRef cpu = split.second.empty() ? target : split.second;

  static llvm::once_flag initializeBackendOnce;
  llvm::call_once(initializeBackendOnce, []() {
    llvm::InitializeAllTargetInfos();
    llvm::InitializeAllTargetMCs();
  });

  llvm::Triple triple("amdgcn-amd-amdhsa");
  std::string error;
  const llvm::Target *llvmTarget =
      llvm::TargetRegistry::lookupTarget(triple, error);
  if (!llvmTarget)
    return op->emitError("failed to lookup AMDGPU target: ") << error;

  std::unique_ptr<llvm::MCSubtargetInfo> sti(
      llvmTarget->createMCSubtargetInfo(triple, cpu, /*Features=*/""));
  if (!sti)
    return op->emitError("unsupported AMDGPU target: ") << target;
  if (llvm::AMDGPU::getIsaVersion(cpu).Major == 0)
    return op->emitError("unsupported AMDGPU target: ") << target;
  return sti;
}

FailureOr<WaveAMDRegisterLimits> getWaveAMDRegisterLimits(Operation *op) {
  FailureOr<std::unique_ptr<llvm::MCSubtargetInfo>> sti =
      createSubtargetInfo(op);
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

unsigned getWaveAMDReservedSGPRs(func::FuncOp func) {
  // Kernel ABI preloads kernarg + workgroup ids in s[0:4].
  return func->hasAttr(wave::WaveDialect::getKernelAttrName()) ? 5 : 0;
}

unsigned getWaveAMDReservedVGPRs(func::FuncOp func) {
  // Kernel ABI preloads packed workitem id in v0.
  return func->hasAttr(wave::WaveDialect::getKernelAttrName()) ? 1 : 0;
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
