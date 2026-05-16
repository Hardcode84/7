//===- Wave.cpp - Wave dialect ----------------------------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/Wave/IR/Wave.h"

#include "mlir/Conversion/ConvertToLLVM/ToLLVMInterface.h"
#include "mlir/Dialect/Arith/IR/Arith.h"
#include "mlir/Dialect/GPU/IR/GPUDialect.h"
#include "mlir/Dialect/SCF/IR/SCF.h"
#include "mlir/IR/Builders.h"
#include "mlir/IR/DialectImplementation.h"
#include "llvm/ADT/TypeSwitch.h"

using namespace mlir;
using namespace mlir::wave;

#include "mlir/Dialect/Wave/IR/WaveOpsDialect.cpp.inc"

void WaveDialect::initialize() {
  registerAttributes();
  registerTypes();
  addOperations<
#define GET_OP_LIST
#include "mlir/Dialect/Wave/IR/WaveOps.cpp.inc"
      >();
  // The actual interface implementation lives in MLIRWaveToLLVM and is
  // attached lazily via `registerConvertWaveToLLVMInterface`. Promising it
  // here keeps the dialect honest if anyone reaches for it before the
  // extension has run.
  declarePromisedInterface<ConvertToLLVMPatternInterface, WaveDialect>();
}

void WaveDialect::registerAttributes() {
  addAttributes<
#define GET_ATTRDEF_LIST
#include "mlir/Dialect/Wave/IR/WaveOpsAttributes.cpp.inc"
      >();
}

void WaveDialect::registerTypes() {
  addTypes<
#define GET_TYPEDEF_LIST
#include "mlir/Dialect/Wave/IR/WaveOpsTypes.cpp.inc"
      >();
}

LogicalResult WhereOp::verify() {
  auto maskType = dyn_cast<MaskType>(getCondition().getType());
  if (!maskType)
    return emitOpError("condition must be a wave mask");
  if (!getThenRegion().hasOneBlock())
    return emitOpError("then region must have one block");
  if (!getElseRegion().empty() && !getElseRegion().hasOneBlock())
    return emitOpError("otherwise region must have at most one block");
  return success();
}

LogicalResult SplatOp::verify() {
  auto simdType = cast<SimdType>(getResult().getType());
  if (simdType.getElementType() != getSource().getType())
    return emitOpError("source type must match SIMD element type");
  if (simdType.getWidth() != 32 && simdType.getWidth() != 64)
    return emitOpError("only wave32 and wave64 are supported for now");
  return success();
}

LogicalResult BinaryOp::verify() {
  auto lhsType = getLhs().getType();
  auto rhsType = getRhs().getType();
  auto resultType = getResult().getType();
  if (lhsType != rhsType || lhsType != resultType)
    return emitOpError("operands and result must have the same SIMD type");
  return success();
}

LogicalResult CmpIOp::verify() {
  auto lhsType = cast<SimdType>(getLhs().getType());
  auto rhsType = cast<SimdType>(getRhs().getType());
  if (lhsType != rhsType)
    return emitOpError("operands must have the same SIMD type");
  auto resultType = cast<MaskType>(getResult().getType());
  if (lhsType.getWidth() != resultType.getWidth())
    return emitOpError("result mask width must match operand SIMD width");
  return success();
}

LogicalResult BallotOp::verify() {
  unsigned expectedWidth =
      cast<MaskType>(getMask().getType()).getWidth() == 32 ? 32 : 64;
  auto integerType = dyn_cast<IntegerType>(getResult().getType());
  if (!integerType || integerType.getWidth() != expectedWidth)
    return emitOpError("result integer width must match mask width");
  return success();
}

LogicalResult ReadFirstOp::verify() {
  auto simdType = cast<SimdType>(getSource().getType());
  if (simdType.getElementType() != getResult().getType())
    return emitOpError("result type must match SIMD element type");
  return success();
}

LogicalResult WorkgroupIdOp::verify() {
  if (getAxis() > 2)
    return emitOpError("axis must be 0 (x), 1 (y), or 2 (z)");
  return success();
}

