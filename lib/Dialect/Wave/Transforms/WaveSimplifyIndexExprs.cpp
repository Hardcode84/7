//===- WaveSimplifyIndexExprs.cpp - Range-simplify index_exprs -*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/Wave/Transforms/Passes.h"

#include "WaveSymbolicTransformTiming.h"

#include "mlir/Analysis/DataFlow/IntegerRangeAnalysis.h"
#include "mlir/Analysis/DataFlow/Utils.h"
#include "mlir/Analysis/DataFlowFramework.h"
#include "mlir/Dialect/Wave/IR/Wave.h"
#include "mlir/Dialect/Wave/IR/WaveSymbols.h"
#include "mlir/IR/PatternMatch.h"
#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/DenseSet.h"

#include <memory>
#include <optional>

namespace mlir::wave {
#define GEN_PASS_DEF_WAVESIMPLIFYINDEXEXPRS
#include "mlir/Dialect/Wave/Transforms/Passes.h.inc"
} // namespace mlir::wave

using namespace mlir;
using namespace mlir::wave;

namespace {

static bool isFullSignedRange(const ConstantIntRanges &range) {
  unsigned width = range.smin().getBitWidth();
  if (width == 0)
    return true;
  return range.smin() == APInt::getSignedMinValue(width) &&
         range.smax() == APInt::getSignedMaxValue(width);
}

static std::optional<int64_t> getSExtI64(const APInt &value) {
  if (!value.isSignedIntN(64))
    return std::nullopt;
  return value.getSExtValue();
}

static std::optional<ConstantIntRanges> getFiniteRange(DataFlowSolver &solver,
                                                       Value binding) {
  const dataflow::IntegerValueRangeLattice *lattice =
      solver.lookupState<dataflow::IntegerValueRangeLattice>(binding);
  if (!lattice)
    return std::nullopt;
  IntegerValueRange ivr = lattice->getValue();
  if (ivr.isUninitialized())
    return std::nullopt;

  ConstantIntRanges range = ivr.getValue();
  if (isFullSignedRange(range))
    return std::nullopt;
  if (!getSExtI64(range.smin()) || !getSExtI64(range.smax()))
    return std::nullopt;
  return range;
}

struct IndexExprAssumptions {
  SmallVector<sym::PredHandle> explicitPredicates;
  SmallVector<sym::PredHandle> bindingPredicates;

