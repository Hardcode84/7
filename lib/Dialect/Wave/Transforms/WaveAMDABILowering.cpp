//===- WaveAMDABILowering.cpp - WaveAMD ABI lowering ------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/Wave/Transforms/Passes.h"

#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/Wave/IR/WaveAMDABI.h"
#include "mlir/Dialect/Wave/Transforms/WaveAMDEntryRegs.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachine.h"
#include "mlir/IR/Builders.h"
#include "mlir/IR/BuiltinOps.h"
#include "llvm/ADT/STLExtras.h"

#include <limits>

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

// Width is SGPR dwords: 1/2/4 map to scalar load width.
static Value createKernArgLoad(OpBuilder &builder, Location loc,
                               Type resultType, Value offsetImm, unsigned width,
                               StringRef base) {
  if (width == 1)
    return waveamdmachine::SLoadB32Op::create(builder, loc, resultType,
                                              offsetImm, base);
  if (width == 2)
    return waveamdmachine::SLoadB64Op::create(builder, loc, resultType,
                                              offsetImm, base);
  return waveamdmachine::SLoadB128Op::create(builder, loc, resultType,
                                             offsetImm, base);
}

static bool isCoveredByPreload(const waveamd::KernargSlot &slot,
                               const wave::WaveAMDKernelEntryRegs &entryRegs) {
  if (entryRegs.kernargPreloadDwords == 0 ||
      entryRegs.kernargPreloadOffsetDwords != 0)
    return false;
  if (slot.offset % 4 != 0 || slot.size % 4 != 0)
    return false;
  unsigned start = slot.offset / 4;
  unsigned width = slot.size / 4;
  return start <= entryRegs.kernargPreloadDwords &&
         width <= entryRegs.kernargPreloadDwords - start;
}

static void applyDefaultKernargPreload(func::FuncOp func, OpBuilder &builder) {
  if (func->hasAttr(wave::getWaveAMDKernargPreloadLengthAttrName()) ||
      func->hasAttr(wave::getWaveAMDKernargPreloadOffsetAttrName()))
    return;
  unsigned preloadDwords = wave::getWaveAMDDefaultKernargPreloadDwords(func);
  if (preloadDwords == 0)
    return;
  func->setAttr(wave::getWaveAMDKernargPreloadLengthAttrName(),
                builder.getI64IntegerAttr(preloadDwords));
}

static Value
createKernargPreload(OpBuilder &builder, Location loc,
                     waveamdmachine::RegType regType,
                     const waveamd::KernargSlot &slot,
                     const wave::WaveAMDKernelEntryRegs &entryRegs) {
  unsigned dwordOffset = slot.offset / 4;
  unsigned physIndex = entryRegs.kernargSegmentPtrWidth + dwordOffset;
  waveamdmachine::RegType pinnedType = waveamdmachine::RegType::get(
      builder.getContext(), waveamdmachine::RegClass::SGPR, regType.getWidth(),
      physIndex);
  return waveamdmachine::KernargPreloadOp::create(builder, loc, pinnedType,
                                                  dwordOffset);
}

static bool isUniformLoopInit(OpOperand &use) {
  waveamdmachine::UniformLoopOp loop =
      dyn_cast<waveamdmachine::UniformLoopOp>(use.getOwner());
  if (!loop)
    return false;
  unsigned initBegin = loop.getEntryCond() ? 1 : 0;
  return use.getOperandNumber() >= initBegin;
}

static Value createVirtualSGPRCopy(OpBuilder &builder, Location loc,
                                   waveamdmachine::RegType type, Value source) {
  if (type.getWidth() == 1)
    return waveamdmachine::SMovB32ValueOp::create(builder, loc, type, source);
  return waveamdmachine::SMovB32TupleOp::create(builder, loc, type, source);
}

static bool hasDmaIssueDelay(func::FuncOp func) {
  return func
      .walk([](waveamdmachine::DmaIssueDelayOp) {
        return WalkResult::interrupt();
      })
      .wasInterrupted();
}

