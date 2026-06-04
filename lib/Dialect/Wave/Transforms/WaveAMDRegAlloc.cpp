//===- WaveAMDRegAlloc.cpp - WaveAMD register allocation --------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/Wave/Transforms/Passes.h"

#include "WaveAMDHardwareResources.h"
#include "WaveAMDRegAllocPrep.h"
#include "WaveAMDRegLiveIntervals.h"
#include "WaveAMDRegisterLimits.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/Wave/Transforms/WaveAMDRegAllocVerification.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachine.h"
#include "mlir/IR/Builders.h"
#include "mlir/IR/BuiltinOps.h"
#include "llvm/ADT/DenseSet.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/Support/MathExtras.h"
#include "llvm/Support/raw_ostream.h"
#include <optional>
#include <set>

namespace mlir::wave {
#define GEN_PASS_DEF_WAVEAMDREGALLOC
#include "mlir/Dialect/Wave/Transforms/Passes.h.inc"
} // namespace mlir::wave

using namespace mlir;

namespace {

struct RegisterLimits {
  unsigned numSGPR = 0;
  unsigned numVGPR = 0;
  unsigned numAGPR = 0;
};

static constexpr llvm::StringLiteral kPressureClassAttr =
    "waveamdmachine.regalloc_pressure_class";
static constexpr llvm::StringLiteral kPressureLimitAttr =
    "waveamdmachine.regalloc_pressure_limit";
static constexpr llvm::StringLiteral kPressureLiveDwordsAttr =
    "waveamdmachine.regalloc_pressure_live_dwords";
static constexpr llvm::StringLiteral kPressureOverlapsAttr =
    "waveamdmachine.regalloc_pressure_overlaps";
static constexpr llvm::StringLiteral kPressurePositionAttr =
    "waveamdmachine.regalloc_pressure_position";
static constexpr llvm::StringLiteral kPressureReliefAttr =
    "waveamdmachine.regalloc_pressure_required_relief";
static constexpr llvm::StringLiteral kPressureRequestAttr =
    "waveamdmachine.regalloc_pressure_request";
static constexpr llvm::StringLiteral kPressureReservedAttr =
    "waveamdmachine.regalloc_pressure_reserved";
static constexpr llvm::StringLiteral kAGPRCandidatesAttr =
    "waveamdmachine.regalloc_agpr_candidates";

static void setRegPhys(Value v, unsigned phys) {
  auto rt = cast<waveamdmachine::RegType>(v.getType());
  v.setType(waveamdmachine::RegType::get(rt.getContext(), rt.getRegClass(),
                                         rt.getWidth(),
                                         static_cast<int64_t>(phys)));
}

static FailureOr<RegisterLimits> getRegisterLimits(ModuleOp module) {
  if (!module->hasAttr("waveamdmachine.target"))
    return module.emitError(
        "waveamd-reg-alloc requires a waveamdmachine.target attribute");
  FailureOr<wave::WaveAMDRegisterLimits> targetLimits =
      wave::getWaveAMDRegisterLimits(module);
  if (failed(targetLimits))
    return failure();

  RegisterLimits limits;
  limits.numSGPR = targetLimits->addressableSGPRs;
  limits.numVGPR = targetLimits->addressableVGPRs;
  limits.numAGPR = targetLimits->addressableAGPRs;
  return limits;
}

static LogicalResult validateReservedLimit(func::FuncOp func, StringRef cls,
                                           unsigned numPhys,
                                           unsigned reserved) {
  if (numPhys >= reserved)
    return success();
  return func.emitError()
         << "waveamd-reg-alloc " << cls
         << " limit leaves fewer registers than reserved kernel ABI prefix "
         << "(available=" << numPhys << ", reserved=" << reserved << ")";
}

static bool hasLiveIntervals(ArrayRef<wave::WaveAMDLiveInterval> intervals) {
  return llvm::any_of(intervals, [](const wave::WaveAMDLiveInterval &interval) {
    return !interval.values.empty();
  });
}

struct PressureIntervalRef {
  SmallVector<int64_t> resultIndices;
  SmallVector<int64_t> slotOffsets;
  SmallVector<int64_t> valuePositions;
  unsigned start = 0;
  unsigned end = 0;
  unsigned width = 0;
};

struct AGPRConversionCandidate {
  SmallVector<PressureIntervalRef> intervals;
  unsigned agprDwords = 0;
  unsigned bridgeCount = 0;
  unsigned overlapDwords = 0;
  unsigned order = 0;
  unsigned reliefDwords = 0;
};

struct RegisterPressurePoint {
  SmallVector<AGPRConversionCandidate> agprCandidates;
  SmallVector<PressureIntervalRef> overlaps;
  PressureIntervalRef request;
  StringRef regClass;
  unsigned limit = 0;
  unsigned liveDwords = 0;
  unsigned position = 0;
  unsigned requiredRelief = 0;
  unsigned reserved = 0;
};

struct WaveAMDRegAllocPass
    : public wave::impl::WaveAMDRegAllocBase<WaveAMDRegAllocPass> {
  using WaveAMDRegAllocBase::WaveAMDRegAllocBase;

  void runOnOperation() override {
    FailureOr<RegisterLimits> limits = getRegisterLimits(getOperation());
    if (failed(limits))
      return signalPassFailure();
    applyLimitOverrides(*limits);

    Builder builder(&getContext());
    int64_t overflowedCount = 0;
    getOperation()->removeAttr(
        wave::getWaveAMDRegAllocOverflowedCountAttrName());
    for (func::FuncOp func : collectFunctions())
      if (failed(processFunction(func, *limits, builder, overflowedCount)))
        return signalPassFailure();

    if (markOverflow)
      getOperation()->setAttr(wave::getWaveAMDRegAllocOverflowedCountAttrName(),
                              builder.getI64IntegerAttr(overflowedCount));
  }

  void applyLimitOverrides(RegisterLimits &limits) {
    if (vgprLimitOverride >= 0)
      limits.numVGPR =
          std::min(limits.numVGPR, static_cast<unsigned>(vgprLimitOverride));
    if (sgprLimitOverride >= 0)
      limits.numSGPR =
          std::min(limits.numSGPR, static_cast<unsigned>(sgprLimitOverride));
  }

  SmallVector<func::FuncOp> collectFunctions() {
    SmallVector<func::FuncOp> funcs;
    getOperation().walk([&](func::FuncOp f) {
      if (!f.isExternal())
        funcs.push_back(f);
    });
    return funcs;
  }

  LogicalResult processFunction(func::FuncOp func, RegisterLimits limits,
                                Builder &builder, int64_t &overflowedCount) {
    bool overflow = false;
    std::optional<RegisterPressurePoint> pressure;
    clearOverflowAttrs(func);
    if (failed(
            allocateFunction(func, limits, markOverflow, overflow, pressure)))
      return failure();
    if (overflow) {
      markOverflowed(func, pressure, builder);
      ++overflowedCount;
      return success();
    }
    return wave::verifyWaveAMDRegAllocation(
        func, "waveamd-reg-alloc",
        wave::WaveAMDRegAllocVerificationScope::Results);
  }

  static void
  markOverflowed(func::FuncOp func,
                 const std::optional<RegisterPressurePoint> &pressure,
                 Builder &builder) {
    func->setAttr(wave::getWaveAMDRegAllocOverflowedAttrName(),
                  builder.getI64IntegerAttr(1));
    if (pressure)
      setPressureAttrs(func, *pressure, builder);
  }

  LogicalResult
  allocateFunction(func::FuncOp func, RegisterLimits limits, bool softFail,
                   bool &overflow,
                   std::optional<RegisterPressurePoint> &pressure) {
    if (failed(wave::prepareWaveAMDRegAllocIR(func)))
      return failure();
    if (failed(wave::verifyNoHardwareResourceLiveRangeOverlap(
            func, "waveamd-reg-alloc")))
      return failure();
    FailureOr<wave::WaveAMDLiveIntervalBuildResult> builtIntervals =
        wave::buildWaveAMDLiveIntervals(func);
    if (failed(builtIntervals))
      return failure();
    wave::WaveAMDLiveIntervalSet &intervals = builtIntervals->intervals;

    unsigned sgprReserved = wave::getWaveAMDReservedSGPRs(func);
    unsigned vgprReserved = wave::getWaveAMDReservedVGPRs(func);
    if (failed(
            validateReservedLimits(func, limits, sgprReserved, vgprReserved)))
      return failure();
    if (limits.numAGPR == 0 && hasLiveIntervals(intervals.agprs))
      return func.emitError(
          "waveamd-reg-alloc AGPR registers require target with AGPR support");
    return allocateRegisterClasses(func, intervals, limits, sgprReserved,
                                   vgprReserved, softFail, overflow, pressure,
                                   builtIntervals->positions);
  }

  LogicalResult validateReservedLimits(func::FuncOp func, RegisterLimits limits,
                                       unsigned sgprReserved,
                                       unsigned vgprReserved) {
    if (failed(
            validateReservedLimit(func, "SGPR", limits.numSGPR, sgprReserved)))
      return failure();
    return validateReservedLimit(func, "VGPR", limits.numVGPR, vgprReserved);
  }

  LogicalResult
  allocateRegisterClasses(func::FuncOp func,
                          wave::WaveAMDLiveIntervalSet &intervals,
                          RegisterLimits limits, unsigned sgprReserved,
                          unsigned vgprReserved, bool softFail, bool &overflow,
                          std::optional<RegisterPressurePoint> &pressure,
                          const DenseMap<Operation *, unsigned> &positions) {
    if (failed(allocateClass(func, intervals.sgprs, limits.numSGPR,
                             sgprReserved, softFail, overflow, pressure,
                             positions, "SGPR", intervals.agprs,
                             /*agprCandidateLimit=*/0)))
      return failure();
    if (overflow)
      return success();
    unsigned agprCandidateLimit = rankAgprCandidates ? limits.numAGPR : 0;
    if (failed(allocateClass(func, intervals.vgprs, limits.numVGPR,
                             vgprReserved, softFail, overflow, pressure,
                             positions, "VGPR", intervals.agprs,
                             agprCandidateLimit)))
      return failure();
    if (overflow)
      return success();
    return allocateClass(func, intervals.agprs, limits.numAGPR, /*reserved=*/0,
                         softFail, overflow, pressure, positions, "AGPR",
                         intervals.agprs, /*agprCandidateLimit=*/0);
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
  void expireOld(SmallVectorImpl<wave::WaveAMDLiveInterval> &active,
                 std::set<PhysAlloc> &live, unsigned pos) {
    SmallVector<wave::WaveAMDLiveInterval> stillActive;
    for (wave::WaveAMDLiveInterval interval : active) {
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

  LogicalResult handleAllocationFailure(
      func::FuncOp func, MutableArrayRef<wave::WaveAMDLiveInterval> intervals,
      const wave::WaveAMDLiveInterval &request,
      ArrayRef<wave::WaveAMDLiveInterval> active,
      const std::set<PhysAlloc> &live, unsigned numPhys, unsigned reserved,
      bool softFail, bool &overflow,
      std::optional<RegisterPressurePoint> &pressure,
      const DenseMap<Operation *, unsigned> &positions, StringRef regClass,
      ArrayRef<wave::WaveAMDLiveInterval> agprIntervals,
      unsigned agprCandidateLimit) {
    if (!pressure)
      pressure = buildPressurePoint(regClass, request, active, live, positions,
                                    request.start, numPhys, reserved);
    if (agprCandidateLimit > 0 && regClass == "VGPR")
      pressure->agprCandidates =
          buildAGPRCandidates(intervals, active, request, agprIntervals,
                              positions, request.start, agprCandidateLimit);
    if (softFail) {
      overflow = true;
      return success();
    }
    InFlightDiagnostic diag =
        func.emitError() << "WaveAMDMachine register allocator ran "
                            "out of "
                         << regClass << " registers at position "
                         << pressure->position << " (limit=" << pressure->limit
                         << ", live_dwords=" << pressure->liveDwords
                         << ", required_relief=" << pressure->requiredRelief
                         << ")";
    diag << "; request=" << formatInterval(pressure->request)
         << "; overlaps=" << formatIntervals(pressure->overlaps);
    return failure();
  }

  LogicalResult allocateClass(
      func::FuncOp func, MutableArrayRef<wave::WaveAMDLiveInterval> intervals,
      unsigned numPhys, unsigned reserved, bool softFail, bool &overflow,
      std::optional<RegisterPressurePoint> &pressure,
      const DenseMap<Operation *, unsigned> &positions, StringRef regClass,
      ArrayRef<wave::WaveAMDLiveInterval> agprIntervals,
      unsigned agprCandidateLimit) {
    llvm::stable_sort(intervals, [](const wave::WaveAMDLiveInterval &lhs,
                                    const wave::WaveAMDLiveInterval &rhs) {
      return lhs.start < rhs.start;
    });

    SmallVector<wave::WaveAMDLiveInterval> active;
    // Mirrors aster's gap-walking constraint set: reserved registers
    // pre-occupy `[0, reserved)`.
    std::set<PhysAlloc> live;
    if (reserved > 0 && reserved <= numPhys)
      live.insert(PhysAlloc{0, reserved});

    for (wave::WaveAMDLiveInterval interval : intervals) {
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
      if (!phys)
        return handleAllocationFailure(func, intervals, interval, active, live,
                                       numPhys, reserved, softFail, overflow,
                                       pressure, positions, regClass,
                                       agprIntervals, agprCandidateLimit);
      for (auto [v, off] : llvm::zip(interval.values, interval.slotOffsets))
        setRegPhys(v, *phys + off);
      live.insert(PhysAlloc{*phys, width});
      active.push_back(interval);
      llvm::sort(active, [](const wave::WaveAMDLiveInterval &lhs,
                            const wave::WaveAMDLiveInterval &rhs) {
        return lhs.end < rhs.end;
      });
    }
    return success();
  }

  // Walk the gaps between live allocations in `begin` order. For each
  // gap, check whether the requested width fits at `start`; if not,
  // advance `start` to the next `align`-aligned position past the
  // current allocation. After the last allocation, try the tail up to
  // `maxRegs`.
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

  static bool intervalContains(const wave::WaveAMDLiveInterval &interval,
                               unsigned position) {
    return interval.start <= position && position <= interval.end;
  }

  static bool intervalsOverlap(const wave::WaveAMDLiveInterval &lhs,
                               const wave::WaveAMDLiveInterval &rhs) {
    return lhs.start <= rhs.end && rhs.start <= lhs.end;
  }

  static DenseMap<Value, unsigned>
  buildValueIntervalMap(ArrayRef<wave::WaveAMDLiveInterval> intervals) {
    DenseMap<Value, unsigned> valueToInterval;
    for (auto [index, interval] : llvm::enumerate(intervals))
      for (Value value : interval.values)
        valueToInterval[value] = index;
    return valueToInterval;
  }

  static void addIntervalByValue(
      Value value, const DenseMap<Value, unsigned> &valueToInterval,
      llvm::DenseSet<unsigned> &seen, SmallVectorImpl<unsigned> &worklist) {
    auto it = valueToInterval.find(value);
    if (it == valueToInterval.end())
      return;
    if (seen.insert(it->second).second)
      worklist.push_back(it->second);
  }

  static bool isMFMA(Operation *op) {
    return op && op->hasTrait<OpTrait::waveamdmachine::MFMAOp>();
  }

  static bool isMFMAResult(Value value) {
    Operation *def = value.getDefiningOp();
    return isMFMA(def) && def->getNumResults() == 1 &&
           value == def->getResult(0);
  }

  static bool isTupleRename(Operation *op) {
    return isa_and_nonnull<waveamdmachine::TupleFromElementsOp,
                           waveamdmachine::TupleToElementsOp>(op);
  }

  static bool
  allRegisterEndpointsInGroup(Operation *op,
                              const llvm::DenseSet<Value> &groupValues) {
    for (Value operand : op->getOperands())
      if (isa<waveamdmachine::RegType>(operand.getType()) &&
          !groupValues.contains(operand))
        return false;
    for (Value result : op->getResults())
      if (isa<waveamdmachine::RegType>(result.getType()) &&
          !groupValues.contains(result))
        return false;
    return true;
  }

  static void collectMFMAAccumulatorClosure(
      unsigned seed, ArrayRef<wave::WaveAMDLiveInterval> intervals,
      const DenseMap<Value, unsigned> &valueToInterval,
      SmallVectorImpl<unsigned> &group) {
    llvm::DenseSet<unsigned> seen;
    SmallVector<unsigned> worklist;
    seen.insert(seed);
    worklist.push_back(seed);

    while (!worklist.empty()) {
      unsigned intervalIndex = worklist.pop_back_val();
      group.push_back(intervalIndex);
      for (Value value : intervals[intervalIndex].values) {
        if (isMFMAResult(value))
          addIntervalByValue(value.getDefiningOp()->getOperand(2),
                             valueToInterval, seen, worklist);
        for (OpOperand &use : value.getUses()) {
          Operation *user = use.getOwner();
          if (isMFMA(user) && use.getOperandNumber() == 2 &&
              user->getNumResults() == 1)
            addIntervalByValue(user->getResult(0), valueToInterval, seen,
                               worklist);
        }
      }
    }
    llvm::sort(group);
  }

  static bool hasGroup(ArrayRef<SmallVector<unsigned>> groups,
                       ArrayRef<unsigned> candidate) {
    return llvm::any_of(
        groups, [&](ArrayRef<unsigned> group) { return group == candidate; });
  }

  static llvm::DenseSet<Value>
  collectGroupValues(ArrayRef<unsigned> group,
                     ArrayRef<wave::WaveAMDLiveInterval> intervals) {
    llvm::DenseSet<Value> values;
    for (unsigned intervalIndex : group)
      for (Value value : intervals[intervalIndex].values)
        values.insert(value);
    return values;
  }

  static bool canDefineAGPR(Value value,
                            const llvm::DenseSet<Value> &groupValues) {
    Operation *def = value.getDefiningOp();
    if (!def)
      return false;
    if (isa<waveamdmachine::UninitOp>(def))
      return true;
    if (isTupleRename(def))
      return allRegisterEndpointsInGroup(def, groupValues);
    if (isMFMA(def) && def->getNumResults() == 1 && value == def->getResult(0))
      return def->getNumOperands() > 2 &&
             groupValues.contains(def->getOperand(2));
    return false;
  }

  static bool canConsumeAGPR(OpOperand &use,
                             const llvm::DenseSet<Value> &groupValues) {
    Operation *user = use.getOwner();
    unsigned operandNumber = use.getOperandNumber();
    if (isMFMA(user)) {
      if (operandNumber < 2)
        return true;
      if (operandNumber == 2 && user->getNumResults() == 1)
        return groupValues.contains(user->getResult(0));
      return false;
    }
    if (isa<waveamdmachine::VAccvgprReadB32TupleOp>(user) && operandNumber == 0)
      return true;
    if (isTupleRename(user))
      return allRegisterEndpointsInGroup(user, groupValues);
    return false;
  }

  static unsigned
  countAGPRBridgeBoundaries(ArrayRef<unsigned> group,
                            ArrayRef<wave::WaveAMDLiveInterval> intervals) {
    llvm::DenseSet<Value> groupValues = collectGroupValues(group, intervals);
    unsigned bridges = 0;
    for (unsigned intervalIndex : group) {
      for (Value value : intervals[intervalIndex].values) {
        if (!canDefineAGPR(value, groupValues))
          ++bridges;
        for (OpOperand &use : value.getUses())
          if (!canConsumeAGPR(use, groupValues))
            ++bridges;
      }
    }
    return bridges;
  }

  static unsigned liveDwordsAt(ArrayRef<unsigned> group,
                               ArrayRef<wave::WaveAMDLiveInterval> intervals,
                               unsigned position) {
    unsigned dwords = 0;
    for (unsigned intervalIndex : group)
      if (intervalContains(intervals[intervalIndex], position))
        dwords += intervals[intervalIndex].type.getWidth();
    return dwords;
  }

  static unsigned liveDwordsAt(ArrayRef<wave::WaveAMDLiveInterval> intervals,
                               unsigned position) {
    unsigned dwords = 0;
    for (const wave::WaveAMDLiveInterval &interval : intervals)
      if (intervalContains(interval, position))
        dwords += interval.type.getWidth();
    return dwords;
  }

  static unsigned
  maxGroupLiveDwords(ArrayRef<unsigned> group,
                     ArrayRef<wave::WaveAMDLiveInterval> intervals) {
    unsigned maxDwords = 0;
    for (unsigned intervalIndex : group) {
      const wave::WaveAMDLiveInterval &interval = intervals[intervalIndex];
      maxDwords =
          std::max(maxDwords, liveDwordsAt(group, intervals, interval.start));
      maxDwords =
          std::max(maxDwords, liveDwordsAt(group, intervals, interval.end));
    }
    return maxDwords;
  }

  static unsigned overlapDwords(ArrayRef<unsigned> group,
                                ArrayRef<wave::WaveAMDLiveInterval> intervals) {
    unsigned overlap = 0;
    for (unsigned intervalIndex : group) {
      const wave::WaveAMDLiveInterval &interval = intervals[intervalIndex];
      overlap += interval.type.getWidth() * (interval.end - interval.start + 1);
    }
    return overlap;
  }

  static bool fitsAGPRSpace(ArrayRef<unsigned> group,
                            ArrayRef<wave::WaveAMDLiveInterval> vgprs,
                            ArrayRef<wave::WaveAMDLiveInterval> agprs,
                            unsigned agprLimit) {
    if (maxGroupLiveDwords(group, vgprs) > agprLimit)
      return false;

    SmallVector<unsigned> points;
    for (unsigned intervalIndex : group) {
      points.push_back(vgprs[intervalIndex].start);
      points.push_back(vgprs[intervalIndex].end);
    }
    for (const wave::WaveAMDLiveInterval &agpr : agprs) {
      bool overlapsGroup = llvm::any_of(group, [&](unsigned intervalIndex) {
        return intervalsOverlap(agpr, vgprs[intervalIndex]);
      });
      if (!overlapsGroup)
        continue;
      points.push_back(agpr.start);
      points.push_back(agpr.end);
    }
    llvm::sort(points);
    points.erase(std::unique(points.begin(), points.end()), points.end());

    return llvm::all_of(points, [&](unsigned position) {
      return liveDwordsAt(group, vgprs, position) +
                 liveDwordsAt(agprs, position) <=
             agprLimit;
    });
  }

  static AGPRConversionCandidate
  buildAGPRCandidate(ArrayRef<unsigned> group,
                     ArrayRef<wave::WaveAMDLiveInterval> intervals,
                     const DenseMap<Operation *, unsigned> &positions,
                     unsigned pressurePosition, unsigned order) {
    AGPRConversionCandidate candidate;
    candidate.order = order;
    candidate.bridgeCount = countAGPRBridgeBoundaries(group, intervals);
    candidate.reliefDwords = liveDwordsAt(group, intervals, pressurePosition);
    candidate.overlapDwords = overlapDwords(group, intervals);
    candidate.agprDwords = maxGroupLiveDwords(group, intervals);
    for (unsigned intervalIndex : group)
      candidate.intervals.push_back(
          buildIntervalRef(intervals[intervalIndex], positions));
    return candidate;
  }

  static bool betterAGPRCandidate(const AGPRConversionCandidate &lhs,
                                  const AGPRConversionCandidate &rhs) {
    if (lhs.bridgeCount != rhs.bridgeCount)
      return lhs.bridgeCount < rhs.bridgeCount;
    if (lhs.reliefDwords != rhs.reliefDwords)
      return lhs.reliefDwords > rhs.reliefDwords;
    if (lhs.overlapDwords != rhs.overlapDwords)
      return lhs.overlapDwords > rhs.overlapDwords;
    if (lhs.agprDwords != rhs.agprDwords)
      return lhs.agprDwords < rhs.agprDwords;
    return lhs.order < rhs.order;
  }

  static SmallVector<AGPRConversionCandidate>
  buildAGPRCandidates(ArrayRef<wave::WaveAMDLiveInterval> intervals,
                      ArrayRef<wave::WaveAMDLiveInterval> active,
                      const wave::WaveAMDLiveInterval &request,
                      ArrayRef<wave::WaveAMDLiveInterval> agprIntervals,
                      const DenseMap<Operation *, unsigned> &positions,
                      unsigned pressurePosition, unsigned agprLimit) {
    DenseMap<Value, unsigned> valueToInterval =
        buildValueIntervalMap(intervals);
    SmallVector<SmallVector<unsigned>> groups;
    auto addSeed = [&](const wave::WaveAMDLiveInterval &interval) {
      if (interval.values.empty())
        return;
      auto it = valueToInterval.find(interval.values.front());
      if (it == valueToInterval.end())
        return;
      SmallVector<unsigned> group;
      collectMFMAAccumulatorClosure(it->second, intervals, valueToInterval,
                                    group);
      if (!hasGroup(groups, group))
        groups.push_back(std::move(group));
    };

    for (const wave::WaveAMDLiveInterval &interval : active)
      addSeed(interval);
    addSeed(request);

    SmallVector<AGPRConversionCandidate> candidates;
    for (auto [order, group] : llvm::enumerate(groups)) {
      if (!fitsAGPRSpace(group, intervals, agprIntervals, agprLimit))
        continue;
      candidates.push_back(buildAGPRCandidate(group, intervals, positions,
                                              pressurePosition, order));
    }
    llvm::stable_sort(candidates, betterAGPRCandidate);
    return candidates;
  }

  static void clearOverflowAttrs(func::FuncOp func) {
    func->removeAttr(wave::getWaveAMDRegAllocOverflowedAttrName());
    func->removeAttr(kPressureClassAttr);
    func->removeAttr(kPressureLimitAttr);
    func->removeAttr(kPressureLiveDwordsAttr);
    func->removeAttr(kPressureOverlapsAttr);
    func->removeAttr(kPressurePositionAttr);
    func->removeAttr(kPressureReliefAttr);
    func->removeAttr(kPressureRequestAttr);
    func->removeAttr(kPressureReservedAttr);
    func->removeAttr(kAGPRCandidatesAttr);
  }

  static unsigned
  valuePosition(Value value, const DenseMap<Operation *, unsigned> &positions,
                unsigned fallback) {
    if (Operation *def = value.getDefiningOp())
      return positions.lookup(def);
    return fallback;
  }

  static int64_t resultIndex(Value value) {
    if (auto result = dyn_cast<OpResult>(value))
      return result.getResultNumber();
    return -1;
  }

  static PressureIntervalRef
  buildIntervalRef(const wave::WaveAMDLiveInterval &interval,
                   const DenseMap<Operation *, unsigned> &positions) {
    PressureIntervalRef ref;
    ref.start = interval.start;
    ref.end = interval.end;
    ref.width = interval.type.getWidth();
    for (auto [value, slot] :
         llvm::zip(interval.values, interval.slotOffsets)) {
      ref.valuePositions.push_back(valuePosition(value, positions, ref.start));
      ref.resultIndices.push_back(resultIndex(value));
      ref.slotOffsets.push_back(slot);
    }
    return ref;
  }

  static unsigned liveDwords(const std::set<PhysAlloc> &live) {
    unsigned dwords = 0;
    for (const PhysAlloc &alloc : live)
      dwords += alloc.size;
    return dwords;
  }

  static unsigned estimateRelief(unsigned liveWidth, unsigned requestWidth,
                                 unsigned limit) {
    if (liveWidth + requestWidth > limit)
      return liveWidth + requestWidth - limit;
    return 1;
  }

  static RegisterPressurePoint
  buildPressurePoint(StringRef regClass,
                     const wave::WaveAMDLiveInterval &request,
                     ArrayRef<wave::WaveAMDLiveInterval> active,
                     const std::set<PhysAlloc> &live,
                     const DenseMap<Operation *, unsigned> &positions,
                     unsigned position, unsigned limit, unsigned reserved) {
    RegisterPressurePoint point;
    point.regClass = regClass;
    point.limit = limit;
    point.liveDwords = liveDwords(live);
    point.position = position;
    point.request = buildIntervalRef(request, positions);
    point.requiredRelief =
        estimateRelief(point.liveDwords, point.request.width, limit);
    point.reserved = reserved;

    for (const wave::WaveAMDLiveInterval &interval : active)
      point.overlaps.push_back(buildIntervalRef(interval, positions));
    llvm::stable_sort(point.overlaps, [](const PressureIntervalRef &lhs,
                                         const PressureIntervalRef &rhs) {
      if (lhs.start != rhs.start)
        return lhs.start < rhs.start;
      if (lhs.end != rhs.end)
        return lhs.end < rhs.end;
      if (lhs.width != rhs.width)
        return lhs.width < rhs.width;
      return std::lexicographical_compare(
          lhs.valuePositions.begin(), lhs.valuePositions.end(),
          rhs.valuePositions.begin(), rhs.valuePositions.end());
    });
    return point;
  }

  static DictionaryAttr intervalAttr(Builder &builder,
                                     const PressureIntervalRef &interval) {
    return builder.getDictionaryAttr({
        builder.getNamedAttr("end", builder.getI64IntegerAttr(interval.end)),
        builder.getNamedAttr("result_indices", builder.getDenseI64ArrayAttr(
                                                   interval.resultIndices)),
        builder.getNamedAttr(
            "slot_offsets", builder.getDenseI64ArrayAttr(interval.slotOffsets)),
        builder.getNamedAttr("start",
                             builder.getI64IntegerAttr(interval.start)),
        builder.getNamedAttr("value_positions", builder.getDenseI64ArrayAttr(
                                                    interval.valuePositions)),
        builder.getNamedAttr("width",
                             builder.getI64IntegerAttr(interval.width)),
    });
  }

  static ArrayAttr intervalArrayAttr(Builder &builder,
                                     ArrayRef<PressureIntervalRef> intervals) {
    SmallVector<Attribute> attrs;
    for (const PressureIntervalRef &interval : intervals)
      attrs.push_back(intervalAttr(builder, interval));
    return builder.getArrayAttr(attrs);
  }

  static DictionaryAttr
  candidateAttr(Builder &builder, const AGPRConversionCandidate &candidate) {
    return builder.getDictionaryAttr({
        builder.getNamedAttr("agpr_dwords",
                             builder.getI64IntegerAttr(candidate.agprDwords)),
        builder.getNamedAttr("bridge_count",
                             builder.getI64IntegerAttr(candidate.bridgeCount)),
        builder.getNamedAttr("intervals",
                             intervalArrayAttr(builder, candidate.intervals)),
        builder.getNamedAttr("overlap_dwords", builder.getI64IntegerAttr(
                                                   candidate.overlapDwords)),
        builder.getNamedAttr("relief_dwords",
                             builder.getI64IntegerAttr(candidate.reliefDwords)),
    });
  }

  static ArrayAttr
  candidateArrayAttr(Builder &builder,
                     ArrayRef<AGPRConversionCandidate> candidates) {
    SmallVector<Attribute> attrs;
    for (const AGPRConversionCandidate &candidate : candidates)
      attrs.push_back(candidateAttr(builder, candidate));
    return builder.getArrayAttr(attrs);
  }

  static void setPressureAttrs(func::FuncOp func,
                               const RegisterPressurePoint &pressure,
                               Builder &builder) {
    func->setAttr(kPressureClassAttr, builder.getStringAttr(pressure.regClass));
    func->setAttr(kPressureLimitAttr,
                  builder.getI64IntegerAttr(pressure.limit));
    func->setAttr(kPressureLiveDwordsAttr,
                  builder.getI64IntegerAttr(pressure.liveDwords));
    func->setAttr(kPressureOverlapsAttr,
                  intervalArrayAttr(builder, pressure.overlaps));
    func->setAttr(kPressurePositionAttr,
                  builder.getI64IntegerAttr(pressure.position));
    func->setAttr(kPressureReliefAttr,
                  builder.getI64IntegerAttr(pressure.requiredRelief));
    func->setAttr(kPressureRequestAttr,
                  intervalAttr(builder, pressure.request));
    func->setAttr(kPressureReservedAttr,
                  builder.getI64IntegerAttr(pressure.reserved));
    if (!pressure.agprCandidates.empty())
      func->setAttr(kAGPRCandidatesAttr,
                    candidateArrayAttr(builder, pressure.agprCandidates));
  }

  static std::string formatInterval(const PressureIntervalRef &interval) {
    std::string out;
    llvm::raw_string_ostream os(out);
    os << "{start=" << interval.start << ", end=" << interval.end
       << ", width=" << interval.width << ", values=[";
    llvm::interleaveComma(llvm::seq<size_t>(0, interval.valuePositions.size()),
                          os, [&](size_t i) {
                            os << interval.valuePositions[i] << "."
                               << interval.resultIndices[i] << "+"
                               << interval.slotOffsets[i];
                          });
    os << "]}";
    return out;
  }

  static std::string formatIntervals(ArrayRef<PressureIntervalRef> intervals) {
    std::string out;
    llvm::raw_string_ostream os(out);
    os << "[";
    llvm::interleaveComma(intervals, os,
                          [&](const PressureIntervalRef &interval) {
                            os << formatInterval(interval);
                          });
    os << "]";
    return out;
  }
};

} // namespace
