//===- WaveLowerTokenSelects.cpp - lower token selects ----------*- C++ -*-===//
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

#include <array>

namespace mlir::wave {
#define GEN_PASS_DEF_WAVELOWERTOKENSELECTS
#include "mlir/Dialect/Wave/Transforms/Passes.h.inc"
} // namespace mlir::wave

using namespace mlir;
using namespace mlir::wave;

namespace {

struct WaveLowerTokenSelectsPass
    : public wave::impl::WaveLowerTokenSelectsBase<WaveLowerTokenSelectsPass> {
  void runOnOperation() override {
    SmallVector<Operation *> selects;
    getOperation()->walk([&](Operation *select) {
      if (isa<SelectOp, arith::SelectOp>(select) &&
          isa<MemTokenType>(select->getResult(0).getType()))
        selects.push_back(select);
    });

    IRRewriter rewriter(&getContext());
    for (Operation *select : selects) {
      rewriter.setInsertionPoint(select);
      std::array<Value, 2> dependencies{select->getOperand(1),
                                        select->getOperand(2)};
      JoinOp join =
          JoinOp::create(rewriter, select->getLoc(),
                         select->getResult(0).getType(), dependencies);
      rewriter.replaceOp(select, join.getResult());
    }
  }
};

} // namespace
