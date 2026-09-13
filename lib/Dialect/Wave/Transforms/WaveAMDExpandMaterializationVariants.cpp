//===- WaveAMDExpandMaterializationVariants.cpp - Candidate regions
//--------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM-exception.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/Wave/Transforms/Passes.h"

#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/Utils/MaterializationVariants.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachine.h"
#include "mlir/IR/IRMapping.h"
#include "mlir/IR/PatternMatch.h"
#include "mlir/IR/Threading.h"
#include "mlir/Interfaces/ControlFlowInterfaces.h"
#include "mlir/Interfaces/SideEffectInterfaces.h"
#include "mlir/Transforms/RegionUtils.h"
#include "llvm/ADT/DenseSet.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/ADT/SetVector.h"

namespace mlir::wave {
#define GEN_PASS_DEF_WAVEAMDEXPANDMATERIALIZATIONVARIANTS
#include "mlir/Dialect/Wave/Transforms/Passes.h.inc"
} // namespace mlir::wave

using namespace mlir;
using namespace mlir::waveamdmachine;

static constexpr StringLiteral kScheduleInputAttr =
    "waveamdmachine.schedule_input";

namespace {
struct CandidateScope {
  SmallVector<Operation *> operations;
  SmallVector<MaterializationVariantsOp> choices;
  SmallVector<unsigned> choiceDimensions;
  SmallVector<unsigned> dimensionArities;
  llvm::DenseMap<int64_t, unsigned> groupDimensions;
  SmallVector<Value> inputs;
  SmallVector<Value> outputs;
  unsigned count = 1;
};
} // namespace

static bool isScopeExit(Operation &op) {
  return op.hasTrait<OpTrait::IsTerminator>() ||
         isa<SEndpgmOp, SSetpcB64Op>(op);
}

static void collectScopeValues(CandidateScope &scope) {
  llvm::DenseSet<Operation *> internalOps;
  llvm::DenseSet<Value> definitions;
  for (Operation *root : scope.operations)
    root->walk([&](Operation *op) {
      internalOps.insert(op);
      definitions.insert(op->result_begin(), op->result_end());
      for (Region &region : op->getRegions())
        for (Block &block : region)
          definitions.insert(block.args_begin(), block.args_end());
    });
  llvm::SetVector<Value> inputs;
  for (Operation *root : scope.operations) {
    root->walk<WalkOrder::PreOrder>([&](Operation *op) {
      for (Value operand : op->getOperands())
        if (!definitions.contains(operand))
          inputs.insert(operand);
    });
    for (Value result : root->getResults())
      if (llvm::any_of(result.getUses(), [&](OpOperand &use) {
            return !internalOps.contains(use.getOwner());
          }))
        scope.outputs.push_back(result);
  }
  llvm::append_range(scope.inputs, inputs);
}

static LogicalResult checkScope(unsigned limit, CandidateScope &scope) {
  for (Operation *op : scope.operations) {
    WalkResult walk = op->walk<WalkOrder::PreOrder>([&](Operation *nested) {
      if (isa<MaterializationCandidatesOp>(nested)) {
        nested->emitOpError("cannot nest candidate expansion scopes");
        return WalkResult::interrupt();
      }
      if (auto choice = dyn_cast<MaterializationVariantsOp>(nested))
        scope.choices.push_back(choice);
      return WalkResult::advance();
    });
    if (walk.wasInterrupted())
      return failure();
  }
  for (MaterializationVariantsOp choice : scope.choices) {
    unsigned arity = choice.getChoices().size();
    auto group =
        choice->getAttrOfType<IntegerAttr>(kMaterializationChoiceGroupAttrName);
    unsigned dimension;
    if (!group) {
      dimension = scope.dimensionArities.size();
      scope.dimensionArities.push_back(arity);
    } else {
      auto [it, inserted] = scope.groupDimensions.try_emplace(
          group.getInt(), scope.dimensionArities.size());
      dimension = it->second;
      if (inserted)
        scope.dimensionArities.push_back(arity);
      else if (scope.dimensionArities[dimension] != arity)
        return choice.emitOpError(
            "materialization choices in one group must have equal arity");
    }
    scope.choiceDimensions.push_back(dimension);
  }
  for (unsigned arity : scope.dimensionArities) {
    scope.count = arity > limit / scope.count ? limit : scope.count * arity;
  }
  return success();
}

