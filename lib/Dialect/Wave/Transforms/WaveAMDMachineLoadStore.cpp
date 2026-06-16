//===- WaveAMDMachineLoadStore.cpp - load/store selection
//-------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// Lower `wave.load` / `wave.store` to LDS / global / buffer ops.
// Pointer offsets are planned at the emission site.
//
//===----------------------------------------------------------------------===//

#include "WaveAMDMachineSelector.h"

using namespace mlir;
using namespace mlir::wave;
using namespace mlir::waveamd;
using namespace mlir::wave::wmsel;

namespace mlir::wave::wmsel {

namespace {

static FailureOr<MemoryPayloadShape> getPayloadShape(Operation *op,
                                                     SimdType simdType) {
  return getMemoryPayloadShape(
      simdType.getElementType(),
      [&](const Twine &msg) { return op->emitError(msg); });
}

// Bind the caller `wave.load` op's value + token to the freshly built
// WaveAMDMachine load and drop the source op.
void bindLoadResults(WaveAMDMachineSelector &S, LoadOp op, Operation *load) {
  S.values[op.getValue()] = load->getResult(0);
  S.values[op.getToken()] = load->getResult(1);
  S.eraseIfTopLevel(op);
}

static waveamdmachine::AddressFieldSpec
sharedStoreSpec(unsigned registers, bool useB8Op, bool useB16Op) {
  if (useB8Op)
    return waveamdmachine::DsStoreB8Op::getAddressFieldSpec();
  if (useB16Op)
    return waveamdmachine::DsStoreB16Op::getAddressFieldSpec();
  if (registers == 1)
    return waveamdmachine::DsStoreB32Op::getAddressFieldSpec();
  return waveamdmachine::DsStoreTupleB32Op::getAddressFieldSpec();
}

static Operation *buildSharedStore(WaveAMDMachineSelector &S, StoreOp op,
                                   Type tokenType, Value addr, Value value,
                                   Value dep, int64_t offset,
                                   unsigned registers, bool useB8Op,
                                   bool useB16Op) {
  if (useB8Op)
    return waveamdmachine::DsStoreB8Op::create(
        S.builder, op.getLoc(), tokenType, addr, value, dep, offset);
  if (useB16Op)
    return waveamdmachine::DsStoreB16Op::create(
        S.builder, op.getLoc(), tokenType, addr, value, dep, offset);
  if (registers == 1)
    return waveamdmachine::DsStoreB32Op::create(
        S.builder, op.getLoc(), tokenType, addr, value, dep, offset);
  return waveamdmachine::DsStoreTupleB32Op::create(
      S.builder, op.getLoc(), tokenType, addr, value, dep, offset);
}

LogicalResult selectSharedStore(WaveAMDMachineSelector &S, StoreOp op,
                                Value base, const PointerOffset &offset,
                                unsigned registers, bool useB8Op,
                                bool useB16Op) {
  waveamdmachine::AddressFieldSpec spec =
      sharedStoreSpec(registers, useB8Op, useB16Op);
  FailureOr<MaterializedLdsAddress> sharedAddr =
      materializeLdsAddress(S, op.getOperation(), base, offset, spec);
  if (failed(sharedAddr))
    return failure();
  Value value = S.expect(op.getValue(), op);
  if (registers == 1)
    value = S.ensureVGPRForVSrc1(op.getLoc(), value);
  Value dep = op.getDependency() ? S.expect(op.getDependency(), op) : Value{};
  Type tokenType = getMemTokenType(op.getContext());
  Operation *store =
      buildSharedStore(S, op, tokenType, sharedAddr->addr, value, dep,
                       sharedAddr->instOffset, registers, useB8Op, useB16Op);
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
                                            const AddressPlan &plan,
                                            unsigned registers, bool useB8Op,
                                            bool useB16Op) {
  if (!globalBase)
    return op.emitError("full-address fallback requires original global base");
  FailureOr<Value> addr = materializeFullPlanAddress(S, op, globalBase, plan);
  if (failed(addr))
    return failure();
  Value value = S.ensureVGPRForVSrc1(op.getLoc(), S.expect(op.getValue(), op));
  Value dep = op.getDependency() ? S.expect(op.getDependency(), op) : Value{};
  Type tokenType = getMemTokenType(op.getContext());
  SmallVector<Value> tokens;
  if (useB8Op) {
    Operation *store = waveamdmachine::GlobalStoreB8Addr64Op::create(
        S.builder, op.getLoc(), tokenType, *addr, value, dep, 0);
    tokens.push_back(store->getResult(0));
  } else if (useB16Op) {
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

static LogicalResult
emitGlobalOrBufferStore(WaveAMDMachineSelector &S, StoreOp op, Value base,
                        WaveAMDMachineSelector::BucketedOperands b,
                        bool isBuffer, unsigned registers, bool useB8Op,
                        bool useB16Op) {
  // wave.splat'd SGPRs (e.g. wave.read_cycles) reach the store as
  // SGPR1; the VMEM store needs the value in a VGPR. Materialize on
  // demand; no-op for already-VGPR values.
  Value value = S.ensureVGPRForVSrc1(op.getLoc(), S.expect(op.getValue(), op));
  Value dep = op.getDependency() ? S.expect(op.getDependency(), op) : Value{};
  Operation *store;
  if (useB8Op || useB16Op) {
    Type tokenType = getMemTokenType(op.getContext());
    if (useB8Op) {
      if (isBuffer)
        store = waveamdmachine::BufferStoreB8Op::create(
            S.builder, op.getLoc(), tokenType, b.voffset, value, base,
            b.soffset, dep, b.instOffset);
      else
        store = waveamdmachine::GlobalStoreB8Op::create(
            S.builder, op.getLoc(), tokenType, b.voffset, value, base, dep,
            b.instOffset);
    } else {
      if (isBuffer)
        store = waveamdmachine::BufferStoreB16Op::create(
            S.builder, op.getLoc(), tokenType, b.voffset, value, base,
            b.soffset, dep, b.instOffset);
      else
        store = waveamdmachine::GlobalStoreB16Op::create(
            S.builder, op.getLoc(), tokenType, b.voffset, value, base, dep,
            b.instOffset);
    }
  } else {
    store = buildOneGlobalOrBufferStore(S, op, b.voffset, value, base, isBuffer,
                                        b.soffset, dep, b.instOffset,
                                        /*isTuple=*/registers != 1);
  }
  S.values[op.getToken()] = store->getResult(0);
  S.eraseIfTopLevel(op);
  return success();
}

static LogicalResult selectGlobalOrBufferStore(
    WaveAMDMachineSelector &S, StoreOp op, Value base, Value globalBase,
    const PointerOffset &offset, bool isBuffer, unsigned registers,
    bool useB8Op, bool useB16Op, const waveamdmachine::AddressFieldSpec &spec) {
  FailureOr<AddressPlan> plan = planMemoryAddress(S, op, offset, spec);
  if (failed(plan))
    return failure();
  if (plan->fullAddressRemainderExpr && isBuffer)
    return emitBufferAddressFieldError(op.getOperation());
  if (plan->fullAddressRemainderExpr)
    return selectFullAddressStore(S, op, globalBase, *plan, registers, useB8Op,
                                  useB16Op);
  FailureOr<WaveAMDMachineSelector::BucketedOperands> buckets =
      materializePlanBuckets(S, op, *plan, spec);
  if (failed(buckets))
    return failure();
  return emitGlobalOrBufferStore(S, op, base, *buckets, isBuffer, registers,
                                 useB8Op, useB16Op);
}

LogicalResult selectGlobalOrBufferStore(WaveAMDMachineSelector &S, StoreOp op,
                                        Value base, Value globalBase,
                                        const PointerOffset &offset,
                                        bool isBuffer, unsigned registers,
                                        bool useB8Op, bool useB16Op) {
  waveamdmachine::AddressFieldSpec spec =
      useB8Op
          ? (isBuffer ? waveamdmachine::BufferStoreB8Op::getAddressFieldSpec()
                      : waveamdmachine::GlobalStoreB8Op::getAddressFieldSpec())
      : useB16Op
          ? (isBuffer ? waveamdmachine::BufferStoreB16Op::getAddressFieldSpec()
                      : waveamdmachine::GlobalStoreB16Op::getAddressFieldSpec())
          : (isBuffer
                 ? waveamdmachine::BufferStoreB32Op::getAddressFieldSpec()
                 : waveamdmachine::GlobalStoreB32Op::getAddressFieldSpec());
  return selectGlobalOrBufferStore(S, op, base, globalBase, offset, isBuffer,
                                   registers, useB8Op, useB16Op, spec);
}

static waveamdmachine::AddressFieldSpec
sharedLoadSpec(unsigned registers, bool useB8Op, bool useB16Op) {
  if (useB8Op)
    return waveamdmachine::DsLoadU8Op::getAddressFieldSpec();
  if (useB16Op)
    return waveamdmachine::DsLoadB16Op::getAddressFieldSpec();
  if (registers == 1)
    return waveamdmachine::DsLoadB32Op::getAddressFieldSpec();
  return waveamdmachine::DsLoadTupleB32Op::getAddressFieldSpec();
}

static Operation *buildSharedLoad(WaveAMDMachineSelector &S, LoadOp op,
                                  Type resultType, Type tokenType, Value addr,
                                  Value dep, int64_t offset, unsigned registers,
                                  bool useB8Op, bool useB16Op) {
  if (useB8Op)
    return waveamdmachine::DsLoadU8Op::create(
        S.builder, op.getLoc(), resultType, tokenType, addr, dep, offset);
  if (useB16Op)
    return waveamdmachine::DsLoadB16Op::create(
        S.builder, op.getLoc(), resultType, tokenType, addr, dep, offset);
  if (registers == 1)
    return waveamdmachine::DsLoadB32Op::create(
        S.builder, op.getLoc(), resultType, tokenType, addr, dep, offset);
  return waveamdmachine::DsLoadTupleB32Op::create(
      S.builder, op.getLoc(), resultType, tokenType, addr, dep, offset);
}

LogicalResult selectSharedLoad(WaveAMDMachineSelector &S, LoadOp op, Value base,
                               const PointerOffset &offset, unsigned registers,
                               bool useB8Op, bool useB16Op) {
  waveamdmachine::AddressFieldSpec spec =
      sharedLoadSpec(registers, useB8Op, useB16Op);
  FailureOr<MaterializedLdsAddress> sharedAddr =
      materializeLdsAddress(S, op.getOperation(), base, offset, spec);
  if (failed(sharedAddr))
    return failure();
  Value dep = op.getDependency() ? S.expect(op.getDependency(), op) : Value{};
  Type resultType =
      getRegType(op.getContext(), waveamdmachine::RegClass::VGPR, registers);
  Type tokenType = getMemTokenType(op.getContext());
  Operation *load =
      buildSharedLoad(S, op, resultType, tokenType, sharedAddr->addr, dep,
                      sharedAddr->instOffset, registers, useB8Op, useB16Op);
  bindLoadResults(S, op, load);
  return success();
}

static waveamdmachine::AddressFieldSpec
bufferLoadSpec(bool useB8Op, bool useB16Op, unsigned registers) {
  if (useB8Op)
    return waveamdmachine::BufferLoadU8Op::getAddressFieldSpec();
  if (useB16Op)
    return waveamdmachine::BufferLoadB16Op::getAddressFieldSpec();
  if (registers == 1)
    return waveamdmachine::BufferLoadB32Op::getAddressFieldSpec();
  return waveamdmachine::BufferLoadTupleB32Op::getAddressFieldSpec();
}

static waveamdmachine::AddressFieldSpec
globalLoadSpec(bool useB8Op, bool useB16Op, unsigned registers) {
  if (useB8Op)
    return waveamdmachine::GlobalLoadU8Op::getAddressFieldSpec();
  if (useB16Op)
    return waveamdmachine::GlobalLoadB16Op::getAddressFieldSpec();
  if (registers == 1)
    return waveamdmachine::GlobalLoadB32Op::getAddressFieldSpec();
  return waveamdmachine::GlobalLoadTupleB32Op::getAddressFieldSpec();
}

static Operation *buildBufferLoad(WaveAMDMachineSelector &S, LoadOp op,
                                  Type resultType, Type tokenType,
                                  WaveAMDMachineSelector::BucketedOperands b,
                                  Value base, Value dep, bool useB8Op,
                                  bool useB16Op, unsigned registers) {
  if (useB8Op)
    return waveamdmachine::BufferLoadU8Op::create(
        S.builder, op.getLoc(), resultType, tokenType, b.voffset, base,
        b.soffset, dep, b.instOffset);
  if (useB16Op)
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
                                  Value base, Value dep, bool useB8Op,
                                  bool useB16Op, unsigned registers) {
  if (useB8Op)
    return waveamdmachine::GlobalLoadU8Op::create(
        S.builder, op.getLoc(), resultType, tokenType, b.voffset, base, dep,
        b.instOffset);
  if (useB16Op)
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
                                    Value globalBase, const AddressPlan &plan,
                                    unsigned registers, bool useB8Op,
                                    bool useB16Op) {
  if (!globalBase)
    return op.emitError("full-address fallback requires original global base");
  FailureOr<Value> addr = materializeFullPlanAddress(S, op, globalBase, plan);
  if (failed(addr))
    return failure();
  Value dep = op.getDependency() ? S.expect(op.getDependency(), op) : Value{};
  Type tokenType = getMemTokenType(op.getContext());
  Type vgpr1 = getRegType(op.getContext(), waveamdmachine::RegClass::VGPR, 1);
  SmallVector<Value> elements;
  SmallVector<Value> tokens;
  if (useB8Op) {
    Operation *load = waveamdmachine::GlobalLoadU8Addr64Op::create(
        S.builder, op.getLoc(), vgpr1, tokenType, *addr, dep, 0);
    elements.push_back(load->getResult(0));
    tokens.push_back(load->getResult(1));
  } else if (useB16Op) {
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

static LogicalResult
emitGlobalOrBufferLoad(WaveAMDMachineSelector &S, LoadOp op, Value base,
                       WaveAMDMachineSelector::BucketedOperands b,
                       bool isBuffer, unsigned registers, bool useB8Op,
                       bool useB16Op) {
  Value dep = op.getDependency() ? S.expect(op.getDependency(), op) : Value{};
  Type resultType =
      getRegType(op.getContext(), waveamdmachine::RegClass::VGPR, registers);
  Type tokenType = getMemTokenType(op.getContext());
  Operation *load = isBuffer
                        ? buildBufferLoad(S, op, resultType, tokenType, b, base,
                                          dep, useB8Op, useB16Op, registers)
                        : buildGlobalLoad(S, op, resultType, tokenType, b, base,
                                          dep, useB8Op, useB16Op, registers);
  bindLoadResults(S, op, load);
  return success();
}

static LogicalResult selectGlobalOrBufferLoad(
    WaveAMDMachineSelector &S, LoadOp op, Value base, Value globalBase,
    const PointerOffset &offset, bool isBuffer, unsigned registers,
    bool useB8Op, bool useB16Op, const waveamdmachine::AddressFieldSpec &spec) {
  FailureOr<AddressPlan> plan = planMemoryAddress(S, op, offset, spec);
  if (failed(plan))
    return failure();
  if (plan->fullAddressRemainderExpr && isBuffer)
    return emitBufferAddressFieldError(op.getOperation());
  if (plan->fullAddressRemainderExpr)
    return selectFullAddressLoad(S, op, globalBase, *plan, registers, useB8Op,
                                 useB16Op);
  FailureOr<WaveAMDMachineSelector::BucketedOperands> buckets =
      materializePlanBuckets(S, op, *plan, spec);
  if (failed(buckets))
    return failure();
  return emitGlobalOrBufferLoad(S, op, base, *buckets, isBuffer, registers,
                                useB8Op, useB16Op);
}

LogicalResult selectGlobalOrBufferLoad(WaveAMDMachineSelector &S, LoadOp op,
                                       Value base, Value globalBase,
                                       const PointerOffset &offset,
                                       bool isBuffer, unsigned registers,
                                       bool useB8Op, bool useB16Op) {
  waveamdmachine::AddressFieldSpec spec =
      isBuffer ? bufferLoadSpec(useB8Op, useB16Op, registers)
               : globalLoadSpec(useB8Op, useB16Op, registers);
  return selectGlobalOrBufferLoad(S, op, base, globalBase, offset, isBuffer,
                                  registers, useB8Op, useB16Op, spec);
}

} // namespace

LogicalResult selectStore(WaveAMDMachineSelector &S, StoreOp op) {
  auto baseIt = S.pointerBases.find(op.getPtr());
  auto symIt = S.pointerIndexOffsets.find(op.getPtr());
  auto bufferIt = S.pointerBuffers.find(op.getPtr());
  if (baseIt == S.pointerBases.end() || symIt == S.pointerIndexOffsets.end())
    return op.emitError("WaveAMDMachine backend expects selected wave pointer");
  FailureOr<MemoryPayloadShape> shape =
      getPayloadShape(op, cast<SimdType>(op.getValue().getType()));
  if (failed(shape))
    return failure();
  if (S.isSharedPointer(op.getPtr().getType()))
    return selectSharedStore(S, op, baseIt->second, symIt->second,
                             shape->registers, shape->useB8Op, shape->useB16Op);
  bool isBuffer = bufferIt != S.pointerBuffers.end() && bufferIt->second;
  Value globalBase = S.pointerGlobalBases.lookup(op.getPtr());
  if (!globalBase && !isBuffer)
    globalBase = baseIt->second;
  return selectGlobalOrBufferStore(S, op, baseIt->second, globalBase,
                                   symIt->second, isBuffer, shape->registers,
                                   shape->useB8Op, shape->useB16Op);
}

LogicalResult selectLoad(WaveAMDMachineSelector &S, LoadOp op) {
  auto baseIt = S.pointerBases.find(op.getPtr());
  auto symIt = S.pointerIndexOffsets.find(op.getPtr());
  auto bufferIt = S.pointerBuffers.find(op.getPtr());
  if (baseIt == S.pointerBases.end() || symIt == S.pointerIndexOffsets.end())
    return op.emitError("WaveAMDMachine backend expects selected wave pointer");

  auto simdType = cast<SimdType>(op.getValue().getType());
  FailureOr<MemoryPayloadShape> shape = getPayloadShape(op, simdType);
  if (failed(shape))
    return failure();
  if (S.isSharedPointer(op.getPtr().getType()))
    return selectSharedLoad(S, op, baseIt->second, symIt->second,
                            shape->registers, shape->useB8Op, shape->useB16Op);

  bool isBuffer = bufferIt != S.pointerBuffers.end() && bufferIt->second;
  Value globalBase = S.pointerGlobalBases.lookup(op.getPtr());
  if (!globalBase && !isBuffer)
    globalBase = baseIt->second;
  return selectGlobalOrBufferLoad(S, op, baseIt->second, globalBase,
                                  symIt->second, isBuffer, shape->registers,
                                  shape->useB8Op, shape->useB16Op);
}

} // namespace mlir::wave::wmsel
