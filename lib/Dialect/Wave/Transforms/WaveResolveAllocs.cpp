//===- WaveResolveAllocs.cpp - place Wave allocations -----------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/Wave/Transforms/Passes.h"
#include "mlir/Dialect/Wave/Transforms/WaveLDSAllocation.h"

#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/SCF/IR/SCF.h"
#include "mlir/Dialect/Wave/IR/Wave.h"
#include "mlir/Dialect/Wave/IR/WaveAMD.h"
#include "mlir/IR/Builders.h"
#include "mlir/IR/PatternMatch.h"
#include "mlir/Interfaces/ControlFlowInterfaces.h"
#include "mlir/Interfaces/SideEffectInterfaces.h"
#include "mlir/Interfaces/ViewLikeInterface.h"
#include "llvm/ADT/ArrayRef.h"
#include "llvm/ADT/BitVector.h"
#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/DenseSet.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/ADT/SmallPtrSet.h"

#include <algorithm>
#include <cassert>
#include <limits>
#include <memory>
#include <optional>
#include <utility>

namespace mlir::wave {
#define GEN_PASS_DEF_WAVERESOLVEALLOCS
#include "mlir/Dialect/Wave/Transforms/Passes.h.inc"
} // namespace mlir::wave

using namespace mlir;
using namespace mlir::wave;

namespace {

struct AllocInterval {
  SmallVector<Operation *, 4> accesses;
  SmallVector<Value, 4> completionTokens;
  std::optional<int64_t> fixedOffset;
  AllocOp op;
  AllocReleaseOp release;
  int64_t bytes = 0;
  int64_t align = 1;
  int64_t offset = 0;
  unsigned start = 0;
  unsigned end = 0;
  bool hasUntrackedAccess = false;
  bool collectivelyComplete = false;
};

struct PlacedAllocation {
  int64_t offset = 0;
  int64_t bytes = 0;
  unsigned index = 0;
};

struct TokenOrigin {
  Value source;
  Region *predecessorRegion = nullptr;
};

using TokenOriginMap = DenseMap<Value, SmallVector<TokenOrigin, 2>>;

static bool dropsTokenCompletion(Operation *op) {
  return isa<IssueTokenOp>(op);
}

using MemoryEffectInstance = SideEffects::EffectInstance<MemoryEffects::Effect>;

static FailureOr<int64_t> alignUp(int64_t value, int64_t align) {
  if (value < 0 || align <= 0)
    return failure();
  int64_t rem = value % align;
  if (rem == 0)
    return value;
  int64_t add = align - rem;
  if (value > std::numeric_limits<int64_t>::max() - add)
    return failure();
  return value + add;
}

class OperationOrder {
public:
  explicit OperationOrder(func::FuncOp func) {
    func.walk<WalkOrder::PreOrder>(
        [&](Operation *op) { positions.try_emplace(op, next++); });
  }

  unsigned lookup(Operation *op) const {
    auto it = positions.find(op);
    assert(it != positions.end() && "operation missing from order");
    return it->second;
  }

private:
  DenseMap<Operation *, unsigned> positions;
  unsigned next = 0;
};

static bool appendAlias(DenseMap<Value, SmallVector<unsigned, 1>> &aliases,
                        Value value, unsigned index,
                        SmallVectorImpl<std::pair<Value, unsigned>> &worklist) {
  SmallVector<unsigned, 1> &indices = aliases[value];
  if (llvm::is_contained(indices, index))
    return false;
  indices.push_back(index);
  worklist.push_back({value, index});
  return true;
}

static bool
appendForAliases(scf::ForOp loop, Value value, unsigned index,
                 DenseMap<Value, SmallVector<unsigned, 1>> &aliases,
                 SmallVectorImpl<std::pair<Value, unsigned>> &worklist) {
  bool forwarded = false;
  for (auto [i, init] : llvm::enumerate(loop.getInitArgs())) {
    if (init != value)
      continue;
    forwarded = true;
    appendAlias(aliases, loop.getRegionIterArgs()[i], index, worklist);
    appendAlias(aliases, loop.getResult(i), index, worklist);
  }
  return forwarded;
}

static bool
appendYieldAliases(Operation *yield, Value value, unsigned index,
                   DenseMap<Value, SmallVector<unsigned, 1>> &aliases,
                   SmallVectorImpl<std::pair<Value, unsigned>> &worklist) {
  Operation *parent = yield->getParentOp();
  bool forwarded = false;
  for (auto [i, operand] : llvm::enumerate(yield->getOperands())) {
    if (operand != value)
      continue;
    forwarded = true;
    if (auto where = dyn_cast<WhereOp>(parent)) {
      appendAlias(aliases, where.getResult(i), index, worklist);
      continue;
    }
    if (auto ifOp = dyn_cast<scf::IfOp>(parent)) {
      appendAlias(aliases, ifOp.getResult(i), index, worklist);
      continue;
    }
    if (auto loop = dyn_cast<scf::ForOp>(parent)) {
      appendAlias(aliases, loop.getRegionIterArgs()[i], index, worklist);
      appendAlias(aliases, loop.getResult(i), index, worklist);
    }
  }
  return forwarded;
}

static bool
appendForwardedAliases(Operation *user, Value value, unsigned index,
                       DenseMap<Value, SmallVector<unsigned, 1>> &aliases,
                       SmallVectorImpl<std::pair<Value, unsigned>> &worklist) {
  bool forwarded = false;
  if (auto view = dyn_cast<ViewLikeOpInterface>(user)) {
    if (view.getViewSource() == value) {
      forwarded = true;
      appendAlias(aliases, view.getViewDest(), index, worklist);
    }
  }
  if (auto select = dyn_cast<SelectOp>(user)) {
    if (select.getTrueValue() == value || select.getFalseValue() == value) {
      forwarded = true;
      appendAlias(aliases, select.getResult(), index, worklist);
    }
  }
  if (auto loop = dyn_cast<scf::ForOp>(user))
    forwarded |= appendForAliases(loop, value, index, aliases, worklist);
  if (isa<YieldOp, scf::YieldOp>(user))
    forwarded |= appendYieldAliases(user, value, index, aliases, worklist);
  return forwarded;
}

static void appendTokenOrigins(TokenOriginMap &origins, OperandRange sources,
                               ValueRange targets, Region *predecessorRegion) {
  for (auto [index, source] : llvm::enumerate(sources)) {
    if (index >= targets.size())
      break;
    Value target = targets[index];
    if (!isa<MemTokenType>(source.getType()) ||
        source.getType() != target.getType())
      continue;
    SmallVector<TokenOrigin, 2> &targetOrigins = origins[target];
    if (llvm::none_of(targetOrigins, [&](const TokenOrigin &origin) {
          return origin.source == source &&
                 origin.predecessorRegion == predecessorRegion;
        }))
      targetOrigins.push_back({source, predecessorRegion});
  }
}

static TokenOriginMap buildTokenOrigins(func::FuncOp func) {
  TokenOriginMap origins;
  func.walk([&](RegionBranchOpInterface branch) {
    SmallVector<RegionSuccessor> successors;
    branch.getSuccessorRegions(RegionBranchPoint::parent(), successors);
    for (RegionSuccessor successor : successors)
      appendTokenOrigins(origins, branch.getEntrySuccessorOperands(successor),
                         branch.getSuccessorInputs(successor),
                         /*predecessorRegion=*/nullptr);

    for (Region &region : branch->getRegions()) {
      for (Block &block : region) {
        RegionBranchTerminatorOpInterface terminator =
            dyn_cast<RegionBranchTerminatorOpInterface>(block.getTerminator());
        if (!terminator)
          continue;
        successors.clear();
        branch.getSuccessorRegions(RegionBranchPoint(terminator), successors);
        for (RegionSuccessor successor : successors)
          appendTokenOrigins(origins,
                             terminator.getSuccessorOperands(successor),
                             branch.getSuccessorInputs(successor), &region);
      }
    }
  });
  return origins;
}

struct DependencyProof {
  bool depends = false;
  bool cyclic = false;
};

struct ActiveProof {
  DenseSet<Value> dependency;
  DenseSet<Value> barrier;
};

struct TokenProofDependency {
  Region *predecessorRegion = nullptr;
  unsigned index = 0;
};

struct TokenProofNode {
  SmallVector<TokenProofDependency, 2> dependencies;
  bool allDependencies = false;
  bool barrier = false;
};

static Region *getValueParentRegion(Value value) {
  if (BlockArgument argument = dyn_cast<BlockArgument>(value))
    return argument.getOwner()->getParent();
  Operation *def = value.getDefiningOp();
  return def ? def->getParentRegion() : nullptr;
}

static Operation *getOriginBranch(Value value) {
  if (Operation *def = value.getDefiningOp())
    if (isa<RegionBranchOpInterface>(def))
      return def;
  // Entry plus backedge prevents self-yield from proving completion.
  return nullptr;
}

static Region *getEnclosingBranchRegion(Operation *branch, Value value) {
  for (Region *region = getValueParentRegion(value); region;) {
    Operation *parent = region->getParentOp();
    if (parent == branch)
      return region;
    region = parent ? parent->getParentRegion() : nullptr;
  }
  return nullptr;
}

static bool regionMayReach(Operation *branchOp, Region *source,
                           Region *target) {
  RegionBranchOpInterface branch = cast<RegionBranchOpInterface>(branchOp);
  SmallVector<Region *, 4> worklist{source};
  SmallPtrSet<Region *, 4> visited;
  SmallVector<RegionSuccessor> successors;
  while (!worklist.empty()) {
    Region *region = worklist.pop_back_val();
    if (!visited.insert(region).second)
      continue;
    if (region == target)
      return true;
    for (Block &block : *region) {
      RegionBranchTerminatorOpInterface terminator =
          dyn_cast<RegionBranchTerminatorOpInterface>(block.getTerminator());
      if (!terminator)
        continue;
      successors.clear();
      branch.getSuccessorRegions(RegionBranchPoint(terminator), successors);
      for (RegionSuccessor successor : successors)
        if (!successor.isOperation())
          worklist.push_back(successor.getSuccessor());
    }
  }
  return false;
}

static bool originParticipatesForTarget(Value merged, Region *predecessorRegion,
                                        Value target) {
  Operation *branch = getOriginBranch(merged);
  if (!branch)
    return true;
  Region *targetRegion = getEnclosingBranchRegion(branch, target);
  if (!targetRegion)
    return true;
  // Parent-origin edges precede every nested target.
  if (!predecessorRegion)
    return false;
  return regionMayReach(branch, targetRegion, predecessorRegion);
}

class BatchedTokenProof {
public:
  BatchedTokenProof(const TokenOriginMap &origins, ArrayRef<Value> tokens,
                    ArrayRef<Value> targets)
      : origins(origins), width(targets.size()) {
    targetValues.append(targets.begin(), targets.end());
    for (Value token : tokens)
      roots.push_back(addNode(token));
    for (auto [index, target] : llvm::enumerate(targets))
      targetIndices[target].push_back(index);
    buildNodes();
    buildUsers();
    plain.assign(nodes.size(), BitVector(width, true));
    throughBarrier.assign(nodes.size(), BitVector(width, true));
    solve();
  }

