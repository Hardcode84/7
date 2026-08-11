//===- WaveSymbols.cpp - Wave symbolic offset algebra -----------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/Wave/IR/WaveSymbols.h"

#include "mlir/Dialect/Wave/IR/Wave.h"
#include "mlir/IR/OpImplementation.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/Support/CheckedArithmetic.h"
#include "llvm/Support/ErrorHandling.h"
#include "llvm/Support/MathExtras.h"
#include "llvm/Support/raw_ostream.h"

#include <array>
#include <cassert>
#include <cstring>
#include <limits>
#include <utility>

using namespace mlir;
using namespace mlir::wave;
using namespace mlir::wave::sym;

namespace {

static ExprKind getExprKind(ixs_tag tag) {
  static_assert(IXS_CMP == 12 && IXS_NOT == 15 && IXS_PARSE_ERROR == 17 &&
                    IXS_TRUNC == 18,
                "update ixs_tag mappings");
  static constexpr std::array<ExprKind, IXS_TRUNC + 1> kindByTag = {
      ExprKind::Integer, ExprKind::Rational, ExprKind::Symbol,
      ExprKind::Add,     ExprKind::Mul,      ExprKind::Floor,
      ExprKind::Ceil,    ExprKind::Mod,      ExprKind::Piecewise,
      ExprKind::Max,     ExprKind::Min,      ExprKind::Xor,
      ExprKind::Invalid, ExprKind::And,      ExprKind::Or,
      ExprKind::Invalid, ExprKind::Error,    ExprKind::ParseError,
      ExprKind::Trunc,
  };
  size_t index = static_cast<size_t>(tag);
  return index < kindByTag.size() ? kindByTag[index] : ExprKind::Invalid;
}

static PredKind getPredKind(ixs_tag tag) {
  static_assert(IXS_CMP == 12 && IXS_NOT == 15 && IXS_PARSE_ERROR == 17,
                "update ixs_tag mappings");
  static constexpr std::array<PredKind, IXS_PARSE_ERROR + 1> kindByTag = {
      PredKind::Invalid, PredKind::Invalid, PredKind::Invalid,
      PredKind::Invalid, PredKind::Invalid, PredKind::Invalid,
      PredKind::Invalid, PredKind::Invalid, PredKind::Invalid,
      PredKind::Invalid, PredKind::Invalid, PredKind::Invalid,
      PredKind::Cmp,     PredKind::And,     PredKind::Or,
      PredKind::Not,     PredKind::Error,   PredKind::ParseError,
  };
  size_t index = static_cast<size_t>(tag);
  return index < kindByTag.size() ? kindByTag[index] : PredKind::Invalid;
}

static std::optional<PredCmpOp> getPredCmpOp(ixs_cmp_op op) {
  switch (op) {
  case IXS_CMP_LT:
    return PredCmpOp::Lt;
  case IXS_CMP_LE:
    return PredCmpOp::Le;
  case IXS_CMP_GT:
    return PredCmpOp::Gt;
  case IXS_CMP_GE:
    return PredCmpOp::Ge;
  case IXS_CMP_EQ:
    return PredCmpOp::Eq;
  case IXS_CMP_NE:
    return PredCmpOp::Ne;
  }
  return std::nullopt;
}

static std::string joinSessionErrors(ixs_session *session) {
  std::string message;
  llvm::raw_string_ostream os(message);
  size_t nerrors = ixs_session_nerrors(session);
  for (size_t i = 0; i < nerrors; ++i) {
    if (i)
      os << "; ";
    os << ixs_session_error(session, i);
  }
  return message;
}

static std::string renderNode(const ixs_node *node) {
  assert(node && "expected non-null ixsimpl node");
  // ixsimpl printer walks immutable graph: no session needed.
  size_t n = ixs_print(node, nullptr, 0);
  if (n == std::numeric_limits<size_t>::max())
    llvm::report_fatal_error(
        "wave symbolic printer reported an invalid length");
  std::string text(n + 1, '\0');
  if (ixs_print(node, text.data(), text.size()) ==
      std::numeric_limits<size_t>::max())
    llvm::report_fatal_error("wave symbolic printer failed");
  text.resize(n);
  return text;
}

static WaveDialect &getWaveDialect(MLIRContext *context) {
  return *context->getOrLoadDialect<WaveDialect>();
}

static void setDiagnostic(std::string *diagnostic, std::string message) {
  if (diagnostic)
    *diagnostic = std::move(message);
}

static const ixs_node *rawExprNode(ExprHandle value, std::string *diagnostic) {
  if (!value) {
    setDiagnostic(diagnostic, "expected non-null wave.expr");
    return nullptr;
  }
  const ixs_node *node = value.raw();
  if (!ixs_node_is_expr(node)) {
    setDiagnostic(diagnostic, "expected wave.expr node");
    return nullptr;
  }
  return node;
}

static const ixs_node *rawPredNode(PredHandle value, std::string *diagnostic) {
  if (!value) {
    setDiagnostic(diagnostic, "expected non-null wave.pred");
    return nullptr;
  }
  const ixs_node *node = value.raw();
  if (!ixs_node_is_pred(node)) {
    setDiagnostic(diagnostic, "expected wave.pred node");
    return nullptr;
  }
  return node;
}

struct BufferReaderState {
  llvm::ArrayRef<uint8_t> bytes;
  size_t pos = 0;
};

static bool bufferReaderRead(void *userdata, void *buf, size_t len) {
  auto *state = static_cast<BufferReaderState *>(userdata);
  if (len > state->bytes.size() - state->pos)
    return false;
  std::memcpy(buf, state->bytes.data() + state->pos, len);
  state->pos += len;
  return true;
}

static size_t bufferReaderRemaining(void *userdata) {
  auto *state = static_cast<BufferReaderState *>(userdata);
  return state->bytes.size() - state->pos;
}

static void walkSymbolNamesImpl(const ixs_node *node,
                                llvm::function_ref<void(StringRef)> callback) {
  if (!node)
    return;

  SmallVector<const ixs_node *, 16> stack;
  stack.push_back(node);
  while (!stack.empty()) {
    const ixs_node *current = stack.pop_back_val();
    const ixs_node *rawNode = current;
    if (ixs_node_tag(rawNode) == IXS_SYM)
      callback(ixs_node_sym_name(rawNode));

    for (uint32_t index = ixs_node_nchildren(rawNode); index > 0; --index)
      stack.push_back(ixs_node_child(rawNode, index - 1));
  }
}

static FailureOr<ExprHandle> finishExpr(ixs_session *session,
                                        const ixs_node *node,
                                        std::string *diagnostic,
                                        const char *fallback) {
  if (!node) {
    setDiagnostic(diagnostic, fallback);
    return failure();
  }
  if (!ixs_node_is_expr(node)) {
    std::string message = joinSessionErrors(session);
    setDiagnostic(diagnostic, message.empty() ? fallback : message);
    return failure();
  }
  return ExprHandle(node);
}

static FailureOr<PredHandle> finishPred(ixs_session *session,
                                        const ixs_node *node,
                                        std::string *diagnostic,
                                        const char *fallback) {
  if (!node) {
    setDiagnostic(diagnostic, fallback);
    return failure();
  }
  if (!ixs_node_is_pred(node)) {
    std::string message = joinSessionErrors(session);
    setDiagnostic(diagnostic, message.empty() ? fallback : message);
    return failure();
  }
  return PredHandle(node);
}

static const ixs_node *composeRawBitwise(ixs_session *session,
                                         const ixs_node *lhs, ExprBinaryOp op,
                                         const ixs_node *rhs) {
  switch (op) {
  case ExprBinaryOp::Xor:
    return ixs_xor(session, lhs, rhs);
  case ExprBinaryOp::And:
    return ixs_and(session, lhs, rhs);
  case ExprBinaryOp::Or:
    return ixs_or(session, lhs, rhs);
  default:
    llvm_unreachable("not a symbolic bitwise operation");
  }
}

static const ixs_node *composeRawBinary(ixs_session *session,
                                        const ixs_node *lhs, ExprBinaryOp op,
                                        const ixs_node *rhs) {
  switch (op) {
  case ExprBinaryOp::Add:
    return ixs_add(session, lhs, rhs);
  case ExprBinaryOp::Sub:
    return ixs_sub(session, lhs, rhs);
  case ExprBinaryOp::Mul:
    return ixs_mul(session, lhs, rhs);
  case ExprBinaryOp::Div:
    return ixs_div(session, lhs, rhs);
  case ExprBinaryOp::Mod:
    return ixs_mod(session, lhs, rhs);
  case ExprBinaryOp::Max:
    return ixs_max(session, lhs, rhs);
  case ExprBinaryOp::Min:
    return ixs_min(session, lhs, rhs);
  default:
    return composeRawBitwise(session, lhs, op, rhs);
  }
}

static const ixs_node *composeFiniteDifference(ixs_session *session,
                                               ixs_facts *facts,
                                               const ixs_node *expr,
                                               const ixs_node *symbol,
                                               const ixs_node *step) {
  if (ixs_node_tag(symbol) != IXS_SYM)
    return nullptr;
  const ixs_node *shiftedSymbol = ixs_add(session, symbol, step);
  if (!shiftedSymbol)
    return nullptr;
  const ixs_node *shifted = ixs_subs(session, expr, symbol, shiftedSymbol);
  if (!shifted)
    return nullptr;
  const ixs_node *difference = ixs_sub(session, shifted, expr);
  if (!difference)
    return nullptr;
  difference = ixs_expand(session, difference);
  return difference ? ixs_simplify_facts(facts, difference) : nullptr;
}

} // namespace

llvm::StringRef mlir::wave::sym::getExprKindName(ExprKind kind) {
  static constexpr std::array<llvm::StringLiteral, 18> names = {
      "invalid", "integer", "rational", "symbol", "add",       "mul",
      "floor",   "ceil",    "trunc",    "mod",    "piecewise", "max",
      "min",     "xor",     "and",      "or",     "error",     "parse-error",
  };
  static_assert(names.size() == static_cast<size_t>(ExprKind::ParseError) + 1);
  size_t index = static_cast<size_t>(kind);
  return index < names.size() ? names[index] : names.front();
}

