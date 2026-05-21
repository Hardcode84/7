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

#define GET_OP_CLASSES
#include "mlir/Dialect/Wave/IR/WaveMetaOps.cpp.inc"
