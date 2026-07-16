//===- WaveAMDHoistTuples.cpp - hoist machine tuples --------*- C++ -*-===//
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
#define GEN_PASS_DEF_WAVEAMDHOISTTUPLES
#include "mlir/Dialect/Wave/Transforms/Passes.h.inc"
} // namespace mlir::wave

using namespace mlir;
using namespace mlir::wave;
using namespace mlir::waveamdmachine;

namespace {

struct LoopCarryCandidate {
  Operation *op = nullptr;
  Value initValue;
  SmallVector<Value> updateValues;
  SmallVector<int64_t> updateOffsets;
};

static bool isInside(Operation *root, Operation *op) {
  return op && root->isProperAncestor(op);
}

static bool canCloneBeforeLoop(Operation *op) {
  return op && op->getNumRegions() == 0 &&
         !op->hasTrait<OpTrait::IsTerminator>() && isMemoryEffectFree(op) &&
         isSpeculatable(op);
}

class LoopTupleLikeHoister {
public:
  LoopTupleLikeHoister(UniformLoopOp loop, IRRewriter &rewriter)
      : loop(loop), rewriter(rewriter) {}

  FailureOr<bool> run() {
    if (loop.getBody().empty())
      return false;
    collectCandidates();
    filterCandidates();
    if (candidates.empty())
      return false;
    if (failed(materializeInitValues()))
      return false;
    if (failed(rebuildLoop()))
      return failure();
    return true;
  }

private:
  void collectCandidates() {
    Block &body = loop.getBody().front();
    for (Operation &op : body.without_terminator())
      if (isa<TupleFromElementsOp>(op))
        candidates.push_back({&op});
  }

  void filterCandidates() {
    SmallVector<LoopCarryCandidate> valid;
    for (LoopCarryCandidate candidate : candidates) {
      if (!isValidCandidate(candidate))
        continue;
      valid.push_back(candidate);
    }
    candidates = std::move(valid);
  }

  bool isValidCandidate(LoopCarryCandidate &candidate) {
    if (auto tuple = dyn_cast<TupleFromElementsOp>(candidate.op))
      return isValidTupleCandidate(candidate, tuple);
    return false;
  }

  FailureOr<bool> needsLoopUpdate(Value value) {
    DenseSet<Operation *> invariantSeen;
    if (canMaterializeBeforeLoop(value, /*allowLoopBodyArgs=*/false,
                                 invariantSeen))
      return false;

    DenseSet<Operation *> variantSeen;
    if (!canMaterializeBeforeLoop(value, /*allowLoopBodyArgs=*/true,
                                  variantSeen))
      return failure();
    return true;
  }

  bool isValidTupleCandidate(LoopCarryCandidate &candidate,
                             TupleFromElementsOp tuple) {
    auto tupleType = cast<RegType>(tuple.getTuple().getType());
    int64_t offset = 0;
    int64_t updatedWidth = 0;
    for (Value element : tuple.getElements()) {
      FailureOr<bool> update = needsLoopUpdate(element);
      if (failed(update))
        return false;
      int64_t width = cast<RegType>(element.getType()).getWidth();
      if (*update) {
        if (isExistingLoopCarryValue(element))
          return false;
        candidate.updateValues.push_back(element);
        candidate.updateOffsets.push_back(offset);
        updatedWidth += width;
      }
      offset += width;
    }
    return updatedWidth > 0 && updatedWidth < tupleType.getWidth();
  }

  FailureOr<bool> materializeInitValues() {
    IRMapping mapper;
    Block &body = loop.getBody().front();
    for (auto [arg, init] :
         llvm::zip_equal(body.getArguments(), loop.getInits()))
      mapper.map(arg, init);

    OpBuilder::InsertionGuard guard(rewriter);
    rewriter.setInsertionPoint(loop);
    for (LoopCarryCandidate &candidate : candidates) {
      FailureOr<Value> initValue = materializeInitValue(candidate, mapper);
      if (failed(initValue))
        return failure();
      candidate.initValue = *initValue;
    }
    return true;
  }

  FailureOr<Value> materializeInitValue(LoopCarryCandidate &candidate,
                                        IRMapping &mapper) {
    if (auto tuple = dyn_cast<TupleFromElementsOp>(candidate.op))
      return materializeInitTuple(tuple, mapper);
    return failure();
  }

