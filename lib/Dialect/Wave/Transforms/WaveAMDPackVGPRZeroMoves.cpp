//===- WaveAMDPackVGPRZeroMoves.cpp - pack zero fills -----------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/Wave/Transforms/Passes.h"

#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachine.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachineTarget.h"
#include "mlir/IR/Builders.h"
#include "mlir/IR/BuiltinOps.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/TargetParser/TargetParser.h"

namespace mlir::wave {
#define GEN_PASS_DEF_WAVEAMDPACKVGPRZEROMOVES
#include "mlir/Dialect/Wave/Transforms/Passes.h.inc"
} // namespace mlir::wave

using namespace mlir;

namespace {

static FailureOr<llvm::AMDGPU::IsaVersion> getIsaVersion(Operation *root) {
  return waveamdmachine::getAMDGPUTargetIsaVersion(
      root, "waveamd-pack-vgpr-zero-moves");
}

static bool isZeroImm(Value value) {
  auto imm = value.getDefiningOp<waveamdmachine::ImmOp>();
  return imm && imm.getValue() == 0;
}

static waveamdmachine::RegType getChunkType(MLIRContext *ctx,
                                            waveamdmachine::RegType tupleType,
                                            unsigned width, unsigned offset) {
  int64_t index = tupleType.getIndex() < 0 ? -1 : tupleType.getIndex() + offset;
  return waveamdmachine::RegType::get(ctx, waveamdmachine::RegClass::VGPR,
                                      width, index);
}

static bool canPack(waveamdmachine::VMovB32TupleOp op) {
  auto resultType = dyn_cast<waveamdmachine::RegType>(op.getResult().getType());
  if (!resultType || resultType.getRegClass() != waveamdmachine::RegClass::VGPR)
    return false;
  if (resultType.getIndex() < 0 || resultType.getWidth() < 2)
    return false;
  if (!isZeroImm(op.getSource()))
    return false;
  unsigned base = static_cast<unsigned>(resultType.getIndex());
  unsigned width = static_cast<unsigned>(resultType.getWidth());
  if (base % 2 != 0 && width == 2)
    return false;
  return true;
}

static waveamdmachine::VMovB32TupleOp
createB32Move(OpBuilder &builder, Location loc, Type type, Value zero) {
  auto move = waveamdmachine::VMovB32TupleOp::create(builder, loc, type, zero);
  move->setAttr("registers", builder.getI64IntegerAttr(1));
  return move;
}

static void packMove(waveamdmachine::VMovB32TupleOp op) {
  OpBuilder builder(op);
  Location loc = op.getLoc();
  MLIRContext *ctx = op.getContext();
  Value zero = op.getSource();
  auto resultType = cast<waveamdmachine::RegType>(op.getResult().getType());
  unsigned base = static_cast<unsigned>(resultType.getIndex());
  unsigned width = static_cast<unsigned>(resultType.getWidth());
  SmallVector<Value, 16> elements;

  unsigned offset = 0;
  if (base % 2 != 0) {
    elements.push_back(createB32Move(builder, loc,
                                     getChunkType(ctx, resultType, 1, offset),
                                     zero)
                           .getResult());
    ++offset;
  }
  for (; offset + 1 < width; offset += 2)
    elements.push_back(
        waveamdmachine::VMovB64TupleOp::create(
            builder, loc, getChunkType(ctx, resultType, 2, offset), zero)
            .getResult());
  if (offset < width)
    elements.push_back(createB32Move(builder, loc,
                                     getChunkType(ctx, resultType, 1, offset),
                                     zero)
                           .getResult());

  auto tuple = waveamdmachine::TupleFromElementsOp::create(
      builder, loc, op.getResult().getType(), elements);
  op.getResult().replaceAllUsesWith(tuple.getTuple());
  op.erase();
}

struct WaveAMDPackVGPRZeroMovesPass
    : public wave::impl::WaveAMDPackVGPRZeroMovesBase<
          WaveAMDPackVGPRZeroMovesPass> {
  void runOnOperation() override {
    Operation *root = getOperation();
    FailureOr<llvm::AMDGPU::IsaVersion> isaVersion = getIsaVersion(root);
    if (failed(isaVersion))
      return signalPassFailure();
    if (!waveamdmachine::VMovB64TupleOp::isSupportedOnIsa(*isaVersion))
      return;

    SmallVector<waveamdmachine::VMovB32TupleOp> moves;
    root->walk([&](waveamdmachine::VMovB32TupleOp op) {
      if (canPack(op))
        moves.push_back(op);
    });
    for (waveamdmachine::VMovB32TupleOp op : moves)
      packMove(op);
  }
};

} // namespace
