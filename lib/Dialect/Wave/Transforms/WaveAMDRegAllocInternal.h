//===- WaveAMDRegAllocInternal.h - Regalloc internals ----------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef MLIR_DIALECT_WAVE_TRANSFORMS_WAVEAMDREGALLOCINTERNAL_H
#define MLIR_DIALECT_WAVE_TRANSFORMS_WAVEAMDREGALLOCINTERNAL_H

#include "WaveAMDRegPressureRelief.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/Wave/Transforms/WaveAMDEntryRegs.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachine.h"
#include "mlir/IR/Block.h"
#include "mlir/IR/Builders.h"
#include "mlir/IR/IRMapping.h"
#include "mlir/IR/Operation.h"
#include "mlir/IR/Value.h"
#include "mlir/Support/LLVM.h"
#include "mlir/Support/LogicalResult.h"
#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/DenseSet.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/ADT/StringRef.h"
#include <algorithm>
#include <cstdint>
#include <memory>
#include <optional>

namespace mlir::wave::regalloc {

inline constexpr llvm::StringLiteral kRegAllocTempAttr =
    "waveamdmachine.regalloc_debug_temp";
inline constexpr llvm::StringLiteral kLDSSpillBytesAttr =
    "waveamdmachine.lds_spill_bytes";
inline constexpr llvm::StringLiteral kPrivateSegmentFixedSizeAttr =
    "waveamdmachine.private_segment_fixed_size";
inline constexpr llvm::StringLiteral kScratchSpillBytesAttr =
    "waveamdmachine.scratch_spill_bytes";
inline constexpr llvm::StringLiteral kMemorySpillRejectAttr =
    "waveamdmachine.regalloc_debug_memory_spill_reject";
inline constexpr llvm::StringLiteral kMemorySpillRejectDetailAttr =
    "waveamdmachine.regalloc_debug_memory_spill_reject_detail";
inline constexpr llvm::StringLiteral kMemorySpillLoopCarryReject = "loop_carry";

struct IntervalGroup;

struct Interval {
  llvm::SmallDenseSet<Value, 1> values;
  IntervalGroup *group = nullptr;
  waveamdmachine::RegType type;
  unsigned start = 0;
  unsigned end = 0;
  bool reserved = false;
  bool nonPromotable = false;
};

struct IntervalGroup {
  SmallVector<Interval *> intervals;
  waveamdmachine::RegClass preferredClass;
  waveamdmachine::RegClass storageClass;
  std::optional<unsigned> assignedBase;
  std::optional<unsigned> fixedBase;
  unsigned order = 0;
  bool reserved = false;
  bool nonPromotable = false;
  bool allocatable = true;
  bool plannedPressureRelief = false;
};

struct AllocationProbeStats {
  int64_t findFreeBaseCalls = 0;
  int64_t baseFitsCalls = 0;
  int64_t assignedLaneQueries = 0;
  int64_t assignedLaneChecks = 0;
};

struct Inventory {
  SmallVector<Operation *> ops;
  DenseMap<Operation *, unsigned> positions;
  DenseMap<Value, Interval *> intervalFor;
  ::mlir::wave::WaveAMDKernelEntryRegs entryRegs;
  SmallVector<std::unique_ptr<Interval>> intervals;
  SmallVector<std::unique_ptr<IntervalGroup>> groups;
  wave::WaveAMDPressureReliefPlanList plannedReliefPlans;
  DenseMap<StringRef, unsigned> plannedProviderBytes;
  AllocationProbeStats probeStats;
  unsigned peakSGPR = 0;
  unsigned peakVGPR = 0;
  unsigned peakAGPR = 0;
  unsigned scalarIntervals = 0;
  unsigned promotedGroups = 0;
};

using PressureFailure = ::mlir::wave::WaveAMDPressureFailure;
using PressureIntervalRef = ::mlir::wave::WaveAMDPressureIntervalRef;

inline bool isRegAllocTempOp(Operation *op) {
  return op && op->hasAttr(kRegAllocTempAttr);
}

inline bool isMemoryIssuerOp(Operation *op) {
  if (!op)
    return false;
  waveamdmachine::WaitcntInfoOpInterface info =
      dyn_cast<waveamdmachine::WaitcntInfoOpInterface>(op);
  return info && info.getWaitcntInfo().isIssuer();
}

inline bool isLoopCarryUseOp(Operation *op) {
  return isa<waveamdmachine::UniformLoopOp, waveamdmachine::ContinueIfOp>(op);
}

inline Operation *getAncestorInBlock(Operation *op, Block *block) {
  for (Operation *cur = op; cur; cur = cur->getParentOp())
    if (cur->getBlock() == block)
      return cur;
  return nullptr;
}

inline bool useIsDominatedByDef(Operation *def, Operation *user) {
  if (user->getBlock() == def->getBlock())
    return true;
  Operation *ancestor = getAncestorInBlock(user, def->getBlock());
  return ancestor && def->isBeforeInBlock(ancestor);
}

inline unsigned getPressureOverage(unsigned liveDwords, unsigned limit) {
  if (liveDwords <= limit)
    return 0;
  return liveDwords - limit;
}

inline unsigned alignDownTo(unsigned value, unsigned granule) {
  return (value / granule) * granule;
}

inline bool
memorySpillReducesPressureFailure(const wave::WaveAMDPressureFailure &failure,
                                  IntervalGroup *group, unsigned reliefDwords) {
  if (!failure.combinedVGPRAGPR)
    return reliefDwords != 0;
  if (!group || reliefDwords == 0)
    return false;

  unsigned oldOverage = getPressureOverage(failure.liveDwords, failure.limit);
  if (group->storageClass == waveamdmachine::RegClass::VGPR) {
    if (reliefDwords > failure.liveDwords)
      return false;
    return getPressureOverage(failure.liveDwords - reliefDwords,
                              failure.limit) < oldOverage;
  }
  if (group->storageClass != waveamdmachine::RegClass::AGPR ||
      reliefDwords > failure.combinedAGPRLiveDwords)
    return false;
  unsigned newAGPRLive = failure.combinedAGPRLiveDwords - reliefDwords;
  unsigned newVGPRLimit = 0;
  if (newAGPRLive < failure.combinedVGPRFamilyLimit)
    newVGPRLimit =
        alignDownTo(failure.combinedVGPRFamilyLimit - newAGPRLive, 4);
  return getPressureOverage(failure.liveDwords, newVGPRLimit) < oldOverage;
}

inline bool isCheapVGPRExpr(Operation *op);

struct MemorySpillLoadResult {
  Value value;
  Value token;
};

struct MemorySpillLoopCarrySlot {
  waveamdmachine::UniformLoopOp loop;
  unsigned index = 0;
};

inline unsigned getLoopDepth(Operation *op) {
  unsigned depth = 0;
  for (Operation *cur = op; cur; cur = cur->getParentOp())
    if (isa<waveamdmachine::UniformLoopOp>(cur))
      ++depth;
  return depth;
}

inline bool collectSimpleMemorySpillVGPRUses(Value value,
                                             SmallVectorImpl<OpOperand *> &uses,
                                             bool &sawLoopCarryReject) {
  Operation *def = value.getDefiningOp();
  if (!def || isMemoryIssuerOp(def))
    return false;
  for (OpOperand &use : value.getUses()) {
    if (isRegAllocTempOp(use.getOwner()))
      continue;
    if (isLoopCarryUseOp(use.getOwner())) {
      sawLoopCarryReject = true;
      return false;
    }
    if (!useIsDominatedByDef(def, use.getOwner()))
      return false;
    uses.push_back(&use);
  }
  return !uses.empty();
}

inline bool
collectSimpleMemorySpillAGPRUses(Value value,
                                 SmallVectorImpl<OpOperand *> &uses) {
  Operation *def = value.getDefiningOp();
  if (!def || isMemoryIssuerOp(def))
    return false;
  for (OpOperand &use : value.getUses()) {
    if (!useIsDominatedByDef(def, use.getOwner()))
      return false;
    if (isa<waveamdmachine::VAccvgprReadB32TupleOp>(use.getOwner())) {
      uses.push_back(&use);
      continue;
    }
    if (isRegAllocTempOp(use.getOwner()))
      continue;
    return false;
  }
  return !uses.empty();
}

inline bool collectSimpleMemorySpillUses(Value value,
                                         SmallVectorImpl<OpOperand *> &uses,
                                         bool &sawLoopCarryReject) {
  waveamdmachine::RegType type = cast<waveamdmachine::RegType>(value.getType());
  if (type.getRegClass() == waveamdmachine::RegClass::AGPR)
    return collectSimpleMemorySpillAGPRUses(value, uses);
  return collectSimpleMemorySpillVGPRUses(value, uses, sawLoopCarryReject);
}

inline bool isValueLiveAtPressure(Value value, ArrayRef<OpOperand *> uses,
                                  const Inventory &inventory,
                                  unsigned position) {
  Operation *def = value.getDefiningOp();
  if (!def)
    return false;
  unsigned start = inventory.positions.lookup(def);
  if (start >= position)
    return false;
  unsigned end = start;
  for (OpOperand *use : uses)
    end = std::max(end, inventory.positions.lookup(use->getOwner()));
  return position <= end;
}

inline bool valueCoversWholeGroup(IntervalGroup *group, Value value,
                                  const Inventory &inventory) {
  auto type = dyn_cast<waveamdmachine::RegType>(value.getType());
  if (!type ||
      static_cast<unsigned>(type.getWidth()) != group->intervals.size())
    return false;
  Interval *first = inventory.intervalFor.lookup(value);
  return first && first->group == group && first == group->intervals.front();
}

inline bool hasMemorySpillUseAtPressure(ArrayRef<OpOperand *> uses,
                                        const Inventory &inventory,
                                        unsigned position) {
  for (OpOperand *use : uses)
    if (inventory.positions.lookup(use->getOwner()) == position)
      return true;
  return false;
}

inline std::optional<unsigned> getMemorySpillPressureRelief(
    Value value, unsigned width, ArrayRef<OpOperand *> uses,
    const Inventory &inventory, const PressureFailure *pressureFailure) {
  if (!pressureFailure || !pressureFailure->combinedVGPRAGPR)
    return width;
  if (isCheapVGPRExpr(value.getDefiningOp()))
    return 0;
  if (hasMemorySpillUseAtPressure(uses, inventory, pressureFailure->position))
    return 0;
  return width;
}

inline unsigned getLiveLaneCount(IntervalGroup *group, unsigned position) {
  unsigned count = 0;
  for (Interval *lane : group->intervals)
    if (!lane->values.empty() && lane->start <= position &&
        position <= lane->end)
      ++count;
  return count;
}

inline bool liveLanesStartBeforePressure(IntervalGroup *group,
                                         unsigned position) {
  for (Interval *lane : group->intervals)
    if (!lane->values.empty() && lane->start <= position &&
        position <= lane->end && lane->start >= position)
      return false;
  return true;
}

inline int64_t getMemorySpillValueOrder(Value value,
                                        const Inventory &inventory) {
  int64_t resultIndex = -1;
  if (OpResult result = dyn_cast<OpResult>(value)) {
    resultIndex = result.getResultNumber();
    return inventory.positions.lookup(result.getOwner()) * 1024 + resultIndex;
  }
  BlockArgument arg = cast<BlockArgument>(value);
  resultIndex = arg.getArgNumber();
  Operation *parent = arg.getOwner()->getParentOp();
  if (isa_and_nonnull<func::FuncOp>(parent))
    return resultIndex;
  return inventory.positions.lookup(parent) * 1024 + resultIndex;
}

inline SmallVector<Value>
getMemorySpillGroupValues(IntervalGroup *group, const Inventory &inventory) {
  SmallVector<Value> values;
  llvm::SmallDenseSet<Value, 8> seen;
  for (Interval *lane : group->intervals)
    for (Value value : lane->values)
      if (seen.insert(value).second)
        values.push_back(value);
  llvm::stable_sort(values, [&](Value lhs, Value rhs) {
    return getMemorySpillValueOrder(lhs, inventory) <
           getMemorySpillValueOrder(rhs, inventory);
  });
  return values;
}

inline LogicalResult
mergeLoopCarrySlot(MemorySpillLoopCarrySlot next,
                   std::optional<MemorySpillLoopCarrySlot> &slot) {
  if (!slot) {
    slot = next;
    return success();
  }
  if (slot->loop == next.loop && slot->index == next.index)
    return success();
  return failure();
}

inline std::optional<MemorySpillLoopCarrySlot>
getValueLoopCarrySlot(Value value) {
  if (BlockArgument arg = dyn_cast<BlockArgument>(value))
    if (waveamdmachine::UniformLoopOp loop =
            dyn_cast<waveamdmachine::UniformLoopOp>(
                arg.getOwner()->getParentOp()))
      return MemorySpillLoopCarrySlot{loop, arg.getArgNumber()};
  if (waveamdmachine::UniformLoopOp loop =
          value.getDefiningOp<waveamdmachine::UniformLoopOp>())
    return MemorySpillLoopCarrySlot{loop,
                                    cast<OpResult>(value).getResultNumber()};
  for (OpOperand &use : value.getUses()) {
    Operation *owner = use.getOwner();
    if (waveamdmachine::UniformLoopOp loop =
            dyn_cast<waveamdmachine::UniformLoopOp>(owner))
      for (auto [index, init] : llvm::enumerate(loop.getInits()))
        if (init == value)
          return MemorySpillLoopCarrySlot{loop, static_cast<unsigned>(index)};
    if (waveamdmachine::ContinueIfOp term =
            dyn_cast<waveamdmachine::ContinueIfOp>(owner))
      if (use.getOperandNumber() != 0)
        return MemorySpillLoopCarrySlot{
            term->getParentOfType<waveamdmachine::UniformLoopOp>(),
            use.getOperandNumber() - 1};
  }
  return std::nullopt;
}

inline LogicalResult
mergeLoopCarrySlot(Value value, std::optional<MemorySpillLoopCarrySlot> &slot) {
  if (std::optional<MemorySpillLoopCarrySlot> valueSlot =
          getValueLoopCarrySlot(value))
    return mergeLoopCarrySlot(*valueSlot, slot);
  return success();
}

inline std::optional<MemorySpillLoopCarrySlot>
getLoopCarrySlot(IntervalGroup *group, const Inventory &inventory) {
  std::optional<MemorySpillLoopCarrySlot> slot;
  for (Value value : getMemorySpillGroupValues(group, inventory))
    if (failed(mergeLoopCarrySlot(value, slot)))
      return std::nullopt;
  return slot;
}

inline bool hasLocalLoopCarryUses(MemorySpillLoopCarrySlot slot) {
  Block &body = slot.loop.getBody().front();
  BlockArgument arg = body.getArgument(slot.index);
  for (OpOperand &use : arg.getUses())
    if (!getAncestorInBlock(use.getOwner(), &body))
      return false;
  return true;
}

inline bool isSplatInit(MemorySpillLoopCarrySlot slot) {
  waveamdmachine::VMovB32TupleOp splat =
      slot.loop.getInits()[slot.index]
          .getDefiningOp<waveamdmachine::VMovB32TupleOp>();
  return splat && splat.getSource().getDefiningOp<waveamdmachine::ImmOp>();
}

inline bool canSpillLoopCarryAtPosition(MemorySpillLoopCarrySlot slot,
                                        const Inventory &inventory,
                                        unsigned position) {
  DenseMap<Operation *, unsigned>::const_iterator loopPos =
      inventory.positions.find(slot.loop);
  if (loopPos == inventory.positions.end())
    return false;
  if (position > loopPos->second)
    return true;
  return isSplatInit(slot);
}

inline bool canRewriteExtraLoopInitUse(OpOperand &use, OpOperand *loopUse,
                                       waveamdmachine::UniformLoopOp loop) {
  if (&use == loopUse || isRegAllocTempOp(use.getOwner()))
    return true;
  Operation *user = use.getOwner();
  return user->getBlock() == loop->getBlock() && user->isBeforeInBlock(loop);
}

inline bool canRewriteExtraLoopInitUses(MemorySpillLoopCarrySlot slot) {
  OpOperand *loopUse = &slot.loop.getInitsMutable()[slot.index];
  Value init = loopUse->get();
  for (OpOperand &use : init.getUses())
    if (!canRewriteExtraLoopInitUse(use, loopUse, slot.loop))
      return false;
  return true;
}

inline bool loopCarryTouchesPressure(MemorySpillLoopCarrySlot slot,
                                     const Inventory &inventory,
                                     unsigned position) {
  Block &body = slot.loop.getBody().front();
  BlockArgument arg = body.getArgument(slot.index);
  for (OpOperand &use : arg.getUses())
    if (inventory.positions.lookup(use.getOwner()) == position)
      return true;
  Operation *term = body.getTerminator();
  return term && inventory.positions.lookup(term) == position;
}

inline unsigned getLoopCarryUseCount(MemorySpillLoopCarrySlot slot) {
  Block &body = slot.loop.getBody().front();
  BlockArgument arg = body.getArgument(slot.index);
  unsigned count = llvm::range_size(arg.getUses());
  count += llvm::range_size(slot.loop.getResult(slot.index).getUses());
  return count + 1;
}

inline bool canMaterializeLoopCarrySpill(MemorySpillLoopCarrySlot slot,
                                         const Inventory &inventory,
                                         unsigned position) {
  return canSpillLoopCarryAtPosition(slot, inventory, position) &&
         hasLocalLoopCarryUses(slot) && canRewriteExtraLoopInitUses(slot);
}

template <typename SpillPlanT, typename GetSlotFn, typename StoreValueFn,
          typename LoadValueFn, typename ReserveFn>
struct MemorySpillLoopCarryMaterializer {
  ArrayRef<const SpillPlanT *> input;
  OpBuilder &builder;
  StringRef provider;
  GetSlotFn getSlot;
  StoreValueFn storeValue;
  LoadValueFn loadValue;
  ReserveFn reservePlan;

