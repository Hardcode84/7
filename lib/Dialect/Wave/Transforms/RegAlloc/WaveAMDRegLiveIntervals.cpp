//===- WaveAMDRegLiveIntervals.cpp - WaveAMD reg liveness ------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "WaveAMDRegLiveIntervals.h"

#include "WaveAMDRegAllocInternal.h"
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

static FailureOr<unsigned>
getIntervalSlotOffset(Value value, const wave::WaveAMDLiveInterval &interval,
                      Operation *errOp) {
  for (auto [v, off] : llvm::zip(interval.values, interval.slotOffsets))
    if (v == value)
      return off;
  return errOp->emitError("live interval table is missing value slot");
}

static LogicalResult
verifySelfCoalesceSlot(Value extra, const wave::WaveAMDLiveInterval &interval,
                       unsigned slotOffset, Operation *errOp) {
  FailureOr<unsigned> existingSlot =
      getIntervalSlotOffset(extra, interval, errOp);
  if (failed(existingSlot))
    return failure();
  if (*existingSlot == slotOffset)
    return success();
  return errOp->emitError("coalesce: alias slot offset mismatch, existing ")
         << *existingSlot << " requested " << slotOffset;
}

// Merge `extra` into `primary`; `slotOffset` pins tuple elements under base.
static LogicalResult coalesce(Value primary, Value extra, unsigned pos,
                              wave::WaveAMDLiveIntervalSet &intervals,
                              Operation *errOp, unsigned slotOffset = 0) {
  std::optional<waveamdmachine::RegType> rt =
      wave::getTrackedWaveAMDRegType(primary);
  if (!rt)
    return success();
  std::optional<waveamdmachine::RegType> extraRt =
      wave::getTrackedWaveAMDRegType(extra);
  if (!extraRt || rt->getRegClass() != extraRt->getRegClass())
    return success();
  auto [bucket, table] = intervalsFor(*rt, intervals);
  auto primIt = table->find(primary);
  if (primIt == table->end())
    return errOp->emitError("coalesce: primary has no interval");
  unsigned primIdx = primIt->second;
  if (!canAliasInterval((*bucket)[primIdx], *extraRt, slotOffset))
    return success();
  auto extraIt = table->find(extra);
  if (extraIt == table->end()) {
    appendIntervalValue((*bucket)[primIdx], extra, slotOffset, pos, pos);
    (*table)[extra] = primIdx;
    return success();
  }
  unsigned extraIdx = extraIt->second;
  if (extraIdx == primIdx)
    return verifySelfCoalesceSlot(extra, (*bucket)[primIdx], slotOffset, errOp);
  wave::WaveAMDLiveInterval &prim = (*bucket)[primIdx];
  wave::WaveAMDLiveInterval &ex = (*bucket)[extraIdx];
  updateEnvelope(prim, ex.start, std::max(ex.end, pos));
  for (auto [v, off, start, end] :
       llvm::zip(ex.values, ex.slotOffsets, ex.valueStarts, ex.valueEnds)) {
    prim.values.push_back(v);
    prim.slotOffsets.push_back(slotOffset + off);
    prim.valueStarts.push_back(start);
    prim.valueEnds.push_back(bumpEnd(end, pos));
    (*table)[v] = primIdx;
  }
  ex.values.clear();
  ex.slotOffsets.clear();
  ex.valueStarts.clear();
  ex.valueEnds.clear();
  return success();
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
  if (!llvm::hasSingleElement(acc.getUses()))
    return std::nullopt;
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

class LiveIntervalBuilder {
public:
  LiveIntervalBuilder() = default;
  LiveIntervalBuilder(wave::WaveAMDLiveIntervalOrderOverride orderOverride,
                      bool includeAllocated)
      : orderOverride(orderOverride), includeAllocated(includeAllocated),
        hasOrderOverride(true) {}
  LiveIntervalBuilder(wave::WaveAMDLiveIntervalOrderOverride orderOverride)
      : orderOverride(orderOverride), hasOrderOverride(true) {}
  explicit LiveIntervalBuilder(bool includeAllocated)
      : includeAllocated(includeAllocated) {}

  FailureOr<wave::WaveAMDLiveIntervalBuildResult> build(func::FuncOp func) {
    if (func.isExternal())
      return std::move(result);
    coalesceMFMAAccResult = shouldCoalesceMFMAAccResult(func);
    if (failed(walkRegion(func.getBody())))
      return failure();
    if (hasOrderOverride && !usedOrderOverride)
      return func.emitError("live interval order override block not visited");
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

  LogicalResult coalesceLoopEntryCarries(waveamdmachine::UniformLoopOp loop,
                                         unsigned pos) {
    Block &body = loop.getBody().front();
    for (auto [i, init] : llvm::enumerate(loop.getInits())) {
      auto rt = wave::getTrackedWaveAMDRegType(init);
      if (!rt)
        continue;
      auto [bucket, table] = intervalsFor(*rt, result.intervals);
      // Pre-pinned inits have no interval; carry/result already share phys.
      if (!table->contains(init))
        continue;
      FailureOr<unsigned> initSlot =
          getIntervalSlotOffset(init, (*bucket)[table->lookup(init)], loop);
      if (failed(initSlot))
        return failure();
      if (failed(coalesce(init, body.getArgument(i), pos, result.intervals,
                          loop, *initSlot)))
        return failure();
      if (failed(coalesce(init, loop.getResult(i), pos, result.intervals, loop,
                          *initSlot)))
        return failure();
    }
    return success();
  }

  LogicalResult mergeLoopBackEdgeInterval(waveamdmachine::UniformLoopOp loop,
                                          wave::WaveAMDLiveInterval &loopIv,
                                          wave::WaveAMDLiveInterval &carryIv,
                                          unsigned initSlot, unsigned carrySlot,
                                          unsigned loopIndex,
                                          DenseMap<Value, unsigned> &table) {
    updateEnvelope(loopIv, carryIv.start, carryIv.end);
    for (auto [v, off, start, end] :
         llvm::zip(carryIv.values, carryIv.slotOffsets, carryIv.valueStarts,
                   carryIv.valueEnds)) {
      int64_t shifted = static_cast<int64_t>(off) -
                        static_cast<int64_t>(carrySlot) +
                        static_cast<int64_t>(initSlot);
      if (shifted < 0 ||
          !canAliasInterval(loopIv, cast<waveamdmachine::RegType>(v.getType()),
                            static_cast<unsigned>(shifted)))
        return loop.emitError("loop carry alias slot offset mismatch");
      loopIv.values.push_back(v);
      loopIv.slotOffsets.push_back(static_cast<unsigned>(shifted));
      loopIv.valueStarts.push_back(start);
      loopIv.valueEnds.push_back(end);
      table[v] = loopIndex;
    }
    carryIv.values.clear();
    carryIv.slotOffsets.clear();
    carryIv.valueStarts.clear();
    carryIv.valueEnds.clear();
    return success();
  }

  LogicalResult
  coalesceLoopBackEdgeCarries(waveamdmachine::UniformLoopOp loop) {
    Block &body = loop.getBody().front();
    auto term = cast<waveamdmachine::ContinueIfOp>(body.getTerminator());
    // Back-edge carry is a rename into the init interval.
    for (auto [i, init, carry] :
         llvm::enumerate(loop.getInits(), term.getCarries())) {
      auto rt = wave::getTrackedWaveAMDRegType(init);
      if (!rt)
        continue;
      auto [bucket, table] = intervalsFor(*rt, result.intervals);
      auto initIt = table->find(init);
      auto carryIt = table->find(carry);
      if (carryIt == table->end() || initIt == table->end())
        continue;
      wave::WaveAMDLiveInterval &loopIv = (*bucket)[initIt->second];
      wave::WaveAMDLiveInterval &carryIv = (*bucket)[carryIt->second];
      FailureOr<unsigned> initSlot = getIntervalSlotOffset(init, loopIv, loop);
      if (failed(initSlot))
        return failure();
      FailureOr<unsigned> carrySlot =
          getIntervalSlotOffset(carry, carryIv, loop);
      if (failed(carrySlot))
        return failure();
      if (carryIt->second == initIt->second) {
        if (*carrySlot != *initSlot)
          return loop.emitError("loop carry alias slot offset mismatch");
        continue;
      }
      if (failed(mergeLoopBackEdgeInterval(loop, loopIv, carryIv, *initSlot,
                                           *carrySlot, initIt->second, *table)))
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
    // Entry/result aliases first; back-edge aliases after body intervals exist.
    if (failed(coalesceLoopEntryCarries(loop, pos)))
      return failure();
    Block &body = loop.getBody().front();
    if (failed(walkBlock(body)))
      return failure();
    if (failed(coalesceLoopBackEdgeCarries(loop)))
      return failure();
    unsigned loopEnd = cursor - 1;
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
    if (failed(coalesceExecIfResults(execIf, pos)))
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
                                 Region &region, unsigned index, unsigned pos) {
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
    return coalesce(resultValue, yieldValue, pos, result.intervals, uniformIf);
  }

  LogicalResult coalesceUniformIfResults(waveamdmachine::UniformIfOp uniformIf,
                                         unsigned pos) {
    for (unsigned index : llvm::seq<unsigned>(0, uniformIf.getNumResults())) {
      if (failed(coalesceUniformIfRegionResults(
              uniformIf, uniformIf.getThenRegion(), index, pos)))
        return failure();
      if (failed(coalesceUniformIfRegionResults(
              uniformIf, uniformIf.getElseRegion(), index, pos)))
        return failure();
    }
    return success();
  }

  LogicalResult processUniformIf(waveamdmachine::UniformIfOp uniformIf,
                                 unsigned pos) {
    if (failed(coalesceUniformIfResults(uniformIf, pos)))
      return failure();
    if (failed(walkExecIfRegion(uniformIf.getThenRegion())))
      return failure();
    return walkExecIfRegion(uniformIf.getElseRegion());
  }

  LogicalResult processNestedRegions(Operation *op, unsigned pos) {
    if (auto loop = dyn_cast<waveamdmachine::UniformLoopOp>(op))
      return processLoop(loop, pos);
    if (auto uniformIf = dyn_cast<waveamdmachine::UniformIfOp>(op))
      return processUniformIf(uniformIf, pos);
    if (auto execIf = dyn_cast<waveamdmachine::ExecIfOp>(op))
      return processExecIf(execIf, pos);
    return walkNestedRegions(op);
  }

  LogicalResult coalesceTupleElementOps(Operation &op, unsigned pos) {
    // Tuple is primary; elements get cumulative dword offsets.
    auto coalesceTupleElements = [&](auto top) -> LogicalResult {
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
        if (failed(coalesce(tuple, element, pos, result.intervals, top,
                            cumOffset)))
          return failure();
        cumOffset +=
            cast<waveamdmachine::RegType>(element.getType()).getWidth();
      }
      return success();
    };
    if (auto toElems = dyn_cast<waveamdmachine::TupleToElementsOp>(op))
      return coalesceTupleElements(toElems);
    if (auto fromElems = dyn_cast<waveamdmachine::TupleFromElementsOp>(op))
      return coalesceTupleElements(fromElems);
    return success();
  }

  LogicalResult coalesceMFMAAccumulatorOp(Operation &op, unsigned pos) {
    if (!coalesceMFMAAccResult)
      return success();
    std::optional<MFMAAccumulatorAlias> alias = getMFMAAccumulatorAlias(op);
    if (!alias)
      return success();
    auto [bucket, table] = intervalsFor(alias->type, result.intervals);
    if (!table->contains(alias->acc))
      return success();
    FailureOr<unsigned> accSlot = getIntervalSlotOffset(
        alias->acc, (*bucket)[table->lookup(alias->acc)], &op);
    if (failed(accSlot))
      return failure();
    return coalesce(alias->acc, alias->result, pos, result.intervals, &op,
                    *accSlot);
  }

  bool tupleRenameHandlesOperandUses(Operation *op) {
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
      for (Value value : op->getResults()) {
        // failure() here means "not a tracked register", not error.
        (void)ensureInterval(value, pos, result.intervals, op,
                             includeAllocated);
      }
      if (!tupleRenameHandlesOperandUses(op))
        for (Value operand : op->getOperands())
          extendInterval(operand, pos);
      if (failed(coalesceMFMAAccumulatorOp(*op, pos)))
        return failure();
      if (failed(coalesceTupleElementOps(*op, pos)))
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
  wave::WaveAMDLiveIntervalOrderOverride orderOverride;
  unsigned cursor = 0;
  bool includeAllocated = false;
  bool hasOrderOverride = false;
  bool usedOrderOverride = false;
  bool coalesceMFMAAccResult = true;
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
