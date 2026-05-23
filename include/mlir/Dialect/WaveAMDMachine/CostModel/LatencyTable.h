//===- LatencyTable.h - Per-arch SchedClass latency ------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// Per-(arch, SchedClass) latency in SIMD cycles. Numbers come from
// LLVM's SISchedule.td (gfx942 / gfx950 / gfx1100 / gfx1200 models).
// Hand-copied; scripts/check-sched-tables.py keeps the copy honest
// against upstream LLVM.
//
//===----------------------------------------------------------------------===//

#ifndef MLIR_DIALECT_WAVEAMDMACHINE_COSTMODEL_LATENCYTABLE_H
#define MLIR_DIALECT_WAVEAMDMACHINE_COSTMODEL_LATENCYTABLE_H

#include "mlir/Dialect/WaveAMDMachine/CostModel/ArchData.h"
#include "mlir/Dialect/WaveAMDMachine/CostModel/SchedClass.h"

namespace mlir::waveamdmachine {

// Latency in SIMD cycles for `cls` on `arch`. Always returns a
// non-negative value; for class/arch combinations the upstream
// SchedModel doesn't bind (e.g. WMMA on CDNA, MAI on RDNA), the
// returned value is a sensible default rather than an error --
// applicability is the caller's concern.
int getLatency(const ArchData &arch, SchedClass cls);

} // namespace mlir::waveamdmachine

#endif // MLIR_DIALECT_WAVEAMDMACHINE_COSTMODEL_LATENCYTABLE_H
