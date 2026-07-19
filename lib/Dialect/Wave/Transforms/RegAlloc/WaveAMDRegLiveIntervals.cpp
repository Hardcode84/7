//===- WaveAMDRegLiveIntervals.cpp - WaveAMD reg liveness ------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "WaveAMDRegLiveIntervals.h"

#include "WaveAMDRegAllocInternal.h"
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

  void extendInterval(Value value, unsigned pos) {
    auto rt = wave::getTrackedWaveAMDRegType(value);
    if (!rt)
      return;
    auto [bucket, table] = intervalsFor(*rt, result.intervals);
    if (auto it = table->find(value); it != table->end())
      extendIntervalValue((*bucket)[it->second], value, pos);
  }

  SmallVector<Value> buildLoopCarryAnchors(waveamdmachine::UniformLoopOp loop) {
    SmallVector<Value> anchors(loop.getInits());
    if (aliasPolicy != wave::WaveAMDLiveIntervalAliasPolicy::Conservative)
      return anchors;
    DenseSet<Value> seen;
    Block &body = loop.getBody().front();
    for (auto [index, init] : llvm::enumerate(loop.getInits())) {
      if (!wave::getTrackedWaveAMDRegType(init) || seen.insert(init).second)
        continue;
      // Regalloc gives each repeated init its own loop-carried register.
      anchors[index] = body.getArgument(index);
    }
    return anchors;
  }

  LogicalResult coalesceLoopEntryCarries(waveamdmachine::UniformLoopOp loop,
                                         unsigned pos,
                                         ArrayRef<Value> anchors) {
    Block &body = loop.getBody().front();
    for (auto [i, init, anchor] : llvm::enumerate(loop.getInits(), anchors)) {
      std::optional<waveamdmachine::RegType> rt =
          wave::getTrackedWaveAMDRegType(anchor);
      if (!rt)
        continue;
      if (anchor != init) {
        (void)ensureInterval(anchor, pos, result.intervals, loop,
                             includeAllocated);
        continue;
      }
      DenseMap<Value, unsigned> *table =
          intervalsFor(*rt, result.intervals).second;
      // Pre-pinned inits have no interval; carry/result already share phys.
      if (!table->contains(init))
        continue;
      if (failed(
              coalesce(init, body.getArgument(i), pos, result.intervals, loop)))
        return failure();
    }
    return success();
  }

  LogicalResult coalesceLoopExitResults(waveamdmachine::UniformLoopOp loop,
                                        unsigned pos, ArrayRef<Value> anchors) {
    for (auto [anchor, resultValue] :
         llvm::zip_equal(anchors, loop.getResults())) {
      std::optional<waveamdmachine::RegType> rt =
          wave::getTrackedWaveAMDRegType(anchor);
      if (!rt)
        continue;
      DenseMap<Value, unsigned> *table =
          intervalsFor(*rt, result.intervals).second;
      if (!table->contains(anchor))
        continue;
      (void)ensureInterval(resultValue, pos, result.intervals, loop,
                           includeAllocated);
      if (failed(coalesce(anchor, resultValue, pos, result.intervals, loop)))
        return failure();
    }
    return success();
  }

  LogicalResult coalesceLoopBackEdgeCarries(waveamdmachine::UniformLoopOp loop,
                                            ArrayRef<Value> anchors) {
    Block &body = loop.getBody().front();
    auto term = cast<waveamdmachine::ContinueIfOp>(body.getTerminator());
    // Back-edge carry is a rename into its loop slot interval.
    for (auto [anchor, carry] : llvm::zip_equal(anchors, term.getCarries())) {
      std::optional<waveamdmachine::RegType> rt =
          wave::getTrackedWaveAMDRegType(anchor);
      if (!rt)
        continue;
      DenseMap<Value, unsigned> *table =
          intervalsFor(*rt, result.intervals).second;
      auto initIt = table->find(anchor);
      auto carryIt = table->find(carry);
      if (carryIt == table->end() || initIt == table->end())
        continue;
      if (failed(coalesce(anchor, carry, result.positions.lookup(term),
                          result.intervals, loop)))
        return failure();
    }
    return success();
  }

  void extendExternalLoopUses(waveamdmachine::UniformLoopOp loop,
                              unsigned endPos) {
    loop.getBody().walk([&](Operation *op) {
      for (Value operand : op->getOperands()) {
        if (valueIsDefinedInside(loop, operand))
          continue;
        extendInterval(operand, endPos);
      }
    });
  }

  LogicalResult processLoop(waveamdmachine::UniformLoopOp loop, unsigned pos) {
    SmallVector<Value> carryAnchors = buildLoopCarryAnchors(loop);
    // Entry/result aliases first; back-edge aliases after body intervals exist.
    if (failed(coalesceLoopEntryCarries(loop, pos, carryAnchors)))
      return failure();
    Block &body = loop.getBody().front();
    if (failed(walkBlock(body)))
      return failure();
    if (failed(coalesceLoopBackEdgeCarries(loop, carryAnchors)))
      return failure();
    unsigned loopEnd = cursor - 1;
    if (failed(coalesceLoopExitResults(loop, loopEnd, carryAnchors)))
      return failure();
    extendExternalLoopUses(loop, loopEnd);
    return success();
  }

  LogicalResult coalesceExecIfRegionResults(waveamdmachine::ExecIfOp execIf,
                                            Region &region, unsigned index,
                                            unsigned pos) {
    if (region.empty())
      return success();
    auto yield =
        dyn_cast<waveamdmachine::YieldOp>(region.front().getTerminator());
    if (!yield || index >= yield.getValues().size())
      return success();
    Value resultValue = execIf.getResult(index);
    auto rt = wave::getTrackedWaveAMDRegType(resultValue);
    if (!rt)
      return success();
    auto [bucket, table] = intervalsFor(*rt, result.intervals);
    if (!table->contains(resultValue))
      return success();
    return coalesce(resultValue, yield.getValues()[index], pos,
                    result.intervals, execIf);
  }

  LogicalResult coalesceExecIfResults(waveamdmachine::ExecIfOp execIf,
                                      unsigned pos) {
    for (unsigned index : llvm::seq<unsigned>(0, execIf.getNumResults())) {
      if (failed(coalesceExecIfRegionResults(execIf, execIf.getThenRegion(),
                                             index, pos)))
        return failure();
      if (failed(coalesceExecIfRegionResults(execIf, execIf.getElseRegion(),
                                             index, pos)))
        return failure();
    }
    return success();
  }

  LogicalResult walkExecIfRegion(Region &region) {
    if (region.empty())
      return success();
    return walkBlock(region.front());
  }

  static bool needsConditionForDataMerge(waveamdmachine::ExecIfOp execIf) {
    if (execIf.getElseRegion().empty())
      return false;
    for (Type type : execIf.getResultTypes())
      if (!isa<waveamdmachine::MemTokenType>(type))
        return true;
    return false;
  }

  LogicalResult processExecIf(waveamdmachine::ExecIfOp execIf, unsigned pos) {
    if (aliasPolicy == wave::WaveAMDLiveIntervalAliasPolicy::Coalesce &&
        failed(coalesceExecIfResults(execIf, pos)))
      return failure();
    if (failed(walkExecIfRegion(execIf.getThenRegion())))
      return failure();
    if (!execIf.getElseRegion().empty())
      extendInterval(execIf.getCondition(), cursor - 1);
    if (failed(walkExecIfRegion(execIf.getElseRegion())))
      return failure();
    if (needsConditionForDataMerge(execIf))
      extendInterval(execIf.getCondition(), cursor - 1);
    return success();
  }

  LogicalResult
  coalesceUniformIfRegionResults(waveamdmachine::UniformIfOp uniformIf,
                                 Region &region, unsigned index) {
    if (region.empty())
      return success();
    auto yield =
        dyn_cast<waveamdmachine::YieldOp>(region.front().getTerminator());
    if (!yield || index >= yield.getValues().size())
      return success();
    Value resultValue = uniformIf.getResult(index);
    auto rt = wave::getTrackedWaveAMDRegType(resultValue);
    if (!rt)
      return success();
    auto [bucket, table] = intervalsFor(*rt, result.intervals);
    if (!table->contains(resultValue))
      return success();
    Value yieldValue = yield.getValues()[index];
    if (!valueIsDefinedInside(uniformIf, yieldValue))
      return uniformIf.emitError(
          "uniform_if register yield must be defined inside the branch");
    unsigned yieldPos = result.positions.lookup(yield);
    return coalesce(resultValue, yieldValue, yieldPos, result.intervals,
                    uniformIf);
  }

  LogicalResult
  coalesceUniformIfResults(waveamdmachine::UniformIfOp uniformIf) {
    for (unsigned index : llvm::seq<unsigned>(0, uniformIf.getNumResults())) {
      if (failed(coalesceUniformIfRegionResults(
              uniformIf, uniformIf.getThenRegion(), index)))
        return failure();
      if (failed(coalesceUniformIfRegionResults(
              uniformIf, uniformIf.getElseRegion(), index)))
        return failure();
    }
    return success();
  }

  LogicalResult processUniformIf(waveamdmachine::UniformIfOp uniformIf) {
    if (failed(walkExecIfRegion(uniformIf.getThenRegion())))
      return failure();
    if (failed(walkExecIfRegion(uniformIf.getElseRegion())))
      return failure();

    // Yield aliases cover each arm; parent results start at join.
    unsigned exitPos = cursor - 1;
    for (Value resultValue : uniformIf.getResults())
      (void)ensureInterval(resultValue, exitPos, result.intervals, uniformIf,
                           includeAllocated);
    if (aliasPolicy == wave::WaveAMDLiveIntervalAliasPolicy::Coalesce &&
        failed(coalesceUniformIfResults(uniformIf)))
      return failure();
    return success();
  }

  LogicalResult processNestedRegions(Operation *op, unsigned pos) {
    if (auto loop = dyn_cast<waveamdmachine::UniformLoopOp>(op))
      return processLoop(loop, pos);
    if (auto uniformIf = dyn_cast<waveamdmachine::UniformIfOp>(op))
      return processUniformIf(uniformIf);
    if (auto execIf = dyn_cast<waveamdmachine::ExecIfOp>(op))
      return processExecIf(execIf, pos);
    return walkNestedRegions(op);
  }

  template <typename TupleElementOp>
  LogicalResult coalesceTupleElements(TupleElementOp top, unsigned pos) {
    // Tuple is primary; elements get cumulative dword offsets.
    Value tuple = top.getTuple();
    extendInterval(tuple, pos);
    auto rt = wave::getTrackedWaveAMDRegType(tuple);
    if (rt) {
      auto [bucket, table] = intervalsFor(*rt, result.intervals);
      // Pinned tuples have no interval; elements derive tuple index + offset.
      if (!table->contains(tuple))
        return success();
    }
    unsigned cumOffset = 0;
    for (Value element : top.getElements()) {
      if (failed(
              coalesce(tuple, element, pos, result.intervals, top, cumOffset)))
        return failure();
      cumOffset += cast<waveamdmachine::RegType>(element.getType()).getWidth();
    }
    return success();
  }

  LogicalResult coalesceUpdateTupleOp(waveamdmachine::UpdateTupleOp update,
                                      unsigned pos) {
    Value resultTuple = update.getResult();
    Value baseTuple = update.getBase();
    extendInterval(baseTuple, pos);
    if (failed(
            coalesce(resultTuple, baseTuple, pos, result.intervals, update, 0)))
      return failure();
    for (auto [value, offset] :
         llvm::zip_equal(update.getUpdates(), update.getOffsets())) {
      unsigned slotOffset =
          static_cast<unsigned>(cast<IntegerAttr>(offset).getInt());
      if (failed(coalesce(resultTuple, value, pos, result.intervals, update,
                          slotOffset)))
        return failure();
    }
    return success();
  }

  LogicalResult coalesceTupleElementOps(Operation &op, unsigned pos) {
    if (aliasPolicy == wave::WaveAMDLiveIntervalAliasPolicy::Conservative)
      return success();
    if (auto toElems = dyn_cast<waveamdmachine::TupleToElementsOp>(op))
      return coalesceTupleElements(toElems, pos);
    if (auto fromElems = dyn_cast<waveamdmachine::TupleFromElementsOp>(op))
      return coalesceTupleElements(fromElems, pos);
    if (auto update = dyn_cast<waveamdmachine::UpdateTupleOp>(op))
      return coalesceUpdateTupleOp(update, pos);
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

  bool tupleRenameHandlesOperandUses(Operation *op) {
    if (aliasPolicy == wave::WaveAMDLiveIntervalAliasPolicy::Conservative)
      return false;
    if (isa<waveamdmachine::TupleToElementsOp>(op))
      return true;
    auto fromElems = dyn_cast<waveamdmachine::TupleFromElementsOp>(op);
    if (!fromElems)
      return false;
    auto rt = wave::getTrackedWaveAMDRegType(fromElems.getTuple());
    if (!rt)
      return false;
    auto [bucket, table] = intervalsFor(*rt, result.intervals);
    return table->contains(fromElems.getTuple());
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
          isa<waveamdmachine::UniformLoopOp, waveamdmachine::UniformIfOp>(op);
      if (!deferResults)
        for (Value value : op->getResults()) {
          // failure() here means "not a tracked register", not error.
          (void)ensureInterval(value, pos, result.intervals, op,
                               includeAllocated);
        }
      if (!tupleRenameHandlesOperandUses(op))
        for (Value operand : op->getOperands())
          extendInterval(operand, pos);
      recordMFMAAccumulatorOp(*op, pos);
      if (failed(coalesceTupleElementOps(*op, pos)))
        return failure();
      if (failed(coalesceRequiredKilledOperandInputs(*op, pos)))
        return failure();
      if (failed(processNestedRegions(op, pos)))
        return failure();
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
