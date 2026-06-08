//===- WaveAMDNarrowWideInt.cpp - Narrow wide integer ops -------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/Wave/Transforms/Passes.h"

#include "WaveAMDMachineSelector.h"
#include "mlir/Analysis/DataFlow/IntegerRangeAnalysis.h"
#include "mlir/Analysis/DataFlow/Utils.h"
#include "mlir/Analysis/DataFlowFramework.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachine.h"
#include "mlir/IR/PatternMatch.h"
#include "mlir/Interfaces/SideEffectInterfaces.h"
#include "mlir/Transforms/GreedyPatternRewriteDriver.h"

#include <cstdint>

namespace mlir::wave {
#define GEN_PASS_DEF_WAVEAMDNARROWWIDEINT
#include "mlir/Dialect/Wave/Transforms/Passes.h.inc"
} // namespace mlir::wave

using namespace mlir;
using namespace mlir::dataflow;
using namespace mlir::wave;
using namespace mlir::wave::wmsel;
using namespace mlir::waveamdmachine;

namespace {

static bool fitsU32(int64_t value) {
  return value >= 0 && static_cast<uint64_t>(value) <= (uint64_t{1} << 32) - 1;
}

static bool rangeProvesZero(DataFlowSolver &solver, Value value) {
  const IntegerValueRangeLattice *lattice =
      solver.lookupState<IntegerValueRangeLattice>(value);
  if (!lattice)
    return false;
  IntegerValueRange valueRange = lattice->getValue();
  if (valueRange.isUninitialized())
    return false;
  ConstantIntRanges range = valueRange.getValue();
  if (range.umin().getBitWidth() == 0)
    return false;
  return range.umin().isZero() && range.umax().isZero();
}

static bool isLocalZero(DataFlowSolver &solver, Value value) {
  if (auto imm = value.getDefiningOp<ImmOp>())
    return imm.getValue() == 0;
  if (auto mov = value.getDefiningOp<SMovB32ValueOp>())
    return isLocalZero(solver, mov.getSource());
  if (auto mov = value.getDefiningOp<SMovB32TupleOp>())
    return isLocalZero(solver, mov.getSource());
  if (auto mov = value.getDefiningOp<VMovB32TupleOp>())
    return isLocalZero(solver, mov.getSource());
  return rangeProvesZero(solver, value);
}

static std::optional<Value> matchZeroExtendedTuple(DataFlowSolver &solver,
                                                   Value value) {
  auto tuple = value.getDefiningOp<TupleFromElementsOp>();
  if (!tuple || tuple.getElements().size() != 2)
    return std::nullopt;
  Value hi = tuple.getElements().back();
  if (!isLocalZero(solver, hi))
    return std::nullopt;
  return tuple.getElements().front();
}

static FailureOr<Value> matchU32Addend(PatternRewriter &rewriter, Location loc,
                                       DataFlowSolver &solver, Value value) {
  if (auto mov = value.getDefiningOp<SMovB64ImmOp>()) {
    int64_t imm = mov.getValue();
    if (!fitsU32(imm))
      return failure();
    return createImm(rewriter, loc, imm);
  }
  if (auto mov = value.getDefiningOp<VMovB32TupleOp>()) {
    FailureOr<Value> source =
        matchU32Addend(rewriter, loc, solver, mov.getSource());
    if (succeeded(source))
      return *source;
  }
  if (auto mov = value.getDefiningOp<SMovB32TupleOp>()) {
    FailureOr<Value> source =
        matchU32Addend(rewriter, loc, solver, mov.getSource());
    if (succeeded(source))
      return *source;
  }
  if (std::optional<Value> low = matchZeroExtendedTuple(solver, value))
    return *low;
  return failure();
}

static void eraseDeadProducerTree(PatternRewriter &rewriter, Operation *op) {
  if (!op || !isOpTriviallyDead(op))
    return;
  SmallVector<Operation *> producers;
  for (Value operand : op->getOperands())
    if (Operation *producer = operand.getDefiningOp())
      producers.push_back(producer);
  rewriter.eraseOp(op);
  for (Operation *producer : producers)
    eraseDeadProducerTree(rewriter, producer);
}

template <typename OldOp, typename NewOp>
struct NarrowAddPattern : public OpRewritePattern<OldOp> {
  NarrowAddPattern(MLIRContext *context, DataFlowSolver &solver)
      : OpRewritePattern<OldOp>(context), solver(solver) {}

  LogicalResult matchAndRewrite(OldOp op,
                                PatternRewriter &rewriter) const override {
    if (succeeded(rewriteWithOffset(op, op.getLhs(), op.getRhs(), rewriter)))
      return success();
    return rewriteWithOffset(op, op.getRhs(), op.getLhs(), rewriter);
  }

  LogicalResult rewriteWithOffset(OldOp op, Value base, Value offset,
                                  PatternRewriter &rewriter) const {
    FailureOr<Value> narrowOffset =
        matchU32Addend(rewriter, op.getLoc(), solver, offset);
    if (failed(narrowOffset))
      return failure();
    NewOp narrow =
        NewOp::create(rewriter, op.getLoc(), op.getResult().getType(),
                      op->getResult(1).getType(), base, *narrowOffset);
    narrow->setAttrs(op->getAttrs());
    Operation *offsetProducer = offset.getDefiningOp();
    rewriter.replaceOp(op, narrow->getResults());
    eraseDeadProducerTree(rewriter, offsetProducer);
    return success();
  }

  DataFlowSolver &solver;
};

class DataFlowListener : public RewriterBase::Listener {
public:
  DataFlowListener(DataFlowSolver &solver) : solver(solver) {}

protected:
  void notifyOperationErased(Operation *op) override {
    solver.eraseState(solver.getProgramPointAfter(op));
    for (Value result : op->getResults())
      solver.eraseState(result);
  }

  DataFlowSolver &solver;
};

static bool hasNarrowWideCandidate(func::FuncOp func) {
  bool found = false;
  WalkResult result = func.walk([&](Operation *op) {
    if (!isa<SAddU64Op, VAddU64Op>(op))
      return WalkResult::advance();
    found = true;
    return WalkResult::interrupt();
  });
  return result.wasInterrupted() && found;
}

static LogicalResult runOnFunc(func::FuncOp func) {
  if (!hasNarrowWideCandidate(func))
    return success();

  DataFlowSolver solver;
  loadBaselineAnalyses(solver);
  solver.load<IntegerRangeAnalysis>();
  if (failed(solver.initializeAndRun(func)))
    return func.emitError(
        "IntegerRangeAnalysis failed for narrow-wide-int pass");

  RewritePatternSet patterns(func.getContext());
  patterns.add<NarrowAddPattern<SAddU64Op, SAddU64U32Op>,
               NarrowAddPattern<VAddU64Op, VAddU64U32Op>>(func.getContext(),
                                                          solver);
  DataFlowListener listener(solver);
  return applyPatternsGreedily(
      func, std::move(patterns),
      GreedyRewriteConfig()
          .enableFolding(false)
          .setRegionSimplificationLevel(GreedySimplifyRegionLevel::Disabled)
          .setListener(&listener));
}

struct WaveAMDNarrowWideIntPass
    : public wave::impl::WaveAMDNarrowWideIntBase<WaveAMDNarrowWideIntPass> {
  void runOnOperation() override {
    WalkResult result = getOperation()->walk([&](func::FuncOp func) {
      if (failed(runOnFunc(func)))
        return WalkResult::interrupt();
      return WalkResult::advance();
    });
    if (result.wasInterrupted())
      return signalPassFailure();
  }
};

} // namespace
