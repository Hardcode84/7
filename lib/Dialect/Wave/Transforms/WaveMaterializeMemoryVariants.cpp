//===- WaveMaterializeMemoryVariants.cpp - Concrete memory choices -------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/Wave/Transforms/Passes.h"

#include "mlir/Dialect/Wave/IR/Wave.h"
#include "mlir/IR/IRMapping.h"
#include "mlir/IR/PatternMatch.h"
#include "mlir/Interfaces/SideEffectInterfaces.h"
#include "mlir/Transforms/GreedyPatternRewriteDriver.h"
#include "llvm/ADT/SetVector.h"

namespace mlir::wave {
#define GEN_PASS_DEF_WAVEMATERIALIZEMEMORYVARIANTS
#include "mlir/Dialect/Wave/Transforms/Passes.h.inc"
} // namespace mlir::wave

using namespace mlir;
using namespace mlir::wave;

namespace {

using ConcreteAlternatives = DenseMap<Value, SmallVector<Value>>;

static Operation *cloneWithMappedOperands(IRRewriter &rewriter, Operation *op,
                                          IRMapping &map) {
  SmallVector<Type> resultTypes(op->getResultTypes());
  Operation::CloneOptions options = Operation::CloneOptions::all();
  options.withResultTypes(std::move(resultTypes));
  return rewriter.insert(op->clone(map, options));
}

static void mapAlternativeOperands(IRMapping &map, Operation *op,
                                   const ConcreteAlternatives &concrete,
                                   unsigned alternative) {
  for (Value operand : op->getOperands()) {
    auto found = concrete.find(operand);
    map.map(operand,
            found == concrete.end() ? operand : found->second[alternative]);
  }
}

static LogicalResult duplicateAccess(IRRewriter &rewriter, Operation *access,
                                     const ConcreteAlternatives &concrete,
                                     MaterializationVariantsOp choice) {
  if (access->getNumRegions() != 0)
    return access->emitOpError(
        "effectful materialization alternative must be region-free");
  SmallVector<SmallVector<Value>> resultAlternatives(access->getNumResults());
  rewriter.setInsertionPoint(access);
  for (unsigned alternative : llvm::seq(choice.getChoices().size())) {
    IRMapping accessMap;
    mapAlternativeOperands(accessMap, access, concrete, alternative);
    Operation *concreteAccess =
        cloneWithMappedOperands(rewriter, access, accessMap);
    for (auto [result, alternatives] :
         llvm::zip_equal(concreteAccess->getResults(), resultAlternatives))
      alternatives.push_back(result);
  }

  SmallVector<Value> replacements;
  replacements.reserve(access->getNumResults());
  for (auto [result, alternatives] :
       llvm::zip_equal(access->getResults(), resultAlternatives)) {
    auto resultChoice = MaterializationVariantsOp::create(
        rewriter, access->getLoc(), result.getType(), alternatives);
    replacements.push_back(resultChoice.getResult());
    if (isa<MemTokenType>(result.getType()))
      MaterializationAnchorOp::create(rewriter, access->getLoc(), resultChoice);
  }
  rewriter.replaceOp(access, replacements);
  return success();
}

static LogicalResult duplicatePureAddressOp(IRRewriter &rewriter, Operation *op,
                                            ConcreteAlternatives &concrete,
                                            MaterializationVariantsOp choice) {
  if (op->getNumRegions() != 0 || !isMemoryEffectFree(op))
    return op->emitOpError(
        "operation in a materialization address tree must be pure and "
        "region-free");
  SmallVector<SmallVector<Value>> resultAlternatives(op->getNumResults());
  rewriter.setInsertionPoint(op);
  for (unsigned alternative : llvm::seq(choice.getChoices().size())) {
    IRMapping map;
    mapAlternativeOperands(map, op, concrete, alternative);
    Operation *clone = cloneWithMappedOperands(rewriter, op, map);
    for (auto [result, alternatives] :
         llvm::zip_equal(clone->getResults(), resultAlternatives))
      alternatives.push_back(result);
  }
  for (auto [result, alternatives] :
       llvm::zip_equal(op->getResults(), resultAlternatives))
    concrete[result] = std::move(alternatives);
  return success();
}

static llvm::SetVector<Operation *>
collectDependentUsers(llvm::SetVector<Value> &dependentValues) {
  llvm::SetVector<Operation *> reachable;
  for (size_t index = 0; index < dependentValues.size(); ++index) {
    Value value = dependentValues[index];
    for (Operation *user : value.getUsers()) {
      if (!reachable.insert(user) || !isMemoryEffectFree(user))
        continue;
      for (Value result : user->getResults())
        dependentValues.insert(result);
    }
  }

  return reachable;
}

static SmallVector<Operation *>
collectReadyUsers(const llvm::SetVector<Operation *> &pending,
                  const llvm::SetVector<Value> &dependentValues,
                  const ConcreteAlternatives &concrete) {
  SmallVector<Operation *> readyUsers;
  for (Operation *user : pending) {
    bool ready = llvm::all_of(user->getOperands(), [&](Value operand) {
      return !dependentValues.contains(operand) || concrete.contains(operand);
    });
    if (ready)
      readyUsers.push_back(user);
  }
  return readyUsers;
}

static LogicalResult duplicateDependentUsers(
    IRRewriter &rewriter, MaterializationVariantsOp sourceChoice,
    ConcreteAlternatives &concrete, llvm::SetVector<Value> &dependentValues,
    llvm::SetVector<Operation *> &cleanupRoots) {
  llvm::SetVector<Operation *> reachable =
      collectDependentUsers(dependentValues);
  llvm::SetVector<Operation *> pending = reachable;
  while (!pending.empty()) {
    SmallVector<Operation *> readyUsers =
        collectReadyUsers(pending, dependentValues, concrete);
    if (readyUsers.empty()) {
      pending.front()->emitOpError(
          "materialization address alternatives contain a cycle");
      return failure();
    }
    for (Operation *user : readyUsers) {
      pending.remove(user);
      if (!isMemoryEffectFree(user)) {
        if (failed(duplicateAccess(rewriter, user, concrete, sourceChoice)))
          return failure();
        continue;
      }
      if (failed(
              duplicatePureAddressOp(rewriter, user, concrete, sourceChoice)))
        return failure();
      cleanupRoots.insert(user);
    }
  }
  return success();
}

static LogicalResult materializePointerChoices(
    IRRewriter &rewriter, MaterializationVariantsOp sourceChoice,
    ArrayRef<PtrAddOp> pointers, llvm::SetVector<Operation *> &cleanupRoots) {
  ConcreteAlternatives concrete;
  llvm::SetVector<Value> dependentValues;
  cleanupRoots.insert(sourceChoice);
  for (PtrAddOp ptrAdd : pointers) {
    cleanupRoots.insert(ptrAdd);
    SmallVector<Value> concretePointers;
    rewriter.setInsertionPoint(ptrAdd);
    for (Value concreteOffset : sourceChoice.getChoices()) {
      IRMapping map;
      map.map(sourceChoice.getResult(), concreteOffset);
      concretePointers.push_back(
          cloneWithMappedOperands(rewriter, ptrAdd, map)->getResult(0));
    }
    concrete[ptrAdd.getResult()] = std::move(concretePointers);
    dependentValues.insert(ptrAdd.getResult());
  }

  if (failed(duplicateDependentUsers(rewriter, sourceChoice, concrete,
                                     dependentValues, cleanupRoots)))
    return failure();
  return success();
}

struct WaveMaterializeMemoryVariantsPass
    : wave::impl::WaveMaterializeMemoryVariantsBase<
          WaveMaterializeMemoryVariantsPass> {
  void runOnOperation() override {
    llvm::SetVector<Operation *> cleanupRoots;
    SmallVector<MaterializationVariantsOp> addressChoices;
    DenseMap<Operation *, SmallVector<PtrAddOp>> pointersByChoice;
    getOperation()->walk([&](PtrAddOp op) {
      auto choice = op.getOffset().getDefiningOp<MaterializationVariantsOp>();
      if (!choice)
        return;
      auto [it, inserted] = pointersByChoice.try_emplace(choice);
      if (inserted)
        addressChoices.push_back(choice);
      it->second.push_back(op);
    });

    IRRewriter rewriter(&getContext());
    for (MaterializationVariantsOp sourceChoice : addressChoices)
      if (failed(materializePointerChoices(
              rewriter, sourceChoice, pointersByChoice.lookup(sourceChoice),
              cleanupRoots)))
        return signalPassFailure();
    RewritePatternSet patterns(&getContext());
    GreedyRewriteConfig config;
    config.setStrictness(GreedyRewriteStrictness::ExistingOps)
        .enableFolding(false)
        .enableConstantCSE(false);
    if (failed(applyOpPatternsGreedily(
            cleanupRoots.getArrayRef(),
            FrozenRewritePatternSet(std::move(patterns)), config)))
      return signalPassFailure();
  }
};

} // namespace
