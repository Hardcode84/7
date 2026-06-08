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
  Value value;
  unsigned intervalIndex = 0;
  unsigned start = 0;
  unsigned end = 0;
  unsigned physStart = 0;
  unsigned physEnd = 0;
};

static bool isAllocatedClass(waveamdmachine::RegType type) {
  return wave::isWaveAMDSGPR(type) || wave::isWaveAMDVGPR(type) ||
         wave::isWaveAMDAGPR(type);
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
           << consumer
           << " supports only SGPR, VGPR, and AGPR register classes";
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

static LogicalResult buildPhysicalLiveRange(
    func::FuncOp func, const wave::WaveAMDLiveInterval &interval,
    unsigned intervalIndex, SmallVectorImpl<PhysicalLiveRange> &ranges,
    StringRef consumer) {
  std::optional<int64_t> base;
  for (auto [value, slotOffset, start, end] :
       llvm::zip(interval.values, interval.slotOffsets, interval.valueStarts,
                 interval.valueEnds)) {
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
    ranges.push_back(PhysicalLiveRange{
        value, intervalIndex, start, end, static_cast<unsigned>(index),
        static_cast<unsigned>(index) + static_cast<unsigned>(type.getWidth())});
  }
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

static LogicalResult
verifyNotInReservedRange(func::FuncOp func, const PhysicalLiveRange &range,
                         StringRef consumer, StringRef regClass,
                         unsigned reserved,
                         const wave::WaveAMDKernelEntryRegs &regs) {
  if (reserved == 0 || range.physStart >= reserved)
    return success();
  if (isAllowedReservedValue(range.value, regs))
    return success();
  return diagOpForValue(range.value, func)->emitError()
         << consumer << " found " << regClass
         << " value allocated in reserved kernel ABI registers";
}

static LogicalResult
verifyReservedRanges(func::FuncOp func, ArrayRef<PhysicalLiveRange> ranges,
                     StringRef consumer, StringRef regClass, unsigned reserved,
                     const wave::WaveAMDKernelEntryRegs &regs) {
  for (const PhysicalLiveRange &range : ranges)
    if (failed(verifyNotInReservedRange(func, range, consumer, regClass,
                                        reserved, regs)))
      return failure();
  return success();
}

static bool canSharePhysicalRange(const PhysicalLiveRange &lhs,
                                  const PhysicalLiveRange &rhs) {
  return lhs.intervalIndex == rhs.intervalIndex;
}

static LogicalResult
verifyNoRangeInterference(func::FuncOp func, ArrayRef<PhysicalLiveRange> ranges,
                          StringRef consumer, StringRef regClass) {
  for (auto [index, lhs] : llvm::enumerate(ranges)) {
    for (const PhysicalLiveRange &rhs :
         ArrayRef(ranges).drop_front(index + 1)) {
      if (canSharePhysicalRange(lhs, rhs))
        continue;
      if (!liveRangesOverlap(lhs, rhs) || !physicalRangesOverlap(lhs, rhs))
        continue;
      InFlightDiagnostic diag =
          func.emitError() << consumer << " found interfering " << regClass
                           << " register live ranges: lhs phys=["
                           << lhs.physStart << ", " << lhs.physEnd << ") live=["
                           << lhs.start << ", " << lhs.end << "), rhs phys=["
                           << rhs.physStart << ", " << rhs.physEnd << ") live=["
                           << rhs.start << ", " << rhs.end << ")";
      diag.attachNote(diagOpForValue(lhs.value, func)->getLoc())
          << "lhs phys=[" << lhs.physStart << ", " << lhs.physEnd << ") live=["
          << lhs.start << ", " << lhs.end << ")";
      diag.attachNote(diagOpForValue(rhs.value, func)->getLoc())
          << "rhs phys=[" << rhs.physStart << ", " << rhs.physEnd << ") live=["
          << rhs.start << ", " << rhs.end << ")";
      return failure();
    }
  }
  return success();
}

static LogicalResult
verifyNoInterference(func::FuncOp func,
                     ArrayRef<wave::WaveAMDLiveInterval> intervals,
                     StringRef consumer, StringRef regClass, unsigned reserved,
                     const wave::WaveAMDKernelEntryRegs &regs) {
  SmallVector<PhysicalLiveRange> ranges;
  for (auto [intervalIndex, interval] : llvm::enumerate(intervals)) {
    if (interval.values.empty())
      continue;
    if (failed(buildPhysicalLiveRange(func, interval, intervalIndex, ranges,
                                      consumer)))
      return failure();
  }
  if (failed(verifyReservedRanges(func, ranges, consumer, regClass, reserved,
                                  regs)))
    return failure();
  return verifyNoRangeInterference(func, ranges, consumer, regClass);
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
  if (failed(verifyNoInterference(func, builtIntervals->intervals.vgprs,
                                  consumer, "VGPR", regs.reservedVGPRs, regs)))
    return failure();
  return verifyNoInterference(func, builtIntervals->intervals.agprs, consumer,
                              "AGPR", /*reserved=*/0, regs);
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
