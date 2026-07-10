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
#include "llvm/ADT/BitVector.h"
#include "llvm/ADT/DenseMap.h"
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

static constexpr StringLiteral kScheduleInputAttr =
    "waveamdmachine.schedule_input";
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

using MemoryKind = waveamdmachine::MemoryCounterKind;
using MemoryKindSet = SmallVector<MemoryKind, 4>;

struct ValueOriginMap {
  DenseMap<Value, SmallVector<Value, 4>> sources;
};

struct IssueState {
  IssueState(const waveamdmachine::ArchData &arch,
             waveamdmachine::InstructionExecutionConfig config)
      : model(arch, config) {}

  waveamdmachine::InstructionExecutionState model;
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

static void recordPreviewStall(IssuePreview &preview,
                               const waveamdmachine::InstructionStall &stall) {
  for (const waveamdmachine::InstructionStallComponent &component :
       stall.components) {
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
    case waveamdmachine::InstructionStallKind::M0ReadWrite:
      preview.hazardWaitInsts =
          std::max<unsigned>(preview.hazardWaitInsts, component.cycles);
      preview.m0Hazard = true;
      break;
    case waveamdmachine::InstructionStallKind::StoreWriteData:
      preview.hazardWaitInsts =
          std::max<unsigned>(preview.hazardWaitInsts, component.cycles);
      preview.storeDataHazard = true;
      break;
    case waveamdmachine::InstructionStallKind::None:
      break;
    }
  }
}

