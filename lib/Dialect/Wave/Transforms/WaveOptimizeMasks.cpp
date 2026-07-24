//===- WaveOptimizeMasks.cpp - Optimize symbolic masks --------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/Wave/Transforms/Passes.h"
#include "mlir/Dialect/Wave/Transforms/SymbolicValue.h"

#include "mlir/Analysis/DataFlow/IntegerRangeAnalysis.h"
#include "mlir/Analysis/DataFlow/Utils.h"
#include "mlir/Analysis/DataFlowFramework.h"
#include "mlir/Dialect/Wave/IR/Wave.h"
#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/MapVector.h"
#include "llvm/ADT/StringMap.h"

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
  SmallVector<sym::PredHandle, 4> forms;
  CmpIOp op;
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

static bool areEquivalent(const PredicateCandidate &lhs,
                          const PredicateCandidate &rhs) {
  for (sym::PredHandle lhsForm : lhs.forms) {
    for (sym::PredHandle rhsForm : rhs.forms)
      if (lhsForm == rhsForm)
        return true;
  }
  return false;
}

static std::optional<bool> getConstantValue(sym::Analysis &analysis,
                                            sym::PredHandle predicate) {
  sym::CheckResult result = analysis.check(predicate);
  if (result != sym::CheckResult::Unknown)
    return std::optional<bool>{result == sym::CheckResult::True};
  return std::nullopt;
}

static LogicalResult shareEquivalentMasks(Operation *root, WaveDialect &dialect,
                                          DataFlowSolver &solver) {
  llvm::MapVector<Block *, SmallVector<CmpIOp>> blockComparisons;
  root->walk([&](CmpIOp op) {
    if (!op.getResult().use_empty())
      blockComparisons[op->getBlock()].push_back(op);
  });

  sym::Store &store = dialect.getSymbolStore();
  for (auto &[block, comparisons] : blockComparisons) {
    (void)block;
    PredicateBindingState bindings;
    SmallVector<PredicateCandidate> representatives;
    for (CmpIOp op : comparisons) {
      if (op.getResult().use_empty())
        continue;
      FailureOr<std::optional<SymbolicPredicate>> symbolic =
          buildSymbolicMaskPredicate(op.getResult(), dialect, solver);
      if (failed(symbolic))
        return op.emitError("failed to build symbolic mask predicate");
      if (!*symbolic)
        continue;
      FailureOr<CanonicalPredicate> canonical =
          canonicalizePredicate(store, std::move(**symbolic), bindings);
      if (failed(canonical))
        return op.emitError("failed to canonicalize symbolic mask predicate");

      FailureOr<std::unique_ptr<sym::Analysis>> analysis =
          sym::Analysis::create(store, canonical->assumptions);
      if (failed(analysis))
        return op.emitError("failed to create symbolic mask analysis");

      SmallVector<sym::PredHandle, 4> forms =
          (*analysis)->orderedComparisonForms(canonical->predicate);
      std::optional<bool> constant =
          getConstantValue(**analysis, canonical->predicate);
      if (constant) {
        OpBuilder builder(op);
        Value replacement = ConstantOp::create(
            builder, op.getLoc(), op.getType(), builder.getBoolAttr(*constant));
        op.getResult().replaceAllUsesWith(replacement);
        op.erase();
        continue;
      }

      PredicateCandidate candidate{std::move(forms), op};
      bool replaced = false;
      for (PredicateCandidate &representative : representatives) {
        if (representative.op.getType() != op.getType())
          continue;
        if (!areEquivalent(representative, candidate))
          continue;
        op.getResult().replaceAllUsesWith(representative.op.getResult());
        op.erase();
        replaced = true;
        break;
      }
      if (!replaced)
        representatives.push_back(std::move(candidate));
    }
  }
  return success();
}

struct WaveOptimizeMasksPass
    : public wave::impl::WaveOptimizeMasksBase<WaveOptimizeMasksPass> {
  void runOnOperation() override {
    Operation *root = getOperation();
    WaveDialect *dialect = getContext().getLoadedDialect<WaveDialect>();
    if (!dialect) {
      root->emitError("Wave dialect is not loaded");
      return signalPassFailure();
    }

    DataFlowSolver solver;
    dataflow::loadBaselineAnalyses(solver);
    solver.load<dataflow::IntegerRangeAnalysis>();
    if (failed(solver.initializeAndRun(root))) {
      root->emitError("IntegerRangeAnalysis failed for mask optimization pass");
      return signalPassFailure();
    }
    if (failed(shareEquivalentMasks(root, *dialect, solver)))
      return signalPassFailure();
  }
};

} // namespace
