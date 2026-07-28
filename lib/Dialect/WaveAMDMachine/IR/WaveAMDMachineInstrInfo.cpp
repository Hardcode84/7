//===- WaveAMDMachineInstrInfo.cpp - Machine instruction helpers ----------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachineInstrInfo.h"

#include "MCTargetDesc/AMDGPUMCTargetDesc.h"
#include "Utils/AMDGPUBaseInfo.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachine.h"
#include "llvm/ADT/STLExtras.h"

#include <array>
#include <cstdint>
#include <limits>
#include <tuple>
#include <utility>

using namespace mlir;
using namespace mlir::waveamdmachine;

static bool isInlinableIntLiteral(int64_t literal) {
  return literal >= -16 && literal <= 64;
}

static bool isInlinableLiteral32(int32_t literal) {
  if (isInlinableIntLiteral(literal))
    return true;

  static constexpr std::array<uint32_t, 9> inlineFloatBits = {
      0x00000000, 0x3f800000, 0xbf800000, 0x3f000000, 0xbf000000,
      0x40000000, 0xc0000000, 0x40800000, 0xc0800000};
  return llvm::is_contained(inlineFloatBits, static_cast<uint32_t>(literal));
}

bool mlir::waveamdmachine::isSGPRValue(Value value) {
  RegType regType = dyn_cast<RegType>(value.getType());
  return regType && regType.getRegClass() == RegClass::SGPR;
}

bool mlir::waveamdmachine::isVGPRValue(Value value) {
  RegType regType = dyn_cast<RegType>(value.getType());
  return regType && regType.getRegClass() == RegClass::VGPR;
}

bool mlir::waveamdmachine::isMachineImm(Value value) {
  return value.getDefiningOp<ImmOp>() != nullptr;
}

std::optional<int64_t> mlir::waveamdmachine::getMachineImmValue(Value value) {
  ImmOp imm = value.getDefiningOp<ImmOp>();
  if (!imm)
    return std::nullopt;
  return imm.getValue();
}

bool mlir::waveamdmachine::isSamePhysicalReg(Value lhs, Value rhs) {
  RegType lhsType = dyn_cast<RegType>(lhs.getType());
  RegType rhsType = dyn_cast<RegType>(rhs.getType());
  if (!lhsType || !rhsType)
    return false;
  return lhsType.getRegClass() == rhsType.getRegClass() &&
         lhsType.getWidth() == rhsType.getWidth() &&
         lhsType.getIndex() == rhsType.getIndex();
}

bool mlir::waveamdmachine::requiresMCTupleEncoding(OpOperand &operand) {
  Operation *owner = operand.getOwner();
  if (!isa<OperandLegalityOpInterface>(owner))
    return false;
  OperandLegalitySpec spec =
      cast<OperandLegalityOpInterface>(owner).getOperandLegality();
  unsigned operandNumber = operand.getOperandNumber();
  return operandNumber < 32 &&
         (spec.mcTupleMask & (uint32_t{1} << operandNumber)) != 0;
}

static std::optional<int64_t> parseRegisterIndex(StringRef text) {
  int64_t index = 0;
  if (text.empty())
    return std::nullopt;
  if (text.getAsInteger(10, index))
    return std::nullopt;
  if (index < 0 || index == std::numeric_limits<int64_t>::max())
    return std::nullopt;
  return index;
}

static std::optional<PhysicalRegisterSpan>
parseSGPRRegisterPair(StringRef text) {
  StringRef beginText;
  StringRef endText;
  std::tie(beginText, text) = text.split(':');
  std::tie(endText, text) = text.split(']');
  if (!text.empty())
    return std::nullopt;

  std::optional<int64_t> begin = parseRegisterIndex(beginText);
  std::optional<int64_t> end = parseRegisterIndex(endText);
  if (!begin || !end || *end < *begin)
    return std::nullopt;
  return PhysicalRegisterSpan{RegClass::SGPR, *begin, *end + 1};
}

static std::optional<PhysicalRegisterSpan>
parseSingleSGPRRegister(StringRef text) {
  std::optional<int64_t> reg = parseRegisterIndex(text);
  if (!reg)
    return std::nullopt;
  return PhysicalRegisterSpan{RegClass::SGPR, *reg, *reg + 1};
}

std::optional<PhysicalRegisterSpan>
mlir::waveamdmachine::parseSGPRRegisterSpan(StringRef text) {
  text = text.trim();
  if (!text.consume_front("s"))
    return std::nullopt;
  if (text.consume_front("["))
    return parseSGPRRegisterPair(text);
  return parseSingleSGPRRegister(text);
}

bool mlir::waveamdmachine::isInlineImm32(Value value) {
  std::optional<int64_t> imm = getMachineImmValue(value);
  if (!imm)
    return false;
  if (*imm < std::numeric_limits<int32_t>::min() ||
      *imm > std::numeric_limits<uint32_t>::max())
    return false;
  return isInlinableLiteral32(static_cast<int32_t>(*imm));
}

