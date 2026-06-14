//===- WaveAMDRegAlloc.cpp - WaveAMD register allocation -------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/Wave/Transforms/Passes.h"

#include "WaveAMDHardwareResources.h"
#include "WaveAMDRegAllocInternal.h"
#include "WaveAMDRegAllocPrep.h"
#include "WaveAMDRegPressureRelief.h"
#include "WaveAMDRegisterLimits.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/Wave/Transforms/WaveAMDRegAllocVerification.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachine.h"
#include "mlir/IR/BuiltinOps.h"
#include "mlir/IR/Remarks.h"
#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/DenseSet.h"
#include "llvm/ADT/STLExtras.h"
#include <algorithm>
#include <limits>
#include <memory>
#include <optional>
#include <tuple>

namespace mlir::wave {
#define GEN_PASS_DEF_WAVEAMDCLEARREGALLOCASSIGNMENTS
#define GEN_PASS_DEF_WAVEAMDREGALLOC
#include "mlir/Dialect/Wave/Transforms/Passes.h.inc"
} // namespace mlir::wave

using namespace mlir;
using namespace mlir::wave::regalloc;

unsigned mlir::wave::regalloc::getPlannedProviderBytes(Inventory &inventory,
                                                       StringRef provider) {
  return inventory.plannedProviderBytes.lookup(provider);
}

void mlir::wave::regalloc::addPlannedProviderBytes(Inventory &inventory,
                                                   StringRef provider,
                                                   unsigned bytes) {
  inventory.plannedProviderBytes[provider] =
      inventory.plannedProviderBytes.lookup(provider) + bytes;
}

void mlir::wave::regalloc::recordPlannedPressureRelief(
    Inventory &inventory,
    std::unique_ptr<wave::WaveAMDPressureReliefPlan> plan) {
  inventory.plannedReliefPlans.push_back(std::move(plan));
}

