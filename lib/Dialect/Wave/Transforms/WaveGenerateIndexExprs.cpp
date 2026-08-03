//===- WaveGenerateIndexExprs.cpp - Symbolize address math ------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/Wave/Transforms/Passes.h"
#include "mlir/Dialect/Wave/Transforms/SymbolicValue.h"

#include "mlir/Analysis/DataFlow/IntegerRangeAnalysis.h"
#include "mlir/Analysis/DataFlow/Utils.h"
#include "mlir/Analysis/DataFlowFramework.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/SCF/IR/SCF.h"
#include "mlir/Dialect/Utils/StaticValueUtils.h"
#include "mlir/Dialect/Wave/IR/Wave.h"
#include "mlir/Dialect/Wave/IR/WaveAMD.h"
#include "mlir/IR/PatternMatch.h"
#include "mlir/Transforms/GreedyPatternRewriteDriver.h"
#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/DenseSet.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/ADT/StringMap.h"
#include "llvm/Support/MathExtras.h"

#include <algorithm>
#include <array>
#include <cassert>
#include <limits>
#include <optional>
#include <string>

namespace mlir::wave {
#define GEN_PASS_DEF_WAVEGENERATEINDEXEXPRS
#include "mlir/Dialect/Wave/Transforms/Passes.h.inc"
} // namespace mlir::wave

using namespace mlir;
using namespace mlir::wave;

