//===- WaveAMDMMAReusePreschedule.cpp - MMA reuse ordering ----------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/Wave/Transforms/Passes.h"

#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachine.h"
#include "llvm/ADT/BitVector.h"
#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/ADT/SmallVector.h"

#include <optional>

namespace mlir::wave {
#define GEN_PASS_DEF_WAVEAMDMMAREUSEPRESCHEDULE
#include "mlir/Dialect/Wave/Transforms/Passes.h.inc"
} // namespace mlir::wave

using namespace mlir;
using namespace mlir::wave;

namespace {

static bool isMMA(Operation *op) {
  return isa<waveamdmachine::MMAOpInterface>(op);
}

static bool isRegisterValue(Value value) {
  return isa<waveamdmachine::RegType>(value.getType());
}

static void collectUniqueRegisterOperands(Operation *op,
                                          SmallVectorImpl<Value> &operands) {
  for (Value operand : op->getOperands()) {
    if (!isRegisterValue(operand))
      continue;
    if (!llvm::is_contained(operands, operand))
      operands.push_back(operand);
  }
}

static unsigned countReusedOperands(Operation *prev, Operation *candidate) {
  SmallVector<Value, 8> prevOperands;
  SmallVector<Value, 8> counted;
  collectUniqueRegisterOperands(prev, prevOperands);
  unsigned count = 0;
  for (Value operand : candidate->getOperands()) {
    if (!isRegisterValue(operand))
      continue;
    if (!llvm::is_contained(prevOperands, operand))
      continue;
    if (llvm::is_contained(counted, operand))
      continue;
    counted.push_back(operand);
    ++count;
  }
  return count;
}

static DenseMap<Operation *, unsigned>
buildChunkIndexMap(ArrayRef<Operation *> chunk) {
  DenseMap<Operation *, unsigned> indices;
  for (auto [index, op] : llvm::enumerate(chunk))
    indices[op] = static_cast<unsigned>(index);
  return indices;
}

static bool isReady(Operation *op,
                    const DenseMap<Operation *, unsigned> &indices,
                    const llvm::BitVector &scheduled) {
  for (Value operand : op->getOperands()) {
    Operation *def = operand.getDefiningOp();
    if (!def)
      continue;
    DenseMap<Operation *, unsigned>::const_iterator it = indices.find(def);
    if (it == indices.end())
      continue;
    if (!scheduled[it->second])
      return false;
  }
  return true;
}

static std::optional<unsigned>
pickNext(Operation *prev, ArrayRef<Operation *> chunk,
         const DenseMap<Operation *, unsigned> &indices,
         const llvm::BitVector &scheduled) {
  std::optional<unsigned> best;
  unsigned bestReuse = 0;
  for (unsigned index : llvm::seq<unsigned>(1, chunk.size())) {
    if (scheduled[index])
      continue;
    if (!isReady(chunk[index], indices, scheduled))
      continue;
    unsigned reuse = countReusedOperands(prev, chunk[index]);
    if (!best || reuse > bestReuse) {
      best = index;
      bestReuse = reuse;
    }
  }
  return best;
}

static SmallVector<unsigned, 8> buildReuseOrder(ArrayRef<Operation *> chunk) {
  SmallVector<unsigned, 8> order;
  llvm::BitVector scheduled(chunk.size());
  DenseMap<Operation *, unsigned> indices = buildChunkIndexMap(chunk);
  order.push_back(0);
  scheduled.set(0);

  while (order.size() != chunk.size()) {
    std::optional<unsigned> next =
        pickNext(chunk[order.back()], chunk, indices, scheduled);
    if (!next)
      break;
    order.push_back(*next);
    scheduled.set(*next);
  }
  for (unsigned index : llvm::seq<unsigned>(1, chunk.size()))
    if (!scheduled[index])
      order.push_back(index);
  return order;
}

static bool isIdentityOrder(ArrayRef<unsigned> order) {
  for (auto [position, index] : llvm::enumerate(order))
    if (position != index)
      return false;
  return true;
}

static void applyChunkOrder(ArrayRef<Operation *> chunk,
                            ArrayRef<unsigned> order) {
  Operation *insertBefore = chunk.back()->getNextNode();
  Block *block = chunk.back()->getBlock();
  for (unsigned index : llvm::reverse(order)) {
    Operation *op = chunk[index];
    if (insertBefore)
      op->moveBefore(insertBefore);
    else
      op->moveBefore(block, block->end());
    insertBefore = op;
  }
}

static bool prescheduleChunk(ArrayRef<Operation *> chunk) {
  if (chunk.size() < 3)
    return false;
  SmallVector<unsigned, 8> order = buildReuseOrder(chunk);
  if (isIdentityOrder(order))
    return false;
  applyChunkOrder(chunk, order);
  return true;
}

static bool prescheduleBlock(Block &block) {
  SmallVector<SmallVector<Operation *, 8>, 8> chunks;
  SmallVector<Operation *, 8> chunk;
  auto flush = [&]() {
    if (chunk.size() > 1)
      chunks.push_back(std::move(chunk));
    chunk.clear();
  };
  for (Operation &op : block) {
    if (isMMA(&op)) {
      chunk.push_back(&op);
      continue;
    }
    flush();
  }
  flush();

  bool changed = false;
  for (ArrayRef<Operation *> chunk : chunks)
    changed |= prescheduleChunk(chunk);
  return changed;
}

static SmallVector<Block *, 16> collectBlocks(func::FuncOp func) {
  SmallVector<Block *, 16> blocks;
  func->walk([&](Operation *op) {
    for (Region &region : op->getRegions())
      for (Block &block : region)
        blocks.push_back(&block);
  });
  return blocks;
}

struct WaveAMDMMAReusePreschedulePass
    : public wave::impl::WaveAMDMMAReusePrescheduleBase<
          WaveAMDMMAReusePreschedulePass> {
  using WaveAMDMMAReusePrescheduleBase::WaveAMDMMAReusePrescheduleBase;

  void runOnOperation() override {
    getOperation()->walk([&](func::FuncOp func) {
      if (func.isExternal())
        return;
      for (Block *block : collectBlocks(func))
        prescheduleBlock(*block);
    });
  }
};

} // namespace
