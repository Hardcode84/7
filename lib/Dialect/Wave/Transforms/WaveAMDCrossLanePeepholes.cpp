//===- WaveAMDCrossLanePeepholes.cpp - Cross-lane peepholes ----*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/Wave/Transforms/Passes.h"

#include "SIDefines.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachine.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachineTarget.h"
#include "mlir/IR/PatternMatch.h"
#include "mlir/Transforms/GreedyPatternRewriteDriver.h"

namespace mlir::wave {
#define GEN_PASS_DEF_WAVEAMDCROSSLANEPEEPHOLES
#include "mlir/Dialect/Wave/Transforms/Passes.h.inc"
} // namespace mlir::wave

using namespace mlir;
using namespace mlir::wave;
using namespace mlir::waveamdmachine;

namespace {

static std::optional<int64_t> getImmediate(Value value) {
  ImmOp imm = value.getDefiningOp<ImmOp>();
  if (!imm)
    return std::nullopt;
  return imm.getValue();
}

static bool isLaneId(Value value, unsigned wavefrontSize) {
  if (wavefrontSize == 32)
    return isa_and_nonnull<VMbcntLoOp>(value.getDefiningOp());

  VMbcntHiOp hi = value.getDefiningOp<VMbcntHiOp>();
  return hi && isa_and_nonnull<VMbcntLoOp>(hi.getSource().getDefiningOp());
}

static bool isLowFiveBitMask(int64_t value) {
  return value >= 0 && value <= llvm::AMDGPU::Swizzle::BITMASK_MASK;
}

static unsigned encodeBitmaskPerm(unsigned andMask, unsigned orMask,
                                  unsigned xorMask) {
  using namespace llvm::AMDGPU::Swizzle;
  return (andMask << BITMASK_AND_SHIFT) | (orMask << BITMASK_OR_SHIFT) |
         (xorMask << BITMASK_XOR_SHIFT);
}

static std::optional<unsigned> matchXorLaneSwizzle(Value laneExpr,
                                                   unsigned wavefrontSize) {
  if (isLaneId(laneExpr, wavefrontSize))
    return encodeBitmaskPerm(llvm::AMDGPU::Swizzle::BITMASK_MASK, 0, 0);

  VXorB32Op xorOp = laneExpr.getDefiningOp<VXorB32Op>();
  if (!xorOp)
    return std::nullopt;

  auto matchLaneAndMask = [&](Value lhs, Value rhs) -> std::optional<unsigned> {
    if (!isLaneId(lhs, wavefrontSize))
      return std::nullopt;
    std::optional<int64_t> mask = getImmediate(rhs);
    if (!mask || !isLowFiveBitMask(*mask))
      return std::nullopt;
    return encodeBitmaskPerm(llvm::AMDGPU::Swizzle::BITMASK_MASK, 0, *mask);
  };

  if (std::optional<unsigned> offset =
          matchLaneAndMask(xorOp.getLhs(), xorOp.getRhs()))
    return offset;
  return matchLaneAndMask(xorOp.getRhs(), xorOp.getLhs());
}

static std::optional<unsigned>
matchDsPermuteSwizzleOffset(DsPermuteB32Op op, unsigned wavefrontSize) {
  if (op.getOffset() != 0)
    return std::nullopt;

  VLshlrevB32Op byteAddr = op.getAddr().getDefiningOp<VLshlrevB32Op>();
  if (!byteAddr)
    return std::nullopt;
  std::optional<int64_t> shift = getImmediate(byteAddr.getRhs());
  if (!shift || *shift != 2)
    return std::nullopt;

  return matchXorLaneSwizzle(byteAddr.getLhs(), wavefrontSize);
}

static void eraseIfDead(PatternRewriter &rewriter, Operation *op) {
  if (!op || !op->use_empty())
    return;
  rewriter.eraseOp(op);
}

static void eraseDeadAddressChain(PatternRewriter &rewriter, Value addr) {
  VLshlrevB32Op byteAddr = addr.getDefiningOp<VLshlrevB32Op>();
  if (!byteAddr || !byteAddr->use_empty())
    return;

  Value laneExpr = byteAddr.getLhs();
  rewriter.eraseOp(byteAddr);
  if (VXorB32Op xorOp = laneExpr.getDefiningOp<VXorB32Op>()) {
    Operation *lhs = xorOp.getLhs().getDefiningOp();
    Operation *rhs = xorOp.getRhs().getDefiningOp();
    eraseIfDead(rewriter, xorOp);
    eraseIfDead(rewriter, lhs);
    eraseIfDead(rewriter, rhs);
  }
}

struct DsPermuteToSwizzlePattern : public OpRewritePattern<DsPermuteB32Op> {
  DsPermuteToSwizzlePattern(MLIRContext *context, unsigned wavefrontSize)
      : OpRewritePattern<DsPermuteB32Op>(context),
        wavefrontSize(wavefrontSize) {}

  LogicalResult matchAndRewrite(DsPermuteB32Op op,
                                PatternRewriter &rewriter) const override {
    std::optional<unsigned> offset =
        matchDsPermuteSwizzleOffset(op, wavefrontSize);
    if (!offset)
      return failure();

    Value addr = op.getAddr();
    DsSwizzleB32Op swizzle = DsSwizzleB32Op::create(
        rewriter, op.getLoc(), op.getResult().getType(), op.getData(),
        rewriter.getI64IntegerAttr(*offset));
    rewriter.replaceOp(op, swizzle.getResult());
    eraseDeadAddressChain(rewriter, addr);
    return success();
  }

  unsigned wavefrontSize;
};

static bool hasCrossLanePeepholeCandidate(func::FuncOp func) {
  bool found = false;
  WalkResult result = func.walk([&](DsPermuteB32Op) {
    found = true;
    return WalkResult::interrupt();
  });
  return result.wasInterrupted() && found;
}

static LogicalResult runOnFunc(func::FuncOp func) {
  if (!hasCrossLanePeepholeCandidate(func))
    return success();

  FailureOr<unsigned> wavefrontSize = waveamdmachine::getAMDGPUWavefrontSize(
      func, "waveamd-cross-lane-peepholes");
  if (failed(wavefrontSize))
    return failure();

  RewritePatternSet patterns(func.getContext());
  patterns.add<DsPermuteToSwizzlePattern>(func.getContext(), *wavefrontSize);
  return applyPatternsGreedily(
      func, std::move(patterns),
      GreedyRewriteConfig().enableFolding(false).setRegionSimplificationLevel(
          GreedySimplifyRegionLevel::Disabled));
}

struct WaveAMDCrossLanePeepholesPass
    : public wave::impl::WaveAMDCrossLanePeepholesBase<
          WaveAMDCrossLanePeepholesPass> {
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
