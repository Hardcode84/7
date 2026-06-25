//===- WaveAMDRegAlloc.cpp - WaveAMD register allocation -------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/Wave/Transforms/Passes.h"

#include "../WaveAMDHardwareResources.h"
#include "WaveAMDRegAllocInternal.h"
#include "WaveAMDRegAllocPrep.h"
#include "WaveAMDRegLiveIntervals.h"
#include "WaveAMDRegPressureRelief.h"
#include "WaveAMDRegisterLimits.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/Wave/Transforms/WaveAMDExecIfUtils.h"
#include "mlir/Dialect/Wave/Transforms/WaveAMDRegAllocVerification.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachine.h"
#include "mlir/IR/BuiltinOps.h"
#include "mlir/IR/Remarks.h"
#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/DenseSet.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/Support/raw_ostream.h"
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
static constexpr llvm::StringLiteral kPressureReliefCandidatesAttr =
    "waveamdmachine.regalloc_debug_pressure_relief_candidates";
static constexpr llvm::StringLiteral kPressureReliefProvidersAttr =
    "waveamdmachine.regalloc_debug_pressure_relief_providers";
static constexpr llvm::StringLiteral kRemarkCategory =
    "waveamdmachine-regalloc";
static constexpr llvm::StringLiteral kScalarIntervalsAttr =
    "waveamdmachine.regalloc_debug_scalar_intervals";
static constexpr llvm::StringLiteral kTrackedValuesAttr =
    "waveamdmachine.regalloc_debug_tracked_values";
static constexpr llvm::StringLiteral kProbeAssignedLaneChecksAttr =
    "waveamdmachine.regalloc_debug_probe_assigned_lane_checks";
static constexpr llvm::StringLiteral kProbeAssignedLaneQueriesAttr =
    "waveamdmachine.regalloc_debug_probe_assigned_lane_queries";
static constexpr llvm::StringLiteral kProbeBaseFitsAttr =
    "waveamdmachine.regalloc_debug_probe_base_fits";
static constexpr llvm::StringLiteral kProbeFindFreeBaseAttr =
    "waveamdmachine.regalloc_debug_probe_find_free_base";
static constexpr llvm::StringLiteral kTempAttr = kRegAllocTempAttr;
static constexpr llvm::StringLiteral kFixedBlockArgsAttr =
    "waveamdmachine.regalloc_fixed_block_args";
static constexpr llvm::StringLiteral kFixedResultsAttr =
    "waveamdmachine.regalloc_fixed_results";
static constexpr llvm::StringLiteral kAssignmentsAttr =
    "waveamdmachine.regalloc_assignments";
static constexpr unsigned kFixedBlockArgRecordSize = 3;

static bool isAllocRegClass(waveamdmachine::RegClass regClass) {
  return regClass == waveamdmachine::RegClass::SGPR ||
         regClass == waveamdmachine::RegClass::VGPR ||
         regClass == waveamdmachine::RegClass::AGPR;
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
  // AGPR uses the VGPR wave budget; GFX90A+ also checks combined usage.
  budgets.agpr = std::min(budgets.agpr, vgprBudget);
  budgets.sgpr = std::min(budgets.sgpr, sgprBudget);
  budgets.targetWaves = *targetWaves;
  return success();
}

static LogicalResult reserveExecIfSaveBudget(func::FuncOp func,
                                             RegisterBudgets &budgets) {
  unsigned reserve = wave::getWaveAMDExecIfSaveBudgetReserve(func);
  if (reserve == 0)
    return success();
  if (budgets.sgpr <= reserve)
    return func.emitError(kPassName)
           << " exec_if save stack requires " << reserve << " SGPRs but only "
           << budgets.sgpr << " are available";
  budgets.sgpr -= reserve;
  return success();
}

