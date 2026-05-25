//===- WaveAMDMachineSchedule.cpp - WaveAMDMachine scheduler ----*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/Wave/Transforms/Passes.h"

#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/WaveAMDMachine/CostModel/ArchData.h"
#include "mlir/Dialect/WaveAMDMachine/CostModel/EventSimulator.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachine.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachineTraits.h"
#include "mlir/IR/BuiltinOps.h"
#include "mlir/IR/Operation.h"
#include "mlir/Interfaces/SideEffectInterfaces.h"
#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/TargetParser/TargetParser.h"

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
                            ArchResolution archResolution) {
  if (!archResolution.arch)
    return {false, 0, 0, archResolution.fallbackReason};

  waveamdmachine::EventSimConfig config;
  config.waves = 1;
  config.simds = 1;

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

static ScoreResult scoreCandidateOps(const ScheduleRegion &region,
                                     const DependenceGraph &graph,
                                     const CandidateRequest &candidate,
                                     ArchResolution archResolution) {
  if (!candidate.parsed)
    return {false, 0, 0, candidate.fallbackReason};

  SmallVector<Operation *, 16> candidateOps;
  StringRef fallbackReason;
  if (!buildCandidateOps(region, graph, candidate.order, candidateOps,
                         fallbackReason))
    return {false, 0, 0, fallbackReason};

  return scoreOps(candidateOps, archResolution);
}

static void printRegionScores(const ScheduleRegion &region,
                              const DependenceGraph &graph,
                              ArchResolution archResolution,
                              const CandidateRequest &candidate,
                              bool scoreCandidate) {
  printScoreLine(region, "original", scoreOps(region.ops, archResolution));
  if (!scoreCandidate)
    return;
  printScoreLine(region, "candidate",
                 scoreCandidateOps(region, graph, candidate, archResolution));
}

struct WaveAMDMachineSchedulePass
    : public wave::impl::WaveAMDMachineScheduleBase<
          WaveAMDMachineSchedulePass> {
  using WaveAMDMachineScheduleBase::WaveAMDMachineScheduleBase;

  void runOnOperation() override {
    ModuleOp mod = getOperation();
    ArchResolution archResolution = resolveArch(mod);
    CandidateRequest candidate =
        getCandidateRequest(StringRef(scoreOrder), scoreRegion);
    bool emitScores = printScore || candidate.requested;
    StringRef scoreFuncName(scoreFunc);
    mod.walk([&](func::FuncOp func) {
      if (func.isExternal())
        return;
      SmallVector<ScheduleRegion> regions = RegionCollector(func).collect();
      for (const ScheduleRegion &region : regions)
        processRegion(region, archResolution, candidate, scoreFuncName,
                      emitScores);
    });
  }

  void processRegion(const ScheduleRegion &region,
                     ArchResolution archResolution,
                     const CandidateRequest &candidate, StringRef scoreFuncName,
                     bool emitScores) {
    bool scoreCandidate =
        candidate.requested &&
        shouldScoreCandidate(region, scoreFuncName, scoreRegion);
    DependenceGraph graph;
    if (printDeps || scoreCandidate)
      graph = buildDependenceGraph(region);
    if (printRegions)
      printRegion(region);
    if (printDeps)
      printDependences(region, graph);
    if (emitScores)
      printRegionScores(region, graph, archResolution, candidate,
                        scoreCandidate);
  }
};

} // namespace
