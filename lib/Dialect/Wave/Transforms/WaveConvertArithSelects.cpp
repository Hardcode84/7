//===- WaveConvertArithSelects.cpp - import arith selects -------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/Wave/Transforms/Passes.h"

#include "mlir/Dialect/Arith/IR/Arith.h"
#include "mlir/Dialect/Wave/IR/Wave.h"
#include "mlir/IR/PatternMatch.h"

namespace mlir::wave {
#define GEN_PASS_DEF_WAVECONVERTARITHSELECTS
#include "mlir/Dialect/Wave/Transforms/Passes.h.inc"
} // namespace mlir::wave

using namespace mlir;
using namespace mlir::wave;

namespace {

static bool hasWaveType(Type type) {
  return isa<SimdType, MaskType, MemTokenType, PtrType>(type);
}

struct WaveConvertArithSelectsPass
    : public wave::impl::WaveConvertArithSelectsBase<
          WaveConvertArithSelectsPass> {
  void runOnOperation() override {
    SmallVector<arith::SelectOp> selects;
    getOperation()->walk([&](arith::SelectOp select) {
      if (hasWaveType(select.getType()))
        selects.push_back(select);
    });

    IRRewriter rewriter(&getContext());
    for (arith::SelectOp select : selects) {
      rewriter.setInsertionPoint(select);
      SelectOp replacement = SelectOp::create(
          rewriter, select.getLoc(), select.getType(), select.getCondition(),
          select.getTrueValue(), select.getFalseValue());
      rewriter.replaceOp(select, replacement.getResult());
    }
  }
};

} // namespace
