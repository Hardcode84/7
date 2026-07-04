//===- WaveAMDMachineGreedySchedule.cpp - Greedy machine scheduler --------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/Wave/Transforms/Passes.h"

#include "WaveAMDMachineScheduleEligibility.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/WaveAMDMachine/CostModel/ArchData.h"
#include "mlir/Dialect/WaveAMDMachine/CostModel/CalibrationData.h"
#include "mlir/Dialect/WaveAMDMachine/CostModel/EventSimulator.h"
#include "mlir/Dialect/WaveAMDMachine/CostModel/LatencyTable.h"
#include "mlir/Dialect/WaveAMDMachine/CostModel/MemoryCounterTiming.h"
#include "mlir/Dialect/WaveAMDMachine/CostModel/OpClassifier.h"
#include "mlir/Dialect/WaveAMDMachine/CostModel/SchedClass.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachine.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachineTarget.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachineTraits.h"
#include "mlir/IR/BuiltinOps.h"
#include "mlir/Support/LLVM.h"
#include "llvm/ADT/BitVector.h"
#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/ADT/SmallPtrSet.h"
#include "llvm/ADT/SmallVector.h"

#include <algorithm>
#include <array>
#include <cstdint>
#include <limits>
#include <optional>

namespace mlir::wave {
#define GEN_PASS_DEF_WAVEAMDMACHINESCHEDULE
#define GEN_PASS_DEF_WAVEAMDMACHINESCHEDULEREPORT
#include "mlir/Dialect/Wave/Transforms/Passes.h.inc"
} // namespace mlir::wave

using namespace mlir;
using namespace mlir::wave;

