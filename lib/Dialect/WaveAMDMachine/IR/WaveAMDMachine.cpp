//===- WaveAMDMachine.cpp - WaveAMDMachine dialect --------------------*- C++
//-*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachine.h"

#include "mlir/IR/Builders.h"
#include "mlir/IR/DialectImplementation.h"
#include "mlir/Interfaces/ControlFlowInterfaces.h"
#include "mlir/Interfaces/Utils/InferIntRangeCommon.h"
#include "llvm/ADT/TypeSwitch.h"

#include <cstdint>
#include <limits>

using namespace mlir;
using namespace mlir::waveamdmachine;

#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachineInterfaces.cpp.inc"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachineOpsDialect.cpp.inc"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachineOpsEnums.cpp.inc"

void WaveAMDMachineDialect::initialize() {
  registerTypes();
  addOperations<
#define GET_OP_LIST
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachineOps.cpp.inc"
      >();
}

void WaveAMDMachineDialect::registerTypes() {
  addTypes<
#define GET_TYPEDEF_LIST
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachineOpsTypes.cpp.inc"
      >();
}

static bool isSingletonFlagRegClass(RegClass regClass) {
  return regClass == RegClass::SCC || regClass == RegClass::VCC;
}

LogicalResult RegType::verify(function_ref<InFlightDiagnostic()> emitError,
                              RegClass regClass, int64_t width, int64_t index) {
  if (width <= 0)
    return emitError() << "register width must be positive";
  if (index < -1)
    return emitError() << "register index must be -1 (virtual) or non-negative";
  if (!isSingletonFlagRegClass(regClass))
    return success();
  if (width != 1)
    return emitError() << "SCC/VCC register width must be 1";
  if (index != -1)
    return emitError() << "SCC/VCC registers cannot have a physical index";
  return success();
}

#define GET_TYPEDEF_CLASSES
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachineOpsTypes.cpp.inc"

static bool isRegClassWidth(Type type, RegClass regClass, int64_t width) {
  auto regType = dyn_cast<RegType>(type);
  return regType && regType.getRegClass() == regClass &&
         regType.getWidth() == width;
}

static LogicalResult verifyVGPRWidth(Operation *op, Value value, int64_t width,
                                     StringRef name) {
  if (!isRegClassWidth(value.getType(), RegClass::VGPR, width))
    return op->emitOpError()
           << name << " must be !waveamdmachine.reg<vgpr, " << width << ">";
  return success();
}

static ConstantIntRanges
normalizeMachineU32Range(const ConstantIntRanges &range) {
  unsigned bits = range.umin().getBitWidth();
  if (bits == 32)
    return range;
  if (bits == 0 || bits > 32)
    return ConstantIntRanges::maxRange(32);
  return {range.umin().zext(32), range.umax().zext(32), range.smin().sext(32),
          range.smax().sext(32)};
}

static SmallVector<ConstantIntRanges, 2>
normalizeMachineU32Ranges(ArrayRef<ConstantIntRanges> ranges) {
  SmallVector<ConstantIntRanges, 2> normalized;
  normalized.reserve(ranges.size());
  for (const ConstantIntRanges &range : ranges)
    normalized.push_back(normalizeMachineU32Range(range));
  return normalized;
}

void ImmOp::inferResultRanges(ArrayRef<ConstantIntRanges>,
                              SetIntRangeFn setResultRange) {
  int64_t value = getValue();
  if (value < std::numeric_limits<int32_t>::min() ||
      value > std::numeric_limits<uint32_t>::max()) {
    setResultRange(getResult(), ConstantIntRanges::maxRange(32));
    return;
  }

  APInt bits(64, static_cast<uint64_t>(value), /*isSigned=*/true);
  setResultRange(getResult(), ConstantIntRanges::constant(bits.trunc(32)));
}

void VAddU32Op::inferResultRanges(ArrayRef<ConstantIntRanges> argRanges,
                                  SetIntRangeFn setResultRange) {
  setResultRange(getResult(), mlir::intrange::inferAdd(
                                  normalizeMachineU32Ranges(argRanges)));
}

