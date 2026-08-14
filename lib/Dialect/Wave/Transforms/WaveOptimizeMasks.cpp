//===- WaveOptimizeMasks.cpp - Optimize symbolic masks --------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/Wave/Transforms/Passes.h"
#include "mlir/Dialect/Wave/Transforms/SymbolicValue.h"

#include "../IR/WaveIndexExpr.h"
#include "WaveSymbolicTransformTiming.h"
#include "mlir/Dialect/Wave/IR/Wave.h"
#include "mlir/Transforms/GreedyPatternRewriteDriver.h"
#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/MapVector.h"
#include "llvm/ADT/StringMap.h"

#include <memory>

namespace mlir::wave {
#define GEN_PASS_DEF_WAVEOPTIMIZEMASKS
#include "mlir/Dialect/Wave/Transforms/Passes.h.inc"
} // namespace mlir::wave

using namespace mlir;
using namespace mlir::wave;

namespace {

struct PredicateBindingState {
  llvm::DenseMap<Value, StringRef> byValue;
  llvm::StringMap<Value> reserved;
};

struct CanonicalPredicate {
  SmallVector<sym::PredHandle> assumptions;
  sym::PredHandle predicate;
};

struct PredicateCandidate {
  sym::PredHandle predicate;
  SmallVector<sym::PredHandle, 4> equivalentForms;
  CmpIOp op;
  std::unique_ptr<sym::Analysis> analysis;
};

struct MaskBlockState {
  SmallVector<PredicateCandidate> representatives;
  PredicateBindingState bindings;
};

using BlockComparisons = llvm::MapVector<Block *, SmallVector<CmpIOp>>;

struct IntegerizedMask {
  Value mask;
  int64_t trueBits = 0;
};

static std::optional<IntegerizedMask> matchIntegerizedMask(Value value) {
  SelectOp select = value.getDefiningOp<SelectOp>();
  if (!select || !isa<MaskType>(select.getCondition().getType()))
    return std::nullopt;

  std::optional<int64_t> trueValue =
      getSplatOrConstantInt(select.getTrueValue());
  std::optional<int64_t> falseValue =
      getSplatOrConstantInt(select.getFalseValue());
  if (!trueValue || !falseValue || *trueValue == 0 || *falseValue != 0)
    return std::nullopt;
  return IntegerizedMask{select.getCondition(), *trueValue};
}

static bool rewriteIntegerizedMaskAndCmp(PatternRewriter &rewriter, CmpIOp op) {
  if (op.getPredicate() != arith::CmpIPredicate::ne)
    return false;

  Value andValue;
  if (getSplatOrConstantInt(op.getRhs()) == int64_t{0})
    andValue = op.getLhs();
  else if (getSplatOrConstantInt(op.getLhs()) == int64_t{0})
    andValue = op.getRhs();
  else
    return false;

  BinaryOp andOp = andValue.getDefiningOp<BinaryOp>();
  if (!andOp || andOp.getKind() != BinaryKind::AndI)
    return false;

  std::optional<IntegerizedMask> lhs = matchIntegerizedMask(andOp.getLhs());
  std::optional<IntegerizedMask> rhs = matchIntegerizedMask(andOp.getRhs());
  if (!lhs || !rhs || (lhs->trueBits & rhs->trueBits) == 0)
    return false;

  rewriter.setInsertionPoint(op);
  Value falseMask = ConstantOp::create(rewriter, op.getLoc(), op.getType(),
                                       rewriter.getBoolAttr(false));
  Value combined = SelectOp::create(rewriter, op.getLoc(), op.getType(),
                                    lhs->mask, rhs->mask, falseMask);
  rewriter.replaceOp(op, combined);
  return true;
}

struct OptimizeIntegerizedMaskAndCmpPattern : OpRewritePattern<CmpIOp> {
  using OpRewritePattern::OpRewritePattern;

