//===- WaveLDSAllocation.h - LDS allocation analysis ----------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef MLIR_DIALECT_WAVE_TRANSFORMS_WAVELDSALLOCATION_H
#define MLIR_DIALECT_WAVE_TRANSFORMS_WAVELDSALLOCATION_H

#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/IR/Value.h"
#include "mlir/Support/LLVM.h"

namespace mlir::wave {

/// Returns the largest 16-byte-aligned LDS range not blocked at `point`.
/// `dependency` retires ordered lifetimes; ignored allocations omit dead
/// ranges.
FailureOr<int64_t>
getWaveLDSLargestFreeRange(func::FuncOp func, Operation *point,
                           int64_t capacity, Value dependency = {},
                           ArrayRef<Value> ignoredAllocations = {});

} // namespace mlir::wave

#endif // MLIR_DIALECT_WAVE_TRANSFORMS_WAVELDSALLOCATION_H
