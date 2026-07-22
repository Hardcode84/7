//===- WaveAMDDmaZeroFill.cpp - predicated DMA zero-fill -------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/Wave/Transforms/Passes.h"

#include "mlir/Dialect/SCF/IR/SCF.h"
#include "mlir/Dialect/Wave/IR/Wave.h"
#include "mlir/Dialect/Wave/IR/WaveAMD.h"
#include "mlir/IR/PatternMatch.h"
#include "mlir/Interfaces/SideEffectInterfaces.h"
#include "llvm/ADT/DenseSet.h"
#include "llvm/ADT/STLExtras.h"

namespace mlir::wave {
#define GEN_PASS_DEF_WAVEAMDDMAZEROFILL
#include "mlir/Dialect/Wave/Transforms/Passes.h.inc"
} // namespace mlir::wave

using namespace mlir;
using namespace mlir::wave;

namespace {

struct BufferSentinel {
  Value base;
  Value range;
};

static bool isZeroFillDma(waveamd::DmaLoadLdsOp op) {
  return op.getZeroFillInactive().value_or(false);
}

static bool isBufferSimdPointer(Type type) {
  auto simdType = dyn_cast<SimdType>(type);
  if (!simdType)
    return false;
  auto ptrType = dyn_cast<PtrType>(simdType.getElementType());
  return ptrType &&
         isa<waveamd::BufferAddressSpaceAttr>(ptrType.getAddressSpace());
}

static Value stripPtrAdds(Value value) {
  while (auto add = value.getDefiningOp<PtrAddOp>())
    value = add.getBase();
  return value;
}

static waveamd::MakeBufferOp findMakeBuffer(Value value) {
  while (true) {
    if (auto makeBuffer = value.getDefiningOp<waveamd::MakeBufferOp>())
      return makeBuffer;
    if (auto add = value.getDefiningOp<PtrAddOp>()) {
      value = add.getBase();
      continue;
    }
    if (auto cast = value.getDefiningOp<PtrCastOp>()) {
      value = cast.getSource();
      continue;
    }
    return {};
  }
}

static FailureOr<BufferSentinel> findBufferSentinel(Value source,
                                                    DenseSet<Value> &seen);

static FailureOr<BufferSentinel>
findScfForIterArgBufferSentinel(BlockArgument arg, DenseSet<Value> &seen) {
  auto loop = dyn_cast<scf::ForOp>(arg.getOwner()->getParentOp());
  if (!loop)
    return failure();
  if (arg.getArgNumber() == 0)
    return failure();

  unsigned iterIndex = arg.getArgNumber() - 1;
  if (iterIndex >= loop.getNumRegionIterArgs())
    return failure();
  return findBufferSentinel(loop.getInitArgs()[iterIndex], seen);
}

static FailureOr<BufferSentinel> findBufferSentinel(Value source,
                                                    DenseSet<Value> &seen) {
  if (!seen.insert(source).second)
    return failure();
  if (!isBufferSimdPointer(source.getType()))
    return failure();
  Value base = stripPtrAdds(source);
  if (auto arg = dyn_cast<BlockArgument>(base))
    return findScfForIterArgBufferSentinel(arg, seen);
  if (!isa<PtrType>(base.getType()))
    return failure();
  waveamd::MakeBufferOp makeBuffer = findMakeBuffer(base);
  if (!makeBuffer)
    return failure();
  return BufferSentinel{base, makeBuffer.getRange()};
}

static FailureOr<BufferSentinel> findBufferSentinel(Value source) {
  DenseSet<Value> seen;
  return findBufferSentinel(source, seen);
}

static bool canMoveOut(Operation *op,
                       SmallVectorImpl<waveamd::DmaLoadLdsOp> &dmas) {
  if (isa<YieldOp>(op))
    return true;
  if (auto dma = dyn_cast<waveamd::DmaLoadLdsOp>(op)) {
    if (!isZeroFillDma(dma))
      return false;
    dmas.push_back(dma);
    return succeeded(findBufferSentinel(dma.getSource()));
  }
  if (op->getNumRegions() != 0)
    return false;
  return isMemoryEffectFree(op) && isSpeculatable(op);
}

static bool collectMovableBody(WhereOp where, SmallVectorImpl<Operation *> &ops,
                               SmallVectorImpl<waveamd::DmaLoadLdsOp> &dmas) {
  if (!where.getElseRegion().empty())
    return false;
  if (where.getNumResults() > 1)
    return false;
  if (where.getNumResults() == 1 &&
      !isa<MemTokenType>(where.getResult(0).getType()))
    return false;

  Block &block = where.getThenRegion().front();
  Operation *terminator = block.getTerminator();
  for (Operation &op : block) {
    if (&op == terminator)
      break;
    if (!canMoveOut(&op, dmas))
      return false;
    ops.push_back(&op);
  }
  return !dmas.empty();
}

static FailureOr<Value> createSelectedSource(IRRewriter &rewriter,
                                             waveamd::DmaLoadLdsOp dma,
                                             Value condition) {
  FailureOr<BufferSentinel> sentinel = findBufferSentinel(dma.getSource());
  if (failed(sentinel))
    return failure();

  Location loc = dma.getLoc();
  auto simdType = cast<SimdType>(dma.getSource().getType());
  auto baseType = cast<PtrType>(sentinel->base.getType());
  Type i8 = rewriter.getI8Type();
  Type byteBaseType =
      PtrType::get(dma.getContext(), i8, baseType.getAddressSpace());
  Type byteSourceType =
      SimdType::get(dma.getContext(), byteBaseType, simdType.getWidth());

  Value byteBase = sentinel->base;
  if (byteBase.getType() != byteBaseType)
    byteBase = PtrCastOp::create(rewriter, loc, byteBaseType, byteBase);

  Type offsetType = SimdType::get(dma.getContext(), sentinel->range.getType(),
                                  simdType.getWidth());
  Value offset = SplatOp::create(rewriter, loc, offsetType, sentinel->range);
  Value oob = PtrAddOp::create(rewriter, loc, byteSourceType, byteBase, offset);
  if (oob.getType() != dma.getSource().getType())
    oob = PtrCastOp::create(rewriter, loc, dma.getSource().getType(), oob);
  return SelectOp::create(rewriter, loc, dma.getSource().getType(), condition,
                          dma.getSource(), oob)
      .getResult();
}

static bool rewriteWhere(IRRewriter &rewriter, WhereOp where) {
  if (where.getConditions().size() != 1)
    return false;
  SmallVector<Operation *> ops;
  SmallVector<waveamd::DmaLoadLdsOp> dmas;
  if (!collectMovableBody(where, ops, dmas))
    return false;

  YieldOp yield = cast<YieldOp>(where.getThenRegion().front().getTerminator());
  SmallVector<Value> results(yield.getValues());
  for (Operation *op : ops)
    op->moveBefore(where);

  for (waveamd::DmaLoadLdsOp dma : dmas) {
    rewriter.setInsertionPoint(dma);
    FailureOr<Value> source =
        createSelectedSource(rewriter, dma, where.getCondition());
    if (failed(source))
      return false;
    dma->setOperand(0, *source);
  }

  rewriter.replaceOp(where, results);
  return true;
}

struct WaveAMDDmaZeroFillPass
    : public wave::impl::WaveAMDDmaZeroFillBase<WaveAMDDmaZeroFillPass> {
  void runOnOperation() override {
    IRRewriter rewriter(&getContext());
    SmallVector<WhereOp> wheres;
    getOperation()->walk([&](WhereOp where) { wheres.push_back(where); });

    for (WhereOp where : llvm::reverse(wheres)) {
      if (!where->getBlock())
        continue;
      (void)rewriteWhere(rewriter, where);
    }
  }
};

} // namespace
