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

#include <algorithm>
#include <array>

namespace mlir::waveamdmachine {

using ClassCycles =
    std::array<int, static_cast<size_t>(SchedClass::NumSchedClasses)>;
using ClassSupport =
    std::array<bool, static_cast<size_t>(SchedClass::NumSchedClasses)>;

#include "LatencyTable.inc"

namespace {
struct ArchTable {
  llvm::AMDGPU::IsaVersion isa;
  const ClassCycles *latencies;
  const ClassCycles *resourceCycles;
  const ClassCycles *issueCounts;
  const ClassSupport *supported;
};
} // namespace

static constexpr ArchTable kArchTables[] = {
    {{8, 0, 3},
     &kLatencyGfx942,
     &kResourceCyclesGfx942,
     &kIssueCountsGfx942,
     &kSupportedGfx942},
    {{9, 4, 2},
     &kLatencyGfx942,
     &kResourceCyclesGfx942,
     &kIssueCountsGfx942,
     &kSupportedGfx942},
    {{9, 5, 0},
     &kLatencyGfx950,
     &kResourceCyclesGfx950,
     &kIssueCountsGfx950,
     &kSupportedGfx950},
    {{11, 0, 0},
     &kLatencyGfx1100,
     &kResourceCyclesGfx1100,
     &kIssueCountsGfx1100,
     &kSupportedGfx1100},
    {{12, 0, 0},
     &kLatencyGfx1200,
     &kResourceCyclesGfx1200,
     &kIssueCountsGfx1200,
     &kSupportedGfx1200},
};

static const ArchTable *selectTable(const llvm::AMDGPU::IsaVersion &isa) {
  static const ArchTable gfx1250 = {getGfx1250IsaVersion(), &kLatencyGfx1250,
                                    &kResourceCyclesGfx1250,
                                    &kIssueCountsGfx1250, &kSupportedGfx1250};
  if (isaEq(gfx1250.isa, isa))
    return &gfx1250;
  for (const ArchTable &e : kArchTables)
    if (isaEq(e.isa, isa))
      return &e;
  return nullptr;
}

static bool isPlainVALUClass(SchedClass cls) {
  switch (cls) {
  case SchedClass::Write32Bit:
  case SchedClass::Write64Bit:
  case SchedClass::WriteFloatFMA:
    return true;
  default:
    return false;
  }
}

static int getTableCycles(const ArchData &arch, SchedClass cls,
                          const ClassCycles *ArchTable::*member) {
  const ArchTable *table = selectTable(arch.isa);
  if (!table)
    llvm::report_fatal_error(llvm::Twine("no scheduling table for arch ") +
                             arch.name);
  size_t idx = static_cast<size_t>(cls);
  const ClassCycles &cycles = *(table->*member);
  if (idx >= cycles.size())
    llvm_unreachable("invalid SchedClass");
  if (!(*table->supported)[idx])
    llvm::report_fatal_error(llvm::Twine(getSchedClassName(cls)) +
                             " is unsupported on " + arch.name);
  return cycles[idx];
}

bool isSchedClassSupported(const ArchData &arch, SchedClass cls) {
  const ArchTable *table = selectTable(arch.isa);
  if (!table)
    return false;
  size_t idx = static_cast<size_t>(cls);
  return idx < table->supported->size() && (*table->supported)[idx];
}

int getLatency(const ArchData &arch, SchedClass cls) {
  int latency = getTableCycles(arch, cls, &ArchTable::latencies);
  if (isPlainVALUClass(cls))
    return std::max(latency, arch.valuPipelineDepth);
  return latency;
}

int getResourceCycles(const ArchData &arch, SchedClass cls) {
  return getTableCycles(arch, cls, &ArchTable::resourceCycles);
}

unsigned getIssueCount(const ArchData &arch, SchedClass cls) {
  return static_cast<unsigned>(
      getTableCycles(arch, cls, &ArchTable::issueCounts));
}

} // namespace mlir::waveamdmachine
