//===- WaveAMDMachineTarget.h - AMDGPU target helpers ----------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef MLIR_DIALECT_WAVEAMDMACHINE_IR_WAVEAMDMACHINETARGET_H
#define MLIR_DIALECT_WAVEAMDMACHINE_IR_WAVEAMDMACHINETARGET_H

#include "mlir/IR/BuiltinOps.h"
#include "mlir/IR/Diagnostics.h"
#include "mlir/Support/LLVM.h"
#include "mlir/Support/LogicalResult.h"
#include "llvm/ADT/STLFunctionalExtras.h"
#include "llvm/ADT/StringRef.h"
#include "llvm/TargetParser/AMDGPUTargetParser.h"

#include <optional>
#include <string>

namespace mlir::waveamdmachine {

struct AMDGPUTarget {
  std::string triple;
  std::string chip;
  std::string features;
};

std::optional<AMDGPUTarget> parseAMDGPUTargetAttr(llvm::StringRef value);

FailureOr<AMDGPUTarget>
parseAMDGPUTargetAttr(llvm::StringRef value,
                      llvm::function_ref<InFlightDiagnostic()> emitError);

ModuleOp findAMDGPUTargetModule(Operation *op);

FailureOr<AMDGPUTarget> getAMDGPUTarget(Operation *op,
                                        llvm::StringRef consumer);

FailureOr<llvm::AMDGPU::IsaVersion>
getAMDGPUTargetIsaVersion(Operation *op, llvm::StringRef consumer);

bool supportsAGPRs(const llvm::AMDGPU::IsaVersion &isa);

bool supportsCvtPkF16F32Inst(const llvm::AMDGPU::IsaVersion &isa);

bool supportsCvtPkBF16F32Inst(const llvm::AMDGPU::IsaVersion &isa);

std::optional<unsigned> getAMDGPUDefaultWavefrontSize(llvm::StringRef chip);

FailureOr<unsigned> getAMDGPUDefaultWavefrontSize(Operation *op,
                                                  llvm::StringRef consumer);

FailureOr<unsigned> getAMDGPUWavefrontSize(Operation *op,
                                           llvm::StringRef consumer);

FailureOr<bool> getAMDGPUD16PreservesUnusedBits(Operation *op,
                                                llvm::StringRef consumer);

FailureOr<std::string> getAMDGPUAssemblerFeatures(Operation *op,
                                                  llvm::StringRef features,
                                                  llvm::StringRef consumer);

} // namespace mlir::waveamdmachine

#endif // MLIR_DIALECT_WAVEAMDMACHINE_IR_WAVEAMDMACHINETARGET_H
