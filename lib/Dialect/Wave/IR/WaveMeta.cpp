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

using namespace mlir;
using namespace mlir::wavemeta;

#include "mlir/Dialect/Wave/IR/WaveMetaOpsDialect.cpp.inc"

void WaveMetaDialect::initialize() {
  addOperations<
#define GET_OP_LIST
#include "mlir/Dialect/Wave/IR/WaveMetaOps.cpp.inc"
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

LogicalResult StaticForOp::verify() {
  Block &block = getBody().front();
  unsigned expectedArgs = 1 + getIterArgs().size();
  if (block.getNumArguments() != expectedArgs)
    return emitOpError("body block expects ")
           << expectedArgs << " arguments (induction var + iter args), got "
           << block.getNumArguments();
  if (!block.getArgument(0).getType().isIndex())
    return emitOpError("body block first argument must be index, got ")
           << block.getArgument(0).getType();
  for (auto [idx, init] : llvm::enumerate(getIterArgs())) {
    Type argType = block.getArgument(idx + 1).getType();
    if (argType != init.getType())
      return emitOpError("body block arg #")
             << (idx + 1) << " type " << argType
             << " must match iter_args type " << init.getType();
  }
  auto yield = dyn_cast<YieldOp>(block.getTerminator());
  if (!yield)
    return emitOpError("body must be terminated by wavemeta.yield");
  if (yield.getValues().size() != getIterArgs().size())
    return emitOpError("yield operand count must equal iter_args count");
  for (auto [idx, val] : llvm::enumerate(yield.getValues())) {
    if (val.getType() != getIterArgs()[idx].getType())
      return emitOpError("yield operand #")
             << idx << " type " << val.getType()
             << " must match iter_args type " << getIterArgs()[idx].getType();
  }
  return success();
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

#define GET_OP_CLASSES
#include "mlir/Dialect/Wave/IR/WaveMetaOps.cpp.inc"
