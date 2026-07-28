//===- SchedClass.cpp - Scheduling-class enum -----------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/WaveAMDMachine/CostModel/SchedClass.h"

#include "mlir/Dialect/WaveAMDMachine/CostModel/CostModelEnums.cpp.inc"

namespace mlir::waveamdmachine {

llvm::StringRef getSchedClassName(SchedClass cls) {
  return stringifySchedClass(cls);
}

} // namespace mlir::waveamdmachine