namespace {

static constexpr unsigned kMaxSymbolicValueDepth = 64;

struct IndexExprBinding {
  std::string name;
  Value value;
};

struct BindingState {
  SmallVector<IndexExprBinding> bindings;
  SmallVector<sym::PredHandle> assumptions;
  llvm::DenseMap<Value, StringRef> byValue;
  llvm::StringMap<Value> reserved;
  llvm::StringMap<Value> emitted;
};

static StringRef symbolName(const SymbolicOffsetBinding &binding) {
  StringRef name = sym::ExprView(binding.name).getSymbolName();
  assert(!name.empty() && "symbolic offset binding must have a name");
  return name;
}

static FailureOr<sym::ExprHandle> symbolExpr(sym::Store &store,
                                             StringRef name) {
  return sym::composeExprSym(store, name);
}

static StringRef reserveBindingName(StringRef requested, Value value,
                                    BindingState &state) {
  return reserveIndexExprBindingName(requested, value, state.reserved,
                                     state.byValue);
}

static LogicalResult appendBinding(BindingState &state, StringRef name,
                                   Value value) {
  auto [it, inserted] = state.emitted.try_emplace(name, value);
  if (!inserted && it->second != value)
    return failure();
  if (!inserted)
    return success();
  state.bindings.push_back({name.str(), value});
  return success();
}

static FailureOr<sym::ExprHandle>
remapSymbolicOffset(sym::Store &store, const SymbolicOffset &offset,
                    BindingState &state) {
  SmallVector<sym::ExprSubstitution> substitutions;
  for (const SymbolicOffsetBinding &binding : offset.bindings) {
    StringRef oldName = symbolName(binding);
    StringRef newName = reserveBindingName(oldName, binding.value, state);
    if (failed(appendBinding(state, newName, binding.value)))
      return failure();
    if (newName == oldName)
      continue;

    FailureOr<sym::ExprHandle> target = symbolExpr(store, oldName);
    FailureOr<sym::ExprHandle> replacement = symbolExpr(store, newName);
    if (failed(target) || failed(replacement))
      return failure();
    substitutions.push_back({*target, *replacement});
  }

  if (substitutions.empty())
    llvm::append_range(state.assumptions, offset.assumptions);
  else {
    FailureOr<SmallVector<sym::PredHandle>> assumptions =
        substituteIndexExprPredicates(store, offset.assumptions, substitutions);
    if (failed(assumptions))
      return failure();
    llvm::append_range(state.assumptions, *assumptions);
  }

  if (substitutions.empty())
    return offset.expr;
  return sym::substituteExpr(store, offset.expr, substitutions);
}

static void appendNameRefs(ArrayRef<IndexExprBinding> bindings,
                           SmallVectorImpl<StringRef> &names) {
  for (const IndexExprBinding &binding : bindings)
    names.push_back(binding.name);
}

static void appendValues(ArrayRef<IndexExprBinding> bindings,
                         SmallVectorImpl<Value> &values) {
  for (const IndexExprBinding &binding : bindings)
    values.push_back(binding.value);
}

static void collectFreeSymbols(sym::ExprHandle expr,
                               llvm::DenseSet<StringRef> &symbols) {
  sym::walkSymbolNames(expr, [&](StringRef name) { symbols.insert(name); });
}

static SmallVector<IndexExprBinding>
collectLiveBindings(sym::ExprHandle expr, ArrayRef<IndexExprBinding> bindings) {
  llvm::DenseSet<StringRef> freeSymbols;
  collectFreeSymbols(expr, freeSymbols);

  SmallVector<IndexExprBinding> liveBindings;
  for (const IndexExprBinding &binding : bindings)
    if (freeSymbols.contains(binding.name))
      liveBindings.push_back(binding);
  return liveBindings;
}

static SmallVector<SymbolicOffsetBinding>
collectLiveBindings(sym::ExprHandle expr,
                    ArrayRef<SymbolicOffsetBinding> bindings) {
  llvm::DenseSet<StringRef> freeSymbols;
  collectFreeSymbols(expr, freeSymbols);

  SmallVector<SymbolicOffsetBinding> liveBindings;
  for (const SymbolicOffsetBinding &binding : bindings)
    if (freeSymbols.contains(symbolName(binding)))
      liveBindings.push_back(binding);
  return liveBindings;
}

static bool isSymbolicValueType(Type type, bool allowI64Integers) {
  if (type.isIndex())
    return true;
  if (auto intType = dyn_cast<IntegerType>(type))
    return intType.isSignless() &&
           (intType.getWidth() == 32 ||
            (allowI64Integers && intType.getWidth() == 64));
  if (auto simdType = dyn_cast<SimdType>(type)) {
    Type element = simdType.getElementType();
    return element.isIndex() || element.isInteger(32);
  }
  return false;
}

static bool isSignlessI32StorageType(Type type) {
  if (auto simd = dyn_cast<SimdType>(type))
    type = simd.getElementType();
  auto intType = dyn_cast<IntegerType>(type);
  return intType && intType.isSignless() && intType.getWidth() == 32;
}

static bool isSignlessI32SimdType(Type type) {
  return isa<SimdType>(type) && isSignlessI32StorageType(type);
}

static std::optional<int64_t> getPacketElementCount(Type type) {
  SimdType simd = dyn_cast<SimdType>(type);
  if (!simd)
    return std::nullopt;
  VectorType vector = dyn_cast<VectorType>(simd.getElementType());
  if (vector)
    return vector.getNumElements();
  return 1;
}

static Value getPackedElementAlias(Value source, int64_t index,
                                   Type resultType) {
  PackOp pack = source.getDefiningOp<PackOp>();
  if (!pack)
    return {};

  int64_t offset = 0;
  for (Value input : pack.getInputs()) {
    std::optional<int64_t> elements = getPacketElementCount(input.getType());
    if (!elements)
      return {};
    if (offset == index && input.getType() == resultType)
      return input;
    offset += *elements;
    if (offset > index)
      return {};
  }
  return {};
}

static Value getExtractedPackAlias(Value value) {
  ExtractOp extract = value.getDefiningOp<ExtractOp>();
  if (!extract)
    return {};
  return getPackedElementAlias(extract.getSource(), extract.getIndex(),
                               value.getType());
}

static Value getDirectRedistributeAlias(Value value) {
  RedistributeOp redistribute = value.getDefiningOp<RedistributeOp>();
  if (!redistribute || redistribute.getSource().getType() != value.getType() ||
      !isIdentityRedistribution(redistribute.getRelation()))
    return {};
  return redistribute.getSource();
}

static std::optional<int64_t>
getRedistributedSourceIndex(RedistributionAttr relation,
                            int64_t destinationIndex, sym::Store &store) {
  if (!isItemLocalRedistribution(relation))
    return std::nullopt;

  FailureOr<sym::ExprHandle> slot = sym::composeExprSym(store, "slot");
  FailureOr<sym::ExprHandle> index =
      sym::composeExprInt(store, destinationIndex);
  if (failed(slot) || failed(index))
    return std::nullopt;
  std::array<sym::ExprSubstitution, 1> substitutions{
      sym::ExprSubstitution{*slot, *index}};
  FailureOr<sym::ExprHandle> sourceSlot =
      sym::substituteExpr(store, relation.getSourceSlot(), substitutions);
  if (failed(sourceSlot))
    return std::nullopt;
  sourceSlot = sym::simplifyExpr(store, *sourceSlot);
  if (failed(sourceSlot))
    return std::nullopt;
  std::optional<int64_t> sourceIndex = sym::getIntegerLiteralValue(*sourceSlot);
  if (!sourceIndex || *sourceIndex < 0)
    return std::nullopt;
  return sourceIndex;
}

static Value getExtractedRedistributeAlias(Value value, sym::Store &store) {
  ExtractOp extract = value.getDefiningOp<ExtractOp>();
  if (!extract)
    return {};
  RedistributeOp redistribute =
      extract.getSource().getDefiningOp<RedistributeOp>();
  if (!redistribute)
    return {};

  std::optional<int64_t> sourceIndex = getRedistributedSourceIndex(
      redistribute.getRelation(), extract.getIndex(), store);
  if (!sourceIndex)
    return {};
  Value source = redistribute.getSource();
  if (*sourceIndex == 0 && source.getType() == value.getType())
    return source;
  return getPackedElementAlias(source, *sourceIndex, value.getType());
}

static Value getSymbolicAlias(Value value, sym::Store &store) {
  if (Value source = getDirectRedistributeAlias(value))
    return source;
  if (Value source = getExtractedPackAlias(value))
    return source;
  return getExtractedRedistributeAlias(value, store);
}

static Value peelSymbolicAliases(Value value, sym::Store &store) {
  while (Value source = getSymbolicAlias(value, store))
    value = source;
  return value;
}

static bool isPredicateImplied(sym::Store &store, sym::PredHandle pred,
                               ArrayRef<sym::PredHandle> assumptions) {
  return sym::checkPredicate(store, pred, assumptions) ==
         sym::CheckResult::True;
}

static LogicalResult
appendSignedRangeAssumption(sym::Store &store, StringRef name, int64_t lo,
                            int64_t hi,
                            SmallVectorImpl<sym::PredHandle> &assumptions) {
  FailureOr<sym::PredHandle> range = sym::rangeAssumption(store, name, lo, hi);
  if (failed(range))
    return failure();
  if (!isPredicateImplied(store, *range, assumptions))
    assumptions.push_back(*range);
  return success();
}

static LogicalResult appendSignedI32StorageRangeAssumption(
    sym::Store &store, StringRef name,
    SmallVectorImpl<sym::PredHandle> &assumptions) {
  return appendSignedRangeAssumption(store, name, -(int64_t{1} << 31),
                                     (int64_t{1} << 31) - 1, assumptions);
}

static bool isSymbolicBinaryOp(BinaryOp op, bool allowI64Integers) {
  return isSymbolicValueType(op.getResult().getType(), allowI64Integers) &&
         isSymbolicValueType(op.getLhs().getType(), allowI64Integers) &&
         isSymbolicValueType(op.getRhs().getType(), allowI64Integers);
}

static bool isNoSignedWrapSymbolicArithmetic(BinaryKind kind) {
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

static std::optional<int64_t> getSplatOrConstantInt(Value value) {
  if (std::optional<int64_t> constant = getConstantIntValue(value))
    return constant;
  if (ConstantOp constant = value.getDefiningOp<ConstantOp>()) {
    if (auto attr = dyn_cast<IntegerAttr>(constant.getValue())) {
      APInt intValue = attr.getValue();
      if (intValue.isSignedIntN(64))
        return intValue.getSExtValue();
    }
  }
  if (SplatOp splat = value.getDefiningOp<SplatOp>())
    return getSplatOrConstantInt(splat.getSource());
  return std::nullopt;
}

struct BooleanSelectComparison {
  SelectOp select;
  bool trueResult;
  bool falseResult;
};

static std::optional<BooleanSelectComparison>
matchBooleanSelectComparison(arith::CmpIPredicate predicate, Value lhs,
                             Value rhs, sym::Store &store) {
  bool isEqual = predicate == arith::CmpIPredicate::eq;
  if (!isEqual && predicate != arith::CmpIPredicate::ne)
    return std::nullopt;

  SelectOp select = peelSymbolicAliases(lhs, store).getDefiningOp<SelectOp>();
  Value compared = rhs;
  if (!select) {
    select = peelSymbolicAliases(rhs, store).getDefiningOp<SelectOp>();
    compared = lhs;
  }
  if (!select)
    return std::nullopt;

  std::optional<int64_t> trueValue =
      getSplatOrConstantInt(select.getTrueValue());
  std::optional<int64_t> falseValue =
      getSplatOrConstantInt(select.getFalseValue());
  std::optional<int64_t> comparedValue = getSplatOrConstantInt(compared);
  if (!trueValue || !falseValue || !comparedValue)
    return std::nullopt;

  return BooleanSelectComparison{select,
                                 isEqual == (*trueValue == *comparedValue),
                                 isEqual == (*falseValue == *comparedValue)};
}

static bool isFullSignedRange(const ConstantIntRanges &range) {
  unsigned width = range.smin().getBitWidth();
  if (width == 0)
    return true;
  return range.smin() == APInt::getSignedMinValue(width) &&
         range.smax() == APInt::getSignedMaxValue(width);
}

static std::optional<ConstantIntRanges>
finiteSignedRange(DataFlowSolver &solver, Value value) {
  const dataflow::IntegerValueRangeLattice *lattice =
      solver.lookupState<dataflow::IntegerValueRangeLattice>(value);
  if (!lattice)
    return std::nullopt;
  IntegerValueRange ivr = lattice->getValue();
  if (ivr.isUninitialized())
    return std::nullopt;
  ConstantIntRanges range = ivr.getValue();
  if (isFullSignedRange(range))
    return std::nullopt;
  return range;
}

static bool isPositivePowerOfTwo(int64_t value) {
  return value > 0 && llvm::isPowerOf2_64(static_cast<uint64_t>(value));
}

static std::optional<int64_t> getPowerOfTwoMaskModulus(int64_t mask) {
  if (mask < 0 || mask == std::numeric_limits<int64_t>::max())
    return std::nullopt;
  uint64_t modulus = static_cast<uint64_t>(mask) + 1;
  if (!llvm::isPowerOf2_64(modulus))
    return std::nullopt;
  if (modulus > static_cast<uint64_t>(std::numeric_limits<int64_t>::max()))
    return std::nullopt;
  return static_cast<int64_t>(modulus);
}

static std::optional<int64_t> getSExtI64(const APInt &value) {
  if (!value.isSignedIntN(64))
    return std::nullopt;
  return value.getSExtValue();
}

using SignedI64Range = std::pair<int64_t, int64_t>;

static SignedI64Range signedI32StorageRange() {
  return SignedI64Range{-(int64_t{1} << 31), (int64_t{1} << 31) - 1};
}

static std::optional<std::pair<int64_t, int64_t>>
finiteSignedI64Range(DataFlowSolver &solver, Value value) {
  std::optional<ConstantIntRanges> range = finiteSignedRange(solver, value);
  if (!range)
    return std::nullopt;
  std::optional<int64_t> lo = getSExtI64(range->smin());
  std::optional<int64_t> hi = getSExtI64(range->smax());
  if (!lo || !hi)
    return std::nullopt;
  return std::pair<int64_t, int64_t>{*lo, *hi};
}

static std::optional<int64_t> getKnownWorkgroupDim(Operation *op,
                                                   unsigned axis) {
  func::FuncOp func = op->getParentOfType<func::FuncOp>();
  if (!func || axis > 2)
    return std::nullopt;

  for (StringRef name : {"wave.workgroup_size", "gpu.known_block_size"}) {
    DenseI32ArrayAttr attr = func->getAttrOfType<DenseI32ArrayAttr>(name);
    if (!attr)
      continue;
    int64_t dim = axis < attr.size() ? attr.asArrayRef()[axis] : 1;
    if (dim > 0)
      return dim;
  }
  return std::nullopt;
}

static std::optional<SignedI64Range> workitemIdRange(WorkitemIdOp op) {
  std::optional<int64_t> dim =
      getKnownWorkgroupDim(op.getOperation(), op.getAxis());
  if (!dim)
    return std::nullopt;
  return SignedI64Range{0, *dim - 1};
}

static std::optional<SignedI64Range>
finiteAssumeSignedI64Range(sym::Store &store, AssumeOp assume) {
  FailureOr<sym::ExprHandle> expr =
      sym::composeExprSym(store, assume.getName());
  if (failed(expr))
    return std::nullopt;

  SmallVector<sym::PredHandle, 4> assumptions;
  for (Attribute attr : assume.getAssumptions())
    assumptions.push_back(cast<PredAttr>(attr).getValue());
  appendAssumePredicates(store, assume.getValue(), assume.getName(),
                         assumptions);

  std::optional<sym::InferredRange> range =
      sym::inferRange(store, *expr, assumptions);
  if (!range || !range->lower || !range->upper)
    return std::nullopt;
  std::optional<int64_t> lo = sym::floorEndpoint(*range->lower);
  std::optional<int64_t> hi = sym::ceilEndpoint(*range->upper);
  if (!lo || !hi)
    return std::nullopt;
  return SignedI64Range{*lo, *hi};
}

static std::optional<SignedI64Range>
inferSignedI64Range(sym::Store &store, sym::ExprHandle expr,
                    ArrayRef<sym::PredHandle> assumptions) {
  std::optional<sym::InferredRange> range =
      sym::inferRange(store, expr, assumptions);
  if (!range || !range->lower || !range->upper)
    return std::nullopt;
  std::optional<int64_t> lo = sym::floorEndpoint(*range->lower);
  std::optional<int64_t> hi = sym::ceilEndpoint(*range->upper);
  if (!lo || !hi)
    return std::nullopt;
  return SignedI64Range{*lo, *hi};
}

static LogicalResult
appendExprSignedRangeAssumption(sym::Store &store, sym::ExprHandle expr,
                                SignedI64Range range,
                                SmallVectorImpl<sym::PredHandle> &assumptions) {
  constexpr llvm::StringLiteral resultName = "__wave_generated_result";
  FailureOr<sym::ExprHandle> result = symbolExpr(store, resultName);
  FailureOr<sym::PredHandle> resultRange =
      sym::rangeAssumption(store, resultName, range.first, range.second);
  if (failed(result) || failed(resultRange))
    return failure();
  std::array<sym::ExprSubstitution, 1> substitution{
      sym::ExprSubstitution{*result, expr}};
  FailureOr<sym::PredHandle> remapped =
      sym::substitutePred(store, *resultRange, substitution);
  if (failed(remapped))
    return failure();
  if (!isPredicateImplied(store, *remapped, assumptions))
    assumptions.push_back(*remapped);
  return success();
}

static std::optional<SignedI64Range>
intersectRange(std::optional<SignedI64Range> lhs,
               std::optional<SignedI64Range> rhs) {
  if (!lhs)
    return rhs;
  if (!rhs)
    return lhs;
  SignedI64Range result{std::max(lhs->first, rhs->first),
                        std::min(lhs->second, rhs->second)};
  if (result.first > result.second)
    return std::nullopt;
  return result;
}

static unsigned elementStorageBitWidth(Type type) {
  if (auto simd = dyn_cast<SimdType>(type))
    type = simd.getElementType();
  return ConstantIntRanges::getStorageBitwidth(type);
}

static bool fitsSignedWidth(__int128 value, unsigned bits) {
  if (bits == 0)
    return false;
  __int128 min = -(__int128{1} << (bits - 1));
  __int128 max = (__int128{1} << (bits - 1)) - 1;
  return value >= min && value <= max;
}

static bool fitsSignedWidth(std::pair<__int128, __int128> range,
                            unsigned bits) {
  return fitsSignedWidth(range.first, bits) &&
         fitsSignedWidth(range.second, bits);
}

static std::pair<__int128, __int128> addRange(std::pair<int64_t, int64_t> lhs,
                                              std::pair<int64_t, int64_t> rhs) {
  return {__int128(lhs.first) + rhs.first, __int128(lhs.second) + rhs.second};
}

static std::pair<__int128, __int128> subRange(std::pair<int64_t, int64_t> lhs,
                                              std::pair<int64_t, int64_t> rhs) {
  return {__int128(lhs.first) - rhs.second, __int128(lhs.second) - rhs.first};
}

static std::pair<__int128, __int128> mulRange(std::pair<int64_t, int64_t> lhs,
                                              std::pair<int64_t, int64_t> rhs) {
  std::array<__int128, 4> products{
      __int128(lhs.first) * rhs.first, __int128(lhs.first) * rhs.second,
      __int128(lhs.second) * rhs.first, __int128(lhs.second) * rhs.second};
  return {*std::min_element(products.begin(), products.end()),
          *std::max_element(products.begin(), products.end())};
}

static std::optional<std::pair<__int128, __int128>>
shlRange(BinaryOp op, std::pair<int64_t, int64_t> lhs) {
  std::optional<int64_t> shift = getSplatOrConstantInt(op.getRhs());
  if (!shift || *shift < 0 || *shift >= 63)
    return std::nullopt;
  __int128 scale = __int128{1} << *shift;
  return std::pair<__int128, __int128>{__int128(lhs.first) * scale,
                                       __int128(lhs.second) * scale};
}

static std::optional<std::pair<__int128, __int128>>
xorRange(std::pair<int64_t, int64_t> lhs, std::pair<int64_t, int64_t> rhs) {
  if (lhs.first < 0 || rhs.first < 0)
    return std::nullopt;
  uint64_t maxOperand = std::max(static_cast<uint64_t>(lhs.second),
                                 static_cast<uint64_t>(rhs.second));
  if (maxOperand == 0)
    return std::pair<__int128, __int128>{0, 0};
  unsigned bits = llvm::Log2_64(maxOperand) + 1;
  return std::pair<__int128, __int128>{0, (__int128{1} << bits) - 1};
}

static std::optional<std::pair<__int128, __int128>>
resultRange(BinaryOp op, std::pair<int64_t, int64_t> lhs,
            std::pair<int64_t, int64_t> rhs) {
  switch (op.getKind()) {
  case BinaryKind::AddI:
    return addRange(lhs, rhs);
  case BinaryKind::SubI:
    return subRange(lhs, rhs);
  case BinaryKind::MulI:
    return mulRange(lhs, rhs);
  case BinaryKind::ShLI:
    return shlRange(op, lhs);
  default:
    return std::nullopt;
  }
}

static std::optional<SignedI64Range>
narrowRange(std::pair<__int128, __int128> range, unsigned bits) {
  if (!fitsSignedWidth(range, bits) || !fitsSignedWidth(range, 64))
    return std::nullopt;
  return SignedI64Range{static_cast<int64_t>(range.first),
                        static_cast<int64_t>(range.second)};
}

static std::optional<SignedI64Range> computeNoWrapRange(BinaryOp binary,
                                                        SignedI64Range lhs,
                                                        SignedI64Range rhs,
                                                        unsigned bits) {
  std::optional<std::pair<__int128, __int128>> range =
      resultRange(binary, lhs, rhs);
  if (!range)
    return std::nullopt;
  return narrowRange(*range, bits);
}

static std::optional<SignedI64Range>
computeXorRange(SignedI64Range lhs, SignedI64Range rhs, unsigned bits) {
  std::optional<std::pair<__int128, __int128>> range = xorRange(lhs, rhs);
  if (!range)
    return std::nullopt;
  return narrowRange(*range, bits);
}

static std::optional<SignedI64Range> computeDivSIRange(BinaryOp binary,
                                                       SignedI64Range lhs) {
  std::optional<int64_t> divisor = getSplatOrConstantInt(binary.getRhs());
  if (!divisor || !isPositivePowerOfTwo(*divisor) || lhs.first < 0)
    return std::nullopt;
  return SignedI64Range{lhs.first / *divisor, lhs.second / *divisor};
}

static std::optional<SignedI64Range> computeDivUIRange(SignedI64Range lhs,
                                                       SignedI64Range rhs) {
  if (lhs.first < 0 || rhs.first <= 0)
    return std::nullopt;
  return SignedI64Range{lhs.first / rhs.second, lhs.second / rhs.first};
}

static std::optional<SignedI64Range> computeRemUIRange(SignedI64Range lhs,
                                                       SignedI64Range rhs) {
  if (lhs.first < 0 || rhs.first <= 0)
    return std::nullopt;
  return SignedI64Range{0, std::min(lhs.second, rhs.second - 1)};
}

static std::optional<SignedI64Range> computeShruiRange(BinaryOp binary,
                                                       SignedI64Range lhs) {
  std::optional<int64_t> shift = getSplatOrConstantInt(binary.getRhs());
  if (!shift || *shift < 0 || *shift >= 63 || lhs.first < 0)
    return std::nullopt;
  int64_t divisor = int64_t{1} << *shift;
  return SignedI64Range{lhs.first / divisor, lhs.second / divisor};
}

static std::optional<SignedI64Range>
computeAndIRange(BinaryOp binary, SignedI64Range lhs, SignedI64Range rhs) {
  std::optional<int64_t> mask = getSplatOrConstantInt(binary.getRhs());
  std::optional<SignedI64Range> maskedRange = lhs;
  if (!mask) {
    mask = getSplatOrConstantInt(binary.getLhs());
    maskedRange = rhs;
  }
  std::optional<int64_t> modulus =
      mask ? getPowerOfTwoMaskModulus(*mask) : std::nullopt;
  if (!modulus || !maskedRange || maskedRange->first < 0)
    return std::nullopt;
  return SignedI64Range{0, std::min(maskedRange->second, *modulus - 1)};
}

static std::optional<SignedI64Range>
computeBinarySignedI64Range(BinaryOp binary, SignedI64Range lhs,
                            SignedI64Range rhs, unsigned bits,
                            DataFlowSolver &solver, Value value) {
  if (isNoSignedWrapSymbolicArithmetic(binary.getKind()))
    return computeNoWrapRange(binary, lhs, rhs, bits);

  switch (binary.getKind()) {
  case BinaryKind::XOrI:
    if (std::optional<SignedI64Range> range = computeXorRange(lhs, rhs, bits))
      return range;
    return finiteSignedI64Range(solver, value);
  case BinaryKind::DivSI:
    return computeDivSIRange(binary, lhs);
  case BinaryKind::DivUI:
    return computeDivUIRange(lhs, rhs);
  case BinaryKind::RemUI:
    return computeRemUIRange(lhs, rhs);
  case BinaryKind::ShRUI:
    return computeShruiRange(binary, lhs);
  case BinaryKind::AndI:
    return computeAndIRange(binary, lhs, rhs);
  default:
    return finiteSignedI64Range(solver, value);
  }
}

static std::optional<SignedI64Range>
computeSignedI64Range(Value value, DataFlowSolver &solver, sym::Store &store,
                      unsigned depth);

static std::optional<SignedI64Range>
computeIndexExprSignedI64Range(IndexExprOp op, DataFlowSolver &solver,
                               sym::Store &store, unsigned depth) {
  SmallVector<sym::PredHandle, 4> assumptions;
  appendIndexExprPredicates(op, assumptions);
  for (auto [nameAttr, binding] : llvm::zip(op.getNames(), op.getBindings())) {
    StringRef name = cast<StringAttr>(nameAttr).getValue();
    appendAssumePredicates(store, binding, name, assumptions);
    std::optional<SignedI64Range> range =
        computeSignedI64Range(binding, solver, store, depth + 1);
    if (range && failed(appendSignedRangeAssumption(
                     store, name, range->first, range->second, assumptions)))
      return std::nullopt;
  }
  return inferSignedI64Range(store, op.getExpr().getValue(), assumptions);
}

static std::optional<SignedI64Range>
computeBinaryValueSignedI64Range(BinaryOp binary, DataFlowSolver &solver,
                                 sym::Store &store, unsigned depth) {
  unsigned bits = elementStorageBitWidth(binary.getResult().getType());
  if (bits == 0 || bits > 64)
    return std::nullopt;

  std::optional<SignedI64Range> lhs =
      computeSignedI64Range(binary.getLhs(), solver, store, depth + 1);
  std::optional<SignedI64Range> rhs =
      computeSignedI64Range(binary.getRhs(), solver, store, depth + 1);
  if (!lhs || !rhs)
    return finiteSignedI64Range(solver, binary.getResult());
  return computeBinarySignedI64Range(binary, *lhs, *rhs, bits, solver,
                                     binary.getResult());
}

static std::optional<SignedI64Range>
computeSelectValueSignedI64Range(SelectOp select, DataFlowSolver &solver,
                                 sym::Store &store, unsigned depth) {
  std::optional<SignedI64Range> trueRange =
      computeSignedI64Range(select.getTrueValue(), solver, store, depth + 1);
  std::optional<SignedI64Range> falseRange =
      computeSignedI64Range(select.getFalseValue(), solver, store, depth + 1);
  if (!trueRange || !falseRange)
    return finiteSignedI64Range(solver, select.getResult());
  return SignedI64Range{std::min(trueRange->first, falseRange->first),
                        std::max(trueRange->second, falseRange->second)};
}

static std::optional<SignedI64Range>
computeLeafSignedI64Range(Value value, DataFlowSolver &solver) {
  if (std::optional<int64_t> constant = getSplatOrConstantInt(value))
    return SignedI64Range{*constant, *constant};
  if (WorkitemIdOp workitem = value.getDefiningOp<WorkitemIdOp>())
    if (std::optional<SignedI64Range> range = workitemIdRange(workitem))
      return range;
  return finiteSignedI64Range(solver, value);
}

static std::optional<SignedI64Range>
computeSignedI64Range(Value value, DataFlowSolver &solver, sym::Store &store,
                      unsigned depth = 0) {
  if (depth > kMaxSymbolicValueDepth)
    return std::nullopt;
  if (AssumeOp assume = value.getDefiningOp<AssumeOp>())
    return intersectRange(
        computeSignedI64Range(assume.getValue(), solver, store, depth + 1),
        finiteAssumeSignedI64Range(store, assume));
  if (SplatOp splat = value.getDefiningOp<SplatOp>())
    return computeSignedI64Range(splat.getSource(), solver, store, depth + 1);
  if (IndexExprOp indexExpr = value.getDefiningOp<IndexExprOp>()) {
    if (std::optional<SignedI64Range> range =
            finiteSignedI64Range(solver, value))
      return range;
    return computeIndexExprSignedI64Range(indexExpr, solver, store, depth);
  }
  if (BinaryOp binary = value.getDefiningOp<BinaryOp>())
    return computeBinaryValueSignedI64Range(binary, solver, store, depth);
  if (SelectOp select = value.getDefiningOp<SelectOp>())
    return computeSelectValueSignedI64Range(select, solver, store, depth);

  return computeLeafSignedI64Range(value, solver);
}

static bool
rangeProvesNoSignedOverflow(BinaryOp op, DataFlowSolver &solver,
                            sym::Store &store,
                            bool assumeAddressArithmeticNoOverflow = false) {
  if (op.hasNoSignedWrap() || assumeAddressArithmeticNoOverflow)
    return true;

  unsigned bits = elementStorageBitWidth(op.getResult().getType());
  if (bits == 0 || bits > 64)
    return false;

  std::optional<SignedI64Range> lhs =
      computeSignedI64Range(op.getLhs(), solver, store);
  std::optional<SignedI64Range> rhs =
      computeSignedI64Range(op.getRhs(), solver, store);
  if (!lhs || !rhs)
    return false;

  std::optional<std::pair<__int128, __int128>> range =
      resultRange(op, *lhs, *rhs);
  return range && fitsSignedWidth(*range, bits);
}

static bool canBuildSymbolicBinaryOp(BinaryOp op, bool allowI64Integers,
                                     DataFlowSolver &solver, sym::Store &store,
                                     bool assumeAddressArithmeticNoOverflow) {
  if (!isSymbolicBinaryOp(op, allowI64Integers))
    return false;
  if (isNoSignedWrapSymbolicArithmetic(op.getKind()))
    return rangeProvesNoSignedOverflow(op, solver, store,
                                       assumeAddressArithmeticNoOverflow);
  switch (op.getKind()) {
  case BinaryKind::XOrI:
  case BinaryKind::ShRUI:
  case BinaryKind::AndI:
    return true;
  case BinaryKind::DivSI:
  case BinaryKind::DivUI:
  case BinaryKind::RemUI:
    // Dynamic div/rem stay SSA: shared lowering must not be duplicated.
    return getSplatOrConstantInt(op.getRhs()).has_value();
  default:
    return false;
  }
}

static std::optional<sym::PredCmpOp>
convertSignedCmpPredicate(arith::CmpIPredicate predicate) {
  switch (predicate) {
  case arith::CmpIPredicate::eq:
    return sym::PredCmpOp::Eq;
  case arith::CmpIPredicate::ne:
    return sym::PredCmpOp::Ne;
  case arith::CmpIPredicate::slt:
    return sym::PredCmpOp::Lt;
  case arith::CmpIPredicate::sle:
    return sym::PredCmpOp::Le;
  case arith::CmpIPredicate::sgt:
    return sym::PredCmpOp::Gt;
  case arith::CmpIPredicate::sge:
    return sym::PredCmpOp::Ge;
  default:
    return std::nullopt;
  }
}

static std::optional<sym::PredCmpOp>
convertUnsignedCmpPredicate(arith::CmpIPredicate predicate) {
  switch (predicate) {
  case arith::CmpIPredicate::ult:
    return sym::PredCmpOp::Lt;
  case arith::CmpIPredicate::ule:
    return sym::PredCmpOp::Le;
  case arith::CmpIPredicate::ugt:
    return sym::PredCmpOp::Gt;
  case arith::CmpIPredicate::uge:
    return sym::PredCmpOp::Ge;
  default:
    return std::nullopt;
  }
}

static bool hasUnsignedCmpDomain(Value lhsValue, Value rhsValue,
                                 DataFlowSolver &solver, sym::Store &store) {
  std::optional<SignedI64Range> lhs =
      computeSignedI64Range(lhsValue, solver, store);
  std::optional<SignedI64Range> rhs =
      computeSignedI64Range(rhsValue, solver, store);
  return lhs && rhs && lhs->first >= 0 && rhs->first >= 0;
}

static std::optional<sym::PredCmpOp>
convertCmpPredicate(arith::CmpIPredicate predicate, Value lhs, Value rhs,
                    DataFlowSolver &solver, sym::Store &store) {
  if (std::optional<sym::PredCmpOp> converted =
          convertSignedCmpPredicate(predicate))
    return converted;
  if (!hasUnsignedCmpDomain(lhs, rhs, solver, store))
    return std::nullopt;
  return convertUnsignedCmpPredicate(predicate);
}

static std::optional<sym::PredCmpOp>
convertCmpPredicate(CmpIOp op, DataFlowSolver &solver, sym::Store &store) {
  return convertCmpPredicate(op.getPredicate(), op.getLhs(), op.getRhs(),
                             solver, store);
}

static bool canBuildSymbolicCmp(CmpIOp op, bool allowI64Integers,
                                DataFlowSolver &solver, sym::Store &store) {
  return isSymbolicValueType(op.getLhs().getType(), allowI64Integers) &&
         isSymbolicValueType(op.getRhs().getType(), allowI64Integers) &&
         convertCmpPredicate(op, solver, store).has_value();
}

static bool isSymbolicSelectOp(SelectOp op, bool allowI64Integers,
                               DataFlowSolver &solver, sym::Store &store) {
  if (!isSymbolicValueType(op.getType(), allowI64Integers) ||
      !isSymbolicValueType(op.getTrueValue().getType(), allowI64Integers) ||
      !isSymbolicValueType(op.getFalseValue().getType(), allowI64Integers))
    return false;
  if (!isa<MaskType>(op.getCondition().getType()))
    return false;
  CmpIOp cmp = op.getCondition().getDefiningOp<CmpIOp>();
  return cmp && canBuildSymbolicCmp(cmp, allowI64Integers, solver, store);
}

class SymbolicValueBuilder {
public:
  explicit SymbolicValueBuilder(WaveDialect &dialect, DataFlowSolver &solver,
                                bool allowI64Integers = false,
                                bool assumeI32StorageRange = false,
                                bool bindI32Root = false,
                                bool requireI32RootRange = false,
                                bool expandIndexExprRoot = false,
                                bool foldWaveConstants = false,
                                bool allowWrappingArithmetic = false,
                                bool modelWrappingArithmetic = false,
                                bool assumeAddressArithmeticNoOverflow = false)
      : dialect(dialect), solver(solver), store(dialect.getSymbolStore()),
        allowI64Integers(allowI64Integers),
        assumeI32StorageRange(assumeI32StorageRange), bindI32Root(bindI32Root),
        requireI32RootRange(requireI32RootRange),
        expandIndexExprRoot(expandIndexExprRoot),
        foldWaveConstants(foldWaveConstants),
        allowWrappingArithmetic(allowWrappingArithmetic),
        modelWrappingArithmetic(modelWrappingArithmetic),
        assumeAddressArithmeticNoOverflow(assumeAddressArithmeticNoOverflow) {}

  FailureOr<std::optional<SymbolicOffset>> build(Value value) {
    return build(value, /*allowRootLeaf=*/false);
  }

  FailureOr<std::optional<SymbolicOffset>> buildAllowingRootLeaf(Value value) {
    return build(value, /*allowRootLeaf=*/true);
  }

  FailureOr<std::optional<SymbolicPredicate>> buildPredicate(Value value) {
    bool skip = false;
    FailureOr<sym::PredHandle> predicate = buildPredicateExpr(value, skip, 0);
    if (skip)
      return std::optional<SymbolicPredicate>{};
    if (failed(predicate))
      return failure();
    FailureOr<sym::PredHandle> simplified =
        sym::simplifyPred(store, *predicate);
    if (failed(simplified))
      return failure();
    SymbolicPredicate result;
    result.bindings = std::move(offset.bindings);
    result.assumptions = std::move(offset.assumptions);
    result.predicate = *simplified;
    return std::optional<SymbolicPredicate>{std::move(result)};
  }

  bool canExpand(Value value) { return hasSymbolicRoot(value); }

private:
  struct LoopCarriedRecurrence {
    scf::ForOp loop;
    Value init;
    Value stride;
    bool subtractStride = false;
  };

  struct LoopCarriedUpdate {
    scf::ForOp loop;
    BinaryOp update;
    unsigned index;
  };

  static bool isWrappingArithmeticKind(BinaryKind kind) {
    return kind == BinaryKind::AddI || kind == BinaryKind::SubI ||
           kind == BinaryKind::MulI;
  }

  bool canBuildBinary(BinaryOp op) {
    if (canBuildSymbolicBinaryOp(op, allowI64Integers, solver, store,
                                 assumeAddressArithmeticNoOverflow))
      return true;
    if ((!allowWrappingArithmetic && !modelWrappingArithmetic) ||
        !isSignlessI32StorageType(op.getResult().getType()))
      return false;
    return isWrappingArithmeticKind(op.getKind());
  }

  bool shouldModelWrappingBinary(BinaryOp op) {
    return modelWrappingArithmetic && isWrappingArithmeticKind(op.getKind()) &&
           !rangeProvesNoSignedOverflow(op, solver, store,
                                        assumeAddressArithmeticNoOverflow);
  }

  static bool isMaskSelect(SelectOp select) {
    return select && isa<MaskType>(select.getType()) &&
           isa<MaskType>(select.getCondition().getType()) &&
           isa<MaskType>(select.getTrueValue().getType()) &&
           isa<MaskType>(select.getFalseValue().getType());
  }

  template <typename T>
  static bool failedOrSkipped(const FailureOr<T> &value, bool skip) {
    return skip || failed(value);
  }

  FailureOr<sym::PredHandle> buildSelectPredicate(SelectOp select, bool &skip,
                                                  unsigned depth) {
    FailureOr<sym::PredHandle> condition =
        buildPredicateExpr(select.getCondition(), skip, depth + 1);
    if (failedOrSkipped(condition, skip))
      return failure();
    FailureOr<sym::PredHandle> truePredicate =
        buildPredicateExpr(select.getTrueValue(), skip, depth + 1);
    if (failedOrSkipped(truePredicate, skip))
      return failure();
    FailureOr<sym::PredHandle> falsePredicate =
        buildPredicateExpr(select.getFalseValue(), skip, depth + 1);
    if (failedOrSkipped(falsePredicate, skip))
      return failure();

    FailureOr<sym::PredHandle> activeTrue =
        sym::composePredAnd(store, *condition, *truePredicate);
    FailureOr<sym::PredHandle> notCondition =
        sym::composePredNot(store, *condition);
    if (failed(activeTrue) || failed(notCondition))
      return failure();
    FailureOr<sym::PredHandle> activeFalse =
        sym::composePredAnd(store, *notCondition, *falsePredicate);
    if (failed(activeFalse))
      return failure();
    return sym::composePredOr(store, *activeTrue, *activeFalse);
  }

  FailureOr<sym::PredHandle> buildPredicateExpr(Value value, bool &skip,
                                                unsigned depth) {
    if (depth > kMaxSymbolicValueDepth) {
      skip = true;
      return failure();
    }
    if (CmpIOp cmp = value.getDefiningOp<CmpIOp>())
      return buildCmpPredicate(cmp, skip, depth + 1);
    if (arith::CmpIOp cmp = value.getDefiningOp<arith::CmpIOp>())
      return buildCmpPredicate(cmp.getPredicate(), cmp.getLhs(), cmp.getRhs(),
                               skip, depth + 1);
    if (std::optional<int64_t> constant = getSplatOrConstantInt(value)) {
      if (*constant == 0)
        return sym::composePredFalse(store);
      if (*constant == 1)
        return sym::composePredTrue(store);
    }
    SelectOp select = value.getDefiningOp<SelectOp>();
    if (!isMaskSelect(select)) {
      skip = true;
      return failure();
    }
    return buildSelectPredicate(select, skip, depth);
  }

  FailureOr<std::optional<SymbolicOffset>> build(Value value,
                                                 bool allowRootLeaf) {
    bool hasRoot = hasSymbolicRoot(value);
    if (!hasRoot && !allowRootLeaf)
      return std::optional<SymbolicOffset>{};

    bool skip = false;
    FailureOr<sym::ExprHandle> expr =
        buildRootExpr(value, hasRoot, allowRootLeaf, skip);
    if (skip)
      return std::optional<SymbolicOffset>{};
    if (failed(expr))
      return failure();
    FailureOr<sym::ExprHandle> simplified = simplifyBuiltExpr(*expr);
    if (failed(simplified))
      return failure();
    offset.expr = *simplified;
    return std::optional<SymbolicOffset>{std::move(offset)};
  }

  FailureOr<sym::ExprHandle> buildRootExpr(Value value, bool hasRoot,
                                           bool allowRootLeaf, bool &skip) {
    bool allowLeaf = allowRootLeaf && !hasRoot;
    if (!bindI32Root || !isSignlessI32StorageType(value.getType()))
      return buildExpr(value, skip, allowLeaf);

    std::optional<SignedI64Range> rootRange = inferI32RootRange(value);
    if (rootRange || !requireI32RootRange)
      return bindSymbol(value, skip, rootRange);
    return buildExpr(value, skip, false);
  }

  FailureOr<sym::ExprHandle> simplifyBuiltExpr(sym::ExprHandle expr) {
    FailureOr<sym::ExprHandle> simplified =
        offset.assumptions.empty()
            ? sym::simplifyExpr(store, expr)
            : sym::simplifyExpr(store, expr, offset.assumptions);
    if (failed(simplified) || !shouldUseSimplifiedIndexExpr(*simplified, expr))
      return expr;
    return *simplified;
  }

  bool hasSymbolicRoot(Value value) {
    if (Value source = getSymbolicAlias(value, store))
      return hasSymbolicRoot(source);
    if (value.getDefiningOp<IndexExprOp>())
      return expandIndexExprRoot;
    if (AssumeOp assume = value.getDefiningOp<AssumeOp>())
      return hasSymbolicRoot(assume.getValue());
    if (BinaryOp binary = value.getDefiningOp<BinaryOp>())
      return canBuildBinary(binary);
    if (SelectOp select = value.getDefiningOp<SelectOp>())
      return isSymbolicSelectOp(select, allowI64Integers, solver, store);
    if (SplatOp splat = value.getDefiningOp<SplatOp>())
      return hasSymbolicRoot(splat.getSource());
    if (BlockArgument arg = dyn_cast<BlockArgument>(value))
      return matchLoopCarriedRecurrence(arg).has_value();
    return false;
  }

  FailureOr<sym::ExprHandle> buildExpr(Value value, bool &skip, bool allowLeaf,
                                       unsigned depth = 0) {
    if (depth > kMaxSymbolicValueDepth) {
      skip = true;
      return failure();
    }
    std::optional<int64_t> constant = foldWaveConstants
                                          ? getSplatOrConstantInt(value)
                                          : getConstantIntValue(value);
    if (constant)
      return sym::composeExprInt(store, *constant);
    if (IndexExprOp indexExpr = value.getDefiningOp<IndexExprOp>())
      return buildIndexExpr(indexExpr);
    if (AssumeOp assume = value.getDefiningOp<AssumeOp>())
      return buildAssumeExpr(value, assume, skip, allowLeaf, depth);
    if (SplatOp splat = value.getDefiningOp<SplatOp>())
      return buildSplatExpr(splat, skip, allowLeaf, depth);
    if (Value source = getSymbolicAlias(value, store))
      return buildExpr(source, skip, allowLeaf, depth + 1);
    if (BinaryOp binary = value.getDefiningOp<BinaryOp>())
      return buildBinaryExpr(value, binary, skip, allowLeaf, depth);
    if (SelectOp select = value.getDefiningOp<SelectOp>())
      return buildSelectExpr(value, select, skip, allowLeaf, depth);
    return buildLeafOrRecurrence(value, skip, allowLeaf, depth);
  }

  FailureOr<sym::ExprHandle> buildLeafOrRecurrence(Value value, bool &skip,
                                                   bool allowLeaf,
                                                   unsigned depth) {
    if (BlockArgument arg = dyn_cast<BlockArgument>(value)) {
      if (std::optional<LoopCarriedRecurrence> recurrence =
              matchLoopCarriedRecurrence(arg))
        return buildLoopCarriedRecurrence(*recurrence, skip, depth);
    }
    return bindOrSkip(value, skip, allowLeaf);
  }

  std::optional<LoopCarriedUpdate> getLoopCarriedUpdate(BlockArgument arg) {
    if (arg.getArgNumber() == 0)
      return std::nullopt;
    if (!isSymbolicValueType(arg.getType(), allowI64Integers))
      return std::nullopt;
    scf::ForOp loop =
        dyn_cast_or_null<scf::ForOp>(arg.getOwner()->getParentOp());
    if (!loop)
      return std::nullopt;
    if (arg.getOwner() != loop.getBody())
      return std::nullopt;

    unsigned index = arg.getArgNumber() - 1;
    if (index >= loop.getInitArgs().size())
      return std::nullopt;
    std::optional<int64_t> step = getConstantIntValue(loop.getStep());
    if (!step)
      return std::nullopt;
    if (*step <= 0)
      return std::nullopt;

    scf::YieldOp yield = cast<scf::YieldOp>(loop.getBody()->getTerminator());
    BinaryOp update = yield.getOperand(index).getDefiningOp<BinaryOp>();
    if (!update)
      return std::nullopt;
    if (!canBuildBinary(update))
      return std::nullopt;
    return LoopCarriedUpdate{loop, update, index};
  }

  static std::optional<std::pair<Value, bool>>
  getRecurrenceStride(BlockArgument arg, BinaryOp update) {
    if (update.getKind() == BinaryKind::AddI) {
      if (update.getLhs() == arg)
        return std::pair<Value, bool>{update.getRhs(), false};
      if (update.getRhs() == arg)
        return std::pair<Value, bool>{update.getLhs(), false};
      return std::nullopt;
    }
    if (update.getKind() != BinaryKind::SubI)
      return std::nullopt;
    if (update.getLhs() != arg)
      return std::nullopt;
    return std::pair<Value, bool>{update.getRhs(), true};
  }

  std::optional<LoopCarriedRecurrence>
  matchLoopCarriedRecurrence(BlockArgument arg) {
    std::optional<LoopCarriedUpdate> carried = getLoopCarriedUpdate(arg);
    if (!carried)
      return std::nullopt;
    std::optional<std::pair<Value, bool>> stride =
        getRecurrenceStride(arg, carried->update);
    if (!stride)
      return std::nullopt;
    if (!carried->loop.isDefinedOutsideOfLoop(stride->first))
      return std::nullopt;
    if (stride->first.getType() != arg.getType())
      return std::nullopt;
    return LoopCarriedRecurrence{carried->loop,
                                 carried->loop.getInitArgs()[carried->index],
                                 stride->first, stride->second};
  }

  FailureOr<sym::ExprHandle>
  buildRecurrenceIteration(LoopCarriedRecurrence recurrence, bool &skip,
                           unsigned depth) {
    FailureOr<sym::ExprHandle> induction =
        buildExpr(recurrence.loop.getInductionVar(), skip, true, depth + 1);
    if (failedOrSkipped(induction, skip))
      return failure();
    FailureOr<sym::ExprHandle> lower =
        buildExpr(recurrence.loop.getLowerBound(), skip, true, depth + 1);
    if (failedOrSkipped(lower, skip))
      return failure();
    FailureOr<sym::ExprHandle> iteration = sym::composeExprBinary(
        store, *induction, sym::ExprBinaryOp::Sub, *lower);
    if (failed(iteration))
      return failure();

    int64_t step = *getConstantIntValue(recurrence.loop.getStep());
    if (step == 1)
      return iteration;
    FailureOr<sym::ExprHandle> stepExpr = sym::composeExprInt(store, step);
    if (failed(stepExpr))
      return failure();
    return sym::composeExprBinary(store, *iteration, sym::ExprBinaryOp::Div,
                                  *stepExpr);
  }

  FailureOr<sym::ExprHandle>
  buildRecurrenceStride(LoopCarriedRecurrence recurrence, bool &skip,
                        unsigned depth) {
    FailureOr<sym::ExprHandle> stride =
        buildExpr(recurrence.stride, skip, true, depth + 1);
    if (failedOrSkipped(stride, skip))
      return failure();
    if (!recurrence.subtractStride)
      return stride;
    FailureOr<sym::ExprHandle> zero = sym::composeExprInt(store, 0);
    if (failed(zero))
      return failure();
    return sym::composeExprBinary(store, *zero, sym::ExprBinaryOp::Sub,
                                  *stride);
  }

  FailureOr<sym::ExprHandle>
  buildLoopCarriedRecurrence(LoopCarriedRecurrence recurrence, bool &skip,
                             unsigned depth) {
    FailureOr<sym::ExprHandle> init =
        buildExpr(recurrence.init, skip, true, depth + 1);
    if (failedOrSkipped(init, skip))
      return failure();
    FailureOr<sym::ExprHandle> iteration =
        buildRecurrenceIteration(recurrence, skip, depth);
    if (failed(iteration))
      return failure();
    FailureOr<sym::ExprHandle> stride =
        buildRecurrenceStride(recurrence, skip, depth);
    if (failed(stride))
      return failure();
    FailureOr<sym::ExprHandle> displacement = sym::composeExprBinary(
        store, *iteration, sym::ExprBinaryOp::Mul, *stride);
    if (failed(displacement))
      return failure();
    return sym::composeExprBinary(store, *init, sym::ExprBinaryOp::Add,
                                  *displacement);
  }

  FailureOr<sym::ExprHandle> bindOrSkip(Value value, bool &skip,
                                        bool allowLeaf) {
    if (allowLeaf)
      return bindSymbol(value, skip);
    skip = true;
    return failure();
  }

  FailureOr<sym::ExprHandle> buildAssumeExpr(Value value, AssumeOp assume,
                                             bool &skip, bool allowLeaf,
                                             unsigned depth) {
    if (!hasSymbolicRoot(assume.getValue()))
      return bindOrSkip(value, skip, allowLeaf);
    bool childSkip = false;
    FailureOr<sym::ExprHandle> expr =
        buildExpr(assume.getValue(), childSkip, allowLeaf, depth + 1);
    if (!childSkip && failed(expr))
      return failure();
    if (childSkip)
      return bindOrSkip(value, skip, allowLeaf);
    if (failed(appendAssumePredicatesForExpr(assume, *expr))) {
      skip = true;
      return failure();
    }
    return *expr;
  }

  FailureOr<sym::ExprHandle> buildSplatExpr(SplatOp splat, bool &skip,
                                            bool allowLeaf, unsigned depth) {
    bool childSkip = false;
    FailureOr<sym::ExprHandle> expr =
        buildExpr(splat.getSource(), childSkip, allowLeaf, depth + 1);
    if (!childSkip)
      return expr;
    return bindOrSkip(splat.getSource(), skip, allowLeaf);
  }

  FailureOr<sym::ExprHandle> buildBinaryExpr(Value value, BinaryOp binary,
                                             bool &skip, bool allowLeaf,
                                             unsigned depth) {
    bool childSkip = false;
    FailureOr<sym::ExprHandle> expr = buildBinary(binary, childSkip, depth + 1);
    if (!childSkip) {
      if (succeeded(expr))
        offset.materializations.push_back({value, *expr});
      return expr;
    }
    return bindOrSkip(value, skip, allowLeaf);
  }

  FailureOr<sym::ExprHandle> buildSelectExpr(Value value, SelectOp select,
                                             bool &skip, bool allowLeaf,
                                             unsigned depth) {
    bool childSkip = false;
    FailureOr<sym::ExprHandle> expr = buildSelect(select, childSkip, depth + 1);
    if (!childSkip)
      return expr;
    return bindOrSkip(value, skip, allowLeaf);
  }

  FailureOr<sym::ExprHandle> buildIndexExpr(IndexExprOp op) {
    FailureOr<SymbolicOffset> symbolic = getIndexExprSymbolicOffset(op);
    if (failed(symbolic))
      return failure();
    return appendOffset(*symbolic);
  }

  FailureOr<sym::ExprHandle> buildBinary(BinaryOp op, bool &skip,
                                         unsigned depth) {
    if (!canBuildBinary(op)) {
      skip = true;
      return failure();
    }
    if (shouldModelWrappingBinary(op))
      return buildWrappingBinary(op, skip, depth);
    return buildNonWrappingBinary(op, skip, depth);
  }

  FailureOr<sym::ExprHandle> buildNonWrappingBinary(BinaryOp op, bool &skip,
                                                    unsigned depth) {
    switch (op.getKind()) {
    case BinaryKind::ShLI:
      return buildShift(op, skip, depth);
    case BinaryKind::DivSI:
      return buildSignedDiv(op, skip, depth);
    case BinaryKind::DivUI:
      return buildUnsignedDiv(op, skip, depth);
    case BinaryKind::RemUI:
      return buildUnsignedRem(op, skip, depth);
    case BinaryKind::ShRUI:
      return buildUnsignedShiftRight(op, skip, depth);
    case BinaryKind::AndI:
      return buildPowerOfTwoMask(op, skip, depth);
    default:
      return buildPlainBinary(op, skip, depth);
    }
  }

  FailureOr<sym::ExprHandle> buildWrappingBinary(BinaryOp op, bool &skip,
                                                 unsigned depth) {
    FailureOr<sym::ExprHandle> value = buildPlainBinary(op, skip, depth);
    if (skip || failed(value))
      return failure();
    if (sym::provablyInRange(store, *value, offset.assumptions,
                             -(int64_t{1} << 31), (int64_t{1} << 31) - 1))
      return value;
    FailureOr<sym::ExprHandle> bias =
        sym::composeExprInt(store, int64_t{1} << 31);
    FailureOr<sym::ExprHandle> modulus =
        sym::composeExprInt(store, int64_t{1} << 32);
    if (failed(bias) || failed(modulus))
      return failure();
    FailureOr<sym::ExprHandle> biased =
        sym::composeExprBinary(store, *value, sym::ExprBinaryOp::Add, *bias);
    if (failed(biased))
      return failure();
    FailureOr<sym::ExprHandle> wrapped = sym::composeExprBinary(
        store, *biased, sym::ExprBinaryOp::Mod, *modulus);
    if (failed(wrapped))
      return failure();
    return sym::composeExprBinary(store, *wrapped, sym::ExprBinaryOp::Sub,
                                  *bias);
  }

  FailureOr<sym::ExprHandle> buildSelect(SelectOp op, bool &skip,
                                         unsigned depth) {
    if (!isSymbolicSelectOp(op, allowI64Integers, solver, store)) {
      skip = true;
      return failure();
    }

    FailureOr<sym::PredHandle> condition =
        buildSelectCondition(op, skip, depth);
    if (skip || failed(condition))
      return failure();
    FailureOr<sym::ExprHandle> trueValue =
        buildExpr(op.getTrueValue(), skip, true, depth);
    if (skip || failed(trueValue))
      return failure();
    FailureOr<sym::ExprHandle> falseValue =
        buildExpr(op.getFalseValue(), skip, true, depth);
    if (skip || failed(falseValue))
      return failure();
    FailureOr<sym::PredHandle> defaultCondition = sym::composePredTrue(store);
    if (failed(defaultCondition))
      return failure();
    std::array<sym::PiecewiseCase, 2> cases{
        sym::PiecewiseCase{*trueValue, *condition},
        sym::PiecewiseCase{*falseValue, *defaultCondition}};
    return sym::composeExprPiecewise(store, cases);
  }

  FailureOr<sym::PredHandle> buildSelectCondition(SelectOp op, bool &skip,
                                                  unsigned depth) {
    CmpIOp cmp = op.getCondition().getDefiningOp<CmpIOp>();
    if (!cmp) {
      skip = true;
      return failure();
    }
    return buildCmpPredicate(cmp, skip, depth);
  }

  FailureOr<sym::PredHandle> buildCmpPredicate(CmpIOp op, bool &skip,
                                               unsigned depth) {
    return buildCmpPredicate(op.getPredicate(), op.getLhs(), op.getRhs(), skip,
                             depth);
  }

  FailureOr<std::optional<sym::PredHandle>>
  buildBooleanSelectComparison(arith::CmpIPredicate predicate, Value lhs,
                               Value rhs, bool &skip, unsigned depth) {
    std::optional<BooleanSelectComparison> match =
        matchBooleanSelectComparison(predicate, lhs, rhs, store);
    if (!match)
      return std::optional<sym::PredHandle>{};
    FailureOr<sym::PredHandle> recovered =
        buildBooleanSelectComparison(*match, skip, depth);
    if (failed(recovered))
      return failure();
    return std::optional<sym::PredHandle>{*recovered};
  }

  FailureOr<sym::PredHandle>
  buildBooleanSelectComparison(BooleanSelectComparison match, bool &skip,
                               unsigned depth) {
    if (match.trueResult == match.falseResult)
      return match.trueResult ? sym::composePredTrue(store)
                              : sym::composePredFalse(store);
    FailureOr<sym::PredHandle> condition =
        buildPredicateExpr(match.select.getCondition(), skip, depth + 1);
    if (failedOrSkipped(condition, skip))
      return failure();
    if (match.trueResult)
      return condition;
    return sym::composePredNot(store, *condition);
  }

  FailureOr<sym::PredHandle> buildCmpPredicate(arith::CmpIPredicate predicate,
                                               Value lhsValue, Value rhsValue,
                                               bool &skip, unsigned depth = 0) {
    FailureOr<std::optional<sym::PredHandle>> select =
        buildBooleanSelectComparison(predicate, lhsValue, rhsValue, skip,
                                     depth);
    if (failed(select))
      return failure();
    if (*select)
      return **select;

    std::optional<sym::PredCmpOp> converted =
        convertCmpPredicate(predicate, lhsValue, rhsValue, solver, store);
    if (!converted) {
      skip = true;
      return failure();
    }

    FailureOr<sym::ExprHandle> lhs = buildExpr(lhsValue, skip, true, depth);
    if (skip || failed(lhs))
      return failure();
    FailureOr<sym::ExprHandle> rhs = buildExpr(rhsValue, skip, true, depth);
    if (skip || failed(rhs))
      return failure();
    return sym::composePredCmp(store, *lhs, *converted, *rhs);
  }

  FailureOr<sym::ExprHandle> buildPlainBinary(BinaryOp op, bool &skip,
                                              unsigned depth) {
    std::optional<sym::ExprBinaryOp> kind = convertBinaryKind(op.getKind());
    if (!kind) {
      skip = true;
      return failure();
    }
    FailureOr<sym::ExprHandle> lhs = buildExpr(op.getLhs(), skip, true, depth);
    if (skip || failed(lhs))
      return failure();
    FailureOr<sym::ExprHandle> rhs = buildExpr(op.getRhs(), skip, true, depth);
    if (skip || failed(rhs))
      return failure();
    return sym::composeExprBinary(store, *lhs, *kind, *rhs);
  }

  static std::optional<sym::ExprBinaryOp> convertBinaryKind(BinaryKind kind) {
    switch (kind) {
    case BinaryKind::AddI:
      return sym::ExprBinaryOp::Add;
    case BinaryKind::SubI:
      return sym::ExprBinaryOp::Sub;
    case BinaryKind::MulI:
      return sym::ExprBinaryOp::Mul;
    case BinaryKind::XOrI:
      return sym::ExprBinaryOp::Xor;
    default:
      return std::nullopt;
    }
  }

  FailureOr<sym::ExprHandle> buildShift(BinaryOp op, bool &skip,
                                        unsigned depth) {
    std::optional<int64_t> shift = getSplatOrConstantInt(op.getRhs());
    if (!shift || *shift < 0 || *shift >= 63) {
      skip = true;
      return failure();
    }
    FailureOr<sym::ExprHandle> lhs = buildExpr(op.getLhs(), skip, true, depth);
    if (skip || failed(lhs))
      return failure();
    FailureOr<sym::ExprHandle> scale =
        sym::composeExprInt(store, int64_t{1} << *shift);
    if (failed(scale))
      return failure();
    return sym::composeExprBinary(store, *lhs, sym::ExprBinaryOp::Mul, *scale);
  }

  FailureOr<sym::ExprHandle> buildUnsignedShiftRight(BinaryOp op, bool &skip,
                                                     unsigned depth) {
    std::optional<int64_t> shift = getSplatOrConstantInt(op.getRhs());
    std::optional<SignedI64Range> lhsRange =
        computeSignedI64Range(op.getLhs(), solver, store);
    if (!shift || *shift < 0 || *shift >= 63 || !lhsRange ||
        lhsRange->first < 0) {
      skip = true;
      return failure();
    }
    FailureOr<sym::ExprHandle> lhs = buildExpr(op.getLhs(), skip, true, depth);
    if (skip || failed(lhs))
      return failure();
    FailureOr<sym::ExprHandle> rhs =
        sym::composeExprInt(store, int64_t{1} << *shift);
    if (failed(rhs))
      return failure();
    FailureOr<sym::ExprHandle> div =
        sym::composeExprBinary(store, *lhs, sym::ExprBinaryOp::Div, *rhs);
    if (failed(div))
      return failure();
    return sym::composeExprFloor(store, *div);
  }

  bool hasUnsignedDivRemDomain(BinaryOp op) {
    std::optional<SignedI64Range> lhsRange =
        computeSignedI64Range(op.getLhs(), solver, store);
    std::optional<SignedI64Range> rhsRange =
        computeSignedI64Range(op.getRhs(), solver, store);
    return lhsRange && rhsRange && lhsRange->first >= 0 && rhsRange->first > 0;
  }

  FailureOr<std::pair<sym::ExprHandle, sym::ExprHandle>>
  buildBinaryOperands(BinaryOp op, bool &skip, unsigned depth) {
    FailureOr<sym::ExprHandle> lhs = buildExpr(op.getLhs(), skip, true, depth);
    if (skip || failed(lhs))
      return failure();
    FailureOr<sym::ExprHandle> rhs = buildExpr(op.getRhs(), skip, true, depth);
    if (skip || failed(rhs))
      return failure();
    return std::pair<sym::ExprHandle, sym::ExprHandle>{*lhs, *rhs};
  }

  FailureOr<sym::ExprHandle> buildUnsignedDiv(BinaryOp op, bool &skip,
                                              unsigned depth) {
    if (!hasUnsignedDivRemDomain(op)) {
      skip = true;
      return failure();
    }
    FailureOr<std::pair<sym::ExprHandle, sym::ExprHandle>> operands =
        buildBinaryOperands(op, skip, depth);
    if (failed(operands))
      return failure();
    FailureOr<sym::ExprHandle> div = sym::composeExprBinary(
        store, operands->first, sym::ExprBinaryOp::Div, operands->second);
    if (failed(div))
      return failure();
    return sym::composeExprFloor(store, *div);
  }

  FailureOr<sym::ExprHandle> buildUnsignedRem(BinaryOp op, bool &skip,
                                              unsigned depth) {
    if (!hasUnsignedDivRemDomain(op)) {
      skip = true;
      return failure();
    }
    FailureOr<std::pair<sym::ExprHandle, sym::ExprHandle>> operands =
        buildBinaryOperands(op, skip, depth);
    if (failed(operands))
      return failure();
    return sym::composeExprBinary(store, operands->first,
                                  sym::ExprBinaryOp::Mod, operands->second);
  }

  FailureOr<sym::ExprHandle> buildSignedDiv(BinaryOp op, bool &skip,
                                            unsigned depth) {
    std::optional<int64_t> divisor = getSplatOrConstantInt(op.getRhs());
    std::optional<SignedI64Range> lhsRange =
        computeSignedI64Range(op.getLhs(), solver, store);
    if (!divisor || !isPositivePowerOfTwo(*divisor) || !lhsRange ||
        lhsRange->first < 0) {
      skip = true;
      return failure();
    }
    FailureOr<sym::ExprHandle> lhs = buildExpr(op.getLhs(), skip, true, depth);
    if (skip || failed(lhs))
      return failure();
    FailureOr<sym::ExprHandle> rhs = sym::composeExprInt(store, *divisor);
    if (failed(rhs))
      return failure();
    FailureOr<sym::ExprHandle> div =
        sym::composeExprBinary(store, *lhs, sym::ExprBinaryOp::Div, *rhs);
    if (failed(div))
      return failure();
    return sym::composeExprFloor(store, *div);
  }

  FailureOr<sym::ExprHandle> buildPowerOfTwoMask(BinaryOp op, bool &skip,
                                                 unsigned depth) {
    Value value = op.getLhs();
    std::optional<int64_t> mask = getSplatOrConstantInt(op.getRhs());
    if (!mask) {
      mask = getSplatOrConstantInt(op.getLhs());
      value = op.getRhs();
    }
    std::optional<int64_t> modulus =
        mask ? getPowerOfTwoMaskModulus(*mask) : std::nullopt;
    std::optional<SignedI64Range> valueRange =
        computeSignedI64Range(value, solver, store);
    if (!modulus || !valueRange || valueRange->first < 0) {
      skip = true;
      return failure();
    }

    FailureOr<sym::ExprHandle> lhs = buildExpr(value, skip, true, depth);
    if (skip || failed(lhs))
      return failure();
    FailureOr<sym::ExprHandle> rhs = sym::composeExprInt(store, *modulus);
    if (failed(rhs))
      return failure();
    return sym::composeExprBinary(store, *lhs, sym::ExprBinaryOp::Mod, *rhs);
  }

  LogicalResult appendAssumePredicatesForExpr(AssumeOp assume,
                                              sym::ExprHandle expr) {
    FailureOr<sym::ExprHandle> target =
        sym::composeExprSym(store, assume.getName());
    if (failed(target))
      return failure();

    SmallVector<sym::PredHandle, 4> predicates;
    for (Attribute attr : assume.getAssumptions())
      predicates.push_back(cast<PredAttr>(attr).getValue());
    std::array<sym::ExprSubstitution, 1> substitutions{
        sym::ExprSubstitution{*target, expr}};
    FailureOr<SmallVector<sym::PredHandle>> remapped =
        substituteIndexExprPredicates(store, predicates, substitutions);
    if (failed(remapped))
      return failure();
    llvm::append_range(offset.assumptions, *remapped);
    return success();
  }

  FailureOr<sym::ExprHandle> bindSymbol(Value value, bool &skip) {
    return bindSymbol(value, skip, std::nullopt);
  }

  FailureOr<sym::ExprHandle>
  bindSymbol(Value value, bool &skip,
             std::optional<SignedI64Range> derivedRange) {
    std::optional<SymbolicOffsetBindingKind> kind =
        classifyBindingType(value.getType());
    if (!kind) {
      skip = true;
      return failure();
    }

    auto valueIt = nameByValue.find(value);
    if (valueIt != nameByValue.end())
      return sym::composeExprSym(store, valueIt->second);

    std::string name = freshName();
    FailureOr<sym::ExprHandle> expr = sym::composeExprSym(store, name);
    if (failed(expr))
      return failure();
    if (*kind == SymbolicOffsetBindingKind::Lane)
      offset.laneWidth =
          std::max(offset.laneWidth,
                   unsigned(cast<SimdType>(value.getType()).getWidth()));
    auto [it, inserted] = bindingByName.try_emplace(name, value);
    (void)inserted;
    nameByValue[value] = it->getKey();
    offset.bindings.push_back({*expr, value, *kind});
    if (failed(appendSymbolAssumptions(value, it->getKey(), derivedRange)))
      return failure();
    return *expr;
  }

  LogicalResult
  appendSymbolAssumptions(Value value, StringRef name,
                          std::optional<SignedI64Range> derivedRange) {
    if (std::optional<ConstantIntRanges> range =
            finiteSignedRange(solver, value))
      appendRangeAndAssumePredicates(store, value, name, *range,
                                     offset.assumptions);
    else {
      appendAssumePredicates(store, value, name, offset.assumptions);
    }
    if (derivedRange) {
      if (failed(appendSignedRangeAssumption(store, name, derivedRange->first,
                                             derivedRange->second,
                                             offset.assumptions)))
        return failure();
    } else if (assumeI32StorageRange &&
               isSignlessI32StorageType(value.getType())) {
      if (failed(appendSignedI32StorageRangeAssumption(store, name,
                                                       offset.assumptions)))
        return failure();
    }
    if (modelWrappingArithmetic &&
        failed(appendCongruenceTightenedI32Range(value, name)))
      return failure();
    return success();
  }

  LogicalResult appendCongruenceTightenedI32Range(Value value, StringRef name) {
    if (!isSignlessI32StorageType(value.getType()))
      return success();
    FailureOr<std::unique_ptr<sym::Analysis>> analysis =
        sym::Analysis::create(store, offset.assumptions);
    FailureOr<sym::ExprHandle> expression = symbolExpr(store, name);
    if (failed(analysis) || failed(expression))
      return failure();
    std::optional<sym::Congruence> congruence =
        (*analysis)->getSymbolCongruence(*expression);
    if (!congruence || congruence->modulus <= 1)
      return success();

    int64_t modulus = congruence->modulus;
    auto positiveMod = [modulus](__int128 value) {
      int64_t remainder = value % modulus;
      return remainder < 0 ? remainder + modulus : remainder;
    };
    int64_t lo = -(int64_t{1} << 31);
    int64_t hi = (int64_t{1} << 31) - 1;
    lo += positiveMod(static_cast<__int128>(congruence->residue) - lo);
    hi -= positiveMod(static_cast<__int128>(hi) - congruence->residue);
    if (lo > hi)
      return success();
    return appendSignedRangeAssumption(store, name, lo, hi, offset.assumptions);
  }

  std::optional<SignedI64Range> inferI32RootRange(Value value) {
    if (std::optional<SignedI64Range> range =
            computeSignedI64Range(value, solver, store))
      return intersectRange(range, signedI32StorageRange());
    SymbolicValueBuilder expanded(
        dialect, solver, allowI64Integers,
        /*assumeI32StorageRange=*/false, /*bindI32Root=*/false,
        /*requireI32RootRange=*/false, /*expandIndexExprRoot=*/false,
        /*foldWaveConstants=*/false, /*allowWrappingArithmetic=*/false,
        /*modelWrappingArithmetic=*/false, assumeAddressArithmeticNoOverflow);
    FailureOr<std::optional<SymbolicOffset>> symbolic = expanded.build(value);
    if (failed(symbolic) || !*symbolic || !(*symbolic)->expr)
      return std::nullopt;
    return intersectRange(
        inferSignedI64Range(store, (*symbolic)->expr, (*symbolic)->assumptions),
        signedI32StorageRange());
  }

  static std::optional<SymbolicOffsetBindingKind>
  classifyBindingType(Type type) {
    if (type.isIndex())
      return SymbolicOffsetBindingKind::Uniform;
    if (auto intType = dyn_cast<IntegerType>(type)) {
      if (!intType.isSignless())
        return std::nullopt;
      return SymbolicOffsetBindingKind::Uniform;
    }
    if (auto simdType = dyn_cast<SimdType>(type)) {
      Type element = simdType.getElementType();
      if (element.isIndex() || element.isInteger(32))
        return SymbolicOffsetBindingKind::Lane;
    }
    return std::nullopt;
  }

  LogicalResult appendSymbolSubstitution(
      sym::ExprHandle source, StringRef replacementName,
      SmallVectorImpl<sym::ExprSubstitution> &substitutions) {
    FailureOr<sym::ExprHandle> replacement =
        sym::composeExprSym(store, replacementName);
    if (failed(replacement))
      return failure();
    substitutions.push_back({source, *replacement});
    return success();
  }

  void appendNewOffsetBinding(const SymbolicOffsetBinding &binding,
                              const SymbolicOffset &symbolic) {
    StringRef name = symbolName(binding);
    auto [it, inserted] = bindingByName.try_emplace(name, binding.value);
    (void)inserted;
    nameByValue[binding.value] = it->getKey();
    offset.bindings.push_back(binding);
    offset.laneWidth = std::max(offset.laneWidth, symbolic.laneWidth);
  }

  LogicalResult appendFreshOffsetBinding(
      const SymbolicOffsetBinding &binding, const SymbolicOffset &symbolic,
      SmallVectorImpl<sym::ExprSubstitution> &substitutions) {
    std::string fresh = freshName(symbolName(binding));
    auto [freshIt, inserted] = bindingByName.try_emplace(fresh, binding.value);
    (void)inserted;
    nameByValue[binding.value] = freshIt->getKey();
    FailureOr<sym::ExprHandle> replacement =
        sym::composeExprSym(store, freshIt->getKey());
    if (failed(replacement))
      return failure();
    offset.bindings.push_back({*replacement, binding.value, binding.kind});
    offset.laneWidth = std::max(offset.laneWidth, symbolic.laneWidth);
    substitutions.push_back({binding.name, *replacement});
    return success();
  }

  LogicalResult appendNamedOffsetBinding(
      const SymbolicOffsetBinding &binding, const SymbolicOffset &symbolic,
      SmallVectorImpl<sym::ExprSubstitution> &substitutions) {
    StringRef name = symbolName(binding);
    auto valueIt = nameByValue.find(binding.value);
    if (valueIt != nameByValue.end())
      return appendSymbolSubstitution(binding.name, valueIt->second,
                                      substitutions);

    auto existing = bindingByName.find(name);
    if (existing == bindingByName.end()) {
      appendNewOffsetBinding(binding, symbolic);
      return success();
    }
    if (existing->second == binding.value)
      return success();
    return appendFreshOffsetBinding(binding, symbolic, substitutions);
  }

  LogicalResult
  appendOffsetBinding(const SymbolicOffsetBinding &binding,
                      const SymbolicOffset &symbolic,
                      SmallVectorImpl<sym::ExprSubstitution> &substitutions) {
    FailureOr<std::optional<sym::ExprHandle>> expanded =
        buildGeneratedBindingExpr(binding.value);
    if (failed(expanded))
      return failure();
    if (*expanded) {
      substitutions.push_back({binding.name, **expanded});
      return success();
    }
    return appendNamedOffsetBinding(binding, symbolic, substitutions);
  }

  FailureOr<sym::ExprHandle>
  appendOffsetExpr(const SymbolicOffset &symbolic,
                   ArrayRef<sym::ExprSubstitution> substitutions) {
    if (substitutions.empty()) {
      llvm::append_range(offset.assumptions, symbolic.assumptions);
      return symbolic.expr;
    }
    FailureOr<SmallVector<sym::PredHandle>> assumptions =
        substituteIndexExprPredicates(store, symbolic.assumptions,
                                      substitutions);
    if (failed(assumptions))
      return failure();
    llvm::append_range(offset.assumptions, *assumptions);
    return sym::substituteExpr(store, symbolic.expr, substitutions);
  }

  FailureOr<sym::ExprHandle> appendOffset(const SymbolicOffset &symbolic) {
    SmallVector<sym::ExprSubstitution> substitutions;
    for (const SymbolicOffsetBinding &binding : symbolic.bindings)
      if (failed(appendOffsetBinding(binding, symbolic, substitutions)))
        return failure();
    return appendOffsetExpr(symbolic, substitutions);
  }

  FailureOr<std::optional<sym::ExprHandle>>
  buildGeneratedBindingExpr(Value value) {
    if (!hasSymbolicRoot(value))
      return std::optional<sym::ExprHandle>{};
    bool skip = false;
    FailureOr<sym::ExprHandle> expr =
        buildExpr(value, skip, /*allowLeaf=*/true);
    if (skip)
      return std::optional<sym::ExprHandle>{};
    if (failed(expr))
      return failure();
    return std::optional<sym::ExprHandle>{*expr};
  }

  std::string freshName(StringRef stem = "raw") {
    return getFreshIndexExprBindingName(stem, bindingByName, nextRawSymbol);
  }

  SymbolicOffset offset;
  llvm::DenseMap<Value, StringRef> nameByValue;
  llvm::StringMap<Value> bindingByName;
  WaveDialect &dialect;
  DataFlowSolver &solver;
  sym::Store &store;
  bool allowI64Integers = false;
  bool assumeI32StorageRange = false;
  bool bindI32Root = false;
  bool requireI32RootRange = false;
  bool expandIndexExprRoot = false;
  bool foldWaveConstants = false;
  bool allowWrappingArithmetic = false;
  bool modelWrappingArithmetic = false;
  bool assumeAddressArithmeticNoOverflow = false;
  unsigned nextRawSymbol = 0;
};

} // namespace

FailureOr<std::optional<SymbolicOffset>>
mlir::wave::buildSymbolicIndexValue(Value value, WaveDialect &dialect,
                                    DataFlowSolver &solver) {
  SymbolicValueBuilder builder(
      dialect, solver, /*allowI64Integers=*/false,
      /*assumeI32StorageRange=*/true, /*bindI32Root=*/false,
      /*requireI32RootRange=*/false, /*expandIndexExprRoot=*/true,
      /*foldWaveConstants=*/false, /*allowWrappingArithmetic=*/false,
      /*modelWrappingArithmetic=*/false,
      hasAddressArithmeticNoOverflowAssumption(value));
  return builder.buildAllowingRootLeaf(value);
}

FailureOr<std::optional<SymbolicPredicate>>
mlir::wave::buildSymbolicIndexPredicate(Value value, WaveDialect &dialect,
                                        DataFlowSolver &solver) {
  SymbolicValueBuilder builder(
      dialect, solver, /*allowI64Integers=*/false,
      /*assumeI32StorageRange=*/true, /*bindI32Root=*/false,
      /*requireI32RootRange=*/false, /*expandIndexExprRoot=*/true,
      /*foldWaveConstants=*/true);
  return builder.buildPredicate(value);
}

FailureOr<std::optional<SymbolicPredicate>>
mlir::wave::buildSymbolicPacketPredicateRelation(Value value,
                                                 WaveDialect &dialect,
                                                 DataFlowSolver &solver) {
  SymbolicValueBuilder builder(
      dialect, solver, /*allowI64Integers=*/false,
      /*assumeI32StorageRange=*/true, /*bindI32Root=*/false,
      /*requireI32RootRange=*/false, /*expandIndexExprRoot=*/true,
      /*foldWaveConstants=*/true, /*allowWrappingArithmetic=*/true);
  return builder.buildPredicate(value);
}

FailureOr<std::optional<SymbolicPredicate>>
mlir::wave::buildSymbolicMaskPredicate(Value value, WaveDialect &dialect,
                                       DataFlowSolver &solver) {
  SymbolicValueBuilder builder(
      dialect, solver, /*allowI64Integers=*/false,
      /*assumeI32StorageRange=*/true, /*bindI32Root=*/false,
      /*requireI32RootRange=*/false, /*expandIndexExprRoot=*/true,
      /*foldWaveConstants=*/true, /*allowWrappingArithmetic=*/false,
      /*modelWrappingArithmetic=*/true);
  return builder.buildPredicate(value);
}

namespace {

static IndexExprOp createIndexExpr(OpBuilder &builder, Location loc,
                                   MLIRContext *ctx,
                                   const SymbolicOffset &offset) {
  SmallVector<SymbolicOffsetBinding> liveBindings =
      collectLiveBindings(offset.expr, offset.bindings);
  SmallVector<StringRef> nameRefs;
  SmallVector<Value> values;
  llvm::DenseSet<StringRef> liveSymbols;
  for (const SymbolicOffsetBinding &binding : liveBindings) {
    StringRef name = symbolName(binding);
    nameRefs.push_back(name);
    liveSymbols.insert(name);
    values.push_back(binding.value);
  }
  SmallVector<sym::PredHandle> assumptions =
      filterIndexExprPredicatesBySymbols(offset.assumptions, liveSymbols);

  Type resultType = getIndexExprResultType(ctx, values);
  return IndexExprOp::create(builder, loc, resultType,
                             ExprAttr::get(ctx, offset.expr),
                             getIndexExprPredArrayAttr(ctx, assumptions),
                             builder.getStrArrayAttr(nameRefs), values);
}

static IndexExprOp createIndexExpr(OpBuilder &builder, Location loc,
                                   MLIRContext *ctx, sym::ExprHandle expr,
                                   ArrayRef<IndexExprBinding> bindings,
                                   ArrayRef<sym::PredHandle> assumptions) {
  SmallVector<StringRef> nameRefs;
  SmallVector<Value> values;
  appendNameRefs(bindings, nameRefs);
  appendValues(bindings, values);

  Type resultType = getIndexExprResultType(ctx, values);
  return IndexExprOp::create(builder, loc, resultType, ExprAttr::get(ctx, expr),
                             getIndexExprPredArrayAttr(ctx, assumptions),
                             builder.getStrArrayAttr(nameRefs), values);
}

static std::optional<int64_t> getOffsetWidth(Type type) {
  if (type.isIndex())
    return int64_t{0};
  if (isa<IntegerType>(type))
    return int64_t{0};
  if (auto simd = dyn_cast<SimdType>(type)) {
    Type element = simd.getElementType();
    if (element.isIndex() || element.isInteger(32))
      return simd.getWidth();
  }
  return std::nullopt;
}

static std::optional<int64_t> getPointerWidth(Type type) {
  if (isa<PtrType>(type))
    return int64_t{0};
  if (auto simd = dyn_cast<SimdType>(type))
    if (isa<PtrType>(simd.getElementType()))
      return simd.getWidth();
  return std::nullopt;
}

static bool preservesPtrAddResult(PtrAddOp op, Type offsetType) {
  std::optional<int64_t> baseWidth = getPointerWidth(op.getBase().getType());
  std::optional<int64_t> offsetWidth = getOffsetWidth(offsetType);
  if (!baseWidth || !offsetWidth)
    return false;
  int64_t resultWidth = std::max(*baseWidth, *offsetWidth);
  if (resultWidth == 0)
    return isa<PtrType>(op.getResult().getType());
  auto result = dyn_cast<SimdType>(op.getResult().getType());
  return result && result.getWidth() == resultWidth;
}

static bool hasGlobalPointerBase(PtrAddOp op) {
  std::optional<PtrType> ptr = getWavePointerType(op.getBase().getType());
  return ptr && isa<GlobalAddressSpaceAttr>(ptr->getAddressSpace());
}

static bool shouldPreserveUniformI32GlobalOffset(PtrAddOp op,
                                                 const SymbolicOffset &offset,
                                                 WaveDialect &dialect) {
  IntegerType type = dyn_cast<IntegerType>(op.getOffset().getType());
  if (!type || !type.isSignless() || type.getWidth() != 32 ||
      !hasGlobalPointerBase(op))
    return false;

  // Index widening changes negative i32 offsets; require a U31 proof.
  return !sym::provablyInRange(dialect.getSymbolStore(), offset.expr,
                               offset.assumptions, 0,
                               std::numeric_limits<int32_t>::max());
}

static Type getIndexExprType(MLIRContext *ctx,
                             ArrayRef<IndexExprBinding> bindings) {
  SmallVector<Value> values;
  appendValues(bindings, values);
  return getIndexExprResultType(ctx, values);
}

static Type getIndexExprType(MLIRContext *ctx, const SymbolicOffset &offset) {
  SmallVector<Value> values;
  for (const SymbolicOffsetBinding &binding :
       collectLiveBindings(offset.expr, offset.bindings))
    values.push_back(binding.value);
  return getIndexExprResultType(ctx, values);
}

static SymbolicValueBuilder
createGeneratedIndexExprBuilder(WaveDialect &dialect, DataFlowSolver &solver,
                                Operation *addressOp,
                                bool allowI64Integers = false) {
  return SymbolicValueBuilder(
      dialect, solver, allowI64Integers,
      /*assumeI32StorageRange=*/true,
      /*bindI32Root=*/false,
      /*requireI32RootRange=*/false,
      /*expandIndexExprRoot=*/false,
      /*foldWaveConstants=*/false,
      /*allowWrappingArithmetic=*/false,
      /*modelWrappingArithmetic=*/false,
      hasAddressArithmeticNoOverflowAssumption(addressOp));
}

static FailureOr<bool> rewritePtrAdd(PatternRewriter &rewriter, PtrAddOp op,
                                     WaveDialect &dialect,
                                     DataFlowSolver &solver) {
  if (!op.getOffset().hasOneUse() &&
      isSignlessI32SimdType(op.getOffset().getType()))
    return false;

  SymbolicValueBuilder builder = createGeneratedIndexExprBuilder(
      dialect, solver, op, hasGlobalPointerBase(op));
  FailureOr<std::optional<SymbolicOffset>> offset =
      builder.build(op.getOffset());
  if (failed(offset))
    return op.emitError("failed to generate wave.index_expr offset");
  if (!*offset)
    return false;
  if (shouldPreserveUniformI32GlobalOffset(op, **offset, dialect))
    return false;

  Type indexType = getIndexExprType(op.getContext(), **offset);
  if (!preservesPtrAddResult(op, indexType))
    return false;

  rewriter.setInsertionPoint(op);
  IndexExprOp index =
      createIndexExpr(rewriter, op.getLoc(), op.getContext(), **offset);
  rewriter.modifyOpInPlace(
      op, [&] { op.getOffsetMutable().assign(index.getResult()); });
  return true;
}

struct IntegerizedMask {
  Value mask;
  int64_t trueBits = 0;
};

static std::optional<IntegerizedMask> matchIntegerizedMask(Value value) {
  SelectOp select = value.getDefiningOp<SelectOp>();
  if (!select || !isa<MaskType>(select.getCondition().getType()))
    return std::nullopt;

  std::optional<int64_t> trueValue =
      getSplatOrConstantInt(select.getTrueValue());
  std::optional<int64_t> falseValue =
      getSplatOrConstantInt(select.getFalseValue());
  if (!trueValue || !falseValue || *trueValue == 0 || *falseValue != 0)
    return std::nullopt;
  return IntegerizedMask{select.getCondition(), *trueValue};
}

static FailureOr<bool> rewriteIntegerizedMaskAndCmp(PatternRewriter &rewriter,
                                                    CmpIOp op) {
  if (op.getPredicate() != arith::CmpIPredicate::ne)
    return false;

  Value andValue;
  if (getSplatOrConstantInt(op.getRhs()) == int64_t{0})
    andValue = op.getLhs();
  else if (getSplatOrConstantInt(op.getLhs()) == int64_t{0})
    andValue = op.getRhs();
  else
    return false;

  BinaryOp andOp = andValue.getDefiningOp<BinaryOp>();
  if (!andOp || andOp.getKind() != BinaryKind::AndI)
    return false;

  std::optional<IntegerizedMask> lhs = matchIntegerizedMask(andOp.getLhs());
  std::optional<IntegerizedMask> rhs = matchIntegerizedMask(andOp.getRhs());
  if (!lhs || !rhs || (lhs->trueBits & rhs->trueBits) == 0)
    return false;

  rewriter.setInsertionPoint(op);
  Value falseMask = ConstantOp::create(rewriter, op.getLoc(), op.getType(),
                                       rewriter.getBoolAttr(false));
  Value combined = SelectOp::create(rewriter, op.getLoc(), op.getType(),
                                    lhs->mask, rhs->mask, falseMask);
  rewriter.replaceOp(op, combined);
  return true;
}

static void seedBindingNames(IndexExprOp op, BindingState &state) {
  for (auto [nameAttr, value] : llvm::zip(op.getNames(), op.getBindings())) {
    StringRef name = cast<StringAttr>(nameAttr).getValue();
    state.reserved[name] = value;
  }
  for (auto [nameAttr, value] : llvm::zip(op.getNames(), op.getBindings())) {
    StringRef name = cast<StringAttr>(nameAttr).getValue();
    llvm::StringMap<Value>::iterator it = state.reserved.find(name);
    state.byValue.try_emplace(value, it->getKey());
  }
}

static bool isIdentityBinding(IndexExprOp op, StringRef name) {
  sym::ExprView expr(op.getExpr().getValue());
  return expr.getKind() == sym::ExprKind::Symbol &&
         expr.getSymbolName() == name;
}

static bool shouldPreserveGeneratedBinding(Value value,
                                           bool preserveI32Binding) {
  if (preserveI32Binding && isSignlessI32SimdType(value.getType()))
    return true;
  return false;
}

static FailureOr<bool> preserveGeneratedBinding(BindingState &state,
                                                StringRef name, Value value) {
  if (failed(appendBinding(state, name, value)))
    return failure();
  return false;
}

static FailureOr<bool> collectGeneratedBindingRewrite(
    IndexExprOp op, WaveDialect &dialect, BindingState &state, StringRef name,
    Value value, SmallVectorImpl<sym::ExprSubstitution> &substitutions,
    DataFlowSolver &solver, bool preserveI32Binding = false) {
  if (shouldPreserveGeneratedBinding(value, preserveI32Binding))
    return preserveGeneratedBinding(state, name, value);

  SymbolicValueBuilder builder(
      dialect, solver,
      /*allowI64Integers=*/false,
      /*assumeI32StorageRange=*/true,
      /*bindI32Root=*/false,
      /*requireI32RootRange=*/false,
      /*expandIndexExprRoot=*/true,
      /*foldWaveConstants=*/false,
      /*allowWrappingArithmetic=*/false,
      /*modelWrappingArithmetic=*/false,
      hasAddressArithmeticNoOverflowAssumption(op.getOperation()));
  FailureOr<std::optional<SymbolicOffset>> symbolic = builder.build(value);
  if (failed(symbolic))
    return op.emitError("failed to generate wave.index_expr binding");
  if (!*symbolic)
    return preserveGeneratedBinding(state, name, value);

  sym::Store &store = dialect.getSymbolStore();
  FailureOr<sym::ExprHandle> target = symbolExpr(store, name);
  FailureOr<sym::ExprHandle> replacement =
      remapSymbolicOffset(store, **symbolic, state);
  if (failed(target) || failed(replacement))
    return failure();
  substitutions.push_back({*target, *replacement});
  return true;
}

struct GeneratedIndexExprSimplification {
  SmallVector<sym::PredHandle> assumptions;
  sym::ExprHandle expr;
};

static FailureOr<GeneratedIndexExprSimplification>
substituteAndSimplifyGenerated(IndexExprOp op, sym::Store &store,
                               ArrayRef<sym::ExprSubstitution> substitutions,
                               ArrayRef<sym::PredHandle> assumptions) {
  FailureOr<std::unique_ptr<sym::Analysis>> analysis =
      sym::Analysis::create(store);
  if (failed(analysis))
    return op.emitError("failed to construct generated wave.index_expr facts");
  FailureOr<SmallVector<sym::PredHandle>> substitutedAssumptions =
      substituteIndexExprPredicates(**analysis, assumptions, substitutions);
  if (failed(substitutedAssumptions))
    return op.emitError("failed to substitute generated wave.index_expr facts");
  for (sym::PredHandle pred : *substitutedAssumptions)
    if (failed((*analysis)->assume(pred)))
      return op.emitError("failed to assume generated wave.index_expr facts");
  FailureOr<sym::ExprHandle> substituted =
      (*analysis)->substitute(op.getExpr().getValue(), substitutions);
  if (failed(substituted))
    return op.emitError("failed to substitute generated wave.index_expr");
  FailureOr<sym::ExprHandle> simplified = (*analysis)->simplify(*substituted);
  if (failed(simplified))
    return op.emitError("failed to simplify generated wave.index_expr");
  sym::ExprHandle result =
      shouldUseSimplifiedIndexExpr(*simplified, *substituted) ? *simplified
                                                              : *substituted;
  return GeneratedIndexExprSimplification{std::move(*substitutedAssumptions),
                                          result};
}

static FailureOr<bool> rewriteIndexExpr(PatternRewriter &rewriter,
                                        IndexExprOp op, WaveDialect &dialect,
                                        DataFlowSolver &solver) {
  sym::Store &store = dialect.getSymbolStore();
  BindingState state;
  seedBindingNames(op, state);
  appendIndexExprPredicates(op, state.assumptions);

  SmallVector<sym::ExprSubstitution> substitutions;
  bool changed = false;
  for (auto [nameAttr, value] : llvm::zip(op.getNames(), op.getBindings())) {
    StringRef name = cast<StringAttr>(nameAttr).getValue();
    appendAssumePredicates(store, value, name, state.assumptions);
    FailureOr<bool> bindingChanged = collectGeneratedBindingRewrite(
        op, dialect, state, name, value, substitutions, solver,
        /*preserveI32Binding=*/!value.hasOneUse() &&
            isIdentityBinding(op, name));
    if (failed(bindingChanged))
      return failure();
    changed |= *bindingChanged;
  }

  if (!changed)
    return false;

  // Keep result bounds when binding expansion hides producer correlations.
  std::optional<SignedI64Range> resultRange =
      inferSignedI64Range(store, op.getExpr().getValue(), state.assumptions);

  FailureOr<GeneratedIndexExprSimplification> simplification =
      substituteAndSimplifyGenerated(op, store, substitutions,
                                     state.assumptions);
  if (failed(simplification))
    return failure();
  if (resultRange && failed(appendExprSignedRangeAssumption(
                         store, simplification->expr, *resultRange,
                         simplification->assumptions)))
    return op.emitError(
        "failed to preserve generated wave.index_expr result range");
  SmallVector<IndexExprBinding> liveBindings =
      collectLiveBindings(simplification->expr, state.bindings);
  llvm::DenseSet<StringRef> liveSymbols;
  for (const IndexExprBinding &binding : liveBindings)
    liveSymbols.insert(binding.name);
  SmallVector<sym::PredHandle> liveAssumptions =
      filterIndexExprPredicatesBySymbols(simplification->assumptions,
                                         liveSymbols);
  if (getIndexExprType(op.getContext(), liveBindings) !=
      op.getResult().getType())
    return false;

  rewriter.setInsertionPoint(op);
  IndexExprOp replacement =
      createIndexExpr(rewriter, op.getLoc(), op.getContext(),
                      simplification->expr, liveBindings, liveAssumptions);
  rewriter.replaceOp(op, replacement.getResult());
  return true;
}

struct GeneratePtrAddIndexExprPattern : OpRewritePattern<PtrAddOp> {
  GeneratePtrAddIndexExprPattern(MLIRContext *context, bool &hadFailure,
                                 DataFlowSolver &solver)
      : OpRewritePattern(context), solver(solver), hadFailure(hadFailure) {}

