//===- WaveSymbolicMemoryPreparation.cpp - symbolic access maps -*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
#include "WaveSymbolicMemoryPreparation.h"
#include "../IR/WaveIndexExpr.h"
#include "WaveSymbolicValueAnalysis.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/Wave/IR/WaveAMD.h"
#include "mlir/Dialect/Wave/Transforms/SymbolicValue.h"
#include "mlir/IR/Dominance.h"
#include "mlir/Interfaces/SideEffectInterfaces.h"
#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/ADT/StringMap.h"
#include "llvm/ADT/Twine.h"
#include <cassert>
#include <iterator>
#include <utility>
using namespace mlir;
using namespace mlir::wave;
namespace mlir::wave::symbolic_memory {
Preparation::Preparation(IRRewriter &rewriter) : rewriter(rewriter) {}
Preparation::~Preparation() {
  for (Operation *op : llvm::reverse(createdOps)) {
    assert(op->use_empty() &&
           "speculative preparation op escaped before commit");
    rewriter.eraseOp(op);
  }
}
void Preparation::track(Operation *op) { createdOps.push_back(op); }
void Preparation::prepareForParentErasure(Operation *parent) {
  llvm::erase_if(createdOps, [&](Operation *op) {
    if (!parent->isProperAncestor(op))
      return false;
    assert(llvm::all_of(op->getUsers(), [&](Operation *user) {
      return parent->isProperAncestor(user);
    }));
    return true;
  });
}
void Preparation::commit() {
  for (Operation *op : llvm::reverse(createdOps))
    if (op->use_empty())
      rewriter.eraseOp(op);
  createdOps.clear();
}
static PackOp getComponentPack(const MemoryAccess &access, Value packet,
                               int64_t slotCount) {
  Type componentType = getComponentType(access);
  if (PackOp pack = packet.getDefiningOp<PackOp>();
      pack && pack.getInputs().size() == static_cast<size_t>(slotCount) &&
      llvm::all_of(pack.getInputs(), [&](Value value) {
        return value.getType() == componentType;
      }))
    return pack;
  return {};
}
SmallVector<Value> getPacketComponents(IRRewriter &rewriter,
                                       const MemoryAccess &access, Value packet,
                                       int64_t slotCount,
                                       Preparation *preparation) {
  Type componentType = getComponentType(access);
  if (PackOp pack = getComponentPack(access, packet, slotCount))
    return SmallVector<Value>(pack.getInputs().begin(), pack.getInputs().end());
  SmallVector<Value> components;
  components.reserve(slotCount);
  for (int64_t index : llvm::seq<int64_t>(0, slotCount)) {
    ExtractOp extract = ExtractOp::create(rewriter, access.op->getLoc(),
                                          componentType, packet, index);
    if (preparation)
      preparation->track(extract);
    components.push_back(extract);
  }
  return components;
}
// This is only an ownership/effect check for erasing the packet region. It
// never contributes an adjacent operation's symbolic expression or facts.
bool isOwnedPacketRegion(Block &block, Operation *memory) {
  return llvm::all_of(block.without_terminator(), [&](Operation &op) {
    if (&op == memory)
      return true;
    if (isa<BallotOp, ReadFirstOp, ShuffleOp>(op) || op.getNumRegions() ||
        !isMemoryEffectFree(&op) || !isSpeculatable(&op))
      return false;
    return llvm::all_of(op.getUsers(), [&](Operation *user) {
      return user->getBlock() == &block;
    });
  });
}
static bool dominatesPacketRegion(DominanceInfo &dominance, WhereOp where,
                                  Value value) {
  return !value || dominance.dominates(value, where);
}
static FailureOr<YieldOp>
validatePacketPredicationOwner(MemoryAccess &access, WhereOp where,
                               DominanceInfo &dominance) {
  auto dominates = [&](Value value) {
    return dominatesPacketRegion(dominance, where, value);
  };
  if (access.op->getBlock() != &where.getThenRegion().front() ||
      !llvm::all_of(access.bases, dominates) || !dominates(access.packet) ||
      !dominates(access.dependency))
    return where.emitOpError(
        "packet-predicated symbolic memory then region must contain only "
        "index dependencies and the memory access");
  YieldOp thenYield =
      dyn_cast<YieldOp>(where.getThenRegion().front().getTerminator());
  if (!thenYield ||
      !isOwnedPacketRegion(where.getThenRegion().front(), access.op))
    return where.emitOpError(
        "packet-predicated symbolic memory then region must contain only "
        "index dependencies and the memory access");
  return thenYield;
}
static bool hasValidGatherYield(MemoryAccess &access, WhereOp where,
                                YieldOp thenYield) {
  return where.getNumResults() == 2 && thenYield.getNumOperands() == 2 &&
         thenYield.getOperand(0) == access.op->getResult(0) &&
         thenYield.getOperand(1) == access.op->getResult(1) &&
         !where.getElseRegion().empty();
}
static bool hasValidGatherFallback(WhereOp where, YieldOp inactive) {
  return inactive && inactive.getNumOperands() == 2 &&
         isOwnedPacketRegion(where.getElseRegion().front());
}
static LogicalResult
prepareGatherPacketPredication(IRRewriter &rewriter, MemoryAccess &access,
                               WhereOp where, YieldOp thenYield,
                               int64_t slotCount, DominanceInfo &dominance,
                               Preparation &transaction) {
  if (!hasValidGatherYield(access, where, thenYield))
    return where.emitOpError(
        "packet-predicated gather must yield its value and token and have "
        "an inactive region");
  YieldOp inactive =
      dyn_cast<YieldOp>(where.getElseRegion().front().getTerminator());
  if (!hasValidGatherFallback(where, inactive))
    return where.emitOpError(
        "packet-predicated gather inactive region must only yield fallback "
        "value and token");
  Value packet = inactive.getOperand(0);
  if (!dominatesPacketRegion(dominance, where, packet) &&
      !getComponentPack(access, packet, slotCount))
    return where.emitOpError(
        "packet-predicated gather fallback must be defined before its "
        "control region");
  access.inactiveComponents =
      getPacketComponents(rewriter, access, packet, slotCount, &transaction);
  access.inactiveToken = inactive.getOperand(1);
  auto dominates = [&](Value value) {
    return dominatesPacketRegion(dominance, where, value);
  };
  if (!llvm::all_of(access.inactiveComponents, dominates) ||
      !dominates(access.inactiveToken))
    return where.emitOpError(
        "packet-predicated gather fallback must be defined before its "
        "control region");
  return success();
}
static bool hasValidScatterYield(MemoryAccess &access, WhereOp where,
                                 YieldOp thenYield) {
  return where.getNumResults() <= 1 &&
         thenYield.getNumOperands() == where.getNumResults() &&
         (where.getNumResults() != 1 ||
          thenYield.getOperand(0) == access.op->getResult(0));
}
static bool hasValidScatterFallback(WhereOp where, YieldOp inactive) {
  return inactive && inactive.getNumOperands() == 1 &&
         isOwnedPacketRegion(where.getElseRegion().front());
}
static LogicalResult prepareScatterPacketPredication(
    IRRewriter &rewriter, MemoryAccess &access, WhereOp where,
    YieldOp thenYield, DominanceInfo &dominance, Preparation &transaction) {
  if (!hasValidScatterYield(access, where, thenYield))
    return where.emitOpError(
        "packet-predicated scatter must yield only its optional token");
  if (where.getNumResults() == 1) {
    if (where.getElseRegion().empty())
      return where.emitOpError(
          "result-bearing packet-predicated scatter requires an inactive "
          "region");
    YieldOp inactive =
        dyn_cast<YieldOp>(where.getElseRegion().front().getTerminator());
    if (!hasValidScatterFallback(where, inactive))
      return where.emitOpError(
          "packet-predicated scatter inactive region must only yield a token");
    access.inactiveToken = inactive.getOperand(0);
    if (!dominatesPacketRegion(dominance, where, access.inactiveToken))
      return where.emitOpError(
          "packet-predicated scatter inactive token must be defined before "
          "its control region");
    return success();
  }
  if (!where.getElseRegion().empty())
    return where.emitOpError(
        "effect-only packet-predicated scatter must not have an inactive "
        "region");
  access.inactiveToken = access.dependency;
  if (!access.inactiveToken) {
    TokenOp token = TokenOp::create(rewriter, where.getLoc(), access.tokenType);
    transaction.track(token);
    access.inactiveToken = token;
  }
  return success();
}
static LogicalResult preparePacketPredication(IRRewriter &rewriter,
                                              MemoryAccess &access,
                                              int64_t slotCount,
                                              Preparation &transaction) {
  WhereOp where = dyn_cast_or_null<WhereOp>(access.op->getParentOp());
  if (!where)
    return success();
  if (where.getConditions().size() == 1)
    return success();
  if (where.getConditions().size() != static_cast<size_t>(slotCount))
    return where.emitOpError(
        "mask packet length must match symbolic memory packet length");
  if (access.op->getBlock() != &where.getThenRegion().front())
    return access.op->emitOpError(
        "packet-predicated symbolic memory access must be in the then region");
  DominanceInfo dominance(where);
  FailureOr<YieldOp> thenYield =
      validatePacketPredicationOwner(access, where, dominance);
  if (failed(thenYield))
    return failure();
  rewriter.setInsertionPoint(where);
  access.packetWhere = where;
  return access.gather
             ? prepareGatherPacketPredication(rewriter, access, where,
                                              *thenYield, slotCount, dominance,
                                              transaction)
             : prepareScatterPacketPredication(
                   rewriter, access, where, *thenYield, dominance, transaction);
}
constexpr StringLiteral kMemoryItem = "item";
constexpr StringLiteral kMemorySlot = "slot";
static FailureOr<sym::PredHandle>
composeEqual(sym::Store &store, sym::ExprHandle lhs, sym::ExprHandle rhs) {
  return sym::composePredCmp(store, lhs, sym::PredCmpOp::Eq, rhs);
}
Type getComponentType(const MemoryAccess &access) {
  VectorType packet = cast<VectorType>(access.packetType.getElementType());
  return SimdType::get(access.op->getContext(), packet.getElementType(),
                       access.packetType.getWidth());
}
static void appendUnique(SmallVectorImpl<sym::PredHandle> &facts,
                         sym::PredHandle fact) {
  if (!llvm::is_contained(facts, fact))
    facts.push_back(fact);
}
PtrType getMemoryBasePtrType(Type type) {
  if (auto simd = dyn_cast<SimdType>(type))
    type = simd.getElementType();
  return cast<PtrType>(type);
}
static FailureOr<AccessShape> getAccessShape(const MemoryAccess &access) {
  auto packet = cast<VectorType>(access.packetType.getElementType());
  int64_t slots = packet.getNumElements();
  Type element = packet.getElementType();
  if (slots <= 0)
    return access.op->emitOpError("requires at least one packet slot");
  if (!element.isIntOrFloat())
    return access.op->emitOpError(
        "lowering requires an integer or float packet element type");
  int64_t bits = element.getIntOrFloatBitWidth();
  if (bits != 8 && bits != 16 && bits != 32)
    return access.op->emitOpError(
        "lowering requires 8-, 16-, or 32-bit packet elements");
  if (access.bases.empty())
    return access.op->emitOpError("requires at least one pointer base");
  Attribute space =
      getMemoryBasePtrType(access.bases.front().getType()).getAddressSpace();
  if (!isa<GlobalAddressSpaceAttr, SharedAddressSpaceAttr,
           waveamd::BufferAddressSpaceAttr>(space))
    return access.op->emitOpError(
        "lowering requires global, shared, or AMD buffer pointer bases");
  return AccessShape{slots, bits};
}

class IndexMapBuilder {
public:
  struct Predicate {
    sym::PredHandle value;
    SmallVector<sym::PredHandle, 2> facts;
  };
  explicit IndexMapBuilder(sym::Store &store) : store(store) {
    reserved.try_emplace("dma_wave_base", Value());
  }
  FailureOr<sym::ExprHandle> addAxis(StringRef name,
                                     std::optional<int64_t> extent,
                                     sym::ExprHandle shared = {}) {
    FailureOr<sym::ExprHandle> variable =
        shared ? FailureOr<sym::ExprHandle>(shared)
               : sym::composeExprSym(store, name);
    if (failed(variable))
      return failure();
    map.inputs.push_back({*variable, extent, {}});
    reserved.try_emplace(sym::ExprView(*variable).getSymbolName(), Value());
    return *variable;
  }
  void identify(Value value, sym::ExprHandle axis) {
    if (value)
      identities.try_emplace(value, axis);
  }
  LogicalResult appendExplicitAssumeFacts(Value value,
                                          sym::ExprHandle variable) {
    if (SplatOp splat = value.getDefiningOp<SplatOp>())
      value = splat.getSource();
    while (AssumeOp assume = value.getDefiningOp<AssumeOp>()) {
      FailureOr<sym::ExprHandle> target =
          sym::composeExprSym(store, assume.getName());
      if (failed(target))
        return failure();
      std::array<sym::ExprSubstitution, 1> substitution{
          sym::ExprSubstitution{*target, variable}};
      for (Attribute attr : assume.getAssumptions()) {
        FailureOr<sym::PredHandle> predicate = sym::substitutePred(
            store, cast<PredAttr>(attr).getValue(), substitution);
        if (failed(predicate))
          return failure();
        appendUnique(map.facts, *predicate);
      }
      value = assume.getValue();
    }
    return success();
  }
  FailureOr<sym::ExprHandle>
  bind(Value value, StringRef requested,
       SymbolicOffsetBindingKind kind = SymbolicOffsetBindingKind::Lane,
       bool materializable = false) {
    auto markMaterial = [&](sym::ExprHandle variable) {
      if (!materializable)
        return;
      auto input = llvm::find_if(map.inputs, [&](const auto &candidate) {
        return candidate.variable == variable;
      });
      assert(input != map.inputs.end());
      input->materializable = true;
    };
    if (auto found = identities.find(value); found != identities.end()) {
      if (failed(appendExplicitAssumeFacts(value, found->second)))
        return failure();
      markMaterial(found->second);
      return found->second;
    }
    if (auto found = values.find(value); found != values.end()) {
      if (failed(appendExplicitAssumeFacts(value, found->second)))
        return failure();
      markMaterial(found->second);
      return found->second;
    }
    StringRef name =
        reserveIndexExprBindingName(requested, value, reserved, bindingNames);
    FailureOr<sym::ExprHandle> variable = sym::composeExprSym(store, name);
    if (failed(variable))
      return failure();
    map.inputs.push_back(
        {*variable, std::nullopt, value, kind, materializable});
    if (failed(appendExplicitAssumeFacts(value, *variable)))
      return failure();
    Type storageType = value.getType();
    if (auto simd = dyn_cast<SimdType>(storageType))
      storageType = simd.getElementType();
    if (auto integer = dyn_cast<IntegerType>(storageType);
        integer && integer.isSignless() && integer.getWidth() == 32) {
      FailureOr<sym::PredHandle> storage =
          sym::rangeAssumption(store, sym::ExprView(*variable).getSymbolName(),
                               -(int64_t{1} << 31), (int64_t{1} << 31) - 1);
      if (failed(storage))
        return failure();
      appendUnique(map.facts, *storage);
    }
    values.try_emplace(value, *variable);
    return *variable;
  }
  FailureOr<sym::ExprHandle>
  import(const SymbolicOffset &offset,
         SmallVectorImpl<sym::PredHandle> &importedFacts) {
    FailureOr<SmallVector<sym::ExprSubstitution>> substitutions =
        importBindings(offset.bindings);
    if (failed(substitutions))
      return failure();
    FailureOr<SmallVector<sym::PredHandle>> facts =
        substituteIndexExprPredicates(store, offset.assumptions,
                                      *substitutions);
    if (failed(facts))
      return failure();
    for (sym::PredHandle fact : *facts)
      appendUnique(importedFacts, fact);
    if (substitutions->empty())
      return offset.expr;
    return sym::substituteExpr(store, offset.expr, *substitutions);
  }
  FailureOr<Predicate> import(const SymbolicPredicate &predicate) {
    FailureOr<SmallVector<sym::ExprSubstitution>> substitutions =
        importBindings(predicate.bindings);
    if (failed(substitutions))
      return failure();
    Predicate result;
    FailureOr<sym::PredHandle> value =
        remapPredicate(predicate.predicate, *substitutions);
    if (failed(value))
      return failure();
    result.value = *value;
    FailureOr<SmallVector<sym::PredHandle>> facts =
        substituteIndexExprPredicates(store, predicate.assumptions,
                                      *substitutions);
    if (failed(facts))
      return failure();
    result.facts = std::move(*facts);
    return result;
  }
  indexing::IndexMap map;

private:
  FailureOr<sym::PredHandle>
  remapPredicate(sym::PredHandle value,
                 ArrayRef<sym::ExprSubstitution> substitutions) {
    if (substitutions.empty())
      return value;
    return sym::substitutePred(store, value, substitutions);
  }
  FailureOr<SmallVector<sym::ExprSubstitution>>
  importBindings(ArrayRef<SymbolicOffsetBinding> bindings) {
    SmallVector<sym::ExprSubstitution> substitutions;
    for (const SymbolicOffsetBinding &binding : bindings) {
      StringRef name = sym::ExprView(binding.name).getSymbolName();
      if (name.empty())
        return failure();
      FailureOr<sym::ExprHandle> replacement =
          bind(binding.value, name, binding.kind);
      if (failed(replacement))
        return failure();
      if (!(*replacement == binding.name))
        substitutions.push_back({binding.name, *replacement});
    }
    return substitutions;
  }
  sym::Store &store;
  llvm::StringMap<Value> reserved;
  llvm::DenseMap<Value, StringRef> bindingNames;
  llvm::DenseMap<Value, sym::ExprHandle> identities;
  llvm::DenseMap<Value, sym::ExprHandle> values;
};
static void identifyAssumeLineage(IndexMapBuilder &builder, Value value,
                                  sym::ExprHandle identity) {
  while (AssumeOp assume = value.getDefiningOp<AssumeOp>()) {
    value = assume.getValue();
    builder.identify(value, identity);
  }
}
static FailureOr<std::optional<Value>>
findItemIdentity(const MemoryAccess &access, WaveDialect &dialect) {
  auto found = llvm::find(access.bindingNames, kMemoryItem);
  if (found == access.bindingNames.end())
    return std::optional<Value>{};
  Value binding =
      access.bindings[std::distance(access.bindingNames.begin(), found)];
  Value identity = binding;
  detail::SymbolicValueBuilder builder(
      dialect, /*allowI64Integers=*/true,
      /*assumeI32StorageRange=*/true, /*expandIndexExprRoot=*/true,
      /*foldWaveConstants=*/true, /*modelWrappingArithmetic=*/true,
      /*fullyMergeAssumes=*/true, detail::AssumeRootPolicy::ExpandSource);
  builder.enableExactIntegerCasts();
  builder.enableSSAIntermediateLeaves();
  FailureOr<std::optional<SymbolicOffset>> decoded =
      builder.buildAllowingRootLeaf(binding);
  if (failed(decoded))
    return failure();
  auto extractIdentity =
      [](const std::optional<SymbolicOffset> &offset) -> std::optional<Value> {
    if (!offset)
      return std::nullopt;
    StringRef name = sym::ExprView(offset->expr).getSymbolName();
    if (offset->bindings.size() != 1 || name.empty() ||
        sym::ExprView(offset->bindings.front().name).getSymbolName() != name)
      return std::nullopt;
    return offset->bindings.front().value;
  };
  if (*decoded) {
    std::optional<Value> decodedIdentity = extractIdentity(*decoded);
    if (!decodedIdentity)
      return std::optional<Value>{};
    identity = *decodedIdentity;
    if (binding.getDefiningOp<IndexExprOp>()) {
      FailureOr<std::optional<SymbolicOffset>> local =
          builder.buildAllowingRootLeaf(identity);
      if (failed(local))
        return failure();
      if (std::optional<Value> localIdentity = extractIdentity(*local))
        identity = *localIdentity;
    }
  }
  Value value = identity;
  while (AssumeOp assume = value.getDefiningOp<AssumeOp>())
    value = assume.getValue();
  auto workitem = value.getDefiningOp<WorkitemIdOp>();
  if (!workitem || workitem.getAxis() != 0)
    return std::optional<Value>{};
  return std::optional<Value>{value};
}
static LogicalResult
appendInteger(sym::Store &store, sym::ExprHandle expression,
              SmallVectorImpl<sym::PredHandle> &requirements) {
  if (sym::isIntegerValued(expression))
    return success();
  FailureOr<sym::ExprHandle> floored = sym::composeExprFloor(store, expression);
  FailureOr<sym::PredHandle> integer =
      failed(floored) ? FailureOr<sym::PredHandle>(failure())
                      : composeEqual(store, expression, *floored);
  if (failed(integer))
    return failure();
  requirements.push_back(*integer);
  return success();
}
struct ImportedCondition {
  sym::ExprHandle activity;
  sym::PredHandle active;
  SmallVector<sym::PredHandle, 4> facts;
};
struct AccessPreparation {
  AccessPreparation(IRRewriter &rewriter, MemoryAccess &access,
                    const AccessShape &shape, const AccessAxes &axes,
                    IndexMapBuilder &builder, WaveDialect &dialect,
                    Preparation &transaction)
      : rewriter(rewriter), access(access), shape(shape), axes(axes),
        builder(builder), dialect(dialect), transaction(transaction),
        store(dialect.getSymbolStore()) {}
  void addFact(sym::PredHandle fact) { appendUnique(commonFacts, fact); }
  IRRewriter &rewriter;
  MemoryAccess &access;
  const AccessShape &shape;
  const AccessAxes &axes;
  IndexMapBuilder &builder;
  WaveDialect &dialect;
  Preparation &transaction;
  sym::Store &store;
  sym::ExprHandle zero, activity;
  SmallVector<sym::ExprSubstitution> substitutions;
  SmallVector<sym::PredHandle, 8> commonFacts;
  SmallVector<ImportedCondition, 4> packetConditions;
};
static LogicalResult initializeAccessPreparation(AccessPreparation &state) {
  FailureOr<sym::ExprHandle> localBlock =
      sym::composeExprSym(state.store, "block");
  FailureOr<sym::ExprHandle> localSlot =
      sym::composeExprSym(state.store, kMemorySlot);
  FailureOr<sym::ExprHandle> zero = sym::composeExprInt(state.store, 0);
  FailureOr<sym::ExprHandle> one = sym::composeExprInt(state.store, 1);
  if (failed(localBlock) || failed(localSlot) || failed(zero) || failed(one))
    return failure();
  state.zero = *zero;
  state.activity = *one;
  state.substitutions = {{*localBlock, state.axes.block},
                         {*localSlot, state.axes.slot}};
  return success();
}
static FailureOr<sym::PredHandle> orientAccessBranch(AccessPreparation &state,
                                                     WhereOp where,
                                                     sym::PredHandle branch) {
  if (state.access.op->getParentRegion() == &where.getElseRegion()) {
    FailureOr<sym::PredHandle> inverted =
        sym::composePredNot(state.store, branch);
    return failed(inverted) ? FailureOr<sym::PredHandle>(failure()) : *inverted;
  }
  if (state.access.op->getParentRegion() != &where.getThenRegion())
    return failure();
  return branch;
}
static LogicalResult importAccessBranch(AccessPreparation &state) {
  WhereOp where = dyn_cast_or_null<WhereOp>(state.access.op->getParentOp());
  if (!where || where.getConditions().size() != 1 ||
      state.access.ambientCondition)
    return success();
  FailureOr<std::optional<SymbolicPredicate>> decoded =
      buildSymbolicMaskPredicate(where.getCondition(), state.dialect);
  if (failed(decoded))
    return failure();
  if (*decoded) {
    // Import only facts carried by the condition's defining SSA packet. The
    // oriented branch value is an execution fact; region membership never
    // supplies or transports a wave.assume predicate.
    FailureOr<IndexMapBuilder::Predicate> imported =
        state.builder.import(**decoded);
    if (failed(imported))
      return failure();
    for (sym::PredHandle fact : imported->facts)
      state.addFact(fact);
    FailureOr<sym::PredHandle> branch =
        orientAccessBranch(state, where, imported->value);
    if (failed(branch))
      return failure();
    state.addFact(*branch);
  }
  return success();
}
static FailureOr<bool>
packetBindingDominatesOwner(AccessPreparation &state, Value value,
                            StringRef name,
                            const std::optional<SymbolicOffset> &decoded) {
  if (!state.access.packetWhere)
    return true;
  DominanceInfo dominance(state.access.packetWhere);
  if (dominatesPacketRegion(dominance, state.access.packetWhere, value))
    return true;
  if (decoded && llvm::all_of(decoded->bindings,
                              [&](const SymbolicOffsetBinding &binding) {
                                return dominatesPacketRegion(
                                    dominance, state.access.packetWhere,
                                    binding.value);
                              }))
    return false;
  return state.access.packetWhere.emitOpError(
             "packet-predicated symbolic memory binding '")
         << name << "' is not fully representable outside its control region";
}
static FailureOr<std::optional<SymbolicOffset>>
decodeAccessValue(AccessPreparation &state, Value value, StringRef name) {
  FailureOr<std::optional<SymbolicOffset>> decoded =
      buildSymbolicIntegerPacket(value, state.dialect);
  if (failed(decoded))
    return state.access.op->emitOpError(
               "failed to build symbolic SSA packet for binding '")
           << name << "'";
  return decoded;
}
static FailureOr<sym::ExprHandle>
importDecodedAccessValue(AccessPreparation &state, Value value, StringRef name,
                         SymbolicOffsetBindingKind kind,
                         const std::optional<SymbolicOffset> &decoded,
                         SmallVectorImpl<sym::PredHandle> &facts) {
  FailureOr<bool> bindingDominatesPacket =
      packetBindingDominatesOwner(state, value, name, decoded);
  if (failed(bindingDominatesPacket))
    return failure();
  if (decoded && !*bindingDominatesPacket)
    return state.builder.import(*decoded, facts);

  bool materializable =
      decoded &&
      llvm::any_of(decoded->materializations, [&](const auto &candidate) {
        return candidate.value == value;
      });
  FailureOr<sym::ExprHandle> root =
      state.builder.bind(value, name, kind, materializable);
  if (failed(root))
    return failure();
  identifyAssumeLineage(state.builder, value, *root);
  if (!decoded)
    return root;
  FailureOr<sym::ExprHandle> definition = state.builder.import(*decoded, facts);
  if (failed(definition))
    return failure();
  if (*root == *definition)
    return root;
  FailureOr<sym::PredHandle> equality =
      composeEqual(state.store, *root, *definition);
  if (failed(equality))
    return failure();
  appendUnique(facts, *equality);
  return root;
}
static FailureOr<sym::ExprHandle>
importAccessValue(AccessPreparation &state, Value value, StringRef name,
                  SmallVectorImpl<sym::PredHandle> &facts) {
  if (std::optional<int64_t> literal = getSplatOrConstantInt(value))
    return sym::composeExprInt(state.store, *literal);
  FailureOr<std::optional<SymbolicOffset>> decoded =
      decodeAccessValue(state, value, name);
  if (failed(decoded))
    return failure();
  if (name == kMemoryItem && state.axes.item && *decoded &&
      (**decoded).bindings.size() == 1) {
    StringRef identity = sym::ExprView((**decoded).expr).getSymbolName();
    const SymbolicOffsetBinding &binding = (**decoded).bindings.front();
    if (!identity.empty() &&
        sym::ExprView(binding.name).getSymbolName() == identity)
      state.builder.identify(binding.value, *state.axes.item);
  }
  FailureOr<SymbolicOffsetBindingKind> kind =
      classifySymbolicOffsetBinding(value.getType(), [&](const Twine &message) {
        return state.access.op->emitOpError(message);
      });
  if (failed(kind))
    return failure();
  return importDecodedAccessValue(state, value, name, *kind, *decoded, facts);
}
static bool mappingUsesBinding(MemoryMappingAttr mapping, StringRef name) {
  bool used = false;
  auto findName = [&](sym::ExprHandle expression) {
    sym::walkSymbolNames(expression,
                         [&](StringRef symbol) { used |= symbol == name; });
  };
  if (mapping.getBase())
    findName(mapping.getBase().getValue());
  if (mapping.getTargetBlock())
    findName(mapping.getTargetBlock().getValue());
  findName(mapping.getBitOffset().getValue());
  return used;
}
static LogicalResult importAccessBindings(AccessPreparation &state) {
  for (auto [index, name] : llvm::enumerate(state.access.bindingNames)) {
    if (name != kMemoryItem && !mappingUsesBinding(state.access.mapping, name))
      continue;
    Value value = state.access.bindings[index];
    if (name == kMemoryItem && state.axes.item) {
      state.builder.identify(value, *state.axes.item);
      state.builder.identify(state.axes.itemValue, *state.axes.item);
    }
    FailureOr<sym::ExprHandle> original =
        sym::composeExprSym(state.store, name);
    if (failed(original))
      return failure();
    SmallVector<sym::PredHandle> facts;
    FailureOr<sym::ExprHandle> imported =
        importAccessValue(state, value, name, facts);
    if (failed(imported))
      return failure();
    for (sym::PredHandle fact : facts)
      state.addFact(fact);
    state.substitutions.push_back({*original, *imported});
  }
  return success();
}
static FailureOr<ImportedCondition>
importAccessCondition(AccessPreparation &state, Value condition,
                      StringRef name) {
  FailureOr<std::optional<SymbolicPredicate>> decoded =
      buildSymbolicMaskPredicate(condition, state.dialect);
  if (failed(decoded))
    return state.access.op->emitOpError(
        "failed to build symbolic SSA packet for condition");
  if (*decoded) {
    FailureOr<IndexMapBuilder::Predicate> predicate =
        state.builder.import(**decoded);
    if (failed(predicate))
      return failure();
    FailureOr<sym::ExprHandle> activity =
        composeIndexExprIndicator(state.store, predicate->value);
    if (failed(activity))
      return failure();
    return ImportedCondition{*activity, predicate->value,
                             std::move(predicate->facts)};
  }
  Type flagType =
      SimdType::get(state.access.op->getContext(), state.rewriter.getI32Type(),
                    state.access.packetType.getWidth());
  auto falseValue =
      ConstantOp::create(state.rewriter, state.access.op->getLoc(), flagType,
                         state.rewriter.getI32IntegerAttr(0));
  auto trueValue =
      ConstantOp::create(state.rewriter, state.access.op->getLoc(), flagType,
                         state.rewriter.getI32IntegerAttr(1));
  auto selected = SelectOp::create(state.rewriter, state.access.op->getLoc(),
                                   flagType, condition, trueValue, falseValue);
  state.transaction.track(falseValue);
  state.transaction.track(trueValue);
  state.transaction.track(selected);
  FailureOr<sym::ExprHandle> bound =
      state.builder.bind(selected, name, SymbolicOffsetBindingKind::Lane);
  if (failed(bound))
    return failure();
  FailureOr<sym::PredHandle> range = sym::rangeAssumption(
      state.store, sym::ExprView(*bound).getSymbolName(), 0, 1);
  FailureOr<sym::PredHandle> active =
      sym::composePredCmp(state.store, *bound, sym::PredCmpOp::Ne, state.zero);
  if (failed(range) || failed(active))
    return failure();
  ImportedCondition result{*bound, *active};
  result.facts.push_back(*range);
  return result;
}
static LogicalResult importAccessConditions(AccessPreparation &state) {
  if (state.access.ambientCondition) {
    FailureOr<ImportedCondition> imported =
        importAccessCondition(state, state.access.ambientCondition, "activity");
    if (failed(imported))
      return failure();
    state.activity = imported->activity;
    for (sym::PredHandle fact : imported->facts)
      state.addFact(fact);
  }
  if (!state.access.packetWhere)
    return success();
  state.packetConditions.reserve(
      state.access.packetWhere.getConditions().size());
  llvm::DenseMap<Value, unsigned> importedByValue;
  for (auto [index, condition] :
       llvm::enumerate(state.access.packetWhere.getConditions())) {
    auto [known, inserted] =
        importedByValue.try_emplace(condition, state.packetConditions.size());
    if (!inserted) {
      state.packetConditions.push_back(state.packetConditions[known->second]);
      continue;
    }
    FailureOr<ImportedCondition> imported = importAccessCondition(
        state, condition, (Twine("activity") + Twine(index)).str());
    if (failed(imported))
      return failure();
    state.packetConditions.push_back(std::move(*imported));
  }
  return success();
}
static FailureOr<sym::ExprHandle>
specializeAccessExpression(AccessPreparation &state,
                           sym::ExprHandle expression) {
  return sym::substituteExpr(state.store, expression, state.substitutions);
}
struct PreparedAddress {
  sym::ExprHandle base, owner, bit;
};
static FailureOr<PreparedAddress>
prepareAddressExpressions(AccessPreparation &state) {
  sym::ExprHandle base = state.zero;
  if (state.access.mapping.getBase()) {
    FailureOr<sym::ExprHandle> mapped = specializeAccessExpression(
        state, state.access.mapping.getBase().getValue());
    if (failed(mapped))
      return failure();
    base = *mapped;
  }
  sym::ExprHandle owner = state.axes.block;
  if (state.access.mapping.getTargetBlock()) {
    FailureOr<sym::ExprHandle> mapped = specializeAccessExpression(
        state, state.access.mapping.getTargetBlock().getValue());
    if (failed(mapped))
      return failure();
    owner = *mapped;
  }
  FailureOr<sym::ExprHandle> bit = specializeAccessExpression(
      state, state.access.mapping.getBitOffset().getValue());
  if (failed(bit))
    return failure();
  return PreparedAddress{base, owner, *bit};
}
static LogicalResult appendAccessRequirements(AccessPreparation &state,
                                              const PreparedAddress &address,
                                              indexing::IndexMap &domain) {
  if (failed(appendInteger(state.store, address.base, domain.requirements)) ||
      failed(appendInteger(state.store, address.owner, domain.requirements)) ||
      failed(appendInteger(state.store, address.bit, domain.requirements)) ||
      failed(appendInteger(state.store, state.activity, domain.requirements)))
    return failure();
  for (const ImportedCondition &condition : state.packetConditions)
    if (failed(appendInteger(state.store, condition.activity,
                             domain.requirements)))
      return failure();
  return success();
}
static void retainAddressFacts(const AccessPreparation &state,
                               const PreparedAddress &address,
                               indexing::IndexMap &domain) {
  llvm::DenseSet<StringRef> live;
  for (sym::ExprHandle expression : {address.base, address.owner, address.bit})
    collectIndexExprRequiredSymbols(expression, domain.facts, live);
  collectIndexExprRequiredSymbols(state.activity, domain.facts, live);
  for (const ImportedCondition &condition : state.packetConditions)
    collectIndexExprRequiredSymbols(condition.activity, domain.facts, live);
  bool changed = true;
  while (changed) {
    size_t previous = live.size();
    for (const sym::ExprSubstitution &definition : domain.definitions) {
      StringRef target = sym::ExprView(definition.target).getSymbolName();
      if (!target.empty() && live.contains(target))
        collectIndexExprRequiredSymbols(definition.replacement, domain.facts,
                                        live);
    }
    changed = live.size() != previous;
  }
  for (sym::PredHandle requirement : domain.requirements)
    collectIndexExprRequiredSymbols(sym::asExpr(requirement), domain.facts,
                                    live);
  domain.facts = filterIndexExprPredicatesBySymbols(domain.facts, live);
}
static FailureOr<bool>
haveEquivalentActivity(AccessPreparation &state, const ImportedCondition &lhs,
                       const ImportedCondition &rhs,
                       const indexing::IndexMap &domain) {
  if (lhs.active == rhs.active)
    return true;
  FailureOr<sym::PredHandle> equal =
      composeEqual(state.store, lhs.activity, rhs.activity);
  if (failed(equal))
    return failure();
  indexing::IndexMap proof = domain;
  for (sym::PredHandle fact : lhs.facts)
    appendUnique(proof.facts, fact);
  for (sym::PredHandle fact : rhs.facts)
    appendUnique(proof.facts, fact);
  FailureOr<sym::CheckResult> checked =
      indexing::check(state.store, proof, {*equal});
  return succeeded(checked) && *checked == sym::CheckResult::True;
}
static LogicalResult appendPacketActivityDomains(AccessPreparation &state,
                                                 AccessMap &result) {
  if (state.packetConditions.empty())
    return success();
  indexing::IndexMap domain = result.address.map;
  domain.requirements.clear();
  PacketActivityDomain current{state.packetConditions.front().active,
                               {},
                               state.access.packetWhere.getConditions().front(),
                               0,
                               1};
  current.facts.append(state.packetConditions.front().facts);
  for (int64_t slot = 1; slot < state.shape.slotCount; ++slot) {
    FailureOr<bool> same =
        haveEquivalentActivity(state, state.packetConditions[current.firstSlot],
                               state.packetConditions[slot], domain);
    if (failed(same))
      return failure();
    if (*same) {
      for (sym::PredHandle fact : state.packetConditions[slot].facts)
        appendUnique(current.facts, fact);
      ++current.slotCount;
      continue;
    }
    result.packetActivityDomains.push_back(std::move(current));
    current =
        PacketActivityDomain{state.packetConditions[slot].active,
                             {},
                             state.access.packetWhere.getConditions()[slot],
                             slot,
                             1};
    current.facts.append(state.packetConditions[slot].facts);
  }
  result.packetActivityDomains.push_back(std::move(current));
  return success();
}
static FailureOr<AccessMap> finishAccessPreparation(AccessPreparation &state,
                                                    PreparedAddress address) {
  indexing::IndexMap domain = state.builder.map;
  domain.facts.append(state.commonFacts.begin(), state.commonFacts.end());
  AccessMap result;
  result.access = &state.access;
  result.shape = state.shape;
  result.axes = state.axes;
  result.transactionSlotCount = state.shape.slotCount;
  if (failed(appendAccessRequirements(state, address, domain)))
    return failure();
  retainAddressFacts(state, address, domain);
  if (state.access.bases.size() == 1) {
    FailureOr<sym::PredHandle> singleton =
        composeEqual(state.store, address.base, state.zero);
    if (failed(singleton))
      return failure();
    domain.requirements.push_back(*singleton);
    address.base = state.zero;
  }
  FailureOr<sym::PredHandle> active = sym::composePredCmp(
      state.store, state.activity, sym::PredCmpOp::Ne, state.zero);
  if (failed(active))
    return failure();
  result.address = {std::move(domain), state.access.bases.front(),
                    address.owner, address.bit, *active};
  result.baseSelector = address.base;
  result.condition = state.access.ambientCondition;
  if (failed(appendPacketActivityDomains(state, result)))
    return failure();
  return result;
}
static FailureOr<AccessMap>
prepareAccess(IRRewriter &rewriter, MemoryAccess &access,
              const AccessShape &shape, const AccessAxes &axes,
              IndexMapBuilder &builder, WaveDialect &dialect,
              Preparation &transaction) {
  AccessPreparation state(rewriter, access, shape, axes, builder, dialect,
                          transaction);
  if (failed(initializeAccessPreparation(state)) ||
      failed(importAccessBranch(state)) ||
      failed(importAccessBindings(state)) ||
      failed(importAccessConditions(state)))
    return failure();
  FailureOr<PreparedAddress> address = prepareAddressExpressions(state);
  if (failed(address))
    return failure();
  return finishAccessPreparation(state, *address);
}
AccessMap specializeTransactionRange(const AccessMap &access, int64_t firstSlot,
                                     int64_t slotCount) {
  AccessMap specialized = access;
  specialized.packetActivityDomains.clear();
  specialized.transactionFirstSlot = firstSlot;
  specialized.transactionSlotCount = slotCount;
  return specialized;
}
AccessMap specializePacketActivity(const AccessMap &access,
                                   const PacketActivityDomain &domain) {
  AccessMap specialized =
      specializeTransactionRange(access, domain.firstSlot, domain.slotCount);
  for (sym::PredHandle fact : domain.facts)
    appendUnique(specialized.address.map.facts, fact);
  specialized.address.active = domain.active;
  specialized.condition = domain.condition;
  return specialized;
}
struct GroupItemAxis {
  std::optional<sym::ExprHandle> axis;
  Value value;
};
static FailureOr<std::optional<int64_t>> getItemExtent(Operation *anchor) {
  func::FuncOp func = anchor->getParentOfType<func::FuncOp>();
  DenseI32ArrayAttr shape;
  for (StringRef name : {"wave.workgroup_size", "gpu.known_block_size"}) {
    DenseI32ArrayAttr candidate =
        func ? func->getAttrOfType<DenseI32ArrayAttr>(name)
             : DenseI32ArrayAttr{};
    if (!candidate)
      continue;
    if (shape && shape != candidate)
      return anchor->emitOpError(
          "wave.workgroup_size and gpu.known_block_size must match");
    shape = candidate;
  }
  if (!shape)
    return std::optional<int64_t>{};
  if (shape.size() != 3 || shape.asArrayRef()[0] <= 0)
    return anchor->emitOpError("requires a positive 3D workgroup shape");
  return std::optional<int64_t>{shape.asArrayRef()[0]};
}
static FailureOr<GroupItemAxis>
prepareGroupItemAxis(IndexMapBuilder &builder, const std::optional<Value> &item,
                     std::optional<int64_t> extent, StringRef prefix,
                     llvm::DenseMap<Value, sym::ExprHandle> &itemAxes) {
  if (!item)
    return GroupItemAxis{};
  Value value = *item;
  auto existing = itemAxes.find(value);
  FailureOr<sym::ExprHandle> axis = builder.addAxis(
      (Twine(prefix) + "item").str(), extent,
      existing == itemAxes.end() ? sym::ExprHandle{} : existing->second);
  if (failed(axis))
    return failure();
  itemAxes.try_emplace(value, *axis);
  builder.identify(value, *axis);
  return GroupItemAxis{*axis, value};
}
static FailureOr<AccessMap>
prepareGroupAccess(IRRewriter &rewriter, MemoryAccess &access, size_t index,
                   size_t accessCount, WaveDialect &dialect,
                   Preparation &transaction,
                   llvm::DenseMap<Value, sym::ExprHandle> &itemAxes) {
  FailureOr<AccessShape> shape = getAccessShape(access);
  if (failed(shape) || failed(preparePacketPredication(
                           rewriter, access, shape->slotCount, transaction)))
    return failure();
  FailureOr<std::optional<Value>> item = findItemIdentity(access, dialect);
  FailureOr<std::optional<int64_t>> itemExtent = getItemExtent(access.op);
  if (failed(item) || failed(itemExtent))
    return failure();
  IndexMapBuilder builder(dialect.getSymbolStore());
  StringRef prefix =
      accessCount == 2 ? (index == 0 ? "source_" : "destination_") : "";
  FailureOr<sym::ExprHandle> block =
      builder.addAxis((Twine(prefix) + "block").str(), std::nullopt);
  FailureOr<GroupItemAxis> itemAxis =
      prepareGroupItemAxis(builder, *item, *itemExtent, prefix, itemAxes);
  if (failed(itemAxis))
    return failure();
  FailureOr<sym::ExprHandle> slot =
      builder.addAxis((Twine(prefix) + "slot").str(), shape->slotCount);
  if (failed(block) || failed(slot))
    return failure();
  AccessAxes axes{*block, *slot, itemAxis->axis, itemAxis->value};
  return prepareAccess(rewriter, access, *shape, axes, builder, dialect,
                       transaction);
}
FailureOr<AccessGroup>
prepareAccessGroup(IRRewriter &rewriter, MutableArrayRef<MemoryAccess> accesses,
                   WaveDialect &dialect, Preparation &transaction) {
  AccessGroup result;
  llvm::DenseMap<Value, sym::ExprHandle> itemAxes;
  for (auto [index, access] : llvm::enumerate(accesses)) {
    FailureOr<AccessMap> prepared =
        prepareGroupAccess(rewriter, access, index, accesses.size(), dialect,
                           transaction, itemAxes);
    if (failed(prepared))
      return failure();
    result.push_back(std::move(*prepared));
  }
  return result;
}
} // namespace mlir::wave::symbolic_memory
