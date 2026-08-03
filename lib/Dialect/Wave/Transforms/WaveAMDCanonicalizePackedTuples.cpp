//===- WaveAMDCanonicalizePackedTuples.cpp - canonical tuple reuse --------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/Wave/Transforms/Passes.h"

#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachine.h"
#include "mlir/IR/Dominance.h"
#include "mlir/IR/PatternMatch.h"
#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/ADT/SmallVector.h"

#include <array>
#include <utility>

namespace mlir::wave {
#define GEN_PASS_DEF_WAVEAMDCANONICALIZEPACKEDTUPLES
#include "mlir/Dialect/Wave/Transforms/Passes.h.inc"
} // namespace mlir::wave

using namespace mlir;
using namespace mlir::waveamdmachine;

namespace {

struct CanonicalTupleLane {
  TupleFromElementsOp tuple;
  Value partner;
  unsigned lane = 0;
  bool ambiguous = false;
};

struct PackedTupleRemap {
  TupleFromElementsOp tuple;
  std::array<unsigned, 2> lanes;
};

using CanonicalTupleKey = std::pair<Value, Type>;
using CanonicalTupleMap = DenseMap<CanonicalTupleKey, CanonicalTupleLane>;

static bool isVGPRPair(TupleFromElementsOp tuple) {
  RegType tupleType = dyn_cast<RegType>(tuple.getTuple().getType());
  if (!tupleType || tupleType.getRegClass() != RegClass::VGPR ||
      tupleType.getWidth() != 2 || tuple.getElements().size() != 2)
    return false;
  for (Value element : tuple.getElements()) {
    RegType elementType = dyn_cast<RegType>(element.getType());
    if (!elementType || elementType.getRegClass() != RegClass::VGPR ||
        elementType.getWidth() != 1)
      return false;
  }
  return true;
}

static void addCanonicalTupleLane(CanonicalTupleMap &tuples, Value element,
                                  Value partner, unsigned lane,
                                  TupleFromElementsOp tuple) {
  CanonicalTupleKey key{element, tuple.getTuple().getType()};
  std::pair<CanonicalTupleMap::iterator, bool> inserted =
      tuples.try_emplace(key, CanonicalTupleLane{tuple, partner, lane, false});
  if (!inserted.second && inserted.first->second.partner != partner)
    inserted.first->second.ambiguous = true;
}

static CanonicalTupleMap collectCanonicalTuples(Block &block) {
  CanonicalTupleMap tuples;
  for (Operation &operation : block) {
    TupleFromElementsOp tuple = dyn_cast<TupleFromElementsOp>(operation);
    if (!tuple || !isVGPRPair(tuple) || tuple.getTuple().use_empty())
      continue;
    Value low = tuple.getElements()[0];
    Value high = tuple.getElements()[1];
    if (low == high)
      continue;
    addCanonicalTupleLane(tuples, low, high, 0, tuple);
    addCanonicalTupleLane(tuples, high, low, 1, tuple);
  }
  return tuples;
}

static const CanonicalTupleLane *
lookupCanonicalTupleLane(const CanonicalTupleMap &tuples, Value element,
                         Type tupleType) {
  CanonicalTupleMap::const_iterator found =
      tuples.find(CanonicalTupleKey{element, tupleType});
  if (found == tuples.end() || found->second.ambiguous)
    return nullptr;
  const CanonicalTupleLane &lane = found->second;
  CanonicalTupleMap::const_iterator partner =
      tuples.find(CanonicalTupleKey{lane.partner, tupleType});
  if (partner == tuples.end() || partner->second.ambiguous ||
      partner->second.tuple != lane.tuple)
    return nullptr;
  return &lane;
}

static FailureOr<PackedTupleRemap>
matchPackedTupleRemap(Value operand, const CanonicalTupleMap &tuples) {
  TupleFromElementsOp repack = operand.getDefiningOp<TupleFromElementsOp>();
  if (!repack || !isVGPRPair(repack))
    return failure();

  PackedTupleRemap remap;
  for (unsigned index : llvm::seq<unsigned>(0, 2)) {
    const CanonicalTupleLane *lane = lookupCanonicalTupleLane(
        tuples, repack.getElements()[index], operand.getType());
    if (!lane)
      return failure();
    if (!remap.tuple)
      remap.tuple = lane->tuple;
    else if (remap.tuple != lane->tuple)
      return failure();
    remap.lanes[index] = lane->lane;
  }
  if (remap.tuple.getTuple() == operand)
    return failure();
  return remap;
}

static bool reachesOperation(TupleFromElementsOp tuple, Operation *op) {
  Operation *tupleOp = tuple;
  if (tupleOp->getBlock() != op->getBlock())
    return false;
  if (op->isBeforeInBlock(tupleOp))
    return true;
  for (Operation *user : tuple.getTuple().getUsers())
    if (user->getBlock() == op->getBlock() &&
        (user == op || op->isBeforeInBlock(user)))
      return true;
  return false;
}

static bool operandsDominate(TupleFromElementsOp tuple, Operation *op,
                             DominanceInfo &dominance) {
  return llvm::all_of(tuple.getElements(), [&](Value value) {
    return dominance.dominates(value, op);
  });
}

static bool isPackedF32Op(Operation *op) {
  return isa<VPkAddF32Op, VPkMulF32Op, VPkFmaF32Op>(op);
}

static FailureOr<PackedTupleRemap>
matchUsablePackedTupleRemap(Operation *op, unsigned operandIndex,
                            const CanonicalTupleMap &tuples,
                            DominanceInfo &dominance) {
  FailureOr<PackedTupleRemap> remap =
      matchPackedTupleRemap(op->getOperand(operandIndex), tuples);
  if (failed(remap) || !reachesOperation(remap->tuple, op) ||
      !operandsDominate(remap->tuple, op, dominance))
    return failure();
  if (op->isBeforeInBlock(remap->tuple))
    remap->tuple->moveBefore(op);
  return remap;
}

static void canonicalizePackedOp(Operation *op, const CanonicalTupleMap &tuples,
                                 DominanceInfo &dominance,
                                 IRRewriter &rewriter) {
  SmallVector<std::pair<unsigned, PackedTupleRemap>, 3> remaps;
  for (unsigned index : llvm::seq<unsigned>(0, op->getNumOperands())) {
    FailureOr<PackedTupleRemap> remap =
        matchUsablePackedTupleRemap(op, index, tuples, dominance);
    if (succeeded(remap))
      remaps.emplace_back(index, *remap);
  }
  if (remaps.empty())
    return;

  rewriter.modifyOpInPlace(op, [&] {
    for (std::pair<unsigned, PackedTupleRemap> &entry : remaps) {
      LogicalResult remapped = remapPackedF32Operand(
          op, entry.first, entry.second.tuple.getTuple(), entry.second.lanes);
      assert(succeeded(remapped) && "matched packed-F32 operand must remap");
      (void)remapped;
    }
  });
}

static void canonicalizeBlock(Block &block, DominanceInfo &dominance,
                              IRRewriter &rewriter) {
  CanonicalTupleMap tuples = collectCanonicalTuples(block);
  SmallVector<Operation *, 16> packedOps;
  for (Operation &operation : block)
    if (isPackedF32Op(&operation))
      packedOps.push_back(&operation);
  for (Operation *op : packedOps)
    canonicalizePackedOp(op, tuples, dominance, rewriter);
}

static void collectBlocks(Operation *op, SmallVectorImpl<Block *> &blocks) {
  for (Region &region : op->getRegions()) {
    for (Block &block : region) {
      blocks.push_back(&block);
      for (Operation &nested : block)
        collectBlocks(&nested, blocks);
    }
  }
}

struct WaveAMDCanonicalizePackedTuplesPass
    : public wave::impl::WaveAMDCanonicalizePackedTuplesBase<
          WaveAMDCanonicalizePackedTuplesPass> {
  void runOnOperation() override {
    getOperation()->walk([&](func::FuncOp func) {
      DominanceInfo dominance(func);
      IRRewriter rewriter(func.getContext());
      SmallVector<Block *, 8> blocks;
      collectBlocks(func, blocks);
      for (Block *block : blocks)
        canonicalizeBlock(*block, dominance, rewriter);
    });
  }
};

} // namespace
