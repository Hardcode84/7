//===- WaveAMDResourceInfo.cpp - WaveAMD resource info ----------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/Wave/Transforms/Passes.h"

#include "WaveAMDRegAllocInternal.h"
#include "WaveAMDRegisterLimits.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/Wave/Transforms/WaveAMDExecIfUtils.h"
#include "mlir/Dialect/Wave/Transforms/WaveAMDRegAllocVerification.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachine.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachineTarget.h"
#include "mlir/IR/Builders.h"
#include "mlir/IR/BuiltinOps.h"
#include "llvm/Support/CheckedArithmetic.h"

#include <algorithm>
#include <optional>

namespace mlir::wave {
#define GEN_PASS_DEF_WAVEAMDRESOURCEINFO
#include "mlir/Dialect/Wave/Transforms/Passes.h.inc"
} // namespace mlir::wave

using namespace mlir;

namespace {

static bool isSGPR(waveamdmachine::RegType type) {
  return type.getRegClass() == waveamdmachine::RegClass::SGPR;
}

static bool isVGPR(waveamdmachine::RegType type) {
  return type.getRegClass() == waveamdmachine::RegClass::VGPR;
}

static bool isAGPR(waveamdmachine::RegType type) {
  return type.getRegClass() == waveamdmachine::RegClass::AGPR;
}

static void clearResourceAttrs(func::FuncOp func) {
  func->removeAttr("waveamdmachine.sgpr_count");
  func->removeAttr("waveamdmachine.vgpr_count");
  func->removeAttr("waveamdmachine.agpr_count");
  func->removeAttr("waveamdmachine.lds_size");
  func->removeAttr("waveamdmachine.dynamic_lds_size");
}

static void clearModuleResourceAttrs(ModuleOp mod) {
  mod->removeAttr("waveamdmachine.sgpr_count_max");
  mod->removeAttr("waveamdmachine.vgpr_count_max");
  mod->removeAttr("waveamdmachine.agpr_count_max");
  mod->removeAttr("waveamdmachine.lds_size_max");
  mod->removeAttr("waveamdmachine.private_segment_fixed_size_max");
}

static FailureOr<int64_t> getLDSAttr(func::FuncOp func, StringRef name) {
  IntegerAttr attr = func->getAttrOfType<IntegerAttr>(name);
  if (!attr)
    return 0;
  int64_t bytes = attr.getInt();
  if (bytes < 0)
    return func.emitError() << name << " must be non-negative";
  return bytes;
}

static FailureOr<int64_t> collectLDSBytes(func::FuncOp func,
                                          OpBuilder &builder) {
  FailureOr<int64_t> fixedLds = getLDSAttr(func, "wave.lds_size");
  FailureOr<int64_t> dynamicLds = getLDSAttr(func, "wave.dynamic_lds_size");
  FailureOr<int64_t> spillLds =
      getLDSAttr(func, "waveamdmachine.lds_spill_bytes");
  if (failed(fixedLds) || failed(dynamicLds) || failed(spillLds))
    return failure();

  std::optional<int64_t> fixedAndDynamic =
      llvm::checkedAdd(*fixedLds, *dynamicLds);
  std::optional<int64_t> total =
      fixedAndDynamic ? llvm::checkedAdd(*fixedAndDynamic, *spillLds)
                      : std::nullopt;
  if (!total)
    return func.emitError("aggregate LDS byte count overflows i64");

  if (func->hasAttr("wave.dynamic_lds_size"))
    func->setAttr("waveamdmachine.dynamic_lds_size",
                  builder.getI64IntegerAttr(*dynamicLds));
  if (func->hasAttr("wave.lds_size") ||
      func->hasAttr("wave.dynamic_lds_size") ||
      func->hasAttr("waveamdmachine.lds_spill_bytes"))
    func->setAttr("waveamdmachine.lds_size", builder.getI64IntegerAttr(*total));
  return *total;
}

static LogicalResult verifyLDSCapacity(func::FuncOp func, int64_t bytes) {
  if (!waveamdmachine::findAMDGPUTargetModule(func))
    return success();
  FailureOr<wave::WaveAMDLocalMemoryLimits> limits =
      wave::getWaveAMDLocalMemoryLimits(func, "waveamd-resource-info");
  if (failed(limits))
    return failure();

  uint64_t capacity = limits->localMemoryBytes;
  if (limits->addressableLocalMemoryBytes != 0)
    capacity =
        std::min<uint64_t>(capacity, limits->addressableLocalMemoryBytes);
  if (capacity == 0)
    return func.emitError("waveamd-resource-info target has no usable LDS");
  if (static_cast<uint64_t>(bytes) > capacity)
    return func.emitError("waveamd-resource-info LDS usage ")
           << bytes << " bytes exceeds target-addressable capacity " << capacity
           << " bytes";
  return success();
}

static int64_t collectPrivateSegmentBytes(func::FuncOp func,
                                          OpBuilder &builder) {
  int64_t fixedPrivate = 0;
  int64_t spillPrivate = 0;
  bool hasPrivate = false;
  if (IntegerAttr attr = func->getAttrOfType<IntegerAttr>(
          wave::regalloc::kScratchSpillBytesAttr)) {
    spillPrivate = attr.getInt();
    hasPrivate = true;
  }
  if (IntegerAttr attr =
          func->getAttrOfType<IntegerAttr>("wave.private_segment_fixed_size")) {
    fixedPrivate = attr.getInt();
    hasPrivate = true;
  } else if (IntegerAttr attr = func->getAttrOfType<IntegerAttr>(
                 wave::regalloc::kPrivateSegmentFixedSizeAttr)) {
    int64_t totalPrivate = attr.getInt();
    fixedPrivate =
        totalPrivate >= spillPrivate ? totalPrivate - spillPrivate : 0;
    hasPrivate = true;
  }
  int64_t privateBytes = fixedPrivate + spillPrivate;
  if (hasPrivate)
    func->setAttr(wave::regalloc::kPrivateSegmentFixedSizeAttr,
                  builder.getI64IntegerAttr(privateBytes));
  return privateBytes;
}

struct WaveAMDResourceInfoPass
    : public wave::impl::WaveAMDResourceInfoBase<WaveAMDResourceInfoPass> {
  struct MaxRegs {
    unsigned sgpr;
    unsigned vgpr;
    unsigned agpr;
  };
  bool scanValue(Operation &op, Value value, MaxRegs &out) {
    auto regType = dyn_cast<waveamdmachine::RegType>(value.getType());
    if (!regType)
      return false;
    // Hardware flags are single global resources; no physical numbering.
    if (regType.getRegClass() == waveamdmachine::RegClass::SCC ||
        regType.getRegClass() == waveamdmachine::RegClass::VCC)
      return false;
    int64_t index = regType.getIndex();
    if (index < 0) {
      op.emitError("waveamd-resource-info requires allocated register values");
      return true;
    }
    unsigned end = index + regType.getWidth();
    if (isSGPR(regType))
      out.sgpr = std::max(out.sgpr, end);
    if (isVGPR(regType))
      out.vgpr = std::max(out.vgpr, end);
    if (isAGPR(regType))
      out.agpr = std::max(out.agpr, end);
    return false;
  }

  void scanOp(Operation &op, MaxRegs &out, bool &failed) {
    for (Value result : op.getResults()) {
      if (scanValue(op, result, out)) {
        failed = true;
        return;
      }
    }
    for (Region &region : op.getRegions()) {
      for (Block &block : region) {
        for (BlockArgument arg : block.getArguments()) {
          if (scanValue(op, arg, out)) {
            failed = true;
            return;
          }
        }
        for (Operation &nested : block) {
          scanOp(nested, out, failed);
          if (failed)
            return;
        }
      }
    }
  }

  MaxRegs collectMaxRegs(func::FuncOp func, bool &scanFailed) {
    MaxRegs out{wave::getWaveAMDReservedSGPRs(func),
                wave::getWaveAMDReservedVGPRs(func), 0};
    for (Block &block : func.getBody()) {
      for (BlockArgument arg : block.getArguments()) {
        if (scanValue(*func, arg, out)) {
          scanFailed = true;
          return out;
        }
      }
      for (Operation &op : block) {
        scanOp(op, out, scanFailed);
        if (scanFailed)
          return out;
      }
    }
    FailureOr<unsigned> minReportedSGPRs =
        wave::getWaveAMDMinReportedSGPRs(func, "waveamd-resource-info");
    if (failed(minReportedSGPRs)) {
      scanFailed = true;
      return out;
    }
    out.sgpr = std::max(out.sgpr, *minReportedSGPRs);
    out.vgpr = std::max(out.vgpr, wave::getWaveAMDMinReportedVGPRs(func));
    return out;
  }

  void runOnOperation() override {
    ModuleOp mod = getOperation();
    clearModuleResourceAttrs(mod);
    OpBuilder builder(mod.getContext());
    SmallVector<func::FuncOp> kernels;
    mod.walk([&](func::FuncOp f) {
      if (!f.isExternal())
        kernels.push_back(f);
    });
    int64_t maxSgpr = 0;
    int64_t maxVgpr = 0;
    int64_t maxAgpr = 0;
    int64_t maxLds = 0;
    int64_t maxPrivate = 0;
    bool sawKernel = false;
    for (func::FuncOp func : kernels) {
      clearResourceAttrs(func);
      if (wave::isWaveAMDRegAllocOverflowed(func))
        continue;
      if (failed(wave::verifyWaveAMDRegAllocation(
              func, "waveamd-resource-info",
              wave::WaveAMDRegAllocVerificationScope::Results)))
        return signalPassFailure();
      bool scanFailed = false;
      MaxRegs regs = collectMaxRegs(func, scanFailed);
      if (scanFailed)
        return signalPassFailure();
      bool isKernel = func->hasAttr(wave::WaveDialect::getKernelAttrName());
      unsigned sgprCount = regs.sgpr;
      unsigned vgprCount = regs.vgpr;
      unsigned agprCount = regs.agpr;
      sgprCount = wave::getWaveAMDExecIfReservedSGPRCount(func, sgprCount);
      func->setAttr("waveamdmachine.sgpr_count",
                    builder.getI64IntegerAttr(sgprCount));
      func->setAttr("waveamdmachine.vgpr_count",
                    builder.getI64IntegerAttr(vgprCount));
      func->setAttr("waveamdmachine.agpr_count",
                    builder.getI64IntegerAttr(agprCount));
      FailureOr<int64_t> lds = collectLDSBytes(func, builder);
      if (failed(lds))
        return signalPassFailure();
      int64_t privateBytes = collectPrivateSegmentBytes(func, builder);
      if (!isKernel)
        continue;
      if (failed(verifyLDSCapacity(func, *lds)))
        return signalPassFailure();
      sawKernel = true;
      maxSgpr = std::max<int64_t>(maxSgpr, sgprCount);
      maxVgpr = std::max<int64_t>(maxVgpr, vgprCount);
      maxAgpr = std::max<int64_t>(maxAgpr, agprCount);
      maxLds = std::max<int64_t>(maxLds, *lds);
      maxPrivate = std::max<int64_t>(maxPrivate, privateBytes);
    }
    if (sawKernel) {
      mod->setAttr("waveamdmachine.sgpr_count_max",
                   builder.getI64IntegerAttr(maxSgpr));
      mod->setAttr("waveamdmachine.vgpr_count_max",
                   builder.getI64IntegerAttr(maxVgpr));
      mod->setAttr("waveamdmachine.agpr_count_max",
                   builder.getI64IntegerAttr(maxAgpr));
      mod->setAttr("waveamdmachine.lds_size_max",
                   builder.getI64IntegerAttr(maxLds));
      mod->setAttr("waveamdmachine.private_segment_fixed_size_max",
                   builder.getI64IntegerAttr(maxPrivate));
    }
  }
};

} // namespace
