//===- WaveMeta.cpp - WaveMeta dialect --------------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/Wave/IR/WaveMeta.h"

#include "mlir/Dialect/Arith/IR/Arith.h"
#include "mlir/IR/Builders.h"
#include "mlir/IR/DialectImplementation.h"
#include "mlir/Interfaces/ControlFlowInterfaces.h"
#include "llvm/ADT/TypeSwitch.h"

using namespace mlir;
using namespace mlir::wavemeta;

#include "mlir/Dialect/Wave/IR/WaveMetaOpsDialect.cpp.inc"

void WaveMetaDialect::initialize() {
  registerTypes();
  addOperations<
#define GET_OP_LIST
#include "mlir/Dialect/Wave/IR/WaveMetaOps.cpp.inc"
      >();
}

#define GET_TYPEDEF_CLASSES
#include "mlir/Dialect/Wave/IR/WaveMetaOpsTypes.cpp.inc"

void WaveMetaDialect::registerTypes() {
  addTypes<
#define GET_TYPEDEF_LIST
#include "mlir/Dialect/Wave/IR/WaveMetaOpsTypes.cpp.inc"
      >();
}

// Constant-folded values of `wavemeta.param` get rematerialised as
// `arith.constant` since wavemeta does not carry its own constant
// op (the param op IS the constant, but only when bound).
Operation *WaveMetaDialect::materializeConstant(OpBuilder &builder,
                                                Attribute value, Type type,
                                                Location loc) {
  if (auto typed = dyn_cast<TypedAttr>(value)) {
    if (typed.getType() != type)
      return nullptr;
    return arith::ConstantOp::create(builder, loc, type, typed);
  }
  return nullptr;
}

LogicalResult ParamOp::verify() {
  // ODS already constrains `$value` to `TypedAttrInterface`; just
  // enforce that its type matches the result.
  if (auto typed = getValueAttr())
    if (typed.getType() != getResult().getType())
      return emitOpError("value attribute type must match result type");
  return success();
}

OpFoldResult ParamOp::fold(FoldAdaptor adaptor) {
  if (std::optional<TypedAttr> value = adaptor.getValue())
    return *value;
  return {};
}

//===----------------------------------------------------------------------===//
// YieldOp
//===----------------------------------------------------------------------===//

MutableOperandRange
YieldOp::getMutableSuccessorOperands(RegionSuccessor successor) {
  return getValuesMutable();
}

//===----------------------------------------------------------------------===//
// StaticForOp
//===----------------------------------------------------------------------===//

static LogicalResult verifyLoopRegion(Operation *op, Region &body,
                                      ValueRange iterArgs) {
  Block &block = body.front();
  unsigned expectedArgs = 1 + iterArgs.size();
  if (block.getNumArguments() != expectedArgs)
    return op->emitOpError("body block expects ")
           << expectedArgs << " arguments (induction var + iter args), got "
           << block.getNumArguments();
  if (!block.getArgument(0).getType().isIndex())
    return op->emitOpError("body block first argument must be index, got ")
           << block.getArgument(0).getType();
  for (auto [idx, init] : llvm::enumerate(iterArgs)) {
    Type argType = block.getArgument(idx + 1).getType();
    if (argType != init.getType())
      return op->emitOpError("body block arg #")
             << (idx + 1) << " type " << argType
             << " must match iter_args type " << init.getType();
  }
  auto yield = dyn_cast<YieldOp>(block.getTerminator());
  if (!yield)
    return op->emitOpError("body must be terminated by wavemeta.yield");
  if (yield.getValues().size() != iterArgs.size())
    return op->emitOpError("yield operand count must equal iter_args count");
  for (auto [idx, val] : llvm::enumerate(yield.getValues())) {
    if (val.getType() != iterArgs[idx].getType())
      return op->emitOpError("yield operand #")
             << idx << " type " << val.getType()
             << " must match iter_args type " << iterArgs[idx].getType();
  }
  return success();
}

