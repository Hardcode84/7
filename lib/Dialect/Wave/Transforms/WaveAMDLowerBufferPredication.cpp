//===- WaveAMDLowerBufferPredication.cpp - buffer OOB masking -*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/Wave/Transforms/Passes.h"

#include "WaveAMDBufferPredicationUtils.h"

#include "mlir/Dialect/Wave/IR/Wave.h"
#include "mlir/Dialect/Wave/IR/WaveAMD.h"
#include "mlir/IR/PatternMatch.h"
#include "mlir/Interfaces/SideEffectInterfaces.h"
#include "llvm/ADT/STLExtras.h"

namespace mlir::wave {
#define GEN_PASS_DEF_WAVEAMDLOWERBUFFERPREDICATION
#include "mlir/Dialect/Wave/Transforms/Passes.h.inc"
} // namespace mlir::wave

using namespace mlir;
using namespace mlir::wave;

namespace {

static Value getMemoryPointer(Operation *op) {
  if (auto load = dyn_cast<LoadOp>(op))
    return load.getPtr();
  if (auto store = dyn_cast<StoreOp>(op))
    return store.getPtr();
  return {};
}

static Value getMemoryDependency(Operation *op) {
  if (auto load = dyn_cast<LoadOp>(op))
    return load.getDependency();
  return cast<StoreOp>(op).getDependency();
}

static Value getMemoryToken(Operation *op) {
  if (auto load = dyn_cast<LoadOp>(op))
    return load.getToken();
  return cast<StoreOp>(op).getToken();
}

static bool isInactiveDependency(Value inactive, Operation *memory) {
  Value dependency = getMemoryDependency(memory);
  if (dependency)
    return inactive == dependency;
  return !!inactive.getDefiningOp<TokenOp>();
}

static bool isZeroValue(Value value) {
  if (auto constant = value.getDefiningOp<ConstantOp>()) {
    if (auto integer = dyn_cast<IntegerAttr>(constant.getValue()))
      return integer.getValue().isZero();
    if (auto floating = dyn_cast<FloatAttr>(constant.getValue()))
      return floating.getValue().isZero() && !floating.getValue().isNegative();
  }
  if (auto splat = value.getDefiningOp<SplatOp>())
    return isZeroValue(splat.getSource());
  auto pack = value.getDefiningOp<PackOp>();
  return pack && llvm::all_of(pack.getInputs(), isZeroValue);
}

static bool canHoist(Operation &op) {
  return op.getNumRegions() == 0 && isMemoryEffectFree(&op) &&
         isSpeculatable(&op);
}

static bool collectBody(WhereOp where, SmallVectorImpl<Operation *> &ops,
                        Operation *&memory) {
  Block &block = where.getThenRegion().front();
  Operation *terminator = block.getTerminator();
  for (Operation &op : block) {
    if (&op == terminator)
      break;
    if (isa<LoadOp, StoreOp>(op)) {
      if (memory)
        return false;
      memory = &op;
    } else if (!canHoist(op)) {
      return false;
    }
    ops.push_back(&op);
  }
  return memory != nullptr;
}

static bool validateYields(WhereOp where, Operation *memory) {
  auto active = cast<YieldOp>(where.getThenRegion().front().getTerminator());
  auto inactive = cast<YieldOp>(where.getElseRegion().front().getTerminator());

  Value token = getMemoryToken(memory);
  Value loaded =
      isa<LoadOp>(memory) ? cast<LoadOp>(memory).getValue() : Value{};
  for (auto [activeValue, inactiveValue] :
       llvm::zip_equal(active.getValues(), inactive.getValues())) {
    if (activeValue == token) {
      if (!isInactiveDependency(inactiveValue, memory))
        return false;
      continue;
    }
    if (activeValue != loaded)
      return false;
  }
  return true;
}

static void replaceWhereResults(IRRewriter &rewriter, WhereOp where,
                                Operation *memory) {
  auto active = cast<YieldOp>(where.getThenRegion().front().getTerminator());
  auto inactive = cast<YieldOp>(where.getElseRegion().front().getTerminator());
  rewriter.setInsertionPoint(where);
  SmallVector<Value> replacements;
  replacements.reserve(where.getNumResults());
  Value token = getMemoryToken(memory);
  for (auto [activeValue, inactiveValue] :
       llvm::zip_equal(active.getValues(), inactive.getValues())) {
    if (activeValue == token || isZeroValue(inactiveValue)) {
      replacements.push_back(activeValue);
      continue;
    }
    replacements.push_back(
        SelectOp::create(rewriter, where.getLoc(), activeValue.getType(),
                         where.getCondition(), activeValue, inactiveValue));
  }
  rewriter.replaceOp(where, replacements);
}

static bool rewriteWhere(IRRewriter &rewriter, WhereOp where) {
  if (where.getConditions().size() != 1 || where.getElseRegion().empty())
    return false;

  SmallVector<Operation *> ops;
  Operation *memory = nullptr;
  if (!collectBody(where, ops, memory) || !validateYields(where, memory))
    return false;

  for (Operation &op : where.getElseRegion().front().without_terminator()) {
    if (!canHoist(op))
      return false;
    ops.push_back(&op);
  }
  FailureOr<buffer_predication::BufferSentinel> sentinel =
      buffer_predication::findBufferSentinel(getMemoryPointer(memory));
  if (failed(sentinel))
    return false;

  for (Operation *op : ops)
    op->moveBefore(where);

  rewriter.setInsertionPoint(memory);
  Value selected = buffer_predication::createOOBSelectedBufferPointer(
      rewriter, memory->getLoc(), getMemoryPointer(memory),
      where.getCondition(), *sentinel);
  if (auto load = dyn_cast<LoadOp>(memory))
    load.getPtrMutable().assign(selected);
  else
    cast<StoreOp>(memory).getPtrMutable().assign(selected);

  replaceWhereResults(rewriter, where, memory);
  return true;
}

struct WaveAMDLowerBufferPredicationPass
    : public wave::impl::WaveAMDLowerBufferPredicationBase<
          WaveAMDLowerBufferPredicationPass> {
  void runOnOperation() override {
    IRRewriter rewriter(&getContext());
    getOperation()->walk([&](WhereOp where) { rewriteWhere(rewriter, where); });
  }
};

} // namespace
