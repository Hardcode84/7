//===- WaveLowerRedistribute.cpp - symbolic packet movement -----*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/Wave/Transforms/Passes.h"

#include "../IR/WaveIndexExpr.h"
#include "../IR/WaveMemoryAddress.h"
#include "RegAlloc/WaveAMDRegisterLimits.h"
#include "WaveLDSRegionLiveness.h"
#include "WaveRedistributePlanning.h"
#include "WaveSymbolicTransformTiming.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/Wave/IR/Wave.h"
#include "mlir/Dialect/Wave/IR/WaveSymbols.h"
#include "mlir/Dialect/Wave/Transforms/WaveLDSAllocation.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachineTarget.h"
#include "mlir/IR/BuiltinAttributes.h"
#include "mlir/IR/IRMapping.h"
#include "mlir/IR/PatternMatch.h"
#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/DenseSet.h"
#include "llvm/ADT/MapVector.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/Support/CheckedArithmetic.h"
#include "llvm/Support/ErrorHandling.h"
#include "llvm/Support/MathExtras.h"

#include <algorithm>
#include <array>
#include <cassert>
#include <cstdint>
#include <limits>
#include <memory>
#include <optional>
#include <tuple>
#include <utility>

namespace mlir::wave {
#define GEN_PASS_DEF_WAVELOWERREDISTRIBUTE
#include "mlir/Dialect/Wave/Transforms/Passes.h.inc"
} // namespace mlir::wave
using namespace mlir;
using namespace mlir::wave;

