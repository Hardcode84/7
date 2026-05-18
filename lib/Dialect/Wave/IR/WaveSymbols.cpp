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
#include "llvm/Support/ErrorHandling.h"
#include "llvm/Support/raw_ostream.h"

#include <cassert>
#include <limits>
#include <utility>

using namespace mlir;
using namespace mlir::wave;
using namespace mlir::wave::sym;

namespace {

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
  auto *rawNode = const_cast<ixs_node *>(node);
  // ixsimpl printer walks immutable graph: no session needed.
  size_t n = ixs_print(rawNode, nullptr, 0);
  if (n == std::numeric_limits<size_t>::max())
    llvm::report_fatal_error(
        "wave symbolic printer reported an invalid length");
  std::string text(n + 1, '\0');
  ixs_print(rawNode, text.data(), text.size());
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

static ixs_node *importNode(Session &session, const ixs_node *node,
                            std::string *diagnostic, const char *kind) {
  if (!node) {
    setDiagnostic(diagnostic, std::string("cannot compose null ") + kind);
    return nullptr;
  }
  ixs_node *imported = ixs_import_node(session.raw(), node);
  if (!imported)
    setDiagnostic(diagnostic, std::string("out of memory importing ") + kind);
  return imported;
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
    auto *rawNode = const_cast<ixs_node *>(current);
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

Session::Session(Store &store) : store(store), lock(store.mutex) {
  ixs_session_init(&session, store.ctx);
}

Session::~Session() { ixs_session_destroy(&session); }

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
  ixs_node *lhs = importNode(session, lhsHandle.raw(), diagnostic, "wave.expr");
  ixs_node *rhs = importNode(session, rhsHandle.raw(), diagnostic, "wave.expr");
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
  }
  return finishExpr(session.raw(), node, diagnostic,
                    "failed to compose wave.expr");
}

FailureOr<ExprHandle>
mlir::wave::sym::composeExprCeil(Store &store, ExprHandle valueHandle,
                                 std::string *diagnostic) {
  Session session(store);
  ixs_node *value =
      importNode(session, valueHandle.raw(), diagnostic, "wave.expr");
  if (!value)
    return failure();
  return finishExpr(session.raw(), ixs_ceil(session.raw(), value), diagnostic,
                    "failed to compose wave.expr");
}

FailureOr<ExprHandle>
mlir::wave::sym::composeExprFloor(Store &store, ExprHandle valueHandle,
                                  std::string *diagnostic) {
  Session session(store);
  ixs_node *value =
      importNode(session, valueHandle.raw(), diagnostic, "wave.expr");
  if (!value)
    return failure();
  return finishExpr(session.raw(), ixs_floor(session.raw(), value), diagnostic,
                    "failed to compose wave.expr");
}

