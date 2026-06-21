//===- PressureAnalysis.cpp - Dense forward dataflow over MachineState ---===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/WaveAMDMachine/CostModel/PressureAnalysis.h"

#include "mlir/Analysis/DataFlow/DenseAnalysis.h"
#include "mlir/Analysis/DataFlow/Utils.h"
#include "mlir/Analysis/DataFlowFramework.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/WaveAMDMachine/CostModel/ArchData.h"
#include "mlir/Dialect/WaveAMDMachine/CostModel/FunctionalUnit.h"
#include "mlir/Dialect/WaveAMDMachine/CostModel/LatencyTable.h"
#include "mlir/Dialect/WaveAMDMachine/CostModel/OpClassifier.h"
#include "mlir/Dialect/WaveAMDMachine/CostModel/SchedClass.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachine.h"
#include "mlir/IR/Operation.h"
#include "mlir/Interfaces/ControlFlowInterfaces.h"
#include "llvm/Support/raw_ostream.h"

#include <algorithm>

namespace mlir::waveamdmachine {

namespace {

// Lattice cell: a (cold, hot) tuple of relative-pendings
// MachineState. The default meet joins both components
// symmetrically; per-edge overrides in PressureAnalysis route
// backedges through only the hot component.
class PressureLattice : public mlir::dataflow::AbstractDenseLattice {
public:
  MLIR_DEFINE_EXPLICIT_INTERNAL_INLINE_TYPE_ID(PressureLattice)

  using AbstractDenseLattice::AbstractDenseLattice;

  MachineState cold;
  MachineState hot;

  ChangeResult meet(const AbstractDenseLattice &rhs) override {
    const auto &rhsLat = static_cast<const PressureLattice &>(rhs);
    bool c1 = cold.join(rhsLat.cold);
    bool c2 = hot.join(rhsLat.hot);
    return (c1 || c2) ? ChangeResult::Change : ChangeResult::NoChange;
  }

