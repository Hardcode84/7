//===- wave-calibrate-report.cpp - Print calibration delta table ----------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// Read a calibration JSON (typically data/calibration/<arch>.json) and
// print a per-SchedClass table comparing the LLVM SISchedule.td default
// to the measured override. Empty overrides print as "-"; classes
// without measurements still get a row so the campaign progress is
// visible.
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/WaveAMDMachine/CostModel/ArchData.h"
#include "mlir/Dialect/WaveAMDMachine/CostModel/CalibrationData.h"
#include "mlir/Dialect/WaveAMDMachine/CostModel/LatencyTable.h"
#include "mlir/Dialect/WaveAMDMachine/CostModel/SchedClass.h"

#include "llvm/Support/CommandLine.h"
#include "llvm/Support/Format.h"
#include "llvm/Support/InitLLVM.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/TargetParser/TargetParser.h"

#include <cmath>
#include <cstdio>

using namespace mlir::waveamdmachine;

static llvm::cl::opt<std::string>
    inputFile(llvm::cl::Positional, llvm::cl::Required,
              llvm::cl::desc("<calibration JSON>"));

static void printHeader(const CalibrationData &calib) {
  llvm::outs() << "arch:           " << calib.arch << "\n";
  llvm::outs() << "device_name:    " << calib.deviceName << "\n";
  llvm::outs() << "rocm_version:   " << calib.rocmVersion << "\n";
  llvm::outs() << "measured_at:    " << calib.measuredAt << "\n";
  if (!calib.notes.empty())
    llvm::outs() << "notes:          " << calib.notes << "\n";
  llvm::outs() << "\n";
}

static const ArchData *resolveArch(llvm::StringRef name) {
  llvm::AMDGPU::IsaVersion isa = llvm::AMDGPU::getIsaVersion(name);
  if (isa.Major == 0 || !isArchSupported(isa))
    return nullptr;
  return &getArchData(isa);
}

static void printRow(llvm::StringRef name, int llvmDefault,
                     const CalibrationOverride *override) {
  std::string measured = "-";
  std::string delta = "-";
  if (override) {
    measured = std::to_string(override->cycles);
    if (llvmDefault > 0) {
      double pct = 100.0 *
                   (static_cast<double>(override->cycles) - llvmDefault) /
                   llvmDefault;
      char buf[32];
      std::snprintf(buf, sizeof(buf), "%+.1f%%", pct);
      delta = buf;
    } else {
      delta = "n/a";
    }
  }
  llvm::outs() << llvm::format("  %-22s %6d  %10s  %10s\n", name.str().c_str(),
                               llvmDefault, measured.c_str(), delta.c_str());
}

static int reportFor(const CalibrationData &calib) {
  printHeader(calib);
  const ArchData *arch = resolveArch(calib.arch);
  if (!arch) {
    llvm::errs() << "unsupported arch in calibration: " << calib.arch << "\n";
    return 1;
  }
  llvm::outs() << "  SchedClass             LLVM       Measured       Delta\n";
  llvm::outs() << "  ----------             ----       --------       -----\n";
  int total = 0;
  int covered = 0;
  for (int i = 0; i < static_cast<int>(SchedClass::NumSchedClasses); ++i) {
    SchedClass cls = static_cast<SchedClass>(i);
    llvm::StringRef name = getSchedClassName(cls);
    const CalibrationOverride *over = calib.getOverride(cls);
    if (!isSchedClassSupported(*arch, cls)) {
      if (over) {
        llvm::errs() << "calibration override " << name << " is unsupported on "
                     << arch->name << "\n";
        return 1;
      }
      continue;
    }
    ++total;
    if (over)
      ++covered;
    printRow(name, getLatency(*arch, cls), over);
  }
  llvm::outs() << "\n  coverage: " << covered << " / " << total
               << " SchedClasses\n";
  return 0;
}

int main(int argc, char **argv) {
  llvm::InitLLVM x(argc, argv);
  llvm::cl::ParseCommandLineOptions(
      argc, argv, "Print calibration delta table from a calibration JSON.\n");
  llvm::Expected<CalibrationData> calib =
      CalibrationData::loadFromFile(inputFile);
  if (!calib) {
    llvm::errs() << "failed to load calibration: "
                 << llvm::toString(calib.takeError()) << "\n";
    return 1;
  }
  return reportFor(*calib);
}
