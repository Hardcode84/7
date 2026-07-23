//===- WaveCleanupAllocs.cpp - remove dead allocation writes ----*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/Wave/Transforms/Passes.h"

#include "mlir/Dialect/SCF/IR/SCF.h"
#include "mlir/Dialect/Wave/IR/Wave.h"
#include "mlir/IR/PatternMatch.h"
#include "mlir/Interfaces/ControlFlowInterfaces.h"
#include "mlir/Interfaces/SideEffectInterfaces.h"
#include "mlir/Interfaces/ViewLikeInterface.h"
#include "llvm/ADT/DenseSet.h"
#include "llvm/ADT/SetVector.h"

namespace mlir::wave {
#define GEN_PASS_DEF_WAVECLEANUPALLOCS
#include "mlir/Dialect/Wave/Transforms/Passes.h.inc"
} // namespace mlir::wave

using namespace mlir;
using namespace mlir::wave;

namespace {

using MemoryEffectInstance = SideEffects::EffectInstance<MemoryEffects::Effect>;

struct AllocUseInfo {
  DenseSet<Value> aliases;
  SmallVector<Value, 16> worklist;
  llvm::SetVector<Operation *> memoryOps;
  llvm::SetVector<Operation *> writes;
  llvm::SetVector<Operation *> releases;
  bool hasRead = false;
  bool hasUnknown = false;
};

static bool appendAlias(AllocUseInfo &info, Value value) {
  if (!info.aliases.insert(value).second)
    return false;
  info.worklist.push_back(value);
  return true;
}

static bool appendSuccessorAliases(AllocUseInfo &info, Value value,
                                   OperandRange sources, ValueRange targets) {
  bool handled = false;
  for (auto [index, source] : llvm::enumerate(sources)) {
    if (source != value)
      continue;
    handled = true;
    if (index < targets.size())
      appendAlias(info, targets[index]);
  }
  return handled;
}

static bool appendViewAlias(AllocUseInfo &info, OpOperand &use) {
  auto view = dyn_cast<ViewLikeOpInterface>(use.getOwner());
  if (!view || view.getViewSource() != use.get())
    return false;
  appendAlias(info, view.getViewDest());
  return true;
}

static bool appendSelectAlias(AllocUseInfo &info, OpOperand &use) {
  auto select = dyn_cast<SelectOp>(use.getOwner());
  if (!select)
    return false;
  if (select.getTrueValue() != use.get() && select.getFalseValue() != use.get())
    return false;
  appendAlias(info, select.getResult());
  return true;
}

static bool appendRegionEntryAliases(AllocUseInfo &info, OpOperand &use) {
  auto branch = dyn_cast<RegionBranchOpInterface>(use.getOwner());
  if (!branch)
    return false;

  bool handled = false;
  SmallVector<RegionSuccessor> successors;
  branch.getSuccessorRegions(RegionBranchPoint::parent(), successors);
  for (RegionSuccessor successor : successors) {
    handled |= appendSuccessorAliases(
        info, use.get(), branch.getEntrySuccessorOperands(successor),
        branch.getSuccessorInputs(successor));
  }
  return handled;
}

static bool appendRegionTerminatorAliases(AllocUseInfo &info, OpOperand &use) {
  auto terminator = dyn_cast<RegionBranchTerminatorOpInterface>(use.getOwner());
  if (!terminator)
    return false;
  auto branch =
      dyn_cast_or_null<RegionBranchOpInterface>(use.getOwner()->getParentOp());
  if (!branch)
    return false;

  bool handled = false;
  SmallVector<RegionSuccessor> successors;
  branch.getSuccessorRegions(RegionBranchPoint(terminator), successors);
  for (RegionSuccessor successor : successors) {
    handled |= appendSuccessorAliases(
        info, use.get(), terminator.getSuccessorOperands(successor),
        branch.getSuccessorInputs(successor));
  }
  return handled;
}

static bool appendWhereYieldAliases(AllocUseInfo &info, OpOperand &use) {
  auto yield = dyn_cast<YieldOp>(use.getOwner());
  if (!yield)
    return false;
  auto where = dyn_cast_or_null<WhereOp>(yield->getParentOp());
  if (!where)
    return false;

  bool handled = false;
  for (auto [index, value] : llvm::enumerate(yield.getValues())) {
    if (value != use.get())
      continue;
    handled = true;
    appendAlias(info, where.getResult(index));
  }
  return handled;
}

static bool hasMixedSourceOperands(AllocUseInfo &info, Value value,
                                   OperandRange sources, ValueRange targets) {
  for (auto [index, source] : llvm::enumerate(sources))
    if (index < targets.size() && targets[index] == value &&
        !info.aliases.contains(source))
      return true;
  return false;
}

static bool hasMixedSelectSources(AllocUseInfo &info, Value value) {
  auto result = dyn_cast<OpResult>(value);
  if (!result)
    return false;
  auto select = dyn_cast<SelectOp>(result.getOwner());
  if (!select)
    return false;
  return !info.aliases.contains(select.getTrueValue()) ||
         !info.aliases.contains(select.getFalseValue());
}

static bool hasMixedRegionEntrySources(AllocUseInfo &info, Value value) {
  auto arg = dyn_cast<BlockArgument>(value);
  if (!arg)
    return false;
  Operation *parent = arg.getParentRegion()->getParentOp();
  auto branch = dyn_cast_or_null<RegionBranchOpInterface>(parent);
  if (!branch)
    return false;

  SmallVector<RegionSuccessor> successors;
  branch.getSuccessorRegions(RegionBranchPoint::parent(), successors);
  for (RegionSuccessor successor : successors)
    if (hasMixedSourceOperands(info, value,
                               branch.getEntrySuccessorOperands(successor),
                               branch.getSuccessorInputs(successor)))
      return true;
  return false;
}

static bool hasMixedRegionTerminatorSources(AllocUseInfo &info, Value value) {
  auto result = dyn_cast<OpResult>(value);
  if (!result)
    return false;
  Operation *parent = result.getOwner();
  auto branch = dyn_cast<RegionBranchOpInterface>(parent);
  if (!branch)
    return false;

  for (Region &region : parent->getRegions()) {
    for (Block &block : region) {
      auto terminator =
          dyn_cast<RegionBranchTerminatorOpInterface>(block.getTerminator());
      if (!terminator)
        continue;
      SmallVector<RegionSuccessor> successors;
      branch.getSuccessorRegions(RegionBranchPoint(terminator), successors);
      for (RegionSuccessor successor : successors)
        if (hasMixedSourceOperands(info, value,
                                   terminator.getSuccessorOperands(successor),
                                   branch.getSuccessorInputs(successor)))
          return true;
    }
  }
  return false;
}

static bool hasMixedWhereYieldSources(AllocUseInfo &info, Value value) {
  auto result = dyn_cast<OpResult>(value);
  if (!result)
    return false;
  auto where = dyn_cast<WhereOp>(result.getOwner());
  if (!where)
    return false;

  unsigned resultIndex = result.getResultNumber();
  for (Region &region : where->getRegions()) {
    for (Block &block : region) {
      auto yield = dyn_cast<YieldOp>(block.getTerminator());
      if (!yield || resultIndex >= yield.getValues().size())
        continue;
      if (!info.aliases.contains(yield.getValues()[resultIndex]))
        return true;
    }
  }
  return false;
}

static void markMixedJoinSources(AllocUseInfo &info) {
  for (Value value : info.aliases) {
    if (!hasMixedSelectSources(info, value) &&
        !hasMixedRegionEntrySources(info, value) &&
        !hasMixedRegionTerminatorSources(info, value) &&
        !hasMixedWhereYieldSources(info, value))
      continue;
    info.hasUnknown = true;
    return;
  }
}

static bool targetsUse(const MemoryEffectInstance &effect, OpOperand &use) {
  OpOperand *operand = effect.getEffectValue<OpOperand *>();
  return operand == &use;
}

static bool hasLiveNonTokenResult(Operation *op) {
  for (Value result : op->getResults())
    if (!isa<MemTokenType>(result.getType()) && !result.use_empty())
      return true;
  return false;
}

static bool classifyMemoryUse(AllocUseInfo &info, OpOperand &use) {
  Operation *owner = use.getOwner();
  if (AllocReleaseOp release = dyn_cast<AllocReleaseOp>(owner)) {
    if (release.getAllocation() == use.get()) {
      info.releases.insert(owner);
      return true;
    }
  }

  auto memory = dyn_cast<MemoryEffectOpInterface>(owner);
  if (!memory)
    return false;

  bool handled = false;
  SmallVector<MemoryEffectInstance, 4> effects;
  memory.getEffects(effects);
  for (const MemoryEffectInstance &effect : effects) {
    if (!targetsUse(effect, use))
      continue;
    handled = true;
    info.memoryOps.insert(owner);
    if (isa<MemoryEffects::Read>(effect.getEffect())) {
      info.hasRead = true;
      continue;
    }
    if (isa<MemoryEffects::Write>(effect.getEffect())) {
      if (hasLiveNonTokenResult(owner))
        info.hasUnknown = true;
      else
        info.writes.insert(owner);
      continue;
    }
    info.hasUnknown = true;
  }
  return handled;
}

static void collectAllocUses(AllocOp alloc, AllocUseInfo &info) {
  appendAlias(info, alloc.getResult());
  while (!info.worklist.empty()) {
    Value value = info.worklist.pop_back_val();
    for (OpOperand &use : value.getUses()) {
      if (appendViewAlias(info, use) || appendSelectAlias(info, use) ||
          appendRegionEntryAliases(info, use) ||
          appendRegionTerminatorAliases(info, use) ||
          appendWhereYieldAliases(info, use) || classifyMemoryUse(info, use))
        continue;
      info.hasUnknown = true;
    }
  }
  markMixedJoinSources(info);
}

static Value getSingleMemTokenOperand(Operation *op) {
  Value dependency;
  for (Value operand : op->getOperands()) {
    if (!isa<MemTokenType>(operand.getType()))
      continue;
    if (dependency)
      return Value();
    dependency = operand;
  }
  return dependency;
}

static void eraseTokenForwardingOp(IRRewriter &rewriter, Operation *op) {
  Value dependency = getSingleMemTokenOperand(op);
  for (Value result : op->getResults()) {
    if (!isa<MemTokenType>(result.getType()) || result.use_empty())
      continue;
    Value replacement = dependency;
    if (!replacement || replacement.getType() != result.getType()) {
      rewriter.setInsertionPoint(op);
      replacement =
          TokenOp::create(rewriter, op->getLoc(), result.getType()).getResult();
    }
    rewriter.replaceAllUsesWith(result, replacement);
  }
  rewriter.eraseOp(op);
}

static void cleanupAllocs(Operation *root, IRRewriter &rewriter) {
  SmallVector<AllocOp> allocs;
  root->walk([&](AllocOp alloc) { allocs.push_back(alloc); });
  if (allocs.empty())
    return;

  llvm::SetVector<Operation *> writes;
  llvm::SetVector<Operation *> releases;
  llvm::SetVector<Operation *> blocked;
  for (AllocOp alloc : allocs) {
    AllocUseInfo info;
    collectAllocUses(alloc, info);
    if (info.hasRead || info.hasUnknown) {
      blocked.set_union(info.memoryOps);
      continue;
    }
    writes.set_union(info.writes);
    releases.set_union(info.releases);
  }

  for (Operation *write : writes) {
    if (!blocked.contains(write))
      eraseTokenForwardingOp(rewriter, write);
  }
  for (Operation *release : releases)
    eraseTokenForwardingOp(rewriter, release);
}

struct WaveCleanupAllocsPass
    : public wave::impl::WaveCleanupAllocsBase<WaveCleanupAllocsPass> {
  void runOnOperation() override {
    Operation *root = getOperation();
    IRRewriter rewriter(root->getContext());
    cleanupAllocs(root, rewriter);
  }
};

} // namespace
