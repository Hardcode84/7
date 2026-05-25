//===- WaveAMDMachineSchedule.cpp - WaveAMDMachine scheduler ----*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/Wave/Transforms/Passes.h"

#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachine.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachineTraits.h"
#include "mlir/IR/BuiltinOps.h"
#include "mlir/IR/Operation.h"
#include "mlir/Interfaces/SideEffectInterfaces.h"
#include "llvm/Support/raw_ostream.h"

namespace mlir::wave {
#define GEN_PASS_DEF_WAVEAMDMACHINESCHEDULE
#include "mlir/Dialect/Wave/Transforms/Passes.h.inc"
} // namespace mlir::wave

using namespace mlir;

namespace {

namespace traits = ::mlir::OpTrait::waveamdmachine;

struct ScheduleRegion {
  func::FuncOp func;
  unsigned blockOrdinal = 0;
  unsigned regionOrdinal = 0;
  Operation *first = nullptr;
  Operation *last = nullptr;
  unsigned opCount = 0;
};

static bool isWaveAMDMachineOp(Operation *op) {
  return op->getName().getDialectNamespace() ==
         waveamdmachine::WaveAMDMachineDialect::getDialectNamespace();
}

static bool isKnownMemoryOp(Operation *op) {
  return op->hasTrait<traits::SMEMLoadOp>() ||
         op->hasTrait<traits::VMEMLoadOp>() ||
         op->hasTrait<traits::VMEMStoreOp>();
}

static bool hasUnknownMemoryEffects(Operation *op) {
  if (isKnownMemoryOp(op))
    return false;
  MemoryEffectOpInterface iface = dyn_cast<MemoryEffectOpInterface>(op);
  if (!iface)
    return false;
  SmallVector<MemoryEffects::EffectInstance> effects;
  iface.getEffects(effects);
  return !effects.empty();
}

static bool isHardBoundary(Operation *op) {
  if (!isWaveAMDMachineOp(op))
    return true;
  if (op->hasTrait<OpTrait::IsTerminator>())
    return true;
  if (op->getNumRegions() != 0)
    return true;
  if (op->hasTrait<traits::WaitcntOp>())
    return true;
  if (isa<waveamdmachine::LabelOp, waveamdmachine::SBarrierOp,
          waveamdmachine::SSetprioOp, waveamdmachine::SCBranchExeczOp,
          waveamdmachine::SCBranchScc0Op, waveamdmachine::SCBranchScc1Op,
          waveamdmachine::SGetregShaderCyclesOp, waveamdmachine::SNopOp,
          waveamdmachine::SDelayAluOp, waveamdmachine::SAndSaveexecB32Op,
          waveamdmachine::SAndn2ExecB32Op, waveamdmachine::SMovExecLoOp,
          waveamdmachine::SEndpgmOp, waveamdmachine::SSetpcB64Op>(op))
    return true;
  return hasUnknownMemoryEffects(op);
}

class RegionCollector {
public:
  explicit RegionCollector(func::FuncOp func) : func(func) {}

  SmallVector<ScheduleRegion> collect() {
    for (Block &block : func.getBody())
      collectBlock(block);
    return regions;
  }

private:
  void flush(Operation *first, Operation *last, unsigned opCount,
             unsigned blockOrdinal) {
    if (!opCount)
      return;
    regions.push_back({func, blockOrdinal, nextRegion++, first, last, opCount});
  }

  void collectBlock(Block &block) {
    unsigned blockOrdinal = nextBlock++;
    Operation *first = nullptr;
    Operation *last = nullptr;
    unsigned opCount = 0;
    for (Operation &op : block) {
      if (isHardBoundary(&op)) {
        flush(first, last, opCount, blockOrdinal);
        first = nullptr;
        last = nullptr;
        opCount = 0;
        if (auto loop = dyn_cast<waveamdmachine::UniformLoopOp>(op))
          for (Block &nested : loop.getBody())
            collectBlock(nested);
        continue;
      }
      if (!first)
        first = &op;
      last = &op;
      ++opCount;
    }
    flush(first, last, opCount, blockOrdinal);
  }

  func::FuncOp func;
  SmallVector<ScheduleRegion> regions;
  unsigned nextBlock = 0;
  unsigned nextRegion = 0;
};

static void printRegion(ScheduleRegion region) {
  llvm::errs() << "waveamd-machine-schedule region func="
               << region.func.getSymName() << " block=" << region.blockOrdinal
               << " region=" << region.regionOrdinal
               << " ops=" << region.opCount
               << " first=" << region.first->getName().getStringRef()
               << " last=" << region.last->getName().getStringRef() << "\n";
}

struct WaveAMDMachineSchedulePass
    : public wave::impl::WaveAMDMachineScheduleBase<
          WaveAMDMachineSchedulePass> {
  using WaveAMDMachineScheduleBase::WaveAMDMachineScheduleBase;

  void runOnOperation() override {
    ModuleOp mod = getOperation();
    mod.walk([&](func::FuncOp func) {
      if (func.isExternal())
        return;
      SmallVector<ScheduleRegion> regions = RegionCollector(func).collect();
      if (!printRegions)
        return;
      for (const ScheduleRegion &region : regions)
        printRegion(region);
    });
  }
};

} // namespace
