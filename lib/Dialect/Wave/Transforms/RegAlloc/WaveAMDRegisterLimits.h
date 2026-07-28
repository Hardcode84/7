//===- WaveAMDRegisterLimits.h - AMDGPU register budgets --------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef MLIR_DIALECT_WAVE_TRANSFORMS_WAVEAMDREGISTERLIMITS_H
#define MLIR_DIALECT_WAVE_TRANSFORMS_WAVEAMDREGISTERLIMITS_H

#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/Wave/Transforms/WaveAMDEntryRegs.h"
#include "mlir/IR/BuiltinOps.h"
#include "mlir/IR/Operation.h"
#include "mlir/Support/LLVM.h"
#include "llvm/ADT/SmallVector.h"

namespace mlir::wave {

struct WaveAMDRegisterLimits {
  SmallVector<unsigned, 32> maxSGPRsForWaves;
  SmallVector<unsigned, 32> maxVGPRsForWaves;
  unsigned addressableSGPRs = 0;
  unsigned addressableVGPRs = 0;
  unsigned addressableAGPRs = 0;
  unsigned sgprAllocGranule = 0;
  unsigned vgprAllocGranule = 0;
  unsigned agprAllocGranule = 0;
  unsigned vgprTupleAlignment = 0;
  unsigned maxWavesPerEU = 0;
  bool hasTargetCapabilityContract = false;
  bool agprCountsAgainstVGPRs = false;
};

struct WaveAMDLocalMemoryLimits {
  unsigned localMemoryBytes = 0;
  unsigned addressableLocalMemoryBytes = 0;
};

FailureOr<WaveAMDRegisterLimits> getWaveAMDRegisterLimits(Operation *op);
FailureOr<WaveAMDLocalMemoryLimits>
getWaveAMDLocalMemoryLimits(Operation *op, StringRef consumer);
unsigned getEffectiveWaveAMDRegisterBudget(unsigned budget, unsigned reserved);
unsigned getMaxWaveAMDRegisterBudgetForWaves(ArrayRef<unsigned> budgets,
                                             unsigned targetWaves);

} // namespace mlir::wave

#endif // MLIR_DIALECT_WAVE_TRANSFORMS_WAVEAMDREGISTERLIMITS_H
