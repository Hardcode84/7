//===- WaveAMDRegAllocPrep.h - WaveAMD regalloc preparation -----*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef MLIR_DIALECT_WAVE_TRANSFORMS_WAVEAMDREGALLOCPREP_H
#define MLIR_DIALECT_WAVE_TRANSFORMS_WAVEAMDREGALLOCPREP_H

#include "mlir/Support/LogicalResult.h"

namespace mlir {
namespace func {
class FuncOp;
} // namespace func

namespace wave {
// Rewrites carry/tuple alias cases into explicit SSA copies before intervals.
LogicalResult prepareWaveAMDRegAllocIR(func::FuncOp func);

} // namespace wave
} // namespace mlir

#endif // MLIR_DIALECT_WAVE_TRANSFORMS_WAVEAMDREGALLOCPREP_H