void VAndB32Op::inferResultRanges(ArrayRef<ConstantIntRanges> argRanges,
                                  SetIntRangeFn setResultRange) {
  setResultRange(getResult(), mlir::intrange::inferAnd(
                                  normalizeMachineU32Ranges(argRanges)));
}

void VOrB32Op::inferResultRanges(ArrayRef<ConstantIntRanges> argRanges,
                                 SetIntRangeFn setResultRange) {
  setResultRange(getResult(),
                 mlir::intrange::inferOr(normalizeMachineU32Ranges(argRanges)));
}

void VXorB32Op::inferResultRanges(ArrayRef<ConstantIntRanges> argRanges,
                                  SetIntRangeFn setResultRange) {
  setResultRange(getResult(), mlir::intrange::inferXor(
                                  normalizeMachineU32Ranges(argRanges)));
}

void VLshlrevB32Op::inferResultRanges(ArrayRef<ConstantIntRanges> argRanges,
                                      SetIntRangeFn setResultRange) {
  setResultRange(getResult(), mlir::intrange::inferShl(
                                  normalizeMachineU32Ranges(argRanges)));
}

void VLshrrevB32Op::inferResultRanges(ArrayRef<ConstantIntRanges> argRanges,
                                      SetIntRangeFn setResultRange) {
  setResultRange(getResult(), mlir::intrange::inferShrU(
                                  normalizeMachineU32Ranges(argRanges)));
}

void VMulLoU32Op::inferResultRanges(ArrayRef<ConstantIntRanges> argRanges,
                                    SetIntRangeFn setResultRange) {
  setResultRange(getResult(), mlir::intrange::inferMul(
                                  normalizeMachineU32Ranges(argRanges)));
}

LogicalResult VMovB32TupleOp::verify() {
  auto resultType = cast<RegType>(getResult().getType());
  if (auto registers = (*this)->getAttrOfType<IntegerAttr>("registers")) {
    if (registers.getInt() != resultType.getWidth())
      return emitOpError(
          "registers attribute must match result register width");
  }
  return success();
}

static LogicalResult verifyCndmaskSource(Operation *op, Value value,
                                         unsigned resultWidth, StringRef name) {
  RegType regType = dyn_cast<RegType>(value.getType());
  if (!regType) {
    assert(isa<ImmType>(value.getType()) &&
           "ODS permits only registers or immediates");
    if (resultWidth != 1)
      return op->emitOpError(name)
             << " immediate source requires width-1 result";
    return success();
  }
  if (regType.getWidth() != resultWidth)
    return op->emitOpError(name) << " source width " << regType.getWidth()
                                 << " must match result width " << resultWidth;
  if (regType.getRegClass() != RegClass::VGPR &&
      regType.getRegClass() != RegClass::SGPR)
    return op->emitOpError(name) << " source must be VGPR or SGPR";
  return success();
}

LogicalResult VCndmaskB32TupleOp::verify() {
  RegType resultType = cast<RegType>(getResult().getType());
  if (failed(verifyCndmaskSource(*this, getFalseValue(), resultType.getWidth(),
                                 "false")) ||
      failed(verifyCndmaskSource(*this, getTrueValue(), resultType.getWidth(),
                                 "true")))
    return failure();
  RegType conditionType = cast<RegType>(getCondition().getType());
  if (conditionType.getWidth() != 1 && conditionType.getWidth() != 2)
    return emitOpError("condition width must be 1 or 2");
  return success();
}

LogicalResult SMovB32TupleOp::verify() {
  auto resultType = cast<RegType>(getResult().getType());
  if (auto registers = (*this)->getAttrOfType<IntegerAttr>("registers")) {
    if (registers.getInt() != resultType.getWidth())
      return emitOpError(
          "registers attribute must match result register width");
  }
  return success();
}

static int64_t sumElementWidths(ValueRange elements) {
  int64_t total = 0;
  for (Value e : elements)
    total += cast<RegType>(e.getType()).getWidth();
  return total;
}

