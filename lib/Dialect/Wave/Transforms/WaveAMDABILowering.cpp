//===- WaveAMDABILowering.cpp - WaveAMD ABI lowering ------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/Wave/Transforms/Passes.h"

#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/WaveMachine/IR/WaveMachine.h"
#include "mlir/IR/Builders.h"
#include "mlir/IR/BuiltinOps.h"
#include "llvm/ADT/STLExtras.h"

namespace mlir::wave {
#define GEN_PASS_DEF_WAVEAMDABILOWERING
#include "mlir/Dialect/Wave/Transforms/Passes.h.inc"
} // namespace mlir::wave

using namespace mlir;

namespace {

static wavemachine::ImmType getImmType(MLIRContext *ctx) {
  return wavemachine::ImmType::get(ctx);
}

static Operation *createWMOp(OpBuilder &builder, Location loc, StringRef name,
                             ValueRange operands, TypeRange resultTypes,
                             ArrayRef<NamedAttribute> attrs = {}) {
  OperationState state(loc, ("wavemachine." + name).str());
  state.addOperands(operands);
  state.addTypes(resultTypes);
  state.addAttributes(attrs);
  return builder.create(state);
}

static Value createImm(OpBuilder &builder, Location loc, int64_t value) {
  Operation *op = createWMOp(
      builder, loc, "imm", {}, getImmType(builder.getContext()),
      {builder.getNamedAttr("value", builder.getI64IntegerAttr(value))});
  return op->getResult(0);
}

static Value createInstr(OpBuilder &builder, Location loc, StringRef name,
                         ValueRange operands, Type resultType,
                         ArrayRef<NamedAttribute> attrs = {}) {
  Operation *op = createWMOp(builder, loc, name, operands, resultType, attrs);
  return op->getResult(0);
}

static bool isSGPR(wavemachine::RegType type) {
  return type.getRegClass() == wavemachine::RegClass::SGPR;
}

struct WaveAMDABILoweringPass
    : public wave::impl::WaveAMDABILoweringBase<WaveAMDABILoweringPass> {
  void runOnOperation() override {
    ModuleOp module = getOperation();
    OpBuilder builder(module.getContext());
    for (func::FuncOp func : module.getOps<func::FuncOp>())
      if (func->hasAttr("wave.kernel") && failed(lowerKernel(func, builder)))
        return signalPassFailure();
  }

private:
  // Verify operand shape constraints and extract the (regType, isPointer)
  // pair we need to emit the load.
  static FailureOr<std::pair<wavemachine::RegType, bool>>
  validateArgOp(Operation &op) {
    if (op.getNumResults() != 1)
      return op.emitError(
          "waveamd-abi-lowering expects wavemachine.arg to have one result");
    auto regType = dyn_cast<wavemachine::RegType>(op.getResult(0).getType());
    if (!regType || !isSGPR(regType))
      return op.emitError(
          "waveamd-abi-lowering expects kernel arguments to be SGPR "
          "WaveMachine registers");
    auto pointerAttr = op.getAttrOfType<BoolAttr>("pointer");
    if (!pointerAttr)
      return op.emitError(
          "waveamd-abi-lowering expects wavemachine.arg to have a pointer "
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

  // Pick the scalar load opcode for an argument of width `width`.
  static StringRef pickLoadOpcode(unsigned width, bool isPointer) {
    if (!isPointer)
      return "s_load_b32";
    return width == 4 ? "s_load_b128" : "s_load_b64";
  }

  // Validate and lower a single `wavemachine.arg` op into an `s_load_*`
  // sequence at offset `offset`. On success returns the number of bytes
  // consumed for this argument's kernarg slot.
  static FailureOr<unsigned> lowerArgOp(Operation &op, unsigned offset,
                                        OpBuilder &builder) {
    auto info = validateArgOp(op);
    if (failed(info))
      return failure();
    auto [regType, isPointer] = *info;

    builder.setInsertionPoint(&op);
    Value offsetImm = createImm(builder, op.getLoc(), offset);
    StringRef opcode = pickLoadOpcode(regType.getWidth(), isPointer);
    Value loaded = createInstr(
        builder, op.getLoc(), opcode, offsetImm, op.getResult(0).getType(),
        {builder.getNamedAttr("base", builder.getStringAttr("s[0:1]"))});
    op.getResult(0).replaceAllUsesWith(loaded);
    op.erase();
    return isPointer ? regType.getWidth() * 4u : 4u;
  }

  static LogicalResult lowerKernel(func::FuncOp func, OpBuilder &builder) {
    unsigned offset = 0;
    for (Operation &op : llvm::make_early_inc_range(func.getBody().front())) {
      if (!isa<wavemachine::ArgOp>(op))
        continue;
      auto consumed = lowerArgOp(op, offset, builder);
      if (failed(consumed))
        return failure();
      offset += *consumed;
    }
    unsigned kernargSize = (std::max(offset, 4u) + 7u) & ~7u;
    func->setAttr("wavemachine.kernarg_size",
                  builder.getI64IntegerAttr(kernargSize));
    return success();
  }
};

} // namespace
