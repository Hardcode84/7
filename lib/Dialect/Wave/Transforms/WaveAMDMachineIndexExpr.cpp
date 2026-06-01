//===- WaveAMDMachineIndexExpr.cpp - `wave.index_expr` lowering
//--------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// IXS-AST materializer, classifier, and address planner.
// Per-op selection stays in `WaveAMDMachine.cpp`.
//
//===----------------------------------------------------------------------===//

#include "WaveAMDMachineSelector.h"

#include "llvm/Support/CheckedArithmetic.h"
#include "llvm/Support/MathExtras.h"

#include <optional>

using namespace mlir;
using namespace mlir::wave;
using namespace mlir::waveamd;
using namespace mlir::wave::wmsel;

namespace mlir::wave::wmsel {

namespace {

// Integer or unit-denominator rational; nullopt otherwise.
std::optional<int64_t> staticIntLiteral(sym::ExprHandle expr) {
  return sym::getIntegerLiteralValue(expr);
}

FailureOr<Value> materializeRational(WaveAMDMachineSelector &S,
                                     sym::ExprHandle expr, Operation *user) {
  std::optional<sym::RationalLiteral> rational =
      sym::ExprView(expr).getRational();
  if (!rational || rational->denominator != 1)
    return user->emitError(
        "wave.index_expr selection rejects non-integer rational");
  return createImm(S.builder, user->getLoc(), rational->numerator);
}

FailureOr<Value> materializeSymbol(WaveAMDMachineSelector &,
                                   sym::ExprHandle expr, Operation *user,
                                   const llvm::StringMap<Value> &subs) {
  StringRef name = sym::ExprView(expr).getSymbolName();
  auto it = subs.find(name);
  if (it == subs.end())
    return user->emitError("wave.index_expr leaf '")
           << name << "' has no binding";
  return it->second;
}

FailureOr<Value> materializeAddTerm(WaveAMDMachineSelector &S,
                                    sym::AddTerm addTerm, Operation *user,
                                    const llvm::StringMap<Value> &subs) {
  Location loc = user->getLoc();
  FailureOr<Value> term = materializeIndexExprNode(S, addTerm.term, user, subs);
  if (failed(term))
    return failure();
  std::optional<int64_t> tcInt = staticIntLiteral(addTerm.coefficient);
  if (tcInt && *tcInt == 1)
    return *term;
  FailureOr<Value> tcVal =
      materializeIndexExprNode(S, addTerm.coefficient, user, subs);
  if (failed(tcVal))
    return failure();
  if (S.isUniformValue(*tcVal) && S.isUniformValue(*term))
    return S.mulUniformValues(loc, *tcVal, *term);
  return S.mulIndexValues(loc, *tcVal, *term);
}

// ADD = coeff + sum(term_coeff[i] * term[i]). Skip materializing coeff
// when it's 0 and term_coeff[i] when it's 1.
FailureOr<Value> materializeAdd(WaveAMDMachineSelector &S, sym::ExprHandle expr,
                                Operation *user,
                                const llvm::StringMap<Value> &subs) {
  Location loc = user->getLoc();
  sym::ExprView view(expr);
  sym::ExprHandle coeff = view.getAddConstant();
  std::optional<int64_t> coeffInt = staticIntLiteral(coeff);
  std::optional<Value> acc;
  if (!coeffInt || *coeffInt != 0) {
    FailureOr<Value> seed = materializeIndexExprNode(S, coeff, user, subs);
    if (failed(seed))
      return failure();
    acc = *seed;
  }
  uint32_t nterms = view.getAddTermCount();
  for (uint32_t i = 0; i < nterms; ++i) {
    FailureOr<Value> scaled =
        materializeAddTerm(S, view.getAddTerm(i), user, subs);
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

FailureOr<Value> materializeMulFactor(WaveAMDMachineSelector &S,
                                      sym::MulFactor factor, Operation *user,
                                      const llvm::StringMap<Value> &subs) {
  int32_t exp = factor.exponent;
  if (exp <= 0)
    return user->emitError(
        "wave.index_expr selection rejects non-positive mul exponent");
  FailureOr<Value> base = materializeIndexExprNode(S, factor.base, user, subs);
  if (failed(base))
    return failure();
  Value pow = *base;
  for (int32_t e = 1; e < exp; ++e)
    pow = S.mulIndexValues(user->getLoc(), pow, *base);
  return pow;
}

// MUL = coeff * prod(base[i] ^ exp[i]). Skip the coeff when it's 1.
FailureOr<Value> materializeMul(WaveAMDMachineSelector &S, sym::ExprHandle expr,
                                Operation *user,
                                const llvm::StringMap<Value> &subs) {
  Location loc = user->getLoc();
  sym::ExprView view(expr);
  sym::ExprHandle coeff = view.getMulCoefficient();
  std::optional<int64_t> coeffInt = staticIntLiteral(coeff);
  std::optional<Value> acc;
  if (!coeffInt || *coeffInt != 1) {
    FailureOr<Value> seed = materializeIndexExprNode(S, coeff, user, subs);
    if (failed(seed))
      return failure();
    acc = *seed;
  }
  uint32_t nfactors = view.getMulFactorCount();
  for (uint32_t i = 0; i < nfactors; ++i) {
    FailureOr<Value> pow =
        materializeMulFactor(S, view.getMulFactor(i), user, subs);
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
                                          sym::ExprHandle expr, int64_t factor,
                                          Operation *user,
                                          const llvm::StringMap<Value> &subs) {
  auto factorExpr = sym::composeExprInt(S.symbolStore(), factor);
  if (failed(factorExpr))
    return user->emitError("failed to compose integer factor");
  auto scaled = sym::composeExprBinary(S.symbolStore(), expr,
                                       sym::ExprBinaryOp::Mul, *factorExpr);
  if (failed(scaled))
    return user->emitError("failed to scale floor/ceil child");
  return materializeIndexExprNode(S, *scaled, user, subs);
}

// floor(expr): scale `expr` by its LCM denominator to get an integer-
// valued sub-expression, then divide by the denominator. Power-of-two
// denominators only.
FailureOr<Value> materializeFloor(WaveAMDMachineSelector &S,
                                  sym::ExprHandle expr, Operation *user,
                                  const llvm::StringMap<Value> &subs) {
  sym::ExprHandle child = sym::ExprView(expr).getUnaryArg();
  std::optional<int64_t> den = sym::collectDenominator(child);
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
FailureOr<Value> materializeCeil(WaveAMDMachineSelector &S,
                                 sym::ExprHandle expr, Operation *user,
                                 const llvm::StringMap<Value> &subs) {
  sym::ExprHandle child = sym::ExprView(expr).getUnaryArg();
  std::optional<int64_t> den = sym::collectDenominator(child);
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
FailureOr<Value> materializeMod(WaveAMDMachineSelector &S, sym::ExprHandle expr,
                                Operation *user,
                                const llvm::StringMap<Value> &subs) {
  sym::ExprView view(expr);
  sym::ExprHandle lhs = view.getBinaryLhs();
  sym::ExprHandle rhs = view.getBinaryRhs();
  std::optional<int64_t> rhsInt = staticIntLiteral(rhs);
  if (!rhsInt || *rhsInt <= 0 || (*rhsInt & (*rhsInt - 1)) != 0)
    return user->emitError(
        "wave.index_expr mod needs a power-of-two integer divisor");
  FailureOr<Value> lhsValue = materializeIndexExprNode(S, lhs, user, subs);
  if (failed(lhsValue))
    return failure();
  return S.andMask(user->getLoc(), *lhsValue, *rhsInt - 1);
}

std::optional<Value> foldXorImmediates(WaveAMDMachineSelector &S, Location loc,
                                       Value lhs, Value rhs) {
  std::optional<int64_t> lhsImm = S.getImmediateValue(lhs);
  std::optional<int64_t> rhsImm = S.getImmediateValue(rhs);
  if (lhsImm && rhsImm)
    return createImm(S.builder, loc, *lhsImm ^ *rhsImm);
  if (lhsImm && *lhsImm == 0)
    return rhs;
  if (rhsImm && *rhsImm == 0)
    return lhs;
  return std::nullopt;
}

Value materializeUniformXor(WaveAMDMachineSelector &S, Location loc, Value lhs,
                            Value rhs) {
  return waveamdmachine::SXorB32Op::create(
             S.builder, loc,
             getRegType(S.builder.getContext(), waveamdmachine::RegClass::SGPR),
             getSCCType(S.builder.getContext()), lhs, rhs)
      .getResult();
}

Value materializeLaneXor(WaveAMDMachineSelector &S, Location loc, Value lhs,
                         Value rhs) {
  return waveamdmachine::VXorB32Op::create(
             S.builder, loc,
             getRegType(S.builder.getContext(), waveamdmachine::RegClass::VGPR),
             lhs, rhs)
      .getResult();
}

FailureOr<Value> materializeXor(WaveAMDMachineSelector &S, sym::ExprHandle expr,
                                Operation *user,
                                const llvm::StringMap<Value> &subs) {
  Location loc = user->getLoc();
  sym::ExprView view(expr);
  FailureOr<Value> lhs =
      materializeIndexExprNode(S, view.getBinaryLhs(), user, subs);
  FailureOr<Value> rhs =
      materializeIndexExprNode(S, view.getBinaryRhs(), user, subs);
  if (failed(lhs) || failed(rhs))
    return failure();
  if (std::optional<Value> folded = foldXorImmediates(S, loc, *lhs, *rhs))
    return *folded;
  if (S.isUniformValue(*lhs) && S.isUniformValue(*rhs))
    return materializeUniformXor(S, loc, *lhs, *rhs);
  return materializeLaneXor(S, loc, *lhs, *rhs);
}

TermKind classifyAdd(WaveAMDMachineSelector &S, sym::ExprHandle expr,
                     const llvm::StringMap<TermKind> &symKinds) {
  sym::ExprView view(expr);
  TermKind k = classifyTerm(S, view.getAddConstant(), symKinds);
  uint32_t n = view.getAddTermCount();
  for (uint32_t i = 0; i < n; ++i)
    k = std::max(k, classifyTerm(S, view.getAddTerm(i).term, symKinds));
  return k;
}

TermKind classifyMul(WaveAMDMachineSelector &S, sym::ExprHandle expr,
                     const llvm::StringMap<TermKind> &symKinds) {
  sym::ExprView view(expr);
  TermKind k = classifyTerm(S, view.getMulCoefficient(), symKinds);
  uint32_t n = view.getMulFactorCount();
  for (uint32_t i = 0; i < n; ++i)
    k = std::max(k, classifyTerm(S, view.getMulFactor(i).base, symKinds));
  return k;
}

struct AddressPlanAddend {
  sym::ExprHandle expr;
  TermKind kind = TermKind::Lane;
};

static bool isOneExpr(sym::ExprHandle expr) {
  if (!expr)
    return false;
  std::optional<int64_t> value = staticIntLiteral(expr);
  return value && *value == 1;
}

static bool isZeroExpr(sym::ExprHandle expr) {
  if (!expr)
    return true;
  std::optional<int64_t> value = staticIntLiteral(expr);
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
scalePlanAddend(WaveAMDMachineSelector &S, sym::ExprHandle term,
                sym::ExprHandle termCoeff,
                ArrayRef<sym::PredHandle> assumptions) {
  if (!termCoeff || isOneExpr(termCoeff))
    return simplifyPlanExpr(S, term, assumptions);
  FailureOr<sym::ExprHandle> scaled = sym::composeExprBinary(
      S.symbolStore(), termCoeff, sym::ExprBinaryOp::Mul, term);
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
classifyScaledAddend(WaveAMDMachineSelector &S, sym::ExprHandle term,
                     sym::ExprHandle termCoeff,
                     const llvm::StringMap<TermKind> &symKinds) {
  TermKind kind = classifyTerm(S, term, symKinds);
  if (termCoeff)
    kind = std::max(kind, classifyTerm(S, termCoeff, symKinds));
  return kind;
}

static LogicalResult
collectPlanAddend(WaveAMDMachineSelector &S, sym::ExprHandle term,
                  sym::ExprHandle termCoeff,
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
      {*scaled, classifyScaledAddend(S, term, termCoeff, symKinds)});
  return success();
}

static LogicalResult
collectPlanAddends(WaveAMDMachineSelector &S, sym::ExprHandle expr,
                   const llvm::StringMap<TermKind> &symKinds,
                   ArrayRef<sym::PredHandle> assumptions,
                   SmallVectorImpl<AddressPlanAddend> &addends) {
  sym::ExprView view(expr);
  if (view.getKind() != sym::ExprKind::Add)
    return collectPlanAddend(S, expr, /*termCoeff=*/{}, symKinds, assumptions,
                             addends);
  sym::ExprHandle coeff = view.getAddConstant();
  if (!isZeroExpr(coeff))
    addends.push_back({coeff, TermKind::Const});
  uint32_t nterms = view.getAddTermCount();
  for (uint32_t i = 0; i < nterms; ++i) {
    sym::AddTerm term = view.getAddTerm(i);
    if (failed(collectPlanAddend(S, term.term, term.coefficient, symKinds,
                                 assumptions, addends)))
      return failure();
  }
  return success();
}

static FailureOr<sym::ExprHandle> expandPlanExpr(WaveAMDMachineSelector &S,
                                                 sym::ExprHandle expr) {
  return sym::expandExpr(S.symbolStore(), expr);
}

static LogicalResult appendPlanRemainder(WaveAMDMachineSelector &S,
                                         sym::ExprHandle expr,
                                         AddressPlan &plan) {
  return appendPlanExpr(S, expr, plan.assumptions,
                        plan.fullAddressRemainderExpr);
}

static LogicalResult
takeInstOffsetAddends(WaveAMDMachineSelector &S,
                      const waveamdmachine::AddressFieldSpec &spec,
                      ArrayRef<AddressPlanAddend> addends, AddressPlan &plan) {
  for (const AddressPlanAddend &addend : addends) {
    if (addend.kind != TermKind::Const)
      continue;
    std::optional<int64_t> value = sym::getIntegerLiteralValue(addend.expr);
    std::optional<int64_t> next =
        value ? llvm::checkedAdd(plan.instOffset, *value) : std::nullopt;
    if (next && instOffsetFits(*next, spec)) {
      plan.instOffset = *next;
      continue;
    }
    if (failed(appendPlanRemainder(S, addend.expr, plan)))
      return failure();
  }
  return success();
}

static FailureOr<bool> tryAppendPlanSlot(WaveAMDMachineSelector &S,
                                         sym::ExprHandle expr,
                                         AddressPlan &plan,
                                         sym::ExprHandle &slotExpr) {
  if (!expr)
    return true;
  sym::ExprHandle candidate = slotExpr;
  if (failed(appendPlanExpr(S, expr, plan.assumptions, candidate)))
    return failure();
  if (!S.slotFitsU32(candidate, plan.assumptions))
    return false;
  slotExpr = candidate;
  return true;
}

static LogicalResult packPlanSlotAddends(WaveAMDMachineSelector &S,
                                         TermKind kind,
                                         ArrayRef<AddressPlanAddend> addends,
                                         AddressPlan &plan,
                                         sym::ExprHandle &slotExpr) {
  for (const AddressPlanAddend &addend : addends) {
    if (addend.kind != kind)
      continue;
    FailureOr<bool> took = tryAppendPlanSlot(S, addend.expr, plan, slotExpr);
    if (failed(took))
      return failure();
    if (!*took && failed(appendPlanRemainder(S, addend.expr, plan)))
      return failure();
  }
  return success();
}

static LogicalResult
appendPlanAddendsRemainder(WaveAMDMachineSelector &S, TermKind kind,
                           ArrayRef<AddressPlanAddend> addends,
                           AddressPlan &plan) {
  for (const AddressPlanAddend &addend : addends)
    if (addend.kind == kind &&
        failed(appendPlanRemainder(S, addend.expr, plan)))
      return failure();
  return success();
}

static LogicalResult
assignPlanAddends(WaveAMDMachineSelector &S,
                  const waveamdmachine::AddressFieldSpec &spec,
                  ArrayRef<AddressPlanAddend> addends, AddressPlan &plan) {
  if (failed(takeInstOffsetAddends(S, spec, addends, plan)))
    return failure();
  if (spec.hasSoffset)
    return packPlanSlotAddends(S, TermKind::Uniform, addends, plan,
                               plan.soffsetExpr);
  return appendPlanAddendsRemainder(S, TermKind::Uniform, addends, plan);
}

} // namespace

// ---- public surface (declared in WaveAMDMachineSelector.h) ----------------

static FailureOr<Value>
materializeCompoundIndexExprNode(WaveAMDMachineSelector &S,
                                 sym::ExprHandle expr, Operation *user,
                                 const llvm::StringMap<Value> &subs) {
  sym::ExprView view(expr);
  switch (view.getKind()) {
  case sym::ExprKind::Add:
    return materializeAdd(S, expr, user, subs);
  case sym::ExprKind::Mul:
    return materializeMul(S, expr, user, subs);
  case sym::ExprKind::Floor:
    return materializeFloor(S, expr, user, subs);
  case sym::ExprKind::Ceil:
    return materializeCeil(S, expr, user, subs);
  case sym::ExprKind::Mod:
    return materializeMod(S, expr, user, subs);
  case sym::ExprKind::Xor:
    return materializeXor(S, expr, user, subs);
  default:
    break;
  }
  return user->emitError(
             "wave.index_expr selection does not support expression kind ")
         << static_cast<int>(view.getKind());
}

FailureOr<Value> materializeIndexExprNode(WaveAMDMachineSelector &S,
                                          sym::ExprHandle expr, Operation *user,
                                          const llvm::StringMap<Value> &subs) {
  sym::ExprView view(expr);
  switch (view.getKind()) {
  case sym::ExprKind::Integer:
    if (std::optional<int64_t> value = view.getInt())
      return createImm(S.builder, user->getLoc(), *value);
    break;
  case sym::ExprKind::Rational:
    return materializeRational(S, expr, user);
  case sym::ExprKind::Symbol: {
    return materializeSymbol(S, expr, user, subs);
  }
  default:
    return materializeCompoundIndexExprNode(S, expr, user, subs);
  }
  return user->emitError(
             "wave.index_expr selection does not support expression kind ")
         << static_cast<int>(view.getKind());
}

static TermKind
classifyCompoundTerm(WaveAMDMachineSelector &S, sym::ExprHandle expr,
                     const llvm::StringMap<TermKind> &symKinds) {
  sym::ExprView view(expr);
  switch (view.getKind()) {
  case sym::ExprKind::Add:
    return classifyAdd(S, expr, symKinds);
  case sym::ExprKind::Mul:
    return classifyMul(S, expr, symKinds);
  case sym::ExprKind::Floor:
  case sym::ExprKind::Ceil:
    return classifyTerm(S, view.getUnaryArg(), symKinds);
  case sym::ExprKind::Mod:
  case sym::ExprKind::Xor:
    return std::max(classifyTerm(S, view.getBinaryLhs(), symKinds),
                    classifyTerm(S, view.getBinaryRhs(), symKinds));
  default:
    return TermKind::Lane;
  }
}

TermKind classifyTerm(WaveAMDMachineSelector &S, sym::ExprHandle expr,
                      const llvm::StringMap<TermKind> &symKinds) {
  sym::ExprView view(expr);
  switch (view.getKind()) {
  case sym::ExprKind::Integer:
  case sym::ExprKind::Rational:
    return TermKind::Const;
  case sym::ExprKind::Symbol: {
    StringRef name = view.getSymbolName();
    auto it = symKinds.find(name);
    return it == symKinds.end() ? TermKind::Lane : it->second;
  }
  default:
    return classifyCompoundTerm(S, expr, symKinds);
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

  sym::ExprHandle expr = offset.expr;
  if (FailureOr<sym::ExprHandle> expanded = expandPlanExpr(S, expr);
      succeeded(expanded))
    expr = *expanded;
  if (FailureOr<sym::ExprHandle> simplified =
          simplifyPlanExpr(S, expr, plan.assumptions);
      succeeded(simplified))
    expr = *simplified;

  SmallVector<AddressPlanAddend, 8> addends;
  if (failed(collectPlanAddends(S, expr, symKinds, plan.assumptions, addends)))
    return failure();
  if (failed(assignPlanAddends(S, spec, addends, plan)))
    return failure();
  if (failed(packPlanSlotAddends(S, TermKind::Lane, addends, plan,
                                 plan.voffsetExpr)))
    return failure();
  return plan;
}

} // namespace mlir::wave::wmsel
