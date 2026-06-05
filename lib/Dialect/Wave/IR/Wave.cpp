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
#include "mlir/Dialect/Utils/StaticValueUtils.h"
#include "mlir/IR/Builders.h"
#include "mlir/IR/DialectImplementation.h"
#include "mlir/IR/PatternMatch.h"
#include "mlir/Interfaces/Utils/InferIntRangeCommon.h"
#include "llvm/ADT/DenseSet.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/ADT/TypeSwitch.h"

#include <array>

using namespace mlir;
using namespace mlir::wave;

#include "mlir/Dialect/Wave/IR/WaveOpsDialect.cpp.inc"
#include "mlir/Dialect/Wave/IR/WaveOpsEnums.cpp.inc"

void WaveDialect::initialize() {
  if (!symbolStore)
    symbolStore = std::make_unique<sym::Store>();
  registerAttributes();
  registerTypes();
  addOperations<
#define GET_OP_LIST
#include "mlir/Dialect/Wave/IR/WaveOps.cpp.inc"
      ,
#define GET_OP_LIST
#include "mlir/Dialect/Wave/IR/WaveTransformOps.cpp.inc"
      >();
  // The actual interface implementation lives in MLIRWaveToLLVM and is
  // attached lazily via `registerConvertWaveToLLVMInterface`. Promising it
  // here keeps the dialect honest if anyone reaches for it before the
  // extension has run.
  declarePromisedInterface<ConvertToLLVMPatternInterface, WaveDialect>();
}

sym::Store &WaveDialect::getSymbolStore() {
  assert(symbolStore && "wave symbolic store must be initialized");
  return *symbolStore;
}

const sym::Store &WaveDialect::getSymbolStore() const {
  assert(symbolStore && "wave symbolic store must be initialized");
  return *symbolStore;
}

LogicalResult ExprAttr::verify(function_ref<InFlightDiagnostic()> emitError,
                               sym::ExprHandle value) {
  if (!sym::isExpr(value))
    return emitError() << "expected expression handle";
  return success();
}

LogicalResult PredAttr::verify(function_ref<InFlightDiagnostic()> emitError,
                               sym::PredHandle value) {
  if (!sym::isPred(value))
    return emitError() << "expected predicate handle";
  return success();
}

LogicalResult TuneEnumAttr::verify(function_ref<InFlightDiagnostic()> emitError,
                                   ArrayRef<int64_t> values) {
  if (values.empty())
    return emitError() << "tune_enum domain must be non-empty";
  return success();
}

LogicalResult
TuneRangeAttr::verify(function_ref<InFlightDiagnostic()> emitError,
                      int64_t lower, int64_t upper, int64_t step) {
  if (step <= 0)
    return emitError() << "tune_range step must be positive, got " << step;
  if (upper <= lower)
    return emitError() << "tune_range upper (" << upper
                       << ") must be greater than lower (" << lower << ")";
  return success();
}

LogicalResult
TunePow2InAttr::verify(function_ref<InFlightDiagnostic()> emitError,
                       int64_t lower, int64_t upper) {
  if (lower <= 0)
    return emitError() << "tune_pow2_in lower must be positive, got " << lower;
  if (upper < lower)
    return emitError() << "tune_pow2_in upper (" << upper
                       << ") must be >= lower (" << lower << ")";
  // At least one power of two must fit. The smallest pow2 >= lower is
  // 2^ceil(log2(lower)); reject if that overshoots `upper`.
  uint64_t p = 1;
  while (p < static_cast<uint64_t>(lower))
    p <<= 1;
  if (p > static_cast<uint64_t>(upper))
    return emitError() << "tune_pow2_in domain is empty: no power of two in ["
                       << lower << ", " << upper << "]";
  return success();
}

static bool isWaveExecutionWidth(int64_t width) {
  return width == 32 || width == 64;
}

LogicalResult SimdType::verify(function_ref<InFlightDiagnostic()> emitError,
                               Type elementType, int64_t width) {
  if (!elementType)
    return emitError() << "SIMD element type must be non-null";
  if (!isWaveExecutionWidth(width))
    return emitError() << "wave SIMD width must be 32 or 64";
  return success();
}

LogicalResult MaskType::verify(function_ref<InFlightDiagnostic()> emitError,
                               int64_t width) {
  if (!isWaveExecutionWidth(width))
    return emitError() << "wave mask width must be 32 or 64";
  return success();
}

LogicalResult PtrType::verify(function_ref<InFlightDiagnostic()> emitError,
                              Attribute addressSpace, Type elementType) {
  if (!addressSpace)
    return emitError() << "pointer address space must be non-null";
  return success();
}

std::optional<PtrType> mlir::wave::getWavePointerType(Type type) {
  if (PtrType ptrType = dyn_cast<PtrType>(type))
    return ptrType;
  SimdType simdType = dyn_cast<SimdType>(type);
  if (!simdType)
    return std::nullopt;
  if (PtrType ptrType = dyn_cast<PtrType>(simdType.getElementType()))
    return ptrType;
  return std::nullopt;
}

