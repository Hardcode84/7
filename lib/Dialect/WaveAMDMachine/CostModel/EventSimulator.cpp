//===- EventSimulator.cpp - Instruction-state timeline --------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/WaveAMDMachine/CostModel/EventSimulator.h"

#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/WaveAMDMachine/CostModel/ArchData.h"
#include "mlir/Dialect/WaveAMDMachine/CostModel/CalibrationData.h"
#include "mlir/Dialect/WaveAMDMachine/CostModel/InstructionExecutionState.h"
#include "mlir/Dialect/WaveAMDMachine/CostModel/LatencyTable.h"
#include "mlir/Dialect/WaveAMDMachine/CostModel/MemoryCounterTiming.h"
#include "mlir/Dialect/WaveAMDMachine/CostModel/MultiWaveExecutionState.h"
#include "mlir/Dialect/WaveAMDMachine/CostModel/OpClassifier.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachine.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachineTraits.h"
#include "mlir/IR/Operation.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/Support/ErrorHandling.h"

#include <algorithm>
#include <cstdint>
#include <limits>
#include <optional>

namespace mlir::waveamdmachine {

bool isEventSimCmaClass(SchedClass cls) {
  switch (cls) {
  case SchedClass::Write2PassMAI:
  case SchedClass::Write4PassMAI:
  case SchedClass::Write8PassMAI:
  case SchedClass::Write16PassMAI:
  case SchedClass::WriteXDL2PassWMMA:
  case SchedClass::WriteXDL4PassWMMA:
  case SchedClass::Write4PassWMMA:
  case SchedClass::Write8PassWMMA:
  case SchedClass::Write16PassWMMA:
    return true;
  default:
    return false;
  }
}

static unsigned getNativeWaveSize(const ArchData &arch) {
  return arch.isa.Major >= 10 ? 32 : 64;
}

int getEventSimIssuePeriod(const ArchData &arch, const EventSimConfig &config) {
  int period = std::max(1, arch.simdIssuePeriod);
  unsigned waveSize =
      config.waveSize > 0 ? config.waveSize : getNativeWaveSize(arch);
  if (waveSize == 64)
    period *= std::max(1, arch.wave64IssueMultiplier);
  return period;
}

int getEventSimCmaIssueInterval(const ArchData &arch,
                                const EventSimConfig &config) {
  if (config.cmaIssueInterval > 0)
    return config.cmaIssueInterval;
  if (config.cmaIssueInterval < 0)
    return getEventSimIssuePeriod(arch, config);
  return 0;
}

unsigned getEventSimCmaIssueCapacity(const ArchData &arch) {
  return std::max(1, arch.simdsPerCU);
}

unsigned getEventSimCmaIssueCount(Operation *op, SchedClass cls,
                                  unsigned issues) {
  if (!isLdsDmaIssuer(op) && !isEventSimCmaClass(cls))
    return 0;
  return std::max(1u, issues);
}

namespace {

namespace traits = ::mlir::OpTrait::waveamdmachine;

static bool isMemToken(Value value) {
  return isa<MemTokenType>(value.getType());
}

static bool isWaitcntOp(Operation *op) {
  return op->hasTrait<traits::WaitcntOp>();
}

static unsigned getCounterIssueCount(Operation *op) {
  if (WaitcntInfoOpInterface info = dyn_cast<WaitcntInfoOpInterface>(op))
    return info.getWaitcntInfo().issueCount;
  return 0;
}

static InstructionExecutionConfig
buildInstructionConfig(const ArchData &arch, const EventSimConfig &config) {
  InstructionExecutionConfig stateConfig;
  stateConfig.calibration = config.calibration;
  stateConfig.counterLatencies = config.counterLatencies;
  stateConfig.valueLatencies = config.valueLatencies;
  stateConfig.issuePeriod = getEventSimIssuePeriod(arch, config);
  return stateConfig;
}

static EventSimCounter toEventCounter(MemoryCounterKind kind) {
  switch (kind) {
  case MemoryCounterKind::Vmem:
    return EventSimCounter::Vmem;
  case MemoryCounterKind::Lgkm:
    return EventSimCounter::Lgkm;
  case MemoryCounterKind::Vscnt:
    return EventSimCounter::Vscnt;
  case MemoryCounterKind::Async:
    return EventSimCounter::Async;
  case MemoryCounterKind::Tensor:
    return EventSimCounter::Tensor;
  case MemoryCounterKind::None:
    return EventSimCounter::None;
  }
  llvm_unreachable("bad memory counter");
}

static int eventKindRank(EventSimEventKind kind) {
  switch (kind) {
  case EventSimEventKind::OpIssued:
    return 0;
  case EventSimEventKind::ValueReady:
    return 1;
  case EventSimEventKind::CounterDrained:
    return 2;
  case EventSimEventKind::WaveCompleted:
    return 3;
  }
  llvm_unreachable("bad event kind");
}

static int64_t getTripCount(UniformLoopOp loop, const EventSimConfig &config) {
  if (config.tripCountOverride >= 0)
    return config.tripCountOverride;
  IntegerAttr trip =
      loop->getAttrOfType<IntegerAttr>("waveamdmachine.trip_count");
  if (!trip)
    return 1;
  return std::max<int64_t>(0, trip.getInt());
}

static YieldOp getYield(Region &region) {
  if (region.empty())
    return nullptr;
  return dyn_cast<YieldOp>(region.front().getTerminator());
}

class StateTimeline {
public:
  StateTimeline(const ArchData &arch, const EventSimConfig &config,
                EventSimResult &out, bool recordTimeline)
      : state(arch, buildInstructionConfig(arch, config)), arch(arch),
        config(config), out(out), recordTimeline(recordTimeline) {}