  bool isSpilledIndex(ArrayRef<const SpillPlanT *> spills,
                      unsigned index) const {
    return llvm::any_of(spills, [&](const SpillPlanT *spill) {
      return getSlot(*spill).index == index;
    });
  }

  std::optional<unsigned> getSpillOrdinal(ArrayRef<const SpillPlanT *> spills,
                                          unsigned index) const {
    for (auto [ordinal, spill] : llvm::enumerate(spills))
      if (getSlot(*spill).index == index)
        return ordinal;
    return std::nullopt;
  }

  LogicalResult run() const {
    if (failed(materializeCarries()))
      return failure();
    for (const SpillPlanT *spill : input)
      reservePlan(*spill, builder);
    return success();
  }

  LogicalResult materializeCarries() const {
    if (input.empty())
      return success();
    SmallVector<const SpillPlanT *, 4> spills(input.begin(), input.end());
    llvm::stable_sort(spills,
                      [&](const SpillPlanT *lhs, const SpillPlanT *rhs) {
                        return getSlot(*lhs).index < getSlot(*rhs).index;
                      });

    waveamdmachine::UniformLoopOp loop = getSlot(*spills.front()).loop;
    for (const SpillPlanT *spill : spills)
      assert(getSlot(*spill).loop == loop && "expected one loop carry group");

    SmallVector<Value, 4> initTokens;
    for (const SpillPlanT *spill : spills) {
      MemorySpillLoopCarrySlot slot = getSlot(*spill);
      Value init = loop.getInits()[slot.index];
      OpOperand *loopUse = &loop.getInitsMutable()[slot.index];
      setInsertionPointForInitStore(init, loopUse, loop);
      initTokens.push_back(
          storeValue(init, Value{}, *spill, builder, loop.getLoc()));
    }
    for (auto [index, spill] : llvm::enumerate(spills))
      if (failed(rewriteExtraLoopInitUses(*spill, initTokens[index])))
        return failure();

    waveamdmachine::UniformLoopOp newLoop =
        cloneLoopWithoutCarries(loop, spills, initTokens);
    replaceLoopResults(loop, newLoop, spills);
    loop.erase();
    return success();
  }

