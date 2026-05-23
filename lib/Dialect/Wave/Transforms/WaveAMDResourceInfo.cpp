//===- WaveAMDResourceInfo.cpp - WaveAMD resource info ----------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/Wave/Transforms/Passes.h"

#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachine.h"
#include "mlir/IR/Builders.h"
#include "mlir/IR/BuiltinOps.h"

namespace mlir::wave {
#define GEN_PASS_DEF_WAVEAMDRESOURCEINFO
#include "mlir/Dialect/Wave/Transforms/Passes.h.inc"
} // namespace mlir::wave

using namespace mlir;

namespace {

static bool isSGPR(waveamdmachine::RegType type) {
  return type.getRegClass() == waveamdmachine::RegClass::SGPR;
}

static bool isVGPR(waveamdmachine::RegType type) {
  return type.getRegClass() == waveamdmachine::RegClass::VGPR;
}

struct WaveAMDResourceInfoPass
    : public wave::impl::WaveAMDResourceInfoBase<WaveAMDResourceInfoPass> {
  // Walk a kernel func's allocated WaveAMDMachine register results and
  // return the highest end-of-register for each class. Sets `failed` if
  // any result still has an unallocated `-1` index.
  struct MaxRegs {
    unsigned sgpr;
    unsigned vgpr;
  };
  // Update `out` with the high-water mark of a single result's
  // register footprint. Returns true on a hard error (unallocated
  // index) so the caller can short-circuit the walk.
  bool scanResult(Operation &op, Value result, MaxRegs &out) {
    auto regType = dyn_cast<waveamdmachine::RegType>(result.getType());
    if (!regType)
      return false;
    // SCC is a single global bit; the allocator never assigns
    // physical numbers for it.
    if (regType.getRegClass() == waveamdmachine::RegClass::SCC)
      return false;
    int64_t index = regType.getIndex();
    if (index < 0) {
      op.emitError("waveamd-resource-info requires allocated register results");
      return true;
    }
    unsigned end = index + regType.getWidth();
    if (isSGPR(regType))
      out.sgpr = std::max(out.sgpr, end);
    if (isVGPR(regType))
      out.vgpr = std::max(out.vgpr, end);
    return false;
  }

  void scanOp(Operation &op, MaxRegs &out, bool &failed) {
    for (Value result : op.getResults()) {
      if (scanResult(op, result, out)) {
        failed = true;
        return;
      }
    }
    for (Region &region : op.getRegions()) {
      for (Block &block : region) {
        for (Operation &nested : block) {
          scanOp(nested, out, failed);
          if (failed)
            return;
        }
      }
    }
  }

  MaxRegs collectMaxRegs(func::FuncOp func, bool &failed) {
    bool isKernel = func->hasAttr(wave::WaveDialect::getKernelAttrName());
    MaxRegs out{isKernel ? 5u : 0u, isKernel ? 1u : 0u};
    for (Operation &op : func.getBody().front()) {
      scanOp(op, out, failed);
      if (failed)
        return out;
    }
    return out;
  }

  void runOnOperation() override {
    ModuleOp mod = getOperation();
    OpBuilder builder(mod.getContext());
    SmallVector<func::FuncOp> kernels;
    mod.walk([&](func::FuncOp f) {
      if (!f.isExternal())
        kernels.push_back(f);
    });
    int64_t maxSgpr = 0;
    int64_t maxVgpr = 0;
    int64_t maxLds = 0;
    bool sawKernel = false;
    for (func::FuncOp func : kernels) {
      bool failed = false;
      MaxRegs regs = collectMaxRegs(func, failed);
      if (failed)
        return signalPassFailure();
      bool isKernel = func->hasAttr(wave::WaveDialect::getKernelAttrName());
      unsigned sgprBaseline = isKernel ? 6u : 1u;
      unsigned sgprCount = std::max(regs.sgpr, sgprBaseline);
      unsigned vgprCount = std::max(regs.vgpr, 1u);
      func->setAttr("waveamdmachine.sgpr_count",
                    builder.getI64IntegerAttr(sgprCount));
      func->setAttr("waveamdmachine.vgpr_count",
                    builder.getI64IntegerAttr(vgprCount));
      int64_t lds = 0;
      if (auto ldsAttr = func->getAttrOfType<IntegerAttr>("wave.lds_size")) {
        lds = ldsAttr.getInt();
        func->setAttr("waveamdmachine.lds_size",
                      builder.getI64IntegerAttr(lds));
      }
      if (!isKernel)
        continue;
      sawKernel = true;
      maxSgpr = std::max<int64_t>(maxSgpr, sgprCount);
      maxVgpr = std::max<int64_t>(maxVgpr, vgprCount);
      maxLds = std::max<int64_t>(maxLds, lds);
    }
    if (sawKernel) {
      mod->setAttr("waveamdmachine.sgpr_count_max",
                   builder.getI64IntegerAttr(maxSgpr));
      mod->setAttr("waveamdmachine.vgpr_count_max",
                   builder.getI64IntegerAttr(maxVgpr));
      mod->setAttr("waveamdmachine.lds_size_max",
                   builder.getI64IntegerAttr(maxLds));
    }
  }
};

} // namespace
