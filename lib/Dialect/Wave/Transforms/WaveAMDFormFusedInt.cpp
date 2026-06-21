//===- WaveAMDFormFusedInt.cpp - Fused integer peepholes -------*- C++ -*-===//
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
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachine.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachineInstrInfo.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachineTarget.h"
#include "mlir/IR/PatternMatch.h"
#include "mlir/Transforms/GreedyPatternRewriteDriver.h"
#include "llvm/TargetParser/TargetParser.h"

#include <array>
#include <cstdint>

namespace mlir::wave {
#define GEN_PASS_DEF_WAVEAMDFORMFUSEDINT
#include "mlir/Dialect/Wave/Transforms/Passes.h.inc"
} // namespace mlir::wave

using namespace mlir;
using namespace mlir::dataflow;
using namespace mlir::wave;
using namespace mlir::waveamdmachine;

namespace {

template <typename OpTy>
static bool canCreateTernary(ArrayRef<Value> operands,
                             const llvm::AMDGPU::IsaVersion &isa) {
  return OpTy::isSupportedOnIsa(isa) &&
         canUseConstantBus(operands, isa, [](Value, Value) { return false; });
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

static SAddI32Op matchDeadSCCSAddProducer(Value value, Operation *consumer) {
  SAddI32Op inner = value.getDefiningOp<SAddI32Op>();
  if (!inner)
    return SAddI32Op();
  if (inner->getBlock() != consumer->getBlock())
    return SAddI32Op();
  if (!inner.getResult().hasOneUse())
    return SAddI32Op();
  if (!inner.getScc().use_empty())
    return SAddI32Op();
  return inner;
}

static bool writesM0(Operation *op) {
  return llvm::any_of(op->getResults(), [](Value result) {
    return isa<M0Type>(result.getType());
  });
}

static bool hasSingleM0UseBeforeClobber(SMovM0Op op) {
  if (!op.getResult().hasOneUse())
    return false;

  Operation *user = *op.getResult().user_begin();
  if (user->getBlock() != op->getBlock())
    return false;

  for (Operation *cur = op->getNextNode(); cur && cur != user;
       cur = cur->getNextNode()) {
    if (cur->getNumRegions() != 0)
      return false;
    if (writesM0(cur))
      return false;
  }
  return true;
}

static std::optional<ConstantIntRanges>
normalizeU32Range(const ConstantIntRanges &range) {
  unsigned bits = range.umin().getBitWidth();
  if (bits == 0 || bits > 32)
    return std::nullopt;
  if (bits == 32)
    return range;
  return ConstantIntRanges(range.umin().zext(32), range.umax().zext(32),
                           range.smin().sext(32), range.smax().sext(32));
}

static std::optional<ConstantIntRanges> getU32Range(DataFlowSolver &solver,
                                                    Value value) {
  const IntegerValueRangeLattice *lattice =
      solver.lookupState<IntegerValueRangeLattice>(value);
  if (!lattice)
    return std::nullopt;
  IntegerValueRange valueRange = lattice->getValue();
  if (valueRange.isUninitialized())
    return std::nullopt;
  return normalizeU32Range(valueRange.getValue());
}

static bool isProvenU24(const ConstantIntRanges &range) {
  if (range.umin().getBitWidth() != 32)
    return false;
  return range.umax().ule(APInt::getLowBitsSet(32, 24));
}

static bool isProvenI24(const ConstantIntRanges &range) {
  if (range.smin().getBitWidth() != 32)
    return false;
  APInt min = APInt::getSignedMinValue(24).sext(32);
  APInt max = APInt::getSignedMaxValue(24).sext(32);
  return range.smin().sge(min) && range.smax().sle(max);
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

static LogicalResult tryFuseScalarAdd(PatternRewriter &rewriter, VAddU32Op op,
                                      const llvm::AMDGPU::IsaVersion &isa) {
  if (SAddI32Op inner = matchDeadSCCSAddProducer(op.getLhs(), op)) {
    if (succeeded(tryReplaceTernary<VAdd3U32Op>(rewriter, op, inner,
                                                inner.getLhs(), inner.getRhs(),
                                                op.getRhs(), isa)))
      return success();
  }

  if (SAddI32Op inner = matchDeadSCCSAddProducer(op.getRhs(), op)) {
    if (succeeded(tryReplaceTernary<VAdd3U32Op>(rewriter, op, inner,
                                                inner.getLhs(), inner.getRhs(),
                                                op.getLhs(), isa)))
      return success();
  }

  return failure();
}

class DataFlowListener : public RewriterBase::Listener {
public:
  DataFlowListener(DataFlowSolver &solver) : solver(solver) {}

protected:
  void notifyOperationErased(Operation *op) override {
    solver.eraseState(solver.getProgramPointAfter(op));
    for (Value result : op->getResults())
      solver.eraseState(result);
  }

  DataFlowSolver &solver;
};

struct Mad24FusionPattern : public OpRewritePattern<VAddU32Op> {
  Mad24FusionPattern(MLIRContext *context, const llvm::AMDGPU::IsaVersion &isa,
                     DataFlowSolver &solver)
      : OpRewritePattern<VAddU32Op>(context), isa(isa), solver(solver) {}

  LogicalResult matchAndRewrite(VAddU32Op op,
                                PatternRewriter &rewriter) const override {
    if (succeeded(tryFuse(op, op.getLhs(), op.getRhs(), rewriter)))
      return success();
    return tryFuse(op, op.getRhs(), op.getLhs(), rewriter);
  }

  LogicalResult tryFuse(VAddU32Op op, Value maybeMul, Value addend,
                        PatternRewriter &rewriter) const {
    VMulLoU32Op inner = matchSingleUseProducer<VMulLoU32Op>(maybeMul, op);
    if (!inner)
      return failure();

    std::optional<ConstantIntRanges> lhs = getU32Range(solver, inner.getLhs());
    std::optional<ConstantIntRanges> rhs = getU32Range(solver, inner.getRhs());
    if (!lhs || !rhs)
      return failure();

    if (isProvenU24(*lhs) && isProvenU24(*rhs))
      return tryReplaceTernary<VMadU32U24Op>(
          rewriter, op, inner, inner.getLhs(), inner.getRhs(), addend, isa);
    if (isProvenI24(*lhs) && isProvenI24(*rhs))
      return tryReplaceTernary<VMadI32I24Op>(
          rewriter, op, inner, inner.getLhs(), inner.getRhs(), addend, isa);
    return failure();
  }

  llvm::AMDGPU::IsaVersion isa;
  DataFlowSolver &solver;
};

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
    if (succeeded(tryFuseScalarAdd(rewriter, op, isa)))
      return success();
    if (succeeded(tryFuseNestedBinary<VXorB32Op, VXadU32Op>(rewriter, op, isa)))
      return success();

    return failure();
  }

  llvm::AMDGPU::IsaVersion isa;
};

struct M0AddFusionPattern : public OpRewritePattern<SMovM0Op> {
  M0AddFusionPattern(MLIRContext *context)
      : OpRewritePattern<SMovM0Op>(context) {}

