//===- WaveAMDMachineScheduleSupport.cpp - Scheduler support --------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "WaveAMDMachineScheduleSupport.h"

#include "WaveAMDMachineScheduleInternal.h"
#include "WaveAMDRegLiveIntervals.h"
#include "WaveAMDRegisterLimits.h"
#include "mlir/Dialect/WaveAMDMachine/CostModel/FunctionalUnit.h"
#include "mlir/Dialect/WaveAMDMachine/CostModel/LatencyTable.h"
#include "mlir/Dialect/WaveAMDMachine/CostModel/MemoryCounterTiming.h"
#include "mlir/Dialect/WaveAMDMachine/CostModel/OpClassifier.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachine.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachineTarget.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachineTraits.h"
#include "mlir/Interfaces/SideEffectInterfaces.h"
#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/TargetParser/TargetParser.h"

#include <algorithm>
#include <limits>
#include <optional>

using namespace mlir;

namespace mlir::wave {

namespace traits = ::mlir::OpTrait::waveamdmachine;
static constexpr StringLiteral kDiagPrefix = "waveamd-machine-schedule-report";
static constexpr StringLiteral kTargetWavesAttr = "waveamdmachine.target_waves";

static bool isWaveAMDMachineOp(Operation *op) {
  return op->getName().getDialectNamespace() ==
         waveamdmachine::WaveAMDMachineDialect::getDialectNamespace();
}

static bool isKnownMemoryOp(Operation *op) {
  return op->hasTrait<traits::SMEMLoadOp>() ||
         op->hasTrait<traits::VMEMLoadOp>() ||
         op->hasTrait<traits::VMEMStoreOp>();
}

static bool hasUnknownMemoryEffects(Operation *op) {
  if (isKnownMemoryOp(op))
    return false;
  MemoryEffectOpInterface iface = dyn_cast<MemoryEffectOpInterface>(op);
  if (!iface)
    return false;
  SmallVector<MemoryEffects::EffectInstance> effects;
  iface.getEffects(effects);
  return !effects.empty();
}

static bool isHardBoundary(Operation *op) {
  if (!isWaveAMDMachineOp(op))
    return true;
  if (op->hasTrait<OpTrait::IsTerminator>())
    return true;
  if (op->getNumRegions() != 0)
    return true;
  if (op->hasTrait<traits::WaitcntOp>())
    return true;
  if (isa<waveamdmachine::LabelOp, waveamdmachine::SBarrierOp,
          waveamdmachine::SSetprioOp, waveamdmachine::SCBranchExeczOp,
          waveamdmachine::SCBranchScc0Op, waveamdmachine::SCBranchScc1Op,
          waveamdmachine::SGetregShaderCyclesOp, waveamdmachine::SNopOp,
          waveamdmachine::WaitOp, waveamdmachine::SDelayAluOp,
          waveamdmachine::SAndSaveexecB32Op, waveamdmachine::SAndn2ExecB32Op,
          waveamdmachine::SMovExecLoOp, waveamdmachine::SEndpgmOp,
          waveamdmachine::SSetpcB64Op>(op))
    return true;
  return hasUnknownMemoryEffects(op);
}

StringRef getEdgeKindName(EdgeKind kind) {
  switch (kind) {
  case EdgeKind::Ssa:
    return "ssa";
  case EdgeKind::MemToken:
    return "mem_token";
  case EdgeKind::LoopCarry:
    return "loop_carry";
  }
  llvm_unreachable("unknown edge kind");
}

static bool isMemToken(Value value) {
  return isa<waveamdmachine::MemTokenType>(value.getType());
}

static void addEdge(DependenceGraph &graph, unsigned src, unsigned dst,
                    EdgeKind kind, bool recurrence = false) {
  if (src == dst)
    return;
  for (const ScheduleEdge &edge : graph.edges)
    if (edge.src == src && edge.dst == dst && edge.kind == kind &&
        edge.recurrence == recurrence)
      return;
  graph.edges.push_back({src, dst, kind, recurrence});
}

namespace {

class RegionCollector {
public:
  explicit RegionCollector(func::FuncOp func) : func(func) {}

  SmallVector<ScheduleRegion> collect() {
    for (Block &block : func.getBody())
      collectBlock(block);
    return regions;
  }

private:
  void flush(SmallVectorImpl<Operation *> &ops, unsigned blockOrdinal) {
    if (ops.empty())
      return;
    ScheduleRegion region;
    region.func = func;
    region.blockOrdinal = blockOrdinal;
    region.regionOrdinal = nextRegion++;
    region.first = ops.front();
    region.last = ops.back();
    region.opCount = static_cast<unsigned>(ops.size());
    region.ops.append(ops.begin(), ops.end());
    regions.push_back(std::move(region));
    ops.clear();
  }

  void collectBlock(Block &block) {
    unsigned blockOrdinal = nextBlock++;
    SmallVector<Operation *, 16> ops;
    for (Operation &op : block) {
      if (isHardBoundary(&op)) {
        flush(ops, blockOrdinal);
        if (auto loop = dyn_cast<waveamdmachine::UniformLoopOp>(op))
          for (Block &nested : loop.getBody())
            collectBlock(nested);
        continue;
      }
      ops.push_back(&op);
    }
    flush(ops, blockOrdinal);
  }

