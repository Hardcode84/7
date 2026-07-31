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
#include "WaveAMDRegisterLimits.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachine.h"
#include "mlir/IR/Builders.h"
#include "mlir/IR/IRMapping.h"
#include "mlir/Interfaces/ControlFlowInterfaces.h"
#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/DenseSet.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/Support/MathExtras.h"
#include <optional>

using namespace mlir;

namespace {

enum class DuplicateRematPolicy { Never, AnyLegal, CopyCostBounded };

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

static bool requiresMCTupleEncoding(Value value) {
  return llvm::any_of(value.getUses(), [](OpOperand &use) {
    return waveamdmachine::requiresMCTupleEncoding(use);
  });
}

static unsigned getFallbackTupleAlignment(waveamdmachine::RegType type) {
  unsigned width = type.getWidth();
  if (width <= 1)
    return 1;
  return std::max<unsigned>(1, llvm::PowerOf2Ceil(width));
}

static unsigned
getAddressableRegisterCount(const wave::WaveAMDRegisterLimits &limits,
                            waveamdmachine::RegType type) {
  if (isSGPR(type))
    return limits.addressableSGPRs;
  if (isVGPR(type))
    return limits.addressableVGPRs;
  if (isAGPR(type))
    return limits.addressableAGPRs;
  return 0;
}

static bool isTupleBaseLegal(const wave::WaveAMDRegisterLimits &limits,
                             waveamdmachine::RegType type, unsigned base,
                             bool exactSGPRBase) {
  if (isSGPR(type))
    return exactSGPRBase ? limits.isSGPRTupleBaseLegal(type.getWidth(), base)
                         : base % getFallbackTupleAlignment(type) == 0;
  return wave::isWaveAMDRegisterTupleBaseLegal(limits, type.getRegClass(),
                                               type.getWidth(), base);
}

static bool hasTargetCompatibleTupleBases(
    waveamdmachine::RegType outerType, waveamdmachine::RegType innerType,
    unsigned innerOffset, const wave::WaveAMDRegisterLimits &targetLimits,
    bool exactOuterSGPRBase, bool exactInnerSGPRBase) {
  unsigned limit = getAddressableRegisterCount(targetLimits, outerType);
  unsigned outerWidth = outerType.getWidth();
  unsigned innerWidth = innerType.getWidth();
  if (outerWidth > limit || innerOffset > outerWidth ||
      innerWidth > outerWidth - innerOffset)
    return false;
  for (unsigned outerBase = 0; outerBase <= limit - outerWidth; ++outerBase) {
    if (!isTupleBaseLegal(targetLimits, outerType, outerBase,
                          exactOuterSGPRBase))
      continue;
    if (isTupleBaseLegal(targetLimits, innerType, outerBase + innerOffset,
                         exactInnerSGPRBase))
      return true;
  }
  return false;
}

static bool
hasCompatibleTupleBases(waveamdmachine::RegType outerType,
                        waveamdmachine::RegType innerType, unsigned innerOffset,
                        const wave::WaveAMDRegisterLimits *targetLimits,
                        bool exactOuterSGPRBase, bool exactInnerSGPRBase) {
  if (outerType.getRegClass() != innerType.getRegClass())
    return false;
  if (!targetLimits ||
      (isSGPR(innerType) && !exactOuterSGPRBase && !exactInnerSGPRBase))
    return innerOffset % getFallbackTupleAlignment(innerType) == 0;
  return hasTargetCompatibleTupleBases(outerType, innerType, innerOffset,
                                       *targetLimits, exactOuterSGPRBase,
                                       exactInnerSGPRBase);
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

static void eraseRegAfterOps(func::FuncOp func) {
  SmallVector<waveamdmachine::RegAfterOp> ops;
  func.walk([&](waveamdmachine::RegAfterOp op) { ops.push_back(op); });
  for (waveamdmachine::RegAfterOp op : ops) {
    op.getResult().replaceAllUsesWith(op.getSource());
    op.erase();
  }
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
  if (isa<waveamdmachine::VWorkitemIdXOp, waveamdmachine::VWorkitemIdYOp,
          waveamdmachine::VWorkitemIdZOp>(def))
    return false;
  wave::HardwareResourceEffects effects = wave::getHardwareResourceEffects(def);
  if (!effects.reads.empty() || !effects.writes.empty())
    return false;
  if (!visiting.insert(v).second)
    return false;
  bool canRemat = llvm::all_of(def->getOperands(), [&](Value operand) {
    return canRematerializeDuplicateOperand(operand, visiting);
  });
  visiting.erase(v);
  return canRemat;
}

static bool consumeDuplicateRematerializationOpCost(Operation *op,
                                                    unsigned &budget) {
  if (op->hasTrait<OpTrait::waveamdmachine::NoMachineInst>())
    return true;
  bool charged = false;
  for (Value result : op->getResults()) {
    waveamdmachine::RegType type =
        dyn_cast<waveamdmachine::RegType>(result.getType());
    if (!type)
      continue;
    charged = true;
    if (static_cast<unsigned>(type.getWidth()) > budget)
      return false;
    budget -= static_cast<unsigned>(type.getWidth());
  }
  if (charged)
    return true;
  if (budget == 0)
    return false;
  --budget;
  return true;
}

static bool duplicateRematerializationFitsCost(Value v, unsigned &budget,
                                               DenseSet<Operation *> &counted) {
  Operation *def = v.getDefiningOp();
  assert(def && "rematerialization legality requires an op result");
  if (!counted.insert(def).second)
    return true;
  if (!consumeDuplicateRematerializationOpCost(def, budget))
    return false;
  for (Value operand : def->getOperands()) {
    if (canUseOriginalDuplicateOperand(operand))
      continue;
    if (!duplicateRematerializationFitsCost(operand, budget, counted))
      return false;
  }
  return true;
}

static bool canProfitablyRematerializeDuplicateRegValue(Value v) {
  DenseSet<Value> visiting;
  if (!canRematerializeDuplicateRegValue(v, visiting))
    return false;
  unsigned budget = cast<waveamdmachine::RegType>(v.getType()).getWidth();
  DenseSet<Operation *> counted;
  return duplicateRematerializationFitsCost(v, budget, counted);
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

static FailureOr<Value> duplicateRegValue(
    OpBuilder &builder, Location loc, Value v,
    DuplicateRematPolicy rematPolicy = DuplicateRematPolicy::Never) {
  auto rt = cast<waveamdmachine::RegType>(v.getType());
  waveamdmachine::RegType resultType = getUnassignedRegType(rt);
  if (rematPolicy != DuplicateRematPolicy::Never && isVGPR(rt)) {
    bool canRematerialize = false;
    if (rematPolicy == DuplicateRematPolicy::AnyLegal) {
      DenseSet<Value> visiting;
      canRematerialize = canRematerializeDuplicateRegValue(v, visiting);
    } else {
      canRematerialize = canProfitablyRematerializeDuplicateRegValue(v);
    }
    if (canRematerialize) {
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

static Region *getChildRegion(Operation *parent, Operation *nested) {
  for (Region *region = nested->getParentRegion(); region;) {
    Operation *owner = region->getParentOp();
    if (owner == parent)
      return region;
    region = owner ? owner->getParentRegion() : nullptr;
  }
  return nullptr;
}

static bool regionMayReach(RegionBranchOpInterface branch, Region *source,
                           Region *target) {
  SmallVector<Region *, 4> pending{source};
  DenseSet<Region *> visited;
  SmallVector<RegionSuccessor, 4> successors;
  while (!pending.empty()) {
    Region *region = pending.pop_back_val();
    if (!visited.insert(region).second)
      continue;
    if (region == target)
      return true;
    for (Block &block : *region) {
      RegionBranchTerminatorOpInterface terminator =
          dyn_cast<RegionBranchTerminatorOpInterface>(block.getTerminator());
      if (!terminator)
        continue;
      successors.clear();
      branch.getSuccessorRegions(RegionBranchPoint(terminator), successors);
      for (RegionSuccessor successor : successors)
        if (!successor.isOperation())
          pending.push_back(successor.getSuccessor());
    }
  }
  return false;
}

static bool useCannotFollow(Operation *from, Operation *user) {
  for (Operation *parent = from->getParentOp(); parent;
       parent = parent->getParentOp()) {
    RegionBranchOpInterface branch = dyn_cast<RegionBranchOpInterface>(parent);
    if (!branch)
      continue;
    Region *fromRegion = getChildRegion(parent, from);
    Region *useRegion = getChildRegion(parent, user);
    if (fromRegion && useRegion && fromRegion != useRegion &&
        !regionMayReach(branch, fromRegion, useRegion))
      return true;
  }
  return false;
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

static bool useMayFollowThroughLoop(Value value, Operation *from,
                                    Operation *user) {
  for (Operation *parent = from->getParentOp(); parent;
       parent = parent->getParentOp()) {
    auto loop = dyn_cast<waveamdmachine::UniformLoopOp>(parent);
    if (loop && !valueIsDefinedInside(loop, value) &&
        user != loop.getOperation() &&
        operationIsInside(loop.getOperation(), user))
      return true;
  }
  return false;
}

static bool useMayFollow(Value value, Operation *from, Operation *user) {
  if (from == user)
    return false;
  if (useMayFollowThroughLoop(value, from, user))
    return true;
  if (useCannotFollow(from, user))
    return false;
  for (Operation *fromTop = from; fromTop; fromTop = fromTop->getParentOp()) {
    Operation *userTop = ancestorInBlock(user, fromTop->getBlock());
    if (!userTop)
      continue;
    if (fromTop == userTop)
      return true;
    return fromTop->isBeforeInBlock(userTop);
  }
  return true;
}

static bool hasInvariantBodyRead(Value value,
                                 waveamdmachine::UniformLoopOp loop) {
  Operation *terminator = loop.getBody().front().getTerminator();
  for (OpOperand &use : value.getUses()) {
    Operation *user = use.getOwner();
    if (user != loop.getOperation() && user != terminator &&
        operationIsInside(loop.getOperation(), user))
      return true;
  }
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

static bool hasUseAfterLoop(Value value, waveamdmachine::UniformLoopOp loop) {
  return llvm::any_of(value.getUses(), [&](OpOperand &use) {
    Operation *user = use.getOwner();
    return user != loop.getOperation() &&
           !operationIsInside(loop.getOperation(), user) &&
           useMayFollow(value, loop, user);
  });
}

static bool valueIsLiveAfter(Value value, Operation *op) {
  return llvm::any_of(value.getUses(), [&](OpOperand &use) {
    return use.getOwner() != op && useMayFollow(value, op, use.getOwner());
  });
}

static bool valueUseRepeatsAfter(Value value, Operation *op) {
  for (Operation *parent = op->getParentOp(); parent;
       parent = parent->getParentOp())
    if (isa<waveamdmachine::UniformLoopOp>(parent) &&
        !valueIsDefinedInside(parent, value))
      return true;
  return false;
}

static bool valueDiesAt(Value value, Operation *op) {
  return !valueUseRepeatsAfter(value, op) && !valueIsLiveAfter(value, op);
}

static Operation *
getUpdateTupleCopyAnchor(waveamdmachine::UpdateTupleOp update) {
  Operation *anchor = update.getOperation();
  Value base = update.getBase();
  for (Operation *parent = update->getParentOp(); parent;
       parent = parent->getParentOp())
    if (isa<waveamdmachine::UniformLoopOp>(parent) &&
        !valueIsDefinedInside(parent, base))
      anchor = parent;
  return anchor;
}

static LogicalResult splitLiveUpdateTupleBases(func::FuncOp func) {
  SmallVector<waveamdmachine::UpdateTupleOp> updates;
  func.walk([&](waveamdmachine::UpdateTupleOp update) {
    if (valueIsLiveAfter(update.getBase(), update))
      updates.push_back(update);
  });

  OpBuilder builder(func.getContext());
  for (waveamdmachine::UpdateTupleOp update : updates) {
    Operation *anchor = getUpdateTupleCopyAnchor(update);
    builder.setInsertionPoint(anchor);
    FailureOr<Value> copy =
        duplicateRegValue(builder, update.getLoc(), update.getBase());
    if (failed(copy))
      return failure();
    update.getBaseMutable().assign(*copy);
  }
  return success();
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

static bool needsDistinctLoopInit(Value init,
                                  waveamdmachine::UniformLoopOp loop,
                                  bool repeatedInit, bool rematInit) {
  return repeatedInit || needsLocalNestedLoopInit(loop, init) || rematInit ||
         hasInvariantBodyRead(init, loop) || hasUseAfterLoop(init, loop);
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
      bool rematInit = shouldRematerializeLoopInit(init, loop);
      if (!needsDistinctLoopInit(init, loop, repeatedInit, rematInit))
        continue;
      Operation *def = init.getDefiningOp();
      DuplicateRematPolicy rematPolicy =
          rematInit ? DuplicateRematPolicy::AnyLegal
                    : DuplicateRematPolicy::CopyCostBounded;
      FailureOr<Value> dup =
          duplicateRegValue(builder, loop.getLoc(), init, rematPolicy);
      if (failed(dup))
        return failure();
      loop.getInitsMutable()[i].assign(*dup);
      eraseDeadCheapRegOps({def});
    }
  }
  return success();
}

static DenseSet<Value> collectRematerializableMFMAAccumulators(
    ArrayRef<waveamdmachine::MMAOpInterface> ops) {
  DenseSet<Value> rematerializeAccumulators;
  for (waveamdmachine::MMAOpInterface op : ops) {
    Value acc = op.getAcc();
    if (!copyableRegType(acc) || llvm::hasSingleElement(acc.getUses()))
      continue;
    if (canProfitablyRematerializeDuplicateRegValue(acc))
      rematerializeAccumulators.insert(acc);
  }
  return rematerializeAccumulators;
}

static LogicalResult splitDuplicateMFMAAccumulatorInputs(func::FuncOp func) {
  SmallVector<waveamdmachine::MMAOpInterface> ops;
  func.walk([&](waveamdmachine::MMAOpInterface op) {
    if (op.getOperation()->hasTrait<OpTrait::waveamdmachine::MFMAOp>())
      ops.push_back(op);
  });

  DenseSet<Value> rematerializeAccumulators =
      collectRematerializableMFMAAccumulators(ops);

  OpBuilder builder(func.getContext());
  for (waveamdmachine::MMAOpInterface op : ops) {
    Value acc = op.getAcc();
    if (!copyableRegType(acc))
      continue;
    bool canRematerialize = rematerializeAccumulators.contains(acc);
    if (llvm::hasSingleElement(acc.getUses()) && !canRematerialize)
      continue;
    Operation *def = acc.getDefiningOp();
    builder.setInsertionPoint(op.getOperation());
    DuplicateRematPolicy rematPolicy =
        canRematerialize ? DuplicateRematPolicy::CopyCostBounded
                         : DuplicateRematPolicy::Never;
    FailureOr<Value> dup =
        duplicateRegValue(builder, op.getLoc(), acc, rematPolicy);
    if (failed(dup))
      return failure();
    op.setAcc(*dup);
    eraseDeadCheapRegOps({def});
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

static LogicalResult
splitRequiredKilledOperandInputs(func::FuncOp func,
                                 KilledOperandReuseIsaCache &isaCache) {
  SmallVector<std::pair<Operation *, unsigned>> operands;
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

struct AlignedTupleView {
  Value sourceTuple;
  unsigned sourceOffset = 0;
};

struct AlignedTupleViewState {
  std::optional<unsigned> sourceOffset;
  Value sourceTuple;
  unsigned consumerOffset = 0;
};

static bool addAlignedTupleViewElement(Value element,
                                       const ToElementsSourceMap &source,
                                       AlignedTupleViewState &state) {
  auto sourceIt = source.find(element);
  if (sourceIt == source.end())
    return false;
  auto [elementSource, elementOffset] = sourceIt->second;
  if (!state.sourceTuple)
    state.sourceTuple = elementSource;
  else if (state.sourceTuple != elementSource)
    return false;
  if (elementOffset < state.consumerOffset)
    return false;
  unsigned sourceOffset = elementOffset - state.consumerOffset;
  if (state.sourceOffset && *state.sourceOffset != sourceOffset)
    return false;
  state.sourceOffset = sourceOffset;
  state.consumerOffset +=
      cast<waveamdmachine::RegType>(element.getType()).getWidth();
  return true;
}

static std::optional<AlignedTupleView>
getAlignedTupleView(waveamdmachine::TupleFromElementsOp op,
                    const ToElementsSourceMap &source,
                    const wave::WaveAMDRegisterLimits *targetLimits) {
  AlignedTupleViewState state;
  for (Value element : op.getElements())
    if (!addAlignedTupleViewElement(element, source, state))
      return std::nullopt;
  if (!state.sourceTuple)
    return std::nullopt;
  if (!state.sourceOffset)
    return std::nullopt;
  waveamdmachine::RegType tupleType =
      cast<waveamdmachine::RegType>(op.getTuple().getType());
  unsigned tupleWidth = tupleType.getWidth();
  unsigned sourceWidth =
      cast<waveamdmachine::RegType>(state.sourceTuple.getType()).getWidth();
  if (state.consumerOffset != tupleWidth)
    return std::nullopt;
  if (*state.sourceOffset + tupleWidth > sourceWidth)
    return std::nullopt;
  waveamdmachine::RegType sourceType =
      cast<waveamdmachine::RegType>(state.sourceTuple.getType());
  if (!hasCompatibleTupleBases(sourceType, tupleType, *state.sourceOffset,
                               targetLimits,
                               requiresMCTupleEncoding(state.sourceTuple),
                               requiresMCTupleEncoding(op.getTuple())))
    return std::nullopt;
  return AlignedTupleView{state.sourceTuple, *state.sourceOffset};
}

static bool addFixedBaseConstraint(Value value, unsigned offset,
                                   std::optional<int64_t> &fixedBase) {
  int64_t index = cast<waveamdmachine::RegType>(value.getType()).getIndex();
  if (index < 0)
    return true;
  if (index < offset)
    return false;
  int64_t base = index - offset;
  if (fixedBase && *fixedBase != base)
    return false;
  fixedBase = base;
  return true;
}

static bool hasFixedViewConflict(waveamdmachine::TupleFromElementsOp op,
                                 AlignedTupleView view,
                                 const ToElementsSourceMap &source) {
  std::optional<int64_t> fixedBase;
  if (!addFixedBaseConstraint(view.sourceTuple, 0, fixedBase) ||
      !addFixedBaseConstraint(op.getTuple(), view.sourceOffset, fixedBase))
    return true;
  for (Value element : op.getElements()) {
    auto sourceIt = source.find(element);
    assert(sourceIt != source.end() && "aligned view element lacks source");
    if (!addFixedBaseConstraint(element, sourceIt->second.second, fixedBase))
      return true;
  }
  return false;
}

static bool hasSingleUseBy(Value value, Operation *user) {
  return llvm::hasSingleElement(value.getUses()) &&
         value.use_begin()->getOwner() == user;
}

static DenseMap<Value, unsigned>
getTupleElementSlots(waveamdmachine::TupleFromElementsOp op) {
  DenseMap<Value, unsigned> slots;
  unsigned offset = 0;
  for (Value element : op.getElements()) {
    slots.try_emplace(element, offset);
    offset += cast<waveamdmachine::RegType>(element.getType()).getWidth();
  }
  return slots;
}

static std::optional<unsigned>
getReanchorShift(waveamdmachine::TupleFromElementsOp op, Value element,
                 const ToElementsSourceMap &source,
                 const DenseMap<Value, unsigned> &consumerSlots) {
  auto sourceIt = source.find(element);
  if (sourceIt == source.end())
    return std::nullopt;
  auto slotIt = consumerSlots.find(element);
  if (slotIt == consumerSlots.end())
    return std::nullopt;
  if (!hasSingleUseBy(element, op.getOperation()))
    return std::nullopt;
  if (slotIt->second < sourceIt->second.second)
    return std::nullopt;
  return slotIt->second - sourceIt->second.second;
}

static std::optional<unsigned>
getTupleReanchorShift(waveamdmachine::TupleFromElementsOp op,
                      waveamdmachine::TupleToElementsOp split,
                      const ToElementsSourceMap &source,
                      const DenseMap<Value, unsigned> &consumerSlots) {
  std::optional<unsigned> shift;
  for (Value element : split.getElements()) {
    std::optional<unsigned> elementShift =
        getReanchorShift(op, element, source, consumerSlots);
    if (!elementShift)
      return std::nullopt;
    if (shift && *shift != *elementShift)
      return std::nullopt;
    shift = elementShift;
  }
  return shift;
}

static bool reanchorMeetsTargetConstraints(
    waveamdmachine::TupleFromElementsOp op, Value sourceTuple, unsigned shift,
    const wave::WaveAMDRegisterLimits *targetLimits) {
  if (!targetLimits)
    return true;
  waveamdmachine::RegType sourceType =
      cast<waveamdmachine::RegType>(sourceTuple.getType());
  waveamdmachine::RegType resultType =
      cast<waveamdmachine::RegType>(op.getTuple().getType());
  bool exactSourceSGPRBase = requiresMCTupleEncoding(sourceTuple);
  bool exactResultSGPRBase = requiresMCTupleEncoding(op.getTuple());
  bool hasTargetConstraint =
      (isSGPR(sourceType) && (exactSourceSGPRBase || exactResultSGPRBase)) ||
      (isVGPR(sourceType) && targetLimits->vgprTupleAlignment);
  if (!hasTargetConstraint)
    return true;
  return hasCompatibleTupleBases(resultType, sourceType, shift, targetLimits,
                                 exactResultSGPRBase, exactSourceSGPRBase);
}

static bool
isReanchorableSource(waveamdmachine::TupleFromElementsOp op, Value sourceTuple,
                     Value representative, const ToElementsSourceMap &source,
                     const DenseMap<Value, unsigned> &consumerSlots,
                     const wave::WaveAMDRegisterLimits *targetLimits) {
  auto split =
      representative.getDefiningOp<waveamdmachine::TupleToElementsOp>();
  if (!split)
    return false;
  if (!hasSingleUseBy(sourceTuple, split.getOperation()))
    return false;
  std::optional<unsigned> shift =
      getTupleReanchorShift(op, split, source, consumerSlots);
  if (!shift)
    return false;
  return reanchorMeetsTargetConstraints(op, sourceTuple, *shift, targetLimits);
}

static DenseSet<Value>
getReanchorableSources(waveamdmachine::TupleFromElementsOp op,
                       const ToElementsSourceMap &source,
                       const DenseMap<Value, unsigned> &consumerSlots,
                       const wave::WaveAMDRegisterLimits *targetLimits) {
  DenseMap<Value, Value> representatives;
  for (Value element : op.getElements()) {
    auto sourceIt = source.find(element);
    if (sourceIt != source.end())
      representatives.try_emplace(sourceIt->second.first, element);
  }

  DenseSet<Value> result;
  for (auto [sourceTuple, representative] : representatives)
    if (isReanchorableSource(op, sourceTuple, representative, source,
                             consumerSlots, targetLimits))
      result.insert(sourceTuple);
  return result;
}

static bool isStorageClobberUse(OpOperand &use,
                                KilledOperandReuseIsaCache &isaCache) {
  Operation *user = use.getOwner();
  if (isa<waveamdmachine::UniformLoopOp, waveamdmachine::ContinueIfOp,
          waveamdmachine::UpdateTupleOp>(user))
    return true;
  if (auto mma = dyn_cast<waveamdmachine::MMAOpInterface>(user))
    if (user->hasTrait<OpTrait::waveamdmachine::MFMAOp>() &&
        mma.getAcc() == use.get())
      return true;
  waveamdmachine::KilledOperandReuseOpInterface reuse =
      wave::regalloc_detail::getKilledOperandReuseCandidate(user);
  if (!reuse)
    return false;
  const llvm::AMDGPU::IsaVersion *isa = isaCache.get();
  return isa && wave::regalloc_detail::requiresKilledOperandReuseForResult(
                    reuse, use, *isa);
}

static bool hasStorageClobberUse(Value value,
                                 KilledOperandReuseIsaCache &isaCache) {
  return llvm::any_of(value.getUses(), [&](OpOperand &use) {
    return isStorageClobberUse(use, isaCache);
  });
}

struct RegSplatMove {
  Operation *op;
  Value source;
  Value result;
};

static std::optional<RegSplatMove> getRegSplatMove(Operation *op) {
  waveamdmachine::RegisterCopyOpInterface copy =
      dyn_cast<waveamdmachine::RegisterCopyOpInterface>(op);
  if (!copy)
    return std::nullopt;
  return RegSplatMove{op, copy.getRegisterCopySource(),
                      copy.getRegisterCopyResult()};
}

static bool isLastUseRegSplat(RegSplatMove move,
                              KilledOperandReuseIsaCache &isaCache) {
  std::optional<waveamdmachine::RegType> sourceType =
      copyableRegType(move.source);
  waveamdmachine::RegType resultType =
      cast<waveamdmachine::RegType>(move.result.getType());
  return sourceType && sourceType->getRegClass() == resultType.getRegClass() &&
         sourceType->getWidth() == 1 && sourceType->getIndex() < 0 &&
         resultType.getIndex() < 0 && resultType.getWidth() > 1 &&
         llvm::hasSingleElement(move.result.getUses()) &&
         isStorageClobberUse(*move.result.use_begin(), isaCache) &&
         valueDiesAt(move.source, move.op);
}

static void
decomposeLastUseRegSplatCopies(func::FuncOp func,
                               KilledOperandReuseIsaCache &isaCache,
                               DenseSet<Operation *> &decomposedSplatTuples) {
  SmallVector<RegSplatMove> moves;
  func.walk([&](Operation *op) {
    std::optional<RegSplatMove> move = getRegSplatMove(op);
    if (move && isLastUseRegSplat(*move, isaCache))
      moves.push_back(*move);
  });

  OpBuilder builder(func.getContext());
  for (RegSplatMove move : moves) {
    builder.setInsertionPoint(move.op);
    waveamdmachine::RegType resultType =
        cast<waveamdmachine::RegType>(move.result.getType());
    SmallVector<Value> elements(resultType.getWidth(), move.source);
    waveamdmachine::TupleFromElementsOp tuple =
        waveamdmachine::TupleFromElementsOp::create(builder, move.op->getLoc(),
                                                    resultType, elements);
    decomposedSplatTuples.insert(tuple.getOperation());
    move.result.replaceAllUsesWith(tuple.getTuple());
    move.op->erase();
  }
}

static bool
hasAlignedViewLifetimeConflict(waveamdmachine::TupleFromElementsOp op,
                               AlignedTupleView view,
                               KilledOperandReuseIsaCache &isaCache) {
  if (llvm::none_of(op.getTuple().getUses(), [&](OpOperand &use) {
        return isStorageClobberUse(use, isaCache);
      }))
    return false;
  auto split = op.getElements()
                   .front()
                   .getDefiningOp<waveamdmachine::TupleToElementsOp>();
  if (!split || split.getTuple() != view.sourceTuple ||
      !hasSingleUseBy(view.sourceTuple, split.getOperation()))
    return true;
  return llvm::any_of(op.getElements(), [&](Value element) {
    return !hasSingleUseBy(element, op.getOperation());
  });
}

static bool hasSlotMismatch(const DenseMap<Value, unsigned> &anchorSlot,
                            Value element, unsigned slot) {
  auto anchorIt = anchorSlot.find(element);
  return anchorIt != anchorSlot.end() && anchorIt->second != slot;
}

static bool needsTupleElementCopy(Value element, bool slotMismatch, bool reuse,
                                  bool dragInConflict,
                                  bool fixedElementInUnfixedTuple,
                                  bool liveThroughClobber) {
  return slotMismatch || reuse || dragInConflict ||
         fixedElementInUnfixedTuple || liveThroughClobber ||
         feedsLoopCarry(element);
}

static bool canPreserveAlignedView(waveamdmachine::TupleFromElementsOp op,
                                   AlignedTupleView view,
                                   const ToElementsSourceMap &source,
                                   KilledOperandReuseIsaCache &isaCache) {
  if (hasFixedViewConflict(op, view, source))
    return false;
  return !hasAlignedViewLifetimeConflict(op, view, isaCache);
}

static bool isReanchoredElement(Value element,
                                const ToElementsSourceMap &source,
                                const DenseSet<Value> &reanchorableSources) {
  auto sourceIt = source.find(element);
  if (sourceIt == source.end())
    return false;
  return reanchorableSources.contains(sourceIt->second.first);
}

static bool hasSharingSlotConflict(const DenseMap<Value, unsigned> &anchorSlot,
                                   Value element, unsigned slot,
                                   bool preserveLayout) {
  return !preserveLayout && hasSlotMismatch(anchorSlot, element, slot);
}

static bool hasSharingReuse(const DenseSet<Value> &consumed, Value element,
                            bool preserveAlignedView) {
  return !preserveAlignedView && consumed.contains(element);
}

static bool hasSourceDragConflict(Value element,
                                  const ToElementsSourceMap &source,
                                  bool preserveLayout) {
  return !preserveLayout && source.contains(element);
}

static bool hasFixedElementConflict(Value element,
                                    waveamdmachine::RegType tupleType,
                                    bool preserveAlignedView) {
  if (preserveAlignedView || tupleType.getIndex() >= 0)
    return false;
  return cast<waveamdmachine::RegType>(element.getType()).getIndex() >= 0;
}

static bool isUnitReg(Value value, waveamdmachine::RegClass regClass) {
  std::optional<waveamdmachine::RegType> type = trackedRegType(value);
  return type && type->getRegClass() == regClass && type->getWidth() == 1;
}

static bool isUnassignedUnitReg(Value value,
                                waveamdmachine::RegClass regClass) {
  std::optional<waveamdmachine::RegType> type = trackedRegType(value);
  return type && type->getRegClass() == regClass && type->getWidth() == 1 &&
         type->getIndex() < 0;
}

static Value getTupleCopySource(Value value) {
  waveamdmachine::RegisterCopyOpInterface copy =
      dyn_cast_or_null<waveamdmachine::RegisterCopyOpInterface>(
          value.getDefiningOp());
  return copy ? copy.getRegisterCopySource() : Value{};
}

static Value getUnitRegTupleCopySource(Value value, Operation *tuple,
                                       waveamdmachine::RegClass regClass) {
  if (!hasSingleUseBy(value, tuple) || !isUnitReg(value, regClass))
    return {};
  Value source = getTupleCopySource(value);
  if (!source || !isUnitReg(source, regClass))
    return {};
  return source;
}

struct RegSplatSource {
  Value value;
  unsigned directElements = 0;
};

static std::optional<RegSplatSource>
getRegSplatSource(waveamdmachine::TupleFromElementsOp op,
                  waveamdmachine::RegClass regClass) {
  RegSplatSource source;
  for (Value element : op.getElements()) {
    Value root =
        getUnitRegTupleCopySource(element, op.getOperation(), regClass);
    if (!root) {
      root = element;
      ++source.directElements;
    }
    if (!isUnassignedUnitReg(root, regClass))
      return std::nullopt;
    if (source.value && source.value != root)
      return std::nullopt;
    source.value = root;
  }
  return source.value ? std::optional<RegSplatSource>(source) : std::nullopt;
}

static bool isLastUseRegSplat(waveamdmachine::TupleFromElementsOp op,
                              bool newlyDecomposed) {
  std::optional<waveamdmachine::RegType> tupleType =
      copyableRegType(op.getTuple());
  if (!tupleType || tupleType->getIndex() >= 0 || tupleType->getWidth() <= 1)
    return false;
  std::optional<RegSplatSource> source =
      getRegSplatSource(op, tupleType->getRegClass());
  return source && (newlyDecomposed || source->directElements == 1) &&
         valueDiesAt(source->value, op.getOperation());
}

static FailureOr<Value> rewriteTupleElementForSharing(
    waveamdmachine::TupleFromElementsOp op, OpBuilder &builder, Value element,
    unsigned slot, waveamdmachine::RegType tupleType, bool preserveAlignedView,
    bool preserveLayout, bool tupleIsClobbered, bool lastUseSplat,
    DenseMap<Value, unsigned> &anchorSlot, const ToElementsSourceMap &source,
    DenseSet<Value> &consumedByFromElements) {
  bool slotMismatch =
      hasSharingSlotConflict(anchorSlot, element, slot, preserveLayout);
  bool reuse =
      hasSharingReuse(consumedByFromElements, element, preserveAlignedView);
  bool dragInConflict = hasSourceDragConflict(element, source, preserveLayout);
  bool fixedConflict =
      hasFixedElementConflict(element, tupleType, preserveAlignedView);
  bool elementDies = lastUseSplat ? valueDiesAt(element, op.getOperation())
                                  : hasSingleUseBy(element, op.getOperation());
  bool liveThroughClobber = tupleIsClobbered && !elementDies;
  if (!needsTupleElementCopy(element, slotMismatch, reuse, dragInConflict,
                             fixedConflict, liveThroughClobber)) {
    if (!preserveAlignedView)
      anchorSlot[element] = slot;
    consumedByFromElements.insert(element);
    return element;
  }

  FailureOr<Value> duplicate = duplicateRegValue(builder, op.getLoc(), element);
  if (failed(duplicate))
    return failure();
  anchorSlot[*duplicate] = slot;
  consumedByFromElements.insert(*duplicate);
  return *duplicate;
}

static LogicalResult rewriteFromElementsForSharing(
    waveamdmachine::TupleFromElementsOp op, OpBuilder &builder,
    DenseMap<Value, unsigned> &anchorSlot,
    const ToElementsSourceMap &toElementsSource,
    DenseSet<Value> &consumedByFromElements,
    const DenseSet<Operation *> &decomposedSplatTuples,
    KilledOperandReuseIsaCache &isaCache,
    const wave::WaveAMDRegisterLimits *targetLimits) {
  builder.setInsertionPoint(op);
  DenseMap<Value, unsigned> consumerSlots = getTupleElementSlots(op);
  DenseSet<Value> reanchorableSources =
      getReanchorableSources(op, toElementsSource, consumerSlots, targetLimits);
  std::optional<AlignedTupleView> alignedView =
      getAlignedTupleView(op, toElementsSource, targetLimits);
  if (alignedView &&
      !canPreserveAlignedView(op, *alignedView, toElementsSource, isaCache)) {
    reanchorableSources.erase(alignedView->sourceTuple);
    alignedView.reset();
  }
  SmallVector<Value> newElements;
  newElements.reserve(op.getElements().size());
  bool changed = false;
  unsigned cumOffset = 0;
  waveamdmachine::RegType tupleType =
      cast<waveamdmachine::RegType>(op.getTuple().getType());
  bool preserveAlignedView = alignedView.has_value();
  bool tupleIsClobbered = hasStorageClobberUse(op.getTuple(), isaCache);
  bool lastUseSplat =
      tupleIsClobbered &&
      isLastUseRegSplat(op, decomposedSplatTuples.contains(op.getOperation()));
  for (Value element : op.getElements()) {
    unsigned slot = cumOffset;
    bool reanchorSource =
        isReanchoredElement(element, toElementsSource, reanchorableSources);
    bool preserveLayout = preserveAlignedView || reanchorSource;
    FailureOr<Value> use = rewriteTupleElementForSharing(
        op, builder, element, slot, tupleType, preserveAlignedView,
        preserveLayout, tupleIsClobbered, lastUseSplat, anchorSlot,
        toElementsSource, consumedByFromElements);
    if (failed(use))
      return failure();
    changed |= *use != element;
    newElements.push_back(*use);
    cumOffset += cast<waveamdmachine::RegType>(element.getType()).getWidth();
  }
  if (changed)
    op.getElementsMutable().assign(newElements);
  return success();
}

static LogicalResult
splitTupleElementSharing(func::FuncOp func,
                         KilledOperandReuseIsaCache &isaCache,
                         const DenseSet<Operation *> &decomposedSplatTuples,
                         const wave::WaveAMDRegisterLimits *targetLimits) {
  OpBuilder builder(func.getContext());
  DenseMap<Value, unsigned> anchorSlot;
  ToElementsSourceMap toElementsSource;
  DenseSet<Value> consumedByFromElements;
  SmallVector<waveamdmachine::TupleFromElementsOp> fromElementsOps;
  func.walk([&](Operation *op) {
    if (waveamdmachine::TupleToElementsOp toElements =
            dyn_cast<waveamdmachine::TupleToElementsOp>(op)) {
      unsigned cumOffset = 0;
      for (Value element : toElements.getElements()) {
        anchorSlot[element] = cumOffset;
        toElementsSource[element] = {toElements.getTuple(), cumOffset};
        cumOffset +=
            cast<waveamdmachine::RegType>(element.getType()).getWidth();
      }
    } else if (waveamdmachine::TupleFromElementsOp fromElements =
                   dyn_cast<waveamdmachine::TupleFromElementsOp>(op))
      fromElementsOps.push_back(fromElements);
  });
  for (waveamdmachine::TupleFromElementsOp op : fromElementsOps) {
    if (failed(rewriteFromElementsForSharing(
            op, builder, anchorSlot, toElementsSource, consumedByFromElements,
            decomposedSplatTuples, isaCache, targetLimits)))
      return failure();
  }
  return success();
}

static bool isRegionCopyableYield(Value value) {
  auto rt = dyn_cast<waveamdmachine::RegType>(value.getType());
  return rt && (isSGPR(rt) || isVGPR(rt));
}

static waveamdmachine::YieldOp getRegionYield(Region &region) {
  if (region.empty())
    return {};
  return dyn_cast<waveamdmachine::YieldOp>(region.front().getTerminator());
}

static bool isUniqueUniformIfIncoming(waveamdmachine::UniformIfOp uniformIf,
                                      unsigned resultIndex, Value value) {
  for (Region *region :
       {&uniformIf.getThenRegion(), &uniformIf.getElseRegion()}) {
    waveamdmachine::YieldOp yield = getRegionYield(*region);
    if (!yield)
      continue;
    for (auto [index, incoming] : llvm::enumerate(yield.getValues()))
      if (index != resultIndex && incoming == value)
        return false;
  }
  return true;
}

static bool
uniformIfAlternativesCanOverwrite(waveamdmachine::UniformIfOp uniformIf,
                                  unsigned resultIndex, Value value) {
  for (Region *region :
       {&uniformIf.getThenRegion(), &uniformIf.getElseRegion()}) {
    waveamdmachine::YieldOp yield = getRegionYield(*region);
    if (!yield || resultIndex >= yield.getValues().size())
      return false;
    Value incoming = yield.getValues()[resultIndex];
    if (incoming == value)
      continue;
    Operation *def = incoming.getDefiningOp();
    if (!def || !valueIsDefinedInside(uniformIf, incoming) ||
        !valueDiesAt(value, def))
      return false;
  }
  return true;
}

static bool
canAliasExternalUniformIfYield(waveamdmachine::UniformIfOp uniformIf,
                               unsigned resultIndex, Value value,
                               waveamdmachine::YieldOp currentYield) {
  waveamdmachine::RegType type = cast<waveamdmachine::RegType>(value.getType());
  // SGPR inputs may occupy reserved ABI registers; keep their edge copies.
  if (!isVGPR(type) || !valueDiesAt(value, currentYield))
    return false;
  if (!isUniqueUniformIfIncoming(uniformIf, resultIndex, value))
    return false;
  return uniformIfAlternativesCanOverwrite(uniformIf, resultIndex, value);
}

static Value createBranchLocalRegAlias(OpBuilder &builder, Location loc,
                                       Value value) {
  return waveamdmachine::UpdateTupleOp::create(builder, loc, value.getType(),
                                               value, ValueRange{},
                                               builder.getArrayAttr({}))
      .getResult();
}

static LogicalResult
materializeExternalRegionYieldCopies(Operation *regionBranch, Region &region,
                                     OpBuilder &builder) {
  waveamdmachine::YieldOp yield = getRegionYield(region);
  if (!yield)
    return success();
  SmallVector<Value> values(yield.getValues());
  bool changed = false;
  builder.setInsertionPoint(yield);
  for (auto [index, value] : llvm::enumerate(values)) {
    if (!isRegionCopyableYield(value))
      continue;
    if (valueIsDefinedInside(regionBranch, value))
      continue;
    if (waveamdmachine::UniformIfOp uniformIf =
            dyn_cast<waveamdmachine::UniformIfOp>(regionBranch);
        uniformIf &&
        canAliasExternalUniformIfYield(uniformIf, index, value, yield)) {
      values[index] = createBranchLocalRegAlias(builder, yield.getLoc(), value);
      changed = true;
      continue;
    }
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

static LogicalResult materializeConditionalYieldCopies(func::FuncOp func) {
  SmallVector<waveamdmachine::UniformIfOp> uniformIfOps;
  SmallVector<waveamdmachine::ExecIfOp> execIfOps;
  func.walk([&](Operation *op) {
    if (waveamdmachine::UniformIfOp uniformIf =
            dyn_cast<waveamdmachine::UniformIfOp>(op))
      uniformIfOps.push_back(uniformIf);
    else if (waveamdmachine::ExecIfOp execIf =
                 dyn_cast<waveamdmachine::ExecIfOp>(op))
      execIfOps.push_back(execIf);
  });

  OpBuilder builder(func.getContext());
  for (waveamdmachine::UniformIfOp op : uniformIfOps) {
    if (failed(materializeExternalRegionYieldCopies(
            op.getOperation(), op.getThenRegion(), builder)))
      return failure();
    if (failed(materializeExternalRegionYieldCopies(
            op.getOperation(), op.getElseRegion(), builder)))
      return failure();
  }
  for (waveamdmachine::ExecIfOp op : execIfOps) {
    if (failed(materializeExternalRegionYieldCopies(
            op.getOperation(), op.getThenRegion(), builder)))
      return failure();
    if (failed(materializeExternalRegionYieldCopies(
            op.getOperation(), op.getElseRegion(), builder)))
      return failure();
  }
  return success();
}

} // namespace

LogicalResult mlir::wave::prepareWaveAMDRegAllocIR(func::FuncOp func) {
  std::optional<WaveAMDRegisterLimits> targetLimits;
  if (waveamdmachine::findAMDGPUTargetModule(func)) {
    FailureOr<WaveAMDRegisterLimits> limits = getWaveAMDRegisterLimits(func);
    if (failed(limits))
      return failure();
    targetLimits = std::move(*limits);
  }
  eraseRegAfterOps(func);
  if (failed(splitLiveUpdateTupleBases(func)))
    return failure();
  if (failed(materializeConditionalYieldCopies(func)))
    return failure();
  if (failed(materializeLoopBackedgeCopies(func)))
    return failure();
  if (failed(splitDuplicateLoopInits(func)))
    return failure();
  if (failed(splitDuplicateMFMAAccumulatorInputs(func)))
    return failure();
  KilledOperandReuseIsaCache isaCache(func);
  if (failed(splitRequiredKilledOperandInputs(func, isaCache)))
    return failure();
  DenseSet<Operation *> decomposedSplatTuples;
  decomposeLastUseRegSplatCopies(func, isaCache, decomposedSplatTuples);
  return splitTupleElementSharing(func, isaCache, decomposedSplatTuples,
                                  targetLimits ? &*targetLimits : nullptr);
}