  bool covers(bool requireBarrier) const {
    BitVector covered(width);
    ArrayRef<BitVector> states = requireBarrier ? throughBarrier : plain;
    for (unsigned root : roots)
      covered |= states[root];
    return covered.all();
  }

private:
  unsigned addNode(Value value) {
    auto [it, inserted] = indices.try_emplace(value, values.size());
    if (inserted) {
      values.push_back(value);
      nodes.emplace_back();
      pending.push_back(it->second);
    }
    return it->second;
  }

  TokenProofNode buildNode(Value value) {
    TokenProofNode node;
    auto origin = origins.find(value);
    if (origin != origins.end()) {
      node.allDependencies = true;
      for (const TokenOrigin &tokenOrigin : origin->second)
        node.dependencies.push_back(
            {tokenOrigin.predecessorRegion, addNode(tokenOrigin.source)});
      return node;
    }
    Operation *def = value.getDefiningOp();
    if (!def)
      return node;
    if (dropsTokenCompletion(def))
      return node;
    node.barrier = isa<BarrierOp>(def);
    for (Value operand : def->getOperands())
      if (isa<MemTokenType>(operand.getType()))
        node.dependencies.push_back({nullptr, addNode(operand)});
    return node;
  }

  void buildNodes() {
    while (!pending.empty()) {
      unsigned index = pending.pop_back_val();
      nodes[index] = buildNode(values[index]);
    }
  }

  void buildUsers() {
    users.resize(nodes.size());
    for (auto [index, node] : llvm::enumerate(nodes))
      for (TokenProofDependency dependency : node.dependencies)
        users[dependency.index].push_back(index);
  }

  BitVector combine(unsigned index, const TokenProofNode &node,
                    ArrayRef<BitVector> states) const {
    BitVector result(width);
    if (!node.allDependencies) {
      for (TokenProofDependency dependency : node.dependencies)
        result |= states[dependency.index];
      return result;
    }
    for (unsigned targetIndex : llvm::seq<unsigned>(0, width)) {
      bool hasRelevantOrigin = false;
      bool covered = true;
      for (TokenProofDependency dependency : node.dependencies) {
        if (!originParticipatesForTarget(values[index],
                                         dependency.predecessorRegion,
                                         targetValues[targetIndex]))
          continue;
        hasRelevantOrigin = true;
        covered &= states[dependency.index].test(targetIndex);
      }
      if (hasRelevantOrigin && covered)
        result.set(targetIndex);
    }
    return result;
  }

  bool update(unsigned index) {
    const TokenProofNode &node = nodes[index];
    BitVector nextPlain = combine(index, node, plain);
    for (unsigned target : targetIndices.lookup(values[index]))
      nextPlain.set(target);
    BitVector nextBarrier = node.barrier ? combine(index, node, plain)
                                         : combine(index, node, throughBarrier);
    if (nextPlain == plain[index] && nextBarrier == throughBarrier[index])
      return false;
    plain[index] = std::move(nextPlain);
    throughBarrier[index] = std::move(nextBarrier);
    return true;
  }

  void solve() {
    SmallVector<unsigned> worklist;
    BitVector queued(nodes.size(), true);
    for (unsigned index : llvm::seq<unsigned>(0, nodes.size()))
      worklist.push_back(index);
    while (!worklist.empty()) {
      unsigned index = worklist.pop_back_val();
      queued.reset(index);
      if (!update(index))
        continue;
      for (unsigned user : users[index])
        if (!queued.test(user)) {
          queued.set(user);
          worklist.push_back(user);
        }
    }
  }

  DenseMap<Value, SmallVector<unsigned, 1>> targetIndices;
  DenseMap<Value, unsigned> indices;
  SmallVector<SmallVector<unsigned, 2>> users;
  SmallVector<TokenProofNode> nodes;
  SmallVector<BitVector> throughBarrier;
  SmallVector<BitVector> plain;
  SmallVector<unsigned, 2> roots;
  SmallVector<unsigned> pending;
  SmallVector<Value> targetValues;
  SmallVector<Value> values;
  const TokenOriginMap &origins;
  unsigned width = 0;
};

class TokenOrdering {
public:
  explicit TokenOrdering(TokenOriginMap origins)
      : origins(std::move(origins)) {}

