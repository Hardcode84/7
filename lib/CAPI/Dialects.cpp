//===- Dialects.cpp - CAPI for Wave dialects ------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "Wave-c/Dialects.h"

#include "ixsimpl.h"
#include "mlir/CAPI/IR.h"
#include "mlir/CAPI/Registration.h"
#include "mlir/CAPI/Support.h"
#include "mlir/CAPI/Wrap.h"
#include "mlir/Dialect/Wave/IR/Wave.h"
#include "mlir/Dialect/Wave/IR/WaveAMD.h"
#include "mlir/Dialect/Wave/IR/WaveSymbols.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachine.h"
#include "llvm/ADT/StringRef.h"

#include <cstring>

using namespace mlir;

MLIR_DEFINE_CAPI_DIALECT_REGISTRATION(Wave, wave, mlir::wave::WaveDialect)
MLIR_DEFINE_CAPI_DIALECT_REGISTRATION(WaveAMD, waveamd,
                                      mlir::waveamd::WaveAMDDialect)
MLIR_DEFINE_CAPI_DIALECT_REGISTRATION(
    WaveAMDMachine, waveamdmachine, mlir::waveamdmachine::WaveAMDMachineDialect)

//===----------------------------------------------------------------------===//
// Wave types
//===----------------------------------------------------------------------===//

bool mlirWaveTypeIsASimd(MlirType type) {
  return llvm::isa<wave::SimdType>(unwrap(type));
}

MlirType mlirWaveSimdTypeGet(MlirType elementType, int64_t width) {
  Type elt = unwrap(elementType);
  return wrap(wave::SimdType::get(elt.getContext(), elt, width));
}

MlirType mlirWaveSimdTypeGetElementType(MlirType type) {
  return wrap(llvm::cast<wave::SimdType>(unwrap(type)).getElementType());
}

int64_t mlirWaveSimdTypeGetWidth(MlirType type) {
  return llvm::cast<wave::SimdType>(unwrap(type)).getWidth();
}

bool mlirWaveTypeIsAMask(MlirType type) {
  return llvm::isa<wave::MaskType>(unwrap(type));
}

MlirType mlirWaveMaskTypeGet(MlirContext ctx, int64_t width) {
  return wrap(wave::MaskType::get(unwrap(ctx), width));
}

int64_t mlirWaveMaskTypeGetWidth(MlirType type) {
  return llvm::cast<wave::MaskType>(unwrap(type)).getWidth();
}

bool mlirWaveTypeIsAMemToken(MlirType type) {
  return llvm::isa<wave::MemTokenType>(unwrap(type));
}

MlirType mlirWaveMemTokenTypeGet(MlirContext ctx) {
  return wrap(wave::MemTokenType::get(unwrap(ctx)));
}

bool mlirWaveTypeIsAPtr(MlirType type) {
  return llvm::isa<wave::PtrType>(unwrap(type));
}

MlirType mlirWavePtrTypeGet(MlirType elementType, MlirAttribute addressSpace) {
  Type elt = unwrap(elementType);
  return wrap(wave::PtrType::get(elt.getContext(), elt, unwrap(addressSpace)));
}

MlirType mlirWavePtrTypeGetElementType(MlirType type) {
  return wrap(llvm::cast<wave::PtrType>(unwrap(type)).getElementType());
}

MlirAttribute mlirWavePtrTypeGetAddressSpace(MlirType type) {
  return wrap(llvm::cast<wave::PtrType>(unwrap(type)).getAddressSpace());
}

bool mlirWaveTypeIsAWaveIndex(MlirType type) {
  return llvm::isa<wave::WaveIndexType>(unwrap(type));
}

MlirType mlirWaveWaveIndexTypeGet(MlirContext ctx, int64_t width) {
  return wrap(wave::WaveIndexType::get(unwrap(ctx), width));
}

int64_t mlirWaveWaveIndexTypeGetWidth(MlirType type) {
  return llvm::cast<wave::WaveIndexType>(unwrap(type)).getWidth();
}

//===----------------------------------------------------------------------===//
// Wave symbolic-expression attribute
//===----------------------------------------------------------------------===//

bool mlirWaveAttributeIsAExpr(MlirAttribute attr) {
  return llvm::isa<wave::ExprAttr>(unwrap(attr));
}

MlirAttribute mlirWaveExprAttrGetFromText(MlirContext ctx, MlirStringRef text) {
  MLIRContext *context = unwrap(ctx);
  // getOrLoad so the call is safe from Python before any other Wave op has
  // forced the dialect to load.
  auto *dialect = context->getOrLoadDialect<wave::WaveDialect>();
  if (!dialect)
    return MlirAttribute{nullptr};
  std::string diagnostic;
  auto handle = wave::sym::parseExpr(dialect->getSymbolStore(),
                                     llvm::StringRef(text.data, text.length),
                                     &diagnostic);
  if (failed(handle)) {
    emitError(UnknownLoc::get(context))
        << "failed to parse wave.expr text: " << diagnostic;
    return MlirAttribute{nullptr};
  }
  return wrap(wave::ExprAttr::get(context, *handle));
}

