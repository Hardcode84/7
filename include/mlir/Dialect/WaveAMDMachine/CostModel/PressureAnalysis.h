//===- PressureAnalysis.h - Dense forward dataflow over MachineState
//-*-C++-*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// Dense forward dataflow that propagates `MachineState` through a
// wave.amd.machine func body. Per-op transfer function charges
// the right FU pipe + updates per-Value ready cycles; join at CFG
// merges is element-wise max. Single-block kernels run as a flat
// forward pass; multi-block (s_cbranch_*) gets the standard join
// at block heads.
//
// Loop bodies are walked once at this stage; structural loop
// handling with trip-count multiplication is Stage 2C's job
// (sy5.13). Counter modeling (waitcnt inflight depth) is also
// deferred; this stage tracks FU pressure + value readiness only.
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
  // Per-op "after" MachineState for every wave.amd.machine op in
  // the analysed func.
  llvm::DenseMap<Operation *, MachineState> perOpAfter;

  // max fuReadyAt over every per-op state -- single-wave cycle
  // estimate ignoring loop trip counts (Stage 2C fixes that).
  int64_t totalCycles = 0;
};

// Run the dense forward analysis on `func`. Returns failure only
// if the dataflow solver itself fails (rare; usually means a
// pathological op pattern the framework can't handle). On
// success, `out` is populated with the per-op states and the
// scalar total.
LogicalResult runPressureAnalysis(func::FuncOp func, const ArchData &arch,
                                  PressureAnalysisResult &out);

} // namespace mlir::waveamdmachine

#endif // MLIR_DIALECT_WAVEAMDMACHINE_COSTMODEL_PRESSUREANALYSIS_H
