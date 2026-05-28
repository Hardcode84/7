//===- WaveCompileKernels.cpp - GPU-module ISA assembly + lld --*- C++ -*-===//
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
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachineTarget.h"
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
    auto target = parent->getAttrOfType<StringAttr>("waveamdmachine.target");
    if (!target) {
      parent.emitError("wave-compile-kernels requires a "
                       "`waveamdmachine.target` module attribute");
      return signalPassFailure();
    }
    FailureOr<waveamdmachine::AMDGPUTarget> parsed =
        waveamdmachine::parseAMDGPUTargetAttr(
            target.getValue(), [&]() { return parent.emitError(); });
    if (failed(parsed))
      return signalPassFailure();

    SmallVector<gpu::GPUModuleOp> targets;
    parent.walk([&](gpu::GPUModuleOp mod) {
      for (auto func : mod.getOps<func::FuncOp>()) {
        if (func->hasAttr(wave::WaveDialect::getKernelAttrName())) {
          targets.push_back(mod);
          break;
        }
      }
    });

    for (gpu::GPUModuleOp gpuMod : targets) {
      if (failed(compileOne(gpuMod, target.getValue(), parsed->triple,
                            parsed->chip)))
        return signalPassFailure();
    }
  }

private:
  LogicalResult compileOne(gpu::GPUModuleOp gpuMod, StringRef targetAttrValue,
                           StringRef triple, StringRef chip) {
    Location loc = gpuMod.getLoc();
    MLIRContext *ctx = &getContext();
    Builder b(ctx);

    // Already-lowered WaveAMDMachine IR lives inside `gpuMod`. Pull the
    // funcs into a fresh top-level module so the ISA emitter sees the
    // shape it expects (`builtin.module` + `func.func`s with the target
    // attribute on the parent).
    OwningOpRef<ModuleOp> stagingRef(ModuleOp::create(loc));
    ModuleOp staging = *stagingRef;
    staging->setAttr("waveamdmachine.target", b.getStringAttr(targetAttrValue));
    for (auto func : gpuMod.getOps<func::FuncOp>())
      staging.getBody()->push_back(func.clone().getOperation());

    SmallVector<char, 0> hsaco;
    if (failed(wave::assembleWaveAMDGPUKernels(staging.getOperation(), triple,
                                               chip, features, hsaco)))
      return gpuMod.emitError("in-process wave-to-HSACO compilation failed for "
                              "`gpu.module @")
             << gpuMod.getSymName() << "`";

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
