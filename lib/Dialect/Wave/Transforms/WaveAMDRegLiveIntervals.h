//===- WaveAMDRegLiveIntervals.h - WaveAMD reg liveness --------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef MLIR_DIALECT_WAVE_TRANSFORMS_WAVEAMDREGLIVEINTERVALS_H
#define MLIR_DIALECT_WAVE_TRANSFORMS_WAVEAMDREGLIVEINTERVALS_H

#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachine.h"
#include "mlir/IR/Block.h"
#include "mlir/IR/Operation.h"
#include "mlir/IR/Value.h"
#include "mlir/Support/LLVM.h"
#include "mlir/Support/LogicalResult.h"
#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/SmallVector.h"
#include <limits>
#include <optional>

namespace mlir {
namespace func {
class FuncOp;
} // namespace func

namespace wave {

// One logical register: a Value or coalesced group sharing one block.
// Tuple/coalesced aliases record per-Value dword offsets from the base.
struct WaveAMDLiveInterval {
  SmallVector<Value> values;
  SmallVector<unsigned> slotOffsets;
  SmallVector<unsigned> valueStarts;
  SmallVector<unsigned> valueEnds;
  waveamdmachine::RegType type;
  unsigned start = std::numeric_limits<unsigned>::max();
  unsigned end = 0;
};

using WaveAMDLiveIntervalVector = SmallVector<WaveAMDLiveInterval, 0>;

struct WaveAMDLiveIntervalSet {
  WaveAMDLiveIntervalVector sgprs;
  WaveAMDLiveIntervalVector vgprs;
  WaveAMDLiveIntervalVector agprs;
  // Loop carries map init / block arg / continue carry / result together.
  DenseMap<Value, unsigned> sgprIntervals;
  DenseMap<Value, unsigned> vgprIntervals;
  DenseMap<Value, unsigned> agprIntervals;
};

struct WaveAMDLiveIntervalBuildResult {
  WaveAMDLiveIntervalSet intervals;
  SmallVector<Operation *> orderedOps;
  DenseMap<Operation *, unsigned> positions;
};

struct WaveAMDLiveIntervalOrderOverride {
  ArrayRef<Operation *> ops;
  Block *block = nullptr;
};

bool isWaveAMDReg(Value value);
bool isWaveAMDSGPR(waveamdmachine::RegType type);
bool isWaveAMDVGPR(waveamdmachine::RegType type);
bool isWaveAMDAGPR(waveamdmachine::RegType type);
bool isWaveAMDSCC(waveamdmachine::RegType type);
bool isWaveAMDVCC(waveamdmachine::RegType type);
bool isWaveAMDFlagReg(waveamdmachine::RegType type);
// Skips non-register operands and hardware flags.
std::optional<waveamdmachine::RegType> getTrackedWaveAMDRegType(Value value);
unsigned getWaveAMDLiveIntervalWidthAt(const WaveAMDLiveInterval &interval,
                                       unsigned position);
bool isWaveAMDLiveIntervalLiveAt(const WaveAMDLiveInterval &interval,
                                 unsigned position);

FailureOr<WaveAMDLiveIntervalBuildResult>
buildWaveAMDLiveIntervals(func::FuncOp func);

FailureOr<WaveAMDLiveIntervalBuildResult>
buildAllocatedWaveAMDLiveIntervals(func::FuncOp func);

// Candidate order replaces one contiguous slice in one block.
FailureOr<WaveAMDLiveIntervalBuildResult>
buildWaveAMDLiveIntervals(func::FuncOp func,
                          WaveAMDLiveIntervalOrderOverride orderOverride);

// Allocated variant keeps fixed-index registers in the pressure model.
FailureOr<WaveAMDLiveIntervalBuildResult> buildAllocatedWaveAMDLiveIntervals(
    func::FuncOp func, WaveAMDLiveIntervalOrderOverride orderOverride);

} // namespace wave
} // namespace mlir

#endif // MLIR_DIALECT_WAVE_TRANSFORMS_WAVEAMDREGLIVEINTERVALS_H