  LogicalResult matchAndRewrite(PtrAddOp op,
                                PatternRewriter &rewriter) const override {
    WaveDialect *dialect = op->getContext()->getLoadedDialect<WaveDialect>();
    if (!dialect) {
      op.emitError("Wave dialect is not loaded");
      hadFailure = true;
      return failure();
    }

    FailureOr<bool> rewritten = rewritePtrAdd(rewriter, op, *dialect, solver);
    if (failed(rewritten)) {
      hadFailure = true;
      return failure();
    }
    return success(*rewritten);
  }

  DataFlowSolver &solver;
  bool &hadFailure;
};

struct GenerateIndexExprBindingPattern : OpRewritePattern<IndexExprOp> {
  GenerateIndexExprBindingPattern(MLIRContext *context, bool &hadFailure,
                                  DataFlowSolver &solver)
      : OpRewritePattern(context), solver(solver), hadFailure(hadFailure) {}

  LogicalResult matchAndRewrite(IndexExprOp op,
                                PatternRewriter &rewriter) const override {
    WaveDialect *dialect = op->getContext()->getLoadedDialect<WaveDialect>();
    if (!dialect) {
      op.emitError("Wave dialect is not loaded");
      hadFailure = true;
      return failure();
    }

    FailureOr<bool> rewritten =
        rewriteIndexExpr(rewriter, op, *dialect, solver);
    if (failed(rewritten)) {
      hadFailure = true;
      return failure();
    }
    return success(*rewritten);
  }

