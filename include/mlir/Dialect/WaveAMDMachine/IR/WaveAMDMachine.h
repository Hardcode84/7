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
#include "mlir/IR/Builders.h"
#include "mlir/IR/BuiltinAttributes.h"
#include "mlir/IR/Dialect.h"
#include "mlir/IR/OpDefinition.h"
#include "mlir/IR/Types.h"
#include "mlir/Interfaces/ControlFlowInterfaces.h"
#include "mlir/Interfaces/InferIntRangeInterface.h"
#include "mlir/Interfaces/LoopLikeInterface.h"
#include "mlir/Interfaces/SideEffectInterfaces.h"
#include "mlir/Support/LLVM.h"
#include "mlir/Support/LogicalResult.h"
#include "llvm/ADT/ArrayRef.h"
// Generated op classes expose `isSupportedOnIsa(IsaVersion)`.
#include "llvm/TargetParser/AMDGPUTargetParser.h"

#include <cstdint>

namespace mlir::waveamdmachine {

/// Relative register-storage constraint, in dwords.
struct RegisterStorageAlias {
  Value storage;
  Value alias;
  int64_t offset = 0;

  /// Alias is consumed while storage is overwritten.
  bool destructive = false;
};

/// Machine use extending past its explicit SSA operand use.
struct ImplicitRegisterUse {
  Value value;
  Operation *lastUse = nullptr;
};

struct KernelMetadataEntry {
  StringAttr name;
  Attribute value;
};

StringRef getKernelMetadataAttrName();

FailureOr<SmallVector<KernelMetadataEntry>>
getKernelMetadataEntries(Operation *op);

LogicalResult setKernelMetadataEntry(Operation *op, Builder &builder,
                                     StringRef name, Attribute value);

LogicalResult removeKernelMetadataEntries(Operation *op, Builder &builder,
                                          ArrayRef<StringRef> names);

} // namespace mlir::waveamdmachine

#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachineOpsDialect.h.inc"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachineOpsEnums.h.inc"

#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachineInterfaces.h.inc"

#define GET_TYPEDEF_CLASSES
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachineOpsTypes.h.inc"

#define GET_OP_CLASSES
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachineOps.h.inc"

namespace mlir::waveamdmachine {

inline WaitcntInfo getWaitcntInfo(Operation *op) {
  if (WaitcntInfoOpInterface info = dyn_cast<WaitcntInfoOpInterface>(op))
    return info.getWaitcntInfo();
  return {};
}

inline bool isWaveAMDMachineOp(Operation *op) {
  return isa<WaveAMDMachineDialect>(op->getDialect());
}

} // namespace mlir::waveamdmachine

#endif // MLIR_DIALECT_WAVEAMDMACHINE_IR_WAVEAMDMACHINE_H
