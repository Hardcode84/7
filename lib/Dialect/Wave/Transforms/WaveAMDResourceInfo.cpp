//===- WaveAMDResourceInfo.cpp - WaveAMD resource info ----------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/Wave/Transforms/Passes.h"

#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/WaveMachine/IR/WaveMachine.h"
#include "mlir/IR/Builders.h"
#include "mlir/IR/BuiltinOps.h"

namespace mlir::wave {
#define GEN_PASS_DEF_WAVEAMDRESOURCEINFO
#include "mlir/Dialect/Wave/Transforms/Passes.h.inc"
} // namespace mlir::wave

using namespace mlir;

namespace {

static bool isSGPR(wavemachine::RegType type) {
  return type.getRegClass() == wavemachine::RegClass::SGPR;
}

static bool isVGPR(wavemachine::RegType type) {
  return type.getRegClass() == wavemachine::RegClass::VGPR;
}

struct WaveAMDResourceInfoPass
    : public wave::impl::WaveAMDResourceInfoBase<WaveAMDResourceInfoPass> {
  // Walk a kernel func's allocated WaveMachine register results and
  // return the highest end-of-register for each class. Sets `failed` if
  // any result still has an unallocated `-1` index.
  struct MaxRegs {
    unsigned sgpr;
    unsigned vgpr;
  };
  MaxRegs collectMaxRegs(func::FuncOp func, bool &failed) {
    bool isKernel = func->hasAttr("wave.kernel");
    MaxRegs out{isKernel ? 5u : 0u, isKernel ? 1u : 0u};
    for (Operation &op : func.getBody().front()) {
      if (op.getNumResults() == 0)
        continue;
      auto regType = dyn_cast<wavemachine::RegType>(op.getResult(0).getType());
      if (!regType)
        continue;
      int64_t index = regType.getIndex();
      if (index < 0) {
        op.emitError(
            "waveamd-resource-info requires allocated register results");
        failed = true;
        return out;
      }
      unsigned end = index + regType.getWidth();
      if (isSGPR(regType))
        out.sgpr = std::max(out.sgpr, end);
      if (isVGPR(regType))
        out.vgpr = std::max(out.vgpr, end);
    }
    return out;
  }

  void runOnOperation() override {
    OpBuilder builder(getOperation().getContext());
    for (func::FuncOp func : getOperation().getOps<func::FuncOp>()) {
      bool failed = false;
      MaxRegs regs = collectMaxRegs(func, failed);
      if (failed)
        return signalPassFailure();
      unsigned sgprBaseline = func->hasAttr("wave.kernel") ? 6u : 1u;
      func->setAttr(
          "wavemachine.sgpr_count",
          builder.getI64IntegerAttr(std::max(regs.sgpr, sgprBaseline)));
      func->setAttr("wavemachine.vgpr_count",
                    builder.getI64IntegerAttr(std::max(regs.vgpr, 1u)));
    }
  }
};

} // namespace