Store::Store() : ctx(ixs_ctx_create()) {
  if (!ctx)
    llvm::report_fatal_error("failed to create wave symbolic ixsimpl store");
}

Store::~Store() { ixs_ctx_destroy(ctx); }

std::string Store::render(const ixs_node *node) const {
  // Serialized: callers get one sync policy around dialect-owned context.
  llvm::sys::SmartScopedLock<true> lock(mutex);
  return renderNode(node);
}

std::string Store::render(ExprHandle value) const {
  return render(value.raw());
}

std::string Store::render(PredHandle value) const {
  return render(value.raw());
}

Session::Session(Store &store) : store(store), lock(store.mutex) {
  ixs_session_init(&session, store.ctx);
}

Session::~Session() { ixs_session_destroy(&session); }

namespace {

static CheckResult convertCheckResult(ixs_check_result result) {
  switch (result) {
  case IXS_CHECK_TRUE:
    return CheckResult::True;
  case IXS_CHECK_FALSE:
    return CheckResult::False;
  case IXS_CHECK_UNKNOWN:
    return CheckResult::Unknown;
  }
  return CheckResult::Unknown;
}

static Pow2Fact convertPow2Fact(ixs_pow2_fact fact) {
  switch (fact) {
  case IXS_POW2_UNKNOWN:
    return Pow2Fact::Unknown;
  case IXS_POW2_OR_ZERO:
    return Pow2Fact::OrZero;
  case IXS_POW2_POSITIVE:
    return Pow2Fact::Positive;
  }
  return Pow2Fact::Unknown;
}

static ixs_cmp_op convertCmpOp(PredCmpOp op) {
  switch (op) {
  case PredCmpOp::Lt:
    return IXS_CMP_LT;
  case PredCmpOp::Le:
    return IXS_CMP_LE;
  case PredCmpOp::Gt:
    return IXS_CMP_GT;
  case PredCmpOp::Ge:
    return IXS_CMP_GE;
  case PredCmpOp::Eq:
    return IXS_CMP_EQ;
  case PredCmpOp::Ne:
    return IXS_CMP_NE;
  }
  llvm_unreachable("unknown symbolic comparison operation");
}

static bool
collectRawSubstitutions(ArrayRef<ExprSubstitution> substitutions,
                        SmallVectorImpl<const ixs_node *> &targets,
                        SmallVectorImpl<const ixs_node *> &replacements,
                        std::string *diagnostic) {
  if (substitutions.size() > std::numeric_limits<uint32_t>::max()) {
    setDiagnostic(diagnostic, "too many wave.expr substitutions");
    return false;
  }
  targets.reserve(substitutions.size());
  replacements.reserve(substitutions.size());
  for (const ExprSubstitution &substitution : substitutions) {
    const ixs_node *target = rawExprNode(substitution.target, diagnostic);
    const ixs_node *replacement =
        rawExprNode(substitution.replacement, diagnostic);
    if (!target || !replacement)
      return false;
    targets.push_back(target);
    replacements.push_back(replacement);
  }
  return true;
}

static ixs_range_result convertRange(InferredRange range) {
  ixs_range_result result{};
  if (range.lower) {
    result.has_lower = true;
    result.lower_p = range.lower->numerator;
    result.lower_q = range.lower->denominator;
  }
  if (range.upper) {
    result.has_upper = true;
    result.upper_p = range.upper->numerator;
    result.upper_q = range.upper->denominator;
  }
  return result;
}

static InferredRange convertRange(ixs_range_result range) {
  InferredRange result;
  if (range.has_lower)
    result.lower = RationalEndpoint{range.lower_p, range.lower_q};
  if (range.has_upper)
    result.upper = RationalEndpoint{range.upper_p, range.upper_q};
  return result;
}

} // namespace

Analysis::Analysis(Store &store) : session(store) {}

void Analysis::invalidateQueryCaches() {
  exactDivideCache.clear();
  simplifyExprCache.clear();
  definedCache.clear();
}

FailureOr<std::unique_ptr<Analysis>>
Analysis::create(Store &store, ArrayRef<PredHandle> assumptions,
                 std::string *diagnostic) {
  setDiagnostic(diagnostic, {});
  std::unique_ptr<Analysis> analysis(new Analysis(store));
  analysis->facts = ixs_facts_create(analysis->session.raw());
  if (!analysis->facts) {
    analysis->poison(diagnostic, "failed to create symbolic fact set");
    return failure();
  }
  analysis->usable = true;
  if (failed(analysis->assume(assumptions, diagnostic)))
    return failure();
  return analysis;
}

FailureOr<std::unique_ptr<Analysis>>
Analysis::createDirect(Store &store, ArrayRef<PredHandle> assumptions,
                       std::string *diagnostic) {
  setDiagnostic(diagnostic, {});
  std::unique_ptr<Analysis> analysis(new Analysis(store));
  SmallVector<const ixs_node *, 4> rawAssumptions;
  rawAssumptions.reserve(assumptions.size());
  for (PredHandle assumption : assumptions) {
    const ixs_node *rawAssumption = rawPredNode(assumption, diagnostic);
    if (!rawAssumption) {
      analysis->poison(diagnostic, "failed to ingest symbolic assumptions");
      return failure();
    }
    rawAssumptions.push_back(rawAssumption);
  }
  analysis->facts = ixs_facts_create_preds(
      analysis->session.raw(), rawAssumptions.data(), rawAssumptions.size());
  if (!analysis->facts) {
    analysis->poison(diagnostic, "failed to ingest symbolic assumptions");
    return failure();
  }
  analysis->usable = true;
  return analysis;
}

bool Analysis::prepareQuery() {
  ixs_session_clear_errors(session.raw());
  return usable && facts;
}

void Analysis::poison(std::string *diagnostic, StringRef fallback) {
  usable = false;
  std::string message = joinSessionErrors(session.raw());
  if (!message.empty())
    setDiagnostic(diagnostic, std::move(message));
  else if (!diagnostic || diagnostic->empty())
    setDiagnostic(diagnostic, fallback.str());
}

LogicalResult Analysis::assume(PredHandle pred, std::string *diagnostic) {
  setDiagnostic(diagnostic, {});
  if (!prepareQuery()) {
    setDiagnostic(diagnostic, "symbolic analysis is unusable");
    return failure();
  }
  const ixs_node *rawPred = rawPredNode(pred, diagnostic);
  if (!rawPred || !ixs_facts_assume_pred(facts, rawPred)) {
    poison(diagnostic, "failed to ingest symbolic assumption");
    return failure();
  }
  invalidateQueryCaches();
  return success();
}

LogicalResult Analysis::assume(ArrayRef<PredHandle> predicates,
                               std::string *diagnostic) {
  setDiagnostic(diagnostic, {});
  if (!prepareQuery()) {
    setDiagnostic(diagnostic, "symbolic analysis is unusable");
    return failure();
  }
  SmallVector<const ixs_node *, 4> rawPredicates;
  rawPredicates.reserve(predicates.size());
  for (PredHandle predicate : predicates) {
    const ixs_node *rawPredicate = rawPredNode(predicate, diagnostic);
    if (!rawPredicate) {
      poison(diagnostic, "failed to ingest symbolic assumptions");
      return failure();
    }
    rawPredicates.push_back(rawPredicate);
  }
  if (!ixs_facts_assume_preds(facts, rawPredicates.data(),
                              rawPredicates.size())) {
    poison(diagnostic, "failed to ingest symbolic assumptions");
    return failure();
  }
  invalidateQueryCaches();
  return success();
}

LogicalResult Analysis::assumeRange(ExprHandle expr, InferredRange range,
                                    std::string *diagnostic) {
  setDiagnostic(diagnostic, {});
  if (!prepareQuery()) {
    setDiagnostic(diagnostic, "symbolic analysis is unusable");
    return failure();
  }
  const ixs_node *rawExpr = rawExprNode(expr, diagnostic);
  if (!rawExpr || (range.lower && range.lower->denominator <= 0) ||
      (range.upper && range.upper->denominator <= 0)) {
    poison(diagnostic, "invalid symbolic range");
    return failure();
  }
  ixs_range_result rawRange = convertRange(std::move(range));
  if (!ixs_facts_assume_range(facts, rawExpr, &rawRange)) {
    poison(diagnostic, "failed to ingest symbolic range");
    return failure();
  }
  invalidateQueryCaches();
  return success();
}

LogicalResult Analysis::deriveAffine(ExprHandle base, int64_t scale,
                                     int64_t offset, ExprHandle derived,
                                     std::string *diagnostic) {
  setDiagnostic(diagnostic, {});
  if (!prepareQuery()) {
    setDiagnostic(diagnostic, "symbolic analysis is unusable");
    return failure();
  }
  const ixs_node *rawBase = rawExprNode(base, diagnostic);
  const ixs_node *rawDerived = rawExprNode(derived, diagnostic);
  if (!rawBase || !rawDerived ||
      !ixs_facts_derive_affine(facts, rawBase, scale, offset, rawDerived)) {
    poison(diagnostic, "failed to derive symbolic affine range");
    return failure();
  }
  invalidateQueryCaches();
  return success();
}

LogicalResult
Analysis::substituteFacts(ArrayRef<ExprSubstitution> substitutions,
                          std::string *diagnostic) {
  setDiagnostic(diagnostic, {});
  if (!prepareQuery()) {
    setDiagnostic(diagnostic, "symbolic analysis is unusable");
    return failure();
  }
  SmallVector<const ixs_node *, 4> targets;
  SmallVector<const ixs_node *, 4> replacements;
  if (!collectRawSubstitutions(substitutions, targets, replacements,
                               diagnostic)) {
    poison(diagnostic, "invalid symbolic fact substitution");
    return failure();
  }
  ixs_facts *substituted = ixs_facts_create(session.raw());
  if (!substituted ||
      !ixs_facts_substitute_multi(substituted, facts,
                                  static_cast<uint32_t>(targets.size()),
                                  targets.data(), replacements.data())) {
    poison(diagnostic, "failed to substitute symbolic facts");
    return failure();
  }
  facts = substituted;
  invalidateQueryCaches();
  return success();
}

