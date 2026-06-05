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

namespace mlir::wave {
#define GEN_PASS_DEF_WAVEAMDREGALLOC
#include "mlir/Dialect/Wave/Transforms/Passes.h.inc"
} // namespace mlir::wave

using namespace mlir;

namespace {

struct RegisterLimits {
  SmallVector<unsigned, 32> maxSGPRsForWaves;
  SmallVector<unsigned, 32> maxVGPRsForWaves;
  std::optional<unsigned> totalVGPRLimit;
  unsigned numSGPR = 0;
  unsigned numVGPR = 0;
  unsigned numAGPR = 0;
  unsigned maxWavesPerEU = 0;
  unsigned targetWaves = 0;
  bool agprCountsAgainstVGPRs = false;
};

struct AllocatedRegisterCounts {
  unsigned sgpr = 0;
  unsigned vgpr = 0;
  unsigned agpr = 0;
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
static constexpr llvm::StringLiteral kTargetWavesAttr =
    "waveamdmachine.target_waves";

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

static Attribute findTargetWavesAttr(Operation *op) {
  for (Operation *cur = op; cur; cur = cur->getParentOp())
    if (Attribute attr = cur->getAttr(kTargetWavesAttr))
      return attr;
  return {};
}

static FailureOr<unsigned> getTargetWaves(func::FuncOp func,
                                          const RegisterLimits &limits) {
  Attribute attr = findTargetWavesAttr(func);
  if (!attr)
    return 0;
  auto intAttr = dyn_cast<IntegerAttr>(attr);
  if (!intAttr)
    return func.emitError("waveamd-reg-alloc ")
           << kTargetWavesAttr << " must be an integer attribute";
  int64_t value = intAttr.getInt();
  if (value <= 0)
    return func.emitError("waveamd-reg-alloc ")
           << kTargetWavesAttr << " must be positive";
  if (static_cast<uint64_t>(value) > limits.maxWavesPerEU)
    return func.emitError("waveamd-reg-alloc ")
           << kTargetWavesAttr << " exceeds target wave capacity";
  return static_cast<unsigned>(value);
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
  limits.maxWavesPerEU = targetLimits->maxWavesPerEU;
  limits.maxSGPRsForWaves = targetLimits->maxSGPRsForWaves;
  limits.maxVGPRsForWaves = targetLimits->maxVGPRsForWaves;
  limits.agprCountsAgainstVGPRs = targetLimits->agprCountsAgainstVGPRs;
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

  static LogicalResult applyTargetWavesLimits(func::FuncOp func,
                                              RegisterLimits &limits) {
    FailureOr<unsigned> targetWaves = getTargetWaves(func, limits);
    if (failed(targetWaves))
      return failure();
    if (*targetWaves == 0)
      return success();

    unsigned vgprBudget = wave::getMaxWaveAMDRegisterBudgetForWaves(
        limits.maxVGPRsForWaves, *targetWaves);
    unsigned sgprBudget = wave::getMaxWaveAMDRegisterBudgetForWaves(
        limits.maxSGPRsForWaves, *targetWaves);
    if (vgprBudget == 0 || sgprBudget == 0)
      return func.emitError("waveamd-reg-alloc ")
             << kTargetWavesAttr << " has no register budget for this target";

    limits.totalVGPRLimit = vgprBudget;
    limits.numVGPR = std::min(limits.numVGPR, vgprBudget);
    limits.numSGPR = std::min(limits.numSGPR, sgprBudget);
    limits.targetWaves = *targetWaves;
    return success();
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
    if (failed(applyTargetWavesLimits(func, limits)))
      return failure();
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
    bool allowLoopCarriedAGPR = hasMFMAAccumulatorGroup(groupValues);
    SmallVector<std::pair<Value, Value>, 4> agprValues;
    for (Value value : candidate.values) {
      if (!isa<waveamdmachine::RegType>(value.getType()))
        continue;
      if (canDefineAGPR(value, groupValues, allowLoopCarriedAGPR)) {
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
      rewriteAGPRUses(mapping.first, mapping.second, groupValues,
                      allowLoopCarriedAGPR, builder);
    return success();
  }

  static void rewriteAGPRUses(Value original, Value agpr,
                              const llvm::DenseSet<Value> &groupValues,
                              bool allowLoopCarriedAGPR, OpBuilder &builder) {
    SmallVector<OpOperand *> uses;
    for (OpOperand &use : original.getUses())
      uses.push_back(&use);
    for (OpOperand *use : uses) {
      if (use->get() != original)
        continue;
      Operation *user = use->getOwner();
      if (auto write =
              dyn_cast<waveamdmachine::VAccvgprWriteB32TupleOp>(user)) {
        if (write.getResult() != agpr) {
          write.getResult().replaceAllUsesWith(agpr);
          write.erase();
        }
        continue;
      }
      if (canConsumeAGPR(*use, groupValues, allowLoopCarriedAGPR)) {
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
                                   rankAgprCandidates,
                                   /*enforceFinalBudgets=*/true);
  }

  LogicalResult
  allocateFunctionAttempt(func::FuncOp func, RegisterLimits limits,
                          bool softFail, bool &overflow,
                          std::optional<RegisterPressurePoint> &pressure,
                          bool buildAgprCandidates, bool enforceFinalBudgets) {
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
    if (failed(applyAGPRTotalVGPRLimit(func, intervals, limits, softFail,
                                       overflow)))
      return failure();
    if (overflow)
      return success();
    if (failed(allocateRegisterClasses(func, intervals, limits, sgprReserved,
                                       vgprReserved, softFail, overflow,
                                       pressure, builtIntervals->positions,
                                       buildAgprCandidates)))
      return failure();
    if (overflow || !enforceFinalBudgets)
      return success();
    return enforceAllocatedRegisterBudgets(func, limits, softFail, overflow);
  }

  static unsigned allocatedRegCount(ArrayRef<wave::WaveAMDLiveInterval> ivs) {
    unsigned count = 0;
    for (const wave::WaveAMDLiveInterval &interval : ivs) {
      for (Value value : interval.values) {
        auto type = dyn_cast<waveamdmachine::RegType>(value.getType());
        if (!type || type.getIndex() < 0)
          continue;
        unsigned end = static_cast<unsigned>(type.getIndex()) +
                       static_cast<unsigned>(type.getWidth());
        count = std::max(count, end);
      }
    }
    return count;
  }

  static FailureOr<AllocatedRegisterCounts>
  getAllocatedRegisterCounts(func::FuncOp func) {
    FailureOr<wave::WaveAMDLiveIntervalBuildResult> builtIntervals =
        wave::buildAllocatedWaveAMDLiveIntervals(func);
    if (failed(builtIntervals))
      return failure();

    AllocatedRegisterCounts counts;
    counts.sgpr = std::max(allocatedRegCount(builtIntervals->intervals.sgprs),
                           wave::getWaveAMDReservedSGPRs(func));
    counts.vgpr = std::max(allocatedRegCount(builtIntervals->intervals.vgprs),
                           wave::getWaveAMDReservedVGPRs(func));
    counts.agpr = allocatedRegCount(builtIntervals->intervals.agprs);
    return counts;
  }

  static unsigned alignUp(unsigned value, unsigned granule) {
    return ((value + granule - 1) / granule) * granule;
  }

  static unsigned alignDown(unsigned value, unsigned granule) {
    return (value / granule) * granule;
  }

  static unsigned getTotalVGPRCount(const RegisterLimits &limits,
                                    AllocatedRegisterCounts counts) {
    if (limits.agprCountsAgainstVGPRs && counts.agpr != 0)
      return alignUp(counts.vgpr, 4) + counts.agpr;
    return std::max(counts.vgpr, counts.agpr);
  }

  static LogicalResult enforceSGPRBudget(func::FuncOp func,
                                         const RegisterLimits &limits,
                                         AllocatedRegisterCounts counts,
                                         bool softFail, bool &overflow) {
    if (counts.sgpr <= limits.numSGPR)
      return success();
    if (softFail) {
      overflow = true;
      return success();
    }
    return func.emitError()
           << "waveamd-reg-alloc SGPR count exceeds register budget (count="
           << counts.sgpr << ", limit=" << limits.numSGPR
           << ", target_waves=" << limits.targetWaves << ")";
  }

  static LogicalResult enforceTotalVGPRBudget(func::FuncOp func,
                                              const RegisterLimits &limits,
                                              AllocatedRegisterCounts counts,
                                              bool softFail, bool &overflow) {
    if (!limits.totalVGPRLimit)
      return success();
    unsigned total = getTotalVGPRCount(limits, counts);
    if (total <= *limits.totalVGPRLimit)
      return success();
    if (softFail) {
      overflow = true;
      return success();
    }
    return func.emitError()
           << "waveamd-reg-alloc total VGPR count exceeds target-waves budget "
              "(total="
           << total << ", limit=" << *limits.totalVGPRLimit
           << ", vgpr=" << counts.vgpr << ", agpr=" << counts.agpr
           << ", target_waves=" << limits.targetWaves << ")";
  }

  static LogicalResult
  enforceAllocatedRegisterBudgets(func::FuncOp func,
                                  const RegisterLimits &limits, bool softFail,
                                  bool &overflow) {
    FailureOr<AllocatedRegisterCounts> counts =
        getAllocatedRegisterCounts(func);
    if (failed(counts))
      return failure();
    if (failed(enforceSGPRBudget(func, limits, *counts, softFail, overflow)))
      return failure();
    if (overflow)
      return success();
    return enforceTotalVGPRBudget(func, limits, *counts, softFail, overflow);
  }

  static unsigned maxLiveDwords(ArrayRef<wave::WaveAMDLiveInterval> intervals) {
    SmallVector<unsigned> points;
    for (const wave::WaveAMDLiveInterval &interval : intervals)
      appendLivePoints(interval, points);
    llvm::sort(points);
    points.erase(std::unique(points.begin(), points.end()), points.end());

    unsigned maxDwords = 0;
    for (unsigned position : points)
      maxDwords = std::max(maxDwords, liveDwordsAt(intervals, position));
    return maxDwords;
  }

  static LogicalResult applyAGPRTotalVGPRLimit(
      func::FuncOp func, const wave::WaveAMDLiveIntervalSet &intervals,
      RegisterLimits &limits, bool softFail, bool &overflow) {
    if (!limits.totalVGPRLimit || !limits.agprCountsAgainstVGPRs ||
        !hasLiveIntervals(intervals.agprs))
      return success();

    unsigned agprPressure = maxLiveDwords(intervals.agprs);
    if (agprPressure == 0)
      return success();
    if (agprPressure >= *limits.totalVGPRLimit) {
      if (softFail) {
        overflow = true;
        return success();
      }
      return func.emitError()
             << "waveamd-reg-alloc AGPR pressure exceeds total VGPR budget "
             << "(agpr=" << agprPressure << ", limit=" << *limits.totalVGPRLimit
             << ", target_waves=" << limits.targetWaves << ")";
    }

    unsigned vgprBudget =
        alignDown(*limits.totalVGPRLimit - agprPressure, /*granule=*/4);
    limits.numVGPR = std::min(limits.numVGPR, vgprBudget);
    return success();
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
                                         /*buildAgprCandidates=*/true,
                                         /*enforceFinalBudgets=*/false)))
        return failure();
      if (!attemptOverflow)
        return enforceAllocatedRegisterBudgets(func, limits, softFail,
                                               overflow);
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

  struct ActiveAlloc {
    const wave::WaveAMDLiveInterval *interval = nullptr;
    unsigned base = 0;
  };

  // Staged assignments keep values virtual until the class succeeds.
  void expireOld(SmallVectorImpl<ActiveAlloc> &active, unsigned pos) {
    SmallVector<ActiveAlloc> stillActive;
    for (const ActiveAlloc &alloc : active) {
      if (alloc.interval->end >= pos) {
        stillActive.push_back(alloc);
        continue;
      }
    }
    active = std::move(stillActive);
  }

  static wave::WaveAMDLiveIntervalVector
  collectActiveIntervals(ArrayRef<ActiveAlloc> active) {
    wave::WaveAMDLiveIntervalVector intervals;
    for (const ActiveAlloc &alloc : active)
      intervals.push_back(*alloc.interval);
    return intervals;
  }

  LogicalResult handleAllocationFailure(
      func::FuncOp func, MutableArrayRef<wave::WaveAMDLiveInterval> intervals,
      const wave::WaveAMDLiveInterval &request,
      ArrayRef<wave::WaveAMDLiveInterval> active, unsigned liveDwords,
      unsigned numPhys, unsigned reserved, bool softFail, bool &overflow,
      std::optional<RegisterPressurePoint> &pressure,
      const DenseMap<Operation *, unsigned> &positions, StringRef regClass,
      ArrayRef<wave::WaveAMDLiveInterval> agprIntervals,
      unsigned agprCandidateLimit) {
    if (!pressure)
      pressure =
          buildPressurePoint(regClass, request, active, liveDwords, positions,
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
    SmallVector<std::pair<Value, unsigned>> assignments;
    for (const wave::WaveAMDLiveInterval &interval : intervals) {
      if (interval.values.empty())
        continue;
      expireOld(active, interval.start);
      std::optional<unsigned> phys =
          findFreeSlot(active, interval, reserved, numPhys);
      if (!phys) {
        wave::WaveAMDLiveIntervalVector activeIntervals =
            collectActiveIntervals(active);
        unsigned liveDwords =
            reserved + liveDwordsAt(activeIntervals, interval.start);
        return handleAllocationFailure(
            func, intervals, interval, activeIntervals, liveDwords, numPhys,
            reserved, softFail, overflow, pressure, positions, regClass,
            agprIntervals, agprCandidateLimit);
      }
      for (auto [v, off] : llvm::zip(interval.values, interval.slotOffsets))
        assignments.push_back({v, *phys + off});
      active.push_back(ActiveAlloc{&interval, *phys});
      llvm::sort(active, [](const ActiveAlloc &lhs, const ActiveAlloc &rhs) {
        return lhs.interval->end < rhs.interval->end;
      });
    }
    for (auto [value, phys] : assignments)
      setRegPhys(value, phys);
    return success();
  }

  static bool timeOverlap(unsigned lhsStart, unsigned lhsEnd, unsigned rhsStart,
                          unsigned rhsEnd) {
    return lhsStart <= rhsEnd && rhsStart <= lhsEnd;
  }

  static bool physOverlap(unsigned lhsBegin, unsigned lhsWidth,
                          unsigned rhsBegin, unsigned rhsWidth) {
    return lhsBegin < rhsBegin + rhsWidth && rhsBegin < lhsBegin + lhsWidth;
  }

  static bool assignedIntervalsOverlap(const wave::WaveAMDLiveInterval &lhs,
                                       unsigned lhsBase,
                                       const wave::WaveAMDLiveInterval &rhs,
                                       unsigned rhsBase) {
    for (auto [lhsValue, lhsSlot, lhsStart, lhsEnd] : llvm::zip(
             lhs.values, lhs.slotOffsets, lhs.valueStarts, lhs.valueEnds)) {
      unsigned lhsWidth =
          cast<waveamdmachine::RegType>(lhsValue.getType()).getWidth();
      for (auto [rhsValue, rhsSlot, rhsStart, rhsEnd] : llvm::zip(
               rhs.values, rhs.slotOffsets, rhs.valueStarts, rhs.valueEnds)) {
        if (!timeOverlap(lhsStart, lhsEnd, rhsStart, rhsEnd))
          continue;
        unsigned rhsWidth =
            cast<waveamdmachine::RegType>(rhsValue.getType()).getWidth();
        if (physOverlap(lhsBase + lhsSlot, lhsWidth, rhsBase + rhsSlot,
                        rhsWidth))
          return true;
      }
    }
    return false;
  }

  static bool baseFits(ArrayRef<ActiveAlloc> active,
                       const wave::WaveAMDLiveInterval &interval,
                       unsigned base) {
    for (const ActiveAlloc &alloc : active)
      if (assignedIntervalsOverlap(interval, base, *alloc.interval, alloc.base))
        return false;
    return true;
  }

  static std::optional<unsigned>
  findFreeSlot(ArrayRef<ActiveAlloc> active,
               const wave::WaveAMDLiveInterval &interval, unsigned reserved,
               unsigned maxRegs) {
    unsigned width = interval.type.getWidth();
    unsigned align = std::max<unsigned>(1, llvm::PowerOf2Ceil(width));
    unsigned first = alignUp(reserved, align);
    for (unsigned base = first; base + width <= maxRegs; base += align)
      if (baseFits(active, interval, base))
        return base;
    return std::nullopt;
  }

  static bool intervalContains(const wave::WaveAMDLiveInterval &interval,
                               unsigned position) {
    return wave::isWaveAMDLiveIntervalLiveAt(interval, position);
  }

  static bool intervalsOverlap(const wave::WaveAMDLiveInterval &lhs,
                               const wave::WaveAMDLiveInterval &rhs) {
    for (auto [lhsStart, lhsEnd] : llvm::zip(lhs.valueStarts, lhs.valueEnds))
      for (auto [rhsStart, rhsEnd] : llvm::zip(rhs.valueStarts, rhs.valueEnds))
        if (timeOverlap(lhsStart, lhsEnd, rhsStart, rhsEnd))
          return true;
    return false;
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

  static std::optional<unsigned> getUniformLoopBodyArgIndex(Value value) {
    auto arg = dyn_cast<BlockArgument>(value);
    if (!arg)
      return std::nullopt;
    auto loop =
        dyn_cast<waveamdmachine::UniformLoopOp>(arg.getOwner()->getParentOp());
    if (!loop || arg.getOwner() != &loop.getBody().front())
      return std::nullopt;
    return arg.getArgNumber();
  }

  static std::optional<unsigned> getUniformLoopResultIndex(Value value) {
    auto result = dyn_cast<OpResult>(value);
    if (!result)
      return std::nullopt;
    if (!isa<waveamdmachine::UniformLoopOp>(result.getOwner()))
      return std::nullopt;
    return result.getResultNumber();
  }

  static std::optional<unsigned> getUniformLoopInitIndex(OpOperand &use) {
    auto loop = dyn_cast<waveamdmachine::UniformLoopOp>(use.getOwner());
    if (!loop)
      return std::nullopt;
    MutableOperandRange inits = loop.getInitsMutable();
    for (unsigned i : llvm::seq<unsigned>(0, inits.size()))
      if (&inits[i] == &use)
        return i;
    return std::nullopt;
  }

  static std::optional<unsigned> getUniformLoopCarryIndex(OpOperand &use) {
    auto term = dyn_cast<waveamdmachine::ContinueIfOp>(use.getOwner());
    if (!term)
      return std::nullopt;
    MutableOperandRange carries = term.getCarriesMutable();
    for (unsigned i : llvm::seq<unsigned>(0, carries.size()))
      if (&carries[i] == &use)
        return i;
    return std::nullopt;
  }

  static waveamdmachine::UniformLoopOp getParentUniformLoop(Operation *op) {
    if (auto loop = dyn_cast<waveamdmachine::UniformLoopOp>(op))
      return loop;
    if (auto term = dyn_cast<waveamdmachine::ContinueIfOp>(op))
      return term->getParentOfType<waveamdmachine::UniformLoopOp>();
    return {};
  }

  static bool uniformLoopSlotInGroup(waveamdmachine::UniformLoopOp loop,
                                     unsigned index,
                                     const llvm::DenseSet<Value> &groupValues) {
    if (!loop || index >= loop.getInits().size())
      return false;
    Block &body = loop.getBody().front();
    auto term = dyn_cast<waveamdmachine::ContinueIfOp>(body.getTerminator());
    if (!term || index >= term.getCarries().size())
      return false;
    return groupValues.contains(loop.getInits()[index]) ||
           groupValues.contains(body.getArgument(index)) ||
           groupValues.contains(loop.getResult(index)) ||
           groupValues.contains(term.getCarries()[index]);
  }

  static bool
  isUniformLoopAGPREndpoint(Value value,
                            const llvm::DenseSet<Value> &groupValues,
                            bool allowLoopCarriedAGPR) {
    if (!allowLoopCarriedAGPR)
      return false;
    if (std::optional<unsigned> index = getUniformLoopBodyArgIndex(value)) {
      auto arg = cast<BlockArgument>(value);
      auto loop =
          cast<waveamdmachine::UniformLoopOp>(arg.getOwner()->getParentOp());
      return uniformLoopSlotInGroup(loop, *index, groupValues);
    }
    if (std::optional<unsigned> index = getUniformLoopResultIndex(value)) {
      auto result = cast<OpResult>(value);
      auto loop = cast<waveamdmachine::UniformLoopOp>(result.getOwner());
      return uniformLoopSlotInGroup(loop, *index, groupValues);
    }
    return false;
  }

  static bool isUniformLoopAGPRUse(OpOperand &use,
                                   const llvm::DenseSet<Value> &groupValues,
                                   bool allowLoopCarriedAGPR) {
    if (!allowLoopCarriedAGPR)
      return false;
    if (std::optional<unsigned> index = getUniformLoopInitIndex(use))
      return uniformLoopSlotInGroup(
          cast<waveamdmachine::UniformLoopOp>(use.getOwner()), *index,
          groupValues);
    if (std::optional<unsigned> index = getUniformLoopCarryIndex(use))
      return uniformLoopSlotInGroup(getParentUniformLoop(use.getOwner()),
                                    *index, groupValues);
    return false;
  }

  static bool
  hasMFMAAccumulatorGroup(const llvm::DenseSet<Value> &groupValues) {
    for (Value value : groupValues) {
      if (isMFMAResult(value))
        return true;
      for (OpOperand &use : value.getUses()) {
        Operation *user = use.getOwner();
        if (isMFMA(user) && use.getOperandNumber() == 2 &&
            user->getNumResults() == 1 &&
            groupValues.contains(user->getResult(0)))
          return true;
      }
    }
    return false;
  }

  static bool canDefineAGPR(Value value,
                            const llvm::DenseSet<Value> &groupValues,
                            bool allowLoopCarriedAGPR) {
    if (isUniformLoopAGPREndpoint(value, groupValues, allowLoopCarriedAGPR))
      return true;
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
                             const llvm::DenseSet<Value> &groupValues,
                             bool allowLoopCarriedAGPR) {
    if (isUniformLoopAGPRUse(use, groupValues, allowLoopCarriedAGPR))
      return true;
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

  static bool isAGPRReload(Value value) {
    return isa_and_nonnull<waveamdmachine::VAccvgprReadB32TupleOp>(
        value.getDefiningOp());
  }

  static bool canMaterializeAndProgressAGPRCandidate(
      ArrayRef<unsigned> group, ArrayRef<wave::WaveAMDLiveInterval> intervals) {
    llvm::DenseSet<Value> groupValues = collectGroupValues(group, intervals);
    bool allowLoopCarriedAGPR = hasMFMAAccumulatorGroup(groupValues);
    bool canProgress = false;
    for (unsigned intervalIndex : group) {
      for (Value value : intervals[intervalIndex].values) {
        if (isAGPRReload(value))
          return false;
        if (canDefineAGPR(value, groupValues, allowLoopCarriedAGPR)) {
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
    bool allowLoopCarriedAGPR = hasMFMAAccumulatorGroup(groupValues);
    unsigned bridges = 0;
    for (unsigned intervalIndex : group) {
      for (Value value : intervals[intervalIndex].values) {
        if (!canDefineAGPR(value, groupValues, allowLoopCarriedAGPR))
          ++bridges;
        for (OpOperand &use : value.getUses())
          if (!canConsumeAGPR(use, groupValues, allowLoopCarriedAGPR))
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
        dwords += wave::getWaveAMDLiveIntervalWidthAt(intervals[intervalIndex],
                                                      position);
    return dwords;
  }

  static unsigned liveDwordsAt(ArrayRef<wave::WaveAMDLiveInterval> intervals,
                               unsigned position) {
    unsigned dwords = 0;
    for (const wave::WaveAMDLiveInterval &interval : intervals)
      if (intervalContains(interval, position))
        dwords += wave::getWaveAMDLiveIntervalWidthAt(interval, position);
    return dwords;
  }

  static void appendLivePoints(const wave::WaveAMDLiveInterval &interval,
                               SmallVectorImpl<unsigned> &points) {
    points.append(interval.valueStarts.begin(), interval.valueStarts.end());
    points.append(interval.valueEnds.begin(), interval.valueEnds.end());
  }

  static unsigned
  maxGroupLiveDwords(ArrayRef<unsigned> group,
                     ArrayRef<wave::WaveAMDLiveInterval> intervals) {
    unsigned maxDwords = 0;
    SmallVector<unsigned> points;
    for (unsigned intervalIndex : group) {
      appendLivePoints(intervals[intervalIndex], points);
    }
    llvm::sort(points);
    points.erase(std::unique(points.begin(), points.end()), points.end());
    for (unsigned position : points)
      maxDwords = std::max(maxDwords, liveDwordsAt(group, intervals, position));
    return maxDwords;
  }

  static unsigned overlapDwords(ArrayRef<unsigned> group,
                                ArrayRef<wave::WaveAMDLiveInterval> intervals) {
    unsigned overlap = 0;
    for (unsigned intervalIndex : group) {
      const wave::WaveAMDLiveInterval &interval = intervals[intervalIndex];
      for (unsigned position : llvm::seq(interval.start, interval.end + 1))
        overlap += wave::getWaveAMDLiveIntervalWidthAt(interval, position);
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
    for (unsigned intervalIndex : group)
      appendLivePoints(vgprs[intervalIndex], points);
    for (const wave::WaveAMDLiveInterval &agpr : agprs) {
      bool overlapsGroup = llvm::any_of(group, [&](unsigned intervalIndex) {
        return intervalsOverlap(agpr, vgprs[intervalIndex]);
      });
      if (!overlapsGroup)
        continue;
      appendLivePoints(agpr, points);
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

  static unsigned estimateRelief(unsigned liveWidth, unsigned requestWidth,
                                 unsigned limit) {
    if (liveWidth + requestWidth > limit)
      return liveWidth + requestWidth - limit;
    return 1;
  }

  static RegisterPressurePoint buildPressurePoint(
      StringRef regClass, const wave::WaveAMDLiveInterval &request,
      ArrayRef<wave::WaveAMDLiveInterval> active, unsigned liveDwords,
      const DenseMap<Operation *, unsigned> &positions, unsigned position,
      unsigned limit, unsigned reserved) {
    RegisterPressurePoint point;
    point.regClass = regClass;
    point.limit = limit;
    point.liveDwords = liveDwords;
    point.position = position;
    point.request = buildIntervalRef(request, positions);
    point.requiredRelief = estimateRelief(
        point.liveDwords,
        wave::getWaveAMDLiveIntervalWidthAt(request, position), limit);
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
