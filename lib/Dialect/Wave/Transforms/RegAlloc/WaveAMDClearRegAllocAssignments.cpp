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
#include "mlir/IR/SymbolTable.h"
#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/DenseSet.h"
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

static Type getClearedRegAllocAssignmentType(Value value) {
  std::optional<waveamdmachine::RegType> type =
      wave::getRegAllocTransformTrackedRegType(value);
  if (!type || type->getIndex() < 0)
    return value.getType();
  return waveamdmachine::RegType::get(type->getContext(), type->getRegClass(),
                                      type->getWidth(),
                                      /*index=*/-1);
}

static void clearRegAllocAssignment(Value value) {
  value.setType(getClearedRegAllocAssignmentType(value));
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

static bool isMarkedFixedResult(OpResult result) {
  DenseI64ArrayAttr attr =
      result.getOwner()->getAttrOfType<DenseI64ArrayAttr>(kFixedResultsAttr);
  return attr &&
         llvm::is_contained(attr.asArrayRef(),
                            static_cast<int64_t>(result.getResultNumber()));
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

static int64_t getBlockNumber(Block *target) {
  for (auto [blockNumber, block] : llvm::enumerate(*target->getParent()))
    if (&block == target)
      return static_cast<int64_t>(blockNumber);
  llvm_unreachable("block missing from parent region");
}

static bool shouldPreserveBlockArgument(BlockArgument arg) {
  Region *region = arg.getOwner()->getParent();
  Operation *op = region->getParentOp();
  if (!op || isa<func::FuncOp>(op))
    return true;
  DenseI64ArrayAttr attr =
      op->getAttrOfType<DenseI64ArrayAttr>(kFixedBlockArgsAttr);
  if (!attr)
    return false;
  ArrayRef<int64_t> raw = attr.asArrayRef();
  int64_t regionNumber = region->getRegionNumber();
  int64_t blockNumber = getBlockNumber(arg.getOwner());
  for (size_t index = 0; index < raw.size(); index += kFixedBlockArgRecordSize)
    if (FixedBlockArgumentRecord{raw[index], raw[index + 1], raw[index + 2]} ==
        FixedBlockArgumentRecord{regionNumber, blockNumber, arg.getArgNumber()})
      return true;
  return false;
}

static bool shouldPreserveRegAllocAssignment(Value value) {
  if (auto result = dyn_cast<OpResult>(value))
    return isAuthoredFixedResult(result) || isMarkedFixedResult(result);
  auto arg = cast<BlockArgument>(value);
  return shouldPreserveBlockArgument(arg);
}

static Type
getTypeAfterClearing(Value value,
                     const DenseSet<Operation *> &functionsToClear) {
  Region *region = value.getParentRegion();
  func::FuncOp func =
      region ? region->getParentOfType<func::FuncOp>() : nullptr;
  if (!func || !functionsToClear.contains(func.getOperation()) ||
      shouldPreserveRegAllocAssignment(value))
    return value.getType();
  return getClearedRegAllocAssignmentType(value);
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

static LogicalResult validateRegAllocAssignmentMarkers(func::FuncOp func) {
  WalkResult walk = func.walk([](Operation *op) {
    if (isa<func::FuncOp>(op))
      return WalkResult::advance();
    SmallVector<int64_t, 4> fixedResults;
    SmallVector<FixedBlockArgumentRecord, 4> fixedArgs;
    if (failed(readFixedResultNumbers(op, fixedResults)) ||
        failed(readFixedBlockArgumentRecords(op, fixedArgs)) ||
        failed(validateFixedBlockArgumentRecords(op, fixedArgs)))
      return WalkResult::interrupt();
    return WalkResult::advance();
  });
  return success(!walk.wasInterrupted());
}

static FailureOr<FunctionType>
getFunctionTypeAfterClearing(func::FuncOp func,
                             const DenseSet<Operation *> &functionsToClear) {
  if (func.isDeclaration())
    return func.getFunctionType();
  SmallVector<Type> inputs(func.getBody().front().getArgumentTypes());
  SmallVector<Type> outputs;
  func::ReturnOp firstReturn;
  for (Block &block : func.getBody()) {
    auto ret = dyn_cast<func::ReturnOp>(block.getTerminator());
    if (!ret)
      continue;
    SmallVector<Type> current;
    current.reserve(ret.getNumOperands());
    for (Value operand : ret.getOperands())
      current.push_back(getTypeAfterClearing(operand, functionsToClear));
    if (!firstReturn) {
      firstReturn = ret;
      outputs = std::move(current);
      continue;
    }
    if (outputs != current)
      return ret.emitError(kPassName)
             << " would make function returns inconsistent after clearing "
                "assignments";
  }
  if (!firstReturn)
    outputs.assign(func.getFunctionType().getResults().begin(),
                   func.getFunctionType().getResults().end());
  return FunctionType::get(func.getContext(), inputs, outputs);
}

static LogicalResult buildRegAllocAssignmentClearPlans(
    ModuleOp root, SmallVectorImpl<func::FuncOp> &funcs,
    DenseSet<Operation *> &functionsToClear,
    DenseMap<Operation *, FunctionType> &plannedTypes) {
  root.walk([&](func::FuncOp func) { funcs.push_back(func); });
  for (func::FuncOp func : funcs) {
    if (!shouldClearRegAllocAssignments(func))
      continue;
    functionsToClear.insert(func.getOperation());
    if (failed(validateRegAllocAssignmentMarkers(func)))
      return failure();
  }
  for (func::FuncOp func : funcs) {
    if (!functionsToClear.contains(func.getOperation()))
      continue;
    FailureOr<FunctionType> type =
        getFunctionTypeAfterClearing(func, functionsToClear);
    if (failed(type))
      return failure();
    plannedTypes[func.getOperation()] = *type;
  }
  return success();
}

static func::FuncOp resolveCallCallee(func::CallOp call) {
  return SymbolTable::lookupNearestSymbolFrom<func::FuncOp>(
      call, call.getCalleeAttr());
}

static LogicalResult validateChangedFunctionSymbolUsers(
    ModuleOp root, ArrayRef<func::FuncOp> funcs,
    const DenseMap<Operation *, FunctionType> &plannedTypes) {
  for (func::FuncOp func : funcs) {
    FunctionType plannedType = plannedTypes.lookup(func.getOperation());
    if (!plannedType || plannedType == func.getFunctionType())
      continue;
    std::optional<SymbolTable::UseRange> uses =
        SymbolTable::getSymbolUses(func.getOperation(), root.getOperation());
    if (!uses)
      return func.emitError(kPassName)
             << " cannot prove signature-changing symbol users are safe";
    for (const SymbolTable::SymbolUse &use : *uses) {
      auto call = dyn_cast<func::CallOp>(use.getUser());
      if (!call || resolveCallCallee(call) != func)
        return use.getUser()->emitError(kPassName)
               << " does not support this signature-changing symbol user";
    }
  }
  return success();
}

static bool
valueTypesMatchAfterClearing(ValueRange values, TypeRange types,
                             const DenseSet<Operation *> &functionsToClear) {
  if (values.size() != types.size())
    return false;
  for (auto [value, type] : llvm::zip(values, types))
    if (getTypeAfterClearing(value, functionsToClear) != type)
      return false;
  return true;
}

static LogicalResult validateRegAllocAssignmentCallBoundaries(
    ModuleOp root, const DenseSet<Operation *> &functionsToClear,
    const DenseMap<Operation *, FunctionType> &plannedTypes) {
  WalkResult walk = root.walk([&](func::CallOp call) {
    func::FuncOp caller = call->getParentOfType<func::FuncOp>();
    bool callerChanges =
        caller && functionsToClear.contains(caller.getOperation());
    func::FuncOp callee = resolveCallCallee(call);
    if (!callee) {
      if (!callerChanges)
        return WalkResult::advance();
      call.emitError(kPassName)
          << " cannot resolve callee `" << call.getCallee()
          << "` before clearing assignments";
      return WalkResult::interrupt();
    }
    FunctionType calleeType = plannedTypes.lookup(callee.getOperation());
    if (!calleeType)
      calleeType = callee.getFunctionType();
    bool calleeChanges = calleeType != callee.getFunctionType();
    if (!callerChanges && !calleeChanges)
      return WalkResult::advance();
    if (!valueTypesMatchAfterClearing(
            call.getOperands(), calleeType.getInputs(), functionsToClear) ||
        !valueTypesMatchAfterClearing(
            call.getResults(), calleeType.getResults(), functionsToClear)) {
      call.emitError(kPassName) << " would make call to `" << call.getCallee()
                                << "` type-inconsistent";
      return WalkResult::interrupt();
    }
    return WalkResult::advance();
  });
  return success(!walk.wasInterrupted());
}

static LogicalResult applyRegAllocAssignmentClear(func::FuncOp func,
                                                  FunctionType plannedType) {
  WalkResult walk = func.walk([](Operation *op) {
    if (isa<func::FuncOp>(op))
      return WalkResult::advance();
    if (failed(clearResultAssignments(op)) ||
        failed(clearBlockArgumentAssignments(op)))
      return WalkResult::interrupt();
    return WalkResult::advance();
  });
  if (walk.wasInterrupted())
    return failure();
  if (!func.isDeclaration())
    func.setType(plannedType);
  func->removeAttr(wave::getRegAllocTransformAssignmentsAttrName());
  wave::invalidateRegAllocPreparation(func);
  wave::clearRegAllocTransformState(func);
  return success();
}

static LogicalResult clearRegAllocAssignments(ModuleOp root) {
  SmallVector<func::FuncOp> funcs;
  DenseSet<Operation *> functionsToClear;
  DenseMap<Operation *, FunctionType> plannedTypes;
  if (failed(buildRegAllocAssignmentClearPlans(root, funcs, functionsToClear,
                                               plannedTypes)) ||
      failed(validateChangedFunctionSymbolUsers(root, funcs, plannedTypes)) ||
      failed(validateRegAllocAssignmentCallBoundaries(root, functionsToClear,
                                                      plannedTypes)))
    return failure();
  for (func::FuncOp func : funcs) {
    if (!functionsToClear.contains(func.getOperation()))
      continue;
    if (failed(applyRegAllocAssignmentClear(
            func, plannedTypes.lookup(func.getOperation()))))
      return failure();
  }
  return success();
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
