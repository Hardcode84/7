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
  unsigned branchId = branches.size();
  Branch branch;
  initializeBranch(branchOp, branchId, branch);
  collectTransfers(branchOp, branch);
  closeReachability(branch);
  classifyRegions(branch);
  recordRepetitiveTransfers(branch);
  classifyRepetitiveInputTransfers(branch);

  branchIds[branch.op] = branchId;
  branches.push_back(std::move(branch));
}

void RegAllocRegionFlow::initializeBranch(RegionBranchOpInterface branchOp,
                                          unsigned branchId, Branch &branch) {
  Operation *op = branchOp.getOperation();
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
}

void RegAllocRegionFlow::collectTransfers(RegionBranchOpInterface branchOp,
                                          Branch &branch) {
  for (RegionBranchPoint point : branchOp.getAllRegionBranchPoints())
    collectPointTransfers(branchOp, point, branch);
}

void RegAllocRegionFlow::collectPointTransfers(RegionBranchOpInterface branchOp,
                                               RegionBranchPoint point,
                                               Branch &branch) {
  SmallVector<RegionSuccessor, 4> successors;
  branchOp.getSuccessorRegions(point, successors);
  Region *source = nullptr;
  Operation *sourceOperation = branch.op;
  if (!point.isParent()) {
    RegionBranchTerminatorOpInterface term =
        point.getTerminatorPredecessorOrNull();
    source = term->getParentRegion();
    sourceOperation = term.getOperation();
  }
  for (RegionSuccessor successor : successors)
    appendSuccessorTransfers(branchOp, point, source, sourceOperation,
                             successor, branch);
}

void RegAllocRegionFlow::appendSuccessorTransfers(
    RegionBranchOpInterface branchOp, RegionBranchPoint point, Region *source,
    Operation *sourceOperation, RegionSuccessor successor, Branch &branch) {
  Region *target = successor.isRegion() ? successor.getSuccessor() : nullptr;
  if (point.isParent() && target)
    branch.entryRegions.set(target->getRegionNumber());
  if (source && target)
    branch.reachable[source->getRegionNumber()].set(target->getRegionNumber());

  OperandRange operands = branchOp.getSuccessorOperands(point, successor);
  ValueRange inputs = branchOp.getSuccessorInputs(successor);
  assert(operands.size() == inputs.size() &&
         "RegionBranch successor arity mismatch");
  MutableArrayRef<OpOperand> opOperands(operands.getBase(), operands.size());
  unsigned firstTransfer = branch.transfers.size();
  for (auto [index, values] :
       llvm::enumerate(llvm::zip_equal(opOperands, inputs))) {
    auto [operand, input] = values;
    branch.transfers.push_back({input, &operand, source, target,
                                sourceOperation, static_cast<unsigned>(index)});
  }
  if (branch.transfers.size() != firstTransfer)
    branch.transferGroups.push_back(
        {sourceOperation, source, target, firstTransfer,
         static_cast<unsigned>(branch.transfers.size() - firstTransfer)});
}

void RegAllocRegionFlow::closeReachability(Branch &branch) {
  unsigned regionCount = branch.regions.size();
  for (unsigned via = 0; via < regionCount; ++via)
    for (unsigned source = 0; source < regionCount; ++source)
      if (branch.reachable[source].test(via))
        branch.reachable[source] |= branch.reachable[via];
  for (unsigned i = 0; i < regionCount; ++i)
    branch.repetitiveRegions[i] = branch.reachable[i].test(i);
}

static bool areExclusiveEntryRegions(const RegAllocRegionFlow::Branch &branch,
                                     unsigned lhs, unsigned rhs) {
  return lhs != rhs && !branch.repetitiveRegions.test(lhs) &&
         !branch.repetitiveRegions.test(rhs) &&
         !branch.reachable[lhs].test(rhs) && !branch.reachable[rhs].test(lhs);
}

void RegAllocRegionFlow::classifyRegions(Branch &branch) {
  for (unsigned lhs : branch.entryRegions.set_bits()) {
    for (unsigned rhs : branch.entryRegions.set_bits()) {
      if (areExclusiveEntryRegions(branch, lhs, rhs)) {
        exclusiveRegions.insert(branch.regions[lhs]);
        break;
      }
    }
  }
}