LogicalResult StaticForOp::verify() {
  return verifyLoopRegion(getOperation(), getBody(), getIterArgs());
}

// The body region is both the entry (from parent) and a back-edge
// successor. The induction var sits in the body's first block arg
// and is produced by the op itself; the remaining args (forwarded
// from `$iter_args` or from a `yield`) come through
// `getSuccessorInputs`.
void StaticForOp::getSuccessorRegions(
    RegionBranchPoint point, SmallVectorImpl<RegionSuccessor> &regions) {
  regions.push_back(RegionSuccessor(&getBody()));
  regions.push_back(RegionSuccessor::parent());
}

OperandRange StaticForOp::getEntrySuccessorOperands(RegionSuccessor successor) {
  return getIterArgs();
}

ValueRange StaticForOp::getSuccessorInputs(RegionSuccessor successor) {
  if (successor.isParent())
    return getResults();
  // Body block args excluding the induction var.
  return getBody().front().getArguments().drop_front();
}

//===----------------------------------------------------------------------===//
// UnrolledForOp
//===----------------------------------------------------------------------===//

LogicalResult UnrolledForOp::verify() {
  return verifyLoopRegion(getOperation(), getBody(), getIterArgs());
}

void UnrolledForOp::getSuccessorRegions(
    RegionBranchPoint point, SmallVectorImpl<RegionSuccessor> &regions) {
  regions.push_back(RegionSuccessor(&getBody()));
  regions.push_back(RegionSuccessor::parent());
}

OperandRange
UnrolledForOp::getEntrySuccessorOperands(RegionSuccessor successor) {
  return getIterArgs();
}

ValueRange UnrolledForOp::getSuccessorInputs(RegionSuccessor successor) {
  if (successor.isParent())
    return getResults();
  return getBody().front().getArguments().drop_front();
}

//===----------------------------------------------------------------------===//
// StaticIfOp
//===----------------------------------------------------------------------===//

LogicalResult StaticIfOp::verify() {
  auto verifyYield = [&](Region &region, StringRef name) -> LogicalResult {
    auto yield = dyn_cast<YieldOp>(region.front().getTerminator());
    if (!yield)
      return emitOpError(name)
             << " region must be terminated by wavemeta.yield";
    if (yield.getValues().size() != getResults().size())
      return emitOpError(name)
             << " region yield operand count must match op result count";
    for (auto [idx, val] : llvm::enumerate(yield.getValues())) {
      if (val.getType() != getResults()[idx].getType())
        return emitOpError(name)
               << " region yield operand #" << idx << " type " << val.getType()
               << " must match result type " << getResults()[idx].getType();
    }
    return success();
  };
  if (failed(verifyYield(getThenRegion(), "then")))
    return failure();
  if (getElseRegion().empty()) {
    if (!getResults().empty())
      return emitOpError("else region is required when the op has results");
    return success();
  }
  return verifyYield(getElseRegion(), "else");
}

void StaticIfOp::getSuccessorRegions(
    RegionBranchPoint point, SmallVectorImpl<RegionSuccessor> &regions) {
  if (point.isParent()) {
    regions.push_back(RegionSuccessor(&getThenRegion()));
    if (!getElseRegion().empty())
      regions.push_back(RegionSuccessor(&getElseRegion()));
    else
      regions.push_back(RegionSuccessor::parent());
    return;
  }
  regions.push_back(RegionSuccessor::parent());
}

ValueRange StaticIfOp::getSuccessorInputs(RegionSuccessor successor) {
  return successor.isParent() ? ValueRange(getResults()) : ValueRange();
}

void StaticIfOp::getRegionInvocationBounds(
    ArrayRef<Attribute> operands,
    SmallVectorImpl<InvocationBounds> &invocationBounds) {
  // Exactly one of the two regions executes; the framework folds
  // tighter when `$condition` is constant.
  if (auto cond = dyn_cast_or_null<BoolAttr>(operands.front())) {
    invocationBounds.emplace_back(0, cond.getValue() ? 1 : 0);
    invocationBounds.emplace_back(0, cond.getValue() ? 0 : 1);
    return;
  }
  invocationBounds.assign(/*NumElts=*/2, InvocationBounds(0, 1));
}