bool mlir::waveamdmachine::usesConstantBus(Value value) {
  if (isSGPRValue(value))
    return true;
  return isa<ImmType>(value.getType()) && !isInlineImm32(value);
}

std::optional<int64_t> mlir::waveamdmachine::getNonInlineLiteral(Value value) {
  std::optional<int64_t> imm = getMachineImmValue(value);
  if (!imm || isInlineImm32(value))
    return std::nullopt;
  return imm;
}

unsigned
mlir::waveamdmachine::getConstantBusLimit(const llvm::AMDGPU::IsaVersion &isa) {
  return isa.Major >= 10 ? 2 : 1;
}

unsigned mlir::waveamdmachine::encodeSDelayAluVALU(unsigned dependency) {
  return dependency;
}

unsigned mlir::waveamdmachine::encodeSDelayAluSALUCycle(unsigned cycles) {
  // LLVM keeps this MC encoding private to AMDGPUInsertDelayAlu.
  return cycles + 8;
}

unsigned mlir::waveamdmachine::encodeDepCtrWait(
    std::optional<unsigned> vaVdst, std::optional<unsigned> saSdst,
    std::optional<unsigned> vaSdst, const llvm::MCSubtargetInfo &sti) {
  unsigned encoded = llvm::AMDGPU::DepCtr::getDefaultDepCtrEncoding(sti);
  if (vaVdst)
    encoded = llvm::AMDGPU::DepCtr::encodeFieldVaVdst(encoded, *vaVdst);
  if (saSdst)
    encoded = llvm::AMDGPU::DepCtr::encodeFieldSaSdst(encoded, *saSdst);
  if (vaSdst)
    encoded = llvm::AMDGPU::DepCtr::encodeFieldVaSdst(encoded, *vaSdst);
  return encoded;
}

static PhysicalRegisterSpan getSGPRSpan(unsigned llvmRegister) {
  int64_t index = llvmRegister - llvm::AMDGPU::SGPR0;
  return PhysicalRegisterSpan(RegClass::SGPR, index, index + 1);
}

std::array<PhysicalRegisterSpan, 2>
mlir::waveamdmachine::getFlatScratchBaseSGPRSpans() {
  return {getSGPRSpan(llvm::AMDGPU::SGPR102),
          getSGPRSpan(llvm::AMDGPU::SGPR103)};
}

unsigned mlir::waveamdmachine::getScratchBaseForwardingSGPRWriteLimit() {
  // LLVM exposes no query for this post-RA hazard window.
  return 10;
}

static bool isGfx8Or9(const llvm::AMDGPU::IsaVersion &isa) {
  return isa.Major == 8 || isa.Major == 9;
}

static bool hasAnyMachineImm(Value lhs, Value rhs) {
  return mlir::waveamdmachine::isMachineImm(lhs) ||
         mlir::waveamdmachine::isMachineImm(rhs);
}

static bool hasTwoMachineImms(Value lhs, Value rhs) {
  return mlir::waveamdmachine::isMachineImm(lhs) &&
         mlir::waveamdmachine::isMachineImm(rhs);
}

bool mlir::waveamdmachine::sameConstantBusUse(
    Value lhs, Value rhs, SamePhysicalRegFn samePhysicalReg) {
  if (isSGPRValue(lhs) && isSGPRValue(rhs))
    return lhs == rhs || samePhysicalReg(lhs, rhs);
  std::optional<int64_t> lhsLiteral = getNonInlineLiteral(lhs);
  std::optional<int64_t> rhsLiteral = getNonInlineLiteral(rhs);
  return lhsLiteral && rhsLiteral && *lhsLiteral == *rhsLiteral;
}

static bool hasPreGfx10UnsupportedLiteral(ArrayRef<Value> operands,
                                          const llvm::AMDGPU::IsaVersion &isa) {
  if (isa.Major != 8 && isa.Major != 9)
    return false;
  for (Value operand : operands)
    if (getNonInlineLiteral(operand))
      return true;
  return false;
}

static bool hasMultipleNonInlineLiterals(ArrayRef<Value> operands) {
  std::optional<int64_t> first;
  for (Value operand : operands) {
    std::optional<int64_t> literal = getNonInlineLiteral(operand);
    if (!literal)
      continue;
    if (!first) {
      first = literal;
      continue;
    }
    if (*literal != *first)
      return true;
  }
  return false;
}

static SmallVector<Value, 4> collectMaskedOperands(Operation *op,
                                                   uint32_t mask) {
  SmallVector<Value, 4> operands;
  unsigned count = std::min<unsigned>(op->getNumOperands(), 32);
  for (unsigned i = 0; i < count; ++i)
    if (mask & (uint32_t{1} << i))
      operands.push_back(op->getOperand(i));
  return operands;
}

