//===- WaveAMDMetadata.cpp - WaveAMD metadata -------------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/Wave/Transforms/Passes.h"

#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/Wave/Transforms/WaveAMDRegAllocVerification.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachine.h"
#include "mlir/IR/Builders.h"
#include "mlir/IR/BuiltinOps.h"

namespace mlir::wave {
#define GEN_PASS_DEF_WAVEAMDMETADATA
#include "mlir/Dialect/Wave/Transforms/Passes.h.inc"
} // namespace mlir::wave

using namespace mlir;

namespace {

static ModuleOp findTargetModule(Operation *op) {
  ModuleOp module = op->getParentOfType<ModuleOp>();
  if (!module)
    module = dyn_cast<ModuleOp>(op);
  while (module && !module->hasAttr("waveamdmachine.target"))
    module = module->getParentOfType<ModuleOp>();
  return module;
}

static bool hasKernelMetadataInputs(func::FuncOp func) {
  return func->hasAttr("waveamdmachine.kernarg_size") &&
         func->hasAttr("waveamdmachine.sgpr_count") &&
         func->hasAttr("waveamdmachine.vgpr_count");
}

static LogicalResult initializeKernelMetadata(func::FuncOp func,
                                              Builder &builder) {
  if (failed(wave::failIfWaveAMDRegAllocOverflowed(func, "waveamd-metadata")))
    return failure();
  if (!hasKernelMetadataInputs(func)) {
    func.emitError("waveamd-metadata requires ABI and resource attributes "
                   "on kernels");
    return failure();
  }
  if (failed(waveamdmachine::getKernelMetadataEntries(func)))
    return failure();
  Attribute metadata =
      func->getAttr(waveamdmachine::getKernelMetadataAttrName());
  if (!metadata || isa<UnitAttr>(metadata))
    func->setAttr(waveamdmachine::getKernelMetadataAttrName(),
                  builder.getArrayAttr({}));
  return success();
}

struct WaveAMDMetadataPass
    : public wave::impl::WaveAMDMetadataBase<WaveAMDMetadataPass> {
  void runOnOperation() override {
    Operation *root = getOperation();
    if (!findTargetModule(root)) {
      root->emitError("waveamd-metadata requires a waveamdmachine.target "
                      "module attribute");
      return signalPassFailure();
    }
    OpBuilder builder(root->getContext());
    SmallVector<func::FuncOp> kernels;
    root->walk([&](func::FuncOp f) {
      if (f->hasAttr(wave::WaveDialect::getKernelAttrName()))
        kernels.push_back(f);
    });
    for (func::FuncOp func : kernels)
      if (failed(initializeKernelMetadata(func, builder)))
        return signalPassFailure();
  }
};

} // namespace
