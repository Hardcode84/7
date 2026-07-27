//===- WaveAMDMachineTarget.cpp - AMDGPU target helpers --------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachineTarget.h"

#include "llvm/ADT/SmallString.h"
#include "llvm/ADT/StringSet.h"
#include "llvm/ADT/Twine.h"
#include "llvm/TargetParser/Triple.h"

using namespace mlir;
using namespace mlir::waveamdmachine;

static constexpr char kWavefrontSizeAttr[] = "waveamdmachine.wavefront_size";

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
  return AMDGPUTarget{parts->triple.str(), chip.str(), features.str()};
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

  llvm::AMDGPU::IsaVersion isa = llvm::AMDGPU::getIsaVersion(target->chip);
  if (isa.Major == 0)
    return findAMDGPUTargetModule(op).emitError("unsupported AMDGPU target: ")
           << target->triple << "--" << target->chip;
  return isa;
}

bool mlir::waveamdmachine::supportsAGPRs(const llvm::AMDGPU::IsaVersion &isa) {
  return isa.Major == 9 &&
         ((isa.Minor == 0 && (isa.Stepping == 8 || isa.Stepping == 10)) ||
          isa.Minor == 4 || (isa.Minor == 5 && isa.Stepping == 0));
}

static bool isGfx950(const llvm::AMDGPU::IsaVersion &isa) {
  return isa.Major == 9 && isa.Minor == 5 && isa.Stepping == 0;
}

static bool isGfx125x(const llvm::AMDGPU::IsaVersion &isa) {
  return isa.Major == 12 && isa.Minor == 5;
}

bool mlir::waveamdmachine::supportsCvtPkF16F32Inst(
    const llvm::AMDGPU::IsaVersion &isa) {
  return isGfx950(isa) || isGfx125x(isa) || isa.Major == 13;
}

bool mlir::waveamdmachine::supportsCvtPkBF16F32Inst(
    const llvm::AMDGPU::IsaVersion &isa) {
  return isGfx950(isa) || isGfx125x(isa) || isa.Major == 13;
}

std::optional<unsigned>
mlir::waveamdmachine::getAMDGPUDefaultWavefrontSize(StringRef chip) {
  llvm::AMDGPU::IsaVersion isa = llvm::AMDGPU::getIsaVersion(chip);
  if (isa.Major == 0)
    return std::nullopt;
  return isa.Major == 8 || isa.Major == 9 ? 64 : 32;
}

FailureOr<unsigned>
mlir::waveamdmachine::getAMDGPUDefaultWavefrontSize(Operation *op,
                                                    StringRef consumer) {
  FailureOr<AMDGPUTarget> target = getAMDGPUTarget(op, consumer);
  if (failed(target))
    return failure();

  std::optional<unsigned> wavefrontSize =
      getAMDGPUDefaultWavefrontSize(target->chip);
  if (!wavefrontSize)
    return findAMDGPUTargetModule(op).emitError("unsupported AMDGPU target: ")
           << target->triple << "--" << target->chip;
  return *wavefrontSize;
}

static bool supportsWavefrontSize(const llvm::AMDGPU::IsaVersion &isa,
                                  unsigned width, unsigned defaultWidth) {
  if (width == defaultWidth)
    return true;
  if (isa.Major == 8 || isa.Major == 9)
    return false;
  if (isa.Major == 12 && isa.Minor == 5)
    return false;
  return isa.Major >= 10 && (width == 32 || width == 64);
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

  std::optional<unsigned> defaultWavefrontSize =
      getAMDGPUDefaultWavefrontSize(target->chip);
  if (!defaultWavefrontSize)
    return findAMDGPUTargetModule(op).emitError("unsupported AMDGPU target: ")
           << target->triple << "--" << target->chip;

  unsigned width = *defaultWavefrontSize;
  ModuleOp mod = findAMDGPUTargetModule(op);
  if (!mod->hasAttr(kWavefrontSizeAttr))
    return width;

  FailureOr<unsigned> attrWidth = readWavefrontSizeAttr(mod, consumer);
  if (failed(attrWidth))
    return failure();
  width = *attrWidth;

  llvm::AMDGPU::IsaVersion isa = llvm::AMDGPU::getIsaVersion(target->chip);
  if (!supportsWavefrontSize(isa, width, *defaultWavefrontSize))
    return mod.emitError(consumer)
           << " target " << target->chip << " does not support wave" << width;
  return width;
}

static void appendTargetFeature(SmallString<128> &features, StringRef feature) {
  if (!features.empty())
    features.push_back(',');
  features.append(feature);
}

static std::optional<bool> getTargetIDFeature(AMDGPUTarget target,
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
                                   AMDGPUTarget target) {
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

  llvm::AMDGPU::IsaVersion isa = llvm::AMDGPU::getIsaVersion(target->chip);
  if (isa.Major == 0)
    return findAMDGPUTargetModule(op).emitError("unsupported AMDGPU target: ")
           << target->triple << "--" << target->chip;
  if (isa.Major < 9)
    return false;

  llvm::AMDGPU::GPUKind kind = llvm::AMDGPU::parseArchAMDGCN(target->chip);
  bool supportsSRAMECC =
      llvm::AMDGPU::getArchAttrAMDGCN(kind) & llvm::AMDGPU::FEATURE_SRAMECC;
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

  llvm::AMDGPU::IsaVersion isa = llvm::AMDGPU::getIsaVersion(target->chip);
  FailureOr<unsigned> width = getAMDGPUWavefrontSize(op, consumer);
  if (failed(width))
    return failure();

  SmallString<128> resolved(features);
  appendTargetIDFeatures(resolved, *target);
  if (isa.Major >= 10) {
    appendTargetFeature(resolved,
                        *width == 32 ? "-wavefrontsize64" : "-wavefrontsize32");
    appendTargetFeature(resolved,
                        *width == 32 ? "+wavefrontsize32" : "+wavefrontsize64");
  }
  return resolved.str().str();
}
