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

// Lattice cell: wraps a MachineState in relative-cycles form.
// Element-wise max meet via MachineState::join.
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
    os << "MachineState{maxFu=" << state.maxFuPending()
       << ", liveVals=" << state.valPending.size() << "}";
  }
};

// Forward dataflow that propagates relative-pendings MachineState.
// Transfer for each wave.amd.machine op: compute wait W,
// saturating-decrement all pendings by W, then schedule the op
// (FU pending = 1, results pending = latency).
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
    // Entry state: nothing pending. fuPending all zeros, valPending empty.
    lattice->state.fuPending = {};
    lattice->state.valPending.clear();
    propagateIfChanged(lattice, ChangeResult::Change);
  }

private:
  ChangeResult applyTransfer(Operation *op, MachineStateLattice *lattice);

  const ArchData &arch;
};

// Per-op transfer in relative-cycles form. Side-effect: returns
// Change always (we always mutate state for waveamdmachine ops).
ChangeResult PressureAnalysis::applyTransfer(Operation *op,
                                             MachineStateLattice *lattice) {
  SchedClass cls = classifyOp(op);
  MachineState &state = lattice->state;

  // Compute max operand-pending across the op's operands.
  int operandWait = 0;
  for (Value v : op->getOperands()) {
    auto it = state.valPending.find(v);
    if (it != state.valPending.end())
      operandWait = std::max(operandWait, it->second);
  }

  if (cls == SchedClass::NoInst) {
    // Pseudo: results inherit the operand wait (data-dep propagation),
    // no time advance, no FU charged.
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

  // Advance time by `wait` (saturating-decrement all pendings).
  state.advance(wait);

  // Issue: FU is occupied for 1 cycle; results pending = latency.
  if (fu != FunctionalUnit::None)
    state.fuPending[static_cast<size_t>(fu)] = 1;
  for (Value r : op->getResults())
    state.valPending[r] = latency;

  return ChangeResult::Change;
}

// Compute the wait time `op` would incur given the relative state
// just before it. Mirrors the wait computation in applyTransfer
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
  // DeadCodeAnalysis is the standard companion -- without it the
  // dense forward analysis trips on un-walked blocks.
  solver.load<mlir::dataflow::DeadCodeAnalysis>();
  solver.load<PressureAnalysis>(arch);
  if (failed(solver.initializeAndRun(func)))
    return failure();

  // Walk ops in program order and accumulate absolute cycles from
  // the relative-pending state at each program-point-before. Loops
  // are walked once at this stage (Stage 2 trip-count handling is
  // a separate commit); the resulting cycle count is correct for
  // straight-line code only.
  int64_t absoluteCycle = 0;
  int64_t maxCompletion = 0;
  func.walk([&](Operation *op) {
    if (op == func.getOperation())
      return;
    if (!isa<WaveAMDMachineDialect>(op->getDialect()))
      return;
    ProgramPoint *beforePt = solver.getProgramPointBefore(op);
    ProgramPoint *afterPt = solver.getProgramPointAfter(op);
    const auto *beforeLat = solver.lookupState<MachineStateLattice>(beforePt);
    const auto *afterLat = solver.lookupState<MachineStateLattice>(afterPt);
    if (!beforeLat || !afterLat)
      return;
    int wait = waitForOp(op, beforeLat->state, arch);
    absoluteCycle += wait;
    int64_t issueAt = absoluteCycle;
    SchedClass cls = classifyOp(op);
    if (cls != SchedClass::NoInst) {
      absoluteCycle += 1; // FU held for 1 issue cycle
      maxCompletion = std::max(maxCompletion, issueAt + getLatency(arch, cls));
    }
    out.perOpAfter[op] = afterLat->state;
  });
  out.totalCycles = maxCompletion;
  return success();
}

} // namespace mlir::waveamdmachine
