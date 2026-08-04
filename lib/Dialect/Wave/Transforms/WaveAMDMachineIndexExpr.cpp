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

#include "llvm/ADT/APInt.h"
#include "llvm/Support/CheckedArithmetic.h"
#include "llvm/Support/DivisionByConstantInfo.h"
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

static std::optional<int64_t>
staticBoundInt(WaveAMDMachineSelector &S, sym::ExprHandle expr,
               const llvm::StringMap<Value> &subs) {
  if (std::optional<int64_t> literal = staticIntLiteral(expr))
    return literal;
  sym::ExprView view(expr);
  if (view.getKind() != sym::ExprKind::Symbol)
    return std::nullopt;
  auto it = subs.find(view.getSymbolName());
  if (it == subs.end())
    return std::nullopt;
  if (std::optional<int64_t> immediate = S.getImmediateValue(it->second))
    return immediate;
  if (auto mov = it->second.getDefiningOp<waveamdmachine::SMovB64ImmOp>())
    return mov.getValue();
  return std::nullopt;
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

static FailureOr<bool> canMaterializeIntegerRationalExpr(
    WaveAMDMachineSelector &S, sym::ExprHandle expr, Operation *user,
    const llvm::StringMap<Value> &subs, ArrayRef<sym::PredHandle> assumptions,
    std::unique_ptr<sym::Analysis> &analysis);

static FailureOr<Value> materializeIntegerRationalExpr(
    WaveAMDMachineSelector &S, sym::Analysis &analysis, sym::ExprHandle expr,
    Operation *user, const llvm::StringMap<Value> &subs,
    ArrayRef<sym::PredHandle> assumptions);
static bool isPositivePowerOfTwo(int64_t value);
static bool isProvablyNonNegative(WaveAMDMachineSelector &S,
                                  sym::ExprHandle expr,
                                  ArrayRef<sym::PredHandle> assumptions);
static bool isProvablyNonNegative(sym::Analysis &analysis,
                                  sym::ExprHandle expr);

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

static TermKind
predicateMaterializationKind(WaveAMDMachineSelector &S, sym::PredHandle pred,
                             const llvm::StringMap<Value> &subs) {
  sym::PredView view(pred);
  switch (view.getKind()) {
  case sym::PredKind::True:
  case sym::PredKind::False:
    return TermKind::Const;
  case sym::PredKind::Cmp:
    return std::max(materializationKind(S, view.getCmpLhs(), subs),
                    materializationKind(S, view.getCmpRhs(), subs));
  case sym::PredKind::And:
  case sym::PredKind::Or: {
    TermKind kind = TermKind::Const;
    for (uint32_t i = 0, e = view.getLogicArgCount(); i != e; ++i)
      kind = std::max(
          kind, predicateMaterializationKind(S, view.getLogicArg(i), subs));
    return kind;
  }
  case sym::PredKind::Not:
    return predicateMaterializationKind(S, view.getUnaryArg(), subs);
  default:
    return TermKind::Lane;
  }
}

static TermKind
piecewiseMaterializationKind(WaveAMDMachineSelector &S, sym::ExprHandle expr,
                             const llvm::StringMap<Value> &subs) {
  sym::ExprView view(expr);
  TermKind kind = TermKind::Const;
  for (uint32_t i = 0, e = view.getPiecewiseCaseCount(); i != e; ++i) {
    sym::PiecewiseCase piece = view.getPiecewiseCase(i);
    kind = std::max(kind, materializationKind(S, piece.value, subs));
    kind =
        std::max(kind, predicateMaterializationKind(S, piece.condition, subs));
  }
  return kind;
}

static TermKind assocMaterializationKind(WaveAMDMachineSelector &S,
                                         sym::ExprView view,
                                         const llvm::StringMap<Value> &subs) {
  TermKind kind = TermKind::Const;
  for (uint32_t i = 0, e = view.getAssocArgCount(); i != e; ++i)
    kind = std::max(kind, materializationKind(S, view.getAssocArg(i), subs));
  return kind;
}

static TermKind compoundMaterializationKind(WaveAMDMachineSelector &S,
                                            sym::ExprHandle expr,
                                            const llvm::StringMap<Value> &subs,
                                            sym::ExprView view) {
  switch (view.getKind()) {
  case sym::ExprKind::Add:
    return addMaterializationKind(S, expr, subs);
  case sym::ExprKind::Mul:
    return mulMaterializationKind(S, expr, subs);
  case sym::ExprKind::Floor:
  case sym::ExprKind::Ceil:
    return materializationKind(S, view.getUnaryArg(), subs);
  case sym::ExprKind::Mod:
    return std::max(materializationKind(S, view.getBinaryLhs(), subs),
                    materializationKind(S, view.getBinaryRhs(), subs));
  case sym::ExprKind::Xor:
  case sym::ExprKind::And:
  case sym::ExprKind::Or:
    return assocMaterializationKind(S, view, subs);
  case sym::ExprKind::Piecewise:
    return piecewiseMaterializationKind(S, expr, subs);
  default:
    return TermKind::Lane;
  }
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
  default:
    return compoundMaterializationKind(S, expr, subs, view);
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

static unsigned
predicateMaterializationLoopDepth(sym::PredHandle pred, Operation *user,
                                  const llvm::StringMap<Value> &subs) {
  sym::PredView view(pred);
  switch (view.getKind()) {
  case sym::PredKind::True:
  case sym::PredKind::False:
    return 0;
  case sym::PredKind::Cmp:
    return std::max(materializationLoopDepth(view.getCmpLhs(), user, subs),
                    materializationLoopDepth(view.getCmpRhs(), user, subs));
  case sym::PredKind::And:
  case sym::PredKind::Or: {
    unsigned depth = 0;
    for (uint32_t i = 0, e = view.getLogicArgCount(); i != e; ++i)
      depth = std::max(depth, predicateMaterializationLoopDepth(
                                  view.getLogicArg(i), user, subs));
    return depth;
  }
  case sym::PredKind::Not:
    return predicateMaterializationLoopDepth(view.getUnaryArg(), user, subs);
  default:
    return std::numeric_limits<unsigned>::max();
  }
}

static unsigned
piecewiseMaterializationLoopDepth(sym::ExprHandle expr, Operation *user,
                                  const llvm::StringMap<Value> &subs) {
  sym::ExprView view(expr);
  unsigned depth = 0;
  for (uint32_t i = 0, e = view.getPiecewiseCaseCount(); i != e; ++i) {
    sym::PiecewiseCase piece = view.getPiecewiseCase(i);
    depth = std::max(depth, materializationLoopDepth(piece.value, user, subs));
    depth = std::max(
        depth, predicateMaterializationLoopDepth(piece.condition, user, subs));
  }
  return depth;
}

static unsigned
assocMaterializationLoopDepth(sym::ExprView view, Operation *user,
                              const llvm::StringMap<Value> &subs) {
  unsigned depth = 0;
  for (uint32_t i = 0, e = view.getAssocArgCount(); i != e; ++i)
    depth = std::max(depth,
                     materializationLoopDepth(view.getAssocArg(i), user, subs));
  return depth;
}

static unsigned
compoundMaterializationLoopDepth(sym::ExprHandle expr, Operation *user,
                                 const llvm::StringMap<Value> &subs,
                                 sym::ExprView view) {
  switch (view.getKind()) {
  case sym::ExprKind::Add:
    return addMaterializationLoopDepth(expr, user, subs);
  case sym::ExprKind::Mul:
    return mulMaterializationLoopDepth(expr, user, subs);
  case sym::ExprKind::Floor:
  case sym::ExprKind::Ceil:
    return materializationLoopDepth(view.getUnaryArg(), user, subs);
  case sym::ExprKind::Mod:
    return std::max(materializationLoopDepth(view.getBinaryLhs(), user, subs),
                    materializationLoopDepth(view.getBinaryRhs(), user, subs));
  case sym::ExprKind::Xor:
  case sym::ExprKind::And:
  case sym::ExprKind::Or:
    return assocMaterializationLoopDepth(view, user, subs);
  case sym::ExprKind::Piecewise:
    return piecewiseMaterializationLoopDepth(expr, user, subs);
  default:
    return std::numeric_limits<unsigned>::max();
  }
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
  default:
    return compoundMaterializationLoopDepth(expr, user, subs, view);
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
  std::unique_ptr<sym::Analysis> analysis;
  FailureOr<bool> rational = canMaterializeIntegerRationalExpr(
      S, expr, user, subs, assumptions, analysis);
  if (failed(rational))
    return failure();
  if (*rational)
    return materializeIntegerRationalExpr(S, *analysis, expr, user, subs,
                                          assumptions);
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
  std::unique_ptr<sym::Analysis> analysis;
  FailureOr<bool> rational = canMaterializeIntegerRationalExpr(
      S, expr, user, subs, assumptions, analysis);
  if (failed(rational))
    return failure();
  if (*rational)
    return materializeIntegerRationalExpr(S, *analysis, expr, user, subs,
                                          assumptions);
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

static Value addIndexValues(WaveAMDMachineSelector &S, Location loc, Value lhs,
                            Value rhs) {
  if (S.isUniformValue(lhs) && S.isUniformValue(rhs))
    return S.addUniformBytes(loc, lhs, rhs);
  return S.addByteOffsets(loc, lhs, rhs);
}

static Value xorPreservingDomain(WaveAMDMachineSelector &S, Location loc,
                                 Value value, int64_t rhs) {
  if (std::optional<int64_t> imm = S.getImmediateValue(value))
    return createImm(S.builder, loc,
                     static_cast<int64_t>(static_cast<uint32_t>(*imm) ^
                                          static_cast<uint32_t>(rhs)));
  Value rhsValue = createImm(S.builder, loc, rhs);
  if (S.isUniformValue(value))
    return waveamdmachine::SXorB32Op::create(
               S.builder, loc,
               getRegType(S.builder.getContext(),
                          waveamdmachine::RegClass::SGPR),
               getSCCType(S.builder.getContext()), S.ensureSGPR1(loc, value),
               rhsValue)
        .getResult();
  value = S.ensureVGPRForVSrc1(loc, value);
  return waveamdmachine::VXorB32Op::create(
      S.builder, loc,
      getRegType(S.builder.getContext(), waveamdmachine::RegClass::VGPR), value,
      rhsValue);
}

static Value subIndexValues(WaveAMDMachineSelector &S, Location loc, Value lhs,
                            Value rhs) {
  std::optional<int64_t> lhsImm = S.getImmediateValue(lhs);
  std::optional<int64_t> rhsImm = S.getImmediateValue(rhs);
  if (lhsImm && rhsImm) {
    uint32_t diff =
        static_cast<uint32_t>(*lhsImm) - static_cast<uint32_t>(*rhsImm);
    return createImm(S.builder, loc, static_cast<int64_t>(diff));
  }
  Value notRhs = xorPreservingDomain(S, loc, rhs, -1);
  Value negRhs = addIndexValues(S, loc, notRhs, createImm(S.builder, loc, 1));
  return addIndexValues(S, loc, lhs, negRhs);
}

static Value mulHiU32(WaveAMDMachineSelector &S, Location loc, Value value,
                      uint32_t multiplier) {
  if (std::optional<int64_t> imm = S.getImmediateValue(value)) {
    uint64_t product = static_cast<uint64_t>(static_cast<uint32_t>(*imm)) *
                       static_cast<uint64_t>(multiplier);
    return createImm(S.builder, loc, static_cast<int64_t>(product >> 32));
  }
  Value rhs = createImm(S.builder, loc, static_cast<int64_t>(multiplier));
  if (S.isUniformValue(value))
    return waveamdmachine::SMulHiU32Op::create(
        S.builder, loc,
        getRegType(S.builder.getContext(), waveamdmachine::RegClass::SGPR),
        S.ensureSGPR1(loc, value), rhs);
  value = S.ensureVGPRForVSrc1(loc, value);
  return waveamdmachine::VMulHiU32Op::create(
      S.builder, loc,
      getRegType(S.builder.getContext(), waveamdmachine::RegClass::VGPR), value,
      rhs);
}

static Value materializeUnsignedMagicQuotient(WaveAMDMachineSelector &S,
                                              Location loc, Value numerator,
                                              uint32_t divisor) {
  llvm::UnsignedDivisionByConstantInfo magics =
      llvm::UnsignedDivisionByConstantInfo::get(
          APInt(32, divisor), /*LeadingZeros=*/0,
          /*AllowEvenDivisorOptimization=*/true,
          /*AllowWidenOptimization=*/false);
  Value q = numerator;
  if (magics.PreShift != 0)
    q = S.shrPow2(loc, q, magics.PreShift);
  q = mulHiU32(S, loc, q, static_cast<uint32_t>(magics.Magic.getZExtValue()));
  if (magics.IsAdd) {
    Value npq = subIndexValues(S, loc, numerator, q);
    npq = S.shrPow2(loc, npq, 1);
    q = addIndexValues(S, loc, npq, q);
  }
  if (magics.PostShift != 0)
    q = S.shrPow2(loc, q, magics.PostShift);
  return q;
}

static FailureOr<Value> materializeStaticMod(WaveAMDMachineSelector &S,
                                             Operation *user, Value numerator,
                                             int64_t divisor) {
  if (divisor == 1)
    return createImm(S.builder, user->getLoc(), 0);
  if (isPositivePowerOfTwo(divisor))
    return S.andMask(user->getLoc(), numerator, divisor - 1);
  if (!llvm::isUInt<32>(divisor))
    return user->emitError("wave.index_expr non-power-of-two mod divisor "
                           "must fit u32");
  Value quotient = materializeUnsignedMagicQuotient(
      S, user->getLoc(), numerator, static_cast<uint32_t>(divisor));
  Value divisorValue = createImm(S.builder, user->getLoc(), divisor);
  Value scaled =
      S.isUniformValue(quotient)
          ? S.mulUniformValues(user->getLoc(), quotient, divisorValue)
          : S.mulIndexValues(user->getLoc(), quotient, divisorValue);
  return subIndexValues(S, user->getLoc(), numerator, scaled);
}

// mod(lhs, rhs). Power-of-two rhs stays a mask; other static rhs values use
// unsigned constant-division remainder.
FailureOr<Value> materializeMod(WaveAMDMachineSelector &S, sym::ExprHandle expr,
                                Operation *user,
                                const llvm::StringMap<Value> &subs,
                                ArrayRef<sym::PredHandle> assumptions,
                                IndexExprAddOrder addOrder) {
  sym::ExprView view(expr);
  sym::ExprHandle lhs = view.getBinaryLhs();
  sym::ExprHandle rhs = view.getBinaryRhs();
  std::optional<int64_t> rhsInt = staticBoundInt(S, rhs, subs);
  if (!rhsInt)
    return user->emitError("wave.index_expr mod needs a static integer "
                           "divisor; got ")
           << ExprAttr::get(user->getContext(), rhs) << " in "
           << ExprAttr::get(user->getContext(), expr);
  if (*rhsInt <= 0)
    return user->emitError("wave.index_expr mod needs a positive divisor");
  if (!isPositivePowerOfTwo(*rhsInt) &&
      !isProvablyNonNegative(S, lhs, assumptions))
    return user->emitError(
        "wave.index_expr non-power-of-two mod needs nonnegative dividend");
  if (!isPositivePowerOfTwo(*rhsInt) && !S.slotFitsU32(lhs, assumptions))
    return user->emitError(
        "wave.index_expr non-power-of-two mod dividend must fit u32");
  FailureOr<Value> lhsValue =
      materializeIndexExprNode(S, lhs, user, subs, assumptions, addOrder);
  if (failed(lhsValue))
    return failure();
  return materializeStaticMod(S, user, *lhsValue, *rhsInt);
}

static int64_t applyBitwise(sym::ExprKind kind, int64_t lhs, int64_t rhs) {
  switch (kind) {
  case sym::ExprKind::Xor:
    return lhs ^ rhs;
  case sym::ExprKind::And:
    return lhs & rhs;
  case sym::ExprKind::Or:
    return lhs | rhs;
  default:
    llvm_unreachable("expected bitwise expression");
  }
}

static sym::ExprBinaryOp getBitwiseBinaryOp(sym::ExprKind kind) {
  switch (kind) {
  case sym::ExprKind::Xor:
    return sym::ExprBinaryOp::Xor;
  case sym::ExprKind::And:
    return sym::ExprBinaryOp::And;
  case sym::ExprKind::Or:
    return sym::ExprBinaryOp::Or;
  default:
    llvm_unreachable("expected bitwise expression");
  }
}

static std::optional<Value> foldBitwiseImmediates(WaveAMDMachineSelector &S,
                                                  Location loc,
                                                  sym::ExprKind kind, Value lhs,
                                                  Value rhs) {
  std::optional<int64_t> lhsImm = S.getImmediateValue(lhs);
  std::optional<int64_t> rhsImm = S.getImmediateValue(rhs);
  if (lhsImm && rhsImm)
    return createImm(S.builder, loc, applyBitwise(kind, *lhsImm, *rhsImm));
  int64_t identity = kind == sym::ExprKind::And ? -1 : 0;
  if (lhsImm && *lhsImm == identity)
    return rhs;
  if (rhsImm && *rhsImm == identity)
    return lhs;
  return std::nullopt;
}

static Value materializeUniformBitwise(WaveAMDMachineSelector &S, Location loc,
                                       sym::ExprKind kind, Value lhs,
                                       Value rhs) {
  Type resultType =
      getRegType(S.builder.getContext(), waveamdmachine::RegClass::SGPR);
  Type sccType = getSCCType(S.builder.getContext());
  switch (kind) {
  case sym::ExprKind::Xor:
    return waveamdmachine::SXorB32Op::create(S.builder, loc, resultType,
                                             sccType, lhs, rhs)
        .getResult();
  case sym::ExprKind::And:
    return waveamdmachine::SAndB32Op::create(S.builder, loc, resultType,
                                             sccType, lhs, rhs)
        .getResult();
  case sym::ExprKind::Or:
    return waveamdmachine::SOrB32Op::create(S.builder, loc, resultType, sccType,
                                            lhs, rhs)
        .getResult();
  default:
    llvm_unreachable("expected bitwise expression");
  }
}

static Value materializeLaneBitwise(WaveAMDMachineSelector &S, Location loc,
                                    sym::ExprKind kind, Value lhs, Value rhs) {
  Type resultType =
      getRegType(S.builder.getContext(), waveamdmachine::RegClass::VGPR);
  switch (kind) {
  case sym::ExprKind::Xor:
    return waveamdmachine::VXorB32Op::create(S.builder, loc, resultType, lhs,
                                             rhs)
        .getResult();
  case sym::ExprKind::And:
    return waveamdmachine::VAndB32Op::create(S.builder, loc, resultType, lhs,
                                             rhs);
  case sym::ExprKind::Or:
    return waveamdmachine::VOrB32Op::create(S.builder, loc, resultType, lhs,
                                            rhs);
  default:
    llvm_unreachable("expected bitwise expression");
  }
}

static Value materializeBitwisePair(WaveAMDMachineSelector &S, Location loc,
                                    sym::ExprKind kind, Value lhs, Value rhs) {
  if (std::optional<Value> folded =
          foldBitwiseImmediates(S, loc, kind, lhs, rhs))
    return *folded;
  if (S.isUniformValue(lhs) && S.isUniformValue(rhs))
    return materializeUniformBitwise(S, loc, kind, lhs, rhs);
  return materializeLaneBitwise(S, loc, kind, lhs, rhs);
}

static FailureOr<Value>
materializeBitwise(WaveAMDMachineSelector &S, sym::ExprHandle expr,
                   Operation *user, const llvm::StringMap<Value> &subs,
                   ArrayRef<sym::PredHandle> assumptions,
                   IndexExprAddOrder addOrder) {
  Location loc = user->getLoc();
  sym::ExprView view(expr);
  uint32_t count = view.getAssocArgCount();
  assert(count >= 2 && "expected associative bitwise operands");
  SmallVector<Value> values;
  values.reserve(count);
  for (uint32_t i : llvm::seq<uint32_t>(0, count)) {
    FailureOr<Value> value = materializeIndexExprNode(
        S, view.getAssocArg(i), user, subs, assumptions, addOrder);
    if (failed(value))
      return failure();
    values.push_back(*value);
  }
  Value result = values.back();
  for (uint32_t i : llvm::reverse(llvm::seq<uint32_t>(0, count - 1)))
    result = materializeBitwisePair(S, loc, view.getKind(), values[i], result);
  return result;
}

static std::optional<CmpRelation> convertPredCmpOp(sym::PredCmpOp op) {
  switch (op) {
  case sym::PredCmpOp::Eq:
    return CmpRelation::Eq;
  case sym::PredCmpOp::Ne:
    return CmpRelation::Ne;
  case sym::PredCmpOp::Lt:
    return CmpRelation::Lt;
  case sym::PredCmpOp::Le:
    return CmpRelation::Le;
  case sym::PredCmpOp::Gt:
    return CmpRelation::Gt;
  case sym::PredCmpOp::Ge:
    return CmpRelation::Ge;
  }
  llvm_unreachable("handled predicate compare op");
}

static bool isSignedPredicateCmp(CmpRelation relation) {
  return relation != CmpRelation::Eq && relation != CmpRelation::Ne;
}

static unsigned getCmpValueBits(WaveAMDMachineSelector &S, Value value,
                                bool signedCmp) {
  if (auto regType = dyn_cast<waveamdmachine::RegType>(value.getType())) {
    if (regType.getWidth() <= 1)
      return 32;
    return regType.getWidth() * 32;
  }
  if (std::optional<int64_t> imm = S.getImmediateValue(value)) {
    if (signedCmp)
      return llvm::isInt<32>(*imm) ? 32 : 64;
    return llvm::isInt<32>(*imm) || llvm::isUInt<32>(*imm) ? 32 : 64;
  }
  return 64;
}

static std::optional<unsigned> getMaskWordWidth(Type type) {
  if (auto simd = dyn_cast<SimdType>(type))
    return simd.getWidth() / 32;
  if (auto mask = dyn_cast<MaskType>(type))
    return mask.getWidth() / 32;
  return std::nullopt;
}

static FailureOr<unsigned> inferUserMaskWordWidth(Operation *user) {
  for (Type type : user->getResultTypes())
    if (std::optional<unsigned> width = getMaskWordWidth(type))
      return *width;
  for (Value operand : user->getOperands())
    if (std::optional<unsigned> width = getMaskWordWidth(operand.getType()))
      return *width;
  return user->emitError("wave.index_expr piecewise needs a SIMD user");
}

static FailureOr<Value>
materializePredicateCmpMask(WaveAMDMachineSelector &S, sym::PredHandle pred,
                            Operation *user, const llvm::StringMap<Value> &subs,
                            ArrayRef<sym::PredHandle> assumptions,
                            IndexExprAddOrder addOrder, unsigned maskWords) {
  sym::PredView view(pred);
  std::optional<sym::PredCmpOp> cmp = view.getCmpOp();
  std::optional<CmpRelation> relation =
      cmp ? convertPredCmpOp(*cmp) : std::optional<CmpRelation>{};
  if (!relation)
    return user->emitError("wave.index_expr piecewise needs cmp predicate");
  bool signedCmp = isSignedPredicateCmp(*relation);

  FailureOr<Value> lhs = materializeIndexExprNode(S, view.getCmpLhs(), user,
                                                  subs, assumptions, addOrder);
  FailureOr<Value> rhs = materializeIndexExprNode(S, view.getCmpRhs(), user,
                                                  subs, assumptions, addOrder);
  if (failed(lhs) || failed(rhs))
    return failure();

  unsigned bits = std::max(getCmpValueBits(S, *lhs, signedCmp),
                           getCmpValueBits(S, *rhs, signedCmp));
  Type maskType = getRegType(S.builder.getContext(),
                             waveamdmachine::RegClass::SGPR, maskWords);
  if (bits == 64)
    return createI64Cmp(S, user->getLoc(), *relation, signedCmp, maskType, *lhs,
                        *rhs);
  if (bits == 32)
    return createWordCmp(S, user->getLoc(), *relation, signedCmp, maskType,
                         *lhs, *rhs);
  return user->emitError("wave.index_expr piecewise cmp width unsupported");
}

static FailureOr<unsigned> getMaterializedWordWidth(Operation *user,
                                                    Value value) {
  if (isImm(value))
    return 1;
  if (auto regType = dyn_cast<waveamdmachine::RegType>(value.getType()))
    return regType.getWidth();
  return user->emitError(
      "wave.index_expr piecewise branch is not materialized");
}

static LogicalResult materializePiecewiseCase(
    WaveAMDMachineSelector &S, sym::PiecewiseCase piece, Operation *user,
    const llvm::StringMap<Value> &subs, ArrayRef<sym::PredHandle> assumptions,
    IndexExprAddOrder addOrder, unsigned maskWords, Value &acc) {
  sym::PredKind predKind = sym::PredView(piece.condition).getKind();
  if (predKind == sym::PredKind::False)
    return success();

  FailureOr<Value> trueValue = materializeIndexExprNode(
      S, piece.value, user, subs, assumptions, addOrder);
  if (failed(trueValue))
    return failure();
  if (predKind == sym::PredKind::True) {
    acc = *trueValue;
    return success();
  }

  FailureOr<Value> condition = materializePredicateCmpMask(
      S, piece.condition, user, subs, assumptions, addOrder, maskWords);
  FailureOr<unsigned> trueWidth = getMaterializedWordWidth(user, *trueValue);
  FailureOr<unsigned> falseWidth = getMaterializedWordWidth(user, acc);
  if (failed(condition) || failed(trueWidth) || failed(falseWidth))
    return failure();
  FailureOr<Value> selected = createLaneSelect(
      S, user, *condition, *trueValue, acc, std::max(*trueWidth, *falseWidth));
  if (failed(selected))
    return failure();
  acc = *selected;
  return success();
}

static FailureOr<Value>
materializePiecewise(WaveAMDMachineSelector &S, sym::ExprHandle expr,
                     Operation *user, const llvm::StringMap<Value> &subs,
                     ArrayRef<sym::PredHandle> assumptions,
                     IndexExprAddOrder addOrder) {
  sym::ExprView view(expr);
  uint32_t count = view.getPiecewiseCaseCount();
  if (count == 0)
    return user->emitError("wave.index_expr piecewise has no cases");
  FailureOr<unsigned> maskWords = inferUserMaskWordWidth(user);
  if (failed(maskWords))
    return failure();

  sym::PiecewiseCase last = view.getPiecewiseCase(count - 1);
  FailureOr<Value> seed = materializeIndexExprNode(S, last.value, user, subs,
                                                   assumptions, addOrder);
  if (failed(seed))
    return failure();
  Value acc = *seed;

  for (uint32_t i = count - 1; i > 0; --i) {
    sym::PiecewiseCase piece = view.getPiecewiseCase(i - 1);
    if (failed(materializePiecewiseCase(S, piece, user, subs, assumptions,
                                        addOrder, *maskWords, acc)))
      return failure();
  }
  return acc;
}

struct RationalIndexValue {
  OpFoldResult numerator;
  OpFoldResult denominator;
  sym::ExprHandle numeratorExpr;
  sym::ExprHandle denominatorExpr;
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

static bool needsRationalMaterialization(sym::ExprHandle expr);

static bool addNeedsRationalMaterialization(sym::ExprView view) {
  if (needsRationalMaterialization(view.getAddConstant()))
    return true;
  for (uint32_t i : llvm::seq<uint32_t>(0, view.getAddTermCount())) {
    sym::AddTerm term = view.getAddTerm(i);
    if (needsRationalMaterialization(term.coefficient) ||
        needsRationalMaterialization(term.term))
      return true;
  }
  return false;
}

static bool mulNeedsRationalMaterialization(sym::ExprView view) {
  if (needsRationalMaterialization(view.getMulCoefficient()))
    return true;
  for (uint32_t i : llvm::seq<uint32_t>(0, view.getMulFactorCount()))
    if (needsRationalMaterialization(view.getMulFactor(i).base))
      return true;
  return false;
}

static bool needsRationalMaterialization(sym::ExprHandle expr) {
  sym::ExprView view(expr);
  switch (view.getKind()) {
  case sym::ExprKind::Rational: {
    std::optional<sym::RationalLiteral> rational = view.getRational();
    return rational && rational->denominator != 1;
  }
  case sym::ExprKind::Add:
    return addNeedsRationalMaterialization(view);
  case sym::ExprKind::Mul:
    return mulNeedsRationalMaterialization(view);
  case sym::ExprKind::Mod:
    return needsRationalMaterialization(view.getBinaryLhs());
  default:
    return false;
  }
}

static bool containsRationalMaterialization(sym::ExprHandle expr);

static bool addContainsRationalMaterialization(sym::ExprView view) {
  if (containsRationalMaterialization(view.getAddConstant()))
    return true;
  for (uint32_t i : llvm::seq<uint32_t>(0, view.getAddTermCount())) {
    sym::AddTerm term = view.getAddTerm(i);
    if (containsRationalMaterialization(term.coefficient) ||
        containsRationalMaterialization(term.term))
      return true;
  }
  return false;
}

static bool mulContainsRationalMaterialization(sym::ExprView view) {
  if (containsRationalMaterialization(view.getMulCoefficient()))
    return true;
  for (uint32_t i : llvm::seq<uint32_t>(0, view.getMulFactorCount()))
    if (containsRationalMaterialization(view.getMulFactor(i).base))
      return true;
  return false;
}

static bool binaryContainsRationalMaterialization(sym::ExprView view) {
  return containsRationalMaterialization(view.getBinaryLhs()) ||
         containsRationalMaterialization(view.getBinaryRhs());
}

static bool assocContainsRationalMaterialization(sym::ExprView view) {
  for (uint32_t i : llvm::seq<uint32_t>(0, view.getAssocArgCount()))
    if (containsRationalMaterialization(view.getAssocArg(i)))
      return true;
  return false;
}

static bool compoundContainsRationalMaterialization(sym::ExprView view) {
  switch (view.getKind()) {
  case sym::ExprKind::Floor:
  case sym::ExprKind::Ceil:
    return containsRationalMaterialization(view.getUnaryArg());
  case sym::ExprKind::Mod:
    return binaryContainsRationalMaterialization(view);
  case sym::ExprKind::Xor:
  case sym::ExprKind::And:
  case sym::ExprKind::Or:
    return assocContainsRationalMaterialization(view);
  default:
    return false;
  }
}

static bool containsRationalMaterialization(sym::ExprHandle expr) {
  sym::ExprView view(expr);
  switch (view.getKind()) {
  case sym::ExprKind::Rational: {
    std::optional<sym::RationalLiteral> rational = view.getRational();
    return rational && rational->denominator != 1;
  }
  case sym::ExprKind::Add:
    return addContainsRationalMaterialization(view);
  case sym::ExprKind::Mul:
    return mulContainsRationalMaterialization(view);
  default:
    return compoundContainsRationalMaterialization(view);
  }
}

static bool rationalNumeratorFitsRange(sym::Analysis &analysis,
                                       sym::ExprHandle expr, int64_t min,
                                       int64_t max) {
  if (std::optional<sym::InferredRange> range = analysis.range(expr);
      range && range->lower && range->upper &&
      sym::compareEndpointToInteger(*range->lower, min) >= 0 &&
      sym::compareEndpointToInteger(*range->upper, max) <= 0)
    return true;
  if (sym::provablyInRange(analysis, expr, min, max))
    return true;
  FailureOr<sym::ExprHandle> simplified = analysis.simplify(expr);
  return succeeded(simplified) &&
         sym::provablyInRange(analysis, *simplified, min, max);
}

static bool rationalNumeratorFitsB32(sym::Analysis &analysis,
                                     sym::ExprHandle expr) {
  constexpr int64_t min = std::numeric_limits<int32_t>::min();
  constexpr int64_t max = (int64_t{1} << 32) - 1;
  return rationalNumeratorFitsRange(analysis, expr, min, max);
}

static bool rationalNumeratorFitsI32(sym::Analysis &analysis,
                                     sym::ExprHandle expr) {
  return rationalNumeratorFitsRange(analysis, expr,
                                    std::numeric_limits<int32_t>::min(),
                                    std::numeric_limits<int32_t>::max());
}

static LogicalResult
assumeNarrowBindingRanges(WaveAMDMachineSelector &S, sym::Analysis &analysis,
                          const llvm::StringMap<Value> &bindings) {
  for (const auto &binding : bindings) {
    std::optional<sym::InferredRange> range;
    if (std::optional<int64_t> value =
            S.getImmediateValue(binding.getValue())) {
      sym::RationalEndpoint endpoint{*value, 1};
      range = sym::InferredRange{endpoint, endpoint};
    } else if (waveamdmachine::RegType type = dyn_cast<waveamdmachine::RegType>(
                   binding.getValue().getType());
               type && type.getWidth() == 1) {
      range = sym::InferredRange{
          sym::RationalEndpoint{std::numeric_limits<int32_t>::min(), 1},
          sym::RationalEndpoint{std::numeric_limits<int32_t>::max(), 1}};
    }
    if (!range)
      continue;
    FailureOr<sym::ExprHandle> symbol =
        analysis.composeSymbol(binding.getKey());
    if (failed(symbol) || failed(analysis.assumeRange(*symbol, *range)))
      return failure();
  }
  return success();
}

struct RationalNarrowingProof {
  sym::ExprHandle numerator;
  int64_t denominator = 1;
  bool fitsB32 = true;
};

static FailureOr<RationalNarrowingProof>
proveRationalNarrowing(sym::Analysis &analysis, sym::ExprHandle expr);

static FailureOr<sym::ExprHandle> composeProofInteger(sym::Analysis &analysis,
                                                      int64_t value) {
  return analysis.composeInteger(value);
}

static FailureOr<sym::ExprHandle> composeProofBinary(sym::Analysis &analysis,
                                                     sym::ExprHandle lhs,
                                                     sym::ExprBinaryOp op,
                                                     sym::ExprHandle rhs) {
  return analysis.compose(lhs, op, rhs);
}

static FailureOr<RationalNarrowingProof>
multiplyRationalProof(sym::Analysis &analysis, RationalNarrowingProof lhs,
                      RationalNarrowingProof rhs) {
  std::optional<int64_t> denominator =
      llvm::checkedMul(lhs.denominator, rhs.denominator);
  if (!denominator)
    return failure();
  FailureOr<sym::ExprHandle> numerator = composeProofBinary(
      analysis, lhs.numerator, sym::ExprBinaryOp::Mul, rhs.numerator);
  if (failed(numerator))
    return failure();
  return RationalNarrowingProof{
      *numerator, *denominator,
      lhs.fitsB32 && rhs.fitsB32 &&
          rationalNumeratorFitsB32(analysis, *numerator)};
}

static FailureOr<sym::ExprHandle> scaleProofNumerator(sym::Analysis &analysis,
                                                      sym::ExprHandle numerator,
                                                      int64_t scale) {
  if (scale == 1)
    return numerator;
  FailureOr<sym::ExprHandle> scaleExpr = composeProofInteger(analysis, scale);
  if (failed(scaleExpr))
    return failure();
  return composeProofBinary(analysis, numerator, sym::ExprBinaryOp::Mul,
                            *scaleExpr);
}

static FailureOr<RationalNarrowingProof>
addRationalProof(sym::Analysis &analysis, RationalNarrowingProof lhs,
                 RationalNarrowingProof rhs) {
  std::optional<int64_t> denominator =
      checkedLCM(lhs.denominator, rhs.denominator);
  if (!denominator)
    return failure();
  FailureOr<sym::ExprHandle> lhsNumerator = scaleProofNumerator(
      analysis, lhs.numerator, *denominator / lhs.denominator);
  FailureOr<sym::ExprHandle> rhsNumerator = scaleProofNumerator(
      analysis, rhs.numerator, *denominator / rhs.denominator);
  if (failed(lhsNumerator) || failed(rhsNumerator))
    return failure();
  FailureOr<sym::ExprHandle> numerator = composeProofBinary(
      analysis, *lhsNumerator, sym::ExprBinaryOp::Add, *rhsNumerator);
  if (failed(numerator))
    return failure();
  bool scaledFit = rationalNumeratorFitsB32(analysis, *lhsNumerator) &&
                   rationalNumeratorFitsB32(analysis, *rhsNumerator);
  return RationalNarrowingProof{
      *numerator, *denominator,
      lhs.fitsB32 && rhs.fitsB32 && scaledFit &&
          rationalNumeratorFitsB32(analysis, *numerator)};
}

static FailureOr<RationalNarrowingProof>
proveRationalAdd(sym::Analysis &analysis, sym::ExprHandle expr) {
  sym::ExprView view(expr);
  FailureOr<RationalNarrowingProof> acc =
      proveRationalNarrowing(analysis, view.getAddConstant());
  if (failed(acc))
    return failure();
  for (uint32_t i : llvm::seq<uint32_t>(0, view.getAddTermCount())) {
    sym::AddTerm term = view.getAddTerm(i);
    FailureOr<RationalNarrowingProof> coefficient =
        proveRationalNarrowing(analysis, term.coefficient);
    FailureOr<RationalNarrowingProof> value =
        proveRationalNarrowing(analysis, term.term);
    if (failed(coefficient) || failed(value))
      return failure();
    FailureOr<RationalNarrowingProof> product =
        multiplyRationalProof(analysis, *coefficient, *value);
    if (failed(product))
      return failure();
    acc = addRationalProof(analysis, *acc, *product);
    if (failed(acc))
      return failure();
  }
  return *acc;
}

static FailureOr<RationalNarrowingProof>
raiseRationalProof(sym::Analysis &analysis, RationalNarrowingProof base,
                   int32_t exponent) {
  FailureOr<sym::ExprHandle> oneExpr = composeProofInteger(analysis, 1);
  if (failed(oneExpr) || exponent <= 0)
    return failure();
  RationalNarrowingProof power{*oneExpr, 1, true};
  for ([[maybe_unused]] int32_t e : llvm::seq<int32_t>(0, exponent)) {
    FailureOr<RationalNarrowingProof> next =
        multiplyRationalProof(analysis, power, base);
    if (failed(next))
      return failure();
    power = *next;
  }
  return power;
}

static FailureOr<RationalNarrowingProof>
proveRationalMul(sym::Analysis &analysis, sym::ExprHandle expr) {
  sym::ExprView view(expr);
  FailureOr<RationalNarrowingProof> acc =
      proveRationalNarrowing(analysis, view.getMulCoefficient());
  if (failed(acc))
    return failure();
  for (uint32_t i : llvm::seq<uint32_t>(0, view.getMulFactorCount())) {
    sym::MulFactor factor = view.getMulFactor(i);
    FailureOr<RationalNarrowingProof> base =
        proveRationalNarrowing(analysis, factor.base);
    if (failed(base))
      return failure();
    FailureOr<RationalNarrowingProof> power =
        raiseRationalProof(analysis, *base, factor.exponent);
    if (failed(power))
      return failure();
    acc = multiplyRationalProof(analysis, *acc, *power);
    if (failed(acc))
      return failure();
  }
  return *acc;
}

static FailureOr<sym::ExprHandle>
composeCeilProofNumerator(sym::Analysis &analysis,
                          RationalNarrowingProof child) {
  FailureOr<sym::ExprHandle> bias =
      composeProofInteger(analysis, child.denominator - 1);
  if (failed(bias))
    return failure();
  return composeProofBinary(analysis, child.numerator, sym::ExprBinaryOp::Add,
                            *bias);
}

static FailureOr<bool> roundedProofFitsB32(sym::Analysis &analysis,
                                           RationalNarrowingProof child,
                                           sym::ExprHandle childExpr,
                                           bool isCeil) {
  bool nonNegative = isProvablyNonNegative(analysis, childExpr);
  bool fits =
      child.fitsB32 && rationalNumeratorFitsB32(analysis, child.numerator);
  if (!nonNegative)
    fits &= rationalNumeratorFitsI32(analysis, child.numerator);
  if (!isCeil || child.denominator <= 1)
    return fits;
  FailureOr<sym::ExprHandle> biased =
      composeCeilProofNumerator(analysis, child);
  if (failed(biased))
    return failure();
  fits &= rationalNumeratorFitsB32(analysis, *biased);
  if (!nonNegative)
    fits &= rationalNumeratorFitsI32(analysis, *biased);
  return fits;
}

static FailureOr<RationalNarrowingProof>
proveRationalRounded(sym::Analysis &analysis, sym::ExprHandle expr,
                     bool isCeil) {
  sym::ExprHandle childExpr = sym::ExprView(expr).getUnaryArg();
  FailureOr<RationalNarrowingProof> child =
      proveRationalNarrowing(analysis, childExpr);
  if (failed(child))
    return failure();
  FailureOr<bool> fits =
      roundedProofFitsB32(analysis, *child, childExpr, isCeil);
  if (failed(fits))
    return failure();
  return RationalNarrowingProof{
      expr, 1, *fits && rationalNumeratorFitsB32(analysis, expr)};
}

static RationalNarrowingProof proveRationalIntegerNode(sym::Analysis &analysis,
                                                       sym::ExprHandle expr) {
  return RationalNarrowingProof{expr, 1,
                                rationalNumeratorFitsB32(analysis, expr)};
}

static FailureOr<RationalNarrowingProof>
proveRationalLiteral(sym::Analysis &analysis, sym::ExprView view) {
  std::optional<sym::RationalLiteral> rational = view.getRational();
  if (!rational || rational->denominator <= 0)
    return failure();
  FailureOr<sym::ExprHandle> numerator =
      composeProofInteger(analysis, rational->numerator);
  if (failed(numerator))
    return failure();
  return RationalNarrowingProof{*numerator, rational->denominator,
                                rationalNumeratorFitsB32(analysis, *numerator)};
}

static bool canTruncateModuloDividend(sym::ExprView view) {
  std::optional<int64_t> divisor =
      sym::getIntegerLiteralValue(view.getBinaryRhs());
  return divisor && *divisor > 0 &&
         llvm::isPowerOf2_64(static_cast<uint64_t>(*divisor)) &&
         static_cast<uint64_t>(*divisor) <= (uint64_t{1} << 32);
}

static FailureOr<RationalNarrowingProof>
proveRationalBinary(sym::Analysis &analysis, sym::ExprHandle expr,
                    sym::ExprView view) {
  FailureOr<RationalNarrowingProof> lhs =
      proveRationalNarrowing(analysis, view.getBinaryLhs());
  FailureOr<RationalNarrowingProof> rhs =
      proveRationalNarrowing(analysis, view.getBinaryRhs());
  if (failed(lhs) || failed(rhs) ||
      analysis.integerValued(expr) != sym::CheckResult::True)
    return failure();
  RationalNarrowingProof result = proveRationalIntegerNode(analysis, expr);
  bool operandsFit = lhs->fitsB32 && rhs->fitsB32;
  // B32 truncation preserves remainder for power-of-two divisors up to 2^32.
  if (view.getKind() == sym::ExprKind::Mod && canTruncateModuloDividend(view))
    operandsFit = rhs->fitsB32;
  result.fitsB32 &= operandsFit;
  return result;
}

static FailureOr<RationalNarrowingProof>
proveRationalAssoc(sym::Analysis &analysis, sym::ExprHandle expr,
                   sym::ExprView view) {
  bool operandsFit = true;
  for (uint32_t i : llvm::seq<uint32_t>(0, view.getAssocArgCount())) {
    FailureOr<RationalNarrowingProof> operand =
        proveRationalNarrowing(analysis, view.getAssocArg(i));
    if (failed(operand))
      return failure();
    operandsFit &= operand->fitsB32;
  }
  if (analysis.integerValued(expr) != sym::CheckResult::True)
    return failure();
  RationalNarrowingProof result = proveRationalIntegerNode(analysis, expr);
  result.fitsB32 &= operandsFit;
  return result;
}

static FailureOr<RationalNarrowingProof>
proveRationalCompound(sym::Analysis &analysis, sym::ExprHandle expr,
                      sym::ExprView view) {
  switch (view.getKind()) {
  case sym::ExprKind::Floor:
    return proveRationalRounded(analysis, expr, /*isCeil=*/false);
  case sym::ExprKind::Ceil:
    return proveRationalRounded(analysis, expr, /*isCeil=*/true);
  case sym::ExprKind::Mod:
    return proveRationalBinary(analysis, expr, view);
  case sym::ExprKind::Xor:
  case sym::ExprKind::And:
  case sym::ExprKind::Or:
    return proveRationalAssoc(analysis, expr, view);
  default:
    return failure();
  }
}

static FailureOr<RationalNarrowingProof>
proveRationalNarrowing(sym::Analysis &analysis, sym::ExprHandle expr) {
  sym::ExprView view(expr);
  switch (view.getKind()) {
  case sym::ExprKind::Integer:
  case sym::ExprKind::Symbol:
    return proveRationalIntegerNode(analysis, expr);
  case sym::ExprKind::Rational:
    return proveRationalLiteral(analysis, view);
  case sym::ExprKind::Add:
    return proveRationalAdd(analysis, expr);
  case sym::ExprKind::Mul:
    return proveRationalMul(analysis, expr);
  default:
    return proveRationalCompound(analysis, expr, view);
  }
}

static bool rationalProofNeedsWide(sym::Analysis &analysis,
                                   sym::ExprHandle expr) {
  FailureOr<RationalNarrowingProof> proof =
      proveRationalNarrowing(analysis, expr);
  return failed(proof) || !proof->fitsB32;
}

static bool requiresWideRationalIntermediatesImpl(sym::Analysis &analysis,
                                                  sym::ExprHandle expr);

static bool addRequiresWideRationalIntermediates(sym::Analysis &analysis,
                                                 sym::ExprHandle expr) {
  if (needsRationalMaterialization(expr))
    return rationalProofNeedsWide(analysis, expr);
  sym::ExprView view(expr);
  if (requiresWideRationalIntermediatesImpl(analysis, view.getAddConstant()))
    return true;
  for (uint32_t i : llvm::seq<uint32_t>(0, view.getAddTermCount())) {
    sym::AddTerm term = view.getAddTerm(i);
    if (requiresWideRationalIntermediatesImpl(analysis, term.coefficient) ||
        requiresWideRationalIntermediatesImpl(analysis, term.term))
      return true;
  }
  return false;
}

static bool mulRequiresWideRationalIntermediates(sym::Analysis &analysis,
                                                 sym::ExprHandle expr) {
  if (needsRationalMaterialization(expr))
    return rationalProofNeedsWide(analysis, expr);
  sym::ExprView view(expr);
  if (requiresWideRationalIntermediatesImpl(analysis, view.getMulCoefficient()))
    return true;
  for (uint32_t i : llvm::seq<uint32_t>(0, view.getMulFactorCount()))
    if (requiresWideRationalIntermediatesImpl(analysis,
                                              view.getMulFactor(i).base))
      return true;
  return false;
}

static bool binaryRequiresWideRationalIntermediates(sym::Analysis &analysis,
                                                    sym::ExprView view) {
  return requiresWideRationalIntermediatesImpl(analysis, view.getBinaryLhs()) ||
         requiresWideRationalIntermediatesImpl(analysis, view.getBinaryRhs());
}

static bool assocRequiresWideRationalIntermediates(sym::Analysis &analysis,
                                                   sym::ExprView view) {
  for (uint32_t i : llvm::seq<uint32_t>(0, view.getAssocArgCount()))
    if (requiresWideRationalIntermediatesImpl(analysis, view.getAssocArg(i)))
      return true;
  return false;
}

static bool requiresWideRationalIntermediatesImpl(sym::Analysis &analysis,
                                                  sym::ExprHandle expr) {
  sym::ExprView view(expr);
  switch (view.getKind()) {
  case sym::ExprKind::Add:
    return addRequiresWideRationalIntermediates(analysis, expr);
  case sym::ExprKind::Mul:
    return mulRequiresWideRationalIntermediates(analysis, expr);
  case sym::ExprKind::Floor:
  case sym::ExprKind::Ceil:
    return rationalProofNeedsWide(analysis, expr);
  case sym::ExprKind::Mod:
    return binaryRequiresWideRationalIntermediates(analysis, view);
  case sym::ExprKind::Xor:
  case sym::ExprKind::And:
  case sym::ExprKind::Or:
    return assocRequiresWideRationalIntermediates(analysis, view);
  default:
    return false;
  }
}

static FailureOr<bool> canMaterializeIntegerRationalExpr(
    WaveAMDMachineSelector &S, sym::ExprHandle expr, Operation *user,
    const llvm::StringMap<Value> &subs, ArrayRef<sym::PredHandle> assumptions,
    std::unique_ptr<sym::Analysis> &analysis) {
  if (!needsRationalMaterialization(expr))
    return false;
  FailureOr<std::unique_ptr<sym::Analysis>> created =
      sym::Analysis::create(S.symbolStore(), assumptions);
  if (failed(created) ||
      failed(assumeNarrowBindingRanges(S, **created, subs)) ||
      (*created)->integerValued(expr) != sym::CheckResult::True)
    return false;
  if (!isProvablyNonNegative(**created, expr))
    return user->emitError(
        "wave.index_expr rational shift lowering needs nonnegative operand");
  analysis = std::move(*created);
  return true;
}

static OpFoldResult getIntFoldResult(WaveAMDMachineSelector &S, int64_t value) {
  return S.builder.getI64IntegerAttr(value);
}

static FailureOr<sym::ExprHandle>
composeRationalInteger(sym::Analysis &analysis, int64_t value,
                       Operation *user) {
  FailureOr<sym::ExprHandle> expr = analysis.composeInteger(value);
  if (failed(expr))
    return user->emitError("wave.index_expr failed to compose rational proof");
  return *expr;
}

static FailureOr<sym::ExprHandle> composeRationalBinary(sym::Analysis &analysis,
                                                        sym::ExprHandle lhs,
                                                        sym::ExprBinaryOp op,
                                                        sym::ExprHandle rhs,
                                                        Operation *user) {
  FailureOr<sym::ExprHandle> expr = analysis.compose(lhs, op, rhs);
  if (failed(expr))
    return user->emitError("wave.index_expr failed to compose rational proof");
  return *expr;
}

static LogicalResult requireNarrowRationalNumerator(WaveAMDMachineSelector &S,
                                                    sym::Analysis &analysis,
                                                    sym::ExprHandle numerator,
                                                    Operation *user) {
  if (rationalNumeratorFitsB32(analysis, numerator))
    return success();
  return user->emitError(
      "wave.index_expr rational numerator does not provably fit 32 bits");
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

static FailureOr<RationalIndexValue> getIntRational(WaveAMDMachineSelector &S,
                                                    sym::Analysis &analysis,
                                                    int64_t value,
                                                    Operation *user) {
  FailureOr<sym::ExprHandle> numerator =
      composeRationalInteger(analysis, value, user);
  FailureOr<sym::ExprHandle> denominator =
      composeRationalInteger(analysis, 1, user);
  if (failed(numerator) || failed(denominator))
    return failure();
  return RationalIndexValue{getIntFoldResult(S, value), getIntFoldResult(S, 1),
                            *numerator, *denominator};
}

static FailureOr<RationalIndexValue> materializeRationalIndexExprNode(
    WaveAMDMachineSelector &S, sym::Analysis &analysis, sym::ExprHandle expr,
    Operation *user, const llvm::StringMap<Value> &subs,
    ArrayRef<sym::PredHandle> assumptions);
static LogicalResult requireIntegerRationalOperands(WaveAMDMachineSelector &S,
                                                    RationalIndexValue lhs,
                                                    RationalIndexValue rhs,
                                                    Operation *user);
static FailureOr<BinaryValues>
materializeRationalNumerators(WaveAMDMachineSelector &S, Location loc,
                              RationalIndexValue lhs, RationalIndexValue rhs,
                              Operation *user);

static FailureOr<sym::ExprHandle>
scaleRationalNumeratorExpr(WaveAMDMachineSelector &S, sym::Analysis &analysis,
                           sym::ExprHandle numerator, int64_t scale,
                           Operation *user) {
  FailureOr<sym::ExprHandle> scaleExpr =
      composeRationalInteger(analysis, scale, user);
  if (failed(scaleExpr))
    return failure();
  FailureOr<sym::ExprHandle> scaled = composeRationalBinary(
      analysis, numerator, sym::ExprBinaryOp::Mul, *scaleExpr, user);
  if (failed(scaled) ||
      failed(requireNarrowRationalNumerator(S, analysis, *scaled, user)))
    return failure();
  return *scaled;
}

static FailureOr<sym::ExprHandle>
addRationalNumeratorExpr(WaveAMDMachineSelector &S, sym::Analysis &analysis,
                         sym::ExprHandle lhs, sym::ExprHandle rhs,
                         Operation *user) {
  FailureOr<sym::ExprHandle> sum =
      composeRationalBinary(analysis, lhs, sym::ExprBinaryOp::Add, rhs, user);
  if (failed(sum) ||
      failed(requireNarrowRationalNumerator(S, analysis, *sum, user)))
    return failure();
  return *sum;
}

static FailureOr<OpFoldResult> scaleRationalNumerator(WaveAMDMachineSelector &S,
                                                      Location loc,
                                                      RationalIndexValue value,
                                                      int64_t scale,
                                                      Operation *user) {
  return mulFoldResult(S, loc, value.numerator, getIntFoldResult(S, scale),
                       user);
}

static FailureOr<RationalIndexValue>
addStaticDenominatorRational(WaveAMDMachineSelector &S, sym::Analysis &analysis,
                             Location loc, RationalIndexValue lhs,
                             int64_t lhsDen, RationalIndexValue rhs,
                             int64_t rhsDen, Operation *user) {
  std::optional<int64_t> denominator = checkedLCM(lhsDen, rhsDen);
  if (!denominator)
    return user->emitError("wave.index_expr denominator overflows i64");
  int64_t lhsScale = *denominator / lhsDen;
  int64_t rhsScale = *denominator / rhsDen;
  FailureOr<sym::ExprHandle> lhsNumeratorExpr = scaleRationalNumeratorExpr(
      S, analysis, lhs.numeratorExpr, lhsScale, user);
  if (failed(lhsNumeratorExpr))
    return failure();
  FailureOr<sym::ExprHandle> rhsNumeratorExpr = scaleRationalNumeratorExpr(
      S, analysis, rhs.numeratorExpr, rhsScale, user);
  if (failed(rhsNumeratorExpr))
    return failure();
  FailureOr<sym::ExprHandle> numeratorExpr = addRationalNumeratorExpr(
      S, analysis, *lhsNumeratorExpr, *rhsNumeratorExpr, user);
  if (failed(numeratorExpr))
    return failure();
  FailureOr<sym::ExprHandle> denominatorExpr =
      composeRationalInteger(analysis, *denominator, user);
  if (failed(denominatorExpr))
    return failure();
  FailureOr<OpFoldResult> lhsNumerator =
      scaleRationalNumerator(S, loc, lhs, lhsScale, user);
  if (failed(lhsNumerator))
    return failure();
  FailureOr<OpFoldResult> rhsNumerator =
      scaleRationalNumerator(S, loc, rhs, rhsScale, user);
  if (failed(rhsNumerator))
    return failure();
  FailureOr<OpFoldResult> numerator =
      addFoldResult(S, loc, *lhsNumerator, *rhsNumerator, user);
  if (failed(numerator))
    return failure();
  return RationalIndexValue{*numerator, getIntFoldResult(S, *denominator),
                            *numeratorExpr, *denominatorExpr};
}

static FailureOr<RationalIndexValue>
addRational(WaveAMDMachineSelector &S, sym::Analysis &analysis, Location loc,
            RationalIndexValue lhs, RationalIndexValue rhs, Operation *user) {
  std::optional<int64_t> lhsDen = getStaticInt(S, lhs.denominator);
  std::optional<int64_t> rhsDen = getStaticInt(S, rhs.denominator);
  if (lhsDen && rhsDen)
    return addStaticDenominatorRational(S, analysis, loc, lhs, *lhsDen, rhs,
                                        *rhsDen, user);
  return user->emitError("wave.index_expr dynamic denominator is unsupported");
}

static FailureOr<RationalIndexValue>
mulRational(WaveAMDMachineSelector &S, sym::Analysis &analysis, Location loc,
            RationalIndexValue lhs, RationalIndexValue rhs, Operation *user) {
  std::optional<int64_t> lhsDen = getStaticInt(S, lhs.denominator);
  std::optional<int64_t> rhsDen = getStaticInt(S, rhs.denominator);
  if (!lhsDen || !rhsDen)
    return user->emitError(
        "wave.index_expr dynamic denominator is unsupported");
  std::optional<int64_t> denominator = llvm::checkedMul(*lhsDen, *rhsDen);
  if (!denominator)
    return user->emitError("wave.index_expr denominator overflows i64");
  FailureOr<sym::ExprHandle> numeratorExpr =
      composeRationalBinary(analysis, lhs.numeratorExpr, sym::ExprBinaryOp::Mul,
                            rhs.numeratorExpr, user);
  if (failed(numeratorExpr) ||
      failed(requireNarrowRationalNumerator(S, analysis, *numeratorExpr, user)))
    return failure();
  FailureOr<sym::ExprHandle> denominatorExpr =
      composeRationalInteger(analysis, *denominator, user);
  if (failed(denominatorExpr))
    return failure();
  FailureOr<OpFoldResult> numerator =
      mulFoldResult(S, loc, lhs.numerator, rhs.numerator, user);
  if (failed(numerator))
    return failure();
  return RationalIndexValue{*numerator, getIntFoldResult(S, *denominator),
                            *numeratorExpr, *denominatorExpr};
}

static FailureOr<RationalIndexValue>
materializeRationalAdd(WaveAMDMachineSelector &S, sym::Analysis &analysis,
                       sym::ExprHandle expr, Operation *user,
                       const llvm::StringMap<Value> &subs,
                       ArrayRef<sym::PredHandle> assumptions) {
  Location loc = user->getLoc();
  sym::ExprView view(expr);
  FailureOr<RationalIndexValue> constant = materializeRationalIndexExprNode(
      S, analysis, view.getAddConstant(), user, subs, assumptions);
  if (failed(constant))
    return failure();
  RationalIndexValue acc = *constant;
  for (uint32_t i = 0, e = view.getAddTermCount(); i != e; ++i) {
    sym::AddTerm term = view.getAddTerm(i);
    FailureOr<RationalIndexValue> coefficient =
        materializeRationalIndexExprNode(S, analysis, term.coefficient, user,
                                         subs, assumptions);
    FailureOr<RationalIndexValue> value = materializeRationalIndexExprNode(
        S, analysis, term.term, user, subs, assumptions);
    if (failed(coefficient) || failed(value))
      return failure();
    FailureOr<RationalIndexValue> product =
        mulRational(S, analysis, loc, *coefficient, *value, user);
    if (failed(product))
      return failure();
    FailureOr<RationalIndexValue> sum =
        addRational(S, analysis, loc, acc, *product, user);
    if (failed(sum))
      return failure();
    acc = *sum;
  }
  return acc;
}

static FailureOr<RationalIndexValue>
materializeRationalMul(WaveAMDMachineSelector &S, sym::Analysis &analysis,
                       sym::ExprHandle expr, Operation *user,
                       const llvm::StringMap<Value> &subs,
                       ArrayRef<sym::PredHandle> assumptions) {
  Location loc = user->getLoc();
  sym::ExprView view(expr);
  FailureOr<RationalIndexValue> coefficient = materializeRationalIndexExprNode(
      S, analysis, view.getMulCoefficient(), user, subs, assumptions);
  if (failed(coefficient))
    return failure();
  RationalIndexValue acc = *coefficient;
  for (uint32_t i = 0, e = view.getMulFactorCount(); i != e; ++i) {
    sym::MulFactor factor = view.getMulFactor(i);
    FailureOr<RationalIndexValue> base = materializeRationalIndexExprNode(
        S, analysis, factor.base, user, subs, assumptions);
    if (failed(base))
      return failure();
    uint32_t exponent =
        factor.exponent < 0
            ? static_cast<uint32_t>(-static_cast<int64_t>(factor.exponent))
            : static_cast<uint32_t>(factor.exponent);
    FailureOr<RationalIndexValue> one = getIntRational(S, analysis, 1, user);
    if (failed(one))
      return failure();
    RationalIndexValue pow = *one;
    for ([[maybe_unused]] uint32_t e : llvm::seq<uint32_t>(0, exponent)) {
      FailureOr<RationalIndexValue> next =
          mulRational(S, analysis, loc, pow, *base, user);
      if (failed(next))
        return failure();
      pow = *next;
    }
    if (factor.exponent < 0) {
      std::swap(pow.numerator, pow.denominator);
      std::swap(pow.numeratorExpr, pow.denominatorExpr);
    }
    FailureOr<RationalIndexValue> product =
        mulRational(S, analysis, loc, acc, pow, user);
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

static bool isProvablyNonNegative(sym::Analysis &analysis,
                                  sym::ExprHandle expr) {
  std::optional<sym::InferredRange> range = analysis.range(expr);
  if (range && hasNonNegativeLowerBound(*range))
    return true;
  FailureOr<sym::ExprHandle> zero = analysis.composeInteger(0);
  if (failed(zero))
    return false;
  FailureOr<sym::PredHandle> nonNegative =
      analysis.compare(expr, sym::PredCmpOp::Ge, *zero);
  return succeeded(nonNegative) &&
         analysis.check(*nonNegative) == sym::CheckResult::True;
}

static bool isProvablyNonNegative(WaveAMDMachineSelector &S,
                                  sym::ExprHandle expr,
                                  ArrayRef<sym::PredHandle> assumptions) {
  FailureOr<std::unique_ptr<sym::Analysis>> analysis =
      sym::Analysis::create(S.symbolStore(), assumptions);
  return succeeded(analysis) && isProvablyNonNegative(**analysis, expr);
}

static LogicalResult requireNonNegativeRoundedExpr(sym::Analysis &analysis,
                                                   sym::ExprHandle sourceExpr,
                                                   Operation *user,
                                                   StringRef opName) {
  if (isProvablyNonNegative(analysis, sourceExpr))
    return success();
  return user->emitError("wave.index_expr ")
         << opName << " shift lowering needs nonnegative operand";
}

static Value materializeSignedShrPow2(WaveAMDMachineSelector &S, Location loc,
                                      Value value, unsigned shift) {
  if (shift == 0)
    return value;
  Value shiftValue = createImm(S.builder, loc, shift);
  if (std::optional<int64_t> immediate = S.getImmediateValue(value)) {
    llvm::APInt bits(32, static_cast<uint64_t>(*immediate));
    return createImm(S.builder, loc, bits.ashr(shift).getSExtValue());
  }
  if (S.isUniformValue(value))
    return waveamdmachine::SAshrI32Op::create(
               S.builder, loc,
               getRegType(S.builder.getContext(),
                          waveamdmachine::RegClass::SGPR),
               getSCCType(S.builder.getContext()), value, shiftValue)
        .getResult();
  return waveamdmachine::VAshrrevI32Op::create(
      S.builder, loc,
      getRegType(S.builder.getContext(), waveamdmachine::RegClass::VGPR),
      S.ensureVGPRForVSrc1(loc, value), shiftValue);
}

static FailureOr<Value> materializeFloorRational(WaveAMDMachineSelector &S,
                                                 sym::Analysis &analysis,
                                                 RationalIndexValue value,
                                                 sym::ExprHandle sourceExpr,
                                                 Operation *user) {
  std::optional<int64_t> staticDen = getStaticInt(S, value.denominator);
  if (!staticDen)
    return user->emitError("wave.index_expr floor needs a static denominator");
  int64_t den = *staticDen;
  if (den == 1)
    return materializeValue(S, user->getLoc(), value.numerator, user);
  if (den <= 0 || (den & (den - 1)) != 0)
    return user->emitError(
               "wave.index_expr floor needs a power-of-two denominator (got ")
           << den << ")";
  if (failed(requireNarrowRationalNumerator(S, analysis, value.numeratorExpr,
                                            user)))
    return failure();
  if (den > std::numeric_limits<uint32_t>::max())
    return createImm(S.builder, user->getLoc(), 0);
  FailureOr<Value> numerator =
      materializeValue(S, user->getLoc(), value.numerator, user);
  if (failed(numerator))
    return failure();
  unsigned shift = llvm::Log2_64(den);
  if (isProvablyNonNegative(analysis, sourceExpr))
    return S.shrPow2(user->getLoc(), *numerator, shift);
  if (!rationalNumeratorFitsI32(analysis, value.numeratorExpr)) {
    (void)requireNonNegativeRoundedExpr(analysis, sourceExpr, user, "floor");
    return failure();
  }
  return materializeSignedShrPow2(S, user->getLoc(), *numerator, shift);
}

static FailureOr<Value> materializeWideCeilRational(WaveAMDMachineSelector &S,
                                                    sym::Analysis &analysis,
                                                    RationalIndexValue value,
                                                    Operation *user) {
  FailureOr<sym::ExprHandle> zero = composeRationalInteger(analysis, 0, user);
  if (failed(zero))
    return failure();
  FailureOr<sym::PredHandle> isZero =
      analysis.compare(value.numeratorExpr, sym::PredCmpOp::Eq, *zero);
  if (succeeded(isZero) && analysis.check(*isZero) == sym::CheckResult::True)
    return createImm(S.builder, user->getLoc(), 0);
  return user->emitError(
      "wave.index_expr ceil denominator exceeds narrow numerator width");
}

static FailureOr<Value> materializeBiasedCeilRational(WaveAMDMachineSelector &S,
                                                      sym::Analysis &analysis,
                                                      RationalIndexValue value,
                                                      int64_t denominator,
                                                      Operation *user) {
  FailureOr<Value> numerator =
      materializeValue(S, user->getLoc(), value.numerator, user);
  if (failed(numerator))
    return failure();
  FailureOr<sym::ExprHandle> biasExpr =
      composeRationalInteger(analysis, denominator - 1, user);
  if (failed(biasExpr))
    return failure();
  FailureOr<sym::ExprHandle> biasedExpr = composeRationalBinary(
      analysis, value.numeratorExpr, sym::ExprBinaryOp::Add, *biasExpr, user);
  if (failed(biasedExpr) ||
      failed(requireNarrowRationalNumerator(S, analysis, *biasedExpr, user)))
    return failure();
  Value bias = createImm(S.builder, user->getLoc(), denominator - 1);
  Value biased = S.isUniformValue(*numerator)
                     ? S.addUniformBytes(user->getLoc(), *numerator, bias)
                     : S.addByteOffsets(user->getLoc(), *numerator, bias);
  return S.shrPow2(user->getLoc(), biased, llvm::Log2_64(denominator));
}

static FailureOr<Value>
materializeSignedCeilRational(WaveAMDMachineSelector &S,
                              sym::Analysis &analysis, RationalIndexValue value,
                              sym::ExprHandle sourceExpr, int64_t denominator,
                              Operation *user) {
  FailureOr<Value> numerator =
      materializeValue(S, user->getLoc(), value.numerator, user);
  FailureOr<sym::ExprHandle> biasExpr =
      composeRationalInteger(analysis, denominator - 1, user);
  if (failed(numerator) || failed(biasExpr))
    return failure();
  FailureOr<sym::ExprHandle> biasedExpr = composeRationalBinary(
      analysis, value.numeratorExpr, sym::ExprBinaryOp::Add, *biasExpr, user);
  if (failed(biasedExpr))
    return failure();
  if (!rationalNumeratorFitsI32(analysis, *biasedExpr)) {
    (void)requireNonNegativeRoundedExpr(analysis, sourceExpr, user, "ceil");
    return failure();
  }
  Value bias = createImm(S.builder, user->getLoc(), denominator - 1);
  Value biased = S.isUniformValue(*numerator)
                     ? S.addUniformBytes(user->getLoc(), *numerator, bias)
                     : S.addByteOffsets(user->getLoc(), *numerator, bias);
  return materializeSignedShrPow2(S, user->getLoc(), biased,
                                  llvm::Log2_64(denominator));
}

static FailureOr<Value> materializeCeilRational(WaveAMDMachineSelector &S,
                                                sym::Analysis &analysis,
                                                RationalIndexValue value,
                                                sym::ExprHandle sourceExpr,
                                                Operation *user) {
  std::optional<int64_t> staticDen = getStaticInt(S, value.denominator);
  if (!staticDen)
    return user->emitError("wave.index_expr ceil needs a static denominator");
  int64_t den = *staticDen;
  if (den == 1)
    return materializeValue(S, user->getLoc(), value.numerator, user);
  if (den <= 0 || (den & (den - 1)) != 0)
    return user->emitError(
               "wave.index_expr ceil needs a power-of-two denominator (got ")
           << den << ")";
  if (failed(requireNarrowRationalNumerator(S, analysis, value.numeratorExpr,
                                            user)))
    return failure();
  if (den > std::numeric_limits<uint32_t>::max())
    return materializeWideCeilRational(S, analysis, value, user);
  if (isProvablyNonNegative(analysis, sourceExpr))
    return materializeBiasedCeilRational(S, analysis, value, den, user);
  return materializeSignedCeilRational(S, analysis, value, sourceExpr, den,
                                       user);
}

static FailureOr<Value> materializeIntegerRationalExpr(
    WaveAMDMachineSelector &S, sym::Analysis &analysis, sym::ExprHandle expr,
    Operation *user, const llvm::StringMap<Value> &subs,
    ArrayRef<sym::PredHandle> assumptions) {
  FailureOr<RationalIndexValue> value = materializeRationalIndexExprNode(
      S, analysis, expr, user, subs, assumptions);
  if (failed(value))
    return failure();
  std::optional<int64_t> staticDen = getStaticInt(S, value->denominator);
  if (!staticDen)
    return user->emitError("wave.index_expr needs a static denominator");
  int64_t den = *staticDen;
  if (den == 1)
    return materializeValue(S, user->getLoc(), value->numerator, user);
  if (!isPositivePowerOfTwo(den))
    return user->emitError(
               "wave.index_expr integer rational denominator must be a power "
               "of two (got ")
           << den << ")";
  if (failed(requireNarrowRationalNumerator(S, analysis, value->numeratorExpr,
                                            user)))
    return failure();
  if (den > std::numeric_limits<uint32_t>::max())
    return createImm(S.builder, user->getLoc(), 0);
  FailureOr<Value> numerator =
      materializeValue(S, user->getLoc(), value->numerator, user);
  if (failed(numerator))
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
  if (!divisor || *divisor <= 0)
    return user->emitError(
               "wave.index_expr mod needs a positive static integer divisor "
               "(lhs denominator ")
           << *lhsDen << ", rhs numerator " << *rhsNum << ")";
  return *divisor;
}

static bool preservesLowBitsThroughB32(sym::ExprHandle expr,
                                       const llvm::StringMap<Value> &subs);

static bool
symbolPreservesLowBitsThroughB32(sym::ExprView view,
                                 const llvm::StringMap<Value> &subs) {
  auto it = subs.find(view.getSymbolName());
  if (it == subs.end())
    return false;
  if (isImm(it->second))
    return true;
  auto type = dyn_cast<waveamdmachine::RegType>(it->second.getType());
  return type && type.getWidth() == 1;
}

static bool addPreservesLowBitsThroughB32(sym::ExprView view,
                                          const llvm::StringMap<Value> &subs) {
  if (!staticIntLiteral(view.getAddConstant()))
    return false;
  for (uint32_t i : llvm::seq<uint32_t>(0, view.getAddTermCount())) {
    sym::AddTerm term = view.getAddTerm(i);
    if (!staticIntLiteral(term.coefficient) ||
        !preservesLowBitsThroughB32(term.term, subs))
      return false;
  }
  return true;
}

static bool mulPreservesLowBitsThroughB32(sym::ExprView view,
                                          const llvm::StringMap<Value> &subs) {
  if (!staticIntLiteral(view.getMulCoefficient()))
    return false;
  for (uint32_t i : llvm::seq<uint32_t>(0, view.getMulFactorCount())) {
    sym::MulFactor factor = view.getMulFactor(i);
    if (factor.exponent <= 0 || !preservesLowBitsThroughB32(factor.base, subs))
      return false;
  }
  return true;
}

static bool modPreservesLowBitsThroughB32(sym::ExprView view,
                                          const llvm::StringMap<Value> &subs) {
  std::optional<int64_t> divisor = staticIntLiteral(view.getBinaryRhs());
  return divisor && isPositivePowerOfTwo(*divisor) &&
         llvm::isUInt<32>(*divisor - 1) &&
         preservesLowBitsThroughB32(view.getBinaryLhs(), subs);
}

static bool
assocPreservesLowBitsThroughB32(sym::ExprView view,
                                const llvm::StringMap<Value> &subs) {
  for (uint32_t i : llvm::seq<uint32_t>(0, view.getAssocArgCount()))
    if (!preservesLowBitsThroughB32(view.getAssocArg(i), subs))
      return false;
  return true;
}

static bool preservesLowBitsThroughB32(sym::ExprHandle expr,
                                       const llvm::StringMap<Value> &subs) {
  sym::ExprView view(expr);
  switch (view.getKind()) {
  case sym::ExprKind::Integer:
    return true;
  case sym::ExprKind::Symbol:
    return symbolPreservesLowBitsThroughB32(view, subs);
  case sym::ExprKind::Add:
    return addPreservesLowBitsThroughB32(view, subs);
  case sym::ExprKind::Mul:
    return mulPreservesLowBitsThroughB32(view, subs);
  case sym::ExprKind::Mod:
    return modPreservesLowBitsThroughB32(view, subs);
  case sym::ExprKind::Xor:
  case sym::ExprKind::And:
  case sym::ExprKind::Or:
    return assocPreservesLowBitsThroughB32(view, subs);
  default:
    return false;
  }
}

static std::optional<int64_t>
getWrappingModDivisor(sym::ExprView view, const llvm::StringMap<Value> &subs) {
  std::optional<int64_t> divisor = staticIntLiteral(view.getBinaryRhs());
  if (!divisor || !isPositivePowerOfTwo(*divisor))
    return std::nullopt;
  if (!llvm::isUInt<32>(*divisor - 1) ||
      !preservesLowBitsThroughB32(view.getBinaryLhs(), subs))
    return std::nullopt;
  return divisor;
}

static FailureOr<RationalIndexValue> materializeWrappingRationalMod(
    WaveAMDMachineSelector &S, sym::Analysis &analysis, sym::ExprHandle expr,
    sym::ExprView view, int64_t divisor, Operation *user,
    const llvm::StringMap<Value> &subs, ArrayRef<sym::PredHandle> assumptions) {
  if (failed(requireNarrowRationalNumerator(S, analysis, expr, user)))
    return failure();
  FailureOr<Value> lhs =
      materializeIndexExprNode(S, view.getBinaryLhs(), user, subs, assumptions);
  if (failed(lhs))
    return failure();
  FailureOr<Value> numerator = materializeStaticMod(S, user, *lhs, divisor);
  FailureOr<sym::ExprHandle> one = composeRationalInteger(analysis, 1, user);
  if (failed(numerator) || failed(one))
    return failure();
  return RationalIndexValue{*numerator, getIntFoldResult(S, 1), expr, *one};
}

static FailureOr<RationalIndexValue>
materializeRationalModNumerator(WaveAMDMachineSelector &S,
                                sym::Analysis &analysis, RationalIndexValue lhs,
                                int64_t divisor, Operation *user) {
  if (failed(
          requireNarrowRationalNumerator(S, analysis, lhs.numeratorExpr, user)))
    return failure();
  FailureOr<Value> lhsNumerator =
      materializeValue(S, user->getLoc(), lhs.numerator, user);
  if (failed(lhsNumerator))
    return failure();
  FailureOr<Value> numerator =
      materializeStaticMod(S, user, *lhsNumerator, divisor);
  if (failed(numerator))
    return failure();
  FailureOr<sym::ExprHandle> divisorExpr =
      composeRationalInteger(analysis, divisor, user);
  if (failed(divisorExpr))
    return failure();
  FailureOr<sym::ExprHandle> numeratorExpr = composeRationalBinary(
      analysis, lhs.numeratorExpr, sym::ExprBinaryOp::Mod, *divisorExpr, user);
  if (failed(numeratorExpr))
    return failure();
  return RationalIndexValue{*numerator, lhs.denominator, *numeratorExpr,
                            lhs.denominatorExpr};
}

static FailureOr<RationalIndexValue>
materializeScaledRationalMod(WaveAMDMachineSelector &S, sym::Analysis &analysis,
                             sym::ExprView view, Operation *user,
                             const llvm::StringMap<Value> &subs,
                             ArrayRef<sym::PredHandle> assumptions) {
  FailureOr<RationalIndexValue> lhs = materializeRationalIndexExprNode(
      S, analysis, view.getBinaryLhs(), user, subs, assumptions);
  if (failed(lhs))
    return failure();
  FailureOr<RationalIndexValue> rhs = materializeRationalIndexExprNode(
      S, analysis, view.getBinaryRhs(), user, subs, assumptions);
  if (failed(rhs))
    return failure();
  FailureOr<int64_t> divisor = getStaticModDivisor(S, *lhs, *rhs, user);
  if (failed(divisor))
    return failure();
  if (!isPositivePowerOfTwo(*divisor) &&
      !isProvablyNonNegative(analysis, view.getBinaryLhs()))
    return user->emitError(
        "wave.index_expr non-power-of-two mod needs nonnegative dividend");
  return materializeRationalModNumerator(S, analysis, *lhs, *divisor, user);
}

static FailureOr<RationalIndexValue>
materializeRationalMod(WaveAMDMachineSelector &S, sym::Analysis &analysis,
                       sym::ExprHandle expr, Operation *user,
                       const llvm::StringMap<Value> &subs,
                       ArrayRef<sym::PredHandle> assumptions) {
  sym::ExprView view(expr);
  if (std::optional<int64_t> divisor = getWrappingModDivisor(view, subs))
    return materializeWrappingRationalMod(S, analysis, expr, view, *divisor,
                                          user, subs, assumptions);
  return materializeScaledRationalMod(S, analysis, view, user, subs,
                                      assumptions);
}

static FailureOr<RationalIndexValue>
combineRationalBitwise(WaveAMDMachineSelector &S, sym::Analysis &analysis,
                       sym::ExprKind kind, RationalIndexValue lhs,
                       RationalIndexValue rhs, Operation *user) {
  if (failed(requireIntegerRationalOperands(S, lhs, rhs, user)))
    return failure();
  if (failed(
          requireNarrowRationalNumerator(S, analysis, lhs.numeratorExpr, user)))
    return failure();
  if (failed(
          requireNarrowRationalNumerator(S, analysis, rhs.numeratorExpr, user)))
    return failure();
  FailureOr<BinaryValues> numerators =
      materializeRationalNumerators(S, user->getLoc(), lhs, rhs, user);
  FailureOr<sym::ExprHandle> numeratorExpr =
      composeRationalBinary(analysis, lhs.numeratorExpr,
                            getBitwiseBinaryOp(kind), rhs.numeratorExpr, user);
  FailureOr<sym::ExprHandle> denominator =
      composeRationalInteger(analysis, 1, user);
  if (failed(numerators) || failed(numeratorExpr) || failed(denominator))
    return failure();
  Value numerator = materializeBitwisePair(S, user->getLoc(), kind,
                                           numerators->lhs, numerators->rhs);
  return RationalIndexValue{numerator, getIntFoldResult(S, 1), *numeratorExpr,
                            *denominator};
}

static FailureOr<RationalIndexValue>
materializeRationalBitwise(WaveAMDMachineSelector &S, sym::Analysis &analysis,
                           sym::ExprHandle expr, Operation *user,
                           const llvm::StringMap<Value> &subs,
                           ArrayRef<sym::PredHandle> assumptions) {
  sym::ExprView view(expr);
  uint32_t count = view.getAssocArgCount();
  assert(count >= 2 && "expected associative bitwise operands");
  SmallVector<RationalIndexValue> values;
  values.reserve(count);
  for (uint32_t i : llvm::seq<uint32_t>(0, count)) {
    FailureOr<RationalIndexValue> value = materializeRationalIndexExprNode(
        S, analysis, view.getAssocArg(i), user, subs, assumptions);
    if (failed(value))
      return failure();
    values.push_back(*value);
  }
  RationalIndexValue result = values.back();
  for (uint32_t i : llvm::reverse(llvm::seq<uint32_t>(0, count - 1))) {
    FailureOr<RationalIndexValue> combined = combineRationalBitwise(
        S, analysis, view.getKind(), values[i], result, user);
    if (failed(combined))
      return failure();
    result = *combined;
  }
  return result;
}

static LogicalResult requireIntegerRationalOperands(WaveAMDMachineSelector &S,
                                                    RationalIndexValue lhs,
                                                    RationalIndexValue rhs,
                                                    Operation *user) {
  std::optional<int64_t> lhsDen = getStaticInt(S, lhs.denominator);
  std::optional<int64_t> rhsDen = getStaticInt(S, rhs.denominator);
  if (!lhsDen || !rhsDen || *lhsDen != 1 || *rhsDen != 1)
    return user->emitError(
        "wave.index_expr bitwise operation needs integer operands");
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
materializeRationalLiteral(WaveAMDMachineSelector &S, sym::Analysis &analysis,
                           std::optional<sym::RationalLiteral> value,
                           Operation *user) {
  if (!value || value->denominator <= 0)
    return user->emitError("wave.index_expr has invalid rational literal");
  FailureOr<sym::ExprHandle> numerator =
      composeRationalInteger(analysis, value->numerator, user);
  FailureOr<sym::ExprHandle> denominator =
      composeRationalInteger(analysis, value->denominator, user);
  if (failed(numerator) || failed(denominator))
    return failure();
  return RationalIndexValue{getIntFoldResult(S, value->numerator),
                            getIntFoldResult(S, value->denominator), *numerator,
                            *denominator};
}

static FailureOr<RationalIndexValue>
materializeRationalSymbol(WaveAMDMachineSelector &S, sym::Analysis &analysis,
                          sym::ExprHandle expr, Operation *user,
                          const llvm::StringMap<Value> &subs) {
  FailureOr<Value> value = materializeSymbol(S, expr, user, subs);
  if (failed(value))
    return failure();
  FailureOr<sym::ExprHandle> denominator =
      composeRationalInteger(analysis, 1, user);
  if (failed(denominator))
    return failure();
  return RationalIndexValue{*value, getIntFoldResult(S, 1), expr, *denominator};
}

static FailureOr<RationalIndexValue> materializeRationalPrimitiveIndexExprNode(
    WaveAMDMachineSelector &S, sym::Analysis &analysis, sym::ExprHandle expr,
    Operation *user, const llvm::StringMap<Value> &subs) {
  sym::ExprView view(expr);
  switch (view.getKind()) {
  case sym::ExprKind::Integer:
    if (std::optional<int64_t> value = view.getInt())
      return getIntRational(S, analysis, *value, user);
    break;
  case sym::ExprKind::Rational:
    return materializeRationalLiteral(S, analysis, view.getRational(), user);
  case sym::ExprKind::Symbol:
    return materializeRationalSymbol(S, analysis, expr, user, subs);
  default:
    break;
  }
  return user->emitError(
             "wave.index_expr selection does not support expression kind ")
         << static_cast<int>(view.getKind());
}

static FailureOr<RationalIndexValue> materializeRationalRoundedIndexExprNode(
    WaveAMDMachineSelector &S, sym::Analysis &analysis, sym::ExprHandle expr,
    Operation *user, const llvm::StringMap<Value> &subs,
    ArrayRef<sym::PredHandle> assumptions, bool isCeil) {
  sym::ExprHandle childExpr = sym::ExprView(expr).getUnaryArg();
  FailureOr<RationalIndexValue> child = materializeRationalIndexExprNode(
      S, analysis, childExpr, user, subs, assumptions);
  if (failed(child))
    return failure();
  FailureOr<Value> value =
      isCeil ? materializeCeilRational(S, analysis, *child, childExpr, user)
             : materializeFloorRational(S, analysis, *child, childExpr, user);
  if (failed(value))
    return failure();
  FailureOr<sym::ExprHandle> denominator =
      composeRationalInteger(analysis, 1, user);
  if (failed(denominator))
    return failure();
  return RationalIndexValue{*value, getIntFoldResult(S, 1), expr, *denominator};
}

static FailureOr<RationalIndexValue> materializeRationalCompoundIndexExprNode(
    WaveAMDMachineSelector &S, sym::Analysis &analysis, sym::ExprHandle expr,
    Operation *user, const llvm::StringMap<Value> &subs,
    ArrayRef<sym::PredHandle> assumptions) {
  sym::ExprView view(expr);
  switch (view.getKind()) {
  case sym::ExprKind::Add:
    return materializeRationalAdd(S, analysis, expr, user, subs, assumptions);
  case sym::ExprKind::Mul:
    return materializeRationalMul(S, analysis, expr, user, subs, assumptions);
  case sym::ExprKind::Floor:
    return materializeRationalRoundedIndexExprNode(S, analysis, expr, user,
                                                   subs, assumptions,
                                                   /*isCeil=*/false);
  case sym::ExprKind::Ceil:
    return materializeRationalRoundedIndexExprNode(S, analysis, expr, user,
                                                   subs, assumptions,
                                                   /*isCeil=*/true);
  case sym::ExprKind::Mod:
    return materializeRationalMod(S, analysis, expr, user, subs, assumptions);
  case sym::ExprKind::Xor:
  case sym::ExprKind::And:
  case sym::ExprKind::Or:
    return materializeRationalBitwise(S, analysis, expr, user, subs,
                                      assumptions);
  default:
    break;
  }
  return user->emitError(
             "wave.index_expr selection does not support expression kind ")
         << static_cast<int>(view.getKind());
}

static FailureOr<RationalIndexValue> materializeRationalIndexExprNode(
    WaveAMDMachineSelector &S, sym::Analysis &analysis, sym::ExprHandle expr,
    Operation *user, const llvm::StringMap<Value> &subs,
    ArrayRef<sym::PredHandle> assumptions) {
  sym::ExprKind kind = sym::ExprView(expr).getKind();
  if (kind == sym::ExprKind::Integer || kind == sym::ExprKind::Rational ||
      kind == sym::ExprKind::Symbol)
    return materializeRationalPrimitiveIndexExprNode(S, analysis, expr, user,
                                                     subs);
  return materializeRationalCompoundIndexExprNode(S, analysis, expr, user, subs,
                                                  assumptions);
}

static FailureOr<Value> materializeFloor(WaveAMDMachineSelector &S,
                                         sym::ExprHandle expr, Operation *user,
                                         const llvm::StringMap<Value> &subs,
                                         ArrayRef<sym::PredHandle> assumptions,
                                         IndexExprAddOrder addOrder) {
  FailureOr<std::unique_ptr<sym::Analysis>> analysis =
      sym::Analysis::create(S.symbolStore(), assumptions);
  if (failed(analysis) ||
      failed(assumeNarrowBindingRanges(S, **analysis, subs)))
    return failure();
  sym::ExprHandle childExpr = sym::ExprView(expr).getUnaryArg();
  FailureOr<RationalIndexValue> value = materializeRationalIndexExprNode(
      S, **analysis, childExpr, user, subs, assumptions);
  if (failed(value))
    return failure();
  return materializeFloorRational(S, **analysis, *value, childExpr, user);
}

static FailureOr<Value> materializeCeil(WaveAMDMachineSelector &S,
                                        sym::ExprHandle expr, Operation *user,
                                        const llvm::StringMap<Value> &subs,
                                        ArrayRef<sym::PredHandle> assumptions,
                                        IndexExprAddOrder addOrder) {
  FailureOr<std::unique_ptr<sym::Analysis>> analysis =
      sym::Analysis::create(S.symbolStore(), assumptions);
  if (failed(analysis) ||
      failed(assumeNarrowBindingRanges(S, **analysis, subs)))
    return failure();
  sym::ExprHandle childExpr = sym::ExprView(expr).getUnaryArg();
  FailureOr<RationalIndexValue> value = materializeRationalIndexExprNode(
      S, **analysis, childExpr, user, subs, assumptions);
  if (failed(value))
    return failure();
  return materializeCeilRational(S, **analysis, *value, childExpr, user);
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
assocExprReferencesWideScalarInteger(sym::ExprView view,
                                     const llvm::StringMap<bool> &wideSymbols) {
  for (uint32_t i : llvm::seq<uint32_t>(0, view.getAssocArgCount()))
    if (exprReferencesWideScalarInteger(view.getAssocArg(i), wideSymbols))
      return true;
  return false;
}

static bool compoundExprReferencesWideScalarInteger(
    sym::ExprView view, const llvm::StringMap<bool> &wideSymbols) {
  switch (view.getKind()) {
  case sym::ExprKind::Floor:
  case sym::ExprKind::Ceil:
    return exprReferencesWideScalarInteger(view.getUnaryArg(), wideSymbols);
  case sym::ExprKind::Mod:
    return exprReferencesWideScalarInteger(view.getBinaryLhs(), wideSymbols) ||
           exprReferencesWideScalarInteger(view.getBinaryRhs(), wideSymbols);
  case sym::ExprKind::Xor:
  case sym::ExprKind::And:
  case sym::ExprKind::Or:
    return assocExprReferencesWideScalarInteger(view, wideSymbols);
  default:
    return false;
  }
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
  default:
    return compoundExprReferencesWideScalarInteger(view, wideSymbols);
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

static FailureOr<sym::ExprHandle> scalePlanAddend(sym::Analysis &analysis,
                                                  sym::ExprHandle term,
                                                  sym::ExprHandle termCoeff) {
  sym::ExprHandle scaled = term;
  if (termCoeff && !isOneExpr(termCoeff)) {
    FailureOr<sym::ExprHandle> product =
        analysis.compose(termCoeff, sym::ExprBinaryOp::Mul, term);
    if (failed(product))
      return failure();
    scaled = *product;
  }
  FailureOr<sym::ExprHandle> simplified = analysis.simplify(scaled);
  return succeeded(simplified) &&
                 shouldUseSimplifiedIndexExpr(*simplified, scaled)
             ? *simplified
             : scaled;
}

static LogicalResult appendPlanExpr(sym::Analysis &analysis,
                                    sym::ExprHandle add, sym::ExprHandle &acc) {
  if (isZeroExpr(add))
    return success();
  if (!acc) {
    acc = add;
    return success();
  }
  FailureOr<sym::ExprHandle> joined =
      analysis.compose(acc, sym::ExprBinaryOp::Add, add);
  if (failed(joined))
    return failure();
  acc = *joined;
  return success();
}

static void appendPlanAddend(WaveAMDMachineSelector &S, sym::ExprHandle expr,
                             const llvm::StringMap<TermKind> &symKinds,
                             SmallVectorImpl<AddressPlanAddend> &addends) {
  if (!isZeroExpr(expr))
    addends.push_back({expr, classifyTerm(S, expr, symKinds)});
}

static FailureOr<bool>
collectShallowMulAddends(WaveAMDMachineSelector &S, sym::ExprHandle expr,
                         sym::Analysis &analysis,
                         const llvm::StringMap<TermKind> &symKinds,
                         SmallVectorImpl<AddressPlanAddend> &addends) {
  sym::ExprView mul(expr);
  if (mul.getKind() != sym::ExprKind::Mul || mul.getMulFactorCount() != 1)
    return false;
  sym::MulFactor factor = mul.getMulFactor(0);
  sym::ExprView add(factor.base);
  if (factor.exponent != 1 || add.getKind() != sym::ExprKind::Add)
    return false;

  sym::ExprHandle outer = mul.getMulCoefficient();
  if (!sym::getIntegerLiteralValue(outer))
    return false;
  FailureOr<sym::ExprHandle> constant =
      scalePlanAddend(analysis, add.getAddConstant(), outer);
  if (failed(constant))
    return failure();
  appendPlanAddend(S, *constant, symKinds, addends);
  for (uint32_t i = 0, e = add.getAddTermCount(); i != e; ++i) {
    sym::AddTerm term = add.getAddTerm(i);
    FailureOr<sym::ExprHandle> coefficient =
        scalePlanAddend(analysis, term.coefficient, outer);
    if (failed(coefficient))
      return failure();
    FailureOr<sym::ExprHandle> scaled =
        scalePlanAddend(analysis, term.term, *coefficient);
    if (failed(scaled))
      return failure();
    appendPlanAddend(S, *scaled, symKinds, addends);
  }
  return true;
}

static LogicalResult
collectPlanAddend(WaveAMDMachineSelector &S, sym::ExprHandle term,
                  sym::Analysis &analysis, sym::ExprHandle termCoeff,
                  const llvm::StringMap<TermKind> &symKinds,
                  SmallVectorImpl<AddressPlanAddend> &addends) {
  FailureOr<sym::ExprHandle> scaled =
      scalePlanAddend(analysis, term, termCoeff);
  if (failed(scaled))
    return failure();
  FailureOr<bool> shallow =
      collectShallowMulAddends(S, *scaled, analysis, symKinds, addends);
  if (failed(shallow))
    return failure();
  if (!*shallow)
    appendPlanAddend(S, *scaled, symKinds, addends);
  return success();
}

static LogicalResult
collectPlanAddends(WaveAMDMachineSelector &S, sym::ExprHandle expr,
                   sym::Analysis &analysis,
                   const llvm::StringMap<TermKind> &symKinds,
                   SmallVectorImpl<AddressPlanAddend> &addends) {
  sym::ExprView view(expr);
  if (view.getKind() != sym::ExprKind::Add)
    return collectPlanAddend(S, expr, analysis, /*termCoeff=*/{}, symKinds,
                             addends);
  appendPlanAddend(S, view.getAddConstant(), symKinds, addends);
  uint32_t nterms = view.getAddTermCount();
  for (uint32_t i = 0; i < nterms; ++i) {
    sym::AddTerm term = view.getAddTerm(i);
    if (failed(collectPlanAddend(S, term.term, analysis, term.coefficient,
                                 symKinds, addends)))
      return failure();
  }
  return success();
}

static LogicalResult appendPlanRemainder(sym::Analysis &analysis,
                                         sym::ExprHandle expr,
                                         AddressPlan &plan) {
  return appendPlanExpr(analysis, expr, plan.fullAddressRemainderExpr);
}

static LogicalResult appendPlanIntRemainder(sym::Analysis &analysis,
                                            int64_t value, AddressPlan &plan) {
  FailureOr<sym::ExprHandle> remainder = analysis.composeInteger(value);
  if (failed(remainder))
    return failure();
  return appendPlanRemainder(analysis, *remainder, plan);
}

static FailureOr<bool>
takeInstOffsetConstAddend(sym::Analysis &analysis,
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
  if (failed(appendPlanIntRemainder(analysis, split->second, plan)))
    return failure();
  return true;
}

static LogicalResult
takeInstOffsetAddends(sym::Analysis &analysis,
                      const waveamdmachine::AddressFieldSpec &spec,
                      ArrayRef<AddressPlanAddend> addends, AddressPlan &plan) {
  for (const AddressPlanAddend &addend : addends) {
    if (addend.kind != TermKind::Const)
      continue;
    std::optional<int64_t> value = sym::getIntegerLiteralValue(addend.expr);
    if (value) {
      FailureOr<bool> took =
          takeInstOffsetConstAddend(analysis, spec, *value, plan);
      if (failed(took))
        return failure();
      if (*took)
        continue;
    }
    if (failed(appendPlanRemainder(analysis, addend.expr, plan)))
      return failure();
  }
  return success();
}

static FailureOr<bool>
tryAppendPlanSlot(WaveAMDMachineSelector &S, sym::Analysis &analysis,
                  sym::ExprHandle expr, AddressPlan &plan,
                  sym::ExprHandle &slotExpr, bool &slotNeedsWide) {
  if (!expr)
    return true;
  sym::ExprHandle candidate = slotExpr;
  if (failed(appendPlanExpr(analysis, expr, candidate)))
    return failure();
  if (!S.slotFitsU32(analysis, candidate))
    return false;
  slotNeedsWide = needsWideAddressMaterialization(candidate, plan);
  slotExpr = candidate;
  return true;
}

static LogicalResult packPlanSlotAddends(WaveAMDMachineSelector &S,
                                         TermKind kind, sym::Analysis &analysis,
                                         ArrayRef<AddressPlanAddend> addends,
                                         AddressPlan &plan,
                                         sym::ExprHandle &slotExpr,
                                         bool &slotNeedsWide) {
  for (const AddressPlanAddend &addend : addends) {
    if (addend.kind != kind)
      continue;
    FailureOr<bool> took = tryAppendPlanSlot(S, analysis, addend.expr, plan,
                                             slotExpr, slotNeedsWide);
    if (failed(took))
      return failure();
    if (!*took && failed(appendPlanRemainder(analysis, addend.expr, plan)))
      return failure();
  }
  return success();
}

static LogicalResult
appendPlanAddendsRemainder(sym::Analysis &analysis, TermKind kind,
                           ArrayRef<AddressPlanAddend> addends,
                           AddressPlan &plan) {
  for (const AddressPlanAddend &addend : addends)
    if (addend.kind == kind &&
        failed(appendPlanRemainder(analysis, addend.expr, plan)))
      return failure();
  return success();
}

static LogicalResult
assignPlanAddends(WaveAMDMachineSelector &S, sym::Analysis &analysis,
                  const waveamdmachine::AddressFieldSpec &spec,
                  ArrayRef<AddressPlanAddend> addends, AddressPlan &plan) {
  if (failed(takeInstOffsetAddends(analysis, spec, addends, plan)))
    return failure();
  if (spec.hasSoffset)
    return packPlanSlotAddends(S, TermKind::Uniform, analysis, addends, plan,
                               plan.soffsetExpr, plan.soffsetNeedsWide);
  return appendPlanAddendsRemainder(analysis, TermKind::Uniform, addends, plan);
}

static std::optional<uint64_t>
getAddressPlanMaterializationCost(const AddressPlan &plan) {
  uint64_t cost = 0;
  for (sym::ExprHandle expr :
       {plan.voffsetExpr, plan.soffsetExpr, plan.fullAddressRemainderExpr}) {
    if (!expr)
      continue;
    std::optional<uint64_t> exprCost = getIndexExprMaterializationCost(expr);
    if (!exprCost || *exprCost > std::numeric_limits<uint64_t>::max() - cost)
      return std::nullopt;
    cost += *exprCost;
  }
  return cost;
}

static bool preferWholeAddressPlan(const AddressPlan &whole,
                                   const AddressPlan &decomposed) {
  if (decomposed.voffsetExpr && decomposed.soffsetExpr &&
      !decomposed.fullAddressRemainderExpr)
    return false;
  std::optional<uint64_t> wholeCost = getAddressPlanMaterializationCost(whole);
  std::optional<uint64_t> decomposedCost =
      getAddressPlanMaterializationCost(decomposed);
  if (!decomposedCost)
    return true;
  return wholeCost && *wholeCost < *decomposedCost;
}

static void selectPlanMaterialization(sym::Analysis &analysis,
                                      sym::ExprHandle &expr) {
  if (!expr)
    return;
  FailureOr<sym::ExprHandle> simplified = analysis.simplify(expr);
  if (succeeded(simplified) && shouldUseSimplifiedIndexExpr(*simplified, expr))
    expr = *simplified;
}

static FailureOr<AddressPlan>
buildDecomposedAddressPlan(WaveAMDMachineSelector &S, sym::Analysis &analysis,
                           const waveamdmachine::AddressFieldSpec &spec,
                           ArrayRef<AddressPlanAddend> addends,
                           const AddressPlan &base) {
  AddressPlan plan = base;
  if (failed(assignPlanAddends(S, analysis, spec, addends, plan)) ||
      failed(packPlanSlotAddends(S, TermKind::Lane, analysis, addends, plan,
                                 plan.voffsetExpr, plan.voffsetNeedsWide)))
    return failure();
  selectPlanMaterialization(analysis, plan.voffsetExpr);
  selectPlanMaterialization(analysis, plan.soffsetExpr);
  selectPlanMaterialization(analysis, plan.fullAddressRemainderExpr);
  plan.voffsetNeedsWide =
      needsWideAddressMaterialization(plan.voffsetExpr, plan);
  plan.soffsetNeedsWide =
      needsWideAddressMaterialization(plan.soffsetExpr, plan);
  return plan;
}

static FailureOr<AddressPlan> buildDecomposedAddressPlanForExpr(
    WaveAMDMachineSelector &S, sym::Analysis &analysis,
    const waveamdmachine::AddressFieldSpec &spec, sym::ExprHandle expr,
    const llvm::StringMap<TermKind> &symKinds, const AddressPlan &base) {
  SmallVector<AddressPlanAddend, 8> addends;
  if (failed(collectPlanAddends(S, expr, analysis, symKinds, addends)))
    return failure();
  return buildDecomposedAddressPlan(S, analysis, spec, addends, base);
}

static FailureOr<AddressPlan>
buildWholeAddressPlan(WaveAMDMachineSelector &S, sym::Analysis &analysis,
                      const waveamdmachine::AddressFieldSpec &spec,
                      const llvm::StringMap<TermKind> &symKinds,
                      sym::ExprHandle materialExpr, const AddressPlan &base) {
  AddressPlan plan = base;
  TermKind wholeKind = classifyTerm(S, materialExpr, symKinds);
  bool assigned = false;
  if (wholeKind == TermKind::Const)
    if (std::optional<int64_t> value =
            sym::getIntegerLiteralValue(materialExpr)) {
      FailureOr<bool> took =
          takeInstOffsetConstAddend(analysis, spec, *value, plan);
      if (failed(took))
        return failure();
      assigned = *took;
    }
  if (assigned)
    return plan;
  if (wholeKind == TermKind::Uniform && spec.hasSoffset) {
    plan.soffsetExpr = materialExpr;
    plan.soffsetNeedsWide = needsWideAddressMaterialization(materialExpr, plan);
  } else {
    plan.voffsetExpr = materialExpr;
    plan.voffsetNeedsWide = needsWideAddressMaterialization(materialExpr, plan);
  }
  return plan;
}

struct AddressPlanCandidates {
  AddressPlan decomposed;
  sym::ExprHandle materialExpr;
  bool wholeFits = false;
};

static FailureOr<AddressPlanCandidates> buildAddressPlanCandidates(
    WaveAMDMachineSelector &S, sym::Analysis &analysis,
    const waveamdmachine::AddressFieldSpec &spec, sym::ExprHandle materialExpr,
    const llvm::StringMap<TermKind> &symKinds, const AddressPlan &base) {
  bool wholeFits = S.slotFitsU32(analysis, materialExpr);
  FailureOr<AddressPlan> decomposed = buildDecomposedAddressPlanForExpr(
      S, analysis, spec, materialExpr, symKinds, base);
  if (failed(decomposed))
    return failure();
  if (wholeFits || !decomposed->fullAddressRemainderExpr)
    return AddressPlanCandidates{*decomposed, materialExpr, wholeFits};

  FailureOr<sym::ExprHandle> expanded = analysis.expand(materialExpr);
  if (failed(expanded))
    return AddressPlanCandidates{*decomposed, materialExpr, wholeFits};
  sym::ExprHandle queryExpr = *expanded;
  FailureOr<sym::ExprHandle> simplified = analysis.simplify(queryExpr);
  if (succeeded(simplified))
    queryExpr = *simplified;
  wholeFits = S.slotFitsU32(analysis, queryExpr);
  if (!shouldUseSimplifiedIndexExpr(queryExpr, materialExpr))
    return AddressPlanCandidates{*decomposed, materialExpr, wholeFits};

  materialExpr = queryExpr;
  decomposed = buildDecomposedAddressPlanForExpr(S, analysis, spec,
                                                 materialExpr, symKinds, base);
  if (failed(decomposed))
    return failure();
  return AddressPlanCandidates{*decomposed, materialExpr, wholeFits};
}

} // namespace

// ---- public surface (declared in WaveAMDMachineSelector.h) ----------------

bool needsWideAddressMaterialization(sym::ExprHandle expr,
                                     const AddressPlan &plan) {
  return needsWideAddressMaterializationImpl(expr, plan);
}

bool hasRationalIndexExpr(sym::ExprHandle expr) {
  return expr && containsRationalMaterialization(expr);
}

bool needsIntegerRationalMaterialization(sym::ExprHandle expr) {
  return expr && needsRationalMaterialization(expr);
}

bool requiresWideRationalIntermediates(WaveAMDMachineSelector &S,
                                       sym::ExprHandle expr,
                                       ArrayRef<sym::PredHandle> assumptions,
                                       const llvm::StringMap<Value> &bindings) {
  if (!hasRationalIndexExpr(expr))
    return false;
  FailureOr<std::unique_ptr<sym::Analysis>> analysis =
      sym::Analysis::create(S.symbolStore(), assumptions);
  if (failed(analysis) ||
      failed(assumeNarrowBindingRanges(S, **analysis, bindings)))
    return true;
  return requiresWideRationalIntermediatesImpl(**analysis, expr);
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
  case sym::ExprKind::And:
  case sym::ExprKind::Or:
    return materializeBitwise(S, expr, user, subs, assumptions, addOrder);
  case sym::ExprKind::Piecewise:
    return materializePiecewise(S, expr, user, subs, assumptions, addOrder);
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
classifyPredicateTerm(WaveAMDMachineSelector &S, sym::PredHandle pred,
                      const llvm::StringMap<TermKind> &symKinds) {
  sym::PredView view(pred);
  switch (view.getKind()) {
  case sym::PredKind::True:
  case sym::PredKind::False:
    return TermKind::Const;
  case sym::PredKind::Cmp:
    return std::max(classifyTerm(S, view.getCmpLhs(), symKinds),
                    classifyTerm(S, view.getCmpRhs(), symKinds));
  case sym::PredKind::And:
  case sym::PredKind::Or: {
    TermKind kind = TermKind::Const;
    for (uint32_t i = 0, e = view.getLogicArgCount(); i != e; ++i)
      kind = std::max(kind,
                      classifyPredicateTerm(S, view.getLogicArg(i), symKinds));
    return kind;
  }
  case sym::PredKind::Not:
    return classifyPredicateTerm(S, view.getUnaryArg(), symKinds);
  default:
    return TermKind::Lane;
  }
}

static TermKind classifyAssocTerm(WaveAMDMachineSelector &S, sym::ExprView view,
                                  const llvm::StringMap<TermKind> &symKinds) {
  TermKind kind = TermKind::Const;
  for (uint32_t i : llvm::seq<uint32_t>(0, view.getAssocArgCount()))
    kind = std::max(kind, classifyTerm(S, view.getAssocArg(i), symKinds));
  return kind;
}

static TermKind
classifyPiecewiseTerm(WaveAMDMachineSelector &S, sym::ExprView view,
                      const llvm::StringMap<TermKind> &symKinds) {
  TermKind kind = TermKind::Const;
  for (uint32_t i = 0, e = view.getPiecewiseCaseCount(); i != e; ++i) {
    sym::PiecewiseCase piece = view.getPiecewiseCase(i);
    kind = std::max(kind, classifyTerm(S, piece.value, symKinds));
    kind = std::max(kind, classifyPredicateTerm(S, piece.condition, symKinds));
  }
  return kind;
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
    return std::max(classifyTerm(S, view.getBinaryLhs(), symKinds),
                    classifyTerm(S, view.getBinaryRhs(), symKinds));
  case sym::ExprKind::Xor:
  case sym::ExprKind::And:
  case sym::ExprKind::Or:
    return classifyAssocTerm(S, view, symKinds);
  case sym::ExprKind::Piecewise:
    return classifyPiecewiseTerm(S, view, symKinds);
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
                  const waveamdmachine::AddressFieldSpec &spec,
                  bool allowFullAddressRemainder) {
  AddressPlan plan;
  plan.bindings = offset.bindings;
  plan.assumptions = offset.assumptions;
  if (!offset.expr)
    return plan;

  llvm::StringMap<TermKind> symKinds;
  for (const PointerOffsetBinding &binding : offset.bindings)
    symKinds[binding.name] = binding.kind;

  sym::ExprHandle materialExpr = offset.expr;
  FailureOr<std::unique_ptr<sym::Analysis>> analysis =
      sym::Analysis::create(S.symbolStore(), plan.assumptions);
  if (failed(analysis))
    return failure();
  FailureOr<AddressPlanCandidates> candidates = buildAddressPlanCandidates(
      S, **analysis, spec, materialExpr, symKinds, plan);
  if (failed(candidates))
    return failure();
  if (!candidates->wholeFits)
    return candidates->decomposed;

  FailureOr<AddressPlan> whole = buildWholeAddressPlan(
      S, **analysis, spec, symKinds, candidates->materialExpr, plan);
  if (failed(whole))
    return failure();
  if (!allowFullAddressRemainder &&
      candidates->decomposed.fullAddressRemainderExpr)
    return *whole;
  if (preferWholeAddressPlan(*whole, candidates->decomposed))
    return *whole;
  return candidates->decomposed;
}

} // namespace mlir::wave::wmsel
