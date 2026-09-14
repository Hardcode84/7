//===- WaveMaterializeMemoryVariants.cpp - Concrete memory choices -------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/Wave/Transforms/Passes.h"

#include "mlir/Dialect/Utils/MaterializationVariants.h"
#include "mlir/Dialect/Wave/IR/Wave.h"
#include "mlir/IR/IRMapping.h"
#include "mlir/IR/PatternMatch.h"
#include "mlir/Interfaces/SideEffectInterfaces.h"
#include "mlir/Transforms/GreedyPatternRewriteDriver.h"
#include "llvm/ADT/DenseSet.h"
#include "llvm/ADT/SetVector.h"
#include "llvm/ADT/SmallPtrSet.h"

namespace mlir::wave {
#define GEN_PASS_DEF_WAVEMATERIALIZEMEMORYVARIANTS
#include "mlir/Dialect/Wave/Transforms/Passes.h.inc"
} // namespace mlir::wave

using namespace mlir;
using namespace mlir::wave;

namespace {

struct Choice {
  MaterializationVariantsOp op;
  int64_t group;
};

static LogicalResult verifyCoupledOperand(Operation *op, Value value,
                                          Choice addressChoice) {
  auto choice = value.getDefiningOp<MaterializationVariantsOp>();
  if (!choice)
    return success();
  auto group =
      choice->getAttrOfType<IntegerAttr>(kMaterializationChoiceGroupAttrName);
  if (!group || group.getInt() != addressChoice.group)
    return op->emitOpError(
        "memory alternative combines independent materialization groups");
  if (choice.getChoices().size() != addressChoice.op.getChoices().size())
    return op->emitOpError(
        "coupled materialization choices must have equal arity");
  return success();
}

static Value selectCoupledOperand(Value value, Choice addressChoice,
                                  unsigned alternative) {
  auto choice = value.getDefiningOp<MaterializationVariantsOp>();
  if (!choice)
    return value;
  return choice.getChoices()[alternative];
}

using ConcreteAlternatives = DenseMap<Value, SmallVector<Value>>;

static Operation *cloneWithMappedOperands(IRRewriter &rewriter, Operation *op,
                                           IRMapping &map) {
  SmallVector<Type> resultTypes(op->getResultTypes());
  Operation::CloneOptions options = Operation::CloneOptions::all();
  options.withResultTypes(std::move(resultTypes));
  return rewriter.insert(op->clone(map, options));
}

static LogicalResult
mapAlternativeOperands(IRMapping &map, Operation *op,
                       const ConcreteAlternatives &concrete, Choice choice,
                       unsigned alternative) {
  for (Value operand : op->getOperands()) {
    auto found = concrete.find(operand);
    if (found != concrete.end()) {
      if (alternative >= found->second.size())
        return op->emitOpError(
            "concrete materialization has inconsistent alternative count");
      map.map(operand, found->second[alternative]);
    } else {
      map.map(operand, selectCoupledOperand(operand, choice, alternative));
    }
    if (!map.lookupOrNull(operand))
      return op->emitOpError("materialization produced a null operand");
  }
  return success();
}

static LogicalResult duplicateAccess(IRRewriter &rewriter, Operation *access,
                                     const ConcreteAlternatives &concrete,
                                     Choice choice) {
  if (auto existingGroup = access->getAttrOfType<IntegerAttr>(
          kMaterializationChoiceGroupAttrName))
    return access->emitOpError("memory access already belongs to group ")
           << existingGroup.getInt() << " while materializing group "
           << choice.group;
  if (access->getNumRegions() != 0)
    return access->emitOpError(
        "effectful materialization alternative must be region-free");
  for (Value operand : access->getOperands())
    if (failed(verifyCoupledOperand(access, operand, choice)))
      return failure();

  SmallVector<SmallVector<Value>> resultAlternatives(access->getNumResults());
  if (llvm::any_of(access->getResultTypes(), [](Type type) { return !type; }))
    return access->emitOpError("materialization access has a null result type");
  rewriter.setInsertionPoint(access);
  for (unsigned alternative : llvm::seq(choice.op.getChoices().size())) {
    IRMapping accessMap;
    if (failed(mapAlternativeOperands(accessMap, access, concrete, choice,
                                      alternative)))
      return failure();
    Operation *concreteAccess =
        cloneWithMappedOperands(rewriter, access, accessMap);
    concreteAccess->setAttr(kMaterializationChoiceGroupAttrName,
                            rewriter.getI64IntegerAttr(choice.group));
    concreteAccess->setAttr(kMaterializationAlternativeAttrName,
                            rewriter.getI64IntegerAttr(alternative));
    if (llvm::any_of(concreteAccess->getResultTypes(),
                     [](Type type) { return !type; }))
      return concreteAccess->emitOpError(
          "cloned materialization access has a null result type");
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
    resultChoice->setAttr(kMaterializationChoiceGroupAttrName,
                          rewriter.getI64IntegerAttr(choice.group));
    resultChoice->setAttr(kMaterializationEffectOwnerAttrName,
                          rewriter.getUnitAttr());
    replacements.push_back(resultChoice.getResult());
  }
  rewriter.replaceOp(access, replacements);
  return success();
}

static LogicalResult
duplicatePureAddressOp(IRRewriter &rewriter, Operation *op,
                       ConcreteAlternatives &concrete, Choice choice) {
  if (op->getNumRegions() != 0 || !isMemoryEffectFree(op))
    return op->emitOpError(
        "operation in a materialization address tree must be pure and "
        "region-free");
  for (Value operand : op->getOperands())
    if (failed(verifyCoupledOperand(op, operand, choice)))
      return failure();

  SmallVector<SmallVector<Value>> resultAlternatives(op->getNumResults());
  rewriter.setInsertionPoint(op);
  for (unsigned alternative : llvm::seq(choice.op.getChoices().size())) {
    IRMapping map;
    if (failed(mapAlternativeOperands(map, op, concrete, choice, alternative)))
      return failure();
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

struct WaveMaterializeMemoryVariantsPass
    : wave::impl::WaveMaterializeMemoryVariantsBase<
          WaveMaterializeMemoryVariantsPass> {
  void runOnOperation() override {
    llvm::SetVector<Operation *> cleanupRoots;
    int64_t nextGroup = 0;
    getOperation()->walk([&](MaterializationVariantsOp op) {
      if (auto group = op->getAttrOfType<IntegerAttr>(
              kMaterializationChoiceGroupAttrName))
        nextGroup = std::max(nextGroup, group.getInt() + 1);
    });

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
    for (MaterializationVariantsOp sourceChoice : addressChoices) {
      if (sourceChoice->hasAttr(kMaterializationChoiceGroupAttrName))
        continue;
      sourceChoice->setAttr(kMaterializationChoiceGroupAttrName,
                            rewriter.getI64IntegerAttr(nextGroup++));
    }
    llvm::DenseSet<int64_t> processedGroups;
    for (MaterializationVariantsOp sourceChoice : addressChoices) {
      auto group = sourceChoice->getAttrOfType<IntegerAttr>(
          kMaterializationChoiceGroupAttrName);
      if (!processedGroups.insert(group.getInt()).second)
        continue;
      Choice choice{sourceChoice, group.getInt()};

      ConcreteAlternatives concrete;
      llvm::SetVector<Value> dependentValues;
      for (MaterializationVariantsOp groupChoice : addressChoices) {
        auto candidateGroup = groupChoice->getAttrOfType<IntegerAttr>(
            kMaterializationChoiceGroupAttrName);
        if (candidateGroup.getInt() != choice.group)
          continue;
        if (groupChoice.getChoices().size() != sourceChoice.getChoices().size()) {
          groupChoice.emitOpError(
              "materialization choices in one group must have equal arity");
          return signalPassFailure();
        }
        cleanupRoots.insert(groupChoice);
        for (PtrAddOp ptrAdd : pointersByChoice.lookup(groupChoice)) {
          cleanupRoots.insert(ptrAdd);
          SmallVector<Value> concretePointers;
          rewriter.setInsertionPoint(ptrAdd);
          for (Value concreteOffset : groupChoice.getChoices()) {
            IRMapping map;
            map.map(groupChoice.getResult(), concreteOffset);
            concretePointers.push_back(
                cloneWithMappedOperands(rewriter, ptrAdd, map)->getResult(0));
          }
          concrete[ptrAdd.getResult()] = std::move(concretePointers);
          dependentValues.insert(ptrAdd.getResult());
        }
      }

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

      llvm::SetVector<Operation *> pending = reachable;
      while (!pending.empty()) {
        SmallVector<Operation *> readyUsers;
        for (Operation *user : pending) {
          bool ready = llvm::all_of(user->getOperands(), [&](Value operand) {
            return !dependentValues.contains(operand) ||
                   concrete.contains(operand);
          });
          if (ready)
            readyUsers.push_back(user);
        }
        if (readyUsers.empty()) {
          pending.front()->emitOpError(
              "materialization address alternatives contain a cycle");
          return signalPassFailure();
        }
        for (Operation *user : readyUsers) {
          pending.remove(user);
          if (!isMemoryEffectFree(user)) {
            if (failed(duplicateAccess(rewriter, user, concrete, choice)))
              return signalPassFailure();
            continue;
          }
          if (failed(duplicatePureAddressOp(rewriter, user, concrete, choice)))
            return signalPassFailure();
          cleanupRoots.insert(user);
        }
      }

    }
    RewritePatternSet patterns(&getContext());
    GreedyRewriteConfig config;
    config.setStrictness(GreedyRewriteStrictness::ExistingOps)
        .enableFolding(false)
        .enableConstantCSE(false);
    if (failed(applyOpPatternsGreedily(
            cleanupRoots.getArrayRef(),
            FrozenRewritePatternSet(std::move(patterns)),
            config)))
      return signalPassFailure();
  }
};

} // namespace
