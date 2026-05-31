//===- WaveAMDFormFusedInt.cpp - Fused integer peepholes -------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/Wave/Transforms/Passes.h"

#include "Utils/AMDGPUBaseInfo.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachine.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachineTarget.h"
#include "mlir/IR/PatternMatch.h"
#include "mlir/Transforms/GreedyPatternRewriteDriver.h"
#include "llvm/TargetParser/TargetParser.h"

#include <array>
#include <cstdint>
#include <limits>

namespace mlir::wave {
#define GEN_PASS_DEF_WAVEAMDFORMFUSEDINT
#include "mlir/Dialect/Wave/Transforms/Passes.h.inc"
} // namespace mlir::wave

using namespace mlir;
using namespace mlir::wave;
using namespace mlir::waveamdmachine;

namespace {

static unsigned getConstantBusLimit(const llvm::AMDGPU::IsaVersion &isa) {
  return isa.Major >= 10 ? 2 : 1;
}

static bool isSGPR(Value value) {
  RegType regType = dyn_cast<RegType>(value.getType());
  return regType && regType.getRegClass() == RegClass::SGPR;
}

static bool isInlineImm(Value value) {
  ImmOp imm = value.getDefiningOp<ImmOp>();
  if (!imm)
    return false;

  int64_t immValue = imm.getValue();
  if (immValue < std::numeric_limits<int32_t>::min() ||
      immValue > std::numeric_limits<uint32_t>::max())
    return false;
  return llvm::AMDGPU::isInlinableLiteral32(static_cast<int32_t>(immValue),
                                            /*HasInv2Pi=*/false);
}

static bool usesConstantBus(Value value) {
  if (isSGPR(value))
    return true;
  return isa<ImmType>(value.getType()) && !isInlineImm(value);
}

static bool hasUnsupportedLiteral(ArrayRef<Value> operands,
                                  const llvm::AMDGPU::IsaVersion &isa) {
  if (isa.Major >= 10)
    return false;
  for (Value operand : operands)
    if (llvm::isa<ImmType>(operand.getType()) && !isInlineImm(operand))
      return true;
  return false;
}

static bool fitsConstantBus(ArrayRef<Value> operands,
                            const llvm::AMDGPU::IsaVersion &isa) {
  unsigned uses = 0;
  unsigned limit = getConstantBusLimit(isa);
  for (Value operand : operands) {
    if (!usesConstantBus(operand))
      continue;
    if (++uses > limit)
      return false;
  }
  return true;
}

template <typename OpTy>
static bool canCreateTernary(ArrayRef<Value> operands,
                             const llvm::AMDGPU::IsaVersion &isa) {
  return OpTy::isSupportedOnIsa(isa) && !hasUnsupportedLiteral(operands, isa) &&
         fitsConstantBus(operands, isa);
}

template <typename InnerOp>
static InnerOp matchSingleUseProducer(Value value, Operation *consumer) {
  InnerOp inner = value.getDefiningOp<InnerOp>();
  if (!inner)
    return InnerOp();
  if (inner->getBlock() != consumer->getBlock())
    return InnerOp();
  if (!inner.getResult().hasOneUse())
    return InnerOp();
  return inner;
}

template <typename NewOp, typename OldOp>
static void replaceWithTernary(PatternRewriter &rewriter, OldOp oldOp,
                               Operation *deadProducer, Value a, Value b,
                               Value c) {
  NewOp fused = NewOp::create(rewriter, oldOp.getLoc(),
                              oldOp.getResult().getType(), a, b, c);
  fused->setAttrs(oldOp->getAttrs());
  rewriter.replaceOp(oldOp, fused.getResult());
  rewriter.eraseOp(deadProducer);
}

template <typename NewOp, typename OldOp>
static LogicalResult tryReplaceTernary(PatternRewriter &rewriter, OldOp oldOp,
                                       Operation *deadProducer, Value a,
                                       Value b, Value c,
                                       const llvm::AMDGPU::IsaVersion &isa) {
  std::array<Value, 3> operands = {a, b, c};
  if (!canCreateTernary<NewOp>(operands, isa))
    return failure();
  replaceWithTernary<NewOp>(rewriter, oldOp, deadProducer, a, b, c);
  return success();
}

template <typename InnerOp, typename NewOp, typename OldOp>
static LogicalResult tryFuseNestedBinary(PatternRewriter &rewriter, OldOp oldOp,
                                         const llvm::AMDGPU::IsaVersion &isa) {
  if (InnerOp inner = matchSingleUseProducer<InnerOp>(oldOp.getLhs(), oldOp)) {
    if (succeeded(tryReplaceTernary<NewOp>(rewriter, oldOp, inner,
                                           inner.getLhs(), inner.getRhs(),
                                           oldOp.getRhs(), isa)))
      return success();
  }

  if (InnerOp inner = matchSingleUseProducer<InnerOp>(oldOp.getRhs(), oldOp)) {
    if (succeeded(tryReplaceTernary<NewOp>(rewriter, oldOp, inner,
                                           inner.getLhs(), inner.getRhs(),
                                           oldOp.getLhs(), isa)))
      return success();
  }

  return failure();
}

struct AddFusionPattern : public OpRewritePattern<VAddU32Op> {
  AddFusionPattern(MLIRContext *context, const llvm::AMDGPU::IsaVersion &isa)
      : OpRewritePattern<VAddU32Op>(context), isa(isa) {}

