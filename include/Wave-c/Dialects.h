//===- Dialects.h - CAPI for Wave dialects ------------------------*- C -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef WAVE_C_DIALECTS_H
#define WAVE_C_DIALECTS_H

#include "mlir-c/IR.h"

#ifdef __cplusplus
extern "C" {
#endif

MLIR_DECLARE_CAPI_DIALECT_REGISTRATION(Wave, wave);
MLIR_DECLARE_CAPI_DIALECT_REGISTRATION(WaveAMD, waveamd);
MLIR_DECLARE_CAPI_DIALECT_REGISTRATION(WaveMachine, wavemachine);

#ifdef __cplusplus
}
#endif

#endif // WAVE_C_DIALECTS_H
