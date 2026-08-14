//===- WaveLDSRegionLiveness.h - Region-aware LDS lifetimes ----*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef MLIR_DIALECT_WAVE_TRANSFORMS_WAVELDSREGIONLIVENESS_H
#define MLIR_DIALECT_WAVE_TRANSFORMS_WAVELDSREGIONLIVENESS_H

#include "mlir/IR/Operation.h"
#include "llvm/ADT/ArrayRef.h"

namespace mlir::wave {

/// Returns whether two operations can execute in different invocations of a
/// common repetitive region or in the same region-branch path.
bool waveLDSOperationsMayCoexecute(Operation *lhs, Operation *rhs);

/// Returns whether every operation in two complete allocation lifetimes is
/// confined to mutually exclusive region-branch paths in one invocation.
bool waveLDSLifetimesAreMutuallyExclusive(ArrayRef<Operation *> lhs,
                                          ArrayRef<Operation *> rhs);

} // namespace mlir::wave

#endif // MLIR_DIALECT_WAVE_TRANSFORMS_WAVELDSREGIONLIVENESS_H