static LogicalResult verifyTupleElements(Operation *op, RegType tupleType,
                                         ValueRange elements) {
  int64_t total = sumElementWidths(elements);
  if (tupleType.getWidth() != total)
    return op->emitOpError("element widths sum (")
           << total << ") must match tuple register width ("
           << tupleType.getWidth() << ")";
  for (Value e : elements) {
    auto eType = cast<RegType>(e.getType());
    if (eType.getRegClass() != tupleType.getRegClass())
      return op->emitOpError("element register class must match tuple's");
  }
  return success();
}

LogicalResult TupleToElementsOp::verify() {
  return verifyTupleElements(*this, cast<RegType>(getTuple().getType()),
                             getElements());
}

LogicalResult TupleFromElementsOp::verify() {
  return verifyTupleElements(*this, cast<RegType>(getTuple().getType()),
                             getElements());
}

LogicalResult WmmaI32_16x16x16_IU8Op::verify() {
  if (failed(verifyVGPRWidth(*this, getOperand(0), 4, "A operand")) ||
      failed(verifyVGPRWidth(*this, getOperand(1), 4, "B operand")) ||
      failed(verifyVGPRWidth(*this, getOperand(2), 8, "accumulator operand")) ||
      failed(verifyVGPRWidth(*this, getResult(), 8, "result")))
    return failure();
  return success();
}

LogicalResult WmmaF32_16x16x16_F16Op::verify() {
  if (failed(verifyVGPRWidth(*this, getOperand(0), 8, "A operand")) ||
      failed(verifyVGPRWidth(*this, getOperand(1), 8, "B operand")) ||
      failed(verifyVGPRWidth(*this, getOperand(2), 8, "accumulator operand")) ||
      failed(verifyVGPRWidth(*this, getResult(), 8, "result")))
    return failure();
  return success();
}

LogicalResult WmmaF32_16x16x16_BF16Op::verify() {
  if (failed(verifyVGPRWidth(*this, getOperand(0), 8, "A operand")) ||
      failed(verifyVGPRWidth(*this, getOperand(1), 8, "B operand")) ||
      failed(verifyVGPRWidth(*this, getOperand(2), 8, "accumulator operand")) ||
      failed(verifyVGPRWidth(*this, getResult(), 8, "result")))
    return failure();
  return success();
}

LogicalResult MfmaF32_16x16x16_F16Op::verify() {
  if (failed(verifyVGPRWidth(*this, getOperand(0), 2, "A operand")) ||
      failed(verifyVGPRWidth(*this, getOperand(1), 2, "B operand")) ||
      failed(verifyVGPRWidth(*this, getOperand(2), 4, "accumulator operand")) ||
      failed(verifyVGPRWidth(*this, getResult(), 4, "result")))
    return failure();
  return success();
}

LogicalResult MfmaF32_16x16x16_BF16Op::verify() {
  if (failed(verifyVGPRWidth(*this, getOperand(0), 2, "A operand")) ||
      failed(verifyVGPRWidth(*this, getOperand(1), 2, "B operand")) ||
      failed(verifyVGPRWidth(*this, getOperand(2), 4, "accumulator operand")) ||
      failed(verifyVGPRWidth(*this, getResult(), 4, "result")))
    return failure();
  return success();
}

LogicalResult MfmaF32_16x16x32_F16Op::verify() {
  if (failed(verifyVGPRWidth(*this, getOperand(0), 4, "A operand")) ||
      failed(verifyVGPRWidth(*this, getOperand(1), 4, "B operand")) ||
      failed(verifyVGPRWidth(*this, getOperand(2), 4, "accumulator operand")) ||
      failed(verifyVGPRWidth(*this, getResult(), 4, "result")))
    return failure();
  return success();
}

