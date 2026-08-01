//===- WaveAMDRegLiveIntervals.cpp - WaveAMD reg liveness ------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "WaveAMDRegLiveIntervals.h"

#include "WaveAMDRegAllocInternal.h"
#include "WaveAMDRegAllocRegionFlow.h"
#include "WaveAMDRegAllocTransformUtils.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "llvm/ADT/BitVector.h"
#include "llvm/ADT/DenseSet.h"
#include "llvm/ADT/STLExtras.h"

using namespace mlir;

namespace mlir::wave {

bool isWaveAMDReg(Value value) {
  return isa<waveamdmachine::RegType>(value.getType());
}

bool isWaveAMDSGPR(waveamdmachine::RegType type) {
  return type.getRegClass() == waveamdmachine::RegClass::SGPR;
}

bool isWaveAMDVGPR(waveamdmachine::RegType type) {
  return type.getRegClass() == waveamdmachine::RegClass::VGPR;
}

bool isWaveAMDAGPR(waveamdmachine::RegType type) {
  return type.getRegClass() == waveamdmachine::RegClass::AGPR;
}

// SCC is a single hardware bit; no physical register allocation.
bool isWaveAMDSCC(waveamdmachine::RegType type) {
  return type.getRegClass() == waveamdmachine::RegClass::SCC;
}

bool isWaveAMDVCC(waveamdmachine::RegType type) {
  return type.getRegClass() == waveamdmachine::RegClass::VCC;
}

bool isWaveAMDFlagReg(waveamdmachine::RegType type) {
  return isWaveAMDSCC(type) || isWaveAMDVCC(type);
}

std::optional<waveamdmachine::RegType> getTrackedWaveAMDRegType(Value value) {
  if (!isWaveAMDReg(value))
    return std::nullopt;
  auto rt = cast<waveamdmachine::RegType>(value.getType());
  if (isWaveAMDFlagReg(rt))
    return std::nullopt;
  return rt;
}

unsigned getWaveAMDLiveIntervalWidthAt(const WaveAMDLiveInterval &interval,
                                       unsigned position) {
  if (interval.values.empty())
    return 0;
  unsigned width = interval.type.getWidth();
  llvm::BitVector live(width);
  for (auto [value, slot, start, end] :
       llvm::zip(interval.values, interval.slotOffsets, interval.valueStarts,
                 interval.valueEnds)) {
    if (position < start || end < position)
      continue;
    unsigned valueWidth =
        cast<waveamdmachine::RegType>(value.getType()).getWidth();
    for (unsigned bit : llvm::seq<unsigned>(slot, slot + valueWidth))
      if (bit < width)
        live.set(bit);
  }
  return live.count();
}

bool isWaveAMDLiveIntervalLiveAt(const WaveAMDLiveInterval &interval,
                                 unsigned position) {
  return getWaveAMDLiveIntervalWidthAt(interval, position) != 0;
}

} // namespace mlir::wave