  SmallVector<sym::PredHandle> all() const {
    SmallVector<sym::PredHandle> result(explicitPredicates);
    result.append(bindingPredicates.begin(), bindingPredicates.end());
    return result;
  }
};

static IndexExprAssumptions collectIndexExprAssumptions(IndexExprOp op,
                                                        DataFlowSolver &solver,
                                                        sym::Store &store) {
  IndexExprAssumptions assumptions;
  appendIndexExprPredicates(op, assumptions.explicitPredicates);
  for (auto [nameAttr, binding] : llvm::zip(op.getNames(), op.getBindings())) {
    StringRef name = cast<StringAttr>(nameAttr).getValue();
    if (std::optional<ConstantIntRanges> range =
            getFiniteRange(solver, binding))
      appendRangeAndAssumePredicates(store, binding, name, *range,
                                     assumptions.bindingPredicates);
    else
      appendAssumePredicates(store, binding, name,
                             assumptions.bindingPredicates);
  }
  return assumptions;
}

static bool samePredicates(ArrayAttr attrs,
                           ArrayRef<sym::PredHandle> assumptions) {
  if (attrs.size() != assumptions.size())
    return false;
  for (auto [attr, pred] : llvm::zip(attrs, assumptions))
    if (!(cast<PredAttr>(attr).getValue() == pred))
      return false;
  return true;
}

static void collectFreeSymbols(sym::ExprHandle expr,
                               llvm::DenseSet<StringRef> &symbols) {
  sym::walkSymbolNames(expr, [&](StringRef name) { symbols.insert(name); });
}

static void collectLiveBindings(IndexExprOp op,
                                const llvm::DenseSet<StringRef> &freeSymbols,
                                SmallVectorImpl<StringRef> &names,
                                SmallVectorImpl<Value> &bindings) {
  for (auto [nameAttr, binding] : llvm::zip(op.getNames(), op.getBindings())) {
    StringRef name = cast<StringAttr>(nameAttr).getValue();
    if (!freeSymbols.count(name))
      continue;
    names.push_back(name);
    bindings.push_back(binding);
  }
}

static bool rewriteIndexExpr(IRRewriter &rewriter, IndexExprOp op,
                             sym::ExprHandle expr, ArrayRef<StringRef> names,
                             ValueRange bindings,
                             ArrayRef<sym::PredHandle> assumptions) {
  Type resultType = getIndexExprResultType(op.getContext(), bindings);
  Type targetType = op.getResult().getType();
  auto targetSimd = dyn_cast<SimdType>(targetType);
  bool needsSplat = targetSimd && resultType == targetSimd.getElementType();
  if (resultType != targetType && !needsSplat)
    return false;

  rewriter.setInsertionPoint(op);
  auto replacement = IndexExprOp::create(
      rewriter, op.getLoc(), resultType, ExprAttr::get(op.getContext(), expr),
      getIndexExprPredArrayAttr(op.getContext(), assumptions),
      rewriter.getStrArrayAttr(names), bindings);
  Value result = replacement.getResult();
  if (needsSplat)
    result = SplatOp::create(rewriter, op.getLoc(), targetType, result);
  rewriter.replaceOp(op, result);
  return true;
}

static FailureOr<sym::ExprHandle> expandAndSimplify(sym::Analysis &analysis,
                                                    sym::ExprHandle expr) {
  return analysis.simplify(analysis.expand(expr));
}

static FailureOr<std::optional<sym::PredHandle>>
simplifyExplicitPredicate(sym::Analysis &analysis, sym::PredHandle pred);

static FailureOr<std::optional<sym::PredHandle>>
simplifyExplicitComparison(sym::Analysis &analysis, sym::PredView view) {
  std::optional<sym::PredCmpOp> comparison = view.getCmpOp();
  if (!comparison)
    return failure();
  FailureOr<sym::ExprHandle> lhs =
      expandAndSimplify(analysis, view.getCmpLhs());
  FailureOr<sym::ExprHandle> rhs =
      expandAndSimplify(analysis, view.getCmpRhs());
  if (failed(lhs) || failed(rhs))
    return failure();
  sym::PredHandle rewritten = analysis.compare(*lhs, *comparison, *rhs);
  if (analysis.check(rewritten) == sym::CheckResult::False)
    return std::optional<sym::PredHandle>{};
  return std::optional<sym::PredHandle>{rewritten};
}

static FailureOr<std::optional<sym::PredHandle>>
simplifyExplicitConjunction(sym::Analysis &analysis, sym::PredView view) {
  std::optional<sym::PredHandle> result;
  for (uint32_t i : llvm::seq<uint32_t>(0, view.getLogicArgCount())) {
    FailureOr<std::optional<sym::PredHandle>> arg =
        simplifyExplicitPredicate(analysis, view.getLogicArg(i));
    if (failed(arg))
      return failure();
    if (!*arg)
      continue;
    if (!result) {
      result = **arg;
      continue;
    }
    result = analysis.composeAnd(*result, **arg);
  }
  return result;
}

static FailureOr<std::optional<sym::PredHandle>>
simplifyExplicitPredicate(sym::Analysis &analysis, sym::PredHandle pred) {
  sym::PredView view(pred);
  if (view.getKind() == sym::PredKind::Cmp)
    return simplifyExplicitComparison(analysis, view);
  if (view.getKind() == sym::PredKind::And)
    return simplifyExplicitConjunction(analysis, view);
  if (view.getKind() == sym::PredKind::True ||
      view.getKind() == sym::PredKind::False)
    return std::optional<sym::PredHandle>{};
  return std::optional<sym::PredHandle>{pred};
}

static FailureOr<SmallVector<sym::PredHandle>>
simplifyExplicitPredicates(sym::Store &store,
                           ArrayRef<sym::PredHandle> explicitPredicates,
                           ArrayRef<sym::PredHandle> bindingPredicates) {
  FailureOr<std::unique_ptr<sym::Analysis>> analysis =
      sym::Analysis::create(store, bindingPredicates);
  if (failed(analysis))
    return failure();
  SmallVector<sym::PredHandle> simplifiedPredicates;
  for (sym::PredHandle pred : explicitPredicates) {
    FailureOr<std::optional<sym::PredHandle>> simplified =
        simplifyExplicitPredicate(**analysis, pred);
    if (failed(simplified))
      return failure();
    if (*simplified && !llvm::is_contained(simplifiedPredicates, **simplified))
      simplifiedPredicates.push_back(**simplified);
  }
  return simplifiedPredicates;
}

static FailureOr<bool> simplifyIndexExpr(IRRewriter &rewriter, IndexExprOp op,
                                         const IndexExprAssumptions &collected,
                                         sym::Store &store) {
  SmallVector<sym::PredHandle> assumptions = collected.all();
  FailureOr<std::unique_ptr<sym::Analysis>> analysis =
      sym::Analysis::create(store, assumptions);
  if (failed(analysis))
    return op.emitError("failed to create wave.index_expr analysis");
  sym::ExprHandle original = op.getExpr().getValue();
  sym::ExprHandle expanded = (*analysis)->expand(original);
  FailureOr<sym::ExprHandle> simplified = (*analysis)->simplify(expanded);
  if (failed(simplified))
    return op.emitError("failed to range-simplify wave.index_expr");
  analysis->reset();
  sym::ExprHandle result = shouldUseSimplifiedIndexExpr(*simplified, original)
                               ? *simplified
                               : original;

  llvm::DenseSet<StringRef> freeSymbols;
  collectFreeSymbols(result, freeSymbols);
  FailureOr<SmallVector<sym::PredHandle>> simplifiedExplicit =
      simplifyExplicitPredicates(store, collected.explicitPredicates,
                                 collected.bindingPredicates);
  if (failed(simplifiedExplicit))
    return op.emitError("failed to simplify wave.index_expr assumptions");
  SmallVector<sym::PredHandle> rewrittenAssumptions =
      std::move(*simplifiedExplicit);
  rewrittenAssumptions.append(collected.bindingPredicates.begin(),
                              collected.bindingPredicates.end());
  SmallVector<sym::PredHandle> liveAssumptions =
      filterIndexExprPredicatesBySymbols(rewrittenAssumptions, freeSymbols);

  SmallVector<StringRef> names;
  SmallVector<Value> bindings;
  collectLiveBindings(op, freeSymbols, names, bindings);

  bool exprChanged = !(result == op.getExpr().getValue());
  bool bindingsChanged = bindings.size() != op.getBindings().size();
  bool assumptionsChanged =
      !samePredicates(op.getAssumptionsAttr(), liveAssumptions);
  if (!exprChanged && !bindingsChanged && !assumptionsChanged)
    return false;

  return rewriteIndexExpr(rewriter, op, result, names, bindings,
                          liveAssumptions);
}

struct WaveSimplifyIndexExprsPass
    : public wave::impl::WaveSimplifyIndexExprsBase<
          WaveSimplifyIndexExprsPass> {
  void runOnOperation() override {
    SymbolicTransformTiming timing("simplify_index_exprs");
    Operation *root = getOperation();

    WaveDialect *dialect = root->getContext()->getLoadedDialect<WaveDialect>();
    if (!dialect) {
      root->emitError("Wave dialect is not loaded");
      return signalPassFailure();
    }

    SmallVector<IndexExprOp> ops;
    {
      TimingScope collectTiming = timing.nest("index_expr_collect");
      root->walk([&](IndexExprOp op) { ops.push_back(op); });
    }
    if (ops.empty())
      return;

    DataFlowSolver solver;
    dataflow::loadBaselineAnalyses(solver);
    solver.load<dataflow::IntegerRangeAnalysis>();
    {
      TimingScope rangeTiming = timing.nest("index_expr_range_analysis");
      if (failed(solver.initializeAndRun(root))) {
        root->emitError("IntegerRangeAnalysis failed for wave.index_expr pass");
        return signalPassFailure();
      }
    }

    llvm::DenseMap<Operation *, IndexExprAssumptions> assumptionsByOp;
    {
      TimingScope assumptionsTiming =
          timing.nest("index_expr_collect_assumptions");
      for (IndexExprOp op : ops)
        assumptionsByOp[op.getOperation()] =
            collectIndexExprAssumptions(op, solver, dialect->getSymbolStore());
    }

    IRRewriter rewriter(root->getContext());
    TimingScope simplifyTiming = timing.nest("index_expr_simplify");
    for (IndexExprOp op : ops) {
      auto it = assumptionsByOp.find(op.getOperation());
      assert(it != assumptionsByOp.end() && "missing precomputed assumptions");
      FailureOr<bool> changed = simplifyIndexExpr(rewriter, op, it->second,
                                                  dialect->getSymbolStore());
      if (failed(changed))
        return signalPassFailure();
    }
  }
};

} // namespace
