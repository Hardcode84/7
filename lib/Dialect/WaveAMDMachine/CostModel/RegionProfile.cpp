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