  StateTimeline(const StateTimeline &base, EventSimResult &out,
                bool recordTimeline)
      : state(base.state), arch(base.arch), config(base.config), out(out),
        recordTimeline(recordTimeline), lastReady(base.lastReady),
        lastCounterReady(base.lastCounterReady) {}

  LogicalResult runFunc(func::FuncOp func) {
    for (Block &block : func.getBody())
      if (failed(runBlock(block)))
        return failure();
    finish();
    return success();
  }

  LogicalResult runOps(ArrayRef<Operation *> ops) {
    for (Operation *op : ops)
      if (failed(runOp(op)))
        return failure();
    finish();
    return success();
  }

  int64_t getCompleteCycle() const {
    int64_t complete = std::max(lastReady, state.getCurrentCycle());
    if (config.completePendingLdsDmaCounters)
      complete = std::max(complete, lastCounterReady);
    return complete;
  }

private:
  InstructionExecutionState state;
  const ArchData &arch;
  const EventSimConfig &config;
  EventSimResult &out;
  bool recordTimeline = false;
  int64_t lastReady = 0;
  int64_t lastCounterReady = 0;

  LogicalResult runBlock(Block &block) {
    for (Operation &op : block)
      if (failed(runOp(&op)))
        return failure();
    return success();
  }

  LogicalResult runRegion(Region &region) {
    if (region.empty())
      return success();
    return runBlock(region.front());
  }

  LogicalResult runOp(Operation *op) {
    if (!isWaveAMDMachineOp(op))
      return success();
    if (UniformLoopOp loop = dyn_cast<UniformLoopOp>(op))
      return runUniformLoop(loop);
    if (UniformIfOp uniformIf = dyn_cast<UniformIfOp>(op))
      return runUniformIf(uniformIf);
    if (ExecIfOp execIf = dyn_cast<ExecIfOp>(op))
      return runExecIf(execIf);
    return commitAndRecord(op);
  }

  FailureOr<int64_t> estimateRegion(Region &region) {
    EventSimResult dummy;
    StateTimeline trial(*this, dummy, /*recordTimeline=*/false);
    if (failed(trial.runRegion(region)))
      return failure();
    return trial.getCompleteCycle();
  }

  LogicalResult runUniformIf(UniformIfOp op) {
    if (failed(commitAndRecord(op.getOperation())))
      return failure();

    FailureOr<int64_t> thenCost = estimateRegion(op.getThenRegion());
    if (failed(thenCost))
      return failure();
    FailureOr<int64_t> elseCost = estimateRegion(op.getElseRegion());
    if (failed(elseCost))
      return failure();

    Region &selected =
        *thenCost >= *elseCost ? op.getThenRegion() : op.getElseRegion();
    if (failed(runRegion(selected)))
      return failure();
    bindYieldResults(op.getResults(), selected);
    return success();
  }

  LogicalResult runExecIf(ExecIfOp op) {
    if (failed(runRegion(op.getThenRegion())))
      return failure();
    bindYieldResults(op.getResults(), op.getThenRegion());
    if (!op.getElseRegion().empty()) {
      if (failed(runRegion(op.getElseRegion())))
        return failure();
      bindYieldResults(op.getResults(), op.getElseRegion());
    }
    return success();
  }

