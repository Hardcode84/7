//===- WaveAMDExpandMaterializationVariants.cpp - Candidate regions
//--------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM-exception.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/Wave/Transforms/Passes.h"

#include "mlir/Dialect/Utils/MaterializationVariants.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachine.h"
#include "mlir/IR/IRMapping.h"
#include "mlir/IR/PatternMatch.h"
#include "mlir/IR/Threading.h"
#include "mlir/Interfaces/ControlFlowInterfaces.h"
#include "mlir/Interfaces/SideEffectInterfaces.h"
#include "mlir/Pass/PassManager.h"
#include "mlir/Pass/PassRegistry.h"
#include "mlir/Transforms/Passes.h"
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

namespace {
using EffectAlternative = SmallVector<Operation *>;
using EffectAlternatives = SmallVector<EffectAlternative>;
using ChoiceEffects = llvm::DenseMap<Operation *, EffectAlternatives>;

struct CandidateScope {
  SmallVector<Operation *> operations;
  SmallVector<MaterializationVariantsOp> choices;
  SmallVector<unsigned> choiceDimensions;
  SmallVector<unsigned> dimensionArities;
  SmallVector<EffectAlternatives> dimensionEffectProducers;
  SmallVector<SmallVector<unsigned>> assignments;
  SmallVector<Value> inputs;
  SmallVector<Value> outputs;
};
} // namespace

static void appendPredecessors(RegionBranchOpInterface branch,
                               RegionSuccessor successor, Value value,
                               SmallVectorImpl<Value> &pending) {
  ValueRange inputs = branch.getSuccessorInputs(successor);
  auto found = llvm::find(inputs, value);
  if (found != inputs.end())
    branch.getPredecessorValues(successor, found - inputs.begin(), pending);
}

struct EffectTrace {
  EffectAlternative effects;
  llvm::DenseSet<Value> tokens;
};

static EffectTrace
collectEffectAncestors(Value root,
                       const llvm::DenseSet<Value> &sharedTokens = {}) {
  SmallVector<Value> pending{root};
  llvm::DenseSet<Value> visited;
  llvm::SetVector<Operation *> effects;
  while (!pending.empty()) {
    Value value = pending.pop_back_val();
    if (!visited.insert(value).second)
      continue;
    bool isToken = isa<MemTokenType>(value.getType());
    if (isToken && sharedTokens.contains(value))
      continue;
    if (auto arg = dyn_cast<BlockArgument>(value)) {
      if (auto branch =
              dyn_cast<RegionBranchOpInterface>(arg.getOwner()->getParentOp()))
        appendPredecessors(branch, RegionSuccessor(arg.getOwner()->getParent()),
                           value, pending);
      continue;
    }
    Operation *def = value.getDefiningOp();
    if (!def)
      continue;
    // Address operands are setup for this effect, not earlier effects owned by
    // the alternative. Follow only explicit memory-token dependencies beyond
    // an effect. Shared tokens form the boundary between an alternative and
    // the memory history that all alternatives depend on.
    if (!isMemoryEffectFree(def)) {
      effects.insert(def);
      llvm::copy_if(
          def->getOperands(), std::back_inserter(pending),
          [](Value operand) { return isa<MemTokenType>(operand.getType()); });
      continue;
    }
    if (auto branch = dyn_cast<RegionBranchOpInterface>(def)) {
      appendPredecessors(branch, RegionSuccessor(def), value, pending);
      continue;
    }
    llvm::append_range(pending, def->getOperands());
  }
  EffectTrace trace;
  trace.effects = effects.takeVector();
  for (Value value : visited)
    if (isa<MemTokenType>(value.getType()))
      trace.tokens.insert(value);
  return trace;
}

static EffectAlternatives
collectAlternativeEffects(MaterializationVariantsOp choice) {
  SmallVector<EffectTrace> provisional;
  for (Value value : choice.getChoices())
    provisional.push_back(collectEffectAncestors(value));

  llvm::DenseSet<Value> sharedTokens;
  if (!provisional.empty()) {
    sharedTokens = provisional.front().tokens;
    SmallVector<Value> uniqueTokens;
    for (Value token : sharedTokens)
      if (llvm::any_of(llvm::drop_begin(provisional),
                       [&](const EffectTrace &trace) {
                         return !trace.tokens.contains(token);
                       }))
        uniqueTokens.push_back(token);
    for (Value token : uniqueTokens)
      sharedTokens.erase(token);
    // A cyclic dependency can make an alternative's result reachable from a
    // sibling result. Roots are selections, never shared dependency bounds.
    for (Value value : choice.getChoices())
      sharedTokens.erase(value);
  }

  EffectAlternatives alternatives;
  llvm::DenseMap<Operation *, unsigned> occurrences;
  for (Value value : choice.getChoices()) {
    alternatives.push_back(collectEffectAncestors(value, sharedTokens).effects);
    for (Operation *effect : alternatives.back())
      ++occurrences[effect];
  }
  for (EffectAlternative &alternative : alternatives)
    llvm::erase_if(alternative, [&](Operation *effect) {
      return occurrences.lookup(effect) == alternatives.size();
    });
  return alternatives;
}

