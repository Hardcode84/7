//===- WaveMachineLoadStore.cpp - load/store selection -------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// Lower `wave.load` / `wave.store` to the LDS / global / buffer
// wavemachine ops. The pointer's bucketized triple (set by the
// bucketizer at the `wave.index_expr` boundary and stored in the
// selector's sidecars) is routed through `bucketForSpec`, which picks
// V / S / inst-offset slots that fit the address-field spec of the
// concrete machine op.
//
//===----------------------------------------------------------------------===//

#include "WaveMachineSelector.h"

using namespace mlir;
using namespace mlir::wave;
using namespace mlir::waveamd;
using namespace mlir::wave::wmsel;

namespace mlir::wave::wmsel {

namespace {

// Per-lane register count for a wave.load result: 1 for scalar
// results, vector element count for tuple results. The verifier
// guarantees a 32-bit element width, so this maps directly to VGPR
// tuple width.
unsigned loadRegisterCount(SimdType simdType) {
  if (auto vecTy = dyn_cast<VectorType>(simdType.getElementType()))
    return vecTy.getNumElements();
  return 1;
}

// Bind the caller `wave.load` op's value + token to the freshly built
// WaveMachine load and drop the source op.
void bindLoadResults(WaveMachineSelector &S, LoadOp op, Operation *load) {
  S.values[op.getValue()] = load->getResult(0);
  S.values[op.getToken()] = load->getResult(1);
  S.eraseIfTopLevel(op);
}

LogicalResult selectSharedStore(WaveMachineSelector &S, StoreOp op, Value base,
                                OffsetTriple offset, unsigned registers) {
  wavemachine::AddressFieldSpec spec =
      registers == 1 ? wavemachine::DsStoreB32Op::getAddressFieldSpec()
                     : wavemachine::DsStoreTupleB32Op::getAddressFieldSpec();
  auto b = S.bucketForSpec(op.getLoc(), offset, spec);
  Value addr = S.ensureVGPRForVSrc1(
      op.getLoc(), S.addByteOffsets(op.getLoc(), base, b.voffset));
  Value value = S.expect(op.getValue(), op);
  Value dep = op.getDependency() ? S.expect(op.getDependency(), op) : Value{};
  Type tokenType = getMemTokenType(op.getContext());
  Operation *store;
  if (registers == 1)
    store = wavemachine::DsStoreB32Op::create(S.builder, op.getLoc(), tokenType,
                                              addr, value, dep, b.instOffset);
  else
    store = wavemachine::DsStoreTupleB32Op::create(
        S.builder, op.getLoc(), tokenType, addr, value, dep, b.instOffset);
  S.values[op.getToken()] = store->getResult(0);
  S.eraseIfTopLevel(op);
  return success();
}

// Build one scalar or tuple global-or-buffer store; the tuple form
// covers all N dwords in a single op (asm emit expands it).
static Operation *buildOneGlobalOrBufferStore(
    WaveMachineSelector &S, StoreOp op, Value voffset, Value value, Value base,
    bool isBuffer, Value soffset, Value dep, int64_t instOffset, bool isTuple) {
  Type tokenType = getMemTokenType(op.getContext());
  if (isTuple) {
    if (isBuffer)
      return wavemachine::BufferStoreTupleB32Op::create(
          S.builder, op.getLoc(), tokenType, voffset, value, base, soffset, dep,
          instOffset);
    return wavemachine::GlobalStoreTupleB32Op::create(S.builder, op.getLoc(),
                                                      tokenType, voffset, value,
                                                      base, dep, instOffset);
  }
  if (isBuffer)
    return wavemachine::BufferStoreB32Op::create(
        S.builder, op.getLoc(), tokenType, voffset, value, base, soffset, dep,
        instOffset);
  return wavemachine::GlobalStoreB32Op::create(
      S.builder, op.getLoc(), tokenType, voffset, value, base, dep, instOffset);
}

LogicalResult selectGlobalOrBufferStore(WaveMachineSelector &S, StoreOp op,
                                        Value base, OffsetTriple offset,
                                        bool isBuffer, unsigned registers) {
  wavemachine::AddressFieldSpec spec =
      isBuffer ? wavemachine::BufferStoreB32Op::getAddressFieldSpec()
               : wavemachine::GlobalStoreB32Op::getAddressFieldSpec();
  auto b = S.bucketForSpec(op.getLoc(), offset, spec);
  Value value = S.expect(op.getValue(), op);
  Value dep = op.getDependency() ? S.expect(op.getDependency(), op) : Value{};
  Operation *store = buildOneGlobalOrBufferStore(
      S, op, b.voffset, value, base, isBuffer, b.soffset, dep, b.instOffset,
      /*isTuple=*/registers != 1);
  S.values[op.getToken()] = store->getResult(0);
  S.eraseIfTopLevel(op);
  return success();
}

LogicalResult selectSharedLoad(WaveMachineSelector &S, LoadOp op, Value base,
                               OffsetTriple offset, unsigned registers) {
  wavemachine::AddressFieldSpec spec =
      registers == 1 ? wavemachine::DsLoadB32Op::getAddressFieldSpec()
                     : wavemachine::DsLoadTupleB32Op::getAddressFieldSpec();
  auto b = S.bucketForSpec(op.getLoc(), offset, spec);
  Value addr = S.ensureVGPRForVSrc1(
      op.getLoc(), S.addByteOffsets(op.getLoc(), base, b.voffset));
  Value dep = op.getDependency() ? S.expect(op.getDependency(), op) : Value{};
  Type resultType =
      getRegType(op.getContext(), wavemachine::RegClass::VGPR, registers);
  Type tokenType = getMemTokenType(op.getContext());
  Operation *load;
  if (registers == 1)
    load = wavemachine::DsLoadB32Op::create(S.builder, op.getLoc(), resultType,
                                            tokenType, addr, dep, b.instOffset);
  else
    load = wavemachine::DsLoadTupleB32Op::create(
        S.builder, op.getLoc(), resultType, tokenType, addr, dep, b.instOffset);
  bindLoadResults(S, op, load);
  return success();
}

LogicalResult selectGlobalOrBufferLoad(WaveMachineSelector &S, LoadOp op,
                                       Value base, OffsetTriple offset,
                                       bool isBuffer, unsigned registers) {
  wavemachine::AddressFieldSpec spec;
  if (isBuffer)
    spec = registers == 1
               ? wavemachine::BufferLoadB32Op::getAddressFieldSpec()
               : wavemachine::BufferLoadTupleB32Op::getAddressFieldSpec();
  else
    spec = registers == 1
               ? wavemachine::GlobalLoadB32Op::getAddressFieldSpec()
               : wavemachine::GlobalLoadTupleB32Op::getAddressFieldSpec();
  auto b = S.bucketForSpec(op.getLoc(), offset, spec);
  Value dep = op.getDependency() ? S.expect(op.getDependency(), op) : Value{};
  Type resultType =
      getRegType(op.getContext(), wavemachine::RegClass::VGPR, registers);
  Type tokenType = getMemTokenType(op.getContext());
  Operation *load;
  if (isBuffer) {
    if (registers == 1)
      load = wavemachine::BufferLoadB32Op::create(
          S.builder, op.getLoc(), resultType, tokenType, b.voffset, base,
          b.soffset, dep, b.instOffset);
    else
      load = wavemachine::BufferLoadTupleB32Op::create(
          S.builder, op.getLoc(), resultType, tokenType, b.voffset, base,
          b.soffset, dep, b.instOffset);
  } else {
    if (registers == 1)
      load = wavemachine::GlobalLoadB32Op::create(
          S.builder, op.getLoc(), resultType, tokenType, b.voffset, base, dep,
          b.instOffset);
    else
      load = wavemachine::GlobalLoadTupleB32Op::create(
          S.builder, op.getLoc(), resultType, tokenType, b.voffset, base, dep,
          b.instOffset);
  }
  bindLoadResults(S, op, load);
  return success();
}

} // namespace

LogicalResult selectStore(WaveMachineSelector &S, StoreOp op) {
  auto baseIt = S.pointerBases.find(op.getPtr());
  auto offsetIt = S.pointerOffsets.find(op.getPtr());
  auto bufferIt = S.pointerBuffers.find(op.getPtr());
  if (baseIt == S.pointerBases.end() || offsetIt == S.pointerOffsets.end())
    return op.emitError("WaveMachine backend expects selected wave pointer");
  unsigned registers =
      loadRegisterCount(cast<SimdType>(op.getValue().getType()));
  OffsetTriple triple = offsetIt->second;
  if (S.isSharedPointer(op.getPtr().getType()))
    return selectSharedStore(S, op, baseIt->second, triple, registers);
  bool isBuffer = bufferIt != S.pointerBuffers.end() && bufferIt->second;
  return selectGlobalOrBufferStore(S, op, baseIt->second, triple, isBuffer,
                                   registers);
}

LogicalResult selectLoad(WaveMachineSelector &S, LoadOp op) {
  auto baseIt = S.pointerBases.find(op.getPtr());
  auto offsetIt = S.pointerOffsets.find(op.getPtr());
  auto bufferIt = S.pointerBuffers.find(op.getPtr());
  if (baseIt == S.pointerBases.end() || offsetIt == S.pointerOffsets.end())
    return op.emitError("WaveMachine backend expects selected wave pointer");

  auto simdType = cast<SimdType>(op.getValue().getType());
  unsigned registers = loadRegisterCount(simdType);
  OffsetTriple triple = offsetIt->second;

  if (S.isSharedPointer(op.getPtr().getType()))
    return selectSharedLoad(S, op, baseIt->second, triple, registers);

  bool isBuffer = bufferIt != S.pointerBuffers.end() && bufferIt->second;
  return selectGlobalOrBufferLoad(S, op, baseIt->second, triple, isBuffer,
                                  registers);
}

} // namespace mlir::wave::wmsel
