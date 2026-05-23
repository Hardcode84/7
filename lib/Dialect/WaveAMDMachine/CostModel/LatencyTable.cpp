//===- LatencyTable.cpp - Per-arch SchedClass latency ---------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/WaveAMDMachine/CostModel/LatencyTable.h"

#include "llvm/ADT/Twine.h"
#include "llvm/Support/ErrorHandling.h"

#include <array>

namespace mlir::waveamdmachine {

using ClassLatencies =
    std::array<int, static_cast<size_t>(SchedClass::NumSchedClasses)>;

// Helper for the per-arch tables below: layout must match the
// SchedClass enum. Comments cite the SISchedule.td line that
// supplied each number; classes that the upstream model leaves
// unbound for this arch (e.g. WMMA on CDNA) take the global default
// from the SchedWrite declaration block (SISchedule.td:69-74).
//
// The check-sched-tables.py pre-commit hook parses SISchedule.td
// and diffs against these tables.

// CDNA3 / gfx942. SICommonWriteRes (SISchedule.td:171-221) +
// SIDPGFX942FullSpeedModel overrides (lines 301-333).
static constexpr ClassLatencies kLatencyGfx942 = {
    /*NoInst=*/0,             // pseudo.
    /*WriteSALU=*/1,          // SICommonWriteRes :177.
    /*Write32Bit=*/1,         // SICommonWriteRes :182.
    /*Write64Bit=*/1,         // gfx942 override   :311.
    /*WriteFloatFMA=*/1,      // gfx942 override   :305.
    /*WriteDouble=*/1,        // gfx942 override   :306.
    /*WriteTrans32=*/4,       // SICommonWriteRes :184.
    /*WriteSFPU=*/0,          // unsupported on CDNA (:208).
    /*Write2PassMAI=*/2,      // SICommonWriteRes :195.
    /*Write4PassMAI=*/4,      // SICommonWriteRes :197.
    /*Write8PassMAI=*/8,      // SICommonWriteRes :199.
    /*Write16PassMAI=*/16,    // SICommonWriteRes :201.
    /*WriteXDL2PassWMMA=*/8,  // global default :70 / GFX125x :514.
    /*WriteXDL4PassWMMA=*/16, // global default :71 / GFX125x :516.
    /*Write4PassWMMA=*/16,    // global default :72 / GFX125x :518.
    /*Write8PassWMMA=*/32,    // global default :73 / GFX125x :519.
    /*Write16PassWMMA=*/64,   // global default :74 / GFX125x :520.
    /*WriteVMEM=*/80,         // SICommonWriteRes :179.
    /*WriteSMEM=*/5,          // SICommonWriteRes :178.
    /*WriteLDS=*/5,           // SICommonWriteRes :176.
    /*WriteBranch=*/8,        // SICommonWriteRes :174.
    /*WriteBarrier=*/500,     // SICommonWriteRes :180.
    /*WriteExport=*/4,        // SICommonWriteRes :175.
    /*WaitcntPseudo=*/0,      // pseudo.
};

// CDNA4 / gfx950. SICommonWriteRes + SIDPGFX950FullSpeedModel
// overrides (SISchedule.td:336-384). Same shape as gfx942 on every
// class the cost model tracks; the gfx950-specific scaled-MFMA
// variants live at :372-382 and are handled separately when the
// classifier gains the scaled-MFMA ops.
static constexpr ClassLatencies kLatencyGfx950 = kLatencyGfx942;

// RDNA3 / gfx1100. GFX11SpeedModel (SISchedule.td:426-462).
static constexpr ClassLatencies kLatencyGfx1100 = {
    /*NoInst=*/0,
    /*WriteSALU=*/2,     // :446.
    /*Write32Bit=*/5,    // :431.
    /*Write64Bit=*/6,    // :433.
    /*WriteFloatFMA=*/5, // :436.
    /*WriteDouble=*/38,  // :437.
    /*WriteTrans32=*/10, // :434.
    /*WriteSFPU=*/4,     // :447.
    /*Write2PassMAI=*/2, // n/a on RDNA; use class pass-count.
    /*Write4PassMAI=*/4,
    /*Write8PassMAI=*/8,
    /*Write16PassMAI=*/16,
    /*WriteXDL2PassWMMA=*/8, // n/a on RDNA3; placeholder.
    /*WriteXDL4PassWMMA=*/16,
    /*Write4PassWMMA=*/16,  // placeholder; classifier maps RDNA3.
    /*Write8PassWMMA=*/32,  // WMMA ops to Write16PassWMMA, calibrated.
    /*Write16PassWMMA=*/64, // in Stage 4.
    /*WriteVMEM=*/320,      // :449.
    /*WriteSMEM=*/20,       // :448.
    /*WriteLDS=*/20,        // :445.
    /*WriteBranch=*/32,     // :443.
    /*WriteBarrier=*/2000,  // :450.
    /*WriteExport=*/16,     // :444.
    /*WaitcntPseudo=*/0,
};

// RDNA4 / gfx1200. GFX12SpeedModel (SISchedule.td:464-495).
static constexpr ClassLatencies kLatencyGfx1200 = {
    /*NoInst=*/0,
    /*WriteSALU=*/2,     // :482.
    /*Write32Bit=*/5,    // :466.
    /*Write64Bit=*/6,    // :468.
    /*WriteFloatFMA=*/5, // :471.
    /*WriteDouble=*/38,  // :472.
    /*WriteTrans32=*/9,  // :469.
    /*WriteSFPU=*/4,     // :483.
    /*Write2PassMAI=*/2, // n/a on RDNA; use class pass-count.
    /*Write4PassMAI=*/4,
    /*Write8PassMAI=*/8,
    /*Write16PassMAI=*/16,
    /*WriteXDL2PassWMMA=*/8, // n/a on RDNA4; placeholder.
    /*WriteXDL4PassWMMA=*/16,
    /*Write4PassWMMA=*/16,
    /*Write8PassWMMA=*/32,
    /*Write16PassWMMA=*/64,
    /*WriteVMEM=*/320,     // :485.
    /*WriteSMEM=*/20,      // :484.
    /*WriteLDS=*/20,       // :481.
    /*WriteBranch=*/32,    // :479.
    /*WriteBarrier=*/2000, // :486.
    /*WriteExport=*/16,    // :480.
    /*WaitcntPseudo=*/0,
};

namespace {
struct ArchTable {
  llvm::AMDGPU::IsaVersion isa;
  const ClassLatencies *table;
};
} // namespace

static constexpr ArchTable kArchTables[] = {
    {{9, 4, 2}, &kLatencyGfx942},
    {{9, 5, 0}, &kLatencyGfx950},
    {{11, 0, 0}, &kLatencyGfx1100},
    {{12, 0, 0}, &kLatencyGfx1200},
};

static bool isaEq(const llvm::AMDGPU::IsaVersion &a,
                  const llvm::AMDGPU::IsaVersion &b) {
  return a.Major == b.Major && a.Minor == b.Minor && a.Stepping == b.Stepping;
}

static const ClassLatencies *selectTable(const llvm::AMDGPU::IsaVersion &isa) {
  for (const ArchTable &e : kArchTables)
    if (isaEq(e.isa, isa))
      return e.table;
  return nullptr;
}

int getLatency(const ArchData &arch, SchedClass cls) {
  const ClassLatencies *table = selectTable(arch.isa);
  if (!table)
    llvm::report_fatal_error(llvm::Twine("getLatency: no table for arch ") +
                             arch.name);
  size_t idx = static_cast<size_t>(cls);
  if (idx >= table->size())
    llvm_unreachable("getLatency: invalid SchedClass");
  return (*table)[idx];
}

} // namespace mlir::waveamdmachine
