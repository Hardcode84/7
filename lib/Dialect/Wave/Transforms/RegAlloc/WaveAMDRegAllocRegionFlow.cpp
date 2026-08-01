//===- WaveAMDRegAllocRegionFlow.cpp - Region control flow ---------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "WaveAMDRegAllocRegionFlow.h"

#include "llvm/ADT/STLExtras.h"

#include <algorithm>
#include <limits>
#include <optional>

using namespace mlir;
using namespace mlir::wave::regalloc_detail;

RegAllocRegionFlow::RegAllocRegionFlow(Operation *root) { collect(root); }

void RegAllocRegionFlow::collect(Operation *root) {
  root->walk<WalkOrder::PreOrder>([&](Operation *op) {
    if (op->getNumRegions() == 0)
      return;
    if (auto branch = dyn_cast<RegionBranchOpInterface>(op))
      buildBranch(branch);
  });
}

void RegAllocRegionFlow::buildBranch(RegionBranchOpInterface branchOp) {
  Operation *op = branchOp.getOperation();
  unsigned branchId = branches.size();
  Branch branch;
  branch.op = op;
  branch.regions.reserve(op->getNumRegions());
  for (auto [index, region] : llvm::enumerate(op->getRegions())) {
    branch.regions.push_back(&region);
    regionLocations[&region] = {branchId, static_cast<unsigned>(index)};
  }

  unsigned regionCount = branch.regions.size();
  branch.entryRegions.resize(regionCount);
  branch.repetitiveRegions.resize(regionCount);
  branch.reachable.reserve(regionCount);
  for (unsigned i = 0; i < regionCount; ++i)
    branch.reachable.emplace_back(regionCount);

  SmallVector<RegionSuccessor, 4> successors;
  for (RegionBranchPoint point : branchOp.getAllRegionBranchPoints()) {
    successors.clear();
    branchOp.getSuccessorRegions(point, successors);
    Region *source = nullptr;
    Operation *sourceOperation = op;
    if (!point.isParent()) {
      RegionBranchTerminatorOpInterface term =
          point.getTerminatorPredecessorOrNull();
      source = term->getParentRegion();
      sourceOperation = term.getOperation();
    }

    for (RegionSuccessor successor : successors) {
      Region *target =
          successor.isRegion() ? successor.getSuccessor() : nullptr;
      if (point.isParent() && target)
        branch.entryRegions.set(target->getRegionNumber());
      if (source && target)
        branch.reachable[source->getRegionNumber()].set(
            target->getRegionNumber());

      OperandRange operands = branchOp.getSuccessorOperands(point, successor);
      ValueRange inputs = branchOp.getSuccessorInputs(successor);
      assert(operands.size() == inputs.size() &&
             "RegionBranch successor arity mismatch");
      MutableArrayRef<OpOperand> opOperands(operands.getBase(),
                                            operands.size());
      unsigned firstTransfer = branch.transfers.size();
      for (auto [index, values] :
           llvm::enumerate(llvm::zip_equal(opOperands, inputs))) {
        auto [operand, input] = values;
        branch.transfers.push_back({&operand, input, source, target,
                                    sourceOperation,
                                    static_cast<unsigned>(index)});
      }
      if (branch.transfers.size() != firstTransfer)
        branch.transferGroups.push_back(
            {sourceOperation, source, target, firstTransfer,
             static_cast<unsigned>(branch.transfers.size() - firstTransfer)});
    }
  }

  // Region counts are normally tiny.  Closing this matrix once avoids a DFS
  // for every SSA use during preparation and live-range construction.
  for (unsigned via = 0; via < regionCount; ++via)
    for (unsigned source = 0; source < regionCount; ++source)
      if (branch.reachable[source].test(via))
        branch.reachable[source] |= branch.reachable[via];
  for (unsigned i = 0; i < regionCount; ++i)
    branch.repetitiveRegions[i] = branch.reachable[i].test(i);
  for (unsigned lhs : branch.entryRegions.set_bits()) {
    if (branch.repetitiveRegions.test(lhs))
      continue;
    for (unsigned rhs : branch.entryRegions.set_bits()) {
      if (lhs == rhs || branch.repetitiveRegions.test(rhs))
        continue;
      if (!branch.reachable[lhs].test(rhs) &&
          !branch.reachable[rhs].test(lhs)) {
        exclusiveRegions.insert(branch.regions[lhs]);
        break;
      }
    }
  }
  for (const Transfer &transfer : branch.transfers)
    if (transfer.target &&
        branch.repetitiveRegions.test(transfer.target->getRegionNumber())) {
      repetitiveTransferOperands.insert(transfer.operand);
      repetitiveTransferInputs.insert(transfer.input);
    }
  classifyRepetitiveInputTransfers(branch);

  branchIds[op] = branchId;
  branches.push_back(std::move(branch));
}

