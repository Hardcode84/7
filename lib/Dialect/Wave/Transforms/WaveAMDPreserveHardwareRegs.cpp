//===- WaveAMDPreserveHardwareRegs.cpp - Singleton register preservation --===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/Wave/Transforms/Passes.h"

#include "WaveAMDHardwareResources.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachine.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachineTarget.h"
#include "mlir/IR/Builders.h"
#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/DenseSet.h"
#include "llvm/ADT/STLExtras.h"

#include <array>

namespace mlir::wave {
#define GEN_PASS_DEF_WAVEAMDPRESERVEHARDWAREREGS
#include "mlir/Dialect/Wave/Transforms/Passes.h.inc"
} // namespace mlir::wave

using namespace mlir;

namespace {

static unsigned resourceIndex(wave::HardwareResourceKind kind) {
  return static_cast<unsigned>(kind);
}

static waveamdmachine::RegType getSGPR1Type(MLIRContext *ctx) {
  return waveamdmachine::RegType::get(ctx, waveamdmachine::RegClass::SGPR, 1,
                                      -1);
}

static waveamdmachine::RegType getSCCType(MLIRContext *ctx) {
  return waveamdmachine::RegType::get(ctx, waveamdmachine::RegClass::SCC, 1,
                                      -1);
}

static waveamdmachine::RegType getVCCType(MLIRContext *ctx) {
  return waveamdmachine::RegType::get(ctx, waveamdmachine::RegClass::VCC, 1,
                                      -1);
}

static waveamdmachine::ImmOp createImm(OpBuilder &builder, Location loc,
                                       uint64_t value) {
  return waveamdmachine::ImmOp::create(
      builder, loc, waveamdmachine::ImmType::get(builder.getContext()), value);
}

static FailureOr<Value> failureWithError(Operation *op, StringRef message) {
  op->emitError() << message;
  return failure();
}

static SmallVector<wave::HardwareResourceKind, 4>
getWrittenResources(Operation *op) {
  return wave::getHardwareResourceEffects(op).writes;
}

struct ResourceBlockInfo {
  SmallVector<Operation *> ops;
  DenseMap<Operation *, unsigned> positions;
  DenseMap<Value, unsigned> lastUse;
  DenseSet<Value> definedInBlock;
};

static void noteUse(Value value, Operation *owner, ResourceBlockInfo &info) {
  if (!wave::getHardwareResourceForValue(value))
    return;
  DenseMap<Operation *, unsigned>::iterator it = info.positions.find(owner);
  if (it == info.positions.end())
    return;
  unsigned &last = info.lastUse[value];
  last = std::max(last, it->second);
}

static void noteResultUses(Operation *op, ResourceBlockInfo &info) {
  for (Value result : op->getResults()) {
    if (!wave::getHardwareResourceForValue(result))
      continue;
    info.definedInBlock.insert(result);
    for (OpOperand &use : result.getUses()) {
      DenseMap<Operation *, unsigned>::iterator it =
          info.positions.find(use.getOwner());
      unsigned index =
          it == info.positions.end() ? info.ops.size() : it->second;
      unsigned &last = info.lastUse[result];
      last = std::max(last, index);
    }
  }
}

static ResourceBlockInfo collectBlockInfo(Block &block) {
  ResourceBlockInfo info;
  for (auto [index, op] : llvm::enumerate(block)) {
    info.ops.push_back(&op);
    info.positions[&op] = index;
  }
  for (Operation *op : info.ops)
    for (Value operand : op->getOperands())
      noteUse(operand, op, info);
  for (Operation *op : info.ops)
    noteResultUses(op, info);
  return info;
}

static Value getResultForResource(Operation *op,
                                  wave::HardwareResourceKind kind) {
  for (Value result : op->getResults()) {
    std::optional<wave::HardwareResourceKind> resultKind =
        wave::getHardwareResourceForValue(result);
    if (resultKind == kind)
      return result;
  }
  return {};
}

class BlockPreserver {
public:
  BlockPreserver(Block &block, unsigned wavefrontSize)
      : builder(block.getParentOp()->getContext()),
        info(collectBlockInfo(block)), wavefrontSize(wavefrontSize) {}

