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

static bool haveSameWriteEffect(Operation *lhs, Operation *rhs) {
  if (lhs == rhs || lhs->getName() != rhs->getName() ||
      !llvm::equal(lhs->getResultTypes(), rhs->getResultTypes()) ||
      lhs->getAttrDictionary() != rhs->getAttrDictionary())
    return false;
  if (StoreOp lhsStore = dyn_cast<StoreOp>(lhs)) {
    StoreOp rhsStore = cast<StoreOp>(rhs);
    return lhsStore.getValue() == rhsStore.getValue() &&
           lhsStore.getPtr() == rhsStore.getPtr();
  }
  return llvm::equal(lhs->getOperands(), rhs->getOperands());
}

static Value getWriteDependency(Operation *write) {
  if (StoreOp store = dyn_cast<StoreOp>(write))
    return store.getDependency();
  return cast<waveamd::DmaLoadLdsOp>(write).getDependency();
}

static void setWriteDependency(Operation *write, Value dependency) {
  if (StoreOp store = dyn_cast<StoreOp>(write)) {
    store.getDependencyMutable().assign(dependency);
    return;
  }
  cast<waveamd::DmaLoadLdsOp>(write).getDependencyMutable().set(dependency);
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

using WriteGroup = SmallVector<Operation *, 4>;

static SmallVector<WriteGroup>
groupEquivalentWrites(ArrayRef<Operation *> candidates) {
  SmallVector<WriteGroup> groups;
  for (Operation *write : candidates) {
    auto found = llvm::find_if(groups, [&](ArrayRef<Operation *> group) {
      return haveSameWriteEffect(group.front(), write);
    });
    if (found == groups.end())
      groups.push_back({write});
    else
      found->push_back(write);
  }
  return groups;
}

static bool dependenciesMatch(ArrayRef<Operation *> writes) {
  Value dependency = getWriteDependency(writes.front());
  return llvm::all_of(writes, [&](Operation *write) {
    return getWriteDependency(write) == dependency;
  });
}

static Value mergeDependencies(IRRewriter &rewriter,
                               ArrayRef<Operation *> writes,
                               Operation *survivor) {
  llvm::SmallDenseSet<Value, 4> seen;
  SmallVector<Value> dependencies;
  for (Operation *write : writes) {
    Value dependency = getWriteDependency(write);
    if (dependency && seen.insert(dependency).second)
      dependencies.push_back(dependency);
  }
  if (dependencies.empty())
    return {};
  if (dependencies.size() == 1)
    return dependencies.front();
  rewriter.setInsertionPoint(survivor);
  return JoinOp::create(rewriter, survivor->getLoc(),
                        dependencies.front().getType(), dependencies);
}

static SmallVector<Operation *> prepareWriteGroups(IRRewriter &rewriter,
                                                   JoinOp join) {
  SmallVector<Operation *> duplicates;
  for (WriteGroup &group :
       groupEquivalentWrites(collectWriteCandidates(join))) {
    if (group.size() == 1)
      continue;
    // Differing dependencies all dominate the last writer.
    Operation *survivor =
        dependenciesMatch(group) ? group.front() : group.back();
    Value dependency = mergeDependencies(rewriter, group, survivor);
    if (getWriteDependency(survivor) != dependency)
      rewriter.modifyOpInPlace(
          survivor, [&] { setWriteDependency(survivor, dependency); });
    for (Operation *write : group)
      if (write != survivor)
        duplicates.push_back(write);
  }
  return duplicates;
}

static void deduplicateJoinedWrites(IRRewriter &rewriter, JoinOp join) {
  SmallVector<Operation *> duplicates = prepareWriteGroups(rewriter, join);
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
