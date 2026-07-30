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
// Raw ixsimpl boundary: header exposes handles; implementation owns ixs_*
// calls.
//
//===----------------------------------------------------------------------===//

#ifndef MLIR_DIALECT_WAVE_IR_WAVESYMBOLS_H
#define MLIR_DIALECT_WAVE_IR_WAVESYMBOLS_H

#include "ixsimpl.h"
#include "mlir/Support/LogicalResult.h"
#include "llvm/ADT/ArrayRef.h"
#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/DenseMapInfo.h"
#include "llvm/ADT/Hashing.h"
#include "llvm/ADT/STLFunctionalExtras.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/ADT/StringRef.h"
#include "llvm/Support/Mutex.h"

#include <cstdint>
#include <memory>
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

enum class ExprBinaryOp { Add, Sub, Mul, Div, Mod, Xor, Max, Min };
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

struct PiecewiseCase {
  ExprHandle value;
  PredHandle condition;
};

struct ExprSubstitution {
  ExprHandle target;
  ExprHandle replacement;
};

bool isExpr(ExprHandle value);
bool isPred(PredHandle value);
bool isIntegerValued(ExprHandle value);

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
  uint32_t getPiecewiseCaseCount() const;
  PiecewiseCase getPiecewiseCase(uint32_t index) const;

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
mlir::FailureOr<ExprHandle> deserializeExpr(Store &store,
                                            llvm::ArrayRef<uint8_t> bytes,
                                            std::string *diagnostic = nullptr);
mlir::FailureOr<PredHandle> deserializePred(Store &store,
                                            llvm::ArrayRef<uint8_t> bytes,
                                            std::string *diagnostic = nullptr);
mlir::FailureOr<ExprHandle>
importExprFromNodePtr(Store &store, uintptr_t nodePtr,
                      std::string *diagnostic = nullptr);
