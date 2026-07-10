//===- WaveAMDScalarMaskPreschedule.cpp - scalar mask sinking ------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/Wave/Transforms/Passes.h"

#include "WaveAMDHardwareResources.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachine.h"
#include "llvm/ADT/DenseSet.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/ADT/SmallVector.h"

namespace mlir::wave {
#define GEN_PASS_DEF_WAVEAMDSCALARMASKPRESCHEDULE
#include "mlir/Dialect/Wave/Transforms/Passes.h.inc"
} // namespace mlir::wave

using namespace mlir;

namespace {

static bool isVCCCompare(Operation *op) {
  return isa<waveamdmachine::VCmpEqU32VccOp, waveamdmachine::VCmpNeU32VccOp,
             waveamdmachine::VCmpLtU32VccOp, waveamdmachine::VCmpLeU32VccOp,
             waveamdmachine::VCmpGtU32VccOp, waveamdmachine::VCmpGeU32VccOp,
             waveamdmachine::VCmpLtI32VccOp, waveamdmachine::VCmpLeI32VccOp,
             waveamdmachine::VCmpGtI32VccOp, waveamdmachine::VCmpGeI32VccOp>(
      op);
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
  Operation *compare = mask.getDefiningOp();
  if (!compare || !isVCCCompare(compare) || compare->getResult(0) != mask)
    return {};
  Value vcc = compare->getResult(1);
  return vcc.use_empty() ? vcc : Value();
}

static void useVCCExecMask(waveamdmachine::ExecIfOp execIf) {
  Value mask = execIf.getCondition();
  if (!mask.hasOneUse())
    return;
  Value vcc = getUnusedVCCResult(mask);
  if (!vcc)
    return;
  Operation *compare = mask.getDefiningOp();
  if (compare->getNextNode() != execIf)
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
  if (!isa<waveamdmachine::SCmpEqU32Op, waveamdmachine::SCmpLtU32Op,
           waveamdmachine::SCmpLeU32Op, waveamdmachine::SCmpGtU32Op,
           waveamdmachine::SCmpGeU32Op, waveamdmachine::SCmpEqI32Op,
           waveamdmachine::SCmpLtI32Op, waveamdmachine::SCmpLeI32Op,
           waveamdmachine::SCmpGtI32Op, waveamdmachine::SCmpGeI32Op,
           waveamdmachine::VCmpEqU32VccOp, waveamdmachine::VCmpNeU32VccOp,
           waveamdmachine::VCmpLtU32VccOp, waveamdmachine::VCmpLeU32VccOp,
           waveamdmachine::VCmpGtU32VccOp, waveamdmachine::VCmpGeU32VccOp,
           waveamdmachine::VCmpLtI32VccOp, waveamdmachine::VCmpLeI32VccOp,
           waveamdmachine::VCmpGtI32VccOp, waveamdmachine::VCmpGeI32VccOp>(op))
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

struct WaveAMDScalarMaskPreschedulePass
    : public wave::impl::WaveAMDScalarMaskPrescheduleBase<
          WaveAMDScalarMaskPreschedulePass> {
  void runOnOperation() override {
    SmallVector<Operation *> ops;
    getOperation()->walk([&](Operation *op) { ops.push_back(op); });
    for (Operation *op : ops)
      sinkScalarMaskClosure(op);
    for (Operation *op : ops)
      if (auto execIf = dyn_cast<waveamdmachine::ExecIfOp>(op))
        useVCCExecMask(execIf);
  }
};

} // namespace
