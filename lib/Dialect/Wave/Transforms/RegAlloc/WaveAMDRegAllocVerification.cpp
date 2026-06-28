//===- WaveAMDRegAllocVerification.cpp - Post-regalloc checks ---*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/Wave/Transforms/WaveAMDRegAllocVerification.h"

#include "WaveAMDRegAllocTransformUtils.h"
#include "WaveAMDRegLiveIntervals.h"
#include "WaveAMDRegisterLimits.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachine.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/ADT/StringRef.h"
#include <algorithm>
#include <optional>
#include <tuple>

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

struct FixedCarryRange {
  StringRef regClass;
  Operation *diagOp = nullptr;
  unsigned carryIndex = 0;
  unsigned physStart = 0;
  unsigned physEnd = 0;
};

struct ReservedLiveRange {
  unsigned start = 0;
  unsigned end = 0;
  unsigned physStart = 0;
  unsigned physEnd = 0;
};

static bool isAllocatedClass(waveamdmachine::RegType type) {
  return wave::isWaveAMDSGPR(type) || wave::isWaveAMDVGPR(type) ||
         wave::isWaveAMDAGPR(type);
}

static StringRef getRegClassName(waveamdmachine::RegType type) {
  if (wave::isWaveAMDSGPR(type))
    return "SGPR";
  if (wave::isWaveAMDVGPR(type))
    return "VGPR";
  if (wave::isWaveAMDAGPR(type))
    return "AGPR";
  return "";
}

static Operation *diagOpForValue(Value value, func::FuncOp func) {
  if (Operation *def = value.getDefiningOp())
    return def;
  if (auto arg = dyn_cast<BlockArgument>(value))
    if (Operation *parent = arg.getOwner()->getParentOp())
      return parent;
  return func;
}

static bool isFixedHardwareRead(Value value) {
  Operation *def = value.getDefiningOp();
  return isa_and_nonnull<
      waveamdmachine::SWorkgroupIdXOp, waveamdmachine::SWorkgroupIdYOp,
      waveamdmachine::SWorkgroupIdZOp, waveamdmachine::VWorkitemIdXOp>(def);
}

