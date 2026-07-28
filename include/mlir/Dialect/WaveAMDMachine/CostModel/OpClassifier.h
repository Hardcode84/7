//===- OpClassifier.h - wave.amd.machine -> SchedClass ----------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef MLIR_DIALECT_WAVEAMDMACHINE_COSTMODEL_OPCLASSIFIER_H
#define MLIR_DIALECT_WAVEAMDMACHINE_COSTMODEL_OPCLASSIFIER_H

#include "mlir/Dialect/WaveAMDMachine/CostModel/SchedClass.h"

namespace llvm::AMDGPU {
struct IsaVersion;
} // namespace llvm::AMDGPU

namespace mlir {
class Operation;
} // namespace mlir

namespace mlir::waveamdmachine {

struct ArchData;

// Bucket a wave.amd.machine op into a SchedClass. Aborts in debug
// builds on an unmapped op so coverage gaps surface during testing;
// release builds fall back to Write32Bit and emit a warning via
// llvm::errs().
SchedClass classifyOp(Operation *op);

unsigned getInstructionIssueCount(Operation *op,
                                  const llvm::AMDGPU::IsaVersion &targetIsa);

bool usesMfmaCoissueResource(Operation *op, SchedClass cls,
                             const ArchData &arch);

// True when the cost model has a non-fallback mapping for the op.
bool hasSchedClassMapping(Operation *op);

} // namespace mlir::waveamdmachine

#endif // MLIR_DIALECT_WAVEAMDMACHINE_COSTMODEL_OPCLASSIFIER_H
