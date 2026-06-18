//===- WaveSimplifyIndexExprs.cpp - Range-simplify index_exprs -*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/Wave/Transforms/Passes.h"

#include "mlir/Analysis/DataFlow/IntegerRangeAnalysis.h"
#include "mlir/Analysis/DataFlow/Utils.h"
#include "mlir/Analysis/DataFlowFramework.h"
#include "mlir/Dialect/Wave/IR/Wave.h"
#include "mlir/Dialect/Wave/IR/WaveSymbols.h"
#include "mlir/IR/PatternMatch.h"
#include "llvm/ADT/DenseSet.h"

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

static SmallVector<sym::PredHandle>
collectIndexExprAssumptions(IndexExprOp op, DataFlowSolver &solver,
                            sym::Store &store) {
  SmallVector<sym::PredHandle> assumptions;
  appendIndexExprPredicates(op, assumptions);
  for (auto [nameAttr, binding] : llvm::zip(op.getNames(), op.getBindings())) {
    StringRef name = cast<StringAttr>(nameAttr).getValue();
    if (std::optional<ConstantIntRanges> range =
            getFiniteRange(solver, binding))
      appendRangeAndAssumePredicates(store, binding, name, *range, assumptions);
    else
      appendAssumePredicates(store, binding, name, assumptions);
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

static FailureOr<sym::ExprHandle>
expandAndSimplify(sym::Store &store, sym::ExprHandle expr,
                  ArrayRef<sym::PredHandle> assumptions) {
  if (FailureOr<sym::ExprHandle> expanded = sym::expandExpr(store, expr);
      succeeded(expanded))
    expr = *expanded;
  if (assumptions.empty())
    return sym::simplifyExpr(store, expr);
  return sym::simplifyExpr(store, expr, assumptions);
}

static FailureOr<bool> simplifyIndexExpr(IRRewriter &rewriter, IndexExprOp op,
                                         DataFlowSolver &solver,
                                         sym::Store &store) {
  SmallVector<sym::PredHandle> assumptions =
      collectIndexExprAssumptions(op, solver, store);

  FailureOr<sym::ExprHandle> simplified =
      expandAndSimplify(store, op.getExpr().getValue(), assumptions);
  if (failed(simplified))
    return op.emitError("failed to range-simplify wave.index_expr");

  llvm::DenseSet<StringRef> freeSymbols;
  collectFreeSymbols(*simplified, freeSymbols);
  SmallVector<sym::PredHandle> liveAssumptions =
      filterIndexExprPredicatesBySymbols(assumptions, freeSymbols);

  SmallVector<StringRef> names;
  SmallVector<Value> bindings;
  collectLiveBindings(op, freeSymbols, names, bindings);

  bool exprChanged = !(*simplified == op.getExpr().getValue());
  bool bindingsChanged = bindings.size() != op.getBindings().size();
  bool assumptionsChanged =
      !samePredicates(op.getAssumptionsAttr(), liveAssumptions);
  if (!exprChanged && !bindingsChanged && !assumptionsChanged)
    return false;

  return rewriteIndexExpr(rewriter, op, *simplified, names, bindings,
                          liveAssumptions);
}

struct WaveSimplifyIndexExprsPass
    : public wave::impl::WaveSimplifyIndexExprsBase<
          WaveSimplifyIndexExprsPass> {
  void runOnOperation() override {
    Operation *root = getOperation();

    WaveDialect *dialect = root->getContext()->getLoadedDialect<WaveDialect>();
    if (!dialect) {
      root->emitError("Wave dialect is not loaded");
      return signalPassFailure();
    }

    DataFlowSolver solver;
    dataflow::loadBaselineAnalyses(solver);
    solver.load<dataflow::IntegerRangeAnalysis>();
    if (failed(solver.initializeAndRun(root))) {
      root->emitError("IntegerRangeAnalysis failed for wave.index_expr pass");
      return signalPassFailure();
    }

    SmallVector<IndexExprOp> ops;
    root->walk([&](IndexExprOp op) { ops.push_back(op); });

    IRRewriter rewriter(root->getContext());
    for (IndexExprOp op : ops) {
      FailureOr<bool> changed =
          simplifyIndexExpr(rewriter, op, solver, dialect->getSymbolStore());
      if (failed(changed))
        return signalPassFailure();
    }
  }
};

} // namespace
