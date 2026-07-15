//===- WaveAMDClearRegAllocTransformState.cpp - Drop planning state -------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "WaveAMDRegAllocTransformState.h"

#include "mlir/Dialect/Wave/Transforms/Passes.h"

namespace mlir::wave {
#define GEN_PASS_DEF_WAVEAMDCLEARREGALLOCTRANSFORMSTATE
#include "mlir/Dialect/Wave/Transforms/Passes.h.inc"
} // namespace mlir::wave

using namespace mlir;

namespace {

struct WaveAMDClearRegAllocTransformStatePass
    : public wave::impl::WaveAMDClearRegAllocTransformStateBase<
          WaveAMDClearRegAllocTransformStatePass> {
  using WaveAMDClearRegAllocTransformStateBase::
      WaveAMDClearRegAllocTransformStateBase;

  void runOnOperation() override {
    wave::clearRegAllocTransformState(getOperation());
  }
};

} // namespace
