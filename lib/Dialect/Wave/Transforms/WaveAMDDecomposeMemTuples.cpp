//===- WaveAMDDecomposeMemTuples.cpp - tuple-mem decomposition --*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/Wave/Transforms/Passes.h"

#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachine.h"
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

static waveamdmachine::RegType vgprNType(MLIRContext *ctx, unsigned width) {
  return waveamdmachine::RegType::get(ctx, waveamdmachine::RegClass::VGPR,
                                      width,
                                      /*index=*/-1);
}

static waveamdmachine::MemTokenType memTokenType(MLIRContext *ctx) {
  return waveamdmachine::MemTokenType::get(ctx);
}

static ModuleOp findTargetModule(Operation *op) {
  ModuleOp module = op->getParentOfType<ModuleOp>();
  if (!module)
    module = dyn_cast<ModuleOp>(op);
  while (module && !module->hasAttr("waveamdmachine.target"))
    module = module->getParentOfType<ModuleOp>();
  return module;
}

static FailureOr<llvm::AMDGPU::IsaVersion> getIsaVersion(Operation *root) {
  ModuleOp module = findTargetModule(root);
  if (!module)
    return root->emitError("waveamd-decompose-mem-tuples requires a "
                           "waveamdmachine.target module attribute");
  auto target = module->getAttrOfType<StringAttr>("waveamdmachine.target");
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
    return waveamdmachine::GlobalLoadB32Op::create(builder, loc, rt, tokenType,
                                                   off, base, dep, instOffset);
  case 2:
    return waveamdmachine::GlobalLoadB64Op::create(builder, loc, rt, tokenType,
                                                   off, base, dep, instOffset);
  case 3:
    return waveamdmachine::GlobalLoadB96Op::create(builder, loc, rt, tokenType,
                                                   off, base, dep, instOffset);
  case 4:
    return waveamdmachine::GlobalLoadB128Op::create(builder, loc, rt, tokenType,
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
    return waveamdmachine::GlobalStoreB32Op::create(
        builder, loc, tokenType, off, value, base, dep, instOffset);
  case 2:
    return waveamdmachine::GlobalStoreB64Op::create(
        builder, loc, tokenType, off, value, base, dep, instOffset);
  case 3:
    return waveamdmachine::GlobalStoreB96Op::create(
        builder, loc, tokenType, off, value, base, dep, instOffset);
  case 4:
    return waveamdmachine::GlobalStoreB128Op::create(
        builder, loc, tokenType, off, value, base, dep, instOffset);
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
    return waveamdmachine::BufferLoadB32Op::create(
        builder, loc, rt, tokenType, off, desc, soffset, dep, instOffset);
  case 2:
    return waveamdmachine::BufferLoadB64Op::create(
        builder, loc, rt, tokenType, off, desc, soffset, dep, instOffset);
  case 3:
    return waveamdmachine::BufferLoadB96Op::create(
        builder, loc, rt, tokenType, off, desc, soffset, dep, instOffset);
  case 4:
    return waveamdmachine::BufferLoadB128Op::create(
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
    return waveamdmachine::BufferStoreB32Op::create(
        builder, loc, tokenType, off, value, desc, soffset, dep, instOffset);
  case 2:
    return waveamdmachine::BufferStoreB64Op::create(
        builder, loc, tokenType, off, value, desc, soffset, dep, instOffset);
  case 3:
    return waveamdmachine::BufferStoreB96Op::create(
        builder, loc, tokenType, off, value, desc, soffset, dep, instOffset);
  case 4:
    return waveamdmachine::BufferStoreB128Op::create(
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
    return waveamdmachine::DsLoadB32Op::create(builder, loc, rt, tokenType,
                                               addr, dep, instOffset);
  case 2:
    return waveamdmachine::DsLoadB64Op::create(builder, loc, rt, tokenType,
                                               addr, dep, instOffset);
  case 3:
    return waveamdmachine::DsLoadB96Op::create(builder, loc, rt, tokenType,
                                               addr, dep, instOffset);
  case 4:
    return waveamdmachine::DsLoadB128Op::create(builder, loc, rt, tokenType,
                                                addr, dep, instOffset);
  }
  llvm_unreachable("unsupported ds load chunk width");
}

static Operation *createDsStoreChunk(OpBuilder &builder, Location loc,
                                     unsigned width, Type tokenType, Value addr,
                                     Value value, Value dep,
                                     int64_t instOffset) {
  switch (width) {
  case 1:
    return waveamdmachine::DsStoreB32Op::create(builder, loc, tokenType, addr,
                                                value, dep, instOffset);
  case 2:
    return waveamdmachine::DsStoreB64Op::create(builder, loc, tokenType, addr,
                                                value, dep, instOffset);
  case 3:
    return waveamdmachine::DsStoreB96Op::create(builder, loc, tokenType, addr,
                                                value, dep, instOffset);
  case 4:
    return waveamdmachine::DsStoreB128Op::create(builder, loc, tokenType, addr,
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
  auto tupleFromElements = waveamdmachine::TupleFromElementsOp::create(
      builder, op->getLoc(), tupleResult.getType(), elements);
  tupleResult.replaceAllUsesWith(tupleFromElements.getTuple());
  if (tokenResult) {
    auto tokenJoin = waveamdmachine::TokenJoinOp::create(builder, op->getLoc(),
                                                         tokenType, tokens);
    tokenResult.replaceAllUsesWith(tokenJoin.getResult());
  }
  op->erase();
}

static void finalizeStoreDecomposition(Operation *op, Value tokenResult,
                                       ArrayRef<Value> tokens) {
  OpBuilder builder(op);
  Type tokenType = memTokenType(op->getContext());
  auto tokenJoin = waveamdmachine::TokenJoinOp::create(builder, op->getLoc(),
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
  auto split = waveamdmachine::TupleToElementsOp::create(builder, op->getLoc(),
                                                         elementTypes, tuple);
  return SmallVector<Value>(split.getElements().begin(),
                            split.getElements().end());
}

static LogicalResult
decomposeGlobalLoad(waveamdmachine::GlobalLoadTupleB32Op op,
                    const llvm::AMDGPU::IsaVersion &isa) {
  OpBuilder builder(op);
  unsigned width =
      cast<waveamdmachine::RegType>(op.getResult().getType()).getWidth();
  SmallVector<unsigned> plan = planChunks(width, [&](unsigned w) {
    return widthSupported<
        waveamdmachine::GlobalLoadB32Op, waveamdmachine::GlobalLoadB64Op,
        waveamdmachine::GlobalLoadB96Op, waveamdmachine::GlobalLoadB128Op>(w,
                                                                           isa);
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

static LogicalResult
decomposeBufferLoad(waveamdmachine::BufferLoadTupleB32Op op,
                    const llvm::AMDGPU::IsaVersion &isa) {
  OpBuilder builder(op);
  unsigned width =
      cast<waveamdmachine::RegType>(op.getResult().getType()).getWidth();
  SmallVector<unsigned> plan = planChunks(width, [&](unsigned w) {
    return widthSupported<
        waveamdmachine::BufferLoadB32Op, waveamdmachine::BufferLoadB64Op,
        waveamdmachine::BufferLoadB96Op, waveamdmachine::BufferLoadB128Op>(w,
                                                                           isa);
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

static LogicalResult decomposeDsLoad(waveamdmachine::DsLoadTupleB32Op op,
                                     const llvm::AMDGPU::IsaVersion &isa) {
  OpBuilder builder(op);
  unsigned width =
      cast<waveamdmachine::RegType>(op.getResult().getType()).getWidth();
  SmallVector<unsigned> plan = planChunks(width, [&](unsigned w) {
    return widthSupported<
        waveamdmachine::DsLoadB32Op, waveamdmachine::DsLoadB64Op,
        waveamdmachine::DsLoadB96Op, waveamdmachine::DsLoadB128Op>(w, isa);
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

static LogicalResult
decomposeGlobalStore(waveamdmachine::GlobalStoreTupleB32Op op,
                     const llvm::AMDGPU::IsaVersion &isa) {
  OpBuilder builder(op);
  unsigned width =
      cast<waveamdmachine::RegType>(op.getValue().getType()).getWidth();
  SmallVector<unsigned> plan = planChunks(width, [&](unsigned w) {
    return widthSupported<
        waveamdmachine::GlobalStoreB32Op, waveamdmachine::GlobalStoreB64Op,
        waveamdmachine::GlobalStoreB96Op, waveamdmachine::GlobalStoreB128Op>(
        w, isa);
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

static LogicalResult
decomposeBufferStore(waveamdmachine::BufferStoreTupleB32Op op,
                     const llvm::AMDGPU::IsaVersion &isa) {
  OpBuilder builder(op);
  unsigned width =
      cast<waveamdmachine::RegType>(op.getValue().getType()).getWidth();
  SmallVector<unsigned> plan = planChunks(width, [&](unsigned w) {
    return widthSupported<
        waveamdmachine::BufferStoreB32Op, waveamdmachine::BufferStoreB64Op,
        waveamdmachine::BufferStoreB96Op, waveamdmachine::BufferStoreB128Op>(
        w, isa);
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

static LogicalResult decomposeDsStore(waveamdmachine::DsStoreTupleB32Op op,
                                      const llvm::AMDGPU::IsaVersion &isa) {
  OpBuilder builder(op);
  unsigned width =
      cast<waveamdmachine::RegType>(op.getValue().getType()).getWidth();
  SmallVector<unsigned> plan = planChunks(width, [&](unsigned w) {
    return widthSupported<
        waveamdmachine::DsStoreB32Op, waveamdmachine::DsStoreB64Op,
        waveamdmachine::DsStoreB96Op, waveamdmachine::DsStoreB128Op>(w, isa);
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
    Operation *root = getOperation();
    FailureOr<llvm::AMDGPU::IsaVersion> isaVer = getIsaVersion(root);
    if (failed(isaVer))
      return signalPassFailure();
    SmallVector<Operation *> worklist;
    root->walk([&](Operation *op) {
      if (isa<waveamdmachine::GlobalLoadTupleB32Op,
              waveamdmachine::BufferLoadTupleB32Op,
              waveamdmachine::DsLoadTupleB32Op,
              waveamdmachine::GlobalStoreTupleB32Op,
              waveamdmachine::BufferStoreTupleB32Op,
              waveamdmachine::DsStoreTupleB32Op>(op))
        worklist.push_back(op);
    });
    for (Operation *op : worklist) {
      if (failed(decomposeOne(op, *isaVer)))
        return signalPassFailure();
    }
  }

  static LogicalResult decomposeOne(Operation *op,
                                    const llvm::AMDGPU::IsaVersion &isaVer) {
    if (auto load = dyn_cast<waveamdmachine::GlobalLoadTupleB32Op>(op))
      return decomposeGlobalLoad(load, isaVer);
    if (auto load = dyn_cast<waveamdmachine::BufferLoadTupleB32Op>(op))
      return decomposeBufferLoad(load, isaVer);
    if (auto load = dyn_cast<waveamdmachine::DsLoadTupleB32Op>(op))
      return decomposeDsLoad(load, isaVer);
    if (auto store = dyn_cast<waveamdmachine::GlobalStoreTupleB32Op>(op))
      return decomposeGlobalStore(store, isaVer);
    if (auto store = dyn_cast<waveamdmachine::BufferStoreTupleB32Op>(op))
      return decomposeBufferStore(store, isaVer);
    if (auto store = dyn_cast<waveamdmachine::DsStoreTupleB32Op>(op))
      return decomposeDsStore(store, isaVer);
    return success();
  }
};

} // namespace