void RegAllocRegionFlow::recordRepetitiveTransfers(const Branch &branch) {
  for (const Transfer &transfer : branch.transfers)
    if (transfer.target &&
        branch.repetitiveRegions.test(transfer.target->getRegionNumber())) {
      repetitiveTransferOperands.insert(transfer.operand);
      repetitiveTransferInputs.insert(transfer.input);
    }
}

namespace {

class RepetitiveInputClasses {
public:
  explicit RepetitiveInputClasses(const RegAllocRegionFlow::Branch &branch) {
    for (const RegAllocRegionFlow::Transfer &transfer : branch.transfers)
      if (targetsRepetitiveRegion(branch, transfer))
        inputIds.try_emplace(transfer.input, inputIds.size());
    parents.resize(inputIds.size());
    entrySlots.resize(inputIds.size());
    for (unsigned id = 0; id < parents.size(); ++id)
      parents[id] = id;
    for (const RegAllocRegionFlow::Transfer &transfer : branch.transfers)
      if (!transfer.source && targetsRepetitiveRegion(branch, transfer)) {
        unsigned id = inputIds.lookup(transfer.input);
        entrySlots[id] = id;
      }
  }

  RegAllocRegionFlow::RepetitiveInputRelation classify(Value source,
                                                       Value target) {
    auto sourceIt = inputIds.find(source);
    auto targetIt = inputIds.find(target);
    if (sourceIt == inputIds.end() || targetIt == inputIds.end())
      return RegAllocRegionFlow::RepetitiveInputRelation::None;
    unsigned sourceRoot = findRoot(sourceIt->second);
    unsigned targetRoot = findRoot(targetIt->second);
    if (sourceRoot == targetRoot)
      return RegAllocRegionFlow::RepetitiveInputRelation::SameSlot;
    if (hasDistinctEntrySlots(sourceRoot, targetRoot))
      return RegAllocRegionFlow::RepetitiveInputRelation::DifferentSlots;
    parents[targetRoot] = sourceRoot;
    if (!entrySlots[sourceRoot])
      entrySlots[sourceRoot] = entrySlots[targetRoot];
    return RegAllocRegionFlow::RepetitiveInputRelation::SameSlot;
  }

private:
  static bool
  targetsRepetitiveRegion(const RegAllocRegionFlow::Branch &branch,
                          const RegAllocRegionFlow::Transfer &transfer) {
    return transfer.target &&
           branch.repetitiveRegions.test(transfer.target->getRegionNumber());
  }

  bool hasDistinctEntrySlots(unsigned lhs, unsigned rhs) const {
    return entrySlots[lhs] && entrySlots[rhs] &&
           entrySlots[lhs] != entrySlots[rhs];
  }

  unsigned findRoot(unsigned id) {
    while (parents[id] != id) {
      parents[id] = parents[parents[id]];
      id = parents[id];
    }
    return id;
  }

  DenseMap<Value, unsigned> inputIds;
  SmallVector<unsigned> parents;
  SmallVector<std::optional<unsigned>> entrySlots;
};

static bool isRepetitiveCycle(const RegAllocRegionFlow::Branch &branch,
                              const RegAllocRegionFlow::Transfer &transfer) {
  if (!transfer.source || !transfer.target)
    return false;
  unsigned source = transfer.source->getRegionNumber();
  unsigned target = transfer.target->getRegionNumber();
  return branch.repetitiveRegions.test(target) &&
         branch.reachable[target].test(source);
}

} // namespace