LogicalResult MfmaF32_16x16x32_BF16Op::verify() {
  if (failed(verifyVGPRWidth(*this, getOperand(0), 4, "A operand")) ||
      failed(verifyVGPRWidth(*this, getOperand(1), 4, "B operand")) ||
      failed(verifyVGPRWidth(*this, getOperand(2), 4, "accumulator operand")) ||
      failed(verifyVGPRWidth(*this, getResult(), 4, "result")))
    return failure();
  return success();
}

static LogicalResult verifyUniformLoopTerminator(UniformLoopOp loop,
                                                 ContinueIfOp terminator) {
  if (terminator.getCarries().size() != loop.getInits().size())
    return terminator.emitOpError(
        "carries count must match parent uniform_loop inits");
  for (auto [carry, init] :
       llvm::zip(terminator.getCarries(), loop.getInits())) {
    if (carry.getType() != init.getType())
      return terminator.emitOpError(
                 "carry types must match parent uniform_loop init types: ")
             << carry.getType() << " vs " << init.getType();
  }
  return success();
}

LogicalResult UniformLoopOp::verify() {
  Block &body = getBody().front();
  if (body.getNumArguments() != getInits().size())
    return emitOpError("body block must have one argument per init carry");
  for (auto [init, arg] : llvm::zip(getInits(), body.getArguments())) {
    if (init.getType() != arg.getType())
      return emitOpError(
                 "init carry types must match body block argument types: ")
             << init.getType() << " vs " << arg.getType();
  }
  if (getResults().size() != getInits().size())
    return emitOpError("results count must match inits count");
  for (auto [init, result] : llvm::zip(getInits(), getResults())) {
    if (init.getType() != result.getType())
      return emitOpError("init carry types must match result types: ")
             << init.getType() << " vs " << result.getType();
  }
  if (body.empty() || !isa<ContinueIfOp>(body.back()))
    return emitOpError(
        "body must be terminated by a waveamdmachine.continue_if");
  ContinueIfOp terminator = cast<ContinueIfOp>(body.back());
  return verifyUniformLoopTerminator(*this, terminator);
}

// Body region successors (from the WaveAMDMachine perspective):
//   - From parent: if entry_cond is missing, only the body is a
//     successor (always entered); else both the body (cond=1) and the
//     parent (cond=0; results = inits) are.
//   - From body: both the body again (continue_if cond=1) and the
//     parent (cond=0; results = continue_if.carries).
void UniformLoopOp::getSuccessorRegions(
    RegionBranchPoint point, SmallVectorImpl<RegionSuccessor> &regions) {
  if (point.isParent()) {
    regions.push_back(RegionSuccessor(&getBody()));
    if (getEntryCond())
      regions.push_back(RegionSuccessor::parent());
    return;
  }
  regions.push_back(RegionSuccessor(&getBody()));
  regions.push_back(RegionSuccessor::parent());
}

OperandRange
UniformLoopOp::getEntrySuccessorOperands(RegionSuccessor successor) {
  return getInits();
}

ValueRange UniformLoopOp::getSuccessorInputs(RegionSuccessor successor) {
  if (successor.isParent())
    return getResults();
  return getBody().getArguments();
}

llvm::SmallVector<Region *> UniformLoopOp::getLoopRegions() {
  return {&getBody()};
}

Block::BlockArgListType UniformLoopOp::getRegionIterArgs() {
  return getBody().front().getArguments();
}

std::optional<MutableArrayRef<OpOperand>>
UniformLoopOp::getYieldedValuesMutable() {
  return cast<ContinueIfOp>(getBody().front().getTerminator())
      .getCarriesMutable();
}

std::optional<ResultRange> UniformLoopOp::getLoopResults() {
  return getResults();
}

// continue_if forwards $carries to either the body block (back-edge,
// cond=1) or the parent results (exit, cond=0). The SCC `$cond`
// operand is local to the s_cbranch_scc1 the printer emits and is
// *not* forwarded.
MutableOperandRange
ContinueIfOp::getMutableSuccessorOperands(RegionSuccessor successor) {
  return getCarriesMutable();
}

#define GET_OP_CLASSES
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachineOps.cpp.inc"