namespace {

static unsigned bumpEnd(unsigned cur, unsigned pos) {
  return std::max(cur, pos);
}

static void updateEnvelope(wave::WaveAMDLiveInterval &interval, unsigned start,
                           unsigned end) {
  interval.start = std::min(interval.start, start);
  interval.end = bumpEnd(interval.end, end);
}

static void appendIntervalValue(wave::WaveAMDLiveInterval &interval,
                                Value value, unsigned slotOffset,
                                unsigned start, unsigned end) {
  interval.values.push_back(value);
  interval.slotOffsets.push_back(slotOffset);
  interval.valueStarts.push_back(start);
  interval.valueEnds.push_back(end);
  updateEnvelope(interval, start, end);
}

static void extendIntervalValue(wave::WaveAMDLiveInterval &interval,
                                Value value, unsigned pos) {
  for (auto [index, v] : llvm::enumerate(interval.values)) {
    if (v != value)
      continue;
    interval.valueEnds[index] = bumpEnd(interval.valueEnds[index], pos);
    interval.end = bumpEnd(interval.end, pos);
    return;
  }
}

static std::pair<SmallVectorImpl<wave::WaveAMDLiveInterval> *,
                 DenseMap<Value, unsigned> *>
intervalsFor(waveamdmachine::RegType rt,
             wave::WaveAMDLiveIntervalSet &intervals) {
  if (wave::isWaveAMDSGPR(rt))
    return {&intervals.sgprs, &intervals.sgprIntervals};
  if (wave::isWaveAMDVGPR(rt))
    return {&intervals.vgprs, &intervals.vgprIntervals};
  return {&intervals.agprs, &intervals.agprIntervals};
}

static FailureOr<unsigned>
ensureInterval(Value value, unsigned pos,
               wave::WaveAMDLiveIntervalSet &intervals, Operation *errOp,
               bool includeAllocated) {
  if (!wave::isWaveAMDReg(value))
    return failure();
  auto rt = cast<waveamdmachine::RegType>(value.getType());
  if (wave::isWaveAMDFlagReg(rt))
    return failure();
  if (!wave::isWaveAMDSGPR(rt) && !wave::isWaveAMDVGPR(rt) &&
      !wave::isWaveAMDAGPR(rt))
    return errOp->emitError("waveamd regalloc supports only SGPR, VGPR, and "
                            "AGPR register classes");
  if (rt.getIndex() >= 0 && !includeAllocated)
    return failure();
  auto [bucket, table] = intervalsFor(rt, intervals);
  if (auto it = table->find(value); it != table->end()) {
    extendIntervalValue((*bucket)[it->second], value, pos);
    return it->second;
  }
  unsigned index = bucket->size();
  wave::WaveAMDLiveInterval interval;
  interval.type = rt;
  appendIntervalValue(interval, value, /*slotOffset=*/0, pos, pos);
  bucket->push_back(interval);
  (*table)[value] = index;
  return index;
}

static bool canAliasTypes(waveamdmachine::RegType baseType,
                          waveamdmachine::RegType valueType, unsigned offset) {
  if (baseType.getRegClass() != valueType.getRegClass())
    return false;
  return offset + valueType.getWidth() <= baseType.getWidth();
}

static bool canAliasInterval(const wave::WaveAMDLiveInterval &interval,
                             waveamdmachine::RegType valueType,
                             unsigned offset) {
  return canAliasTypes(interval.type, valueType, offset);
}

static bool canFitIntervalAt(const wave::WaveAMDLiveInterval &base,
                             const wave::WaveAMDLiveInterval &nested,
                             int64_t offset) {
  if (offset < 0 || base.type.getRegClass() != nested.type.getRegClass())
    return false;
  return static_cast<uint64_t>(offset) + nested.type.getWidth() <=
         static_cast<uint64_t>(base.type.getWidth());
}

static FailureOr<unsigned>
getIntervalSlotOffset(Value value, const wave::WaveAMDLiveInterval &interval,
                      Operation *errOp) {
  for (auto [v, off] : llvm::zip(interval.values, interval.slotOffsets))
    if (v == value)
      return off;
  return errOp->emitError("live interval table is missing value slot");
}

static void clearInterval(wave::WaveAMDLiveInterval &interval) {
  interval.values.clear();
  interval.slotOffsets.clear();
  interval.valueStarts.clear();
  interval.valueEnds.clear();
}

static void mergeIntervalAt(SmallVectorImpl<wave::WaveAMDLiveInterval> &bucket,
                            DenseMap<Value, unsigned> &table, unsigned dstIdx,
                            unsigned srcIdx, unsigned shift, Value usedValue,
                            unsigned pos) {
  wave::WaveAMDLiveInterval &dst = bucket[dstIdx];
  wave::WaveAMDLiveInterval &src = bucket[srcIdx];
  updateEnvelope(dst, src.start, std::max(src.end, pos));
  for (auto [value, offset, start, end] :
       llvm::zip(src.values, src.slotOffsets, src.valueStarts, src.valueEnds)) {
    dst.values.push_back(value);
    dst.slotOffsets.push_back(shift + offset);
    dst.valueStarts.push_back(start);
    dst.valueEnds.push_back(value == usedValue ? bumpEnd(end, pos) : end);
    table[value] = dstIdx;
  }
  clearInterval(src);
}

static LogicalResult appendAliasValue(wave::WaveAMDLiveInterval &primary,
                                      DenseMap<Value, unsigned> &table,
                                      unsigned primaryIndex, Value extra,
                                      waveamdmachine::RegType extraType,
                                      unsigned requestedSlot, unsigned pos) {
  if (!canAliasInterval(primary, extraType, requestedSlot))
    return success();
  appendIntervalValue(primary, extra, requestedSlot, pos, pos);
  table[extra] = primaryIndex;
  return success();
}

static LogicalResult
mergeAliasIntervals(SmallVectorImpl<wave::WaveAMDLiveInterval> &bucket,
                    DenseMap<Value, unsigned> &table, unsigned primaryIndex,
                    unsigned extraIndex, Value extra, int64_t requestedSlot,
                    unsigned pos, Operation *errOp) {
  wave::WaveAMDLiveInterval &primary = bucket[primaryIndex];
  wave::WaveAMDLiveInterval &extraInterval = bucket[extraIndex];
  FailureOr<unsigned> extraSlot =
      getIntervalSlotOffset(extra, extraInterval, errOp);
  if (failed(extraSlot))
    return failure();
  if (extraIndex == primaryIndex) {
    if (static_cast<int64_t>(*extraSlot) == requestedSlot)
      return success();
    return errOp->emitError("coalesce: alias slot offset mismatch, existing ")
           << *extraSlot << " requested " << requestedSlot;
  }

  int64_t extraShift = requestedSlot - *extraSlot;
  if (canFitIntervalAt(primary, extraInterval, extraShift)) {
    mergeIntervalAt(bucket, table, primaryIndex, extraIndex,
                    static_cast<unsigned>(extraShift), extra, pos);
    return success();
  }

  int64_t primaryShift = *extraSlot - requestedSlot;
  if (!canFitIntervalAt(extraInterval, primary, primaryShift))
    return errOp->emitError("coalesce: alias interval envelope mismatch");
  extendIntervalValue(extraInterval, extra, pos);
  mergeIntervalAt(bucket, table, extraIndex, primaryIndex,
                  static_cast<unsigned>(primaryShift), extra, pos);
  return success();
}

// `delta` pins extra relative to primary, independent of either interval root.
static LogicalResult coalesce(Value primary, Value extra, unsigned pos,
                              wave::WaveAMDLiveIntervalSet &intervals,
                              Operation *errOp, int64_t delta = 0) {
  std::optional<waveamdmachine::RegType> rt =
      wave::getTrackedWaveAMDRegType(primary);
  if (!rt)
    return success();
  std::optional<waveamdmachine::RegType> extraRt =
      wave::getTrackedWaveAMDRegType(extra);
  if (!extraRt)
    return success();
  if (rt->getRegClass() != extraRt->getRegClass())
    return success();
  auto [bucket, table] = intervalsFor(*rt, intervals);
  auto primIt = table->find(primary);
  if (primIt == table->end())
    return errOp->emitError("coalesce: primary has no interval");
  unsigned primIdx = primIt->second;
  wave::WaveAMDLiveInterval &prim = (*bucket)[primIdx];
  FailureOr<unsigned> primarySlot = getIntervalSlotOffset(primary, prim, errOp);
  if (failed(primarySlot))
    return failure();
  int64_t requestedSlot = static_cast<int64_t>(*primarySlot) + delta;
  if (requestedSlot < 0)
    return success();
  auto extraIt = table->find(extra);
  if (extraIt == table->end())
    return appendAliasValue(prim, *table, primIdx, extra, *extraRt,
                            static_cast<unsigned>(requestedSlot), pos);
  return mergeAliasIntervals(*bucket, *table, primIdx, extraIt->second, extra,
                             requestedSlot, pos, errOp);
}

static bool shouldCoalesceMFMAAccResult(func::FuncOp func) {
  BoolAttr attr = func->getAttrOfType<BoolAttr>(
      wave::regalloc::kRegAllocCoalesceMFMAAccResultAttr);
  return !attr || attr.getValue();
}

static bool intervalValueEndsAt(const wave::WaveAMDLiveInterval &interval,
                                Value value, unsigned position) {
  for (auto [member, end] : llvm::zip(interval.values, interval.valueEnds))
    if (member == value)
      return end == position;
  return false;
}

struct MFMAAccumulatorAlias {
  Value acc;
  Value result;
  waveamdmachine::RegType type;
};

static std::optional<MFMAAccumulatorAlias>
getMFMAAccumulatorAlias(Operation &op) {
  if (!op.hasTrait<OpTrait::waveamdmachine::MFMAOp>())
    return std::nullopt;
  waveamdmachine::MMAOpInterface mma =
      dyn_cast<waveamdmachine::MMAOpInterface>(&op);
  if (!mma)
    return std::nullopt;
  Value acc = mma.getAcc();
  Value resultValue = mma.getAccResult();
  std::optional<waveamdmachine::RegType> rt =
      wave::getTrackedWaveAMDRegType(acc);
  std::optional<waveamdmachine::RegType> resultRt =
      wave::getTrackedWaveAMDRegType(resultValue);
  if (!rt || !resultRt)
    return std::nullopt;
  if (rt->getRegClass() != resultRt->getRegClass() ||
      rt->getWidth() != resultRt->getWidth())
    return std::nullopt;
  return MFMAAccumulatorAlias{acc, resultValue, *rt};
}

struct PendingMFMAAccumulatorAlias {
  Operation *op = nullptr;
  unsigned position = 0;
};

class LiveIntervalBuilder {
public:
  LiveIntervalBuilder() = default;
  LiveIntervalBuilder(wave::WaveAMDLiveIntervalOrderOverride orderOverride,
                      bool includeAllocated,
                      wave::WaveAMDLiveIntervalAliasPolicy aliasPolicy =
                          wave::WaveAMDLiveIntervalAliasPolicy::Coalesce)
      : orderOverride(orderOverride), includeAllocated(includeAllocated),
        hasOrderOverride(true), aliasPolicy(aliasPolicy) {}
  LiveIntervalBuilder(wave::WaveAMDLiveIntervalOrderOverride orderOverride)
      : orderOverride(orderOverride), hasOrderOverride(true) {}
  explicit LiveIntervalBuilder(bool includeAllocated)
      : includeAllocated(includeAllocated) {}
  LiveIntervalBuilder(bool includeAllocated,
                      wave::WaveAMDLiveIntervalAliasPolicy aliasPolicy)
      : includeAllocated(includeAllocated), aliasPolicy(aliasPolicy) {}

