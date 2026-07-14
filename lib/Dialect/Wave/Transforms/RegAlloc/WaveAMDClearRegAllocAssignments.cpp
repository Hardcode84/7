//===- WaveAMDClearRegAllocAssignments.cpp - Regalloc reset --------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "WaveAMDRegAllocTransformState.h"

#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/Wave/Transforms/Passes.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachine.h"
#include "mlir/IR/BuiltinOps.h"
#include "llvm/ADT/STLExtras.h"

namespace mlir::wave {
#define GEN_PASS_DEF_WAVEAMDCLEARREGALLOCASSIGNMENTS
#include "mlir/Dialect/Wave/Transforms/Passes.h.inc"
} // namespace mlir::wave

using namespace mlir;

namespace {

static constexpr llvm::StringLiteral kPassName =
    "waveamd-clear-regalloc-assignments";
static constexpr llvm::StringLiteral kFixedBlockArgsAttr =
    "waveamdmachine.regalloc_fixed_block_args";
static constexpr llvm::StringLiteral kFixedResultsAttr =
    "waveamdmachine.regalloc_fixed_results";
static constexpr llvm::StringLiteral kLDSSpillBytesAttr =
    "waveamdmachine.lds_spill_bytes";
static constexpr llvm::StringLiteral kScratchSpillBytesAttr =
    "waveamdmachine.scratch_spill_bytes";
static constexpr unsigned kFixedBlockArgRecordSize = 3;

struct FixedBlockArgumentRecord {
  int64_t regionNumber;
  int64_t blockNumber;
  int64_t argumentNumber;
};

static bool operator==(const FixedBlockArgumentRecord &lhs,
                       const FixedBlockArgumentRecord &rhs) {
  return lhs.regionNumber == rhs.regionNumber &&
         lhs.blockNumber == rhs.blockNumber &&
         lhs.argumentNumber == rhs.argumentNumber;
}

static bool isAuthoredFixedResult(OpResult result) {
  Operation *op = result.getOwner();
  return isa<waveamdmachine::KernargPreloadOp, waveamdmachine::SWorkgroupIdXOp,
             waveamdmachine::SWorkgroupIdYOp, waveamdmachine::SWorkgroupIdZOp,
             waveamdmachine::UninitOp, waveamdmachine::VWorkitemIdXOp,
             waveamdmachine::VWorkitemIdYOp, waveamdmachine::VWorkitemIdZOp>(
      op);
}

static void clearRegAllocAssignment(Value value) {
  std::optional<waveamdmachine::RegType> type =
      wave::getRegAllocTransformTrackedRegType(value);
  if (!type || type->getIndex() < 0)
    return;
  value.setType(waveamdmachine::RegType::get(
      type->getContext(), type->getRegClass(), type->getWidth(),
      /*index=*/-1));
}

static LogicalResult readFixedResultNumbers(Operation *op,
                                            SmallVectorImpl<int64_t> &results) {
  DenseI64ArrayAttr attr =
      op->getAttrOfType<DenseI64ArrayAttr>(kFixedResultsAttr);
  if (!attr)
    return success();
  for (int64_t resultNumber : attr.asArrayRef()) {
    if (resultNumber < 0 ||
        static_cast<unsigned>(resultNumber) >= op->getNumResults())
      return op->emitError(kPassName)
             << " has invalid register assignment marker";
    results.push_back(resultNumber);
  }
  return success();
}

static LogicalResult clearResultAssignments(Operation *op) {
  SmallVector<int64_t, 4> fixedResults;
  if (failed(readFixedResultNumbers(op, fixedResults)))
    return failure();
  for (OpResult result : op->getResults()) {
    if (llvm::is_contained(fixedResults,
                           static_cast<int64_t>(result.getResultNumber())))
      continue;
    if (isAuthoredFixedResult(result))
      continue;
    clearRegAllocAssignment(result);
  }
  op->removeAttr(kFixedResultsAttr);
  return success();
}

static LogicalResult readFixedBlockArgumentRecords(
    Operation *op, SmallVectorImpl<FixedBlockArgumentRecord> &records) {
  DenseI64ArrayAttr attr =
      op->getAttrOfType<DenseI64ArrayAttr>(kFixedBlockArgsAttr);
  if (!attr)
    return success();
  ArrayRef<int64_t> raw = attr.asArrayRef();
  if (raw.size() % kFixedBlockArgRecordSize != 0)
    return op->emitError(kPassName)
           << " has malformed register assignment markers";
  size_t count = raw.size() / kFixedBlockArgRecordSize;
  for (size_t recordNumber : llvm::seq<size_t>(0, count)) {
    size_t index = recordNumber * kFixedBlockArgRecordSize;
    records.push_back({raw[index], raw[index + 1], raw[index + 2]});
  }
  return success();
}

static Block *getBlockAt(Region &region, int64_t blockNumber) {
  if (blockNumber < 0)
    return nullptr;
  for (auto [index, block] : llvm::enumerate(region))
    if (static_cast<int64_t>(index) == blockNumber)
      return &block;
  return nullptr;
}

static LogicalResult
validateFixedBlockArgumentRecords(Operation *op,
                                  ArrayRef<FixedBlockArgumentRecord> records) {
  for (const FixedBlockArgumentRecord &record : records) {
    if (record.regionNumber < 0 ||
        static_cast<unsigned>(record.regionNumber) >= op->getNumRegions())
      return op->emitError(kPassName)
             << " has invalid register assignment marker";
    Region &region = op->getRegion(static_cast<unsigned>(record.regionNumber));
    Block *block = getBlockAt(region, record.blockNumber);
    if (!block || record.argumentNumber < 0 ||
        static_cast<unsigned>(record.argumentNumber) >=
            block->getNumArguments())
      return op->emitError(kPassName)
             << " has invalid register assignment marker";
  }
  return success();
}

static bool isFixedBlockArgument(ArrayRef<FixedBlockArgumentRecord> fixedArgs,
                                 int64_t regionNumber, int64_t blockNumber,
                                 int64_t argumentNumber) {
  return llvm::is_contained(
      fixedArgs,
      FixedBlockArgumentRecord{regionNumber, blockNumber, argumentNumber});
}

static LogicalResult
clearRegionBlockArguments(Region &region, int64_t regionNumber,
                          ArrayRef<FixedBlockArgumentRecord> fixedArgs) {
  for (auto [blockNumber, block] : llvm::enumerate(region)) {
    for (BlockArgument arg : block.getArguments()) {
      if (isFixedBlockArgument(fixedArgs, regionNumber, blockNumber,
                               arg.getArgNumber()))
        continue;
      clearRegAllocAssignment(arg);
    }
  }
  return success();
}

static LogicalResult clearBlockArgumentAssignments(Operation *op) {
  SmallVector<FixedBlockArgumentRecord, 4> fixedArgs;
  if (failed(readFixedBlockArgumentRecords(op, fixedArgs)))
    return failure();
  if (failed(validateFixedBlockArgumentRecords(op, fixedArgs)))
    return failure();
  for (auto [regionNumber, region] : llvm::enumerate(op->getRegions()))
    if (failed(clearRegionBlockArguments(region, regionNumber, fixedArgs)))
      return failure();
  op->removeAttr(kFixedBlockArgsAttr);
  return success();
}

static bool shouldClearRegAllocAssignments(func::FuncOp func) {
  return func->hasAttr(wave::getRegAllocTransformAssignmentsAttrName()) ||
         func->hasAttr(wave::getRegAllocTransformStateAttrName()) ||
         func->hasAttr(kLDSSpillBytesAttr) ||
         func->hasAttr(kScratchSpillBytesAttr);
}

static LogicalResult clearRegAllocAssignments(func::FuncOp func) {
  if (!shouldClearRegAllocAssignments(func))
    return success();
  WalkResult walk = func.walk([](Operation *op) {
    if (isa<func::FuncOp>(op))
      return WalkResult::advance();
    if (failed(clearResultAssignments(op)) ||
        failed(clearBlockArgumentAssignments(op)))
      return WalkResult::interrupt();
    return WalkResult::advance();
  });
  func->removeAttr(wave::getRegAllocTransformAssignmentsAttrName());
  wave::clearRegAllocTransformState(func);
  return success(!walk.wasInterrupted());
}

static LogicalResult clearRegAllocAssignments(ModuleOp root) {
  WalkResult walk = root->walk([](func::FuncOp func) {
    return failed(clearRegAllocAssignments(func)) ? WalkResult::interrupt()
                                                  : WalkResult::advance();
  });
  return success(!walk.wasInterrupted());
}

struct WaveAMDClearRegAllocAssignmentsPass
    : public wave::impl::WaveAMDClearRegAllocAssignmentsBase<
          WaveAMDClearRegAllocAssignmentsPass> {
  using WaveAMDClearRegAllocAssignmentsBase::
      WaveAMDClearRegAllocAssignmentsBase;

  void runOnOperation() override {
    if (failed(clearRegAllocAssignments(getOperation())))
      return signalPassFailure();
  }
};

} // namespace
