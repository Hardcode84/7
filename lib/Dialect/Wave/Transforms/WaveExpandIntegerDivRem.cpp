//===- WaveExpandIntegerDivRem.cpp - Expand integer div/rem ---------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/Wave/Transforms/Passes.h"

#include "mlir/Analysis/DataFlow/IntegerRangeAnalysis.h"
#include "mlir/Analysis/DataFlow/Utils.h"
#include "mlir/Analysis/DataFlowFramework.h"
#include "mlir/Dialect/Arith/IR/Arith.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/SCF/IR/SCF.h"
#include "mlir/Dialect/Wave/IR/Wave.h"
#include "mlir/IR/Builders.h"
#include "mlir/IR/Matchers.h"
#include "mlir/IR/PatternMatch.h"
#include "llvm/ADT/APInt.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/ADT/StringMap.h"
#include "llvm/Support/DivisionByConstantInfo.h"
#include "llvm/Support/MathExtras.h"

#include <limits>
#include <optional>

namespace mlir::wave {
#define GEN_PASS_DEF_WAVEEXPANDINTEGERDIVREM
#include "mlir/Dialect/Wave/Transforms/Passes.h.inc"
} // namespace mlir::wave

using namespace mlir;
using namespace mlir::wave;

namespace {

struct DivRemValues {
  Value quotient;
  Value remainder;
};

static bool isDivRem(BinaryKind kind) {
  return kind == BinaryKind::DivUI || kind == BinaryKind::DivSI ||
         kind == BinaryKind::RemUI || kind == BinaryKind::RemSI;
}

static bool isSignedDivRem(BinaryKind kind) {
  return kind == BinaryKind::DivSI || kind == BinaryKind::RemSI;
}

static constexpr int64_t signedI32Max = 2147483647;

static Type scalarElementType(Type type) {
  if (auto simd = dyn_cast<SimdType>(type))
    return simd.getElementType();
  return type;
}

static Type i32Like(OpBuilder &builder, Type type) {
  Type i32 = builder.getI32Type();
  if (auto simd = dyn_cast<SimdType>(type))
    return SimdType::get(type.getContext(), i32, simd.getWidth());
  return i32;
}

static bool canNarrowDivRemTypeToI32(Type type) {
  Type elementType = scalarElementType(type);
  return elementType.isIndex() || elementType.isInteger(64);
}

static unsigned elementBits(Type type) {
  Type elementType = scalarElementType(type);
  if (elementType.isIndex())
    return 64;
  return cast<IntegerType>(elementType).getWidth();
}

static uint64_t maskToBits(uint64_t value, unsigned bits) {
  if (bits == 64)
    return value;
  return value & ((uint64_t{1} << bits) - 1);
}

static std::optional<APInt> getConstantAPInt(Value value, unsigned bits) {
  if (auto splat = value.getDefiningOp<SplatOp>())
    return getConstantAPInt(splat.getSource(), bits);

  IntegerAttr attr;
  if (!matchPattern(value, m_Constant(&attr)))
    return std::nullopt;
  return attr.getValue().sextOrTrunc(bits);
}

static Value createScalarConstant(OpBuilder &builder, Location loc, Type type,
                                  uint64_t raw) {
  unsigned bits = type.isIndex() ? 64 : cast<IntegerType>(type).getWidth();
  APInt value(bits, maskToBits(raw, bits));
  return arith::ConstantOp::create(builder, loc, type,
                                   IntegerAttr::get(type, value));
}

static Value createConstantLike(OpBuilder &builder, Location loc, Type type,
                                uint64_t raw) {
  if (auto simd = dyn_cast<SimdType>(type)) {
    Value scalar =
        createScalarConstant(builder, loc, simd.getElementType(), raw);
    return SplatOp::create(builder, loc, type, scalar);
  }
  return createScalarConstant(builder, loc, type, raw);
}

static Value asType(OpBuilder &builder, Location loc, Value value, Type type) {
  if (value.getType() == type)
    return value;
  auto simd = dyn_cast<SimdType>(type);
  if (simd && value.getType() == simd.getElementType())
    return SplatOp::create(builder, loc, type, value);
  return value;
}

static Value createBinary(OpBuilder &builder, Location loc, Type resultType,
                          BinaryKind kind, Value lhs, Value rhs) {
  return BinaryOp::create(builder, loc, resultType, kind, lhs, rhs);
}

static Value createAdd(OpBuilder &builder, Location loc, Type type, Value lhs,
                       Value rhs) {
  return createBinary(builder, loc, type, BinaryKind::AddI, lhs, rhs);
}

static Value createSub(OpBuilder &builder, Location loc, Type type, Value lhs,
                       Value rhs) {
  return createBinary(builder, loc, type, BinaryKind::SubI, lhs, rhs);
}

static Value createMul(OpBuilder &builder, Location loc, Type type, Value lhs,
                       Value rhs) {
  return createBinary(builder, loc, type, BinaryKind::MulI, lhs, rhs);
}

static Value createMulHU(OpBuilder &builder, Location loc, Type type, Value lhs,
                         Value rhs) {
  return createBinary(builder, loc, type, BinaryKind::MulHUI, lhs, rhs);
}

static Value createShl(OpBuilder &builder, Location loc, Type type, Value lhs,
                       Value rhs) {
  return createBinary(builder, loc, type, BinaryKind::ShLI, lhs, rhs);
}

static Value createShrU(OpBuilder &builder, Location loc, Type type, Value lhs,
                        Value rhs) {
  return createBinary(builder, loc, type, BinaryKind::ShRUI, lhs, rhs);
}

static Value createShrS(OpBuilder &builder, Location loc, Type type, Value lhs,
                        Value rhs) {
  return createBinary(builder, loc, type, BinaryKind::ShRSI, lhs, rhs);
}

static Value createAnd(OpBuilder &builder, Location loc, Type type, Value lhs,
                       Value rhs) {
  return createBinary(builder, loc, type, BinaryKind::AndI, lhs, rhs);
}

static Value createOr(OpBuilder &builder, Location loc, Type type, Value lhs,
                      Value rhs) {
  return createBinary(builder, loc, type, BinaryKind::OrI, lhs, rhs);
}

static Value createXor(OpBuilder &builder, Location loc, Type type, Value lhs,
                       Value rhs) {
  return createBinary(builder, loc, type, BinaryKind::XOrI, lhs, rhs);
}

static Value createNeg(OpBuilder &builder, Location loc, Type type,
                       Value value) {
  return createSub(builder, loc, type,
                   createConstantLike(builder, loc, type, 0), value);
}

static Value createCompare(OpBuilder &builder, Location loc,
                           arith::CmpIPredicate predicate, Value lhs, Value rhs,
                           Type valueType) {
  if (auto simd = dyn_cast<SimdType>(valueType)) {
    lhs = asType(builder, loc, lhs, valueType);
    rhs = asType(builder, loc, rhs, valueType);
    Type maskType = MaskType::get(valueType.getContext(), simd.getWidth());
    return CmpIOp::create(builder, loc, maskType, predicate, lhs, rhs);
  }
  return arith::CmpIOp::create(builder, loc, predicate, lhs, rhs);
}

static Value createSelect(OpBuilder &builder, Location loc, Type type,
                          Value condition, Value trueValue, Value falseValue) {
  trueValue = asType(builder, loc, trueValue, type);
  falseValue = asType(builder, loc, falseValue, type);
  return SelectOp::create(builder, loc, type, condition, trueValue, falseValue);
}

static Value createShiftAmount(OpBuilder &builder, Location loc, Type type,
                               unsigned amount) {
  return createScalarConstant(builder, loc, scalarElementType(type), amount);
}

static Value createURecip(OpBuilder &builder, Location loc, Type type,
                          Value value) {
  value = asType(builder, loc, value, type);
  return URecipOp::create(builder, loc, type, value);
}

static Value createCtz(OpBuilder &builder, Location loc, Value value) {
  return CtzOp::create(builder, loc, value.getType(), value);
}

static Value createUMulHi(OpBuilder &builder, Location loc, Type type,
                          Value value, uint64_t multiplier,
                          bool useNativeI32MulHi = false) {
  unsigned bits = elementBits(type);
  if (useNativeI32MulHi && bits == 32)
    return createMulHU(builder, loc, type, value,
                       createScalarConstant(
                           builder, loc, scalarElementType(type), multiplier));

  unsigned halfBits = bits / 2;
  uint64_t halfMask =
      halfBits == 64 ? ~uint64_t{0} : ((uint64_t{1} << halfBits) - 1);

  Value mask =
      createScalarConstant(builder, loc, scalarElementType(type), halfMask);
  Value shift = createShiftAmount(builder, loc, type, halfBits);
  Value x0 = createAnd(builder, loc, type, value, mask);
  Value x1 = createShrU(builder, loc, type, value, shift);
  Value m0 = createScalarConstant(builder, loc, scalarElementType(type),
                                  multiplier & halfMask);
  Value m1 = createScalarConstant(builder, loc, scalarElementType(type),
                                  multiplier >> halfBits);

  Value p00 = createMul(builder, loc, type, x0, m0);
  Value p01 = createMul(builder, loc, type, x0, m1);
  Value p10 = createMul(builder, loc, type, x1, m0);
  Value p11 = createMul(builder, loc, type, x1, m1);
  Value p00Hi = createShrU(builder, loc, type, p00, shift);
  Value p01Lo = createAnd(builder, loc, type, p01, mask);
  Value p10Lo = createAnd(builder, loc, type, p10, mask);
  Value middle = createAdd(builder, loc, type, p00Hi, p01Lo);
  middle = createAdd(builder, loc, type, middle, p10Lo);

  Value hi = createAdd(builder, loc, type, p11,
                       createShrU(builder, loc, type, p01, shift));
  hi = createAdd(builder, loc, type, hi,
                 createShrU(builder, loc, type, p10, shift));
  return createAdd(builder, loc, type, hi,
                   createShrU(builder, loc, type, middle, shift));
}

static Value createUnsignedMagicQuotient(OpBuilder &builder, Location loc,
                                         Type type, Value numerator,
                                         uint64_t divisor,
                                         bool useNativeI32MulHi = false) {
  unsigned bits = elementBits(type);
  llvm::UnsignedDivisionByConstantInfo magics =
      llvm::UnsignedDivisionByConstantInfo::get(
          APInt(bits, maskToBits(divisor, bits)), /*LeadingZeros=*/0,
          /*AllowEvenDivisorOptimization=*/true,
          /*AllowWidenOptimization=*/false);

  Value q = numerator;
  if (magics.PreShift != 0)
    q = createShrU(builder, loc, type, q,
                   createShiftAmount(builder, loc, type, magics.PreShift));
  q = createUMulHi(builder, loc, type, q, magics.Magic.getZExtValue(),
                   useNativeI32MulHi);
  if (magics.IsAdd) {
    Value npq = createSub(builder, loc, type, numerator, q);
    npq = createShrU(builder, loc, type, npq,
                     createShiftAmount(builder, loc, type, 1));
    q = createAdd(builder, loc, type, npq, q);
  }
  if (magics.PostShift != 0)
    q = createShrU(builder, loc, type, q,
                   createShiftAmount(builder, loc, type, magics.PostShift));
  return q;
}

static std::optional<DivRemValues>
tryCreateUnsignedConstDivRem(OpBuilder &builder, Location loc, Type type,
                             Value numerator, uint64_t divisor,
                             bool useNativeI32MulHi = false) {
  unsigned bits = elementBits(type);
  divisor = maskToBits(divisor, bits);
  if (divisor == 0)
    return std::nullopt;
  if (divisor == 1)
    return DivRemValues{numerator, createConstantLike(builder, loc, type, 0)};
  if (llvm::isPowerOf2_64(divisor)) {
    unsigned shift = llvm::Log2_64(divisor);
    Value quotient = createShrU(builder, loc, type, numerator,
                                createShiftAmount(builder, loc, type, shift));
    Value remainder =
        createAnd(builder, loc, type, numerator,
                  createScalarConstant(builder, loc, scalarElementType(type),
                                       divisor - 1));
    return DivRemValues{quotient, remainder};
  }

  Value quotient = createUnsignedMagicQuotient(builder, loc, type, numerator,
                                               divisor, useNativeI32MulHi);
  Value scaled = createMul(
      builder, loc, type, quotient,
      createScalarConstant(builder, loc, scalarElementType(type), divisor));
  return DivRemValues{quotient,
                      createSub(builder, loc, type, numerator, scaled)};
}

static DivRemValues createUnsignedRestoringDivRem(OpBuilder &builder,
                                                  Location loc, Type type,
                                                  Value numerator,
                                                  Value divisor) {
  unsigned bits = elementBits(type);
  Value quotient = createConstantLike(builder, loc, type, 0);
  Value remainder = createConstantLike(builder, loc, type, 0);
  Value one = createScalarConstant(builder, loc, scalarElementType(type), 1);

  for (unsigned bit : llvm::reverse(llvm::seq<unsigned>(0, bits))) {
    Value shift = createShiftAmount(builder, loc, type, bit);
    Value nextBit =
        createAnd(builder, loc, type,
                  createShrU(builder, loc, type, numerator, shift), one);
    remainder = createOr(builder, loc, type,
                         createShl(builder, loc, type, remainder,
                                   createShiftAmount(builder, loc, type, 1)),
                         nextBit);

    Value take = createCompare(builder, loc, arith::CmpIPredicate::uge,
                               remainder, divisor, type);
    Value reduced = createSub(builder, loc, type, remainder, divisor);
    remainder = createSelect(builder, loc, type, take, reduced, remainder);
    Value withBit =
        createOr(builder, loc, type, quotient,
                 createConstantLike(builder, loc, type, uint64_t{1} << bit));
    quotient = createSelect(builder, loc, type, take, withBit, quotient);
  }

  return DivRemValues{quotient, remainder};
}

static DivRemValues createUnsignedI32DivRem(OpBuilder &builder, Location loc,
                                            Type type, Value numerator,
                                            Value divisor) {
  Value z = createURecip(builder, loc, type, divisor);
  Value negDivisor = createNeg(builder, loc, type, divisor);
  Value negYZ = createMul(builder, loc, type, negDivisor, z);
  z = createAdd(builder, loc, type, z,
                createMulHU(builder, loc, type, z, negYZ));

  Value quotient = createMulHU(builder, loc, type, numerator, z);
  Value remainder = createSub(builder, loc, type, numerator,
                              createMul(builder, loc, type, quotient, divisor));
  Value one = createConstantLike(builder, loc, type, 1);
  for ([[maybe_unused]] unsigned i : llvm::seq<unsigned>(0, 2)) {
    Value take = createCompare(builder, loc, arith::CmpIPredicate::uge,
                               remainder, divisor, type);
    quotient =
        createSelect(builder, loc, type, take,
                     createAdd(builder, loc, type, quotient, one), quotient);
    remainder = createSelect(builder, loc, type, take,
                             createSub(builder, loc, type, remainder, divisor),
                             remainder);
  }
  return DivRemValues{quotient, remainder};
}

static bool isFullSignedRange(const ConstantIntRanges &range) {
  unsigned width = range.smin().getBitWidth();
  if (width == 0)
    return true;
  return range.smin() == APInt::getSignedMinValue(width) &&
         range.smax() == APInt::getSignedMaxValue(width);
}

static bool isSignedI32RangeWithLowerBound(const ConstantIntRanges &range,
                                           int64_t lower) {
  unsigned width = range.smin().getBitWidth();
  APInt lowerBound(width, lower, /*isSigned=*/true);
  APInt upperBound = APInt::getSignedMaxValue(32).sextOrTrunc(width);
  return range.smin().sge(lowerBound) && range.smax().sle(upperBound);
}

static std::optional<ConstantIntRanges> integerRange(DataFlowSolver &solver,
                                                     Value value) {
  const dataflow::IntegerValueRangeLattice *lattice =
      solver.lookupState<dataflow::IntegerValueRangeLattice>(value);
  if (!lattice)
    return std::nullopt;
  IntegerValueRange ivr = lattice->getValue();
  if (ivr.isUninitialized())
    return std::nullopt;
  return ivr.getValue();
}

static std::optional<ConstantIntRanges>
finiteSignedRange(DataFlowSolver &solver, Value value) {
  std::optional<ConstantIntRanges> range = integerRange(solver, value);
  if (!range || isFullSignedRange(*range))
    return std::nullopt;
  return range;
}

static bool hasLowerBoundAtLeast(const sym::InferredRange &range,
                                 int64_t lower) {
  return range.lower && range.lower->denominator > 0 &&
         range.lower->numerator >= lower * range.lower->denominator;
}

static bool hasUpperBoundAtMost(const sym::InferredRange &range,
                                int64_t upper) {
  if (!range.upper || range.upper->denominator <= 0)
    return false;
  if (upper == std::numeric_limits<int64_t>::max())
    return true;
  int64_t quotient = range.upper->numerator / range.upper->denominator;
  int64_t remainder = range.upper->numerator % range.upper->denominator;
  if (remainder != 0 && range.upper->numerator > 0)
    ++quotient;
  return quotient <= upper;
}

static bool isAssumedAtLeast(sym::Store &store, Value value, int64_t lower) {
  while (AssumeOp assume = value.getDefiningOp<AssumeOp>()) {
    FailureOr<sym::ExprHandle> expr =
        sym::composeExprSym(store, assume.getName());
    if (failed(expr))
      return false;
    SmallVector<sym::PredHandle, 4> assumptions;
    for (Attribute attr : assume.getAssumptions())
      assumptions.push_back(cast<PredAttr>(attr).getValue());
    appendAssumePredicates(store, assume.getValue(), assume.getName(),
                           assumptions);
    std::optional<sym::InferredRange> range =
        sym::inferRange(store, *expr, assumptions);
    if (range && hasLowerBoundAtLeast(*range, lower))
      return true;
    value = assume.getValue();
  }
  return false;
}

static bool isAssumedAtMost(sym::Store &store, Value value, int64_t upper) {
  while (AssumeOp assume = value.getDefiningOp<AssumeOp>()) {
    FailureOr<sym::ExprHandle> expr =
        sym::composeExprSym(store, assume.getName());
    if (failed(expr))
      return false;
    SmallVector<sym::PredHandle, 4> assumptions;
    for (Attribute attr : assume.getAssumptions())
      assumptions.push_back(cast<PredAttr>(attr).getValue());
    appendAssumePredicates(store, assume.getValue(), assume.getName(),
                           assumptions);
    std::optional<sym::InferredRange> range =
        sym::inferRange(store, *expr, assumptions);
    if (range && hasUpperBoundAtMost(*range, upper))
      return true;
    value = assume.getValue();
  }
  return false;
}

static bool isIndexExprProvenAtLeast(sym::Store &store, Value value,
                                     int64_t lower) {
  IndexExprOp index = value.getDefiningOp<IndexExprOp>();
  if (!index)
    return false;

  SmallVector<sym::PredHandle, 4> assumptions;
  appendIndexExprPredicates(index, assumptions);
  for (auto [nameAttr, binding] :
       llvm::zip(index.getNames(), index.getBindings())) {
    StringRef name = cast<StringAttr>(nameAttr).getValue();
    appendAssumePredicates(store, binding, name, assumptions);
  }
  std::optional<sym::InferredRange> range =
      sym::inferRange(store, index.getExpr().getValue(), assumptions);
  return range && hasLowerBoundAtLeast(*range, lower);
}

static bool isIndexExprProvenAtMost(sym::Store &store, Value value,
                                    int64_t upper) {
  IndexExprOp index = value.getDefiningOp<IndexExprOp>();
  if (!index)
    return false;

  SmallVector<sym::PredHandle, 4> assumptions;
  appendIndexExprPredicates(index, assumptions);
  for (auto [nameAttr, binding] :
       llvm::zip(index.getNames(), index.getBindings())) {
    StringRef name = cast<StringAttr>(nameAttr).getValue();
    appendAssumePredicates(store, binding, name, assumptions);
  }
  std::optional<sym::InferredRange> range =
      sym::inferRange(store, index.getExpr().getValue(), assumptions);
  return range && hasUpperBoundAtMost(*range, upper);
}

static bool isProvenSignedLowerBound(DataFlowSolver &solver, sym::Store &store,
                                     Value value, int64_t lower);
static bool isProvenSignedUpperBound(DataFlowSolver &solver, sym::Store &store,
                                     Value value, int64_t upper);

static bool isConstantPositive(Value value) {
  std::optional<APInt> constant =
      getConstantAPInt(value, elementBits(value.getType()));
  return constant &&
         constant->sgt(APInt(constant->getBitWidth(), 0, /*isSigned=*/true));
}

static bool isProvenUnsignedUpperAtMostSignedMin(DataFlowSolver &solver,
                                                 sym::Store &store,
                                                 Value value) {
  if (SplatOp splat = value.getDefiningOp<SplatOp>())
    return isProvenUnsignedUpperAtMostSignedMin(solver, store,
                                                splat.getSource());

  unsigned bits = elementBits(value.getType());
  APInt signedMin = APInt::getSignedMinValue(bits);
  if (std::optional<APInt> constant = getConstantAPInt(value, bits))
    return constant->ule(signedMin);

  if (std::optional<ConstantIntRanges> range = integerRange(solver, value))
    if (range->umax().ule(signedMin))
      return true;

  int64_t signedMax = APInt::getSignedMaxValue(bits).getSExtValue();
  return isProvenSignedLowerBound(solver, store, value, 0) &&
         isProvenSignedUpperBound(solver, store, value, signedMax);
}

static bool isScfForIvProvenAtLeast(DataFlowSolver &solver, sym::Store &store,
                                    Value value, int64_t lower) {
  scf::ForOp loop = scf::getForInductionVarOwner(value);
  if (!loop)
    return false;
  if (!isConstantPositive(loop.getStep()))
    return false;
  if (loop.getUnsignedCmp())
    return isProvenSignedLowerBound(solver, store, loop.getLowerBound(),
                                    lower) &&
           isProvenUnsignedUpperAtMostSignedMin(solver, store,
                                                loop.getUpperBound());
  return isProvenSignedLowerBound(solver, store, loop.getLowerBound(), lower);
}

static bool isSignedIndexCastFromNoWiderInt(Value value, unsigned bits) {
  arith::IndexCastOp cast = value.getDefiningOp<arith::IndexCastOp>();
  if (!cast)
    return false;
  Type sourceType = scalarElementType(cast.getIn().getType());
  IntegerType sourceInt = dyn_cast<IntegerType>(sourceType);
  return sourceInt && sourceInt.getWidth() <= bits;
}

static bool isNarrowSignedIndexCastOfNonNegativeLoopIv(DataFlowSolver &solver,
                                                       sym::Store &store,
                                                       arith::IndexCastOp cast,
                                                       int64_t lower) {
  if (lower > 0)
    return false;
  Value source = cast.getIn();
  if (elementBits(source.getType()) <= elementBits(cast.getType()))
    return isProvenSignedLowerBound(solver, store, source, lower);

  scf::ForOp loop = scf::getForInductionVarOwner(source);
  if (!loop || loop.getUnsignedCmp() || !isConstantPositive(loop.getStep()))
    return false;
  if (!isProvenSignedLowerBound(solver, store, loop.getLowerBound(), 0))
    return false;
  return isSignedIndexCastFromNoWiderInt(loop.getUpperBound(),
                                         elementBits(cast.getType()));
}

static bool isNonNegativeWaveId(Value value) {
  return value.getDefiningOp<LaneIdOp>() ||
         value.getDefiningOp<WorkgroupIdOp>() ||
         value.getDefiningOp<WorkitemIdOp>();
}

static bool isProvenSignedLowerBoundFromDef(DataFlowSolver &solver,
                                            sym::Store &store, Value value,
                                            int64_t lower) {
  if (SplatOp splat = value.getDefiningOp<SplatOp>())
    return isProvenSignedLowerBound(solver, store, splat.getSource(), lower);
  if (arith::IndexCastOp cast = value.getDefiningOp<arith::IndexCastOp>())
    if (isNarrowSignedIndexCastOfNonNegativeLoopIv(solver, store, cast, lower))
      return true;
  return lower <= 0 && isNonNegativeWaveId(value);
}

static bool isProvenSignedLowerBoundByPredicate(DataFlowSolver &solver,
                                                sym::Store &store, Value value,
                                                int64_t lower) {
  if (isAssumedAtLeast(store, value, lower))
    return true;
  if (isIndexExprProvenAtLeast(store, value, lower))
    return true;
  return isScfForIvProvenAtLeast(solver, store, value, lower);
}

static bool isProvenSignedLowerBound(DataFlowSolver &solver, sym::Store &store,
                                     Value value, int64_t lower) {
  if (isProvenSignedLowerBoundFromDef(solver, store, value, lower))
    return true;
  if (std::optional<APInt> constant =
          getConstantAPInt(value, elementBits(value.getType())))
    return constant->sge(APInt(constant->getBitWidth(), lower,
                               /*isSigned=*/true));
  if (isProvenSignedLowerBoundByPredicate(solver, store, value, lower))
    return true;
  std::optional<ConstantIntRanges> range = finiteSignedRange(solver, value);
  return range && range->smin().sge(APInt(range->smin().getBitWidth(), lower,
                                          /*isSigned=*/true));
}

static bool isProvenSignedUpperBound(DataFlowSolver &solver, sym::Store &store,
                                     Value value, int64_t upper) {
  if (SplatOp splat = value.getDefiningOp<SplatOp>())
    return isProvenSignedUpperBound(solver, store, splat.getSource(), upper);
  if (std::optional<APInt> constant =
          getConstantAPInt(value, elementBits(value.getType())))
    return constant->sle(
        APInt(constant->getBitWidth(), upper, /*isSigned=*/true));
  if (isAssumedAtMost(store, value, upper))
    return true;
  if (isIndexExprProvenAtMost(store, value, upper))
    return true;
  std::optional<ConstantIntRanges> range = finiteSignedRange(solver, value);
  return range && range->smax().sle(APInt(range->smax().getBitWidth(), upper,
                                          /*isSigned=*/true));
}

static bool isProvenNonNegative(DataFlowSolver &solver, sym::Store &store,
                                Value value) {
  return isProvenSignedLowerBound(solver, store, value, 0);
}

static bool isProvenPositive(DataFlowSolver &solver, sym::Store &store,
                             Value value) {
  return isProvenSignedLowerBound(solver, store, value, 1);
}

struct DynamicDivisorQuery {
  SmallVector<sym::PredHandle, 4> assumptions;
  sym::ExprHandle expr;
};

class DynamicDivisorQueryBuilder {
public:
  explicit DynamicDivisorQueryBuilder(sym::Store &store) : store(store) {}