  template <typename TargetRange, typename SourceRange>
  void bindValues(TargetRange targets, SourceRange sources) {
    for (auto [target, source] : llvm::zip_equal(targets, sources))
      state.bindValue(target, source);
  }

  LogicalResult runUniformLoop(UniformLoopOp op) {
    if (failed(commitAndRecord(op.getOperation())))
      return failure();

    Block &body = op.getBody().front();
    int64_t trips = getTripCount(op, config);
    if (trips <= 0) {
      bindValues(op.getResults(), op.getInits());
      return success();
    }

    bindValues(body.getArguments(), op.getInits());

    for (int64_t iter = 0; iter < trips; ++iter) {
      if (failed(runBlock(body)))
        return failure();
      ContinueIfOp terminator = dyn_cast<ContinueIfOp>(body.getTerminator());
      if (!terminator)
        return failure();
      ValueRange carries = terminator.getCarries();
      if (iter + 1 == trips)
        bindValues(op.getResults(), carries);
      else
        bindValues(body.getArguments(), carries);
    }
    return success();
  }

  void bindYieldResults(ResultRange results, Region &region) {
    YieldOp yield = getYield(region);
    if (!yield)
      return;
    for (auto [result, value] : llvm::zip_equal(results, yield.getValues())) {
      state.bindValue(result, value);
      recordValueReady(yield.getOperation(), result);
    }
  }

  LogicalResult commitAndRecord(Operation *op) {
    FailureOr<InstructionCommitResult> commit = state.commit(op);
    if (failed(commit))
      return failure();

    SchedClass cls = classifyOp(op);
    bool realInst = cls != SchedClass::NoInst;
    FunctionalUnit fu = realInst ? funit(arch, cls) : FunctionalUnit::None;

    if (realInst) {
      ++out.issuedOps;
      record({commit->issueCycle, EventSimEventKind::OpIssued, op, fu,
              EventSimCounter::None});
    }

    if (isWaitcntOp(op)) {
      record({commit->issueCycle, EventSimEventKind::CounterDrained, op,
              FunctionalUnit::None, EventSimCounter::None});
    }

    for (Value result : op->getResults())
      recordValueReady(op, result, fu, *commit);

    recordMemoryCounters(op, fu, *commit);
    if (op->getNumResults() == 0)
      lastReady = std::max(lastReady, commit->valueReadyCycle);
    return success();
  }

  void recordValueReady(Operation *op, Value result,
                        FunctionalUnit fu = FunctionalUnit::None) {
    int64_t ready = state.getValueReadyCycle(result);
    lastReady = std::max(lastReady, ready);
    record(
        {ready, EventSimEventKind::ValueReady, op, fu, EventSimCounter::None});
  }

  void recordValueReady(Operation *op, Value result, FunctionalUnit fu,
                        const InstructionCommitResult &commit) {
    int64_t ready =
        isMemToken(result) ? commit.tokenReadyCycle : commit.valueReadyCycle;
    lastReady = std::max(lastReady, ready);
    record(
        {ready, EventSimEventKind::ValueReady, op, fu, EventSimCounter::None});
  }

  void recordMemoryCounters(Operation *op, FunctionalUnit fu,
                            const InstructionCommitResult &commit) {
    MemoryCounterKind counterKind = getMemoryCounterKind(op);
    if (counterKind == MemoryCounterKind::None)
      return;

    EventSimCounter counter = toEventCounter(counterKind);
    int latency = getMemoryCounterLatency(arch, op, config.counterLatencies,
                                          config.calibration);
    int period = getEventSimIssuePeriod(arch, config);

    for (unsigned issue : llvm::seq<unsigned>(0, getCounterIssueCount(op))) {
      int64_t ready =
          commit.issueCycle + static_cast<int64_t>(issue) * period + latency;
      lastCounterReady = std::max(lastCounterReady, ready);
      record({ready, EventSimEventKind::CounterDrained, op, fu, counter});
    }
  }

  void record(EventSimEvent event) {
    if (!recordTimeline)
      return;
    out.events.push_back(event);
  }

  void finish() {
    int64_t complete = getCompleteCycle();
    out.totalCycles = complete;
    out.completedCycle = complete;
    out.waveCompletedCycles = {complete};
    record({complete, EventSimEventKind::WaveCompleted, nullptr,
            FunctionalUnit::None, EventSimCounter::None});
    sortEvents();
  }

