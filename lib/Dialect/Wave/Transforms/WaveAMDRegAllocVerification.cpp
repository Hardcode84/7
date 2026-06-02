//===- WaveAMDRegAllocVerification.cpp - Post-regalloc checks ---*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/Wave/Transforms/WaveAMDRegAllocVerification.h"

#include "WaveAMDRegLiveIntervals.h"
#include "WaveAMDRegisterLimits.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachine.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/ADT/StringRef.h"
#include <optional>

using namespace mlir;

namespace {

struct PhysicalLiveRange {
  unsigned start = 0;
  unsigned end = 0;
  unsigned physStart = 0;
  unsigned physEnd = 0;
};

static bool isAllocatedClass(waveamdmachine::RegType type) {
  return wave::isWaveAMDSGPR(type) || wave::isWaveAMDVGPR(type);
}

static Operation *diagOpForValue(Value value, func::FuncOp func) {
  if (Operation *def = value.getDefiningOp())
    return def;
  if (auto arg = dyn_cast<BlockArgument>(value))
    if (Operation *parent = arg.getOwner()->getParentOp())
      return parent;
  return func;
}

static LogicalResult verifyValueAllocated(Value value, func::FuncOp func,
                                          StringRef consumer) {
  auto type = dyn_cast<waveamdmachine::RegType>(value.getType());
  if (!type || wave::isWaveAMDFlagReg(type))
    return success();
  Operation *diagOp = diagOpForValue(value, func);
  if (!isAllocatedClass(type))
    return diagOp->emitError()
           << consumer << " supports only SGPR and VGPR register classes";
  if (type.getIndex() < 0)
    return diagOp->emitError()
           << consumer << " requires allocated register values";
  return success();
}

static LogicalResult verifyOperandsAllocated(Operation *op, func::FuncOp func,
                                             StringRef consumer) {
  for (Value operand : op->getOperands())
    if (failed(verifyValueAllocated(operand, func, consumer)))
      return failure();
  return success();
}

static LogicalResult verifyResultsAllocated(Operation *op, func::FuncOp func,
                                            StringRef consumer) {
  for (Value result : op->getResults())
    if (failed(verifyValueAllocated(result, func, consumer)))
      return failure();
  return success();
}

static LogicalResult verifyBlockArgsAllocated(Operation *op, func::FuncOp func,
                                              StringRef consumer) {
  for (Region &region : op->getRegions()) {
    for (Block &block : region) {
      for (BlockArgument arg : block.getArguments())
        if (failed(verifyValueAllocated(arg, func, consumer)))
          return failure();
    }
  }
  return success();
}

static LogicalResult
verifyOpValuesAllocated(Operation *op, func::FuncOp func, StringRef consumer,
                        wave::WaveAMDRegAllocVerificationScope scope) {
  if (scope == wave::WaveAMDRegAllocVerificationScope::AllValues &&
      failed(verifyOperandsAllocated(op, func, consumer)))
    return failure();
  if (failed(verifyResultsAllocated(op, func, consumer)))
    return failure();
  if (scope == wave::WaveAMDRegAllocVerificationScope::Results)
    return success();
  return verifyBlockArgsAllocated(op, func, consumer);
}

static LogicalResult
verifyValuesAllocated(func::FuncOp func, StringRef consumer,
                      wave::WaveAMDRegAllocVerificationScope scope) {
  WalkResult walk = func.walk([&](Operation *op) {
    return failed(verifyOpValuesAllocated(op, func, consumer, scope))
               ? WalkResult::interrupt()
               : WalkResult::advance();
  });
  return success(!walk.wasInterrupted());
}

static LogicalResult
buildPhysicalLiveRange(func::FuncOp func,
                       const wave::WaveAMDLiveInterval &interval,
                       PhysicalLiveRange &range, StringRef consumer) {
  std::optional<int64_t> base;
  unsigned width = 0;
  for (auto [value, slotOffset] :
       llvm::zip(interval.values, interval.slotOffsets)) {
    auto type = cast<waveamdmachine::RegType>(value.getType());
    int64_t index = type.getIndex();
    if (index < static_cast<int64_t>(slotOffset))
      return diagOpForValue(value, func)->emitError()
             << consumer << " found register alias below physical zero";
    int64_t valueBase = index - static_cast<int64_t>(slotOffset);
    if (!base) {
      base = valueBase;
    } else if (*base != valueBase) {
      return diagOpForValue(value, func)->emitError()
             << consumer << " found inconsistent physical register aliases";
    }
    width = std::max<unsigned>(width, slotOffset + type.getWidth());
  }
  if (!base)
    return success();
  range.start = interval.start;
  range.end = interval.end;
  range.physStart = static_cast<unsigned>(*base);
  range.physEnd = range.physStart + width;
  return success();
}

static bool liveRangesOverlap(const PhysicalLiveRange &lhs,
                              const PhysicalLiveRange &rhs) {
  return lhs.start <= rhs.end && rhs.start <= lhs.end;
}

static bool physicalRangesOverlap(const PhysicalLiveRange &lhs,
                                  const PhysicalLiveRange &rhs) {
  return lhs.physStart < rhs.physEnd && rhs.physStart < lhs.physEnd;
}

static bool
isAllowedKernargPreloadValue(waveamdmachine::RegType type,
                             const wave::WaveAMDKernelEntryRegs &regs) {
  int64_t index = type.getIndex();
  if (!wave::isWaveAMDSGPR(type) || index < 0)
    return false;
  unsigned begin = static_cast<unsigned>(index);
  unsigned end = begin + type.getWidth();
  unsigned preloadBegin = regs.kernargSegmentPtrWidth;
  unsigned preloadEnd = preloadBegin + regs.kernargPreloadDwords;
  return preloadBegin <= begin && end <= preloadEnd;
}

static bool isAllowedEntryRegValue(Operation *def, int64_t index,
                                   const wave::WaveAMDKernelEntryRegs &regs) {
  if (isa<waveamdmachine::VWorkitemIdXOp>(def))
    return index == regs.workitemIdXVGPR;
  if (isa<waveamdmachine::SWorkgroupIdXOp>(def))
    return index == regs.workgroupIdSGPR(0);
  if (isa<waveamdmachine::SWorkgroupIdYOp>(def))
    return index == regs.workgroupIdSGPR(1);
  if (isa<waveamdmachine::SWorkgroupIdZOp>(def))
    return index == regs.workgroupIdSGPR(2);
  return false;
}

static bool isAllowedReservedValue(Value value,
                                   const wave::WaveAMDKernelEntryRegs &regs) {
  Operation *def = value.getDefiningOp();
  if (!def)
    return false;
  auto type = cast<waveamdmachine::RegType>(value.getType());
  int64_t index = type.getIndex();
  if (isa<waveamdmachine::KernargPreloadOp>(def))
    return isAllowedKernargPreloadValue(type, regs);
  if (type.getWidth() != 1)
    return false;
  return isAllowedEntryRegValue(def, index, regs);
}

static LogicalResult verifyNotInReservedRange(
    func::FuncOp func, const wave::WaveAMDLiveInterval &interval,
    const PhysicalLiveRange &range, StringRef consumer, StringRef regClass,
    unsigned reserved, const wave::WaveAMDKernelEntryRegs &regs) {
  if (reserved == 0 || range.physStart >= reserved)
    return success();
  for (Value value : interval.values)
    if (!isAllowedReservedValue(value, regs))
      return diagOpForValue(value, func)->emitError()
             << consumer << " found " << regClass
             << " value allocated in reserved kernel ABI registers";
  return success();
}

static LogicalResult
verifyNoInterference(func::FuncOp func,
                     ArrayRef<wave::WaveAMDLiveInterval> intervals,
                     StringRef consumer, StringRef regClass, unsigned reserved,
                     const wave::WaveAMDKernelEntryRegs &regs) {
  SmallVector<PhysicalLiveRange> ranges;
  for (const wave::WaveAMDLiveInterval &interval : intervals) {
    if (interval.values.empty())
      continue;
    PhysicalLiveRange range;
    if (failed(buildPhysicalLiveRange(func, interval, range, consumer)))
      return failure();
    if (failed(verifyNotInReservedRange(func, interval, range, consumer,
                                        regClass, reserved, regs)))
      return failure();
    ranges.push_back(range);
  }
  for (auto [index, lhs] : llvm::enumerate(ranges)) {
    for (const PhysicalLiveRange &rhs :
         ArrayRef(ranges).drop_front(index + 1)) {
      if (!liveRangesOverlap(lhs, rhs) || !physicalRangesOverlap(lhs, rhs))
        continue;
      return func.emitError() << consumer << " found interfering " << regClass
                              << " register live ranges";
    }
  }
  return success();
}

} // namespace

