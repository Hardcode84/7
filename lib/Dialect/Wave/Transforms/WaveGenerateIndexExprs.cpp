//===- WaveGenerateIndexExprs.cpp - Symbolize address math ------*- C++ -*-===//
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

static bool isPredicateImplied(sym::Store &store, sym::PredHandle pred,
                               ArrayRef<sym::PredHandle> assumptions) {
  sym::PredView view(pred);
  if (view.getKind() == sym::PredKind::And) {
    for (uint32_t i : llvm::seq<uint32_t>(0, view.getLogicArgCount()))
      if (!isPredicateImplied(store, view.getLogicArg(i), assumptions))
        return false;
    return true;
  }
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
  if (SplatOp splat = value.getDefiningOp<SplatOp>())
    return getSplatOrConstantInt(splat.getSource());
  return std::nullopt;
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
  std::optional<int64_t> lo = floorRational(*range->lower);
  std::optional<int64_t> hi = ceilRational(*range->upper);
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
  std::optional<int64_t> lo = floorRational(*range->lower);
  std::optional<int64_t> hi = ceilRational(*range->upper);
  if (!lo || !hi)
    return std::nullopt;
  return SignedI64Range{*lo, *hi};
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
                      unsigned depth = 0) {
  if (depth > kMaxSymbolicValueDepth)
    return std::nullopt;
  if (std::optional<int64_t> constant = getSplatOrConstantInt(value))
    return SignedI64Range{*constant, *constant};
  if (AssumeOp assume = value.getDefiningOp<AssumeOp>())
    return intersectRange(
        computeSignedI64Range(assume.getValue(), solver, store, depth + 1),
        finiteAssumeSignedI64Range(store, assume));
  if (SplatOp splat = value.getDefiningOp<SplatOp>())
    return computeSignedI64Range(splat.getSource(), solver, store, depth + 1);

  if (BinaryOp binary = value.getDefiningOp<BinaryOp>()) {
    unsigned bits = elementStorageBitWidth(binary.getResult().getType());
    if (bits == 0 || bits > 64)
      return std::nullopt;

    std::optional<SignedI64Range> lhs =
        computeSignedI64Range(binary.getLhs(), solver, store, depth + 1);
    std::optional<SignedI64Range> rhs =
        computeSignedI64Range(binary.getRhs(), solver, store, depth + 1);
    if (!lhs || !rhs)
      return finiteSignedI64Range(solver, value);
    return computeBinarySignedI64Range(binary, *lhs, *rhs, bits, solver, value);
  }

  return finiteSignedI64Range(solver, value);
}

static bool rangeProvesNoSignedOverflow(BinaryOp op, DataFlowSolver &solver,
                                        sym::Store &store) {
  if (op.hasNoSignedWrap())
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
                                     DataFlowSolver &solver,
                                     sym::Store &store) {
  if (!isSymbolicBinaryOp(op, allowI64Integers))
    return false;
  if (isNoSignedWrapSymbolicArithmetic(op.getKind()))
    return rangeProvesNoSignedOverflow(op, solver, store);
  switch (op.getKind()) {
  case BinaryKind::XOrI:
  case BinaryKind::DivSI:
  case BinaryKind::ShRUI:
  case BinaryKind::AndI:
    return true;
  default:
    return false;
  }
}

static bool isSymbolicRootBinaryOp(BinaryOp op, bool allowI64Integers,
                                   DataFlowSolver &solver, sym::Store &store) {
  return canBuildSymbolicBinaryOp(op, allowI64Integers, solver, store);
}

class SymbolicValueBuilder {
public:
  explicit SymbolicValueBuilder(WaveDialect &dialect, DataFlowSolver &solver,
                                bool allowI64Integers = false,
                                bool assumeI32StorageRange = false,
                                bool bindI32Root = false,
                                bool requireI32RootRange = false)
      : dialect(dialect), solver(solver), store(dialect.getSymbolStore()),
        allowI64Integers(allowI64Integers),
        assumeI32StorageRange(assumeI32StorageRange), bindI32Root(bindI32Root),
        requireI32RootRange(requireI32RootRange) {}

