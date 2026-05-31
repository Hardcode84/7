//===- WaveExtractLoopStrides.cpp - expose loop-carried strides -*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/Wave/Transforms/Passes.h"

#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/SCF/IR/SCF.h"
#include "mlir/Dialect/Utils/StaticValueUtils.h"
#include "mlir/Dialect/Wave/IR/Wave.h"
#include "mlir/Dialect/Wave/IR/WaveSymbols.h"
#include "mlir/IR/IRMapping.h"
#include "mlir/IR/PatternMatch.h"
#include "llvm/ADT/DenseSet.h"
#include "llvm/ADT/StringSet.h"

#include <optional>
#include <string>

namespace mlir::wave {
#define GEN_PASS_DEF_WAVEEXTRACTLOOPSTRIDES
#include "mlir/Dialect/Wave/Transforms/Passes.h.inc"
} // namespace mlir::wave

using namespace mlir;
using namespace mlir::wave;

namespace {

struct NamedBinding {
  std::string name;
  Value value;
};

struct BoundExpr {
  sym::ExprHandle expr;
  SmallVector<std::string> names;
  SmallVector<Value> bindings;
};

struct LoopStrideCandidate {
  PtrAddOp ptrAdd;
  IndexExprOp indexExpr;
  BoundExpr base;
  BoundExpr stride;
};

static bool isDefinedInside(Operation *scope, Value value) {
  if (Operation *def = value.getDefiningOp())
    return scope->isAncestor(def);
  BlockArgument arg = dyn_cast<BlockArgument>(value);
  if (!arg)
    return false;
  Region *region = arg.getOwner()->getParent();
  while (region) {
    Operation *parent = region->getParentOp();
    if (!parent)
      return false;
    if (parent == scope)
      return true;
    region = parent->getParentRegion();
  }
  return false;
}

static void collectFreeSymbols(sym::ExprHandle expr,
                               llvm::DenseSet<StringRef> &symbols) {
  sym::walkSymbolNames(expr, [&](StringRef name) { symbols.insert(name); });
}

static bool hasSymbol(sym::ExprHandle expr, StringRef needle) {
  bool found = false;
  sym::walkSymbolNames(expr, [&](StringRef name) {
    if (name == needle)
      found = true;
  });
  return found;
}

static std::string uniqueName(llvm::StringSet<> &used, StringRef stem) {
  std::string base = stem.str();
  std::string name = base;
  unsigned suffix = 0;
  while (used.contains(name))
    name = (Twine(base) + "_" + Twine(++suffix)).str();
  used.insert(name);
  return name;
}

static void collectUsedNames(IndexExprOp op, llvm::StringSet<> &used) {
  for (Attribute attr : op.getNames())
    used.insert(cast<StringAttr>(attr).getValue());
}

static FailureOr<sym::ExprHandle>
symbolForValue(sym::Store &store, Value value, StringRef stem,
               llvm::StringSet<> &used, SmallVectorImpl<NamedBinding> &extra) {
  if (std::optional<int64_t> constant = getConstantIntValue(value))
    return sym::composeExprInt(store, *constant);

  std::string name = uniqueName(used, stem);
  FailureOr<sym::ExprHandle> expr = sym::composeExprSym(store, name);
  if (failed(expr))
    return failure();
  extra.push_back({name, value});
  return *expr;
}

static void collectOriginalBindings(IndexExprOp op, StringRef ivName,
                                    SmallVectorImpl<NamedBinding> &out) {
  for (auto [nameAttr, binding] : llvm::zip(op.getNames(), op.getBindings())) {
    StringRef name = cast<StringAttr>(nameAttr).getValue();
    if (name == ivName)
      continue;
    out.push_back({name.str(), binding});
  }
}

static FailureOr<BoundExpr> bindLiveExpr(IndexExprOp op, sym::ExprHandle expr,
                                         StringRef ivName,
                                         ArrayRef<NamedBinding> extraBindings) {
  if (hasSymbol(expr, ivName))
    return failure();

  llvm::DenseSet<StringRef> freeSymbols;
  collectFreeSymbols(expr, freeSymbols);

  SmallVector<NamedBinding> available;
  collectOriginalBindings(op, ivName, available);
  llvm::append_range(available, extraBindings);

  BoundExpr out;
  llvm::StringSet<> consumed;
  for (const NamedBinding &binding : available) {
    if (!freeSymbols.count(binding.name))
      continue;
    out.names.push_back(binding.name);
    out.bindings.push_back(binding.value);
    consumed.insert(binding.name);
  }
  for (StringRef symbol : freeSymbols)
    if (!consumed.contains(symbol))
      return failure();

  out.expr = expr;
  return out;
}

static FailureOr<sym::ExprHandle> simplifyExpanded(sym::Store &store,
                                                   sym::ExprHandle expr) {
  FailureOr<sym::ExprHandle> expanded = sym::expandExpr(store, expr);
  if (failed(expanded))
    return failure();
  return sym::simplifyExpr(store, *expanded);
}

static FailureOr<BoundExpr> buildBaseExpr(IndexExprOp op, StringRef ivName,
                                          scf::ForOp loop, sym::Store &store) {
  llvm::StringSet<> used;
  collectUsedNames(op, used);

  FailureOr<sym::ExprHandle> iv = sym::composeExprSym(store, ivName);
  SmallVector<NamedBinding> extra;
  FailureOr<sym::ExprHandle> lower = symbolForValue(
      store, loop.getLowerBound(), (Twine(ivName) + "_lb").str(), used, extra);
  if (failed(iv) || failed(lower))
    return failure();

  FailureOr<sym::ExprHandle> substituted =
      sym::substituteExpr(store, op.getExpr().getValue(), {{*iv, *lower}});
  if (failed(substituted))
    return failure();
  FailureOr<sym::ExprHandle> simplified = simplifyExpanded(store, *substituted);
  if (failed(simplified))
    return failure();
  return bindLiveExpr(op, *simplified, ivName, extra);
}

static FailureOr<BoundExpr> buildStrideExpr(IndexExprOp op, StringRef ivName,
                                            scf::ForOp loop,
                                            sym::Store &store) {
  llvm::StringSet<> used;
  collectUsedNames(op, used);

  FailureOr<sym::ExprHandle> iv = sym::composeExprSym(store, ivName);
  SmallVector<NamedBinding> extra;
  FailureOr<sym::ExprHandle> step = symbolForValue(
      store, loop.getStep(), (Twine(ivName) + "_step").str(), used, extra);
  if (failed(iv) || failed(step))
    return failure();

  FailureOr<sym::ExprHandle> nextIv =
      sym::composeExprBinary(store, *iv, sym::ExprBinaryOp::Add, *step);
  if (failed(nextIv))
    return failure();

  FailureOr<sym::ExprHandle> next =
      sym::substituteExpr(store, op.getExpr().getValue(), {{*iv, *nextIv}});
  if (failed(next))
    return failure();
  FailureOr<sym::ExprHandle> diff = sym::composeExprBinary(
      store, *next, sym::ExprBinaryOp::Sub, op.getExpr().getValue());
  if (failed(diff))
    return failure();
  FailureOr<sym::ExprHandle> simplified = simplifyExpanded(store, *diff);
  if (failed(simplified))
    return failure();
  if (sym::getIntegerLiteralValue(*simplified) == int64_t{0})
    return failure();
  return bindLiveExpr(op, *simplified, ivName, extra);
}

static std::optional<std::string> findIVBinding(IndexExprOp op, Value iv) {
  for (auto [nameAttr, binding] : llvm::zip(op.getNames(), op.getBindings()))
    if (binding == iv)
      return cast<StringAttr>(nameAttr).getValue().str();
  return std::nullopt;
}

static bool isImmediateBodyOp(scf::ForOp loop, Operation *op) {
  return op->getBlock() == loop.getBody();
}

static bool canRewritePtrAddInLoop(scf::ForOp loop, PtrAddOp ptrAdd) {
  if (!isImmediateBodyOp(loop, ptrAdd))
    return false;
  if (ptrAdd->use_empty())
    return false;
  return !isDefinedInside(loop, ptrAdd.getBase());
}

static IndexExprOp getLoopLocalOffsetExpr(scf::ForOp loop, PtrAddOp ptrAdd) {
  IndexExprOp indexExpr = ptrAdd.getOffset().getDefiningOp<IndexExprOp>();
  if (!indexExpr || !isImmediateBodyOp(loop, indexExpr))
    return {};
  if (!indexExpr.getResult().hasOneUse())
    return {};
  return indexExpr;
}

static bool hasLoopLocalNonIVBinding(scf::ForOp loop, IndexExprOp indexExpr) {
  for (Value binding : indexExpr.getBindings()) {
    if (binding == loop.getInductionVar())
      continue;
    if (isDefinedInside(loop, binding))
      return true;
  }
  return false;
}

static LogicalResult buildCandidate(scf::ForOp loop, PtrAddOp ptrAdd,
                                    sym::Store &store,
                                    LoopStrideCandidate &candidate,
                                    bool &matched) {
  matched = false;
  if (!canRewritePtrAddInLoop(loop, ptrAdd))
    return success();

  IndexExprOp indexExpr = getLoopLocalOffsetExpr(loop, ptrAdd);
  if (!indexExpr)
    return success();

  std::optional<std::string> ivName =
      findIVBinding(indexExpr, loop.getInductionVar());
  if (!ivName)
    return success();
  if (hasLoopLocalNonIVBinding(loop, indexExpr))
    return success();

  FailureOr<BoundExpr> base = buildBaseExpr(indexExpr, *ivName, loop, store);
  FailureOr<BoundExpr> stride =
      buildStrideExpr(indexExpr, *ivName, loop, store);
  if (failed(base) || failed(stride))
    return success();

  candidate.ptrAdd = ptrAdd;
  candidate.indexExpr = indexExpr;
  candidate.base = std::move(*base);
  candidate.stride = std::move(*stride);
  matched = true;
  return success();
}

static FailureOr<std::optional<LoopStrideCandidate>>
findCandidate(scf::ForOp loop, sym::Store &store) {
  for (Operation &op : loop.getBody()->without_terminator()) {
    PtrAddOp ptrAdd = dyn_cast<PtrAddOp>(&op);
    if (!ptrAdd)
      continue;
    LoopStrideCandidate candidate;
    bool matched = false;
    if (failed(buildCandidate(loop, ptrAdd, store, candidate, matched)))
      return failure();
    if (matched)
      return std::optional<LoopStrideCandidate>(std::move(candidate));
  }
  return std::optional<LoopStrideCandidate>{};
}

static bool isScalarOffset(Type type) {
  if (type.isIndex())
    return true;
  if (isa<IntegerType>(type))
    return true;
  if (WaveIndexType indexType = dyn_cast<WaveIndexType>(type))
    return indexType.getWidth() == 0;
  return false;
}

static IndexExprOp createIndexExpr(IRRewriter &rewriter, Location loc,
                                   MLIRContext *ctx, const BoundExpr &expr,
                                   IRMapping *map = nullptr) {
  SmallVector<StringRef> nameRefs;
  SmallVector<Value> bindings;
  for (StringRef name : expr.names)
    nameRefs.push_back(name);
  for (Value binding : expr.bindings)
    bindings.push_back(map ? map->lookupOrDefault(binding) : binding);
  Type type = getIndexExprResultType(ctx, bindings);
  return IndexExprOp::create(rewriter, loc, type, ExprAttr::get(ctx, expr.expr),
                             rewriter.getStrArrayAttr(nameRefs), bindings);
}

static Value createPtrAdd(IRRewriter &rewriter, Location loc, Type resultType,
                          Value base, Value offset) {
  if (isa<SimdType>(resultType) && isa<PtrType>(base.getType()) &&
      isScalarOffset(offset.getType())) {
    PtrAddOp scalarPtr =
        PtrAddOp::create(rewriter, loc, base.getType(), base, offset);
    return SplatOp::create(rewriter, loc, resultType, scalarPtr.getResult());
  }
  return PtrAddOp::create(rewriter, loc, resultType, base, offset).getResult();
}

static void cloneBodyWithCarriedPointer(IRRewriter &rewriter, scf::ForOp src,
                                        scf::ForOp dst,
                                        LoopStrideCandidate candidate,
                                        Value strideValue) {
  Block &srcBody = *src.getBody();
  Block &dstBody = *dst.getBody();
  Value ptrCarry = dstBody.getArgument(srcBody.getNumArguments());

  IRMapping map;
  map.map(srcBody.getArgument(0), dstBody.getArgument(0));
  for (auto [oldArg, newArg] :
       llvm::zip(src.getRegionIterArgs(), dst.getRegionIterArgs().drop_back()))
    map.map(oldArg, newArg);
  map.map(candidate.ptrAdd.getResult(), ptrCarry);

  rewriter.setInsertionPointToStart(&dstBody);
  for (Operation &op : srcBody.without_terminator()) {
    if (&op == candidate.indexExpr.getOperation() ||
        &op == candidate.ptrAdd.getOperation())
      continue;
    rewriter.clone(op, map);
  }

  SmallVector<Value> yielded;
  scf::YieldOp srcYield = cast<scf::YieldOp>(srcBody.getTerminator());
  for (Value value : srcYield.getOperands())
    yielded.push_back(map.lookupOrDefault(value));

  yielded.push_back(createPtrAdd(rewriter, candidate.ptrAdd.getLoc(),
                                 candidate.ptrAdd.getType(), ptrCarry,
                                 map.lookupOrDefault(strideValue)));
  scf::YieldOp::create(rewriter, srcYield.getLoc(), yielded);
}

static void copyLoopAttrs(scf::ForOp src, scf::ForOp dst) {
  for (NamedAttribute attr : src->getAttrs())
    dst->setAttr(attr.getName(), attr.getValue());
}

static void rewriteLoop(IRRewriter &rewriter, scf::ForOp loop,
                        LoopStrideCandidate candidate) {
  Location loc = loop.getLoc();
  rewriter.setInsertionPoint(loop);
  IndexExprOp base = createIndexExpr(rewriter, candidate.indexExpr.getLoc(),
                                     loop->getContext(), candidate.base);
  Value basePtr = createPtrAdd(rewriter, candidate.ptrAdd.getLoc(),
                               candidate.ptrAdd.getType(),
                               candidate.ptrAdd.getBase(), base.getResult());
  IndexExprOp stride = createIndexExpr(rewriter, candidate.ptrAdd.getLoc(),
                                       loop->getContext(), candidate.stride);

  SmallVector<Value> initArgs(loop.getInitArgs().begin(),
                              loop.getInitArgs().end());
  initArgs.push_back(basePtr);
  scf::ForOp newLoop =
      scf::ForOp::create(rewriter, loc, loop.getLowerBound(),
                         loop.getUpperBound(), loop.getStep(), initArgs);
  copyLoopAttrs(loop, newLoop);
  cloneBodyWithCarriedPointer(rewriter, loop, newLoop, candidate,
                              stride.getResult());

  rewriter.replaceOp(loop,
                     newLoop.getResults().take_front(loop.getNumResults()));
}

static FailureOr<bool> rewriteOneLoop(IRRewriter &rewriter, scf::ForOp loop,
                                      sym::Store &store) {
  FailureOr<std::optional<LoopStrideCandidate>> candidate =
      findCandidate(loop, store);
  if (failed(candidate))
    return failure();
  if (!*candidate)
    return false;
  rewriteLoop(rewriter, loop, **candidate);
  return true;
}

struct WaveExtractLoopStridesPass
    : public wave::impl::WaveExtractLoopStridesBase<
          WaveExtractLoopStridesPass> {
  void runOnOperation() override {
    Operation *root = getOperation();
    WaveDialect *dialect = root->getContext()->getLoadedDialect<WaveDialect>();
    if (!dialect) {
      root->emitError("Wave dialect is not loaded");
      return signalPassFailure();
    }

    IRRewriter rewriter(root->getContext());
    bool changed = true;
    while (changed) {
      changed = false;
      WalkResult result = root->walk([&](scf::ForOp loop) {
        FailureOr<bool> rewritten =
            rewriteOneLoop(rewriter, loop, dialect->getSymbolStore());
        if (failed(rewritten)) {
          signalPassFailure();
          return WalkResult::interrupt();
        }
        if (!*rewritten)
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