  Operation *
  getFirstLoopPreheaderUse(Value init, OpOperand *loopUse,
                           waveamdmachine::UniformLoopOp loop) const {
    Operation *first = nullptr;
    for (OpOperand &use : init.getUses()) {
      Operation *user = use.getOwner();
      if (&use == loopUse || isRegAllocTempOp(user))
        continue;
      if (!canRewriteExtraLoopInitUse(use, loopUse, loop))
        continue;
      if (user->getBlock() != loop->getBlock() || !user->isBeforeInBlock(loop))
        continue;
      if (!first || user->isBeforeInBlock(first))
        first = user;
    }
    return first;
  }

  void setInsertionPointForInitStore(Value init, OpOperand *loopUse,
                                     waveamdmachine::UniformLoopOp loop) const {
    Operation *def = init.getDefiningOp();
    Operation *firstPreheaderUse =
        getFirstLoopPreheaderUse(init, loopUse, loop);
    if (firstPreheaderUse && (!def || def->getBlock() != loop->getBlock() ||
                              def->isBeforeInBlock(firstPreheaderUse))) {
      builder.setInsertionPoint(firstPreheaderUse);
      return;
    }
    if (!def || def->getBlock() != loop->getBlock() ||
        !def->isBeforeInBlock(loop)) {
      builder.setInsertionPoint(loop);
      return;
    }
    builder.setInsertionPointAfter(def);
  }

