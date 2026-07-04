//===- FunctionalUnit.h - Per-arch SchedClass -> FU map ---------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// Per-(arch, SchedClass) primary functional unit. Used by the
// instruction execution model, scheduler reports, and static FU
// summaries. Numbers come from LLVM's SISchedule.td
// HWWriteRes/HWVALUWriteRes resource lists; gen_sched_table.py
// checks this map against upstream.
//
//===----------------------------------------------------------------------===//

#ifndef MLIR_DIALECT_WAVEAMDMACHINE_COSTMODEL_FUNCTIONALUNIT_H
#define MLIR_DIALECT_WAVEAMDMACHINE_COSTMODEL_FUNCTIONALUNIT_H

#include "mlir/Dialect/WaveAMDMachine/CostModel/ArchData.h"
#include "mlir/Dialect/WaveAMDMachine/CostModel/SchedClass.h"
#include "llvm/ADT/StringRef.h"

#include <cstdint>

namespace mlir::waveamdmachine {

// Coarse functional-unit set. Maps onto the LLVM SISchedule.td
// resource enum (HWVALU/HWSALU/HWVMEM/HWLGKM/HWXDL/HWTransVALU/
// HWBranch/HWExport) with HWRC (register-cache port) dropped --
// HWRC is a serializing port already folded into the per-class
// latency.
enum class FunctionalUnit : uint8_t {
  VALU,     // HWVALU.
  SALU,     // HWSALU.
  VMEM,     // HWVMEM.
  LGKM,     // HWLGKM (SMEM + LDS; lgkmcnt-side).
  MFMA_XDL, // HWXDL (matrix multiply pipe; CDNA + gfx1250 WMMA).
  TRANS,    // HWTransVALU (transcendental pipe).
  BRANCH,   // HWBranch.
  EXPORT,   // HWExport.

  // Pseudo / waitcnt-class ops that consume no FU issue slot.
  None,

  NumFunctionalUnits,
};

// Diagnostics / LatencyTable lookups.
llvm::StringRef getFunctionalUnitName(FunctionalUnit fu);

// Primary FU for the given class on the given arch. The
// "primary" is the first non-HWRC resource in the SISchedule.td
// HWWriteRes list. Classes that the upstream model leaves unbound
// for the given arch (e.g. WMMA on CDNA, MAI on RDNA) take a
// sensible canonical FU rather than an error -- arch-mismatch is
// caller-detectable via isArchSupported and gracefully degrades
// rather than aborts.
FunctionalUnit funit(const ArchData &arch, SchedClass cls);

} // namespace mlir::waveamdmachine

#endif // MLIR_DIALECT_WAVEAMDMACHINE_COSTMODEL_FUNCTIONALUNIT_H
