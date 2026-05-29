//===- WaveAMDRegAllocVerification.h - Post-regalloc checks -----*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef MLIR_DIALECT_WAVE_TRANSFORMS_WAVEAMDREGALLOCVERIFICATION_H
#define MLIR_DIALECT_WAVE_TRANSFORMS_WAVEAMDREGALLOCVERIFICATION_H

#include "mlir/Support/LLVM.h"
#include "mlir/Support/LogicalResult.h"

namespace mlir {
class Operation;

namespace func {
class FuncOp;
} // namespace func

namespace wave {

enum class WaveAMDRegAllocVerificationScope { Results, AllValues };

StringRef getWaveAMDRegAllocOverflowedAttrName();
StringRef getWaveAMDRegAllocOverflowedCountAttrName();

bool isWaveAMDRegAllocOverflowed(func::FuncOp func);
LogicalResult failIfWaveAMDRegAllocOverflowed(func::FuncOp func,
                                              StringRef consumer);

LogicalResult
verifyWaveAMDRegAllocation(func::FuncOp func, StringRef consumer,
                           WaveAMDRegAllocVerificationScope scope);
LogicalResult
verifyWaveAMDRegAllocations(Operation *root, StringRef consumer,
                            WaveAMDRegAllocVerificationScope scope);

} // namespace wave
} // namespace mlir

#endif // MLIR_DIALECT_WAVE_TRANSFORMS_WAVEAMDREGALLOCVERIFICATION_H