  FailureOr<wave::WaveAMDLiveIntervalBuildResult> build(func::FuncOp func) {
    if (func.isExternal())
      return std::move(result);
    flow.emplace(func);
    coalesceMFMAAccResult = shouldCoalesceMFMAAccResult(func);
    if (failed(walkRegion(func.getBody())))
      return failure();
    if (hasOrderOverride && !usedOrderOverride)
      return func.emitError("live interval order override block not visited");
    if (failed(coalesceMFMAAccumulatorOps()))
      return failure();
    return std::move(result);
  }

private:
  struct ExclusiveRegionContext {
    Operation *branchOp = nullptr;
    unsigned branchPosition = 0;
    unsigned entry = 0;
  };

  void appendOriginalBlockOps(Block &block, SmallVectorImpl<Operation *> &ops) {
    for (Operation &op : block)
      ops.push_back(&op);
  }

  void collectOriginalBlockOps(Block &block,
                               SmallVectorImpl<Operation *> &originalOps,
                               DenseMap<Operation *, unsigned> &originalIndex) {
    unsigned index = 0;
    for (Operation &op : block) {
      originalOps.push_back(&op);
      originalIndex[&op] = index++;
    }
  }

  LogicalResult collectOverrideSet(
      Block &block, DenseMap<Operation *, unsigned> &originalIndex,
      DenseSet<Operation *> &overrideSet, unsigned &first, unsigned &last) {
    for (Operation *op : orderOverride.ops) {
      if (!op || op->getBlock() != &block)
        return block.getParentOp()->emitError(
            "live interval order override op is outside the override block");
      if (!overrideSet.insert(op).second)
        return op->emitError("duplicate live interval order override op");
      unsigned index = originalIndex.lookup(op);
      first = std::min(first, index);
      last = std::max(last, index);
    }
    return success();
  }

