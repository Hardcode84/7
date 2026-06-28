//===- WaveAMDRegAllocLDSRelief.cpp - LDS pressure relief ----------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "WaveAMDRegAllocInternal.h"
#include "WaveAMDRegAllocMemoryReliefUtils.h"
#include "WaveAMDRegAllocTransformLoop.h"
#include "WaveAMDRegAllocTransformState.h"
#include "WaveAMDRegAllocTransformUtils.h"
#include "WaveAMDRegisterLimits.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachine.h"
#include "mlir/IR/Builders.h"
#include "mlir/IR/BuiltinTypes.h"
#include "mlir/IR/IRMapping.h"
#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/DenseSet.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/Support/MathExtras.h"
#include <array>
#include <limits>
#include <optional>

using namespace mlir;
using namespace mlir::wave::regalloc_detail;

namespace {

static FailureOr<unsigned> getLDSTransformTargetWaves(func::FuncOp func) {
  Attribute attr = findAncestorAttr(func, "waveamdmachine.target_waves");
  if (!attr)
    return 0;
  auto intAttr = dyn_cast<IntegerAttr>(attr);
  if (!intAttr)
    return func.emitError("regalloc transform LDS relief target_waves must be "
                          "an integer attribute");
  int64_t value = intAttr.getInt();
  if (value <= 0)
    return func.emitError(
        "regalloc transform LDS relief target_waves must be positive");
  if (static_cast<uint64_t>(value) > std::numeric_limits<unsigned>::max())
    return func.emitError(
        "regalloc transform LDS relief target_waves exceeds supported range");
  return static_cast<unsigned>(value);
}

static FailureOr<wave::regalloc::RegisterBudgets>
getLDSTransformBudgets(func::FuncOp func) {
  FailureOr<unsigned> targetWaves = getLDSTransformTargetWaves(func);
  if (failed(targetWaves))
    return failure();
  wave::regalloc::RegisterBudgets budgets;
  budgets.targetWaves = *targetWaves;
  return budgets;
}

static unsigned getCommittedLDSSpillBytes(func::FuncOp func) {
  return getUnsignedIntegerAttr(func.getOperation(),
                                wave::regalloc::kLDSSpillBytesAttr)
      .value_or(0);
}

static LDSReliefPlanningState
getLDSReliefPlanningState(func::FuncOp func,
                          wave::regalloc::RegisterBudgets budgets) {
  LDSReliefPlanningState state;
  state.budgets = budgets;
  state.committedBytes = getCommittedLDSSpillBytes(func);
  wave::regalloc::getExistingLDSBytes(func, state.fixedLDS, state.dynamicLDS,
                                      state.committedBytes);
  state.ldsPlanning = wave::regalloc::getLDSSpillPlanningInfo(func, budgets);
  return state;
}

static std::optional<SmallVector<wave::regalloc::LDSSpillPlan, 4>>
getLDSPlansForValue(const LDSReliefPlanningState &planning,
                    waveamdmachine::RegType type, unsigned extraReservedBytes) {
  if (type.getWidth() == 0)
    return std::nullopt;
  SmallVector<wave::regalloc::LDSSpillPlan, 4> plans;
  plans.reserve(type.getWidth());
  unsigned reserved = planning.committedBytes + extraReservedBytes;
  for ([[maybe_unused]] unsigned index :
       llvm::seq<unsigned>(0, type.getWidth())) {
    wave::regalloc::LDSSpillPlan plan = wave::regalloc::planLDSSpillSlot(
        planning.ldsPlanning, /*valueBytes=*/4, reserved, planning.fixedLDS,
        planning.dynamicLDS);
    if (plan.status != wave::regalloc::LDSSpillPlanStatus::Available)
      return std::nullopt;
    reserved += plan.slotBytes;
    plans.push_back(plan);
  }
  return plans;
}

static unsigned getLDSSlotBytes(ArrayRef<wave::regalloc::LDSSpillPlan> plans) {
  unsigned total = 0;
  for (wave::regalloc::LDSSpillPlan plan : plans)
    total += plan.slotBytes;
  return total;
}

static bool canFoldSlotBaseIntoDSOffset(unsigned slotBase) {
  std::pair<int64_t, int64_t> range = waveamdmachine::instOffsetRange(
      waveamdmachine::DsStoreB32Op::getAddressFieldSpec());
  return slotBase >= static_cast<uint64_t>(range.first) &&
         slotBase <= static_cast<uint64_t>(range.second);
}

static unsigned getLDSAddressOpsPerAccess(wave::regalloc::LDSSpillPlan plan) {
  return canFoldSlotBaseIntoDSOffset(plan.slotBase) ? 1 : 2;
}

static unsigned
getLDSAccessOpCount(ArrayRef<wave::regalloc::LDSSpillPlan> plans) {
  unsigned total = 0;
  for (wave::regalloc::LDSSpillPlan plan : plans)
    total += 1 + getLDSAddressOpsPerAccess(plan);
  return total;
}

static int64_t getLDSReliefCost(Value value,
                                ArrayRef<wave::regalloc::LDSSpillPlan> plans,
                                ArrayRef<OpOperand *> uses) {
  unsigned accessOps = getLDSAccessOpCount(plans);
  int64_t cost =
      accessOps * getRematReliefLoopCostScale(getValueAnchorOp(value));
  for (OpOperand *use : uses)
    cost += accessOps * getRematReliefLoopCostScale(use->getOwner());
  return cost;
}

static int64_t
getLDSLoopCarryReliefCost(Value value,
                          ArrayRef<wave::regalloc::LDSSpillPlan> plans,
                          wave::regalloc::MemorySpillLoopCarrySlot loopCarry) {
  unsigned accessOps = getLDSAccessOpCount(plans);
  return getMemoryLoopCarryReliefCost(value, loopCarry, accessOps);
}

struct LDSMemoryReliefTraits {
  using Plan = LDSReliefPlan;
  using Slot = LDSReliefSlot;
  using Candidate = LDSReliefCandidate;
  using PlanningState = LDSReliefPlanningState;

