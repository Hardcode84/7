//===- WaveAMDBufferRsrcToTuples.cpp - buffer SRD aliases -----*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/Wave/Transforms/Passes.h"

#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachine.h"
#include "mlir/IR/PatternMatch.h"
#include "llvm/ADT/SmallVector.h"

namespace mlir::wave {
#define GEN_PASS_DEF_WAVEAMDBUFFERRSRCTOTUPLES
#include "mlir/Dialect/Wave/Transforms/Passes.h.inc"
} // namespace mlir::wave

using namespace mlir;
using namespace mlir::waveamdmachine;

namespace {

static constexpr uint32_t getDefaultBufferRsrcFlags() {
  constexpr uint32_t gfx11Format32Float = 22;
  return (gfx11Format32Float << 12) | (1u << 24) | (3u << 28);
}

static RegType getTuplePartType(RegType tupleType, unsigned offset,
                                unsigned width) {
  int64_t index = -1;
  if (tupleType.getIndex() >= 0)
    index = tupleType.getIndex() + offset;
  return RegType::get(tupleType.getContext(), RegClass::SGPR, width, index);
}

static Value getImm(IRRewriter &rewriter, Location loc, int64_t value) {
  return ImmOp::create(rewriter, loc, ImmType::get(rewriter.getContext()),
                       value);
}

static bool isUsableSGPR(Value value, RegType type) {
  auto valueType = dyn_cast<RegType>(value.getType());
  if (!valueType || valueType.getRegClass() != RegClass::SGPR ||
      valueType.getWidth() != type.getWidth())
    return false;
  return type.getIndex() < 0 || valueType.getIndex() == type.getIndex();
}

static FailureOr<Value> getSGPR(Value value, RegType targetType,
                                IRRewriter &rewriter, Operation *op) {
  if (auto type = dyn_cast<RegType>(value.getType())) {
    if (isUsableSGPR(value, targetType))
      return value;
    if (type.getRegClass() != RegClass::SGPR ||
        type.getWidth() != targetType.getWidth())
      return op->emitError(
          "buffer descriptor part must be matching-width SGPR or immediate");
  }
  auto mov = SMovB32TupleOp::create(rewriter, op->getLoc(), targetType, value);
  return mov.getResult();
}

static FailureOr<Value> convertMakeBufferRsrc(MakeBufferRsrcOp make,
                                              IRRewriter &rewriter) {
  rewriter.setInsertionPoint(make);
  auto descriptorType = cast<RegType>(make.getDescriptor().getType());
  FailureOr<Value> base = getSGPR(
      make.getBase(), getTuplePartType(descriptorType, 0, 2), rewriter, make);
  if (failed(base))
    return failure();
  FailureOr<Value> range = getSGPR(
      make.getRange(), getTuplePartType(descriptorType, 2, 1), rewriter, make);
  if (failed(range))
    return failure();
  Value flagsImm = getImm(rewriter, make.getLoc(), getDefaultBufferRsrcFlags());
  auto flags =
      SMovB32TupleOp::create(rewriter, make.getLoc(),
                             getTuplePartType(descriptorType, 3, 1), flagsImm);
  auto tuple = TupleFromElementsOp::create(
      rewriter, make.getLoc(), make.getDescriptor().getType(),
      ValueRange{*base, *range, flags.getResult()});
  rewriter.replaceOp(make, tuple.getTuple());
  return tuple.getTuple();
}

static FailureOr<Value>
convertUpdateBufferRsrcBase(UpdateBufferRsrcBaseOp update,
                            IRRewriter &rewriter) {
  rewriter.setInsertionPoint(update);
  auto resultType = cast<RegType>(update.getResult().getType());
  FailureOr<Value> base = getSGPR(
      update.getBase(), getTuplePartType(resultType, 0, 2), rewriter, update);
  if (failed(base))
    return failure();
  auto tuple = UpdateTupleOp::create(rewriter, update.getLoc(), resultType,
                                     update.getDescriptor(), ValueRange{*base},
                                     rewriter.getI64ArrayAttr({0}));
  rewriter.replaceOp(update, tuple.getResult());
  return tuple.getResult();
}

struct WaveAMDBufferRsrcToTuplesPass
    : public wave::impl::WaveAMDBufferRsrcToTuplesBase<
          WaveAMDBufferRsrcToTuplesPass> {
  void runOnOperation() override {
    IRRewriter rewriter(&getContext());
    SmallVector<Operation *> ops;
    getOperation()->walk([&](Operation *op) {
      if (isa<MakeBufferRsrcOp, UpdateBufferRsrcBaseOp>(op))
        ops.push_back(op);
    });

    for (Operation *op : ops) {
      if (!op->getParentOp())
        continue;
      if (auto make = dyn_cast<MakeBufferRsrcOp>(op)) {
        if (failed(convertMakeBufferRsrc(make, rewriter)))
          return signalPassFailure();
        continue;
      }
      auto update = cast<UpdateBufferRsrcBaseOp>(op);
      if (failed(convertUpdateBufferRsrcBase(update, rewriter)))
        return signalPassFailure();
    }
  }
};

} // namespace
