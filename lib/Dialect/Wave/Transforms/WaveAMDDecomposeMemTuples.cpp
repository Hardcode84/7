//===- WaveAMDDecomposeMemTuples.cpp - tuple-mem decomposition --*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/Wave/Transforms/Passes.h"

#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/WaveMachine/IR/WaveMachine.h"
#include "mlir/IR/Builders.h"
#include "mlir/IR/BuiltinOps.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/ADT/SmallVector.h"

namespace mlir::wave {
#define GEN_PASS_DEF_WAVEAMDDECOMPOSEMEMTUPLES
#include "mlir/Dialect/Wave/Transforms/Passes.h.inc"
} // namespace mlir::wave

using namespace mlir;

namespace {

static wavemachine::RegType vgpr1Type(MLIRContext *ctx) {
  return wavemachine::RegType::get(ctx, wavemachine::RegClass::VGPR,
                                   /*width=*/1, /*index=*/-1);
}

static wavemachine::MemTokenType memTokenType(MLIRContext *ctx) {
  return wavemachine::MemTokenType::get(ctx);
}

// Gather elements + per-slot tokens into a TupleFromElements + TokenJoin
// and rewire `tuple_result` / `token_result` to them. Erases `op`.
static void finalizeLoadDecomposition(Operation *op, Value tupleResult,
                                      Value tokenResult,
                                      ArrayRef<Value> elements,
                                      ArrayRef<Value> tokens) {
  OpBuilder builder(op);
  Type tokenType = memTokenType(op->getContext());
  auto tupleFromElements = wavemachine::TupleFromElementsOp::create(
      builder, op->getLoc(), tupleResult.getType(), elements);
  tupleResult.replaceAllUsesWith(tupleFromElements.getTuple());
  if (tokenResult) {
    auto tokenJoin = wavemachine::TokenJoinOp::create(builder, op->getLoc(),
                                                      tokenType, tokens);
    tokenResult.replaceAllUsesWith(tokenJoin.getResult());
  }
  op->erase();
}

// Same for the store side: tuple_to_elements + N scalar stores +
// token_join. Caller supplies the per-slot store builder.
static void finalizeStoreDecomposition(Operation *op, Value tokenResult,
                                       ArrayRef<Value> tokens) {
  OpBuilder builder(op);
  Type tokenType = memTokenType(op->getContext());
  auto tokenJoin = wavemachine::TokenJoinOp::create(builder, op->getLoc(),
                                                    tokenType, tokens);
  if (tokenResult)
    tokenResult.replaceAllUsesWith(tokenJoin.getResult());
  op->erase();
}

static LogicalResult decomposeGlobalLoad(wavemachine::GlobalLoadTupleB32Op op) {
  OpBuilder builder(op);
  unsigned width =
      cast<wavemachine::RegType>(op.getResult().getType()).getWidth();
  Type vgpr1 = vgpr1Type(op.getContext());
  Type tokenType = memTokenType(op.getContext());
  int64_t baseInstOffset = op.getInstOffset();
  Value dep = op.getDependency();
  SmallVector<Value> elements;
  SmallVector<Value> tokens;
  elements.reserve(width);
  tokens.reserve(width);
  for (unsigned i = 0; i < width; ++i) {
    auto scalar = wavemachine::GlobalLoadB32Op::create(
        builder, op.getLoc(), vgpr1, tokenType, op.getOffset(), op.getBase(),
        dep, baseInstOffset + i * 4);
    elements.push_back(scalar.getResult());
    tokens.push_back(scalar.getTokens().front());
  }
  Value tokenResult = op.getTokens().empty() ? Value{} : op.getTokens().front();
  finalizeLoadDecomposition(op, op.getResult(), tokenResult, elements, tokens);
  return success();
}

static LogicalResult decomposeBufferLoad(wavemachine::BufferLoadTupleB32Op op) {
  OpBuilder builder(op);
  unsigned width =
      cast<wavemachine::RegType>(op.getResult().getType()).getWidth();
  Type vgpr1 = vgpr1Type(op.getContext());
  Type tokenType = memTokenType(op.getContext());
  int64_t baseInstOffset = op.getInstOffset();
  Value dep = op.getDependency();
  SmallVector<Value> elements;
  SmallVector<Value> tokens;
  elements.reserve(width);
  tokens.reserve(width);
  for (unsigned i = 0; i < width; ++i) {
    auto scalar = wavemachine::BufferLoadB32Op::create(
        builder, op.getLoc(), vgpr1, tokenType, op.getOffset(),
        op.getDescriptor(), op.getSoffset(), dep, baseInstOffset + i * 4);
    elements.push_back(scalar.getResult());
    tokens.push_back(scalar.getTokens().front());
  }
  Value tokenResult = op.getTokens().empty() ? Value{} : op.getTokens().front();
  finalizeLoadDecomposition(op, op.getResult(), tokenResult, elements, tokens);
  return success();
}

static LogicalResult decomposeDsLoad(wavemachine::DsLoadTupleB32Op op) {
  OpBuilder builder(op);
  unsigned width =
      cast<wavemachine::RegType>(op.getResult().getType()).getWidth();
  Type vgpr1 = vgpr1Type(op.getContext());
  Type tokenType = memTokenType(op.getContext());
  int64_t baseOffset = op.getOffset();
  Value dep = op.getDependency();
  SmallVector<Value> elements;
  SmallVector<Value> tokens;
  elements.reserve(width);
  tokens.reserve(width);
  for (unsigned i = 0; i < width; ++i) {
    auto scalar =
        wavemachine::DsLoadB32Op::create(builder, op.getLoc(), vgpr1, tokenType,
                                         op.getAddr(), dep, baseOffset + i * 4);
    elements.push_back(scalar.getResult());
    tokens.push_back(scalar.getTokens().front());
  }
  Value tokenResult = op.getTokens().empty() ? Value{} : op.getTokens().front();
  finalizeLoadDecomposition(op, op.getResult(), tokenResult, elements, tokens);
  return success();
}

// Split the tuple value into per-slot scalars via `tuple_to_elements`,
// inserted just before `op`. Returns a value list parallel to slots.
static SmallVector<Value> splitTuple(OpBuilder &builder, Operation *op,
                                     Value tuple) {
  auto tupleType = cast<wavemachine::RegType>(tuple.getType());
  unsigned width = tupleType.getWidth();
  Type vgpr1 = vgpr1Type(op->getContext());
  SmallVector<Type> elementTypes(width, vgpr1);
  auto split = wavemachine::TupleToElementsOp::create(builder, op->getLoc(),
                                                      elementTypes, tuple);
  return SmallVector<Value>(split.getElements().begin(),
                            split.getElements().end());
}

static LogicalResult
decomposeGlobalStore(wavemachine::GlobalStoreTupleB32Op op) {
  OpBuilder builder(op);
  SmallVector<Value> elements = splitTuple(builder, op, op.getValue());
  Type tokenType = memTokenType(op.getContext());
  int64_t baseInstOffset = op.getInstOffset();
  Value dep = op.getDependency();
  SmallVector<Value> tokens;
  tokens.reserve(elements.size());
  for (auto [i, element] : llvm::enumerate(elements)) {
    auto scalar = wavemachine::GlobalStoreB32Op::create(
        builder, op.getLoc(), tokenType, op.getOffset(), element, op.getBase(),
        dep, baseInstOffset + i * 4);
    tokens.push_back(scalar.getTokens().front());
  }
  Value tokenResult = op.getTokens().empty() ? Value{} : op.getTokens().front();
  finalizeStoreDecomposition(op, tokenResult, tokens);
  return success();
}

static LogicalResult
decomposeBufferStore(wavemachine::BufferStoreTupleB32Op op) {
  OpBuilder builder(op);
  SmallVector<Value> elements = splitTuple(builder, op, op.getValue());
  Type tokenType = memTokenType(op.getContext());
  int64_t baseInstOffset = op.getInstOffset();
  Value dep = op.getDependency();
  SmallVector<Value> tokens;
  tokens.reserve(elements.size());
  for (auto [i, element] : llvm::enumerate(elements)) {
    auto scalar = wavemachine::BufferStoreB32Op::create(
        builder, op.getLoc(), tokenType, op.getOffset(), element,
        op.getDescriptor(), op.getSoffset(), dep, baseInstOffset + i * 4);
    tokens.push_back(scalar.getTokens().front());
  }
  Value tokenResult = op.getTokens().empty() ? Value{} : op.getTokens().front();
  finalizeStoreDecomposition(op, tokenResult, tokens);
  return success();
}

static LogicalResult decomposeDsStore(wavemachine::DsStoreTupleB32Op op) {
  OpBuilder builder(op);
  SmallVector<Value> elements = splitTuple(builder, op, op.getValue());
  Type tokenType = memTokenType(op.getContext());
  int64_t baseOffset = op.getOffset();
  Value dep = op.getDependency();
  SmallVector<Value> tokens;
  tokens.reserve(elements.size());
  for (auto [i, element] : llvm::enumerate(elements)) {
    auto scalar = wavemachine::DsStoreB32Op::create(
        builder, op.getLoc(), tokenType, op.getAddr(), element, dep,
        baseOffset + i * 4);
    tokens.push_back(scalar.getTokens().front());
  }
  Value tokenResult = op.getTokens().empty() ? Value{} : op.getTokens().front();
  finalizeStoreDecomposition(op, tokenResult, tokens);
  return success();
}

struct WaveAMDDecomposeMemTuplesPass
    : public wave::impl::WaveAMDDecomposeMemTuplesBase<
          WaveAMDDecomposeMemTuplesPass> {
  void runOnOperation() override {
    ModuleOp module = getOperation();
    SmallVector<Operation *> worklist;
    module.walk([&](Operation *op) {
      if (isa<wavemachine::GlobalLoadTupleB32Op,
              wavemachine::BufferLoadTupleB32Op, wavemachine::DsLoadTupleB32Op,
              wavemachine::GlobalStoreTupleB32Op,
              wavemachine::BufferStoreTupleB32Op,
              wavemachine::DsStoreTupleB32Op>(op))
        worklist.push_back(op);
    });
    for (Operation *op : worklist) {
      LogicalResult r = success();
      if (auto load = dyn_cast<wavemachine::GlobalLoadTupleB32Op>(op))
        r = decomposeGlobalLoad(load);
      else if (auto load = dyn_cast<wavemachine::BufferLoadTupleB32Op>(op))
        r = decomposeBufferLoad(load);
      else if (auto load = dyn_cast<wavemachine::DsLoadTupleB32Op>(op))
        r = decomposeDsLoad(load);
      else if (auto store = dyn_cast<wavemachine::GlobalStoreTupleB32Op>(op))
        r = decomposeGlobalStore(store);
      else if (auto store = dyn_cast<wavemachine::BufferStoreTupleB32Op>(op))
        r = decomposeBufferStore(store);
      else if (auto store = dyn_cast<wavemachine::DsStoreTupleB32Op>(op))
        r = decomposeDsStore(store);
      if (failed(r))
        return signalPassFailure();
    }
  }
};

} // namespace
