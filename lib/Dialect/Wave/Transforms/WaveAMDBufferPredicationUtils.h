//===- WaveAMDBufferPredicationUtils.h - buffer OOB masking ----*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef MLIR_LIB_DIALECT_WAVE_TRANSFORMS_WAVEAMDBUFFERPREDICATIONUTILS_H
#define MLIR_LIB_DIALECT_WAVE_TRANSFORMS_WAVEAMDBUFFERPREDICATIONUTILS_H

#include "mlir/Dialect/SCF/IR/SCF.h"
#include "mlir/Dialect/Wave/IR/Wave.h"
#include "mlir/Dialect/Wave/IR/WaveAMD.h"
#include "mlir/IR/PatternMatch.h"
#include "llvm/ADT/DenseSet.h"

namespace mlir::wave::buffer_predication {

struct BufferSentinel {
  Value base;
  Value range;
};

inline bool isBufferSimdPointer(Type type) {
  auto simdType = dyn_cast<SimdType>(type);
  if (!simdType)
    return false;
  auto ptrType = dyn_cast<PtrType>(simdType.getElementType());
  return ptrType &&
         isa<waveamd::BufferAddressSpaceAttr>(ptrType.getAddressSpace());
}

inline Value stripPtrAdds(Value value) {
  while (auto add = value.getDefiningOp<PtrAddOp>())
    value = add.getBase();
  return value;
}

inline waveamd::MakeBufferOp findMakeBuffer(Value value) {
  while (true) {
    if (auto makeBuffer = value.getDefiningOp<waveamd::MakeBufferOp>())
      return makeBuffer;
    if (auto add = value.getDefiningOp<PtrAddOp>()) {
      value = add.getBase();
      continue;
    }
    if (auto cast = value.getDefiningOp<PtrCastOp>()) {
      value = cast.getSource();
      continue;
    }
    return {};
  }
}

inline FailureOr<BufferSentinel>
findBufferSentinel(Value source, llvm::DenseSet<Value> &seen);

inline FailureOr<BufferSentinel>
findScfForIterArgBufferSentinel(BlockArgument arg,
                                llvm::DenseSet<Value> &seen) {
  auto loop = dyn_cast<scf::ForOp>(arg.getOwner()->getParentOp());
  if (!loop || arg.getArgNumber() == 0)
    return failure();
  unsigned iterIndex = arg.getArgNumber() - 1;
  if (iterIndex >= loop.getNumRegionIterArgs())
    return failure();
  return findBufferSentinel(loop.getInitArgs()[iterIndex], seen);
}

inline FailureOr<BufferSentinel>
findBufferSentinel(Value source, llvm::DenseSet<Value> &seen) {
  if (!seen.insert(source).second || !isBufferSimdPointer(source.getType()))
    return failure();
  Value base = stripPtrAdds(source);
  if (auto arg = dyn_cast<BlockArgument>(base))
    return findScfForIterArgBufferSentinel(arg, seen);
  if (!isa<PtrType>(base.getType()))
    return failure();
  waveamd::MakeBufferOp makeBuffer = findMakeBuffer(base);
  if (!makeBuffer)
    return failure();
  return BufferSentinel{base, makeBuffer.getRange()};
}

inline FailureOr<BufferSentinel> findBufferSentinel(Value source) {
  llvm::DenseSet<Value> seen;
  return findBufferSentinel(source, seen);
}

inline Value createOOBSelectedBufferPointer(IRRewriter &rewriter, Location loc,
                                            Value source, Value condition,
                                            BufferSentinel sentinel) {
  auto simdType = cast<SimdType>(source.getType());
  auto baseType = cast<PtrType>(sentinel.base.getType());
  Type byteBaseType = PtrType::get(rewriter.getContext(), rewriter.getI8Type(),
                                   baseType.getAddressSpace());
  Type byteSourceType =
      SimdType::get(rewriter.getContext(), byteBaseType, simdType.getWidth());

  Value byteBase = sentinel.base;
  if (byteBase.getType() != byteBaseType)
    byteBase = PtrCastOp::create(rewriter, loc, byteBaseType, byteBase);
  Value byteRange = sentinel.range;
  if (byteRange.getType().isInteger(32)) {
    DictionaryAttr policy = rewriter.getDictionaryAttr(rewriter.getNamedAttr(
        "extension", CastExtensionPolicyAttr::get(rewriter.getContext(),
                                                  CastExtension::Zero)));
    byteRange = CastOp::create(rewriter, loc, rewriter.getIndexType(),
                               CastKind::IntConvert, byteRange, policy);
  }
  Type offsetType = SimdType::get(rewriter.getContext(), byteRange.getType(),
                                  simdType.getWidth());
  Value offset = SplatOp::create(rewriter, loc, offsetType, byteRange);
  Value oob = PtrAddOp::create(rewriter, loc, byteSourceType, byteBase, offset);
  if (oob.getType() != source.getType())
    oob = PtrCastOp::create(rewriter, loc, source.getType(), oob);
  return SelectOp::create(rewriter, loc, source.getType(), condition, source,
                          oob)
      .getResult();
}

inline FailureOr<Value> createOOBSelectedBufferPointer(IRRewriter &rewriter,
                                                       Location loc,
                                                       Value source,
                                                       Value condition) {
  FailureOr<BufferSentinel> sentinel = findBufferSentinel(source);
  if (failed(sentinel))
    return failure();
  return createOOBSelectedBufferPointer(rewriter, loc, source, condition,
                                        *sentinel);
}

} // namespace mlir::wave::buffer_predication

#endif // MLIR_LIB_DIALECT_WAVE_TRANSFORMS_WAVEAMDBUFFERPREDICATIONUTILS_H