  LogicalResult rewriteExtraLoopInitUses(const SpillPlanT &spill,
                                         Value initToken) const {
    MemorySpillLoopCarrySlot slot = getSlot(spill);
    waveamdmachine::UniformLoopOp loop = slot.loop;
    OpOperand *loopUse = &loop.getInitsMutable()[slot.index];
    Value init = loopUse->get();
    SmallVector<OpOperand *> uses;
    for (OpOperand &use : init.getUses()) {
      if (&use == loopUse || isRegAllocTempOp(use.getOwner()))
        continue;
      uses.push_back(&use);
    }

    for (OpOperand *use : uses) {
      Operation *user = use->getOwner();
      if (!canRewriteExtraLoopInitUse(*use, loopUse, loop))
        return mlir::emitError(init.getLoc())
               << "waveamd-reg-alloc cannot materialize " << provider
               << " spill for loop init use outside loop preheader";
      builder.setInsertionPoint(user);
      MemorySpillLoadResult load =
          loadValue(init.getType(), initToken, spill, builder, user->getLoc());
      use->set(load.value);
    }
    return success();
  }

  waveamdmachine::UniformLoopOp
  cloneLoopWithoutCarries(waveamdmachine::UniformLoopOp loop,
                          ArrayRef<const SpillPlanT *> spills,
                          ArrayRef<Value> initTokens) const {
    Type tokenType = waveamdmachine::MemTokenType::get(builder.getContext());
    SmallVector<Type> resultTypes;
    SmallVector<Value> inits;
    for (unsigned index : llvm::seq<unsigned>(0, loop.getInits().size())) {
      if (isSpilledIndex(spills, index))
        continue;
      resultTypes.push_back(loop.getResult(index).getType());
      inits.push_back(loop.getInits()[index]);
    }
    for (Value initToken : initTokens) {
      resultTypes.push_back(tokenType);
      inits.push_back(initToken);
    }

    builder.setInsertionPoint(loop);
    waveamdmachine::UniformLoopOp newLoop =
        waveamdmachine::UniformLoopOp::create(
            builder, loop.getLoc(), resultTypes, loop.getEntryCond(), inits);
    cloneLoopBody(loop, newLoop, spills);
    return newLoop;
  }

