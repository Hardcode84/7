//===- WaveAMDRegAllocSGPRToVGPRRelief.cpp - SGPR relief -----------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "WaveAMDRegAllocTransformLoop.h"
#include "WaveAMDRegAllocTransformState.h"
#include "WaveAMDRegAllocTransformUtils.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachine.h"
#include "mlir/IR/Builders.h"
#include "mlir/IR/BuiltinTypes.h"
#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/DenseSet.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/ADT/SmallSet.h"
#include <optional>

using namespace mlir;
using namespace mlir::wave::regalloc_detail;

namespace {

static constexpr StringLiteral kSGPRToVGPRTempAttr =
    "waveamdmachine.regalloc_sgpr_to_vgpr_temp";

struct SGPRToVGPRReliefScore {
  unsigned liveDwords = 0;
  int64_t bridgeCost = 0;
  int64_t bridgeCount = 0;
  int64_t loopBridgeCost = 0;
  unsigned end = 0;
};

struct SGPRToVGPRReliefCandidate {
  SmallVector<ResolvedRegAllocValue> values;
  SGPRToVGPRReliefScore score;
  unsigned promotedDwords = 0;
  unsigned setId = 0;
};

struct SGPRToVGPRReliefPlan {
  SmallVector<SGPRToVGPRReliefCandidate> candidates;
  unsigned promotedDwords = 0;
};

static bool
isSGPRToVGPRRelievableFailure(const RegAllocTransformFailure &failure) {
  bool relievableClass = failure.className == "sgpr";
  bool relievableReason =
      failure.reason == "pressure" || failure.reason == "allocated-footprint";
  return relievableClass && relievableReason;
}

static SmallVector<unsigned>
collectSGPRReliefCandidateIds(const RegAllocTransformFailure &failure) {
  SmallVector<unsigned> ids;
  DenseSet<unsigned> seen;
  auto add = [&](unsigned id) {
    if (seen.insert(id).second)
      ids.push_back(id);
  };
  add(failure.set);
  for (const wave::RegAllocTransformAssignment &overlap : failure.overlaps)
    if (overlap.regClass == waveamdmachine::RegClass::SGPR)
      add(overlap.set);
  return ids;
}

static waveamdmachine::RegType
getRegAllocTransformClassType(Value value, waveamdmachine::RegClass regClass) {
  auto type = cast<waveamdmachine::RegType>(value.getType());
  return waveamdmachine::RegType::get(type.getContext(), regClass,
                                      type.getWidth(), /*index=*/-1);
}

static bool isFuncEntryBlockArgument(Value value, func::FuncOp func) {
  auto arg = dyn_cast<BlockArgument>(value);
  return arg && arg.getOwner() == &func.getBody().front();
}

static bool isSGPRToVGPRTempMove(Operation *op) {
  return isa_and_nonnull<waveamdmachine::VMovB32TupleOp>(op) &&
         op->hasAttr(kSGPRToVGPRTempAttr);
}

static bool hasSGPRToVGPRTempUse(Value value) {
  return llvm::any_of(value.getUses(), [](OpOperand &use) {
    return isSGPRToVGPRTempMove(use.getOwner());
  });
}

static bool isPromotableSGPRValue(func::FuncOp func,
                                  const ResolvedRegAllocValue &resolved) {
  Value value = resolved.first;
  const wave::RegAllocTransformValue &stateValue = *resolved.second;
  auto type = dyn_cast<waveamdmachine::RegType>(value.getType());
  if (!type || type.getRegClass() != waveamdmachine::RegClass::SGPR ||
      type.getIndex() >= 0 || stateValue.regClass != type.getRegClass() ||
      stateValue.width != static_cast<unsigned>(type.getWidth()))
    return false;
  if (stateValue.fixed || hasSGPRToVGPRTempUse(value))
    return false;
  if (isa<BlockArgument>(value))
    return isFuncEntryBlockArgument(value, func);
  return value.getDefiningOp() != nullptr;
}

static bool
valueSetLiveAtPosition(const wave::RegAllocTransformAliasSet &set,
                       ArrayRef<wave::RegAllocTransformValue> values,
                       unsigned position) {
  return llvm::any_of(set.members, [&](unsigned valueId) {
    return valueId < values.size() &&
           valueLiveAtPosition(values[valueId], position);
  });
}

static unsigned
getSGPRToVGPRReliefLiveDwords(const wave::RegAllocTransformAliasSet &set,
                              ArrayRef<wave::RegAllocTransformValue> values,
                              unsigned position) {
  SmallVector<char, 8> live(set.width, 0);
  unsigned count = 0;
  for (unsigned valueId : set.members) {
    const wave::RegAllocTransformValue &value = values[valueId];
    if (!valueLiveAtPosition(value, position))
      continue;
    unsigned begin = static_cast<unsigned>(value.offset);
    if (begin >= set.width)
      continue;
    unsigned end = std::min<unsigned>(set.width, begin + value.width);
    for (unsigned lane : llvm::seq(begin, end)) {
      if (live[lane])
        continue;
      live[lane] = 1;
      ++count;
    }
  }
  return count;
}

static unsigned
getSGPRToVGPRReliefEnd(const wave::RegAllocTransformAliasSet &set,
                       ArrayRef<wave::RegAllocTransformValue> values) {
  unsigned end = 0;
  for (unsigned valueId : set.members)
    end = std::max(end, values[valueId].end);
  return end;
}

struct SGPRToVGPRBridgeCost {
  int64_t cost = 0;
  int64_t count = 0;
  int64_t loopCost = 0;

