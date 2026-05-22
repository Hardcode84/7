//===- AMDGPU.h - Wave to AMDGPU backend ------------------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef MLIR_TARGET_WAVE_AMDGPU_H
#define MLIR_TARGET_WAVE_AMDGPU_H

#include "mlir/Support/LLVM.h"
#include "llvm/ADT/StringRef.h"

namespace mlir {
class Operation;

namespace wave {

/// Emit AMDGPU assembly for the Wave dialect MVP.
///
/// Runs the staged WaveAMDMachine MLIR pipeline described by the
/// `transform.named_sequence` in `pipelineFile` (or the CMake-baked
/// default when empty) before emission. The emitter consumes inspectable
/// WaveAMDMachine IR rather than selecting source Wave operations
/// directly.
LogicalResult translateWaveToAMDGPU(Operation *op, raw_ostream &os,
                                    StringRef pipelineFile = {});

/// Run the wave-to-AMDGPU pipeline plus in-process assembly and linking,
/// producing a HSACO blob in memory. `op` must be a `ModuleOp` carrying a
/// `waveamdmachine.target` string attribute compatible with the WaveAMDMachine
/// backend; `op` is mutated in place by the pipeline. `triple`, `chip`, and
/// `features` describe the assembler/linker target. `pipelineFile` overrides
/// the default `transform.named_sequence` path; empty selects the default.
LogicalResult compileWaveToHSACO(Operation *op, StringRef triple,
                                 StringRef chip, StringRef features,
                                 StringRef pipelineFile,
                                 SmallVectorImpl<char> &out);

/// Register the `wave-to-amdgpu-asm` mlir-translate entry point.
void registerWaveToAMDGPUTranslation();

} // namespace wave
} // namespace mlir

#endif // MLIR_TARGET_WAVE_AMDGPU_H
