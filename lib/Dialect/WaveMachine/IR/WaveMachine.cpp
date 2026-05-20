//===- WaveMachine.cpp - WaveMachine dialect --------------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/WaveMachine/IR/WaveMachine.h"

#include "mlir/IR/Builders.h"
#include "mlir/IR/DialectImplementation.h"
#include "mlir/Interfaces/ControlFlowInterfaces.h"
#include "llvm/ADT/TypeSwitch.h"

using namespace mlir;
using namespace mlir::wavemachine;

#include "mlir/Dialect/WaveMachine/IR/WaveMachineInterfaces.cpp.inc"
#include "mlir/Dialect/WaveMachine/IR/WaveMachineOpsDialect.cpp.inc"
#include "mlir/Dialect/WaveMachine/IR/WaveMachineOpsEnums.cpp.inc"

void WaveMachineDialect::initialize() {
  registerTypes();
  addOperations<
#define GET_OP_LIST
#include "mlir/Dialect/WaveMachine/IR/WaveMachineOps.cpp.inc"
      >();
}

void WaveMachineDialect::registerTypes() {
  addTypes<
#define GET_TYPEDEF_LIST
#include "mlir/Dialect/WaveMachine/IR/WaveMachineOpsTypes.cpp.inc"
      >();
}

#define GET_TYPEDEF_CLASSES
#include "mlir/Dialect/WaveMachine/IR/WaveMachineOpsTypes.cpp.inc"

static bool isRegClassWidth(Type type, RegClass regClass, int64_t width) {
  auto regType = dyn_cast<RegType>(type);
  return regType && regType.getRegClass() == regClass &&
         regType.getWidth() == width;
}

static bool isVGPR(Type type) {
  auto regType = dyn_cast<RegType>(type);
  return regType && regType.getRegClass() == RegClass::VGPR;
}

static LogicalResult verifyVGPRWidth(Operation *op, Value value, int64_t width,
                                     StringRef name) {
  if (!isRegClassWidth(value.getType(), RegClass::VGPR, width))
    return op->emitOpError()
           << name << " must be !wavemachine.reg<vgpr, " << width << ">";
  return success();
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

static int64_t sumElementWidths(ValueRange elements) {
  int64_t total = 0;
  for (Value e : elements)
    total += cast<RegType>(e.getType()).getWidth();
  return total;
}

LogicalResult TupleToElementsOp::verify() {
  auto tupleType = cast<RegType>(getTuple().getType());
  int64_t total = sumElementWidths(getElements());
  if (tupleType.getWidth() != total)
    return emitOpError("element widths sum (")
           << total << ") must match tuple register width ("
           << tupleType.getWidth() << ")";
  return success();
}

LogicalResult TupleFromElementsOp::verify() {
  auto tupleType = cast<RegType>(getTuple().getType());
  int64_t total = sumElementWidths(getElements());
  if (tupleType.getWidth() != total)
    return emitOpError("element widths sum (")
           << total << ") must match tuple register width ("
           << tupleType.getWidth() << ")";
  return success();
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

LogicalResult MfmaF32_16x16x16_F16Op::verify() {
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

LogicalResult GlobalStoreB32Op::verify() {
  if (getNumResults() > 1)
    return emitOpError("produces at most one memory token");
  return success();
}

LogicalResult BufferStoreB32Op::verify() {
  if (getNumResults() > 1)
    return emitOpError("produces at most one memory token");
  return success();
}

LogicalResult GlobalStoreTupleB32Op::verify() {
  if (getNumResults() > 1)
    return emitOpError("produces at most one memory token");
  auto valueType = cast<RegType>(getOperand(1).getType());
  if (!isVGPR(valueType))
    return emitOpError("value operand must be a VGPR tuple");
  if (valueType.getWidth() < 1)
    return emitOpError("value tuple width must be at least 1");
  return success();
}

LogicalResult GlobalLoadB32Op::verify() {
  if (getTokens().size() > 1)
    return emitOpError("produces at most one memory token");
  return success();
}

LogicalResult GlobalLoadTupleB32Op::verify() {
  if (getTokens().size() > 1)
    return emitOpError("produces at most one memory token");
  auto resultType = cast<RegType>(getResult().getType());
  if (!isVGPR(resultType))
    return emitOpError("result must be a VGPR tuple");
  if (resultType.getWidth() < 1)
    return emitOpError("result tuple width must be at least 1");
  return success();
}

LogicalResult BufferLoadB32Op::verify() {
  if (getTokens().size() > 1)
    return emitOpError("produces at most one memory token");
  return success();
}

LogicalResult BufferLoadTupleB32Op::verify() {
  if (getTokens().size() > 1)
    return emitOpError("produces at most one memory token");
  auto resultType = cast<RegType>(getResult().getType());
  if (!isVGPR(resultType))
    return emitOpError("result must be a VGPR tuple");
  if (resultType.getWidth() < 1)
    return emitOpError("result tuple width must be at least 1");
  return success();
}

LogicalResult BufferStoreTupleB32Op::verify() {
  if (getNumResults() > 1)
    return emitOpError("produces at most one memory token");
  auto valueType = cast<RegType>(getOperand(1).getType());
  if (!isVGPR(valueType))
    return emitOpError("value operand must be a VGPR tuple");
  if (valueType.getWidth() < 1)
    return emitOpError("value tuple width must be at least 1");
  return success();
}

LogicalResult DsLoadTupleB32Op::verify() {
  if (getTokens().size() > 1)
    return emitOpError("produces at most one memory token");
  auto resultType = cast<RegType>(getResult().getType());
  if (!isVGPR(resultType))
    return emitOpError("result must be a VGPR tuple");
  if (resultType.getWidth() < 1)
    return emitOpError("result tuple width must be at least 1");
  return success();
}

LogicalResult DsStoreTupleB32Op::verify() {
  if (getNumResults() > 1)
    return emitOpError("produces at most one memory token");
  auto valueType = cast<RegType>(getValue().getType());
  if (!isVGPR(valueType))
    return emitOpError("value must be a VGPR tuple");
  if (valueType.getWidth() < 1)
    return emitOpError("value tuple width must be at least 1");
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
    return emitOpError("body must be terminated by a wavemachine.continue_if");
  return success();
}

// Body region successors (from the WaveMachine perspective):
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

LogicalResult ContinueIfOp::verify() {
  auto parent = (*this)->getParentOfType<UniformLoopOp>();
  if (!parent)
    return emitOpError("must be nested inside a wavemachine.uniform_loop");
  if (getCarries().size() != parent.getInits().size())
    return emitOpError("carries count must match parent uniform_loop inits");
  for (auto [carry, init] : llvm::zip(getCarries(), parent.getInits())) {
    if (carry.getType() != init.getType())
      return emitOpError(
                 "carry types must match parent uniform_loop init types: ")
             << carry.getType() << " vs " << init.getType();
  }
  return success();
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
#include "mlir/Dialect/WaveMachine/IR/WaveMachineOps.cpp.inc"
