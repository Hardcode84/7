//===- WaveAMDRegPressureRelief.h - Reg pressure relief --------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef MLIR_DIALECT_WAVE_TRANSFORMS_WAVEAMDREGPRESSURERELIEF_H
#define MLIR_DIALECT_WAVE_TRANSFORMS_WAVEAMDREGPRESSURERELIEF_H

#include "mlir/IR/Value.h"
#include "mlir/Support/LLVM.h"
#include "mlir/Support/LogicalResult.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/ADT/StringRef.h"
#include <cstdint>

namespace mlir {
class OpBuilder;
class Operation;

namespace wave {

enum class WaveAMDPressureReliefStorage : uint8_t {
  SGPR,
  VGPR,
  AGPR,
  LDS,
  Scratch,
};

enum class WaveAMDPressureReliefLegality : uint8_t {
  Legal,
  UnsupportedStorage,
  UnsupportedValue,
  FixedRegister,
  InsufficientBudget,
  UnsupportedRegion,
};

struct WaveAMDPressureIntervalRef {
  SmallVector<int64_t, 4> resultIndices;
  SmallVector<int64_t, 4> slotOffsets;
  SmallVector<int64_t, 4> valuePositions;
  unsigned start = 0;
  unsigned end = 0;
  unsigned width = 0;
};

struct WaveAMDPressureFailure {
  SmallVector<WaveAMDPressureIntervalRef, 4> overlaps;
  WaveAMDPressureIntervalRef request;
  StringRef regClass;
  unsigned limit = 0;
  unsigned liveDwords = 0;
  unsigned position = 0;
  unsigned relief = 0;
  unsigned reserved = 0;
  bool combinedVGPRAGPR = false;
};

struct WaveAMDPressureReliefResourceDelta {
  int64_t sgprDwords = 0;
  int64_t vgprDwords = 0;
  int64_t agprDwords = 0;
  int64_t vgprFamilyDwords = 0;
  int64_t ldsBytes = 0;
  int64_t scratchBytes = 0;
};

struct WaveAMDPressureReliefCost {
  int64_t materializationOps = 0;
  int64_t loopWeightedOps = 0;
  int64_t latencyPenalty = 0;
  int64_t instabilityPenalty = 0;
};

struct WaveAMDPressureReliefCandidate {
  SmallVector<Value, 4> values;
  WaveAMDPressureReliefResourceDelta resourceDelta;
  WaveAMDPressureReliefCost cost;
  StringRef provider;
  StringRef reason;
  unsigned reliefDwords = 0;
  WaveAMDPressureReliefStorage sourceStorage =
      WaveAMDPressureReliefStorage::VGPR;
  WaveAMDPressureReliefStorage targetStorage =
      WaveAMDPressureReliefStorage::AGPR;
  WaveAMDPressureReliefLegality legality = WaveAMDPressureReliefLegality::Legal;
};

struct WaveAMDPressureReliefQuery {
  Operation *scope = nullptr;
  const WaveAMDPressureFailure *failure = nullptr;
};

class WaveAMDPressureReliefProvider {
public:
  virtual ~WaveAMDPressureReliefProvider();

  virtual StringRef getName() const = 0;
  virtual WaveAMDPressureReliefStorage getSourceStorage() const = 0;
  virtual WaveAMDPressureReliefStorage getTargetStorage() const = 0;

  virtual LogicalResult collectCandidates(
      const WaveAMDPressureReliefQuery &query,
      SmallVectorImpl<WaveAMDPressureReliefCandidate> &candidates) const = 0;

  virtual LogicalResult
  materialize(const WaveAMDPressureReliefCandidate &candidate,
              OpBuilder &builder) const = 0;
};

StringRef
stringifyWaveAMDPressureReliefStorage(WaveAMDPressureReliefStorage storage);
StringRef
stringifyWaveAMDPressureReliefLegality(WaveAMDPressureReliefLegality legality);
bool isLegalWaveAMDPressureReliefCandidate(
    const WaveAMDPressureReliefCandidate &candidate);
bool isBetterWaveAMDPressureReliefCandidate(
    const WaveAMDPressureReliefCandidate &lhs,
    const WaveAMDPressureReliefCandidate &rhs);

} // namespace wave
} // namespace mlir

#endif // MLIR_DIALECT_WAVE_TRANSFORMS_WAVEAMDREGPRESSURERELIEF_H
