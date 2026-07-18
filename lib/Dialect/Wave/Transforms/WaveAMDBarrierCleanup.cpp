//===- WaveAMDBarrierCleanup.cpp ------------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/Wave/Transforms/Passes.h"

#include "mlir/Dialect/WaveAMDMachine/CostModel/OpClassifier.h"
#include "mlir/Dialect/WaveAMDMachine/CostModel/SchedClass.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachine.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachineTraits.h"
#include "mlir/IR/Builders.h"
#include "llvm/ADT/DenseSet.h"
#include "llvm/ADT/SmallVector.h"

namespace mlir::wave {
#define GEN_PASS_DEF_WAVEAMDBARRIERCLEANUP
#include "mlir/Dialect/Wave/Transforms/Passes.h.inc"
} // namespace mlir::wave

using namespace mlir;
using namespace mlir::wave;

namespace {

namespace traits = ::mlir::OpTrait::waveamdmachine;

static bool isMemToken(Value value) {
  return isa<waveamdmachine::MemTokenType>(value.getType());
}

static bool isFlatNoInst(Operation *op) {
  if (op->hasTrait<OpTrait::IsTerminator>() || op->getNumRegions() != 0)
    return false;
  if (!isa<waveamdmachine::WaveAMDMachineDialect>(op->getDialect()))
    return false;
  if (isa<waveamdmachine::LabelOp>(op))
    return false;
  if (!waveamdmachine::hasSchedClassMapping(op))
    return false;
  return waveamdmachine::classifyOp(op) == waveamdmachine::SchedClass::NoInst;
}

static bool isFlattenableTokenProducer(Operation *op) {
  if (!isFlatNoInst(op))
    return false;
  // Flattening restores completion deps and drains retained async groups.
  if (isa<waveamdmachine::IssueTokenOp>(op))
    return false;
  return op->hasTrait<traits::TokenOp>() || op->hasTrait<traits::TokenJoinOp>();
}

static bool isFirstBarrierResult(Value value,
                                 waveamdmachine::SBarrierOp first) {
  for (Value result : first->getResults())
    if (value == result)
      return true;
  return false;
}

static bool isBetween(Operation *op, Operation *first, Operation *second) {
  return op->getBlock() == first->getBlock() && first->isBeforeInBlock(op) &&
         op->isBeforeInBlock(second);
}

static bool addUnique(Value value, SmallVectorImpl<Value> &deps,
                      llvm::SmallDenseSet<Value, 16> &seen) {
  if (!isMemToken(value))
    return true;
  if (seen.insert(value).second)
    deps.push_back(value);
  return true;
}

struct TokenDepCollector {
  bool collect(Value token) {
    if (!isMemToken(token))
      return true;
    if (!visiting.insert(token).second)
      return true;
    if (isFirstBarrierResult(token, first))
      return collectOperands(first);

    Operation *def = token.getDefiningOp();
    if (!def || !isBetween(def, first, second))
      return addUnique(token, deps, seen);
    return collectBetweenDef(def);
  }

  bool collectOperands(Operation *op) {
    for (Value operand : op->getOperands())
      if (isMemToken(operand) && !collect(operand))
        return false;
    return true;
  }

  bool collectBetweenDef(Operation *def) {
    if (!isFlattenableTokenProducer(def))
      return false;
    return collectOperands(def);
  }

