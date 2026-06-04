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
  waveamdmachine::RegType rt = cast<waveamdmachine::RegType>(v.getType());
  v.setType(waveamdmachine::RegType::get(rt.getContext(), rt.getRegClass(),
                                         rt.getWidth(),
                                         static_cast<int64_t>(phys)));
}

static waveamdmachine::RegType
getVirtualRegType(Value v, waveamdmachine::RegClass regClass) {
  waveamdmachine::RegType rt = cast<waveamdmachine::RegType>(v.getType());
  return waveamdmachine::RegType::get(rt.getContext(), regClass, rt.getWidth(),
                                      /*index=*/-1);
}

static void setRegClass(Value v, waveamdmachine::RegClass regClass) {
  v.setType(getVirtualRegType(v, regClass));
}

static bool isVirtualVGPRValue(Value value) {
  waveamdmachine::RegType regType =
      dyn_cast<waveamdmachine::RegType>(value.getType());
  return regType && regType.getRegClass() == waveamdmachine::RegClass::VGPR &&
         regType.getIndex() < 0;
}

static unsigned countVirtualVGPRValues(Operation *op) {
  unsigned count = 0;
  for (Value result : op->getResults())
    if (isVirtualVGPRValue(result))
      ++count;
  for (Region &region : op->getRegions()) {
    for (Block &block : region) {
      for (BlockArgument arg : block.getArguments())
        if (isVirtualVGPRValue(arg))
          ++count;
      for (Operation &nested : block)
        count += countVirtualVGPRValues(&nested);
    }
  }
  return count;
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
  SmallVector<PressureIntervalRef, 2> intervals;
  SmallVector<Value, 4> values;
  unsigned agprDwords = 0;
  unsigned bridgeCount = 0;
  unsigned overlapDwords = 0;
  unsigned order = 0;
  unsigned reliefDwords = 0;
};

struct RegisterPressurePoint {
  SmallVector<AGPRConversionCandidate, 4> agprCandidates;
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

  LogicalResult finishUnrelievedOverflow(
      func::FuncOp func, bool softFail, bool &overflow,
      const std::optional<RegisterPressurePoint> &pressure) {
    if (softFail) {
      overflow = true;
      return success();
    }
    if (!pressure)
      return func.emitError("waveamd-reg-alloc overflowed without pressure "
                            "diagnostics");
    InFlightDiagnostic diag =
        func.emitError()
        << "waveamd-reg-alloc could not find a legal AGPR bank-spill "
           "candidate for "
        << pressure->regClass << " pressure at position " << pressure->position
        << " (limit=" << pressure->limit
        << ", live_dwords=" << pressure->liveDwords
        << ", required_relief=" << pressure->requiredRelief << ")";
    diag << "; request=" << formatInterval(pressure->request)
         << "; overlaps=" << formatIntervals(pressure->overlaps);
    return failure();
  }

  LogicalResult
  finishAGPRProgressBound(func::FuncOp func, bool softFail, bool &overflow,
                          const std::optional<RegisterPressurePoint> &pressure,
                          unsigned progressBound) {
    if (softFail) {
      overflow = true;
      return success();
    }
    if (!pressure)
      return func.emitError("waveamd-reg-alloc hit AGPR bank-spill progress "
                            "bound without pressure diagnostics");
    return func.emitError()
           << "waveamd-reg-alloc hit AGPR bank-spill progress bound "
           << "(bound=" << progressBound
           << ") before relieving VGPR pressure at position "
           << pressure->position;
  }

