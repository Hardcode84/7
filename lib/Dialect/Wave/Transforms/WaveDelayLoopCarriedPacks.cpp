//===- WaveDelayLoopCarriedPacks.cpp - Delay sub-dword packs ----*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/Wave/Transforms/Passes.h"

#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/SCF/IR/SCF.h"
#include "mlir/Dialect/Wave/IR/Wave.h"
#include "mlir/Dialect/Wave/IR/WaveAMD.h"
#include "mlir/IR/IRMapping.h"
#include "mlir/IR/PatternMatch.h"
#include "llvm/ADT/DenseSet.h"
#include "llvm/ADT/STLExtras.h"

namespace mlir::wave {
#define GEN_PASS_DEF_WAVEDELAYLOOPCARRIEDPACKS
#include "mlir/Dialect/Wave/Transforms/Passes.h.inc"
} // namespace mlir::wave

using namespace mlir;
using namespace mlir::wave;

namespace {
struct PackCarry {
  SmallVector<Value, 8> initInputs;
  SmallVector<Value, 8> yieldInputs;
  PackOp initPack;
  PackOp yieldPack;
  unsigned oldIndex;
};

struct DelayedPackArg {
  BlockArgument oldArg;
  SmallVector<Value, 8> inputs;
  Location loc;
};
} // namespace

static VectorType getWaveVectorPayload(Type type) {
  if (SimdType simd = dyn_cast<SimdType>(type))
    type = simd.getElementType();
  return dyn_cast<VectorType>(type);
}

static bool isSubDwordIntegerPack(PackOp pack) {
  VectorType vectorType = getWaveVectorPayload(pack.getResult().getType());
  if (!vectorType || vectorType.getRank() != 1)
    return false;
  Type elementType = vectorType.getElementType();
  return elementType.isInteger() && elementType.getIntOrFloatBitWidth() < 32;
}

static bool isReadResult(Value value) {
  if (ExtractOp extract = value.getDefiningOp<ExtractOp>())
    return isReadResult(extract.getSource());
  Operation *def = value.getDefiningOp();
  return isa_and_nonnull<LoadOp, waveamd::TransposeLoadOp>(def);
}

static bool hasReadOperands(PackOp pack) {
  return llvm::all_of(pack.getInputs(), isReadResult);
}

static bool samePackShape(PackOp lhs, PackOp rhs, Type resultType) {
  if (lhs.getResult().getType() != resultType ||
      rhs.getResult().getType() != resultType ||
      lhs.getInputs().size() != rhs.getInputs().size())
    return false;
  for (auto [lhsInput, rhsInput] :
       llvm::zip_equal(lhs.getInputs(), rhs.getInputs()))
    if (lhsInput.getType() != rhsInput.getType())
      return false;
  return true;
}

static FailureOr<PackCarry> matchPackCarry(scf::ForOp loop, unsigned index) {
  PackOp initPack = loop.getInitArgs()[index].getDefiningOp<PackOp>();
  if (!initPack || !isSubDwordIntegerPack(initPack))
    return failure();

  scf::YieldOp yield = cast<scf::YieldOp>(loop.getBody()->getTerminator());
  PackOp yieldPack = yield.getOperand(index).getDefiningOp<PackOp>();
  if (!yieldPack)
    return failure();
  if (!yieldPack.getResult().hasOneUse())
    return failure();

  Type resultType = loop.getResult(index).getType();
  if (!samePackShape(initPack, yieldPack, resultType))
    return failure();
  if (!hasReadOperands(yieldPack))
    return failure();

  SmallVector<Value, 8> initInputs(initPack.getInputs().begin(),
                                   initPack.getInputs().end());
  SmallVector<Value, 8> yieldInputs(yieldPack.getInputs().begin(),
                                    yieldPack.getInputs().end());
  return PackCarry{initInputs, yieldInputs, initPack, yieldPack, index};
}

