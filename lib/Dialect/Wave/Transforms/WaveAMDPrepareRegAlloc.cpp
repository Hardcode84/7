//===- WaveAMDPrepareRegAlloc.cpp - Expose allocation copies ---*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "RegAlloc/WaveAMDRegAllocPrep.h"

#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/Wave/Transforms/Passes.h"

namespace mlir::wave {
#define GEN_PASS_DEF_WAVEAMDPREPAREREGALLOC
#include "mlir/Dialect/Wave/Transforms/Passes.h.inc"
} // namespace mlir::wave

using namespace mlir;

namespace {

struct WaveAMDPrepareRegAllocPass
    : public wave::impl::WaveAMDPrepareRegAllocBase<
          WaveAMDPrepareRegAllocPass> {
  void runOnOperation() override {
    WalkResult result = getOperation()->walk([&](func::FuncOp func) {
      return failed(wave::prepareWaveAMDRegAllocIR(func))
                 ? WalkResult::interrupt()
                 : WalkResult::advance();
    });
    if (result.wasInterrupted())
      return signalPassFailure();
  }
};

} // namespace
