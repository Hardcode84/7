//===- WaveMemoryTransactionProvider.h - target memory plans ----*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef MLIR_LIB_DIALECT_WAVE_TRANSFORMS_WAVEMEMORYTRANSACTIONPROVIDER_H
#define MLIR_LIB_DIALECT_WAVE_TRANSFORMS_WAVEMEMORYTRANSACTIONPROVIDER_H

#include "../IR/WaveIndexMap.h"
#include "mlir/Dialect/Wave/IR/Wave.h"
#include "mlir/IR/PatternMatch.h"
#include "llvm/ADT/ArrayRef.h"
#include "llvm/ADT/SmallVector.h"

#include <cstdint>
#include <memory>
#include <optional>
#include <vector>

namespace mlir::wave::memory_lowering {

struct GatherTransactionResult {
  Value value;
  Value token;
};

class GatherTransactionEmitter {
public:
  virtual ~GatherTransactionEmitter() = default;

  // The checked target formula is trusted at emission.
  virtual GatherTransactionResult emit(IRRewriter &rewriter, Location loc,
                                       SimdType resultType, Type tokenType,
                                       Value address,
                                       Value dependency) const = 0;
};

struct GatherTransaction {
  struct VerifiedAddress {
    unsigned firstSlot;
    sym::ExprHandle bitOffset;
  };

  unsigned width;
  sym::ExprHandle sourceItem;
  sym::ExprHandle intraBits;
  sym::ExprHandle originItem;
  sym::ExprHandle originSlot;
  std::vector<VerifiedAddress> verifiedAddresses;
  std::shared_ptr<const GatherTransactionEmitter> emitter;
};

struct GatherTransactionRequest {
  ValueRange bases;
  Operation *op = nullptr;
  SimdType resultType;
  Attribute cache;
  sym::ExprHandle item;
  sym::ExprHandle slot;
  std::optional<int64_t> itemCount;
  const indexing::IndexAddress *address = nullptr;
};

using GatherTransactions = SmallVector<GatherTransaction, 3>;

struct CopyTransactionRequest {
  Value sourceBase;
  Value destinationBase;
  Operation *op = nullptr;
  SimdType packetType;
  bool zeroFillInactive = false;
};

class CopyTransactionEmitter;

struct CopyTransaction {
  int64_t bytes = 0;
  int64_t windowBytes = 0;
  std::shared_ptr<const CopyTransactionEmitter> emitter;
};

class CopyTransactionEmitter {
public:
  virtual ~CopyTransactionEmitter() = default;

  // The provider selected `bytes` and zero-fill eligibility before emission.
  virtual Value emit(IRRewriter &rewriter, Location loc, Type tokenType,
                     Value source, Value destination, Value dependency,
                     int64_t bytes, bool zeroFillInactive) const = 0;
};

GatherTransactions
getGatherTransactions(const GatherTransactionRequest &request);

// AMD currently has exactly two direct-to-LDS widths. Keep both candidates so
// mapping legality, which is only known by the planner, can select the widest
// legal transaction.
SmallVector<CopyTransaction>
getCopyTransactions(const CopyTransactionRequest &request);

} // namespace mlir::wave::memory_lowering

#endif // MLIR_LIB_DIALECT_WAVE_TRANSFORMS_WAVEMEMORYTRANSACTIONPROVIDER_H
