//===- WaveAMDScalarMaskPreschedule.cpp - scalar mask sinking ------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/Wave/Transforms/Passes.h"

#include "WaveAMDHardwareResources.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachine.h"
#include "llvm/ADT/DenseSet.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/ADT/SmallVector.h"

namespace mlir::wave {
#define GEN_PASS_DEF_WAVEAMDSCALARMASKPOSTSCHEDULE
#define GEN_PASS_DEF_WAVEAMDSCALARMASKPRESCHEDULE
#include "mlir/Dialect/Wave/Transforms/Passes.h.inc"
} // namespace mlir::wave

using namespace mlir;

namespace {

static bool isVCCCompare(Operation *op) {
  return op->hasTrait<OpTrait::waveamdmachine::VCmpVccOp>();
}

static bool hasLiveVCCWrite(Operation *op) {
  wave::HardwareResourceEffects effects = wave::getHardwareResourceEffects(op);
  if (!llvm::is_contained(effects.writes, wave::HardwareResourceKind::VCC))
    return false;
  bool hasVCCResult = false;
  for (Value result : op->getResults()) {
    if (wave::getHardwareResourceForValue(result) !=
        wave::HardwareResourceKind::VCC)
      continue;
    hasVCCResult = true;
    if (!result.use_empty())
      return true;
  }
  return !hasVCCResult;
}

static bool hasLiveVCCWriteIn(Operation *root) {
  return root
      ->walk([&](Operation *op) {
        if (hasLiveVCCWrite(op))
          return WalkResult::interrupt();
        return WalkResult::advance();
      })
      .wasInterrupted();
}

static bool hasLiveVCCWriteBetween(Operation *first, Operation *last) {
  for (Operation *op = first->getNextNode(); op && op != last;
       op = op->getNextNode())
    if (hasLiveVCCWriteIn(op))
      return true;
  return false;
}

static bool regionWritesVCC(Region &region) {
  return region
      .walk([&](Operation *op) {
        wave::HardwareResourceEffects effects =
            wave::getHardwareResourceEffects(op);
        if (llvm::is_contained(effects.writes, wave::HardwareResourceKind::VCC))
          return WalkResult::interrupt();
        return WalkResult::advance();
      })
      .wasInterrupted();
}

static Value getUnusedVCCResult(Value mask) {
  Value vcc = waveamdmachine::getVCCCopySource(mask);
  if (!vcc || !vcc.hasOneUse())
    return {};
  Operation *compare = vcc.getDefiningOp();
  return compare && isVCCCompare(compare) ? vcc : Value();
}

template <typename DirectCompareOp, typename VCCCompareOp>
static void makeCompareResultDirect(OpBuilder &builder, Operation *copy,
                                    VCCCompareOp compare) {
  builder.setInsertionPoint(compare);
  DirectCompareOp direct = DirectCompareOp::create(
      builder, compare.getLoc(), copy->getResult(0).getType(), compare.getLhs(),
      compare.getRhs());
  direct->setAttrs(compare->getAttrs());
  copy->getResult(0).replaceAllUsesWith(direct.getResult());
  copy->erase();
  compare.erase();
}

static bool makeUnsignedCompareResultDirect(OpBuilder &builder, Operation *copy,
                                            Operation *op) {
  if (auto compare = dyn_cast<waveamdmachine::VCmpEqU32VccOp>(op))
    makeCompareResultDirect<waveamdmachine::VCmpEqU32Op>(builder, copy,
                                                         compare);
  else if (auto compare = dyn_cast<waveamdmachine::VCmpNeU32VccOp>(op))
    makeCompareResultDirect<waveamdmachine::VCmpNeU32Op>(builder, copy,
                                                         compare);
  else if (auto compare = dyn_cast<waveamdmachine::VCmpLtU32VccOp>(op))
    makeCompareResultDirect<waveamdmachine::VCmpLtU32Op>(builder, copy,
                                                         compare);
  else if (auto compare = dyn_cast<waveamdmachine::VCmpLeU32VccOp>(op))
    makeCompareResultDirect<waveamdmachine::VCmpLeU32Op>(builder, copy,
                                                         compare);
  else if (auto compare = dyn_cast<waveamdmachine::VCmpGtU32VccOp>(op))
    makeCompareResultDirect<waveamdmachine::VCmpGtU32Op>(builder, copy,
                                                         compare);
  else if (auto compare = dyn_cast<waveamdmachine::VCmpGeU32VccOp>(op))
    makeCompareResultDirect<waveamdmachine::VCmpGeU32Op>(builder, copy,
                                                         compare);
  else
    return false;
  return true;
}

static bool makeSignedCompareResultDirect(OpBuilder &builder, Operation *copy,
                                          Operation *op) {
  if (auto compare = dyn_cast<waveamdmachine::VCmpLtI32VccOp>(op))
    makeCompareResultDirect<waveamdmachine::VCmpLtI32Op>(builder, copy,
                                                         compare);
  else if (auto compare = dyn_cast<waveamdmachine::VCmpLeI32VccOp>(op))
    makeCompareResultDirect<waveamdmachine::VCmpLeI32Op>(builder, copy,
                                                         compare);
  else if (auto compare = dyn_cast<waveamdmachine::VCmpGtI32VccOp>(op))
    makeCompareResultDirect<waveamdmachine::VCmpGtI32Op>(builder, copy,
                                                         compare);
  else if (auto compare = dyn_cast<waveamdmachine::VCmpGeI32VccOp>(op))
    makeCompareResultDirect<waveamdmachine::VCmpGeI32Op>(builder, copy,
                                                         compare);
  else
    return false;
  return true;
}

static bool makeFloatCompareResultDirect(OpBuilder &builder, Operation *copy,
                                         Operation *op) {
  if (auto compare = dyn_cast<waveamdmachine::VCmpEqF32VccOp>(op))
    makeCompareResultDirect<waveamdmachine::VCmpEqF32Op>(builder, copy,
                                                         compare);
  else if (auto compare = dyn_cast<waveamdmachine::VCmpLtF32VccOp>(op))
    makeCompareResultDirect<waveamdmachine::VCmpLtF32Op>(builder, copy,
                                                         compare);
  else if (auto compare = dyn_cast<waveamdmachine::VCmpLeF32VccOp>(op))
    makeCompareResultDirect<waveamdmachine::VCmpLeF32Op>(builder, copy,
                                                         compare);
  else if (auto compare = dyn_cast<waveamdmachine::VCmpGtF32VccOp>(op))
    makeCompareResultDirect<waveamdmachine::VCmpGtF32Op>(builder, copy,
                                                         compare);
  else if (auto compare = dyn_cast<waveamdmachine::VCmpGeF32VccOp>(op))
    makeCompareResultDirect<waveamdmachine::VCmpGeF32Op>(builder, copy,
                                                         compare);
  else
    return false;
  return true;
}

static bool makeCopiedVCCCompareResultDirect(OpBuilder &builder,
                                             Operation *copy,
                                             unsigned wavefrontSize) {
  if (!copy->hasTrait<OpTrait::waveamdmachine::VCCToSGPRCopyOp>())
    return false;
  Value vcc = copy->getOperand(0);
  Operation *compare = vcc.getDefiningOp();
  if (!vcc.hasOneUse() || !compare || !isVCCCompare(compare))
    return false;
  waveamdmachine::RegType resultType =
      cast<waveamdmachine::RegType>(copy->getResult(0).getType());
  if (resultType.getWidth() * 32 != wavefrontSize)
    return false;
  if (makeFloatCompareResultDirect(builder, copy, compare) ||
      makeUnsignedCompareResultDirect(builder, copy, compare) ||
      makeSignedCompareResultDirect(builder, copy, compare))
    return true;
  llvm_unreachable("unhandled VCC compare");
}

static LogicalResult makeCopiedVCCCompareResultsDirect(Operation *root) {
  if (!waveamdmachine::findAMDGPUTargetModule(root))
    return success();
  FailureOr<unsigned> wavefrontSize = waveamdmachine::getAMDGPUWavefrontSize(
      root, "waveamd-scalar-mask-preschedule");
  if (failed(wavefrontSize))
    return failure();
  SmallVector<Operation *> copies;
  root->walk([&](Operation *op) {
    if (op->hasTrait<OpTrait::waveamdmachine::VCCToSGPRCopyOp>())
      copies.push_back(op);
  });
  OpBuilder builder(root->getContext());
  for (Operation *copy : copies)
    makeCopiedVCCCompareResultDirect(builder, copy, *wavefrontSize);
  return success();
}

static void useVCCScalarCompare(Operation *op) {
  if (!isa<waveamdmachine::SCmpEqU64Op, waveamdmachine::SCmpLgU64Op>(op))
    return;
  for (OpOperand &operand : op->getOpOperands()) {
    Value mask = operand.get();
    if (!mask.hasOneUse())
      continue;
    Value vcc = getUnusedVCCResult(mask);
    Operation *compare = vcc ? vcc.getDefiningOp() : nullptr;
    if (!vcc || compare->getBlock() != op->getBlock() ||
        !compare->isBeforeInBlock(op) || hasLiveVCCWriteBetween(compare, op))
      continue;
    operand.set(vcc);
  }
}

static void useVCCExecMask(waveamdmachine::ExecIfOp execIf) {
  Value mask = execIf.getCondition();
  if (!mask.hasOneUse())
    return;
  Value vcc = getUnusedVCCResult(mask);
  if (!vcc)
    return;
  Operation *copy = mask.getDefiningOp();
  if (copy->getNextNode() != execIf)
    return;
  if (!execIf.getElseRegion().empty() &&
      regionWritesVCC(execIf.getThenRegion()))
    return;

  auto maskType = cast<waveamdmachine::RegType>(mask.getType());
  execIf->setAttr("mask_width",
                  IntegerAttr::get(IntegerType::get(execIf.getContext(), 64),
                                   maskType.getWidth() * 32));
  execIf->setOperand(0, vcc);
}

static bool isScalarMaskSinkOp(Operation *op) {
  if (op->hasTrait<OpTrait::waveamdmachine::VCCToSGPRCopyOp>()) {
    Operation *vccDef = op->getOperand(0).getDefiningOp();
    if (!vccDef || !isVCCCompare(vccDef))
      return false;
  }
  if (!isa<waveamdmachine::SCmpEqU32Op, waveamdmachine::SCmpLtU32Op,
           waveamdmachine::SCmpLeU32Op, waveamdmachine::SCmpGtU32Op,
           waveamdmachine::SCmpGeU32Op, waveamdmachine::SCmpEqI32Op,
           waveamdmachine::SCmpLtI32Op, waveamdmachine::SCmpLeI32Op,
           waveamdmachine::SCmpGtI32Op, waveamdmachine::SCmpGeI32Op,
           waveamdmachine::SCmpEqU64Op, waveamdmachine::SCmpLgU64Op>(op) &&
      !isVCCCompare(op) &&
      !op->hasTrait<OpTrait::waveamdmachine::VCCToSGPRCopyOp>())
    return false;
  return llvm::all_of(op->getResults(), [](Value result) {
    auto type = dyn_cast<waveamdmachine::RegType>(result.getType());
    if (!type)
      return false;
    return type.getRegClass() == waveamdmachine::RegClass::SGPR ||
           type.getRegClass() == waveamdmachine::RegClass::SCC ||
           type.getRegClass() == waveamdmachine::RegClass::VCC;
  });
}

static bool collectScalarMaskSinkClosure(Value value, Operation *anchor,
                                         DenseSet<Operation *> &seen,
                                         SmallVectorImpl<Operation *> &ops) {
  Operation *def = value.getDefiningOp();
  if (!def || !isScalarMaskSinkOp(def))
    return true;
  if (def->getBlock() != anchor->getBlock() || !def->isBeforeInBlock(anchor))
    return false;
  if (isVCCCompare(def) && hasLiveVCCWriteBetween(def, anchor))
    return false;
  if (!seen.insert(def).second)
    return true;
  for (Value operand : def->getOperands())
    if (!collectScalarMaskSinkClosure(operand, anchor, seen, ops))
      return false;
  ops.push_back(def);
  return true;
}

static bool hasOnlySinkClosureUses(Operation *op, Operation *anchor,
                                   const DenseSet<Operation *> &closure) {
  return llvm::all_of(op->getResults(), [&](Value result) {
    return llvm::all_of(result.getUsers(), [&](Operation *user) {
      return user == anchor || closure.contains(user);
    });
  });
}

static void sinkScalarMaskClosure(Operation *anchor) {
  DenseSet<Operation *> closure;
  SmallVector<Operation *> ops;
  for (Value operand : anchor->getOperands())
    if (!collectScalarMaskSinkClosure(operand, anchor, closure, ops))
      return;
  if (ops.empty() || !llvm::all_of(ops, [&](Operation *op) {
        return hasOnlySinkClosureUses(op, anchor, closure);
      }))
    return;
  llvm::sort(ops, [](Operation *lhs, Operation *rhs) {
    return lhs->isBeforeInBlock(rhs);
  });
  for (Operation *op : ops)
    op->moveBefore(anchor);
}

static bool hasDmaIssueDelay(func::FuncOp func) {
  return func
      .walk([](waveamdmachine::DmaIssueDelayOp) {
        return WalkResult::interrupt();
      })
      .wasInterrupted();
}

static void collectOps(Operation *root, SmallVectorImpl<Operation *> &ops) {
  root->walk([&](Operation *op) { ops.push_back(op); });
}

static void sinkScalarMasks(Operation *root) {
  SmallVector<Operation *> ops;
  collectOps(root, ops);
  for (Operation *op : ops)
    useVCCScalarCompare(op);
  for (Operation *op : ops)
    sinkScalarMaskClosure(op);
  for (Operation *op : ops)
    if (auto execIf = dyn_cast<waveamdmachine::ExecIfOp>(op))
      useVCCExecMask(execIf);
}

static void eraseDeadVCCCopies(Operation *root) {
  SmallVector<Operation *> ops;
  collectOps(root, ops);
  for (Operation *op : ops)
    if (op->hasTrait<OpTrait::waveamdmachine::VCCToSGPRCopyOp>() &&
        op->getResult(0).use_empty())
      op->erase();
}

struct WaveAMDScalarMaskPreschedulePass
    : public wave::impl::WaveAMDScalarMaskPrescheduleBase<
          WaveAMDScalarMaskPreschedulePass> {
  using WaveAMDScalarMaskPrescheduleBase::WaveAMDScalarMaskPrescheduleBase;

  void runOnOperation() override {
    sinkScalarMasks(getOperation());
    if (failed(makeCopiedVCCCompareResultsDirect(getOperation())))
      return signalPassFailure();
    eraseDeadVCCCopies(getOperation());
  }
};

struct WaveAMDScalarMaskPostSchedulePass
    : public wave::impl::WaveAMDScalarMaskPostScheduleBase<
          WaveAMDScalarMaskPostSchedulePass> {
  using WaveAMDScalarMaskPostScheduleBase::WaveAMDScalarMaskPostScheduleBase;

  void runOnOperation() override {
    SmallVector<func::FuncOp> funcs;
    getOperation()->walk([&](func::FuncOp func) {
      if (hasDmaIssueDelay(func))
        funcs.push_back(func);
    });
    for (func::FuncOp func : funcs) {
      sinkScalarMasks(func);
      eraseDeadVCCCopies(func);
    }
  }
};

} // namespace
