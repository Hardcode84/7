//===- WaveAMDSplitBarriers.cpp ------------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/Wave/Transforms/Passes.h"

#include "WaveAMDSplitBarrierEligibility.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/WaveAMDMachine/CostModel/ArchData.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachine.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachineTarget.h"
#include "llvm/ADT/SmallVector.h"

#include <optional>

namespace mlir::wave {
#define GEN_PASS_DEF_WAVEAMDSPLITBARRIERS
#include "mlir/Dialect/Wave/Transforms/Passes.h.inc"
} // namespace mlir::wave

using namespace mlir;
using namespace mlir::wave;

namespace {

static constexpr StringLiteral kEnableSplitBarriersAttr =
    "waveamdmachine.enable_split_barriers";

static bool isUnderWaveConditional(waveamdmachine::SBarrierOp barrier) {
  return barrier->getParentOfType<waveamdmachine::ExecIfOp>() ||
         barrier->getParentOfType<waveamdmachine::UniformIfOp>();
}

static bool isEligibleBarrier(waveamdmachine::SBarrierOp barrier) {
  if (isUnderWaveConditional(barrier))
    return false;
  return true;
}

static LogicalResult splitFunc(func::FuncOp func, unsigned wavefrontSize,
                               const waveamdmachine::ArchData &arch) {
  if (func.isExternal())
    return success();

  std::optional<unsigned> expectedWaves =
      split_barrier_detail::getExpectedWaves(func, wavefrontSize);
  if (!expectedWaves)
    return success();
  if (*expectedWaves <= static_cast<unsigned>(arch.simdsPerCU))
    return success();

  SmallVector<waveamdmachine::SBarrierOp> barriers;
  func.walk([&](waveamdmachine::SBarrierOp barrier) {
    if (!isEligibleBarrier(barrier))
      return;
    barriers.push_back(barrier);
  });
  if (barriers.empty())
    return success();

  MLIRContext *ctx = func.getContext();
  Type barrierType = waveamdmachine::BarrierType::get(ctx);
  Type ticketType =
      waveamdmachine::RegType::get(ctx, waveamdmachine::RegClass::VGPR, 1, -1);
  Type tokenType = waveamdmachine::MemTokenType::get(ctx);
  Block &entry = func.getBody().front();
  OpBuilder entryBuilder(&entry.front());
  OpBuilder builder(ctx);

  for (waveamdmachine::SBarrierOp barrier : barriers) {
    auto init = waveamdmachine::BarrierInitOp::create(
        entryBuilder, barrier.getLoc(), barrierType);

    builder.setInsertionPoint(barrier);
    auto arrive = waveamdmachine::BarrierArriveOp::create(
        builder, barrier.getLoc(), ticketType, tokenType, init.getBarrier(),
        barrier.getDependencies());
    auto wait = waveamdmachine::BarrierWaitOp::create(
        builder, barrier.getLoc(), tokenType, init.getBarrier(),
        arrive.getTicket(), arrive.getToken());
    for (Value result : barrier->getResults())
      result.replaceAllUsesWith(wait.getToken());
    barrier.erase();
  }
  return success();
}

struct WaveAMDSplitBarriersPass
    : public wave::impl::WaveAMDSplitBarriersBase<WaveAMDSplitBarriersPass> {
  using WaveAMDSplitBarriersBase::WaveAMDSplitBarriersBase;

  void runOnOperation() override {
    Operation *root = getOperation();
    SmallVector<func::FuncOp> functions;
    root->walk([&](func::FuncOp func) {
      if (func->hasAttr(kEnableSplitBarriersAttr))
        functions.push_back(func);
    });
    if (functions.empty())
      return;

    FailureOr<unsigned> wavefrontSize =
        waveamdmachine::getAMDGPUWavefrontSize(root, "waveamd-split-barriers");
    if (failed(wavefrontSize))
      return signalPassFailure();
    FailureOr<waveamdmachine::AMDGPUTarget> target =
        waveamdmachine::getAMDGPUTarget(root, "waveamd-split-barriers");
    if (failed(target))
      return signalPassFailure();
    if (!waveamdmachine::isArchSupported(target->isa)) {
      root->emitError("waveamd-split-barriers unsupported target");
      return signalPassFailure();
    }
    const waveamdmachine::ArchData &arch =
        waveamdmachine::getArchData(target->isa);

    for (func::FuncOp func : functions)
      if (failed(splitFunc(func, *wavefrontSize, arch)))
        return signalPassFailure();
  }
};

} // namespace