void RegAllocRegionFlow::classifyRepetitiveInputTransfers(Branch &branch) {
  DenseMap<Value, unsigned> inputIds;
  for (const Transfer &transfer : branch.transfers)
    if (transfer.target &&
        branch.repetitiveRegions.test(transfer.target->getRegionNumber()))
      inputIds.try_emplace(transfer.input, inputIds.size());

  SmallVector<unsigned> parents(inputIds.size());
  SmallVector<std::optional<unsigned>> entrySlots(inputIds.size());
  for (unsigned id = 0; id < parents.size(); ++id)
    parents[id] = id;
  for (const Transfer &transfer : branch.transfers)
    if (!transfer.source && transfer.target &&
        branch.repetitiveRegions.test(transfer.target->getRegionNumber())) {
      unsigned id = inputIds.lookup(transfer.input);
      entrySlots[id] = id;
    }

  auto findRoot = [&](unsigned id) {
    while (parents[id] != id) {
      parents[id] = parents[parents[id]];
      id = parents[id];
    }
    return id;
  };

  for (Transfer &transfer : branch.transfers) {
    if (!transfer.source || !transfer.target ||
        !branch.repetitiveRegions.test(transfer.target->getRegionNumber()) ||
        !branch.reachable[transfer.target->getRegionNumber()].test(
            transfer.source->getRegionNumber()))
      continue;
    auto sourceIt = inputIds.find(transfer.operand->get());
    auto targetIt = inputIds.find(transfer.input);
    if (sourceIt == inputIds.end() || targetIt == inputIds.end())
      continue;
    unsigned sourceRoot = findRoot(sourceIt->second);
    unsigned targetRoot = findRoot(targetIt->second);
    if (sourceRoot == targetRoot) {
      transfer.repetitiveInputRelation = RepetitiveInputRelation::SameSlot;
      continue;
    }
    if (entrySlots[sourceRoot] && entrySlots[targetRoot] &&
        entrySlots[sourceRoot] != entrySlots[targetRoot]) {
      transfer.repetitiveInputRelation =
          RepetitiveInputRelation::DifferentSlots;
      continue;
    }
    parents[targetRoot] = sourceRoot;
    if (!entrySlots[sourceRoot])
      entrySlots[sourceRoot] = entrySlots[targetRoot];
    transfer.repetitiveInputRelation = RepetitiveInputRelation::SameSlot;
  }
}

const RegAllocRegionFlow::Branch *
RegAllocRegionFlow::lookup(Operation *op) const {
  if (op->getNumRegions() == 0)
    return nullptr;
  auto it = branchIds.find(op);
  return it == branchIds.end() ? nullptr : &branches[it->second];
}

ArrayRef<RegAllocRegionFlow::Transfer>
RegAllocRegionFlow::getTransfers(Operation *op) const {
  const Branch *branch = lookup(op);
  return branch ? ArrayRef<Transfer>(branch->transfers) : ArrayRef<Transfer>();
}

