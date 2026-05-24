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

  // Override region-branch transfer so that the back-edge of a
  // `uniform_loop` (body region looping back to itself) only
  // propagates the hot component, not cold. Loop-entry and
  // loop-exit transitions use the default symmetric meet for now;
  // a follow-up commit refines them.
  void visitRegionBranchControlFlowTransfer(RegionBranchOpInterface branch,
                                            std::optional<unsigned> regionFrom,
                                            std::optional<unsigned> regionTo,
                                            const PressureLattice &before,
                                            PressureLattice *after) override {
    if (isa<UniformLoopOp>(branch.getOperation()) && regionFrom.has_value() &&
        regionTo.has_value() && *regionFrom == 0 && *regionTo == 0) {
      // Back-edge: only hot loops back.
      bool changed = after->hot.join(before.hot);
      propagateIfChanged(after, changed ? ChangeResult::Change
                                        : ChangeResult::NoChange);
      return;
    }
    DenseForwardDataFlowAnalysis::visitRegionBranchControlFlowTransfer(
        branch, regionFrom, regionTo, before, after);
  }

private:
  const ArchData &arch;
};

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
