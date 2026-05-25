//===- RegionProfile.h - Per-region per-FU profile ------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// Per-region per-FU cycle matrix used by the multi-wave queries
// (Stage 5B optimal-D search, Stage 5C stagger insertion, Stage 5D
// pingpong_score op). Region boundaries are auto-detected via a
// sliding-window dominant-FU detector.
//
//===----------------------------------------------------------------------===//

#ifndef MLIR_DIALECT_WAVEAMDMACHINE_COSTMODEL_REGIONPROFILE_H
#define MLIR_DIALECT_WAVEAMDMACHINE_COSTMODEL_REGIONPROFILE_H

#include "mlir/Dialect/WaveAMDMachine/CostModel/FunctionalUnit.h"
#include "mlir/Dialect/WaveAMDMachine/CostModel/PressureAnalysis.h"
#include "mlir/Support/LLVM.h"
#include "llvm/ADT/SmallVector.h"

#include <array>
#include <optional>

namespace mlir {
class Operation;
namespace func {
class FuncOp;
} // namespace func
} // namespace mlir

namespace mlir::waveamdmachine {

struct ArchData;

struct RegionProfile {
  // First op of the region (inclusive) and one-past-last (exclusive,
  // nullptr if the region runs to the end of the kernel).
  Operation *begin = nullptr;
  Operation *end = nullptr;

  // Issue cycles per functional unit. fuCycles[fu] = number of ops
  // in the region whose primary FU is `fu`.
  std::array<int, static_cast<size_t>(FunctionalUnit::NumFunctionalUnits)>
      fuCycles = {};

  // Sum of fuCycles. Number of issue slots in the region.
  int totalIssueCycles = 0;

  // Approximate wall cycles for the region. First-cut estimate;
  // refined when the multi-wave queries need it.
  int totalWallCycles = 0;

  // argmax over fuCycles. FunctionalUnit::None if the region has no
  // ops with bound FUs (shouldn't happen post-filtering).
  FunctionalUnit dominantFU = FunctionalUnit::None;
};

// Partition `func` into per-FU regions. Walks all wave.amd.machine
// ops in program order (including those inside `uniform_loop`
// bodies, visited once per iter), filters NoInst / FU-less pseudos,
// applies a sliding-window dominant-FU detector with the given
// window size and fuzzy margin (margin = dominant-count minus
// second-best, divided by window total).
//
// Defaults tuned to be re-calibrated against CK / HipKittens
// scheduling traces in Stage 6.
SmallVector<RegionProfile>
partitionRegions(func::FuncOp func, const PressureAnalysisResult &dataflow,
                 const ArchData &arch, int windowSize = 16,
                 double fuzzyMargin = 0.2);

// Result of the ping-pong delay search.
struct PingpongPick {
  int delay = 0;

  // Worst FU load across the combined timeline at this D.
  // 1.0 = saturated, >1 = bottleneck (oversubscribed contention).
  double predictedPeakUtil = 0.0;

  // FU that hits predictedPeakUtil.
  FunctionalUnit bottleneckFU = FunctionalUnit::None;

  // If the search had a target FU (PingpongObjective::maximizeFU
  // set), this is its time-averaged utilisation under this D.
  // [0, 1] where 1.0 means the target pipe is fully busy
  // throughout the combined run. 0.0 if no target was set.
  double targetFuAvgUtil = 0.0;
};

// What the search is optimising for. Default = minimise overall
// peak; with maximizeFU set, instead maximise that FU's avg
// utilisation among Ds whose overall peak doesn't exceed peakCap.
struct PingpongObjective {
  std::optional<FunctionalUnit> maximizeFU;
  double peakCap = 1.0;
};

// Score a specific delay D. If targetFU is set, also computes the
// target's avg utilisation; otherwise targetFuAvgUtil stays 0.
PingpongPick
scorePingpongDelay(ArrayRef<RegionProfile> regions, const ArchData &arch,
                   int delay,
                   std::optional<FunctionalUnit> targetFU = std::nullopt);

// Search over candidate D values (region-boundary alignments).
// Without maximizeFU: returns the D with the lowest overall peak.
// With maximizeFU: returns the D that maximises target FU's avg
// utilisation among Ds whose overall peak <= obj.peakCap; falls
// back to min-peak if no D satisfies the constraint.
// 2-wave specialisation; same convolution generalises to N waves.
PingpongPick findOptimalPingpongDelay(ArrayRef<RegionProfile> regions,
                                      const ArchData &arch,
                                      PingpongObjective obj = {});

} // namespace mlir::waveamdmachine

#endif // MLIR_DIALECT_WAVEAMDMACHINE_COSTMODEL_REGIONPROFILE_H
