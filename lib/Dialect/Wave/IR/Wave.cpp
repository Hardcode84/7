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
#include "mlir/Dialect/CommonFolders.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/GPU/IR/GPUDialect.h"
#include "mlir/Dialect/SCF/IR/SCF.h"
#include "mlir/Dialect/Utils/StaticValueUtils.h"
#include "mlir/IR/Builders.h"
#include "mlir/IR/DialectImplementation.h"
#include "mlir/IR/IRMapping.h"
#include "mlir/IR/Matchers.h"
#include "mlir/IR/PatternMatch.h"
#include "mlir/Interfaces/SideEffectInterfaces.h"
#include "mlir/Interfaces/Utils/InferIntRangeCommon.h"
#include "llvm/ADT/APFloat.h"
#include "llvm/ADT/APInt.h"
#include "llvm/ADT/APSInt.h"
#include "llvm/ADT/DenseSet.h"
#include "llvm/ADT/FloatingPointMode.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/ADT/StringMap.h"
#include "llvm/ADT/StringSet.h"
#include "llvm/ADT/Twine.h"
#include "llvm/ADT/TypeSwitch.h"
#include "llvm/Support/CheckedArithmetic.h"
#include "llvm/Support/ErrorHandling.h"
#include "llvm/Support/MathExtras.h"

#include <array>
#include <cstdint>
#include <limits>
#include <numeric>
#include <utility>

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

static Type getWaveConstantValueType(Type type) {
  if (SimdType simd = dyn_cast<SimdType>(type))
    return simd.getElementType();
  if (isa<MaskType>(type))
    return IntegerType::get(type.getContext(), 1);
  return type;
}

Operation *WaveDialect::materializeConstant(OpBuilder &builder, Attribute value,
                                            Type type, Location loc) {
  return ConstantOp::materialize(builder, value, type, loc);
}

sym::Store &WaveDialect::getSymbolStore() {
  assert(symbolStore && "wave symbolic store must be initialized");
  return *symbolStore;
}

const sym::Store &WaveDialect::getSymbolStore() const {
  assert(symbolStore && "wave symbolic store must be initialized");
  return *symbolStore;
}

ParseResult ConstantOp::parse(OpAsmParser &parser, OperationState &result) {
  Attribute value;
  Type resultType;
  if (parser.parseAttribute(value, getValueAttrName(result.name),
                            result.attributes) ||
      parser.parseOptionalAttrDict(result.attributes))
    return failure();

  if (succeeded(parser.parseOptionalArrow())) {
    if (parser.parseType(resultType))
      return failure();
  } else {
    auto typed = dyn_cast<TypedAttr>(value);
    if (!typed)
      return parser.emitError(parser.getNameLoc(),
                              "constant value must be a typed attribute");
    resultType = typed.getType();
  }

  result.addTypes(resultType);
  return success();
}

void ConstantOp::print(OpAsmPrinter &p) {
  p << ' ';
  p.printAttribute(getValue());
  p.printOptionalAttrDict((*this)->getAttrs(), {getValueAttrName()});
  if (cast<TypedAttr>(getValue()).getType() != getType())
    p << " -> " << getType();
}

bool ConstantOp::isBuildableWith(Attribute value, Type type) {
  TypedAttr typed = dyn_cast_if_present<TypedAttr>(value);
  return typed && typed.getType() == getWaveConstantValueType(type);
}

ConstantOp ConstantOp::materialize(OpBuilder &builder, Attribute value,
                                   Type type, Location loc) {
  TypedAttr typed = dyn_cast_if_present<TypedAttr>(value);
  if (!typed || !isBuildableWith(typed, type))
    return nullptr;
  return ConstantOp::create(builder, loc, type, typed);
}

OpFoldResult ConstantOp::fold(FoldAdaptor) { return getValue(); }

void ConstantOp::inferResultRanges(ArrayRef<ConstantIntRanges>,
                                   SetIntRangeFn setResultRange) {
  IntegerAttr attr = dyn_cast<IntegerAttr>(getValue());
  if (!attr)
    return;
  Type valueType = getWaveConstantValueType(getType());
  if (!valueType.isIntOrIndex())
    return;
  unsigned bits = ConstantIntRanges::getStorageBitwidth(valueType);
  if (bits == 0)
    return;
  APInt value = attr.getValue().sextOrTrunc(bits);
  setResultRange(getResult(), ConstantIntRanges::constant(value));
}

