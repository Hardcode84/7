//===- MachineState.h - Per-program-point pressure ------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// MachineState is the lattice value carried at every program point
// by dense dataflow analysis. Represented in
// relative-cycles form -- fuPending[fu] = cycles until that
// functional unit is next free from this point in time;
// valPending[v] = cycles until value v is ready. Bounded above by
// max-latency, so the lattice domain is finite and dataflow
// reaches a fixed point naturally.
//
// Total cycles are accumulated separately during the walk, not
// stored in the state. See PressureAnalysis.
//
//===----------------------------------------------------------------------===//

#ifndef MLIR_DIALECT_WAVEAMDMACHINE_COSTMODEL_MACHINESTATE_H
#define MLIR_DIALECT_WAVEAMDMACHINE_COSTMODEL_MACHINESTATE_H

#include "mlir/Dialect/WaveAMDMachine/CostModel/FunctionalUnit.h"
#include "mlir/IR/Value.h"
#include "llvm/ADT/DenseMap.h"

#include <array>

namespace mlir::waveamdmachine {

// Relative-cycles pressure: per-FU and per-Value "cycles until
// free / ready" from this program point. All zero = nothing
// pending. Element-wise max is the lattice ordering; join = max.
struct MachineState {
  std::array<int, static_cast<size_t>(FunctionalUnit::NumFunctionalUnits)>
      fuPending = {};
  llvm::DenseMap<mlir::Value, int> valPending;

  // Element-wise max join. Returns true iff any field changed.
  bool join(const MachineState &rhs);

  bool operator==(const MachineState &rhs) const;
  bool operator!=(const MachineState &rhs) const { return !(*this == rhs); }

  // Saturating-decrement all pendings by `w`. Drops valPending
  // entries that reach <= 0. Models "time advances by w cycles".
  void advance(int w);

  // Max over fuPending. The "bottleneck FU is busy for at most
  // this many more cycles" upper bound.
  int maxFuPending() const;
};

} // namespace mlir::waveamdmachine

#endif // MLIR_DIALECT_WAVEAMDMACHINE_COSTMODEL_MACHINESTATE_H