  LogicalResult applyAGPRCandidate(func::FuncOp func,
                                   const AGPRConversionCandidate &candidate,
                                   OpBuilder &builder) {
    llvm::DenseSet<Value> groupValues(candidate.values.begin(),
                                      candidate.values.end());
    SmallVector<std::pair<Value, Value>, 4> agprValues;
    for (Value value : candidate.values) {
      if (!isa<waveamdmachine::RegType>(value.getType()))
        continue;
      if (canDefineAGPR(value, groupValues)) {
        setRegClass(value, waveamdmachine::RegClass::AGPR);
        agprValues.push_back({value, value});
        continue;
      }
      Operation *def = value.getDefiningOp();
      if (!def)
        return func.emitError()
               << "waveamd-reg-alloc cannot bank-spill block argument "
               << value;
      builder.setInsertionPointAfter(def);
      auto write = waveamdmachine::VAccvgprWriteB32TupleOp::create(
          builder, def->getLoc(),
          getVirtualRegType(value, waveamdmachine::RegClass::AGPR), value);
      agprValues.push_back({value, write.getResult()});
    }

    for (const std::pair<Value, Value> &mapping : agprValues)
      rewriteAGPRUses(mapping.first, mapping.second, groupValues, builder);
    return success();
  }

  static void rewriteAGPRUses(Value original, Value agpr,
                              const llvm::DenseSet<Value> &groupValues,
                              OpBuilder &builder) {
    SmallVector<OpOperand *> uses;
    for (OpOperand &use : original.getUses())
      uses.push_back(&use);
    for (OpOperand *use : uses) {
      if (use->get() != original)
        continue;
      Operation *user = use->getOwner();
      if (original != agpr &&
          isa<waveamdmachine::VAccvgprWriteB32TupleOp>(user))
        continue;
      if (canConsumeAGPR(*use, groupValues)) {
        use->set(agpr);
        continue;
      }
      builder.setInsertionPoint(user);
      auto read = waveamdmachine::VAccvgprReadB32TupleOp::create(
          builder, user->getLoc(),
          getVirtualRegType(agpr, waveamdmachine::RegClass::VGPR), agpr);
      use->set(read.getResult());
    }
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
    if (agprBankSpill)
      return allocateFunctionWithAGPRBankSpill(func, limits, softFail, overflow,
                                               pressure);
    return allocateFunctionAttempt(func, limits, softFail, overflow, pressure,
                                   rankAgprCandidates);
  }

  LogicalResult
  allocateFunctionAttempt(func::FuncOp func, RegisterLimits limits,
                          bool softFail, bool &overflow,
                          std::optional<RegisterPressurePoint> &pressure,
                          bool buildAgprCandidates) {
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
    return allocateRegisterClasses(
        func, intervals, limits, sgprReserved, vgprReserved, softFail, overflow,
        pressure, builtIntervals->positions, buildAgprCandidates);
  }

