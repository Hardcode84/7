//===- WaveAMDRegAllocPrep.cpp - WaveAMD regalloc preparation ---*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "WaveAMDRegAllocPrep.h"

#include "../WaveAMDHardwareResources.h"
#include "WaveAMDRegAllocInternal.h"
#include "WaveAMDRegAllocTransformUtils.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachine.h"
#include "mlir/IR/Builders.h"
#include "mlir/IR/IRMapping.h"
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

static waveamdmachine::RegType
getUnassignedRegType(waveamdmachine::RegType type) {
  return waveamdmachine::RegType::get(type.getContext(), type.getRegClass(),
                                      type.getWidth(), /*index=*/-1);
}

static bool allResultsDead(Operation *op) {
  return llvm::all_of(op->getResults(),
                      [](Value result) { return result.use_empty(); });
}

static bool isDeadCheapRegOp(Operation *op) {
  return op && op->getNumResults() != 0 && allResultsDead(op) &&
         wave::regalloc::isCheapVGPRPressureReliefExpr(op);
}

static void eraseDeadCheapRegOps(ArrayRef<Operation *> roots) {
  SmallVector<Operation *> worklist(roots);
  DenseSet<Operation *> erased;
  while (!worklist.empty()) {
    Operation *op = worklist.pop_back_val();
    if (!op || erased.contains(op) || !isDeadCheapRegOp(op))
      continue;
    SmallVector<Value> operands(op->getOperands());
    erased.insert(op);
    op->erase();
    for (Value operand : operands)
      if (Operation *def = operand.getDefiningOp())
        worklist.push_back(def);
  }
}

static bool canRematerializeDuplicateRegValue(Value v,
                                              DenseSet<Value> &visiting);

static bool canUseOriginalDuplicateOperand(Value operand) {
  if (!isReg(operand))
    return true;
  std::optional<waveamdmachine::RegType> rt = trackedRegType(operand);
  if (!rt)
    return true;
  return isSGPR(*rt);
}

static bool canRematerializeDuplicateOperand(Value operand,
                                             DenseSet<Value> &visiting) {
  if (canUseOriginalDuplicateOperand(operand))
    return true;
  std::optional<waveamdmachine::RegType> rt = trackedRegType(operand);
  if (!rt || !isVGPR(*rt))
    return false;
  return canRematerializeDuplicateRegValue(operand, visiting);
}

static bool canRematerializeDuplicateRegValue(Value v,
                                              DenseSet<Value> &visiting) {
  std::optional<waveamdmachine::RegType> rt = trackedRegType(v);
  if (!rt || !isVGPR(*rt))
    return false;
  Operation *def = v.getDefiningOp();
  if (!def || !wave::regalloc::isCheapVGPRPressureReliefExpr(def))
    return false;
  if (isa<waveamdmachine::VWorkitemIdXOp>(def))
    return false;
  if (!visiting.insert(v).second)
    return false;
  bool canRemat = llvm::all_of(def->getOperands(), [&](Value operand) {
    return canRematerializeDuplicateOperand(operand, visiting);
  });
  visiting.erase(v);
  return canRemat;
}

static FailureOr<Value>
rematerializeDuplicateRegValue(OpBuilder &builder, Location loc, Value v,
                               DenseMap<Value, Value> &cache);

static FailureOr<Value>
mapRematerializedOperand(OpBuilder &builder, Location loc, Value operand,
                         DenseMap<Value, Value> &cache) {
  if (canUseOriginalDuplicateOperand(operand))
    return operand;
  DenseSet<Value> visiting;
  if (!canRematerializeDuplicateRegValue(operand, visiting))
    return emitError(loc) << "waveamd regalloc cannot rematerialize operand "
                             "while duplicating register value";
  return rematerializeDuplicateRegValue(builder, loc, operand, cache);
}