  FailureOr<DynamicDivisorQuery> build(Value value) {
    FailureOr<sym::ExprHandle> expr = buildValueExpr(value);
    if (failed(expr))
      return failure();
    return DynamicDivisorQuery{std::move(assumptions), *expr};
  }

private:
  FailureOr<sym::ExprHandle> buildValueExpr(Value value, unsigned depth = 0) {
    if (depth > 8)
      return failure();
    if (std::optional<APInt> constant =
            getConstantAPInt(value, elementBits(value.getType())))
      return sym::composeExprInt(store, constant->getSExtValue());
    if (SplatOp splat = value.getDefiningOp<SplatOp>())
      return buildValueExpr(splat.getSource(), depth + 1);
    if (BinaryOp binary = value.getDefiningOp<BinaryOp>())
      return buildBinaryExpr(binary, depth + 1);
    return bindSymbol(value);
  }

  FailureOr<sym::ExprHandle> buildBinaryExpr(BinaryOp op, unsigned depth) {
    if (op.getKind() == BinaryKind::ShLI)
      return buildShiftExpr(op, depth);
    std::optional<sym::ExprBinaryOp> kind = convertBinaryKind(op);
    if (!kind)
      return failure();
    FailureOr<sym::ExprHandle> lhs = buildValueExpr(op.getLhs(), depth);
    FailureOr<sym::ExprHandle> rhs = buildValueExpr(op.getRhs(), depth);
    if (failed(lhs) || failed(rhs))
      return failure();
    return sym::composeExprBinary(store, *lhs, *kind, *rhs);
  }

