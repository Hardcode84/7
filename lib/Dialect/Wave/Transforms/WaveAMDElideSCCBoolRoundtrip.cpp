//===- WaveAMDElideSCCBoolRoundtrip.cpp - SCC bool peephole -----*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/Wave/Transforms/Passes.h"

#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachine.h"
#include "mlir/IR/PatternMatch.h"
#include "mlir/Transforms/GreedyPatternRewriteDriver.h"

namespace mlir::wave {
#define GEN_PASS_DEF_WAVEAMDELIDESCCBOOLROUNDTRIP
#include "mlir/Dialect/Wave/Transforms/Passes.h.inc"
} // namespace mlir::wave

using namespace mlir;
using namespace mlir::waveamdmachine;

namespace {

static std::optional<int64_t> getLocalImmediate(Value value) {
  if (ImmOp imm = value.getDefiningOp<ImmOp>())
    return imm.getValue();
  if (SMovB32ValueOp mov = value.getDefiningOp<SMovB32ValueOp>())
    return getLocalImmediate(mov.getSource());
  return std::nullopt;
}

static bool isLocalImmediate(Value value, int64_t expected) {
  std::optional<int64_t> actual = getLocalImmediate(value);
  return actual && *actual == expected;
}

static bool allResultsDead(Operation *op) {
  for (Value result : op->getResults())
    if (!result.use_empty())
      return false;
  return true;
}

static bool canEraseLocalConstantProducer(Operation *op) {
  return isa<ImmOp, SMovB32ValueOp, SCSelectB32Op>(op);
}

static void eraseDeadLocalProducer(PatternRewriter &rewriter, Operation *op) {
  if (!op || !canEraseLocalConstantProducer(op) || !allResultsDead(op))
    return;

  SmallVector<Value> operands(op->getOperands());
  rewriter.eraseOp(op);
  for (Value operand : operands)
    eraseDeadLocalProducer(rewriter, operand.getDefiningOp());
}

struct SCCBoolRoundtripPattern : public OpRewritePattern<SCmpLgU32Op> {
  using OpRewritePattern<SCmpLgU32Op>::OpRewritePattern;

  LogicalResult matchAndRewrite(SCmpLgU32Op op,
                                PatternRewriter &rewriter) const override {
    Value boolValue = op.getLhs();
    if (!isLocalImmediate(op.getRhs(), 0)) {
      if (!isLocalImmediate(op.getLhs(), 0))
        return failure();
      boolValue = op.getRhs();
    }

    SCSelectB32Op select = boolValue.getDefiningOp<SCSelectB32Op>();
    if (!select || !isLocalImmediate(select.getTrueValue(), 1) ||
        !isLocalImmediate(select.getFalseValue(), 0))
      return failure();

    rewriter.replaceOp(op, select.getCond());
    eraseDeadLocalProducer(rewriter, select);
    return success();
  }
};

static LogicalResult runOnOp(Operation *root) {
  RewritePatternSet patterns(root->getContext());
  patterns.add<SCCBoolRoundtripPattern>(root->getContext());
  return applyPatternsGreedily(
      root, std::move(patterns),
      GreedyRewriteConfig().enableFolding(false).setRegionSimplificationLevel(
          GreedySimplifyRegionLevel::Disabled));
}

struct WaveAMDElideSCCBoolRoundtripPass
    : public wave::impl::WaveAMDElideSCCBoolRoundtripBase<
          WaveAMDElideSCCBoolRoundtripPass> {
  void runOnOperation() override {
    if (failed(runOnOp(getOperation())))
      signalPassFailure();
  }
};

} // namespace