void RegAllocRegionFlow::classifyRepetitiveInputTransfers(Branch &branch) {
  RepetitiveInputClasses classes(branch);
  for (Transfer &transfer : branch.transfers) {
    if (!isRepetitiveCycle(branch, transfer))
      continue;
    transfer.repetitiveInputRelation =
        classes.classify(transfer.operand->get(), transfer.input);
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

namespace {

class AliasForestBuilder {
public:
  AliasForestBuilder(const RegAllocRegionFlow &flow,
                     const RegAllocRegionFlow::Branch &branch)
      : flow(flow), branch(branch), repetitive(branch.repetitiveRegions.any()) {
    orderTransfers();
    numberValues();
    mergeComponents();
    selectPreferredRoots();
  }

  SmallVector<RegAllocRegionFlow::Alias, 8> build() {
    SmallVector<RegAllocRegionFlow::Alias, 8> aliases;
    DenseSet<Value> emitted;
    for (unsigned kind : {0u, 3u, 1u, 2u})
      appendKind(kind, emitted, aliases);
    return aliases;
  }

private:
  struct PreferredRoot {
    Value value;
    unsigned priority = std::numeric_limits<unsigned>::max();
  };

  void orderTransfers() {
    for (unsigned wanted = 0; wanted != 4; ++wanted)
      for (const RegAllocRegionFlow::Transfer &transfer : branch.transfers)
        if (static_cast<unsigned>(flow.getTransferKind(transfer)) == wanted)
          ordered.push_back(&transfer);
  }

  unsigned getId(Value value) {
    return ids.try_emplace(value, ids.size()).first->second;
  }

  void numberValues() {
    for (const RegAllocRegionFlow::Transfer *transfer : ordered) {
      (void)getId(transfer->operand->get());
      (void)getId(transfer->input);
    }
    parents.resize(ids.size());
    for (unsigned id = 0; id != parents.size(); ++id)
      parents[id] = id;
  }

  unsigned findRoot(unsigned id) {
    while (parents[id] != id) {
      parents[id] = parents[parents[id]];
      id = parents[id];
    }
    return id;
  }

  void mergeComponents() {
    for (const RegAllocRegionFlow::Transfer *transfer : ordered) {
      unsigned lhs = findRoot(ids.lookup(transfer->operand->get()));
      unsigned rhs = findRoot(ids.lookup(transfer->input));
      if (lhs != rhs)
        parents[rhs] = lhs;
    }
  }

  void consider(Value value, unsigned priority) {
    unsigned component = findRoot(ids.lookup(value));
    PreferredRoot &candidate = preferred[component];
    if (!candidate.value || priority < candidate.priority)
      candidate = {value, priority};
  }

  void selectPreferredRoots() {
    for (const RegAllocRegionFlow::Transfer *transfer : ordered) {
      Value source = transfer->operand->get();
      if (repetitive) {
        bool entry = !transfer->source && transfer->target &&
                     flow.isRepetitive(transfer->target);
        consider(source, entry ? 0u : 3u);
        consider(transfer->input, entry ? 1u : 3u);
        continue;
      }
      consider(source, 2u);
      consider(transfer->input, transfer->target ? 1u : 0u);
    }
  }

  void appendKind(unsigned wanted, DenseSet<Value> &emitted,
                  SmallVectorImpl<RegAllocRegionFlow::Alias> &aliases) {
    for (const RegAllocRegionFlow::Transfer *transfer : ordered) {
      RegAllocRegionFlow::TransferKind kind = flow.getTransferKind(*transfer);
      if (static_cast<unsigned>(kind) != wanted)
        continue;
      for (Value value : {transfer->operand->get(), transfer->input}) {
        unsigned component = findRoot(ids.lookup(value));
        Value root = preferred.lookup(component).value;
        if (value != root && emitted.insert(value).second)
          aliases.push_back({root, value, transfer, kind});
      }
    }
  }

  SmallVector<const RegAllocRegionFlow::Transfer *, 8> ordered;
  DenseMap<Value, unsigned> ids;
  SmallVector<unsigned> parents;
  DenseMap<unsigned, PreferredRoot> preferred;
  const RegAllocRegionFlow &flow;
  const RegAllocRegionFlow::Branch &branch;
  bool repetitive = false;
};

} // namespace

SmallVector<RegAllocRegionFlow::Alias, 8>
RegAllocRegionFlow::getAliasForest(Operation *op) const {
  const Branch *branch = lookup(op);
  if (!branch)
    return {};
  return AliasForestBuilder(*this, *branch).build();
}

namespace {

static void appendAcyclicAliasEdges(
    const RegAllocRegionFlow &flow, const RegAllocRegionFlow::Branch &branch,
    SmallVectorImpl<RegAllocRegionFlow::OrderedAliasEdge> &edges) {
  for (const RegAllocRegionFlow::Transfer &transfer : branch.transfers) {
    Value source = transfer.operand->get();
    RegAllocRegionFlow::TransferKind kind = flow.getTransferKind(transfer);
    if (transfer.target)
      edges.push_back({source, transfer.input, &transfer, kind});
    else
      edges.push_back({transfer.input, source, &transfer, kind});
  }
}

struct SingleRegionAliasLayout {
  SmallVector<const RegAllocRegionFlow::Transfer *, 8> entries;
  SmallVector<const RegAllocRegionFlow::Transfer *, 8> results;
  SmallVector<const RegAllocRegionFlow::Transfer *, 8> cycles;
  Region *region = nullptr;
  bool supported = true;
};

static bool
recordSingleRegionTransfer(SingleRegionAliasLayout &layout,
                           const RegAllocRegionFlow::Transfer &transfer) {
  unsigned index = transfer.successorInputIndex;
  if (!transfer.source && transfer.target == layout.region) {
    if (layout.entries[index])
      return false;
    layout.entries[index] = &transfer;
    return true;
  }
  if (transfer.source == layout.region && transfer.target == layout.region) {
    layout.cycles.push_back(&transfer);
    return true;
  }
  if (!transfer.target) {
    if (!layout.results[index]) {
      layout.results[index] = &transfer;
      return true;
    }
    return layout.results[index]->input == transfer.input;
  }
  return false;
}

static SingleRegionAliasLayout
getSingleRegionAliasLayout(const RegAllocRegionFlow::Branch &branch) {
  SingleRegionAliasLayout layout;
  layout.region = branch.regions.front();
  unsigned slotCount = 0;
  for (const RegAllocRegionFlow::Transfer &transfer : branch.transfers)
    slotCount = std::max(slotCount, transfer.successorInputIndex + 1);
  layout.entries.resize(slotCount);
  layout.results.resize(slotCount);
  for (const RegAllocRegionFlow::Transfer &transfer : branch.transfers)
    layout.supported &= recordSingleRegionTransfer(layout, transfer);
  return layout;
}

static bool
hasCompleteSingleRegionLayout(const SingleRegionAliasLayout &layout) {
  return layout.supported &&
         llvm::all_of(
             layout.entries,
             [](const auto *transfer) { return transfer != nullptr; }) &&
         llvm::all_of(layout.results,
                      [](const auto *transfer) { return transfer != nullptr; });
}

static void appendSingleRegionAliasEdges(
    const RegAllocRegionFlow &flow, const SingleRegionAliasLayout &layout,
    SmallVectorImpl<RegAllocRegionFlow::OrderedAliasEdge> &edges) {
  edges.reserve(layout.entries.size() * 2 + layout.cycles.size());
  DenseSet<Value> seenEntrySources;
  for (auto [entry, result] : llvm::zip_equal(layout.entries, layout.results)) {
    Value slot = entry->input;
    edges.push_back(
        {slot, result->input, result, flow.getTransferKind(*result)});
    Value source = entry->operand->get();
    if (seenEntrySources.insert(source).second)
      edges.push_back({source, slot, entry, flow.getTransferKind(*entry)});
  }
  for (const RegAllocRegionFlow::Transfer *cycle : layout.cycles)
    edges.push_back({layout.entries[cycle->successorInputIndex]->input,
                     cycle->operand->get(), cycle,
                     flow.getTransferKind(*cycle)});
}

static bool tryAppendSingleRegionAliasEdges(
    const RegAllocRegionFlow &flow, const RegAllocRegionFlow::Branch &branch,
    SmallVectorImpl<RegAllocRegionFlow::OrderedAliasEdge> &edges) {
  if (branch.regions.size() != 1 || !branch.repetitiveRegions.test(0))
    return false;
  SingleRegionAliasLayout layout = getSingleRegionAliasLayout(branch);
  if (!hasCompleteSingleRegionLayout(layout))
    return false;
  appendSingleRegionAliasEdges(flow, layout, edges);
  return true;
}

class RepeatedAliasEdgeBuilder {
public:
  RepeatedAliasEdgeBuilder(
      const RegAllocRegionFlow &flow, const RegAllocRegionFlow::Branch &branch,
      SmallVectorImpl<RegAllocRegionFlow::OrderedAliasEdge> &edges)
      : flow(flow), branch(branch), edges(edges) {
    buildComponentRoots();
    buildSlots();
    buildResults();
  }

  void build() {
    appendEntries();
    appendCycles();
    appendRemainingValues();
  }

private:
  Value getRoot(Value value) const {
    auto it = componentRoots.find(value);
    return it == componentRoots.end() ? value : it->second;
  }

  void buildComponentRoots() {
    for (const RegAllocRegionFlow::Alias &alias :
         flow.getAliasForest(branch.op)) {
      componentRoots.try_emplace(alias.primary, alias.primary);
      componentRoots[alias.extra] = alias.primary;
    }
  }

  void buildSlots() {
    for (const RegAllocRegionFlow::Transfer &transfer : branch.transfers)
      if (!transfer.source && transfer.target &&
          flow.isRepetitive(transfer.target))
        slots.try_emplace(getRoot(transfer.input), transfer.input);
    for (const RegAllocRegionFlow::Transfer &transfer : branch.transfers)
      if (transfer.source && transfer.target &&
          flow.mayReach(transfer.target, transfer.source))
        slots.try_emplace(getRoot(transfer.input), transfer.input);
  }

  void buildResults() {
    DenseSet<Value> seen;
    for (const RegAllocRegionFlow::Transfer &transfer : branch.transfers)
      if (!transfer.target && seen.insert(transfer.input).second)
        results[getRoot(transfer.input)].push_back(&transfer);
  }

  void appendResults(Value root, Value slot) {
    if (!emittedResultComponents.insert(root).second)
      return;
    for (const RegAllocRegionFlow::Transfer *result : results.lookup(root)) {
      edges.push_back(
          {slot, result->input, result, flow.getTransferKind(*result)});
      emitted.insert(result->input);
    }
  }

  void appendEntry(const RegAllocRegionFlow::Transfer &transfer) {
    Value input = transfer.input;
    Value root = getRoot(input);
    Value slot = slots.lookup(root);
    appendResults(root, slot);
    Value source = transfer.operand->get();
    if (seenEntrySources.insert(source).second)
      edges.push_back(
          {source, input, &transfer, flow.getTransferKind(transfer)});
    if (input != slot && emitted.insert(input).second)
      edges.push_back({slot, input, &transfer, flow.getTransferKind(transfer)});
    emitted.insert(source);
    emitted.insert(input);
  }

  void appendEntries() {
    for (const RegAllocRegionFlow::Transfer &transfer : branch.transfers)
      if (!transfer.source && transfer.target &&
          flow.isRepetitive(transfer.target))
        appendEntry(transfer);
  }

  void appendCycle(const RegAllocRegionFlow::Transfer &transfer) {
    Value slot = slots.lookup(getRoot(transfer.input));
    if (transfer.input != slot && emitted.insert(transfer.input).second)
      edges.push_back(
          {slot, transfer.input, &transfer, flow.getTransferKind(transfer)});
    Value source = transfer.operand->get();
    edges.push_back({slot, source, &transfer, flow.getTransferKind(transfer)});
    emitted.insert(source);
  }

  void appendCycles() {
    for (const RegAllocRegionFlow::Transfer &transfer : branch.transfers)
      if (transfer.source && transfer.target &&
          flow.mayReach(transfer.target, transfer.source))
        appendCycle(transfer);
  }

  void appendRemainingValues() {
    for (const RegAllocRegionFlow::Transfer &transfer : branch.transfers) {
      for (Value value : {transfer.operand->get(), transfer.input}) {
        if (!emitted.insert(value).second)
          continue;
        Value slot = slots.lookup(getRoot(value));
        if (slot && value != slot)
          edges.push_back(
              {slot, value, &transfer, flow.getTransferKind(transfer)});
      }
    }
  }

  DenseMap<Value, Value> componentRoots;
  DenseMap<Value, Value> slots;
  DenseMap<Value, SmallVector<const RegAllocRegionFlow::Transfer *, 2>> results;
  DenseSet<Value> emitted;
  DenseSet<Value> emittedResultComponents;
  DenseSet<Value> seenEntrySources;
  const RegAllocRegionFlow &flow;
  const RegAllocRegionFlow::Branch &branch;
  SmallVectorImpl<RegAllocRegionFlow::OrderedAliasEdge> &edges;
};

} // namespace

void RegAllocRegionFlow::appendOrderedAliasEdges(
    Operation *op, SmallVectorImpl<OrderedAliasEdge> &edges) const {
  const Branch *branch = lookup(op);
  if (!branch)
    return;
  if (branch->repetitiveRegions.none()) {
    appendAcyclicAliasEdges(*this, *branch, edges);
    return;
  }
  if (tryAppendSingleRegionAliasEdges(*this, *branch, edges))
    return;
  RepeatedAliasEdgeBuilder(*this, *branch, edges).build();
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