  void cloneLoopBody(waveamdmachine::UniformLoopOp oldLoop,
                     waveamdmachine::UniformLoopOp newLoop,
                     ArrayRef<const SpillPlanT *> spills) const {
    Block &oldBody = oldLoop.getBody().front();
    Block *newBody = new Block;
    newLoop.getBody().push_back(newBody);
    for (Value init : newLoop.getInits())
      newBody->addArgument(init.getType(), oldLoop.getLoc());

    IRMapping mapper;
    unsigned newArgIndex = 0;
    for (unsigned index : llvm::seq<unsigned>(0, oldLoop.getInits().size())) {
      if (isSpilledIndex(spills, index))
        continue;
      mapper.map(oldBody.getArgument(index),
                 newBody->getArgument(newArgIndex++));
    }
    SmallVector<Value, 4> tokens;
    for ([[maybe_unused]] const SpillPlanT *spill : spills)
      tokens.push_back(newBody->getArgument(newArgIndex++));
    cloneLoopBodyOps(oldLoop, newBody, spills, tokens, mapper);
  }

  void cloneLoopBodyOps(waveamdmachine::UniformLoopOp oldLoop, Block *newBody,
                        ArrayRef<const SpillPlanT *> spills,
                        SmallVectorImpl<Value> &tokens,
                        IRMapping &mapper) const {
    Block &oldBody = oldLoop.getBody().front();
    builder.setInsertionPointToEnd(newBody);
    for (Operation &op : oldBody.without_terminator()) {
      for (const SpillPlanT *spill : spills) {
        BlockArgument oldArg = oldBody.getArgument(getSlot(*spill).index);
        if (!opUsesValue(&op, oldArg))
          continue;
        (void)getMappedValue(oldLoop, oldArg, spills, tokens, mapper,
                             op.getLoc());
      }
      builder.clone(op, mapper);
    }
    cloneLoopTerminator(oldLoop, spills, tokens, mapper);
  }