  LogicalResult matchAndRewrite(VAddU32Op op,
                                PatternRewriter &rewriter) const override {
    if (succeeded(tryFuseNestedBinary<VLshlrevB32Op, VLshlAddU32Op>(rewriter,
                                                                    op, isa)))
      return success();
    if (succeeded(
            tryFuseNestedBinary<VAddU32Op, VAdd3U32Op>(rewriter, op, isa)))
      return success();
    if (succeeded(tryFuseNestedBinary<VXorB32Op, VXadU32Op>(rewriter, op, isa)))
      return success();

    return failure();
  }

  llvm::AMDGPU::IsaVersion isa;
};

struct LshlFusionPattern : public OpRewritePattern<VLshlrevB32Op> {
  LshlFusionPattern(MLIRContext *context, const llvm::AMDGPU::IsaVersion &isa)
      : OpRewritePattern<VLshlrevB32Op>(context), isa(isa) {}

  LogicalResult matchAndRewrite(VLshlrevB32Op op,
                                PatternRewriter &rewriter) const override {
    VAddU32Op inner = matchSingleUseProducer<VAddU32Op>(op.getLhs(), op);
    if (!inner)
      return failure();
    return tryReplaceTernary<VAddLshlU32Op>(rewriter, op, inner, inner.getLhs(),
                                            inner.getRhs(), op.getRhs(), isa);
  }

  llvm::AMDGPU::IsaVersion isa;
};

struct OrFusionPattern : public OpRewritePattern<VOrB32Op> {
  OrFusionPattern(MLIRContext *context, const llvm::AMDGPU::IsaVersion &isa)
      : OpRewritePattern<VOrB32Op>(context), isa(isa) {}

  LogicalResult matchAndRewrite(VOrB32Op op,
                                PatternRewriter &rewriter) const override {
    if (succeeded(
            tryFuseNestedBinary<VAndB32Op, VAndOrB32Op>(rewriter, op, isa)))
      return success();
    if (succeeded(tryFuseNestedBinary<VOrB32Op, VOr3B32Op>(rewriter, op, isa)))
      return success();

    return failure();
  }

  llvm::AMDGPU::IsaVersion isa;
};

static bool hasFusedIntCandidate(func::FuncOp func) {
  bool found = false;
  WalkResult result = func.walk([&](Operation *op) {
    if (!isa<VAddU32Op, VLshlrevB32Op, VOrB32Op>(op))
      return WalkResult::advance();
    found = true;
    return WalkResult::interrupt();
  });
  return result.wasInterrupted() && found;
}

static LogicalResult runOnFunc(func::FuncOp func) {
  if (!hasFusedIntCandidate(func))
    return success();

  FailureOr<llvm::AMDGPU::IsaVersion> isa =
      getAMDGPUTargetIsaVersion(func, "waveamd-form-fused-int");
  if (failed(isa))
    return failure();

  RewritePatternSet patterns(func.getContext());
  patterns.add<AddFusionPattern, LshlFusionPattern, OrFusionPattern>(
      func.getContext(), *isa);
  return applyPatternsGreedily(func, std::move(patterns));
}

struct WaveAMDFormFusedIntPass
    : public wave::impl::WaveAMDFormFusedIntBase<WaveAMDFormFusedIntPass> {
  void runOnOperation() override {
    WalkResult result = getOperation()->walk([&](func::FuncOp func) {
      if (failed(runOnFunc(func)))
        return WalkResult::interrupt();
      return WalkResult::advance();
    });
    if (result.wasInterrupted())
      return signalPassFailure();
  }
};

} // namespace