RegAllocRegionFlow::TransferKind
RegAllocRegionFlow::getTransferKind(const Transfer &transfer) const {
  if (!transfer.source && transfer.target && isRepetitive(transfer.target))
    return TransferKind::RepetitiveEntry;
  if (transfer.source && transfer.target &&
      mayReach(transfer.target, transfer.source))
    return TransferKind::Cyclic;
  if (transfer.target)
    return TransferKind::Forward;
  return TransferKind::Exit;
}

SmallVector<RegAllocRegionFlow::Alias, 8>
RegAllocRegionFlow::getAliasForest(Operation *op) const {
  const Branch *branch = lookup(op);
  if (!branch)
    return {};

  // Process entry and cyclic transfers before exits.  Besides making the
  // result deterministic, this gives a repeated component the same natural
  // anchor as its carried storage: parent entry, cyclic definitions, then the
  // joined result.  A non-repeated component is instead anchored at its parent
  // result, matching the structural join.
  SmallVector<const Transfer *, 8> ordered;
  for (unsigned wanted = 0; wanted != 4; ++wanted)
    for (const Transfer &transfer : branch->transfers)
      if (static_cast<unsigned>(getTransferKind(transfer)) == wanted)
        ordered.push_back(&transfer);

  DenseMap<Value, unsigned> ids;
  auto getId = [&](Value value) {
    auto [it, inserted] = ids.try_emplace(value, ids.size());
    return it->second;
  };
  for (const Transfer *transfer : ordered) {
    (void)getId(transfer->operand->get());
    (void)getId(transfer->input);
  }

  SmallVector<unsigned> parents(ids.size());
  for (unsigned id = 0; id != parents.size(); ++id)
    parents[id] = id;
  auto findRoot = [&](unsigned id) {
    while (parents[id] != id) {
      parents[id] = parents[parents[id]];
      id = parents[id];
    }
    return id;
  };
  for (const Transfer *transfer : ordered) {
    unsigned lhs = findRoot(ids.lookup(transfer->operand->get()));
    unsigned rhs = findRoot(ids.lookup(transfer->input));
    if (lhs != rhs)
      parents[rhs] = lhs;
  }

  struct PreferredRoot {
    unsigned priority = std::numeric_limits<unsigned>::max();
    Value value;
  };
  DenseMap<unsigned, PreferredRoot> preferred;
  bool repetitive = branch->repetitiveRegions.any();
  auto consider = [&](Value value, unsigned priority) {
    unsigned component = findRoot(ids.lookup(value));
    PreferredRoot &candidate = preferred[component];
    if (!candidate.value || priority < candidate.priority)
      candidate = {priority, value};
  };
  for (const Transfer *transfer : ordered) {
    Value source = transfer->operand->get();
    if (repetitive) {
      bool repeatedEntry = !transfer->source && transfer->target &&
                           isRepetitive(transfer->target);
      consider(source, repeatedEntry ? 0u : 3u);
      consider(transfer->input, repeatedEntry ? 1u : 3u);
    } else {
      bool parentResult = !transfer->target;
      consider(source, 2u);
      consider(transfer->input, parentResult ? 0u : 1u);
    }
  }

  SmallVector<Alias, 8> aliases;
  DenseSet<Value> emitted;
  // Keep joined results ahead of cyclic definitions in the serialized alias
  // set.  This is the stable logical-slot order used by the allocator; clients
  // that care about execution positions may sort by TransferKind instead.
  for (unsigned wanted : {0u, 3u, 1u, 2u})
    for (const Transfer *transfer : ordered) {
      TransferKind transferKind = getTransferKind(*transfer);
      if (static_cast<unsigned>(transferKind) != wanted)
        continue;
      for (Value value : {transfer->operand->get(), transfer->input}) {
        unsigned component = findRoot(ids.lookup(value));
        Value root = preferred.lookup(component).value;
        if (value == root || !emitted.insert(value).second)
          continue;
        aliases.push_back({root, value, transfer, transferKind});
      }
    }
  return aliases;
}

