//===- EventSimulator.cpp - Event-driven machine timeline -----------------===//
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
#include "mlir/Dialect/WaveAMDMachine/CostModel/LatencyTable.h"
#include "mlir/Dialect/WaveAMDMachine/CostModel/MemoryCounterTiming.h"
#include "mlir/Dialect/WaveAMDMachine/CostModel/OpClassifier.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachine.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachineTraits.h"
#include "mlir/IR/Operation.h"
#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/Support/ErrorHandling.h"

#include <algorithm>
#include <array>
#include <limits>
#include <optional>
#include <queue>
#include <vector>

namespace mlir::waveamdmachine {

namespace {

namespace traits = ::mlir::OpTrait::waveamdmachine;

constexpr int64_t kInf = std::numeric_limits<int64_t>::max() / 4;
constexpr size_t kNumFUs =
    static_cast<size_t>(FunctionalUnit::NumFunctionalUnits);
constexpr unsigned kNumCounters = 3;

static bool isWaveAMDMachineOp(Operation *op) {
  return op->getName().getDialectNamespace() ==
         WaveAMDMachineDialect::getDialectNamespace();
}

static bool isWaitcntOp(Operation *op) {
  return op->hasTrait<traits::WaitcntOp>();
}

static bool isMemoryIssuer(Operation *op) {
  return getMemoryCounterKind(op) != MemoryCounterKind::None;
}

static bool isMemToken(Value value) {
  return isa<MemTokenType>(value.getType());
}

static int getConfiguredLatency(const ArchData &arch, SchedClass cls,
                                const EventSimConfig &config) {
  if (!config.calibration)
    return getLatency(arch, cls);
  return getCalibratedLatency(arch, cls, *config.calibration);
}

static EventSimCounter counterOf(Operation *op) {
  switch (getMemoryCounterKind(op)) {
  case MemoryCounterKind::Vmem:
    return EventSimCounter::Vmem;
  case MemoryCounterKind::Vscnt:
    return EventSimCounter::Vscnt;
  case MemoryCounterKind::Lgkm:
    return EventSimCounter::Lgkm;
  case MemoryCounterKind::None:
    break;
  }
  llvm_unreachable("op has no waitcnt counter");
}

static unsigned counterIndex(EventSimCounter counter) {
  switch (counter) {
  case EventSimCounter::Vmem:
    return 0;
  case EventSimCounter::Lgkm:
    return 1;
  case EventSimCounter::Vscnt:
    return 2;
  case EventSimCounter::None:
    break;
  }
  llvm_unreachable("counter has no queue");
}

struct WaitcntLimits {
  unsigned vmem = 0;
  unsigned lgkm = 0;
};

static WaitcntLimits decodeWaitcntImm(const ArchData &arch, unsigned imm) {
  WaitcntLimits limits;
  if (arch.isa.Major >= 11) {
    limits.vmem = (imm >> 10) & 0x3f;
    limits.lgkm = (imm >> 4) & 0x3f;
    return limits;
  }
  limits.vmem = (imm & 0xf) | (((imm >> 14) & 0x3) << 4);
  limits.lgkm = (imm >> 8) & 0xf;
  return limits;
}

static std::optional<unsigned> getImmediate(Value value) {
  if (ImmOp imm = value.getDefiningOp<ImmOp>())
    return static_cast<unsigned>(imm.getValue());
  return std::nullopt;
}

static unsigned getIssueCount(Operation *op) {
  if (isa<DsLoadTupleB32Op, GlobalLoadTupleB32Op, BufferLoadTupleB32Op>(op))
    return cast<RegType>(op->getResult(0).getType()).getWidth();
  if (isa<DsStoreTupleB32Op>(op))
    return cast<RegType>(op->getOperand(1).getType()).getWidth();
  return 1;
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

static void appendBlockOps(Block &block, const EventSimConfig &config,
                           SmallVectorImpl<Operation *> &ops);

static void appendOp(Operation *op, const EventSimConfig &config,
                     SmallVectorImpl<Operation *> &ops) {
  if (UniformLoopOp loop = dyn_cast<UniformLoopOp>(op)) {
    int64_t trips = getTripCount(loop, config);
    Block &body = loop.getBody().front();
    for (int64_t i = 0; i < trips; ++i)
      appendBlockOps(body, config, ops);
    return;
  }
  if (isWaveAMDMachineOp(op))
    ops.push_back(op);
}

static void appendBlockOps(Block &block, const EventSimConfig &config,
                           SmallVectorImpl<Operation *> &ops) {
  for (Operation &op : block)
    appendOp(&op, config, ops);
}

static SmallVector<Operation *> flattenOps(func::FuncOp func,
                                           const EventSimConfig &config) {
  SmallVector<Operation *> ops;
  for (Block &block : func.getBody())
    appendBlockOps(block, config, ops);
  return ops;
}

struct WaveState {
  int id = 0;
  int simd = 0;
  size_t pc = 0;
  int priority = 0;
  int64_t startCycle = 0;
  int64_t lastReady = 0;
  bool done = false;
  bool completionQueued = false;
  DenseMap<Value, int64_t> readyAt;
  std::array<SmallVector<int64_t, 4>, kNumCounters> counters;
};

struct SimdState {
  int64_t issueReady = 0;
  int rrCursor = 0;
  std::array<int64_t, kNumFUs> fuReady = {};
};

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

struct EventLater {
  bool operator()(const EventSimEvent &lhs, const EventSimEvent &rhs) const {
    if (lhs.cycle != rhs.cycle)
      return lhs.cycle > rhs.cycle;
    if (eventKindRank(lhs.kind) != eventKindRank(rhs.kind))
      return eventKindRank(lhs.kind) > eventKindRank(rhs.kind);
    return lhs.wave > rhs.wave;
  }
};

class EventSimulator {
public:
  EventSimulator(ArrayRef<Operation *> ops, const ArchData &arch,
                 const EventSimConfig &config, EventSimResult &out)
      : ops(ops), arch(arch), config(config), out(out) {}

  LogicalResult run();

private:
  ArrayRef<Operation *> ops;
  const ArchData &arch;
  const EventSimConfig &config;
  EventSimResult &out;
  SmallVector<WaveState> waves;
  SmallVector<SimdState> simds;
  std::priority_queue<EventSimEvent, std::vector<EventSimEvent>, EventLater>
      events;

  void initialize();
  void processEventsUpTo(int64_t cycle);
  void schedule(EventSimEvent event);
  void recordNow(EventSimEvent event);
  void pruneCounters(WaveState &wave, int64_t cycle);
  int64_t operandReadyCycle(const WaveState &wave, Operation *op) const;
  int64_t waitcntReadyCycle(WaveState &wave, Operation *op, int64_t cycle);
  int64_t opReadyCycle(WaveState &wave, int64_t cycle);
  int selectReadyWave(int simd, int64_t cycle);
  LogicalResult stepWave(WaveState &wave, int64_t cycle, bool &issued);
  LogicalResult executeNoInst(WaveState &wave, Operation *op, int64_t cycle);
  LogicalResult executeWaitcnt(WaveState &wave, Operation *op, int64_t cycle);
  LogicalResult executeIssued(WaveState &wave, Operation *op, int64_t cycle);
  void markIssuedResults(WaveState &wave, Operation *op, FunctionalUnit fu,
                         int64_t ready, int64_t nextIssue,
                         int64_t memoryValueReady, bool memoryIssuer,
                         bool hasMemoryValue);
  void queueMemoryCounterEvents(WaveState &wave, Operation *op,
                                FunctionalUnit fu, int64_t cycle,
                                unsigned issues, int period);
  void queueCompletion(WaveState &wave, int64_t cycle);
  bool queueReadyCompletions(int64_t cycle);
  LogicalResult stepReadyWaves(int64_t cycle, bool &progressed);
  bool allComplete() const;
  int64_t nextCycleAfter(int64_t cycle);
};

void EventSimulator::initialize() {
  int waveCount = std::max(1, config.waves);
  int simdCount = std::max(1, config.simds);
  waves.reserve(waveCount);
  simds.resize(simdCount);
  for (int i = 0; i < waveCount; ++i) {
    WaveState wave;
    wave.id = i;
    wave.simd = i % simdCount;
    wave.startCycle = static_cast<int64_t>(i) * std::max(0, config.startDelay);
    wave.lastReady = wave.startCycle;
    waves.push_back(std::move(wave));
  }
  out.waveCompletedCycles.assign(waveCount, 0);
}

void EventSimulator::schedule(EventSimEvent event) { events.push(event); }

void EventSimulator::recordNow(EventSimEvent event) {
  if (config.recordTimeline)
    out.events.push_back(event);
}

void EventSimulator::processEventsUpTo(int64_t cycle) {
  while (!events.empty() && events.top().cycle <= cycle) {
    EventSimEvent event = events.top();
    events.pop();
    if (event.wave >= 0 && event.wave < static_cast<int>(waves.size()))
      pruneCounters(waves[event.wave], event.cycle);
    recordNow(event);
  }
}

void EventSimulator::pruneCounters(WaveState &wave, int64_t cycle) {
  for (SmallVector<int64_t, 4> &queue : wave.counters) {
    queue.erase(std::remove_if(queue.begin(), queue.end(),
                               [&](int64_t ready) { return ready <= cycle; }),
                queue.end());
  }
}

int64_t EventSimulator::operandReadyCycle(const WaveState &wave,
                                          Operation *op) const {
  int64_t ready = wave.startCycle;
  for (Value operand : op->getOperands()) {
    DenseMap<Value, int64_t>::const_iterator it = wave.readyAt.find(operand);
    if (it != wave.readyAt.end())
      ready = std::max(ready, it->second);
  }
  return ready;
}

static int64_t counterReadyAt(ArrayRef<int64_t> queue, unsigned limit,
                              int64_t cycle) {
  SmallVector<int64_t, 4> pending;
  for (int64_t ready : queue)
    if (ready > cycle)
      pending.push_back(ready);
  if (pending.size() <= limit)
    return cycle;
  llvm::sort(pending);
  return pending[pending.size() - limit - 1];
}

int64_t EventSimulator::waitcntReadyCycle(WaveState &wave, Operation *op,
                                          int64_t cycle) {
  pruneCounters(wave, cycle);
  if (isa<SWaitcntVscntOp>(op)) {
    std::optional<unsigned> limit = getImmediate(op->getOperand(0));
    if (!limit)
      return cycle;
    return counterReadyAt(wave.counters[counterIndex(EventSimCounter::Vscnt)],
                          *limit, cycle);
  }
  if (isa<SWaitcntOp>(op)) {
    std::optional<unsigned> imm = getImmediate(op->getOperand(0));
    if (!imm)
      return cycle;
    WaitcntLimits limits = decodeWaitcntImm(arch, *imm);
    int64_t vmem = counterReadyAt(
        wave.counters[counterIndex(EventSimCounter::Vmem)], limits.vmem, cycle);
    int64_t lgkm = counterReadyAt(
        wave.counters[counterIndex(EventSimCounter::Lgkm)], limits.lgkm, cycle);
    return std::max(vmem, lgkm);
  }
  return cycle;
}

int64_t EventSimulator::opReadyCycle(WaveState &wave, int64_t cycle) {
  if (wave.done || wave.pc >= ops.size())
    return cycle;
  Operation *op = ops[wave.pc];
  if (isWaitcntOp(op))
    return waitcntReadyCycle(wave, op, cycle);
  int64_t ready = operandReadyCycle(wave, op);
  SchedClass cls = classifyOp(op);
  if (cls == SchedClass::NoInst)
    return ready;
  SimdState &simd = simds[wave.simd];
  FunctionalUnit fu = funit(arch, cls);
  ready = std::max(ready, simd.issueReady);
  ready = std::max(ready, simd.fuReady[static_cast<size_t>(fu)]);
  return ready;
}

int EventSimulator::selectReadyWave(int simd, int64_t cycle) {
  int best = -1;
  int bestPriority = std::numeric_limits<int>::min();
  int waveCount = static_cast<int>(waves.size());
  int start = simds[simd].rrCursor;
  for (int offset = 0; offset < waveCount; ++offset) {
    int idx = (start + offset) % waveCount;
    WaveState &wave = waves[idx];
    if (wave.simd != simd || wave.done)
      continue;
    if (wave.pc >= ops.size())
      continue;
    if (opReadyCycle(wave, cycle) > cycle)
      continue;
    if (wave.priority > bestPriority) {
      best = idx;
      bestPriority = wave.priority;
    }
  }
  return best;
}

LogicalResult EventSimulator::executeNoInst(WaveState &wave, Operation *op,
                                            int64_t cycle) {
  int64_t ready = operandReadyCycle(wave, op);
  if (ready > cycle)
    return failure();
  for (Value result : op->getResults()) {
    wave.readyAt[result] = cycle;
    schedule({cycle, EventSimEventKind::ValueReady, wave.id, wave.simd, op,
              FunctionalUnit::None, EventSimCounter::None});
  }
  ++wave.pc;
  return success();
}

LogicalResult EventSimulator::executeWaitcnt(WaveState &wave, Operation *op,
                                             int64_t cycle) {
  if (isa<SWaitcntOp>(op)) {
    std::optional<unsigned> imm = getImmediate(op->getOperand(0));
    if (!imm)
      return op->emitError("event simulator requires constant s_waitcnt imm");
  } else if (!getImmediate(op->getOperand(0))) {
    return op->emitError("event simulator requires constant s_waitcnt_vscnt "
                         "imm");
  }
  if (waitcntReadyCycle(wave, op, cycle) > cycle)
    return failure();
  pruneCounters(wave, cycle);
  recordNow({cycle, EventSimEventKind::CounterDrained, wave.id, wave.simd, op,
             FunctionalUnit::None, EventSimCounter::None});
  ++wave.pc;
  return success();
}

void EventSimulator::markIssuedResults(WaveState &wave, Operation *op,
                                       FunctionalUnit fu, int64_t ready,
                                       int64_t nextIssue,
                                       int64_t memoryValueReady,
                                       bool memoryIssuer, bool hasMemoryValue) {
  for (Value result : op->getResults()) {
    int64_t resultReady = ready;
    if (memoryIssuer && isMemToken(result))
      resultReady = nextIssue;
    else if (hasMemoryValue)
      resultReady = memoryValueReady;
    wave.readyAt[result] = resultReady;
    schedule({resultReady, EventSimEventKind::ValueReady, wave.id, wave.simd,
              op, fu, EventSimCounter::None});
    wave.lastReady = std::max(wave.lastReady, resultReady);
  }
  if (op->getNumResults() == 0)
    wave.lastReady = std::max(wave.lastReady, ready);
}

void EventSimulator::queueMemoryCounterEvents(WaveState &wave, Operation *op,
                                              FunctionalUnit fu, int64_t cycle,
                                              unsigned issues, int period) {
  EventSimCounter counter = counterOf(op);
  int counterLatency = getMemoryCounterLatency(
      arch, op, config.counterLatencies, config.calibration);
  SmallVector<int64_t, 4> &queue = wave.counters[counterIndex(counter)];
  for (unsigned i = 0; i < issues; ++i) {
    int64_t done = cycle + static_cast<int64_t>(i) * period + counterLatency;
    queue.push_back(done);
    schedule({done, EventSimEventKind::CounterDrained, wave.id, wave.simd, op,
              fu, counter});
  }
}

LogicalResult EventSimulator::executeIssued(WaveState &wave, Operation *op,
                                            int64_t cycle) {
  SchedClass cls = classifyOp(op);
  FunctionalUnit fu = funit(arch, cls);
  unsigned issues = std::max(1u, getIssueCount(op));
  int period = std::max(1, arch.simdIssuePeriod);
  int dependencyLatency = getConfiguredLatency(arch, cls, config);
  int64_t lastIssue = cycle + static_cast<int64_t>(issues - 1) * period;
  int64_t ready = lastIssue + dependencyLatency;
  int64_t nextIssue = cycle + static_cast<int64_t>(issues) * period;
  bool memoryIssuer = isMemoryIssuer(op);
  bool hasMemoryValue = hasMemoryValueLatency(op);
  int64_t memoryValueReady =
      hasMemoryValue
          ? lastIssue + getMemoryValueLatency(arch, op, config.valueLatencies,
                                              config.calibration)
          : ready;

  SimdState &simd = simds[wave.simd];
  simd.issueReady = nextIssue;
  simd.fuReady[static_cast<size_t>(fu)] = nextIssue;
  simd.rrCursor = (wave.id + 1) % static_cast<int>(waves.size());

  ++out.issuedOps;
  recordNow({cycle, EventSimEventKind::OpIssued, wave.id, wave.simd, op, fu,
             EventSimCounter::None});

  markIssuedResults(wave, op, fu, ready, nextIssue, memoryValueReady,
                    memoryIssuer, hasMemoryValue);

  if (memoryIssuer)
    queueMemoryCounterEvents(wave, op, fu, cycle, issues, period);

  if (SSetprioOp setprio = dyn_cast<SSetprioOp>(op)) {
    if (std::optional<unsigned> imm = getImmediate(setprio.getOperand()))
      wave.priority = static_cast<int>(*imm);
  }

  ++wave.pc;
  return success();
}

LogicalResult EventSimulator::stepWave(WaveState &wave, int64_t cycle,
                                       bool &issued) {
  issued = false;
  if (wave.pc >= ops.size())
    return success();
  Operation *op = ops[wave.pc];
  if (isWaitcntOp(op))
    return executeWaitcnt(wave, op, cycle);
  SchedClass cls = classifyOp(op);
  if (cls == SchedClass::NoInst)
    return executeNoInst(wave, op, cycle);
  issued = true;
  return executeIssued(wave, op, cycle);
}

void EventSimulator::queueCompletion(WaveState &wave, int64_t cycle) {
  if (wave.completionQueued)
    return;
  int64_t complete = std::max(cycle, wave.lastReady);
  wave.done = true;
  wave.completionQueued = true;
  out.waveCompletedCycles[wave.id] = complete;
  out.totalCycles = std::max(out.totalCycles, complete);
  schedule({complete, EventSimEventKind::WaveCompleted, wave.id, wave.simd,
            nullptr, FunctionalUnit::None, EventSimCounter::None});
}

bool EventSimulator::queueReadyCompletions(int64_t cycle) {
  bool changed = false;
  for (WaveState &wave : waves) {
    if (!wave.done && wave.pc >= ops.size()) {
      queueCompletion(wave, cycle);
      changed = true;
    }
  }
  return changed;
}

LogicalResult EventSimulator::stepReadyWaves(int64_t cycle, bool &progressed) {
  progressed = false;
  for (size_t simdIdx = 0; simdIdx < simds.size(); ++simdIdx) {
    while (true) {
      int waveIdx = selectReadyWave(static_cast<int>(simdIdx), cycle);
      if (waveIdx < 0)
        break;
      bool issued = false;
      if (failed(stepWave(waves[waveIdx], cycle, issued)))
        return failure();
      progressed = true;
      if (issued)
        break;
    }
  }
  return success();
}

bool EventSimulator::allComplete() const {
  for (const WaveState &wave : waves)
    if (!wave.done)
      return false;
  return true;
}

int64_t EventSimulator::nextCycleAfter(int64_t cycle) {
  int64_t next = kInf;
  if (!events.empty() && events.top().cycle > cycle)
    next = std::min(next, events.top().cycle);
  for (WaveState &wave : waves) {
    if (wave.done)
      continue;
    if (wave.pc >= ops.size()) {
      next = std::min(next, std::max(cycle, wave.lastReady));
      continue;
    }
    int64_t ready = opReadyCycle(wave, cycle);
    if (ready > cycle)
      next = std::min(next, ready);
  }
  return next;
}

LogicalResult EventSimulator::run() {
  initialize();
  int64_t cycle = 0;
  while (!allComplete()) {
    processEventsUpTo(cycle);
    if (queueReadyCompletions(cycle))
      continue;

    bool progressed = false;
    if (failed(stepReadyWaves(cycle, progressed)))
      return failure();
    if (progressed)
      continue;

    int64_t next = nextCycleAfter(cycle);
    if (next == kInf)
      return failure();
    cycle = next;
  }
  processEventsUpTo(out.totalCycles);
  if (config.recordTimeline) {
    llvm::sort(out.events,
               [](const EventSimEvent &lhs, const EventSimEvent &rhs) {
                 if (lhs.cycle != rhs.cycle)
                   return lhs.cycle < rhs.cycle;
                 if (eventKindRank(lhs.kind) != eventKindRank(rhs.kind))
                   return eventKindRank(lhs.kind) < eventKindRank(rhs.kind);
                 return lhs.wave < rhs.wave;
               });
  }
  return success();
}

} // namespace

LogicalResult simulateEventTimeline(func::FuncOp func, const ArchData &arch,
                                    const EventSimConfig &config,
                                    EventSimResult &out) {
  SmallVector<Operation *> ops = flattenOps(func, config);
  return simulateEventTimeline(ops, arch, config, out);
}

LogicalResult simulateEventTimeline(ArrayRef<Operation *> ops,
                                    const ArchData &arch,
                                    const EventSimConfig &config,
                                    EventSimResult &out) {
  out = EventSimResult();
  EventSimulator simulator(ops, arch, config, out);
  return simulator.run();
}

} // namespace mlir::waveamdmachine
