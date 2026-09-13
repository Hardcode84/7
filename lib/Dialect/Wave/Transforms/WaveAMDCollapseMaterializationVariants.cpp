//===- WaveAMDCollapseMaterializationVariants.cpp - Select candidates
//-------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM-exception.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/Wave/Transforms/Passes.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachine.h"
#include "mlir/IR/PatternMatch.h"

namespace mlir::wave {
#define GEN_PASS_DEF_WAVEAMDCOLLAPSEMATERIALIZATIONVARIANTS
#include "mlir/Dialect/Wave/Transforms/Passes.h.inc"
} // namespace mlir::wave

using namespace mlir;
using namespace mlir::waveamdmachine;

namespace {
struct WaveAMDCollapseMaterializationVariantsPass
    : wave::impl::WaveAMDCollapseMaterializationVariantsBase<
          WaveAMDCollapseMaterializationVariantsPass> {
  void runOnOperation() override {
    SmallVector<std::pair<MaterializationCandidatesOp, Block *>> winners;
    WalkResult result =
        getOperation()->walk([&](MaterializationCandidatesOp op) {
          Block *winner = nullptr;
          int64_t bestCycles = 0;
          for (Region &region : op.getCandidates()) {
            Block &body = region.front();
            auto yield = cast<CandidateYieldOp>(body.getTerminator());
            std::optional<int64_t> cycles = yield.getCycles();
            if (!cycles) {
              yield.emitOpError(
                  "requires a cycle score before candidate collapse");
              return WalkResult::interrupt();
            }
            if (!winner || *cycles < bestCycles) {
              winner = &body;
              bestCycles = *cycles;
            }
          }
          winners.emplace_back(op, winner);
          return WalkResult::advance();
        });
    if (result.wasInterrupted())
      return signalPassFailure();

    IRRewriter rewriter(&getContext());
    for (auto [op, winner] : winners) {
      auto yield = cast<CandidateYieldOp>(winner->getTerminator());
      rewriter.inlineBlockBefore(winner, op, op.getInputs());
      SmallVector<Value> values(yield.getValues());
      rewriter.eraseOp(yield);
      rewriter.replaceOp(op, values);
    }
  }
};
} // namespace
