//===- Wave.h - Wave dialect ------------------------------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef MLIR_DIALECT_WAVE_IR_WAVE_H_
#define MLIR_DIALECT_WAVE_IR_WAVE_H_

#include "mlir/Dialect/Arith/IR/Arith.h"
#include "mlir/Dialect/Transform/IR/TransformDialect.h"
#include "mlir/Dialect/Transform/Interfaces/TransformInterfaces.h"
#include "mlir/Dialect/Wave/IR/WaveSymbols.h"
#include "mlir/IR/Dialect.h"
#include "mlir/IR/OpDefinition.h"
#include "mlir/Interfaces/ControlFlowInterfaces.h"
#include "mlir/Interfaces/InferIntRangeInterface.h"
#include "mlir/Interfaces/SideEffectInterfaces.h"
#include "llvm/ADT/SmallVector.h"

#include <memory>
#include <optional>

#include "mlir/Dialect/Wave/IR/WaveOpsDialect.h.inc"
#include "mlir/Dialect/Wave/IR/WaveOpsEnums.h.inc"

#define GET_ATTRDEF_CLASSES
#include "mlir/Dialect/Wave/IR/WaveOpsAttributes.h.inc"

#define GET_TYPEDEF_CLASSES
#include "mlir/Dialect/Wave/IR/WaveOpsTypes.h.inc"

namespace mlir::wave {
class IndexExprOp;

struct MemoryPayloadShape {
  unsigned elementBits;
  unsigned payloadBits;
  unsigned registers;
  bool useB16Op;
};

enum class SymbolicOffsetBindingKind { Uniform, Lane };

struct SymbolicOffsetBinding {
  sym::ExprHandle name;
  Value value;
  SymbolicOffsetBindingKind kind = SymbolicOffsetBindingKind::Lane;
};

struct SymbolicOffset {
  SmallVector<SymbolicOffsetBinding, 4> bindings;
  SmallVector<sym::PredHandle, 2> assumptions;
  sym::ExprHandle expr;
  unsigned laneWidth = 0;

  bool isUniform() const { return laneWidth == 0; }
};

struct MemoryAddress {
  SymbolicOffset offset;
  Value base;
};

FailureOr<SymbolicOffsetBindingKind> classifySymbolicOffsetBinding(
    Type type, function_ref<InFlightDiagnostic(const Twine &)> emitError);
unsigned getSymbolicOffsetLaneWidth(ValueRange bindings);
Type getSymbolicOffsetResultType(MLIRContext *ctx, unsigned laneWidth);
Type getIndexExprResultType(MLIRContext *ctx, ValueRange bindings);
FailureOr<SymbolicOffset> getIndexExprSymbolicOffset(IndexExprOp op);
FailureOr<MemoryPayloadShape> getMemoryPayloadShape(
    Type elementType,
    function_ref<InFlightDiagnostic(const Twine &)> emitError);
std::optional<PtrType> getWavePointerType(Type type);
bool isWavePointerLikeType(Type type);
FailureOr<std::optional<MemoryAddress>>
normalizeMemoryAddress(Value ptr, WaveDialect &dialect);
FailureOr<std::optional<sym::ExprHandle>>
computeMemoryAddressDelta(WaveDialect &dialect, const MemoryAddress &lhs,
                          const MemoryAddress &rhs);
FailureOr<std::optional<int64_t>> computeConstantMemoryAddressDelta(
    WaveDialect &dialect, const MemoryAddress &lhs, const MemoryAddress &rhs);
} // namespace mlir::wave

#define GET_OP_CLASSES
#include "mlir/Dialect/Wave/IR/WaveOps.h.inc"

#define GET_OP_CLASSES
#include "mlir/Dialect/Wave/IR/WaveTransformOps.h.inc"

#endif // MLIR_DIALECT_WAVE_IR_WAVE_H_