  LogicalResult verifyContiguousOverride(ArrayRef<Operation *> originalOps,
                                         DenseSet<Operation *> &overrideSet,
                                         unsigned first, unsigned last) {
    for (unsigned i = first; i <= last; ++i)
      if (!overrideSet.contains(originalOps[i]))
        return originalOps[i]->emitError(
            "live interval order override must replace a contiguous slice");
    return success();
  }

  void appendOverrideBlockOps(ArrayRef<Operation *> originalOps,
                              DenseSet<Operation *> &overrideSet,
                              unsigned first,
                              SmallVectorImpl<Operation *> &ops) {
    for (auto [index, op] : llvm::enumerate(originalOps)) {
      if (index == first)
        ops.append(orderOverride.ops.begin(), orderOverride.ops.end());
      if (overrideSet.contains(op))
        continue;
      ops.push_back(op);
    }
  }

  LogicalResult collectBlockOps(Block &block,
                                SmallVectorImpl<Operation *> &ops) {
    if (!hasOrderOverride || orderOverride.block != &block) {
      appendOriginalBlockOps(block, ops);
      return success();
    }
    usedOrderOverride = true;
    SmallVector<Operation *> originalOps;
    DenseMap<Operation *, unsigned> originalIndex;
    collectOriginalBlockOps(block, originalOps, originalIndex);

    DenseSet<Operation *> overrideSet;
    unsigned first = std::numeric_limits<unsigned>::max();
    unsigned last = 0;

    if (failed(
            collectOverrideSet(block, originalIndex, overrideSet, first, last)))
      return failure();
    if (overrideSet.empty()) {
      ops.append(originalOps.begin(), originalOps.end());
      return success();
    }
    if (failed(verifyContiguousOverride(originalOps, overrideSet, first, last)))
      return failure();

    appendOverrideBlockOps(originalOps, overrideSet, first, ops);
    return success();
  }

  bool extendIntervalRange(wave::WaveAMDLiveInterval &interval, Value value,
                           unsigned start, unsigned pos) {
    for (auto [index, member] : llvm::enumerate(interval.values)) {
      if (member != value || interval.valueStarts[index] != start)
        continue;
      interval.valueEnds[index] = bumpEnd(interval.valueEnds[index], pos);
      interval.end = bumpEnd(interval.end, pos);
      return true;
    }
    return false;
  }

