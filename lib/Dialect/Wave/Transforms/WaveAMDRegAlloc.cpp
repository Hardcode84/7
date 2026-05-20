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
#include "mlir/Dialect/WaveMachine/IR/WaveMachine.h"
#include "mlir/IR/Builders.h"
#include "mlir/IR/BuiltinOps.h"
#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/DenseSet.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/MC/MCSubtargetInfo.h"
#include "llvm/MC/TargetRegistry.h"
#include "llvm/Support/TargetSelect.h"
#include "llvm/TargetParser/TargetParser.h"
#include "llvm/TargetParser/Triple.h"
#include <limits>
#include <optional>

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
  wavemachine::RegType type;         // block (class, width); index is filled
                                     // in at allocation time
  unsigned start = std::numeric_limits<unsigned>::max();
  unsigned end = 0;
};

struct RegisterLimits {
  unsigned numSGPR = 0;
  unsigned numVGPR = 0;
};

static bool isReg(Value value) {
  return isa<wavemachine::RegType>(value.getType());
}

static bool isSGPR(wavemachine::RegType type) {
  return type.getRegClass() == wavemachine::RegClass::SGPR;
}

static bool isVGPR(wavemachine::RegType type) {
  return type.getRegClass() == wavemachine::RegClass::VGPR;
}

// SCC is a single hardware bit; we don't allocate physical registers
// for it.
static bool isSCC(wavemachine::RegType type) {
  return type.getRegClass() == wavemachine::RegClass::SCC;
}

static void setRegPhys(Value v, unsigned phys) {
  auto rt = cast<wavemachine::RegType>(v.getType());
  v.setType(wavemachine::RegType::get(rt.getContext(), rt.getRegClass(),
                                      rt.getWidth(),
                                      static_cast<int64_t>(phys)));
}

