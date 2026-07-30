//===- WaveAMDDeduplicateWrites.cpp - dedup writes ---------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/Wave/Transforms/Passes.h"

#include "mlir/Dialect/Wave/IR/Wave.h"
#include "mlir/Dialect/Wave/IR/WaveAMD.h"
#include "mlir/IR/PatternMatch.h"
#include "llvm/ADT/DenseSet.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/ADT/SmallPtrSet.h"

namespace mlir::wave {
#define GEN_PASS_DEF_WAVEAMDDEDUPLICATEWRITES
#include "mlir/Dialect/Wave/Transforms/Passes.h.inc"
} // namespace mlir::wave

using namespace mlir;
using namespace mlir::wave;

namespace {

static bool isDeduplicableWrite(Operation *op) {
  return isa<StoreOp, waveamd::DmaLoadLdsOp>(op);
}

static bool areDistinctIdenticalWrites(Operation *lhs, Operation *rhs) {
  return lhs != rhs && lhs->getName() == rhs->getName() &&
         llvm::equal(lhs->getResultTypes(), rhs->getResultTypes()) &&
         lhs->getAttrDictionary() == rhs->getAttrDictionary() &&
         llvm::equal(lhs->getOperands(), rhs->getOperands());
}

static bool tokenUsedOnlyByJoin(Value token, JoinOp join) {
  return llvm::all_of(token.getUses(),
                      [&](OpOperand &use) { return use.getOwner() == join; });
}

static SmallVector<Operation *> collectWriteCandidates(JoinOp join) {
  llvm::SmallPtrSet<Operation *, 8> seen;
  SmallVector<Operation *> candidates;
  for (Value token : join->getOperands()) {
    Operation *write = token.getDefiningOp();
    if (!write || !isDeduplicableWrite(write) ||
        write->getBlock() != join->getBlock() ||
        !tokenUsedOnlyByJoin(token, join) || !seen.insert(write).second)
      continue;
    candidates.push_back(write);
  }
  llvm::sort(candidates, [](Operation *lhs, Operation *rhs) {
    return lhs->isBeforeInBlock(rhs);
  });
  return candidates;
}

static SmallVector<Operation *>
findDuplicateWrites(ArrayRef<Operation *> candidates) {
  SmallVector<Operation *> representatives;
  SmallVector<Operation *> duplicates;
  for (Operation *write : candidates) {
    auto found = llvm::find_if(representatives, [&](Operation *candidate) {
      return areDistinctIdenticalWrites(candidate, write);
    });
    if (found == representatives.end())
      representatives.push_back(write);
    else
      duplicates.push_back(write);
  }
  return duplicates;
}

static void deduplicateJoinedWrites(IRRewriter &rewriter, JoinOp join) {
  SmallVector<Operation *> duplicates =
      findDuplicateWrites(collectWriteCandidates(join));
  if (duplicates.empty())
    return;

  llvm::DenseSet<Value> duplicateTokens;
  for (Operation *duplicate : duplicates)
    duplicateTokens.insert(duplicate->getResult(0));
  SmallVector<Value> inputs;
  inputs.reserve(join->getNumOperands() - duplicateTokens.size());
  for (Value token : join->getOperands())
    if (!duplicateTokens.contains(token))
      inputs.push_back(token);
  rewriter.modifyOpInPlace(join, [&] { join->setOperands(inputs); });

  for (Operation *duplicate : duplicates)
    rewriter.eraseOp(duplicate);
}

struct WaveAMDDeduplicateWritesPass
    : public wave::impl::WaveAMDDeduplicateWritesBase<
          WaveAMDDeduplicateWritesPass> {
  void runOnOperation() override {
    IRRewriter rewriter(&getContext());
    SmallVector<JoinOp> joins;
    getOperation()->walk([&](JoinOp join) { joins.push_back(join); });
    for (JoinOp join : joins)
      deduplicateJoinedWrites(rewriter, join);
  }
};

} // namespace
