//===- WaveCompileKernels.cpp - In-process Wave -> HSACO splice
//------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/Wave/Transforms/Passes.h"

#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/GPU/IR/CompilationInterfaces.h"
#include "mlir/Dialect/GPU/IR/GPUDialect.h"
#include "mlir/Dialect/LLVMIR/ROCDLDialect.h"
#include "mlir/IR/Builders.h"
#include "mlir/IR/BuiltinOps.h"
#include "mlir/IR/OwningOpRef.h"
#include "mlir/Target/Wave/AMDGPU.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/ADT/StringRef.h"

namespace mlir::wave {
#define GEN_PASS_DEF_WAVECOMPILEKERNELS
#include "mlir/Dialect/Wave/Transforms/Passes.h.inc"
} // namespace mlir::wave

using namespace mlir;
using namespace mlir::wave;

namespace {

struct WaveCompileKernelsPass
    : public wave::impl::WaveCompileKernelsBase<WaveCompileKernelsPass> {
  using Base::Base;

  void runOnOperation() override {
    ModuleOp parent = getOperation();
    SmallVector<gpu::GPUModuleOp> targets;
    parent.walk([&](gpu::GPUModuleOp mod) {
      for (auto func : mod.getOps<func::FuncOp>()) {
        if (func->hasAttr("wave.kernel")) {
          targets.push_back(mod);
          break;
        }
      }
    });

    for (gpu::GPUModuleOp target : targets) {
      if (failed(compileOne(target)))
        return signalPassFailure();
    }
  }

private:
  LogicalResult compileOne(gpu::GPUModuleOp gpuMod) {
    Location loc = gpuMod.getLoc();
    MLIRContext *ctx = &getContext();

    // 1. Build a transient top-level module that the wave-to-AMDGPU pipeline
    //    can consume: it expects a `builtin.module` with a
    //    `waveamdmachine.target` attribute and `func.func` operations annotated
    //    with `wave.kernel`.
    Builder b(ctx);
    std::string wmTarget = (StringRef(triple) + "--" + StringRef(chip)).str();
    OwningOpRef<ModuleOp> stagingRef(ModuleOp::create(loc));
    ModuleOp staging = *stagingRef;
    staging->setAttr("waveamdmachine.target", b.getStringAttr(wmTarget));

    for (auto func : gpuMod.getOps<func::FuncOp>())
      staging.getBody()->push_back(func.clone().getOperation());

    // 2. Drive the wave-to-AMDGPU translate pipeline + assemble + link
    //    entirely in-process.
    SmallVector<char, 0> hsaco;
    if (failed(wave::compileWaveToHSACO(staging.getOperation(), triple, chip,
                                        features, pipelineFile, hsaco)))
      return gpuMod.emitError("in-process wave-to-HSACO compilation failed for "
                              "`gpu.module @")
             << gpuMod.getSymName() << "`";

    // 3. Replace `gpu.module @X` with a `gpu.binary @X [#gpu.object<...>]`
    //    that carries the freshly produced HSACO.
    OpBuilder builder(gpuMod);
    auto binaryAttr =
        builder.getStringAttr(StringRef(hsaco.data(), hsaco.size()));
    auto rocdlTarget = ROCDL::ROCDLTargetAttr::get(
        ctx, /*O=*/3, builder.getStringAttr(triple),
        builder.getStringAttr(chip),
        /*features=*/builder.getStringAttr(features),
        /*abi=*/builder.getStringAttr("600"),
        /*flags=*/DictionaryAttr(),
        /*link=*/ArrayAttr());
    auto object = gpu::ObjectAttr::get(
        ctx, rocdlTarget, gpu::CompilationTarget::Binary, binaryAttr,
        /*properties=*/DictionaryAttr(),
        /*kernels=*/gpu::KernelTableAttr());
    auto objects = builder.getArrayAttr({object});
    StringAttr symName = gpuMod.getSymNameAttr();

    builder.setInsertionPoint(gpuMod);
    gpu::BinaryOp::create(builder, loc, symName,
                          /*offloadingHandler=*/Attribute(), objects);
    gpuMod.erase();
    return success();
  }
};

} // namespace
