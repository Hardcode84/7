//===- WaveCombinePointerOffsets.cpp - Fold ptr_add chains ----*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/Wave/Transforms/Passes.h"

#include "../IR/WaveIndexExpr.h"
#include "../IR/WaveMemoryAddress.h"
#include "WaveSymbolicValueAnalysis.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/Utils/StaticValueUtils.h"
#include "mlir/Dialect/Wave/IR/Wave.h"
#include "mlir/IR/Builders.h"
#include "mlir/IR/PatternMatch.h"
#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/DenseSet.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/ADT/SmallPtrSet.h"
#include "llvm/ADT/StringMap.h"

#include <array>
#include <cassert>
#include <optional>
#include <string>

namespace mlir::wave {
#define GEN_PASS_DEF_WAVECOMBINEPOINTEROFFSETS
#include "mlir/Dialect/Wave/Transforms/Passes.h.inc"
} // namespace mlir::wave

using namespace mlir;
using namespace mlir::wave;

namespace {

struct IndexExprBinding {
  std::string name;
  Value value;
};

struct IndexExprMergeState {
  SmallVector<IndexExprBinding> bindings;
  SmallVector<sym::PredHandle> assumptions;
  SmallVector<sym::ExprSubstitution> substitutions;
  SmallVector<IndexExprOp> producers;
  SmallVector<AssumeOp> assumes;
  llvm::DenseMap<Value, StringRef> byValue;
  llvm::SmallPtrSet<Operation *, 4> seenProducers;
  llvm::StringMap<Value> reserved;
  llvm::StringMap<Value> emitted;
};

struct NestedProducer {
  IndexExprOp producer;
  SmallVector<AssumeOp, 2> assumes;
};

static sym::ExprHandle symbolExpr(sym::Store &store, StringRef name) {
  return sym::composeExprSym(store, name);
}

static void appendNameRef(ArrayRef<IndexExprBinding> bindings,
                          SmallVectorImpl<StringRef> &names) {
  for (const IndexExprBinding &binding : bindings)
    names.push_back(binding.name);
}

static void appendValues(ArrayRef<IndexExprBinding> bindings,
                         SmallVectorImpl<Value> &values) {
  for (const IndexExprBinding &binding : bindings)
    values.push_back(binding.value);
}

static LogicalResult appendBinding(SmallVectorImpl<IndexExprBinding> &bindings,
                                   llvm::StringMap<Value> &emitted,
                                   StringRef name, Value value) {
  auto [it, inserted] = emitted.try_emplace(name, value);
  if (!inserted && it->second != value)
    return failure();
  if (!inserted)
    return success();
  bindings.push_back({name.str(), value});
  return success();
}

static StringRef reserveBindingName(StringRef requested, Value value,
                                    llvm::StringMap<Value> &reserved,
                                    llvm::DenseMap<Value, StringRef> &byValue) {
  return reserveIndexExprBindingName(requested, value, reserved, byValue);
}

static sym::ExprHandle
substituteExprSymbols(sym::Store &store, sym::ExprHandle expr,
                      ArrayRef<sym::ExprSubstitution> substitutions) {
  if (substitutions.empty())
    return expr;
  return sym::substituteExpr(store, expr, substitutions);
}

static FailureOr<sym::ExprHandle>
remapProducerExpr(sym::Store &store, IndexExprOp producer,
                  llvm::StringMap<Value> &reserved,
                  llvm::DenseMap<Value, StringRef> &byValue,
                  SmallVectorImpl<IndexExprBinding> &bindings,
                  llvm::StringMap<Value> &emitted,
                  SmallVectorImpl<sym::PredHandle> &assumptions) {
  SmallVector<sym::ExprSubstitution> substitutions;
  for (auto [nameAttr, value] :
       llvm::zip(producer.getNames(), producer.getBindings())) {
    StringRef oldName = cast<StringAttr>(nameAttr).getValue();
    StringRef newName = reserveBindingName(oldName, value, reserved, byValue);
    if (failed(appendBinding(bindings, emitted, newName, value)))
      return failure();
    if (newName == oldName)
      continue;

    sym::ExprHandle target = symbolExpr(store, oldName);
    sym::ExprHandle replacement = symbolExpr(store, newName);
    substitutions.push_back({target, replacement});
  }

  SmallVector<sym::PredHandle> producerAssumptions;
  appendIndexExprPredicates(producer, producerAssumptions);
  FailureOr<SmallVector<sym::PredHandle>> remappedAssumptions =
      substituteIndexExprPredicates(store, producerAssumptions, substitutions);
  if (failed(remappedAssumptions))
    return failure();
  llvm::append_range(assumptions, *remappedAssumptions);

  return substituteExprSymbols(store, producer.getExpr().getValue(),
                               substitutions);
}

static void collectFreeSymbols(sym::ExprHandle expr,
                               llvm::DenseSet<StringRef> &symbols) {
  sym::walkSymbolNames(expr, [&](StringRef name) { symbols.insert(name); });
}

static bool hasSameBindings(IndexExprOp op,
                            ArrayRef<IndexExprBinding> bindings) {
  if (op.getBindings().size() != bindings.size())
    return false;
  for (auto [index, binding] : llvm::enumerate(bindings)) {
    if (binding.value != op.getBindings()[index])
      return false;
    if (binding.name != cast<StringAttr>(op.getNames()[index]).getValue())
      return false;
  }
  return true;
}

static bool isScalarOffset(Type type) {
  return type.isIndex() || isa<IntegerType>(type);
}

static bool needsSimdOffset(Type resultType, Type baseType, Type offsetType) {
  return isa<SimdType>(resultType) && isa<PtrType>(baseType) &&
         isScalarOffset(offsetType);
}

static Type getSimdOffsetType(Type resultType, Type offsetType) {
  if (!offsetType.isIndex() && !offsetType.isInteger(32))
    return {};
  auto resultSimd = cast<SimdType>(resultType);
  return SimdType::get(resultType.getContext(), offsetType,
                       resultSimd.getWidth());
}

static bool canCreatePtrAdd(Type resultType, Type baseType, Type offsetType) {
  if (!needsSimdOffset(resultType, baseType, offsetType))
    return true;
  return !!getSimdOffsetType(resultType, offsetType);
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

static void eraseDeadProducers(IRRewriter &rewriter, ArrayRef<AssumeOp> assumes,
                               ArrayRef<IndexExprOp> producers) {
  for (AssumeOp assume : assumes)
    if (assume && assume->use_empty())
      rewriter.eraseOp(assume);
  for (IndexExprOp producer : producers)
    if (producer && producer->use_empty())
      rewriter.eraseOp(producer);
}

static NestedProducer getNestedProducer(Value value) {
  if (IndexExprOp producer = value.getDefiningOp<IndexExprOp>())
    return {producer, {}};
  SmallVector<AssumeOp, 2> assumes;
  while (AssumeOp assume = value.getDefiningOp<AssumeOp>()) {
    assumes.push_back(assume);
    value = assume.getValue();
  }
  if (IndexExprOp producer = value.getDefiningOp<IndexExprOp>())
    return {producer, std::move(assumes)};
  return {};
}

static bool hasNestedIndexExprBinding(IndexExprOp op) {
  return llvm::any_of(op.getBindings(), [](Value binding) {
    return !!getNestedProducer(binding).producer;
  });
}

static void seedBindingNames(IndexExprOp op, IndexExprMergeState &state) {
  for (auto [nameAttr, value] : llvm::zip(op.getNames(), op.getBindings())) {
    StringRef name = cast<StringAttr>(nameAttr).getValue();
    state.reserved[name] = value;
  }

  for (auto [nameAttr, value] : llvm::zip(op.getNames(), op.getBindings())) {
    if (getNestedProducer(value).producer)
      continue;
    StringRef name = cast<StringAttr>(nameAttr).getValue();
    llvm::StringMap<Value>::iterator it = state.reserved.find(name);
    state.byValue.try_emplace(value, it->getKey());
  }
}

static LogicalResult appendDirectBinding(IndexExprMergeState &state,
                                         StringRef name, Value value) {
  return appendBinding(state.bindings, state.emitted, name, value);
}

static FailureOr<sym::ExprHandle>
remapNestedBinding(sym::Store &store, IndexExprOp producer,
                   IndexExprMergeState &state) {
  return remapProducerExpr(store, producer, state.reserved, state.byValue,
                           state.bindings, state.emitted, state.assumptions);
}

struct MergedIndexExpr {
  SmallVector<sym::PredHandle> assumptions;
  sym::ExprHandle expr;
};

static std::optional<std::pair<int64_t, int64_t>>
inferIntegerRange(sym::Store &store, sym::ExprHandle expr,
                  ArrayRef<sym::PredHandle> assumptions) {
  std::optional<sym::InferredRange> range =
      sym::inferRange(store, expr, assumptions);
  if (!range || !range->lower || !range->upper)
    return std::nullopt;
  std::optional<int64_t> lower = sym::ceilEndpoint(*range->lower);
  std::optional<int64_t> upper = sym::floorEndpoint(*range->upper);
  if (!lower || !upper || *lower > *upper)
    return std::nullopt;
  return std::make_pair(*lower, *upper);
}

static sym::PredHandle
buildExprRangeAssumption(sym::Store &store, sym::ExprHandle expr,
                         std::pair<int64_t, int64_t> range) {
  constexpr llvm::StringLiteral resultName = "__wave_combined_result";
  sym::ExprHandle result = symbolExpr(store, resultName);
  sym::PredHandle assumption =
      sym::rangeAssumption(store, resultName, range.first, range.second);
  std::array<sym::ExprSubstitution, 1> substitution{
      sym::ExprSubstitution{result, expr}};
  return sym::substitutePred(store, assumption, substitution);
}

static void
appendExprRangeAssumption(sym::Store &store, MergedIndexExpr &merged,
                          std::optional<std::pair<int64_t, int64_t>> range) {
  if (!range)
    return;
  merged.assumptions.push_back(
      buildExprRangeAssumption(store, merged.expr, *range));
}

static FailureOr<MergedIndexExpr>
substituteAndSimplify(IndexExprOp op, sym::Store &store,
                      ArrayRef<sym::ExprSubstitution> substitutions,
                      ArrayRef<sym::PredHandle> assumptions) {
  FailureOr<std::unique_ptr<sym::Analysis>> analysis =
      sym::Analysis::create(store);
  if (failed(analysis))
    return op.emitError("failed to construct chained wave.index_expr facts");
  FailureOr<SmallVector<sym::PredHandle>> substitutedAssumptions =
      substituteIndexExprPredicates(**analysis, assumptions, substitutions);
  if (failed(substitutedAssumptions))
    return op.emitError("failed to substitute chained wave.index_expr "
                        "assumptions");
  for (sym::PredHandle pred : *substitutedAssumptions)
    if (failed((*analysis)->assume(pred)))
      return op.emitError("failed to assume chained wave.index_expr facts");
  FailureOr<sym::ExprHandle> substituted =
      (*analysis)->substitute(op.getExpr().getValue(), substitutions);
  if (failed(substituted))
    return op.emitError("failed to substitute chained wave.index_expr");
  FailureOr<sym::ExprHandle> simplified = (*analysis)->simplify(*substituted);
  if (failed(simplified))
    return op.emitError("failed to simplify chained wave.index_expr");
  sym::ExprHandle result =
      shouldUseSimplifiedIndexExpr(*simplified, *substituted) ? *simplified
                                                              : *substituted;
  return MergedIndexExpr{std::move(*substitutedAssumptions), result};
}

static FailureOr<SmallVector<IndexExprBinding>>
collectLiveBindings(sym::ExprHandle expr, ArrayRef<IndexExprBinding> bindings) {
  llvm::DenseSet<StringRef> freeSymbols;
  collectFreeSymbols(expr, freeSymbols);

  SmallVector<IndexExprBinding> liveBindings;
  for (const IndexExprBinding &binding : bindings)
    if (freeSymbols.contains(binding.name))
      liveBindings.push_back(binding);
  return liveBindings;
}

static bool rewriteIndexExpr(IRRewriter &rewriter, IndexExprOp op,
                             sym::ExprHandle expr,
                             ArrayRef<IndexExprBinding> bindings,
                             ArrayRef<sym::PredHandle> assumptions) {
  SmallVector<StringRef> names;
  SmallVector<Value> values;
  appendNameRef(bindings, names);
  appendValues(bindings, values);

  Type resultType = getIndexExprResultType(op.getContext(), values);
  if (!canPreserveIndexExprResultType(resultType, op.getResult().getType()))
    return false;

  rewriter.setInsertionPoint(op);
  IndexExprOp replacement = IndexExprOp::create(
      rewriter, op.getLoc(), resultType, ExprAttr::get(op.getContext(), expr),
      getIndexExprPredArrayAttr(op.getContext(), assumptions),
      rewriter.getStrArrayAttr(names), values);
  Value result = preserveIndexExprResultType(
      rewriter, op.getLoc(), op.getResult().getType(), replacement.getResult());
  rewriter.replaceOp(op, result);
  return true;
}

static LogicalResult appendProducerBinding(sym::Store &store,
                                           IndexExprMergeState &state,
                                           StringRef name, Value value,
                                           NestedProducer nested) {
  sym::ExprHandle target = symbolExpr(store, name);
  FailureOr<sym::ExprHandle> replacement =
      remapNestedBinding(store, nested.producer, state);
  if (failed(replacement))
    return failure();
  state.substitutions.push_back({target, *replacement});
  appendAssumePredicates(store, value, name, state.assumptions);
  for (AssumeOp nestedAssume : nested.assumes)
    if (llvm::none_of(state.assumes,
                      [&](AssumeOp assume) { return assume == nestedAssume; }))
      state.assumes.push_back(nestedAssume);
  if (state.seenProducers.insert(nested.producer).second)
    state.producers.push_back(nested.producer);
  return success();
}

static LogicalResult collectIndexExprMerge(IndexExprOp op, sym::Store &store,
                                           IndexExprMergeState &state) {
  appendIndexExprPredicates(op, state.assumptions);
  for (auto [nameAttr, value] : llvm::zip(op.getNames(), op.getBindings())) {
    StringRef name = cast<StringAttr>(nameAttr).getValue();
    NestedProducer nested = getNestedProducer(value);
    if (nested.producer) {
      if (failed(appendProducerBinding(store, state, name, value, nested)))
        return failure();
      continue;
    }
    appendAssumePredicates(store, value, name, state.assumptions);
    if (failed(appendDirectBinding(state, name, value)))
      return failure();
  }
  return success();
}

static FailureOr<bool> combineIndexExpr(IRRewriter &rewriter, IndexExprOp op,
                                        sym::Store &store) {
  if (!hasNestedIndexExprBinding(op))
    return false;

  IndexExprMergeState state;
  seedBindingNames(op, state);
  if (failed(collectIndexExprMerge(op, store, state)))
    return op.emitError("failed to compose chained wave.index_expr");
  // Keep outer bounds when flattening hides producer correlations.
  std::optional<std::pair<int64_t, int64_t>> resultRange =
      inferIntegerRange(store, op.getExpr().getValue(), state.assumptions);
  FailureOr<MergedIndexExpr> merged =
      substituteAndSimplify(op, store, state.substitutions, state.assumptions);
  if (failed(merged))
    return failure();
  appendExprRangeAssumption(store, *merged, resultRange);

  FailureOr<SmallVector<IndexExprBinding>> liveBindings =
      collectLiveBindings(merged->expr, state.bindings);
  if (failed(liveBindings))
    return failure();
  llvm::DenseSet<StringRef> liveSymbols;
  for (const IndexExprBinding &binding : *liveBindings)
    liveSymbols.insert(binding.name);
  SmallVector<sym::PredHandle> liveAssumptions =
      filterIndexExprPredicatesBySymbols(merged->assumptions, liveSymbols);
  bool exprChanged = !(merged->expr == op.getExpr().getValue());
  if (!exprChanged && hasSameBindings(op, *liveBindings))
    return false;

  if (!rewriteIndexExpr(rewriter, op, merged->expr, *liveBindings,
                        liveAssumptions))
    return false;
  eraseDeadProducers(rewriter, state.assumes, state.producers);
  return true;
}

static SmallVector<PtrAddOp> collectPtrAddChain(PtrAddOp op) {
  SmallVector<PtrAddOp> chain;
  for (PtrAddOp cur = op; cur; cur = cur.getBase().getDefiningOp<PtrAddOp>())
    chain.push_back(cur);
  return chain;
}

static FailureOr<Value> createPtrAdd(IRRewriter &rewriter, Location loc,
                                     Type resultType, Value base,
                                     Value offset) {
  if (needsSimdOffset(resultType, base.getType(), offset.getType())) {
    Type offsetType = getSimdOffsetType(resultType, offset.getType());
    if (!offsetType)
      return failure();
    Value simdOffset = SplatOp::create(rewriter, loc, offsetType, offset);
    return PtrAddOp::create(rewriter, loc, resultType, base, simdOffset)
        .getResult();
  }
  return PtrAddOp::create(rewriter, loc, resultType, base, offset).getResult();
}

struct PreparedPointerOffsets {
  SmallVector<std::pair<PtrAddOp, Value>, 0> originals;
  SmallVector<Operation *> created;
};

struct DecodedPointerOffset {
  PtrAddOp add;
  SymbolicOffset offset;
};

static FailureOr<std::optional<SmallVector<DecodedPointerOffset>>>
decodePointerOffsets(ArrayRef<PtrAddOp> chain, WaveDialect &dialect) {
  SmallVector<DecodedPointerOffset> decoded;
  for (PtrAddOp add : llvm::reverse(chain)) {
    if (add.getOffset().getDefiningOp<IndexExprOp>() ||
        getConstantIntValue(add.getOffset()))
      continue;
    mlir::wave::detail::SymbolicValueBuilder builder(
        dialect, /*allowI64Integers=*/false,
        /*assumeI32StorageRange=*/false, /*expandIndexExprRoot=*/false,
        /*foldWaveConstants=*/true, /*modelWrappingArithmetic=*/false,
        /*fullyMergeAssumes=*/false,
        mlir::wave::detail::AssumeRootPolicy::ExpandSource,
        hasAddressArithmeticNoOverflowAssumption(add.getOperation()));
    builder.enableExactIntegerCasts();
    FailureOr<std::optional<SymbolicOffset>> offset =
        builder.build(add.getOffset());
    if (failed(offset))
      return failure();
    if (!*offset)
      return std::optional<SmallVector<DecodedPointerOffset>>{};
    decoded.push_back({add, std::move(**offset)});
  }
  return std::optional<SmallVector<DecodedPointerOffset>>{std::move(decoded)};
}

static FailureOr<bool>
validatePointerOffsets(ArrayRef<DecodedPointerOffset> decoded) {
  for (DecodedPointerOffset entry : decoded) {
    SmallVector<Value> bindings;
    for (const SymbolicOffsetBinding &binding : entry.offset.bindings) {
      if (sym::ExprView(binding.name).getSymbolName().empty())
        return failure();
      bindings.push_back(binding.value);
    }
    Type indexType = getIndexExprResultType(entry.add.getContext(), bindings);
    if (!canCreatePtrAdd(entry.add.getType(), entry.add.getBase().getType(),
                         indexType))
      return false;
  }
  return true;
}

static void materializePointerOffset(IRRewriter &rewriter,
                                     DecodedPointerOffset &entry,
                                     PreparedPointerOffsets &prepared) {
  SmallVector<Value> bindings;
  SmallVector<StringRef> names;
  for (const SymbolicOffsetBinding &binding : entry.offset.bindings) {
    StringRef name = sym::ExprView(binding.name).getSymbolName();
    assert(!name.empty() && "symbolic offset binding must have a name");
    names.push_back(name);
    bindings.push_back(binding.value);
  }
  Type indexType = getIndexExprResultType(entry.add.getContext(), bindings);
  rewriter.setInsertionPoint(entry.add);
  IndexExprOp index = IndexExprOp::create(
      rewriter, entry.add.getLoc(), indexType,
      ExprAttr::get(entry.add.getContext(), entry.offset.expr),
      getIndexExprPredArrayAttr(entry.add.getContext(),
                                entry.offset.assumptions),
      rewriter.getStrArrayAttr(names), bindings);
  prepared.created.push_back(index);
  Value replacement = index;
  if (needsSimdOffset(entry.add.getType(), entry.add.getBase().getType(),
                      indexType)) {
    Type simdType = getSimdOffsetType(entry.add.getType(), indexType);
    assert(simdType && "pointer offset type was prevalidated");
    replacement =
        SplatOp::create(rewriter, entry.add.getLoc(), simdType, replacement);
    prepared.created.push_back(replacement.getDefiningOp());
  }
  prepared.originals.push_back({entry.add, entry.add.getOffset()});
  rewriter.modifyOpInPlace(
      entry.add, [&] { entry.add.getOffsetMutable().assign(replacement); });
}

static FailureOr<std::optional<PreparedPointerOffsets>>
preparePointerOffsets(IRRewriter &rewriter, ArrayRef<PtrAddOp> chain,
                      WaveDialect &dialect) {
  FailureOr<std::optional<SmallVector<DecodedPointerOffset>>> decoded =
      decodePointerOffsets(chain, dialect);
  if (failed(decoded))
    return failure();
  if (!*decoded)
    return std::optional<PreparedPointerOffsets>{};
  FailureOr<bool> valid = validatePointerOffsets(**decoded);
  if (failed(valid))
    return failure();
  if (!*valid)
    return std::optional<PreparedPointerOffsets>{};

  PreparedPointerOffsets prepared;
  for (DecodedPointerOffset &entry : **decoded)
    materializePointerOffset(rewriter, entry, prepared);
  return std::optional<PreparedPointerOffsets>{std::move(prepared)};
}

static void discardPreparedPointerOffsets(IRRewriter &rewriter,
                                          PreparedPointerOffsets &prepared,
                                          bool restore) {
  if (restore)
    for (auto [add, original] : prepared.originals)
      rewriter.modifyOpInPlace(
          add, [&] { add.getOffsetMutable().assign(original); });
  for (Operation *op : llvm::reverse(prepared.created))
    if (op->use_empty())
      rewriter.eraseOp(op);
}

struct LiveIndexExprBindings {
  SmallVector<std::string> names;
  SmallVector<Value> values;
  SmallVector<sym::PredHandle> assumptions;
};

static LiveIndexExprBindings
collectLiveIndexExprBindings(const CheckedIndexExpr &checked,
                             sym::ExprHandle expression) {
  llvm::DenseSet<StringRef> freeSymbols;
  collectIndexExprRequiredSymbols(expression, checked.domain.facts,
                                  freeSymbols);
  LiveIndexExprBindings result;
  for (const indexing::IndexMap::Input &binding : checked.domain.inputs) {
    if (!binding.value)
      continue;
    StringRef name = sym::ExprView(binding.variable).getSymbolName();
    assert(!name.empty() && "symbolic offset binding must have a name");
    if (!freeSymbols.contains(name))
      continue;
    result.names.push_back(name.str());
    result.values.push_back(binding.value);
  }
  result.assumptions =
      filterIndexExprPredicatesBySymbols(checked.domain.facts, freeSymbols);
  return result;
}

static SmallVector<StringRef>
getIndexExprNameRefs(ArrayRef<std::string> names) {
  SmallVector<StringRef> result;
  result.reserve(names.size());
  for (StringRef name : names)
    result.push_back(name);
  return result;
}

static FailureOr<sym::ExprHandle>
simplifyCombinedPointerOffset(WaveDialect &dialect,
                              const CheckedIndexExpr &checked) {
  FailureOr<sym::ExprHandle> simplified = sym::simplifyExpr(
      dialect.getSymbolStore(), checked.expression, checked.domain.facts);
  if (failed(simplified))
    return failure();
  return shouldUseSimplifiedIndexExpr(*simplified, checked.expression)
             ? *simplified
             : checked.expression;
}

static FailureOr<bool> rewritePtrAddChain(IRRewriter &rewriter, PtrAddOp op,
                                          ArrayRef<PtrAddOp> chain,
                                          WaveDialect &dialect,
                                          MemoryAddress address) {
  FailureOr<std::optional<int64_t>> elementBits =
      getMemoryPointerElementBits(address.base.getType());
  if (failed(elementBits))
    return failure();
  if (!*elementBits)
    return false;
  FailureOr<std::optional<CheckedIndexExpr>> offset =
      getMemoryAddressElementOffset(dialect, address, **elementBits);
  if (failed(offset))
    return failure();
  if (!*offset)
    return false;
  const CheckedIndexExpr &checked = **offset;
  FailureOr<sym::ExprHandle> expression =
      simplifyCombinedPointerOffset(dialect, checked);
  if (failed(expression))
    return failure();
  LiveIndexExprBindings live =
      collectLiveIndexExprBindings(checked, *expression);
  SmallVector<StringRef> nameRefs = getIndexExprNameRefs(live.names);

  MLIRContext *ctx = op->getContext();
  rewriter.setInsertionPoint(op);
  Type indexType = getIndexExprResultType(ctx, live.values);
  if (!canCreatePtrAdd(op.getType(), address.base.getType(), indexType))
    return false;
  IndexExprOp index = IndexExprOp::create(
      rewriter, op.getLoc(), indexType, ExprAttr::get(ctx, *expression),
      getIndexExprPredArrayAttr(ctx, live.assumptions),
      rewriter.getStrArrayAttr(nameRefs), live.values);
  FailureOr<Value> replacement = createPtrAdd(
      rewriter, op.getLoc(), op.getType(), address.base, index.getResult());
  if (failed(replacement))
    return failure();
  rewriter.replaceOp(op, *replacement);
  for (PtrAddOp add : llvm::drop_begin(chain))
    if (add->use_empty())
      rewriter.eraseOp(add);
  return true;
}

static FailureOr<bool> combinePtrAdd(IRRewriter &rewriter, PtrAddOp op) {
  SmallVector<PtrAddOp> chain = collectPtrAddChain(op);
  if (chain.size() < 2)
    return false;

  WaveDialect *dialect = op->getContext()->getLoadedDialect<WaveDialect>();
  if (!dialect)
    return op.emitError("Wave dialect is not loaded");
  FailureOr<std::optional<PreparedPointerOffsets>> prepared =
      preparePointerOffsets(rewriter, chain, *dialect);
  if (failed(prepared))
    return op.emitError("failed to analyze combined pointer offset");
  if (!*prepared)
    return false;
  FailureOr<std::optional<MemoryAddress>> address =
      normalizeMemoryAddress(op.getResult(), *dialect);
  if (failed(address)) {
    discardPreparedPointerOffsets(rewriter, **prepared, /*restore=*/true);
    return op.emitError("failed to compose combined pointer offset");
  }
  if (!*address) {
    discardPreparedPointerOffsets(rewriter, **prepared, /*restore=*/true);
    return false;
  }
  FailureOr<bool> rewritten =
      rewritePtrAddChain(rewriter, op, chain, *dialect, std::move(**address));
  if (failed(rewritten) || !*rewritten)
    discardPreparedPointerOffsets(rewriter, **prepared, /*restore=*/true);
  else
    discardPreparedPointerOffsets(rewriter, **prepared, /*restore=*/false);
  return rewritten;
}

struct WaveCombinePointerOffsetsPass
    : public wave::impl::WaveCombinePointerOffsetsBase<
          WaveCombinePointerOffsetsPass> {
  void runOnOperation() override {
    IRRewriter rewriter(&getContext());
    bool changed = true;
    while (changed) {
      changed = false;
      Operation *root = getOperation();
      WaveDialect *dialect =
          root->getContext()->getLoadedDialect<WaveDialect>();
      if (!dialect) {
        root->emitError("Wave dialect is not loaded");
        return signalPassFailure();
      }
      WalkResult indexResult = root->walk([&](IndexExprOp op) {
        FailureOr<bool> folded =
            combineIndexExpr(rewriter, op, dialect->getSymbolStore());
        if (failed(folded)) {
          signalPassFailure();
          return WalkResult::interrupt();
        }
        if (!*folded)
          return WalkResult::advance();
        changed = true;
        return WalkResult::interrupt();
      });
      if (indexResult.wasInterrupted())
        continue;

      WalkResult result = root->walk([&](PtrAddOp op) {
        FailureOr<bool> folded = combinePtrAdd(rewriter, op);
        if (failed(folded)) {
          signalPassFailure();
          return WalkResult::interrupt();
        }
        if (!*folded)
          return WalkResult::advance();
        changed = true;
        return WalkResult::interrupt();
      });
      if (result.wasInterrupted() && !changed)
        return;
    }
  }
};

} // namespace
