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

static std::optional<sym::PredHandle>
buildRangeAssumption(DataFlowSolver &solver, sym::Store &store, Value binding,
                     StringRef name) {
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
  std::optional<int64_t> lo = getSExtI64(range.smin());
  std::optional<int64_t> hi = getSExtI64(range.smax());
  if (!lo || !hi)
    return std::nullopt;

  FailureOr<sym::PredHandle> assumption =
      sym::rangeAssumption(store, name, *lo, *hi);
  if (failed(assumption))
    return std::nullopt;
  return *assumption;
}

static SmallVector<sym::PredHandle>
collectIndexExprAssumptions(IndexExprOp op, DataFlowSolver &solver,
                            sym::Store &store) {
  SmallVector<sym::PredHandle> assumptions;
  for (auto [nameAttr, binding] : llvm::zip(op.getNames(), op.getBindings())) {
    StringRef name = cast<StringAttr>(nameAttr).getValue();
    std::optional<sym::PredHandle> assumption =
        buildRangeAssumption(solver, store, binding, name);
    if (assumption)
      assumptions.push_back(*assumption);
  }
  return assumptions;
}

static int64_t getIndexBindingWidth(Value binding) {
  Type type = binding.getType();
  if (WaveIndexType indexType = dyn_cast<WaveIndexType>(type))
    return indexType.getWidth();
  if (SimdType simdType = dyn_cast<SimdType>(type))
    return simdType.getWidth();
  return 0;
}

static WaveIndexType getIndexExprType(MLIRContext *ctx, ValueRange bindings) {
  int64_t width = 0;
  for (Value binding : bindings)
    width = std::max(width, getIndexBindingWidth(binding));
  return WaveIndexType::get(ctx, width);
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
                             ValueRange bindings) {
  Type resultType = getIndexExprType(op.getContext(), bindings);
  if (resultType != op.getResult().getType())
    return false;

  rewriter.setInsertionPoint(op);
  auto replacement = IndexExprOp::create(
      rewriter, op.getLoc(), resultType, ExprAttr::get(op.getContext(), expr),
      rewriter.getStrArrayAttr(names), bindings);
  rewriter.replaceOp(op, replacement.getResult());
  return true;
}

static FailureOr<bool> simplifyIndexExpr(IRRewriter &rewriter, IndexExprOp op,
                                         DataFlowSolver &solver,
                                         sym::Store &store) {
  SmallVector<sym::PredHandle> assumptions =
      collectIndexExprAssumptions(op, solver, store);
  if (assumptions.empty())
    return false;

  FailureOr<sym::ExprHandle> simplified =
      sym::simplifyExpr(store, op.getExpr().getValue(), assumptions);
  if (failed(simplified))
    return op.emitError("failed to range-simplify wave.index_expr");

  llvm::DenseSet<StringRef> freeSymbols;
  collectFreeSymbols(*simplified, freeSymbols);

  SmallVector<StringRef> names;
  SmallVector<Value> bindings;
  collectLiveBindings(op, freeSymbols, names, bindings);

  bool exprChanged = !(*simplified == op.getExpr().getValue());
  bool bindingsChanged = bindings.size() != op.getBindings().size();
  if (!exprChanged && !bindingsChanged)
    return false;

  return rewriteIndexExpr(rewriter, op, *simplified, names, bindings);
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