  void print(llvm::raw_ostream &os) const override {
    os << "PressureLattice{cold.maxFu=" << cold.maxFuPending()
       << ", hot.maxFu=" << hot.maxFuPending() << "}";
  }
};

// Apply the relative-pendings per-op transfer to a single
// MachineState. Returns Change always (we always mutate).
static ChangeResult applyTransferTo(MachineState &state, Operation *op,
                                    const ArchData &arch) {
  SchedClass cls = classifyOp(op);

  int operandWait = 0;
  for (Value v : op->getOperands()) {
    auto it = state.valPending.find(v);
    if (it != state.valPending.end())
      operandWait = std::max(operandWait, it->second);
  }

  if (cls == SchedClass::NoInst) {
    // Pseudo: results inherit operand wait, no time advance.
    for (Value r : op->getResults())
      state.valPending[r] = operandWait;
    return ChangeResult::Change;
  }

  FunctionalUnit fu = funit(arch, cls);
  int latency = getLatency(arch, cls);
  int fuWait = (fu == FunctionalUnit::None)
                   ? 0
                   : state.fuPending[static_cast<size_t>(fu)];
  int wait = std::max(fuWait, operandWait);
  state.advance(wait);
  if (fu != FunctionalUnit::None)
    state.fuPending[static_cast<size_t>(fu)] = 1;
  for (Value r : op->getResults())
    state.valPending[r] = latency;
  return ChangeResult::Change;
}

// Forward dataflow that propagates the cold/hot lattice. Per-op
// transfer applies to both components; back-edge override drops
// the cold component.
class PressureAnalysis
    : public mlir::dataflow::DenseForwardDataFlowAnalysis<PressureLattice> {
public:
  MLIR_DEFINE_EXPLICIT_INTERNAL_INLINE_TYPE_ID(PressureAnalysis)

  PressureAnalysis(DataFlowSolver &solver, const ArchData &arch)
      : DenseForwardDataFlowAnalysis(solver), arch(arch) {}

  LogicalResult visitOperation(Operation *op, const PressureLattice &before,
                               PressureLattice *after) override {
    ChangeResult cr = after->meet(before);
    if (isa<WaveAMDMachineDialect>(op->getDialect())) {
      cr |= applyTransferTo(after->cold, op, arch);
      cr |= applyTransferTo(after->hot, op, arch);
    }
    propagateIfChanged(after, cr);
    return success();
  }

  void setToEntryState(PressureLattice *lattice) override {
    lattice->cold.fuPending = {};
    lattice->cold.valPending.clear();
    lattice->hot.fuPending = {};
    lattice->hot.valPending.clear();
    propagateIfChanged(lattice, ChangeResult::Change);
  }

  // Override region-branch transfer for `uniform_loop`. Three
  // edge kinds matter:
  //   - parent -> body  (loop entry): after.cold = collapse of
  //     before.cold and before.hot (max -- either outer flavor
  //     could be reaching iter 1 of this loop). after.hot stays
  //     untouched; only the back-edge populates it.
  //   - body -> body    (back-edge): only after.hot.join(before.hot).
  //     cold does not loop back by construction.
  //   - body -> parent  (loop exit): after.cold = collapse of
  //     body-exit cold and hot (covers both T=1 and T>1).
  //     after.hot = before.hot for now (pessimistic upper bound;
  //     proper enclosing-hot lookup is a follow-up).
  void visitRegionBranchControlFlowTransfer(RegionBranchOpInterface branch,
                                            std::optional<unsigned> regionFrom,
                                            std::optional<unsigned> regionTo,
                                            const PressureLattice &before,
                                            PressureLattice *after) override {
    if (auto loop = dyn_cast<UniformLoopOp>(branch.getOperation())) {
      if (handleUniformLoopEdge(loop, regionFrom, regionTo, before, after))
        return;
    }
    DenseForwardDataFlowAnalysis::visitRegionBranchControlFlowTransfer(
        branch, regionFrom, regionTo, before, after);
  }

private:
  bool handleUniformLoopEdge(UniformLoopOp loop,
                             std::optional<unsigned> regionFrom,
                             std::optional<unsigned> regionTo,
                             const PressureLattice &before,
                             PressureLattice *after);

  // Per-edge-kind helpers; each returns true to indicate the
  // edge was handled (caller skips the default symmetric meet).
  void propagateLoopEntry(const PressureLattice &before,
                          PressureLattice *after);
  void propagateBackEdge(const PressureLattice &before, PressureLattice *after);
  void propagateLoopExit(const PressureLattice &before, PressureLattice *after);

  const ArchData &arch;
};

bool PressureAnalysis::handleUniformLoopEdge(UniformLoopOp loop,
                                             std::optional<unsigned> regionFrom,
                                             std::optional<unsigned> regionTo,
                                             const PressureLattice &before,
                                             PressureLattice *after) {
  (void)loop;
  if (!regionFrom && regionTo == 0u) {
    propagateLoopEntry(before, after);
    return true;
  }
  if (regionFrom == 0u && regionTo == 0u) {
    propagateBackEdge(before, after);
    return true;
  }
  if (regionFrom == 0u && !regionTo) {
    propagateLoopExit(before, after);
    return true;
  }
  // parent->parent (entry_cond=false skip): default symmetric meet.
  return false;
}

void PressureAnalysis::propagateLoopEntry(const PressureLattice &before,
                                          PressureLattice *after) {
  // Collapse pre-loop cold and hot into iter-1 cold. `after->hot`
  // stays untouched -- only the back-edge populates it.
  MachineState collapse = before.cold;
  collapse.join(before.hot);
  bool changed = after->cold.join(collapse);
  propagateIfChanged(after,
                     changed ? ChangeResult::Change : ChangeResult::NoChange);
}

void PressureAnalysis::propagateBackEdge(const PressureLattice &before,
                                         PressureLattice *after) {
  bool changed = after->hot.join(before.hot);
  propagateIfChanged(after,
                     changed ? ChangeResult::Change : ChangeResult::NoChange);
}

void PressureAnalysis::propagateLoopExit(const PressureLattice &before,
                                         PressureLattice *after) {
  // Collapse body-exit cold and hot into downstream cold (handles
  // both T=1 and T>1 without branching). after.hot pessimistically
  // inherits before.hot -- proper enclosing-hot lookup via
  // getOrCreateFor is a follow-up.
  MachineState collapse = before.cold;
  collapse.join(before.hot);
  bool c1 = after->cold.join(collapse);
  bool c2 = after->hot.join(before.hot);
  propagateIfChanged(after, (c1 || c2) ? ChangeResult::Change
                                       : ChangeResult::NoChange);
}

// Compute the wait time `op` would incur given the relative state
// just before it. Mirrors the wait computation in applyTransferTo
// but does not mutate. Used by the total-cycles accumulator.
static int waitForOp(Operation *op, const MachineState &state,
                     const ArchData &arch) {
  SchedClass cls = classifyOp(op);
  if (cls == SchedClass::NoInst)
    return 0;
  FunctionalUnit fu = funit(arch, cls);
  int fuWait = (fu == FunctionalUnit::None)
                   ? 0
                   : state.fuPending[static_cast<size_t>(fu)];
  int operandWait = 0;
  for (Value v : op->getOperands()) {
    auto it = state.valPending.find(v);
    if (it != state.valPending.end())
      operandWait = std::max(operandWait, it->second);
  }
  return std::max(fuWait, operandWait);
}

} // namespace

static int64_t computeIterCost(Block &body, bool useCold,
                               DataFlowSolver &solver, const ArchData &arch);

static int64_t computeIterRegionCost(Region &region, bool useCold,
                                     DataFlowSolver &solver,
                                     const ArchData &arch) {
  if (region.empty())
    return 0;
  return computeIterCost(region.front(), useCold, solver, arch);
}

static int64_t computeIterUniformIfCost(UniformIfOp uniformIf, bool useCold,
                                        DataFlowSolver &solver,
                                        const ArchData &arch) {
  int64_t thenCost =
      computeIterRegionCost(uniformIf.getThenRegion(), useCold, solver, arch);
  int64_t elseCost =
      computeIterRegionCost(uniformIf.getElseRegion(), useCold, solver, arch);
  return std::max(thenCost, elseCost);
}

// Walk one body block (cold or hot trajectory) and return the
// per-iter cycle cost = max(issueAt + latency) measured from
// block entry at cycle 0. Used to compute C1 (cold trajectory)
// and Ss (hot trajectory) for uniform_loop bodies.
static int64_t computeIterCost(Block &body, bool useCold,
                               DataFlowSolver &solver, const ArchData &arch) {
  int64_t cycle = 0;
  int64_t maxComp = 0;
  for (Operation &op : body) {
    if (op.hasTrait<OpTrait::IsTerminator>())
      continue;
    if (auto uniformIf = dyn_cast<UniformIfOp>(&op)) {
      int64_t ifCost =
          computeIterUniformIfCost(uniformIf, useCold, solver, arch);
      cycle += ifCost;
      maxComp = std::max(maxComp, cycle);
      continue;
    }
    if (!isa<WaveAMDMachineDialect>(op.getDialect()))
      continue;
    ProgramPoint *beforePt = solver.getProgramPointBefore(&op);
    const auto *lat = solver.lookupState<PressureLattice>(beforePt);
    if (!lat)
      continue;
    const MachineState &state = useCold ? lat->cold : lat->hot;
    int wait = waitForOp(&op, state, arch);
    cycle += wait;
    SchedClass cls = classifyOp(&op);
    if (cls != SchedClass::NoInst)
      maxComp = std::max(maxComp, cycle + getLatency(arch, cls));
  }
  return maxComp;
}

// Trip-count extraction. Looks for a `waveamdmachine.trip_count`
// IntegerAttr on the loop op; falls back to a heuristic and sets
// the "unknown" flag so downstream can downweight.
static int64_t extractTripCount(UniformLoopOp loop, bool &unknownFlag) {
  if (auto attr = loop->getAttrOfType<IntegerAttr>("waveamdmachine.trip_count"))
    return attr.getInt();
  unknownFlag = true;
  return 4; // heuristic fallback.
}

// Populate per-op cold/hot maps from the solver. Walks recursively
// (including loop bodies) -- the maps are diagnostic; the
// trip-count multiplication only affects totalCycles.
static void populatePerOpStates(Operation *root, DataFlowSolver &solver,
                                PressureAnalysisResult &out) {
  root->walk([&](Operation *op) {
    if (op == root)
      return;
    if (!isa<WaveAMDMachineDialect>(op->getDialect()))
      return;
    ProgramPoint *afterPt = solver.getProgramPointAfter(op);
    const auto *lat = solver.lookupState<PressureLattice>(afterPt);
    if (!lat)
      return;
    out.perOpCold[op] = lat->cold;
    out.perOpHot[op] = lat->hot;
  });
}

// Forward decl.
static int64_t accumulateBlock(Block &block, int64_t entryCycle,
                               DataFlowSolver &solver, const ArchData &arch,
                               PressureAnalysisResult &out);

static int64_t accumulateRegion(Region &region, int64_t entryCycle,
                                DataFlowSolver &solver, const ArchData &arch,
                                PressureAnalysisResult &out) {
  if (region.empty())
    return entryCycle;
  return accumulateBlock(region.front(), entryCycle, solver, arch, out);
}

// Handle a uniform_loop: C1 + (T-1)*Ss per design doc. Returns
// the post-loop cycle (entry + total loop cycles).
static int64_t accumulateLoop(UniformLoopOp loop, int64_t entryCycle,
                              DataFlowSolver &solver, const ArchData &arch,
                              PressureAnalysisResult &out) {
  Block &body = loop.getBody().front();
  int64_t c1 = computeIterCost(body, /*useCold=*/true, solver, arch);
  int64_t ss = computeIterCost(body, /*useCold=*/false, solver, arch);
  int64_t t = extractTripCount(loop, out.unknownTripCount);
  if (t < 1)
    t = 1;
  int64_t loopCycles = c1 + (t - 1) * ss;
  return entryCycle + loopCycles;
}

static int64_t accumulateUniformIf(UniformIfOp uniformIf, int64_t entryCycle,
                                   DataFlowSolver &solver, const ArchData &arch,
                                   PressureAnalysisResult &out) {
  int64_t thenCycle = accumulateRegion(uniformIf.getThenRegion(), entryCycle,
                                       solver, arch, out);
  int64_t elseCycle = accumulateRegion(uniformIf.getElseRegion(), entryCycle,
                                       solver, arch, out);
  return std::max(thenCycle, elseCycle);
}

static int64_t accumulateBlock(Block &block, int64_t entryCycle,
                               DataFlowSolver &solver, const ArchData &arch,
                               PressureAnalysisResult &out) {
  int64_t cycle = entryCycle;
  int64_t maxComp = entryCycle;
  for (Operation &op : block) {
    if (op.hasTrait<OpTrait::IsTerminator>())
      continue;
    if (auto loop = dyn_cast<UniformLoopOp>(&op)) {
      int64_t postLoop = accumulateLoop(loop, cycle, solver, arch, out);
      cycle = postLoop;
      maxComp = std::max(maxComp, postLoop);
      continue;
    }
    if (auto uniformIf = dyn_cast<UniformIfOp>(&op)) {
      int64_t postIf = accumulateUniformIf(uniformIf, cycle, solver, arch, out);
      cycle = postIf;
      maxComp = std::max(maxComp, postIf);
      continue;
    }
    if (!isa<WaveAMDMachineDialect>(op.getDialect()))
      continue;
    ProgramPoint *beforePt = solver.getProgramPointBefore(&op);
    const auto *beforeLat = solver.lookupState<PressureLattice>(beforePt);
    if (!beforeLat)
      continue;
    int wait = waitForOp(&op, beforeLat->cold, arch);
    cycle += wait;
    int64_t issueAt = cycle;
    SchedClass cls = classifyOp(&op);
    if (cls != SchedClass::NoInst)
      maxComp = std::max(maxComp, issueAt + getLatency(arch, cls));
  }
  return maxComp;
}

LogicalResult runPressureAnalysis(func::FuncOp func, const ArchData &arch,
                                  PressureAnalysisResult &out) {
  DataFlowSolver solver;
  // DeadCodeAnalysis + SparseConstantPropagation pair via the
  // upstream helper. Required prerequisites: without the const-
  // prop analysis, DeadCodeAnalysis can't extract operand values
  // for region-branch ops, uniform_loop body blocks aren't marked
  // Executable, and the dense analysis never visits body ops.
  mlir::dataflow::loadBaselineAnalyses(solver);
  solver.load<PressureAnalysis>(arch);
  if (failed(solver.initializeAndRun(func)))
    return failure();

  // Per-op state map: diagnostic, populated for every reachable
  // waveamdmachine op (top-level and inside loop bodies).
  populatePerOpStates(func.getOperation(), solver, out);

  // Total-cycles accumulator: recursive over blocks, loop-aware
  // via C1 + (T-1)*Ss.
  out.totalCycles = accumulateBlock(func.getBody().front(), /*entryCycle=*/0,
                                    solver, arch, out);
  return success();
}

} // namespace mlir::waveamdmachine
