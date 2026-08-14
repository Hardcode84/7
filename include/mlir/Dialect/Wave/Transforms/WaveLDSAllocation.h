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

#include <memory>

namespace mlir::wave {

struct WaveLDSRange {
  int64_t offset = 0;
  int64_t bytes = 0;
};

class WaveLDSAllocationAnalysis {
public:
  static FailureOr<std::unique_ptr<WaveLDSAllocationAnalysis>>
  create(func::FuncOp func);

  ~WaveLDSAllocationAnalysis();

  /// Returns largest 16-byte-aligned range free at `point`.
  FailureOr<int64_t> getLargestFreeRange(Operation *point, int64_t capacity,
                                         Value dependency = {},
                                         ArrayRef<WaveLDSRange> blocked = {});

  /// Returns first-fit offset for an allocation free at `point`.
  FailureOr<int64_t> findFreeOffset(Operation *point, int64_t capacity,
                                    int64_t bytes, int64_t align,
                                    Value dependency = {},
                                    ArrayRef<WaveLDSRange> blocked = {});

  /// Refreshes token ordering after a client materializes new dependencies.
  void refreshTokenOrdering();

  /// Returns true when `dependency` proves `completion` through a barrier.
  bool completesThroughBarrier(Value dependency, Value completion);

private:
  struct Impl;

  explicit WaveLDSAllocationAnalysis(std::unique_ptr<Impl> impl);

  std::unique_ptr<Impl> impl;
};

} // namespace mlir::wave

#endif // MLIR_DIALECT_WAVE_TRANSFORMS_WAVELDSALLOCATION_H
