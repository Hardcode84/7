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
#include "llvm/ADT/StringRef.h"
#include "llvm/TargetParser/TargetParser.h"

#include <array>

namespace mlir::wave {
#define GEN_PASS_DEF_WAVEAMDDECOMPOSEMEMTUPLES
#include "mlir/Dialect/Wave/Transforms/Passes.h.inc"
} // namespace mlir::wave

using namespace mlir;

namespace {

static wavemachine::RegType vgprNType(MLIRContext *ctx, unsigned width) {
  return wavemachine::RegType::get(ctx, wavemachine::RegClass::VGPR, width,
                                   /*index=*/-1);
}

static wavemachine::MemTokenType memTokenType(MLIRContext *ctx) {
  return wavemachine::MemTokenType::get(ctx);
}

static FailureOr<llvm::AMDGPU::IsaVersion> getIsaVersion(ModuleOp module) {
  auto target = module->getAttrOfType<StringAttr>("wavemachine.target");
  if (!target)
    return module.emitError(
        "waveamd-decompose-mem-tuples requires a wavemachine.target attribute");
  StringRef cpu = target.getValue();
  std::pair<StringRef, StringRef> split = cpu.rsplit("--");
  if (!split.second.empty())
    cpu = split.second;
  llvm::AMDGPU::IsaVersion version = llvm::AMDGPU::getIsaVersion(cpu);
  if (version.Major == 0)
    return module.emitError("unsupported AMDGPU target: ") << target.getValue();
  return version;
}

// Greedy widest-first plan: at each step pick the largest HW-supported
// chunk width that fits the remaining dwords. `b32` is always present,
// so the loop is guaranteed to make progress.
static SmallVector<unsigned>
planChunks(unsigned total, llvm::function_ref<bool(unsigned)> supported) {
  static constexpr std::array<unsigned, 4> kCandidates = {4, 3, 2, 1};
  SmallVector<unsigned> plan;
  unsigned remaining = total;
  while (remaining > 0) {
    unsigned picked = 0;
    for (unsigned w : kCandidates) {
      if (w <= remaining && supported(w)) {
        picked = w;
        break;
      }
    }
    assert(picked > 0 && "b32 must always be a supported chunk width");
    plan.push_back(picked);
    remaining -= picked;
  }
  return plan;
}

template <typename B32, typename B64, typename B96, typename B128>
static bool widthSupported(unsigned width,
                           const llvm::AMDGPU::IsaVersion &isa) {
  switch (width) {
  case 1:
    return B32::isSupportedOnIsa(isa);
  case 2:
    return B64::isSupportedOnIsa(isa);
  case 3:
    return B96::isSupportedOnIsa(isa);
  case 4:
    return B128::isSupportedOnIsa(isa);
  }
  return false;
}

// Per-{address-space, direction} chunk emitters. Each dispatches on the
// chunk width to the right wide op constructor. The op operand shape is
// identical across widths within a family, so the only thing that
// changes is the result-VGPR width and the op type itself.

static Operation *createGlobalLoadChunk(OpBuilder &builder, Location loc,
                                        unsigned width, Type tokenType,
                                        Value off, Value base, Value dep,
                                        int64_t instOffset) {
  Type rt = vgprNType(builder.getContext(), width);
  switch (width) {
  case 1:
    return wavemachine::GlobalLoadB32Op::create(builder, loc, rt, tokenType,
                                                off, base, dep, instOffset);
  case 2:
    return wavemachine::GlobalLoadB64Op::create(builder, loc, rt, tokenType,
                                                off, base, dep, instOffset);
  case 3:
    return wavemachine::GlobalLoadB96Op::create(builder, loc, rt, tokenType,
                                                off, base, dep, instOffset);
  case 4:
    return wavemachine::GlobalLoadB128Op::create(builder, loc, rt, tokenType,
                                                 off, base, dep, instOffset);
  }
  llvm_unreachable("unsupported global load chunk width");
}

static Operation *createGlobalStoreChunk(OpBuilder &builder, Location loc,
                                         unsigned width, Type tokenType,
                                         Value off, Value value, Value base,
                                         Value dep, int64_t instOffset) {
  switch (width) {
  case 1:
    return wavemachine::GlobalStoreB32Op::create(builder, loc, tokenType, off,
                                                 value, base, dep, instOffset);
  case 2:
    return wavemachine::GlobalStoreB64Op::create(builder, loc, tokenType, off,
                                                 value, base, dep, instOffset);
  case 3:
    return wavemachine::GlobalStoreB96Op::create(builder, loc, tokenType, off,
                                                 value, base, dep, instOffset);
  case 4:
    return wavemachine::GlobalStoreB128Op::create(builder, loc, tokenType, off,
                                                  value, base, dep, instOffset);
  }
  llvm_unreachable("unsupported global store chunk width");
}

static Operation *createBufferLoadChunk(OpBuilder &builder, Location loc,
                                        unsigned width, Type tokenType,
                                        Value off, Value desc, Value soffset,
                                        Value dep, int64_t instOffset) {
  Type rt = vgprNType(builder.getContext(), width);
  switch (width) {
  case 1:
    return wavemachine::BufferLoadB32Op::create(
        builder, loc, rt, tokenType, off, desc, soffset, dep, instOffset);
  case 2:
    return wavemachine::BufferLoadB64Op::create(
        builder, loc, rt, tokenType, off, desc, soffset, dep, instOffset);
  case 3:
    return wavemachine::BufferLoadB96Op::create(
        builder, loc, rt, tokenType, off, desc, soffset, dep, instOffset);
  case 4:
    return wavemachine::BufferLoadB128Op::create(
        builder, loc, rt, tokenType, off, desc, soffset, dep, instOffset);
  }
  llvm_unreachable("unsupported buffer load chunk width");
}

static Operation *createBufferStoreChunk(OpBuilder &builder, Location loc,
                                         unsigned width, Type tokenType,
                                         Value off, Value value, Value desc,
                                         Value soffset, Value dep,
                                         int64_t instOffset) {
  switch (width) {
  case 1:
    return wavemachine::BufferStoreB32Op::create(
        builder, loc, tokenType, off, value, desc, soffset, dep, instOffset);
  case 2:
    return wavemachine::BufferStoreB64Op::create(
        builder, loc, tokenType, off, value, desc, soffset, dep, instOffset);
  case 3:
    return wavemachine::BufferStoreB96Op::create(
        builder, loc, tokenType, off, value, desc, soffset, dep, instOffset);
  case 4:
    return wavemachine::BufferStoreB128Op::create(
        builder, loc, tokenType, off, value, desc, soffset, dep, instOffset);
  }
  llvm_unreachable("unsupported buffer store chunk width");
}

static Operation *createDsLoadChunk(OpBuilder &builder, Location loc,
                                    unsigned width, Type tokenType, Value addr,
                                    Value dep, int64_t instOffset) {
  Type rt = vgprNType(builder.getContext(), width);
  switch (width) {
  case 1:
    return wavemachine::DsLoadB32Op::create(builder, loc, rt, tokenType, addr,
                                            dep, instOffset);
  case 2:
    return wavemachine::DsLoadB64Op::create(builder, loc, rt, tokenType, addr,
                                            dep, instOffset);
  case 3:
    return wavemachine::DsLoadB96Op::create(builder, loc, rt, tokenType, addr,
                                            dep, instOffset);
  case 4:
    return wavemachine::DsLoadB128Op::create(builder, loc, rt, tokenType, addr,
                                             dep, instOffset);
  }
  llvm_unreachable("unsupported ds load chunk width");
}

static Operation *createDsStoreChunk(OpBuilder &builder, Location loc,
                                     unsigned width, Type tokenType, Value addr,
                                     Value value, Value dep,
                                     int64_t instOffset) {
  switch (width) {
  case 1:
    return wavemachine::DsStoreB32Op::create(builder, loc, tokenType, addr,
                                             value, dep, instOffset);
  case 2:
    return wavemachine::DsStoreB64Op::create(builder, loc, tokenType, addr,
                                             value, dep, instOffset);
  case 3:
    return wavemachine::DsStoreB96Op::create(builder, loc, tokenType, addr,
                                             value, dep, instOffset);
  case 4:
    return wavemachine::DsStoreB128Op::create(builder, loc, tokenType, addr,
                                              value, dep, instOffset);
  }
  llvm_unreachable("unsupported ds store chunk width");
}

// Gather chunked load results into the original tuple's shape via
// `tuple_from_elements` (mixed-width pieces allowed) and join the
// per-chunk tokens into the single token the caller expected.
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

// Split the tuple value into pieces matching `plan` (one element per
// chunk, widened to the chunk's width) so the per-chunk stores can
// consume them.
static SmallVector<Value> splitTupleByPlan(OpBuilder &builder, Operation *op,
                                           Value tuple,
                                           ArrayRef<unsigned> plan) {
  MLIRContext *ctx = op->getContext();
  SmallVector<Type> elementTypes;
  elementTypes.reserve(plan.size());
  for (unsigned w : plan)
    elementTypes.push_back(vgprNType(ctx, w));
  auto split = wavemachine::TupleToElementsOp::create(builder, op->getLoc(),
                                                      elementTypes, tuple);
  return SmallVector<Value>(split.getElements().begin(),
                            split.getElements().end());
}

static LogicalResult decomposeGlobalLoad(wavemachine::GlobalLoadTupleB32Op op,
                                         const llvm::AMDGPU::IsaVersion &isa) {
  OpBuilder builder(op);
  unsigned width =
      cast<wavemachine::RegType>(op.getResult().getType()).getWidth();
  SmallVector<unsigned> plan = planChunks(width, [&](unsigned w) {
    return widthSupported<
        wavemachine::GlobalLoadB32Op, wavemachine::GlobalLoadB64Op,
        wavemachine::GlobalLoadB96Op, wavemachine::GlobalLoadB128Op>(w, isa);
  });
  Type tokenType = memTokenType(op.getContext());
  int64_t baseInstOffset = op.getInstOffset();
  Value dep = op.getDependency();
  SmallVector<Value> elements;
  SmallVector<Value> tokens;
  elements.reserve(plan.size());
  tokens.reserve(plan.size());
  int64_t cumByteOffset = 0;
  for (unsigned w : plan) {
    Operation *chunk = createGlobalLoadChunk(builder, op.getLoc(), w, tokenType,
                                             op.getOffset(), op.getBase(), dep,
                                             baseInstOffset + cumByteOffset);
    elements.push_back(chunk->getResult(0));
    tokens.push_back(chunk->getResult(1));
    cumByteOffset += static_cast<int64_t>(w) * 4;
  }
  Value tokenResult = op.getTokens().empty() ? Value{} : op.getTokens().front();
  finalizeLoadDecomposition(op, op.getResult(), tokenResult, elements, tokens);
  return success();
}

static LogicalResult decomposeBufferLoad(wavemachine::BufferLoadTupleB32Op op,
                                         const llvm::AMDGPU::IsaVersion &isa) {
  OpBuilder builder(op);
  unsigned width =
      cast<wavemachine::RegType>(op.getResult().getType()).getWidth();
  SmallVector<unsigned> plan = planChunks(width, [&](unsigned w) {
    return widthSupported<
        wavemachine::BufferLoadB32Op, wavemachine::BufferLoadB64Op,
        wavemachine::BufferLoadB96Op, wavemachine::BufferLoadB128Op>(w, isa);
  });
  Type tokenType = memTokenType(op.getContext());
  int64_t baseInstOffset = op.getInstOffset();
  Value dep = op.getDependency();
  SmallVector<Value> elements;
  SmallVector<Value> tokens;
  elements.reserve(plan.size());
  tokens.reserve(plan.size());
  int64_t cumByteOffset = 0;
  for (unsigned w : plan) {
    Operation *chunk = createBufferLoadChunk(
        builder, op.getLoc(), w, tokenType, op.getOffset(), op.getDescriptor(),
        op.getSoffset(), dep, baseInstOffset + cumByteOffset);
    elements.push_back(chunk->getResult(0));
    tokens.push_back(chunk->getResult(1));
    cumByteOffset += static_cast<int64_t>(w) * 4;
  }
  Value tokenResult = op.getTokens().empty() ? Value{} : op.getTokens().front();
  finalizeLoadDecomposition(op, op.getResult(), tokenResult, elements, tokens);
  return success();
}

static LogicalResult decomposeDsLoad(wavemachine::DsLoadTupleB32Op op,
                                     const llvm::AMDGPU::IsaVersion &isa) {
  OpBuilder builder(op);
  unsigned width =
      cast<wavemachine::RegType>(op.getResult().getType()).getWidth();
  SmallVector<unsigned> plan = planChunks(width, [&](unsigned w) {
    return widthSupported<wavemachine::DsLoadB32Op, wavemachine::DsLoadB64Op,
                          wavemachine::DsLoadB96Op, wavemachine::DsLoadB128Op>(
        w, isa);
  });
  Type tokenType = memTokenType(op.getContext());
  int64_t baseOffset = op.getOffset();
  Value dep = op.getDependency();
  SmallVector<Value> elements;
  SmallVector<Value> tokens;
  elements.reserve(plan.size());
  tokens.reserve(plan.size());
  int64_t cumByteOffset = 0;
  for (unsigned w : plan) {
    Operation *chunk =
        createDsLoadChunk(builder, op.getLoc(), w, tokenType, op.getAddr(), dep,
                          baseOffset + cumByteOffset);
    elements.push_back(chunk->getResult(0));
    tokens.push_back(chunk->getResult(1));
    cumByteOffset += static_cast<int64_t>(w) * 4;
  }
  Value tokenResult = op.getTokens().empty() ? Value{} : op.getTokens().front();
  finalizeLoadDecomposition(op, op.getResult(), tokenResult, elements, tokens);
  return success();
}

static LogicalResult decomposeGlobalStore(wavemachine::GlobalStoreTupleB32Op op,
                                          const llvm::AMDGPU::IsaVersion &isa) {
  OpBuilder builder(op);
  unsigned width =
      cast<wavemachine::RegType>(op.getValue().getType()).getWidth();
  SmallVector<unsigned> plan = planChunks(width, [&](unsigned w) {
    return widthSupported<
        wavemachine::GlobalStoreB32Op, wavemachine::GlobalStoreB64Op,
        wavemachine::GlobalStoreB96Op, wavemachine::GlobalStoreB128Op>(w, isa);
  });
  SmallVector<Value> elements =
      splitTupleByPlan(builder, op, op.getValue(), plan);
  Type tokenType = memTokenType(op.getContext());
  int64_t baseInstOffset = op.getInstOffset();
  Value dep = op.getDependency();
  SmallVector<Value> tokens;
  tokens.reserve(plan.size());
  int64_t cumByteOffset = 0;
  for (auto [w, element] : llvm::zip(plan, elements)) {
    Operation *chunk = createGlobalStoreChunk(
        builder, op.getLoc(), w, tokenType, op.getOffset(), element,
        op.getBase(), dep, baseInstOffset + cumByteOffset);
    tokens.push_back(chunk->getResult(0));
    cumByteOffset += static_cast<int64_t>(w) * 4;
  }
  Value tokenResult = op.getTokens().empty() ? Value{} : op.getTokens().front();
  finalizeStoreDecomposition(op, tokenResult, tokens);
  return success();
}

static LogicalResult decomposeBufferStore(wavemachine::BufferStoreTupleB32Op op,
                                          const llvm::AMDGPU::IsaVersion &isa) {
  OpBuilder builder(op);
  unsigned width =
      cast<wavemachine::RegType>(op.getValue().getType()).getWidth();
  SmallVector<unsigned> plan = planChunks(width, [&](unsigned w) {
    return widthSupported<
        wavemachine::BufferStoreB32Op, wavemachine::BufferStoreB64Op,
        wavemachine::BufferStoreB96Op, wavemachine::BufferStoreB128Op>(w, isa);
  });
  SmallVector<Value> elements =
      splitTupleByPlan(builder, op, op.getValue(), plan);
  Type tokenType = memTokenType(op.getContext());
  int64_t baseInstOffset = op.getInstOffset();
  Value dep = op.getDependency();
  SmallVector<Value> tokens;
  tokens.reserve(plan.size());
  int64_t cumByteOffset = 0;
  for (auto [w, element] : llvm::zip(plan, elements)) {
    Operation *chunk = createBufferStoreChunk(
        builder, op.getLoc(), w, tokenType, op.getOffset(), element,
        op.getDescriptor(), op.getSoffset(), dep,
        baseInstOffset + cumByteOffset);
    tokens.push_back(chunk->getResult(0));
    cumByteOffset += static_cast<int64_t>(w) * 4;
  }
  Value tokenResult = op.getTokens().empty() ? Value{} : op.getTokens().front();
  finalizeStoreDecomposition(op, tokenResult, tokens);
  return success();
}

static LogicalResult decomposeDsStore(wavemachine::DsStoreTupleB32Op op,
                                      const llvm::AMDGPU::IsaVersion &isa) {
  OpBuilder builder(op);
  unsigned width =
      cast<wavemachine::RegType>(op.getValue().getType()).getWidth();
  SmallVector<unsigned> plan = planChunks(width, [&](unsigned w) {
    return widthSupported<wavemachine::DsStoreB32Op, wavemachine::DsStoreB64Op,
                          wavemachine::DsStoreB96Op,
                          wavemachine::DsStoreB128Op>(w, isa);
  });
  SmallVector<Value> elements =
      splitTupleByPlan(builder, op, op.getValue(), plan);
  Type tokenType = memTokenType(op.getContext());
  int64_t baseOffset = op.getOffset();
  Value dep = op.getDependency();
  SmallVector<Value> tokens;
  tokens.reserve(plan.size());
  int64_t cumByteOffset = 0;
  for (auto [w, element] : llvm::zip(plan, elements)) {
    Operation *chunk =
        createDsStoreChunk(builder, op.getLoc(), w, tokenType, op.getAddr(),
                           element, dep, baseOffset + cumByteOffset);
    tokens.push_back(chunk->getResult(0));
    cumByteOffset += static_cast<int64_t>(w) * 4;
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
    FailureOr<llvm::AMDGPU::IsaVersion> isaVer = getIsaVersion(module);
    if (failed(isaVer))
      return signalPassFailure();
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
      if (failed(decomposeOne(op, *isaVer)))
        return signalPassFailure();
    }
  }

  static LogicalResult decomposeOne(Operation *op,
                                    const llvm::AMDGPU::IsaVersion &isaVer) {
    if (auto load = dyn_cast<wavemachine::GlobalLoadTupleB32Op>(op))
      return decomposeGlobalLoad(load, isaVer);
    if (auto load = dyn_cast<wavemachine::BufferLoadTupleB32Op>(op))
      return decomposeBufferLoad(load, isaVer);
    if (auto load = dyn_cast<wavemachine::DsLoadTupleB32Op>(op))
      return decomposeDsLoad(load, isaVer);
    if (auto store = dyn_cast<wavemachine::GlobalStoreTupleB32Op>(op))
      return decomposeGlobalStore(store, isaVer);
    if (auto store = dyn_cast<wavemachine::BufferStoreTupleB32Op>(op))
      return decomposeBufferStore(store, isaVer);
    if (auto store = dyn_cast<wavemachine::DsStoreTupleB32Op>(op))
      return decomposeDsStore(store, isaVer);
    return success();
  }
};

} // namespace
