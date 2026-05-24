//===- PressureAnalysis.h - Dense forward dataflow over MachineState
//---*-C++-*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// Dense forward dataflow that propagates a (cold, hot) tuple of
// `MachineState` through a wave.amd.machine func body. Cold
// reflects state arriving via non-backedge incoming control flow
// (first-visit / pre-loop); hot reflects backedge-only incoming
// (loop-carried steady state). At non-loop points the two
// converge; at loop headers they stay separate, giving the
// scheduler a distinguishable steady-state view.
//
// See docs/AMDGPUSchedulerDesign.md "Stage 2" for the full
// design. This header exposes the public API only.
//
//===----------------------------------------------------------------------===//

#ifndef MLIR_DIALECT_WAVEAMDMACHINE_COSTMODEL_PRESSUREANALYSIS_H
#define MLIR_DIALECT_WAVEAMDMACHINE_COSTMODEL_PRESSUREANALYSIS_H

#include "mlir/Dialect/WaveAMDMachine/CostModel/MachineState.h"
#include "mlir/Support/LLVM.h"
#include "llvm/ADT/DenseMap.h"

#include <cstdint>

namespace mlir {
namespace func {
class FuncOp;
} // namespace func
} // namespace mlir

namespace mlir::waveamdmachine {

struct ArchData;

struct PressureAnalysisResult {
  // Per-op "after" cold state. For non-loop ops, equals the hot
  // state after convergence. For ops inside a loop body, this is
  // the iter-1 / warm-up flavor.
  llvm::DenseMap<Operation *, MachineState> perOpCold;

  // Per-op "after" hot state. For ops inside a loop body, this
  // is the steady-state flavor; the scheduler reads this for
  // in-loop pressure queries. BOT at points unreachable via any
  // back-edge.
  llvm::DenseMap<Operation *, MachineState> perOpHot;

  // Total cycle count. Loops counted with structural
  // C1 + (T-1)*Ss: C1 from walking the body with cold entry,
  // Ss from walking with hot entry, T from a
  // waveamdmachine.trip_count attribute or a heuristic
  // fallback (with `unknownTripCount` set).
  int64_t totalCycles = 0;

  // True iff any uniform_loop in the analysed func had no
  // recoverable trip count (no attribute, range analysis didn't
  // produce a concrete value) and the heuristic fallback fired.
  // Downstream consumers (autotune scoring) can downweight or
  // refuse-to-score in that case.
  bool unknownTripCount = false;
};

// Run the dense forward analysis on `func`. Returns failure only
// if the dataflow solver itself fails (rare; usually a pathological
// op pattern the framework can't handle). On success, `out` is
// populated with per-op cold/hot states and the scalar total.
LogicalResult runPressureAnalysis(func::FuncOp func, const ArchData &arch,
                                  PressureAnalysisResult &out);

} // namespace mlir::waveamdmachine

#endif // MLIR_DIALECT_WAVEAMDMACHINE_COSTMODEL_PRESSUREANALYSIS_H