  FailureOr<Value> materializeInitTuple(TupleFromElementsOp tuple,
                                        IRMapping &mapper) {
    SmallVector<Value> elements;
    for (Value element : tuple.getElements()) {
      FailureOr<Value> initElement = materializeBeforeLoop(element, mapper);
      if (failed(initElement))
        return failure();
      elements.push_back(*initElement);
    }
    auto init = TupleFromElementsOp::create(
        rewriter, tuple.getLoc(), tuple.getTuple().getType(), elements);
    return init.getTuple();
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

  bool isExistingLoopCarryValue(Value value) {
    if (isLoopBodyArgument(value))
      return true;
    Block &body = loop.getBody().front();
    auto term = cast<ContinueIfOp>(body.getTerminator());
    return llvm::is_contained(term.getCarries(), value);
  }

  FailureOr<bool> rebuildLoop() {
    SmallVector<Type> resultTypes;
    SmallVector<Value> inits;
    resultTypes.reserve(loop.getNumResults() + candidates.size());
    inits.reserve(loop.getInits().size() + candidates.size());
    llvm::append_range(resultTypes, loop.getResultTypes());
    llvm::append_range(inits, loop.getInits());
    for (const LoopCarryCandidate &candidate : candidates) {
      resultTypes.push_back(candidate.initValue.getType());
      inits.push_back(candidate.initValue);
    }

    OpBuilder::InsertionGuard guard(rewriter);
    rewriter.setInsertionPoint(loop);
    UniformLoopOp newLoop = UniformLoopOp::create(
        rewriter, loop.getLoc(), resultTypes, loop.getEntryCond(), inits,
        loop.getFetchAlignmentAttr(), loop.getFetchPhaseAttr());
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
      candidateIndex[candidate.op] = index;

    SmallVector<Value> candidateCarries(candidates.size());
    rewriter.setInsertionPointToEnd(newBody);
    for (Operation &op : oldBody.without_terminator()) {
      auto it = candidateIndex.find(&op);
      if (it == candidateIndex.end()) {
        rewriter.clone(op, mapper);
        continue;
      }

      Value current = newBody->getArgument(oldArgCount + it->second);
      FailureOr<Value> update =
          materializeLoopUpdate(candidates[it->second], current, mapper);
      if (failed(update))
        return failure();
      candidateCarries[it->second] = *update;
    }

    auto oldTerm = cast<ContinueIfOp>(oldBody.getTerminator());
    SmallVector<Value> carries;
    carries.reserve(oldTerm.getCarries().size() + candidateCarries.size());
    for (Value carry : oldTerm.getCarries())
      carries.push_back(mapper.lookupOrDefault(carry));
    carries.append(candidateCarries.begin(), candidateCarries.end());
    ContinueIfOp::create(rewriter, oldTerm.getLoc(),
                         mapper.lookupOrDefault(oldTerm.getCond()), carries);
    return success();
  }

  FailureOr<Value> materializeLoopUpdate(LoopCarryCandidate &candidate,
                                         Value current, IRMapping &mapper) {
    if (auto tuple = dyn_cast<TupleFromElementsOp>(candidate.op))
      return materializeTupleUpdate(candidate, tuple, current, mapper);
    return failure();
  }

  Value materializeTupleUpdate(LoopCarryCandidate &candidate,
                               TupleFromElementsOp tuple, Value current,
                               IRMapping &mapper) {
    SmallVector<Value> updates;
    for (Value value : candidate.updateValues)
      updates.push_back(mapper.lookupOrDefault(value));
    auto update = UpdateTupleOp::create(
        rewriter, tuple.getLoc(), tuple.getTuple().getType(), current, updates,
        rewriter.getI64ArrayAttr(candidate.updateOffsets));
    mapper.map(tuple.getTuple(), update.getResult());
    return update.getResult();
  }

  SmallVector<LoopCarryCandidate> candidates;
  UniformLoopOp loop;
  IRRewriter &rewriter;
};

struct WaveAMDHoistTuplesPass
    : public wave::impl::WaveAMDHoistTuplesBase<WaveAMDHoistTuplesPass> {
  void runOnOperation() override {
    IRRewriter rewriter(&getContext());
    bool failedPass = false;
    SmallVector<UniformLoopOp> loops;
    getOperation()->walk([&](UniformLoopOp loop) { loops.push_back(loop); });

    for (UniformLoopOp loop : llvm::reverse(loops)) {
      if (failedPass || !loop->getParentOp())
        continue;
      FailureOr<bool> changed = LoopTupleLikeHoister(loop, rewriter).run();
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