LogicalResult WorkitemIdOp::verify() {
  if (getAxis() > 2)
    return emitOpError("axis must be 0 (x), 1 (y), or 2 (z)");
  auto simdType = cast<SimdType>(getResult().getType());
  if (!simdType.getElementType().isInteger(32))
    return emitOpError("result SIMD element type must be i32");
  if (simdType.getWidth() != 32)
    return emitOpError("only wave32 workitem_id is supported for now");
  return success();
}

LogicalResult StoreOp::verify() {
  auto simdType = cast<SimdType>(getValue().getType());
  Type ptrType = getPtr().getType();
  Type ptrElementType;
  if (auto wavePtr = dyn_cast<PtrType>(ptrType)) {
    ptrElementType = wavePtr.getElementType();
  } else if (auto ptrSimdType = dyn_cast<SimdType>(ptrType)) {
    auto wavePtr = dyn_cast<PtrType>(ptrSimdType.getElementType());
    if (!wavePtr)
      return emitOpError("pointer SIMD element type must be a wave pointer");
    if (ptrSimdType.getWidth() != simdType.getWidth())
      return emitOpError("pointer SIMD width must match value SIMD width");
    ptrElementType = wavePtr.getElementType();
  } else {
    return emitOpError("expected wave pointer operand");
  }

  if (simdType.getElementType() != ptrElementType)
    return emitOpError("SIMD element type must match pointer element type");
  return success();
}

namespace {
// Decode a SIMD result element type into a (per-lane payload size in bits,
// transport element bit-width). For a scalar result, the transport width
// equals the payload width. For a vector result, the transport width is
// the vector element width.
struct LoadShape {
  unsigned payloadBits;
  unsigned transportBits;
};
} // namespace

static FailureOr<LoadShape>
decodeLoadShape(Type resultElementType,
                function_ref<InFlightDiagnostic(const Twine &)> emitError) {
  if (auto vecTy = dyn_cast<VectorType>(resultElementType)) {
    if (vecTy.getRank() != 1)
      return emitError("vector result must be 1-D");
    Type elt = vecTy.getElementType();
    if (!elt.isIntOrFloat())
      return emitError("vector element type must be integer or float");
    unsigned eltBits = elt.getIntOrFloatBitWidth();
    if (eltBits != 32)
      return emitError("vector element type must be 32 bits wide");
    return LoadShape{static_cast<unsigned>(vecTy.getNumElements()) * eltBits,
                     eltBits};
  }
  if (!resultElementType.isIntOrFloat())
    return emitError("result element type must be integer or float");
  unsigned bits = resultElementType.getIntOrFloatBitWidth();
  if (bits != 32)
    return emitError("scalar result element type must be 32 bits wide for now");
  return LoadShape{bits, bits};
}

LogicalResult LoadOp::verify() {
  auto emit = [this](const Twine &msg) { return emitOpError(msg); };
  auto resultSimd = cast<SimdType>(getValue().getType());

  Type ptrType = getPtr().getType();
  Type ptrElementType;
  if (auto wavePtr = dyn_cast<PtrType>(ptrType)) {
    ptrElementType = wavePtr.getElementType();
  } else if (auto ptrSimdType = dyn_cast<SimdType>(ptrType)) {
    auto wavePtr = dyn_cast<PtrType>(ptrSimdType.getElementType());
    if (!wavePtr)
      return emit("pointer SIMD element type must be a wave pointer");
    if (ptrSimdType.getWidth() != resultSimd.getWidth())
      return emit("pointer SIMD width must match result SIMD width");
    ptrElementType = wavePtr.getElementType();
  } else {
    return emit("expected wave pointer operand");
  }

  if (!ptrElementType.isIntOrFloat())
    return emit("pointer element type must be integer or float");
  unsigned ptrBits = ptrElementType.getIntOrFloatBitWidth();
  if (ptrBits != 16 && ptrBits != 32)
    return emit("only 16- and 32-bit pointer element types are supported");

  FailureOr<LoadShape> shape = decodeLoadShape(resultSimd.getElementType(),
                                               emit);
  if (failed(shape))
    return failure();

  // Per-lane payload must cover an integer number of pointer elements
  // (i.e. the load addresses an integer number of in-memory elements).
  if (shape->payloadBits % ptrBits != 0)
    return emit("per-lane payload must be a multiple of the pointer "
                "element bit width");
  return success();
}