static Operation *scopeRoot(Operation *op) {
  while (!op->getParentOp()->hasTrait<OpTrait::IsIsolatedFromAbove>())
    op = op->getParentOp();
  return op;
}

static void appendPredecessors(RegionBranchOpInterface branch,
                               RegionSuccessor successor, Value value,
                               SmallVectorImpl<Value> &pending) {
  ValueRange inputs = branch.getSuccessorInputs(successor);
  auto found = llvm::find(inputs, value);
  if (found != inputs.end())
    branch.getPredecessorValues(successor, found - inputs.begin(), pending);
}

static llvm::DenseSet<Operation *>
collectChoiceSetup(ArrayRef<MaterializationVariantsOp> choices) {
  SmallVector<Value> pending;
  for (MaterializationVariantsOp choice : choices)
    llvm::append_range(pending, choice.getChoices());
  llvm::DenseSet<Value> visited;
  llvm::DenseSet<Operation *> setup;
  while (!pending.empty()) {
    Value value = pending.pop_back_val();
    if (!visited.insert(value).second)
      continue;
    if (auto arg = dyn_cast<BlockArgument>(value)) {
      if (auto branch =
              dyn_cast<RegionBranchOpInterface>(arg.getOwner()->getParentOp()))
        appendPredecessors(branch, RegionSuccessor(arg.getOwner()->getParent()),
                           value, pending);
      continue;
    }
    Operation *def = value.getDefiningOp();
    bool markedAlternative =
        def && def->hasAttr(kMaterializationAlternativeAttrName);
    if (auto branch = dyn_cast<RegionBranchOpInterface>(def)) {
      if (isMemoryEffectFree(def) || markedAlternative)
        setup.insert(def);
      appendPredecessors(branch, RegionSuccessor(def), value, pending);
      continue;
    }
    if (def->hasTrait<OpTrait::ConstantLike>() ||
        (!isMemoryEffectFree(def) && !markedAlternative))
      continue;
    setup.insert(def);
    llvm::append_range(pending, def->getOperands());
  }
  return setup;
}

namespace {
struct ScopeNode {
  SmallVector<unsigned> producers;
  SmallVector<unsigned> consumers;
  unsigned parent;
  unsigned end;
  unsigned remaining = 0;
  bool active = false;
  bool setup = false;
};

class ScopeFormation {
public:
  ScopeFormation(Block &block, const llvm::DenseSet<Operation *> &setup) {
    for (Operation &op : block) {
      indices[&op] = operations.size();
      unsigned index = operations.size();
      operations.push_back(&op);
      nodes.push_back({{}, {}, index, index, 0, false, setup.contains(&op)});
    }
    collectDependencies(block);
  }

  void seed(Operation *op) { activate(indices.lookup(op)); }

  void form(SmallVectorImpl<CandidateScope> &scopes) {
    while (!pending.empty()) {
      unsigned index = pending.pop_back_val();
      for (unsigned consumer : nodes[index].consumers)
        if (!isScopeExit(*operations[consumer]))
          merge(index, consumer);
      for (unsigned producer : nodes[index].producers) {
        ScopeNode &node = nodes[producer];
        --node.remaining;
        if (node.active || (node.setup && node.remaining == 0))
          merge(producer, index);
      }
    }
    for (unsigned i = 0; i < nodes.size();) {
      unsigned end = nodes[find(i)].end + 1;
      if (nodes[i].active) {
        scopes.emplace_back();
        llvm::append_range(scopes.back().operations,
                           ArrayRef(operations).slice(i, end - i));
      }
      i = end;
    }
  }

private:
  void collectDependencies(Block &block) {
    for (auto [index, op] : llvm::enumerate(operations)) {
      llvm::SetVector<unsigned> producers;
      op->walk([&](Operation *nested) {
        for (Value operand : nested->getOperands()) {
          Operation *def = operand.getDefiningOp();
          Operation *root = def ? block.findAncestorOpInBlock(*def) : nullptr;
          if (root && root != op)
            producers.insert(indices.lookup(root));
        }
      });
      for (unsigned producer : producers) {
        nodes[index].producers.push_back(producer);
        nodes[producer].consumers.push_back(index);
      }
      // Cross-block users keep setup outside the candidates.
      for (Value result : op->getResults())
        if (llvm::any_of(result.getUsers(), [&](Operation *user) {
              return !block.findAncestorOpInBlock(*user);
            }))
          ++nodes[index].remaining;
    }
    for (ScopeNode &node : nodes)
      node.remaining += node.consumers.size();
  }

