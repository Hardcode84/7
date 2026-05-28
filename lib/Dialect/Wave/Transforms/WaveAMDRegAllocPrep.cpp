//===- WaveAMDRegAllocPrep.cpp - WaveAMD regalloc preparation ---*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "WaveAMDRegAllocPrep.h"

#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachine.h"
#include "mlir/IR/Builders.h"
#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/DenseSet.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/ADT/SmallVector.h"
#include <optional>

using namespace mlir;

namespace {

static bool isReg(Value value) {
  return isa<waveamdmachine::RegType>(value.getType());
}

static bool isSGPR(waveamdmachine::RegType type) {
  return type.getRegClass() == waveamdmachine::RegClass::SGPR;
}

static bool isVGPR(waveamdmachine::RegType type) {
  return type.getRegClass() == waveamdmachine::RegClass::VGPR;
}

static bool isSCC(waveamdmachine::RegType type) {
  return type.getRegClass() == waveamdmachine::RegClass::SCC;
}

static std::optional<waveamdmachine::RegType> trackedRegType(Value v) {
  if (!isReg(v))
    return std::nullopt;
  auto rt = cast<waveamdmachine::RegType>(v.getType());
  if (isSCC(rt))
    return std::nullopt;
  return rt;
}

static FailureOr<Value> duplicateRegValue(OpBuilder &builder, Location loc,
                                          Value v) {
  auto rt = cast<waveamdmachine::RegType>(v.getType());
  waveamdmachine::RegType resultType = waveamdmachine::RegType::get(
      rt.getContext(), rt.getRegClass(), rt.getWidth(), /*index=*/-1);
  if (auto mov = v.getDefiningOp<waveamdmachine::VMovB32TupleOp>())
    if (mov.getSource().getDefiningOp<waveamdmachine::ImmOp>()) {
      Operation *clone = builder.clone(*mov);
      clone->getResult(0).setType(resultType);
      return clone->getResult(0);
    }
  if (isVGPR(rt)) {
    auto copy =
        waveamdmachine::VMovB32TupleOp::create(builder, loc, resultType, v);
    copy->setAttr("registers", builder.getI64IntegerAttr(rt.getWidth()));
    return copy.getResult();
  }
  if (isSGPR(rt)) {
    auto copy =
        waveamdmachine::SMovB32TupleOp::create(builder, loc, resultType, v);
    copy->setAttr("registers", builder.getI64IntegerAttr(rt.getWidth()));
    return copy.getResult();
  }
  return emitError(loc, "duplicateRegValue: unsupported register class / "
                        "width for duplicate iter_arg init");
}

static LogicalResult splitDuplicateLoopInits(func::FuncOp func) {
  SmallVector<waveamdmachine::UniformLoopOp> loops;
  func.walk([&](waveamdmachine::UniformLoopOp loop) { loops.push_back(loop); });
  OpBuilder builder(func.getContext());
  for (waveamdmachine::UniformLoopOp loop : loops) {
    DenseSet<Value> seen;
    builder.setInsertionPoint(loop);
    for (auto [i, init] : llvm::enumerate(loop.getInits())) {
      if (!trackedRegType(init)) {
        seen.insert(init);
        continue;
      }
      if (seen.insert(init).second)
        continue;
      FailureOr<Value> dup = duplicateRegValue(builder, loop.getLoc(), init);
      if (failed(dup))
        return failure();
      loop.getInitsMutable()[i].assign(*dup);
    }
  }
  return success();
}

static Operation *topLevelBodyOp(Block &body, Operation *op) {
  while (op && op->getBlock() != &body)
    op = op->getParentOp();
  return op;
}

static bool hasUseAfter(BlockArgument arg, Operation *op,
                        const DenseMap<Operation *, unsigned> &order) {
  auto posIt = order.find(op);
  if (posIt == order.end())
    return true;
  unsigned pos = posIt->second;
  Block &body = *arg.getOwner();
  for (OpOperand &use : arg.getUses()) {
    Operation *user = topLevelBodyOp(body, use.getOwner());
    if (!user || isa<waveamdmachine::ContinueIfOp>(user))
      continue;
    auto it = order.find(user);
    if (it != order.end() && it->second > pos)
      return true;
  }
  return false;
}

static bool needsBackedgeCopy(waveamdmachine::UniformLoopOp loop, unsigned i,
                              Value carry,
                              const DenseMap<Operation *, unsigned> &order) {
  Block &body = loop.getBody().front();
  Value init = loop.getInits()[i];
  BlockArgument arg = body.getArgument(i);
  if (carry == arg || carry == init)
    return false;
  Operation *def = carry.getDefiningOp();
  if (!def)
    return true;
  Operation *top = topLevelBodyOp(body, def);
  if (!top)
    return true;
  return hasUseAfter(arg, top, order);
}

static LogicalResult materializeLoopBackedgeCopies(func::FuncOp func) {
  SmallVector<waveamdmachine::UniformLoopOp> loops;
  func.walk([&](waveamdmachine::UniformLoopOp loop) { loops.push_back(loop); });
  OpBuilder builder(func.getContext());
  for (waveamdmachine::UniformLoopOp loop : loops) {
    Block &body = loop.getBody().front();
    auto term = cast<waveamdmachine::ContinueIfOp>(body.getTerminator());
    DenseMap<Operation *, unsigned> order;
    unsigned index = 0;
    for (Operation &op : body.without_terminator())
      order[&op] = index++;
    builder.setInsertionPoint(term);
    for (auto [i, carry] : llvm::enumerate(term.getCarries())) {
      if (!trackedRegType(carry))
        continue;
      // Late defs can stay coalesced; early defs need tail copy.
      if (!needsBackedgeCopy(loop, i, carry, order))
        continue;
      FailureOr<Value> dup = duplicateRegValue(builder, term.getLoc(), carry);
      if (failed(dup))
        return failure();
      term.getCarriesMutable()[i].assign(*dup);
    }
  }
  return success();
}

static bool feedsLoopCarry(Value v) {
  if (auto arg = dyn_cast<BlockArgument>(v))
    if (isa<waveamdmachine::UniformLoopOp>(arg.getOwner()->getParentOp()))
      return true;
  if (v.getDefiningOp<waveamdmachine::UniformLoopOp>())
    return true;
  return llvm::any_of(v.getUsers(), [](Operation *u) {
    return isa<waveamdmachine::UniformLoopOp, waveamdmachine::ContinueIfOp>(u);
  });
}

using ToElementsSourceMap = DenseMap<Value, std::pair<Value, unsigned>>;

static bool isPerfectRoundTrip(waveamdmachine::TupleFromElementsOp op,
                               const ToElementsSourceMap &source) {
  Value sourceTuple;
  unsigned cumOffset = 0;
  for (Value element : op.getElements()) {
    auto srcIt = source.find(element);
    if (srcIt == source.end())
      return false;
    auto [srcTuple, srcSlot] = srcIt->second;
    if (!sourceTuple)
      sourceTuple = srcTuple;
    else if (sourceTuple != srcTuple)
      return false;
    if (srcSlot != cumOffset)
      return false;
    cumOffset += cast<waveamdmachine::RegType>(element.getType()).getWidth();
  }
  if (!sourceTuple)
    return false;
  int64_t fromW =
      cast<waveamdmachine::RegType>(op.getTuple().getType()).getWidth();
  int64_t srcW =
      cast<waveamdmachine::RegType>(sourceTuple.getType()).getWidth();
  return fromW == srcW;
}

static LogicalResult
rewriteFromElementsForSharing(waveamdmachine::TupleFromElementsOp op,
                              OpBuilder &builder,
                              DenseMap<Value, unsigned> &anchorSlot,
                              const ToElementsSourceMap &toElementsSource,
                              DenseSet<Value> &consumedByFromElements) {
  builder.setInsertionPoint(op);
  bool perfectRT = isPerfectRoundTrip(op, toElementsSource);
  SmallVector<Value> newElements;
  newElements.reserve(op.getElements().size());
  bool changed = false;
  unsigned cumOffset = 0;
  for (Value element : op.getElements()) {
    unsigned slot = cumOffset;
    unsigned width =
        cast<waveamdmachine::RegType>(element.getType()).getWidth();
    Value use = element;
    auto anchorIt = anchorSlot.find(element);
    bool slotMismatch =
        anchorIt != anchorSlot.end() && anchorIt->second != slot;
    bool reuse = consumedByFromElements.contains(element);
    bool dragInConflict = !perfectRT && toElementsSource.contains(element);
    if (slotMismatch || reuse || dragInConflict || feedsLoopCarry(element)) {
      FailureOr<Value> dup = duplicateRegValue(builder, op.getLoc(), element);
      if (failed(dup))
        return failure();
      use = *dup;
      anchorSlot[use] = slot;
      changed = true;
    } else {
      anchorSlot[element] = slot;
    }
    consumedByFromElements.insert(use);
    newElements.push_back(use);
    cumOffset += width;
  }
  if (changed)
    op.getElementsMutable().assign(newElements);
  return success();
}

static LogicalResult splitTupleElementSharing(func::FuncOp func) {
  OpBuilder builder(func.getContext());
  DenseMap<Value, unsigned> anchorSlot;
  ToElementsSourceMap toElementsSource;
  DenseSet<Value> consumedByFromElements;
  func.walk([&](waveamdmachine::TupleToElementsOp op) {
    unsigned cumOffset = 0;
    for (Value element : op.getElements()) {
      anchorSlot[element] = cumOffset;
      toElementsSource[element] = {op.getTuple(), cumOffset};
      cumOffset += cast<waveamdmachine::RegType>(element.getType()).getWidth();
    }
  });
  SmallVector<waveamdmachine::TupleFromElementsOp> ops;
  func.walk([&](waveamdmachine::TupleFromElementsOp op) { ops.push_back(op); });
  for (waveamdmachine::TupleFromElementsOp op : ops) {
    if (failed(rewriteFromElementsForSharing(
            op, builder, anchorSlot, toElementsSource, consumedByFromElements)))
      return failure();
  }
  return success();
}

} // namespace

LogicalResult mlir::wave::prepareWaveAMDRegAllocIR(func::FuncOp func) {
  if (failed(materializeLoopBackedgeCopies(func)))
    return failure();
  if (failed(splitDuplicateLoopInits(func)))
    return failure();
  return splitTupleElementSharing(func);
}
