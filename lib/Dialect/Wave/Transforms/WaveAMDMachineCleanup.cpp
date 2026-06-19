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

static bool touchesHardwareResource(Operation *op) {
  HardwareResourceEffects effects = getHardwareResourceEffects(op);
  return !effects.reads.empty() || !effects.writes.empty();
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
  if (!isa<ImmOp>(op) && !op->hasTrait<traits::VALUOp>())
    return false;
  return true;
}

static bool hasHoistableSemantics(Operation *op) {
  if (!isMemoryEffectFree(op) || !isSpeculatable(op))
    return false;
  return !touchesHardwareResource(op);
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

struct WaveAMDMachineCleanupPass
    : public wave::impl::WaveAMDMachineCleanupBase<WaveAMDMachineCleanupPass> {
  void runOnOperation() override {
    getOperation()->walk([&](func::FuncOp func) {
      bool changed = true;
      while (changed)
        changed = hoistFunction(func);
    });
  }
};
} // namespace