static bool hasAlternativeEffects(const EffectAlternatives &effects) {
  return llvm::any_of(
      effects, [](const EffectAlternative &ops) { return !ops.empty(); });
}

static std::optional<unsigned>
findCoupledDimension(const CandidateScope &scope,
                     const EffectAlternatives &effects) {
  if (!hasAlternativeEffects(effects))
    return std::nullopt;
  for (auto [dimension, existing] :
       llvm::enumerate(scope.dimensionEffectProducers))
    if (existing == effects)
      return dimension;
  return std::nullopt;
}

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

static SmallVector<unsigned> decodeAssignment(ArrayRef<unsigned> arities,
                                              unsigned ordinal) {
  SmallVector<unsigned> assignment(arities.size());
  for (size_t dimension : llvm::reverse(llvm::seq(arities.size()))) {
    assignment[dimension] = ordinal % arities[dimension];
    ordinal /= arities[dimension];
  }
  return assignment;
}

static void addAssignment(CandidateScope &scope, ArrayRef<unsigned> assignment,
                          unsigned limit) {
  if (scope.assignments.size() == limit ||
      llvm::is_contained(scope.assignments, assignment))
    return;
  scope.assignments.emplace_back(assignment);
}

static bool buildAssignments(unsigned limit, CandidateScope &scope) {
  unsigned product = 1;
  bool bounded = false;
  for (unsigned arity : scope.dimensionArities) {
    if (arity > limit / product) {
      bounded = true;
      break;
    }
    product *= arity;
  }
  if (!bounded) {
    for (unsigned ordinal = 0; ordinal < product; ++ordinal)
      scope.assignments.push_back(
          decodeAssignment(scope.dimensionArities, ordinal));
    return false;
  }

  SmallVector<unsigned> baseline(scope.dimensionArities.size(), 0);
  addAssignment(scope, baseline, limit);

  unsigned maxArity = *llvm::max_element(scope.dimensionArities);
  for (unsigned alternative = 1;
       alternative < maxArity && scope.assignments.size() < limit;
       ++alternative) {
    SmallVector<unsigned> coherent;
    coherent.reserve(scope.dimensionArities.size());
    for (unsigned arity : scope.dimensionArities)
      coherent.push_back(alternative % arity);
    addAssignment(scope, coherent, limit);
  }

  for (auto [dimension, arity] : llvm::enumerate(scope.dimensionArities)) {
    for (unsigned alternative = 1;
         alternative < arity && scope.assignments.size() < limit;
         ++alternative) {
      SmallVector<unsigned> assignment = baseline;
      assignment[dimension] = alternative;
      addAssignment(scope, assignment, limit);
    }
  }

  for (unsigned ordinal = 0; scope.assignments.size() < limit; ++ordinal)
    addAssignment(scope, decodeAssignment(scope.dimensionArities, ordinal),
                  limit);
  return true;
}

static LogicalResult checkScope(unsigned limit, CandidateScope &scope,
                                const ChoiceEffects &choiceEffects) {
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
    const EffectAlternatives &effects = choiceEffects.lookup(choice);
    std::optional<unsigned> coupled = findCoupledDimension(scope, effects);
    unsigned dimension = 0;
    if (!coupled) {
      dimension = scope.dimensionArities.size();
      scope.dimensionArities.push_back(arity);
      scope.dimensionEffectProducers.push_back(effects);
    } else {
      dimension = *coupled;
      if (scope.dimensionArities[dimension] != arity)
        return choice.emitOpError("coupled access results must have equal "
                                  "alternative counts");
    }
    scope.choiceDimensions.push_back(dimension);
  }
  if (buildAssignments(limit, scope))
    scope.choices.front().emitRemark() << "candidate limit reached; exploring "
                                       << limit << " diverse assignments";
  return success();
}

static Operation *scopeRoot(Operation *op) {
  while (!op->getParentOp()->hasTrait<OpTrait::IsIsolatedFromAbove>())
    op = op->getParentOp();
  return op;
}