FailureOr<ExprHandle> Analysis::compose(ExprHandle lhsHandle, ExprBinaryOp op,
                                        ExprHandle rhsHandle,
                                        std::string *diagnostic) {
  ixs_session_clear_errors(session.raw());
  const ixs_node *lhs = rawExprNode(lhsHandle, diagnostic);
  const ixs_node *rhs = rawExprNode(rhsHandle, diagnostic);
  if (!lhs || !rhs)
    return failure();
  return finishExpr(session.raw(),
                    composeRawBinary(session.raw(), lhs, op, rhs), diagnostic,
                    "failed to compose wave.expr");
}

FailureOr<ExprHandle> Analysis::composeCeil(ExprHandle value,
                                            std::string *diagnostic) {
  ixs_session_clear_errors(session.raw());
  const ixs_node *raw = rawExprNode(value, diagnostic);
  if (!raw)
    return failure();
  return finishExpr(session.raw(), ixs_ceil(session.raw(), raw), diagnostic,
                    "failed to compose wave.expr");
}

FailureOr<ExprHandle> Analysis::composeFloor(ExprHandle value,
                                             std::string *diagnostic) {
  ixs_session_clear_errors(session.raw());
  const ixs_node *raw = rawExprNode(value, diagnostic);
  if (!raw)
    return failure();
  return finishExpr(session.raw(), ixs_floor(session.raw(), raw), diagnostic,
                    "failed to compose wave.expr");
}

FailureOr<ExprHandle> Analysis::composeNeg(ExprHandle value,
                                           std::string *diagnostic) {
  ixs_session_clear_errors(session.raw());
  const ixs_node *raw = rawExprNode(value, diagnostic);
  if (!raw)
    return failure();
  return finishExpr(session.raw(), ixs_neg(session.raw(), raw), diagnostic,
                    "failed to compose wave.expr");
}

FailureOr<ExprHandle> Analysis::composeSymbol(StringRef name,
                                              std::string *diagnostic) {
  ixs_session_clear_errors(session.raw());
  std::string nulTerminated(name);
  return finishExpr(session.raw(),
                    ixs_sym(session.raw(), nulTerminated.c_str()), diagnostic,
                    "failed to construct wave.expr symbol");
}

FailureOr<ExprHandle> Analysis::composeInteger(int64_t value,
                                               std::string *diagnostic) {
  ixs_session_clear_errors(session.raw());
  return finishExpr(session.raw(), ixs_int(session.raw(), value), diagnostic,
                    "failed to construct wave.expr integer literal");
}

FailureOr<ExprHandle> Analysis::composePiecewise(ArrayRef<PiecewiseCase> cases,
                                                 std::string *diagnostic) {
  ixs_session_clear_errors(session.raw());
  if (cases.empty() || cases.size() > std::numeric_limits<uint32_t>::max()) {
    setDiagnostic(diagnostic, "invalid wave.expr piecewise case count");
    return failure();
  }
  SmallVector<const ixs_node *, 4> values;
  SmallVector<const ixs_node *, 4> conditions;
  values.reserve(cases.size());
  conditions.reserve(cases.size());
  for (PiecewiseCase piece : cases) {
    const ixs_node *value = rawExprNode(piece.value, diagnostic);
    const ixs_node *condition = rawPredNode(piece.condition, diagnostic);
    if (!value || !condition)
      return failure();
    values.push_back(value);
    conditions.push_back(condition);
  }
  return finishExpr(session.raw(),
                    ixs_pw(session.raw(), static_cast<uint32_t>(values.size()),
                           values.data(), conditions.data()),
                    diagnostic, "failed to compose wave.expr piecewise");
}

FailureOr<PredHandle> Analysis::composeTrue(std::string *diagnostic) {
  ixs_session_clear_errors(session.raw());
  return finishPred(session.raw(), ixs_true(session.raw()), diagnostic,
                    "failed to compose wave.pred true");
}

FailureOr<PredHandle> Analysis::composeFalse(std::string *diagnostic) {
  ixs_session_clear_errors(session.raw());
  return finishPred(session.raw(), ixs_false(session.raw()), diagnostic,
                    "failed to compose wave.pred false");
}

FailureOr<PredHandle> Analysis::compare(ExprHandle lhsHandle, PredCmpOp op,
                                        ExprHandle rhsHandle,
                                        std::string *diagnostic) {
  ixs_session_clear_errors(session.raw());
  const ixs_node *lhs = rawExprNode(lhsHandle, diagnostic);
  const ixs_node *rhs = rawExprNode(rhsHandle, diagnostic);
  if (!lhs || !rhs)
    return failure();
  return finishPred(session.raw(),
                    ixs_cmp(session.raw(), lhs, convertCmpOp(op), rhs),
                    diagnostic, "failed to compose wave.pred");
}

FailureOr<PredHandle> Analysis::composeAnd(PredHandle lhsHandle,
                                           PredHandle rhsHandle,
                                           std::string *diagnostic) {
  ixs_session_clear_errors(session.raw());
  const ixs_node *lhs = rawPredNode(lhsHandle, diagnostic);
  const ixs_node *rhs = rawPredNode(rhsHandle, diagnostic);
  if (!lhs || !rhs)
    return failure();
  return finishPred(session.raw(), ixs_and(session.raw(), lhs, rhs), diagnostic,
                    "failed to compose wave.pred AND");
}

FailureOr<PredHandle> Analysis::composeOr(PredHandle lhsHandle,
                                          PredHandle rhsHandle,
                                          std::string *diagnostic) {
  ixs_session_clear_errors(session.raw());
  const ixs_node *lhs = rawPredNode(lhsHandle, diagnostic);
  const ixs_node *rhs = rawPredNode(rhsHandle, diagnostic);
  if (!lhs || !rhs)
    return failure();
  return finishPred(session.raw(), ixs_or(session.raw(), lhs, rhs), diagnostic,
                    "failed to compose wave.pred OR");
}

FailureOr<PredHandle> Analysis::composeNot(PredHandle value,
                                           std::string *diagnostic) {
  ixs_session_clear_errors(session.raw());
  const ixs_node *raw = rawPredNode(value, diagnostic);
  if (!raw)
    return failure();
  return finishPred(session.raw(), ixs_not(session.raw(), raw), diagnostic,
                    "failed to compose wave.pred NOT");
}

FailureOr<ExprHandle>
Analysis::substitute(ExprHandle value, ArrayRef<ExprSubstitution> substitutions,
                     std::string *diagnostic) {
  ixs_session_clear_errors(session.raw());
  const ixs_node *raw = rawExprNode(value, diagnostic);
  SmallVector<const ixs_node *, 4> targets;
  SmallVector<const ixs_node *, 4> replacements;
  if (!raw || !collectRawSubstitutions(substitutions, targets, replacements,
                                       diagnostic))
    return failure();
  const ixs_node *result =
      ixs_subs_multi(session.raw(), raw, static_cast<uint32_t>(targets.size()),
                     targets.data(), replacements.data());
  return finishExpr(session.raw(), result, diagnostic,
                    "failed to substitute wave.expr");
}

FailureOr<PredHandle>
Analysis::substitute(PredHandle value, ArrayRef<ExprSubstitution> substitutions,
                     std::string *diagnostic) {
  ixs_session_clear_errors(session.raw());
  const ixs_node *raw = rawPredNode(value, diagnostic);
  SmallVector<const ixs_node *, 4> targets;
  SmallVector<const ixs_node *, 4> replacements;
  if (!raw || !collectRawSubstitutions(substitutions, targets, replacements,
                                       diagnostic))
    return failure();
  const ixs_node *result =
      ixs_subs_multi(session.raw(), raw, static_cast<uint32_t>(targets.size()),
                     targets.data(), replacements.data());
  return finishPred(session.raw(), result, diagnostic,
                    "failed to substitute wave.pred");
}

FailureOr<ExprHandle> Analysis::simplify(ExprHandle value,
                                         std::string *diagnostic) {
  if (!prepareQuery()) {
    setDiagnostic(diagnostic, "symbolic analysis is unusable");
    return failure();
  }
  const ixs_node *raw = rawExprNode(value, diagnostic);
  if (!raw)
    return failure();
  if (const ixs_node *cached = simplifyExprCache.lookup(raw))
    return ExprHandle(cached);
  FailureOr<ExprHandle> simplified =
      finishExpr(session.raw(), ixs_simplify_facts(facts, raw), diagnostic,
                 "failed to simplify wave.expr");
  if (succeeded(simplified))
    simplifyExprCache.try_emplace(raw, simplified->raw());
  return simplified;
}

FailureOr<PredHandle> Analysis::simplify(PredHandle value,
                                         std::string *diagnostic) {
  if (!prepareQuery()) {
    setDiagnostic(diagnostic, "symbolic analysis is unusable");
    return failure();
  }
  const ixs_node *raw = rawPredNode(value, diagnostic);
  if (!raw)
    return failure();
  return finishPred(session.raw(), ixs_simplify_facts(facts, raw), diagnostic,
                    "failed to simplify wave.pred");
}

LogicalResult Analysis::simplify(MutableArrayRef<ExprHandle> values,
                                 std::string *diagnostic) {
  if (!prepareQuery()) {
    setDiagnostic(diagnostic, "symbolic analysis is unusable");
    return failure();
  }
  SmallVector<const ixs_node *, 8> rawValues;
  rawValues.reserve(values.size());
  for (ExprHandle value : values) {
    const ixs_node *raw = rawExprNode(value, diagnostic);
    if (!raw)
      return failure();
    rawValues.push_back(raw);
  }
  ixs_simplify_batch_facts(facts, rawValues.data(), rawValues.size());
  for (const ixs_node *raw : rawValues) {
    if (!raw || !ixs_node_is_expr(raw)) {
      std::string message = joinSessionErrors(session.raw());
      setDiagnostic(diagnostic, message.empty()
                                    ? "failed to simplify wave.expr batch"
                                    : message);
      return failure();
    }
  }
  for (size_t index : llvm::seq<size_t>(values.size()))
    values[index] = ExprHandle(rawValues[index]);
  return success();
}

