//===- WaveAMDHoistBufferRsrc.cpp - hoist buffer SRDs -------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/Wave/Transforms/Passes.h"

#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachine.h"
#include "mlir/IR/IRMapping.h"
#include "mlir/IR/PatternMatch.h"
#include "mlir/Interfaces/SideEffectInterfaces.h"
#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/DenseSet.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/ADT/SmallVector.h"

namespace mlir::wave {
#define GEN_PASS_DEF_WAVEAMDHOISTBUFFERRSRC
#include "mlir/Dialect/Wave/Transforms/Passes.h.inc"
} // namespace mlir::wave

using namespace mlir;
using namespace mlir::wave;
using namespace mlir::waveamdmachine;

namespace {

struct BufferRsrcCandidate {
  MakeBufferRsrcOp make;
  Value initDescriptor;
};

static bool isInside(Operation *root, Operation *op) {
  return op && root->isProperAncestor(op);
}

static bool canCloneBeforeLoop(Operation *op) {
  return op && op->getNumRegions() == 0 &&
         !op->hasTrait<OpTrait::IsTerminator>() && isMemoryEffectFree(op) &&
         isSpeculatable(op);
}

class LoopBufferRsrcHoister {
public:
  LoopBufferRsrcHoister(UniformLoopOp loop, IRRewriter &rewriter)
      : loop(loop), rewriter(rewriter) {}

  FailureOr<bool> run() {
    if (loop.getBody().empty())
      return false;
    collectCandidates();
    filterCandidates();
    if (candidates.empty())
      return false;
    if (failed(materializeInitDescriptors()))
      return false;
    if (failed(rebuildLoop()))
      return failure();
    return true;
  }

private:
  void collectCandidates() {
    Block &body = loop.getBody().front();
    for (Operation &op : body.without_terminator())
      if (auto make = dyn_cast<MakeBufferRsrcOp>(op))
        candidates.push_back({make, {}});
  }

  void filterCandidates() {
    SmallVector<BufferRsrcCandidate> valid;
    for (BufferRsrcCandidate candidate : candidates) {
      DenseSet<Operation *> baseSeen;
      DenseSet<Operation *> rangeSeen;
      if (!canMaterializeBeforeLoop(candidate.make.getBase(),
                                    /*allowLoopBodyArgs=*/true, baseSeen))
        continue;
      if (!canMaterializeBeforeLoop(candidate.make.getRange(),
                                    /*allowLoopBodyArgs=*/false, rangeSeen))
        continue;
      valid.push_back(candidate);
    }
    candidates = std::move(valid);
  }

  FailureOr<bool> materializeInitDescriptors() {
    IRMapping mapper;
    Block &body = loop.getBody().front();
    for (auto [arg, init] :
         llvm::zip_equal(body.getArguments(), loop.getInits()))
      mapper.map(arg, init);

    OpBuilder::InsertionGuard guard(rewriter);
    rewriter.setInsertionPoint(loop);
    for (BufferRsrcCandidate &candidate : candidates) {
      FailureOr<Value> base =
          materializeBeforeLoop(candidate.make.getBase(), mapper);
      if (failed(base))
        return failure();
      FailureOr<Value> range =
          materializeBeforeLoop(candidate.make.getRange(), mapper);
      if (failed(range))
        return failure();
      candidate.initDescriptor = MakeBufferRsrcOp::create(
          rewriter, candidate.make.getLoc(),
          candidate.make.getDescriptor().getType(), *base, *range);
    }
    return true;
  }

  bool canMaterializeBeforeLoop(Value value, bool allowLoopBodyArgs,
                                DenseSet<Operation *> &seen) {
    if (!allowLoopBodyArgs && isLoopBodyArgument(value))
      return false;

    Operation *def = value.getDefiningOp();
    if (!isInside(loop, def))
      return true;
    if (!canCloneBeforeLoop(def))
      return false;
    if (!seen.insert(def).second)
      return true;

    for (Value operand : def->getOperands())
      if (!canMaterializeBeforeLoop(operand, allowLoopBodyArgs, seen))
        return false;
    return true;
  }

  FailureOr<Value> materializeBeforeLoop(Value value, IRMapping &mapper) {
    if (Value mapped = mapper.lookupOrNull(value))
      return mapped;

    Operation *def = value.getDefiningOp();
    if (!isInside(loop, def))
      return value;
    if (!canCloneBeforeLoop(def))
      return failure();

    for (Value operand : def->getOperands())
      if (failed(materializeBeforeLoop(operand, mapper)))
        return failure();

    Operation *clone = rewriter.clone(*def, mapper);
    (void)clone;
    if (Value mapped = mapper.lookupOrNull(value))
      return mapped;
    return failure();
  }

