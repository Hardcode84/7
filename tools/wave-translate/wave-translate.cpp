//===- wave-translate.cpp - Wave translate driver -----------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/InitAllTranslations.h"
#include "mlir/Support/LLVM.h"
#include "mlir/Tools/mlir-translate/MlirTranslateMain.h"

#include "mlir/Target/Wave/AMDGPU.h"

int main(int argc, char **argv) {
  mlir::registerAllTranslations();
  mlir::wave::registerWaveToAMDGPUTranslation();
  return failed(mlir::mlirTranslateMain(argc, argv, "Wave translate driver\n"));
}