static SmallVector<PackCarry> collectPackCarries(scf::ForOp loop) {
  SmallVector<PackCarry> packs;
  for (unsigned index : llvm::seq<unsigned>(0, loop.getNumResults())) {
    FailureOr<PackCarry> pack = matchPackCarry(loop, index);
    if (succeeded(pack))
      packs.push_back(*pack);
  }
  return packs;
}

static const PackCarry *findPackCarry(ArrayRef<PackCarry> packs,
                                      unsigned index) {
  auto it = llvm::find_if(
      packs, [index](const PackCarry &pack) { return pack.oldIndex == index; });
  return it == packs.end() ? nullptr : &*it;
}

static SmallVector<Value> buildInitArgs(ArrayRef<PackCarry> packs,
                                        scf::ForOp loop) {
  SmallVector<Value> initArgs;
  for (unsigned index = 0; index < loop.getInitArgs().size(); ++index) {
    if (const PackCarry *pack = findPackCarry(packs, index)) {
      initArgs.append(pack->initInputs.begin(), pack->initInputs.end());
      continue;
    }
    initArgs.push_back(loop.getInitArgs()[index]);
  }
  return initArgs;
}

static void copyScfForAttrs(scf::ForOp src, scf::ForOp dst) {
  for (NamedAttribute attr : src->getAttrs())
    dst->setAttr(attr.getName(), attr.getValue());
}

static void mapLoopArgs(scf::ForOp oldLoop, scf::ForOp newLoop,
                        ArrayRef<PackCarry> packs, IRMapping &map,
                        SmallVectorImpl<DelayedPackArg> &delayedPacks) {
  map.map(oldLoop.getInductionVar(), newLoop.getInductionVar());

  unsigned newIndex = 0;
  for (unsigned oldIndex = 0; oldIndex < oldLoop.getNumRegionIterArgs();
       ++oldIndex) {
    BlockArgument oldArg = oldLoop.getRegionIterArgs()[oldIndex];
    if (const PackCarry *pack = findPackCarry(packs, oldIndex)) {
      SmallVector<Value, 8> inputs;
      unsigned end = newIndex + pack->initInputs.size();
      for (; newIndex < end; ++newIndex)
        inputs.push_back(newLoop.getRegionIterArgs()[newIndex]);
      delayedPacks.push_back(DelayedPackArg{oldArg, inputs, oldLoop.getLoc()});
      continue;
    }
    map.map(oldArg, newLoop.getRegionIterArgs()[newIndex++]);
  }
}

static SmallVector<Value> buildYieldOperands(scf::YieldOp oldYield,
                                             PatternRewriter &rewriter,
                                             ArrayRef<PackCarry> packs,
                                             IRMapping &map) {
  SmallVector<Value> operands;
  for (unsigned index = 0; index < oldYield.getNumOperands(); ++index) {
    if (const PackCarry *pack = findPackCarry(packs, index)) {
      SmallVector<Value> mappedInputs;
      for (Value input : pack->yieldInputs)
        mappedInputs.push_back(map.lookupOrDefault(input));
      operands.append(mappedInputs.begin(), mappedInputs.end());
      continue;
    }
    operands.push_back(map.lookupOrDefault(oldYield.getOperand(index)));
  }
  return operands;
}

static bool usesValue(Operation &op, Value value) {
  WalkResult result = op.walk([&](Operation *nested) {
    if (llvm::is_contained(nested->getOperands(), value))
      return WalkResult::interrupt();
    return WalkResult::advance();
  });
  return result.wasInterrupted();
}

static void materializeNeededPacks(PatternRewriter &rewriter, Operation &op,
                                   MutableArrayRef<DelayedPackArg> delayedPacks,
                                   IRMapping &map) {
  for (DelayedPackArg &pack : delayedPacks) {
    if (map.contains(pack.oldArg) || !usesValue(op, pack.oldArg))
      continue;
    Value repacked =
        PackOp::create(rewriter, pack.loc, pack.oldArg.getType(), pack.inputs)
            .getResult();
    map.map(pack.oldArg, repacked);
  }
}

