//===- WaveAMDRegisterLimits.cpp - AMDGPU register budgets ----------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "WaveAMDRegisterLimits.h"

#include "MCTargetDesc/AMDGPUMCTargetDesc.h"
#include "Utils/AMDGPUBaseInfo.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/Wave/IR/Wave.h"
#include "mlir/Dialect/Wave/IR/WaveAMDABI.h"
#include "mlir/Dialect/Wave/Transforms/WaveAMDClusterInfo.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachine.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachineTarget.h"
#include "llvm/ADT/Twine.h"
#include "llvm/MC/MCRegisterInfo.h"
#include "llvm/MC/MCSubtargetInfo.h"
#include "llvm/Support/MathExtras.h"
#include "llvm/TargetParser/AMDGPUTargetParser.h"
#include "llvm/TargetParser/TargetParser.h"

#include <algorithm>
#include <limits>

using namespace mlir;

namespace mlir::wave {

bool WaveAMDRegisterLimits::hasSGPRTupleLegalBases(unsigned width) const {
  return sgprTupleLegalBases.contains(width);
}

bool WaveAMDRegisterLimits::isSGPRTupleBaseLegal(unsigned width,
                                                 unsigned base) const {
  auto it = sgprTupleLegalBases.find(width);
  return it != sgprTupleLegalBases.end() && base < it->second.size() &&
         it->second.test(base);
}

bool isWaveAMDRegisterTupleBaseLegal(const WaveAMDRegisterLimits &limits,
                                     waveamdmachine::RegClass regClass,
                                     unsigned width, unsigned base) {
  if (width <= 1)
    return true;
  if (regClass == waveamdmachine::RegClass::SGPR &&
      limits.hasSGPRTupleLegalBases(width))
    return limits.isSGPRTupleBaseLegal(width, base);
  unsigned alignment = llvm::PowerOf2Ceil(width);
  if (regClass == waveamdmachine::RegClass::VGPR && limits.vgprTupleAlignment)
    alignment = limits.vgprTupleAlignment;
  return base % alignment == 0;
}

StringRef getWaveAMDKernargPreloadLengthAttrName() {
  return "waveamdmachine.kernarg_preload_length";
}

StringRef getWaveAMDKernargPreloadOffsetAttrName() {
  return "waveamdmachine.kernarg_preload_offset";
}

StringRef getWaveAMDWorkitemIdAxisAttrName() {
  return "waveamdmachine.workitem_id_axis";
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
  if (regs.kernargPreloadDwords == 0 &&
      !func->hasAttr(getWaveAMDKernargPreloadLengthAttrName()) &&
      !func->hasAttr(getWaveAMDKernargPreloadOffsetAttrName()))
    regs.kernargPreloadDwords = getWaveAMDDefaultKernargPreloadDwords(func);
  regs.userSGPRCount = regs.kernargSegmentPtrWidth + regs.kernargPreloadDwords;

  unsigned workgroupBase = regs.userSGPRCount;
  regs.workgroupIdSGPRs = {workgroupBase, workgroupBase + 1, workgroupBase + 2};
  regs.reservedSGPRs = regs.userSGPRCount + regs.workgroupIdSGPRs.size();
  regs.workitemIdVGPRs = {0, 1, 2};
  regs.reservedVGPRs = 1;
  func.walk([&](Operation *op) {
    if (isa<waveamdmachine::VWorkitemIdYOp>(op))
      regs.reservedVGPRs = std::max(regs.reservedVGPRs, 2u);
    if (isa<waveamdmachine::VWorkitemIdZOp>(op))
      regs.reservedVGPRs = std::max(regs.reservedVGPRs, 3u);
  });
  return regs;
}

unsigned getWaveAMDReservedSGPRs(func::FuncOp func) {
  return getWaveAMDKernelEntryRegs(func).reservedSGPRs;
}

unsigned getWaveAMDReservedVGPRs(func::FuncOp func) {
  return getWaveAMDKernelEntryRegs(func).reservedVGPRs;
}

unsigned getWaveAMDMinReportedVGPRs(func::FuncOp func) {
  return std::max(1u, getWaveAMDReservedVGPRs(func));
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
  return waveamdmachine::createAMDGPUMCSubtargetInfo(op, consumer);
}

static bool usesWorkgroupId(func::FuncOp func) {
  return func
      .walk([&](Operation *op) {
        if (isa<waveamdmachine::SWorkgroupIdXOp,
                waveamdmachine::SWorkgroupIdYOp,
                waveamdmachine::SWorkgroupIdZOp>(op))
          return WalkResult::interrupt();
        return WalkResult::advance();
      })
      .wasInterrupted();
}

FailureOr<unsigned> getWaveAMDMinReportedSGPRs(func::FuncOp func,
                                               StringRef consumer) {
  unsigned minimum = std::max(1u, getWaveAMDReservedSGPRs(func) + 1);
  if (!func || !func->hasAttr(wave::WaveDialect::getKernelAttrName()) ||
      !usesWorkgroupId(func))
    return minimum;

  FailureOr<std::unique_ptr<llvm::MCSubtargetInfo>> sti =
      createSubtargetInfo(func, consumer);
  if (failed(sti))
    return failure();
  std::optional<waveamdmachine::AMDGPUTargetCapabilities> capabilities =
      waveamdmachine::getAMDGPUTargetCapabilities(**sti);
  if (!capabilities || !capabilities->architectedSGPRs ||
      !capabilities->clusters)
    return minimum;

  FailureOr<std::optional<std::array<unsigned, 3>>> clusterDims =
      getWaveAMDFixedClusterDims(func, consumer);
  if (failed(clusterDims))
    return failure();
  if (*clusterDims)
    return minimum;

  constexpr unsigned clusterWorkgroupIdTemps = 2;
  return std::max(minimum,
                  getWaveAMDReservedSGPRs(func) + clusterWorkgroupIdTemps);
}

FailureOr<bool> hasWaveAMDPackedTID(Operation *op, StringRef consumer) {
  FailureOr<std::unique_ptr<llvm::MCSubtargetInfo>> sti =
      createSubtargetInfo(op, consumer);
  if (failed(sti))
    return failure();
  return (*sti)->checkFeatures("+packed-tid");
}

FailureOr<bool> supportsWaveAMDKernargPreload(Operation *op,
                                              StringRef consumer) {
  FailureOr<std::unique_ptr<llvm::MCSubtargetInfo>> sti =
      createSubtargetInfo(op, consumer);
  if (failed(sti))
    return failure();
  return llvm::AMDGPU::hasKernargPreload(**sti);
}

FailureOr<unsigned> getWaveAMDMaxKernargPreloadDwords(Operation *op,
                                                      StringRef consumer) {
  FailureOr<std::unique_ptr<llvm::MCSubtargetInfo>> sti =
      createSubtargetInfo(op, consumer);
  if (failed(sti))
    return failure();
  if (!llvm::AMDGPU::hasKernargPreload(**sti))
    return 0;
  unsigned maxUserSGPRs = llvm::AMDGPU::getMaxNumUserSGPRs(**sti);
  if (maxUserSGPRs <= 2)
    return 0;
  return maxUserSGPRs - 2;
}

static unsigned getCompletePrefixDwords(ArrayRef<waveamd::KernargSlot> layout,
                                        unsigned maxDwords) {
  unsigned prefix = 0;
  for (const waveamd::KernargSlot &slot : layout) {
    unsigned end = (slot.offset + slot.size + 3) / 4;
    if (end > maxDwords)
      break;
    prefix = end;
  }
  return prefix;
}

unsigned getWaveAMDDefaultKernargPreloadDwords(func::FuncOp func) {
  if (!waveamdmachine::findAMDGPUTargetModule(func))
    return 0;
  FailureOr<unsigned> maxDwords =
      getWaveAMDMaxKernargPreloadDwords(func, "waveamd entry registers");
  if (failed(maxDwords))
    return 0;
  SmallVector<waveamd::KernargSlot> layout =
      waveamd::getKernargLayout(func.getFunctionType().getInputs());
  return getCompletePrefixDwords(layout, *maxDwords);
}

static std::optional<waveamdmachine::AMDGPUTargetCapabilities>
getTargetCapabilities(const llvm::MCSubtargetInfo &sti) {
  return waveamdmachine::getAMDGPUTargetCapabilities(sti);
}

static unsigned getLowVGPRAddressableCount(const llvm::MCSubtargetInfo &sti) {
  llvm::AMDGPUDwarfFlavour flavour =
      llvm::AMDGPU::IsaInfo::getWavefrontSize(sti) == 32 ? llvm::Wave32
                                                         : llvm::Wave64;
  std::unique_ptr<llvm::MCRegisterInfo> mri(
      llvm::createGCNMCRegisterInfo(flavour));
  return mri->getRegClass(llvm::AMDGPU::VGPR_32_Lo256RegClassID).getNumRegs();
}

static unsigned getAddressableAGPRs(const llvm::MCSubtargetInfo &sti) {
  return waveamdmachine::getAMDGPUAddressableAGPRs(sti);
}

static llvm::DenseMap<unsigned, llvm::BitVector>
getSGPRTupleLegalBases(const llvm::MCSubtargetInfo &sti,
                       unsigned addressableSGPRs) {
  llvm::AMDGPUDwarfFlavour flavour =
      llvm::AMDGPU::IsaInfo::getWavefrontSize(sti) == 32 ? llvm::Wave32
                                                         : llvm::Wave64;
  std::unique_ptr<llvm::MCRegisterInfo> mri(
      llvm::createGCNMCRegisterInfo(flavour));
  llvm::DenseMap<unsigned, llvm::BitVector> legalBases;
  waveamdmachine::forEachAMDGPUAllocatableSGPRTuple(
      *mri, addressableSGPRs, [&](unsigned width, unsigned base, unsigned) {
        llvm::BitVector &widthBases = legalBases[width];
        if (widthBases.empty())
          widthBases.resize(addressableSGPRs);
        widthBases.set(base);
      });
  return legalBases;
}

FailureOr<WaveAMDLocalMemoryLimits>
getWaveAMDLocalMemoryLimits(Operation *op, StringRef consumer) {
  FailureOr<std::unique_ptr<llvm::MCSubtargetInfo>> sti =
      createSubtargetInfo(op, consumer);
  if (failed(sti))
    return failure();
  if (std::optional<waveamdmachine::AMDGPUTargetCapabilities> capabilities =
          getTargetCapabilities(**sti))
    return WaveAMDLocalMemoryLimits{capabilities->localMemoryBytes,
                                    capabilities->addressableLocalMemoryBytes};
  return WaveAMDLocalMemoryLimits{
      llvm::AMDGPU::IsaInfo::getLocalMemorySize(**sti),
      llvm::AMDGPU::IsaInfo::getAddressableLocalMemorySize(**sti)};
}

FailureOr<bool> needsWaveAMDKernargPreloadCompatProlog(Operation *op,
                                                       StringRef consumer) {
  FailureOr<std::unique_ptr<llvm::MCSubtargetInfo>> sti =
      createSubtargetInfo(op, consumer);
  if (failed(sti))
    return failure();
  if (!llvm::AMDGPU::hasKernargPreload(**sti))
    return false;
  return !llvm::AMDGPU::isGFX1250Plus(**sti);
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

LogicalResult verifyWaveAMDKernargPreloadRuntimeSupport(func::FuncOp func,
                                                        StringRef consumer) {
  if (!hasWaveAMDKernargPreloadRequest(func))
    return success();
  if (failed(verifyWaveAMDKernargPreloadTarget(func, consumer)))
    return failure();
  FailureOr<bool> needsProlog =
      needsWaveAMDKernargPreloadCompatProlog(func, consumer);
  if (failed(needsProlog))
    return failure();
  if (!*needsProlog)
    return success();
  return func.emitError(consumer)
         << " kernarg preload requires a compatibility prolog on this target; "
            "Wave backend does not implement one";
}

FailureOr<WaveAMDRegisterLimits> getWaveAMDRegisterLimits(Operation *op) {
  FailureOr<std::unique_ptr<llvm::MCSubtargetInfo>> sti =
      createSubtargetInfo(op, "waveamd register limits");
  if (failed(sti))
    return failure();

  llvm::AMDGPU::GPUKind gpuKind =
      llvm::AMDGPU::parseArchAMDGCN((*sti)->getCPU());
  std::optional<waveamdmachine::AMDGPUTargetCapabilities> capabilities =
      getTargetCapabilities(**sti);
  unsigned addressableSGPRs =
      capabilities ? capabilities->addressableSGPRs
                   : llvm::AMDGPU::getAddressableNumSGPRs(gpuKind);
  unsigned addressableVGPRs =
      capabilities ? capabilities->addressableVGPRs
                   : llvm::AMDGPU::IsaInfo::getAddressableNumVGPRs(
                         **sti, /*DynamicVGPRBlockSize=*/0);
  unsigned addressableAGPRs = capabilities ? capabilities->addressableAGPRs
                                           : getAddressableAGPRs(**sti);
  unsigned vgprAllocGranule = capabilities
                                  ? capabilities->vgprAllocationGranule
                                  : llvm::AMDGPU::IsaInfo::getVGPRAllocGranule(
                                        **sti, /*DynamicVGPRBlockSize=*/0);
  unsigned maxWavesPerEU = capabilities
                               ? capabilities->maxWavesPerEU
                               : llvm::AMDGPU::IsaInfo::getMaxWavesPerEU(**sti);
  WaveAMDRegisterLimits limits;
  limits.sgprTupleLegalBases = getSGPRTupleLegalBases(**sti, addressableSGPRs);
  limits.addressableSGPRs = addressableSGPRs;
  limits.addressableVGPRs =
      capabilities
          ? addressableVGPRs
          : std::min(addressableVGPRs, getLowVGPRAddressableCount(**sti));
  limits.addressableAGPRs = addressableAGPRs;
  limits.sgprAllocGranule = llvm::AMDGPU::getSGPRAllocGranule(gpuKind);
  limits.vgprAllocGranule = vgprAllocGranule;
  limits.agprAllocGranule = limits.vgprAllocGranule;
  limits.vgprTupleAlignment =
      capabilities ? capabilities->vgprTupleAlignment : 0;
  limits.maxWavesPerEU = maxWavesPerEU;
  limits.hasTargetCapabilityContract = capabilities.has_value();
  limits.agprCountsAgainstVGPRs = llvm::AMDGPU::isGFX90A(**sti);
  limits.maxSGPRsForWaves.assign(limits.maxWavesPerEU + 1, 0);
  limits.maxVGPRsForWaves.assign(limits.maxWavesPerEU + 1, 0);
  for (unsigned waves = 1; waves <= limits.maxWavesPerEU; ++waves) {
    limits.maxSGPRsForWaves[waves] =
        llvm::AMDGPU::IsaInfo::getMaxNumSGPRs(**sti, waves,
                                              /*Addressable=*/true);
    limits.maxVGPRsForWaves[waves] = llvm::AMDGPU::IsaInfo::getMaxNumVGPRs(
        **sti, waves, /*DynamicVGPRBlockSize=*/0);
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
