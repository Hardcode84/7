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

static void mapAlternativeOperands(IRMapping &map, Operation *op,
                                   const ConcreteAlternatives &concrete,
                                   Choice choice, unsigned alternative) {
  for (Value operand : op->getOperands()) {
    auto found = concrete.find(operand);
    if (found != concrete.end())
      map.map(operand, found->second[alternative]);
    else
      map.map(operand, selectCoupledOperand(operand, choice, alternative));
  }
}

static LogicalResult duplicateAccess(IRRewriter &rewriter, Operation *access,
                                     const ConcreteAlternatives &concrete,
                                     Choice choice) {
  if (access->getNumRegions() != 0)
    return access->emitOpError(
        "effectful materialization alternative must be region-free");
  for (Value operand : access->getOperands())
    if (failed(verifyCoupledOperand(access, operand, choice)))
      return failure();

  SmallVector<SmallVector<Value>> resultAlternatives(access->getNumResults());
  rewriter.setInsertionPoint(access);
  for (unsigned alternative : llvm::seq(choice.op.getChoices().size())) {
    IRMapping accessMap;
    mapAlternativeOperands(accessMap, access, concrete, choice, alternative);
    Operation *concreteAccess = rewriter.clone(*access, accessMap);
    concreteAccess->setAttr(kMaterializationChoiceGroupAttrName,
                            rewriter.getI64IntegerAttr(choice.group));
    concreteAccess->setAttr(kMaterializationAlternativeAttrName,
                            rewriter.getI64IntegerAttr(alternative));
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
    mapAlternativeOperands(map, op, concrete, choice, alternative);
    Operation *clone = rewriter.clone(*op, map);
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
      auto group = sourceChoice->getAttrOfType<IntegerAttr>(
          kMaterializationChoiceGroupAttrName);
      if (!group) {
        group = rewriter.getI64IntegerAttr(nextGroup++);
        sourceChoice->setAttr(kMaterializationChoiceGroupAttrName, group);
      }
      Choice choice{sourceChoice, group.getInt()};

      ConcreteAlternatives concrete;
      llvm::SetVector<Value> dependentValues;
      for (PtrAddOp ptrAdd : pointersByChoice.lookup(sourceChoice)) {
        SmallVector<Value> concretePointers;
        rewriter.setInsertionPoint(ptrAdd);
        for (Value concreteOffset : sourceChoice.getChoices()) {
          IRMapping map;
          map.map(sourceChoice.getResult(), concreteOffset);
          concretePointers.push_back(
              rewriter.clone(*ptrAdd, map)->getResult(0));
        }
        concrete[ptrAdd.getResult()] = std::move(concretePointers);
        dependentValues.insert(ptrAdd.getResult());
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
        bool madeProgress = false;
        for (Operation *user : llvm::make_early_inc_range(pending)) {
          bool ready = llvm::all_of(user->getOperands(), [&](Value operand) {
            return !dependentValues.contains(operand) ||
                   concrete.contains(operand);
          });
          if (!ready)
            continue;
          pending.remove(user);
          madeProgress = true;
          if (!isMemoryEffectFree(user)) {
            if (failed(duplicateAccess(rewriter, user, concrete, choice)))
              return signalPassFailure();
            continue;
          }
          if (failed(duplicatePureAddressOp(rewriter, user, concrete, choice)))
            return signalPassFailure();
        }
        if (!madeProgress) {
          pending.front()->emitOpError(
              "materialization address alternatives contain a cycle");
          return signalPassFailure();
        }
      }

    }
  }
};

} // namespace