  void extendInterval(Value value, unsigned pos, unsigned contextCount) {
    auto rt = wave::getTrackedWaveAMDRegType(value);
    if (!rt)
      return;
    auto [bucket, table] = intervalsFor(*rt, result.intervals);
    auto valueIt = table->find(value);
    if (valueIt == table->end())
      return;

    std::optional<unsigned> contextIndex;
    for (unsigned index = contextCount; index > 0; --index) {
      ExclusiveRegionContext &context = exclusiveRegionContexts[index - 1];
      if (!flow->isDefinedInside(context.branchOp, value)) {
        contextIndex = index - 1;
        break;
      }
    }
    if (!contextIndex) {
      extendIntervalValue((*bucket)[valueIt->second], value, pos);
      return;
    }

    ExclusiveRegionContext &context = exclusiveRegionContexts[*contextIndex];
    extendInterval(value, context.branchPosition, *contextIndex);
    valueIt = table->find(value);
    wave::WaveAMDLiveInterval &interval = (*bucket)[valueIt->second];
    if (extendIntervalRange(interval, value, context.entry, pos))
      return;
    FailureOr<unsigned> slot =
        getIntervalSlotOffset(value, interval, context.branchOp);
    if (succeeded(slot))
      appendIntervalValue(interval, value, *slot, context.entry, pos);
  }

  void extendInterval(Value value, unsigned pos) {
    extendInterval(value, pos, exclusiveRegionContexts.size());
  }

  bool intervalExists(Value value) {
    std::optional<waveamdmachine::RegType> type =
        wave::getTrackedWaveAMDRegType(value);
    if (!type)
      return false;
    return intervalsFor(*type, result.intervals).second->contains(value);
  }

  LogicalResult coalesceIfPresent(Value primary, Value extra, unsigned pos,
                                  Operation *branch, int64_t offset = 0) {
    if (!intervalExists(primary))
      return success();
    return coalesce(primary, extra, pos, result.intervals, branch, offset);
  }

  void ensureRegionArguments(Region &region, unsigned pos, Operation *branch) {
    for (Block &block : region)
      for (BlockArgument argument : block.getArguments())
        (void)ensureInterval(argument, pos, result.intervals, branch,
                             includeAllocated);
  }

  DenseSet<OpOperand *> getDetachedRepeatedEntryOperands(
      const wave::regalloc_detail::RegAllocRegionFlow::Branch &branch) {
    DenseSet<OpOperand *> detached;
    if (aliasPolicy != wave::WaveAMDLiveIntervalAliasPolicy::Conservative)
      return detached;
    DenseSet<Value> seen;
    for (const auto &transfer : branch.transfers) {
      if (transfer.source || !transfer.target ||
          !flow->isRepetitive(transfer.target) ||
          !wave::getTrackedWaveAMDRegType(transfer.operand->get()))
        continue;
      if (!seen.insert(transfer.operand->get()).second)
        detached.insert(transfer.operand);
    }
    return detached;
  }

  unsigned getTransferPosition(
      const wave::regalloc_detail::RegAllocRegionFlow::Branch &branch,
      const wave::regalloc_detail::RegAllocRegionFlow::Transfer &transfer,
      unsigned branchPosition, unsigned exitPosition) {
    if (!transfer.source && !transfer.target &&
        flow->resultsStartAtJoin(branch.op))
      return exitPosition;
    if (!transfer.source)
      return branchPosition;
    if (!transfer.target && !flow->resultsStartAtJoin(branch.op))
      return branchPosition;
    return result.positions.lookup(transfer.sourceOperation);
  }

  LogicalResult coalesceBranchTransferKind(
      const wave::regalloc_detail::RegAllocRegionFlow::Branch &branch,
      ArrayRef<wave::regalloc_detail::RegAllocRegionFlow::OrderedAliasEdge>
          aliases,
      wave::regalloc_detail::RegAllocRegionFlow::TransferKind wanted,
      unsigned branchPosition, unsigned exitPosition,
      const DenseSet<OpOperand *> &detached,
      DenseMap<OpOperand *, SmallVector<Value, 2>> &detachedInputs) {
    for (const auto &alias : aliases) {
      if (alias.kind != wanted)
        continue;
      const auto &transfer = *alias.transfer;
      unsigned pos =
          getTransferPosition(branch, transfer, branchPosition, exitPosition);
      // A pre-tested branch may reuse the entry operand for a bypass edge.
      // Detach only the repetitive entry; the bypass must still join results.
      if (wanted == wave::regalloc_detail::RegAllocRegionFlow::TransferKind::
                        RepetitiveEntry &&
          detached.contains(transfer.operand))
        continue;
      if (failed(coalesceIfPresent(alias.lhs, alias.rhs, pos, branch.op)))
        return failure();
    }
    return success();
  }