static bool areEquivalentFixedHardwareReads(Value lhs, Value rhs) {
  if (!isFixedHardwareRead(lhs) || !isFixedHardwareRead(rhs))
    return false;
  if (lhs.getType() != rhs.getType())
    return false;
  return lhs.getDefiningOp()->getName() == rhs.getDefiningOp()->getName();
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
    if (index < 0)
      continue;
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

static bool liveRangesOverlap(const PhysicalLiveRange &lhs,
                              const ReservedLiveRange &rhs) {
  return lhs.start <= rhs.end && rhs.start <= lhs.end;
}

static bool physicalRangesOverlap(const PhysicalLiveRange &lhs,
                                  const ReservedLiveRange &rhs) {
  return lhs.physStart < rhs.physEnd && rhs.physStart < lhs.physEnd;
}

static bool physicalRangesOverlap(const FixedCarryRange &lhs,
                                  const FixedCarryRange &rhs) {
  return lhs.physStart < rhs.physEnd && rhs.physStart < lhs.physEnd;
}

static bool haveSamePhysicalRange(const PhysicalLiveRange &lhs,
                                  const PhysicalLiveRange &rhs) {
  return lhs.physStart == rhs.physStart && lhs.physEnd == rhs.physEnd;
}

static bool overlapsReservedRange(const PhysicalLiveRange &range,
                                  const ReservedLiveRange &reservedRange) {
  return liveRangesOverlap(range, reservedRange) &&
         physicalRangesOverlap(range, reservedRange);
}

static Operation *
getResultDefAtStart(const PhysicalLiveRange &range,
                    const DenseMap<Operation *, unsigned> &positions) {
  Operation *op = range.value.getDefiningOp();
  if (!op)
    return nullptr;
  auto it = positions.find(op);
  if (it == positions.end() || it->second != range.start)
    return nullptr;
  if (!llvm::is_contained(op->getResults(), range.value))
    return nullptr;
  return op;
}

static bool hasReusableOperand(Operation *op, Value value) {
  for (OpOperand &operand : op->getOpOperands())
    if (operand.get() == value)
      return wave::regalloc_detail::canReuseKilledOperandForResult(op, operand);
  return false;
}

static bool
isDestructiveOperandBoundary(const PhysicalLiveRange &sourceRange,
                             const PhysicalLiveRange &resultRange,
                             const DenseMap<Operation *, unsigned> &positions) {
  if (!haveSamePhysicalRange(sourceRange, resultRange))
    return false;
  if (sourceRange.end != resultRange.start)
    return false;
  Operation *op = getResultDefAtStart(resultRange, positions);
  return op && hasReusableOperand(op, sourceRange.value);
}

static std::optional<FixedCarryRange>
getFixedCarryRange(Value value, func::FuncOp func, unsigned carryIndex) {
  auto type = dyn_cast<waveamdmachine::RegType>(value.getType());
  if (!type || !isAllocatedClass(type) || type.getIndex() < 0)
    return std::nullopt;
  unsigned index = static_cast<unsigned>(type.getIndex());
  unsigned width = static_cast<unsigned>(type.getWidth());
  return FixedCarryRange{getRegClassName(type), diagOpForValue(value, func),
                         carryIndex, index, index + width};
}

static LogicalResult
mergeFixedCarryRange(std::optional<FixedCarryRange> &slotRange,
                     const FixedCarryRange &range,
                     waveamdmachine::UniformLoopOp loop, StringRef consumer) {
  if (!slotRange) {
    slotRange = range;
    return success();
  }
  if (slotRange->regClass == range.regClass &&
      slotRange->physStart == range.physStart &&
      slotRange->physEnd == range.physEnd)
    return success();
  return loop.emitError() << consumer
                          << " found inconsistent fixed loop carry storage";
}

static LogicalResult
recordFixedCarryValue(SmallVectorImpl<std::optional<FixedCarryRange>> &ranges,
                      Value value, func::FuncOp func,
                      waveamdmachine::UniformLoopOp loop, unsigned carryIndex,
                      StringRef consumer) {
  std::optional<FixedCarryRange> range =
      getFixedCarryRange(value, func, carryIndex);
  if (!range)
    return success();
  return mergeFixedCarryRange(ranges[carryIndex], *range, loop, consumer);
}

static LogicalResult
recordFixedCarrySlot(SmallVectorImpl<std::optional<FixedCarryRange>> &ranges,
                     waveamdmachine::UniformLoopOp loop,
                     waveamdmachine::ContinueIfOp term, func::FuncOp func,
                     unsigned carryIndex, StringRef consumer) {
  Block &body = loop.getBody().front();
  if (failed(recordFixedCarryValue(ranges, loop.getInits()[carryIndex], func,
                                   loop, carryIndex, consumer)))
    return failure();
  if (failed(recordFixedCarryValue(ranges, body.getArgument(carryIndex), func,
                                   loop, carryIndex, consumer)))
    return failure();
  if (failed(recordFixedCarryValue(ranges, loop.getResult(carryIndex), func,
                                   loop, carryIndex, consumer)))
    return failure();
  return recordFixedCarryValue(ranges, term.getCarries()[carryIndex], func,
                               loop, carryIndex, consumer);
}

static LogicalResult
collectFixedCarryRanges(SmallVectorImpl<std::optional<FixedCarryRange>> &ranges,
                        waveamdmachine::UniformLoopOp loop, func::FuncOp func,
                        StringRef consumer) {
  waveamdmachine::ContinueIfOp term = cast<waveamdmachine::ContinueIfOp>(
      loop.getBody().front().getTerminator());
  for (unsigned i : llvm::seq<unsigned>(0, ranges.size())) {
    if (failed(recordFixedCarrySlot(ranges, loop, term, func, i, consumer)))
      return failure();
  }
  return success();
}

static LogicalResult
emitFixedCarryOverlapError(waveamdmachine::UniformLoopOp loop,
                           const FixedCarryRange &lhs,
                           const FixedCarryRange &rhs, StringRef consumer) {
  InFlightDiagnostic diag = loop.emitError()
                            << consumer
                            << " found distinct fixed loop carry slots sharing "
                            << lhs.regClass << " register range";
  diag.attachNote(lhs.diagOp->getLoc())
      << "slot " << lhs.carryIndex << " phys=[" << lhs.physStart << ", "
      << lhs.physEnd << ")";
  diag.attachNote(rhs.diagOp->getLoc())
      << "slot " << rhs.carryIndex << " phys=[" << rhs.physStart << ", "
      << rhs.physEnd << ")";
  return failure();
}

static LogicalResult
verifyNoFixedCarryOverlap(ArrayRef<std::optional<FixedCarryRange>> ranges,
                          waveamdmachine::UniformLoopOp loop,
                          StringRef consumer) {
  for (auto [index, lhs] : llvm::enumerate(ranges)) {
    if (!lhs)
      continue;
    for (const std::optional<FixedCarryRange> &rhs :
         ranges.drop_front(index + 1)) {
      if (!rhs || lhs->regClass != rhs->regClass ||
          !physicalRangesOverlap(*lhs, *rhs))
        continue;
      return emitFixedCarryOverlapError(loop, *lhs, *rhs, consumer);
    }
  }
  return success();
}

static LogicalResult
verifyFixedLoopCarryStorage(waveamdmachine::UniformLoopOp loop,
                            func::FuncOp func, StringRef consumer) {
  SmallVector<std::optional<FixedCarryRange>> ranges(loop.getInits().size());
  if (failed(collectFixedCarryRanges(ranges, loop, func, consumer)))
    return failure();
  return verifyNoFixedCarryOverlap(ranges, loop, consumer);
}

static LogicalResult verifyFixedLoopCarryStorage(func::FuncOp func,
                                                 StringRef consumer) {
  WalkResult walk = func.walk([&](waveamdmachine::UniformLoopOp loop) {
    return failed(verifyFixedLoopCarryStorage(loop, func, consumer))
               ? WalkResult::interrupt()
               : WalkResult::advance();
  });
  return success(!walk.wasInterrupted());
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

static void noteReservedSpan(SmallVectorImpl<ReservedLiveRange> &ranges,
                             unsigned begin, unsigned width, unsigned end,
                             unsigned reserved) {
  for (unsigned phys : llvm::seq<unsigned>(begin, begin + width)) {
    if (phys >= reserved)
      continue;
    ranges.push_back(ReservedLiveRange{/*start=*/0, end, phys, phys + 1});
  }
}

static std::optional<std::pair<unsigned, unsigned>>
parseSGPRSpan(StringRef text) {
  text = text.trim();
  if (!text.consume_front("s"))
    return std::nullopt;
  if (text.consume_front("[")) {
    StringRef beginText;
    StringRef endText;
    std::tie(beginText, text) = text.split(':');
    std::tie(endText, text) = text.split(']');
    if (beginText.empty() || endText.empty() || !text.empty())
      return std::nullopt;
    unsigned begin = 0;
    unsigned end = 0;
    if (beginText.getAsInteger(10, begin) || endText.getAsInteger(10, end) ||
        end < begin)
      return std::nullopt;
    return std::make_pair(begin, end - begin + 1);
  }
  unsigned reg = 0;
  if (text.getAsInteger(10, reg))
    return std::nullopt;
  return std::make_pair(reg, 1);
}

static std::optional<StringRef> getSLoadBase(Operation *op) {
  if (auto load = dyn_cast<waveamdmachine::SLoadB32Op>(op))
    return load.getBase();
  if (auto load = dyn_cast<waveamdmachine::SLoadB64Op>(op))
    return load.getBase();
  if (auto load = dyn_cast<waveamdmachine::SLoadB128Op>(op))
    return load.getBase();
  return std::nullopt;
}

static unsigned
getOperationEnd(Operation *op, const DenseMap<Operation *, unsigned> &positions,
                DenseMap<Operation *, unsigned> &endCache) {
  auto cached = endCache.find(op);
  if (cached != endCache.end())
    return cached->second;
  unsigned end = positions.lookup(op);
  op->walk([&](Operation *nested) {
    auto it = positions.find(nested);
    if (it != positions.end())
      end = std::max(end, it->second);
  });
  endCache[op] = end;
  return end;
}

static unsigned
getImplicitABIUseEnd(Operation *op,
                     const DenseMap<Operation *, unsigned> &positions,
                     DenseMap<Operation *, unsigned> &endCache) {
  unsigned end = positions.lookup(op);
  for (Operation *parent = op->getParentOp(); parent;
       parent = parent->getParentOp())
    if (isa<waveamdmachine::UniformLoopOp>(parent))
      end = std::max(end, getOperationEnd(parent, positions, endCache));
  return end;
}

static void collectImplicitReservedSGPRRanges(
    ArrayRef<Operation *> orderedOps,
    const DenseMap<Operation *, unsigned> &positions,
    const wave::WaveAMDKernelEntryRegs &regs,
    SmallVectorImpl<ReservedLiveRange> &ranges) {
  DenseMap<Operation *, unsigned> endCache;
  for (Operation *op : orderedOps) {
    std::optional<StringRef> base = getSLoadBase(op);
    bool isPreload = isa<waveamdmachine::KernargPreloadOp>(op);
    if (!base && !isPreload)
      continue;
    unsigned end = getImplicitABIUseEnd(op, positions, endCache);
    if (base) {
      if (std::optional<std::pair<unsigned, unsigned>> span =
              parseSGPRSpan(*base))
        noteReservedSpan(ranges, span->first, span->second, end,
                         regs.reservedSGPRs);
    }
    if (isPreload)
      noteReservedSpan(ranges, regs.kernargSegmentPtrSGPR,
                       regs.kernargSegmentPtrWidth, end, regs.reservedSGPRs);
  }
}

static void collectReservedRanges(
    ArrayRef<PhysicalLiveRange> liveRanges, ArrayRef<Operation *> orderedOps,
    const DenseMap<Operation *, unsigned> &positions, StringRef regClass,
    unsigned reserved, const wave::WaveAMDKernelEntryRegs &regs,
    SmallVectorImpl<ReservedLiveRange> &ranges) {
  if (regClass == "SGPR")
    collectImplicitReservedSGPRRanges(orderedOps, positions, regs, ranges);
  for (const PhysicalLiveRange &range : liveRanges) {
    if (!isAllowedReservedValue(range.value, regs))
      continue;
    noteReservedSpan(ranges, range.physStart, range.physEnd - range.physStart,
                     range.end, reserved);
  }
}

static bool needsReservedRangeCheck(const PhysicalLiveRange &range,
                                    unsigned reserved,
                                    const wave::WaveAMDKernelEntryRegs &regs) {
  if (reserved == 0 || range.physStart >= reserved)
    return false;
  return !isAllowedReservedValue(range.value, regs);
}

static bool
hasDestructiveReservedBoundary(const PhysicalLiveRange &range,
                               const ReservedLiveRange &reservedRange,
                               ArrayRef<PhysicalLiveRange> ranges,
                               const DenseMap<Operation *, unsigned> &positions,
                               const wave::WaveAMDKernelEntryRegs &regs) {
  return llvm::any_of(ranges, [&](const PhysicalLiveRange &source) {
    if (!isAllowedReservedValue(source.value, regs))
      return false;
    if (!overlapsReservedRange(source, reservedRange))
      return false;
    return isDestructiveOperandBoundary(source, range, positions);
  });
}

static LogicalResult verifyNotInReservedRange(
    func::FuncOp func, const PhysicalLiveRange &range, StringRef consumer,
    StringRef regClass, ArrayRef<PhysicalLiveRange> ranges,
    ArrayRef<ReservedLiveRange> reservedRanges,
    const DenseMap<Operation *, unsigned> &positions, unsigned reserved,
    const wave::WaveAMDKernelEntryRegs &regs) {
  if (!needsReservedRangeCheck(range, reserved, regs))
    return success();
  for (const ReservedLiveRange &reservedRange : reservedRanges) {
    if (!overlapsReservedRange(range, reservedRange))
      continue;
    if (hasDestructiveReservedBoundary(range, reservedRange, ranges, positions,
                                       regs))
      continue;
    return diagOpForValue(range.value, func)->emitError()
           << consumer << " found " << regClass
           << " value allocated in reserved kernel ABI registers";
  }
  return success();
}

static LogicalResult
verifyReservedRanges(func::FuncOp func, ArrayRef<PhysicalLiveRange> ranges,
                     ArrayRef<Operation *> orderedOps,
                     const DenseMap<Operation *, unsigned> &positions,
                     StringRef consumer, StringRef regClass, unsigned reserved,
                     const wave::WaveAMDKernelEntryRegs &regs) {
  SmallVector<ReservedLiveRange> reservedRanges;
  collectReservedRanges(ranges, orderedOps, positions, regClass, reserved, regs,
                        reservedRanges);
  for (const PhysicalLiveRange &range : ranges)
    if (failed(verifyNotInReservedRange(func, range, consumer, regClass, ranges,
                                        reservedRanges, positions, reserved,
                                        regs)))
      return failure();
  return success();
}

static bool
canSharePhysicalRange(const PhysicalLiveRange &lhs,
                      const PhysicalLiveRange &rhs,
                      const DenseMap<Operation *, unsigned> &positions) {
  if (lhs.intervalIndex == rhs.intervalIndex)
    return true;
  if (!haveSamePhysicalRange(lhs, rhs))
    return false;
  if (isDestructiveOperandBoundary(lhs, rhs, positions) ||
      isDestructiveOperandBoundary(rhs, lhs, positions))
    return true;
  return areEquivalentFixedHardwareReads(lhs.value, rhs.value);
}

static LogicalResult
verifyNoRangeInterference(func::FuncOp func, ArrayRef<PhysicalLiveRange> ranges,
                          const DenseMap<Operation *, unsigned> &positions,
                          StringRef consumer, StringRef regClass) {
  for (auto [index, lhs] : llvm::enumerate(ranges)) {
    for (const PhysicalLiveRange &rhs :
         ArrayRef(ranges).drop_front(index + 1)) {
      if (canSharePhysicalRange(lhs, rhs, positions))
        continue;
      if (!liveRangesOverlap(lhs, rhs) || !physicalRangesOverlap(lhs, rhs))
        continue;
      InFlightDiagnostic diag =
          func.emitError() << consumer << " found interfering " << regClass
                           << " register live ranges: lhs phys=["
                           << lhs.physStart << ", " << lhs.physEnd << ") live=["
                           << lhs.start << ", " << lhs.end << "], rhs phys=["
                           << rhs.physStart << ", " << rhs.physEnd << ") live=["
                           << rhs.start << ", " << rhs.end << "]";
      diag.attachNote(diagOpForValue(lhs.value, func)->getLoc())
          << "lhs phys=[" << lhs.physStart << ", " << lhs.physEnd << ") live=["
          << lhs.start << ", " << lhs.end << "]";
      diag.attachNote(diagOpForValue(rhs.value, func)->getLoc())
          << "rhs phys=[" << rhs.physStart << ", " << rhs.physEnd << ") live=["
          << rhs.start << ", " << rhs.end << "]";
      return failure();
    }
  }
  return success();
}

static LogicalResult
verifyNoInterference(func::FuncOp func,
                     ArrayRef<wave::WaveAMDLiveInterval> intervals,
                     ArrayRef<Operation *> orderedOps,
                     const DenseMap<Operation *, unsigned> &positions,
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
  if (failed(verifyReservedRanges(func, ranges, orderedOps, positions, consumer,
                                  regClass, reserved, regs)))
    return failure();
  return verifyNoRangeInterference(func, ranges, positions, consumer, regClass);
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
  if (failed(verifyFixedLoopCarryStorage(func, consumer)))
    return failure();
  FailureOr<WaveAMDLiveIntervalBuildResult> builtIntervals =
      buildAllocatedWaveAMDLiveIntervals(func);
  if (failed(builtIntervals))
    return failure();
  wave::WaveAMDKernelEntryRegs regs = wave::getWaveAMDKernelEntryRegs(func);
  if (failed(verifyNoInterference(func, builtIntervals->intervals.sgprs,
                                  builtIntervals->orderedOps,
                                  builtIntervals->positions, consumer, "SGPR",
                                  regs.reservedSGPRs, regs)))
    return failure();
  if (failed(verifyNoInterference(func, builtIntervals->intervals.vgprs,
                                  builtIntervals->orderedOps,
                                  builtIntervals->positions, consumer, "VGPR",
                                  regs.reservedVGPRs, regs)))
    return failure();
  return verifyNoInterference(func, builtIntervals->intervals.agprs,
                              builtIntervals->orderedOps,
                              builtIntervals->positions, consumer, "AGPR",
                              /*reserved=*/0, regs);
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