//===----------------------------------------------------------------------===//
// PTupleType
//===----------------------------------------------------------------------===//

LogicalResult PTupleType::verify(function_ref<InFlightDiagnostic()> emitError,
                                 Type elementType, Attribute width) {
  if (!elementType)
    return emitError() << "element type must be non-null";
  if (auto intAttr = dyn_cast<IntegerAttr>(width)) {
    if (intAttr.getInt() < 0)
      return emitError() << "concrete width must be non-negative, got "
                         << intAttr.getInt();
    return success();
  }
  if (isa<StringAttr>(width))
    return success();
  return emitError()
         << "width must be a StringAttr (parameter name) or IntegerAttr "
            "(concrete width)";
}

//===----------------------------------------------------------------------===//
// TupleMakeBroadcastOp
//===----------------------------------------------------------------------===//

LogicalResult TupleMakeBroadcastOp::verify() {
  auto resultType = cast<PTupleType>(getResult().getType());
  if (resultType.getElementType() != getInit().getType())
    return emitOpError("init type ")
           << getInit().getType() << " must match result tuple element type "
           << resultType.getElementType();
  return success();
}

//===----------------------------------------------------------------------===//
// TupleMakeOp
//===----------------------------------------------------------------------===//

LogicalResult TupleMakeOp::verify() {
  auto resultType = cast<PTupleType>(getResult().getType());
  auto widthAttr = dyn_cast<IntegerAttr>(resultType.getWidth());
  if (!widthAttr)
    return emitOpError(
        "result tuple width must be concrete; parameter-named widths are "
        "only valid for tuple_make_broadcast");
  if (widthAttr.getInt() != static_cast<int64_t>(getElements().size()))
    return emitOpError("operand count (")
           << getElements().size() << ") must match concrete tuple width ("
           << widthAttr.getInt() << ")";
  if (!getElements().empty() &&
      resultType.getElementType() != getElements().front().getType())
    return emitOpError("operand type ")
           << getElements().front().getType()
           << " must match result tuple element type "
           << resultType.getElementType();
  return success();
}

//===----------------------------------------------------------------------===//
// TupleGetOp
//===----------------------------------------------------------------------===//

LogicalResult TupleGetOp::verify() {
  auto tupleType = cast<PTupleType>(getTuple().getType());
  if (tupleType.getElementType() != getResult().getType())
    return emitOpError("result type ")
           << getResult().getType() << " must match tuple element type "
           << tupleType.getElementType();
  return success();
}

OpFoldResult TupleGetOp::fold(FoldAdaptor adaptor) {
  // tuple_get from a broadcast collapses to the broadcasted init,
  // regardless of the index.
  if (auto bcast = getTuple().getDefiningOp<TupleMakeBroadcastOp>())
    return bcast.getInit();
  // tuple_get %t[const] from a concrete tuple_make returns the matching
  // operand.
  auto makeOp = getTuple().getDefiningOp<TupleMakeOp>();
  if (!makeOp)
    return {};
  auto idxAttr = dyn_cast_or_null<IntegerAttr>(adaptor.getIndex());
  if (!idxAttr)
    return {};
  int64_t idx = idxAttr.getInt();
  if (idx < 0 || idx >= static_cast<int64_t>(makeOp.getElements().size()))
    return {};
  return makeOp.getElements()[idx];
}

//===----------------------------------------------------------------------===//
// TupleSetOp
//===----------------------------------------------------------------------===//

LogicalResult TupleSetOp::verify() {
  auto tupleType = cast<PTupleType>(getTuple().getType());
  if (tupleType.getElementType() != getValue().getType())
    return emitOpError("value type ")
           << getValue().getType() << " must match tuple element type "
           << tupleType.getElementType();
  return success();
}

#define GET_OP_CLASSES
#include "mlir/Dialect/Wave/IR/WaveMetaOps.cpp.inc"
