//===- WaveAMDMachineInstrInfo.h - Machine instruction helpers --*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef MLIR_DIALECT_WAVEAMDMACHINE_IR_WAVEAMDMACHINEINSTRINFO_H
#define MLIR_DIALECT_WAVEAMDMACHINE_IR_WAVEAMDMACHINEINSTRINFO_H

#include "mlir/IR/Operation.h"
#include "mlir/IR/Value.h"
#include "mlir/Support/LLVM.h"
#include "mlir/Support/LogicalResult.h"
#include "llvm/ADT/STLFunctionalExtras.h"
#include "llvm/TargetParser/AMDGPUTargetParser.h"

#include <cstdint>
#include <optional>

namespace mlir::waveamdmachine {

using SamePhysicalRegFn = llvm::function_ref<bool(Value, Value)>;

struct OperandLegalitySpec {
  uint32_t constantBusMask = 0;
  uint32_t anyVGPRMask = 0;
  uint32_t vgprValueMask = 0;
};

bool isSGPRValue(Value value);
bool isVGPRValue(Value value);
bool isMachineImm(Value value);
std::optional<int64_t> getMachineImmValue(Value value);
bool isSamePhysicalReg(Value lhs, Value rhs);

bool isInlineImm32(Value value);
bool usesConstantBus(Value value);
std::optional<int64_t> getNonInlineLiteral(Value value);
unsigned getConstantBusLimit(const llvm::AMDGPU::IsaVersion &isa);

bool sameConstantBusUse(Value lhs, Value rhs,
                        SamePhysicalRegFn samePhysicalReg);
bool fitsConstantBus(ArrayRef<Value> operands,
                     const llvm::AMDGPU::IsaVersion &isa,
                     SamePhysicalRegFn samePhysicalReg);
bool canUseConstantBus(ArrayRef<Value> operands,
                       const llvm::AMDGPU::IsaVersion &isa,
                       SamePhysicalRegFn samePhysicalReg);

LogicalResult requireConstantBus(Operation *op, StringRef mnemonic,
                                 ArrayRef<Value> operands,
                                 const llvm::AMDGPU::IsaVersion &isa,
                                 StringRef targetChip,
                                 SamePhysicalRegFn samePhysicalReg);
LogicalResult requireOperandLegality(Operation *op, StringRef mnemonic,
                                     OperandLegalitySpec spec,
                                     const llvm::AMDGPU::IsaVersion &isa,
                                     StringRef targetChip,
                                     SamePhysicalRegFn samePhysicalReg);
LogicalResult requireVMulU32OperandLegality(Operation *op, StringRef mnemonic,
                                            const llvm::AMDGPU::IsaVersion &isa,
                                            StringRef targetChip,
                                            SamePhysicalRegFn samePhysicalReg);

bool hasAnyVGPROperand(Value lhs, Value rhs);
void putVGPROperandLast(Value &lhs, Value &rhs);
LogicalResult requireAnyVGPROperand(Operation *op, StringRef mnemonic,
                                    Value lhs, Value rhs);
LogicalResult requireVGPRValueOperand(Operation *op, StringRef mnemonic,
                                      Value value);

} // namespace mlir::waveamdmachine

#endif // MLIR_DIALECT_WAVEAMDMACHINE_IR_WAVEAMDMACHINEINSTRINFO_H
