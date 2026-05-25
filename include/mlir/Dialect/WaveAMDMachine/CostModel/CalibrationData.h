//===- CalibrationData.h - Per-arch HW-measured latency overlay -*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// Optional overlay on top of the LLVM-derived LatencyTable. Loaded
// from a JSON file produced by the microbench harness. Absent
// entries fall back to the LLVM default; the static table is
// untouched, so calibration-free callers see identical behavior.
//
// JSON schema (v1):
//
//   {
//     "schema_version": 1,
//     "arch": "gfx1100",
//     "device_name": "AMD Radeon PRO W7900",
//     "rocm_version": "6.x",
//     "measured_at": "2026-MM-DD",
//     "harness": "tools/wave-microbench/wave-microbench.py --in-kernel-cycles",
//     "notes": "free-form provenance",
//     "overrides": {
//       "<SchedClass name>": {
//         "cycles": <int>,
//         "kernel": "<path to .mlir>",
//         "notes": "<provenance / methodology>"
//       },
//       ...
//     }
//   }
//
//===----------------------------------------------------------------------===//

#ifndef MLIR_DIALECT_WAVEAMDMACHINE_COSTMODEL_CALIBRATIONDATA_H
#define MLIR_DIALECT_WAVEAMDMACHINE_COSTMODEL_CALIBRATIONDATA_H

#include "mlir/Dialect/WaveAMDMachine/CostModel/ArchData.h"
#include "mlir/Dialect/WaveAMDMachine/CostModel/SchedClass.h"
#include "mlir/Support/LLVM.h"
#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/StringRef.h"
#include "llvm/Support/Error.h"

#include <optional>
#include <string>

namespace mlir::waveamdmachine {

struct CalibrationOverride {
  int cycles = 0;
  std::string kernel;
  std::string notes;
};

class CalibrationData {
public:
  static llvm::Expected<CalibrationData> loadFromFile(llvm::StringRef path);
  static llvm::Expected<CalibrationData> loadFromString(llvm::StringRef json);

  std::optional<int> getOverrideCycles(SchedClass cls) const;
  const CalibrationOverride *getOverride(SchedClass cls) const;

  // Public fields with no invariants -- the JSON loader fills them.
  // Kept public so the loader (free helper in the .cpp) and the
  // report tool can read/write directly without yet another accessor
  // layer.
  std::string arch;
  std::string deviceName;
  std::string rocmVersion;
  std::string measuredAt;
  std::string notes;
  llvm::DenseMap<int, CalibrationOverride> overrides;
};

// Calibrated lookup: returns the override if present, else the LLVM
// default from getLatency. Keeps existing callers untouched.
int getCalibratedLatency(const ArchData &arch, SchedClass cls,
                         const CalibrationData &calibration);

// Reverse name -> enum lookup. Returns NumSchedClasses on miss.
SchedClass parseSchedClassName(llvm::StringRef name);

} // namespace mlir::waveamdmachine

#endif // MLIR_DIALECT_WAVEAMDMACHINE_COSTMODEL_CALIBRATIONDATA_H