  void add(Operation *op) {
    ++count;
    int64_t scale = getParentLoopCostScale(op);
    if (scale == 1)
      ++cost;
    else
      loopCost += scale;
  }
};

static SGPRToVGPRBridgeCost
getSGPRToVGPRBridgeCost(ArrayRef<ResolvedRegAllocValue> values) {
  SGPRToVGPRBridgeCost cost;
  for (const ResolvedRegAllocValue &value : values) {
    for (OpOperand &use : value.first.getUses()) {
      if (isa<func::ReturnOp>(use.getOwner()))
        continue;
      cost.add(use.getOwner());
    }
  }
  return cost;
}

static bool returnUsesStayConsistent(func::FuncOp func,
                                     ArrayRef<ResolvedRegAllocValue> values) {
  DenseSet<Value> selected;
  llvm::SmallSet<unsigned, 4> promotedResults;
  for (const ResolvedRegAllocValue &value : values) {
    selected.insert(value.first);
    for (OpOperand &use : value.first.getUses())
      if (isa<func::ReturnOp>(use.getOwner()))
        promotedResults.insert(use.getOperandNumber());
  }
  if (promotedResults.empty())
    return true;

  bool consistent = true;
  func.walk([&](func::ReturnOp ret) {
    for (unsigned result : promotedResults) {
      if (result >= ret.getNumOperands() ||
          !selected.contains(ret.getOperand(result))) {
        consistent = false;
        return WalkResult::interrupt();
      }
    }
    return WalkResult::advance();
  });
  return consistent;
}

static FailureOr<SmallVector<ResolvedRegAllocValue>>
getResolvedSGPRToVGPRSetValues(func::FuncOp func,
                               const wave::RegAllocTransformAliasSet &set,
                               ArrayRef<ResolvedRegAllocValue> resolvedValues) {
  SmallVector<ResolvedRegAllocValue> setValues;
  setValues.reserve(set.members.size());
  for (unsigned valueId : set.members) {
    if (valueId >= resolvedValues.size() ||
        resolvedValues[valueId].second->id != valueId)
      return func.emitError("regalloc state member value id is invalid");
    setValues.push_back(resolvedValues[valueId]);
  }
  return setValues;
}

static SGPRToVGPRReliefScore
getSGPRToVGPRReliefScore(const wave::RegAllocTransformAliasSet &set,
                         ArrayRef<wave::RegAllocTransformValue> values,
                         ArrayRef<ResolvedRegAllocValue> resolvedValues,
                         unsigned position) {
  SGPRToVGPRBridgeCost bridgeCost = getSGPRToVGPRBridgeCost(resolvedValues);
  return {getSGPRToVGPRReliefLiveDwords(set, values, position), bridgeCost.cost,
          bridgeCost.count, bridgeCost.loopCost,
          getSGPRToVGPRReliefEnd(set, values)};
}

static int64_t getSGPRToVGPRPrimaryCost(SGPRToVGPRReliefScore score) {
  return score.bridgeCost + score.loopBridgeCost;
}

static bool isBetterSGPRToVGPRReliefScore(SGPRToVGPRReliefScore lhs,
                                          SGPRToVGPRReliefScore rhs) {
  int64_t lhsCost = getSGPRToVGPRPrimaryCost(lhs);
  int64_t rhsCost = getSGPRToVGPRPrimaryCost(rhs);
  if (lhsCost != rhsCost)
    return lhsCost < rhsCost;
  if (lhs.bridgeCost != rhs.bridgeCost)
    return lhs.bridgeCost < rhs.bridgeCost;
  if (lhs.bridgeCount != rhs.bridgeCount)
    return lhs.bridgeCount < rhs.bridgeCount;
  if (lhs.loopBridgeCost != rhs.loopBridgeCost)
    return lhs.loopBridgeCost < rhs.loopBridgeCost;
  if (lhs.liveDwords != rhs.liveDwords)
    return lhs.liveDwords > rhs.liveDwords;
  return lhs.end > rhs.end;
}

static FailureOr<std::optional<SGPRToVGPRReliefCandidate>>
buildSGPRToVGPRReliefCandidate(func::FuncOp func, unsigned setId,
                               const RegAllocTransformFailure &failureRecord,
                               ArrayRef<wave::RegAllocTransformAliasSet> sets,
                               ArrayRef<wave::RegAllocTransformValue> values,
                               ArrayRef<ResolvedRegAllocValue> resolvedValues) {
  const wave::RegAllocTransformAliasSet *set =
      findRegAllocTransformSet(sets, setId);
  if (!set || set->regClass != waveamdmachine::RegClass::SGPR ||
      set->width == 0 || hasFixedRegAllocValue(*set, values) ||
      !valueSetLiveAtPosition(*set, values, failureRecord.position))
    return std::optional<SGPRToVGPRReliefCandidate>();

  FailureOr<SmallVector<ResolvedRegAllocValue>> setValues =
      getResolvedSGPRToVGPRSetValues(func, *set, resolvedValues);
  if (failed(setValues))
    return failure();
  if (!llvm::all_of(*setValues, [&](const ResolvedRegAllocValue &value) {
        return isPromotableSGPRValue(func, value);
      }))
    return std::optional<SGPRToVGPRReliefCandidate>();
  if (!returnUsesStayConsistent(func, *setValues))
    return std::optional<SGPRToVGPRReliefCandidate>();

  SGPRToVGPRReliefCandidate candidate;
  candidate.values = std::move(*setValues);
  candidate.score = getSGPRToVGPRReliefScore(*set, values, candidate.values,
                                             failureRecord.position);
  candidate.promotedDwords = set->width;
  candidate.setId = set->id;
  return std::optional<SGPRToVGPRReliefCandidate>(std::move(candidate));
}

static bool
isBetterSGPRToVGPRReliefCandidate(const SGPRToVGPRReliefCandidate &lhs,
                                  const SGPRToVGPRReliefCandidate &rhs) {
  if (isBetterSGPRToVGPRReliefScore(lhs.score, rhs.score))
    return true;
  if (isBetterSGPRToVGPRReliefScore(rhs.score, lhs.score))
    return false;
  return lhs.setId < rhs.setId;
}

static unsigned
getRequiredSGPRToVGPRReliefDwords(const RegAllocTransformFailure &failure) {
  if (failure.pressure && failure.limit && *failure.pressure > *failure.limit)
    return *failure.pressure - *failure.limit;
  return std::max(1u, failure.request.value_or(1));
}

static FailureOr<std::optional<SGPRToVGPRReliefPlan>>
selectSGPRToVGPRReliefPlan(func::FuncOp func,
                           const RegAllocTransformFailure &failureRecord,
                           ArrayRef<wave::RegAllocTransformAliasSet> sets,
                           ArrayRef<wave::RegAllocTransformValue> values,
                           ArrayRef<ResolvedRegAllocValue> resolvedValues) {
  SmallVector<SGPRToVGPRReliefCandidate> candidates;
  for (unsigned setId : collectSGPRReliefCandidateIds(failureRecord)) {
    FailureOr<std::optional<SGPRToVGPRReliefCandidate>> candidate =
        buildSGPRToVGPRReliefCandidate(func, setId, failureRecord, sets, values,
                                       resolvedValues);
    if (failed(candidate))
      return failure();
    if (*candidate)
      candidates.push_back(std::move(**candidate));
  }
  if (candidates.empty())
    return std::optional<SGPRToVGPRReliefPlan>();
  llvm::sort(candidates, isBetterSGPRToVGPRReliefCandidate);

  unsigned requiredDwords = getRequiredSGPRToVGPRReliefDwords(failureRecord);
  unsigned relievedDwords = 0;
  SGPRToVGPRReliefPlan plan;
  for (SGPRToVGPRReliefCandidate &candidate : candidates) {
    relievedDwords += candidate.score.liveDwords;
    plan.promotedDwords += candidate.promotedDwords;
    plan.candidates.push_back(std::move(candidate));
    if (relievedDwords >= requiredDwords)
      break;
  }
  return std::optional<SGPRToVGPRReliefPlan>(std::move(plan));
}

static Value createSGPRReadFirst(OpBuilder &builder, Location loc, Value vgpr) {
  auto type = cast<waveamdmachine::RegType>(vgpr.getType());
  MLIRContext *context = type.getContext();
  Type sgpr1 = waveamdmachine::RegType::get(
      context, waveamdmachine::RegClass::SGPR, 1, /*index=*/-1);
  if (type.getWidth() == 1)
    return waveamdmachine::VReadfirstlaneB32Op::create(builder, loc, sgpr1,
                                                       vgpr);

  Type vgpr1 = waveamdmachine::RegType::get(
      context, waveamdmachine::RegClass::VGPR, 1, /*index=*/-1);
  SmallVector<Type, 4> elementTypes(type.getWidth(), vgpr1);
  auto split = waveamdmachine::TupleToElementsOp::create(builder, loc,
                                                         elementTypes, vgpr);
  SmallVector<Value, 4> words;
  for (Value word : split.getElements())
    words.push_back(
        waveamdmachine::VReadfirstlaneB32Op::create(builder, loc, sgpr1, word));
  Type resultType = waveamdmachine::RegType::get(
      context, waveamdmachine::RegClass::SGPR, type.getWidth(),
      /*index=*/-1);
  return waveamdmachine::TupleFromElementsOp::create(builder, loc, resultType,
                                                     words)
      .getTuple();
}

static DenseMap<Value, SmallVector<OpOperand *>>
collectSGPRToVGPRUses(ArrayRef<ResolvedRegAllocValue> values) {
  DenseMap<Value, SmallVector<OpOperand *>> uses;
  for (const ResolvedRegAllocValue &value : values)
    for (OpOperand &use : value.first.getUses())
      uses[value.first].push_back(&use);
  return uses;
}

static LogicalResult refreshFuncTypeFromBody(func::FuncOp func) {
  if (func.isDeclaration())
    return success();
  SmallVector<Type> inputs(func.getBody().front().getArgumentTypes());
  SmallVector<Type> outputs;
  bool haveReturn = false;
  WalkResult walk = func.walk([&](func::ReturnOp ret) {
    SmallVector<Type> current(ret.getOperandTypes());
    if (!haveReturn) {
      outputs = std::move(current);
      haveReturn = true;
      return WalkResult::advance();
    }
    if (outputs != current)
      return WalkResult::interrupt();
    return WalkResult::advance();
  });
  if (walk.wasInterrupted())
    return func.emitError("regalloc SGPR to VGPR relief saw inconsistent "
                          "return types");
  if (!haveReturn)
    outputs.assign(func.getFunctionType().getResults().begin(),
                   func.getFunctionType().getResults().end());
  func.setType(FunctionType::get(func.getContext(), inputs, outputs));
  return success();
}

static void
materializeSGPRToVGPRRelief(OpBuilder &builder,
                            const SGPRToVGPRReliefCandidate &candidate) {
  DenseMap<Value, SmallVector<OpOperand *>> uses =
      collectSGPRToVGPRUses(candidate.values);
  DenseMap<Value, Value> promotedValues;

  for (const ResolvedRegAllocValue &resolved : candidate.values) {
    Value value = resolved.first;
    waveamdmachine::RegType promotedType =
        getRegAllocTransformClassType(value, waveamdmachine::RegClass::VGPR);
    if (isa<BlockArgument>(value)) {
      value.setType(promotedType);
      promotedValues[value] = value;
      continue;
    }

    Operation *def = value.getDefiningOp();
    OpBuilder::InsertionGuard guard(builder);
    builder.setInsertionPointAfter(def);
    auto move = waveamdmachine::VMovB32TupleOp::create(builder, def->getLoc(),
                                                       promotedType, value);
    move->setAttr(kSGPRToVGPRTempAttr, builder.getUnitAttr());
    promotedValues[value] = move.getResult();
  }

  for (const ResolvedRegAllocValue &resolved : candidate.values) {
    Value value = resolved.first;
    Value promoted = promotedValues.lookup(value);
    for (OpOperand *use : uses.lookup(value)) {
      Operation *owner = use->getOwner();
      if (isa<func::ReturnOp>(owner)) {
        use->set(promoted);
        continue;
      }
      OpBuilder::InsertionGuard guard(builder);
      builder.setInsertionPoint(owner);
      Value sgpr = createSGPRReadFirst(builder, owner->getLoc(), promoted);
      use->set(sgpr);
    }
  }
}

static FailureOr<std::optional<SGPRToVGPRReliefPlan>>
findSGPRToVGPRReliefPlan(func::FuncOp func) {
  FailureOr<std::optional<RegAllocTransformFailure>> failureRecord =
      parseRegAllocTransformFailure(func);
  if (failed(failureRecord))
    return failure();
  if (!*failureRecord)
    return std::optional<SGPRToVGPRReliefPlan>();
  if (!isSGPRToVGPRRelievableFailure(**failureRecord))
    return std::optional<SGPRToVGPRReliefPlan>();

  DictionaryAttr state = func->getAttrOfType<DictionaryAttr>(
      wave::getRegAllocTransformStateAttrName());
  FailureOr<SmallVector<wave::RegAllocTransformValue>> values =
      wave::parseRegAllocTransformValues(state, func.getOperation());
  if (failed(values))
    return failure();
  FailureOr<SmallVector<wave::RegAllocTransformAliasSet>> sets =
      wave::parseRegAllocTransformAliasSets(state, *values,
                                            func.getOperation());
  if (failed(sets))
    return failure();
  FailureOr<SmallVector<ResolvedRegAllocValue>> resolvedValues =
      resolveRegAllocStateValues(func, *values);
  if (failed(resolvedValues))
    return failure();

  FailureOr<std::optional<SGPRToVGPRReliefPlan>> plan =
      selectSGPRToVGPRReliefPlan(func, **failureRecord, *sets, *values,
                                 *resolvedValues);
  if (failed(plan))
    return failure();
  return plan;
}

static LogicalResult applySGPRToVGPRRelief(func::FuncOp func,
                                           OpBuilder &builder,
                                           const SGPRToVGPRReliefPlan &plan) {
  for (const SGPRToVGPRReliefCandidate &candidate : plan.candidates)
    materializeSGPRToVGPRRelief(builder, candidate);
  if (failed(refreshFuncTypeFromBody(func)))
    return failure();
  if (failed(wave::addRegAllocTransformProviderMetadata(
          func, builder, "sgpr_to_vgpr", plan.promotedDwords)))
    return failure();
  func->removeAttr(wave::getRegAllocTransformAssignmentsAttrName());
  func->removeAttr(wave::getRegAllocTransformStateAttrName());
  return success();
}

static LogicalResult runRegAllocSGPRToVGPRRelief(func::FuncOp func) {
  FailureOr<std::optional<SGPRToVGPRReliefPlan>> plan =
      findSGPRToVGPRReliefPlan(func);
  if (failed(plan))
    return failure();
  if (!*plan)
    return success();

  OpBuilder builder(func.getContext());
  return applySGPRToVGPRRelief(func, builder, **plan);
}

} // namespace

LogicalResult wave::runRegAllocTransformSGPRToVGPRRelief(Operation *target,
                                                         Builder &builder) {
  if (func::FuncOp func = dyn_cast<func::FuncOp>(target))
    return runRegAllocSGPRToVGPRRelief(func);
  WalkResult walk = target->walk([&](func::FuncOp func) {
    return failed(runRegAllocSGPRToVGPRRelief(func)) ? WalkResult::interrupt()
                                                     : WalkResult::advance();
  });
  return failure(walk.wasInterrupted());
}