  LogicalResult run() {
    initializeLiveIn();
    for (auto [index, op] : llvm::enumerate(info.ops)) {
      currentIndex = index;
      if (failed(ensureOperandsAvailable(op)))
        return failure();
      retireOperands(op, index);
      if (failed(handleWrites(op)))
        return failure();
      trackResults(op, index);
    }
    return success();
  }

private:
  void initializeLiveIn() {
    for (const std::pair<Value, unsigned> &entry : info.lastUse) {
      Value value = entry.first;
      if (info.definedInBlock.contains(value))
        continue;
      std::optional<wave::HardwareResourceKind> kind =
          wave::getHardwareResourceForValue(value);
      if (!kind)
        continue;
      current[resourceIndex(*kind)] = value;
    }
  }

  LogicalResult ensureOperandsAvailable(Operation *op) {
    for (OpOperand &operand : llvm::make_early_inc_range(op->getOpOperands())) {
      std::optional<wave::HardwareResourceKind> kind =
          wave::getHardwareResourceForValue(operand.get());
      if (!kind)
        continue;
      if (!saved.contains(operand.get()))
        continue;
      if (failed(reloadValue(operand.get(), *kind, op)))
        return failure();
    }
    return success();
  }

  void retireOperands(Operation *op, unsigned index) {
    for (Value operand : op->getOperands()) {
      std::optional<wave::HardwareResourceKind> kind =
          wave::getHardwareResourceForValue(operand);
      if (!kind || info.lastUse.lookup(operand) != index)
        continue;
      unsigned slot = resourceIndex(*kind);
      if (current[slot] == operand)
        current[slot] = {};
      saved.erase(operand);
    }
  }

  LogicalResult handleWrites(Operation *op) {
    for (wave::HardwareResourceKind kind : getWrittenResources(op)) {
      if (kind == wave::HardwareResourceKind::EXEC)
        continue;
      unsigned slot = resourceIndex(kind);
      if (current[slot] && failed(spillValue(current[slot], kind, op)))
        return failure();
      current[slot] = {};
    }
    return success();
  }

  void trackResults(Operation *op, unsigned index) {
    for (wave::HardwareResourceKind kind : getWrittenResources(op)) {
      Value result = getResultForResource(op, kind);
      if (!result || info.lastUse.lookup(result) <= index)
        continue;
      current[resourceIndex(kind)] = result;
    }
  }

  LogicalResult spillValue(Value value, wave::HardwareResourceKind kind,
                           Operation *before) {
    if (info.lastUse.lookup(value) < currentIndex)
      return success();
    if (saved.contains(value))
      return success();
    FailureOr<Value> slot = createSave(value, kind, before);
    if (failed(slot))
      return failure();
    saved[value] = *slot;
    return success();
  }

  FailureOr<Value> createSave(Value value, wave::HardwareResourceKind kind,
                              Operation *before) {
    builder.setInsertionPoint(before);
    Location loc = before->getLoc();
    MLIRContext *ctx = builder.getContext();
    if (kind == wave::HardwareResourceKind::SCC) {
      waveamdmachine::ImmOp one = createImm(builder, loc, 1);
      waveamdmachine::ImmOp zero = createImm(builder, loc, 0);
      return waveamdmachine::SCSelectB32Op::create(
                 builder, loc, getSGPR1Type(ctx), value, one.getResult(),
                 zero.getResult())
          .getResult();
    }
    if (kind == wave::HardwareResourceKind::VCC) {
      if (wavefrontSize != 32)
        return failureWithError(
            before, "waveamd-preserve-hw-regs supports VCC preservation only "
                    "for wave32");
      return waveamdmachine::SReadVccB32Op::create(builder, loc,
                                                   getSGPR1Type(ctx), value)
          .getResult();
    }
    if (kind == wave::HardwareResourceKind::M0) {
      Operation *def = value.getDefiningOp();
      waveamdmachine::SMovM0Op mov =
          dyn_cast_or_null<waveamdmachine::SMovM0Op>(def);
      if (!mov)
        return failureWithError(before,
                                "waveamd-preserve-hw-regs cannot preserve M0 "
                                "without an s_mov_m0 source");
      return mov.getSource();
    }
    before->emitError("waveamd-preserve-hw-regs cannot preserve ")
        << wave::getHardwareResourceName(kind);
    return failure();
  }

