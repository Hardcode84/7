//===- WaveAMDMachineSchedule.cpp - WaveAMDMachine scheduler ----*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

// Scheduler design:
// - Split funcs into straight-line local regions. Control flow, waitcnt,
//   barriers, priority changes, nested regions, and unknown effects bound them.
// - Legal motion follows SSA and explicit mem-token edges. Memory ops without
//   a token edge are independent for this pass.
// - Candidate orders are deterministic permutations of one region. Loop-carried
//   recurrence edges are diagnostics, not intra-iteration ordering constraints.
// - Cost code ranks legal candidates only. Rewriting requires a strict win over
//   original order and never repairs an illegal candidate.

#include "mlir/Dialect/Wave/Transforms/Passes.h"

#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/WaveAMDMachine/CostModel/ArchData.h"
#include "mlir/Dialect/WaveAMDMachine/CostModel/EventSimulator.h"
#include "mlir/Dialect/WaveAMDMachine/CostModel/FunctionalUnit.h"
#include "mlir/Dialect/WaveAMDMachine/CostModel/LatencyTable.h"
#include "mlir/Dialect/WaveAMDMachine/CostModel/OpClassifier.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachine.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachineTraits.h"
#include "mlir/IR/BuiltinOps.h"
#include "mlir/IR/Operation.h"
#include "mlir/Interfaces/SideEffectInterfaces.h"
#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/TargetParser/TargetParser.h"

#include <algorithm>
#include <limits>

namespace mlir::wave {
#define GEN_PASS_DEF_WAVEAMDMACHINESCHEDULE
#include "mlir/Dialect/Wave/Transforms/Passes.h.inc"
} // namespace mlir::wave

using namespace mlir;

