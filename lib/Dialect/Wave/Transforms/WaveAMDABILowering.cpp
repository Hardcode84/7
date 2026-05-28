//===- WaveAMDABILowering.cpp - WaveAMD ABI lowering ------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/Wave/Transforms/Passes.h"

#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachine.h"
#include "mlir/IR/Builders.h"
#include "mlir/IR/BuiltinOps.h"
#include "llvm/ADT/STLExtras.h"

namespace mlir::wave {
#define GEN_PASS_DEF_WAVEAMDABILOWERING
#include "mlir/Dialect/Wave/Transforms/Passes.h.inc"
} // namespace mlir::wave

using namespace mlir;

namespace {

static Value createImm(OpBuilder &builder, Location loc, int64_t value) {
  return waveamdmachine::ImmOp::create(
      builder, loc, waveamdmachine::ImmType::get(builder.getContext()),
      static_cast<uint64_t>(value));
}

static bool isSGPR(waveamdmachine::RegType type) {
  return type.getRegClass() == waveamdmachine::RegClass::SGPR;
}

// Pick the typed scalar-load op for an `arg` slot. SLoad{32,64,128}
// all share the same shape (offset operand + base string attr), so we
// dispatch on width and build via the matching op's typed constructor.
static Value createKernArgLoad(OpBuilder &builder, Location loc,
                               Type resultType, Value offsetImm, unsigned width,
                               bool isPointer, StringRef base) {
  if (!isPointer)
    return waveamdmachine::SLoadB32Op::create(builder, loc, resultType,
                                              offsetImm, base);
  if (width == 4)
    return waveamdmachine::SLoadB128Op::create(builder, loc, resultType,
                                               offsetImm, base);
  return waveamdmachine::SLoadB64Op::create(builder, loc, resultType, offsetImm,
                                            base);
}

struct WaveAMDABILoweringPass
    : public wave::impl::WaveAMDABILoweringBase<WaveAMDABILoweringPass> {
  void runOnOperation() override {
    Operation *root = getOperation();
    OpBuilder builder(root->getContext());
    SmallVector<func::FuncOp> kernels;
    root->walk([&](func::FuncOp f) {
      if (f->hasAttr(wave::WaveDialect::getKernelAttrName()))
        kernels.push_back(f);
    });
    // ABI lowering only touches wave kernels; host funcs (memref-shaped
    // entry points, runtime helpers) keep their original signatures.
    for (func::FuncOp func : kernels)
      if (failed(lowerKernel(func, builder)))
        return signalPassFailure();
  }

private:
  // Verify operand shape constraints and extract the (regType, isPointer)
  // pair we need to emit the load.
  static FailureOr<std::pair<waveamdmachine::RegType, bool>>
  validateArgOp(Operation &op) {
    if (op.getNumResults() != 1)
      return op.emitError(
          "waveamd-abi-lowering expects waveamdmachine.arg to have one result");
    auto regType = dyn_cast<waveamdmachine::RegType>(op.getResult(0).getType());
    if (!regType || !isSGPR(regType))
      return op.emitError(
          "waveamd-abi-lowering expects kernel arguments to be SGPR "
          "WaveAMDMachine registers");
    auto pointerAttr = op.getAttrOfType<BoolAttr>("pointer");
    if (!pointerAttr)
      return op.emitError(
          "waveamd-abi-lowering expects waveamdmachine.arg to have a pointer "
          "attribute");
    bool isPointer = pointerAttr.getValue();
    unsigned width = regType.getWidth();
    bool widthOk = isPointer ? (width == 2 || width == 4) : (width == 1);
    if (!widthOk)
      return op.emitError(
          "waveamd-abi-lowering found argument register width inconsistent "
          "with pointer attribute");
    return std::make_pair(regType, isPointer);
  }

  // Validate and lower a single `waveamdmachine.arg` op into the matching
  // `s_load_*` op at offset `offset`. On success returns the number of
  // bytes consumed for this argument's kernarg slot.
  static FailureOr<unsigned> lowerArgOp(Operation &op, unsigned offset,
                                        OpBuilder &builder) {
    auto info = validateArgOp(op);
    if (failed(info))
      return failure();
    auto [regType, isPointer] = *info;

    builder.setInsertionPoint(&op);
    Value offsetImm = createImm(builder, op.getLoc(), offset);
    Value loaded =
        createKernArgLoad(builder, op.getLoc(), op.getResult(0).getType(),
                          offsetImm, regType.getWidth(), isPointer, "s[0:1]");
    op.getResult(0).replaceAllUsesWith(loaded);
    op.erase();
    return isPointer ? regType.getWidth() * 4u : 4u;
  }

  static LogicalResult lowerKernel(func::FuncOp func, OpBuilder &builder) {
    unsigned offset = 0;
    for (Operation &op : llvm::make_early_inc_range(func.getBody().front())) {
      if (!isa<waveamdmachine::ArgOp>(op))
        continue;
      auto consumed = lowerArgOp(op, offset, builder);
      if (failed(consumed))
        return failure();
      offset += *consumed;
    }
    unsigned kernargSize = (std::max(offset, 4u) + 7u) & ~7u;
    func->setAttr("waveamdmachine.kernarg_size",
                  builder.getI64IntegerAttr(kernargSize));
    return success();
  }
};

} // namespace
