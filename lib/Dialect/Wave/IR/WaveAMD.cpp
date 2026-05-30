//===- WaveAMD.cpp - WaveAMD dialect ----------------------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/Wave/IR/WaveAMD.h"

#include "mlir/IR/Builders.h"
#include "mlir/IR/DialectImplementation.h"
#include "llvm/ADT/TypeSwitch.h"

using namespace mlir;
using namespace mlir::waveamd;

#include "mlir/Dialect/Wave/IR/WaveAMDOpsDialect.cpp.inc"

void WaveAMDDialect::initialize() {
  registerAttributes();
  registerTypes();
  addOperations<
#define GET_OP_LIST
#include "mlir/Dialect/Wave/IR/WaveAMDOps.cpp.inc"
      >();
}

void WaveAMDDialect::registerAttributes() {
  addAttributes<
#define GET_ATTRDEF_LIST
#include "mlir/Dialect/Wave/IR/WaveAMDOpsAttributes.cpp.inc"
      >();
}

void WaveAMDDialect::registerTypes() {
  addTypes<
#define GET_TYPEDEF_LIST
#include "mlir/Dialect/Wave/IR/WaveAMDOpsTypes.cpp.inc"
      >();
}

LogicalResult MakeBufferOp::verify() {
  auto baseType = cast<wave::PtrType>(getBase().getType());
  auto resultType = cast<wave::PtrType>(getResult().getType());
  if (!isa<wave::GlobalAddressSpaceAttr>(baseType.getAddressSpace()))
    return emitOpError("base must be a global wave pointer");
  if (!isa<BufferAddressSpaceAttr>(resultType.getAddressSpace()))
    return emitOpError("result must be a waveamd buffer pointer");
  if (baseType.getElementType() != resultType.getElementType())
    return emitOpError("base and result element types must match");
  if (!getRange().getType().isInteger(32))
    return emitOpError("range must be i32 bytes");
  return success();
}

namespace {
// Layout constraints for an A or B operand fragment.
static bool isValidABFragment(FragmentType type) {
  bool isIU8 = type.getElementType().isInteger(8) && type.getRegisters() == 4;
  bool isF16 = type.getElementType().isF16() &&
               (type.getRegisters() == 2 || type.getRegisters() == 4 ||
                type.getRegisters() == 8);
  return isIU8 || isF16;
}
// Layout constraints for an accumulator fragment.
static bool isValidAccFragment(FragmentType type) {
  Type elt = type.getElementType();
  return elt.isIntOrFloat() && elt.getIntOrFloatBitWidth() == 32 &&
         (type.getRegisters() == 4 || type.getRegisters() == 8);
}
static bool isValidFragmentRole(int64_t role) {
  return role == 0 || role == 1 || role == 2;
}
static bool is16x16Fragment(FragmentType type) {
  return type.getRows() == 16 && type.getColumns() == 16;
}
} // namespace

LogicalResult FragmentType::verify(function_ref<InFlightDiagnostic()> emitError,
                                   int64_t role, Type elementType, int64_t rows,
                                   int64_t columns, int64_t waveSize,
                                   int64_t registers) {
  if (!isValidFragmentRole(role))
    return emitError() << "fragment role must be 0 (A), 1 (B), or 2 (acc)";
  if (!elementType)
    return emitError() << "fragment element type must be non-null";
  if (!elementType.isIntOrFloat())
    return emitError() << "fragment element type must be integer or float";
  if (rows <= 0)
    return emitError() << "fragment row count must be positive";
  if (columns <= 0)
    return emitError() << "fragment column count must be positive";
  if (waveSize != 32 && waveSize != 64)
    return emitError() << "fragment wave size must be 32 or 64";
  if (registers <= 0)
    return emitError() << "fragment register count must be positive";
  return success();
}

