//===- WaveAMDMachine.h - WaveAMDMachine dialect ----------------------*- C++
//-*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef MLIR_DIALECT_WAVEAMDMACHINE_IR_WAVEAMDMACHINE_H
#define MLIR_DIALECT_WAVEAMDMACHINE_IR_WAVEAMDMACHINE_H

#include "mlir/Bytecode/BytecodeOpInterface.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachineAddressFields.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachineInstrInfo.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachineTarget.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachineTraits.h"
#include "mlir/IR/Dialect.h"
#include "mlir/IR/OpDefinition.h"
#include "mlir/IR/Types.h"
#include "mlir/Interfaces/ControlFlowInterfaces.h"
#include "mlir/Interfaces/InferIntRangeInterface.h"
#include "mlir/Interfaces/LoopLikeInterface.h"
#include "mlir/Interfaces/SideEffectInterfaces.h"
// The generated op classes carry `static bool isSupportedOnIsa(...)`,
// which takes `llvm::AMDGPU::IsaVersion` by reference. The struct
// must be visible wherever the op headers are included.
#include "llvm/TargetParser/TargetParser.h"

#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachineOpsDialect.h.inc"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachineOpsEnums.h.inc"

#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachineInterfaces.h.inc"

#define GET_TYPEDEF_CLASSES
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachineOpsTypes.h.inc"

#define GET_OP_CLASSES
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachineOps.h.inc"

#endif // MLIR_DIALECT_WAVEAMDMACHINE_IR_WAVEAMDMACHINE_H
