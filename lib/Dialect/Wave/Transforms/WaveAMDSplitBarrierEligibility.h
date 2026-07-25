//===- WaveAMDSplitBarrierEligibility.h - Barrier rules --------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef MLIR_LIB_DIALECT_WAVE_TRANSFORMS_WAVEAMDSPLITBARRIERELIGIBILITY_H
#define MLIR_LIB_DIALECT_WAVE_TRANSFORMS_WAVEAMDSPLITBARRIERELIGIBILITY_H

#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "llvm/ADT/STLExtras.h"

#include <cstdint>
#include <limits>
#include <optional>

namespace mlir::wave::split_barrier_detail {

static inline bool isPowerOfTwo(unsigned value) {
  return value != 0 && (value & (value - 1)) == 0;
}

static inline std::optional<int64_t> getKnownWorkgroupDim(func::FuncOp func,
                                                          unsigned axis) {
  if (axis > 2)
    return std::nullopt;
  for (StringRef name : {"wave.workgroup_size", "gpu.known_block_size"}) {
    DenseI32ArrayAttr attr = func->getAttrOfType<DenseI32ArrayAttr>(name);
    if (!attr)
      continue;
    int32_t dim = axis < attr.size() ? attr.asArrayRef()[axis] : 1;
    if (dim > 0)
      return dim;
  }
  return std::nullopt;
}

static inline std::optional<uint64_t> checkedMul(uint64_t lhs, uint64_t rhs) {
  if (lhs > std::numeric_limits<uint64_t>::max() / rhs)
    return std::nullopt;
  return lhs * rhs;
}

static inline std::optional<uint64_t> getFlatWorkgroupSize(func::FuncOp func) {
  uint64_t flat = 1;
  for (unsigned axis : llvm::seq<unsigned>(0, 3)) {
    std::optional<int64_t> dim = getKnownWorkgroupDim(func, axis);
    if (!dim)
      return std::nullopt;
    std::optional<uint64_t> next =
        checkedMul(flat, static_cast<uint64_t>(*dim));
    if (!next)
      return std::nullopt;
    flat = *next;
  }
  return flat;
}

static inline bool hasConsistentWavesPerWorkgroup(func::FuncOp func,
                                                  unsigned waves) {
  IntegerAttr attr =
      func->getAttrOfType<IntegerAttr>("wave.waves_per_workgroup");
  return !attr || attr.getInt() == waves;
}

static inline std::optional<unsigned> getExpectedWaves(func::FuncOp func,
                                                       unsigned wavefrontSize) {
  std::optional<uint64_t> flat = getFlatWorkgroupSize(func);
  if (!flat || wavefrontSize == 0)
    return std::nullopt;

  uint64_t waves64 = ((*flat - 1) / wavefrontSize) + 1;
  if (waves64 > std::numeric_limits<unsigned>::max())
    return std::nullopt;
  unsigned waves = static_cast<unsigned>(waves64);
  if (!isPowerOfTwo(waves))
    return std::nullopt;
  if (!hasConsistentWavesPerWorkgroup(func, waves))
    return std::nullopt;
  return waves;
}

} // namespace mlir::wave::split_barrier_detail

#endif // MLIR_LIB_DIALECT_WAVE_TRANSFORMS_WAVEAMDSPLITBARRIERELIGIBILITY_H