static void replaceArgUses(Operation &op, waveamdmachine::RegType regType,
                           Value loaded, OpBuilder &builder,
                           bool copyLoopInits) {
  Value arg = op.getResult(0);
  Value loopInit = loaded;
  if (copyLoopInits && loaded.getType() != arg.getType() &&
      llvm::any_of(arg.getUses(), isUniformLoopInit))
    loopInit = createVirtualSGPRCopy(builder, op.getLoc(), regType, loaded);
  for (OpOperand &use : llvm::make_early_inc_range(arg.getUses()))
    use.set(isUniformLoopInit(use) ? loopInit : loaded);
  op.erase();
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
    if (!waveamd::isValidKernargRegisterWidth(isPointer, width))
      return op.emitError(
          "waveamd-abi-lowering found argument register width inconsistent "
          "with pointer attribute");
    return std::make_pair(regType, isPointer);
  }

  static FailureOr<unsigned> getArgIndex(Operation &op) {
    auto argOp = cast<waveamdmachine::ArgOp>(&op);
    int64_t index = argOp.getIndex();
    if (index < 0)
      return op.emitError("waveamd-abi-lowering found negative arg index");
    if (index > std::numeric_limits<unsigned>::max())
      return op.emitError("waveamd-abi-lowering found arg index too large");
    return static_cast<unsigned>(index);
  }

  static LogicalResult lowerArgOp(Operation &op,
                                  ArrayRef<waveamd::KernargSlot> layout,
                                  TypeRange argTypes,
                                  const wave::WaveAMDKernelEntryRegs &entryRegs,
                                  OpBuilder &builder, bool copyLoopInits) {
    auto info = validateArgOp(op);
    if (failed(info))
      return failure();
    auto [regType, isPointer] = *info;

    FailureOr<unsigned> index = getArgIndex(op);
    if (failed(index))
      return failure();
    if (*index >= layout.size())
      return op.emitError("waveamd-abi-lowering found arg index outside "
                          "function argument list");

    Type sourceType = argTypes[*index];
    if (isPointer != waveamd::isKernargPointer(sourceType))
      return op.emitError(
          "waveamd-abi-lowering found pointer attribute inconsistent "
          "with source argument type");
    unsigned byteSize =
        waveamd::getKernargByteSizeForRegisterWidth(regType.getWidth());
    waveamd::KernargSlot slot = layout[*index];
    if (byteSize != slot.size)
      return op.emitError(
          "waveamd-abi-lowering found register width inconsistent with source "
          "argument type");

    builder.setInsertionPoint(&op);
    Value loaded;
    if (isCoveredByPreload(slot, entryRegs)) {
      loaded =
          createKernargPreload(builder, op.getLoc(), regType, slot, entryRegs);
    } else {
      Value offsetImm = createImm(builder, op.getLoc(), slot.offset);
      std::string base = wave::getWaveAMDSGPRName(
          entryRegs.kernargSegmentPtrSGPR, entryRegs.kernargSegmentPtrWidth);
      loaded =
          createKernArgLoad(builder, op.getLoc(), op.getResult(0).getType(),
                            offsetImm, regType.getWidth(), base);
    }
    replaceArgUses(op, regType, loaded, builder, copyLoopInits);
    return success();
  }

  static LogicalResult lowerKernel(func::FuncOp func, OpBuilder &builder) {
    TypeRange argTypes = func.getFunctionType().getInputs();
    SmallVector<waveamd::KernargSlot> layout =
        waveamd::getKernargLayout(argTypes);
    applyDefaultKernargPreload(func, builder);
    if (failed(wave::verifyWaveAMDKernargPreloadTarget(func,
                                                       "waveamd-abi-lowering")))
      return failure();
    wave::WaveAMDKernelEntryRegs entryRegs =
        wave::getWaveAMDKernelEntryRegs(func);
    bool copyLoopInits = hasDmaIssueDelay(func);
    for (Operation &op : llvm::make_early_inc_range(func.getBody().front())) {
      if (!isa<waveamdmachine::ArgOp>(op))
        continue;
      if (failed(lowerArgOp(op, layout, argTypes, entryRegs, builder,
                            copyLoopInits)))
        return failure();
    }
    unsigned kernargSize = waveamd::getKernargSegmentSize(argTypes);
    func->setAttr("waveamdmachine.kernarg_size",
                  builder.getI64IntegerAttr(kernargSize));
    return success();
  }
};

} // namespace
