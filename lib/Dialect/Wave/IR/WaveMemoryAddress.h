//===- WaveMemoryAddress.h - Private Wave address model --------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef MLIR_LIB_DIALECT_WAVE_IR_WAVEMEMORYADDRESS_H
#define MLIR_LIB_DIALECT_WAVE_IR_WAVEMEMORYADDRESS_H

#include "WaveIndexMap.h"

namespace mlir::wave {

using MemoryAddress = indexing::IndexAddress;

struct CheckedIndexExpr {
  indexing::IndexMap domain;
  sym::ExprHandle expression;
};

struct MemoryTransactionAccess {
  indexing::IndexAddress address;
  ArrayRef<Value> bases;
  sym::ExprHandle baseSelector;
  sym::ExprHandle activity;
  sym::ExprHandle block;
  sym::ExprHandle slot;
  std::optional<sym::ExprHandle> item;
  Value itemValue;
  int64_t slotCount = 0;
  int64_t elementBits = 0;
};

struct MemoryTransactionLayout {
  sym::ExprHandle group;
  sym::ExprHandle within;
  /// Logical item coordinate whose access is assigned to this transaction
  /// point. The default is the executing item. A caller that changes it must
  /// prove that (executing item, group, within) -> (accessItem, slot) is a
  /// bijection over the planned logical range and must consume the complete
  /// ownership permutation. This is independent of `pointItem`, which
  /// identifies a lane that supplies a hardware result.
  sym::ExprHandle accessItem;
  sym::ExprHandle pointItem;
  sym::ExprHandle slot;
  sym::ExprHandle originItem;
  sym::ExprHandle originSlot;
  sym::ExprHandle displacement;
  /// A target provider may supply an address formula after proving its full
  /// hardware result permutation against the canonical access map.
  sym::ExprHandle verifiedBitOffset;
  bool bitOffsetRelationVerified = false;
  int64_t width = 1;
  int64_t groupCount = 0;
};

struct MemoryTransactionProjection {
  sym::ExprHandle executionItem;
  sym::ExprHandle readFirstOrigin;
  sym::ExprHandle readFirstParameter;
};

bool supportsFullWaveOwnershipRemap(Operation *anchor, int64_t waveWidth);
bool hasOnlyCoordinateLaneInputs(const indexing::IndexMap &map,
                                 sym::ExprHandle block, sym::ExprHandle slot,
                                 std::optional<sym::ExprHandle> item);

struct MemoryTransactionRequest {
  MemoryTransactionAccess access;
  MemoryTransactionLayout layout;
  std::optional<MemoryTransactionProjection> projection;
  int64_t windowBytes = 0;
};

struct MemoryTransactionAddress {
  ArrayRef<Value> bases;
  sym::ExprHandle owner;
  sym::ExprHandle baseSelector;
  sym::ExprHandle bitOffset;
  sym::ExprHandle elementOffset;
  int64_t unitBits = 0;
};

struct MemoryTransaction {
  indexing::IndexMap map;
  SmallVector<MemoryTransactionAddress, 2> addresses;
  sym::ExprHandle activity;
  sym::ExprHandle slot;
  sym::ExprHandle group;
  sym::ExprHandle within;
  int64_t width = 0;
};

/// Prove an address tuple. Activity relations are unconditional; every other
/// relation is required only where the transaction is active.
FailureOr<bool> proveGuardedMemoryAddress(
    sym::Store &store, const indexing::IndexMap &map, sym::PredHandle active,
    ArrayRef<sym::PredHandle> guarded, ArrayRef<sym::PredHandle> activity = {},
    indexing::CheckMemo *memo = nullptr);

/// Prove an integer address can be hoisted without activity requirements.
FailureOr<bool> proveMemoryTransactionAddressHoistable(
    sym::Store &store, const MemoryTransaction &transaction,
    const MemoryTransactionAddress &address, indexing::CheckMemo &memo);

/// Materialize one access plan at its insertion scope. Unconditional address
/// expressions share only canonical DAGs with identical facts, types, and
/// ordered SSA bindings; activity-dependent materializations are never cached.
class MemoryTransactionAddressMaterializer {
public:
  MemoryTransactionAddressMaterializer(IRRewriter &rewriter, Operation *anchor,
                                       Location location, sym::Store &store,
                                       int64_t waveWidth);
  ~MemoryTransactionAddressMaterializer();

  FailureOr<Value> materializeExpr(const MemoryTransaction &transaction,
                                   sym::ExprHandle expression,
                                   sym::PredHandle active = {});
  FailureOr<Value> materializePredicate(const MemoryTransaction &transaction,
                                        sym::PredHandle predicate,
                                        sym::PredHandle active = {});
  LogicalResult prepare(const MemoryTransaction &transaction,
                        const MemoryTransactionAddress &address);
  FailureOr<Value> materialize(const MemoryTransaction &transaction,
                               const MemoryTransactionAddress &address,
                               sym::PredHandle active = {});

private:
  struct Impl;
  std::unique_ptr<Impl> impl;
};

FailureOr<std::optional<int64_t>> getMemoryPointerElementBits(Type type);

FailureOr<std::optional<MemoryAddress>>
normalizeMemoryAddress(Value ptr, WaveDialect &dialect);

FailureOr<std::optional<CheckedIndexExpr>> getMemoryAddressElementOffset(
    WaveDialect &dialect, const MemoryAddress &address, int64_t elementBits);

FailureOr<bool> proveMemoryAddressElementDelta(WaveDialect &dialect,
                                               const MemoryAddress &lhs,
                                               const MemoryAddress &rhs,
                                               int64_t expectedElements,
                                               int64_t elementBits);

/// Compose and prove one bounded transaction family. Relation coordinates and
/// an optional read-first projection are definitions in the closed IndexMap;
/// `windowBytes` checks the complete emitted address interval.
FailureOr<std::optional<MemoryTransaction>>
planMemoryTransaction(sym::Store &store, MemoryTransactionRequest request,
                      indexing::CheckMemo &memo);

} // namespace mlir::wave

#endif // MLIR_LIB_DIALECT_WAVE_IR_WAVEMEMORYADDRESS_H
