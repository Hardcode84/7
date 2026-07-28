//===- FunctionalUnit.cpp - Per-arch SchedClass -> FU map -----------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/WaveAMDMachine/CostModel/FunctionalUnit.h"

#include "mlir/Dialect/WaveAMDMachine/CostModel/LatencyTable.h"
#include "llvm/ADT/Twine.h"
#include "llvm/Support/ErrorHandling.h"

#include <array>

namespace mlir::waveamdmachine {

using ClassFUs = std::array<FunctionalUnit,
                            static_cast<size_t>(SchedClass::NumSchedClasses)>;

#include "FunctionalUnitTable.inc"

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
  if (isaEq(getGfx1250IsaVersion(), isa))
    return &kFUsGfx1250;
  for (const ArchFUs &e : kArchFUs)
    if (isaEq(e.isa, isa))
      return e.table;
  return nullptr;
}

FunctionalUnit funit(const ArchData &arch, SchedClass cls) {
  if (!isSchedClassSupported(arch, cls))
    llvm::report_fatal_error(llvm::Twine(getSchedClassName(cls)) +
                             " is unsupported on " + arch.name);
  const ClassFUs *table = selectFUTable(arch.isa);
  if (!table)
    llvm::report_fatal_error(llvm::Twine("funit: no FU table for arch ") +
                             arch.name);
  size_t idx = static_cast<size_t>(cls);
  if (idx >= table->size())
    llvm_unreachable("funit: invalid SchedClass");
  return (*table)[idx];
}

llvm::StringRef getFunctionalUnitName(FunctionalUnit fu) {
  return stringifyFunctionalUnit(fu);
}

} // namespace mlir::waveamdmachine