  LogicalResult coalesceDetachedEntryInputs(
      Operation *branch, unsigned branchPosition,
      DenseMap<OpOperand *, SmallVector<Value, 2>> &detachedInputs) {
    // A repeated entry operand denotes distinct carried storage.  Coalesce its
    // successor inputs with each other, but never with the repeated source.
    for (auto &[operand, inputs] : detachedInputs) {
      (void)operand;
      if (inputs.empty())
        continue;
      auto blockArgument = llvm::find_if(
          inputs, [](Value input) { return isa<BlockArgument>(input); });
      Value primary =
          blockArgument != inputs.end() ? *blockArgument : inputs.front();
      for (Value input : inputs)
        if (input != primary &&
            failed(coalesceIfPresent(primary, input, branchPosition, branch)))
          return failure();
    }
    return success();
  }

  void extendExternalRepetitiveUses(
      const wave::regalloc_detail::RegAllocRegionFlow::Branch &branch,
      unsigned endPosition) {
    for (Region *region : branch.regions) {
      if (!flow->isRepetitive(region))
        continue;
      region->walk([&](Operation *op) {
        for (Value operand : op->getOperands())
          if (!flow->isDefinedInside(branch.op, operand))
            extendInterval(operand, endPosition);
      });
    }
  }

  void extendImplicitRegisterUses(Operation *op) {
    auto implicit =
        dyn_cast<waveamdmachine::ImplicitRegisterUseOpInterface>(op);
    if (!implicit)
      return;
    for (waveamdmachine::ImplicitRegisterUse use :
         implicit.getImplicitRegisterUses()) {
      auto position = result.positions.find(use.lastUse);
      if (position != result.positions.end())
        extendInterval(use.value, position->second);
    }
  }

  LogicalResult processRegionBranch(Operation *op, unsigned position) {
    const auto *branch = flow->lookup(op);
    assert(branch && "RegionBranch operation must have a flow summary");
    bool repetitive = branch->repetitiveRegions.any();
    SmallVector<wave::regalloc_detail::RegAllocRegionFlow::OrderedAliasEdge, 8>
        aliases;
    if (aliasPolicy != wave::WaveAMDLiveIntervalAliasPolicy::Conservative ||
        repetitive)
      flow->appendOrderedAliasEdges(op, aliases);
    DenseSet<OpOperand *> detached = getDetachedRepeatedEntryOperands(*branch);
    DenseMap<OpOperand *, SmallVector<Value, 2>> detachedInputs;
    for (const auto &transfer : branch->transfers) {
      if (transfer.source || !transfer.target ||
          !flow->isRepetitive(transfer.target) ||
          !detached.contains(transfer.operand))
        continue;
      (void)ensureInterval(transfer.input, position, result.intervals, op,
                           includeAllocated);
      detachedInputs[transfer.operand].push_back(transfer.input);
    }

    // Repetitive entry transfers establish carried storage before walking the
    // body.  This is the structural equivalent of an SSA block argument being
    // live on entry; cyclic and exit transfers cannot be joined until their
    // source definitions have been visited.
    if (repetitive && failed(coalesceBranchTransferKind(
                          *branch, aliases,
                          wave::regalloc_detail::RegAllocRegionFlow::
                              TransferKind::RepetitiveEntry,
                          position, position, detached, detachedInputs)))
      return failure();
    if (failed(coalesceDetachedEntryInputs(op, position, detachedInputs)))
      return failure();

    bool sawExclusiveRegion = false;
    for (Region *region : branch->regions) {
      if (region->empty())
        continue;
      bool exclusive = flow->isExclusiveChoice(region);
      bool pushContext = exclusive && sawExclusiveRegion;
      if (pushContext)
        exclusiveRegionContexts.push_back({op, position, cursor});
      unsigned argumentPosition =
          flow->isRepetitive(region) ? position : cursor;
      if (!flow->isRepetitive(region))
        ensureRegionArguments(*region, argumentPosition, op);
      if (failed(walkRegion(*region))) {
        if (pushContext)
          exclusiveRegionContexts.pop_back();
        return failure();
      }
      if (pushContext)
        exclusiveRegionContexts.pop_back();
      sawExclusiveRegion |= exclusive;
    }

    unsigned exitPosition = cursor == 0 ? position : cursor - 1;
    if (flow->resultsStartAtJoin(op) && !repetitive)
      for (Value value : op->getResults())
        (void)ensureInterval(value, exitPosition, result.intervals, op,
                             includeAllocated);
    unsigned firstKind = repetitive ? 1u : 0u;
    for (unsigned kind = firstKind; kind != 4; ++kind)
      if (failed(coalesceBranchTransferKind(
              *branch, aliases,
              static_cast<
                  wave::regalloc_detail::RegAllocRegionFlow::TransferKind>(
                  kind),
              position, exitPosition, detached, detachedInputs)))
        return failure();
    extendExternalRepetitiveUses(*branch, exitPosition);
    return success();
  }