  FailureOr<std::optional<SymbolicOffset>> build(Value value) {
    if (!hasSymbolicRoot(value))
      return std::optional<SymbolicOffset>{};

    bool skip = false;
    FailureOr<sym::ExprHandle> expr = failure();
    if (bindI32Root && isSignlessI32StorageType(value.getType())) {
      std::optional<SignedI64Range> rootRange = inferI32RootRange(value);
      expr = rootRange || !requireI32RootRange
                 ? bindSymbol(value, skip, rootRange)
                 : buildExpr(value, skip, false);
    } else {
      expr = buildExpr(value, skip, false);
    }
    if (skip)
      return std::optional<SymbolicOffset>{};
    if (failed(expr))
      return failure();
    FailureOr<sym::ExprHandle> simplified =
        offset.assumptions.empty()
            ? sym::simplifyExpr(store, *expr)
            : sym::simplifyExpr(store, *expr, offset.assumptions);
    if (failed(simplified))
      return failure();
    offset.expr = *simplified;
    return std::optional<SymbolicOffset>{std::move(offset)};
  }

private:
  bool hasSymbolicRoot(Value value) {
    if (AssumeOp assume = value.getDefiningOp<AssumeOp>())
      return hasSymbolicRoot(assume.getValue());
    if (BinaryOp binary = value.getDefiningOp<BinaryOp>())
      return isSymbolicRootBinaryOp(binary, allowI64Integers, solver, store);
    if (SplatOp splat = value.getDefiningOp<SplatOp>())
      return hasSymbolicRoot(splat.getSource());
    return false;
  }

  FailureOr<sym::ExprHandle> buildExpr(Value value, bool &skip, bool allowLeaf,
                                       unsigned depth = 0) {
    if (depth > kMaxSymbolicValueDepth) {
      skip = true;
      return failure();
    }
    if (std::optional<int64_t> constant = getConstantIntValue(value))
      return sym::composeExprInt(store, *constant);
    if (IndexExprOp indexExpr = value.getDefiningOp<IndexExprOp>())
      return buildIndexExpr(indexExpr);
    if (AssumeOp assume = value.getDefiningOp<AssumeOp>())
      return buildAssumeExpr(value, assume, skip, allowLeaf, depth);
    if (SplatOp splat = value.getDefiningOp<SplatOp>())
      return buildSplatExpr(splat, skip, allowLeaf, depth);
    if (BinaryOp binary = value.getDefiningOp<BinaryOp>())
      return buildBinaryExpr(value, binary, skip, allowLeaf, depth);
    return bindOrSkip(value, skip, allowLeaf);
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
    if (!canBuildSymbolicBinaryOp(op, allowI64Integers, solver, store)) {
      skip = true;
      return failure();
    }
    switch (op.getKind()) {
    case BinaryKind::ShLI:
      return buildShift(op, skip, depth);
    case BinaryKind::DivSI:
      return buildSignedDiv(op, skip, depth);
    case BinaryKind::ShRUI:
      return buildUnsignedShiftRight(op, skip, depth);
    case BinaryKind::AndI:
      return buildPowerOfTwoMask(op, skip, depth);
    default:
      return buildPlainBinary(op, skip, depth);
    }
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
    return success();
  }

