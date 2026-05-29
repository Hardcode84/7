//===- WaveAMDRegLiveIntervals.cpp - WaveAMD reg liveness ------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "WaveAMDRegLiveIntervals.h"

#include "mlir/Dialect/Func/IR/FuncOps.h"
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

} // namespace mlir::wave

namespace {

static unsigned bumpEnd(unsigned cur, unsigned pos) {
  return std::max(cur, pos);
}

static std::pair<SmallVectorImpl<wave::WaveAMDLiveInterval> *,
                 DenseMap<Value, unsigned> *>
intervalsFor(waveamdmachine::RegType rt,
             wave::WaveAMDLiveIntervalSet &intervals) {
  if (wave::isWaveAMDSGPR(rt))
    return {&intervals.sgprs, &intervals.sgprIntervals};
  return {&intervals.vgprs, &intervals.vgprIntervals};
}

// Find or create `value`'s interval in the matching SGPR/VGPR bucket.
static FailureOr<unsigned>
ensureInterval(Value value, unsigned pos,
               wave::WaveAMDLiveIntervalSet &intervals, Operation *errOp,
               bool includeAllocated) {
  if (!wave::isWaveAMDReg(value))
    return failure();
  auto rt = cast<waveamdmachine::RegType>(value.getType());
  if (wave::isWaveAMDFlagReg(rt))
    return failure();
  if (!wave::isWaveAMDSGPR(rt) && !wave::isWaveAMDVGPR(rt))
    return errOp->emitError("waveamd-reg-alloc supports only SGPR and "
                            "VGPR register classes");
  if (rt.getIndex() >= 0 && !includeAllocated)
    return failure();
  auto [bucket, table] = intervalsFor(rt, intervals);
  if (auto it = table->find(value); it != table->end()) {
    (*bucket)[it->second].start = std::min((*bucket)[it->second].start, pos);
    (*bucket)[it->second].end = bumpEnd((*bucket)[it->second].end, pos);
    return it->second;
  }
  unsigned index = bucket->size();
  wave::WaveAMDLiveInterval interval;
  interval.values.push_back(value);
  interval.slotOffsets.push_back(0);
  interval.type = rt;
  interval.start = pos;
  interval.end = pos;
  bucket->push_back(interval);
  (*table)[value] = index;
  return index;
}

// Merge `extra` into `primary`; `slotOffset` pins tuple elements under base.
static LogicalResult coalesce(Value primary, Value extra, unsigned pos,
                              wave::WaveAMDLiveIntervalSet &intervals,
                              Operation *errOp, unsigned slotOffset = 0) {
  auto rt = dyn_cast<waveamdmachine::RegType>(primary.getType());
  if (!rt)
    return errOp->emitError("coalesce: primary value is not a register");
  auto [bucket, table] = intervalsFor(rt, intervals);
  auto primIt = table->find(primary);
  if (primIt == table->end())
    return errOp->emitError("coalesce: primary has no interval");
  unsigned primIdx = primIt->second;
  auto extraIt = table->find(extra);
  if (extraIt == table->end()) {
    // First alias for `extra`: place it inside primary's block.
    (*bucket)[primIdx].values.push_back(extra);
    (*bucket)[primIdx].slotOffsets.push_back(slotOffset);
    (*bucket)[primIdx].start = std::min((*bucket)[primIdx].start, pos);
    (*bucket)[primIdx].end = bumpEnd((*bucket)[primIdx].end, pos);
    (*table)[extra] = primIdx;
    return success();
  }
  unsigned extraIdx = extraIt->second;
  if (extraIdx == primIdx)
    return success();
  wave::WaveAMDLiveInterval &prim = (*bucket)[primIdx];
  wave::WaveAMDLiveInterval &ex = (*bucket)[extraIdx];
  prim.start = std::min(prim.start, ex.start);
  prim.end = bumpEnd(prim.end, std::max(ex.end, pos));
  // Existing interval merge: carried offsets shift under primary.
  for (auto [v, off] : llvm::zip(ex.values, ex.slotOffsets)) {
    prim.values.push_back(v);
    prim.slotOffsets.push_back(slotOffset + off);
    (*table)[v] = primIdx;
  }
  ex.values.clear();
  ex.slotOffsets.clear();
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

class LiveIntervalBuilder {
public:
  LiveIntervalBuilder() = default;
  LiveIntervalBuilder(wave::WaveAMDLiveIntervalOrderOverride orderOverride)
      : orderOverride(orderOverride), hasOrderOverride(true) {}
  explicit LiveIntervalBuilder(bool includeAllocated)
      : includeAllocated(includeAllocated) {}

  FailureOr<wave::WaveAMDLiveIntervalBuildResult> build(func::FuncOp func) {
    if (func.isExternal())
      return std::move(result);
    if (failed(walkBlock(func.getBody().front())))
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
      (*bucket)[it->second].end = bumpEnd((*bucket)[it->second].end, pos);
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
      if (failed(
              coalesce(init, body.getArgument(i), pos, result.intervals, loop)))
        return failure();
      if (failed(
              coalesce(init, loop.getResult(i), pos, result.intervals, loop)))
        return failure();
    }
    return success();
  }

  void coalesceLoopBackEdgeCarries(waveamdmachine::UniformLoopOp loop) {
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
      if (carryIt->second == initIt->second)
        continue;
      wave::WaveAMDLiveInterval &loopIv = (*bucket)[initIt->second];
      wave::WaveAMDLiveInterval &carryIv = (*bucket)[carryIt->second];
      loopIv.start = std::min(loopIv.start, carryIv.start);
      loopIv.end = bumpEnd(loopIv.end, carryIv.end);
      for (auto [v, off] : llvm::zip(carryIv.values, carryIv.slotOffsets)) {
        loopIv.values.push_back(v);
        loopIv.slotOffsets.push_back(off);
        (*table)[v] = initIt->second;
      }
      carryIv.values.clear();
      carryIv.slotOffsets.clear();
    }
  }

  void extendCarriesToLoopEnd(waveamdmachine::UniformLoopOp loop,
                              unsigned endPos) {
    // Carry intervals cover the loop op, not just the body.
    for (Value init : loop.getInits())
      extendInterval(init, endPos);
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
    coalesceLoopBackEdgeCarries(loop);
    extendCarriesToLoopEnd(loop, cursor);
    extendExternalLoopUses(loop, cursor);
    return success();
  }

  LogicalResult coalesceTupleElementOps(Operation &op, unsigned pos) {
    // Tuple is primary; elements get cumulative dword offsets.
    auto coalesceTupleElements = [&](auto top) -> LogicalResult {
      Value tuple = top.getTuple();
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
      for (Value operand : op->getOperands())
        extendInterval(operand, pos);
      if (failed(coalesceTupleElementOps(*op, pos)))
        return failure();
      if (auto loop = dyn_cast<waveamdmachine::UniformLoopOp>(op))
        if (failed(processLoop(loop, pos)))
          return failure();
    }
    return success();
  }

  wave::WaveAMDLiveIntervalBuildResult result;
  wave::WaveAMDLiveIntervalOrderOverride orderOverride;
  unsigned cursor = 0;
  bool includeAllocated = false;
  bool hasOrderOverride = false;
  bool usedOrderOverride = false;
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