void RegAllocRegionFlow::appendOrderedAliasEdges(
    Operation *op, SmallVectorImpl<OrderedAliasEdge> &edges) const {
  const Branch *branch = lookup(op);
  if (!branch)
    return;

  // Acyclic branches have no repeated logical slots.  Preserve structural
  // region/result order and orient exits from the join result to the yielded
  // value, which gives the alias graph a stable result-rooted traversal.
  if (branch->repetitiveRegions.none()) {
    for (const Transfer &transfer : branch->transfers) {
      Value source = transfer.operand->get();
      edges.push_back(transfer.target
                          ? OrderedAliasEdge{source, transfer.input, &transfer,
                                             getTransferKind(transfer)}
                          : OrderedAliasEdge{transfer.input, source, &transfer,
                                             getTransferKind(transfer)});
    }
    return;
  }

  // A single repetitive region is the dominant machine-IR shape.  Successor
  // input ordinals already identify its logical slots, so build the historical
  // result/entry/cycle order directly and avoid allocating a value graph.
  if (branch->regions.size() == 1 && branch->repetitiveRegions.test(0)) {
    Region *region = branch->regions.front();
    unsigned slotCount = 0;
    for (const Transfer &transfer : branch->transfers)
      slotCount = std::max(slotCount, transfer.successorInputIndex + 1);
    SmallVector<const Transfer *, 8> entries(slotCount);
    SmallVector<const Transfer *, 8> results(slotCount);
    SmallVector<const Transfer *, 8> cycles;
    bool supported = true;
    for (const Transfer &transfer : branch->transfers) {
      unsigned index = transfer.successorInputIndex;
      if (!transfer.source && transfer.target == region) {
        if (entries[index])
          supported = false;
        entries[index] = &transfer;
      } else if (transfer.source == region && transfer.target == region) {
        cycles.push_back(&transfer);
      } else if (!transfer.target) {
        if (!results[index])
          results[index] = &transfer;
      } else {
        supported = false;
      }
    }
    if (supported &&
        llvm::all_of(
            entries,
            [](const Transfer *transfer) { return transfer != nullptr; }) &&
        llvm::all_of(results, [](const Transfer *transfer) {
          return transfer != nullptr;
        })) {
      edges.reserve(entries.size() * 2 + cycles.size());
      DenseSet<Value> seenEntrySources;
      for (auto [entry, result] : llvm::zip_equal(entries, results)) {
        Value slot = entry->input;
        edges.push_back(
            {slot, result->input, result, getTransferKind(*result)});
        Value source = entry->operand->get();
        if (seenEntrySources.insert(source).second)
          edges.push_back({source, slot, entry, getTransferKind(*entry)});
      }
      for (const Transfer *cycle : cycles)
        edges.push_back({entries[cycle->successorInputIndex]->input,
                         cycle->operand->get(), cycle,
                         getTransferKind(*cycle)});
      return;
    }
  }

  SmallVector<Alias, 8> forest = getAliasForest(op);
  DenseMap<Value, Value> componentRoots;
  for (const Alias &alias : forest) {
    componentRoots.try_emplace(alias.primary, alias.primary);
    componentRoots[alias.extra] = alias.primary;
  }
  auto getRoot = [&](Value value) {
    auto it = componentRoots.find(value);
    return it == componentRoots.end() ? value : it->second;
  };

  DenseMap<Value, Value> slots;
  for (const Transfer &transfer : branch->transfers)
    if (!transfer.source && transfer.target && isRepetitive(transfer.target))
      slots.try_emplace(getRoot(transfer.input), transfer.input);
  for (const Transfer &transfer : branch->transfers)
    if (transfer.source && transfer.target &&
        mayReach(transfer.target, transfer.source))
      slots.try_emplace(getRoot(transfer.input), transfer.input);

  DenseMap<Value, SmallVector<const Transfer *, 2>> results;
  DenseSet<Value> seenResults;
  for (const Transfer &transfer : branch->transfers)
    if (!transfer.target && seenResults.insert(transfer.input).second)
      results[getRoot(transfer.input)].push_back(&transfer);

  DenseSet<Value> emitted;
  DenseSet<Value> emittedResultComponents;
  DenseSet<Value> seenEntrySources;
  for (const Transfer &transfer : branch->transfers) {
    if (transfer.source || !transfer.target || !isRepetitive(transfer.target))
      continue;
    Value input = transfer.input;
    Value root = getRoot(input);
    Value slot = slots.lookup(root);
    if (emittedResultComponents.insert(root).second)
      for (const Transfer *result : results.lookup(root)) {
        edges.push_back(
            {slot, result->input, result, getTransferKind(*result)});
        emitted.insert(result->input);
      }
    Value source = transfer.operand->get();
    if (seenEntrySources.insert(source).second)
      edges.push_back({source, input, &transfer, getTransferKind(transfer)});
    if (input != slot && emitted.insert(input).second)
      edges.push_back({slot, input, &transfer, getTransferKind(transfer)});
    emitted.insert(source);
    emitted.insert(input);
  }

  // Cyclic definitions are appended after entry/result aliases.  Keep every
  // structural cyclic edge, including pass-throughs and values already seen at
  // entry: these edges have no additional graph effect, but preserve stable
  // logical-slot accounting and traversal order.
  for (const Transfer &transfer : branch->transfers) {
    if (!transfer.source || !transfer.target ||
        !mayReach(transfer.target, transfer.source))
      continue;
    Value root = getRoot(transfer.input);
    Value slot = slots.lookup(root);
    Value input = transfer.input;
    if (input != slot && emitted.insert(input).second)
      edges.push_back({slot, input, &transfer, getTransferKind(transfer)});
    Value source = transfer.operand->get();
    edges.push_back({slot, source, &transfer, getTransferKind(transfer)});
    emitted.insert(source);
  }

  // Cover uncommon multi-region forwards and exits that introduce additional
  // values in an already established repeated component.
  for (const Transfer &transfer : branch->transfers) {
    for (Value value : {transfer.operand->get(), transfer.input}) {
      if (!emitted.insert(value).second)
        continue;
      Value slot = slots.lookup(getRoot(value));
      if (slot && value != slot)
        edges.push_back({slot, value, &transfer, getTransferKind(transfer)});
    }
  }
}

