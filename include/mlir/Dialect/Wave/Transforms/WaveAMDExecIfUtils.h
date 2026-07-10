//===- WaveAMDExecIfUtils.h - WaveAMD exec_if helpers ----------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef DIALECT_WAVE_TRANSFORMS_WAVEAMDEXECIFUTILS_H
#define DIALECT_WAVE_TRANSFORMS_WAVEAMDEXECIFUTILS_H

#include "mlir/Dialect/Func/IR/FuncOps.h"

namespace mlir::waveamdmachine {
class ExecIfOp;
}

namespace mlir::wave {

struct WaveAMDExecIfSaveStackInfo {
  unsigned maxDwords = 0;
  unsigned maxAlign = 1;
};

unsigned alignWaveAMDExecIfSaveSlot(unsigned value, unsigned align);

unsigned getWaveAMDExecIfMaskDwords(waveamdmachine::ExecIfOp execIf);

WaveAMDExecIfSaveStackInfo getWaveAMDExecIfSaveStackInfo(func::FuncOp func);

unsigned getWaveAMDExecIfSaveBudgetReserve(func::FuncOp func);

unsigned getWaveAMDExecIfAllocatableSGPRBudget(func::FuncOp func,
                                               unsigned sgprLimit);

unsigned getWaveAMDExecIfSaveBase(func::FuncOp func, unsigned sgprCount);

unsigned getWaveAMDExecIfReservedSGPRCount(func::FuncOp func,
                                           unsigned sgprCount);

} // namespace mlir::wave

#endif // DIALECT_WAVE_TRANSFORMS_WAVEAMDEXECIFUTILS_H