mlir::FailureOr<PredHandle>
importPredFromNodePtr(Store &store, uintptr_t nodePtr,
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
mlir::FailureOr<ExprHandle>
composeExprPiecewise(Store &store, llvm::ArrayRef<PiecewiseCase> cases,
                     std::string *diagnostic = nullptr);
mlir::FailureOr<PredHandle> composePredTrue(Store &store,
                                            std::string *diagnostic = nullptr);
mlir::FailureOr<PredHandle> composePredFalse(Store &store,
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
mlir::FailureOr<PredHandle> composePredNot(Store &store, PredHandle value,
                                           std::string *diagnostic = nullptr);
/// Simplify under no assumptions.
mlir::FailureOr<ExprHandle> simplifyExpr(Store &store, ExprHandle value,
                                         std::string *diagnostic = nullptr);
mlir::FailureOr<PredHandle> simplifyPred(Store &store, PredHandle value,
                                         std::string *diagnostic = nullptr);
/// Simultaneous substitution; replacements are not rewritten.
mlir::FailureOr<ExprHandle>
substituteExpr(Store &store, ExprHandle value,
               llvm::ArrayRef<ExprSubstitution> substitutions,
               std::string *diagnostic = nullptr);
mlir::FailureOr<PredHandle>
substitutePred(Store &store, PredHandle value,
               llvm::ArrayRef<ExprSubstitution> substitutions,
               std::string *diagnostic = nullptr);

/// Simplify `value` under `assumptions`.
mlir::FailureOr<ExprHandle> simplifyExpr(Store &store, ExprHandle value,
                                         llvm::ArrayRef<PredHandle> assumptions,
                                         std::string *diagnostic = nullptr);
mlir::FailureOr<ExprHandle> expandExpr(Store &store, ExprHandle value,
                                       std::string *diagnostic = nullptr);

/// Three-valued result of a predicate entailment query.
enum class CheckResult { True, False, Unknown };

/// Proven power-of-two fact for an expression under assumptions.
enum class Pow2Fact { Unknown, OrZero, Positive };

struct RationalEndpoint {
  int64_t numerator = 0;
  int64_t denominator = 1;
};

std::optional<int64_t> floorEndpoint(RationalEndpoint value);
std::optional<int64_t> ceilEndpoint(RationalEndpoint value);
int compareEndpointToInteger(RationalEndpoint value, int64_t integer);

struct InferredRange {
  std::optional<RationalEndpoint> lower;
  std::optional<RationalEndpoint> upper;
};

struct KnownBits {
  uint64_t knownZero = 0;
  uint64_t knownOne = 0;
  Pow2Fact pow2 = Pow2Fact::Unknown;
};

struct Congruence {
  int64_t modulus = 0;
  int64_t residue = 0;
};

enum class ExactDivideStatus { Proven, NotExact, Unknown, Error };

struct ExactDivideResult {
  ExactDivideStatus status = ExactDivideStatus::Error;
  ExprHandle quotient;
};

struct AffineDecomposition {
  ExprHandle coefficient;
  ExprHandle residual;
};

struct SplitAdditiveConstant {
  ExprHandle residual;
  int64_t constant = 0;
};

/// Scoped fact set. Mutation failure poisons fact queries, not builders.
/// Holds Store lock; use Analysis builders while live.
class Analysis {
public:
  static mlir::FailureOr<std::unique_ptr<Analysis>>
  create(Store &store, llvm::ArrayRef<PredHandle> assumptions = {},
         std::string *diagnostic = nullptr);

  /// Imports one exact domain without inter-predicate closure.
  static mlir::FailureOr<std::unique_ptr<Analysis>>
  createDirect(Store &store, llvm::ArrayRef<PredHandle> assumptions = {},
               std::string *diagnostic = nullptr);

  Analysis(const Analysis &) = delete;
  Analysis &operator=(const Analysis &) = delete;

  mlir::LogicalResult assume(PredHandle pred,
                             std::string *diagnostic = nullptr);
  mlir::LogicalResult assume(llvm::ArrayRef<PredHandle> predicates,
                             std::string *diagnostic = nullptr);
  mlir::LogicalResult assumeRange(ExprHandle expr, InferredRange range,
                                  std::string *diagnostic = nullptr);
  mlir::LogicalResult deriveAffine(ExprHandle base, int64_t scale,
                                   int64_t offset, ExprHandle derived,
                                   std::string *diagnostic = nullptr);
  mlir::LogicalResult
  substituteFacts(llvm::ArrayRef<ExprSubstitution> substitutions,
                  std::string *diagnostic = nullptr);

  mlir::FailureOr<ExprHandle> compose(ExprHandle lhs, ExprBinaryOp op,
                                      ExprHandle rhs,
                                      std::string *diagnostic = nullptr);
  mlir::FailureOr<ExprHandle> composeCeil(ExprHandle value,
                                          std::string *diagnostic = nullptr);
  mlir::FailureOr<ExprHandle> composeFloor(ExprHandle value,
                                           std::string *diagnostic = nullptr);
  mlir::FailureOr<ExprHandle> composeNeg(ExprHandle value,
                                         std::string *diagnostic = nullptr);
  mlir::FailureOr<ExprHandle> composeSymbol(llvm::StringRef name,
                                            std::string *diagnostic = nullptr);
  mlir::FailureOr<ExprHandle> composeInteger(int64_t value,
                                             std::string *diagnostic = nullptr);
  mlir::FailureOr<ExprHandle>
  composePiecewise(llvm::ArrayRef<PiecewiseCase> cases,
                   std::string *diagnostic = nullptr);
  mlir::FailureOr<PredHandle> composeTrue(std::string *diagnostic = nullptr);
  mlir::FailureOr<PredHandle> composeFalse(std::string *diagnostic = nullptr);
  mlir::FailureOr<PredHandle> compare(ExprHandle lhs, PredCmpOp op,
                                      ExprHandle rhs,
                                      std::string *diagnostic = nullptr);
  mlir::FailureOr<PredHandle> composeAnd(PredHandle lhs, PredHandle rhs,
                                         std::string *diagnostic = nullptr);
  mlir::FailureOr<PredHandle> composeOr(PredHandle lhs, PredHandle rhs,
                                        std::string *diagnostic = nullptr);
  mlir::FailureOr<PredHandle> composeNot(PredHandle value,
                                         std::string *diagnostic = nullptr);

  mlir::FailureOr<ExprHandle>
  substitute(ExprHandle value, llvm::ArrayRef<ExprSubstitution> substitutions,
             std::string *diagnostic = nullptr);
  mlir::FailureOr<PredHandle>
  substitute(PredHandle value, llvm::ArrayRef<ExprSubstitution> substitutions,
             std::string *diagnostic = nullptr);
  mlir::FailureOr<ExprHandle> simplify(ExprHandle value,
                                       std::string *diagnostic = nullptr);
  mlir::FailureOr<PredHandle> simplify(PredHandle value,
                                       std::string *diagnostic = nullptr);
  mlir::LogicalResult simplify(llvm::MutableArrayRef<ExprHandle> values,
                               std::string *diagnostic = nullptr);
  mlir::FailureOr<ExprHandle> expand(ExprHandle value,
                                     std::string *diagnostic = nullptr);
  mlir::FailureOr<PredHandle> expand(PredHandle value,
                                     std::string *diagnostic = nullptr);

  CheckResult check(PredHandle pred);
  CheckResult equivalent(ExprHandle lhs, ExprHandle rhs);
  CheckResult equivalent(PredHandle lhs, PredHandle rhs);
  /// Return equivalent normalized forms for an ordered comparison.
  llvm::SmallVector<PredHandle, 4> orderedComparisonForms(PredHandle predicate);
  CheckResult defined(ExprHandle expr);
  CheckResult defined(PredHandle pred);
  CheckResult integerValued(ExprHandle expr);
  CheckResult divisible(ExprHandle expr, int64_t modulus);
  CheckResult congruent(ExprHandle expr, int64_t modulus, int64_t residue);
  ExactDivideResult tryExactDivide(ExprHandle expr, int64_t divisor);
  Pow2Fact getPow2Fact(ExprHandle expr);
  std::optional<KnownBits> getKnownBits(ExprHandle expr);
  std::optional<Congruence> getSymbolCongruence(ExprHandle symbol);
  std::optional<InferredRange> range(ExprHandle expr);
  std::optional<int64_t> constantDifference(ExprHandle lhs, ExprHandle rhs);
  std::optional<AffineDecomposition> affineDecompose(ExprHandle expr,
                                                     ExprHandle symbol);
  std::optional<ExprHandle> finiteDifference(ExprHandle expr, ExprHandle symbol,
                                             ExprHandle step);
  std::optional<SplitAdditiveConstant> splitAdditiveConstant(ExprHandle expr);

private:
  explicit Analysis(Store &store);

  void invalidateQueryCaches();
  bool prepareQuery();
  void poison(std::string *diagnostic, llvm::StringRef fallback);

  llvm::DenseMap<std::pair<const ixs_node *, int64_t>, ExactDivideResult>
      exactDivideCache;
  llvm::DenseMap<const ixs_node *, const ixs_node *> simplifyExprCache;
  llvm::DenseMap<const ixs_node *, CheckResult> definedCache;
  Session session;
  ixs_facts *facts = nullptr;
  bool usable = false;
};

/// Check a predicate tree under `assumptions`.
CheckResult checkPredicate(Store &store, PredHandle predicate,
                           llvm::ArrayRef<PredHandle> assumptions);
/// Prove evaluation cannot produce a domain error under `assumptions`.
bool provablyDefined(Store &store, ExprHandle expr,
                     llvm::ArrayRef<PredHandle> assumptions);
bool provablyDefined(Store &store, PredHandle pred,
                     llvm::ArrayRef<PredHandle> assumptions);
Pow2Fact getPow2Fact(Store &store, ExprHandle expr,
                     llvm::ArrayRef<PredHandle> assumptions);

/// Build the assumption `name in [lo, hi]`.
mlir::FailureOr<PredHandle> rangeAssumption(Store &store, llvm::StringRef name,
                                            int64_t lo, int64_t hi,
                                            std::string *diagnostic = nullptr);

/// True iff `expr` provably stays in `[lo, hi]` under `assumptions`.
bool provablyInRange(Analysis &analysis, ExprHandle expr, int64_t lo,
                     int64_t hi);
bool provablyInRange(Store &store, ExprHandle expr,
                     llvm::ArrayRef<PredHandle> assumptions, int64_t lo,
                     int64_t hi);
bool provablyFitsU32(Store &store, ExprHandle expr,
                     llvm::ArrayRef<PredHandle> assumptions);
bool positiveAddendsFitU32(Store &store, ExprHandle expr,
                           llvm::ArrayRef<PredHandle> assumptions);
std::optional<InferredRange> inferRange(Store &store, ExprHandle expr,
                                        llvm::ArrayRef<PredHandle> assumptions);
std::optional<int64_t>
inferNonNegativeUpperBound(Store &store, ExprHandle expr,
                           llvm::ArrayRef<PredHandle> assumptions,
                           int64_t maxUpper);

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

namespace llvm {

template <> struct DenseMapInfo<mlir::wave::sym::ExprHandle> {
  static unsigned getHashValue(mlir::wave::sym::ExprHandle value) {
    return DenseMapInfo<const ixs_node *>::getHashValue(value.raw());
  }

  static bool isEqual(mlir::wave::sym::ExprHandle lhs,
                      mlir::wave::sym::ExprHandle rhs) {
    return lhs == rhs;
  }
};

} // namespace llvm

#endif // MLIR_DIALECT_WAVE_IR_WAVESYMBOLS_H