FailureOr<ExprHandle> mlir::wave::sym::composeExprNeg(Store &store,
                                                      ExprHandle valueHandle,
                                                      std::string *diagnostic) {
  Session session(store);
  ixs_node *value =
      importNode(session, valueHandle.raw(), diagnostic, "wave.expr");
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

FailureOr<PredHandle> mlir::wave::sym::composePredCmp(Store &store,
                                                      ExprHandle lhsHandle,
                                                      PredCmpOp op,
                                                      ExprHandle rhsHandle,
                                                      std::string *diagnostic) {
  Session session(store);
  ixs_node *lhs = importNode(session, lhsHandle.raw(), diagnostic, "wave.expr");
  ixs_node *rhs = importNode(session, rhsHandle.raw(), diagnostic, "wave.expr");
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
  ixs_node *lhs = importNode(session, lhsHandle.raw(), diagnostic, "wave.pred");
  ixs_node *rhs = importNode(session, rhsHandle.raw(), diagnostic, "wave.pred");
  if (!lhs || !rhs)
    return failure();
  return finishPred(session.raw(), ixs_and(session.raw(), lhs, rhs), diagnostic,
                    "failed to compose wave.pred AND");
}

mlir::FailureOr<PredHandle>
mlir::wave::sym::composePredOr(Store &store, PredHandle lhsHandle,
                               PredHandle rhsHandle, std::string *diagnostic) {
  Session session(store);
  ixs_node *lhs = importNode(session, lhsHandle.raw(), diagnostic, "wave.pred");
  ixs_node *rhs = importNode(session, rhsHandle.raw(), diagnostic, "wave.pred");
  if (!lhs || !rhs)
    return failure();
  return finishPred(session.raw(), ixs_or(session.raw(), lhs, rhs), diagnostic,
                    "failed to compose wave.pred OR");
}

FailureOr<ExprHandle> mlir::wave::sym::simplifyExpr(Store &store,
                                                    ExprHandle value,
                                                    std::string *diagnostic) {
  Session session(store);
  ixs_node *imported =
      importNode(session, value.raw(), diagnostic, "wave.expr");
  if (!imported)
    return failure();
  // `ixs_simplify` with no assumptions: pure rewriting, returns a hash-consed
  // canonical form.
  ixs_node *simplified =
      ixs_simplify(session.raw(), imported, /*assumptions=*/nullptr, 0);
  return finishExpr(session.raw(), simplified, diagnostic,
                    "failed to simplify wave.expr");
}

FailureOr<PredHandle> mlir::wave::sym::simplifyPred(Store &store,
                                                    PredHandle value,
                                                    std::string *diagnostic) {
  Session session(store);
  ixs_node *imported =
      importNode(session, value.raw(), diagnostic, "wave.pred");
  if (!imported)
    return failure();
  ixs_node *simplified =
      ixs_simplify(session.raw(), imported, /*assumptions=*/nullptr, 0);
  return finishPred(session.raw(), simplified, diagnostic,
                    "failed to simplify wave.pred");
}

// `ixs_bounds_add_assumption` only consumes CMP nodes -- an AND-tree
// produced by `composePredAnd` is silently ignored. Flatten before
// handing off to `ixs_check`.
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

mlir::wave::sym::CheckResult
mlir::wave::sym::checkPredicate(Store &store, PredHandle predicate,
                                ArrayRef<PredHandle> assumptions) {
  if (!predicate)
    return CheckResult::Unknown;
  Session session(store);
  ixs_node *importedPred =
      importNode(session, predicate.raw(), /*diagnostic=*/nullptr, "wave.pred");
  if (!importedPred)
    return CheckResult::Unknown;
  SmallVector<ixs_node *, 4> importedAssumptions;
  for (PredHandle assumption : assumptions) {
    ixs_node *imported = importNode(session, assumption.raw(),
                                    /*diagnostic=*/nullptr, "wave.pred");
    if (!imported)
      return CheckResult::Unknown;
    flattenAssumption(imported, importedAssumptions);
  }
  ixs_check_result result =
      ixs_check(session.raw(), importedPred, importedAssumptions.data(),
                importedAssumptions.size());
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
  if (!expr)
    return false;
  auto loConst = composeExprInt(store, lo);
  auto hiConst = composeExprInt(store, hi);
  if (failed(loConst) || failed(hiConst))
    return false;
  auto geLo = composePredCmp(store, expr, PredCmpOp::Ge, *loConst);
  auto leHi = composePredCmp(store, expr, PredCmpOp::Le, *hiConst);
  if (failed(geLo) || failed(leHi))
    return false;
  return checkPredicate(store, *geLo, assumptions) == CheckResult::True &&
         checkPredicate(store, *leHi, assumptions) == CheckResult::True;
}

std::optional<int64_t>
mlir::wave::sym::getIntegerLiteralValue(ExprHandle value) {
  const ixs_node *node = value.raw();
  if (!node)
    return std::nullopt;
  // ixsimpl introspection accessors are read-only but C API lacks const.
  auto *rawNode = const_cast<ixs_node *>(node);
  if (!ixs_node_is_expr(rawNode))
    return std::nullopt;
  if (ixs_node_tag(rawNode) == IXS_INT)
    return ixs_node_int_val(rawNode);
  if (ixs_node_tag(rawNode) == IXS_RAT && ixs_node_rat_den(rawNode) == 1)
    return ixs_node_rat_num(rawNode);
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
