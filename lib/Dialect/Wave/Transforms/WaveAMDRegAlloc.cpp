//===- WaveAMDRegAlloc.cpp - WaveAMD register allocation --------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/Wave/Transforms/Passes.h"

#include "Utils/AMDGPUBaseInfo.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachine.h"
#include "mlir/IR/Builders.h"
#include "mlir/IR/BuiltinOps.h"
#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/DenseSet.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/MC/MCSubtargetInfo.h"
#include "llvm/MC/TargetRegistry.h"
#include "llvm/Support/MathExtras.h"
#include "llvm/Support/TargetSelect.h"
#include "llvm/TargetParser/TargetParser.h"
#include "llvm/TargetParser/Triple.h"
#include <limits>
#include <optional>
#include <set>

namespace mlir::wave {
#define GEN_PASS_DEF_WAVEAMDREGALLOC
#include "mlir/Dialect/Wave/Transforms/Passes.h.inc"
} // namespace mlir::wave

using namespace mlir;

namespace {

// A live interval tracks one "logical" register: either a single Value
// or a coalesced group sharing one physical block. The canonical
// `type` carries the block's register class and width -- the latter is
// the *tuple* width when the interval spans a tuple plus its
// per-slot constituents. Each Value in `values` records its byte
// (well, dword) offset within the block via the parallel
// `slotOffsets`: a same-width loop-carry alias (init / block arg /
// result) lives at `offset 0`, the i-th element of a tuple lives at
// `offset i`. When the interval is allocated, every Value gets its
// type's index field set to `base + slotOffsets[i]`.
struct LiveInterval {
  SmallVector<Value> values;
  SmallVector<unsigned> slotOffsets; // parallel to `values`; slot of each Value
                                     // within the block
  waveamdmachine::RegType type;      // block (class, width); index is filled
                                     // in at allocation time
  unsigned start = std::numeric_limits<unsigned>::max();
  unsigned end = 0;
};

struct RegisterLimits {
  unsigned numSGPR = 0;
  unsigned numVGPR = 0;
};

static bool isReg(Value value) {
  return isa<waveamdmachine::RegType>(value.getType());
}

static bool isSGPR(waveamdmachine::RegType type) {
  return type.getRegClass() == waveamdmachine::RegClass::SGPR;
}

static bool isVGPR(waveamdmachine::RegType type) {
  return type.getRegClass() == waveamdmachine::RegClass::VGPR;
}

// SCC is a single hardware bit; we don't allocate physical registers
// for it.
static bool isSCC(waveamdmachine::RegType type) {
  return type.getRegClass() == waveamdmachine::RegClass::SCC;
}

static void setRegPhys(Value v, unsigned phys) {
  auto rt = cast<waveamdmachine::RegType>(v.getType());
  v.setType(waveamdmachine::RegType::get(rt.getContext(), rt.getRegClass(),
                                         rt.getWidth(),
                                         static_cast<int64_t>(phys)));
}

static FailureOr<std::unique_ptr<llvm::MCSubtargetInfo>>
createSubtargetInfo(ModuleOp module) {
  auto targetAttr = module->getAttrOfType<StringAttr>("waveamdmachine.target");
  if (!targetAttr)
    return module.emitError(
        "waveamd-reg-alloc requires a waveamdmachine.target "
        "attribute");

  StringRef target = targetAttr.getValue();
  std::pair<StringRef, StringRef> split = target.rsplit("--");
  StringRef cpu = split.second.empty() ? target : split.second;

  static llvm::once_flag initializeBackendOnce;
  llvm::call_once(initializeBackendOnce, []() {
    llvm::InitializeAllTargetInfos();
    llvm::InitializeAllTargetMCs();
  });

  llvm::Triple triple("amdgcn-amd-amdhsa");
  std::string error;
  const llvm::Target *llvmTarget =
      llvm::TargetRegistry::lookupTarget(triple, error);
  if (!llvmTarget)
    return module.emitError("failed to lookup AMDGPU target: ") << error;

  std::unique_ptr<llvm::MCSubtargetInfo> sti(
      llvmTarget->createMCSubtargetInfo(triple, cpu, /*Features=*/""));
  if (!sti)
    return module.emitError("unsupported AMDGPU target: ") << target;
  if (llvm::AMDGPU::getIsaVersion(cpu).Major == 0)
    return module.emitError("unsupported AMDGPU target: ") << target;
  return sti;
}

static FailureOr<RegisterLimits> getRegisterLimits(ModuleOp module) {
  FailureOr<std::unique_ptr<llvm::MCSubtargetInfo>> sti =
      createSubtargetInfo(module);
  if (failed(sti))
    return failure();

  RegisterLimits limits;
  limits.numSGPR = llvm::AMDGPU::IsaInfo::getAddressableNumSGPRs(sti->get());
  limits.numVGPR =
      llvm::AMDGPU::IsaInfo::getAddressableNumVGPRs(sti->get(),
                                                    /*DynamicVGPRBlockSize=*/0);
  return limits;
}

struct WaveAMDRegAllocPass
    : public wave::impl::WaveAMDRegAllocBase<WaveAMDRegAllocPass> {
  using WaveAMDRegAllocBase::WaveAMDRegAllocBase;

  void runOnOperation() override {
    FailureOr<RegisterLimits> limits = getRegisterLimits(getOperation());
    if (failed(limits))
      return signalPassFailure();
    if (vgprLimitOverride >= 0)
      limits->numVGPR =
          std::min(limits->numVGPR, static_cast<unsigned>(vgprLimitOverride));
    if (sgprLimitOverride >= 0)
      limits->numSGPR =
          std::min(limits->numSGPR, static_cast<unsigned>(sgprLimitOverride));
    SmallVector<func::FuncOp> kernels;
    getOperation().walk([&](func::FuncOp f) {
      if (!f.isExternal())
        kernels.push_back(f);
    });
    Builder builder(&getContext());
    int64_t overflowedCount = 0;
    for (func::FuncOp func : kernels) {
      bool overflow = false;
      if (failed(allocateFunction(func, *limits, markOverflow, overflow)))
        return signalPassFailure();
      if (overflow) {
        func->setAttr("waveamdmachine.regalloc_overflowed",
                      builder.getI64IntegerAttr(1));
        ++overflowedCount;
      }
    }
    if (markOverflow)
      getOperation()->setAttr("waveamdmachine.regalloc_overflowed_count",
                              builder.getI64IntegerAttr(overflowedCount));
  }

  struct LiveIntervalSet {
    SmallVector<LiveInterval> sgprs;
    SmallVector<LiveInterval> vgprs;
    // Maps any Value (definition or block arg) to the index of its
    // interval in `sgprs` / `vgprs`. Loop carries map all four
    // coalesced Values (init / block arg / continue_if carry / loop
    // result) to the same index.
    DenseMap<Value, unsigned> sgprIntervals;
    DenseMap<Value, unsigned> vgprIntervals;
  };

  static unsigned bumpEnd(unsigned cur, unsigned pos) {
    return std::max(cur, pos);
  }

  // Find or create the interval index for `v` in the right bucket.
  // Returns the index in either `intervals.sgprs` or `intervals.vgprs`
  // depending on the register class of `v`.
  static FailureOr<unsigned> ensureInterval(Value v, unsigned pos,
                                            LiveIntervalSet &intervals,
                                            Operation *errOp) {
    if (!isReg(v))
      return failure();
    auto rt = cast<waveamdmachine::RegType>(v.getType());
    if (isSCC(rt))
      return failure();
    if (!isSGPR(rt) && !isVGPR(rt))
      return errOp->emitError("waveamd-reg-alloc supports only SGPR and "
                              "VGPR register classes");
    if (rt.getIndex() >= 0)
      return failure();
    bool sgpr = isSGPR(rt);
    auto &bucket = sgpr ? intervals.sgprs : intervals.vgprs;
    auto &table = sgpr ? intervals.sgprIntervals : intervals.vgprIntervals;
    if (auto it = table.find(v); it != table.end()) {
      bucket[it->second].start = std::min(bucket[it->second].start, pos);
      bucket[it->second].end = bumpEnd(bucket[it->second].end, pos);
      return it->second;
    }
    unsigned index = bucket.size();
    LiveInterval iv;
    iv.values.push_back(v);
    iv.slotOffsets.push_back(0);
    iv.type = rt;
    iv.start = pos;
    iv.end = pos;
    bucket.push_back(iv);
    table[v] = index;
    return index;
  }

  // Coalesce: merge `extra` (and any pre-existing interval for it)
  // into the interval already created for `primary`. The absorbed
  // interval is emptied so it is skipped during allocation. Updates
  // the alias table so that subsequent lookups for `extra` resolve to
  // the primary interval. `slotOffset` places `extra` at
  // `primary.phys + slotOffset` once the block is assigned -- 0 for
  // the same-width loop-carry aliasing path (the existing iter-arg
  // coalesce); `i` for the i-th element of a wider tuple primary
  // (used by the tuple_to/from_elements coalesce in T3). Caller must
  // have already ensured `primary` has an interval.
  static LogicalResult coalesce(Value primary, Value extra, unsigned pos,
                                LiveIntervalSet &intervals, Operation *errOp,
                                unsigned slotOffset = 0) {
    auto rt = dyn_cast<waveamdmachine::RegType>(primary.getType());
    if (!rt)
      return errOp->emitError("coalesce: primary value is not a register");
    bool sgpr = isSGPR(rt);
    auto &bucket = sgpr ? intervals.sgprs : intervals.vgprs;
    auto &table = sgpr ? intervals.sgprIntervals : intervals.vgprIntervals;
    auto primIt = table.find(primary);
    if (primIt == table.end())
      return errOp->emitError("coalesce: primary has no interval");
    unsigned primIdx = primIt->second;
    auto extraIt = table.find(extra);
    if (extraIt == table.end()) {
      // No pre-existing interval for `extra`; simply alias it onto
      // primary's interval at `slotOffset`.
      bucket[primIdx].values.push_back(extra);
      bucket[primIdx].slotOffsets.push_back(slotOffset);
      bucket[primIdx].start = std::min(bucket[primIdx].start, pos);
      bucket[primIdx].end = bumpEnd(bucket[primIdx].end, pos);
      table[extra] = primIdx;
      return success();
    }
    unsigned extraIdx = extraIt->second;
    if (extraIdx == primIdx)
      return success();
    LiveInterval &prim = bucket[primIdx];
    LiveInterval &ex = bucket[extraIdx];
    prim.start = std::min(prim.start, ex.start);
    prim.end = bumpEnd(prim.end, std::max(ex.end, pos));
    // Merging two pre-existing intervals: every Value carried into
    // primary picks up `slotOffset` on top of whatever offset it
    // already had in `extra`.
    for (auto [v, off] : llvm::zip(ex.values, ex.slotOffsets)) {
      prim.values.push_back(v);
      prim.slotOffsets.push_back(slotOffset + off);
      table[v] = primIdx;
    }
    ex.values.clear();
    ex.slotOffsets.clear();
    return success();
  }

  // Predicate: skip non-register operands and SCC carries during
  // interval bookkeeping. Returns the operand's RegType when it should
  // be tracked, or std::nullopt otherwise.
  std::optional<waveamdmachine::RegType> trackedRegType(Value v) {
    if (!isReg(v))
      return std::nullopt;
    auto rt = cast<waveamdmachine::RegType>(v.getType());
    if (isSCC(rt))
      return std::nullopt;
    return rt;
  }

  // Pick the interval bucket + lookup table matching the SGPR/VGPR
  // class of `rt`.
  std::pair<SmallVectorImpl<LiveInterval> *, DenseMap<Value, unsigned> *>
  intervalsFor(waveamdmachine::RegType rt, LiveIntervalSet &intervals) {
    if (isSGPR(rt))
      return {&intervals.sgprs, &intervals.sgprIntervals};
    return {&intervals.vgprs, &intervals.vgprIntervals};
  }

  // Extend the live interval of `v` (if tracked) to cover `pos`.
  void extendInterval(Value v, unsigned pos, LiveIntervalSet &intervals) {
    auto rt = trackedRegType(v);
    if (!rt)
      return;
    auto [bucket, table] = intervalsFor(*rt, intervals);
    if (auto it = table->find(v); it != table->end())
      (*bucket)[it->second].end = bumpEnd((*bucket)[it->second].end, pos);
  }

  // Coalesce the loop block arg and result of each carry with the
  // init slot so the body can write back without an extra move.
  LogicalResult coalesceLoopEntryCarries(waveamdmachine::UniformLoopOp loop,
                                         unsigned pos,
                                         LiveIntervalSet &intervals) {
    Block &body = loop.getBody().front();
    for (auto [i, init] : llvm::enumerate(loop.getInits())) {
      if (!trackedRegType(init))
        continue;
      if (failed(coalesce(init, body.getArgument(i), pos, intervals, loop)))
        return failure();
      if (failed(coalesce(init, loop.getResult(i), pos, intervals, loop)))
        return failure();
    }
    return success();
  }

  // Fold the continue_if carry-source intervals into the loop's
  // init interval so the back-edge becomes a no-op rename.
  void coalesceLoopBackEdgeCarries(waveamdmachine::UniformLoopOp loop,
                                   LiveIntervalSet &intervals) {
    Block &body = loop.getBody().front();
    auto term = cast<waveamdmachine::ContinueIfOp>(body.getTerminator());
    for (auto [i, init, carry] :
         llvm::enumerate(loop.getInits(), term.getCarries())) {
      auto rt = trackedRegType(init);
      if (!rt)
        continue;
      auto [bucket, table] = intervalsFor(*rt, intervals);
      auto initIt = table->find(init);
      auto carryIt = table->find(carry);
      if (carryIt == table->end() || initIt == table->end())
        continue;
      if (carryIt->second == initIt->second)
        continue;
      LiveInterval &loopIv = (*bucket)[initIt->second];
      LiveInterval &carryIv = (*bucket)[carryIt->second];
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

  // Extend each carry's interval out to `endPos` so it stays live
  // until the loop op itself completes.
  void extendCarriesToLoopEnd(waveamdmachine::UniformLoopOp loop,
                              unsigned endPos, LiveIntervalSet &intervals) {
    for (Value init : loop.getInits())
      extendInterval(init, endPos, intervals);
  }

  // Process a uniform_loop op: coalesce entry carries, recurse into
  // the body, then coalesce the back-edge carries and extend the
  // carry intervals over the whole loop range.
  LogicalResult processLoop(waveamdmachine::UniformLoopOp loop, unsigned pos,
                            unsigned &cursor,
                            DenseMap<Operation *, unsigned> &positions,
                            SmallVectorImpl<Operation *> &orderedOps,
                            LiveIntervalSet &intervals) {
    if (failed(coalesceLoopEntryCarries(loop, pos, intervals)))
      return failure();
    Block &body = loop.getBody().front();
    if (failed(walkBlock(body, cursor, positions, orderedOps, intervals)))
      return failure();
    coalesceLoopBackEdgeCarries(loop, intervals);
    extendCarriesToLoopEnd(loop, cursor, intervals);
    return success();
  }

  // Walk a single block, assigning positions and building intervals.
  // Recurses into uniform_loop bodies via processLoop, which handles
  // loop-carry interval coalescing.
  LogicalResult walkBlock(Block &block, unsigned &cursor,
                          DenseMap<Operation *, unsigned> &positions,
                          SmallVectorImpl<Operation *> &orderedOps,
                          LiveIntervalSet &intervals) {
    for (Operation &op : block) {
      unsigned pos = cursor++;
      positions[&op] = pos;
      orderedOps.push_back(&op);
      for (Value result : op.getResults()) {
        // failure() here means "not a tracked register" (SCC, imm,
        // mem-token, ...) -- not an actual error.
        (void)ensureInterval(result, pos, intervals, &op);
      }
      for (Value operand : op.getOperands())
        extendInterval(operand, pos, intervals);
      if (failed(coalesceTupleElementOps(op, pos, intervals)))
        return failure();
      if (auto loop = dyn_cast<waveamdmachine::UniformLoopOp>(op)) {
        if (failed(processLoop(loop, pos, cursor, positions, orderedOps,
                               intervals)))
          return failure();
      }
    }
    return success();
  }

  // Pin each element of a tuple_to/from_elements into the tuple's
  // physical block at its cumulative byte (dword) offset within the
  // tuple. Tuple is always primary; element i absorbs at
  // `sum(width[0..i-1])` so the allocator emits `phys + offset` for it
  // once the block is assigned. Width-1 elements collapse to operand
  // index, matching the original semantics; wider sub-tuple pieces get
  // their proper offset.
  LogicalResult coalesceTupleElementOps(Operation &op, unsigned pos,
                                        LiveIntervalSet &intervals) {
    auto coalesceTupleElements = [&](auto top) -> LogicalResult {
      Value tuple = top.getTuple();
      unsigned cumOffset = 0;
      for (Value element : top.getElements()) {
        if (failed(coalesce(tuple, element, pos, intervals, top, cumOffset)))
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

  // Two iter_arg slots that share one init SSA value are semantically
  // independent carries that happen to start from the same value. The
  // entry-carry coalescer can only fold init -> blockArg -> result
  // into a single physical-register interval once per init; if it ran
  // for both slots, both block args / both result slots would alias the
  // same physical register and the body's per-slot writes would clobber
  // each other. Materialize an explicit register-rename copy for each
  // duplicate init so the coalescer sees fresh SSA values everywhere.
  LogicalResult splitDuplicateLoopInits(func::FuncOp func) {
    SmallVector<waveamdmachine::UniformLoopOp> loops;
    func.walk(
        [&](waveamdmachine::UniformLoopOp loop) { loops.push_back(loop); });
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

  // Emit a register-rename copy of `v` so the caller can use it as a
  // fresh SSA value with the same register class / width. Drives off
  // the source RegType: VGPR (any width) uses `v_mov_b32_tuple` with
  // a `registers` attr; SGPR1 uses `s_mov_b32_value`. Wider SGPR tuple
  // carries aren't covered by an existing dialect op yet; emit a
  // diagnostic so the gap is visible.
  static FailureOr<Value> duplicateRegValue(OpBuilder &builder, Location loc,
                                            Value v) {
    auto rt = cast<waveamdmachine::RegType>(v.getType());
    waveamdmachine::RegType resultType = waveamdmachine::RegType::get(
        rt.getContext(), rt.getRegClass(), rt.getWidth(), /*index=*/-1);
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

  // Each VGPR value used as a tuple element carries at most one slot
  // constraint: a cumulative dword offset within its
  // anchor tuple's physical block. `tuple_to_elements` anchors each
  // result at `sum(width[0..i-1])`; the first `tuple_from_elements`
  // to consume a value anchors it at the operand's cumulative offset.
  //
  // Copy whenever a coalesce-and-merge would either misplace this
  // value or drag a sibling tuple's contents into a slot the new
  // tuple already wants to fill with something else:
  //   - slot mismatch: anchored at offset k, used here at j != k.
  //   - reuse:         already absorbed by another from_elements.
  //   - drag-in:       value is a to_elements result, and this
  //                    from_elements is not a perfect identity
  //                    round-trip of the same source tuple, so
  //                    merging the source's interval would pull
  //                    its other slots into positions this
  //                    from_elements wants to fill with fresh ops.
  using ToElementsSourceMap = DenseMap<Value, std::pair<Value, unsigned>>;

  // Perfect identity round-trip: every operand is anchored at the
  // same source tuple at its matching cumulative offset, and the
  // from_elements tuple width equals the source tuple width. In
  // that case the coalescer's merge lines each source slot up with
  // exactly the operand slot the from_elements wants, so the two
  // tuples can safely share the source's physical block.
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

  // Process one tuple_from_elements: for each operand decide whether
  // coalescing it directly is safe; if not, materialize a v_mov rename
  // and rewire. Updates the running anchor / source / consumed maps.
  LogicalResult
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
      if (slotMismatch || reuse || dragInConflict) {
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

  LogicalResult splitTupleElementSharing(func::FuncOp func) {
    OpBuilder builder(func.getContext());
    DenseMap<Value, unsigned> anchorSlot;
    ToElementsSourceMap toElementsSource;
    DenseSet<Value> consumedByFromElements;
    func.walk([&](waveamdmachine::TupleToElementsOp op) {
      unsigned cumOffset = 0;
      for (Value element : op.getElements()) {
        anchorSlot[element] = cumOffset;
        toElementsSource[element] = {op.getTuple(), cumOffset};
        cumOffset +=
            cast<waveamdmachine::RegType>(element.getType()).getWidth();
      }
    });
    SmallVector<waveamdmachine::TupleFromElementsOp> ops;
    func.walk(
        [&](waveamdmachine::TupleFromElementsOp op) { ops.push_back(op); });
    for (waveamdmachine::TupleFromElementsOp op : ops) {
      if (failed(rewriteFromElementsForSharing(op, builder, anchorSlot,
                                               toElementsSource,
                                               consumedByFromElements)))
        return failure();
    }
    return success();
  }

  LogicalResult allocateFunction(func::FuncOp func, RegisterLimits limits,
                                 bool softFail, bool &overflow) {
    if (failed(splitDuplicateLoopInits(func)))
      return failure();
    if (failed(splitTupleElementSharing(func)))
      return failure();
    SmallVector<Operation *> orderedOps;
    DenseMap<Operation *, unsigned> positions;
    LiveIntervalSet intervals;
    unsigned cursor = 0;
    if (failed(walkBlock(func.getBody().front(), cursor, positions, orderedOps,
                         intervals)))
      return failure();

    // For `wave.kernel` funcs, the HSA loader preloads s[0:1] = kernarg
    // pointer (always) and s2/s3/s4 = workgroup_id.x/y/z (conditional on
    // the kernel descriptor flags; we reserve unconditionally to keep
    // the allocator simple). v0 always holds the packed workitem_id, so
    // reserve it too.
    unsigned sgprReserved =
        func->hasAttr(wave::WaveDialect::getKernelAttrName()) ? 5 : 0;
    unsigned vgprReserved =
        func->hasAttr(wave::WaveDialect::getKernelAttrName()) ? 1 : 0;
    if (failed(allocateClass(func, intervals.sgprs, limits.numSGPR,
                             sgprReserved, softFail, overflow)))
      return failure();
    return allocateClass(func, intervals.vgprs, limits.numVGPR, vgprReserved,
                         softFail, overflow);
  }

  // Physically-allocated half-open span `[begin, begin + size)` in a
  // single register class. The class itself is implicit -- each
  // allocator pass walks one class at a time and owns its own set.
  // Sort by `begin` so a `std::set` lets us iterate gaps in order;
  // intervals never overlap, so the begin-only comparison is also a
  // sound equality key when we erase on expiration.
  struct PhysAlloc {
    unsigned begin;
    unsigned size;
    unsigned end() const { return begin + size; }
    bool operator<(const PhysAlloc &o) const { return begin < o.begin; }
  };

  // Release every active interval whose end position is before `pos`,
  // dropping its `PhysAlloc` from `live` so the freed slot rejoins the
  // gap-walking pool. Mirrors the bitmap clear in the previous
  // implementation, just keyed by interval.
  void expireOld(SmallVectorImpl<LiveInterval> &active,
                 std::set<PhysAlloc> &live, unsigned pos) {
    SmallVector<LiveInterval> stillActive;
    for (LiveInterval interval : active) {
      if (interval.end >= pos) {
        stillActive.push_back(interval);
        continue;
      }
      auto rt =
          cast<waveamdmachine::RegType>(interval.values.front().getType());
      live.erase(PhysAlloc{static_cast<unsigned>(rt.getIndex()),
                           static_cast<unsigned>(rt.getWidth())});
    }
    active = std::move(stillActive);
  }

  LogicalResult allocateClass(func::FuncOp func,
                              MutableArrayRef<LiveInterval> intervals,
                              unsigned numPhys, unsigned reserved,
                              bool softFail, bool &overflow) {
    llvm::stable_sort(intervals,
                      [](const LiveInterval &lhs, const LiveInterval &rhs) {
                        return lhs.start < rhs.start;
                      });

    SmallVector<LiveInterval> active;
    // Mirrors aster's `AllocConstraints` (RegisterColoring.cpp:82-258):
    // one `std::set<Allocation>` sorted by `begin` so the allocator
    // can walk gaps in order and pick the first one wide and aligned
    // enough. Reserved registers (kernel preloaded SGPRs, v0 for the
    // packed workitem id) pre-occupy `[0, reserved)`.
    std::set<PhysAlloc> live;
    if (reserved > 0 && reserved <= numPhys)
      live.insert(PhysAlloc{0, reserved});

    for (LiveInterval interval : intervals) {
      if (interval.values.empty())
        continue;
      expireOld(active, live, interval.start);
      unsigned width = interval.type.getWidth();
      // AMDGPU register classes are sized to the next power of two of
      // the tuple width: VReg_96 (3 dwords) sits in a 4-aligned class,
      // VReg_160 (5 dwords) in an 8-aligned class, etc. Pinning the
      // base to `next_power_of_two(width)` keeps the assembler happy
      // for the consumer ops, and matches `width` exactly for the
      // power-of-two widths the pipeline currently produces.
      unsigned align = std::max<unsigned>(1, llvm::PowerOf2Ceil(width));
      std::optional<unsigned> phys = findFreeSlot(live, width, align, numPhys);
      if (!phys) {
        if (softFail) {
          overflow = true;
          return success();
        }
        return func.emitError(
            "WaveAMDMachine register allocator ran out of registers");
      }
      for (auto [v, off] : llvm::zip(interval.values, interval.slotOffsets))
        setRegPhys(v, *phys + off);
      live.insert(PhysAlloc{*phys, width});
      active.push_back(interval);
      llvm::sort(active, [](const LiveInterval &lhs, const LiveInterval &rhs) {
        return lhs.end < rhs.end;
      });
    }
    return success();
  }

  // Walk the gaps between live allocations in `begin` order. For each
  // gap, check whether the requested width fits at `start`; if not,
  // advance `start` to the next `align`-aligned position past the
  // current allocation. After the last allocation, try the tail up to
  // `maxRegs`. Lifted from aster's `AllocConstraints::alloc`
  // (RegisterColoring.cpp:212-258).
  static std::optional<unsigned> findFreeSlot(const std::set<PhysAlloc> &live,
                                              unsigned width, unsigned align,
                                              unsigned maxRegs) {
    auto alignUp = [&](unsigned v) {
      return ((v + align - 1) / align) * align;
    };
    unsigned start = 0;
    for (const PhysAlloc &a : live) {
      if (start + width <= a.begin)
        return start;
      start = alignUp(a.end());
    }
    if (start + width <= maxRegs)
      return start;
    return std::nullopt;
  }
};

} // namespace