  LogicalResult reloadValue(Value value, wave::HardwareResourceKind kind,
                            Operation *before) {
    unsigned slot = resourceIndex(kind);
    if (current[slot] && current[slot] != value)
      if (failed(spillValue(current[slot], kind, before)))
        return failure();

    DenseMap<Value, Value>::iterator saveIt = saved.find(value);
    if (saveIt == saved.end())
      return success();
    FailureOr<Value> reloaded = createReload(saveIt->second, kind, before);
    if (failed(reloaded))
      return failure();

    unsigned oldLastUse = info.lastUse.lookup(value);
    info.lastUse[*reloaded] = oldLastUse;
    replaceFutureUses(value, *reloaded, currentIndex);
    saved.erase(saveIt);
    current[slot] = *reloaded;
    return success();
  }

  FailureOr<Value> createReload(Value slot, wave::HardwareResourceKind kind,
                                Operation *before) {
    builder.setInsertionPoint(before);
    Location loc = before->getLoc();
    MLIRContext *ctx = builder.getContext();
    if (kind == wave::HardwareResourceKind::SCC) {
      waveamdmachine::ImmOp zero = createImm(builder, loc, 0);
      return waveamdmachine::SCmpLgU32Op::create(builder, loc, getSCCType(ctx),
                                                 slot, zero.getResult())
          .getResult();
    }
    if (kind == wave::HardwareResourceKind::VCC)
      return waveamdmachine::SMovVccB32Op::create(builder, loc, getVCCType(ctx),
                                                  slot)
          .getResult();
    if (kind == wave::HardwareResourceKind::M0)
      return waveamdmachine::SMovM0Op::create(
                 builder, loc, waveamdmachine::M0Type::get(ctx), slot)
          .getResult();
    before->emitError("waveamd-preserve-hw-regs cannot reload ")
        << wave::getHardwareResourceName(kind);
    return failure();
  }

  void replaceFutureUses(Value oldValue, Value newValue, unsigned index) {
    for (OpOperand &use : llvm::make_early_inc_range(oldValue.getUses())) {
      DenseMap<Operation *, unsigned>::iterator it =
          info.positions.find(use.getOwner());
      if (it == info.positions.end() || it->second < index)
        continue;
      use.set(newValue);
    }
  }

  OpBuilder builder;
  ResourceBlockInfo info;
  std::array<Value, 4> current = {};
  DenseMap<Value, Value> saved;
  unsigned wavefrontSize = 32;
  unsigned currentIndex = 0;
};

static LogicalResult preserveBlock(Block &block, unsigned wavefrontSize) {
  BlockPreserver preserver(block, wavefrontSize);
  return preserver.run();
}

static LogicalResult preserveRegion(Region &region, unsigned wavefrontSize) {
  for (Block &block : region) {
    if (failed(preserveBlock(block, wavefrontSize)))
      return failure();
    for (Operation &op : block)
      for (Region &nested : op.getRegions())
        if (failed(preserveRegion(nested, wavefrontSize)))
          return failure();
  }
  return success();
}

struct WaveAMDPreserveHardwareRegsPass
    : public wave::impl::WaveAMDPreserveHardwareRegsBase<
          WaveAMDPreserveHardwareRegsPass> {
  using WaveAMDPreserveHardwareRegsBase::WaveAMDPreserveHardwareRegsBase;

  void runOnOperation() override {
    WalkResult result = getOperation()->walk([&](func::FuncOp func) {
      if (func.isExternal())
        return WalkResult::advance();
      FailureOr<unsigned> wavefrontSize =
          waveamdmachine::getAMDGPUDefaultWavefrontSize(
              func, "waveamd-preserve-hw-regs");
      if (failed(wavefrontSize))
        return WalkResult::interrupt();
      if (failed(preserveRegion(func.getBody(), *wavefrontSize)))
        return WalkResult::interrupt();
      return WalkResult::advance();
    });
    if (result.wasInterrupted())
      return signalPassFailure();
  }
};

} // namespace
