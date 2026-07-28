//===- WaveAMDMachineTarget.cpp - AMDGPU target helpers --------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachineTarget.h"

#include "MCTargetDesc/AMDGPUMCTargetDesc.h"
#include "SIDefines.h"
#include "Utils/AMDGPUBaseInfo.h"
#include "llvm/ADT/SmallString.h"
#include "llvm/ADT/StringSet.h"
#include "llvm/ADT/StringSwitch.h"
#include "llvm/ADT/Twine.h"
#include "llvm/MC/MCRegisterInfo.h"
#include "llvm/MC/MCSubtargetInfo.h"
#include "llvm/MC/TargetRegistry.h"
#include "llvm/Support/TargetSelect.h"
#include "llvm/TargetParser/Triple.h"

using namespace mlir;
using namespace mlir::waveamdmachine;

#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachineTargetEnums.cpp.inc"

static constexpr char kWavefrontSizeAttr[] = "waveamdmachine.wavefront_size";

static void appendTargetIDFeatures(SmallString<128> &resolved,
                                   const AMDGPUTarget &target);

static bool isValidTargetIDFeature(StringRef feature) {
  return feature == "sramecc+" || feature == "sramecc-" ||
         feature == "xnack+" || feature == "xnack-";
}

static bool parseTargetIDFeatures(StringRef features) {
  if (features.empty() || features.ends_with(":"))
    return false;

  llvm::StringSet<> seen;
  while (!features.empty()) {
    auto [feature, rest] = features.split(':');
    if (feature.empty() || !isValidTargetIDFeature(feature))
      return false;
    StringRef name = feature.drop_back();
    if (!seen.insert(name).second)
      return false;
    features = rest;
  }
  return true;
}

struct TargetParts {
  StringRef triple;
  StringRef chipAndFeatures;
};

static std::optional<TargetParts> splitTargetParts(StringRef value) {
  size_t first = value.find("--");
  if (first == StringRef::npos || first == 0 || first + 2 == value.size())
    return std::nullopt;
  if (value.find("--", first + 2) != StringRef::npos)
    return std::nullopt;
  return TargetParts{value.take_front(first), value.drop_front(first + 2)};
}

static bool splitChipAndFeatures(StringRef chipAndFeatures, StringRef &chip,
                                 StringRef &features) {
  auto split = chipAndFeatures.split(':');
  chip = split.first;
  features = split.second;
  if (chip.empty())
    return false;
  if (chipAndFeatures.contains(':') && features.empty())
    return false;
  return features.empty() || parseTargetIDFeatures(features);
}

std::optional<AMDGPUTarget>
mlir::waveamdmachine::parseAMDGPUTargetAttr(StringRef value) {
  std::optional<TargetParts> parts = splitTargetParts(value);
  if (!parts)
    return std::nullopt;

  StringRef chip;
  StringRef features;
  if (!splitChipAndFeatures(parts->chipAndFeatures, chip, features))
    return std::nullopt;
  if (llvm::Triple(parts->triple).getArch() != llvm::Triple::amdgpu)
    return std::nullopt;
  AMDGPUTarget target;
  target.triple = parts->triple.str();
  target.chip = chip.str();
  target.features = features.str();
  target.isa = llvm::AMDGPU::getIsaVersion(chip);
  target.kind = llvm::AMDGPU::parseArchAMDGCN(chip);
  return target;
}

FailureOr<AMDGPUTarget> mlir::waveamdmachine::parseAMDGPUTargetAttr(
    StringRef value, function_ref<InFlightDiagnostic()> emitError) {
  std::optional<AMDGPUTarget> target = parseAMDGPUTargetAttr(value);
  if (target)
    return *target;
  emitError() << "malformed waveamdmachine.target `" << value
              << "`; expected `<amdgcn-triple>--<chip>[:sramecc(+|-)]"
                 "[:xnack(+|-)]`";
  return failure();
}

ModuleOp mlir::waveamdmachine::findAMDGPUTargetModule(Operation *op) {
  ModuleOp mod = dyn_cast<ModuleOp>(op);
  if (!mod)
    mod = op->getParentOfType<ModuleOp>();
  while (mod && !mod->hasAttr("waveamdmachine.target"))
    mod = mod->getParentOfType<ModuleOp>();
  return mod;
}

