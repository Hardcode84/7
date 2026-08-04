//===- WaveAMDMachineGreedySchedule.cpp - Greedy machine scheduler --------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/Wave/Transforms/Passes.h"

#include "WaveAMDMachineScheduleEligibility.h"
#include "WaveAMDMachineScheduleModel.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/WaveAMDMachine/CostModel/ArchData.h"
#include "mlir/Dialect/WaveAMDMachine/CostModel/CalibrationData.h"
#include "mlir/Dialect/WaveAMDMachine/CostModel/EventSimulator.h"
#include "mlir/Dialect/WaveAMDMachine/CostModel/InstructionExecutionState.h"
#include "mlir/Dialect/WaveAMDMachine/CostModel/LatencyTable.h"
#include "mlir/Dialect/WaveAMDMachine/CostModel/MemoryCounterTiming.h"
#include "mlir/Dialect/WaveAMDMachine/CostModel/MultiWaveExecutionState.h"
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
#include <functional>
#include <memory>
#include <optional>
#include <queue>
#include <utility>
#include <variant>
#include <vector>

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
static constexpr StringLiteral kMultiWaveScheduleAttr =
    "waveamdmachine.multi_wave_schedule";
static constexpr StringLiteral kBarrierSitesAttr =
    "waveamdmachine.barrier_sites";
static constexpr StringLiteral kReportPrefix =
    "waveamd-machine-schedule-report";
static constexpr unsigned kSteadyStateIterations = 4;
static constexpr unsigned kSteadyStateRefinementLimit = 3;
static constexpr unsigned kSteadyStateFillsPerTarget = 16;
static constexpr unsigned kMultiWaveClassCount = 2;

enum class EdgeKind : uint8_t {
  Ssa,
  MemToken,
  Singleton,
  Exec,
  LoopCarry,
};

using FillableStallKind = ReadyScheduleStallKind;
using FillableStall = ReadyScheduleStallFacts;

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

using MemoryKind = waveamdmachine::MemoryCounterKind;
using MemoryKindSet = SmallVector<MemoryKind, 4>;
using MemoryResourceMask = waveamdmachine::MemoryIssueResourceMask;

struct GraphTables {
  DenseMap<Operation *, unsigned> node;
  SmallVector<ScheduleEdge, 32> edges;
  SmallVector<SmallVector<unsigned, 4>, 16> predecessors;
  SmallVector<SmallVector<unsigned, 4>, 16> successors;
  SmallVector<MemoryKind, 16> memoryKinds;
  SmallVector<MemoryKindSet, 16> fillerMemoryKinds;
  SmallVector<unsigned, 16> memoryNodes;
  SmallVector<unsigned, 8> memoryRecurrenceSources;
  SmallVector<unsigned, 8> computeRecurrenceSources;
  BitVector computeRecurrenceCritical;
  SmallVector<unsigned, 16> pendingPreds;
};

struct SteadyStallTarget {
  unsigned index = 0;
  unsigned fills = 0;
};

struct ValueOriginBinding {
  SmallVector<Value, 4> leaves;
  Value target;
};

struct ValueOriginMap {
  DenseMap<Value, SmallVector<Value, 4>> sources;
  SmallVector<ValueOriginBinding, 16> bindings;
  DenseMap<Operation *, SmallVector<unsigned, 4>> bindingsByDef;
};

struct StaticIssueInfo {
  unsigned issues = 0;
  waveamdmachine::SchedClass cls = waveamdmachine::SchedClass::NoInst;
  waveamdmachine::InstructionScheduleResourceInfo resource;
  bool realInst = false;
  bool memoryIssuer = false;
};

using StaticIssueInfoMap = DenseMap<Operation *, StaticIssueInfo>;

static const StaticIssueInfo &
getStaticIssueInfo(const StaticIssueInfoMap &staticInfo, Operation *op) {
  StaticIssueInfoMap::const_iterator it = staticInfo.find(op);
  assert(it != staticInfo.end() && "missing static issue info");
  return it->second;
}

static unsigned
getMultiWaveClass(const waveamdmachine::MultiWaveExecutionState &state,
                  unsigned wave) {
  return state.getWaveCohort(wave, kMultiWaveClassCount);
}

class IssueExecutionModel {
public:
  IssueExecutionModel(const waveamdmachine::ArchData &arch,
                      waveamdmachine::InstructionExecutionConfig config)
      : state(std::in_place_type<waveamdmachine::InstructionExecutionState>,
              arch, config) {}

  IssueExecutionModel(const waveamdmachine::MultiWaveExecutionState &state,
                      ArrayRef<unsigned> waves)
      : state(std::in_place_type<waveamdmachine::MultiWaveCohortExecutionState>,
              state, waves) {}

  FailureOr<waveamdmachine::InstructionCommitResult> commit(Operation *op) {
    if (auto *single =
            std::get_if<waveamdmachine::InstructionExecutionState>(&state))
      return single->commit(op);
    return std::get<waveamdmachine::MultiWaveCohortExecutionState>(state)
        .commit(op);
  }

  int64_t getCurrentCycle() const {
    if (const auto *single =
            std::get_if<waveamdmachine::InstructionExecutionState>(&state))
      return single->getCurrentCycle();
    return std::get<waveamdmachine::MultiWaveCohortExecutionState>(state)
        .getCurrentCycle();
  }

  void bindValue(Value result, Value source) {
    if (auto *single =
            std::get_if<waveamdmachine::InstructionExecutionState>(&state)) {
      single->bindValue(result, source);
      return;
    }
    std::get<waveamdmachine::MultiWaveCohortExecutionState>(state).bindValue(
        result, source);
  }

  void bindValue(Value result, ArrayRef<Value> sources) {
    if (auto *single =
            std::get_if<waveamdmachine::InstructionExecutionState>(&state)) {
      single->bindValue(result, sources);
      return;
    }
    std::get<waveamdmachine::MultiWaveCohortExecutionState>(state).bindValue(
        result, sources);
  }

  void setMultiWaveState(
      std::unique_ptr<waveamdmachine::MultiWaveExecutionState> newState) {
    std::get<waveamdmachine::MultiWaveCohortExecutionState>(state).setState(
        std::move(newState));
  }
  std::unique_ptr<waveamdmachine::MultiWaveExecutionState>
  takeMultiWaveState() {
    return std::get<waveamdmachine::MultiWaveCohortExecutionState>(state)
        .takeState();
  }

  const waveamdmachine::InstructionScheduleModel &getScheduleModel() const {
    if (const auto *single =
            std::get_if<waveamdmachine::InstructionExecutionState>(&state))
      return single->getScheduleModel();
    return std::get<waveamdmachine::MultiWaveCohortExecutionState>(state)
        .getScheduleModel();
  }

  bool hasSharedResourceState() const {
    if (const auto *single =
            std::get_if<waveamdmachine::InstructionExecutionState>(&state))
      return single->hasSharedResourceState();
    return std::get<waveamdmachine::MultiWaveCohortExecutionState>(state)
        .hasSharedResourceState();
  }

private:
  std::variant<waveamdmachine::InstructionExecutionState,
               waveamdmachine::MultiWaveCohortExecutionState>
      state;
};

struct IssueState {
  IssueState(const waveamdmachine::ArchData &arch,
             waveamdmachine::InstructionExecutionConfig config,
             const StaticIssueInfoMap &staticInfo,
             Block *frozenLoopArgs = nullptr)
      : model(arch, config), resources(!model.hasSharedResourceState()),
        staticInfo(&staticInfo), frozenLoopArgs(frozenLoopArgs) {}

  IssueState(const waveamdmachine::MultiWaveExecutionState &state,
             ArrayRef<unsigned> waves, const StaticIssueInfoMap &staticInfo,
             Block *frozenLoopArgs = nullptr)
      : model(state, waves), resources(!model.hasSharedResourceState()),
        staticInfo(&staticInfo), frozenLoopArgs(frozenLoopArgs) {}

  const StaticIssueInfo &getStaticInfo(Operation *op) const {
    return getStaticIssueInfo(*staticInfo, op);
  }

  IssueExecutionModel model;
  waveamdmachine::InstructionScheduleResourceState resources;
  const StaticIssueInfoMap *staticInfo = nullptr;
  Block *frozenLoopArgs = nullptr;
};

struct ComputeIslandInfo {
  explicit ComputeIslandInfo(RegionScheduleSession session)
      : session(std::move(session)) {}

  RegionScheduleSession session;
};

struct IssuePreview {
  waveamdmachine::SchedClass cls = waveamdmachine::SchedClass::NoInst;
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
  int64_t coexecWindowWaitCycles = 0;
  unsigned issues = 0;
  bool realInst = false;
  bool memoryIssuer = false;
  bool m0Hazard = false;
  bool storeDataHazard = false;
  bool priorityStall = false;
  bool computePriorityStall = false;
  waveamdmachine::InstructionScheduleResourcePreview resource;
};

static void bindValueOrigins(IssueExecutionModel &model,
                             const ValueOriginMap &origins,
                             Block *frozenLoopArgs = nullptr);
static void bindValueOriginsFromDef(IssueExecutionModel &model,
                                    const ValueOriginMap &origins,
                                    Operation *def,
                                    Block *frozenLoopArgs = nullptr);

struct GreedyStats {
  unsigned filledGaps = 0;
  unsigned unfilledGaps = 0;
  unsigned operandGaps = 0;
  unsigned resourceGaps = 0;
  unsigned cheapHazardGaps = 0;
  unsigned m0Gaps = 0;
  unsigned storeDataGaps = 0;
  unsigned coexecWindowGaps = 0;
  unsigned vmemPrefetchMoves = 0;
  unsigned longLatencyVmemPrefetchMoves = 0;
  unsigned recurrenceModelMoves = 0;
  unsigned memoryTokenGaps = 0;
  unsigned barrierMemoryGaps = 0;
  unsigned filledBarrierMemoryGaps = 0;
  unsigned steadyStateFills = 0;
  unsigned steadyStateIterations = 0;
  unsigned steadyStateRefinements = 0;
  unsigned latencyPriorityMoves = 0;
  unsigned resourcePriorityMoves = 0;
  unsigned resourceStallFills = 0;
  unsigned pressurePriorityMoves = 0;
  uint64_t pressureStateBuilds = 0;
  uint64_t pressureMemberVisits = 0;
  uint64_t pressureProjections = 0;
  uint64_t pressureProjectedNodes = 0;
  uint64_t pressureProjectionChecks = 0;
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

static waveamdmachine::EventSimConfig buildModelConfig() {
  waveamdmachine::EventSimConfig modelConfig;
  modelConfig.completePendingLdsDmaCounters = true;
  return modelConfig;
}

static LogicalResult
validateSchedClassSupport(Operation *op, const waveamdmachine::ArchData &arch) {
  waveamdmachine::SchedClass cls = waveamdmachine::classifyOp(op);
  if (waveamdmachine::isSchedClassSupported(arch, cls))
    return success();
  return op->emitOpError() << waveamdmachine::getSchedClassName(cls)
                           << " is unsupported on " << arch.name;
}

static LogicalResult
validateSchedClassSupport(const GreedyRegion &region,
                          const waveamdmachine::ArchData &arch) {
  for (Operation *op : region.ops)
    if (failed(validateSchedClassSupport(op, arch)))
      return failure();
  return success();
}

static StaticIssueInfo
buildStaticIssueInfo(Operation *op, const waveamdmachine::ArchData &arch) {
  StaticIssueInfo info;
  info.cls = waveamdmachine::classifyOp(op);
  info.realInst = info.cls != waveamdmachine::SchedClass::NoInst;
  if (!info.realInst)
    return info;

  info.resource =
      waveamdmachine::getInstructionScheduleResourceInfo(op, info.cls, arch);
  info.issues = info.resource.issueSlots;
  info.memoryIssuer = waveamdmachine::getMemoryCounterKind(op) !=
                      waveamdmachine::MemoryCounterKind::None;
  return info;
}

static FailureOr<StaticIssueInfoMap>
buildStaticIssueInfoMap(const GreedyRegion &region,
                        const waveamdmachine::ArchData &arch) {
  if (failed(validateSchedClassSupport(region, arch)))
    return failure();
  StaticIssueInfoMap result;
  result.reserve(region.ops.size());
  for (Operation *op : region.ops)
    result.try_emplace(op, buildStaticIssueInfo(op, arch));
  return result;
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
    case waveamdmachine::InstructionStallKind::CoexecWindow:
      preview.coexecWindowWaitCycles =
          std::max(preview.coexecWindowWaitCycles, component.cycles);
      break;
    case waveamdmachine::InstructionStallKind::None:
      break;
    default:
      llvm_unreachable("handled hazard stall");
    }
  }
}

static FailureOr<IssuePreview> previewIssue(
    const IssueState &state, Operation *op,
    std::optional<waveamdmachine::InstructionScheduleResourcePreview> resource =
        std::nullopt) {
  const StaticIssueInfo &info = state.getStaticInfo(op);
  IssuePreview preview;
  preview.cls = info.cls;
  preview.realInst = info.realInst;
  preview.issues = info.issues;
  preview.memoryIssuer = info.memoryIssuer;
  preview.resource =
      resource ? *resource : state.resources.preview(info.resource);

  IssueState trial = state;
  FailureOr<waveamdmachine::InstructionCommitResult> commit =
      trial.model.commit(op);
  if (failed(commit))
    return failure();

  recordPreviewStall(preview, commit->stall);
  preview.priorityStall = commit->priorityStall.cycles != 0;
  preview.computePriorityStall = commit->computePriorityStall.cycles != 0;
  preview.issueCycle = commit->issueCycle;
  preview.readyCycle = commit->valueReadyCycle;
  preview.nextIssueCycle = commit->nextIssueCycle;
  preview.memoryReadyCycle = commit->tokenReadyCycle;
  preview.memoryValueReadyCycle = commit->valueReadyCycle;
  return preview;
}

static bool stalls(const IssuePreview &preview) {
  return preview.operandWaitCycles != 0 || preview.memoryWaitCycles != 0 ||
         preview.fuWaitCycles != 0 || preview.coexecWindowWaitCycles != 0 ||
         preview.issueWaitCycles != 0 || preview.cuIssueWaitCycles != 0 ||
         preview.cmaIssueWaitCycles != 0 || preview.hazardWaitInsts != 0;
}

static bool stallsPriority(const IssuePreview &preview) {
  return preview.priorityStall || preview.issueWaitCycles != 0 ||
         preview.cuIssueWaitCycles != 0 || preview.cmaIssueWaitCycles != 0;
}

static bool stallsComputePriority(const IssuePreview &preview) {
  return preview.computePriorityStall || preview.issueWaitCycles != 0 ||
         preview.cuIssueWaitCycles != 0 || preview.cmaIssueWaitCycles != 0;
}