  LogicalResult processNestedRegions(Operation *op, unsigned pos) {
    if (op->getNumRegions() == 0)
      return success();
    if (flow->lookup(op))
      return processRegionBranch(op, pos);
    return walkNestedRegions(op);
  }

  LogicalResult coalesceStorageAliases(Operation &op, unsigned pos) {
    if (aliasPolicy == wave::WaveAMDLiveIntervalAliasPolicy::Conservative)
      return success();
    auto aliases =
        dyn_cast<waveamdmachine::RegisterStorageAliasOpInterface>(&op);
    if (!aliases)
      return success();
    storageAliases.clear();
    aliases.getRegisterStorageAliases(storageAliases);
    for (waveamdmachine::RegisterStorageAlias alias : storageAliases) {
      extendInterval(alias.storage, pos);
      if (failed(coalesceIfPresent(alias.storage, alias.alias, pos, &op,
                                   alias.offset)))
        return failure();
    }
    return success();
  }

  Value getSingleTrackedResult(Operation &op) {
    Value tracked;
    for (Value value : op.getResults()) {
      if (!wave::getTrackedWaveAMDRegType(value))
        continue;
      if (tracked)
        return {};
      tracked = value;
    }
    return tracked;
  }

  bool hasInterval(Value value, waveamdmachine::RegType type) {
    auto [bucket, table] = intervalsFor(type, result.intervals);
    (void)bucket;
    return table->contains(value);
  }

  bool intervalEndsAt(Value value, waveamdmachine::RegType type, unsigned pos) {
    auto [bucket, table] = intervalsFor(type, result.intervals);
    auto it = table->find(value);
    return it != table->end() &&
           intervalValueEndsAt((*bucket)[it->second], value, pos);
  }

  LogicalResult
  coalesceRequiredKilledOperandInput(Operation &op, Value resultValue,
                                     waveamdmachine::RegType resultType,
                                     OpOperand &operand, unsigned pos) {
    if (!wave::regalloc_detail::requiresKilledOperandReuseForResult(&op,
                                                                    operand))
      return success();
    Value source = operand.get();
    auto sourceType = wave::getTrackedWaveAMDRegType(source);
    if (!sourceType || sourceType->getRegClass() != resultType.getRegClass())
      return success();
    if (!intervalEndsAt(source, *sourceType, pos))
      return success();
    return coalesce(resultValue, source, pos, result.intervals, &op);
  }

  bool hasAMDGPUTarget(Operation &op) {
    for (Operation *cur = &op; cur; cur = cur->getParentOp())
      if (cur->hasAttr("waveamdmachine.target"))
        return true;
    return false;
  }

  LogicalResult coalesceRequiredKilledOperandInputs(Operation &op,
                                                    unsigned pos) {
    if (!hasAMDGPUTarget(op))
      return success();
    Value resultValue = getSingleTrackedResult(op);
    if (!resultValue)
      return success();
    auto resultType = wave::getTrackedWaveAMDRegType(resultValue);
    if (!resultType || !hasInterval(resultValue, *resultType))
      return success();
    for (OpOperand &operand : op.getOpOperands())
      if (failed(coalesceRequiredKilledOperandInput(op, resultValue,
                                                    *resultType, operand, pos)))
        return failure();
    return success();
  }

  void recordMFMAAccumulatorOp(Operation &op, unsigned pos) {
    if (coalesceMFMAAccResult && op.hasTrait<OpTrait::waveamdmachine::MFMAOp>())
      pendingMFMAAccumulatorAliases.push_back({&op, pos});
  }

  LogicalResult coalesceMFMAAccumulatorOp(Operation &op, unsigned pos) {
    std::optional<MFMAAccumulatorAlias> alias = getMFMAAccumulatorAlias(op);
    if (!alias)
      return success();
    auto [bucket, table] = intervalsFor(alias->type, result.intervals);
    auto accIt = table->find(alias->acc);
    if (accIt == table->end())
      return success();
    if (!intervalValueEndsAt((*bucket)[accIt->second], alias->acc, pos))
      return success();
    return coalesce(alias->acc, alias->result, pos, result.intervals, &op);
  }

  LogicalResult coalesceMFMAAccumulatorOps() {
    for (PendingMFMAAccumulatorAlias pending : pendingMFMAAccumulatorAliases)
      if (failed(coalesceMFMAAccumulatorOp(*pending.op, pending.position)))
        return failure();
    return success();
  }

