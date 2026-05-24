//===- MachineState.h - Per-program-point pressure ------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// MachineState is the lattice value carried at every program point
// by the Stage 2 dense dataflow analysis. Fields are scoped to what
// the scheduler actually consumes; counter modeling beyond
// fuReadyAt comes with Stage 2C (loops + waitcnt-aware transfer).
//
//===----------------------------------------------------------------------===//

#ifndef MLIR_DIALECT_WAVEAMDMACHINE_COSTMODEL_MACHINESTATE_H
#define MLIR_DIALECT_WAVEAMDMACHINE_COSTMODEL_MACHINESTATE_H

#include "mlir/Dialect/WaveAMDMachine/CostModel/FunctionalUnit.h"
#include "mlir/IR/Value.h"
#include "llvm/ADT/DenseMap.h"

#include <array>
#include <cstdint>

namespace mlir::waveamdmachine {

// Per-FU "next free" cycle vector + per-Value ready map. All
// counts are absolute cycles since function entry (relative
// origin = 0).
//
// Element-wise max is the lattice ordering; join = max. NoInst
// and waitcnt-pseudo ops do not advance fuReadyAt but propagate
// operand ready-cycles to their results so downstream data
// dependencies stay correct.
struct MachineState {
  std::array<int64_t, static_cast<size_t>(FunctionalUnit::NumFunctionalUnits)>
      fuReadyAt = {};
  llvm::DenseMap<mlir::Value, int64_t> readyAt;

  // Element-wise max join. Returns true iff any field changed.
  bool join(const MachineState &rhs);

  // Equality on the full state (fuReadyAt + readyAt map).
  bool operator==(const MachineState &rhs) const;
  bool operator!=(const MachineState &rhs) const { return !(*this == rhs); }

  // Max fuReadyAt over all FUs -- the "current cycle" upper bound.
  int64_t maxFuCycle() const;
};

} // namespace mlir::waveamdmachine

#endif // MLIR_DIALECT_WAVEAMDMACHINE_COSTMODEL_MACHINESTATE_H