LogicalResult FragmentPackOp::verify() {
  auto fragmentType = cast<FragmentType>(getResult().getType());
  auto simdType = cast<wave::SimdType>(getRegisters().getType());
  if (simdType.getWidth() != fragmentType.getWaveSize())
    return emitOpError("operand SIMD width must match fragment wave size");
  auto vectorType = dyn_cast<VectorType>(simdType.getElementType());
  if (!vectorType || vectorType.getRank() != 1)
    return emitOpError("operand SIMD element type must be a 1-D vector");
  Type vectorElement = vectorType.getElementType();
  if (!vectorElement.isIntOrFloat() ||
      vectorElement.getIntOrFloatBitWidth() != 32)
    return emitOpError("operand vector element type must be 32 bits wide");
  if (vectorType.getNumElements() != fragmentType.getRegisters())
    return emitOpError("operand vector element count (")
           << vectorType.getNumElements() << ") must match fragment register "
           << "count (" << fragmentType.getRegisters() << ")";
  return success();
}

LogicalResult FragmentFillOp::verify() {
  auto fragmentType = cast<FragmentType>(getResult().getType());
  if (!getSource().getType().isInteger(32))
    return emitOpError("source must be an i32 bit pattern");
  int64_t role = fragmentType.getRole();
  if (!is16x16Fragment(fragmentType))
    return emitOpError("only 16x16 fragments are supported for now");
  if (role != 2 && !isValidABFragment(fragmentType))
    return emitOpError("A/B fragments must be i8 fragments with 4 registers "
                       "or f16 fragments with 2 or 8 registers");
  if (role == 2 && !isValidAccFragment(fragmentType))
    return emitOpError(
        "accumulator fragments must be 32-bit fragments with 4 or 8 registers");
  return success();
}

namespace {
// Expected fragment-operand layout for a single WMMA kind.
struct WmmaShape {
  StringRef kind;
  // Predicate that returns true iff a fragment matches the A/B operand
  // shape (the predicate also pins the operand `role`).
  bool (*matchAB)(FragmentType, int64_t role);
  // Predicate for the accumulator operand.
  bool (*matchAcc)(FragmentType);
  StringRef abError;
  StringRef accError;
};

static bool isWmma16x16x16(FragmentType type) {
  return type.getRows() == 16 && type.getColumns() == 16 &&
         type.getWaveSize() == 32;
}
static bool isMfmaGfx95016x16x32(FragmentType type) {
  return type.getRows() == 16 && type.getColumns() == 16 &&
         type.getWaveSize() == 64;
}
static bool matchIU8AB(FragmentType type, int64_t role) {
  return type.getRole() == role && type.getElementType().isInteger(8) &&
         type.getRegisters() == 4 && isWmma16x16x16(type);
}
static bool matchI32Acc(FragmentType type) {
  return type.getRole() == 2 && type.getElementType().isInteger(32) &&
         type.getRegisters() == 8 && isWmma16x16x16(type);
}
static bool matchF16AB(FragmentType type, int64_t role) {
  return type.getRole() == role && type.getElementType().isF16() &&
         type.getRegisters() == 8 && isWmma16x16x16(type);
}
static bool matchF32Acc(FragmentType type) {
  return type.getRole() == 2 && type.getElementType().isF32() &&
         type.getRegisters() == 8 && isWmma16x16x16(type);
}
static bool matchMfmaF16AB(FragmentType type, int64_t role) {
  return type.getRole() == role && type.getElementType().isF16() &&
         type.getRegisters() == 2 && isWmma16x16x16(type);
}
static bool matchMfmaF32Acc(FragmentType type) {
  return type.getRole() == 2 && type.getElementType().isF32() &&
         type.getRegisters() == 4 && isWmma16x16x16(type);
}
static bool matchMfmaGfx950F16AB(FragmentType type, int64_t role) {
  return type.getRole() == role && type.getElementType().isF16() &&
         type.getRegisters() == 4 && isMfmaGfx95016x16x32(type);
}
static bool matchMfmaGfx950F32Acc(FragmentType type) {
  return type.getRole() == 2 && type.getElementType().isF32() &&
         type.getRegisters() == 4 && isMfmaGfx95016x16x32(type);
}

static constexpr WmmaShape kWmmaShapes[] = {
    {"wmma.i32.16x16x16.iu8", matchIU8AB, matchI32Acc,
     "must be a 16x16 i8 wave32 fragment with 4 registers",
     "accumulator must be a 16x16 i32 wave32 fragment with 8 registers"},
    {"wmma.f32.16x16x16.f16", matchF16AB, matchF32Acc,
     "must be a 16x16 f16 wave32 fragment with 8 registers",
     "accumulator must be a 16x16 f32 wave32 fragment with 8 registers"},
    {"mfma.f32.16x16x16.f16", matchMfmaF16AB, matchMfmaF32Acc,
     "must be a 16x16 f16 wave32 fragment with 2 registers",
     "accumulator must be a 16x16 f32 wave32 fragment with 4 registers"},
    {"mfma.f32.16x16x32.f16", matchMfmaGfx950F16AB, matchMfmaGfx950F32Acc,
     "must be a 16x16 f16 wave64 fragment with 4 registers",
     "accumulator must be a 16x16 f32 wave64 fragment with 4 registers"},
};
} // namespace

