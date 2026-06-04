//===- WaveAMDLinearizeExecIf.cpp - linearize EXEC regions ---------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/Wave/Transforms/Passes.h"

#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachine.h"
#include "mlir/IR/Builders.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/ADT/Twine.h"

namespace mlir::wave {
#define GEN_PASS_DEF_WAVEAMDLINEARIZEEXECIF
#include "mlir/Dialect/Wave/Transforms/Passes.h.inc"
} // namespace mlir::wave

using namespace mlir;

namespace {

static waveamdmachine::RegType
getRegType(MLIRContext *ctx, waveamdmachine::RegClass cls, unsigned width = 1) {
  return waveamdmachine::RegType::get(ctx, cls, width, -1);
}

static waveamdmachine::RegType getSCCType(MLIRContext *ctx) {
  return waveamdmachine::RegType::get(ctx, waveamdmachine::RegClass::SCC,
                                      /*width=*/1, /*index=*/-1);
}

static std::string makeLabel(func::FuncOp func, StringRef stem, unsigned id) {
  return (Twine(".Lwave_") + func.getSymName() + "_exec_" + stem + "_" +
          Twine(id))
      .str();
}

static unsigned maskWidth(Value condition) {
  return cast<waveamdmachine::RegType>(condition.getType()).getWidth();
}

static Value saveExecMask(OpBuilder &builder, Location loc, Value condition) {
  MLIRContext *context = builder.getContext();
  if (maskWidth(condition) == 2) {
    waveamdmachine::SAndSaveexecB64Op save =
        waveamdmachine::SAndSaveexecB64Op::create(
            builder, loc,
            getRegType(context, waveamdmachine::RegClass::SGPR, 2),
            getSCCType(context), condition);
    return save.getSavedExec();
  }
  waveamdmachine::SAndSaveexecB32Op save =
      waveamdmachine::SAndSaveexecB32Op::create(
          builder, loc, getRegType(context, waveamdmachine::RegClass::SGPR),
          getSCCType(context), condition);
  return save.getSavedExec();
}

static void selectElseExecMask(OpBuilder &builder, Location loc,
                               Value savedExec, Value condition) {
  if (maskWidth(condition) == 2) {
    waveamdmachine::SAndn2ExecB64Op::create(
        builder, loc, getSCCType(builder.getContext()), savedExec, condition);
    return;
  }
  waveamdmachine::SAndn2ExecB32Op::create(
      builder, loc, getSCCType(builder.getContext()), savedExec, condition);
}

static void restoreExecMask(OpBuilder &builder, Location loc, Value savedExec) {
  if (maskWidth(savedExec) == 2) {
    waveamdmachine::SMovExecB64Op::create(builder, loc, savedExec);
    return;
  }
  waveamdmachine::SMovExecLoOp::create(builder, loc, savedExec);
}

static bool isImm(Value value) {
  return isa<waveamdmachine::ImmType>(value.getType());
}

static bool isVGPR(Value value) {
  auto reg = dyn_cast<waveamdmachine::RegType>(value.getType());
  return reg && reg.getRegClass() == waveamdmachine::RegClass::VGPR;
}

static Value ensureVGPRForVSrc1(OpBuilder &builder, Location loc, Value value) {
  if (isVGPR(value))
    return value;
  return waveamdmachine::VMovB32TupleOp::create(
      builder, loc,
      getRegType(builder.getContext(), waveamdmachine::RegClass::VGPR), value);
}

static void moveRegionBodyBefore(Region &region, Operation *before) {
  if (region.empty())
    return;
  Block &body = region.front();
  Operation *term = body.getTerminator();
  before->getBlock()->getOperations().splice(before->getIterator(),
                                             body.getOperations(), body.begin(),
                                             term->getIterator());
}

static SmallVector<Value> getYieldedValues(Region &region) {
  if (region.empty())
    return {};
  waveamdmachine::YieldOp yield =
      cast<waveamdmachine::YieldOp>(region.front().getTerminator());
  return SmallVector<Value>(yield.getValues());
}

static Value mergeExecIfResult(OpBuilder &builder, Location loc, Value result,
                               Value condition, Value thenValue,
                               Value elseValue) {
  if (isa<waveamdmachine::MemTokenType>(result.getType()))
    return waveamdmachine::TokenJoinOp::create(
        builder, loc, waveamdmachine::MemTokenType::get(builder.getContext()),
        ValueRange{thenValue, elseValue});
  if (isImm(thenValue) && isImm(elseValue))
    thenValue = ensureVGPRForVSrc1(builder, loc, thenValue);
  return waveamdmachine::VCndmaskB32TupleOp::create(
      builder, loc, result.getType(), elseValue, thenValue, condition);
}

class ExecIfLinearizer {
public:
  explicit ExecIfLinearizer(func::FuncOp func) : func(func) {}

  LogicalResult run() {
    SmallVector<waveamdmachine::ExecIfOp> ops;
    func.walk<WalkOrder::PostOrder>(
        [&](waveamdmachine::ExecIfOp op) { ops.push_back(op); });
    for (waveamdmachine::ExecIfOp op : ops)
      if (failed(linearize(op)))
        return failure();
    return success();
  }

private:
  LogicalResult linearize(waveamdmachine::ExecIfOp op) {
    OpBuilder builder(op);
    Location loc = op.getLoc();
    Value condition = op.getCondition();
    SmallVector<Value> thenValues = getYieldedValues(op.getThenRegion());
    SmallVector<Value> elseValues = getYieldedValues(op.getElseRegion());
    bool hasElse = !op.getElseRegion().empty();
    std::string endLabel = makeLabel(func, "endif", nextLabel++);
    std::string elseLabel =
        hasElse ? makeLabel(func, "else", nextLabel++) : endLabel;

    Value savedExec = saveExecMask(builder, loc, condition);
    waveamdmachine::SCBranchExeczOp::create(builder, loc, elseLabel);
    moveRegionBodyBefore(op.getThenRegion(), op);
    if (hasElse) {
      builder.setInsertionPoint(op);
      waveamdmachine::LabelOp::create(builder, loc, elseLabel);
      selectElseExecMask(builder, loc, savedExec, condition);
      waveamdmachine::SCBranchExeczOp::create(builder, loc, endLabel);
      moveRegionBodyBefore(op.getElseRegion(), op);
    }
    builder.setInsertionPoint(op);
    waveamdmachine::LabelOp::create(builder, loc, endLabel);
    restoreExecMask(builder, loc, savedExec);

    SmallVector<Value> replacements;
    if (!hasElse) {
      replacements = std::move(thenValues);
    } else {
      for (auto [result, thenValue, elseValue] :
           llvm::zip_equal(op.getResults(), thenValues, elseValues))
        replacements.push_back(mergeExecIfResult(
            builder, loc, result, condition, thenValue, elseValue));
    }
    op->replaceAllUsesWith(replacements);
    op.erase();
    return success();
  }

  func::FuncOp func;
  unsigned nextLabel = 0;
};

struct WaveAMDLinearizeExecIfPass
    : public wave::impl::WaveAMDLinearizeExecIfBase<
          WaveAMDLinearizeExecIfPass> {
  using WaveAMDLinearizeExecIfBase::WaveAMDLinearizeExecIfBase;

  void runOnOperation() override {
    WalkResult walk = getOperation()->walk([&](func::FuncOp func) {
      if (func.isExternal())
        return WalkResult::advance();
      if (failed(ExecIfLinearizer(func).run()))
        return WalkResult::interrupt();
      return WalkResult::advance();
    });
    if (walk.wasInterrupted())
      signalPassFailure();
  }
};

} // namespace