static void cloneLoopBody(PatternRewriter &rewriter, scf::ForOp oldLoop,
                          scf::ForOp newLoop, ArrayRef<PackCarry> packs) {
  DenseSet<Operation *> skippedYieldPacks;
  for (const PackCarry &pack : packs)
    skippedYieldPacks.insert(pack.yieldPack);

  Block &oldBody = *oldLoop.getBody();
  IRMapping map;
  SmallVector<DelayedPackArg> delayedPacks;
  rewriter.setInsertionPointToStart(newLoop.getBody());
  mapLoopArgs(oldLoop, newLoop, packs, map, delayedPacks);

  for (Operation &op : oldBody.without_terminator()) {
    if (skippedYieldPacks.contains(&op))
      continue;
    materializeNeededPacks(rewriter, op, delayedPacks, map);
    rewriter.clone(op, map);
  }

  scf::YieldOp oldYield = cast<scf::YieldOp>(oldBody.getTerminator());
  rewriter.setInsertionPointToEnd(newLoop.getBody());
  SmallVector<Value> operands =
      buildYieldOperands(oldYield, rewriter, packs, map);
  scf::YieldOp::create(rewriter, oldYield.getLoc(), operands);
}

static SmallVector<Value> buildLoopReplacements(PatternRewriter &rewriter,
                                                scf::ForOp oldLoop,
                                                scf::ForOp newLoop,
                                                ArrayRef<PackCarry> packs) {
  SmallVector<Value> replacements;
  unsigned newIndex = 0;
  for (unsigned oldIndex = 0; oldIndex < oldLoop.getNumResults(); ++oldIndex) {
    if (const PackCarry *pack = findPackCarry(packs, oldIndex)) {
      SmallVector<Value> inputs;
      unsigned end = newIndex + pack->initInputs.size();
      for (; newIndex < end; ++newIndex)
        inputs.push_back(newLoop.getResult(newIndex));
      Value repacked =
          PackOp::create(rewriter, oldLoop.getLoc(),
                         oldLoop.getResult(oldIndex).getType(), inputs)
              .getResult();
      replacements.push_back(repacked);
      continue;
    }
    replacements.push_back(newLoop.getResult(newIndex++));
  }
  return replacements;
}

static void eraseDeadInitPacks(ArrayRef<PackCarry> packs) {
  for (const PackCarry &pack : packs)
    if (pack.initPack->use_empty())
      pack.initPack->erase();
}

static LogicalResult rewriteLoop(PatternRewriter &rewriter, scf::ForOp loop,
                                 ArrayRef<PackCarry> packs) {
  rewriter.setInsertionPoint(loop);
  SmallVector<Value> initArgs = buildInitArgs(packs, loop);
  scf::ForOp newLoop =
      scf::ForOp::create(rewriter, loop.getLoc(), loop.getLowerBound(),
                         loop.getUpperBound(), loop.getStep(), initArgs);
  copyScfForAttrs(loop, newLoop);
  cloneLoopBody(rewriter, loop, newLoop, packs);

  rewriter.setInsertionPointAfter(newLoop);
  SmallVector<Value> replacements =
      buildLoopReplacements(rewriter, loop, newLoop, packs);
  rewriter.replaceOp(loop, replacements);
  eraseDeadInitPacks(packs);
  return success();
}

namespace {
struct WaveDelayLoopCarriedPacksPass
    : public wave::impl::WaveDelayLoopCarriedPacksBase<
          WaveDelayLoopCarriedPacksPass> {
  void runOnOperation() override {
    SmallVector<scf::ForOp> loops;
    getOperation()->walk([&](scf::ForOp loop) { loops.push_back(loop); });

    MLIRContext *ctx = &getContext();
    PatternRewriter rewriter(ctx);
    for (scf::ForOp loop : llvm::reverse(loops)) {
      SmallVector<PackCarry> packs = collectPackCarries(loop);
      if (packs.empty())
        continue;
      if (failed(rewriteLoop(rewriter, loop, packs)))
        return signalPassFailure();
    }
  }
};
} // namespace
