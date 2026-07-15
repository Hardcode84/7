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

namespace regalloc_detail {
class RegAllocTransformStateCache;
}

LogicalResult buildRegAllocTransformAliasState(
    Operation *target, Builder &builder, bool coalesceMFMAAccResult = true,
    regalloc_detail::RegAllocTransformStateCache *cache = nullptr);

LogicalResult runRegAllocTransformLinearScan(
    Operation *target, Builder &builder,
    regalloc_detail::RegAllocTransformStateCache *cache = nullptr);

LogicalResult runRegAllocTransformAGPRRelief(
    Operation *target, Builder &builder,
    regalloc_detail::RegAllocTransformStateCache *cache = nullptr);

LogicalResult runRegAllocTransformRematRelief(
    Operation *target, Builder &builder,
    regalloc_detail::RegAllocTransformStateCache *cache = nullptr);

LogicalResult runRegAllocTransformSGPRToVGPRRelief(
    Operation *target, Builder &builder,
    regalloc_detail::RegAllocTransformStateCache *cache = nullptr);

LogicalResult runRegAllocTransformLDSRelief(
    Operation *target, Builder &builder,
    regalloc_detail::RegAllocTransformStateCache *cache = nullptr);

LogicalResult runRegAllocTransformScratchRelief(
    Operation *target, Builder &builder,
    regalloc_detail::RegAllocTransformStateCache *cache = nullptr);

} // namespace mlir::wave

#endif // MLIR_DIALECT_WAVE_TRANSFORMS_WAVEAMDREGALLOCTRANSFORMLOOP_H
