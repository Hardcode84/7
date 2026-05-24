//===- PressureAnalysis.cpp - Dense forward dataflow over MachineState ---===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/WaveAMDMachine/CostModel/PressureAnalysis.h"

#include "mlir/Analysis/DataFlow/DeadCodeAnalysis.h"
#include "mlir/Analysis/DataFlow/DenseAnalysis.h"
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

LogicalResult runPressureAnalysis(func::FuncOp func, const ArchData &arch,
                                  PressureAnalysisResult &out) {
  DataFlowSolver solver;
  solver.load<mlir::dataflow::DeadCodeAnalysis>();
  solver.load<PressureAnalysis>(arch);
  if (failed(solver.initializeAndRun(func)))
    return failure();

  // Walk ops in program order and accumulate absolute cycles
  // from the relative-pending cold state at each program point.
  // Loops walked once at this stage; trip-count multiplication
  // is a follow-up commit.
  int64_t absoluteCycle = 0;
  int64_t maxCompletion = 0;
  func.walk([&](Operation *op) {
    if (op == func.getOperation())
      return;
    if (!isa<WaveAMDMachineDialect>(op->getDialect()))
      return;
    ProgramPoint *beforePt = solver.getProgramPointBefore(op);
    ProgramPoint *afterPt = solver.getProgramPointAfter(op);
    const auto *beforeLat = solver.lookupState<PressureLattice>(beforePt);
    const auto *afterLat = solver.lookupState<PressureLattice>(afterPt);
    if (!beforeLat || !afterLat)
      return;
    int wait = waitForOp(op, beforeLat->cold, arch);
    absoluteCycle += wait;
    int64_t issueAt = absoluteCycle;
    SchedClass cls = classifyOp(op);
    if (cls != SchedClass::NoInst) {
      absoluteCycle += 1;
      maxCompletion = std::max(maxCompletion, issueAt + getLatency(arch, cls));
    }
    out.perOpCold[op] = afterLat->cold;
    out.perOpHot[op] = afterLat->hot;
  });
  out.totalCycles = maxCompletion;
  return success();
}

} // namespace mlir::waveamdmachine