namespace {
static constexpr StringLiteral kBlock = "block";
static constexpr StringLiteral kItem = "item";
static constexpr StringLiteral kSlot = "slot";
static constexpr int64_t kMaxEnumerationPoints = int64_t{1} << 20;

enum class Movement { Alias, Workitem, Wave, Workgroup, Cluster };
struct MaterializedExpr {
  Value value;
  std::optional<int64_t> literal;
  sym::ExprHandle expression;
};
struct ExprMaterializationPoint {
  sym::ExprHandle expression;
  int64_t destinationSlot;
};
struct ScratchPlan {
  PacketPlan packet;
  GroupWindow window;
  ScratchPhysicalLayout layout;
  int64_t scratchBytes = 0;
};
struct ScratchRelation {
  indexing::IndexAddress store, load;
  SmallVector<sym::ExprHandle, 4> stageActive;
};
static Type getPacketPayloadType(Type type) {
  return cast<SimdType>(type).getElementType();
}
static Type getPacketScalarType(Type type) {
  Type payload = getPacketPayloadType(type);
  if (VectorType vector = dyn_cast<VectorType>(payload))
    return vector.getElementType();
  return payload;
}
static int64_t getPacketElementCount(Type type) {
  if (VectorType vector = dyn_cast<VectorType>(getPacketPayloadType(type)))
    return vector.getNumElements();
  return 1;
}
static int64_t getReductionExtent(ReduceOp op) {
  return op.getReductionExtentAttr().getInt();
}
static SimdType getPacketElementType(Type type) {
  SimdType packet = cast<SimdType>(type);
  return SimdType::get(type.getContext(), getPacketScalarType(type),
                       packet.getWidth());
}
static SimdType getPacketSliceType(Type type, int64_t elements) {
  SimdType packet = cast<SimdType>(type);
  Type payload = getPacketScalarType(type);
  if (elements > 1)
    payload = VectorType::get({elements}, payload);
  return SimdType::get(type.getContext(), payload, packet.getWidth());
}
struct SpecializedReductionRelation {
  sym::ExprHandle sourceBlock;
  sym::ExprHandle sourceItem;
  sym::ExprHandle sourceSlot;
};
static LogicalResult
specializeReductionExpression(sym::Store &store, sym::ExprHandle expression,
                              ArrayRef<sym::ExprSubstitution> substitutions,
                              SmallVectorImpl<sym::ExprHandle> &expressions) {
  FailureOr<sym::ExprHandle> result =
      sym::substituteExpr(store, expression, substitutions);
  if (failed(result))
    return failure();
  expressions.push_back(*result);
  return success();
}
static FailureOr<SpecializedReductionRelation>
specializeReductionRelation(sym::Store &store, const indexing::IndexMap &domain,
                            RedistributionAttr relation, int64_t resultSlot,
                            int64_t reductionCoordinate) {
  FailureOr<sym::ExprHandle> slot = sym::composeExprSym(store, kSlot);
  FailureOr<sym::ExprHandle> slotValue = sym::composeExprInt(store, resultSlot);
  FailureOr<sym::ExprHandle> reduction =
      sym::composeExprSym(store, "reduction");
  FailureOr<sym::ExprHandle> reductionValue =
      sym::composeExprInt(store, reductionCoordinate);
  if (failed(slot) || failed(slotValue) || failed(reduction) ||
      failed(reductionValue))
    return failure();
  std::array<sym::ExprSubstitution, 2> substitutions{
      sym::ExprSubstitution{*slot, *slotValue},
      sym::ExprSubstitution{*reduction, *reductionValue}};
  SmallVector<sym::ExprHandle, 3> expressions;
  for (sym::ExprHandle expression :
       {relation.getSourceBlock(), relation.getSourceItem(),
        relation.getSourceSlot()})
    if (failed(specializeReductionExpression(store, expression, substitutions,
                                             expressions)))
      return failure();
  FailureOr<SmallVector<sym::ExprHandle>> simplified =
      indexing::simplify(store, domain, expressions, {});
  if (failed(simplified))
    return failure();
  return SpecializedReductionRelation{(*simplified)[0], (*simplified)[1],
                                      (*simplified)[2]};
}

static LogicalResult validateReductionPointCount(ReduceOp op,
                                                 int64_t resultSlots) {
  std::optional<int64_t> points =
      llvm::checkedMul(getReductionExtent(op), resultSlots);
  if (!points)
    return op.emitOpError("reduction specialization point count overflows i64");
  if (*points > kMaxEnumerationPoints)
    return op.emitOpError("reduction specialization requires ")
           << *points << " points, exceeding the 2^20 point limit";
  return success();
}

static Value buildReductionResult(IRRewriter &rewriter, ReduceOp op,
                                  ArrayRef<Value> results) {
  if (results.size() == 1 &&
      !isa<VectorType>(getPacketPayloadType(op.getResult().getType())))
    return results.front();
  return PackOp::create(rewriter, op.getLoc(), op.getResult().getType(),
                        results);
}
static Value applyReductionCombiner(IRRewriter &rewriter, ReduceOp op,
                                    Value lhs, Value rhs) {
  Block &body = op.getCombiner().front();
  IRMapping mapping;
  mapping.map(body.getArgument(0), lhs);
  mapping.map(body.getArgument(1), rhs);
  for (Operation &bodyOp : body.without_terminator())
    rewriter.clone(bodyOp, mapping);
  YieldOp yield = cast<YieldOp>(body.getTerminator());
  return mapping.lookup(yield.getValues().front());
}
static FailureOr<Value> reduceTerms(IRRewriter &rewriter, ReduceOp op,
                                    ArrayRef<Value> terms, bool balanced) {
  if (terms.empty()) {
    op.emitOpError("lowering produced an empty reduction");
    return failure();
  }
  SmallVector<Value> level(terms);
  if (!balanced) {
    for (Value term : ArrayRef<Value>(level).drop_front())
      level.front() = applyReductionCombiner(rewriter, op, level.front(), term);
    return level.front();
  }
  while (level.size() > 1) {
    SmallVector<Value> next;
    next.reserve((level.size() + 1) / 2);
    for (size_t index = 0; index < level.size(); index += 2) {
      if (index + 1 == level.size()) {
        next.push_back(level[index]);
        continue;
      }
      next.push_back(
          applyReductionCombiner(rewriter, op, level[index], level[index + 1]));
    }
    level = std::move(next);
  }
  return level.front();
}
struct ReductionRelationGroup {
  SpecializedReductionRelation relation;
  SmallVector<Value> values;
  SmallVector<int64_t> sourceSlots;
};
static bool hasConsecutiveSourceSlots(ArrayRef<int64_t> sourceSlots) {
  return llvm::all_of(
      llvm::enumerate(sourceSlots.drop_front()), [&](auto indexedSlot) {
        return indexedSlot.value() == sourceSlots[indexedSlot.index()] + 1;
      });
}
static FailureOr<Value>
extractReductionSourceSlot(IRRewriter &rewriter, ReduceOp op,
                           MutableArrayRef<Value> cache, int64_t slot,
                           int64_t resultSlot, int64_t reductionCoordinate) {
  if (slot < 0 || slot >= static_cast<int64_t>(cache.size())) {
    op.emitOpError("relation source slot ")
        << slot << " is outside the source packet at result slot " << resultSlot
        << ", reduction coordinate " << reductionCoordinate;
    return failure();
  }
  if (cache[slot])
    return cache[slot];
  if (cache.size() == 1 &&
      !isa<VectorType>(getPacketPayloadType(op.getSource().getType())))
    cache[slot] = op.getSource();
  else
    cache[slot] = ExtractOp::create(
        rewriter, op.getLoc(), getPacketElementType(op.getSource().getType()),
        op.getSource(), slot);
  return cache[slot];
}
static Value
redistributeReductionValue(IRRewriter &rewriter, ReduceOp op, Value source,
                           const SpecializedReductionRelation &relation,
                           sym::ExprHandle sourceSlot) {
  RedistributionAttr attr =
      RedistributionAttr::get(op.getContext(), op.getRelation().getBlocks(),
                              op.getRelation().getItems(), relation.sourceBlock,
                              relation.sourceItem, sourceSlot);
  return RedistributeOp::create(rewriter, op.getLoc(),
                                getPacketElementType(op.getResult().getType()),
                                source, attr)
      .getResult();
}
static FailureOr<Value>
lowerReductionResultSlot(IRRewriter &rewriter, ReduceOp op, sym::Store &store,
                         const indexing::IndexMap &domain, sym::ExprHandle zero,
                         int64_t resultSlot, MutableArrayRef<Value> extracted,
                         bool reorderable) {
  SmallVector<ReductionRelationGroup> groups;
  SmallVector<Value> terms;
  terms.reserve(getReductionExtent(op));
  RedistributionAttr relation = op.getRelation();
  for (int64_t reductionCoordinate :
       llvm::seq<int64_t>(0, getReductionExtent(op))) {
    FailureOr<SpecializedReductionRelation> specialized =
        specializeReductionRelation(store, domain, relation, resultSlot,
                                    reductionCoordinate);
    if (failed(specialized)) {
      op.emitOpError("failed to specialize reduction relation at result slot ")
          << resultSlot << ", reduction coordinate " << reductionCoordinate;
      return failure();
    }
    std::optional<int64_t> sourceSlot =
        sym::getIntegerLiteralValue(specialized->sourceSlot);
    if (!sourceSlot) {
      terms.push_back(redistributeReductionValue(
          rewriter, op, op.getSource(), *specialized, specialized->sourceSlot));
      continue;
    }
    FailureOr<Value> source = extractReductionSourceSlot(
        rewriter, op, extracted, *sourceSlot, resultSlot, reductionCoordinate);
    if (failed(source))
      return failure();
    if (!reorderable) {
      terms.push_back(redistributeReductionValue(rewriter, op, *source,
                                                 *specialized, zero));
      continue;
    }
    SmallVector<ReductionRelationGroup>::iterator group =
        llvm::find_if(groups, [&](const ReductionRelationGroup &candidate) {
          return candidate.relation.sourceBlock == specialized->sourceBlock &&
                 candidate.relation.sourceItem == specialized->sourceItem;
        });
    if (group == groups.end()) {
      groups.push_back(ReductionRelationGroup{*specialized, {}, {}});
      group = std::prev(groups.end());
    }
    group->values.push_back(*source);
    group->sourceSlots.push_back(*sourceSlot);
  }
  for (ReductionRelationGroup &group : groups) {
    // Permuted slots need an accumulator to avoid a wide tuple frontier.
    bool balanced = hasConsecutiveSourceSlots(group.sourceSlots);
    FailureOr<Value> local = reduceTerms(rewriter, op, group.values, balanced);
    if (failed(local))
      return failure();
    terms.push_back(
        redistributeReductionValue(rewriter, op, *local, group.relation, zero));
  }
  return reduceTerms(rewriter, op, terms, reorderable);
}
static LogicalResult lowerReduction(IRRewriter &rewriter, ReduceOp op,
                                    WaveDialect &dialect) {
  int64_t resultSlots = getPacketElementCount(op.getResult().getType());
  if (failed(validateReductionPointCount(op, resultSlots)))
    return failure();
  sym::Store &store = dialect.getSymbolStore();
  FailureOr<sym::ExprHandle> block = sym::composeExprSym(store, kBlock);
  FailureOr<sym::ExprHandle> item = sym::composeExprSym(store, kItem);
  FailureOr<sym::ExprHandle> zero = sym::composeExprInt(store, 0);
  if (failed(block) || failed(item) || failed(zero))
    return op.emitOpError("failed to construct the reduction slot origin");
  RedistributionAttr relation = op.getRelation();
  indexing::IndexMap domain;
  domain.inputs = {
      {*block, relation.getBlocks(), Value(),
       SymbolicOffsetBindingKind::Uniform},
      {*item, relation.getItems(), Value(), SymbolicOffsetBindingKind::Lane}};
  int64_t sourceSlots = getPacketElementCount(op.getSource().getType());
  SmallVector<Value> extracted(sourceSlots);
  SmallVector<Value> results;
  results.reserve(resultSlots);
  rewriter.setInsertionPoint(op);
  bool reorderable = op.getAssociativeAttr() && op.getCommutativeAttr();
  for (int64_t resultSlot : llvm::seq<int64_t>(0, resultSlots)) {
    FailureOr<Value> result = lowerReductionResultSlot(
        rewriter, op, store, domain, *zero, resultSlot, extracted, reorderable);
    if (failed(result))
      return failure();
    results.push_back(*result);
  }
  rewriter.replaceOp(op, buildReductionResult(rewriter, op, results));
  return success();
}
static Value packPacket(IRRewriter &rewriter, RedistributeOp op,
                        ArrayRef<Value> components) {
  if (!isa<VectorType>(getPacketPayloadType(op.getResult().getType()))) {
    assert(components.size() == 1 &&
           components.front().getType() == op.getResult().getType());
    return components.front();
  }
  return PackOp::create(rewriter, op.getLoc(), op.getResult().getType(),
                        components);
}
static const indexing::IndexMap::Input &getInput(const indexing::IndexMap &map,
                                                 StringRef name) {
  auto input = llvm::find_if(map.inputs, [&](const auto &candidate) {
    return sym::ExprView(candidate.variable).getSymbolName() == name;
  });
  assert(input != map.inputs.end() && "missing index-map input");
  return *input;
}
static std::array<sym::ExprHandle, 3>
getSourceCoordinates(const indexing::IndexMap &map) {
  assert(map.exprs.size() == 3 &&
         "redistribution map must carry block, item, and slot");
  return {map.exprs[0], map.exprs[1], map.exprs[2]};
}
static FailureOr<sym::ExprHandle> composeWithInt(sym::Store &store,
                                                 sym::ExprHandle lhs,
                                                 sym::ExprBinaryOp op,
                                                 int64_t rhs) {
  FailureOr<sym::ExprHandle> literal = sym::composeExprInt(store, rhs);
  if (failed(literal))
    return failure();
  return sym::composeExprBinary(store, lhs, op, *literal);
}
static FailureOr<sym::ExprHandle>
composeRowMajor(sym::Store &store, ArrayRef<sym::ExprHandle> coordinates,
                ArrayRef<int64_t> extents) {
  if (coordinates.size() != extents.size() + 1)
    return failure();
  FailureOr<sym::ExprHandle> result = coordinates.front();
  for (auto [coordinate, extent] :
       llvm::zip_equal(coordinates.drop_front(), extents)) {
    if (failed(result = composeWithInt(store, *result, sym::ExprBinaryOp::Mul,
                                       extent)) ||
        failed(result = sym::composeExprBinary(
                   store, *result, sym::ExprBinaryOp::Add, coordinate)))
      return failure();
  }
  return result;
}
static FailureOr<sym::ExprHandle>
floorDiv(sym::Store &store, sym::ExprHandle value, int64_t divisor) {
  FailureOr<sym::ExprHandle> divided =
      composeWithInt(store, value, sym::ExprBinaryOp::Div, divisor);
  if (failed(divided))
    return failure();
  return sym::composeExprFloor(store, *divided);
}
static LogicalResult
appendCoordinateRequirements(sym::Store &store, sym::ExprHandle expression,
                             int64_t extent,
                             SmallVectorImpl<sym::PredHandle> &requirements) {
  FailureOr<sym::ExprHandle> zero = sym::composeExprInt(store, 0);
  FailureOr<sym::ExprHandle> upper = sym::composeExprInt(store, extent);
  if (failed(zero) || failed(upper))
    return failure();
  if (!sym::isIntegerValued(expression)) {
    FailureOr<sym::ExprHandle> integral =
        sym::composeExprFloor(store, expression);
    FailureOr<sym::PredHandle> integer =
        failed(integral) ? FailureOr<sym::PredHandle>(failure())
                         : sym::composePredCmp(store, expression,
                                               sym::PredCmpOp::Eq, *integral);
    if (failed(integer))
      return failure();
    requirements.push_back(*integer);
  }
  for (auto [predicate, rhs] : {std::pair{sym::PredCmpOp::Ge, *zero},
                                std::pair{sym::PredCmpOp::Lt, *upper}}) {
    FailureOr<sym::PredHandle> goal =
        sym::composePredCmp(store, expression, predicate, rhs);
    if (failed(goal))
      return failure();
    requirements.push_back(*goal);
  }
  return success();
}
static FailureOr<indexing::IndexMap> buildCarrier(sym::Store &store,
                                                  RedistributeOp op) {
  FailureOr<sym::ExprHandle> block = sym::composeExprSym(store, kBlock);
  FailureOr<sym::ExprHandle> item = sym::composeExprSym(store, kItem);
  FailureOr<sym::ExprHandle> slot = sym::composeExprSym(store, kSlot);
  if (failed(block) || failed(item) || failed(slot))
    return failure();
  indexing::IndexMap carrier;
  carrier.inputs = {{*block, op.getRelation().getBlocks(), Value(),
                     SymbolicOffsetBindingKind::Uniform},
                    {*item, op.getRelation().getItems(), Value(),
                     SymbolicOffsetBindingKind::Lane},
                    {*slot, getPacketElementCount(op.getResult().getType()),
                     Value(), SymbolicOffsetBindingKind::Uniform}};
  carrier.exprs = {op.getRelation().getSourceBlock(),
                   op.getRelation().getSourceItem(),
                   op.getRelation().getSourceSlot()};
  return carrier;
}
static FailureOr<sym::PredHandle> equal(sym::Store &store, sym::ExprHandle lhs,
                                        sym::ExprHandle rhs) {
  return sym::composePredCmp(store, lhs, sym::PredCmpOp::Eq, rhs);
}
static FailureOr<sym::PredHandle> sameWave(sym::Store &store,
                                           sym::ExprHandle lhs,
                                           sym::ExprHandle rhs,
                                           int64_t waveWidth) {
  FailureOr<sym::ExprHandle> lhsWave = floorDiv(store, lhs, waveWidth);
  FailureOr<sym::ExprHandle> rhsWave = floorDiv(store, rhs, waveWidth);
  if (failed(lhsWave) || failed(rhsWave))
    return failure();
  return equal(store, *lhsWave, *rhsWave);
}
static FailureOr<bool> carrierAccepts(sym::Store &store,
                                      const indexing::IndexMap &carrier,
                                      ArrayRef<sym::PredHandle> goals,
                                      indexing::CheckMemo &memo) {
  FailureOr<sym::CheckResult> result =
      indexing::check(store, carrier, goals, memo);
  if (failed(result))
    return failure();
  return *result == sym::CheckResult::True;
}
static FailureOr<int64_t> evaluateRedistributionPoint(
    sym::Store &store, const indexing::IndexMap &carrier,
    sym::ExprHandle expression, int64_t block, int64_t item, int64_t slot);

struct MovementProperties {
  bool sameBlock = true;
  bool sameItem = true;
  bool sameWave = true;
  bool identitySlot;
};

static LogicalResult
updateMovementProperties(sym::Store &store, const indexing::IndexMap &carrier,
                         ArrayRef<sym::ExprHandle> sourceCoordinates,
                         int64_t block, int64_t item, int64_t slot,
                         int64_t waveWidth, MovementProperties &properties) {
  FailureOr<int64_t> sourceBlock = evaluateRedistributionPoint(
      store, carrier, sourceCoordinates[0], block, item, slot);
  FailureOr<int64_t> sourceItem = evaluateRedistributionPoint(
      store, carrier, sourceCoordinates[1], block, item, slot);
  FailureOr<int64_t> sourceSlot = evaluateRedistributionPoint(
      store, carrier, sourceCoordinates[2], block, item, slot);
  if (failed(sourceBlock) || failed(sourceItem) || failed(sourceSlot))
    return failure();
  properties.sameBlock &= *sourceBlock == block;
  properties.sameItem &= *sourceItem == item;
  properties.sameWave &= *sourceItem / waveWidth == item / waveWidth;
  properties.identitySlot &= *sourceSlot == slot;
  return success();
}

static Movement
classifyMovementProperties(const MovementProperties &properties) {
  if (!properties.sameBlock)
    return Movement::Cluster;
  if (properties.sameItem && properties.identitySlot)
    return Movement::Alias;
  if (properties.sameItem)
    return Movement::Workitem;
  return properties.sameWave ? Movement::Wave : Movement::Workgroup;
}

static FailureOr<std::optional<Movement>> classifyCarrierByEnumeration(
    sym::Store &store, RedistributeOp op, const indexing::IndexMap &carrier,
    ArrayRef<sym::ExprHandle> sourceCoordinates, int64_t waveWidth) {
  int64_t blocks = op.getRelation().getBlocks();
  int64_t items = op.getRelation().getItems();
  int64_t slots = getPacketElementCount(op.getResult().getType());
  std::optional<int64_t> points = llvm::checkedMul(blocks, items);
  if (points)
    points = llvm::checkedMul(*points, slots);
  if (!points || *points > kMaxEnumerationPoints)
    return std::optional<Movement>{};

  MovementProperties properties;
  properties.identitySlot =
      op.getSource().getType() == op.getResult().getType();
  for (int64_t block : llvm::seq<int64_t>(0, blocks)) {
    for (int64_t item : llvm::seq<int64_t>(0, items)) {
      for (int64_t slot : llvm::seq<int64_t>(0, slots)) {
        if (failed(updateMovementProperties(store, carrier, sourceCoordinates,
                                            block, item, slot, waveWidth,
                                            properties)))
          return failure();
      }
    }
  }
  return std::optional<Movement>{classifyMovementProperties(properties)};
}
static LogicalResult
validateCarrierCoordinates(sym::Store &store, RedistributeOp op,
                           const indexing::IndexMap &carrier,
                           ArrayRef<sym::ExprHandle> coordinates,
                           int64_t sourceSlots, indexing::CheckMemo &memo) {
  SmallVector<sym::PredHandle, 12> validity;
  if (failed(appendCoordinateRequirements(
          store, coordinates[0], op.getRelation().getBlocks(), validity)) ||
      failed(appendCoordinateRequirements(
          store, coordinates[1], op.getRelation().getItems(), validity)) ||
      failed(appendCoordinateRequirements(store, coordinates[2], sourceSlots,
                                          validity)))
    return failure();
  FailureOr<bool> valid = carrierAccepts(store, carrier, validity, memo);
  if (failed(valid))
    return failure();
  if (!*valid)
    return op.emitOpError(
        "redistribution relation is not provably total, integral, and in "
        "bounds");
  return success();
}

using MovementCandidate = std::pair<Movement, SmallVector<sym::PredHandle, 3>>;

static FailureOr<std::optional<Movement>>
findAcceptedMovement(sym::Store &store, const indexing::IndexMap &carrier,
                     ArrayRef<MovementCandidate> candidates,
                     indexing::CheckMemo &memo) {
  for (const auto &[candidate, goals] : candidates) {
    FailureOr<bool> accepted = carrierAccepts(store, carrier, goals, memo);
    if (failed(accepted))
      return failure();
    if (*accepted)
      return std::optional<Movement>{candidate};
  }
  return std::optional<Movement>{};
}

static FailureOr<Movement>
classifyCarrierByProof(sym::Store &store, RedistributeOp op,
                       const indexing::IndexMap &carrier,
                       ArrayRef<sym::ExprHandle> sourceCoordinates,
                       int64_t waveWidth, indexing::CheckMemo &memo) {
  sym::ExprHandle block = getInput(carrier, kBlock).variable;
  sym::ExprHandle item = getInput(carrier, kItem).variable;
  sym::ExprHandle slot = getInput(carrier, kSlot).variable;
  FailureOr<sym::PredHandle> blockIdentity =
      equal(store, sourceCoordinates[0], block);
  FailureOr<sym::PredHandle> itemIdentity =
      equal(store, sourceCoordinates[1], item);
  FailureOr<sym::PredHandle> slotIdentity =
      equal(store, sourceCoordinates[2], slot);
  FailureOr<sym::PredHandle> waveIdentity =
      sameWave(store, sourceCoordinates[1], item, waveWidth);
  if (failed(blockIdentity) || failed(itemIdentity) || failed(slotIdentity) ||
      failed(waveIdentity))
    return failure();
  SmallVector<MovementCandidate, 4> candidates;
  if (op.getSource().getType() == op.getResult().getType())
    candidates.push_back(
        {Movement::Alias, {*blockIdentity, *itemIdentity, *slotIdentity}});
  candidates.push_back({Movement::Workitem, {*blockIdentity, *itemIdentity}});
  candidates.push_back({Movement::Wave, {*blockIdentity, *waveIdentity}});
  FailureOr<std::optional<Movement>> accepted =
      findAcceptedMovement(store, carrier, candidates, memo);
  if (failed(accepted))
    return failure();
  if (*accepted)
    return **accepted;
  FailureOr<bool> sameBlock =
      carrierAccepts(store, carrier, {*blockIdentity}, memo);
  if (failed(sameBlock))
    return failure();
  return *sameBlock ? Movement::Workgroup : Movement::Cluster;
}

static FailureOr<Movement>
classifyCarrierMovement(sym::Store &store, RedistributeOp op,
                        const indexing::IndexMap &carrier,
                        ArrayRef<sym::ExprHandle> sourceCoordinates,
                        int64_t waveWidth, indexing::CheckMemo &memo) {
  FailureOr<std::optional<Movement>> enumerated = classifyCarrierByEnumeration(
      store, op, carrier, sourceCoordinates, waveWidth);
  if (failed(enumerated))
    return failure();
  if (*enumerated)
    return **enumerated;
  return classifyCarrierByProof(store, op, carrier, sourceCoordinates,
                                waveWidth, memo);
}
static LogicalResult
validateBlockIndependentMovement(sym::Store &store, RedistributeOp op,
                                 const indexing::IndexMap &carrier,
                                 ArrayRef<sym::ExprHandle> sourceCoordinates,
                                 Movement movement, indexing::CheckMemo &memo) {
  if (movement == Movement::Alias || op.getRelation().getBlocks() == 1)
    return success();
  sym::ExprHandle block = getInput(carrier, kBlock).variable;
  FailureOr<sym::ExprHandle> zero = sym::composeExprInt(store, 0);
  if (failed(zero))
    return failure();
  std::array<sym::ExprSubstitution, 1> atBlockZero{
      sym::ExprSubstitution{block, *zero}};
  SmallVector<sym::PredHandle, 2> invariants;
  for (sym::ExprHandle coordinate : sourceCoordinates.drop_front()) {
    FailureOr<sym::ExprHandle> reference =
        sym::substituteExpr(store, coordinate, atBlockZero);
    FailureOr<sym::PredHandle> invariant =
        succeeded(reference) ? equal(store, coordinate, *reference)
                             : FailureOr<sym::PredHandle>(failure());
    if (failed(invariant))
      return failure();
    invariants.push_back(*invariant);
  }
  FailureOr<bool> independent =
      carrierAccepts(store, carrier, invariants, memo);
  if (failed(independent))
    return failure();
  if (!*independent)
    return op.emitOpError(
        "block-dependent redistribution requires a cluster block coordinate");
  return success();
}
static FailureOr<Movement>
validateAndClassifyMovement(sym::Store &store, RedistributeOp op,
                            const indexing::IndexMap &carrier,
                            int64_t waveWidth) {
  int64_t sourceSlots = getPacketElementCount(op.getSource().getType());
  indexing::CheckMemo memo;
  std::array sourceCoordinates = getSourceCoordinates(carrier);
  if (failed(validateCarrierCoordinates(store, op, carrier, sourceCoordinates,
                                        sourceSlots, memo)))
    return failure();
  FailureOr<Movement> movement = classifyCarrierMovement(
      store, op, carrier, sourceCoordinates, waveWidth, memo);
  if (failed(movement) ||
      failed(validateBlockIndependentMovement(
          store, op, carrier, sourceCoordinates,
          succeeded(movement) ? *movement : Movement::Cluster, memo)))
    return failure();
  return *movement;
}
static DenseI32ArrayAttr getWorkgroupShape(func::FuncOp func) {
  for (StringRef name : {"wave.workgroup_size", "gpu.known_block_size"})
    if (DenseI32ArrayAttr shape = func->getAttrOfType<DenseI32ArrayAttr>(name))
      return shape;
  return {};
}
static bool isInsideWhere(RedistributeOp op, func::FuncOp func) {
  for (Operation *parent = op->getParentOp(); parent && parent != func;
       parent = parent->getParentOp())
    if (isa<WhereOp>(parent))
      return true;
  return false;
}
static LogicalResult validateWorkgroup(RedistributeOp op, func::FuncOp func,
                                       int64_t waveWidth) {
  DenseI32ArrayAttr shape = getWorkgroupShape(func);
  if (!shape)
    return op.emitOpError("requires a known workgroup shape");
  ArrayRef<int32_t> dims = shape.asArrayRef();
  if (dims.size() != 3 || dims[1] != 1 || dims[2] != 1)
    return op.emitOpError("requires an X-linear workgroup shape [items, 1, 1]");
  if (dims[0] != op.getRelation().getItems())
    return op.emitOpError("relation item count ")
           << op.getRelation().getItems() << " does not match workgroup size "
           << dims[0];
  if (dims[0] % waveWidth != 0)
    return op.emitOpError("workgroup size must be divisible by SIMD width");
  if (isInsideWhere(op, func))
    return op.emitOpError("requires full-wave execution outside wave.where");
  return success();
}
class ExprMaterializer {
  using Key = std::pair<sym::ExprHandle, int64_t>;

public:
  ExprMaterializer(IRRewriter &rewriter, RedistributeOp op, sym::Store &store,
                   const indexing::IndexMap &domain)
      : rewriter(rewriter), op(op), store(store), domain(domain) {}
  LogicalResult prepare(ArrayRef<ExprMaterializationPoint> points) {
    llvm::MapVector<int64_t, SmallVector<ExprMaterializationPoint>> grouped;
    DenseSet<Key> pending;
    for (ExprMaterializationPoint point : points) {
      Key key{point.expression, point.destinationSlot};
      if (prepared.contains(key) || !pending.insert(key).second)
        continue;
      grouped[point.destinationSlot].push_back(point);
    }
    for (auto &[slot, group] : grouped)
      if (failed(prepareSlot(slot, group)))
        return failure();
    return success();
  }
  FailureOr<MaterializedExpr> materialize(sym::ExprHandle expression,
                                          int64_t slot) {
    auto found = prepared.find({expression, slot});
    if (found == prepared.end())
      return failure();
    const MaterializedExpr &entry = found->second;
    if (entry.literal)
      return MaterializedExpr{Value(), entry.literal, entry.expression};
    FailureOr<Value> value = materializeExpression(entry.expression);
    if (failed(value))
      return failure();
    return MaterializedExpr{*value, std::nullopt, entry.expression};
  }
  Value constantIndex(int64_t value, bool simd) {
    Type type = rewriter.getIndexType();
    if (simd)
      type = SimdType::get(op.getContext(), type, getWaveWidth());
    return ConstantOp::create(rewriter, op.getLoc(), type,
                              rewriter.getIndexAttr(value));
  }

private:
  static std::optional<arith::CmpIPredicate>
  getCmpPredicate(sym::PredCmpOp predicate) {
    switch (predicate) {
    case sym::PredCmpOp::Eq:
      return arith::CmpIPredicate::eq;
    case sym::PredCmpOp::Ne:
      return arith::CmpIPredicate::ne;
    case sym::PredCmpOp::Lt:
      return arith::CmpIPredicate::slt;
    case sym::PredCmpOp::Le:
      return arith::CmpIPredicate::sle;
    case sym::PredCmpOp::Gt:
      return arith::CmpIPredicate::sgt;
    case sym::PredCmpOp::Ge:
      return arith::CmpIPredicate::sge;
    }
    return std::nullopt;
  }
  Value constantMask(bool value) {
    return ConstantOp::create(rewriter, op.getLoc(),
                              MaskType::get(op.getContext(), getWaveWidth()),
                              rewriter.getBoolAttr(value));
  }
  Value selectMask(Value condition, Value trueValue, Value falseValue) {
    return SelectOp::create(rewriter, op.getLoc(), trueValue.getType(),
                            condition, trueValue, falseValue);
  }
  FailureOr<Value> materializeComparison(sym::PredView view) {
    std::optional<arith::CmpIPredicate> comparison =
        getCmpPredicate(*view.getCmpOp());
    FailureOr<Value> lhs = materializeExpression(view.getCmpLhs());
    FailureOr<Value> rhs = materializeExpression(view.getCmpRhs());
    if (!comparison || failed(lhs) || failed(rhs))
      return failure();
    return CmpIOp::create(rewriter, op.getLoc(),
                          MaskType::get(op.getContext(), getWaveWidth()),
                          *comparison, *lhs, *rhs)
        .getResult();
  }
  FailureOr<Value> materializeLogic(sym::PredView view) {
    bool isAnd = view.getKind() == sym::PredKind::And;
    Value result = constantMask(isAnd);
    for (uint32_t index = 0; index < view.getLogicArgCount(); ++index) {
      FailureOr<Value> argument = materializePredicate(view.getLogicArg(index));
      if (failed(argument))
        return failure();
      Value constant = constantMask(!isAnd);
      result = isAnd ? selectMask(result, *argument, constant)
                     : selectMask(result, constant, *argument);
    }
    return result;
  }
  FailureOr<Value> materializePiecewise(sym::PredHandle predicate) {
    sym::ExprView expression(sym::asExpr(predicate));
    Value result;
    for (uint32_t index = expression.getPiecewiseCaseCount(); index-- > 0;) {
      sym::PiecewiseCase arm = expression.getPiecewiseCase(index);
      std::optional<sym::PredHandle> armValue = sym::asPred(arm.value);
      FailureOr<Value> value = armValue ? materializePredicate(*armValue)
                                        : FailureOr<Value>(failure());
      FailureOr<Value> condition = materializePredicate(arm.condition);
      if (failed(value) || failed(condition))
        return failure();
      result = result ? selectMask(*condition, *value, result) : *value;
    }
    return result ? FailureOr<Value>(result) : FailureOr<Value>(failure());
  }
  FailureOr<Value> materializePredicateLeaf(sym::PredView view) {
    switch (view.getKind()) {
    case sym::PredKind::True:
      return constantMask(true);
    case sym::PredKind::False:
      return constantMask(false);
    case sym::PredKind::Cmp:
      return materializeComparison(view);
    case sym::PredKind::Not: {
      FailureOr<Value> argument = materializePredicate(view.getUnaryArg());
      if (failed(argument))
        return failure();
      return selectMask(*argument, constantMask(false), constantMask(true));
    }
    default:
      return failure();
    }
  }
  FailureOr<Value> materializePredicate(sym::PredHandle predicate) {
    sym::PredView view(predicate);
    if (view.getKind() == sym::PredKind::And ||
        view.getKind() == sym::PredKind::Or)
      return materializeLogic(view);
    if (view.getKind() == sym::PredKind::Piecewise)
      return materializePiecewise(predicate);
    return materializePredicateLeaf(view);
  }
  FailureOr<Value> materializeExpression(sym::ExprHandle expression) {
    if (std::optional<int64_t> literal =
            sym::getIntegerLiteralValue(expression))
      return constantIndex(*literal, /*simd=*/true);
    Value &cached = values[expression];
    if (cached)
      return cached;
    if (std::optional<sym::PredHandle> predicate = sym::asPred(expression)) {
      FailureOr<Value> condition = materializePredicate(*predicate);
      if (failed(condition))
        return failure();
      cached = selectMask(*condition, constantIndex(1, /*simd=*/true),
                          constantIndex(0, /*simd=*/true));
      return cached;
    }
    Value item = getItem();
    Type resultType =
        SimdType::get(op.getContext(), rewriter.getIndexType(), getWaveWidth());
    FailureOr<sym::PredHandle> itemRange = sym::rangeAssumption(
        store, kItem, 0,
        getInput(domain, kItem).extent.value_or(op.getRelation().getItems()) -
            1);
    if (failed(itemRange))
      return failure();
    cached = IndexExprOp::create(
        rewriter, op.getLoc(), resultType,
        ExprAttr::get(op.getContext(), expression),
        getIndexExprPredArrayAttr(op.getContext(),
                                  ArrayRef<sym::PredHandle>{*itemRange}),
        rewriter.getStrArrayAttr({kItem}), ValueRange{item});
    return cached;
  }
  LogicalResult prepareSlot(int64_t destinationSlot,
                            ArrayRef<ExprMaterializationPoint> points) {
    FailureOr<sym::ExprHandle> zero = sym::composeExprInt(store, 0);
    FailureOr<sym::ExprHandle> slot =
        sym::composeExprInt(store, destinationSlot);
    if (failed(zero) || failed(slot)) {
      op.emitOpError("failed to specialize redistribution point at slot ")
          << destinationSlot;
      return failure();
    }
    std::array<sym::ExprSubstitution, 2> definitions{
        sym::ExprSubstitution{getInput(domain, kBlock).variable, *zero},
        sym::ExprSubstitution{getInput(domain, kSlot).variable, *slot}};
    SmallVector<sym::ExprHandle> expressions;
    for (ExprMaterializationPoint point : points)
      expressions.push_back(point.expression);
    std::string diagnostic;
    FailureOr<SmallVector<sym::ExprHandle>> simplified = indexing::simplify(
        store, domain, expressions, definitions, &diagnostic);
    if (failed(simplified)) {
      InFlightDiagnostic error =
          op.emitOpError("failed to simplify redistribution point at slot ")
          << destinationSlot;
      if (!diagnostic.empty())
        error << ": " << diagnostic;
      return failure();
    }
    for (auto [point, expression] : llvm::zip(points, *simplified)) {
      Key key{point.expression, point.destinationSlot};
      prepared.try_emplace(
          key,
          MaterializedExpr{Value(), sym::getIntegerLiteralValue(expression),
                           expression});
    }
    return success();
  }
  int64_t getWaveWidth() {
    return cast<SimdType>(op.getSource().getType()).getWidth();
  }
  Value getItem() {
    if (!item) {
      Type type =
          SimdType::get(op.getContext(), rewriter.getI32Type(), getWaveWidth());
      item = WorkitemIdOp::create(rewriter, op.getLoc(), type,
                                  rewriter.getI64IntegerAttr(0));
    }
    return item;
  }
  DenseMap<Key, MaterializedExpr> prepared;
  DenseMap<sym::ExprHandle, Value> values;
  Value item;
  IRRewriter &rewriter;
  RedistributeOp op;
  sym::Store &store;
  const indexing::IndexMap &domain;
};
static SmallVector<Value> extractComponents(IRRewriter &rewriter,
                                            Location location, Value source) {
  Type packet = getPacketPayloadType(source.getType());
  if (!isa<VectorType>(packet))
    return {source};
  VectorType packetVector = cast<VectorType>(packet);
  Type componentType = getPacketElementType(source.getType());
  SmallVector<Value> components;
  components.reserve(packetVector.getNumElements());
  for (int64_t index : llvm::seq<int64_t>(0, packetVector.getNumElements()))
    components.push_back(
        ExtractOp::create(rewriter, location, componentType, source, index));
  return components;
}
static FailureOr<Value> selectComponent(IRRewriter &rewriter, RedistributeOp op,
                                        ExprMaterializer &materializer,
                                        ArrayRef<Value> candidates,
                                        MaterializedExpr selector) {
  if (candidates.empty())
    return failure();
  if (selector.literal) {
    int64_t index = *selector.literal;
    if (index < 0 || index >= static_cast<int64_t>(candidates.size()))
      return failure();
    return candidates[index];
  }
  if (!selector.value)
    return failure();
  Value result = candidates.front();
  Type maskType = MaskType::get(
      op.getContext(), cast<SimdType>(selector.value.getType()).getWidth());
  for (size_t index = 1; index < candidates.size(); ++index) {
    Value constant = materializer.constantIndex(index, /*simd=*/true);
    Value equal =
        CmpIOp::create(rewriter, op.getLoc(), maskType,
                       arith::CmpIPredicate::eq, selector.value, constant);
    result = SelectOp::create(rewriter, op.getLoc(), result.getType(), equal,
                              candidates[index], result);
  }
  return result;
}
static FailureOr<Value>
selectKeyedComponent(IRRewriter &rewriter, RedistributeOp op,
                     ExprMaterializer &materializer, ArrayRef<Value> candidates,
                     ArrayRef<int64_t> keys, MaterializedExpr selector) {
  assert(candidates.size() == keys.size() && "candidate keys must align");
  if (selector.literal) {
    auto found = llvm::find(keys, *selector.literal);
    if (found == keys.end())
      return failure();
    return candidates[std::distance(keys.begin(), found)];
  }
  if (!selector.value || candidates.empty())
    return failure();
  Value result = candidates.front();
  Type maskType = MaskType::get(
      op.getContext(), cast<SimdType>(selector.value.getType()).getWidth());
  for (size_t index = 1; index < candidates.size(); ++index) {
    Value constant = materializer.constantIndex(keys[index], /*simd=*/true);
    Value equal =
        CmpIOp::create(rewriter, op.getLoc(), maskType,
                       arith::CmpIPredicate::eq, selector.value, constant);
    result = SelectOp::create(rewriter, op.getLoc(), result.getType(), equal,
                              candidates[index], result);
  }
  return result;
}
static LogicalResult lowerWorkitem(IRRewriter &rewriter, RedistributeOp op,
                                   sym::Store &store,
                                   const indexing::IndexMap &carrier) {
  ExprMaterializer materializer(rewriter, op, store, carrier);
  SmallVector<Value> source =
      extractComponents(rewriter, op.getLoc(), op.getSource());
  int64_t resultSlots = getPacketElementCount(op.getResult().getType());
  sym::ExprHandle sourceSlot = getSourceCoordinates(carrier)[2];
  SmallVector<ExprMaterializationPoint> points;
  for (int64_t slot : llvm::seq<int64_t>(0, resultSlots))
    points.push_back({sourceSlot, slot});
  if (failed(materializer.prepare(points)))
    return op.emitOpError("failed to prepare source slot expression");
  SmallVector<Value> result;
  result.reserve(resultSlots);
  DenseMap<sym::ExprHandle, Value> selectedValues;
  for (int64_t slot : llvm::seq<int64_t>(0, resultSlots)) {
    FailureOr<MaterializedExpr> selector =
        materializer.materialize(sourceSlot, slot);
    if (failed(selector))
      return op.emitOpError("failed to materialize source packet component");
    Value selected = selectedValues.lookup(selector->expression);
    if (!selected) {
      FailureOr<Value> created =
          selectComponent(rewriter, op, materializer, source, *selector);
      if (failed(created))
        return op.emitOpError("failed to select source packet component");
      selected = *created;
      selectedValues.try_emplace(selector->expression, selected);
    }
    result.push_back(selected);
  }
  rewriter.replaceOp(op, packPacket(rewriter, op, result));
  return success();
}

static SmallVector<Value> extractPacketSlices(IRRewriter &rewriter,
                                              RedistributeOp op,
                                              const PacketPlan &plan) {
  SmallVector<Value> components =
      extractComponents(rewriter, op.getLoc(), op.getSource());
  Type sliceType =
      getPacketSliceType(op.getSource().getType(), plan.vectorElements);
  SmallVector<Value> slices;
  slices.reserve(plan.sourceGroups);
  for (int64_t group : llvm::seq<int64_t>(0, plan.sourceGroups)) {
    SmallVector<Value> values;
    values.reserve(plan.vectorElements);
    for (int64_t within : llvm::seq<int64_t>(0, plan.vectorElements)) {
      int64_t packedSlot = group * plan.vectorElements + within;
      int64_t sourceSlot = packedToLogicalSlot(
          plan.sourceWithinMask, plan.sourceGroups * plan.vectorElements,
          packedSlot);
      values.push_back(components[sourceSlot]);
    }
    slices.push_back(
        plan.vectorElements == 1
            ? values.front()
            : PackOp::create(rewriter, op.getLoc(), sliceType, values)
                  .getResult());
  }
  return slices;
}
struct DirectWavePlan {
  PacketPlan packet;
  SmallVector<SmallVector<int64_t>> sourceGroups;
  sym::ExprHandle sourceLane;
};
static FailureOr<int64_t> evaluateRedistributionPoint(
    sym::Store &store, const indexing::IndexMap &carrier,
    sym::ExprHandle expression, int64_t block, int64_t item, int64_t slot) {
  FailureOr<sym::ExprHandle> blockValue = sym::composeExprInt(store, block);
  FailureOr<sym::ExprHandle> itemValue = sym::composeExprInt(store, item);
  FailureOr<sym::ExprHandle> slotValue = sym::composeExprInt(store, slot);
  if (failed(blockValue) || failed(itemValue) || failed(slotValue))
    return failure();
  std::array<sym::ExprSubstitution, 3> substitutions{
      sym::ExprSubstitution{getInput(carrier, kBlock).variable, *blockValue},
      sym::ExprSubstitution{getInput(carrier, kItem).variable, *itemValue},
      sym::ExprSubstitution{getInput(carrier, kSlot).variable, *slotValue}};
  FailureOr<sym::ExprHandle> specialized =
      sym::substituteExpr(store, expression, substitutions);
  FailureOr<sym::ExprHandle> simplified =
      succeeded(specialized) ? sym::simplifyExpr(store, *specialized)
                             : FailureOr<sym::ExprHandle>(failure());
  std::optional<int64_t> literal =
      succeeded(simplified) ? sym::getIntegerLiteralValue(*simplified)
                            : std::nullopt;
  return literal ? FailureOr<int64_t>(*literal) : FailureOr<int64_t>(failure());
}
static FailureOr<SmallVector<SmallVector<int64_t>>>
collectDirectWaveSourceGroups(sym::Store &store, RedistributeOp op,
                              const indexing::IndexMap &carrier,
                              const PacketPlan &packet) {
  SmallVector<SmallVector<int64_t>> result;
  result.reserve(packet.resultGroups);
  int64_t resultSlots = getPacketElementCount(op.getResult().getType());
  for (int64_t group : llvm::seq<int64_t>(0, packet.resultGroups)) {
    int64_t packedSlot = group * packet.vectorElements;
    int64_t slot =
        packedToLogicalSlot(packet.resultWithinMask, resultSlots, packedSlot);
    DenseSet<int64_t> seen;
    for (int64_t block : llvm::seq<int64_t>(0, op.getRelation().getBlocks()))
      for (int64_t item : llvm::seq<int64_t>(0, op.getRelation().getItems())) {
        FailureOr<int64_t> sourceGroup = evaluateRedistributionPoint(
            store, carrier, packet.sourceGroup, block, item, slot);
        if (failed(sourceGroup) || *sourceGroup < 0 ||
            *sourceGroup >= packet.sourceGroups)
          return failure();
        seen.insert(*sourceGroup);
      }
    SmallVector<int64_t> groups(seen.begin(), seen.end());
    llvm::sort(groups);
    result.push_back(std::move(groups));
  }
  return result;
}
static FailureOr<DirectWavePlan>
buildDirectWavePlan(sym::Store &store, RedistributeOp op,
                    const indexing::IndexMap &carrier, int64_t waveWidth) {
  if (!llvm::isPowerOf2_64(waveWidth))
    return op.emitOpError("wave width is not a binary coordinate");
  int64_t sourceSlots = getPacketElementCount(op.getSource().getType());
  int64_t resultSlots = getPacketElementCount(op.getResult().getType());
  int64_t maxElements = std::min(sourceSlots, resultSlots);
  FailureOr<PacketPlan> packet =
      buildPacketPlan(store, op, carrier, maxElements, waveWidth,
                      /*allowResultPermutation=*/false);
  if (failed(packet))
    return op.emitOpError("failed to build direct wave packet plan");
  FailureOr<SmallVector<SmallVector<int64_t>>> sourceGroups =
      collectDirectWaveSourceGroups(store, op, carrier, *packet);
  if (failed(sourceGroups))
    return op.emitOpError("failed to enumerate direct wave source groups");
  FailureOr<sym::ExprHandle> sourceLane = composeWithInt(
      store, packet->sourceItem, sym::ExprBinaryOp::Mod, waveWidth);
  if (failed(sourceLane))
    return op.emitOpError("failed to build direct wave source lane");
  return DirectWavePlan{std::move(*packet), std::move(*sourceGroups),
                        *sourceLane};
}
static SmallVector<ExprMaterializationPoint>
getWaveMaterializationPoints(const DirectWavePlan &plan, int64_t resultSlots) {
  SmallVector<ExprMaterializationPoint> points;
  for (int64_t group : llvm::seq<int64_t>(0, plan.packet.resultGroups)) {
    int64_t packedSlot = group * plan.packet.vectorElements;
    int64_t slot = packedToLogicalSlot(plan.packet.resultWithinMask,
                                       resultSlots, packedSlot);
    points.push_back({plan.sourceLane, slot});
    points.push_back({plan.packet.sourceGroup, slot});
    for (int64_t offset : llvm::seq<int64_t>(0, plan.packet.vectorElements)) {
      int64_t resultSlot = packedToLogicalSlot(
          plan.packet.resultWithinMask, resultSlots, packedSlot + offset);
      points.push_back({plan.packet.sourceWithin, resultSlot});
    }
  }
  return points;
}
struct WaveGroupSelection {
  MaterializedExpr lane, selector;
};
static FailureOr<WaveGroupSelection>
materializeWaveGroupSelection(ExprMaterializer &materializer,
                              const DirectWavePlan &plan, int64_t slot) {
  FailureOr<MaterializedExpr> lane =
      materializer.materialize(plan.sourceLane, slot);
  FailureOr<MaterializedExpr> selector =
      materializer.materialize(plan.packet.sourceGroup, slot);
  if (failed(lane) || failed(selector))
    return failure();
  return WaveGroupSelection{*lane, *selector};
}
static FailureOr<Value>
buildShuffledWaveGroup(IRRewriter &rewriter, RedistributeOp op,
                       ExprMaterializer &materializer,
                       const DirectWavePlan &plan, ArrayRef<Value> source,
                       int64_t resultSlots, int64_t group) {
  int64_t packedSlot = group * plan.packet.vectorElements;
  int64_t slot = packedToLogicalSlot(plan.packet.resultWithinMask, resultSlots,
                                     packedSlot);
  FailureOr<WaveGroupSelection> selection =
      materializeWaveGroupSelection(materializer, plan, slot);
  if (failed(selection))
    return failure();
  Value laneValue = selection->lane.literal
                        ? materializer.constantIndex(*selection->lane.literal,
                                                     /*simd=*/false)
                        : selection->lane.value;
  ArrayRef<int64_t> sourceGroups = plan.sourceGroups[group];
  SmallVector<Value> candidates;
  candidates.reserve(sourceGroups.size());
  for (int64_t sourceGroup : sourceGroups) {
    Value slice = source[sourceGroup];
    candidates.push_back(ShuffleOp::create(rewriter, op.getLoc(),
                                           slice.getType(), slice, laneValue));
  }
  FailureOr<Value> selected =
      selectKeyedComponent(rewriter, op, materializer, candidates, sourceGroups,
                           selection->selector);
  if (failed(selected))
    return op.emitOpError("failed to select shuffled packet group");
  return *selected;
}
static LogicalResult
writeShuffledWaveGroup(IRRewriter &rewriter, RedistributeOp op,
                       ExprMaterializer &materializer, const PacketPlan &plan,
                       Value selected, int64_t resultSlots, int64_t group,
                       MutableArrayRef<Value> result) {
  int64_t packedSlot = group * plan.vectorElements;
  SmallVector<Value> components =
      extractComponents(rewriter, op.getLoc(), selected);
  for (int64_t offset : llvm::seq<int64_t>(0, plan.vectorElements)) {
    int64_t resultSlot = packedToLogicalSlot(plan.resultWithinMask, resultSlots,
                                             packedSlot + offset);
    FailureOr<MaterializedExpr> within =
        materializer.materialize(plan.sourceWithin, resultSlot);
    if (failed(within))
      return op.emitOpError("failed to select shuffled packet component");
    FailureOr<Value> component =
        selectComponent(rewriter, op, materializer, components, *within);
    if (failed(component))
      return op.emitOpError("failed to select shuffled packet component");
    result[resultSlot] = *component;
  }
  return success();
}
static LogicalResult lowerWave(IRRewriter &rewriter, RedistributeOp op,
                               sym::Store &store,
                               const indexing::IndexMap &carrier,
                               int64_t waveWidth) {
  FailureOr<DirectWavePlan> plan =
      buildDirectWavePlan(store, op, carrier, waveWidth);
  if (failed(plan))
    return op.emitOpError("failed to construct direct wave redistribution");
  int64_t resultSlots = getPacketElementCount(op.getResult().getType());
  SmallVector<Value> source = extractPacketSlices(rewriter, op, plan->packet);
  ExprMaterializer materializer(rewriter, op, store, carrier);
  SmallVector<ExprMaterializationPoint> points =
      getWaveMaterializationPoints(*plan, resultSlots);
  if (failed(materializer.prepare(points)))
    return op.emitOpError("failed to prepare packetized wave relation");
  SmallVector<Value> result(resultSlots);
  for (int64_t group : llvm::seq<int64_t>(0, plan->packet.resultGroups)) {
    FailureOr<Value> selected = buildShuffledWaveGroup(
        rewriter, op, materializer, *plan, source, resultSlots, group);
    if (failed(selected))
      return op.emitOpError("failed to materialize shuffled wave group ")
             << group;
    if (failed(writeShuffledWaveGroup(rewriter, op, materializer, plan->packet,
                                      *selected, resultSlots, group, result)))
      return failure();
  }
  rewriter.replaceOp(op, packPacket(rewriter, op, result));
  return success();
}
static FailureOr<Value> buildPointer(IRRewriter &rewriter, RedistributeOp op,
                                     ExprMaterializer &materializer, Value base,
                                     MaterializedExpr offset) {
  Value offsetValue = offset.literal
                          ? materializer.constantIndex(*offset.literal,
                                                       /*simd=*/false)
                          : offset.value;
  if (!offsetValue)
    return failure();
  Type resultType = base.getType();
  if (isa<SimdType>(offsetValue.getType()))
    resultType =
        SimdType::get(op.getContext(), base.getType(),
                      cast<SimdType>(op.getSource().getType()).getWidth());
  return PtrAddOp::create(rewriter, op.getLoc(), resultType, base, offsetValue)
      .getResult();
}
static FailureOr<int64_t> getScratchBytes(RedistributeOp op) {
  Type elementType = getPacketScalarType(op.getSource().getType());
  if (!elementType.isIntOrFloat()) {
    op.emitOpError("cross-wave payload element must be integer or float");
    return failure();
  }
  int64_t bits = elementType.getIntOrFloatBitWidth();
  if (bits != 8 && bits != 16 && bits != 32) {
    op.emitOpError("cross-wave payload element must be 8, 16, or 32 bits wide");
    return failure();
  }
  std::optional<int64_t> elements =
      llvm::checkedMul(op.getRelation().getItems(),
                       getPacketElementCount(op.getSource().getType()));
  std::optional<int64_t> bytes =
      elements ? llvm::checkedMul(*elements, bits / 8) : std::nullopt;
  if (!bytes || *bytes <= 0) {
    op.emitOpError("cross-wave scratch byte size overflows i64");
    return failure();
  }
  return *bytes;
}
static FailureOr<int64_t> getNonNegativeLDSAttr(func::FuncOp func,
                                                StringRef name) {
  IntegerAttr attr = func->getAttrOfType<IntegerAttr>(name);
  if (!attr)
    return 0;
  int64_t bytes = attr.getInt();
  if (bytes < 0)
    return func.emitError() << name << " must be non-negative";
  return bytes;
}
static FailureOr<std::optional<int64_t>> getScratchLDSLimit(func::FuncOp func) {
  if (!waveamdmachine::findAMDGPUTargetModule(func))
    return std::optional<int64_t>();
  FailureOr<WaveAMDLocalMemoryLimits> limits =
      getWaveAMDLocalMemoryLimits(func, "wave-lower-redistribute");
  FailureOr<int64_t> dynamic =
      getNonNegativeLDSAttr(func, "wave.dynamic_lds_size");
  FailureOr<int64_t> spill =
      getNonNegativeLDSAttr(func, "waveamdmachine.lds_spill_bytes");
  if (failed(limits) || failed(dynamic) || failed(spill))
    return failure();
  uint64_t capacity = limits->localMemoryBytes;
  if (limits->addressableLocalMemoryBytes)
    capacity =
        std::min<uint64_t>(capacity, limits->addressableLocalMemoryBytes);
  std::optional<int64_t> reserved = llvm::checkedAdd(*dynamic, *spill);
  if (!capacity)
    return func.emitError("wave-lower-redistribute target has no usable LDS");
  if (!reserved)
    return func.emitError("non-allocation LDS byte count overflows i64");
  if (static_cast<uint64_t>(*reserved) >= capacity)
    return std::optional<int64_t>(0);
  return std::optional<int64_t>(capacity - static_cast<uint64_t>(*reserved));
}
static FailureOr<ScratchPlan>
buildScratchPlan(sym::Store &store, RedistributeOp op,
                 const indexing::IndexMap &carrier, int64_t scratchBudget) {
  int64_t items = op.getRelation().getItems();
  int64_t elementBits =
      getPacketScalarType(op.getSource().getType()).getIntOrFloatBitWidth();
  int64_t elementBytes = elementBits / 8;
  std::optional<int64_t> scalarPlaneBytes =
      llvm::checkedMul(items, elementBytes);
  if (!scalarPlaneBytes || !*scalarPlaneBytes ||
      scratchBudget < *scalarPlaneBytes)
    return op.emitOpError("remaining target LDS capacity ")
           << scratchBudget << " bytes cannot hold one " << items
           << "-element scratch plane";
  int64_t maxTransferElements = 128 / elementBits;
  int64_t maxCapacityElements = scratchBudget / *scalarPlaneBytes;
  FailureOr<PacketPlan> packet = buildPacketPlan(
      store, op, carrier, std::min(maxTransferElements, maxCapacityElements),
      std::nullopt, /*allowResultPermutation=*/true);
  if (failed(packet))
    return failure();
  std::optional<int64_t> vectorPlaneBytes =
      llvm::checkedMul(*scalarPlaneBytes, packet->vectorElements);
  if (!vectorPlaneBytes)
    return op.emitOpError("cross-wave scratch vector plane overflows i64");
  int64_t maxLocalGroups =
      std::min(packet->sourceGroups, scratchBudget / *vectorPlaneBytes);
  if (maxLocalGroups <= 0)
    return op.emitOpError("cross-wave scratch cannot hold one vector plane");
  FailureOr<GroupWindow> window =
      buildGroupWindow(store, op, carrier, packet->sourceGroup,
                       packet->sourceGroups, maxLocalGroups);
  if (failed(window))
    return failure();
  std::optional<int64_t> scratchBytes =
      llvm::checkedMul(*vectorPlaneBytes, window->localGroups);
  if (!scratchBytes)
    return op.emitOpError("cross-wave scratch allocation overflows i64");
  int64_t waveWidth = cast<SimdType>(op.getSource().getType()).getWidth();
  FailureOr<ScratchPhysicalLayout> layout = selectScratchPhysicalLayout(
      store, op, carrier, *packet, *window, waveWidth, elementBits);
  if (failed(layout))
    return failure();
  return ScratchPlan{std::move(*packet), std::move(*window), std::move(*layout),
                     *scratchBytes};
}
struct ScratchCapacity {
  std::optional<int64_t> limit;
  int64_t availableBytes = 0, overlapBytes = 0;
  Value dependency, analysisDependency;
};
struct ScratchSequence {
  Value releaseCompletion, accessCompletion, publicationCompletion;
  Operation *cursor = nullptr;
  WaveLDSRange range;
};
using ScratchSequenceHistory = SmallVector<ScratchSequence, 4>;
using ScratchSequenceMap = DenseMap<Block *, ScratchSequenceHistory>;
static const ScratchSequence *
getLatestScratchSequence(Block *block, const ScratchSequenceMap &sequences) {
  auto found = sequences.find(block);
  return found == sequences.end() ? nullptr : &found->second.back();
}
static SmallVector<WaveLDSRange, 4>
collectScratchRanges(Operation *point, const ScratchSequenceMap &sequences,
                     WaveLDSAllocationAnalysis &analysis, Value dependency,
                     bool includeCurrentBlock) {
  SmallVector<WaveLDSRange, 4> ranges;
  for (const auto &[sequenceBlock, history] : sequences) {
    if (!includeCurrentBlock && sequenceBlock == point->getBlock())
      continue;
    for (const ScratchSequence &sequence : history) {
      if (!waveLDSOperationsMayCoexecute(sequence.cursor, point) ||
          analysis.completesThroughBarrier(dependency,
                                           sequence.accessCompletion))
        continue;
      ranges.push_back(sequence.range);
    }
  }
  return ranges;
}
static bool scratchBlockCompleted(Block *block,
                                  const ScratchSequenceMap &sequences,
                                  WaveLDSAllocationAnalysis &analysis,
                                  Value dependency) {
  auto found = sequences.find(block);
  if (found == sequences.end())
    return true;
  return llvm::all_of(found->second, [&](const ScratchSequence &sequence) {
    return analysis.completesThroughBarrier(dependency,
                                            sequence.accessCompletion);
  });
}
static Value findPrecedingBarrier(RedistributeOp op) {
  for (Operation *cursor = op->getPrevNode(); cursor;
       cursor = cursor->getPrevNode())
    if (BarrierOp barrier = dyn_cast<BarrierOp>(cursor))
      return barrier.getToken();
  return {};
}
static std::pair<Value, Value>
advanceScratchSequence(IRRewriter &rewriter, RedistributeOp op,
                       ScratchSequenceMap &sequences) {
  const ScratchSequence *previous =
      getLatestScratchSequence(op->getBlock(), sequences);
  if (!previous) {
    Value barrier = findPrecedingBarrier(op);
    return {barrier, barrier};
  }
  Value dependency = previous->releaseCompletion;
  Value analysisDependency = previous->publicationCompletion;
  for (Operation *cursor = previous->cursor->getNextNode(); cursor != op;
       cursor = cursor->getNextNode()) {
    assert(cursor && "redistributions must lower in block order");
    BarrierOp barrier = dyn_cast<BarrierOp>(cursor);
    if (!barrier)
      continue;
    SmallVector<Value> inputs(barrier.getDependencies());
    if (!llvm::is_contained(inputs, dependency)) {
      inputs.push_back(dependency);
      rewriter.modifyOpInPlace(
          barrier, [&] { barrier.getDependenciesMutable().assign(inputs); });
    }
    dependency = barrier.getToken();
    analysisDependency = dependency;
  }
  return {dependency, analysisDependency};
}
static FailureOr<ScratchCapacity>
getScratchCapacity(IRRewriter &rewriter, RedistributeOp op, func::FuncOp func,
                   WaveLDSAllocationAnalysis &analysis, int64_t requestedBytes,
                   ScratchSequenceMap &sequences) {
  ScratchCapacity capacity;
  capacity.availableBytes = requestedBytes;
  capacity.overlapBytes = requestedBytes;
  std::tie(capacity.dependency, capacity.analysisDependency) =
      advanceScratchSequence(rewriter, op, sequences);
  analysis.refreshTokenOrdering();
  FailureOr<std::optional<int64_t>> limit = getScratchLDSLimit(func);
  if (failed(limit))
    return failure();
  capacity.limit = *limit;
  if (!capacity.limit)
    return capacity;
  SmallVector<WaveLDSRange, 4> blocked =
      collectScratchRanges(op, sequences, analysis, capacity.analysisDependency,
                           /*includeCurrentBlock=*/false);
  FailureOr<int64_t> available = analysis.getLargestFreeRange(
      op, *capacity.limit, capacity.analysisDependency, blocked);
  if (failed(available))
    return failure();
  capacity.availableBytes = std::min(requestedBytes, *available);
  capacity.overlapBytes = capacity.availableBytes;
  if (!getLatestScratchSequence(op->getBlock(), sequences))
    return capacity;
  blocked =
      collectScratchRanges(op, sequences, analysis, capacity.analysisDependency,
                           /*includeCurrentBlock=*/true);
  FailureOr<int64_t> overlap = analysis.getLargestFreeRange(
      op, *capacity.limit, capacity.analysisDependency, blocked);
  if (failed(overlap))
    return failure();
  capacity.overlapBytes = std::min(requestedBytes, *overlap);
  return capacity;
}
struct ScratchLoadPredicate {
  Value mask;
  bool active = false;
  sym::ExprHandle expression;
};
static FailureOr<ScratchLoadPredicate>
buildScratchLoadPredicate(IRRewriter &rewriter, RedistributeOp op,
                          ExprMaterializer &materializer,
                          sym::ExprHandle active, int64_t destinationSlot,
                          DenseMap<sym::ExprHandle, Value> &masks) {
  FailureOr<MaterializedExpr> predicate =
      materializer.materialize(active, destinationSlot);
  if (failed(predicate))
    return failure();
  if (predicate->literal)
    return ScratchLoadPredicate{Value(), *predicate->literal != 0,
                                predicate->expression};
  Value &mask = masks[predicate->expression];
  if (!mask) {
    int64_t width = cast<SimdType>(predicate->value.getType()).getWidth();
    Value zero = materializer.constantIndex(0, /*simd=*/true);
    mask = CmpIOp::create(rewriter, op.getLoc(),
                          MaskType::get(op.getContext(), width),
                          arith::CmpIPredicate::ne, predicate->value, zero);
  }
  return ScratchLoadPredicate{mask, true, predicate->expression};
}
static std::pair<Value, Value>
emitScratchLoad(IRRewriter &rewriter, RedistributeOp op, Type transferType,
                Type tokenType, Value pointer, Value published, Value mask) {
  if (!mask) {
    LoadOp load = LoadOp::create(rewriter, op.getLoc(), transferType, tokenType,
                                 pointer, published, Attribute());
    return {load.getValue(), load.getToken()};
  }
  WhereOp where =
      WhereOp::create(rewriter, op.getLoc(), TypeRange{transferType, tokenType},
                      ValueRange{mask});
  Block &body = where.getThenRegion().emplaceBlock();
  rewriter.setInsertionPointToStart(&body);
  LoadOp load = LoadOp::create(rewriter, op.getLoc(), transferType, tokenType,
                               pointer, published, Attribute());
  YieldOp::create(rewriter, op.getLoc(),
                  ValueRange{load.getValue(), load.getToken()});
  rewriter.setInsertionPointAfter(where);
  return {where.getResult(0), where.getResult(1)};
}
struct ScratchAllocation {
  WaveLDSRange range;
  Value allocation, dependency;
};
static FailureOr<ScratchAllocation> createScratchAllocation(
    IRRewriter &rewriter, RedistributeOp op, Type elementType, Type tokenType,
    int64_t transferBytes, const ScratchPlan &plan,
    const ScratchCapacity &capacity, WaveLDSAllocationAnalysis &analysis,
    ScratchSequenceMap &sequences) {
  bool retire = getLatestScratchSequence(op->getBlock(), sequences) &&
                plan.scratchBytes > capacity.overlapBytes;
  Value dependency = capacity.dependency;
  Value placementDependency = capacity.analysisDependency;
  if (retire) {
    if (!dependency)
      return op.emitOpError("scratch retirement is missing its completion");
    if (!dependency.getDefiningOp<BarrierOp>())
      dependency =
          BarrierOp::create(rewriter, op.getLoc(), tokenType, dependency)
              .getToken();
    placementDependency = dependency;
    analysis.refreshTokenOrdering();
    if (!scratchBlockCompleted(op->getBlock(), sequences, analysis,
                               placementDependency))
      return op.emitOpError(
          "scratch retirement does not cover every prior access");
  }
  SmallVector<WaveLDSRange, 4> blocked =
      collectScratchRanges(op, sequences, analysis, placementDependency,
                           /*includeCurrentBlock=*/true);
  WaveLDSRange range{0, plan.scratchBytes};
  IntegerAttr fixedOffset;
  if (capacity.limit) {
    FailureOr<int64_t> offset =
        analysis.findFreeOffset(op, *capacity.limit, plan.scratchBytes,
                                transferBytes, placementDependency, blocked);
    if (failed(offset))
      return failure();
    range.offset = *offset;
    fixedOffset = rewriter.getI64IntegerAttr(*offset);
  }
  PtrType pointerType =
      PtrType::get(op.getContext(), elementType,
                   SharedAddressSpaceAttr::get(op.getContext()));
  AllocOp allocation =
      AllocOp::create(rewriter, op.getLoc(), pointerType,
                      rewriter.getI64IntegerAttr(plan.scratchBytes),
                      rewriter.getI64IntegerAttr(transferBytes), fixedOffset);
  return ScratchAllocation{range, allocation.getResult(), dependency};
}
struct ScratchRelationBasis {
  sym::ExprHandle block, item, slot, zero;
  sym::PredHandle active;
  std::array<int64_t, 3> extents;
  int64_t addressExtent;
};
static FailureOr<ScratchRelationBasis>
buildScratchRelationBasis(sym::Store &store, RedistributeOp op,
                          const ScratchPlan &plan, int64_t elementBits) {
  FailureOr<sym::ExprHandle> block = sym::composeExprSym(store, kBlock);
  FailureOr<sym::ExprHandle> item = sym::composeExprSym(store, kItem);
  FailureOr<sym::ExprHandle> slot = sym::composeExprSym(store, kSlot);
  FailureOr<sym::ExprHandle> zero = sym::composeExprInt(store, 0);
  FailureOr<sym::PredHandle> active = sym::composePredTrue(store);
  if (failed(block) || failed(item) || failed(slot) || failed(zero) ||
      failed(active))
    return failure();
  std::optional<int64_t> addressExtent =
      llvm::checkedMul(plan.scratchBytes, int64_t{8});
  std::optional<int64_t> transferBits =
      llvm::checkedMul(plan.packet.vectorElements, elementBits);
  if (!addressExtent || !transferBits || *addressExtent < *transferBits)
    return failure();
  *addressExtent -= *transferBits - 1;
  return ScratchRelationBasis{
      *block,
      *item,
      *slot,
      *zero,
      *active,
      {op.getRelation().getItems(), plan.packet.vectorElements, elementBits},
      *addressExtent};
}
static FailureOr<MemoryAddress>
buildScratchStoreAddress(sym::Store &store, RedistributeOp op,
                         const ScratchPlan &plan,
                         const ScratchRelationBasis &basis, Value allocation) {
  indexing::IndexMap sourceDomain;
  sourceDomain.inputs = {{basis.block, op.getRelation().getBlocks(), Value(),
                          SymbolicOffsetBindingKind::Uniform},
                         {basis.item, op.getRelation().getItems(), Value(),
                          SymbolicOffsetBindingKind::Lane},
                         {basis.slot, plan.window.localGroups, Value(),
                          SymbolicOffsetBindingKind::Uniform}};
  FailureOr<sym::ExprHandle> physicalItem =
      composeScratchPhysicalItem(store, basis.item, basis.slot, plan.layout);
  if (failed(physicalItem))
    return failure();
  FailureOr<sym::ExprHandle> offset = composeRowMajor(
      store, std::array{basis.slot, *physicalItem, basis.zero, basis.zero},
      basis.extents);
  SmallVector<sym::PredHandle, 8> goals;
  if (failed(offset) ||
      failed(appendCoordinateRequirements(
          store, *physicalItem, op.getRelation().getItems(), goals)) ||
      failed(appendCoordinateRequirements(store, *offset, basis.addressExtent,
                                          goals)))
    return failure();
  llvm::append_range(sourceDomain.requirements, goals);
  sourceDomain.exprs = {basis.block, *offset};
  return MemoryAddress{std::move(sourceDomain), allocation, basis.block,
                       *offset, basis.active};
}
static LogicalResult appendScratchLoadGoals(
    sym::Store &store, RedistributeOp op, const ScratchPlan &plan,
    const ScratchRelationBasis &basis, sym::ExprHandle sourceBlock,
    sym::ExprHandle sourceItem, sym::ExprHandle sourceSlot,
    sym::ExprHandle physicalItem, sym::ExprHandle loadOffset,
    SmallVectorImpl<sym::PredHandle> &goals) {
  if (failed(appendCoordinateRequirements(
          store, sourceBlock, op.getRelation().getBlocks(), goals)) ||
      failed(appendCoordinateRequirements(
          store, sourceItem, op.getRelation().getItems(), goals)) ||
      failed(appendCoordinateRequirements(
          store, sourceSlot, getPacketElementCount(op.getSource().getType()),
          goals)) ||
      failed(appendCoordinateRequirements(store, plan.packet.sourceWithin,
                                          plan.packet.vectorElements, goals)) ||
      failed(appendCoordinateRequirements(store, plan.window.local,
                                          plan.window.localGroups, goals)) ||
      failed(appendCoordinateRequirements(store, plan.window.stage,
                                          plan.window.stageCount, goals)) ||
      failed(appendCoordinateRequirements(
          store, physicalItem, op.getRelation().getItems(), goals)) ||
      failed(appendCoordinateRequirements(store, loadOffset,
                                          basis.addressExtent, goals)))
    return failure();
  return success();
}
static FailureOr<SmallVector<sym::ExprHandle, 4>>
buildScratchStageActive(sym::Store &store, const GroupWindow &window,
                        SmallVectorImpl<sym::PredHandle> &goals) {
  SmallVector<sym::ExprHandle, 4> stageActive;
  for (int64_t stageIndex : llvm::seq<int64_t>(0, window.stageCount)) {
    FailureOr<sym::ExprHandle> stageValue =
        sym::composeExprInt(store, stageIndex);
    FailureOr<sym::PredHandle> active =
        succeeded(stageValue) ? equal(store, window.stage, *stageValue)
                              : FailureOr<sym::PredHandle>(failure());
    if (failed(active))
      return failure();
    FailureOr<sym::ExprHandle> activeExpr =
        composeIndexExprIndicator(store, *active);
    if (failed(activeExpr) ||
        failed(appendCoordinateRequirements(store, *activeExpr, 2, goals)))
      return failure();
    stageActive.push_back(*activeExpr);
  }
  return stageActive;
}
struct ScratchLoadRelation {
  MemoryAddress address;
  SmallVector<sym::ExprHandle, 4> stageActive;
};
static FailureOr<ScratchLoadRelation>
buildScratchLoadRelation(sym::Store &store, RedistributeOp op,
                         const indexing::IndexMap &carrier,
                         const ScratchPlan &plan,
                         const ScratchRelationBasis &basis, Value allocation) {
  auto [sourceBlock, sourceItem, sourceSlot] = getSourceCoordinates(carrier);
  FailureOr<sym::ExprHandle> physicalItem = composeScratchPhysicalItem(
      store, sourceItem, plan.window.local, plan.layout);
  if (failed(physicalItem))
    return failure();
  FailureOr<sym::ExprHandle> offset = composeRowMajor(
      store,
      std::array{plan.window.local, *physicalItem, basis.zero, basis.zero},
      basis.extents);
  FailureOr<sym::PredHandle> sameOwner =
      equal(store, sourceBlock, getInput(carrier, kBlock).variable);
  if (failed(offset) || failed(sameOwner))
    return failure();
  SmallVector<sym::PredHandle, 32> goals;
  if (failed(appendScratchLoadGoals(store, op, plan, basis, sourceBlock,
                                    sourceItem, sourceSlot, *physicalItem,
                                    *offset, goals)))
    return failure();
  goals.push_back(*sameOwner);
  FailureOr<SmallVector<sym::ExprHandle, 4>> stageActive =
      buildScratchStageActive(store, plan.window, goals);
  if (failed(stageActive))
    return failure();
  indexing::IndexMap loadDomain = carrier;
  llvm::append_range(loadDomain.requirements, goals);
  loadDomain.exprs = {sourceBlock, *offset};
  MemoryAddress address{std::move(loadDomain), allocation, sourceBlock, *offset,
                        basis.active};
  return ScratchLoadRelation{std::move(address), std::move(*stageActive)};
}
static FailureOr<ScratchRelation> composeScratchRelation(
    sym::Store &store, RedistributeOp op, const indexing::IndexMap &carrier,
    const ScratchPlan &plan, Value allocation, int64_t elementBits) {
  FailureOr<ScratchRelationBasis> basis =
      buildScratchRelationBasis(store, op, plan, elementBits);
  if (failed(basis))
    return failure();
  FailureOr<MemoryAddress> storeAddress =
      buildScratchStoreAddress(store, op, plan, *basis, allocation);
  FailureOr<ScratchLoadRelation> load =
      buildScratchLoadRelation(store, op, carrier, plan, *basis, allocation);
  if (failed(storeAddress) || failed(load))
    return failure();
  return ScratchRelation{std::move(*storeAddress), std::move(load->address),
                         std::move(load->stageActive)};
}
static LogicalResult prepareScratchMaterializers(
    RedistributeOp op, const ScratchPlan &plan, const ScratchRelation &relation,
    const CheckedIndexExpr &storeOffset, const CheckedIndexExpr &loadOffset,
    ExprMaterializer &storeMaterializer, ExprMaterializer &loadMaterializer) {
  SmallVector<ExprMaterializationPoint> storePoints;
  for (int64_t group : llvm::seq<int64_t>(0, plan.window.localGroups))
    storePoints.push_back({storeOffset.expression, group});
  if (failed(storeMaterializer.prepare(storePoints)))
    return op.emitOpError("failed to prepare canonical scratch stores");
  int64_t resultSlots = getPacketElementCount(op.getResult().getType());
  SmallVector<ExprMaterializationPoint> loadPoints;
  for (sym::ExprHandle active : relation.stageActive)
    for (int64_t slot : llvm::seq<int64_t>(0, resultSlots)) {
      loadPoints.push_back({loadOffset.expression, slot});
      loadPoints.push_back({plan.packet.sourceWithin, slot});
      loadPoints.push_back({active, slot});
    }
  if (failed(loadMaterializer.prepare(loadPoints)))
    return op.emitOpError("failed to prepare canonical scratch loads");
  return success();
}
struct ScratchOffsets {
  CheckedIndexExpr store, load;
};
static FailureOr<ScratchOffsets>
getScratchOffsets(WaveDialect &dialect, RedistributeOp op,
                  const ScratchRelation &relation, int64_t elementBits) {
  FailureOr<std::optional<CheckedIndexExpr>> store =
      getMemoryAddressElementOffset(dialect, relation.store, elementBits);
  if (failed(store) || !*store)
    return op.emitOpError("could not prove canonical scratch store address");
  FailureOr<std::optional<CheckedIndexExpr>> load =
      getMemoryAddressElementOffset(dialect, relation.load, elementBits);
  if (failed(load) || !*load)
    return op.emitOpError("could not prove canonical scratch load address");
  return ScratchOffsets{std::move(**store), std::move(**load)};
}
struct ScratchLoweringSetup {
  ScratchPlan plan;
  ScratchAllocation scratch;
  ScratchRelation relation;
  ScratchOffsets offsets;
  Type tokenType, elementType;
  int64_t elementBits, transferBytes;
};
static FailureOr<ScratchLoweringSetup>
prepareScratchLowering(IRRewriter &rewriter, RedistributeOp op,
                       WaveDialect &dialect, const indexing::IndexMap &carrier,
                       func::FuncOp func, WaveLDSAllocationAnalysis &analysis,
                       ScratchSequenceMap &sequences) {
  sym::Store &store = dialect.getSymbolStore();
  FailureOr<int64_t> requestedBytes = getScratchBytes(op);
  if (failed(requestedBytes))
    return failure();
  FailureOr<ScratchCapacity> capacity = getScratchCapacity(
      rewriter, op, func, analysis, *requestedBytes, sequences);
  if (failed(capacity))
    return failure();
  FailureOr<ScratchPlan> plan =
      buildScratchPlan(store, op, carrier, capacity->availableBytes);
  if (failed(plan))
    return failure();
  Type tokenType = MemTokenType::get(op.getContext());
  Type elementType = getPacketScalarType(op.getSource().getType());
  int64_t elementBits = elementType.getIntOrFloatBitWidth();
  std::optional<int64_t> transferBytes =
      llvm::checkedMul(elementBits / 8, plan->packet.vectorElements);
  if (!transferBytes)
    return op.emitOpError("cross-wave scratch transfer size overflows i64");
  FailureOr<ScratchAllocation> scratch = createScratchAllocation(
      rewriter, op, elementType, tokenType, *transferBytes, *plan, *capacity,
      analysis, sequences);
  if (failed(scratch))
    return failure();
  FailureOr<ScratchRelation> relation = composeScratchRelation(
      store, op, carrier, *plan, scratch->allocation, elementBits);
  if (failed(relation))
    return failure();
  FailureOr<ScratchOffsets> offsets =
      getScratchOffsets(dialect, op, *relation, elementBits);
  if (failed(offsets))
    return failure();
  return ScratchLoweringSetup{
      std::move(*plan),    std::move(*scratch), std::move(*relation),
      std::move(*offsets), tokenType,           elementType,
      elementBits,         *transferBytes};
}
static FailureOr<SmallVector<Value>>
emitScratchStageStores(IRRewriter &rewriter, RedistributeOp op,
                       ScratchLoweringSetup &setup,
                       ExprMaterializer &materializer, ArrayRef<Value> source,
                       int64_t stageIndex) {
  const PacketPlan &packet = setup.plan.packet;
  const GroupWindow &window = setup.plan.window;
  SmallVector<Value> stores;
  for (int64_t localGroup : llvm::seq<int64_t>(0, window.localGroups)) {
    int64_t sourceGroup = stageIndex * window.localGroups + localGroup;
    if (sourceGroup >= packet.sourceGroups)
      break;
    FailureOr<MaterializedExpr> offset =
        materializer.materialize(setup.offsets.store.expression, localGroup);
    FailureOr<Value> pointer =
        succeeded(offset) ? buildPointer(rewriter, op, materializer,
                                         setup.scratch.allocation, *offset)
                          : FailureOr<Value>(failure());
    if (failed(pointer))
      return op.emitOpError("failed to materialize canonical scratch store");
    stores.push_back(StoreOp::create(rewriter, op.getLoc(), setup.tokenType,
                                     source[sourceGroup], *pointer,
                                     setup.scratch.dependency, Attribute())
                         .getToken());
  }
  return stores;
}
using ScratchLoadedPackets = DenseMap<int64_t, SmallVector<Value>>;
static FailureOr<SmallVector<Value> *> getScratchLoadedPacket(
    IRRewriter &rewriter, RedistributeOp op, ScratchLoweringSetup &setup,
    ExprMaterializer &materializer, const ScratchLoadPredicate &predicate,
    const MaterializedExpr &offset, int64_t resultGroup, Value published,
    ScratchLoadedPackets &loadedPackets,
    SmallVectorImpl<Value> &completionTokens) {
  auto loaded = loadedPackets.find(resultGroup);
  if (loaded == loadedPackets.end()) {
    FailureOr<Value> pointer = buildPointer(rewriter, op, materializer,
                                            setup.scratch.allocation, offset);
    if (failed(pointer))
      return op.emitOpError("failed to build canonical scratch pointer");
    Type transferType = getPacketSliceType(op.getSource().getType(),
                                           setup.plan.packet.vectorElements);
    auto [packet, token] =
        emitScratchLoad(rewriter, op, transferType, setup.tokenType, *pointer,
                        published, predicate.mask);
    completionTokens.push_back(token);
    loaded = loadedPackets
                 .try_emplace(resultGroup,
                              extractComponents(rewriter, op.getLoc(), packet))
                 .first;
  }
  return &loaded->second;
}
static Value mergeScratchLoadedValue(IRRewriter &rewriter, RedistributeOp op,
                                     Type componentType, Value mask,
                                     Value value, Value &previous,
                                     Value &inactive) {
  if (!mask)
    return value;
  if (!previous) {
    if (!inactive) {
      Type payload = cast<SimdType>(componentType).getElementType();
      inactive = ConstantOp::create(rewriter, op.getLoc(), componentType,
                                    rewriter.getZeroAttr(payload));
    }
    previous = inactive;
  }
  return SelectOp::create(rewriter, op.getLoc(), componentType, mask, value,
                          previous);
}
static LogicalResult loadScratchStageSlot(
    IRRewriter &rewriter, RedistributeOp op, ScratchLoweringSetup &setup,
    ExprMaterializer &materializer, sym::ExprHandle active, int64_t slot,
    Value published, DenseMap<sym::ExprHandle, Value> &masks,
    ScratchLoadedPackets &loadedPackets,
    SmallVectorImpl<Value> &completionTokens, MutableArrayRef<Value> result,
    Value &inactive) {
  FailureOr<ScratchLoadPredicate> predicate = buildScratchLoadPredicate(
      rewriter, op, materializer, active, slot, masks);
  if (failed(predicate))
    return failure();
  if (!predicate->active)
    return success();
  FailureOr<MaterializedExpr> offset =
      materializer.materialize(setup.offsets.load.expression, slot);
  FailureOr<MaterializedExpr> within =
      materializer.materialize(setup.plan.packet.sourceWithin, slot);
  if (failed(offset) || failed(within))
    return op.emitOpError("failed to materialize canonical scratch load");
  int64_t resultSlots = getPacketElementCount(op.getResult().getType());
  int64_t packedSlot = logicalToPackedSlot(setup.plan.packet.resultWithinMask,
                                           resultSlots, slot);
  int64_t resultGroup = packedSlot / setup.plan.packet.vectorElements;
  FailureOr<SmallVector<Value> *> loaded = getScratchLoadedPacket(
      rewriter, op, setup, materializer, *predicate, *offset, resultGroup,
      published, loadedPackets, completionTokens);
  if (failed(loaded))
    return failure();
  FailureOr<Value> selected =
      selectComponent(rewriter, op, materializer, **loaded, *within);
  if (failed(selected))
    return op.emitOpError("failed to select scratch vector component");
  result[slot] = mergeScratchLoadedValue(
      rewriter, op, getPacketElementType(op.getSource().getType()),
      predicate->mask, *selected, result[slot], inactive);
  return success();
}
static LogicalResult
emitScratchStageLoads(IRRewriter &rewriter, RedistributeOp op,
                      ScratchLoweringSetup &setup,
                      ExprMaterializer &materializer, sym::ExprHandle active,
                      Value published, SmallVectorImpl<Value> &completionTokens,
                      MutableArrayRef<Value> result, Value &inactive) {
  DenseMap<sym::ExprHandle, Value> masks;
  ScratchLoadedPackets loadedPackets;
  for (int64_t slot : llvm::seq<int64_t>(0, result.size()))
    if (failed(loadScratchStageSlot(rewriter, op, setup, materializer, active,
                                    slot, published, masks, loadedPackets,
                                    completionTokens, result, inactive)))
      return failure();
  return success();
}
static LogicalResult lowerScratchStage(
    IRRewriter &rewriter, RedistributeOp op, ScratchLoweringSetup &setup,
    ExprMaterializer &storeMaterializer, ExprMaterializer &loadMaterializer,
    ArrayRef<Value> source, int64_t stageIndex,
    SmallVectorImpl<Value> &completionTokens, MutableArrayRef<Value> result,
    Value &analysisCompletion, Value &inactive) {
  FailureOr<SmallVector<Value>> stores = emitScratchStageStores(
      rewriter, op, setup, storeMaterializer, source, stageIndex);
  if (failed(stores))
    return failure();
  Value published =
      BarrierOp::create(rewriter, op.getLoc(), setup.tokenType, *stores)
          .getToken();
  analysisCompletion = published;
  completionTokens.clear();
  sym::ExprHandle active = setup.relation.stageActive[stageIndex];
  if (failed(emitScratchStageLoads(rewriter, op, setup, loadMaterializer,
                                   active, published, completionTokens, result,
                                   inactive)))
    return failure();
  if (completionTokens.empty())
    completionTokens.push_back(published);
  if (stageIndex + 1 != setup.plan.window.stageCount)
    setup.scratch.dependency =
        BarrierOp::create(rewriter, op.getLoc(), setup.tokenType,
                          completionTokens)
            .getToken();
  return success();
}
static LogicalResult lowerWorkgroup(IRRewriter &rewriter, RedistributeOp op,
                                    WaveDialect &dialect,
                                    const indexing::IndexMap &carrier,
                                    func::FuncOp func,
                                    WaveLDSAllocationAnalysis &analysis,
                                    ScratchSequenceMap &sequences) {
  sym::Store &store = dialect.getSymbolStore();
  FailureOr<ScratchLoweringSetup> setup = prepareScratchLowering(
      rewriter, op, dialect, carrier, func, analysis, sequences);
  if (failed(setup))
    return failure();
  ExprMaterializer storeMaterializer(rewriter, op, store,
                                     setup->offsets.store.domain);
  ExprMaterializer loadMaterializer(rewriter, op, store,
                                    setup->offsets.load.domain);
  if (failed(prepareScratchMaterializers(
          op, setup->plan, setup->relation, setup->offsets.store,
          setup->offsets.load, storeMaterializer, loadMaterializer)))
    return failure();
  SmallVector<Value> source =
      extractPacketSlices(rewriter, op, setup->plan.packet);
  int64_t resultSlots = getPacketElementCount(op.getResult().getType());
  SmallVector<Value> result(resultSlots);
  SmallVector<Value> completionTokens;
  Value analysisCompletion;
  Value inactive;
  for (int64_t stageIndex :
       llvm::seq<int64_t>(0, setup->plan.window.stageCount))
    if (failed(lowerScratchStage(rewriter, op, *setup, storeMaterializer,
                                 loadMaterializer, source, stageIndex,
                                 completionTokens, result, analysisCompletion,
                                 inactive)))
      return failure();
  if (llvm::any_of(result, [](Value value) { return !value; }))
    return op.emitOpError("canonical scratch stages did not cover result");
  Value packed = packPacket(rewriter, op, result);
  Value completed =
      JoinOp::create(rewriter, op.getLoc(), setup->tokenType, completionTokens);
  AllocReleaseOp released = AllocReleaseOp::create(
      rewriter, op.getLoc(), setup->tokenType, setup->scratch.allocation,
      completed, rewriter.getUnitAttr());
  sequences[op->getBlock()].push_back({released.getToken(), completed,
                                       analysisCompletion, released,
                                       setup->scratch.range});
  rewriter.replaceOp(op, packed);
  return success();
}
static bool canCompose(RedistributeOp previous, RedistributeOp op) {
  return previous->getBlock() == op->getBlock() &&
         previous.getResult().hasOneUse() &&
         previous.getRelation().getBlocks() == op.getRelation().getBlocks() &&
         previous.getRelation().getItems() == op.getRelation().getItems();
}
struct ComposedRedistributionChain {
  indexing::IndexMap carrier;
  Value source;
  SmallVector<RedistributeOp> ops;
};
static FailureOr<ComposedRedistributionChain>
composeRedistributionChain(sym::Store &store, RedistributeOp op,
                           indexing::IndexMap carrier,
                           RedistributeOp previous) {
  Value source = op.getSource();
  SmallVector<RedistributeOp> composedOps;
  do {
    FailureOr<indexing::IndexMap> previousCarrier =
        buildCarrier(store, previous);
    if (failed(previousCarrier))
      return failure();
    auto destination = getSourceCoordinates(carrier);
    std::array<sym::ExprSubstitution, 3> transport{
        sym::ExprSubstitution{getInput(*previousCarrier, kBlock).variable,
                              destination[0]},
        sym::ExprSubstitution{getInput(*previousCarrier, kItem).variable,
                              destination[1]},
        sym::ExprSubstitution{getInput(*previousCarrier, kSlot).variable,
                              destination[2]}};
    FailureOr<indexing::IndexMap> composed = indexing::pullback(
        store, *previousCarrier, carrier, transport, "carrier");
    if (failed(composed))
      return op.emitOpError("failed to compose redistribution carriers");
    carrier = std::move(*composed);
    source = previous.getSource();
    composedOps.push_back(previous);
    previous = source.getDefiningOp<RedistributeOp>();
  } while (previous && canCompose(previous, op));
  return ComposedRedistributionChain{std::move(carrier), source,
                                     std::move(composedOps)};
}
static FailureOr<std::array<sym::ExprHandle, 3>>
materializeCarrierCoordinates(sym::Store &store,
                              const indexing::IndexMap &carrier) {
  std::array coordinates = getSourceCoordinates(carrier);
  for (sym::ExprHandle &coordinate : coordinates) {
    FailureOr<sym::ExprHandle> concrete =
        indexing::materialize(store, carrier, coordinate);
    if (failed(concrete))
      return failure();
    coordinate = *concrete;
  }
  return coordinates;
}
static FailureOr<bool> composeAdjacent(IRRewriter &rewriter, RedistributeOp op,
                                       sym::Store &store,
                                       DenseSet<Operation *> &erased) {
  RedistributeOp previous = op.getSource().getDefiningOp<RedistributeOp>();
  if (!previous || !canCompose(previous, op))
    return false;
  FailureOr<indexing::IndexMap> carrier = buildCarrier(store, op);
  if (failed(carrier))
    return failure();
  FailureOr<ComposedRedistributionChain> chain =
      composeRedistributionChain(store, op, std::move(*carrier), previous);
  if (failed(chain))
    return failure();
  FailureOr<sym::CheckResult> total =
      indexing::check(store, chain->carrier, {});
  if (failed(total) || *total != sym::CheckResult::True)
    return op.emitOpError(
        "composed redistribution relation is not total on its domain");
  op->setOperand(0, chain->source);
  FailureOr<std::array<sym::ExprHandle, 3>> coordinates =
      materializeCarrierCoordinates(store, chain->carrier);
  if (failed(coordinates))
    return failure();
  op.setRelationAttr(
      RedistributionAttr::get(op.getContext(), op.getRelation().getBlocks(),
                              op.getRelation().getItems(), (*coordinates)[0],
                              (*coordinates)[1], (*coordinates)[2]));
  if (failed(op.verify()))
    return failure();
  for (RedistributeOp composed : chain->ops) {
    erased.insert(composed.getOperation());
    rewriter.eraseOp(composed);
  }
  return true;
}
static LogicalResult lowerWorkgroupRedistribution(
    IRRewriter &rewriter, RedistributeOp op, WaveDialect &dialect,
    const indexing::IndexMap &carrier, func::FuncOp func,
    std::unique_ptr<WaveLDSAllocationAnalysis> &analysis,
    ScratchSequenceMap &sequences) {
  if (isa<PtrType>(getPacketScalarType(op.getSource().getType())))
    return op.emitOpError("cross-wave pointer redistribution is unsupported");
  if (!func.getBody().hasOneBlock())
    return op.emitOpError(
        "cross-wave redistribution requires a single-block kernel function");
  if (!analysis) {
    FailureOr<std::unique_ptr<WaveLDSAllocationAnalysis>> created =
        WaveLDSAllocationAnalysis::create(func);
    if (failed(created))
      return failure();
    analysis = std::move(*created);
  }
  return lowerWorkgroup(rewriter, op, dialect, carrier, func, *analysis,
                        sequences);
}
static LogicalResult
lowerRedistribution(IRRewriter &rewriter, RedistributeOp op,
                    WaveDialect &dialect, func::FuncOp func,
                    std::unique_ptr<WaveLDSAllocationAnalysis> &analysis,
                    ScratchSequenceMap &sequences) {
  rewriter.setInsertionPoint(op);
  FailureOr<indexing::IndexMap> carrier =
      buildCarrier(dialect.getSymbolStore(), op);
  if (failed(carrier))
    return op.emitOpError("failed to build redistribution carrier");
  int64_t width = cast<SimdType>(op.getSource().getType()).getWidth();
  FailureOr<Movement> movement = validateAndClassifyMovement(
      dialect.getSymbolStore(), op, *carrier, width);
  if (failed(movement))
    return failure();
  if (failed(validateWorkgroup(op, func, width)))
    return failure();
  switch (*movement) {
  case Movement::Alias: {
    rewriter.replaceOp(op, op.getSource());
    return success();
  }
  case Movement::Workitem: {
    return lowerWorkitem(rewriter, op, dialect.getSymbolStore(), *carrier);
  }
  case Movement::Wave: {
    return lowerWave(rewriter, op, dialect.getSymbolStore(), *carrier, width);
  }
  case Movement::Workgroup: {
    return lowerWorkgroupRedistribution(rewriter, op, dialect, *carrier, func,
                                        analysis, sequences);
  }
  case Movement::Cluster:
    return op.emitOpError("cluster/DSM redistribution is unsupported");
  }
  llvm_unreachable("unknown redistribution movement");
}
static LogicalResult lowerFunc(func::FuncOp func, WaveDialect &dialect,
                               IRRewriter &rewriter,
                               SymbolicTransformTiming &timing) {
  SmallVector<ReduceOp> reductions;
  {
    TimingScope reductionTiming = timing.nest("redistribute_lower_reductions");
    func.walk([&](ReduceOp op) { reductions.push_back(op); });
    for (ReduceOp op : reductions)
      if (failed(lowerReduction(rewriter, op, dialect)))
        return failure();
  }
  SmallVector<RedistributeOp> ops;
  {
    TimingScope collectTiming = timing.nest("redistribute_collect");
    func.walk([&](RedistributeOp op) { ops.push_back(op); });
  }
  if (ops.empty())
    return success();
  DenseSet<Operation *> erased;
  {
    TimingScope composeTiming = timing.nest("redistribute_compose_adjacent");
    for (RedistributeOp op : llvm::reverse(ops)) {
      if (erased.contains(op.getOperation()))
        continue;
      if (failed(
              composeAdjacent(rewriter, op, dialect.getSymbolStore(), erased)))
        return failure();
    }
  }
  ScratchSequenceMap sequences;
  std::unique_ptr<WaveLDSAllocationAnalysis> analysis;
  TimingScope lowerTiming = timing.nest("redistribute_plan_and_lower");
  for (RedistributeOp op : ops) {
    if (erased.contains(op.getOperation()))
      continue;
    if (failed(lowerRedistribution(rewriter, op, dialect, func, analysis,
                                   sequences)))
      return failure();
  }
  return success();
}
struct WaveLowerRedistributePass
    : public wave::impl::WaveLowerRedistributeBase<WaveLowerRedistributePass> {
  void runOnOperation() override {
    SymbolicTransformTiming timing("lower_redistribute");
    WaveDialect *dialect = getContext().getLoadedDialect<WaveDialect>();
    if (!dialect) {
      getOperation()->emitError("Wave dialect is not loaded");
      return signalPassFailure();
    }
    IRRewriter rewriter(&getContext());
    SmallVector<func::FuncOp> funcs;
    {
      TimingScope collectTiming = timing.nest("redistribute_collect_functions");
      if (auto func = dyn_cast<func::FuncOp>(getOperation()))
        funcs.push_back(func);
      else
        getOperation()->walk([&](func::FuncOp func) { funcs.push_back(func); });
    }
    for (func::FuncOp func : funcs)
      if (failed(lowerFunc(func, *dialect, rewriter, timing)))
        return signalPassFailure();
  }
};
} // namespace
