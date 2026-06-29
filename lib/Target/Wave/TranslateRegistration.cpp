//===- TranslateRegistration.cpp - Wave backend registration --------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Target/Wave/AMDGPU.h"

#include "mlir/Dialect/Arith/IR/Arith.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/GPU/IR/GPUDialect.h"
#include "mlir/Dialect/UB/IR/UBOps.h"
#include "mlir/Dialect/Wave/IR/Wave.h"
#include "mlir/Dialect/Wave/IR/WaveAMD.h"
#include "mlir/Dialect/Wave/IR/WaveMeta.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachine.h"
#include "mlir/Tools/mlir-translate/Translation.h"

using namespace mlir;

void mlir::wave::registerWaveToAMDGPUTranslation() {
  // Some LLVM installs ship a modified `InitAllTranslations.h` that already
  // invokes this function from inside `mlir::registerAllTranslations()`
  // (notably the wave-dsl branch). Guard against double registration so the
  // standalone tool works against both stock LLVM and such installs.
  static bool registered = false;
  if (registered)
    return;
  registered = true;
  static TranslateFromMLIRRegistration reg(
      "wave-to-amdgpu-asm", "translate Wave dialect directly to AMDGPU ISA",
      [](Operation *op, raw_ostream &output) {
        return wave::translateWaveToAMDGPU(op, output);
      },
      [](DialectRegistry &registry) {
        registry.insert<arith::ArithDialect, func::FuncDialect, gpu::GPUDialect,
                        ub::UBDialect, waveamd::WaveAMDDialect,
                        wave::WaveDialect, wavemeta::WaveMetaDialect,
                        waveamdmachine::WaveAMDMachineDialect>();
      });
}
