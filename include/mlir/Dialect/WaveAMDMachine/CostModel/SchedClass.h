//===- SchedClass.h - Scheduling-class enum ---------------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// Bucketing enum mirroring the LLVM AMDGPU SchedWrite classes the
// cost model cares about. Each wave.amd.machine op maps to one of
// these (see OpClassifier); LatencyTable maps each one to a per-arch
// cycle count.
//
//===----------------------------------------------------------------------===//

#ifndef MLIR_DIALECT_WAVEAMDMACHINE_COSTMODEL_SCHEDCLASS_H
#define MLIR_DIALECT_WAVEAMDMACHINE_COSTMODEL_SCHEDCLASS_H

#include "mlir/Dialect/WaveAMDMachine/CostModel/CostModelEnums.h"

namespace mlir::waveamdmachine {

llvm::StringRef getSchedClassName(SchedClass cls);

} // namespace mlir::waveamdmachine

#endif // MLIR_DIALECT_WAVEAMDMACHINE_COSTMODEL_SCHEDCLASS_H