bool RegAllocRegionFlow::isRepetitive(Region *region) const {
  auto it = regionLocations.find(region);
  if (it == regionLocations.end())
    return false;
  const RegionLocation &location = it->second;
  return branches[location.branch].repetitiveRegions.test(location.region);
}

bool RegAllocRegionFlow::feedsRepetitiveTransfer(Value value) const {
  if (repetitiveTransferInputs.contains(value))
    return true;
  return llvm::any_of(value.getUses(), [&](OpOperand &use) {
    return repetitiveTransferOperands.contains(&use);
  });
}

bool RegAllocRegionFlow::mayReach(Region *source, Region *target) const {
  if (!source || !target)
    return false;
  auto sourceIt = regionLocations.find(source);
  auto targetIt = regionLocations.find(target);
  if (sourceIt == regionLocations.end() || targetIt == regionLocations.end() ||
      sourceIt->second.branch != targetIt->second.branch)
    return false;
  return branches[sourceIt->second.branch]
      .reachable[sourceIt->second.region]
      .test(targetIt->second.region);
}

bool RegAllocRegionFlow::areMutuallyExclusive(Region *lhs, Region *rhs) const {
  if (!lhs || !rhs || lhs == rhs)
    return false;
  auto lhsIt = regionLocations.find(lhs);
  auto rhsIt = regionLocations.find(rhs);
  if (lhsIt == regionLocations.end() || rhsIt == regionLocations.end() ||
      lhsIt->second.branch != rhsIt->second.branch)
    return false;
  const Branch &branch = branches[lhsIt->second.branch];
  if (!branch.entryRegions.test(lhsIt->second.region) ||
      !branch.entryRegions.test(rhsIt->second.region))
    return false;
  return !mayReach(lhs, rhs) && !mayReach(rhs, lhs);
}

