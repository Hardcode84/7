//===- WaveAMDMachineScheduleSupport.cpp - Scheduler support --------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "WaveAMDMachineScheduleSupport.h"

#include "RegAlloc/WaveAMDRegLiveIntervals.h"
#include "RegAlloc/WaveAMDRegisterLimits.h"
#include "WaveAMDHardwareResources.h"
#include "WaveAMDMachineScheduleInternal.h"
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
#include "llvm/ADT/SmallPtrSet.h"
#include "llvm/Support/Error.h"
#include "llvm/TargetParser/TargetParser.h"

#include <algorithm>
#include <array>
#include <limits>
#include <optional>

using namespace mlir;

namespace mlir::wave {

namespace traits = ::mlir::OpTrait::waveamdmachine;
static constexpr StringLiteral kDiagPrefix = "waveamd-machine-schedule-report";
static constexpr StringLiteral kTargetWavesAttr = "waveamdmachine.target_waves";

static bool isMemoryIssuer(Operation *op);
static unsigned getIssueCount(Operation *op);

static bool isWaveAMDMachineOp(Operation *op) {
  return op->getName().getDialectNamespace() ==
         waveamdmachine::WaveAMDMachineDialect::getDialectNamespace();
}

static int getModelLatency(const waveamdmachine::ArchData &arch,
                           waveamdmachine::SchedClass cls,
                           const waveamdmachine::EventSimConfig &modelConfig) {
  if (!modelConfig.calibration)
    return waveamdmachine::getLatency(arch, cls);
  return waveamdmachine::getCalibratedLatency(arch, cls,
                                              *modelConfig.calibration);
}

static bool isKnownMemoryOp(Operation *op) {
  if (auto info = dyn_cast<waveamdmachine::WaitcntInfoOpInterface>(op))
    return info.getWaitcntInfo().isIssuer();
  return false;
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

static bool isInstructionOp(Operation *op) {
  return waveamdmachine::classifyOp(op) != waveamdmachine::SchedClass::NoInst;
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
          waveamdmachine::SAndSaveexecB64Op, waveamdmachine::SAndn2ExecB64Op,
          waveamdmachine::SMovExecLoOp, waveamdmachine::SMovExecB64Op,
          waveamdmachine::SEndpgmOp, waveamdmachine::SSetpcB64Op>(op))
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
  case EdgeKind::Flag:
    return "flag";
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
    region.instructionOpCount =
        llvm::count_if(ops, [](Operation *op) { return isInstructionOp(op); });
    region.ops.append(ops.begin(), ops.end());
    regions.push_back(std::move(region));
    ops.clear();
  }

  void collectNested(Operation &op) {
    if (auto loop = dyn_cast<waveamdmachine::UniformLoopOp>(op)) {
      for (Block &nested : loop.getBody())
        collectBlock(nested);
      return;
    }
    if (auto uniformIf = dyn_cast<waveamdmachine::UniformIfOp>(op)) {
      for (Block &nested : uniformIf.getThenRegion())
        collectBlock(nested);
      for (Block &nested : uniformIf.getElseRegion())
        collectBlock(nested);
      return;
    }
    if (auto execIf = dyn_cast<waveamdmachine::ExecIfOp>(op)) {
      for (Block &nested : execIf.getThenRegion())
        collectBlock(nested);
      for (Block &nested : execIf.getElseRegion())
        collectBlock(nested);
      return;
    }
  }

  void collectBlock(Block &block) {
    unsigned blockOrdinal = nextBlock++;
    SmallVector<Operation *, 16> ops;
    for (Operation &op : block) {
      if (isHardBoundary(&op)) {
        flush(ops, blockOrdinal);
        collectNested(op);
        continue;
      }
      ops.push_back(&op);
    }
    flush(ops, blockOrdinal);
  }

  SmallVector<ScheduleRegion> regions;
  func::FuncOp func;
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
               << " instruction_ops=" << region.instructionOpCount
               << " first=" << region.first->getName().getStringRef()
               << " last=" << region.last->getName().getStringRef() << "\n";
}

bool exceedsScheduleRegionLimit(ScheduleRegion region,
                                ScheduleSearchLimits limits) {
  return limits.maxRegionOps >= 0 &&
         region.opCount > static_cast<unsigned>(limits.maxRegionOps);
}

static LogicalResult readScheduleLimitAttr(func::FuncOp func,
                                           StringRef attrName, int64_t &limit) {
  Attribute attr = func->getAttr(attrName);
  if (!attr)
    return success();
  auto intAttr = dyn_cast<IntegerAttr>(attr);
  if (!intAttr)
    return func.emitError() << attrName << " must be an integer attribute";
  int64_t value = intAttr.getInt();
  if (value < -1)
    return func.emitError() << attrName << " must be -1 or non-negative";
  limit = value;
  return success();
}

LogicalResult
applyFunctionScheduleSearchLimitOverrides(func::FuncOp func,
                                          ScheduleSearchLimits &limits) {
  int64_t maxBeamWork = limits.maxBeamWork;
  int64_t maxRegionOps = limits.maxRegionOps;
  if (failed(readScheduleLimitAttr(
          func, "waveamdmachine.schedule_max_beam_work", maxBeamWork)))
    return failure();
  if (failed(readScheduleLimitAttr(
          func, "waveamdmachine.schedule_max_region_ops", maxRegionOps)))
    return failure();
  if (maxRegionOps > std::numeric_limits<int>::max())
    return func.emitError()
           << "waveamdmachine.schedule_max_region_ops is too large";
  limits.maxBeamWork = maxBeamWork;
  limits.maxRegionOps = static_cast<int>(maxRegionOps);
  return success();
}

void printScheduleRegionLimitSkip(ScheduleRegion region,
                                  ScheduleSearchLimits limits) {
  llvm::errs() << kDiagPrefix << " skipped func=" << region.func.getSymName()
               << " region=" << region.regionOrdinal << " reason=max_region_ops"
               << " ops=" << region.opCount
               << " instruction_ops=" << region.instructionOpCount
               << " limit=" << limits.maxRegionOps << "\n";
}

void emitScheduleRegionLimitRemark(ScheduleRegion region,
                                   ScheduleSearchLimits limits) {
  region.first->emitRemark()
      << "skipped WaveAMDMachine scheduling region: reason=max_region_ops"
      << " ops=" << region.opCount
      << " instruction_ops=" << region.instructionOpCount
      << " limit=" << limits.maxRegionOps;
}

void emitScheduleBeamWorkRemark(ScheduleRegion region, int64_t estimatedWork,
                                ScheduleSearchLimits limits) {
  region.first->emitRemark()
      << "skipped WaveAMDMachine beam search: reason=max_beam_work"
      << " estimated_work=" << estimatedWork << " limit=" << limits.maxBeamWork;
}

