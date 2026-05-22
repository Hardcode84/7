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

/// Emit AMDGPU assembly + assemble + lld-link an already-lowered module
/// of WaveAMDMachine IR into a HSACO blob. `op` must be a `ModuleOp`
/// carrying a `waveamdmachine.target` attribute. No wave-to-AMDGPU pass
/// pipeline runs here; the caller is responsible for lowering the input
/// via the transform interpreter beforehand.
LogicalResult assembleWaveAMDGPUKernels(Operation *op, StringRef triple,
                                        StringRef chip, StringRef features,
                                        SmallVectorImpl<char> &out);

/// Register the `wave-to-amdgpu-asm` mlir-translate entry point.
void registerWaveToAMDGPUTranslation();

} // namespace wave
} // namespace mlir

#endif // MLIR_TARGET_WAVE_AMDGPU_H
