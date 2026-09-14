//===- WaveAMDPostScheduleIntCanonicalize.cpp ------------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/Wave/Transforms/Passes.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachine.h"
#include "mlir/IR/PatternMatch.h"
#include "llvm/ADT/SmallVector.h"

namespace mlir::wave {
#define GEN_PASS_DEF_WAVEAMDPOSTSCHEDULEINTCANONICALIZE
#include "mlir/Dialect/Wave/Transforms/Passes.h.inc"
} // namespace mlir::wave

using namespace mlir;
using namespace mlir::wave;
using namespace mlir::waveamdmachine;

namespace {

static std::optional<int64_t> getImm(Value value) {
  if (auto imm = value.getDefiningOp<ImmOp>())
    return imm.getValue();
  return std::nullopt;
}

static Value matchAddOne(SAddI32Op add) {
  if (!add || !add.getResult().hasOneUse() || !add.getScc().use_empty())
    return {};
  if (getImm(add.getLhs()) == 1)
    return add.getRhs();
  if (getImm(add.getRhs()) == 1)
    return add.getLhs();
  return {};
}

static Value matchBitwiseNot(Value value) {
  auto bitwiseNot = value.getDefiningOp<SXorB32Op>();
  if (!bitwiseNot || !bitwiseNot.getResult().hasOneUse() ||
      !bitwiseNot.getScc().use_empty())
    return {};
  if (getImm(bitwiseNot.getLhs()) == -1)
    return bitwiseNot.getRhs();
  if (getImm(bitwiseNot.getRhs()) == -1)
    return bitwiseNot.getLhs();
  return {};
}

static bool contractSubtraction(IRRewriter &rewriter, SAddI32Op outer) {
  if (!outer.getScc().use_empty())
    return false;

  SAddI32Op negate;
  Value lhs;
  if ((negate = outer.getLhs().getDefiningOp<SAddI32Op>()))
    lhs = outer.getRhs();
  else if ((negate = outer.getRhs().getDefiningOp<SAddI32Op>()))
    lhs = outer.getLhs();
  else
    return false;

  Value inverted = matchAddOne(negate);
  if (!inverted)
    return false;
  Value rhs = matchBitwiseNot(inverted);
  if (!rhs)
    return false;

  rewriter.setInsertionPoint(outer);
  auto sub =
      SSubI32Op::create(rewriter, outer.getLoc(), outer.getResult().getType(),
                        outer.getScc().getType(), lhs, rhs);
  sub->setAttrs(outer->getAttrs());
  rewriter.replaceAllUsesWith(outer.getResult(), sub.getResult());
  rewriter.eraseOp(outer);
  rewriter.eraseOp(negate);
  rewriter.eraseOp(inverted.getDefiningOp());
  return true;
}

struct WaveAMDPostScheduleIntCanonicalizePass
    : public wave::impl::WaveAMDPostScheduleIntCanonicalizeBase<
          WaveAMDPostScheduleIntCanonicalizePass> {
  void runOnOperation() override {
    IRRewriter rewriter(&getContext());
    getOperation()->walk([&](func::FuncOp func) {
      SmallVector<SAddI32Op> adds;
      func.walk([&](SAddI32Op add) { adds.push_back(add); });
      for (SAddI32Op add : adds)
        contractSubtraction(rewriter, add);
    });
  }
};

} // namespace
