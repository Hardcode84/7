//===- WaveIndexMap.h - Private Wave index maps ---------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef MLIR_LIB_DIALECT_WAVE_IR_WAVEINDEXMAP_H
#define MLIR_LIB_DIALECT_WAVE_IR_WAVEINDEXMAP_H

#include "mlir/Dialect/Wave/IR/Wave.h"
#include "llvm/ADT/ArrayRef.h"
#include "llvm/ADT/SmallVector.h"

#include <cstdint>
#include <memory>
#include <optional>
#include <string>

namespace mlir::wave::indexing {

/// A closed expression tuple over named material or proof-only inputs. Extents
/// supply canonical range facts; every check proves transported requirements.
struct IndexMap {
  struct Input {
    sym::ExprHandle variable;
    std::optional<int64_t> extent;
    Value value;
    SymbolicOffsetBindingKind kind = SymbolicOffsetBindingKind::Lane;
    /// This input has an analyzed SSA materialization that should remain a
    /// leaf when proof facts also expose its defining expression.
    bool materializable = false;
  };

  SmallVector<Input, 4> inputs;
  SmallVector<sym::PredHandle, 8> facts;
  SmallVector<sym::PredHandle, 8> requirements;
  SmallVector<sym::ExprSubstitution, 4> definitions;
  SmallVector<sym::ExprHandle, 4> exprs;
};

/// One concrete allocation identity and its symbolic owner/bit address.
struct IndexAddress {
  IndexMap map;
  Value base;
  sym::ExprHandle owner;
  sym::ExprHandle bitOffset;
  sym::PredHandle active;
};

/// Exact proof-result memo scoped by a caller to one layout-planning attempt.
/// The implementation keys only the closed ixsimpl fact domain and predicate;
/// it carries no layout semantics.
class CheckMemo {
public:
  CheckMemo();
  ~CheckMemo();

  CheckMemo(const CheckMemo &) = delete;
  CheckMemo &operator=(const CheckMemo &) = delete;

private:
  struct Impl;
  std::unique_ptr<Impl> impl;

  friend FailureOr<sym::CheckResult> check(sym::Store &, const IndexMap &,
                                           ArrayRef<sym::PredHandle>,
                                           CheckMemo &, std::string *);
};

/// Pull `source` back to `domain` through an exact input substitution.
FailureOr<IndexMap> pullback(sym::Store &store, const IndexMap &source,
                             const IndexMap &domain,
                             ArrayRef<sym::ExprSubstitution> substitutions,
                             StringRef scope,
                             std::string *diagnostic = nullptr);

/// Replace proof coordinates with their composed expressions.
FailureOr<sym::ExprHandle> materialize(sym::Store &store, const IndexMap &map,
                                       sym::ExprHandle expression,
                                       std::string *diagnostic = nullptr);

/// Simplify a specialized expression tuple under the complete map domain.
FailureOr<SmallVector<sym::ExprHandle>>
simplify(sym::Store &store, const IndexMap &map,
         ArrayRef<sym::ExprHandle> expressions,
         ArrayRef<sym::ExprSubstitution> definitions,
         std::string *diagnostic = nullptr);

/// Prove exact division in the complete map domain. Additional assumptions
/// restrict the query but do not discharge map requirements.
FailureOr<sym::ExactDivideResult>
tryExactDivide(sym::Store &store, const IndexMap &map,
               sym::ExprHandle expression, int64_t divisor,
               ArrayRef<sym::PredHandle> assumptions = {},
               std::string *diagnostic = nullptr);

/// The sole proof boundary. One analysis checks every map requirement and each
/// requested goal atomically.
FailureOr<sym::CheckResult> check(sym::Store &store, const IndexMap &map,
                                  ArrayRef<sym::PredHandle> goals,
                                  std::string *diagnostic = nullptr);

/// The same proof boundary with an exact result memo owned by the enclosing
/// layout-planning attempt.
FailureOr<sym::CheckResult> check(sym::Store &store, const IndexMap &map,
                                  ArrayRef<sym::PredHandle> goals,
                                  CheckMemo &memo,
                                  std::string *diagnostic = nullptr);

} // namespace mlir::wave::indexing

#endif // MLIR_LIB_DIALECT_WAVE_IR_WAVEINDEXMAP_H
