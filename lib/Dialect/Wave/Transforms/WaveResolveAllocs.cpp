//===- WaveResolveAllocs.cpp - place Wave allocations -----------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/Wave/Transforms/Passes.h"

#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/SCF/IR/SCF.h"
#include "mlir/Dialect/Wave/IR/Wave.h"
#include "mlir/IR/Builders.h"
#include "mlir/IR/PatternMatch.h"
#include "mlir/Interfaces/ViewLikeInterface.h"
#include "llvm/ADT/ArrayRef.h"
#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/STLExtras.h"

#include <algorithm>
#include <limits>

namespace mlir::wave {
#define GEN_PASS_DEF_WAVERESOLVEALLOCS
#include "mlir/Dialect/Wave/Transforms/Passes.h.inc"
} // namespace mlir::wave

using namespace mlir;
using namespace mlir::wave;

namespace {

struct AllocInterval {
  AllocOp op;
  int64_t bytes = 0;
  int64_t align = 1;
  int64_t offset = 0;
  unsigned start = 0;
  unsigned end = 0;
};

struct ActiveAllocation {
  int64_t offset = 0;
  int64_t bytes = 0;
  unsigned end = 0;
};

static FailureOr<int64_t> alignUp(int64_t value, int64_t align) {
  if (value < 0 || align <= 0)
    return failure();
  int64_t rem = value % align;
  if (rem == 0)
    return value;
  int64_t add = align - rem;
  if (value > std::numeric_limits<int64_t>::max() - add)
    return failure();
  return value + add;
}

static Operation *getFunctionBodyAnchor(Operation *op, func::FuncOp func) {
  Operation *anchor = op;
  while (anchor && anchor->getParentOp() != func) {
    Operation *parent = anchor->getParentOp();
    if (!parent)
      break;
    anchor = parent;
  }
  return anchor;
}

class OperationOrder {
public:
  explicit OperationOrder(func::FuncOp func) {
    func.walk<WalkOrder::PreOrder>(
        [&](Operation *op) { positions.try_emplace(op, next++); });
  }

  unsigned lookup(Operation *op) const {
    auto it = positions.find(op);
    assert(it != positions.end() && "operation missing from order");
    return it->second;
  }

