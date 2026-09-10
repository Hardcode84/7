//===- WaveAMDRegAllocInternal.h - Regalloc internals ----------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef MLIR_DIALECT_WAVE_TRANSFORMS_WAVEAMDREGALLOCINTERNAL_H
#define MLIR_DIALECT_WAVE_TRANSFORMS_WAVEAMDREGALLOCINTERNAL_H

#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachine.h"
#include "mlir/IR/Block.h"
#include "mlir/IR/Builders.h"
#include "mlir/IR/Operation.h"
#include "mlir/IR/Value.h"
#include "mlir/Support/LLVM.h"
#include "mlir/Support/LogicalResult.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/ADT/StringRef.h"
#include <cstdint>
#include <optional>

namespace mlir::wave::regalloc {

inline constexpr llvm::StringLiteral kRegAllocTempAttr =
    "waveamdmachine.regalloc_debug_temp";
inline constexpr llvm::StringLiteral kRegAllocRematTempAttr =
    "waveamdmachine.regalloc_remat_temp";
inline constexpr llvm::StringLiteral kRegAllocSGPRToVGPRTempAttr =
    "waveamdmachine.regalloc_sgpr_to_vgpr_temp";
inline constexpr llvm::StringLiteral kRegAllocSGPRToVGPRPinnedAttr =
    "waveamdmachine.regalloc_sgpr_to_vgpr_pinned";
inline constexpr llvm::StringLiteral kLDSSpillBytesAttr =
    "waveamdmachine.lds_spill_bytes";
inline constexpr llvm::StringLiteral kPrivateSegmentFixedSizeAttr =
    "waveamdmachine.private_segment_fixed_size";
inline constexpr llvm::StringLiteral kScratchSpillBytesAttr =
    "waveamdmachine.scratch_spill_bytes";
inline constexpr llvm::StringLiteral kUsesFlatScratchAttr =
    "waveamdmachine.uses_flat_scratch";
inline constexpr llvm::StringLiteral kSGPRSpillCountAttr =
    "waveamdmachine.sgpr_spill_count";
inline constexpr llvm::StringLiteral kVGPRSpillCountAttr =
    "waveamdmachine.vgpr_spill_count";
inline constexpr llvm::StringLiteral kRegAllocCoalesceMFMAAccResultAttr =
    "waveamdmachine.regalloc_coalesce_mfma_acc_result";

inline bool isRegAllocTempOp(Operation *op) {
  return op && op->hasAttr(kRegAllocTempAttr);
}

inline bool isRegAllocRematTempOp(Operation *op) {
  return op && op->hasAttr(kRegAllocRematTempAttr);
}

inline bool isRegAllocGeneratedOp(Operation *op) {
  return isRegAllocTempOp(op) || isRegAllocRematTempOp(op);
}

inline bool isMemoryIssuerOp(Operation *op) {
  if (!op)
    return false;
  waveamdmachine::WaitcntInfoOpInterface info =
      dyn_cast<waveamdmachine::WaitcntInfoOpInterface>(op);
  return info && info.getWaitcntInfo().isIssuer();
}

inline Value getMemoryIssuerToken(Operation *op) {
  if (!isMemoryIssuerOp(op))
    return {};
  for (Value result : op->getResults())
    if (isa<waveamdmachine::MemTokenType>(result.getType()))
      return result;
  return {};
}

inline Operation *getAncestorInBlock(Operation *op, Block *block) {
  for (Operation *cur = op; cur; cur = cur->getParentOp())
    if (cur->getBlock() == block)
      return cur;
  return nullptr;
}
inline bool isCheapVGPRPressureReliefRootExpr(Operation *op);

struct MemorySpillLoadResult {
  Value value;
  Value token;
};

struct MemorySpillLoopCarrySlot {
  waveamdmachine::UniformLoopOp loop;
  unsigned index = 0;
};

inline LogicalResult
mergeLoopCarrySlot(MemorySpillLoopCarrySlot next,
                   std::optional<MemorySpillLoopCarrySlot> &slot) {
  if (!slot) {
    slot = next;
    return success();
  }
  if (slot->loop == next.loop && slot->index == next.index)
    return success();
  return failure();
}

inline std::optional<MemorySpillLoopCarrySlot>
getValueLoopCarrySlot(Value value) {
  if (BlockArgument arg = dyn_cast<BlockArgument>(value))
    if (waveamdmachine::UniformLoopOp loop =
            dyn_cast<waveamdmachine::UniformLoopOp>(
                arg.getOwner()->getParentOp()))
      return MemorySpillLoopCarrySlot{loop, arg.getArgNumber()};
  if (waveamdmachine::UniformLoopOp loop =
          value.getDefiningOp<waveamdmachine::UniformLoopOp>())
    return MemorySpillLoopCarrySlot{loop,
                                    cast<OpResult>(value).getResultNumber()};
  for (OpOperand &use : value.getUses()) {
    Operation *owner = use.getOwner();
    if (waveamdmachine::UniformLoopOp loop =
            dyn_cast<waveamdmachine::UniformLoopOp>(owner))
      for (auto [index, init] : llvm::enumerate(loop.getInits()))
        if (init == value)
          return MemorySpillLoopCarrySlot{loop, static_cast<unsigned>(index)};
    if (waveamdmachine::ContinueIfOp term =
            dyn_cast<waveamdmachine::ContinueIfOp>(owner))
      if (use.getOperandNumber() != 0)
        return MemorySpillLoopCarrySlot{
            term->getParentOfType<waveamdmachine::UniformLoopOp>(),
            use.getOperandNumber() - 1};
  }
  return std::nullopt;
}

inline LogicalResult
mergeLoopCarrySlot(Value value, std::optional<MemorySpillLoopCarrySlot> &slot) {
  if (std::optional<MemorySpillLoopCarrySlot> valueSlot =
          getValueLoopCarrySlot(value))
    return mergeLoopCarrySlot(*valueSlot, slot);
  return success();
}

inline bool hasLocalLoopCarryUses(MemorySpillLoopCarrySlot slot) {
  Block &body = slot.loop.getBody().front();
  BlockArgument arg = body.getArgument(slot.index);
  for (OpOperand &use : arg.getUses())
    if (!getAncestorInBlock(use.getOwner(), &body))
      return false;
  return true;
}

inline bool canRewriteExtraLoopInitUse(OpOperand &use, OpOperand *loopUse,
                                       waveamdmachine::UniformLoopOp loop) {
  if (&use == loopUse || isRegAllocGeneratedOp(use.getOwner()))
    return true;
  Operation *user = use.getOwner();
  return user->getBlock() == loop->getBlock() && user->isBeforeInBlock(loop);
}

inline bool canRewriteExtraLoopInitUses(MemorySpillLoopCarrySlot slot) {
  OpOperand *loopUse = &slot.loop.getInitsMutable()[slot.index];
  Value init = loopUse->get();
  for (OpOperand &use : init.getUses())
    if (!canRewriteExtraLoopInitUse(use, loopUse, slot.loop))
      return false;
  return true;
}

inline Operation *
getLoopCarryFirstPreheaderUse(Value init, OpOperand *loopUse,
                              waveamdmachine::UniformLoopOp loop) {
  Operation *first = nullptr;
  for (OpOperand &use : init.getUses()) {
    Operation *user = use.getOwner();
    if (&use == loopUse || isRegAllocGeneratedOp(user))
      continue;
    if (!canRewriteExtraLoopInitUse(use, loopUse, loop))
      continue;
    if (user->getBlock() != loop->getBlock() || !user->isBeforeInBlock(loop))
      continue;
    if (!first || user->isBeforeInBlock(first))
      first = user;
  }
  return first;
}

inline Operation *
getLoopCarryInitStoreDiagOp(Value init, OpOperand *loopUse,
                            waveamdmachine::UniformLoopOp loop) {
  Operation *def = init.getDefiningOp();
  Operation *firstPreheaderUse =
      getLoopCarryFirstPreheaderUse(init, loopUse, loop);
  if (firstPreheaderUse && (!def || def->getBlock() != loop->getBlock() ||
                            def->isBeforeInBlock(firstPreheaderUse)))
    return firstPreheaderUse;
  if (!def || def->getBlock() != loop->getBlock() ||
      !def->isBeforeInBlock(loop))
    return loop.getOperation();
  return def;
}

inline void setInsertionPointForMemorySpillStore(Value value,
                                                 OpBuilder &builder) {
  if (Operation *def = value.getDefiningOp()) {
    builder.setInsertionPointAfter(def);
    return;
  }
  BlockArgument arg = cast<BlockArgument>(value);
  builder.setInsertionPointToStart(arg.getOwner());
}

inline SmallVector<Type> getMemorySpillScalarRegTypes(Type tupleType) {
  waveamdmachine::RegType regType = cast<waveamdmachine::RegType>(tupleType);
  SmallVector<Type> types;
  types.reserve(regType.getWidth());
  for (unsigned lane : llvm::seq<unsigned>(0, regType.getWidth())) {
    int64_t index = -1;
    if (regType.getIndex() >= 0)
      index = regType.getIndex() + lane;
    types.push_back(waveamdmachine::RegType::get(
        tupleType.getContext(), regType.getRegClass(), /*width=*/1, index));
  }
  return types;
}

inline SmallVector<Value> splitMemorySpillValue(Value value, OpBuilder &builder,
                                                Location loc) {
  SmallVector<Type> elementTypes =
      getMemorySpillScalarRegTypes(value.getType());
  waveamdmachine::TupleToElementsOp split =
      waveamdmachine::TupleToElementsOp::create(builder, loc, elementTypes,
                                                value);
  split->setAttr(kRegAllocTempAttr, builder.getUnitAttr());
  return SmallVector<Value>(split.getElements().begin(),
                            split.getElements().end());
}

inline Value joinMemorySpillValue(Type type, ArrayRef<Value> elements,
                                  OpBuilder &builder, Location loc) {
  waveamdmachine::TupleFromElementsOp joined =
      waveamdmachine::TupleFromElementsOp::create(builder, loc, type, elements);
  joined->setAttr(kRegAllocTempAttr, builder.getUnitAttr());
  return joined.getTuple();
}

inline Value joinMemorySpillTokens(Type tokenType, ArrayRef<Value> tokens,
                                   OpBuilder &builder, Location loc) {
  if (tokens.size() == 1)
    return tokens.front();
  waveamdmachine::TokenJoinOp join =
      waveamdmachine::TokenJoinOp::create(builder, loc, tokenType, tokens);
  join->setAttr(kRegAllocTempAttr, builder.getUnitAttr());
  return join.getResult();
}

inline bool isMemorySpillSuppressedVGPRExpr(Operation *op) {
  return isa_and_nonnull<
      waveamdmachine::VWorkitemIdXOp, waveamdmachine::VWorkitemIdYOp,
      waveamdmachine::VWorkitemIdZOp, waveamdmachine::VMovB32TupleOp,
      waveamdmachine::CopyTupleOp, waveamdmachine::UpdateTupleOp,
      waveamdmachine::VLshrrevB32Op, waveamdmachine::VLshlrevB32Op,
      waveamdmachine::VLshlAddU32Op, waveamdmachine::VAddU32Op,
      waveamdmachine::VAdd3U32Op, waveamdmachine::VAndB32Op,
      waveamdmachine::VBfeU32Op, waveamdmachine::VMulLoU32Op,
      waveamdmachine::VAddLshlU32Op, waveamdmachine::VXorB32Op,
      waveamdmachine::VAndOrB32Op, waveamdmachine::VPermB32Op,
      waveamdmachine::VBitOp3B32Op, waveamdmachine::VCndmaskB32TupleOp,
      waveamdmachine::VCndmaskB32VccOp, waveamdmachine::VAccvgprReadB32TupleOp,
      waveamdmachine::VAccvgprWriteB32TupleOp>(op);
}

inline bool isCheapVGPRPressureReliefExpr(Operation *op) {
  return isCheapVGPRPressureReliefRootExpr(op) ||
         isa_and_nonnull<waveamdmachine::TupleFromElementsOp>(op);
}

inline bool isCheapVGPRPressureReliefRootExpr(Operation *op) {
  return isMemorySpillSuppressedVGPRExpr(op) ||
         isa_and_nonnull<waveamdmachine::VMulU64Op, waveamdmachine::VAddU64Op>(
             op);
}

struct RegisterBudgets {
  SmallVector<unsigned, 32> maxSGPRsForWaves;
  SmallVector<unsigned, 32> maxVGPRsForWaves;
  std::optional<unsigned> totalVGPRLimit;
  unsigned addressableSGPR = 0;
  unsigned addressableVGPR = 0;
  unsigned addressableAGPR = 0;
  unsigned sgpr = 0;
  unsigned vgpr = 0;
  unsigned agpr = 0;
  unsigned maxWavesPerEU = 0;
  unsigned targetWaves = 0;
  bool agprCountsAgainstVGPRs = false;
  bool combinedPlacementVGPRLimit = false;
};

enum class LDSSpillPlanStatus : uint8_t {
  Available,
  NotKernel,
  MissingWorkgroupShape,
  InvalidWorkgroupShape,
  UnsupportedWorkgroupShape,
  UnsupportedSlotBase,
  UnsupportedWavesPerWorkgroup,
  InvalidValueBytes,
  InsufficientLDS,
};

struct LDSSpillPlan {
  unsigned existingFixedBytes = 0;
  unsigned existingDynamicBytes = 0;
  unsigned reservedSpillBytes = 0;
  unsigned limitBytes = 0;
  unsigned availableBytes = 0;
  unsigned slotBase = 0;
  unsigned slotBytes = 0;
  unsigned waveStride = 0;
  unsigned valueBytes = 0;
  unsigned wavesPerWorkgroup = 0;
  unsigned wavefrontSize = 0;
  LDSSpillPlanStatus status = LDSSpillPlanStatus::NotKernel;
};

struct LDSSpillPlanningInfo {
  uint64_t limitBytes = 0;
  unsigned localMemorySize = 0;
  unsigned addressableLocalMemorySize = 0;
  unsigned wavefrontSize = 0;
  unsigned eusPerCU = 0;
  unsigned wavesPerWorkgroup = 0;
  LDSSpillPlanStatus status = LDSSpillPlanStatus::InsufficientLDS;
};

enum class ScratchSpillPlanStatus : uint8_t {
  Available,
  NotKernel,
  UnsupportedTarget,
  InvalidValueBytes,
  PrivateSegmentOverflow,
};

struct ScratchSpillPlan {
  unsigned existingPrivateBytes = 0;
  unsigned reservedSpillBytes = 0;
  unsigned slotBase = 0;
  unsigned slotBytes = 0;
  unsigned valueBytes = 0;
  bool usesFlatScratch = false;
  ScratchSpillPlanStatus status = ScratchSpillPlanStatus::NotKernel;
};

StringRef getLDSSpillPlanStatusName(LDSSpillPlanStatus status);
void getExistingLDSBytes(func::FuncOp func, unsigned &fixedBytes,
                         unsigned &dynamicBytes, unsigned reservedSpillBytes);
LDSSpillPlanningInfo getLDSSpillPlanningInfo(func::FuncOp func,
                                             RegisterBudgets budgets);
LDSSpillPlan planLDSSpillSlot(const LDSSpillPlanningInfo &planning,
                              unsigned valueBytes, unsigned reservedSpillBytes,
                              unsigned fixedLDS, unsigned dynamicLDS);
LDSSpillPlan planLDSSpillSlot(func::FuncOp func, RegisterBudgets budgets,
                              unsigned valueBytes,
                              unsigned reservedSpillBytes = 0);
LDSSpillPlan planLDSSpillSlot(func::FuncOp func, RegisterBudgets budgets,
                              unsigned valueBytes, unsigned reservedSpillBytes,
                              unsigned fixedLDS, unsigned dynamicLDS);
StringRef getScratchSpillPlanStatusName(ScratchSpillPlanStatus status);
unsigned getExistingPrivateSegmentBytes(func::FuncOp func,
                                        unsigned reservedSpillBytes);
ScratchSpillPlan planScratchSpillSlot(func::FuncOp func, unsigned valueBytes,
                                      unsigned reservedSpillBytes = 0);
ScratchSpillPlan planScratchSpillSlot(func::FuncOp func, unsigned valueBytes,
                                      unsigned reservedSpillBytes,
                                      unsigned existingPrivateBytes);

} // namespace mlir::wave::regalloc

#endif // MLIR_DIALECT_WAVE_TRANSFORMS_WAVEAMDREGALLOCINTERNAL_H
