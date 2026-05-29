//===- WaveSymbols.h - Wave symbolic offset algebra -------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// Pointer-typed handles around hash-consed `ixsimpl` nodes for the Wave
// dialect's symbolic offset algebra. Storage is opaque: handles round-
// trip via the dialect-owned `Store` and only touch text at the MLIR
// parser/printer boundary.
//
//===----------------------------------------------------------------------===//

#ifndef MLIR_DIALECT_WAVE_IR_WAVESYMBOLS_H
#define MLIR_DIALECT_WAVE_IR_WAVESYMBOLS_H

#include "ixsimpl.h"
#include "mlir/Support/LogicalResult.h"
#include "llvm/ADT/ArrayRef.h"
#include "llvm/ADT/Hashing.h"
#include "llvm/ADT/STLFunctionalExtras.h"
#include "llvm/ADT/StringRef.h"
#include "llvm/Support/Mutex.h"

#include <cstdint>
#include <optional>
#include <string>

namespace mlir {
class AsmParser;
class AsmPrinter;
} // namespace mlir

namespace mlir::wave::sym {

/// Hash-consed symbolic expression handle scoped to one Store/ixs_ctx.
struct ExprHandle {
  ExprHandle() = default;
  explicit ExprHandle(const ixs_node *node) : node(node) {}

  const ixs_node *raw() const { return node; }
  explicit operator bool() const { return node != nullptr; }

  friend bool operator==(ExprHandle lhs, ExprHandle rhs) {
    return lhs.node == rhs.node;
  }
  friend llvm::hash_code hash_value(ExprHandle value) {
    return llvm::hash_value(value.node);
  }

private:
  const ixs_node *node = nullptr;
};

/// Hash-consed symbolic predicate handle scoped to one Store/ixs_ctx.
struct PredHandle {
  PredHandle() = default;
  explicit PredHandle(const ixs_node *node) : node(node) {}

  const ixs_node *raw() const { return node; }
  explicit operator bool() const { return node != nullptr; }

  friend bool operator==(PredHandle lhs, PredHandle rhs) {
    return lhs.node == rhs.node;
  }
  friend llvm::hash_code hash_value(PredHandle value) {
    return llvm::hash_value(value.node);
  }

private:
  const ixs_node *node = nullptr;
};

enum class ExprBinaryOp { Add, Sub, Mul, Div, Mod };
enum class PredCmpOp { Lt, Le, Gt, Ge, Eq, Ne };

enum class ExprKind {
  Invalid,
  Integer,
  Rational,
  Symbol,
  Add,
  Mul,
  Floor,
  Ceil,
  Mod,
  Piecewise,
  Max,
  Min,
  Xor,
  Error,
  ParseError,
};

enum class PredKind {
  Invalid,
  Cmp,
  And,
  Or,
  Not,
  True,
  False,
  Error,
  ParseError,
};

struct RationalLiteral {
  int64_t numerator = 0;
  int64_t denominator = 1;
};

struct AddTerm {
  ExprHandle coefficient;
  ExprHandle term;
};

struct MulFactor {
  ExprHandle base;
  int32_t exponent = 0;
};

bool isExpr(ExprHandle value);
bool isPred(PredHandle value);

// Wrong-kind accessors return empty handles / zero counts.
class ExprView {
public:
  explicit ExprView(ExprHandle value) : value(value) {}

  ExprHandle getHandle() const { return value; }
  bool isValid() const;
  ExprKind getKind() const;
  std::optional<int64_t> getInt() const;
  std::optional<RationalLiteral> getRational() const;
  llvm::StringRef getSymbolName() const;
  ExprHandle getAddConstant() const;
  uint32_t getAddTermCount() const;
  AddTerm getAddTerm(uint32_t index) const;
  ExprHandle getMulCoefficient() const;
  uint32_t getMulFactorCount() const;
  MulFactor getMulFactor(uint32_t index) const;
  ExprHandle getUnaryArg() const;
  ExprHandle getBinaryLhs() const;
  ExprHandle getBinaryRhs() const;

private:
  ExprHandle value;
};

class PredView {
public:
  explicit PredView(PredHandle value) : value(value) {}

  PredHandle getHandle() const { return value; }
  bool isValid() const;
  PredKind getKind() const;
  std::optional<PredCmpOp> getCmpOp() const;
  ExprHandle getCmpLhs() const;
  ExprHandle getCmpRhs() const;
  PredHandle getUnaryArg() const;
  uint32_t getLogicArgCount() const;
  PredHandle getLogicArg(uint32_t index) const;

private:
  PredHandle value;
};

/// Long-lived symbolic store owned by one `WaveDialect` / `MLIRContext`.
class Store {
public:
  Store();
  ~Store();

  Store(const Store &) = delete;
  Store &operator=(const Store &) = delete;

  ixs_ctx *raw() const { return ctx; }
  /// Render `node` as text.
  std::string render(const ixs_node *node) const;
  std::string render(ExprHandle value) const;
  std::string render(PredHandle value) const;

private:
  ixs_ctx *ctx = nullptr;
  mutable llvm::sys::SmartMutex<true> mutex;