  static bool opUsesValue(Operation *op, Value value) {
    bool found = false;
    op->walk([&](Operation *nested) {
      if (found)
        return WalkResult::interrupt();
      if (llvm::any_of(nested->getOperands(),
                       [&](Value operand) { return operand == value; })) {
        found = true;
        return WalkResult::interrupt();
      }
      return WalkResult::advance();
    });
    return found;
  }

  std::optional<unsigned>
  getSpillOrdinalForValue(waveamdmachine::UniformLoopOp loop, Value value,
                          ArrayRef<const SpillPlanT *> spills) const {
    BlockArgument arg = dyn_cast<BlockArgument>(value);
    if (!arg || arg.getOwner() != &loop.getBody().front())
      return std::nullopt;
    return getSpillOrdinal(spills, arg.getArgNumber());
  }

  Value getMappedValue(waveamdmachine::UniformLoopOp loop, Value value,
                       ArrayRef<const SpillPlanT *> spills,
                       SmallVectorImpl<Value> &tokens, IRMapping &mapper,
                       Location loc) const {
    if (Value mapped = mapper.lookupOrNull(value))
      return mapped;
    std::optional<unsigned> ordinal =
        getSpillOrdinalForValue(loop, value, spills);
    if (!ordinal)
      return mapper.lookupOrDefault(value);
    const SpillPlanT &spill = *spills[*ordinal];
    MemorySpillLoadResult load =
        loadValue(value.getType(), tokens[*ordinal], spill, builder, loc);
    tokens[*ordinal] = load.token;
    mapper.map(value, load.value);
    return load.value;
  }

  bool needsTerminatorPreload(waveamdmachine::UniformLoopOp loop,
                              unsigned carryIndex, Value carry,
                              ArrayRef<const SpillPlanT *> spills) const {
    std::optional<unsigned> source =
        getSpillOrdinalForValue(loop, carry, spills);
    if (!source)
      return false;
    std::optional<unsigned> dest = getSpillOrdinal(spills, carryIndex);
    if (!dest || *dest != *source)
      return true;
    BlockArgument arg = cast<BlockArgument>(carry);
    return arg.getArgNumber() != carryIndex;
  }

  void cloneLoopTerminator(waveamdmachine::UniformLoopOp loop,
                           ArrayRef<const SpillPlanT *> spills,
                           SmallVectorImpl<Value> &tokens,
                           IRMapping &mapper) const {
    waveamdmachine::ContinueIfOp oldTerm = cast<waveamdmachine::ContinueIfOp>(
        loop.getBody().front().getTerminator());
    for (auto [index, carry] : llvm::enumerate(oldTerm.getCarries()))
      if (needsTerminatorPreload(loop, index, carry, spills))
        (void)getMappedValue(loop, carry, spills, tokens, mapper,
                             oldTerm.getLoc());

    SmallVector<Value> carries;
    for (unsigned index : llvm::seq<unsigned>(0, oldTerm.getCarries().size())) {
      Value carry = oldTerm.getCarries()[index];
      std::optional<unsigned> spillIndex = getSpillOrdinal(spills, index);
      if (spillIndex) {
        const SpillPlanT &spill = *spills[*spillIndex];
        BlockArgument oldArg =
            loop.getBody().front().getArgument(getSlot(spill).index);
        if (carry != oldArg)
          tokens[*spillIndex] =
              storeValue(getMappedValue(loop, carry, spills, tokens, mapper,
                                        oldTerm.getLoc()),
                         tokens[*spillIndex], spill, builder, oldTerm.getLoc());
        continue;
      }
      carries.push_back(getMappedValue(loop, carry, spills, tokens, mapper,
                                       oldTerm.getLoc()));
    }
    carries.append(tokens.begin(), tokens.end());
    waveamdmachine::ContinueIfOp::create(
        builder, oldTerm.getLoc(), mapper.lookupOrDefault(oldTerm.getCond()),
        carries);
  }

