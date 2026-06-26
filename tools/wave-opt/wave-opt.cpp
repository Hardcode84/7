//===- wave-opt.cpp - Wave optimizer driver -----------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/Transform/IR/TransformDialect.h"
#include "mlir/IR/DialectRegistry.h"
#include "mlir/InitAllDialects.h"
#include "mlir/InitAllExtensions.h"
#include "mlir/InitAllPasses.h"
#include "mlir/Tools/mlir-opt/MlirOptMain.h"

#include "mlir/Conversion/WaveToLLVM/WaveToLLVM.h"
#include "mlir/Dialect/Wave/IR/Wave.h"
#include "mlir/Dialect/Wave/IR/WaveAMD.h"
#include "mlir/Dialect/Wave/IR/WaveMeta.h"
#include "mlir/Dialect/Wave/Transforms/Passes.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachine.h"

int main(int argc, char **argv) {
  mlir::DialectRegistry registry;
  mlir::registerAllDialects(registry);
  mlir::registerAllExtensions(registry);
  mlir::registerAllPasses();

  registry.insert<mlir::wave::WaveDialect, mlir::waveamd::WaveAMDDialect,
                  mlir::wavemeta::WaveMetaDialect,
                  mlir::waveamdmachine::WaveAMDMachineDialect>();
  registry.addExtension(
      +[](mlir::MLIRContext *ctx, mlir::transform::TransformDialect *dialect) {
        (void)dialect;
        ctx->getOrLoadDialect<mlir::wave::WaveDialect>();
      });
  mlir::wave::registerWavePasses();
  mlir::wave::registerConvertWaveToLLVMInterface(registry);

  return mlir::asMainReturnCode(
      mlir::MlirOptMain(argc, argv, "Wave optimizer driver\n", registry));
}