  waveamdmachine::SBarrierOp first;
  waveamdmachine::SBarrierOp second;
  SmallVectorImpl<Value> &deps;
  llvm::SmallDenseSet<Value, 16> &seen;
  llvm::SmallDenseSet<Value, 16> &visiting;
};

static FailureOr<SmallVector<Value, 8>>
collectMergedDeps(waveamdmachine::SBarrierOp first,
                  waveamdmachine::SBarrierOp second) {
  SmallVector<Value, 8> deps;
  llvm::SmallDenseSet<Value, 16> seen;
  llvm::SmallDenseSet<Value, 16> visiting;
  TokenDepCollector collector{first, second, deps, seen, visiting};
  for (Value operand : first->getOperands())
    if (!collector.collect(operand))
      return failure();
  for (Value operand : second->getOperands())
    if (!collector.collect(operand))
      return failure();
  return deps;
}

static bool needsTokenResult(waveamdmachine::SBarrierOp first,
                             waveamdmachine::SBarrierOp second) {
  return first->getNumResults() != 0 || second->getNumResults() != 0;
}

static void replaceResults(Operation *op, Value replacement) {
  for (Value result : op->getResults())
    result.replaceAllUsesWith(replacement);
}

static FailureOr<waveamdmachine::SBarrierOp>
collapseBarriers(waveamdmachine::SBarrierOp first,
                 waveamdmachine::SBarrierOp second) {
  FailureOr<SmallVector<Value, 8>> deps = collectMergedDeps(first, second);
  if (failed(deps))
    return failure();

  OpBuilder builder(first);
  SmallVector<Type, 1> resultTypes;
  if (needsTokenResult(first, second))
    resultTypes.push_back(
        waveamdmachine::MemTokenType::get(first.getContext()));

  auto replacement = waveamdmachine::SBarrierOp::create(builder, first.getLoc(),
                                                        resultTypes, *deps);
  replacement->setAttrs(first->getAttrs());
  if (!resultTypes.empty()) {
    Value token = replacement->getResult(0);
    replaceResults(first, token);
    replaceResults(second, token);
  }
  second->erase();
  first->erase();
  return replacement;
}

static waveamdmachine::SBarrierOp
getPreviousBarrier(waveamdmachine::SBarrierOp barrier) {
  Operation *cursor = barrier->getPrevNode();
  while (cursor && isFlatNoInst(cursor))
    cursor = cursor->getPrevNode();
  return dyn_cast_or_null<waveamdmachine::SBarrierOp>(cursor);
}

static FailureOr<waveamdmachine::SBarrierOp>
tryCollapseWithPrevious(waveamdmachine::SBarrierOp barrier) {
  waveamdmachine::SBarrierOp previous = getPreviousBarrier(barrier);
  if (!previous)
    return failure();
  return collapseBarriers(previous, barrier);
}

static FailureOr<waveamdmachine::SBarrierOp>
tryCollapseFrom(waveamdmachine::SBarrierOp first) {
  Operation *cursor = first->getNextNode();
  while (cursor && isFlatNoInst(cursor))
    cursor = cursor->getNextNode();

  auto second = dyn_cast_or_null<waveamdmachine::SBarrierOp>(cursor);
  if (!second)
    return failure();
  return collapseBarriers(first, second);
}

struct SplitBarrierDepCollector {
  bool collect(Value token) {
    if (!isMemToken(token))
      return true;
    if (token == arrive.getToken()) {
      sawArriveToken = true;
      if (!visiting.insert(token).second)
        return true;
      return collectOperands(arrive);
    }
    if (!visiting.insert(token).second)
      return true;

    Operation *def = token.getDefiningOp();
    if (!def || !isBetween(def, arrive, wait))
      return addUnique(token, deps, seen);
    return collectBetweenDef(def);
  }

  bool collectOperands(Operation *op) {
    for (Value operand : op->getOperands())
      if (isMemToken(operand) && !collect(operand))
        return false;
    return true;
  }

  bool collectBetweenDef(Operation *def) {
    if (!isFlattenableTokenProducer(def))
      return false;
    return collectOperands(def);
  }

