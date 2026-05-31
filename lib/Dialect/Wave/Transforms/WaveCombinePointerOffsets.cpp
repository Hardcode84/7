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
#include "llvm/ADT/STLExtras.h"

#include <string>

namespace mlir::wave {
#define GEN_PASS_DEF_WAVECOMBINEPOINTEROFFSETS
#include "mlir/Dialect/Wave/Transforms/Passes.h.inc"
} // namespace mlir::wave

using namespace mlir;
using namespace mlir::wave;

namespace {

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
  for (MemoryAddressBinding &binding : address.bindings) {
    names.push_back(binding.name);
    bindings.push_back(binding.value);
  }
  for (StringRef name : names)
    nameRefs.push_back(name);

  MLIRContext *ctx = op->getContext();
  rewriter.setInsertionPoint(op);
  Type indexType = getIndexExprResultType(ctx, bindings);
  IndexExprOp index =
      IndexExprOp::create(rewriter, op.getLoc(), indexType,
                          ExprAttr::get(ctx, address.elementOffset),
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
