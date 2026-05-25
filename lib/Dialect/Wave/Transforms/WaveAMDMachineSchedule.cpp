//===- WaveAMDMachineSchedule.cpp - WaveAMDMachine scheduler ----*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/Wave/Transforms/Passes.h"

#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachine.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachineTraits.h"
#include "mlir/IR/BuiltinOps.h"
#include "mlir/IR/Operation.h"
#include "mlir/Interfaces/SideEffectInterfaces.h"
#include "llvm/ADT/DenseMap.h"
#include "llvm/Support/raw_ostream.h"

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

struct ScheduleDag {
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

static void addEdge(ScheduleDag &dag, unsigned src, unsigned dst, EdgeKind kind,
                    bool recurrence = false) {
  if (src == dst)
    return;
  for (const ScheduleEdge &edge : dag.edges)
    if (edge.src == src && edge.dst == dst && edge.kind == kind &&
        edge.recurrence == recurrence)
      return;
  dag.edges.push_back({src, dst, kind, recurrence});
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

static void addValueEdges(const ScheduleRegion &region, ScheduleDag &dag,
                          DenseMap<Operation *, unsigned> &nodeForOp) {
  for (auto [dstIndex, op] : llvm::enumerate(region.ops)) {
    for (Value operand : op->getOperands()) {
      Operation *def = operand.getDefiningOp();
      if (!def)
        continue;
      auto it = nodeForOp.find(def);
      if (it == nodeForOp.end())
        continue;
      addEdge(dag, it->second, dstIndex,
              isMemToken(operand) ? EdgeKind::MemToken : EdgeKind::Ssa);
    }
  }
}

static void addLoopCarryEdges(const ScheduleRegion &region, ScheduleDag &dag,
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
      addEdge(dag, it->second, userIndex, EdgeKind::LoopCarry,
              /*recurrence=*/true);
    }
  }
}

static ScheduleDag buildDag(const ScheduleRegion &region) {
  ScheduleDag dag;
  DenseMap<Operation *, unsigned> nodeForOp;
  for (auto [index, op] : llvm::enumerate(region.ops))
    nodeForOp[op] = index;

  addValueEdges(region, dag, nodeForOp);
  addLoopCarryEdges(region, dag, nodeForOp);
  return dag;
}

static void printScheduleDag(ScheduleRegion region, const ScheduleDag &dag) {
  llvm::errs() << "waveamd-machine-schedule dag func="
               << region.func.getSymName() << " region=" << region.regionOrdinal
               << " nodes=" << region.ops.size()
               << " edges=" << dag.edges.size() << "\n";
  for (const ScheduleEdge &edge : dag.edges) {
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

struct WaveAMDMachineSchedulePass
    : public wave::impl::WaveAMDMachineScheduleBase<
          WaveAMDMachineSchedulePass> {
  using WaveAMDMachineScheduleBase::WaveAMDMachineScheduleBase;

  void runOnOperation() override {
    ModuleOp mod = getOperation();
    mod.walk([&](func::FuncOp func) {
      if (func.isExternal())
        return;
      SmallVector<ScheduleRegion> regions = RegionCollector(func).collect();
      for (const ScheduleRegion &region : regions) {
        if (printRegions)
          printRegion(region);
        if (printDag)
          printScheduleDag(region, buildDag(region));
      }
    });
  }
};

} // namespace
