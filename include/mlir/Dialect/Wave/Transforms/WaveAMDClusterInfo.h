//===- WaveAMDClusterInfo.h - AMDGPU cluster metadata -----------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef MLIR_DIALECT_WAVE_TRANSFORMS_WAVEAMDCLUSTERINFO_H
#define MLIR_DIALECT_WAVE_TRANSFORMS_WAVEAMDCLUSTERINFO_H

#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Support/LLVM.h"

#include <array>
#include <optional>

namespace mlir::wave {

// LLVM keeps this ABI width local to cluster intrinsic lowering.
inline constexpr unsigned kWaveAMDClusterDimensionBits = 4;
inline constexpr unsigned kWaveAMDMaxClusterWorkgroups =
    1u << kWaveAMDClusterDimensionBits;

FailureOr<std::optional<std::array<unsigned, 3>>>
getWaveAMDFixedClusterDims(func::FuncOp func, StringRef consumer);

} // namespace mlir::wave

#endif // MLIR_DIALECT_WAVE_TRANSFORMS_WAVEAMDCLUSTERINFO_H
