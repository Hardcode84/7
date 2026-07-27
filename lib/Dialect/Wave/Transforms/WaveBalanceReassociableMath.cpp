//===- WaveBalanceReassociableMath.cpp - Balance FP32 trees ----*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/Wave/Transforms/Passes.h"

#include "mlir/Dialect/Arith/IR/Arith.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/Wave/IR/Wave.h"
#include "mlir/IR/Builders.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/Support/MathExtras.h"

#include <algorithm>
#include <array>
#include <optional>

namespace mlir::wave {
#define GEN_PASS_DEF_WAVEBALANCEREASSOCIABLEMATH
#include "mlir/Dialect/Wave/Transforms/Passes.h.inc"
} // namespace mlir::wave

using namespace mlir;
using namespace mlir::wave;

namespace {

enum class ReductionKind {
  Add,
  Mul,
};

struct ReductionTree {
  SmallVector<Value, 16> leaves;
  SmallVector<Operation *, 16> operations;
  arith::FastMathFlags commonFlags = arith::FastMathFlags::fast;
};

static std::optional<ReductionKind> getReductionKind(Operation *op) {
  if (op->getNumResults() != 1)
    return std::nullopt;
  SimdType type = dyn_cast<SimdType>(op->getResult(0).getType());
  if (!type || !type.getElementType().isF32())
    return std::nullopt;
  if (isa<FAddOp>(op))
    return ReductionKind::Add;
  if (isa<FMulOp>(op))
    return ReductionKind::Mul;
  return std::nullopt;
}

static arith::FastMathFlags getFastmath(Operation *op) {
  if (auto add = dyn_cast<FAddOp>(op))
    return add.getFastmath();
  return cast<FMulOp>(op).getFastmath();
}

static bool permitsReassociation(Operation *op) {
  return arith::bitEnumContainsAll(getFastmath(op),
                                   arith::FastMathFlags::reassoc);
}

static bool isTreeOp(Operation *op, ReductionKind kind, Type type,
                     Block *block) {
  return op && op->getBlock() == block &&
         getReductionKind(op) == std::optional<ReductionKind>(kind) &&
         op->getResult(0).getType() == type && permitsReassociation(op);
}

static bool isInternalTreeOp(Operation *op) {
  std::optional<ReductionKind> kind = getReductionKind(op);
  if (!kind || !permitsReassociation(op) || !op->getResult(0).hasOneUse())
    return false;
  Operation *user = op->getResult(0).use_begin()->getOwner();
  return isTreeOp(user, *kind, op->getResult(0).getType(), op->getBlock());
}

static unsigned collectTree(Operation *op, ReductionKind kind, Type type,
                            ReductionTree &tree) {
  tree.operations.push_back(op);
  tree.commonFlags &= getFastmath(op);

  std::array<unsigned, 2> depths;
  for (auto [index, operand] : llvm::enumerate(op->getOperands())) {
    Operation *child = operand.getDefiningOp();
    if (isTreeOp(child, kind, type, op->getBlock()) &&
        child->getResult(0).hasOneUse()) {
      depths[index] = collectTree(child, kind, type, tree);
      continue;
    }
    tree.leaves.push_back(operand);
    depths[index] = 0;
  }
  return 1 + std::max(depths[0], depths[1]);
}

static Value createReductionOp(OpBuilder &builder, Location loc,
                               ReductionKind kind, Type type, Value lhs,
                               Value rhs, arith::FastMathFlagsAttr fastmath) {
  if (kind == ReductionKind::Add)
    return FAddOp::create(builder, loc, type, lhs, rhs, fastmath).getResult();
  return FMulOp::create(builder, loc, type, lhs, rhs, fastmath).getResult();
}

static Value buildBalancedBranch(OpBuilder &builder, Location loc,
                                 ReductionKind kind, Type type,
                                 ArrayRef<Value> leaves,
                                 arith::FastMathFlagsAttr fastmath) {
  SmallVector<Value, 16> level(leaves);
  while (level.size() > 1) {
    SmallVector<Value, 16> next;
    next.reserve((level.size() + 1) / 2);
    for (size_t pair : llvm::seq<size_t>(0, level.size() / 2))
      next.push_back(createReductionOp(builder, loc, kind, type,
                                       level[2 * pair], level[2 * pair + 1],
                                       fastmath));
    if (level.size() % 2)
      next.push_back(level.back());
    level = std::move(next);
  }
  return level.front();
}

static void balanceTree(Operation *root) {
  std::optional<ReductionKind> kind = getReductionKind(root);
  if (!kind || !permitsReassociation(root) || root->getResult(0).use_empty())
    return;

  ReductionTree tree;
  unsigned depth = collectTree(root, *kind, root->getResult(0).getType(), tree);
  if (tree.operations.size() < 3 ||
      depth <= llvm::Log2_64_Ceil(tree.leaves.size()))
    return;

  OpBuilder builder(root);
  arith::FastMathFlagsAttr fastmath =
      arith::FastMathFlagsAttr::get(root->getContext(), tree.commonFlags);
  SmallVector<Value, 16> even;
  SmallVector<Value, 16> odd;
  for (auto [index, leaf] : llvm::enumerate(tree.leaves)) {
    if (index % 2)
      odd.push_back(leaf);
    else
      even.push_back(leaf);
  }
  Value lhs = buildBalancedBranch(builder, root->getLoc(), *kind,
                                  root->getResult(0).getType(), even, fastmath);
  Value rhs = buildBalancedBranch(builder, root->getLoc(), *kind,
                                  root->getResult(0).getType(), odd, fastmath);
  Value balanced =
      createReductionOp(builder, root->getLoc(), *kind,
                        root->getResult(0).getType(), lhs, rhs, fastmath);

  root->getResult(0).replaceAllUsesWith(balanced);
  for (Operation *op : tree.operations) {
    assert(op->use_empty() && "balanced tree operation still used");
    op->erase();
  }
}

struct WaveBalanceReassociableMathPass
    : public wave::impl::WaveBalanceReassociableMathBase<
          WaveBalanceReassociableMathPass> {
  using WaveBalanceReassociableMathBase::WaveBalanceReassociableMathBase;

  void runOnOperation() override {
    getOperation()->walk([&](func::FuncOp func) {
      if (func.isExternal())
        return;

      SmallVector<Block *, 16> blocks;
      func.walk([&](Operation *op) {
        for (Region &region : op->getRegions())
          for (Block &block : region)
            blocks.push_back(&block);
      });
      for (Block *block : blocks) {
        SmallVector<Operation *, 16> roots;
        for (Operation &op : *block)
          if (getReductionKind(&op) && permitsReassociation(&op) &&
              !isInternalTreeOp(&op))
            roots.push_back(&op);
        for (Operation *root : roots)
          balanceTree(root);
      }
    });
  }
};

} // namespace
