//===- WaveAMDRegPressureRelief.cpp - Reg pressure relief -------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "WaveAMDRegPressureRelief.h"

#include "llvm/Support/ErrorHandling.h"
#include <algorithm>

using namespace mlir;

namespace mlir::wave {

WaveAMDPressureReliefProvider::~WaveAMDPressureReliefProvider() = default;

StringRef
stringifyWaveAMDPressureReliefStorage(WaveAMDPressureReliefStorage storage) {
  switch (storage) {
  case WaveAMDPressureReliefStorage::SGPR:
    return "sgpr";
  case WaveAMDPressureReliefStorage::VGPR:
    return "vgpr";
  case WaveAMDPressureReliefStorage::AGPR:
    return "agpr";
  case WaveAMDPressureReliefStorage::LDS:
    return "lds";
  case WaveAMDPressureReliefStorage::Scratch:
    return "scratch";
  }
  llvm_unreachable("unknown pressure relief storage");
}

StringRef
stringifyWaveAMDPressureReliefLegality(WaveAMDPressureReliefLegality legality) {
  switch (legality) {
  case WaveAMDPressureReliefLegality::Legal:
    return "legal";
  case WaveAMDPressureReliefLegality::UnsupportedStorage:
    return "unsupported-storage";
  case WaveAMDPressureReliefLegality::UnsupportedValue:
    return "unsupported-value";
  case WaveAMDPressureReliefLegality::FixedRegister:
    return "fixed-register";
  case WaveAMDPressureReliefLegality::InsufficientBudget:
    return "insufficient-budget";
  case WaveAMDPressureReliefLegality::UnsupportedRegion:
    return "unsupported-region";
  }
  llvm_unreachable("unknown pressure relief legality");
}

bool isLegalWaveAMDPressureReliefCandidate(
    const WaveAMDPressureReliefCandidate &candidate) {
  return candidate.legality == WaveAMDPressureReliefLegality::Legal;
}

static int64_t getTotalCost(const WaveAMDPressureReliefCandidate &candidate) {
  return candidate.cost.materializationOps + candidate.cost.loopWeightedOps +
         candidate.cost.latencyPenalty + candidate.cost.instabilityPenalty;
}

static int64_t
getTotalResourceGrowth(const WaveAMDPressureReliefCandidate &candidate) {
  const WaveAMDPressureReliefResourceDelta &delta = candidate.resourceDelta;
  return std::max<int64_t>(0, delta.sgprDwords) +
         std::max<int64_t>(0, delta.vgprDwords) +
         std::max<int64_t>(0, delta.agprDwords) +
         std::max<int64_t>(0, delta.vgprFamilyDwords) +
         std::max<int64_t>(0, delta.ldsBytes) +
         std::max<int64_t>(0, delta.scratchBytes);
}

bool isBetterWaveAMDPressureReliefCandidate(
    const WaveAMDPressureReliefCandidate &lhs,
    const WaveAMDPressureReliefCandidate &rhs) {
  bool lhsLegal = isLegalWaveAMDPressureReliefCandidate(lhs);
  bool rhsLegal = isLegalWaveAMDPressureReliefCandidate(rhs);
  if (lhsLegal != rhsLegal)
    return lhsLegal;

  int64_t lhsCost = getTotalCost(lhs);
  int64_t rhsCost = getTotalCost(rhs);
  if (lhsCost != rhsCost)
    return lhsCost < rhsCost;

  if (lhs.reliefDwords != rhs.reliefDwords)
    return lhs.reliefDwords > rhs.reliefDwords;

  int64_t lhsResources = getTotalResourceGrowth(lhs);
  int64_t rhsResources = getTotalResourceGrowth(rhs);
  if (lhsResources != rhsResources)
    return lhsResources < rhsResources;

  if (lhs.provider != rhs.provider)
    return lhs.provider < rhs.provider;

  return stringifyWaveAMDPressureReliefStorage(lhs.targetStorage) <
         stringifyWaveAMDPressureReliefStorage(rhs.targetStorage);
}

} // namespace mlir::wave