  bool dependsOn(Value token, Value target) {
    ActiveProof active;
    return prove(token, target, /*requireBarrier=*/false, active).depends;
  }

  bool dependsOnThroughBarrier(Value token, Value target) {
    ActiveProof active;
    return prove(token, target, /*requireBarrier=*/true, active).depends;
  }

  bool dependsOnAll(Value token, ArrayRef<Value> targets, bool requireBarrier) {
    return dependsOnAll(ArrayRef<Value>{token}, targets, requireBarrier);
  }

  bool dependsOnAll(ArrayRef<Value> tokens, ArrayRef<Value> targets,
                    bool requireBarrier) {
    if (targets.empty())
      return true;
    if (tokens.empty())
      return false;
    return BatchedTokenProof(origins, tokens, targets).covers(requireBarrier);
  }

  const TokenOriginMap &getOrigins() const { return origins; }

private:
  DependencyProof proveAllOrigins(Value merged,
                                  ArrayRef<TokenOrigin> tokenOrigins,
                                  Value target, bool requireBarrier,
                                  ActiveProof &active) {
    if (tokenOrigins.empty())
      return {};
    DependencyProof result{true, false};
    bool hasRelevantOrigin = false;
    for (const TokenOrigin &origin : tokenOrigins) {
      if (!originParticipatesForTarget(merged, origin.predecessorRegion,
                                       target))
        continue;
      hasRelevantOrigin = true;
      DependencyProof proof =
          prove(origin.source, target, requireBarrier, active);
      if (!proof.depends && !proof.cyclic)
        return {};
      result.depends &= proof.depends;
      result.cyclic |= proof.cyclic;
    }
    return hasRelevantOrigin ? result : DependencyProof{};
  }

  DependencyProof proveAnyOperand(Operation *op, Value target,
                                  bool requireBarrier, ActiveProof &active) {
    DependencyProof result;
    if (dropsTokenCompletion(op))
      return result;
    requireBarrier &= !isa<BarrierOp>(op);
    for (Value operand : op->getOperands()) {
      if (!isa<MemTokenType>(operand.getType()))
        continue;
      DependencyProof proof = prove(operand, target, requireBarrier, active);
      if (proof.depends && !proof.cyclic)
        return {true, false};
      result.depends |= proof.depends;
      result.cyclic |= proof.cyclic;
    }
    return result;
  }

  DependencyProof prove(Value token, Value target, bool requireBarrier,
                        ActiveProof &active) {
    if (token == target)
      return {!requireBarrier, false};
    if (!isa<MemTokenType>(token.getType()))
      return {};

    std::pair<Value, Value> key{token, target};
    auto &cache = requireBarrier ? barrierCache : dependencyCache;
    auto cached = cache.find(key);
    if (cached != cache.end())
      return {cached->second, false};
    // Backedge cycle provisional; non-cycle origins still must prove target.
    DenseSet<Value> &activeSet =
        requireBarrier ? active.barrier : active.dependency;
    if (!activeSet.insert(token).second)
      return {true, true};

    // Region merge: every path on which the target executes. Op result: any
    // dependency operand.
    DependencyProof result;
    auto origin = origins.find(token);
    if (origin != origins.end())
      result = proveAllOrigins(token, origin->second, target, requireBarrier,
                               active);
    else if (Operation *def = token.getDefiningOp())
      result = proveAnyOperand(def, target, requireBarrier, active);

    activeSet.erase(token);
    if (!result.cyclic)
      cache.try_emplace(key, result.depends);
    return result;
  }