  FailureOr<sym::ExprHandle> buildShiftExpr(BinaryOp op, unsigned depth) {
    if (!op.hasNoSignedWrap())
      return failure();
    std::optional<APInt> shift =
        getConstantAPInt(op.getRhs(), elementBits(op.getRhs().getType()));
    if (!shift || shift->isNegative() || shift->uge(63))
      return failure();
    FailureOr<sym::ExprHandle> lhs = buildValueExpr(op.getLhs(), depth);
    if (failed(lhs))
      return failure();
    FailureOr<sym::ExprHandle> scale =
        sym::composeExprInt(store, int64_t{1} << shift->getZExtValue());
    if (failed(scale))
      return failure();
    return sym::composeExprBinary(store, *lhs, sym::ExprBinaryOp::Mul, *scale);
  }

  static std::optional<sym::ExprBinaryOp> convertBinaryKind(BinaryOp op) {
    switch (op.getKind()) {
    case BinaryKind::AddI:
      return op.hasNoSignedWrap()
                 ? std::optional<sym::ExprBinaryOp>(sym::ExprBinaryOp::Add)
                 : std::nullopt;
    case BinaryKind::SubI:
      return op.hasNoSignedWrap()
                 ? std::optional<sym::ExprBinaryOp>(sym::ExprBinaryOp::Sub)
                 : std::nullopt;
    case BinaryKind::MulI:
      return op.hasNoSignedWrap()
                 ? std::optional<sym::ExprBinaryOp>(sym::ExprBinaryOp::Mul)
                 : std::nullopt;
    case BinaryKind::XOrI:
      return sym::ExprBinaryOp::Xor;
    default:
      return std::nullopt;
    }
  }