void printOpClasses(ScheduleRegion region, ArchResolution archResolution,
                    const waveamdmachine::EventSimConfig &modelConfig) {
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
                   << getModelLatency(*archResolution.arch, cls, modelConfig);
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

static void addHardwareResourceEdges(const ScheduleRegion &region,
                                     DependenceGraph &graph) {
  DenseMap<unsigned, unsigned> lastWriter;
  DenseMap<unsigned, SmallVector<unsigned, 4>> readers;
  for (auto [index, op] : llvm::enumerate(region.ops)) {
    wave::HardwareResourceEffects effects =
        wave::getHardwareResourceEffects(op);
    for (wave::HardwareResourceKind kind : effects.reads)
      readers[static_cast<unsigned>(kind)].push_back(index);
    for (wave::HardwareResourceKind kind : effects.writes) {
      unsigned key = static_cast<unsigned>(kind);
      if (DenseMap<unsigned, unsigned>::iterator it = lastWriter.find(key);
          it != lastWriter.end())
        addEdge(graph, it->second, index, EdgeKind::Flag);
      for (unsigned reader : readers[key])
        addEdge(graph, reader, index, EdgeKind::Flag);
      readers[key].clear();
      lastWriter[key] = index;
    }
  }
}

static Operation *
resolveLoopCarryDef(Value value, Block *body,
                    waveamdmachine::ContinueIfOp terminator,
                    llvm::SmallPtrSetImpl<BlockArgument> &seenArgs) {
  if (Operation *def = value.getDefiningOp())
    return def;
  BlockArgument arg = dyn_cast<BlockArgument>(value);
  if (!arg || arg.getOwner() != body)
    return nullptr;
  if (!seenArgs.insert(arg).second)
    return nullptr;
  unsigned argIndex = arg.getArgNumber();
  if (argIndex >= terminator.getCarries().size())
    return nullptr;
  return resolveLoopCarryDef(terminator.getCarries()[argIndex], body,
                             terminator, seenArgs);
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
      llvm::SmallPtrSet<BlockArgument, 4> seenArgs;
      Operation *carryDef = resolveLoopCarryDef(term.getCarries()[argIndex],
                                                block, term, seenArgs);
      if (!carryDef)
        continue;
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
  addHardwareResourceEdges(region, graph);
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

static ScoreResult makeUnsupportedScore(StringRef fallbackReason) {
  ScoreResult result;
  result.fallbackReason = fallbackReason;
  return result;
}

static CandidateMetrics makeUnsupportedCandidateMetrics(StringRef reason) {
  CandidateMetrics metrics;
  metrics.score = makeUnsupportedScore(reason);
  return metrics;
}

struct ScheduleHazardState {
  DenseMap<Value, unsigned> mfmaResults;
};

struct ScheduleHazardConfig {
  llvm::AMDGPU::IsaVersion isaVersion;
};

static bool isCDNA3Family(const llvm::AMDGPU::IsaVersion &isa) {
  return isa.Major == 9 && isa.Minor == 4;
}

static bool isCDNA4Family(const llvm::AMDGPU::IsaVersion &isa) {
  return isa.Major == 9 && isa.Minor == 5;
}

static ScheduleHazardConfig
makeScheduleHazardConfig(const waveamdmachine::ArchData &arch) {
  return {/*isaVersion=*/arch.isa};
}

static void advanceValueHazards(ScheduleHazardState &state,
                                unsigned count = 1) {
  if (count == 0)
    return;
  SmallVector<Value, 8> expired;
  for (auto &entry : state.mfmaResults) {
    entry.second = entry.second > count ? entry.second - count : 0;
    if (entry.second == 0)
      expired.push_back(entry.first);
  }
  for (Value value : expired)
    state.mfmaResults.erase(value);
}

static void advanceScheduleHazards(ScheduleHazardState &state,
                                   unsigned count = 1) {
  advanceValueHazards(state, count);
}

static void mergeMfmaResultHazard(ScheduleHazardState &state, Value value,
                                  unsigned remaining) {
  if (remaining == 0)
    return;
  unsigned &existing = state.mfmaResults[value];
  existing = std::max(existing, remaining);
}

static void inheritNoInstValueHazards(Operation *op,
                                      ScheduleHazardState &state) {
  if (isInstructionOp(op) || op->getNumResults() == 0)
    return;
  unsigned wait = 0;
  for (Value operand : op->getOperands())
    wait = std::max(wait, state.mfmaResults.lookup(operand));
  for (Value result : op->getResults())
    mergeMfmaResultHazard(state, result, wait);
}

static bool isMFMA(Operation *op) { return op->hasTrait<traits::MFMAOp>(); }

static unsigned getMfmaPassCount(Operation *op) {
  switch (waveamdmachine::classifyOp(op)) {
  case waveamdmachine::SchedClass::Write2PassMAI:
    return 2;
  case waveamdmachine::SchedClass::Write4PassMAI:
    return 4;
  case waveamdmachine::SchedClass::Write8PassMAI:
    return 8;
  case waveamdmachine::SchedClass::Write16PassMAI:
    return 16;
  default:
    op->emitError("MFMA op lacks MAI schedule class");
    llvm::report_fatal_error("MFMA op lacks MAI schedule class");
  }
}

static unsigned getXdlResultLatency(unsigned passes,
                                    const ScheduleHazardConfig &cfg) {
  if (isCDNA3Family(cfg.isaVersion))
    return passes + 3;
  if (isCDNA4Family(cfg.isaVersion))
    return passes + 3 + (passes != 2);
  return 8;
}

static bool isLegacyVALU(Operation *op) {
  return op->hasTrait<traits::VALUOp>() && !isMFMA(op);
}

static bool isVMEM(Operation *op) {
  return op->hasTrait<traits::VMEMLoadOp>() ||
         op->hasTrait<traits::VMEMStoreOp>();
}

static waveamdmachine::WaitcntInfo getWaitcntInfo(Operation *op) {
  if (waveamdmachine::WaitcntInfoOpInterface info =
          dyn_cast<waveamdmachine::WaitcntInfoOpInterface>(op))
    return info.getWaitcntInfo();
  return {};
}

static bool issuesLdsWaitcnt(Operation *op) {
  return getWaitcntInfo(op).event == waveamdmachine::WaitcntEvent::Lds;
}

static bool isMfmaResultHazardConsumer(Operation *op) {
  return isVMEM(op) || issuesLdsWaitcnt(op) || isLegacyVALU(op);
}

static unsigned getRequiredValueWait(Operation *op,
                                     const ScheduleHazardState &state) {
  if (!isMfmaResultHazardConsumer(op))
    return 0;
  unsigned wait = 0;
  for (Value operand : op->getOperands())
    wait = std::max(wait, state.mfmaResults.lookup(operand));
  return wait;
}

static void addProducedMfmaValueHazards(Operation *op,
                                        ScheduleHazardState &state,
                                        const ScheduleHazardConfig &cfg) {
  if (!isMFMA(op))
    return;
  unsigned resultLatency = getXdlResultLatency(getMfmaPassCount(op), cfg);
  for (Value result : op->getResults())
    mergeMfmaResultHazard(state, result, resultLatency);
}

static void transferScheduleHazards(Operation *op, ScheduleHazardState &state,
                                    const ScheduleHazardConfig &cfg) {
  if (isInstructionOp(op))
    advanceScheduleHazards(state);
  inheritNoInstValueHazards(op, state);
  addProducedMfmaValueHazards(op, state, cfg);
}

static int64_t estimateHazardWaitCycles(ArrayRef<Operation *> ops,
                                        const waveamdmachine::ArchData &arch) {
  ScheduleHazardConfig cfg = makeScheduleHazardConfig(arch);
  ScheduleHazardState state;
  int64_t cycles = 0;
  for (Operation *op : ops) {
    unsigned wait = getRequiredValueWait(op, state);
    cycles += wait;
    advanceScheduleHazards(state, wait);
    transferScheduleHazards(op, state, cfg);
  }
  return cycles;
}

static ScoreResult scoreOps(ArrayRef<Operation *> ops,
                            ArchResolution archResolution,
                            const waveamdmachine::EventSimConfig &config) {
  if (!archResolution.arch)
    return makeUnsupportedScore(archResolution.fallbackReason);

  waveamdmachine::EventSimResult result;
  if (failed(waveamdmachine::simulateEventTimeline(ops, *archResolution.arch,
                                                   config, result)))
    return makeUnsupportedScore("simulation_failed");

  ScoreResult score;
  score.cycles = result.totalCycles;
  score.issuedOps = result.issuedOps;
  score.supported = true;
  return score;
}

static bool isNonDmaCmaIssueOp(Operation *op) {
  waveamdmachine::SchedClass cls = waveamdmachine::classifyOp(op);
  unsigned issueCount = getIssueCount(op);
  return !waveamdmachine::isLdsDmaIssuer(op) &&
         waveamdmachine::getEventSimCmaIssueCount(op, cls, issueCount) > 0;
}

static bool isCounterBurstProducer(Operation *op) {
  return waveamdmachine::isLdsDmaIssuer(op) ||
         op->hasTrait<traits::LDSLoadOp>();
}

static int64_t
computeCounterBurstCycles(ArrayRef<Operation *> ops,
                          const waveamdmachine::ArchData &arch,
                          const waveamdmachine::EventSimConfig &config) {
  int64_t current = 0;
  int64_t worst = 0;
  bool sawCma = false;
  bool sawCounterBurstProducer = false;
  unsigned capacity = waveamdmachine::getEventSimCmaIssueCapacity(arch);
  for (Operation *op : ops) {
    if (isCounterBurstProducer(op)) {
      sawCounterBurstProducer = true;
      int latency = waveamdmachine::getMemoryCounterLatency(
          arch, op, config.counterLatencies, config.calibration);
      int64_t clamped = std::max(latency, 0);
      current += (clamped + capacity - 1) / capacity;
      continue;
    }
    if (isNonDmaCmaIssueOp(op)) {
      sawCma = true;
      worst = std::max(worst, current);
      current = 0;
      continue;
    }
    if (isMemoryIssuer(op)) {
      worst = std::max(worst, current);
      current = 0;
    }
  }
  worst = std::max(worst, current);
  if (!sawCma || !sawCounterBurstProducer)
    return 0;
  return worst;
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
  if (modelWaves < 0) {
    op->emitError() << "model-waves must be non-negative";
    return failure();
  }
  if (modelSimds < 0) {
    op->emitError() << "model-simds must be non-negative";
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
  modelConfig.completePendingLdsDmaCounters = true;
  modelConfig.ldsDmaIssueInterval = -1;
  modelConfig.cmaIssueInterval = -1;
  return success();
}

LogicalResult loadScheduleCalibration(
    Operation *op, StringRef calibrationFile,
    std::optional<waveamdmachine::CalibrationData> &calibration) {
  if (calibrationFile.empty())
    return success();
  llvm::Expected<waveamdmachine::CalibrationData> loaded =
      waveamdmachine::CalibrationData::loadFromFile(calibrationFile);
  if (!loaded)
    return op->emitError("failed to load calibration: ")
           << llvm::toString(loaded.takeError());
  calibration = std::move(*loaded);
  return success();
}

LogicalResult
validateScheduleCalibration(Operation *op, ArchResolution archResolution,
                            const waveamdmachine::EventSimConfig &modelConfig) {
  if (!modelConfig.calibration || !archResolution.arch)
    return success();
  if (modelConfig.calibration->matchesArch(*archResolution.arch))
    return success();
  return op->emitError("calibration arch ")
         << modelConfig.calibration->arch << " does not match target "
         << archResolution.arch->name;
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

LogicalResult
finalizeScheduleModel(Operation *op, ArchResolution archResolution,
                      waveamdmachine::EventSimConfig &modelConfig) {
  if (modelConfig.waves > 0 && modelConfig.simds > 0)
    return success();

  int simds = modelConfig.simds;
  if (simds == 0)
    simds = archResolution.arch ? archResolution.arch->simdsPerCU : 1;

  int waves = modelConfig.waves;
  if (waves == 0) {
    Attribute attr = findTargetWavesAttr(op);
    if (attr && archResolution.arch) {
      auto intAttr = dyn_cast<IntegerAttr>(attr);
      if (!intAttr) {
        op->emitError() << kTargetWavesAttr << " must be an integer attribute";
        return failure();
      }
      FailureOr<int> targetWaves =
          validateTargetWaves(op, archResolution, intAttr.getInt(),
                              kTargetWavesAttr, /*allowZero=*/false);
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
        pressure += getWaveAMDLiveIntervalWidthAt(interval, pos);
    }
    maxPressure = std::max(maxPressure, pressure);
  }
  return maxPressure;
}

struct SchedulePressureRegionContext {
  SmallVector<unsigned, 32> sgprGroups;
  SmallVector<unsigned, 32> vgprGroups;
  StringRef fallbackReason;
  const SchedulePressureContext *funcContext = nullptr;
  unsigned firstPos = 0;
  unsigned lastPos = 0;
  bool supported = false;
};

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

static bool overlaps(unsigned start, unsigned end, unsigned firstPos,
                     unsigned lastPos) {
  return start <= lastPos && firstPos <= end;
}

static void collectOverlappingGroups(ArrayRef<WaveAMDLiveInterval> intervals,
                                     unsigned firstPos, unsigned lastPos,
                                     SmallVectorImpl<unsigned> &groups) {
  for (auto [index, interval] : llvm::enumerate(intervals)) {
    if (interval.values.empty())
      continue;
    if (overlaps(interval.start, interval.end, firstPos, lastPos))
      groups.push_back(index);
  }
}

SchedulePressureContext buildSchedulePressureContext(func::FuncOp func) {
  SchedulePressureContext context;
  FailureOr<WaveAMDLiveIntervalBuildResult> builtIntervals =
      buildAllocatedWaveAMDLiveIntervals(func);
  if (failed(builtIntervals)) {
    context.fallbackReason = "pressure_analysis_failed";
    return context;
  }
  context.intervals = std::move(*builtIntervals);
  context.supported = true;
  return context;
}

static SchedulePressureRegionContext
buildSchedulePressureRegionContext(const ScheduleRegion &region,
                                   const SchedulePressureContext *funcContext) {
  SchedulePressureRegionContext context;
  if (!funcContext) {
    context.fallbackReason = "pressure_analysis_failed";
    return context;
  }
  if (!funcContext->supported) {
    context.fallbackReason = funcContext->fallbackReason;
    return context;
  }
  context.funcContext = funcContext;
  FailureOr<std::pair<unsigned, unsigned>> span =
      getPositionSpan(region.ops, funcContext->intervals.positions);
  if (failed(span)) {
    context.fallbackReason = "pressure_position_missing";
    return context;
  }
  context.firstPos = span->first;
  context.lastPos = span->second;
  collectOverlappingGroups(funcContext->intervals.intervals.sgprs,
                           context.firstPos, context.lastPos,
                           context.sgprGroups);
  collectOverlappingGroups(funcContext->intervals.intervals.vgprs,
                           context.firstPos, context.lastPos,
                           context.vgprGroups);
  context.supported = true;
  return context;
}

static unsigned
computePressureUpperBound(ArrayRef<WaveAMDLiveInterval> intervals,
                          ArrayRef<unsigned> groups) {
  unsigned pressure = 0;
  for (unsigned index : groups)
    pressure += intervals[index].type.getWidth();
  return pressure;
}

static RegisterPressureResult
makeRegisterPressureResult(unsigned maxVGPR, unsigned maxSGPR,
                           const RegisterPressureBudgets &budgets,
                           bool conservative) {
  RegisterPressureResult result;
  result.supported = true;
  result.maxSGPR = maxSGPR;
  result.maxVGPR = maxVGPR;
  result.hardVGPRExcess = computeExcess(result.maxVGPR, budgets.hardVGPR);
  result.hardSGPRExcess = computeExcess(result.maxSGPR, budgets.hardSGPR);
  result.criticalVGPRExcess =
      computeExcess(result.maxVGPR, budgets.criticalVGPR);
  result.criticalSGPRExcess =
      computeExcess(result.maxSGPR, budgets.criticalSGPR);
  result.conservative = conservative;
  return result;
}

static RegisterPressureResult
makeUnsupportedRegisterPressureResult(StringRef fallbackReason) {
  RegisterPressureResult result;
  result.fallbackReason = fallbackReason;
  return result;
}

static std::optional<RegisterPressureResult>
getSafePressureUpperBound(const SchedulePressureRegionContext &context,
                          const RegisterPressureBudgets &budgets) {
  if (!context.supported)
    return std::nullopt;
  const WaveAMDLiveIntervalBuildResult &intervals =
      context.funcContext->intervals;
  RegisterPressureResult result = makeRegisterPressureResult(
      computePressureUpperBound(intervals.intervals.vgprs, context.vgprGroups),
      computePressureUpperBound(intervals.intervals.sgprs, context.sgprGroups),
      budgets, /*conservative=*/true);
  if (getHardExcess(result) != 0 || getCriticalExcess(result) != 0)
    return std::nullopt;
  return result;
}

static RegisterPressureResult
computeRegisterPressureFull(const ScheduleRegion &region,
                            ArrayRef<Operation *> orderedOps,
                            const RegisterPressureBudgets &budgets) {
  WaveAMDLiveIntervalOrderOverride orderOverride;
  orderOverride.block = region.first->getBlock();
  orderOverride.ops = orderedOps;
  FailureOr<WaveAMDLiveIntervalBuildResult> builtIntervals =
      buildAllocatedWaveAMDLiveIntervals(region.func, orderOverride);
  if (failed(builtIntervals))
    return makeUnsupportedRegisterPressureResult("pressure_analysis_failed");

  FailureOr<std::pair<unsigned, unsigned>> span =
      getPositionSpan(orderedOps, builtIntervals->positions);
  if (failed(span))
    return makeUnsupportedRegisterPressureResult("pressure_position_missing");

  return makeRegisterPressureResult(
      computeMaxPressure(builtIntervals->intervals.vgprs, span->first,
                         span->second),
      computeMaxPressure(builtIntervals->intervals.sgprs, span->first,
                         span->second),
      budgets, /*conservative=*/false);
}

struct PressureGroupRef {
  unsigned index = 0;
  bool sgpr = false;
};

struct LocalPressureBounds {
  unsigned start = std::numeric_limits<unsigned>::max();
  unsigned end = 0;
};

static std::optional<PressureGroupRef>
findPressureGroup(const SchedulePressureContext &context, Value value) {
  std::optional<waveamdmachine::RegType> type = getTrackedWaveAMDRegType(value);
  if (!type)
    return std::nullopt;
  if (isWaveAMDSGPR(*type)) {
    auto it = context.intervals.intervals.sgprIntervals.find(value);
    if (it == context.intervals.intervals.sgprIntervals.end())
      return std::nullopt;
    return PressureGroupRef{it->second, true};
  }
  auto it = context.intervals.intervals.vgprIntervals.find(value);
  if (it == context.intervals.intervals.vgprIntervals.end())
    return std::nullopt;
  return PressureGroupRef{it->second, false};
}

static void markPressureStart(LocalPressureBounds &bounds, unsigned pos) {
  bounds.start = std::min(bounds.start, pos);
  bounds.end = std::max(bounds.end, pos);
}

static void markPressureEnd(LocalPressureBounds &bounds, unsigned pos) {
  bounds.end = std::max(bounds.end, pos);
}

static LocalPressureBounds &
getPressureBounds(PressureGroupRef group,
                  SmallVectorImpl<LocalPressureBounds> &sgprBounds,
                  SmallVectorImpl<LocalPressureBounds> &vgprBounds) {
  return group.sgpr ? sgprBounds[group.index] : vgprBounds[group.index];
}

static void
initializeBoundaryPressure(ArrayRef<WaveAMDLiveInterval> intervals,
                           ArrayRef<unsigned> groups, unsigned firstPos,
                           unsigned lastPos,
                           SmallVectorImpl<LocalPressureBounds> &bounds) {
  for (unsigned index : groups) {
    const WaveAMDLiveInterval &interval = intervals[index];
    if (interval.start < firstPos &&
        isWaveAMDLiveIntervalLiveAt(interval, firstPos))
      markPressureStart(bounds[index], firstPos);
    if (lastPos < interval.end &&
        isWaveAMDLiveIntervalLiveAt(interval, lastPos))
      markPressureEnd(bounds[index], lastPos);
  }
}

static unsigned computeLocalMaxPressure(ArrayRef<WaveAMDLiveInterval> intervals,
                                        ArrayRef<unsigned> groups,
                                        ArrayRef<LocalPressureBounds> bounds,
                                        unsigned firstPos, unsigned lastPos) {
  unsigned maxPressure = 0;
  for (unsigned pos = firstPos; pos <= lastPos; ++pos) {
    unsigned pressure = 0;
    for (unsigned index : groups) {
      const LocalPressureBounds &bound = bounds[index];
      if (bound.start <= pos && pos <= bound.end)
        pressure += intervals[index].type.getWidth();
    }
    maxPressure = std::max(maxPressure, pressure);
  }
  return maxPressure;
}

static RegisterPressureResult
computeRegisterPressureLocal(const ScheduleRegion &region,
                             ArrayRef<Operation *> orderedOps,
                             const RegisterPressureBudgets &budgets,
                             const SchedulePressureRegionContext &context) {
  if (!context.supported)
    return makeUnsupportedRegisterPressureResult(context.fallbackReason);
  if (orderedOps.size() != region.ops.size())
    return makeUnsupportedRegisterPressureResult("pressure_position_missing");
  const WaveAMDLiveIntervalBuildResult &intervals =
      context.funcContext->intervals;

  DenseMap<Operation *, unsigned> candidatePos;
  for (auto [ordinal, op] : llvm::enumerate(orderedOps))
    candidatePos[op] = context.firstPos + ordinal;

  SmallVector<LocalPressureBounds, 32> sgprBounds(
      intervals.intervals.sgprs.size());
  SmallVector<LocalPressureBounds, 32> vgprBounds(
      intervals.intervals.vgprs.size());
  initializeBoundaryPressure(intervals.intervals.sgprs, context.sgprGroups,
                             context.firstPos, context.lastPos, sgprBounds);
  initializeBoundaryPressure(intervals.intervals.vgprs, context.vgprGroups,
                             context.firstPos, context.lastPos, vgprBounds);

  for (Operation *op : orderedOps) {
    auto posIt = candidatePos.find(op);
    if (posIt == candidatePos.end())
      return makeUnsupportedRegisterPressureResult("pressure_position_missing");
    unsigned pos = posIt->second;
    for (Value value : op->getResults()) {
      std::optional<PressureGroupRef> group =
          findPressureGroup(*context.funcContext, value);
      if (!group)
        continue;
      LocalPressureBounds &bounds =
          getPressureBounds(*group, sgprBounds, vgprBounds);
      markPressureStart(bounds, pos);
    }
    for (Value value : op->getOperands()) {
      std::optional<PressureGroupRef> group =
          findPressureGroup(*context.funcContext, value);
      if (!group)
        continue;
      LocalPressureBounds &bounds =
          getPressureBounds(*group, sgprBounds, vgprBounds);
      markPressureEnd(bounds, pos);
    }
  }

  return makeRegisterPressureResult(
      computeLocalMaxPressure(intervals.intervals.vgprs, context.vgprGroups,
                              vgprBounds, context.firstPos, context.lastPos),
      computeLocalMaxPressure(intervals.intervals.sgprs, context.sgprGroups,
                              sgprBounds, context.firstPos, context.lastPos),
      budgets, /*conservative=*/false);
}

static RegisterPressureResult
computeRegisterPressure(const ScheduleRegion &region,
                        ArrayRef<Operation *> orderedOps,
                        const RegisterPressureBudgets &budgets,
                        const SchedulePressureRegionContext *context) {
  if (context)
    return computeRegisterPressureLocal(region, orderedOps, budgets, *context);
  return computeRegisterPressureFull(region, orderedOps, budgets);
}

CandidateMetrics evaluateOps(const ScheduleRegion &region,
                             ArrayRef<Operation *> ops,
                             ArchResolution archResolution,
                             const waveamdmachine::EventSimConfig &modelConfig,
                             const RegisterPressureBudgets &budgets,
                             PressureEvaluation pressureEvaluation) {
  CandidateMetrics metrics;
  metrics.score = scoreOps(ops, archResolution, modelConfig);
  if (archResolution.arch) {
    metrics.counterBurstCycles =
        computeCounterBurstCycles(ops, *archResolution.arch, modelConfig);
    metrics.hazardWaitCycles =
        estimateHazardWaitCycles(ops, *archResolution.arch);
  }
  if (pressureEvaluation == PressureEvaluation::Eager)
    metrics.pressure =
        computeRegisterPressure(region, ops, budgets, /*context=*/nullptr);
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
  if (pressure.conservative)
    os << " pressure_bound=conservative";
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
    if (metrics.hazardWaitCycles != 0)
      llvm::errs() << " hazard_wait_cycles=" << metrics.hazardWaitCycles;
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
    return makeUnsupportedCandidateMetrics(candidate.fallbackReason);

  SmallVector<Operation *, 16> candidateOps;
  StringRef fallbackReason;
  if (!buildCandidateOps(region, graph, candidate.order, candidateOps,
                         fallbackReason))
    return makeUnsupportedCandidateMetrics(fallbackReason);

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
    if (llvm::is_contained(tables.successors[edge.src], edge.dst))
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
  if (auto info = dyn_cast<waveamdmachine::WaitcntInfoOpInterface>(op))
    return info.getWaitcntInfo().isIssuer();
  return false;
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

static bool isValuLikeFU(waveamdmachine::FunctionalUnit fu) {
  return fu == waveamdmachine::FunctionalUnit::VALU ||
         fu == waveamdmachine::FunctionalUnit::TRANS;
}

enum class DfsState : uint8_t {
  Unseen,
  Visiting,
  Done,
};

static int64_t computeCriticalPath(
    unsigned node, ArrayRef<SmallVector<unsigned, 4>> successors,
    ArrayRef<NodeMetrics> metrics, SmallVectorImpl<int64_t> &memo,
    SmallVectorImpl<DfsState> &state) {
  if (state[node] == DfsState::Done)
    return memo[node];
  if (state[node] == DfsState::Visiting)
    return metrics[node].latency;
  state[node] = DfsState::Visiting;
  int64_t best = metrics[node].latency;
  for (unsigned succ : successors[node]) {
    int64_t through =
        metrics[node].latency +
        computeCriticalPath(succ, successors, metrics, memo, state);
    best = std::max(best, through);
  }
  state[node] = DfsState::Done;
  memo[node] = best;
  return best;
}

static bool computeReachMemory(unsigned node,
                               ArrayRef<SmallVector<unsigned, 4>> successors,
                               SmallVectorImpl<NodeMetrics> &metrics,
                               SmallVectorImpl<DfsState> &state) {
  if (state[node] == DfsState::Done)
    return metrics[node].reachesMemory;
  if (state[node] == DfsState::Visiting)
    return metrics[node].memory;
  state[node] = DfsState::Visiting;
  bool reaches = metrics[node].memory;
  for (unsigned succ : successors[node])
    reaches |= computeReachMemory(succ, successors, metrics, state);
  state[node] = DfsState::Done;
  metrics[node].reachesMemory = reaches;
  return reaches;
}

static bool computeReachCmaIssue(unsigned node,
                                 ArrayRef<SmallVector<unsigned, 4>> successors,
                                 SmallVectorImpl<NodeMetrics> &metrics,
                                 SmallVectorImpl<DfsState> &state) {
  if (state[node] == DfsState::Done)
    return metrics[node].reachesCmaIssue;
  if (state[node] == DfsState::Visiting)
    return metrics[node].cmaIssue;
  state[node] = DfsState::Visiting;
  bool reaches = metrics[node].cmaIssue;
  for (unsigned succ : successors[node])
    reaches |= computeReachCmaIssue(succ, successors, metrics, state);
  state[node] = DfsState::Done;
  metrics[node].reachesCmaIssue = reaches;
  return reaches;
}

static bool computeReachLdsDma(unsigned node,
                               ArrayRef<SmallVector<unsigned, 4>> successors,
                               SmallVectorImpl<NodeMetrics> &metrics,
                               SmallVectorImpl<DfsState> &state) {
  if (state[node] == DfsState::Done)
    return metrics[node].reachesLdsDma;
  if (state[node] == DfsState::Visiting)
    return metrics[node].ldsDma;
  state[node] = DfsState::Visiting;
  bool reaches = metrics[node].ldsDma;
  for (unsigned succ : successors[node])
    reaches |= computeReachLdsDma(succ, successors, metrics, state);
  state[node] = DfsState::Done;
  metrics[node].reachesLdsDma = reaches;
  return reaches;
}

SmallVector<NodeMetrics, 16>
computeNodeMetrics(const ScheduleRegion &region, const GraphTables &tables,
                   const waveamdmachine::ArchData &arch,
                   const waveamdmachine::EventSimConfig &modelConfig) {
  SmallVector<NodeMetrics, 16> metrics(region.ops.size());
  for (auto [index, op] : llvm::enumerate(region.ops)) {
    waveamdmachine::SchedClass cls = waveamdmachine::classifyOp(op);
    metrics[index].noInst = cls == waveamdmachine::SchedClass::NoInst;
    metrics[index].latency = getModelLatency(arch, cls, modelConfig);
    metrics[index].fu = waveamdmachine::funit(arch, cls);
    if (waveamdmachine::hasMemoryValueLatency(op))
      metrics[index].latency = waveamdmachine::getMemoryValueLatency(
          arch, op, modelConfig.valueLatencies, modelConfig.calibration);
    metrics[index].memory = isMemoryIssuer(op);
    unsigned issueCount = getIssueCount(op);
    metrics[index].issueCount = issueCount;
    metrics[index].issueSlots = getIssueSlots(cls, issueCount);
    metrics[index].cmaIssueCount =
        waveamdmachine::getEventSimCmaIssueCount(op, cls, issueCount);
    metrics[index].cmaIssue = metrics[index].cmaIssueCount > 0;
    metrics[index].ldsDma = waveamdmachine::isLdsDmaIssuer(op);
    metrics[index].salu =
        metrics[index].fu == waveamdmachine::FunctionalUnit::SALU;
    metrics[index].valu = isValuLikeFU(metrics[index].fu);
  }

  SmallVector<int64_t, 16> memo(region.ops.size(), 0);
  SmallVector<DfsState, 16> state(region.ops.size(), DfsState::Unseen);
  for (unsigned index = 0; index < region.ops.size(); ++index)
    metrics[index].criticalPath =
        computeCriticalPath(index, tables.successors, metrics, memo, state);

  state.assign(region.ops.size(), DfsState::Unseen);
  for (unsigned index = 0; index < region.ops.size(); ++index)
    computeReachMemory(index, tables.successors, metrics, state);

  state.assign(region.ops.size(), DfsState::Unseen);
  for (unsigned index = 0; index < region.ops.size(); ++index)
    computeReachCmaIssue(index, tables.successors, metrics, state);

  state.assign(region.ops.size(), DfsState::Unseen);
  for (unsigned index = 0; index < region.ops.size(); ++index)
    computeReachLdsDma(index, tables.successors, metrics, state);

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

static bool isBetterReadyNode(SchedulePolicy policy, unsigned lhs, unsigned rhs,
                              ArrayRef<NodeMetrics> metrics) {
  const NodeMetrics &l = metrics[lhs];
  const NodeMetrics &r = metrics[rhs];
  if (l.noInst != r.noInst)
    return l.noInst;
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

struct IssueWindowState {
  waveamdmachine::FunctionalUnit lastFU = waveamdmachine::FunctionalUnit::None;
  unsigned issueFillSlots = 0;
};

static bool fillsIssueWindow(const NodeMetrics &metrics) {
  return metrics.issueSlots > 0 && !metrics.cmaIssue &&
         (metrics.memory || metrics.salu || metrics.valu);
}

static int issueFillWindowScore(const NodeMetrics &metrics,
                                const IssueWindowState &state) {
  int score = 0;
  if (state.issueFillSlots == 0)
    return score;
  if (fillsIssueWindow(metrics))
    score += 220;
  if (metrics.cmaIssue)
    score -= 120;
  return score;
}

static int cmaReachScore(const NodeMetrics &metrics) {
  if (metrics.reachesCmaIssue && !metrics.cmaIssue)
    return 180;
  if (metrics.cmaIssue)
    return 120;
  return 0;
}

static int memoryReachScore(const NodeMetrics &metrics) {
  int score = 0;
  if (metrics.memory)
    score += 90;
  if (metrics.reachesMemory)
    score += 45;
  return score;
}

static int fuSwitchScore(const NodeMetrics &metrics,
                         const IssueWindowState &state) {
  if (state.lastFU == waveamdmachine::FunctionalUnit::None)
    return 0;
  if (metrics.fu != state.lastFU)
    return 25;
  return 0;
}

static int issueWindowScore(const NodeMetrics &metrics,
                            const IssueWindowState &state) {
  return issueFillWindowScore(metrics, state) + cmaReachScore(metrics) +
         memoryReachScore(metrics) + fuSwitchScore(metrics, state) +
         std::min<int64_t>(metrics.criticalPath, 255);
}

static bool isBetterIssueReadyNode(unsigned lhs, unsigned rhs,
                                   ArrayRef<NodeMetrics> metrics,
                                   const IssueWindowState &state) {
  if (metrics[lhs].noInst != metrics[rhs].noInst)
    return metrics[lhs].noInst;
  int lhsScore = issueWindowScore(metrics[lhs], state);
  int rhsScore = issueWindowScore(metrics[rhs], state);
  if (lhsScore != rhsScore)
    return lhsScore > rhsScore;
  if (metrics[lhs].latency != metrics[rhs].latency)
    return metrics[lhs].latency > metrics[rhs].latency;
  return lhs < rhs;
}

static void updateIssueWindowState(IssueWindowState &state,
                                   const NodeMetrics &metrics) {
  if (metrics.cmaIssue)
    state.issueFillSlots = 2;
  else if (metrics.issueSlots >= state.issueFillSlots)
    state.issueFillSlots = 0;
  else
    state.issueFillSlots -= metrics.issueSlots;
  if (metrics.issueSlots > 0)
    state.lastFU = metrics.fu;
}

static bool buildIssueWindowOrder(const GraphTables &tables,
                                  ArrayRef<NodeMetrics> metrics,
                                  SmallVectorImpl<unsigned> &order) {
  SmallVector<unsigned, 16> pending = tables.pendingPreds;
  SmallVector<unsigned, 16> ready;
  for (auto [index, count] : llvm::enumerate(pending))
    if (count == 0)
      ready.push_back(index);

  IssueWindowState state;
  while (!ready.empty()) {
    unsigned bestReady = 0;
    for (unsigned i = 1; i < ready.size(); ++i)
      if (isBetterIssueReadyNode(ready[i], ready[bestReady], metrics, state))
        bestReady = i;

    unsigned node = ready[bestReady];
    ready.erase(ready.begin() + bestReady);
    order.push_back(node);
    updateIssueWindowState(state, metrics[node]);
    for (unsigned succ : tables.successors[node]) {
      assert(pending[succ] > 0 && "successor predecessor count underflow");
      --pending[succ];
      if (pending[succ] == 0)
        ready.push_back(succ);
    }
  }

  return order.size() == pending.size();
}

struct CmaDmaPlacementWindow {
  SmallVector<unsigned, 16> insertPositions;
  SmallVector<unsigned, 16> cmaLeadCounts;
  unsigned dmaBegin = 0;
  unsigned dmaEnd = 0;
};

static constexpr unsigned kMaxCmaDmaPlacementCandidatesPerWindow = 8;

struct LdsDmaSlice {
  unsigned begin = 0;
  unsigned end = 0;
  unsigned issues = 0;
};

struct SlicedCmaDmaPlacementWindow {
  SmallVector<LdsDmaSlice, 16> slices;
  SmallVector<unsigned, 16> insertPositions;
  SmallVector<unsigned, 16> cmaLeadCounts;
  SmallVector<unsigned, 4> earlyBridge;
  SmallVector<unsigned, 4> lateBridge;
  unsigned totalCmaIssues = 0;
  unsigned cmaBegin = 0;
  unsigned cmaEnd = 0;
};

static bool isNonDmaCmaIssue(const NodeMetrics &metrics) {
  return metrics.cmaIssue && !metrics.ldsDma;
}

static bool isLdsDmaProducer(const NodeMetrics &metrics) {
  return metrics.ldsDma || metrics.reachesLdsDma;
}

static void collectCmaInsertPositions(unsigned runBegin, unsigned runEnd,
                                      ArrayRef<NodeMetrics> metrics,
                                      CmaDmaPlacementWindow &window) {
  unsigned cmaCount = 0;
  for (unsigned index = runBegin; index < runEnd; ++index) {
    if (!isNonDmaCmaIssue(metrics[index]))
      continue;
    ++cmaCount;
    if (index + 1 >= runEnd)
      continue;
    window.insertPositions.push_back(index + 1);
    window.cmaLeadCounts.push_back(cmaCount);
  }
}

static bool isCmaDmaPlacementStart(ArrayRef<NodeMetrics> metrics,
                                   unsigned index) {
  if (index >= metrics.size())
    return false;
  if (isNonDmaCmaIssue(metrics[index]))
    return false;
  return isLdsDmaProducer(metrics[index]);
}

static bool isCmaStreamOp(const NodeMetrics &metrics) {
  return isNonDmaCmaIssue(metrics) || !metrics.memory;
}

struct LdsDmaProducerScan {
  unsigned lastProducerEnd = 0;
  bool hasIssuer = false;
};

static std::optional<LdsDmaProducerScan>
scanLdsDmaProducerCluster(ArrayRef<NodeMetrics> metrics, unsigned dmaBegin) {
  LdsDmaProducerScan scan;
  scan.lastProducerEnd = dmaBegin;
  bool gapAfterProducer = false;
  for (unsigned index = dmaBegin; index < metrics.size(); ++index) {
    if (isNonDmaCmaIssue(metrics[index]))
      break;
    if (!isLdsDmaProducer(metrics[index])) {
      if (scan.lastProducerEnd > dmaBegin)
        gapAfterProducer = true;
      continue;
    }
    if (gapAfterProducer)
      return std::nullopt;
    scan.lastProducerEnd = index + 1;
    scan.hasIssuer |= metrics[index].ldsDma;
  }
  if (!scan.hasIssuer || scan.lastProducerEnd <= dmaBegin)
    return std::nullopt;
  return scan;
}

static std::optional<LdsDmaProducerScan>
scanLeadingLdsDmaProducerCluster(ArrayRef<NodeMetrics> metrics,
                                 unsigned dmaBegin) {
  LdsDmaProducerScan scan;
  scan.lastProducerEnd = dmaBegin;
  for (unsigned index = dmaBegin; index < metrics.size(); ++index) {
    if (!isLdsDmaProducer(metrics[index]))
      break;
    scan.lastProducerEnd = index + 1;
    scan.hasIssuer |= metrics[index].ldsDma;
  }
  if (!scan.hasIssuer || scan.lastProducerEnd <= dmaBegin)
    return std::nullopt;
  return scan;
}

static std::optional<CmaDmaPlacementWindow>
findCmaDmaPlacementWindow(ArrayRef<NodeMetrics> metrics, unsigned runBegin,
                          unsigned runEnd) {
  unsigned dmaBegin = runEnd;
  if (!isCmaDmaPlacementStart(metrics, dmaBegin))
    return std::nullopt;
  std::optional<LdsDmaProducerScan> scan =
      scanLdsDmaProducerCluster(metrics, dmaBegin);
  if (!scan)
    return std::nullopt;

  CmaDmaPlacementWindow window;
  collectCmaInsertPositions(runBegin, runEnd, metrics, window);
  if (window.insertPositions.empty())
    return std::nullopt;
  window.dmaBegin = dmaBegin;
  window.dmaEnd = scan->lastProducerEnd;
  return window;
}

static SmallVector<CmaDmaPlacementWindow, 4>
findCmaDmaPlacementWindows(ArrayRef<NodeMetrics> metrics) {
  SmallVector<CmaDmaPlacementWindow, 4> windows;
  for (unsigned index = 0; index < metrics.size();) {
    if (!isNonDmaCmaIssue(metrics[index])) {
      ++index;
      continue;
    }
    unsigned runBegin = index;
    while (index < metrics.size() && isNonDmaCmaIssue(metrics[index]))
      ++index;
    unsigned runEnd = index;
    if (std::optional<CmaDmaPlacementWindow> window =
            findCmaDmaPlacementWindow(metrics, runBegin, runEnd)) {
      windows.push_back(*window);
      index = std::max(index, window->dmaEnd);
    }
  }
  return windows;
}

static SmallVector<LdsDmaSlice, 16>
collectLdsDmaSlices(ArrayRef<NodeMetrics> metrics, unsigned begin,
                    unsigned end) {
  SmallVector<LdsDmaSlice, 16> slices;
  unsigned sliceBegin = begin;
  unsigned sliceIssues = 0;
  for (unsigned index = begin; index < end; ++index) {
    if (metrics[index].ldsDma)
      sliceIssues += std::max(1u, metrics[index].issueCount);
    if (!metrics[index].ldsDma)
      continue;
    slices.push_back({sliceBegin, index + 1, sliceIssues});
    sliceBegin = index + 1;
    sliceIssues = 0;
  }
  return slices;
}

static void appendIndexRange(unsigned begin, unsigned end,
                             SmallVectorImpl<unsigned> &order) {
  for (unsigned index = begin; index < end; ++index)
    order.push_back(index);
}

static void
collectSlicedCmaInsertPositions(unsigned cmaBegin, unsigned cmaEnd,
                                ArrayRef<NodeMetrics> metrics,
                                SlicedCmaDmaPlacementWindow &window) {
  unsigned cmaCount = 0;
  for (unsigned index = cmaBegin; index < cmaEnd; ++index) {
    if (isNonDmaCmaIssue(metrics[index]))
      cmaCount += std::max(1u, metrics[index].cmaIssueCount);
    window.totalCmaIssues = cmaCount;
    if (cmaCount == 0 || index + 1 >= cmaEnd)
      continue;
    window.insertPositions.push_back(index + 1);
    window.cmaLeadCounts.push_back(cmaCount);
  }
}

static std::optional<unsigned> findSlicedCmaBegin(ArrayRef<NodeMetrics> metrics,
                                                  unsigned begin) {
  for (unsigned index = begin; index < metrics.size(); ++index) {
    if (isNonDmaCmaIssue(metrics[index]))
      return index;
    if (isLdsDmaProducer(metrics[index]) || metrics[index].memory)
      return std::nullopt;
  }
  return std::nullopt;
}

static unsigned findCmaStreamEnd(ArrayRef<NodeMetrics> metrics,
                                 unsigned begin) {
  unsigned end = begin;
  while (end < metrics.size() && isCmaStreamOp(metrics[end]))
    ++end;
  return end;
}

static bool hasSuccessorIn(const GraphTables &tables, ArrayRef<unsigned> nodes,
                           unsigned successor) {
  for (unsigned node : nodes)
    if (llvm::is_contained(tables.successors[node], successor))
      return true;
  return false;
}

static void classifySlicedBridgeOps(ArrayRef<NodeMetrics> metrics,
                                    const GraphTables &tables,
                                    unsigned dmaBegin, unsigned dmaEnd,
                                    unsigned cmaBegin,
                                    SlicedCmaDmaPlacementWindow &window) {
  SmallVector<unsigned, 16> lateDeps;
  appendIndexRange(dmaBegin, dmaEnd, lateDeps);
  for (unsigned index : llvm::seq<unsigned>(dmaEnd, cmaBegin)) {
    if (!hasSuccessorIn(tables, lateDeps, index)) {
      window.earlyBridge.push_back(index);
      continue;
    }
    window.lateBridge.push_back(index);
    lateDeps.push_back(index);
  }
}

static std::optional<SlicedCmaDmaPlacementWindow>
findSlicedCmaDmaPlacementWindow(ArrayRef<NodeMetrics> metrics,
                                const GraphTables &tables, unsigned dmaBegin) {
  std::optional<LdsDmaProducerScan> scan =
      scanLeadingLdsDmaProducerCluster(metrics, dmaBegin);
  if (!scan)
    return std::nullopt;

  std::optional<unsigned> cmaBegin =
      findSlicedCmaBegin(metrics, scan->lastProducerEnd);
  if (!cmaBegin)
    return std::nullopt;

  SlicedCmaDmaPlacementWindow window;
  window.slices = collectLdsDmaSlices(metrics, dmaBegin, scan->lastProducerEnd);
  if (window.slices.size() < 2)
    return std::nullopt;
  classifySlicedBridgeOps(metrics, tables, dmaBegin, scan->lastProducerEnd,
                          *cmaBegin, window);
  window.cmaBegin = *cmaBegin;
  window.cmaEnd = findCmaStreamEnd(metrics, *cmaBegin);
  collectSlicedCmaInsertPositions(*cmaBegin, window.cmaEnd, metrics, window);
  if (window.insertPositions.empty())
    return std::nullopt;
  return window;
}

static SmallVector<SlicedCmaDmaPlacementWindow, 4>
findSlicedCmaDmaPlacementWindows(ArrayRef<NodeMetrics> metrics,
                                 const GraphTables &tables) {
  SmallVector<SlicedCmaDmaPlacementWindow, 4> windows;
  for (unsigned index = 0; index < metrics.size();) {
    if (!isCmaDmaPlacementStart(metrics, index)) {
      ++index;
      continue;
    }
    std::optional<SlicedCmaDmaPlacementWindow> window =
        findSlicedCmaDmaPlacementWindow(metrics, tables, index);
    if (!window) {
      ++index;
      continue;
    }
    windows.push_back(*window);
    index = window->cmaEnd;
  }
  return windows;
}

static void buildCmaDmaPlacementOrder(const CmaDmaPlacementWindow &window,
                                      unsigned insertPos, unsigned opCount,
                                      SmallVectorImpl<unsigned> &order) {
  appendIndexRange(0, insertPos, order);
  appendIndexRange(window.dmaBegin, window.dmaEnd, order);
  appendIndexRange(insertPos, window.dmaBegin, order);
  appendIndexRange(window.dmaEnd, opCount, order);
}

static unsigned totalCmaIssues(const SlicedCmaDmaPlacementWindow &window) {
  return window.totalCmaIssues;
}

static unsigned
desiredCmaLeadForSlice(const SlicedCmaDmaPlacementWindow &window,
                       unsigned prefixSlices, unsigned movableOrdinal,
                       unsigned movableCount) {
  unsigned cmaIssues = totalCmaIssues(window);
  if (cmaIssues == 0 || movableCount == 0)
    return 0;
  unsigned spacing = (cmaIssues + movableCount) / (movableCount + 1);
  unsigned lead = spacing * (movableOrdinal + 1);
  if (lead <= prefixSlices)
    return 1;
  return lead - prefixSlices;
}

static unsigned
nearestCmaInsertPosition(const SlicedCmaDmaPlacementWindow &window,
                         unsigned targetCmaLead) {
  unsigned best = 0;
  unsigned bestDistance = std::numeric_limits<unsigned>::max();
  for (auto [index, cmaLead] : llvm::enumerate(window.cmaLeadCounts)) {
    unsigned distance = cmaLead > targetCmaLead ? cmaLead - targetCmaLead
                                                : targetCmaLead - cmaLead;
    if (distance >= bestDistance)
      continue;
    best = static_cast<unsigned>(index);
    bestDistance = distance;
  }
  return window.insertPositions[best];
}

static void appendLdsDmaSlice(const LdsDmaSlice &slice,
                              SmallVectorImpl<unsigned> &order) {
  appendIndexRange(slice.begin, slice.end, order);
}

static void appendSlicedCmaDmaPrefix(const SlicedCmaDmaPlacementWindow &window,
                                     unsigned prefixSlices,
                                     SmallVectorImpl<unsigned> &order) {
  appendIndexRange(0, window.slices.front().begin, order);
  for (unsigned sliceIndex : llvm::seq<unsigned>(0, prefixSlices))
    appendLdsDmaSlice(window.slices[sliceIndex], order);
  order.append(window.earlyBridge.begin(), window.earlyBridge.end());
}

static SmallVector<std::pair<unsigned, unsigned>, 16>
collectSlicedCmaDmaInsertions(const SlicedCmaDmaPlacementWindow &window,
                              unsigned prefixSlices) {
  SmallVector<std::pair<unsigned, unsigned>, 16> insertions;
  unsigned movableCount = window.slices.size() - prefixSlices;
  for (unsigned movableOrdinal : llvm::seq<unsigned>(0, movableCount)) {
    unsigned sliceIndex = prefixSlices + movableOrdinal;
    unsigned cmaLead = desiredCmaLeadForSlice(window, prefixSlices,
                                              movableOrdinal, movableCount);
    insertions.push_back(
        {nearestCmaInsertPosition(window, cmaLead), sliceIndex});
  }
  return insertions;
}

static bool
emitSlicedCmaDmaInsertionsAt(const SlicedCmaDmaPlacementWindow &window,
                             ArrayRef<std::pair<unsigned, unsigned>> insertions,
                             unsigned insertPos, unsigned &nextInsertion,
                             bool emittedLateBridge,
                             SmallVectorImpl<unsigned> &order) {
  while (nextInsertion < insertions.size() &&
         insertions[nextInsertion].first == insertPos) {
    appendLdsDmaSlice(window.slices[insertions[nextInsertion].second], order);
    ++nextInsertion;
    if (nextInsertion == insertions.size() && !emittedLateBridge) {
      order.append(window.lateBridge.begin(), window.lateBridge.end());
      emittedLateBridge = true;
    }
  }
  return emittedLateBridge;
}

static void
buildSlicedCmaDmaPlacementOrder(const SlicedCmaDmaPlacementWindow &window,
                                unsigned prefixSlices, unsigned opCount,
                                SmallVectorImpl<unsigned> &order) {
  appendSlicedCmaDmaPrefix(window, prefixSlices, order);
  SmallVector<std::pair<unsigned, unsigned>, 16> insertions =
      collectSlicedCmaDmaInsertions(window, prefixSlices);
  unsigned nextInsertion = 0;
  bool emittedLateBridge = window.lateBridge.empty();
  for (unsigned index = window.cmaBegin; index < window.cmaEnd; ++index) {
    order.push_back(index);
    emittedLateBridge = emitSlicedCmaDmaInsertionsAt(
        window, insertions, index + 1, nextInsertion, emittedLateBridge, order);
  }
  if (!emittedLateBridge)
    order.append(window.lateBridge.begin(), window.lateBridge.end());
  appendIndexRange(window.cmaEnd, opCount, order);
}

static SmallVector<unsigned, 4>
sampleSlicedCmaDmaPrefixes(unsigned sliceCount, unsigned cmaIssues,
                           unsigned cmaCapacity) {
  SmallVector<unsigned, 4> prefixes;
  if (sliceCount < 2 || cmaIssues == 0)
    return prefixes;
  unsigned denom = std::max(1u, 2 * cmaCapacity);
  unsigned prefix = (sliceCount + denom - 1) / denom;
  auto appendUniquePrefix = [&](unsigned value) {
    value = std::min(value, sliceCount - 1);
    if (!llvm::is_contained(prefixes, value))
      prefixes.push_back(value);
  };
  appendUniquePrefix(0);
  appendUniquePrefix(prefix);
  return prefixes;
}

static SmallVector<unsigned, 8>
sampleCmaDmaPlacementIndices(unsigned candidateCount) {
  SmallVector<unsigned, 8> indices;
  if (candidateCount <= kMaxCmaDmaPlacementCandidatesPerWindow) {
    for (unsigned index : llvm::seq<unsigned>(0, candidateCount))
      indices.push_back(index);
    return indices;
  }

  unsigned last = candidateCount - 1;
  unsigned denom = kMaxCmaDmaPlacementCandidatesPerWindow - 1;
  for (unsigned sample :
       llvm::seq<unsigned>(0, kMaxCmaDmaPlacementCandidatesPerWindow)) {
    unsigned index = sample * last / denom;
    if (indices.empty() || indices.back() != index)
      indices.push_back(index);
  }
  return indices;
}

static constexpr size_t kNumScheduleFUs =
    static_cast<size_t>(waveamdmachine::FunctionalUnit::NumFunctionalUnits);

struct LocalIssueState {
  DenseMap<Value, int64_t> readyAt;
  DenseMap<int64_t, unsigned> cuIssueCounts;
  DenseMap<int64_t, unsigned> cmaIssueCounts;
  ScheduleHazardState hazardState;
  std::array<int64_t, kNumScheduleFUs> fuReady = {};
  int64_t issueReady = 0;
  int64_t ldsDmaReady = 0;
};

struct LocalIssuePreview {
  waveamdmachine::SchedClass cls = waveamdmachine::SchedClass::NoInst;
  waveamdmachine::FunctionalUnit fu = waveamdmachine::FunctionalUnit::None;
  int64_t operandReady = 0;
  int64_t issueCycle = 0;
  int64_t nextIssue = 0;
  int64_t readyCycle = 0;
  int64_t memoryValueReady = 0;
  unsigned issues = 0;
  unsigned hazardWait = 0;
  bool memoryIssuer = false;
  bool hasMemoryValue = false;
};

struct LocalIssueChoice {
  LocalIssuePreview preview;
  unsigned unlocked = 0;
  unsigned node = 0;
};

static int getIssuePeriod(const waveamdmachine::ArchData &arch,
                          const waveamdmachine::EventSimConfig &config) {
  return waveamdmachine::getEventSimIssuePeriod(arch, config);
}

static int
getLdsDmaIssueInterval(const waveamdmachine::ArchData &arch,
                       const waveamdmachine::EventSimConfig &config) {
  return waveamdmachine::getEventSimLdsDmaIssueInterval(arch, config);
}

static int getCmaIssueInterval(const waveamdmachine::ArchData &arch,
                               const waveamdmachine::EventSimConfig &config) {
  return waveamdmachine::getEventSimCmaIssueInterval(arch, config);
}

static unsigned getCmaIssueCount(Operation *op, waveamdmachine::SchedClass cls,
                                 unsigned issues) {
  return waveamdmachine::getEventSimCmaIssueCount(op, cls, issues);
}

static int64_t issueCycleAt(int64_t start, unsigned issue, int period) {
  return start + static_cast<int64_t>(issue) * period;
}

static int64_t cuIssueReadyCycle(const LocalIssueState &state,
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

static int64_t cmaIssueReadyCycle(const LocalIssueState &state,
                                  const waveamdmachine::ArchData &arch,
                                  const waveamdmachine::EventSimConfig &config,
                                  int64_t cycle, Operation *op,
                                  waveamdmachine::SchedClass cls,
                                  unsigned issues) {
  int interval = getCmaIssueInterval(arch, config);
  unsigned cmaIssues = getCmaIssueCount(op, cls, issues);
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

static void consumeCuIssueSlots(LocalIssueState &state,
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

static void consumeCmaIssueSlots(LocalIssueState &state,
                                 const waveamdmachine::ArchData &arch,
                                 const waveamdmachine::EventSimConfig &config,
                                 int64_t cycle, Operation *op,
                                 waveamdmachine::SchedClass cls,
                                 unsigned issues) {
  int interval = getCmaIssueInterval(arch, config);
  unsigned cmaIssues = getCmaIssueCount(op, cls, issues);
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

static int64_t operandReadyCycle(const LocalIssueState &state, Operation *op) {
  int64_t ready = 0;
  for (Value operand : op->getOperands()) {
    DenseMap<Value, int64_t>::const_iterator it = state.readyAt.find(operand);
    if (it != state.readyAt.end())
      ready = std::max(ready, it->second);
  }
  return ready;
}

static LocalIssuePreview
previewLocalIssue(const LocalIssueState &state, Operation *op,
                  const waveamdmachine::ArchData &arch,
                  const waveamdmachine::EventSimConfig &config) {
  LocalIssuePreview preview;
  preview.operandReady = operandReadyCycle(state, op);
  preview.hazardWait = getRequiredValueWait(op, state.hazardState);
  preview.cls = waveamdmachine::classifyOp(op);
  if (preview.cls == waveamdmachine::SchedClass::NoInst) {
    preview.issueCycle = preview.operandReady;
    preview.nextIssue = preview.operandReady;
    preview.readyCycle = preview.operandReady;
    preview.memoryValueReady = preview.operandReady;
    return preview;
  }

  preview.fu = waveamdmachine::funit(arch, preview.cls);
  preview.issues = std::max(1u, getIssueCount(op));
  preview.memoryIssuer = isMemoryIssuer(op);
  preview.hasMemoryValue = waveamdmachine::hasMemoryValueLatency(op);
  int period = getIssuePeriod(arch, config);
  int latency = getModelLatency(arch, preview.cls, config);
  int64_t ready = std::max(preview.operandReady, state.issueReady);
  ready = std::max(ready, state.fuReady[static_cast<size_t>(preview.fu)]);
  if (waveamdmachine::isLdsDmaIssuer(op)) {
    int interval = getLdsDmaIssueInterval(arch, config);
    if (interval > 0)
      ready = std::max(ready, state.ldsDmaReady);
  }

  while (true) {
    int64_t cmaReady = cmaIssueReadyCycle(state, arch, config, ready, op,
                                          preview.cls, preview.issues);
    int64_t cuReady =
        cuIssueReadyCycle(state, arch, cmaReady, preview.issues, period);
    if (cuReady == cmaReady) {
      preview.issueCycle = cuReady;
      break;
    }
    ready = cuReady;
  }

  int64_t lastIssue =
      preview.issueCycle + static_cast<int64_t>(preview.issues - 1) * period;
  preview.nextIssue =
      preview.issueCycle + static_cast<int64_t>(preview.issues) * period;
  preview.readyCycle = lastIssue + latency;
  preview.memoryValueReady =
      preview.hasMemoryValue
          ? lastIssue + waveamdmachine::getMemoryValueLatency(
                            arch, op, config.valueLatencies, config.calibration)
          : preview.readyCycle;
  return preview;
}

static void applyLocalIssue(LocalIssueState &state, Operation *op,
                            const LocalIssuePreview &preview,
                            const waveamdmachine::ArchData &arch,
                            const waveamdmachine::EventSimConfig &config) {
  if (preview.cls == waveamdmachine::SchedClass::NoInst) {
    for (Value result : op->getResults())
      state.readyAt[result] = preview.readyCycle;
    ScheduleHazardConfig hazardConfig = makeScheduleHazardConfig(arch);
    transferScheduleHazards(op, state.hazardState, hazardConfig);
    return;
  }

  int period = getIssuePeriod(arch, config);
  state.issueReady = preview.nextIssue;
  state.fuReady[static_cast<size_t>(preview.fu)] = preview.nextIssue;
  consumeCuIssueSlots(state, arch, preview.issueCycle, preview.issues, period);
  consumeCmaIssueSlots(state, arch, config, preview.issueCycle, op, preview.cls,
                       preview.issues);
  if (waveamdmachine::isLdsDmaIssuer(op)) {
    int interval = getLdsDmaIssueInterval(arch, config);
    if (interval > 0)
      state.ldsDmaReady =
          preview.issueCycle + static_cast<int64_t>(preview.issues) * interval;
  }

  for (Value result : op->getResults()) {
    int64_t resultReady = preview.readyCycle;
    if (preview.memoryIssuer && isMemToken(result))
      resultReady = preview.nextIssue;
    else if (preview.hasMemoryValue)
      resultReady = preview.memoryValueReady;
    state.readyAt[result] = resultReady;
  }

  ScheduleHazardConfig hazardConfig = makeScheduleHazardConfig(arch);
  transferScheduleHazards(op, state.hazardState, hazardConfig);
}

static unsigned countUnlockedSuccessors(unsigned node,
                                        const GraphTables &tables,
                                        ArrayRef<unsigned> pending) {
  unsigned unlocked = 0;
  for (unsigned succ : tables.successors[node])
    if (pending[succ] == 1)
      ++unlocked;
  return unlocked;
}

static LocalIssueChoice
makeLocalIssueChoice(unsigned node, const GraphTables &tables,
                     ArrayRef<unsigned> pending, const LocalIssueState &state,
                     const ScheduleRegion &region,
                     const waveamdmachine::ArchData &arch,
                     const waveamdmachine::EventSimConfig &modelConfig) {
  LocalIssueChoice choice;
  choice.node = node;
  choice.unlocked = countUnlockedSuccessors(node, tables, pending);
  choice.preview =
      previewLocalIssue(state, region.ops[node], arch, modelConfig);
  return choice;
}

static bool isBetterLocalIssueChoice(const LocalIssueChoice &lhs,
                                     const LocalIssueChoice &rhs,
                                     ArrayRef<NodeMetrics> metrics) {
  if (metrics[lhs.node].noInst != metrics[rhs.node].noInst)
    return metrics[lhs.node].noInst;
  if (lhs.preview.issueCycle != rhs.preview.issueCycle)
    return lhs.preview.issueCycle < rhs.preview.issueCycle;
  if (lhs.preview.hazardWait != rhs.preview.hazardWait)
    return lhs.preview.hazardWait < rhs.preview.hazardWait;
  if (metrics[lhs.node].criticalPath != metrics[rhs.node].criticalPath)
    return metrics[lhs.node].criticalPath > metrics[rhs.node].criticalPath;
  if (metrics[lhs.node].latency != metrics[rhs.node].latency)
    return metrics[lhs.node].latency > metrics[rhs.node].latency;
  if (lhs.unlocked != rhs.unlocked)
    return lhs.unlocked > rhs.unlocked;
  if (lhs.preview.readyCycle != rhs.preview.readyCycle)
    return lhs.preview.readyCycle < rhs.preview.readyCycle;
  return lhs.node < rhs.node;
}

static bool
buildLocalIssueOrder(const ScheduleRegion &region, const GraphTables &tables,
                     ArrayRef<NodeMetrics> metrics,
                     const waveamdmachine::ArchData &arch,
                     const waveamdmachine::EventSimConfig &modelConfig,
                     SmallVectorImpl<unsigned> &order) {
  SmallVector<unsigned, 16> pending = tables.pendingPreds;
  SmallVector<unsigned, 16> ready;
  for (auto [index, count] : llvm::enumerate(pending))
    if (count == 0)
      ready.push_back(index);

  LocalIssueState state;
  while (!ready.empty()) {
    unsigned bestReady = 0;
    LocalIssueChoice best = makeLocalIssueChoice(
        ready.front(), tables, pending, state, region, arch, modelConfig);
    for (unsigned i = 1; i < ready.size(); ++i) {
      LocalIssueChoice choice = makeLocalIssueChoice(
          ready[i], tables, pending, state, region, arch, modelConfig);
      if (isBetterLocalIssueChoice(choice, best, metrics)) {
        bestReady = i;
        best = choice;
      }
    }

    unsigned node = ready[bestReady];
    ready.erase(ready.begin() + bestReady);
    order.push_back(node);
    applyLocalIssue(state, region.ops[node], best.preview, arch, modelConfig);
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
  candidate.name = name.str();
  if (!buildListOrder(tables, metrics, policy, candidate.order))
    return;
  for (const OrderCandidate &existing : candidates)
    if (sameOrder(existing.order, candidate.order))
      return;
  candidates.push_back(std::move(candidate));
}

static void
addCmaDmaPlacementCandidates(SmallVectorImpl<OrderCandidate> &candidates,
                             ArrayRef<NodeMetrics> metrics) {
  if (!llvm::any_of(metrics,
                    [](const NodeMetrics &metrics) { return metrics.ldsDma; }))
    return;

  for (const CmaDmaPlacementWindow &window :
       findCmaDmaPlacementWindows(metrics)) {
    for (unsigned index :
         sampleCmaDmaPlacementIndices(window.insertPositions.size())) {
      unsigned insertPos = window.insertPositions[index];
      OrderCandidate candidate;
      candidate.name =
          "cma_dma_place_" + std::to_string(window.cmaLeadCounts[index]);
      buildCmaDmaPlacementOrder(window, insertPos, metrics.size(),
                                candidate.order);
      if (candidate.order.size() != metrics.size())
        continue;
      bool duplicate = false;
      for (const OrderCandidate &existing : candidates) {
        if (!sameOrder(existing.order, candidate.order))
          continue;
        duplicate = true;
        break;
      }
      if (!duplicate)
        candidates.push_back(std::move(candidate));
    }
  }
}

static bool appendUniqueCandidate(SmallVectorImpl<OrderCandidate> &candidates,
                                  OrderCandidate candidate,
                                  unsigned expectedSize) {
  if (candidate.order.size() != expectedSize)
    return false;
  for (const OrderCandidate &existing : candidates)
    if (sameOrder(existing.order, candidate.order))
      return false;
  candidates.push_back(std::move(candidate));
  return true;
}

static void addSlicedCmaDmaPlacementCandidates(
    SmallVectorImpl<OrderCandidate> &candidates, ArrayRef<NodeMetrics> metrics,
    const GraphTables &tables, const waveamdmachine::ArchData &arch) {
  if (!llvm::any_of(metrics,
                    [](const NodeMetrics &metrics) { return metrics.ldsDma; }))
    return;

  for (const SlicedCmaDmaPlacementWindow &window :
       findSlicedCmaDmaPlacementWindows(metrics, tables)) {
    unsigned cmaIssues = totalCmaIssues(window);
    for (unsigned prefix : sampleSlicedCmaDmaPrefixes(
             window.slices.size(), cmaIssues,
             waveamdmachine::getEventSimCmaIssueCapacity(arch))) {
      OrderCandidate candidate;
      candidate.name = "cma_dma_place_sliced_p" + std::to_string(prefix) +
                       "_d" + std::to_string(window.slices.size()) + "_c" +
                       std::to_string(cmaIssues);
      buildSlicedCmaDmaPlacementOrder(window, prefix, metrics.size(),
                                      candidate.order);
      appendUniqueCandidate(candidates, std::move(candidate), metrics.size());
    }
  }
}

static void addIssueWindowCandidate(SmallVectorImpl<OrderCandidate> &candidates,
                                    const GraphTables &tables,
                                    ArrayRef<NodeMetrics> metrics) {
  if (!llvm::any_of(
          metrics, [](const NodeMetrics &metrics) { return metrics.cmaIssue; }))
    return;

  OrderCandidate candidate;
  candidate.name = "issue_window";
  if (!buildIssueWindowOrder(tables, metrics, candidate.order))
    return;
  for (const OrderCandidate &existing : candidates)
    if (sameOrder(existing.order, candidate.order))
      return;
  candidates.push_back(std::move(candidate));
}

static void
addLocalIssueCandidate(SmallVectorImpl<OrderCandidate> &candidates,
                       const ScheduleRegion &region, const GraphTables &tables,
                       ArrayRef<NodeMetrics> metrics,
                       const waveamdmachine::ArchData &arch,
                       const waveamdmachine::EventSimConfig &modelConfig) {
  if (!llvm::any_of(
          metrics, [](const NodeMetrics &metrics) { return metrics.cmaIssue; }))
    return;

  OrderCandidate candidate;
  candidate.name = "local_issue";
  if (!buildLocalIssueOrder(region, tables, metrics, arch, modelConfig,
                            candidate.order))
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

static bool
hasCmaIssueContention(ArrayRef<NodeMetrics> metrics,
                      const waveamdmachine::ArchData &arch,
                      const waveamdmachine::EventSimConfig &modelConfig) {
  if (waveamdmachine::getEventSimCmaIssueInterval(arch, modelConfig) <= 0)
    return false;
  return llvm::count_if(metrics, [](const NodeMetrics &metrics) {
           return metrics.cmaIssue;
         }) > 1;
}

static constexpr int64_t kAutomaticBeamWorkLimit = 1000000;

static bool shouldRunBeamSearch(
    ArrayRef<NodeMetrics> metrics, const waveamdmachine::ArchData &arch,
    const waveamdmachine::EventSimConfig &modelConfig, bool enableBeamSearch,
    int64_t estimatedWork, ScheduleSearchLimits limits) {
  if (enableBeamSearch)
    return true;
  if (!hasCmaIssueContention(metrics, arch, modelConfig))
    return false;
  int64_t limit =
      limits.maxBeamWork >= 0 ? limits.maxBeamWork : kAutomaticBeamWorkLimit;
  return estimatedWork <= limit;
}

static bool exceedsBeamWorkLimit(bool enableBeamSearch, int64_t estimatedWork,
                                 ScheduleSearchLimits limits) {
  if (limits.maxBeamWork >= 0)
    return estimatedWork > limits.maxBeamWork;
  if (!enableBeamSearch)
    return estimatedWork > kAutomaticBeamWorkLimit;
  return false;
}

static SmallVector<OrderCandidate, 4>
buildScheduleCandidates(const ScheduleRegion &region,
                        const DependenceGraph &graph,
                        const waveamdmachine::ArchData &arch,
                        const waveamdmachine::EventSimConfig &modelConfig,
                        const RegisterPressureBudgets &budgets,
                        bool enableBeamSearch, ScheduleSearchLimits limits) {
  SmallVector<OrderCandidate, 4> candidates;
  OrderCandidate original;
  original.name = "original";
  original.order = getOriginalOrder(region);
  candidates.push_back(std::move(original));

  GraphTables tables = buildGraphTables(region, graph);
  SmallVector<NodeMetrics, 16> metrics =
      computeNodeMetrics(region, tables, arch, modelConfig);
  addPolicyCandidate(candidates, "critical_path", tables, metrics,
                     SchedulePolicy::CriticalPath);
  addPolicyCandidate(candidates, "memory_early", tables, metrics,
                     SchedulePolicy::MemoryEarly);
  addIssueWindowCandidate(candidates, tables, metrics);
  addLocalIssueCandidate(candidates, region, tables, metrics, arch,
                         modelConfig);
  unsigned beamGuideCount = candidates.size();
  addCmaDmaPlacementCandidates(candidates, metrics);
  addSlicedCmaDmaPlacementCandidates(candidates, metrics, tables, arch);
  int64_t estimatedBeamWork =
      estimateGuidedBeamSearchWork(beamGuideCount, region.opCount);
  if (shouldRunBeamSearch(metrics, arch, modelConfig, enableBeamSearch,
                          estimatedBeamWork, limits)) {
    if (exceedsBeamWorkLimit(enableBeamSearch, estimatedBeamWork, limits)) {
      if (enableBeamSearch && limits.emitDiagnostics) {
        func::FuncOp func = region.func;
        llvm::errs() << kDiagPrefix << " skipped func=" << func.getSymName()
                     << " region=" << region.regionOrdinal
                     << " reason=max_beam_work"
                     << " estimated_work=" << estimatedBeamWork
                     << " limit=" << limits.maxBeamWork << "\n";
      }
      if (enableBeamSearch && limits.emitRemarks)
        emitScheduleBeamWorkRemark(region, estimatedBeamWork, limits);
    } else {
      addGuidedBeamCandidates(candidates, tables, metrics, region, budgets,
                              beamGuideCount);
    }
  }
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

static bool computeCandidatePressure(
    EvaluatedCandidate &candidate, const ScheduleRegion &region,
    const DependenceGraph &graph, const RegisterPressureBudgets &budgets,
    const SchedulePressureRegionContext *context) {
  if (!candidate.metrics.score.supported)
    return false;
  if (candidate.metrics.pressure.supported)
    return true;

  SmallVector<Operation *, 16> ops;
  StringRef fallbackReason;
  if (!buildCandidateOps(region, graph, candidate.order, ops, fallbackReason)) {
    candidate.metrics.pressure =
        makeUnsupportedRegisterPressureResult(fallbackReason);
    return false;
  }

  candidate.metrics.pressure =
      computeRegisterPressure(region, ops, budgets, context);
  return candidate.metrics.pressure.supported;
}

static bool usesIssueWindowTie(const EvaluatedCandidate &candidate) {
  static constexpr unsigned kMinIssueWindowTieOps = 128;
  return candidate.name == "issue_window" &&
         (candidate.metrics.originalCycleDelta < 0 ||
          candidate.order.size() >= kMinIssueWindowTieOps);
}

static std::optional<bool>
compareCriticalPressure(const EvaluatedCandidate &candidate,
                        const EvaluatedCandidate &best,
                        RegisterPressureBudgets budgets) {
  if (!budgets.selectionEnabled || !hasCriticalBudget(budgets))
    return std::nullopt;
  int64_t candidateExcess = getCriticalExcess(candidate.metrics.pressure);
  int64_t bestExcess = getCriticalExcess(best.metrics.pressure);
  if (candidateExcess != bestExcess)
    return candidateExcess < bestExcess;
  return std::nullopt;
}

static bool isCmaDmaPlacementName(StringRef name) {
  return name.starts_with("cma_dma_place_");
}

static bool isSlicedCmaDmaPlacementName(StringRef name) {
  return name.starts_with("cma_dma_place_sliced_p");
}

static bool isZeroPrefixSlicedCmaDmaPlacementName(StringRef name) {
  return name.starts_with("cma_dma_place_sliced_p0_");
}

static bool isBarrierPipelineName(StringRef name) {
  return name.starts_with("barrier_pipeline_");
}

static bool isBarrierMemoryPipelineName(StringRef name) {
  return name == "barrier_pipeline_ds_read_mfma" ||
         name == "barrier_pipeline_write_read_mfma" ||
         name == "barrier_pipeline_write_read_ds_mfma";
}

static bool isCmaDmaPlacementCandidate(const EvaluatedCandidate &candidate) {
  return isCmaDmaPlacementName(candidate.name);
}

static bool
isCounterBurstPlacementCandidate(const EvaluatedCandidate &candidate) {
  return isCmaDmaPlacementCandidate(candidate) ||
         isBarrierPipelineName(candidate.name);
}

static bool comparableOverflowCandidate(const EvaluatedCandidate &candidate,
                                        const EvaluatedCandidate &best) {
  return isCmaDmaPlacementCandidate(candidate) ||
         isCmaDmaPlacementCandidate(best);
}

static std::optional<bool>
compareEqualOverflow(const EvaluatedCandidate &candidate,
                     const EvaluatedCandidate &best) {
  if (!comparableOverflowCandidate(candidate, best))
    return false;
  int64_t candidateHard = getHardExcess(candidate.metrics.pressure);
  int64_t bestHard = getHardExcess(best.metrics.pressure);
  if (candidateHard != bestHard)
    return candidateHard < bestHard;
  int64_t candidateCritical = getCriticalExcess(candidate.metrics.pressure);
  int64_t bestCritical = getCriticalExcess(best.metrics.pressure);
  if (candidateCritical != bestCritical)
    return candidateCritical < bestCritical;
  return std::nullopt;
}

static std::optional<bool>
comparePressureViability(const EvaluatedCandidate &candidate,
                         const EvaluatedCandidate &best,
                         RegisterPressureBudgets budgets) {
  bool candidateViable = isPressureViable(candidate, budgets);
  bool bestViable = isPressureViable(best, budgets);
  if (candidateViable != bestViable)
    return candidateViable;
  if (!candidateViable)
    return compareEqualOverflow(candidate, best);
  return std::nullopt;
}

static int resourceTiePriority(const EvaluatedCandidate &candidate) {
  StringRef name(candidate.name);
  if (isBarrierMemoryPipelineName(name))
    return 3;
  if (isCmaDmaPlacementName(name))
    return 2;
  if (isBarrierPipelineName(name))
    return 1;
  if (usesIssueWindowTie(candidate))
    return 1;
  return 0;
}

static std::optional<bool>
compareResourceTie(const EvaluatedCandidate &candidate,
                   const EvaluatedCandidate &best) {
  int candidatePriority = resourceTiePriority(candidate);
  int bestPriority = resourceTiePriority(best);
  if (candidatePriority != bestPriority)
    return candidatePriority > bestPriority;
  return std::nullopt;
}

static int64_t rawScheduleCycles(const EvaluatedCandidate &candidate) {
  return candidate.metrics.score.cycles + candidate.metrics.hazardWaitCycles;
}

static int64_t adjustedScheduleCycles(const EvaluatedCandidate &candidate) {
  return rawScheduleCycles(candidate) + candidate.metrics.counterBurstCycles;
}

static bool hasLowerCounterBurst(const EvaluatedCandidate &candidate,
                                 const EvaluatedCandidate &original) {
  return candidate.metrics.counterBurstCycles <
         original.metrics.counterBurstCycles;
}

static bool hasSameCounterBurst(const EvaluatedCandidate &candidate,
                                const EvaluatedCandidate &original) {
  return candidate.metrics.counterBurstCycles ==
         original.metrics.counterBurstCycles;
}

static bool lowerCounterBurstEligible(const EvaluatedCandidate &candidate,
                                      bool isPlacement) {
  return isPlacement || candidate.metrics.originalCycleDelta < 0;
}

static bool sameCounterBurstRawEligible(const EvaluatedCandidate &candidate,
                                        bool isPlacement) {
  return !isPlacement && candidate.metrics.originalCycleDelta < 0;
}

static bool
sameCounterBurstAdjustedEligible(const EvaluatedCandidate &candidate,
                                 const EvaluatedCandidate &original) {
  int64_t neutralMinGain =
      std::max<int64_t>(1, original.metrics.counterBurstCycles / 8);
  int64_t adjustedCycleDelta =
      adjustedScheduleCycles(candidate) - adjustedScheduleCycles(original);
  return adjustedCycleDelta <= -neutralMinGain;
}

static bool counterBurstEligible(const EvaluatedCandidate &candidate,
                                 const EvaluatedCandidate &original) {
  if (candidate.name == "original" || original.metrics.counterBurstCycles == 0)
    return true;
  bool isPlacement = isCounterBurstPlacementCandidate(candidate);
  if (isBarrierPipelineName(candidate.name))
    return true;
  if (hasLowerCounterBurst(candidate, original))
    return lowerCounterBurstEligible(candidate, isPlacement);
  if (!hasSameCounterBurst(candidate, original))
    return false;
  if (sameCounterBurstRawEligible(candidate, isPlacement))
    return true;
  if (!isPlacement)
    return false;
  return sameCounterBurstAdjustedEligible(candidate, original);
}

static bool
isCounterNeutralPlacementCandidate(const EvaluatedCandidate &candidate,
                                   const EvaluatedCandidate &original) {
  return original.metrics.counterBurstCycles != 0 &&
         candidate.metrics.counterBurstCycles ==
             original.metrics.counterBurstCycles &&
         isCounterBurstPlacementCandidate(candidate) &&
         counterBurstEligible(candidate, original);
}

static std::optional<bool>
compareCounterNeutralPlacement(const EvaluatedCandidate &candidate,
                               const EvaluatedCandidate &best,
                               const EvaluatedCandidate *original) {
  if (!original)
    return std::nullopt;
  bool candidateNeutral =
      isCounterNeutralPlacementCandidate(candidate, *original);
  bool bestNeutral = isCounterNeutralPlacementCandidate(best, *original);
  if (candidateNeutral != bestNeutral)
    return candidateNeutral;
  if (!candidateNeutral)
    return std::nullopt;
  if (candidate.metrics.orderDisplacement != best.metrics.orderDisplacement)
    return candidate.metrics.orderDisplacement < best.metrics.orderDisplacement;
  return std::nullopt;
}

static std::optional<bool>
compareSlicedCmaDmaRawTie(const EvaluatedCandidate &candidate,
                          const EvaluatedCandidate &best) {
  StringRef candidateName(candidate.name);
  StringRef bestName(best.name);
  if (!isSlicedCmaDmaPlacementName(candidateName) ||
      !isSlicedCmaDmaPlacementName(bestName))
    return std::nullopt;
  if (rawScheduleCycles(candidate) != rawScheduleCycles(best))
    return std::nullopt;
  bool candidateZero = isZeroPrefixSlicedCmaDmaPlacementName(candidateName);
  bool bestZero = isZeroPrefixSlicedCmaDmaPlacementName(bestName);
  if (candidateZero != bestZero)
    return !candidateZero;
  return std::nullopt;
}

static bool
isBetterScheduleCandidate(const EvaluatedCandidate &candidate,
                          const EvaluatedCandidate &best,
                          RegisterPressureBudgets budgets,
                          const EvaluatedCandidate *original = nullptr) {
  if (std::optional<bool> better =
          comparePressureViability(candidate, best, budgets))
    return *better;
  if (std::optional<bool> better =
          compareCriticalPressure(candidate, best, budgets))
    return *better;
  if (std::optional<bool> better =
          compareCounterNeutralPlacement(candidate, best, original))
    return *better;
  if (std::optional<bool> better = compareSlicedCmaDmaRawTie(candidate, best))
    return *better;
  int64_t candidateCycles = adjustedScheduleCycles(candidate);
  int64_t bestCycles = adjustedScheduleCycles(best);
  if (candidateCycles != bestCycles)
    return candidateCycles < bestCycles;
  if (std::optional<bool> better = compareResourceTie(candidate, best))
    return *better;
  return false;
}

static CandidateMetrics evaluateOrderCandidate(
    const ScheduleRegion &region, const DependenceGraph &graph,
    const OrderCandidate &candidate, ArchResolution archResolution,
    const waveamdmachine::EventSimConfig &modelConfig,
    const RegisterPressureBudgets &budgets,
    PressureEvaluation pressureEvaluation,
    std::optional<RegisterPressureResult> safePressureUpperBound,
    const SchedulePressureRegionContext *context) {
  SmallVector<Operation *, 16> ops;
  StringRef fallbackReason;
  if (!buildCandidateOps(region, graph, candidate.order, ops, fallbackReason))
    return makeUnsupportedCandidateMetrics(fallbackReason);
  bool skipExactPressure =
      safePressureUpperBound ||
      pressureEvaluation == PressureEvaluation::LazyHardCap;
  PressureEvaluation initialPressure =
      skipExactPressure ? PressureEvaluation::None : pressureEvaluation;
  CandidateMetrics metrics;
  metrics.score = scoreOps(ops, archResolution, modelConfig);
  if (archResolution.arch) {
    metrics.counterBurstCycles =
        computeCounterBurstCycles(ops, *archResolution.arch, modelConfig);
    metrics.hazardWaitCycles =
        estimateHazardWaitCycles(ops, *archResolution.arch);
  }
  if (initialPressure == PressureEvaluation::Eager)
    metrics.pressure = computeRegisterPressure(region, ops, budgets, context);
  if (safePressureUpperBound && metrics.score.supported)
    metrics.pressure = *safePressureUpperBound;
  return metrics;
}

static void selectEagerPressureCandidate(ScheduleDecision &decision,
                                         RegisterPressureBudgets budgets) {
  const EvaluatedCandidate &original = decision.candidates.front();
  for (unsigned i = 1; i < decision.candidates.size(); ++i)
    if (!counterBurstEligible(decision.candidates[i], original))
      continue;
    else if (isBetterScheduleCandidate(decision.candidates[i],
                                       decision.candidates[decision.selected],
                                       budgets, &original))
      decision.selected = i;
}

static SmallVector<unsigned, 16>
collectSupportedCandidateIndices(ArrayRef<EvaluatedCandidate> candidates) {
  SmallVector<unsigned, 16> indices;
  for (auto [index, candidate] : llvm::enumerate(candidates))
    if (candidate.metrics.score.supported)
      indices.push_back(index);
  return indices;
}

static bool compareLazyHardCapSortKey(const ScheduleDecision &decision,
                                      unsigned lhs, unsigned rhs) {
  const EvaluatedCandidate &lhsCandidate = decision.candidates[lhs];
  const EvaluatedCandidate &rhsCandidate = decision.candidates[rhs];
  int64_t lhsCycles = adjustedScheduleCycles(lhsCandidate);
  int64_t rhsCycles = adjustedScheduleCycles(rhsCandidate);
  if (lhsCycles != rhsCycles)
    return lhsCycles < rhsCycles;
  if (std::optional<bool> better =
          compareResourceTie(lhsCandidate, rhsCandidate))
    return *better;
  return lhs < rhs;
}

static bool selectBestViableLazyCandidate(
    ScheduleDecision &decision, const ScheduleRegion &region,
    const DependenceGraph &graph, RegisterPressureBudgets budgets,
    const SchedulePressureRegionContext *context, ArrayRef<unsigned> indices) {
  const EvaluatedCandidate &original = decision.candidates.front();
  std::optional<unsigned> selected;
  for (unsigned index : indices) {
    EvaluatedCandidate &candidate = decision.candidates[index];
    computeCandidatePressure(candidate, region, graph, budgets, context);
    if (!counterBurstEligible(candidate, original))
      continue;
    if (!isPressureViable(candidate, budgets))
      continue;
    if (!selected ||
        isBetterScheduleCandidate(candidate, decision.candidates[*selected],
                                  budgets, &original))
      selected = index;
  }
  if (!selected)
    return false;
  decision.selected = *selected;
  return true;
}

static void selectBestFallbackLazyCandidate(ScheduleDecision &decision,
                                            RegisterPressureBudgets budgets,
                                            ArrayRef<unsigned> indices) {
  const EvaluatedCandidate &original = decision.candidates.front();
  for (unsigned index : indices)
    if (!counterBurstEligible(decision.candidates[index], original))
      continue;
    else if (isBetterScheduleCandidate(decision.candidates[index],
                                       decision.candidates[decision.selected],
                                       budgets, &original))
      decision.selected = index;
}

static void selectLazyHardCapCandidate(
    ScheduleDecision &decision, const ScheduleRegion &region,
    const DependenceGraph &graph, RegisterPressureBudgets budgets,
    const SchedulePressureRegionContext *context) {
  SmallVector<unsigned, 16> indices =
      collectSupportedCandidateIndices(decision.candidates);
  llvm::stable_sort(indices, [&](unsigned lhs, unsigned rhs) {
    return compareLazyHardCapSortKey(decision, lhs, rhs);
  });
  decision.selected = 0;
  if (selectBestViableLazyCandidate(decision, region, graph, budgets, context,
                                    indices))
    return;
  selectBestFallbackLazyCandidate(decision, budgets, indices);
}

static void selectScheduleCandidate(
    ScheduleDecision &decision, const ScheduleRegion &region,
    const DependenceGraph &graph, RegisterPressureBudgets budgets,
    PressureEvaluation pressureEvaluation,
    const SchedulePressureRegionContext *context) {
  switch (pressureEvaluation) {
  case PressureEvaluation::None:
  case PressureEvaluation::Eager:
    selectEagerPressureCandidate(decision, budgets);
    return;
  case PressureEvaluation::LazyHardCap:
    selectLazyHardCapCandidate(decision, region, graph, budgets, context);
    return;
  }
  llvm_unreachable("unknown pressure evaluation mode");
}

static uint64_t computeOrderDisplacement(ArrayRef<unsigned> order) {
  uint64_t displacement = 0;
  for (auto [ordinal, index] : llvm::enumerate(order)) {
    uint64_t lhs = static_cast<uint64_t>(ordinal);
    uint64_t rhs = static_cast<uint64_t>(index);
    displacement += lhs > rhs ? lhs - rhs : rhs - lhs;
  }
  return displacement;
}

static const SchedulePressureRegionContext *preparePressureRegionContext(
    const ScheduleRegion &region, PressureEvaluation pressureEvaluation,
    const SchedulePressureContext *&pressureContext,
    std::optional<SchedulePressureContext> &ownedPressureContext,
    std::optional<SchedulePressureRegionContext> &pressureRegionContext) {
  if (pressureEvaluation == PressureEvaluation::None)
    return nullptr;
  if (!pressureContext) {
    ownedPressureContext = buildSchedulePressureContext(region.func);
    pressureContext = &*ownedPressureContext;
  }
  pressureRegionContext =
      buildSchedulePressureRegionContext(region, pressureContext);
  return &*pressureRegionContext;
}

static std::optional<RegisterPressureResult>
tryGetSafePressureUpperBound(bool allowPressureUpperBound,
                             RegisterPressureBudgets budgets,
                             const SchedulePressureRegionContext *context) {
  if (!allowPressureUpperBound || !budgets.selectionEnabled || !context)
    return std::nullopt;
  return getSafePressureUpperBound(*context, budgets);
}

static RegisterPressureBudgets
getCandidateBudgets(RegisterPressureBudgets budgets,
                    std::optional<RegisterPressureResult> pressureUpperBound) {
  if (pressureUpperBound)
    budgets.selectionEnabled = false;
  return budgets;
}

static void appendEvaluatedCandidates(
    ScheduleDecision &decision, ArrayRef<OrderCandidate> candidates,
    const ScheduleRegion &region, const DependenceGraph &graph,
    ArchResolution archResolution,
    const waveamdmachine::EventSimConfig &modelConfig,
    const RegisterPressureBudgets &budgets,
    PressureEvaluation pressureEvaluation,
    std::optional<RegisterPressureResult> safePressureUpperBound,
    const SchedulePressureRegionContext *pressureRegionContext) {
  std::optional<int64_t> originalCycles;
  for (const OrderCandidate &candidate : candidates) {
    CandidateMetrics metrics = evaluateOrderCandidate(
        region, graph, candidate, archResolution, modelConfig, budgets,
        pressureEvaluation, safePressureUpperBound, pressureRegionContext);
    if (!originalCycles && candidate.name == "original" &&
        metrics.score.supported)
      originalCycles = metrics.score.cycles;
    if (originalCycles && metrics.score.supported)
      metrics.originalCycleDelta = metrics.score.cycles - *originalCycles;
    metrics.orderDisplacement = computeOrderDisplacement(candidate.order);
    decision.candidates.push_back(
        {candidate.order, std::move(metrics), candidate.name});
  }
}

ScheduleDecision evaluateScheduleCandidates(
    const ScheduleRegion &region, const DependenceGraph &graph,
    ArchResolution archResolution,
    const waveamdmachine::EventSimConfig &modelConfig,
    const RegisterPressureBudgets &budgets, bool enableBeamSearch,
    ScheduleSearchLimits limits, PressureEvaluation pressureEvaluation,
    bool allowPressureUpperBound,
    const SchedulePressureContext *pressureContext) {
  ScheduleDecision decision;
  if (!archResolution.arch) {
    decision.candidates.push_back(
        {getOriginalOrder(region),
         makeUnsupportedCandidateMetrics(archResolution.fallbackReason),
         "original"});
    return decision;
  }

  std::optional<SchedulePressureContext> ownedPressureContext;
  std::optional<SchedulePressureRegionContext> pressureRegionContext;
  const SchedulePressureRegionContext *pressureContextForRegion =
      preparePressureRegionContext(region, pressureEvaluation, pressureContext,
                                   ownedPressureContext, pressureRegionContext);

  std::optional<RegisterPressureResult> safePressureUpperBound =
      tryGetSafePressureUpperBound(allowPressureUpperBound, budgets,
                                   pressureContextForRegion);
  RegisterPressureBudgets candidateBudgets =
      getCandidateBudgets(budgets, safePressureUpperBound);
  SmallVector<OrderCandidate, 4> candidates =
      buildScheduleCandidates(region, graph, *archResolution.arch, modelConfig,
                              candidateBudgets, enableBeamSearch, limits);
  appendEvaluatedCandidates(decision, candidates, region, graph, archResolution,
                            modelConfig, budgets, pressureEvaluation,
                            safePressureUpperBound, pressureContextForRegion);
  selectScheduleCandidate(decision, region, graph, budgets, pressureEvaluation,
                          pressureContextForRegion);
  return decision;
}

ScheduleDecision evaluateScheduleOrderCandidates(
    const ScheduleRegion &region, const DependenceGraph &graph,
    ArrayRef<OrderCandidate> candidates, ArchResolution archResolution,
    const waveamdmachine::EventSimConfig &modelConfig,
    const RegisterPressureBudgets &budgets,
    PressureEvaluation pressureEvaluation, bool allowPressureUpperBound,
    const SchedulePressureContext *pressureContext) {
  ScheduleDecision decision;
  if (!archResolution.arch) {
    decision.candidates.push_back(
        {getOriginalOrder(region),
         makeUnsupportedCandidateMetrics(archResolution.fallbackReason),
         "original"});
    return decision;
  }

  std::optional<SchedulePressureContext> ownedPressureContext;
  std::optional<SchedulePressureRegionContext> pressureRegionContext;
  const SchedulePressureRegionContext *pressureContextForRegion =
      preparePressureRegionContext(region, pressureEvaluation, pressureContext,
                                   ownedPressureContext, pressureRegionContext);

  std::optional<RegisterPressureResult> safePressureUpperBound =
      tryGetSafePressureUpperBound(allowPressureUpperBound, budgets,
                                   pressureContextForRegion);
  appendEvaluatedCandidates(decision, candidates, region, graph, archResolution,
                            modelConfig, budgets, pressureEvaluation,
                            safePressureUpperBound, pressureContextForRegion);
  selectScheduleCandidate(decision, region, graph, budgets, pressureEvaluation,
                          pressureContextForRegion);
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
      if (candidate.metrics.counterBurstCycles != 0)
        llvm::errs() << " counter_burst_cycles="
                     << candidate.metrics.counterBurstCycles;
      if (candidate.metrics.hazardWaitCycles != 0)
        llvm::errs() << " hazard_wait_cycles="
                     << candidate.metrics.hazardWaitCycles;
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
    if (selected.metrics.counterBurstCycles != 0)
      llvm::errs() << " selected_counter_burst_cycles="
                   << selected.metrics.counterBurstCycles;
    if (selected.metrics.hazardWaitCycles != 0)
      llvm::errs() << " selected_hazard_wait_cycles="
                   << selected.metrics.hazardWaitCycles;
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
  return isBetterScheduleCandidate(selected, original, budgets, &original) &&
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
