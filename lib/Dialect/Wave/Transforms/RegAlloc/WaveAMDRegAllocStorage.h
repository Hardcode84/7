//===- WaveAMDRegAllocStorage.h - Register storage semantics ----*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef MLIR_DIALECT_WAVE_TRANSFORMS_WAVEAMDREGALLOCSTORAGE_H
#define MLIR_DIALECT_WAVE_TRANSFORMS_WAVEAMDREGALLOCSTORAGE_H

#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachine.h"
#include "mlir/IR/Builders.h"
#include "mlir/Support/LogicalResult.h"

#include <optional>

namespace mlir::wave::regalloc_detail {

/// Machine storage properties consumed by regalloc.
struct RegAllocStorageProperties {
  waveamdmachine::RegType type;

  /// Dead value may provide storage for an exclusive join.
  bool mayAliasExclusiveJoin = false;
};

std::optional<RegAllocStorageProperties>
getRegAllocStorageProperties(Value value);

/// Materialize an independent virtual register and explicit bridge temporaries.
FailureOr<Value> materializeRegAllocCopy(OpBuilder &builder, Location loc,
                                         Value value);

} // namespace mlir::wave::regalloc_detail

#endif // MLIR_DIALECT_WAVE_TRANSFORMS_WAVEAMDREGALLOCSTORAGE_H