bool mlir::wave::isWavePointerLikeType(Type type) {
  return getWavePointerType(type).has_value();
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

LogicalResult SplatOp::verify() {
  auto simdType = cast<SimdType>(getResult().getType());
  if (simdType.getElementType() != getSource().getType())
    return emitOpError("source type must match SIMD element type");
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

ParseResult SelectOp::parse(OpAsmParser &parser, OperationState &result) {
  Type conditionType;
  Type resultType;
  SmallVector<OpAsmParser::UnresolvedOperand, 3> operands;
  if (parser.parseOperandList(operands, /*requiredOperandCount=*/3) ||
      parser.parseOptionalAttrDict(result.attributes) ||
      parser.parseColonType(resultType))
    return failure();

  if (succeeded(parser.parseOptionalComma())) {
    conditionType = resultType;
    if (parser.parseType(resultType))
      return failure();
  } else {
    conditionType = parser.getBuilder().getI1Type();
  }

  result.addTypes(resultType);
  return parser.resolveOperands(operands,
                                {conditionType, resultType, resultType},
                                parser.getNameLoc(), result.operands);
}

void SelectOp::print(OpAsmPrinter &p) {
  p << " " << getOperands();
  p.printOptionalAttrDict((*this)->getAttrs());
  p << " : ";
  if (isa<MaskType>(getCondition().getType()))
    p << getCondition().getType() << ", ";
  p << getType();
}

LogicalResult SelectOp::verify() {
  Type condType = getCondition().getType();
  Type resultType = getResult().getType();
  if (isa<MemTokenType>(resultType))
    return emitOpError("cannot select memory tokens");
  if (condType.isInteger(1))
    return success();
  auto maskType = dyn_cast<MaskType>(condType);
  if (!maskType)
    return emitOpError("condition must be i1 or !wave.mask");
  if (auto simdType = dyn_cast<SimdType>(resultType)) {
    if (simdType.getWidth() != maskType.getWidth())
      return emitOpError("SIMD result width must match mask width");
    return success();
  }
  if (auto resultMaskType = dyn_cast<MaskType>(resultType)) {
    if (resultMaskType.getWidth() != maskType.getWidth())
      return emitOpError("result mask width must match condition mask width");
    return success();
  }
  return emitOpError("mask condition requires SIMD or mask result");
}

LogicalResult WhereOp::verify() {
  auto verifyYield = [&](Region &region, StringRef name) -> LogicalResult {
    auto yield = dyn_cast<YieldOp>(region.front().getTerminator());
    if (!yield)
      return emitOpError(name) << " region must be terminated by wave.yield";
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
  if (!getElseRegion().empty())
    return verifyYield(getElseRegion(), "else");
  return success();
}

namespace {
enum class WaveCastElementKind { Int, Float };

struct WaveCastShape {
  WaveCastElementKind elementKind;
  unsigned elementBits;
  std::optional<int64_t> simdWidth;
  std::optional<int64_t> vectorLength;
};

struct WaveCastPolicy {
  CastRoundingPolicyAttr rounding;
  CastSignednessPolicyAttr signedness;
  CastExtensionPolicyAttr extension;
};
} // namespace

static FailureOr<WaveCastShape> classifyWaveCastType(
    Type type, function_ref<InFlightDiagnostic(const Twine &)> emitError) {
  Type elementType = type;
  std::optional<int64_t> simdWidth;
  if (SimdType simdType = dyn_cast<SimdType>(type)) {
    elementType = simdType.getElementType();
    simdWidth = simdType.getWidth();
  }
  std::optional<int64_t> vectorLength;
  if (VectorType vectorType = dyn_cast<VectorType>(elementType)) {
    if (vectorType.getRank() != 1)
      return emitError("numeric vector payload must be 1-D");
    vectorLength = vectorType.getNumElements();
    elementType = vectorType.getElementType();
  }

  if (IntegerType integerType = dyn_cast<IntegerType>(elementType)) {
    if (!integerType.isSignless())
      return emitError("integer cast type must be signless");
    return WaveCastShape{WaveCastElementKind::Int, integerType.getWidth(),
                         simdWidth, vectorLength};
  }
  if (isa<FloatType>(elementType))
    return WaveCastShape{WaveCastElementKind::Float,
                         elementType.getIntOrFloatBitWidth(), simdWidth,
                         vectorLength};
  return emitError(
      "cast type must be a signless integer or float, optionally wrapped in "
      "vector<...> and !wave.simd<..., W>");
}

static LogicalResult requireWaveCastKind(CastOp op, WaveCastShape source,
                                         WaveCastShape result,
                                         WaveCastElementKind sourceKind,
                                         WaveCastElementKind resultKind,
                                         StringRef message) {
  if (source.elementKind != sourceKind || result.elementKind != resultKind)
    return op.emitOpError(message);
  return success();
}

static bool isWaveCastPolicyKey(StringRef name) {
  return name == "rounding" || name == "signedness" || name == "extension";
}

static FailureOr<WaveCastPolicy> getWaveCastPolicy(CastOp op) {
  WaveCastPolicy result;
  std::optional<DictionaryAttr> policy = op.getPolicy();
  if (!policy)
    return result;

  for (NamedAttribute attr : *policy)
    if (!isWaveCastPolicyKey(attr.getName().getValue()))
      return op.emitOpError("unknown policy field '")
             << attr.getName().getValue() << "'";

  Attribute rounding = policy->get("rounding");
  if (rounding) {
    result.rounding = dyn_cast<CastRoundingPolicyAttr>(rounding);
    if (!result.rounding)
      return op.emitOpError("policy 'rounding' must be #wave.cast_rounding");
  }

  Attribute signedness = policy->get("signedness");
  if (signedness) {
    result.signedness = dyn_cast<CastSignednessPolicyAttr>(signedness);
    if (!result.signedness)
      return op.emitOpError(
          "policy 'signedness' must be #wave.cast_signedness");
  }

  Attribute extension = policy->get("extension");
  if (extension) {
    result.extension = dyn_cast<CastExtensionPolicyAttr>(extension);
    if (!result.extension)
      return op.emitOpError("policy 'extension' must be #wave.cast_extension");
  }

  return result;
}

static LogicalResult verifyWaveCastKind(CastOp op, WaveCastShape source,
                                        WaveCastShape result) {
  switch (op.getKind()) {
  case CastKind::FpConvert:
    return requireWaveCastKind(op, source, result, WaveCastElementKind::Float,
                               WaveCastElementKind::Float,
                               "fpconvert requires float source and result");
  case CastKind::IntConvert:
    return requireWaveCastKind(op, source, result, WaveCastElementKind::Int,
                               WaveCastElementKind::Int,
                               "intconvert requires integer source and result");
  case CastKind::IntToFp:
    return requireWaveCastKind(op, source, result, WaveCastElementKind::Int,
                               WaveCastElementKind::Float,
                               "int_to_fp requires integer source and float "
                               "result");
  case CastKind::FpToInt:
    return requireWaveCastKind(op, source, result, WaveCastElementKind::Float,
                               WaveCastElementKind::Int,
                               "fp_to_int requires float source and integer "
                               "result");
  }
  return success();
}

static LogicalResult verifyWaveCastRoundingPolicy(CastOp op,
                                                  WaveCastPolicy policy) {
  if (!policy.rounding)
    return success();
  if (op.getKind() != CastKind::FpConvert && op.getKind() != CastKind::IntToFp)
    return op.emitOpError("rounding policy requires fpconvert or int_to_fp");
  return success();
}

static LogicalResult verifyWaveCastSignednessPolicy(CastOp op,
                                                    WaveCastPolicy policy) {
  bool needsSignedness =
      op.getKind() == CastKind::IntToFp || op.getKind() == CastKind::FpToInt;
  if (needsSignedness && !policy.signedness)
    return op.emitOpError("signedness policy required for ")
           << stringifyCastKind(op.getKind());
  if (!needsSignedness && policy.signedness)
    return op.emitOpError("signedness policy requires int_to_fp or fp_to_int");
  return success();
}

static LogicalResult verifyWaveCastExtensionPolicy(CastOp op,
                                                   WaveCastShape source,
                                                   WaveCastShape result,
                                                   WaveCastPolicy policy) {
  bool wideningIntConvert = op.getKind() == CastKind::IntConvert &&
                            result.elementBits > source.elementBits;
  if (wideningIntConvert && !policy.extension)
    return op.emitOpError("extension policy required for widening intconvert");
  if (!wideningIntConvert && policy.extension)
    return op.emitOpError(
        "extension policy only valid for widening intconvert");
  return success();
}

static LogicalResult verifyWaveCastPolicy(CastOp op, WaveCastShape source,
                                          WaveCastShape result,
                                          WaveCastPolicy policy) {
  if (failed(verifyWaveCastRoundingPolicy(op, policy)))
    return failure();
  if (failed(verifyWaveCastSignednessPolicy(op, policy)))
    return failure();
  return verifyWaveCastExtensionPolicy(op, source, result, policy);
}

LogicalResult CastOp::verify() {
  auto emit = [this](const Twine &msg) { return emitOpError(msg); };
  FailureOr<WaveCastShape> source =
      classifyWaveCastType(getSource().getType(), emit);
  FailureOr<WaveCastShape> result =
      classifyWaveCastType(getResult().getType(), emit);
  if (failed(source) || failed(result))
    return failure();

  if (source->simdWidth.has_value() != result->simdWidth.has_value())
    return emitOpError("source and result must both be scalar or both be SIMD");
  if (source->simdWidth && *source->simdWidth != *result->simdWidth)
    return emitOpError("source and result SIMD widths must match");
  if (source->vectorLength != result->vectorLength)
    return emitOpError("source and result vector lengths must match");

  FailureOr<WaveCastPolicy> policy = getWaveCastPolicy(*this);
  if (failed(policy))
    return failure();
  if (failed(verifyWaveCastKind(*this, *source, *result)))
    return failure();
  return verifyWaveCastPolicy(*this, *source, *result, *policy);
}

static VectorType getWaveVectorPayloadType(Type type) {
  if (SimdType simdType = dyn_cast<SimdType>(type))
    return cast<VectorType>(simdType.getElementType());
  return cast<VectorType>(type);
}

LogicalResult PackOp::verify() {
  OperandRange inputs = getInputs();
  if (inputs.empty())
    return emitOpError("requires at least one input");

  Type inputType = inputs.front().getType();
  Type inputElementType = inputType;
  std::optional<int64_t> inputSimdWidth;
  if (SimdType inputSimd = dyn_cast<SimdType>(inputType)) {
    inputElementType = inputSimd.getElementType();
    inputSimdWidth = inputSimd.getWidth();
  }

  Type resultType = getResult().getType();
  if (SimdType resultSimd = dyn_cast<SimdType>(resultType)) {
    if (!inputSimdWidth)
      return emitOpError("result must not be SIMD when inputs are scalar");
    if (resultSimd.getWidth() != *inputSimdWidth)
      return emitOpError("result SIMD width must match inputs");
  } else if (inputSimdWidth) {
    return emitOpError("result must be SIMD when inputs are SIMD");
  }

  VectorType vectorType = getWaveVectorPayloadType(resultType);
  if (vectorType.getElementType() != inputElementType)
    return emitOpError("result vector element type must match inputs");
  if (static_cast<size_t>(vectorType.getNumElements()) != inputs.size())
    return emitOpError("input count must match result vector length");
  return success();
}

OpFoldResult PackOp::fold(FoldAdaptor) {
  Value source;
  for (auto [index, input] : llvm::enumerate(getInputs())) {
    ExtractOp extract = input.getDefiningOp<ExtractOp>();
    if (!extract || extract.getIndex() != index)
      return {};
    if (!source)
      source = extract.getSource();
    if (extract.getSource() != source)
      return {};
  }
  if (source && source.getType() == getResult().getType())
    return source;
  return {};
}

LogicalResult ExtractOp::verify() {
  Type sourceType = getSource().getType();
  std::optional<int64_t> simdWidth;
  if (SimdType sourceSimd = dyn_cast<SimdType>(sourceType)) {
    simdWidth = sourceSimd.getWidth();
  }

  VectorType vectorType = getWaveVectorPayloadType(sourceType);
  int64_t index = getIndex();
  if (index >= vectorType.getNumElements())
    return emitOpError("index must be in source vector bounds");

  Type resultType = getResult().getType();
  if (simdWidth) {
    SimdType resultSimd = dyn_cast<SimdType>(resultType);
    if (!resultSimd)
      return emitOpError("result must be SIMD when source is SIMD");
    if (resultSimd.getWidth() != *simdWidth)
      return emitOpError("result SIMD width must match source");
    if (resultSimd.getElementType() != vectorType.getElementType())
      return emitOpError(
          "result element type must match source vector element");
    return success();
  }
  if (resultType != vectorType.getElementType())
    return emitOpError("result type must match source vector element");
  return success();
}

OpFoldResult ExtractOp::fold(FoldAdaptor) {
  PackOp pack = getSource().getDefiningOp<PackOp>();
  if (!pack)
    return {};
  uint64_t index = getIndex();
  if (index >= pack.getInputs().size())
    return {};
  return pack.getInputs()[index];
}

namespace {
// Operand shape for the width-independent arith ops: element bit-width
// plus an optional SIMD wave width (nullopt = uniform scalar).
struct WaveArithOperandShape {
  unsigned elementBits;
  std::optional<int64_t> simdWidth;
};
} // namespace

static FailureOr<WaveArithOperandShape> classifyWaveArithOperand(
    Type type, function_ref<InFlightDiagnostic(const Twine &)> emitError) {
  if (auto intTy = dyn_cast<IntegerType>(type)) {
    if (!intTy.isSignless())
      return emitError("integer operand must be signless");
    return WaveArithOperandShape{intTy.getWidth(), std::nullopt};
  }
  if (auto simdTy = dyn_cast<SimdType>(type)) {
    auto eltIntTy = dyn_cast<IntegerType>(simdTy.getElementType());
    if (!eltIntTy || !eltIntTy.isSignless())
      return emitError("SIMD operand element type must be a signless integer");
    return WaveArithOperandShape{eltIntTy.getWidth(), simdTy.getWidth()};
  }
  return emitError("operand must be a signless integer or !wave.simd<iN, W>");
}

static LogicalResult verifyWaveArithResult(
    Type resultType, unsigned elementBits, std::optional<int64_t> simdWidth,
    function_ref<InFlightDiagnostic(const Twine &)> emitError) {
  if (simdWidth) {
    auto simdTy = dyn_cast<SimdType>(resultType);
    if (!simdTy)
      return emitError(
          "result must be SIMD because at least one operand is SIMD");
    if (simdTy.getWidth() != *simdWidth)
      return emitError("result SIMD wave width must match operands");
    auto eltIntTy = dyn_cast<IntegerType>(simdTy.getElementType());
    if (!eltIntTy || eltIntTy.getWidth() != elementBits)
      return emitError("result SIMD element width must match operands");
    return success();
  }
  auto intTy = dyn_cast<IntegerType>(resultType);
  if (!intTy || intTy.getWidth() != elementBits)
    return emitError(
        "result must be a signless integer with the operand element width");
  return success();
}

static LogicalResult verifyWaveIntBinaryArith(Operation *op, Type lhsTy,
                                              Type rhsTy, Type resultTy) {
  auto emit = [op](const Twine &msg) { return op->emitOpError(msg); };
  auto lhs = classifyWaveArithOperand(lhsTy, emit);
  auto rhs = classifyWaveArithOperand(rhsTy, emit);
  if (failed(lhs) || failed(rhs))
    return failure();
  if (lhs->elementBits != rhs->elementBits)
    return emit("operand element bit-widths must match");
  if (lhs->simdWidth && rhs->simdWidth && *lhs->simdWidth != *rhs->simdWidth)
    return emit("SIMD wave widths must match across operands");
  std::optional<int64_t> resultSimd =
      lhs->simdWidth ? lhs->simdWidth : rhs->simdWidth;
  return verifyWaveArithResult(resultTy, lhs->elementBits, resultSimd, emit);
}

LogicalResult AddiOp::verify() {
  return verifyWaveIntBinaryArith(getOperation(), getLhs().getType(),
                                  getRhs().getType(), getResult().getType());
}

LogicalResult MuliOp::verify() {
  return verifyWaveIntBinaryArith(getOperation(), getLhs().getType(),
                                  getRhs().getType(), getResult().getType());
}

LogicalResult ShliOp::verify() {
  return verifyWaveIntBinaryArith(getOperation(), getLhs().getType(),
                                  getRhs().getType(), getResult().getType());
}

static bool isWavePackedF16Type(Type type) {
  VectorType vectorType = dyn_cast<VectorType>(type);
  return vectorType && vectorType.getRank() == 1 &&
         vectorType.getNumElements() == 2 &&
         vectorType.getElementType().isF16();
}

static bool isAllowedWaveFloatElement(Type elementType, bool allowScalarF16,
                                      bool allowPackedF16) {
  if (elementType.isF32())
    return true;
  if (allowScalarF16 && elementType.isF16())
    return true;
  return allowPackedF16 && isWavePackedF16Type(elementType);
}

static const char *getWaveFloatElementError(bool allowScalarF16,
                                            bool allowPackedF16) {
  if (allowScalarF16 && allowPackedF16)
    return "SIMD element type must be f32, f16, or vector<2xf16>";
  if (allowPackedF16)
    return "SIMD element type must be f32 or vector<2xf16>";
  return "SIMD element type must be f32";
}

static LogicalResult
verifyWaveFloatSimd(Type type, bool allowScalarF16, bool allowPackedF16,
                    function_ref<InFlightDiagnostic(const Twine &)> emitError) {
  SimdType simdType = dyn_cast<SimdType>(type);
  if (!simdType)
    return emitError("operand must be !wave.simd<..., W>");
  Type elementType = simdType.getElementType();
  if (!isAllowedWaveFloatElement(elementType, allowScalarF16, allowPackedF16))
    return emitError(getWaveFloatElementError(allowScalarF16, allowPackedF16));
  return success();
}

static LogicalResult verifyWaveFloatSimdBinary(Operation *op, Type lhsTy,
                                               Type rhsTy, Type resultTy,
                                               bool allowScalarF16,
                                               bool allowPackedF16) {
  auto emit = [op](const Twine &msg) { return op->emitOpError(msg); };
  if (lhsTy != rhsTy || lhsTy != resultTy)
    return emit("operands and result must have the same SIMD type");
  return verifyWaveFloatSimd(lhsTy, allowScalarF16, allowPackedF16, emit);
}

static LogicalResult verifyWaveFloatSimdTernary(Operation *op, Type lhsTy,
                                                Type rhsTy, Type accTy,
                                                Type resultTy) {
  auto emit = [op](const Twine &msg) { return op->emitOpError(msg); };
  if (lhsTy != rhsTy || lhsTy != accTy || lhsTy != resultTy)
    return emit("operands and result must have the same SIMD type");
  return verifyWaveFloatSimd(lhsTy, /*allowScalarF16=*/true,
                             /*allowPackedF16=*/true, emit);
}

static LogicalResult verifyWaveFloatSimdUnary(Operation *op, Type sourceTy,
                                              Type resultTy) {
  auto emit = [op](const Twine &msg) { return op->emitOpError(msg); };
  if (sourceTy != resultTy)
    return emit("operand and result must have the same SIMD type");
  return verifyWaveFloatSimd(sourceTy, /*allowScalarF16=*/false,
                             /*allowPackedF16=*/false, emit);
}

LogicalResult FAddOp::verify() {
  return verifyWaveFloatSimdBinary(getOperation(), getLhs().getType(),
                                   getRhs().getType(), getResult().getType(),
                                   /*allowScalarF16=*/true,
                                   /*allowPackedF16=*/true);
}

LogicalResult FSubOp::verify() {
  return verifyWaveFloatSimdBinary(getOperation(), getLhs().getType(),
                                   getRhs().getType(), getResult().getType(),
                                   /*allowScalarF16=*/false,
                                   /*allowPackedF16=*/false);
}

LogicalResult FMulOp::verify() {
  return verifyWaveFloatSimdBinary(getOperation(), getLhs().getType(),
                                   getRhs().getType(), getResult().getType(),
                                   /*allowScalarF16=*/true,
                                   /*allowPackedF16=*/true);
}

LogicalResult FMaxOp::verify() {
  return verifyWaveFloatSimdBinary(getOperation(), getLhs().getType(),
                                   getRhs().getType(), getResult().getType(),
                                   /*allowScalarF16=*/false,
                                   /*allowPackedF16=*/true);
}

LogicalResult FmaOp::verify() {
  return verifyWaveFloatSimdTernary(getOperation(), getLhs().getType(),
                                    getRhs().getType(), getAcc().getType(),
                                    getResult().getType());
}

LogicalResult FExp2Op::verify() {
  return verifyWaveFloatSimdUnary(getOperation(), getSource().getType(),
                                  getResult().getType());
}

LogicalResult FRcpOp::verify() {
  return verifyWaveFloatSimdUnary(getOperation(), getSource().getType(),
                                  getResult().getType());
}

// Range inference forwards to upstream `mlir::intrange` helpers. The
// wrinkle is that upstream's `ConstantIntRanges::getStorageBitwidth`
// returns 0 for `!wave.simd<...>` (our SIMD type isn't a ShapedType
// in upstream's eyes), so SIMD entry-state lattices arrive at width
// 0 and would crash the helpers' APInt math. Normalize each operand
// range to the result's element bit-width before forwarding -- a
// width-0 (or otherwise-mismatched) incoming range becomes a max
// range at the correct width. SIMD chains then propagate through
// wave-arith uniformly with scalar chains.

static unsigned waveArithElementWidth(Type type) {
  if (auto simd = dyn_cast<SimdType>(type))
    type = simd.getElementType();
  return cast<IntegerType>(type).getWidth();
}

static ConstantIntRanges normalizeWaveArithRange(const ConstantIntRanges &range,
                                                 unsigned bits) {
  if (range.smin().getBitWidth() == bits)
    return range;
  return ConstantIntRanges::maxRange(bits);
}

static SmallVector<ConstantIntRanges, 2>
normalizeWaveArithRanges(ArrayRef<ConstantIntRanges> argRanges, unsigned bits) {
  SmallVector<ConstantIntRanges, 2> normalized;
  normalized.reserve(argRanges.size());
  for (const ConstantIntRanges &range : argRanges)
    normalized.push_back(normalizeWaveArithRange(range, bits));
  return normalized;
}

static bool isFullSignedRange(const ConstantIntRanges &range) {
  unsigned width = range.smin().getBitWidth();
  if (width == 0)
    return true;
  return range.smin() == APInt::getSignedMinValue(width) &&
         range.smax() == APInt::getSignedMaxValue(width);
}

static std::optional<int64_t> getSExtI64(const APInt &value) {
  if (!value.isSignedIntN(64))
    return std::nullopt;
  return value.getSExtValue();
}

static std::optional<sym::PredHandle>
buildIndexExprRangeAssumption(sym::Store &store, StringRef name,
                              const ConstantIntRanges &range) {
  if (isFullSignedRange(range))
    return std::nullopt;
  std::optional<int64_t> lo = getSExtI64(range.smin());
  std::optional<int64_t> hi = getSExtI64(range.smax());
  if (!lo || !hi)
    return std::nullopt;
  FailureOr<sym::PredHandle> assumption =
      sym::rangeAssumption(store, name, *lo, *hi);
  if (failed(assumption))
    return std::nullopt;
  return *assumption;
}

void mlir::wave::appendRangeAndAssumePredicates(
    sym::Store &store, Value binding, StringRef name,
    const ConstantIntRanges &range,
    SmallVectorImpl<sym::PredHandle> &assumptions) {
  std::optional<sym::PredHandle> assumption =
      buildIndexExprRangeAssumption(store, name, range);
  if (assumption)
    assumptions.push_back(*assumption);
  appendAssumePredicates(store, binding, name, assumptions);
}

static SmallVector<sym::PredHandle, 4> getPredicateHandles(ArrayAttr attrs) {
  SmallVector<sym::PredHandle, 4> handles;
  handles.reserve(attrs.size());
  for (Attribute attr : attrs)
    handles.push_back(cast<PredAttr>(attr).getValue());
  return handles;
}

static std::optional<int64_t> floorRational(sym::RationalEndpoint value) {
  if (value.denominator <= 0)
    return std::nullopt;
  int64_t quotient = value.numerator / value.denominator;
  int64_t remainder = value.numerator % value.denominator;
  if (remainder != 0 && value.numerator < 0)
    --quotient;
  return quotient;
}

static std::optional<int64_t> ceilRational(sym::RationalEndpoint value) {
  if (value.denominator <= 0)
    return std::nullopt;
  int64_t quotient = value.numerator / value.denominator;
  int64_t remainder = value.numerator % value.denominator;
  if (remainder != 0 && value.numerator > 0)
    ++quotient;
  return quotient;
}

static unsigned indexValueElementWidth(Type type) {
  if (auto simd = dyn_cast<SimdType>(type))
    type = simd.getElementType();
  return ConstantIntRanges::getStorageBitwidth(type);
}

static bool fitsSignedWidth(int64_t value, unsigned bits) {
  return bits >= 64 || APInt(64, value, /*isSigned=*/true).isSignedIntN(bits);
}

static std::optional<ConstantIntRanges>
buildIndexExprResultRange(sym::Store &store, sym::ExprHandle expr,
                          Type resultType,
                          ArrayRef<sym::PredHandle> assumptions) {
  std::optional<sym::InferredRange> range =
      sym::inferRange(store, expr, assumptions);
  if (!range || !range->lower || !range->upper)
    return std::nullopt;

  std::optional<int64_t> lo = floorRational(*range->lower);
  std::optional<int64_t> hi = ceilRational(*range->upper);
  if (!lo || !hi)
    return std::nullopt;
  unsigned bits = indexValueElementWidth(resultType);
  if (bits == 0 || !fitsSignedWidth(*lo, bits) || !fitsSignedWidth(*hi, bits))
    return std::nullopt;

  APInt loValue(bits, *lo, /*isSigned=*/true);
  APInt hiValue(bits, *hi, /*isSigned=*/true);
  return ConstantIntRanges::fromSigned(loValue, hiValue);
}

static std::optional<ConstantIntRanges>
buildAssumePredicateRange(sym::Store &store, StringRef name, Type resultType,
                          ArrayAttr attrs) {
  FailureOr<sym::ExprHandle> expr = sym::composeExprSym(store, name);
  if (failed(expr))
    return std::nullopt;
  SmallVector<sym::PredHandle, 4> assumptions = getPredicateHandles(attrs);
  return buildIndexExprResultRange(store, *expr, resultType, assumptions);
}

void mlir::wave::appendAssumePredicates(
    sym::Store &store, Value binding, StringRef name,
    SmallVectorImpl<sym::PredHandle> &assumptions) {
  FailureOr<sym::ExprHandle> replacement = sym::composeExprSym(store, name);
  if (failed(replacement))
    return;

  while (auto assume = binding.getDefiningOp<AssumeOp>()) {
    FailureOr<sym::ExprHandle> target =
        sym::composeExprSym(store, assume.getName());
    if (failed(target))
      return;
    std::array<sym::ExprSubstitution, 1> substitutions{
        sym::ExprSubstitution{*target, *replacement}};
    for (Attribute attr : assume.getAssumptions()) {
      FailureOr<sym::PredHandle> pred = sym::substitutePred(
          store, cast<PredAttr>(attr).getValue(), substitutions);
      if (succeeded(pred))
        assumptions.push_back(*pred);
    }
    binding = assume.getValue();
  }
}

void SplatOp::inferResultRanges(ArrayRef<ConstantIntRanges> argRanges,
                                SetIntRangeFn setResultRange) {
  SimdType simd = cast<SimdType>(getResult().getType());
  if (!isa<IntegerType>(simd.getElementType()))
    return;
  unsigned bits = cast<IntegerType>(simd.getElementType()).getWidth();
  setResultRange(getResult(), normalizeWaveArithRange(argRanges[0], bits));
}

void BinaryOp::inferResultRanges(ArrayRef<ConstantIntRanges> argRanges,
                                 SetIntRangeFn setResultRange) {
  SimdType simd = cast<SimdType>(getResult().getType());
  if (!isa<IntegerType>(simd.getElementType()))
    return;
  unsigned bits = cast<IntegerType>(simd.getElementType()).getWidth();
  SmallVector<ConstantIntRanges, 2> ranges =
      normalizeWaveArithRanges(argRanges, bits);

  StringRef kind = getKind();
  if (kind == "andi") {
    setResultRange(getResult(), mlir::intrange::inferAnd(ranges));
    return;
  }
  if (kind == "ori") {
    setResultRange(getResult(), mlir::intrange::inferOr(ranges));
    return;
  }
  if (kind == "xori") {
    setResultRange(getResult(), mlir::intrange::inferXor(ranges));
    return;
  }
  if (kind == "shri") {
    setResultRange(getResult(), mlir::intrange::inferShrU(ranges));
    return;
  }
  setResultRange(getResult(), ConstantIntRanges::maxRange(bits));
}

void AddiOp::inferResultRanges(ArrayRef<ConstantIntRanges> argRanges,
                               SetIntRangeFn setResultRange) {
  unsigned bits = waveArithElementWidth(getResult().getType());
  setResultRange(getResult(), mlir::intrange::inferAdd(
                                  normalizeWaveArithRanges(argRanges, bits)));
}

void MuliOp::inferResultRanges(ArrayRef<ConstantIntRanges> argRanges,
                               SetIntRangeFn setResultRange) {
  unsigned bits = waveArithElementWidth(getResult().getType());
  setResultRange(getResult(), mlir::intrange::inferMul(
                                  normalizeWaveArithRanges(argRanges, bits)));
}

void ShliOp::inferResultRanges(ArrayRef<ConstantIntRanges> argRanges,
                               SetIntRangeFn setResultRange) {
  unsigned bits = waveArithElementWidth(getResult().getType());
  setResultRange(getResult(), mlir::intrange::inferShl(
                                  normalizeWaveArithRanges(argRanges, bits)));
}

void AssumeOp::inferResultRangesFromOptional(
    ArrayRef<IntegerValueRange> argRanges, SetIntLatticeFn setResultRange) {
  WaveDialect *dialect = getContext()->getLoadedDialect<WaveDialect>();
  if (!dialect)
    return;

  IntegerValueRange incoming = argRanges[0];
  std::optional<ConstantIntRanges> asserted =
      buildAssumePredicateRange(dialect->getSymbolStore(), getName(),
                                getResult().getType(), getAssumptions());
  if (!asserted) {
    if (incoming.isUninitialized())
      return;
    setResultRange(getResult(), incoming);
    return;
  }

  IntegerValueRange out =
      incoming.isUninitialized()
          ? IntegerValueRange{*asserted}
          : IntegerValueRange{asserted->intersection(incoming.getValue())};
  setResultRange(getResult(), out);
}

void IndexExprOp::inferResultRanges(ArrayRef<ConstantIntRanges> argRanges,
                                    SetIntRangeFn setResultRange) {
  WaveDialect *dialect = getContext()->getLoadedDialect<WaveDialect>();
  if (!dialect)
    return;
  sym::Store &store = dialect->getSymbolStore();

  SmallVector<sym::PredHandle, 4> assumptions;
  for (auto [nameAttr, binding, range] :
       llvm::zip(getNames(), getBindings(), argRanges)) {
    StringRef name = cast<StringAttr>(nameAttr).getValue();
    appendRangeAndAssumePredicates(store, binding, name, range, assumptions);
  }
  std::optional<ConstantIntRanges> range = buildIndexExprResultRange(
      store, getExpr().getValue(), getResult().getType(), assumptions);
  if (!range)
    return;
  setResultRange(getResult(), *range);
}

static bool isCmpAndTree(sym::PredHandle pred) {
  sym::PredView view(pred);
  if (!view.isValid())
    return false;
  if (view.getKind() == sym::PredKind::Cmp)
    return true;
  if (view.getKind() != sym::PredKind::And)
    return false;
  for (uint32_t i : llvm::seq<uint32_t>(0, view.getLogicArgCount()))
    if (!isCmpAndTree(view.getLogicArg(i)))
      return false;
  return true;
}

LogicalResult AssumeOp::verify() {
  if (getName().empty())
    return emitOpError("symbol name must be non-empty");
  if (getAssumptions().empty())
    return emitOpError("requires at least one predicate");

  for (auto [index, attr] : llvm::enumerate(getAssumptions())) {
    sym::PredHandle pred = cast<PredAttr>(attr).getValue();
    if (!isCmpAndTree(pred))
      return emitOpError("predicate #")
             << index << " must be a comparison or AND of comparisons";

    std::optional<StringRef> badName;
    sym::walkSymbolNames(pred, [&](StringRef name) {
      if (name != getName() && !badName)
        badName = name;
    });
    if (badName)
      return emitOpError("predicate #")
             << index << " references undeclared symbol `" << *badName << "`";
  }
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
  return success();
}

// Seed `IntRangeAnalysis` from the wave-axis id ops. We don't know
// grid / block dims at this layer, so all upper bounds default to
// INT32_MAX; the producer wraps with `wave.assume` when a tighter
// bound is needed. lane_id is the exception -- the SIMD wave
// width gives us a tight `[0, W-1]` per lane.

void LaneIdOp::inferResultRanges(ArrayRef<ConstantIntRanges>,
                                 SetIntRangeFn setRange) {
  auto simdTy = cast<SimdType>(getResult().getType());
  unsigned bits = simdTy.getElementType().getIntOrFloatBitWidth();
  APInt lo(bits, 0, /*isSigned=*/false);
  APInt hi(bits, simdTy.getWidth() - 1, /*isSigned=*/false);
  setRange(getResult(), ConstantIntRanges::fromSigned(lo, hi));
}

void WorkgroupIdOp::inferResultRanges(ArrayRef<ConstantIntRanges>,
                                      SetIntRangeFn setRange) {
  APInt lo(32, 0, /*isSigned=*/true);
  APInt hi = APInt::getSignedMaxValue(32);
  setRange(getResult(), ConstantIntRanges::fromSigned(lo, hi));
}

void WorkitemIdOp::inferResultRanges(ArrayRef<ConstantIntRanges>,
                                     SetIntRangeFn setRange) {
  auto simdTy = cast<SimdType>(getResult().getType());
  unsigned bits = simdTy.getElementType().getIntOrFloatBitWidth();
  APInt lo(bits, 0, /*isSigned=*/true);
  APInt hi = APInt::getSignedMaxValue(bits);
  setRange(getResult(), ConstantIntRanges::fromSigned(lo, hi));
}

static MemoryPayloadShape getMemoryPayloadShape(unsigned elementBits,
                                                unsigned payloadBits) {
  return MemoryPayloadShape{elementBits, payloadBits,
                            payloadBits <= 32 ? 1 : payloadBits / 32,
                            payloadBits == 8, payloadBits == 16};
}

static FailureOr<MemoryPayloadShape> getScalarMemoryPayloadShape(
    Type elementType,
    function_ref<InFlightDiagnostic(const Twine &)> emitError) {
  if (!elementType.isIntOrFloat())
    return emitError("payload element type must be integer or float");
  unsigned bits = elementType.getIntOrFloatBitWidth();
  if (bits != 8 && bits != 16 && bits != 32)
    return emitError(
        "scalar payload element type must be 8, 16, or 32 bits wide");
  return getMemoryPayloadShape(bits, bits);
}

static FailureOr<MemoryPayloadShape> getVectorMemoryPayloadShape(
    VectorType vecTy,
    function_ref<InFlightDiagnostic(const Twine &)> emitError) {
  if (vecTy.getRank() != 1)
    return emitError("vector payload must be 1-D");
  Type scalarType = vecTy.getElementType();
  if (!scalarType.isIntOrFloat())
    return emitError("vector element type must be integer or float");
  unsigned scalarBits = scalarType.getIntOrFloatBitWidth();
  if (scalarBits != 4 && scalarBits != 8 && scalarBits != 16 &&
      scalarBits != 32)
    return emitError("vector element type must be 4, 8, 16, or 32 bits wide");
  uint64_t payloadBits = vecTy.getNumElements() * scalarBits;
  if (payloadBits != 16 && payloadBits % 32 != 0)
    return emitError("vector payload must be 16 bits or a multiple of 32 bits");
  return getMemoryPayloadShape(scalarBits, static_cast<unsigned>(payloadBits));
}

FailureOr<MemoryPayloadShape> mlir::wave::getMemoryPayloadShape(
    Type elementType,
    function_ref<InFlightDiagnostic(const Twine &)> emitError) {
  if (auto vecTy = dyn_cast<VectorType>(elementType))
    return getVectorMemoryPayloadShape(vecTy, emitError);
  return getScalarMemoryPayloadShape(elementType, emitError);
}

static FailureOr<std::optional<Type>> getMemoryPointerElementType(
    Type ptrType, int64_t simdWidth, StringRef widthError,
    function_ref<InFlightDiagnostic(const Twine &)> emitError) {
  if (auto wavePtr = dyn_cast<PtrType>(ptrType))
    return wavePtr.getElementType()
               ? std::optional<Type>(wavePtr.getElementType())
               : std::nullopt;
  auto ptrSimdType = dyn_cast<SimdType>(ptrType);
  if (!ptrSimdType)
    return emitError("expected wave pointer operand");
  auto wavePtr = dyn_cast<PtrType>(ptrSimdType.getElementType());
  if (!wavePtr)
    return emitError("pointer SIMD element type must be a wave pointer");
  if (ptrSimdType.getWidth() != simdWidth)
    return emitError(widthError);
  return wavePtr.getElementType()
             ? std::optional<Type>(wavePtr.getElementType())
             : std::nullopt;
}

static FailureOr<unsigned> getMemoryPointerElementBits(
    Type ptrElementType,
    function_ref<InFlightDiagnostic(const Twine &)> emitError) {
  FailureOr<MemoryPayloadShape> shape =
      getMemoryPayloadShape(ptrElementType, emitError);
  if (failed(shape))
    return failure();
  return shape->payloadBits;
}

static LogicalResult verifyMemoryPayloadFitsPointer(
    Type payloadElementType, std::optional<Type> ptrElementType,
    function_ref<InFlightDiagnostic(const Twine &)> emitError) {
  FailureOr<MemoryPayloadShape> shape =
      getMemoryPayloadShape(payloadElementType, emitError);
  if (failed(shape))
    return failure();
  if (!ptrElementType)
    return success();
  FailureOr<unsigned> ptrBits =
      getMemoryPointerElementBits(*ptrElementType, emitError);
  if (failed(ptrBits))
    return failure();
  if (shape->payloadBits % *ptrBits != 0)
    return emitError("per-lane payload must be a multiple of the pointer "
                     "element bit width");
  return success();
}

LogicalResult StoreOp::verify() {
  auto emit = [this](const Twine &msg) { return emitOpError(msg); };
  auto simdType = cast<SimdType>(getValue().getType());
  FailureOr<std::optional<Type>> ptrElementType = getMemoryPointerElementType(
      getPtr().getType(), simdType.getWidth(),
      "pointer SIMD width must match value SIMD width", emit);
  if (failed(ptrElementType))
    return failure();
  return verifyMemoryPayloadFitsPointer(simdType.getElementType(),
                                        *ptrElementType, emit);
}

LogicalResult LoadOp::verify() {
  auto emit = [this](const Twine &msg) { return emitOpError(msg); };
  auto resultSimd = cast<SimdType>(getValue().getType());
  FailureOr<std::optional<Type>> ptrElementType = getMemoryPointerElementType(
      getPtr().getType(), resultSimd.getWidth(),
      "pointer SIMD width must match result SIMD width", emit);
  if (failed(ptrElementType))
    return failure();
  return verifyMemoryPayloadFitsPointer(resultSimd.getElementType(),
                                        *ptrElementType, emit);
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
    Type elementType = offsetSimd.getElementType();
    if (!elementType.isIndex() && !elementType.isInteger(32))
      return emitError("SIMD offset element type must be index or i32");
    return offsetSimd.getWidth();
  }
  return emitError("offset must be index, integer, or index/i32 SIMD");
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
  // ODS pins the result to `Wave_Ptr`; only the address space needs a
  // runtime check.
  auto ptrType = cast<PtrType>(getResult().getType());
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

FailureOr<SymbolicOffsetBindingKind> mlir::wave::classifySymbolicOffsetBinding(
    Type type, function_ref<InFlightDiagnostic(const Twine &)> emitError) {
  if (type.isIndex())
    return SymbolicOffsetBindingKind::Uniform;
  if (auto intType = dyn_cast<IntegerType>(type)) {
    if (!intType.isSignless())
      return emitError("integer binding must be signless");
    return SymbolicOffsetBindingKind::Uniform;
  }
  if (auto simdType = dyn_cast<SimdType>(type)) {
    Type elementType = simdType.getElementType();
    if (!elementType.isIndex() && !elementType.isInteger(32))
      return emitError("SIMD binding element type must be index or i32");
    return SymbolicOffsetBindingKind::Lane;
  }
  return emitError("binding must be index, signless integer, or "
                   "!wave.simd<index/i32, W>");
}

unsigned mlir::wave::getSymbolicOffsetLaneWidth(ValueRange bindings) {
  unsigned width = 0;
  for (Value binding : bindings)
    if (auto simdType = dyn_cast<SimdType>(binding.getType()))
      width = std::max(width, static_cast<unsigned>(simdType.getWidth()));
  return width;
}

Type mlir::wave::getSymbolicOffsetResultType(MLIRContext *ctx,
                                             unsigned laneWidth) {
  return laneWidth == 0
             ? IndexType::get(ctx)
             : Type(SimdType::get(ctx, IndexType::get(ctx), laneWidth));
}

// Uniform scalars have width 0; lane bindings return SIMD width.
static FailureOr<int64_t> classifyIndexBinding(
    Type type, function_ref<InFlightDiagnostic(const Twine &)> emitError) {
  FailureOr<SymbolicOffsetBindingKind> kind =
      classifySymbolicOffsetBinding(type, emitError);
  if (failed(kind))
    return failure();
  if (*kind == SymbolicOffsetBindingKind::Uniform)
    return int64_t{0};
  return cast<SimdType>(type).getWidth();
}

// Bijection check: every entry in `names` is a non-empty unique string
// that names a free symbol of `freeSymbols`, and every member of
// `freeSymbols` is covered. Successful return populates `bindingNames`.
static LogicalResult verifyIndexExprNames(
    ArrayAttr names, const llvm::DenseSet<StringRef> &freeSymbols,
    llvm::DenseSet<StringRef> &bindingNames,
    function_ref<InFlightDiagnostic(const Twine &)> emitError) {
  for (Attribute attr : names) {
    // ODS declares `$names` as `StrArrayAttr`, so non-string entries
    // are rejected by the attribute parser before this runs.
    StringRef name = cast<StringAttr>(attr).getValue();
    if (name.empty())
      return emitError("binding name must be non-empty");
    if (!bindingNames.insert(name).second)
      return emitError("duplicate binding name '" + name + "'");
    if (!freeSymbols.count(name))
      return emitError("binding name '" + name +
                       "' is not a free symbol of the expression");
  }
  for (StringRef name : freeSymbols)
    if (!bindingNames.count(name))
      return emitError("free symbol '" + name + "' has no binding");
  return success();
}

// Reduce binding types to the unique lane width (0 if all uniform).
// Reports per-binding-type errors and lane-width conflicts.
static FailureOr<int64_t> reduceIndexBindingWidth(
    OperandRange bindings,
    function_ref<InFlightDiagnostic(const Twine &)> emitError) {
  int64_t laneWidth = 0;
  for (Value binding : bindings) {
    auto width = classifyIndexBinding(binding.getType(), emitError);
    if (failed(width))
      return failure();
    if (*width == 0)
      continue;
    if (laneWidth != 0 && laneWidth != *width)
      return emitError("conflicting lane-varying binding widths (" +
                       Twine(laneWidth) + " vs " + Twine(*width) + ")");
    laneWidth = *width;
  }
  return laneWidth;
}

Type mlir::wave::getIndexExprResultType(MLIRContext *ctx, ValueRange bindings) {
  return getSymbolicOffsetResultType(ctx, getSymbolicOffsetLaneWidth(bindings));
}

FailureOr<SymbolicOffset>
mlir::wave::getIndexExprSymbolicOffset(IndexExprOp op) {
  WaveDialect *dialect = op->getContext()->getLoadedDialect<WaveDialect>();
  if (!dialect)
    return op.emitError("Wave dialect is not loaded");

  sym::Store &store = dialect->getSymbolStore();
  SymbolicOffset offset;
  offset.expr = op.getExpr().getValue();
  offset.laneWidth = getSymbolicOffsetLaneWidth(op.getBindings());
  for (auto [nameAttr, binding] : llvm::zip(op.getNames(), op.getBindings())) {
    StringRef name = cast<StringAttr>(nameAttr).getValue();
    FailureOr<sym::ExprHandle> sym = sym::composeExprSym(store, name);
    if (failed(sym))
      return op.emitError("failed to compose binding symbol '") << name << "'";
    FailureOr<SymbolicOffsetBindingKind> kind =
        classifySymbolicOffsetBinding(binding.getType(), [&](const Twine &msg) {
          return op.emitOpError(msg);
        });
    if (failed(kind))
      return failure();
    offset.bindings.push_back({*sym, binding, *kind});
  }
  return offset;
}

static LogicalResult verifyIndexExprResultType(
    Type resultType, int64_t laneWidth,
    function_ref<InFlightDiagnostic(const Twine &)> emitError) {
  if (laneWidth == 0) {
    if (!resultType.isIndex())
      return emitError("uniform result must be index");
    return success();
  }
  auto simdType = dyn_cast<SimdType>(resultType);
  if (!simdType || !simdType.getElementType().isIndex())
    return emitError("lane-varying result must be !wave.simd<index, W>");
  if (simdType.getWidth() != laneWidth)
    return emitError("result width ")
           << simdType.getWidth() << " disagrees with binding lane width "
           << laneWidth;
  return success();
}

static LogicalResult collectConstantIndexExprSubstitutions(
    IndexExprOp op, sym::Store &store,
    SmallVectorImpl<sym::ExprSubstitution> &substitutions) {
  for (auto [nameAttr, binding] : llvm::zip(op.getNames(), op.getBindings())) {
    std::optional<int64_t> constant = getConstantIntValue(binding);
    if (!constant)
      continue;
    StringRef name = cast<StringAttr>(nameAttr).getValue();
    FailureOr<sym::ExprHandle> target = sym::composeExprSym(store, name);
    FailureOr<sym::ExprHandle> value = sym::composeExprInt(store, *constant);
    if (failed(target) || failed(value))
      return failure();
    substitutions.push_back({*target, *value});
  }
  return success();
}

static void collectIndexExprFreeSymbols(sym::ExprHandle expr,
                                        llvm::DenseSet<StringRef> &symbols) {
  sym::walkSymbolNames(expr, [&](StringRef name) { symbols.insert(name); });
}

static void collectLiveIndexExprBindings(
    IndexExprOp op, const llvm::DenseSet<StringRef> &freeSymbols,
    SmallVectorImpl<StringRef> &names, SmallVectorImpl<Value> &bindings) {
  for (auto [nameAttr, binding] : llvm::zip(op.getNames(), op.getBindings())) {
    StringRef name = cast<StringAttr>(nameAttr).getValue();
    if (!freeSymbols.count(name))
      continue;
    names.push_back(name);
    bindings.push_back(binding);
  }
}

namespace {
struct CanonicalizeIndexExprOp : OpRewritePattern<IndexExprOp> {
  using OpRewritePattern::OpRewritePattern;

  LogicalResult matchAndRewrite(IndexExprOp op,
                                PatternRewriter &rewriter) const override {
    if (op.getBindings().empty() && op.getResult().getType().isIndex()) {
      std::optional<int64_t> value =
          sym::getIntegerLiteralValue(op.getExpr().getValue());
      if (value) {
        Value constant =
            arith::ConstantIndexOp::create(rewriter, op.getLoc(), *value);
        rewriter.replaceOp(op, constant);
        return success();
      }
    }

    auto *dialect = op->getContext()->getLoadedDialect<WaveDialect>();
    if (!dialect)
      return failure();
    sym::Store &store = dialect->getSymbolStore();

    SmallVector<sym::ExprSubstitution, 4> substitutions;
    if (failed(collectConstantIndexExprSubstitutions(op, store, substitutions)))
      return failure();

    FailureOr<sym::ExprHandle> substituted =
        sym::substituteExpr(store, op.getExpr().getValue(), substitutions);
    if (failed(substituted))
      return failure();
    FailureOr<sym::ExprHandle> simplified =
        sym::simplifyExpr(store, *substituted);
    if (failed(simplified))
      return failure();

    llvm::DenseSet<StringRef> freeSymbols;
    collectIndexExprFreeSymbols(*simplified, freeSymbols);

    SmallVector<StringRef> names;
    SmallVector<Value> bindings;
    collectLiveIndexExprBindings(op, freeSymbols, names, bindings);

    bool exprChanged = !(*simplified == op.getExpr().getValue());
    bool bindingsChanged = bindings.size() != op.getBindings().size();
    if (!exprChanged && !bindingsChanged)
      return failure();

    Type resultType = getIndexExprResultType(op.getContext(), bindings);

    auto replacement =
        IndexExprOp::create(rewriter, op.getLoc(), resultType,
                            ExprAttr::get(op.getContext(), *simplified),
                            rewriter.getStrArrayAttr(names), bindings);
    rewriter.replaceOp(op, replacement.getResult());
    return success();
  }
};
} // namespace

LogicalResult IndexExprOp::verify() {
  auto emit = [this](const Twine &msg) { return emitOpError(msg); };

  ArrayAttr names = getNames();
  OperandRange bindings = getBindings();
  if (names.size() != bindings.size())
    return emit("expected one name per binding (got ")
           << names.size() << " names and " << bindings.size() << " bindings)";

  // Hash-consed leaves may appear multiple times in the AST: dedupe.
  llvm::DenseSet<StringRef> freeSymbols;
  sym::walkSymbolNames(getExpr().getValue(),
                       [&](StringRef name) { freeSymbols.insert(name); });

  llvm::DenseSet<StringRef> bindingNames;
  if (failed(verifyIndexExprNames(names, freeSymbols, bindingNames, emit)))
    return failure();

  auto laneWidth = reduceIndexBindingWidth(bindings, emit);
  if (failed(laneWidth))
    return failure();

  return verifyIndexExprResultType(getResult().getType(), *laneWidth, emit);
}

void IndexExprOp::getCanonicalizationPatterns(RewritePatternSet &patterns,
                                              MLIRContext *context) {
  patterns.add<CanonicalizeIndexExprOp>(context);
}

#define GET_OP_CLASSES
#include "mlir/Dialect/Wave/IR/WaveOps.cpp.inc"

#define GET_TYPEDEF_CLASSES
#include "mlir/Dialect/Wave/IR/WaveOpsTypes.cpp.inc"

#define GET_ATTRDEF_CLASSES
#include "mlir/Dialect/Wave/IR/WaveOpsAttributes.cpp.inc"

PtrType PtrType::get(MLIRContext *context, Type elementType,
                     Attribute addressSpace) {
  return PtrType::get(context, addressSpace, elementType);
}

PtrType PtrType::get(MLIRContext *context, Attribute addressSpace) {
  return PtrType::get(context, addressSpace, Type());
}
