//===- WaveAMDMachineCleanup.cpp - Machine cleanup pass ---------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "WaveAMDHardwareResources.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/Wave/Transforms/Passes.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachine.h"
#include "mlir/Interfaces/SideEffectInterfaces.h"
#include "llvm/ADT/STLExtras.h"

namespace mlir::wave {
#define GEN_PASS_DEF_WAVEAMDMACHINECLEANUP
#include "mlir/Dialect/Wave/Transforms/Passes.h.inc"
} // namespace mlir::wave

using namespace mlir;
using namespace mlir::wave;
using namespace mlir::waveamdmachine;

namespace {
namespace traits = OpTrait::waveamdmachine;

struct ScaledLoopStep {
  SAddI32Op add;
  Value step;
  unsigned stepOperand = 1;
};

struct ScaledLoopCarryPlan {
  SmallVector<SLshlB32Op, 4> shifts;
  SmallVector<ScaledLoopStep, 2> steps;
  int64_t shift = 0;
};

static waveamdmachine::RegType getSCCType(MLIRContext *ctx) {
  return waveamdmachine::RegType::get(ctx, waveamdmachine::RegClass::SCC, 1,
                                      -1);
}

static waveamdmachine::ImmOp createImm(OpBuilder &builder, Location loc,
                                       uint64_t value) {
  return waveamdmachine::ImmOp::create(
      builder, loc, waveamdmachine::ImmType::get(builder.getContext()), value);
}

static std::optional<int64_t> getImmValue(Value value) {
  auto imm = value.getDefiningOp<ImmOp>();
  if (!imm)
    return std::nullopt;
  return imm.getValue();
}

static Value createShiftedReg(OpBuilder &builder, Location loc, Value value,
                              int64_t shift) {
  auto shifted = SLshlB32Op::create(builder, loc, value.getType(),
                                    getSCCType(builder.getContext()), value,
                                    createImm(builder, loc, shift));
  return shifted.getResult();
}

static std::optional<uint64_t> shiftU32Imm(int64_t value, int64_t shift) {
  if (shift < 0 || shift >= 32)
    return std::nullopt;
  uint32_t bits = static_cast<uint32_t>(value);
  return static_cast<uint64_t>(bits << shift);
}

static bool operationIsInside(Operation *root, Operation *op) {
  for (Operation *cur = op; cur; cur = cur->getParentOp())
    if (cur == root)
      return true;
  return false;
}

static bool valueIsDefinedInside(Operation *root, Value value) {
  if (Operation *def = value.getDefiningOp())
    return operationIsInside(root, def);
  BlockArgument arg = dyn_cast<BlockArgument>(value);
  return arg && operationIsInside(root, arg.getOwner()->getParentOp());
}

static bool isWaveAMDMachineOp(Operation *op) {
  return op->getName().getDialectNamespace() ==
         WaveAMDMachineDialect::getDialectNamespace();
}

static bool hasOnlyLocalNonYieldUsers(Operation *root, Operation *op) {
  bool sawUse = false;
  for (OpResult result : op->getResults()) {
    for (OpOperand &use : result.getUses()) {
      Operation *owner = use.getOwner();
      if (isa<waveamdmachine::YieldOp>(owner))
        return false;
      if (!operationIsInside(root, owner))
        return false;
      sawUse = true;
    }
  }
  return sawUse;
}

static bool hasHoistableShape(Operation *op) {
  if (!isWaveAMDMachineOp(op))
    return false;
  if (op->getNumRegions() != 0)
    return false;
  return op->getNumResults() != 0;
}

static bool isHoistableKind(Operation *op) {
  if (!isa<ImmOp>(op) && !op->hasTrait<traits::VALUOp>() &&
      !op->hasTrait<traits::SALUOp>())
    return false;
  return true;
}

static bool isFlagResource(HardwareResourceKind kind) {
  return kind == HardwareResourceKind::SCC || kind == HardwareResourceKind::VCC;
}

static bool touchesOnlyUnusedFlags(Operation *op,
                                   const HardwareResourceEffects &effects) {
  if (!effects.reads.empty())
    return false;
  if (!llvm::all_of(effects.writes, [](HardwareResourceKind kind) {
        return isFlagResource(kind);
      }))
    return false;

  bool sawFlagResult = false;
  for (OpResult result : op->getResults()) {
    std::optional<HardwareResourceKind> kind =
        getHardwareResourceForValue(result);
    if (!kind)
      continue;
    if (!isFlagResource(*kind) || !result.use_empty())
      return false;
    sawFlagResult = true;
  }
  return sawFlagResult;
}

static bool hasHoistableSemantics(Operation *op) {
  if (!isMemoryEffectFree(op) || !isSpeculatable(op))
    return false;
  HardwareResourceEffects effects = getHardwareResourceEffects(op);
  if (effects.reads.empty() && effects.writes.empty())
    return true;
  return touchesOnlyUnusedFlags(op, effects);
}

static bool operandsAvailableBefore(Operation *root, Operation *op) {
  for (Value operand : op->getOperands())
    if (valueIsDefinedInside(root, operand))
      return false;
  return true;
}

static bool canHoistThroughExecIf(Operation *root, Operation *op) {
  if (!hasHoistableShape(op))
    return false;
  if (!isHoistableKind(op))
    return false;
  if (!hasHoistableSemantics(op))
    return false;
  if (!operandsAvailableBefore(root, op))
    return false;
  return hasOnlyLocalNonYieldUsers(root, op);
}

static bool hoistFromRegion(Operation *root, Region &region) {
  if (region.empty())
    return false;

  Block &block = region.front();
  Operation *terminator = block.getTerminator();
  SmallVector<Operation *> ops;
  for (Operation &op : block) {
    if (&op == terminator)
      break;
    ops.push_back(&op);
  }

  bool changed = false;
  for (Operation *op : ops) {
    if (!canHoistThroughExecIf(root, op))
      continue;
    op->moveBefore(root);
    changed = true;
  }
  return changed;
}

static bool hoistExecIf(ExecIfOp execIf) {
  bool changed = hoistFromRegion(execIf.getOperation(), execIf.getThenRegion());
  changed |= hoistFromRegion(execIf.getOperation(), execIf.getElseRegion());
  return changed;
}

static bool hoistFunction(func::FuncOp func) {
  SmallVector<ExecIfOp> execIfs;
  func.walk([&](ExecIfOp execIf) { execIfs.push_back(execIf); });

  bool changed = false;
  for (ExecIfOp execIf : llvm::reverse(execIfs))
    changed |= hoistExecIf(execIf);
  return changed;
}

static bool isLoopCarryTerminatorUse(OpOperand &use, ContinueIfOp term,
                                     unsigned index) {
  return use.getOwner() == term && use.getOperandNumber() == index + 1;
}

static bool matchShiftUse(Operation *owner, Value value,
                          std::optional<int64_t> &shift,
                          SmallVectorImpl<SLshlB32Op> &shifts) {
  auto shl = dyn_cast<SLshlB32Op>(owner);
  if (!shl || shl.getLhs() != value || !shl.getScc().use_empty())
    return false;
  std::optional<int64_t> amount = getImmValue(shl.getRhs());
  if (!amount || *amount <= 0 || *amount >= 32)
    return false;
  if (shift && *shift != *amount)
    return false;
  shift = *amount;
  shifts.push_back(shl);
  return true;
}

static SAddI32Op matchStepUse(Operation *owner, Value value,
                              unsigned &stepOperand) {
  auto add = dyn_cast<SAddI32Op>(owner);
  if (!add || !add.getScc().use_empty())
    return {};
  bool lhs = add.getLhs() == value;
  bool rhs = add.getRhs() == value;
  if (lhs == rhs)
    return {};
  stepOperand = lhs ? 1 : 0;
  return add;
}

static LogicalResult
collectLoopCarryUse(OpOperand &use, Value current, ContinueIfOp term,
                    unsigned index, std::optional<int64_t> &shift,
                    SmallVectorImpl<SLshlB32Op> &shifts, SAddI32Op &stepAdd,
                    unsigned &stepOperand, bool &sawCarry) {
  Operation *user = use.getOwner();
  if (matchShiftUse(user, current, shift, shifts))
    return success();

  unsigned matchedStepOperand = 1;
  if (SAddI32Op add = matchStepUse(user, current, matchedStepOperand)) {
    if (stepAdd)
      return failure();
    stepAdd = add;
    stepOperand = matchedStepOperand;
    return success();
  }

  if (isLoopCarryTerminatorUse(use, term, index)) {
    sawCarry = true;
    return success();
  }
  return failure();
}

static LogicalResult
collectLoopCarryStep(Value current, ContinueIfOp term, unsigned index,
                     std::optional<int64_t> &shift,
                     SmallVectorImpl<SLshlB32Op> &shifts, SAddI32Op &stepAdd,
                     unsigned &stepOperand, bool &sawCarry) {
  for (OpOperand &use : llvm::make_early_inc_range(current.getUses()))
    if (failed(collectLoopCarryUse(use, current, term, index, shift, shifts,
                                   stepAdd, stepOperand, sawCarry)))
      return failure();
  return success();
}

static LogicalResult appendLoopCarryStep(UniformLoopOp loop, SAddI32Op stepAdd,
                                         unsigned stepOperand,
                                         ScaledLoopCarryPlan &plan,
                                         Value &current) {
  if (!stepAdd)
    return failure();
  Value step = stepAdd->getOperand(stepOperand);
  if (!getImmValue(step) && valueIsDefinedInside(loop, step))
    return failure();
  plan.steps.push_back({stepAdd, step, stepOperand});
  current = stepAdd.getResult();
  return success();
}

static FailureOr<ScaledLoopCarryPlan>
buildScaledLoopCarryPlan(UniformLoopOp loop, unsigned index) {
  if (!loop.getResult(index).use_empty())
    return failure();

  Block &body = loop.getBody().front();
  auto term = cast<ContinueIfOp>(body.getTerminator());
  Value current = body.getArgument(index);
  std::optional<int64_t> shift;
  ScaledLoopCarryPlan plan;

  while (true) {
    SAddI32Op stepAdd;
    unsigned stepOperand = 1;
    bool sawCarry = false;

    if (failed(collectLoopCarryStep(current, term, index, shift, plan.shifts,
                                    stepAdd, stepOperand, sawCarry)))
      return failure();

    if (sawCarry) {
      if (stepAdd)
        return failure();
      break;
    }
    if (failed(appendLoopCarryStep(loop, stepAdd, stepOperand, plan, current)))
      return failure();
  }

  if (!shift || plan.shifts.empty())
    return failure();
  plan.shift = *shift;
  return plan;
}

static bool valueAvailableBefore(Value value, Operation *op) {
  Operation *def = value.getDefiningOp();
  if (!def)
    return true;
  if (def->getBlock() != op->getBlock())
    return true;
  return def->isBeforeInBlock(op);
}

static bool planValuesAvailableBefore(UniformLoopOp loop, unsigned index,
                                      const ScaledLoopCarryPlan &plan,
                                      Operation *op) {
  if (!valueAvailableBefore(loop.getInits()[index], op))
    return false;
  for (const ScaledLoopStep &step : plan.steps)
    if (!getImmValue(step.step) && !valueAvailableBefore(step.step, op))
      return false;
  return true;
}

static Operation *getScaleInsertPoint(UniformLoopOp loop, unsigned index,
                                      const ScaledLoopCarryPlan &plan) {
  Value entryCond = loop.getEntryCond();
  Operation *condDef = entryCond ? entryCond.getDefiningOp() : nullptr;
  if (condDef && condDef->getBlock() == loop->getBlock() &&
      planValuesAvailableBefore(loop, index, plan, condDef))
    return condDef;
  return loop;
}

static Value createScaledStep(OpBuilder &builder, Operation *insertPoint,
                              Value step, int64_t shift) {
  if (std::optional<int64_t> imm = getImmValue(step)) {
    std::optional<uint64_t> shifted = shiftU32Imm(*imm, shift);
    if (!shifted)
      return {};
    return createImm(builder, step.getLoc(), *shifted);
  }
  builder.setInsertionPoint(insertPoint);
  return createShiftedReg(builder, step.getLoc(), step, shift);
}

static bool scaleLoopCarry(UniformLoopOp loop, unsigned index,
                           const ScaledLoopCarryPlan &plan) {
  OpBuilder builder(loop.getContext());
  Value init = loop.getInits()[index];
  Operation *insertPoint = getScaleInsertPoint(loop, index, plan);
  builder.setInsertionPoint(insertPoint);
  Value scaledInit = createShiftedReg(builder, loop.getLoc(), init, plan.shift);
  loop.getInitsMutable()[index].assign(scaledInit);

  for (SLshlB32Op shl : plan.shifts) {
    shl.getResult().replaceAllUsesWith(shl.getLhs());
    shl.erase();
  }

  for (const ScaledLoopStep &step : plan.steps) {
    Value scaledStep =
        createScaledStep(builder, insertPoint, step.step, plan.shift);
    if (!scaledStep)
      return false;
    step.add->setOperand(step.stepOperand, scaledStep);
  }
  return true;
}

static bool scaleLoopCarries(UniformLoopOp loop) {
  SmallVector<std::pair<unsigned, ScaledLoopCarryPlan>, 2> plans;
  for (unsigned index : llvm::seq<unsigned>(0, loop.getInits().size())) {
    FailureOr<ScaledLoopCarryPlan> plan = buildScaledLoopCarryPlan(loop, index);
    if (succeeded(plan))
      plans.push_back({index, std::move(*plan)});
  }

  bool changed = false;
  for (auto &[index, plan] : plans)
    changed |= scaleLoopCarry(loop, index, plan);
  return changed;
}

static bool scaleLoopCarries(func::FuncOp func) {
  SmallVector<UniformLoopOp> loops;
  func.walk([&](UniformLoopOp loop) { loops.push_back(loop); });

  bool changed = false;
  for (UniformLoopOp loop : loops)
    changed |= scaleLoopCarries(loop);
  return changed;
}

struct WaveAMDMachineCleanupPass
    : public wave::impl::WaveAMDMachineCleanupBase<WaveAMDMachineCleanupPass> {
  void runOnOperation() override {
    getOperation()->walk([&](func::FuncOp func) {
      bool changed = true;
      while (changed) {
        changed = hoistFunction(func);
        changed |= scaleLoopCarries(func);
      }
    });
  }
};
} // namespace
