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

#include <limits>
#include <numeric>
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

static TermKind materializationKind(WaveAMDMachineSelector &S,
                                    sym::ExprHandle expr,
                                    const llvm::StringMap<Value> &subs);

static unsigned materializationLoopDepth(sym::ExprHandle expr, Operation *user,
                                         const llvm::StringMap<Value> &subs);

static bool canMaterializeIntegerRationalExpr(sym::ExprHandle expr);

static FailureOr<Value> materializeIntegerRationalExpr(
    WaveAMDMachineSelector &S, sym::ExprHandle expr, Operation *user,
    const llvm::StringMap<Value> &subs, ArrayRef<sym::PredHandle> assumptions);

static bool isHoistScope(Operation *op) { return isa<LoopLikeOpInterface>(op); }

static Operation *scopeOp(Value value) {
  if (Operation *def = value.getDefiningOp())
    return def;
  return cast<BlockArgument>(value).getOwner()->getParentOp();
}

static unsigned valueLoopDepth(Value value, Operation *) {
  Operation *scope = scopeOp(value);
  if (!scope)
    return 0;
  unsigned depth = 0;
  for (Operation *cur = scope; cur; cur = cur->getParentOp())
    if (isHoistScope(cur))
      ++depth;
  return depth;
}

static TermKind symbolMaterializationKind(WaveAMDMachineSelector &S,
                                          sym::ExprHandle expr,
                                          const llvm::StringMap<Value> &subs) {
  auto it = subs.find(sym::ExprView(expr).getSymbolName());
  if (it == subs.end())
    return TermKind::Lane;
  return S.isUniformValue(it->second) ? TermKind::Uniform : TermKind::Lane;
}

static TermKind addMaterializationKind(WaveAMDMachineSelector &S,
                                       sym::ExprHandle expr,
                                       const llvm::StringMap<Value> &subs) {
  sym::ExprView view(expr);
  TermKind kind = materializationKind(S, view.getAddConstant(), subs);
  for (uint32_t i = 0, e = view.getAddTermCount(); i != e; ++i) {
    sym::AddTerm term = view.getAddTerm(i);
    kind = std::max(kind, materializationKind(S, term.coefficient, subs));
    kind = std::max(kind, materializationKind(S, term.term, subs));
  }
  return kind;
}

static TermKind mulMaterializationKind(WaveAMDMachineSelector &S,
                                       sym::ExprHandle expr,
                                       const llvm::StringMap<Value> &subs) {
  sym::ExprView view(expr);
  TermKind kind = materializationKind(S, view.getMulCoefficient(), subs);
  for (uint32_t i = 0, e = view.getMulFactorCount(); i != e; ++i)
    kind =
        std::max(kind, materializationKind(S, view.getMulFactor(i).base, subs));
  return kind;
}

static TermKind materializationKind(WaveAMDMachineSelector &S,
                                    sym::ExprHandle expr,
                                    const llvm::StringMap<Value> &subs) {
  sym::ExprView view(expr);
  switch (view.getKind()) {
  case sym::ExprKind::Integer:
  case sym::ExprKind::Rational:
    return TermKind::Const;
  case sym::ExprKind::Symbol:
    return symbolMaterializationKind(S, expr, subs);
  case sym::ExprKind::Add:
    return addMaterializationKind(S, expr, subs);
  case sym::ExprKind::Mul:
    return mulMaterializationKind(S, expr, subs);
  case sym::ExprKind::Floor:
  case sym::ExprKind::Ceil:
    return materializationKind(S, view.getUnaryArg(), subs);
  case sym::ExprKind::Mod:
  case sym::ExprKind::Xor:
    return std::max(materializationKind(S, view.getBinaryLhs(), subs),
                    materializationKind(S, view.getBinaryRhs(), subs));
  default:
    return TermKind::Lane;
  }
}

static unsigned
symbolMaterializationLoopDepth(sym::ExprHandle expr, Operation *user,
                               const llvm::StringMap<Value> &subs) {
  auto it = subs.find(sym::ExprView(expr).getSymbolName());
  if (it == subs.end())
    return std::numeric_limits<unsigned>::max();
  return valueLoopDepth(it->second, user);
}

static unsigned
addMaterializationLoopDepth(sym::ExprHandle expr, Operation *user,
                            const llvm::StringMap<Value> &subs) {
  sym::ExprView view(expr);
  unsigned depth = materializationLoopDepth(view.getAddConstant(), user, subs);
  for (uint32_t i = 0, e = view.getAddTermCount(); i != e; ++i) {
    sym::AddTerm term = view.getAddTerm(i);
    depth =
        std::max(depth, materializationLoopDepth(term.coefficient, user, subs));
    depth = std::max(depth, materializationLoopDepth(term.term, user, subs));
  }
  return depth;
}

static unsigned
mulMaterializationLoopDepth(sym::ExprHandle expr, Operation *user,
                            const llvm::StringMap<Value> &subs) {
  sym::ExprView view(expr);
  unsigned depth =
      materializationLoopDepth(view.getMulCoefficient(), user, subs);
  for (uint32_t i = 0, e = view.getMulFactorCount(); i != e; ++i)
    depth = std::max(
        depth, materializationLoopDepth(view.getMulFactor(i).base, user, subs));
  return depth;
}

static unsigned materializationLoopDepth(sym::ExprHandle expr, Operation *user,
                                         const llvm::StringMap<Value> &subs) {
  sym::ExprView view(expr);
  switch (view.getKind()) {
  case sym::ExprKind::Integer:
  case sym::ExprKind::Rational:
    return 0;
  case sym::ExprKind::Symbol:
    return symbolMaterializationLoopDepth(expr, user, subs);
  case sym::ExprKind::Add:
    return addMaterializationLoopDepth(expr, user, subs);
  case sym::ExprKind::Mul:
    return mulMaterializationLoopDepth(expr, user, subs);
  case sym::ExprKind::Floor:
  case sym::ExprKind::Ceil:
    return materializationLoopDepth(view.getUnaryArg(), user, subs);
  case sym::ExprKind::Mod:
  case sym::ExprKind::Xor:
    return std::max(materializationLoopDepth(view.getBinaryLhs(), user, subs),
                    materializationLoopDepth(view.getBinaryRhs(), user, subs));
  default:
    return std::numeric_limits<unsigned>::max();
  }
}

struct OrderedAddTerm {
  sym::AddTerm term;
  TermKind kind = TermKind::Lane;
  unsigned loopDepth = 0;
};

struct OrderedMulFactor {
  sym::MulFactor factor;
  TermKind kind = TermKind::Lane;
  unsigned loopDepth = 0;
};

static unsigned termKindRank(TermKind kind, IndexExprAddOrder addOrder) {
  if (addOrder == IndexExprAddOrder::UniformFirst)
    return static_cast<unsigned>(kind);
  switch (kind) {
  case TermKind::Lane:
    return 0;
  case TermKind::Const:
    return 1;
  case TermKind::Uniform:
    return 2;
  }
  llvm_unreachable("unknown term kind");
}

static bool orderedBefore(TermKind lhsKind, unsigned lhsDepth, TermKind rhsKind,
                          unsigned rhsDepth, IndexExprAddOrder addOrder) {
  unsigned lhsRank = termKindRank(lhsKind, addOrder);
  unsigned rhsRank = termKindRank(rhsKind, addOrder);
  if (lhsRank != rhsRank)
    return lhsRank < rhsRank;
  if (lhsDepth != rhsDepth)
    return lhsDepth < rhsDepth;
  return false;
}

static SmallVector<OrderedAddTerm, 8>
collectOrderedAddTerms(WaveAMDMachineSelector &S, sym::ExprHandle expr,
                       Operation *user, const llvm::StringMap<Value> &subs,
                       IndexExprAddOrder addOrder) {
  sym::ExprView view(expr);
  SmallVector<OrderedAddTerm, 8> terms;
  terms.reserve(view.getAddTermCount());
  for (uint32_t i = 0; i < view.getAddTermCount(); ++i) {
    sym::AddTerm term = view.getAddTerm(i);
    TermKind kind = std::max(materializationKind(S, term.coefficient, subs),
                             materializationKind(S, term.term, subs));
    unsigned depth =
        std::max(materializationLoopDepth(term.coefficient, user, subs),
                 materializationLoopDepth(term.term, user, subs));
    terms.push_back({term, kind, depth});
  }
  llvm::stable_sort(
      terms, [addOrder](const OrderedAddTerm &lhs, const OrderedAddTerm &rhs) {
        return orderedBefore(lhs.kind, lhs.loopDepth, rhs.kind, rhs.loopDepth,
                             addOrder);
      });
  return terms;
}