FailureOr<ExprHandle> Analysis::expand(ExprHandle value,
                                       std::string *diagnostic) {
  ixs_session_clear_errors(session.raw());
  const ixs_node *raw = rawExprNode(value, diagnostic);
  if (!raw)
    return failure();
  return finishExpr(session.raw(), ixs_expand(session.raw(), raw), diagnostic,
                    "failed to expand wave.expr");
}

FailureOr<PredHandle> Analysis::expand(PredHandle value,
                                       std::string *diagnostic) {
  ixs_session_clear_errors(session.raw());
  const ixs_node *raw = rawPredNode(value, diagnostic);
  if (!raw)
    return failure();
  return finishPred(session.raw(), ixs_expand(session.raw(), raw), diagnostic,
                    "failed to expand wave.pred");
}

CheckResult Analysis::check(PredHandle pred) {
  if (!prepareQuery())
    return CheckResult::Unknown;
  const ixs_node *raw = rawPredNode(pred, /*diagnostic=*/nullptr);
  if (!raw)
    return CheckResult::Unknown;
  ixs_check_result result = PredView(pred).getKind() == PredKind::Cmp
                                ? ixs_check_facts(facts, raw)
                                : ixs_check_predicate_facts(facts, raw);
  return convertCheckResult(result);
}

CheckResult Analysis::equivalent(ExprHandle lhs, ExprHandle rhs) {
  if (!prepareQuery())
    return CheckResult::Unknown;
  const ixs_node *rawLhs = rawExprNode(lhs, /*diagnostic=*/nullptr);
  const ixs_node *rawRhs = rawExprNode(rhs, /*diagnostic=*/nullptr);
  return rawLhs && rawRhs
             ? convertCheckResult(ixs_equivalent_facts(facts, rawLhs, rawRhs))
             : CheckResult::Unknown;
}

enum class ComparisonRounding { Floor, Ceil };

static std::optional<ComparisonRounding> getComparisonRounding(PredCmpOp op) {
  // Floor preserves < 0 and >= 0; ceil preserves <= 0 and > 0.
  switch (op) {
  case PredCmpOp::Lt:
  case PredCmpOp::Ge:
    return ComparisonRounding::Floor;
  case PredCmpOp::Le:
  case PredCmpOp::Gt:
    return ComparisonRounding::Ceil;
  case PredCmpOp::Eq:
  case PredCmpOp::Ne:
    return std::nullopt;
  }
  llvm_unreachable("unknown predicate comparison");
}

static FailureOr<ExprHandle>
roundComparisonDifference(Analysis &analysis, PredView view, int64_t divisor,
                          ComparisonRounding rounding) {
  FailureOr<ExprHandle> difference =
      analysis.compose(view.getCmpLhs(), ExprBinaryOp::Sub, view.getCmpRhs());
  if (failed(difference) ||
      analysis.integerValued(*difference) != CheckResult::True)
    return failure();
  FailureOr<ExprHandle> scale = analysis.composeInteger(divisor);
  if (failed(scale))
    return failure();
  FailureOr<ExprHandle> quotient =
      analysis.compose(*difference, ExprBinaryOp::Div, *scale);
  if (failed(quotient))
    return failure();
  return rounding == ComparisonRounding::Floor
             ? analysis.composeFloor(*quotient)
             : analysis.composeCeil(*quotient);
}

static FailureOr<PredHandle> scaleOrderedComparison(Analysis &analysis,
                                                    PredHandle predicate,
                                                    int64_t divisor) {
  if (divisor <= 1)
    return failure();
  PredView view(predicate);
  std::optional<PredCmpOp> op = view.getCmpOp();
  if (!op)
    return failure();
  std::optional<ComparisonRounding> rounding = getComparisonRounding(*op);
  if (!rounding)
    return failure();
  FailureOr<ExprHandle> rounded =
      roundComparisonDifference(analysis, view, divisor, *rounding);
  if (failed(rounded))
    return failure();
  FailureOr<ExprHandle> zero = analysis.composeInteger(0);
  if (failed(zero))
    return failure();
  FailureOr<PredHandle> scaled = analysis.compare(*rounded, *op, *zero);
  if (failed(scaled))
    return failure();
  return analysis.simplify(*scaled);
}

static void collectCongruenceModuli(Analysis &analysis, PredHandle predicate,
                                    SmallVectorImpl<int64_t> &moduli) {
  walkSymbolNames(predicate, [&](StringRef name) {
    FailureOr<ExprHandle> symbol = analysis.composeSymbol(name);
    if (failed(symbol))
      return;
    std::optional<Congruence> congruence =
        analysis.getSymbolCongruence(*symbol);
    if (!congruence || congruence->modulus <= 1 ||
        llvm::is_contained(moduli, congruence->modulus))
      return;
    moduli.push_back(congruence->modulus);
  });
}

SmallVector<PredHandle, 4>
Analysis::orderedComparisonForms(PredHandle predicate) {
  SmallVector<PredHandle, 4> forms{predicate};
  if (!prepareQuery() || defined(predicate) != CheckResult::True)
    return forms;

  FailureOr<PredHandle> simplified = simplify(predicate);
  if (succeeded(simplified) && !llvm::is_contained(forms, *simplified))
    forms.push_back(*simplified);

  SmallVector<int64_t, 4> moduli;
  collectCongruenceModuli(*this, predicate, moduli);
  llvm::sort(moduli);
  for (int64_t modulus : moduli) {
    FailureOr<PredHandle> scaled =
        scaleOrderedComparison(*this, predicate, modulus);
    if (succeeded(scaled) && !llvm::is_contained(forms, *scaled))
      forms.push_back(*scaled);
  }
  return forms;
}

CheckResult Analysis::equivalent(PredHandle lhs, PredHandle rhs) {
  if (!prepareQuery())
    return CheckResult::Unknown;
  const ixs_node *rawLhs = rawPredNode(lhs, /*diagnostic=*/nullptr);
  const ixs_node *rawRhs = rawPredNode(rhs, /*diagnostic=*/nullptr);
  return rawLhs && rawRhs
             ? convertCheckResult(ixs_equivalent_facts(facts, rawLhs, rawRhs))
             : CheckResult::Unknown;
}

CheckResult Analysis::defined(ExprHandle expr) {
  if (!prepareQuery())
    return CheckResult::Unknown;
  const ixs_node *raw = rawExprNode(expr, /*diagnostic=*/nullptr);
  if (!raw)
    return CheckResult::Unknown;
  auto [it, inserted] = definedCache.try_emplace(raw);
  if (inserted)
    it->second = convertCheckResult(ixs_check_defined_facts(facts, raw));
  return it->second;
}

CheckResult Analysis::defined(PredHandle pred) {
  if (!prepareQuery())
    return CheckResult::Unknown;
  const ixs_node *raw = rawPredNode(pred, /*diagnostic=*/nullptr);
  if (!raw)
    return CheckResult::Unknown;
  auto [it, inserted] = definedCache.try_emplace(raw);
  if (inserted)
    it->second = convertCheckResult(ixs_check_defined_facts(facts, raw));
  return it->second;
}

CheckResult Analysis::integerValued(ExprHandle expr) {
  if (!prepareQuery())
    return CheckResult::Unknown;
  const ixs_node *raw = rawExprNode(expr, /*diagnostic=*/nullptr);
  return raw ? convertCheckResult(ixs_check_integer_valued_facts(facts, raw))
             : CheckResult::Unknown;
}

CheckResult Analysis::divisible(ExprHandle expr, int64_t modulus) {
  if (!prepareQuery())
    return CheckResult::Unknown;
  const ixs_node *raw = rawExprNode(expr, /*diagnostic=*/nullptr);
  return raw ? convertCheckResult(
                   ixs_check_divisible_facts(facts, raw, modulus))
             : CheckResult::Unknown;
}

CheckResult Analysis::congruent(ExprHandle expr, int64_t modulus,
                                int64_t residue) {
  if (!prepareQuery())
    return CheckResult::Unknown;
  const ixs_node *raw = rawExprNode(expr, /*diagnostic=*/nullptr);
  return raw ? convertCheckResult(
                   ixs_check_congruent_facts(facts, raw, modulus, residue))
             : CheckResult::Unknown;
}

ExactDivideResult Analysis::tryExactDivide(ExprHandle expr, int64_t divisor) {
  if (!prepareQuery())
    return {};
  const ixs_node *raw = rawExprNode(expr, /*diagnostic=*/nullptr);
  if (!raw)
    return {};
  auto key = std::make_pair(raw, divisor);
  auto cached = exactDivideCache.find(key);
  if (cached != exactDivideCache.end())
    return cached->second;
  ixs_exact_divide_result result =
      ixs_try_exact_divide_facts(facts, raw, divisor);
  ExactDivideResult converted;
  switch (result.status) {
  case IXS_EXACT_DIVIDE_PROVEN:
    converted = {ExactDivideStatus::Proven, ExprHandle(result.quotient)};
    break;
  case IXS_EXACT_DIVIDE_NOT_EXACT:
    converted = {ExactDivideStatus::NotExact, {}};
    break;
  case IXS_EXACT_DIVIDE_UNKNOWN:
    converted = {ExactDivideStatus::Unknown, {}};
    break;
  case IXS_EXACT_DIVIDE_ERROR:
    return {ExactDivideStatus::Error, {}};
  }
  exactDivideCache.try_emplace(key, converted);
  return converted;
}