  static std::optional<Plan> getPlanForValue(func::FuncOp func,
                                             const PlanningState &planning,
                                             waveamdmachine::RegType type,
                                             unsigned extraReservedBytes) {
    return getLDSPlansForValue(planning, type, extraReservedBytes);
  }

  static unsigned getSlotBytes(const Plan &plan) {
    return getLDSSlotBytes(plan);
  }

  static int64_t getCost(Value value, const Plan &plan, waveamdmachine::RegType,
                         ArrayRef<OpOperand *> uses) {
    return getLDSReliefCost(value, plan, uses);
  }

  static int64_t
  getLoopCarryCost(Value value, const Plan &plan, waveamdmachine::RegType,
                   wave::regalloc::MemorySpillLoopCarrySlot loopCarry) {
    return getLDSLoopCarryReliefCost(value, plan, loopCarry);
  }
};

static Value createLDSImm(OpBuilder &builder, Location loc, int64_t value) {
  return waveamdmachine::ImmOp::create(
      builder, loc, waveamdmachine::ImmType::get(builder.getContext()),
      static_cast<uint64_t>(value));
}

static waveamdmachine::RegType getVirtualVGPR1(MLIRContext *ctx) {
  return waveamdmachine::RegType::get(ctx, waveamdmachine::RegClass::VGPR,
                                      /*width=*/1, /*index=*/-1);
}

static waveamdmachine::RegType getWorkitemIdType(MLIRContext *ctx) {
  return waveamdmachine::RegType::get(ctx, waveamdmachine::RegClass::VGPR,
                                      /*width=*/1, /*index=*/0);
}

static waveamdmachine::VWorkitemIdXOp getFixedWorkitemIdX(Operation &op) {
  auto workitem = dyn_cast<waveamdmachine::VWorkitemIdXOp>(&op);
  if (!workitem)
    return {};
  waveamdmachine::RegType type =
      cast<waveamdmachine::RegType>(workitem.getType());
  if (type.getIndex() != 0)
    return {};
  return workitem;
}

static bool opUsesValue(Operation *op, Value value) {
  bool found = false;
  op->walk([&](Operation *nested) {
    if (llvm::is_contained(nested->getOperands(), value)) {
      found = true;
      return WalkResult::interrupt();
    }
    return WalkResult::advance();
  });
  return found;
}

static bool valueHasUseAtOrAfter(Value value, Block *block,
                                 Block::iterator stop) {
  for (auto it = stop; it != block->end(); ++it)
    if (opUsesValue(&*it, value))
      return true;
  return false;
}

static Value findLiveWorkitemIdBefore(Block *block, Block::iterator stop) {
  for (auto it = block->begin(); it != stop; ++it) {
    waveamdmachine::VWorkitemIdXOp workitem = getFixedWorkitemIdX(*it);
    if (workitem && valueHasUseAtOrAfter(workitem.getResult(), block, stop))
      return workitem.getResult();
  }
  return {};
}

static Value moveWorkitemIdBefore(Block *block, Block::iterator stop,
                                  OpBuilder &builder) {
  for (auto it = stop; it != block->end(); ++it) {
    waveamdmachine::VWorkitemIdXOp workitem = getFixedWorkitemIdX(*it);
    if (!workitem)
      continue;
    workitem->moveBefore(block, stop);
    builder.setInsertionPointAfter(workitem);
    return workitem.getResult();
  }
  return {};
}

static Value findAvailableWorkitemId(OpBuilder &builder) {
  Block *block = builder.getInsertionBlock();
  if (!block)
    return {};
  Block::iterator stop = builder.getInsertionPoint();
  if (Value workitem = findLiveWorkitemIdBefore(block, stop))
    return workitem;
  if (Value workitem = moveWorkitemIdBefore(block, stop, builder))
    return workitem;
  while (block) {
    Operation *parent = block->getParentOp();
    if (!parent)
      return {};
    block = parent->getBlock();
    if (!block)
      return {};
    stop = parent->getIterator();
    if (Value workitem = findLiveWorkitemIdBefore(block, stop))
      return workitem;
  }
  return {};
}

static Value getOrCreateWorkitemId(OpBuilder &builder, Location loc) {
  if (Value workitem = findAvailableWorkitemId(builder))
    return workitem;
  return waveamdmachine::VWorkitemIdXOp::create(
             builder, loc, getWorkitemIdType(builder.getContext()))
      .getResult();
}

static FailureOr<std::pair<Value, int64_t>>
materializeLDSAddress(OpBuilder &builder, Location loc,
                      wave::regalloc::LDSSpillPlan plan) {
  MLIRContext *ctx = builder.getContext();
  Value workitem = getOrCreateWorkitemId(builder, loc);
  waveamdmachine::VLshlrevB32Op addr = waveamdmachine::VLshlrevB32Op::create(
      builder, loc, getVirtualVGPR1(ctx), workitem,
      createLDSImm(builder, loc, llvm::Log2_32(plan.valueBytes)));
  addr->setAttr(wave::regalloc::kRegAllocTempAttr, builder.getUnitAttr());
  if (canFoldSlotBaseIntoDSOffset(plan.slotBase))
    return std::make_pair(addr.getResult(),
                          static_cast<int64_t>(plan.slotBase));
  waveamdmachine::VAddU32Op fullAddr = waveamdmachine::VAddU32Op::create(
      builder, loc, getVirtualVGPR1(ctx), addr.getResult(),
      createLDSImm(builder, loc, plan.slotBase));
  fullAddr->setAttr(wave::regalloc::kRegAllocTempAttr, builder.getUnitAttr());
  return std::make_pair(fullAddr.getResult(), int64_t{0});
}

static FailureOr<Value> storeLDSScalarValue(OpBuilder &builder, Location loc,
                                            Value value, Value token,
                                            wave::regalloc::LDSSpillPlan plan) {
  FailureOr<std::pair<Value, int64_t>> addr =
      materializeLDSAddress(builder, loc, plan);
  if (failed(addr))
    return failure();
  Type tokenType = waveamdmachine::MemTokenType::get(builder.getContext());
  waveamdmachine::DsStoreB32Op store = waveamdmachine::DsStoreB32Op::create(
      builder, loc, tokenType, addr->first, value, token, addr->second);
  store->setAttr(wave::regalloc::kRegAllocTempAttr, builder.getUnitAttr());
  return store.getToken();
}

static FailureOr<Value>
storeLDSValueAt(OpBuilder &builder, Location loc, Value value,
                waveamdmachine::RegType type, Value token,
                ArrayRef<wave::regalloc::LDSSpillPlan> plans) {
  unsigned width = type.getWidth();
  if (width == 1)
    return storeLDSScalarValue(builder, loc, value, token, plans.front());

  SmallVector<Value> elements =
      wave::regalloc::splitMemorySpillValue(value, builder, loc);
  SmallVector<Value> tokens;
  tokens.reserve(elements.size());
  for (auto [index, element] : llvm::enumerate(elements)) {
    FailureOr<Value> stored =
        storeLDSScalarValue(builder, loc, element, token, plans[index]);
    if (failed(stored))
      return failure();
    tokens.push_back(*stored);
  }
  Type tokenType = waveamdmachine::MemTokenType::get(builder.getContext());
  return wave::regalloc::joinMemorySpillTokens(tokenType, tokens, builder, loc);
}

static FailureOr<Value> storeLDSValue(OpBuilder &builder,
                                      const LDSReliefSlot &slot, Value token) {
  wave::regalloc::setInsertionPointForMemorySpillStore(slot.value, builder);
  return storeLDSValueAt(builder, slot.value.getLoc(), slot.value, slot.type,
                         token, slot.plan);
}

static FailureOr<wave::regalloc::MemorySpillLoadResult>
loadLDSScalarValue(OpBuilder &builder, Location loc, Type type, Value token,
                   wave::regalloc::LDSSpillPlan plan) {
  FailureOr<std::pair<Value, int64_t>> addr =
      materializeLDSAddress(builder, loc, plan);
  if (failed(addr))
    return failure();
  Type tokenType = waveamdmachine::MemTokenType::get(builder.getContext());
  waveamdmachine::DsLoadB32Op load = waveamdmachine::DsLoadB32Op::create(
      builder, loc, type, tokenType, addr->first, token, addr->second);
  load->setAttr(wave::regalloc::kRegAllocTempAttr, builder.getUnitAttr());
  return wave::regalloc::MemorySpillLoadResult{load.getResult(),
                                               load.getToken()};
}

static FailureOr<wave::regalloc::MemorySpillLoadResult>
loadLDSValue(OpBuilder &builder, Location loc, Type type, Value token,
             ArrayRef<wave::regalloc::LDSSpillPlan> plans) {
  unsigned width = cast<waveamdmachine::RegType>(type).getWidth();
  if (width == 1)
    return loadLDSScalarValue(builder, loc, type, token, plans.front());

  SmallVector<Type> elementTypes =
      wave::regalloc::getMemorySpillScalarRegTypes(type);
  SmallVector<Value> elements;
  SmallVector<Value> tokens;
  elements.reserve(elementTypes.size());
  tokens.reserve(elementTypes.size());
  for (auto [index, elementType] : llvm::enumerate(elementTypes)) {
    FailureOr<wave::regalloc::MemorySpillLoadResult> load =
        loadLDSScalarValue(builder, loc, elementType, token, plans[index]);
    if (failed(load))
      return failure();
    elements.push_back(load->value);
    tokens.push_back(load->token);
  }
  Type tokenType = waveamdmachine::MemTokenType::get(builder.getContext());
  return wave::regalloc::MemorySpillLoadResult{
      wave::regalloc::joinMemorySpillValue(type, elements, builder, loc),
      wave::regalloc::joinMemorySpillTokens(tokenType, tokens, builder, loc)};
}

static void reserveLDSSpillBytes(func::FuncOp func, OpBuilder &builder,
                                 unsigned bytes) {
  unsigned reserved = getCommittedLDSSpillBytes(func);
  func->setAttr(wave::regalloc::kLDSSpillBytesAttr,
                builder.getI64IntegerAttr(reserved + bytes));
}

static LogicalResult materializeLDSRelief(OpBuilder &builder, func::FuncOp func,
                                          const LDSReliefCandidate &candidate) {
  auto store = [&](const LDSReliefSlot &slot, Value token) {
    return storeLDSValue(builder, slot, token);
  };
  auto load = [&](Location loc, Type type, Value token,
                  const LDSReliefPlan &plan)
      -> FailureOr<wave::regalloc::MemorySpillLoadResult> {
    return loadLDSValue(builder, loc, type, token, plan);
  };
  auto reserve = [&](unsigned bytes) {
    reserveLDSSpillBytes(func, builder, bytes);
  };
  auto loopStore = [&](Value value, Value token, const LDSReliefSlot &slot,
                       Location loc) -> FailureOr<Value> {
    return storeLDSValueAt(builder, loc, value, slot.type, token, slot.plan);
  };
  return materializeMemoryRelief<LDSReliefSlot>(builder, candidate, store, load,
                                                reserve, loopStore);
}

static LogicalResult runRegAllocLDSRelief(func::FuncOp func) {
  FailureOr<std::optional<RegAllocTransformFailure>> failureRecord =
      parseRegAllocTransformFailure(func);
  if (failed(failureRecord))
    return failure();
  if (!*failureRecord)
    return success();
  if (!isAGPRRelievableFailure(**failureRecord))
    return success();

  FailureOr<wave::regalloc::RegisterBudgets> budgets =
      getLDSTransformBudgets(func);
  if (failed(budgets))
    return failure();
  LDSReliefPlanningState planning = getLDSReliefPlanningState(func, *budgets);
  FailureOr<std::optional<LDSReliefCandidate>> candidate =
      selectMemoryReliefCandidateFromState<LDSMemoryReliefTraits>(
          func, **failureRecord, planning);
  if (failed(candidate))
    return failure();
  if (!*candidate)
    return success();

  OpBuilder builder(func.getContext());
  if (failed(materializeLDSRelief(builder, func, **candidate)))
    return failure();
  func->removeAttr(wave::getRegAllocTransformAssignmentsAttrName());
  func->removeAttr(wave::getRegAllocTransformStateAttrName());
  return success();
}

} // namespace

LogicalResult wave::runRegAllocTransformLDSRelief(Operation *target,
                                                  Builder &builder) {
  if (func::FuncOp func = dyn_cast<func::FuncOp>(target))
    return runRegAllocLDSRelief(func);
  WalkResult walk = target->walk([&](func::FuncOp func) {
    return failed(runRegAllocLDSRelief(func)) ? WalkResult::interrupt()
                                              : WalkResult::advance();
  });
  return failure(walk.wasInterrupted());
}