  void sortEvents() {
    if (!recordTimeline)
      return;
    llvm::sort(out.events,
               [](const EventSimEvent &lhs, const EventSimEvent &rhs) {
                 if (lhs.cycle != rhs.cycle)
                   return lhs.cycle < rhs.cycle;
                 if (eventKindRank(lhs.kind) != eventKindRank(rhs.kind))
                   return eventKindRank(lhs.kind) < eventKindRank(rhs.kind);
                 return lhs.op < rhs.op;
               });
  }
};

class MultiWaveTimeline {
public:
  MultiWaveTimeline(ArrayRef<Operation *> ops, const ArchData &arch,
                    const EventSimConfig &config, EventSimResult &out)
      : ops(ops),
        placements(getFullCUWavePlacements(arch, config.wavesPerSIMD)),
        state(arch, placements, buildInstructionConfig(arch, config)),
        arch(arch), config(config), out(out) {
    size_t waveCount = placements.size();
    pc.assign(waveCount, 0);
    lastReady.assign(waveCount, 0);
    lastCounterReady.assign(waveCount, 0);
  }

  LogicalResult run() {
    if (placements.empty())
      return failure();
    if (ops.size() > std::numeric_limits<size_t>::max() / placements.size())
      return failure();

    size_t stepCount = ops.size() * placements.size();
    for ([[maybe_unused]] size_t step : llvm::seq<size_t>(0, stepCount)) {
      unsigned selected = 0;
      if (failed(selectNextWave(selected)) || failed(commitWave(selected)))
        return failure();
    }
    finish();
    return success();
  }

private:
  ArrayRef<Operation *> ops;
  SmallVector<WavePlacement> placements;
  MultiWaveExecutionState state;
  const ArchData &arch;
  const EventSimConfig &config;
  EventSimResult &out;
  SmallVector<size_t, 8> pc;
  SmallVector<int64_t, 8> lastReady;
  SmallVector<int64_t, 8> lastCounterReady;

  LogicalResult selectNextWave(unsigned &selected) {
    SmallVector<Operation *, 8> candidates(placements.size(), nullptr);
    for (unsigned wave :
         llvm::seq<unsigned>(0, static_cast<unsigned>(placements.size()))) {
      if (pc[wave] == ops.size())
        continue;
      candidates[wave] = ops[pc[wave]];
    }
    FailureOr<unsigned> wave = state.selectWave(candidates);
    if (failed(wave))
      return failure();
    selected = *wave;
    return success();
  }

  LogicalResult commitWave(unsigned wave) {
    Operation *op = ops[pc[wave]];
    FailureOr<InstructionCommitResult> commit = state.commit(wave, op);
    if (failed(commit))
      return failure();

    SchedClass cls = classifyOp(op);
    bool realInst = cls != SchedClass::NoInst;
    FunctionalUnit fu = realInst ? funit(arch, cls) : FunctionalUnit::None;
    WavePlacement placement = placements[wave];

    if (realInst) {
      ++out.issuedOps;
      record({commit->issueCycle, EventSimEventKind::OpIssued, op, fu,
              EventSimCounter::None, wave, placement.simd});
    }
    if (isWaitcntOp(op))
      record({commit->issueCycle, EventSimEventKind::CounterDrained, op,
              FunctionalUnit::None, EventSimCounter::None, wave,
              placement.simd});

    for (Value result : op->getResults()) {
      int64_t ready = isMemToken(result) ? commit->tokenReadyCycle
                                         : commit->valueReadyCycle;
      lastReady[wave] = std::max(lastReady[wave], ready);
      record({ready, EventSimEventKind::ValueReady, op, fu,
              EventSimCounter::None, wave, placement.simd});
    }
    if (op->getNumResults() == 0)
      lastReady[wave] = std::max(lastReady[wave], commit->valueReadyCycle);
    recordMemoryCounters(wave, op, fu, *commit);
    ++pc[wave];
    return success();
  }

  void recordMemoryCounters(unsigned wave, Operation *op, FunctionalUnit fu,
                            const InstructionCommitResult &commit) {
    MemoryCounterKind counterKind = getMemoryCounterKind(op);
    if (counterKind == MemoryCounterKind::None)
      return;

    EventSimCounter counter = toEventCounter(counterKind);
    int latency = getMemoryCounterLatency(arch, op, config.counterLatencies,
                                          config.calibration);
    int period = getEventSimIssuePeriod(arch, config);
    WavePlacement placement = placements[wave];
    for (unsigned issue : llvm::seq<unsigned>(0, getCounterIssueCount(op))) {
      int64_t ready =
          commit.issueCycle + static_cast<int64_t>(issue) * period + latency;
      lastCounterReady[wave] = std::max(lastCounterReady[wave], ready);
      record({ready, EventSimEventKind::CounterDrained, op, fu, counter, wave,
              placement.simd});
    }
  }

