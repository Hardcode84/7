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

//===----------------------------------------------------------------------===//
// Wave types
//===----------------------------------------------------------------------===//

MLIR_CAPI_EXPORTED bool mlirWaveTypeIsASimd(MlirType type);
MLIR_CAPI_EXPORTED MlirType mlirWaveSimdTypeGet(MlirType elementType,
                                                int64_t width);
MLIR_CAPI_EXPORTED MlirType mlirWaveSimdTypeGetElementType(MlirType type);
MLIR_CAPI_EXPORTED int64_t mlirWaveSimdTypeGetWidth(MlirType type);

MLIR_CAPI_EXPORTED bool mlirWaveTypeIsAMask(MlirType type);
MLIR_CAPI_EXPORTED MlirType mlirWaveMaskTypeGet(MlirContext ctx, int64_t width);
MLIR_CAPI_EXPORTED int64_t mlirWaveMaskTypeGetWidth(MlirType type);

MLIR_CAPI_EXPORTED bool mlirWaveTypeIsAMemToken(MlirType type);
MLIR_CAPI_EXPORTED MlirType mlirWaveMemTokenTypeGet(MlirContext ctx);

MLIR_CAPI_EXPORTED bool mlirWaveTypeIsAPtr(MlirType type);
MLIR_CAPI_EXPORTED MlirType mlirWavePtrTypeGet(MlirType elementType,
                                               MlirAttribute addressSpace);
MLIR_CAPI_EXPORTED MlirType mlirWavePtrTypeGetElementType(MlirType type);
MLIR_CAPI_EXPORTED MlirAttribute mlirWavePtrTypeGetAddressSpace(MlirType type);

//===----------------------------------------------------------------------===//
// Wave address-space attributes
//===----------------------------------------------------------------------===//

MLIR_CAPI_EXPORTED bool
mlirWaveAttributeIsAGlobalAddressSpace(MlirAttribute attr);
MLIR_CAPI_EXPORTED MlirAttribute
mlirWaveGlobalAddressSpaceAttrGet(MlirContext ctx);

MLIR_CAPI_EXPORTED bool
mlirWaveAttributeIsASharedAddressSpace(MlirAttribute attr);
MLIR_CAPI_EXPORTED MlirAttribute
mlirWaveSharedAddressSpaceAttrGet(MlirContext ctx);

MLIR_CAPI_EXPORTED bool
mlirWaveAttributeIsAPrivateAddressSpace(MlirAttribute attr);
MLIR_CAPI_EXPORTED MlirAttribute
mlirWavePrivateAddressSpaceAttrGet(MlirContext ctx);

//===----------------------------------------------------------------------===//
// WaveAMD types and attributes
//===----------------------------------------------------------------------===//

MLIR_CAPI_EXPORTED bool mlirWaveAMDTypeIsAFragment(MlirType type);
MLIR_CAPI_EXPORTED MlirType mlirWaveAMDFragmentTypeGet(
    MlirContext ctx, int64_t role, MlirType elementType, int64_t rows,
    int64_t columns, int64_t waveSize, int64_t registers);
MLIR_CAPI_EXPORTED int64_t mlirWaveAMDFragmentTypeGetRole(MlirType type);
MLIR_CAPI_EXPORTED MlirType
mlirWaveAMDFragmentTypeGetElementType(MlirType type);
MLIR_CAPI_EXPORTED int64_t mlirWaveAMDFragmentTypeGetRows(MlirType type);
MLIR_CAPI_EXPORTED int64_t mlirWaveAMDFragmentTypeGetColumns(MlirType type);
MLIR_CAPI_EXPORTED int64_t mlirWaveAMDFragmentTypeGetWaveSize(MlirType type);
MLIR_CAPI_EXPORTED int64_t mlirWaveAMDFragmentTypeGetRegisters(MlirType type);

MLIR_CAPI_EXPORTED bool
mlirWaveAMDAttributeIsABufferAddressSpace(MlirAttribute attr);
MLIR_CAPI_EXPORTED MlirAttribute
mlirWaveAMDBufferAddressSpaceAttrGet(MlirContext ctx);

#ifdef __cplusplus
}
#endif

#endif // WAVE_C_DIALECTS_H
