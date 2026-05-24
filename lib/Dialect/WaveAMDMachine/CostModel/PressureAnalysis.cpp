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
#include "llvm/Support/raw_ostream.h"

#include <algorithm>

namespace mlir::waveamdmachine {

namespace {

// Lattice cell: wraps a MachineState. Element-wise max meet via
// MachineState::join.
class MachineStateLattice : public mlir::dataflow::AbstractDenseLattice {
public:
  using AbstractDenseLattice::AbstractDenseLattice;

  MachineState state;

  ChangeResult meet(const AbstractDenseLattice &rhs) override {
    const auto &rhsLat = static_cast<const MachineStateLattice &>(rhs);
    return state.join(rhsLat.state) ? ChangeResult::Change
                                    : ChangeResult::NoChange;
  }

  void print(llvm::raw_ostream &os) const override {
    os << "MachineState{maxFu=" << state.maxFuCycle()
       << ", liveVals=" << state.readyAt.size() << "}";
  }
};

// Forward dataflow that propagates MachineState. Transfer for
// each wave.amd.machine op charges its FU's ready cycle + updates
// the per-Value ready map. Non-wave-amd-machine ops are
// pass-through.
class PressureAnalysis
    : public mlir::dataflow::DenseForwardDataFlowAnalysis<MachineStateLattice> {
public:
  PressureAnalysis(DataFlowSolver &solver, const ArchData &arch)
      : DenseForwardDataFlowAnalysis(solver), arch(arch) {}

  LogicalResult visitOperation(Operation *op, const MachineStateLattice &before,
                               MachineStateLattice *after) override {
    ChangeResult cr = after->meet(before);
    if (isa<WaveAMDMachineDialect>(op->getDialect()))
      cr |= applyTransfer(op, after);
    propagateIfChanged(after, cr);
    return success();
  }

  void setToEntryState(MachineStateLattice *lattice) override {
    // Entry state is zero (all FUs idle at cycle 0, no live values).
    lattice->state.fuReadyAt = {};
    lattice->state.readyAt.clear();
    propagateIfChanged(lattice, ChangeResult::Change);
  }

private:
  ChangeResult applyTransfer(Operation *op, MachineStateLattice *lattice);

  const ArchData &arch;
};

ChangeResult PressureAnalysis::applyTransfer(Operation *op,
                                             MachineStateLattice *lattice) {
  SchedClass cls = classifyOp(op);
  MachineState &state = lattice->state;

  int64_t operandReady = 0;
  for (Value v : op->getOperands()) {
    auto it = state.readyAt.find(v);
    if (it != state.readyAt.end())
      operandReady = std::max(operandReady, it->second);
  }

  if (cls == SchedClass::NoInst) {
    // Pseudo: results ready at max-operand-ready; no FU charged.
    for (Value r : op->getResults())
      state.readyAt[r] = operandReady;
    return ChangeResult::Change;
  }

  FunctionalUnit fu = funit(arch, cls);
  int64_t latency = getLatency(arch, cls);

  int64_t fuReady = (fu == FunctionalUnit::None)
                        ? 0
                        : state.fuReadyAt[static_cast<size_t>(fu)];
  int64_t issueAt = std::max(fuReady, operandReady);

  if (fu != FunctionalUnit::None)
    state.fuReadyAt[static_cast<size_t>(fu)] = issueAt + 1;

  for (Value r : op->getResults())
    state.readyAt[r] = issueAt + latency;

  return ChangeResult::Change;
}

} // namespace

LogicalResult runPressureAnalysis(func::FuncOp func, const ArchData &arch,
                                  PressureAnalysisResult &out) {
  DataFlowSolver solver;
  // DeadCodeAnalysis is the standard companion -- without it the
  // dense forward analysis trips on un-walked blocks.
  solver.load<mlir::dataflow::DeadCodeAnalysis>();
  solver.load<PressureAnalysis>(arch);
  if (failed(solver.initializeAndRun(func)))
    return failure();

  int64_t maxCycles = 0;
  func.walk([&](Operation *op) {
    if (op == func.getOperation())
      return;
    if (!isa<WaveAMDMachineDialect>(op->getDialect()))
      return;
    ProgramPoint *pt = solver.getProgramPointAfter(op);
    const auto *lat = solver.lookupState<MachineStateLattice>(pt);
    if (!lat)
      return;
    out.perOpAfter[op] = lat->state;
    maxCycles = std::max(maxCycles, lat->state.maxFuCycle());
  });
  out.totalCycles = maxCycles;
  return success();
}

} // namespace mlir::waveamdmachine