  DataFlowSolver &solver;
  bool &hadFailure;
};

struct GenerateCmpIndexExprPattern : OpRewritePattern<CmpIOp> {
  GenerateCmpIndexExprPattern(MLIRContext *context, bool &hadFailure)
      : OpRewritePattern(context), hadFailure(hadFailure) {}

  LogicalResult matchAndRewrite(CmpIOp op,
                                PatternRewriter &rewriter) const override {
    FailureOr<bool> maskRewrite = rewriteIntegerizedMaskAndCmp(rewriter, op);
    if (failed(maskRewrite)) {
      hadFailure = true;
      return failure();
    }
    if (*maskRewrite)
      return success();
    return failure();
  }

  bool &hadFailure;
};

struct WaveGenerateIndexExprsPass
    : public wave::impl::WaveGenerateIndexExprsBase<
          WaveGenerateIndexExprsPass> {
  void runOnOperation() override {
    Operation *root = getOperation();
    DataFlowSolver solver;
    dataflow::loadBaselineAnalyses(solver);
    solver.load<dataflow::IntegerRangeAnalysis>();
    if (failed(solver.initializeAndRun(root))) {
      root->emitError("IntegerRangeAnalysis failed for wave.index_expr "
                      "generation pass");
      return signalPassFailure();
    }

    bool failed = false;
    RewritePatternSet patterns(&getContext());
    patterns.add<GenerateCmpIndexExprPattern>(&getContext(), failed);
    patterns
        .add<GenerateIndexExprBindingPattern, GeneratePtrAddIndexExprPattern>(
            &getContext(), failed, solver);
    if (mlir::failed(
            applyPatternsGreedily(getOperation(), std::move(patterns))) ||
        failed)
      return signalPassFailure();
  }
};

} // namespace