namespace {
struct BufferReaderState {
  const uint8_t *data;
  size_t length;
  size_t pos;
};

bool bufferReaderRead(void *userdata, void *buf, size_t len) {
  auto *state = static_cast<BufferReaderState *>(userdata);
  if (state->pos + len > state->length)
    return false;
  std::memcpy(buf, state->data + state->pos, len);
  state->pos += len;
  return true;
}

size_t bufferReaderRemaining(void *userdata) {
  auto *state = static_cast<BufferReaderState *>(userdata);
  return state->length - state->pos;
}
} // namespace

MlirAttribute mlirWaveExprAttrGetFromBytes(MlirContext ctx,
                                           const uint8_t *bytes,
                                           size_t length) {
  MLIRContext *context = unwrap(ctx);
  auto *dialect = context->getOrLoadDialect<wave::WaveDialect>();
  if (!dialect)
    return MlirAttribute{nullptr};
  BufferReaderState state{bytes, length, 0};
  ixs_reader reader{bufferReaderRead, bufferReaderRemaining, &state};
  wave::sym::Store &store = dialect->getSymbolStore();
  wave::sym::Session session(store);
  ixs_node *node = ixs_deserialize_node(session.raw(), &reader);
  if (!node || ixs_node_tag(node) == IXS_PARSE_ERROR) {
    emitError(UnknownLoc::get(context))
        << "failed to deserialize wave.expr bytes";
    return MlirAttribute{nullptr};
  }
  std::string diagnostic;
  auto handle = wave::sym::importExpr(store, node, &diagnostic);
  if (failed(handle)) {
    emitError(UnknownLoc::get(context))
        << "failed to materialize wave.expr from bytes: " << diagnostic;
    return MlirAttribute{nullptr};
  }
  return wrap(wave::ExprAttr::get(context, *handle));
}

//===----------------------------------------------------------------------===//
// Wave address-space attributes
//===----------------------------------------------------------------------===//

bool mlirWaveAttributeIsAGlobalAddressSpace(MlirAttribute attr) {
  return llvm::isa<wave::GlobalAddressSpaceAttr>(unwrap(attr));
}

MlirAttribute mlirWaveGlobalAddressSpaceAttrGet(MlirContext ctx) {
  return wrap(wave::GlobalAddressSpaceAttr::get(unwrap(ctx)));
}

bool mlirWaveAttributeIsASharedAddressSpace(MlirAttribute attr) {
  return llvm::isa<wave::SharedAddressSpaceAttr>(unwrap(attr));
}

MlirAttribute mlirWaveSharedAddressSpaceAttrGet(MlirContext ctx) {
  return wrap(wave::SharedAddressSpaceAttr::get(unwrap(ctx)));
}

bool mlirWaveAttributeIsAPrivateAddressSpace(MlirAttribute attr) {
  return llvm::isa<wave::PrivateAddressSpaceAttr>(unwrap(attr));
}

MlirAttribute mlirWavePrivateAddressSpaceAttrGet(MlirContext ctx) {
  return wrap(wave::PrivateAddressSpaceAttr::get(unwrap(ctx)));
}

//===----------------------------------------------------------------------===//
// WaveAMD types and attributes
//===----------------------------------------------------------------------===//

bool mlirWaveAMDTypeIsAFragment(MlirType type) {
  return llvm::isa<waveamd::FragmentType>(unwrap(type));
}

MlirType mlirWaveAMDFragmentTypeGet(MlirContext ctx, int64_t role,
                                    MlirType elementType, int64_t rows,
                                    int64_t columns, int64_t waveSize,
                                    int64_t registers) {
  return wrap(waveamd::FragmentType::get(unwrap(ctx), role, unwrap(elementType),
                                         rows, columns, waveSize, registers));
}

int64_t mlirWaveAMDFragmentTypeGetRole(MlirType type) {
  return llvm::cast<waveamd::FragmentType>(unwrap(type)).getRole();
}

MlirType mlirWaveAMDFragmentTypeGetElementType(MlirType type) {
  return wrap(llvm::cast<waveamd::FragmentType>(unwrap(type)).getElementType());
}

int64_t mlirWaveAMDFragmentTypeGetRows(MlirType type) {
  return llvm::cast<waveamd::FragmentType>(unwrap(type)).getRows();
}

int64_t mlirWaveAMDFragmentTypeGetColumns(MlirType type) {
  return llvm::cast<waveamd::FragmentType>(unwrap(type)).getColumns();
}

int64_t mlirWaveAMDFragmentTypeGetWaveSize(MlirType type) {
  return llvm::cast<waveamd::FragmentType>(unwrap(type)).getWaveSize();
}

int64_t mlirWaveAMDFragmentTypeGetRegisters(MlirType type) {
  return llvm::cast<waveamd::FragmentType>(unwrap(type)).getRegisters();
}

bool mlirWaveAMDAttributeIsABufferAddressSpace(MlirAttribute attr) {
  return llvm::isa<waveamd::BufferAddressSpaceAttr>(unwrap(attr));
}

MlirAttribute mlirWaveAMDBufferAddressSpaceAttrGet(MlirContext ctx) {
  return wrap(waveamd::BufferAddressSpaceAttr::get(unwrap(ctx)));
}
