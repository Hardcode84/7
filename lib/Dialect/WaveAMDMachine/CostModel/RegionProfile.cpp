//===- RegionProfile.cpp - Per-region per-FU profile ----------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/WaveAMDMachine/CostModel/RegionProfile.h"

#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/WaveAMDMachine/CostModel/ArchData.h"
#include "mlir/Dialect/WaveAMDMachine/CostModel/LatencyTable.h"
#include "mlir/Dialect/WaveAMDMachine/CostModel/OpClassifier.h"
#include "mlir/Dialect/WaveAMDMachine/CostModel/SchedClass.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachine.h"
#include "mlir/IR/Operation.h"
#include "llvm/ADT/Sequence.h"

#include <algorithm>
#include <limits>

namespace mlir::waveamdmachine {

namespace {

constexpr size_t kNumFUs =
    static_cast<size_t>(FunctionalUnit::NumFunctionalUnits);

// Flatten the func body to a linear list of FU-bearing
// wave.amd.machine ops in program order, descending into
// `uniform_loop` bodies. Skips NoInst pseudos and ops whose FU is
// None (those don't contribute to FU pressure).
static SmallVector<Operation *> flattenKernelOps(func::FuncOp func,
                                                 const ArchData &arch) {
  SmallVector<Operation *> ops;
  func.walk([&](Operation *op) {
    if (!isa<WaveAMDMachineDialect>(op->getDialect()))
      return;
    SchedClass cls = classifyOp(op);
    if (cls == SchedClass::NoInst)
      return;
    if (funit(arch, cls) == FunctionalUnit::None)
      return;
    ops.push_back(op);
  });
  return ops;
}

// Count per-FU occurrences over ops[lo..hi).
static std::array<int, kNumFUs> countFus(ArrayRef<Operation *> ops, size_t lo,
                                         size_t hi, const ArchData &arch) {
  std::array<int, kNumFUs> counts = {};
  for (size_t i = lo; i < hi; ++i)
    counts[static_cast<size_t>(funit(arch, classifyOp(ops[i])))] += 1;
  return counts;
}

// argmax over the counts vector; returns FunctionalUnit::None if
// every entry is zero.
static FunctionalUnit argmaxFu(const std::array<int, kNumFUs> &counts) {
  size_t best = 0;
  int bestCount = -1;
  for (size_t i : llvm::seq(kNumFUs)) {
    if (counts[i] > bestCount) {
      best = i;
      bestCount = counts[i];
    }
  }
  return bestCount > 0 ? static_cast<FunctionalUnit>(best)
                       : FunctionalUnit::None;
}

// (margin = (top - second) / total). Returns 0.0 for empty windows.
static double dominanceMargin(const std::array<int, kNumFUs> &counts) {
  int top = 0, second = 0, total = 0;
  for (int c : counts) {
    total += c;
    if (c > top) {
      second = top;
      top = c;
    } else if (c > second) {
      second = c;
    }
  }
  if (total == 0)
    return 0.0;
  return static_cast<double>(top - second) / static_cast<double>(total);
}

// Build a RegionProfile from ops[startIdx..endIdx).
static RegionProfile makeRegion(ArrayRef<Operation *> ops, size_t startIdx,
                                size_t endIdx, const ArchData &arch) {
  RegionProfile p;
  p.begin = ops[startIdx];
  p.end = endIdx < ops.size() ? ops[endIdx] : nullptr;
  int wallEstimate = 0;
  int lastLatency = 0;
  for (size_t i = startIdx; i < endIdx; ++i) {
    SchedClass cls = classifyOp(ops[i]);
    FunctionalUnit fu = funit(arch, cls);
    p.fuCycles[static_cast<size_t>(fu)] += 1;
    lastLatency = getLatency(arch, cls);
    wallEstimate += 1; // one issue slot per op
  }
  p.totalIssueCycles = static_cast<int>(endIdx - startIdx);
  // Crude wall estimate: issue slots + tail latency of the last
  // op. Refined later when Stage 5B's convolution needs better
  // numbers (will plumb per-op cold absolute cycles from the
  // dataflow).
  p.totalWallCycles = wallEstimate + std::max(0, lastLatency - 1);
  p.dominantFU = argmaxFu(p.fuCycles);
  return p;
}

} // namespace

// Per-cycle issue bandwidth for an FU on this arch. SIMD-local
// pipes get 1 / simdIssuePeriod (RDNA = 1.0, CDNA wave64 = 0.25).
// CU-shared pipes default to 1.0 (rough approximation;
// rocprofiler-compute docs cap at "5 IPC per CU" overall but
// per-FU limits aren't individually published). Used as the
// denominator in peak-utilisation = combined-density / bandwidth.
static double fuBandwidth(FunctionalUnit fu, const ArchData &arch) {
  static constexpr std::array<FunctionalUnit, 4> kSimdLocal = {
      FunctionalUnit::VALU, FunctionalUnit::SALU, FunctionalUnit::TRANS,
      FunctionalUnit::MFMA_XDL};
  for (FunctionalUnit f : kSimdLocal)
    if (f == fu)
      return 1.0 / std::max(1, arch.simdIssuePeriod);
  return 1.0;
}

namespace {

// Per-FU timeline of (startCycle, endCycle, density). Non-overlapping
// per FU because each kernel region contributes at most one segment.
struct Segment {
  int start;
  int end;
  double density;
};
using FuTimeline = std::array<SmallVector<Segment, 4>, kNumFUs>;

// Build a per-FU timeline by walking regions in program order;
// each region's fuCycles[fu] becomes a segment spanning the
// region's wall-cycle range with density = fuCycles / wallCycles.
static FuTimeline buildTimeline(ArrayRef<RegionProfile> regions) {
  FuTimeline tl;
  int cursor = 0;
  for (const RegionProfile &r : regions) {
    int width = std::max(1, r.totalWallCycles);
    int start = cursor;
    int end = cursor + width;
    for (size_t fu = 0; fu < kNumFUs; ++fu) {
      if (r.fuCycles[fu] > 0) {
        double density = static_cast<double>(r.fuCycles[fu]) / width;
        tl[fu].push_back({start, end, density});
      }
    }
    cursor = end;
  }
  return tl;
}

// Density on `fu` at cycle t. Each FU's segments are non-overlapping,
// so at most one segment matches.
static double densityAt(const FuTimeline &tl, FunctionalUnit fu, int t) {
  for (const Segment &s : tl[static_cast<size_t>(fu)])
    if (s.start <= t && t < s.end)
      return s.density;
  return 0.0;
}

// Cumulative region-boundary cycles (sorted, unique).
static SmallVector<int> regionBoundaries(ArrayRef<RegionProfile> regions) {
  SmallVector<int> b = {0};
  int cursor = 0;
  for (const RegionProfile &r : regions) {
    cursor += std::max(1, r.totalWallCycles);
    b.push_back(cursor);
  }
  return b;
}

} // namespace

PingpongPick scorePingpongDelay(ArrayRef<RegionProfile> regions,
                                const ArchData &arch, int delay) {
  PingpongPick pick;
  pick.delay = delay;
  if (regions.empty())
    return pick;
  FuTimeline tl = buildTimeline(regions);
  // Event cycles to evaluate: every segment boundary from wave 0
  // and the same boundaries shifted by `delay` for wave 1.
  SmallVector<int> events;
  for (size_t fu = 0; fu < kNumFUs; ++fu) {
    for (const Segment &s : tl[fu]) {
      events.push_back(s.start);
      events.push_back(s.end);
      events.push_back(s.start + delay);
      events.push_back(s.end + delay);
    }
  }
  llvm::sort(events);
  events.erase(std::unique(events.begin(), events.end()), events.end());

  for (int t : events) {
    for (size_t fu = 0; fu < kNumFUs; ++fu) {
      double bw = fuBandwidth(static_cast<FunctionalUnit>(fu), arch);
      if (bw <= 0.0)
        continue;
      double combined =
          densityAt(tl, static_cast<FunctionalUnit>(fu), t) +
          densityAt(tl, static_cast<FunctionalUnit>(fu), t - delay);
      double load = combined / bw;
      if (load > pick.predictedPeakUtil) {
        pick.predictedPeakUtil = load;
        pick.bottleneckFU = static_cast<FunctionalUnit>(fu);
      }
    }
  }
  return pick;
}

PingpongPick findOptimalPingpongDelay(ArrayRef<RegionProfile> regions,
                                      const ArchData &arch) {
  PingpongPick best;
  best.predictedPeakUtil = std::numeric_limits<double>::infinity();
  if (regions.empty()) {
    best.predictedPeakUtil = 0.0;
    return best;
  }
  // Candidate D values = pairwise differences of region-boundary
  // cycles. O(N^2) candidates; for typical N=10..20 that's
  // hundreds, sub-millisecond per scoring call.
  SmallVector<int> boundaries = regionBoundaries(regions);
  SmallVector<int> candidates;
  for (int b0 : boundaries)
    for (int b1 : boundaries)
      if (b0 - b1 >= 0)
        candidates.push_back(b0 - b1);
  llvm::sort(candidates);
  candidates.erase(std::unique(candidates.begin(), candidates.end()),
                   candidates.end());

  for (int d : candidates) {
    PingpongPick pick = scorePingpongDelay(regions, arch, d);
    if (pick.predictedPeakUtil < best.predictedPeakUtil)
      best = pick;
  }
  return best;
}

SmallVector<RegionProfile>
partitionRegions(func::FuncOp func, const PressureAnalysisResult &dataflow,
                 const ArchData &arch, int windowSize, double fuzzyMargin) {
  (void)dataflow; // wall-cycle plumbing comes when Stage 5B needs it.
  SmallVector<Operation *> ops = flattenKernelOps(func, arch);
  SmallVector<RegionProfile> regions;
  if (ops.empty())
    return regions;

  size_t n = ops.size();
  size_t half = static_cast<size_t>(std::max(1, windowSize / 2));
  size_t regionStart = 0;
  FunctionalUnit currentDominant = FunctionalUnit::None;

  for (size_t i = 0; i < n; ++i) {
    // Window centred on i with radius half, clamped.
    size_t lo = i > half ? i - half : 0;
    size_t hi = std::min(n, i + half);
    auto counts = countFus(ops, lo, hi, arch);
    FunctionalUnit dom = argmaxFu(counts);
    double margin = dominanceMargin(counts);

    if (currentDominant == FunctionalUnit::None) {
      currentDominant = dom;
      continue;
    }
    if (dom != FunctionalUnit::None && dom != currentDominant &&
        margin >= fuzzyMargin) {
      // Emit region [regionStart, i).
      if (i > regionStart)
        regions.push_back(makeRegion(ops, regionStart, i, arch));
      regionStart = i;
      currentDominant = dom;
    }
  }

  // Final region.
  if (regionStart < n)
    regions.push_back(makeRegion(ops, regionStart, n, arch));
  return regions;
}

} // namespace mlir::waveamdmachine
