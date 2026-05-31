//===- WaveCombinePointerOffsets.cpp - Fold ptr_add chains ----*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/Wave/Transforms/Passes.h"

#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/Utils/StaticValueUtils.h"
#include "mlir/Dialect/Wave/IR/Wave.h"
#include "mlir/Dialect/Wave/IR/WaveSymbols.h"
#include "mlir/IR/Builders.h"
#include "mlir/IR/PatternMatch.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/ADT/StringMap.h"
#include "llvm/Support/FormatVariadic.h"

#include <optional>
#include <string>

namespace mlir::wave {
#define GEN_PASS_DEF_WAVECOMBINEPOINTEROFFSETS
#include "mlir/Dialect/Wave/Transforms/Passes.h.inc"
} // namespace mlir::wave

using namespace mlir;
using namespace mlir::wave;

namespace {

struct OffsetBinding {
  std::string name;
  Value value;
};

struct CombinedOffset {
  SmallVector<OffsetBinding> bindings;
  sym::ExprHandle expr;
};

class PointerOffsetBuilder {
public:
  explicit PointerOffsetBuilder(WaveDialect &dialect)
      : store(dialect.getSymbolStore()) {}

  LogicalResult append(Value offset, bool &skip) {
    if (IndexExprOp indexExpr = offset.getDefiningOp<IndexExprOp>())
      return append(indexExpr, skip);
    if (std::optional<int64_t> value = getConstantIntValue(offset))
      return appendConstant(*value);
    if (offset.getType().isIndex()) {
      skip = true;
      return success();
    }
    return appendRaw(offset, skip);
  }

  FailureOr<CombinedOffset> finish(Location loc) {
    FailureOr<sym::ExprHandle> simplified = sym::simplifyExpr(store, expr);
    if (failed(simplified))
      return emitError(loc) << "failed to simplify combined pointer offset";
    return CombinedOffset{std::move(bindings), *simplified};
  }

private:
  LogicalResult append(IndexExprOp op, bool &skip) {
    for (auto [nameAttr, binding] :
         llvm::zip(op.getNames(), op.getBindings())) {
      StringRef name = cast<StringAttr>(nameAttr).getValue();
      auto it = bindingByName.find(name);
      if (it != bindingByName.end() && it->second != binding) {
        skip = true;
        return success();
      }
    }
    for (auto [nameAttr, binding] :
         llvm::zip(op.getNames(), op.getBindings())) {
      StringRef name = cast<StringAttr>(nameAttr).getValue();
      if (bindingByName.contains(name))
        continue;
      bindingByName[name] = binding;
      bindings.push_back({name.str(), binding});
    }
    return appendExpr(op.getExpr().getValue());
  }

  LogicalResult appendConstant(int64_t value) {
    FailureOr<sym::ExprHandle> constant = sym::composeExprInt(store, value);
    if (failed(constant))
      return failure();
    return appendExpr(*constant);
  }

  LogicalResult appendRaw(Value value, bool &skip) {
    FailureOr<sym::ExprHandle> valueExpr = buildValueExpr(value, skip);
    if (skip)
      return success();
    if (failed(valueExpr))
      return failure();
    return appendExpr(*valueExpr);
  }

  FailureOr<sym::ExprHandle> buildValueExpr(Value value, bool &skip,
                                            unsigned depth = 0) {
    if (depth > 8) {
      skip = true;
      return failure();
    }
    if (std::optional<int64_t> constant = getConstantIntValue(value))
      return sym::composeExprInt(store, *constant);
    if (value.getDefiningOp<LaneIdOp>())
      return bindSymbol(value);
    if (SplatOp splat = value.getDefiningOp<SplatOp>())
      return buildValueExpr(splat.getSource(), skip, depth + 1);
    if (AddiOp add = value.getDefiningOp<AddiOp>())
      return buildBinaryExpr(add.getLhs(), sym::ExprBinaryOp::Add, add.getRhs(),
                             skip, depth + 1);
    if (MuliOp mul = value.getDefiningOp<MuliOp>())
      return buildBinaryExpr(mul.getLhs(), sym::ExprBinaryOp::Mul, mul.getRhs(),
                             skip, depth + 1);
    if (ShliOp shl = value.getDefiningOp<ShliOp>())
      return buildShiftExpr(shl, skip, depth + 1);
    skip = true;
    return failure();
  }

