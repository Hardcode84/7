//===- WavePointerAdd.h - Pointer-add construction ------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef WAVE_LIB_DIALECT_WAVE_TRANSFORMS_WAVEPOINTERADD_H
#define WAVE_LIB_DIALECT_WAVE_TRANSFORMS_WAVEPOINTERADD_H

#include "mlir/Dialect/Wave/IR/Wave.h"
#include "mlir/IR/PatternMatch.h"

namespace mlir::wave {

static inline bool isScalarOffset(Type type) {
  return type.isIndex() || isa<IntegerType>(type);
}

static inline bool needsSimdOffset(Type resultType, Type baseType,
                                   Type offsetType) {
  return isa<SimdType>(resultType) && isa<PtrType>(baseType) &&
         isScalarOffset(offsetType);
}

static inline Type getSimdOffsetType(Type resultType, Type offsetType) {
  if (!offsetType.isIndex() && !offsetType.isInteger(32))
    return {};
  auto resultSimd = cast<SimdType>(resultType);
  return SimdType::get(resultType.getContext(), offsetType,
                       resultSimd.getWidth());
}

static inline FailureOr<Value> createPtrAdd(IRRewriter &rewriter, Location loc,
                                            Type resultType, Value base,
                                            Value offset) {
  if (needsSimdOffset(resultType, base.getType(), offset.getType())) {
    Type offsetType = getSimdOffsetType(resultType, offset.getType());
    if (!offsetType)
      return failure();
    Value simdOffset = SplatOp::create(rewriter, loc, offsetType, offset);
    return PtrAddOp::create(rewriter, loc, resultType, base, simdOffset)
        .getResult();
  }
  return PtrAddOp::create(rewriter, loc, resultType, base, offset).getResult();
}

} // namespace mlir::wave

#endif // WAVE_LIB_DIALECT_WAVE_TRANSFORMS_WAVEPOINTERADD_H
