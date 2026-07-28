//===- LatencyTable.h - Per-arch SchedClass latency ------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// Per-(arch, SchedClass) LLVM scheduling data.
//
//===----------------------------------------------------------------------===//

#ifndef MLIR_DIALECT_WAVEAMDMACHINE_COSTMODEL_LATENCYTABLE_H
#define MLIR_DIALECT_WAVEAMDMACHINE_COSTMODEL_LATENCYTABLE_H

#include "mlir/Dialect/WaveAMDMachine/CostModel/ArchData.h"
#include "mlir/Dialect/WaveAMDMachine/CostModel/SchedClass.h"

namespace mlir::waveamdmachine {

bool isSchedClassSupported(const ArchData &arch, SchedClass cls);

// Latency in SIMD cycles. Unsupported class/arch pairs are fatal.
int getLatency(const ArchData &arch, SchedClass cls);

// Resource release interval from the target scheduling model.
int getResourceCycles(const ArchData &arch, SchedClass cls);

unsigned getIssueCount(const ArchData &arch, SchedClass cls);

} // namespace mlir::waveamdmachine

#endif // MLIR_DIALECT_WAVEAMDMACHINE_COSTMODEL_LATENCYTABLE_H