StringRef mlir::wave::getWaveAMDRegAllocOverflowedAttrName() {
  return "waveamdmachine.regalloc_overflowed";
}

StringRef mlir::wave::getWaveAMDRegAllocOverflowedCountAttrName() {
  return "waveamdmachine.regalloc_overflowed_count";
}

bool mlir::wave::isWaveAMDRegAllocOverflowed(func::FuncOp func) {
  return func->hasAttr(getWaveAMDRegAllocOverflowedAttrName());
}

LogicalResult mlir::wave::failIfWaveAMDRegAllocOverflowed(func::FuncOp func,
                                                          StringRef consumer) {
  if (!isWaveAMDRegAllocOverflowed(func))
    return success();
  return func.emitError() << consumer
                          << " cannot consume overflowed register allocation";
}

LogicalResult
mlir::wave::verifyWaveAMDRegAllocation(func::FuncOp func, StringRef consumer,
                                       WaveAMDRegAllocVerificationScope scope) {
  if (func.isExternal())
    return success();
  if (failed(failIfWaveAMDRegAllocOverflowed(func, consumer)))
    return failure();
  if (failed(verifyValuesAllocated(func, consumer, scope)))
    return failure();
  FailureOr<WaveAMDLiveIntervalBuildResult> builtIntervals =
      buildAllocatedWaveAMDLiveIntervals(func);
  if (failed(builtIntervals))
    return failure();
  wave::WaveAMDKernelEntryRegs regs = wave::getWaveAMDKernelEntryRegs(func);
  if (failed(verifyNoInterference(func, builtIntervals->intervals.sgprs,
                                  consumer, "SGPR", regs.reservedSGPRs, regs)))
    return failure();
  return verifyNoInterference(func, builtIntervals->intervals.vgprs, consumer,
                              "VGPR", regs.reservedVGPRs, regs);
}

LogicalResult mlir::wave::verifyWaveAMDRegAllocations(
    Operation *root, StringRef consumer,
    WaveAMDRegAllocVerificationScope scope) {
  WalkResult walk = root->walk([&](func::FuncOp func) {
    return failed(verifyWaveAMDRegAllocation(func, consumer, scope))
               ? WalkResult::interrupt()
               : WalkResult::advance();
  });
  return success(!walk.wasInterrupted());
}
