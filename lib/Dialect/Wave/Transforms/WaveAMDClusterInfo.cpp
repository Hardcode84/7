//===- WaveAMDClusterInfo.cpp - AMDGPU cluster metadata -------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/Wave/Transforms/WaveAMDClusterInfo.h"

#include "mlir/IR/BuiltinAttributes.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/Support/MathExtras.h"

using namespace mlir;

static FailureOr<std::array<unsigned, 3>> parseClusterDims(func::FuncOp func,
                                                           Attribute raw,
                                                           StringRef name,
                                                           StringRef consumer) {
  DenseI32ArrayAttr attr = dyn_cast<DenseI32ArrayAttr>(raw);
  if (!attr)
    return func.emitError(consumer)
           << " requires " << name << " to be a dense i32 array";
  if (attr.size() != 3)
    return func.emitError(consumer)
           << " requires " << name << " with exactly three dimensions";

  std::array<unsigned, 3> dims;
  uint64_t flatSize = 1;
  for (auto [axis, dim] : llvm::enumerate(attr.asArrayRef())) {
    if (dim <= 0)
      return func.emitError(consumer) << " requires positive " << name
                                      << "; axis " << axis << " is " << dim;
    unsigned unsignedDim = static_cast<unsigned>(dim);
    if (unsignedDim >
        llvm::maskTrailingOnes<unsigned>(wave::kWaveAMDClusterDimensionBits))
      return func.emitError(consumer)
             << " requires " << name << " axes to fit "
             << wave::kWaveAMDClusterDimensionBits << " bits; axis " << axis
             << " is " << dim;
    dims[axis] = unsignedDim;
    flatSize *= unsignedDim;
  }
  if (flatSize > wave::kWaveAMDMaxClusterWorkgroups)
    return func.emitError(consumer)
           << " requires at most " << wave::kWaveAMDMaxClusterWorkgroups
           << " workgroups per cluster; product is " << flatSize;
  return dims;
}

FailureOr<std::optional<std::array<unsigned, 3>>>
mlir::wave::getWaveAMDFixedClusterDims(func::FuncOp func, StringRef consumer) {
  std::optional<std::array<unsigned, 3>> result;
  for (StringRef name : {"wave.cluster_dims", "gpu.known_cluster_size"}) {
    Attribute raw = func->getAttr(name);
    if (!raw)
      continue;
    FailureOr<std::array<unsigned, 3>> dims =
        parseClusterDims(func, raw, name, consumer);
    if (failed(dims))
      return failure();
    if (result && *result != *dims)
      return func.emitError(consumer)
             << " requires wave.cluster_dims and gpu.known_cluster_size to "
                "match";
    result = *dims;
  }
  return result;
}
