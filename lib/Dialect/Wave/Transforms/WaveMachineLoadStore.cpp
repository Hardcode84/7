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

// Build the WaveMachine load op with `opcode` and rebind the original
// value / token to the produced VGPR tuple and memory token. Shared by
// every selectLoad variant (LDS / global / buffer).
void finalizeLoad(WaveMachineSelector &S, LoadOp op, StringRef opcode,
                  ArrayRef<Value> operands, unsigned registers,
                  ArrayRef<NamedAttribute> attrs = {}) {
  SmallVector<Type, 2> resultTypes{
      getRegType(op.getContext(), wavemachine::RegClass::VGPR, registers),
      getMemTokenType(op.getContext())};
  Operation *load =
      createWMOp(S.builder, op.getLoc(), opcode, operands, resultTypes, attrs);
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
  SmallVector<Value> operands{addr, S.expect(op.getValue(), op)};
  if (Value dependency = op.getDependency())
    operands.push_back(S.expect(dependency, op));
  StringRef opcode = registers == 1 ? "ds_store_b32" : "ds_store_tuple_b32";
  Operation *store = createWMOp(S.builder, op.getLoc(), opcode, operands,
                                getMemTokenType(op.getContext()),
                                S.instOffsetAttrs(b.instOffset, "offset"));
  S.values[op.getToken()] = store->getResult(0);
  S.eraseIfTopLevel(op);
  return success();
}

LogicalResult selectGlobalOrBufferStore(WaveMachineSelector &S, StoreOp op,
                                        Value base, OffsetTriple offset,
                                        bool isBuffer, unsigned registers) {
  if (registers != 1)
    return op.emitError("global/buffer tuple stores are not supported by "
                        "the WaveMachine backend yet");
  wavemachine::AddressFieldSpec spec =
      isBuffer ? wavemachine::BufferStoreB32Op::getAddressFieldSpec()
               : wavemachine::GlobalStoreB32Op::getAddressFieldSpec();
  auto b = S.bucketForSpec(op.getLoc(), offset, spec);
  SmallVector<Value> operands{b.voffset, S.expect(op.getValue(), op), base};
  if (spec.hasSoffset)
    operands.push_back(b.soffset);
  if (Value dependency = op.getDependency())
    operands.push_back(S.expect(dependency, op));
  Operation *store =
      createWMOp(S.builder, op.getLoc(),
                 isBuffer ? "buffer_store_b32" : "global_store_b32", operands,
                 getMemTokenType(op.getContext()),
                 S.instOffsetAttrs(b.instOffset, "inst_offset"));
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
  SmallVector<Value> operands{addr};
  if (Value dependency = op.getDependency())
    operands.push_back(S.expect(dependency, op));
  finalizeLoad(S, op, registers == 1 ? "ds_load_b32" : "ds_load_tuple_b32",
               operands, registers, S.instOffsetAttrs(b.instOffset, "offset"));
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
  SmallVector<Value> operands{b.voffset, base};
  if (spec.hasSoffset)
    operands.push_back(b.soffset);
  if (Value dependency = op.getDependency())
    operands.push_back(S.expect(dependency, op));
  StringRef opcode;
  if (isBuffer)
    opcode = registers == 1 ? "buffer_load_b32" : "buffer_load_tuple_b32";
  else
    opcode = registers == 1 ? "global_load_b32" : "global_load_tuple_b32";
  finalizeLoad(S, op, opcode, operands, registers,
               S.instOffsetAttrs(b.instOffset, "inst_offset"));
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
