//===- WaveAMDRegAllocTransformLoop.h - Regalloc transforms ----*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef MLIR_DIALECT_WAVE_TRANSFORMS_WAVEAMDREGALLOCTRANSFORMLOOP_H
#define MLIR_DIALECT_WAVE_TRANSFORMS_WAVEAMDREGALLOCTRANSFORMLOOP_H

#include "mlir/IR/Builders.h"
#include "mlir/IR/Operation.h"
#include "mlir/Support/LogicalResult.h"

namespace mlir::wave {

LogicalResult
buildRegAllocTransformAliasState(Operation *target, Builder &builder,
                                 bool coalesceMFMAAccResult = true);

LogicalResult runRegAllocTransformLinearScan(Operation *target,
                                             Builder &builder);

LogicalResult runRegAllocTransformAGPRRelief(Operation *target,
                                             Builder &builder);

LogicalResult runRegAllocTransformRematRelief(Operation *target,
                                              Builder &builder);

LogicalResult runRegAllocTransformLDSRelief(Operation *target,
                                            Builder &builder);

LogicalResult runRegAllocTransformScratchRelief(Operation *target,
                                                Builder &builder);

} // namespace mlir::wave

#endif // MLIR_DIALECT_WAVE_TRANSFORMS_WAVEAMDREGALLOCTRANSFORMLOOP_H