  bool storageAliasHandlesOperandUse(Operation *op, Value operand) {
    if (aliasPolicy == wave::WaveAMDLiveIntervalAliasPolicy::Conservative)
      return false;
    auto aliases =
        dyn_cast<waveamdmachine::RegisterStorageAliasOpInterface>(op);
    if (!aliases)
      return false;
    storageAliases.clear();
    aliases.getRegisterStorageAliases(storageAliases);
    return llvm::any_of(
        storageAliases, [&](waveamdmachine::RegisterStorageAlias alias) {
          return alias.alias == operand && intervalExists(alias.storage);
        });
  }

  LogicalResult walkBlock(Block &block) {
    SmallVector<Operation *> ops;
    if (failed(collectBlockOps(block, ops)))
      return failure();
    for (Operation *op : ops) {
      unsigned pos = cursor++;
      result.positions[op] = pos;
      result.orderedOps.push_back(op);
      bool deferResults =
          op->getNumRegions() != 0 && flow->resultsStartAtJoin(op);
      if (!deferResults)
        for (Value value : op->getResults()) {
          // failure() here means "not a tracked register", not error.
          (void)ensureInterval(value, pos, result.intervals, op,
                               includeAllocated);
        }
      for (Value operand : op->getOperands())
        if (!storageAliasHandlesOperandUse(op, operand))
          extendInterval(operand, pos);
      recordMFMAAccumulatorOp(*op, pos);
      if (failed(coalesceStorageAliases(*op, pos)))
        return failure();
      if (failed(coalesceRequiredKilledOperandInputs(*op, pos)))
        return failure();
      if (failed(processNestedRegions(op, pos)))
        return failure();
      extendImplicitRegisterUses(op);
    }
    return success();
  }

  LogicalResult walkRegion(Region &region) {
    for (Block &block : region)
      if (failed(walkBlock(block)))
        return failure();
    return success();
  }

  LogicalResult walkNestedRegions(Operation *op) {
    for (Region &region : op->getRegions())
      if (failed(walkRegion(region)))
        return failure();
    return success();
  }

  wave::WaveAMDLiveIntervalBuildResult result;
  SmallVector<PendingMFMAAccumulatorAlias, 16> pendingMFMAAccumulatorAliases;
  SmallVector<ExclusiveRegionContext, 2> exclusiveRegionContexts;
  SmallVector<waveamdmachine::RegisterStorageAlias, 8> storageAliases;
  std::optional<wave::regalloc_detail::RegAllocRegionFlow> flow;
  wave::WaveAMDLiveIntervalOrderOverride orderOverride;
  unsigned cursor = 0;
  bool includeAllocated = false;
  bool hasOrderOverride = false;
  bool usedOrderOverride = false;
  bool coalesceMFMAAccResult = true;
  wave::WaveAMDLiveIntervalAliasPolicy aliasPolicy =
      wave::WaveAMDLiveIntervalAliasPolicy::Coalesce;
};

} // namespace

FailureOr<wave::WaveAMDLiveIntervalBuildResult>
mlir::wave::buildWaveAMDLiveIntervals(func::FuncOp func) {
  LiveIntervalBuilder builder;
  return builder.build(func);
}

FailureOr<wave::WaveAMDLiveIntervalBuildResult>
mlir::wave::buildAllocatedWaveAMDLiveIntervals(func::FuncOp func) {
  LiveIntervalBuilder builder(/*includeAllocated=*/true);
  return builder.build(func);
}

FailureOr<wave::WaveAMDLiveIntervalBuildResult>
mlir::wave::buildWaveAMDLiveIntervals(
    func::FuncOp func, WaveAMDLiveIntervalOrderOverride orderOverride) {
  if (!orderOverride.block)
    return buildWaveAMDLiveIntervals(func);
  LiveIntervalBuilder builder(orderOverride);
  return builder.build(func);
}

FailureOr<wave::WaveAMDLiveIntervalBuildResult>
mlir::wave::buildAllocatedWaveAMDLiveIntervals(
    func::FuncOp func, WaveAMDLiveIntervalOrderOverride orderOverride) {
  if (!orderOverride.block)
    return buildAllocatedWaveAMDLiveIntervals(func);
  LiveIntervalBuilder builder(orderOverride, /*includeAllocated=*/true);
  return builder.build(func);
}

FailureOr<wave::WaveAMDLiveIntervalBuildResult>
mlir::wave::buildAllocatedWaveAMDLiveIntervals(
    func::FuncOp func, WaveAMDLiveIntervalOrderOverride orderOverride,
    WaveAMDLiveIntervalAliasPolicy aliasPolicy) {
  if (!orderOverride.block) {
    LiveIntervalBuilder builder(/*includeAllocated=*/true, aliasPolicy);
    return builder.build(func);
  }
  LiveIntervalBuilder builder(orderOverride, /*includeAllocated=*/true,
                              aliasPolicy);
  return builder.build(func);
}