FailureOr<AMDGPUTarget>
mlir::waveamdmachine::getAMDGPUTarget(Operation *op, StringRef consumer) {
  ModuleOp mod = findAMDGPUTargetModule(op);
  if (!mod)
    return op->emitError(consumer)
           << " requires a waveamdmachine.target module attribute";

  StringAttr targetAttr =
      mod->getAttrOfType<StringAttr>("waveamdmachine.target");
  return parseAMDGPUTargetAttr(targetAttr.getValue(),
                               [&]() { return mod.emitError(); });
}

FailureOr<llvm::AMDGPU::IsaVersion>
mlir::waveamdmachine::getAMDGPUTargetIsaVersion(Operation *op,
                                                StringRef consumer) {
  FailureOr<AMDGPUTarget> target = getAMDGPUTarget(op, consumer);
  if (failed(target))
    return failure();

  if (target->isa.Major == 0)
    return findAMDGPUTargetModule(op).emitError("unsupported AMDGPU target: ")
           << target->triple << "--" << target->chip;
  return target->isa;
}

std::unique_ptr<llvm::MCSubtargetInfo>
mlir::waveamdmachine::createAMDGPUMCSubtargetInfo(const AMDGPUTarget &target,
                                                  std::string *error) {
  if (target.kind == llvm::AMDGPU::GK_NONE || target.isa.Major == 0) {
    if (error)
      *error = "unsupported AMDGPU processor: " + target.chip;
    return nullptr;
  }

  static llvm::once_flag initializeBackendOnce;
  llvm::call_once(initializeBackendOnce, []() {
    LLVMInitializeAMDGPUTargetInfo();
    LLVMInitializeAMDGPUTargetMC();
  });

  llvm::Triple triple(target.triple);
  std::string lookupError;
  const llvm::Target *llvmTarget =
      llvm::TargetRegistry::lookupTarget(triple, lookupError);
  if (!llvmTarget) {
    if (error)
      *error = lookupError;
    return nullptr;
  }

  SmallString<128> features;
  appendTargetIDFeatures(features, target);
  std::unique_ptr<llvm::MCSubtargetInfo> sti(
      llvmTarget->createMCSubtargetInfo(triple, target.chip, features));
  if (!sti && error)
    *error = "unsupported AMDGPU processor: " + target.chip;
  return sti;
}

FailureOr<std::unique_ptr<llvm::MCSubtargetInfo>>
mlir::waveamdmachine::createAMDGPUMCSubtargetInfo(Operation *op,
                                                  StringRef consumer) {
  FailureOr<AMDGPUTarget> target = getAMDGPUTarget(op, consumer);
  if (failed(target))
    return failure();

  std::string error;
  std::unique_ptr<llvm::MCSubtargetInfo> sti =
      createAMDGPUMCSubtargetInfo(*target, &error);
  if (!sti)
    return op->emitError("failed to create AMDGPU subtarget: ") << error;
  return sti;
}

unsigned mlir::waveamdmachine::getAMDGPULocalMemoryBankCount(
    const llvm::MCSubtargetInfo &sti) {
  // MC exposes LDS bank count through feature bits only.
  if (sti.hasFeature(llvm::AMDGPU::FeatureLDSBankCount32))
    return 32;
  if (sti.hasFeature(llvm::AMDGPU::FeatureLDSBankCount16))
    return 16;
  return 0;
}

static unsigned getVGPRTupleAlignment(const llvm::MCSubtargetInfo &sti) {
  llvm::AMDGPUDwarfFlavour flavour =
      llvm::AMDGPU::IsaInfo::getWavefrontSize(sti) == 32 ? llvm::Wave32
                                                         : llvm::Wave64;
  std::unique_ptr<llvm::MCRegisterInfo> mri(
      llvm::createGCNMCRegisterInfo(flavour));
  unsigned classID = sti.hasFeature(llvm::AMDGPU::FeatureRequiresAlignedVGPRs)
                         ? llvm::AMDGPU::VReg_64_Align2RegClassID
                         : llvm::AMDGPU::VReg_64RegClassID;
  return mri->getRegClass(classID).TSFlags &
         llvm::SIRCFlags::RegTupleAlignUnitsMask;
}