static llvm::DenseSet<Operation *>
collectChoiceSetup(ArrayRef<MaterializationVariantsOp> choices,
                   const ChoiceEffects &choiceEffects) {
  SmallVector<Value> pending;
  llvm::DenseSet<Operation *> effectProducers;
  for (MaterializationVariantsOp choice : choices) {
    for (Value value : choice.getChoices()) {
      pending.push_back(value);
    }
    for (const EffectAlternative &alternative : choiceEffects.lookup(choice))
      effectProducers.insert(alternative.begin(), alternative.end());
  }
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
    bool alternativeEffect = effectProducers.contains(def);
    if (auto branch = dyn_cast<RegionBranchOpInterface>(def)) {
      if (isMemoryEffectFree(def) || alternativeEffect)
        setup.insert(def);
      appendPredecessors(branch, RegionSuccessor(def), value, pending);
      continue;
    }
    if (def->hasTrait<OpTrait::ConstantLike>() ||
        (!isMemoryEffectFree(def) && !alternativeEffect))
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
                                       ArrayRef<unsigned> dimensionSelections,
                                       Region &region) {
  IRMapping mapping;
  mapping.map(scope.inputs, region.front().getArguments());
  OpBuilder builder = OpBuilder::atBlockEnd(&region.front());
  for (Operation *op : scope.operations)
    builder.clone(*op, mapping);
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

  SmallVector<Value> outputs;
  for (Value value : scope.outputs)
    outputs.push_back(mapping.lookup(value));
  CandidateYieldOp::create(builder, scope.operations.back()->getLoc(), outputs,
                           IntegerAttr{});

  IRRewriter rewriter(builder.getContext());
  eliminateTriviallyDeadOps(rewriter, region);
  llvm::DenseSet<Operation *> liveOperations;
  region.walk([&](Operation *op) { liveOperations.insert(op); });

  llvm::SetVector<Operation *> rejected;
  for (auto [dimension, alternatives] :
       llvm::enumerate(scope.dimensionEffectProducers)) {
    unsigned selection = dimensionSelections[dimension];
    for (auto [alternative, producers] : llvm::enumerate(alternatives)) {
      if (alternative == selection)
        continue;
      for (Operation *producer : producers) {
        Operation *clone = mapping.lookupOrNull(producer);
        if (!clone)
          return producer->emitOpError(
              "effectful alternative is outside its candidate scope");
        if (liveOperations.contains(clone))
          rejected.insert(clone);
      }
    }
  }
  while (!rejected.empty()) {
    bool erased = false;
    for (Operation *op : llvm::to_vector(rejected)) {
      if (!op->use_empty())
        continue;
      rejected.remove(op);
      op->erase();
      erased = true;
    }
    if (!erased)
      return emitError(rejected.front()->getLoc())
             << "rejected materialization effects retain a live use";
  }
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
  auto wrapper = MaterializationCandidatesOp::create(builder, first->getLoc(),
                                                     outputTypes, scope.inputs,
                                                     scope.assignments.size());
  for (Region &region : wrapper.getCandidates()) {
    Block *block = new Block;
    region.push_back(block);
    for (Value input : scope.inputs)
      block->addArgument(input.getType(), input.getLoc());
  }
  // Shared input use lists stay fixed while workers clone private regions.
  std::atomic<bool> failedCandidate = false;
  parallelFor(first->getContext(), 0, scope.assignments.size(),
              [&](size_t ordinal) {
                if (failed(populateCandidate(scope, scope.assignments[ordinal],
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
    SmallVector<MaterializationVariantsOp> choices;
    llvm::DenseMap<Block *, SmallVector<Operation *>> roots;
    WalkResult walk = getOperation()->walk([&](MaterializationVariantsOp op) {
      if (op->getParentOfType<MaterializationCandidatesOp>()) {
        op.emitOpError("cannot expand choices inside an existing candidate");
        return WalkResult::interrupt();
      }
      choices.push_back(op);
      Operation *root = scopeRoot(op);
      blocks.insert(root->getBlock());
      roots[root->getBlock()].push_back(root);
      return WalkResult::advance();
    });
    if (walk.wasInterrupted())
      return signalPassFailure();
    ChoiceEffects choiceEffects;
    for (MaterializationVariantsOp choice : choices)
      choiceEffects.try_emplace(choice, collectAlternativeEffects(choice));
    llvm::DenseSet<Operation *> setup =
        collectChoiceSetup(choices, choiceEffects);
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
      if (failed(checkScope(maxCandidates, scope, choiceEffects)))
        return signalPassFailure();
    for (CandidateScope &scope : scopes)
      if (failed(expandScope(scope)))
        return signalPassFailure();
  }
};
} // namespace

void mlir::wave::registerWaveMaterializationPipelines() {
  static PassPipelineRegistration<> cleanup(
      "waveamd-cleanup-materialization-variants",
      "Clean isolated materialization candidate bodies", [](OpPassManager &pm) {
        OpPassManager &nested = pm.nest<MaterializationCandidatesOp>();
        nested.addPass(createRemoveDeadValuesPass());
        nested.addPass(createCSEPass());
        nested.addPass(createCanonicalizerPass());
      });
}