  LogicalResult allocateFunctionWithAGPRBankSpill(
      func::FuncOp func, RegisterLimits limits, bool softFail, bool &overflow,
      std::optional<RegisterPressurePoint> &pressure) {
    unsigned progressBound = countVirtualVGPRValues(func.getOperation());
    for (unsigned iter : llvm::seq<unsigned>(0, progressBound + 1)) {
      bool attemptOverflow = false;
      std::optional<RegisterPressurePoint> attemptPressure;
      if (failed(allocateFunctionAttempt(func, limits, /*softFail=*/true,
                                         attemptOverflow, attemptPressure,
                                         /*buildAgprCandidates=*/true)))
        return failure();
      if (!attemptOverflow)
        return success();
      pressure = std::move(attemptPressure);
      if (!pressure || pressure->regClass != "VGPR" ||
          pressure->agprCandidates.empty())
        return finishUnrelievedOverflow(func, softFail, overflow, pressure);
      if (iter == progressBound)
        return finishAGPRProgressBound(func, softFail, overflow, pressure,
                                       progressBound);
      OpBuilder builder(func.getContext());
      if (failed(applyAGPRCandidate(func, pressure->agprCandidates.front(),
                                    builder)))
        return failure();
    }
    llvm_unreachable("loop exits through success or overflow handling");
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
                          const DenseMap<Operation *, unsigned> &positions,
                          bool buildAgprCandidates) {
    if (failed(allocateClass(func, intervals.sgprs, limits.numSGPR,
                             sgprReserved, softFail, overflow, pressure,
                             positions, "SGPR", intervals.agprs,
                             /*agprCandidateLimit=*/0)))
      return failure();
    if (overflow)
      return success();
    unsigned agprCandidateLimit = buildAgprCandidates ? limits.numAGPR : 0;
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

  struct ActiveAlloc {
    wave::WaveAMDLiveInterval interval;
    PhysAlloc phys;
  };

  // Staged assignments keep values virtual until the class succeeds.
  void expireOld(SmallVectorImpl<ActiveAlloc> &active,
                 std::set<PhysAlloc> &live, unsigned pos) {
    SmallVector<ActiveAlloc> stillActive;
    for (ActiveAlloc alloc : active) {
      if (alloc.interval.end >= pos) {
        stillActive.push_back(alloc);
        continue;
      }
      live.erase(alloc.phys);
    }
    active = std::move(stillActive);
  }

  static SmallVector<wave::WaveAMDLiveInterval>
  collectActiveIntervals(ArrayRef<ActiveAlloc> active) {
    SmallVector<wave::WaveAMDLiveInterval> intervals;
    for (const ActiveAlloc &alloc : active)
      intervals.push_back(alloc.interval);
    return intervals;
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

    SmallVector<ActiveAlloc> active;
    // Reserved registers pre-occupy `[0, reserved)`.
    std::set<PhysAlloc> live;
    if (reserved > 0 && reserved <= numPhys)
      live.insert(PhysAlloc{0, reserved});

    SmallVector<std::pair<Value, unsigned>> assignments;
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
      if (!phys) {
        SmallVector<wave::WaveAMDLiveInterval> activeIntervals =
            collectActiveIntervals(active);
        return handleAllocationFailure(
            func, intervals, interval, activeIntervals, live, numPhys, reserved,
            softFail, overflow, pressure, positions, regClass, agprIntervals,
            agprCandidateLimit);
      }
      for (auto [v, off] : llvm::zip(interval.values, interval.slotOffsets))
        assignments.push_back({v, *phys + off});
      PhysAlloc allocation{*phys, width};
      live.insert(allocation);
      active.push_back(ActiveAlloc{interval, allocation});
      llvm::sort(active, [](const ActiveAlloc &lhs, const ActiveAlloc &rhs) {
        return lhs.interval.end < rhs.interval.end;
      });
    }
    for (auto [value, phys] : assignments)
      setRegPhys(value, phys);
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

  static bool hasNonAGPRWriteUse(Value value) {
    return llvm::any_of(value.getUses(), [](OpOperand &use) {
      return !isa<waveamdmachine::VAccvgprWriteB32TupleOp>(use.getOwner());
    });
  }

  static bool canMaterializeAndProgressAGPRCandidate(
      ArrayRef<unsigned> group, ArrayRef<wave::WaveAMDLiveInterval> intervals) {
    llvm::DenseSet<Value> groupValues = collectGroupValues(group, intervals);
    bool canProgress = false;
    for (unsigned intervalIndex : group) {
      for (Value value : intervals[intervalIndex].values) {
        if (canDefineAGPR(value, groupValues)) {
          canProgress = true;
          continue;
        }
        if (!value.getDefiningOp())
          return false;
        canProgress |= hasNonAGPRWriteUse(value);
      }
    }
    return canProgress;
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
    for (unsigned intervalIndex : group) {
      const wave::WaveAMDLiveInterval &interval = intervals[intervalIndex];
      candidate.values.append(interval.values);
      candidate.intervals.push_back(buildIntervalRef(interval, positions));
    }
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

  static SmallVector<AGPRConversionCandidate, 4>
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

    SmallVector<AGPRConversionCandidate, 4> candidates;
    for (auto [order, group] : llvm::enumerate(groups)) {
      if (!fitsAGPRSpace(group, intervals, agprIntervals, agprLimit))
        continue;
      if (!canMaterializeAndProgressAGPRCandidate(group, intervals))
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