unsigned mlir::waveamdmachine::getAMDGPUAddressableAGPRs(
    const llvm::MCSubtargetInfo &sti) {
  if (!llvm::AMDGPU::hasMAIInsts(sti))
    return 0;
  llvm::AMDGPUDwarfFlavour flavour =
      llvm::AMDGPU::IsaInfo::getWavefrontSize(sti) == 32 ? llvm::Wave32
                                                         : llvm::Wave64;
  std::unique_ptr<llvm::MCRegisterInfo> mri(
      llvm::createGCNMCRegisterInfo(flavour));
  return mri->getRegClass(llvm::AMDGPU::AGPR_32RegClassID).getNumRegs();
}

std::optional<AMDGPUTargetCapabilities>
mlir::waveamdmachine::getAMDGPUTargetCapabilities(
    const llvm::MCSubtargetInfo &sti) {
  llvm::AMDGPU::GPUKind kind = llvm::AMDGPU::parseArchAMDGCN(sti.getCPU());
  if (kind != llvm::AMDGPU::GK_GFX1250 && kind != llvm::AMDGPU::GK_GFX1251)
    return std::nullopt;

  AMDGPUTargetCapabilities capabilities;
  capabilities.isa = llvm::AMDGPU::getIsaVersion(sti.getCPU());
  capabilities.defaultWavefrontSize =
      llvm::AMDGPU::IsaInfo::getWavefrontSize(sti);
  bool supportsAlternateWaveSize = llvm::AMDGPU::supportsWave32(sti);
  capabilities.supportsWave32 =
      capabilities.defaultWavefrontSize == 32 || supportsAlternateWaveSize;
  capabilities.supportsWave64 =
      capabilities.defaultWavefrontSize == 64 || supportsAlternateWaveSize;
  capabilities.addressableSGPRs = llvm::AMDGPU::getAddressableNumSGPRs(kind);
  capabilities.addressableVGPRs =
      llvm::AMDGPU::IsaInfo::getAddressableNumArchVGPRs(sti);
  capabilities.addressableAGPRs = getAMDGPUAddressableAGPRs(sti);
  capabilities.vgprAllocationGranule =
      llvm::AMDGPU::IsaInfo::getVGPRAllocGranule(sti,
                                                 /*DynamicVGPRBlockSize=*/0);
  capabilities.vgprTupleAlignment = getVGPRTupleAlignment(sti);
  capabilities.localMemoryBytes =
      llvm::AMDGPU::IsaInfo::getLocalMemorySize(sti);
  capabilities.addressableLocalMemoryBytes =
      llvm::AMDGPU::IsaInfo::getAddressableLocalMemorySize(sti);
  capabilities.localMemoryBankCount = getAMDGPULocalMemoryBankCount(sti);
  capabilities.maxWavesPerEU = llvm::AMDGPU::IsaInfo::getMaxWavesPerEU(sti);
  capabilities.maxUserSGPRs = llvm::AMDGPU::getMaxNumUserSGPRs(sti);
  if (sti.hasFeature(llvm::AMDGPU::Feature45BitNumRecordsBufferResource)) {
    // LLVM exposes this layout as one feature, not two field-width queries.
    capabilities.bufferResourceBaseBits = 57;
    capabilities.bufferResourceNumRecordsBits = 45;
  }
  capabilities.kernelDescriptor.dx10ClampAndIEEEMode =
      sti.hasFeature(llvm::AMDGPU::FeatureDX10ClampAndIEEEMode);
  capabilities.kernelDescriptor.wgpMode = llvm::AMDGPU::supportsWGP(sti);
  capabilities.kernelDescriptor.sharedVGPRCount =
      llvm::AMDGPU::isGFX10_GFX11(sti);
  capabilities.kernelDescriptor.roundRobin = llvm::AMDGPU::isGFX12Plus(sti);
  capabilities.kernelDescriptor.namedBarrierCount =
      llvm::AMDGPU::isGFX1250Plus(sti);
  capabilities.architectedFlatScratch =
      llvm::AMDGPU::hasArchitectedFlatScratch(sti);
  capabilities.kernelDescriptor.architectedPrivateSegment =
      capabilities.architectedFlatScratch;
  capabilities.architectedSGPRs =
      sti.hasFeature(llvm::AMDGPU::FeatureArchitectedSGPRs);
  capabilities.clusters = sti.hasFeature(llvm::AMDGPU::FeatureClusters);
  capabilities.waitCounterFamily = llvm::AMDGPU::isGFX12Plus(sti)
                                       ? WaitCounterFamily::Gfx12Split
                                       : WaitCounterFamily::Legacy;
  capabilities.matrixFamily =
      sti.hasFeature(llvm::AMDGPU::FeatureGFX1251GEMMInsts)
          ? MatrixFamily::Gfx1251
          : MatrixFamily::Gfx1250;
  capabilities.kernargPreload = llvm::AMDGPU::hasKernargPreload(sti);
  capabilities.requiresInitialUnclausedVmem =
      sti.hasFeature(llvm::AMDGPU::FeatureRequiresInitialUnclausedVmem);
  capabilities.waitXcnt = sti.hasFeature(llvm::AMDGPU::FeatureWaitXcnt);
  capabilities.vgprWindowing =
      sti.hasFeature(llvm::AMDGPU::Feature1024AddressableVGPRs);
  capabilities.setregVGPRMSBFixup =
      sti.hasFeature(llvm::AMDGPU::FeatureSetregVGPRMSBFixup);
  return capabilities;
}