  void replaceLoopResults(waveamdmachine::UniformLoopOp oldLoop,
                          waveamdmachine::UniformLoopOp newLoop,
                          ArrayRef<const SpillPlanT *> spills) const {
    builder.setInsertionPointAfter(newLoop);
    unsigned newResultIndex = 0;
    for (unsigned index : llvm::seq<unsigned>(0, oldLoop.getResults().size())) {
      if (isSpilledIndex(spills, index))
        continue;
      oldLoop.getResult(index).replaceAllUsesWith(
          newLoop.getResult(newResultIndex++));
    }
    for (const SpillPlanT *spill : spills) {
      Value token = newLoop.getResult(newResultIndex++);
      unsigned oldIndex = getSlot(*spill).index;
      if (oldLoop.getResult(oldIndex).use_empty())
        continue;
      MemorySpillLoadResult load =
          loadValue(oldLoop.getResult(oldIndex).getType(), token, *spill,
                    builder, oldLoop.getLoc());
      oldLoop.getResult(oldIndex).replaceAllUsesWith(load.value);
    }
  }
};

template <typename SpillPlanT, typename GetSlotFn, typename StoreValueFn,
          typename LoadValueFn, typename ReserveFn>
LogicalResult materializeMemorySpillLoopCarryPlans(
    ArrayRef<const SpillPlanT *> input, OpBuilder &builder, StringRef provider,
    GetSlotFn getSlot, StoreValueFn storeValue, LoadValueFn loadValue,
    ReserveFn reservePlan) {
  return MemorySpillLoopCarryMaterializer<SpillPlanT, GetSlotFn, StoreValueFn,
                                          LoadValueFn, ReserveFn>{
      input, builder, provider, getSlot, storeValue, loadValue, reservePlan}
      .run();
}

inline bool isCheapVGPRExpr(Operation *op) {
  return isa_and_nonnull<
      waveamdmachine::VWorkitemIdXOp, waveamdmachine::VMovB32TupleOp,
      waveamdmachine::VLshrrevB32Op, waveamdmachine::VLshlrevB32Op,
      waveamdmachine::VLshlAddU32Op, waveamdmachine::VAddU32Op,
      waveamdmachine::VAdd3U32Op, waveamdmachine::VAndB32Op,
      waveamdmachine::VXorB32Op, waveamdmachine::VAndOrB32Op>(op);
}

inline bool isFixedRegisterGroup(IntervalGroup *group) {
  if (!group)
    return false;
  if (group->fixedBase)
    return true;
  for (Interval *lane : group->intervals)
    for (Value value : lane->values)
      if (auto type = dyn_cast<waveamdmachine::RegType>(value.getType()))
        if (type.getIndex() >= 0)
          return true;
  return false;
}

inline bool isMemorySpillVGPRGroup(IntervalGroup *group) {
  if (!group || group->plannedPressureRelief || group->reserved ||
      group->nonPromotable || isFixedRegisterGroup(group))
    return false;
  return group->storageClass == waveamdmachine::RegClass::VGPR &&
         group->preferredClass == waveamdmachine::RegClass::VGPR;
}

inline bool hasLiveMemorySpillLane(IntervalGroup *group, unsigned position) {
  if (!group)
    return false;
  return llvm::any_of(group->intervals, [&](Interval *lane) {
    return !lane->nonPromotable && lane->start <= position &&
           position <= lane->end;
  });
}

inline bool isMemorySpillEligibleGroup(IntervalGroup *group,
                                       unsigned position) {
  return isMemorySpillVGPRGroup(group) &&
         hasLiveMemorySpillLane(group, position);
}

struct RegisterBudgets {
  SmallVector<unsigned, 32> maxSGPRsForWaves;
  SmallVector<unsigned, 32> maxVGPRsForWaves;
  std::optional<unsigned> totalVGPRLimit;
  unsigned addressableSGPR = 0;
  unsigned addressableVGPR = 0;
  unsigned addressableAGPR = 0;
  unsigned sgpr = 0;
  unsigned vgpr = 0;
  unsigned agpr = 0;
  unsigned maxWavesPerEU = 0;
  unsigned targetWaves = 0;
  bool agprCountsAgainstVGPRs = false;
};

enum class LDSSpillPlanStatus : uint8_t {
  Available,
  NotKernel,
  MissingWorkgroupShape,
  InvalidWorkgroupShape,
  UnsupportedWorkgroupShape,
  UnsupportedSlotBase,
  UnsupportedWavesPerWorkgroup,
  InvalidValueBytes,
  InsufficientLDS,
};

struct LDSSpillPlan {
  unsigned existingFixedBytes = 0;
  unsigned existingDynamicBytes = 0;
  unsigned reservedSpillBytes = 0;
  unsigned limitBytes = 0;
  unsigned availableBytes = 0;
  unsigned slotBase = 0;
  unsigned slotBytes = 0;
  unsigned waveStride = 0;
  unsigned valueBytes = 0;
  unsigned wavesPerWorkgroup = 0;
  unsigned wavefrontSize = 0;
  LDSSpillPlanStatus status = LDSSpillPlanStatus::NotKernel;
};

enum class ScratchSpillPlanStatus : uint8_t {
  Available,
  NotKernel,
  UnsupportedTarget,
  InvalidValueBytes,
  PrivateSegmentOverflow,
};

struct ScratchSpillPlan {
  unsigned existingPrivateBytes = 0;
  unsigned reservedSpillBytes = 0;
  unsigned slotBase = 0;
  unsigned slotBytes = 0;
  unsigned valueBytes = 0;
  bool usesFlatScratch = false;
  ScratchSpillPlanStatus status = ScratchSpillPlanStatus::NotKernel;
};

struct PromotionScore {
  unsigned liveDwords = 0;
  unsigned bridgeCost = 0;
  unsigned end = 0;
};

struct BankPromotionStep {
  IntervalGroup *group = nullptr;
  waveamdmachine::RegClass sourceClass;
  waveamdmachine::RegClass targetClass;
};

struct BankPromotionHooks {
  StringRef (*getRegClassName)(waveamdmachine::RegClass) = nullptr;
  std::optional<waveamdmachine::RegClass> (*getNextRegClass)(
      waveamdmachine::RegClass) = nullptr;
  PromotionScore (*getPromotionScore)(IntervalGroup *, unsigned,
                                      Inventory &) = nullptr;
  bool (*isBetterPromotionScore)(PromotionScore, PromotionScore) = nullptr;
  bool (*isLiveAt)(IntervalGroup *, unsigned) = nullptr;
  bool (*canPromote)(IntervalGroup *, RegisterBudgets) = nullptr;
  bool (*canFitPromotionTarget)(
      IntervalGroup *, ArrayRef<IntervalGroup *>, RegisterBudgets,
      const ::mlir::wave::WaveAMDKernelEntryRegs &) = nullptr;
  LogicalResult (*materializePlans)(ArrayRef<BankPromotionStep>, Inventory &,
                                    OpBuilder &) = nullptr;
  LogicalResult (*materialize)(IntervalGroup *, Inventory &,
                               OpBuilder &) = nullptr;
};

std::unique_ptr<wave::WaveAMDPressureReliefProvider>
createBankPromotionProvider(ArrayRef<IntervalGroup *> groups,
                            IntervalGroup *request, unsigned position,
                            RegisterBudgets budgets, Inventory &inventory,
                            const BankPromotionHooks &hooks);
std::unique_ptr<wave::WaveAMDPressureReliefProvider>
createRematerializeProvider(ArrayRef<IntervalGroup *> groups,
                            IntervalGroup *request, unsigned position,
                            Inventory &inventory);
std::unique_ptr<wave::WaveAMDPressureReliefProvider>
createLDSSpillProvider(func::FuncOp func, ArrayRef<IntervalGroup *> groups,
                       IntervalGroup *request, unsigned position,
                       RegisterBudgets budgets, Inventory &inventory);
std::unique_ptr<wave::WaveAMDPressureReliefProvider>
createScratchSpillProvider(func::FuncOp func, ArrayRef<IntervalGroup *> groups,
                           IntervalGroup *request, unsigned position,
                           Inventory &inventory);
unsigned getPlannedProviderBytes(Inventory &inventory, StringRef provider);
void addPlannedProviderBytes(Inventory &inventory, StringRef provider,
                             unsigned bytes);
void recordPlannedPressureRelief(
    Inventory &inventory,
    std::unique_ptr<wave::WaveAMDPressureReliefPlan> plan);

StringRef getLDSSpillPlanStatusName(LDSSpillPlanStatus status);
LDSSpillPlan planLDSSpillSlot(func::FuncOp func, RegisterBudgets budgets,
                              unsigned valueBytes,
                              unsigned reservedSpillBytes = 0);
StringRef getScratchSpillPlanStatusName(ScratchSpillPlanStatus status);
ScratchSpillPlan planScratchSpillSlot(func::FuncOp func, unsigned valueBytes,
                                      unsigned reservedSpillBytes = 0);

} // namespace mlir::wave::regalloc

#endif // MLIR_DIALECT_WAVE_TRANSFORMS_WAVEAMDREGALLOCINTERNAL_H