Pow2Fact Analysis::getPow2Fact(ExprHandle expr) {
  if (!prepareQuery())
    return Pow2Fact::Unknown;
  const ixs_node *raw = rawExprNode(expr, /*diagnostic=*/nullptr);
  return raw ? convertPow2Fact(ixs_get_pow2_fact_facts(facts, raw))
             : Pow2Fact::Unknown;
}

std::optional<KnownBits> Analysis::getKnownBits(ExprHandle expr) {
  if (!prepareQuery())
    return std::nullopt;
  const ixs_node *raw = rawExprNode(expr, /*diagnostic=*/nullptr);
  ixs_known_bits result{};
  if (!raw || !ixs_get_known_bits_facts(facts, raw, &result))
    return std::nullopt;
  return KnownBits{result.known_zero, result.known_one,
                   convertPow2Fact(result.pow2)};
}

std::optional<Congruence> Analysis::getSymbolCongruence(ExprHandle symbol) {
  if (!prepareQuery())
    return std::nullopt;
  const ixs_node *raw = rawExprNode(symbol, /*diagnostic=*/nullptr);
  int64_t modulus = 0;
  int64_t residue = 0;
  if (!raw || !ixs_get_symbol_congruence_facts(facts, raw, &modulus, &residue))
    return std::nullopt;
  return Congruence{modulus, residue};
}

std::optional<InferredRange> Analysis::range(ExprHandle expr) {
  if (!prepareQuery())
    return std::nullopt;
  const ixs_node *raw = rawExprNode(expr, /*diagnostic=*/nullptr);
  ixs_range_result result{};
  if (!raw || !ixs_range_facts(facts, raw, &result))
    return std::nullopt;
  return convertRange(result);
}

std::optional<int64_t> Analysis::constantDifference(ExprHandle lhs,
                                                    ExprHandle rhs) {
  if (!prepareQuery())
    return std::nullopt;
  const ixs_node *rawLhs = rawExprNode(lhs, /*diagnostic=*/nullptr);
  const ixs_node *rawRhs = rawExprNode(rhs, /*diagnostic=*/nullptr);
  if (!rawLhs || !rawRhs)
    return std::nullopt;
  const ixs_node *difference = ixs_sub(session.raw(), rawLhs, rawRhs);
  difference = difference ? ixs_simplify_facts(facts, difference) : nullptr;
  if (!difference || ixs_node_tag(difference) != IXS_INT)
    return std::nullopt;
  return ixs_node_int_val(difference);
}

std::optional<AffineDecomposition>
Analysis::affineDecompose(ExprHandle expr, ExprHandle symbol) {
  if (!prepareQuery())
    return std::nullopt;
  const ixs_node *rawExpr = rawExprNode(expr, /*diagnostic=*/nullptr);
  const ixs_node *rawSymbol = rawExprNode(symbol, /*diagnostic=*/nullptr);
  const ixs_node *coefficient = nullptr;
  const ixs_node *residual = nullptr;
  if (!rawExpr || !rawSymbol ||
      !ixs_affine_decompose_facts(facts, rawExpr, rawSymbol, &coefficient,
                                  &residual))
    return std::nullopt;
  return AffineDecomposition{ExprHandle(coefficient), ExprHandle(residual)};
}

std::optional<ExprHandle> Analysis::finiteDifference(ExprHandle expr,
                                                     ExprHandle symbol,
                                                     ExprHandle step) {
  if (!prepareQuery())
    return std::nullopt;
  const ixs_node *rawExpr = rawExprNode(expr, /*diagnostic=*/nullptr);
  const ixs_node *rawSymbol = rawExprNode(symbol, /*diagnostic=*/nullptr);
  const ixs_node *rawStep = rawExprNode(step, /*diagnostic=*/nullptr);
  if (!rawExpr || !rawSymbol || !rawStep)
    return std::nullopt;
  const ixs_node *difference = composeFiniteDifference(
      session.raw(), facts, rawExpr, rawSymbol, rawStep);
  if (!difference || !ixs_node_is_expr(difference))
    return std::nullopt;
  return ExprHandle(difference);
}

std::optional<SplitAdditiveConstant>
Analysis::splitAdditiveConstant(ExprHandle expr) {
  if (!prepareQuery())
    return std::nullopt;
  const ixs_node *raw = rawExprNode(expr, /*diagnostic=*/nullptr);
  const ixs_node *residual = nullptr;
  int64_t constant = 0;
  if (!raw ||
      !ixs_split_additive_constant_facts(facts, raw, &residual, &constant))
    return std::nullopt;
  return SplitAdditiveConstant{ExprHandle(residual), constant};
}

bool mlir::wave::sym::isExpr(ExprHandle value) {
  return value && ixs_node_is_expr(value.raw());
}

bool mlir::wave::sym::isPred(PredHandle value) {
  return value && ixs_node_is_pred(value.raw());
}

bool mlir::wave::sym::isIntegerValued(ExprHandle value) {
  return value && ixs_node_is_integer_valued(value.raw());
}

bool ExprView::isValid() const { return isExpr(value); }

ExprKind ExprView::getKind() const {
  if (!value)
    return ExprKind::Invalid;
  return getExprKind(ixs_node_tag(value.raw()));
}

std::optional<int64_t> ExprView::getInt() const {
  if (getKind() != ExprKind::Integer)
    return std::nullopt;
  return ixs_node_int_val(value.raw());
}

std::optional<RationalLiteral> ExprView::getRational() const {
  if (getKind() != ExprKind::Rational)
    return std::nullopt;
  const ixs_node *node = value.raw();
  return RationalLiteral{ixs_node_rat_num(node), ixs_node_rat_den(node)};
}

StringRef ExprView::getSymbolName() const {
  if (getKind() != ExprKind::Symbol)
    return {};
  return ixs_node_sym_name(value.raw());
}

ExprHandle ExprView::getAddConstant() const {
  if (getKind() != ExprKind::Add)
    return {};
  return ExprHandle(ixs_node_add_coeff(value.raw()));
}

uint32_t ExprView::getAddTermCount() const {
  if (getKind() != ExprKind::Add)
    return 0;
  return ixs_node_add_nterms(value.raw());
}

AddTerm ExprView::getAddTerm(uint32_t index) const {
  if (getKind() != ExprKind::Add)
    return {};
  const ixs_node *node = value.raw();
  if (index >= ixs_node_add_nterms(node))
    return {};
  return AddTerm{ExprHandle(ixs_node_add_term_coeff(node, index)),
                 ExprHandle(ixs_node_add_term(node, index))};
}

ExprHandle ExprView::getMulCoefficient() const {
  if (getKind() != ExprKind::Mul)
    return {};
  return ExprHandle(ixs_node_mul_coeff(value.raw()));
}

uint32_t ExprView::getMulFactorCount() const {
  if (getKind() != ExprKind::Mul)
    return 0;
  return ixs_node_mul_nfactors(value.raw());
}

MulFactor ExprView::getMulFactor(uint32_t index) const {
  if (getKind() != ExprKind::Mul)
    return {};
  const ixs_node *node = value.raw();
  if (index >= ixs_node_mul_nfactors(node))
    return {};
  return MulFactor{ExprHandle(ixs_node_mul_factor_base(node, index)),
                   ixs_node_mul_factor_exp(node, index)};
}

ExprHandle ExprView::getUnaryArg() const {
  ExprKind kind = getKind();
  if (kind != ExprKind::Floor && kind != ExprKind::Ceil &&
      kind != ExprKind::Trunc)
    return {};
  return ExprHandle(ixs_node_unary_arg(value.raw()));
}

ExprHandle ExprView::getBinaryLhs() const {
  if (getKind() != ExprKind::Mod)
    return {};
  return ExprHandle(ixs_node_binary_lhs(value.raw()));
}

ExprHandle ExprView::getBinaryRhs() const {
  if (getKind() != ExprKind::Mod)
    return {};
  return ExprHandle(ixs_node_binary_rhs(value.raw()));
}

uint32_t ExprView::getAssocArgCount() const {
  ExprKind kind = getKind();
  if (kind != ExprKind::Max && kind != ExprKind::Min && kind != ExprKind::Xor &&
      kind != ExprKind::And && kind != ExprKind::Or)
    return 0;
  return ixs_node_assoc_nargs(value.raw());
}

ExprHandle ExprView::getAssocArg(uint32_t index) const {
  if (index >= getAssocArgCount())
    return {};
  return ExprHandle(ixs_node_assoc_arg(value.raw(), index));
}

uint32_t ExprView::getPiecewiseCaseCount() const {
  if (getKind() != ExprKind::Piecewise)
    return 0;
  return ixs_node_pw_ncases(value.raw());
}

PiecewiseCase ExprView::getPiecewiseCase(uint32_t index) const {
  if (getKind() != ExprKind::Piecewise)
    return {};
  const ixs_node *node = value.raw();
  if (index >= ixs_node_pw_ncases(node))
    return {};
  return PiecewiseCase{ExprHandle(ixs_node_pw_value(node, index)),
                       PredHandle(ixs_node_pw_cond(node, index))};
}

bool PredView::isValid() const { return isPred(value); }

PredKind PredView::getKind() const {
  if (!value)
    return PredKind::Invalid;
  const ixs_node *node = value.raw();
  if (ixs_node_tag(node) == IXS_INT) {
    int64_t constant = ixs_node_int_val(node);
    if (constant == 0)
      return PredKind::False;
    if (constant == 1)
      return PredKind::True;
  }
  return getPredKind(ixs_node_tag(node));
}

std::optional<PredCmpOp> PredView::getCmpOp() const {
  if (getKind() != PredKind::Cmp)
    return std::nullopt;
  return getPredCmpOp(ixs_node_cmp_op(value.raw()));
}

ExprHandle PredView::getCmpLhs() const {
  if (getKind() != PredKind::Cmp)
    return {};
  return ExprHandle(ixs_node_binary_lhs(value.raw()));
}

ExprHandle PredView::getCmpRhs() const {
  if (getKind() != PredKind::Cmp)
    return {};
  return ExprHandle(ixs_node_binary_rhs(value.raw()));
}