  unsigned find(unsigned index) {
    while (nodes[index].parent != index) {
      nodes[index].parent = nodes[nodes[index].parent].parent;
      index = nodes[index].parent;
    }
    return index;
  }

  void activate(unsigned index) {
    if (nodes[index].active)
      return;
    nodes[index].active = true;
    pending.push_back(index);
  }

  void merge(unsigned lhs, unsigned rhs) {
    lhs = find(lhs);
    rhs = find(rhs);
    if (lhs > rhs)
      std::swap(lhs, rhs);
    activate(lhs);
    // Consume interval roots once; intervening effects retain lexical order.
    while (nodes[lhs].end < nodes[rhs].end) {
      unsigned next = nodes[lhs].end + 1;
      activate(next);
      nodes[lhs].end = nodes[next].end;
      nodes[next].parent = lhs;
    }
  }

  SmallVector<Operation *> operations;
  SmallVector<ScopeNode> nodes;
  SmallVector<unsigned> pending;
  llvm::DenseMap<Operation *, unsigned> indices;
};
} // namespace

static LogicalResult checkBlockExits(Block &block) {
  bool sawExit = false;
  for (Operation &op : block) {
    if (isScopeExit(op))
      sawExit = true;
    else if (sawExit)
      return op.emitOpError(
          "cannot expand a block with operations after its exit");
  }
  return success();
}

static LogicalResult populateCandidate(const CandidateScope &scope,
                                       unsigned ordinal, Region &region) {
  IRMapping mapping;
  mapping.map(scope.inputs, region.front().getArguments());
  OpBuilder builder = OpBuilder::atBlockEnd(&region.front());
  for (Operation *op : scope.operations)
    builder.clone(*op, mapping);
  SmallVector<unsigned> dimensionSelections(scope.dimensionArities.size());
  for (size_t dimension :
       llvm::reverse(llvm::seq(scope.dimensionArities.size()))) {
    dimensionSelections[dimension] =
        ordinal % scope.dimensionArities[dimension];
    ordinal /= scope.dimensionArities[dimension];
  }
  for (size_t index : llvm::seq(scope.choices.size())) {
    MaterializationVariantsOp source = scope.choices[index];
    unsigned selection = dimensionSelections[scope.choiceDimensions[index]];
    auto choice = cast<MaterializationVariantsOp>(
        mapping.lookup(source.getResult()).getDefiningOp());
    Value selected = choice.getChoices()[selection];
    choice.getResult().replaceAllUsesWith(selected);
    mapping.map(source.getResult(), selected);
    choice.erase();
  }

  SmallVector<Operation *> rejected;
  WalkResult marked = region.walk<WalkOrder::PostOrder>([&](Operation *op) {
    auto group =
        op->getAttrOfType<IntegerAttr>(kMaterializationChoiceGroupAttrName);
    auto alternative =
        op->getAttrOfType<IntegerAttr>(kMaterializationAlternativeAttrName);
    if (!group && !alternative)
      return WalkResult::advance();
    if (!group || !alternative) {
      op->emitOpError("materialization alternative marker is incomplete");
      return WalkResult::interrupt();
    }
    auto dimension = scope.groupDimensions.find(group.getInt());
    if (dimension == scope.groupDimensions.end()) {
      op->emitOpError("materialization alternative has no choice group");
      return WalkResult::interrupt();
    }
    if (alternative.getInt() == dimensionSelections[dimension->second]) {
      op->removeAttr(kMaterializationChoiceGroupAttrName);
      op->removeAttr(kMaterializationAlternativeAttrName);
    } else {
      rejected.push_back(op);
    }
    return WalkResult::advance();
  });
  if (marked.wasInterrupted())
    return failure();
  for (Operation *op : llvm::reverse(rejected)) {
    if (!op->use_empty())
      return op->emitOpError(
          "rejected materialization alternative still has a live use");
    op->erase();
  }
  SmallVector<Value> outputs;
  for (Value value : scope.outputs)
    outputs.push_back(mapping.lookup(value));
  CandidateYieldOp::create(builder, scope.operations.back()->getLoc(), outputs,
                           IntegerAttr{});
  IRRewriter rewriter(builder.getContext());
  eliminateTriviallyDeadOps(rewriter, region);
  return success();
}