static LogicalResult commitIssue(IssueState &state, Operation *op,
                                 const IssuePreview &preview,
                                 const ValueOriginMap &origins) {
  (void)preview;
  if (failed(state.model.commit(op)))
    return failure();
  // Candidate copies inherit aliases from the committed state.
  bindValueOriginsFromDef(state.model, origins, op, state.frozenLoopArgs);
  state.resources.commit(state.getStaticInfo(op).resource);
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

struct DfsFrame {
  unsigned node = 0;
  unsigned next = 0;
};

using NodeAdjacency = SmallVector<SmallVector<unsigned, 4>, 16>;

static SmallVector<unsigned, 16>
graphPostOrder(ArrayRef<SmallVector<unsigned, 4>> successors) {
  BitVector visited(successors.size());
  SmallVector<unsigned, 16> postOrder;
  SmallVector<DfsFrame, 16> pending;
  for (unsigned root : llvm::seq<unsigned>(successors.size())) {
    if (visited.test(root))
      continue;
    visited.set(root);
    pending.push_back({root, 0});
    while (!pending.empty()) {
      DfsFrame &frame = pending.back();
      if (frame.next == successors[frame.node].size()) {
        postOrder.push_back(frame.node);
        pending.pop_back();
        continue;
      }
      unsigned child = successors[frame.node][frame.next++];
      if (visited.test(child))
        continue;
      visited.set(child);
      pending.push_back({child, 0});
    }
  }
  return postOrder;
}

static NodeAdjacency
buildGraphPredecessors(ArrayRef<SmallVector<unsigned, 4>> successors) {
  NodeAdjacency predecessors(successors.size());
  for (unsigned src : llvm::seq<unsigned>(successors.size()))
    for (unsigned dst : successors[src])
      predecessors[dst].push_back(src);
  return predecessors;
}

static SmallVector<unsigned, 16>
findStrongComponents(ArrayRef<SmallVector<unsigned, 4>> successors) {
  NodeAdjacency predecessors = buildGraphPredecessors(successors);
  SmallVector<unsigned, 16> postOrder = graphPostOrder(successors);
  unsigned unassigned = successors.size();
  SmallVector<unsigned, 16> component(successors.size(), unassigned);
  SmallVector<unsigned, 16> pending;
  unsigned nextComponent = 0;
  for (unsigned root : llvm::reverse(postOrder)) {
    if (component[root] != unassigned)
      continue;
    component[root] = nextComponent;
    pending.push_back(root);
    while (!pending.empty()) {
      unsigned index = pending.pop_back_val();
      for (unsigned predecessor : predecessors[index]) {
        if (component[predecessor] != unassigned)
          continue;
        component[predecessor] = nextComponent;
        pending.push_back(predecessor);
      }
    }
    ++nextComponent;
  }
  return component;
}

static std::optional<SmallVector<unsigned, 16>>
findCarryTopologicalPositions(const GraphTables &graph,
                              ArrayRef<ScheduleEdge> candidates) {
  unsigned nodeCount = graph.pendingPreds.size();
  unsigned defaultPriority = static_cast<unsigned>(candidates.size());
  SmallVector<unsigned, 16> priority(nodeCount, defaultPriority);
  for (auto [rank, edge] : llvm::enumerate(candidates))
    priority[edge.src] =
        std::min(priority[edge.src], static_cast<unsigned>(rank));

  using RankedNode = std::pair<unsigned, unsigned>;
  std::priority_queue<RankedNode, std::vector<RankedNode>,
                      std::greater<RankedNode>>
      ready;
  SmallVector<unsigned, 16> pendingPreds = graph.pendingPreds;
  for (unsigned index : llvm::seq<unsigned>(nodeCount))
    if (pendingPreds[index] == 0)
      ready.emplace(priority[index], index);

  SmallVector<unsigned, 16> position(nodeCount, nodeCount);
  unsigned nextPosition = 0;
  while (!ready.empty()) {
    unsigned index = ready.top().second;
    ready.pop();
    position[index] = nextPosition++;
    for (unsigned successor : graph.successors[index])
      if (--pendingPreds[successor] == 0)
        ready.emplace(priority[successor], successor);
  }
  if (nextPosition != nodeCount)
    return std::nullopt;
  return position;
}

static void addAcyclicLoopCarryEdges(GraphTables &graph,
                                     ArrayRef<ScheduleEdge> candidates) {
  if (candidates.empty())
    return;

  NodeAdjacency combined = graph.successors;
  for (const ScheduleEdge &edge : candidates)
    combined[edge.src].push_back(edge.dst);
  SmallVector<unsigned, 16> component = findStrongComponents(combined);

  SmallVector<ScheduleEdge, 16> cyclicCandidates;
  for (const ScheduleEdge &edge : candidates) {
    if (component[edge.src] != component[edge.dst]) {
      addEdge(graph, edge.src, edge.dst, edge.kind);
      continue;
    }
    cyclicCandidates.push_back(edge);
  }
  if (cyclicCandidates.empty())
    return;

  std::optional<SmallVector<unsigned, 16>> position =
      findCarryTopologicalPositions(graph, cyclicCandidates);
  if (!position)
    return;

  // Rejected cyclic carry hazards use regalloc's backedge copies.
  for (const ScheduleEdge &edge : cyclicCandidates)
    if ((*position)[edge.src] < (*position)[edge.dst])
      addEdge(graph, edge.src, edge.dst, edge.kind);
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
  bool splitDeadWriters = isa_and_nonnull<waveamdmachine::UniformLoopOp>(
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

static bool isMemoryAddressUse(Operation *user, Value address) {
  auto memory = dyn_cast<waveamdmachine::AddressFieldsOpInterface>(user);
  return memory &&
         waveamdmachine::getMemoryCounterKind(user) != MemoryKind::None &&
         memory.getVAddress() == address;
}

static bool findMemoryAddressUse(Value value,
                                 const DenseMap<Operation *, unsigned> &node,
                                 SmallVectorImpl<Value> &pendingAddressValues) {
  for (OpOperand &use : value.getUses()) {
    Operation *user = use.getOwner();
    if (!node.contains(user))
      continue;
    if (user->hasTrait<traits::TupleAliasOp>()) {
      llvm::append_range(pendingAddressValues, user->getResults());
      continue;
    }
    if (isMemoryAddressUse(user, value))
      return true;
  }
  return false;
}

static bool isComputeRecurrence(Value arg,
                                const DenseMap<Operation *, unsigned> &node) {
  auto regType = dyn_cast<waveamdmachine::RegType>(arg.getType());
  if (regType && regType.getRegClass() == waveamdmachine::RegClass::SGPR)
    return true;

  SmallVector<Value, 4> pendingAddressValues{arg};
  SmallPtrSet<Value, 16> visitedAddressValues;
  while (!pendingAddressValues.empty()) {
    Value value = pendingAddressValues.pop_back_val();
    if (!visitedAddressValues.insert(value).second)
      continue;
    if (findMemoryAddressUse(value, node, pendingAddressValues))
      return true;
  }
  return false;
}

static void appendUniqueNode(SmallVectorImpl<unsigned> &nodes, unsigned index) {
  if (!llvm::is_contained(nodes, index))
    nodes.push_back(index);
}

static void
recordLoopRecurrenceSources(Value arg, unsigned defIndex, GraphTables &graph,
                            const DenseMap<Operation *, unsigned> &node) {
  if (isMemToken(arg))
    appendUniqueNode(graph.memoryRecurrenceSources, defIndex);
  if (isComputeRecurrence(arg, node))
    appendUniqueNode(graph.computeRecurrenceSources, defIndex);
}

static void
collectPhysicalLoopCarryHazards(Value arg, Operation *def, unsigned defIndex,
                                const DenseMap<Operation *, unsigned> &node,
                                SmallVectorImpl<ScheduleEdge> &hazards) {
  // Backedge defs reuse carry registers; aliased readers must issue first.
  SmallVector<Value, 4> pending{arg};
  SmallPtrSet<Value, 16> visited;
  while (!pending.empty()) {
    Value value = pending.pop_back_val();
    if (!visited.insert(value).second)
      continue;
    for (OpOperand &use : value.getUses()) {
      Operation *user = use.getOwner();
      if (user == def)
        continue;
      auto useIt = node.find(user);
      if (useIt == node.end())
        continue;
      if (user->hasTrait<traits::TupleAliasOp>()) {
        llvm::append_range(pending, user->getResults());
        continue;
      }
      hazards.push_back({useIt->second, defIndex, EdgeKind::LoopCarry, false});
    }
  }
}

static void addLoopCarryEdgesForValue(Value arg, Value carry,
                                      GraphTables &graph,
                                      DenseMap<Operation *, unsigned> &node,
                                      SmallVectorImpl<ScheduleEdge> &hazards) {
  Operation *def = carry.getDefiningOp();
  if (!def)
    return;
  auto defIt = node.find(def);
  if (defIt == node.end())
    return;

  recordLoopRecurrenceSources(arg, defIt->second, graph, node);
  for (OpOperand &use : arg.getUses()) {
    auto useIt = node.find(use.getOwner());
    if (useIt == node.end())
      continue;
    addEdge(graph, defIt->second, useIt->second, EdgeKind::LoopCarry,
            /*recurrence=*/true);
  }

  if (!isa<waveamdmachine::RegType, waveamdmachine::M0Type>(arg.getType()))
    return;
  collectPhysicalLoopCarryHazards(arg, def, defIt->second, node, hazards);
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

  SmallVector<ScheduleEdge, 16> hazards;
  for (auto [arg, carry] :
       llvm::zip(region.block->getArguments(), terminator.getCarries()))
    addLoopCarryEdgesForValue(arg, carry, graph, node, hazards);
  addAcyclicLoopCarryEdges(graph, hazards);
}

static void indexGraphNodes(const GreedyRegion &region, GraphTables &graph) {
  graph.memoryKinds.reserve(region.ops.size());
  for (auto [index, op] : llvm::enumerate(region.ops)) {
    graph.node[op] = index;
    MemoryKind kind = waveamdmachine::getMemoryCounterKind(op);
    graph.memoryKinds.push_back(kind);
    if (kind != MemoryKind::None)
      graph.memoryNodes.push_back(index);
  }
}

static bool edgeLess(const ScheduleEdge &lhs, const ScheduleEdge &rhs) {
  if (lhs.src != rhs.src)
    return lhs.src < rhs.src;
  if (lhs.dst != rhs.dst)
    return lhs.dst < rhs.dst;
  if (lhs.kind != rhs.kind)
    return lhs.kind < rhs.kind;
  return lhs.recurrence < rhs.recurrence;
}

static void buildComputeRecurrenceCritical(GraphTables &graph) {
  graph.computeRecurrenceCritical.resize(graph.pendingPreds.size());
  SmallVector<SmallVector<unsigned, 4>, 16> ssaPredecessors(
      graph.pendingPreds.size());
  for (const ScheduleEdge &edge : graph.edges)
    if (!edge.recurrence && edge.kind == EdgeKind::Ssa)
      ssaPredecessors[edge.dst].push_back(edge.src);

  SmallVector<unsigned, 16> pending;
  llvm::append_range(pending, graph.computeRecurrenceSources);
  while (!pending.empty()) {
    unsigned index = pending.pop_back_val();
    if (graph.computeRecurrenceCritical.test(index))
      continue;
    graph.computeRecurrenceCritical.set(index);
    llvm::append_range(pending, ssaPredecessors[index]);
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
  llvm::sort(graph.edges, edgeLess);
  buildComputeRecurrenceCritical(graph);
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

static bool isRegionAboveLimit(const GreedyRegion &region, int limit) {
  return limit >= 0 && region.ops.size() > static_cast<unsigned>(limit);
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

static bool isFullBarrierOp(Operation *op) {
  return isa<waveamdmachine::ClusterBarrierOp, waveamdmachine::SBarrierOp>(op);
}

static bool isBarrierOp(Operation *op) {
  return isa<waveamdmachine::BarrierWaitOp>(op) || isFullBarrierOp(op);
}

static void recordCoexecGapStats(const IssuePreview &preview,
                                 GreedyStats &stats) {
  if (preview.coexecWindowWaitCycles != 0)
    ++stats.coexecWindowGaps;
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
  recordCoexecGapStats(preview, stats);
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

static bool filledSteadyStateStall(const GreedyStats &stats) {
  return stats.steadyStateFills != 0;
}

static bool scheduledModeledRecurrence(const GreedyStats &stats) {
  return stats.recurrenceModelMoves != 0;
}

static bool hasComputeResourceMoves(const GreedyStats &stats) {
  return stats.resourcePriorityMoves != 0 || stats.resourceStallFills != 0;
}

static StringRef getDirectStallMoveReason(const GreedyStats &stats) {
  if (filledOnlyM0HazardGaps(stats))
    return "m0_hazard";
  if (filledOnlyStoreDataHazardGaps(stats))
    return "store_data_hazard";
  if (stats.coexecWindowGaps != 0)
    return "coexec_window";
  return {};
}

static StringRef getGreedyMoveReason(const GreedyStats &stats) {
  if (StringRef reason = getDirectStallMoveReason(stats); !reason.empty())
    return reason;
  if (scheduledModeledRecurrence(stats))
    return "recurrence_model";
  if (filledSteadyStateStall(stats))
    return "loop_wait";
  if (filledBarrierMemoryGap(stats))
    return "barrier_memory";
  if (stats.vmemPrefetchMoves != 0)
    return "vmem_prefetch";
  if (stats.pressurePriorityMoves != 0)
    return "register_pressure";
  if (stats.latencyPriorityMoves != 0)
    return "latency_priority";
  if (hasComputeResourceMoves(stats))
    return "compute_resource";
  return "greedy";
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
  for (auto [index, binding] : llvm::enumerate(origins.bindings)) {
    for (Value leaf : binding.leaves) {
      Operation *def = leaf.getDefiningOp();
      if (!def)
        continue;
      SmallVector<unsigned, 4> &indices = origins.bindingsByDef[def];
      if (!llvm::is_contained(indices, index))
        indices.push_back(index);
    }
  }
}

static void bindValueOrigin(IssueExecutionModel &model,
                            const ValueOriginBinding &binding,
                            Block *frozenLoopArgs) {
  BlockArgument arg = dyn_cast<BlockArgument>(binding.target);
  if (arg && arg.getOwner() == frozenLoopArgs)
    return;
  model.bindValue(binding.target, binding.leaves);
}

static void bindValueOrigins(IssueExecutionModel &model,
                             const ValueOriginMap &origins,
                             Block *frozenLoopArgs) {
  for (const ValueOriginBinding &binding : origins.bindings)
    bindValueOrigin(model, binding, frozenLoopArgs);
}

static void bindValueOriginsFromDef(IssueExecutionModel &model,
                                    const ValueOriginMap &origins,
                                    Operation *def, Block *frozenLoopArgs) {
  auto it = origins.bindingsByDef.find(def);
  if (it == origins.bindingsByDef.end())
    return;
  for (unsigned index : it->second)
    bindValueOrigin(model, origins.bindings[index], frozenLoopArgs);
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
  if (def->hasTrait<traits::CompletionFreeTokenOp>())
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

static void buildFillerMemoryKinds(const GreedyRegion &region,
                                   const ValueOriginMap &origins,
                                   GraphTables &graph) {
  graph.fillerMemoryKinds.reserve(region.ops.size());
  for (Operation *op : region.ops)
    graph.fillerMemoryKinds.push_back(collectFillerMemoryKinds(op, origins));
}

static bool containsMemoryKind(ArrayRef<MemoryKind> kinds, MemoryKind kind) {
  return kind != MemoryKind::None && llvm::is_contained(kinds, kind);
}

static bool crossesSameMemoryProducer(const GraphTables &graph,
                                      const BitVector &scheduled, unsigned next,
                                      unsigned filler,
                                      ArrayRef<MemoryKind> fillerKinds) {
  auto memory = llvm::lower_bound(graph.memoryNodes, next);
  for (; memory != graph.memoryNodes.end() && *memory < filler; ++memory) {
    unsigned index = *memory;
    if (scheduled.test(index))
      continue;
    if (containsMemoryKind(fillerKinds, graph.memoryKinds[index]))
      return true;
  }
  return false;
}

static bool crossesSplitBarrier(const GreedyRegion &region,
                                const BitVector &scheduled, unsigned next,
                                unsigned filler) {
  if (filler <= next)
    return false;
  for (unsigned index : llvm::seq(next, filler)) {
    if (scheduled.test(index))
      continue;
    if (isa<waveamdmachine::BarrierArriveOp, waveamdmachine::BarrierWaitOp>(
            region.ops[index]))
      return true;
  }
  return false;
}

static bool canUseStallFiller(const GraphTables &graph,
                              const BitVector &scheduled, unsigned next,
                              unsigned filler) {
  assert(filler < graph.fillerMemoryKinds.size() &&
         "missing filler memory kinds");
  return !crossesSameMemoryProducer(graph, scheduled, next, filler,
                                    graph.fillerMemoryKinds[filler]);
}

static FailureOr<ReadyScheduleProjectionFacts>
projectReadyScheduleOrder(const IssueState &state, const GreedyRegion &region,
                          ArrayRef<unsigned> order,
                          const ValueOriginMap &origins) {
  IssueState trial = state;
  int64_t startCycle = trial.model.getCurrentCycle();
  ReadyScheduleProjectionFacts projection;
  for (unsigned index : order) {
    Operation *op = region.ops[index];
    FailureOr<waveamdmachine::InstructionCommitResult> commit =
        trial.model.commit(op);
    if (failed(commit))
      return failure();
    bindValueOriginsFromDef(trial.model, origins, op, trial.frozenLoopArgs);
    llvm::append_range(projection.stalls, commit->stall.components);
  }
  projection.cycles = trial.model.getCurrentCycle() - startCycle;
  return projection;
}

static ReadyScheduleIssueFacts
getReadyScheduleIssueFacts(const IssuePreview &preview) {
  return {preview.operandWaitCycles,
          preview.memoryWaitCycles,
          preview.fuWaitCycles,
          preview.issueWaitCycles,
          preview.cuIssueWaitCycles,
          preview.cmaIssueWaitCycles,
          preview.coexecWindowWaitCycles,
          preview.hazardWaitInsts,
          preview.issueCycle};
}

static FailureOr<ReadyScheduleCandidateIssueFacts>
getReadyScheduleCandidateIssueFacts(const GreedyRegion &region,
                                    const IssueState &state, unsigned index) {
  FailureOr<IssuePreview> preview = previewIssue(state, region.ops[index]);
  if (failed(preview))
    return failure();
  return ReadyScheduleCandidateIssueFacts{preview->nextIssueCycle,
                                          preview->issues, preview->realInst,
                                          stalls(*preview)};
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
                  const GraphTables &graph, IssueState &state,
                  IssueState *steadyState, BitVector &ready,
                  BitVector &scheduled, SmallVectorImpl<unsigned> &pending,
                  SmallVectorImpl<unsigned> &order, const IssuePreview &preview,
                  const ValueOriginMap &origins) {
  order.push_back(selected);
  if (failed(commitIssue(state, region.ops[selected], preview, origins)))
    return failure();
  if (steadyState) {
    FailureOr<IssuePreview> steadyPreview =
        previewIssue(*steadyState, region.ops[selected]);
    if (failed(steadyPreview) ||
        failed(commitIssue(*steadyState, region.ops[selected], *steadyPreview,
                           origins)))
      return failure();
  }
  markScheduled(selected, graph, ready, scheduled, pending);
  return success();
}

static LogicalResult
drainReadyNoInsts(const GreedyRegion &region, const GraphTables &graph,
                  IssueState &state, IssueState *steadyState, BitVector &ready,
                  BitVector &scheduled, SmallVectorImpl<unsigned> &pending,
                  SmallVectorImpl<unsigned> &order,
                  const ValueOriginMap &origins, const BitVector &noInsts) {
  while (true) {
    unsigned selected = findFirstReadyNoInst(ready, noInsts);
    if (selected == region.ops.size())
      return success();
    FailureOr<IssuePreview> preview = previewIssue(state, region.ops[selected]);
    if (failed(preview))
      return failure();
    if (failed(scheduleReadyNode(selected, region, graph, state, steadyState,
                                 ready, scheduled, pending, order, *preview,
                                 origins)))
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

static LogicalResult scheduleStallFiller(
    const GreedyRegion &region, const GraphTables &graph, IssueState &state,
    IssueState *steadyState, BitVector &ready, BitVector &scheduled,
    SmallVectorImpl<unsigned> &pending, SmallVectorImpl<unsigned> &order,
    unsigned filler, const ValueOriginMap &origins, const BitVector &noInsts) {
  FailureOr<IssuePreview> fillerPreview =
      previewIssue(state, region.ops[filler]);
  if (failed(fillerPreview))
    return failure();
  if (failed(scheduleReadyNode(filler, region, graph, state, steadyState, ready,
                               scheduled, pending, order, *fillerPreview,
                               origins)))
    return failure();
  return drainReadyNoInsts(region, graph, state, steadyState, ready, scheduled,
                           pending, order, origins, noInsts);
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

enum class FillStallStatus : uint8_t { Ready, ScheduledFiller };

static FailureOr<FillStallStatus> fillStallBeforeNext(
    const GreedyRegion &region, const GraphTables &graph, IssueState &state,
    IssueState *steadyState, BitVector &ready, BitVector &scheduled,
    SmallVectorImpl<unsigned> &pending, SmallVectorImpl<unsigned> &order,
    GreedyStats &stats, unsigned next, IssuePreview &nextPreview,
    const ValueOriginMap &origins, const BitVector &noInsts,
    const ComputeIslandInfo &computeIslands) {
  FailureOr<bool> readyNow = previewNextIssue(region, state, next, nextPreview);
  if (failed(readyNow))
    return failure();
  if (*readyNow || computeIslands.session.canIssueBaselineDespiteStall(
                       next, getReadyScheduleIssueFacts(nextPreview),
                       state.model.getScheduleModel()))
    return FillStallStatus::Ready;

  recordGapStats(region.ops[next], nextPreview, stats);
  FillableStall stall = computeIslands.session.classifyStall(
      next, getReadyScheduleIssueFacts(nextPreview),
      state.model.getScheduleModel());
  auto issueProvider = [&](unsigned candidate) {
    return getReadyScheduleCandidateIssueFacts(region, state, candidate);
  };
  FailureOr<ReadyScheduleDecision> decision =
      computeIslands.session.selectStallFiller(scheduled, next, ready, stall,
                                               state.model.getScheduleModel(),
                                               issueProvider);
  if (failed(decision))
    return failure();
  if (!decision->candidate) {
    ++stats.unfilledGaps;
    return FillStallStatus::Ready;
  }
  recordFilledStall(region.ops[next], nextPreview, stats);
  if (failed(scheduleStallFiller(region, graph, state, steadyState, ready,
                                 scheduled, pending, order,
                                 *decision->candidate, origins, noInsts)))
    return failure();
  return FillStallStatus::ScheduledFiller;
}

static GreedyResult failGreedyModel(GreedyResult &result) {
  result.failureReason = "model_failed";
  result.success = false;
  return result;
}

static FailureOr<GreedyStepStatus> scheduleReadyByIndex(
    unsigned selected, const GreedyRegion &region, const GraphTables &graph,
    IssueState &state, IssueState *steadyState, BitVector &ready,
    BitVector &scheduled, SmallVectorImpl<unsigned> &pending,
    SmallVectorImpl<unsigned> &order, const ValueOriginMap &origins) {
  FailureOr<IssuePreview> selectedPreview =
      previewIssue(state, region.ops[selected]);
  if (failed(selectedPreview))
    return failure();
  if (failed(scheduleReadyNode(selected, region, graph, state, steadyState,
                               ready, scheduled, pending, order,
                               *selectedPreview, origins)))
    return failure();
  return GreedyStepStatus::Continue;
}

static FailureOr<GreedyStepStatus> scheduleOriginalNext(
    const GreedyRegion &region, const GraphTables &graph, IssueState &state,
    IssueState *steadyState, BitVector &ready, BitVector &scheduled,
    SmallVectorImpl<unsigned> &pending, GreedyResult &result, unsigned next,
    const ValueOriginMap &origins, const BitVector &noInsts,
    std::optional<unsigned> &stallTarget,
    const ComputeIslandInfo &computeIslands) {
  stallTarget = next;
  IssuePreview preview;
  FailureOr<FillStallStatus> filled =
      fillStallBeforeNext(region, graph, state, steadyState, ready, scheduled,
                          pending, result.order, result.stats, next, preview,
                          origins, noInsts, computeIslands);
  if (failed(filled))
    return failure();
  if (*filled == FillStallStatus::ScheduledFiller) {
    if (!nextStillReady(ready, scheduled, next))
      stallTarget.reset();
    return GreedyStepStatus::Continue;
  }
  stallTarget.reset();
  if (scheduled.test(next))
    return GreedyStepStatus::Continue;
  if (failed(scheduleReadyNode(next, region, graph, state, steadyState, ready,
                               scheduled, pending, result.order, preview,
                               origins)))
    return failure();
  return GreedyStepStatus::Continue;
}

static ComputeIslandInfo
buildComputeIslandInfo(const GreedyRegion &region, const GraphTables &graph,
                       const waveamdmachine::EventSimConfig &config,
                       const WaveAMDMachineScheduleModel &scheduleModel) {
  return ComputeIslandInfo(scheduleModel.createRegionSession(
      region.ops, graph.predecessors, graph.successors, graph.memoryKinds,
      graph.fillerMemoryKinds, graph.memoryNodes,
      graph.computeRecurrenceCritical, config));
}

static BitVector buildNoInsts(const GreedyRegion &region,
                              const StaticIssueInfoMap &staticInfo) {
  BitVector noInsts(region.ops.size());
  for (unsigned index : llvm::seq<unsigned>(0, region.ops.size()))
    if (!getStaticIssueInfo(staticInfo, region.ops[index]).realInst)
      noInsts.set(index);
  return noInsts;
}

static FailureOr<unsigned>
findModelReadyOverride(const BitVector &ready, unsigned next,
                       const GreedyRegion &region, const GraphTables &graph,
                       const IssueState &state, const BitVector &scheduled,
                       const ComputeIslandInfo &computeIslands) {
  BitVector legalReadyCandidates(region.ops.size());
  for (int readyIndex = ready.find_first(); readyIndex >= 0;
       readyIndex = ready.find_next(readyIndex)) {
    unsigned index = readyIndex;
    if (index == next || !canUseStallFiller(graph, scheduled, next, index) ||
        crossesSplitBarrier(region, scheduled, next, index))
      continue;
    FailureOr<IssuePreview> preview = previewIssue(state, region.ops[index]);
    if (failed(preview))
      return failure();
    if (stalls(*preview))
      continue;
    legalReadyCandidates.set(index);
  }
  ReadyScheduleDecision decision =
      computeIslands.session.selectNext(scheduled, next, legalReadyCandidates,
                                        {}, state.model.getScheduleModel());
  return decision.candidate.value_or(region.ops.size());
}

static LogicalResult describeComputeResourceCandidate(
    unsigned index, const GreedyRegion &region, const IssueState &state,
    const IssuePreview &nextPreview, bool prioritizeComputeResources,
    SmallVectorImpl<ReadyScheduleProposal> &proposals) {
  waveamdmachine::InstructionScheduleResourcePreview resource =
      state.resources.preview(state.getStaticInfo(region.ops[index]).resource);
  FailureOr<IssuePreview> preview =
      previewIssue(state, region.ops[index], resource);
  if (failed(preview))
    return failure();
  // Keep this descriptor policy-free. The ready model classifies, admits, and
  // ranks the raw baseline and candidate facts.
  ReadyScheduleProposal proposal{
      index, ReadyScheduleProposalKind::ComputeResource, /*group=*/0};
  proposal.resource = {nextPreview.resource, preview->resource,
                       stallsComputePriority(nextPreview),
                       stallsPriority(*preview), prioritizeComputeResources};
  proposals.push_back(proposal);
  return success();
}

static FailureOr<unsigned> findReadyComputeResourceAlternative(
    const BitVector &ready, unsigned next, const GreedyRegion &region,
    const IssueState &state, const BitVector &scheduled,
    const ComputeIslandInfo &computeIslands, bool prioritizeComputeResources,
    GreedyStats &stats) {
  BitVector candidates = computeIslands.session.getComputeResourceCandidates(
      scheduled, next, ready);
  if (!candidates.any())
    return region.ops.size();

  FailureOr<IssuePreview> nextPreview = previewIssue(state, region.ops[next]);
  if (failed(nextPreview))
    return failure();

  SmallVector<ReadyScheduleProposal, 8> proposals;
  for (int candidate = candidates.find_first(); candidate >= 0;
       candidate = candidates.find_next(candidate))
    if (failed(describeComputeResourceCandidate(
            candidate, region, state, *nextPreview, prioritizeComputeResources,
            proposals)))
      return failure();

  ReadyScheduleDecision decision = computeIslands.session.selectComputeResource(
      scheduled, next, ready, proposals, state.model.getScheduleModel());
  if (decision.candidate) {
    if (decision.kind == ReadyScheduleSelectionKind::ResourceStallFiller)
      ++stats.resourceStallFills;
    else {
      assert(decision.kind == ReadyScheduleSelectionKind::ResourcePriority &&
             "compute resource selection has unexpected provenance");
      ++stats.resourcePriorityMoves;
    }
  }
  return decision.candidate.value_or(region.ops.size());
}

static FailureOr<std::optional<unsigned>> findReadyComputeAlternative(
    const BitVector &ready, unsigned next, const GreedyRegion &region,
    const IssueState &state, const BitVector &scheduled,
    const ComputeIslandInfo &computeIslands, GreedyStats &stats,
    bool prioritizeComputeResources) {
  FailureOr<unsigned> compute = findReadyComputeResourceAlternative(
      ready, next, region, state, scheduled, computeIslands,
      prioritizeComputeResources, stats);
  if (failed(compute))
    return failure();
  if (*compute == region.ops.size())
    return std::optional<unsigned>{};
  return std::optional<unsigned>(*compute);
}

static FailureOr<std::optional<unsigned>> findReadyLatencyAlternative(
    const BitVector &ready, unsigned next, const GreedyRegion &region,
    const IssueState &state, const BitVector &scheduled, bool enabled,
    GreedyStats &stats, const ComputeIslandInfo &computeIslands,
    std::optional<unsigned> &resumeTarget) {
  if (!computeIslands.session.supportsLatencyPriority(enabled))
    return std::optional<unsigned>{};
  FailureOr<IssuePreview> nextPreview = previewIssue(state, region.ops[next]);
  if (failed(nextPreview))
    return failure();

  BitVector candidates = computeIslands.session.getLatencyCandidates(
      scheduled, next, ready, stallsPriority(*nextPreview),
      state.model.getScheduleModel());
  if (!candidates.any())
    return std::optional<unsigned>{};

  SmallVector<ReadyScheduleProposal, 8> proposals;
  for (int candidate = candidates.find_first(); candidate >= 0;
       candidate = candidates.find_next(candidate)) {
    FailureOr<IssuePreview> preview =
        previewIssue(state, region.ops[candidate]);
    if (failed(preview))
      return failure();
    ReadyScheduleProposal proposal{static_cast<unsigned>(candidate),
                                   ReadyScheduleProposalKind::Latency,
                                   /*group=*/0};
    proposal.latency = {stallsPriority(*nextPreview), stallsPriority(*preview)};
    proposals.push_back(proposal);
  }
  BitVector noDiscoveries(region.ops.size());
  ReadyScheduleDecision decision = computeIslands.session.selectNext(
      scheduled, next, noDiscoveries, proposals,
      state.model.getScheduleModel());
  if (!decision.candidate)
    return std::optional<unsigned>{};
  assert(decision.kind == ReadyScheduleSelectionKind::LatencyPriority &&
         "latency selection has unexpected provenance");
  resumeTarget = next;
  ++stats.latencyPriorityMoves;
  return decision.candidate;
}

static bool isSteadyStateFillerCandidate(const BitVector &ready, unsigned next,
                                         unsigned index,
                                         const GreedyRegion &region,
                                         const BitVector &scheduled) {
  Operation *candidate = region.ops[index];
  if (!ready.test(index) || scheduled.test(index))
    return false;
  if (!isPure(candidate) ||
      waveamdmachine::getMemoryCounterKind(candidate) != MemoryKind::None)
    return false;
  // Split-barrier expansion depends on inter-wave state absent here.
  return !crossesSplitBarrier(region, scheduled, next, index);
}

static void markDependencyClosure(unsigned source, const GraphTables &graph,
                                  const BitVector &scheduled,
                                  BitVector &critical) {
  SmallVector<unsigned, 16> pending = {source};
  while (!pending.empty()) {
    unsigned index = pending.pop_back_val();
    if (scheduled.test(index) || critical.test(index))
      continue;
    critical.set(index);
    llvm::append_range(pending, graph.predecessors[index]);
  }
}

static BitVector buildSteadyStateCritical(const GraphTables &graph) {
  BitVector critical(graph.pendingPreds.size());
  BitVector noneScheduled(graph.pendingPreds.size());
  for (unsigned source : graph.memoryRecurrenceSources) {
    BitVector closure(graph.pendingPreds.size());
    markDependencyClosure(source, graph, noneScheduled, closure);
    critical |= closure;
  }
  return critical;
}

static bool isReadySteadyStateProducer(
    unsigned index, unsigned next, const GreedyRegion &region,
    const BitVector &scheduled, const BitVector &critical,
    MemoryResourceMask blockedMemoryResources) {
  if (index == next || !critical.test(index) || scheduled.test(index) ||
      isBarrierOp(region.ops[index]))
    return false;
  if ((blockedMemoryResources &
       waveamdmachine::getMemoryIssueResources(region.ops[index])) != 0)
    return false;
  return index <= next || !crossesSplitBarrier(region, scheduled, next, index);
}

static FailureOr<unsigned> findReadySteadyStateProducer(
    const BitVector &ready, unsigned next, const GreedyRegion &region,
    const IssueState &localState, const IssueState &steadyState,
    const BitVector &scheduled, const BitVector &critical,
    MemoryResourceMask blockedMemoryResources) {
  for (int readyIndex = ready.find_first(); readyIndex >= 0;
       readyIndex = ready.find_next(readyIndex)) {
    unsigned index = readyIndex;
    if (!isReadySteadyStateProducer(index, next, region, scheduled, critical,
                                    blockedMemoryResources))
      continue;
    FailureOr<IssuePreview> localPreview =
        previewIssue(localState, region.ops[index]);
    FailureOr<IssuePreview> steadyPreview =
        previewIssue(steadyState, region.ops[index]);
    if (failed(localPreview) || failed(steadyPreview))
      return failure();
    if (localPreview->realInst && !stalls(*localPreview) &&
        steadyPreview->realInst && !stalls(*steadyPreview))
      return index;
  }
  return region.ops.size();
}

static bool isSingleSlotStallFree(const IssuePreview &preview) {
  return preview.realInst && !stalls(preview) &&
         preview.resource.releaseSlots == 1;
}

static FailureOr<unsigned>
findSteadyStateFiller(const BitVector &ready, unsigned next,
                      const GreedyRegion &region, const IssueState &localState,
                      const IssueState &steadyState, const BitVector &scheduled,
                      const ComputeIslandInfo &computeIslands) {
  SmallVector<ReadyScheduleProposal, 8> proposals;
  for (unsigned index : llvm::seq(next + 1, ready.size())) {
    Operation *candidate = region.ops[index];
    if (!isSteadyStateFillerCandidate(ready, next, index, region, scheduled))
      continue;
    FailureOr<IssuePreview> localPreview = previewIssue(localState, candidate);
    FailureOr<IssuePreview> steadyPreview =
        previewIssue(steadyState, candidate);
    if (failed(localPreview) || failed(steadyPreview))
      return failure();
    if (!isSingleSlotStallFree(*localPreview) ||
        !isSingleSlotStallFree(*steadyPreview))
      continue;
    proposals.push_back(
        {index, ReadyScheduleProposalKind::RankedFiller, /*group=*/0});
  }
  BitVector noDiscoveries(region.ops.size());
  ReadyScheduleDecision decision = computeIslands.session.selectNext(
      scheduled, next, noDiscoveries, proposals,
      localState.model.getScheduleModel());
  return decision.candidate.value_or(region.ops.size());
}

static void
updateSteadyStallTarget(unsigned next, const IssuePreview &nextPreview,
                        std::optional<SteadyStallTarget> &steadyStallTarget,
                        const ComputeIslandInfo &computeIslands) {
  if (steadyStallTarget && steadyStallTarget->index != next)
    steadyStallTarget.reset();
  if (steadyStallTarget || !stalls(nextPreview))
    return;
  if (computeIslands.session
          .classifyStall(next, getReadyScheduleIssueFacts(nextPreview),
                         /*blockMemoryResource=*/false)
          .kind != FillableStallKind::None)
    steadyStallTarget = SteadyStallTarget{next, /*fills=*/0};
}

static FailureOr<std::optional<unsigned>> findSteadyStateProducerAlternative(
    const BitVector &ready, unsigned next, const GreedyRegion &region,
    const IssueState &localState, const IssueState &steadyState,
    const IssuePreview &nextPreview, const BitVector &scheduled,
    const BitVector &critical, const ComputeIslandInfo &computeIslands,
    GreedyStats &stats) {
  if (!localState.model.getScheduleModel()
           .shouldPrioritizeSteadyStateProducer() ||
      !stalls(nextPreview))
    return std::optional<unsigned>{};
  FillableStall nextStall = computeIslands.session.classifyStall(
      next, getReadyScheduleIssueFacts(nextPreview),
      /*blockMemoryResource=*/true);
  FailureOr<unsigned> producer = findReadySteadyStateProducer(
      ready, next, region, localState, steadyState, scheduled, critical,
      nextStall.blockedMemoryResources);
  if (failed(producer))
    return failure();
  if (*producer == region.ops.size())
    return std::optional<unsigned>{};
  BitVector noDiscoveries(region.ops.size());
  ReadyScheduleProposal proposal{*producer, ReadyScheduleProposalKind::Direct,
                                 /*group=*/0};
  ReadyScheduleDecision decision = computeIslands.session.selectNext(
      scheduled, next, noDiscoveries, proposal,
      localState.model.getScheduleModel());
  if (!decision.candidate)
    return std::optional<unsigned>{};
  ++stats.steadyStateFills;
  return decision.candidate;
}

static FailureOr<std::optional<unsigned>> findSteadyStateFillerAlternative(
    const BitVector &ready, unsigned next, const GreedyRegion &region,
    const IssueState &localState, const IssueState &steadyState,
    const IssuePreview &nextPreview,
    std::optional<SteadyStallTarget> &steadyStallTarget,
    const BitVector &scheduled, const ComputeIslandInfo &computeIslands,
    GreedyStats &stats) {
  updateSteadyStallTarget(next, nextPreview, steadyStallTarget, computeIslands);
  if (!steadyStallTarget ||
      steadyStallTarget->fills >= kSteadyStateFillsPerTarget)
    return std::optional<unsigned>{};

  FailureOr<unsigned> filler = findSteadyStateFiller(
      ready, next, region, localState, steadyState, scheduled, computeIslands);
  if (failed(filler))
    return failure();
  if (*filler == region.ops.size()) {
    steadyStallTarget.reset();
    return std::optional<unsigned>{};
  }

  if (stalls(nextPreview))
    recordFilledStall(region.ops[next], nextPreview, stats);
  ++steadyStallTarget->fills;
  ++stats.steadyStateFills;
  return std::optional<unsigned>(*filler);
}

static waveamdmachine::UniformLoopOp
getCompleteUniformLoop(const GreedyRegion &region);

static LogicalResult bindLoopBackedge(IssueState &state,
                                      waveamdmachine::UniformLoopOp loop);

static FailureOr<RecurrenceScheduleProjectionFacts>
projectLoopSchedule(const IssueState &state, ArrayRef<unsigned> scheduledOrder,
                    ArrayRef<unsigned> remainingOrder,
                    const GreedyRegion &region,
                    const waveamdmachine::ArchData &arch,
                    const waveamdmachine::EventSimConfig &config,
                    const ValueOriginMap &origins) {
  waveamdmachine::UniformLoopOp loop = getCompleteUniformLoop(region);
  if (!loop)
    return failure();

  IssueState trial = state;
  int64_t startCycle = trial.model.getCurrentCycle();
  int64_t startSlot = trial.resources.getCurrentSlot();
  auto commitNode = [&](unsigned node) -> LogicalResult {
    FailureOr<IssuePreview> preview = previewIssue(trial, region.ops[node]);
    if (failed(preview))
      return failure();
    return commitIssue(trial, region.ops[node], *preview, origins);
  };

  for (unsigned node : remainingOrder)
    if (failed(commitNode(node)))
      return failure();
  trial.frozenLoopArgs = region.block;
  if (failed(bindLoopBackedge(trial, loop)))
    return failure();
  for (unsigned node : scheduledOrder)
    if (failed(commitNode(node)))
      return failure();
  for (unsigned node : remainingOrder)
    if (failed(commitNode(node)))
      return failure();

  int64_t modelCycles = trial.model.getCurrentCycle() - startCycle;
  int64_t issuePeriod = waveamdmachine::getEventSimIssuePeriod(arch, config);
  int64_t resourceCycles =
      (trial.resources.getCurrentSlot() - startSlot) * issuePeriod;
  return RecurrenceScheduleProjectionFacts{modelCycles, resourceCycles};
}

static FailureOr<std::optional<unsigned>> findSteadyStateAlternative(
    const BitVector &ready, unsigned next, const GreedyRegion &region,
    const IssueState &state, const IssueState *steadyState,
    std::optional<SteadyStallTarget> &steadyStallTarget,
    const BitVector &scheduled, const ComputeIslandInfo &computeIslands,
    BitVector &critical, GreedyStats &stats) {
  if (!steadyState)
    return std::optional<unsigned>{};

  FailureOr<IssuePreview> nextPreview =
      previewIssue(*steadyState, region.ops[next]);
  if (failed(nextPreview))
    return failure();
  FailureOr<std::optional<unsigned>> producer =
      findSteadyStateProducerAlternative(ready, next, region, state,
                                         *steadyState, *nextPreview, scheduled,
                                         critical, computeIslands, stats);
  if (failed(producer))
    return failure();
  if (*producer)
    return *producer;
  return findSteadyStateFillerAlternative(
      ready, next, region, state, *steadyState, *nextPreview, steadyStallTarget,
      scheduled, computeIslands, stats);
}

static FailureOr<std::optional<unsigned>> findReadyMemoryAlternative(
    const BitVector &ready, unsigned next, const GreedyRegion &region,
    const IssueState &state, const BitVector &scheduled,
    const ValueOriginMap &origins, const ComputeIslandInfo &computeIslands,
    GreedyStats &stats, bool prioritizeLongLatencyVmem) {
  auto issueProvider = [&](unsigned candidate) {
    return getReadyScheduleCandidateIssueFacts(region, state, candidate);
  };
  auto projectionProvider = [&](ArrayRef<unsigned> order) {
    return projectReadyScheduleOrder(state, region, order, origins);
  };
  FailureOr<ReadyScheduleDecision> decision =
      computeIslands.session.selectMemoryReady(
          scheduled, next, ready, prioritizeLongLatencyVmem,
          state.model.getScheduleModel(), issueProvider, projectionProvider);
  if (failed(decision))
    return failure();
  if (!decision->candidate)
    return std::optional<unsigned>{};

  if (decision->kind == ReadyScheduleSelectionKind::VmemPrefetch ||
      decision->kind == ReadyScheduleSelectionKind::LongLatencyVmemPrefetch)
    ++stats.vmemPrefetchMoves;
  if (decision->kind == ReadyScheduleSelectionKind::LongLatencyVmemPrefetch)
    ++stats.longLatencyVmemPrefetchMoves;
  assert(
      (decision->kind == ReadyScheduleSelectionKind::MemoryTokenConsumer ||
       decision->kind == ReadyScheduleSelectionKind::BarrierPairFiller ||
       decision->kind == ReadyScheduleSelectionKind::VmemPrefetch ||
       decision->kind == ReadyScheduleSelectionKind::LongLatencyVmemPrefetch) &&
      "memory selection has unexpected provenance");
  return decision->candidate;
}

static FailureOr<std::optional<unsigned>> findReadyAlternative(
    const BitVector &ready, unsigned next, const GreedyRegion &region,
    const GraphTables &graph, const IssueState &state,
    const IssueState *steadyState,
    std::optional<SteadyStallTarget> &steadyStallTarget,
    const BitVector &scheduled, BitVector &steadyCritical,
    const waveamdmachine::ArchData &arch,
    const waveamdmachine::EventSimConfig &config, const ValueOriginMap &origins,
    const ComputeIslandInfo &computeIslands, GreedyStats &stats,
    bool prioritizeLongLatencyVmem, bool prioritizeComputeResources,
    bool prioritizeLatency, std::optional<unsigned> &resumeTarget) {
  FailureOr<unsigned> modelOverride = findModelReadyOverride(
      ready, next, region, graph, state, scheduled, computeIslands);
  if (failed(modelOverride))
    return failure();
  if (*modelOverride != region.ops.size())
    return std::optional<unsigned>(*modelOverride);

  FailureOr<std::optional<unsigned>> steady = findSteadyStateAlternative(
      ready, next, region, state, steadyState, steadyStallTarget, scheduled,
      computeIslands, steadyCritical, stats);
  if (failed(steady))
    return failure();
  if (*steady)
    return *steady;

  FailureOr<std::optional<unsigned>> memory = findReadyMemoryAlternative(
      ready, next, region, state, scheduled, origins, computeIslands, stats,
      prioritizeLongLatencyVmem);
  if (failed(memory))
    return failure();
  if (*memory)
    return *memory;

  FailureOr<std::optional<unsigned>> compute = findReadyComputeAlternative(
      ready, next, region, state, scheduled, computeIslands, stats,
      prioritizeComputeResources);
  if (failed(compute) || *compute)
    return compute;
  return findReadyLatencyAlternative(ready, next, region, state, scheduled,
                                     prioritizeLatency, stats, computeIslands,
                                     resumeTarget);
}

struct GreedyCompletion {
  SmallVector<unsigned, 16> order;
  GreedyStats stats;
};

static FailureOr<GreedyCompletion> buildGreedyBaselineCompletion(
    const GreedyRegion &region, const GraphTables &graph,
    const waveamdmachine::ArchData &arch,
    const waveamdmachine::EventSimConfig &config, const IssueState &state,
    const IssueState *steadyState,
    const std::optional<SteadyStallTarget> &steadyStallTarget,
    const BitVector &ready, const BitVector &scheduled,
    ArrayRef<unsigned> pending, const GreedyResult &result,
    const ValueOriginMap &origins, const ComputeIslandInfo &computeIslands,
    const BitVector &noInsts, BitVector &steadyCritical,
    bool prioritizeLongLatencyVmem, bool prioritizeComputeResources,
    bool prioritizeLatency);

static FailureOr<std::optional<unsigned>> findModelRecurrenceAction(
    unsigned next, const GreedyRegion &region, const GraphTables &graph,
    const waveamdmachine::ArchData &arch,
    const waveamdmachine::EventSimConfig &config, const IssueState &state,
    const IssueState *steadyState,
    const std::optional<SteadyStallTarget> &steadyStallTarget,
    const BitVector &ready, const BitVector &scheduled,
    ArrayRef<unsigned> pending, GreedyResult &result,
    const ValueOriginMap &origins, const ComputeIslandInfo &computeIslands,
    const BitVector &noInsts, BitVector &steadyCritical,
    bool prioritizeLongLatencyVmem, bool prioritizeComputeResources,
    bool prioritizeLatency) {
  std::optional<GreedyCompletion> baseline;
  // The session alone decides whether this factual completion is needed and
  // whether its statistics become the accepted recurrence bookkeeping.
  auto baselineProvider = [&]() -> FailureOr<RecurrenceScheduleBaselineFacts> {
    FailureOr<GreedyCompletion> completion = buildGreedyBaselineCompletion(
        region, graph, arch, config, state, steadyState, steadyStallTarget,
        ready, scheduled, pending, result, origins, computeIslands, noInsts,
        steadyCritical, prioritizeLongLatencyVmem, prioritizeComputeResources,
        prioritizeLatency);
    if (failed(completion))
      return failure();
    baseline = std::move(*completion);
    RecurrenceScheduleBaselineFacts facts;
    facts.order = baseline->order;
    return facts;
  };
  const IssueState &projectionState = steadyState ? *steadyState : state;
  // Replay exactly the session-supplied orders. Keep model and resource cycles
  // separate so the scheduler cannot combine, compare, or veto them.
  auto projectionProvider = [&](ArrayRef<unsigned> scheduledPrefix,
                                ArrayRef<unsigned> remainingOrder) {
    return projectLoopSchedule(projectionState, scheduledPrefix, remainingOrder,
                               region, arch, config, origins);
  };
  FailureOr<RecurrenceScheduleDecision> decision =
      computeIslands.session.selectRecurrence(next, ready, scheduled,
                                              result.order, baselineProvider,
                                              projectionProvider);
  if (failed(decision))
    return failure();
  if (decision->activated) {
    assert(baseline && "activated recurrence has no baseline completion");
    result.stats = baseline->stats;
    result.stats.recurrenceModelMoves += decision->movedCount;
  }
  return decision->candidate;
}

static FailureOr<std::optional<unsigned>> findGreedyAction(
    const GreedyRegion &region, const GraphTables &graph,
    const waveamdmachine::ArchData &arch,
    const waveamdmachine::EventSimConfig &config, const IssueState &state,
    const IssueState *steadyState,
    std::optional<SteadyStallTarget> &steadyStallTarget, const BitVector &ready,
    unsigned next, const BitVector &scheduled, GreedyResult &result,
    const ValueOriginMap &origins, const ComputeIslandInfo &computeIslands,
    BitVector &steadyCritical, bool prioritizeLongLatencyVmem,
    bool prioritizeComputeResources, bool prioritizeLatency,
    std::optional<unsigned> &resumeTarget) {
  if (!ready.test(next))
    return std::optional<unsigned>{};
  FailureOr<std::optional<unsigned>> alternative = findReadyAlternative(
      ready, next, region, graph, state, steadyState, steadyStallTarget,
      scheduled, steadyCritical, arch, config, origins, computeIslands,
      result.stats, prioritizeLongLatencyVmem, prioritizeComputeResources,
      prioritizeLatency, resumeTarget);
  if (failed(alternative))
    return failure();
  return alternative;
}

static FailureOr<std::optional<GreedyStepStatus>> resumeGreedyStallTarget(
    const GreedyRegion &region, const GraphTables &graph,
    const waveamdmachine::ArchData &arch,
    const waveamdmachine::EventSimConfig &config, IssueState &state,
    IssueState *steadyState, BitVector &ready, BitVector &scheduled,
    SmallVectorImpl<unsigned> &pending, GreedyResult &result,
    const ValueOriginMap &origins, const ComputeIslandInfo &computeIslands,
    const BitVector &noInsts, std::optional<unsigned> &stallTarget) {
  if (!stallTarget)
    return std::optional<GreedyStepStatus>{};
  if (!nextStillReady(ready, scheduled, *stallTarget)) {
    stallTarget.reset();
    return std::optional<GreedyStepStatus>{};
  }
  FailureOr<unsigned> modelOverride = findModelReadyOverride(
      ready, *stallTarget, region, graph, state, scheduled, computeIslands);
  if (failed(modelOverride))
    return failure();

  if (*modelOverride != region.ops.size()) {
    FailureOr<GreedyStepStatus> scheduledResult =
        scheduleReadyByIndex(*modelOverride, region, graph, state, steadyState,
                             ready, scheduled, pending, result.order, origins);
    if (failed(scheduledResult))
      return failure();
    return std::optional<GreedyStepStatus>(*scheduledResult);
  }
  FailureOr<GreedyStepStatus> scheduledResult = scheduleOriginalNext(
      region, graph, state, steadyState, ready, scheduled, pending, result,
      *stallTarget, origins, noInsts, stallTarget, computeIslands);
  if (failed(scheduledResult))
    return failure();
  return std::optional<GreedyStepStatus>(*scheduledResult);
}

struct GreedyStepPreparation {
  std::optional<GreedyStepStatus> completed;
  unsigned next = 0;
};

static FailureOr<GreedyStepPreparation> prepareGreedyStep(
    const GreedyRegion &region, const GraphTables &graph,
    const waveamdmachine::ArchData &arch,
    const waveamdmachine::EventSimConfig &config, IssueState &state,
    IssueState *steadyState,
    std::optional<SteadyStallTarget> &steadyStallTarget, BitVector &ready,
    BitVector &scheduled, SmallVectorImpl<unsigned> &pending,
    GreedyResult &result, const ValueOriginMap &origins,
    const ComputeIslandInfo &computeIslands, const BitVector &noInsts,
    std::optional<unsigned> &stallTarget) {
  if (failed(drainReadyNoInsts(region, graph, state, steadyState, ready,
                               scheduled, pending, result.order, origins,
                               noInsts)))
    return failure();
  if (result.order.size() == region.ops.size())
    return GreedyStepPreparation{GreedyStepStatus::Done};
  FailureOr<std::optional<GreedyStepStatus>> resumed = resumeGreedyStallTarget(
      region, graph, arch, config, state, steadyState, ready, scheduled,
      pending, result, origins, computeIslands, noInsts, stallTarget);
  if (failed(resumed))
    return failure();
  if (*resumed)
    return GreedyStepPreparation{**resumed};
  if (!ready.any()) {
    recordDependencyCycle(graph, scheduled, pending, result);
    return GreedyStepPreparation{GreedyStepStatus::Blocked};
  }

  unsigned next = findFirstUnscheduled(scheduled);
  // Blocked original nodes must not bypass model-aware ready selection.
  if (!ready.test(next))
    next = findFirstReadyByOriginal(ready);
  return GreedyStepPreparation{std::nullopt, next};
}

static FailureOr<GreedyStepStatus> scheduleGreedyReadyAction(
    unsigned next, const GreedyRegion &region, const GraphTables &graph,
    const waveamdmachine::ArchData &arch,
    const waveamdmachine::EventSimConfig &config, IssueState &state,
    IssueState *steadyState,
    std::optional<SteadyStallTarget> &steadyStallTarget, BitVector &ready,
    BitVector &scheduled, SmallVectorImpl<unsigned> &pending,
    GreedyResult &result, const ValueOriginMap &origins,
    const ComputeIslandInfo &computeIslands, const BitVector &noInsts,
    BitVector &steadyCritical, bool prioritizeLongLatencyVmem,
    bool prioritizeComputeResources, bool prioritizeLatency,
    std::optional<unsigned> &stallTarget) {
  FailureOr<std::optional<unsigned>> action = findGreedyAction(
      region, graph, arch, config, state, steadyState, steadyStallTarget, ready,
      next, scheduled, result, origins, computeIslands, steadyCritical,
      prioritizeLongLatencyVmem, prioritizeComputeResources, prioritizeLatency,
      stallTarget);
  if (failed(action))
    return failure();
  if (*action)
    return scheduleReadyByIndex(**action, region, graph, state, steadyState,
                                ready, scheduled, pending, result.order,
                                origins);
  return scheduleOriginalNext(region, graph, state, steadyState, ready,
                              scheduled, pending, result, next, origins,
                              noInsts, stallTarget, computeIslands);
}

static FailureOr<GreedyStepStatus> buildGreedyStepWithoutRecurrence(
    const GreedyRegion &region, const GraphTables &graph,
    const waveamdmachine::ArchData &arch,
    const waveamdmachine::EventSimConfig &config, IssueState &state,
    IssueState *steadyState,
    std::optional<SteadyStallTarget> &steadyStallTarget, BitVector &ready,
    BitVector &scheduled, SmallVectorImpl<unsigned> &pending,
    GreedyResult &result, const ValueOriginMap &origins,
    const ComputeIslandInfo &computeIslands, const BitVector &noInsts,
    BitVector &steadyCritical, bool prioritizeLongLatencyVmem,
    bool prioritizeComputeResources, bool prioritizeLatency,
    std::optional<unsigned> &stallTarget) {
  FailureOr<GreedyStepPreparation> preparation =
      prepareGreedyStep(region, graph, arch, config, state, steadyState,
                        steadyStallTarget, ready, scheduled, pending, result,
                        origins, computeIslands, noInsts, stallTarget);
  if (failed(preparation))
    return failure();
  if (preparation->completed)
    return *preparation->completed;
  return scheduleGreedyReadyAction(
      preparation->next, region, graph, arch, config, state, steadyState,
      steadyStallTarget, ready, scheduled, pending, result, origins,
      computeIslands, noInsts, steadyCritical, prioritizeLongLatencyVmem,
      prioritizeComputeResources, prioritizeLatency, stallTarget);
}

static FailureOr<GreedyStepStatus>
buildGreedyStep(const GreedyRegion &region, const GraphTables &graph,
                const waveamdmachine::ArchData &arch,
                const waveamdmachine::EventSimConfig &config, IssueState &state,
                IssueState *steadyState,
                std::optional<SteadyStallTarget> &steadyStallTarget,
                BitVector &ready, BitVector &scheduled,
                SmallVectorImpl<unsigned> &pending, GreedyResult &result,
                const ValueOriginMap &origins,
                const ComputeIslandInfo &computeIslands,
                const BitVector &noInsts, BitVector &steadyCritical,
                bool prioritizeLongLatencyVmem, bool prioritizeComputeResources,
                bool prioritizeLatency, std::optional<unsigned> &stallTarget) {
  FailureOr<GreedyStepPreparation> preparation =
      prepareGreedyStep(region, graph, arch, config, state, steadyState,
                        steadyStallTarget, ready, scheduled, pending, result,
                        origins, computeIslands, noInsts, stallTarget);
  if (failed(preparation))
    return failure();
  if (preparation->completed)
    return *preparation->completed;

  FailureOr<std::optional<unsigned>> recurrence = findModelRecurrenceAction(
      preparation->next, region, graph, arch, config, state, steadyState,
      steadyStallTarget, ready, scheduled, pending, result, origins,
      computeIslands, noInsts, steadyCritical, prioritizeLongLatencyVmem,
      prioritizeComputeResources, prioritizeLatency);
  if (failed(recurrence))
    return failure();
  if (*recurrence)
    return scheduleReadyByIndex(**recurrence, region, graph, state, steadyState,
                                ready, scheduled, pending, result.order,
                                origins);

  return scheduleGreedyReadyAction(
      preparation->next, region, graph, arch, config, state, steadyState,
      steadyStallTarget, ready, scheduled, pending, result, origins,
      computeIslands, noInsts, steadyCritical, prioritizeLongLatencyVmem,
      prioritizeComputeResources, prioritizeLatency, stallTarget);
}

static FailureOr<GreedyCompletion> buildGreedyBaselineCompletion(
    const GreedyRegion &region, const GraphTables &graph,
    const waveamdmachine::ArchData &arch,
    const waveamdmachine::EventSimConfig &config, const IssueState &state,
    const IssueState *steadyState,
    const std::optional<SteadyStallTarget> &steadyStallTarget,
    const BitVector &ready, const BitVector &scheduled,
    ArrayRef<unsigned> pending, const GreedyResult &result,
    const ValueOriginMap &origins, const ComputeIslandInfo &computeIslands,
    const BitVector &noInsts, BitVector &steadyCritical,
    bool prioritizeLongLatencyVmem, bool prioritizeComputeResources,
    bool prioritizeLatency) {
  IssueState baselineState = state;
  std::unique_ptr<IssueState> baselineSteadyState =
      steadyState ? std::make_unique<IssueState>(*steadyState) : nullptr;
  std::optional<SteadyStallTarget> baselineStallTarget = steadyStallTarget;
  BitVector baselineReady = ready;
  BitVector baselineScheduled = scheduled;
  SmallVector<unsigned, 16> baselinePending;
  llvm::append_range(baselinePending, pending);
  GreedyResult baselineResult = result;
  std::optional<unsigned> stallTarget;

  while (baselineResult.order.size() != region.ops.size()) {
    FailureOr<GreedyStepStatus> step = buildGreedyStepWithoutRecurrence(
        region, graph, arch, config, baselineState, baselineSteadyState.get(),
        baselineStallTarget, baselineReady, baselineScheduled, baselinePending,
        baselineResult, origins, computeIslands, noInsts, steadyCritical,
        prioritizeLongLatencyVmem, prioritizeComputeResources,
        prioritizeLatency, stallTarget);
    if (failed(step) || *step == GreedyStepStatus::Blocked)
      return failure();
    if (*step == GreedyStepStatus::Done)
      break;
  }

  GreedyCompletion completion;
  llvm::append_range(
      completion.order,
      ArrayRef<unsigned>(baselineResult.order).drop_front(result.order.size()));
  completion.stats = baselineResult.stats;
  return completion;
}

static BitVector getInitialReadySet(ArrayRef<unsigned> pending) {
  BitVector ready(pending.size());
  for (auto [index, count] : llvm::enumerate(pending))
    if (count == 0)
      ready.set(index);
  return ready;
}

struct GreedyOrderState {
  GreedyOrderState(const GreedyRegion &region, const GraphTables &graph,
                   const StaticIssueInfoMap &staticInfo,
                   ComputeIslandInfo computeIslands, IssueState state,
                   std::unique_ptr<IssueState> steadyState)
      : pending(graph.pendingPreds), ready(getInitialReadySet(pending)),
        scheduled(region.ops.size()), computeIslands(std::move(computeIslands)),
        noInsts(buildNoInsts(region, staticInfo)), state(std::move(state)),
        steadyState(std::move(steadyState)),
        steadyCritical(this->steadyState ? buildSteadyStateCritical(graph)
                                         : BitVector(region.ops.size())) {}

  FailureOr<GreedyStepStatus>
  step(const GreedyRegion &region, const GraphTables &graph,
       const waveamdmachine::ArchData &arch,
       const waveamdmachine::EventSimConfig &config,
       const ValueOriginMap &origins, bool prioritizeLongLatencyVmem,
       bool prioritizeComputeResources, bool prioritizeLatency) {
    return buildGreedyStep(
        region, graph, arch, config, state, steadyState.get(),
        steadyStallTarget, ready, scheduled, pending, result, origins,
        computeIslands, noInsts, steadyCritical, prioritizeLongLatencyVmem,
        prioritizeComputeResources, prioritizeLatency, stallTarget);
  }

  SmallVector<unsigned, 16> pending;
  BitVector ready;
  BitVector scheduled;
  GreedyResult result;
  ComputeIslandInfo computeIslands;
  BitVector noInsts;
  IssueState state;
  std::unique_ptr<IssueState> steadyState;
  BitVector steadyCritical;
  std::optional<SteadyStallTarget> steadyStallTarget;
  std::optional<unsigned> stallTarget;
};

static GreedyResult buildGreedyOrderFromState(
    const GreedyRegion &region, const GraphTables &graph,
    const waveamdmachine::ArchData &arch,
    const waveamdmachine::EventSimConfig &config, const ValueOriginMap &origins,
    const StaticIssueInfoMap &staticInfo,
    const WaveAMDMachineScheduleModel &scheduleModel,
    const IssueState *initialState, bool prioritizeLongLatencyVmem,
    bool prioritizeComputeResources, bool prioritizeLatency) {
  assert((!initialState || initialState->staticInfo == &staticInfo) &&
         "initial issue state uses different static info");
  IssueState state(
      arch, buildWaveAMDMachineInstructionConfig(arch, config, region.first),
      staticInfo);
  std::unique_ptr<IssueState> steadyState =
      initialState ? std::make_unique<IssueState>(*initialState) : nullptr;
  bindValueOrigins(state.model, origins, state.frozenLoopArgs);
  if (steadyState)
    bindValueOrigins(steadyState->model, origins, steadyState->frozenLoopArgs);
  ComputeIslandInfo computeIslands =
      buildComputeIslandInfo(region, graph, config, scheduleModel);
  GreedyOrderState orderState(region, graph, staticInfo,
                              std::move(computeIslands), std::move(state),
                              std::move(steadyState));
  while (orderState.result.order.size() != region.ops.size()) {
    FailureOr<GreedyStepStatus> step = orderState.step(
        region, graph, arch, config, origins, prioritizeLongLatencyVmem,
        prioritizeComputeResources, prioritizeLatency);
    if (failed(step))
      return failGreedyModel(orderState.result);
    if (*step == GreedyStepStatus::Done)
      break;
    if (*step == GreedyStepStatus::Blocked)
      return orderState.result;
  }

  ReadyScheduleWorkStats work =
      orderState.computeIslands.session.getWorkStats();
  orderState.result.stats.pressureStateBuilds = work.stateBuilds;
  orderState.result.stats.pressureMemberVisits = work.memberVisits;
  orderState.result.stats.pressureProjections = work.projections;
  orderState.result.stats.pressureProjectedNodes = work.projectedNodes;
  orderState.result.stats.pressureProjectionChecks = work.projectionChecks;
  orderState.result.stats.pressurePriorityMoves = work.pressureSelections;
  orderState.result.success = true;
  return orderState.result;
}

static GreedyResult buildGreedyOrder(
    const GreedyRegion &region, const GraphTables &graph,
    const waveamdmachine::ArchData &arch,
    const waveamdmachine::EventSimConfig &config, const ValueOriginMap &origins,
    const WaveAMDMachineScheduleModel &scheduleModel,
    bool prioritizeLongLatencyVmem = true,
    bool prioritizeComputeResources = true, bool prioritizeLatency = true) {
  FailureOr<StaticIssueInfoMap> staticInfo =
      buildStaticIssueInfoMap(region, arch);
  if (failed(staticInfo)) {
    GreedyResult result;
    return failGreedyModel(result);
  }
  return buildGreedyOrderFromState(
      region, graph, arch, config, origins, *staticInfo, scheduleModel,
      /*initialState=*/nullptr, prioritizeLongLatencyVmem,
      prioritizeComputeResources, prioritizeLatency);
}

static waveamdmachine::UniformLoopOp
getCompleteUniformLoop(const GreedyRegion &region) {
  waveamdmachine::UniformLoopOp loop =
      dyn_cast_if_present<waveamdmachine::UniformLoopOp>(
          region.block->getParentOp());
  if (!loop)
    return nullptr;

  unsigned index = 0;
  for (Operation &op : region.block->without_terminator()) {
    if (index >= region.ops.size() || region.ops[index] != &op)
      return nullptr;
    ++index;
  }
  return index == region.ops.size() ? loop : nullptr;
}

static void bindLoopEntry(IssueState &state,
                          waveamdmachine::UniformLoopOp loop) {
  Block &body = loop.getBody().front();
  for (auto [arg, init] : llvm::zip_equal(body.getArguments(), loop.getInits()))
    state.model.bindValue(arg, init);
}

static LogicalResult bindLoopBackedge(IssueState &state,
                                      waveamdmachine::UniformLoopOp loop) {
  Block &body = loop.getBody().front();
  waveamdmachine::ContinueIfOp terminator =
      dyn_cast<waveamdmachine::ContinueIfOp>(body.getTerminator());
  if (!terminator)
    return failure();
  for (auto [arg, carry] :
       llvm::zip_equal(body.getArguments(), terminator.getCarries()))
    state.model.bindValue(arg, carry);
  return success();
}

static FailureOr<std::unique_ptr<IssueState>>
replayLoopOrder(const GreedyRegion &region, ArrayRef<unsigned> order,
                const waveamdmachine::ArchData &arch,
                const waveamdmachine::EventSimConfig &config,
                const ValueOriginMap &origins,
                const StaticIssueInfoMap &staticInfo) {
  waveamdmachine::UniformLoopOp loop = getCompleteUniformLoop(region);
  if (!loop)
    return failure();

  std::unique_ptr<IssueState> state = std::make_unique<IssueState>(
      arch, buildWaveAMDMachineInstructionConfig(arch, config, region.first),
      staticInfo, region.block);
  bindValueOrigins(state->model, origins, region.block);
  bindLoopEntry(*state, loop);
  for (unsigned iteration : llvm::seq(kSteadyStateIterations)) {
    (void)iteration;
    for (unsigned index : order) {
      FailureOr<IssuePreview> preview = previewIssue(*state, region.ops[index]);
      if (failed(preview) ||
          failed(commitIssue(*state, region.ops[index], *preview, origins)))
        return failure();
    }
    if (failed(bindLoopBackedge(*state, loop)))
      return failure();
  }
  return state;
}

static void materializeOrder(const GreedyRegion &region,
                             ArrayRef<unsigned> order,
                             SmallVectorImpl<Operation *> &ops) {
  ops.clear();
  for (unsigned index : order)
    ops.push_back(region.ops[index]);
}

static bool hasSeenOrder(ArrayRef<SmallVector<unsigned, 16>> seen,
                         ArrayRef<unsigned> order) {
  return llvm::any_of(
      seen, [&](ArrayRef<unsigned> prior) { return sameOrder(prior, order); });
}

static GreedyResult refineSteadyStateGreedyOrder(
    const GreedyRegion &region, const GraphTables &graph,
    const waveamdmachine::ArchData &arch,
    const waveamdmachine::EventSimConfig &config, const ValueOriginMap &origins,
    const StaticIssueInfoMap &staticInfo,
    const WaveAMDMachineScheduleModel &scheduleModel, GreedyResult best,
    bool prioritizeLongLatencyVmem, bool prioritizeComputeResources,
    bool prioritizeLatency) {
  bool usedModeledRecurrence = best.stats.recurrenceModelMoves != 0;
  SmallVector<unsigned, 16> currentOrder = best.order;
  SmallVector<SmallVector<unsigned, 16>, 4> seenOrders{currentOrder};
  unsigned refinements = 0;

  FailureOr<std::unique_ptr<IssueState>> replayed =
      replayLoopOrder(region, currentOrder, arch, config, origins, staticInfo);
  if (failed(replayed))
    return failGreedyModel(best);
  std::unique_ptr<IssueState> entryState = std::move(*replayed);

  for (unsigned refinement : llvm::seq(kSteadyStateRefinementLimit)) {
    GreedyResult stableCandidate = buildGreedyOrderFromState(
        region, graph, arch, config, origins, staticInfo, scheduleModel,
        entryState.get(), prioritizeLongLatencyVmem, prioritizeComputeResources,
        prioritizeLatency);
    ++refinements;
    if (!stableCandidate.success)
      return stableCandidate;
    usedModeledRecurrence |= stableCandidate.stats.recurrenceModelMoves != 0;
    if (sameOrder(stableCandidate.order, currentOrder) ||
        hasSeenOrder(seenOrders, stableCandidate.order))
      break;

    seenOrders.push_back(stableCandidate.order);
    best = std::move(stableCandidate);
    currentOrder = best.order;
    if (refinement + 1 == kSteadyStateRefinementLimit)
      break;

    FailureOr<std::unique_ptr<IssueState>> candidateState = replayLoopOrder(
        region, currentOrder, arch, config, origins, staticInfo);
    if (failed(candidateState))
      return failGreedyModel(best);
    entryState = std::move(*candidateState);
  }

  best.stats.steadyStateIterations = kSteadyStateIterations;
  best.stats.steadyStateRefinements = refinements;
  if (usedModeledRecurrence && best.stats.recurrenceModelMoves == 0)
    best.stats.recurrenceModelMoves = 1;
  return best;
}

// Never post-veto greedy orders with simulated cycles; fix greedy choices.
static GreedyResult buildBoundedGreedyOrder(
    const GreedyRegion &region, const GraphTables &graph,
    const waveamdmachine::ArchData &arch,
    const waveamdmachine::EventSimConfig &config, const ValueOriginMap &origins,
    const WaveAMDMachineScheduleModel &scheduleModel,
    bool prioritizeLongLatencyVmem = true,
    bool prioritizeComputeResources = true, bool prioritizeLatency = true) {
  if (!getCompleteUniformLoop(region))
    return buildGreedyOrder(region, graph, arch, config, origins, scheduleModel,
                            prioritizeLongLatencyVmem,
                            prioritizeComputeResources, prioritizeLatency);

  FailureOr<StaticIssueInfoMap> staticInfo =
      buildStaticIssueInfoMap(region, arch);
  if (failed(staticInfo)) {
    GreedyResult result;
    return failGreedyModel(result);
  }
  GreedyResult best = buildGreedyOrderFromState(
      region, graph, arch, config, origins, *staticInfo, scheduleModel,
      /*initialState=*/nullptr, prioritizeLongLatencyVmem,
      prioritizeComputeResources, prioritizeLatency);
  if (!best.success)
    return best;
  return refineSteadyStateGreedyOrder(
      region, graph, arch, config, origins, *staticInfo, scheduleModel,
      std::move(best), prioritizeLongLatencyVmem, prioritizeComputeResources,
      prioritizeLatency);
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
               << " coexec_window_gaps=" << stats.coexecWindowGaps
               << " vmem_prefetch_moves=" << stats.vmemPrefetchMoves
               << " long_latency_vmem_prefetch_moves="
               << stats.longLatencyVmemPrefetchMoves
               << " recurrence_model_moves=" << stats.recurrenceModelMoves
               << " memory_token_gaps=" << stats.memoryTokenGaps
               << " barrier_memory_gaps=" << stats.barrierMemoryGaps
               << " filled_barrier_memory_gaps="
               << stats.filledBarrierMemoryGaps
               << " steady_state_fills=" << stats.steadyStateFills
               << " steady_state_iterations=" << stats.steadyStateIterations
               << " steady_state_refinements=" << stats.steadyStateRefinements
               << " latency_priority_moves=" << stats.latencyPriorityMoves
               << " resource_priority_moves=" << stats.resourcePriorityMoves
               << " resource_stall_fills=" << stats.resourceStallFills
               << " pressure_priority_moves=" << stats.pressurePriorityMoves
               << "\n";
}

using MultiWaveRegions = std::array<GreedyRegion, kMultiWaveClassCount>;
using MultiWaveGraphs = std::array<GraphTables, kMultiWaveClassCount>;
using MultiWaveOrders =
    std::array<SmallVector<unsigned, 16>, kMultiWaveClassCount>;
using MultiWaveRegionLists =
    std::array<SmallVector<GreedyRegion, 16>, kMultiWaveClassCount>;

static waveamdmachine::InstructionExecutionConfig
buildMultiWaveInstructionConfig(const waveamdmachine::ArchData &arch,
                                const waveamdmachine::EventSimConfig &config,
                                Operation *context) {
  waveamdmachine::InstructionExecutionConfig stateConfig =
      buildWaveAMDMachineInstructionConfig(arch, config, context);
  stateConfig.smoothLdsDmaIssue = false;
  stateConfig.enablePipeBackpressure = true;
  stateConfig.valuMaxInFlight = 1;
  stateConfig.saluMaxInFlight = 1;
  stateConfig.xdlMaxInFlight = 1;
  return stateConfig;
}

static void
bindMultiWaveValueOrigins(waveamdmachine::MultiWaveExecutionState &state,
                          unsigned wave, const ValueOriginMap &origins,
                          Block *frozenLoopArgs) {
  for (const ValueOriginBinding &binding : origins.bindings) {
    BlockArgument arg = dyn_cast<BlockArgument>(binding.target);
    if (arg && arg.getOwner() == frozenLoopArgs)
      continue;
    state.bindValue(wave, binding.target, binding.leaves);
  }
}

static void
bindMultiWaveLoopEntry(waveamdmachine::MultiWaveExecutionState &state,
                       unsigned wave, waveamdmachine::UniformLoopOp loop) {
  Block &body = loop.getBody().front();
  for (auto [arg, init] : llvm::zip_equal(body.getArguments(), loop.getInits()))
    state.bindValue(wave, arg, init);
}

static LogicalResult
bindMultiWaveLoopBackedge(waveamdmachine::MultiWaveExecutionState &state,
                          unsigned wave, waveamdmachine::UniformLoopOp loop) {
  Block &body = loop.getBody().front();
  auto terminator =
      dyn_cast<waveamdmachine::ContinueIfOp>(body.getTerminator());
  if (!terminator)
    return failure();
  for (auto [arg, carry] :
       llvm::zip_equal(body.getArguments(), terminator.getCarries()))
    state.bindValue(wave, arg, carry);
  return success();
}

static void
initializeMultiWaveState(waveamdmachine::MultiWaveExecutionState &state,
                         const MultiWaveRegions &regions,
                         const ValueOriginMap &origins) {
  for (unsigned wave : llvm::seq<unsigned>(state.getWaveCount())) {
    unsigned classId = getMultiWaveClass(state, wave);
    waveamdmachine::UniformLoopOp loop =
        getCompleteUniformLoop(regions[classId]);
    bindMultiWaveValueOrigins(state, wave, origins, regions[classId].block);
    bindMultiWaveLoopEntry(state, wave, loop);
  }
}

static bool haveSameGraphShape(const GraphTables &lhs, const GraphTables &rhs) {
  if (lhs.pendingPreds != rhs.pendingPreds ||
      lhs.edges.size() != rhs.edges.size())
    return false;
  for (auto [left, right] : llvm::zip_equal(lhs.edges, rhs.edges))
    if (left.src != right.src || left.dst != right.dst ||
        left.kind != right.kind || left.recurrence != right.recurrence)
      return false;
  return true;
}

static bool haveSameRegionShape(const MultiWaveRegions &regions,
                                const MultiWaveGraphs &graphs) {
  if (regions[0].ops.empty() ||
      regions[0].ops.size() != regions[1].ops.size() ||
      regions[0].blockOrdinal != regions[1].blockOrdinal ||
      regions[0].regionOrdinal != regions[1].regionOrdinal ||
      !haveSameGraphShape(graphs[0], graphs[1]))
    return false;
  for (auto [left, right] : llvm::zip_equal(regions[0].ops, regions[1].ops))
    if (left->getName() != right->getName() ||
        left->getOperandTypes() != right->getOperandTypes() ||
        left->getResultTypes() != right->getResultTypes())
      return false;
  return true;
}

static LogicalResult verifySameBarrier(Operation *left, Operation *right) {
  if (left->getName() != right->getName())
    return failure();
  DenseI64ArrayAttr leftSites =
      left->getAttrOfType<DenseI64ArrayAttr>(kBarrierSitesAttr);
  DenseI64ArrayAttr rightSites =
      right->getAttrOfType<DenseI64ArrayAttr>(kBarrierSitesAttr);
  return success(leftSites && leftSites == rightSites);
}

using MultiWaveGreedyResults = std::array<GreedyResult, kMultiWaveClassCount>;

struct GreedyPolicyConfig {
  bool prioritizeLongLatencyVmem = true;
  bool prioritizeComputeResources = true;
  bool prioritizeLatency = true;
};

using MultiWavePolicies = std::array<GreedyPolicyConfig, kMultiWaveClassCount>;

// Coordinator picks a class; buildGreedyStep owns every ordering choice.
class MultiWaveGreedyCoordinator {
public:
  MultiWaveGreedyCoordinator(
      const MultiWaveRegions &regions, const MultiWaveGraphs &graphs,
      const ValueOriginMap &origins,
      const WaveAMDMachineScheduleModel &scheduleModel,
      const waveamdmachine::ArchData &arch,
      const waveamdmachine::EventSimConfig &config,
      ArrayRef<waveamdmachine::WavePlacement> placements,
      const MultiWavePolicies &policies,
      const waveamdmachine::MultiWaveExecutionState *steadyState)
      : regions(regions), graphs(graphs), origins(origins), arch(arch),
        config(config), policies(policies), scheduleModel(scheduleModel),
        localState(std::make_unique<waveamdmachine::MultiWaveExecutionState>(
            arch, placements,
            buildMultiWaveInstructionConfig(arch, config, regions[0].first))) {
    if (steadyState)
      this->steadyState =
          std::make_unique<waveamdmachine::MultiWaveExecutionState>(
              *steadyState);
    for (unsigned wave : llvm::seq<unsigned>(localState->getWaveCount())) {
      unsigned classId = getMultiWaveClass(*localState, wave);
      classWaves[classId].push_back(wave);
    }
    for (unsigned classId : llvm::seq<unsigned>(kMultiWaveClassCount)) {
      FailureOr<StaticIssueInfoMap> info =
          buildStaticIssueInfoMap(regions[classId], arch);
      if (failed(info)) {
        initializationFailed = true;
        return;
      }
      staticInfo[classId] = std::move(*info);
      ComputeIslandInfo computeIslands = buildComputeIslandInfo(
          regions[classId], graphs[classId], config, scheduleModel);
      IssueState local(*localState, classWaves[classId], staticInfo[classId]);
      bindValueOrigins(local.model, origins, local.frozenLoopArgs);
      std::unique_ptr<IssueState> steady;
      if (this->steadyState) {
        steady = std::make_unique<IssueState>(
            *this->steadyState, classWaves[classId], staticInfo[classId],
            regions[classId].block);
        bindValueOrigins(steady->model, origins, steady->frozenLoopArgs);
      }
      classes[classId] = std::make_unique<GreedyOrderState>(
          regions[classId], graphs[classId], staticInfo[classId],
          std::move(computeIslands), std::move(local), std::move(steady));
    }
  }

  FailureOr<MultiWaveGreedyResults> run();

private:
  void loadModel(unsigned classId);
  void saveModel(unsigned classId);
  FailureOr<unsigned> selectClass() const;
  LogicalResult advanceClass(unsigned classId, size_t &added);
  FailureOr<Operation *> getTrailingBarrier(unsigned classId,
                                            size_t previousSize) const;
  LogicalResult rendezvousBarriers();
  bool hasWaitingBarriers() const;
  MultiWaveGreedyResults takeResults();

  std::array<SmallVector<unsigned, 4>, kMultiWaveClassCount> classWaves;
  std::array<StaticIssueInfoMap, kMultiWaveClassCount> staticInfo;
  std::array<std::unique_ptr<GreedyOrderState>, kMultiWaveClassCount> classes;
  std::array<Operation *, kMultiWaveClassCount> waitingBarriers{};
  const MultiWaveRegions &regions;
  const MultiWaveGraphs &graphs;
  const ValueOriginMap &origins;
  const waveamdmachine::ArchData &arch;
  const waveamdmachine::EventSimConfig &config;
  const MultiWavePolicies &policies;
  const WaveAMDMachineScheduleModel &scheduleModel;
  std::unique_ptr<waveamdmachine::MultiWaveExecutionState> localState;
  std::unique_ptr<waveamdmachine::MultiWaveExecutionState> steadyState;
  unsigned preferredClass = 0;
  bool initializationFailed = false;
};

void MultiWaveGreedyCoordinator::loadModel(unsigned classId) {
  GreedyOrderState &classState = *classes[classId];
  classState.state.model.setMultiWaveState(std::move(localState));
  if (classState.steadyState)
    classState.steadyState->model.setMultiWaveState(std::move(steadyState));
}

void MultiWaveGreedyCoordinator::saveModel(unsigned classId) {
  GreedyOrderState &classState = *classes[classId];
  localState = classState.state.model.takeMultiWaveState();
  if (classState.steadyState)
    steadyState = classState.steadyState->model.takeMultiWaveState();
}

FailureOr<unsigned> MultiWaveGreedyCoordinator::selectClass() const {
  for (unsigned offset : llvm::seq<unsigned>(kMultiWaveClassCount)) {
    unsigned classId = (preferredClass + offset) % kMultiWaveClassCount;
    if (waitingBarriers[classId])
      continue;
    if (classes[classId]->result.order.size() == regions[classId].ops.size())
      continue;
    return classId;
  }
  return failure();
}

FailureOr<Operation *>
MultiWaveGreedyCoordinator::getTrailingBarrier(unsigned classId,
                                               size_t previousSize) const {
  const GreedyOrderState &classState = *classes[classId];
  Operation *barrier = nullptr;
  for (unsigned position :
       llvm::seq<unsigned>(previousSize, classState.result.order.size())) {
    Operation *op = regions[classId].ops[classState.result.order[position]];
    if (!isBarrierOp(op))
      continue;
    if (barrier || position + 1 != classState.result.order.size())
      return failure();
    barrier = op;
  }
  return barrier;
}

LogicalResult MultiWaveGreedyCoordinator::rendezvousBarriers() {
  if (!llvm::all_of(waitingBarriers,
                    [](Operation *barrier) { return barrier != nullptr; }))
    return success();
  if (failed(verifySameBarrier(waitingBarriers[0], waitingBarriers[1])))
    return failure();
  localState->rendezvous();
  if (steadyState)
    steadyState->rendezvous();
  waitingBarriers.fill(nullptr);
  return success();
}

LogicalResult MultiWaveGreedyCoordinator::advanceClass(unsigned classId,
                                                       size_t &added) {
  GreedyOrderState &classState = *classes[classId];
  size_t previousSize = classState.result.order.size();
  loadModel(classId);
  const GreedyPolicyConfig &policy = policies[classId];
  FailureOr<GreedyStepStatus> step = classState.step(
      regions[classId], graphs[classId], arch, config, origins,
      policy.prioritizeLongLatencyVmem, policy.prioritizeComputeResources,
      policy.prioritizeLatency);
  if (failed(step))
    return failure();
  if (*step == GreedyStepStatus::Blocked)
    return failure();
  saveModel(classId);

  added = classState.result.order.size() - previousSize;
  if (added == 0)
    return failure();
  FailureOr<Operation *> barrier = getTrailingBarrier(classId, previousSize);
  if (failed(barrier))
    return failure();
  waitingBarriers[classId] = *barrier;
  if (failed(rendezvousBarriers()))
    return failure();
  preferredClass = (classId + 1) % kMultiWaveClassCount;
  return success();
}

bool MultiWaveGreedyCoordinator::hasWaitingBarriers() const {
  return llvm::any_of(waitingBarriers,
                      [](Operation *barrier) { return barrier != nullptr; });
}

MultiWaveGreedyResults MultiWaveGreedyCoordinator::takeResults() {
  MultiWaveGreedyResults results;
  for (unsigned classId : llvm::seq<unsigned>(kMultiWaveClassCount)) {
    GreedyOrderState &state = *classes[classId];
    ReadyScheduleWorkStats work = state.computeIslands.session.getWorkStats();
    state.result.stats.pressureStateBuilds = work.stateBuilds;
    state.result.stats.pressureMemberVisits = work.memberVisits;
    state.result.stats.pressureProjections = work.projections;
    state.result.stats.pressureProjectedNodes = work.projectedNodes;
    state.result.stats.pressureProjectionChecks = work.projectionChecks;
    state.result.stats.pressurePriorityMoves = work.pressureSelections;
    state.result.success = true;
    results[classId] = std::move(state.result);
  }
  return results;
}

static size_t getMultiWaveOpCount(const MultiWaveRegions &regions) {
  size_t total = 0;
  for (const GreedyRegion &region : regions)
    total += region.ops.size();
  return total;
}

FailureOr<MultiWaveGreedyResults> MultiWaveGreedyCoordinator::run() {
  if (initializationFailed)
    return failure();
  size_t total = getMultiWaveOpCount(regions);
  size_t scheduled = 0;
  while (scheduled != total) {
    FailureOr<unsigned> classId = selectClass();
    if (failed(classId))
      return failure();
    size_t added = 0;
    if (failed(advanceClass(*classId, added)))
      return failure();
    scheduled += added;
  }
  if (hasWaitingBarriers())
    return failure();
  return takeResults();
}

struct MultiWaveReplayPosition {
  unsigned offset = 0;
  unsigned iteration = 0;
};

class MultiWaveOrderReplay {
public:
  MultiWaveOrderReplay(const MultiWaveRegions &regions,
                       const MultiWaveOrders &orders,
                       const ValueOriginMap &origins,
                       waveamdmachine::MultiWaveExecutionState &state,
                       unsigned iterations)
      : regions(regions), orders(orders), origins(origins), state(state),
        iterations(iterations) {
    positions.resize(state.getWaveCount());
  }

  LogicalResult run();

private:
  Operation *getCurrentOp(unsigned wave) const;
  FailureOr<bool> allWavesAtBarrier() const;
  FailureOr<unsigned> selectWave() const;
  LogicalResult commitWave(unsigned wave);
  LogicalResult commitBarrier();

  SmallVector<MultiWaveReplayPosition, 8> positions;
  const MultiWaveRegions &regions;
  const MultiWaveOrders &orders;
  const ValueOriginMap &origins;
  waveamdmachine::MultiWaveExecutionState &state;
  size_t committed = 0;
  unsigned iterations = 0;
};

Operation *MultiWaveOrderReplay::getCurrentOp(unsigned wave) const {
  const MultiWaveReplayPosition &position = positions[wave];
  if (position.iteration >= iterations)
    return nullptr;
  unsigned classId = getMultiWaveClass(state, wave);
  return regions[classId].ops[orders[classId][position.offset]];
}

FailureOr<bool> MultiWaveOrderReplay::allWavesAtBarrier() const {
  Operation *first = nullptr;
  std::optional<unsigned> iteration;
  for (unsigned wave : llvm::seq<unsigned>(state.getWaveCount())) {
    Operation *op = getCurrentOp(wave);
    if (!op || !isBarrierOp(op))
      return false;
    if (iteration && *iteration != positions[wave].iteration)
      return failure();
    if (first && failed(verifySameBarrier(first, op)))
      return failure();
    first = op;
    iteration = positions[wave].iteration;
  }
  return first != nullptr;
}

FailureOr<unsigned> MultiWaveOrderReplay::selectWave() const {
  SmallVector<Operation *, 8> candidates(state.getWaveCount(), nullptr);
  for (unsigned wave : llvm::seq<unsigned>(state.getWaveCount())) {
    Operation *op = getCurrentOp(wave);
    if (!op || isBarrierOp(op))
      continue;
    candidates[wave] = op;
  }
  return state.selectWave(candidates);
}

LogicalResult MultiWaveOrderReplay::commitWave(unsigned wave) {
  Operation *op = getCurrentOp(wave);
  if (!op || failed(state.commit(wave, op)))
    return failure();
  unsigned classId = getMultiWaveClass(state, wave);
  bindMultiWaveValueOrigins(state, wave, origins, regions[classId].block);
  MultiWaveReplayPosition &position = positions[wave];
  ++position.offset;
  if (position.offset == orders[classId].size()) {
    position.offset = 0;
    ++position.iteration;
    if (failed(bindMultiWaveLoopBackedge(
            state, wave, getCompleteUniformLoop(regions[classId]))))
      return failure();
  }
  ++committed;
  return success();
}

LogicalResult MultiWaveOrderReplay::commitBarrier() {
  SmallVector<Operation *, 8> candidates(state.getWaveCount(), nullptr);
  for (unsigned wave : llvm::seq<unsigned>(state.getWaveCount()))
    candidates[wave] = getCurrentOp(wave);
  for ([[maybe_unused]] unsigned offset :
       llvm::seq<unsigned>(state.getWaveCount())) {
    FailureOr<unsigned> wave = state.selectWave(candidates);
    if (failed(wave) || failed(commitWave(*wave)))
      return failure();
    candidates[*wave] = nullptr;
  }
  state.rendezvous();
  return success();
}

LogicalResult MultiWaveOrderReplay::run() {
  size_t total = state.getWaveCount() * regions[0].ops.size() * iterations;
  for ([[maybe_unused]] size_t step : llvm::seq<size_t>(total)) {
    if (committed == total)
      return success();
    FailureOr<bool> barrier = allWavesAtBarrier();
    if (failed(barrier))
      return failure();
    if (*barrier) {
      if (failed(commitBarrier()))
        return failure();
      continue;
    }
    FailureOr<unsigned> wave = selectWave();
    if (failed(wave) || failed(commitWave(*wave)))
      return failure();
  }
  return success(committed == total);
}

static bool sameMultiWaveOrders(const MultiWaveOrders &lhs,
                                const MultiWaveOrders &rhs) {
  return llvm::all_of(
      llvm::seq<unsigned>(kMultiWaveClassCount),
      [&](unsigned classId) { return sameOrder(lhs[classId], rhs[classId]); });
}

static bool hasSeenMultiWaveOrders(ArrayRef<MultiWaveOrders> seen,
                                   const MultiWaveOrders &orders) {
  return llvm::any_of(seen, [&](const MultiWaveOrders &prior) {
    return sameMultiWaveOrders(prior, orders);
  });
}

static FailureOr<std::unique_ptr<waveamdmachine::MultiWaveExecutionState>>
replayMultiWaveOrders(const MultiWaveRegions &regions,
                      const MultiWaveOrders &orders,
                      const waveamdmachine::ArchData &arch,
                      const waveamdmachine::EventSimConfig &config,
                      const ValueOriginMap &origins,
                      ArrayRef<waveamdmachine::WavePlacement> placements) {
  auto state = std::make_unique<waveamdmachine::MultiWaveExecutionState>(
      arch, placements,
      buildMultiWaveInstructionConfig(arch, config, regions[0].first));
  initializeMultiWaveState(*state, regions, origins);
  MultiWaveOrderReplay replay(regions, orders, origins, *state,
                              kSteadyStateIterations);
  if (failed(replay.run()))
    return failure();
  return state;
}

static MultiWaveOrders
getMultiWaveOrders(const MultiWaveGreedyResults &results) {
  MultiWaveOrders orders;
  for (unsigned classId : llvm::seq<unsigned>(kMultiWaveClassCount))
    orders[classId] = results[classId].order;
  return orders;
}

static FailureOr<MultiWaveGreedyResults> buildMultiWaveGreedyResults(
    const MultiWaveRegions &regions, const MultiWaveGraphs &graphs,
    const waveamdmachine::ArchData &arch,
    const waveamdmachine::EventSimConfig &config, const ValueOriginMap &origins,
    const WaveAMDMachineScheduleModel &scheduleModel,
    ArrayRef<waveamdmachine::WavePlacement> placements,
    const MultiWavePolicies &policies,
    const waveamdmachine::MultiWaveExecutionState *steadyState = nullptr) {
  MultiWaveGreedyCoordinator coordinator(regions, graphs, origins,
                                         scheduleModel, arch, config,
                                         placements, policies, steadyState);
  return coordinator.run();
}

static bool areCompleteMultiWaveLoops(const MultiWaveRegions &regions) {
  return llvm::all_of(regions, [](const GreedyRegion &region) {
    return getCompleteUniformLoop(region) != nullptr;
  });
}

struct MultiWaveRefinementState {
  MultiWaveGreedyResults best;
  MultiWaveOrders current;
  SmallVector<MultiWaveOrders, 4> seen;
  std::array<bool, kMultiWaveClassCount> usedModeledRecurrence{};
  unsigned refinements = 0;
};

static void
recordMultiWaveRecurrences(const MultiWaveGreedyResults &results,
                           std::array<bool, kMultiWaveClassCount> &used) {
  for (unsigned classId : llvm::seq<unsigned>(kMultiWaveClassCount))
    used[classId] |= results[classId].stats.recurrenceModelMoves != 0;
}

static MultiWaveRefinementState
initializeMultiWaveRefinement(MultiWaveGreedyResults best) {
  MultiWaveRefinementState state;
  state.best = std::move(best);
  state.current = getMultiWaveOrders(state.best);
  state.seen.push_back(state.current);
  recordMultiWaveRecurrences(state.best, state.usedModeledRecurrence);
  return state;
}

static void acceptMultiWaveRefinement(MultiWaveRefinementState &state,
                                      MultiWaveGreedyResults candidate,
                                      MultiWaveOrders candidateOrders) {
  state.best = std::move(candidate);
  state.current = std::move(candidateOrders);
  state.seen.push_back(state.current);
}

static FailureOr<bool> refineMultiWaveGreedyOnce(
    const MultiWaveRegions &regions, const MultiWaveGraphs &graphs,
    const waveamdmachine::ArchData &arch,
    const waveamdmachine::EventSimConfig &config, const ValueOriginMap &origins,
    const WaveAMDMachineScheduleModel &scheduleModel,
    ArrayRef<waveamdmachine::WavePlacement> placements,
    const MultiWavePolicies &policies, MultiWaveRefinementState &refinement) {
  FailureOr<std::unique_ptr<waveamdmachine::MultiWaveExecutionState>> state =
      replayMultiWaveOrders(regions, refinement.current, arch, config, origins,
                            placements);
  if (failed(state))
    return failure();
  FailureOr<MultiWaveGreedyResults> candidate = buildMultiWaveGreedyResults(
      regions, graphs, arch, config, origins, scheduleModel, placements,
      policies, state->get());
  if (failed(candidate))
    return failure();
  ++refinement.refinements;

  MultiWaveOrders candidateOrders = getMultiWaveOrders(*candidate);
  recordMultiWaveRecurrences(*candidate, refinement.usedModeledRecurrence);
  if (sameMultiWaveOrders(refinement.current, candidateOrders) ||
      hasSeenMultiWaveOrders(refinement.seen, candidateOrders))
    return false;
  acceptMultiWaveRefinement(refinement, std::move(*candidate),
                            std::move(candidateOrders));
  return true;
}

static MultiWaveGreedyResults
finishMultiWaveRefinement(MultiWaveRefinementState refinement) {
  for (unsigned classId : llvm::seq<unsigned>(kMultiWaveClassCount)) {
    GreedyResult &result = refinement.best[classId];
    result.stats.steadyStateIterations = kSteadyStateIterations;
    result.stats.steadyStateRefinements = refinement.refinements;
    if (refinement.usedModeledRecurrence[classId] &&
        result.stats.recurrenceModelMoves == 0)
      result.stats.recurrenceModelMoves = 1;
  }
  return std::move(refinement.best);
}

// Refinement feeds greedy state only; simulated totals never veto an order.
static FailureOr<MultiWaveGreedyResults> buildBoundedMultiWaveGreedyResults(
    const MultiWaveRegions &regions, const MultiWaveGraphs &graphs,
    const waveamdmachine::ArchData &arch,
    const waveamdmachine::EventSimConfig &config, const ValueOriginMap &origins,
    const WaveAMDMachineScheduleModel &scheduleModel,
    ArrayRef<waveamdmachine::WavePlacement> placements,
    const MultiWavePolicies &policies) {
  FailureOr<MultiWaveGreedyResults> first =
      buildMultiWaveGreedyResults(regions, graphs, arch, config, origins,
                                  scheduleModel, placements, policies);
  if (failed(first) || !areCompleteMultiWaveLoops(regions))
    return first;

  MultiWaveRefinementState refinement =
      initializeMultiWaveRefinement(std::move(*first));
  for ([[maybe_unused]] unsigned iteration :
       llvm::seq<unsigned>(kSteadyStateRefinementLimit)) {
    FailureOr<bool> changed = refineMultiWaveGreedyOnce(
        regions, graphs, arch, config, origins, scheduleModel, placements,
        policies, refinement);
    if (failed(changed))
      return failure();
    if (!*changed)
      break;
  }
  return finishMultiWaveRefinement(std::move(refinement));
}

struct RegionCollector {
  FailureOr<SmallVector<GreedyRegion, 16>> collect(func::FuncOp func) {
    this->func = func;
    for (Block &block : func.getBody())
      if (failed(collectBlock(block)))
        return failure();
    return std::move(regions);
  }

  FailureOr<SmallVector<GreedyRegion, 16>> collect(Region &root,
                                                   func::FuncOp func) {
    this->func = func;
    for (Block &block : root)
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
    if (op.hasAttr(kMultiWaveScheduleAttr))
      return success();
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
    if (isSchedulerRegionBoundary(&op)) {
      flush(block, thisBlockOrdinal, ops);
      // Real boundary instructions retain cost as singleton regions.
      if (isPinnedSchedulerBoundary(&op)) {
        ops.push_back(&op);
        flush(block, thisBlockOrdinal, ops);
      }
      return success();
    }
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
  WalkResult walk = func.walk([&](Operation *op) {
    if (op == func.getOperation() || !isWaveAMDMachineOpForScheduling(op))
      return WalkResult::advance();
    return WalkResult::interrupt();
  });
  return walk.wasInterrupted();
}

static FailureOr<MultiWaveRegionLists>
collectSpecializedRegions(waveamdmachine::UniformIfOp uniformIf) {
  func::FuncOp func = uniformIf->getParentOfType<func::FuncOp>();
  MultiWaveRegionLists regions;
  FailureOr<SmallVector<GreedyRegion, 16>> thenRegions =
      RegionCollector().collect(uniformIf.getThenRegion(), func);
  FailureOr<SmallVector<GreedyRegion, 16>> elseRegions =
      RegionCollector().collect(uniformIf.getElseRegion(), func);
  if (failed(thenRegions) || failed(elseRegions))
    return failure();
  if (thenRegions->size() != elseRegions->size()) {
    uniformIf.emitOpError("multi-wave branches have different region counts");
    return failure();
  }
  regions[0] = std::move(*thenRegions);
  regions[1] = std::move(*elseRegions);
  return regions;
}

static LogicalResult buildMultiWaveGraphs(waveamdmachine::UniformIfOp uniformIf,
                                          const MultiWaveRegions &regions,
                                          const ValueOriginMap &origins,
                                          MultiWaveGraphs &graphs) {
  for (unsigned classId : llvm::seq<unsigned>(kMultiWaveClassCount)) {
    if (failed(buildGraph(regions[classId], graphs[classId])))
      return failure();
    buildFillerMemoryKinds(regions[classId], origins, graphs[classId]);
  }
  if (!haveSameRegionShape(regions, graphs))
    return uniformIf.emitOpError("multi-wave branch graphs differ");
  return success();
}

static MultiWaveOrders
getOriginalMultiWaveOrders(const MultiWaveRegions &regions) {
  MultiWaveOrders orders;
  for (unsigned classId : llvm::seq<unsigned>(kMultiWaveClassCount))
    orders[classId] = getOriginalOrder(regions[classId]);
  return orders;
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

  LogicalResult
  processCollectedRegions(ArrayRef<waveamdmachine::UniformIfOp> specializations,
                          ArrayRef<GreedyRegion> regions,
                          const waveamdmachine::ArchData &arch,
                          const waveamdmachine::EventSimConfig &modelConfig,
                          const ValueOriginMap &origins,
                          const WaveAMDMachineScheduleModel &scheduleModel,
                          MachineScheduleStageTiming &timing) {
    for (waveamdmachine::UniformIfOp specialization : specializations)
      if (failed(processSpecialization(specialization, arch, modelConfig,
                                       origins, scheduleModel, timing)))
        return failure();
    for (const GreedyRegion &region : regions)
      if (failed(processRegion(region, arch, modelConfig, origins,
                               scheduleModel, timing)))
        return failure();
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
    SmallVector<waveamdmachine::UniformIfOp, 2> specializations;
    func.walk([&](waveamdmachine::UniformIfOp uniformIf) {
      if (uniformIf->hasAttr(kMultiWaveScheduleAttr))
        specializations.push_back(uniformIf);
    });
    FailureOr<SmallVector<GreedyRegion, 16>> collected =
        RegionCollector().collect(func);
    if (failed(collected))
      return WalkResult::interrupt();
    collectTiming.stop();

    TimingScope originsTiming =
        timing.nest("machine_schedule_build_value_origins");
    ValueOriginMap origins = buildValueOriginMap(func);
    originsTiming.stop();

    TimingScope modelTiming = timing.nest("machine_schedule_build_model");
    FailureOr<WaveAMDMachineScheduleModel> scheduleModel =
        WaveAMDMachineScheduleModel::create(func);
    if (failed(scheduleModel))
      return WalkResult::interrupt();
    modelTiming.stop();
    if (failed(processCollectedRegions(specializations, *collected, *arch.arch,
                                       modelConfig, origins, *scheduleModel,
                                       timing)))
      return WalkResult::interrupt();
    for (waveamdmachine::UniformIfOp specialization : specializations)
      specialization->removeAttr(kMultiWaveScheduleAttr);
    return WalkResult::advance();
  }

  bool shouldScheduleFunction(func::FuncOp func) const {
    if (func.isExternal())
      return false;
    if (applySchedule && requireSelectedInput &&
        !func->hasAttr(kScheduleInputAttr))
      return false;
    return hasAnyWaveMachineOp(func);
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
                              const WaveAMDMachineScheduleModel &scheduleModel,
                              MachineScheduleStageTiming &timing) {
    if (isRegionAboveLimit(region, maxRegionOps))
      return success();

    TimingScope graphTiming = timing.nest("machine_schedule_build_graph");
    GraphTables graph;
    if (failed(buildGraph(region, graph)))
      return failure();
    buildFillerMemoryKinds(region, origins, graph);
    graphTiming.stop();

    SmallVector<unsigned, 16> originalOrder = getOriginalOrder(region);
    TimingScope orderTiming = timing.nest("machine_schedule_build_order");
    GreedyResult greedy = buildBoundedGreedyOrder(region, graph, arch, config,
                                                  origins, scheduleModel);
    if (!greedy.success)
      return emitGreedyFailure(region, greedy);
    orderTiming.stop();

    TimingScope applyTiming = timing.nest("machine_schedule_apply_order");
    return applyGreedyOrder(region, originalOrder, greedy);
  }

  FailureOr<MultiWaveGreedyResults> buildMultiWaveOrder(
      waveamdmachine::UniformIfOp uniformIf, const MultiWaveRegions &regions,
      const MultiWaveGraphs &graphs, const waveamdmachine::ArchData &arch,
      const waveamdmachine::EventSimConfig &config,
      const ValueOriginMap &origins,
      const WaveAMDMachineScheduleModel &scheduleModel,
      ArrayRef<waveamdmachine::WavePlacement> placements,
      MachineScheduleStageTiming &timing) {
    MultiWavePolicies policies;
    TimingScope orderTiming = timing.nest("machine_schedule_build_joint_order");
    FailureOr<MultiWaveGreedyResults> candidate =
        buildBoundedMultiWaveGreedyResults(regions, graphs, arch, config,
                                           origins, scheduleModel, placements,
                                           policies);
    if (failed(candidate)) {
      uniformIf.emitOpError("joint greedy scheduling failed");
      return failure();
    }
    return candidate;
  }

  LogicalResult
  processSpecializedRegion(waveamdmachine::UniformIfOp uniformIf,
                           const MultiWaveRegions &regions,
                           const waveamdmachine::ArchData &arch,
                           const waveamdmachine::EventSimConfig &config,
                           const ValueOriginMap &origins,
                           const WaveAMDMachineScheduleModel &scheduleModel,
                           ArrayRef<waveamdmachine::WavePlacement> placements,
                           MachineScheduleStageTiming &timing) {
    if (llvm::any_of(regions, [&](const GreedyRegion &region) {
          return isRegionAboveLimit(region, maxRegionOps);
        }))
      return success();

    TimingScope graphTiming = timing.nest("machine_schedule_build_joint_graph");
    MultiWaveGraphs graphs;
    if (failed(buildMultiWaveGraphs(uniformIf, regions, origins, graphs)))
      return failure();
    graphTiming.stop();

    MultiWaveOrders originalOrders = getOriginalMultiWaveOrders(regions);
    FailureOr<MultiWaveGreedyResults> greedy =
        buildMultiWaveOrder(uniformIf, regions, graphs, arch, config, origins,
                            scheduleModel, placements, timing);
    if (failed(greedy))
      return failure();

    TimingScope applyTiming = timing.nest("machine_schedule_apply_joint_order");
    for (unsigned classId : llvm::seq<unsigned>(kMultiWaveClassCount))
      if (failed(applyGreedyOrder(regions[classId], originalOrders[classId],
                                  (*greedy)[classId])))
        return failure();
    return success();
  }

  LogicalResult
  processSpecialization(waveamdmachine::UniformIfOp uniformIf,
                        const waveamdmachine::ArchData &arch,
                        const waveamdmachine::EventSimConfig &config,
                        const ValueOriginMap &origins,
                        const WaveAMDMachineScheduleModel &scheduleModel,
                        MachineScheduleStageTiming &timing) {
    FailureOr<MultiWaveRegionLists> collected =
        collectSpecializedRegions(uniformIf);
    if (failed(collected))
      return failure();
    SmallVector<waveamdmachine::WavePlacement> placements =
        waveamdmachine::getFullCUWavePlacements(arch, uniformIf);
    if (placements.empty())
      return uniformIf.emitOpError("invalid multi-wave occupancy");

    for (unsigned regionIndex : llvm::seq<unsigned>((*collected)[0].size())) {
      MultiWaveRegions regions{(*collected)[0][regionIndex],
                               (*collected)[1][regionIndex]};
      if (failed(processSpecializedRegion(uniformIf, regions, arch, config,
                                          origins, scheduleModel, placements,
                                          timing)))
        return failure();
    }
    return success();
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

static LogicalResult
printReportClasses(const GreedyRegion &region,
                   const waveamdmachine::ArchData &arch,
                   const waveamdmachine::EventSimConfig &config) {
  if (failed(validateSchedClassSupport(region, arch)))
    return failure();
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
  return success();
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
    std::optional<WaveAMDMachineScheduleModel> scheduleModel;
    if (printCandidates) {
      FailureOr<WaveAMDMachineScheduleModel> built =
          WaveAMDMachineScheduleModel::create(func);
      if (failed(built))
        return WalkResult::interrupt();
      scheduleModel.emplace(std::move(*built));
    }
    for (const GreedyRegion &region : *collected)
      if (failed(reportRegion(region, *arch.arch, modelConfig, parsedOrder,
                              origins,
                              scheduleModel ? &*scheduleModel : nullptr)))
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
                        const ValueOriginMap &origins,
                        const WaveAMDMachineScheduleModel &scheduleModel) {
    if (!printCandidates)
      return success();

    GreedyResult greedy = buildBoundedGreedyOrder(region, graph, arch, config,
                                                  origins, scheduleModel);
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

  LogicalResult printCandidateSectionIfRequested(
      const GreedyRegion &region, const GraphTables &graph,
      ArrayRef<unsigned> originalOrder, FailureOr<OrderScore> originalScore,
      const waveamdmachine::ArchData &arch,
      const waveamdmachine::EventSimConfig &config,
      const ValueOriginMap &origins,
      const WaveAMDMachineScheduleModel *scheduleModel) {
    if (!printCandidates)
      return success();
    assert(scheduleModel && "candidate report requires schedule model");
    return printCandidateSection(region, graph, originalOrder, originalScore,
                                 arch, config, origins, *scheduleModel);
  }

  LogicalResult
  prepareRegionReport(const GreedyRegion &region,
                      const waveamdmachine::ArchData &arch,
                      const waveamdmachine::EventSimConfig &config) {
    if (printRegions)
      printReportRegion(region);
    if (printCandidates && failed(validateSchedClassSupport(region, arch)))
      return failure();
    if (printClasses && failed(printReportClasses(region, arch, config)))
      return failure();
    return success();
  }

  LogicalResult reportRegion(const GreedyRegion &region,
                             const waveamdmachine::ArchData &arch,
                             const waveamdmachine::EventSimConfig &config,
                             ArrayRef<unsigned> parsedOrder,
                             const ValueOriginMap &origins,
                             const WaveAMDMachineScheduleModel *scheduleModel) {
    if (failed(prepareRegionReport(region, arch, config)))
      return failure();

    if (!wantsGraphForRegion(region))
      return success();
    if (isRegionAboveLimit(region, maxRegionOps)) {
      printReportSkip(region, maxRegionOps);
      return success();
    }

    GraphTables graph;
    if (failed(buildGraph(region, graph)))
      return failure();
    buildFillerMemoryKinds(region, origins, graph);
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
    return printCandidateSectionIfRequested(region, graph, originalOrder,
                                            originalScore, arch, config,
                                            origins, scheduleModel);
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
                 << " coexec_window_gaps=" << stats.coexecWindowGaps
                 << " vmem_prefetch_moves=" << stats.vmemPrefetchMoves
                 << " recurrence_model_moves=" << stats.recurrenceModelMoves
                 << " memory_token_gaps=" << stats.memoryTokenGaps
                 << " barrier_memory_gaps=" << stats.barrierMemoryGaps
                 << " filled_barrier_memory_gaps="
                 << stats.filledBarrierMemoryGaps
                 << " steady_state_fills=" << stats.steadyStateFills
                 << " steady_state_iterations=" << stats.steadyStateIterations
                 << " steady_state_refinements=" << stats.steadyStateRefinements
                 << " latency_priority_moves=" << stats.latencyPriorityMoves
                 << " resource_priority_moves=" << stats.resourcePriorityMoves
                 << " resource_stall_fills=" << stats.resourceStallFills
                 << " pressure_priority_moves=" << stats.pressurePriorityMoves
                 << " order=";
    printOrder(order);
    llvm::errs() << " pressure_state_builds=" << stats.pressureStateBuilds
                 << " pressure_member_visits=" << stats.pressureMemberVisits
                 << " pressure_projections=" << stats.pressureProjections
                 << " pressure_projected_nodes=" << stats.pressureProjectedNodes
                 << " pressure_projection_checks="
                 << stats.pressureProjectionChecks << "\n";
  }
};

} // namespace