namespace {

namespace traits = ::mlir::OpTrait::waveamdmachine;

static constexpr StringLiteral kTargetWavesAttr = "waveamdmachine.target_waves";
static constexpr StringLiteral kScheduleInputAttr =
    "waveamdmachine.schedule_input";
static constexpr StringLiteral kReportPrefix =
    "waveamd-machine-schedule-report";
static constexpr size_t kNumScheduleFUs =
    static_cast<size_t>(waveamdmachine::FunctionalUnit::NumFunctionalUnits);

enum class EdgeKind : uint8_t {
  Ssa,
  MemToken,
  Singleton,
  Exec,
  LoopCarry,
};

enum class FillableStallKind : uint8_t {
  None,
  Cycle,
  MemoryToken,
  M0Hazard,
};

struct ScheduleEdge {
  unsigned src = 0;
  unsigned dst = 0;
  EdgeKind kind = EdgeKind::Ssa;
  bool recurrence = false;
};

struct FillableStall {
  FillableStallKind kind = FillableStallKind::None;
  int64_t issueCycle = 0;
};

struct GreedyRegion {
  SmallVector<Operation *, 16> ops;
  func::FuncOp func;
  Block *block = nullptr;
  Operation *first = nullptr;
  Operation *last = nullptr;
  unsigned blockOrdinal = 0;
  unsigned regionOrdinal = 0;
};

struct ArchResolution {
  StringRef reason;
  const waveamdmachine::ArchData *arch = nullptr;
};

struct GraphTables {
  SmallVector<ScheduleEdge, 32> edges;
  SmallVector<SmallVector<unsigned, 4>, 16> successors;
  SmallVector<unsigned, 16> pendingPreds;
};

struct ValueHazards {
  unsigned m0 = 0;
};

struct IssueState {
  DenseMap<Value, int64_t> readyAt;
  DenseMap<Value, int64_t> memoryReadyAt;
  DenseMap<Value, ValueHazards> hazards;
  DenseMap<int64_t, unsigned> cuIssueCounts;
  DenseMap<int64_t, unsigned> cmaIssueCounts;
  std::array<int64_t, kNumScheduleFUs> fuReady = {};
  int64_t issueReady = 0;
  int64_t ldsDmaReady = 0;
};

struct IssuePreview {
  waveamdmachine::SchedClass cls = waveamdmachine::SchedClass::NoInst;
  waveamdmachine::FunctionalUnit fu = waveamdmachine::FunctionalUnit::None;
  int64_t operandWaitCycles = 0;
  int64_t memoryWaitCycles = 0;
  int64_t fuWaitCycles = 0;
  int64_t issueWaitCycles = 0;
  int64_t cuIssueWaitCycles = 0;
  int64_t cmaIssueWaitCycles = 0;
  int64_t ldsDmaWaitCycles = 0;
  unsigned hazardWaitInsts = 0;
  int64_t issueCycle = 0;
  int64_t readyCycle = 0;
  int64_t nextIssueCycle = 0;
  int64_t memoryReadyCycle = 0;
  int64_t memoryValueReadyCycle = 0;
  unsigned issues = 0;
  bool realInst = false;
  bool memoryIssuer = false;
  bool hasMemoryValue = false;
};

struct GreedyStats {
  unsigned filledGaps = 0;
  unsigned unfilledGaps = 0;
  unsigned operandGaps = 0;
  unsigned resourceGaps = 0;
  unsigned cheapHazardGaps = 0;
  unsigned m0Gaps = 0;
  unsigned memoryTokenGaps = 0;
  unsigned barrierMemoryGaps = 0;
  unsigned filledBarrierMemoryGaps = 0;
};

struct GreedyResult {
  SmallVector<unsigned, 16> order;
  SmallVector<unsigned, 8> pendingNodes;
  SmallVector<unsigned, 8> pendingCounts;
  SmallVector<ScheduleEdge, 8> cycleIncoming;
  GreedyStats stats;
  StringRef failureReason;
  bool success = false;
};

struct OrderScore {
  int64_t cycles = 0;
  int64_t issuedOps = 0;
};

struct UnsupportedOption {
  bool enabled = false;
  StringRef name;
};

static bool isMemToken(Value value) {
  return isa<waveamdmachine::MemTokenType>(value.getType());
}

static bool isM0(Value value) {
  return isa<waveamdmachine::M0Type>(value.getType());
}

enum class SingletonKind : uint8_t {
  None,
  Scc,
  Vcc,
  M0,
};

static SingletonKind getSingletonKind(Type type) {
  if (isa<waveamdmachine::M0Type>(type))
    return SingletonKind::M0;
  auto regType = dyn_cast<waveamdmachine::RegType>(type);
  if (!regType)
    return SingletonKind::None;
  switch (regType.getRegClass()) {
  case waveamdmachine::RegClass::SCC:
    return SingletonKind::Scc;
  case waveamdmachine::RegClass::VCC:
    return SingletonKind::Vcc;
  default:
    return SingletonKind::None;
  }
}

static unsigned getSingletonIndex(SingletonKind kind) {
  return static_cast<unsigned>(kind) - 1;
}

static bool isSupportedRegionOp(Operation *op) {
  return isa<waveamdmachine::ExecIfOp, waveamdmachine::UniformIfOp,
             waveamdmachine::UniformLoopOp>(op);
}

static bool isTerminalMachineOp(Operation *op) {
  return isa<waveamdmachine::SEndpgmOp>(op);
}

static LogicalResult validateRegionMember(Operation *op) {
  if (!isSupportedSchedulerRegionMember(op))
    return op->emitError("waveamd-machine-schedule unsupported op: ")
           << op->getName();
  return success();
}

static Attribute findTargetWavesAttr(Operation *op) {
  for (Operation *cur = op; cur; cur = cur->getParentOp())
    if (Attribute attr = cur->getAttr(kTargetWavesAttr))
      return attr;
  return {};
}

static ArchResolution resolveArch(Operation *op) {
  ModuleOp mod = waveamdmachine::findAMDGPUTargetModule(op);
  if (!mod)
    return {"missing_target", nullptr};

  StringAttr target = mod->getAttrOfType<StringAttr>("waveamdmachine.target");
  std::optional<waveamdmachine::AMDGPUTarget> parsed =
      waveamdmachine::parseAMDGPUTargetAttr(target.getValue());
  if (!parsed)
    return {"malformed_target", nullptr};

  llvm::AMDGPU::IsaVersion isa = llvm::AMDGPU::getIsaVersion(parsed->chip);
  if (!waveamdmachine::isArchSupported(isa))
    return {"unsupported_arch", nullptr};
  return {{}, &waveamdmachine::getArchData(isa)};
}

static LogicalResult reportArchFailure(Operation *op, ArchResolution arch) {
  if (arch.arch)
    return success();
  return op->emitError("waveamd-machine-schedule failed: reason=")
         << arch.reason;
}

static LogicalResult
configureModel(Operation *op, int modelWaves, int modelSimds,
               int modelStartDelay,
               waveamdmachine::EventSimConfig &modelConfig) {
  if (modelWaves < 0)
    return op->emitError("model-waves must be non-negative");
  if (modelSimds < 0)
    return op->emitError("model-simds must be non-negative");
  if (modelStartDelay < 0)
    return op->emitError("model-start-delay must be non-negative");

  modelConfig.waves = modelWaves;
  modelConfig.simds = modelSimds;
  modelConfig.startDelay = modelStartDelay;
  modelConfig.completePendingLdsDmaCounters = true;
  modelConfig.ldsDmaIssueInterval = -1;
  modelConfig.cmaIssueInterval = -1;
  return success();
}

static FailureOr<int> validateTargetWaves(Operation *op, ArchResolution arch,
                                          int64_t targetWaves,
                                          StringRef sourceName) {
  if (targetWaves <= 0 ||
      targetWaves > static_cast<int64_t>(std::numeric_limits<int>::max()))
    return op->emitError() << sourceName << " must be positive";
  if (arch.arch && targetWaves > arch.arch->wavesPerSIMD)
    return op->emitError() << sourceName << " exceeds target wave capacity";
  return static_cast<int>(targetWaves);
}

static LogicalResult
finalizeModel(Operation *op, ArchResolution arch,
              waveamdmachine::EventSimConfig &modelConfig) {
  if (modelConfig.waves > 0 && modelConfig.simds > 0)
    return success();

  int simds = modelConfig.simds;
  if (simds == 0)
    simds = arch.arch ? arch.arch->simdsPerCU : 1;

  int waves = modelConfig.waves;
  if (waves == 0) {
    Attribute attr = findTargetWavesAttr(op);
    if (attr && arch.arch) {
      auto intAttr = dyn_cast<IntegerAttr>(attr);
      if (!intAttr)
        return op->emitError()
               << kTargetWavesAttr << " must be an integer attribute";
      FailureOr<int> targetWaves =
          validateTargetWaves(op, arch, intAttr.getInt(), kTargetWavesAttr);
      if (failed(targetWaves))
        return failure();
      waves = *targetWaves * simds;
    } else {
      waves = 1;
    }
  }

  modelConfig.waves = waves;
  modelConfig.simds = simds;
  return success();
}

static LogicalResult checkUnsupportedOptions(Operation *op, StringRef passName,
                                             ArrayRef<UnsupportedOption> opts) {
  for (const UnsupportedOption &opt : opts)
    if (opt.enabled)
      return op->emitError() << passName << " unsupported option: " << opt.name;
  return success();
}

static int getModelLatency(const waveamdmachine::ArchData &arch,
                           waveamdmachine::SchedClass cls,
                           const waveamdmachine::EventSimConfig &config) {
  if (cls == waveamdmachine::SchedClass::NoInst)
    return 0;
  if (config.calibration)
    return waveamdmachine::getCalibratedLatency(arch, cls, *config.calibration);
  return waveamdmachine::getLatency(arch, cls);
}

static unsigned getIssueCount(Operation *op) {
  if (auto info = dyn_cast<waveamdmachine::WaitcntInfoOpInterface>(op))
    return info.getWaitcntInfo().issueCount;
  return 0;
}

static unsigned getIssueSlots(waveamdmachine::SchedClass cls,
                              unsigned issueCount) {
  if (cls == waveamdmachine::SchedClass::NoInst)
    return 0;
  return std::max(1u, issueCount);
}

static int64_t issueCycleAt(int64_t start, unsigned issue, int period) {
  return start + static_cast<int64_t>(issue) * period;
}

static int64_t cuIssueReadyCycle(const IssueState &state,
                                 const waveamdmachine::ArchData &arch,
                                 int64_t cycle, unsigned issues, int period) {
  unsigned cap = static_cast<unsigned>(arch.issuesPerCUPerCycle);
  while (true) {
    std::optional<int64_t> nextStart;
    for (unsigned issue : llvm::seq<unsigned>(0, issues)) {
      int64_t current = issueCycleAt(cycle, issue, period);
      if (state.cuIssueCounts.lookup(current) < cap)
        continue;
      nextStart = current - static_cast<int64_t>(issue) * period + 1;
      break;
    }
    if (!nextStart)
      return cycle;
    cycle = std::max<int64_t>(cycle + 1, *nextStart);
  }
}

static int64_t cmaIssueReadyCycle(const IssueState &state,
                                  const waveamdmachine::ArchData &arch,
                                  const waveamdmachine::EventSimConfig &config,
                                  int64_t cycle, Operation *op,
                                  waveamdmachine::SchedClass cls,
                                  unsigned issues) {
  int interval = waveamdmachine::getEventSimCmaIssueInterval(arch, config);
  unsigned cmaIssues =
      waveamdmachine::getEventSimCmaIssueCount(op, cls, issues);
  if (interval <= 0 || cmaIssues == 0)
    return cycle;

  unsigned cap = waveamdmachine::getEventSimCmaIssueCapacity(arch);
  while (true) {
    std::optional<int64_t> nextStart;
    for (unsigned issue : llvm::seq<unsigned>(0, cmaIssues)) {
      int64_t begin = issueCycleAt(cycle, issue, interval);
      for (unsigned offset :
           llvm::seq<unsigned>(0, static_cast<unsigned>(interval))) {
        int64_t current = begin + offset;
        if (state.cmaIssueCounts.lookup(current) < cap)
          continue;
        nextStart = current - static_cast<int64_t>(issue) * interval -
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

static void consumeCuIssueSlots(IssueState &state,
                                const waveamdmachine::ArchData &arch,
                                int64_t cycle, unsigned issues, int period) {
  for (unsigned issue : llvm::seq<unsigned>(0, issues)) {
    int64_t current = issueCycleAt(cycle, issue, period);
    unsigned &count = state.cuIssueCounts[current];
    assert(count < static_cast<unsigned>(arch.issuesPerCUPerCycle) &&
           "CU issue cap exceeded");
    ++count;
  }
}

static void consumeCmaIssueSlots(IssueState &state,
                                 const waveamdmachine::ArchData &arch,
                                 const waveamdmachine::EventSimConfig &config,
                                 int64_t cycle, Operation *op,
                                 waveamdmachine::SchedClass cls,
                                 unsigned issues) {
  int interval = waveamdmachine::getEventSimCmaIssueInterval(arch, config);
  unsigned cmaIssues =
      waveamdmachine::getEventSimCmaIssueCount(op, cls, issues);
  if (interval <= 0 || cmaIssues == 0)
    return;

  unsigned cap = waveamdmachine::getEventSimCmaIssueCapacity(arch);
  for (unsigned issue : llvm::seq<unsigned>(0, cmaIssues)) {
    int64_t begin = issueCycleAt(cycle, issue, interval);
    for (unsigned offset :
         llvm::seq<unsigned>(0, static_cast<unsigned>(interval))) {
      int64_t current = begin + offset;
      unsigned &count = state.cmaIssueCounts[current];
      assert(count < cap && "CMA issue cap exceeded");
      ++count;
    }
  }
}

static int64_t valueReadyCycle(const IssueState &state, Operation *op) {
  int64_t ready = 0;
  for (Value operand : op->getOperands()) {
    if (isMemToken(operand))
      continue;
    ready = std::max(ready, state.readyAt.lookup(operand));
  }
  return ready;
}

static bool waitsForMemoryTokens(Operation *op) {
  if (isa<waveamdmachine::SBarrierOp, waveamdmachine::TokenJoinOp,
          waveamdmachine::AfterOp>(op))
    return true;
  return false;
}

static int64_t memoryReadyCycle(const IssueState &state, Operation *op) {
  if (!waitsForMemoryTokens(op))
    return 0;
  int64_t ready = 0;
  for (Value operand : op->getOperands())
    if (isMemToken(operand))
      ready = std::max(ready, state.memoryReadyAt.lookup(operand));
  return ready;
}

static ValueHazards joinOperandHazards(const IssueState &state, Operation *op) {
  ValueHazards joined;
  for (Value operand : op->getOperands()) {
    ValueHazards hazards = state.hazards.lookup(operand);
    joined.m0 = std::max(joined.m0, hazards.m0);
  }
  return joined;
}

static unsigned getRequiredM0Wait(Operation *op, const IssueState &state) {
  unsigned wait = 0;
  for (Value operand : op->getOperands())
    if (isM0(operand))
      wait = std::max(wait, state.hazards.lookup(operand).m0);
  return wait;
}

static void decrementHazards(IssueState &state, unsigned count) {
  if (count == 0)
    return;
  for (auto &it : state.hazards)
    it.second.m0 = it.second.m0 > count ? it.second.m0 - count : 0;
}

static void seedProducedHazards(IssueState &state, Operation *op) {
  auto hazardOp = dyn_cast<waveamdmachine::M0WriteHazardOpInterface>(op);
  if (!hazardOp)
    return;
  Value value = hazardOp.getM0HazardValue();
  state.hazards[value].m0 = std::max(state.hazards[value].m0, 1u);
}

static IssuePreview previewIssue(const IssueState &state, Operation *op,
                                 const waveamdmachine::ArchData &arch,
                                 const waveamdmachine::EventSimConfig &config) {
  IssuePreview preview;
  int64_t start = state.issueReady;
  preview.cls = waveamdmachine::classifyOp(op);
  preview.realInst = preview.cls != waveamdmachine::SchedClass::NoInst;
  preview.hazardWaitInsts = getRequiredM0Wait(op, state);
  preview.operandWaitCycles =
      std::max<int64_t>(0, valueReadyCycle(state, op) - start);
  preview.memoryWaitCycles =
      std::max<int64_t>(0, memoryReadyCycle(state, op) - start);

  int64_t ready = start + preview.issueWaitCycles;
  ready = std::max<int64_t>(ready, valueReadyCycle(state, op));
  ready = std::max<int64_t>(ready, memoryReadyCycle(state, op));

  if (!preview.realInst) {
    preview.issueCycle = ready;
    preview.readyCycle = ready;
    preview.nextIssueCycle = start;
    preview.memoryReadyCycle = ready;
    preview.memoryValueReadyCycle = ready;
    return preview;
  }

  preview.fu = waveamdmachine::funit(arch, preview.cls);
  preview.issues = getIssueSlots(preview.cls, getIssueCount(op));
  preview.memoryIssuer = waveamdmachine::getMemoryCounterKind(op) !=
                         waveamdmachine::MemoryCounterKind::None;
  preview.hasMemoryValue = waveamdmachine::hasMemoryValueLatency(op);
  int period = waveamdmachine::getEventSimIssuePeriod(arch, config);
  int latency = getModelLatency(arch, preview.cls, config);

  preview.fuWaitCycles = std::max<int64_t>(
      0, state.fuReady[static_cast<size_t>(preview.fu)] - start);
  ready = std::max(ready, state.fuReady[static_cast<size_t>(preview.fu)]);
  if (waveamdmachine::isLdsDmaIssuer(op)) {
    int interval = waveamdmachine::getEventSimLdsDmaIssueInterval(arch, config);
    if (interval > 0) {
      preview.ldsDmaWaitCycles =
          std::max<int64_t>(0, state.ldsDmaReady - start);
      ready = std::max(ready, state.ldsDmaReady);
    }
  }

  int64_t beforeCma = ready;
  int64_t cmaReady = cmaIssueReadyCycle(state, arch, config, beforeCma, op,
                                        preview.cls, preview.issues);
  preview.cmaIssueWaitCycles = std::max<int64_t>(0, cmaReady - beforeCma);
  int64_t cuReady =
      cuIssueReadyCycle(state, arch, cmaReady, preview.issues, period);
  preview.cuIssueWaitCycles = std::max<int64_t>(0, cuReady - cmaReady);
  preview.issueCycle = cuReady;

  int64_t lastIssue =
      preview.issueCycle + static_cast<int64_t>(preview.issues - 1) * period;
  preview.nextIssueCycle =
      preview.issueCycle + static_cast<int64_t>(preview.issues) * period;
  preview.readyCycle = lastIssue + latency;
  preview.memoryValueReadyCycle =
      preview.hasMemoryValue
          ? lastIssue + waveamdmachine::getMemoryValueLatency(
                            arch, op, config.counterLatencies,
                            config.valueLatencies, config.calibration)
          : preview.readyCycle;
  if (preview.memoryIssuer)
    preview.memoryReadyCycle =
        lastIssue + waveamdmachine::getMemoryCounterLatency(
                        arch, op, config.counterLatencies, config.calibration);
  else
    preview.memoryReadyCycle = preview.readyCycle;
  return preview;
}

static bool stalls(const IssuePreview &preview) {
  return preview.operandWaitCycles != 0 || preview.memoryWaitCycles != 0 ||
         preview.fuWaitCycles != 0 || preview.issueWaitCycles != 0 ||
         preview.cuIssueWaitCycles != 0 || preview.cmaIssueWaitCycles != 0 ||
         preview.ldsDmaWaitCycles != 0 || preview.hazardWaitInsts != 0;
}

static void commitNoInst(IssueState &state, Operation *op,
                         const IssuePreview &preview) {
  ValueHazards inherited = joinOperandHazards(state, op);
  int64_t valueReady = valueReadyCycle(state, op);
  int64_t memoryReady = memoryReadyCycle(state, op);
  for (Value result : op->getResults()) {
    state.readyAt[result] = valueReady;
    if (isMemToken(result))
      state.memoryReadyAt[result] = memoryReady;
    if (isM0(result))
      state.hazards[result] = inherited;
  }
  seedProducedHazards(state, op);
  (void)preview;
}

static void commitIssue(IssueState &state, Operation *op,
                        const IssuePreview &preview,
                        const waveamdmachine::ArchData &arch,
                        const waveamdmachine::EventSimConfig &config) {
  if (!preview.realInst) {
    commitNoInst(state, op, preview);
    return;
  }

  int period = waveamdmachine::getEventSimIssuePeriod(arch, config);
  state.issueReady = preview.nextIssueCycle;
  state.fuReady[static_cast<size_t>(preview.fu)] = preview.nextIssueCycle;
  consumeCuIssueSlots(state, arch, preview.issueCycle, preview.issues, period);
  consumeCmaIssueSlots(state, arch, config, preview.issueCycle, op, preview.cls,
                       preview.issues);
  if (waveamdmachine::isLdsDmaIssuer(op)) {
    int interval = waveamdmachine::getEventSimLdsDmaIssueInterval(arch, config);
    if (interval > 0)
      state.ldsDmaReady =
          preview.issueCycle + static_cast<int64_t>(preview.issues) * interval;
  }

  decrementHazards(state, 1);
  for (Value result : op->getResults()) {
    int64_t resultReady = preview.readyCycle;
    if (preview.hasMemoryValue && !isMemToken(result))
      resultReady = preview.memoryValueReadyCycle;
    state.readyAt[result] = resultReady;
    if (isMemToken(result))
      state.memoryReadyAt[result] = preview.memoryReadyCycle;
  }
  seedProducedHazards(state, op);
}

static void addEdge(GraphTables &graph, unsigned src, unsigned dst,
                    EdgeKind kind, bool recurrence = false) {
  if (src == dst && !recurrence)
    return;
  for (const ScheduleEdge &edge : graph.edges)
    if (edge.src == src && edge.dst == dst && edge.kind == kind &&
        edge.recurrence == recurrence)
      return;
  graph.edges.push_back({src, dst, kind, recurrence});
  if (recurrence)
    return;
  graph.successors[src].push_back(dst);
  ++graph.pendingPreds[dst];
}

static StringRef edgeKindName(EdgeKind kind) {
  switch (kind) {
  case EdgeKind::Ssa:
    return "ssa";
  case EdgeKind::MemToken:
    return "mem_token";
  case EdgeKind::Singleton:
    return "singleton";
  case EdgeKind::Exec:
    return "exec";
  case EdgeKind::LoopCarry:
    return "loop_carry";
  }
  llvm_unreachable("unknown edge kind");
}

static void
addSingletonReadEdges(Operation *op, unsigned index, GraphTables &graph,
                      DenseMap<Operation *, unsigned> &node,
                      const std::array<std::optional<unsigned>, 3> &lastWriter,
                      std::array<SmallVector<unsigned, 4>, 3> &readers) {
  llvm::SmallPtrSet<Type, 4> seenReadTypes;
  for (Value operand : op->getOperands()) {
    SingletonKind kind = getSingletonKind(operand.getType());
    if (kind == SingletonKind::None)
      continue;
    if (!seenReadTypes.insert(operand.getType()).second)
      continue;
    unsigned kindIndex = getSingletonIndex(kind);
    Operation *def = operand.getDefiningOp();
    auto defIt = def ? node.find(def) : node.end();
    if (lastWriter[kindIndex] &&
        (defIt == node.end() || *lastWriter[kindIndex] != defIt->second))
      addEdge(graph, *lastWriter[kindIndex], index, EdgeKind::Singleton);
    if (!llvm::is_contained(readers[kindIndex], index))
      readers[kindIndex].push_back(index);
  }
}

static void
addSingletonWriteEdges(Operation *op, unsigned index, GraphTables &graph,
                       std::array<std::optional<unsigned>, 3> &lastWriter,
                       std::array<SmallVector<unsigned, 4>, 3> &readers) {
  llvm::SmallPtrSet<Type, 4> seenWriteTypes;
  for (Value result : op->getResults()) {
    SingletonKind kind = getSingletonKind(result.getType());
    if (kind == SingletonKind::None)
      continue;
    if (!seenWriteTypes.insert(result.getType()).second)
      continue;
    unsigned kindIndex = getSingletonIndex(kind);
    if (lastWriter[kindIndex])
      addEdge(graph, *lastWriter[kindIndex], index, EdgeKind::Singleton);
    for (unsigned reader : readers[kindIndex])
      addEdge(graph, reader, index, EdgeKind::Singleton);
    readers[kindIndex].clear();
    lastWriter[kindIndex] = index;
  }
}

static LogicalResult addSingletonEdges(const GreedyRegion &region,
                                       GraphTables &graph,
                                       DenseMap<Operation *, unsigned> &node) {
  std::array<std::optional<unsigned>, 3> lastWriter;
  std::array<SmallVector<unsigned, 4>, 3> readers;

  for (auto [index, op] : llvm::enumerate(region.ops)) {
    addSingletonReadEdges(op, index, graph, node, lastWriter, readers);
    addSingletonWriteEdges(op, index, graph, lastWriter, readers);
  }
  return success();
}

static void addExecEdges(const GreedyRegion &region, GraphTables &graph) {
  std::optional<unsigned> lastWriter;
  SmallVector<unsigned, 8> readers;

  for (auto [index, op] : llvm::enumerate(region.ops)) {
    bool reads = op->hasTrait<traits::ReadsExecOp>();
    bool writes = op->hasTrait<traits::WritesExecOp>();

    if (reads && lastWriter)
      addEdge(graph, *lastWriter, index, EdgeKind::Exec);
    if (writes) {
      if (lastWriter)
        addEdge(graph, *lastWriter, index, EdgeKind::Exec);
      for (unsigned reader : readers)
        addEdge(graph, reader, index, EdgeKind::Exec);
      readers.clear();
      lastWriter = index;
      continue;
    }
    if (reads && !llvm::is_contained(readers, index))
      readers.push_back(index);
  }
}

static void addLoopCarryEdges(const GreedyRegion &region, GraphTables &graph,
                              DenseMap<Operation *, unsigned> &node) {
  Operation *parent = region.block ? region.block->getParentOp() : nullptr;
  waveamdmachine::UniformLoopOp loop =
      dyn_cast_if_present<waveamdmachine::UniformLoopOp>(parent);
  if (!loop)
    return;
  waveamdmachine::ContinueIfOp terminator =
      dyn_cast<waveamdmachine::ContinueIfOp>(region.block->getTerminator());
  if (!terminator)
    return;

  for (auto [arg, carry] :
       llvm::zip(region.block->getArguments(), terminator.getCarries())) {
    Operation *def = carry.getDefiningOp();
    auto defIt = def ? node.find(def) : node.end();
    if (defIt == node.end())
      continue;
    for (OpOperand &use : arg.getUses()) {
      auto useIt = node.find(use.getOwner());
      if (useIt == node.end())
        continue;
      addEdge(graph, defIt->second, useIt->second, EdgeKind::LoopCarry,
              /*recurrence=*/true);
    }
  }
}

static LogicalResult buildGraph(const GreedyRegion &region,
                                GraphTables &graph) {
  graph.successors.resize(region.ops.size());
  graph.pendingPreds.assign(region.ops.size(), 0);

  DenseMap<Operation *, unsigned> node;
  for (auto [index, op] : llvm::enumerate(region.ops))
    node[op] = index;

  for (auto [dst, op] : llvm::enumerate(region.ops)) {
    for (Value operand : op->getOperands()) {
      Operation *def = operand.getDefiningOp();
      if (!def)
        continue;
      auto it = node.find(def);
      if (it == node.end())
        continue;
      addEdge(graph, it->second, dst,
              isMemToken(operand) ? EdgeKind::MemToken : EdgeKind::Ssa);
    }
  }

  if (failed(addSingletonEdges(region, graph, node)))
    return failure();
  addExecEdges(region, graph);
  addLoopCarryEdges(region, graph, node);
  for (SmallVector<unsigned, 4> &succs : graph.successors)
    llvm::sort(succs);
  return success();
}

static SmallVector<unsigned, 16> getOriginalOrder(const GreedyRegion &region) {
  SmallVector<unsigned, 16> order;
  for (unsigned index : llvm::seq<unsigned>(0, region.ops.size()))
    order.push_back(index);
  return order;
}

static bool sameOrder(ArrayRef<unsigned> lhs, ArrayRef<unsigned> rhs) {
  return lhs.size() == rhs.size() &&
         std::equal(lhs.begin(), lhs.end(), rhs.begin());
}

static StringRef getRegionFuncName(const GreedyRegion &region) {
  StringAttr funcName = region.func->getAttrOfType<StringAttr>("sym_name");
  return funcName ? funcName.getValue() : StringRef("<unknown>");
}

static unsigned findFirstUnscheduled(const BitVector &scheduled) {
  for (unsigned index : llvm::seq<unsigned>(0, scheduled.size()))
    if (!scheduled.test(index))
      return index;
  return scheduled.size();
}

static unsigned findFirstReadyByOriginal(const BitVector &ready) {
  for (unsigned index : llvm::seq<unsigned>(0, ready.size()))
    if (ready.test(index))
      return index;
  return ready.size();
}

static void recordGapStats(Operation *op, const IssuePreview &preview,
                           GreedyStats &stats) {
  if (preview.operandWaitCycles != 0)
    ++stats.operandGaps;
  if (preview.memoryWaitCycles != 0) {
    ++stats.memoryTokenGaps;
    if (isa<waveamdmachine::SBarrierOp>(op))
      ++stats.barrierMemoryGaps;
  }
  if (preview.fuWaitCycles != 0 || preview.cuIssueWaitCycles != 0 ||
      preview.cmaIssueWaitCycles != 0 || preview.ldsDmaWaitCycles != 0)
    ++stats.resourceGaps;
  if (preview.hazardWaitInsts != 0) {
    ++stats.cheapHazardGaps;
    ++stats.m0Gaps;
  }
}

static bool filledOnlyM0HazardGaps(const GreedyStats &stats) {
  return stats.m0Gaps != 0 && stats.cheapHazardGaps == stats.m0Gaps &&
         stats.filledGaps >= stats.m0Gaps && stats.unfilledGaps == 0 &&
         stats.resourceGaps == 0 && stats.memoryTokenGaps == 0;
}

static bool filledBarrierMemoryGap(const GreedyStats &stats) {
  return stats.filledBarrierMemoryGaps != 0;
}

static bool hasNonMemoryCycleWait(const IssuePreview &preview) {
  return preview.operandWaitCycles != 0 || preview.fuWaitCycles != 0 ||
         preview.issueWaitCycles != 0 || preview.cuIssueWaitCycles != 0 ||
         preview.cmaIssueWaitCycles != 0 || preview.ldsDmaWaitCycles != 0;
}

static FillableStall getFillableStall(const IssuePreview &preview) {
  if (preview.memoryWaitCycles != 0)
    return {FillableStallKind::MemoryToken, preview.issueCycle};
  if (hasNonMemoryCycleWait(preview))
    return {FillableStallKind::Cycle, preview.issueCycle};
  if (preview.hazardWaitInsts != 0)
    return {FillableStallKind::M0Hazard, preview.issueCycle};
  return {};
}

static bool fillsStall(FillableStall stall, const IssuePreview &candidate) {
  if (stall.kind == FillableStallKind::None || !candidate.realInst ||
      stalls(candidate))
    return false;
  if (stall.kind == FillableStallKind::Cycle)
    return candidate.nextIssueCycle <= stall.issueCycle;
  return true;
}

static unsigned findStallFiller(const BitVector &ready, unsigned next,
                                const GreedyRegion &region,
                                const IssueState &state,
                                const waveamdmachine::ArchData &arch,
                                const waveamdmachine::EventSimConfig &cfg,
                                FillableStall stall) {
  for (unsigned index : llvm::seq<unsigned>(0, ready.size())) {
    if (!ready.test(index) || index == next)
      continue;
    IssuePreview preview = previewIssue(state, region.ops[index], arch, cfg);
    if (fillsStall(stall, preview))
      return index;
  }
  return ready.size();
}

static unsigned findFirstReadyNoInst(const BitVector &ready,
                                     const GreedyRegion &region) {
  for (unsigned index : llvm::seq<unsigned>(0, ready.size())) {
    if (!ready.test(index))
      continue;
    if (waveamdmachine::classifyOp(region.ops[index]) ==
        waveamdmachine::SchedClass::NoInst)
      return index;
  }
  return ready.size();
}

static void markScheduled(unsigned node, const GraphTables &graph,
                          BitVector &ready, BitVector &scheduled,
                          SmallVectorImpl<unsigned> &pending) {
  ready.reset(node);
  scheduled.set(node);
  for (unsigned succ : graph.successors[node]) {
    assert(pending[succ] > 0 && "successor predecessor count underflow");
    --pending[succ];
    if (pending[succ] == 0 && !scheduled.test(succ))
      ready.set(succ);
  }
}

static void recordDependencyCycle(const GraphTables &graph,
                                  const BitVector &scheduled,
                                  ArrayRef<unsigned> pending,
                                  GreedyResult &result) {
  result.failureReason = "dependency_cycle";
  for (unsigned index : llvm::seq<unsigned>(0, scheduled.size())) {
    if (scheduled.test(index) || pending[index] == 0)
      continue;
    result.pendingNodes.push_back(index);
    result.pendingCounts.push_back(pending[index]);
    if (result.pendingNodes.size() == 8)
      break;
  }
  for (const ScheduleEdge &edge : graph.edges) {
    if (edge.recurrence || scheduled.test(edge.src) || scheduled.test(edge.dst))
      continue;
    result.cycleIncoming.push_back(edge);
    if (result.cycleIncoming.size() == 16)
      break;
  }
}

static void scheduleReadyNode(
    unsigned selected, const GreedyRegion &region, const GraphTables &graph,
    const waveamdmachine::ArchData &arch,
    const waveamdmachine::EventSimConfig &config, IssueState &state,
    BitVector &ready, BitVector &scheduled, SmallVectorImpl<unsigned> &pending,
    SmallVectorImpl<unsigned> &order, const IssuePreview &preview) {
  order.push_back(selected);
  commitIssue(state, region.ops[selected], preview, arch, config);
  markScheduled(selected, graph, ready, scheduled, pending);
}

static void drainReadyNoInsts(const GreedyRegion &region,
                              const GraphTables &graph,
                              const waveamdmachine::ArchData &arch,
                              const waveamdmachine::EventSimConfig &config,
                              IssueState &state, BitVector &ready,
                              BitVector &scheduled,
                              SmallVectorImpl<unsigned> &pending,
                              SmallVectorImpl<unsigned> &order) {
  while (true) {
    unsigned selected = findFirstReadyNoInst(ready, region);
    if (selected == region.ops.size())
      return;
    IssuePreview preview =
        previewIssue(state, region.ops[selected], arch, config);
    scheduleReadyNode(selected, region, graph, arch, config, state, ready,
                      scheduled, pending, order, preview);
  }
}

static bool
fillStallBeforeNext(const GreedyRegion &region, const GraphTables &graph,
                    const waveamdmachine::ArchData &arch,
                    const waveamdmachine::EventSimConfig &config,
                    IssueState &state, BitVector &ready, BitVector &scheduled,
                    SmallVectorImpl<unsigned> &pending,
                    SmallVectorImpl<unsigned> &order, GreedyStats &stats,
                    unsigned next, IssuePreview &nextPreview) {
  while (true) {
    nextPreview = previewIssue(state, region.ops[next], arch, config);
    if (!stalls(nextPreview))
      return true;

    recordGapStats(region.ops[next], nextPreview, stats);
    FillableStall stall = getFillableStall(nextPreview);
    unsigned filler =
        findStallFiller(ready, next, region, state, arch, config, stall);
    if (filler == region.ops.size()) {
      ++stats.unfilledGaps;
      return true;
    }

    ++stats.filledGaps;
    if (nextPreview.memoryWaitCycles != 0 &&
        isa<waveamdmachine::SBarrierOp>(region.ops[next]))
      ++stats.filledBarrierMemoryGaps;
    IssuePreview fillerPreview =
        previewIssue(state, region.ops[filler], arch, config);
    scheduleReadyNode(filler, region, graph, arch, config, state, ready,
                      scheduled, pending, order, fillerPreview);
    drainReadyNoInsts(region, graph, arch, config, state, ready, scheduled,
                      pending, order);
    if (scheduled.test(next) || !ready.test(next))
      return false;
  }
}

static GreedyResult
buildGreedyOrder(const GreedyRegion &region, const GraphTables &graph,
                 const waveamdmachine::ArchData &arch,
                 const waveamdmachine::EventSimConfig &config) {
  GreedyResult result;
  SmallVector<unsigned, 16> pending = graph.pendingPreds;
  BitVector ready(region.ops.size());
  BitVector scheduled(region.ops.size());
  for (auto [index, count] : llvm::enumerate(pending))
    if (count == 0)
      ready.set(index);

  IssueState state;
  while (result.order.size() != region.ops.size()) {
    drainReadyNoInsts(region, graph, arch, config, state, ready, scheduled,
                      pending, result.order);
    if (result.order.size() == region.ops.size())
      break;
    if (!ready.any()) {
      recordDependencyCycle(graph, scheduled, pending, result);
      return result;
    }

    IssuePreview preview;
    unsigned next = findFirstUnscheduled(scheduled);
    if (!ready.test(next)) {
      unsigned selected = findFirstReadyByOriginal(ready);
      preview = previewIssue(state, region.ops[selected], arch, config);
      scheduleReadyNode(selected, region, graph, arch, config, state, ready,
                        scheduled, pending, result.order, preview);
      continue;
    }

    if (!fillStallBeforeNext(region, graph, arch, config, state, ready,
                             scheduled, pending, result.order, result.stats,
                             next, preview))
      continue;

    if (scheduled.test(next))
      continue;
    scheduleReadyNode(next, region, graph, arch, config, state, ready,
                      scheduled, pending, result.order, preview);
  }

  result.success = true;
  return result;
}

static void materializeOrder(const GreedyRegion &region,
                             ArrayRef<unsigned> order,
                             SmallVectorImpl<Operation *> &ops) {
  ops.clear();
  for (unsigned index : order)
    ops.push_back(region.ops[index]);
}

static int64_t estimateM0HazardCycles(ArrayRef<Operation *> ops) {
  IssueState state;
  int64_t cycles = 0;
  for (Operation *op : ops) {
    unsigned wait = getRequiredM0Wait(op, state);
    cycles += wait;
    decrementHazards(state, wait);
    waveamdmachine::SchedClass cls = waveamdmachine::classifyOp(op);
    if (cls == waveamdmachine::SchedClass::NoInst) {
      ValueHazards inherited = joinOperandHazards(state, op);
      for (Value result : op->getResults())
        if (isM0(result))
          state.hazards[result] = inherited;
      seedProducedHazards(state, op);
      continue;
    }
    decrementHazards(state, 1);
    seedProducedHazards(state, op);
  }
  return cycles;
}

static FailureOr<OrderScore>
evaluateOrderScore(ArrayRef<Operation *> ops,
                   const waveamdmachine::ArchData &arch,
                   const waveamdmachine::EventSimConfig &config);

static FailureOr<OrderScore>
evaluateOrderScore(ArrayRef<Operation *> ops,
                   const waveamdmachine::ArchData &arch,
                   const waveamdmachine::EventSimConfig &config) {
  waveamdmachine::EventSimResult result;
  if (failed(waveamdmachine::simulateEventTimeline(ops, arch, config, result)))
    return failure();
  OrderScore score;
  score.cycles = result.totalCycles + estimateM0HazardCycles(ops);
  score.issuedOps = result.issuedOps;
  return score;
}

static void applyOrder(const GreedyRegion &region, ArrayRef<unsigned> order) {
  Block *block = region.block;
  Block::iterator insertIt = region.first->getIterator();
  for (unsigned index : order) {
    Operation *op = region.ops[index];
    if (op->getIterator() != insertIt)
      op->moveBefore(block, insertIt);
    insertIt = std::next(op->getIterator());
  }
}

static void printDecision(const GreedyRegion &region, StringRef action,
                          StringRef reason, const GreedyStats &stats) {
  StringAttr funcName = region.func->getAttrOfType<StringAttr>("sym_name");
  llvm::errs() << "waveamd-machine-schedule region func="
               << (funcName ? funcName.getValue() : StringRef("<unknown>"))
               << " index=" << region.regionOrdinal
               << " ops=" << region.ops.size() << " action=" << action
               << " reason=" << reason << " filled_gaps=" << stats.filledGaps
               << " unfilled_gaps=" << stats.unfilledGaps
               << " operand_gaps=" << stats.operandGaps
               << " resource_gaps=" << stats.resourceGaps
               << " cheap_hazard_gaps=" << stats.cheapHazardGaps
               << " m0_gaps=" << stats.m0Gaps
               << " memory_token_gaps=" << stats.memoryTokenGaps
               << " barrier_memory_gaps=" << stats.barrierMemoryGaps
               << " filled_barrier_memory_gaps="
               << stats.filledBarrierMemoryGaps << "\n";
}

struct RegionCollector {
  FailureOr<SmallVector<GreedyRegion, 16>> collect(func::FuncOp func) {
    this->func = func;
    for (Block &block : func.getBody())
      if (failed(collectBlock(block)))
        return failure();
    return std::move(regions);
  }

  void flush(Block &block, unsigned thisBlockOrdinal,
             SmallVector<Operation *, 16> &ops) {
    if (ops.empty())
      return;
    GreedyRegion region;
    region.ops = std::move(ops);
    region.func = func;
    region.block = &block;
    region.first = region.ops.front();
    region.last = region.ops.back();
    region.blockOrdinal = thisBlockOrdinal;
    region.regionOrdinal = nextRegion++;
    regions.push_back(std::move(region));
    ops.clear();
  }

  LogicalResult collectNestedRegionOp(Operation &op) {
    if (!isWaveAMDMachineOpForScheduling(&op) || !isSupportedRegionOp(&op))
      return op.emitError("waveamd-machine-schedule unsupported region op: ")
             << op.getName();
    for (Region &nested : op.getRegions())
      for (Block &nestedBlock : nested)
        if (failed(collectBlock(nestedBlock)))
          return failure();
    return success();
  }

  LogicalResult collectOp(Operation &op, Block &block,
                          unsigned thisBlockOrdinal,
                          SmallVector<Operation *, 16> &ops,
                          bool &sawTerminalMachineOp) {
    if (op.hasTrait<OpTrait::IsTerminator>()) {
      flush(block, thisBlockOrdinal, ops);
      return success();
    }
    if (isTerminalMachineOp(&op)) {
      flush(block, thisBlockOrdinal, ops);
      sawTerminalMachineOp = true;
      return success();
    }
    if (sawTerminalMachineOp)
      return op.emitError("waveamd-machine-schedule op after block-ending "
                          "machine terminator: ")
             << op.getName();
    if (op.getNumRegions() != 0) {
      flush(block, thisBlockOrdinal, ops);
      return collectNestedRegionOp(op);
    }
    if (failed(validateRegionMember(&op)))
      return failure();
    ops.push_back(&op);
    return success();
  }

  LogicalResult collectBlock(Block &block) {
    SmallVector<Operation *, 16> ops;
    bool sawTerminalMachineOp = false;
    unsigned thisBlockOrdinal = blockOrdinal++;
    for (Operation &op : block)
      if (failed(collectOp(op, block, thisBlockOrdinal, ops,
                           sawTerminalMachineOp)))
        return failure();
    flush(block, thisBlockOrdinal, ops);
    return success();
  }

  SmallVector<GreedyRegion, 16> regions;
  func::FuncOp func;
  unsigned blockOrdinal = 0;
  unsigned nextRegion = 0;
};

static bool hasAnyWaveMachineOp(func::FuncOp func) {
  bool found = false;
  func.walk([&](Operation *op) {
    if (op != func.getOperation() && isWaveAMDMachineOpForScheduling(op))
      found = true;
  });
  return found;
}

struct WaveAMDMachineSchedulePass
    : public wave::impl::WaveAMDMachineScheduleBase<
          WaveAMDMachineSchedulePass> {
  using WaveAMDMachineScheduleBase::WaveAMDMachineScheduleBase;

  void runOnOperation() override {
    Operation *root = getOperation();
    if (failed(validateOldOptions(root)))
      return signalPassFailure();

    waveamdmachine::EventSimConfig modelConfig;
    if (failed(configureModel(root, modelWaves, modelSimds, modelStartDelay,
                              modelConfig)))
      return signalPassFailure();

    WalkResult walk = root->walk(
        [&](func::FuncOp func) { return processFunction(func, modelConfig); });
    if (walk.wasInterrupted())
      return signalPassFailure();
  }

  LogicalResult validateOldOptions(Operation *op) {
    if (maxRegionOps < -1)
      return op->emitError("max-region-ops must be -1 or non-negative");
    UnsupportedOption opts[] = {
        {barrieredLdsDmaHoist, "barriered-lds-dma-hoist"},
        {beamSearch, "beam-search"},
        {maxBeamWork != -1, "max-beam-work"},
        {pressureAwareSelection, "pressure-aware-selection"},
        {pressureVgprBudget != -1, "pressure-vgpr-budget"},
        {pressureSgprBudget != -1, "pressure-sgpr-budget"},
        {pressureCriticalVgprBudget != -1, "pressure-critical-vgpr-budget"},
        {pressureCriticalSgprBudget != -1, "pressure-critical-sgpr-budget"},
        {pressureTargetWavesOverride != -2, "pressure-target-waves-override"},
    };
    return checkUnsupportedOptions(op, "waveamd-machine-schedule", opts);
  }

  WalkResult
  processFunction(func::FuncOp func,
                  const waveamdmachine::EventSimConfig &modelConfig) {
    if (!shouldScheduleFunction(func))
      return WalkResult::advance();

    ArchResolution arch = resolveArch(func);
    if (failed(reportArchFailure(func, arch)))
      return WalkResult::interrupt();

    waveamdmachine::EventSimConfig funcConfig = modelConfig;
    if (failed(finalizeModel(func, arch, funcConfig)))
      return WalkResult::interrupt();
    if (!applySchedule)
      return WalkResult::advance();
    func->removeAttr(kScheduleInputAttr);

    FailureOr<SmallVector<GreedyRegion, 16>> collected =
        RegionCollector().collect(func);
    if (failed(collected))
      return WalkResult::interrupt();
    for (const GreedyRegion &region : *collected)
      if (failed(processRegion(region, *arch.arch, funcConfig)))
        return WalkResult::interrupt();
    return WalkResult::advance();
  }

  bool shouldScheduleFunction(func::FuncOp func) const {
    if (func.isExternal() || !hasAnyWaveMachineOp(func))
      return false;
    return !applySchedule || !requireSelectedInput ||
           func->hasAttr(kScheduleInputAttr);
  }

  LogicalResult emitGreedyFailure(const GreedyRegion &region,
                                  const GreedyResult &greedy) {
    InFlightDiagnostic diag =
        region.first->emitError("waveamd-machine-schedule failed: reason=")
        << greedy.failureReason;
    for (auto [index, count] :
         llvm::zip_equal(greedy.pendingNodes, greedy.pendingCounts))
      diag.attachNote(region.ops[index]->getLoc())
          << "pending node " << index << ": " << region.ops[index]->getName()
          << " remaining-predecessors=" << count;
    for (const ScheduleEdge &edge : greedy.cycleIncoming)
      diag.attachNote(region.ops[edge.dst]->getLoc())
          << "incoming edge " << edge.src << " -> " << edge.dst
          << " kind=" << edgeKindName(edge.kind);
    return failure();
  }

  LogicalResult applyGreedyOrder(const GreedyRegion &region,
                                 ArrayRef<unsigned> originalOrder,
                                 const GreedyResult &greedy) {
    if (sameOrder(originalOrder, greedy.order)) {
      printDecision(region, "keep", "same_order", greedy.stats);
      return success();
    }

    StringRef reason = "greedy";
    if (filledOnlyM0HazardGaps(greedy.stats))
      reason = "m0_hazard";
    else if (filledBarrierMemoryGap(greedy.stats))
      reason = "barrier_memory";
    printDecision(region, "apply", reason, greedy.stats);
    applyOrder(region, greedy.order);
    return success();
  }

  LogicalResult processRegion(const GreedyRegion &region,
                              const waveamdmachine::ArchData &arch,
                              const waveamdmachine::EventSimConfig &config) {
    if (maxRegionOps >= 0 &&
        region.ops.size() > static_cast<unsigned>(maxRegionOps))
      return success();

    GraphTables graph;
    if (failed(buildGraph(region, graph)))
      return failure();

    GreedyResult greedy = buildGreedyOrder(region, graph, arch, config);
    if (!greedy.success)
      return emitGreedyFailure(region, greedy);

    SmallVector<unsigned, 16> originalOrder = getOriginalOrder(region);
    return applyGreedyOrder(region, originalOrder, greedy);
  }
};

static unsigned countInstructionOps(const GreedyRegion &region) {
  return llvm::count_if(region.ops, [](Operation *op) {
    return waveamdmachine::classifyOp(op) != waveamdmachine::SchedClass::NoInst;
  });
}

static void printOrder(ArrayRef<unsigned> order) {
  for (auto [index, node] : llvm::enumerate(order)) {
    if (index != 0)
      llvm::errs() << ",";
    llvm::errs() << node;
  }
}

static void printReportRegion(const GreedyRegion &region) {
  llvm::errs() << kReportPrefix << " region func=" << getRegionFuncName(region)
               << " block=" << region.blockOrdinal
               << " region=" << region.regionOrdinal
               << " ops=" << region.ops.size()
               << " instruction_ops=" << countInstructionOps(region)
               << " first=" << region.first->getName().getStringRef()
               << " last=" << region.last->getName().getStringRef() << "\n";
}

static void printReportClasses(const GreedyRegion &region,
                               const waveamdmachine::ArchData &arch,
                               const waveamdmachine::EventSimConfig &config) {
  for (auto [index, op] : llvm::enumerate(region.ops)) {
    waveamdmachine::SchedClass cls = waveamdmachine::classifyOp(op);
    waveamdmachine::FunctionalUnit fu = waveamdmachine::funit(arch, cls);
    llvm::errs() << kReportPrefix << " op func=" << getRegionFuncName(region)
                 << " region=" << region.regionOrdinal << " index=" << index
                 << " name=" << op->getName().getStringRef()
                 << " class=" << waveamdmachine::getSchedClassName(cls)
                 << " fu=" << waveamdmachine::getFunctionalUnitName(fu)
                 << " latency=" << getModelLatency(arch, cls, config) << "\n";
  }
}

static void printReportDeps(const GreedyRegion &region,
                            const GraphTables &graph) {
  llvm::errs() << kReportPrefix << " deps func=" << getRegionFuncName(region)
               << " region=" << region.regionOrdinal
               << " nodes=" << region.ops.size()
               << " edges=" << graph.edges.size() << "\n";
  for (const ScheduleEdge &edge : graph.edges) {
    llvm::errs() << kReportPrefix << " edge region=" << region.regionOrdinal
                 << " kind=" << edgeKindName(edge.kind);
    if (edge.recurrence)
      llvm::errs() << " recurrence";
    llvm::errs() << " " << edge.src << "->" << edge.dst
                 << " src=" << region.ops[edge.src]->getName().getStringRef()
                 << " dst=" << region.ops[edge.dst]->getName().getStringRef()
                 << "\n";
  }
}

static void printReportSkip(const GreedyRegion &region, int maxRegionOps) {
  llvm::errs() << kReportPrefix << " skipped func=" << getRegionFuncName(region)
               << " region=" << region.regionOrdinal
               << " reason=max_region_ops ops=" << region.ops.size()
               << " instruction_ops=" << countInstructionOps(region)
               << " limit=" << maxRegionOps << "\n";
}

static FailureOr<SmallVector<unsigned, 16>> parseScoreOrder(StringRef text) {
  SmallVector<unsigned, 16> order;
  if (text.empty())
    return order;
  SmallVector<StringRef, 16> pieces;
  text.split(pieces, ",");
  for (StringRef piece : pieces) {
    unsigned index = 0;
    if (piece.getAsInteger(10, index))
      return failure();
    order.push_back(index);
  }
  return order;
}

static bool buildCandidateOps(const GreedyRegion &region,
                              const GraphTables &graph,
                              ArrayRef<unsigned> order,
                              SmallVectorImpl<Operation *> &ops) {
  if (order.size() != region.ops.size())
    return false;
  BitVector seen(region.ops.size());
  SmallVector<unsigned, 16> position(region.ops.size());
  for (auto [pos, node] : llvm::enumerate(order)) {
    if (node >= region.ops.size() || seen.test(node))
      return false;
    seen.set(node);
    position[node] = pos;
    ops.push_back(region.ops[node]);
  }
  for (const ScheduleEdge &edge : graph.edges)
    if (!edge.recurrence && position[edge.src] > position[edge.dst])
      return false;
  return true;
}

static void printScoreLine(const GreedyRegion &region, StringRef name,
                           FailureOr<OrderScore> score) {
  llvm::errs() << kReportPrefix << " score func=" << getRegionFuncName(region)
               << " region=" << region.regionOrdinal << " order=" << name;
  if (failed(score)) {
    llvm::errs() << " fallback=original reason=simulation_failed\n";
    return;
  }
  llvm::errs() << " cycles=" << score->cycles
               << " issued_ops=" << score->issuedOps << "\n";
}

static void printFallbackScore(const GreedyRegion &region, StringRef reason) {
  llvm::errs() << kReportPrefix << " score func=" << getRegionFuncName(region)
               << " region=" << region.regionOrdinal
               << " order=original fallback=original reason=" << reason << "\n";
}

static bool isSelectedReportRegion(const GreedyRegion &region,
                                   StringRef scoreFunc, int scoreRegion) {
  if (!scoreFunc.empty() && getRegionFuncName(region) != scoreFunc)
    return false;
  if (scoreRegion >= 0 &&
      region.regionOrdinal != static_cast<unsigned>(scoreRegion))
    return false;
  return true;
}

struct WaveAMDMachineScheduleReportPass
    : public wave::impl::WaveAMDMachineScheduleReportBase<
          WaveAMDMachineScheduleReportPass> {
  using WaveAMDMachineScheduleReportBase::WaveAMDMachineScheduleReportBase;

  void runOnOperation() override {
    if (!hasAnyOutput())
      return;
    Operation *root = getOperation();
    if (failed(validateOptions(root)))
      return signalPassFailure();

    waveamdmachine::EventSimConfig modelConfig;
    if (failed(configureModel(root, modelWaves, modelSimds, modelStartDelay,
                              modelConfig)))
      return signalPassFailure();

    FailureOr<SmallVector<unsigned, 16>> parsedOrder =
        parseScoreOrder(StringRef(scoreOrder));
    if (failed(parsedOrder)) {
      root->emitError("waveamd-machine-schedule-report invalid score-order");
      return signalPassFailure();
    }

    WalkResult walk = root->walk([&](func::FuncOp func) {
      return processFunction(func, modelConfig, *parsedOrder);
    });
    if (walk.wasInterrupted())
      return signalPassFailure();
  }

  bool hasAnyOutput() const {
    return printRegions || printDeps || printScore || printCandidates ||
           printClasses || !scoreOrder.empty();
  }

  LogicalResult validateOptions(Operation *op) {
    if (maxRegionOps < -1)
      return op->emitError("max-region-ops must be -1 or non-negative");
    UnsupportedOption opts[] = {
        {beamSearch, "beam-search"},
        {maxBeamWork != -1, "max-beam-work"},
        {pressureAwareSelection, "pressure-aware-selection"},
        {pressureVgprBudget != -1, "pressure-vgpr-budget"},
        {pressureSgprBudget != -1, "pressure-sgpr-budget"},
        {pressureCriticalVgprBudget != -1, "pressure-critical-vgpr-budget"},
        {pressureCriticalSgprBudget != -1, "pressure-critical-sgpr-budget"},
        {pressureTargetWavesOverride != -2, "pressure-target-waves-override"},
    };
    if (failed(checkUnsupportedOptions(op, "waveamd-machine-schedule-report",
                                       opts)))
      return failure();
    if (!scoreOrder.empty() && scoreRegion < 0)
      return op->emitError("score-order requires score-region");
    return success();
  }

  WalkResult processFunction(func::FuncOp func,
                             const waveamdmachine::EventSimConfig &modelConfig,
                             ArrayRef<unsigned> parsedOrder) {
    if (func.isExternal() || !hasAnyWaveMachineOp(func))
      return WalkResult::advance();

    FailureOr<SmallVector<GreedyRegion, 16>> collected =
        RegionCollector().collect(func);
    if (failed(collected))
      return WalkResult::interrupt();

    ArchResolution arch = resolveArch(func);
    if (!arch.arch)
      return reportMissingArch(*collected, func, arch);

    waveamdmachine::EventSimConfig funcConfig = modelConfig;
    if (failed(finalizeModel(func, arch, funcConfig)))
      return WalkResult::interrupt();

    for (const GreedyRegion &region : *collected)
      if (failed(reportRegion(region, *arch.arch, funcConfig, parsedOrder)))
        return WalkResult::interrupt();
    return WalkResult::advance();
  }

  WalkResult reportMissingArch(ArrayRef<GreedyRegion> regions,
                               func::FuncOp func, ArchResolution arch) {
    if (printClasses || printCandidates) {
      (void)reportArchFailure(func, arch);
      return WalkResult::interrupt();
    }
    for (const GreedyRegion &region : regions) {
      if (printRegions)
        printReportRegion(region);
      if (printScore && isSelectedReportRegion(region, scoreFunc, scoreRegion))
        printFallbackScore(region, arch.reason);
    }
    return WalkResult::advance();
  }

  bool wantsGraphForRegion(const GreedyRegion &region) const {
    return printDeps || printCandidates || printScore ||
           (!scoreOrder.empty() &&
            isSelectedReportRegion(region, scoreFunc, scoreRegion));
  }

  LogicalResult printScoreSection(const GreedyRegion &region,
                                  const GraphTables &graph,
                                  FailureOr<OrderScore> originalScore,
                                  const waveamdmachine::ArchData &arch,
                                  const waveamdmachine::EventSimConfig &config,
                                  ArrayRef<unsigned> parsedOrder) {
    bool selected = isSelectedReportRegion(region, scoreFunc, scoreRegion);
    if ((!printScore && scoreOrder.empty()) || !selected)
      return success();

    printScoreLine(region, "original", originalScore);
    if (scoreOrder.empty())
      return success();

    SmallVector<Operation *, 16> candidateOps;
    if (!buildCandidateOps(region, graph, parsedOrder, candidateOps)) {
      llvm::errs() << kReportPrefix
                   << " score func=" << getRegionFuncName(region)
                   << " region=" << region.regionOrdinal
                   << " order=candidate fallback=original "
                   << "reason=candidate_order_breaks_dependency\n";
      return success();
    }
    printScoreLine(region, "candidate",
                   scoreOrderOps(candidateOps, arch, config));
    return success();
  }

  LogicalResult
  printCandidateSection(const GreedyRegion &region, const GraphTables &graph,
                        ArrayRef<unsigned> originalOrder,
                        FailureOr<OrderScore> originalScore,
                        const waveamdmachine::ArchData &arch,
                        const waveamdmachine::EventSimConfig &config) {
    if (!printCandidates)
      return success();

    GreedyResult greedy = buildGreedyOrder(region, graph, arch, config);
    if (!greedy.success)
      return region.first->emitError(
                 "waveamd-machine-schedule-report failed: reason=")
             << greedy.failureReason;

    SmallVector<Operation *, 16> greedyOps;
    materializeOrder(region, greedy.order, greedyOps);
    FailureOr<OrderScore> greedyScore = scoreOrderOps(greedyOps, arch, config);
    printCandidate("original", region, originalOrder, originalScore,
                   originalScore, GreedyStats(), "keep", "original");
    printGreedyCandidate(region, originalOrder, greedy, originalScore,
                         greedyScore);
    return success();
  }

  void printGreedyCandidate(const GreedyRegion &region,
                            ArrayRef<unsigned> originalOrder,
                            const GreedyResult &greedy,
                            FailureOr<OrderScore> originalScore,
                            FailureOr<OrderScore> greedyScore) {
    StringRef action = "keep";
    StringRef reason = "same_order";
    if (!sameOrder(originalOrder, greedy.order)) {
      action = "apply";
      reason = "greedy";
      if (filledOnlyM0HazardGaps(greedy.stats))
        reason = "m0_hazard";
      else if (filledBarrierMemoryGap(greedy.stats))
        reason = "barrier_memory";
      else if (succeeded(originalScore) && succeeded(greedyScore) &&
               greedyScore->cycles < originalScore->cycles)
        reason = "better";
    }
    printCandidate("greedy", region, greedy.order, originalScore, greedyScore,
                   greedy.stats, action, reason);
    printSelectedCandidate(region, originalOrder, greedy.order, originalScore,
                           greedyScore, action, reason);
  }

  void printSelectedCandidate(const GreedyRegion &region,
                              ArrayRef<unsigned> originalOrder,
                              ArrayRef<unsigned> greedyOrder,
                              FailureOr<OrderScore> originalScore,
                              FailureOr<OrderScore> greedyScore,
                              StringRef action, StringRef reason) {
    FailureOr<OrderScore> selectedScore =
        action == "apply" ? greedyScore : originalScore;
    llvm::errs() << kReportPrefix
                 << " selected func=" << getRegionFuncName(region)
                 << " region=" << region.regionOrdinal
                 << " name=" << (action == "apply" ? "greedy" : "original");
    if (succeeded(originalScore) && succeeded(selectedScore))
      llvm::errs() << " original_cycles=" << originalScore->cycles
                   << " selected_cycles=" << selectedScore->cycles << " delta="
                   << (selectedScore->cycles - originalScore->cycles);
    llvm::errs() << " action=" << action << " reason=" << reason << " order=";
    printOrder(action == "apply" ? greedyOrder : originalOrder);
    llvm::errs() << "\n";
  }

  LogicalResult reportRegion(const GreedyRegion &region,
                             const waveamdmachine::ArchData &arch,
                             const waveamdmachine::EventSimConfig &config,
                             ArrayRef<unsigned> parsedOrder) {
    if (printRegions)
      printReportRegion(region);
    if (printClasses)
      printReportClasses(region, arch, config);

    if (!wantsGraphForRegion(region))
      return success();
    if (maxRegionOps >= 0 &&
        region.ops.size() > static_cast<unsigned>(maxRegionOps)) {
      printReportSkip(region, maxRegionOps);
      return success();
    }

    GraphTables graph;
    if (failed(buildGraph(region, graph)))
      return failure();
    if (printDeps)
      printReportDeps(region, graph);

    SmallVector<unsigned, 16> originalOrder = getOriginalOrder(region);
    SmallVector<Operation *, 16> originalOps;
    materializeOrder(region, originalOrder, originalOps);
    FailureOr<OrderScore> originalScore =
        scoreOrderOps(originalOps, arch, config);

    if (failed(printScoreSection(region, graph, originalScore, arch, config,
                                 parsedOrder)))
      return failure();
    return printCandidateSection(region, graph, originalOrder, originalScore,
                                 arch, config);
  }

  static FailureOr<OrderScore>
  scoreOrderOps(ArrayRef<Operation *> ops, const waveamdmachine::ArchData &arch,
                const waveamdmachine::EventSimConfig &config) {
    return evaluateOrderScore(ops, arch, config);
  }

  static void printCandidate(StringRef name, const GreedyRegion &region,
                             ArrayRef<unsigned> order,
                             FailureOr<OrderScore> originalScore,
                             FailureOr<OrderScore> candidateScore,
                             const GreedyStats &stats, StringRef action,
                             StringRef reason) {
    llvm::errs() << kReportPrefix
                 << " candidate func=" << getRegionFuncName(region)
                 << " region=" << region.regionOrdinal << " name=" << name;
    if (succeeded(candidateScore)) {
      llvm::errs() << " cycles=" << candidateScore->cycles;
      if (succeeded(originalScore))
        llvm::errs() << " delta="
                     << (candidateScore->cycles - originalScore->cycles);
      llvm::errs() << " issued_ops=" << candidateScore->issuedOps;
    } else {
      llvm::errs() << " fallback=original reason=simulation_failed";
    }
    llvm::errs() << " action=" << action << " reason=" << reason
                 << " filled_gaps=" << stats.filledGaps
                 << " unfilled_gaps=" << stats.unfilledGaps
                 << " operand_gaps=" << stats.operandGaps
                 << " resource_gaps=" << stats.resourceGaps
                 << " cheap_hazard_gaps=" << stats.cheapHazardGaps
                 << " m0_gaps=" << stats.m0Gaps
                 << " memory_token_gaps=" << stats.memoryTokenGaps
                 << " barrier_memory_gaps=" << stats.barrierMemoryGaps
                 << " filled_barrier_memory_gaps="
                 << stats.filledBarrierMemoryGaps << " order=";
    printOrder(order);
    llvm::errs() << "\n";
  }
};

} // namespace