static SmallVector<OrderedMulFactor, 8>
collectOrderedMulFactors(WaveAMDMachineSelector &S, sym::ExprHandle expr,
                         Operation *user, const llvm::StringMap<Value> &subs) {
  sym::ExprView view(expr);
  SmallVector<OrderedMulFactor, 8> factors;
  factors.reserve(view.getMulFactorCount());
  for (uint32_t i = 0; i < view.getMulFactorCount(); ++i) {
    sym::MulFactor factor = view.getMulFactor(i);
    factors.push_back({factor, materializationKind(S, factor.base, subs),
                       materializationLoopDepth(factor.base, user, subs)});
  }
  llvm::stable_sort(
      factors, [](const OrderedMulFactor &lhs, const OrderedMulFactor &rhs) {
        return orderedBefore(lhs.kind, lhs.loopDepth, rhs.kind, rhs.loopDepth,
                             IndexExprAddOrder::UniformFirst);
      });
  return factors;
}

FailureOr<Value> materializeAddTerm(WaveAMDMachineSelector &S,
                                    sym::AddTerm addTerm, Operation *user,
                                    const llvm::StringMap<Value> &subs,
                                    ArrayRef<sym::PredHandle> assumptions,
                                    IndexExprAddOrder addOrder) {
  Location loc = user->getLoc();
  FailureOr<Value> term = materializeIndexExprNode(S, addTerm.term, user, subs,
                                                   assumptions, addOrder);
  if (failed(term))
    return failure();
  std::optional<int64_t> tcInt = staticIntLiteral(addTerm.coefficient);
  if (tcInt && *tcInt == 1)
    return *term;
  FailureOr<Value> tcVal = materializeIndexExprNode(
      S, addTerm.coefficient, user, subs, assumptions, addOrder);
  if (failed(tcVal))
    return failure();
  if (S.isUniformValue(*tcVal) && S.isUniformValue(*term))
    return S.mulUniformValues(loc, *tcVal, *term);
  return S.mulIndexValues(loc, *tcVal, *term);
}

static void appendLaneAdd(WaveAMDMachineSelector &S, Location loc, Value value,
                          std::optional<Value> &acc) {
  acc = acc ? S.addByteOffsets(loc, *acc, value) : value;
}

static void appendUniformAdd(WaveAMDMachineSelector &S, Location loc,
                             Value value, std::optional<Value> &acc) {
  acc = acc ? S.addUniformBytes(loc, *acc, value) : value;
}

static LogicalResult materializeLaneFirstAddConstant(
    WaveAMDMachineSelector &S, Operation *user, sym::ExprHandle coeff,
    const llvm::StringMap<Value> &subs, ArrayRef<sym::PredHandle> assumptions,
    std::optional<Value> &uniformAcc) {
  std::optional<int64_t> coeffInt = staticIntLiteral(coeff);
  if (!coeffInt || *coeffInt != 0) {
    FailureOr<Value> seed = materializeIndexExprNode(
        S, coeff, user, subs, assumptions, IndexExprAddOrder::LaneFirst);
    if (failed(seed))
      return failure();
    appendUniformAdd(S, user->getLoc(), *seed, uniformAcc);
  }
  return success();
}

static LogicalResult appendLaneFirstAddTerm(
    WaveAMDMachineSelector &S, Operation *user, const OrderedAddTerm &ordered,
    const llvm::StringMap<Value> &subs, ArrayRef<sym::PredHandle> assumptions,
    std::optional<Value> &laneAcc, std::optional<Value> &uniformAcc) {
  FailureOr<Value> scaled = materializeAddTerm(
      S, ordered.term, user, subs, assumptions, IndexExprAddOrder::LaneFirst);
  if (failed(scaled))
    return failure();
  if (ordered.kind == TermKind::Lane)
    appendLaneAdd(S, user->getLoc(), *scaled, laneAcc);
  else
    appendUniformAdd(S, user->getLoc(), *scaled, uniformAcc);
  return success();
}

static Value finalizeLaneFirstAdd(WaveAMDMachineSelector &S, Location loc,
                                  std::optional<Value> laneAcc,
                                  std::optional<Value> uniformAcc) {
  if (laneAcc && uniformAcc)
    return S.addByteOffsets(loc, *uniformAcc, *laneAcc);
  if (laneAcc)
    return *laneAcc;
  if (uniformAcc)
    return *uniformAcc;
  return createImm(S.builder, loc, 0);
}

static FailureOr<Value>
materializeAddLaneFirst(WaveAMDMachineSelector &S, sym::ExprHandle expr,
                        Operation *user, const llvm::StringMap<Value> &subs,
                        ArrayRef<sym::PredHandle> assumptions) {
  sym::ExprView view(expr);
  std::optional<Value> laneAcc;
  std::optional<Value> uniformAcc;
  if (failed(materializeLaneFirstAddConstant(S, user, view.getAddConstant(),
                                             subs, assumptions, uniformAcc)))
    return failure();
  SmallVector<OrderedAddTerm, 8> terms =
      collectOrderedAddTerms(S, expr, user, subs, IndexExprAddOrder::LaneFirst);
  for (const OrderedAddTerm &ordered : terms)
    if (failed(appendLaneFirstAddTerm(S, user, ordered, subs, assumptions,
                                      laneAcc, uniformAcc)))
      return failure();
  return finalizeLaneFirstAdd(S, user->getLoc(), laneAcc, uniformAcc);
}

