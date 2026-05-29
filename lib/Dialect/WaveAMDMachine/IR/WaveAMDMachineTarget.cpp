//===- WaveAMDMachineTarget.cpp - AMDGPU target helpers --------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachineTarget.h"

#include "llvm/TargetParser/Triple.h"

using namespace mlir;
using namespace mlir::waveamdmachine;

std::optional<AMDGPUTarget>
mlir::waveamdmachine::parseAMDGPUTargetAttr(StringRef value) {
  size_t first = value.find("--");
  if (first == StringRef::npos || first == 0 || first + 2 == value.size())
    return std::nullopt;
  if (value.find("--", first + 2) != StringRef::npos)
    return std::nullopt;

  StringRef triple = value.take_front(first);
  StringRef chip = value.drop_front(first + 2);
  if (llvm::Triple(triple).getArch() != llvm::Triple::amdgcn)
    return std::nullopt;
  return AMDGPUTarget{triple, chip};
}

FailureOr<AMDGPUTarget> mlir::waveamdmachine::parseAMDGPUTargetAttr(
    StringRef value, function_ref<InFlightDiagnostic()> emitError) {
  std::optional<AMDGPUTarget> target = parseAMDGPUTargetAttr(value);
  if (target)
    return *target;
  emitError() << "malformed waveamdmachine.target `" << value
              << "`; expected `<amdgcn-triple>--<chip>`";
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