  LogicalResult matchAndRewrite(CmpIOp op,
                                PatternRewriter &rewriter) const override {
    if (rewriteIntegerizedMaskAndCmp(rewriter, op))
      return success();
    return failure();
  }
};

static StringRef getSymbolName(const SymbolicOffsetBinding &binding) {
  StringRef name = sym::ExprView(binding.name).getSymbolName();
  assert(!name.empty() && "symbolic binding must have a name");
  return name;
}

static FailureOr<CanonicalPredicate>
canonicalizePredicate(sym::Store &store, SymbolicPredicate symbolic,
                      PredicateBindingState &state) {
  SmallVector<sym::ExprSubstitution> substitutions;
  for (const SymbolicOffsetBinding &binding : symbolic.bindings) {
    StringRef oldName = getSymbolName(binding);
    StringRef newName = reserveIndexExprBindingName(
        oldName, binding.value, state.reserved, state.byValue);
    if (newName == oldName)
      continue;
    FailureOr<sym::ExprHandle> replacement =
        sym::composeExprSym(store, newName);
    if (failed(replacement))
      return failure();
    substitutions.push_back({binding.name, *replacement});
  }

  if (substitutions.empty())
    return CanonicalPredicate{std::move(symbolic.assumptions),
                              symbolic.predicate};
  FailureOr<SmallVector<sym::PredHandle>> assumptions =
      substituteIndexExprPredicates(store, symbolic.assumptions, substitutions);
  FailureOr<sym::PredHandle> predicate =
      sym::substitutePred(store, symbolic.predicate, substitutions);
  if (failed(assumptions) || failed(predicate))
    return failure();
  return CanonicalPredicate{std::move(*assumptions), *predicate};
}

static bool haveEquivalentFormsUnder(const PredicateCandidate &domain,
                                     const PredicateCandidate &other,
                                     SymbolicTransformTiming &timing) {
  TimingScope formsTiming = timing.nest("mask_cross_domain_forms");
  SmallVector<sym::PredHandle, 4> otherForms =
      domain.analysis->orderedComparisonForms(other.predicate);
  return llvm::any_of(domain.equivalentForms, [&](sym::PredHandle form) {
    return llvm::is_contained(otherForms, form);
  });
}

static bool haveEquivalentForms(const PredicateCandidate &lhs,
                                const PredicateCandidate &rhs,
                                SymbolicTransformTiming &timing) {
  if (lhs.predicate == rhs.predicate)
    return true;
  // Candidate assumptions are local to the packet that produced them. Require
  // the canonical forms to agree in both domains before sharing either value.
  return haveEquivalentFormsUnder(lhs, rhs, timing) &&
         haveEquivalentFormsUnder(rhs, lhs, timing);
}

static FailureOr<std::optional<bool>>
getConstantValue(sym::Analysis &analysis, sym::PredHandle predicate) {
  FailureOr<sym::CheckResult> query = analysis.check(predicate);
  if (failed(query))
    return failure();
  sym::CheckResult result = *query;
  if (result != sym::CheckResult::Unknown)
    return std::optional<bool>{result == sym::CheckResult::True};
  return std::optional<bool>{};
}

static BlockComparisons collectMaskComparisons(Operation *root) {
  BlockComparisons blockComparisons;
  root->walk([&](CmpIOp op) {
    if (!op.getResult().use_empty())
      blockComparisons[op->getBlock()].push_back(op);
  });
  return blockComparisons;
}

static void replaceWithMaskConstant(CmpIOp op, bool value) {
  OpBuilder builder(op);
  Value replacement = ConstantOp::create(builder, op.getLoc(), op.getType(),
                                         builder.getBoolAttr(value));
  op.getResult().replaceAllUsesWith(replacement);
  op.erase();
}

static LogicalResult
shareOrRecordMask(CmpIOp op, CanonicalPredicate canonical,
                  std::unique_ptr<sym::Analysis> analysis,
                  SmallVectorImpl<PredicateCandidate> &representatives,
                  SymbolicTransformTiming &timing) {
  SmallVector<sym::PredHandle, 4> equivalentForms;
  {
    TimingScope formsTiming = timing.nest("mask_equivalent_forms");
    equivalentForms = analysis->orderedComparisonForms(canonical.predicate);
  }
  PredicateCandidate candidate{canonical.predicate, std::move(equivalentForms),
                               op, std::move(analysis)};
  for (PredicateCandidate &representative : representatives) {
    if (representative.op.getType() != op.getType())
      continue;
    if (!haveEquivalentForms(representative, candidate, timing))
      continue;
    op.getResult().replaceAllUsesWith(representative.op.getResult());
    op.erase();
    return success();
  }
  representatives.push_back(std::move(candidate));
  return success();
}

static LogicalResult optimizeMaskComparison(CmpIOp op, WaveDialect &dialect,
                                            MaskBlockState &state,
                                            SymbolicTransformTiming &timing) {
  sym::Store &store = dialect.getSymbolStore();
  FailureOr<std::optional<SymbolicPredicate>> symbolic = [&] {
    TimingScope buildTiming = timing.nest("mask_build_predicate");
    return buildSymbolicMaskPredicate(op.getResult(), dialect);
  }();
  if (failed(symbolic))
    return op.emitError("failed to build symbolic mask predicate");
  if (!*symbolic)
    return success();
  FailureOr<CanonicalPredicate> canonical = [&] {
    TimingScope canonicalizeTiming = timing.nest("mask_canonicalize_predicate");
    return canonicalizePredicate(store, std::move(**symbolic), state.bindings);
  }();
  if (failed(canonical))
    return op.emitError("failed to canonicalize symbolic mask predicate");

  FailureOr<std::unique_ptr<sym::Analysis>> analysis = [&] {
    TimingScope analysisTiming = timing.nest("mask_create_analysis");
    return createClosedIndexExprAnalysis(store, canonical->assumptions);
  }();
  if (failed(analysis))
    return op.emitError("failed to create symbolic mask analysis");

  FailureOr<std::optional<bool>> constant = [&] {
    TimingScope constantTiming = timing.nest("mask_constant_query");
    return getConstantValue(**analysis, canonical->predicate);
  }();
  if (failed(constant))
    return op.emitError("failed to query symbolic mask value");
  if (*constant) {
    replaceWithMaskConstant(op, **constant);
    return success();
  }
  return shareOrRecordMask(op, std::move(*canonical), std::move(*analysis),
                           state.representatives, timing);
}

static LogicalResult
shareEquivalentMasks(const BlockComparisons &blockComparisons,
                     WaveDialect &dialect, SymbolicTransformTiming &timing) {
  for (const BlockComparisons::value_type &entry : blockComparisons) {
    MaskBlockState state;
    for (CmpIOp op : entry.second) {
      if (op.getResult().use_empty())
        continue;
      if (failed(optimizeMaskComparison(op, dialect, state, timing)))
        return failure();
    }
  }
  return success();
}

struct WaveOptimizeMasksPass
    : public wave::impl::WaveOptimizeMasksBase<WaveOptimizeMasksPass> {
  void runOnOperation() override {
    SymbolicTransformTiming timing("optimize_masks");
    Operation *root = getOperation();
    WaveDialect *dialect = getContext().getLoadedDialect<WaveDialect>();
    if (!dialect) {
      root->emitError("Wave dialect is not loaded");
      return signalPassFailure();
    }

    {
      TimingScope rewriteTiming = timing.nest("mask_rewrite_integerized");
      RewritePatternSet patterns(&getContext());
      patterns.add<OptimizeIntegerizedMaskAndCmpPattern>(&getContext());
      if (mlir::failed(applyPatternsGreedily(root, std::move(patterns))))
        return signalPassFailure();
    }

    BlockComparisons blockComparisons;
    {
      TimingScope collectTiming = timing.nest("mask_collect_comparisons");
      blockComparisons = collectMaskComparisons(root);
    }
    if (blockComparisons.empty())
      return;

    if (failed(shareEquivalentMasks(blockComparisons, *dialect, timing)))
      return signalPassFailure();
  }
};

} // namespace
