//===- WaveAMDPackVGPRZeroMoves.cpp - pack zero fills -----------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/Wave/Transforms/Passes.h"

#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachine.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachineTarget.h"
#include "mlir/IR/Builders.h"
#include "mlir/IR/BuiltinOps.h"
#include "mlir/IR/Dominance.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/TargetParser/TargetParser.h"
#include <optional>

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

static std::optional<unsigned> getAllocatedScalarVGPRIndex(Value value) {
  auto type = dyn_cast<waveamdmachine::RegType>(value.getType());
  if (!type || type.getRegClass() != waveamdmachine::RegClass::VGPR ||
      type.getWidth() != 1 || type.getIndex() < 0)
    return std::nullopt;
  return static_cast<unsigned>(type.getIndex());
}

static bool isPackableScalarMove(waveamdmachine::VMovB32TupleOp op) {
  auto resultType = dyn_cast<waveamdmachine::RegType>(op.getResult().getType());
  if (!resultType ||
      resultType.getRegClass() != waveamdmachine::RegClass::VGPR ||
      resultType.getWidth() != 1 || resultType.getIndex() < 0 ||
      !op.getResult().hasOneUse())
    return false;
  return isZeroImm(op.getSource()) ||
         getAllocatedScalarVGPRIndex(op.getSource()).has_value();
}

static bool areAdjacentBefore(Operation *first, Operation *second,
                              Operation *anchor) {
  return first->getBlock() == anchor->getBlock() &&
         second->getBlock() == anchor->getBlock() &&
         first->getNextNode() == second && first->isBeforeInBlock(anchor);
}

static waveamdmachine::VMovB32TupleOp getPackableScalarMove(Value value) {
  auto move = value.getDefiningOp<waveamdmachine::VMovB32TupleOp>();
  if (!move || !isPackableScalarMove(move))
    return {};
  return move;
}

static bool hasZeroSources(waveamdmachine::VMovB32TupleOp first,
                           waveamdmachine::VMovB32TupleOp second) {
  return isZeroImm(first.getSource()) && isZeroImm(second.getSource());
}

static bool hasContiguousVGPRSourcePair(waveamdmachine::VMovB32TupleOp first,
                                        waveamdmachine::VMovB32TupleOp second) {
  std::optional<unsigned> firstIndex =
      getAllocatedScalarVGPRIndex(first.getSource());
  std::optional<unsigned> secondIndex =
      getAllocatedScalarVGPRIndex(second.getSource());
  return firstIndex && secondIndex && *firstIndex % 2 == 0 &&
         *secondIndex == *firstIndex + 1;
}

static bool valueDominates(Value value, Operation *op, DominanceInfo &dom) {
  if (auto arg = dyn_cast<BlockArgument>(value))
    return dom.dominates(arg.getOwner(), op->getBlock());
  Operation *def = value.getDefiningOp();
  return def && dom.dominates(def, op);
}

static bool sourcesDominatePack(waveamdmachine::VMovB32TupleOp first,
                                waveamdmachine::VMovB32TupleOp second,
                                DominanceInfo &dom) {
  return valueDominates(first.getSource(), first, dom) &&
         valueDominates(second.getSource(), first, dom);
}

static bool canPackPair(waveamdmachine::VMovB32TupleOp first,
                        waveamdmachine::VMovB32TupleOp second,
                        waveamdmachine::TupleFromElementsOp tuple,
                        DominanceInfo &dom) {
  auto firstType = cast<waveamdmachine::RegType>(first.getResult().getType());
  auto secondType = cast<waveamdmachine::RegType>(second.getResult().getType());
  return firstType.getIndex() % 2 == 0 &&
         secondType.getIndex() == firstType.getIndex() + 1 &&
         areAdjacentBefore(first, second, tuple) &&
         sourcesDominatePack(first, second, dom) &&
         (hasZeroSources(first, second) ||
          hasContiguousVGPRSourcePair(first, second));
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

static Value createB64Move(OpBuilder &builder,
                           waveamdmachine::VMovB32TupleOp first,
                           waveamdmachine::VMovB32TupleOp second,
                           waveamdmachine::RegType firstType) {
  builder.setInsertionPoint(first);
  auto pairType = waveamdmachine::RegType::get(first.getContext(),
                                               waveamdmachine::RegClass::VGPR,
                                               2, firstType.getIndex());
  if (hasZeroSources(first, second))
    return waveamdmachine::VMovB64TupleOp::create(builder, first.getLoc(),
                                                  pairType, first.getSource())
        .getResult();
  return waveamdmachine::VMovB64FromElementsOp::create(
             builder, first.getLoc(), pairType, first.getSource(),
             second.getSource())
      .getResult();
}

static bool packTupleElements(waveamdmachine::TupleFromElementsOp tuple,
                              DominanceInfo &dom) {
  OpBuilder builder(tuple.getContext());
  SmallVector<Value, 16> elements;
  SmallVector<waveamdmachine::VMovB32TupleOp, 16> movesToErase;
  ValueRange oldElements = tuple.getElements();

  for (unsigned i = 0, e = oldElements.size(); i != e;) {
    waveamdmachine::VMovB32TupleOp first =
        getPackableScalarMove(oldElements[i]);
    waveamdmachine::VMovB32TupleOp second =
        i + 1 == e ? waveamdmachine::VMovB32TupleOp()
                   : getPackableScalarMove(oldElements[i + 1]);
    if (!first || !second || !canPackPair(first, second, tuple, dom)) {
      elements.push_back(oldElements[i++]);
      continue;
    }

    auto firstType = cast<waveamdmachine::RegType>(first.getResult().getType());
    elements.push_back(createB64Move(builder, first, second, firstType));
    movesToErase.push_back(first);
    movesToErase.push_back(second);
    i += 2;
  }

  if (movesToErase.empty())
    return false;

  builder.setInsertionPoint(tuple);
  auto replacement = waveamdmachine::TupleFromElementsOp::create(
      builder, tuple.getLoc(), tuple.getTuple().getType(), elements);
  tuple.getTuple().replaceAllUsesWith(replacement.getTuple());
  tuple.erase();
  for (waveamdmachine::VMovB32TupleOp move : llvm::reverse(movesToErase))
    move.erase();
  return true;
}

static void eraseDeadScalarB32Moves(Operation *root) {
  SmallVector<waveamdmachine::VMovB32TupleOp, 16> deadMoves;
  root->walk([&](waveamdmachine::VMovB32TupleOp op) {
    auto resultType =
        dyn_cast<waveamdmachine::RegType>(op.getResult().getType());
    if (resultType && resultType.getWidth() == 1 && op->use_empty())
      deadMoves.push_back(op);
  });
  for (waveamdmachine::VMovB32TupleOp op : llvm::reverse(deadMoves))
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

    SmallVector<func::FuncOp> funcs;
    root->walk([&](func::FuncOp func) { funcs.push_back(func); });
    for (func::FuncOp func : funcs) {
      DominanceInfo dom(func);
      SmallVector<waveamdmachine::TupleFromElementsOp> tuples;
      func.walk([&](waveamdmachine::TupleFromElementsOp op) {
        tuples.push_back(op);
      });
      for (waveamdmachine::TupleFromElementsOp op : tuples)
        packTupleElements(op, dom);
    }
    eraseDeadScalarB32Moves(root);
  }
};

} // namespace
