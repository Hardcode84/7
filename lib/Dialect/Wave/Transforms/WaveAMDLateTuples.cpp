//===- WaveAMDLateTuples.cpp - sink machine tuples -------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/Wave/Transforms/Passes.h"

#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachine.h"
#include "mlir/IR/Operation.h"
#include "mlir/IR/ValueRange.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/ADT/SmallVector.h"

namespace mlir::wave {
#define GEN_PASS_DEF_WAVEAMDLATETUPLES
#include "mlir/Dialect/Wave/Transforms/Passes.h.inc"
} // namespace mlir::wave

using namespace mlir;

namespace {

struct SinkTarget {
  Operation *op = nullptr;
  bool valid = true;
};

static SinkTarget getSinkTarget(Operation *op, ValueRange values) {
  Block *block = op->getBlock();
  Operation *target = nullptr;

  for (Value value : values) {
    for (Operation *user : value.getUsers()) {
      if (user == op)
        continue;
      if (user->getBlock() != block || !op->isBeforeInBlock(user))
        return {nullptr, false};
      if (!target || user->isBeforeInBlock(target))
        target = user;
    }
  }

  return {target, true};
}

static bool sinkBeforeEarliestUser(Operation *op) {
  SinkTarget target = getSinkTarget(op, op->getResults());
  if (!target.valid || !target.op || op->getNextNode() == target.op)
    return false;
  op->moveBefore(target.op);
  return true;
}

struct WaveAMDLateTuplesPass
    : public wave::impl::WaveAMDLateTuplesBase<WaveAMDLateTuplesPass> {
  void runOnOperation() override {
    SmallVector<Operation *> tuples;
    getOperation()->walk([&](Operation *op) {
      if (isa<waveamdmachine::TupleToElementsOp,
              waveamdmachine::TupleFromElementsOp>(op))
        tuples.push_back(op);
    });

    for (Operation *op : llvm::reverse(tuples))
      sinkBeforeEarliestUser(op);
  }
};

} // namespace