PredHandle PredView::getUnaryArg() const {
  if (getKind() != PredKind::Not)
    return {};
  return PredHandle(ixs_node_unary_arg(value.raw()));
}

uint32_t PredView::getLogicArgCount() const {
  PredKind kind = getKind();
  if (kind != PredKind::And && kind != PredKind::Or)
    return 0;
  return ixs_node_assoc_nargs(value.raw());
}

PredHandle PredView::getLogicArg(uint32_t index) const {
  PredKind kind = getKind();
  if (kind != PredKind::And && kind != PredKind::Or)
    return {};
  const ixs_node *node = value.raw();
  if (index >= ixs_node_assoc_nargs(node))
    return {};
  return PredHandle(ixs_node_assoc_arg(node, index));
}

FailureOr<ExprHandle> mlir::wave::sym::parseExpr(Store &store,
                                                 llvm::StringRef text,
                                                 std::string *diagnostic) {
  std::string nulTerminated(text);
  Session session(store);
  const ixs_node *node = ixs_parse_expr(session.raw(), nulTerminated.c_str(),
                                        nulTerminated.size());
  if (!node) {
    setDiagnostic(diagnostic, "out of memory parsing wave.expr");
    return failure();
  }
  if (!ixs_node_is_expr(node)) {
    std::string message = joinSessionErrors(session.raw());
    setDiagnostic(diagnostic, message.empty()
                                  ? "invalid wave.expr text"
                                  : "invalid wave.expr text: " + message);
    return failure();
  }
  return ExprHandle(node);
}

FailureOr<PredHandle> mlir::wave::sym::parsePred(Store &store,
                                                 llvm::StringRef text,
                                                 std::string *diagnostic) {
  std::string nulTerminated(text);
  Session session(store);
  const ixs_node *node = ixs_parse_pred(session.raw(), nulTerminated.c_str(),
                                        nulTerminated.size());
  if (!node) {
    setDiagnostic(diagnostic, "out of memory parsing wave.pred");
    return failure();
  }
  if (!ixs_node_is_pred(node)) {
    std::string message = joinSessionErrors(session.raw());
    setDiagnostic(diagnostic, message.empty()
                                  ? "invalid wave.pred text"
                                  : "invalid wave.pred text: " + message);
    return failure();
  }
  return PredHandle(node);
}

FailureOr<ExprHandle>
mlir::wave::sym::deserializeExpr(Store &store, ArrayRef<uint8_t> bytes,
                                 std::string *diagnostic) {
  Session session(store);
  BufferReaderState state{bytes, 0};
  ixs_reader reader{bufferReaderRead, bufferReaderRemaining, &state};
  return finishExpr(session.raw(), ixs_deserialize_node(session.raw(), &reader),
                    diagnostic, "failed to deserialize wave.expr bytes");
}

FailureOr<PredHandle>
mlir::wave::sym::deserializePred(Store &store, ArrayRef<uint8_t> bytes,
                                 std::string *diagnostic) {
  Session session(store);
  BufferReaderState state{bytes, 0};
  ixs_reader reader{bufferReaderRead, bufferReaderRemaining, &state};
  return finishPred(session.raw(), ixs_deserialize_node(session.raw(), &reader),
                    diagnostic, "failed to deserialize wave.pred bytes");
}

FailureOr<ExprHandle> mlir::wave::sym::importExpr(Store &store,
                                                  const ixs_node *foreign,
                                                  std::string *diagnostic) {
  if (!foreign) {
    setDiagnostic(diagnostic, "cannot import null wave.expr node");
    return failure();
  }
  if (!ixs_node_is_expr(foreign)) {
    setDiagnostic(diagnostic, "expected expression node for wave.expr");
    return failure();
  }

  Session session(store);
  const ixs_node *node = ixs_import_node(session.raw(), foreign);
  if (!node) {
    setDiagnostic(diagnostic, "out of memory importing wave.expr");
    return failure();
  }
  return ExprHandle(node);
}

FailureOr<ExprHandle>
mlir::wave::sym::importExprFromNodePtr(Store &store, uintptr_t nodePtr,
                                       std::string *diagnostic) {
  const ixs_node *node = reinterpret_cast<const ixs_node *>(nodePtr);
  return importExpr(store, node, diagnostic);
}

FailureOr<PredHandle>
mlir::wave::sym::importPredFromNodePtr(Store &store, uintptr_t nodePtr,
                                       std::string *diagnostic) {
  const ixs_node *node = reinterpret_cast<const ixs_node *>(nodePtr);
  return importPred(store, node, diagnostic);
}

FailureOr<PredHandle> mlir::wave::sym::importPred(Store &store,
                                                  const ixs_node *foreign,
                                                  std::string *diagnostic) {
  if (!foreign) {
    setDiagnostic(diagnostic, "cannot import null wave.pred node");
    return failure();
  }
  if (!ixs_node_is_pred(foreign)) {
    setDiagnostic(diagnostic, "expected predicate node for wave.pred");
    return failure();
  }

  Session session(store);
  const ixs_node *node = ixs_import_node(session.raw(), foreign);
  if (!node) {
    setDiagnostic(diagnostic, "out of memory importing wave.pred");
    return failure();
  }
  return PredHandle(node);
}

FailureOr<ExprHandle>
mlir::wave::sym::composeExprBinary(Store &store, ExprHandle lhsHandle,
                                   ExprBinaryOp op, ExprHandle rhsHandle,
                                   std::string *diagnostic) {
  Session session(store);
  const ixs_node *lhs = rawExprNode(lhsHandle, diagnostic);
  const ixs_node *rhs = rawExprNode(rhsHandle, diagnostic);
  if (!lhs || !rhs)
    return failure();
  const ixs_node *node = composeRawBinary(session.raw(), lhs, op, rhs);
  return finishExpr(session.raw(), node, diagnostic,
                    "failed to compose wave.expr");
}

FailureOr<ExprHandle>
mlir::wave::sym::composeExprCeil(Store &store, ExprHandle valueHandle,
                                 std::string *diagnostic) {
  Session session(store);
  const ixs_node *value = rawExprNode(valueHandle, diagnostic);
  if (!value)
    return failure();
  return finishExpr(session.raw(), ixs_ceil(session.raw(), value), diagnostic,
                    "failed to compose wave.expr");
}

FailureOr<ExprHandle>
mlir::wave::sym::composeExprFloor(Store &store, ExprHandle valueHandle,
                                  std::string *diagnostic) {
  Session session(store);
  const ixs_node *value = rawExprNode(valueHandle, diagnostic);
  if (!value)
    return failure();
  return finishExpr(session.raw(), ixs_floor(session.raw(), value), diagnostic,
                    "failed to compose wave.expr");
}

FailureOr<ExprHandle> mlir::wave::sym::composeExprNeg(Store &store,
                                                      ExprHandle valueHandle,
                                                      std::string *diagnostic) {
  Session session(store);
  const ixs_node *value = rawExprNode(valueHandle, diagnostic);
  if (!value)
    return failure();
  return finishExpr(session.raw(), ixs_neg(session.raw(), value), diagnostic,
                    "failed to compose wave.expr");
}

FailureOr<ExprHandle> mlir::wave::sym::composeExprSym(Store &store,
                                                      llvm::StringRef name,
                                                      std::string *diagnostic) {
  // ixs_sym needs NUL-terminated buffer.
  std::string nulTerminated(name);
  Session session(store);
  const ixs_node *node = ixs_sym(session.raw(), nulTerminated.c_str());
  return finishExpr(session.raw(), node, diagnostic,
                    "failed to construct wave.expr symbol");
}

FailureOr<ExprHandle> mlir::wave::sym::composeExprInt(Store &store,
                                                      int64_t value,
                                                      std::string *diagnostic) {
  Session session(store);
  const ixs_node *node = ixs_int(session.raw(), value);
  return finishExpr(session.raw(), node, diagnostic,
                    "failed to construct wave.expr integer literal");
}

FailureOr<ExprHandle> mlir::wave::sym::composeExprPiecewise(
    Store &store, ArrayRef<PiecewiseCase> cases, std::string *diagnostic) {
  if (cases.empty()) {
    setDiagnostic(diagnostic, "wave.expr piecewise needs at least one case");
    return failure();
  }

  Session session(store);
  SmallVector<const ixs_node *, 4> values;
  SmallVector<const ixs_node *, 4> conditions;
  values.reserve(cases.size());
  conditions.reserve(cases.size());
  for (PiecewiseCase piece : cases) {
    const ixs_node *value = rawExprNode(piece.value, diagnostic);
    const ixs_node *condition = rawPredNode(piece.condition, diagnostic);
    if (!value || !condition)
      return failure();
    values.push_back(value);
    conditions.push_back(condition);
  }
  uint32_t count = static_cast<uint32_t>(values.size());
  return finishExpr(
      session.raw(),
      ixs_pw(session.raw(), count, values.data(), conditions.data()),
      diagnostic, "failed to compose wave.expr piecewise");
}

FailureOr<PredHandle>
mlir::wave::sym::composePredTrue(Store &store, std::string *diagnostic) {
  Session session(store);
  return finishPred(session.raw(), ixs_true(session.raw()), diagnostic,
                    "failed to compose wave.pred true");
}

FailureOr<PredHandle>
mlir::wave::sym::composePredFalse(Store &store, std::string *diagnostic) {
  Session session(store);
  return finishPred(session.raw(), ixs_false(session.raw()), diagnostic,
                    "failed to compose wave.pred false");
}