  friend class Session;
};

class Session {
public:
  explicit Session(Store &store);
  ~Session();

  Session(const Session &) = delete;
  Session &operator=(const Session &) = delete;

  ixs_session *raw() { return &session; }

private:
  Store &store;
  llvm::sys::SmartScopedLock<true> lock;
  ixs_session session;
};

/// Parse symbolic text into the destination store.
mlir::FailureOr<ExprHandle> parseExpr(Store &store, llvm::StringRef text,
                                      std::string *diagnostic = nullptr);
mlir::FailureOr<PredHandle> parsePred(Store &store, llvm::StringRef text,
                                      std::string *diagnostic = nullptr);

mlir::FailureOr<ExprHandle> importExpr(Store &store, const ixs_node *foreign,
                                       std::string *diagnostic = nullptr);
mlir::FailureOr<PredHandle> importPred(Store &store, const ixs_node *foreign,
                                       std::string *diagnostic = nullptr);

mlir::FailureOr<ExprHandle>
composeExprBinary(Store &store, ExprHandle lhs, ExprBinaryOp op, ExprHandle rhs,
                  std::string *diagnostic = nullptr);
mlir::FailureOr<ExprHandle> composeExprCeil(Store &store, ExprHandle value,
                                            std::string *diagnostic = nullptr);
/// Floor of `value`. Use to turn an exact-rational `Div` into Python
/// `//` (floored integer division).
mlir::FailureOr<ExprHandle> composeExprFloor(Store &store, ExprHandle value,
                                             std::string *diagnostic = nullptr);
mlir::FailureOr<ExprHandle> composeExprNeg(Store &store, ExprHandle value,
                                           std::string *diagnostic = nullptr);

/// Symbol / integer leaves.
mlir::FailureOr<ExprHandle> composeExprSym(Store &store, llvm::StringRef name,
                                           std::string *diagnostic = nullptr);
mlir::FailureOr<ExprHandle> composeExprInt(Store &store, int64_t value,
                                           std::string *diagnostic = nullptr);
mlir::FailureOr<PredHandle> composePredCmp(Store &store, ExprHandle lhs,
                                           PredCmpOp op, ExprHandle rhs,
                                           std::string *diagnostic = nullptr);
/// AND / OR of two predicates.
mlir::FailureOr<PredHandle> composePredAnd(Store &store, PredHandle lhs,
                                           PredHandle rhs,
                                           std::string *diagnostic = nullptr);
mlir::FailureOr<PredHandle> composePredOr(Store &store, PredHandle lhs,
                                          PredHandle rhs,
                                          std::string *diagnostic = nullptr);

/// Simplify under no assumptions.
mlir::FailureOr<ExprHandle> simplifyExpr(Store &store, ExprHandle value,
                                         std::string *diagnostic = nullptr);
mlir::FailureOr<PredHandle> simplifyPred(Store &store, PredHandle value,
                                         std::string *diagnostic = nullptr);

/// Simplify `value` under `assumptions`. AND-of-CMP assumption handles
/// flatten to their CMP leaves before reaching the simplifier.
mlir::FailureOr<ExprHandle> simplifyExpr(Store &store, ExprHandle value,
                                         llvm::ArrayRef<PredHandle> assumptions,
                                         std::string *diagnostic = nullptr);

/// Three-valued result of a predicate entailment query.
enum class CheckResult { True, False, Unknown };

/// Decide whether `predicate` is provably true / false under
/// `assumptions`. Returns `Unknown` when inconclusive.
CheckResult checkPredicate(Store &store, PredHandle predicate,
                           llvm::ArrayRef<PredHandle> assumptions);

/// Build the assumption `name in [lo, hi]`.
mlir::FailureOr<PredHandle> rangeAssumption(Store &store, llvm::StringRef name,
                                            int64_t lo, int64_t hi,
                                            std::string *diagnostic = nullptr);

/// True iff `expr` provably stays in `[lo, hi]` under `assumptions`.
bool provablyInRange(Store &store, ExprHandle expr,
                     llvm::ArrayRef<PredHandle> assumptions, int64_t lo,
                     int64_t hi);

/// Integer payload of a structurally-integral expression. `nullopt`
/// for non-integral nodes.
std::optional<int64_t> getIntegerLiteralValue(ExprHandle value);

/// Walk every symbolic leaf name in `value`.
void walkSymbolNames(ExprHandle value,
                     llvm::function_ref<void(llvm::StringRef)> callback);
void walkSymbolNames(PredHandle value,
                     llvm::function_ref<void(llvm::StringRef)> callback);

mlir::FailureOr<ExprHandle> parseExprHandle(AsmParser &parser);
mlir::FailureOr<PredHandle> parsePredHandle(AsmParser &parser);

/// Print straight from the immutable node -- does not touch the store.
void printExprHandle(AsmPrinter &printer, ExprHandle value);
void printPredHandle(AsmPrinter &printer, PredHandle value);

} // namespace mlir::wave::sym

#endif // MLIR_DIALECT_WAVE_IR_WAVESYMBOLS_H