// ADD = coeff + sum(term_coeff[i] * term[i]). Skip materializing coeff
// when it's 0 and term_coeff[i] when it's 1.
static FailureOr<Value>
materializeAddUniformFirst(WaveAMDMachineSelector &S, sym::ExprHandle expr,
                           Operation *user, const llvm::StringMap<Value> &subs,
                           ArrayRef<sym::PredHandle> assumptions) {
  Location loc = user->getLoc();
  sym::ExprView view(expr);
  sym::ExprHandle coeff = view.getAddConstant();
  std::optional<int64_t> coeffInt = staticIntLiteral(coeff);
  std::optional<Value> acc;
  if (!coeffInt || *coeffInt != 0) {
    FailureOr<Value> seed =
        materializeIndexExprNode(S, coeff, user, subs, assumptions);
    if (failed(seed))
      return failure();
    acc = *seed;
  }
  SmallVector<OrderedAddTerm, 8> terms = collectOrderedAddTerms(
      S, expr, user, subs, IndexExprAddOrder::UniformFirst);
  for (const OrderedAddTerm &ordered : terms) {
    FailureOr<Value> scaled =
        materializeAddTerm(S, ordered.term, user, subs, assumptions,
                           IndexExprAddOrder::UniformFirst);
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

FailureOr<Value> materializeAdd(WaveAMDMachineSelector &S, sym::ExprHandle expr,
                                Operation *user,
                                const llvm::StringMap<Value> &subs,
                                ArrayRef<sym::PredHandle> assumptions,
                                IndexExprAddOrder addOrder) {
  if (canMaterializeIntegerRationalExpr(expr))
    return materializeIntegerRationalExpr(S, expr, user, subs, assumptions);
  if (addOrder == IndexExprAddOrder::LaneFirst)
    return materializeAddLaneFirst(S, expr, user, subs, assumptions);
  return materializeAddUniformFirst(S, expr, user, subs, assumptions);
}

FailureOr<Value> materializeMulFactor(WaveAMDMachineSelector &S,
                                      sym::MulFactor factor, Operation *user,
                                      const llvm::StringMap<Value> &subs,
                                      ArrayRef<sym::PredHandle> assumptions,
                                      IndexExprAddOrder addOrder) {
  int32_t exp = factor.exponent;
  if (exp <= 0)
    return user->emitError(
        "wave.index_expr selection rejects non-positive mul exponent");
  FailureOr<Value> base = materializeIndexExprNode(S, factor.base, user, subs,
                                                   assumptions, addOrder);
  if (failed(base))
    return failure();
  Value pow = *base;
  for (int32_t e = 1; e < exp; ++e)
    pow = S.mulIndexValues(user->getLoc(), pow, *base);
  return pow;
}

static LogicalResult materializeMulSeed(WaveAMDMachineSelector &S,
                                        sym::ExprHandle coeff, Operation *user,
                                        const llvm::StringMap<Value> &subs,
                                        ArrayRef<sym::PredHandle> assumptions,
                                        IndexExprAddOrder addOrder,
                                        std::optional<Value> &acc) {
  std::optional<int64_t> coeffInt = staticIntLiteral(coeff);
  if (coeffInt && *coeffInt == 1)
    return success();
  FailureOr<Value> seed =
      materializeIndexExprNode(S, coeff, user, subs, assumptions, addOrder);
  if (failed(seed))
    return failure();
  acc = *seed;
  return success();
}

static Value combineMulValues(WaveAMDMachineSelector &S, Location loc,
                              Value lhs, Value rhs) {
  if (S.isUniformValue(lhs) && S.isUniformValue(rhs))
    return S.mulUniformValues(loc, lhs, rhs);
  return S.mulIndexValues(loc, lhs, rhs);
}

static LogicalResult
appendMulFactor(WaveAMDMachineSelector &S, const OrderedMulFactor &ordered,
                Operation *user, const llvm::StringMap<Value> &subs,
                ArrayRef<sym::PredHandle> assumptions,
                IndexExprAddOrder addOrder, std::optional<Value> &acc) {
  FailureOr<Value> pow = materializeMulFactor(S, ordered.factor, user, subs,
                                              assumptions, addOrder);
  if (failed(pow))
    return failure();
  acc = acc ? combineMulValues(S, user->getLoc(), *acc, *pow) : *pow;
  return success();
}

// MUL = coeff * prod(base[i] ^ exp[i]). Skip the coeff when it's 1.
FailureOr<Value> materializeMul(WaveAMDMachineSelector &S, sym::ExprHandle expr,
                                Operation *user,
                                const llvm::StringMap<Value> &subs,
                                ArrayRef<sym::PredHandle> assumptions,
                                IndexExprAddOrder addOrder) {
  if (canMaterializeIntegerRationalExpr(expr))
    return materializeIntegerRationalExpr(S, expr, user, subs, assumptions);
  Location loc = user->getLoc();
  sym::ExprView view(expr);
  std::optional<Value> acc;
  if (failed(materializeMulSeed(S, view.getMulCoefficient(), user, subs,
                                assumptions, addOrder, acc)))
    return failure();
  SmallVector<OrderedMulFactor, 8> factors =
      collectOrderedMulFactors(S, expr, user, subs);
  for (const OrderedMulFactor &ordered : factors)
    if (failed(appendMulFactor(S, ordered, user, subs, assumptions, addOrder,
                               acc)))
      return failure();
  return acc ? *acc : createImm(S.builder, loc, 1);
}

// mod(lhs, rhs). Only power-of-two `rhs` is supported: the modulus is
// a bitwise AND with `rhs - 1`.
FailureOr<Value> materializeMod(WaveAMDMachineSelector &S, sym::ExprHandle expr,
                                Operation *user,
                                const llvm::StringMap<Value> &subs,
                                ArrayRef<sym::PredHandle> assumptions,
                                IndexExprAddOrder addOrder) {
  sym::ExprView view(expr);
  sym::ExprHandle lhs = view.getBinaryLhs();
  sym::ExprHandle rhs = view.getBinaryRhs();
  std::optional<int64_t> rhsInt = staticIntLiteral(rhs);
  if (!rhsInt || *rhsInt <= 0 || (*rhsInt & (*rhsInt - 1)) != 0)
    return user->emitError(
        "wave.index_expr mod needs a power-of-two integer divisor");
  FailureOr<Value> lhsValue =
      materializeIndexExprNode(S, lhs, user, subs, assumptions, addOrder);
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
                                const llvm::StringMap<Value> &subs,
                                ArrayRef<sym::PredHandle> assumptions,
                                IndexExprAddOrder addOrder) {
  Location loc = user->getLoc();
  sym::ExprView view(expr);
  FailureOr<Value> lhs = materializeIndexExprNode(S, view.getBinaryLhs(), user,
                                                  subs, assumptions, addOrder);
  FailureOr<Value> rhs = materializeIndexExprNode(S, view.getBinaryRhs(), user,
                                                  subs, assumptions, addOrder);
  if (failed(lhs) || failed(rhs))
    return failure();
  if (std::optional<Value> folded = foldXorImmediates(S, loc, *lhs, *rhs))
    return *folded;
  if (S.isUniformValue(*lhs) && S.isUniformValue(*rhs))
    return materializeUniformXor(S, loc, *lhs, *rhs);
  return materializeLaneXor(S, loc, *lhs, *rhs);
}

struct RationalIndexValue {
  OpFoldResult numerator;
  OpFoldResult denominator;
};

struct BinaryValues {
  Value lhs;
  Value rhs;
};

static std::optional<int64_t> checkedLCM(int64_t lhs, int64_t rhs) {
  int64_t gcd = std::gcd(lhs, rhs);
  return llvm::checkedMul(lhs / gcd, rhs);
}

static bool isPositivePowerOfTwo(int64_t value) {
  return value > 0 && (value & (value - 1)) == 0;
}

static unsigned cappedPow2Divisibility(int64_t value) {
  if (value == 0)
    return 62;
  uint64_t magnitude = value < 0 ? uint64_t{0} - static_cast<uint64_t>(value)
                                 : static_cast<uint64_t>(value);
  return std::min<unsigned>(llvm::countr_zero(magnitude), 62);
}

static std::optional<RationalPow2Shape>
inferRationalPow2ShapeImpl(sym::ExprHandle expr);

static std::optional<RationalPow2Shape>
mulRationalPow2Shape(RationalPow2Shape lhs, RationalPow2Shape rhs) {
  std::optional<int64_t> denominator =
      llvm::checkedMul(lhs.denominator, rhs.denominator);
  if (!denominator)
    return std::nullopt;
  return RationalPow2Shape{
      *denominator,
      std::min(lhs.numeratorPow2Divisibility + rhs.numeratorPow2Divisibility,
               62u)};
}

static std::optional<RationalPow2Shape>
addRationalPow2Shape(RationalPow2Shape lhs, RationalPow2Shape rhs) {
  std::optional<int64_t> denominator =
      checkedLCM(lhs.denominator, rhs.denominator);
  if (!denominator)
    return std::nullopt;
  int64_t lhsScale = *denominator / lhs.denominator;
  int64_t rhsScale = *denominator / rhs.denominator;
  unsigned lhsDiv = std::min(
      lhs.numeratorPow2Divisibility + cappedPow2Divisibility(lhsScale), 62u);
  unsigned rhsDiv = std::min(
      rhs.numeratorPow2Divisibility + cappedPow2Divisibility(rhsScale), 62u);
  return RationalPow2Shape{*denominator, std::min(lhsDiv, rhsDiv)};
}

static std::optional<RationalPow2Shape>
inferAddRationalPow2Shape(sym::ExprView view) {
  std::optional<RationalPow2Shape> acc =
      inferRationalPow2ShapeImpl(view.getAddConstant());
  if (!acc)
    return std::nullopt;
  for (uint32_t i : llvm::seq<uint32_t>(0, view.getAddTermCount())) {
    sym::AddTerm term = view.getAddTerm(i);
    std::optional<RationalPow2Shape> coefficient =
        inferRationalPow2ShapeImpl(term.coefficient);
    std::optional<RationalPow2Shape> value =
        inferRationalPow2ShapeImpl(term.term);
    if (!coefficient || !value)
      return std::nullopt;
    std::optional<RationalPow2Shape> product =
        mulRationalPow2Shape(*coefficient, *value);
    if (!product)
      return std::nullopt;
    acc = addRationalPow2Shape(*acc, *product);
    if (!acc)
      return std::nullopt;
  }
  return acc;
}

static std::optional<RationalPow2Shape>
inferMulRationalPow2Shape(sym::ExprView view) {
  std::optional<RationalPow2Shape> acc =
      inferRationalPow2ShapeImpl(view.getMulCoefficient());
  if (!acc)
    return std::nullopt;
  for (uint32_t i : llvm::seq<uint32_t>(0, view.getMulFactorCount())) {
    sym::MulFactor factor = view.getMulFactor(i);
    if (factor.exponent <= 0)
      return std::nullopt;
    std::optional<RationalPow2Shape> base =
        inferRationalPow2ShapeImpl(factor.base);
    if (!base)
      return std::nullopt;
    for ([[maybe_unused]] int32_t e : llvm::seq<int32_t>(0, factor.exponent)) {
      acc = mulRationalPow2Shape(*acc, *base);
      if (!acc)
        return std::nullopt;
    }
  }
  return acc;
}

static std::optional<RationalPow2Shape>
inferModRationalPow2Shape(sym::ExprView view) {
  std::optional<RationalPow2Shape> lhs =
      inferRationalPow2ShapeImpl(view.getBinaryLhs());
  std::optional<int64_t> rhs = staticIntLiteral(view.getBinaryRhs());
  if (!lhs || !rhs)
    return std::nullopt;
  std::optional<int64_t> divisor = llvm::checkedMul(lhs->denominator, *rhs);
  if (!divisor || !isPositivePowerOfTwo(*divisor))
    return std::nullopt;
  return RationalPow2Shape{lhs->denominator,
                           std::min(lhs->numeratorPow2Divisibility,
                                    cappedPow2Divisibility(*divisor))};
}

static std::optional<RationalPow2Shape>
inferLeafOrOpaqueRationalPow2Shape(sym::ExprView view) {
  switch (view.getKind()) {
  case sym::ExprKind::Integer:
    if (std::optional<int64_t> value = view.getInt())
      return RationalPow2Shape{1, cappedPow2Divisibility(*value)};
    return std::nullopt;
  case sym::ExprKind::Rational: {
    std::optional<sym::RationalLiteral> rational = view.getRational();
    if (!rational || rational->denominator <= 0)
      return std::nullopt;
    return RationalPow2Shape{rational->denominator,
                             cappedPow2Divisibility(rational->numerator)};
  }
  case sym::ExprKind::Symbol:
  case sym::ExprKind::Floor:
  case sym::ExprKind::Ceil:
  case sym::ExprKind::Xor:
    return RationalPow2Shape{1, 0};
  default:
    return std::nullopt;
  }
}

static std::optional<RationalPow2Shape>
inferRationalPow2ShapeImpl(sym::ExprHandle expr) {
  sym::ExprView view(expr);
  if (std::optional<RationalPow2Shape> shape =
          inferLeafOrOpaqueRationalPow2Shape(view))
    return shape;
  switch (view.getKind()) {
  case sym::ExprKind::Add:
    return inferAddRationalPow2Shape(view);
  case sym::ExprKind::Mul:
    return inferMulRationalPow2Shape(view);
  case sym::ExprKind::Mod:
    return inferModRationalPow2Shape(view);
  default:
    return std::nullopt;
  }
}

static bool canMaterializeIntegerRationalExpr(sym::ExprHandle expr) {
  std::optional<RationalPow2Shape> shape = inferRationalPow2Shape(expr);
  if (!shape || shape->denominator == 1)
    return false;
  return isIntegerValuedRationalPow2Expr(expr, shape->denominator);
}

static OpFoldResult getIntFoldResult(WaveAMDMachineSelector &S, int64_t value) {
  return S.builder.getI64IntegerAttr(value);
}

static std::optional<int64_t> getStaticInt(WaveAMDMachineSelector &S,
                                           OpFoldResult value) {
  if (Attribute attr = llvm::dyn_cast_if_present<Attribute>(value))
    if (auto intAttr = dyn_cast<IntegerAttr>(attr))
      return intAttr.getInt();
  if (Value v = llvm::dyn_cast_if_present<Value>(value))
    return S.getImmediateValue(v);
  return std::nullopt;
}

static FailureOr<Value> materializeValue(WaveAMDMachineSelector &S,
                                         Location loc, OpFoldResult value,
                                         Operation *user) {
  if (Value v = llvm::dyn_cast_if_present<Value>(value))
    return v;
  if (std::optional<int64_t> imm = getStaticInt(S, value))
    return createImm(S.builder, loc, *imm);
  return user->emitError("wave.index_expr has non-integer fold result");
}

static FailureOr<OpFoldResult> addFoldResult(WaveAMDMachineSelector &S,
                                             Location loc, OpFoldResult lhs,
                                             OpFoldResult rhs,
                                             Operation *user) {
  std::optional<int64_t> lhsInt = getStaticInt(S, lhs);
  std::optional<int64_t> rhsInt = getStaticInt(S, rhs);
  if (lhsInt && rhsInt)
    if (std::optional<int64_t> sum = llvm::checkedAdd(*lhsInt, *rhsInt))
      return getIntFoldResult(S, *sum);
  FailureOr<Value> lhsValue = materializeValue(S, loc, lhs, user);
  FailureOr<Value> rhsValue = materializeValue(S, loc, rhs, user);
  if (failed(lhsValue) || failed(rhsValue))
    return failure();
  if (S.isUniformValue(*lhsValue) && S.isUniformValue(*rhsValue))
    return OpFoldResult(S.addUniformBytes(loc, *lhsValue, *rhsValue));
  return OpFoldResult(S.addByteOffsets(loc, *lhsValue, *rhsValue));
}

static FailureOr<OpFoldResult> mulFoldResult(WaveAMDMachineSelector &S,
                                             Location loc, OpFoldResult lhs,
                                             OpFoldResult rhs,
                                             Operation *user) {
  std::optional<int64_t> lhsInt = getStaticInt(S, lhs);
  std::optional<int64_t> rhsInt = getStaticInt(S, rhs);
  if (lhsInt && rhsInt)
    if (std::optional<int64_t> product = llvm::checkedMul(*lhsInt, *rhsInt))
      return getIntFoldResult(S, *product);
  FailureOr<Value> lhsValue = materializeValue(S, loc, lhs, user);
  FailureOr<Value> rhsValue = materializeValue(S, loc, rhs, user);
  if (failed(lhsValue) || failed(rhsValue))
    return failure();
  if (S.isUniformValue(*lhsValue) && S.isUniformValue(*rhsValue))
    return OpFoldResult(S.mulUniformValues(loc, *lhsValue, *rhsValue));
  return OpFoldResult(S.mulIndexValues(loc, *lhsValue, *rhsValue));
}

static RationalIndexValue getIntRational(WaveAMDMachineSelector &S,
                                         int64_t value) {
  return RationalIndexValue{getIntFoldResult(S, value), getIntFoldResult(S, 1)};
}

static FailureOr<RationalIndexValue> materializeRationalIndexExprNode(
    WaveAMDMachineSelector &S, sym::ExprHandle expr, Operation *user,
    const llvm::StringMap<Value> &subs, ArrayRef<sym::PredHandle> assumptions);
static LogicalResult requireIntegerRationalOperands(WaveAMDMachineSelector &S,
                                                    RationalIndexValue lhs,
                                                    RationalIndexValue rhs,
                                                    Operation *user);
static FailureOr<BinaryValues>
materializeRationalNumerators(WaveAMDMachineSelector &S, Location loc,
                              RationalIndexValue lhs, RationalIndexValue rhs,
                              Operation *user);

static FailureOr<RationalIndexValue> addStaticDenominatorRational(
    WaveAMDMachineSelector &S, Location loc, RationalIndexValue lhs,
    int64_t lhsDen, RationalIndexValue rhs, int64_t rhsDen, Operation *user) {
  std::optional<int64_t> denominator = checkedLCM(lhsDen, rhsDen);
  if (!denominator)
    return user->emitError("wave.index_expr denominator overflows i64");
  FailureOr<OpFoldResult> lhsNumerator = mulFoldResult(
      S, loc, lhs.numerator, getIntFoldResult(S, *denominator / lhsDen), user);
  FailureOr<OpFoldResult> rhsNumerator = mulFoldResult(
      S, loc, rhs.numerator, getIntFoldResult(S, *denominator / rhsDen), user);
  if (failed(lhsNumerator) || failed(rhsNumerator))
    return failure();
  FailureOr<OpFoldResult> numerator =
      addFoldResult(S, loc, *lhsNumerator, *rhsNumerator, user);
  if (failed(numerator))
    return failure();
  return RationalIndexValue{*numerator, getIntFoldResult(S, *denominator)};
}

static FailureOr<RationalIndexValue>
addDynamicDenominatorRational(WaveAMDMachineSelector &S, Location loc,
                              RationalIndexValue lhs, RationalIndexValue rhs,
                              Operation *user) {
  FailureOr<OpFoldResult> lhsNumerator =
      mulFoldResult(S, loc, lhs.numerator, rhs.denominator, user);
  FailureOr<OpFoldResult> rhsNumerator =
      mulFoldResult(S, loc, rhs.numerator, lhs.denominator, user);
  if (failed(lhsNumerator) || failed(rhsNumerator))
    return failure();
  FailureOr<OpFoldResult> numerator =
      addFoldResult(S, loc, *lhsNumerator, *rhsNumerator, user);
  FailureOr<OpFoldResult> denominator =
      mulFoldResult(S, loc, lhs.denominator, rhs.denominator, user);
  if (failed(numerator) || failed(denominator))
    return failure();
  return RationalIndexValue{*numerator, *denominator};
}

static FailureOr<RationalIndexValue>
addRational(WaveAMDMachineSelector &S, Location loc, RationalIndexValue lhs,
            RationalIndexValue rhs, Operation *user) {
  std::optional<int64_t> lhsDen = getStaticInt(S, lhs.denominator);
  std::optional<int64_t> rhsDen = getStaticInt(S, rhs.denominator);
  if (lhsDen && rhsDen)
    return addStaticDenominatorRational(S, loc, lhs, *lhsDen, rhs, *rhsDen,
                                        user);
  return addDynamicDenominatorRational(S, loc, lhs, rhs, user);
}

static FailureOr<RationalIndexValue>
mulRational(WaveAMDMachineSelector &S, Location loc, RationalIndexValue lhs,
            RationalIndexValue rhs, Operation *user) {
  FailureOr<OpFoldResult> numerator =
      mulFoldResult(S, loc, lhs.numerator, rhs.numerator, user);
  FailureOr<OpFoldResult> denominator =
      mulFoldResult(S, loc, lhs.denominator, rhs.denominator, user);
  if (failed(numerator) || failed(denominator))
    return failure();
  return RationalIndexValue{*numerator, *denominator};
}

static FailureOr<RationalIndexValue>
materializeRationalAdd(WaveAMDMachineSelector &S, sym::ExprHandle expr,
                       Operation *user, const llvm::StringMap<Value> &subs,
                       ArrayRef<sym::PredHandle> assumptions) {
  Location loc = user->getLoc();
  sym::ExprView view(expr);
  FailureOr<RationalIndexValue> constant = materializeRationalIndexExprNode(
      S, view.getAddConstant(), user, subs, assumptions);
  if (failed(constant))
    return failure();
  RationalIndexValue acc = *constant;
  for (uint32_t i = 0, e = view.getAddTermCount(); i != e; ++i) {
    sym::AddTerm term = view.getAddTerm(i);
    FailureOr<RationalIndexValue> coefficient =
        materializeRationalIndexExprNode(S, term.coefficient, user, subs,
                                         assumptions);
    FailureOr<RationalIndexValue> value =
        materializeRationalIndexExprNode(S, term.term, user, subs, assumptions);
    if (failed(coefficient) || failed(value))
      return failure();
    FailureOr<RationalIndexValue> product =
        mulRational(S, loc, *coefficient, *value, user);
    if (failed(product))
      return failure();
    FailureOr<RationalIndexValue> sum =
        addRational(S, loc, acc, *product, user);
    if (failed(sum))
      return failure();
    acc = *sum;
  }
  return acc;
}

static FailureOr<RationalIndexValue>
materializeRationalMul(WaveAMDMachineSelector &S, sym::ExprHandle expr,
                       Operation *user, const llvm::StringMap<Value> &subs,
                       ArrayRef<sym::PredHandle> assumptions) {
  Location loc = user->getLoc();
  sym::ExprView view(expr);
  FailureOr<RationalIndexValue> coefficient = materializeRationalIndexExprNode(
      S, view.getMulCoefficient(), user, subs, assumptions);
  if (failed(coefficient))
    return failure();
  RationalIndexValue acc = *coefficient;
  for (uint32_t i = 0, e = view.getMulFactorCount(); i != e; ++i) {
    sym::MulFactor factor = view.getMulFactor(i);
    FailureOr<RationalIndexValue> base = materializeRationalIndexExprNode(
        S, factor.base, user, subs, assumptions);
    if (failed(base))
      return failure();
    uint32_t exponent =
        factor.exponent < 0
            ? static_cast<uint32_t>(-static_cast<int64_t>(factor.exponent))
            : static_cast<uint32_t>(factor.exponent);
    RationalIndexValue pow = getIntRational(S, 1);
    for ([[maybe_unused]] uint32_t e : llvm::seq<uint32_t>(0, exponent)) {
      FailureOr<RationalIndexValue> next =
          mulRational(S, loc, pow, *base, user);
      if (failed(next))
        return failure();
      pow = *next;
    }
    if (factor.exponent < 0)
      std::swap(pow.numerator, pow.denominator);
    FailureOr<RationalIndexValue> product = mulRational(S, loc, acc, pow, user);
    if (failed(product))
      return failure();
    acc = *product;
  }
  return acc;
}

static bool hasNonNegativeLowerBound(const sym::InferredRange &range) {
  return range.lower && range.lower->denominator > 0 &&
         range.lower->numerator >= 0;
}

static bool isNonNegativeLiteral(sym::ExprHandle expr) {
  sym::ExprView view(expr);
  if (std::optional<int64_t> value = view.getInt())
    return *value >= 0;
  if (std::optional<sym::RationalLiteral> rational = view.getRational())
    return rational->denominator > 0 && rational->numerator >= 0;
  return false;
}

static bool isProvablyNonNegativeByShape(WaveAMDMachineSelector &S,
                                         sym::ExprHandle expr,
                                         ArrayRef<sym::PredHandle> assumptions);

static bool
hasInferredNonNegativeLowerBound(WaveAMDMachineSelector &S,
                                 sym::ExprHandle expr,
                                 ArrayRef<sym::PredHandle> assumptions) {
  std::optional<sym::InferredRange> range =
      sym::inferRange(S.symbolStore(), expr, assumptions);
  return range && hasNonNegativeLowerBound(*range);
}

static bool isNonNegativeAddExpr(WaveAMDMachineSelector &S,
                                 sym::ExprHandle expr,
                                 ArrayRef<sym::PredHandle> assumptions) {
  sym::ExprView view(expr);
  if (!isProvablyNonNegativeByShape(S, view.getAddConstant(), assumptions))
    return false;
  for (uint32_t i : llvm::seq<uint32_t>(0, view.getAddTermCount())) {
    sym::AddTerm term = view.getAddTerm(i);
    if (!isProvablyNonNegativeByShape(S, term.coefficient, assumptions) ||
        !isProvablyNonNegativeByShape(S, term.term, assumptions))
      return false;
  }
  return true;
}

static bool isNonNegativeMulExpr(WaveAMDMachineSelector &S,
                                 sym::ExprHandle expr,
                                 ArrayRef<sym::PredHandle> assumptions) {
  sym::ExprView view(expr);
  if (!isProvablyNonNegativeByShape(S, view.getMulCoefficient(), assumptions))
    return false;
  for (uint32_t i : llvm::seq<uint32_t>(0, view.getMulFactorCount())) {
    sym::MulFactor factor = view.getMulFactor(i);
    if (factor.exponent <= 0 ||
        !isProvablyNonNegativeByShape(S, factor.base, assumptions))
      return false;
  }
  return true;
}

static bool isNonNegativeModExpr(sym::ExprHandle expr) {
  std::optional<int64_t> divisor =
      staticIntLiteral(sym::ExprView(expr).getBinaryRhs());
  return divisor && *divisor > 0;
}

static bool
isProvablyNonNegativeByShape(WaveAMDMachineSelector &S, sym::ExprHandle expr,
                             ArrayRef<sym::PredHandle> assumptions) {
  if (hasInferredNonNegativeLowerBound(S, expr, assumptions))
    return true;
  sym::ExprView view(expr);
  switch (view.getKind()) {
  case sym::ExprKind::Integer:
  case sym::ExprKind::Rational:
    return isNonNegativeLiteral(expr);
  case sym::ExprKind::Add:
    return isNonNegativeAddExpr(S, expr, assumptions);
  case sym::ExprKind::Mul:
    return isNonNegativeMulExpr(S, expr, assumptions);
  case sym::ExprKind::Mod:
    return isNonNegativeModExpr(expr);
  case sym::ExprKind::Floor:
  case sym::ExprKind::Ceil:
    return isProvablyNonNegativeByShape(S, view.getUnaryArg(), assumptions);
  default:
    return false;
  }
}

static LogicalResult requireNonNegativeRoundedExpr(
    WaveAMDMachineSelector &S, sym::ExprHandle sourceExpr, Operation *user,
    ArrayRef<sym::PredHandle> assumptions, StringRef opName) {
  std::optional<sym::InferredRange> range =
      sym::inferRange(S.symbolStore(), sourceExpr, assumptions);
  if (range && hasNonNegativeLowerBound(*range))
    return success();
  if (isProvablyNonNegativeByShape(S, sourceExpr, assumptions))
    return success();
  return user->emitError("wave.index_expr ")
         << opName << " shift lowering needs nonnegative operand";
}

static FailureOr<Value>
materializeFloorRational(WaveAMDMachineSelector &S, RationalIndexValue value,
                         sym::ExprHandle sourceExpr, Operation *user,
                         ArrayRef<sym::PredHandle> assumptions) {
  std::optional<int64_t> staticDen = getStaticInt(S, value.denominator);
  if (!staticDen)
    return user->emitError("wave.index_expr floor needs a static denominator");
  int64_t den = *staticDen;
  FailureOr<Value> numerator =
      materializeValue(S, user->getLoc(), value.numerator, user);
  if (failed(numerator))
    return failure();
  if (den == 1)
    return *numerator;
  if (den <= 0 || (den & (den - 1)) != 0)
    return user->emitError(
               "wave.index_expr floor needs a power-of-two denominator (got ")
           << den << ")";
  if (failed(requireNonNegativeRoundedExpr(S, sourceExpr, user, assumptions,
                                           "floor")))
    return failure();
  return S.shrPow2(user->getLoc(), *numerator, llvm::Log2_64(den));
}

static FailureOr<Value>
materializeCeilRational(WaveAMDMachineSelector &S, RationalIndexValue value,
                        sym::ExprHandle sourceExpr, Operation *user,
                        ArrayRef<sym::PredHandle> assumptions) {
  std::optional<int64_t> staticDen = getStaticInt(S, value.denominator);
  if (!staticDen)
    return user->emitError("wave.index_expr ceil needs a static denominator");
  int64_t den = *staticDen;
  FailureOr<Value> numerator =
      materializeValue(S, user->getLoc(), value.numerator, user);
  if (failed(numerator))
    return failure();
  if (den == 1)
    return *numerator;
  if (den <= 0 || (den & (den - 1)) != 0)
    return user->emitError(
               "wave.index_expr ceil needs a power-of-two denominator (got ")
           << den << ")";
  if (failed(requireNonNegativeRoundedExpr(S, sourceExpr, user, assumptions,
                                           "ceil")))
    return failure();
  Value bias = createImm(S.builder, user->getLoc(), den - 1);
  Value biased = S.isUniformValue(*numerator)
                     ? S.addUniformBytes(user->getLoc(), *numerator, bias)
                     : S.addByteOffsets(user->getLoc(), *numerator, bias);
  return S.shrPow2(user->getLoc(), biased, llvm::Log2_64(den));
}

static FailureOr<Value> materializeIntegerRationalExpr(
    WaveAMDMachineSelector &S, sym::ExprHandle expr, Operation *user,
    const llvm::StringMap<Value> &subs, ArrayRef<sym::PredHandle> assumptions) {
  FailureOr<RationalIndexValue> value =
      materializeRationalIndexExprNode(S, expr, user, subs, assumptions);
  if (failed(value))
    return failure();
  std::optional<int64_t> staticDen = getStaticInt(S, value->denominator);
  if (!staticDen)
    return user->emitError("wave.index_expr needs a static denominator");
  int64_t den = *staticDen;
  FailureOr<Value> numerator =
      materializeValue(S, user->getLoc(), value->numerator, user);
  if (failed(numerator))
    return failure();
  if (den == 1)
    return *numerator;
  if (!canMaterializeIntegerRationalExpr(expr))
    return user->emitError(
        "wave.index_expr selection rejects non-integer rational");
  if (failed(requireNonNegativeRoundedExpr(S, expr, user, assumptions,
                                           "rational")))
    return failure();
  return S.shrPow2(user->getLoc(), *numerator, llvm::Log2_64(den));
}

static FailureOr<int64_t> getStaticModDivisor(WaveAMDMachineSelector &S,
                                              RationalIndexValue lhs,
                                              RationalIndexValue rhs,
                                              Operation *user) {
  std::optional<int64_t> lhsDen = getStaticInt(S, lhs.denominator);
  std::optional<int64_t> rhsDen = getStaticInt(S, rhs.denominator);
  std::optional<int64_t> rhsNum = getStaticInt(S, rhs.numerator);
  if (!lhsDen || !rhsDen || *rhsDen != 1 || !rhsNum)
    return user->emitError(
        "wave.index_expr mod needs a static integer divisor");
  std::optional<int64_t> divisor = llvm::checkedMul(*lhsDen, *rhsNum);
  if (!divisor || *divisor <= 0 || (*divisor & (*divisor - 1)) != 0)
    return user->emitError(
        "wave.index_expr mod needs a power-of-two integer divisor");
  return *divisor;
}

static FailureOr<RationalIndexValue>
materializeRationalMod(WaveAMDMachineSelector &S, sym::ExprHandle expr,
                       Operation *user, const llvm::StringMap<Value> &subs,
                       ArrayRef<sym::PredHandle> assumptions) {
  sym::ExprView view(expr);
  FailureOr<RationalIndexValue> lhs = materializeRationalIndexExprNode(
      S, view.getBinaryLhs(), user, subs, assumptions);
  if (failed(lhs))
    return failure();
  FailureOr<RationalIndexValue> rhs = materializeRationalIndexExprNode(
      S, view.getBinaryRhs(), user, subs, assumptions);
  if (failed(rhs))
    return failure();
  FailureOr<int64_t> divisor = getStaticModDivisor(S, *lhs, *rhs, user);
  if (failed(divisor))
    return failure();
  FailureOr<Value> lhsNumerator =
      materializeValue(S, user->getLoc(), lhs->numerator, user);
  if (failed(lhsNumerator))
    return failure();
  Value numerator = S.andMask(user->getLoc(), *lhsNumerator, *divisor - 1);
  return RationalIndexValue{numerator, lhs->denominator};
}

static FailureOr<RationalIndexValue>
materializeRationalXor(WaveAMDMachineSelector &S, sym::ExprHandle expr,
                       Operation *user, const llvm::StringMap<Value> &subs,
                       ArrayRef<sym::PredHandle> assumptions) {
  Location loc = user->getLoc();
  sym::ExprView view(expr);
  FailureOr<RationalIndexValue> lhs = materializeRationalIndexExprNode(
      S, view.getBinaryLhs(), user, subs, assumptions);
  FailureOr<RationalIndexValue> rhs = materializeRationalIndexExprNode(
      S, view.getBinaryRhs(), user, subs, assumptions);
  if (failed(lhs) || failed(rhs))
    return failure();
  if (failed(requireIntegerRationalOperands(S, *lhs, *rhs, user)))
    return failure();
  FailureOr<BinaryValues> numerators =
      materializeRationalNumerators(S, loc, *lhs, *rhs, user);
  if (failed(numerators))
    return failure();
  if (std::optional<Value> folded =
          foldXorImmediates(S, loc, numerators->lhs, numerators->rhs))
    return RationalIndexValue{*folded, getIntFoldResult(S, 1)};
  Value numerator =
      S.isUniformValue(numerators->lhs) && S.isUniformValue(numerators->rhs)
          ? materializeUniformXor(S, loc, numerators->lhs, numerators->rhs)
          : materializeLaneXor(S, loc, numerators->lhs, numerators->rhs);
  return RationalIndexValue{numerator, getIntFoldResult(S, 1)};
}

static LogicalResult requireIntegerRationalOperands(WaveAMDMachineSelector &S,
                                                    RationalIndexValue lhs,
                                                    RationalIndexValue rhs,
                                                    Operation *user) {
  std::optional<int64_t> lhsDen = getStaticInt(S, lhs.denominator);
  std::optional<int64_t> rhsDen = getStaticInt(S, rhs.denominator);
  if (!lhsDen || !rhsDen || *lhsDen != 1 || *rhsDen != 1)
    return user->emitError("wave.index_expr xor needs integer operands");
  return success();
}

static FailureOr<BinaryValues>
materializeRationalNumerators(WaveAMDMachineSelector &S, Location loc,
                              RationalIndexValue lhs, RationalIndexValue rhs,
                              Operation *user) {
  FailureOr<Value> lhsNumerator = materializeValue(S, loc, lhs.numerator, user);
  FailureOr<Value> rhsNumerator = materializeValue(S, loc, rhs.numerator, user);
  if (failed(lhsNumerator) || failed(rhsNumerator))
    return failure();
  return BinaryValues{*lhsNumerator, *rhsNumerator};
}

static FailureOr<RationalIndexValue>
materializeRationalPrimitiveIndexExprNode(WaveAMDMachineSelector &S,
                                          sym::ExprHandle expr, Operation *user,
                                          const llvm::StringMap<Value> &subs) {
  sym::ExprView view(expr);
  switch (view.getKind()) {
  case sym::ExprKind::Integer:
    if (std::optional<int64_t> value = view.getInt())
      return getIntRational(S, *value);
    break;
  case sym::ExprKind::Rational: {
    std::optional<sym::RationalLiteral> value = view.getRational();
    if (!value || value->denominator <= 0)
      return user->emitError("wave.index_expr has invalid rational literal");
    return RationalIndexValue{getIntFoldResult(S, value->numerator),
                              getIntFoldResult(S, value->denominator)};
  }
  case sym::ExprKind::Symbol: {
    FailureOr<Value> value = materializeSymbol(S, expr, user, subs);
    if (failed(value))
      return failure();
    return RationalIndexValue{*value, getIntFoldResult(S, 1)};
  }
  default:
    break;
  }
  return user->emitError(
             "wave.index_expr selection does not support expression kind ")
         << static_cast<int>(view.getKind());
}

static FailureOr<RationalIndexValue> materializeRationalRoundedIndexExprNode(
    WaveAMDMachineSelector &S, sym::ExprHandle expr, Operation *user,
    const llvm::StringMap<Value> &subs, ArrayRef<sym::PredHandle> assumptions,
    bool isCeil) {
  sym::ExprHandle childExpr = sym::ExprView(expr).getUnaryArg();
  FailureOr<RationalIndexValue> child =
      materializeRationalIndexExprNode(S, childExpr, user, subs, assumptions);
  if (failed(child))
    return failure();
  FailureOr<Value> value =
      isCeil
          ? materializeCeilRational(S, *child, childExpr, user, assumptions)
          : materializeFloorRational(S, *child, childExpr, user, assumptions);
  if (failed(value))
    return failure();
  return RationalIndexValue{*value, getIntFoldResult(S, 1)};
}

static FailureOr<RationalIndexValue> materializeRationalCompoundIndexExprNode(
    WaveAMDMachineSelector &S, sym::ExprHandle expr, Operation *user,
    const llvm::StringMap<Value> &subs, ArrayRef<sym::PredHandle> assumptions) {
  sym::ExprView view(expr);
  switch (view.getKind()) {
  case sym::ExprKind::Add:
    return materializeRationalAdd(S, expr, user, subs, assumptions);
  case sym::ExprKind::Mul:
    return materializeRationalMul(S, expr, user, subs, assumptions);
  case sym::ExprKind::Floor:
    return materializeRationalRoundedIndexExprNode(
        S, expr, user, subs, assumptions, /*isCeil=*/false);
  case sym::ExprKind::Ceil:
    return materializeRationalRoundedIndexExprNode(
        S, expr, user, subs, assumptions, /*isCeil=*/true);
  case sym::ExprKind::Mod:
    return materializeRationalMod(S, expr, user, subs, assumptions);
  case sym::ExprKind::Xor:
    return materializeRationalXor(S, expr, user, subs, assumptions);
  default:
    break;
  }
  return user->emitError(
             "wave.index_expr selection does not support expression kind ")
         << static_cast<int>(view.getKind());
}

static FailureOr<RationalIndexValue> materializeRationalIndexExprNode(
    WaveAMDMachineSelector &S, sym::ExprHandle expr, Operation *user,
    const llvm::StringMap<Value> &subs, ArrayRef<sym::PredHandle> assumptions) {
  sym::ExprKind kind = sym::ExprView(expr).getKind();
  if (kind == sym::ExprKind::Integer || kind == sym::ExprKind::Rational ||
      kind == sym::ExprKind::Symbol)
    return materializeRationalPrimitiveIndexExprNode(S, expr, user, subs);
  return materializeRationalCompoundIndexExprNode(S, expr, user, subs,
                                                  assumptions);
}

static FailureOr<Value> materializeFloor(WaveAMDMachineSelector &S,
                                         sym::ExprHandle expr, Operation *user,
                                         const llvm::StringMap<Value> &subs,
                                         ArrayRef<sym::PredHandle> assumptions,
                                         IndexExprAddOrder addOrder) {
  sym::ExprHandle childExpr = sym::ExprView(expr).getUnaryArg();
  FailureOr<RationalIndexValue> value =
      materializeRationalIndexExprNode(S, childExpr, user, subs, assumptions);
  if (failed(value))
    return failure();
  return materializeFloorRational(S, *value, childExpr, user, assumptions);
}

static FailureOr<Value> materializeCeil(WaveAMDMachineSelector &S,
                                        sym::ExprHandle expr, Operation *user,
                                        const llvm::StringMap<Value> &subs,
                                        ArrayRef<sym::PredHandle> assumptions,
                                        IndexExprAddOrder addOrder) {
  sym::ExprHandle childExpr = sym::ExprView(expr).getUnaryArg();
  FailureOr<RationalIndexValue> value =
      materializeRationalIndexExprNode(S, childExpr, user, subs, assumptions);
  if (failed(value))
    return failure();
  return materializeCeilRational(S, *value, childExpr, user, assumptions);
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

static bool isWideScalarIntegerValue(Value value) {
  auto intType = dyn_cast<IntegerType>(value.getType());
  return intType && intType.isSignless() && intType.getWidth() > 32;
}

static bool
exprReferencesWideScalarInteger(sym::ExprHandle expr,
                                const llvm::StringMap<bool> &wideSymbols);

static bool
addExprReferencesWideScalarInteger(sym::ExprHandle expr,
                                   const llvm::StringMap<bool> &wideSymbols) {
  sym::ExprView view(expr);
  if (exprReferencesWideScalarInteger(view.getAddConstant(), wideSymbols))
    return true;
  for (uint32_t i = 0, e = view.getAddTermCount(); i != e; ++i) {
    sym::AddTerm term = view.getAddTerm(i);
    if (exprReferencesWideScalarInteger(term.coefficient, wideSymbols) ||
        exprReferencesWideScalarInteger(term.term, wideSymbols))
      return true;
  }
  return false;
}

static bool
mulExprReferencesWideScalarInteger(sym::ExprHandle expr,
                                   const llvm::StringMap<bool> &wideSymbols) {
  sym::ExprView view(expr);
  if (exprReferencesWideScalarInteger(view.getMulCoefficient(), wideSymbols))
    return true;
  for (uint32_t i = 0, e = view.getMulFactorCount(); i != e; ++i)
    if (exprReferencesWideScalarInteger(view.getMulFactor(i).base, wideSymbols))
      return true;
  return false;
}

static bool
exprReferencesWideScalarInteger(sym::ExprHandle expr,
                                const llvm::StringMap<bool> &wideSymbols) {
  sym::ExprView view(expr);
  switch (view.getKind()) {
  case sym::ExprKind::Symbol:
    return wideSymbols.lookup(view.getSymbolName());
  case sym::ExprKind::Add:
    return addExprReferencesWideScalarInteger(expr, wideSymbols);
  case sym::ExprKind::Mul:
    return mulExprReferencesWideScalarInteger(expr, wideSymbols);
  case sym::ExprKind::Floor:
  case sym::ExprKind::Ceil:
    return exprReferencesWideScalarInteger(view.getUnaryArg(), wideSymbols);
  case sym::ExprKind::Mod:
  case sym::ExprKind::Xor:
    return exprReferencesWideScalarInteger(view.getBinaryLhs(), wideSymbols) ||
           exprReferencesWideScalarInteger(view.getBinaryRhs(), wideSymbols);
  default:
    return false;
  }
}

static bool needsWideAddressMaterializationImpl(sym::ExprHandle expr,
                                                const AddressPlan &plan) {
  if (!expr)
    return false;
  llvm::StringMap<bool> wideSymbols;
  for (const PointerOffsetBinding &binding : plan.bindings)
    wideSymbols[binding.name] = isWideScalarIntegerValue(binding.value);
  return exprReferencesWideScalarInteger(expr, wideSymbols);
}

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
  int64_t headroom = static_cast<int64_t>(spec.instOffsetHeadroom);
  std::optional<int64_t> high = llvm::checkedSub(range.second, headroom);
  if (!high || *high < range.first)
    return false;
  range.second = *high;
  return value >= range.first && value <= range.second;
}

static int64_t floorMod(int64_t value, int64_t modulus) {
  int64_t rem = value % modulus;
  return rem < 0 ? rem + modulus : rem;
}

static std::optional<std::pair<int64_t, int64_t>>
usableInstOffsetRange(const waveamdmachine::AddressFieldSpec &spec) {
  std::pair<int64_t, int64_t> range = waveamdmachine::instOffsetRange(spec);
  int64_t headroom = static_cast<int64_t>(spec.instOffsetHeadroom);
  std::optional<int64_t> high = llvm::checkedSub(range.second, headroom);
  if (!high || *high < range.first)
    return std::nullopt;
  return std::make_pair(range.first, *high);
}

static bool containsInt(std::pair<int64_t, int64_t> range, int64_t value) {
  return value >= range.first && value <= range.second;
}

static std::optional<int64_t>
wrapInstOffset(int64_t total, std::pair<int64_t, int64_t> fullRange,
               std::pair<int64_t, int64_t> usableRange, unsigned bits) {
  int64_t quantum = int64_t{1} << bits;
  std::optional<int64_t> shifted = llvm::checkedSub(total, fullRange.first);
  if (!shifted)
    return std::nullopt;
  int64_t instOffset = fullRange.first + floorMod(*shifted, quantum);
  if (containsInt(usableRange, instOffset))
    return instOffset;
  int64_t alternate = instOffset - quantum;
  if (containsInt(usableRange, alternate))
    return alternate;
  return std::nullopt;
}

static bool
canSplitInstOffsetConstant(int64_t total,
                           const waveamdmachine::AddressFieldSpec &spec) {
  if (spec.instOffsetBits == 0 || spec.instOffsetBits >= 62)
    return false;
  return spec.instOffsetSigned || total >= 0;
}

static bool splitLeavesConstantUntaken(std::optional<int64_t> remainder,
                                       int64_t instOffset, int64_t current,
                                       int64_t addend) {
  if (!remainder)
    return true;
  return instOffset == current && *remainder == addend;
}

static std::optional<std::pair<int64_t, int64_t>>
splitInstOffsetConstant(int64_t current, int64_t addend,
                        const waveamdmachine::AddressFieldSpec &spec) {
  std::optional<int64_t> total = llvm::checkedAdd(current, addend);
  if (!total)
    return std::nullopt;
  if (!canSplitInstOffsetConstant(*total, spec))
    return std::nullopt;
  std::optional<std::pair<int64_t, int64_t>> usableRange =
      usableInstOffsetRange(spec);
  if (!usableRange)
    return std::nullopt;
  if (containsInt(*usableRange, *total))
    return std::make_pair(*total, int64_t{0});
  if (!spec.instOffsetSigned && *total < 0)
    return std::nullopt;

  std::pair<int64_t, int64_t> fullRange = waveamdmachine::instOffsetRange(spec);
  std::optional<int64_t> instOffset =
      wrapInstOffset(*total, fullRange, *usableRange, spec.instOffsetBits);
  if (!instOffset)
    return std::nullopt;
  std::optional<int64_t> remainder = llvm::checkedSub(*total, *instOffset);
  if (splitLeavesConstantUntaken(remainder, *instOffset, current, addend))
    return std::nullopt;
  return std::make_pair(*instOffset, *remainder);
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

static LogicalResult appendPlanIntRemainder(WaveAMDMachineSelector &S,
                                            int64_t value, AddressPlan &plan) {
  FailureOr<sym::ExprHandle> remainder =
      sym::composeExprInt(S.symbolStore(), value);
  if (failed(remainder))
    return failure();
  return appendPlanRemainder(S, *remainder, plan);
}

static FailureOr<bool>
takeInstOffsetConstAddend(WaveAMDMachineSelector &S,
                          const waveamdmachine::AddressFieldSpec &spec,
                          int64_t value, AddressPlan &plan) {
  std::optional<int64_t> next = llvm::checkedAdd(plan.instOffset, value);
  if (next && instOffsetFits(*next, spec)) {
    plan.instOffset = *next;
    return true;
  }

  std::optional<std::pair<int64_t, int64_t>> split =
      splitInstOffsetConstant(plan.instOffset, value, spec);
  if (!split)
    return false;
  plan.instOffset = split->first;
  if (split->second == 0)
    return true;
  if (failed(appendPlanIntRemainder(S, split->second, plan)))
    return failure();
  return true;
}

static LogicalResult
takeInstOffsetAddends(WaveAMDMachineSelector &S,
                      const waveamdmachine::AddressFieldSpec &spec,
                      ArrayRef<AddressPlanAddend> addends, AddressPlan &plan) {
  for (const AddressPlanAddend &addend : addends) {
    if (addend.kind != TermKind::Const)
      continue;
    std::optional<int64_t> value = sym::getIntegerLiteralValue(addend.expr);
    if (value) {
      FailureOr<bool> took = takeInstOffsetConstAddend(S, spec, *value, plan);
      if (failed(took))
        return failure();
      if (*took)
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
                                         sym::ExprHandle &slotExpr,
                                         bool &slotNeedsWide) {
  if (!expr)
    return true;
  sym::ExprHandle candidate = slotExpr;
  if (failed(appendPlanExpr(S, expr, plan.assumptions, candidate)))
    return failure();
  if (!S.slotFitsU32(candidate, plan.assumptions))
    return false;
  slotNeedsWide = needsWideAddressMaterialization(candidate, plan);
  slotExpr = candidate;
  return true;
}

static LogicalResult
packPlanSlotAddends(WaveAMDMachineSelector &S, TermKind kind,
                    ArrayRef<AddressPlanAddend> addends, AddressPlan &plan,
                    sym::ExprHandle &slotExpr, bool &slotNeedsWide) {
  for (const AddressPlanAddend &addend : addends) {
    if (addend.kind != kind)
      continue;
    FailureOr<bool> took =
        tryAppendPlanSlot(S, addend.expr, plan, slotExpr, slotNeedsWide);
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
                               plan.soffsetExpr, plan.soffsetNeedsWide);
  return appendPlanAddendsRemainder(S, TermKind::Uniform, addends, plan);
}

} // namespace

// ---- public surface (declared in WaveAMDMachineSelector.h) ----------------

std::optional<RationalPow2Shape> inferRationalPow2Shape(sym::ExprHandle expr) {
  return inferRationalPow2ShapeImpl(expr);
}

bool isIntegerValuedRationalPow2Expr(sym::ExprHandle expr,
                                     int64_t denominator) {
  if (denominator == 1)
    return true;
  if (!isPositivePowerOfTwo(denominator))
    return false;
  std::optional<RationalPow2Shape> shape = inferRationalPow2Shape(expr);
  return shape && shape->denominator == denominator &&
         shape->numeratorPow2Divisibility >= llvm::Log2_64(denominator);
}

bool needsWideAddressMaterialization(sym::ExprHandle expr,
                                     const AddressPlan &plan) {
  return needsWideAddressMaterializationImpl(expr, plan);
}

static FailureOr<Value> materializeCompoundIndexExprNode(
    WaveAMDMachineSelector &S, sym::ExprHandle expr, Operation *user,
    const llvm::StringMap<Value> &subs, ArrayRef<sym::PredHandle> assumptions,
    IndexExprAddOrder addOrder) {
  sym::ExprView view(expr);
  switch (view.getKind()) {
  case sym::ExprKind::Add:
    return materializeAdd(S, expr, user, subs, assumptions, addOrder);
  case sym::ExprKind::Mul:
    return materializeMul(S, expr, user, subs, assumptions, addOrder);
  case sym::ExprKind::Floor:
    return materializeFloor(S, expr, user, subs, assumptions, addOrder);
  case sym::ExprKind::Ceil:
    return materializeCeil(S, expr, user, subs, assumptions, addOrder);
  case sym::ExprKind::Mod:
    return materializeMod(S, expr, user, subs, assumptions, addOrder);
  case sym::ExprKind::Xor:
    return materializeXor(S, expr, user, subs, assumptions, addOrder);
  default:
    break;
  }
  return user->emitError(
             "wave.index_expr selection does not support expression kind ")
         << static_cast<int>(view.getKind());
}

FailureOr<Value> materializeIndexExprNode(WaveAMDMachineSelector &S,
                                          sym::ExprHandle expr, Operation *user,
                                          const llvm::StringMap<Value> &subs,
                                          ArrayRef<sym::PredHandle> assumptions,
                                          IndexExprAddOrder addOrder) {
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
    return materializeCompoundIndexExprNode(S, expr, user, subs, assumptions,
                                            addOrder);
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
                                 plan.voffsetExpr, plan.voffsetNeedsWide)))
    return failure();
  return plan;
}

} // namespace mlir::wave::wmsel
