//===- WaveAMDMachineIndexExpr.cpp - bucketizer for `wave.index_expr`
//--------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// IXS-AST materializer / classifier / constant evaluator / bucketizer
// cluster, factored out of `WaveAMDMachine.cpp`. The selector's
// per-op `select*` methods (and the rest of WaveAMDMachine selection)
// stay in `WaveAMDMachine.cpp`; this file owns the `wave.index_expr`
// translation surface: walk the symbolic AST, decide whether each
// summand rides voffset / soffset / inst_offset, and emit the right
// SGPR / VGPR / imm ops via `WaveAMDMachineSelector`'s public codegen
// helpers.
//
//===----------------------------------------------------------------------===//

#include "WaveAMDMachineSelector.h"

#include "llvm/Support/CheckedArithmetic.h"
#include "llvm/Support/MathExtras.h"

#include <limits>
#include <numeric>
#include <optional>

using namespace mlir;
using namespace mlir::wave;
using namespace mlir::waveamd;
using namespace mlir::wave::wmsel;

namespace mlir::wave::wmsel {

namespace {

// IXS_INT or IXS_RAT with unit denominator; nullopt otherwise.
std::optional<int64_t> staticIntLiteral(::ixs_node *node) {
  switch (ixs_node_tag(node)) {
  case IXS_INT:
    return ixs_node_int_val(node);
  case IXS_RAT:
    if (ixs_node_rat_den(node) == 1)
      return ixs_node_rat_num(node);
    return std::nullopt;
  default:
    return std::nullopt;
  }
}

static std::optional<int64_t> checkedLCM(std::optional<int64_t> lhs,
                                         std::optional<int64_t> rhs) {
  if (!lhs || !rhs)
    return std::nullopt;
  int64_t gcd = std::gcd(*lhs, *rhs);
  return llvm::checkedMul(*lhs / gcd, *rhs);
}

static bool divOverflows(int64_t p, int64_t q) {
  return q == 0 ||
         (p == std::numeric_limits<int64_t>::min() && q == int64_t{-1});
}

static std::optional<int64_t> floorDiv(int64_t p, int64_t q) {
  if (divOverflows(p, q))
    return std::nullopt;
  int64_t div = p / q;
  int64_t rem = p % q;
  if (rem == 0 || (rem < 0) == (q < 0))
    return div;
  return llvm::checkedSub(div, int64_t{1});
}

static std::optional<int64_t> ceilDiv(int64_t p, int64_t q) {
  if (divOverflows(p, q))
    return std::nullopt;
  int64_t div = p / q;
  int64_t rem = p % q;
  if (rem == 0 || (rem < 0) != (q < 0))
    return div;
  return llvm::checkedAdd(div, int64_t{1});
}

FailureOr<Value> materializeIxsRat(WaveAMDMachineSelector &S, ::ixs_node *node,
                                   Operation *user) {
  if (ixs_node_rat_den(node) != 1)
    return user->emitError(
        "wave.index_expr selection rejects non-integer rational");
  return createImm(S.builder, user->getLoc(), ixs_node_rat_num(node));
}

FailureOr<Value> materializeIxsSym(WaveAMDMachineSelector &, ::ixs_node *node,
                                   Operation *user,
                                   const llvm::StringMap<Value> &subs) {
  StringRef name = ixs_node_sym_name(node);
  auto it = subs.find(name);
  if (it == subs.end())
    return user->emitError("wave.index_expr leaf '")
           << name << "' has no binding";
  return it->second;
}

FailureOr<Value> materializeIxsAddTerm(WaveAMDMachineSelector &S,
                                       ::ixs_node *node, uint32_t i,
                                       Operation *user,
                                       const llvm::StringMap<Value> &subs) {
  Location loc = user->getLoc();
  ::ixs_node *termCoeff = ixs_node_add_term_coeff(node, i);
  FailureOr<Value> term =
      materializeIndexExprNode(S, ixs_node_add_term(node, i), user, subs);
  if (failed(term))
    return failure();
  std::optional<int64_t> tcInt = staticIntLiteral(termCoeff);
  if (tcInt && *tcInt == 1)
    return *term;
  FailureOr<Value> tcVal = materializeIndexExprNode(S, termCoeff, user, subs);
  if (failed(tcVal))
    return failure();
  return S.mulIndexValues(loc, *tcVal, *term);
}

// ADD = coeff + sum(term_coeff[i] * term[i]). Skip materializing coeff
// when it's 0 and term_coeff[i] when it's 1.
FailureOr<Value> materializeIxsAdd(WaveAMDMachineSelector &S, ::ixs_node *node,
                                   Operation *user,
                                   const llvm::StringMap<Value> &subs) {
  Location loc = user->getLoc();
  ::ixs_node *coeff = ixs_node_add_coeff(node);
  std::optional<int64_t> coeffInt = staticIntLiteral(coeff);
  std::optional<Value> acc;
  if (!coeffInt || *coeffInt != 0) {
    FailureOr<Value> seed = materializeIndexExprNode(S, coeff, user, subs);
    if (failed(seed))
      return failure();
    acc = *seed;
  }
  uint32_t nterms = ixs_node_add_nterms(node);
  for (uint32_t i = 0; i < nterms; ++i) {
    FailureOr<Value> scaled = materializeIxsAddTerm(S, node, i, user, subs);
    if (failed(scaled))
      return failure();
    if (!acc) {
      acc = *scaled;
    } else if (S.isUniformValue(*acc) && S.isUniformValue(*scaled)) {
      acc = S.addUniformBytes(loc, *acc, *scaled);
    } else {
      acc = S.addByteOffsets(loc, *acc, *scaled);
    }
  }
  return acc ? *acc : createImm(S.builder, loc, 0);
}

FailureOr<Value> materializeIxsMulFactor(WaveAMDMachineSelector &S,
                                         ::ixs_node *node, uint32_t i,
                                         Operation *user,
                                         const llvm::StringMap<Value> &subs) {
  int32_t exp = ixs_node_mul_factor_exp(node, i);
  if (exp <= 0)
    return user->emitError(
        "wave.index_expr selection rejects non-positive mul exponent");
  FailureOr<Value> base = materializeIndexExprNode(
      S, ixs_node_mul_factor_base(node, i), user, subs);
  if (failed(base))
    return failure();
  Value pow = *base;
  for (int32_t e = 1; e < exp; ++e)
    pow = S.mulIndexValues(user->getLoc(), pow, *base);
  return pow;
}

// MUL = coeff * prod(base[i] ^ exp[i]). Skip the coeff when it's 1.
FailureOr<Value> materializeIxsMul(WaveAMDMachineSelector &S, ::ixs_node *node,
                                   Operation *user,
                                   const llvm::StringMap<Value> &subs) {
  Location loc = user->getLoc();
  ::ixs_node *coeff = ixs_node_mul_coeff(node);
  std::optional<int64_t> coeffInt = staticIntLiteral(coeff);
  std::optional<Value> acc;
  if (!coeffInt || *coeffInt != 1) {
    FailureOr<Value> seed = materializeIndexExprNode(S, coeff, user, subs);
    if (failed(seed))
      return failure();
    acc = *seed;
  }
  uint32_t nfactors = ixs_node_mul_nfactors(node);
  for (uint32_t i = 0; i < nfactors; ++i) {
    FailureOr<Value> pow = materializeIxsMulFactor(S, node, i, user, subs);
    if (failed(pow))
      return failure();
    if (!acc) {
      acc = *pow;
    } else if (S.isUniformValue(*acc) && S.isUniformValue(*pow)) {
      acc = S.mulUniformValues(loc, *acc, *pow);
    } else {
      acc = S.mulIndexValues(loc, *acc, *pow);
    }
  }
  return acc ? *acc : createImm(S.builder, loc, 1);
}

// Materialize `node * factor` so every rational coefficient in `node`
// becomes an integer. ixsimpl does the algebra; we just compose and
// re-materialize.
FailureOr<Value> materializeScaledInteger(WaveAMDMachineSelector &S,
                                          ::ixs_node *node, int64_t factor,
                                          Operation *user,
                                          const llvm::StringMap<Value> &subs) {
  auto factorExpr = sym::composeExprInt(S.symbolStore(), factor);
  if (failed(factorExpr))
    return user->emitError("failed to compose integer factor");
  auto scaled = sym::composeExprBinary(S.symbolStore(), sym::ExprHandle(node),
                                       sym::ExprBinaryOp::Mul, *factorExpr);
  if (failed(scaled))
    return user->emitError("failed to scale floor/ceil child");
  return materializeIndexExprNode(S, scaled->raw(), user, subs);
}

// floor(expr): scale `expr` by its LCM denominator to get an integer-
// valued sub-expression, then divide by the denominator. Power-of-two
// denominators only.
FailureOr<Value> materializeIxsFloor(WaveAMDMachineSelector &S,
                                     ::ixs_node *node, Operation *user,
                                     const llvm::StringMap<Value> &subs) {
  ::ixs_node *child = ixs_node_unary_arg(node);
  std::optional<int64_t> den = collectDenominator(child);
  if (!den)
    return user->emitError("wave.index_expr denominator overflows i64");
  if (*den == 1)
    return materializeIndexExprNode(S, child, user, subs);
  if (*den <= 0 || (*den & (*den - 1)) != 0)
    return user->emitError(
               "wave.index_expr floor needs a power-of-two denominator (got ")
           << *den << ")";
  FailureOr<Value> scaled =
      materializeScaledInteger(S, child, *den, user, subs);
  if (failed(scaled))
    return failure();
  return S.shrPow2(user->getLoc(), *scaled, llvm::Log2_64(*den));
}

// ceil(expr) on positive divisors via the (x + d - 1) // d identity.
FailureOr<Value> materializeIxsCeil(WaveAMDMachineSelector &S, ::ixs_node *node,
                                    Operation *user,
                                    const llvm::StringMap<Value> &subs) {
  ::ixs_node *child = ixs_node_unary_arg(node);
  std::optional<int64_t> den = collectDenominator(child);
  if (!den)
    return user->emitError("wave.index_expr denominator overflows i64");
  if (*den == 1)
    return materializeIndexExprNode(S, child, user, subs);
  if (*den <= 0 || (*den & (*den - 1)) != 0)
    return user->emitError(
               "wave.index_expr ceil needs a power-of-two denominator (got ")
           << *den << ")";
  FailureOr<Value> scaled =
      materializeScaledInteger(S, child, *den, user, subs);
  if (failed(scaled))
    return failure();
  Value bias = createImm(S.builder, user->getLoc(), *den - 1);
  Value biased = S.addByteOffsets(user->getLoc(), *scaled, bias);
  return S.shrPow2(user->getLoc(), biased, llvm::Log2_64(*den));
}

// mod(lhs, rhs). Only power-of-two `rhs` is supported: the modulus is
// a bitwise AND with `rhs - 1`.
FailureOr<Value> materializeIxsMod(WaveAMDMachineSelector &S, ::ixs_node *node,
                                   Operation *user,
                                   const llvm::StringMap<Value> &subs) {
  ::ixs_node *lhs = ixs_node_binary_lhs(node);
  ::ixs_node *rhs = ixs_node_binary_rhs(node);
  std::optional<int64_t> rhsInt = staticIntLiteral(rhs);
  if (!rhsInt || *rhsInt <= 0 || (*rhsInt & (*rhsInt - 1)) != 0)
    return user->emitError(
        "wave.index_expr mod needs a power-of-two integer divisor");
  FailureOr<Value> lhsValue = materializeIndexExprNode(S, lhs, user, subs);
  if (failed(lhsValue))
    return failure();
  return S.andMask(user->getLoc(), *lhsValue, *rhsInt - 1);
}

TermKind classifyAdd(WaveAMDMachineSelector &S, ::ixs_node *node,
                     const llvm::StringMap<TermKind> &symKinds) {
  TermKind k = classifyTerm(S, ixs_node_add_coeff(node), symKinds);
  uint32_t n = ixs_node_add_nterms(node);
  for (uint32_t i = 0; i < n; ++i)
    k = std::max(k, classifyTerm(S, ixs_node_add_term(node, i), symKinds));
  return k;
}

TermKind classifyMul(WaveAMDMachineSelector &S, ::ixs_node *node,
                     const llvm::StringMap<TermKind> &symKinds) {
  TermKind k = classifyTerm(S, ixs_node_mul_coeff(node), symKinds);
  uint32_t n = ixs_node_mul_nfactors(node);
  for (uint32_t i = 0; i < n; ++i)
    k = std::max(k,
                 classifyTerm(S, ixs_node_mul_factor_base(node, i), symKinds));
  return k;
}

std::optional<int64_t> evalConstantAdd(WaveAMDMachineSelector &S,
                                       ::ixs_node *node) {
  std::optional<int64_t> acc = evalConstantNode(S, ixs_node_add_coeff(node));
  if (!acc)
    return std::nullopt;
  uint32_t n = ixs_node_add_nterms(node);
  for (uint32_t i = 0; i < n; ++i) {
    std::optional<int64_t> tc =
        evalConstantNode(S, ixs_node_add_term_coeff(node, i));
    std::optional<int64_t> t = evalConstantNode(S, ixs_node_add_term(node, i));
    if (!tc || !t)
      return std::nullopt;
    acc = llvm::checkedMulAdd(*tc, *t, *acc);
    if (!acc)
      return std::nullopt;
  }
  return acc;
}

std::optional<int64_t> evalConstantMul(WaveAMDMachineSelector &S,
                                       ::ixs_node *node) {
  std::optional<int64_t> acc = evalConstantNode(S, ixs_node_mul_coeff(node));
  if (!acc)
    return std::nullopt;
  uint32_t n = ixs_node_mul_nfactors(node);
  for (uint32_t i = 0; i < n; ++i) {
    int32_t exp = ixs_node_mul_factor_exp(node, i);
    if (exp < 0)
      return std::nullopt;
    std::optional<int64_t> base =
        evalConstantNode(S, ixs_node_mul_factor_base(node, i));
    if (!base)
      return std::nullopt;
    int64_t pow = 1;
    for (int32_t e = 0; e < exp; ++e) {
      std::optional<int64_t> next = llvm::checkedMul(pow, *base);
      if (!next)
        return std::nullopt;
      pow = *next;
    }
    acc = llvm::checkedMul(*acc, pow);
    if (!acc)
      return std::nullopt;
  }
  return acc;
}

// Constant-fold IXS_FLOOR / IXS_CEIL by scaling the child to integer
// via ixsimpl, then dividing.
std::optional<int64_t> evalConstantFloorOrCeil(WaveAMDMachineSelector &S,
                                               ::ixs_node *node) {
  ::ixs_node *child = ixs_node_unary_arg(node);
  std::optional<int64_t> den = collectDenominator(child);
  if (!den || *den <= 0)
    return std::nullopt;
  auto factor = sym::composeExprInt(S.symbolStore(), *den);
  if (failed(factor))
    return std::nullopt;
  auto scaled = sym::composeExprBinary(S.symbolStore(), sym::ExprHandle(child),
                                       sym::ExprBinaryOp::Mul, *factor);
  if (failed(scaled))
    return std::nullopt;
  std::optional<int64_t> num =
      evalConstantNode(S, const_cast<::ixs_node *>(scaled->raw()));
  if (!num)
    return std::nullopt;
  return ixs_node_tag(node) == IXS_FLOOR ? floorDiv(*num, *den)
                                         : ceilDiv(*num, *den);
}

std::optional<int64_t> evalConstantMod(WaveAMDMachineSelector &S,
                                       ::ixs_node *node) {
  std::optional<int64_t> lhs = evalConstantNode(S, ixs_node_binary_lhs(node));
  std::optional<int64_t> rhs = evalConstantNode(S, ixs_node_binary_rhs(node));
  if (!lhs || !rhs || divOverflows(*lhs, *rhs))
    return std::nullopt;
  int64_t r = *lhs % *rhs;
  if (r != 0 && (r < 0) != (*rhs < 0))
    r += *rhs;
  return r;
}

// Materialize `term_coeff * term` as a single Value, skipping the
// multiply when the coefficient is trivially 1. Uniform-only summands
// route through SGPR-domain mul so the result can ride the soffset
// slot.
FailureOr<Value> materializeSummand(WaveAMDMachineSelector &S, ::ixs_node *term,
                                    ::ixs_node *termCoeff, Operation *user,
                                    const llvm::StringMap<Value> &subs,
                                    bool uniform) {
  FailureOr<Value> termValue = materializeIndexExprNode(S, term, user, subs);
  if (failed(termValue))
    return failure();
  std::optional<int64_t> coeffInt =
      termCoeff ? staticIntLiteral(termCoeff) : std::optional<int64_t>{1};
  if (!termCoeff || (coeffInt && *coeffInt == 1))
    return *termValue;
  FailureOr<Value> coeffValue =
      materializeIndexExprNode(S, termCoeff, user, subs);
  if (failed(coeffValue))
    return failure();
  Location loc = user->getLoc();
  if (uniform && S.isUniformValue(*coeffValue) && S.isUniformValue(*termValue))
    return S.mulUniformValues(loc, *coeffValue, *termValue);
  return S.mulIndexValues(loc, *coeffValue, *termValue);
}

// Literal-fold fast path for a Const-kind summand.
FailureOr<bool> tryConstFoldSummand(WaveAMDMachineSelector &S, ::ixs_node *term,
                                    ::ixs_node *termCoeff, TermKind kind,
                                    Operation *user, OffsetTriple &triple) {
  if (kind != TermKind::Const)
    return false;
  std::optional<int64_t> termInt = evalConstantNode(S, term);
  std::optional<int64_t> coeffInt =
      termCoeff ? staticIntLiteral(termCoeff) : std::optional<int64_t>{1};
  if (!termInt || !coeffInt)
    return user->emitError(
        "wave.index_expr constant summand is not representable as i64");
  std::optional<int64_t> folded =
      llvm::checkedMulAdd(*coeffInt, *termInt, triple.instOffset);
  if (!folded)
    return user->emitError(
        "wave.index_expr constant summand is not representable as i64");
  triple.instOffset = *folded;
  return true;
}

// Route one (optionally `term_coeff *`) summand into `triple`'s
// matching slot. Const summands fold into `instOffset`; uniform
// summands that materialize to an SGPR / imm join `soffset`;
// everything else lands in `voffset`. The symbolic form joins the
// matching `*Expr` slot so the emit-time width check sees the full
// bucket.
LogicalResult bucketizeSummand(WaveAMDMachineSelector &S, ::ixs_node *term,
                               ::ixs_node *termCoeff, Operation *user,
                               const llvm::StringMap<Value> &subs,
                               const llvm::StringMap<TermKind> &symKinds,
                               OffsetTriple &triple) {
  TermKind kind = classifyTerm(S, term, symKinds);
  if (termCoeff)
    kind = std::max(kind, classifyTerm(S, termCoeff, symKinds));
  FailureOr<bool> constFolded =
      tryConstFoldSummand(S, term, termCoeff, kind, user, triple);
  if (failed(constFolded))
    return failure();
  if (*constFolded)
    return success();
  FailureOr<Value> summand = materializeSummand(
      S, term, termCoeff, user, subs, /*uniform=*/kind == TermKind::Uniform);
  if (failed(summand))
    return failure();
  if (std::optional<int64_t> imm = S.getImmediateValue(*summand)) {
    std::optional<int64_t> sum = llvm::checkedAdd(triple.instOffset, *imm);
    if (!sum)
      return user->emitError("wave.index_expr constant offset overflows i64");
    triple.instOffset = *sum;
    return success();
  }
  const ::ixs_node *summandExpr = S.scaleBucketExpr(term, termCoeff);
  Location loc = user->getLoc();
  if (kind == TermKind::Uniform && S.isUniformValue(*summand)) {
    triple.soffset = S.addUniformBytes(loc, triple.soffset, *summand);
    triple.soffsetExpr = S.appendBucketExpr(triple.soffsetExpr, summandExpr);
    return success();
  }
  triple.voffset = triple.voffset
                       ? S.addByteOffsets(loc, triple.voffset, *summand)
                       : *summand;
  triple.voffsetExpr = S.appendBucketExpr(triple.voffsetExpr, summandExpr);
  return success();
}

struct AddressPlanAddend {
  sym::ExprHandle expr;
  TermKind kind = TermKind::Lane;
  bool taken = false;
};

static bool isOneExpr(sym::ExprHandle expr) {
  if (!expr)
    return false;
  ::ixs_node *node = const_cast<::ixs_node *>(expr.raw());
  std::optional<int64_t> value = staticIntLiteral(node);
  return value && *value == 1;
}

static bool isZeroExpr(sym::ExprHandle expr) {
  if (!expr)
    return true;
  ::ixs_node *node = const_cast<::ixs_node *>(expr.raw());
  std::optional<int64_t> value = staticIntLiteral(node);
  return value && *value == 0;
}

static bool instOffsetFits(int64_t value,
                           const waveamdmachine::AddressFieldSpec &spec) {
  std::pair<int64_t, int64_t> range = waveamdmachine::instOffsetRange(spec);
  return value >= range.first && value <= range.second;
}

static FailureOr<sym::ExprHandle>
simplifyPlanExpr(WaveAMDMachineSelector &S, sym::ExprHandle expr,
                 ArrayRef<sym::PredHandle> assumptions) {
  FailureOr<sym::ExprHandle> simplified =
      sym::simplifyExpr(S.symbolStore(), expr, assumptions);
  if (succeeded(simplified))
    return *simplified;
  return expr;
}

static FailureOr<sym::ExprHandle>
scalePlanAddend(WaveAMDMachineSelector &S, ::ixs_node *term,
                ::ixs_node *termCoeff, ArrayRef<sym::PredHandle> assumptions) {
  sym::ExprHandle termExpr(term);
  if (!termCoeff || isOneExpr(sym::ExprHandle(termCoeff)))
    return simplifyPlanExpr(S, termExpr, assumptions);
  FailureOr<sym::ExprHandle> scaled =
      sym::composeExprBinary(S.symbolStore(), sym::ExprHandle(termCoeff),
                             sym::ExprBinaryOp::Mul, termExpr);
  if (failed(scaled))
    return failure();
  return simplifyPlanExpr(S, *scaled, assumptions);
}

static LogicalResult appendPlanExpr(WaveAMDMachineSelector &S,
                                    sym::ExprHandle add,
                                    ArrayRef<sym::PredHandle> assumptions,
                                    sym::ExprHandle &acc) {
  if (isZeroExpr(add))
    return success();
  if (!acc) {
    acc = add;
    return success();
  }
  FailureOr<sym::ExprHandle> joined =
      sym::composeExprBinary(S.symbolStore(), acc, sym::ExprBinaryOp::Add, add);
  if (failed(joined))
    return failure();
  FailureOr<sym::ExprHandle> simplified =
      simplifyPlanExpr(S, *joined, assumptions);
  if (failed(simplified))
    return failure();
  acc = *simplified;
  return success();
}

static TermKind
classifyScaledAddend(WaveAMDMachineSelector &S, ::ixs_node *term,
                     ::ixs_node *termCoeff,
                     const llvm::StringMap<TermKind> &symKinds) {
  TermKind kind = classifyTerm(S, term, symKinds);
  if (termCoeff)
    kind = std::max(kind, classifyTerm(S, termCoeff, symKinds));
  return kind;
}

static LogicalResult
collectPlanAddend(WaveAMDMachineSelector &S, ::ixs_node *term,
                  ::ixs_node *termCoeff,
                  const llvm::StringMap<TermKind> &symKinds,
                  ArrayRef<sym::PredHandle> assumptions,
                  SmallVectorImpl<AddressPlanAddend> &addends) {
  FailureOr<sym::ExprHandle> scaled =
      scalePlanAddend(S, term, termCoeff, assumptions);
  if (failed(scaled))
    return failure();
  if (isZeroExpr(*scaled))
    return success();
  addends.push_back(
      {*scaled, classifyScaledAddend(S, term, termCoeff, symKinds), false});
  return success();
}

static LogicalResult
collectPlanAddends(WaveAMDMachineSelector &S, ::ixs_node *node,
                   const llvm::StringMap<TermKind> &symKinds,
                   ArrayRef<sym::PredHandle> assumptions,
                   SmallVectorImpl<AddressPlanAddend> &addends) {
  if (ixs_node_tag(node) != IXS_ADD)
    return collectPlanAddend(S, node, /*termCoeff=*/nullptr, symKinds,
                             assumptions, addends);
  sym::ExprHandle coeff(ixs_node_add_coeff(node));
  if (!isZeroExpr(coeff))
    addends.push_back({coeff, TermKind::Const, false});
  uint32_t nterms = ixs_node_add_nterms(node);
  for (uint32_t i = 0; i < nterms; ++i) {
    if (failed(collectPlanAddend(S, ixs_node_add_term(node, i),
                                 ixs_node_add_term_coeff(node, i), symKinds,
                                 assumptions, addends)))
      return failure();
  }
  return success();
}

static LogicalResult takeInstOffsetAddends(
    WaveAMDMachineSelector &S, const waveamdmachine::AddressFieldSpec &spec,
    SmallVectorImpl<AddressPlanAddend> &addends, AddressPlan &plan) {
  for (AddressPlanAddend &addend : addends) {
    if (addend.taken || addend.kind != TermKind::Const)
      continue;
    ::ixs_node *node = const_cast<::ixs_node *>(addend.expr.raw());
    std::optional<int64_t> value = evalConstantNode(S, node);
    std::optional<int64_t> next =
        value ? llvm::checkedAdd(plan.instOffset, *value) : std::nullopt;
    if (next && instOffsetFits(*next, spec)) {
      plan.instOffset = *next;
      addend.taken = true;
      continue;
    }
    if (failed(appendPlanExpr(S, addend.expr, plan.assumptions,
                              plan.fullAddressRemainderExpr)))
      return failure();
    addend.taken = true;
  }
  return success();
}

static void takeFirstPlanSlot(WaveAMDMachineSelector &S, TermKind kind,
                              SmallVectorImpl<AddressPlanAddend> &addends,
                              AddressPlan &plan, sym::ExprHandle &slotExpr) {
  if (slotExpr)
    return;
  for (AddressPlanAddend &addend : addends) {
    if (addend.taken || addend.kind != kind)
      continue;
    if (!S.slotFitsU32(addend.expr.raw(), plan.assumptions))
      continue;
    slotExpr = addend.expr;
    addend.taken = true;
    return;
  }
}

static LogicalResult
appendRemainingAddends(WaveAMDMachineSelector &S,
                       SmallVectorImpl<AddressPlanAddend> &addends,
                       AddressPlan &plan) {
  for (AddressPlanAddend &addend : addends) {
    if (addend.taken)
      continue;
    if (failed(appendPlanExpr(S, addend.expr, plan.assumptions,
                              plan.fullAddressRemainderExpr)))
      return failure();
    addend.taken = true;
  }
  return success();
}

} // namespace

// ---- public surface (declared in WaveAMDMachineSelector.h) ----------------

std::optional<int64_t> collectDenominator(::ixs_node *node) {
  switch (ixs_node_tag(node)) {
  case IXS_RAT: {
    int64_t den = ixs_node_rat_den(node);
    return den > 0 ? den : 1;
  }
  case IXS_ADD: {
    std::optional<int64_t> d = collectDenominator(ixs_node_add_coeff(node));
    uint32_t n = ixs_node_add_nterms(node);
    for (uint32_t i = 0; i < n; ++i) {
      d = checkedLCM(d, collectDenominator(ixs_node_add_term_coeff(node, i)));
      d = checkedLCM(d, collectDenominator(ixs_node_add_term(node, i)));
    }
    return d;
  }
  case IXS_MUL: {
    std::optional<int64_t> d = collectDenominator(ixs_node_mul_coeff(node));
    uint32_t n = ixs_node_mul_nfactors(node);
    for (uint32_t i = 0; i < n; ++i)
      d = checkedLCM(d, collectDenominator(ixs_node_mul_factor_base(node, i)));
    return d;
  }
  default:
    // INT / SYM are integer-valued leaves; FLOOR / CEIL / MOD are
    // integer-valued by construction.
    return 1;
  }
}

FailureOr<Value> materializeIndexExprNode(WaveAMDMachineSelector &S,
                                          const ::ixs_node *cnode,
                                          Operation *user,
                                          const llvm::StringMap<Value> &subs) {
  // ixsimpl introspection accessors take non-const ixs_node *.
  auto *node = const_cast<::ixs_node *>(cnode);
  switch (ixs_node_tag(node)) {
  case IXS_INT:
    return createImm(S.builder, user->getLoc(), ixs_node_int_val(node));
  case IXS_RAT:
    return materializeIxsRat(S, node, user);
  case IXS_SYM:
    return materializeIxsSym(S, node, user, subs);
  case IXS_ADD:
    return materializeIxsAdd(S, node, user, subs);
  case IXS_MUL:
    return materializeIxsMul(S, node, user, subs);
  case IXS_FLOOR:
    return materializeIxsFloor(S, node, user, subs);
  case IXS_CEIL:
    return materializeIxsCeil(S, node, user, subs);
  case IXS_MOD:
    return materializeIxsMod(S, node, user, subs);
  default:
    return user->emitError(
               "wave.index_expr selection does not support node tag ")
           << static_cast<int>(ixs_node_tag(node));
  }
}

TermKind classifyTerm(WaveAMDMachineSelector &S, ::ixs_node *node,
                      const llvm::StringMap<TermKind> &symKinds) {
  switch (ixs_node_tag(node)) {
  case IXS_INT:
  case IXS_RAT:
    return TermKind::Const;
  case IXS_SYM: {
    StringRef name = ixs_node_sym_name(node);
    auto it = symKinds.find(name);
    return it == symKinds.end() ? TermKind::Lane : it->second;
  }
  case IXS_ADD:
    return classifyAdd(S, node, symKinds);
  case IXS_MUL:
    return classifyMul(S, node, symKinds);
  case IXS_FLOOR:
  case IXS_CEIL:
    return classifyTerm(S, ixs_node_unary_arg(node), symKinds);
  case IXS_MOD:
    return std::max(classifyTerm(S, ixs_node_binary_lhs(node), symKinds),
                    classifyTerm(S, ixs_node_binary_rhs(node), symKinds));
  default:
    return TermKind::Lane;
  }
}

// Constant-fold a node that classifyTerm decided is Const, returning
// its int value when expressible without materialization. ADD / MUL /
// FLOOR / CEIL / MOD recurse here; non-literal leaves break the fold.
std::optional<int64_t> evalConstantNode(WaveAMDMachineSelector &S,
                                        ::ixs_node *node) {
  if (std::optional<int64_t> v = staticIntLiteral(node))
    return v;
  switch (ixs_node_tag(node)) {
  case IXS_ADD:
    return evalConstantAdd(S, node);
  case IXS_MUL:
    return evalConstantMul(S, node);
  case IXS_FLOOR:
  case IXS_CEIL:
    return evalConstantFloorOrCeil(S, node);
  case IXS_MOD:
    return evalConstantMod(S, node);
  default:
    return std::nullopt;
  }
}

FailureOr<AddressPlan>
planAddressFields(WaveAMDMachineSelector &S, const PointerOffset &offset,
                  const waveamdmachine::AddressFieldSpec &spec) {
  AddressPlan plan;
  plan.bindings = offset.bindings;
  plan.assumptions = offset.assumptions;
  if (!offset.expr)
    return plan;

  llvm::StringMap<TermKind> symKinds;
  for (const PointerOffsetBinding &binding : offset.bindings)
    symKinds[binding.name] = binding.kind;

  SmallVector<AddressPlanAddend, 8> addends;
  ::ixs_node *node = const_cast<::ixs_node *>(offset.expr.raw());
  if (failed(collectPlanAddends(S, node, symKinds, plan.assumptions, addends)))
    return failure();
  if (failed(takeInstOffsetAddends(S, spec, addends, plan)))
    return failure();
  if (spec.hasSoffset)
    takeFirstPlanSlot(S, TermKind::Uniform, addends, plan, plan.soffsetExpr);
  takeFirstPlanSlot(S, TermKind::Lane, addends, plan, plan.voffsetExpr);
  if (failed(appendRemainingAddends(S, addends, plan)))
    return failure();
  return plan;
}

// Bucketize each top-level summand of `node` into `triple`. ADD
// structure: coeff + sum(term_coeff[i] * term[i]). For a non-ADD
// node the whole expression is treated as a single summand.
LogicalResult bucketize(WaveAMDMachineSelector &S, ::ixs_node *node,
                        Operation *user, const llvm::StringMap<Value> &subs,
                        const llvm::StringMap<TermKind> &symKinds,
                        OffsetTriple &triple) {
  if (ixs_node_tag(node) != IXS_ADD)
    return bucketizeSummand(S, node, /*explicitCoeff=*/nullptr, user, subs,
                            symKinds, triple);
  ::ixs_node *coeff = ixs_node_add_coeff(node);
  std::optional<int64_t> coeffInt = staticIntLiteral(coeff);
  if (!coeffInt)
    return user->emitError(
        "wave.index_expr bucketizer expects an integer ADD coefficient");
  std::optional<int64_t> instOffset =
      llvm::checkedAdd(triple.instOffset, *coeffInt);
  if (!instOffset)
    return user->emitError("wave.index_expr constant offset overflows i64");
  triple.instOffset = *instOffset;
  uint32_t nterms = ixs_node_add_nterms(node);
  for (uint32_t i = 0; i < nterms; ++i) {
    ::ixs_node *termCoeff = ixs_node_add_term_coeff(node, i);
    ::ixs_node *term = ixs_node_add_term(node, i);
    if (failed(
            bucketizeSummand(S, term, termCoeff, user, subs, symKinds, triple)))
      return failure();
  }
  return success();
}

} // namespace mlir::wave::wmsel