  LogicalResult matchAndRewrite(SMovM0Op op,
                                PatternRewriter &rewriter) const override {
    SAddI32Op inner = matchDeadSCCSAddProducer(op.getSource(), op);
    if (!inner || !hasSingleM0UseBeforeClobber(op))
      return failure();

    SAddM0I32Op fused = SAddM0I32Op::create(
        rewriter, op.getLoc(), op.getResult().getType(),
        inner.getScc().getType(), inner.getLhs(), inner.getRhs());
    rewriter.replaceOp(op, fused.getM0());
    rewriter.eraseOp(inner);
    return success();
  }
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
    if (!isa<VAddU32Op, VLshlrevB32Op, VOrB32Op, SMovM0Op>(op))
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
  DataFlowSolver solver;
  loadBaselineAnalyses(solver);
  solver.load<IntegerRangeAnalysis>();
  if (failed(solver.initializeAndRun(func)))
    return func.emitError("IntegerRangeAnalysis failed for fused-int pass");

  patterns.add<Mad24FusionPattern>(func.getContext(), *isa, solver);
  patterns.add<M0AddFusionPattern>(func.getContext());
  patterns.add<AddFusionPattern, LshlFusionPattern, OrFusionPattern>(
      func.getContext(), *isa);
  DataFlowListener listener(solver);
  return applyPatternsGreedily(
      func, std::move(patterns),
      GreedyRewriteConfig()
          .enableFolding(false)
          .setRegionSimplificationLevel(GreedySimplifyRegionLevel::Disabled)
          .setListener(&listener));
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
