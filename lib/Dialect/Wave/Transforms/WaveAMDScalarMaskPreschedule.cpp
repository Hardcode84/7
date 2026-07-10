//===- WaveAMDScalarMaskPreschedule.cpp - scalar mask sinking ------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/Wave/Transforms/Passes.h"

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
  }
};

} // namespace