FailureOr<PredHandle> mlir::wave::sym::composePredCmp(Store &store,
                                                      ExprHandle lhsHandle,
                                                      PredCmpOp op,
                                                      ExprHandle rhsHandle,
                                                      std::string *diagnostic) {
  Session session(store);
  const ixs_node *lhs = rawExprNode(lhsHandle, diagnostic);
  const ixs_node *rhs = rawExprNode(rhsHandle, diagnostic);
  if (!lhs || !rhs)
    return failure();

  ixs_cmp_op cmp = IXS_CMP_EQ;
  switch (op) {
  case PredCmpOp::Lt:
    cmp = IXS_CMP_LT;
    break;
  case PredCmpOp::Le:
    cmp = IXS_CMP_LE;
    break;
  case PredCmpOp::Gt:
    cmp = IXS_CMP_GT;
    break;
  case PredCmpOp::Ge:
    cmp = IXS_CMP_GE;
    break;
  case PredCmpOp::Eq:
    cmp = IXS_CMP_EQ;
    break;
  case PredCmpOp::Ne:
    cmp = IXS_CMP_NE;
    break;
  }
  return finishPred(session.raw(), ixs_cmp(session.raw(), lhs, cmp, rhs),
                    diagnostic, "failed to compose wave.pred");
}

mlir::FailureOr<PredHandle>
mlir::wave::sym::composePredAnd(Store &store, PredHandle lhsHandle,
                                PredHandle rhsHandle, std::string *diagnostic) {
  Session session(store);
  const ixs_node *lhs = rawPredNode(lhsHandle, diagnostic);
  const ixs_node *rhs = rawPredNode(rhsHandle, diagnostic);
  if (!lhs || !rhs)
    return failure();
  return finishPred(session.raw(), ixs_and(session.raw(), lhs, rhs), diagnostic,
                    "failed to compose wave.pred AND");
}

mlir::FailureOr<PredHandle>
mlir::wave::sym::composePredOr(Store &store, PredHandle lhsHandle,
                               PredHandle rhsHandle, std::string *diagnostic) {
  Session session(store);
  const ixs_node *lhs = rawPredNode(lhsHandle, diagnostic);
  const ixs_node *rhs = rawPredNode(rhsHandle, diagnostic);
  if (!lhs || !rhs)
    return failure();
  return finishPred(session.raw(), ixs_or(session.raw(), lhs, rhs), diagnostic,
                    "failed to compose wave.pred OR");
}

mlir::FailureOr<PredHandle>
mlir::wave::sym::composePredNot(Store &store, PredHandle valueHandle,
                                std::string *diagnostic) {
  Session session(store);
  const ixs_node *value = rawPredNode(valueHandle, diagnostic);
  if (!value)
    return failure();
  return finishPred(session.raw(), ixs_not(session.raw(), value), diagnostic,
                    "failed to compose wave.pred NOT");
}

FailureOr<ExprHandle> mlir::wave::sym::simplifyExpr(Store &store,
                                                    ExprHandle value,
                                                    std::string *diagnostic) {
  Session session(store);
  const ixs_node *expr = rawExprNode(value, diagnostic);
  if (!expr)
    return failure();
  const ixs_node *simplified =
      ixs_simplify(session.raw(), expr, /*assumptions=*/nullptr, 0);
  return finishExpr(session.raw(), simplified, diagnostic,
                    "failed to simplify wave.expr");
}

FailureOr<PredHandle> mlir::wave::sym::simplifyPred(Store &store,
                                                    PredHandle value,
                                                    std::string *diagnostic) {
  Session session(store);
  const ixs_node *pred = rawPredNode(value, diagnostic);
  if (!pred)
    return failure();
  const ixs_node *simplified =
      ixs_simplify(session.raw(), pred, /*assumptions=*/nullptr, 0);
  return finishPred(session.raw(), simplified, diagnostic,
                    "failed to simplify wave.pred");
}

FailureOr<ExprHandle>
mlir::wave::sym::substituteExpr(Store &store, ExprHandle value,
                                ArrayRef<ExprSubstitution> substitutions,
                                std::string *diagnostic) {
  Session session(store);
  const ixs_node *expr = rawExprNode(value, diagnostic);
  if (!expr)
    return failure();

  SmallVector<const ixs_node *, 4> targets;
  SmallVector<const ixs_node *, 4> replacements;
  targets.reserve(substitutions.size());
  replacements.reserve(substitutions.size());
  for (const ExprSubstitution &substitution : substitutions) {
    const ixs_node *target = rawExprNode(substitution.target, diagnostic);
    const ixs_node *replacement =
        rawExprNode(substitution.replacement, diagnostic);
    if (!target || !replacement)
      return failure();
    targets.push_back(target);
    replacements.push_back(replacement);
  }

  if (targets.size() > std::numeric_limits<uint32_t>::max()) {
    setDiagnostic(diagnostic, "too many wave.expr substitutions");
    return failure();
  }
  const ixs_node *result =
      ixs_subs_multi(session.raw(), expr, static_cast<uint32_t>(targets.size()),
                     targets.data(), replacements.data());
  return finishExpr(session.raw(), result, diagnostic,
                    "failed to substitute wave.expr");
}

FailureOr<PredHandle>
mlir::wave::sym::substitutePred(Store &store, PredHandle value,
                                ArrayRef<ExprSubstitution> substitutions,
                                std::string *diagnostic) {
  Session session(store);
  const ixs_node *pred = rawPredNode(value, diagnostic);
  if (!pred)
    return failure();

  SmallVector<const ixs_node *, 4> targets;
  SmallVector<const ixs_node *, 4> replacements;
  targets.reserve(substitutions.size());
  replacements.reserve(substitutions.size());
  for (const ExprSubstitution &substitution : substitutions) {
    const ixs_node *target = rawExprNode(substitution.target, diagnostic);
    const ixs_node *replacement =
        rawExprNode(substitution.replacement, diagnostic);
    if (!target || !replacement)
      return failure();
    targets.push_back(target);
    replacements.push_back(replacement);
  }

  if (targets.size() > std::numeric_limits<uint32_t>::max()) {
    setDiagnostic(diagnostic, "too many wave.pred substitutions");
    return failure();
  }
  const ixs_node *result =
      ixs_subs_multi(session.raw(), pred, static_cast<uint32_t>(targets.size()),
                     targets.data(), replacements.data());
  return finishPred(session.raw(), result, diagnostic,
                    "failed to substitute wave.pred");
}

int mlir::wave::sym::compareEndpointToInteger(RationalEndpoint value,
                                              int64_t integer) {
  assert(value.denominator > 0 && "expected positive denominator");
  __int128 lhs = static_cast<__int128>(value.numerator);
  __int128 rhs =
      static_cast<__int128>(integer) * static_cast<__int128>(value.denominator);
  if (lhs < rhs)
    return -1;
  if (lhs > rhs)
    return 1;
  return 0;
}

std::optional<int64_t> mlir::wave::sym::floorEndpoint(RationalEndpoint value) {
  if (value.denominator <= 0)
    return std::nullopt;
  int64_t quotient = value.numerator / value.denominator;
  int64_t remainder = value.numerator % value.denominator;
  if (remainder != 0 && value.numerator < 0)
    --quotient;
  return quotient;
}

std::optional<int64_t> mlir::wave::sym::ceilEndpoint(RationalEndpoint value) {
  if (value.denominator <= 0)
    return std::nullopt;
  int64_t quotient = value.numerator / value.denominator;
  int64_t remainder = value.numerator % value.denominator;
  if (remainder != 0 && value.numerator > 0)
    ++quotient;
  return quotient;
}

FailureOr<ExprHandle>
mlir::wave::sym::simplifyExpr(Store &store, ExprHandle value,
                              ArrayRef<PredHandle> assumptions,
                              std::string *diagnostic) {
  Session session(store);
  const ixs_node *expr = rawExprNode(value, diagnostic);
  if (!expr)
    return failure();
  SmallVector<const ixs_node *, 4> rawAssumptions;
  for (PredHandle assumption : assumptions) {
    const ixs_node *raw = rawPredNode(assumption, diagnostic);
    if (!raw)
      return failure();
    rawAssumptions.push_back(raw);
  }
  const ixs_node *simplified = ixs_simplify(
      session.raw(), expr, rawAssumptions.data(), rawAssumptions.size());
  return finishExpr(session.raw(), simplified, diagnostic,
                    "failed to simplify wave.expr");
}

FailureOr<ExprHandle> mlir::wave::sym::expandExpr(Store &store,
                                                  ExprHandle value,
                                                  std::string *diagnostic) {
  Session session(store);
  const ixs_node *expr = rawExprNode(value, diagnostic);
  if (!expr)
    return failure();
  return finishExpr(session.raw(), ixs_expand(session.raw(), expr), diagnostic,
                    "failed to expand wave.expr");
}

mlir::wave::sym::CheckResult
mlir::wave::sym::checkPredicate(Store &store, PredHandle predicate,
                                ArrayRef<PredHandle> assumptions) {
  FailureOr<std::unique_ptr<Analysis>> analysis =
      Analysis::create(store, assumptions);
  return succeeded(analysis) ? (*analysis)->check(predicate)
                             : CheckResult::Unknown;
}

bool mlir::wave::sym::provablyDefined(Store &store, ExprHandle expr,
                                      ArrayRef<PredHandle> assumptions) {
  FailureOr<std::unique_ptr<Analysis>> analysis =
      Analysis::create(store, assumptions);
  return succeeded(analysis) && (*analysis)->defined(expr) == CheckResult::True;
}

bool mlir::wave::sym::provablyDefined(Store &store, PredHandle pred,
                                      ArrayRef<PredHandle> assumptions) {
  FailureOr<std::unique_ptr<Analysis>> analysis =
      Analysis::create(store, assumptions);
  return succeeded(analysis) && (*analysis)->defined(pred) == CheckResult::True;
}

mlir::wave::sym::Pow2Fact
mlir::wave::sym::getPow2Fact(Store &store, ExprHandle expr,
                             ArrayRef<PredHandle> assumptions) {
  Session session(store);
  const ixs_node *rawExpr = rawExprNode(expr, /*diagnostic=*/nullptr);
  if (!rawExpr)
    return Pow2Fact::Unknown;
  SmallVector<const ixs_node *, 4> rawAssumptions;
  for (PredHandle assumption : assumptions) {
    const ixs_node *raw = rawPredNode(assumption, /*diagnostic=*/nullptr);
    if (!raw)
      return Pow2Fact::Unknown;
    rawAssumptions.push_back(raw);
  }
  return convertPow2Fact(ixs_get_pow2_fact(
      session.raw(), rawExpr, rawAssumptions.data(), rawAssumptions.size()));
}

