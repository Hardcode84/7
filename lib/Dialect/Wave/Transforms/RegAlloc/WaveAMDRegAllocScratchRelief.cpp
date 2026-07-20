//===- WaveAMDRegAllocScratchRelief.cpp - Scratch pressure relief ------===//
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
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachine.h"
#include "mlir/IR/Builders.h"
#include "mlir/IR/BuiltinTypes.h"
#include "mlir/IR/IRMapping.h"
#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/DenseSet.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/ADT/ScopeExit.h"
#include "llvm/Support/MathExtras.h"
#include <array>
#include <limits>
#include <optional>

using namespace mlir;
using namespace mlir::wave::regalloc_detail;

namespace {

static unsigned getCommittedScratchSpillBytes(func::FuncOp func) {
  return getUnsignedIntegerAttr(func.getOperation(),
                                wave::regalloc::kScratchSpillBytesAttr)
      .value_or(0);
}

static ScratchReliefPlanningState
getScratchReliefPlanningState(func::FuncOp func) {
  ScratchReliefPlanningState state;
  state.committedBytes = getCommittedScratchSpillBytes(func);
  state.existingPrivateBytes = wave::regalloc::getExistingPrivateSegmentBytes(
      func, state.committedBytes);
  return state;
}

static std::optional<wave::regalloc::ScratchSpillPlan> getScratchPlanForValue(
    func::FuncOp func, const ScratchReliefPlanningState &planning,
    waveamdmachine::RegType type, unsigned extraReservedBytes) {
  if (type.getWidth() == 0)
    return std::nullopt;
  unsigned reserved = planning.committedBytes + extraReservedBytes;
  wave::regalloc::ScratchSpillPlan plan = wave::regalloc::planScratchSpillSlot(
      func, type.getWidth() * 4, reserved, planning.existingPrivateBytes);
  if (plan.status != wave::regalloc::ScratchSpillPlanStatus::Available)
    return std::nullopt;
  return plan;
}

static constexpr unsigned kScratchTransformImmediateOffsetMax = 4095;

static bool scratchTupleFitsImmediate(unsigned slotBase, unsigned width) {
  if (width == 0)
    return false;
  uint64_t lastOffset =
      static_cast<uint64_t>(slotBase) + static_cast<uint64_t>(width - 1) * 4;
  return lastOffset <= kScratchTransformImmediateOffsetMax;
}

static unsigned getScratchMemoryOps(wave::regalloc::ScratchSpillPlan plan,
                                    unsigned width) {
  if (width > 1 && !scratchTupleFitsImmediate(plan.slotBase, width))
    return width;
  return 1;
}

static unsigned getScratchAccessOpCount(wave::regalloc::ScratchSpillPlan plan,
                                        unsigned width) {
  return getScratchMemoryOps(plan, width) * 2;
}

static int64_t getScratchReliefCost(Value value,
                                    wave::regalloc::ScratchSpillPlan plan,
                                    waveamdmachine::RegType type,
                                    ArrayRef<OpOperand *> uses) {
  unsigned accessOps = getScratchAccessOpCount(plan, type.getWidth());
  int64_t cost =
      accessOps * getRematReliefLoopCostScale(getValueAnchorOp(value));
  for (OpOperand *use : uses)
    cost += accessOps * getRematReliefLoopCostScale(use->getOwner());
  return cost;
}

static int64_t getScratchLoopCarryReliefCost(
    Value value, wave::regalloc::ScratchSpillPlan plan,
    waveamdmachine::RegType type,
    wave::regalloc::MemorySpillLoopCarrySlot loopCarry) {
  unsigned accessOps = getScratchAccessOpCount(plan, type.getWidth());
  return getMemoryLoopCarryReliefCost(value, loopCarry, accessOps);
}

struct ScratchMemoryReliefTraits {
  using Plan = wave::regalloc::ScratchSpillPlan;
  using Slot = ScratchReliefSlot;
  using Candidate = ScratchReliefCandidate;
  using PlanningState = ScratchReliefPlanningState;

  static std::optional<Plan> getPlanForValue(func::FuncOp func,
                                             const PlanningState &planning,
                                             waveamdmachine::RegType type,
                                             unsigned extraReservedBytes) {
    return getScratchPlanForValue(func, planning, type, extraReservedBytes);
  }

  static unsigned getSlotBytes(Plan plan) { return plan.slotBytes; }

  static int64_t getCost(Value value, Plan plan, waveamdmachine::RegType type,
                         ArrayRef<OpOperand *> uses) {
    return getScratchReliefCost(value, plan, type, uses);
  }

