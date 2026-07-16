//===- WaveAMDMachineGreedySchedule.cpp - Greedy machine scheduler --------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/Wave/Transforms/Passes.h"

#include "RegAlloc/WaveAMDRegAllocTransformState.h"
#include "RegAlloc/WaveAMDRegLiveIntervals.h"
#include "WaveAMDMachineScheduleEligibility.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/WaveAMDMachine/CostModel/ArchData.h"
#include "mlir/Dialect/WaveAMDMachine/CostModel/CalibrationData.h"
#include "mlir/Dialect/WaveAMDMachine/CostModel/EventSimulator.h"
#include "mlir/Dialect/WaveAMDMachine/CostModel/InstructionExecutionState.h"
#include "mlir/Dialect/WaveAMDMachine/CostModel/LatencyTable.h"
#include "mlir/Dialect/WaveAMDMachine/CostModel/MemoryCounterTiming.h"
#include "mlir/Dialect/WaveAMDMachine/CostModel/OpClassifier.h"
#include "mlir/Dialect/WaveAMDMachine/CostModel/SchedClass.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachine.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachineTarget.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachineTraits.h"
#include "mlir/IR/BuiltinOps.h"
#include "mlir/Interfaces/ControlFlowInterfaces.h"
#include "mlir/Interfaces/SideEffectInterfaces.h"
#include "mlir/Support/LLVM.h"
#include "mlir/Support/Timing.h"
#include "llvm/ADT/BitVector.h"
#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/DenseSet.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/ADT/SmallPtrSet.h"
#include "llvm/ADT/SmallVector.h"

#include <algorithm>
#include <array>
#include <cstdint>
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

struct MachineScheduleStageTimingManager {
  MachineScheduleStageTimingManager() {
    applyDefaultTimingManagerCLOptions(manager);
  }

  DefaultTimingManager manager;
};

static DefaultTimingManager &getMachineScheduleStageTimingManager() {
  static MachineScheduleStageTimingManager timing;
  return timing.manager;
}

struct MachineScheduleStageTiming {
  MachineScheduleStageTiming() {
    rootScope = getMachineScheduleStageTimingManager().getRootScope();
    stageScope = rootScope.nest("wave_machine_schedule_stages");
  }

  TimingScope nest(StringRef name) { return stageScope.nest(name); }

  TimingScope rootScope;
  TimingScope stageScope;
};

static constexpr StringLiteral kScheduleInputAttr =
    "waveamdmachine.schedule_input";
static constexpr StringLiteral kDmaIssueTimingAttr =
    "waveamdmachine.dma_issue_timing";
static constexpr StringLiteral kDmaIssueAfterDelayAttr =
    "waveamdmachine.dma_issue_after_delay";
static constexpr StringLiteral kReportPrefix =
    "waveamd-machine-schedule-report";

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
  InstructionHazard,
};

enum class GreedyStepStatus : uint8_t {
  Continue,
  Done,
  Blocked,
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
  bool dmaIssueTiming = false;
};

struct ArchResolution {
  StringRef reason;
  const waveamdmachine::ArchData *arch = nullptr;
};

struct GraphTables {
  DenseMap<Operation *, unsigned> node;
  SmallVector<ScheduleEdge, 32> edges;
  SmallVector<SmallVector<unsigned, 4>, 16> predecessors;
  SmallVector<SmallVector<unsigned, 4>, 16> successors;
  SmallVector<unsigned, 16> memoryNodes;
  SmallVector<unsigned, 16> pendingPreds;
};

using MemoryKind = waveamdmachine::MemoryCounterKind;
using MemoryKindSet = SmallVector<MemoryKind, 4>;

struct ValueOriginBinding {
  SmallVector<Value, 4> leaves;
  Value target;
};

struct ValueOriginMap {
  DenseMap<Value, SmallVector<Value, 4>> sources;
  SmallVector<ValueOriginBinding, 16> bindings;
};

struct ComputeResourcePreview {
  waveamdmachine::FunctionalUnit fu = waveamdmachine::FunctionalUnit::None;
  int64_t waitSlots = 0;
  unsigned releaseSlots = 0;
};

struct StaticIssueInfo {
  unsigned issues = 0;
  unsigned releaseSlots = 0;
  waveamdmachine::SchedClass cls = waveamdmachine::SchedClass::NoInst;
  waveamdmachine::FunctionalUnit fu = waveamdmachine::FunctionalUnit::None;
  bool realInst = false;
  bool memoryIssuer = false;
  bool hasMemoryValue = false;
};

using StaticIssueInfoMap = DenseMap<Operation *, StaticIssueInfo>;

static const StaticIssueInfo &
getStaticIssueInfo(const StaticIssueInfoMap &staticInfo, Operation *op) {
  StaticIssueInfoMap::const_iterator it = staticInfo.find(op);
  assert(it != staticInfo.end() && "missing static issue info");
  return it->second;
}

struct ComputeResourceState {
  ComputeResourcePreview preview(const StaticIssueInfo &info) const;
  void commit(const StaticIssueInfo &info);

  std::array<int64_t, static_cast<size_t>(
                          waveamdmachine::FunctionalUnit::NumFunctionalUnits)>
      readyAt{};
  int64_t currentSlot = 0;
};

struct IssueState {
  IssueState(const waveamdmachine::ArchData &arch,
             waveamdmachine::InstructionExecutionConfig config,
             const StaticIssueInfoMap &staticInfo)
      : model(arch, config), staticInfo(&staticInfo) {}

  const StaticIssueInfo &getStaticInfo(Operation *op) const {
    return getStaticIssueInfo(*staticInfo, op);
  }

  waveamdmachine::InstructionExecutionState model;
  ComputeResourceState resources;
  const StaticIssueInfoMap *staticInfo = nullptr;
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
  bool m0Hazard = false;
  bool storeDataHazard = false;
  ComputeResourcePreview resource;
};

static void bindValueOrigins(waveamdmachine::InstructionExecutionState &model,
                             const ValueOriginMap &origins);