  TokenOriginMap origins;
  DenseMap<std::pair<Value, Value>, bool> dependencyCache;
  DenseMap<std::pair<Value, Value>, bool> barrierCache;
};

static SmallVector<Value, 2> getTokenResults(Operation *op) {
  SmallVector<Value, 2> tokens;
  for (Value result : op->getResults())
    if (isa<MemTokenType>(result.getType()))
      tokens.push_back(result);
  return tokens;
}

static LogicalResult associateReleases(ArrayRef<AllocReleaseOp> releases,
                                       SmallVectorImpl<AllocInterval> &allocs) {
  DenseMap<Value, unsigned> allocationIndices;
  for (auto [index, interval] : llvm::enumerate(allocs))
    allocationIndices.try_emplace(interval.op.getResult(), index);

  for (AllocReleaseOp release : releases) {
    auto index = allocationIndices.find(release.getAllocation());
    if (index == allocationIndices.end())
      return release.emitOpError(
          "allocation must be a direct wave.alloc result");
    AllocInterval &interval = allocs[index->second];
    if (interval.release)
      return release.emitOpError("allocation already has a wave.alloc_release");
    interval.release = release;
  }
  return success();
}

static void initializeAllocationAliases(
    const OperationOrder &order, SmallVectorImpl<AllocInterval> &allocs,
    DenseMap<Value, SmallVector<unsigned, 1>> &aliases,
    SmallVectorImpl<std::pair<Value, unsigned>> &worklist) {
  for (auto [index, interval] : llvm::enumerate(allocs)) {
    appendAlias(aliases, interval.op.getResult(), index, worklist);
    interval.start = order.lookup(interval.op);
    interval.end = interval.start;
  }
}

static unsigned getRegionEnd(const OperationOrder &order, Region &region) {
  unsigned end = order.lookup(region.getParentOp());
  region.walk([&](Operation *op) { end = std::max(end, order.lookup(op)); });
  return end;
}

static void extendIntervalForUse(const OperationOrder &order,
                                 AllocInterval &interval, Operation *user) {
  interval.end = std::max(interval.end, order.lookup(user));
  for (Region *region = user->getParentRegion(); region;) {
    Operation *parent = region->getParentOp();
    RegionBranchOpInterface branch = dyn_cast<RegionBranchOpInterface>(parent);
    if (branch && branch.isRepetitiveRegion(region->getRegionNumber()) &&
        interval.start < order.lookup(parent))
      interval.end = std::max(interval.end, getRegionEnd(order, *region));
    region = parent->getParentRegion();
  }
  scf::YieldOp yield = dyn_cast<scf::YieldOp>(user);
  if (!yield)
    return;
  scf::ForOp loop = dyn_cast<scf::ForOp>(yield->getParentOp());
  if (loop)
    interval.start = std::min(interval.start, order.lookup(loop));
}

static bool isTrackedMemoryUse(OpOperand &use) {
  MemoryEffectOpInterface memory =
      dyn_cast<MemoryEffectOpInterface>(use.getOwner());
  if (!memory)
    return false;
  SmallVector<MemoryEffectInstance, 4> effects;
  memory.getEffects(effects);
  for (const MemoryEffectInstance &effect : effects) {
    OpOperand *target = effect.getEffectValue<OpOperand *>();
    if (target == &use &&
        isa<MemoryEffects::Read, MemoryEffects::Write>(effect.getEffect()))
      return true;
  }
  return false;
}

static void
recordAllocationUse(const OperationOrder &order, Value value, unsigned index,
                    OpOperand &use,
                    DenseMap<Value, SmallVector<unsigned, 1>> &aliases,
                    SmallVectorImpl<std::pair<Value, unsigned>> &worklist,
                    SmallVectorImpl<AllocInterval> &allocs) {
  Operation *user = use.getOwner();
  AllocInterval &interval = allocs[index];
  extendIntervalForUse(order, interval, user);
  if (isa<AllocReleaseOp>(user) ||
      appendForwardedAliases(user, value, index, aliases, worklist))
    return;
  if (!llvm::is_contained(interval.accesses, user))
    interval.accesses.push_back(user);
  if (!isTrackedMemoryUse(use))
    interval.hasUntrackedAccess = true;
}

static void collectAllocationUses(const OperationOrder &order,
                                  SmallVectorImpl<AllocInterval> &allocs) {
  DenseMap<Value, SmallVector<unsigned, 1>> aliases;
  SmallVector<std::pair<Value, unsigned>, 16> worklist;
  initializeAllocationAliases(order, allocs, aliases, worklist);

  while (!worklist.empty()) {
    auto [value, index] = worklist.pop_back_val();
    for (OpOperand &use : value.getUses())
      recordAllocationUse(order, value, index, use, aliases, worklist, allocs);
  }
}

static SmallVector<Value, 4> collectAccessTokens(AllocInterval &interval) {
  SmallVector<Value, 4> accessTokens;
  for (Operation *access : interval.accesses) {
    SmallVector<Value, 2> tokens = getTokenResults(access);
    if (tokens.empty())
      interval.hasUntrackedAccess = true;
    llvm::append_range(accessTokens, tokens);
  }
  return accessTokens;
}

static LogicalResult finalizeAllocationInterval(AllocInterval &interval,
                                                TokenOrdering &ordering) {
  SmallVector<Value, 4> accessTokens = collectAccessTokens(interval);
  if (!interval.release) {
    interval.completionTokens = std::move(accessTokens);
    return success();
  }

  if (!ordering.dependsOnAll(interval.release.getDependency(), accessTokens,
                             /*requireBarrier=*/false))
    return interval.release.emitOpError(
        "dependency does not cover every allocation access token");
  if (interval.hasUntrackedAccess)
    return interval.release.emitOpError(
        "cannot release an allocation with an untracked pointer use");
  interval.collectivelyComplete =
      ordering.dependsOnAll(interval.release.getDependency(), accessTokens,
                            /*requireBarrier=*/true);
  interval.completionTokens.push_back(interval.release.getToken());
  return success();
}

static LogicalResult
collectAllocationIntervals(const OperationOrder &order, TokenOrdering &ordering,
                           SmallVectorImpl<AllocInterval> &allocs) {
  collectAllocationUses(order, allocs);
  for (AllocInterval &interval : allocs) {
    if (failed(finalizeAllocationInterval(interval, ordering)))
      return failure();
  }
  return success();
}

static bool operationDependsOnAll(Operation *op, ArrayRef<Value> dependencies,
                                  TokenOrdering &ordering,
                                  bool requireBarrier = false) {
  SmallVector<Value, 2> tokens;
  for (Value operand : op->getOperands())
    if (isa<MemTokenType>(operand.getType()))
      tokens.push_back(operand);
  return ordering.dependsOnAll(tokens, dependencies, requireBarrier);
}

static bool appendLoopCarriedTokenIndex(Value token, scf::ForOp loop,
                                        SmallVectorImpl<unsigned> &indices) {
  BlockArgument argument = dyn_cast<BlockArgument>(token);
  if (!argument)
    return false;
  for (auto [index, iterArg] : llvm::enumerate(loop.getRegionIterArgs())) {
    if (iterArg != argument)
      continue;
    if (!llvm::is_contained(indices, index))
      indices.push_back(index);
    return true;
  }
  return false;
}

static void collectLoopCarriedTokenIndicesImpl(
    Value token, scf::ForOp loop, const TokenOriginMap &origins,
    SmallVectorImpl<unsigned> &indices, DenseSet<Value> &visited) {
  if (!isa<MemTokenType>(token.getType()) || !visited.insert(token).second ||
      appendLoopCarriedTokenIndex(token, loop, indices))
    return;
  auto origin = origins.find(token);
  if (origin != origins.end()) {
    for (const TokenOrigin &tokenOrigin : origin->second)
      collectLoopCarriedTokenIndicesImpl(tokenOrigin.source, loop, origins,
                                         indices, visited);
    return;
  }
  Operation *def = token.getDefiningOp();
  if (!def || dropsTokenCompletion(def))
    return;
  for (Value operand : def->getOperands())
    if (isa<MemTokenType>(operand.getType()))
      collectLoopCarriedTokenIndicesImpl(operand, loop, origins, indices,
                                         visited);
}

static SmallVector<unsigned, 2>
collectLoopCarriedTokenIndices(Value token, scf::ForOp loop,
                               const TokenOriginMap &origins) {
  SmallVector<unsigned, 2> indices;
  DenseSet<Value> visited;
  collectLoopCarriedTokenIndicesImpl(token, loop, origins, indices, visited);
  return indices;
}

static SmallVector<unsigned, 2>
collectAccessCarriedIndices(Operation *access, scf::ForOp loop,
                            const TokenOriginMap &origins) {
  SmallVector<unsigned, 2> carried;
  for (Value operand : access->getOperands()) {
    if (!isa<MemTokenType>(operand.getType()))
      continue;
    for (unsigned index :
         collectLoopCarriedTokenIndices(operand, loop, origins))
      if (!llvm::is_contained(carried, index))
        carried.push_back(index);
  }
  return carried;
}

static bool yieldOrdersCompletion(scf::YieldOp yield,
                                  ArrayRef<unsigned> carried, Value completion,
                                  Operation *access, scf::ForOp loop,
                                  bool requireCollectiveBarrier,
                                  TokenOrdering &ordering) {
  for (unsigned index : carried) {
    if (index >= yield.getNumOperands())
      continue;
    Value yielded = yield.getOperand(index);
    bool accessCrossesBarrier =
        operationDependsOnAll(access, {loop.getRegionIterArg(index)}, ordering,
                              /*requireBarrier=*/true);
    bool requireBarrier = requireCollectiveBarrier && !accessCrossesBarrier;
    if (requireBarrier ? ordering.dependsOnThroughBarrier(yielded, completion)
                       : ordering.dependsOn(yielded, completion))
      return true;
  }
  return false;
}

static bool loopBackedgeOrders(const AllocInterval &later,
                               const AllocInterval &earlier, scf::ForOp loop,
                               TokenOrdering &ordering) {
  if (later.hasUntrackedAccess || earlier.hasUntrackedAccess)
    return false;
  scf::YieldOp yield = cast<scf::YieldOp>(loop.getBody()->getTerminator());
  for (Operation *access : earlier.accesses) {
    SmallVector<unsigned, 2> carried =
        collectAccessCarriedIndices(access, loop, ordering.getOrigins());
    for (Value completion : later.completionTokens)
      if (!yieldOrdersCompletion(
              yield, carried, completion, access, loop,
              /*requireCollectiveBarrier=*/!later.collectivelyComplete,
              ordering))
        return false;
  }
  return true;
}

static SmallVector<Region *, 2>
getCommonEnclosingRepetitiveRegions(Operation *lhs, Operation *rhs) {
  SmallPtrSet<Region *, 4> lhsRegions;
  for (Region *region = lhs->getParentRegion(); region;) {
    Operation *parent = region->getParentOp();
    RegionBranchOpInterface branch = dyn_cast<RegionBranchOpInterface>(parent);
    if (branch && branch.isRepetitiveRegion(region->getRegionNumber()))
      lhsRegions.insert(region);
    region = parent->getParentRegion();
  }

  SmallVector<Region *, 2> common;
  for (Region *region = rhs->getParentRegion(); region;) {
    Operation *parent = region->getParentOp();
    RegionBranchOpInterface branch = dyn_cast<RegionBranchOpInterface>(parent);
    if (branch && branch.isRepetitiveRegion(region->getRegionNumber()) &&
        lhsRegions.contains(region))
      common.push_back(region);
    region = parent->getParentRegion();
  }
  return common;
}

static bool repeatedLifetimeNeedsBarrier(AllocInterval &interval,
                                         TokenOrdering &ordering) {
  SmallVector<Region *, 2> regions =
      getCommonEnclosingRepetitiveRegions(interval.op, interval.op);
  if (regions.empty() || interval.collectivelyComplete)
    return false;
  for (Region *region : regions) {
    scf::ForOp loop = dyn_cast<scf::ForOp>(region->getParentOp());
    if (!loop || !loopBackedgeOrders(interval, interval, loop, ordering))
      return true;
  }
  return false;
}

static std::optional<scf::ForOp> getDirectRepeatedFor(AllocInterval &interval) {
  SmallVector<Region *, 2> regions =
      getCommonEnclosingRepetitiveRegions(interval.op, interval.op);
  if (regions.size() != 1)
    return std::nullopt;
  scf::ForOp loop = dyn_cast<scf::ForOp>(regions.front()->getParentOp());
  if (!loop || interval.release->getBlock() != loop.getBody())
    return std::nullopt;
  if (llvm::any_of(interval.accesses, [&](Operation *access) {
        return access->getBlock() != loop.getBody();
      }))
    return std::nullopt;
  return loop;
}

static bool canAddTokenDependency(Operation *access) {
  if (isa<LoadOp, StoreOp, waveamd::TransposeLoadOp>(access))
    return true;
  return llvm::any_of(access->getOperands(), [](Value operand) {
    return isa<MemTokenType>(operand.getType());
  });
}

static bool tokenOnlyEndsAtUnusedLoopYield(Value token, scf::ForOp loop,
                                           DenseSet<Value> &visited) {
  if (!visited.insert(token).second)
    return true;
  for (OpOperand &use : token.getUses()) {
    Operation *user = use.getOwner();
    if (user == loop.getBody()->getTerminator()) {
      if (!loop.getResult(use.getOperandNumber()).use_empty())
        return false;
      continue;
    }
    if (!isa<AfterOp, JoinOp>(user))
      return false;
    for (Value result : user->getResults())
      if (isa<MemTokenType>(result.getType()) &&
          !tokenOnlyEndsAtUnusedLoopYield(result, loop, visited))
        return false;
  }
  return true;
}

static bool tokenOnlyEndsAtUnusedLoopYield(Value token, scf::ForOp loop) {
  DenseSet<Value> visited;
  return tokenOnlyEndsAtUnusedLoopYield(token, loop, visited);
}

static void addTokenDependency(IRRewriter &rewriter, Operation *access,
                               Value dependency) {
  rewriter.setInsertionPoint(access);
  Value previous;
  OpOperand *genericDependency = nullptr;
  if (auto load = dyn_cast<LoadOp>(access))
    previous = load.getDependency();
  else if (auto store = dyn_cast<StoreOp>(access))
    previous = store.getDependency();
  else if (auto load = dyn_cast<waveamd::TransposeLoadOp>(access))
    previous = load.getDependency();
  else {
    auto dependencyOperand =
        llvm::find_if(access->getOpOperands(), [](OpOperand &operand) {
          return isa<MemTokenType>(operand.get().getType());
        });
    assert(dependencyOperand != access->getOpOperands().end());
    genericDependency = &*dependencyOperand;
    previous = genericDependency->get();
  }

  Value combined = dependency;
  if (previous && previous != dependency)
    combined = JoinOp::create(rewriter, access->getLoc(), dependency.getType(),
                              ValueRange{previous, dependency});

  if (auto load = dyn_cast<LoadOp>(access))
    load.getDependencyMutable().assign(combined);
  else if (auto store = dyn_cast<StoreOp>(access))
    store.getDependencyMutable().assign(combined);
  else if (auto load = dyn_cast<waveamd::TransposeLoadOp>(access))
    load.getDependencyMutable().assign(combined);
  else
    genericDependency->set(combined);
}

static std::optional<unsigned>
findLoopHeaderCarry(scf::ForOp loop, ArrayRef<AllocInterval *> intervals,
                    TokenOrdering &ordering) {
  SmallVector<Value> completions;
  completions.reserve(intervals.size());
  for (AllocInterval *interval : intervals)
    completions.push_back(interval->release.getToken());

  scf::YieldOp yield = cast<scf::YieldOp>(loop.getBody()->getTerminator());
  for (auto [index, yielded] : llvm::enumerate(yield.getOperands())) {
    if (!isa<MemTokenType>(yielded.getType()) ||
        !loop.getResult(index).use_empty() ||
        !ordering.dependsOnAll(yielded, completions,
                               /*requireBarrier=*/false))
      continue;
    return index;
  }
  return std::nullopt;
}

static SmallVector<AllocInterval *> collectLoopLifetimeClosure(
    scf::ForOp loop, ArrayRef<AllocInterval *> terminalIntervals,
    MutableArrayRef<AllocInterval> allIntervals, TokenOrdering &ordering) {
  SmallVector<AllocInterval *> closure;
  for (AllocInterval &candidate : allIntervals) {
    if (!candidate.release)
      continue;
    std::optional<scf::ForOp> owner = getDirectRepeatedFor(candidate);
    if (!owner || owner->getOperation() != loop.getOperation() ||
        !candidate.release.getWorkgroupCollectiveAttr() ||
        !llvm::all_of(candidate.accesses, canAddTokenDependency))
      continue;
    if (llvm::any_of(terminalIntervals, [&](AllocInterval *terminal) {
          return ordering.dependsOn(terminal->release.getToken(),
                                    candidate.release.getToken());
        }))
      closure.push_back(&candidate);
  }
  return closure;
}

static SmallVector<Operation *>
collectLoopLifetimeEntryAccesses(ArrayRef<AllocInterval *> intervals,
                                 TokenOrdering &ordering) {
  SmallVector<Value> accessTokens;
  for (AllocInterval *interval : intervals)
    for (Operation *access : interval->accesses)
      llvm::append_range(accessTokens, getTokenResults(access));

  SmallVector<Operation *> entries;
  SmallPtrSet<Operation *, 8> seen;
  for (AllocInterval *interval : intervals) {
    for (Operation *access : interval->accesses) {
      bool followsAccess = llvm::any_of(accessTokens, [&](Value token) {
        return operationDependsOnAll(access, {token}, ordering,
                                     /*requireBarrier=*/false);
      });
      if (!followsAccess && seen.insert(access).second)
        entries.push_back(access);
    }
  }
  return entries;
}

static LogicalResult
materializeNewLoopLifetimeCarry(IRRewriter &rewriter, scf::ForOp loop,
                                ArrayRef<AllocInterval *> terminalIntervals,
                                ArrayRef<AllocInterval *> loopLifetimes,
                                TokenOrdering &ordering) {
  Type tokenType = terminalIntervals.front()->release.getToken().getType();
  SmallVector<Value> completions;
  completions.reserve(terminalIntervals.size());
  for (AllocInterval *interval : terminalIntervals)
    completions.push_back(interval->release.getToken());
  SmallVector<Operation *> entries =
      collectLoopLifetimeEntryAccesses(loopLifetimes, ordering);
  assert(!entries.empty() && "allocation recurrence must have an entry");

  rewriter.setInsertionPoint(loop);
  Value initial =
      TokenOp::create(rewriter, loop.getLoc(), tokenType).getResult();
  NewYieldValuesFn yieldValues =
      [completions = std::move(completions),
       tokenType](OpBuilder &builder, Location loc,
                  ArrayRef<BlockArgument>) -> SmallVector<Value> {
    Value completed =
        BarrierOp::create(builder, loc, tokenType, completions).getToken();
    return {completed};
  };
  FailureOr<LoopLikeOpInterface> replacement = loop.replaceWithAdditionalYields(
      rewriter, initial, /*replaceInitOperandUsesInLoop=*/false, yieldValues);
  if (failed(replacement))
    return failure();

  scf::ForOp newLoop = cast<scf::ForOp>(replacement->getOperation());
  Value carried = newLoop.getRegionIterArgs().back();
  // Backedge token is allocator-private; source operations stay value-only.
  for (Operation *access : entries)
    addTokenDependency(rewriter, access, carried);
  return success();
}

static void
materializeExistingLoopLifetimeCarry(IRRewriter &rewriter, scf::ForOp loop,
                                     unsigned carry,
                                     ArrayRef<AllocInterval *> loopLifetimes) {
  Operation *firstAccess = loop.getBody()->getTerminator();
  Value carried = loop.getRegionIterArg(carry);
  SmallVector<Operation *> accesses;
  SmallPtrSet<Operation *, 8> seen;
  for (AllocInterval *interval : loopLifetimes) {
    for (Operation *access : interval->accesses) {
      if (seen.insert(access).second)
        accesses.push_back(access);
      if (access->isBeforeInBlock(firstAccess))
        firstAccess = access;
    }
  }
  rewriter.setInsertionPoint(firstAccess);
  Value barrier = BarrierOp::create(rewriter, firstAccess->getLoc(),
                                    carried.getType(), carried)
                      .getToken();
  for (Operation *access : accesses)
    addTokenDependency(rewriter, access, barrier);
}

static LogicalResult
materializeLoopLifetimeCarry(IRRewriter &rewriter, scf::ForOp loop,
                             ArrayRef<AllocInterval *> terminalIntervals,
                             MutableArrayRef<AllocInterval> allIntervals,
                             TokenOrdering &ordering) {
  std::optional<unsigned> carry =
      findLoopHeaderCarry(loop, terminalIntervals, ordering);
  SmallVector<AllocInterval *> loopLifetimes = collectLoopLifetimeClosure(
      loop, terminalIntervals, allIntervals, ordering);
  assert(!loopLifetimes.empty() &&
         "repeated loop lifetime group must contain its triggering interval");
  if (!carry)
    return materializeNewLoopLifetimeCarry(rewriter, loop, terminalIntervals,
                                           loopLifetimes, ordering);
  materializeExistingLoopLifetimeCarry(rewriter, loop, *carry, loopLifetimes);
  return success();
}

using RepeatedLoopIntervalMap =
    DenseMap<Operation *, SmallVector<AllocInterval *, 2>>;

static std::optional<scf::ForOp>
getLoopHeaderBarrierLoop(AllocInterval &interval) {
  std::optional<scf::ForOp> loop = getDirectRepeatedFor(interval);
  if (!loop)
    return std::nullopt;
  if (!tokenOnlyEndsAtUnusedLoopYield(interval.release.getToken(), *loop))
    return std::nullopt;
  if (!llvm::all_of(interval.accesses, canAddTokenDependency))
    return std::nullopt;
  return loop;
}

static LogicalResult collectRepeatedLifetimeBarrierSites(
    MutableArrayRef<AllocInterval> allocs, TokenOrdering &ordering,
    RepeatedLoopIntervalMap &loopIntervals,
    SmallVectorImpl<AllocInterval *> &releaseSiteIntervals) {
  for (AllocInterval &interval : allocs) {
    if (!interval.release)
      continue;
    if (!repeatedLifetimeNeedsBarrier(interval, ordering))
      continue;
    if (!interval.release.getWorkgroupCollectiveAttr()) {
      interval.release.emitOpError(
          "repeated lifetime requires workgroup_collective before barrier "
          "synthesis");
      return failure();
    }
    std::optional<scf::ForOp> loop = getLoopHeaderBarrierLoop(interval);
    if (loop)
      loopIntervals[loop->getOperation()].push_back(&interval);
    else
      releaseSiteIntervals.push_back(&interval);
  }
  return success();
}

static LogicalResult materializeLoopHeaderBarriers(
    IRRewriter &rewriter, MutableArrayRef<AllocInterval> allocs,
    TokenOrdering &ordering, RepeatedLoopIntervalMap &loopIntervals) {
  for (auto &[loopOp, intervals] : loopIntervals) {
    if (failed(materializeLoopLifetimeCarry(rewriter, cast<scf::ForOp>(loopOp),
                                            intervals, allocs, ordering)))
      return failure();
  }
  return success();
}

static void
materializeReleaseSiteBarriers(IRRewriter &rewriter,
                               ArrayRef<AllocInterval *> intervals) {
  for (AllocInterval *interval : intervals) {
    SmallVector<OpOperand *> uses;
    for (OpOperand &use : interval->release.getToken().getUses())
      uses.push_back(&use);
    rewriter.setInsertionPointAfter(interval->release);
    BarrierOp barrier = BarrierOp::create(
        rewriter, interval->release.getLoc(),
        interval->release.getToken().getType(), interval->release.getToken());
    for (OpOperand *use : uses)
      use->set(barrier.getToken());
  }
}

static FailureOr<bool>
materializeRepeatedLifetimeBarriers(IRRewriter &rewriter,
                                    SmallVectorImpl<AllocInterval> &allocs,
                                    TokenOrdering &ordering) {
  RepeatedLoopIntervalMap loopIntervals;
  SmallVector<AllocInterval *> releaseSiteIntervals;
  if (failed(collectRepeatedLifetimeBarrierSites(
          allocs, ordering, loopIntervals, releaseSiteIntervals)))
    return failure();
  if (failed(materializeLoopHeaderBarriers(rewriter, allocs, ordering,
                                           loopIntervals)))
    return failure();
  materializeReleaseSiteBarriers(rewriter, releaseSiteIntervals);
  return !loopIntervals.empty() || !releaseSiteIntervals.empty();
}

static bool usesExplicitLifetime(const AllocInterval &earlier,
                                 const AllocInterval &later) {
  return earlier.release || later.release;
}

static bool canReuseStorage(const AllocInterval &earlier,
                            const AllocInterval &later,
                            TokenOrdering &ordering) {
  if (earlier.end >= later.start)
    return false;
  if (!usesExplicitLifetime(earlier, later))
    return true;
  if (earlier.hasUntrackedAccess || later.hasUntrackedAccess)
    return false;
  for (Operation *access : later.accesses)
    if (!operationDependsOnAll(access, earlier.completionTokens, ordering,
                               /*requireBarrier=*/
                               !earlier.collectivelyComplete))
      return false;
  for (Region *region :
       getCommonEnclosingRepetitiveRegions(earlier.op, later.op)) {
    scf::ForOp loop = dyn_cast<scf::ForOp>(region->getParentOp());
    if (!loop || !loopBackedgeOrders(later, earlier, loop, ordering))
      return false;
  }
  return true;
}

static FailureOr<int64_t> findAvailableOffset(ArrayRef<PlacedAllocation> active,
                                              int64_t baseOffset,
                                              const AllocInterval &interval) {
  FailureOr<int64_t> aligned = alignUp(baseOffset, interval.align);
  if (failed(aligned))
    return failure();
  int64_t offset = *aligned;
  for (const PlacedAllocation &entry : active) {
    if (entry.offset <= std::numeric_limits<int64_t>::max() - entry.bytes &&
        entry.offset + entry.bytes <= offset)
      continue;
    if (offset <= std::numeric_limits<int64_t>::max() - interval.bytes &&
        offset + interval.bytes <= entry.offset)
      break;
    if (entry.offset > std::numeric_limits<int64_t>::max() - entry.bytes)
      return failure();
    aligned = alignUp(entry.offset + entry.bytes, interval.align);
    if (failed(aligned))
      return failure();
    offset = *aligned;
  }
  if (offset > std::numeric_limits<int64_t>::max() - interval.bytes)
    return failure();
  return offset;
}

static bool overlaps(int64_t offset, int64_t bytes,
                     const PlacedAllocation &entry) {
  return offset < entry.offset + entry.bytes && entry.offset < offset + bytes;
}

static FailureOr<int64_t> assignOffsets(SmallVectorImpl<AllocInterval> &allocs,
                                        int64_t baseOffset,
                                        TokenOrdering &ordering) {
  SmallVector<unsigned> order;
  order.reserve(allocs.size());
  for (unsigned i = 0, e = allocs.size(); i != e; ++i)
    order.push_back(i);
  llvm::stable_sort(order, [&](unsigned lhs, unsigned rhs) {
    if (allocs[lhs].start != allocs[rhs].start)
      return allocs[lhs].start < allocs[rhs].start;
    return lhs < rhs;
  });

  SmallVector<PlacedAllocation, 8> placed;
  int64_t highWater = baseOffset;
  for (unsigned index : order) {
    AllocInterval &interval = allocs[index];
    SmallVector<PlacedAllocation, 8> active;
    for (const PlacedAllocation &entry : placed)
      if (!canReuseStorage(allocs[entry.index], interval, ordering))
        active.push_back(entry);
    llvm::sort(active,
               [](const PlacedAllocation &lhs, const PlacedAllocation &rhs) {
                 return lhs.offset < rhs.offset;
               });

    FailureOr<int64_t> offset = failure();
    if (interval.fixedOffset) {
      if (*interval.fixedOffset < baseOffset) {
        interval.op.emitOpError("fixed offset overlaps reserved LDS storage");
        return failure();
      }
      if (llvm::any_of(active, [&](const PlacedAllocation &entry) {
            return overlaps(*interval.fixedOffset, interval.bytes, entry);
          })) {
        interval.op.emitOpError("fixed offset overlaps live LDS storage");
        return failure();
      }
      offset = *interval.fixedOffset;
    } else {
      offset = findAvailableOffset(active, baseOffset, interval);
      if (failed(offset)) {
        interval.op.emitOpError("LDS offset arithmetic overflow");
        return failure();
      }
    }

    interval.offset = *offset;
    placed.push_back({*offset, interval.bytes, index});
    highWater = std::max(highWater, *offset + interval.bytes);
  }
  return highWater;
}

static SmallVector<AllocInterval> buildAllocIntervals(ArrayRef<AllocOp> ops) {
  SmallVector<AllocInterval> allocs;
  allocs.reserve(ops.size());
  for (AllocOp op : ops) {
    int64_t bytes = op.getBytesizeAttr().getInt();
    int64_t align = op.getAlignAttr().getInt();
    assert(bytes > 0 && "wave.alloc verifier guarantees positive bytesize");
    assert(align > 0 && "wave.alloc verifier guarantees positive alignment");
    AllocInterval interval;
    interval.op = op;
    interval.bytes = bytes;
    interval.align = align;
    if (IntegerAttr offset = op.getOffsetAttr())
      interval.fixedOffset = offset.getInt();
    allocs.push_back(std::move(interval));
  }
  return allocs;
}

static void eraseAllocationReleases(IRRewriter &rewriter,
                                    SmallVectorImpl<AllocInterval> &allocs) {
  for (AllocInterval &interval : allocs) {
    if (!interval.release)
      continue;
    rewriter.replaceAllUsesWith(interval.release.getToken(),
                                interval.release.getDependency());
    rewriter.eraseOp(interval.release);
  }
}

static void rewriteAllocations(IRRewriter &rewriter,
                               SmallVectorImpl<AllocInterval> &allocs) {
  for (AllocInterval &interval : allocs) {
    rewriter.setInsertionPoint(interval.op);
    SharedMemoryBaseOp base = SharedMemoryBaseOp::create(
        rewriter, interval.op.getLoc(), interval.op.getResult().getType(),
        static_cast<uint64_t>(interval.offset));
    rewriter.replaceOp(interval.op, base.getResult());
  }
}

struct AllocationAnalysis {
  SmallVector<AllocInterval> allocs;
  std::unique_ptr<TokenOrdering> ordering;
  std::unique_ptr<OperationOrder> order;
};

struct AllocationOps {
  SmallVector<AllocOp> allocs;
  SmallVector<AllocReleaseOp> releases;
};

static AllocationOps collectAllocationOps(Operation *root) {
  AllocationOps ops;
  root->walk<WalkOrder::PreOrder>([&](Operation *op) {
    if (AllocOp alloc = dyn_cast<AllocOp>(op))
      ops.allocs.push_back(alloc);
    else if (AllocReleaseOp release = dyn_cast<AllocReleaseOp>(op))
      ops.releases.push_back(release);
  });
  return ops;
}

static LogicalResult analyzeAllocations(func::FuncOp func,
                                        ArrayRef<AllocOp> ops,
                                        ArrayRef<AllocReleaseOp> releases,
                                        AllocationAnalysis &analysis) {
  analysis.order = std::make_unique<OperationOrder>(func);
  analysis.allocs = buildAllocIntervals(ops);
  if (failed(associateReleases(releases, analysis.allocs)))
    return failure();
  analysis.ordering = std::make_unique<TokenOrdering>(buildTokenOrigins(func));
  return collectAllocationIntervals(*analysis.order, *analysis.ordering,
                                    analysis.allocs);
}

static FailureOr<int64_t> getFixedLDSBytes(func::FuncOp func) {
  IntegerAttr attr = func->getAttrOfType<IntegerAttr>("wave.lds_size");
  int64_t bytes = attr ? attr.getInt() : 0;
  if (bytes < 0)
    return func.emitError("wave.lds_size must be non-negative");
  return bytes;
}

static bool isRetiredAtPoint(AllocInterval &interval, Operation *point,
                             unsigned position, Value dependency,
                             TokenOrdering &ordering) {
  if (interval.end >= position)
    return false;
  if (interval.hasUntrackedAccess)
    return false;
  if (interval.completionTokens.empty())
    return true;
  if (!dependency)
    return false;
  if (!getCommonEnclosingRepetitiveRegions(interval.op, point).empty())
    return false;
  return ordering.dependsOnAll(dependency, interval.completionTokens,
                               !interval.collectivelyComplete);
}

static FailureOr<int64_t>
findLargestAlignedGap(ArrayRef<PlacedAllocation> blocked, int64_t baseOffset,
                      int64_t capacity) {
  int64_t cursor = baseOffset;
  int64_t largest = 0;
  for (const PlacedAllocation &entry : blocked) {
    FailureOr<int64_t> aligned = alignUp(cursor, 16);
    if (failed(aligned) ||
        entry.offset > std::numeric_limits<int64_t>::max() - entry.bytes)
      return failure();
    int64_t gapEnd = std::min(entry.offset, capacity);
    if (*aligned < gapEnd)
      largest = std::max(largest, gapEnd - *aligned);
    cursor = std::max(cursor, entry.offset + entry.bytes);
    if (cursor >= capacity)
      return largest;
  }
  FailureOr<int64_t> aligned = alignUp(cursor, 16);
  if (failed(aligned))
    return failure();
  if (*aligned < capacity)
    largest = std::max(largest, capacity - *aligned);
  return largest;
}

static LogicalResult analyzeCurrentAllocations(func::FuncOp func,
                                               int64_t fixedBytes,
                                               AllocationAnalysis &analysis) {
  AllocationOps ops = collectAllocationOps(func);
  if (ops.allocs.empty())
    return success();
  if (failed(analyzeAllocations(func, ops.allocs, ops.releases, analysis)))
    return failure();
  if (failed(assignOffsets(analysis.allocs, fixedBytes, *analysis.ordering)))
    return failure();
  return success();
}

static SmallVector<PlacedAllocation>
collectBlockedAllocations(AllocationAnalysis &analysis, Operation *point,
                          unsigned position, Value dependency) {
  SmallVector<PlacedAllocation> blocked;
  for (auto [index, interval] : llvm::enumerate(analysis.allocs)) {
    if (isRetiredAtPoint(interval, point, position, dependency,
                         *analysis.ordering))
      continue;
    blocked.push_back(
        {interval.offset, interval.bytes, static_cast<unsigned>(index)});
  }
  llvm::sort(blocked,
             [](const PlacedAllocation &lhs, const PlacedAllocation &rhs) {
               return lhs.offset < rhs.offset;
             });
  return blocked;
}

static LogicalResult
appendBlockedRanges(ArrayRef<WaveLDSRange> ranges,
                    SmallVectorImpl<PlacedAllocation> &blocked) {
  for (WaveLDSRange range : ranges) {
    if (range.offset < 0 || range.bytes <= 0 ||
        range.offset > std::numeric_limits<int64_t>::max() - range.bytes)
      return failure();
    blocked.push_back({range.offset, range.bytes, 0});
  }
  llvm::sort(blocked,
             [](const PlacedAllocation &lhs, const PlacedAllocation &rhs) {
               return lhs.offset < rhs.offset;
             });
  return success();
}

static LogicalResult materializeAndReanalyzeRepeatedLifetimes(
    func::FuncOp func, ArrayRef<AllocOp> ops, ArrayRef<AllocReleaseOp> releases,
    IRRewriter &rewriter, AllocationAnalysis &analysis) {
  FailureOr<bool> materialized = materializeRepeatedLifetimeBarriers(
      rewriter, analysis.allocs, *analysis.ordering);
  if (failed(materialized))
    return failure();
  if (!*materialized)
    return success();
  return analyzeAllocations(func, ops, releases, analysis);
}

static LogicalResult resolveFuncAllocs(func::FuncOp func,
                                       IRRewriter &rewriter) {
  if (func.isExternal())
    return success();

  AllocationOps ops = collectAllocationOps(func);
  if (ops.allocs.empty() && ops.releases.empty())
    return success();

  FailureOr<int64_t> fixedBytes = getFixedLDSBytes(func);
  if (failed(fixedBytes))
    return failure();

  AllocationAnalysis analysis;
  if (failed(analyzeAllocations(func, ops.allocs, ops.releases, analysis)))
    return failure();
  if (failed(materializeAndReanalyzeRepeatedLifetimes(
          func, ops.allocs, ops.releases, rewriter, analysis)))
    return failure();

  FailureOr<int64_t> plannedBytes =
      assignOffsets(analysis.allocs, *fixedBytes, *analysis.ordering);
  if (failed(plannedBytes))
    return failure();

  eraseAllocationReleases(rewriter, analysis.allocs);
  rewriteAllocations(rewriter, analysis.allocs);

  OpBuilder builder(func.getContext());
  func->setAttr("wave.lds_size", builder.getI64IntegerAttr(*plannedBytes));
  return success();
}

struct WaveResolveAllocsPass
    : public wave::impl::WaveResolveAllocsBase<WaveResolveAllocsPass> {
  void runOnOperation() override {
    Operation *root = getOperation();
    IRRewriter rewriter(root->getContext());

    SmallVector<func::FuncOp> funcs;
    if (auto func = dyn_cast<func::FuncOp>(root)) {
      funcs.push_back(func);
    } else {
      root->walk([&](func::FuncOp func) { funcs.push_back(func); });
    }

    for (func::FuncOp func : funcs) {
      if (failed(resolveFuncAllocs(func, rewriter)))
        return signalPassFailure();
    }
  }
};

} // namespace