  void record(EventSimEvent event) {
    if (config.recordTimeline)
      out.events.push_back(event);
  }

  void finish() {
    out.waveCompletedCycles.assign(placements.size(), 0);
    for (unsigned wave :
         llvm::seq<unsigned>(0, static_cast<unsigned>(placements.size()))) {
      int64_t complete = std::max(lastReady[wave], state.getCurrentCycle(wave));
      if (config.completePendingLdsDmaCounters)
        complete = std::max(complete, lastCounterReady[wave]);
      out.waveCompletedCycles[wave] = complete;
      out.totalCycles = std::max(out.totalCycles, complete);
      record({complete, EventSimEventKind::WaveCompleted, nullptr,
              FunctionalUnit::None, EventSimCounter::None, wave,
              placements[wave].simd});
    }
    out.completedCycle = out.totalCycles;
    if (!config.recordTimeline)
      return;
    llvm::sort(out.events,
               [](const EventSimEvent &lhs, const EventSimEvent &rhs) {
                 if (lhs.cycle != rhs.cycle)
                   return lhs.cycle < rhs.cycle;
                 if (eventKindRank(lhs.kind) != eventKindRank(rhs.kind))
                   return eventKindRank(lhs.kind) < eventKindRank(rhs.kind);
                 if (lhs.wave != rhs.wave)
                   return lhs.wave < rhs.wave;
                 return lhs.op < rhs.op;
               });
  }
};

static LogicalResult validateMultiWaveProgramOp(Operation *op) {
  if (op->getNumRegions() != 0)
    return op->emitOpError(
        "multi-wave event simulation requires linear machine control flow");
  if (isa<ClusterBarrierOp, SBarrierOp, SBarrierWaitOp, BarrierWaitOp>(op))
    return op->emitOpError(
        "multi-wave event simulation does not model wave rendezvous");
  return success();
}

static LogicalResult collectLinearProgram(func::FuncOp func,
                                          SmallVectorImpl<Operation *> &ops) {
  if (!func.getBody().hasOneBlock())
    return func.emitOpError(
        "multi-wave event simulation requires one function block");
  for (Operation &op : func.getBody().front()) {
    if (failed(validateMultiWaveProgramOp(&op)))
      return failure();
    if (isWaveAMDMachineOp(&op))
      ops.push_back(&op);
  }
  return success();
}

static LogicalResult validateLinearProgram(ArrayRef<Operation *> ops) {
  for (Operation *op : ops)
    if (failed(validateMultiWaveProgramOp(op)))
      return failure();
  return success();
}

} // namespace

LogicalResult simulateEventTimeline(func::FuncOp func, const ArchData &arch,
                                    const EventSimConfig &config,
                                    EventSimResult &out) {
  out = EventSimResult();
  if (config.wavesPerSIMD != 0) {
    if (config.wavesPerSIMD > static_cast<unsigned>(arch.wavesPerSIMD))
      return failure();
    SmallVector<Operation *> ops;
    if (failed(collectLinearProgram(func, ops)))
      return failure();
    MultiWaveTimeline timeline(ops, arch, config, out);
    return timeline.run();
  }
  StateTimeline timeline(arch, config, out, config.recordTimeline);
  return timeline.runFunc(func);
}

LogicalResult simulateEventTimeline(ArrayRef<Operation *> ops,
                                    const ArchData &arch,
                                    const EventSimConfig &config,
                                    EventSimResult &out) {
  out = EventSimResult();
  if (config.wavesPerSIMD != 0) {
    if (config.wavesPerSIMD > static_cast<unsigned>(arch.wavesPerSIMD))
      return failure();
    if (failed(validateLinearProgram(ops)))
      return failure();
    SmallVector<Operation *> machineOps;
    llvm::copy_if(ops, std::back_inserter(machineOps), isWaveAMDMachineOp);
    MultiWaveTimeline timeline(machineOps, arch, config, out);
    return timeline.run();
  }
  StateTimeline timeline(arch, config, out, config.recordTimeline);
  return timeline.runOps(ops);
}

} // namespace mlir::waveamdmachine
