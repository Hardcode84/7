//===- WaveAMD.cpp - WaveAMD dialect ----------------------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/Wave/IR/WaveAMD.h"

#include "mlir/Dialect/Wave/IR/Wave.h"
#include "mlir/IR/Builders.h"
#include "mlir/IR/DialectImplementation.h"
#include "mlir/IR/PatternMatch.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/ADT/TypeSwitch.h"

using namespace mlir;
using namespace mlir::waveamd;

#include "mlir/Dialect/Wave/IR/WaveAMDOpsDialect.cpp.inc"
#include "mlir/Dialect/Wave/IR/WaveAMDOpsEnums.cpp.inc"

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
  if (!getRange().getType().isInteger(32) &&
      !getRange().getType().isInteger(64))
    return emitOpError("range must be i32 or i64 bytes");
  return success();
}

namespace {
// Layout constraints for an A or B operand fragment.
static bool isValidABFragment(FragmentType type) {
  bool isIU8 = type.getElementType().isInteger(8) && type.getRegisters() == 4;
  bool isFloat16 =
      (type.getElementType().isF16() || type.getElementType().isBF16()) &&
      (type.getRegisters() == 2 || type.getRegisters() == 4 ||
       type.getRegisters() == 8);
  return isIU8 || isFloat16;
}
// Layout constraints for an accumulator fragment.
static bool isValidAccFragment(FragmentType type) {
  Type elt = type.getElementType();
  return elt.isIntOrFloat() && elt.getIntOrFloatBitWidth() == 32 &&
         (type.getRegisters() == 4 || type.getRegisters() == 8 ||
          type.getRegisters() == 16);
}
static bool isValidFragmentRole(int64_t role) {
  return role == 0 || role == 1 || role == 2;
}
static bool is16x16Fragment(FragmentType type) {
  return type.getRows() == 16 && type.getColumns() == 16;
}
static bool isSupportedFragmentFillShape(FragmentType type) {
  return is16x16Fragment(type) ||
         (type.getRows() == 32 && type.getColumns() == 32 &&
          type.getWaveSize() == 64);
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
  if (!vectorElement.isIntOrFloat())
    return emitOpError("operand vector element type must be int or float");
  unsigned elementBits = vectorElement.getIntOrFloatBitWidth();
  if (elementBits < 4 || elementBits > 32 || 32 % elementBits != 0)
    return emitOpError(
        "operand vector element bit width must be 4, 8, 16, or 32");
  int64_t payloadBits = vectorType.getNumElements() * elementBits;
  int64_t expectedBits = fragmentType.getRegisters() * 32;
  if (payloadBits != expectedBits)
    return emitOpError("operand vector payload bit width (")
           << payloadBits << ") must match fragment register payload bit width "
           << "(" << expectedBits << ")";
  return success();
}

LogicalResult FragmentFillOp::verify() {
  auto fragmentType = cast<FragmentType>(getResult().getType());
  if (!getSource().getType().isInteger(32))
    return emitOpError("source must be an i32 bit pattern");
  int64_t role = fragmentType.getRole();
  if (!isSupportedFragmentFillShape(fragmentType))
    return emitOpError("only 16x16 and wave64 32x32 fragments are supported");
  if (role != 2 && !isValidABFragment(fragmentType))
    return emitOpError("A/B fragments must be i8 fragments with 4 registers "
                       "or f16/bf16 fragments with 2, 4, or 8 registers");
  if (role == 2 && !isValidAccFragment(fragmentType))
    return emitOpError(
        "accumulator fragments must be 32-bit fragments with 4, 8, or 16 "
        "registers");
  return success();
}

namespace {
struct MmaShape {
  MmaKind kind;
  bool (*matchAB)(FragmentType, int64_t role);
  bool (*matchAcc)(FragmentType);
  StringRef abError;
  StringRef accError;
};

static bool isWmma16x16x16(FragmentType type) {
  return type.getRows() == 16 && type.getColumns() == 16 &&
         type.getWaveSize() == 32;
}
static bool isMfma16x16x16(FragmentType type) {
  return type.getRows() == 16 && type.getColumns() == 16 &&
         (type.getWaveSize() == 32 || type.getWaveSize() == 64);
}
static bool isMfmaGfx95016x16x32(FragmentType type) {
  return type.getRows() == 16 && type.getColumns() == 16 &&
         type.getWaveSize() == 64;
}
static bool isMfmaGfx95032x32x16(FragmentType type) {
  return type.getRows() == 32 && type.getColumns() == 32 &&
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
static bool matchBF16AB(FragmentType type, int64_t role) {
  return type.getRole() == role && type.getElementType().isBF16() &&
         type.getRegisters() == 8 && isWmma16x16x16(type);
}
static bool matchF32Acc(FragmentType type) {
  return type.getRole() == 2 && type.getElementType().isF32() &&
         type.getRegisters() == 8 && isWmma16x16x16(type);
}
static bool isGfx1250Wmma16x16x32(FragmentType type) {
  return type.getRows() == 16 && type.getColumns() == 16 &&
         type.getWaveSize() == 32;
}
static bool hasDwordPayload(FragmentType type, int64_t elements) {
  Type elementType = type.getElementType();
  if (!elementType.isIntOrFloat())
    return false;
  return type.getRegisters() * 32 ==
         elements * elementType.getIntOrFloatBitWidth();
}
static bool matchGfx1250F16AB(FragmentType type, int64_t role) {
  return type.getRole() == role && type.getElementType().isF16() &&
         hasDwordPayload(type, 16) && isGfx1250Wmma16x16x32(type);
}
static bool matchGfx1250BF16AB(FragmentType type, int64_t role) {
  return type.getRole() == role && type.getElementType().isBF16() &&
         hasDwordPayload(type, 16) && isGfx1250Wmma16x16x32(type);
}
static bool matchGfx1250F32Acc(FragmentType type) {
  return type.getRole() == 2 && type.getElementType().isF32() &&
         hasDwordPayload(type, 8) && isGfx1250Wmma16x16x32(type);
}
static bool matchMfmaF16AB(FragmentType type, int64_t role) {
  return type.getRole() == role && type.getElementType().isF16() &&
         type.getRegisters() == 2 && isMfma16x16x16(type);
}
static bool matchMfmaBF16AB(FragmentType type, int64_t role) {
  return type.getRole() == role && type.getElementType().isBF16() &&
         type.getRegisters() == 2 && isMfma16x16x16(type);
}
static bool matchMfmaF32Acc(FragmentType type) {
  return type.getRole() == 2 && type.getElementType().isF32() &&
         type.getRegisters() == 4 && isMfma16x16x16(type);
}
static bool matchMfmaGfx950F16AB(FragmentType type, int64_t role) {
  return type.getRole() == role && type.getElementType().isF16() &&
         type.getRegisters() == 4 && isMfmaGfx95016x16x32(type);
}
static bool matchMfmaGfx950BF16AB(FragmentType type, int64_t role) {
  return type.getRole() == role && type.getElementType().isBF16() &&
         type.getRegisters() == 4 && isMfmaGfx95016x16x32(type);
}
static bool matchMfmaGfx950F4AB(FragmentType type, int64_t role) {
  return type.getRole() == role && type.getElementType().isInteger(8) &&
         type.getRegisters() == 4 && isMfmaGfx95016x16x32(type);
}
static bool matchMfmaGfx950F32Acc(FragmentType type) {
  return type.getRole() == 2 && type.getElementType().isF32() &&
         type.getRegisters() == 4 && isMfmaGfx95016x16x32(type);
}
static bool matchMfmaGfx95032x32F16AB(FragmentType type, int64_t role) {
  return type.getRole() == role && type.getElementType().isF16() &&
         type.getRegisters() == 4 && isMfmaGfx95032x32x16(type);
}
static bool matchMfmaGfx95032x32BF16AB(FragmentType type, int64_t role) {
  return type.getRole() == role && type.getElementType().isBF16() &&
         type.getRegisters() == 4 && isMfmaGfx95032x32x16(type);
}
static bool matchMfmaGfx95032x32F32Acc(FragmentType type) {
  return type.getRole() == 2 && type.getElementType().isF32() &&
         type.getRegisters() == 16 && isMfmaGfx95032x32x16(type);
}
static bool isScaleI32Wave64(Type type) {
  wave::SimdType simd = dyn_cast<wave::SimdType>(type);
  return simd && simd.getWidth() == 64 && simd.getElementType().isInteger(32);
}
static std::optional<int64_t> getI8ScaleVectorLength(Type type) {
  wave::SimdType simd = dyn_cast<wave::SimdType>(type);
  if (!simd || simd.getWidth() != 64)
    return std::nullopt;
  VectorType vecType = dyn_cast<VectorType>(simd.getElementType());
  if (!vecType || vecType.getRank() != 1 || vecType.isScalable() ||
      !vecType.getElementType().isInteger(8))
    return std::nullopt;
  return vecType.getNumElements();
}
static bool isScaleI8VectorWave64(Type type, int64_t elements) {
  return getI8ScaleVectorLength(type) == elements;
}
static bool isMmaScaleType(Type type) {
  return isScaleI32Wave64(type) || isScaleI8VectorWave64(type, 4) ||
         isScaleI8VectorWave64(type, 8);
}

static constexpr MmaShape kMmaShapes[] = {
    {MmaKind::WmmaI32_16x16x16_IU8, matchIU8AB, matchI32Acc,
     "must be a 16x16 i8 wave32 fragment with 4 registers",
     "accumulator must be a 16x16 i32 wave32 fragment with 8 registers"},
    {MmaKind::WmmaF32_16x16x16_F16, matchF16AB, matchF32Acc,
     "must be a 16x16 f16 wave32 fragment with 8 registers",
     "accumulator must be a 16x16 f32 wave32 fragment with 8 registers"},
    {MmaKind::WmmaF32_16x16x16_BF16, matchBF16AB, matchF32Acc,
     "must be a 16x16 bf16 wave32 fragment with 8 registers",
     "accumulator must be a 16x16 f32 wave32 fragment with 8 registers"},
    {MmaKind::WmmaF32_16x16x32_F16, matchGfx1250F16AB, matchGfx1250F32Acc,
     "must be a 16x16 wave32 fragment carrying 16 f16 elements",
     "accumulator must be a 16x16 wave32 fragment carrying 8 f32 elements"},
    {MmaKind::WmmaF32_16x16x32_BF16, matchGfx1250BF16AB, matchGfx1250F32Acc,
     "must be a 16x16 wave32 fragment carrying 16 bf16 elements",
     "accumulator must be a 16x16 wave32 fragment carrying 8 f32 elements"},
    {MmaKind::MfmaF32_16x16x16_F16, matchMfmaF16AB, matchMfmaF32Acc,
     "must be a 16x16 f16 wave32/wave64 fragment with 2 registers",
     "accumulator must be a 16x16 f32 wave32/wave64 fragment with 4 registers"},
    {MmaKind::MfmaF32_16x16x16_BF16, matchMfmaBF16AB, matchMfmaF32Acc,
     "must be a 16x16 bf16 wave32/wave64 fragment with 2 registers",
     "accumulator must be a 16x16 f32 wave32/wave64 fragment with 4 registers"},
    {MmaKind::MfmaF32_16x16x32_F16, matchMfmaGfx950F16AB, matchMfmaGfx950F32Acc,
     "must be a 16x16 f16 wave64 fragment with 4 registers",
     "accumulator must be a 16x16 f32 wave64 fragment with 4 registers"},
    {MmaKind::MfmaF32_16x16x32_BF16, matchMfmaGfx950BF16AB,
     matchMfmaGfx950F32Acc,
     "must be a 16x16 bf16 wave64 fragment with 4 registers",
     "accumulator must be a 16x16 f32 wave64 fragment with 4 registers"},
    {MmaKind::MfmaF32_32x32x16_F16, matchMfmaGfx95032x32F16AB,
     matchMfmaGfx95032x32F32Acc,
     "must be a 32x32 f16 wave64 fragment with 4 registers",
     "accumulator must be a 32x32 f32 wave64 fragment with 16 registers"},
    {MmaKind::MfmaF32_32x32x16_BF16, matchMfmaGfx95032x32BF16AB,
     matchMfmaGfx95032x32F32Acc,
     "must be a 32x32 bf16 wave64 fragment with 4 registers",
     "accumulator must be a 32x32 f32 wave64 fragment with 16 registers"},
};

static bool haveSameWaveSize(FragmentType aType, FragmentType bType,
                             FragmentType accType, FragmentType resultType) {
  int64_t waveSize = aType.getWaveSize();
  return bType.getWaveSize() == waveSize && accType.getWaveSize() == waveSize &&
         resultType.getWaveSize() == waveSize;
}
} // namespace

LogicalResult MmaOp::verify() {
  std::optional<MmaKind> kind = symbolizeMmaKind(getKind());
  if (!kind)
    return emitOpError("unsupported matrix operation kind");
  const MmaShape *shape = nullptr;
  for (const MmaShape &candidate : kMmaShapes)
    if (candidate.kind == *kind) {
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
  if (!haveSameWaveSize(aType, bType, accType, resultType))
    return emitOpError("operand/result fragment wave sizes must match");
  if (resultType != accType)
    return emitOpError("result type must match accumulator type");
  return success();
}

static LogicalResult verifyMmaScaleAttrs(MmaScaleOp op) {
  if (symbolizeMmaKind(op.getKind()) != MmaKind::MfmaScaleF32_16x16x128_F4F4)
    return op.emitOpError("unsupported scaled matrix operation kind");
  return success();
}

static LogicalResult verifyMmaScaleFragments(MmaScaleOp op) {
  auto aType = cast<FragmentType>(op.getA().getType());
  auto bType = cast<FragmentType>(op.getB().getType());
  auto accType = cast<FragmentType>(op.getAcc().getType());
  auto resultType = cast<FragmentType>(op.getResult().getType());
  if (!matchMfmaGfx950F4AB(aType, 0))
    return op.emitOpError("A operand must be a 16x16 packed-f4 wave64 fragment "
                          "with 4 registers");
  if (!matchMfmaGfx950F4AB(bType, 1))
    return op.emitOpError("B operand must be a 16x16 packed-f4 wave64 fragment "
                          "with 4 registers");
  if (!matchMfmaGfx950F32Acc(accType))
    return op.emitOpError(
        "accumulator must be a 16x16 f32 wave64 fragment with 4 registers");
  if (resultType != accType)
    return op.emitOpError("result type must match accumulator type");
  return success();
}

static LogicalResult verifyMmaScaleTypes(MmaScaleOp op) {
  if (!isMmaScaleType(op.getAScale().getType()))
    return op.emitOpError("A scale must be !wave.simd<i32, 64>, "
                          "!wave.simd<vector<4xi8>, 64>, or "
                          "!wave.simd<vector<8xi8>, 64>");
  if (!isMmaScaleType(op.getBScale().getType()))
    return op.emitOpError("B scale must be !wave.simd<i32, 64>, "
                          "!wave.simd<vector<4xi8>, 64>, or "
                          "!wave.simd<vector<8xi8>, 64>");
  return success();
}

LogicalResult MmaScaleOp::verify() {
  if (failed(verifyMmaScaleAttrs(*this)))
    return failure();
  if (failed(verifyMmaScaleFragments(*this)))
    return failure();
  if (failed(verifyMmaScaleTypes(*this)))
    return failure();
  return success();
}

namespace {
struct MmaScaleOperandRewrite {
  Value scale;
  int64_t scaleIdx;
};

struct MmaScalePackExtract {
  wave::PackOp pack;
  wave::ExtractOp extract;
};

struct MmaScaleExtractSource {
  wave::PackOp pack;
  Value source;
  int64_t sourceIndex;
  int64_t wordBase;
};

static bool isExtractFrom(Value value, Value source, int64_t index) {
  wave::ExtractOp extract = value.getDefiningOp<wave::ExtractOp>();
  return extract && extract.getSource() == source &&
         static_cast<int64_t>(extract.getIndex()) == index;
}

static bool isCanonicalUpperDwordPack(wave::PackOp pack, Value source,
                                      int64_t wordBase) {
  if (wordBase == 0 || pack.getInputs().size() != 8)
    return false;
  for (int64_t index : llvm::seq<int64_t>(0, 4))
    if (!isExtractFrom(pack.getInputs()[index], source, wordBase + index))
      return false;
  for (int64_t index : llvm::seq<int64_t>(0, 4))
    if (!isExtractFrom(pack.getInputs()[4 + index], source, index))
      return false;
  return true;
}

static Value createDwordScalePack(PatternRewriter &rewriter, Location loc,
                                  wave::PackOp sourcePack, Value source,
                                  int64_t wordBase) {
  Type extractType = sourcePack.getInputs().front().getType();
  SmallVector<Value, 8> inputs;
  inputs.reserve(8);
  for (int64_t index : llvm::seq<int64_t>(wordBase, wordBase + 4)) {
    wave::ExtractOp extract = wave::ExtractOp::create(
        rewriter, loc, extractType, source, rewriter.getI64IntegerAttr(index));
    inputs.push_back(extract.getResult());
  }
  for (int64_t index : llvm::seq<int64_t>(0, wordBase)) {
    wave::ExtractOp extract = wave::ExtractOp::create(
        rewriter, loc, extractType, source, rewriter.getI64IntegerAttr(index));
    inputs.push_back(extract.getResult());
  }
  return wave::PackOp::create(rewriter, loc, sourcePack.getResult().getType(),
                              inputs)
      .getResult();
}

static FailureOr<MmaScalePackExtract> getSelectedPackExtract(Value scale,
                                                             int64_t scaleIdx) {
  wave::PackOp pack = scale.getDefiningOp<wave::PackOp>();
  if (!pack)
    return failure();
  if (!isScaleI8VectorWave64(pack.getResult().getType(), 8))
    return failure();
  if (scaleIdx < 0)
    return failure();
  if (scaleIdx >= static_cast<int64_t>(pack.getInputs().size()))
    return failure();

  wave::ExtractOp selected = pack.getInputs()[static_cast<unsigned>(scaleIdx)]
                                 .getDefiningOp<wave::ExtractOp>();
  if (!selected)
    return failure();
  return MmaScalePackExtract{pack, selected};
}

static std::optional<int64_t> getSupportedI8ScaleSourceLength(Type type) {
  std::optional<int64_t> elements = getI8ScaleVectorLength(type);
  if (!elements)
    return std::nullopt;
  if (*elements != 4 && *elements != 8)
    return std::nullopt;
  return elements;
}

static FailureOr<MmaScaleExtractSource>
matchRepackedMmaScaleSource(Value scale, int64_t scaleIdx) {
  FailureOr<MmaScalePackExtract> selected =
      getSelectedPackExtract(scale, scaleIdx);
  if (failed(selected))
    return failure();

  Value source = selected->extract.getSource();
  std::optional<int64_t> sourceElements =
      getSupportedI8ScaleSourceLength(source.getType());
  if (!sourceElements)
    return failure();

  int64_t sourceIndex = static_cast<int64_t>(selected->extract.getIndex());
  if (sourceIndex >= *sourceElements)
    return failure();
  int64_t wordBase = sourceIndex & ~int64_t{3};
  if (wordBase + 3 >= *sourceElements)
    return failure();
  return MmaScaleExtractSource{selected->pack, source, sourceIndex, wordBase};
}

static FailureOr<MmaScaleOperandRewrite>
matchRepackedMmaScaleOperand(PatternRewriter &rewriter, Location loc,
                             Value scale, int64_t scaleIdx) {
  FailureOr<MmaScaleExtractSource> matched =
      matchRepackedMmaScaleSource(scale, scaleIdx);
  if (failed(matched))
    return failure();

  int64_t newScaleIdx = matched->sourceIndex - matched->wordBase;
  if (matched->wordBase == 0)
    return MmaScaleOperandRewrite{matched->source, newScaleIdx};
  if (isCanonicalUpperDwordPack(matched->pack, matched->source,
                                matched->wordBase))
    return failure();

  Value wordScale = createDwordScalePack(rewriter, loc, matched->pack,
                                         matched->source, matched->wordBase);
  return MmaScaleOperandRewrite{wordScale, newScaleIdx};
}

struct MmaScaleRepackCanonicalizer : OpRewritePattern<MmaScaleOp> {
  using OpRewritePattern<MmaScaleOp>::OpRewritePattern;

  LogicalResult matchAndRewrite(MmaScaleOp op,
                                PatternRewriter &rewriter) const override {
    rewriter.setInsertionPoint(op);
    FailureOr<MmaScaleOperandRewrite> aScale = matchRepackedMmaScaleOperand(
        rewriter, op.getLoc(), op.getAScale(), op.getScaleIdxA());
    FailureOr<MmaScaleOperandRewrite> bScale = matchRepackedMmaScaleOperand(
        rewriter, op.getLoc(), op.getBScale(), op.getScaleIdxB());
    if (failed(aScale) && failed(bScale))
      return failure();

    rewriter.modifyOpInPlace(op, [&] {
      if (succeeded(aScale)) {
        op->setOperand(1, aScale->scale);
        op->setAttr("scale_idx_a",
                    rewriter.getI64IntegerAttr(aScale->scaleIdx));
      }
      if (succeeded(bScale)) {
        op->setOperand(3, bScale->scale);
        op->setAttr("scale_idx_b",
                    rewriter.getI64IntegerAttr(bScale->scaleIdx));
      }
    });
    return success();
  }
};
} // namespace

void MmaScaleOp::getCanonicalizationPatterns(RewritePatternSet &patterns,
                                             MLIRContext *context) {
  patterns.add<MmaScaleRepackCanonicalizer>(context);
}

static LogicalResult verifyDmaLoadLdsOptions(DmaLoadLdsOp op) {
  if (op.getBytes() != 4 && op.getBytes() != 16)
    return op.emitOpError("currently supports only bytes = 4 or 16");
  IntegerAttr delay = op->getAttrOfType<IntegerAttr>("issue_delay_cycles");
  IntegerAttr overlap =
      op->getAttrOfType<IntegerAttr>("issue_delay_overlap_cycles");
  IntegerAttr threshold =
      op->getAttrOfType<IntegerAttr>("issue_delay_skip_thread_threshold");
  if (!delay && (overlap || threshold))
    return op.emitOpError("issue delay options require issue_delay_cycles");
  if (delay && overlap && overlap.getInt() > delay.getInt())
    return op.emitOpError("issue delay overlap cannot exceed delay cycles");
  return success();
}

LogicalResult DmaLoadLdsOp::verify() {
  if (failed(verifyDmaLoadLdsOptions(*this)))
    return failure();

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
  Type destElementType = destPtr.getElementType();
  if (destElementType && !destElementType.isInteger(32))
    return emitOpError("destination pointer element type must be i32");
  return success();
}

namespace {
struct SharedPointerInfo {
  wave::PtrType ptr;
  std::optional<int64_t> simdWidth;
};

enum class TransposeLoadKind { B4, B6, B8, B16 };

static FailureOr<SharedPointerInfo>
getSharedPointerInfo(Operation *op, Value value, StringRef name) {
  Type type = value.getType();
  std::optional<int64_t> simdWidth;
  if (auto simdType = dyn_cast<wave::SimdType>(type)) {
    simdWidth = simdType.getWidth();
    type = simdType.getElementType();
  }
  auto ptrType = dyn_cast<wave::PtrType>(type);
  if (!ptrType)
    return op->emitOpError() << name << " must be a wave pointer";
  if (!isa<wave::SharedAddressSpaceAttr>(ptrType.getAddressSpace()))
    return op->emitOpError() << name << " pointer must be shared";
  return SharedPointerInfo{ptrType, simdWidth};
}

static bool isTransposeLoadB16Element(Type elementType) {
  return elementType.isInteger(16) || elementType.isF16() ||
         elementType.isBF16();
}

static std::optional<FailureOr<TransposeLoadKind>>
verifyIntegerTransposeLoadResult(Operation *op, unsigned width, int64_t count) {
  if (width == 4) {
    if (count == 16)
      return TransposeLoadKind::B4;
    return op->emitOpError("i4 transpose load result must have 16 elements");
  }
  if (width == 8) {
    if (count == 8)
      return TransposeLoadKind::B8;
    return op->emitOpError("i8 transpose load result must have 8 elements");
  }
  if (width == 32) {
    if (count == 3)
      return TransposeLoadKind::B6;
    return op->emitOpError("i32 transpose load result must have 3 elements");
  }
  return std::nullopt;
}

static FailureOr<TransposeLoadKind> verifyTransposeLoadResult(Operation *op,
                                                              Value value) {
  auto simdType = cast<wave::SimdType>(value.getType());
  auto vecType = dyn_cast<VectorType>(simdType.getElementType());
  if (simdType.getWidth() != 64)
    return op->emitOpError("result SIMD width must be 64");
  if (!vecType || vecType.getRank() != 1)
    return op->emitOpError("result SIMD element type must be a 1-D vector");
  Type elementType = vecType.getElementType();
  if (auto intType = dyn_cast<IntegerType>(elementType))
    if (std::optional<FailureOr<TransposeLoadKind>> kind =
            verifyIntegerTransposeLoadResult(op, intType.getWidth(),
                                             vecType.getNumElements()))
      return *kind;
  if (isTransposeLoadB16Element(elementType)) {
    if (vecType.getNumElements() == 4)
      return TransposeLoadKind::B16;
    return op->emitOpError("16-bit transpose load result must have 4 elements");
  }
  return op->emitOpError(
      "transpose load result element type must be i4, i8, i16, i32, f16, or "
      "bf16");
}

static LogicalResult verifyTransposeLoadSourceElement(Operation *op,
                                                      Type elementType,
                                                      TransposeLoadKind kind) {
  if (!elementType)
    return success();
  if (kind == TransposeLoadKind::B4 || kind == TransposeLoadKind::B8) {
    if (elementType.isInteger(8))
      return success();
    return op->emitOpError(
        "source pointer element type must be i8 for i4/i8 transpose load");
  }
  if (kind == TransposeLoadKind::B6) {
    if (elementType.isInteger(32))
      return success();
    return op->emitOpError(
        "source pointer element type must be i32 for i32 transpose load");
  }
  if (isTransposeLoadB16Element(elementType))
    return success();
  return op->emitOpError(
      "source pointer element type must be i16, f16, or bf16 for 16-bit "
      "transpose load");
}
} // namespace

LogicalResult GlobalAtomicAddAcqRelOp::verify() {
  Type ptrStorageType = getPtr().getType();
  std::optional<int64_t> ptrWidth;
  if (auto simdType = dyn_cast<wave::SimdType>(ptrStorageType)) {
    ptrWidth = simdType.getWidth();
    ptrStorageType = simdType.getElementType();
  }
  auto ptrType = cast<wave::PtrType>(ptrStorageType);
  if (!isa<wave::GlobalAddressSpaceAttr>(ptrType.getAddressSpace()))
    return emitOpError("atomic pointer must be global");
  Type elementType = ptrType.getElementType();
  if (elementType && !elementType.isInteger(32))
    return emitOpError("atomic pointer element type must be i32");

  wave::SimdType valueType = cast<wave::SimdType>(getValue().getType());
  if (!valueType.getElementType().isInteger(32))
    return emitOpError("atomic value must have i32 SIMD elements");
  if (ptrWidth && *ptrWidth != valueType.getWidth())
    return emitOpError("atomic pointer and value SIMD widths must match");
  if (getOldValue().getType() != valueType)
    return emitOpError("result type must match atomic value type");
  return success();
}

LogicalResult TransposeLoadOp::verify() {
  FailureOr<SharedPointerInfo> source =
      getSharedPointerInfo(getOperation(), getSource(), "source");
  if (failed(source))
    return failure();
  if (source->simdWidth && *source->simdWidth != 64)
    return emitOpError("source SIMD width must be 64");
  FailureOr<TransposeLoadKind> kind =
      verifyTransposeLoadResult(getOperation(), getValue());
  if (failed(kind))
    return failure();
  return verifyTransposeLoadSourceElement(getOperation(),
                                          source->ptr.getElementType(), *kind);
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
