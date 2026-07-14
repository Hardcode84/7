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
#include "llvm/ADT/SmallVector.h"
#include "llvm/Support/CheckedArithmetic.h"
#include "llvm/Support/ErrorHandling.h"
#include "llvm/Support/MathExtras.h"
#include "llvm/Support/raw_ostream.h"

#include <array>
#include <cassert>
#include <cstring>
#include <limits>
#include <numeric>
#include <utility>

using namespace mlir;
using namespace mlir::wave;
using namespace mlir::wave::sym;

namespace {

static ixs_node *mutableNode(const ixs_node *node) {
  return const_cast<ixs_node *>(node);
}

static ExprKind getExprKind(ixs_tag tag) {
  static_assert(IXS_CMP == 12 && IXS_NOT == 15 && IXS_PARSE_ERROR == 17,
                "update ixs_tag mappings");
  static constexpr std::array<ExprKind, IXS_PARSE_ERROR + 1> kindByTag = {
      ExprKind::Integer, ExprKind::Rational, ExprKind::Symbol,
      ExprKind::Add,     ExprKind::Mul,      ExprKind::Floor,
      ExprKind::Ceil,    ExprKind::Mod,      ExprKind::Piecewise,
      ExprKind::Max,     ExprKind::Min,      ExprKind::Xor,
      ExprKind::Invalid, ExprKind::Invalid,  ExprKind::Invalid,
      ExprKind::Invalid, ExprKind::Error,    ExprKind::ParseError,
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

static std::optional<int64_t> checkedLCM(std::optional<int64_t> lhs,
                                         std::optional<int64_t> rhs) {
  if (!lhs || !rhs)
    return std::nullopt;
  int64_t gcd = std::gcd(*lhs, *rhs);
  return llvm::checkedMul(*lhs / gcd, *rhs);
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
  size_t n = ixs_print(mutableNode(node), nullptr, 0);
  if (n == std::numeric_limits<size_t>::max())
    llvm::report_fatal_error(
        "wave symbolic printer reported an invalid length");
  std::string text(n + 1, '\0');
  ixs_print(mutableNode(node), text.data(), text.size());
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

static ixs_node *rawExprNode(ExprHandle value, std::string *diagnostic) {
  if (!value) {
    setDiagnostic(diagnostic, "expected non-null wave.expr");
    return nullptr;
  }
  ixs_node *node = mutableNode(value.raw());
  if (!ixs_node_is_expr(node)) {
    setDiagnostic(diagnostic, "expected wave.expr node");
    return nullptr;
  }
  return node;
}

static ixs_node *rawPredNode(PredHandle value, std::string *diagnostic) {
  if (!value) {
    setDiagnostic(diagnostic, "expected non-null wave.pred");
    return nullptr;
  }
  ixs_node *node = mutableNode(value.raw());
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
    // ixsimpl introspection accessors are read-only but C API lacks const.
    ixs_node *rawNode = mutableNode(current);
    if (ixs_node_tag(rawNode) == IXS_SYM)
      callback(ixs_node_sym_name(rawNode));

    for (uint32_t index = ixs_node_nchildren(rawNode); index > 0; --index)
      stack.push_back(ixs_node_child(rawNode, index - 1));
  }
}

static FailureOr<ExprHandle> finishExpr(ixs_session *session, ixs_node *node,
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

static FailureOr<PredHandle> finishPred(ixs_session *session, ixs_node *node,
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

} // namespace

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

bool mlir::wave::sym::isExpr(ExprHandle value) {
  return value && ixs_node_is_expr(value.raw());
}

bool mlir::wave::sym::isPred(PredHandle value) {
  return value && ixs_node_is_pred(value.raw());
}

bool ExprView::isValid() const { return isExpr(value); }

ExprKind ExprView::getKind() const {
  if (!value)
    return ExprKind::Invalid;
  return getExprKind(ixs_node_tag(mutableNode(value.raw())));
}

std::optional<int64_t> ExprView::getInt() const {
  if (getKind() != ExprKind::Integer)
    return std::nullopt;
  return ixs_node_int_val(mutableNode(value.raw()));
}

std::optional<RationalLiteral> ExprView::getRational() const {
  if (getKind() != ExprKind::Rational)
    return std::nullopt;
  ixs_node *node = mutableNode(value.raw());
  return RationalLiteral{ixs_node_rat_num(node), ixs_node_rat_den(node)};
}

StringRef ExprView::getSymbolName() const {
  if (getKind() != ExprKind::Symbol)
    return {};
  return ixs_node_sym_name(mutableNode(value.raw()));
}

ExprHandle ExprView::getAddConstant() const {
  if (getKind() != ExprKind::Add)
    return {};
  return ExprHandle(ixs_node_add_coeff(mutableNode(value.raw())));
}

uint32_t ExprView::getAddTermCount() const {
  if (getKind() != ExprKind::Add)
    return 0;
  return ixs_node_add_nterms(mutableNode(value.raw()));
}

AddTerm ExprView::getAddTerm(uint32_t index) const {
  if (getKind() != ExprKind::Add)
    return {};
  ixs_node *node = mutableNode(value.raw());
  if (index >= ixs_node_add_nterms(node))
    return {};
  return AddTerm{ExprHandle(ixs_node_add_term_coeff(node, index)),
                 ExprHandle(ixs_node_add_term(node, index))};
}

ExprHandle ExprView::getMulCoefficient() const {
  if (getKind() != ExprKind::Mul)
    return {};
  return ExprHandle(ixs_node_mul_coeff(mutableNode(value.raw())));
}

uint32_t ExprView::getMulFactorCount() const {
  if (getKind() != ExprKind::Mul)
    return 0;
  return ixs_node_mul_nfactors(mutableNode(value.raw()));
}

MulFactor ExprView::getMulFactor(uint32_t index) const {
  if (getKind() != ExprKind::Mul)
    return {};
  ixs_node *node = mutableNode(value.raw());
  if (index >= ixs_node_mul_nfactors(node))
    return {};
  return MulFactor{ExprHandle(ixs_node_mul_factor_base(node, index)),
                   ixs_node_mul_factor_exp(node, index)};
}

ExprHandle ExprView::getUnaryArg() const {
  ExprKind kind = getKind();
  if (kind != ExprKind::Floor && kind != ExprKind::Ceil)
    return {};
  return ExprHandle(ixs_node_unary_arg(mutableNode(value.raw())));
}

ExprHandle ExprView::getBinaryLhs() const {
  ExprKind kind = getKind();
  if (kind != ExprKind::Mod && kind != ExprKind::Max && kind != ExprKind::Min &&
      kind != ExprKind::Xor)
    return {};
  return ExprHandle(ixs_node_binary_lhs(mutableNode(value.raw())));
}

ExprHandle ExprView::getBinaryRhs() const {
  ExprKind kind = getKind();
  if (kind != ExprKind::Mod && kind != ExprKind::Max && kind != ExprKind::Min &&
      kind != ExprKind::Xor)
    return {};
  return ExprHandle(ixs_node_binary_rhs(mutableNode(value.raw())));
}

uint32_t ExprView::getPiecewiseCaseCount() const {
  if (getKind() != ExprKind::Piecewise)
    return 0;
  return ixs_node_pw_ncases(mutableNode(value.raw()));
}

PiecewiseCase ExprView::getPiecewiseCase(uint32_t index) const {
  if (getKind() != ExprKind::Piecewise)
    return {};
  ixs_node *node = mutableNode(value.raw());
  if (index >= ixs_node_pw_ncases(node))
    return {};
  return PiecewiseCase{ExprHandle(ixs_node_pw_value(node, index)),
                       PredHandle(ixs_node_pw_cond(node, index))};
}

bool PredView::isValid() const { return isPred(value); }

PredKind PredView::getKind() const {
  if (!value)
    return PredKind::Invalid;
  ixs_node *node = mutableNode(value.raw());
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
  return getPredCmpOp(ixs_node_cmp_op(mutableNode(value.raw())));
}

ExprHandle PredView::getCmpLhs() const {
  if (getKind() != PredKind::Cmp)
    return {};
  return ExprHandle(ixs_node_binary_lhs(mutableNode(value.raw())));
}

ExprHandle PredView::getCmpRhs() const {
  if (getKind() != PredKind::Cmp)
    return {};
  return ExprHandle(ixs_node_binary_rhs(mutableNode(value.raw())));
}

PredHandle PredView::getUnaryArg() const {
  if (getKind() != PredKind::Not)
    return {};
  return PredHandle(ixs_node_unary_arg(mutableNode(value.raw())));
}

uint32_t PredView::getLogicArgCount() const {
  PredKind kind = getKind();
  if (kind != PredKind::And && kind != PredKind::Or)
    return 0;
  return ixs_node_logic_nargs(mutableNode(value.raw()));
}

PredHandle PredView::getLogicArg(uint32_t index) const {
  PredKind kind = getKind();
  if (kind != PredKind::And && kind != PredKind::Or)
    return {};
  ixs_node *node = mutableNode(value.raw());
  if (index >= ixs_node_logic_nargs(node))
    return {};
  return PredHandle(ixs_node_logic_arg(node, index));
}

FailureOr<ExprHandle> mlir::wave::sym::parseExpr(Store &store,
                                                 llvm::StringRef text,
                                                 std::string *diagnostic) {
  std::string nulTerminated(text);
  Session session(store);
  ixs_node *node = ixs_parse_expr(session.raw(), nulTerminated.c_str(),
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
  ixs_node *node = ixs_parse_pred(session.raw(), nulTerminated.c_str(),
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
  ixs_node *node = ixs_import_node(session.raw(), foreign);
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
  ixs_node *node = ixs_import_node(session.raw(), foreign);
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
  ixs_node *lhs = rawExprNode(lhsHandle, diagnostic);
  ixs_node *rhs = rawExprNode(rhsHandle, diagnostic);
  if (!lhs || !rhs)
    return failure();

  ixs_node *node = nullptr;
  switch (op) {
  case ExprBinaryOp::Add:
    node = ixs_add(session.raw(), lhs, rhs);
    break;
  case ExprBinaryOp::Sub:
    node = ixs_sub(session.raw(), lhs, rhs);
    break;
  case ExprBinaryOp::Mul:
    node = ixs_mul(session.raw(), lhs, rhs);
    break;
  case ExprBinaryOp::Div:
    node = ixs_div(session.raw(), lhs, rhs);
    break;
  case ExprBinaryOp::Mod:
    node = ixs_mod(session.raw(), lhs, rhs);
    break;
  case ExprBinaryOp::Xor:
    node = ixs_xor(session.raw(), lhs, rhs);
    break;
  }
  return finishExpr(session.raw(), node, diagnostic,
                    "failed to compose wave.expr");
}

FailureOr<ExprHandle>
mlir::wave::sym::composeExprCeil(Store &store, ExprHandle valueHandle,
                                 std::string *diagnostic) {
  Session session(store);
  ixs_node *value = rawExprNode(valueHandle, diagnostic);
  if (!value)
    return failure();
  return finishExpr(session.raw(), ixs_ceil(session.raw(), value), diagnostic,
                    "failed to compose wave.expr");
}

FailureOr<ExprHandle>
mlir::wave::sym::composeExprFloor(Store &store, ExprHandle valueHandle,
                                  std::string *diagnostic) {
  Session session(store);
  ixs_node *value = rawExprNode(valueHandle, diagnostic);
  if (!value)
    return failure();
  return finishExpr(session.raw(), ixs_floor(session.raw(), value), diagnostic,
                    "failed to compose wave.expr");
}

FailureOr<ExprHandle> mlir::wave::sym::composeExprNeg(Store &store,
                                                      ExprHandle valueHandle,
                                                      std::string *diagnostic) {
  Session session(store);
  ixs_node *value = rawExprNode(valueHandle, diagnostic);
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
  ixs_node *node = ixs_sym(session.raw(), nulTerminated.c_str());
  return finishExpr(session.raw(), node, diagnostic,
                    "failed to construct wave.expr symbol");
}

FailureOr<ExprHandle> mlir::wave::sym::composeExprInt(Store &store,
                                                      int64_t value,
                                                      std::string *diagnostic) {
  Session session(store);
  ixs_node *node = ixs_int(session.raw(), value);
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
  SmallVector<ixs_node *, 4> values;
  SmallVector<ixs_node *, 4> conditions;
  values.reserve(cases.size());
  conditions.reserve(cases.size());
  for (PiecewiseCase piece : cases) {
    ixs_node *value = rawExprNode(piece.value, diagnostic);
    ixs_node *condition = rawPredNode(piece.condition, diagnostic);
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
  ixs_node *lhs = rawExprNode(lhsHandle, diagnostic);
  ixs_node *rhs = rawExprNode(rhsHandle, diagnostic);
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
  ixs_node *lhs = rawPredNode(lhsHandle, diagnostic);
  ixs_node *rhs = rawPredNode(rhsHandle, diagnostic);
  if (!lhs || !rhs)
    return failure();
  return finishPred(session.raw(), ixs_and(session.raw(), lhs, rhs), diagnostic,
                    "failed to compose wave.pred AND");
}

mlir::FailureOr<PredHandle>
mlir::wave::sym::composePredOr(Store &store, PredHandle lhsHandle,
                               PredHandle rhsHandle, std::string *diagnostic) {
  Session session(store);
  ixs_node *lhs = rawPredNode(lhsHandle, diagnostic);
  ixs_node *rhs = rawPredNode(rhsHandle, diagnostic);
  if (!lhs || !rhs)
    return failure();
  return finishPred(session.raw(), ixs_or(session.raw(), lhs, rhs), diagnostic,
                    "failed to compose wave.pred OR");
}

mlir::FailureOr<PredHandle>
mlir::wave::sym::composePredNot(Store &store, PredHandle valueHandle,
                                std::string *diagnostic) {
  Session session(store);
  ixs_node *value = rawPredNode(valueHandle, diagnostic);
  if (!value)
    return failure();
  return finishPred(session.raw(), ixs_not(session.raw(), value), diagnostic,
                    "failed to compose wave.pred NOT");
}

FailureOr<ExprHandle> mlir::wave::sym::simplifyExpr(Store &store,
                                                    ExprHandle value,
                                                    std::string *diagnostic) {
  Session session(store);
  ixs_node *expr = rawExprNode(value, diagnostic);
  if (!expr)
    return failure();
  ixs_node *simplified =
      ixs_simplify(session.raw(), expr, /*assumptions=*/nullptr, 0);
  return finishExpr(session.raw(), simplified, diagnostic,
                    "failed to simplify wave.expr");
}

FailureOr<PredHandle> mlir::wave::sym::simplifyPred(Store &store,
                                                    PredHandle value,
                                                    std::string *diagnostic) {
  Session session(store);
  ixs_node *pred = rawPredNode(value, diagnostic);
  if (!pred)
    return failure();
  ixs_node *simplified =
      ixs_simplify(session.raw(), pred, /*assumptions=*/nullptr, 0);
  return finishPred(session.raw(), simplified, diagnostic,
                    "failed to simplify wave.pred");
}

FailureOr<ExprHandle>
mlir::wave::sym::substituteExpr(Store &store, ExprHandle value,
                                ArrayRef<ExprSubstitution> substitutions,
                                std::string *diagnostic) {
  Session session(store);
  ixs_node *expr = rawExprNode(value, diagnostic);
  if (!expr)
    return failure();

  SmallVector<ixs_node *, 4> targets;
  SmallVector<ixs_node *, 4> replacements;
  targets.reserve(substitutions.size());
  replacements.reserve(substitutions.size());
  for (const ExprSubstitution &substitution : substitutions) {
    ixs_node *target = rawExprNode(substitution.target, diagnostic);
    ixs_node *replacement = rawExprNode(substitution.replacement, diagnostic);
    if (!target || !replacement)
      return failure();
    targets.push_back(target);
    replacements.push_back(replacement);
  }

  if (targets.size() > std::numeric_limits<uint32_t>::max()) {
    setDiagnostic(diagnostic, "too many wave.expr substitutions");
    return failure();
  }
  ixs_node *result =
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
  ixs_node *pred = rawPredNode(value, diagnostic);
  if (!pred)
    return failure();

  SmallVector<ixs_node *, 4> targets;
  SmallVector<ixs_node *, 4> replacements;
  targets.reserve(substitutions.size());
  replacements.reserve(substitutions.size());
  for (const ExprSubstitution &substitution : substitutions) {
    ixs_node *target = rawExprNode(substitution.target, diagnostic);
    ixs_node *replacement = rawExprNode(substitution.replacement, diagnostic);
    if (!target || !replacement)
      return failure();
    targets.push_back(target);
    replacements.push_back(replacement);
  }

  if (targets.size() > std::numeric_limits<uint32_t>::max()) {
    setDiagnostic(diagnostic, "too many wave.pred substitutions");
    return failure();
  }
  ixs_node *result =
      ixs_subs_multi(session.raw(), pred, static_cast<uint32_t>(targets.size()),
                     targets.data(), replacements.data());
  return finishPred(session.raw(), result, diagnostic,
                    "failed to substitute wave.pred");
}

// `ixs_bounds_add_assumption` only consumes CMP nodes -- an AND-tree
// produced by `composePredAnd` is silently ignored. Flatten before
// handing off to ixsimpl queries.
static void flattenAssumption(ixs_node *node,
                              SmallVectorImpl<ixs_node *> &out) {
  if (!node)
    return;
  if (ixs_node_tag(node) == IXS_AND) {
    for (uint32_t i = 0, e = ixs_node_logic_nargs(node); i != e; ++i)
      flattenAssumption(ixs_node_logic_arg(node, i), out);
    return;
  }
  out.push_back(node);
}

static int compareRationalToInteger(RationalEndpoint value, int64_t integer) {
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

static std::optional<int64_t> ceilRational(RationalEndpoint value) {
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
  ixs_node *expr = rawExprNode(value, diagnostic);
  if (!expr)
    return failure();
  SmallVector<ixs_node *, 4> rawAssumptions;
  for (PredHandle assumption : assumptions) {
    ixs_node *pred = rawPredNode(assumption, diagnostic);
    if (!pred)
      return failure();
    flattenAssumption(pred, rawAssumptions);
  }
  ixs_node *simplified = ixs_simplify(
      session.raw(), expr, rawAssumptions.data(), rawAssumptions.size());
  return finishExpr(session.raw(), simplified, diagnostic,
                    "failed to simplify wave.expr");
}

FailureOr<ExprHandle> mlir::wave::sym::expandExpr(Store &store,
                                                  ExprHandle value,
                                                  std::string *diagnostic) {
  Session session(store);
  ixs_node *expr = rawExprNode(value, diagnostic);
  if (!expr)
    return failure();
  return finishExpr(session.raw(), ixs_expand(session.raw(), expr), diagnostic,
                    "failed to expand wave.expr");
}

mlir::wave::sym::CheckResult
mlir::wave::sym::checkPredicate(Store &store, PredHandle predicate,
                                ArrayRef<PredHandle> assumptions) {
  if (!predicate)
    return CheckResult::Unknown;
  Session session(store);
  ixs_node *rawPred = rawPredNode(predicate, /*diagnostic=*/nullptr);
  if (!rawPred)
    return CheckResult::Unknown;
  SmallVector<ixs_node *, 4> rawAssumptions;
  for (PredHandle assumption : assumptions) {
    ixs_node *rawAssumption = rawPredNode(assumption, /*diagnostic=*/nullptr);
    if (!rawAssumption)
      return CheckResult::Unknown;
    flattenAssumption(rawAssumption, rawAssumptions);
  }
  ixs_check_result result = ixs_check(
      session.raw(), rawPred, rawAssumptions.data(), rawAssumptions.size());
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

static bool provablyNonZero(Store &store, ExprHandle expr,
                            ArrayRef<PredHandle> assumptions) {
  FailureOr<ExprHandle> zero = composeExprInt(store, 0);
  if (failed(zero))
    return false;
  FailureOr<PredHandle> nonZero =
      composePredCmp(store, expr, PredCmpOp::Ne, *zero);
  return succeeded(nonZero) &&
         checkPredicate(store, *nonZero, assumptions) == CheckResult::True;
}

static bool provablyDefinedAdd(Store &store, ExprView view,
                               ArrayRef<PredHandle> assumptions) {
  if (!provablyDefined(store, view.getAddConstant(), assumptions))
    return false;
  for (uint32_t index : llvm::seq<uint32_t>(0, view.getAddTermCount())) {
    AddTerm term = view.getAddTerm(index);
    if (!provablyDefined(store, term.coefficient, assumptions) ||
        !provablyDefined(store, term.term, assumptions))
      return false;
  }
  return true;
}

static bool provablyDefinedMul(Store &store, ExprView view,
                               ArrayRef<PredHandle> assumptions) {
  if (!provablyDefined(store, view.getMulCoefficient(), assumptions))
    return false;
  for (uint32_t index : llvm::seq<uint32_t>(0, view.getMulFactorCount())) {
    MulFactor factor = view.getMulFactor(index);
    if (!provablyDefined(store, factor.base, assumptions))
      return false;
    if (factor.exponent < 0 &&
        !provablyNonZero(store, factor.base, assumptions))
      return false;
  }
  return true;
}

static bool provablyDefinedPiecewise(Store &store, ExprView view,
                                     ArrayRef<PredHandle> assumptions) {
  FailureOr<PredHandle> covered = composePredFalse(store);
  if (failed(covered))
    return false;
  for (uint32_t index : llvm::seq<uint32_t>(0, view.getPiecewiseCaseCount())) {
    PiecewiseCase piece = view.getPiecewiseCase(index);
    if (!provablyDefined(store, piece.condition, assumptions))
      return false;
    if (checkPredicate(store, piece.condition, assumptions) !=
        CheckResult::False) {
      SmallVector<PredHandle, 4> caseAssumptions(assumptions);
      caseAssumptions.push_back(piece.condition);
      if (!provablyDefined(store, piece.value, caseAssumptions))
        return false;
    }
    covered = composePredOr(store, *covered, piece.condition);
    if (failed(covered))
      return false;
  }
  return checkPredicate(store, *covered, assumptions) == CheckResult::True;
}

static std::optional<bool>
proveSimpleExprDefined(Store &store, ExprView view,
                       ArrayRef<PredHandle> assumptions) {
  switch (view.getKind()) {
  case ExprKind::Integer:
  case ExprKind::Rational:
  case ExprKind::Symbol:
    return true;
  case ExprKind::Floor:
  case ExprKind::Ceil:
    return provablyDefined(store, view.getUnaryArg(), assumptions);
  case ExprKind::Invalid:
  case ExprKind::Error:
  case ExprKind::ParseError:
    return false;
  default:
    return std::nullopt;
  }
}

static bool provablyDefinedMod(Store &store, ExprView view,
                               ArrayRef<PredHandle> assumptions) {
  return provablyDefined(store, view.getBinaryLhs(), assumptions) &&
         provablyDefined(store, view.getBinaryRhs(), assumptions) &&
         provablyNonZero(store, view.getBinaryRhs(), assumptions);
}

static bool provablyDefinedBinary(Store &store, ExprView view,
                                  ArrayRef<PredHandle> assumptions) {
  return provablyDefined(store, view.getBinaryLhs(), assumptions) &&
         provablyDefined(store, view.getBinaryRhs(), assumptions);
}

static bool proveCompoundExprDefined(Store &store, ExprView view,
                                     ArrayRef<PredHandle> assumptions) {
  switch (view.getKind()) {
  case ExprKind::Add:
    return provablyDefinedAdd(store, view, assumptions);
  case ExprKind::Mul:
    return provablyDefinedMul(store, view, assumptions);
  case ExprKind::Mod:
    return provablyDefinedMod(store, view, assumptions);
  case ExprKind::Max:
  case ExprKind::Min:
  case ExprKind::Xor:
    return provablyDefinedBinary(store, view, assumptions);
  case ExprKind::Piecewise:
    return provablyDefinedPiecewise(store, view, assumptions);
  default:
    llvm_unreachable("expected compound expression");
  }
}

bool mlir::wave::sym::provablyDefined(Store &store, ExprHandle expr,
                                      ArrayRef<PredHandle> assumptions) {
  ExprView view(expr);
  if (std::optional<bool> result =
          proveSimpleExprDefined(store, view, assumptions))
    return *result;
  return proveCompoundExprDefined(store, view, assumptions);
}

static bool provablyDefinedLogic(Store &store, PredView view,
                                 ArrayRef<PredHandle> assumptions) {
  for (uint32_t index : llvm::seq<uint32_t>(0, view.getLogicArgCount()))
    if (!provablyDefined(store, view.getLogicArg(index), assumptions))
      return false;
  return true;
}

static std::optional<bool> proveSimplePredDefined(PredView view) {
  switch (view.getKind()) {
  case PredKind::True:
  case PredKind::False:
    return true;
  case PredKind::Invalid:
  case PredKind::Error:
  case PredKind::ParseError:
    return false;
  default:
    return std::nullopt;
  }
}

bool mlir::wave::sym::provablyDefined(Store &store, PredHandle pred,
                                      ArrayRef<PredHandle> assumptions) {
  PredView view(pred);
  if (std::optional<bool> result = proveSimplePredDefined(view))
    return *result;
  switch (view.getKind()) {
  case PredKind::Cmp:
    return provablyDefined(store, view.getCmpLhs(), assumptions) &&
           provablyDefined(store, view.getCmpRhs(), assumptions);
  case PredKind::And:
  case PredKind::Or:
    return provablyDefinedLogic(store, view, assumptions);
  case PredKind::Not:
    return provablyDefined(store, view.getUnaryArg(), assumptions);
  default:
    llvm_unreachable("expected compound predicate");
  }
}

mlir::wave::sym::Pow2Fact
mlir::wave::sym::getPow2Fact(Store &store, ExprHandle expr,
                             ArrayRef<PredHandle> assumptions) {
  if (!expr)
    return Pow2Fact::Unknown;
  Session session(store);
  ixs_node *rawExpr = rawExprNode(expr, /*diagnostic=*/nullptr);
  if (!rawExpr)
    return Pow2Fact::Unknown;
  SmallVector<ixs_node *, 4> rawAssumptions;
  for (PredHandle assumption : assumptions) {
    ixs_node *rawAssumption = rawPredNode(assumption, /*diagnostic=*/nullptr);
    if (!rawAssumption)
      return Pow2Fact::Unknown;
    flattenAssumption(rawAssumption, rawAssumptions);
  }
  switch (ixs_get_pow2_fact(session.raw(), rawExpr, rawAssumptions.data(),
                            rawAssumptions.size())) {
  case IXS_POW2_UNKNOWN:
    return Pow2Fact::Unknown;
  case IXS_POW2_OR_ZERO:
    return Pow2Fact::OrZero;
  case IXS_POW2_POSITIVE:
    return Pow2Fact::Positive;
  }
  return Pow2Fact::Unknown;
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

bool mlir::wave::sym::provablyInRange(Store &store, ExprHandle expr,
                                      ArrayRef<PredHandle> assumptions,
                                      int64_t lo, int64_t hi) {
  std::optional<InferredRange> range = inferRange(store, expr, assumptions);
  if (!range || !range->lower || !range->upper)
    return false;
  return compareRationalToInteger(*range->lower, lo) >= 0 &&
         compareRationalToInteger(*range->upper, hi) <= 0;
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

static std::optional<uint64_t>
exprU32UpperBound(Store &store, ExprHandle expr,
                  ArrayRef<PredHandle> assumptions);

static std::optional<uint64_t>
addExprU32UpperBound(Store &store, ExprHandle expr,
                     ArrayRef<PredHandle> assumptions) {
  uint64_t bound = 0;
  ExprView view(expr);
  std::optional<int64_t> constant =
      sym::getIntegerLiteralValue(view.getAddConstant());
  if (!constant || *constant < 0)
    return std::nullopt;
  bound = static_cast<uint64_t>(*constant);

  for (uint32_t index : llvm::seq<uint32_t>(0, view.getAddTermCount())) {
    AddTerm addTerm = view.getAddTerm(index);
    std::optional<int64_t> coeff =
        sym::getIntegerLiteralValue(addTerm.coefficient);
    if (!coeff || *coeff < 0)
      return std::nullopt;
    std::optional<uint64_t> term =
        exprU32UpperBound(store, addTerm.term, assumptions);
    if (!term)
      return std::nullopt;
    std::optional<uint64_t> scaled =
        checkedMulU32Bound(static_cast<uint64_t>(*coeff), *term);
    if (!scaled)
      return std::nullopt;
    std::optional<uint64_t> next = checkedAddU32Bound(bound, *scaled);
    if (!next)
      return std::nullopt;
    bound = *next;
  }
  return bound;
}

static std::optional<uint64_t>
positiveAddendsU32UpperBound(Store &store, ExprHandle expr,
                             ArrayRef<PredHandle> assumptions) {
  uint64_t bound = 0;
  ExprView view(expr);
  std::optional<int64_t> constant =
      sym::getIntegerLiteralValue(view.getAddConstant());
  if (!constant)
    return std::nullopt;
  if (*constant > 0)
    bound = static_cast<uint64_t>(*constant);

  for (uint32_t index : llvm::seq<uint32_t>(0, view.getAddTermCount())) {
    AddTerm addTerm = view.getAddTerm(index);
    std::optional<int64_t> coeff =
        sym::getIntegerLiteralValue(addTerm.coefficient);
    if (!coeff)
      return std::nullopt;
    if (*coeff <= 0)
      continue;
    std::optional<uint64_t> term =
        exprU32UpperBound(store, addTerm.term, assumptions);
    if (!term)
      return std::nullopt;
    std::optional<uint64_t> scaled =
        checkedMulU32Bound(static_cast<uint64_t>(*coeff), *term);
    if (!scaled)
      return std::nullopt;
    std::optional<uint64_t> next = checkedAddU32Bound(bound, *scaled);
    if (!next)
      return std::nullopt;
    bound = *next;
  }
  return bound;
}

static std::optional<uint64_t>
mulExprU32UpperBound(Store &store, ExprHandle expr,
                     ArrayRef<PredHandle> assumptions) {
  ExprView view(expr);
  std::optional<int64_t> coeff =
      sym::getIntegerLiteralValue(view.getMulCoefficient());
  if (!coeff || *coeff < 0)
    return std::nullopt;
  uint64_t bound = static_cast<uint64_t>(*coeff);
  for (uint32_t index : llvm::seq<uint32_t>(0, view.getMulFactorCount())) {
    MulFactor factor = view.getMulFactor(index);
    if (factor.exponent <= 0)
      return std::nullopt;
    std::optional<uint64_t> factorBound =
        exprU32UpperBound(store, factor.base, assumptions);
    if (!factorBound)
      return std::nullopt;
    for (int32_t exp = 0; exp < factor.exponent; ++exp) {
      std::optional<uint64_t> next = checkedMulU32Bound(bound, *factorBound);
      if (!next)
        return std::nullopt;
      bound = *next;
    }
  }
  return bound;
}

static std::optional<uint64_t>
xorExprU32UpperBound(Store &store, ExprHandle expr,
                     ArrayRef<PredHandle> assumptions) {
  ExprView view(expr);
  std::optional<uint64_t> lhs =
      exprU32UpperBound(store, view.getBinaryLhs(), assumptions);
  std::optional<uint64_t> rhs =
      exprU32UpperBound(store, view.getBinaryRhs(), assumptions);
  if (!lhs || !rhs)
    return std::nullopt;
  uint64_t maxOperand = std::max(*lhs, *rhs);
  if (maxOperand == 0)
    return uint64_t{0};
  return llvm::PowerOf2Ceil(maxOperand + 1) - 1;
}

static std::optional<uint64_t>
piecewiseExprU32UpperBound(Store &store, ExprHandle expr,
                           ArrayRef<PredHandle> assumptions) {
  ExprView view(expr);
  std::optional<uint64_t> maxBound;
  for (uint32_t index : llvm::seq<uint32_t>(0, view.getPiecewiseCaseCount())) {
    std::optional<uint64_t> bound = exprU32UpperBound(
        store, view.getPiecewiseCase(index).value, assumptions);
    if (!bound)
      return std::nullopt;
    maxBound = maxBound ? std::max(*maxBound, *bound) : *bound;
  }
  return maxBound;
}

static std::optional<uint64_t>
exprU32UpperBound(Store &store, ExprHandle expr,
                  ArrayRef<PredHandle> assumptions) {
  constexpr uint64_t u32Max = (uint64_t{1} << 32) - 1;
  if (std::optional<int64_t> value = sym::getIntegerLiteralValue(expr)) {
    if (*value < 0 || static_cast<uint64_t>(*value) > u32Max)
      return std::nullopt;
    return static_cast<uint64_t>(*value);
  }
  if (std::optional<int64_t> upper = sym::inferNonNegativeUpperBound(
          store, expr, assumptions, static_cast<int64_t>(u32Max)))
    return static_cast<uint64_t>(*upper);

  ExprView view(expr);
  switch (view.getKind()) {
  case ExprKind::Add:
    return addExprU32UpperBound(store, expr, assumptions);
  case ExprKind::Mul:
    return mulExprU32UpperBound(store, expr, assumptions);
  case ExprKind::Xor:
    return xorExprU32UpperBound(store, expr, assumptions);
  case ExprKind::Piecewise:
    return piecewiseExprU32UpperBound(store, expr, assumptions);
  default:
    break;
  }
  return std::nullopt;
}

struct I64RangeBounds {
  std::optional<int64_t> lower;
  std::optional<int64_t> upper;
};

static ExprHandle canonicalExpr(Store &store, ExprHandle value,
                                ArrayRef<PredHandle> assumptions = {}) {
  FailureOr<ExprHandle> expanded = sym::expandExpr(store, value);
  if (succeeded(expanded))
    value = *expanded;
  FailureOr<ExprHandle> simplified =
      assumptions.empty() ? sym::simplifyExpr(store, value)
                          : sym::simplifyExpr(store, value, assumptions);
  return succeeded(simplified) ? *simplified : value;
}

static std::optional<int64_t>
offsetFromTarget(Store &store, ExprHandle target, ExprHandle lhs,
                 ExprHandle rhs, ArrayRef<PredHandle> assumptions) {
  FailureOr<ExprHandle> negRhs = sym::composeExprNeg(store, rhs);
  if (failed(negRhs))
    return std::nullopt;
  FailureOr<ExprHandle> diff =
      sym::composeExprBinary(store, lhs, ExprBinaryOp::Add, *negRhs);
  if (failed(diff))
    return std::nullopt;
  FailureOr<ExprHandle> negTarget = sym::composeExprNeg(store, target);
  if (failed(negTarget))
    return std::nullopt;
  FailureOr<ExprHandle> delta =
      sym::composeExprBinary(store, canonicalExpr(store, *diff, assumptions),
                             ExprBinaryOp::Add, *negTarget);
  if (failed(delta))
    return std::nullopt;
  return sym::getIntegerLiteralValue(canonicalExpr(store, *delta, assumptions));
}

static void tightenLower(I64RangeBounds &bounds, int64_t bound) {
  bounds.lower = bounds.lower ? std::max(*bounds.lower, bound) : bound;
}

static void tightenUpper(I64RangeBounds &bounds, int64_t bound) {
  bounds.upper = bounds.upper ? std::min(*bounds.upper, bound) : bound;
}

static void applyCmpBound(PredCmpOp op, int64_t bound, I64RangeBounds &bounds) {
  switch (op) {
  case PredCmpOp::Le:
    tightenUpper(bounds, bound);
    break;
  case PredCmpOp::Lt:
    if (std::optional<int64_t> strict = llvm::checkedSub(bound, int64_t{1}))
      tightenUpper(bounds, *strict);
    break;
  case PredCmpOp::Ge:
    tightenLower(bounds, bound);
    break;
  case PredCmpOp::Gt:
    if (std::optional<int64_t> strict = llvm::checkedAdd(bound, int64_t{1}))
      tightenLower(bounds, *strict);
    break;
  case PredCmpOp::Eq:
    tightenLower(bounds, bound);
    tightenUpper(bounds, bound);
    break;
  case PredCmpOp::Ne:
    break;
  }
}

static void collectTargetRange(Store &store, ExprHandle target, PredHandle pred,
                               ArrayRef<PredHandle> assumptions,
                               I64RangeBounds &bounds) {
  PredView view(pred);
  if (view.getKind() == PredKind::And) {
    for (uint32_t index : llvm::seq<uint32_t>(0, view.getLogicArgCount()))
      collectTargetRange(store, target, view.getLogicArg(index), assumptions,
                         bounds);
    return;
  }
  if (view.getKind() != PredKind::Cmp)
    return;
  std::optional<PredCmpOp> op = view.getCmpOp();
  std::optional<int64_t> offset = offsetFromTarget(
      store, target, view.getCmpLhs(), view.getCmpRhs(), assumptions);
  if (!op || !offset)
    return;
  std::optional<int64_t> bound = llvm::checkedSub(int64_t{0}, *offset);
  if (bound)
    applyCmpBound(*op, *bound, bounds);
}

static bool provenRangeFitsU32(Store &store, ExprHandle expr,
                               ArrayRef<PredHandle> assumptions) {
  I64RangeBounds bounds;
  ExprHandle target = canonicalExpr(store, expr, assumptions);
  for (PredHandle pred : assumptions)
    collectTargetRange(store, target, pred, assumptions, bounds);
  constexpr int64_t u32Max = (int64_t{1} << 32) - 1;
  return bounds.lower && bounds.upper && *bounds.lower >= 0 &&
         *bounds.upper <= u32Max;
}

static bool explicitPredicatesProveU32(Store &store, ExprHandle expr,
                                       ArrayRef<PredHandle> assumptions) {
  FailureOr<ExprHandle> zero = sym::composeExprInt(store, 0);
  FailureOr<ExprHandle> u32MaxExpr =
      sym::composeExprInt(store, (int64_t{1} << 32) - 1);
  if (failed(zero) || failed(u32MaxExpr))
    return false;
  FailureOr<PredHandle> nonNegative =
      sym::composePredCmp(store, expr, PredCmpOp::Ge, *zero);
  FailureOr<PredHandle> inUpper =
      sym::composePredCmp(store, expr, PredCmpOp::Le, *u32MaxExpr);
  return succeeded(nonNegative) && succeeded(inUpper) &&
         sym::checkPredicate(store, *nonNegative, assumptions) ==
             CheckResult::True &&
         sym::checkPredicate(store, *inUpper, assumptions) == CheckResult::True;
}

bool mlir::wave::sym::provablyFitsU32(Store &store, ExprHandle expr,
                                      ArrayRef<PredHandle> assumptions) {
  if (provenRangeFitsU32(store, expr, assumptions))
    return true;
  if (explicitPredicatesProveU32(store, expr, assumptions))
    return true;
  if (std::optional<uint64_t> bound =
          exprU32UpperBound(store, expr, assumptions))
    return *bound <= (uint64_t{1} << 32) - 1;
  return false;
}

bool mlir::wave::sym::positiveAddendsFitU32(Store &store, ExprHandle expr,
                                            ArrayRef<PredHandle> assumptions) {
  if (ExprView(expr).getKind() != ExprKind::Add)
    return false;
  if (std::optional<uint64_t> bound =
          positiveAddendsU32UpperBound(store, expr, assumptions))
    return *bound <= (uint64_t{1} << 32) - 1;
  return false;
}

std::optional<InferredRange>
mlir::wave::sym::inferRange(Store &store, ExprHandle expr,
                            ArrayRef<PredHandle> assumptions) {
  if (!expr)
    return std::nullopt;
  Session session(store);
  ixs_node *rawExpr = rawExprNode(expr, /*diagnostic=*/nullptr);
  if (!rawExpr)
    return std::nullopt;
  SmallVector<ixs_node *, 4> rawAssumptions;
  for (PredHandle assumption : assumptions) {
    ixs_node *rawAssumption = rawPredNode(assumption, /*diagnostic=*/nullptr);
    if (!rawAssumption)
      return std::nullopt;
    flattenAssumption(rawAssumption, rawAssumptions);
  }
  ixs_range_result rawRange;
  if (!ixs_range(session.raw(), rawExpr, rawAssumptions.data(),
                 rawAssumptions.size(), &rawRange))
    return std::nullopt;
  InferredRange range;
  if (rawRange.has_lower)
    range.lower = RationalEndpoint{rawRange.lower_p, rawRange.lower_q};
  if (rawRange.has_upper)
    range.upper = RationalEndpoint{rawRange.upper_p, rawRange.upper_q};
  return range;
}

std::optional<int64_t>
mlir::wave::sym::inferNonNegativeUpperBound(Store &store, ExprHandle expr,
                                            ArrayRef<PredHandle> assumptions,
                                            int64_t maxUpper) {
  std::optional<InferredRange> range = inferRange(store, expr, assumptions);
  if (!range || !range->lower || !range->upper)
    return std::nullopt;
  if (compareRationalToInteger(*range->lower, 0) < 0 ||
      compareRationalToInteger(*range->upper, maxUpper) > 0)
    return std::nullopt;
  return ceilRational(*range->upper);
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

static bool hasUnitDenominator(ExprKind kind) {
  return kind == ExprKind::Integer || kind == ExprKind::Symbol ||
         kind == ExprKind::Floor || kind == ExprKind::Ceil;
}

static std::optional<int64_t> collectRationalDenominator(ExprView view) {
  std::optional<RationalLiteral> rational = view.getRational();
  if (!rational)
    return std::nullopt;
  return rational->denominator > 0 ? rational->denominator : 1;
}

static std::optional<int64_t> collectAddDenominator(ExprView view) {
  std::optional<int64_t> d = collectDenominator(view.getAddConstant());
  for (uint32_t i = 0, e = view.getAddTermCount(); i != e; ++i) {
    AddTerm term = view.getAddTerm(i);
    d = checkedLCM(d, collectDenominator(term.coefficient));
    d = checkedLCM(d, collectDenominator(term.term));
  }
  return d;
}

static std::optional<int64_t> collectMulDenominator(ExprView view) {
  std::optional<int64_t> d = collectDenominator(view.getMulCoefficient());
  for (uint32_t i = 0, e = view.getMulFactorCount(); i != e; ++i)
    d = checkedLCM(d, collectDenominator(view.getMulFactor(i).base));
  return d;
}

static std::optional<int64_t> collectBinaryLCMDenominator(ExprView view) {
  return checkedLCM(collectDenominator(view.getBinaryLhs()),
                    collectDenominator(view.getBinaryRhs()));
}

static std::optional<int64_t> collectXorDenominator(ExprView view) {
  std::optional<int64_t> lhs = collectDenominator(view.getBinaryLhs());
  std::optional<int64_t> rhs = collectDenominator(view.getBinaryRhs());
  if (!lhs || !rhs || *lhs != 1 || *rhs != 1)
    return std::nullopt;
  return 1;
}

static std::optional<int64_t> collectPiecewiseDenominator(ExprView view) {
  std::optional<int64_t> denominator = 1;
  for (uint32_t index : llvm::seq<uint32_t>(0, view.getPiecewiseCaseCount()))
    denominator = checkedLCM(
        denominator, collectDenominator(view.getPiecewiseCase(index).value));
  return denominator;
}

std::optional<int64_t> mlir::wave::sym::collectDenominator(ExprHandle value) {
  ExprView view(value);
  ExprKind kind = view.getKind();
  if (hasUnitDenominator(kind))
    return 1;
  if (kind == ExprKind::Rational)
    return collectRationalDenominator(view);
  if (kind == ExprKind::Add)
    return collectAddDenominator(view);
  if (kind == ExprKind::Mul)
    return collectMulDenominator(view);
  if (kind == ExprKind::Max || kind == ExprKind::Min || kind == ExprKind::Mod)
    return collectBinaryLCMDenominator(view);
  if (kind == ExprKind::Xor)
    return collectXorDenominator(view);
  if (kind == ExprKind::Piecewise)
    return collectPiecewiseDenominator(view);
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