bool mlir::waveamdmachine::supportsAGPRs(const llvm::AMDGPU::IsaVersion &isa) {
  return isa.Major == 9 &&
         ((isa.Minor == 0 && (isa.Stepping == 8 || isa.Stepping == 10)) ||
          isa.Minor == 4 || (isa.Minor == 5 && isa.Stepping == 0));
}

static bool isGfx950(const llvm::AMDGPU::IsaVersion &isa) {
  return isa.Major == 9 && isa.Minor == 5 && isa.Stepping == 0;
}

static bool isGfx125Isa(const llvm::AMDGPU::IsaVersion &isa) {
  return isa.Major == 12 && isa.Minor == 5;
}

bool mlir::waveamdmachine::supportsCvtPkF16F32Inst(
    const llvm::AMDGPU::IsaVersion &isa) {
  return isGfx950(isa) || isGfx125Isa(isa) || isa.Major == 13;
}

bool mlir::waveamdmachine::supportsCvtPkBF16F32Inst(
    const llvm::AMDGPU::IsaVersion &isa) {
  return isGfx950(isa) || isGfx125Isa(isa) || isa.Major == 13;
}

std::optional<unsigned>
mlir::waveamdmachine::getAMDGPUDefaultWavefrontSize(StringRef chip) {
  AMDGPUTarget target;
  target.triple = "amdgcn-amd-amdhsa";
  target.chip = chip.str();
  target.isa = llvm::AMDGPU::getIsaVersion(chip);
  target.kind = llvm::AMDGPU::parseArchAMDGCN(chip);
  std::unique_ptr<llvm::MCSubtargetInfo> sti =
      createAMDGPUMCSubtargetInfo(target);
  if (!sti)
    return std::nullopt;
  return llvm::AMDGPU::IsaInfo::getWavefrontSize(*sti);
}

FailureOr<unsigned>
mlir::waveamdmachine::getAMDGPUDefaultWavefrontSize(Operation *op,
                                                    StringRef consumer) {
  FailureOr<std::unique_ptr<llvm::MCSubtargetInfo>> sti =
      createAMDGPUMCSubtargetInfo(op, consumer);
  if (failed(sti))
    return failure();
  return llvm::AMDGPU::IsaInfo::getWavefrontSize(**sti);
}

static bool supportsWavefrontSize(const llvm::MCSubtargetInfo &sti,
                                  unsigned width, unsigned defaultWidth) {
  if (width == defaultWidth)
    return true;
  return (width == 32 || width == 64) && llvm::AMDGPU::supportsWave32(sti);
}

