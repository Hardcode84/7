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
#include "llvm/ADT/STLExtras.h"
#include "llvm/ADT/SmallVector.h"

#include <algorithm>
#include <array>
#include <optional>

namespace mlir::wave {
#define GEN_PASS_DEF_WAVEAMDBARRIERCLEANUP
#define GEN_PASS_DEF_WAVEAMDFINALIZEBARRIERPROTOCOLS
#include "mlir/Dialect/Wave/Transforms/Passes.h.inc"
} // namespace mlir::wave

using namespace mlir;
using namespace mlir::wave;

namespace {

namespace traits = ::mlir::OpTrait::waveamdmachine;

static constexpr StringLiteral kPairedBarriersAttr =
    "waveamdmachine.paired_barriers";
static constexpr StringLiteral kBarrierSitesAttr =
    "waveamdmachine.barrier_sites";

using BarrierSites = SmallVector<int64_t, 4>;

enum class BarrierProtocolKind : uint8_t { Full, Arrive, Wait };

struct FullBarrierPlan {
  SmallVector<Value, 8> deps;
  BarrierSites sites;
  waveamdmachine::SBarrierOp first;
  waveamdmachine::SBarrierOp second;
  bool needsResult = false;
};

struct SplitBarrierPlan {
  SmallVector<Value, 8> deps;
  BarrierSites sites;
  waveamdmachine::BarrierArriveOp arrive;
  waveamdmachine::BarrierWaitOp wait;
  bool needsResult = false;
};

struct ProtocolSiteGroup {
  BarrierSites sites;
  waveamdmachine::SBarrierOp full;
  waveamdmachine::BarrierArriveOp arrive;
  waveamdmachine::BarrierWaitOp wait;
};

static std::optional<BarrierProtocolKind> getProtocolKind(Operation *op) {
  if (isa<waveamdmachine::SBarrierOp>(op))
    return BarrierProtocolKind::Full;
  if (isa<waveamdmachine::BarrierArriveOp>(op))
    return BarrierProtocolKind::Arrive;
  if (isa<waveamdmachine::BarrierWaitOp>(op))
    return BarrierProtocolKind::Wait;
  return std::nullopt;
}

static FailureOr<BarrierSites> getBarrierSites(Operation *op) {
  DenseI64ArrayAttr attr =
      op->getAttrOfType<DenseI64ArrayAttr>(kBarrierSitesAttr);
  if (!attr || attr.empty())
    return failure();

  BarrierSites sites(attr.asArrayRef());
  if (sites.front() < 0)
    return failure();
  for (auto [left, right] :
       llvm::zip(sites, ArrayRef<int64_t>(sites).drop_front()))
    if (left >= right)
      return failure();
  return sites;
}

static FailureOr<BarrierSites> mergeBarrierSites(Operation *first,
                                                 Operation *second) {
  FailureOr<BarrierSites> firstSites = getBarrierSites(first);
  FailureOr<BarrierSites> secondSites = getBarrierSites(second);
  if (failed(firstSites) || failed(secondSites))
    return failure();

  BarrierSites merged = *firstSites;
  llvm::append_range(merged, *secondSites);
  llvm::sort(merged);
  if (std::adjacent_find(merged.begin(), merged.end()) != merged.end())
    return failure();
  return merged;
}

static void setBarrierSites(Operation *op, ArrayRef<int64_t> sites) {
  op->setAttr(kBarrierSitesAttr,
              DenseI64ArrayAttr::get(op->getContext(), sites));
}

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
  // Flattening would restore stripped completion deps.
  if (op->hasTrait<traits::CompletionFreeTokenOp>())
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

static FailureOr<FullBarrierPlan>
planFullBarrier(waveamdmachine::SBarrierOp first,
                waveamdmachine::SBarrierOp second, bool paired) {
  FailureOr<SmallVector<Value, 8>> deps = collectMergedDeps(first, second);
  if (failed(deps))
    return failure();

  FullBarrierPlan plan;
  plan.deps = std::move(*deps);
  plan.first = first;
  plan.second = second;
  plan.needsResult = needsTokenResult(first, second);
  if (paired) {
    FailureOr<BarrierSites> sites = mergeBarrierSites(first, second);
    if (failed(sites))
      return failure();
    plan.sites = std::move(*sites);
  }
  return plan;
}

static waveamdmachine::SBarrierOp applyFullBarrier(FullBarrierPlan &plan) {
  OpBuilder builder(plan.first);
  SmallVector<Type, 1> resultTypes;
  if (plan.needsResult)
    resultTypes.push_back(
        waveamdmachine::MemTokenType::get(plan.first.getContext()));

  auto replacement = waveamdmachine::SBarrierOp::create(
      builder, plan.first.getLoc(), resultTypes, plan.deps);
  replacement->setAttrs(plan.first->getAttrs());
  if (!plan.sites.empty())
    setBarrierSites(replacement, plan.sites);
  if (!resultTypes.empty()) {
    Value token = replacement->getResult(0);
    replaceResults(plan.first, token);
    replaceResults(plan.second, token);
  }
  plan.second->erase();
  plan.first->erase();
  return replacement;
}

static FailureOr<waveamdmachine::SBarrierOp>
collapseBarriers(waveamdmachine::SBarrierOp first,
                 waveamdmachine::SBarrierOp second) {
  FailureOr<FullBarrierPlan> plan = planFullBarrier(first, second, false);
  if (failed(plan))
    return failure();
  return applyFullBarrier(*plan);
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

static FailureOr<SplitBarrierPlan>
planSplitBarrier(waveamdmachine::BarrierArriveOp arrive,
                 waveamdmachine::BarrierWaitOp wait, bool paired) {
  if (!isMatchingWait(arrive, wait))
    return failure();

  FailureOr<SmallVector<Value, 8>> deps = collectMergedDeps(arrive, wait);
  if (failed(deps))
    return failure();

  SplitBarrierPlan plan;
  plan.deps = std::move(*deps);
  plan.arrive = arrive;
  plan.wait = wait;
  plan.needsResult = needsTokenResult(arrive, wait);
  if (paired) {
    FailureOr<BarrierSites> arriveSites = getBarrierSites(arrive);
    FailureOr<BarrierSites> waitSites = getBarrierSites(wait);
    if (failed(arriveSites) || failed(waitSites) || *arriveSites != *waitSites)
      return failure();
    plan.sites = std::move(*arriveSites);
  }
  return plan;
}

static waveamdmachine::SBarrierOp applySplitBarrier(SplitBarrierPlan &plan) {
  OpBuilder builder(plan.arrive);
  SmallVector<Type, 1> resultTypes;
  if (plan.needsResult)
    resultTypes.push_back(
        waveamdmachine::MemTokenType::get(plan.arrive.getContext()));

  auto replacement = waveamdmachine::SBarrierOp::create(
      builder, plan.arrive.getLoc(), resultTypes, plan.deps);
  replacement->setAttrs(plan.arrive->getAttrs());
  if (!plan.sites.empty())
    setBarrierSites(replacement, plan.sites);
  Value barrier = plan.arrive.getBarrier();
  if (!resultTypes.empty()) {
    Value token = replacement->getResult(0);
    plan.arrive.getToken().replaceAllUsesWith(token);
    plan.wait.getToken().replaceAllUsesWith(token);
  }
  plan.wait->erase();
  plan.arrive->erase();
  if (auto init = barrier.getDefiningOp<waveamdmachine::BarrierInitOp>())
    if (init->use_empty())
      init.erase();
  return replacement;
}

static FailureOr<waveamdmachine::SBarrierOp>
mergeSplitBarrier(waveamdmachine::BarrierArriveOp arrive,
                  waveamdmachine::BarrierWaitOp wait) {
  FailureOr<SplitBarrierPlan> plan = planSplitBarrier(arrive, wait, false);
  if (failed(plan))
    return failure();
  waveamdmachine::SBarrierOp replacement = applySplitBarrier(*plan);
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

static ProtocolSiteGroup *
findSiteGroup(SmallVectorImpl<ProtocolSiteGroup> &groups,
              ArrayRef<int64_t> sites) {
  for (ProtocolSiteGroup &group : groups)
    if (ArrayRef<int64_t>(group.sites) == sites)
      return &group;
  return nullptr;
}

static LogicalResult setProtocolGroupOp(ProtocolSiteGroup &group,
                                        Operation *op) {
  if (auto full = dyn_cast<waveamdmachine::SBarrierOp>(op)) {
    if (group.full)
      return failure();
    group.full = full;
    return success();
  }
  if (auto arrive = dyn_cast<waveamdmachine::BarrierArriveOp>(op)) {
    if (group.arrive)
      return failure();
    group.arrive = arrive;
    return success();
  }
  auto wait = cast<waveamdmachine::BarrierWaitOp>(op);
  if (group.wait)
    return failure();
  group.wait = wait;
  return success();
}

static LogicalResult
claimBarrierSites(Operation *op, ArrayRef<int64_t> sites,
                  llvm::SmallDenseSet<int64_t, 16> &claimedSites) {
  for (int64_t site : sites) {
    if (claimedSites.insert(site).second)
      continue;
    return op->emitError("paired barrier lineage overlaps another site");
  }
  return success();
}

static LogicalResult
addProtocolGroup(Operation *op, SmallVectorImpl<ProtocolSiteGroup> &groups,
                 llvm::SmallDenseSet<int64_t, 16> &claimedSites) {
  FailureOr<BarrierSites> sites = getBarrierSites(op);
  if (failed(sites))
    return op->emitError("paired barrier requires sorted unique site IDs");

  ProtocolSiteGroup *group = findSiteGroup(groups, *sites);
  if (!group) {
    if (failed(claimBarrierSites(op, *sites, claimedSites)))
      return failure();
    groups.push_back(ProtocolSiteGroup{});
    group = &groups.back();
    group->sites = std::move(*sites);
  }
  if (failed(setProtocolGroupOp(*group, op)))
    return op->emitError("duplicate paired barrier protocol site");
  return success();
}

static LogicalResult validateProtocolGroup(ProtocolSiteGroup &group) {
  bool full = static_cast<bool>(group.full);
  bool split = static_cast<bool>(group.arrive) && static_cast<bool>(group.wait);
  if (full != split)
    return success();

  Operation *op =
      group.full ? group.full.getOperation() : group.arrive.getOperation();
  if (!op && group.wait)
    op = group.wait;
  return op->emitError("paired barrier site must be full or arrive/wait");
}

static FailureOr<SmallVector<ProtocolSiteGroup, 8>>
collectProtocolGroups(Region &region) {
  SmallVector<ProtocolSiteGroup, 8> groups;
  llvm::SmallDenseSet<int64_t, 16> claimedSites;
  WalkResult walk = region.walk([&](Operation *op) {
    if (!getProtocolKind(op))
      return WalkResult::advance();
    if (failed(addProtocolGroup(op, groups, claimedSites)))
      return WalkResult::interrupt();
    return WalkResult::advance();
  });
  if (walk.wasInterrupted())
    return failure();

  for (ProtocolSiteGroup &group : groups)
    if (failed(validateProtocolGroup(group)))
      return failure();
  return groups;
}

static LogicalResult
compareSplitHandles(SmallVectorImpl<ProtocolSiteGroup> &left,
                    SmallVectorImpl<ProtocolSiteGroup> &right,
                    waveamdmachine::UniformIfOp owner) {
  for (ProtocolSiteGroup &leftGroup : left) {
    if (!leftGroup.arrive)
      continue;
    ProtocolSiteGroup *rightGroup = findSiteGroup(right, leftGroup.sites);
    if (!rightGroup || !rightGroup->arrive ||
        leftGroup.arrive.getBarrier() != rightGroup->arrive.getBarrier())
      return owner.emitOpError("split barrier handles differ between arms");
  }
  return success();
}

static bool containsProtocol(Operation &op) {
  for (Region &region : op.getRegions()) {
    WalkResult walk = region.walk([&](Operation *nested) {
      return getProtocolKind(nested) ? WalkResult::interrupt()
                                     : WalkResult::advance();
    });
    if (walk.wasInterrupted())
      return true;
  }
  return false;
}

static SmallVector<Operation *, 8> collectProtocolItems(Block &block) {
  SmallVector<Operation *, 8> items;
  for (Operation &op : block)
    if (getProtocolKind(&op) || containsProtocol(op))
      items.push_back(&op);
  return items;
}

static LogicalResult compareProtocolRegions(Region &left, Region &right,
                                            waveamdmachine::UniformIfOp owner);

static LogicalResult
compareBarrierProtocolOps(Operation *left, Operation *right,
                          BarrierProtocolKind leftKind,
                          std::optional<BarrierProtocolKind> rightKind,
                          waveamdmachine::UniformIfOp owner) {
  FailureOr<BarrierSites> leftSites = getBarrierSites(left);
  FailureOr<BarrierSites> rightSites = getBarrierSites(right);
  if (!rightKind || failed(leftSites) || failed(rightSites) ||
      leftKind != *rightKind || *leftSites != *rightSites)
    return owner.emitOpError("barrier protocols differ between arms");
  return success();
}

static LogicalResult
compareStructuredProtocolOps(Operation *left, Operation *right,
                             waveamdmachine::UniformIfOp owner) {
  if (left->getName() != right->getName() ||
      left->getNumRegions() != right->getNumRegions())
    return owner.emitOpError("barrier region structure differs between arms");
  for (auto [leftRegion, rightRegion] :
       llvm::zip(left->getRegions(), right->getRegions()))
    if (failed(compareProtocolRegions(leftRegion, rightRegion, owner)))
      return failure();
  return success();
}

static LogicalResult compareProtocolOps(Operation *left, Operation *right,
                                        waveamdmachine::UniformIfOp owner) {
  std::optional<BarrierProtocolKind> leftKind = getProtocolKind(left);
  std::optional<BarrierProtocolKind> rightKind = getProtocolKind(right);
  if (!leftKind && rightKind)
    return owner.emitOpError("barrier region structure differs between arms");
  if (leftKind)
    return compareBarrierProtocolOps(left, right, *leftKind, rightKind, owner);
  return compareStructuredProtocolOps(left, right, owner);
}

static LogicalResult compareProtocolBlocks(Block &left, Block &right,
                                           waveamdmachine::UniformIfOp owner) {
  SmallVector<Operation *, 8> leftItems = collectProtocolItems(left);
  SmallVector<Operation *, 8> rightItems = collectProtocolItems(right);
  if (leftItems.size() != rightItems.size())
    return owner.emitOpError("barrier protocols differ between arms");
  for (auto [leftOp, rightOp] : llvm::zip(leftItems, rightItems))
    if (failed(compareProtocolOps(leftOp, rightOp, owner)))
      return failure();
  return success();
}

static LogicalResult compareProtocolRegions(Region &left, Region &right,
                                            waveamdmachine::UniformIfOp owner) {
  if (left.getBlocks().size() != right.getBlocks().size())
    return owner.emitOpError("barrier region structure differs between arms");
  for (auto [leftBlock, rightBlock] :
       llvm::zip(left.getBlocks(), right.getBlocks()))
    if (failed(compareProtocolBlocks(leftBlock, rightBlock, owner)))
      return failure();
  return success();
}

static LogicalResult validatePairedIf(waveamdmachine::UniformIfOp op) {
  if (op.getElseRegion().empty())
    return op.emitOpError("paired barriers require an else arm");

  bool nested = false;
  for (Region *region : {&op.getThenRegion(), &op.getElseRegion()})
    region->walk([&](waveamdmachine::UniformIfOp child) {
      nested |= child->hasAttr(kPairedBarriersAttr);
    });
  if (nested)
    return op.emitOpError("nested paired barrier conditionals unsupported");

  FailureOr<SmallVector<ProtocolSiteGroup, 8>> thenGroups =
      collectProtocolGroups(op.getThenRegion());
  FailureOr<SmallVector<ProtocolSiteGroup, 8>> elseGroups =
      collectProtocolGroups(op.getElseRegion());
  if (failed(thenGroups) || failed(elseGroups))
    return failure();
  if (failed(compareSplitHandles(*thenGroups, *elseGroups, op)))
    return failure();
  return compareProtocolRegions(op.getThenRegion(), op.getElseRegion(), op);
}

static waveamdmachine::SBarrierOp
getFollowingFullBarrier(waveamdmachine::SBarrierOp first) {
  Operation *cursor = first->getNextNode();
  while (cursor && isFlatNoInst(cursor))
    cursor = cursor->getNextNode();
  return dyn_cast_or_null<waveamdmachine::SBarrierOp>(cursor);
}

static waveamdmachine::BarrierWaitOp
getFollowingBarrierWait(waveamdmachine::BarrierArriveOp arrive) {
  Operation *cursor = arrive->getNextNode();
  while (cursor && isFlatNoInst(cursor))
    cursor = cursor->getNextNode();
  return dyn_cast_or_null<waveamdmachine::BarrierWaitOp>(cursor);
}

static FailureOr<std::optional<FullBarrierPlan>>
planPairedFullForArm(Region &arm, ArrayRef<int64_t> firstSites,
                     ArrayRef<int64_t> secondSites) {
  FailureOr<SmallVector<ProtocolSiteGroup, 8>> groups =
      collectProtocolGroups(arm);
  if (failed(groups))
    return failure();

  ProtocolSiteGroup *first = findSiteGroup(*groups, firstSites);
  ProtocolSiteGroup *second = findSiteGroup(*groups, secondSites);
  if (!first || !second || !first->full || !second->full ||
      getFollowingFullBarrier(first->full) != second->full)
    return std::optional<FullBarrierPlan>{};

  FailureOr<FullBarrierPlan> plan =
      planFullBarrier(first->full, second->full, true);
  if (failed(plan))
    return std::optional<FullBarrierPlan>{};
  return std::optional<FullBarrierPlan>{std::move(*plan)};
}

static FailureOr<bool> tryApplyPairedFull(waveamdmachine::SBarrierOp reference,
                                          std::array<Region *, 2> arms) {
  waveamdmachine::SBarrierOp referenceSecond =
      getFollowingFullBarrier(reference);
  if (!referenceSecond)
    return false;
  FailureOr<BarrierSites> firstSites = getBarrierSites(reference);
  FailureOr<BarrierSites> secondSites = getBarrierSites(referenceSecond);
  if (failed(firstSites) || failed(secondSites))
    return failure();

  SmallVector<FullBarrierPlan, 2> plans;
  for (Region *arm : arms) {
    FailureOr<std::optional<FullBarrierPlan>> plan =
        planPairedFullForArm(*arm, *firstSites, *secondSites);
    if (failed(plan))
      return failure();
    if (!*plan)
      return false;
    plans.push_back(std::move(**plan));
  }
  for (FullBarrierPlan &plan : plans)
    (void)applyFullBarrier(plan);
  return true;
}

static FailureOr<std::optional<SplitBarrierPlan>>
planPairedSplitForArm(Region &arm, ArrayRef<int64_t> sites) {
  FailureOr<SmallVector<ProtocolSiteGroup, 8>> groups =
      collectProtocolGroups(arm);
  if (failed(groups))
    return failure();

  ProtocolSiteGroup *group = findSiteGroup(*groups, sites);
  if (!group || !group->arrive || !group->wait ||
      getFollowingBarrierWait(group->arrive) != group->wait)
    return std::optional<SplitBarrierPlan>{};

  FailureOr<SplitBarrierPlan> plan =
      planSplitBarrier(group->arrive, group->wait, true);
  if (failed(plan))
    return std::optional<SplitBarrierPlan>{};
  return std::optional<SplitBarrierPlan>{std::move(*plan)};
}

static FailureOr<bool>
tryApplyPairedSplit(waveamdmachine::BarrierArriveOp reference,
                    std::array<Region *, 2> arms) {
  waveamdmachine::BarrierWaitOp referenceWait =
      getFollowingBarrierWait(reference);
  if (!referenceWait)
    return false;
  FailureOr<BarrierSites> sites = getBarrierSites(reference);
  if (failed(sites))
    return failure();

  SmallVector<SplitBarrierPlan, 2> plans;
  for (Region *arm : arms) {
    FailureOr<std::optional<SplitBarrierPlan>> plan =
        planPairedSplitForArm(*arm, *sites);
    if (failed(plan))
      return failure();
    if (!*plan)
      return false;
    plans.push_back(std::move(**plan));
  }
  for (SplitBarrierPlan &plan : plans)
    (void)applySplitBarrier(plan);
  return true;
}

static FailureOr<bool> tryApplyPairedRewrite(waveamdmachine::UniformIfOp op) {
  SmallVector<Operation *, 16> protocolOps;
  op.getThenRegion().walk([&](Operation *candidate) {
    if (getProtocolKind(candidate))
      protocolOps.push_back(candidate);
  });
  std::array<Region *, 2> arms = {&op.getThenRegion(), &op.getElseRegion()};
  for (Operation *candidate : protocolOps) {
    FailureOr<bool> changed = false;
    if (auto full = dyn_cast<waveamdmachine::SBarrierOp>(candidate))
      changed = tryApplyPairedFull(full, arms);
    else if (auto arrive = dyn_cast<waveamdmachine::BarrierArriveOp>(candidate))
      changed = tryApplyPairedSplit(arrive, arms);
    if (failed(changed) || *changed)
      return changed;
  }
  return false;
}

static LogicalResult cleanupPairedIf(waveamdmachine::UniformIfOp op) {
  while (true) {
    FailureOr<bool> changed = tryApplyPairedRewrite(op);
    if (failed(changed))
      return failure();
    if (!*changed)
      return success();
  }
}

static bool isInsidePairedIf(Block *block) {
  for (Operation *parent = block->getParentOp(); parent;
       parent = parent->getParentOp())
    if (auto op = dyn_cast<waveamdmachine::UniformIfOp>(parent))
      if (op->hasAttr(kPairedBarriersAttr))
        return true;
  return false;
}

static LogicalResult validateProtocolAttrPlacement(Operation *op) {
  Attribute marker = op->getAttr(kPairedBarriersAttr);
  if (marker &&
      (!isa<waveamdmachine::UniformIfOp>(op) || !isa<UnitAttr>(marker)))
    return op->emitError("paired barrier marker requires a unit uniform_if");
  if (!op->hasAttr(kBarrierSitesAttr))
    return success();
  if (!getProtocolKind(op))
    return op->emitError("barrier lineage requires a barrier protocol op");
  if (!isInsidePairedIf(op->getBlock()))
    return op->emitError("barrier lineage requires a paired uniform_if");
  return success();
}

static LogicalResult validateProtocolAttrs(Operation *root) {
  WalkResult walk = root->walk([&](Operation *op) {
    return failed(validateProtocolAttrPlacement(op)) ? WalkResult::interrupt()
                                                     : WalkResult::advance();
  });
  return failure(walk.wasInterrupted());
}

static SmallVector<waveamdmachine::UniformIfOp, 4>
collectPairedIfs(Operation *root) {
  SmallVector<waveamdmachine::UniformIfOp, 4> paired;
  root->walk([&](waveamdmachine::UniformIfOp op) {
    if (op->hasAttr(kPairedBarriersAttr))
      paired.push_back(op);
  });
  return paired;
}

static void stripPairedProtocol(waveamdmachine::UniformIfOp op) {
  for (Region *region : {&op.getThenRegion(), &op.getElseRegion()})
    region->walk([&](Operation *nested) {
      if (getProtocolKind(nested))
        nested->removeAttr(kBarrierSitesAttr);
    });
  op->removeAttr(kPairedBarriersAttr);
}

static LogicalResult
validatePairedIfs(ArrayRef<waveamdmachine::UniformIfOp> paired) {
  for (waveamdmachine::UniformIfOp op : paired)
    if (failed(validatePairedIf(op)))
      return failure();
  return success();
}

static LogicalResult
cleanupPairedIfs(ArrayRef<waveamdmachine::UniformIfOp> paired) {
  for (waveamdmachine::UniformIfOp op : paired)
    if (failed(cleanupPairedIf(op)))
      return failure();
  return success();
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
    Operation *root = getOperation();
    SmallVector<waveamdmachine::UniformIfOp, 4> paired = collectPairedIfs(root);
    if (failed(validateProtocolAttrs(root)) ||
        failed(validatePairedIfs(paired)) || failed(cleanupPairedIfs(paired)))
      return signalPassFailure();
    root->walk([&](Block *block) {
      if (!isInsidePairedIf(block))
        (void)collapseBlock(*block);
    });
    if (failed(validatePairedIfs(paired)))
      return signalPassFailure();
  }
};

struct WaveAMDFinalizeBarrierProtocolsPass
    : public wave::impl::WaveAMDFinalizeBarrierProtocolsBase<
          WaveAMDFinalizeBarrierProtocolsPass> {
  using WaveAMDFinalizeBarrierProtocolsBase::
      WaveAMDFinalizeBarrierProtocolsBase;

  void runOnOperation() override {
    Operation *root = getOperation();
    SmallVector<waveamdmachine::UniformIfOp, 4> paired = collectPairedIfs(root);
    if (failed(validateProtocolAttrs(root)) ||
        failed(validatePairedIfs(paired)))
      return signalPassFailure();
    for (waveamdmachine::UniformIfOp op : paired)
      stripPairedProtocol(op);
  }
};

} // namespace
