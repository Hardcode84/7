//===- WaveAMDDmaZeroFill.cpp - predicated DMA zero-fill -------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/Wave/Transforms/Passes.h"

#include "WaveAMDBufferPredicationUtils.h"

#include "mlir/Dialect/Wave/IR/Wave.h"
#include "mlir/Dialect/Wave/IR/WaveAMD.h"
#include "mlir/IR/PatternMatch.h"
#include "mlir/Interfaces/SideEffectInterfaces.h"
#include "llvm/ADT/STLExtras.h"

namespace mlir::wave {
#define GEN_PASS_DEF_WAVEAMDDMAZEROFILL
#include "mlir/Dialect/Wave/Transforms/Passes.h.inc"
} // namespace mlir::wave

using namespace mlir;
using namespace mlir::wave;

namespace {

static bool isZeroFillDma(waveamd::DmaLoadLdsOp op) {
  return op.getZeroFillInactive().value_or(false);
}

static bool canMoveOut(Operation *op,
                       SmallVectorImpl<waveamd::DmaLoadLdsOp> &dmas) {
  if (isa<YieldOp>(op))
    return true;
  if (auto dma = dyn_cast<waveamd::DmaLoadLdsOp>(op)) {
    if (!isZeroFillDma(dma))
      return false;
    dmas.push_back(dma);
    return succeeded(buffer_predication::findBufferSentinel(dma.getSource()));
  }
  if (op->getNumRegions() != 0)
    return false;
  return isMemoryEffectFree(op) && isSpeculatable(op);
}

static bool hasValidOtherwise(WhereOp where, Operation *terminator,
                              ArrayRef<waveamd::DmaLoadLdsOp> dmas) {
  Region &otherwise = where.getElseRegion();
  if (otherwise.empty())
    return true;
  auto thenYield = cast<YieldOp>(terminator);
  if (dmas.size() != 1 || thenYield.getValues().size() != 1)
    return false;
  waveamd::DmaLoadLdsOp dma = dmas.front();
  if (thenYield.getValues().front() != dma.getToken() ||
      !llvm::hasSingleElement(otherwise) ||
      !llvm::hasSingleElement(otherwise.front()))
    return false;
  auto elseYield = dyn_cast<YieldOp>(otherwise.front().getTerminator());
  return elseYield && elseYield.getValues().size() == 1 &&
         elseYield.getValues().front() == dma.getDependency();
}

static bool collectMovableBody(WhereOp where, SmallVectorImpl<Operation *> &ops,
                               SmallVectorImpl<waveamd::DmaLoadLdsOp> &dmas) {
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
  if (dmas.empty())
    return false;
  return hasValidOtherwise(where, terminator, dmas);
}

static FailureOr<Value> createSelectedSource(IRRewriter &rewriter,
                                             waveamd::DmaLoadLdsOp dma,
                                             Value condition) {
  return buffer_predication::createOOBSelectedBufferPointer(
      rewriter, dma.getLoc(), dma.getSource(), condition);
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
    rewriter.modifyOpInPlace(dma, [&] {
      dma->setOperand(0, *source);
      dma.setZeroFillInactive(false);
    });
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
