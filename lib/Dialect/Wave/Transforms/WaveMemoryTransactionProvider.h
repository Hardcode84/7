//===- WaveMemoryTransactionProvider.h - target memory plans ----*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef MLIR_LIB_DIALECT_WAVE_TRANSFORMS_WAVEMEMORYTRANSACTIONPROVIDER_H
#define MLIR_LIB_DIALECT_WAVE_TRANSFORMS_WAVEMEMORYTRANSACTIONPROVIDER_H

#include "mlir/Dialect/Wave/IR/Wave.h"
#include "mlir/Dialect/Wave/IR/WaveSymbols.h"
#include "mlir/IR/PatternMatch.h"
#include "llvm/ADT/ArrayRef.h"
#include "llvm/ADT/SmallVector.h"

#include <cstdint>
#include <memory>

namespace mlir::wave::memory_lowering {

struct MemoryTransactionBinding {
  StringRef name;
  Value value;
};

struct MemoryTransactionPoint {
  ArrayRef<MemoryTransactionBinding> bindings;
  ArrayRef<sym::PredHandle> assumptions;
  sym::ExprHandle base;
  sym::ExprHandle targetBlock;
  sym::ExprHandle byteOffset;
  sym::ExprHandle materializationByteOffset;
  int64_t baseIndex = 0;
};

struct GatherTransactionResult {
  Value value;
  Value token;
};

class GatherTransactionEmitter {
public:
  virtual ~GatherTransactionEmitter() = default;

  virtual FailureOr<GatherTransactionResult>
  emit(IRRewriter &rewriter, Location loc, SimdType resultType, Type tokenType,
       Value address, Value dependency) const = 0;
};

struct GatherTransactionCandidate {
  SmallVector<unsigned> slots;
  std::unique_ptr<GatherTransactionEmitter> emitter;
  sym::ExprHandle byteOffset;
  unsigned addressPoint = 0;
  int64_t baseIndex = 0;
};

struct GatherTransactionRequest {
  ValueRange bases;
  ArrayRef<MemoryTransactionPoint> points;
  Operation *op = nullptr;
  sym::Store *store = nullptr;
  SimdType resultType;
  Value dependency;
  Attribute cache;
  Type tokenType;
};

class GatherTransactionProvider {
public:
  virtual ~GatherTransactionProvider() = default;

  virtual void
  enumerate(const GatherTransactionRequest &request,
            SmallVectorImpl<GatherTransactionCandidate> &candidates) const = 0;
};

void populateGatherTransactionProviders(
    SmallVectorImpl<std::unique_ptr<GatherTransactionProvider>> &providers);

} // namespace mlir::wave::memory_lowering

#endif // MLIR_LIB_DIALECT_WAVE_TRANSFORMS_WAVEMEMORYTRANSACTIONPROVIDER_H