static LogicalResult expandScope(CandidateScope &scope) {
  collectScopeValues(scope);
  Operation *first = scope.operations.front();
  OpBuilder builder(first);
  SmallVector<Type> outputTypes;
  for (Value value : scope.outputs)
    outputTypes.push_back(value.getType());
  auto wrapper = MaterializationCandidatesOp::create(
      builder, first->getLoc(), outputTypes, scope.inputs, scope.count);
  for (Region &region : wrapper.getCandidates()) {
    Block *block = new Block;
    region.push_back(block);
    for (Value input : scope.inputs)
      block->addArgument(input.getType(), input.getLoc());
  }
  // Shared input use lists stay fixed while workers clone private regions.
  std::atomic<bool> failedCandidate = false;
  parallelFor(first->getContext(), 0, scope.count, [&](size_t ordinal) {
    if (failed(populateCandidate(scope, ordinal,
                                 wrapper.getCandidates()[ordinal])))
      failedCandidate.store(true, std::memory_order_relaxed);
  });
  if (failedCandidate.load(std::memory_order_relaxed))
    return failure();
  for (auto [source, result] :
       llvm::zip_equal(scope.outputs, wrapper.getResults()))
    source.replaceAllUsesWith(result);
  for (Operation *op : llvm::reverse(scope.operations))
    op->erase();
  return success();
}

namespace {
struct WaveAMDExpandMaterializationVariantsPass
    : wave::impl::WaveAMDExpandMaterializationVariantsBase<
          WaveAMDExpandMaterializationVariantsPass> {
  using WaveAMDExpandMaterializationVariantsBase::
      WaveAMDExpandMaterializationVariantsBase;
  void runOnOperation() override {
    if (maxCandidates == 0) {
      getOperation()->emitError("max-candidates must be positive");
      return signalPassFailure();
    }
    llvm::SetVector<Block *> blocks;
    llvm::SetVector<func::FuncOp> scheduleInputs;
    SmallVector<MaterializationVariantsOp> choices;
    llvm::DenseMap<Block *, SmallVector<Operation *>> roots;
    WalkResult walk = getOperation()->walk([&](MaterializationVariantsOp op) {
      if (op->getParentOfType<MaterializationCandidatesOp>()) {
        op.emitOpError("cannot expand choices inside an existing candidate");
        return WalkResult::interrupt();
      }
      choices.push_back(op);
      func::FuncOp func = op->getParentOfType<func::FuncOp>();
      if (!func) {
        op.emitOpError("must be nested in a function");
        return WalkResult::interrupt();
      }
      scheduleInputs.insert(func);
      Operation *root = scopeRoot(op);
      blocks.insert(root->getBlock());
      roots[root->getBlock()].push_back(root);
      return WalkResult::advance();
    });
    if (walk.wasInterrupted())
      return signalPassFailure();
    llvm::DenseSet<Operation *> setup = collectChoiceSetup(choices);
    SmallVector<CandidateScope, 0> scopes;
    for (Block *block : blocks) {
      if (failed(checkBlockExits(*block)))
        return signalPassFailure();
      ScopeFormation formation(*block, setup);
      for (Operation *root : roots.lookup(block))
        formation.seed(root);
      formation.form(scopes);
    }
    for (CandidateScope &scope : scopes)
      if (failed(checkScope(maxCandidates, scope)))
        return signalPassFailure();
    for (CandidateScope &scope : scopes)
      if (failed(expandScope(scope)))
        return signalPassFailure();
    for (func::FuncOp func : scheduleInputs)
      func->setAttr(kScheduleInputAttr, UnitAttr::get(func.getContext()));
  }
};
} // namespace