LogicalResult ConstantOp::verify() {
  if (isBuildableWith(getValue(), getType()))
    return success();
  return emitOpError("value type must match the result payload type");
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

LogicalResult RedistributionAttr::verify(
    function_ref<InFlightDiagnostic()> emitError, int64_t blocks, int64_t items,
    sym::ExprHandle sourceBlock, sym::ExprHandle sourceItem,
    sym::ExprHandle sourceSlot) {
  if (blocks <= 0)
    return emitError() << "redistribution block count must be positive";
  if (items <= 0)
    return emitError() << "redistribution item count must be positive";
  if (!sym::isExpr(sourceBlock) || !sym::isExpr(sourceItem) ||
      !sym::isExpr(sourceSlot))
    return emitError() << "redistribution coordinates must be expressions";
  return success();
}

LogicalResult
MemoryMappingAttr::verify(function_ref<InFlightDiagnostic()> emitError,
                          ExprAttr base, ExprAttr targetBlock,
                          ExprAttr bitOffset) {
  if (!bitOffset)
    return emitError() << "memory mapping requires a bit offset expression";
  if ((base && !sym::isExpr(base.getValue())) ||
      (targetBlock && !sym::isExpr(targetBlock.getValue())) ||
      !sym::isExpr(bitOffset.getValue()))
    return emitError() << "memory mapping coordinates must be expressions";
  return success();
}

static bool isRegAllocPackedUnsigned(int64_t value) {
  return value >= 0 &&
         static_cast<uint64_t>(value) <= std::numeric_limits<unsigned>::max();
}

static LogicalResult
verifyRegAllocPackedSlice(function_ref<InFlightDiagnostic()> emitError,
                          StringRef name, int64_t begin, int64_t count,
                          size_t size) {
  if (!isRegAllocPackedUnsigned(begin) || !isRegAllocPackedUnsigned(count))
    return emitError() << name << " slice exceeds supported range";
  size_t unsignedBegin = static_cast<size_t>(begin);
  size_t unsignedCount = static_cast<size_t>(count);
  if (unsignedBegin > size || unsignedCount > size - unsignedBegin)
    return emitError() << name << " slice is out of bounds";
  return success();
}

static LogicalResult
verifyRegAllocPackedPathComponents(function_ref<InFlightDiagnostic()> emitError,
                                   StringRef name, ArrayRef<int64_t> paths) {
  for (int64_t component : paths)
    if (!isRegAllocPackedUnsigned(component))
      return emitError() << name << " component exceeds range";
  return success();
}

static LogicalResult
verifyRegAllocPackedOps(function_ref<InFlightDiagnostic()> emitError,
                        ArrayRef<int64_t> ops, ArrayRef<int64_t> opPaths) {
  using State = RegAllocStateAttr;
  size_t nextOpPath = 0;
  for (size_t index : llvm::seq<size_t>(ops.size() / State::OpFieldCount)) {
    ArrayRef<int64_t> record =
        ops.slice(index * State::OpFieldCount, State::OpFieldCount);
    if (record[State::OpPathBegin] != static_cast<int64_t>(nextOpPath))
      return emitError() << "regalloc op paths are not contiguous";
    if (failed(verifyRegAllocPackedSlice(
            emitError, "regalloc op path", record[State::OpPathBegin],
            record[State::OpPathLength], opPaths.size())))
      return failure();
    if (record[State::OpPathLength] == 0)
      return emitError() << "regalloc op path is empty";
    nextOpPath += static_cast<size_t>(record[State::OpPathLength]);
  }
  if (nextOpPath != opPaths.size())
    return emitError() << "regalloc op path slab has trailing data";
  return verifyRegAllocPackedPathComponents(emitError, "regalloc op path",
                                            opPaths);
}

static LogicalResult
verifyRegAllocPackedValueIdentity(function_ref<InFlightDiagnostic()> emitError,
                                  ArrayRef<int64_t> record,
                                  size_t aliasSetCount) {
  using State = RegAllocStateAttr;
  int64_t regClass = record[State::ValueRegClass];
  if (regClass < State::PackedSGPR || regClass > State::PackedAGPR)
    return emitError() << "regalloc value has invalid register class";
  int64_t kind = record[State::ValueKind];
  if (kind < State::PackedBlockArgument || kind > State::PackedOpResult)
    return emitError() << "regalloc value has invalid kind";
  int64_t fixed = record[State::ValueFixed];
  if (fixed != -1 && !isRegAllocPackedUnsigned(fixed))
    return emitError() << "regalloc value fixed index exceeds range";
  if (!isRegAllocPackedUnsigned(record[State::ValueSet]) ||
      static_cast<uint64_t>(record[State::ValueSet]) >= aliasSetCount)
    return emitError() << "regalloc value alias-set ID is invalid";
  return success();
}

static LogicalResult verifyRegAllocPackedValueRangeFields(
    function_ref<InFlightDiagnostic()> emitError, ArrayRef<int64_t> record) {
  using State = RegAllocStateAttr;
  if (!isRegAllocPackedUnsigned(record[State::ValueStart]) ||
      !isRegAllocPackedUnsigned(record[State::ValueEnd]) ||
      record[State::ValueEnd] < record[State::ValueStart])
    return emitError() << "regalloc value range envelope is invalid";
  if (!isRegAllocPackedUnsigned(record[State::ValueWidth]) ||
      record[State::ValueWidth] == 0)
    return emitError() << "regalloc value width is invalid";
  if (!isRegAllocPackedUnsigned(record[State::ValueOffset]) ||
      !isRegAllocPackedUnsigned(record[State::ValueNumber]))
    return emitError() << "regalloc value field exceeds range";
  return success();
}

static LogicalResult
verifyRegAllocPackedValueSlices(function_ref<InFlightDiagnostic()> emitError,
                                ArrayRef<int64_t> record, size_t valuePathSize,
                                size_t rangeCount, size_t &nextValuePath,
                                size_t &nextValueRange) {
  using State = RegAllocStateAttr;
  if (record[State::ValuePathBegin] != static_cast<int64_t>(nextValuePath))
    return emitError() << "regalloc value paths are not contiguous";
  if (failed(verifyRegAllocPackedSlice(
          emitError, "regalloc value path", record[State::ValuePathBegin],
          record[State::ValuePathLength], valuePathSize)))
    return failure();
  if (record[State::ValuePathLength] == 0)
    return emitError() << "regalloc value path is empty";
  nextValuePath += static_cast<size_t>(record[State::ValuePathLength]);
  if (record[State::ValueRangeBegin] != static_cast<int64_t>(nextValueRange))
    return emitError() << "regalloc value ranges are not contiguous";
  if (failed(verifyRegAllocPackedSlice(
          emitError, "regalloc value ranges", record[State::ValueRangeBegin],
          record[State::ValueRangeCount], rangeCount)))
    return failure();
  if (record[State::ValueRangeCount] == 0)
    return emitError() << "regalloc value has no live ranges";
  nextValueRange += static_cast<size_t>(record[State::ValueRangeCount]);
  return success();
}

static LogicalResult
verifyRegAllocPackedLiveRanges(function_ref<InFlightDiagnostic()> emitError,
                               ArrayRef<int64_t> record,
                               ArrayRef<int64_t> valueRanges) {
  using State = RegAllocStateAttr;
  size_t rangeBegin = static_cast<size_t>(record[State::ValueRangeBegin]);
  size_t rangeCount = static_cast<size_t>(record[State::ValueRangeCount]);
  int64_t priorEnd = -1;
  for (size_t rangeIndex : llvm::seq<size_t>(rangeCount)) {
    ArrayRef<int64_t> range =
        valueRanges.slice((rangeBegin + rangeIndex) * State::RangeFieldCount,
                          State::RangeFieldCount);
    if (!isRegAllocPackedUnsigned(range[State::RangeStart]) ||
        !isRegAllocPackedUnsigned(range[State::RangeEnd]) ||
        range[State::RangeEnd] < range[State::RangeStart] ||
        range[State::RangeStart] <= priorEnd)
      return emitError() << "regalloc value live ranges are invalid";
    priorEnd = range[State::RangeEnd];
    if (rangeIndex == 0 &&
        range[State::RangeStart] != record[State::ValueStart])
      return emitError() << "regalloc value range start mismatches envelope";
    if (rangeIndex + 1 == rangeCount &&
        range[State::RangeEnd] != record[State::ValueEnd])
      return emitError() << "regalloc value range end mismatches envelope";
  }
  return success();
}

static LogicalResult verifyRegAllocPackedValues(
    function_ref<InFlightDiagnostic()> emitError, ArrayRef<int64_t> values,
    ArrayRef<int64_t> valuePaths, ArrayRef<int64_t> valueRanges,
    size_t aliasSetCount) {
  using State = RegAllocStateAttr;
  size_t rangeCount = valueRanges.size() / State::RangeFieldCount;
  size_t nextValuePath = 0;
  size_t nextValueRange = 0;
  for (size_t index :
       llvm::seq<size_t>(values.size() / State::ValueFieldCount)) {
    ArrayRef<int64_t> record =
        values.slice(index * State::ValueFieldCount, State::ValueFieldCount);
    if (failed(verifyRegAllocPackedValueIdentity(emitError, record,
                                                 aliasSetCount)))
      return failure();
    if (failed(verifyRegAllocPackedValueRangeFields(emitError, record)))
      return failure();
    if (failed(verifyRegAllocPackedValueSlices(emitError, record,
                                               valuePaths.size(), rangeCount,
                                               nextValuePath, nextValueRange)))
      return failure();
    if (failed(verifyRegAllocPackedLiveRanges(emitError, record, valueRanges)))
      return failure();
  }
  if (nextValuePath != valuePaths.size())
    return emitError() << "regalloc value path slab has trailing data";
  if (nextValueRange != rangeCount)
    return emitError() << "regalloc range slab has trailing data";
  return verifyRegAllocPackedPathComponents(emitError, "regalloc value path",
                                            valuePaths);
}

static LogicalResult verifyRegAllocPackedAliasSetHeader(
    function_ref<InFlightDiagnostic()> emitError, ArrayRef<int64_t> record,
    size_t aliasMemberSize, size_t &nextAliasMember) {
  using State = RegAllocStateAttr;
  int64_t regClass = record[State::AliasSetRegClass];
  if (regClass < State::PackedSGPR || regClass > State::PackedAGPR)
    return emitError() << "regalloc alias set has invalid register class";
  if (!isRegAllocPackedUnsigned(record[State::AliasSetWidth]) ||
      record[State::AliasSetWidth] == 0)
    return emitError() << "regalloc alias-set width is invalid";
  if (record[State::AliasSetMemberBegin] !=
      static_cast<int64_t>(nextAliasMember))
    return emitError() << "regalloc alias members are not contiguous";
  if (failed(verifyRegAllocPackedSlice(emitError, "regalloc alias members",
                                       record[State::AliasSetMemberBegin],
                                       record[State::AliasSetMemberCount],
                                       aliasMemberSize)))
    return failure();
  if (record[State::AliasSetMemberCount] == 0)
    return emitError() << "regalloc alias set has no members";
  nextAliasMember += static_cast<size_t>(record[State::AliasSetMemberCount]);
  return success();
}

static LogicalResult verifyRegAllocPackedAliasSetMembers(
    function_ref<InFlightDiagnostic()> emitError, size_t setIndex,
    ArrayRef<int64_t> record, ArrayRef<int64_t> values,
    ArrayRef<int64_t> aliasMembers, SmallVectorImpl<char> &seenValues) {
  using State = RegAllocStateAttr;
  size_t memberBegin = static_cast<size_t>(record[State::AliasSetMemberBegin]);
  size_t memberCount = static_cast<size_t>(record[State::AliasSetMemberCount]);
  int64_t regClass = record[State::AliasSetRegClass];
  int64_t computedWidth = 0;
  for (size_t memberIndex : llvm::seq<size_t>(memberCount)) {
    int64_t valueId = aliasMembers[memberBegin + memberIndex];
    if (!isRegAllocPackedUnsigned(valueId) ||
        static_cast<uint64_t>(valueId) >= seenValues.size())
      return emitError() << "regalloc alias member value ID is invalid";
    size_t unsignedValueId = static_cast<size_t>(valueId);
    if (seenValues[unsignedValueId])
      return emitError() << "regalloc value belongs to multiple alias sets";
    seenValues[unsignedValueId] = 1;
    ArrayRef<int64_t> value = values.slice(
        unsignedValueId * State::ValueFieldCount, State::ValueFieldCount);
    if (value[State::ValueSet] != static_cast<int64_t>(setIndex) ||
        value[State::ValueRegClass] != regClass)
      return emitError() << "regalloc alias member metadata mismatches set";
    computedWidth = std::max(computedWidth, value[State::ValueOffset] +
                                                value[State::ValueWidth]);
  }
  if (computedWidth != record[State::AliasSetWidth])
    return emitError() << "regalloc alias-set width mismatches members";
  return success();
}

static LogicalResult verifyRegAllocPackedAliasSets(
    function_ref<InFlightDiagnostic()> emitError, ArrayRef<int64_t> values,
    ArrayRef<int64_t> aliasSets, ArrayRef<int64_t> aliasMembers) {
  using State = RegAllocStateAttr;
  size_t valueCount = values.size() / State::ValueFieldCount;
  SmallVector<char> seenValues(valueCount, 0);
  size_t nextAliasMember = 0;
  for (size_t index :
       llvm::seq<size_t>(aliasSets.size() / State::AliasSetFieldCount)) {
    ArrayRef<int64_t> record = aliasSets.slice(
        index * State::AliasSetFieldCount, State::AliasSetFieldCount);
    if (failed(verifyRegAllocPackedAliasSetHeader(
            emitError, record, aliasMembers.size(), nextAliasMember)))
      return failure();
    if (failed(verifyRegAllocPackedAliasSetMembers(
            emitError, index, record, values, aliasMembers, seenValues)))
      return failure();
  }
  if (nextAliasMember != aliasMembers.size())
    return emitError() << "regalloc alias-member slab has trailing data";
  if (llvm::is_contained(seenValues, 0))
    return emitError() << "regalloc value has no alias set";
  return success();
}

LogicalResult RegAllocStateAttr::verify(
    function_ref<InFlightDiagnostic()> emitError, int64_t version,
    ArrayRef<int64_t> ops, ArrayRef<int64_t> opPaths, ArrayRef<int64_t> values,
    ArrayRef<int64_t> valuePaths, ArrayRef<int64_t> valueRanges,
    ArrayRef<int64_t> aliasSets, ArrayRef<int64_t> aliasMembers) {
  if (version != kVersion)
    return emitError() << "unsupported regalloc state version " << version;
  if (ops.size() % OpFieldCount != 0)
    return emitError() << "regalloc op slab has partial record";
  if (values.size() % ValueFieldCount != 0)
    return emitError() << "regalloc value slab has partial record";
  if (valueRanges.size() % RangeFieldCount != 0)
    return emitError() << "regalloc range slab has partial record";
  if (aliasSets.size() % AliasSetFieldCount != 0)
    return emitError() << "regalloc alias-set slab has partial record";
  if (failed(verifyRegAllocPackedOps(emitError, ops, opPaths)))
    return failure();
  if (failed(verifyRegAllocPackedValues(emitError, values, valuePaths,
                                        valueRanges,
                                        aliasSets.size() / AliasSetFieldCount)))
    return failure();
  return verifyRegAllocPackedAliasSets(emitError, values, aliasSets,
                                       aliasMembers);
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

OpFoldResult SplatOp::fold(FoldAdaptor adaptor) {
  if (Attribute source = adaptor.getSource())
    return source;
  return {};
}

namespace {
struct WaveBinaryOperandShape {
  Type elementType;
  std::optional<int64_t> simdWidth;
};
} // namespace

static FailureOr<WaveBinaryOperandShape> classifyWaveBinaryOperand(
    Type type, function_ref<InFlightDiagnostic(const Twine &)> emitError) {
  if (auto intTy = dyn_cast<IntegerType>(type)) {
    if (!intTy.isSignless())
      return emitError("integer operand must be signless");
    return WaveBinaryOperandShape{intTy, std::nullopt};
  }
  if (type.isIndex())
    return WaveBinaryOperandShape{type, std::nullopt};
  if (auto simdTy = dyn_cast<SimdType>(type)) {
    Type element = simdTy.getElementType();
    if (auto intTy = dyn_cast<IntegerType>(element)) {
      if (!intTy.isSignless())
        return emitError("SIMD operand element type must be signless");
      return WaveBinaryOperandShape{intTy, simdTy.getWidth()};
    }
    if (element.isIndex())
      return WaveBinaryOperandShape{element, simdTy.getWidth()};
    return emitError("SIMD operand element type must be integer or index");
  }
  return emitError("operand must be integer, index, or !wave.simd<T, W>");
}

static LogicalResult verifyWaveBinaryResult(
    Type resultType, Type elementType, std::optional<int64_t> simdWidth,
    function_ref<InFlightDiagnostic(const Twine &)> emitError) {
  if (!simdWidth)
    return resultType == elementType
               ? success()
               : emitError("result type must match operands");
  auto simdTy = dyn_cast<SimdType>(resultType);
  if (!simdTy)
    return emitError(
        "result must be SIMD because at least one operand is SIMD");
  if (simdTy.getWidth() != *simdWidth)
    return emitError("result SIMD wave width must match operands");
  if (simdTy.getElementType() != elementType)
    return emitError("result SIMD element type must match operands");
  return success();
}

static bool supportsWaveBinaryOverflowFlags(BinaryKind kind) {
  switch (kind) {
  case BinaryKind::AddI:
  case BinaryKind::SubI:
  case BinaryKind::MulI:
  case BinaryKind::ShLI:
    return true;
  default:
    return false;
  }
}

static OpFoldResult foldToResultValue(Value value, Type resultType) {
  if (value && value.getType() == resultType)
    return value;
  return {};
}

static Attribute getZeroFoldAttr(MLIRContext *context, Type type) {
  return Builder(context).getZeroAttr(getWaveConstantValueType(type));
}

static bool isAllOnes(Attribute attr) {
  APInt value;
  return matchPattern(attr, m_ConstantInt(&value)) && value.isAllOnes();
}

template <typename CalculationT>
static Attribute constFoldWaveIntegerBinary(ArrayRef<Attribute> operands,
                                            Type resultType,
                                            CalculationT &&calculate) {
  return constFoldBinaryOp<IntegerAttr>(operands,
                                        getWaveConstantValueType(resultType),
                                        std::forward<CalculationT>(calculate));
}

template <typename SourceAttr, typename ResultAttr, typename CalculationT>
static Attribute constFoldWaveCast(ArrayRef<Attribute> operands,
                                   Type resultType, CalculationT &&calculate) {
  return constFoldCastOp<SourceAttr, ResultAttr, typename SourceAttr::ValueType,
                         typename ResultAttr::ValueType, void>(
      operands, getWaveConstantValueType(resultType),
      std::forward<CalculationT>(calculate));
}

static Attribute foldWaveShiftConstants(ArrayRef<Attribute> operands,
                                        Type resultType,
                                        function_ref<APInt(APInt, APInt)> fn) {
  bool bounded = true;
  Attribute result =
      constFoldWaveIntegerBinary(operands, resultType, [&](APInt a, APInt b) {
        bounded &= b.ult(b.getBitWidth());
        return fn(std::move(a), std::move(b));
      });
  return bounded ? result : Attribute();
}

static Attribute foldWaveAddSubMulConstants(BinaryOp op,
                                            ArrayRef<Attribute> operands) {
  switch (op.getKind()) {
  case BinaryKind::AddI:
    return constFoldWaveIntegerBinary(
        operands, op.getType(),
        [](APInt a, const APInt &b) { return std::move(a) + b; });
  case BinaryKind::SubI:
    return constFoldWaveIntegerBinary(
        operands, op.getType(),
        [](APInt a, const APInt &b) { return std::move(a) - b; });
  case BinaryKind::MulI:
    return constFoldWaveIntegerBinary(
        operands, op.getType(),
        [](const APInt &a, const APInt &b) { return a * b; });
  default:
    return {};
  }
}

static Attribute foldWaveShiftConstants(BinaryOp op,
                                        ArrayRef<Attribute> operands) {
  switch (op.getKind()) {
  case BinaryKind::ShLI:
    return foldWaveShiftConstants(operands, op.getType(),
                                  [](APInt a, APInt b) { return a.shl(b); });
  case BinaryKind::ShRUI:
    return foldWaveShiftConstants(operands, op.getType(),
                                  [](APInt a, APInt b) { return a.lshr(b); });
  case BinaryKind::ShRSI:
    return foldWaveShiftConstants(operands, op.getType(),
                                  [](APInt a, APInt b) { return a.ashr(b); });
  default:
    return {};
  }
}

static Attribute foldWaveBitwiseConstants(BinaryOp op,
                                          ArrayRef<Attribute> operands) {
  switch (op.getKind()) {
  case BinaryKind::AndI:
    return constFoldWaveIntegerBinary(
        operands, op.getType(),
        [](APInt a, const APInt &b) { return std::move(a) & b; });
  case BinaryKind::OrI:
    return constFoldWaveIntegerBinary(
        operands, op.getType(),
        [](APInt a, const APInt &b) { return std::move(a) | b; });
  case BinaryKind::XOrI:
    return constFoldWaveIntegerBinary(
        operands, op.getType(),
        [](APInt a, const APInt &b) { return std::move(a) ^ b; });
  default:
    return {};
  }
}

static Attribute foldWaveDivUIConstants(Type type,
                                        ArrayRef<Attribute> operands) {
  bool div0 = false;
  Attribute result =
      constFoldWaveIntegerBinary(operands, type, [&](APInt a, const APInt &b) {
        if (div0 || b.isZero()) {
          div0 = true;
          return a;
        }
        return a.udiv(b);
      });
  return div0 ? Attribute() : result;
}

static Attribute foldWaveDivSIConstants(Type type,
                                        ArrayRef<Attribute> operands) {
  bool overflowOrDiv0 = false;
  Attribute result =
      constFoldWaveIntegerBinary(operands, type, [&](APInt a, const APInt &b) {
        if (overflowOrDiv0 || b.isZero()) {
          overflowOrDiv0 = true;
          return a;
        }
        return a.sdiv_ov(b, overflowOrDiv0);
      });
  return overflowOrDiv0 ? Attribute() : result;
}

static Attribute foldWaveRemUIConstants(Type type,
                                        ArrayRef<Attribute> operands) {
  bool div0 = false;
  Attribute result =
      constFoldWaveIntegerBinary(operands, type, [&](APInt a, const APInt &b) {
        if (div0 || b.isZero()) {
          div0 = true;
          return a;
        }
        return a.urem(b);
      });
  return div0 ? Attribute() : result;
}

static Attribute foldWaveRemSIConstants(Type type,
                                        ArrayRef<Attribute> operands) {
  bool div0 = false;
  Attribute result =
      constFoldWaveIntegerBinary(operands, type, [&](APInt a, const APInt &b) {
        if (div0 || b.isZero()) {
          div0 = true;
          return a;
        }
        return a.srem(b);
      });
  return div0 ? Attribute() : result;
}

static Attribute foldWaveDivRemConstants(BinaryOp op,
                                         ArrayRef<Attribute> operands) {
  switch (op.getKind()) {
  case BinaryKind::DivUI:
    return foldWaveDivUIConstants(op.getType(), operands);
  case BinaryKind::DivSI:
    return foldWaveDivSIConstants(op.getType(), operands);
  case BinaryKind::RemUI:
    return foldWaveRemUIConstants(op.getType(), operands);
  case BinaryKind::RemSI:
    return foldWaveRemSIConstants(op.getType(), operands);
  default:
    return {};
  }
}

static Attribute foldWaveMulHUIConstants(BinaryOp op,
                                         ArrayRef<Attribute> operands) {
  if (op.getKind() == BinaryKind::MulHUI)
    return constFoldWaveIntegerBinary(operands, op.getType(),
                                      llvm::APIntOps::mulhu);
  return {};
}

static Attribute foldWaveBinaryConstants(BinaryOp op,
                                         ArrayRef<Attribute> operands) {
  if (Attribute result = foldWaveAddSubMulConstants(op, operands))
    return result;
  if (Attribute result = foldWaveShiftConstants(op, operands))
    return result;
  if (Attribute result = foldWaveBitwiseConstants(op, operands))
    return result;
  if (Attribute result = foldWaveDivRemConstants(op, operands))
    return result;
  return foldWaveMulHUIConstants(op, operands);
}

static OpFoldResult foldWaveAddIdentity(BinaryOp op,
                                        BinaryOp::FoldAdaptor adaptor,
                                        Type resultType) {
  if (op.getKind() != BinaryKind::AddI)
    return {};
  if (matchPattern(adaptor.getRhs(), m_Zero()))
    return foldToResultValue(op.getLhs(), resultType);
  if (matchPattern(adaptor.getLhs(), m_Zero()))
    return foldToResultValue(op.getRhs(), resultType);
  return {};
}

static OpFoldResult foldWaveSubIdentity(BinaryOp op,
                                        BinaryOp::FoldAdaptor adaptor,
                                        Type resultType, Attribute zero) {
  if (op.getKind() != BinaryKind::SubI)
    return {};
  if (op.getLhs() == op.getRhs() && zero)
    return zero;
  if (matchPattern(adaptor.getRhs(), m_Zero()))
    return foldToResultValue(op.getLhs(), resultType);
  return {};
}

static OpFoldResult foldWaveAddSubIdentity(BinaryOp op,
                                           BinaryOp::FoldAdaptor adaptor,
                                           Type resultType, Attribute zero) {
  if (OpFoldResult result = foldWaveAddIdentity(op, adaptor, resultType))
    return result;
  return foldWaveSubIdentity(op, adaptor, resultType, zero);
}

static OpFoldResult foldWaveAndIdentity(BinaryOp op,
                                        BinaryOp::FoldAdaptor adaptor,
                                        Type resultType) {
  if (op.getKind() != BinaryKind::AndI)
    return {};
  if (matchPattern(adaptor.getRhs(), m_Zero()))
    return foldToResultValue(op.getRhs(), resultType);
  if (matchPattern(adaptor.getLhs(), m_Zero()))
    return foldToResultValue(op.getLhs(), resultType);
  if (isAllOnes(adaptor.getRhs()))
    return foldToResultValue(op.getLhs(), resultType);
  if (isAllOnes(adaptor.getLhs()))
    return foldToResultValue(op.getRhs(), resultType);
  return {};
}

static OpFoldResult foldWaveOrIdentity(BinaryOp op,
                                       BinaryOp::FoldAdaptor adaptor,
                                       Type resultType) {
  if (op.getKind() != BinaryKind::OrI)
    return {};
  if (matchPattern(adaptor.getRhs(), m_Zero()))
    return foldToResultValue(op.getLhs(), resultType);
  if (matchPattern(adaptor.getLhs(), m_Zero()))
    return foldToResultValue(op.getRhs(), resultType);
  if (isAllOnes(adaptor.getRhs()))
    return foldToResultValue(op.getRhs(), resultType);
  if (isAllOnes(adaptor.getLhs()))
    return foldToResultValue(op.getLhs(), resultType);
  return {};
}

static OpFoldResult foldWaveMulIdentity(BinaryOp op,
                                        BinaryOp::FoldAdaptor adaptor,
                                        Type resultType) {
  if (op.getKind() != BinaryKind::MulI)
    return {};
  if (matchPattern(adaptor.getRhs(), m_Zero()))
    return foldToResultValue(op.getRhs(), resultType);
  if (matchPattern(adaptor.getLhs(), m_Zero()))
    return foldToResultValue(op.getLhs(), resultType);
  if (matchPattern(adaptor.getRhs(), m_One()))
    return foldToResultValue(op.getLhs(), resultType);
  if (matchPattern(adaptor.getLhs(), m_One()))
    return foldToResultValue(op.getRhs(), resultType);
  return {};
}

static OpFoldResult foldWaveShiftIdentity(BinaryOp op,
                                          BinaryOp::FoldAdaptor adaptor,
                                          Type resultType) {
  switch (op.getKind()) {
  case BinaryKind::ShLI:
  case BinaryKind::ShRUI:
  case BinaryKind::ShRSI:
    if (matchPattern(adaptor.getRhs(), m_Zero()))
      return foldToResultValue(op.getLhs(), resultType);
    return {};
  default:
    return {};
  }
}

static OpFoldResult foldWaveAndOrIdentity(BinaryOp op,
                                          BinaryOp::FoldAdaptor adaptor,
                                          Type resultType) {
  if (OpFoldResult result = foldWaveAndIdentity(op, adaptor, resultType))
    return result;
  return foldWaveOrIdentity(op, adaptor, resultType);
}

static OpFoldResult foldWaveXOrIdentity(BinaryOp op,
                                        BinaryOp::FoldAdaptor adaptor,
                                        Type resultType, Attribute zero) {
  if (op.getKind() != BinaryKind::XOrI)
    return {};
  if (op.getLhs() == op.getRhs() && zero)
    return zero;
  if (matchPattern(adaptor.getRhs(), m_Zero()))
    return foldToResultValue(op.getLhs(), resultType);
  if (matchPattern(adaptor.getLhs(), m_Zero()))
    return foldToResultValue(op.getRhs(), resultType);
  return {};
}

static OpFoldResult foldWaveDivRemIdentity(BinaryOp op,
                                           BinaryOp::FoldAdaptor adaptor,
                                           Type resultType, Attribute zero) {
  switch (op.getKind()) {
  case BinaryKind::DivUI:
  case BinaryKind::DivSI:
    if (matchPattern(adaptor.getRhs(), m_One()))
      return foldToResultValue(op.getLhs(), resultType);
    return {};
  case BinaryKind::RemUI:
  case BinaryKind::RemSI:
    if (matchPattern(adaptor.getRhs(), m_One()) && zero)
      return zero;
    return {};
  default:
    return {};
  }
}

static OpFoldResult foldWaveBinaryIdentity(BinaryOp op,
                                           BinaryOp::FoldAdaptor adaptor,
                                           Type resultType, Attribute zero) {
  if (OpFoldResult result =
          foldWaveAddSubIdentity(op, adaptor, resultType, zero))
    return result;
  if (OpFoldResult result = foldWaveMulIdentity(op, adaptor, resultType))
    return result;
  if (OpFoldResult result = foldWaveShiftIdentity(op, adaptor, resultType))
    return result;
  if (OpFoldResult result = foldWaveAndOrIdentity(op, adaptor, resultType))
    return result;
  if (OpFoldResult result = foldWaveXOrIdentity(op, adaptor, resultType, zero))
    return result;
  return foldWaveDivRemIdentity(op, adaptor, resultType, zero);
}

OpFoldResult BinaryOp::fold(FoldAdaptor adaptor) {
  Type resultType = getType();
  Attribute zero = getZeroFoldAttr(getContext(), resultType);

  if (OpFoldResult result =
          foldWaveBinaryIdentity(*this, adaptor, resultType, zero))
    return result;

  if (Attribute folded = foldWaveBinaryConstants(*this, adaptor.getOperands()))
    return folded;
  return {};
}

LogicalResult BinaryOp::verify() {
  auto emit = [this](const Twine &msg) { return emitOpError(msg); };
  FailureOr<WaveBinaryOperandShape> lhs =
      classifyWaveBinaryOperand(getLhs().getType(), emit);
  FailureOr<WaveBinaryOperandShape> rhs =
      classifyWaveBinaryOperand(getRhs().getType(), emit);
  if (failed(lhs) || failed(rhs))
    return failure();
  if (lhs->elementType != rhs->elementType)
    return emit("operand element types must match");
  if (lhs->simdWidth && rhs->simdWidth && *lhs->simdWidth != *rhs->simdWidth)
    return emit("SIMD wave widths must match across operands");
  if (getOverflowFlags() != arith::IntegerOverflowFlags::none &&
      !supportsWaveBinaryOverflowFlags(getKind()))
    return emit("overflow flags require addi, subi, muli, or shli");
  std::optional<int64_t> resultSimd =
      lhs->simdWidth ? lhs->simdWidth : rhs->simdWidth;
  return verifyWaveBinaryResult(getResult().getType(), lhs->elementType,
                                resultSimd, emit);
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

OpFoldResult SelectOp::fold(FoldAdaptor adaptor) {
  if (getTrueValue() == getFalseValue())
    return getTrueValue();
  if (matchPattern(adaptor.getCondition(), m_One())) {
    if (Attribute trueValue = adaptor.getTrueValue())
      return trueValue;
    return getTrueValue();
  }
  if (matchPattern(adaptor.getCondition(), m_Zero())) {
    if (Attribute falseValue = adaptor.getFalseValue())
      return falseValue;
    return getFalseValue();
  }
  return {};
}

LogicalResult WhereOp::verify() {
  if (getConditions().empty())
    return emitOpError("requires at least one lane-mask condition");
  int64_t width = cast<MaskType>(getConditions().front().getType()).getWidth();
  if (llvm::any_of(getConditions(), [&](Value condition) {
        return cast<MaskType>(condition.getType()).getWidth() != width;
      }))
    return emitOpError("all conditions must have the same mask width");

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

void WhereOp::getSuccessorRegions(RegionBranchPoint point,
                                  SmallVectorImpl<RegionSuccessor> &regions) {
  bool hasElse = !getElseRegion().empty();
  if (point.isParent()) {
    regions.push_back(RegionSuccessor(&getThenRegion()));
    if (hasElse)
      regions.push_back(RegionSuccessor(&getElseRegion()));
    else if (getNumResults() == 0)
      regions.push_back(RegionSuccessor(getOperation()));
    return;
  }

  regions.push_back(RegionSuccessor(getOperation()));
}

OperandRange WhereOp::getEntrySuccessorOperands(RegionSuccessor successor) {
  return OperandRange((*this)->operand_end(), (*this)->operand_end());
}

ValueRange WhereOp::getSuccessorInputs(RegionSuccessor successor) {
  return successor.isOperation() ? ValueRange(getResults()) : ValueRange();
}

MutableOperandRange
YieldOp::getMutableSuccessorOperands(RegionSuccessor successor) {
  MutableOperandRange values = getValuesMutable();
  if (successor.isOperation())
    return values;
  return values.slice(0, 0);
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
  if (elementType.isIndex())
    return WaveCastShape{WaveCastElementKind::Int, 64, simdWidth, vectorLength};
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

static Type getWaveCastElementType(Type type) {
  if (SimdType simdType = dyn_cast<SimdType>(type))
    type = simdType.getElementType();
  if (VectorType vectorType = dyn_cast<VectorType>(type))
    type = vectorType.getElementType();
  return type;
}

static unsigned getWaveCastIntegerBits(Type type) {
  Type elementType = getWaveCastElementType(type);
  if (elementType.isIndex())
    return 64;
  return cast<IntegerType>(elementType).getWidth();
}

static llvm::RoundingMode getWaveCastRounding(WaveCastPolicy policy) {
  if (!policy.rounding)
    return llvm::APFloat::rmNearestTiesToEven;
  switch (policy.rounding.getValue()) {
  case CastRounding::RNE:
    return llvm::APFloat::rmNearestTiesToEven;
  case CastRounding::RTZ:
    return llvm::APFloat::rmTowardZero;
  case CastRounding::RTP:
    return llvm::APFloat::rmTowardPositive;
  case CastRounding::RTN:
    return llvm::APFloat::rmTowardNegative;
  }
  llvm_unreachable("unknown wave cast rounding mode");
}

static Attribute foldWaveIntConvert(CastOp op, WaveCastPolicy policy,
                                    ArrayRef<Attribute> operands) {
  unsigned sourceBits = getWaveCastIntegerBits(op.getSource().getType());
  unsigned resultBits = getWaveCastIntegerBits(op.getType());
  CastExtension extension = CastExtension::Sign;
  if (policy.extension)
    extension = policy.extension.getValue();
  return constFoldWaveCast<IntegerAttr, IntegerAttr>(
      operands, op.getType(),
      [sourceBits, resultBits, extension](const APInt &value,
                                          bool &castStatus) {
        if (resultBits > sourceBits) {
          if (extension == CastExtension::Zero)
            return value.zext(resultBits);
          return value.sext(resultBits);
        }
        if (resultBits < value.getBitWidth())
          return value.trunc(resultBits);
        return value;
      });
}

static Attribute foldWaveFpConvert(CastOp op, WaveCastPolicy policy,
                                   ArrayRef<Attribute> operands) {
  FloatType resultType = cast<FloatType>(getWaveCastElementType(op.getType()));
  const llvm::fltSemantics &semantics = resultType.getFloatSemantics();
  llvm::RoundingMode rounding = getWaveCastRounding(policy);
  return constFoldWaveCast<FloatAttr, FloatAttr>(
      operands, op.getType(),
      [&semantics, rounding](APFloat value, bool &castStatus) {
        bool losesInfo = false;
        APFloat::opStatus status =
            value.convert(semantics, rounding, &losesInfo);
        castStatus = status != APFloat::opInvalidOp;
        return value;
      });
}

static Attribute foldWaveIntToFp(CastOp op, WaveCastPolicy policy,
                                 ArrayRef<Attribute> operands) {
  FloatType resultType = cast<FloatType>(getWaveCastElementType(op.getType()));
  unsigned resultWidth = resultType.getWidth();
  const llvm::fltSemantics &semantics = resultType.getFloatSemantics();
  bool isSigned = policy.signedness.getValue() == CastSignedness::Signed;
  llvm::RoundingMode rounding = getWaveCastRounding(policy);
  return constFoldWaveCast<IntegerAttr, FloatAttr>(
      operands, op.getType(),
      [&semantics, resultWidth, isSigned, rounding](const APInt &value,
                                                    bool &castStatus) {
        APFloat result(semantics, APInt::getZero(resultWidth));
        result.convertFromAPInt(value, isSigned, rounding);
        return result;
      });
}

static Attribute foldWaveFpToInt(CastOp op, WaveCastPolicy policy,
                                 ArrayRef<Attribute> operands) {
  unsigned resultBits = getWaveCastIntegerBits(op.getType());
  bool isUnsigned = policy.signedness.getValue() == CastSignedness::Unsigned;
  return constFoldWaveCast<FloatAttr, IntegerAttr>(
      operands, op.getType(),
      [resultBits, isUnsigned](const APFloat &value, bool &castStatus) {
        bool ignored;
        APSInt result(resultBits, isUnsigned);
        castStatus =
            APFloat::opInvalidOp !=
            value.convertToInteger(result, APFloat::rmTowardZero, &ignored);
        return result;
      });
}

void CastOp::inferResultRanges(ArrayRef<ConstantIntRanges> argRanges,
                               SetIntRangeFn setResultRange) {
  if (getKind() != CastKind::IntConvert || argRanges.empty())
    return;

  unsigned sourceBits = getWaveCastIntegerBits(getSource().getType());
  unsigned resultBits = getWaveCastIntegerBits(getType());
  ConstantIntRanges sourceRange =
      argRanges.front().smin().getBitWidth() == sourceBits
          ? argRanges.front()
          : ConstantIntRanges::maxRange(sourceBits);
  if (resultBits < sourceBits) {
    setResultRange(getResult(), intrange::truncRange(sourceRange, resultBits));
    return;
  }
  if (resultBits == sourceBits) {
    setResultRange(getResult(), sourceRange);
    return;
  }

  FailureOr<WaveCastPolicy> policy = getWaveCastPolicy(*this);
  if (failed(policy) || !policy->extension)
    return;
  if (policy->extension.getValue() == CastExtension::Zero)
    setResultRange(getResult(), intrange::extUIRange(sourceRange, resultBits));
  else
    setResultRange(getResult(), intrange::extSIRange(sourceRange, resultBits));
}

OpFoldResult CastOp::fold(FoldAdaptor adaptor) {
  if (getSource().getType() == getType())
    return getSource();

  FailureOr<WaveCastPolicy> policy = getWaveCastPolicy(*this);
  if (failed(policy))
    return {};

  switch (getKind()) {
  case CastKind::FpConvert:
    return foldWaveFpConvert(*this, *policy, adaptor.getOperands());
  case CastKind::IntConvert:
    return foldWaveIntConvert(*this, *policy, adaptor.getOperands());
  case CastKind::IntToFp:
    return foldWaveIntToFp(*this, *policy, adaptor.getOperands());
  case CastKind::FpToInt:
    return foldWaveFpToInt(*this, *policy, adaptor.getOperands());
  }
  return {};
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

namespace {
struct WavePtrCastShape {
  PtrType ptr;
  std::optional<int64_t> simdWidth;
};
} // namespace

static FailureOr<WavePtrCastShape> classifyWavePtrCastType(
    Type type, function_ref<InFlightDiagnostic(const Twine &)> emitError) {
  std::optional<int64_t> simdWidth;
  if (SimdType simdType = dyn_cast<SimdType>(type)) {
    simdWidth = simdType.getWidth();
    type = simdType.getElementType();
  }
  PtrType ptr = dyn_cast<PtrType>(type);
  if (!ptr)
    return emitError(
        "ptr_cast type must be a wave pointer or SIMD of pointers");
  return WavePtrCastShape{ptr, simdWidth};
}

LogicalResult PtrCastOp::verify() {
  auto emit = [this](const Twine &msg) { return emitOpError(msg); };
  FailureOr<WavePtrCastShape> source =
      classifyWavePtrCastType(getSource().getType(), emit);
  FailureOr<WavePtrCastShape> result =
      classifyWavePtrCastType(getResult().getType(), emit);
  if (failed(source) || failed(result))
    return failure();
  if (source->simdWidth.has_value() != result->simdWidth.has_value())
    return emitOpError("source and result must both be scalar or both be SIMD");
  if (source->simdWidth && *source->simdWidth != *result->simdWidth)
    return emitOpError("source and result SIMD widths must match");
  if (source->ptr.getAddressSpace() != result->ptr.getAddressSpace())
    return emitOpError("source and result address spaces must match");
  return success();
}

static VectorType getWaveVectorPayloadType(Type type) {
  if (SimdType simdType = dyn_cast<SimdType>(type))
    return cast<VectorType>(simdType.getElementType());
  return cast<VectorType>(type);
}

static Type getWavePayloadType(Type type) {
  if (SimdType simdType = dyn_cast<SimdType>(type))
    return simdType.getElementType();
  return type;
}

static Type getWavePayloadElementType(Type type) {
  type = getWavePayloadType(type);
  if (VectorType vectorType = dyn_cast<VectorType>(type))
    return vectorType.getElementType();
  return type;
}

static int64_t getWavePayloadElementCount(Type type) {
  type = getWavePayloadType(type);
  if (VectorType vectorType = dyn_cast<VectorType>(type))
    return vectorType.getNumElements();
  return 1;
}

static LogicalResult verifyPackInputVector(PackOp op, Type inputType) {
  if (VectorType inputVector =
          dyn_cast<VectorType>(getWavePayloadType(inputType)))
    if (inputVector.getRank() != 1)
      return op.emitOpError("input vector chunks must be 1-D");
  return success();
}

static LogicalResult verifyPackSimdResult(PackOp op,
                                          std::optional<int64_t> inputWidth) {
  Type resultType = op.getResult().getType();
  if (SimdType resultSimd = dyn_cast<SimdType>(resultType)) {
    if (!inputWidth)
      return op.emitOpError("result must not be SIMD when inputs are scalar");
    if (resultSimd.getWidth() != *inputWidth)
      return op.emitOpError("result SIMD width must match inputs");
    return success();
  }
  if (inputWidth)
    return op.emitOpError("result must be SIMD when inputs are SIMD");
  return success();
}

static LogicalResult verifyPackPayload(PackOp op, Type inputElementType,
                                       int64_t inputElementCount) {
  VectorType vectorType = getWaveVectorPayloadType(op.getResult().getType());
  if (vectorType.getElementType() != inputElementType)
    return op.emitOpError("result vector element type must match inputs");
  if (vectorType.getNumElements() !=
      inputElementCount * static_cast<int64_t>(op.getInputs().size()))
    return op.emitOpError(
        "input element count must match result vector length");
  return success();
}

LogicalResult PackOp::verify() {
  OperandRange inputs = getInputs();
  if (inputs.empty())
    return emitOpError("requires at least one input");

  Type inputType = inputs.front().getType();
  Type inputElementType = getWavePayloadElementType(inputType);
  int64_t inputElementCount = getWavePayloadElementCount(inputType);
  std::optional<int64_t> inputSimdWidth;
  if (SimdType inputSimd = dyn_cast<SimdType>(inputType)) {
    inputSimdWidth = inputSimd.getWidth();
  }
  if (failed(verifyPackInputVector(*this, inputType)))
    return failure();
  if (failed(verifyPackSimdResult(*this, inputSimdWidth)))
    return failure();
  return verifyPackPayload(*this, inputElementType, inputElementCount);
}

OpFoldResult PackOp::fold(FoldAdaptor) {
  Value source;
  int64_t inputElementCount =
      getWavePayloadElementCount(getInputs().front().getType());
  for (auto [index, input] : llvm::enumerate(getInputs())) {
    ExtractOp extract = input.getDefiningOp<ExtractOp>();
    uint64_t expectedIndex =
        static_cast<uint64_t>(index) * static_cast<uint64_t>(inputElementCount);
    if (!extract || extract.getIndex() != expectedIndex)
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

namespace {
struct PackExtractSliceMatch {
  Value source;
  uint64_t startIndex;
};

struct PackLoopResultMatch {
  scf::ForOp loop;
  unsigned startIndex;
};

struct PackedLoopReplacement {
  SmallVector<Value> replacements;
  Value packedResult;
};

static unsigned getPackInputCount(PackOp op) {
  return static_cast<unsigned>(op.getInputs().size());
}

static LogicalResult verifyPackExtractSlicePayload(OperandRange inputs,
                                                   VectorType resultVector) {
  if (inputs.empty())
    return failure();
  if (resultVector.getNumElements() != static_cast<int64_t>(inputs.size()))
    return failure();
  if (getWavePayloadElementCount(inputs.front().getType()) != 1)
    return failure();
  if (getWavePayloadElementType(inputs.front().getType()) !=
      resultVector.getElementType())
    return failure();
  return success();
}

static LogicalResult verifyPackScalarPayload(PackOp op) {
  OperandRange inputs = op.getInputs();
  if (inputs.size() < 2)
    return failure();
  VectorType resultVector = getWaveVectorPayloadType(op.getResult().getType());
  if (resultVector.getNumElements() != static_cast<int64_t>(inputs.size()))
    return failure();
  if (getWavePayloadElementCount(inputs.front().getType()) != 1)
    return failure();
  if (getWavePayloadElementType(inputs.front().getType()) !=
      resultVector.getElementType())
    return failure();
  return success();
}

static FailureOr<PackLoopResultMatch> matchFirstPackLoopResult(PackOp op) {
  OpResult firstResult = dyn_cast<OpResult>(op.getInputs().front());
  if (!firstResult)
    return failure();
  scf::ForOp loop = dyn_cast<scf::ForOp>(firstResult.getOwner());
  if (!loop || loop->getBlock() != op->getBlock() || !loop->isBeforeInBlock(op))
    return failure();
  return PackLoopResultMatch{loop, firstResult.getResultNumber()};
}

static LogicalResult verifyPackLoopResultSlice(PackOp op,
                                               PackLoopResultMatch match) {
  unsigned inputCount = getPackInputCount(op);
  if (match.startIndex + inputCount > match.loop->getNumResults())
    return failure();

  for (auto [offset, input] : llvm::enumerate(op.getInputs())) {
    OpResult result = dyn_cast<OpResult>(input);
    if (!result || result.getOwner() != match.loop)
      return failure();
    if (result.getResultNumber() != match.startIndex + offset)
      return failure();
  }
  return success();
}

static FailureOr<PackLoopResultMatch> matchPackLoopResults(PackOp op) {
  if (failed(verifyPackScalarPayload(op)))
    return failure();

  FailureOr<PackLoopResultMatch> match = matchFirstPackLoopResult(op);
  if (failed(match))
    return failure();
  if (failed(verifyPackLoopResultSlice(op, *match)))
    return failure();
  return *match;
}

static void copyScfForAttrs(scf::ForOp src, scf::ForOp dst) {
  for (NamedAttribute attr : src->getAttrs())
    dst->setAttr(attr.getName(), attr.getValue());
}

static void appendValues(ValueRange values, unsigned start, unsigned count,
                         SmallVectorImpl<Value> &out) {
  for (unsigned index : llvm::seq(start, start + count))
    out.push_back(values[index]);
}

static SmallVector<Value> buildPackedLoopInitArgs(PatternRewriter &rewriter,
                                                  PackOp op,
                                                  PackLoopResultMatch match) {
  scf::ForOp loop = match.loop;
  unsigned inputCount = getPackInputCount(op);
  ValueRange oldInitArgs = loop.getInitArgs();
  SmallVector<Value> newInitArgs;
  newInitArgs.reserve(oldInitArgs.size() - inputCount + 1);
  for (unsigned index = 0; index < oldInitArgs.size(); ++index) {
    if (index != match.startIndex) {
      newInitArgs.push_back(oldInitArgs[index]);
      continue;
    }
    SmallVector<Value> packedInputs;
    appendValues(oldInitArgs, index, inputCount, packedInputs);
    Value packed =
        PackOp::create(rewriter, op.getLoc(), op.getType(), packedInputs)
            .getResult();
    newInitArgs.push_back(packed);
    index += inputCount - 1;
  }
  return newInitArgs;
}

static FailureOr<PackExtractSliceMatch> matchPackFirstExtract(PackOp op) {
  ExtractOp firstExtract = op.getInputs().front().getDefiningOp<ExtractOp>();
  if (!firstExtract)
    return failure();

  Value source = firstExtract.getSource();
  uint64_t startIndex = firstExtract.getIndex();
  if (source.getType() == op.getResult().getType() && startIndex == 0)
    return failure();

  return PackExtractSliceMatch{source, startIndex};
}

static LogicalResult verifyPackExtractSliceBounds(Value source,
                                                  uint64_t startIndex,
                                                  VectorType resultVector) {
  VectorType sourceVector = getWaveVectorPayloadType(source.getType());
  uint64_t resultElementCount =
      static_cast<uint64_t>(resultVector.getNumElements());
  uint64_t sourceElementCount =
      static_cast<uint64_t>(sourceVector.getNumElements());
  if (startIndex + resultElementCount > sourceElementCount)
    return failure();
  return success();
}

static LogicalResult verifyPackExtractSliceInputs(OperandRange inputs,
                                                  Value source,
                                                  uint64_t startIndex) {
  for (auto [offset, input] : llvm::enumerate(inputs)) {
    ExtractOp extract = input.getDefiningOp<ExtractOp>();
    if (!extract || extract.getSource() != source)
      return failure();
    if (extract.getIndex() != startIndex + static_cast<uint64_t>(offset))
      return failure();
  }
  return success();
}

static void mapPackedLoopArgs(PatternRewriter &rewriter, PackOp op,
                              PackLoopResultMatch match, scf::ForOp newLoop,
                              IRMapping &map) {
  scf::ForOp oldLoop = match.loop;
  unsigned inputCount = getPackInputCount(op);
  map.map(oldLoop.getInductionVar(), newLoop.getInductionVar());

  unsigned newIndex = 0;
  for (unsigned oldIndex = 0; oldIndex < oldLoop->getNumResults(); ++oldIndex) {
    if (oldIndex != match.startIndex) {
      map.map(oldLoop.getRegionIterArgs()[oldIndex],
              newLoop.getRegionIterArgs()[newIndex++]);
      continue;
    }

    Value packedArg = newLoop.getRegionIterArgs()[newIndex++];
    for (unsigned offset : llvm::seq(inputCount)) {
      Value oldArg = oldLoop.getRegionIterArgs()[oldIndex + offset];
      Value extracted = ExtractOp::create(
          rewriter, op.getLoc(), oldArg.getType(), packedArg,
          rewriter.getI64IntegerAttr(static_cast<int64_t>(offset)));
      map.map(oldArg, extracted);
    }
    oldIndex += inputCount - 1;
  }
}

static void clonePackedLoopBody(PatternRewriter &rewriter, PackOp op,
                                PackLoopResultMatch match, scf::ForOp newLoop) {
  Block &oldBody = *match.loop.getBody();
  IRMapping map;
  rewriter.setInsertionPointToStart(newLoop.getBody());
  mapPackedLoopArgs(rewriter, op, match, newLoop, map);

  for (Operation &bodyOp : oldBody.without_terminator())
    rewriter.clone(bodyOp, map);

  scf::YieldOp oldYield = cast<scf::YieldOp>(oldBody.getTerminator());
  SmallVector<Value> newYieldOperands;
  unsigned inputCount = getPackInputCount(op);
  for (unsigned index = 0; index < oldYield.getNumOperands(); ++index) {
    if (index != match.startIndex) {
      newYieldOperands.push_back(
          map.lookupOrDefault(oldYield.getOperand(index)));
      continue;
    }
    SmallVector<Value> packedInputs;
    for (unsigned offset : llvm::seq(inputCount))
      packedInputs.push_back(
          map.lookupOrDefault(oldYield.getOperand(index + offset)));
    Value packed =
        PackOp::create(rewriter, oldYield.getLoc(), op.getType(), packedInputs)
            .getResult();
    newYieldOperands.push_back(packed);
    index += inputCount - 1;
  }
  scf::YieldOp::create(rewriter, oldYield.getLoc(), newYieldOperands);
}

static PackedLoopReplacement
buildPackedLoopReplacements(PatternRewriter &rewriter, PackOp op,
                            PackLoopResultMatch match, scf::ForOp newLoop) {
  unsigned inputCount = getPackInputCount(op);
  PackedLoopReplacement replacement;
  replacement.replacements.reserve(match.loop->getNumResults());
  unsigned newIndex = 0;
  for (unsigned oldIndex = 0; oldIndex < match.loop->getNumResults();
       ++oldIndex) {
    if (oldIndex != match.startIndex) {
      replacement.replacements.push_back(newLoop.getResult(newIndex++));
      continue;
    }

    Value packedResult = newLoop.getResult(newIndex++);
    replacement.packedResult = packedResult;
    for (unsigned offset : llvm::seq(inputCount)) {
      Value oldResult = match.loop.getResult(oldIndex + offset);
      Value extracted = ExtractOp::create(
          rewriter, op.getLoc(), oldResult.getType(), packedResult,
          rewriter.getI64IntegerAttr(static_cast<int64_t>(offset)));
      replacement.replacements.push_back(extracted);
    }
    oldIndex += inputCount - 1;
  }
  return replacement;
}

struct PackContiguousExtractsToSlice : OpRewritePattern<PackOp> {
  using OpRewritePattern::OpRewritePattern;

  LogicalResult matchAndRewrite(PackOp op,
                                PatternRewriter &rewriter) const override {
    OperandRange inputs = op.getInputs();
    VectorType resultVector =
        getWaveVectorPayloadType(op.getResult().getType());
    if (failed(verifyPackExtractSlicePayload(inputs, resultVector)))
      return failure();

    FailureOr<PackExtractSliceMatch> match = matchPackFirstExtract(op);
    if (failed(match))
      return failure();

    if (failed(verifyPackExtractSliceBounds(match->source, match->startIndex,
                                            resultVector)))
      return failure();
    if (failed(verifyPackExtractSliceInputs(inputs, match->source,
                                            match->startIndex)))
      return failure();

    ExtractOp slice = ExtractOp::create(
        rewriter, op.getLoc(), op.getResult().getType(), match->source,
        rewriter.getI64IntegerAttr(static_cast<int64_t>(match->startIndex)));
    rewriter.replaceOp(op, slice.getResult());
    return success();
  }
};

struct PackLoopResultsToLoopCarry : OpRewritePattern<PackOp> {
  using OpRewritePattern::OpRewritePattern;

  LogicalResult matchAndRewrite(PackOp op,
                                PatternRewriter &rewriter) const override {
    FailureOr<PackLoopResultMatch> match = matchPackLoopResults(op);
    if (failed(match))
      return failure();

    rewriter.setInsertionPoint(match->loop);
    SmallVector<Value> newInitArgs =
        buildPackedLoopInitArgs(rewriter, op, *match);
    scf::ForOp newLoop = scf::ForOp::create(
        rewriter, match->loop.getLoc(), match->loop.getLowerBound(),
        match->loop.getUpperBound(), match->loop.getStep(), newInitArgs);
    copyScfForAttrs(match->loop, newLoop);
    clonePackedLoopBody(rewriter, op, *match, newLoop);

    rewriter.setInsertionPointAfter(newLoop);
    PackedLoopReplacement replacement =
        buildPackedLoopReplacements(rewriter, op, *match, newLoop);
    rewriter.replaceOp(match->loop, replacement.replacements);
    rewriter.replaceOp(op, replacement.packedResult);
    return success();
  }
};
} // namespace

void PackOp::getCanonicalizationPatterns(RewritePatternSet &patterns,
                                         MLIRContext *context) {
  patterns.add<PackContiguousExtractsToSlice, PackLoopResultsToLoopCarry>(
      context);
}

static FailureOr<Type>
getExtractResultPayloadType(ExtractOp op, std::optional<int64_t> simdWidth) {
  Type resultType = op.getResult().getType();
  if (!simdWidth)
    return resultType;

  SimdType resultSimd = dyn_cast<SimdType>(resultType);
  if (!resultSimd)
    return op.emitOpError("result must be SIMD when source is SIMD");
  if (resultSimd.getWidth() != *simdWidth)
    return op.emitOpError("result SIMD width must match source");
  return resultSimd.getElementType();
}

static LogicalResult verifyExtractVectorResult(ExtractOp op,
                                               VectorType sourceVector,
                                               VectorType resultVector,
                                               int64_t index) {
  if (resultVector.getRank() != 1)
    return op.emitOpError("result vector slice must be 1-D");
  if (resultVector.getElementType() != sourceVector.getElementType())
    return op.emitOpError(
        "result vector element type must match source vector element");
  if (index + resultVector.getNumElements() > sourceVector.getNumElements())
    return op.emitOpError("slice must be in source vector bounds");
  return success();
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

  FailureOr<Type> resultPayloadType =
      getExtractResultPayloadType(*this, simdWidth);
  if (failed(resultPayloadType))
    return failure();

  if (VectorType resultVector = dyn_cast<VectorType>(*resultPayloadType))
    return verifyExtractVectorResult(*this, vectorType, resultVector, index);

  if (*resultPayloadType != vectorType.getElementType())
    return emitOpError("result type must match source vector element");
  return success();
}

OpFoldResult ExtractOp::fold(FoldAdaptor) {
  if (getIndex() == 0 && getSource().getType() == getResult().getType())
    return getSource();

  PackOp pack = getSource().getDefiningOp<PackOp>();
  if (!pack)
    return {};
  uint64_t index = getIndex();
  int64_t inputElementCount =
      getWavePayloadElementCount(pack.getInputs().front().getType());
  if (index % inputElementCount != 0)
    return {};
  uint64_t inputIndex = index / inputElementCount;
  if (inputIndex >= pack.getInputs().size())
    return {};
  Value input = pack.getInputs()[inputIndex];
  if (input.getType() != getResult().getType())
    return {};
  return input;
}

namespace {
struct ExtractFromPackChunk : OpRewritePattern<ExtractOp> {
  using OpRewritePattern::OpRewritePattern;

  LogicalResult matchAndRewrite(ExtractOp op,
                                PatternRewriter &rewriter) const override {
    PackOp pack = op.getSource().getDefiningOp<PackOp>();
    if (!pack)
      return failure();

    int64_t inputElements =
        getWavePayloadElementCount(pack.getInputs().front().getType());
    int64_t resultElements = getWavePayloadElementCount(op.getType());
    int64_t inputIndex = op.getIndex() / inputElements;
    int64_t localIndex = op.getIndex() % inputElements;
    if (inputIndex >= static_cast<int64_t>(pack.getInputs().size()) ||
        localIndex + resultElements > inputElements)
      return failure();

    Value input = pack.getInputs()[inputIndex];
    if (localIndex == 0 && input.getType() == op.getType()) {
      rewriter.replaceOp(op, input);
      return success();
    }
    if (!isa<VectorType>(getWavePayloadType(input.getType())))
      return failure();
    rewriter.replaceOpWithNewOp<ExtractOp>(op, op.getType(), input, localIndex);
    return success();
  }
};
} // namespace

void ExtractOp::getCanonicalizationPatterns(RewritePatternSet &patterns,
                                            MLIRContext *context) {
  patterns.add<ExtractFromPackChunk>(context);
}

static bool isWavePackedF16Type(Type type) {
  VectorType vectorType = dyn_cast<VectorType>(type);
  return vectorType && vectorType.getRank() == 1 && !vectorType.isScalable() &&
         llvm::isPowerOf2_64(vectorType.getNumElements()) &&
         vectorType.getElementType().isF16();
}

static bool isWavePackedF32Type(Type type) {
  VectorType vectorType = dyn_cast<VectorType>(type);
  return vectorType && vectorType.getRank() == 1 && !vectorType.isScalable() &&
         vectorType.getNumElements() >= 2 &&
         llvm::isPowerOf2_64(vectorType.getNumElements()) &&
         vectorType.getElementType().isF32();
}

static bool isAllowedWaveFloatElement(Type elementType, bool allowScalarF16,
                                      bool allowPackedF16,
                                      bool allowPackedF32 = false) {
  if (elementType.isF32())
    return true;
  if (allowScalarF16 && elementType.isF16())
    return true;
  if (allowPackedF16 && isWavePackedF16Type(elementType))
    return true;
  return allowPackedF32 && isWavePackedF32Type(elementType);
}

static const char *getWaveFloatElementError(bool allowScalarF16,
                                            bool allowPackedF16,
                                            bool allowPackedF32 = false) {
  if (allowScalarF16 && allowPackedF16 && allowPackedF32)
    return "SIMD element type must be f32, f16, vector<2^nxf16>, or "
           "vector<2^nxf32> with at least two f32 elements";
  if (allowScalarF16 && allowPackedF16)
    return "SIMD element type must be f32, f16, or vector<2^nxf16>";
  if (allowPackedF16 && allowPackedF32)
    return "SIMD element type must be f32, vector<2^nxf16>, or "
           "vector<2^nxf32> with at least two f32 elements";
  if (allowPackedF32)
    return "SIMD element type must be f32 or vector<2^nxf32> with at least "
           "two f32 elements";
  if (allowPackedF16)
    return "SIMD element type must be f32 or vector<2^nxf16>";
  return "SIMD element type must be f32";
}

static LogicalResult
verifyWaveFloatSimd(Type type, bool allowScalarF16, bool allowPackedF16,
                    bool allowPackedF32,
                    function_ref<InFlightDiagnostic(const Twine &)> emitError) {
  SimdType simdType = dyn_cast<SimdType>(type);
  if (!simdType)
    return emitError("operand must be !wave.simd<..., W>");
  Type elementType = simdType.getElementType();
  if (!isAllowedWaveFloatElement(elementType, allowScalarF16, allowPackedF16,
                                 allowPackedF32))
    return emitError(getWaveFloatElementError(allowScalarF16, allowPackedF16,
                                              allowPackedF32));
  return success();
}

static LogicalResult verifyWaveFloatSimdBinary(Operation *op, Type lhsTy,
                                               Type rhsTy, Type resultTy,
                                               bool allowScalarF16,
                                               bool allowPackedF16,
                                               bool allowPackedF32 = false) {
  auto emit = [op](const Twine &msg) { return op->emitOpError(msg); };
  if (lhsTy != rhsTy || lhsTy != resultTy)
    return emit("operands and result must have the same SIMD type");
  return verifyWaveFloatSimd(lhsTy, allowScalarF16, allowPackedF16,
                             allowPackedF32, emit);
}

static LogicalResult verifyWaveFloatSimdTernary(Operation *op, Type lhsTy,
                                                Type rhsTy, Type accTy,
                                                Type resultTy,
                                                bool allowPackedF32 = false) {
  auto emit = [op](const Twine &msg) { return op->emitOpError(msg); };
  if (lhsTy != rhsTy || lhsTy != accTy || lhsTy != resultTy)
    return emit("operands and result must have the same SIMD type");
  return verifyWaveFloatSimd(lhsTy, /*allowScalarF16=*/true,
                             /*allowPackedF16=*/true, allowPackedF32, emit);
}

static LogicalResult verifyWaveFloatSimdUnary(Operation *op, Type sourceTy,
                                              Type resultTy) {
  auto emit = [op](const Twine &msg) { return op->emitOpError(msg); };
  if (sourceTy != resultTy)
    return emit("operand and result must have the same SIMD type");
  return verifyWaveFloatSimd(sourceTy, /*allowScalarF16=*/false,
                             /*allowPackedF16=*/false,
                             /*allowPackedF32=*/false, emit);
}

LogicalResult FAddOp::verify() {
  return verifyWaveFloatSimdBinary(getOperation(), getLhs().getType(),
                                   getRhs().getType(), getResult().getType(),
                                   /*allowScalarF16=*/true,
                                   /*allowPackedF16=*/true,
                                   /*allowPackedF32=*/true);
}

LogicalResult FSubOp::verify() {
  return verifyWaveFloatSimdBinary(getOperation(), getLhs().getType(),
                                   getRhs().getType(), getResult().getType(),
                                   /*allowScalarF16=*/false,
                                   /*allowPackedF16=*/false,
                                   /*allowPackedF32=*/true);
}

LogicalResult FMulOp::verify() {
  return verifyWaveFloatSimdBinary(getOperation(), getLhs().getType(),
                                   getRhs().getType(), getResult().getType(),
                                   /*allowScalarF16=*/true,
                                   /*allowPackedF16=*/true,
                                   /*allowPackedF32=*/true);
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
                                    getResult().getType(),
                                    /*allowPackedF32=*/true);
}

static bool hasContract(arith::FastMathFlags flags) {
  return arith::bitEnumContainsAll(flags, arith::FastMathFlags::contract);
}

bool mlir::wave::hasAddressArithmeticNoOverflowAssumption(Operation *op) {
  for (Operation *scope = op; scope; scope = scope->getParentOp())
    if (scope->hasAttr("wave.address_arithmetic_no_overflow"))
      return true;
  return false;
}

bool mlir::wave::hasAddressArithmeticNoOverflowAssumption(Value value) {
  if (Operation *definingOp = value.getDefiningOp())
    return hasAddressArithmeticNoOverflowAssumption(definingOp);
  BlockArgument argument = dyn_cast<BlockArgument>(value);
  return argument && hasAddressArithmeticNoOverflowAssumption(
                         argument.getOwner()->getParentOp());
}

namespace {
struct FuseFAddFMul final : OpRewritePattern<FAddOp> {
  using OpRewritePattern::OpRewritePattern;

  LogicalResult matchAndRewrite(FAddOp op,
                                PatternRewriter &rewriter) const override {
    if (!hasContract(op.getFastmath()))
      return failure();

    Value acc;
    FMulOp mul;
    if ((mul = op.getLhs().getDefiningOp<FMulOp>()))
      acc = op.getRhs();
    else if ((mul = op.getRhs().getDefiningOp<FMulOp>()))
      acc = op.getLhs();
    else
      return failure();

    if (!hasContract(mul.getFastmath()))
      return failure();

    arith::FastMathFlags flags = op.getFastmath() & mul.getFastmath();
    arith::FastMathFlagsAttr flagsAttr =
        arith::FastMathFlagsAttr::get(op.getContext(), flags);
    rewriter.replaceOpWithNewOp<FmaOp>(op, op.getType(), mul.getLhs(),
                                       mul.getRhs(), acc, flagsAttr);
    return success();
  }
};
} // namespace

void FAddOp::getCanonicalizationPatterns(RewritePatternSet &patterns,
                                         MLIRContext *context) {
  patterns.add<FuseFAddFMul>(context);
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

static unsigned waveBinaryElementWidth(Type type) {
  if (auto simd = dyn_cast<SimdType>(type))
    type = simd.getElementType();
  unsigned bits = ConstantIntRanges::getStorageBitwidth(type);
  return bits == 0 ? 64 : bits;
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

static intrange::OverflowFlags
convertWaveOverflowFlags(arith::IntegerOverflowFlags flags) {
  intrange::OverflowFlags result = intrange::OverflowFlags::None;
  if (bitEnumContainsAny(flags, arith::IntegerOverflowFlags::nsw))
    result |= intrange::OverflowFlags::Nsw;
  if (bitEnumContainsAny(flags, arith::IntegerOverflowFlags::nuw))
    result |= intrange::OverflowFlags::Nuw;
  return result;
}

using WaveBinaryRangeInferFn =
    ConstantIntRanges (*)(ArrayRef<ConstantIntRanges>, intrange::OverflowFlags);

struct WaveBinaryRangeRule {
  BinaryKind kind;
  WaveBinaryRangeInferFn infer;
};

static ConstantIntRanges
inferWaveBinaryResultRange(BinaryKind kind, ArrayRef<ConstantIntRanges> ranges,
                           unsigned bits,
                           arith::IntegerOverflowFlags overflowFlags) {
  intrange::OverflowFlags intrangeFlags =
      convertWaveOverflowFlags(overflowFlags);
  static constexpr std::array<WaveBinaryRangeRule, 13> rules{{
      {BinaryKind::AddI, mlir::intrange::inferAdd},
      {BinaryKind::SubI, mlir::intrange::inferSub},
      {BinaryKind::MulI, mlir::intrange::inferMul},
      {BinaryKind::ShLI, mlir::intrange::inferShl},
      {BinaryKind::ShRUI,
       [](ArrayRef<ConstantIntRanges> ranges, intrange::OverflowFlags) {
         return mlir::intrange::inferShrU(ranges);
       }},
      {BinaryKind::ShRSI,
       [](ArrayRef<ConstantIntRanges> ranges, intrange::OverflowFlags) {
         return mlir::intrange::inferShrS(ranges);
       }},
      {BinaryKind::AndI,
       [](ArrayRef<ConstantIntRanges> ranges, intrange::OverflowFlags) {
         return mlir::intrange::inferAnd(ranges);
       }},
      {BinaryKind::OrI,
       [](ArrayRef<ConstantIntRanges> ranges, intrange::OverflowFlags) {
         return mlir::intrange::inferOr(ranges);
       }},
      {BinaryKind::XOrI,
       [](ArrayRef<ConstantIntRanges> ranges, intrange::OverflowFlags) {
         return mlir::intrange::inferXor(ranges);
       }},
      {BinaryKind::DivUI,
       [](ArrayRef<ConstantIntRanges> ranges, intrange::OverflowFlags) {
         return mlir::intrange::inferDivU(ranges);
       }},
      {BinaryKind::DivSI,
       [](ArrayRef<ConstantIntRanges> ranges, intrange::OverflowFlags) {
         return mlir::intrange::inferDivS(ranges);
       }},
      {BinaryKind::RemUI,
       [](ArrayRef<ConstantIntRanges> ranges, intrange::OverflowFlags) {
         return mlir::intrange::inferRemU(ranges);
       }},
      {BinaryKind::RemSI,
       [](ArrayRef<ConstantIntRanges> ranges, intrange::OverflowFlags) {
         return mlir::intrange::inferRemS(ranges);
       }},
  }};
  for (const WaveBinaryRangeRule &rule : rules)
    if (rule.kind == kind)
      return rule.infer(ranges, intrangeFlags);
  return ConstantIntRanges::maxRange(bits);
}

LogicalResult URecipOp::verify() {
  Type sourceType = getSource().getType();
  Type resultType = getResult().getType();
  if (sourceType != resultType)
    return emitOpError("source and result types must match");
  Type elementType = sourceType;
  if (auto simd = dyn_cast<SimdType>(sourceType))
    elementType = simd.getElementType();
  IntegerType integerType = dyn_cast<IntegerType>(elementType);
  if (!integerType || integerType.getWidth() != 32)
    return emitOpError("requires i32 or !wave.simd<i32, W>");
  return success();
}

LogicalResult CtzOp::verify() {
  Type sourceType = getSource().getType();
  Type resultType = getResult().getType();
  if (sourceType != resultType)
    return emitOpError("source and result types must match");
  Type elementType = sourceType;
  if (auto simd = dyn_cast<SimdType>(sourceType))
    elementType = simd.getElementType();
  if (elementType.isIndex())
    return success();
  IntegerType integerType = dyn_cast<IntegerType>(elementType);
  if (!integerType ||
      (integerType.getWidth() != 32 && integerType.getWidth() != 64))
    return emitOpError("requires i32, i64, index, or matching SIMD type");
  return success();
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

static bool isPredicateImplied(sym::Store &store, sym::PredHandle pred,
                               ArrayRef<sym::PredHandle> assumptions) {
  if (llvm::is_contained(assumptions, pred))
    return true;
  return sym::checkPredicate(store, pred, assumptions) ==
         sym::CheckResult::True;
}

void mlir::wave::appendRangeAndAssumePredicates(
    sym::Store &store, Value binding, StringRef name,
    const ConstantIntRanges &range,
    SmallVectorImpl<sym::PredHandle> &assumptions) {
  appendAssumePredicates(store, binding, name, assumptions);
  std::optional<sym::PredHandle> assumption =
      buildIndexExprRangeAssumption(store, name, range);
  if (assumption && !isPredicateImplied(store, *assumption, assumptions))
    assumptions.push_back(*assumption);
}

static SmallVector<sym::PredHandle, 4> getPredicateHandles(ArrayAttr attrs) {
  SmallVector<sym::PredHandle, 4> handles;
  handles.reserve(attrs.size());
  for (Attribute attr : attrs)
    handles.push_back(cast<PredAttr>(attr).getValue());
  return handles;
}

static void appendUniquePredicate(SmallVectorImpl<sym::PredHandle> &predicates,
                                  sym::PredHandle pred) {
  if (!llvm::is_contained(predicates, pred))
    predicates.push_back(pred);
}

static bool isAlwaysTruePredicate(sym::PredHandle pred) {
  return sym::PredView(pred).getKind() == sym::PredKind::True;
}

void mlir::wave::appendIndexExprPredicates(
    IndexExprOp op, SmallVectorImpl<sym::PredHandle> &assumptions) {
  for (sym::PredHandle pred : getPredicateHandles(op.getAssumptionsAttr()))
    appendUniquePredicate(assumptions, pred);
}

ArrayAttr
mlir::wave::getIndexExprPredArrayAttr(MLIRContext *ctx,
                                      ArrayRef<sym::PredHandle> assumptions) {
  SmallVector<sym::PredHandle, 4> unique;
  for (sym::PredHandle pred : assumptions)
    if (!isAlwaysTruePredicate(pred))
      appendUniquePredicate(unique, pred);

  SmallVector<Attribute, 4> attrs;
  attrs.reserve(unique.size());
  for (sym::PredHandle pred : unique)
    attrs.push_back(PredAttr::get(ctx, pred));
  return ArrayAttr::get(ctx, attrs);
}

static bool
predicateSymbolsContained(sym::PredHandle pred,
                          const llvm::DenseSet<StringRef> &symbols) {
  bool contained = true;
  sym::walkSymbolNames(pred, [&](StringRef name) {
    if (!symbols.count(name))
      contained = false;
  });
  return contained;
}

SmallVector<sym::PredHandle> mlir::wave::filterIndexExprPredicatesBySymbols(
    ArrayRef<sym::PredHandle> assumptions,
    const llvm::DenseSet<StringRef> &symbols) {
  SmallVector<sym::PredHandle> filtered;
  for (sym::PredHandle pred : assumptions)
    if (!isAlwaysTruePredicate(pred) &&
        predicateSymbolsContained(pred, symbols))
      appendUniquePredicate(filtered, pred);
  return filtered;
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

  std::optional<int64_t> lo = sym::floorEndpoint(*range->lower);
  std::optional<int64_t> hi = sym::ceilEndpoint(*range->upper);
  if (!lo || !hi)
    return std::nullopt;
  unsigned bits = indexValueElementWidth(resultType);
  if (bits == 0 || !fitsSignedWidth(*lo, bits) || !fitsSignedWidth(*hi, bits))
    return std::nullopt;

  APInt loValue(bits, *lo, /*isSigned=*/true);
  APInt hiValue(bits, *hi, /*isSigned=*/true);
  return ConstantIntRanges::fromSigned(loValue, hiValue);
}

static Value stripIndexExprRangeWrappers(Value value) {
  while (auto splat = value.getDefiningOp<SplatOp>())
    value = splat.getSource();
  return value;
}

static std::optional<ConstantIntRanges>
buildIndexExprProducerRange(sym::Store &store, Value value) {
  value = stripIndexExprRangeWrappers(value);
  IndexExprOp producer = value.getDefiningOp<IndexExprOp>();
  if (!producer)
    return std::nullopt;

  SmallVector<sym::PredHandle, 4> assumptions;
  appendIndexExprPredicates(producer, assumptions);
  for (auto [nameAttr, binding] :
       llvm::zip(producer.getNames(), producer.getBindings())) {
    StringRef name = cast<StringAttr>(nameAttr).getValue();
    appendAssumePredicates(store, binding, name, assumptions);
  }
  return buildIndexExprResultRange(store, producer.getExpr().getValue(),
                                   producer.getResult().getType(), assumptions);
}

static FailureOr<sym::PredHandle>
composeLogicPredicate(sym::Analysis &analysis, sym::PredKind kind,
                      ArrayRef<sym::PredHandle> predicates) {
  assert(!predicates.empty() && "expected at least one predicate");
  sym::PredHandle current = predicates.front();
  for (sym::PredHandle pred : predicates.drop_front()) {
    FailureOr<sym::PredHandle> next = kind == sym::PredKind::And
                                          ? analysis.composeAnd(current, pred)
                                          : analysis.composeOr(current, pred);
    if (failed(next))
      return failure();
    current = *next;
  }
  return current;
}

static FailureOr<std::optional<sym::PredHandle>>
removeContradictedPredicateParts(sym::Analysis &analysis,
                                 sym::PredHandle pred) {
  sym::PredView view(pred);
  if (view.getKind() != sym::PredKind::And &&
      view.getKind() != sym::PredKind::Or) {
    if (analysis.check(pred) == sym::CheckResult::False)
      return std::optional<sym::PredHandle>{};
    return std::optional<sym::PredHandle>{pred};
  }

  SmallVector<sym::PredHandle, 4> kept;
  bool changed = false;
  for (uint32_t i : llvm::seq<uint32_t>(0, view.getLogicArgCount())) {
    sym::PredHandle arg = view.getLogicArg(i);
    FailureOr<std::optional<sym::PredHandle>> keptArg =
        removeContradictedPredicateParts(analysis, arg);
    if (failed(keptArg))
      return failure();
    if (!*keptArg) {
      changed = true;
      continue;
    }
    changed |= !(**keptArg == arg);
    kept.push_back(**keptArg);
  }
  if (kept.empty())
    return std::optional<sym::PredHandle>{};
  if (!changed)
    return std::optional<sym::PredHandle>{pred};
  FailureOr<sym::PredHandle> rebuilt =
      composeLogicPredicate(analysis, view.getKind(), kept);
  if (failed(rebuilt))
    return failure();
  return std::optional<sym::PredHandle>{*rebuilt};
}

static void
dropPredicatesContradictedBy(sym::Store &store, sym::PredHandle trusted,
                             SmallVectorImpl<sym::PredHandle> &assumptions) {
  std::array<sym::PredHandle, 1> trustedAssumptions{trusted};
  FailureOr<std::unique_ptr<sym::Analysis>> analysis =
      sym::Analysis::create(store, trustedAssumptions);
  if (failed(analysis))
    return;

  SmallVector<sym::PredHandle, 4> filtered;
  for (sym::PredHandle pred : assumptions) {
    if (pred == trusted) {
      appendUniquePredicate(filtered, pred);
      continue;
    }
    FailureOr<std::optional<sym::PredHandle>> kept =
        removeContradictedPredicateParts(**analysis, pred);
    if (failed(kept)) {
      appendUniquePredicate(filtered, pred);
      continue;
    }
    if (*kept)
      appendUniquePredicate(filtered, **kept);
  }
  assumptions.assign(filtered.begin(), filtered.end());
}

static void appendIndexExprProducerRangePredicate(
    sym::Store &store, Value binding, StringRef name,
    SmallVectorImpl<sym::PredHandle> &assumptions) {
  std::optional<ConstantIntRanges> range =
      buildIndexExprProducerRange(store, binding);
  if (!range)
    return;
  std::optional<sym::PredHandle> assumption =
      buildIndexExprRangeAssumption(store, name, *range);
  if (!assumption)
    return;
  dropPredicatesContradictedBy(store, *assumption, assumptions);
  if (!isPredicateImplied(store, *assumption, assumptions))
    appendUniquePredicate(assumptions, *assumption);
}

static void
appendAssumePredicatesImpl(sym::Store &store, Value binding, StringRef name,
                           SmallVectorImpl<sym::PredHandle> &assumptions,
                           bool includeProducerRange) {
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
        appendUniquePredicate(assumptions, *pred);
    }
    binding = assume.getValue();
  }
  if (includeProducerRange)
    appendIndexExprProducerRangePredicate(store, binding, name, assumptions);
}

void mlir::wave::appendAssumePredicates(
    sym::Store &store, Value binding, StringRef name,
    SmallVectorImpl<sym::PredHandle> &assumptions) {
  appendAssumePredicatesImpl(store, binding, name, assumptions,
                             /*includeProducerRange=*/true);
}

static void appendRangePredicatesForInference(
    sym::Store &store, Value binding, StringRef name,
    const ConstantIntRanges &range,
    SmallVectorImpl<sym::PredHandle> &assumptions) {
  appendAssumePredicatesImpl(store, binding, name, assumptions,
                             /*includeProducerRange=*/false);
  std::optional<sym::PredHandle> assumption =
      buildIndexExprRangeAssumption(store, name, range);
  if (assumption)
    appendUniquePredicate(assumptions, *assumption);
}

static std::optional<ConstantIntRanges>
buildAssumePredicateRange(sym::Store &store, Value binding, StringRef name,
                          Type resultType, ArrayAttr attrs) {
  FailureOr<sym::ExprHandle> expr = sym::composeExprSym(store, name);
  if (failed(expr))
    return std::nullopt;
  SmallVector<sym::PredHandle, 4> assumptions = getPredicateHandles(attrs);
  appendAssumePredicates(store, binding, name, assumptions);
  std::optional<sym::InferredRange> range =
      sym::inferRange(store, *expr, assumptions);
  if (!range)
    return std::nullopt;

  unsigned bits = indexValueElementWidth(resultType);
  if (bits == 0)
    return std::nullopt;

  APInt loValue = APInt::getSignedMinValue(bits);
  APInt hiValue = APInt::getSignedMaxValue(bits);
  if (range->lower) {
    std::optional<int64_t> lo = sym::floorEndpoint(*range->lower);
    if (!lo || !fitsSignedWidth(*lo, bits))
      return std::nullopt;
    loValue = APInt(bits, *lo, /*isSigned=*/true);
  }
  if (range->upper) {
    std::optional<int64_t> hi = sym::ceilEndpoint(*range->upper);
    if (!hi || !fitsSignedWidth(*hi, bits))
      return std::nullopt;
    hiValue = APInt(bits, *hi, /*isSigned=*/true);
  }
  return ConstantIntRanges::fromSigned(loValue, hiValue);
}

void SplatOp::inferResultRanges(ArrayRef<ConstantIntRanges> argRanges,
                                SetIntRangeFn setResultRange) {
  SimdType simd = cast<SimdType>(getResult().getType());
  if (!isa<IntegerType>(simd.getElementType()) &&
      !simd.getElementType().isIndex())
    return;
  unsigned bits = waveBinaryElementWidth(simd.getElementType());
  setResultRange(getResult(), normalizeWaveArithRange(argRanges[0], bits));
}

void BinaryOp::inferResultRanges(ArrayRef<ConstantIntRanges> argRanges,
                                 SetIntRangeFn setResultRange) {
  unsigned bits = waveBinaryElementWidth(getResult().getType());
  SmallVector<ConstantIntRanges, 2> ranges =
      normalizeWaveArithRanges(argRanges, bits);
  setResultRange(getResult(), inferWaveBinaryResultRange(
                                  getKind(), ranges, bits, getOverflowFlags()));
}

void ReadFirstOp::inferResultRanges(ArrayRef<ConstantIntRanges> argRanges,
                                    SetIntRangeFn setResultRange) {
  Type resultType = getResult().getType();
  if (!resultType.isIntOrIndex())
    return;
  unsigned bits = waveBinaryElementWidth(resultType);
  setResultRange(getResult(), normalizeWaveArithRange(argRanges.front(), bits));
}

OpFoldResult ReadFirstOp::fold(FoldAdaptor adaptor) {
  if (Attribute source = adaptor.getSource())
    return source;
  if (SplatOp splat = getSource().getDefiningOp<SplatOp>())
    return splat.getSource();
  return {};
}

void AssumeOp::inferResultRangesFromOptional(
    ArrayRef<IntegerValueRange> argRanges, SetIntLatticeFn setResultRange) {
  WaveDialect *dialect = getContext()->getLoadedDialect<WaveDialect>();
  if (!dialect)
    return;

  IntegerValueRange incoming = argRanges[0];
  std::optional<ConstantIntRanges> asserted = buildAssumePredicateRange(
      dialect->getSymbolStore(), getValue(), getName(), getResult().getType(),
      getAssumptions());
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
  appendIndexExprPredicates(*this, assumptions);
  for (auto [nameAttr, binding, range] :
       llvm::zip(getNames(), getBindings(), argRanges)) {
    StringRef name = cast<StringAttr>(nameAttr).getValue();
    appendRangePredicatesForInference(store, binding, name, range, assumptions);
  }
  std::optional<ConstantIntRanges> range = buildIndexExprResultRange(
      store, getExpr().getValue(), getResult().getType(), assumptions);
  if (!range)
    return;
  setResultRange(getResult(), *range);
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

LogicalResult CmpFOp::verify() {
  SimdType lhsType = cast<SimdType>(getLhs().getType());
  SimdType rhsType = cast<SimdType>(getRhs().getType());
  if (lhsType != rhsType)
    return emitOpError("operands must have the same SIMD type");
  if (!isa<FloatType>(lhsType.getElementType()))
    return emitOpError("operands must have floating-point SIMD elements");
  MaskType resultType = cast<MaskType>(getResult().getType());
  if (lhsType.getWidth() != resultType.getWidth())
    return emitOpError("result mask width must match operand SIMD width");
  return success();
}

static std::optional<bool> foldWaveCmpIAttrs(arith::CmpIPredicate predicate,
                                             Attribute lhsAttr,
                                             Attribute rhsAttr) {
  APInt lhs;
  APInt rhs;
  if (!matchPattern(lhsAttr, m_ConstantInt(&lhs)) ||
      !matchPattern(rhsAttr, m_ConstantInt(&rhs)))
    return std::nullopt;
  return arith::applyCmpPredicate(predicate, lhs, rhs);
}

OpFoldResult CmpIOp::fold(FoldAdaptor adaptor) {
  std::optional<bool> result;
  if (getLhs() == getRhs())
    result = arith::applyCmpPredicate(getPredicate(), APInt(1, 0), APInt(1, 0));
  else
    result =
        foldWaveCmpIAttrs(getPredicate(), adaptor.getLhs(), adaptor.getRhs());
  if (!result)
    return {};
  return Builder(getContext()).getBoolAttr(*result);
}

namespace {
static std::optional<APInt> getSplatInteger(Value value) {
  std::optional<std::pair<APInt, bool>> constant;
  if (SplatOp splat = value.getDefiningOp<SplatOp>())
    constant = getConstantAPIntValue(splat.getSource());
  else if (ConstantOp constantOp = value.getDefiningOp<ConstantOp>())
    constant = getConstantAPIntValue(constantOp.getValue());
  else
    return std::nullopt;
  if (!constant)
    return std::nullopt;
  return constant->first;
}

struct FoldCmpIOfBooleanSelect : OpRewritePattern<CmpIOp> {
  using OpRewritePattern::OpRewritePattern;

  LogicalResult matchAndRewrite(CmpIOp op,
                                PatternRewriter &rewriter) const override {
    SelectOp select = op.getLhs().getDefiningOp<SelectOp>();
    Value other = op.getRhs();
    bool selectIsLhs = true;
    if (!select) {
      select = op.getRhs().getDefiningOp<SelectOp>();
      other = op.getLhs();
      selectIsLhs = false;
    }
    if (!select || select.getCondition().getType() != op.getType())
      return failure();

    std::optional<APInt> trueValue = getSplatInteger(select.getTrueValue());
    std::optional<APInt> falseValue = getSplatInteger(select.getFalseValue());
    std::optional<APInt> otherValue = getSplatInteger(other);
    if (!trueValue || !falseValue || !otherValue)
      return failure();

    auto compare = [&](const APInt &selected) {
      return selectIsLhs ? arith::applyCmpPredicate(op.getPredicate(), selected,
                                                    *otherValue)
                         : arith::applyCmpPredicate(op.getPredicate(),
                                                    *otherValue, selected);
    };
    if (!compare(*trueValue) || compare(*falseValue))
      return failure();
    rewriter.replaceOp(op, select.getCondition());
    return success();
  }
};
} // namespace

void CmpIOp::getCanonicalizationPatterns(RewritePatternSet &patterns,
                                         MLIRContext *context) {
  patterns.add<FoldCmpIOfBooleanSelect>(context);
}

static std::optional<bool> foldWaveCmpIToBool(CmpIOp cmp) {
  if (cmp.getLhs() == cmp.getRhs())
    return arith::applyCmpPredicate(cmp.getPredicate(), APInt(1, 0),
                                    APInt(1, 0));

  SplatOp lhsSplat = cmp.getLhs().getDefiningOp<SplatOp>();
  SplatOp rhsSplat = cmp.getRhs().getDefiningOp<SplatOp>();
  if (!lhsSplat || !rhsSplat)
    return std::nullopt;

  APInt lhs;
  APInt rhs;
  if (!matchPattern(lhsSplat.getSource(), m_ConstantInt(&lhs)) ||
      !matchPattern(rhsSplat.getSource(), m_ConstantInt(&rhs)))
    return std::nullopt;
  return arith::applyCmpPredicate(cmp.getPredicate(), lhs, rhs);
}

static std::optional<bool> foldWaveMaskAttrToBool(Attribute attr) {
  APInt value;
  if (!matchPattern(attr, m_ConstantInt(&value)) || value.getBitWidth() != 1)
    return std::nullopt;
  return !value.isZero();
}

OpFoldResult BallotOp::fold(FoldAdaptor adaptor) {
  if (std::optional<bool> mask = foldWaveMaskAttrToBool(adaptor.getMask())) {
    unsigned bits = cast<IntegerType>(getType()).getWidth();
    APInt value = *mask ? APInt::getAllOnes(bits) : APInt::getZero(bits);
    return IntegerAttr::get(getType(), value);
  }

  CmpIOp cmp = getMask().getDefiningOp<CmpIOp>();
  if (!cmp)
    return {};

  std::optional<bool> result = foldWaveCmpIToBool(cmp);
  if (!result)
    return {};

  unsigned bits = cast<IntegerType>(getType()).getWidth();
  APInt value = *result ? APInt::getAllOnes(bits) : APInt::getZero(bits);
  return IntegerAttr::get(getType(), value);
}

LogicalResult BallotOp::verify() {
  unsigned expectedWidth =
      cast<MaskType>(getMask().getType()).getWidth() == 32 ? 32 : 64;
  auto integerType = dyn_cast<IntegerType>(getResult().getType());
  if (!integerType || integerType.getWidth() != expectedWidth)
    return emitOpError("result integer width must match mask width");
  return success();
}

namespace {
struct CanonicalizeJoinOp : OpRewritePattern<JoinOp> {
  using OpRewritePattern<JoinOp>::OpRewritePattern;

  LogicalResult matchAndRewrite(JoinOp op,
                                PatternRewriter &rewriter) const override {
    SmallVector<Value> dependencies;
    llvm::SmallDenseSet<Value, 8> seen;
    bool changed = false;
    for (Value dependency : op.getDependencies()) {
      if (dependency.getDefiningOp<TokenOp>()) {
        changed = true;
        continue;
      }
      if (!seen.insert(dependency).second) {
        changed = true;
        continue;
      }
      dependencies.push_back(dependency);
    }

    if (!changed && !dependencies.empty())
      return failure();
    if (dependencies.empty()) {
      TokenOp token =
          TokenOp::create(rewriter, op.getLoc(), op.getResult().getType());
      rewriter.replaceOp(op, token.getResult());
      return success();
    }
    if (dependencies.size() == 1) {
      rewriter.replaceOp(op, dependencies.front());
      return success();
    }

    rewriter.modifyOpInPlace(
        op, [&] { op.getDependenciesMutable().assign(dependencies); });
    return success();
  }
};
} // namespace

OpFoldResult JoinOp::fold(FoldAdaptor) {
  if (getDependencies().size() == 1)
    return getDependencies().front();
  return {};
}

void JoinOp::getCanonicalizationPatterns(RewritePatternSet &patterns,
                                         MLIRContext *context) {
  patterns.add<CanonicalizeJoinOp>(context);
}

LogicalResult ReadFirstOp::verify() {
  auto simdType = cast<SimdType>(getSource().getType());
  if (simdType.getElementType() != getResult().getType())
    return emitOpError("result type must match SIMD element type");
  return success();
}

static bool isShuffleLaneType(Type type) {
  if (type.isIndex())
    return true;
  IntegerType integerType = dyn_cast<IntegerType>(type);
  return integerType && integerType.isSignless() &&
         integerType.getWidth() == 32;
}

LogicalResult ShuffleOp::verify() {
  SimdType sourceType = cast<SimdType>(getSource().getType());
  SimdType resultType = cast<SimdType>(getResult().getType());
  if (sourceType != resultType)
    return emitOpError("source and result SIMD types must match");

  Type sourceLaneType = getSourceLane().getType();
  if (SimdType laneSimdType = dyn_cast<SimdType>(sourceLaneType)) {
    if (laneSimdType.getWidth() != sourceType.getWidth())
      return emitOpError("source lane SIMD width must match source SIMD width");
    if (!isShuffleLaneType(laneSimdType.getElementType()))
      return emitOpError(
          "source lane SIMD element type must be index or signless i32");
    return success();
  }

  if (!isShuffleLaneType(sourceLaneType))
    return emitOpError("source lane scalar type must be index or signless i32");
  return success();
}

static LogicalResult verifyRedistributionSymbols(Operation *op,
                                                 sym::ExprHandle expr,
                                                 StringRef coordinate,
                                                 bool allowReduction = false) {
  std::optional<std::string> badSymbol;
  sym::walkSymbolNames(expr, [&](StringRef name) {
    if (name != "block" && name != "item" && name != "slot" &&
        (!allowReduction || name != "reduction") && !badSymbol)
      badSymbol = name.str();
  });
  if (badSymbol)
    return op->emitOpError(coordinate)
           << " expression references unsupported symbol `" << *badSymbol
           << "`";
  if (!sym::isIntegerValued(expr))
    return op->emitOpError(coordinate)
           << " expression must be structurally integral";
  return success();
}

static LogicalResult
verifyRedistributionRelationSymbols(Operation *op, RedistributionAttr relation,
                                    bool allowReduction = false) {
  if (failed(verifyRedistributionSymbols(op, relation.getSourceBlock(),
                                         "source block", allowReduction)))
    return failure();
  if (failed(verifyRedistributionSymbols(op, relation.getSourceItem(),
                                         "source item", allowReduction)))
    return failure();
  if (failed(verifyRedistributionSymbols(op, relation.getSourceSlot(),
                                         "source slot", allowReduction)))
    return failure();
  return success();
}

static LogicalResult verifyRedistributionPayload(Operation *op, SimdType type,
                                                 StringRef role,
                                                 bool allowPointer) {
  Type payload = type.getElementType();
  if (VectorType vector = dyn_cast<VectorType>(payload)) {
    if (vector.getRank() != 1)
      return op->emitOpError() << role << " packet vector must be 1-D";
    if (vector.isScalable())
      return op->emitOpError() << role << " packet vector must be fixed-size";
    payload = vector.getElementType();
  }
  if (payload.isIntOrFloat() || (allowPointer && isa<PtrType>(payload)))
    return success();
  if (allowPointer)
    return op->emitOpError()
           << role << " packet element type must be integer, float, or pointer";
  return op->emitOpError() << role
                           << " packet element type must be integer or float";
}

LogicalResult RedistributeOp::verify() {
  SimdType sourceType = cast<SimdType>(getSource().getType());
  SimdType resultType = cast<SimdType>(getResult().getType());

  if (failed(verifyRedistributionPayload(getOperation(), sourceType, "source",
                                         /*allowPointer=*/true)) ||
      failed(verifyRedistributionPayload(getOperation(), resultType, "result",
                                         /*allowPointer=*/true)))
    return failure();
  if (sourceType.getWidth() != resultType.getWidth())
    return emitOpError("source and result SIMD widths must match");
  if (getWavePayloadElementType(sourceType) !=
      getWavePayloadElementType(resultType))
    return emitOpError("source and result packet element types must match");
  return verifyRedistributionRelationSymbols(getOperation(), getRelation());
}

static LogicalResult verifyReductionPacketTypes(ReduceOp op) {
  SimdType sourceType = cast<SimdType>(op.getSource().getType());
  SimdType resultType = cast<SimdType>(op.getResult().getType());
  if (failed(verifyRedistributionPayload(op.getOperation(), sourceType,
                                         "source", /*allowPointer=*/false)) ||
      failed(verifyRedistributionPayload(op.getOperation(), resultType,
                                         "result",
                                         /*allowPointer=*/false)))
    return failure();
  if (sourceType.getWidth() != resultType.getWidth())
    return op.emitOpError("source and result SIMD widths must match");
  if (getWavePayloadElementType(sourceType) !=
      getWavePayloadElementType(resultType))
    return op.emitOpError("source and result packet element types must match");
  return success();
}

static bool operationHasMemoryToken(Operation *operation) {
  return llvm::any_of(operation->getOperandTypes(),
                      [](Type type) { return isa<MemTokenType>(type); }) ||
         llvm::any_of(operation->getResultTypes(),
                      [](Type type) { return isa<MemTokenType>(type); });
}

static Operation *
findReductionCombinerOperation(Region &combiner,
                               function_ref<bool(Operation *)> predicate) {
  Operation *found = nullptr;
  combiner.walk([&](Operation *nested) {
    if (!predicate(nested))
      return WalkResult::advance();
    found = nested;
    return WalkResult::interrupt();
  });
  return found;
}

static LogicalResult verifyReductionCombinerBody(ReduceOp op) {
  Region &combiner = op.getCombiner();
  Block &block = combiner.front();
  if (llvm::any_of(block.getArgumentTypes(),
                   [](Type type) { return isa<MemTokenType>(type); }))
    return op.emitOpError("combiner must not contain memory tokens");

  Operation *tokenOperation =
      findReductionCombinerOperation(combiner, operationHasMemoryToken);
  if (tokenOperation)
    return op.emitOpError("combiner must not contain memory tokens");

  Operation *capturingOperation =
      findReductionCombinerOperation(combiner, [&](Operation *nested) {
        return llvm::any_of(nested->getOperands(), [&](Value value) {
          return !combiner.isAncestor(value.getParentRegion());
        });
      });
  if (capturingOperation)
    return op.emitOpError(
        "combiner must not capture values from outside the reduction");

  Operation *impureOperation = findReductionCombinerOperation(
      combiner, [](Operation *nested) { return !isPure(nested); });
  if (impureOperation)
    return op.emitOpError("combiner contains non-pure operation '")
           << impureOperation->getName() << "'";
  return success();
}

static LogicalResult verifyReductionCombiner(ReduceOp op) {
  SimdType sourceType = cast<SimdType>(op.getSource().getType());
  Type combinerType =
      SimdType::get(op.getContext(), getWavePayloadElementType(sourceType),
                    sourceType.getWidth());
  Region &combiner = op.getCombiner();
  Block &block = combiner.front();
  if (block.getNumArguments() != 2)
    return op.emitOpError("combiner block must have exactly two arguments");
  for (BlockArgument argument : block.getArguments())
    if (argument.getType() != combinerType)
      return op.emitOpError("combiner block arguments must have type ")
             << combinerType;
  YieldOp yield = dyn_cast<YieldOp>(block.getTerminator());
  if (!yield)
    return op.emitOpError("combiner block must terminate with wave.yield");
  if (yield.getValues().size() != 1 ||
      yield.getValues().front().getType() != combinerType)
    return op.emitOpError("combiner must yield exactly one value of type ")
           << combinerType;
  return verifyReductionCombinerBody(op);
}

static LogicalResult verifyReductionRelation(ReduceOp op) {
  if (op.getReductionExtentAttr().getInt() <= 0)
    return op.emitOpError("reduction extent must be positive");
  return verifyRedistributionRelationSymbols(op.getOperation(),
                                             op.getRelation(), true);
}

LogicalResult ReduceOp::verify() {
  if (static_cast<bool>(getAssociativeAttr()) !=
      static_cast<bool>(getCommutativeAttr()))
    return emitOpError(
        "associative and commutative permissions must appear together");
  if (failed(verifyReductionPacketTypes(*this)))
    return failure();
  if (failed(verifyReductionCombiner(*this)))
    return failure();
  return verifyReductionRelation(*this);
}

bool mlir::wave::isItemLocalRedistribution(RedistributionAttr relation) {
  sym::ExprView sourceBlock(relation.getSourceBlock());
  bool identityBlock = sourceBlock.getSymbolName() == "block";
  if (relation.getBlocks() == 1)
    identityBlock |= sourceBlock.getInt() == 0;
  return identityBlock &&
         sym::ExprView(relation.getSourceItem()).getSymbolName() == "item";
}

bool mlir::wave::isIdentityRedistribution(RedistributionAttr relation) {
  return isItemLocalRedistribution(relation) &&
         sym::ExprView(relation.getSourceSlot()).getSymbolName() == "slot";
}

OpFoldResult RedistributeOp::fold(FoldAdaptor) {
  if (getSource().getType() != getResult().getType() ||
      !isIdentityRedistribution(getRelation()))
    return {};
  return getSource();
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

// Seed `IntRangeAnalysis` from the wave-axis id ops. Workgroup id bounds
// default to INT32_MAX because grid size is launch-provided. Workitem id can
// use the kernel's known workgroup size when present; otherwise it also falls
// back to INT32_MAX. lane_id is the tight `[0, W-1]` per-wave lane id.

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

static std::optional<int32_t> getKnownWorkgroupDim(Operation *op,
                                                   unsigned axis) {
  func::FuncOp func = op->getParentOfType<func::FuncOp>();
  if (!func || axis > 2)
    return std::nullopt;

  for (StringRef name : {"wave.workgroup_size", "gpu.known_block_size"}) {
    DenseI32ArrayAttr attr = func->getAttrOfType<DenseI32ArrayAttr>(name);
    if (!attr)
      continue;
    int32_t dim = axis < attr.size() ? attr.asArrayRef()[axis] : 1;
    if (dim > 0)
      return dim;
  }
  return std::nullopt;
}

void WorkitemIdOp::inferResultRanges(ArrayRef<ConstantIntRanges>,
                                     SetIntRangeFn setRange) {
  auto simdTy = cast<SimdType>(getResult().getType());
  unsigned bits = simdTy.getElementType().getIntOrFloatBitWidth();
  APInt lo(bits, 0, /*isSigned=*/true);
  int64_t upper = std::numeric_limits<int32_t>::max();
  if (std::optional<int32_t> dim =
          getKnownWorkgroupDim(getOperation(), getAxis()))
    upper = int64_t{*dim - 1};
  APInt hi(bits, upper, /*isSigned=*/true);
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

static bool isMemoryMappingReservedSymbol(StringRef name) {
  return name == "block" || name == "item" || name == "slot";
}

static void
collectMemoryMappingBindings(ExprAttr attr,
                             llvm::DenseSet<StringRef> &requiredBindings) {
  if (!attr)
    return;
  sym::ExprHandle expr = attr.getValue();
  sym::walkSymbolNames(expr, [&](StringRef name) {
    if (!isMemoryMappingReservedSymbol(name))
      requiredBindings.insert(name);
  });
}

static LogicalResult verifyMemoryMappingBindingNames(
    Operation *op, ArrayAttr names, ValueRange bindings, StringRef kind,
    llvm::DenseSet<StringRef> &declaredBindings,
    const llvm::DenseSet<StringRef> &requiredBindings) {
  if (names.size() != bindings.size())
    return op->emitOpError()
           << "expected one " << kind << " name per operand (got "
           << names.size() << " names and " << bindings.size() << " operands)";
  for (Attribute attr : names) {
    StringRef name = cast<StringAttr>(attr).getValue();
    if (name.empty())
      return op->emitOpError() << kind << " names must be non-empty";
    if (isMemoryMappingReservedSymbol(name))
      return op->emitOpError() << kind << " name `" << name << "` is reserved";
    if (!declaredBindings.insert(name).second)
      return op->emitOpError() << "duplicate mapping binding `" << name << "`";
    if (!requiredBindings.contains(name))
      return op->emitOpError()
             << kind << " `" << name << "` is not referenced by the mapping";
  }
  return success();
}

static LogicalResult verifyMemoryMappingPacketBindingNames(
    Operation *op, ArrayAttr names, ValueRange bindings,
    llvm::DenseSet<StringRef> &declaredBindings,
    const llvm::DenseSet<StringRef> &requiredBindings) {
  if (names.size() != bindings.size())
    return op->emitOpError()
           << "expected one packet binding name per operand (got "
           << names.size() << " names and " << bindings.size() << " operands)";

  llvm::DenseSet<StringRef> packetNames;
  for (Attribute attr : names) {
    StringRef name = cast<StringAttr>(attr).getValue();
    if (name.empty())
      return op->emitOpError("packet binding names must be non-empty");
    if (isMemoryMappingReservedSymbol(name))
      return op->emitOpError("packet binding name `")
             << name << "` is reserved";
    if (packetNames.insert(name).second &&
        !declaredBindings.insert(name).second)
      return op->emitOpError("duplicate mapping binding `") << name << "`";
    if (!requiredBindings.contains(name))
      return op->emitOpError("packet binding `")
             << name << "` is not referenced by the mapping";
  }
  return success();
}

static FailureOr<PtrType> verifyMemoryMappingBase(Operation *op, Type baseType,
                                                  SimdType packetType) {
  auto emit = [op](const Twine &msg) { return op->emitOpError(msg); };
  FailureOr<WavePtrCastShape> shape = classifyWavePtrCastType(baseType, emit);
  if (failed(shape))
    return failure();
  if (shape->simdWidth && *shape->simdWidth != packetType.getWidth()) {
    op->emitOpError("SIMD pointer base width must match packet SIMD width");
    return failure();
  }
  return shape->ptr;
}

static LogicalResult verifyMemoryMappingBases(Operation *op, ValueRange bases,
                                              SimdType packetType) {
  if (bases.empty())
    return op->emitOpError("requires at least one pointer base");
  FailureOr<PtrType> first =
      verifyMemoryMappingBase(op, bases.front().getType(), packetType);
  if (failed(first))
    return failure();
  for (Value base : bases.drop_front()) {
    FailureOr<PtrType> type =
        verifyMemoryMappingBase(op, base.getType(), packetType);
    if (failed(type))
      return failure();
    if (type->getAddressSpace() != first->getAddressSpace() ||
        type->getElementType() != first->getElementType())
      return op->emitOpError(
          "pointer bases must have identical address spaces and element types");
  }
  return success();
}

static LogicalResult verifyMemoryMappingNames(Operation *op,
                                              MemoryMappingAttr mapping,
                                              ValueRange bindings,
                                              ArrayAttr bindingNames,
                                              ValueRange packetBindings,
                                              ArrayAttr packetBindingNames) {
  llvm::DenseSet<StringRef> requiredBindings;
  collectMemoryMappingBindings(mapping.getBase(), requiredBindings);
  collectMemoryMappingBindings(mapping.getTargetBlock(), requiredBindings);
  collectMemoryMappingBindings(mapping.getBitOffset(), requiredBindings);

  llvm::DenseSet<StringRef> declaredBindings;
  if (failed(verifyMemoryMappingBindingNames(op, bindingNames, bindings,
                                             "binding", declaredBindings,
                                             requiredBindings)))
    return failure();
  if (failed(verifyMemoryMappingPacketBindingNames(
          op, packetBindingNames, packetBindings, declaredBindings,
          requiredBindings)))
    return failure();
  for (StringRef name : requiredBindings)
    if (!declaredBindings.contains(name))
      return op->emitOpError()
             << "mapping symbol `" << name << "` has no binding";
  return success();
}

static LogicalResult verifyMemoryMappingBindings(Operation *op,
                                                 ValueRange bindings,
                                                 SimdType packetType) {
  auto emit = [op](const Twine &msg) { return op->emitOpError(msg); };
  for (Value binding : bindings) {
    FailureOr<SymbolicOffsetBindingKind> kind =
        classifySymbolicOffsetBinding(binding.getType(), emit);
    if (failed(kind))
      return failure();
    if (*kind == SymbolicOffsetBindingKind::Lane &&
        cast<SimdType>(binding.getType()).getWidth() != packetType.getWidth())
      return op->emitOpError("lane binding width must match packet SIMD width");
  }
  return success();
}

static LogicalResult verifyPackedPacketBinding(
    Operation *op, StringRef name, VectorType vector, VectorType packetVector,
    llvm::StringMap<int64_t> &scalarCounts, llvm::StringSet<> &vectorBindings) {
  if (scalarCounts.contains(name) || !vectorBindings.insert(name).second)
    return op->emitOpError("packet binding `")
           << name << "` mixes packed and component operands";
  if (vector.isScalable() ||
      vector.getNumElements() != packetVector.getNumElements())
    return op->emitOpError(
        "packet binding slot count must match the accessed packet");
  if (!vector.getElementType().isInteger(32))
    return op->emitOpError(
        "packed packet binding elements must be signless i32");
  return success();
}

static LogicalResult
verifyComponentPacketBinding(Operation *op, StringRef name, Type element,
                             llvm::StringMap<int64_t> &scalarCounts,
                             const llvm::StringSet<> &vectorBindings) {
  if (vectorBindings.contains(name))
    return op->emitOpError("packet binding `")
           << name << "` mixes packed and component operands";
  if (!element.isIndex() && !element.isInteger(32))
    return op->emitOpError(
        "packet binding components must be index or signless i32");
  ++scalarCounts[name];
  return success();
}

static LogicalResult
verifyMemoryMappingPacketBinding(Operation *op, Value binding, StringRef name,
                                 SimdType packetType, VectorType packetVector,
                                 llvm::StringMap<int64_t> &scalarCounts,
                                 llvm::StringSet<> &vectorBindings) {
  SimdType simd = dyn_cast<SimdType>(binding.getType());
  if (!simd)
    return op->emitOpError("packet binding operands must have wave SIMD type");
  if (simd.getWidth() != packetType.getWidth())
    return op->emitOpError(
        "packet binding SIMD width must match packet SIMD width");

  Type element = simd.getElementType();
  if (VectorType vector = dyn_cast<VectorType>(element))
    return verifyPackedPacketBinding(op, name, vector, packetVector,
                                     scalarCounts, vectorBindings);
  return verifyComponentPacketBinding(op, name, element, scalarCounts,
                                      vectorBindings);
}

static LogicalResult verifyMemoryMappingPacketBindings(
    Operation *op, ValueRange packetBindings, ArrayAttr packetBindingNames,
    SimdType packetType, VectorType packetVector) {
  llvm::StringMap<int64_t> scalarCounts;
  llvm::StringSet<> vectorBindings;
  for (auto [binding, nameAttr] :
       llvm::zip(packetBindings, packetBindingNames)) {
    StringRef name = cast<StringAttr>(nameAttr).getValue();
    if (failed(verifyMemoryMappingPacketBinding(op, binding, name, packetType,
                                                packetVector, scalarCounts,
                                                vectorBindings)))
      return failure();
  }
  for (auto &entry : scalarCounts)
    if (entry.getValue() != packetVector.getNumElements())
      return op->emitOpError("packet binding `")
             << entry.getKey()
             << "` component count must match the accessed packet";
  return success();
}

static LogicalResult
verifyMemoryMappingOp(Operation *op, MemoryMappingAttr mapping,
                      ValueRange bases, ValueRange bindings,
                      ArrayAttr bindingNames, ValueRange packetBindings,
                      ArrayAttr packetBindingNames, SimdType packetType) {
  VectorType packetVector = cast<VectorType>(packetType.getElementType());
  if (packetVector.isScalable())
    return op->emitOpError("packet vector must be fixed-size");
  if (failed(verifyMemoryMappingBases(op, bases, packetType)))
    return failure();
  if (failed(verifyMemoryMappingNames(op, mapping, bindings, bindingNames,
                                      packetBindings, packetBindingNames)))
    return failure();
  if (failed(verifyMemoryMappingBindings(op, bindings, packetType)))
    return failure();
  return verifyMemoryMappingPacketBindings(
      op, packetBindings, packetBindingNames, packetType, packetVector);
}

LogicalResult GatherOp::verify() {
  SimdType packetType = cast<SimdType>(getValue().getType());
  return verifyMemoryMappingOp(getOperation(), getMapping(), getBases(),
                               getBindings(), getBindingNames(),
                               getPacketBindings(), getPacketBindingNames(),
                               packetType);
}

LogicalResult ScatterOp::verify() {
  SimdType packetType = cast<SimdType>(getValue().getType());
  return verifyMemoryMappingOp(getOperation(), getMapping(), getBases(),
                               getBindings(), getBindingNames(),
                               getPacketBindings(), getPacketBindingNames(),
                               packetType);
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

LogicalResult SharedMemoryBaseOp::verify() {
  // ODS pins the result to `Wave_Ptr`; only the address space needs a
  // runtime check.
  auto ptrType = cast<PtrType>(getResult().getType());
  if (!isa<SharedAddressSpaceAttr>(ptrType.getAddressSpace()))
    return emitOpError("result pointer must live in the shared address space");
  return success();
}

LogicalResult AllocOp::verify() {
  auto ptrType = cast<PtrType>(getResult().getType());
  if (!isa<SharedAddressSpaceAttr>(ptrType.getAddressSpace()))
    return emitOpError("result pointer must live in the shared address space");
  if (getBytesizeAttr().getInt() <= 0)
    return emitOpError("bytesize must be positive");

  int64_t align = getAlignAttr().getInt();
  if (align <= 0 || !llvm::isPowerOf2_64(static_cast<uint64_t>(align)))
    return emitOpError("align must be a positive power of two");
  IntegerAttr offsetAttr = getOffsetAttr();
  if (!offsetAttr)
    return success();
  int64_t offset = offsetAttr.getInt();
  if (offset < 0)
    return emitOpError("offset must be non-negative");
  if (offset % align)
    return emitOpError("offset must satisfy alignment");
  if (offset > std::numeric_limits<int64_t>::max() - getBytesizeAttr().getInt())
    return emitOpError("offset plus bytesize overflows i64");
  return success();
}

LogicalResult AllocReleaseOp::verify() {
  PtrType ptrType = cast<PtrType>(getAllocation().getType());
  if (!isa<SharedAddressSpaceAttr>(ptrType.getAddressSpace()))
    return emitOpError(
        "allocation pointer must live in the shared address space");
  if (static_cast<bool>(getLifetimeSource()) !=
      static_cast<bool>(getLifetimeResult()))
    return emitOpError(
        "lifetime_source and lifetime_result must be present together");
  if (Value source = getLifetimeSource())
    if (isa<MemTokenType>(source.getType()) ||
        isa<MemTokenType>(getLifetimeResult().getType()))
      return emitOpError("value lifetime operands cannot be memory tokens");
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

std::string
mlir::wave::getFreshIndexExprBindingName(StringRef stem,
                                         const llvm::StringMap<Value> &reserved,
                                         StringRef separator) {
  for (unsigned index :
       llvm::seq<unsigned>(0, std::numeric_limits<unsigned>::max())) {
    std::string candidate =
        (Twine(stem) + Twine(separator) + Twine(index)).str();
    if (!reserved.contains(candidate))
      return candidate;
  }
  llvm_unreachable("exhausted index_expr binding names");
}

std::string mlir::wave::getFreshIndexExprBindingName(
    StringRef stem, const llvm::StringMap<Value> &reserved, unsigned &nextIndex,
    StringRef separator) {
  for (; nextIndex != std::numeric_limits<unsigned>::max(); ++nextIndex) {
    std::string candidate =
        (Twine(stem) + Twine(separator) + Twine(nextIndex)).str();
    if (!reserved.contains(candidate)) {
      ++nextIndex;
      return candidate;
    }
  }
  llvm_unreachable("exhausted index_expr binding names");
}

StringRef mlir::wave::reserveIndexExprBindingName(
    StringRef requested, Value value, llvm::StringMap<Value> &reserved,
    llvm::DenseMap<Value, StringRef> &byValue, StringRef renameSeparator) {
  auto valueIt = byValue.find(value);
  if (valueIt != byValue.end())
    return valueIt->second;

  auto nameIt = reserved.find(requested);
  if (nameIt != reserved.end() && nameIt->second != value) {
    std::string fresh =
        getFreshIndexExprBindingName(requested, reserved, renameSeparator);
    auto [it, inserted] = reserved.try_emplace(fresh, value);
    (void)inserted;
    byValue[value] = it->getKey();
    return it->getKey();
  }

  auto [it, inserted] = reserved.try_emplace(requested, value);
  if (!inserted)
    it->second = value;
  byValue[value] = it->getKey();
  return it->getKey();
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
  appendIndexExprPredicates(op, offset.assumptions);
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
    appendAssumePredicates(store, binding, name, offset.assumptions);
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

FailureOr<SmallVector<sym::PredHandle>>
mlir::wave::substituteIndexExprPredicates(
    sym::Analysis &analysis, ArrayRef<sym::PredHandle> assumptions,
    ArrayRef<sym::ExprSubstitution> substitutions) {
  if (substitutions.empty())
    return SmallVector<sym::PredHandle>(assumptions);

  SmallVector<sym::PredHandle> substituted;
  substituted.reserve(assumptions.size());
  for (sym::PredHandle pred : assumptions) {
    FailureOr<sym::PredHandle> result =
        analysis.substitute(pred, substitutions);
    if (failed(result))
      return failure();
    FailureOr<sym::PredHandle> expanded = analysis.expand(*result);
    if (failed(expanded))
      return failure();
    FailureOr<sym::PredHandle> simplified = analysis.simplify(*expanded);
    substituted.push_back(succeeded(simplified) ? *simplified : *expanded);
  }
  return substituted;
}

FailureOr<SmallVector<sym::PredHandle>>
mlir::wave::substituteIndexExprPredicates(
    sym::Store &store, ArrayRef<sym::PredHandle> assumptions,
    ArrayRef<sym::ExprSubstitution> substitutions) {
  if (substitutions.empty())
    return SmallVector<sym::PredHandle>(assumptions);
  FailureOr<std::unique_ptr<sym::Analysis>> analysis =
      sym::Analysis::create(store);
  if (failed(analysis))
    return failure();
  return substituteIndexExprPredicates(**analysis, assumptions, substitutions);
}

static void collectIndexExprFreeSymbols(sym::ExprHandle expr,
                                        llvm::DenseSet<StringRef> &symbols) {
  sym::walkSymbolNames(expr, [&](StringRef name) { symbols.insert(name); });
}

static bool isIntegerLiteral(sym::ExprHandle expr, int64_t value) {
  return sym::ExprView(expr).getInt() == value;
}

static bool addIndexExprMaterializationCost(uint64_t value, uint64_t &cost) {
  if (value > std::numeric_limits<uint64_t>::max() - cost)
    return false;
  cost += value;
  return true;
}

static std::optional<int64_t>
combineIndexExprDenominators(std::optional<int64_t> lhs,
                             std::optional<int64_t> rhs) {
  if (!lhs || !rhs || *lhs <= 0 || *rhs <= 0)
    return std::nullopt;
  int64_t gcd = std::gcd(*lhs, *rhs);
  return llvm::checkedMul(*lhs / gcd, *rhs);
}

static std::optional<int64_t>
multiplyIndexExprDenominators(std::optional<int64_t> lhs,
                              std::optional<int64_t> rhs) {
  if (!lhs || !rhs || *lhs <= 0 || *rhs <= 0)
    return std::nullopt;
  return llvm::checkedMul(*lhs, *rhs);
}

static std::optional<int64_t> raiseIndexExprDenominator(int64_t value,
                                                        int32_t exponent) {
  if (value <= 0 || exponent < 0)
    return std::nullopt;
  int64_t result = 1;
  int64_t factor = value;
  uint32_t remaining = static_cast<uint32_t>(exponent);
  while (remaining) {
    if (remaining & 1) {
      std::optional<int64_t> product = llvm::checkedMul(result, factor);
      if (!product)
        return std::nullopt;
      result = *product;
    }
    remaining >>= 1;
    if (!remaining)
      break;
    std::optional<int64_t> square = llvm::checkedMul(factor, factor);
    if (!square)
      return std::nullopt;
    factor = *square;
  }
  return result;
}

static std::optional<int64_t>
getIndexExprStaticDenominator(sym::ExprHandle expr);

static std::optional<int64_t> getIndexExprAddDenominator(sym::ExprView view) {
  std::optional<int64_t> denominator =
      getIndexExprStaticDenominator(view.getAddConstant());
  for (uint32_t i : llvm::seq<uint32_t>(0, view.getAddTermCount())) {
    sym::AddTerm term = view.getAddTerm(i);
    std::optional<int64_t> termDenominator = multiplyIndexExprDenominators(
        getIndexExprStaticDenominator(term.coefficient),
        getIndexExprStaticDenominator(term.term));
    denominator = combineIndexExprDenominators(denominator, termDenominator);
  }
  return denominator;
}

static std::optional<int64_t> getIndexExprMulDenominator(sym::ExprView view) {
  std::optional<int64_t> denominator =
      getIndexExprStaticDenominator(view.getMulCoefficient());
  for (uint32_t i : llvm::seq<uint32_t>(0, view.getMulFactorCount())) {
    sym::MulFactor factor = view.getMulFactor(i);
    std::optional<int64_t> base = getIndexExprStaticDenominator(factor.base);
    if (!base)
      return std::nullopt;
    denominator = multiplyIndexExprDenominators(
        denominator, raiseIndexExprDenominator(*base, factor.exponent));
  }
  return denominator;
}

static std::optional<int64_t> getIndexExprModDenominator(sym::ExprView view) {
  std::optional<int64_t> rhs =
      getIndexExprStaticDenominator(view.getBinaryRhs());
  if (!rhs || *rhs != 1)
    return std::nullopt;
  return getIndexExprStaticDenominator(view.getBinaryLhs());
}

static std::optional<int64_t>
getIndexExprBitwiseDenominator(sym::ExprView view) {
  for (uint32_t i : llvm::seq<uint32_t>(0, view.getAssocArgCount())) {
    std::optional<int64_t> denominator =
        getIndexExprStaticDenominator(view.getAssocArg(i));
    if (!denominator || *denominator != 1)
      return std::nullopt;
  }
  return 1;
}

static std::optional<int64_t>
getIndexExprCompoundDenominator(sym::ExprView view) {
  switch (view.getKind()) {
  case sym::ExprKind::Add:
    return getIndexExprAddDenominator(view);
  case sym::ExprKind::Mul:
    return getIndexExprMulDenominator(view);
  case sym::ExprKind::Mod:
    return getIndexExprModDenominator(view);
  case sym::ExprKind::Xor:
  case sym::ExprKind::And:
  case sym::ExprKind::Or:
    return getIndexExprBitwiseDenominator(view);
  default:
    return std::nullopt;
  }
}

static std::optional<int64_t>
getIndexExprStaticDenominator(sym::ExprHandle expr) {
  sym::ExprView view(expr);
  sym::ExprKind kind = view.getKind();
  if (kind == sym::ExprKind::Integer || kind == sym::ExprKind::Symbol ||
      kind == sym::ExprKind::Floor || kind == sym::ExprKind::Ceil)
    return 1;
  if (kind == sym::ExprKind::Rational) {
    std::optional<sym::RationalLiteral> rational = view.getRational();
    if (!rational || rational->denominator <= 0)
      return std::nullopt;
    return rational->denominator;
  }
  return getIndexExprCompoundDenominator(view);
}

static std::optional<uint64_t>
getIndexExprMaterializationCostImpl(sym::ExprHandle expr, bool rationalAllowed);

static bool appendIndexExprNodeMaterializationCost(sym::ExprHandle expr,
                                                   bool rationalAllowed,
                                                   uint64_t &cost) {
  std::optional<uint64_t> node =
      getIndexExprMaterializationCostImpl(expr, rationalAllowed);
  return node && addIndexExprMaterializationCost(*node, cost);
}

static bool appendIndexExprOperatorCost(uint64_t operandCount, uint64_t &cost) {
  return operandCount == 0 ||
         addIndexExprMaterializationCost(operandCount - 1, cost);
}

static bool appendIndexExprAddTermMaterializationCost(sym::AddTerm term,
                                                      bool rationalAllowed,
                                                      uint64_t &cost) {
  if (!appendIndexExprNodeMaterializationCost(term.term, rationalAllowed, cost))
    return false;
  if (isIntegerLiteral(term.coefficient, 1))
    return true;
  return appendIndexExprNodeMaterializationCost(term.coefficient,
                                                rationalAllowed, cost) &&
         addIndexExprMaterializationCost(1, cost);
}

static std::optional<uint64_t>
getIndexExprAddMaterializationCost(sym::ExprView view, bool rationalAllowed) {
  uint64_t cost = 0;
  uint64_t operandCount = 0;
  if (!isIntegerLiteral(view.getAddConstant(), 0)) {
    if (!appendIndexExprNodeMaterializationCost(view.getAddConstant(),
                                                rationalAllowed, cost))
      return std::nullopt;
    ++operandCount;
  }
  for (uint32_t i : llvm::seq<uint32_t>(0, view.getAddTermCount())) {
    sym::AddTerm term = view.getAddTerm(i);
    if (!appendIndexExprAddTermMaterializationCost(term, rationalAllowed, cost))
      return std::nullopt;
    ++operandCount;
  }
  if (!appendIndexExprOperatorCost(operandCount, cost))
    return std::nullopt;
  return cost;
}

static bool appendIndexExprMulFactorMaterializationCost(sym::MulFactor factor,
                                                        bool rationalAllowed,
                                                        uint64_t &cost) {
  if (factor.exponent <= 0)
    return false;
  if (!appendIndexExprNodeMaterializationCost(factor.base, rationalAllowed,
                                              cost))
    return false;
  return addIndexExprMaterializationCost(
      static_cast<uint64_t>(factor.exponent - 1), cost);
}

static std::optional<uint64_t>
getIndexExprMulMaterializationCost(sym::ExprView view, bool rationalAllowed) {
  uint64_t cost = 0;
  uint64_t operandCount = 0;
  if (!isIntegerLiteral(view.getMulCoefficient(), 1)) {
    if (!appendIndexExprNodeMaterializationCost(view.getMulCoefficient(),
                                                rationalAllowed, cost))
      return std::nullopt;
    ++operandCount;
  }
  for (uint32_t i : llvm::seq<uint32_t>(0, view.getMulFactorCount())) {
    sym::MulFactor factor = view.getMulFactor(i);
    if (!appendIndexExprMulFactorMaterializationCost(factor, rationalAllowed,
                                                     cost))
      return std::nullopt;
    ++operandCount;
  }
  if (!appendIndexExprOperatorCost(operandCount, cost))
    return std::nullopt;
  return cost;
}

static std::optional<uint64_t>
getRoundedIndexExprMaterializationCost(sym::ExprView view) {
  std::optional<int64_t> denominator =
      getIndexExprStaticDenominator(view.getUnaryArg());
  if (!denominator || !llvm::isPowerOf2_64(*denominator))
    return std::nullopt;
  std::optional<uint64_t> arg =
      getIndexExprMaterializationCostImpl(view.getUnaryArg(), true);
  if (!arg || *arg == std::numeric_limits<uint64_t>::max())
    return std::nullopt;
  return *arg + 1;
}

static std::optional<uint64_t>
getModIndexExprMaterializationCost(sym::ExprView view, bool rationalAllowed) {
  std::optional<int64_t> divisor =
      sym::getIntegerLiteralValue(view.getBinaryRhs());
  if (!divisor || *divisor <= 0)
    return std::nullopt;
  bool isPowerOfTwo = llvm::isPowerOf2_64(*divisor);
  if ((!isPowerOfTwo && !llvm::isUInt<32>(*divisor)) ||
      (isPowerOfTwo && !llvm::isUInt<32>(*divisor - 1)))
    return std::nullopt;
  std::optional<uint64_t> lhs =
      getIndexExprMaterializationCostImpl(view.getBinaryLhs(), rationalAllowed);
  if (!lhs || *lhs == std::numeric_limits<uint64_t>::max())
    return std::nullopt;
  return *lhs + 1;
}

static std::optional<uint64_t>
getBitwiseIndexExprMaterializationCost(sym::ExprView view) {
  uint64_t cost = 0;
  uint32_t argCount = view.getAssocArgCount();
  for (uint32_t i : llvm::seq<uint32_t>(0, argCount))
    if (!appendIndexExprNodeMaterializationCost(view.getAssocArg(i), false,
                                                cost))
      return std::nullopt;
  if (!appendIndexExprOperatorCost(argCount, cost))
    return std::nullopt;
  return cost;
}

static std::optional<uint64_t>
getCompoundIndexExprMaterializationCost(sym::ExprView view,
                                        bool rationalAllowed) {
  switch (view.getKind()) {
  case sym::ExprKind::Add:
    return getIndexExprAddMaterializationCost(view, rationalAllowed);
  case sym::ExprKind::Mul:
    return getIndexExprMulMaterializationCost(view, rationalAllowed);
  case sym::ExprKind::Floor:
  case sym::ExprKind::Ceil:
    return getRoundedIndexExprMaterializationCost(view);
  case sym::ExprKind::Mod:
    return getModIndexExprMaterializationCost(view, rationalAllowed);
  case sym::ExprKind::Xor:
  case sym::ExprKind::And:
  case sym::ExprKind::Or:
    return getBitwiseIndexExprMaterializationCost(view);
  default:
    return std::nullopt;
  }
}

static std::optional<uint64_t>
getIndexExprMaterializationCostImpl(sym::ExprHandle expr,
                                    bool rationalAllowed) {
  sym::ExprView view(expr);
  if (view.getKind() == sym::ExprKind::Integer ||
      view.getKind() == sym::ExprKind::Symbol)
    return 0;
  if (view.getKind() == sym::ExprKind::Rational)
    return rationalAllowed ? std::optional<uint64_t>(0) : std::nullopt;
  return getCompoundIndexExprMaterializationCost(view, rationalAllowed);
}

std::optional<uint64_t>
mlir::wave::getIndexExprMaterializationCost(sym::ExprHandle expr) {
  sym::ExprKind kind = sym::ExprView(expr).getKind();
  bool rationalAllowed =
      kind == sym::ExprKind::Add || kind == sym::ExprKind::Mul;
  if (rationalAllowed) {
    std::optional<int64_t> denominator = getIndexExprStaticDenominator(expr);
    if (!denominator || !llvm::isPowerOf2_64(*denominator))
      return std::nullopt;
  }
  return getIndexExprMaterializationCostImpl(expr, rationalAllowed);
}

bool mlir::wave::shouldUseSimplifiedIndexExpr(sym::ExprHandle candidate,
                                              sym::ExprHandle baseline) {
  llvm::DenseSet<StringRef> candidateSymbols;
  llvm::DenseSet<StringRef> baselineSymbols;
  collectIndexExprFreeSymbols(candidate, candidateSymbols);
  collectIndexExprFreeSymbols(baseline, baselineSymbols);
  bool removesSymbols =
      candidateSymbols.size() < baselineSymbols.size() &&
      llvm::all_of(
          candidateSymbols,
          [&](StringRef name) { return baselineSymbols.contains(name); });
  sym::ExprKind candidateKind = sym::ExprView(candidate).getKind();
  if (candidateKind == sym::ExprKind::Integer)
    return true;

  std::optional<uint64_t> candidateCost =
      getIndexExprMaterializationCost(candidate);
  std::optional<uint64_t> baselineCost =
      getIndexExprMaterializationCost(baseline);
  if (!candidateCost)
    return false;
  if (!baselineCost)
    return true;
  if (*candidateCost != *baselineCost)
    return *candidateCost < *baselineCost;
  return removesSymbols;
}

static Value preserveIndexExprResultType(OpBuilder &builder, Location loc,
                                         Type targetType, Value value) {
  if (value.getType() == targetType)
    return value;
  auto targetSimd = dyn_cast<SimdType>(targetType);
  if (!targetSimd || value.getType() != targetSimd.getElementType())
    return {};
  return SplatOp::create(builder, loc, targetType, value);
}

static bool canPreserveIndexExprResultType(Type resultType, Type targetType) {
  if (resultType == targetType)
    return true;
  auto targetSimd = dyn_cast<SimdType>(targetType);
  return targetSimd && resultType == targetSimd.getElementType();
}

struct CanonicalIndexExprSimplification {
  SmallVector<sym::PredHandle> assumptions;
  sym::ExprHandle expr;
};

struct CanonicalIndexExprReplacement {
  SmallVector<StringRef> names;
  SmallVector<Value> bindings;
  SmallVector<sym::PredHandle> assumptions;
  Type resultType;
};

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

static LogicalResult materializeLiteralIndexExpr(IndexExprOp op,
                                                 PatternRewriter &rewriter) {
  if (!op.getBindings().empty() || !op.getResult().getType().isIndex())
    return failure();
  std::optional<int64_t> value =
      sym::getIntegerLiteralValue(op.getExpr().getValue());
  if (!value)
    return failure();
  Value constant =
      arith::ConstantIndexOp::create(rewriter, op.getLoc(), *value);
  rewriter.replaceOp(op, constant);
  return success();
}

static FailureOr<CanonicalIndexExprSimplification>
substituteAndSimplifyIndexExpr(IndexExprOp op, sym::Store &store) {
  SmallVector<sym::ExprSubstitution, 4> substitutions;
  if (failed(collectConstantIndexExprSubstitutions(op, store, substitutions)))
    return failure();

  SmallVector<sym::PredHandle, 4> assumptions;
  appendIndexExprPredicates(op, assumptions);
  FailureOr<std::unique_ptr<sym::Analysis>> analysis =
      sym::Analysis::create(store);
  if (failed(analysis))
    return failure();
  FailureOr<SmallVector<sym::PredHandle>> substitutedAssumptions =
      substituteIndexExprPredicates(**analysis, assumptions, substitutions);
  if (failed(substitutedAssumptions))
    return failure();
  for (sym::PredHandle pred : *substitutedAssumptions)
    if (failed((*analysis)->assume(pred)))
      return failure();

  FailureOr<sym::ExprHandle> substituted =
      (*analysis)->substitute(op.getExpr().getValue(), substitutions);
  if (failed(substituted))
    return failure();
  FailureOr<sym::ExprHandle> simplified = (*analysis)->simplify(*substituted);
  if (failed(simplified))
    return failure();
  sym::ExprHandle result =
      shouldUseSimplifiedIndexExpr(*simplified, *substituted) ? *simplified
                                                              : *substituted;

  return CanonicalIndexExprSimplification{std::move(*substitutedAssumptions),
                                          result};
}

static CanonicalIndexExprReplacement buildCanonicalIndexExprReplacement(
    IndexExprOp op, const CanonicalIndexExprSimplification &simplification) {
  llvm::DenseSet<StringRef> freeSymbols;
  collectIndexExprFreeSymbols(simplification.expr, freeSymbols);

  CanonicalIndexExprReplacement replacement;
  replacement.assumptions = filterIndexExprPredicatesBySymbols(
      simplification.assumptions, freeSymbols);
  collectLiveIndexExprBindings(op, freeSymbols, replacement.names,
                               replacement.bindings);
  replacement.resultType =
      getIndexExprResultType(op.getContext(), replacement.bindings);
  return replacement;
}

namespace {
struct MergeChainedAssumeOp : OpRewritePattern<AssumeOp> {
  using OpRewritePattern::OpRewritePattern;

  LogicalResult matchAndRewrite(AssumeOp op,
                                PatternRewriter &rewriter) const override {
    auto source = op.getValue().getDefiningOp<AssumeOp>();
    if (!source)
      return failure();

    auto *dialect = op->getContext()->getLoadedDialect<WaveDialect>();
    if (!dialect)
      return failure();
    sym::Store &store = dialect->getSymbolStore();

    FailureOr<sym::ExprHandle> sourceName =
        sym::composeExprSym(store, source.getName());
    FailureOr<sym::ExprHandle> targetName =
        sym::composeExprSym(store, op.getName());
    if (failed(sourceName) || failed(targetName))
      return failure();

    std::array<sym::ExprSubstitution, 1> substitutions{
        sym::ExprSubstitution{*sourceName, *targetName}};
    SmallVector<Attribute, 4> assumptions;
    assumptions.reserve(source.getAssumptions().size() +
                        op.getAssumptions().size());
    for (Attribute attr : source.getAssumptions()) {
      FailureOr<sym::PredHandle> pred = sym::substitutePred(
          store, cast<PredAttr>(attr).getValue(), substitutions);
      if (failed(pred))
        return failure();
      assumptions.push_back(PredAttr::get(op.getContext(), *pred));
    }
    for (Attribute attr : op.getAssumptions())
      assumptions.push_back(attr);

    auto replacement = AssumeOp::create(
        rewriter, op.getLoc(), op.getResult().getType(), source.getValue(),
        op.getNameAttr(), rewriter.getArrayAttr(assumptions));
    rewriter.replaceOp(op, replacement.getResult());
    return success();
  }
};

struct CanonicalizeIndexExprOp : OpRewritePattern<IndexExprOp> {
  using OpRewritePattern::OpRewritePattern;

  LogicalResult matchAndRewrite(IndexExprOp op,
                                PatternRewriter &rewriter) const override {
    if (succeeded(materializeLiteralIndexExpr(op, rewriter)))
      return success();

    auto *dialect = op->getContext()->getLoadedDialect<WaveDialect>();
    if (!dialect)
      return failure();
    FailureOr<CanonicalIndexExprSimplification> simplified =
        substituteAndSimplifyIndexExpr(op, dialect->getSymbolStore());
    if (failed(simplified))
      return failure();

    CanonicalIndexExprReplacement replacement =
        buildCanonicalIndexExprReplacement(op, *simplified);
    bool exprChanged = !(simplified->expr == op.getExpr().getValue());
    bool bindingsChanged =
        replacement.bindings.size() != op.getBindings().size();
    if (!exprChanged && !bindingsChanged)
      return failure();

    if (!canPreserveIndexExprResultType(replacement.resultType,
                                        op.getResult().getType()))
      return failure();

    auto newOp = IndexExprOp::create(
        rewriter, op.getLoc(), replacement.resultType,
        ExprAttr::get(op.getContext(), simplified->expr),
        getIndexExprPredArrayAttr(op.getContext(), replacement.assumptions),
        rewriter.getStrArrayAttr(replacement.names), replacement.bindings);
    Value result = preserveIndexExprResultType(
        rewriter, op.getLoc(), op.getResult().getType(), newOp.getResult());
    rewriter.replaceOp(op, result);
    return success();
  }
};
} // namespace

void AssumeOp::getCanonicalizationPatterns(RewritePatternSet &patterns,
                                           MLIRContext *context) {
  patterns.add<MergeChainedAssumeOp>(context);
}

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

  for (auto [index, attr] : llvm::enumerate(getAssumptionsAttr())) {
    sym::PredHandle pred = cast<PredAttr>(attr).getValue();
    std::optional<StringRef> badName;
    sym::walkSymbolNames(pred, [&](StringRef name) {
      if (!bindingNames.count(name) && !badName)
        badName = name;
    });
    if (badName)
      return emit("assumption #")
             << index << " references undeclared symbol `" << *badName << "`";
  }

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