  unsigned intervalPosition(func::FuncOp func, Operation *op) const {
    Operation *anchor = getFunctionBodyAnchor(op, func);
    return lookup(anchor ? anchor : op);
  }

private:
  DenseMap<Operation *, unsigned> positions;
  unsigned next = 0;
};

static bool appendAlias(DenseMap<Value, SmallVector<unsigned, 1>> &aliases,
                        Value value, unsigned index,
                        SmallVectorImpl<std::pair<Value, unsigned>> &worklist) {
  SmallVector<unsigned, 1> &indices = aliases[value];
  if (llvm::is_contained(indices, index))
    return false;
  indices.push_back(index);
  worklist.push_back({value, index});
  return true;
}

static void
appendForAliases(scf::ForOp loop, Value value, unsigned index,
                 DenseMap<Value, SmallVector<unsigned, 1>> &aliases,
                 SmallVectorImpl<std::pair<Value, unsigned>> &worklist) {
  for (auto [i, init] : llvm::enumerate(loop.getInitArgs())) {
    if (init != value)
      continue;
    appendAlias(aliases, loop.getRegionIterArgs()[i], index, worklist);
    appendAlias(aliases, loop.getResult(i), index, worklist);
  }
}

static void
appendYieldAliases(Operation *yield, Value value, unsigned index,
                   DenseMap<Value, SmallVector<unsigned, 1>> &aliases,
                   SmallVectorImpl<std::pair<Value, unsigned>> &worklist) {
  Operation *parent = yield->getParentOp();
  for (auto [i, operand] : llvm::enumerate(yield->getOperands())) {
    if (operand != value)
      continue;
    if (auto where = dyn_cast<WhereOp>(parent)) {
      appendAlias(aliases, where.getResult(i), index, worklist);
      continue;
    }
    if (auto ifOp = dyn_cast<scf::IfOp>(parent)) {
      appendAlias(aliases, ifOp.getResult(i), index, worklist);
      continue;
    }
    if (auto loop = dyn_cast<scf::ForOp>(parent)) {
      appendAlias(aliases, loop.getRegionIterArgs()[i], index, worklist);
      appendAlias(aliases, loop.getResult(i), index, worklist);
    }
  }
}

static void
appendForwardedAliases(Operation *user, Value value, unsigned index,
                       DenseMap<Value, SmallVector<unsigned, 1>> &aliases,
                       SmallVectorImpl<std::pair<Value, unsigned>> &worklist) {
  if (auto view = dyn_cast<ViewLikeOpInterface>(user)) {
    if (view.getViewSource() == value)
      appendAlias(aliases, view.getViewDest(), index, worklist);
  }
  if (auto select = dyn_cast<SelectOp>(user)) {
    if (select.getTrueValue() == value || select.getFalseValue() == value)
      appendAlias(aliases, select.getResult(), index, worklist);
  }
  if (auto loop = dyn_cast<scf::ForOp>(user))
    appendForAliases(loop, value, index, aliases, worklist);
  if (isa<YieldOp, scf::YieldOp>(user))
    appendYieldAliases(user, value, index, aliases, worklist);
}

static void
extendIntervalsThroughAliases(func::FuncOp func, const OperationOrder &order,
                              SmallVectorImpl<AllocInterval> &allocs) {
  DenseMap<Value, SmallVector<unsigned, 1>> aliases;
  SmallVector<std::pair<Value, unsigned>, 16> worklist;
  for (auto [index, interval] : llvm::enumerate(allocs)) {
    appendAlias(aliases, interval.op.getResult(), index, worklist);
    unsigned start = order.intervalPosition(func, interval.op);
    interval.start = start;
    interval.end = start;
  }

  while (!worklist.empty()) {
    auto [value, index] = worklist.pop_back_val();
    for (OpOperand &use : value.getUses()) {
      Operation *user = use.getOwner();
      allocs[index].end =
          std::max(allocs[index].end, order.intervalPosition(func, user));
      appendForwardedAliases(user, value, index, aliases, worklist);
    }
  }
}

static FailureOr<int64_t> findAvailableOffset(ArrayRef<ActiveAllocation> active,
                                              int64_t baseOffset,
                                              const AllocInterval &interval) {
  FailureOr<int64_t> aligned = alignUp(baseOffset, interval.align);
  if (failed(aligned))
    return failure();
  int64_t offset = *aligned;
  for (const ActiveAllocation &entry : active) {
    if (offset <= std::numeric_limits<int64_t>::max() - interval.bytes &&
        offset + interval.bytes <= entry.offset)
      break;
    if (entry.offset > std::numeric_limits<int64_t>::max() - entry.bytes)
      return failure();
    aligned = alignUp(entry.offset + entry.bytes, interval.align);
    if (failed(aligned))
      return failure();
    offset = *aligned;
  }
  if (offset > std::numeric_limits<int64_t>::max() - interval.bytes)
    return failure();
  return offset;
}

static FailureOr<int64_t> assignOffsets(SmallVectorImpl<AllocInterval> &allocs,
                                        int64_t baseOffset) {
  SmallVector<unsigned> order;
  order.reserve(allocs.size());
  for (unsigned i = 0, e = allocs.size(); i != e; ++i)
    order.push_back(i);
  llvm::stable_sort(order, [&](unsigned lhs, unsigned rhs) {
    if (allocs[lhs].start != allocs[rhs].start)
      return allocs[lhs].start < allocs[rhs].start;
    return lhs < rhs;
  });

  SmallVector<ActiveAllocation, 8> active;
  int64_t highWater = baseOffset;
  for (unsigned index : order) {
    AllocInterval &interval = allocs[index];
    llvm::erase_if(active, [&](const ActiveAllocation &entry) {
      return entry.end < interval.start;
    });
    llvm::sort(active,
               [](const ActiveAllocation &lhs, const ActiveAllocation &rhs) {
                 return lhs.offset < rhs.offset;
               });

    FailureOr<int64_t> offset =
        findAvailableOffset(active, baseOffset, interval);
    if (failed(offset))
      return failure();

    interval.offset = *offset;
    active.push_back({*offset, interval.bytes, interval.end});
    highWater = std::max(highWater, *offset + interval.bytes);
  }
  return highWater;
}

static LogicalResult resolveFuncAllocs(func::FuncOp func,
                                       IRRewriter &rewriter) {
  if (func.isExternal())
    return success();

  SmallVector<AllocOp> ops;
  func.walk([&](AllocOp op) { ops.push_back(op); });
  if (ops.empty())
    return success();

  IntegerAttr fixedAttr = func->getAttrOfType<IntegerAttr>("wave.lds_size");
  int64_t fixedBytes = fixedAttr ? fixedAttr.getInt() : 0;
  if (fixedBytes < 0)
    return func.emitError("wave.lds_size must be non-negative");

  OperationOrder order(func);
  SmallVector<AllocInterval> allocs;
  allocs.reserve(ops.size());
  for (AllocOp op : ops) {
    int64_t bytes = op.getBytesizeAttr().getInt();
    int64_t align = op.getAlignAttr().getInt();
    assert(bytes > 0 && "wave.alloc verifier guarantees positive bytesize");
    assert(align > 0 && "wave.alloc verifier guarantees positive alignment");
    allocs.push_back({op, bytes, align});
  }

  extendIntervalsThroughAliases(func, order, allocs);
  FailureOr<int64_t> plannedBytes = assignOffsets(allocs, fixedBytes);
  if (failed(plannedBytes))
    return func.emitError("failed to place wave.alloc storage");

  for (AllocInterval &interval : allocs) {
    rewriter.setInsertionPoint(interval.op);
    SharedMemoryBaseOp base = SharedMemoryBaseOp::create(
        rewriter, interval.op.getLoc(), interval.op.getResult().getType(),
        static_cast<uint64_t>(interval.offset));
    rewriter.replaceOp(interval.op, base.getResult());
  }

  OpBuilder builder(func.getContext());
  func->setAttr("wave.lds_size", builder.getI64IntegerAttr(*plannedBytes));
  return success();
}

struct WaveResolveAllocsPass
    : public wave::impl::WaveResolveAllocsBase<WaveResolveAllocsPass> {
  void runOnOperation() override {
    Operation *root = getOperation();
    IRRewriter rewriter(root->getContext());

    SmallVector<func::FuncOp> funcs;
    if (auto func = dyn_cast<func::FuncOp>(root)) {
      funcs.push_back(func);
    } else {
      root->walk([&](func::FuncOp func) { funcs.push_back(func); });
    }

    for (func::FuncOp func : funcs) {
      if (failed(resolveFuncAllocs(func, rewriter)))
        return signalPassFailure();
    }
  }
};

} // namespace