bool mlir::waveamdmachine::fitsConstantBus(ArrayRef<Value> operands,
                                           const llvm::AMDGPU::IsaVersion &isa,
                                           SamePhysicalRegFn samePhysicalReg) {
  SmallVector<Value, 4> uniqueUses;
  for (Value operand : operands) {
    if (!usesConstantBus(operand))
      continue;
    if (llvm::any_of(uniqueUses, [&](Value unique) {
          return sameConstantBusUse(operand, unique, samePhysicalReg);
        }))
      continue;
    uniqueUses.push_back(operand);
    if (uniqueUses.size() > getConstantBusLimit(isa))
      return false;
  }
  return true;
}

bool mlir::waveamdmachine::canUseConstantBus(
    ArrayRef<Value> operands, const llvm::AMDGPU::IsaVersion &isa,
    SamePhysicalRegFn samePhysicalReg) {
  return !hasPreGfx10UnsupportedLiteral(operands, isa) &&
         !hasMultipleNonInlineLiterals(operands) &&
         fitsConstantBus(operands, isa, samePhysicalReg);
}

LogicalResult mlir::waveamdmachine::requireConstantBus(
    Operation *op, StringRef mnemonic, ArrayRef<Value> operands,
    const llvm::AMDGPU::IsaVersion &isa, StringRef targetChip,
    SamePhysicalRegFn samePhysicalReg) {
  if (hasPreGfx10UnsupportedLiteral(operands, isa))
    return op->emitError(mnemonic)
           << " cannot use non-inline literal on " << targetChip;
  if (hasMultipleNonInlineLiterals(operands))
    return op->emitError(mnemonic)
           << " cannot use multiple non-inline literals";
  if (!fitsConstantBus(operands, isa, samePhysicalReg))
    return op->emitError(mnemonic) << " exceeds constant bus limit";
  return success();
}

LogicalResult mlir::waveamdmachine::requireOperandLegality(
    Operation *op, StringRef mnemonic, OperandLegalitySpec spec,
    const llvm::AMDGPU::IsaVersion &isa, StringRef targetChip,
    SamePhysicalRegFn samePhysicalReg) {
  if (spec.anyVGPRMask) {
    SmallVector<Value, 4> operands =
        collectMaskedOperands(op, spec.anyVGPRMask);
    if (!llvm::any_of(operands, isVGPRValue))
      return op->emitError(mnemonic) << " needs a VGPR operand";
  }
  unsigned count = std::min<unsigned>(op->getNumOperands(), 32);
  for (unsigned i = 0; i < count; ++i)
    if ((spec.vgprValueMask & (uint32_t{1} << i)) &&
        !isVGPRValue(op->getOperand(i)))
      return op->emitError(mnemonic) << " needs value operand in VGPR";
  if (spec.constantBusMask) {
    SmallVector<Value, 4> operands =
        collectMaskedOperands(op, spec.constantBusMask);
    if (failed(requireConstantBus(op, mnemonic, operands, isa, targetChip,
                                  samePhysicalReg)))
      return failure();
  }
  return success();
}

LogicalResult mlir::waveamdmachine::requireVMulU32OperandLegality(
    Operation *op, StringRef mnemonic, const llvm::AMDGPU::IsaVersion &isa,
    StringRef targetChip, SamePhysicalRegFn samePhysicalReg) {
  Value lhs = op->getOperand(0);
  Value rhs = op->getOperand(1);
  if (isGfx8Or9(isa) && hasTwoMachineImms(lhs, rhs))
    return op->emitError(mnemonic) << " cannot materialize two immediates";
  if (isGfx8Or9(isa) && hasAnyMachineImm(lhs, rhs)) {
    Value regValue = isMachineImm(lhs) ? rhs : lhs;
    if (samePhysicalReg(op->getResult(0), regValue))
      return op->emitError(mnemonic)
             << " cannot materialize immediate into aliased result";
    return requireConstantBus(op, mnemonic, {op->getResult(0), regValue}, isa,
                              targetChip, samePhysicalReg);
  }
  return requireConstantBus(op, mnemonic, {lhs, rhs}, isa, targetChip,
                            samePhysicalReg);
}

bool mlir::waveamdmachine::hasAnyVGPROperand(Value lhs, Value rhs) {
  return isVGPRValue(lhs) || isVGPRValue(rhs);
}

void mlir::waveamdmachine::putVGPROperandLast(Value &lhs, Value &rhs) {
  if (!isVGPRValue(rhs) && isVGPRValue(lhs))
    std::swap(lhs, rhs);
}

LogicalResult mlir::waveamdmachine::requireAnyVGPROperand(Operation *op,
                                                          StringRef mnemonic,
                                                          Value lhs,
                                                          Value rhs) {
  if (hasAnyVGPROperand(lhs, rhs))
    return success();
  return op->emitError(mnemonic) << " needs a VGPR operand";
}

LogicalResult mlir::waveamdmachine::requireVGPRValueOperand(Operation *op,
                                                            StringRef mnemonic,
                                                            Value value) {
  if (isVGPRValue(value))
    return success();
  return op->emitError(mnemonic) << " needs value operand in VGPR";
}