static SmallVector<std::unique_ptr<wave::WaveAMDPressureReliefProvider>, 4>
createPressureReliefProviders(func::FuncOp func, Inventory &inventory,
                              ArrayRef<IntervalGroup *> assigned,
                              IntervalGroup *request, unsigned position,
                              RegisterBudgets budgets) {
  SmallVector<std::unique_ptr<wave::WaveAMDPressureReliefProvider>, 4>
      providers;
  providers.push_back(createBankPromotionProvider(assigned, request, position,
                                                  budgets, inventory));
  providers.push_back(
      createRematerializeProvider(assigned, request, position, inventory));
  providers.push_back(createLDSSpillProvider(func, assigned, request, position,
                                             budgets, inventory));
  providers.push_back(
      createScratchSpillProvider(func, assigned, request, position, inventory));
  return providers;
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

static bool isAuthoredFixedResult(OpResult result) {
  Operation *op = result.getOwner();
  return isa<waveamdmachine::KernargPreloadOp, waveamdmachine::SWorkgroupIdXOp,
             waveamdmachine::SWorkgroupIdYOp, waveamdmachine::SWorkgroupIdZOp,
             waveamdmachine::UninitOp, waveamdmachine::VWorkitemIdXOp>(op);
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
    if (isAuthoredFixedResult(result))
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

static bool hasProviderRegAllocState(func::FuncOp func) {
  Inventory inventory;
  RegisterBudgets budgets;
  SmallVector<std::unique_ptr<wave::WaveAMDPressureReliefProvider>, 4>
      providers = createPressureReliefProviders(func, inventory, {}, nullptr,
                                                /*position=*/0, budgets);
  for (const std::unique_ptr<wave::WaveAMDPressureReliefProvider> &provider :
       providers)
    if (provider->hasRegAllocState())
      return true;
  return false;
}

static bool shouldClearRegAllocAssignments(func::FuncOp func) {
  return func->hasAttr(kAssignmentsAttr) || hasProviderRegAllocState(func);
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
  func->removeAttr(kAssignmentsAttr);
  return success(!walk.wasInterrupted());
}

static LogicalResult clearRegAllocAssignments(ModuleOp root) {
  WalkResult walk = root->walk([](func::FuncOp func) {
    return failed(clearRegAllocAssignments(func)) ? WalkResult::interrupt()
                                                  : WalkResult::advance();
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

static std::unique_ptr<Interval>
makeScalarInterval(MLIRContext *ctx, waveamdmachine::RegClass cls,
                   int64_t index, unsigned start, unsigned end) {
  std::unique_ptr<Interval> interval = std::make_unique<Interval>();
  interval->type = waveamdmachine::RegType::get(ctx, cls, /*width=*/1, index);
  interval->start = start;
  interval->end = end;
  return interval;
}

static IntervalGroup *
addPlannedTempInterval(Inventory &inventory,
                       wave::WaveAMDPressureReliefTempInterval temp,
                       MLIRContext *ctx) {
  if (temp.width == 0)
    return nullptr;
  std::unique_ptr<IntervalGroup> group = std::make_unique<IntervalGroup>();
  IntervalGroup *groupPtr = group.get();
  groupPtr->preferredClass = temp.regClass;
  groupPtr->storageClass = temp.regClass;
  groupPtr->order = inventory.groups.size();
  groupPtr->nonPromotable = true;
  groupPtr->fixedBase = temp.fixedBase;
  inventory.groups.push_back(std::move(group));

  for (unsigned offset : llvm::seq<unsigned>(0, temp.width)) {
    int64_t index = -1;
    if (temp.fixedBase)
      index = *temp.fixedBase + offset;
    std::unique_ptr<Interval> interval = makeScalarInterval(
        ctx, temp.regClass, index, temp.start, std::max(temp.start, temp.end));
    interval->group = groupPtr;
    interval->nonPromotable = true;
    interval->plannedTemp = true;
    groupPtr->intervals.push_back(interval.get());
    inventory.intervals.push_back(std::move(interval));
  }
  return groupPtr;
}

static void
addPlannedTempIntervals(Inventory &inventory, MLIRContext *ctx,
                        const wave::WaveAMDPressureReliefProvider &provider,
                        const wave::WaveAMDPressureReliefPlan &plan) {
  SmallVector<wave::WaveAMDPressureReliefTempInterval, 4> temps;
  provider.collectPlanTempIntervals(plan, temps);
  for (wave::WaveAMDPressureReliefTempInterval temp : temps) {
    IntervalGroup *group = addPlannedTempInterval(inventory, temp, ctx);
    if (!group)
      continue;
    if (!temp.fixedBase)
      inventory.plannedReliefTemps.push_back({&plan, temp, group});
  }
}

using ReservedLaneUses = SmallVector<std::optional<unsigned>, 8>;

static void noteReservedLaneUse(ReservedLaneUses &lastUses, unsigned lane,
                                unsigned position) {
  if (lane >= lastUses.size())
    return;
  std::optional<unsigned> &lastUse = lastUses[lane];
  lastUse = lastUse ? std::max(*lastUse, position) : position;
}

static void noteReservedSpanUse(ReservedLaneUses &lastUses, unsigned begin,
                                unsigned width, unsigned position) {
  for (unsigned lane : llvm::seq<unsigned>(begin, begin + width))
    noteReservedLaneUse(lastUses, lane, position);
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

static void noteImplicitSGPRABIUse(
    Operation *op, const DenseMap<Operation *, unsigned> &positions,
    DenseMap<Operation *, unsigned> &endCache,
    const wave::WaveAMDKernelEntryRegs &regs, ReservedLaneUses &sgprLastUses) {
  std::optional<StringRef> base = getSLoadBase(op);
  bool isPreload = isa<waveamdmachine::KernargPreloadOp>(op);
  if (!base && !isPreload)
    return;
  unsigned end = getImplicitABIUseEnd(op, positions, endCache);
  if (base) {
    if (std::optional<std::pair<unsigned, unsigned>> span =
            parseSGPRSpan(*base))
      noteReservedSpanUse(sgprLastUses, span->first, span->second, end);
  }
  if (isPreload)
    noteReservedSpanUse(sgprLastUses, regs.kernargSegmentPtrSGPR,
                        regs.kernargSegmentPtrWidth, end);
}

static std::optional<unsigned>
getKernargPreloadBase(waveamdmachine::KernargPreloadOp op,
                      waveamdmachine::RegType type,
                      const wave::WaveAMDKernelEntryRegs &regs) {
  if (type.getRegClass() != waveamdmachine::RegClass::SGPR)
    return std::nullopt;
  uint64_t dwordOffset = op.getDwordOffset();
  if (dwordOffset < regs.kernargPreloadOffsetDwords)
    return std::nullopt;
  uint64_t preloadOffset = dwordOffset - regs.kernargPreloadOffsetDwords;
  if (preloadOffset + static_cast<uint64_t>(type.getWidth()) >
      regs.kernargPreloadDwords)
    return std::nullopt;
  return regs.kernargSegmentPtrWidth + static_cast<unsigned>(preloadOffset);
}

static std::optional<unsigned>
getEntryRegFixedBase(Value value, const wave::WaveAMDKernelEntryRegs &regs) {
  Operation *def = value.getDefiningOp();
  if (!def)
    return std::nullopt;
  auto type = cast<waveamdmachine::RegType>(value.getType());
  if (type.getRegClass() == waveamdmachine::RegClass::VGPR &&
      isa<waveamdmachine::VWorkitemIdXOp>(def))
    return regs.workitemIdXVGPR;
  if (type.getRegClass() == waveamdmachine::RegClass::SGPR) {
    if (isa<waveamdmachine::SWorkgroupIdXOp>(def))
      return regs.workgroupIdSGPR(0);
    if (isa<waveamdmachine::SWorkgroupIdYOp>(def))
      return regs.workgroupIdSGPR(1);
    if (isa<waveamdmachine::SWorkgroupIdZOp>(def))
      return regs.workgroupIdSGPR(2);
    if (auto preload = dyn_cast<waveamdmachine::KernargPreloadOp>(def))
      return getKernargPreloadBase(preload, type, regs);
  }
  return std::nullopt;
}

static LogicalResult
validateEntryRegFixedBase(func::FuncOp func, Value value,
                          const wave::WaveAMDKernelEntryRegs &regs) {
  std::optional<unsigned> abiBase = getEntryRegFixedBase(value, regs);
  if (!abiBase)
    return success();
  auto type = cast<waveamdmachine::RegType>(value.getType());
  if (type.getIndex() < 0 || static_cast<unsigned>(type.getIndex()) == *abiBase)
    return success();
  return diagOpForValue(value, func)->emitError()
         << kPassName << " found " << getRegClassName(type.getRegClass())
         << " value allocated in reserved kernel ABI registers";
}

static void noteEntryRegInterval(const wave::WaveAMDLiveInterval &interval,
                                 const wave::WaveAMDKernelEntryRegs &regs,
                                 ReservedLaneUses &sgprLastUses,
                                 ReservedLaneUses &vgprLastUses) {
  for (auto [value, slot, start, end] :
       llvm::zip(interval.values, interval.slotOffsets, interval.valueStarts,
                 interval.valueEnds)) {
    (void)slot;
    (void)start;
    auto type = cast<waveamdmachine::RegType>(value.getType());
    std::optional<unsigned> abiBase = getEntryRegFixedBase(value, regs);
    if (!abiBase)
      continue;
    unsigned width = static_cast<unsigned>(type.getWidth());
    if (type.getRegClass() == waveamdmachine::RegClass::SGPR)
      noteReservedSpanUse(sgprLastUses, *abiBase, width, end);
    else if (type.getRegClass() == waveamdmachine::RegClass::VGPR)
      noteReservedSpanUse(vgprLastUses, *abiBase, width, end);
  }
}

static void noteEntryRegIntervals(const wave::WaveAMDLiveIntervalSet &intervals,
                                  const wave::WaveAMDKernelEntryRegs &regs,
                                  ReservedLaneUses &sgprLastUses,
                                  ReservedLaneUses &vgprLastUses) {
  for (const wave::WaveAMDLiveInterval &interval : intervals.sgprs)
    noteEntryRegInterval(interval, regs, sgprLastUses, vgprLastUses);
  for (const wave::WaveAMDLiveInterval &interval : intervals.vgprs)
    noteEntryRegInterval(interval, regs, sgprLastUses, vgprLastUses);
}

static void createReservedGroup(Inventory &inventory, MLIRContext *ctx,
                                waveamdmachine::RegClass regClass,
                                ArrayRef<std::optional<unsigned>> lastUses) {
  unsigned width = 0;
  for (auto [lane, lastUse] : llvm::enumerate(lastUses))
    if (lastUse)
      width = lane + 1;
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
    std::unique_ptr<Interval> interval = makeScalarInterval(
        ctx, regClass, offset, /*start=*/0, lastUses[offset].value_or(0));
    interval->group = groupPtr;
    if (lastUses[offset]) {
      interval->reserved = true;
      interval->nonPromotable = true;
    }
    groupPtr->intervals.push_back(interval.get());
    inventory.intervals.push_back(std::move(interval));
  }
}

static void
createReservedABIIntervals(func::FuncOp func, Inventory &inventory,
                           const wave::WaveAMDLiveIntervalSet &intervals) {
  const wave::WaveAMDKernelEntryRegs &regs = inventory.entryRegs;
  ReservedLaneUses sgprLastUses(regs.reservedSGPRs);
  ReservedLaneUses vgprLastUses(regs.reservedVGPRs);
  DenseMap<Operation *, unsigned> endCache;
  for (Operation *op : inventory.ops)
    noteImplicitSGPRABIUse(op, inventory.positions, endCache, regs,
                           sgprLastUses);
  noteEntryRegIntervals(intervals, regs, sgprLastUses, vgprLastUses);
  MLIRContext *ctx = func.getContext();
  createReservedGroup(inventory, ctx, waveamdmachine::RegClass::SGPR,
                      sgprLastUses);
  createReservedGroup(inventory, ctx, waveamdmachine::RegClass::VGPR,
                      vgprLastUses);
}

static bool isFunctionEntryBlockArgument(Value value) {
  auto arg = dyn_cast<BlockArgument>(value);
  return arg && isa<func::FuncOp>(arg.getOwner()->getParentOp());
}

static bool isRegAllocTempValue(Value value) {
  Operation *def = value.getDefiningOp();
  return def && def->hasAttr(kTempAttr);
}

struct ImportedLane {
  llvm::SmallDenseSet<Value, 1> values;
  std::optional<int64_t> fixedIndex;
  Value fixedValue;
  unsigned start = std::numeric_limits<unsigned>::max();
  unsigned end = 0;
  bool nonPromotable = false;
  bool touched = false;
};

static unsigned getDiagnosticPosition(Value value, Inventory &inventory) {
  if (Operation *def = value.getDefiningOp())
    return inventory.positions.lookup(def);
  BlockArgument arg = cast<BlockArgument>(value);
  Operation *parent = arg.getOwner()->getParentOp();
  if (isa<func::FuncOp>(parent))
    return 0;
  return inventory.positions.lookup(parent);
}

static Operation *getFixedAliasConflictDiag(Value oldValue, Value newValue,
                                            func::FuncOp func,
                                            Inventory &inventory) {
  if (getDiagnosticPosition(newValue, inventory) >
      getDiagnosticPosition(oldValue, inventory))
    return diagOpForValue(newValue, func);
  return diagOpForValue(oldValue, func);
}

static LogicalResult recordImportedLaneValue(func::FuncOp func, Value value,
                                             unsigned valueLane, unsigned start,
                                             unsigned end, ImportedLane &lane,
                                             Inventory &inventory) {
  auto type = cast<waveamdmachine::RegType>(value.getType());
  if (failed(validateEntryRegFixedBase(func, value, inventory.entryRegs)))
    return failure();
  if (type.getIndex() >= 0) {
    int64_t fixedIndex = type.getIndex() + valueLane;
    if (lane.fixedIndex && *lane.fixedIndex != fixedIndex)
      return getFixedAliasConflictDiag(lane.fixedValue, value, func, inventory)
                 ->emitError()
             << kPassName << " found incompatible fixed alias registers";
    lane.fixedIndex = fixedIndex;
    lane.fixedValue = value;
  }
  lane.values.insert(value);
  lane.start = std::min(lane.start, start);
  lane.end = std::max(lane.end, end);
  lane.nonPromotable |=
      isFunctionEntryBlockArgument(value) || isRegAllocTempValue(value);
  lane.touched = true;
  return success();
}

static LogicalResult
collectImportedLanes(func::FuncOp func, const wave::WaveAMDLiveInterval &source,
                     SmallVectorImpl<ImportedLane> &lanes,
                     Inventory &inventory) {
  for (auto [value, slot, start, end] :
       llvm::zip(source.values, source.slotOffsets, source.valueStarts,
                 source.valueEnds)) {
    auto type = cast<waveamdmachine::RegType>(value.getType());
    unsigned width = static_cast<unsigned>(type.getWidth());
    if (slot + width > lanes.size())
      return diagOpForValue(value, func)->emitError()
             << kPassName << " live interval alias exceeds register width";
    for (unsigned valueLane : llvm::seq<unsigned>(0, width)) {
      if (failed(recordImportedLaneValue(func, value, valueLane, start, end,
                                         lanes[slot + valueLane], inventory)))
        return failure();
    }
  }
  return success();
}

static LogicalResult importLiveInterval(func::FuncOp func,
                                        const wave::WaveAMDLiveInterval &source,
                                        Inventory &inventory) {
  if (source.values.empty())
    return success();
  unsigned width = static_cast<unsigned>(source.type.getWidth());
  SmallVector<ImportedLane, 8> lanes(width);
  if (failed(collectImportedLanes(func, source, lanes, inventory)))
    return failure();

  std::unique_ptr<IntervalGroup> group = std::make_unique<IntervalGroup>();
  IntervalGroup *groupPtr = group.get();
  groupPtr->preferredClass = source.type.getRegClass();
  groupPtr->storageClass = source.type.getRegClass();
  groupPtr->order = inventory.groups.size();

  bool hasLocalValue = false;
  for (const ImportedLane &lane : lanes) {
    groupPtr->nonPromotable |= lane.nonPromotable;
    for (Value value : lane.values)
      hasLocalValue |= !isFunctionEntryBlockArgument(value);
  }
  groupPtr->allocatable = hasLocalValue;

  inventory.groups.push_back(std::move(group));
  for (unsigned laneIndex : llvm::seq<unsigned>(0, width)) {
    const ImportedLane &lane = lanes[laneIndex];
    unsigned start = lane.touched ? lane.start : source.start;
    unsigned end = lane.touched ? lane.end : source.end;
    int64_t fixedIndex = lane.fixedIndex.value_or(-1);
    std::unique_ptr<Interval> interval =
        makeScalarInterval(source.type.getContext(), source.type.getRegClass(),
                           fixedIndex, start, end);
    interval->values = lane.values;
    interval->group = groupPtr;
    interval->nonPromotable = lane.nonPromotable;
    Interval *intervalPtr = interval.get();
    groupPtr->intervals.push_back(intervalPtr);
    inventory.intervals.push_back(std::move(interval));
  }

  for (auto [value, slot] : llvm::zip(source.values, source.slotOffsets))
    inventory.intervalFor[value] = groupPtr->intervals[slot];
  inventory.scalarIntervals += groupPtr->intervals.size();
  return success();
}

struct ImportRef {
  const wave::WaveAMDLiveInterval *interval;
  unsigned classOrder;
  unsigned intervalOrder;
};

static void appendImportRefs(ArrayRef<wave::WaveAMDLiveInterval> intervals,
                             unsigned classOrder,
                             SmallVectorImpl<ImportRef> &refs) {
  for (auto [index, interval] : llvm::enumerate(intervals))
    if (!interval.values.empty())
      refs.push_back({&interval, classOrder, static_cast<unsigned>(index)});
}

static LogicalResult importLiveIntervals(func::FuncOp func,
                                         wave::WaveAMDLiveIntervalSet &source,
                                         Inventory &inventory) {
  SmallVector<ImportRef, 32> refs;
  appendImportRefs(source.sgprs, /*classOrder=*/0, refs);
  appendImportRefs(source.vgprs, /*classOrder=*/1, refs);
  appendImportRefs(source.agprs, /*classOrder=*/2, refs);
  llvm::stable_sort(refs, [](const ImportRef &lhs, const ImportRef &rhs) {
    return std::tie(lhs.interval->start, lhs.classOrder, lhs.intervalOrder) <
           std::tie(rhs.interval->start, rhs.classOrder, rhs.intervalOrder);
  });
  for (const ImportRef &ref : refs)
    if (failed(importLiveInterval(func, *ref.interval, inventory)))
      return failure();
  return success();
}

static bool hasIntervalPayload(const Interval &interval) {
  return !interval.values.empty() || interval.reserved || interval.plannedTemp;
}

static bool hasIntervalPayload(const Interval *interval) {
  return interval && hasIntervalPayload(*interval);
}

static bool isFixedPlannedTemp(const Interval &interval) {
  return interval.plannedTemp && interval.type.getIndex() >= 0;
}

static bool isFixedPlannedTemp(const Interval *interval) {
  return interval && isFixedPlannedTemp(*interval);
}

static bool countsForLivePressure(const Interval *interval) {
  return hasIntervalPayload(interval) && !isFixedPlannedTemp(interval);
}

static std::optional<unsigned> getLaneIndex(IntervalGroup *group,
                                            Interval *interval) {
  for (auto [index, lane] : llvm::enumerate(group->intervals))
    if (lane == interval)
      return index;
  return std::nullopt;
}

static SmallVector<unsigned, 0>
getLiveDwordsByPosition(ArrayRef<std::unique_ptr<Interval>> intervals,
                        unsigned positionCount,
                        waveamdmachine::RegClass regClass) {
  SmallVector<int64_t, 0> delta(positionCount + 1, 0);
  for (const std::unique_ptr<Interval> &interval : intervals) {
    if (interval->group->plannedPressureRelief)
      continue;
    if (!countsForLivePressure(interval.get()))
      continue;
    if (interval->group->storageClass != regClass)
      continue;
    if (interval->start >= positionCount)
      continue;
    unsigned end = std::min<unsigned>(interval->end, positionCount - 1);
    ++delta[interval->start];
    --delta[end + 1];
  }

  SmallVector<unsigned, 0> liveByPosition;
  liveByPosition.reserve(positionCount);
  int64_t live = 0;
  for (unsigned position : llvm::seq<unsigned>(0, positionCount)) {
    live += delta[position];
    liveByPosition.push_back(static_cast<unsigned>(live));
  }
  return liveByPosition;
}

static bool countsForPeak(const Interval &interval,
                          waveamdmachine::RegClass regClass) {
  if (interval.group->plannedPressureRelief)
    return false;
  if (!countsForLivePressure(&interval))
    return false;
  return interval.group->storageClass == regClass;
}

static unsigned getPeak(Inventory &inventory,
                        waveamdmachine::RegClass regClass) {
  if (inventory.ops.empty())
    return 0;
  SmallVector<int64_t, 0> delta(inventory.ops.size() + 1, 0);
  for (const std::unique_ptr<Interval> &interval : inventory.intervals) {
    if (!countsForPeak(*interval, regClass))
      continue;
    if (interval->start >= inventory.ops.size())
      continue;
    unsigned end = std::min<unsigned>(interval->end, inventory.ops.size() - 1);
    ++delta[interval->start];
    --delta[end + 1];
  }

  int64_t live = 0;
  unsigned peak = 0;
  for (unsigned position : llvm::seq<unsigned>(0, inventory.ops.size())) {
    live += delta[position];
    peak = std::max<unsigned>(peak, live);
  }
  return peak;
}

static void updatePeaks(Inventory &inventory) {
  inventory.peakSGPR = getPeak(inventory, waveamdmachine::RegClass::SGPR);
  inventory.peakVGPR = getPeak(inventory, waveamdmachine::RegClass::VGPR);
  inventory.peakAGPR = getPeak(inventory, waveamdmachine::RegClass::AGPR);
}

static bool isLiveAt(Interval *interval, unsigned position) {
  if (interval->group->plannedPressureRelief)
    return false;
  return hasIntervalPayload(interval) && interval->start <= position &&
         position <= interval->end;
}

static bool isLiveAt(IntervalGroup *group, unsigned position) {
  return llvm::any_of(group->intervals,
                      [&](Interval *lane) { return isLiveAt(lane, position); });
}

static unsigned getGroupStart(IntervalGroup *group) {
  unsigned start = std::numeric_limits<unsigned>::max();
  for (Interval *lane : group->intervals)
    if (hasIntervalPayload(lane))
      start = std::min(start, lane->start);
  return start;
}

static unsigned getGroupEnd(IntervalGroup *group) {
  unsigned end = 0;
  for (Interval *lane : group->intervals)
    if (hasIntervalPayload(lane))
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
  return llvm::any_of(group->intervals,
                      [](Interval *lane) { return hasIntervalPayload(lane); });
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

static void updatePlacementFootprint(unsigned &footprint, unsigned base,
                                     IntervalGroup *group) {
  footprint = std::max(footprint,
                       base + static_cast<unsigned>(group->intervals.size()));
}

static unsigned getFixedPlacementFootprint(Inventory &inventory,
                                           waveamdmachine::RegClass regClass) {
  unsigned footprint = getReservedPrefix(regClass, inventory.entryRegs);
  for (const std::unique_ptr<IntervalGroup> &group : inventory.groups) {
    if (group->storageClass != regClass || !hasLiveLanes(group.get()))
      continue;
    if (std::optional<unsigned> fixedBase = getFixedBase(group.get()))
      updatePlacementFootprint(footprint, *fixedBase, group.get());
  }
  return footprint;
}

static unsigned
getAssignedPlacementFootprint(ArrayRef<IntervalGroup *> groups,
                              waveamdmachine::RegClass regClass,
                              const wave::WaveAMDKernelEntryRegs &regs) {
  unsigned footprint = getReservedPrefix(regClass, regs);
  for (IntervalGroup *group : groups)
    if (group->storageClass == regClass && group->assignedBase)
      updatePlacementFootprint(footprint, *group->assignedBase, group);
  return footprint;
}

static unsigned getInitialCombinedPlacementAGPRFootprint(Inventory &inventory) {
  return std::max(
      inventory.peakAGPR,
      getFixedPlacementFootprint(inventory, waveamdmachine::RegClass::AGPR));
}

static RegisterBudgets applyCombinedPlacementLimits(RegisterBudgets budgets,
                                                    unsigned agprFootprint) {
  if (!budgets.totalVGPRLimit || !budgets.agprCountsAgainstVGPRs)
    return budgets;

  unsigned vgprBudget = 0;
  if (agprFootprint < *budgets.totalVGPRLimit)
    vgprBudget = alignDownTo(*budgets.totalVGPRLimit - agprFootprint, 4);
  if (vgprBudget < budgets.vgpr) {
    budgets.vgpr = vgprBudget;
    budgets.combinedPlacementVGPRLimit = true;
  }
  return budgets;
}

static RegisterBudgets applyCombinedPlacementLimits(RegisterBudgets budgets,
                                                    Inventory &inventory) {
  return applyCombinedPlacementLimits(
      budgets, getInitialCombinedPlacementAGPRFootprint(inventory));
}

static bool canOverlapReservedLane(Interval *lane, unsigned phys,
                                   const wave::WaveAMDKernelEntryRegs &regs) {
  return !lane->values.empty() && llvm::all_of(lane->values, [&](Value value) {
    return canValueOverlapReservedLane(value, phys, regs);
  });
}

static bool
canOverlapFixedPlannedTemp(Interval *lane, Interval *otherLane, unsigned phys,
                           const wave::WaveAMDKernelEntryRegs &regs) {
  if (!lane->plannedTemp)
    return false;
  if (lane->type.getIndex() < 0 || lane->type.getIndex() != phys)
    return false;
  if (canOverlapReservedLane(otherLane, phys, regs))
    return true;
  if (otherLane->reserved)
    return true;
  if (!otherLane->plannedTemp)
    return false;
  return lane->type.getIndex() == otherLane->type.getIndex();
}

static bool lanesCanOverlap(Interval *lane, Interval *otherLane, unsigned phys,
                            const wave::WaveAMDKernelEntryRegs &regs) {
  if (canOverlapFixedPlannedTemp(lane, otherLane, phys, regs) ||
      canOverlapFixedPlannedTemp(otherLane, lane, phys, regs))
    return true;
  if (lane->reserved && canOverlapReservedLane(otherLane, phys, regs))
    return true;
  if (otherLane->reserved && canOverlapReservedLane(lane, phys, regs))
    return true;
  return false;
}

static bool laneBlocksPhys(Interval *lane, Interval *otherLane, unsigned phys,
                           const wave::WaveAMDKernelEntryRegs &regs) {
  if (!hasIntervalPayload(otherLane))
    return false;
  if (lanesCanOverlap(lane, otherLane, phys, regs))
    return false;
  return intervalsOverlap(lane, otherLane);
}

struct AssignedLaneRef {
  IntervalGroup *group = nullptr;
  Interval *lane = nullptr;
  unsigned phys = 0;
  unsigned start = 0;
  unsigned end = 0;
};

struct AssignedLaneBucket {
  SmallVector<AssignedLaneRef, 4> lanes;
  SmallVector<unsigned, 4> prefixMaxEnds;

  void add(AssignedLaneRef ref) {
    auto it = std::lower_bound(lanes.begin(), lanes.end(), ref.start,
                               [](const AssignedLaneRef &lhs, unsigned start) {
                                 return lhs.start < start;
                               });
    size_t index = it - lanes.begin();
    lanes.insert(it, ref);
    prefixMaxEnds.insert(prefixMaxEnds.begin() + index, ref.end);

    unsigned maxEnd = index == 0 ? 0 : prefixMaxEnds[index - 1];
    for (size_t i : llvm::seq<size_t>(index, lanes.size())) {
      maxEnd = std::max(maxEnd, lanes[i].end);
      prefixMaxEnds[i] = maxEnd;
    }
  }

  std::pair<size_t, size_t> getCandidateRange(Interval *lane) const {
    auto lastIt =
        std::upper_bound(lanes.begin(), lanes.end(), lane->end,
                         [](unsigned end, const AssignedLaneRef &ref) {
                           return end < ref.start;
                         });
    size_t last = lastIt - lanes.begin();
    auto firstIt = std::lower_bound(prefixMaxEnds.begin(),
                                    prefixMaxEnds.begin() + last, lane->start);
    return {static_cast<size_t>(firstIt - prefixMaxEnds.begin()), last};
  }
};

struct AssignedRegisterClassIndex {
  SmallVector<AssignedLaneBucket, 0> buckets;

  AssignedLaneBucket &get(unsigned phys) {
    if (phys >= buckets.size())
      buckets.resize(phys + 1);
    return buckets[phys];
  }

  const AssignedLaneBucket *lookup(unsigned phys) const {
    if (phys >= buckets.size())
      return nullptr;
    if (buckets[phys].lanes.empty())
      return nullptr;
    return &buckets[phys];
  }
};

struct AssignedRegisterIndex {
  AssignedRegisterClassIndex sgpr;
  AssignedRegisterClassIndex vgpr;
  AssignedRegisterClassIndex agpr;
  AllocationProbeStats *stats = nullptr;
};

static AssignedRegisterClassIndex *
getAssignedClassIndex(AssignedRegisterIndex &index,
                      waveamdmachine::RegClass regClass) {
  if (regClass == waveamdmachine::RegClass::SGPR)
    return &index.sgpr;
  if (regClass == waveamdmachine::RegClass::VGPR)
    return &index.vgpr;
  if (regClass == waveamdmachine::RegClass::AGPR)
    return &index.agpr;
  return nullptr;
}

static const AssignedRegisterClassIndex *
getAssignedClassIndex(const AssignedRegisterIndex &index,
                      waveamdmachine::RegClass regClass) {
  if (regClass == waveamdmachine::RegClass::SGPR)
    return &index.sgpr;
  if (regClass == waveamdmachine::RegClass::VGPR)
    return &index.vgpr;
  if (regClass == waveamdmachine::RegClass::AGPR)
    return &index.agpr;
  return nullptr;
}

static bool hasAssignedLanePayload(Interval *lane) {
  return hasIntervalPayload(lane);
}

static void addAssignedLane(AssignedRegisterIndex &index, IntervalGroup *group,
                            unsigned laneIndex) {
  if (!group->assignedBase)
    return;
  Interval *lane = group->intervals[laneIndex];
  if (!hasAssignedLanePayload(lane))
    return;
  AssignedRegisterClassIndex *classIndex =
      getAssignedClassIndex(index, group->storageClass);
  if (!classIndex)
    return;
  unsigned phys = *group->assignedBase + laneIndex;
  classIndex->get(phys).add({group, lane, phys, lane->start, lane->end});
}

static void addAssignedGroup(AssignedRegisterIndex &index,
                             IntervalGroup *group) {
  if (!group || !group->assignedBase)
    return;
  for (unsigned laneIndex : llvm::seq<unsigned>(0, group->intervals.size()))
    addAssignedLane(index, group, laneIndex);
}

static void recordAssignedLaneCheck(const AssignedRegisterIndex &index) {
  if (index.stats)
    ++index.stats->assignedLaneChecks;
}

static bool laneConflictsWithGroup(Interval *lane, unsigned phys,
                                   const AssignedLaneRef &other,
                                   const wave::WaveAMDKernelEntryRegs &regs,
                                   const AssignedRegisterIndex &index) {
  recordAssignedLaneCheck(index);
  if (other.group == lane->group || other.phys != phys)
    return false;
  return laneBlocksPhys(lane, other.lane, phys, regs);
}

static void recordAssignedLaneQuery(const AssignedRegisterIndex &index) {
  if (index.stats)
    ++index.stats->assignedLaneQueries;
}

static bool
laneConflictsWithAssigned(Interval *lane, unsigned phys, IntervalGroup *group,
                          const AssignedRegisterIndex &assigned,
                          const wave::WaveAMDKernelEntryRegs &regs) {
  recordAssignedLaneQuery(assigned);
  const AssignedRegisterClassIndex *classIndex =
      getAssignedClassIndex(assigned, group->storageClass);
  if (!classIndex)
    return false;
  const AssignedLaneBucket *bucket = classIndex->lookup(phys);
  if (!bucket)
    return false;

  auto [first, last] = bucket->getCandidateRange(lane);
  for (size_t i : llvm::seq<size_t>(first, last)) {
    const AssignedLaneRef &other = bucket->lanes[i];
    if (laneConflictsWithGroup(lane, phys, other, regs, assigned))
      return true;
  }
  return false;
}

static void recordBaseFits(const AssignedRegisterIndex &index) {
  if (index.stats)
    ++index.stats->baseFitsCalls;
}

static bool baseFits(IntervalGroup *group, unsigned base,
                     const AssignedRegisterIndex &assigned,
                     const wave::WaveAMDKernelEntryRegs &regs) {
  recordBaseFits(assigned);
  for (unsigned laneIndex : llvm::seq<unsigned>(0, group->intervals.size())) {
    Interval *lane = group->intervals[laneIndex];
    if (!hasAssignedLanePayload(lane))
      continue;
    if (laneConflictsWithAssigned(lane, base + laneIndex, group, assigned,
                                  regs))
      return false;
  }
  return true;
}

static void recordFindFreeBase(AssignedRegisterIndex &index) {
  if (index.stats)
    ++index.stats->findFreeBaseCalls;
}

static std::optional<unsigned>
findFreeBase(IntervalGroup *group, RegisterBudgets budgets,
             AssignedRegisterIndex &assigned,
             const wave::WaveAMDKernelEntryRegs &regs) {
  recordFindFreeBase(assigned);
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

static SmallVector<IntervalGroup *> getAllocGroupsExcept(Inventory &inventory,
                                                         IntervalGroup *skip) {
  SmallVector<IntervalGroup *> groups;
  for (IntervalGroup *group : getAllocGroups(inventory))
    if (group != skip)
      groups.push_back(group);
  return groups;
}

static unsigned getGroupLiveDwords(IntervalGroup *group, unsigned position) {
  unsigned live = 0;
  for (Interval *lane : group->intervals)
    if (isLiveAt(lane, position) && countsForLivePressure(lane))
      ++live;
  return live;
}

static unsigned getReservedLiveDwords(Inventory &inventory,
                                      waveamdmachine::RegClass regClass,
                                      unsigned position) {
  unsigned live = 0;
  for (const std::unique_ptr<IntervalGroup> &ownedGroup : inventory.groups) {
    IntervalGroup *group = ownedGroup.get();
    if (!group->reserved || group->storageClass != regClass)
      continue;
    for (Interval *lane : group->intervals)
      if (lane->reserved && isLiveAt(lane, position))
        ++live;
  }
  return live;
}

static bool isAllowedEntryRegGroup(IntervalGroup *group,
                                   const wave::WaveAMDKernelEntryRegs &regs) {
  if (!group->assignedBase)
    return false;
  bool hasEntryValue = false;
  for (auto [laneIndex, lane] : llvm::enumerate(group->intervals)) {
    unsigned phys = *group->assignedBase + laneIndex;
    if (phys >= getReservedPrefix(group->storageClass, regs))
      continue;
    if (lane->values.empty())
      continue;
    if (!canOverlapReservedLane(lane, phys, regs))
      return false;
    hasEntryValue = true;
  }
  return hasEntryValue;
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
  failure.reserved = getReservedLiveDwords(inventory, regClass, position);
  failure.liveDwords = failure.reserved;
  failure.request = buildPressureIntervalRef(request, inventory);
  for (IntervalGroup *group : assigned) {
    if (group == request || group->storageClass != regClass ||
        !isLiveAt(group, position))
      continue;
    if (group->reserved || isAllowedEntryRegGroup(group, inventory.entryRegs))
      continue;
    failure.liveDwords += getGroupLiveDwords(group, position);
    failure.overlaps.push_back(buildPressureIntervalRef(group, inventory));
  }
  failure.relief = estimateRelief(
      failure.liveDwords, getGroupLiveDwords(request, position), failure.limit);
  return failure;
}

static bool contributesToCombinedPressure(IntervalGroup *group,
                                          unsigned position) {
  if (!group || group->reserved || !isLiveAt(group, position))
    return false;
  return group->storageClass == waveamdmachine::RegClass::VGPR ||
         group->storageClass == waveamdmachine::RegClass::AGPR;
}

static PressureFailure
buildCombinedPressureFailure(Inventory &inventory, IntervalGroup *request,
                             unsigned position, unsigned totalVGPRLimit,
                             unsigned agprLive, unsigned vgprLimit,
                             unsigned vgprLive) {
  PressureFailure failure;
  failure.regClass = "VGPR/AGPR";
  failure.combinedAGPRLiveDwords = agprLive;
  failure.combinedVGPRFamilyLimit = totalVGPRLimit;
  failure.limit = vgprLimit;
  failure.position = position;
  failure.reserved = inventory.entryRegs.reservedVGPRs;
  failure.liveDwords = vgprLive;
  failure.combinedVGPRAGPR = true;
  if (request) {
    failure.request = buildPressureIntervalRef(request, inventory);
    failure.relief = vgprLive > vgprLimit ? vgprLive - vgprLimit : 1;
  } else {
    failure.relief = vgprLive > vgprLimit ? vgprLive - vgprLimit : 1;
  }
  for (const std::unique_ptr<IntervalGroup> &group : inventory.groups) {
    if (group.get() == request ||
        !contributesToCombinedPressure(group.get(), position))
      continue;
    failure.overlaps.push_back(
        buildPressureIntervalRef(group.get(), inventory));
  }
  return failure;
}

static std::optional<PressureFailure> buildCombinedPlacementFailure(
    Inventory &inventory, ArrayRef<IntervalGroup *> assigned,
    IntervalGroup *request, unsigned position, RegisterBudgets budgets) {
  if (!budgets.totalVGPRLimit || !budgets.agprCountsAgainstVGPRs ||
      !budgets.combinedPlacementVGPRLimit ||
      request->storageClass != waveamdmachine::RegClass::VGPR)
    return std::nullopt;

  unsigned vgprLimit = getBudget(budgets, waveamdmachine::RegClass::VGPR);
  if (vgprLimit >= *budgets.totalVGPRLimit)
    return std::nullopt;

  PressureFailure classFailure = buildClassPressureFailure(
      inventory, assigned, request, position, request->storageClass, vgprLimit);
  unsigned vgprLiveWithRequest =
      classFailure.liveDwords + getGroupLiveDwords(request, position);
  unsigned agprFootprint = getAssignedPlacementFootprint(
      assigned, waveamdmachine::RegClass::AGPR, inventory.entryRegs);
  PressureFailure failure = buildCombinedPressureFailure(
      inventory, request, position, *budgets.totalVGPRLimit, agprFootprint,
      vgprLimit, vgprLiveWithRequest);
  failure.placementFailure = true;
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
                   RegisterBudgets budgets,
                   const AssignedRegisterIndex &assigned,
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
                  AssignedRegisterIndex &assignedIndex,
                  const wave::WaveAMDKernelEntryRegs &regs) {
  for (IntervalGroup *group : groups) {
    if (!hasFixedRegister(group))
      continue;
    if (failed(validateFixedGroup(func, group, budgets, assignedIndex, regs)))
      return failure();
    assigned.push_back(group);
    addAssignedGroup(assignedIndex, group);
  }
  return success();
}

static bool groupLiveAt(IntervalGroup *group, unsigned position) {
  if (!group || group->plannedPressureRelief)
    return false;
  for (Interval *lane : group->intervals)
    if (lane->start <= position && position <= lane->end)
      return true;
  return false;
}

struct PressureReliefProviderState {
  PressureReliefProviderState(
      std::unique_ptr<wave::WaveAMDPressureReliefProvider> provider,
      unsigned order)
      : provider(std::move(provider)), order(order) {}

  std::unique_ptr<wave::WaveAMDPressureReliefProvider> provider;
  wave::WaveAMDPressureReliefCandidateList candidates;
  unsigned order = 0;
};

struct PressureReliefCandidateRef {
  PressureReliefProviderState *state = nullptr;
  unsigned index = 0;
};

static const wave::WaveAMDPressureReliefCandidate &
getPressureReliefCandidate(PressureReliefCandidateRef ref) {
  return *ref.state->candidates[ref.index];
}

static bool isSelectedPressureReliefCandidate(
    const PressureReliefProviderState &state, unsigned index,
    std::optional<PressureReliefCandidateRef> selected) {
  return selected && selected->state == &state && selected->index == index;
}

static FailureOr<bool> pressureReliefCandidateProgressesFailure(
    PressureReliefCandidateRef ref, const PressureFailure *pressureFailure);

static std::string
formatPressureReliefProviders(ArrayRef<PressureReliefProviderState> providers) {
  std::string out;
  llvm::raw_string_ostream os(out);
  os << "[";
  llvm::interleaveComma(
      providers, os, [&](const PressureReliefProviderState &state) {
        os << "{provider=" << state.provider->getName()
           << ", candidates=" << state.candidates.size();
        if (std::optional<StringRef> reason = state.provider->getRejectReason())
          os << ", reject=" << *reason;
        os << "}";
      });
  os << "]";
  return out;
}

static std::string formatPressureReliefCandidates(
    MutableArrayRef<PressureReliefProviderState> providers,
    std::optional<PressureReliefCandidateRef> selected,
    const PressureFailure *failure) {
  std::string out;
  llvm::raw_string_ostream os(out);
  os << "[";
  bool first = true;
  for (PressureReliefProviderState &state : providers) {
    for (auto [index, candidate] : llvm::enumerate(state.candidates)) {
      if (!first)
        os << ", ";
      first = false;
      std::optional<bool> netReducesFailure;
      if (failure && candidate->isLegal()) {
        PressureReliefCandidateRef ref{&state, static_cast<unsigned>(index)};
        FailureOr<bool> progresses =
            pressureReliefCandidateProgressesFailure(ref, failure);
        if (succeeded(progresses))
          netReducesFailure = *progresses;
      }
      candidate->print(
          os, isSelectedPressureReliefCandidate(state, index, selected),
          failure, netReducesFailure);
    }
  }
  os << "]";
  return out;
}

static void setPressureReliefDiagnostics(
    func::FuncOp func, MutableArrayRef<PressureReliefProviderState> providers,
    std::optional<PressureReliefCandidateRef> selected,
    const PressureFailure *failure) {
  Builder builder(func.getContext());
  func->setAttr(
      kPressureReliefProvidersAttr,
      builder.getStringAttr(formatPressureReliefProviders(providers)));
  func->setAttr(kPressureReliefCandidatesAttr,
                builder.getStringAttr(formatPressureReliefCandidates(
                    providers, selected, failure)));
}

static void emitPressureReliefSelectionRemark(
    func::FuncOp func, MutableArrayRef<PressureReliefProviderState> providers,
    PressureReliefCandidateRef selected, const PressureFailure *failure) {
  auto remark = mlir::remark::analysis(
      func.getLoc(),
      mlir::remark::RemarkOpts::name("regalloc-pressure-relief-selection")
          .category(kRemarkCategory)
          .function(func.getSymName()));
  if (!remark)
    return;

  const wave::WaveAMDPressureReliefCandidate &candidate =
      getPressureReliefCandidate(selected);
  remark << mlir::remark::detail::Remark::Arg("provider",
                                              candidate.getProviderName());
  remark << mlir::remark::metric("candidate_index", selected.index);
  if (failure) {
    remark << mlir::remark::detail::Remark::Arg("class", failure->regClass);
    remark << mlir::remark::metric("position", failure->position);
    remark << mlir::remark::metric("required_relief", failure->relief);
  }
  remark << mlir::remark::detail::Remark::Arg(
      "pressure_relief_candidates",
      formatPressureReliefCandidates(providers, selected, failure));
}

static void clearPressureReliefDiagnostics(func::FuncOp func) {
  func->removeAttr(kPressureReliefCandidatesAttr);
  func->removeAttr(kPressureReliefProvidersAttr);
}

static bool
isBetterProviderPressureReliefCandidate(PressureReliefCandidateRef lhsRef,
                                        PressureReliefCandidateRef rhsRef) {
  assert(lhsRef.state == rhsRef.state &&
         "provider order selects before candidate cost");
  const wave::WaveAMDPressureReliefCandidate &lhs =
      getPressureReliefCandidate(lhsRef);
  const wave::WaveAMDPressureReliefCandidate &rhs =
      getPressureReliefCandidate(rhsRef);
  if (lhs.isLegal() != rhs.isLegal())
    return lhs.isLegal();
  return lhsRef.state->provider->isBetterCandidate(lhs, rhs);
}

static wave::WaveAMDPressureReliefEffect getPressureReliefTempEffect(
    ArrayRef<wave::WaveAMDPressureReliefTempInterval> intervals,
    const PressureFailure &failure) {
  wave::WaveAMDPressureReliefEffect effect;
  for (const wave::WaveAMDPressureReliefTempInterval &interval : intervals) {
    if (interval.fixedBase)
      continue;
    if (failure.position < interval.start || failure.position > interval.end)
      continue;
    if (interval.regClass == waveamdmachine::RegClass::SGPR)
      effect.sgprLiveDelta += interval.width;
    if (interval.regClass == waveamdmachine::RegClass::VGPR)
      effect.vgprLiveDelta += interval.width;
    if (interval.regClass == waveamdmachine::RegClass::AGPR)
      effect.agprLiveDelta += interval.width;
  }
  return effect;
}

static FailureOr<wave::WaveAMDPressureReliefEffect>
getNetPressureReliefEffect(PressureReliefCandidateRef ref,
                           const PressureFailure &pressureFailure) {
  const wave::WaveAMDPressureReliefCandidate &candidate =
      getPressureReliefCandidate(ref);
  std::unique_ptr<wave::WaveAMDPressureReliefPlan> plan =
      ref.state->provider->createPlan(candidate);
  if (!plan)
    return failure();

  SmallVector<wave::WaveAMDPressureReliefTempInterval, 8> intervals;
  ref.state->provider->collectPlanTempIntervals(*plan, intervals);
  return wave::combineWaveAMDPressureReliefEffects(
      candidate.getPressureEffect(pressureFailure),
      getPressureReliefTempEffect(intervals, pressureFailure));
}

static FailureOr<bool> pressureReliefCandidateProgressesFailure(
    PressureReliefCandidateRef ref, const PressureFailure *pressureFailure) {
  if (!pressureFailure)
    return true;
  if (pressureFailure->placementFailure)
    return true;
  FailureOr<wave::WaveAMDPressureReliefEffect> effect =
      getNetPressureReliefEffect(ref, *pressureFailure);
  if (failed(effect))
    return failure();
  return wave::waveAMDPressureReliefEffectProgressesFailure(
      *pressureFailure, wave::WaveAMDPressureReliefEffect{}, *effect);
}

static void addPressureReliefProvider(
    SmallVectorImpl<PressureReliefProviderState> &providers,
    std::unique_ptr<wave::WaveAMDPressureReliefProvider> provider) {
  providers.emplace_back(std::move(provider), providers.size());
}

struct PressureReliefProviderSelection {
  std::optional<PressureReliefCandidateRef> selected;
  bool hasLegalCandidate = false;
};

static FailureOr<PressureReliefProviderSelection>
selectProviderPressureReliefCandidate(PressureReliefProviderState &state,
                                      const PressureFailure *pressureFailure) {
  PressureReliefProviderSelection selection;
  for (size_t index : llvm::seq(state.candidates.size())) {
    PressureReliefCandidateRef candidate{&state, static_cast<unsigned>(index)};
    if (!getPressureReliefCandidate(candidate).isLegal())
      continue;
    selection.hasLegalCandidate = true;
    FailureOr<bool> progresses =
        pressureReliefCandidateProgressesFailure(candidate, pressureFailure);
    if (failed(progresses))
      return failure();
    if (!*progresses)
      continue;
    if (!selection.selected ||
        isBetterProviderPressureReliefCandidate(candidate, *selection.selected))
      selection.selected = candidate;
  }
  return selection;
}

static LogicalResult collectPressureReliefCandidates(
    SmallVectorImpl<PressureReliefProviderState> &providers,
    const wave::WaveAMDPressureReliefQuery &query,
    std::optional<PressureReliefCandidateRef> &selected) {
  for (auto [index, state] : llvm::enumerate(providers)) {
    if (failed(state.provider->collectCandidates(query, state.candidates)))
      return failure();
    FailureOr<PressureReliefProviderSelection> providerSelection =
        selectProviderPressureReliefCandidate(state, query.failure);
    if (failed(providerSelection))
      return failure();
    selected = providerSelection->selected;
    if (providerSelection->hasLegalCandidate) {
      providers.truncate(index + 1);
      return success();
    }
  }
  return success();
}

static void notifyNoPressureReliefCandidate(
    MutableArrayRef<PressureReliefProviderState> providers) {
  for (PressureReliefProviderState &state : providers)
    state.provider->notifyNoCandidate();
}

static void collectPressureReliefFailureDiagnostics(
    ArrayRef<PressureReliefProviderState> providers,
    SmallVectorImpl<wave::WaveAMDPressureReliefProviderDiagnostic>
        &diagnostics) {
  SmallVector<wave::WaveAMDPressureReliefProviderDiagnostic, 4>
      providerDiagnostics;
  for (const PressureReliefProviderState &state : providers) {
    providerDiagnostics.clear();
    state.provider->collectFailureDiagnostics(providerDiagnostics);
    if (providerDiagnostics.empty())
      continue;
    diagnostics.clear();
    for (const wave::WaveAMDPressureReliefProviderDiagnostic &diagnostic :
         providerDiagnostics)
      diagnostics.push_back(diagnostic);
  }
}

static void notifyPressureReliefAttemptStarted(
    MutableArrayRef<PressureReliefProviderState> providers) {
  for (PressureReliefProviderState &state : providers)
    state.provider->notifyAttemptStarted();
}

static IntervalGroup *selectVGPRPressureRequest(Inventory &inventory,
                                                unsigned position);

static void addPressureReliefProviders(
    SmallVectorImpl<PressureReliefProviderState> &providers, func::FuncOp func,
    Inventory &inventory, ArrayRef<IntervalGroup *> assigned,
    IntervalGroup *request, unsigned position, RegisterBudgets budgets) {
  SmallVector<std::unique_ptr<wave::WaveAMDPressureReliefProvider>, 4> created =
      createPressureReliefProviders(func, inventory, assigned, request,
                                    position, budgets);
  for (std::unique_ptr<wave::WaveAMDPressureReliefProvider> &provider : created)
    addPressureReliefProvider(providers, std::move(provider));
}

static FailureOr<bool>
applyPressureRelief(func::FuncOp func, Inventory &inventory,
                    ArrayRef<IntervalGroup *> assigned, IntervalGroup *request,
                    unsigned position, RegisterBudgets budgets,
                    PressureFailure *pressureFailure = nullptr) {
  SmallVector<PressureReliefProviderState, 4> providers;
  providers.reserve(4);
  addPressureReliefProviders(providers, func, inventory, assigned, request,
                             position, budgets);
  if (providers.empty())
    return false;
  if (pressureFailure)
    pressureFailure->providerDiagnostics.clear();
  notifyPressureReliefAttemptStarted(providers);

  wave::WaveAMDPressureReliefQuery query;
  query.scope = func;
  query.failure = pressureFailure;
  std::optional<PressureReliefCandidateRef> selected;
  if (failed(collectPressureReliefCandidates(providers, query, selected)))
    return failure();

  setPressureReliefDiagnostics(func, providers, selected, pressureFailure);
  if (selected)
    emitPressureReliefSelectionRemark(func, providers, *selected,
                                      pressureFailure);
  if (!selected) {
    notifyNoPressureReliefCandidate(providers);
    if (pressureFailure)
      collectPressureReliefFailureDiagnostics(
          providers, pressureFailure->providerDiagnostics);
    return false;
  }

  PressureReliefProviderState &state = *selected->state;
  const wave::WaveAMDPressureReliefCandidate &candidate =
      getPressureReliefCandidate(*selected);
  std::unique_ptr<wave::WaveAMDPressureReliefPlan> plan =
      state.provider->createPlan(candidate);
  if (!plan)
    return failure();
  state.provider->applyPlan(*plan);
  addPlannedTempIntervals(inventory, func.getContext(), *state.provider, *plan);
  state.provider->notifyPlanApplied();
  recordPlannedPressureRelief(inventory, std::move(plan));
  return true;
}

static FailureOr<bool> applyCombinedPressureRelief(func::FuncOp func,
                                                   Inventory &inventory,
                                                   PressureFailure &failure,
                                                   RegisterBudgets budgets) {
  IntervalGroup *request =
      selectVGPRPressureRequest(inventory, failure.position);
  SmallVector<IntervalGroup *> groups =
      getAllocGroupsExcept(inventory, request);
  return applyPressureRelief(func, inventory, groups, request, failure.position,
                             budgets, &failure);
}

static LogicalResult allocateOnce(func::FuncOp func, Inventory &inventory,
                                  ArrayRef<IntervalGroup *> groups,
                                  RegisterBudgets budgets,
                                  PressureFailure &pressureFailure,
                                  bool &promoted, bool &rewroteIR) {
  SmallVector<IntervalGroup *> assigned;
  AssignedRegisterIndex assignedIndex;
  assignedIndex.stats = &inventory.probeStats;
  if (failed(assignFixedGroups(func, groups, budgets, assigned, assignedIndex,
                               inventory.entryRegs)))
    return failure();
  for (IntervalGroup *group : groups) {
    if (hasFixedRegister(group))
      continue;
    RegisterBudgets placementBudgets = applyCombinedPlacementLimits(
        budgets,
        getAssignedPlacementFootprint(assigned, waveamdmachine::RegClass::AGPR,
                                      inventory.entryRegs));
    if (std::optional<unsigned> base = findFreeBase(
            group, placementBudgets, assignedIndex, inventory.entryRegs)) {
      group->assignedBase = *base;
      assigned.push_back(group);
      addAssignedGroup(assignedIndex, group);
      continue;
    }

    unsigned position = getGroupStart(group);
    unsigned plannedBefore = inventory.plannedReliefPlans.size();
    std::optional<PressureFailure> placementFailure =
        buildCombinedPlacementFailure(inventory, assigned, group, position,
                                      placementBudgets);
    PressureFailure classFailure;
    if (!placementFailure)
      classFailure = buildClassPressureFailure(
          inventory, assigned, group, position, group->storageClass,
          getBudget(placementBudgets, group->storageClass));
    PressureFailure *queryFailure =
        placementFailure ? &*placementFailure : &classFailure;
    FailureOr<bool> relieved =
        applyPressureRelief(func, inventory, assigned, group, position,
                            placementBudgets, queryFailure);
    if (failed(relieved))
      return failure();
    if (!*relieved) {
      pressureFailure = *queryFailure;
      return mlir::failure();
    }
    if (inventory.plannedReliefPlans.size() != plannedBefore)
      promoted = true;
    else
      rewroteIR = true;
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
reportCombinedAllocatedOverflow(func::FuncOp func, Inventory &inventory,
                                unsigned vgprCount, unsigned agprCount,
                                RegisterBudgets budgets, bool markOverflow,
                                PressureFailure &pressureFailure) {
  if (!budgets.totalVGPRLimit || !budgets.agprCountsAgainstVGPRs)
    return success();

  unsigned vgprLimit = 0;
  if (agprCount < *budgets.totalVGPRLimit)
    vgprLimit = alignDownTo(*budgets.totalVGPRLimit - agprCount, 4);
  if (vgprCount <= vgprLimit)
    return success();

  pressureFailure = buildCombinedPressureFailure(
      inventory, /*request=*/nullptr, /*position=*/0, *budgets.totalVGPRLimit,
      agprCount, vgprLimit, vgprCount);
  pressureFailure.placementFailure = true;
  pressureFailure.relief = vgprCount - vgprLimit;
  if (markOverflow)
    return mlir::failure();
  return func.emitError()
         << kPassName
         << " VGPR/AGPR count exceeds target-waves budget (vgpr_count="
         << vgprCount << ", agpr_count=" << agprCount
         << ", vgpr_limit=" << vgprLimit
         << ", target_waves=" << budgets.targetWaves << ")";
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
  unsigned agprCount =
      getAllocatedCount(inventory, waveamdmachine::RegClass::AGPR);
  if (failed(reportBudgetOverflow(func, "AGPR", agprCount, budgets.agpr,
                                  budgets.targetWaves, markOverflow,
                                  pressureFailure))) {
    if (markOverflow)
      failureOut = pressureFailure;
    return mlir::failure();
  }
  if (failed(reportCombinedAllocatedOverflow(func, inventory, vgprCount,
                                             agprCount, budgets, markOverflow,
                                             pressureFailure))) {
    if (markOverflow)
      failureOut = pressureFailure;
    return mlir::failure();
  }
  if (failed(reportBudgetOverflow(func, "VGPR", vgprCount, budgets.vgpr,
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
        !group->reserved && groupLiveAt(group.get(), position))
      return group.get();
  return nullptr;
}

static LogicalResult
enforceCombinedVGPRAGPRBudget(Inventory &inventory, RegisterBudgets budgets,
                              std::optional<PressureFailure> &failureOut) {
  if (!budgets.totalVGPRLimit || !budgets.agprCountsAgainstVGPRs)
    return success();
  unsigned positionCount = std::max<unsigned>(1, inventory.ops.size());
  SmallVector<unsigned, 0> agprLiveByPosition = getLiveDwordsByPosition(
      inventory.intervals, positionCount, waveamdmachine::RegClass::AGPR);
  SmallVector<unsigned, 0> vgprLiveByPosition = getLiveDwordsByPosition(
      inventory.intervals, positionCount, waveamdmachine::RegClass::VGPR);
  for (unsigned position : llvm::seq<unsigned>(0, positionCount)) {
    unsigned agprLive = agprLiveByPosition[position];
    unsigned vgprLimit = 0;
    if (agprLive < *budgets.totalVGPRLimit)
      vgprLimit = alignDown(*budgets.totalVGPRLimit - agprLive, 4);
    unsigned vgprLive = vgprLiveByPosition[position];
    if (vgprLive <= vgprLimit)
      continue;
    IntervalGroup *request = selectVGPRPressureRequest(inventory, position);
    failureOut = buildCombinedPressureFailure(inventory, request, position,
                                              *budgets.totalVGPRLimit, agprLive,
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

class PlannedReliefMaterializationContext final
    : public wave::WaveAMDPressureReliefMaterializationContext {
public:
  explicit PlannedReliefMaterializationContext(Inventory &inventory)
      : inventory(inventory) {
    for (const PlannedPressureReliefTempInterval &temp :
         inventory.plannedReliefTemps)
      tempsByPlan[temp.plan].push_back(&temp);
  }

  FailureOr<wave::WaveAMDPressureReliefTempAssignment>
  consumeTempAssignment(const wave::WaveAMDPressureReliefPlan &plan,
                        waveamdmachine::RegClass regClass, unsigned width,
                        Operation *diagOp) override {
    const PlannedPressureReliefTempInterval *temp =
        findMatchingTemp(plan, regClass, width, diagOp);
    if (!temp) {
      if (allTempsConsumed(plan))
        return diagOp->emitError(kPassName)
               << " materialized more pressure-relief temps than planned";
      return diagOp->emitError(kPassName)
             << " materialized pressure-relief temp does not match plan";
    }
    consumedTemps.insert(temp);
    IntervalGroup *group = temp->group;
    if (!group || !group->assignedBase)
      return wave::WaveAMDPressureReliefTempAssignment{regClass, width, -1};
    return wave::WaveAMDPressureReliefTempAssignment{regClass, width,
                                                     *group->assignedBase};
  }

private:
  bool matchesPosition(const wave::WaveAMDPressureReliefTempInterval &temp,
                       Operation *diagOp) const {
    DenseMap<Operation *, unsigned>::const_iterator it =
        inventory.positions.find(diagOp);
    if (it == inventory.positions.end())
      return true;
    return temp.start <= it->second && it->second <= temp.end;
  }

  bool matches(const PlannedPressureReliefTempInterval &temp,
               waveamdmachine::RegClass regClass, unsigned width,
               Operation *diagOp) const {
    return temp.interval.regClass == regClass && temp.interval.width == width &&
           matchesPosition(temp.interval, diagOp);
  }

  const PlannedPressureReliefTempInterval *
  findMatchingTemp(const wave::WaveAMDPressureReliefPlan &plan,
                   waveamdmachine::RegClass regClass, unsigned width,
                   Operation *diagOp) const {
    auto it = tempsByPlan.find(&plan);
    if (it == tempsByPlan.end())
      return nullptr;
    for (const PlannedPressureReliefTempInterval *temp : it->second) {
      if (consumedTemps.contains(temp))
        continue;
      if (matches(*temp, regClass, width, diagOp))
        return temp;
    }
    return nullptr;
  }

  bool allTempsConsumed(const wave::WaveAMDPressureReliefPlan &plan) const {
    auto it = tempsByPlan.find(&plan);
    if (it == tempsByPlan.end())
      return true;
    for (const PlannedPressureReliefTempInterval *temp : it->second)
      if (!consumedTemps.contains(temp))
        return false;
    return true;
  }

  DenseMap<const wave::WaveAMDPressureReliefPlan *,
           SmallVector<const PlannedPressureReliefTempInterval *, 4>>
      tempsByPlan;
  DenseSet<const PlannedPressureReliefTempInterval *> consumedTemps;
  Inventory &inventory;
};

static LogicalResult materializePlannedPressureRelief(func::FuncOp func,
                                                      Inventory &inventory,
                                                      RegisterBudgets budgets,
                                                      OpBuilder &builder) {
  PlannedReliefMaterializationContext context(inventory);
  SmallVector<std::unique_ptr<wave::WaveAMDPressureReliefProvider>, 4>
      providers = createPressureReliefProviders(func, inventory, {}, nullptr,
                                                /*position=*/0, budgets);
  for (const std::unique_ptr<wave::WaveAMDPressureReliefProvider> &provider :
       providers) {
    SmallVector<const wave::WaveAMDPressureReliefPlan *, 8> plans;
    for (const std::unique_ptr<wave::WaveAMDPressureReliefPlan> &plan :
         inventory.plannedReliefPlans)
      if (provider->ownsPlan(*plan))
        plans.push_back(plan.get());
    if (plans.empty())
      continue;
    if (failed(provider->materializePlans(plans, context, builder)))
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
  return success();
}

static bool hasPendingRelief(Inventory &inventory) {
  return !inventory.plannedReliefPlans.empty();
}

static LogicalResult buildInventory(func::FuncOp func, Inventory &inventory) {
  if (failed(validateFunctionRegTypes(func)))
    return failure();
  inventory.entryRegs = wave::getWaveAMDKernelEntryRegs(func);
  FailureOr<wave::WaveAMDLiveIntervalBuildResult> built =
      wave::buildAllocatedWaveAMDLiveIntervals(func);
  if (failed(built))
    return failure();
  inventory.ops.append(built->orderedOps);
  inventory.positions = std::move(built->positions);
  createReservedABIIntervals(func, inventory, built->intervals);
  if (failed(importLiveIntervals(func, built->intervals, inventory)))
    return failure();
  updatePeaks(inventory);
  return success();
}

static LogicalResult markFixedValueIfNeeded(Value value, Builder &builder) {
  auto type = cast<waveamdmachine::RegType>(value.getType());
  if (type.getIndex() < 0)
    return success();
  if (auto result = dyn_cast<OpResult>(value))
    if (isAuthoredFixedResult(result))
      return success();
  return markFixedValue(value, builder);
}

static LogicalResult applyPhysicalAssignments(func::FuncOp func,
                                              Inventory &inventory,
                                              Builder &builder) {
  for (auto [value, interval] : inventory.intervalFor) {
    if (isFunctionEntryBlockArgument(value))
      continue;
    if (failed(markFixedValueIfNeeded(value, builder)))
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
  func->setAttr(kAssignmentsAttr, builder.getUnitAttr());
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
    return hasIntervalPayload(interval.get());
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
  if (!hasIntervalPayload(interval))
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
  func->removeAttr(kOverflowedAttr);
  func->removeAttr(kPeakAGPRAttr);
  func->removeAttr(kPeakSGPRAttr);
  func->removeAttr(kPeakVGPRAttr);
  func->removeAttr(kPressureClassAttr);
  func->removeAttr(kPressureLimitAttr);
  func->removeAttr(kPressureLiveAttr);
  clearPressureReliefDiagnostics(func);
  func->removeAttr(kScalarIntervalsAttr);
  func->removeAttr(kTrackedValuesAttr);
  func->removeAttr(kProbeAssignedLaneChecksAttr);
  func->removeAttr(kProbeAssignedLaneQueriesAttr);
  func->removeAttr(kProbeBaseFitsAttr);
  func->removeAttr(kProbeFindFreeBaseAttr);
}

static void clearTransientRegAllocAttrs(func::FuncOp func) {
  clearPressureReliefDiagnostics(func);
  func.walk([](Operation *op) { op->removeAttr(kTempAttr); });
}

static void emitPressureReliefProviderRemarks(func::FuncOp func,
                                              Inventory &inventory,
                                              RegisterBudgets budgets) {
  SmallVector<PressureReliefProviderState, 4> providers;
  addPressureReliefProviders(providers, func, inventory, {}, nullptr,
                             /*position=*/0, budgets);
  for (const PressureReliefProviderState &state : providers)
    state.provider->emitRemarks();
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
    emitIntegerMetric(remark, "probe_find_free_base",
                      inventory.probeStats.findFreeBaseCalls);
    emitIntegerMetric(remark, "probe_base_fits",
                      inventory.probeStats.baseFitsCalls);
    emitIntegerMetric(remark, "probe_assigned_lane_queries",
                      inventory.probeStats.assignedLaneQueries);
    emitIntegerMetric(remark, "probe_assigned_lane_checks",
                      inventory.probeStats.assignedLaneChecks);
  }
  emitIntervalRemarks(func, inventory);
  emitPressureReliefProviderRemarks(func, inventory, budgets);
}

static void emitProviderDiagnosticMetrics(
    remark::detail::InFlightRemark &remark,
    ArrayRef<wave::WaveAMDPressureReliefProviderDiagnostic> diagnostics) {
  if (!remark)
    return;
  for (const wave::WaveAMDPressureReliefProviderDiagnostic &diagnostic :
       diagnostics) {
    for (const wave::WaveAMDPressureReliefDiagnosticStringMetric &metric :
         diagnostic.stringMetrics)
      emitStringMetric(remark, metric.name, metric.value);
    for (const wave::WaveAMDPressureReliefDiagnosticMetric &metric :
         diagnostic.integerMetrics)
      emitIntegerMetric(remark, metric.name, metric.value);
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
  if (StringAttr providers =
          func->getAttrOfType<StringAttr>(kPressureReliefProvidersAttr))
    emitStringMetric(remark, "pressure_relief_providers", providers.getValue());
  if (StringAttr candidates =
          func->getAttrOfType<StringAttr>(kPressureReliefCandidatesAttr))
    emitStringMetric(remark, "pressure_relief_candidates",
                     candidates.getValue());
  emitProviderDiagnosticMetrics(remark, failure.providerDiagnostics);
}

static void setProbeAttrs(func::FuncOp func,
                          const AllocationProbeStats &stats) {
  Builder builder(func.getContext());
  func->setAttr(kProbeAssignedLaneChecksAttr,
                builder.getI64IntegerAttr(stats.assignedLaneChecks));
  func->setAttr(kProbeAssignedLaneQueriesAttr,
                builder.getI64IntegerAttr(stats.assignedLaneQueries));
  func->setAttr(kProbeBaseFitsAttr,
                builder.getI64IntegerAttr(stats.baseFitsCalls));
  func->setAttr(kProbeFindFreeBaseAttr,
                builder.getI64IntegerAttr(stats.findFreeBaseCalls));
}

static void setOverflowAttrs(func::FuncOp func,
                             const PressureFailure &failure) {
  Builder builder(func.getContext());
  func->setAttr(kLegacyOverflowedAttr, builder.getI64IntegerAttr(1));
  (void)failure;
}

enum class AllocationAttemptResult { Done, Retry };
enum class AllocationLoopResult { Allocated, Failed, Retry };

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
retryAfterPendingRelief(func::FuncOp func, Inventory &inventory,
                        RegisterBudgets budgets, OpBuilder &builder) {
  if (failed(materializePendingRelief(func, inventory, budgets, builder)))
    return mlir::failure();
  if (failed(clearRegAllocAssignments(func)))
    return mlir::failure();
  return AllocationAttemptResult::Retry;
}

static FailureOr<AllocationAttemptResult>
finishSuccessfulAllocation(func::FuncOp func, Inventory &inventory,
                           RegisterBudgets budgets, bool debugProbes) {
  OpBuilder builder(func.getContext());
  if (failed(applyPhysicalAssignments(func, inventory, builder)))
    return mlir::failure();
  if (hasPendingRelief(inventory))
    return retryAfterPendingRelief(func, inventory, budgets, builder);
  if (debugProbes)
    setProbeAttrs(func, inventory.probeStats);
  updatePeaks(inventory);
  emitRegAllocRemarks(func, inventory, budgets);
  clearTransientRegAllocAttrs(func);
  return AllocationAttemptResult::Done;
}

static FailureOr<AllocationLoopResult> allocateWithBudgetRelief(
    func::FuncOp func, Inventory &inventory, RegisterBudgets budgets,
    std::optional<PressureFailure> &failure, bool softFail) {
  LogicalResult allocated = success();
  unsigned maxBudgetReliefAttempts = inventory.groups.size() * 2 + 1;
  for ([[maybe_unused]] unsigned attempt :
       llvm::seq<unsigned>(0, maxBudgetReliefAttempts)) {
    bool rewroteIR = false;
    allocated = allocateGroups(func, inventory, budgets, failure, rewroteIR);
    updatePeaks(inventory);
    if (succeeded(allocated) && rewroteIR)
      return AllocationLoopResult::Retry;
    if (failed(allocated))
      break;
    unsigned plannedBefore = inventory.plannedReliefPlans.size();
    FailureOr<bool> budgetSatisfied = enforceBudgetsOrApplyRelief(
        func, inventory, budgets, failure, softFail);
    if (failed(budgetSatisfied))
      return mlir::failure();
    if (!*budgetSatisfied)
      return AllocationLoopResult::Failed;
    if (inventory.plannedReliefPlans.size() == plannedBefore)
      break;
  }
  if (failed(allocated))
    return AllocationLoopResult::Failed;
  return AllocationLoopResult::Allocated;
}

static FailureOr<AllocationAttemptResult>
finishFailedAllocation(func::FuncOp func, Inventory &inventory,
                       RegisterBudgets budgets, bool debugProbes) {
  if (hasPendingRelief(inventory)) {
    OpBuilder builder(func.getContext());
    return retryAfterPendingRelief(func, inventory, budgets, builder);
  }
  if (debugProbes)
    setProbeAttrs(func, inventory.probeStats);
  emitRegAllocRemarks(func, inventory, budgets);
  return mlir::failure();
}

static FailureOr<AllocationAttemptResult>
runAllocationAttempt(func::FuncOp func, RegisterBudgets budgets,
                     std::optional<PressureFailure> &failure, bool softFail,
                     bool debugProbes) {
  clearPressureReliefDiagnostics(func);
  Inventory inventory;
  if (failed(buildInventory(func, inventory)))
    return mlir::failure();
  updatePeaks(inventory);
  RegisterBudgets allocationBudgets =
      applyCombinedPlacementLimits(budgets, inventory);
  if (failed(validateAGPRSupport(func, allocationBudgets, inventory)))
    return mlir::failure();

  FailureOr<AllocationLoopResult> allocation = allocateWithBudgetRelief(
      func, inventory, allocationBudgets, failure, softFail);
  if (failed(allocation))
    return mlir::failure();
  if (*allocation == AllocationLoopResult::Retry)
    return AllocationAttemptResult::Retry;
  if (*allocation == AllocationLoopResult::Failed)
    return finishFailedAllocation(func, inventory, allocationBudgets,
                                  debugProbes);

  return finishSuccessfulAllocation(func, inventory, allocationBudgets,
                                    debugProbes);
}

static LogicalResult buildAndAllocate(func::FuncOp func,
                                      RegisterBudgets budgets,
                                      std::optional<PressureFailure> &failure,
                                      bool softFail, bool debugProbes) {
  if (failed(validateReservedLimits(func, budgets)))
    return mlir::failure();
  for (unsigned attempt : llvm::seq<unsigned>(0, kRewriteAttemptLimit)) {
    (void)attempt;
    failure.reset();
    FailureOr<AllocationAttemptResult> result =
        runAllocationAttempt(func, budgets, failure, softFail, debugProbes);
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
  return budgets;
}

struct WaveAMDRegAllocPass
    : public wave::impl::WaveAMDRegAllocBase<WaveAMDRegAllocPass> {
  using WaveAMDRegAllocBase::WaveAMDRegAllocBase;

  FailureOr<RegisterBudgets> getFunctionBudgets(func::FuncOp func,
                                                RegisterBudgets budgets) {
    if (failed(applyTargetWavesLimits(func, budgets)))
      return failure();
    RegisterBudgets funcBudgets = applyLimitOverrides(
        budgets, sgprLimitOverride, vgprLimitOverride, agprLimitOverride);
    if (failed(reserveExecIfSaveBudget(func, funcBudgets)))
      return failure();
    return funcBudgets;
  }

  LogicalResult prepareFunction(func::FuncOp func) {
    if (failed(wave::prepareWaveAMDRegAllocIR(func)))
      return failure();
    return wave::verifyNoHardwareResourceLiveRangeOverlap(func, kPassName);
  }

  static void appendProviderFailureDiagnostics(InFlightDiagnostic &diag,
                                               const PressureFailure &failure) {
    for (const wave::WaveAMDPressureReliefProviderDiagnostic &diagnostic :
         failure.providerDiagnostics)
      if (!diagnostic.message.empty())
        diag << "; " << diagnostic.message;
  }

  static void appendPressureReliefSummary(func::FuncOp func,
                                          const PressureFailure &failure,
                                          InFlightDiagnostic &diag) {
    appendProviderFailureDiagnostics(diag, failure);
    if (StringAttr providers =
            func->getAttrOfType<StringAttr>(kPressureReliefProvidersAttr))
      diag << "; pressure relief providers=" << providers.getValue();
    if (StringAttr candidates =
            func->getAttrOfType<StringAttr>(kPressureReliefCandidatesAttr))
      diag << "; pressure relief candidates=" << candidates.getValue();
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
    appendPressureReliefSummary(func, failure, diag);
    clearTransientRegAllocAttrs(func);
  }

  static void emitCombinedPressureError(func::FuncOp func,
                                        const PressureFailure &failure,
                                        RegisterBudgets budgets) {
    InFlightDiagnostic diag =
        func.emitError() << kPassName
                         << " VGPR/AGPR live pressure exceeds "
                            "target-waves budget at position "
                         << failure.position << " (limit=" << failure.limit
                         << ", live_dwords=" << failure.liveDwords
                         << ", required_relief=" << failure.relief
                         << ", target_waves=" << budgets.targetWaves << ")";
    diag << "; request=" << wave::formatWaveAMDPressureInterval(failure.request)
         << "; overlaps="
         << wave::formatWaveAMDPressureIntervals(failure.overlaps);
    appendPressureReliefSummary(func, failure, diag);
    clearTransientRegAllocAttrs(func);
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
    if (failed(clearRegAllocAssignments(func)))
      return WalkResult::interrupt();

    FailureOr<RegisterBudgets> funcBudgets = getFunctionBudgets(func, budgets);
    if (failed(funcBudgets) || failed(prepareFunction(func)))
      return WalkResult::interrupt();

    std::optional<PressureFailure> allocFailure;
    if (failed(buildAndAllocate(func, *funcBudgets, allocFailure,
                                /*softFail=*/markOverflow, debugProbes))) {
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
