//===- WaveCombinePointerOffsets.cpp - Fold ptr_add chains ----*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/Wave/Transforms/Passes.h"

#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/Wave/IR/Wave.h"
#include "mlir/IR/Builders.h"
#include "mlir/IR/PatternMatch.h"
#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/DenseSet.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/ADT/SmallPtrSet.h"
#include "llvm/ADT/StringMap.h"

#include <cassert>
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
  SmallVector<sym::ExprSubstitution> substitutions;
  SmallVector<IndexExprOp> producers;
  llvm::DenseMap<Value, StringRef> byValue;
  llvm::SmallPtrSet<Operation *, 4> seenProducers;
  llvm::StringMap<Value> reserved;
  llvm::StringMap<Value> emitted;
};

static FailureOr<sym::ExprHandle> symbolExpr(sym::Store &store,
                                             StringRef name) {
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

static FailureOr<sym::ExprHandle>
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
                  llvm::StringMap<Value> &emitted) {
  SmallVector<sym::ExprSubstitution> substitutions;
  for (auto [nameAttr, value] :
       llvm::zip(producer.getNames(), producer.getBindings())) {
    StringRef oldName = cast<StringAttr>(nameAttr).getValue();
    StringRef newName = reserveBindingName(oldName, value, reserved, byValue);
    if (failed(appendBinding(bindings, emitted, newName, value)))
      return failure();
    if (newName == oldName)
      continue;

    FailureOr<sym::ExprHandle> target = symbolExpr(store, oldName);
    FailureOr<sym::ExprHandle> replacement = symbolExpr(store, newName);
    if (failed(target) || failed(replacement))
      return failure();
    substitutions.push_back({*target, *replacement});
  }

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

static void eraseDeadProducers(IRRewriter &rewriter,
                               ArrayRef<IndexExprOp> producers) {
  for (IndexExprOp producer : producers)
    if (producer && producer->use_empty())
      rewriter.eraseOp(producer);
}

static bool hasNestedIndexExprBinding(IndexExprOp op) {
  return llvm::any_of(op.getBindings(), [](Value binding) {
    return !!binding.getDefiningOp<IndexExprOp>();
  });
}

static void seedBindingNames(IndexExprOp op, IndexExprMergeState &state) {
  for (auto [nameAttr, value] : llvm::zip(op.getNames(), op.getBindings())) {
    StringRef name = cast<StringAttr>(nameAttr).getValue();
    state.reserved[name] = value;
  }

  for (auto [nameAttr, value] : llvm::zip(op.getNames(), op.getBindings())) {
    if (value.getDefiningOp<IndexExprOp>())
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
                           state.bindings, state.emitted);
}

static FailureOr<sym::ExprHandle>
substituteAndSimplify(IndexExprOp op, sym::Store &store,
                      ArrayRef<sym::ExprSubstitution> substitutions) {
  FailureOr<sym::ExprHandle> substituted =
      substituteExprSymbols(store, op.getExpr().getValue(), substitutions);
  if (failed(substituted))
    return op.emitError("failed to substitute chained wave.index_expr");
  FailureOr<sym::ExprHandle> simplified =
      sym::simplifyExpr(store, *substituted);
  if (failed(simplified))
    return op.emitError("failed to simplify chained wave.index_expr");
  return *simplified;
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

static void rewriteIndexExpr(IRRewriter &rewriter, IndexExprOp op,
                             sym::ExprHandle expr,
                             ArrayRef<IndexExprBinding> bindings) {
  SmallVector<StringRef> names;
  SmallVector<Value> values;
  appendNameRef(bindings, names);
  appendValues(bindings, values);

  Type resultType = getIndexExprResultType(op.getContext(), values);
  rewriter.setInsertionPoint(op);
  IndexExprOp replacement = IndexExprOp::create(
      rewriter, op.getLoc(), resultType, ExprAttr::get(op.getContext(), expr),
      rewriter.getStrArrayAttr(names), values);
  rewriter.replaceOp(op, replacement.getResult());
}

static LogicalResult appendProducerBinding(sym::Store &store,
                                           IndexExprMergeState &state,
                                           StringRef name,
                                           IndexExprOp producer) {
  FailureOr<sym::ExprHandle> target = symbolExpr(store, name);
  FailureOr<sym::ExprHandle> replacement =
      remapNestedBinding(store, producer, state);
  if (failed(target) || failed(replacement))
    return failure();
  state.substitutions.push_back({*target, *replacement});
  if (state.seenProducers.insert(producer).second)
    state.producers.push_back(producer);
  return success();
}

static LogicalResult collectIndexExprMerge(IndexExprOp op, sym::Store &store,
                                           IndexExprMergeState &state) {
  for (auto [nameAttr, value] : llvm::zip(op.getNames(), op.getBindings())) {
    StringRef name = cast<StringAttr>(nameAttr).getValue();
    IndexExprOp producer = value.getDefiningOp<IndexExprOp>();
    if (producer) {
      if (failed(appendProducerBinding(store, state, name, producer)))
        return failure();
      continue;
    }
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
  FailureOr<sym::ExprHandle> simplified =
      substituteAndSimplify(op, store, state.substitutions);
  if (failed(simplified))
    return failure();

  FailureOr<SmallVector<IndexExprBinding>> liveBindings =
      collectLiveBindings(*simplified, state.bindings);
  if (failed(liveBindings))
    return failure();
  bool exprChanged = !(*simplified == op.getExpr().getValue());
  if (!exprChanged && hasSameBindings(op, *liveBindings))
    return false;

  rewriteIndexExpr(rewriter, op, *simplified, *liveBindings);
  eraseDeadProducers(rewriter, state.producers);
  return true;
}

static SmallVector<PtrAddOp> collectPtrAddChain(PtrAddOp op) {
  SmallVector<PtrAddOp> chain;
  for (PtrAddOp cur = op; cur; cur = cur.getBase().getDefiningOp<PtrAddOp>())
    chain.push_back(cur);
  return chain;
}

static void rewritePtrAddChain(IRRewriter &rewriter, PtrAddOp op,
                               ArrayRef<PtrAddOp> chain,
                               MemoryAddress address) {
  SmallVector<std::string> names;
  SmallVector<StringRef> nameRefs;
  SmallVector<Value> bindings;
  for (const SymbolicOffsetBinding &binding : address.offset.bindings) {
    StringRef name = sym::ExprView(binding.name).getSymbolName();
    assert(!name.empty() && "symbolic offset binding must have a name");
    names.push_back(name.str());
    bindings.push_back(binding.value);
  }
  for (StringRef name : names)
    nameRefs.push_back(name);

  MLIRContext *ctx = op->getContext();
  rewriter.setInsertionPoint(op);
  Type indexType = getIndexExprResultType(ctx, bindings);
  IndexExprOp index = IndexExprOp::create(
      rewriter, op.getLoc(), indexType, ExprAttr::get(ctx, address.offset.expr),
      rewriter.getStrArrayAttr(nameRefs), bindings);
  PtrAddOp replacement = PtrAddOp::create(rewriter, op.getLoc(), op.getType(),
                                          address.base, index.getResult());
  rewriter.replaceOp(op, replacement.getResult());
  for (PtrAddOp add : llvm::drop_begin(chain))
    if (add->use_empty())
      rewriter.eraseOp(add);
}

static FailureOr<bool> combinePtrAdd(IRRewriter &rewriter, PtrAddOp op) {
  SmallVector<PtrAddOp> chain = collectPtrAddChain(op);
  if (chain.size() < 2)
    return false;

  WaveDialect *dialect = op->getContext()->getLoadedDialect<WaveDialect>();
  if (!dialect)
    return op.emitError("Wave dialect is not loaded");
  FailureOr<std::optional<MemoryAddress>> address =
      normalizeMemoryAddress(op.getResult(), *dialect);
  if (failed(address))
    return op.emitError("failed to compose combined pointer offset");
  if (!*address)
    return false;
  rewritePtrAddChain(rewriter, op, chain, std::move(**address));
  return true;
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
