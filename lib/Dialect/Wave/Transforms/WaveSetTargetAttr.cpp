//===- WaveSetTargetAttr.cpp - Stamp waveamdmachine.target -----*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/Wave/Transforms/Passes.h"

#include "mlir/IR/Builders.h"
#include "mlir/IR/BuiltinOps.h"
#include "llvm/ADT/Twine.h"

namespace mlir::wave {
#define GEN_PASS_DEF_WAVESETTARGETATTR
#include "mlir/Dialect/Wave/Transforms/Passes.h.inc"
} // namespace mlir::wave

using namespace mlir;

namespace {

struct WaveSetTargetAttrPass
    : public wave::impl::WaveSetTargetAttrBase<WaveSetTargetAttrPass> {
  using Base::Base;

  void runOnOperation() override {
    ModuleOp module = getOperation();
    if (module->hasAttr("waveamdmachine.target"))
      return;
    Builder b(module.getContext());
    module->setAttr("waveamdmachine.target",
                    b.getStringAttr((Twine(triple) + "--" + chip).str()));
  }
};

} // namespace