  FailureOr<sym::ExprHandle> bindSymbol(Value value) {
    StringRef stem = "d";
    if (AssumeOp assume = value.getDefiningOp<AssumeOp>())
      stem = assume.getName();
    StringRef name =
        reserveIndexExprBindingName(stem, value, reserved, byValue);
    FailureOr<sym::ExprHandle> expr = sym::composeExprSym(store, name);
    if (failed(expr))
      return failure();
    appendAssumePredicates(store, value, name, assumptions);
    return *expr;
  }

  sym::Store &store;
  SmallVector<sym::PredHandle, 4> assumptions;
  llvm::StringMap<Value> reserved;
  llvm::DenseMap<Value, StringRef> byValue;
};

static bool isConstantInSignedI32RangeWithLowerBound(const APInt &constant,
                                                     int64_t lower) {
  unsigned bits = constant.getBitWidth();
  APInt lowerBound(bits, lower, /*isSigned=*/true);
  APInt upperBound = APInt::getSignedMaxValue(32).sextOrTrunc(bits);
  return constant.sge(lowerBound) && constant.sle(upperBound);
}

static bool isProvenSignedI32RangeWithLowerBound(DataFlowSolver &solver,
                                                 sym::Store &store, Value value,
                                                 int64_t lower) {
  if (SplatOp splat = value.getDefiningOp<SplatOp>())
    return isProvenSignedI32RangeWithLowerBound(solver, store,
                                                splat.getSource(), lower);
  if (std::optional<APInt> constant =
          getConstantAPInt(value, elementBits(value.getType())))
    return isConstantInSignedI32RangeWithLowerBound(*constant, lower);
  if (std::optional<ConstantIntRanges> range = finiteSignedRange(solver, value))
    if (isSignedI32RangeWithLowerBound(*range, lower))
      return true;

  FailureOr<DynamicDivisorQuery> query =
      DynamicDivisorQueryBuilder(store).build(value);
  return succeeded(query) &&
         sym::provablyInRange(store, query->expr, query->assumptions, lower,
                              signedI32Max);
}

static bool isProvenPositivePow2(sym::Store &store, Value source) {
  FailureOr<DynamicDivisorQuery> query =
      DynamicDivisorQueryBuilder(store).build(source);
  if (failed(query))
    return false;
  return sym::getPow2Fact(store, query->expr, query->assumptions) ==
         sym::Pow2Fact::Positive;
}

static std::optional<Value>
tryCreateDynamicPow2Value(OpBuilder &builder, Location loc, Type type,
                          BinaryKind kind, Value lhs, Value rhs, Value lhsProof,
                          Value rhsProof, DataFlowSolver &solver,
                          sym::Store &store) {
  if (getConstantAPInt(rhsProof, elementBits(type)))
    return std::nullopt;
  if (!isProvenPositivePow2(store, rhsProof))
    return std::nullopt;
  if (isSignedDivRem(kind) && !isProvenNonNegative(solver, store, lhsProof))
    return std::nullopt;

  if (kind == BinaryKind::DivUI || kind == BinaryKind::DivSI) {
    lhs = asType(builder, loc, lhs, type);
    Value shiftSource = rhs;
    if (SplatOp splat = rhs.getDefiningOp<SplatOp>())
      shiftSource = splat.getSource();
    return createShrU(builder, loc, type, lhs,
                      createCtz(builder, loc, shiftSource));
  }
  rhs = asType(builder, loc, rhs, type);
  Value mask = createSub(builder, loc, type, rhs,
                         createConstantLike(builder, loc, type, 1));
  return createAnd(builder, loc, type, lhs, mask);
}

static std::optional<Value>
tryCreateDynamicPow2Value(OpBuilder &builder, Location loc, Type type,
                          BinaryKind kind, Value lhs, Value rhs,
                          DataFlowSolver &solver, sym::Store &store) {
  return tryCreateDynamicPow2Value(builder, loc, type, kind, lhs, rhs, lhs, rhs,
                                   solver, store);
}

static DivRemValues createUnsignedDivRem(OpBuilder &builder, Location loc,
                                         Type type, Value numerator,
                                         Value divisor,
                                         bool useNativeI32ConstMulHi = false) {
  numerator = asType(builder, loc, numerator, type);
  divisor = asType(builder, loc, divisor, type);
  if (std::optional<APInt> constant =
          getConstantAPInt(divisor, elementBits(type)))
    if (std::optional<DivRemValues> result = tryCreateUnsignedConstDivRem(
            builder, loc, type, numerator, constant->getZExtValue(),
            useNativeI32ConstMulHi))
      return *result;
  if (elementBits(type) == 32)
    return createUnsignedI32DivRem(builder, loc, type, numerator, divisor);
  return createUnsignedRestoringDivRem(builder, loc, type, numerator, divisor);
}

static APInt signedAbs(APInt value) {
  if (value.isNegative())
    return -value;
  return value;
}

static std::optional<Value>
tryCreateSignedPositivePow2Value(OpBuilder &builder, Location loc, Type type,
                                 BinaryKind kind, Value lhs, APInt rhsConst) {
  if (rhsConst.isNegative() || rhsConst.isZero())
    return std::nullopt;
  uint64_t divisor = rhsConst.getZExtValue();
  if (!llvm::isPowerOf2_64(divisor))
    return std::nullopt;

  Value zero = createConstantLike(builder, loc, type, 0);
  if (divisor == 1)
    return kind == BinaryKind::DivSI ? asType(builder, loc, lhs, type) : zero;

  Value lhsNeg =
      createCompare(builder, loc, arith::CmpIPredicate::slt, lhs, zero, type);
  Value bias =
      createSelect(builder, loc, type, lhsNeg,
                   createConstantLike(builder, loc, type, divisor - 1), zero);
  unsigned shift = llvm::Log2_64(divisor);
  Value adjusted = createAdd(builder, loc, type, lhs, bias);
  Value quotient = createShrS(builder, loc, type, adjusted,
                              createShiftAmount(builder, loc, type, shift));
  if (kind == BinaryKind::DivSI)
    return quotient;

  Value scaled = createShl(builder, loc, type, quotient,
                           createShiftAmount(builder, loc, type, shift));
  return createSub(builder, loc, type, lhs, scaled);
}

static DivRemValues createSignedDivRem(OpBuilder &builder, Location loc,
                                       Type type, Value lhs, Value rhs) {
  lhs = asType(builder, loc, lhs, type);
  rhs = asType(builder, loc, rhs, type);
  unsigned bits = elementBits(type);
  Value zero = createConstantLike(builder, loc, type, 0);
  Value lhsNeg =
      createCompare(builder, loc, arith::CmpIPredicate::slt, lhs, zero, type);
  Value absLhs = createSelect(builder, loc, type, lhsNeg,
                              createNeg(builder, loc, type, lhs), lhs);

  std::optional<APInt> rhsConst = getConstantAPInt(rhs, bits);
  Value absRhs;
  if (rhsConst) {
    absRhs = createConstantLike(builder, loc, type,
                                signedAbs(*rhsConst).getZExtValue());
  } else {
    Value rhsNeg =
        createCompare(builder, loc, arith::CmpIPredicate::slt, rhs, zero, type);
    absRhs = createSelect(builder, loc, type, rhsNeg,
                          createNeg(builder, loc, type, rhs), rhs);
  }

  DivRemValues unsignedResult =
      createUnsignedDivRem(builder, loc, type, absLhs, absRhs,
                           /*useNativeI32ConstMulHi=*/rhsConst.has_value());
  Value signBits = createXor(builder, loc, type, lhs, rhs);
  Value quotientNeg = createCompare(builder, loc, arith::CmpIPredicate::slt,
                                    signBits, zero, type);
  Value quotient =
      createSelect(builder, loc, type, quotientNeg,
                   createNeg(builder, loc, type, unsignedResult.quotient),
                   unsignedResult.quotient);
  Value remainder =
      createSelect(builder, loc, type, lhsNeg,
                   createNeg(builder, loc, type, unsignedResult.remainder),
                   unsignedResult.remainder);
  return DivRemValues{quotient, remainder};
}

static Value createNonNegativeI32View(OpBuilder &builder, Location loc,
                                      Value value) {
  Type i32 = i32Like(builder, value.getType());
  if (std::optional<APInt> constant =
          getConstantAPInt(value, elementBits(value.getType())))
    return createConstantLike(builder, loc, i32, constant->getZExtValue());
  return CastOp::create(builder, loc, i32, CastKind::IntConvert, value,
                        DictionaryAttr())
      .getResult();
}

static DictionaryAttr createZeroExtendPolicy(OpBuilder &builder) {
  MLIRContext *context = builder.getContext();
  return builder.getDictionaryAttr(builder.getNamedAttr(
      "extension", CastExtensionPolicyAttr::get(context, CastExtension::Zero)));
}

static std::optional<Value> tryExpandIndexDivRemAsI32(IRRewriter &rewriter,
                                                      BinaryOp op,
                                                      DataFlowSolver &solver,
                                                      sym::Store &store) {
  if (!canNarrowDivRemTypeToI32(op.getResult().getType()))
    return std::nullopt;
  if (!isProvenSignedI32RangeWithLowerBound(solver, store, op.getLhs(), 0) ||
      !isProvenSignedI32RangeWithLowerBound(solver, store, op.getRhs(), 1))
    return std::nullopt;

  Location loc = op.getLoc();
  Type i32 = i32Like(rewriter, op.getResult().getType());
  BinaryKind kind = op.getKind();
  Value lhs = createNonNegativeI32View(rewriter, loc, op.getLhs());
  Value rhs = createNonNegativeI32View(rewriter, loc, op.getRhs());

  Value narrow;
  if (std::optional<Value> pow2 =
          tryCreateDynamicPow2Value(rewriter, loc, i32, kind, lhs, rhs,
                                    op.getLhs(), op.getRhs(), solver, store)) {
    narrow = *pow2;
  } else {
    DivRemValues result = createUnsignedDivRem(rewriter, loc, i32, lhs, rhs);
    narrow = (kind == BinaryKind::DivUI || kind == BinaryKind::DivSI)
                 ? result.quotient
                 : result.remainder;
  }
  return CastOp::create(rewriter, loc, op.getResult().getType(),
                        CastKind::IntConvert, narrow,
                        createZeroExtendPolicy(rewriter))
      .getResult();
}

static std::optional<Value>
tryCreateSignedAsUnsignedValue(IRRewriter &rewriter, BinaryOp op,
                               DataFlowSolver &solver, sym::Store &store) {
  BinaryKind kind = op.getKind();
  if (!isSignedDivRem(kind) ||
      !isProvenNonNegative(solver, store, op.getLhs()) ||
      !isProvenPositive(solver, store, op.getRhs()))
    return std::nullopt;

  DivRemValues result = createUnsignedDivRem(
      rewriter, op.getLoc(), op.getResult().getType(), op.getLhs(), op.getRhs(),
      /*useNativeI32ConstMulHi=*/true);
  return kind == BinaryKind::DivSI ? result.quotient : result.remainder;
}

static std::optional<Value> tryCreateSignedConstPow2Value(IRRewriter &rewriter,
                                                          BinaryOp op) {
  BinaryKind kind = op.getKind();
  if (!isSignedDivRem(kind))
    return std::nullopt;
  Type type = op.getResult().getType();
  std::optional<APInt> rhsConst =
      getConstantAPInt(op.getRhs(), elementBits(type));
  if (!rhsConst)
    return std::nullopt;
  return tryCreateSignedPositivePow2Value(rewriter, op.getLoc(), type, kind,
                                          op.getLhs(), *rhsConst);
}

static Value expandDivRem(IRRewriter &rewriter, BinaryOp op,
                          DataFlowSolver &solver, sym::Store &store) {
  Type type = op.getResult().getType();
  Location loc = op.getLoc();
  BinaryKind kind = op.getKind();
  if (std::optional<Value> narrow =
          tryExpandIndexDivRemAsI32(rewriter, op, solver, store))
    return *narrow;
  if (std::optional<Value> pow2 = tryCreateDynamicPow2Value(
          rewriter, loc, type, kind, op.getLhs(), op.getRhs(), solver, store))
    return *pow2;
  if (std::optional<Value> signedAsUnsigned =
          tryCreateSignedAsUnsignedValue(rewriter, op, solver, store))
    return *signedAsUnsigned;
  if (std::optional<Value> signedPow2 =
          tryCreateSignedConstPow2Value(rewriter, op))
    return *signedPow2;
  DivRemValues result =
      isSignedDivRem(kind)
          ? createSignedDivRem(rewriter, loc, type, op.getLhs(), op.getRhs())
          : createUnsignedDivRem(rewriter, loc, type, op.getLhs(), op.getRhs());
  if (kind == BinaryKind::DivUI || kind == BinaryKind::DivSI)
    return result.quotient;
  return result.remainder;
}

class WaveExpandIntegerDivRemPass
    : public wave::impl::WaveExpandIntegerDivRemBase<
          WaveExpandIntegerDivRemPass> {
public:
  void runOnOperation() override {
    Operation *root = getOperation();
    DataFlowSolver solver;
    solver.load<dataflow::IntegerRangeAnalysis>();
    if (failed(solver.initializeAndRun(root))) {
      root->emitError("IntegerRangeAnalysis failed for integer div/rem pass");
      return signalPassFailure();
    }

    sym::Store &store =
        root->getContext()->getLoadedDialect<WaveDialect>()->getSymbolStore();
    SmallVector<BinaryOp> ops;
    root->walk([&](BinaryOp op) {
      if (isDivRem(op.getKind()))
        ops.push_back(op);
    });
    for (BinaryOp op : ops) {
      if (elementBits(op.getResult().getType()) <= 64)
        continue;
      op.emitOpError("integer div/rem expansion supports at most 64-bit "
                     "elements");
      return signalPassFailure();
    }

    IRRewriter rewriter(root->getContext());
    for (BinaryOp op : ops) {
      if (!op->getBlock())
        continue;
      rewriter.setInsertionPoint(op);
      Value replacement = expandDivRem(rewriter, op, solver, store);
      rewriter.replaceOp(op, replacement);
    }
  }
};

} // namespace