static FailureOr<unsigned> readWavefrontSizeAttr(ModuleOp mod,
                                                 StringRef consumer) {
  Attribute raw = mod->getAttr(kWavefrontSizeAttr);
  if (!raw)
    return failure();
  IntegerAttr attr = dyn_cast<IntegerAttr>(raw);
  if (!attr)
    return mod.emitError(consumer)
           << " " << kWavefrontSizeAttr << " must be an integer attribute";
  int64_t width = attr.getInt();
  if (width != 32 && width != 64)
    return mod.emitError(consumer)
           << " " << kWavefrontSizeAttr << " must be 32 or 64";
  return static_cast<unsigned>(width);
}

FailureOr<unsigned>
mlir::waveamdmachine::getAMDGPUWavefrontSize(Operation *op,
                                             StringRef consumer) {
  FailureOr<AMDGPUTarget> target = getAMDGPUTarget(op, consumer);
  if (failed(target))
    return failure();

  std::string error;
  std::unique_ptr<llvm::MCSubtargetInfo> sti =
      createAMDGPUMCSubtargetInfo(*target, &error);
  if (!sti)
    return op->emitError("failed to create AMDGPU subtarget: ") << error;
  unsigned defaultWavefrontSize = llvm::AMDGPU::IsaInfo::getWavefrontSize(*sti);

  unsigned width = defaultWavefrontSize;
  ModuleOp mod = findAMDGPUTargetModule(op);
  if (!mod->hasAttr(kWavefrontSizeAttr))
    return width;

  FailureOr<unsigned> attrWidth = readWavefrontSizeAttr(mod, consumer);
  if (failed(attrWidth))
    return failure();
  width = *attrWidth;

  if (!supportsWavefrontSize(*sti, width, defaultWavefrontSize))
    return mod.emitError(consumer)
           << " target " << target->chip << " does not support wave" << width;
  return width;
}

static void appendTargetFeature(SmallString<128> &features, StringRef feature) {
  if (!features.empty())
    features.push_back(',');
  features.append(feature);
}

static std::optional<bool> getTargetIDFeature(const AMDGPUTarget &target,
                                              StringRef name) {
  StringRef features = target.features;
  while (!features.empty()) {
    auto [feature, rest] = features.split(':');
    if (feature.drop_back() == name)
      return feature.ends_with("+");
    features = rest;
  }
  return std::nullopt;
}

static void appendTargetIDFeatures(SmallString<128> &resolved,
                                   const AMDGPUTarget &target) {
  StringRef features = target.features;
  while (!features.empty()) {
    auto [feature, rest] = features.split(':');
    char sign = feature.back();
    appendTargetFeature(resolved,
                        Twine(sign).concat(feature.drop_back()).str());
    features = rest;
  }
}

FailureOr<bool>
mlir::waveamdmachine::getAMDGPUD16PreservesUnusedBits(Operation *op,
                                                      StringRef consumer) {
  FailureOr<AMDGPUTarget> target = getAMDGPUTarget(op, consumer);
  if (failed(target))
    return failure();

  if (target->isa.Major == 0)
    return findAMDGPUTargetModule(op).emitError("unsupported AMDGPU target: ")
           << target->triple << "--" << target->chip;
  if (target->isa.Major < 9)
    return false;

  bool supportsSRAMECC = llvm::AMDGPU::getArchAttrAMDGCN(target->kind) &
                         llvm::AMDGPU::FEATURE_SRAMECC;
  if (!supportsSRAMECC)
    return true;
  if (std::optional<bool> sramecc = getTargetIDFeature(*target, "sramecc"))
    return !*sramecc;
  return false;
}

FailureOr<std::string> mlir::waveamdmachine::getAMDGPUAssemblerFeatures(
    Operation *op, StringRef features, StringRef consumer) {
  FailureOr<AMDGPUTarget> target = getAMDGPUTarget(op, consumer);
  if (failed(target))
    return failure();

  FailureOr<unsigned> width = getAMDGPUWavefrontSize(op, consumer);
  if (failed(width))
    return failure();

  SmallString<128> resolved(features);
  appendTargetIDFeatures(resolved, *target);
  if (target->isa.Major >= 10) {
    appendTargetFeature(resolved,
                        *width == 32 ? "-wavefrontsize64" : "-wavefrontsize32");
    appendTargetFeature(resolved,
                        *width == 32 ? "+wavefrontsize32" : "+wavefrontsize64");
  }
  return resolved.str().str();
}