LogicalResult MmaOp::verify() {
  const WmmaShape *shape = nullptr;
  for (const WmmaShape &candidate : kWmmaShapes)
    if (candidate.kind == getKind()) {
      shape = &candidate;
      break;
    }
  if (!shape)
    return emitOpError("unsupported matrix operation kind");

  auto aType = cast<FragmentType>(getA().getType());
  auto bType = cast<FragmentType>(getB().getType());
  auto accType = cast<FragmentType>(getAcc().getType());
  auto resultType = cast<FragmentType>(getResult().getType());

  if (!shape->matchAB(aType, 0))
    return emitOpError("A operand ") << shape->abError;
  if (!shape->matchAB(bType, 1))
    return emitOpError("B operand ") << shape->abError;
  if (!shape->matchAcc(accType))
    return emitOpError(shape->accError);
  if (resultType != accType)
    return emitOpError("result type must match accumulator type");
  return success();
}

LogicalResult DmaLoadLdsOp::verify() {
  if (getBytes() != 4 && getBytes() != 16)
    return emitOpError("currently supports only bytes = 4 or 16");

  Type sourceType = getSource().getType();
  auto sourceSimdType = dyn_cast<wave::SimdType>(sourceType);
  if (!sourceSimdType)
    return emitOpError("source must be a SIMD wave pointer");
  auto sourcePtr = dyn_cast<wave::PtrType>(sourceSimdType.getElementType());
  if (!sourcePtr)
    return emitOpError("source SIMD element type must be a wave pointer");
  if (!isa<wave::GlobalAddressSpaceAttr, BufferAddressSpaceAttr>(
          sourcePtr.getAddressSpace()))
    return emitOpError("source pointer must be global or waveamd buffer");

  auto destPtr = cast<wave::PtrType>(getDest().getType());
  if (!isa<wave::SharedAddressSpaceAttr>(destPtr.getAddressSpace()))
    return emitOpError("destination pointer must be shared");
  if (!destPtr.getElementType().isInteger(32))
    return emitOpError("destination pointer element type must be i32");
  return success();
}

LogicalResult FragmentUnpackOp::verify() {
  auto fragmentType = cast<FragmentType>(getFragment().getType());
  auto simdType = cast<wave::SimdType>(getRegisters().getType());
  if (simdType.getWidth() != fragmentType.getWaveSize())
    return emitOpError("result SIMD width must match fragment wave size");
  auto vectorType = dyn_cast<VectorType>(simdType.getElementType());
  if (!vectorType || vectorType.getRank() != 1)
    return emitOpError("result SIMD element type must be a 1-D vector");
  Type vectorElement = vectorType.getElementType();
  if (!vectorElement.isIntOrFloat() ||
      vectorElement.getIntOrFloatBitWidth() != 32)
    return emitOpError("result vector element type must be 32 bits wide");
  if (vectorType.getNumElements() != fragmentType.getRegisters())
    return emitOpError("result vector element count (")
           << vectorType.getNumElements() << ") must match fragment register "
           << "count (" << fragmentType.getRegisters() << ")";
  return success();
}

#define GET_OP_CLASSES
#include "mlir/Dialect/Wave/IR/WaveAMDOps.cpp.inc"

#define GET_TYPEDEF_CLASSES
#include "mlir/Dialect/Wave/IR/WaveAMDOpsTypes.cpp.inc"

#define GET_ATTRDEF_CLASSES
#include "mlir/Dialect/Wave/IR/WaveAMDOpsAttributes.cpp.inc"