static FailureOr<std::unique_ptr<llvm::MCSubtargetInfo>>
createSubtargetInfo(ModuleOp module) {
  auto targetAttr = module->getAttrOfType<StringAttr>("wavemachine.target");
  if (!targetAttr)
    return module.emitError("waveamd-reg-alloc requires a wavemachine.target "
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
  void runOnOperation() override {
    FailureOr<RegisterLimits> limits = getRegisterLimits(getOperation());
    if (failed(limits))
      return signalPassFailure();
    for (func::FuncOp func : getOperation().getOps<func::FuncOp>()) {
      if (failed(allocateFunction(func, *limits)))
        return signalPassFailure();
    }
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
    auto rt = cast<wavemachine::RegType>(v.getType());
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
    auto rt = dyn_cast<wavemachine::RegType>(primary.getType());
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
  std::optional<wavemachine::RegType> trackedRegType(Value v) {
    if (!isReg(v))
      return std::nullopt;
    auto rt = cast<wavemachine::RegType>(v.getType());
    if (isSCC(rt))
      return std::nullopt;
    return rt;
  }

  // Pick the interval bucket + lookup table matching the SGPR/VGPR
  // class of `rt`.
  std::pair<SmallVectorImpl<LiveInterval> *, DenseMap<Value, unsigned> *>
  intervalsFor(wavemachine::RegType rt, LiveIntervalSet &intervals) {
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
  LogicalResult coalesceLoopEntryCarries(wavemachine::UniformLoopOp loop,
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
  void coalesceLoopBackEdgeCarries(wavemachine::UniformLoopOp loop,
                                   LiveIntervalSet &intervals) {
    Block &body = loop.getBody().front();
    auto term = cast<wavemachine::ContinueIfOp>(body.getTerminator());
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
  void extendCarriesToLoopEnd(wavemachine::UniformLoopOp loop, unsigned endPos,
                              LiveIntervalSet &intervals) {
    for (Value init : loop.getInits())
      extendInterval(init, endPos, intervals);
  }

  // Process a uniform_loop op: coalesce entry carries, recurse into
  // the body, then coalesce the back-edge carries and extend the
  // carry intervals over the whole loop range.
  LogicalResult processLoop(wavemachine::UniformLoopOp loop, unsigned pos,
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
      if (auto loop = dyn_cast<wavemachine::UniformLoopOp>(op)) {
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
        cumOffset += cast<wavemachine::RegType>(element.getType()).getWidth();
      }
      return success();
    };
    if (auto toElems = dyn_cast<wavemachine::TupleToElementsOp>(op))
      return coalesceTupleElements(toElems);
    if (auto fromElems = dyn_cast<wavemachine::TupleFromElementsOp>(op))
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
    SmallVector<wavemachine::UniformLoopOp> loops;
    func.walk([&](wavemachine::UniformLoopOp loop) { loops.push_back(loop); });
    OpBuilder builder(func.getContext());
    for (wavemachine::UniformLoopOp loop : loops) {
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
    auto rt = cast<wavemachine::RegType>(v.getType());
    if (isVGPR(rt)) {
      wavemachine::RegType resultType = wavemachine::RegType::get(
          rt.getContext(), rt.getRegClass(), rt.getWidth(), /*index=*/-1);
      auto copy =
          wavemachine::VMovB32TupleOp::create(builder, loc, resultType, v);
      copy->setAttr("registers", builder.getI64IntegerAttr(rt.getWidth()));
      return copy.getResult();
    }
    if (isSGPR(rt) && rt.getWidth() == 1) {
      wavemachine::RegType resultType = wavemachine::RegType::get(
          rt.getContext(), rt.getRegClass(), /*width=*/1, /*index=*/-1);
      auto copy =
          wavemachine::SMovB32ValueOp::create(builder, loc, resultType, v);
      return copy.getResult();
    }
    return emitError(loc, "duplicateRegValue: unsupported register class / "
                          "width for duplicate iter_arg init");
  }

  // Each VGPR value used as a tuple element carries at most one slot
  // constraint: the cumulative dword offset it sits at within its
  // anchor tuple's physical block. `tuple_to_elements` anchors each
  // result at `sum(width[0..i-1])`; the first `tuple_from_elements`
  // to consume a value anchors it at the operand's cumulative offset.
  // Any subsequent use at a different offset, or any second
  // from_elements consuming a value already consumed by another,
  // must go through a fresh copy -- otherwise the coalescer would
  // merge two unrelated tuples and the other slots would clobber
  // each other.
  LogicalResult splitTupleElementSharing(func::FuncOp func) {
    OpBuilder builder(func.getContext());
    DenseMap<Value, unsigned> anchorSlot;
    DenseSet<Value> consumedByFromElements;
    func.walk([&](wavemachine::TupleToElementsOp op) {
      unsigned cumOffset = 0;
      for (Value element : op.getElements()) {
        anchorSlot[element] = cumOffset;
        cumOffset += cast<wavemachine::RegType>(element.getType()).getWidth();
      }
    });
    SmallVector<wavemachine::TupleFromElementsOp> ops;
    func.walk([&](wavemachine::TupleFromElementsOp op) { ops.push_back(op); });
    for (wavemachine::TupleFromElementsOp op : ops) {
      builder.setInsertionPoint(op);
      SmallVector<Value> newElements;
      newElements.reserve(op.getElements().size());
      bool changed = false;
      unsigned cumOffset = 0;
      for (Value element : op.getElements()) {
        unsigned slot = cumOffset;
        unsigned width =
            cast<wavemachine::RegType>(element.getType()).getWidth();
        Value use = element;
        auto anchorIt = anchorSlot.find(element);
        bool slotMismatch =
            anchorIt != anchorSlot.end() && anchorIt->second != slot;
        bool reuse = consumedByFromElements.contains(element);
        if (slotMismatch || reuse) {
          FailureOr<Value> dup =
              duplicateRegValue(builder, op.getLoc(), element);
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
    }
    return success();
  }

  LogicalResult allocateFunction(func::FuncOp func, RegisterLimits limits) {
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
    unsigned sgprReserved = func->hasAttr("wave.kernel") ? 5 : 0;
    unsigned vgprReserved = func->hasAttr("wave.kernel") ? 1 : 0;
    if (failed(
            allocateClass(func, intervals.sgprs, limits.numSGPR, sgprReserved)))
      return failure();
    return allocateClass(func, intervals.vgprs, limits.numVGPR, vgprReserved);
  }

  // Release every active interval whose end position is before `pos`,
  // freeing its physical register footprint in `used`.
  void expireOld(SmallVectorImpl<LiveInterval> &active,
                 SmallVectorImpl<bool> &used, unsigned pos) {
    SmallVector<LiveInterval> stillActive;
    for (LiveInterval interval : active) {
      if (interval.end >= pos) {
        stillActive.push_back(interval);
        continue;
      }
      auto rt = cast<wavemachine::RegType>(interval.values.front().getType());
      unsigned phys = rt.getIndex();
      unsigned width = rt.getWidth();
      for (unsigned i = 0; i != width; ++i)
        used[phys + i] = false;
    }
    active = std::move(stillActive);
  }

  LogicalResult allocateClass(func::FuncOp func,
                              MutableArrayRef<LiveInterval> intervals,
                              unsigned numPhys, unsigned reserved) {
    llvm::stable_sort(intervals,
                      [](const LiveInterval &lhs, const LiveInterval &rhs) {
                        return lhs.start < rhs.start;
                      });

    SmallVector<LiveInterval> active;
    SmallVector<bool> used(numPhys, false);
    for (unsigned i = 0; i != reserved && i != numPhys; ++i)
      used[i] = true;

    for (LiveInterval interval : intervals) {
      if (interval.values.empty())
        continue;
      expireOld(active, used, interval.start);
      unsigned width = interval.type.getWidth();
      std::optional<unsigned> phys =
          findFreeContiguous(used, width, /*align=*/width);
      if (!phys)
        return func.emitError(
            "WaveMachine register allocator ran out of registers");
      for (auto [v, off] : llvm::zip(interval.values, interval.slotOffsets))
        setRegPhys(v, *phys + off);
      for (unsigned i = 0; i != width; ++i)
        used[*phys + i] = true;
      active.push_back(interval);
      llvm::sort(active, [](const LiveInterval &lhs, const LiveInterval &rhs) {
        return lhs.end < rhs.end;
      });
    }
    return success();
  }

  static std::optional<unsigned>
  findFreeContiguous(ArrayRef<bool> used, unsigned width, unsigned align) {
    for (unsigned i = 0, e = used.size(); i + width <= e; ++i) {
      if (i % align)
        continue;
      bool allFree = true;
      for (unsigned j = 0; j != width; ++j) {
        if (used[i + j]) {
          allFree = false;
          break;
        }
      }
      if (allFree)
        return i;
    }
    return std::nullopt;
  }
};

} // namespace
