//===- WaveAMDRegAllocPrep.cpp - WaveAMD regalloc preparation ---*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "WaveAMDRegAllocPrep.h"

#include "WaveAMDHardwareResources.h"
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

static bool isAGPR(waveamdmachine::RegType type) {
  return type.getRegClass() == waveamdmachine::RegClass::AGPR;
}

static std::optional<waveamdmachine::RegType> trackedRegType(Value v) {
  if (!isReg(v))
    return std::nullopt;
  auto rt = cast<waveamdmachine::RegType>(v.getType());
  if (wave::getHardwareResourceForValue(v))
    return std::nullopt;
  return rt;
}

static std::optional<waveamdmachine::RegType> copyableRegType(Value v) {
  std::optional<waveamdmachine::RegType> rt = trackedRegType(v);
  if (!rt || isAGPR(*rt))
    return std::nullopt;
  return rt;
}

static bool hasCloneableAGPRDef(Value v) {
  if (!isReg(v))
    return false;
  auto rt = cast<waveamdmachine::RegType>(v.getType());
  if (!isAGPR(rt))
    return false;
  Operation *def = v.getDefiningOp();
  return isa_and_nonnull<waveamdmachine::UninitOp,
                         waveamdmachine::VAccvgprWriteB32TupleOp>(def);
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
  if (isAGPR(rt) && hasCloneableAGPRDef(v)) {
    Operation *clone = builder.clone(*v.getDefiningOp());
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
  if (isAGPR(rt)) {
    auto vgprType = waveamdmachine::RegType::get(
        rt.getContext(), waveamdmachine::RegClass::VGPR, rt.getWidth(),
        /*index=*/-1);
    auto read = waveamdmachine::VAccvgprReadB32TupleOp::create(builder, loc,
                                                               vgprType, v);
    auto write = waveamdmachine::VAccvgprWriteB32TupleOp::create(
        builder, loc, resultType, read.getResult());
    return write.getResult();
  }
  return emitError(loc, "duplicateRegValue: unsupported register class/width");
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

static LogicalResult splitDuplicateMFMAAccumulatorInputs(func::FuncOp func) {
  SmallVector<waveamdmachine::MMAOpInterface> ops;
  func.walk([&](waveamdmachine::MMAOpInterface op) {
    if (op.getOperation()->hasTrait<OpTrait::waveamdmachine::MFMAOp>())
      ops.push_back(op);
  });

  OpBuilder builder(func.getContext());
  for (waveamdmachine::MMAOpInterface op : ops) {
    Value acc = op.getAcc();
    if (!copyableRegType(acc))
      continue;
    if (llvm::hasSingleElement(acc.getUses()))
      continue;
    builder.setInsertionPoint(op.getOperation());
    FailureOr<Value> dup = duplicateRegValue(builder, op.getLoc(), acc);
    if (failed(dup))
      return failure();
    op.setAcc(*dup);
  }
  return success();
}

static Operation *topLevelBodyOp(Block &body, Operation *op) {
  while (op && op->getBlock() != &body)
    op = op->getParentOp();
  return op;
}

static bool operationIsInside(Operation *root, Operation *op) {
  for (Operation *cur = op; cur; cur = cur->getParentOp())
    if (cur == root)
      return true;
  return false;
}

static bool valueIsDefinedInside(Operation *root, Value value) {
  if (Operation *def = value.getDefiningOp())
    return operationIsInside(root, def);
  if (auto arg = dyn_cast<BlockArgument>(value))
    return operationIsInside(root, arg.getOwner()->getParentOp());
  return false;
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

static bool hasFixedElement(ValueRange elements) {
  return llvm::any_of(elements, [](Value element) {
    return cast<waveamdmachine::RegType>(element.getType()).getIndex() >= 0;
  });
}

static std::optional<unsigned>
slotInTupleElements(waveamdmachine::TupleFromElementsOp op, Value needle) {
  unsigned cumOffset = 0;
  for (Value element : op.getElements()) {
    if (element == needle)
      return cumOffset;
    cumOffset += cast<waveamdmachine::RegType>(element.getType()).getWidth();
  }
  return std::nullopt;
}

static bool hasSingleUseBy(Value value, Operation *user) {
  return llvm::hasSingleElement(value.getUses()) &&
         value.use_begin()->getOwner() == user;
}

static bool
splitElementFitsConsumer(waveamdmachine::TupleFromElementsOp consumer,
                         Value splitElement, Value sourceTuple,
                         unsigned slotDelta,
                         const ToElementsSourceMap &toElementsSource) {
  auto splitIt = toElementsSource.find(splitElement);
  if (splitIt == toElementsSource.end())
    return false;
  if (splitIt->second.first != sourceTuple)
    return false;
  if (!hasSingleUseBy(splitElement, consumer.getOperation()))
    return false;
  std::optional<unsigned> slot = slotInTupleElements(consumer, splitElement);
  if (!slot)
    return false;
  return *slot == splitIt->second.second + slotDelta;
}

static bool
canReanchorSingleUseSplitElement(waveamdmachine::TupleFromElementsOp consumer,
                                 Value element, unsigned consumerSlot,
                                 const ToElementsSourceMap &toElementsSource) {
  auto sourceIt = toElementsSource.find(element);
  if (sourceIt == toElementsSource.end())
    return false;
  Value sourceTuple = sourceIt->second.first;
  unsigned sourceSlot = sourceIt->second.second;
  auto split = element.getDefiningOp<waveamdmachine::TupleToElementsOp>();
  if (!split || split.getTuple() != sourceTuple)
    return false;
  if (!hasSingleUseBy(sourceTuple, split.getOperation()))
    return false;
  if (consumerSlot < sourceSlot)
    return false;
  unsigned slotDelta = consumerSlot - sourceSlot;
  for (Value splitElement : split.getElements())
    if (!splitElementFitsConsumer(consumer, splitElement, sourceTuple,
                                  slotDelta, toElementsSource))
      return false;
  return true;
}

static bool hasSlotMismatch(DenseMap<Value, unsigned> &anchorSlot,
                            Value element, unsigned slot) {
  auto anchorIt = anchorSlot.find(element);
  return anchorIt != anchorSlot.end() && anchorIt->second != slot;
}

static bool hasDragInConflict(bool perfectRT, Value element,
                              const ToElementsSourceMap &toElementsSource,
                              bool singleUseSplitConcat) {
  return !perfectRT && toElementsSource.contains(element) &&
         !singleUseSplitConcat;
}

static bool breaksUnfixedRoundTrip(waveamdmachine::TupleFromElementsOp op,
                                   waveamdmachine::RegType tupleType,
                                   bool perfectRT) {
  return perfectRT && tupleType.getIndex() < 0 &&
         hasFixedElement(op.getElements());
}

static bool needsTupleElementCopy(Value element, bool slotMismatch, bool reuse,
                                  bool dragInConflict,
                                  bool fixedElementInUnfixedTuple,
                                  bool brokenRoundTripElement) {
  return slotMismatch || reuse || dragInConflict ||
         fixedElementInUnfixedTuple || brokenRoundTripElement ||
         feedsLoopCarry(element);
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
  waveamdmachine::RegType tupleType =
      cast<waveamdmachine::RegType>(op.getTuple().getType());
  bool copyRoundTripElements = breaksUnfixedRoundTrip(op, tupleType, perfectRT);
  for (Value element : op.getElements()) {
    unsigned slot = cumOffset;
    waveamdmachine::RegType elementType =
        cast<waveamdmachine::RegType>(element.getType());
    unsigned width = elementType.getWidth();
    Value use = element;
    bool singleUseSplitConcat =
        canReanchorSingleUseSplitElement(op, element, slot, toElementsSource);
    bool slotMismatch =
        hasSlotMismatch(anchorSlot, element, slot) && !singleUseSplitConcat;
    bool reuse = consumedByFromElements.contains(element);
    bool dragInConflict = hasDragInConflict(
        perfectRT, element, toElementsSource, singleUseSplitConcat);
    bool fixedElementInUnfixedTuple =
        tupleType.getIndex() < 0 && elementType.getIndex() >= 0;
    bool brokenRoundTripElement =
        copyRoundTripElements && toElementsSource.contains(element);
    if (needsTupleElementCopy(element, slotMismatch, reuse, dragInConflict,
                              fixedElementInUnfixedTuple,
                              brokenRoundTripElement)) {
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

static bool isUniformIfCopyableYield(Value value) {
  auto rt = dyn_cast<waveamdmachine::RegType>(value.getType());
  return rt && (isSGPR(rt) || isVGPR(rt));
}

static LogicalResult
materializeUniformIfRegionYieldCopies(waveamdmachine::UniformIfOp uniformIf,
                                      Region &region, OpBuilder &builder) {
  if (region.empty())
    return success();
  auto yield =
      dyn_cast<waveamdmachine::YieldOp>(region.front().getTerminator());
  if (!yield)
    return success();
  SmallVector<Value> values(yield.getValues());
  bool changed = false;
  builder.setInsertionPoint(yield);
  for (auto [index, value] : llvm::enumerate(values)) {
    if (!isUniformIfCopyableYield(value))
      continue;
    if (valueIsDefinedInside(uniformIf, value))
      continue;
    FailureOr<Value> dup = duplicateRegValue(builder, yield.getLoc(), value);
    if (failed(dup))
      return failure();
    values[index] = *dup;
    changed = true;
  }
  if (changed)
    yield.getValuesMutable().assign(values);
  return success();
}

static LogicalResult materializeUniformIfYieldCopies(func::FuncOp func) {
  SmallVector<waveamdmachine::UniformIfOp> ops;
  func.walk([&](waveamdmachine::UniformIfOp op) { ops.push_back(op); });
  OpBuilder builder(func.getContext());
  for (waveamdmachine::UniformIfOp op : ops) {
    if (failed(materializeUniformIfRegionYieldCopies(op, op.getThenRegion(),
                                                     builder)))
      return failure();
    if (failed(materializeUniformIfRegionYieldCopies(op, op.getElseRegion(),
                                                     builder)))
      return failure();
  }
  return success();
}

} // namespace

LogicalResult mlir::wave::prepareWaveAMDRegAllocIR(func::FuncOp func) {
  if (failed(materializeUniformIfYieldCopies(func)))
    return failure();
  if (failed(materializeLoopBackedgeCopies(func)))
    return failure();
  if (failed(splitDuplicateLoopInits(func)))
    return failure();
  if (failed(splitDuplicateMFMAAccumulatorInputs(func)))
    return failure();
  return splitTupleElementSharing(func);
}
