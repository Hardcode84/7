//===- WaveAMDRegAllocLDSRelief.cpp - LDS pressure relief ----------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "../WaveAMDHardwareResources.h"
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
#include "mlir/IR/Dominance.h"
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

static constexpr llvm::StringLiteral kLDSAddTidBaseAttr =
    "waveamdmachine.lds_addtid_base_bytes";

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
  if (planning.fixedLDS != 0 && planning.dynamicLDS != 0)
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

static unsigned
getLDSAccessOpCount(ArrayRef<wave::regalloc::LDSSpillPlan> plans) {
  return plans.size() * 2;
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

static Value createImm(OpBuilder &builder, Location loc, int64_t value) {
  return waveamdmachine::ImmOp::create(
      builder, loc, waveamdmachine::ImmType::get(builder.getContext()),
      static_cast<uint64_t>(value));
}

static void markRegAllocTemp(Operation *op, OpBuilder &builder) {
  op->setAttr(wave::regalloc::kRegAllocTempAttr, builder.getUnitAttr());
}

static void markLDSAddTidBase(Operation *op, OpBuilder &builder,
                              unsigned ldsBaseBytes) {
  op->setAttr(kLDSAddTidBaseAttr, builder.getI64IntegerAttr(ldsBaseBytes));
}

static waveamdmachine::RegType getVirtualSGPR1(MLIRContext *ctx) {
  return waveamdmachine::RegType::get(ctx, waveamdmachine::RegClass::SGPR,
                                      /*width=*/1, /*index=*/-1);
}

static waveamdmachine::RegType getSCCType(MLIRContext *ctx) {
  return waveamdmachine::RegType::get(ctx, waveamdmachine::RegClass::SCC,
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

struct LDSAddTidContext {
  Value waveBaseBytes;
};

static Operation *getLDSReliefStoreAnchor(const LDSReliefSlot &slot) {
  if (!slot.loopCarry)
    return slot.value.getDefiningOp();
  waveamdmachine::UniformLoopOp loop = slot.loopCarry->loop;
  OpOperand *loopUse = &loop.getInitsMutable()[slot.loopCarry->index];
  return wave::regalloc::getLoopCarryInitStoreDiagOp(slot.value, loopUse, loop);
}

static bool ldsAddTidBaseDominatesStore(Value base, const LDSReliefSlot &slot,
                                        DominanceInfo &dominance) {
  if (Operation *anchor = getLDSReliefStoreAnchor(slot))
    return dominance.dominates(base, anchor);

  // Block-start stores require a base from an ancestor block.
  auto arg = dyn_cast<BlockArgument>(slot.value);
  if (!arg)
    return false;
  Operation *parent = arg.getOwner()->getParentOp();
  return parent && dominance.dominates(base, parent);
}

static bool ldsAddTidBaseDominatesCandidate(Value base,
                                            const LDSReliefCandidate &candidate,
                                            DominanceInfo &dominance) {
  return llvm::all_of(candidate.slots, [&](const LDSReliefSlot &slot) {
    return ldsAddTidBaseDominatesStore(base, slot, dominance);
  });
}

static Value findLDSAddTidBase(func::FuncOp func, unsigned ldsBaseBytes,
                               const LDSReliefCandidate &candidate,
                               DominanceInfo &dominance) {
  Block &entry = func.getBody().front();
  for (Operation &op : entry) {
    std::optional<unsigned> attr =
        getUnsignedIntegerAttr(&op, kLDSAddTidBaseAttr);
    if (attr && *attr == ldsBaseBytes && op.getNumResults() != 0 &&
        ldsAddTidBaseDominatesCandidate(op.getResult(0), candidate, dominance))
      return op.getResult(0);
  }
  return {};
}

static FailureOr<unsigned>
getLDSBaseBytes(func::FuncOp func, const LDSReliefCandidate &candidate) {
  std::optional<unsigned> baseBytes;
  for (const LDSReliefSlot &slot : candidate.slots) {
    for (wave::regalloc::LDSSpillPlan plan : slot.plan) {
      unsigned planBase = plan.existingFixedBytes;
      if (!baseBytes) {
        baseBytes = planBase;
        continue;
      }
      if (*baseBytes != planBase)
        return func.emitError("LDS relief candidate has mixed base offsets");
    }
  }
  if (!baseBytes)
    return func.emitError("LDS relief candidate has no spill plan");
  return *baseBytes;
}

static LDSAddTidContext
materializeLDSAddTidContext(OpBuilder &builder, func::FuncOp func,
                            unsigned ldsBaseBytes,
                            const LDSReliefCandidate &candidate) {
  DominanceInfo dominance(func);
  if (Value existing =
          findLDSAddTidBase(func, ldsBaseBytes, candidate, dominance))
    return LDSAddTidContext{existing};

  MLIRContext *ctx = builder.getContext();
  Location loc = func.getLoc();
  OpBuilder::InsertionGuard guard(builder);
  Block &entry = func.getBody().front();
  builder.setInsertionPointToStart(&entry);

  Value workitem = getOrCreateWorkitemId(builder, loc);
  waveamdmachine::VReadfirstlaneB32Op firstLane =
      waveamdmachine::VReadfirstlaneB32Op::create(
          builder, loc, getVirtualSGPR1(ctx), workitem);
  markRegAllocTemp(firstLane, builder);

  waveamdmachine::SLshlB32Op waveOffset = waveamdmachine::SLshlB32Op::create(
      builder, loc, getVirtualSGPR1(ctx), getSCCType(ctx),
      firstLane.getResult(), createImm(builder, loc, llvm::Log2_32(4)));
  markRegAllocTemp(waveOffset, builder);

  Value waveBase = waveOffset.getResult();
  if (ldsBaseBytes != 0) {
    waveamdmachine::SAddI32Op fullBase = waveamdmachine::SAddI32Op::create(
        builder, loc, getVirtualSGPR1(ctx), getSCCType(ctx), waveBase,
        createImm(builder, loc, ldsBaseBytes));
    markRegAllocTemp(fullBase, builder);
    waveBase = fullBase.getResult();
    markLDSAddTidBase(fullBase, builder, ldsBaseBytes);
  } else {
    markLDSAddTidBase(waveOffset, builder, ldsBaseBytes);
  }
  return LDSAddTidContext{waveBase};
}

static Value createLDSByteImm(OpBuilder &builder, Location loc,
                              unsigned bytes) {
  return createImm(builder, loc, bytes);
}

static Value addVGPRByteOffset(OpBuilder &builder, Location loc, Value value,
                               unsigned bytes) {
  if (bytes == 0)
    return value;
  Value offset = createLDSByteImm(builder, loc, bytes);
  return waveamdmachine::VAddU32Op::create(
      builder, loc,
      waveamdmachine::RegType::get(builder.getContext(),
                                   waveamdmachine::RegClass::VGPR,
                                   /*width=*/1, /*index=*/-1),
      value, offset);
}

static std::optional<unsigned> getLDSByteImm(Value value) {
  auto imm = value.getDefiningOp<waveamdmachine::ImmOp>();
  if (!imm || imm.getValue() > std::numeric_limits<unsigned>::max())
    return std::nullopt;
  return static_cast<unsigned>(imm.getValue());
}

struct FoldedSGPROffset {
  Value base;
  unsigned bytes = 0;
};

static std::optional<unsigned> checkedAddBytes(unsigned lhs, unsigned rhs) {
  uint64_t sum = static_cast<uint64_t>(lhs) + rhs;
  if (sum > std::numeric_limits<unsigned>::max())
    return std::nullopt;
  return static_cast<unsigned>(sum);
}

static std::optional<FoldedSGPROffset> foldSGPRByteOffsets(Value value) {
  FoldedSGPROffset folded{value, 0};
  while (auto add = folded.base.getDefiningOp<waveamdmachine::SAddI32Op>()) {
    std::optional<unsigned> rhs = getLDSByteImm(add.getRhs());
    if (!rhs)
      break;
    std::optional<unsigned> bytes = checkedAddBytes(folded.bytes, *rhs);
    if (!bytes)
      return std::nullopt;
    folded.base = add.getLhs();
    folded.bytes = *bytes;
  }
  return folded;
}

static Value materializeM0FromSGPROffset(OpBuilder &builder, Location loc,
                                         FoldedSGPROffset folded) {
  if (folded.bytes == 0)
    return waveamdmachine::SMovM0Op::create(
               builder, loc, waveamdmachine::M0Type::get(builder.getContext()),
               folded.base)
        .getResult();
  Value offset = createLDSByteImm(builder, loc, folded.bytes);
  return waveamdmachine::SAddM0I32Op::create(
             builder, loc, waveamdmachine::M0Type::get(builder.getContext()),
             getSCCType(builder.getContext()), folded.base, offset)
      .getM0();
}

static FailureOr<Value> shiftM0Value(OpBuilder &builder, Location loc, Value m0,
                                     unsigned bytes) {
  if (auto mov = m0.getDefiningOp<waveamdmachine::SMovM0Op>()) {
    std::optional<FoldedSGPROffset> folded =
        foldSGPRByteOffsets(mov.getSource());
    if (!folded)
      return failure();
    std::optional<unsigned> shifted = checkedAddBytes(folded->bytes, bytes);
    if (!shifted)
      return failure();
    folded->bytes = *shifted;
    return materializeM0FromSGPROffset(builder, loc, *folded);
  }
  if (auto add = m0.getDefiningOp<waveamdmachine::SAddM0I32Op>()) {
    if (isa<waveamdmachine::M0Type>(add.getLhs().getType()))
      return failure();
    FoldedSGPROffset folded{add.getLhs(), 0};
    if (std::optional<unsigned> rhs = getLDSByteImm(add.getRhs())) {
      std::optional<unsigned> total = checkedAddBytes(*rhs, bytes);
      if (!total)
        return failure();
      folded.bytes = *total;
      return materializeM0FromSGPROffset(builder, loc, folded);
    }
    waveamdmachine::SAddI32Op sum = waveamdmachine::SAddI32Op::create(
        builder, loc, getVirtualSGPR1(builder.getContext()),
        getSCCType(builder.getContext()), add.getLhs(), add.getRhs());
    folded.base = sum.getResult();
    folded.bytes = bytes;
    return materializeM0FromSGPROffset(builder, loc, folded);
  }
  return failure();
}

static bool isSCCValue(Value value) {
  return wave::getHardwareResourceForValue(value) ==
         wave::HardwareResourceKind::SCC;
}

static bool isDefinedInside(Operation *owner, Value value) {
  if (Operation *def = value.getDefiningOp())
    return owner->isAncestor(def);
  Block *block = cast<BlockArgument>(value).getOwner();
  Operation *parent = block->getParentOp();
  return parent == owner || (parent && owner->isAncestor(parent));
}

static Value findNestedSCCCapture(Operation *owner, Region &region) {
  for (Block &block : region) {
    for (Operation &nested : block) {
      for (Value operand : nested.getOperands())
        if (isSCCValue(operand) && !isDefinedInside(owner, operand))
          return operand;
      for (Region &child : nested.getRegions())
        if (Value capture = findNestedSCCCapture(owner, child))
          return capture;
    }
  }
  return {};
}

static Value findSCCRead(Operation *op) {
  for (Value operand : op->getOperands())
    if (isSCCValue(operand))
      return operand;
  for (Region &region : op->getRegions())
    if (Value capture = findNestedSCCCapture(op, region))
      return capture;
  return {};
}

static bool writesSCC(Operation *op) {
  if (llvm::is_contained(wave::getHardwareResourceEffects(op).writes,
                         wave::HardwareResourceKind::SCC))
    return true;
  return op
      ->walk([&](Operation *nested) {
        if (nested != op &&
            llvm::is_contained(wave::getHardwareResourceEffects(nested).writes,
                               wave::HardwareResourceKind::SCC))
          return WalkResult::interrupt();
        return WalkResult::advance();
      })
      .wasInterrupted();
}

static Value findLiveSCCAt(Operation *point) {
  for (Operation *op = point; op; op = op->getNextNode()) {
    if (Value read = findSCCRead(op))
      return read;
    if (writesSCC(op))
      return {};
  }
  return {};
}

static Operation *getAncestorInBlock(Operation *op, Block *block) {
  while (op && op->getBlock() != block)
    op = op->getParentOp();
  return op;
}

static void replaceSCCUsesAtOrAfter(Value oldSCC, Value newSCC,
                                    Operation *point) {
  for (OpOperand &use : llvm::make_early_inc_range(oldSCC.getUses())) {
    Operation *owner = getAncestorInBlock(use.getOwner(), point->getBlock());
    if (owner && (owner == point || point->isBeforeInBlock(owner)))
      use.set(newSCC);
  }
}

static bool isM0Value(Value value) {
  return wave::getHardwareResourceForValue(value) ==
         wave::HardwareResourceKind::M0;
}

static Value findNestedM0Capture(Operation *owner, Region &region) {
  for (Block &block : region) {
    for (Operation &nested : block) {
      for (Value operand : nested.getOperands())
        if (isM0Value(operand) && !isDefinedInside(owner, operand))
          return operand;
      for (Region &child : nested.getRegions())
        if (Value capture = findNestedM0Capture(owner, child))
          return capture;
    }
  }
  return {};
}

static Value findM0Read(Operation *op) {
  for (Value operand : op->getOperands())
    if (isM0Value(operand))
      return operand;
  for (Region &region : op->getRegions())
    if (Value capture = findNestedM0Capture(op, region))
      return capture;
  return {};
}

static bool writesM0(Operation *op) {
  if (llvm::is_contained(wave::getHardwareResourceEffects(op).writes,
                         wave::HardwareResourceKind::M0))
    return true;
  return op
      ->walk([&](Operation *nested) {
        if (nested != op &&
            llvm::is_contained(wave::getHardwareResourceEffects(nested).writes,
                               wave::HardwareResourceKind::M0))
          return WalkResult::interrupt();
        return WalkResult::advance();
      })
      .wasInterrupted();
}

static Value findLiveM0At(Operation *point) {
  for (Operation *op = point; op; op = op->getNextNode()) {
    if (Value read = findM0Read(op))
      return read;
    if (writesM0(op))
      return {};
  }
  return {};
}

static void replaceM0UsesAtOrAfter(Value oldM0, Value newM0, Operation *point) {
  for (OpOperand &use : llvm::make_early_inc_range(oldM0.getUses())) {
    Operation *owner = getAncestorInBlock(use.getOwner(), point->getBlock());
    if (owner && (owner == point || point->isBeforeInBlock(owner)))
      use.set(newM0);
  }
}

static Value collectM0IncrementChain(
    Value m0, SmallVectorImpl<waveamdmachine::SAddM0I32Op> &increments) {
  while (waveamdmachine::SAddM0I32Op add =
             m0.getDefiningOp<waveamdmachine::SAddM0I32Op>()) {
    if (!isa<waveamdmachine::M0Type>(add.getLhs().getType()))
      break;
    increments.push_back(add);
    m0 = add.getLhs();
  }
  return m0;
}

static bool
m0RestoreRebuildsSCC(Value liveSCC, waveamdmachine::SAddM0I32Op rootAdd,
                     ArrayRef<waveamdmachine::SAddM0I32Op> increments) {
  if (!liveSCC)
    return false;
  if (rootAdd && rootAdd.getScc() == liveSCC)
    return true;
  return llvm::any_of(increments, [&](waveamdmachine::SAddM0I32Op increment) {
    return increment.getScc() == liveSCC;
  });
}

static Value saveSCCForM0Restore(OpBuilder &builder, Operation *point,
                                 Value liveSCC, bool rebuildsLiveSCC) {
  if (!liveSCC || rebuildsLiveSCC)
    return {};
  Value one = createImm(builder, point->getLoc(), 1);
  Value zero = createImm(builder, point->getLoc(), 0);
  waveamdmachine::SCSelectB32Op saved = waveamdmachine::SCSelectB32Op::create(
      builder, point->getLoc(), getVirtualSGPR1(builder.getContext()), liveSCC,
      one, zero);
  markRegAllocTemp(saved, builder);
  return saved.getResult();
}

struct RestoredM0State {
  Value m0;
  Value scc;
};

static RestoredM0State restoreM0Root(OpBuilder &builder, Operation *point,
                                     Value root, waveamdmachine::SMovM0Op mov,
                                     waveamdmachine::SAddM0I32Op add,
                                     Value liveSCC) {
  if (mov) {
    waveamdmachine::SMovM0Op restored = waveamdmachine::SMovM0Op::create(
        builder, point->getLoc(), root.getType(), mov.getSource());
    markRegAllocTemp(restored, builder);
    return {restored.getResult(), {}};
  }

  waveamdmachine::SAddM0I32Op restored = waveamdmachine::SAddM0I32Op::create(
      builder, point->getLoc(), root.getType(), add.getScc().getType(),
      add.getLhs(), add.getRhs());
  markRegAllocTemp(restored, builder);
  Value restoredSCC = liveSCC == add.getScc() ? restored.getScc() : Value{};
  return {restored.getM0(), restoredSCC};
}

static RestoredM0State
replayM0Increments(OpBuilder &builder, Operation *point,
                   ArrayRef<waveamdmachine::SAddM0I32Op> increments,
                   Value liveSCC, RestoredM0State state) {
  for (waveamdmachine::SAddM0I32Op increment : llvm::reverse(increments)) {
    waveamdmachine::SAddM0I32Op restored = waveamdmachine::SAddM0I32Op::create(
        builder, point->getLoc(), increment.getM0().getType(),
        increment.getScc().getType(), state.m0, increment.getRhs());
    markRegAllocTemp(restored, builder);
    state.m0 = restored.getM0();
    if (liveSCC == increment.getScc())
      state.scc = restored.getScc();
  }
  return state;
}

static void restoreSCCAfterM0(OpBuilder &builder, Operation *point,
                              Value liveSCC, Value savedSCC,
                              Value restoredSCC) {
  if (restoredSCC) {
    replaceSCCUsesAtOrAfter(liveSCC, restoredSCC, point);
    return;
  }
  if (!savedSCC)
    return;
  Value zero = createImm(builder, point->getLoc(), 0);
  waveamdmachine::SCmpLgU32Op reloaded = waveamdmachine::SCmpLgU32Op::create(
      builder, point->getLoc(), liveSCC.getType(), savedSCC, zero);
  markRegAllocTemp(reloaded, builder);
  replaceSCCUsesAtOrAfter(liveSCC, reloaded.getResult(), point);
}

static LogicalResult restoreLiveM0(OpBuilder &builder, Value liveM0,
                                   Operation *point) {
  if (!liveM0)
    return success();

  // LDS relief writes physical M0 outside SSA aliasing; recreate live user M0.
  SmallVector<waveamdmachine::SAddM0I32Op, 4> increments;
  Value root = collectM0IncrementChain(liveM0, increments);
  waveamdmachine::SMovM0Op mov = root.getDefiningOp<waveamdmachine::SMovM0Op>();
  waveamdmachine::SAddM0I32Op add =
      root.getDefiningOp<waveamdmachine::SAddM0I32Op>();
  if (!mov && !add)
    return point->emitError("regalloc LDS relief cannot restore live M0 value");

  bool setsSCC = add || !increments.empty();
  Value liveSCC = setsSCC ? findLiveSCCAt(point) : Value{};
  bool rebuildsLiveSCC = m0RestoreRebuildsSCC(liveSCC, add, increments);

  builder.setInsertionPoint(point);
  Value savedSCC =
      saveSCCForM0Restore(builder, point, liveSCC, rebuildsLiveSCC);
  RestoredM0State restored =
      restoreM0Root(builder, point, root, mov, add, liveSCC);
  restored = replayM0Increments(builder, point, increments, liveSCC, restored);
  restoreSCCAfterM0(builder, point, liveSCC, savedSCC, restored.scc);
  replaceM0UsesAtOrAfter(liveM0, restored.m0, point);
  return success();
}

static Operation *getInsertionPointOp(OpBuilder &builder) {
  Block *block = builder.getInsertionBlock();
  if (!block || builder.getInsertionPoint() == block->end())
    return nullptr;
  return &*builder.getInsertionPoint();
}

static LogicalResult restoreGeneratedLDSM0(func::FuncOp func,
                                           OpBuilder &builder) {
  SmallVector<Operation *, 16> boundaries;
  func.walk([&](Operation *op) {
    if (wave::regalloc::isRegAllocTempOp(op) &&
        isa<waveamdmachine::DsLoadAddTidB32Op,
            waveamdmachine::DsStoreAddTidB32Op>(op))
      boundaries.push_back(op);
  });
  // Loop cloning can append spills before their future users exist.
  for (Operation *boundary : boundaries) {
    Operation *point = boundary->getNextNode();
    if (!point)
      continue;
    if (failed(restoreLiveM0(builder, findLiveM0At(point), point)))
      return failure();
  }
  return success();
}

static bool allResultsUnused(Operation *op) {
  return llvm::all_of(op->getResults(),
                      [](Value result) { return result.use_empty(); });
}

static bool isErasableAddressOp(Operation *op) {
  return op && isa<waveamdmachine::SMovM0Op, waveamdmachine::SAddM0I32Op,
                   waveamdmachine::SAddI32Op, waveamdmachine::ImmOp>(op);
}

static void eraseDeadAddressOp(Operation *op) {
  if (!isErasableAddressOp(op) || !allResultsUnused(op))
    return;
  SmallVector<Value, 4> operands(op->operand_begin(), op->operand_end());
  op->erase();
  for (Value operand : operands)
    eraseDeadAddressOp(operand.getDefiningOp());
}

static Value findM0ChainRoot(Value m0) {
  SmallVector<waveamdmachine::SAddM0I32Op, 4> increments;
  return collectM0IncrementChain(m0, increments);
}

static bool isLDSAddressUser(Operation *op) {
  return op->hasTrait<OpTrait::waveamdmachine::LDSLoadOp>() ||
         op->hasTrait<OpTrait::waveamdmachine::LDSStoreOp>() ||
         op->hasTrait<OpTrait::waveamdmachine::LDSDmaOp>();
}

static bool m0ChainOnlyAddressesLDS(Value m0, DenseSet<Value> &visited) {
  if (!visited.insert(m0).second)
    return true;
  for (OpOperand &use : m0.getUses()) {
    Operation *owner = use.getOwner();
    if (isLDSAddressUser(owner))
      continue;
    waveamdmachine::SAddM0I32Op add =
        dyn_cast<waveamdmachine::SAddM0I32Op>(owner);
    if (!add || use.getOperandNumber() != 0 ||
        !m0ChainOnlyAddressesLDS(add.getM0(), visited))
      return false;
  }
  return true;
}

static LogicalResult shiftM0ChainRoot(OpBuilder &builder, Value root,
                                      unsigned bytes) {
  Operation *oldDef = root.getDefiningOp();
  if (!isa_and_nonnull<waveamdmachine::SMovM0Op, waveamdmachine::SAddM0I32Op>(
          oldDef))
    return emitError(root.getLoc(), "cannot find dynamic LDS M0 chain root");
  if (llvm::any_of(oldDef->getResults(), [&](Value result) {
        return result != root && !result.use_empty();
      }))
    return oldDef->emitError("cannot shift M0 chain with live flag result");
  DenseSet<Value> visited;
  if (!m0ChainOnlyAddressesLDS(root, visited))
    return oldDef->emitError("M0 chain has a non-LDS address use");

  Value liveSCC = findLiveSCCAt(oldDef);
  builder.setInsertionPoint(oldDef);
  Value savedSCC;
  if (liveSCC) {
    Value one = createImm(builder, oldDef->getLoc(), 1);
    Value zero = createImm(builder, oldDef->getLoc(), 0);
    waveamdmachine::SCSelectB32Op saved = waveamdmachine::SCSelectB32Op::create(
        builder, oldDef->getLoc(), getVirtualSGPR1(builder.getContext()),
        liveSCC, one, zero);
    markRegAllocTemp(saved, builder);
    savedSCC = saved.getResult();
  }
  FailureOr<Value> shifted =
      shiftM0Value(builder, oldDef->getLoc(), root, bytes);
  if (failed(shifted))
    return oldDef->emitError("cannot shift dynamic LDS M0 chain root");
  if (savedSCC) {
    Value zero = createImm(builder, oldDef->getLoc(), 0);
    waveamdmachine::SCmpLgU32Op reloaded = waveamdmachine::SCmpLgU32Op::create(
        builder, oldDef->getLoc(), liveSCC.getType(), savedSCC, zero);
    markRegAllocTemp(reloaded, builder);
    replaceSCCUsesAtOrAfter(liveSCC, reloaded.getResult(), oldDef);
  }
  root.replaceAllUsesWith(*shifted);
  eraseDeadAddressOp(oldDef);
  return success();
}

static LogicalResult shiftLDSAddressOperand(OpBuilder &builder, Operation *op,
                                            unsigned bytes) {
  for (OpOperand &operand : op->getOpOperands()) {
    if (!isa<waveamdmachine::M0Type>(operand.get().getType()))
      continue;
    builder.setInsertionPoint(op);
    Value liveSCC = findLiveSCCAt(op);
    Value savedSCC;
    if (liveSCC) {
      Value one = createImm(builder, op->getLoc(), 1);
      Value zero = createImm(builder, op->getLoc(), 0);
      savedSCC = waveamdmachine::SCSelectB32Op::create(
                     builder, op->getLoc(),
                     getVirtualSGPR1(builder.getContext()), liveSCC, one, zero)
                     .getResult();
    }
    Value oldM0 = operand.get();
    FailureOr<Value> shifted =
        shiftM0Value(builder, op->getLoc(), oldM0, bytes);
    if (failed(shifted))
      return op->emitError("cannot shift dynamic LDS M0 address");
    if (liveSCC) {
      Value zero = createImm(builder, op->getLoc(), 0);
      Value reloaded = waveamdmachine::SCmpLgU32Op::create(
                           builder, op->getLoc(),
                           getSCCType(builder.getContext()), savedSCC, zero)
                           .getResult();
      replaceSCCUsesAtOrAfter(liveSCC, reloaded, op);
    }
    operand.set(*shifted);
    eraseDeadAddressOp(oldM0.getDefiningOp());
    return success();
  }

  if (op->getNumOperands() == 0)
    return success();
  Value addr = op->getOperand(0);
  if (!waveamdmachine::isVGPRValue(addr))
    return success();
  builder.setInsertionPoint(op);
  op->setOperand(0, addVGPRByteOffset(builder, op->getLoc(), addr, bytes));
  return success();
}

struct DynamicLDSOps {
  SmallVector<Operation *, 64> ldsOps;
  DenseSet<Value> m0ChainRoots;
};

static DynamicLDSOps collectDynamicLDSOps(func::FuncOp func) {
  DynamicLDSOps ops;
  func.walk([&](Operation *op) {
    if (!wave::regalloc::isRegAllocTempOp(op) && isLDSAddressUser(op))
      ops.ldsOps.push_back(op);
    waveamdmachine::SAddM0I32Op add = dyn_cast<waveamdmachine::SAddM0I32Op>(op);
    if (add && isa<waveamdmachine::M0Type>(add.getLhs().getType()))
      ops.m0ChainRoots.insert(findM0ChainRoot(add.getM0()));
  });
  return ops;
}

static void collectUsedM0Chains(ArrayRef<Operation *> ldsOps,
                                const DenseSet<Value> &chainRoots,
                                DenseSet<Value> &usedRoots,
                                DenseSet<Operation *> &chainLDSOps) {
  for (Operation *op : ldsOps)
    for (Value operand : op->getOperands()) {
      if (!isa<waveamdmachine::M0Type>(operand.getType()))
        continue;
      Value root = findM0ChainRoot(operand);
      if (!chainRoots.contains(root))
        continue;
      usedRoots.insert(root);
      chainLDSOps.insert(op);
    }
}

static LogicalResult shiftM0ChainRoots(OpBuilder &builder,
                                       const DenseSet<Value> &roots,
                                       unsigned bytes) {
  for (Value root : roots)
    if (failed(shiftM0ChainRoot(builder, root, bytes)))
      return failure();
  return success();
}

static LogicalResult
shiftUnchainedLDSAddresses(OpBuilder &builder, ArrayRef<Operation *> ldsOps,
                           const DenseSet<Operation *> &chainLDSOps,
                           unsigned bytes) {
  for (Operation *op : ldsOps)
    if (!chainLDSOps.contains(op) &&
        failed(shiftLDSAddressOperand(builder, op, bytes)))
      return failure();
  return success();
}

static LogicalResult shiftDynamicLDSAddresses(func::FuncOp func,
                                              OpBuilder &builder,
                                              unsigned bytes) {
  if (bytes == 0)
    return success();
  DynamicLDSOps ops = collectDynamicLDSOps(func);
  DenseSet<Value> usedRoots;
  DenseSet<Operation *> chainLDSOps;
  collectUsedM0Chains(ops.ldsOps, ops.m0ChainRoots, usedRoots, chainLDSOps);
  if (failed(shiftM0ChainRoots(builder, usedRoots, bytes)))
    return failure();
  return shiftUnchainedLDSAddresses(builder, ops.ldsOps, chainLDSOps, bytes);
}

static bool shouldShiftDynamicLDS(const LDSReliefCandidate &candidate) {
  if (candidate.slots.empty() || candidate.slots.front().plan.empty())
    return false;
  const wave::regalloc::LDSSpillPlan &plan =
      candidate.slots.front().plan.front();
  return plan.existingFixedBytes == 0 && plan.existingDynamicBytes != 0;
}

static FailureOr<int64_t>
getLDSAddTidOffset(wave::regalloc::LDSSpillPlan plan) {
  std::pair<int64_t, int64_t> range = waveamdmachine::instOffsetRange(
      waveamdmachine::DsStoreAddTidB32Op::getAddressFieldSpec());
  int64_t offset = static_cast<int64_t>(plan.reservedSpillBytes);
  if (offset < range.first || offset > range.second)
    return failure();
  return offset;
}

static Value materializeLDSM0(OpBuilder &builder, Location loc,
                              const LDSAddTidContext &context) {
  waveamdmachine::SMovM0Op mov = waveamdmachine::SMovM0Op::create(
      builder, loc, waveamdmachine::M0Type::get(builder.getContext()),
      context.waveBaseBytes);
  markRegAllocTemp(mov, builder);
  return mov.getResult();
}

static FailureOr<Value> storeLDSScalarValue(OpBuilder &builder,
                                            const LDSAddTidContext &context,
                                            Location loc, Value value,
                                            Value token,
                                            wave::regalloc::LDSSpillPlan plan) {
  FailureOr<int64_t> offset = getLDSAddTidOffset(plan);
  if (failed(offset))
    return failure();
  Value m0 = materializeLDSM0(builder, loc, context);
  Type tokenType = waveamdmachine::MemTokenType::get(builder.getContext());
  waveamdmachine::DsStoreAddTidB32Op store =
      waveamdmachine::DsStoreAddTidB32Op::create(builder, loc, tokenType, m0,
                                                 value, token, *offset);
  markRegAllocTemp(store, builder);
  return store.getToken();
}

static FailureOr<Value>
storeLDSValueAt(OpBuilder &builder, const LDSAddTidContext &context,
                Location loc, Value value, waveamdmachine::RegType type,
                Value token, ArrayRef<wave::regalloc::LDSSpillPlan> plans) {
  Operation *point = getInsertionPointOp(builder);
  Value liveM0 = point ? findLiveM0At(point) : Value{};
  unsigned width = type.getWidth();
  if (width == 1) {
    FailureOr<Value> stored =
        storeLDSScalarValue(builder, context, loc, value, token, plans.front());
    if (failed(stored) ||
        (point && failed(restoreLiveM0(builder, liveM0, point))))
      return failure();
    return stored;
  }

  SmallVector<Value> elements =
      wave::regalloc::splitMemorySpillValue(value, builder, loc);
  SmallVector<Value> tokens;
  tokens.reserve(elements.size());
  for (auto [index, element] : llvm::enumerate(elements)) {
    FailureOr<Value> stored = storeLDSScalarValue(builder, context, loc,
                                                  element, token, plans[index]);
    if (failed(stored))
      return failure();
    tokens.push_back(*stored);
  }
  Type tokenType = waveamdmachine::MemTokenType::get(builder.getContext());
  Value joined =
      wave::regalloc::joinMemorySpillTokens(tokenType, tokens, builder, loc);
  if (point && failed(restoreLiveM0(builder, liveM0, point)))
    return failure();
  return joined;
}

static FailureOr<Value> storeLDSValue(OpBuilder &builder,
                                      const LDSAddTidContext &context,
                                      const LDSReliefSlot &slot, Value token) {
  wave::regalloc::setInsertionPointForMemorySpillStore(slot.value, builder);
  if (auto arg = dyn_cast<BlockArgument>(slot.value)) {
    Operation *baseDef = context.waveBaseBytes.getDefiningOp();
    if (baseDef && baseDef->getBlock() == arg.getOwner())
      builder.setInsertionPointAfter(baseDef);
  }
  return storeLDSValueAt(builder, context, slot.value.getLoc(), slot.value,
                         slot.type, token, slot.plan);
}

static FailureOr<wave::regalloc::MemorySpillLoadResult>
loadLDSScalarValue(OpBuilder &builder, const LDSAddTidContext &context,
                   Location loc, Type type, Value token,
                   wave::regalloc::LDSSpillPlan plan) {
  FailureOr<int64_t> offset = getLDSAddTidOffset(plan);
  if (failed(offset))
    return failure();
  Value m0 = materializeLDSM0(builder, loc, context);
  Type tokenType = waveamdmachine::MemTokenType::get(builder.getContext());
  waveamdmachine::DsLoadAddTidB32Op load =
      waveamdmachine::DsLoadAddTidB32Op::create(builder, loc, type, tokenType,
                                                m0, token, *offset);
  markRegAllocTemp(load, builder);
  return wave::regalloc::MemorySpillLoadResult{load.getResult(),
                                               load.getToken()};
}

static FailureOr<wave::regalloc::MemorySpillLoadResult>
loadLDSValue(OpBuilder &builder, const LDSAddTidContext &context, Location loc,
             Type type, Value token,
             ArrayRef<wave::regalloc::LDSSpillPlan> plans) {
  Operation *point = getInsertionPointOp(builder);
  Value liveM0 = point ? findLiveM0At(point) : Value{};
  unsigned width = cast<waveamdmachine::RegType>(type).getWidth();
  if (width == 1) {
    FailureOr<wave::regalloc::MemorySpillLoadResult> loaded =
        loadLDSScalarValue(builder, context, loc, type, token, plans.front());
    if (failed(loaded) ||
        (point && failed(restoreLiveM0(builder, liveM0, point))))
      return failure();
    return loaded;
  }

  SmallVector<Type> elementTypes =
      wave::regalloc::getMemorySpillScalarRegTypes(type);
  SmallVector<Value> elements;
  SmallVector<Value> tokens;
  elements.reserve(elementTypes.size());
  tokens.reserve(elementTypes.size());
  for (auto [index, elementType] : llvm::enumerate(elementTypes)) {
    FailureOr<wave::regalloc::MemorySpillLoadResult> load = loadLDSScalarValue(
        builder, context, loc, elementType, token, plans[index]);
    if (failed(load))
      return failure();
    elements.push_back(load->value);
    tokens.push_back(load->token);
  }
  Type tokenType = waveamdmachine::MemTokenType::get(builder.getContext());
  wave::regalloc::MemorySpillLoadResult result{
      wave::regalloc::joinMemorySpillValue(type, elements, builder, loc),
      wave::regalloc::joinMemorySpillTokens(tokenType, tokens, builder, loc)};
  if (point && failed(restoreLiveM0(builder, liveM0, point)))
    return failure();
  return result;
}

static void reserveLDSSpillBytes(func::FuncOp func, OpBuilder &builder,
                                 unsigned bytes) {
  unsigned reserved = getCommittedLDSSpillBytes(func);
  func->setAttr(wave::regalloc::kLDSSpillBytesAttr,
                builder.getI64IntegerAttr(reserved + bytes));
}

static LogicalResult materializeLDSRelief(OpBuilder &builder, func::FuncOp func,
                                          const LDSReliefCandidate &candidate) {
  if (shouldShiftDynamicLDS(candidate) &&
      failed(shiftDynamicLDSAddresses(func, builder, candidate.reservedBytes)))
    return failure();
  FailureOr<unsigned> ldsBaseBytes = getLDSBaseBytes(func, candidate);
  if (failed(ldsBaseBytes))
    return failure();
  LDSAddTidContext context =
      materializeLDSAddTidContext(builder, func, *ldsBaseBytes, candidate);
  auto store = [&](const LDSReliefSlot &slot, Value token) {
    return storeLDSValue(builder, context, slot, token);
  };
  auto load = [&](Location loc, Type type, Value token,
                  const LDSReliefPlan &plan)
      -> FailureOr<wave::regalloc::MemorySpillLoadResult> {
    return loadLDSValue(builder, context, loc, type, token, plan);
  };
  auto reserve = [&](unsigned bytes) {
    reserveLDSSpillBytes(func, builder, bytes);
  };
  auto loopStore = [&](Value value, Value token, const LDSReliefSlot &slot,
                       Location loc) -> FailureOr<Value> {
    return storeLDSValueAt(builder, context, loc, value, slot.type, token,
                           slot.plan);
  };
  if (failed(materializeMemoryRelief<LDSReliefSlot>(builder, candidate, store,
                                                    load, reserve, loopStore)))
    return failure();
  return restoreGeneratedLDSM0(func, builder);
}

static unsigned countLDSReliefDwords(const LDSReliefCandidate &candidate) {
  unsigned dwords = 0;
  for (const LDSReliefSlot &slot : candidate.slots)
    dwords += slot.type.getWidth();
  return dwords;
}

static bool hasNonXWorkgroupDimension(func::FuncOp func) {
  for (StringRef name : {"wave.workgroup_size", "gpu.known_block_size"}) {
    DenseI32ArrayAttr shape = func->getAttrOfType<DenseI32ArrayAttr>(name);
    if (!shape)
      continue;
    ArrayRef<int32_t> dims = shape.asArrayRef();
    return (dims.size() > 1 && dims[1] > 1) || (dims.size() > 2 && dims[2] > 1);
  }
  return false;
}

static LogicalResult runRegAllocLDSRelief(func::FuncOp func,
                                          RegAllocTransformStateCache &cache) {
  FailureOr<std::optional<RegAllocTransformFailure>> failureRecord =
      parseRegAllocTransformFailure(func);
  if (failed(failureRecord))
    return failure();
  if (!*failureRecord)
    return success();
  if (!isAGPRRelievableFailure(**failureRecord))
    return success();
  // X-based ds_addtid wave bases alias across non-X dimensions.
  if (hasNonXWorkgroupDimension(func))
    return success();

  FailureOr<wave::regalloc::RegisterBudgets> budgets =
      getLDSTransformBudgets(func);
  if (failed(budgets))
    return failure();
  LDSReliefPlanningState planning = getLDSReliefPlanningState(func, *budgets);
  FailureOr<std::optional<LDSReliefCandidate>> candidate =
      selectMemoryReliefCandidateFromState<LDSMemoryReliefTraits>(
          func, **failureRecord, planning, cache);
  if (failed(candidate))
    return failure();
  if (!*candidate)
    return success();

  llvm::scope_exit clearCache([&] { cache.erase(func); });
  OpBuilder builder(func.getContext());
  if (failed(materializeLDSRelief(builder, func, **candidate)))
    return failure();
  if (failed(wave::addRegAllocTransformProviderMetadata(
          func, builder, "lds", countLDSReliefDwords(**candidate))))
    return failure();
  wave::invalidateRegAllocPreparation(func);
  func->removeAttr(wave::getRegAllocTransformAssignmentsAttrName());
  func->removeAttr(wave::getRegAllocTransformStateAttrName());
  return success();
}

} // namespace

LogicalResult
wave::runRegAllocTransformLDSRelief(Operation *target, Builder &builder,
                                    RegAllocTransformStateCache *cache) {
  RegAllocTransformStateCache localCache;
  if (!cache)
    cache = &localCache;
  if (func::FuncOp func = dyn_cast<func::FuncOp>(target))
    return runRegAllocLDSRelief(func, *cache);
  WalkResult walk = target->walk<WalkOrder::PreOrder>([&](func::FuncOp func) {
    return failed(runRegAllocLDSRelief(func, *cache)) ? WalkResult::interrupt()
                                                      : WalkResult::skip();
  });
  return failure(walk.wasInterrupted());
}