  func::FuncOp func;
  SmallVector<ScheduleRegion> regions;
  unsigned nextBlock = 0;
  unsigned nextRegion = 0;
};

} // namespace

SmallVector<ScheduleRegion> collectScheduleRegions(func::FuncOp func) {
  return RegionCollector(func).collect();
}

void printRegion(ScheduleRegion region) {
  llvm::errs() << kDiagPrefix << " region func=" << region.func.getSymName()
               << " block=" << region.blockOrdinal
               << " region=" << region.regionOrdinal
               << " ops=" << region.opCount
               << " first=" << region.first->getName().getStringRef()
               << " last=" << region.last->getName().getStringRef() << "\n";
}

void printOpClasses(ScheduleRegion region, ArchResolution archResolution) {
  for (auto [index, op] : llvm::enumerate(region.ops)) {
    waveamdmachine::SchedClass cls = waveamdmachine::classifyOp(op);
    llvm::errs() << kDiagPrefix << " op func=" << region.func.getSymName()
                 << " region=" << region.regionOrdinal << " index=" << index
                 << " name=" << op->getName().getStringRef()
                 << " class=" << waveamdmachine::getSchedClassName(cls);
    if (archResolution.arch) {
      waveamdmachine::FunctionalUnit fu =
          cls == waveamdmachine::SchedClass::NoInst
              ? waveamdmachine::FunctionalUnit::None
              : waveamdmachine::funit(*archResolution.arch, cls);
      llvm::errs() << " fu=" << waveamdmachine::getFunctionalUnitName(fu)
                   << " latency="
                   << waveamdmachine::getLatency(*archResolution.arch, cls);
    } else {
      llvm::errs() << " arch_fallback=" << archResolution.fallbackReason;
    }
    llvm::errs() << "\n";
  }
}

static void addValueEdges(const ScheduleRegion &region, DependenceGraph &graph,
                          DenseMap<Operation *, unsigned> &nodeForOp) {
  for (auto [dstIndex, op] : llvm::enumerate(region.ops)) {
    for (Value operand : op->getOperands()) {
      Operation *def = operand.getDefiningOp();
      if (!def)
        continue;
      auto it = nodeForOp.find(def);
      if (it == nodeForOp.end())
        continue;
      addEdge(graph, it->second, dstIndex,
              isMemToken(operand) ? EdgeKind::MemToken : EdgeKind::Ssa);
    }
  }
}

static void addLoopCarryEdges(const ScheduleRegion &region,
                              DependenceGraph &graph,
                              DenseMap<Operation *, unsigned> &nodeForOp) {
  Block *block = region.first->getBlock();
  auto loop = dyn_cast<waveamdmachine::UniformLoopOp>(block->getParentOp());
  if (!loop)
    return;
  auto term = dyn_cast<waveamdmachine::ContinueIfOp>(
      loop.getBody().front().getTerminator());
  if (!term)
    return;
  for (Operation *user : region.ops) {
    unsigned userIndex = nodeForOp.lookup(user);
    for (Value operand : user->getOperands()) {
      auto arg = dyn_cast<BlockArgument>(operand);
      if (!arg || arg.getOwner() != block)
        continue;
      unsigned argIndex = arg.getArgNumber();
      if (argIndex >= term.getCarries().size())
        continue;
      Operation *carryDef = term.getCarries()[argIndex].getDefiningOp();
      auto it = nodeForOp.find(carryDef);
      if (it == nodeForOp.end())
        continue;
      addEdge(graph, it->second, userIndex, EdgeKind::LoopCarry,
              /*recurrence=*/true);
    }
  }
}

DependenceGraph buildDependenceGraph(const ScheduleRegion &region) {
  DependenceGraph graph;
  DenseMap<Operation *, unsigned> nodeForOp;
  for (auto [index, op] : llvm::enumerate(region.ops))
    nodeForOp[op] = index;

  addValueEdges(region, graph, nodeForOp);
  addLoopCarryEdges(region, graph, nodeForOp);
  return graph;
}

void printDependences(ScheduleRegion region, const DependenceGraph &graph) {
  llvm::errs() << kDiagPrefix << " deps func=" << region.func.getSymName()
               << " region=" << region.regionOrdinal
               << " nodes=" << region.ops.size()
               << " edges=" << graph.edges.size() << "\n";
  for (const ScheduleEdge &edge : graph.edges) {
    Operation *src = region.ops[edge.src];
    Operation *dst = region.ops[edge.dst];
    llvm::errs() << kDiagPrefix << " edge region=" << region.regionOrdinal
                 << " kind=" << getEdgeKindName(edge.kind);
    if (edge.recurrence)
      llvm::errs() << " recurrence";
    llvm::errs() << " " << edge.src << "->" << edge.dst
                 << " src=" << src->getName().getStringRef()
                 << " dst=" << dst->getName().getStringRef() << "\n";
  }
}

ArchResolution resolveArch(Operation *op) {
  ModuleOp mod = waveamdmachine::findAMDGPUTargetModule(op);
  if (!mod)
    return {nullptr, "missing_target"};

  StringAttr target = mod->getAttrOfType<StringAttr>("waveamdmachine.target");
  std::optional<waveamdmachine::AMDGPUTarget> parsed =
      waveamdmachine::parseAMDGPUTargetAttr(target.getValue());
  if (!parsed)
    return {nullptr, "malformed_target"};

  llvm::AMDGPU::IsaVersion isa = llvm::AMDGPU::getIsaVersion(parsed->chip);
  if (!waveamdmachine::isArchSupported(isa))
    return {nullptr, "unsupported_arch"};
  return {&waveamdmachine::getArchData(isa), {}};
}

static ScoreResult scoreOps(ArrayRef<Operation *> ops,
                            ArchResolution archResolution,
                            const waveamdmachine::EventSimConfig &config) {
  if (!archResolution.arch)
    return {false, 0, 0, archResolution.fallbackReason};

  waveamdmachine::EventSimResult result;
  if (failed(waveamdmachine::simulateEventTimeline(ops, *archResolution.arch,
                                                   config, result)))
    return {false, 0, 0, "simulation_failed"};

  return {true, result.totalCycles, result.issuedOps, {}};
}

static int64_t computeExcess(unsigned pressure, int budget) {
  if (budget < 0)
    return 0;
  return std::max<int64_t>(0, static_cast<int64_t>(pressure) - budget);
}

int64_t getHardExcess(RegisterPressureResult pressure) {
  return pressure.hardVGPRExcess + pressure.hardSGPRExcess;
}

int64_t getCriticalExcess(RegisterPressureResult pressure) {
  return pressure.criticalVGPRExcess + pressure.criticalSGPRExcess;
}

bool hasCriticalBudget(RegisterPressureBudgets budgets) {
  return budgets.criticalVGPR >= 0 || budgets.criticalSGPR >= 0;
}

bool hasHardBudget(RegisterPressureBudgets budgets) {
  return budgets.hardVGPR >= 0 || budgets.hardSGPR >= 0;
}

static bool isValidLatencyOverride(int value) { return value >= -1; }

LogicalResult
configureScheduleModel(Operation *op, int modelWaves, int modelSimds,
                       int modelStartDelay, int modelVmemValueLatency,
                       int modelSmemValueLatency, int modelLdsValueLatency,
                       waveamdmachine::EventSimConfig &modelConfig) {
  if (modelWaves <= 0) {
    op->emitError() << "model-waves must be positive";
    return failure();
  }
  if (modelSimds <= 0) {
    op->emitError() << "model-simds must be positive";
    return failure();
  }
  if (modelStartDelay < 0) {
    op->emitError() << "model-start-delay must be non-negative";
    return failure();
  }
  if (!isValidLatencyOverride(modelVmemValueLatency) ||
      !isValidLatencyOverride(modelSmemValueLatency) ||
      !isValidLatencyOverride(modelLdsValueLatency)) {
    op->emitError() << "model value latencies must be -1 or non-negative";
    return failure();
  }
  modelConfig.waves = modelWaves;
  modelConfig.simds = modelSimds;
  modelConfig.startDelay = modelStartDelay;
  modelConfig.valueLatencies.vmemLoad = modelVmemValueLatency;
  modelConfig.valueLatencies.smemLoad = modelSmemValueLatency;
  modelConfig.valueLatencies.lds = modelLdsValueLatency;
  return success();
}

static LogicalResult validatePressureOptions(Operation *op,
                                             int pressureVgprBudget,
                                             int pressureSgprBudget,
                                             int pressureCriticalVgprBudget,
                                             int pressureCriticalSgprBudget,
                                             int pressureTargetWavesOverride) {
  if (pressureVgprBudget < -1 || pressureSgprBudget < -1 ||
      pressureCriticalVgprBudget < -1 || pressureCriticalSgprBudget < -1) {
    op->emitError() << "pressure budgets must be -1 or non-negative";
    return failure();
  }
  if (pressureTargetWavesOverride < -2) {
    op->emitError()
        << "pressure-target-waves-override must be -2, -1, or non-negative";
    return failure();
  }
  return success();
}

static FailureOr<int>
validateTargetWaves(Operation *op, ArchResolution archResolution,
                    int64_t targetWaves, StringRef sourceName, bool allowZero) {
  if (targetWaves == 0 && allowZero)
    return 0;
  if (targetWaves <= 0 ||
      targetWaves > static_cast<int64_t>(std::numeric_limits<int>::max())) {
    op->emitError() << sourceName << " must be positive";
    return failure();
  }
  if (archResolution.arch && targetWaves > archResolution.arch->wavesPerSIMD) {
    op->emitError() << sourceName << " exceeds target wave capacity";
    return failure();
  }
  return static_cast<int>(targetWaves);
}

static Attribute findTargetWavesAttr(Operation *op) {
  for (Operation *cur = op; cur; cur = cur->getParentOp())
    if (Attribute attr = cur->getAttr(kTargetWavesAttr))
      return attr;
  return {};
}

static FailureOr<int>
resolveScheduleTargetWaves(Operation *op, ArchResolution archResolution,
                           int pressureTargetWavesOverride) {
  if (pressureTargetWavesOverride == -1)
    return -1;
  if (pressureTargetWavesOverride >= 0)
    return validateTargetWaves(op, archResolution, pressureTargetWavesOverride,
                               "pressure-target-waves-override",
                               /*allowZero=*/true);

  Attribute attr = findTargetWavesAttr(op);
  if (!attr)
    return 0;
  auto intAttr = dyn_cast<IntegerAttr>(attr);
  if (!intAttr) {
    op->emitError() << kTargetWavesAttr << " must be an integer attribute";
    return failure();
  }
  return validateTargetWaves(op, archResolution, intAttr.getInt(),
                             kTargetWavesAttr, /*allowZero=*/false);
}

static bool hasPressureOverride(int pressureVgprBudget, int pressureSgprBudget,
                                int pressureCriticalVgprBudget,
                                int pressureCriticalSgprBudget,
                                int pressureTargetWavesOverride) {
  return pressureVgprBudget >= 0 || pressureSgprBudget >= 0 ||
         pressureCriticalVgprBudget >= 0 || pressureCriticalSgprBudget >= 0 ||
         pressureTargetWavesOverride != -2;
}

static int toBudget(unsigned value) {
  return static_cast<int>(
      std::min<unsigned>(value, std::numeric_limits<int>::max()));
}

static unsigned getTargetWavesForBudget(const WaveAMDRegisterLimits &limits,
                                        int targetWaves) {
  if (targetWaves == 0)
    return limits.maxWavesPerEU;
  return static_cast<unsigned>(targetWaves);
}

static bool shouldDeriveCriticalBudgets(Operation *op,
                                        const WaveAMDRegisterLimits &limits,
                                        int targetWaves,
                                        int pressureTargetWavesOverride) {
  if (pressureTargetWavesOverride == -1)
    return false;
  if (pressureTargetWavesOverride >= 0)
    return getTargetWavesForBudget(limits, targetWaves) > 1;

  Attribute attr = findTargetWavesAttr(op);
  if (!attr)
    return false;
  return cast<IntegerAttr>(attr).getInt() > 1;
}

static void deriveHardBudgets(Operation *op,
                              const WaveAMDRegisterLimits &limits,
                              RegisterPressureBudgets &budgets) {
  func::FuncOp func = dyn_cast<func::FuncOp>(op);
  unsigned reservedVGPR = func ? getWaveAMDReservedVGPRs(func) : 0;
  unsigned reservedSGPR = func ? getWaveAMDReservedSGPRs(func) : 0;
  budgets.derivedHardVGPR = toBudget(
      getEffectiveWaveAMDRegisterBudget(limits.addressableVGPRs, reservedVGPR));
  budgets.derivedHardSGPR = toBudget(
      getEffectiveWaveAMDRegisterBudget(limits.addressableSGPRs, reservedSGPR));
}

static void deriveCriticalBudgets(Operation *op,
                                  const WaveAMDRegisterLimits &limits,
                                  int targetWaves,
                                  RegisterPressureBudgets &budgets) {
  if (targetWaves < 0)
    return;
  func::FuncOp func = dyn_cast<func::FuncOp>(op);
  unsigned reservedVGPR = func ? getWaveAMDReservedVGPRs(func) : 0;
  unsigned reservedSGPR = func ? getWaveAMDReservedSGPRs(func) : 0;
  unsigned waves = getTargetWavesForBudget(limits, targetWaves);
  budgets.derivedCriticalVGPR = toBudget(getEffectiveWaveAMDRegisterBudget(
      getMaxWaveAMDRegisterBudgetForWaves(limits.maxVGPRsForWaves, waves),
      reservedVGPR));
  budgets.derivedCriticalSGPR = toBudget(getEffectiveWaveAMDRegisterBudget(
      getMaxWaveAMDRegisterBudgetForWaves(limits.maxSGPRsForWaves, waves),
      reservedSGPR));
}

static void applyPressureOverrides(int pressureVgprBudget,
                                   int pressureSgprBudget,
                                   int pressureCriticalVgprBudget,
                                   int pressureCriticalSgprBudget,
                                   RegisterPressureBudgets &budgets) {
  budgets.hardVGPR =
      pressureVgprBudget >= 0 ? pressureVgprBudget : budgets.derivedHardVGPR;
  budgets.hardSGPR =
      pressureSgprBudget >= 0 ? pressureSgprBudget : budgets.derivedHardSGPR;
  budgets.criticalVGPR = pressureCriticalVgprBudget >= 0
                             ? pressureCriticalVgprBudget
                             : budgets.derivedCriticalVGPR;
  budgets.criticalSGPR = pressureCriticalSgprBudget >= 0
                             ? pressureCriticalSgprBudget
                             : budgets.derivedCriticalSGPR;
}

LogicalResult configureSchedulePressureBudgets(
    Operation *op, ArchResolution archResolution, bool pressureAwareSelection,
    int pressureVgprBudget, int pressureSgprBudget,
    int pressureCriticalVgprBudget, int pressureCriticalSgprBudget,
    int pressureTargetWavesOverride, RegisterPressureBudgets &budgets) {
  if (failed(validatePressureOptions(op, pressureVgprBudget, pressureSgprBudget,
                                     pressureCriticalVgprBudget,
                                     pressureCriticalSgprBudget,
                                     pressureTargetWavesOverride)))
    return failure();
  FailureOr<int> targetWaves = resolveScheduleTargetWaves(
      op, archResolution, pressureTargetWavesOverride);
  if (failed(targetWaves))
    return failure();

  if (archResolution.arch) {
    FailureOr<WaveAMDRegisterLimits> limits = getWaveAMDRegisterLimits(op);
    if (failed(limits))
      return failure();
    deriveHardBudgets(op, *limits, budgets);
    if (shouldDeriveCriticalBudgets(op, *limits, *targetWaves,
                                    pressureTargetWavesOverride))
      deriveCriticalBudgets(op, *limits, *targetWaves, budgets);
  }
  applyPressureOverrides(pressureVgprBudget, pressureSgprBudget,
                         pressureCriticalVgprBudget, pressureCriticalSgprBudget,
                         budgets);
  budgets.reportBudgets =
      pressureAwareSelection ||
      hasPressureOverride(
          pressureVgprBudget, pressureSgprBudget, pressureCriticalVgprBudget,
          pressureCriticalSgprBudget, pressureTargetWavesOverride);
  budgets.selectionEnabled =
      pressureAwareSelection &&
      (hasHardBudget(budgets) || hasCriticalBudget(budgets));
  return success();
}

static unsigned computeMaxPressure(ArrayRef<WaveAMDLiveInterval> intervals,
                                   unsigned firstPos, unsigned lastPos) {
  unsigned maxPressure = 0;
  for (unsigned pos = firstPos; pos <= lastPos; ++pos) {
    unsigned pressure = 0;
    for (const WaveAMDLiveInterval &interval : intervals) {
      if (interval.values.empty())
        continue;
      if (interval.start <= pos && pos <= interval.end)
        pressure += interval.type.getWidth();
    }
    maxPressure = std::max(maxPressure, pressure);
  }
  return maxPressure;
}

static FailureOr<std::pair<unsigned, unsigned>>
getPositionSpan(ArrayRef<Operation *> ops,
                const DenseMap<Operation *, unsigned> &positions) {
  unsigned firstPos = std::numeric_limits<unsigned>::max();
  unsigned lastPos = 0;
  for (Operation *op : ops) {
    auto it = positions.find(op);
    if (it == positions.end())
      return failure();
    firstPos = std::min(firstPos, it->second);
    lastPos = std::max(lastPos, it->second);
  }
  return std::make_pair(firstPos, lastPos);
}

static RegisterPressureResult
computeRegisterPressure(const ScheduleRegion &region,
                        ArrayRef<Operation *> orderedOps,
                        const RegisterPressureBudgets &budgets) {
  WaveAMDLiveIntervalOrderOverride orderOverride;
  orderOverride.block = region.first->getBlock();
  orderOverride.ops = orderedOps;
  FailureOr<WaveAMDLiveIntervalBuildResult> builtIntervals =
      buildWaveAMDLiveIntervals(region.func, orderOverride);
  if (failed(builtIntervals))
    return {false, 0, 0, 0, 0, 0, 0, "pressure_analysis_failed"};

  FailureOr<std::pair<unsigned, unsigned>> span =
      getPositionSpan(orderedOps, builtIntervals->positions);
  if (failed(span))
    return {false, 0, 0, 0, 0, 0, 0, "pressure_position_missing"};

  RegisterPressureResult result;
  result.supported = true;
  result.maxSGPR = computeMaxPressure(builtIntervals->intervals.sgprs,
                                      span->first, span->second);
  result.maxVGPR = computeMaxPressure(builtIntervals->intervals.vgprs,
                                      span->first, span->second);
  result.hardVGPRExcess = computeExcess(result.maxVGPR, budgets.hardVGPR);
  result.hardSGPRExcess = computeExcess(result.maxSGPR, budgets.hardSGPR);
  result.criticalVGPRExcess =
      computeExcess(result.maxVGPR, budgets.criticalVGPR);
  result.criticalSGPRExcess =
      computeExcess(result.maxSGPR, budgets.criticalSGPR);
  return result;
}

CandidateMetrics evaluateOps(const ScheduleRegion &region,
                             ArrayRef<Operation *> ops,
                             ArchResolution archResolution,
                             const waveamdmachine::EventSimConfig &modelConfig,
                             const RegisterPressureBudgets &budgets,
                             PressureEvaluation pressureEvaluation) {
  CandidateMetrics metrics;
  metrics.score = scoreOps(ops, archResolution, modelConfig);
  if (pressureEvaluation == PressureEvaluation::Eager)
    metrics.pressure = computeRegisterPressure(region, ops, budgets);
  return metrics;
}

void printPressure(raw_ostream &os, const RegisterPressureResult &pressure,
                   const RegisterPressureBudgets &budgets) {
  if (!pressure.supported) {
    os << " pressure_fallback=original pressure_reason="
       << pressure.fallbackReason;
    return;
  }
  os << " max_vgpr=" << pressure.maxVGPR << " max_sgpr=" << pressure.maxSGPR;
  if (!budgets.reportBudgets)
    return;
  if (budgets.hardVGPR >= 0)
    os << " vgpr_hard_excess=" << pressure.hardVGPRExcess;
  if (budgets.hardSGPR >= 0)
    os << " sgpr_hard_excess=" << pressure.hardSGPRExcess;
  if (budgets.criticalVGPR >= 0)
    os << " vgpr_critical_excess=" << pressure.criticalVGPRExcess;
  if (budgets.criticalSGPR >= 0)
    os << " sgpr_critical_excess=" << pressure.criticalSGPRExcess;
}

bool shouldReportPressureBudgets(RegisterPressureBudgets budgets) {
  return budgets.reportBudgets &&
         (budgets.hardVGPR >= 0 || budgets.hardSGPR >= 0 ||
          budgets.criticalVGPR >= 0 || budgets.criticalSGPR >= 0 ||
          budgets.derivedHardVGPR >= 0 || budgets.derivedHardSGPR >= 0 ||
          budgets.derivedCriticalVGPR >= 0 || budgets.derivedCriticalSGPR >= 0);
}

static void printBudgetField(raw_ostream &os, StringRef name, int budget,
                             int derived) {
  os << " " << name << "=";
  if (budget >= 0)
    os << budget;
  else
    os << "disabled";
  if (derived >= 0)
    os << " derived_" << name << "=" << derived;
}

void printPressureBudgets(func::FuncOp func,
                          const RegisterPressureBudgets &budgets) {
  if (!shouldReportPressureBudgets(budgets))
    return;
  llvm::errs() << kDiagPrefix << " budgets func=" << func.getSymName();
  printBudgetField(llvm::errs(), "hard_vgpr", budgets.hardVGPR,
                   budgets.derivedHardVGPR);
  printBudgetField(llvm::errs(), "hard_sgpr", budgets.hardSGPR,
                   budgets.derivedHardSGPR);
  printBudgetField(llvm::errs(), "critical_vgpr", budgets.criticalVGPR,
                   budgets.derivedCriticalVGPR);
  printBudgetField(llvm::errs(), "critical_sgpr", budgets.criticalSGPR,
                   budgets.derivedCriticalSGPR);
  llvm::errs() << "\n";
}

static void printScoreLine(ScheduleRegion region, StringRef orderName,
                           CandidateMetrics metrics,
                           const RegisterPressureBudgets &budgets) {
  llvm::errs() << kDiagPrefix << " score func=" << region.func.getSymName()
               << " region=" << region.regionOrdinal << " order=" << orderName;
  if (metrics.score.supported) {
    llvm::errs() << " cycles=" << metrics.score.cycles
                 << " issued_ops=" << metrics.score.issuedOps;
    printPressure(llvm::errs(), metrics.pressure, budgets);
  } else {
    llvm::errs() << " fallback=original reason="
                 << metrics.score.fallbackReason;
  }
  llvm::errs() << "\n";
}

static bool parseScoreOrder(StringRef text, SmallVectorImpl<unsigned> &order) {
  SmallVector<StringRef, 16> pieces;
  text.split(pieces, ',');
  for (StringRef piece : pieces) {
    piece = piece.trim();
    uint64_t index = 0;
    if (piece.empty() || piece.getAsInteger(10, index) ||
        index > std::numeric_limits<unsigned>::max())
      return false;
    order.push_back(static_cast<unsigned>(index));
  }
  return !order.empty();
}

CandidateRequest getCandidateRequest(StringRef orderText, int scoreRegion) {
  CandidateRequest request;
  request.requested = scoreRegion >= 0 || !orderText.empty();
  if (!request.requested)
    return request;
  if (scoreRegion < 0) {
    request.fallbackReason = "candidate_region_missing";
    return request;
  }
  if (!parseScoreOrder(orderText, request.order)) {
    request.fallbackReason = "candidate_order_parse";
    return request;
  }
  request.parsed = true;
  return request;
}

bool shouldScoreCandidate(const ScheduleRegion &region, StringRef scoreFunc,
                          int scoreRegion) {
  if (scoreRegion < 0)
    return false;
  func::FuncOp func = region.func;
  if (!scoreFunc.empty() && func.getSymName() != scoreFunc)
    return false;
  return region.regionOrdinal == static_cast<unsigned>(scoreRegion);
}

static bool buildCandidateOps(const ScheduleRegion &region,
                              const DependenceGraph &graph,
                              ArrayRef<unsigned> order,
                              SmallVectorImpl<Operation *> &ops,
                              StringRef &fallbackReason) {
  if (order.size() != region.ops.size()) {
    fallbackReason = "candidate_order_size";
    return false;
  }

  unsigned unset = std::numeric_limits<unsigned>::max();
  SmallVector<unsigned, 16> position(region.ops.size(), unset);
  ops.reserve(region.ops.size());
  for (unsigned ordinal = 0; ordinal < order.size(); ++ordinal) {
    unsigned index = order[ordinal];
    if (index >= region.ops.size()) {
      fallbackReason = "candidate_order_range";
      return false;
    }
    if (position[index] != unset) {
      fallbackReason = "candidate_order_duplicate";
      return false;
    }
    position[index] = ordinal;
    ops.push_back(region.ops[index]);
  }

  for (const ScheduleEdge &edge : graph.edges) {
    if (edge.recurrence)
      continue;
    if (position[edge.src] > position[edge.dst]) {
      fallbackReason = "candidate_order_breaks_dependency";
      return false;
    }
  }
  return true;
}

CandidateMetrics evaluateCandidateRequest(
    const ScheduleRegion &region, const DependenceGraph &graph,
    const CandidateRequest &candidate, ArchResolution archResolution,
    const waveamdmachine::EventSimConfig &modelConfig,
    const RegisterPressureBudgets &budgets) {
  if (!candidate.parsed)
    return {{false, 0, 0, candidate.fallbackReason}, {}};

  SmallVector<Operation *, 16> candidateOps;
  StringRef fallbackReason;
  if (!buildCandidateOps(region, graph, candidate.order, candidateOps,
                         fallbackReason))
    return {{false, 0, 0, fallbackReason}, {}};

  return evaluateOps(region, candidateOps, archResolution, modelConfig, budgets,
                     PressureEvaluation::Eager);
}

void printRegionScores(const ScheduleRegion &region,
                       const DependenceGraph &graph,
                       ArchResolution archResolution,
                       const waveamdmachine::EventSimConfig &modelConfig,
                       const RegisterPressureBudgets &budgets,
                       const CandidateRequest &candidate, bool scoreCandidate) {
  printScoreLine(region, "original",
                 evaluateOps(region, region.ops, archResolution, modelConfig,
                             budgets, PressureEvaluation::Eager),
                 budgets);
  if (!scoreCandidate)
    return;
  printScoreLine(region, "candidate",
                 evaluateCandidateRequest(region, graph, candidate,
                                          archResolution, modelConfig, budgets),
                 budgets);
}

GraphTables buildGraphTables(const ScheduleRegion &region,
                             const DependenceGraph &graph) {
  GraphTables tables;
  tables.successors.resize(region.ops.size());
  tables.pendingPreds.assign(region.ops.size(), 0);
  for (const ScheduleEdge &edge : graph.edges) {
    if (edge.recurrence)
      continue;
    tables.successors[edge.src].push_back(edge.dst);
    ++tables.pendingPreds[edge.dst];
  }
  for (SmallVector<unsigned, 4> &succs : tables.successors) {
    llvm::sort(succs);
    succs.erase(std::unique(succs.begin(), succs.end()), succs.end());
  }
  return tables;
}

static bool isMemoryIssuer(Operation *op) {
  return op->hasTrait<traits::SMEMLoadOp>() ||
         op->hasTrait<traits::VMEMLoadOp>() ||
         op->hasTrait<traits::VMEMStoreOp>();
}

static bool isMatrixOp(Operation *op) {
  return isa<waveamdmachine::MfmaF32_16x16x16_F16Op,
             waveamdmachine::MfmaF32_16x16x32_F16Op,
             waveamdmachine::WmmaF32_16x16x16_F16Op,
             waveamdmachine::WmmaI32_16x16x16_IU8Op>(op);
}

static int64_t computeCriticalPath(
    unsigned node, ArrayRef<SmallVector<unsigned, 4>> successors,
    ArrayRef<NodeMetrics> metrics, SmallVectorImpl<int64_t> &memo,
    SmallVectorImpl<uint8_t> &state) {
  if (state[node] == 2)
    return memo[node];
  if (state[node] == 1)
    return metrics[node].latency;
  state[node] = 1;
  int64_t best = metrics[node].latency;
  for (unsigned succ : successors[node]) {
    int64_t through =
        metrics[node].latency +
        computeCriticalPath(succ, successors, metrics, memo, state);
    best = std::max(best, through);
  }
  state[node] = 2;
  memo[node] = best;
  return best;
}

static bool computeReachMemory(unsigned node,
                               ArrayRef<SmallVector<unsigned, 4>> successors,
                               SmallVectorImpl<NodeMetrics> &metrics,
                               SmallVectorImpl<uint8_t> &state) {
  if (state[node] == 2)
    return metrics[node].reachesMemory;
  if (state[node] == 1)
    return metrics[node].memory;
  state[node] = 1;
  bool reaches = metrics[node].memory;
  for (unsigned succ : successors[node])
    reaches |= computeReachMemory(succ, successors, metrics, state);
  state[node] = 2;
  metrics[node].reachesMemory = reaches;
  return reaches;
}

static bool computeReachMatrix(unsigned node,
                               ArrayRef<SmallVector<unsigned, 4>> successors,
                               SmallVectorImpl<NodeMetrics> &metrics,
                               SmallVectorImpl<uint8_t> &state) {
  if (state[node] == 2)
    return metrics[node].reachesMatrix;
  if (state[node] == 1)
    return metrics[node].matrix;
  state[node] = 1;
  bool reaches = metrics[node].matrix;
  for (unsigned succ : successors[node])
    reaches |= computeReachMatrix(succ, successors, metrics, state);
  state[node] = 2;
  metrics[node].reachesMatrix = reaches;
  return reaches;
}

SmallVector<NodeMetrics, 16>
computeNodeMetrics(const ScheduleRegion &region, const GraphTables &tables,
                   const waveamdmachine::ArchData &arch,
                   const waveamdmachine::EventSimConfig &modelConfig) {
  SmallVector<NodeMetrics, 16> metrics(region.ops.size());
  for (auto [index, op] : llvm::enumerate(region.ops)) {
    waveamdmachine::SchedClass cls = waveamdmachine::classifyOp(op);
    metrics[index].latency = waveamdmachine::getLatency(arch, cls);
    if (waveamdmachine::hasMemoryValueLatency(op))
      metrics[index].latency = waveamdmachine::getMemoryValueLatency(
          arch, op, modelConfig.valueLatencies);
    metrics[index].memory = isMemoryIssuer(op);
    metrics[index].matrix = isMatrixOp(op);
  }

  SmallVector<int64_t, 16> memo(region.ops.size(), 0);
  SmallVector<uint8_t, 16> state(region.ops.size(), 0);
  for (unsigned index = 0; index < region.ops.size(); ++index)
    metrics[index].criticalPath =
        computeCriticalPath(index, tables.successors, metrics, memo, state);

  state.assign(region.ops.size(), 0);
  for (unsigned index = 0; index < region.ops.size(); ++index)
    computeReachMemory(index, tables.successors, metrics, state);

  state.assign(region.ops.size(), 0);
  for (unsigned index = 0; index < region.ops.size(); ++index)
    computeReachMatrix(index, tables.successors, metrics, state);

  return metrics;
}

int memoryPriority(const NodeMetrics &metrics) {
  if (metrics.memory)
    return 3;
  if (metrics.reachesMemory)
    return 2;
  if (metrics.latency >= 20)
    return 1;
  return 0;
}

int matrixPriority(const NodeMetrics &metrics) {
  if (metrics.reachesMatrix && !metrics.matrix)
    return 3;
  if (metrics.matrix)
    return 2;
  return 0;
}

static bool isBetterReadyNode(SchedulePolicy policy, unsigned lhs, unsigned rhs,
                              ArrayRef<NodeMetrics> metrics) {
  const NodeMetrics &l = metrics[lhs];
  const NodeMetrics &r = metrics[rhs];
  auto betterByCommon = [&]() {
    if (l.criticalPath != r.criticalPath)
      return l.criticalPath > r.criticalPath;
    if (l.latency != r.latency)
      return l.latency > r.latency;
    return lhs < rhs;
  };

  switch (policy) {
  case SchedulePolicy::CriticalPath:
    return betterByCommon();
  case SchedulePolicy::MemoryEarly:
    if (memoryPriority(l) != memoryPriority(r))
      return memoryPriority(l) > memoryPriority(r);
    return betterByCommon();
  case SchedulePolicy::MatrixFeed:
    if (matrixPriority(l) != matrixPriority(r))
      return matrixPriority(l) > matrixPriority(r);
    return betterByCommon();
  }
  llvm_unreachable("unknown schedule policy");
}

bool buildListOrder(const GraphTables &tables, ArrayRef<NodeMetrics> metrics,
                    SchedulePolicy policy, SmallVectorImpl<unsigned> &order) {
  SmallVector<unsigned, 16> pending = tables.pendingPreds;
  SmallVector<unsigned, 16> ready;
  for (auto [index, count] : llvm::enumerate(pending))
    if (count == 0)
      ready.push_back(index);

  while (!ready.empty()) {
    unsigned bestReady = 0;
    for (unsigned i = 1; i < ready.size(); ++i)
      if (isBetterReadyNode(policy, ready[i], ready[bestReady], metrics))
        bestReady = i;

    unsigned node = ready[bestReady];
    ready.erase(ready.begin() + bestReady);
    order.push_back(node);
    for (unsigned succ : tables.successors[node]) {
      assert(pending[succ] > 0 && "successor predecessor count underflow");
      --pending[succ];
      if (pending[succ] == 0)
        ready.push_back(succ);
    }
  }

  return order.size() == pending.size();
}

static SmallVector<unsigned, 16>
getOriginalOrder(const ScheduleRegion &region) {
  SmallVector<unsigned, 16> order;
  for (unsigned i = 0; i < region.ops.size(); ++i)
    order.push_back(i);
  return order;
}

bool sameOrder(ArrayRef<unsigned> lhs, ArrayRef<unsigned> rhs) {
  return lhs.size() == rhs.size() &&
         std::equal(lhs.begin(), lhs.end(), rhs.begin());
}

static void addPolicyCandidate(SmallVectorImpl<OrderCandidate> &candidates,
                               StringRef name, const GraphTables &tables,
                               ArrayRef<NodeMetrics> metrics,
                               SchedulePolicy policy) {
  OrderCandidate candidate;
  candidate.name = name;
  if (!buildListOrder(tables, metrics, policy, candidate.order))
    return;
  for (const OrderCandidate &existing : candidates)
    if (sameOrder(existing.order, candidate.order))
      return;
  candidates.push_back(std::move(candidate));
}

bool isPressureSearchEnabled(const RegisterPressureBudgets &budgets) {
  return budgets.selectionEnabled &&
         (hasHardBudget(budgets) || hasCriticalBudget(budgets));
}

static SmallVector<OrderCandidate, 4> buildScheduleCandidates(
    const ScheduleRegion &region, const DependenceGraph &graph,
    const waveamdmachine::ArchData &arch,
    const waveamdmachine::EventSimConfig &modelConfig,
    const RegisterPressureBudgets &budgets, bool enableBeamSearch) {
  SmallVector<OrderCandidate, 4> candidates;
  candidates.push_back({"original", getOriginalOrder(region)});

  GraphTables tables = buildGraphTables(region, graph);
  SmallVector<NodeMetrics, 16> metrics =
      computeNodeMetrics(region, tables, arch, modelConfig);
  addPolicyCandidate(candidates, "critical_path", tables, metrics,
                     SchedulePolicy::CriticalPath);
  addPolicyCandidate(candidates, "memory_early", tables, metrics,
                     SchedulePolicy::MemoryEarly);
  addPolicyCandidate(candidates, "wmma_feed", tables, metrics,
                     SchedulePolicy::MatrixFeed);
  if (enableBeamSearch)
    addGuidedBeamCandidates(candidates, tables, metrics, region, budgets);
  return candidates;
}

static bool isOriginalOrder(ArrayRef<unsigned> order) {
  for (auto [index, opIndex] : llvm::enumerate(order))
    if (index != opIndex)
      return false;
  return true;
}

static bool isPressureViable(const EvaluatedCandidate &candidate,
                             RegisterPressureBudgets budgets) {
  if (!candidate.metrics.score.supported)
    return false;
  if (!budgets.selectionEnabled)
    return true;
  if (!candidate.metrics.pressure.supported)
    return false;
  return getHardExcess(candidate.metrics.pressure) == 0;
}

static bool computeCandidatePressure(EvaluatedCandidate &candidate,
                                     const ScheduleRegion &region,
                                     const DependenceGraph &graph,
                                     const RegisterPressureBudgets &budgets) {
  if (!candidate.metrics.score.supported)
    return false;
  if (candidate.metrics.pressure.supported)
    return true;

  SmallVector<Operation *, 16> ops;
  StringRef fallbackReason;
  if (!buildCandidateOps(region, graph, candidate.order, ops, fallbackReason)) {
    candidate.metrics.pressure = {false, 0, 0, 0, 0, 0, 0, fallbackReason};
    return false;
  }

  candidate.metrics.pressure = computeRegisterPressure(region, ops, budgets);
  return candidate.metrics.pressure.supported;
}

static bool isBetterScheduleCandidate(const EvaluatedCandidate &candidate,
                                      const EvaluatedCandidate &best,
                                      RegisterPressureBudgets budgets) {
  bool candidateViable = isPressureViable(candidate, budgets);
  bool bestViable = isPressureViable(best, budgets);
  if (candidateViable != bestViable)
    return candidateViable;
  if (!candidateViable)
    return false;
  if (budgets.selectionEnabled && hasCriticalBudget(budgets)) {
    int64_t candidateExcess = getCriticalExcess(candidate.metrics.pressure);
    int64_t bestExcess = getCriticalExcess(best.metrics.pressure);
    if (candidateExcess != bestExcess)
      return candidateExcess < bestExcess;
  }
  return candidate.metrics.score.cycles < best.metrics.score.cycles;
}

static CandidateMetrics evaluateOrderCandidate(
    const ScheduleRegion &region, const DependenceGraph &graph,
    const OrderCandidate &candidate, ArchResolution archResolution,
    const waveamdmachine::EventSimConfig &modelConfig,
    const RegisterPressureBudgets &budgets,
    PressureEvaluation pressureEvaluation) {
  SmallVector<Operation *, 16> ops;
  StringRef fallbackReason;
  if (!buildCandidateOps(region, graph, candidate.order, ops, fallbackReason))
    return {{false, 0, 0, fallbackReason}, {}};
  PressureEvaluation initialPressure =
      pressureEvaluation == PressureEvaluation::LazyHardCap
          ? PressureEvaluation::None
          : pressureEvaluation;
  return evaluateOps(region, ops, archResolution, modelConfig, budgets,
                     initialPressure);
}

static void selectEagerPressureCandidate(ScheduleDecision &decision,
                                         RegisterPressureBudgets budgets) {
  for (unsigned i = 1; i < decision.candidates.size(); ++i)
    if (isBetterScheduleCandidate(decision.candidates[i],
                                  decision.candidates[decision.selected],
                                  budgets))
      decision.selected = i;
}

static void selectLazyHardCapCandidate(ScheduleDecision &decision,
                                       const ScheduleRegion &region,
                                       const DependenceGraph &graph,
                                       RegisterPressureBudgets budgets) {
  SmallVector<unsigned, 16> indices;
  for (auto [index, candidate] : llvm::enumerate(decision.candidates))
    if (candidate.metrics.score.supported)
      indices.push_back(index);
  llvm::stable_sort(indices, [&](unsigned lhs, unsigned rhs) {
    int64_t lhsCycles = decision.candidates[lhs].metrics.score.cycles;
    int64_t rhsCycles = decision.candidates[rhs].metrics.score.cycles;
    if (lhsCycles != rhsCycles)
      return lhsCycles < rhsCycles;
    return lhs < rhs;
  });

  decision.selected = 0;
  for (unsigned index : indices) {
    EvaluatedCandidate &candidate = decision.candidates[index];
    computeCandidatePressure(candidate, region, graph, budgets);
    if (isPressureViable(candidate, budgets)) {
      decision.selected = index;
      return;
    }
  }
}

static void selectScheduleCandidate(ScheduleDecision &decision,
                                    const ScheduleRegion &region,
                                    const DependenceGraph &graph,
                                    RegisterPressureBudgets budgets,
                                    PressureEvaluation pressureEvaluation) {
  switch (pressureEvaluation) {
  case PressureEvaluation::None:
  case PressureEvaluation::Eager:
    selectEagerPressureCandidate(decision, budgets);
    return;
  case PressureEvaluation::LazyHardCap:
    selectLazyHardCapCandidate(decision, region, graph, budgets);
    return;
  }
  llvm_unreachable("unknown pressure evaluation mode");
}

ScheduleDecision evaluateScheduleCandidates(
    const ScheduleRegion &region, const DependenceGraph &graph,
    ArchResolution archResolution,
    const waveamdmachine::EventSimConfig &modelConfig,
    const RegisterPressureBudgets &budgets, bool enableBeamSearch,
    PressureEvaluation pressureEvaluation) {
  ScheduleDecision decision;
  if (!archResolution.arch) {
    decision.candidates.push_back(
        {"original",
         getOriginalOrder(region),
         {{false, 0, 0, archResolution.fallbackReason}, {}}});
    return decision;
  }

  SmallVector<OrderCandidate, 4> candidates =
      buildScheduleCandidates(region, graph, *archResolution.arch, modelConfig,
                              budgets, enableBeamSearch);
  for (const OrderCandidate &candidate : candidates)
    decision.candidates.push_back(
        {candidate.name, candidate.order,
         evaluateOrderCandidate(region, graph, candidate, archResolution,
                                modelConfig, budgets, pressureEvaluation)});

  selectScheduleCandidate(decision, region, graph, budgets, pressureEvaluation);
  return decision;
}

void printOrder(raw_ostream &os, ArrayRef<unsigned> order) {
  for (auto [index, opIndex] : llvm::enumerate(order)) {
    if (index != 0)
      os << ",";
    os << opIndex;
  }
}

void printCandidateDiagnostics(ScheduleRegion region,
                               const ScheduleDecision &decision,
                               const RegisterPressureBudgets &budgets) {
  ScoreResult original = decision.candidates.front().metrics.score;
  for (const EvaluatedCandidate &candidate : decision.candidates) {
    llvm::errs() << kDiagPrefix
                 << " candidate func=" << region.func.getSymName()
                 << " region=" << region.regionOrdinal
                 << " name=" << candidate.name;
    if (candidate.metrics.score.supported) {
      llvm::errs() << " cycles=" << candidate.metrics.score.cycles;
      if (original.supported)
        llvm::errs() << " delta="
                     << candidate.metrics.score.cycles - original.cycles;
      llvm::errs() << " issued_ops=" << candidate.metrics.score.issuedOps;
      printPressure(llvm::errs(), candidate.metrics.pressure, budgets);
    } else {
      llvm::errs() << " fallback=original reason="
                   << candidate.metrics.score.fallbackReason;
    }
    llvm::errs() << " order=";
    printOrder(llvm::errs(), candidate.order);
    llvm::errs() << "\n";
  }
}

void printScheduleDecision(ScheduleRegion region,
                           const ScheduleDecision &decision, bool willApply) {
  const EvaluatedCandidate &selected = decision.candidates[decision.selected];
  ScoreResult original = decision.candidates.front().metrics.score;
  llvm::errs() << kDiagPrefix << " selected func=" << region.func.getSymName()
               << " region=" << region.regionOrdinal
               << " name=" << selected.name;
  if (selected.metrics.score.supported) {
    llvm::errs() << " original_cycles=" << original.cycles
                 << " selected_cycles=" << selected.metrics.score.cycles
                 << " delta="
                 << selected.metrics.score.cycles - original.cycles;
  } else {
    llvm::errs() << " fallback=original reason="
                 << selected.metrics.score.fallbackReason;
  }
  llvm::errs() << " action=" << (willApply ? "apply" : "keep") << " order=";
  printOrder(llvm::errs(), selected.order);
  llvm::errs() << "\n";
}

bool shouldApplyDecision(const ScheduleDecision &decision,
                         RegisterPressureBudgets budgets) {
  if (decision.candidates.empty() || decision.selected == 0)
    return false;
  const EvaluatedCandidate &original = decision.candidates.front();
  const EvaluatedCandidate &selected = decision.candidates[decision.selected];
  return isBetterScheduleCandidate(selected, original, budgets) &&
         !isOriginalOrder(selected.order);
}

void applyScheduleOrder(const ScheduleRegion &region,
                        ArrayRef<unsigned> order) {
  Operation *insertBefore = region.last->getNextNode();
  Block *block = region.last->getBlock();
  for (unsigned index : llvm::reverse(order)) {
    Operation *op = region.ops[index];
    if (insertBefore)
      op->moveBefore(insertBefore);
    else
      op->moveBefore(block, block->end());
    insertBefore = op;
  }
}

} // namespace mlir::wave
