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
#include <array>

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
  Operation *clone = rewriter.insert(op->clone(map, options));
  for (auto [result, clonedResult] :
       llvm::zip_equal(op->getResults(), clone->getResults()))
    map.map(result, clonedResult);
  return clone;
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
  if (!wouldOpBeTriviallyDead(access) &&
      !access->hasTrait<OpTrait::wave::DiscardableMemoryOp>())
    return access->emitOpError(
        "memory alternatives require discardable effects");
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

static bool reachesEffectfulUser(Value root) {
  llvm::SetVector<Value> pending;
  pending.insert(root);
  for (size_t index = 0; index < pending.size(); ++index) {
    for (Operation *user : pending[index].getUsers()) {
      if (!isMemoryEffectFree(user))
        return true;
      for (Value result : user->getResults())
        pending.insert(result);
    }
  }
  return false;
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

static bool isPointerChoice(MaterializationVariantsOp choice) {
  Type type = choice.getType();
  if (auto simd = dyn_cast<SimdType>(type))
    type = simd.getElementType();
  return isa<PtrType>(type);
}

static bool isOffsetUser(Operation *user, MaterializationVariantsOp choice) {
  auto pointer = dyn_cast<PtrAddOp>(user);
  return pointer && pointer.getOffset() == choice &&
         reachesEffectfulUser(pointer.getResult());
}

struct WaveMaterializeMemoryVariantsPass
    : wave::impl::WaveMaterializeMemoryVariantsBase<
          WaveMaterializeMemoryVariantsPass> {
  void runOnOperation() override {
    if (failed(wave::captureMemoryVariants(getOperation())))
      return signalPassFailure();
  }
};

} // namespace

bool mlir::wave::isCapturedMemoryVariant(PtrAddOp pointer) {
  std::array<llvm::SetVector<Value>, 2> pending;
  pending[0].insert(pointer.getResult());
  // Cross at most one access; visit each value twice at most: O(V + E).
  for (unsigned afterAccess : llvm::seq(2u))
    for (size_t index = 0; index < pending[afterAccess].size(); ++index)
      for (Operation *user : pending[afterAccess][index].getUsers()) {
        if (isa<MaterializationVariantsOp>(user))
          return true;
        if (user->getNumRegions())
          continue;
        if (isMemoryEffectFree(user))
          pending[afterAccess].insert_range(user->getResults());
        else if (!afterAccess)
          pending[1].insert_range(user->getResults());
      }
  return false;
}

bool mlir::wave::canCaptureMemoryVariants(PtrAddOp pointer) {
  llvm::SetVector<Operation *> pending;
  pending.insert_range(pointer->getUsers());
  // O(V + E) in this address-use graph; shared users are visited once.
  for (size_t index = 0; index < pending.size(); ++index) {
    Operation *user = pending[index];
    if (user->getNumRegions() || user->hasTrait<OpTrait::IsTerminator>())
      return false;
    if (!isMemoryEffectFree(user)) {
      if (!wouldOpBeTriviallyDead(user) &&
          !user->hasTrait<OpTrait::wave::DiscardableMemoryOp>())
        return false;
      continue;
    }
    for (Value result : user->getResults())
      pending.insert_range(result.getUsers());
  }
  return true;
}

LogicalResult mlir::wave::captureMemoryVariants(Operation *root) {
  llvm::SetVector<Operation *> cleanupRoots;
  SmallVector<MaterializationVariantsOp> addressChoices;
  root->walk([&](MaterializationVariantsOp choice) {
    bool addressChoice =
        isPointerChoice(choice)
            ? reachesEffectfulUser(choice.getResult())
            : llvm::any_of(choice->getUsers(), [&](Operation *user) {
                return isOffsetUser(user, choice);
              });
    if (addressChoice)
      addressChoices.push_back(choice);
  });

  IRRewriter rewriter(root->getContext());
  // Capture consumers first so producer capture sees concrete address users.
  for (MaterializationVariantsOp sourceChoice : llvm::reverse(addressChoices)) {
    ConcreteAlternatives concrete;
    concrete[sourceChoice.getResult()] =
        llvm::to_vector(sourceChoice.getChoices());
    llvm::SetVector<Value> dependentValues;
    cleanupRoots.insert(sourceChoice);
    if (isPointerChoice(sourceChoice)) {
      dependentValues.insert(sourceChoice.getResult());
    } else {
      // Offset choices can have non-address uses; leave those choices intact.
      for (Operation *user :
           llvm::make_early_inc_range(sourceChoice->getUsers())) {
        if (!isOffsetUser(user, sourceChoice))
          continue;
        if (failed(
                duplicatePureAddressOp(rewriter, user, concrete, sourceChoice)))
          return failure();
        dependentValues.insert(cast<PtrAddOp>(user).getResult());
        cleanupRoots.insert(user);
      }
    }
    if (failed(duplicateDependentUsers(rewriter, sourceChoice, concrete,
                                       dependentValues, cleanupRoots)))
      return failure();
  }
  RewritePatternSet patterns(root->getContext());
  GreedyRewriteConfig config;
  config.setStrictness(GreedyRewriteStrictness::ExistingOps)
      .enableFolding(false)
      .enableConstantCSE(false);
  return applyOpPatternsGreedily(cleanupRoots.getArrayRef(),
                                 FrozenRewritePatternSet(std::move(patterns)),
                                 config);
}
