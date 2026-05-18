//===- WaveAttachGPUBinary.cpp - Embed precompiled GPU binary -------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/Wave/Transforms/Passes.h"

#include "mlir/Dialect/GPU/IR/CompilationInterfaces.h"
#include "mlir/Dialect/GPU/IR/GPUDialect.h"
#include "mlir/Dialect/LLVMIR/ROCDLDialect.h"
#include "mlir/IR/Builders.h"
#include "mlir/IR/BuiltinOps.h"
#include "llvm/Support/ErrorOr.h"
#include "llvm/Support/MemoryBuffer.h"

namespace mlir::wave {
#define GEN_PASS_DEF_WAVEATTACHGPUBINARY
#include "mlir/Dialect/Wave/Transforms/Passes.h.inc"
} // namespace mlir::wave

using namespace mlir;
using namespace mlir::wave;

namespace {

struct WaveAttachGPUBinaryPass
    : public wave::impl::WaveAttachGPUBinaryBase<WaveAttachGPUBinaryPass> {
  using Base::Base;

  void runOnOperation() override {
    if (path.empty()) {
      getOperation().emitError(
          "wave-attach-gpu-binary requires `path=` to point at the GPU binary");
      return signalPassFailure();
    }

    auto buffer = llvm::MemoryBuffer::getFile(path);
    if (std::error_code ec = buffer.getError()) {
      getOperation().emitError("failed to read GPU binary at '")
          << path << "': " << ec.message();
      return signalPassFailure();
    }

    ModuleOp module = getOperation();
    OpBuilder builder(module.getBodyRegion());

    StringRef binary = buffer->get()->getBuffer();
    auto binaryAttr = builder.getStringAttr(binary);
    auto chipAttr = builder.getStringAttr(chip);

    // Match the target attr standard GPU binary lowering would produce.
    auto rocdlTarget = ROCDL::ROCDLTargetAttr::get(
        &getContext(), /*O=*/3, builder.getStringAttr(triple), chipAttr,
        /*features=*/builder.getStringAttr(""),
        /*abi=*/builder.getStringAttr("600"),
        /*flags=*/DictionaryAttr(),
        /*link=*/ArrayAttr());

    auto object = gpu::ObjectAttr::get(
        &getContext(), rocdlTarget, gpu::CompilationTarget::Binary, binaryAttr,
        /*properties=*/DictionaryAttr(),
        /*kernels=*/gpu::KernelTableAttr());

    auto objects = builder.getArrayAttr({object});

    // If a stub `gpu.binary @<symbol>` already exists (the typical pattern:
    // declare it with `bin = ""` so `gpu.launch_func` verifies, then attach
    // the real bytes here), rewrite the existing op in place. Otherwise
    // append a fresh one at the end of the module body.
    gpu::BinaryOp existing;
    module.walk([&](gpu::BinaryOp binOp) {
      if (binOp.getSymName() == symbol) {
        existing = binOp;
        return WalkResult::interrupt();
      }
      return WalkResult::advance();
    });
    if (existing) {
      existing.setObjectsAttr(objects);
    } else {
      builder.setInsertionPointToEnd(module.getBody());
      gpu::BinaryOp::create(builder, module.getLoc(), symbol,
                            /*offloadingHandler=*/Attribute(), objects);
    }
  }
};

} // namespace
