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
#include "mlir/IR/PatternMatch.h"
#include "mlir/Transforms/GreedyPatternRewriteDriver.h"
#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/DenseSet.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/ADT/StringMap.h"
#include "llvm/Support/MathExtras.h"

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

static bool isIndexValueType(Type type) {
  if (type.isIndex())
    return true;
  if (auto simdType = dyn_cast<SimdType>(type))
    return simdType.getElementType().isIndex();
  return false;
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

static bool isIndexBinaryOp(BinaryOp op) {
  return isIndexValueType(op.getResult().getType()) &&
         isIndexValueType(op.getLhs().getType()) &&
         isIndexValueType(op.getRhs().getType());
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

static bool canBuildSymbolicBinaryOp(BinaryOp op, bool allowI64Integers) {
  if (!isSymbolicBinaryOp(op, allowI64Integers))
    return false;
  if (isNoSignedWrapSymbolicArithmetic(op.getKind()))
    return op.hasNoSignedWrap();
  return op.getKind() == BinaryKind::XOrI || op.getKind() == BinaryKind::DivSI;
}

static bool isSymbolicRootBinaryOp(BinaryOp op, bool allowI64Integers) {
  if (!canBuildSymbolicBinaryOp(op, allowI64Integers))
    return false;
  return isIndexBinaryOp(op) || op.getKind() == BinaryKind::DivSI;
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

static bool hasNonNegativeLowerBound(const sym::InferredRange &range) {
  return range.lower && range.lower->denominator > 0 &&
         range.lower->numerator >= 0;
}

static bool isAssumedNonNegative(sym::Store &store, Value value) {
  while (AssumeOp assume = value.getDefiningOp<AssumeOp>()) {
    FailureOr<sym::ExprHandle> expr =
        sym::composeExprSym(store, assume.getName());
    if (failed(expr))
      return false;
    SmallVector<sym::PredHandle, 4> assumptions;
    for (Attribute attr : assume.getAssumptions())
      assumptions.push_back(cast<PredAttr>(attr).getValue());
    std::optional<sym::InferredRange> range =
        sym::inferRange(store, *expr, assumptions);
    if (range && hasNonNegativeLowerBound(*range))
      return true;
    value = assume.getValue();
  }
  return false;
}

static bool isProvenNonNegative(DataFlowSolver &solver, sym::Store &store,
                                Value value) {
  if (SplatOp splat = value.getDefiningOp<SplatOp>())
    return isProvenNonNegative(solver, store, splat.getSource());
  if (std::optional<int64_t> constant = getSplatOrConstantInt(value))
    return *constant >= 0;
  if (isAssumedNonNegative(store, value))
    return true;
  std::optional<ConstantIntRanges> range = finiteSignedRange(solver, value);
  return range && !range->smin().isNegative();
}

static bool isPositivePowerOfTwo(int64_t value) {
  return value > 0 && llvm::isPowerOf2_64(static_cast<uint64_t>(value));
}

class SymbolicValueBuilder {
public:
  explicit SymbolicValueBuilder(WaveDialect &dialect, DataFlowSolver &solver,
                                bool allowI64Integers = false)
      : solver(solver), store(dialect.getSymbolStore()),
        allowI64Integers(allowI64Integers) {}

  FailureOr<std::optional<SymbolicOffset>> build(Value value) {
    if (!hasSymbolicRoot(value))
      return std::optional<SymbolicOffset>{};

    bool skip = false;
    FailureOr<sym::ExprHandle> expr = buildExpr(value, skip, false);
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
    if (BinaryOp binary = value.getDefiningOp<BinaryOp>())
      return isSymbolicRootBinaryOp(binary, allowI64Integers);
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
    if (SplatOp splat = value.getDefiningOp<SplatOp>())
      return buildExpr(splat.getSource(), skip, allowLeaf, depth + 1);
    if (BinaryOp binary = value.getDefiningOp<BinaryOp>())
      return buildBinary(binary, skip, depth + 1);
    if (allowLeaf)
      return bindSymbol(value, skip);
    skip = true;
    return failure();
  }

  FailureOr<sym::ExprHandle> buildIndexExpr(IndexExprOp op) {
    FailureOr<SymbolicOffset> symbolic = getIndexExprSymbolicOffset(op);
    if (failed(symbolic))
      return failure();
    return appendOffset(*symbolic);
  }

  FailureOr<sym::ExprHandle> buildBinary(BinaryOp op, bool &skip,
                                         unsigned depth) {
    if (!canBuildSymbolicBinaryOp(op, allowI64Integers)) {
      skip = true;
      return failure();
    }
    if (op.getKind() == BinaryKind::ShLI)
      return buildShift(op, skip, depth);
    if (op.getKind() == BinaryKind::DivSI)
      return buildSignedDiv(op, skip, depth);

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

  FailureOr<sym::ExprHandle> buildSignedDiv(BinaryOp op, bool &skip,
                                            unsigned depth) {
    std::optional<int64_t> divisor = getSplatOrConstantInt(op.getRhs());
    if (!divisor || !isPositivePowerOfTwo(*divisor) ||
        !isProvenNonNegative(solver, store, op.getLhs())) {
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

  FailureOr<sym::ExprHandle> bindSymbol(Value value, bool &skip) {
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
    if (std::optional<ConstantIntRanges> range =
            finiteSignedRange(solver, value))
      appendRangeAndAssumePredicates(store, value, it->getKey(), *range,
                                     offset.assumptions);
    else
      appendAssumePredicates(store, value, it->getKey(), offset.assumptions);
    return *expr;
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
  DataFlowSolver &solver;
  sym::Store &store;
  bool allowI64Integers = false;
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
                               /*allowI64Integers=*/hasGlobalPointerBase(op));
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

static FailureOr<bool> collectGeneratedBindingRewrite(
    IndexExprOp op, WaveDialect &dialect, BindingState &state, StringRef name,
    Value value, SmallVectorImpl<sym::ExprSubstitution> &substitutions,
    DataFlowSolver &solver) {
  SymbolicValueBuilder builder(dialect, solver);
  FailureOr<std::optional<SymbolicOffset>> symbolic = builder.build(value);
  if (failed(symbolic))
    return op.emitError("failed to generate wave.index_expr binding");
  if (!*symbolic) {
    if (failed(appendBinding(state, name, value)))
      return failure();
    return false;
  }

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