struct GreedyStats {
  unsigned filledGaps = 0;
  unsigned unfilledGaps = 0;
  unsigned operandGaps = 0;
  unsigned resourceGaps = 0;
  unsigned cheapHazardGaps = 0;
  unsigned m0Gaps = 0;
  unsigned storeDataGaps = 0;
  unsigned vmemPrefetchMoves = 0;
  unsigned longLatencyVmemPrefetchMoves = 0;
  unsigned memoryTokenGaps = 0;
  unsigned barrierMemoryGaps = 0;
  unsigned filledBarrierMemoryGaps = 0;
  unsigned loopCarriedWaitFills = 0;
  unsigned resourcePriorityMoves = 0;
  unsigned resourceStallFills = 0;
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

static bool isMemToken(Value value) {
  return isa<waveamdmachine::MemTokenType>(value.getType());
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

static int getModelLatency(const waveamdmachine::ArchData &arch,
                           waveamdmachine::SchedClass cls,
                           const waveamdmachine::EventSimConfig &config) {
  if (cls == waveamdmachine::SchedClass::NoInst)
    return 0;
  if (config.calibration)
    return waveamdmachine::getCalibratedLatency(arch, cls, *config.calibration);
  return waveamdmachine::getLatency(arch, cls);
}

static waveamdmachine::InstructionExecutionConfig
buildInstructionConfig(const waveamdmachine::ArchData &arch,
                       const waveamdmachine::EventSimConfig &config) {
  waveamdmachine::InstructionExecutionConfig stateConfig;
  stateConfig.calibration = config.calibration;
  stateConfig.counterLatencies = config.counterLatencies;
  stateConfig.valueLatencies = config.valueLatencies;
  stateConfig.issuePeriod =
      waveamdmachine::getEventSimIssuePeriod(arch, config);
  return stateConfig;
}

static waveamdmachine::EventSimConfig buildModelConfig() {
  waveamdmachine::EventSimConfig modelConfig;
  modelConfig.completePendingLdsDmaCounters = true;
  return modelConfig;
}

static unsigned getIssueCount(Operation *op) {
  if (auto info = dyn_cast<waveamdmachine::WaitcntInfoOpInterface>(op))
    return std::max(1u, info.getWaitcntInfo().issueCount);
  return 1;
}

static bool tracksComputeResource(waveamdmachine::FunctionalUnit fu) {
  switch (fu) {
  case waveamdmachine::FunctionalUnit::VALU:
  case waveamdmachine::FunctionalUnit::SALU:
  case waveamdmachine::FunctionalUnit::MFMA_XDL:
  case waveamdmachine::FunctionalUnit::TRANS:
    return true;
  default:
    return false;
  }
}

static StaticIssueInfo
buildStaticIssueInfo(Operation *op, const waveamdmachine::ArchData &arch) {
  StaticIssueInfo info;
  info.cls = waveamdmachine::classifyOp(op);
  info.realInst = info.cls != waveamdmachine::SchedClass::NoInst;
  if (!info.realInst)
    return info;

  info.fu = waveamdmachine::funit(arch, info.cls);
  info.issues = getIssueCount(op);
  info.memoryIssuer = waveamdmachine::getMemoryCounterKind(op) !=
                      waveamdmachine::MemoryCounterKind::None;
  info.hasMemoryValue = waveamdmachine::hasMemoryValueLatency(op);
  if (tracksComputeResource(info.fu))
    info.releaseSlots =
        std::max(1, waveamdmachine::getResourceCycles(arch, info.cls));
  return info;
}

static StaticIssueInfoMap
buildStaticIssueInfoMap(const GreedyRegion &region,
                        const waveamdmachine::ArchData &arch) {
  StaticIssueInfoMap result;
  result.reserve(region.ops.size());
  for (Operation *op : region.ops)
    result.try_emplace(op, buildStaticIssueInfo(op, arch));
  return result;
}

ComputeResourcePreview
ComputeResourceState::preview(const StaticIssueInfo &info) const {
  ComputeResourcePreview result;
  if (!info.realInst)
    return result;

  result.fu = info.fu;
  if (!tracksComputeResource(result.fu))
    return result;

  result.releaseSlots = info.releaseSlots;
  size_t index = static_cast<size_t>(result.fu);
  result.waitSlots = std::max<int64_t>(0, readyAt[index] - currentSlot);
  return result;
}

void ComputeResourceState::commit(const StaticIssueInfo &info) {
  if (!info.realInst)
    return;

  ComputeResourcePreview resource = preview(info);
  int64_t issueSlot = currentSlot + resource.waitSlots;
  if (!tracksComputeResource(resource.fu)) {
    // Resource scheduling does not cross compute-island boundaries.
    currentSlot = issueSlot + info.issues;
    readyAt.fill(currentSlot);
    return;
  }
  size_t index = static_cast<size_t>(resource.fu);
  readyAt[index] =
      issueSlot + std::max<unsigned>(resource.releaseSlots, info.issues);
  currentSlot = issueSlot + info.issues;
}

static bool
recordHazardStall(IssuePreview &preview,
                  const waveamdmachine::InstructionStallComponent &component) {
  switch (component.kind) {
  case waveamdmachine::InstructionStallKind::InstructionHazard:
    break;
  case waveamdmachine::InstructionStallKind::M0ReadWrite:
    preview.m0Hazard = true;
    break;
  case waveamdmachine::InstructionStallKind::StoreWriteData:
    preview.storeDataHazard = true;
    break;
  default:
    return false;
  }
  preview.hazardWaitInsts =
      std::max<unsigned>(preview.hazardWaitInsts, component.cycles);
  return true;
}

static void recordPreviewStall(IssuePreview &preview,
                               const waveamdmachine::InstructionStall &stall) {
  for (const waveamdmachine::InstructionStallComponent &component :
       stall.components) {
    if (recordHazardStall(preview, component))
      continue;
    switch (component.kind) {
    case waveamdmachine::InstructionStallKind::OperandValue:
    case waveamdmachine::InstructionStallKind::MemoryValue:
      preview.operandWaitCycles =
          std::max(preview.operandWaitCycles, component.cycles);
      break;
    case waveamdmachine::InstructionStallKind::MemoryToken:
    case waveamdmachine::InstructionStallKind::Waitcnt:
      preview.memoryWaitCycles =
          std::max(preview.memoryWaitCycles, component.cycles);
      break;
    case waveamdmachine::InstructionStallKind::IssueBackpressure:
      preview.fuWaitCycles = std::max(preview.fuWaitCycles, component.cycles);
      break;
    case waveamdmachine::InstructionStallKind::None:
      break;
    default:
      llvm_unreachable("handled hazard stall");
    }
  }
}

static FailureOr<IssuePreview>
previewIssue(const IssueState &state, Operation *op,
             std::optional<ComputeResourcePreview> resource = std::nullopt) {
  const StaticIssueInfo &info = state.getStaticInfo(op);
  IssuePreview preview;
  preview.cls = info.cls;
  preview.realInst = info.realInst;
  preview.fu = info.fu;
  preview.issues = info.issues;
  preview.memoryIssuer = info.memoryIssuer;
  preview.hasMemoryValue = info.hasMemoryValue;
  preview.resource = resource ? *resource : state.resources.preview(info);

  IssueState trial = state;
  FailureOr<waveamdmachine::InstructionCommitResult> commit =
      trial.model.commit(op);
  if (failed(commit))
    return failure();

  recordPreviewStall(preview, commit->stall);
  preview.issueCycle = commit->issueCycle;
  preview.readyCycle = commit->valueReadyCycle;
  preview.nextIssueCycle = commit->nextIssueCycle;
  preview.memoryReadyCycle = commit->tokenReadyCycle;
  preview.memoryValueReadyCycle = commit->valueReadyCycle;
  return preview;
}

static bool stalls(const IssuePreview &preview) {
  return preview.operandWaitCycles != 0 || preview.memoryWaitCycles != 0 ||
         preview.fuWaitCycles != 0 || preview.issueWaitCycles != 0 ||
         preview.cuIssueWaitCycles != 0 || preview.cmaIssueWaitCycles != 0 ||
         preview.hazardWaitInsts != 0;
}

static LogicalResult commitIssue(IssueState &state, Operation *op,
                                 const IssuePreview &preview,
                                 const ValueOriginMap &origins) {
  (void)preview;
  if (failed(state.model.commit(op)))
    return failure();
  // Candidate copies inherit aliases from the committed state.
  bindValueOrigins(state.model, origins);
  state.resources.commit(state.getStaticInfo(op));
  return success();
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
  graph.predecessors[dst].push_back(src);
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

static void addSingletonReadEdges(
    Operation *op, unsigned index, GraphTables &graph,
    DenseMap<Operation *, unsigned> &node,
    const std::array<std::optional<unsigned>, 3> &lastWriter,
    std::array<SmallVector<unsigned, 4>, 3> &readers,
    const std::array<SmallVector<unsigned, 4>, 3> &deadWriters) {
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
    for (unsigned writer : deadWriters[kindIndex])
      addEdge(graph, writer, index, EdgeKind::Singleton);
    if (!llvm::is_contained(readers[kindIndex], index))
      readers[kindIndex].push_back(index);
  }
}

static bool readsSingletonKind(Operation *op, SingletonKind kind) {
  return llvm::any_of(op->getOperandTypes(), [kind](Type type) {
    return getSingletonKind(type) == kind;
  });
}

static bool hasUsedSingletonResult(Operation *op, SingletonKind kind) {
  return llvm::any_of(op->getResults(), [kind](OpResult result) {
    return getSingletonKind(result.getType()) == kind && !result.use_empty();
  });
}

static void addPriorSingletonEdges(unsigned index, GraphTables &graph,
                                   std::optional<unsigned> lastWriter,
                                   ArrayRef<unsigned> readers,
                                   bool skipCurrentReader = false) {
  if (lastWriter)
    addEdge(graph, *lastWriter, index, EdgeKind::Singleton);
  for (unsigned reader : readers)
    if (!skipCurrentReader || reader != index)
      addEdge(graph, reader, index, EdgeKind::Singleton);
}

static void
recordLegacySingletonWrite(unsigned index, unsigned kindIndex,
                           GraphTables &graph,
                           std::array<std::optional<unsigned>, 3> &lastWriter,
                           std::array<SmallVector<unsigned, 4>, 3> &readers) {
  addPriorSingletonEdges(index, graph, lastWriter[kindIndex],
                         readers[kindIndex]);
  readers[kindIndex].clear();
  lastWriter[kindIndex] = index;
}

static void recordDeadSingletonWrite(
    unsigned index, unsigned kindIndex, GraphTables &graph,
    const std::array<std::optional<unsigned>, 3> &lastWriter,
    const std::array<SmallVector<unsigned, 4>, 3> &readers,
    std::array<SmallVector<unsigned, 4>, 3> &deadWriters) {
  addPriorSingletonEdges(index, graph, lastWriter[kindIndex],
                         readers[kindIndex]);
  deadWriters[kindIndex].push_back(index);
}

static void
recordLiveSingletonWrite(unsigned index, unsigned kindIndex, GraphTables &graph,
                         std::array<std::optional<unsigned>, 3> &lastWriter,
                         std::array<SmallVector<unsigned, 4>, 3> &readers,
                         std::array<SmallVector<unsigned, 4>, 3> &deadWriters) {
  addPriorSingletonEdges(index, graph, lastWriter[kindIndex],
                         readers[kindIndex], /*skipCurrentReader=*/true);
  for (unsigned writer : deadWriters[kindIndex])
    addEdge(graph, writer, index, EdgeKind::Singleton);
  readers[kindIndex].clear();
  deadWriters[kindIndex].clear();
  lastWriter[kindIndex] = index;
}

static void
addSingletonWriteEdges(Operation *op, unsigned index, GraphTables &graph,
                       std::array<std::optional<unsigned>, 3> &lastWriter,
                       std::array<SmallVector<unsigned, 4>, 3> &readers,
                       std::array<SmallVector<unsigned, 4>, 3> &deadWriters,
                       bool splitDeadWriters) {
  llvm::SmallPtrSet<Type, 4> seenWriteTypes;
  for (Value result : op->getResults()) {
    SingletonKind kind = getSingletonKind(result.getType());
    if (kind == SingletonKind::None)
      continue;
    if (!seenWriteTypes.insert(result.getType()).second)
      continue;
    unsigned kindIndex = getSingletonIndex(kind);
    if (!splitDeadWriters) {
      recordLegacySingletonWrite(index, kindIndex, graph, lastWriter, readers);
      continue;
    }
    bool liveWrite =
        readsSingletonKind(op, kind) || hasUsedSingletonResult(op, kind);
    if (!liveWrite) {
      recordDeadSingletonWrite(index, kindIndex, graph, lastWriter, readers,
                               deadWriters);
      continue;
    }
    recordLiveSingletonWrite(index, kindIndex, graph, lastWriter, readers,
                             deadWriters);
  }
}

static LogicalResult addSingletonEdges(const GreedyRegion &region,
                                       GraphTables &graph,
                                       DenseMap<Operation *, unsigned> &node) {
  std::array<std::optional<unsigned>, 3> lastWriter;
  std::array<SmallVector<unsigned, 4>, 3> readers;
  std::array<SmallVector<unsigned, 4>, 3> deadWriters;
  bool splitDeadWriters =
      region.dmaIssueTiming && isa_and_nonnull<waveamdmachine::UniformLoopOp>(
                                   region.block->getParentOp());

  for (auto [index, op] : llvm::enumerate(region.ops)) {
    addSingletonReadEdges(op, index, graph, node, lastWriter, readers,
                          deadWriters);
    addSingletonWriteEdges(op, index, graph, lastWriter, readers, deadWriters,
                           splitDeadWriters);
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

static void indexGraphNodes(const GreedyRegion &region, GraphTables &graph) {
  for (auto [index, op] : llvm::enumerate(region.ops)) {
    graph.node[op] = index;
    if (waveamdmachine::getMemoryCounterKind(op) != MemoryKind::None)
      graph.memoryNodes.push_back(index);
  }
}

static LogicalResult buildGraph(const GreedyRegion &region,
                                GraphTables &graph) {
  graph.successors.resize(region.ops.size());
  graph.predecessors.resize(region.ops.size());
  graph.pendingPreds.assign(region.ops.size(), 0);

  indexGraphNodes(region, graph);

  for (auto [dst, op] : llvm::enumerate(region.ops)) {
    for (Value operand : op->getOperands()) {
      Operation *def = operand.getDefiningOp();
      if (!def)
        continue;
      auto it = graph.node.find(def);
      if (it == graph.node.end())
        continue;
      // Delay anchors at DMA issue, not memory retirement.
      bool memoryEdge =
          isMemToken(operand) && !isa<waveamdmachine::DmaIssueDelayOp>(op);
      addEdge(graph, it->second, dst,
              memoryEdge ? EdgeKind::MemToken : EdgeKind::Ssa);
    }
  }

  if (failed(addSingletonEdges(region, graph, graph.node)))
    return failure();
  addExecEdges(region, graph);
  addLoopCarryEdges(region, graph, graph.node);
  for (SmallVector<unsigned, 4> &succs : graph.successors)
    llvm::sort(succs);
  for (SmallVector<unsigned, 4> &preds : graph.predecessors)
    llvm::sort(preds);
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
  for (unsigned index : llvm::seq(ready.size()))
    if (ready.test(index))
      return index;
  return ready.size();
}

static bool isBarrierOp(Operation *op) {
  return isa<waveamdmachine::BarrierWaitOp, waveamdmachine::SBarrierOp>(op);
}

static void recordGapStats(Operation *op, const IssuePreview &preview,
                           GreedyStats &stats) {
  if (preview.operandWaitCycles != 0)
    ++stats.operandGaps;
  if (preview.memoryWaitCycles != 0) {
    ++stats.memoryTokenGaps;
    if (isBarrierOp(op))
      ++stats.barrierMemoryGaps;
  }
  if (preview.fuWaitCycles != 0 || preview.cuIssueWaitCycles != 0 ||
      preview.cmaIssueWaitCycles != 0)
    ++stats.resourceGaps;
  if (preview.hazardWaitInsts != 0) {
    ++stats.cheapHazardGaps;
    if (preview.m0Hazard)
      ++stats.m0Gaps;
    if (preview.storeDataHazard)
      ++stats.storeDataGaps;
  }
}

static bool filledOnlyM0HazardGaps(const GreedyStats &stats) {
  return stats.m0Gaps != 0 && stats.storeDataGaps == 0 &&
         stats.cheapHazardGaps == stats.m0Gaps &&
         stats.filledGaps >= stats.m0Gaps && stats.unfilledGaps == 0 &&
         stats.resourceGaps == 0 && stats.memoryTokenGaps == 0;
}

static bool filledOnlyStoreDataHazardGaps(const GreedyStats &stats) {
  return stats.storeDataGaps != 0 && stats.m0Gaps == 0 &&
         stats.cheapHazardGaps == stats.storeDataGaps &&
         stats.filledGaps >= stats.storeDataGaps && stats.unfilledGaps == 0 &&
         stats.resourceGaps == 0 && stats.memoryTokenGaps == 0;
}

static bool filledBarrierMemoryGap(const GreedyStats &stats) {
  return stats.filledBarrierMemoryGaps != 0;
}

static bool filledLoopCarriedWait(const GreedyStats &stats) {
  return stats.loopCarriedWaitFills != 0;
}

static bool hasComputeResourceMoves(const GreedyStats &stats) {
  return stats.resourcePriorityMoves != 0 || stats.resourceStallFills != 0;
}

static StringRef getGreedyMoveReason(const GreedyStats &stats) {
  if (filledOnlyM0HazardGaps(stats))
    return "m0_hazard";
  if (filledOnlyStoreDataHazardGaps(stats))
    return "store_data_hazard";
  if (filledLoopCarriedWait(stats))
    return "loop_wait";
  if (filledBarrierMemoryGap(stats))
    return "barrier_memory";
  if (stats.vmemPrefetchMoves != 0)
    return "vmem_prefetch";
  if (hasComputeResourceMoves(stats))
    return "compute_resource";
  return "greedy";
}

static bool hasNonMemoryCycleWait(const IssuePreview &preview) {
  return preview.operandWaitCycles != 0 || preview.fuWaitCycles != 0 ||
         preview.issueWaitCycles != 0 || preview.cuIssueWaitCycles != 0 ||
         preview.cmaIssueWaitCycles != 0;
}

static bool appendMemoryKind(SmallVectorImpl<MemoryKind> &kinds,
                             MemoryKind kind) {
  if (kind == MemoryKind::None || llvm::is_contained(kinds, kind))
    return false;
  kinds.push_back(kind);
  return true;
}

static void appendValueAliases(ValueOriginMap &origins, OperandRange sources,
                               ValueRange targets) {
  for (auto [index, source] : llvm::enumerate(sources)) {
    if (index >= targets.size())
      break;
    Value target = targets[index];
    if (source.getType() != target.getType())
      continue;
    origins.sources[target].push_back(source);
  }
}

static void buildValueOriginBindings(ValueOriginMap &origins);

static ValueOriginMap buildValueOriginMap(func::FuncOp func) {
  ValueOriginMap origins;
  func.walk([&](RegionBranchOpInterface branch) {
    SmallVector<RegionSuccessor> successors;
    branch.getSuccessorRegions(RegionBranchPoint::parent(), successors);
    for (RegionSuccessor successor : successors)
      appendValueAliases(origins, branch.getEntrySuccessorOperands(successor),
                         branch.getSuccessorInputs(successor));

    for (Region &region : branch->getRegions()) {
      for (Block &block : region) {
        auto terminator = dyn_cast_or_null<RegionBranchTerminatorOpInterface>(
            block.getTerminator());
        if (!terminator)
          continue;
        successors.clear();
        branch.getSuccessorRegions(RegionBranchPoint(terminator), successors);
        for (RegionSuccessor successor : successors)
          appendValueAliases(origins,
                             terminator.getSuccessorOperands(successor),
                             branch.getSuccessorInputs(successor));
      }
    }
  });
  buildValueOriginBindings(origins);
  return origins;
}

static void collectOriginLeaves(Value value, const ValueOriginMap &origins,
                                SmallVectorImpl<Value> &leaves,
                                SmallPtrSetImpl<Value> &visited) {
  if (!visited.insert(value).second)
    return;
  auto originIt = origins.sources.find(value);
  if (originIt == origins.sources.end()) {
    leaves.push_back(value);
    return;
  }
  for (Value source : originIt->second)
    collectOriginLeaves(source, origins, leaves, visited);
}

static void buildValueOriginBindings(ValueOriginMap &origins) {
  origins.bindings.reserve(origins.sources.size());
  for (const auto &entry : origins.sources) {
    SmallVector<Value, 4> leaves;
    SmallPtrSet<Value, 16> visited;
    collectOriginLeaves(entry.first, origins, leaves, visited);
    if (!leaves.empty())
      origins.bindings.push_back({std::move(leaves), entry.first});
  }
}

static void bindValueOrigins(waveamdmachine::InstructionExecutionState &model,
                             const ValueOriginMap &origins) {
  for (const ValueOriginBinding &binding : origins.bindings)
    model.bindValue(binding.target, binding.leaves);
}

static void collectTokenMemoryKinds(Value value, const ValueOriginMap &origins,
                                    SmallVectorImpl<MemoryKind> &kinds,
                                    SmallPtrSetImpl<Value> &visited) {
  if (!isMemToken(value))
    return;
  if (!visited.insert(value).second)
    return;

  auto originIt = origins.sources.find(value);
  if (originIt != origins.sources.end())
    for (Value source : originIt->second)
      collectTokenMemoryKinds(source, origins, kinds, visited);

  Operation *def = value.getDefiningOp();
  if (!def)
    return;
  appendMemoryKind(kinds, waveamdmachine::getMemoryCounterKind(def));

  for (Value operand : def->getOperands())
    collectTokenMemoryKinds(operand, origins, kinds, visited);
}

static void collectValueMemoryKinds(Value value, const ValueOriginMap &origins,
                                    SmallVectorImpl<MemoryKind> &kinds,
                                    SmallPtrSetImpl<Value> &visited) {
  if (isMemToken(value)) {
    collectTokenMemoryKinds(value, origins, kinds, visited);
    return;
  }
  if (!visited.insert(value).second)
    return;

  auto originIt = origins.sources.find(value);
  if (originIt != origins.sources.end())
    for (Value source : originIt->second)
      collectValueMemoryKinds(source, origins, kinds, visited);

  Operation *def = value.getDefiningOp();
  if (!def)
    return;
  appendMemoryKind(kinds, waveamdmachine::getMemoryCounterKind(def));
}

static MemoryKindSet collectFillerMemoryKinds(Operation *op,
                                              const ValueOriginMap &origins) {
  MemoryKindSet kinds;
  appendMemoryKind(kinds, waveamdmachine::getMemoryCounterKind(op));

  SmallPtrSet<Value, 16> visited;
  for (Value operand : op->getOperands())
    collectValueMemoryKinds(operand, origins, kinds, visited);
  return kinds;
}

static bool containsMemoryKind(ArrayRef<MemoryKind> kinds, MemoryKind kind) {
  return kind != MemoryKind::None && llvm::is_contained(kinds, kind);
}

static bool memoryKindsIntersect(ArrayRef<MemoryKind> lhs,
                                 ArrayRef<MemoryKind> rhs) {
  return llvm::any_of(
      lhs, [&](MemoryKind kind) { return containsMemoryKind(rhs, kind); });
}

static void
collectTransitiveValueMemoryKinds(Value value, const ValueOriginMap &origins,
                                  SmallVectorImpl<MemoryKind> &kinds,
                                  SmallPtrSetImpl<Value> &visited) {
  if (isMemToken(value)) {
    collectTokenMemoryKinds(value, origins, kinds, visited);
    return;
  }
  if (!visited.insert(value).second)
    return;

  auto originIt = origins.sources.find(value);
  if (originIt != origins.sources.end())
    for (Value source : originIt->second)
      collectTransitiveValueMemoryKinds(source, origins, kinds, visited);

  Operation *def = value.getDefiningOp();
  if (!def)
    return;
  appendMemoryKind(kinds, waveamdmachine::getMemoryCounterKind(def));
  for (Value operand : def->getOperands())
    collectTransitiveValueMemoryKinds(operand, origins, kinds, visited);
}

static MemoryKindSet
collectTransitiveFillerMemoryKinds(Operation *op,
                                   const ValueOriginMap &origins) {
  MemoryKindSet kinds;
  appendMemoryKind(kinds, waveamdmachine::getMemoryCounterKind(op));
  SmallPtrSet<Value, 16> visited;
  for (Value operand : op->getOperands())
    collectTransitiveValueMemoryKinds(operand, origins, kinds, visited);
  return kinds;
}

static MemoryKindSet getLoopCarriedTokenKinds(const GreedyRegion &region,
                                              unsigned consumer,
                                              const ValueOriginMap &origins) {
  MemoryKindSet kinds;
  if (!region.dmaIssueTiming ||
      !isa_and_nonnull<waveamdmachine::UniformLoopOp>(
          region.block->getParentOp()) ||
      !waveamdmachine::waitsForMemoryTokenDepsBeforeIssue(region.ops[consumer]))
    return kinds;

  for (Value operand : region.ops[consumer]->getOperands()) {
    if (!isMemToken(operand))
      continue;
    BlockArgument arg = dyn_cast<BlockArgument>(operand);
    if (!arg || arg.getOwner() != region.block)
      continue;
    SmallPtrSet<Value, 16> visited;
    collectTokenMemoryKinds(operand, origins, kinds, visited);
  }
  return kinds;
}

static bool isLoopCarriedWaitFiller(unsigned index, const BitVector &ready,
                                    const BitVector &scheduled,
                                    const GreedyRegion &region,
                                    ArrayRef<MemoryKind> waitKinds,
                                    const ValueOriginMap &origins) {
  Operation *candidate = region.ops[index];
  if (!ready.test(index) || scheduled.test(index) || !isPure(candidate) ||
      waveamdmachine::getMemoryCounterKind(candidate) != MemoryKind::None)
    return false;
  MemoryKindSet candidateKinds =
      collectTransitiveFillerMemoryKinds(candidate, origins);
  return !memoryKindsIntersect(waitKinds, candidateKinds);
}

static FailureOr<unsigned>
findLoopCarriedWaitFiller(const BitVector &ready, unsigned next,
                          const GreedyRegion &region, const IssueState &state,
                          const BitVector &scheduled,
                          const ValueOriginMap &origins) {
  MemoryKindSet waitKinds = getLoopCarriedTokenKinds(region, next, origins);
  if (waitKinds.empty())
    return region.ops.size();

  for (unsigned index : llvm::seq(next + 1, ready.size())) {
    Operation *candidate = region.ops[index];
    if (!isLoopCarriedWaitFiller(index, ready, scheduled, region, waitKinds,
                                 origins))
      continue;
    FailureOr<IssuePreview> preview = previewIssue(state, candidate);
    if (failed(preview))
      return failure();
    if (preview->realInst && !stalls(*preview) &&
        preview->resource.releaseSlots == 1)
      return index;
  }
  return region.ops.size();
}

static bool crossesSameMemoryProducer(const GreedyRegion &region,
                                      const BitVector &scheduled, unsigned next,
                                      unsigned filler,
                                      ArrayRef<MemoryKind> fillerKinds) {
  for (unsigned index : llvm::seq(next, filler)) {
    if (scheduled.test(index))
      continue;
    if (containsMemoryKind(fillerKinds, waveamdmachine::getMemoryCounterKind(
                                            region.ops[index])))
      return true;
  }
  return false;
}

static bool canUseStallFiller(const GreedyRegion &region,
                              const BitVector &scheduled, unsigned next,
                              unsigned filler, const ValueOriginMap &origins) {
  MemoryKindSet fillerKinds =
      collectFillerMemoryKinds(region.ops[filler], origins);
  return !crossesSameMemoryProducer(region, scheduled, next, filler,
                                    fillerKinds);
}

struct LocalProjection {
  int64_t cycles = 0;
  int64_t memoryWaitCycles = 0;
  int64_t issueBackpressureCycles = 0;
};

static void addProjectionStall(LocalProjection &projection,
                               const waveamdmachine::InstructionStall &stall) {
  for (const waveamdmachine::InstructionStallComponent &component :
       stall.components) {
    switch (component.kind) {
    case waveamdmachine::InstructionStallKind::MemoryToken:
    case waveamdmachine::InstructionStallKind::Waitcnt:
      projection.memoryWaitCycles += component.cycles;
      break;
    case waveamdmachine::InstructionStallKind::IssueBackpressure:
      projection.issueBackpressureCycles += component.cycles;
      break;
    default:
      break;
    }
  }
}

static FailureOr<LocalProjection>
projectIssueOrder(const IssueState &state, ArrayRef<Operation *> ops,
                  const ValueOriginMap &origins) {
  IssueState trial = state;
  int64_t startCycle = trial.model.getCurrentCycle();
  LocalProjection projection;
  for (Operation *op : ops) {
    FailureOr<waveamdmachine::InstructionCommitResult> commit =
        trial.model.commit(op);
    if (failed(commit))
      return failure();
    bindValueOrigins(trial.model, origins);
    addProjectionStall(projection, commit->stall);
  }
  projection.cycles = trial.model.getCurrentCycle() - startCycle;
  return projection;
}

static unsigned findFirstRealDataConsumer(Operation *producer,
                                          const GreedyRegion &region,
                                          const GraphTables &graph,
                                          const BitVector &scheduled) {
  SmallVector<Value, 8> pending;
  for (Value result : producer->getResults())
    if (!isMemToken(result))
      pending.push_back(result);

  DenseSet<Value> seen;
  unsigned first = region.ops.size();
  while (!pending.empty()) {
    Value value = pending.pop_back_val();
    if (!seen.insert(value).second)
      continue;
    for (OpOperand &use : value.getUses()) {
      Operation *user = use.getOwner();
      auto it = graph.node.find(user);
      if (it == graph.node.end())
        continue;
      if (waveamdmachine::classifyOp(user) ==
          waveamdmachine::SchedClass::NoInst) {
        llvm::append_range(pending, user->getResults());
        continue;
      }
      if (!scheduled.test(it->second))
        first = std::min(first, it->second);
    }
  }
  return first;
}

static bool collectPrefetchChain(unsigned node, unsigned candidate,
                                 unsigned next, const GreedyRegion &region,
                                 const GraphTables &graph,
                                 const BitVector &scheduled, BitVector &chain) {
  if (scheduled.test(node) || chain.test(node))
    return true;
  if (node == next)
    return false;
  Operation *op = region.ops[node];
  if (node != candidate &&
      waveamdmachine::classifyOp(op) != waveamdmachine::SchedClass::NoInst &&
      !isPure(op))
    return false;
  for (unsigned predecessor : graph.predecessors[node])
    if (!collectPrefetchChain(predecessor, candidate, next, region, graph,
                              scheduled, chain))
      return false;
  chain.set(node);
  return true;
}

static FailureOr<LocalProjection> projectPrefetchOrder(
    const IssueState &state, unsigned next, const BitVector &chain,
    unsigned consumer, bool prefetchFirst, const GreedyRegion &region,
    const BitVector &scheduled, const ValueOriginMap &origins) {
  SmallVector<Operation *, 32> ops;
  if (!prefetchFirst)
    ops.push_back(region.ops[next]);
  for (unsigned index : llvm::seq<unsigned>(0, chain.size()))
    if (chain.test(index))
      ops.push_back(region.ops[index]);
  if (prefetchFirst)
    ops.push_back(region.ops[next]);
  for (unsigned index : llvm::seq(next + 1, consumer)) {
    if (chain.test(index) || scheduled.test(index))
      continue;
    ops.push_back(region.ops[index]);
  }
  ops.push_back(region.ops[consumer]);
  return projectIssueOrder(state, ops, origins);
}

static bool hasPrefetchSlack(unsigned next, Operation *candidate,
                             unsigned consumer, const BitVector &chain,
                             const GreedyRegion &region,
                             const BitVector &scheduled,
                             const waveamdmachine::ArchData &arch,
                             const waveamdmachine::EventSimConfig &config) {
  int64_t issuePeriod = waveamdmachine::getEventSimIssuePeriod(arch, config);
  int64_t slack = 0;
  for (unsigned index : llvm::seq(next, consumer)) {
    if (scheduled.test(index) || chain.test(index) ||
        waveamdmachine::classifyOp(region.ops[index]) ==
            waveamdmachine::SchedClass::NoInst)
      continue;
    slack +=
        static_cast<int64_t>(getIssueCount(region.ops[index])) * issuePeriod;
  }
  int64_t nextSpan =
      static_cast<int64_t>(getIssueCount(region.ops[next])) * issuePeriod;
  int64_t valueLatency = waveamdmachine::getMemoryValueLatency(
      arch, candidate, config.counterLatencies, config.valueLatencies,
      config.calibration);
  // Candidate can wait only when post-next work still covers its latency.
  return slack - nextSpan >= valueLatency;
}

static bool
isLongLatencyVmemCandidate(Operation *candidate, Operation *next,
                           const waveamdmachine::ArchData &arch,
                           const waveamdmachine::EventSimConfig &config) {
  int nextLatency =
      getModelLatency(arch, waveamdmachine::classifyOp(next), config);
  if (nextLatency <= 0)
    return false;
  int memoryLatency = waveamdmachine::getMemoryValueLatency(
      arch, candidate, config.counterLatencies, config.valueLatencies,
      config.calibration);
  // Match LLVM's latency-based load preference; cache policy is orthogonal.
  return static_cast<int64_t>(memoryLatency) >
         10 * static_cast<int64_t>(nextLatency);
}

static unsigned findNextVmemValue(unsigned next, const GreedyRegion &region,
                                  const GraphTables &graph,
                                  const BitVector &scheduled) {
  for (unsigned node : graph.memoryNodes) {
    if (node <= next || scheduled.test(node))
      continue;
    if (waveamdmachine::getMemoryCounterKind(region.ops[node]) ==
        MemoryKind::Vmem)
      return node;
  }
  return region.ops.size();
}

static FailureOr<std::optional<unsigned>>
findReadyPrefetchChainHead(unsigned candidate, unsigned next,
                           const BitVector &ready, const GreedyRegion &region,
                           const GraphTables &graph, const IssueState &state,
                           const BitVector &scheduled,
                           const ValueOriginMap &origins, BitVector &chain) {
  Operation *op = region.ops[candidate];
  if (!waveamdmachine::hasMemoryValueLatency(op) ||
      !canUseStallFiller(region, scheduled, next, candidate, origins))
    return std::optional<unsigned>{};
  if (!collectPrefetchChain(candidate, candidate, next, region, graph,
                            scheduled, chain))
    return std::optional<unsigned>{};

  int first = chain.find_first();
  if (first < 0 || !ready.test(first))
    return std::optional<unsigned>{};
  FailureOr<IssuePreview> preview = previewIssue(state, region.ops[first]);
  if (failed(preview))
    return failure();
  if (stalls(*preview))
    return std::optional<unsigned>{};
  return std::optional<unsigned>(first);
}

static FailureOr<bool>
prefetchReducesCycles(const IssueState &state, unsigned next,
                      const BitVector &chain, unsigned consumer,
                      const GreedyRegion &region, const BitVector &scheduled,
                      const ValueOriginMap &origins) {
  FailureOr<LocalProjection> nextFirst =
      projectPrefetchOrder(state, next, chain, consumer,
                           /*prefetchFirst=*/false, region, scheduled, origins);
  if (failed(nextFirst))
    return failure();
  FailureOr<LocalProjection> prefetchFirst =
      projectPrefetchOrder(state, next, chain, consumer, /*prefetchFirst=*/true,
                           region, scheduled, origins);
  if (failed(prefetchFirst))
    return failure();
  return prefetchFirst->cycles < nextFirst->cycles;
}

static bool isValidPrefetchConsumer(unsigned consumer, unsigned candidate,
                                    unsigned regionSize) {
  return consumer != regionSize && consumer > candidate;
}

static bool
shouldPrioritizeLongLatencyVmem(bool enabled, Operation *candidate,
                                Operation *next,
                                const waveamdmachine::ArchData &arch,
                                const waveamdmachine::EventSimConfig &config) {
  return enabled && isLongLatencyVmemCandidate(candidate, next, arch, config);
}

static FailureOr<unsigned> findReadyVmemPrefetch(
    const BitVector &ready, unsigned next, const GreedyRegion &region,
    const GraphTables &graph, const IssueState &state,
    const BitVector &scheduled, const waveamdmachine::ArchData &arch,
    const waveamdmachine::EventSimConfig &config, const ValueOriginMap &origins,
    bool prioritizeLongLatencyVmem, bool &usedLongLatencyPriority) {
  unsigned candidate = findNextVmemValue(next, region, graph, scheduled);
  if (candidate == region.ops.size())
    return candidate;

  BitVector chain(region.ops.size());
  FailureOr<std::optional<unsigned>> chainHead = findReadyPrefetchChainHead(
      candidate, next, ready, region, graph, state, scheduled, origins, chain);
  if (failed(chainHead))
    return failure();
  if (!*chainHead)
    return region.ops.size();

  Operation *op = region.ops[candidate];
  unsigned consumer = findFirstRealDataConsumer(op, region, graph, scheduled);
  if (!isValidPrefetchConsumer(consumer, candidate, region.ops.size()))
    return region.ops.size();
  if (shouldPrioritizeLongLatencyVmem(prioritizeLongLatencyVmem, op,
                                      region.ops[next], arch, config)) {
    usedLongLatencyPriority = true;
    return **chainHead;
  }
  if (hasPrefetchSlack(next, op, consumer, chain, region, scheduled, arch,
                       config))
    return region.ops.size();
  FailureOr<bool> profitable = prefetchReducesCycles(
      state, next, chain, consumer, region, scheduled, origins);
  if (failed(profitable))
    return failure();
  if (!*profitable)
    return region.ops.size();
  return **chainHead;
}

static FailureOr<bool> canIssueTokenConsumerBeforeNext(
    const GreedyRegion &region, const BitVector &scheduled, unsigned next,
    unsigned consumer, const IssueState &state, const ValueOriginMap &origins) {
  MemoryKindSet consumerKinds =
      collectFillerMemoryKinds(region.ops[consumer], origins);
  if (crossesSameMemoryProducer(region, scheduled, next, consumer,
                                consumerKinds))
    return false;

  std::array<Operation *, 2> original = {region.ops[next],
                                         region.ops[consumer]};
  std::array<Operation *, 2> moved = {region.ops[consumer], region.ops[next]};
  FailureOr<LocalProjection> originalProjection =
      projectIssueOrder(state, original, origins);
  if (failed(originalProjection))
    return failure();
  FailureOr<LocalProjection> movedProjection =
      projectIssueOrder(state, moved, origins);
  if (failed(movedProjection))
    return failure();

  if (region.dmaIssueTiming && isBarrierOp(region.ops[consumer]))
    return movedProjection->memoryWaitCycles <
               originalProjection->memoryWaitCycles ||
           (movedProjection->memoryWaitCycles ==
                originalProjection->memoryWaitCycles &&
            movedProjection->issueBackpressureCycles <
                originalProjection->issueBackpressureCycles);
  return movedProjection->memoryWaitCycles <=
             originalProjection->memoryWaitCycles &&
         movedProjection->issueBackpressureCycles <=
             originalProjection->issueBackpressureCycles;
}

static unsigned findReadyBarrierPairFiller(const BitVector &ready,
                                           const GreedyRegion &region,
                                           const BitVector &scheduled,
                                           unsigned next) {
  if (!isa<waveamdmachine::SBarrierOp>(region.ops[next]))
    return region.ops.size();

  unsigned filler = region.ops.size();
  for (unsigned index : llvm::seq(next + 1, ready.size())) {
    Operation *op = region.ops[index];
    if (isa<waveamdmachine::SBarrierOp>(op))
      return scheduled.test(index) ? region.ops.size() : filler;
    if (!isPure(op))
      return region.ops.size();
    if (scheduled.test(index))
      continue;
    if (filler == region.ops.size()) {
      if (!ready.test(index))
        return region.ops.size();
      filler = index;
    }
  }
  return region.ops.size();
}

static bool shareTokenJoin(waveamdmachine::SBarrierOp lhs,
                           waveamdmachine::SBarrierOp rhs) {
  for (Value result : lhs->getResults())
    for (OpOperand &use : result.getUses()) {
      Operation *user = use.getOwner();
      if (user->hasTrait<traits::TokenJoinOp>() &&
          llvm::any_of(user->getOperands(), [rhs](Value operand) {
            return operand.getDefiningOp() == rhs;
          }))
        return true;
    }
  return false;
}

static FailureOr<unsigned> findReadyNoWaitBarrierRunContinuation(
    const BitVector &ready, const GreedyRegion &region,
    ArrayRef<unsigned> order, const IssueState &state) {
  SmallVector<waveamdmachine::SBarrierOp, 4> run;
  for (unsigned scheduled : llvm::reverse(order)) {
    Operation *op = region.ops[scheduled];
    if (!state.getStaticInfo(op).realInst)
      continue;
    auto barrier = dyn_cast<waveamdmachine::SBarrierOp>(op);
    if (!barrier)
      break;
    run.push_back(barrier);
  }

  for (unsigned index : llvm::seq(ready.size())) {
    auto candidate =
        dyn_cast_if_present<waveamdmachine::SBarrierOp>(region.ops[index]);
    if (!ready.test(index) || !candidate ||
        llvm::none_of(run, [&](waveamdmachine::SBarrierOp barrier) {
          return shareTokenJoin(barrier, candidate);
        }))
      continue;
    FailureOr<IssuePreview> preview = previewIssue(state, candidate);
    if (failed(preview))
      return failure();
    if (preview->memoryWaitCycles == 0)
      return index;
  }
  return region.ops.size();
}

static FailureOr<unsigned>
findReadyTokenConsumer(const BitVector &ready, const GreedyRegion &region,
                       const BitVector &scheduled, unsigned next,
                       const IssueState &state, const ValueOriginMap &origins) {
  for (unsigned index : llvm::seq(next + 1, ready.size())) {
    if (!ready.test(index))
      continue;
    if (!waveamdmachine::waitsForMemoryTokenDepsBeforeIssue(region.ops[index]))
      continue;
    if (findReadyBarrierPairFiller(ready, region, scheduled, index) !=
        region.ops.size())
      return region.ops.size();
    if (isa<waveamdmachine::SBarrierOp>(region.ops[next]) &&
        isa<waveamdmachine::SBarrierOp>(region.ops[index]))
      return region.ops.size();
    FailureOr<bool> canMove = canIssueTokenConsumerBeforeNext(
        region, scheduled, next, index, state, origins);
    if (failed(canMove))
      return failure();
    if (*canMove)
      return index;
  }
  return region.ops.size();
}

static FillableStall getFillableStall(const IssuePreview &preview) {
  if (preview.memoryWaitCycles != 0)
    return {FillableStallKind::MemoryToken, preview.issueCycle};
  if (hasNonMemoryCycleWait(preview))
    return {FillableStallKind::Cycle, preview.issueCycle};
  if (preview.hazardWaitInsts != 0)
    return {FillableStallKind::InstructionHazard, preview.issueCycle};
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

static unsigned findFirstUnscheduledBarrier(const GreedyRegion &region,
                                            const BitVector &scheduled,
                                            unsigned begin) {
  for (unsigned index :
       llvm::seq(begin, static_cast<unsigned>(region.ops.size())))
    if (!scheduled.test(index) && isBarrierOp(region.ops[index]))
      return index;
  return region.ops.size();
}

static unsigned findFirstUnscheduledMemory(const GreedyRegion &region,
                                           const BitVector &scheduled,
                                           unsigned begin) {
  for (unsigned index :
       llvm::seq(begin, static_cast<unsigned>(region.ops.size())))
    if (!scheduled.test(index) && waveamdmachine::getMemoryCounterKind(
                                      region.ops[index]) != MemoryKind::None)
      return index;
  return region.ops.size();
}

static bool isPostBarrierFillerCandidate(unsigned index, const BitVector &ready,
                                         const BitVector &scheduled,
                                         const GreedyRegion &region) {
  Operation *candidate = region.ops[index];
  return ready.test(index) && !scheduled.test(index) && isPure(candidate) &&
         waveamdmachine::getMemoryCounterKind(candidate) == MemoryKind::None;
}

static bool fillsReservedStall(Operation *candidate, FillableStall stall,
                               const IssuePreview &preview,
                               const waveamdmachine::ArchData &arch,
                               const waveamdmachine::EventSimConfig &config) {
  int64_t reserveCycles = static_cast<int64_t>(getIssueCount(candidate)) *
                          waveamdmachine::getEventSimIssuePeriod(arch, config);
  return fillsStall(stall, preview) &&
         preview.nextIssueCycle + reserveCycles <= stall.issueCycle;
}

static FailureOr<unsigned> findDmaDelayPostBarrierFiller(
    const BitVector &ready, unsigned next, const GreedyRegion &region,
    const IssueState &state, const BitVector &scheduled,
    const waveamdmachine::ArchData &arch,
    const waveamdmachine::EventSimConfig &config, FillableStall stall) {
  if (!region.dmaIssueTiming ||
      !isa<waveamdmachine::DmaIssueDelayOp>(region.ops[next]))
    return region.ops.size();

  unsigned barrier = findFirstUnscheduledBarrier(region, scheduled, next + 1);
  if (barrier == region.ops.size())
    return region.ops.size();

  unsigned memory = findFirstUnscheduledMemory(region, scheduled, barrier + 1);
  if (memory == region.ops.size())
    return region.ops.size();

  // Prefix fills barrier wait; downstream work shortens post-barrier path.
  for (unsigned index : llvm::seq(memory + 1, ready.size())) {
    Operation *candidate = region.ops[index];
    if (!isPostBarrierFillerCandidate(index, ready, scheduled, region))
      continue;
    FailureOr<IssuePreview> preview = previewIssue(state, candidate);
    if (failed(preview))
      return failure();
    if (fillsReservedStall(candidate, stall, *preview, arch, config))
      return index;
  }
  return region.ops.size();
}

static FailureOr<unsigned>
findGenericStallFiller(const BitVector &ready, unsigned next,
                       const GreedyRegion &region, const IssueState &state,
                       const BitVector &scheduled, FillableStall stall,
                       const ValueOriginMap &origins) {
  for (unsigned index : llvm::seq(ready.size())) {
    if (!ready.test(index) || index == next)
      continue;
    if (isa<waveamdmachine::SBarrierOp>(region.ops[next]) &&
        isa<waveamdmachine::SBarrierOp>(region.ops[index]))
      continue;
    if (!canUseStallFiller(region, scheduled, next, index, origins))
      continue;
    FailureOr<IssuePreview> preview = previewIssue(state, region.ops[index]);
    if (failed(preview))
      return failure();
    if (fillsStall(stall, *preview))
      return index;
  }
  return ready.size();
}

static FailureOr<unsigned>
findStallFiller(const BitVector &ready, unsigned next,
                const GreedyRegion &region, const IssueState &state,
                const BitVector &scheduled,
                const waveamdmachine::ArchData &arch,
                const waveamdmachine::EventSimConfig &config,
                FillableStall stall, const ValueOriginMap &origins) {
  FailureOr<unsigned> postBarrier = findDmaDelayPostBarrierFiller(
      ready, next, region, state, scheduled, arch, config, stall);
  if (failed(postBarrier) || *postBarrier != region.ops.size())
    return postBarrier;
  return findGenericStallFiller(ready, next, region, state, scheduled, stall,
                                origins);
}

static unsigned findFirstReadyNoInst(const BitVector &ready,
                                     const BitVector &noInsts) {
  for (int readyIndex = ready.find_first(); readyIndex >= 0;
       readyIndex = ready.find_next(readyIndex))
    if (noInsts.test(readyIndex))
      return readyIndex;
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

static LogicalResult
scheduleReadyNode(unsigned selected, const GreedyRegion &region,
                  const GraphTables &graph, IssueState &state, BitVector &ready,
                  BitVector &scheduled, SmallVectorImpl<unsigned> &pending,
                  SmallVectorImpl<unsigned> &order, const IssuePreview &preview,
                  const ValueOriginMap &origins) {
  order.push_back(selected);
  if (failed(commitIssue(state, region.ops[selected], preview, origins)))
    return failure();
  markScheduled(selected, graph, ready, scheduled, pending);
  return success();
}

static LogicalResult
drainReadyNoInsts(const GreedyRegion &region, const GraphTables &graph,
                  IssueState &state, BitVector &ready, BitVector &scheduled,
                  SmallVectorImpl<unsigned> &pending,
                  SmallVectorImpl<unsigned> &order,
                  const ValueOriginMap &origins, const BitVector &noInsts) {
  while (true) {
    unsigned selected = findFirstReadyNoInst(ready, noInsts);
    if (selected == region.ops.size())
      return success();
    FailureOr<IssuePreview> preview = previewIssue(state, region.ops[selected]);
    if (failed(preview))
      return failure();
    if (failed(scheduleReadyNode(selected, region, graph, state, ready,
                                 scheduled, pending, order, *preview, origins)))
      return failure();
  }
}

static FailureOr<bool> previewNextIssue(const GreedyRegion &region,
                                        const IssueState &state, unsigned next,
                                        IssuePreview &nextPreview) {
  FailureOr<IssuePreview> preview = previewIssue(state, region.ops[next]);
  if (failed(preview))
    return failure();
  nextPreview = *preview;
  return !stalls(nextPreview);
}

static LogicalResult
scheduleStallFiller(const GreedyRegion &region, const GraphTables &graph,
                    IssueState &state, BitVector &ready, BitVector &scheduled,
                    SmallVectorImpl<unsigned> &pending,
                    SmallVectorImpl<unsigned> &order, unsigned filler,
                    const ValueOriginMap &origins, const BitVector &noInsts) {
  FailureOr<IssuePreview> fillerPreview =
      previewIssue(state, region.ops[filler]);
  if (failed(fillerPreview))
    return failure();
  if (failed(scheduleReadyNode(filler, region, graph, state, ready, scheduled,
                               pending, order, *fillerPreview, origins)))
    return failure();
  return drainReadyNoInsts(region, graph, state, ready, scheduled, pending,
                           order, origins, noInsts);
}

static void recordFilledStall(Operation *op, const IssuePreview &nextPreview,
                              GreedyStats &stats) {
  ++stats.filledGaps;
  if (nextPreview.memoryWaitCycles != 0 && isBarrierOp(op))
    ++stats.filledBarrierMemoryGaps;
}

static bool nextStillReady(const BitVector &ready, const BitVector &scheduled,
                           unsigned next) {
  return !scheduled.test(next) && ready.test(next);
}

static int64_t
getLdsDmaIssueLead(const waveamdmachine::ArchData &arch,
                   const waveamdmachine::EventSimConfig &config) {
  if (arch.ldsDmaIssueQueueDepth <= 0 || arch.ldsDmaIssueLatency <= 0)
    return 0;
  int64_t issuePeriod = waveamdmachine::getEventSimIssuePeriod(arch, config);
  int64_t serviceInterval =
      arch.ldsDmaIssueLatency / arch.ldsDmaIssueQueueDepth;
  return serviceInterval / issuePeriod * issuePeriod;
}

static bool canLeadLdsDmaIssue(Operation *op, const IssuePreview &preview,
                               const waveamdmachine::ArchData &arch,
                               const waveamdmachine::EventSimConfig &config) {
  int64_t lead = getLdsDmaIssueLead(arch, config);
  return op->hasTrait<traits::LDSDmaOp>() && lead != 0 &&
         preview.fuWaitCycles != 0 && preview.fuWaitCycles <= lead &&
         preview.operandWaitCycles == 0 && preview.memoryWaitCycles == 0 &&
         preview.hazardWaitInsts == 0;
}

static bool
canIssueNextDespiteStall(const GreedyRegion &region, unsigned next,
                         const IssuePreview &preview,
                         const waveamdmachine::ArchData &arch,
                         const waveamdmachine::EventSimConfig &config) {
  Operation *op = region.ops[next];
  bool canLeadDma = region.dmaIssueTiming &&
                    !op->hasAttr(kDmaIssueAfterDelayAttr) &&
                    canLeadLdsDmaIssue(op, preview, arch, config);
  bool emptyBarrierWait =
      isa<waveamdmachine::BarrierWaitOp>(op) && preview.memoryWaitCycles == 0;
  return canLeadDma || emptyBarrierWait;
}

static FailureOr<bool>
fillStallBeforeNext(const GreedyRegion &region, const GraphTables &graph,
                    const waveamdmachine::ArchData &arch,
                    const waveamdmachine::EventSimConfig &config,
                    IssueState &state, BitVector &ready, BitVector &scheduled,
                    SmallVectorImpl<unsigned> &pending,
                    SmallVectorImpl<unsigned> &order, GreedyStats &stats,
                    unsigned next, IssuePreview &nextPreview,
                    const ValueOriginMap &origins, const BitVector &noInsts) {
  while (true) {
    FailureOr<bool> readyNow =
        previewNextIssue(region, state, next, nextPreview);
    if (failed(readyNow))
      return failure();
    if (*readyNow)
      return true;
    if (canIssueNextDespiteStall(region, next, nextPreview, arch, config))
      return true;

    recordGapStats(region.ops[next], nextPreview, stats);
    FillableStall stall = getFillableStall(nextPreview);
    FailureOr<unsigned> filler = findStallFiller(
        ready, next, region, state, scheduled, arch, config, stall, origins);
    if (failed(filler))
      return failure();
    if (*filler == region.ops.size()) {
      ++stats.unfilledGaps;
      return true;
    }

    recordFilledStall(region.ops[next], nextPreview, stats);
    if (failed(scheduleStallFiller(region, graph, state, ready, scheduled,
                                   pending, order, *filler, origins, noInsts)))
      return failure();
    if (!nextStillReady(ready, scheduled, next))
      return false;
  }
}

static GreedyResult failGreedyModel(GreedyResult &result) {
  result.failureReason = "model_failed";
  return result;
}

static FailureOr<GreedyStepStatus> scheduleReadyByIndex(
    unsigned selected, const GreedyRegion &region, const GraphTables &graph,
    IssueState &state, BitVector &ready, BitVector &scheduled,
    SmallVectorImpl<unsigned> &pending, SmallVectorImpl<unsigned> &order,
    const ValueOriginMap &origins) {
  FailureOr<IssuePreview> selectedPreview =
      previewIssue(state, region.ops[selected]);
  if (failed(selectedPreview))
    return failure();
  if (failed(scheduleReadyNode(selected, region, graph, state, ready, scheduled,
                               pending, order, *selectedPreview, origins)))
    return failure();
  return GreedyStepStatus::Continue;
}

static FailureOr<GreedyStepStatus> scheduleFirstReadyByOriginal(
    const GreedyRegion &region, const GraphTables &graph, IssueState &state,
    BitVector &ready, BitVector &scheduled, SmallVectorImpl<unsigned> &pending,
    SmallVectorImpl<unsigned> &order, const ValueOriginMap &origins) {
  unsigned selected = findFirstReadyByOriginal(ready);
  return scheduleReadyByIndex(selected, region, graph, state, ready, scheduled,
                              pending, order, origins);
}

static FailureOr<GreedyStepStatus>
scheduleOriginalNext(const GreedyRegion &region, const GraphTables &graph,
                     const waveamdmachine::ArchData &arch,
                     const waveamdmachine::EventSimConfig &config,
                     IssueState &state, BitVector &ready, BitVector &scheduled,
                     SmallVectorImpl<unsigned> &pending, GreedyResult &result,
                     unsigned next, const ValueOriginMap &origins,
                     const BitVector &noInsts) {
  IssuePreview preview;
  FailureOr<bool> filled = fillStallBeforeNext(
      region, graph, arch, config, state, ready, scheduled, pending,
      result.order, result.stats, next, preview, origins, noInsts);
  if (failed(filled))
    return failure();
  if (!*filled)
    return GreedyStepStatus::Continue;
  if (scheduled.test(next))
    return GreedyStepStatus::Continue;
  if (failed(scheduleReadyNode(next, region, graph, state, ready, scheduled,
                               pending, result.order, preview, origins)))
    return failure();
  return GreedyStepStatus::Continue;
}

static bool isPureComputeIslandOp(Operation *op, const StaticIssueInfo &info) {
  if (!isPure(op) || isBarrierOp(op) ||
      waveamdmachine::getMemoryCounterKind(op) != MemoryKind::None)
    return false;
  return !info.realInst || tracksComputeResource(info.fu);
}

static SmallVector<unsigned, 16>
buildComputeIslandEnds(const GreedyRegion &region,
                       const StaticIssueInfoMap &staticInfo) {
  SmallVector<unsigned, 16> ends(region.ops.size());
  unsigned end = region.ops.size();
  for (unsigned index : llvm::reverse(
           llvm::seq<unsigned>(0, static_cast<unsigned>(region.ops.size())))) {
    if (!isPureComputeIslandOp(
            region.ops[index],
            getStaticIssueInfo(staticInfo, region.ops[index])))
      end = index;
    ends[index] = end;
  }
  return ends;
}

static BitVector buildNoInsts(const GreedyRegion &region,
                              const StaticIssueInfoMap &staticInfo) {
  BitVector noInsts(region.ops.size());
  for (unsigned index : llvm::seq<unsigned>(0, region.ops.size()))
    if (!getStaticIssueInfo(staticInfo, region.ops[index]).realInst)
      noInsts.set(index);
  return noInsts;
}

static bool isReadyComputeResourceCandidate(const IssuePreview &preview) {
  return !stalls(preview) && preview.resource.releaseSlots != 0 &&
         preview.resource.waitSlots == 0;
}

static bool
shouldPreviewComputeResource(const ComputeResourcePreview &next,
                             const ComputeResourcePreview &candidate,
                             unsigned selectedRelease) {
  if (candidate.releaseSlots == 0 || candidate.waitSlots != 0)
    return false;
  if (next.waitSlots != 0)
    return true;
  return candidate.fu != next.fu &&
         candidate.releaseSlots > next.releaseSlots &&
         candidate.releaseSlots > selectedRelease;
}

static bool shouldPrioritizeComputeResource(const IssuePreview &next,
                                            const IssuePreview &candidate,
                                            unsigned selectedRelease) {
  return candidate.resource.fu != next.resource.fu &&
         candidate.resource.releaseSlots > next.resource.releaseSlots &&
         candidate.resource.releaseSlots > selectedRelease;
}

static FailureOr<unsigned> findComputeResourceCandidate(
    const BitVector &ready, unsigned next, unsigned islandEnd,
    const GreedyRegion &region, const IssueState &state,
    const IssuePreview &nextPreview, bool &fillsResourceStall) {
  unsigned selected = region.ops.size();
  unsigned selectedRelease = 0;
  for (int readyIndex = ready.find_next(next);
       readyIndex >= 0 && static_cast<unsigned>(readyIndex) < islandEnd;
       readyIndex = ready.find_next(readyIndex)) {
    unsigned index = readyIndex;
    ComputeResourcePreview resource =
        state.resources.preview(state.getStaticInfo(region.ops[index]));
    if (!shouldPreviewComputeResource(nextPreview.resource, resource,
                                      selectedRelease))
      continue;
    FailureOr<IssuePreview> candidate =
        previewIssue(state, region.ops[index], resource);
    if (failed(candidate))
      return failure();
    if (!isReadyComputeResourceCandidate(*candidate))
      continue;

    if (nextPreview.resource.waitSlots != 0) {
      fillsResourceStall = true;
      return index;
    }
    if (!shouldPrioritizeComputeResource(nextPreview, *candidate,
                                         selectedRelease))
      continue;
    selected = index;
    selectedRelease = candidate->resource.releaseSlots;
  }
  return selected;
}

static FailureOr<unsigned> findReadyComputeResourceAlternative(
    const BitVector &ready, unsigned next, const GreedyRegion &region,
    const IssueState &state, ArrayRef<unsigned> computeIslandEnds,
    bool &fillsResourceStall) {
  fillsResourceStall = false;
  if (!isPureComputeIslandOp(region.ops[next],
                             state.getStaticInfo(region.ops[next])))
    return region.ops.size();

  FailureOr<IssuePreview> nextPreview = previewIssue(state, region.ops[next]);
  if (failed(nextPreview))
    return failure();
  if (stalls(*nextPreview) || nextPreview->resource.releaseSlots == 0)
    return region.ops.size();

  unsigned islandEnd = computeIslandEnds[next];
  return findComputeResourceCandidate(ready, next, islandEnd, region, state,
                                      *nextPreview, fillsResourceStall);
}

static FailureOr<std::optional<unsigned>> findReadyComputeAlternative(
    const BitVector &ready, unsigned next, const GreedyRegion &region,
    const IssueState &state, ArrayRef<unsigned> computeIslandEnds,
    GreedyStats &stats, bool prioritizeComputeResources) {
  if (!prioritizeComputeResources)
    return std::optional<unsigned>{};
  bool fillsResourceStall = false;
  FailureOr<unsigned> compute = findReadyComputeResourceAlternative(
      ready, next, region, state, computeIslandEnds, fillsResourceStall);
  if (failed(compute))
    return failure();
  if (*compute == region.ops.size())
    return std::optional<unsigned>{};
  if (fillsResourceStall)
    ++stats.resourceStallFills;
  else
    ++stats.resourcePriorityMoves;
  return std::optional<unsigned>(*compute);
}

static FailureOr<std::optional<unsigned>> findReadyAlternative(
    const BitVector &ready, unsigned next, const GreedyRegion &region,
    const GraphTables &graph, const IssueState &state,
    const BitVector &scheduled, const waveamdmachine::ArchData &arch,
    const waveamdmachine::EventSimConfig &config, const ValueOriginMap &origins,
    ArrayRef<unsigned> computeIslandEnds, GreedyStats &stats,
    bool prioritizeLongLatencyVmem, bool prioritizeComputeResources,
    bool prefillLoopCarriedWaits) {
  if (prefillLoopCarriedWaits) {
    FailureOr<unsigned> filler = findLoopCarriedWaitFiller(
        ready, next, region, state, scheduled, origins);
    if (failed(filler))
      return failure();
    if (*filler != region.ops.size()) {
      ++stats.loopCarriedWaitFills;
      return std::optional<unsigned>(*filler);
    }
  }
  FailureOr<unsigned> consumer =
      findReadyTokenConsumer(ready, region, scheduled, next, state, origins);
  if (failed(consumer))
    return failure();
  if (*consumer != region.ops.size())
    return std::optional<unsigned>(*consumer);

  unsigned filler = findReadyBarrierPairFiller(ready, region, scheduled, next);
  if (filler != region.ops.size())
    return std::optional<unsigned>(filler);

  bool usedLongLatencyPriority = false;
  FailureOr<unsigned> prefetch = findReadyVmemPrefetch(
      ready, next, region, graph, state, scheduled, arch, config, origins,
      prioritizeLongLatencyVmem, usedLongLatencyPriority);
  if (failed(prefetch))
    return failure();
  if (*prefetch != region.ops.size()) {
    ++stats.vmemPrefetchMoves;
    if (usedLongLatencyPriority)
      ++stats.longLatencyVmemPrefetchMoves;
    return std::optional<unsigned>(*prefetch);
  }

  return findReadyComputeAlternative(ready, next, region, state,
                                     computeIslandEnds, stats,
                                     prioritizeComputeResources);
}

static FailureOr<GreedyStepStatus>
buildGreedyStep(const GreedyRegion &region, const GraphTables &graph,
                const waveamdmachine::ArchData &arch,
                const waveamdmachine::EventSimConfig &config, IssueState &state,
                BitVector &ready, BitVector &scheduled,
                SmallVectorImpl<unsigned> &pending, GreedyResult &result,
                const ValueOriginMap &origins,
                ArrayRef<unsigned> computeIslandEnds, const BitVector &noInsts,
                bool prioritizeLongLatencyVmem, bool prioritizeComputeResources,
                bool prefillLoopCarriedWaits) {
  if (failed(drainReadyNoInsts(region, graph, state, ready, scheduled, pending,
                               result.order, origins, noInsts)))
    return failure();
  if (result.order.size() == region.ops.size())
    return GreedyStepStatus::Done;
  if (!ready.any()) {
    recordDependencyCycle(graph, scheduled, pending, result);
    return GreedyStepStatus::Blocked;
  }

  unsigned next = findFirstUnscheduled(scheduled);
  FailureOr<unsigned> barrier =
      findReadyNoWaitBarrierRunContinuation(ready, region, result.order, state);
  if (failed(barrier))
    return failure();
  if (*barrier != region.ops.size())
    return scheduleReadyByIndex(*barrier, region, graph, state, ready,
                                scheduled, pending, result.order, origins);

  if (ready.test(next)) {
    FailureOr<std::optional<unsigned>> alternative = findReadyAlternative(
        ready, next, region, graph, state, scheduled, arch, config, origins,
        computeIslandEnds, result.stats, prioritizeLongLatencyVmem,
        prioritizeComputeResources, prefillLoopCarriedWaits);
    if (failed(alternative))
      return failure();
    if (*alternative)
      return scheduleReadyByIndex(**alternative, region, graph, state, ready,
                                  scheduled, pending, result.order, origins);
  }

  if (!ready.test(next))
    return scheduleFirstReadyByOriginal(region, graph, state, ready, scheduled,
                                        pending, result.order, origins);
  return scheduleOriginalNext(region, graph, arch, config, state, ready,
                              scheduled, pending, result, next, origins,
                              noInsts);
}

static GreedyResult
buildGreedyOrder(const GreedyRegion &region, const GraphTables &graph,
                 const waveamdmachine::ArchData &arch,
                 const waveamdmachine::EventSimConfig &config,
                 const ValueOriginMap &origins,
                 bool prioritizeLongLatencyVmem = true,
                 bool prioritizeComputeResources = true,
                 bool prefillLoopCarriedWaits = true) {
  GreedyResult result;
  SmallVector<unsigned, 16> pending = graph.pendingPreds;
  BitVector ready(region.ops.size());
  BitVector scheduled(region.ops.size());
  for (auto [index, count] : llvm::enumerate(pending))
    if (count == 0)
      ready.set(index);

  StaticIssueInfoMap staticInfo = buildStaticIssueInfoMap(region, arch);
  SmallVector<unsigned, 16> computeIslandEnds =
      buildComputeIslandEnds(region, staticInfo);
  BitVector noInsts = buildNoInsts(region, staticInfo);
  IssueState state(arch, buildInstructionConfig(arch, config), staticInfo);
  bindValueOrigins(state.model, origins);
  while (result.order.size() != region.ops.size()) {
    FailureOr<GreedyStepStatus> step = buildGreedyStep(
        region, graph, arch, config, state, ready, scheduled, pending, result,
        origins, computeIslandEnds, noInsts, prioritizeLongLatencyVmem,
        prioritizeComputeResources, prefillLoopCarriedWaits);
    if (failed(step))
      return failGreedyModel(result);
    if (*step == GreedyStepStatus::Done)
      break;
    if (*step == GreedyStepStatus::Blocked)
      return result;
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

struct PeakRegisterPressure {
  unsigned sgpr = 0;
  unsigned vgpr = 0;
  unsigned agpr = 0;
  unsigned vgprFamily = 0;
};

struct RegisterPressureLimits {
  unsigned sgpr = 0;
  unsigned vgpr = 0;
  unsigned agpr = 0;
  std::optional<unsigned> vgprFamily;
};

struct RegisterPressureEvent {
  unsigned position = 0;
  unsigned slot = 0;
  int delta = 0;
};

static void
appendRegisterPressureEvents(const WaveAMDLiveInterval &interval,
                             unsigned eventCount,
                             SmallVectorImpl<RegisterPressureEvent> &events) {
  unsigned intervalWidth = interval.type.getWidth();
  for (auto [value, slot, start, end] :
       llvm::zip(interval.values, interval.slotOffsets, interval.valueStarts,
                 interval.valueEnds)) {
    unsigned valueWidth =
        cast<waveamdmachine::RegType>(value.getType()).getWidth();
    assert(start <= end && end + 1 < eventCount &&
           slot + valueWidth <= intervalWidth && "invalid live interval range");
    for (unsigned bit : llvm::seq<unsigned>(slot, slot + valueWidth)) {
      events.push_back({start, bit, 1});
      events.push_back({end + 1, bit, -1});
    }
  }
}

static void
applyRegisterPressureEvents(ArrayRef<RegisterPressureEvent> events,
                            unsigned intervalWidth,
                            MutableArrayRef<int64_t> pressureChanges) {
  SmallVector<unsigned, 16> slotUseCounts(intervalWidth, 0);
  unsigned liveWidth = 0;
  for (unsigned first = 0; first < events.size();) {
    unsigned position = events[first].position;
    unsigned oldLiveWidth = liveWidth;
    unsigned last = first;
    while (last < events.size() && events[last].position == position) {
      RegisterPressureEvent event = events[last++];
      unsigned &useCount = slotUseCounts[event.slot];
      if (event.delta > 0) {
        if (useCount++ == 0)
          ++liveWidth;
      } else {
        assert(useCount > 0 && "live interval slot count underflow");
        if (--useCount == 0)
          --liveWidth;
      }
    }
    pressureChanges[position] += static_cast<int64_t>(liveWidth) - oldLiveWidth;
    first = last;
  }
  assert(liveWidth == 0 && "unbalanced live interval events");
}

static void
addRegisterPressureChanges(ArrayRef<WaveAMDLiveInterval> intervals,
                           MutableArrayRef<int64_t> pressureChanges) {
  for (const WaveAMDLiveInterval &interval : intervals) {
    if (interval.values.empty())
      continue;

    SmallVector<RegisterPressureEvent, 16> events;
    appendRegisterPressureEvents(interval, pressureChanges.size(), events);
    llvm::sort(events, [](const RegisterPressureEvent &lhs,
                          const RegisterPressureEvent &rhs) {
      return lhs.position < rhs.position;
    });
    applyRegisterPressureEvents(events, interval.type.getWidth(),
                                pressureChanges);
  }
}

static PeakRegisterPressure
getPeakRegisterPressure(const WaveAMDLiveIntervalBuildResult &liveness) {
  unsigned eventCount = liveness.orderedOps.size() + 1;
  SmallVector<int64_t> sgprChanges(eventCount, 0);
  SmallVector<int64_t> vgprChanges(eventCount, 0);
  SmallVector<int64_t> agprChanges(eventCount, 0);
  addRegisterPressureChanges(liveness.intervals.sgprs, sgprChanges);
  addRegisterPressureChanges(liveness.intervals.vgprs, vgprChanges);
  addRegisterPressureChanges(liveness.intervals.agprs, agprChanges);

  PeakRegisterPressure peak;
  int64_t sgpr = 0;
  int64_t vgpr = 0;
  int64_t agpr = 0;
  for (unsigned position : llvm::seq<unsigned>(liveness.orderedOps.size())) {
    sgpr += sgprChanges[position];
    vgpr += vgprChanges[position];
    agpr += agprChanges[position];
    assert(sgpr >= 0 && vgpr >= 0 && agpr >= 0 &&
           "register pressure underflow");
    peak.sgpr = std::max(peak.sgpr, static_cast<unsigned>(sgpr));
    peak.vgpr = std::max(peak.vgpr, static_cast<unsigned>(vgpr));
    peak.agpr = std::max(peak.agpr, static_cast<unsigned>(agpr));
    peak.vgprFamily =
        std::max(peak.vgprFamily, static_cast<unsigned>(vgpr + agpr));
  }
  return peak;
}

static FailureOr<PeakRegisterPressure>
getCandidateRegisterPressure(const GreedyRegion &region,
                             ArrayRef<unsigned> order) {
  SmallVector<Operation *, 16> ops;
  materializeOrder(region, order, ops);
  FailureOr<WaveAMDLiveIntervalBuildResult> liveness =
      buildAllocatedWaveAMDLiveIntervals(
          region.func, WaveAMDLiveIntervalOrderOverride{ops, region.block},
          WaveAMDLiveIntervalAliasPolicy::Conservative);
  if (failed(liveness))
    return failure();
  return getPeakRegisterPressure(*liveness);
}

static FailureOr<PeakRegisterPressure>
getCurrentRegisterPressure(func::FuncOp func) {
  FailureOr<WaveAMDLiveIntervalBuildResult> liveness =
      buildAllocatedWaveAMDLiveIntervals(
          func, WaveAMDLiveIntervalOrderOverride{},
          WaveAMDLiveIntervalAliasPolicy::Conservative);
  if (failed(liveness))
    return failure();
  return getPeakRegisterPressure(*liveness);
}

static FailureOr<RegisterPressureLimits>
getRegisterPressureLimits(func::FuncOp func) {
  RegisterPressureLimits limits;
  limits.sgpr =
      getRegAllocTransformBudget(func, waveamdmachine::RegClass::SGPR).limit;
  limits.vgpr =
      getRegAllocTransformBudget(func, waveamdmachine::RegClass::VGPR).limit;
  limits.agpr =
      getRegAllocTransformBudget(func, waveamdmachine::RegClass::AGPR).limit;
  FailureOr<std::optional<RegAllocTransformBudget>> familyBudget =
      getRegAllocTransformVGPRFamilyBudget(func);
  if (failed(familyBudget))
    return failure();
  if (*familyBudget)
    limits.vgprFamily = (*familyBudget)->limit;
  return limits;
}

static bool isWithinRegisterPressureLimits(
    PeakRegisterPressure candidate, const RegisterPressureLimits &limits,
    std::optional<PeakRegisterPressure> current = std::nullopt) {
  unsigned sgprLimit =
      current ? std::max(limits.sgpr, current->sgpr) : limits.sgpr;
  if (candidate.sgpr > sgprLimit)
    return false;
  if (limits.vgprFamily) {
    unsigned familyLimit =
        current ? std::max(*limits.vgprFamily, current->vgprFamily)
                : *limits.vgprFamily;
    return candidate.vgprFamily <= familyLimit;
  }
  unsigned vgprLimit =
      current ? std::max(limits.vgpr, current->vgpr) : limits.vgpr;
  unsigned agprLimit =
      current ? std::max(limits.agpr, current->agpr) : limits.agpr;
  return candidate.vgpr <= vgprLimit && candidate.agpr <= agprLimit;
}

static FailureOr<bool> isRegisterPressureSafe(const GreedyRegion &region,
                                              ArrayRef<unsigned> order) {
  FailureOr<PeakRegisterPressure> candidate =
      getCandidateRegisterPressure(region, order);
  FailureOr<RegisterPressureLimits> limits =
      getRegisterPressureLimits(region.func);
  if (failed(candidate) || failed(limits))
    return failure();
  if (isWithinRegisterPressureLimits(*candidate, *limits))
    return true;

  FailureOr<PeakRegisterPressure> current =
      getCurrentRegisterPressure(region.func);
  if (failed(current))
    return failure();
  return isWithinRegisterPressureLimits(*candidate, *limits, *current);
}

static FailureOr<bool> needsRegisterPressureFallback(const GreedyRegion &region,
                                                     ArrayRef<unsigned> order,
                                                     bool policyEnabled,
                                                     bool orderChanged) {
  if (!policyEnabled || !orderChanged)
    return false;
  FailureOr<bool> pressureSafe = isRegisterPressureSafe(region, order);
  if (failed(pressureSafe))
    return failure();
  return !*pressureSafe;
}

struct RegisterPressurePolicy {
  bool *enabled;
  bool changedOrder;
};

static FailureOr<bool>
applyRegisterPressureFallback(const GreedyRegion &region,
                              ArrayRef<unsigned> order,
                              ArrayRef<RegisterPressurePolicy> policies) {
  for (RegisterPressurePolicy policy : policies) {
    FailureOr<bool> drop = needsRegisterPressureFallback(
        region, order, *policy.enabled, policy.changedOrder);
    if (failed(drop))
      return failure();
    if (*drop) {
      *policy.enabled = false;
      return true;
    }
  }
  return false;
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
  score.cycles = result.totalCycles;
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
               << " store_data_gaps=" << stats.storeDataGaps
               << " vmem_prefetch_moves=" << stats.vmemPrefetchMoves
               << " long_latency_vmem_prefetch_moves="
               << stats.longLatencyVmemPrefetchMoves
               << " memory_token_gaps=" << stats.memoryTokenGaps
               << " barrier_memory_gaps=" << stats.barrierMemoryGaps
               << " filled_barrier_memory_gaps="
               << stats.filledBarrierMemoryGaps
               << " loop_carried_wait_fills=" << stats.loopCarriedWaitFills
               << " resource_priority_moves=" << stats.resourcePriorityMoves
               << " resource_stall_fills=" << stats.resourceStallFills << "\n";
}

static bool hasLocalDmaIssueTiming(Block &block) {
  if (!isa_and_nonnull<waveamdmachine::UniformLoopOp>(block.getParentOp()))
    return false;
  return llvm::any_of(block.without_terminator(), [](Operation &op) {
    return op.hasAttr(kDmaIssueTimingAttr) ||
           isa<waveamdmachine::DmaIssueDelayOp>(op);
  });
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
    region.dmaIssueTiming = hasLocalDmaIssueTiming(block);
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
    MachineScheduleStageTiming timing;
    TimingScope setupTiming = timing.nest("machine_schedule_setup");
    Operation *root = getOperation();
    if (failed(validateOptions(root)))
      return signalPassFailure();

    waveamdmachine::EventSimConfig modelConfig = buildModelConfig();
    setupTiming.stop();
    WalkResult walk = root->walk([&](func::FuncOp func) {
      return processFunction(func, modelConfig, timing);
    });
    if (walk.wasInterrupted())
      return signalPassFailure();
  }

  LogicalResult validateOptions(Operation *op) {
    if (maxRegionOps < -1)
      return op->emitError("max-region-ops must be -1 or non-negative");
    return success();
  }

  WalkResult processFunction(func::FuncOp func,
                             const waveamdmachine::EventSimConfig &modelConfig,
                             MachineScheduleStageTiming &timing) {
    TimingScope prepareTiming =
        timing.nest("machine_schedule_prepare_function");
    if (!shouldScheduleFunction(func))
      return WalkResult::advance();

    ArchResolution arch = resolveArch(func);
    if (failed(reportArchFailure(func, arch)))
      return WalkResult::interrupt();

    if (!applySchedule)
      return WalkResult::advance();
    func->removeAttr(kScheduleInputAttr);
    prepareTiming.stop();

    TimingScope collectTiming = timing.nest("machine_schedule_collect_regions");
    FailureOr<SmallVector<GreedyRegion, 16>> collected =
        RegionCollector().collect(func);
    if (failed(collected))
      return WalkResult::interrupt();
    collectTiming.stop();

    TimingScope originsTiming =
        timing.nest("machine_schedule_build_value_origins");
    ValueOriginMap origins = buildValueOriginMap(func);
    originsTiming.stop();
    for (const GreedyRegion &region : *collected)
      if (failed(
              processRegion(region, *arch.arch, modelConfig, origins, timing)))
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

    printDecision(region, "apply", getGreedyMoveReason(greedy.stats),
                  greedy.stats);
    applyOrder(region, greedy.order);
    return success();
  }

  LogicalResult processRegion(const GreedyRegion &region,
                              const waveamdmachine::ArchData &arch,
                              const waveamdmachine::EventSimConfig &config,
                              const ValueOriginMap &origins,
                              MachineScheduleStageTiming &timing) {
    if (maxRegionOps >= 0 &&
        region.ops.size() > static_cast<unsigned>(maxRegionOps))
      return success();

    TimingScope graphTiming = timing.nest("machine_schedule_build_graph");
    GraphTables graph;
    if (failed(buildGraph(region, graph)))
      return failure();
    graphTiming.stop();

    bool prioritizeLongLatencyVmem = true;
    bool prioritizeComputeResources = true;
    bool prefillLoopCarriedWaits = region.dmaIssueTiming;
    GreedyResult greedy;
    while (true) {
      TimingScope orderTiming = timing.nest("machine_schedule_build_order");
      greedy = buildGreedyOrder(
          region, graph, arch, config, origins, prioritizeLongLatencyVmem,
          prioritizeComputeResources, prefillLoopCarriedWaits);
      if (!greedy.success)
        return emitGreedyFailure(region, greedy);
      orderTiming.stop();

      TimingScope pressureTiming =
          timing.nest("machine_schedule_pressure_checks");
      std::array policies{
          RegisterPressurePolicy{&prioritizeLongLatencyVmem,
                                 greedy.stats.longLatencyVmemPrefetchMoves !=
                                     0},
          RegisterPressurePolicy{&prioritizeComputeResources,
                                 hasComputeResourceMoves(greedy.stats)},
          RegisterPressurePolicy{&prefillLoopCarriedWaits,
                                 filledLoopCarriedWait(greedy.stats)}};
      FailureOr<bool> retry =
          applyRegisterPressureFallback(region, greedy.order, policies);
      if (failed(retry))
        return failure();
      if (*retry)
        continue;
      pressureTiming.stop();
      break;
    }

    TimingScope applyTiming = timing.nest("machine_schedule_apply_order");
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
                 << " latency=" << getModelLatency(arch, cls, config)
                 << " resource_cycles="
                 << waveamdmachine::getResourceCycles(arch, cls) << "\n";
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

    waveamdmachine::EventSimConfig modelConfig = buildModelConfig();
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

    ValueOriginMap origins = buildValueOriginMap(func);
    for (const GreedyRegion &region : *collected)
      if (failed(reportRegion(region, *arch.arch, modelConfig, parsedOrder,
                              origins)))
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
                        const waveamdmachine::EventSimConfig &config,
                        const ValueOriginMap &origins) {
    if (!printCandidates)
      return success();

    GreedyResult greedy =
        buildGreedyOrder(region, graph, arch, config, origins);
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
      reason = getGreedyMoveReason(greedy.stats);
      if (reason == "greedy" && succeeded(originalScore) &&
          succeeded(greedyScore) && greedyScore->cycles < originalScore->cycles)
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
                             ArrayRef<unsigned> parsedOrder,
                             const ValueOriginMap &origins) {
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
                                 arch, config, origins);
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
                 << " store_data_gaps=" << stats.storeDataGaps
                 << " vmem_prefetch_moves=" << stats.vmemPrefetchMoves
                 << " memory_token_gaps=" << stats.memoryTokenGaps
                 << " barrier_memory_gaps=" << stats.barrierMemoryGaps
                 << " filled_barrier_memory_gaps="
                 << stats.filledBarrierMemoryGaps
                 << " loop_carried_wait_fills=" << stats.loopCarriedWaitFills
                 << " resource_priority_moves=" << stats.resourcePriorityMoves
                 << " resource_stall_fills=" << stats.resourceStallFills
                 << " order=";
    printOrder(order);
    llvm::errs() << "\n";
  }
};

} // namespace
