//===- FunctionalUnit.h - Per-arch SchedClass -> FU map ---------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// Per-(arch, SchedClass) primary LLVM processor resource.
//
//===----------------------------------------------------------------------===//

#ifndef MLIR_DIALECT_WAVEAMDMACHINE_COSTMODEL_FUNCTIONALUNIT_H
#define MLIR_DIALECT_WAVEAMDMACHINE_COSTMODEL_FUNCTIONALUNIT_H

#include "mlir/Dialect/WaveAMDMachine/CostModel/ArchData.h"
#include "mlir/Dialect/WaveAMDMachine/CostModel/CostModelEnums.h"
#include "mlir/Dialect/WaveAMDMachine/CostModel/SchedClass.h"

namespace mlir::waveamdmachine {

llvm::StringRef getFunctionalUnitName(FunctionalUnit fu);

// First non-HWRC resource in LLVM's model. Unsupported pairs are fatal.
FunctionalUnit funit(const ArchData &arch, SchedClass cls);

} // namespace mlir::waveamdmachine

#endif // MLIR_DIALECT_WAVEAMDMACHINE_COSTMODEL_FUNCTIONALUNIT_H