namespace {

static constexpr llvm::StringLiteral kPassName = "waveamd-reg-alloc";
static constexpr llvm::StringLiteral kTargetWavesAttr =
    "waveamdmachine.target_waves";
static constexpr llvm::StringLiteral kLegacyOverflowedAttr =
    "waveamdmachine.regalloc_overflowed";
static constexpr llvm::StringLiteral kLegacyOverflowCountAttr =
    "waveamdmachine.regalloc_overflowed_count";
static constexpr llvm::StringLiteral kLegacyPressureClassAttr =
    "waveamdmachine.regalloc_pressure_class";
static constexpr llvm::StringLiteral kLegacyPressureLimitAttr =
    "waveamdmachine.regalloc_pressure_limit";
static constexpr llvm::StringLiteral kLegacyPressureLiveAttr =
    "waveamdmachine.regalloc_pressure_live_dwords";
static constexpr llvm::StringLiteral kLegacyPressureOverlapsAttr =
    "waveamdmachine.regalloc_pressure_overlaps";
static constexpr llvm::StringLiteral kLegacyPressurePositionAttr =
    "waveamdmachine.regalloc_pressure_position";
static constexpr llvm::StringLiteral kLegacyPressureReliefAttr =
    "waveamdmachine.regalloc_pressure_required_relief";
static constexpr llvm::StringLiteral kLegacyPressureRequestAttr =
    "waveamdmachine.regalloc_pressure_request";
static constexpr llvm::StringLiteral kLegacyPressureReservedAttr =
    "waveamdmachine.regalloc_pressure_reserved";
static constexpr unsigned kRewriteAttemptLimit = 512;
static constexpr llvm::StringLiteral kFlatOpsAttr =
    "waveamdmachine.regalloc_debug_flat_ops";
static constexpr llvm::StringLiteral kIntervalsAttr =
    "waveamdmachine.regalloc_debug_intervals";
static constexpr llvm::StringLiteral kLDSSpillPlanAttr =
    "waveamdmachine.regalloc_debug_lds_spill_plan";
static constexpr llvm::StringLiteral kScratchSpillPlanAttr =
    "waveamdmachine.regalloc_debug_scratch_spill_plan";
static constexpr llvm::StringLiteral kOverflowCountAttr =
    "waveamdmachine.regalloc_debug_overflowed_count";
static constexpr llvm::StringLiteral kOverflowedAttr =
    "waveamdmachine.regalloc_debug_overflowed";
static constexpr llvm::StringLiteral kPeakAGPRAttr =
    "waveamdmachine.regalloc_debug_peak_agpr";
static constexpr llvm::StringLiteral kPeakSGPRAttr =
    "waveamdmachine.regalloc_debug_peak_sgpr";
static constexpr llvm::StringLiteral kPeakVGPRAttr =
    "waveamdmachine.regalloc_debug_peak_vgpr";
static constexpr llvm::StringLiteral kPressureClassAttr =
    "waveamdmachine.regalloc_debug_pressure_class";
static constexpr llvm::StringLiteral kPressureLimitAttr =
    "waveamdmachine.regalloc_debug_pressure_limit";
static constexpr llvm::StringLiteral kPressureLiveAttr =
    "waveamdmachine.regalloc_debug_pressure_live_dwords";
static constexpr llvm::StringLiteral kRemarkCategory =
    "waveamdmachine-regalloc";
static constexpr llvm::StringLiteral kScalarIntervalsAttr =
    "waveamdmachine.regalloc_debug_scalar_intervals";
static constexpr llvm::StringLiteral kTrackedValuesAttr =
    "waveamdmachine.regalloc_debug_tracked_values";
static constexpr llvm::StringLiteral kTempAttr = kRegAllocTempAttr;
static constexpr llvm::StringLiteral kFixedBlockArgsAttr =
    "waveamdmachine.regalloc_fixed_block_args";
static constexpr llvm::StringLiteral kFixedResultsAttr =
    "waveamdmachine.regalloc_fixed_results";
static constexpr unsigned kFixedBlockArgRecordSize = 3;

static bool isAllocRegClass(waveamdmachine::RegClass regClass) {
  return regClass == waveamdmachine::RegClass::SGPR ||
         regClass == waveamdmachine::RegClass::VGPR ||
         regClass == waveamdmachine::RegClass::AGPR;
}

static bool shouldRecordRegAllocAssignments(func::FuncOp func) {
  return func->hasAttr(kLDSSpillBytesAttr) ||
         func->hasAttr(kScratchSpillBytesAttr);
}

static std::optional<waveamdmachine::RegType> getTrackedType(Value value) {
  auto type = dyn_cast<waveamdmachine::RegType>(value.getType());
  if (!type || !isAllocRegClass(type.getRegClass()))
    return std::nullopt;
  return type;
}

static StringRef getRegClassName(waveamdmachine::RegClass regClass) {
  if (regClass == waveamdmachine::RegClass::SGPR)
    return "SGPR";
  if (regClass == waveamdmachine::RegClass::VGPR)
    return "VGPR";
  if (regClass == waveamdmachine::RegClass::AGPR)
    return "AGPR";
  return "unsupported";
}

static unsigned getBudget(RegisterBudgets budgets,
                          waveamdmachine::RegClass regClass) {
  if (regClass == waveamdmachine::RegClass::SGPR)
    return budgets.sgpr;
  if (regClass == waveamdmachine::RegClass::VGPR)
    return budgets.vgpr;
  if (regClass == waveamdmachine::RegClass::AGPR)
    return budgets.agpr;
  return 0;
}

static unsigned getAddressable(RegisterBudgets budgets,
                               waveamdmachine::RegClass regClass) {
  if (regClass == waveamdmachine::RegClass::SGPR)
    return budgets.addressableSGPR;
  if (regClass == waveamdmachine::RegClass::VGPR)
    return budgets.addressableVGPR;
  if (regClass == waveamdmachine::RegClass::AGPR)
    return budgets.addressableAGPR;
  return 0;
}

static RegisterBudgets applyLimitOverrides(RegisterBudgets budgets,
                                           int sgprLimit, int vgprLimit,
                                           int agprLimit) {
  if (sgprLimit >= 0)
    budgets.sgpr = std::min(budgets.sgpr, static_cast<unsigned>(sgprLimit));
  if (vgprLimit >= 0)
    budgets.vgpr = std::min(budgets.vgpr, static_cast<unsigned>(vgprLimit));
  if (agprLimit >= 0)
    budgets.agpr = std::min(budgets.agpr, static_cast<unsigned>(agprLimit));
  return budgets;
}

static Attribute findTargetWavesAttr(Operation *op) {
  for (Operation *cur = op; cur; cur = cur->getParentOp())
    if (Attribute attr = cur->getAttr(kTargetWavesAttr))
      return attr;
  return {};
}

static FailureOr<unsigned> getTargetWaves(func::FuncOp func,
                                          RegisterBudgets budgets) {
  Attribute attr = findTargetWavesAttr(func);
  if (!attr)
    return 0;
  IntegerAttr intAttr = dyn_cast<IntegerAttr>(attr);
  if (!intAttr)
    return func.emitError(kPassName)
           << " " << kTargetWavesAttr << " must be an integer attribute";
  int64_t value = intAttr.getInt();
  if (value <= 0)
    return func.emitError(kPassName)
           << " " << kTargetWavesAttr << " must be positive";
  if (static_cast<uint64_t>(value) > budgets.maxWavesPerEU)
    return func.emitError(kPassName)
           << " " << kTargetWavesAttr << " exceeds target wave capacity";
  return static_cast<unsigned>(value);
}

static LogicalResult applyTargetWavesLimits(func::FuncOp func,
                                            RegisterBudgets &budgets) {
  FailureOr<unsigned> targetWaves = getTargetWaves(func, budgets);
  if (failed(targetWaves))
    return mlir::failure();
  if (*targetWaves == 0)
    return success();

  unsigned vgprBudget = wave::getMaxWaveAMDRegisterBudgetForWaves(
      budgets.maxVGPRsForWaves, *targetWaves);
  unsigned sgprBudget = wave::getMaxWaveAMDRegisterBudgetForWaves(
      budgets.maxSGPRsForWaves, *targetWaves);
  if (vgprBudget == 0 || sgprBudget == 0)
    return func.emitError(kPassName)
           << " " << kTargetWavesAttr
           << " has no register budget for this target";

  budgets.totalVGPRLimit = vgprBudget;
  budgets.vgpr = std::min(budgets.vgpr, vgprBudget);
  budgets.sgpr = std::min(budgets.sgpr, sgprBudget);
  budgets.targetWaves = *targetWaves;
  return success();
}

static std::optional<waveamdmachine::RegClass>
getNextRegClass(waveamdmachine::RegClass regClass) {
  if (regClass == waveamdmachine::RegClass::SGPR)
    return waveamdmachine::RegClass::VGPR;
  if (regClass == waveamdmachine::RegClass::VGPR)
    return waveamdmachine::RegClass::AGPR;
  return std::nullopt;
}

static waveamdmachine::RegType getRegType(Value value,
                                          waveamdmachine::RegClass regClass) {
  auto type = cast<waveamdmachine::RegType>(value.getType());
  return waveamdmachine::RegType::get(type.getContext(), regClass,
                                      type.getWidth(), /*index=*/-1);
}

static Operation *diagOpForValue(Value value, func::FuncOp func) {
  if (Operation *def = value.getDefiningOp())
    return def;
  if (auto arg = dyn_cast<BlockArgument>(value))
    if (Operation *parent = arg.getOwner()->getParentOp())
      return parent;
  return func;
}

static FailureOr<unsigned> checkedUnsigned(int64_t value, Operation *diagOp,
                                           StringRef what) {
  if (value < 0 ||
      static_cast<uint64_t>(value) > std::numeric_limits<unsigned>::max())
    return diagOp->emitError()
           << kPassName << " " << what << " exceeds supported range";
  return static_cast<unsigned>(value);
}

static LogicalResult validateTrackedType(Value value, func::FuncOp func) {
  std::optional<waveamdmachine::RegType> type = getTrackedType(value);
  if (!type)
    return success();
  if (failed(checkedUnsigned(type->getWidth(), func, "register width")))
    return failure();
  if (type->getIndex() >= 0 &&
      failed(checkedUnsigned(type->getIndex(), diagOpForValue(value, func),
                             "fixed register index")))
    return failure();
  return success();
}

static void setRegClass(Value value, waveamdmachine::RegClass regClass) {
  value.setType(getRegType(value, regClass));
}

static void flatten(Block &block, Inventory &inventory) {
  for (Operation &op : block) {
    inventory.positions[&op] = inventory.ops.size();
    inventory.ops.push_back(&op);
    for (Region &region : op.getRegions())
      for (Block &nested : region)
        flatten(nested, inventory);
  }
}

static std::optional<int64_t> getRegionNumber(Operation *op, Region *region) {
  for (auto [index, candidate] : llvm::enumerate(op->getRegions()))
    if (&candidate == region)
      return static_cast<int64_t>(index);
  return std::nullopt;
}

static std::optional<int64_t> getBlockNumber(Region *region, Block *block) {
  for (auto [index, candidate] : llvm::enumerate(*region))
    if (&candidate == block)
      return static_cast<int64_t>(index);
  return std::nullopt;
}

struct FixedBlockArgumentRecord {
  int64_t regionNumber;
  int64_t blockNumber;
  int64_t argumentNumber;
};

static bool operator<(const FixedBlockArgumentRecord &lhs,
                      const FixedBlockArgumentRecord &rhs) {
  return std::tie(lhs.regionNumber, lhs.blockNumber, lhs.argumentNumber) <
         std::tie(rhs.regionNumber, rhs.blockNumber, rhs.argumentNumber);
}

static bool operator==(const FixedBlockArgumentRecord &lhs,
                       const FixedBlockArgumentRecord &rhs) {
  return lhs.regionNumber == rhs.regionNumber &&
         lhs.blockNumber == rhs.blockNumber &&
         lhs.argumentNumber == rhs.argumentNumber;
}

static LogicalResult markFixedResult(OpResult result, Builder &builder) {
  Operation *op = result.getOwner();
  int64_t resultNumber = result.getResultNumber();
  DenseI64ArrayAttr oldAttr =
      op->getAttrOfType<DenseI64ArrayAttr>(kFixedResultsAttr);
  SmallVector<int64_t> results;
  if (oldAttr)
    results.append(oldAttr.asArrayRef().begin(), oldAttr.asArrayRef().end());
  if (llvm::is_contained(results, resultNumber))
    return success();
  results.push_back(resultNumber);
  llvm::sort(results);
  results.erase(std::unique(results.begin(), results.end()), results.end());
  op->setAttr(kFixedResultsAttr, builder.getDenseI64ArrayAttr(results));
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

static void
writeFixedBlockArgumentRecords(Operation *op,
                               ArrayRef<FixedBlockArgumentRecord> records,
                               Builder &builder) {
  SmallVector<int64_t> raw;
  for (const FixedBlockArgumentRecord &record : records)
    raw.append(
        {record.regionNumber, record.blockNumber, record.argumentNumber});
  op->setAttr(kFixedBlockArgsAttr, builder.getDenseI64ArrayAttr(raw));
}

static LogicalResult markFixedBlockArgument(BlockArgument arg,
                                            Builder &builder) {
  Block *block = arg.getOwner();
  Region *region = block->getParent();
  Operation *parent = region->getParentOp();
  if (isa<func::FuncOp>(parent))
    return success();
  std::optional<int64_t> regionNumber = getRegionNumber(parent, region);
  std::optional<int64_t> blockNumber = getBlockNumber(region, block);
  if (!regionNumber || !blockNumber)
    return failure();
  FixedBlockArgumentRecord record{*regionNumber, *blockNumber,
                                  arg.getArgNumber()};
  SmallVector<FixedBlockArgumentRecord, 4> records;
  if (failed(readFixedBlockArgumentRecords(parent, records)))
    return failure();
  if (!llvm::is_contained(records, record))
    records.push_back(record);
  llvm::sort(records);
  records.erase(std::unique(records.begin(), records.end()), records.end());
  writeFixedBlockArgumentRecords(parent, records, builder);
  return success();
}

static LogicalResult markFixedValue(Value value, Builder &builder) {
  if (auto result = dyn_cast<OpResult>(value))
    return markFixedResult(result, builder);
  return markFixedBlockArgument(cast<BlockArgument>(value), builder);
}

static void clearRegAllocAssignment(Value value) {
  auto type = dyn_cast<waveamdmachine::RegType>(value.getType());
  if (!type || !isAllocRegClass(type.getRegClass()) || type.getIndex() < 0)
    return;
  value.setType(waveamdmachine::RegType::get(
      type.getContext(), type.getRegClass(), type.getWidth(), /*index=*/-1));
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
    clearRegAllocAssignment(result);
  }
  op->removeAttr(kFixedResultsAttr);
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

static LogicalResult clearRegAllocAssignments(ModuleOp root) {
  WalkResult walk = root->walk([](Operation *op) {
    if (isa<func::FuncOp>(op))
      return WalkResult::advance();
    func::FuncOp func = op->getParentOfType<func::FuncOp>();
    if (!func || !shouldRecordRegAllocAssignments(func))
      return WalkResult::advance();
    if (failed(clearResultAssignments(op)) ||
        failed(clearBlockArgumentAssignments(op)))
      return WalkResult::interrupt();
    return WalkResult::advance();
  });
  return success(!walk.wasInterrupted());
}

static LogicalResult validateBlockRegTypes(Block &block, func::FuncOp func) {
  for (BlockArgument arg : block.getArguments())
    if (failed(validateTrackedType(arg, func)))
      return failure();
  return success();
}

static LogicalResult validateOperationRegTypes(Operation *op,
                                               func::FuncOp func) {
  for (Value operand : op->getOperands())
    if (failed(validateTrackedType(operand, func)))
      return failure();
  for (Value result : op->getResults())
    if (failed(validateTrackedType(result, func)))
      return failure();
  for (Region &region : op->getRegions())
    for (Block &block : region)
      if (failed(validateBlockRegTypes(block, func)))
        return failure();
  return success();
}

static LogicalResult validateFunctionRegTypes(func::FuncOp func) {
  for (Block &block : func.getBody())
    if (failed(validateBlockRegTypes(block, func)))
      return failure();

  WalkResult walk = func.walk([&](Operation *op) {
    return failed(validateOperationRegTypes(op, func)) ? WalkResult::interrupt()
                                                       : WalkResult::advance();
  });
  return success(!walk.wasInterrupted());
}

static unsigned getStart(Value value, Inventory &inventory, unsigned fallback) {
  if (Operation *def = value.getDefiningOp())
    return inventory.positions.lookup(def);
  Operation *parent = cast<BlockArgument>(value).getOwner()->getParentOp();
  if (isa_and_nonnull<func::FuncOp>(parent))
    return 0;
  auto it = inventory.positions.find(parent);
  return it == inventory.positions.end() ? fallback : it->second;
}

static std::unique_ptr<Interval>
makeScalarInterval(MLIRContext *ctx, waveamdmachine::RegClass cls,
                   int64_t index, unsigned start, unsigned end) {
  std::unique_ptr<Interval> interval = std::make_unique<Interval>();
  interval->type = waveamdmachine::RegType::get(ctx, cls, /*width=*/1, index);
  interval->start = start;
  interval->end = end;
  return interval;
}

static Interval *ensureInterval(Value value, Inventory &inventory,
                                unsigned fallback) {
  if (auto it = inventory.intervalFor.find(value);
      it != inventory.intervalFor.end())
    return it->second;
  std::optional<waveamdmachine::RegType> type = getTrackedType(value);
  assert(type && "caller checked tracked type");

  unsigned start = getStart(value, inventory, fallback);
  std::unique_ptr<IntervalGroup> group = std::make_unique<IntervalGroup>();
  IntervalGroup *groupPtr = group.get();
  groupPtr->preferredClass = type->getRegClass();
  groupPtr->storageClass = type->getRegClass();
  groupPtr->order = inventory.groups.size();
  inventory.groups.push_back(std::move(group));

  Interval *first = nullptr;
  for (unsigned offset : llvm::seq<unsigned>(0, type->getWidth())) {
    std::unique_ptr<Interval> interval = makeScalarInterval(
        type->getContext(), type->getRegClass(),
        type->getIndex() < 0 ? -1 : type->getIndex() + offset, start, start);
    interval->values.insert(value);
    interval->group = groupPtr;
    if (auto arg = dyn_cast<BlockArgument>(value))
      if (isa<func::FuncOp>(arg.getOwner()->getParentOp())) {
        interval->nonPromotable = true;
        groupPtr->nonPromotable = true;
        groupPtr->allocatable = false;
      }
    if (Operation *def = value.getDefiningOp();
        def && def->hasAttr(kTempAttr)) {
      interval->nonPromotable = true;
      groupPtr->nonPromotable = true;
    }
    Interval *intervalPtr = interval.get();
    if (!first)
      first = intervalPtr;
    groupPtr->intervals.push_back(intervalPtr);
    inventory.intervals.push_back(std::move(interval));
  }
  inventory.intervalFor[value] = first;
  inventory.scalarIntervals += groupPtr->intervals.size();
  return first;
}

static void createInterval(Value value, Inventory &inventory,
                           unsigned fallback) {
  if (getTrackedType(value))
    (void)ensureInterval(value, inventory, fallback);
}

static void extendInterval(Value value, Inventory &inventory,
                           unsigned position) {
  if (!getTrackedType(value))
    return;
  (void)ensureInterval(value, inventory, position);
  for (const std::unique_ptr<Interval> &interval : inventory.intervals)
    if (interval->values.contains(value))
      interval->end = std::max(interval->end, position);
}

static void createReservedGroup(Inventory &inventory, MLIRContext *ctx,
                                waveamdmachine::RegClass regClass,
                                unsigned width, unsigned end) {
  if (width == 0)
    return;
  std::unique_ptr<IntervalGroup> group = std::make_unique<IntervalGroup>();
  IntervalGroup *groupPtr = group.get();
  groupPtr->preferredClass = regClass;
  groupPtr->storageClass = regClass;
  groupPtr->fixedBase = 0;
  groupPtr->order = inventory.groups.size();
  groupPtr->reserved = true;
  groupPtr->nonPromotable = true;
  inventory.groups.push_back(std::move(group));

  for (unsigned offset : llvm::seq<unsigned>(0, width)) {
    std::unique_ptr<Interval> interval =
        makeScalarInterval(ctx, regClass, offset, /*start=*/0, end);
    interval->group = groupPtr;
    interval->reserved = true;
    interval->nonPromotable = true;
    groupPtr->intervals.push_back(interval.get());
    inventory.intervals.push_back(std::move(interval));
  }
}

static void createReservedABIIntervals(func::FuncOp func,
                                       Inventory &inventory) {
  unsigned end = inventory.ops.empty() ? 0 : inventory.ops.size() - 1;
  MLIRContext *ctx = func.getContext();
  createReservedGroup(inventory, ctx, waveamdmachine::RegClass::SGPR,
                      wave::getWaveAMDReservedSGPRs(func), end);
  createReservedGroup(inventory, ctx, waveamdmachine::RegClass::VGPR,
                      wave::getWaveAMDReservedVGPRs(func), end);
}

static std::optional<unsigned> getLaneIndex(IntervalGroup *group,
                                            Interval *interval) {
  for (auto [index, lane] : llvm::enumerate(group->intervals))
    if (lane == interval)
      return index;
  return std::nullopt;
}

static LogicalResult mergeLane(Inventory &inventory, Operation *diagOp,
                               Interval *dst, Interval *src, bool firstLane) {
  if (dst == src)
    return success();
  if (dst->type.getRegClass() != src->type.getRegClass())
    return success();
  if (dst->type.getIndex() >= 0 && src->type.getIndex() >= 0 &&
      dst->type.getIndex() != src->type.getIndex())
    return diagOp->emitError(kPassName)
           << " found incompatible fixed alias registers";
  for (Value value : src->values) {
    dst->values.insert(value);
    if (firstLane && inventory.intervalFor.lookup(value) == src)
      inventory.intervalFor[value] = dst;
  }
  dst->start = std::min(dst->start, src->start);
  dst->end = std::max(dst->end, src->end);
  dst->reserved |= src->reserved;
  dst->nonPromotable |= src->nonPromotable;
  dst->group->reserved |= src->group->reserved;
  dst->group->nonPromotable |= src->group->nonPromotable;
  src->values.clear();
  src->group = dst->group;
  return success();
}

static bool canAliasTypes(waveamdmachine::RegType baseType,
                          waveamdmachine::RegType valueType, unsigned offset) {
  if (baseType.getRegClass() != valueType.getRegClass())
    return false;
  return offset + valueType.getWidth() <= baseType.getWidth();
}

static bool isMFMA(Operation *op);

static LogicalResult mergeLaneRange(Inventory &inventory, Operation *diagOp,
                                    IntervalGroup *base, unsigned baseIndex,
                                    IntervalGroup *value, unsigned valueIndex,
                                    unsigned width) {
  for (unsigned lane : llvm::seq<unsigned>(0, width)) {
    unsigned dstIndex = baseIndex + lane;
    unsigned srcIndex = valueIndex + lane;
    if (dstIndex >= base->intervals.size() ||
        srcIndex >= value->intervals.size())
      return success();
    if (failed(mergeLane(inventory, diagOp, base->intervals[dstIndex],
                         value->intervals[srcIndex], lane == 0)))
      return failure();
  }
  return success();
}

static LogicalResult aliasValues(Inventory &inventory, Operation *diagOp,
                                 Value base, Value value, unsigned offset,
                                 unsigned fallback) {
  std::optional<waveamdmachine::RegType> baseType = getTrackedType(base);
  std::optional<waveamdmachine::RegType> valueType = getTrackedType(value);
  if (!baseType || !valueType)
    return success();
  if (!canAliasTypes(*baseType, *valueType, offset))
    return success();

  Interval *baseFirst = ensureInterval(base, inventory, fallback);
  Interval *valueFirst = ensureInterval(value, inventory, fallback);
  std::optional<unsigned> baseIndex = getLaneIndex(baseFirst->group, baseFirst);
  std::optional<unsigned> valueIndex =
      getLaneIndex(valueFirst->group, valueFirst);
  if (!baseIndex || !valueIndex)
    return success();

  return mergeLaneRange(inventory, diagOp, baseFirst->group,
                        *baseIndex + offset, valueFirst->group, *valueIndex,
                        valueType->getWidth());
}

static LogicalResult collectTupleAliases(Operation &op, Inventory &inventory,
                                         unsigned position) {
  if (auto from = dyn_cast<waveamdmachine::TupleFromElementsOp>(&op)) {
    Value tuple = from.getTuple();
    unsigned offset = 0;
    for (Value element : from.getElements()) {
      if (failed(aliasValues(inventory, &op, tuple, element, offset, position)))
        return failure();
      if (std::optional<waveamdmachine::RegType> type = getTrackedType(element))
        offset += type->getWidth();
    }
    return success();
  }

  if (auto to = dyn_cast<waveamdmachine::TupleToElementsOp>(&op)) {
    Value tuple = to.getTuple();
    unsigned offset = 0;
    for (Value element : to.getResults()) {
      if (failed(aliasValues(inventory, &op, tuple, element, offset, position)))
        return failure();
      if (std::optional<waveamdmachine::RegType> type = getTrackedType(element))
        offset += type->getWidth();
    }
  }
  return success();
}

static LogicalResult collectMFMAAccumulatorAlias(Operation &op,
                                                 Inventory &inventory,
                                                 unsigned position) {
  if (!isMFMA(&op) || op.getNumOperands() <= 2 || op.getNumResults() != 1)
    return success();
  Value acc = op.getOperand(2);
  if (!llvm::hasSingleElement(acc.getUses()))
    return success();
  Value result = op.getResult(0);
  std::optional<waveamdmachine::RegType> accType = getTrackedType(acc);
  std::optional<waveamdmachine::RegType> resultType = getTrackedType(result);
  if (!accType || !resultType)
    return success();
  if (accType->getRegClass() != resultType->getRegClass() ||
      accType->getWidth() != resultType->getWidth())
    return success();
  return aliasValues(inventory, &op, acc, result, /*offset=*/0, position);
}

static LogicalResult collectLoopSlotAliases(Inventory &inventory, Operation &op,
                                            waveamdmachine::UniformLoopOp loop,
                                            waveamdmachine::ContinueIfOp term,
                                            Block &body, unsigned index,
                                            unsigned position) {
  if (index >= body.getNumArguments() || index >= loop.getNumResults())
    return success();
  Value init = loop.getInits()[index];
  if (failed(aliasValues(inventory, &op, init, body.getArgument(index),
                         /*offset=*/0, position)))
    return failure();
  if (failed(aliasValues(inventory, &op, init, loop.getResult(index),
                         /*offset=*/0, position)))
    return failure();
  if (term && index < term.getCarries().size())
    return aliasValues(inventory, &op, init, term.getCarries()[index],
                       /*offset=*/0, position);
  return success();
}

static LogicalResult collectLoopAliases(Operation &op, Inventory &inventory,
                                        unsigned position) {
  auto loop = dyn_cast<waveamdmachine::UniformLoopOp>(&op);
  if (!loop || loop.getBody().empty())
    return success();

  Block &body = loop.getBody().front();
  auto term = dyn_cast<waveamdmachine::ContinueIfOp>(body.getTerminator());
  for (unsigned index : llvm::seq<unsigned>(0, loop.getInits().size()))
    if (failed(collectLoopSlotAliases(inventory, op, loop, term, body, index,
                                      position)))
      return failure();
  return success();
}

static LogicalResult collectExecIfRegionAliases(Inventory &inventory,
                                                Operation *diagOp, Value result,
                                                Region &region, unsigned index,
                                                unsigned position) {
  if (region.empty())
    return success();
  auto yield =
      dyn_cast<waveamdmachine::YieldOp>(region.front().getTerminator());
  if (!yield || index >= yield.getValues().size())
    return success();
  return aliasValues(inventory, diagOp, result, yield.getValues()[index],
                     /*offset=*/0, position);
}

static LogicalResult collectExecIfAliases(Operation &op, Inventory &inventory,
                                          unsigned position) {
  auto execIf = dyn_cast<waveamdmachine::ExecIfOp>(&op);
  if (!execIf)
    return success();
  for (unsigned index : llvm::seq<unsigned>(0, execIf.getNumResults())) {
    Value result = execIf.getResult(index);
    if (failed(collectExecIfRegionAliases(
            inventory, &op, result, execIf.getThenRegion(), index, position)))
      return failure();
    if (failed(collectExecIfRegionAliases(
            inventory, &op, result, execIf.getElseRegion(), index, position)))
      return failure();
  }
  return success();
}

static unsigned getLiveDwords(ArrayRef<std::unique_ptr<Interval>> intervals,
                              unsigned position,
                              waveamdmachine::RegClass regClass) {
  unsigned live = 0;
  for (const std::unique_ptr<Interval> &interval : intervals) {
    if (interval->group->plannedPressureRelief)
      continue;
    if (interval->values.empty() && !interval->reserved)
      continue;
    if (interval->group->storageClass != regClass ||
        position < interval->start || interval->end < position)
      continue;
    ++live;
  }
  return live;
}

static unsigned getLiveDwords(Inventory &inventory, unsigned position,
                              waveamdmachine::RegClass regClass) {
  return getLiveDwords(inventory.intervals, position, regClass);
}

static unsigned getPeak(Inventory &inventory,
                        waveamdmachine::RegClass regClass) {
  unsigned peak = 0;
  for (unsigned position : llvm::seq<unsigned>(0, inventory.ops.size()))
    peak = std::max(peak, getLiveDwords(inventory, position, regClass));
  return peak;
}

static void updatePeaks(Inventory &inventory) {
  inventory.peakSGPR = getPeak(inventory, waveamdmachine::RegClass::SGPR);
  inventory.peakVGPR = getPeak(inventory, waveamdmachine::RegClass::VGPR);
  inventory.peakAGPR = getPeak(inventory, waveamdmachine::RegClass::AGPR);
}

static bool operationIsInside(Operation *root, Operation *op) {
  for (Operation *cur = op; cur; cur = cur->getParentOp())
    if (cur == root)
      return true;
  return false;
}

static bool valueIsDefinedInside(Operation *root, Value value) {
  if (Operation *def = value.getDefiningOp())
    return operationIsInside(root, def);
  Operation *parent = cast<BlockArgument>(value).getOwner()->getParentOp();
  return operationIsInside(root, parent);
}

static unsigned getRegionEnd(Operation *root, Inventory &inventory) {
  unsigned end = inventory.positions.lookup(root);
  root->walk([&](Operation *op) {
    if (auto it = inventory.positions.find(op); it != inventory.positions.end())
      end = std::max(end, it->second);
  });
  return end;
}

static void extendExternalLoopUse(Operation *user, Value operand,
                                  Inventory &inventory) {
  for (Operation *cur = user->getParentOp(); cur; cur = cur->getParentOp()) {
    if (!isa<waveamdmachine::UniformLoopOp>(cur))
      continue;
    if (valueIsDefinedInside(cur, operand))
      continue;
    extendInterval(operand, inventory, getRegionEnd(cur, inventory));
  }
}

static bool isLiveAt(Interval *interval, unsigned position) {
  if (interval->group->plannedPressureRelief)
    return false;
  return (!interval->values.empty() || interval->reserved) &&
         interval->start <= position && position <= interval->end;
}

static bool isLiveAt(IntervalGroup *group, unsigned position) {
  return llvm::any_of(group->intervals,
                      [&](Interval *lane) { return isLiveAt(lane, position); });
}

static unsigned getGroupStart(IntervalGroup *group) {
  unsigned start = std::numeric_limits<unsigned>::max();
  for (Interval *lane : group->intervals)
    if (!lane->values.empty() || lane->reserved)
      start = std::min(start, lane->start);
  return start;
}

static unsigned getGroupEnd(IntervalGroup *group) {
  unsigned end = 0;
  for (Interval *lane : group->intervals)
    if (!lane->values.empty() || lane->reserved)
      end = std::max(end, lane->end);
  return end;
}

static int64_t getResultIndex(Value value) {
  if (OpResult result = dyn_cast<OpResult>(value))
    return result.getResultNumber();
  return -1;
}

static bool hasLiveLanes(IntervalGroup *group) {
  if (group->plannedPressureRelief)
    return false;
  return llvm::any_of(group->intervals, [](Interval *lane) {
    return !lane->values.empty() || lane->reserved;
  });
}

static std::optional<unsigned> getFixedBase(IntervalGroup *group) {
  if (group->fixedBase)
    return group->fixedBase;
  std::optional<unsigned> base;
  for (auto [laneIndex, lane] : llvm::enumerate(group->intervals)) {
    if (lane->type.getIndex() < 0)
      continue;
    if (lane->type.getIndex() < static_cast<int64_t>(laneIndex))
      return std::nullopt;
    int64_t candidateIndex = lane->type.getIndex() - laneIndex;
    if (static_cast<uint64_t>(candidateIndex) >
        std::numeric_limits<unsigned>::max())
      return std::nullopt;
    unsigned candidate = static_cast<unsigned>(candidateIndex);
    if (base && *base != candidate)
      return std::nullopt;
    base = candidate;
  }
  return base;
}

static bool hasFixedRegister(IntervalGroup *group) {
  return isFixedRegisterGroup(group);
}

static bool isMFMA(Operation *op) {
  return op && op->hasTrait<OpTrait::waveamdmachine::MFMAOp>();
}

static bool canDefineAGPR(Value value) {
  if (isa<BlockArgument>(value))
    return true;
  Operation *def = value.getDefiningOp();
  if (!def)
    return false;
  return isa<waveamdmachine::UninitOp, waveamdmachine::UniformLoopOp>(def) ||
         isMFMA(def);
}

static bool canConsumeAGPR(OpOperand &use) {
  Operation *user = use.getOwner();
  if (isMFMA(user)) {
    if (use.getOperandNumber() < 2)
      return true;
    if (use.getOperandNumber() == 2 && user->getNumResults() == 1) {
      auto resultType =
          dyn_cast<waveamdmachine::RegType>(user->getResult(0).getType());
      return resultType &&
             resultType.getRegClass() == waveamdmachine::RegClass::AGPR;
    }
    return false;
  }
  if (isa<waveamdmachine::UniformLoopOp, waveamdmachine::ContinueIfOp>(user))
    return true;
  if (isa<waveamdmachine::VAccvgprReadB32TupleOp>(user))
    return use.getOperandNumber() == 0;
  return false;
}

static bool hasUnpromotableAGPRUse(IntervalGroup *group) {
  for (Interval *lane : group->intervals) {
    for (Value value : lane->values) {
      for (OpOperand &use : value.getUses())
        if (isa<waveamdmachine::VAccvgprWriteB32TupleOp>(use.getOwner()) &&
            use.getOperandNumber() == 0)
          return true;
    }
  }
  return false;
}

static bool intervalsOverlap(Interval *lhs, Interval *rhs) {
  return lhs->start <= rhs->end && rhs->start <= lhs->end;
}

static bool
isAllowedKernargPreloadValue(waveamdmachine::RegType type, unsigned phys,
                             const wave::WaveAMDKernelEntryRegs &regs) {
  if (type.getRegClass() != waveamdmachine::RegClass::SGPR)
    return false;
  unsigned begin = phys;
  unsigned end = begin + type.getWidth();
  unsigned preloadBegin = regs.kernargSegmentPtrWidth;
  unsigned preloadEnd = preloadBegin + regs.kernargPreloadDwords;
  return preloadBegin <= begin && end <= preloadEnd;
}

static bool
isAllowedReservedVGPRValue(Operation *def, waveamdmachine::RegType type,
                           unsigned phys,
                           const wave::WaveAMDKernelEntryRegs &regs) {
  return type.getRegClass() == waveamdmachine::RegClass::VGPR &&
         isa<waveamdmachine::VWorkitemIdXOp>(def) &&
         phys == regs.workitemIdXVGPR;
}

static bool
isAllowedReservedWorkgroupId(Operation *def, unsigned phys,
                             const wave::WaveAMDKernelEntryRegs &regs) {
  if (isa<waveamdmachine::SWorkgroupIdXOp>(def))
    return phys == regs.workgroupIdSGPR(0);
  if (isa<waveamdmachine::SWorkgroupIdYOp>(def))
    return phys == regs.workgroupIdSGPR(1);
  if (isa<waveamdmachine::SWorkgroupIdZOp>(def))
    return phys == regs.workgroupIdSGPR(2);
  return false;
}

static bool
isAllowedReservedSGPRValue(Operation *def, waveamdmachine::RegType type,
                           unsigned phys,
                           const wave::WaveAMDKernelEntryRegs &regs) {
  if (type.getRegClass() != waveamdmachine::RegClass::SGPR)
    return false;
  if (isa<waveamdmachine::KernargPreloadOp>(def))
    return isAllowedKernargPreloadValue(type, phys, regs);
  return isAllowedReservedWorkgroupId(def, phys, regs);
}

static bool
canValueOverlapReservedLane(Value value, unsigned phys,
                            const wave::WaveAMDKernelEntryRegs &regs) {
  auto type = cast<waveamdmachine::RegType>(value.getType());
  Operation *def = value.getDefiningOp();
  if (!def || type.getIndex() < 0)
    return false;
  unsigned index = static_cast<unsigned>(type.getIndex());
  unsigned width = static_cast<unsigned>(type.getWidth());
  if (phys < index || phys - index >= width)
    return false;
  return isAllowedReservedVGPRValue(def, type, phys, regs) ||
         isAllowedReservedSGPRValue(def, type, index, regs);
}

static unsigned getReservedPrefix(waveamdmachine::RegClass regClass,
                                  const wave::WaveAMDKernelEntryRegs &regs) {
  if (regClass == waveamdmachine::RegClass::SGPR)
    return regs.reservedSGPRs;
  if (regClass == waveamdmachine::RegClass::VGPR)
    return regs.reservedVGPRs;
  return 0;
}

static bool isAllowedReservedValue(Value value, unsigned index,
                                   const wave::WaveAMDKernelEntryRegs &regs) {
  Operation *def = value.getDefiningOp();
  if (!def)
    return false;
  auto type = cast<waveamdmachine::RegType>(value.getType());
  if (type.getRegClass() == waveamdmachine::RegClass::VGPR)
    return isAllowedReservedVGPRValue(def, type, index, regs);
  return isAllowedReservedSGPRValue(def, type, index, regs);
}

static LogicalResult
validateReservedRange(func::FuncOp func, Value value,
                      waveamdmachine::RegClass regClass, unsigned assignedIndex,
                      unsigned reserved,
                      const wave::WaveAMDKernelEntryRegs &regs) {
  if (reserved == 0 || assignedIndex >= reserved)
    return success();
  if (isAllowedReservedValue(value, assignedIndex, regs))
    return success();
  return diagOpForValue(value, func)->emitError()
         << kPassName << " found " << getRegClassName(regClass)
         << " value allocated in reserved kernel ABI registers";
}

static LogicalResult
validateReservedRanges(func::FuncOp func, IntervalGroup *group, unsigned base,
                       const wave::WaveAMDKernelEntryRegs &regs) {
  if (group->reserved)
    return success();
  unsigned reserved = getReservedPrefix(group->storageClass, regs);
  llvm::SmallDenseSet<Value, 8> seen;
  for (auto [laneIndex, lane] : llvm::enumerate(group->intervals)) {
    for (Value value : lane->values) {
      if (!seen.insert(value).second)
        continue;
      if (failed(validateReservedRange(func, value, group->storageClass,
                                       base + laneIndex, reserved, regs)))
        return failure();
    }
  }
  return success();
}

static bool canOverlapReservedLane(Interval *lane, unsigned phys,
                                   const wave::WaveAMDKernelEntryRegs &regs) {
  return !lane->values.empty() && llvm::all_of(lane->values, [&](Value value) {
    return canValueOverlapReservedLane(value, phys, regs);
  });
}

static bool lanesCanOverlap(Interval *lane, Interval *otherLane, unsigned phys,
                            const wave::WaveAMDKernelEntryRegs &regs) {
  if (lane->reserved && canOverlapReservedLane(otherLane, phys, regs))
    return true;
  if (otherLane->reserved && canOverlapReservedLane(lane, phys, regs))
    return true;
  return false;
}

static bool laneBlocksPhys(Interval *lane, Interval *otherLane, unsigned phys,
                           const wave::WaveAMDKernelEntryRegs &regs) {
  if (otherLane->values.empty() && !otherLane->reserved)
    return false;
  if (lanesCanOverlap(lane, otherLane, phys, regs))
    return false;
  return intervalsOverlap(lane, otherLane);
}

static bool laneConflictsWithGroup(Interval *lane, unsigned phys,
                                   IntervalGroup *other,
                                   const wave::WaveAMDKernelEntryRegs &regs) {
  for (auto [otherLaneIndex, otherLane] : llvm::enumerate(other->intervals)) {
    if (*other->assignedBase + otherLaneIndex != phys)
      continue;
    if (laneBlocksPhys(lane, otherLane, phys, regs))
      return true;
  }
  return false;
}

static bool
laneConflictsWithAssigned(Interval *lane, unsigned phys, IntervalGroup *group,
                          ArrayRef<IntervalGroup *> assigned,
                          const wave::WaveAMDKernelEntryRegs &regs) {
  for (IntervalGroup *other : assigned) {
    if (other == group || other->storageClass != group->storageClass ||
        !other->assignedBase)
      continue;
    if (laneConflictsWithGroup(lane, phys, other, regs))
      return true;
  }
  return false;
}

static bool baseFits(IntervalGroup *group, unsigned base,
                     ArrayRef<IntervalGroup *> assigned,
                     const wave::WaveAMDKernelEntryRegs &regs) {
  for (auto [laneIndex, lane] : llvm::enumerate(group->intervals)) {
    if (lane->values.empty() && !lane->reserved)
      continue;
    if (laneConflictsWithAssigned(lane, base + laneIndex, group, assigned,
                                  regs))
      return false;
  }
  return true;
}

static std::optional<unsigned>
findFreeBase(IntervalGroup *group, RegisterBudgets budgets,
             ArrayRef<IntervalGroup *> assigned,
             const wave::WaveAMDKernelEntryRegs &regs) {
  unsigned width = group->intervals.size();
  unsigned budget = getBudget(budgets, group->storageClass);
  if (width == 0 || width > budget)
    return std::nullopt;
  unsigned align = std::max<unsigned>(1, llvm::PowerOf2Ceil(width));
  for (unsigned base = 0; base <= budget - width; base += align)
    if (baseFits(group, base, assigned, regs))
      return base;
  return std::nullopt;
}

static bool groupContainsBlockArgument(IntervalGroup *group) {
  for (Interval *lane : group->intervals)
    for (Value value : lane->values)
      if (isa<BlockArgument>(value))
        return true;
  return false;
}

static bool canPromote(IntervalGroup *group, RegisterBudgets budgets) {
  if (group->nonPromotable || hasFixedRegister(group))
    return false;
  for (Interval *lane : group->intervals)
    if (lane->nonPromotable)
      return false;
  std::optional<waveamdmachine::RegClass> next =
      getNextRegClass(group->storageClass);
  if (!next || getBudget(budgets, *next) < group->intervals.size())
    return false;
  if (*next == waveamdmachine::RegClass::VGPR) {
    if (group->intervals.size() != 1)
      return false;
    return !groupContainsBlockArgument(group);
  }
  if (*next == waveamdmachine::RegClass::AGPR)
    return !hasUnpromotableAGPRUse(group);
  return false;
}

static unsigned getLiveDwords(Inventory &inventory, unsigned position,
                              waveamdmachine::RegClass regClass);
static unsigned getGroupLiveDwords(IntervalGroup *group, unsigned position);
static LogicalResult materializePromotion(IntervalGroup *group,
                                          OpBuilder &builder);

static bool canFitPromotionTarget(IntervalGroup *group,
                                  ArrayRef<IntervalGroup *> assigned,
                                  RegisterBudgets budgets,
                                  const wave::WaveAMDKernelEntryRegs &regs) {
  std::optional<waveamdmachine::RegClass> next =
      getNextRegClass(group->storageClass);
  if (!next)
    return false;
  waveamdmachine::RegClass original = group->storageClass;
  std::optional<unsigned> originalBase = group->assignedBase;
  group->storageClass = *next;
  group->assignedBase.reset();
  bool fits = findFreeBase(group, budgets, assigned, regs).has_value();
  group->storageClass = original;
  group->assignedBase = originalBase;
  return fits;
}

static SmallVector<Value> getGroupValues(IntervalGroup *group) {
  llvm::SmallDenseSet<Value, 8> seen;
  SmallVector<Value> values;
  for (Interval *lane : group->intervals) {
    for (Value value : lane->values) {
      if (seen.insert(value).second)
        values.push_back(value);
    }
  }
  return values;
}

static bool valueInGroup(Value value, IntervalGroup *group,
                         Inventory &inventory) {
  Interval *interval = inventory.intervalFor.lookup(value);
  return interval && interval->group == group;
}

static unsigned getUniformLoopDepth(Operation *op) {
  unsigned depth = 0;
  for (Operation *cur = op; cur; cur = cur->getParentOp())
    if (isa<waveamdmachine::UniformLoopOp>(cur))
      ++depth;
  return depth;
}

static unsigned getBridgeWeight(Operation *op) {
  unsigned depth = getUniformLoopDepth(op);
  if (depth == 0)
    return 1;
  return 1u << std::min<unsigned>(depth * 4, 20);
}

static bool isTupleAliasOp(Operation *op) {
  return isa_and_nonnull<waveamdmachine::TupleToElementsOp,
                         waveamdmachine::TupleFromElementsOp>(op);
}

static bool canConsumeAGPRAfterPromotion(OpOperand &use, IntervalGroup *group,
                                         Inventory &inventory) {
  if (canConsumeAGPR(use))
    return true;

  Operation *user = use.getOwner();
  if (isTupleAliasOp(user))
    return true;

  if (isMFMA(user) && use.getOperandNumber() == 2 && user->getNumResults() == 1)
    return valueInGroup(user->getResult(0), group, inventory);

  return false;
}

static unsigned estimateAGPRBridgeCost(IntervalGroup *group,
                                       Inventory &inventory) {
  unsigned cost = 0;
  for (Value value : getGroupValues(group)) {
    Operation *def = value.getDefiningOp();
    if (def && !isTupleAliasOp(def) && !canDefineAGPR(value))
      cost += getBridgeWeight(value.getDefiningOp());
    for (OpOperand &use : value.getUses()) {
      if (isa<waveamdmachine::VAccvgprWriteB32TupleOp>(use.getOwner()))
        continue;
      if (!canConsumeAGPRAfterPromotion(use, group, inventory))
        cost += getBridgeWeight(use.getOwner());
    }
  }
  return cost;
}

static unsigned estimateSGPRBridgeCost(IntervalGroup *group) {
  unsigned cost = 0;
  for (Value value : getGroupValues(group)) {
    ++cost;
    cost += llvm::range_size(value.getUses());
  }
  return cost;
}

static unsigned estimatePromotionBridgeCost(IntervalGroup *group,
                                            Inventory &inventory) {
  std::optional<waveamdmachine::RegClass> next =
      getNextRegClass(group->storageClass);
  if (!next)
    return std::numeric_limits<unsigned>::max();
  if (*next == waveamdmachine::RegClass::AGPR)
    return estimateAGPRBridgeCost(group, inventory);
  if (*next == waveamdmachine::RegClass::VGPR)
    return estimateSGPRBridgeCost(group);
  return std::numeric_limits<unsigned>::max();
}

static PromotionScore getPromotionScore(IntervalGroup *group, unsigned position,
                                        Inventory &inventory) {
  return {getGroupLiveDwords(group, position),
          estimatePromotionBridgeCost(group, inventory), getGroupEnd(group)};
}

static bool isBetterPromotionScore(PromotionScore lhs, PromotionScore rhs) {
  if (lhs.bridgeCost != rhs.bridgeCost)
    return lhs.bridgeCost < rhs.bridgeCost;
  if (lhs.liveDwords != rhs.liveDwords)
    return lhs.liveDwords > rhs.liveDwords;
  return lhs.end > rhs.end;
}

static BankPromotionHooks getBankPromotionHooks() {
  BankPromotionHooks hooks;
  hooks.getRegClassName = getRegClassName;
  hooks.getNextRegClass = getNextRegClass;
  hooks.getPromotionScore = getPromotionScore;
  hooks.isBetterPromotionScore = isBetterPromotionScore;
  hooks.isLiveAt = static_cast<bool (*)(IntervalGroup *, unsigned)>(&isLiveAt);
  hooks.canPromote = canPromote;
  hooks.canFitPromotionTarget = canFitPromotionTarget;
  hooks.materialize = materializePromotion;
  return hooks;
}

static SmallVector<IntervalGroup *> getAllocGroups(Inventory &inventory) {
  SmallVector<IntervalGroup *> groups;
  for (const std::unique_ptr<IntervalGroup> &group : inventory.groups)
    if (group->allocatable && hasLiveLanes(group.get()))
      groups.push_back(group.get());
  llvm::stable_sort(groups, [](IntervalGroup *lhs, IntervalGroup *rhs) {
    if (getGroupStart(lhs) != getGroupStart(rhs))
      return getGroupStart(lhs) < getGroupStart(rhs);
    return lhs->order < rhs->order;
  });
  return groups;
}

static unsigned getGroupLiveDwords(IntervalGroup *group, unsigned position) {
  unsigned live = 0;
  for (Interval *lane : group->intervals)
    if (isLiveAt(lane, position))
      ++live;
  return live;
}

static bool isReservedFixedGroup(IntervalGroup *group, unsigned reserved) {
  return group->fixedBase && *group->fixedBase < reserved;
}

static int64_t getValuePosition(Value value, Inventory &inventory,
                                unsigned fallback) {
  if (Operation *def = value.getDefiningOp())
    return inventory.positions.lookup(def);
  BlockArgument arg = cast<BlockArgument>(value);
  Operation *parent = arg.getOwner()->getParentOp();
  if (isa_and_nonnull<func::FuncOp>(parent))
    return 0;
  return inventory.positions.lookup(parent);
}

static PressureIntervalRef buildPressureIntervalRef(IntervalGroup *group,
                                                    Inventory &inventory) {
  PressureIntervalRef ref;
  ref.start = getGroupStart(group);
  ref.end = getGroupEnd(group);
  ref.width = group->intervals.size();
  llvm::SmallDenseSet<Value, 8> seen;
  for (auto [laneIndex, lane] : llvm::enumerate(group->intervals)) {
    for (Value value : lane->values) {
      if (!seen.insert(value).second)
        continue;
      ref.valuePositions.push_back(
          getValuePosition(value, inventory, ref.start));
      ref.resultIndices.push_back(getResultIndex(value));
      ref.slotOffsets.push_back(laneIndex);
    }
  }
  return ref;
}

static unsigned estimateRelief(unsigned liveWidth, unsigned requestWidth,
                               unsigned limit) {
  if (liveWidth + requestWidth > limit)
    return liveWidth + requestWidth - limit;
  return 1;
}

static PressureFailure
buildClassPressureFailure(Inventory &inventory,
                          ArrayRef<IntervalGroup *> assigned,
                          IntervalGroup *request, unsigned position,
                          waveamdmachine::RegClass regClass, unsigned limit) {
  PressureFailure failure;
  failure.regClass = getRegClassName(regClass);
  failure.limit = limit;
  failure.position = position;
  failure.reserved = getReservedPrefix(regClass, inventory.entryRegs);
  failure.liveDwords = failure.reserved;
  failure.request = buildPressureIntervalRef(request, inventory);
  for (IntervalGroup *group : assigned) {
    if (group == request || group->storageClass != regClass ||
        !isLiveAt(group, position))
      continue;
    if (group->reserved || isReservedFixedGroup(group, failure.reserved))
      continue;
    failure.liveDwords += getGroupLiveDwords(group, position);
    failure.overlaps.push_back(buildPressureIntervalRef(group, inventory));
  }
  failure.relief = estimateRelief(
      failure.liveDwords, getGroupLiveDwords(request, position), failure.limit);
  return failure;
}

static PressureFailure buildCombinedPressureFailure(Inventory &inventory,
                                                    IntervalGroup *request,
                                                    unsigned position,
                                                    unsigned vgprLimit,
                                                    unsigned vgprLive) {
  PressureFailure failure;
  failure.regClass = "VGPR";
  failure.limit = vgprLimit;
  failure.position = position;
  failure.reserved = inventory.entryRegs.reservedVGPRs;
  failure.liveDwords = vgprLive;
  failure.combinedVGPRAGPR = true;
  if (request) {
    failure.request = buildPressureIntervalRef(request, inventory);
    failure.relief = estimateRelief(
        vgprLive, getGroupLiveDwords(request, position), vgprLimit);
  } else {
    failure.relief = vgprLive > vgprLimit ? vgprLive - vgprLimit : 1;
  }
  return failure;
}

static LogicalResult validateReservedLimit(func::FuncOp func, StringRef cls,
                                           unsigned available,
                                           unsigned reserved) {
  if (available >= reserved)
    return success();
  return func.emitError()
         << kPassName << " " << cls
         << " limit leaves fewer registers than reserved kernel ABI prefix "
         << "(available=" << available << ", reserved=" << reserved << ")";
}

static LogicalResult validateReservedLimits(func::FuncOp func,
                                            RegisterBudgets budgets) {
  unsigned sgprReserved = wave::getWaveAMDReservedSGPRs(func);
  unsigned vgprReserved = wave::getWaveAMDReservedVGPRs(func);
  if (failed(validateReservedLimit(func, "SGPR", budgets.sgpr, sgprReserved)))
    return failure();
  return validateReservedLimit(func, "VGPR", budgets.vgpr, vgprReserved);
}

static LogicalResult
validateFixedGroup(func::FuncOp func, IntervalGroup *group,
                   RegisterBudgets budgets, ArrayRef<IntervalGroup *> assigned,
                   const wave::WaveAMDKernelEntryRegs &regs) {
  std::optional<unsigned> fixedBase = getFixedBase(group);
  if (!fixedBase)
    return func.emitError(kPassName)
           << " found inconsistent fixed register aliases";
  if (*fixedBase + group->intervals.size() >
      getAddressable(budgets, group->storageClass))
    return func.emitError(kPassName)
           << " fixed " << getRegClassName(group->storageClass)
           << " register range exceeds addressable namespace (end="
           << (*fixedBase + group->intervals.size())
           << ", limit=" << getAddressable(budgets, group->storageClass) << ")";
  if (failed(validateReservedRanges(func, group, *fixedBase, regs)))
    return failure();
  if (!baseFits(group, *fixedBase, assigned, regs))
    return func.emitError(kPassName)
           << " found interfering fixed "
           << getRegClassName(group->storageClass) << " register live ranges";
  group->assignedBase = *fixedBase;
  return success();
}

static LogicalResult
assignFixedGroups(func::FuncOp func, ArrayRef<IntervalGroup *> groups,
                  RegisterBudgets budgets,
                  SmallVectorImpl<IntervalGroup *> &assigned,
                  const wave::WaveAMDKernelEntryRegs &regs) {
  for (IntervalGroup *group : groups) {
    if (!hasFixedRegister(group))
      continue;
    if (failed(validateFixedGroup(func, group, budgets, assigned, regs)))
      return failure();
    assigned.push_back(group);
  }
  return success();
}

static bool isLoopCarryUse(Operation *op) { return isLoopCarryUseOp(op); }

static bool groupLiveAt(IntervalGroup *group, unsigned position) {
  if (!group || group->plannedPressureRelief)
    return false;
  for (Interval *lane : group->intervals)
    if (lane->start <= position && position <= lane->end)
      return true;
  return false;
}

static bool groupHasLoopCarryUse(IntervalGroup *group) {
  if (!group)
    return false;
  for (Interval *lane : group->intervals)
    for (Value value : lane->values)
      for (OpOperand &use : value.getUses())
        if (isLoopCarryUse(use.getOwner()))
          return true;
  return false;
}

static bool groupHasTempValue(IntervalGroup *group) {
  if (!group)
    return false;
  for (Interval *lane : group->intervals)
    for (Value value : lane->values)
      if (Operation *def = value.getDefiningOp())
        if (isRegAllocTempOp(def))
          return true;
  return false;
}

static bool groupHasMemoryIssuerValue(IntervalGroup *group) {
  if (!group)
    return false;
  for (Interval *lane : group->intervals)
    for (Value value : lane->values) {
      Operation *def = value.getDefiningOp();
      if (!def)
        continue;
      if (isMemoryIssuerOp(def))
        return true;
    }
  return false;
}

static bool groupHasCrossBlockUse(IntervalGroup *group) {
  if (!group)
    return false;
  for (Interval *lane : group->intervals) {
    for (Value value : lane->values) {
      Operation *def = value.getDefiningOp();
      if (!def)
        continue;
      Block *block = def->getBlock();
      for (OpOperand &use : value.getUses()) {
        if (isRegAllocTempOp(use.getOwner()) || isLoopCarryUse(use.getOwner()))
          continue;
        if (use.getOwner()->getBlock() != block)
          return true;
      }
    }
  }
  return false;
}

static bool groupHasNonTempUse(IntervalGroup *group) {
  if (!group)
    return false;
  for (Interval *lane : group->intervals)
    for (Value value : lane->values)
      for (OpOperand &use : value.getUses())
        if (!isRegAllocTempOp(use.getOwner()))
          return true;
  return false;
}

static bool hasLivePromotableLane(IntervalGroup *group, unsigned position) {
  return llvm::any_of(group->intervals, [&](Interval *lane) {
    return !lane->nonPromotable && lane->start <= position &&
           position <= lane->end;
  });
}

static bool hasLivePromotableLaneBefore(IntervalGroup *group,
                                        unsigned position) {
  return llvm::any_of(group->intervals, [&](Interval *lane) {
    return !lane->nonPromotable && lane->start < position &&
           position <= lane->end;
  });
}

struct MemorySpillRejectStats {
  unsigned crossBlock = 0;
  unsigned eligible = 0;
  unsigned fixed = 0;
  unsigned loopCarry = 0;
  unsigned memoryIssuer = 0;
  unsigned noUse = 0;
  unsigned nonPromotable = 0;
  unsigned startsAtPressure = 0;
  unsigned temp = 0;
  unsigned total = 0;
};

enum class MemorySpillRejectKind : uint8_t {
  CrossBlock,
  Eligible,
  Fixed,
  LoopCarry,
  MemoryIssuer,
  NoUse,
  NonPromotable,
  StartsAtPressure,
  Temp,
};

static bool shouldInspectMemorySpillReject(IntervalGroup *group,
                                           unsigned position) {
  if (!group || !groupLiveAt(group, position))
    return false;
  if (group->storageClass != waveamdmachine::RegClass::VGPR ||
      group->preferredClass != waveamdmachine::RegClass::VGPR)
    return false;
  return true;
}

static bool groupIsNonPromotableAt(IntervalGroup *group, unsigned position) {
  return group->nonPromotable || !hasLivePromotableLane(group, position);
}

static MemorySpillRejectKind getMemorySpillUseRejectKind(IntervalGroup *group,
                                                         unsigned position) {
  if (!hasLivePromotableLaneBefore(group, position))
    return MemorySpillRejectKind::StartsAtPressure;
  if (groupHasMemoryIssuerValue(group))
    return MemorySpillRejectKind::MemoryIssuer;
  if (groupHasCrossBlockUse(group))
    return MemorySpillRejectKind::CrossBlock;
  if (!groupHasNonTempUse(group))
    return MemorySpillRejectKind::NoUse;
  return MemorySpillRejectKind::Eligible;
}

static MemorySpillRejectKind getMemorySpillRejectKind(IntervalGroup *group,
                                                      unsigned position) {
  if (group->reserved || hasFixedRegister(group))
    return MemorySpillRejectKind::Fixed;
  if (groupHasLoopCarryUse(group))
    return MemorySpillRejectKind::LoopCarry;
  if (groupHasTempValue(group))
    return MemorySpillRejectKind::Temp;
  if (groupIsNonPromotableAt(group, position))
    return MemorySpillRejectKind::NonPromotable;
  return getMemorySpillUseRejectKind(group, position);
}

static void incrementMemorySpillReject(MemorySpillRejectStats &stats,
                                       MemorySpillRejectKind kind) {
  switch (kind) {
  case MemorySpillRejectKind::CrossBlock:
    ++stats.crossBlock;
    break;
  case MemorySpillRejectKind::Eligible:
    ++stats.eligible;
    break;
  case MemorySpillRejectKind::Fixed:
    ++stats.fixed;
    break;
  case MemorySpillRejectKind::LoopCarry:
    ++stats.loopCarry;
    break;
  case MemorySpillRejectKind::MemoryIssuer:
    ++stats.memoryIssuer;
    break;
  case MemorySpillRejectKind::NoUse:
    ++stats.noUse;
    break;
  case MemorySpillRejectKind::NonPromotable:
    ++stats.nonPromotable;
    break;
  case MemorySpillRejectKind::StartsAtPressure:
    ++stats.startsAtPressure;
    break;
  case MemorySpillRejectKind::Temp:
    ++stats.temp;
    break;
  }
}

static void classifyMemorySpillReject(IntervalGroup *group, unsigned position,
                                      MemorySpillRejectStats &stats) {
  if (!shouldInspectMemorySpillReject(group, position))
    return;
  ++stats.total;
  incrementMemorySpillReject(stats, getMemorySpillRejectKind(group, position));
}

static void addRejectCount(Builder &builder, NamedAttrList &attrs,
                           StringRef name, unsigned count) {
  if (count == 0)
    return;
  attrs.set(name, builder.getI64IntegerAttr(count));
}

static void setMemorySpillRejectDiagnostics(func::FuncOp func,
                                            ArrayRef<IntervalGroup *> assigned,
                                            IntervalGroup *request,
                                            unsigned position) {
  if (!request || request->storageClass != waveamdmachine::RegClass::VGPR)
    return;
  MemorySpillRejectStats stats;
  classifyMemorySpillReject(request, position, stats);
  for (IntervalGroup *group : assigned)
    classifyMemorySpillReject(group, position, stats);
  if (stats.total == 0)
    return;

  Builder builder(func.getContext());
  NamedAttrList attrs;
  attrs.set("total", builder.getI64IntegerAttr(stats.total));
  addRejectCount(builder, attrs, "cross_block", stats.crossBlock);
  addRejectCount(builder, attrs, "eligible", stats.eligible);
  addRejectCount(builder, attrs, "fixed", stats.fixed);
  addRejectCount(builder, attrs, "loop_carry", stats.loopCarry);
  addRejectCount(builder, attrs, "memory_issuer", stats.memoryIssuer);
  addRejectCount(builder, attrs, "no_use", stats.noUse);
  addRejectCount(builder, attrs, "non_promotable", stats.nonPromotable);
  addRejectCount(builder, attrs, "starts_at_pressure", stats.startsAtPressure);
  addRejectCount(builder, attrs, "temp", stats.temp);
  func->setAttr(kMemorySpillRejectDetailAttr, builder.getDictionaryAttr(attrs));
  if (stats.loopCarry != 0)
    func->setAttr(kMemorySpillRejectAttr,
                  builder.getStringAttr(kMemorySpillLoopCarryReject));
}

static FailureOr<bool> applyMemoryPressureRelief(
    func::FuncOp func, Inventory &inventory, ArrayRef<IntervalGroup *> assigned,
    IntervalGroup *group, unsigned position, RegisterBudgets budgets,
    const PressureFailure *pressureFailure = nullptr) {
  func->removeAttr(kMemorySpillRejectAttr);
  func->removeAttr(kMemorySpillRejectDetailAttr);
  FailureOr<bool> spilledGroup = applyLDSSpillProvider(
      func, assigned, group, position, budgets, inventory, pressureFailure);
  if (failed(spilledGroup))
    return failure();
  if (*spilledGroup)
    return true;
  FailureOr<bool> scratchSpill = applyScratchSpillProvider(
      func, assigned, group, position, inventory, pressureFailure);
  if (failed(scratchSpill) || *scratchSpill)
    return scratchSpill;
  setMemorySpillRejectDiagnostics(func, assigned, group, position);
  return false;
}

static FailureOr<bool>
applyCombinedPressureRelief(func::FuncOp func, Inventory &inventory,
                            const PressureFailure &failure,
                            RegisterBudgets budgets) {
  SmallVector<IntervalGroup *> groups = getAllocGroups(inventory);
  return applyMemoryPressureRelief(func, inventory, groups, nullptr,
                                   failure.position, budgets, &failure);
}

static LogicalResult allocateOnce(func::FuncOp func, Inventory &inventory,
                                  ArrayRef<IntervalGroup *> groups,
                                  RegisterBudgets budgets,
                                  PressureFailure &pressureFailure,
                                  bool &promoted, bool &rewroteIR) {
  SmallVector<IntervalGroup *> assigned;
  if (failed(assignFixedGroups(func, groups, budgets, assigned,
                               inventory.entryRegs)))
    return failure();
  for (IntervalGroup *group : groups) {
    if (hasFixedRegister(group))
      continue;
    if (std::optional<unsigned> base =
            findFreeBase(group, budgets, assigned, inventory.entryRegs)) {
      group->assignedBase = *base;
      assigned.push_back(group);
      continue;
    }

    unsigned position = getGroupStart(group);
    FailureOr<bool> promotedGroup =
        applyBankPromotionProvider(func, assigned, group, position, budgets,
                                   inventory, getBankPromotionHooks());
    if (failed(promotedGroup))
      return failure();
    if (!*promotedGroup) {
      unsigned plannedBefore = inventory.plannedReliefPlans.size();
      FailureOr<bool> rewroteGroup = applyMemoryPressureRelief(
          func, inventory, assigned, group, position, budgets);
      if (failed(rewroteGroup))
        return failure();
      if (*rewroteGroup) {
        if (inventory.plannedReliefPlans.size() != plannedBefore)
          promoted = true;
        else
          rewroteIR = true;
        return success();
      }
      pressureFailure = buildClassPressureFailure(
          inventory, assigned, group, position, group->storageClass,
          getBudget(budgets, group->storageClass));
      return mlir::failure();
    }
    promoted = true;
    return success();
  }
  return success();
}

static void resetAssignments(ArrayRef<IntervalGroup *> groups) {
  for (IntervalGroup *group : groups)
    group->assignedBase.reset();
}

static LogicalResult allocateGroups(func::FuncOp func, Inventory &inventory,
                                    RegisterBudgets budgets,
                                    std::optional<PressureFailure> &failureOut,
                                    bool &rewroteIR) {
  unsigned maxAttempts = inventory.groups.size() * 2 + 1;
  for ([[maybe_unused]] unsigned attempt :
       llvm::seq<unsigned>(0, maxAttempts)) {
    SmallVector<IntervalGroup *> groups = getAllocGroups(inventory);
    resetAssignments(groups);
    bool promoted = false;
    bool localRewrite = false;
    PressureFailure localFailure;
    if (failed(allocateOnce(func, inventory, groups, budgets, localFailure,
                            promoted, localRewrite))) {
      if (!localFailure.regClass.empty())
        failureOut = localFailure;
      return mlir::failure();
    }
    if (localRewrite) {
      rewroteIR = true;
      return success();
    }
    if (!promoted)
      return success();
    ++inventory.promotedGroups;
  }
  PressureFailure progressFailure;
  progressFailure.regClass = "promotion";
  failureOut = progressFailure;
  return mlir::failure();
}

static bool hasVirtualAGPR(Inventory &inventory) {
  return llvm::any_of(inventory.groups, [](const auto &group) {
    return hasLiveLanes(group.get()) &&
           group->preferredClass == waveamdmachine::RegClass::AGPR;
  });
}

static LogicalResult validateAGPRSupport(func::FuncOp func,
                                         RegisterBudgets budgets,
                                         Inventory &inventory) {
  if (budgets.addressableAGPR != 0 || !hasVirtualAGPR(inventory))
    return success();
  return func.emitError() << kPassName
                          << " AGPR registers require target with AGPR support";
}

static void updateAllocatedCount(unsigned &count, IntervalGroup *group) {
  if (!group->assignedBase)
    return;
  count = std::max(count, *group->assignedBase +
                              static_cast<unsigned>(group->intervals.size()));
}

static unsigned getAllocatedCount(Inventory &inventory,
                                  waveamdmachine::RegClass regClass) {
  unsigned count = getReservedPrefix(regClass, inventory.entryRegs);
  for (const std::unique_ptr<IntervalGroup> &group : inventory.groups)
    if (group->storageClass == regClass)
      updateAllocatedCount(count, group.get());
  return count;
}

static LogicalResult reportBudgetOverflow(func::FuncOp func, StringRef name,
                                          unsigned count, unsigned limit,
                                          unsigned targetWaves,
                                          bool markOverflow,
                                          PressureFailure &pressureFailure) {
  if (count <= limit)
    return success();
  pressureFailure.regClass = name;
  pressureFailure.limit = limit;
  pressureFailure.liveDwords = count;
  pressureFailure.position = 0;
  pressureFailure.relief = count - limit;
  if (markOverflow)
    return mlir::failure();
  return func.emitError() << kPassName << " " << name
                          << " count exceeds register budget (count=" << count
                          << ", limit=" << limit
                          << ", target_waves=" << targetWaves << ")";
}

static LogicalResult
enforceAllocatedRegisterBudgets(func::FuncOp func, Inventory &inventory,
                                RegisterBudgets budgets, bool markOverflow,
                                std::optional<PressureFailure> &failureOut) {
  PressureFailure pressureFailure;
  unsigned sgprCount =
      getAllocatedCount(inventory, waveamdmachine::RegClass::SGPR);
  if (failed(reportBudgetOverflow(func, "SGPR", sgprCount, budgets.sgpr,
                                  budgets.targetWaves, markOverflow,
                                  pressureFailure))) {
    if (markOverflow)
      failureOut = pressureFailure;
    return mlir::failure();
  }
  unsigned vgprCount =
      getAllocatedCount(inventory, waveamdmachine::RegClass::VGPR);
  if (failed(reportBudgetOverflow(func, "VGPR", vgprCount, budgets.vgpr,
                                  budgets.targetWaves, markOverflow,
                                  pressureFailure))) {
    if (markOverflow)
      failureOut = pressureFailure;
    return mlir::failure();
  }
  unsigned agprCount =
      getAllocatedCount(inventory, waveamdmachine::RegClass::AGPR);
  if (failed(reportBudgetOverflow(func, "AGPR", agprCount, budgets.agpr,
                                  budgets.targetWaves, markOverflow,
                                  pressureFailure))) {
    if (markOverflow)
      failureOut = pressureFailure;
    return mlir::failure();
  }
  return success();
}

static unsigned alignDown(unsigned value, unsigned granule) {
  return (value / granule) * granule;
}

static IntervalGroup *selectVGPRPressureRequest(Inventory &inventory,
                                                unsigned position) {
  for (const std::unique_ptr<IntervalGroup> &group : inventory.groups)
    if (group->storageClass == waveamdmachine::RegClass::VGPR &&
        !group->reserved && isLiveAt(group.get(), position))
      return group.get();
  return nullptr;
}

static LogicalResult
enforceCombinedVGPRAGPRBudget(Inventory &inventory, RegisterBudgets budgets,
                              std::optional<PressureFailure> &failureOut) {
  if (!budgets.totalVGPRLimit || !budgets.agprCountsAgainstVGPRs)
    return success();
  unsigned positionCount = std::max<unsigned>(1, inventory.ops.size());
  for (unsigned position : llvm::seq<unsigned>(0, positionCount)) {
    unsigned agprLive =
        getLiveDwords(inventory, position, waveamdmachine::RegClass::AGPR);
    unsigned vgprLimit = 0;
    if (agprLive < *budgets.totalVGPRLimit)
      vgprLimit = alignDown(*budgets.totalVGPRLimit - agprLive, 4);
    unsigned vgprLive =
        getLiveDwords(inventory, position, waveamdmachine::RegClass::VGPR);
    if (vgprLive <= vgprLimit)
      continue;
    IntervalGroup *request = selectVGPRPressureRequest(inventory, position);
    failureOut = buildCombinedPressureFailure(inventory, request, position,
                                              vgprLimit, vgprLive);
    return failure();
  }
  return success();
}

static LogicalResult enforceBudgets(func::FuncOp func, Inventory &inventory,
                                    RegisterBudgets budgets, bool markOverflow,
                                    std::optional<PressureFailure> &failure) {
  if (failed(enforceCombinedVGPRAGPRBudget(inventory, budgets, failure)))
    return mlir::failure();
  return enforceAllocatedRegisterBudgets(func, inventory, budgets, markOverflow,
                                         failure);
}

static SmallVector<IntervalGroup *> getPromotedGroups(Inventory &inventory) {
  SmallVector<IntervalGroup *> groups;
  for (const std::unique_ptr<IntervalGroup> &group : inventory.groups)
    if (hasLiveLanes(group.get()) &&
        group->storageClass != group->preferredClass)
      groups.push_back(group.get());
  return groups;
}

static Value materializeAGPRDef(Value value, OpBuilder &builder) {
  if (isa<BlockArgument>(value)) {
    setRegClass(value, waveamdmachine::RegClass::AGPR);
    return value;
  }
  Operation *def = value.getDefiningOp();
  if (canDefineAGPR(value)) {
    setRegClass(value, waveamdmachine::RegClass::AGPR);
    return value;
  }
  builder.setInsertionPointAfter(def);
  auto write = waveamdmachine::VAccvgprWriteB32TupleOp::create(
      builder, def->getLoc(), getRegType(value, waveamdmachine::RegClass::AGPR),
      value);
  write->setAttr(kTempAttr, builder.getUnitAttr());
  return write.getResult();
}

static Value getAGPRReplacement(Value value,
                                DenseMap<Value, Value> &replacements,
                                OpBuilder &builder) {
  if (Value existing = replacements.lookup(value))
    return existing;
  Value replacement = materializeAGPRDef(value, builder);
  replacements[value] = replacement;
  return replacement;
}

static void rewritePromotedAGPRUses(Value original, Value agpr,
                                    OpBuilder &builder) {
  SmallVector<OpOperand *> uses;
  for (OpOperand &use : original.getUses())
    uses.push_back(&use);
  for (OpOperand *use : uses) {
    if (use->get() != original)
      continue;
    Operation *user = use->getOwner();
    if (isa<waveamdmachine::VAccvgprWriteB32TupleOp>(user))
      continue;
    if (canConsumeAGPR(*use)) {
      use->set(agpr);
      continue;
    }
    builder.setInsertionPoint(user);
    auto read = waveamdmachine::VAccvgprReadB32TupleOp::create(
        builder, user->getLoc(),
        getRegType(agpr, waveamdmachine::RegClass::VGPR), agpr);
    read->setAttr(kTempAttr, builder.getUnitAttr());
    use->set(read.getResult());
  }
}

static LogicalResult materializeAGPRPromotion(IntervalGroup *group,
                                              OpBuilder &builder) {
  DenseMap<Value, Value> replacements;
  SmallVector<Value> values = getGroupValues(group);
  for (Value value : values) {
    (void)getAGPRReplacement(value, replacements, builder);
  }
  for (Value value : values)
    rewritePromotedAGPRUses(value, replacements.lookup(value), builder);
  return success();
}

static Value materializeVGPRDef(Value value, OpBuilder &builder) {
  Operation *def = value.getDefiningOp();
  builder.setInsertionPointAfter(def);
  auto mov = waveamdmachine::VMovB32TupleOp::create(
      builder, def->getLoc(), getRegType(value, waveamdmachine::RegClass::VGPR),
      value);
  mov->setAttr("registers", builder.getI64IntegerAttr(1));
  mov->setAttr(kTempAttr, builder.getUnitAttr());
  return mov.getResult();
}

static Value getVGPRReplacement(Value value,
                                DenseMap<Value, Value> &replacements,
                                OpBuilder &builder) {
  if (Value existing = replacements.lookup(value))
    return existing;
  Value replacement = materializeVGPRDef(value, builder);
  replacements[value] = replacement;
  return replacement;
}

static void rewritePromotedSGPRUses(Value original, Value vgpr,
                                    OpBuilder &builder) {
  SmallVector<OpOperand *> uses;
  for (OpOperand &use : original.getUses())
    uses.push_back(&use);
  for (OpOperand *use : uses) {
    if (use->get() != original || use->getOwner() == vgpr.getDefiningOp())
      continue;
    builder.setInsertionPoint(use->getOwner());
    auto read = waveamdmachine::VReadfirstlaneB32Op::create(
        builder, use->getOwner()->getLoc(),
        getRegType(original, waveamdmachine::RegClass::SGPR), vgpr);
    read->setAttr(kTempAttr, builder.getUnitAttr());
    use->set(read.getResult());
  }
}

static LogicalResult materializeSGPRPromotion(IntervalGroup *group,
                                              OpBuilder &builder) {
  DenseMap<Value, Value> replacements;
  SmallVector<Value> values = getGroupValues(group);
  for (Value value : values) {
    if (isa<BlockArgument>(value))
      return mlir::emitError(value.getLoc(), kPassName)
             << " cannot promote block arguments before bridge insertion";
    if (cast<waveamdmachine::RegType>(value.getType()).getWidth() != 1)
      return mlir::emitError(value.getLoc(), kPassName)
             << " SGPR promotion supports only width-1 values";
    (void)getVGPRReplacement(value, replacements, builder);
  }
  for (Value value : values)
    rewritePromotedSGPRUses(value, replacements.lookup(value), builder);
  return success();
}

static LogicalResult materializePromotion(IntervalGroup *group,
                                          OpBuilder &builder) {
  if (group->preferredClass == waveamdmachine::RegClass::SGPR &&
      group->storageClass == waveamdmachine::RegClass::VGPR)
    return materializeSGPRPromotion(group, builder);
  if (group->preferredClass == waveamdmachine::RegClass::VGPR &&
      group->storageClass == waveamdmachine::RegClass::AGPR)
    return materializeAGPRPromotion(group, builder);
  return mlir::emitError(builder.getUnknownLoc(), kPassName)
         << " unsupported promotion " << getRegClassName(group->preferredClass)
         << " -> " << getRegClassName(group->storageClass);
}

static LogicalResult materializePromotions(Inventory &inventory,
                                           OpBuilder &builder) {
  for (IntervalGroup *group : getPromotedGroups(inventory))
    if (failed(materializePromotion(group, builder)))
      return failure();
  return success();
}

static LogicalResult materializePlannedPressureRelief(func::FuncOp func,
                                                      Inventory &inventory,
                                                      RegisterBudgets budgets,
                                                      OpBuilder &builder) {
  SmallVector<std::unique_ptr<wave::WaveAMDPressureReliefProvider>, 4>
      providers;
  providers.push_back(createBankPromotionProvider({}, nullptr, /*position=*/0,
                                                  budgets, inventory,
                                                  getBankPromotionHooks()));
  providers.push_back(createLDSSpillProvider(func, {}, nullptr, /*position=*/0,
                                             budgets, inventory));
  providers.push_back(createScratchSpillProvider(func, {}, nullptr,
                                                 /*position=*/0, inventory));
  for (const std::unique_ptr<wave::WaveAMDPressureReliefProvider> &provider :
       providers) {
    SmallVector<const wave::WaveAMDPressureReliefPlan *, 8> plans;
    for (const std::unique_ptr<wave::WaveAMDPressureReliefPlan> &plan :
         inventory.plannedReliefPlans)
      if (plan->getProviderName() == provider->getName())
        plans.push_back(plan.get());
    if (plans.empty())
      continue;
    if (failed(provider->materializePlans(plans, builder)))
      return failure();
  }
  return success();
}

static LogicalResult materializePendingRelief(func::FuncOp func,
                                              Inventory &inventory,
                                              RegisterBudgets budgets,
                                              OpBuilder &builder) {
  if (!inventory.plannedReliefPlans.empty())
    return materializePlannedPressureRelief(func, inventory, budgets, builder);
  if (!getPromotedGroups(inventory).empty())
    return materializePromotions(inventory, builder);
  return success();
}

static bool hasPendingRelief(Inventory &inventory) {
  return !inventory.plannedReliefPlans.empty() ||
         !getPromotedGroups(inventory).empty();
}

static LogicalResult buildInventory(func::FuncOp func, Inventory &inventory) {
  if (failed(validateFunctionRegTypes(func)))
    return failure();
  inventory.entryRegs = wave::getWaveAMDKernelEntryRegs(func);
  for (Block &block : func.getBody())
    flatten(block, inventory);
  createReservedABIIntervals(func, inventory);
  for (Operation *op : inventory.ops) {
    unsigned position = inventory.positions.lookup(op);
    for (Value result : op->getResults())
      createInterval(result, inventory, position);
    for (Value operand : op->getOperands()) {
      extendInterval(operand, inventory, position);
      extendExternalLoopUse(op, operand, inventory);
    }
    if (failed(collectMFMAAccumulatorAlias(*op, inventory, position)) ||
        failed(collectTupleAliases(*op, inventory, position)) ||
        failed(collectLoopAliases(*op, inventory, position)) ||
        failed(collectExecIfAliases(*op, inventory, position)))
      return failure();
  }
  updatePeaks(inventory);
  return success();
}

static bool isFunctionEntryBlockArgument(Value value) {
  auto arg = dyn_cast<BlockArgument>(value);
  return arg && isa<func::FuncOp>(arg.getOwner()->getParentOp());
}

static LogicalResult markFixedValueIfNeeded(Value value, bool recordFixedValues,
                                            Builder &builder) {
  if (!recordFixedValues)
    return success();
  auto type = cast<waveamdmachine::RegType>(value.getType());
  if (type.getIndex() < 0)
    return success();
  return markFixedValue(value, builder);
}

static LogicalResult applyPhysicalAssignments(func::FuncOp func,
                                              Inventory &inventory,
                                              Builder &builder) {
  bool recordFixedValues = shouldRecordRegAllocAssignments(func);
  for (auto [value, interval] : inventory.intervalFor) {
    if (isFunctionEntryBlockArgument(value))
      continue;
    if (failed(markFixedValueIfNeeded(value, recordFixedValues, builder)))
      return failure();
    auto type = cast<waveamdmachine::RegType>(value.getType());
    IntervalGroup *group = interval->group;
    if (group->plannedPressureRelief)
      continue;
    if (!group->assignedBase)
      continue;
    if (type.getRegClass() != group->storageClass)
      continue;
    std::optional<unsigned> laneIndex = getLaneIndex(group, interval);
    if (!laneIndex)
      continue;
    value.setType(waveamdmachine::RegType::get(
        type.getContext(), type.getRegClass(), type.getWidth(),
        *group->assignedBase + *laneIndex));
  }
  return success();
}

static int64_t getValueOrder(Value value, Inventory &inventory) {
  if (Operation *def = value.getDefiningOp()) {
    int64_t pos = inventory.positions.lookup(def);
    return pos * 1024 + getResultIndex(value);
  }
  auto arg = cast<BlockArgument>(value);
  Operation *parent = arg.getOwner()->getParentOp();
  int64_t pos = 0;
  if (!isa_and_nonnull<func::FuncOp>(parent))
    pos = inventory.positions.lookup(parent);
  return pos * 1024 + arg.getArgNumber();
}

static Value selectRepresentative(const Interval &interval,
                                  Inventory &inventory) {
  assert(!interval.values.empty() && "empty intervals are skipped");
  Value selected = *interval.values.begin();
  for (Value value : interval.values)
    if (getValueOrder(value, inventory) < getValueOrder(selected, inventory))
      selected = value;
  return selected;
}

static unsigned getActiveScalarIntervalCount(Inventory &inventory) {
  return llvm::count_if(inventory.intervals, [](const auto &interval) {
    return !interval->values.empty() || interval->reserved;
  });
}

static remark::RemarkOpts getRegAllocRemarkOpts(func::FuncOp func,
                                                StringRef name) {
  return remark::RemarkOpts::name(name)
      .category(kRemarkCategory)
      .function(func.getSymName());
}

static void emitIntegerMetric(remark::detail::InFlightRemark &remark,
                              StringRef name, int64_t value) {
  if (remark)
    remark << mlir::remark::metric(name, value);
}

static void emitStringMetric(remark::detail::InFlightRemark &remark,
                             StringRef name, StringRef value) {
  if (remark)
    remark << mlir::remark::detail::Remark::Arg(name, value);
}

static void emitIntervalRemark(func::FuncOp func, Inventory &inventory,
                               Interval *interval) {
  if (interval->values.empty() && !interval->reserved)
    return;
  auto remark = mlir::remark::analysis(
      func.getLoc(), getRegAllocRemarkOpts(func, "regalloc-interval"));
  if (!remark)
    return;

  emitStringMetric(remark, "class",
                   getRegClassName(interval->type.getRegClass()));
  emitIntegerMetric(remark, "end", interval->end);
  if (interval->type.getIndex() >= 0)
    emitIntegerMetric(remark, "fixed", interval->type.getIndex());
  if (interval->reserved)
    remark << mlir::remark::metric("reserved", true);
  if (interval->group->assignedBase) {
    std::optional<unsigned> laneIndex = getLaneIndex(interval->group, interval);
    if (laneIndex)
      emitIntegerMetric(remark, "phys",
                        *interval->group->assignedBase + *laneIndex);
  }
  emitStringMetric(remark, "storage_class",
                   getRegClassName(interval->group->storageClass));
  emitIntegerMetric(remark, "position", interval->start);
  if (interval->group->storageClass != interval->type.getRegClass())
    remark << mlir::remark::metric("promoted", true);
  int64_t resultIndex = -1;
  if (!interval->values.empty()) {
    Value value = selectRepresentative(*interval, inventory);
    resultIndex = getResultIndex(value);
  }
  emitIntegerMetric(remark, "result", resultIndex);
  emitIntegerMetric(remark, "start", interval->start);
  emitIntegerMetric(remark, "width", interval->type.getWidth());
}

static void emitIntervalRemarks(func::FuncOp func, Inventory &inventory) {
  for (const std::unique_ptr<Interval> &interval : inventory.intervals)
    emitIntervalRemark(func, inventory, interval.get());
}

static void clearDiagnostics(func::FuncOp func) {
  func->removeAttr(kLegacyOverflowedAttr);
  func->removeAttr(kLegacyPressureClassAttr);
  func->removeAttr(kLegacyPressureLimitAttr);
  func->removeAttr(kLegacyPressureLiveAttr);
  func->removeAttr(kLegacyPressureOverlapsAttr);
  func->removeAttr(kLegacyPressurePositionAttr);
  func->removeAttr(kLegacyPressureReliefAttr);
  func->removeAttr(kLegacyPressureRequestAttr);
  func->removeAttr(kLegacyPressureReservedAttr);
  func->removeAttr(kFlatOpsAttr);
  func->removeAttr(kIntervalsAttr);
  func->removeAttr(kLDSSpillPlanAttr);
  func->removeAttr(kScratchSpillPlanAttr);
  func->removeAttr(kOverflowedAttr);
  func->removeAttr(kPeakAGPRAttr);
  func->removeAttr(kPeakSGPRAttr);
  func->removeAttr(kPeakVGPRAttr);
  func->removeAttr(kPressureClassAttr);
  func->removeAttr(kPressureLimitAttr);
  func->removeAttr(kPressureLiveAttr);
  func->removeAttr(kScalarIntervalsAttr);
  func->removeAttr(kTrackedValuesAttr);
  func->removeAttr(kMemorySpillRejectAttr);
  func->removeAttr(kMemorySpillRejectDetailAttr);
}

static void clearTransientRegAllocAttrs(func::FuncOp func) {
  func->removeAttr(kMemorySpillRejectAttr);
  func->removeAttr(kMemorySpillRejectDetailAttr);
  func.walk([](Operation *op) { op->removeAttr(kTempAttr); });
}

static std::optional<unsigned> getUnsignedFuncAttr(func::FuncOp func,
                                                   StringRef name) {
  IntegerAttr attr = func->getAttrOfType<IntegerAttr>(name);
  if (!attr)
    return std::nullopt;
  int64_t value = attr.getInt();
  if (value < 0 ||
      static_cast<uint64_t>(value) > std::numeric_limits<unsigned>::max())
    return std::nullopt;
  return static_cast<unsigned>(value);
}

static void emitLDSSpillPlanRemark(func::FuncOp func, RegisterBudgets budgets) {
  unsigned reservedBytes =
      getUnsignedFuncAttr(func, kLDSSpillBytesAttr).value_or(0);
  LDSSpillPlan plan =
      planLDSSpillSlot(func, budgets, /*valueBytes=*/4, reservedBytes);
  if (plan.status == LDSSpillPlanStatus::NotKernel)
    return;
  auto remark = mlir::remark::analysis(
      func.getLoc(), getRegAllocRemarkOpts(func, "regalloc-lds-plan"));
  if (!remark)
    return;
  emitIntegerMetric(remark, "existing_dynamic_bytes",
                    plan.existingDynamicBytes);
  emitIntegerMetric(remark, "existing_fixed_bytes", plan.existingFixedBytes);
  emitIntegerMetric(remark, "reserved_spill_bytes", plan.reservedSpillBytes);
  emitStringMetric(remark, "status", getLDSSpillPlanStatusName(plan.status));
  emitIntegerMetric(remark, "value_bytes", plan.valueBytes);
  if (plan.status != LDSSpillPlanStatus::Available)
    return;
  emitIntegerMetric(remark, "available_bytes", plan.availableBytes);
  emitIntegerMetric(remark, "limit_bytes", plan.limitBytes);
  emitIntegerMetric(remark, "slot_base", plan.slotBase);
  emitIntegerMetric(remark, "slot_bytes", plan.slotBytes);
  emitIntegerMetric(remark, "wave_stride", plan.waveStride);
  emitIntegerMetric(remark, "wavefront_size", plan.wavefrontSize);
  emitIntegerMetric(remark, "waves_per_workgroup", plan.wavesPerWorkgroup);
}

static void emitScratchSpillPlanRemark(func::FuncOp func) {
  unsigned reservedBytes =
      getUnsignedFuncAttr(func, kScratchSpillBytesAttr).value_or(0);
  ScratchSpillPlan plan =
      planScratchSpillSlot(func, /*valueBytes=*/4, reservedBytes);
  if (plan.status == ScratchSpillPlanStatus::NotKernel)
    return;
  auto remark = mlir::remark::analysis(
      func.getLoc(), getRegAllocRemarkOpts(func, "regalloc-scratch-plan"));
  if (!remark)
    return;
  emitIntegerMetric(remark, "existing_private_bytes",
                    plan.existingPrivateBytes);
  emitIntegerMetric(remark, "reserved_spill_bytes", plan.reservedSpillBytes);
  emitStringMetric(remark, "status",
                   getScratchSpillPlanStatusName(plan.status));
  remark << mlir::remark::metric("uses_flat_scratch", plan.usesFlatScratch);
  emitIntegerMetric(remark, "value_bytes", plan.valueBytes);
  if (plan.status != ScratchSpillPlanStatus::Available)
    return;
  emitIntegerMetric(remark, "slot_base", plan.slotBase);
  emitIntegerMetric(remark, "slot_bytes", plan.slotBytes);
}

static void emitRegAllocRemarks(func::FuncOp func, Inventory &inventory,
                                RegisterBudgets budgets) {
  auto remark = mlir::remark::analysis(
      func.getLoc(), getRegAllocRemarkOpts(func, "regalloc-summary"));
  if (remark) {
    emitIntegerMetric(remark, "flat_ops", inventory.ops.size());
    emitIntegerMetric(remark, "peak_agpr", inventory.peakAGPR);
    emitIntegerMetric(remark, "peak_sgpr", inventory.peakSGPR);
    emitIntegerMetric(remark, "peak_vgpr", inventory.peakVGPR);
    emitIntegerMetric(remark, "scalar_intervals",
                      getActiveScalarIntervalCount(inventory));
    emitIntegerMetric(remark, "tracked_values", inventory.intervalFor.size());
  }
  emitIntervalRemarks(func, inventory);
  emitLDSSpillPlanRemark(func, budgets);
  emitScratchSpillPlanRemark(func);
}

static void emitRejectDetailMetrics(remark::detail::InFlightRemark &remark,
                                    DictionaryAttr detail) {
  if (!remark || !detail)
    return;
  for (StringRef name : {"loop_carry", "temp", "starts_at_pressure",
                         "non_promotable", "memory_issuer", "cross_block",
                         "fixed", "no_use", "eligible", "total"}) {
    IntegerAttr attr = detail.getAs<IntegerAttr>(name);
    if (attr)
      emitIntegerMetric(remark, name, attr.getInt());
  }
}

static void emitPressureFailureRemark(func::FuncOp func,
                                      const PressureFailure &failure) {
  auto remark = mlir::remark::failed(
      func.getLoc(), getRegAllocRemarkOpts(func, "regalloc-pressure-failure"));
  if (!remark)
    return;
  emitStringMetric(remark, "class", failure.regClass);
  emitIntegerMetric(remark, "limit", failure.limit);
  emitIntegerMetric(remark, "live_dwords", failure.liveDwords);
  emitIntegerMetric(remark, "position", failure.position);
  emitIntegerMetric(remark, "required_relief", failure.relief);
  emitIntegerMetric(remark, "reserved", failure.reserved);
  remark << mlir::remark::metric("combined_vgpr_agpr",
                                 failure.combinedVGPRAGPR);
  emitStringMetric(remark, "request",
                   wave::formatWaveAMDPressureInterval(failure.request));
  emitStringMetric(remark, "overlaps",
                   wave::formatWaveAMDPressureIntervals(failure.overlaps));
  if (StringAttr reject =
          func->getAttrOfType<StringAttr>(kMemorySpillRejectAttr))
    emitStringMetric(remark, "memory_spill_reject", reject.getValue());
  emitRejectDetailMetrics(remark, func->getAttrOfType<DictionaryAttr>(
                                      kMemorySpillRejectDetailAttr));
}

static void setOverflowAttrs(func::FuncOp func,
                             const PressureFailure &failure) {
  Builder builder(func.getContext());
  func->setAttr(kLegacyOverflowedAttr, builder.getI64IntegerAttr(1));
  (void)failure;
}

enum class AllocationAttemptResult { Done, Retry };

static FailureOr<bool> enforceBudgetsOrApplyRelief(
    func::FuncOp func, Inventory &inventory, RegisterBudgets budgets,
    std::optional<PressureFailure> &failure, bool softFail) {
  if (succeeded(enforceBudgets(func, inventory, budgets, softFail, failure)))
    return true;
  if (!failure || !failure->combinedVGPRAGPR)
    return false;
  FailureOr<bool> relieved =
      applyCombinedPressureRelief(func, inventory, *failure, budgets);
  if (failed(relieved))
    return mlir::failure();
  return *relieved;
}

static FailureOr<AllocationAttemptResult>
finishSuccessfulAllocation(func::FuncOp func, Inventory &inventory,
                           RegisterBudgets budgets) {
  OpBuilder builder(func.getContext());
  if (hasPendingRelief(inventory)) {
    if (failed(materializePendingRelief(func, inventory, budgets, builder)))
      return mlir::failure();
    return AllocationAttemptResult::Retry;
  }
  if (failed(applyPhysicalAssignments(func, inventory, builder)))
    return mlir::failure();
  updatePeaks(inventory);
  emitRegAllocRemarks(func, inventory, budgets);
  clearTransientRegAllocAttrs(func);
  return AllocationAttemptResult::Done;
}

static FailureOr<AllocationAttemptResult>
runAllocationAttempt(func::FuncOp func, RegisterBudgets budgets,
                     std::optional<PressureFailure> &failure, bool softFail) {
  Inventory inventory;
  if (failed(buildInventory(func, inventory)))
    return mlir::failure();
  if (failed(validateAGPRSupport(func, budgets, inventory)))
    return mlir::failure();

  bool rewroteIR = false;
  LogicalResult allocated =
      allocateGroups(func, inventory, budgets, failure, rewroteIR);
  updatePeaks(inventory);
  if (succeeded(allocated) && rewroteIR)
    return AllocationAttemptResult::Retry;
  if (succeeded(allocated)) {
    FailureOr<bool> budgetSatisfied = enforceBudgetsOrApplyRelief(
        func, inventory, budgets, failure, softFail);
    if (failed(budgetSatisfied))
      return mlir::failure();
    if (!*budgetSatisfied)
      allocated = mlir::failure();
  }
  if (failed(allocated)) {
    emitRegAllocRemarks(func, inventory, budgets);
    return mlir::failure();
  }

  return finishSuccessfulAllocation(func, inventory, budgets);
}

static LogicalResult buildAndAllocate(func::FuncOp func,
                                      RegisterBudgets budgets,
                                      std::optional<PressureFailure> &failure,
                                      bool softFail) {
  if (failed(validateReservedLimits(func, budgets)))
    return mlir::failure();
  for (unsigned attempt : llvm::seq<unsigned>(0, kRewriteAttemptLimit)) {
    (void)attempt;
    FailureOr<AllocationAttemptResult> result =
        runAllocationAttempt(func, budgets, failure, softFail);
    if (failed(result))
      return mlir::failure();
    if (*result == AllocationAttemptResult::Retry)
      continue;
    return success();
  }
  return func.emitError(kPassName) << " IR rewrites did not converge after "
                                   << kRewriteAttemptLimit << " attempts";
}

static FailureOr<RegisterBudgets> getBudgets(ModuleOp root) {
  if (!root->hasAttr("waveamdmachine.target"))
    return root.emitError(kPassName)
           << " requires a waveamdmachine.target attribute";
  FailureOr<wave::WaveAMDRegisterLimits> limits =
      wave::getWaveAMDRegisterLimits(root);
  if (failed(limits))
    return failure();
  RegisterBudgets budgets;
  budgets.maxSGPRsForWaves = limits->maxSGPRsForWaves;
  budgets.maxVGPRsForWaves = limits->maxVGPRsForWaves;
  budgets.addressableSGPR = limits->addressableSGPRs;
  budgets.addressableVGPR = limits->addressableVGPRs;
  budgets.addressableAGPR = limits->addressableAGPRs;
  budgets.sgpr = limits->addressableSGPRs;
  budgets.vgpr = limits->addressableVGPRs;
  budgets.agpr = limits->addressableAGPRs;
  budgets.maxWavesPerEU = limits->maxWavesPerEU;
  budgets.agprCountsAgainstVGPRs = limits->agprCountsAgainstVGPRs;
  if (budgets.agprCountsAgainstVGPRs)
    budgets.totalVGPRLimit = limits->addressableVGPRs;
  return budgets;
}

struct WaveAMDRegAllocPass
    : public wave::impl::WaveAMDRegAllocBase<WaveAMDRegAllocPass> {
  using WaveAMDRegAllocBase::WaveAMDRegAllocBase;

  FailureOr<RegisterBudgets> getFunctionBudgets(func::FuncOp func,
                                                RegisterBudgets budgets) {
    if (failed(applyTargetWavesLimits(func, budgets)))
      return failure();
    return applyLimitOverrides(budgets, sgprLimitOverride, vgprLimitOverride,
                               agprLimitOverride);
  }

  LogicalResult prepareFunction(func::FuncOp func) {
    if (failed(wave::prepareWaveAMDRegAllocIR(func)))
      return failure();
    return wave::verifyNoHardwareResourceLiveRangeOverlap(func, kPassName);
  }

  static void appendMemorySpillRejectDetail(InFlightDiagnostic &diag,
                                            DictionaryAttr detail) {
    if (!detail)
      return;
    bool first = true;
    auto append = [&](StringRef name) {
      IntegerAttr attr = detail.getAs<IntegerAttr>(name);
      if (!attr)
        return;
      if (first) {
        diag << "; memory spill reject detail: ";
        first = false;
      } else {
        diag << ", ";
      }
      diag << name << "=" << attr.getInt();
    };
    append("loop_carry");
    append("temp");
    append("starts_at_pressure");
    append("non_promotable");
    append("memory_issuer");
    append("cross_block");
    append("fixed");
    append("no_use");
    append("eligible");
    append("total");
  }

  static void emitPressureError(func::FuncOp func,
                                const PressureFailure &failure) {
    InFlightDiagnostic diag = func.emitError()
                              << kPassName << " ran out of " << failure.regClass
                              << " registers at position " << failure.position
                              << " (limit=" << failure.limit
                              << ", live_dwords=" << failure.liveDwords
                              << ", required_relief=" << failure.relief << ")";
    diag << "; request=" << wave::formatWaveAMDPressureInterval(failure.request)
         << "; overlaps="
         << wave::formatWaveAMDPressureIntervals(failure.overlaps);
    StringAttr reject = func->getAttrOfType<StringAttr>(kMemorySpillRejectAttr);
    DictionaryAttr detail =
        func->getAttrOfType<DictionaryAttr>(kMemorySpillRejectDetailAttr);
    if (!reject) {
      appendMemorySpillRejectDetail(diag, detail);
      clearTransientRegAllocAttrs(func);
      return;
    }
    if (reject.getValue() == kMemorySpillLoopCarryReject)
      diag << "; memory spill cannot materialize loop-carried values";
    else
      diag << "; memory spill rejected candidates: " << reject.getValue();
    appendMemorySpillRejectDetail(diag, detail);
    clearTransientRegAllocAttrs(func);
  }

  static void emitCombinedPressureError(func::FuncOp func,
                                        const PressureFailure &failure,
                                        RegisterBudgets budgets) {
    func.emitError()
        << kPassName
        << " VGPR/AGPR live pressure exceeds target-waves budget at position "
        << failure.position << " (limit=" << failure.limit
        << ", live_dwords=" << failure.liveDwords
        << ", target_waves=" << budgets.targetWaves << ")";
  }

  WalkResult handleAllocationFailure(func::FuncOp func, RegisterBudgets budgets,
                                     const PressureFailure &failure,
                                     unsigned &overflowCount) {
    emitPressureFailureRemark(func, failure);
    if (markOverflow) {
      setOverflowAttrs(func, failure);
      clearTransientRegAllocAttrs(func);
      ++overflowCount;
      return WalkResult::advance();
    }
    if (failure.combinedVGPRAGPR)
      emitCombinedPressureError(func, failure, budgets);
    else
      emitPressureError(func, failure);
    return WalkResult::interrupt();
  }

  WalkResult processFunction(func::FuncOp func, RegisterBudgets budgets,
                             unsigned &overflowCount) {
    if (func.isExternal())
      return WalkResult::advance();
    clearDiagnostics(func);

    FailureOr<RegisterBudgets> funcBudgets = getFunctionBudgets(func, budgets);
    if (failed(funcBudgets) || failed(prepareFunction(func)))
      return WalkResult::interrupt();

    std::optional<PressureFailure> allocFailure;
    if (failed(buildAndAllocate(func, *funcBudgets, allocFailure,
                                /*softFail=*/markOverflow))) {
      if (!allocFailure)
        return WalkResult::interrupt();
      return handleAllocationFailure(func, *funcBudgets, *allocFailure,
                                     overflowCount);
    }
    if (!markOverflow &&
        failed(wave::verifyWaveAMDRegAllocation(
            func, kPassName, wave::WaveAMDRegAllocVerificationScope::Results)))
      return WalkResult::interrupt();
    return WalkResult::advance();
  }

  void setModuleOverflowCount(ModuleOp root, Builder &builder,
                              unsigned overflowCount) {
    if (markOverflow)
      root->setAttr(kLegacyOverflowCountAttr,
                    builder.getI64IntegerAttr(overflowCount));
    else
      root->removeAttr(kLegacyOverflowCountAttr);
    root->removeAttr(kOverflowCountAttr);
  }

  void runOnOperation() override {
    ModuleOp root = getOperation();
    FailureOr<RegisterBudgets> budgets = getBudgets(root);
    if (failed(budgets))
      return signalPassFailure();

    Builder builder(root.getContext());
    unsigned overflowCount = 0;
    WalkResult result = root.walk([&](func::FuncOp func) {
      return processFunction(func, *budgets, overflowCount);
    });
    setModuleOverflowCount(root, builder, overflowCount);
    if (result.wasInterrupted())
      signalPassFailure();
  }
};

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