  FailureOr<sym::ExprHandle> buildBinaryExpr(Value lhs, sym::ExprBinaryOp op,
                                             Value rhs, bool &skip,
                                             unsigned depth) {
    FailureOr<sym::ExprHandle> lhsExpr = buildValueExpr(lhs, skip, depth);
    if (skip || failed(lhsExpr))
      return failure();
    FailureOr<sym::ExprHandle> rhsExpr = buildValueExpr(rhs, skip, depth);
    if (skip || failed(rhsExpr))
      return failure();
    return sym::composeExprBinary(store, *lhsExpr, op, *rhsExpr);
  }

  FailureOr<sym::ExprHandle> buildShiftExpr(ShliOp op, bool &skip,
                                            unsigned depth) {
    std::optional<int64_t> shift = getConstantIntValue(op.getRhs());
    if (!shift || *shift < 0 || *shift >= 63) {
      skip = true;
      return failure();
    }
    FailureOr<sym::ExprHandle> lhs = buildValueExpr(op.getLhs(), skip, depth);
    if (skip || failed(lhs))
      return failure();
    FailureOr<sym::ExprHandle> scale =
        sym::composeExprInt(store, int64_t{1} << *shift);
    if (failed(scale))
      return failure();
    return sym::composeExprBinary(store, *lhs, sym::ExprBinaryOp::Mul, *scale);
  }

  FailureOr<sym::ExprHandle> bindSymbol(Value value) {
    std::string name = freshName();
    FailureOr<sym::ExprHandle> sym = sym::composeExprSym(store, name);
    if (failed(sym))
      return failure();
    bindingByName[name] = value;
    bindings.push_back({name, value});
    return *sym;
  }

  LogicalResult appendExpr(sym::ExprHandle term) {
    if (!expr) {
      expr = term;
      return success();
    }
    FailureOr<sym::ExprHandle> sum =
        sym::composeExprBinary(store, expr, sym::ExprBinaryOp::Add, term);
    if (failed(sum))
      return failure();
    expr = *sum;
    return success();
  }

  std::string freshName() {
    for (;;) {
      std::string name = llvm::formatv("raw{0}", nextRawSymbol++).str();
      if (!bindingByName.contains(name))
        return name;
    }
  }

  SmallVector<OffsetBinding> bindings;
  llvm::StringMap<Value> bindingByName;
  sym::Store &store;
  sym::ExprHandle expr;
  unsigned nextRawSymbol = 0;
};

static SmallVector<PtrAddOp> collectPtrAddChain(PtrAddOp op) {
  SmallVector<PtrAddOp> chain;
  for (PtrAddOp cur = op; cur; cur = cur.getBase().getDefiningOp<PtrAddOp>())
    chain.push_back(cur);
  return chain;
}

static FailureOr<bool> buildCombinedOffset(WaveDialect &dialect,
                                           ArrayRef<PtrAddOp> chain,
                                           CombinedOffset &combined) {
  PointerOffsetBuilder offsetBuilder(dialect);
  bool skip = false;
  for (PtrAddOp add : llvm::reverse(chain)) {
    if (failed(offsetBuilder.append(add.getOffset(), skip)))
      return add.emitError("failed to compose combined pointer offset");
    if (skip)
      return false;
  }

  FailureOr<CombinedOffset> offset =
      offsetBuilder.finish(chain.front()->getLoc());
  if (failed(offset))
    return failure();
  combined = std::move(*offset);
  return true;
}

static void rewritePtrAddChain(IRRewriter &rewriter, PtrAddOp op,
                               ArrayRef<PtrAddOp> chain,
                               CombinedOffset combined) {
  SmallVector<std::string> names;
  SmallVector<StringRef> nameRefs;
  SmallVector<Value> bindings;
  for (OffsetBinding &binding : combined.bindings) {
    names.push_back(std::move(binding.name));
    bindings.push_back(binding.value);
  }
  for (StringRef name : names)
    nameRefs.push_back(name);

  MLIRContext *ctx = op->getContext();
  rewriter.setInsertionPoint(op);
  Type indexType = getIndexExprResultType(ctx, bindings);
  auto index = IndexExprOp::create(
      rewriter, op.getLoc(), indexType, ExprAttr::get(ctx, combined.expr),
      rewriter.getStrArrayAttr(nameRefs), bindings);
  PtrAddOp replacement =
      PtrAddOp::create(rewriter, op.getLoc(), op.getType(),
                       chain.back()->getOperand(0), index.getResult());
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
  CombinedOffset combined;
  FailureOr<bool> built = buildCombinedOffset(*dialect, chain, combined);
  if (failed(built))
    return failure();
  if (!*built)
    return false;
  rewritePtrAddChain(rewriter, op, chain, std::move(combined));
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
      WalkResult result = getOperation()->walk([&](PtrAddOp op) {
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