namespace {
// Successful decomposition of `wave.ptr_add`'s base operand into the
// underlying `!wave.ptr` type plus the SIMD lane width (0 for a scalar
// base pointer).
struct PtrAddBase {
  Type pointerType;
  int64_t simdWidth;
};
} // namespace

// Validate the base operand type and return `(pointerType, simdWidth)`.
static FailureOr<PtrAddBase>
verifyPtrAddBase(Type baseType,
                 function_ref<InFlightDiagnostic(const Twine &)> emitError) {
  if (auto basePtr = dyn_cast<PtrType>(baseType))
    return PtrAddBase{basePtr, 0};
  if (auto baseSimd = dyn_cast<SimdType>(baseType)) {
    if (!isa<PtrType>(baseSimd.getElementType()))
      return emitError("base SIMD element type must be a wave pointer");
    return PtrAddBase{baseSimd.getElementType(), baseSimd.getWidth()};
  }
  return emitError("base must be a wave pointer or SIMD of wave pointers");
}

// Validate the offset operand type and return its SIMD lane width
// (0 for non-SIMD offsets).
static FailureOr<int64_t>
verifyPtrAddOffset(Type offsetType,
                   function_ref<InFlightDiagnostic(const Twine &)> emitError) {
  if (offsetType.isIndex())
    return int64_t{0};
  if (auto intType = dyn_cast<IntegerType>(offsetType)) {
    if (intType.getWidth() != 32 && intType.getWidth() != 64)
      return emitError("integer offset must be i32 or i64");
    return int64_t{0};
  }
  if (auto offsetSimd = dyn_cast<SimdType>(offsetType)) {
    if (!offsetSimd.getElementType().isInteger(32))
      return emitError("SIMD offset element type must be i32");
    return offsetSimd.getWidth();
  }
  return emitError("offset must be index, integer, or i32 SIMD");
}

// Check that `resultType` matches `pointerType` when both base and offset are
// scalar, or is a SIMD-of-pointer with the expected lane width otherwise.
static LogicalResult
verifyPtrAddResult(Type resultType, Type pointerType, int64_t simdWidth,
                   function_ref<InFlightDiagnostic(const Twine &)> emitError) {
  if (simdWidth == 0)
    return resultType == pointerType
               ? success()
               : LogicalResult(
                     emitError("result must match base pointer type"));
  auto resultSimd = dyn_cast<SimdType>(resultType);
  if (!resultSimd || resultSimd.getElementType() != pointerType ||
      resultSimd.getWidth() != simdWidth)
    return emitError("result must be a SIMD of the wave pointer type");
  return success();
}

LogicalResult LdsBaseOp::verify() {
  auto ptrType = dyn_cast<PtrType>(getResult().getType());
  if (!ptrType)
    return emitOpError("result must be a wave pointer");
  if (!isa<SharedAddressSpaceAttr>(ptrType.getAddressSpace()))
    return emitOpError("result pointer must live in the shared address space");
  return success();
}

LogicalResult PtrAddOp::verify() {
  auto emit = [this](const Twine &msg) { return emitOpError(msg); };
  auto base = verifyPtrAddBase(getBase().getType(), emit);
  if (failed(base))
    return failure();
  auto offsetWidth = verifyPtrAddOffset(getOffset().getType(), emit);
  if (failed(offsetWidth))
    return failure();

  int64_t pointerWidth = base->simdWidth;
  if (pointerWidth && *offsetWidth && pointerWidth != *offsetWidth)
    return emit("base and offset SIMD widths must match");

  int64_t resultWidth = std::max<int64_t>(pointerWidth, *offsetWidth);
  return verifyPtrAddResult(getResult().getType(), base->pointerType,
                            resultWidth, emit);
}

#define GET_OP_CLASSES
#include "mlir/Dialect/Wave/IR/WaveOps.cpp.inc"

#define GET_TYPEDEF_CLASSES
#include "mlir/Dialect/Wave/IR/WaveOpsTypes.cpp.inc"

#define GET_ATTRDEF_CLASSES
#include "mlir/Dialect/Wave/IR/WaveOpsAttributes.cpp.inc"
