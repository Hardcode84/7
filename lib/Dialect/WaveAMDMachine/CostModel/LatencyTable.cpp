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

#include "LatencyTable.inc"

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