namespace {

namespace traits = ::mlir::OpTrait::waveamdmachine;

struct ScheduleRegion {
  func::FuncOp func;
  unsigned blockOrdinal = 0;
  unsigned regionOrdinal = 0;
  Operation *first = nullptr;
  Operation *last = nullptr;
  unsigned opCount = 0;
  SmallVector<Operation *, 16> ops;
};

enum class EdgeKind {
  Ssa,
  MemToken,
  LoopCarry,
};

struct ScheduleEdge {
  unsigned src = 0;
  unsigned dst = 0;
  EdgeKind kind = EdgeKind::Ssa;
  bool recurrence = false;
};

struct DependenceGraph {
  SmallVector<ScheduleEdge, 32> edges;
};

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

static StringRef getEdgeKindName(EdgeKind kind) {
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

static void printRegion(ScheduleRegion region) {
  llvm::errs() << "waveamd-machine-schedule region func="
               << region.func.getSymName() << " block=" << region.blockOrdinal
               << " region=" << region.regionOrdinal
               << " ops=" << region.opCount
               << " first=" << region.first->getName().getStringRef()
               << " last=" << region.last->getName().getStringRef() << "\n";
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

static DependenceGraph buildDependenceGraph(const ScheduleRegion &region) {
  DependenceGraph graph;
  DenseMap<Operation *, unsigned> nodeForOp;
  for (auto [index, op] : llvm::enumerate(region.ops))
    nodeForOp[op] = index;

  addValueEdges(region, graph, nodeForOp);
  addLoopCarryEdges(region, graph, nodeForOp);
  return graph;
}

static void printDependences(ScheduleRegion region,
                             const DependenceGraph &graph) {
  llvm::errs() << "waveamd-machine-schedule deps func="
               << region.func.getSymName() << " region=" << region.regionOrdinal
               << " nodes=" << region.ops.size()
               << " edges=" << graph.edges.size() << "\n";
  for (const ScheduleEdge &edge : graph.edges) {
    Operation *src = region.ops[edge.src];
    Operation *dst = region.ops[edge.dst];
    llvm::errs() << "waveamd-machine-schedule edge region="
                 << region.regionOrdinal
                 << " kind=" << getEdgeKindName(edge.kind);
    if (edge.recurrence)
      llvm::errs() << " recurrence";
    llvm::errs() << " " << edge.src << "->" << edge.dst
                 << " src=" << src->getName().getStringRef()
                 << " dst=" << dst->getName().getStringRef() << "\n";
  }
}

struct ArchResolution {
  const waveamdmachine::ArchData *arch = nullptr;
  StringRef fallbackReason;
};

static ArchResolution resolveArch(Operation *op) {
  ModuleOp mod = op->getParentOfType<ModuleOp>();
  if (!mod)
    mod = dyn_cast<ModuleOp>(op);
  while (mod) {
    StringAttr target = mod->getAttrOfType<StringAttr>("waveamdmachine.target");
    if (target) {
      StringRef tripleAndChip = target.getValue();
      size_t pos = tripleAndChip.rfind("--");
      StringRef chip = pos == StringRef::npos
                           ? tripleAndChip
                           : tripleAndChip.drop_front(pos + 2);
      llvm::AMDGPU::IsaVersion isa = llvm::AMDGPU::getIsaVersion(chip);
      if (!waveamdmachine::isArchSupported(isa))
        return {nullptr, "unsupported_arch"};
      return {&waveamdmachine::getArchData(isa), {}};
    }
    mod = mod->getParentOfType<ModuleOp>();
  }
  return {nullptr, "missing_target"};
}

struct ScoreResult {
  bool supported = false;
  int64_t cycles = 0;
  int64_t issuedOps = 0;
  StringRef fallbackReason;
};

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

static void printScoreLine(ScheduleRegion region, StringRef orderName,
                           ScoreResult score) {
  llvm::errs() << "waveamd-machine-schedule score func="
               << region.func.getSymName() << " region=" << region.regionOrdinal
               << " order=" << orderName;
  if (score.supported) {
    llvm::errs() << " cycles=" << score.cycles
                 << " issued_ops=" << score.issuedOps;
  } else {
    llvm::errs() << " fallback=original reason=" << score.fallbackReason;
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

struct CandidateRequest {
  bool requested = false;
  bool parsed = false;
  SmallVector<unsigned, 16> order;
  StringRef fallbackReason;
};

static CandidateRequest getCandidateRequest(StringRef orderText,
                                            int scoreRegion) {
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

static bool shouldScoreCandidate(const ScheduleRegion &region,
                                 StringRef scoreFunc, int scoreRegion) {
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

static ScoreResult
scoreCandidateOps(const ScheduleRegion &region, const DependenceGraph &graph,
                  const CandidateRequest &candidate,
                  ArchResolution archResolution,
                  const waveamdmachine::EventSimConfig &modelConfig) {
  if (!candidate.parsed)
    return {false, 0, 0, candidate.fallbackReason};

  SmallVector<Operation *, 16> candidateOps;
  StringRef fallbackReason;
  if (!buildCandidateOps(region, graph, candidate.order, candidateOps,
                         fallbackReason))
    return {false, 0, 0, fallbackReason};

  return scoreOps(candidateOps, archResolution, modelConfig);
}

static void printRegionScores(const ScheduleRegion &region,
                              const DependenceGraph &graph,
                              ArchResolution archResolution,
                              const waveamdmachine::EventSimConfig &modelConfig,
                              const CandidateRequest &candidate,
                              bool scoreCandidate) {
  printScoreLine(region, "original",
                 scoreOps(region.ops, archResolution, modelConfig));
  if (!scoreCandidate)
    return;
  printScoreLine(
      region, "candidate",
      scoreCandidateOps(region, graph, candidate, archResolution, modelConfig));
}

struct GraphTables {
  SmallVector<SmallVector<unsigned, 4>, 16> successors;
  SmallVector<unsigned, 16> pendingPreds;
};

static GraphTables buildGraphTables(const ScheduleRegion &region,
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

struct NodeMetrics {
  int latency = 0;
  int64_t criticalPath = 0;
  bool memory = false;
  bool reachesMemory = false;
  bool matrix = false;
  bool reachesMatrix = false;
};

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

static SmallVector<NodeMetrics, 16>
computeNodeMetrics(const ScheduleRegion &region, const GraphTables &tables,
                   const waveamdmachine::ArchData &arch) {
  SmallVector<NodeMetrics, 16> metrics(region.ops.size());
  for (auto [index, op] : llvm::enumerate(region.ops)) {
    waveamdmachine::SchedClass cls = waveamdmachine::classifyOp(op);
    metrics[index].latency = waveamdmachine::getLatency(arch, cls);
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

enum class SchedulePolicy {
  CriticalPath,
  MemoryEarly,
  MatrixFeed,
};

static int memoryPriority(const NodeMetrics &metrics) {
  if (metrics.memory)
    return 3;
  if (metrics.reachesMemory)
    return 2;
  if (metrics.latency >= 20)
    return 1;
  return 0;
}

static int matrixPriority(const NodeMetrics &metrics) {
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

static bool buildListOrder(const GraphTables &tables,
                           ArrayRef<NodeMetrics> metrics, SchedulePolicy policy,
                           SmallVectorImpl<unsigned> &order) {
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

struct OrderCandidate {
  StringRef name;
  SmallVector<unsigned, 16> order;
};

static SmallVector<unsigned, 16>
getOriginalOrder(const ScheduleRegion &region) {
  SmallVector<unsigned, 16> order;
  for (unsigned i = 0; i < region.ops.size(); ++i)
    order.push_back(i);
  return order;
}

static void addPolicyCandidate(SmallVectorImpl<OrderCandidate> &candidates,
                               StringRef name, const GraphTables &tables,
                               ArrayRef<NodeMetrics> metrics,
                               SchedulePolicy policy) {
  OrderCandidate candidate;
  candidate.name = name;
  if (!buildListOrder(tables, metrics, policy, candidate.order))
    return;
  candidates.push_back(std::move(candidate));
}

static SmallVector<OrderCandidate, 4>
buildScheduleCandidates(const ScheduleRegion &region,
                        const DependenceGraph &graph,
                        const waveamdmachine::ArchData &arch) {
  SmallVector<OrderCandidate, 4> candidates;
  candidates.push_back({"original", getOriginalOrder(region)});

  GraphTables tables = buildGraphTables(region, graph);
  SmallVector<NodeMetrics, 16> metrics =
      computeNodeMetrics(region, tables, arch);
  addPolicyCandidate(candidates, "critical_path", tables, metrics,
                     SchedulePolicy::CriticalPath);
  addPolicyCandidate(candidates, "memory_early", tables, metrics,
                     SchedulePolicy::MemoryEarly);
  addPolicyCandidate(candidates, "wmma_feed", tables, metrics,
                     SchedulePolicy::MatrixFeed);
  return candidates;
}

struct EvaluatedCandidate {
  StringRef name;
  SmallVector<unsigned, 16> order;
  ScoreResult score;
};

struct ScheduleDecision {
  SmallVector<EvaluatedCandidate, 4> candidates;
  unsigned selected = 0;
};

static bool isOriginalOrder(ArrayRef<unsigned> order) {
  for (auto [index, opIndex] : llvm::enumerate(order))
    if (index != opIndex)
      return false;
  return true;
}

static ScoreResult
scoreOrderCandidate(const ScheduleRegion &region, const DependenceGraph &graph,
                    const OrderCandidate &candidate,
                    ArchResolution archResolution,
                    const waveamdmachine::EventSimConfig &modelConfig) {
  SmallVector<Operation *, 16> ops;
  StringRef fallbackReason;
  if (!buildCandidateOps(region, graph, candidate.order, ops, fallbackReason))
    return {false, 0, 0, fallbackReason};
  return scoreOps(ops, archResolution, modelConfig);
}

static ScheduleDecision
evaluateScheduleCandidates(const ScheduleRegion &region,
                           const DependenceGraph &graph,
                           ArchResolution archResolution,
                           const waveamdmachine::EventSimConfig &modelConfig) {
  ScheduleDecision decision;
  if (!archResolution.arch) {
    decision.candidates.push_back(
        {"original",
         getOriginalOrder(region),
         {false, 0, 0, archResolution.fallbackReason}});
    return decision;
  }

  SmallVector<OrderCandidate, 4> candidates =
      buildScheduleCandidates(region, graph, *archResolution.arch);
  for (const OrderCandidate &candidate : candidates)
    decision.candidates.push_back(
        {candidate.name, candidate.order,
         scoreOrderCandidate(region, graph, candidate, archResolution,
                             modelConfig)});

  for (unsigned i = 1; i < decision.candidates.size(); ++i) {
    const ScoreResult &best = decision.candidates[decision.selected].score;
    const ScoreResult &score = decision.candidates[i].score;
    if (!score.supported)
      continue;
    if (!best.supported || score.cycles < best.cycles)
      decision.selected = i;
  }
  return decision;
}

static void printOrder(raw_ostream &os, ArrayRef<unsigned> order) {
  for (auto [index, opIndex] : llvm::enumerate(order)) {
    if (index != 0)
      os << ",";
    os << opIndex;
  }
}

static void printCandidateDiagnostics(ScheduleRegion region,
                                      const ScheduleDecision &decision) {
  ScoreResult original = decision.candidates.front().score;
  for (const EvaluatedCandidate &candidate : decision.candidates) {
    llvm::errs() << "waveamd-machine-schedule candidate func="
                 << region.func.getSymName()
                 << " region=" << region.regionOrdinal
                 << " name=" << candidate.name;
    if (candidate.score.supported) {
      llvm::errs() << " cycles=" << candidate.score.cycles;
      if (original.supported)
        llvm::errs() << " delta=" << candidate.score.cycles - original.cycles;
      llvm::errs() << " issued_ops=" << candidate.score.issuedOps;
    } else {
      llvm::errs() << " fallback=original reason="
                   << candidate.score.fallbackReason;
    }
    llvm::errs() << " order=";
    printOrder(llvm::errs(), candidate.order);
    llvm::errs() << "\n";
  }
}

static void printScheduleDecision(ScheduleRegion region,
                                  const ScheduleDecision &decision,
                                  bool willApply) {
  const EvaluatedCandidate &selected = decision.candidates[decision.selected];
  ScoreResult original = decision.candidates.front().score;
  llvm::errs() << "waveamd-machine-schedule selected func="
               << region.func.getSymName() << " region=" << region.regionOrdinal
               << " name=" << selected.name;
  if (selected.score.supported) {
    llvm::errs() << " original_cycles=" << original.cycles
                 << " selected_cycles=" << selected.score.cycles
                 << " delta=" << selected.score.cycles - original.cycles;
  } else {
    llvm::errs() << " fallback=original reason="
                 << selected.score.fallbackReason;
  }
  llvm::errs() << " action=" << (willApply ? "apply" : "keep") << " order=";
  printOrder(llvm::errs(), selected.order);
  llvm::errs() << "\n";
}

static bool shouldApplyDecision(const ScheduleDecision &decision) {
  if (decision.candidates.empty() || decision.selected == 0)
    return false;
  const EvaluatedCandidate &original = decision.candidates.front();
  const EvaluatedCandidate &selected = decision.candidates[decision.selected];
  return original.score.supported && selected.score.supported &&
         selected.score.cycles < original.score.cycles &&
         !isOriginalOrder(selected.order);
}

static void applyScheduleOrder(const ScheduleRegion &region,
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

struct WaveAMDMachineSchedulePass
    : public wave::impl::WaveAMDMachineScheduleBase<
          WaveAMDMachineSchedulePass> {
  using WaveAMDMachineScheduleBase::WaveAMDMachineScheduleBase;

  void runOnOperation() override {
    ModuleOp mod = getOperation();
    ArchResolution archResolution = resolveArch(mod);
    waveamdmachine::EventSimConfig modelConfig;
    if (modelWaves <= 0) {
      mod.emitError() << "model-waves must be positive";
      return signalPassFailure();
    }
    if (modelSimds <= 0) {
      mod.emitError() << "model-simds must be positive";
      return signalPassFailure();
    }
    if (modelStartDelay < 0) {
      mod.emitError() << "model-start-delay must be non-negative";
      return signalPassFailure();
    }
    modelConfig.waves = modelWaves;
    modelConfig.simds = modelSimds;
    modelConfig.startDelay = modelStartDelay;
    CandidateRequest candidate =
        getCandidateRequest(StringRef(scoreOrder), scoreRegion);
    bool emitScores = printScore || candidate.requested;
    bool runScheduler = printCandidates || applySchedule;
    StringRef scoreFuncName(scoreFunc);
    mod.walk([&](func::FuncOp func) {
      if (func.isExternal())
        return;
      SmallVector<ScheduleRegion> regions = RegionCollector(func).collect();
      for (const ScheduleRegion &region : regions)
        processRegion(region, archResolution, modelConfig, candidate,
                      scoreFuncName, emitScores, runScheduler);
    });
  }

  void processRegion(const ScheduleRegion &region,
                     ArchResolution archResolution,
                     const waveamdmachine::EventSimConfig &modelConfig,
                     const CandidateRequest &candidate, StringRef scoreFuncName,
                     bool emitScores, bool runScheduler) {
    bool scoreCandidate =
        candidate.requested &&
        shouldScoreCandidate(region, scoreFuncName, scoreRegion);
    DependenceGraph graph;
    if (printDeps || scoreCandidate || runScheduler)
      graph = buildDependenceGraph(region);
    if (printRegions)
      printRegion(region);
    if (printDeps)
      printDependences(region, graph);
    if (emitScores)
      printRegionScores(region, graph, archResolution, modelConfig, candidate,
                        scoreCandidate);
    if (runScheduler)
      processScheduler(region, graph, archResolution, modelConfig);
  }

  void processScheduler(const ScheduleRegion &region,
                        const DependenceGraph &graph,
                        ArchResolution archResolution,
                        const waveamdmachine::EventSimConfig &modelConfig) {
    ScheduleDecision decision =
        evaluateScheduleCandidates(region, graph, archResolution, modelConfig);
    bool willApply = applySchedule && shouldApplyDecision(decision);
    if (printCandidates) {
      printCandidateDiagnostics(region, decision);
      printScheduleDecision(region, decision, willApply);
    }
    if (willApply)
      applyScheduleOrder(region, decision.candidates[decision.selected].order);
  }
};

} // namespace
