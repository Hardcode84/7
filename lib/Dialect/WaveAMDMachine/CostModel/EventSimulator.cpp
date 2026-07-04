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
#include <cstdint>
#include <limits>
#include <optional>
#include <queue>
#include <vector>

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

int getEventSimLdsDmaIssueInterval(const ArchData &arch,
                                   const EventSimConfig &config) {
  if (config.ldsDmaIssueInterval > 0)
    return config.ldsDmaIssueInterval;
  if (config.ldsDmaIssueInterval < 0)
    return getEventSimIssuePeriod(arch, config);
  return 0;
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

static std::optional<unsigned> getImmediate(Value value) {
  if (ImmOp imm = value.getDefiningOp<ImmOp>())
    return static_cast<unsigned>(imm.getValue());
  return std::nullopt;
}

static unsigned getIssueCount(Operation *op) {
  if (auto info = dyn_cast<WaitcntInfoOpInterface>(op))
    return info.getWaitcntInfo().issueCount;
  return 0;
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

enum class ProgramItemKind : uint8_t {
  Op,
  LoopBegin,
  LoopEnd,
  Synthetic,
  Yield,
};

struct ProgramItem {
  Operation *op = nullptr;
  Operation *owner = nullptr;
  int64_t tripCount = 0;
  unsigned bodyStart = 0;
  unsigned loop = 0;
  SchedClass syntheticClass = SchedClass::NoInst;
  ProgramItemKind kind = ProgramItemKind::Op;
};

static ProgramItem makeOpItem(Operation *op) {
  ProgramItem item;
  item.op = op;
  return item;
}

static ProgramItem makeLoopBeginItem(int64_t tripCount, unsigned bodyStart) {
  ProgramItem item;
  item.tripCount = tripCount;
  item.bodyStart = bodyStart;
  item.kind = ProgramItemKind::LoopBegin;
  return item;
}

static ProgramItem makeLoopEndItem(unsigned loop) {
  ProgramItem item;
  item.loop = loop;
  item.kind = ProgramItemKind::LoopEnd;
  return item;
}

static ProgramItem makeSyntheticItem(Operation *op, SchedClass cls) {
  ProgramItem item;
  item.op = op;
  item.syntheticClass = cls;
  item.kind = ProgramItemKind::Synthetic;
  return item;
}

static ProgramItem makeYieldItem(Operation *owner, Operation *yield) {
  ProgramItem item;
  item.op = yield;
  item.owner = owner;
  item.kind = ProgramItemKind::Yield;
  return item;
}

static void appendProgramBlock(Block &block, const ArchData &arch,
                               const EventSimConfig &config,
                               SmallVectorImpl<ProgramItem> &program);

static void appendProgramRegion(Region &region, const ArchData &arch,
                                const EventSimConfig &config,
                                SmallVectorImpl<ProgramItem> &program) {
  if (region.empty())
    return;
  appendProgramBlock(region.front(), arch, config, program);
}

static int64_t estimateProgramCost(ArrayRef<ProgramItem> program,
                                   const ArchData &arch,
                                   const EventSimConfig &config);

static void
appendSelectedUniformIfRegion(UniformIfOp uniformIf, const ArchData &arch,
                              const EventSimConfig &config,
                              SmallVectorImpl<ProgramItem> &program) {
  SmallVector<ProgramItem> thenProgram;
  SmallVector<ProgramItem> elseProgram;
  appendProgramRegion(uniformIf.getThenRegion(), arch, config, thenProgram);
  appendProgramRegion(uniformIf.getElseRegion(), arch, config, elseProgram);
  ArrayRef<ProgramItem> selected =
      estimateProgramCost(thenProgram, arch, config) >=
              estimateProgramCost(elseProgram, arch, config)
          ? ArrayRef<ProgramItem>(thenProgram)
          : ArrayRef<ProgramItem>(elseProgram);
  program.append(selected.begin(), selected.end());
}

static void appendProgramOp(Operation *op, const ArchData &arch,
                            const EventSimConfig &config,
                            SmallVectorImpl<ProgramItem> &program) {
  if (UniformLoopOp loop = dyn_cast<UniformLoopOp>(op)) {
    int64_t trips = getTripCount(loop, config);
    if (trips <= 0)
      return;
    unsigned loopIndex = program.size();
    program.push_back(makeLoopBeginItem(trips, loopIndex + 1));
    appendProgramBlock(loop.getBody().front(), arch, config, program);
    program.push_back(makeLoopEndItem(loopIndex));
    return;
  }
  if (ExecIfOp execIf = dyn_cast<ExecIfOp>(op)) {
    program.push_back(makeSyntheticItem(op, SchedClass::WriteSALU));
    program.push_back(makeSyntheticItem(op, SchedClass::WriteBranch));
    appendProgramBlock(execIf.getThenRegion().front(), arch, config, program);
    if (!execIf.getElseRegion().empty()) {
      program.push_back(makeSyntheticItem(op, SchedClass::WriteSALU));
      program.push_back(makeSyntheticItem(op, SchedClass::WriteBranch));
      appendProgramBlock(execIf.getElseRegion().front(), arch, config, program);
    }
    program.push_back(makeSyntheticItem(op, SchedClass::WriteSALU));
    return;
  }
  if (UniformIfOp uniformIf = dyn_cast<UniformIfOp>(op))
    appendSelectedUniformIfRegion(uniformIf, arch, config, program);
  if (YieldOp yield = dyn_cast<YieldOp>(op)) {
    if (Operation *parent = yield->getParentOp();
        isa_and_nonnull<ExecIfOp>(parent))
      program.push_back(makeYieldItem(parent, op));
    return;
  }
  if (isWaveAMDMachineOp(op))
    program.push_back(makeOpItem(op));
}

static void appendProgramBlock(Block &block, const ArchData &arch,
                               const EventSimConfig &config,
                               SmallVectorImpl<ProgramItem> &program) {
  for (Operation &op : block)
    appendProgramOp(&op, arch, config, program);
}

static SmallVector<ProgramItem> buildProgram(func::FuncOp func,
                                             const ArchData &arch,
                                             const EventSimConfig &config) {
  SmallVector<ProgramItem> program;
  for (Block &block : func.getBody())
    appendProgramBlock(block, arch, config, program);
  return program;
}

struct LoopFrame {
  int64_t remaining = 0;
  unsigned loop = 0;
};

struct WaveState {
  SmallVector<LoopFrame, 4> loops;
  DenseMap<Value, int64_t> readyAt;
  std::array<SmallVector<int64_t, 4>, kNumCounters> counters;
  SmallVector<int64_t, 4> ldsDmaCounters;
  int id = 0;
  int simd = 0;
  size_t pc = 0;
  int priority = 0;
  int64_t startCycle = 0;
  int64_t lastReady = 0;
  bool done = false;
  bool completionQueued = false;
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
  EventSimulator(ArrayRef<ProgramItem> program, const ArchData &arch,
                 const EventSimConfig &config, EventSimResult &out)
      : program(program), arch(arch), config(config), out(out),
        structuredProgram(true) {}

  LogicalResult run();

private:
  ArrayRef<Operation *> ops;
  ArrayRef<ProgramItem> program;
  const ArchData &arch;
  const EventSimConfig &config;
  EventSimResult &out;
  SmallVector<WaveState, 8> waves;
  SmallVector<SimdState> simds;
  std::priority_queue<EventSimEvent, std::vector<EventSimEvent>, EventLater>
      events;
  DenseMap<int64_t, unsigned> cuIssueCounts;
  DenseMap<int64_t, unsigned> cmaIssueCounts;
  int64_t ldsDmaReady = 0;
  bool structuredProgram = false;

  void initialize();
  void processEventsUpTo(int64_t cycle);
  void schedule(EventSimEvent event);
  void recordNow(EventSimEvent event);
  void advanceControl(WaveState &wave) const;
  const ProgramItem *currentItem(WaveState &wave) const;
  Operation *currentOp(WaveState &wave) const;
  void pruneCounters(WaveState &wave, int64_t cycle);
  int64_t operandReadyCycle(const WaveState &wave, Operation *op) const;
  int64_t waitcntReadyCycle(WaveState &wave, Operation *op, int64_t cycle);
  int getLdsDmaIssueInterval() const;
  int getCmaIssueInterval() const;
  unsigned getCmaIssueCapacity() const;
  unsigned getCmaIssueCount(Operation *op, SchedClass cls,
                            unsigned issues) const;
  int getIssuePeriod() const;
  int64_t cuIssueReadyCycle(int64_t cycle, unsigned issues, int period) const;
  void pruneCuIssueCounts(int64_t cycle);
  void consumeCuIssueSlots(int64_t cycle, unsigned issues, int period);
  int64_t cmaIssueReadyCycle(int64_t cycle, Operation *op, SchedClass cls,
                             unsigned issues) const;
  void pruneCmaIssueCounts(int64_t cycle);
  void consumeCmaIssueSlots(int64_t cycle, Operation *op, SchedClass cls,
                            unsigned issues);
  int64_t issuedReadyCycle(WaveState &wave, Operation *op, SchedClass cls,
                           unsigned issues, int64_t cycle);
  int64_t opReadyCycle(WaveState &wave, int64_t cycle);
  int selectReadyWave(int simd, int64_t cycle);
  LogicalResult stepWave(WaveState &wave, int64_t cycle, bool &issued);
  LogicalResult executeNoInst(WaveState &wave, Operation *op, int64_t cycle);
  LogicalResult executeSynthetic(WaveState &wave, const ProgramItem &item,
                                 int64_t cycle);
  LogicalResult executeYield(WaveState &wave, const ProgramItem &item,
                             int64_t cycle);
  LogicalResult executeWaitcnt(WaveState &wave, Operation *op, int64_t cycle);
  LogicalResult executeIssued(WaveState &wave, Operation *op, int64_t cycle);
  void markIssuedResults(WaveState &wave, Operation *op, FunctionalUnit fu,
                         int64_t ready, int64_t nextIssue,
                         int64_t memoryValueReady, bool memoryIssuer,
                         bool hasMemoryValue);
  int64_t counterTailCycle(const WaveState &wave, int64_t cycle) const;
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

void EventSimulator::advanceControl(WaveState &wave) const {
  while (wave.pc < program.size()) {
    const ProgramItem &item = program[wave.pc];
    switch (item.kind) {
    case ProgramItemKind::Op:
    case ProgramItemKind::Synthetic:
    case ProgramItemKind::Yield:
      return;
    case ProgramItemKind::LoopBegin:
      wave.loops.push_back({item.tripCount, static_cast<unsigned>(wave.pc)});
      wave.pc = item.bodyStart;
      break;
    case ProgramItemKind::LoopEnd: {
      assert(!wave.loops.empty() && "loop end without active loop");
      LoopFrame &frame = wave.loops.back();
      assert(frame.loop == item.loop && "loop end mismatch");
      --frame.remaining;
      if (frame.remaining > 0) {
        wave.pc = program[frame.loop].bodyStart;
        break;
      }
      wave.loops.pop_back();
      ++wave.pc;
      break;
    }
    }
  }
}

const ProgramItem *EventSimulator::currentItem(WaveState &wave) const {
  if (!structuredProgram)
    return nullptr;
  advanceControl(wave);
  if (wave.pc >= program.size())
    return nullptr;
  return &program[wave.pc];
}

Operation *EventSimulator::currentOp(WaveState &wave) const {
  if (!structuredProgram) {
    if (wave.pc >= ops.size())
      return nullptr;
    return ops[wave.pc];
  }
  const ProgramItem *item = currentItem(wave);
  if (!item)
    return nullptr;
  assert((item->kind == ProgramItemKind::Op ||
          item->kind == ProgramItemKind::Synthetic ||
          item->kind == ProgramItemKind::Yield) &&
         "control item escaped");
  return item->op;
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
  wave.ldsDmaCounters.erase(
      std::remove_if(wave.ldsDmaCounters.begin(), wave.ldsDmaCounters.end(),
                     [&](int64_t ready) { return ready <= cycle; }),
      wave.ldsDmaCounters.end());
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
  if (auto wait = dyn_cast<SWaitcntVscntOp>(op)) {
    return counterReadyAt(wave.counters[counterIndex(EventSimCounter::Vscnt)],
                          wait.getVscnt(), cycle);
  }
  if (auto wait = dyn_cast<SWaitcntOp>(op)) {
    int64_t ready = cycle;
    if (std::optional<uint32_t> vm = wait.getVmcnt())
      ready = std::max(
          ready,
          counterReadyAt(wave.counters[counterIndex(EventSimCounter::Vmem)],
                         *vm, cycle));
    if (std::optional<uint32_t> lg = wait.getLgkmcnt())
      ready = std::max(
          ready,
          counterReadyAt(wave.counters[counterIndex(EventSimCounter::Lgkm)],
                         *lg, cycle));
    return ready;
  }
  return cycle;
}

int EventSimulator::getIssuePeriod() const {
  return getEventSimIssuePeriod(arch, config);
}

int EventSimulator::getLdsDmaIssueInterval() const {
  return getEventSimLdsDmaIssueInterval(arch, config);
}

int EventSimulator::getCmaIssueInterval() const {
  return getEventSimCmaIssueInterval(arch, config);
}

unsigned EventSimulator::getCmaIssueCapacity() const {
  return getEventSimCmaIssueCapacity(arch);
}

unsigned EventSimulator::getCmaIssueCount(Operation *op, SchedClass cls,
                                          unsigned issues) const {
  return getEventSimCmaIssueCount(op, cls, issues);
}

static int64_t issueCycle(int64_t start, unsigned issue, int period) {
  return start + static_cast<int64_t>(issue) * period;
}

int64_t EventSimulator::cuIssueReadyCycle(int64_t cycle, unsigned issues,
                                          int period) const {
  unsigned cap = static_cast<unsigned>(arch.issuesPerCUPerCycle);
  while (true) {
    std::optional<int64_t> nextStart;
    for (unsigned issue : llvm::seq<unsigned>(0, issues)) {
      int64_t currentIssueCycle = issueCycle(cycle, issue, period);
      if (cuIssueCounts.lookup(currentIssueCycle) < cap)
        continue;
      nextStart = currentIssueCycle - static_cast<int64_t>(issue) * period + 1;
      break;
    }
    if (!nextStart)
      return cycle;
    cycle = std::max<int64_t>(cycle + 1, *nextStart);
  }
}

void EventSimulator::pruneCuIssueCounts(int64_t cycle) {
  SmallVector<int64_t, 4> expired;
  for (auto &entry : cuIssueCounts)
    if (entry.first < cycle)
      expired.push_back(entry.first);
  for (int64_t key : expired)
    cuIssueCounts.erase(key);
}

void EventSimulator::consumeCuIssueSlots(int64_t cycle, unsigned issues,
                                         int period) {
  pruneCuIssueCounts(cycle);
  for (unsigned issue : llvm::seq<unsigned>(0, issues)) {
    int64_t currentIssueCycle = issueCycle(cycle, issue, period);
    unsigned &count = cuIssueCounts[currentIssueCycle];
    assert(count < static_cast<unsigned>(arch.issuesPerCUPerCycle) &&
           "CU issue cap exceeded");
    ++count;
  }
}

int64_t EventSimulator::cmaIssueReadyCycle(int64_t cycle, Operation *op,
                                           SchedClass cls,
                                           unsigned issues) const {
  int interval = getCmaIssueInterval();
  unsigned cmaIssues = getCmaIssueCount(op, cls, issues);
  if (interval <= 0 || cmaIssues == 0)
    return cycle;

  unsigned cap = getCmaIssueCapacity();
  while (true) {
    std::optional<int64_t> nextStart;
    for (unsigned issue : llvm::seq<unsigned>(0, cmaIssues)) {
      int64_t begin = issueCycle(cycle, issue, interval);
      for (unsigned offset :
           llvm::seq<unsigned>(0, static_cast<unsigned>(interval))) {
        int64_t currentIssueCycle = begin + offset;
        if (cmaIssueCounts.lookup(currentIssueCycle) < cap)
          continue;
        nextStart = currentIssueCycle - static_cast<int64_t>(issue) * interval -
                    static_cast<int64_t>(offset) + 1;
        break;
      }
      if (nextStart)
        break;
    }
    if (!nextStart)
      return cycle;
    cycle = std::max<int64_t>(cycle + 1, *nextStart);
  }
}

void EventSimulator::pruneCmaIssueCounts(int64_t cycle) {
  SmallVector<int64_t, 4> expired;
  for (auto &entry : cmaIssueCounts)
    if (entry.first < cycle)
      expired.push_back(entry.first);
  for (int64_t key : expired)
    cmaIssueCounts.erase(key);
}

void EventSimulator::consumeCmaIssueSlots(int64_t cycle, Operation *op,
                                          SchedClass cls, unsigned issues) {
  int interval = getCmaIssueInterval();
  unsigned cmaIssues = getCmaIssueCount(op, cls, issues);
  if (interval <= 0 || cmaIssues == 0)
    return;

  pruneCmaIssueCounts(cycle);
  unsigned cap = getCmaIssueCapacity();
  for (unsigned issue : llvm::seq<unsigned>(0, cmaIssues)) {
    int64_t begin = issueCycle(cycle, issue, interval);
    for (unsigned offset :
         llvm::seq<unsigned>(0, static_cast<unsigned>(interval))) {
      int64_t currentIssueCycle = begin + offset;
      unsigned &count = cmaIssueCounts[currentIssueCycle];
      assert(count < cap && "CMA issue cap exceeded");
      ++count;
    }
  }
}

int64_t EventSimulator::issuedReadyCycle(WaveState &wave, Operation *op,
                                         SchedClass cls, unsigned issues,
                                         int64_t cycle) {
  int64_t ready = operandReadyCycle(wave, op);
  SimdState &simd = simds[wave.simd];
  FunctionalUnit fu = funit(arch, cls);
  ready = std::max(ready, simd.issueReady);
  ready = std::max(ready, simd.fuReady[static_cast<size_t>(fu)]);
  if (isLdsDmaIssuer(op)) {
    int interval = getLdsDmaIssueInterval();
    if (interval > 0)
      ready = std::max(ready, ldsDmaReady);
  }
  int period = getIssuePeriod();
  while (true) {
    int64_t cmaReady = cmaIssueReadyCycle(ready, op, cls, issues);
    int64_t cuReady = cuIssueReadyCycle(cmaReady, issues, period);
    if (cuReady == cmaReady)
      return cuReady;
    ready = cuReady;
  }
}

int64_t EventSimulator::opReadyCycle(WaveState &wave, int64_t cycle) {
  if (wave.done)
    return cycle;
  Operation *op = currentOp(wave);
  if (!op)
    return cycle;
  if (structuredProgram) {
    const ProgramItem *item = currentItem(wave);
    assert(item && "currentOp returned op without item");
    if (item->kind == ProgramItemKind::Yield)
      return operandReadyCycle(wave, op);
    if (item->kind == ProgramItemKind::Synthetic)
      return issuedReadyCycle(wave, op, item->syntheticClass, /*issues=*/1,
                              cycle);
  }
  if (isWaitcntOp(op))
    return waitcntReadyCycle(wave, op, cycle);
  int64_t ready = operandReadyCycle(wave, op);
  SchedClass cls = classifyOp(op);
  if (cls == SchedClass::NoInst)
    return ready;
  unsigned issues = std::max(1u, getIssueCount(op));
  return issuedReadyCycle(wave, op, cls, issues, cycle);
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
    if (!currentOp(wave))
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

LogicalResult EventSimulator::executeSynthetic(WaveState &wave,
                                               const ProgramItem &item,
                                               int64_t cycle) {
  Operation *op = item.op;
  SchedClass cls = item.syntheticClass;
  if (issuedReadyCycle(wave, op, cls, /*issues=*/1, cycle) > cycle)
    return failure();

  int period = getIssuePeriod();
  int dependencyLatency = getConfiguredLatency(arch, cls, config);
  int64_t nextIssue = cycle + period;
  int64_t ready = cycle + dependencyLatency;
  FunctionalUnit fu = funit(arch, cls);

  SimdState &simd = simds[wave.simd];
  simd.issueReady = nextIssue;
  simd.fuReady[static_cast<size_t>(fu)] = nextIssue;
  simd.rrCursor = (wave.id + 1) % static_cast<int>(waves.size());
  consumeCuIssueSlots(cycle, /*issues=*/1, period);

  ++out.issuedOps;
  wave.lastReady = std::max(wave.lastReady, ready);
  recordNow({cycle, EventSimEventKind::OpIssued, wave.id, wave.simd, op, fu,
             EventSimCounter::None});
  ++wave.pc;
  return success();
}

LogicalResult EventSimulator::executeYield(WaveState &wave,
                                           const ProgramItem &item,
                                           int64_t cycle) {
  auto yield = cast<YieldOp>(item.op);
  auto execIf = cast<ExecIfOp>(item.owner);
  int64_t ready = operandReadyCycle(wave, yield.getOperation());
  if (ready > cycle)
    return failure();

  for (auto [result, value] :
       llvm::zip_equal(execIf.getResults(), yield.getValues())) {
    wave.readyAt[result] = cycle;
    schedule({cycle, EventSimEventKind::ValueReady, wave.id, wave.simd,
              yield.getOperation(), FunctionalUnit::None,
              EventSimCounter::None});
  }
  wave.lastReady = std::max(wave.lastReady, cycle);
  ++wave.pc;
  return success();
}

LogicalResult EventSimulator::executeWaitcnt(WaveState &wave, Operation *op,
                                             int64_t cycle) {
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
  int64_t counterIssue = cycle;
  int counterIssuePeriod = period;
  if (isLdsDmaIssuer(op)) {
    int interval = getLdsDmaIssueInterval();
    if (interval > 0) {
      counterIssuePeriod = interval;
      ldsDmaReady = counterIssue + static_cast<int64_t>(issues) * interval;
    }
  }
  SmallVector<int64_t, 4> &queue = wave.counters[counterIndex(counter)];
  for (unsigned i = 0; i < issues; ++i) {
    int64_t done = counterIssue + static_cast<int64_t>(i) * counterIssuePeriod +
                   counterLatency;
    queue.push_back(done);
    if (isLdsDmaIssuer(op))
      wave.ldsDmaCounters.push_back(done);
    schedule({done, EventSimEventKind::CounterDrained, wave.id, wave.simd, op,
              fu, counter});
  }
}

LogicalResult EventSimulator::executeIssued(WaveState &wave, Operation *op,
                                            int64_t cycle) {
  SchedClass cls = classifyOp(op);
  FunctionalUnit fu = funit(arch, cls);
  unsigned issues = std::max(1u, getIssueCount(op));
  int period = getIssuePeriod();
  int dependencyLatency = getConfiguredLatency(arch, cls, config);
  int64_t lastIssue = cycle + static_cast<int64_t>(issues - 1) * period;
  int64_t ready = lastIssue + dependencyLatency;
  int64_t nextIssue = cycle + static_cast<int64_t>(issues) * period;
  bool memoryIssuer = isMemoryIssuer(op);
  bool hasMemoryValue = hasMemoryValueLatency(op);
  int64_t memoryValueReady =
      hasMemoryValue
          ? lastIssue + getMemoryValueLatency(arch, op, config.counterLatencies,
                                              config.valueLatencies,
                                              config.calibration)
          : ready;

  SimdState &simd = simds[wave.simd];
  simd.issueReady = nextIssue;
  simd.fuReady[static_cast<size_t>(fu)] = nextIssue;
  simd.rrCursor = (wave.id + 1) % static_cast<int>(waves.size());
  consumeCuIssueSlots(cycle, issues, period);
  consumeCmaIssueSlots(cycle, op, cls, issues);

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
  Operation *op = currentOp(wave);
  if (!op)
    return success();
  if (structuredProgram) {
    const ProgramItem *item = currentItem(wave);
    assert(item && "currentOp returned op without item");
    if (item->kind == ProgramItemKind::Synthetic) {
      issued = true;
      return executeSynthetic(wave, *item, cycle);
    }
    if (item->kind == ProgramItemKind::Yield)
      return executeYield(wave, *item, cycle);
  }
  if (isWaitcntOp(op))
    return executeWaitcnt(wave, op, cycle);
  SchedClass cls = classifyOp(op);
  if (cls == SchedClass::NoInst)
    return executeNoInst(wave, op, cycle);
  issued = true;
  return executeIssued(wave, op, cycle);
}

int64_t EventSimulator::counterTailCycle(const WaveState &wave,
                                         int64_t cycle) const {
  int64_t ready = cycle;
  for (int64_t counterReady : wave.ldsDmaCounters)
    ready = std::max(ready, counterReady);
  return ready;
}

void EventSimulator::queueCompletion(WaveState &wave, int64_t cycle) {
  if (wave.completionQueued)
    return;
  int64_t complete = std::max(cycle, wave.lastReady);
  if (config.completePendingLdsDmaCounters)
    complete = counterTailCycle(wave, complete);
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
    if (!wave.done && !currentOp(wave)) {
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
    if (!currentOp(wave)) {
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

static int64_t estimateProgramCost(ArrayRef<ProgramItem> program,
                                   const ArchData &arch,
                                   const EventSimConfig &config) {
  EventSimConfig branchConfig = config;
  branchConfig.recordTimeline = false;
  EventSimResult result;
  EventSimulator simulator(program, arch, branchConfig, result);
  if (failed(simulator.run()))
    return kInf;
  return result.totalCycles;
}

} // namespace

LogicalResult simulateEventTimeline(func::FuncOp func, const ArchData &arch,
                                    const EventSimConfig &config,
                                    EventSimResult &out) {
  SmallVector<ProgramItem> program = buildProgram(func, arch, config);
  out = EventSimResult();
  EventSimulator simulator(program, arch, config, out);
  return simulator.run();
}

LogicalResult simulateEventTimeline(ArrayRef<Operation *> ops,
                                    const ArchData &arch,
                                    const EventSimConfig &config,
                                    EventSimResult &out) {
  SmallVector<ProgramItem> program;
  for (Operation *op : ops)
    appendProgramOp(op, arch, config, program);
  out = EventSimResult();
  EventSimulator simulator(program, arch, config, out);
  return simulator.run();
}

} // namespace mlir::waveamdmachine
