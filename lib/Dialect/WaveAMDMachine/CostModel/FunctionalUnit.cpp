//===- FunctionalUnit.cpp - Per-arch SchedClass -> FU map -----------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/WaveAMDMachine/CostModel/FunctionalUnit.h"

#include "llvm/ADT/Twine.h"
#include "llvm/Support/ErrorHandling.h"

#include <array>

namespace mlir::waveamdmachine {

using ClassFUs = std::array<FunctionalUnit,
                            static_cast<size_t>(SchedClass::NumSchedClasses)>;

// Per-arch FU map. Layout matches the SchedClass enum.
//
// For class/arch combinations that LLVM does not bind explicitly,
// the entry uses a canonical FU (the one the class would use on
// the arch that does bind it) rather than None. Misuse is a
// user error and gracefully degrades; gen_sched_table.py only
// compares against bindings that LLVM actually publishes.

// CDNA3 / gfx942. SICommonWriteRes plus gfx942 overrides.
static constexpr ClassFUs kFUsGfx942 = {
    /*NoInst=*/FunctionalUnit::None,
    /*WriteSALU=*/FunctionalUnit::SALU,
    /*Write32Bit=*/FunctionalUnit::VALU,
    /*Write64Bit=*/FunctionalUnit::VALU,
    /*WriteFloatFMA=*/FunctionalUnit::VALU,
    /*WriteDouble=*/FunctionalUnit::VALU,
    /*WriteTrans32=*/FunctionalUnit::VALU,
    /*WriteSFPU=*/FunctionalUnit::SALU, // n/a (UnsupportedWriteRes).
    /*Write2PassMAI=*/FunctionalUnit::MFMA_XDL,
    /*Write4PassMAI=*/FunctionalUnit::MFMA_XDL,
    /*Write8PassMAI=*/FunctionalUnit::MFMA_XDL,
    /*Write16PassMAI=*/FunctionalUnit::MFMA_XDL,
    /*WriteXDL2PassWMMA=*/FunctionalUnit::MFMA_XDL, // n/a on CDNA.
    /*WriteXDL4PassWMMA=*/FunctionalUnit::MFMA_XDL,
    /*Write4PassWMMA=*/FunctionalUnit::MFMA_XDL,
    /*Write8PassWMMA=*/FunctionalUnit::MFMA_XDL,
    /*Write16PassWMMA=*/FunctionalUnit::MFMA_XDL,
    /*WriteVMEM=*/FunctionalUnit::VMEM,
    /*WriteSMEM=*/FunctionalUnit::LGKM,
    /*WriteLDS=*/FunctionalUnit::LGKM,
    /*WriteBranch=*/FunctionalUnit::BRANCH,
    /*WriteBarrier=*/FunctionalUnit::BRANCH,
    /*WriteExport=*/FunctionalUnit::EXPORT,
    /*WaitcntPseudo=*/FunctionalUnit::None,
};

// CDNA4 / gfx950. Same FU shape as gfx942 on every class.
static constexpr ClassFUs kFUsGfx950 = kFUsGfx942;

// RDNA3 / gfx1100. GFX11SpeedModel (:426-462).
static constexpr ClassFUs kFUsGfx1100 = {
    /*NoInst=*/FunctionalUnit::None,
    /*WriteSALU=*/FunctionalUnit::SALU,         // :446.
    /*Write32Bit=*/FunctionalUnit::VALU,        // :431.
    /*Write64Bit=*/FunctionalUnit::VALU,        // :433.
    /*WriteFloatFMA=*/FunctionalUnit::VALU,     // :436.
    /*WriteDouble=*/FunctionalUnit::VALU,       // :437.
    /*WriteTrans32=*/FunctionalUnit::TRANS,     // :434, HWTransVALU.
    /*WriteSFPU=*/FunctionalUnit::SALU,         // :447.
    /*Write2PassMAI=*/FunctionalUnit::MFMA_XDL, // n/a on RDNA.
    /*Write4PassMAI=*/FunctionalUnit::MFMA_XDL,
    /*Write8PassMAI=*/FunctionalUnit::MFMA_XDL,
    /*Write16PassMAI=*/FunctionalUnit::MFMA_XDL,
    /*WriteXDL2PassWMMA=*/FunctionalUnit::MFMA_XDL, // n/a on RDNA3.
    /*WriteXDL4PassWMMA=*/FunctionalUnit::MFMA_XDL,
    /*Write4PassWMMA=*/FunctionalUnit::VALU, // RDNA WMMA runs on VALU pipe.
    /*Write8PassWMMA=*/FunctionalUnit::VALU,
    /*Write16PassWMMA=*/FunctionalUnit::VALU,
    /*WriteVMEM=*/FunctionalUnit::VMEM,      // :449.
    /*WriteSMEM=*/FunctionalUnit::LGKM,      // :448.
    /*WriteLDS=*/FunctionalUnit::LGKM,       // :445.
    /*WriteBranch=*/FunctionalUnit::BRANCH,  // :443.
    /*WriteBarrier=*/FunctionalUnit::BRANCH, // :450.
    /*WriteExport=*/FunctionalUnit::EXPORT,  // :444.
    /*WaitcntPseudo=*/FunctionalUnit::None,
};

// RDNA4 / gfx1200. GFX12SpeedModel (:464-495). Differs from
// gfx1100 on WriteTrans32 (HWVALU vs HWTransVALU).
static constexpr ClassFUs kFUsGfx1200 = {
    /*NoInst=*/FunctionalUnit::None,
    /*WriteSALU=*/FunctionalUnit::SALU,     // :482.
    /*Write32Bit=*/FunctionalUnit::VALU,    // :466.
    /*Write64Bit=*/FunctionalUnit::VALU,    // :468.
    /*WriteFloatFMA=*/FunctionalUnit::VALU, // :471.
    /*WriteDouble=*/FunctionalUnit::VALU,   // :472.
    /*WriteTrans32=*/FunctionalUnit::VALU,  // :469, HWVALU (diff from gfx1100).
    /*WriteSFPU=*/FunctionalUnit::SALU,     // :483.
    /*Write2PassMAI=*/FunctionalUnit::MFMA_XDL,
    /*Write4PassMAI=*/FunctionalUnit::MFMA_XDL,
    /*Write8PassMAI=*/FunctionalUnit::MFMA_XDL,
    /*Write16PassMAI=*/FunctionalUnit::MFMA_XDL,
    /*WriteXDL2PassWMMA=*/FunctionalUnit::MFMA_XDL,
    /*WriteXDL4PassWMMA=*/FunctionalUnit::MFMA_XDL,
    /*Write4PassWMMA=*/FunctionalUnit::VALU,
    /*Write8PassWMMA=*/FunctionalUnit::VALU,
    /*Write16PassWMMA=*/FunctionalUnit::VALU,
    /*WriteVMEM=*/FunctionalUnit::VMEM,      // :485.
    /*WriteSMEM=*/FunctionalUnit::LGKM,      // :484.
    /*WriteLDS=*/FunctionalUnit::LGKM,       // :481.
    /*WriteBranch=*/FunctionalUnit::BRANCH,  // :479.
    /*WriteBarrier=*/FunctionalUnit::BRANCH, // :486.
    /*WriteExport=*/FunctionalUnit::EXPORT,  // :480.
    /*WaitcntPseudo=*/FunctionalUnit::None,
};

namespace {
struct ArchFUs {
  llvm::AMDGPU::IsaVersion isa;
  const ClassFUs *table;
};
} // namespace

static constexpr ArchFUs kArchFUs[] = {
    {{8, 0, 3}, &kFUsGfx942},   {{9, 4, 2}, &kFUsGfx942},
    {{9, 5, 0}, &kFUsGfx950},   {{11, 0, 0}, &kFUsGfx1100},
    {{12, 0, 0}, &kFUsGfx1200},
};

static const ClassFUs *selectFUTable(const llvm::AMDGPU::IsaVersion &isa) {
  for (const ArchFUs &e : kArchFUs)
    if (isaEq(e.isa, isa))
      return e.table;
  return nullptr;
}

FunctionalUnit funit(const ArchData &arch, SchedClass cls) {
  const ClassFUs *table = selectFUTable(arch.isa);
  if (!table)
    llvm::report_fatal_error(llvm::Twine("funit: no FU table for arch ") +
                             arch.name);
  size_t idx = static_cast<size_t>(cls);
  if (idx >= table->size())
    llvm_unreachable("funit: invalid SchedClass");
  return (*table)[idx];
}

static constexpr std::array<llvm::StringLiteral,
                            static_cast<size_t>(
                                FunctionalUnit::NumFunctionalUnits)>
    kFUNames = {"VALU",  "SALU",   "VMEM",   "LGKM", "MFMA_XDL",
                "TRANS", "BRANCH", "EXPORT", "None"};

llvm::StringRef getFunctionalUnitName(FunctionalUnit fu) {
  size_t idx = static_cast<size_t>(fu);
  if (idx >= kFUNames.size())
    llvm_unreachable("invalid FunctionalUnit");
  return kFUNames[idx];
}

} // namespace mlir::waveamdmachine