  std::optional<SignedI64Range> inferI32RootRange(Value value) {
    if (std::optional<SignedI64Range> range =
            computeSignedI64Range(value, solver, store))
      return intersectRange(range, signedI32StorageRange());
    SymbolicValueBuilder expanded(dialect, solver, allowI64Integers);
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

  FailureOr<sym::ExprHandle> appendOffset(const SymbolicOffset &symbolic) {
    SmallVector<sym::ExprSubstitution> substitutions;
    for (const SymbolicOffsetBinding &binding : symbolic.bindings) {
      StringRef name = symbolName(binding);
      auto valueIt = nameByValue.find(binding.value);
      if (valueIt != nameByValue.end()) {
        FailureOr<sym::ExprHandle> replacement =
            sym::composeExprSym(store, valueIt->second);
        if (failed(replacement))
          return failure();
        substitutions.push_back({binding.name, *replacement});
        continue;
      }
      auto existing = bindingByName.find(name);
      if (existing == bindingByName.end()) {
        auto [it, inserted] = bindingByName.try_emplace(name, binding.value);
        (void)inserted;
        nameByValue[binding.value] = it->getKey();
        offset.bindings.push_back(binding);
        offset.laneWidth = std::max(offset.laneWidth, symbolic.laneWidth);
        continue;
      }
      if (existing->second == binding.value)
        continue;

      std::string fresh = freshName(name);
      auto [freshIt, inserted] =
          bindingByName.try_emplace(fresh, binding.value);
      (void)inserted;
      nameByValue[binding.value] = freshIt->getKey();
      FailureOr<sym::ExprHandle> replacement =
          sym::composeExprSym(store, freshIt->getKey());
      if (failed(replacement))
        return failure();
      offset.bindings.push_back({*replacement, binding.value, binding.kind});
      offset.laneWidth = std::max(offset.laneWidth, symbolic.laneWidth);
      substitutions.push_back({binding.name, *replacement});
    }

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
  unsigned nextRawSymbol = 0;
};

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

static FailureOr<bool> rewritePtrAdd(PatternRewriter &rewriter, PtrAddOp op,
                                     WaveDialect &dialect,
                                     DataFlowSolver &solver) {
  SymbolicValueBuilder builder(dialect, solver,
                               /*allowI64Integers=*/hasGlobalPointerBase(op),
                               /*assumeI32StorageRange=*/true,
                               /*bindI32Root=*/false,
                               /*requireI32RootRange=*/false);
  FailureOr<std::optional<SymbolicOffset>> offset =
      builder.build(op.getOffset());
  if (failed(offset))
    return op.emitError("failed to generate wave.index_expr offset");
  if (!*offset)
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

static bool shouldPreserveGeneratedBinding(Value value,
                                           bool preserveI32Binding) {
  if (preserveI32Binding && isSignlessI32StorageType(value.getType()))
    return true;
  return !value.hasOneUse() && !getSplatOrConstantInt(value);
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

  SymbolicValueBuilder builder(dialect, solver);
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

static FailureOr<sym::ExprHandle>
substituteAndSimplifyGenerated(IndexExprOp op, sym::Store &store,
                               ArrayRef<sym::ExprSubstitution> substitutions,
                               ArrayRef<sym::PredHandle> assumptions) {
  FailureOr<sym::ExprHandle> substituted =
      sym::substituteExpr(store, op.getExpr().getValue(), substitutions);
  if (failed(substituted))
    return op.emitError("failed to substitute generated wave.index_expr");
  FailureOr<sym::ExprHandle> simplified =
      assumptions.empty() ? sym::simplifyExpr(store, *substituted)
                          : sym::simplifyExpr(store, *substituted, assumptions);
  if (failed(simplified))
    return op.emitError("failed to simplify generated wave.index_expr");
  return *simplified;
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
        op, dialect, state, name, value, substitutions, solver);
    if (failed(bindingChanged))
      return failure();
    changed |= *bindingChanged;
  }

  if (!changed)
    return false;

  FailureOr<SmallVector<sym::PredHandle>> assumptions =
      substituteIndexExprPredicates(store, state.assumptions, substitutions);
  if (failed(assumptions))
    return failure();
  FailureOr<sym::ExprHandle> simplified =
      substituteAndSimplifyGenerated(op, store, substitutions, *assumptions);
  if (failed(simplified))
    return failure();
  SmallVector<IndexExprBinding> liveBindings =
      collectLiveBindings(*simplified, state.bindings);
  llvm::DenseSet<StringRef> liveSymbols;
  for (const IndexExprBinding &binding : liveBindings)
    liveSymbols.insert(binding.name);
  SmallVector<sym::PredHandle> liveAssumptions =
      filterIndexExprPredicatesBySymbols(*assumptions, liveSymbols);
  if (getIndexExprType(op.getContext(), liveBindings) !=
      op.getResult().getType())
    return false;

  rewriter.setInsertionPoint(op);
  IndexExprOp replacement =
      createIndexExpr(rewriter, op.getLoc(), op.getContext(), *simplified,
                      liveBindings, liveAssumptions);
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