bool RegAllocRegionFlow::isExclusiveChoice(Region *region) const {
  return exclusiveRegions.contains(region);
}

bool RegAllocRegionFlow::resultsStartAtJoin(Operation *op) const {
  const Branch *branch = lookup(op);
  if (!branch || branch->regions.empty())
    return false;
  if (branch->repetitiveRegions.any())
    return true;
  return llvm::any_of(branch->regions, [&](Region *region) {
    return exclusiveRegions.contains(region);
  });
}

Region *RegAllocRegionFlow::getEnclosingRepetitiveRegion(Operation *op) const {
  while (Region *region = op->getParentRegion()) {
    if (isRepetitive(region))
      return region;
    op = region->getParentOp();
  }
  return nullptr;
}

Region *RegAllocRegionFlow::getEnclosingRepetitiveRegion(Value value) const {
  Region *region = value.getParentRegion();
  while (region) {
    if (isRepetitive(region))
      return region;
    region = region->getParentOp()->getParentRegion();
  }
  return nullptr;
}

bool RegAllocRegionFlow::isOperationInside(Operation *scope, Operation *op) {
  for (Operation *current = op; current; current = current->getParentOp())
    if (current == scope)
      return true;
  return false;
}

bool RegAllocRegionFlow::isDefinedInside(Operation *scope, Value value) {
  if (Operation *def = value.getDefiningOp())
    return isOperationInside(scope, def);
  auto argument = cast<BlockArgument>(value);
  Operation *owner = argument.getOwner()->getParentOp();
  return owner && isOperationInside(scope, owner);
}

Region *RegAllocRegionFlow::getChildRegion(Operation *parent,
                                           Operation *nested) {
  for (Region *region = nested->getParentRegion(); region;) {
    Operation *owner = region->getParentOp();
    if (owner == parent)
      return region;
    region = owner ? owner->getParentRegion() : nullptr;
  }
  return nullptr;
}

bool RegAllocRegionFlow::useCannotFollow(Operation *from,
                                         Operation *user) const {
  for (Operation *parent = from->getParentOp(); parent;
       parent = parent->getParentOp()) {
    if (!lookup(parent))
      continue;
    Region *fromRegion = getChildRegion(parent, from);
    Region *useRegion = getChildRegion(parent, user);
    if (fromRegion && useRegion && fromRegion != useRegion &&
        !mayReach(fromRegion, useRegion))
      return true;
  }
  return false;
}

bool RegAllocRegionFlow::useMayFollowThroughRepetition(Value value,
                                                       Operation *from,
                                                       Operation *user) const {
  for (Operation *parent = from->getParentOp(); parent;
       parent = parent->getParentOp()) {
    Region *fromRegion = getChildRegion(parent, from);
    if (fromRegion && isRepetitive(fromRegion) &&
        !isDefinedInside(parent, value) && user != parent &&
        isOperationInside(parent, user))
      return true;
  }
  return false;
}

static Operation *ancestorInBlock(Operation *op, Block *block) {
  while (op && op->getBlock() != block)
    op = op->getParentOp();
  return op;
}

bool RegAllocRegionFlow::useMayFollow(Value value, Operation *from,
                                      Operation *user) const {
  if (from == user)
    return false;
  if (useMayFollowThroughRepetition(value, from, user))
    return true;
  if (useCannotFollow(from, user))
    return false;
  for (Operation *fromTop = from; fromTop; fromTop = fromTop->getParentOp()) {
    Operation *userTop = ancestorInBlock(user, fromTop->getBlock());
    if (!userTop)
      continue;
    if (fromTop == userTop)
      return true;
    return fromTop->isBeforeInBlock(userTop);
  }
  return true;
}
