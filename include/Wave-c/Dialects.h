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

#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

MLIR_DECLARE_CAPI_DIALECT_REGISTRATION(Wave, wave);
MLIR_DECLARE_CAPI_DIALECT_REGISTRATION(WaveAMD, waveamd);
MLIR_DECLARE_CAPI_DIALECT_REGISTRATION(WaveAMDMachine, waveamdmachine);
MLIR_DECLARE_CAPI_DIALECT_REGISTRATION(WaveMeta, wavemeta);

// Register all wave-owned MLIR passes with the global pass registry so
// `PassManager.parse(...)` from Python can name them. Idempotent.
MLIR_CAPI_EXPORTED void mlirRegisterWavePasses(void);

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
MLIR_CAPI_EXPORTED MlirType
mlirWavePtrTypeGetOpaque(MlirContext ctx, MlirAttribute addressSpace);
MLIR_CAPI_EXPORTED bool mlirWavePtrTypeHasElementType(MlirType type);
MLIR_CAPI_EXPORTED MlirType mlirWavePtrTypeGetElementType(MlirType type);
MLIR_CAPI_EXPORTED MlirAttribute mlirWavePtrTypeGetAddressSpace(MlirType type);

//===----------------------------------------------------------------------===//
// Wave symbolic attributes
//===----------------------------------------------------------------------===//

// Returns a #wave.expr attribute parsed from `text`. On parse failure
// emits a diagnostic on the context and returns a null MlirAttribute.
// Note: the dialect-owned symbol store hash-conses the underlying node,
// so equal texts return pointer-equal handles.
MLIR_CAPI_EXPORTED bool mlirWaveAttributeIsAExpr(MlirAttribute attr);
MLIR_CAPI_EXPORTED MlirAttribute
mlirWaveExprAttrGetFromText(MlirContext ctx, MlirStringRef text);

// Import a live process-local ixsimpl node pointer into the dialect store.
MLIR_CAPI_EXPORTED MlirAttribute
mlirWaveExprAttrGetFromNodePtr(MlirContext ctx, uintptr_t nodePtr);

// Build from ixsimpl's stable binary serialization.
MLIR_CAPI_EXPORTED MlirAttribute mlirWaveExprAttrGetFromBytes(
    MlirContext ctx, const uint8_t *bytes, size_t length);

MLIR_CAPI_EXPORTED bool mlirWaveAttributeIsAPred(MlirAttribute attr);
MLIR_CAPI_EXPORTED MlirAttribute
mlirWavePredAttrGetFromText(MlirContext ctx, MlirStringRef text);
MLIR_CAPI_EXPORTED MlirAttribute
mlirWavePredAttrGetFromNodePtr(MlirContext ctx, uintptr_t nodePtr);
MLIR_CAPI_EXPORTED MlirAttribute mlirWavePredAttrGetFromBytes(
    MlirContext ctx, const uint8_t *bytes, size_t length);

MLIR_CAPI_EXPORTED bool mlirWaveAttributeIsARedistribution(MlirAttribute attr);
MLIR_CAPI_EXPORTED MlirAttribute mlirWaveRedistributionAttrGet(
    int64_t items, MlirAttribute sourceItem, MlirAttribute sourceSlot);
MLIR_CAPI_EXPORTED int64_t
mlirWaveRedistributionAttrGetItems(MlirAttribute attr);
MLIR_CAPI_EXPORTED MlirAttribute
mlirWaveRedistributionAttrGetSourceItem(MlirAttribute attr);
MLIR_CAPI_EXPORTED MlirAttribute
mlirWaveRedistributionAttrGetSourceSlot(MlirAttribute attr);

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
MLIR_CAPI_EXPORTED bool mlirWaveAMDAttributeIsALoadCache(MlirAttribute attr);
MLIR_CAPI_EXPORTED MlirAttribute mlirWaveAMDLoadCacheAttrGet(MlirContext ctx,
                                                             uint32_t value);
MLIR_CAPI_EXPORTED uint32_t
mlirWaveAMDLoadCacheAttrGetValue(MlirAttribute attr);
MLIR_CAPI_EXPORTED bool mlirWaveAMDAttributeIsAStoreCache(MlirAttribute attr);
MLIR_CAPI_EXPORTED MlirAttribute mlirWaveAMDStoreCacheAttrGet(MlirContext ctx,
                                                              uint32_t value);
MLIR_CAPI_EXPORTED uint32_t
mlirWaveAMDStoreCacheAttrGetValue(MlirAttribute attr);

//===----------------------------------------------------------------------===//
// WaveMeta types
//===----------------------------------------------------------------------===//

// `!wavemeta.ptuple<T, W>` carries N elements of type T. `W` is either an
// `IntegerAttr` (concrete N) or a `StringAttr` (parameter-named width).
MLIR_CAPI_EXPORTED bool mlirWaveMetaTypeIsAPTuple(MlirType type);
MLIR_CAPI_EXPORTED MlirType mlirWaveMetaPTupleTypeGet(MlirType elementType,
                                                      MlirAttribute width);
MLIR_CAPI_EXPORTED MlirType mlirWaveMetaPTupleTypeGetElementType(MlirType type);
MLIR_CAPI_EXPORTED MlirAttribute mlirWaveMetaPTupleTypeGetWidth(MlirType type);

#ifdef __cplusplus
}
#endif

#endif // WAVE_C_DIALECTS_H
