//===- WaveMachine.h - WaveMachine dialect ----------------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef MLIR_DIALECT_WAVEMACHINE_IR_WAVEMACHINE_H
#define MLIR_DIALECT_WAVEMACHINE_IR_WAVEMACHINE_H

#include "mlir/Bytecode/BytecodeOpInterface.h"
#include "mlir/Dialect/WaveMachine/IR/WaveMachineAddressFields.h"
#include "mlir/Dialect/WaveMachine/IR/WaveMachineTraits.h"
#include "mlir/IR/Dialect.h"
#include "mlir/IR/OpDefinition.h"
#include "mlir/IR/Types.h"
#include "mlir/Interfaces/ControlFlowInterfaces.h"
#include "mlir/Interfaces/SideEffectInterfaces.h"
// The generated op classes carry `static bool isSupportedOnIsa(...)`,
// which takes `llvm::AMDGPU::IsaVersion` by reference. The struct
// must be visible wherever the op headers are included.
#include "llvm/TargetParser/TargetParser.h"

#include "mlir/Dialect/WaveMachine/IR/WaveMachineOpsDialect.h.inc"
#include "mlir/Dialect/WaveMachine/IR/WaveMachineOpsEnums.h.inc"

#include "mlir/Dialect/WaveMachine/IR/WaveMachineInterfaces.h.inc"

#define GET_TYPEDEF_CLASSES
#include "mlir/Dialect/WaveMachine/IR/WaveMachineOpsTypes.h.inc"

#define GET_OP_CLASSES
#include "mlir/Dialect/WaveMachine/IR/WaveMachineOps.h.inc"

#endif // MLIR_DIALECT_WAVEMACHINE_IR_WAVEMACHINE_H
