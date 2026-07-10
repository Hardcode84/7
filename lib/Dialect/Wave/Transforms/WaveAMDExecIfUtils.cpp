//===- WaveAMDExecIfUtils.cpp - WaveAMD exec_if helpers -------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/Wave/Transforms/WaveAMDExecIfUtils.h"

#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachine.h"

#include <algorithm>
#include <cassert>

using namespace mlir;

namespace mlir::wave {

unsigned alignWaveAMDExecIfSaveSlot(unsigned value, unsigned align) {
  assert(align != 0 && "alignment must be nonzero");
  return ((value + align - 1) / align) * align;
}

unsigned getWaveAMDExecIfMaskDwords(waveamdmachine::ExecIfOp execIf) {
  auto type = cast<waveamdmachine::RegType>(execIf.getCondition().getType());
  if (type.getRegClass() == waveamdmachine::RegClass::SGPR)
    return type.getWidth();
  IntegerAttr width = execIf->getAttrOfType<IntegerAttr>("mask_width");
  assert(width && "verified VCC exec_if must carry mask_width");
  return width.getInt() / 32;
}

static void collectSaveStackInfo(Operation *op, unsigned cursor,
                                 WaveAMDExecIfSaveStackInfo &info) {
  if (auto execIf = dyn_cast<waveamdmachine::ExecIfOp>(op)) {
    unsigned width = getWaveAMDExecIfMaskDwords(execIf);
    unsigned saveSlot = alignWaveAMDExecIfSaveSlot(cursor, width);
    cursor = saveSlot + width;
    info.maxDwords = std::max(info.maxDwords, cursor);
    info.maxAlign = std::max(info.maxAlign, width);
  }

  for (Region &region : op->getRegions())
    for (Block &block : region)
      for (Operation &nested : block)
        collectSaveStackInfo(&nested, cursor, info);
}

WaveAMDExecIfSaveStackInfo getWaveAMDExecIfSaveStackInfo(func::FuncOp func) {
  WaveAMDExecIfSaveStackInfo info;
  collectSaveStackInfo(func.getOperation(), 0, info);
  return info;
}

unsigned getWaveAMDExecIfSaveBudgetReserve(func::FuncOp func) {
  WaveAMDExecIfSaveStackInfo info = getWaveAMDExecIfSaveStackInfo(func);
  if (info.maxDwords == 0)
    return 0;
  return info.maxDwords + info.maxAlign - 1;
}

unsigned getWaveAMDExecIfAllocatableSGPRBudget(func::FuncOp func,
                                               unsigned sgprLimit) {
  WaveAMDExecIfSaveStackInfo info = getWaveAMDExecIfSaveStackInfo(func);
  if (info.maxDwords == 0)
    return sgprLimit;
  if (sgprLimit <= info.maxDwords)
    return 0;
  unsigned allocatable = sgprLimit - info.maxDwords;
  return (allocatable / info.maxAlign) * info.maxAlign;
}

unsigned getWaveAMDExecIfSaveBase(func::FuncOp func, unsigned sgprCount) {
  WaveAMDExecIfSaveStackInfo info = getWaveAMDExecIfSaveStackInfo(func);
  if (info.maxDwords == 0)
    return sgprCount;
  if (sgprCount < info.maxDwords)
    return alignWaveAMDExecIfSaveSlot(sgprCount, info.maxAlign);
  return alignWaveAMDExecIfSaveSlot(sgprCount - info.maxDwords, info.maxAlign);
}

unsigned getWaveAMDExecIfReservedSGPRCount(func::FuncOp func,
                                           unsigned sgprCount) {
  WaveAMDExecIfSaveStackInfo info = getWaveAMDExecIfSaveStackInfo(func);
  if (info.maxDwords == 0)
    return sgprCount;
  return alignWaveAMDExecIfSaveSlot(sgprCount, info.maxAlign) + info.maxDwords;
}

} // namespace mlir::wave