struct mlir::wave::WaveLDSAllocationAnalysis::Impl {
  AllocationAnalysis analysis;
  DenseMap<std::pair<Operation *, Value>, SmallVector<PlacedAllocation>>
      blockedCache;
  func::FuncOp func;
  int64_t fixedBytes = 0;
};

WaveLDSAllocationAnalysis::WaveLDSAllocationAnalysis(std::unique_ptr<Impl> impl)
    : impl(std::move(impl)) {}

WaveLDSAllocationAnalysis::~WaveLDSAllocationAnalysis() = default;

FailureOr<std::unique_ptr<WaveLDSAllocationAnalysis>>
WaveLDSAllocationAnalysis::create(func::FuncOp func) {
  FailureOr<int64_t> fixedBytes = getFixedLDSBytes(func);
  if (failed(fixedBytes))
    return failure();
  auto impl = std::make_unique<Impl>();
  impl->func = func;
  impl->fixedBytes = *fixedBytes;
  if (failed(analyzeCurrentAllocations(func, *fixedBytes, impl->analysis)))
    return failure();
  return std::unique_ptr<WaveLDSAllocationAnalysis>(
      new WaveLDSAllocationAnalysis(std::move(impl)));
}

FailureOr<int64_t> WaveLDSAllocationAnalysis::getLargestFreeRange(
    Operation *point, int64_t capacity, Value dependency,
    ArrayRef<WaveLDSRange> extraBlocked) {
  if (capacity <= impl->fixedBytes)
    return 0;
  auto [cached, inserted] = impl->blockedCache.try_emplace({point, dependency});
  if (inserted && !impl->analysis.allocs.empty())
    cached->second = collectBlockedAllocations(
        impl->analysis, point, impl->analysis.order->lookup(point), dependency);
  SmallVector<PlacedAllocation> blocked = cached->second;
  if (failed(appendBlockedRanges(extraBlocked, blocked)))
    return impl->func.emitError("invalid provisional LDS range");
  FailureOr<int64_t> largest =
      findLargestAlignedGap(blocked, impl->fixedBytes, capacity);
  if (failed(largest))
    return impl->func.emitError("failed to analyze available LDS ranges");
  return *largest;
}

FailureOr<int64_t> WaveLDSAllocationAnalysis::findFreeOffset(
    Operation *point, int64_t capacity, int64_t bytes, int64_t align,
    Value dependency, ArrayRef<WaveLDSRange> extraBlocked) {
  if (bytes <= 0 || align <= 0)
    return impl->func.emitError("invalid provisional LDS allocation");
  auto [cached, inserted] = impl->blockedCache.try_emplace({point, dependency});
  if (inserted && !impl->analysis.allocs.empty())
    cached->second = collectBlockedAllocations(
        impl->analysis, point, impl->analysis.order->lookup(point), dependency);
  SmallVector<PlacedAllocation> blocked = cached->second;
  if (failed(appendBlockedRanges(extraBlocked, blocked)))
    return impl->func.emitError("invalid provisional LDS range");
  AllocInterval interval;
  interval.bytes = bytes;
  interval.align = align;
  FailureOr<int64_t> offset =
      findAvailableOffset(blocked, impl->fixedBytes, interval);
  if (failed(offset) || *offset > capacity || bytes > capacity - *offset)
    return impl->func.emitError("failed to place provisional LDS allocation");
  return *offset;
}