static FailureOr<Value>
rematerializeDuplicateRegValue(OpBuilder &builder, Location loc, Value v,
                               DenseMap<Value, Value> &cache) {
  if (Value cached = cache.lookup(v))
    return cached;
  Operation *def = v.getDefiningOp();
  if (!def)
    return emitError(loc) << "waveamd regalloc cannot rematerialize block "
                             "argument while duplicating register value";

  IRMapping mapper;
  for (Value operand : def->getOperands()) {
    FailureOr<Value> replacement =
        mapRematerializedOperand(builder, loc, operand, cache);
    if (failed(replacement))
      return failure();
    mapper.map(operand, *replacement);
  }

  Operation *clone = builder.clone(*def, mapper);
  for (OpResult result : clone->getResults()) {
    auto resultType = dyn_cast<waveamdmachine::RegType>(result.getType());
    if (!resultType)
      continue;
    result.setType(getUnassignedRegType(resultType));
  }

  for (auto [original, cloned] :
       llvm::zip(def->getResults(), clone->getResults()))
    cache[original] = cloned;
  return clone->getResult(cast<OpResult>(v).getResultNumber());
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

static FailureOr<Value>
cloneImmediateTupleMove(OpBuilder &builder, Value v,
                        waveamdmachine::RegType resultType) {
  auto mov = v.getDefiningOp<waveamdmachine::VMovB32TupleOp>();
  if (!mov || !mov.getSource().getDefiningOp<waveamdmachine::ImmOp>())
    return failure();
  Operation *clone = builder.clone(*mov);
  clone->getResult(0).setType(resultType);
  return clone->getResult(0);
}

static FailureOr<Value> cloneAGPRDuplicate(OpBuilder &builder, Value v,
                                           waveamdmachine::RegType resultType) {
  if (!hasCloneableAGPRDef(v))
    return failure();
  Operation *clone = builder.clone(*v.getDefiningOp());
  clone->getResult(0).setType(resultType);
  return clone->getResult(0);
}

static Value copyRegDuplicate(OpBuilder &builder, Location loc, Value v,
                              waveamdmachine::RegType resultType) {
  return waveamdmachine::CopyTupleOp::create(builder, loc, resultType, v)
      .getResult();
}

static FailureOr<Value> duplicateRegValue(OpBuilder &builder, Location loc,
                                          Value v,
                                          bool rematerializeVGPR = false) {
  auto rt = cast<waveamdmachine::RegType>(v.getType());
  waveamdmachine::RegType resultType = getUnassignedRegType(rt);
  if (rematerializeVGPR && isVGPR(rt)) {
    DenseSet<Value> visiting;
    if (canRematerializeDuplicateRegValue(v, visiting)) {
      DenseMap<Value, Value> cache;
      return rematerializeDuplicateRegValue(builder, loc, v, cache);
    }
  }

  FailureOr<Value> immClone = cloneImmediateTupleMove(builder, v, resultType);
  if (succeeded(immClone))
    return *immClone;

  if (isAGPR(rt)) {
    FailureOr<Value> agprClone = cloneAGPRDuplicate(builder, v, resultType);
    if (succeeded(agprClone))
      return *agprClone;
    return emitError(loc) << "waveamd regalloc cannot duplicate AGPR value "
                             "before register allocation";
  }

  if (isVGPR(rt) || isSGPR(rt))
    return copyRegDuplicate(builder, loc, v, resultType);
  return emitError(loc, "duplicateRegValue: unsupported register class/width");
}

static Operation *ancestorInBlock(Operation *op, Block *block) {
  while (op && op->getBlock() != block)
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
  if (BlockArgument arg = dyn_cast<BlockArgument>(value))
    return operationIsInside(root, arg.getOwner()->getParentOp());
  return false;
}

static bool hasUseBeforeLoop(Value value, waveamdmachine::UniformLoopOp loop) {
  Block *block = loop->getBlock();
  for (OpOperand &use : value.getUses()) {
    Operation *user = use.getOwner();
    if (user == loop.getOperation())
      continue;
    Operation *top = ancestorInBlock(user, block);
    if (!top || top == loop.getOperation())
      continue;
    if (top->isBeforeInBlock(loop.getOperation()))
      return true;
  }
  return false;
}

static bool shouldRematerializeLoopInit(Value init,
                                        waveamdmachine::UniformLoopOp loop) {
  DenseSet<Value> visiting;
  if (!canRematerializeDuplicateRegValue(init, visiting))
    return false;
  Operation *def = init.getDefiningOp();
  if (def && def->getBlock() == loop->getBlock() &&
      def->getNextNode() == loop.getOperation())
    return false;
  return hasUseBeforeLoop(init, loop);
}

static bool needsLocalNestedLoopInit(waveamdmachine::UniformLoopOp loop,
                                     Value init) {
  if (!trackedRegType(init))
    return false;
  waveamdmachine::UniformLoopOp parentLoop =
      loop->getParentOfType<waveamdmachine::UniformLoopOp>();
  return parentLoop && !valueIsDefinedInside(parentLoop.getOperation(), init);
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
      bool repeatedInit = !seen.insert(init).second;
      bool localNestedInit = needsLocalNestedLoopInit(loop, init);
      bool rematInit = shouldRematerializeLoopInit(init, loop);
      if (!repeatedInit && !localNestedInit && !rematInit)
        continue;
      Operation *def = init.getDefiningOp();
      FailureOr<Value> dup =
          duplicateRegValue(builder, loop.getLoc(), init, rematInit);
      if (failed(dup))
        return failure();
      loop.getInitsMutable()[i].assign(*dup);
      eraseDeadCheapRegOps({def});
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

struct KilledOperandReuseIsaCache {
  KilledOperandReuseIsaCache(func::FuncOp func) : func(func) {}

  const llvm::AMDGPU::IsaVersion *get() {
    if (isa)
      return &*isa;
    if (failed)
      return nullptr;
    FailureOr<llvm::AMDGPU::IsaVersion> parsed =
        waveamdmachine::getAMDGPUTargetIsaVersion(
            func, "waveamd regalloc required killed operand reuse");
    if (mlir::failed(parsed)) {
      failed = true;
      return nullptr;
    }
    isa = *parsed;
    return &*isa;
  }

  std::optional<llvm::AMDGPU::IsaVersion> isa;
  func::FuncOp func;
  bool failed = false;
};

static void collectRequiredKilledOperandInputCopies(
    Operation *op, KilledOperandReuseIsaCache &isaCache,
    SmallVectorImpl<std::pair<Operation *, unsigned>> &operands) {
  waveamdmachine::KilledOperandReuseOpInterface reuse =
      wave::regalloc_detail::getKilledOperandReuseCandidate(op);
  if (!reuse)
    return;
  const llvm::AMDGPU::IsaVersion *targetIsa = isaCache.get();
  if (!targetIsa)
    return;
  for (OpOperand &operand : op->getOpOperands()) {
    if (!wave::regalloc_detail::requiresKilledOperandReuseForResult(
            reuse, operand, *targetIsa))
      continue;
    if (llvm::hasSingleElement(operand.get().getUses()))
      continue;
    operands.push_back({op, operand.getOperandNumber()});
  }
}

static LogicalResult splitRequiredKilledOperandInputs(func::FuncOp func) {
  SmallVector<std::pair<Operation *, unsigned>> operands;
  KilledOperandReuseIsaCache isaCache(func);
  func.walk([&](Operation *op) {
    collectRequiredKilledOperandInputCopies(op, isaCache, operands);
  });

  OpBuilder builder(func.getContext());
  for (auto [op, operandNumber] : operands) {
    OpOperand &operand = op->getOpOperand(operandNumber);
    Value value = operand.get();
    if (llvm::hasSingleElement(value.getUses()))
      continue;
    if (!copyableRegType(value))
      return op->emitError("required killed operand reuse has non-copyable "
                           "multi-use operand");
    builder.setInsertionPoint(op);
    FailureOr<Value> dup = duplicateRegValue(builder, op->getLoc(), value);
    if (failed(dup))
      return failure();
    operand.assign(*dup);
  }
  return success();
}

static Operation *topLevelBodyOp(Block &body, Operation *op) {
  while (op && op->getBlock() != &body)
    op = op->getParentOp();
  return op;
}

static bool hasUseAfter(BlockArgument arg, Operation *op) {
  Block &body = *arg.getOwner();
  for (OpOperand &use : arg.getUses()) {
    Operation *user = topLevelBodyOp(body, use.getOwner());
    if (!user || isa<waveamdmachine::ContinueIfOp>(user))
      continue;
    if (op->isBeforeInBlock(user))
      return true;
  }
  return false;
}

static bool needsBackedgeCopy(waveamdmachine::UniformLoopOp loop, unsigned i,
                              Value carry) {
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
  return hasUseAfter(arg, top);
}

static LogicalResult materializeLoopBackedgeCopies(func::FuncOp func) {
  SmallVector<waveamdmachine::UniformLoopOp> loops;
  func.walk([&](waveamdmachine::UniformLoopOp loop) { loops.push_back(loop); });
  OpBuilder builder(func.getContext());
  for (waveamdmachine::UniformLoopOp loop : loops) {
    Block &body = loop.getBody().front();
    auto term = cast<waveamdmachine::ContinueIfOp>(body.getTerminator());
    SmallVector<std::pair<unsigned, Value>> copies;
    for (auto [i, carry] : llvm::enumerate(term.getCarries())) {
      if (!trackedRegType(carry))
        continue;
      if (needsBackedgeCopy(loop, i, carry))
        copies.push_back({i, carry});
    }
    builder.setInsertionPoint(term);
    for (auto [i, carry] : copies) {
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
  return llvm::any_of(v.getUsers(), [](Operation *user) {
    return isa<waveamdmachine::UniformLoopOp, waveamdmachine::ContinueIfOp>(
        user);
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

static bool isScalarMaskSinkOp(Operation *op) {
  if (!isa<waveamdmachine::SCmpEqU32Op, waveamdmachine::SCmpLtU32Op,
           waveamdmachine::SCmpLeU32Op, waveamdmachine::SCmpGtU32Op,
           waveamdmachine::SCmpGeU32Op, waveamdmachine::SCmpEqI32Op,
           waveamdmachine::SCmpLtI32Op, waveamdmachine::SCmpLeI32Op,
           waveamdmachine::SCmpGtI32Op, waveamdmachine::SCmpGeI32Op,
           waveamdmachine::VCmpEqU32VccOp, waveamdmachine::VCmpNeU32VccOp,
           waveamdmachine::VCmpLtU32VccOp, waveamdmachine::VCmpLeU32VccOp,
           waveamdmachine::VCmpGtU32VccOp, waveamdmachine::VCmpGeU32VccOp,
           waveamdmachine::VCmpLtI32VccOp, waveamdmachine::VCmpLeI32VccOp,
           waveamdmachine::VCmpGtI32VccOp, waveamdmachine::VCmpGeI32VccOp>(op))
    return false;
  return llvm::all_of(op->getResults(), [](Value result) {
    auto type = dyn_cast<waveamdmachine::RegType>(result.getType());
    return type && (isSGPR(type) ||
                    type.getRegClass() == waveamdmachine::RegClass::SCC ||
                    type.getRegClass() == waveamdmachine::RegClass::VCC);
  });
}

static bool collectScalarMaskSinkClosure(Value value, Operation *anchor,
                                         DenseSet<Operation *> &seen,
                                         SmallVectorImpl<Operation *> &ops) {
  Operation *def = value.getDefiningOp();
  if (!def || !isScalarMaskSinkOp(def))
    return true;
  if (def->getBlock() != anchor->getBlock() || !def->isBeforeInBlock(anchor))
    return false;
  if (!seen.insert(def).second)
    return true;
  for (Value operand : def->getOperands())
    if (!collectScalarMaskSinkClosure(operand, anchor, seen, ops))
      return false;
  ops.push_back(def);
  return true;
}

static bool hasOnlySinkClosureUses(Operation *op, Operation *anchor,
                                   const DenseSet<Operation *> &closure) {
  return llvm::all_of(op->getResults(), [&](Value result) {
    return llvm::all_of(result.getUsers(), [&](Operation *user) {
      return user == anchor || closure.contains(user);
    });
  });
}

static bool sinkScalarMaskClosure(Operation *anchor) {
  DenseSet<Operation *> closure;
  SmallVector<Operation *> ops;
  for (Value operand : anchor->getOperands())
    if (!collectScalarMaskSinkClosure(operand, anchor, closure, ops))
      return false;
  if (ops.empty())
    return false;
  if (!llvm::all_of(ops, [&](Operation *op) {
        return hasOnlySinkClosureUses(op, anchor, closure);
      }))
    return false;
  llvm::sort(ops, [](Operation *lhs, Operation *rhs) {
    return lhs->isBeforeInBlock(rhs);
  });
  for (Operation *op : ops)
    op->moveBefore(anchor);
  return true;
}

static LogicalResult sinkSingleUseScalarMasks(func::FuncOp func) {
  SmallVector<Operation *> ops;
  func.walk([&](Operation *op) { ops.push_back(op); });
  for (Operation *op : ops)
    sinkScalarMaskClosure(op);
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
  if (failed(splitRequiredKilledOperandInputs(func)))
    return failure();
  if (failed(splitTupleElementSharing(func)))
    return failure();
  return sinkSingleUseScalarMasks(func);
}
