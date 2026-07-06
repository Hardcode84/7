//===- WaveAMDSplitBarriers.cpp ------------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/Wave/Transforms/Passes.h"

#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachine.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/ADT/SmallVector.h"

#include <limits>
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

static bool isPowerOfTwo(unsigned value) {
  return value != 0 && (value & (value - 1)) == 0;
}

static std::optional<int64_t> getKnownWorkgroupDim(func::FuncOp func,
                                                   unsigned axis) {
  if (axis > 2)
    return std::nullopt;
  for (StringRef name : {"wave.workgroup_size", "gpu.known_block_size"}) {
    DenseI32ArrayAttr attr = func->getAttrOfType<DenseI32ArrayAttr>(name);
    if (!attr)
      continue;
    int32_t dim = axis < attr.size() ? attr.asArrayRef()[axis] : 1;
    if (dim > 0)
      return dim;
  }
  return std::nullopt;
}

static std::optional<uint64_t> checkedMul(uint64_t lhs, uint64_t rhs) {
  if (lhs > std::numeric_limits<uint64_t>::max() / rhs)
    return std::nullopt;
  return lhs * rhs;
}

static std::optional<uint64_t> getFlatWorkgroupSize(func::FuncOp func) {
  uint64_t flat = 1;
  for (unsigned axis : llvm::seq<unsigned>(0, 3)) {
    std::optional<int64_t> dim = getKnownWorkgroupDim(func, axis);
    if (!dim)
      return std::nullopt;
    std::optional<uint64_t> next =
        checkedMul(flat, static_cast<uint64_t>(*dim));
    if (!next)
      return std::nullopt;
    flat = *next;
  }
  return flat;
}

static bool hasConsistentWavesPerWorkgroup(func::FuncOp func, unsigned waves) {
  IntegerAttr attr =
      func->getAttrOfType<IntegerAttr>("wave.waves_per_workgroup");
  return !attr || attr.getInt() == waves;
}

static std::optional<unsigned> getExpectedWaves(func::FuncOp func,
                                                unsigned wavefrontSize) {
  std::optional<uint64_t> flat = getFlatWorkgroupSize(func);
  if (!flat || wavefrontSize == 0)
    return std::nullopt;

  uint64_t waves64 = ((*flat - 1) / wavefrontSize) + 1;
  if (waves64 > std::numeric_limits<unsigned>::max())
    return std::nullopt;
  unsigned waves = static_cast<unsigned>(waves64);
  if (!isPowerOfTwo(waves))
    return std::nullopt;
  if (!hasConsistentWavesPerWorkgroup(func, waves))
    return std::nullopt;
  return waves;
}

static bool isUnderExecIf(waveamdmachine::SBarrierOp barrier) {
  return barrier->getParentOfType<waveamdmachine::ExecIfOp>() != nullptr;
}

static bool isEligibleBarrier(waveamdmachine::SBarrierOp barrier) {
  if (isUnderExecIf(barrier))
    return false;
  return true;
}

static LogicalResult splitFunc(func::FuncOp func, unsigned wavefrontSize) {
  if (func.isExternal())
    return success();
  if (!func->hasAttr(kEnableSplitBarriersAttr))
    return success();

  std::optional<unsigned> expectedWaves = getExpectedWaves(func, wavefrontSize);
  if (!expectedWaves)
    return success();

  SmallVector<waveamdmachine::SBarrierOp> barriers;
  func.walk([&](waveamdmachine::SBarrierOp barrier) {
    if (isEligibleBarrier(barrier))
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
    FailureOr<unsigned> wavefrontSize =
        waveamdmachine::getAMDGPUWavefrontSize(root, "waveamd-split-barriers");
    if (failed(wavefrontSize))
      return signalPassFailure();

    WalkResult result = root->walk([&](func::FuncOp func) {
      if (failed(splitFunc(func, *wavefrontSize)))
        return WalkResult::interrupt();
      return WalkResult::advance();
    });
    if (result.wasInterrupted())
      return signalPassFailure();
  }
};

} // namespace