  static int64_t
  getLoopCarryCost(Value value, Plan plan, waveamdmachine::RegType type,
                   wave::regalloc::MemorySpillLoopCarrySlot loopCarry) {
    return getScratchLoopCarryReliefCost(value, plan, type, loopCarry);
  }
};

static Value createScratchImm(OpBuilder &builder, Location loc, int64_t value) {
  return waveamdmachine::ImmOp::create(
      builder, loc, waveamdmachine::ImmType::get(builder.getContext()),
      static_cast<uint64_t>(value));
}

static waveamdmachine::RegType getVirtualSGPR1(MLIRContext *ctx) {
  return waveamdmachine::RegType::get(ctx, waveamdmachine::RegClass::SGPR,
                                      /*width=*/1, /*index=*/-1);
}

static Value materializeScratchSAddress(OpBuilder &builder, Location loc,
                                        unsigned offset) {
  waveamdmachine::SMovB32ValueOp addr = waveamdmachine::SMovB32ValueOp::create(
      builder, loc, getVirtualSGPR1(builder.getContext()),
      createScratchImm(builder, loc, offset));
  addr->setAttr(wave::regalloc::kRegAllocTempAttr, builder.getUnitAttr());
  return addr.getResult();
}

static void materializeScratchAddress(OpBuilder &builder, Location loc,
                                      unsigned byteOffset, Value &vaddr,
                                      Value &saddr, int64_t &instOffset) {
  vaddr = createScratchImm(builder, loc, 0);
  if (byteOffset <= kScratchTransformImmediateOffsetMax) {
    saddr = materializeScratchSAddress(builder, loc, 0);
    instOffset = byteOffset;
    return;
  }
  saddr = materializeScratchSAddress(builder, loc, byteOffset);
  instOffset = 0;
}

static FailureOr<Value>
storeScratchScalarValue(OpBuilder &builder, Location loc, Value value,
                        Value token, wave::regalloc::ScratchSpillPlan plan) {
  Type tokenType = waveamdmachine::MemTokenType::get(builder.getContext());
  Value storeVaddr;
  Value storeSaddr;
  int64_t storeOffset = 0;
  materializeScratchAddress(builder, loc, plan.slotBase, storeVaddr, storeSaddr,
                            storeOffset);
  waveamdmachine::ScratchStoreB32Op store =
      waveamdmachine::ScratchStoreB32Op::create(builder, loc, tokenType,
                                                storeVaddr, value, storeSaddr,
                                                token, storeOffset);
  store->setAttr(wave::regalloc::kRegAllocTempAttr, builder.getUnitAttr());
  return store.getToken();
}

static FailureOr<Value> storeScratchScalarValue(OpBuilder &builder,
                                                Location loc, Value value,
                                                Value token,
                                                unsigned byteOffset) {
  wave::regalloc::ScratchSpillPlan plan;
  plan.slotBase = byteOffset;
  return storeScratchScalarValue(builder, loc, value, token, plan);
}

static FailureOr<Value>
storeScratchTupleValue(OpBuilder &builder, Location loc, Value value,
                       Value token, wave::regalloc::ScratchSpillPlan plan) {
  Type tokenType = waveamdmachine::MemTokenType::get(builder.getContext());
  Value storeVaddr;
  Value storeSaddr;
  int64_t storeOffset = 0;
  materializeScratchAddress(builder, loc, plan.slotBase, storeVaddr, storeSaddr,
                            storeOffset);
  waveamdmachine::ScratchStoreTupleB32Op store =
      waveamdmachine::ScratchStoreTupleB32Op::create(
          builder, loc, tokenType, storeVaddr, value, storeSaddr, token,
          storeOffset);
  store->setAttr(wave::regalloc::kRegAllocTempAttr, builder.getUnitAttr());
  return store.getToken();
}

static void recordScratchVGPRSpillSave(func::FuncOp func, OpBuilder &builder,
                                       unsigned dwords) {
  unsigned spilledVGPRs =
      getUnsignedIntegerAttr(func.getOperation(),
                             wave::regalloc::kVGPRSpillCountAttr)
          .value_or(0);
  func->setAttr(wave::regalloc::kVGPRSpillCountAttr,
                builder.getI64IntegerAttr(spilledVGPRs + dwords));
}

static FailureOr<Value>
storeScratchValueAt(OpBuilder &builder, func::FuncOp func, Location loc,
                    Value value, waveamdmachine::RegType type, Value token,
                    wave::regalloc::ScratchSpillPlan plan);

static FailureOr<Value> storeScratchValue(OpBuilder &builder, func::FuncOp func,
                                          const ScratchReliefSlot &slot,
                                          Value token) {
  wave::regalloc::setInsertionPointForMemorySpillStore(slot.value, builder);
  return storeScratchValueAt(builder, func, slot.value.getLoc(), slot.value,
                             slot.type, token, slot.plan);
}

static FailureOr<Value>
storeScratchValueAt(OpBuilder &builder, func::FuncOp func, Location loc,
                    Value value, waveamdmachine::RegType type, Value token,
                    wave::regalloc::ScratchSpillPlan plan) {
  unsigned width = type.getWidth();
  recordScratchVGPRSpillSave(func, builder, width);
  if (width == 1)
    return storeScratchScalarValue(builder, loc, value, token, plan);
  if (scratchTupleFitsImmediate(plan.slotBase, width))
    return storeScratchTupleValue(builder, loc, value, token, plan);

  SmallVector<Value> elements =
      wave::regalloc::splitMemorySpillValue(value, builder, loc);
  SmallVector<Value> tokens;
  tokens.reserve(elements.size());
  for (auto [index, element] : llvm::enumerate(elements)) {
    FailureOr<Value> stored = storeScratchScalarValue(
        builder, loc, element, token,
        plan.slotBase + static_cast<unsigned>(index) * 4);
    if (failed(stored))
      return failure();
    tokens.push_back(*stored);
  }
  Type tokenType = waveamdmachine::MemTokenType::get(builder.getContext());
  return wave::regalloc::joinMemorySpillTokens(tokenType, tokens, builder, loc);
}

static FailureOr<wave::regalloc::MemorySpillLoadResult>
loadScratchScalarValue(OpBuilder &builder, Location loc, Type type, Value token,
                       wave::regalloc::ScratchSpillPlan plan) {
  Type tokenType = waveamdmachine::MemTokenType::get(builder.getContext());
  Value loadVaddr;
  Value loadSaddr;
  int64_t loadOffset = 0;
  materializeScratchAddress(builder, loc, plan.slotBase, loadVaddr, loadSaddr,
                            loadOffset);
  waveamdmachine::ScratchLoadB32Op load =
      waveamdmachine::ScratchLoadB32Op::create(builder, loc, type, tokenType,
                                               loadVaddr, loadSaddr, token,
                                               loadOffset);
  load->setAttr(wave::regalloc::kRegAllocTempAttr, builder.getUnitAttr());
  return wave::regalloc::MemorySpillLoadResult{load.getResult(),
                                               load.getToken()};
}

static FailureOr<wave::regalloc::MemorySpillLoadResult>
loadScratchScalarValue(OpBuilder &builder, Location loc, Type type, Value token,
                       unsigned byteOffset) {
  wave::regalloc::ScratchSpillPlan plan;
  plan.slotBase = byteOffset;
  return loadScratchScalarValue(builder, loc, type, token, plan);
}

static FailureOr<wave::regalloc::MemorySpillLoadResult>
loadScratchTupleValue(OpBuilder &builder, Location loc, Type type, Value token,
                      wave::regalloc::ScratchSpillPlan plan) {
  Type tokenType = waveamdmachine::MemTokenType::get(builder.getContext());
  Value loadVaddr;
  Value loadSaddr;
  int64_t loadOffset = 0;
  materializeScratchAddress(builder, loc, plan.slotBase, loadVaddr, loadSaddr,
                            loadOffset);
  waveamdmachine::ScratchLoadTupleB32Op load =
      waveamdmachine::ScratchLoadTupleB32Op::create(
          builder, loc, type, tokenType, loadVaddr, loadSaddr, token,
          loadOffset);
  load->setAttr(wave::regalloc::kRegAllocTempAttr, builder.getUnitAttr());
  return wave::regalloc::MemorySpillLoadResult{load.getResult(),
                                               load.getToken()};
}

static FailureOr<wave::regalloc::MemorySpillLoadResult>
loadScratchValue(OpBuilder &builder, Location loc, Type type, Value token,
                 wave::regalloc::ScratchSpillPlan plan) {
  unsigned width = cast<waveamdmachine::RegType>(type).getWidth();
  if (width == 1)
    return loadScratchScalarValue(builder, loc, type, token, plan);
  if (scratchTupleFitsImmediate(plan.slotBase, width))
    return loadScratchTupleValue(builder, loc, type, token, plan);

  SmallVector<Type> elementTypes =
      wave::regalloc::getMemorySpillScalarRegTypes(type);
  SmallVector<Value> elements;
  SmallVector<Value> tokens;
  elements.reserve(elementTypes.size());
  tokens.reserve(elementTypes.size());
  for (auto [index, elementType] : llvm::enumerate(elementTypes)) {
    FailureOr<wave::regalloc::MemorySpillLoadResult> load =
        loadScratchScalarValue(builder, loc, elementType, token,
                               plan.slotBase +
                                   static_cast<unsigned>(index) * 4);
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

static void reserveScratchSpillBytes(func::FuncOp func, OpBuilder &builder,
                                     unsigned bytes) {
  unsigned reserved = getCommittedScratchSpillBytes(func);
  unsigned existingPrivate =
      wave::regalloc::getExistingPrivateSegmentBytes(func, reserved);
  unsigned newReserved = reserved + bytes;
  func->setAttr(wave::regalloc::kScratchSpillBytesAttr,
                builder.getI64IntegerAttr(newReserved));
  func->setAttr(wave::regalloc::kPrivateSegmentFixedSizeAttr,
                builder.getI64IntegerAttr(existingPrivate + newReserved));
  func->setAttr(wave::regalloc::kUsesFlatScratchAttr,
                builder.getBoolAttr(true));
}

static LogicalResult
materializeScratchRelief(OpBuilder &builder, func::FuncOp func,
                         const ScratchReliefCandidate &candidate) {
  auto store = [&](const ScratchReliefSlot &slot, Value token) {
    return storeScratchValue(builder, func, slot, token);
  };
  auto load = [&](Location loc, Type type, Value token,
                  wave::regalloc::ScratchSpillPlan plan)
      -> FailureOr<wave::regalloc::MemorySpillLoadResult> {
    return loadScratchValue(builder, loc, type, token, plan);
  };
  auto reserve = [&](unsigned bytes) {
    reserveScratchSpillBytes(func, builder, bytes);
  };
  auto loopStore = [&](Value value, Value token, const ScratchReliefSlot &slot,
                       Location loc) -> FailureOr<Value> {
    return storeScratchValueAt(builder, func, loc, value, slot.type, token,
                               slot.plan);
  };
  return materializeMemoryRelief<ScratchReliefSlot>(builder, candidate, store,
                                                    load, reserve, loopStore);
}

static unsigned
countScratchReliefDwords(const ScratchReliefCandidate &candidate) {
  unsigned dwords = 0;
  for (const ScratchReliefSlot &slot : candidate.slots)
    dwords += slot.type.getWidth();
  return dwords;
}

static LogicalResult
runRegAllocScratchRelief(func::FuncOp func,
                         RegAllocTransformStateCache &cache) {
  FailureOr<std::optional<RegAllocTransformFailure>> failureRecord =
      parseRegAllocTransformFailure(func);
  if (failed(failureRecord))
    return failure();
  if (!*failureRecord)
    return success();
  if (!isAGPRRelievableFailure(**failureRecord))
    return success();

  ScratchReliefPlanningState planning = getScratchReliefPlanningState(func);
  FailureOr<std::optional<ScratchReliefCandidate>> candidate =
      selectMemoryReliefCandidateFromState<ScratchMemoryReliefTraits>(
          func, **failureRecord, planning, cache);
  if (failed(candidate))
    return failure();
  if (!*candidate)
    return success();

  llvm::scope_exit clearCache([&] { cache.erase(func); });
  OpBuilder builder(func.getContext());
  if (failed(materializeScratchRelief(builder, func, **candidate)))
    return failure();
  if (failed(wave::addRegAllocTransformProviderMetadata(
          func, builder, "scratch", countScratchReliefDwords(**candidate))))
    return failure();
  wave::invalidateRegAllocPreparation(func);
  func->removeAttr(wave::getRegAllocTransformAssignmentsAttrName());
  func->removeAttr(wave::getRegAllocTransformStateAttrName());
  return success();
}

} // namespace

LogicalResult
wave::runRegAllocTransformScratchRelief(Operation *target, Builder &builder,
                                        RegAllocTransformStateCache *cache) {
  RegAllocTransformStateCache localCache;
  if (!cache)
    cache = &localCache;
  if (func::FuncOp func = dyn_cast<func::FuncOp>(target))
    return runRegAllocScratchRelief(func, *cache);
  WalkResult walk = target->walk<WalkOrder::PreOrder>([&](func::FuncOp func) {
    return failed(runRegAllocScratchRelief(func, *cache))
               ? WalkResult::interrupt()
               : WalkResult::skip();
  });
  return failure(walk.wasInterrupted());
}