static FailureOr<IssuePreview>
previewIssue(const IssueState &state, Operation *op,
             const waveamdmachine::ArchData &arch,
             const waveamdmachine::EventSimConfig &config,
             const ValueOriginMap &origins) {
  IssuePreview preview;
  preview.cls = waveamdmachine::classifyOp(op);
  preview.realInst = preview.cls != waveamdmachine::SchedClass::NoInst;
  preview.fu = preview.realInst ? waveamdmachine::funit(arch, preview.cls)
                                : waveamdmachine::FunctionalUnit::None;
  preview.issues = preview.realInst ? getIssueCount(op) : 0;
  preview.memoryIssuer = waveamdmachine::getMemoryCounterKind(op) !=
                         waveamdmachine::MemoryCounterKind::None;
  preview.hasMemoryValue = waveamdmachine::hasMemoryValueLatency(op);

  IssueState trial = state;
  bindValueOrigins(trial.model, origins);
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
  (void)arch;
  (void)config;
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
  bindValueOrigins(state.model, origins);
  if (failed(state.model.commit(op)))
    return failure();
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

static void bindValueOrigins(waveamdmachine::InstructionExecutionState &model,
                             const ValueOriginMap &origins) {
  for (const auto &entry : origins.sources) {
    SmallVector<Value, 4> leaves;
    SmallPtrSet<Value, 16> visited;
    collectOriginLeaves(entry.first, origins, leaves, visited);
    if (!leaves.empty())
      model.bindValue(entry.first, leaves);
  }
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
    bindValueOrigins(trial.model, origins);
    FailureOr<waveamdmachine::InstructionCommitResult> commit =
        trial.model.commit(op);
    if (failed(commit))
      return failure();
    addProjectionStall(projection, commit->stall);
  }
  projection.cycles = trial.model.getCurrentCycle() - startCycle;
  return projection;
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

static FailureOr<unsigned>
findStallFiller(const BitVector &ready, unsigned next,
                const GreedyRegion &region, const IssueState &state,
                const BitVector &scheduled,
                const waveamdmachine::ArchData &arch,
                const waveamdmachine::EventSimConfig &cfg, FillableStall stall,
                const ValueOriginMap &origins) {
  for (unsigned index : llvm::seq(ready.size())) {
    if (!ready.test(index) || index == next)
      continue;
    if (!canUseStallFiller(region, scheduled, next, index, origins))
      continue;
    FailureOr<IssuePreview> preview =
        previewIssue(state, region.ops[index], arch, cfg, origins);
    if (failed(preview))
      return failure();
    if (fillsStall(stall, *preview))
      return index;
  }
  return ready.size();
}

static unsigned findFirstReadyNoInst(const BitVector &ready,
                                     const GreedyRegion &region) {
  for (unsigned index : llvm::seq(ready.size())) {
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

static LogicalResult scheduleReadyNode(
    unsigned selected, const GreedyRegion &region, const GraphTables &graph,
    const waveamdmachine::ArchData &arch,
    const waveamdmachine::EventSimConfig &config, IssueState &state,
    BitVector &ready, BitVector &scheduled, SmallVectorImpl<unsigned> &pending,
    SmallVectorImpl<unsigned> &order, const IssuePreview &preview,
    const ValueOriginMap &origins) {
  order.push_back(selected);
  if (failed(commitIssue(state, region.ops[selected], preview, origins)))
    return failure();
  markScheduled(selected, graph, ready, scheduled, pending);
  (void)arch;
  (void)config;
  return success();
}

static LogicalResult drainReadyNoInsts(
    const GreedyRegion &region, const GraphTables &graph,
    const waveamdmachine::ArchData &arch,
    const waveamdmachine::EventSimConfig &config, IssueState &state,
    BitVector &ready, BitVector &scheduled, SmallVectorImpl<unsigned> &pending,
    SmallVectorImpl<unsigned> &order, const ValueOriginMap &origins) {
  while (true) {
    unsigned selected = findFirstReadyNoInst(ready, region);
    if (selected == region.ops.size())
      return success();
    FailureOr<IssuePreview> preview =
        previewIssue(state, region.ops[selected], arch, config, origins);
    if (failed(preview))
      return failure();
    if (failed(scheduleReadyNode(selected, region, graph, arch, config, state,
                                 ready, scheduled, pending, order, *preview,
                                 origins)))
      return failure();
  }
}

static FailureOr<bool> previewNextIssue(
    const GreedyRegion &region, const waveamdmachine::ArchData &arch,
    const waveamdmachine::EventSimConfig &config, const IssueState &state,
    unsigned next, IssuePreview &nextPreview, const ValueOriginMap &origins) {
  FailureOr<IssuePreview> preview =
      previewIssue(state, region.ops[next], arch, config, origins);
  if (failed(preview))
    return failure();
  nextPreview = *preview;
  return !stalls(nextPreview);
}

static LogicalResult
scheduleStallFiller(const GreedyRegion &region, const GraphTables &graph,
                    const waveamdmachine::ArchData &arch,
                    const waveamdmachine::EventSimConfig &config,
                    IssueState &state, BitVector &ready, BitVector &scheduled,
                    SmallVectorImpl<unsigned> &pending,
                    SmallVectorImpl<unsigned> &order, unsigned filler,
                    const ValueOriginMap &origins) {
  FailureOr<IssuePreview> fillerPreview =
      previewIssue(state, region.ops[filler], arch, config, origins);
  if (failed(fillerPreview))
    return failure();
  if (failed(scheduleReadyNode(filler, region, graph, arch, config, state,
                               ready, scheduled, pending, order, *fillerPreview,
                               origins)))
    return failure();
  return drainReadyNoInsts(region, graph, arch, config, state, ready, scheduled,
                           pending, order, origins);
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

static FailureOr<bool> fillStallBeforeNext(
    const GreedyRegion &region, const GraphTables &graph,
    const waveamdmachine::ArchData &arch,
    const waveamdmachine::EventSimConfig &config, IssueState &state,
    BitVector &ready, BitVector &scheduled, SmallVectorImpl<unsigned> &pending,
    SmallVectorImpl<unsigned> &order, GreedyStats &stats, unsigned next,
    IssuePreview &nextPreview, const ValueOriginMap &origins) {
  while (true) {
    FailureOr<bool> readyNow = previewNextIssue(region, arch, config, state,
                                                next, nextPreview, origins);
    if (failed(readyNow))
      return failure();
    if (*readyNow)
      return true;
    if (isa<waveamdmachine::BarrierWaitOp>(region.ops[next]) &&
        nextPreview.memoryWaitCycles == 0)
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
    if (failed(scheduleStallFiller(region, graph, arch, config, state, ready,
                                   scheduled, pending, order, *filler,
                                   origins)))
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
    const waveamdmachine::ArchData &arch,
    const waveamdmachine::EventSimConfig &config, IssueState &state,
    BitVector &ready, BitVector &scheduled, SmallVectorImpl<unsigned> &pending,
    SmallVectorImpl<unsigned> &order, const ValueOriginMap &origins) {
  FailureOr<IssuePreview> selectedPreview =
      previewIssue(state, region.ops[selected], arch, config, origins);
  if (failed(selectedPreview))
    return failure();
  if (failed(scheduleReadyNode(selected, region, graph, arch, config, state,
                               ready, scheduled, pending, order,
                               *selectedPreview, origins)))
    return failure();
  return GreedyStepStatus::Continue;
}

static FailureOr<GreedyStepStatus> scheduleFirstReadyByOriginal(
    const GreedyRegion &region, const GraphTables &graph,
    const waveamdmachine::ArchData &arch,
    const waveamdmachine::EventSimConfig &config, IssueState &state,
    BitVector &ready, BitVector &scheduled, SmallVectorImpl<unsigned> &pending,
    SmallVectorImpl<unsigned> &order, const ValueOriginMap &origins) {
  unsigned selected = findFirstReadyByOriginal(ready);
  return scheduleReadyByIndex(selected, region, graph, arch, config, state,
                              ready, scheduled, pending, order, origins);
}

static FailureOr<GreedyStepStatus>
scheduleOriginalNext(const GreedyRegion &region, const GraphTables &graph,
                     const waveamdmachine::ArchData &arch,
                     const waveamdmachine::EventSimConfig &config,
                     IssueState &state, BitVector &ready, BitVector &scheduled,
                     SmallVectorImpl<unsigned> &pending, GreedyResult &result,
                     unsigned next, const ValueOriginMap &origins) {
  IssuePreview preview;
  FailureOr<bool> filled = fillStallBeforeNext(
      region, graph, arch, config, state, ready, scheduled, pending,
      result.order, result.stats, next, preview, origins);
  if (failed(filled))
    return failure();
  if (!*filled)
    return GreedyStepStatus::Continue;
  if (scheduled.test(next))
    return GreedyStepStatus::Continue;
  if (failed(scheduleReadyNode(next, region, graph, arch, config, state, ready,
                               scheduled, pending, result.order, preview,
                               origins)))
    return failure();
  return GreedyStepStatus::Continue;
}

static FailureOr<GreedyStepStatus>
buildGreedyStep(const GreedyRegion &region, const GraphTables &graph,
                const waveamdmachine::ArchData &arch,
                const waveamdmachine::EventSimConfig &config, IssueState &state,
                BitVector &ready, BitVector &scheduled,
                SmallVectorImpl<unsigned> &pending, GreedyResult &result,
                const ValueOriginMap &origins) {
  if (failed(drainReadyNoInsts(region, graph, arch, config, state, ready,
                               scheduled, pending, result.order, origins)))
    return failure();
  if (result.order.size() == region.ops.size())
    return GreedyStepStatus::Done;
  if (!ready.any()) {
    recordDependencyCycle(graph, scheduled, pending, result);
    return GreedyStepStatus::Blocked;
  }

  unsigned next = findFirstUnscheduled(scheduled);
  if (ready.test(next)) {
    FailureOr<unsigned> consumer =
        findReadyTokenConsumer(ready, region, scheduled, next, state, origins);
    if (failed(consumer))
      return failure();
    if (*consumer != region.ops.size())
      return scheduleReadyByIndex(*consumer, region, graph, arch, config, state,
                                  ready, scheduled, pending, result.order,
                                  origins);

    unsigned filler =
        findReadyBarrierPairFiller(ready, region, scheduled, next);
    if (filler != region.ops.size())
      return scheduleReadyByIndex(filler, region, graph, arch, config, state,
                                  ready, scheduled, pending, result.order,
                                  origins);
  }

  if (!ready.test(next))
    return scheduleFirstReadyByOriginal(region, graph, arch, config, state,
                                        ready, scheduled, pending, result.order,
                                        origins);
  return scheduleOriginalNext(region, graph, arch, config, state, ready,
                              scheduled, pending, result, next, origins);
}

static GreedyResult
buildGreedyOrder(const GreedyRegion &region, const GraphTables &graph,
                 const waveamdmachine::ArchData &arch,
                 const waveamdmachine::EventSimConfig &config,
                 const ValueOriginMap &origins) {
  GreedyResult result;
  SmallVector<unsigned, 16> pending = graph.pendingPreds;
  BitVector ready(region.ops.size());
  BitVector scheduled(region.ops.size());
  for (auto [index, count] : llvm::enumerate(pending))
    if (count == 0)
      ready.set(index);

  IssueState state(arch, buildInstructionConfig(arch, config));
  while (result.order.size() != region.ops.size()) {
    FailureOr<GreedyStepStatus> step =
        buildGreedyStep(region, graph, arch, config, state, ready, scheduled,
                        pending, result, origins);
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
    if (failed(validateOptions(root)))
      return signalPassFailure();

    waveamdmachine::EventSimConfig modelConfig = buildModelConfig();
    WalkResult walk = root->walk(
        [&](func::FuncOp func) { return processFunction(func, modelConfig); });
    if (walk.wasInterrupted())
      return signalPassFailure();
  }

  LogicalResult validateOptions(Operation *op) {
    if (maxRegionOps < -1)
      return op->emitError("max-region-ops must be -1 or non-negative");
    return success();
  }

  WalkResult
  processFunction(func::FuncOp func,
                  const waveamdmachine::EventSimConfig &modelConfig) {
    if (!shouldScheduleFunction(func))
      return WalkResult::advance();

    ArchResolution arch = resolveArch(func);
    if (failed(reportArchFailure(func, arch)))
      return WalkResult::interrupt();

    if (!applySchedule)
      return WalkResult::advance();
    func->removeAttr(kScheduleInputAttr);

    FailureOr<SmallVector<GreedyRegion, 16>> collected =
        RegionCollector().collect(func);
    if (failed(collected))
      return WalkResult::interrupt();
    ValueOriginMap origins = buildValueOriginMap(func);
    for (const GreedyRegion &region : *collected)
      if (failed(processRegion(region, *arch.arch, modelConfig, origins)))
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
    else if (filledOnlyStoreDataHazardGaps(greedy.stats))
      reason = "store_data_hazard";
    else if (filledBarrierMemoryGap(greedy.stats))
      reason = "barrier_memory";
    printDecision(region, "apply", reason, greedy.stats);
    applyOrder(region, greedy.order);
    return success();
  }

  LogicalResult processRegion(const GreedyRegion &region,
                              const waveamdmachine::ArchData &arch,
                              const waveamdmachine::EventSimConfig &config,
                              const ValueOriginMap &origins) {
    if (maxRegionOps >= 0 &&
        region.ops.size() > static_cast<unsigned>(maxRegionOps))
      return success();

    GraphTables graph;
    if (failed(buildGraph(region, graph)))
      return failure();

    GreedyResult greedy =
        buildGreedyOrder(region, graph, arch, config, origins);
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
      reason = "greedy";
      if (filledOnlyM0HazardGaps(greedy.stats))
        reason = "m0_hazard";
      else if (filledOnlyStoreDataHazardGaps(greedy.stats))
        reason = "store_data_hazard";
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
                 << " memory_token_gaps=" << stats.memoryTokenGaps
                 << " barrier_memory_gaps=" << stats.barrierMemoryGaps
                 << " filled_barrier_memory_gaps="
                 << stats.filledBarrierMemoryGaps << " order=";
    printOrder(order);
    llvm::errs() << "\n";
  }
};

} // namespace
