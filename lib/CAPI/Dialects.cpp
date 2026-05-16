//===- Dialects.cpp - CAPI for Wave dialects ------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "Wave-c/Dialects.h"

#include "mlir/CAPI/Registration.h"
#include "mlir/Dialect/Wave/IR/Wave.h"
#include "mlir/Dialect/Wave/IR/WaveAMD.h"
#include "mlir/Dialect/WaveMachine/IR/WaveMachine.h"

MLIR_DEFINE_CAPI_DIALECT_REGISTRATION(Wave, wave, mlir::wave::WaveDialect)
MLIR_DEFINE_CAPI_DIALECT_REGISTRATION(WaveAMD, waveamd,
                                      mlir::waveamd::WaveAMDDialect)
MLIR_DEFINE_CAPI_DIALECT_REGISTRATION(WaveMachine, wavemachine,
                                      mlir::wavemachine::WaveMachineDialect)