  bool isLoopBodyArgument(Value value) {
    auto arg = dyn_cast<BlockArgument>(value);
    return arg && arg.getOwner() == &loop.getBody().front();
  }

  FailureOr<bool> rebuildLoop() {
    SmallVector<Type> resultTypes;
    SmallVector<Value> inits;
    resultTypes.reserve(loop.getNumResults() + candidates.size());
    inits.reserve(loop.getInits().size() + candidates.size());
    llvm::append_range(resultTypes, loop.getResultTypes());
    llvm::append_range(inits, loop.getInits());
    for (const BufferRsrcCandidate &candidate : candidates) {
      resultTypes.push_back(candidate.initDescriptor.getType());
      inits.push_back(candidate.initDescriptor);
    }

    OpBuilder::InsertionGuard guard(rewriter);
    rewriter.setInsertionPoint(loop);
    UniformLoopOp newLoop = UniformLoopOp::create(
        rewriter, loop.getLoc(), resultTypes, loop.getEntryCond(), inits);
    copyLoopAttrs(newLoop);
    if (failed(cloneBody(newLoop))) {
      newLoop.erase();
      return failure();
    }

    for (auto [oldResult, newResult] :
         llvm::zip_equal(loop.getResults(),
                         newLoop.getResults().take_front(loop.getNumResults())))
      oldResult.replaceAllUsesWith(newResult);
    rewriter.eraseOp(loop);
    return true;
  }

  void copyLoopAttrs(UniformLoopOp newLoop) {
    StringRef segmentAttr = newLoop.getOperandSegmentSizeAttr();
    for (NamedAttribute attr : loop->getAttrs())
      if (attr.getName() != segmentAttr)
        newLoop->setAttr(attr.getName(), attr.getValue());
  }

  LogicalResult cloneBody(UniformLoopOp newLoop) {
    Block &oldBody = loop.getBody().front();
    Block *newBody = new Block;
    newLoop.getBody().push_back(newBody);
    for (Value init : newLoop.getInits())
      newBody->addArgument(init.getType(), loop.getLoc());

    IRMapping mapper;
    for (unsigned i : llvm::seq<unsigned>(0, oldBody.getNumArguments()))
      mapper.map(oldBody.getArgument(i), newBody->getArgument(i));

    unsigned oldArgCount = oldBody.getNumArguments();
    DenseMap<Operation *, unsigned> candidateIndex;
    for (auto [index, candidate] : llvm::enumerate(candidates))
      candidateIndex[candidate.make.getOperation()] = index;

    SmallVector<Value> descriptorCarries(candidates.size());
    rewriter.setInsertionPointToEnd(newBody);
    for (Operation &op : oldBody.without_terminator()) {
      auto it = candidateIndex.find(&op);
      if (it == candidateIndex.end()) {
        rewriter.clone(op, mapper);
        continue;
      }

      auto make = cast<MakeBufferRsrcOp>(op);
      Value descriptor = newBody->getArgument(oldArgCount + it->second);
      Value base = mapper.lookupOrDefault(make.getBase());
      auto update = UpdateBufferRsrcBaseOp::create(
          rewriter, make.getLoc(), make.getDescriptor().getType(), descriptor,
          base);
      mapper.map(make.getDescriptor(), update.getResult());
      descriptorCarries[it->second] = update.getResult();
    }

    auto oldTerm = cast<ContinueIfOp>(oldBody.getTerminator());
    SmallVector<Value> carries;
    carries.reserve(oldTerm.getCarries().size() + descriptorCarries.size());
    for (Value carry : oldTerm.getCarries())
      carries.push_back(mapper.lookupOrDefault(carry));
    carries.append(descriptorCarries.begin(), descriptorCarries.end());
    ContinueIfOp::create(rewriter, oldTerm.getLoc(),
                         mapper.lookupOrDefault(oldTerm.getCond()), carries);
    return success();
  }

  SmallVector<BufferRsrcCandidate> candidates;
  UniformLoopOp loop;
  IRRewriter &rewriter;
};

struct WaveAMDHoistBufferRsrcPass
    : public wave::impl::WaveAMDHoistBufferRsrcBase<
          WaveAMDHoistBufferRsrcPass> {
  void runOnOperation() override {
    IRRewriter rewriter(&getContext());
    bool failedPass = false;
    SmallVector<UniformLoopOp> loops;
    getOperation()->walk([&](UniformLoopOp loop) { loops.push_back(loop); });

    for (UniformLoopOp loop : llvm::reverse(loops)) {
      if (failedPass || !loop->getParentOp())
        continue;
      FailureOr<bool> changed = LoopBufferRsrcHoister(loop, rewriter).run();
      if (failed(changed)) {
        failedPass = true;
        break;
      }
    }

    if (failedPass)
      signalPassFailure();
  }
};

} // namespace
