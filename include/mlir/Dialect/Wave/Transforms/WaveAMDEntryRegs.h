//===- WaveAMDEntryRegs.h - AMDGPU kernel entry registers -------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef MLIR_DIALECT_WAVE_TRANSFORMS_WAVEAMDENTRYREGS_H
#define MLIR_DIALECT_WAVE_TRANSFORMS_WAVEAMDENTRYREGS_H

#include "mlir/Support/LLVM.h"
#include "mlir/Support/LogicalResult.h"

#include <array>
#include <cassert>
#include <string>

namespace mlir {
class Operation;

namespace func {
class FuncOp;
} // namespace func

namespace wave {

struct WaveAMDKernelEntryRegs {
  std::array<unsigned, 3> workgroupIdSGPRs = {0, 0, 0};
  unsigned userSGPRCount = 0;
  unsigned kernargSegmentPtrSGPR = 0;
  unsigned kernargSegmentPtrWidth = 0;
  unsigned kernargPreloadDwords = 0;
  unsigned kernargPreloadOffsetDwords = 0;
  unsigned workitemIdXVGPR = 0;
  unsigned reservedSGPRs = 0;
  unsigned reservedVGPRs = 0;

  unsigned workgroupIdSGPR(unsigned axis) const {
    assert(axis < workgroupIdSGPRs.size() && "workgroup id axis out of range");
    return workgroupIdSGPRs[axis];
  }
};

StringRef getWaveAMDKernargPreloadLengthAttrName();
StringRef getWaveAMDKernargPreloadOffsetAttrName();
WaveAMDKernelEntryRegs getWaveAMDKernelEntryRegs(func::FuncOp func);
bool hasWaveAMDKernargPreloadRequest(func::FuncOp func);
FailureOr<bool> supportsWaveAMDKernargPreload(Operation *op,
                                              StringRef consumer);
LogicalResult verifyWaveAMDKernargPreloadTarget(func::FuncOp func,
                                                StringRef consumer);
unsigned getWaveAMDReservedSGPRs(func::FuncOp func);
unsigned getWaveAMDReservedVGPRs(func::FuncOp func);
std::string getWaveAMDSGPRName(unsigned index, unsigned width);

} // namespace wave
} // namespace mlir

#endif // MLIR_DIALECT_WAVE_TRANSFORMS_WAVEAMDENTRYREGS_H