FailureOr<PredHandle>
mlir::wave::sym::rangeAssumption(Store &store, StringRef name, int64_t lo,
                                 int64_t hi, std::string *diagnostic) {
  auto sym = composeExprSym(store, name, diagnostic);
  auto loConst = composeExprInt(store, lo, diagnostic);
  auto hiConst = composeExprInt(store, hi, diagnostic);
  if (failed(sym) || failed(loConst) || failed(hiConst))
    return failure();
  auto geLo = composePredCmp(store, *sym, PredCmpOp::Ge, *loConst, diagnostic);
  auto leHi = composePredCmp(store, *sym, PredCmpOp::Le, *hiConst, diagnostic);
  if (failed(geLo) || failed(leHi))
    return failure();
  return composePredAnd(store, *geLo, *leHi, diagnostic);
}

static std::optional<uint64_t> checkedAddU32Bound(uint64_t lhs, uint64_t rhs) {
  constexpr uint64_t u32Max = (uint64_t{1} << 32) - 1;
  if (lhs > u32Max || rhs > u32Max || lhs > u32Max - rhs)
    return std::nullopt;
  return lhs + rhs;
}

static std::optional<uint64_t> checkedMulU32Bound(uint64_t lhs, uint64_t rhs) {
  constexpr uint64_t u32Max = (uint64_t{1} << 32) - 1;
  if (lhs != 0 && rhs > u32Max / lhs)
    return std::nullopt;
  return lhs * rhs;
}

static std::optional<uint64_t> positiveAddendU32UpperBound(Analysis &analysis,
                                                           AddTerm addTerm) {
  std::optional<int64_t> coeff =
      sym::getIntegerLiteralValue(addTerm.coefficient);
  if (!coeff)
    return std::nullopt;
  if (*coeff <= 0)
    return uint64_t{0};
  std::optional<InferredRange> range = analysis.range(addTerm.term);
  if (!range || !range->upper)
    return std::nullopt;
  std::optional<int64_t> upper = ceilEndpoint(*range->upper);
  if (!upper)
    return std::nullopt;
  if (*upper <= 0)
    return uint64_t{0};
  return checkedMulU32Bound(static_cast<uint64_t>(*coeff),
                            static_cast<uint64_t>(*upper));
}

static std::optional<uint64_t> positiveAddendsU32UpperBound(Analysis &analysis,
                                                            ExprHandle expr) {
  uint64_t bound = 0;
  ExprView view(expr);
  std::optional<int64_t> constant =
      sym::getIntegerLiteralValue(view.getAddConstant());
  if (!constant)
    return std::nullopt;
  if (*constant > 0)
    bound = static_cast<uint64_t>(*constant);

  for (uint32_t index : llvm::seq<uint32_t>(0, view.getAddTermCount())) {
    std::optional<uint64_t> addend =
        positiveAddendU32UpperBound(analysis, view.getAddTerm(index));
    if (!addend)
      return std::nullopt;
    if (*addend == 0)
      continue;
    std::optional<uint64_t> next = checkedAddU32Bound(bound, *addend);
    if (!next)
      return std::nullopt;
    bound = *next;
  }
  return bound;
}

static bool inferredRangeWithin(Analysis &analysis, ExprHandle expr,
                                int64_t lower, int64_t upper) {
  std::optional<InferredRange> range = analysis.range(expr);
  return range && range->lower && range->upper &&
         compareEndpointToInteger(*range->lower, lower) >= 0 &&
         compareEndpointToInteger(*range->upper, upper) <= 0;
}

static bool proveRangePredicates(Analysis &analysis, ExprHandle expr,
                                 int64_t lower, int64_t upper) {
  FailureOr<ExprHandle> lowerExpr = analysis.composeInteger(lower);
  FailureOr<ExprHandle> upperExpr = analysis.composeInteger(upper);
  if (failed(lowerExpr) || failed(upperExpr))
    return false;
  FailureOr<PredHandle> lowerBound =
      analysis.compare(expr, PredCmpOp::Ge, *lowerExpr);
  FailureOr<PredHandle> upperBound =
      analysis.compare(expr, PredCmpOp::Le, *upperExpr);
  return succeeded(lowerBound) && succeeded(upperBound) &&
         analysis.check(*lowerBound) == CheckResult::True &&
         analysis.check(*upperBound) == CheckResult::True;
}

bool mlir::wave::sym::provablyInRange(Analysis &analysis, ExprHandle expr,
                                      int64_t lower, int64_t upper) {
  return inferredRangeWithin(analysis, expr, lower, upper) ||
         proveRangePredicates(analysis, expr, lower, upper);
}

bool mlir::wave::sym::provablyInRange(Store &store, ExprHandle expr,
                                      ArrayRef<PredHandle> assumptions,
                                      int64_t lo, int64_t hi) {
  FailureOr<std::unique_ptr<Analysis>> analysis =
      Analysis::create(store, assumptions);
  return succeeded(analysis) && provablyInRange(**analysis, expr, lo, hi);
}

bool mlir::wave::sym::provablyFitsU32(Store &store, ExprHandle expr,
                                      ArrayRef<PredHandle> assumptions) {
  FailureOr<std::unique_ptr<Analysis>> analysis =
      Analysis::create(store, assumptions);
  return succeeded(analysis) &&
         provablyInRange(**analysis, expr, 0, (int64_t{1} << 32) - 1);
}

bool mlir::wave::sym::positiveAddendsFitU32(Store &store, ExprHandle expr,
                                            ArrayRef<PredHandle> assumptions) {
  if (ExprView(expr).getKind() != ExprKind::Add)
    return false;
  FailureOr<std::unique_ptr<Analysis>> analysis =
      Analysis::create(store, assumptions);
  if (failed(analysis))
    return false;
  if (std::optional<uint64_t> bound =
          positiveAddendsU32UpperBound(**analysis, expr))
    return *bound <= (uint64_t{1} << 32) - 1;
  return false;
}

std::optional<InferredRange>
mlir::wave::sym::inferRange(Store &store, ExprHandle expr,
                            ArrayRef<PredHandle> assumptions) {
  Session session(store);
  const ixs_node *rawExpr = rawExprNode(expr, /*diagnostic=*/nullptr);
  if (!rawExpr)
    return std::nullopt;
  SmallVector<const ixs_node *, 4> rawAssumptions;
  for (PredHandle assumption : assumptions) {
    const ixs_node *raw = rawPredNode(assumption, /*diagnostic=*/nullptr);
    if (!raw)
      return std::nullopt;
    rawAssumptions.push_back(raw);
  }
  ixs_range_result rawRange;
  if (!ixs_range(session.raw(), rawExpr, rawAssumptions.data(),
                 rawAssumptions.size(), &rawRange))
    return std::nullopt;
  return convertRange(rawRange);
}

std::optional<int64_t>
mlir::wave::sym::inferNonNegativeUpperBound(Store &store, ExprHandle expr,
                                            ArrayRef<PredHandle> assumptions,
                                            int64_t maxUpper) {
  std::optional<InferredRange> range = inferRange(store, expr, assumptions);
  if (!range || !range->lower || !range->upper)
    return std::nullopt;
  if (compareEndpointToInteger(*range->lower, 0) < 0 ||
      compareEndpointToInteger(*range->upper, maxUpper) > 0)
    return std::nullopt;
  return ceilEndpoint(*range->upper);
}

std::optional<int64_t>
mlir::wave::sym::getIntegerLiteralValue(ExprHandle value) {
  ExprView view(value);
  if (std::optional<int64_t> integer = view.getInt())
    return integer;
  std::optional<RationalLiteral> rational = view.getRational();
  if (rational && rational->denominator == 1)
    return rational->numerator;
  return std::nullopt;
}

void mlir::wave::sym::walkSymbolNames(
    ExprHandle value, llvm::function_ref<void(llvm::StringRef)> callback) {
  walkSymbolNamesImpl(value.raw(), callback);
}

void mlir::wave::sym::walkSymbolNames(
    PredHandle value, llvm::function_ref<void(llvm::StringRef)> callback) {
  walkSymbolNamesImpl(value.raw(), callback);
}

FailureOr<ExprHandle> mlir::wave::sym::parseExprHandle(AsmParser &parser) {
  std::string text;
  llvm::SMLoc loc = parser.getCurrentLocation();
  if (parser.parseString(&text))
    return failure();

  std::string diagnostic;
  FailureOr<ExprHandle> handle = parseExpr(
      getWaveDialect(parser.getContext()).getSymbolStore(), text, &diagnostic);
  if (failed(handle)) {
    parser.emitError(loc, diagnostic.empty() ? "invalid wave.expr text"
                                             : diagnostic);
    return failure();
  }
  return *handle;
}

FailureOr<PredHandle> mlir::wave::sym::parsePredHandle(AsmParser &parser) {
  std::string text;
  llvm::SMLoc loc = parser.getCurrentLocation();
  if (parser.parseString(&text))
    return failure();

  std::string diagnostic;
  FailureOr<PredHandle> handle = parsePred(
      getWaveDialect(parser.getContext()).getSymbolStore(), text, &diagnostic);
  if (failed(handle)) {
    parser.emitError(loc, diagnostic.empty() ? "invalid wave.pred text"
                                             : diagnostic);
    return failure();
  }
  return *handle;
}

void mlir::wave::sym::printExprHandle(AsmPrinter &printer, ExprHandle value) {
  // No Store& at ODS hook; node is immutable, skip dialect lookup + lock.
  printer.printString(renderNode(value.raw()));
}

void mlir::wave::sym::printPredHandle(AsmPrinter &printer, PredHandle value) {
  printer.printString(renderNode(value.raw()));
}
