//===- WaveCoalesceWhere.cpp - merge same-mask regions --------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/Wave/Transforms/Passes.h"

#include "mlir/Dialect/Wave/IR/Wave.h"
#include "mlir/IR/PatternMatch.h"
#include "mlir/Interfaces/SideEffectInterfaces.h"
#include "llvm/ADT/DenseSet.h"
#include "llvm/ADT/STLExtras.h"

namespace mlir::wave {
#define GEN_PASS_DEF_WAVECOALESCEWHERE
#include "mlir/Dialect/Wave/Transforms/Passes.h.inc"
} // namespace mlir::wave

using namespace mlir;
using namespace mlir::wave;

namespace {

static bool isMovableGapOp(Operation *op) {
  // Cross-lane results depend on ambient EXEC, not operand SSA alone.
  if (isa<BallotOp, ReadFirstOp, ShuffleOp>(op))
    return false;
  if (op->getNumRegions() != 0)
    return false;
  return isMemoryEffectFree(op) && isSpeculatable(op);
}

static bool isGapOrSecondUse(Operation *user, const DenseSet<Operation *> &gap,
                             WhereOp second) {
  return gap.contains(user) || second->isProperAncestor(user);
}

struct GapPlan {
  SmallVector<Operation *> hoist;
  SmallVector<Operation *> sink;
};

static void collectEscapingOps(WhereOp second, ArrayRef<Operation *> gapOps,
                               const DenseSet<Operation *> &gap,
                               DenseSet<Operation *> &hoist,
                               SmallVectorImpl<Operation *> &worklist) {
  for (Operation *op : gapOps)
    for (Value result : op->getResults())
      for (Operation *user : result.getUsers())
        if (!isGapOrSecondUse(user, gap, second) && hoist.insert(op).second)
          worklist.push_back(op);
}

static bool closeHoistDependencies(WhereOp first,
                                   const DenseSet<Operation *> &gap,
                                   DenseSet<Operation *> &hoist,
                                   SmallVectorImpl<Operation *> &worklist) {
  DenseSet<Value> firstResults(first.getResults().begin(),
                               first.getResults().end());
  while (!worklist.empty()) {
    Operation *op = worklist.pop_back_val();
    for (Value operand : op->getOperands()) {
      if (firstResults.contains(operand))
        return false;
      Operation *def = operand.getDefiningOp();
      if (def && gap.contains(def) && hoist.insert(def).second)
        worklist.push_back(def);
    }
  }
  return true;
}

static void partitionGapOps(ArrayRef<Operation *> gapOps,
                            const DenseSet<Operation *> &hoist, GapPlan &plan) {
  for (Operation *op : gapOps)
    (hoist.contains(op) ? plan.hoist : plan.sink).push_back(op);
}

static bool planGapOps(WhereOp first, WhereOp second,
                       ArrayRef<Operation *> gapOps, GapPlan &plan) {
  DenseSet<Operation *> gap(gapOps.begin(), gapOps.end());
  DenseSet<Operation *> hoist;
  SmallVector<Operation *> worklist;
  collectEscapingOps(second, gapOps, gap, hoist, worklist);
  if (!closeHoistDependencies(first, gap, hoist, worklist))
    return false;
  partitionGapOps(gapOps, hoist, plan);
  return true;
}

static bool canMerge(WhereOp first, WhereOp second,
                     ArrayRef<Operation *> gapOps, GapPlan &plan) {
  if (first.getCondition() != second.getCondition())
    return false;
  if (!first.getElseRegion().empty() || !second.getElseRegion().empty())
    return false;
  if (first->getAttrDictionary() != second->getAttrDictionary())
    return false;

  return planGapOps(first, second, gapOps, plan);
}

static WhereOp findCandidate(WhereOp first,
                             SmallVectorImpl<Operation *> &gapOps) {
  for (Operation *op = first->getNextNode(); op; op = op->getNextNode()) {
    if (WhereOp second = dyn_cast<WhereOp>(op))
      return second;
    if (!isMovableGapOp(op))
      return {};
    gapOps.push_back(op);
  }
  return {};
}

static void remapFirstResultUses(WhereOp first, WhereOp second,
                                 ArrayRef<Operation *> gapOps) {
  DenseSet<Operation *> gap;
  for (Operation *op : gapOps)
    gap.insert(op);
  YieldOp yield = cast<YieldOp>(first.getThenRegion().front().getTerminator());
  for (auto [result, yielded] :
       llvm::zip(first.getResults(), yield.getOperands()))
    for (OpOperand &use : llvm::make_early_inc_range(result.getUses()))
      if (isGapOrSecondUse(use.getOwner(), gap, second))
        use.set(yielded);
}

static void moveBody(Block &source, Block &dest) {
  Operation *terminator = source.getTerminator();
  while (&source.front() != terminator)
    source.front().moveBefore(&dest, dest.end());
}

static WhereOp mergeWhere(IRRewriter &rewriter, WhereOp first, WhereOp second,
                          const GapPlan &plan) {
  remapFirstResultUses(first, second, plan.sink);

  for (Operation *op : plan.hoist)
    op->moveBefore(first);

  YieldOp firstYield =
      cast<YieldOp>(first.getThenRegion().front().getTerminator());
  YieldOp secondYield =
      cast<YieldOp>(second.getThenRegion().front().getTerminator());
  SmallVector<Value> yielded(firstYield.getOperands());
  llvm::append_range(yielded, secondYield.getOperands());

  SmallVector<Type> resultTypes(first.getResultTypes());
  llvm::append_range(resultTypes, second.getResultTypes());
  rewriter.setInsertionPoint(first);
  WhereOp merged = WhereOp::create(rewriter, first.getLoc(), resultTypes,
                                   first.getConditions());
  merged->setAttrs(first->getAttrDictionary());
  Block &body = merged.getThenRegion().emplaceBlock();

  moveBody(first.getThenRegion().front(), body);
  for (Operation *op : plan.sink)
    op->moveBefore(&body, body.end());
  moveBody(second.getThenRegion().front(), body);
  rewriter.setInsertionPointToEnd(&body);
  YieldOp::create(rewriter, second.getLoc(), yielded);

  for (auto [oldResult, newResult] :
       llvm::zip(first.getResults(),
                 merged.getResults().take_front(first.getNumResults())))
    oldResult.replaceAllUsesWith(newResult);
  for (auto [oldResult, newResult] :
       llvm::zip(second.getResults(),
                 merged.getResults().drop_front(first.getNumResults())))
    oldResult.replaceAllUsesWith(newResult);

  rewriter.eraseOp(second);
  rewriter.eraseOp(first);
  return merged;
}

static WhereOp tryMerge(IRRewriter &rewriter, WhereOp first) {
  SmallVector<Operation *> gapOps;
  WhereOp second = findCandidate(first, gapOps);
  GapPlan plan;
  if (!second || !canMerge(first, second, gapOps, plan))
    return {};
  return mergeWhere(rewriter, first, second, plan);
}

static void coalesceBlock(IRRewriter &rewriter, Block &block) {
  for (Operation *op = block.empty() ? nullptr : &block.front(); op;) {
    if (WhereOp first = dyn_cast<WhereOp>(op)) {
      if (WhereOp merged = tryMerge(rewriter, first)) {
        op = merged;
        continue;
      }
    }

    Operation *next = op->getNextNode();
    for (Region &region : op->getRegions())
      for (Block &nested : region)
        coalesceBlock(rewriter, nested);
    op = next;
  }
}

struct WaveCoalesceWherePass
    : public wave::impl::WaveCoalesceWhereBase<WaveCoalesceWherePass> {
  void runOnOperation() override {
    IRRewriter rewriter(&getContext());
    for (Region &region : getOperation()->getRegions())
      for (Block &block : region)
        coalesceBlock(rewriter, block);
  }
};

} // namespace
