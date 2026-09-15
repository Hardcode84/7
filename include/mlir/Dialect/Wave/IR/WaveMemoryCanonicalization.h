//===- WaveMemoryCanonicalization.h - Token liveness -------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef MLIR_DIALECT_WAVE_IR_WAVEMEMORYCANONICALIZATION_H
#define MLIR_DIALECT_WAVE_IR_WAVEMEMORYCANONICALIZATION_H

#include "mlir/Dialect/Wave/IR/WaveMemoryEffects.h"
#include "mlir/IR/PatternMatch.h"
#include "mlir/Interfaces/ControlFlowInterfaces.h"
#include "mlir/Interfaces/SideEffectInterfaces.h"
#include "llvm/ADT/SetVector.h"

namespace mlir::wave {

struct EraseUnobservedMemory
    : OpTraitRewritePattern<OpTrait::wave::DiscardableMemoryOp> {
  using OpTraitRewritePattern::OpTraitRewritePattern;
  LogicalResult matchAndRewrite(Operation *op,
                                PatternRewriter &rewriter) const override {
    if (!op->use_empty())
      return failure();
    rewriter.eraseOp(op);
    return success();
  }
};

template <typename TokenType> struct MemoryDemand {
  RegionBranchInverseSuccessorMapping predecessors;
  llvm::SmallDenseSet<OpOperand *> forwarded;
  llvm::SetVector<Value> live;
  llvm::SmallPtrSet<Operation *, 32> expanded;
  llvm::SmallPtrSet<Operation *, 32> scope;
  SmallVector<Operation *> writes;

  static bool isDiscardable(Operation *op) {
    return op->hasTrait<OpTrait::wave::DiscardableMemoryOp>() &&
           llvm::all_of(op->getResultTypes(),
                        [](Type type) { return isa<TokenType>(type); });
  }

  void collect(Operation *op) {
    scope.insert(op);
    if (auto branch = dyn_cast<RegionBranchOpInterface>(op)) {
      RegionBranchSuccessorMapping successors;
      branch.getSuccessorOperandInputMapping(successors);
      for (auto &entry : successors) {
        forwarded.insert(entry.first);
        for (Value input : entry.second)
          predecessors[input].push_back(entry.first);
      }
    }
    if (isDiscardable(op))
      writes.push_back(op);
  }

  void seed(Operation *op) {
    for (Value result : op->getResults())
      if (llvm::any_of(result.getUsers(),
                       [&](Operation *user) { return !scope.contains(user); }))
        live.insert(result);
    bool branch = isa<RegionBranchOpInterface>(op);
    bool terminator = op->hasTrait<OpTrait::IsTerminator>();
    if (!branch && !terminator &&
        (isDiscardable(op) || wouldOpBeTriviallyDead(op)))
      return;
    for (OpOperand &operand : op->getOpOperands())
      if (!forwarded.contains(&operand))
        live.insert(operand.get());
  }

  void propagate() {
    for (size_t index = 0; index < live.size(); ++index) {
      Value value = live[index];
      auto incoming = predecessors.find(value);
      if (incoming != predecessors.end()) {
        for (OpOperand *operand : incoming->second)
          live.insert(operand->get());
        continue;
      }
      Operation *def = value.getDefiningOp();
      if (!def || !scope.contains(def) || !expanded.insert(def).second)
        continue;
      for (Value operand : def->getOperands())
        live.insert(operand);
    }
  }
};

template <typename EmptyTokenOp, typename TokenType>
struct EraseUnobservedRegionMemory
    : OpInterfaceRewritePattern<RegionBranchOpInterface> {
  using OpInterfaceRewritePattern::OpInterfaceRewritePattern;

  LogicalResult matchAndRewrite(RegionBranchOpInterface region,
                                PatternRewriter &rewriter) const override {
    // Analyze each outer region once, including its nested recurrences.
    for (Operation *parent = region->getParentOp(); parent;
         parent = parent->getParentOp())
      if (isa<RegionBranchOpInterface>(parent))
        return failure();
    MemoryDemand<TokenType> demand;
    SmallVector<Operation *> ops;
    region->template walk<WalkOrder::PreOrder>([&](Operation *op) {
      ops.push_back(op);
      demand.collect(op);
      if (op->getNumRegions() && !isa<RegionBranchOpInterface>(op))
        return WalkResult::skip();
      return WalkResult::advance();
    });
    if (demand.writes.empty())
      return failure();
    for (Operation *op : ops)
      demand.seed(op);
    demand.propagate();

    return success(eraseDeadWrites(demand, rewriter));
  }

private:
  static bool eraseDeadWrites(const MemoryDemand<TokenType> &demand,
                              PatternRewriter &rewriter) {
    bool changed = false;
    for (Operation *write : llvm::reverse(demand.writes)) {
      if (llvm::any_of(write->getResults(), [&](Value result) {
            return demand.live.contains(result);
          }))
        continue;
      rewriter.setInsertionPoint(write);
      for (Value result : write->getResults()) {
        if (result.use_empty())
          continue;
        Value empty =
            EmptyTokenOp::create(rewriter, write->getLoc(), result.getType());
        rewriter.replaceAllUsesWith(result, empty);
      }
      rewriter.eraseOp(write);
      changed = true;
    }
    return changed;
  }
};

} // namespace mlir::wave

#endif // MLIR_DIALECT_WAVE_IR_WAVEMEMORYCANONICALIZATION_H
