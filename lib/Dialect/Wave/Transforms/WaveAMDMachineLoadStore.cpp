//===- WaveAMDMachineLoadStore.cpp - load/store selection
//-------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// Lower `wave.load` / `wave.store` to the LDS / global / buffer
// waveamdmachine ops. The pointer's bucketized triple (set by the
// bucketizer at the `wave.index_expr` boundary and stored in the
// selector's sidecars) is routed through `bucketForSpec`, which picks
// V / S / inst-offset slots that fit the address-field spec of the
// concrete machine op.
//
//===----------------------------------------------------------------------===//

#include "WaveAMDMachineSelector.h"

using namespace mlir;
using namespace mlir::wave;
using namespace mlir::waveamd;
using namespace mlir::wave::wmsel;

namespace mlir::wave::wmsel {

namespace {

static unsigned dwordCount(Type type) {
  uint64_t bits = 32;
  if (auto vecTy = dyn_cast<VectorType>(type)) {
    Type elementType = vecTy.getElementType();
    if (elementType.isIntOrFloat())
      bits = elementType.getIntOrFloatBitWidth() * vecTy.getNumElements();
  } else if (type.isIntOrFloat())
    bits = type.getIntOrFloatBitWidth();
  return (bits + 31) / 32;
}

unsigned loadRegisterCount(SimdType simdType) {
  return dwordCount(simdType.getElementType());
}

bool isScalar16Bit(SimdType simdType) {
  if (isa<VectorType>(simdType.getElementType()))
    return false;
  Type elementType = simdType.getElementType();
  return elementType.isIntOrFloat() &&
         elementType.getIntOrFloatBitWidth() == 16;
}

// Bind the caller `wave.load` op's value + token to the freshly built
// WaveAMDMachine load and drop the source op.
void bindLoadResults(WaveAMDMachineSelector &S, LoadOp op, Operation *load) {
  S.values[op.getValue()] = load->getResult(0);
  S.values[op.getToken()] = load->getResult(1);
  S.eraseIfTopLevel(op);
}

LogicalResult selectSharedStore(WaveAMDMachineSelector &S, StoreOp op,
                                Value base, OffsetTriple offset,
                                unsigned registers, bool scalar16) {
  waveamdmachine::AddressFieldSpec spec =
      scalar16 ? waveamdmachine::DsStoreB16Op::getAddressFieldSpec()
      : registers == 1
          ? waveamdmachine::DsStoreB32Op::getAddressFieldSpec()
          : waveamdmachine::DsStoreTupleB32Op::getAddressFieldSpec();
  auto b = S.bucketForSpec(op.getLoc(), offset, spec);
  Value addr = S.ensureVGPRForVSrc1(
      op.getLoc(), S.addByteOffsets(op.getLoc(), base, b.voffset));
  Value value = S.expect(op.getValue(), op);
  Value dep = op.getDependency() ? S.expect(op.getDependency(), op) : Value{};
  Type tokenType = getMemTokenType(op.getContext());
  Operation *store;
  if (scalar16)
    store = waveamdmachine::DsStoreB16Op::create(
        S.builder, op.getLoc(), tokenType, addr, value, dep, b.instOffset);
  else if (registers == 1)
    store = waveamdmachine::DsStoreB32Op::create(
        S.builder, op.getLoc(), tokenType, addr, value, dep, b.instOffset);
  else
    store = waveamdmachine::DsStoreTupleB32Op::create(
        S.builder, op.getLoc(), tokenType, addr, value, dep, b.instOffset);
  S.values[op.getToken()] = store->getResult(0);
  S.eraseIfTopLevel(op);
  return success();
}

// Build one scalar or tuple global-or-buffer store; the tuple form
// covers all N dwords in a single op (asm emit expands it).
static Operation *buildOneGlobalOrBufferStore(WaveAMDMachineSelector &S,
                                              StoreOp op, Value voffset,
                                              Value value, Value base,
                                              bool isBuffer, Value soffset,
                                              Value dep, int64_t instOffset,
                                              bool isTuple) {
  Type tokenType = getMemTokenType(op.getContext());
  if (isTuple) {
    if (isBuffer)
      return waveamdmachine::BufferStoreTupleB32Op::create(
          S.builder, op.getLoc(), tokenType, voffset, value, base, soffset, dep,
          instOffset);
    return waveamdmachine::GlobalStoreTupleB32Op::create(
        S.builder, op.getLoc(), tokenType, voffset, value, base, dep,
        instOffset);
  }
  if (isBuffer)
    return waveamdmachine::BufferStoreB32Op::create(
        S.builder, op.getLoc(), tokenType, voffset, value, base, soffset, dep,
        instOffset);
  return waveamdmachine::GlobalStoreB32Op::create(
      S.builder, op.getLoc(), tokenType, voffset, value, base, dep, instOffset);
}

static LogicalResult selectFullAddressStore(WaveAMDMachineSelector &S,
                                            StoreOp op, Value globalBase,
                                            OffsetTriple offset,
                                            unsigned registers, bool scalar16) {
  if (!globalBase)
    return op.emitError("full-address fallback requires original global base");
  FailureOr<Value> addr =
      S.materializeGlobalAddress(op.getLoc(), globalBase, offset, op);
  if (failed(addr))
    return failure();
  Value value = S.ensureVGPRForVSrc1(op.getLoc(), S.expect(op.getValue(), op));
  Value dep = op.getDependency() ? S.expect(op.getDependency(), op) : Value{};
  Type tokenType = getMemTokenType(op.getContext());
  SmallVector<Value> tokens;
  if (scalar16) {
    Operation *store = waveamdmachine::GlobalStoreB16Addr64Op::create(
        S.builder, op.getLoc(), tokenType, *addr, value, dep, 0);
    tokens.push_back(store->getResult(0));
  } else if (registers == 1) {
    Operation *store = waveamdmachine::GlobalStoreB32Addr64Op::create(
        S.builder, op.getLoc(), tokenType, *addr, value, dep, 0);
    tokens.push_back(store->getResult(0));
  } else {
    Type vgpr1 = getRegType(op.getContext(), waveamdmachine::RegClass::VGPR, 1);
    SmallVector<Type> elementTypes(registers, vgpr1);
    auto split = waveamdmachine::TupleToElementsOp::create(
        S.builder, op.getLoc(), elementTypes, value);
    for (auto [idx, element] : llvm::enumerate(split.getElements())) {
      Operation *store = waveamdmachine::GlobalStoreB32Addr64Op::create(
          S.builder, op.getLoc(), tokenType, *addr, element, dep,
          static_cast<int64_t>(idx) * 4);
      tokens.push_back(store->getResult(0));
    }
  }
  Value token = tokens.size() == 1
                    ? tokens.front()
                    : waveamdmachine::TokenJoinOp::create(
                          S.builder, op.getLoc(), tokenType, tokens)
                          .getResult();
  S.values[op.getToken()] = token;
  S.eraseIfTopLevel(op);
  return success();
}

LogicalResult selectGlobalOrBufferStore(WaveAMDMachineSelector &S, StoreOp op,
                                        Value base, Value globalBase,
                                        OffsetTriple offset, bool isBuffer,
                                        unsigned registers, bool scalar16) {
  waveamdmachine::AddressFieldSpec spec =
      scalar16
          ? (isBuffer ? waveamdmachine::BufferStoreB16Op::getAddressFieldSpec()
                      : waveamdmachine::GlobalStoreB16Op::getAddressFieldSpec())
          : (isBuffer
                 ? waveamdmachine::BufferStoreB32Op::getAddressFieldSpec()
                 : waveamdmachine::GlobalStoreB32Op::getAddressFieldSpec());
  if (S.needsFullAddressForSpec(offset, spec))
    return selectFullAddressStore(S, op, globalBase, offset, registers,
                                  scalar16);
  auto b = S.bucketForSpec(op.getLoc(), offset, spec);
  // wave.splat'd SGPRs (e.g. wave.read_cycles) reach the store as
  // SGPR1; the VMEM store needs the value in a VGPR. Materialize on
  // demand; no-op for already-VGPR values.
  Value value = S.ensureVGPRForVSrc1(op.getLoc(), S.expect(op.getValue(), op));
  Value dep = op.getDependency() ? S.expect(op.getDependency(), op) : Value{};
  Operation *store;
  if (scalar16) {
    Type tokenType = getMemTokenType(op.getContext());
    if (isBuffer)
      store = waveamdmachine::BufferStoreB16Op::create(
          S.builder, op.getLoc(), tokenType, b.voffset, value, base, b.soffset,
          dep, b.instOffset);
    else
      store = waveamdmachine::GlobalStoreB16Op::create(
          S.builder, op.getLoc(), tokenType, b.voffset, value, base, dep,
          b.instOffset);
  } else {
    store = buildOneGlobalOrBufferStore(S, op, b.voffset, value, base, isBuffer,
                                        b.soffset, dep, b.instOffset,
                                        /*isTuple=*/registers != 1);
  }
  S.values[op.getToken()] = store->getResult(0);
  S.eraseIfTopLevel(op);
  return success();
}

LogicalResult selectSharedLoad(WaveAMDMachineSelector &S, LoadOp op, Value base,
                               OffsetTriple offset, unsigned registers,
                               bool scalar16) {
  waveamdmachine::AddressFieldSpec spec =
      scalar16 ? waveamdmachine::DsLoadB16Op::getAddressFieldSpec()
      : registers == 1
          ? waveamdmachine::DsLoadB32Op::getAddressFieldSpec()
          : waveamdmachine::DsLoadTupleB32Op::getAddressFieldSpec();
  auto b = S.bucketForSpec(op.getLoc(), offset, spec);
  Value addr = S.ensureVGPRForVSrc1(
      op.getLoc(), S.addByteOffsets(op.getLoc(), base, b.voffset));
  Value dep = op.getDependency() ? S.expect(op.getDependency(), op) : Value{};
  Type resultType =
      getRegType(op.getContext(), waveamdmachine::RegClass::VGPR, registers);
  Type tokenType = getMemTokenType(op.getContext());
  Operation *load;
  if (scalar16)
    load = waveamdmachine::DsLoadB16Op::create(
        S.builder, op.getLoc(), resultType, tokenType, addr, dep, b.instOffset);
  else if (registers == 1)
    load = waveamdmachine::DsLoadB32Op::create(
        S.builder, op.getLoc(), resultType, tokenType, addr, dep, b.instOffset);
  else
    load = waveamdmachine::DsLoadTupleB32Op::create(
        S.builder, op.getLoc(), resultType, tokenType, addr, dep, b.instOffset);
  bindLoadResults(S, op, load);
  return success();
}

static waveamdmachine::AddressFieldSpec bufferLoadSpec(bool scalar16,
                                                       unsigned registers) {
  if (scalar16)
    return waveamdmachine::BufferLoadB16Op::getAddressFieldSpec();
  if (registers == 1)
    return waveamdmachine::BufferLoadB32Op::getAddressFieldSpec();
  return waveamdmachine::BufferLoadTupleB32Op::getAddressFieldSpec();
}

static waveamdmachine::AddressFieldSpec globalLoadSpec(bool scalar16,
                                                       unsigned registers) {
  if (scalar16)
    return waveamdmachine::GlobalLoadB16Op::getAddressFieldSpec();
  if (registers == 1)
    return waveamdmachine::GlobalLoadB32Op::getAddressFieldSpec();
  return waveamdmachine::GlobalLoadTupleB32Op::getAddressFieldSpec();
}

static Operation *buildBufferLoad(WaveAMDMachineSelector &S, LoadOp op,
                                  Type resultType, Type tokenType,
                                  WaveAMDMachineSelector::BucketedOperands b,
                                  Value base, Value dep, bool scalar16,
                                  unsigned registers) {
  if (scalar16)
    return waveamdmachine::BufferLoadB16Op::create(
        S.builder, op.getLoc(), resultType, tokenType, b.voffset, base,
        b.soffset, dep, b.instOffset);
  if (registers == 1)
    return waveamdmachine::BufferLoadB32Op::create(
        S.builder, op.getLoc(), resultType, tokenType, b.voffset, base,
        b.soffset, dep, b.instOffset);
  return waveamdmachine::BufferLoadTupleB32Op::create(
      S.builder, op.getLoc(), resultType, tokenType, b.voffset, base, b.soffset,
      dep, b.instOffset);
}

static Operation *buildGlobalLoad(WaveAMDMachineSelector &S, LoadOp op,
                                  Type resultType, Type tokenType,
                                  WaveAMDMachineSelector::BucketedOperands b,
                                  Value base, Value dep, bool scalar16,
                                  unsigned registers) {
  if (scalar16)
    return waveamdmachine::GlobalLoadB16Op::create(
        S.builder, op.getLoc(), resultType, tokenType, b.voffset, base, dep,
        b.instOffset);
  if (registers == 1)
    return waveamdmachine::GlobalLoadB32Op::create(
        S.builder, op.getLoc(), resultType, tokenType, b.voffset, base, dep,
        b.instOffset);
  return waveamdmachine::GlobalLoadTupleB32Op::create(
      S.builder, op.getLoc(), resultType, tokenType, b.voffset, base, dep,
      b.instOffset);
}

LogicalResult selectFullAddressLoad(WaveAMDMachineSelector &S, LoadOp op,
                                    Value globalBase, OffsetTriple offset,
                                    unsigned registers, bool scalar16) {
  if (!globalBase)
    return op.emitError("full-address fallback requires original global base");
  FailureOr<Value> addr =
      S.materializeGlobalAddress(op.getLoc(), globalBase, offset, op);
  if (failed(addr))
    return failure();
  Value dep = op.getDependency() ? S.expect(op.getDependency(), op) : Value{};
  Type tokenType = getMemTokenType(op.getContext());
  Type vgpr1 = getRegType(op.getContext(), waveamdmachine::RegClass::VGPR, 1);
  SmallVector<Value> elements;
  SmallVector<Value> tokens;
  if (scalar16) {
    Operation *load = waveamdmachine::GlobalLoadB16Addr64Op::create(
        S.builder, op.getLoc(), vgpr1, tokenType, *addr, dep, 0);
    elements.push_back(load->getResult(0));
    tokens.push_back(load->getResult(1));
  } else if (registers == 1) {
    Operation *load = waveamdmachine::GlobalLoadB32Addr64Op::create(
        S.builder, op.getLoc(), vgpr1, tokenType, *addr, dep, 0);
    elements.push_back(load->getResult(0));
    tokens.push_back(load->getResult(1));
  } else {
    for (unsigned idx : llvm::seq<unsigned>(0, registers)) {
      Operation *load = waveamdmachine::GlobalLoadB32Addr64Op::create(
          S.builder, op.getLoc(), vgpr1, tokenType, *addr, dep,
          static_cast<int64_t>(idx) * 4);
      elements.push_back(load->getResult(0));
      tokens.push_back(load->getResult(1));
    }
  }
  Value result = elements.front();
  if (registers != 1) {
    Type resultType =
        getRegType(op.getContext(), waveamdmachine::RegClass::VGPR, registers);
    result = waveamdmachine::TupleFromElementsOp::create(S.builder, op.getLoc(),
                                                         resultType, elements)
                 .getTuple();
  }
  Value token = tokens.size() == 1
                    ? tokens.front()
                    : waveamdmachine::TokenJoinOp::create(
                          S.builder, op.getLoc(), tokenType, tokens)
                          .getResult();
  S.values[op.getValue()] = result;
  S.values[op.getToken()] = token;
  S.eraseIfTopLevel(op);
  return success();
}

LogicalResult selectGlobalOrBufferLoad(WaveAMDMachineSelector &S, LoadOp op,
                                       Value base, Value globalBase,
                                       OffsetTriple offset, bool isBuffer,
                                       unsigned registers, bool scalar16) {
  waveamdmachine::AddressFieldSpec spec =
      isBuffer ? bufferLoadSpec(scalar16, registers)
               : globalLoadSpec(scalar16, registers);
  if (S.needsFullAddressForSpec(offset, spec))
    return selectFullAddressLoad(S, op, globalBase, offset, registers,
                                 scalar16);
  auto b = S.bucketForSpec(op.getLoc(), offset, spec);
  Value dep = op.getDependency() ? S.expect(op.getDependency(), op) : Value{};
  Type resultType =
      getRegType(op.getContext(), waveamdmachine::RegClass::VGPR, registers);
  Type tokenType = getMemTokenType(op.getContext());
  Operation *load = isBuffer ? buildBufferLoad(S, op, resultType, tokenType, b,
                                               base, dep, scalar16, registers)
                             : buildGlobalLoad(S, op, resultType, tokenType, b,
                                               base, dep, scalar16, registers);
  bindLoadResults(S, op, load);
  return success();
}

} // namespace

LogicalResult selectStore(WaveAMDMachineSelector &S, StoreOp op) {
  auto baseIt = S.pointerBases.find(op.getPtr());
  auto offsetIt = S.pointerOffsets.find(op.getPtr());
  auto bufferIt = S.pointerBuffers.find(op.getPtr());
  if (baseIt == S.pointerBases.end() || offsetIt == S.pointerOffsets.end())
    return op.emitError("WaveAMDMachine backend expects selected wave pointer");
  unsigned registers =
      loadRegisterCount(cast<SimdType>(op.getValue().getType()));
  bool scalar16 = isScalar16Bit(cast<SimdType>(op.getValue().getType()));
  OffsetTriple triple = offsetIt->second;
  if (S.isSharedPointer(op.getPtr().getType()))
    return selectSharedStore(S, op, baseIt->second, triple, registers,
                             scalar16);
  bool isBuffer = bufferIt != S.pointerBuffers.end() && bufferIt->second;
  Value globalBase = S.pointerGlobalBases.lookup(op.getPtr());
  if (!globalBase && !isBuffer)
    globalBase = baseIt->second;
  return selectGlobalOrBufferStore(S, op, baseIt->second, globalBase, triple,
                                   isBuffer, registers, scalar16);
}

LogicalResult selectLoad(WaveAMDMachineSelector &S, LoadOp op) {
  auto baseIt = S.pointerBases.find(op.getPtr());
  auto offsetIt = S.pointerOffsets.find(op.getPtr());
  auto bufferIt = S.pointerBuffers.find(op.getPtr());
  if (baseIt == S.pointerBases.end() || offsetIt == S.pointerOffsets.end())
    return op.emitError("WaveAMDMachine backend expects selected wave pointer");

  auto simdType = cast<SimdType>(op.getValue().getType());
  unsigned registers = loadRegisterCount(simdType);
  bool scalar16 = isScalar16Bit(simdType);
  OffsetTriple triple = offsetIt->second;

  if (S.isSharedPointer(op.getPtr().getType()))
    return selectSharedLoad(S, op, baseIt->second, triple, registers, scalar16);

  bool isBuffer = bufferIt != S.pointerBuffers.end() && bufferIt->second;
  Value globalBase = S.pointerGlobalBases.lookup(op.getPtr());
  if (!globalBase && !isBuffer)
    globalBase = baseIt->second;
  return selectGlobalOrBufferLoad(S, op, baseIt->second, globalBase, triple,
                                  isBuffer, registers, scalar16);
}

} // namespace mlir::wave::wmsel