  waveamdmachine::BarrierArriveOp arrive;
  waveamdmachine::BarrierWaitOp wait;
  SmallVectorImpl<Value> &deps;
  llvm::SmallDenseSet<Value, 16> &seen;
  llvm::SmallDenseSet<Value, 16> &visiting;
  bool sawArriveToken = false;
};

static FailureOr<SmallVector<Value, 8>>
collectMergedDeps(waveamdmachine::BarrierArriveOp arrive,
                  waveamdmachine::BarrierWaitOp wait) {
  SmallVector<Value, 8> deps;
  llvm::SmallDenseSet<Value, 16> seen;
  llvm::SmallDenseSet<Value, 16> visiting;
  SplitBarrierDepCollector collector{arrive, wait, deps, seen, visiting};
  if (!collector.collect(wait.getArrival()) || !collector.sawArriveToken)
    return failure();
  return deps;
}

static bool hasOnlyWaitUsers(Value value, waveamdmachine::BarrierWaitOp wait) {
  for (OpOperand &use : value.getUses())
    if (use.getOwner() != wait.getOperation())
      return false;
  return true;
}

static bool isMatchingWait(waveamdmachine::BarrierArriveOp arrive,
                           waveamdmachine::BarrierWaitOp wait) {
  if (wait.getBarrier() != arrive.getBarrier())
    return false;
  if (!arrive.getBarrier().getDefiningOp<waveamdmachine::BarrierInitOp>())
    return false;
  if (wait.getTicket() != arrive.getTicket())
    return false;
  return hasOnlyWaitUsers(arrive.getTicket(), wait);
}

static bool needsTokenResult(waveamdmachine::BarrierArriveOp arrive,
                             waveamdmachine::BarrierWaitOp wait) {
  if (!wait.getToken().use_empty())
    return true;
  return !hasOnlyWaitUsers(arrive.getToken(), wait);
}

static FailureOr<waveamdmachine::SBarrierOp>
mergeSplitBarrier(waveamdmachine::BarrierArriveOp arrive,
                  waveamdmachine::BarrierWaitOp wait) {
  if (!isMatchingWait(arrive, wait))
    return failure();

  FailureOr<SmallVector<Value, 8>> deps = collectMergedDeps(arrive, wait);
  if (failed(deps))
    return failure();

  OpBuilder builder(arrive);
  SmallVector<Type, 1> resultTypes;
  if (needsTokenResult(arrive, wait))
    resultTypes.push_back(
        waveamdmachine::MemTokenType::get(arrive.getContext()));

  auto replacement = waveamdmachine::SBarrierOp::create(
      builder, arrive.getLoc(), resultTypes, *deps);
  replacement->setAttrs(arrive->getAttrs());
  Value barrier = arrive.getBarrier();
  if (!resultTypes.empty()) {
    Value token = replacement->getResult(0);
    arrive.getToken().replaceAllUsesWith(token);
    wait.getToken().replaceAllUsesWith(token);
  }
  wait->erase();
  arrive->erase();
  if (auto init = barrier.getDefiningOp<waveamdmachine::BarrierInitOp>())
    if (init->use_empty())
      init.erase();
  FailureOr<waveamdmachine::SBarrierOp> collapsed =
      tryCollapseWithPrevious(replacement);
  if (succeeded(collapsed))
    return collapsed;
  return replacement;
}

static FailureOr<waveamdmachine::SBarrierOp>
tryMergeSplitFrom(waveamdmachine::BarrierArriveOp arrive) {
  Operation *cursor = arrive->getNextNode();
  while (cursor && isFlatNoInst(cursor))
    cursor = cursor->getNextNode();

  auto wait = dyn_cast_or_null<waveamdmachine::BarrierWaitOp>(cursor);
  if (!wait)
    return failure();
  return mergeSplitBarrier(arrive, wait);
}

static bool collapseBlock(Block &block) {
  bool changed = false;
  Operation *op = block.empty() ? nullptr : &block.front();
  while (op) {
    if (auto first = dyn_cast<waveamdmachine::SBarrierOp>(op)) {
      FailureOr<waveamdmachine::SBarrierOp> replacement =
          tryCollapseFrom(first);
      if (succeeded(replacement)) {
        changed = true;
        op = replacement->getOperation();
        continue;
      }
      op = first->getNextNode();
    } else if (auto arrive = dyn_cast<waveamdmachine::BarrierArriveOp>(op)) {
      FailureOr<waveamdmachine::SBarrierOp> replacement =
          tryMergeSplitFrom(arrive);
      if (succeeded(replacement)) {
        changed = true;
        op = replacement->getOperation();
        continue;
      }
      op = arrive->getNextNode();
    } else {
      op = op->getNextNode();
    }
  }
  return changed;
}

struct WaveAMDBarrierCleanupPass
    : public wave::impl::WaveAMDBarrierCleanupBase<WaveAMDBarrierCleanupPass> {
  using WaveAMDBarrierCleanupBase::WaveAMDBarrierCleanupBase;

  void runOnOperation() override {
    getOperation()->walk([&](Block *block) { (void)collapseBlock(*block); });
  }
};

} // namespace
