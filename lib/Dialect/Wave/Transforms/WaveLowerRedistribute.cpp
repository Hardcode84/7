//===- WaveLowerRedistribute.cpp - symbolic packet movement -----*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/Wave/Transforms/Passes.h"

#include "RegAlloc/WaveAMDRegisterLimits.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/Wave/IR/Wave.h"
#include "mlir/Dialect/Wave/IR/WaveSymbols.h"
#include "mlir/Dialect/Wave/Transforms/WaveLDSAllocation.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachineTarget.h"
#include "mlir/IR/BuiltinAttributes.h"
#include "mlir/IR/PatternMatch.h"
#include "mlir/Support/Timing.h"
#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/DenseSet.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/MC/MCSubtargetInfo.h"
#include "llvm/Support/CheckedArithmetic.h"
#include "llvm/Support/ErrorHandling.h"
#include "llvm/Support/MathExtras.h"

#include <array>
#include <cassert>
#include <cstdint>
#include <limits>
#include <memory>
#include <optional>
#include <tuple>
#include <utility>

namespace mlir::wave {
#define GEN_PASS_DEF_WAVELOWERREDISTRIBUTE
#include "mlir/Dialect/Wave/Transforms/Passes.h.inc"
} // namespace mlir::wave

using namespace mlir;
using namespace mlir::wave;

namespace {

struct RedistributeStageTimingManager {
  RedistributeStageTimingManager() {
    applyDefaultTimingManagerCLOptions(manager);
  }

  DefaultTimingManager manager;
};

static DefaultTimingManager &getRedistributeStageTimingManager() {
  static RedistributeStageTimingManager timing;
  return timing.manager;
}

struct RedistributeStageTiming {
  RedistributeStageTiming() {
    rootScope = getRedistributeStageTimingManager().getRootScope();
    stageScope = rootScope.nest("wave_lower_redistribute_stages");
  }

  TimingScope nest(StringRef name) { return stageScope.nest(name); }

  TimingScope rootScope;
  TimingScope stageScope;
};

static constexpr int64_t kMaxRelationPoints = int64_t{1} << 20;
static constexpr int64_t kMinScratchVectorizationPoints = int64_t{1} << 16;
static constexpr int64_t kScratchVectorizationScanMultiplier = 8;

enum class Movement { Alias, Workitem, Wave, Workgroup, Cluster };

enum class EnumerationPurpose { RelationValidation, MovementClassification };

enum class BlockLoweringStatus {
  Legal,
  Cluster,
  AnalysisFailure,
  SimplificationFailure,
  BlockDependent
};

struct RedistributionClassification {
  Movement movement;
  BlockLoweringStatus blockLowering;
};

using CoordinateCacheKey =
    std::tuple<sym::ExprHandle, sym::ExprHandle, sym::ExprHandle,
               sym::ExprHandle, int64_t, int64_t, int64_t>;
using CoordinateCache = DenseMap<CoordinateCacheKey, int64_t>;
using CoordinateCacheMap =
    DenseMap<Operation *, std::unique_ptr<CoordinateCache>>;

struct RelationDomain {
  sym::ExprHandle block;
  sym::ExprHandle item;
  sym::ExprHandle slot;
  sym::PredHandle blockRange;
  sym::PredHandle itemRange;
  sym::PredHandle slotRange;
  CoordinateCache *coordinateCache = nullptr;
};

struct MaterializedExpr {
  Value value;
  std::optional<int64_t> literal;
};

struct RelationMaterializationPoint {
  sym::ExprHandle expression;
  int64_t destinationSlot;
};

struct PreparedRelationMaterialization {
  sym::ExprHandle expression;
  std::optional<int64_t> literal;
};

struct ScratchStageExpressions {
  sym::ExprHandle storeAddress;
  sym::ExprHandle loadAddress;
};

struct ScratchLayoutPlan {
  SmallVector<std::pair<unsigned, unsigned>, 4> itemXors;
  int64_t vectorElements = 1;
  int64_t groupShift = 0;
  int64_t phaseBits = 0;
  int64_t itemShift = 0;
  int64_t bankConflicts = 0;
};

struct SlotOrder {
  SmallVector<unsigned, 6> logicalBitsByPhysicalBit;
};

struct ScratchVectorizationPlan {
  SlotOrder sourceOrder;
  SlotOrder resultOrder;
  int64_t vectorElements = 1;
};

struct SourceCoordinate {
  int64_t item;
  int64_t slot;
};

struct ScratchRelationMap {
  SmallVector<SourceCoordinate> sources;
  int64_t blocks = 0;
  int64_t items = 0;
  int64_t sourceSlots = 0;
  int64_t resultSlots = 0;
};

struct ScratchAccessPattern {
  SmallVector<SourceCoordinate> loads;
  int64_t resultGroups;
};

struct ScratchStagePlan {
  SmallVector<int64_t> loadBaseGroups;
  SmallVector<int64_t> loadOffsets;
  SmallVector<uint8_t> rawLoadBases;
  ScratchLayoutPlan layout;
  int64_t firstResultGroup = 0;
  int64_t resultGroupCount = 0;
  int64_t firstSourceGroup = 0;
  int64_t sourceGroupCount = 0;
  int64_t scratchBytes = 0;
};

struct ScratchPlan {
  SmallVector<ScratchStagePlan, 1> stages;
  SmallVector<std::optional<int64_t>> selectors;
  SlotOrder sourceOrder;
  SlotOrder resultOrder;
  int64_t vectorElements = 1;
  int64_t scratchBytes = 0;
};

struct ScratchGeometry {
  int64_t sourceGroups = 0;
  int64_t resultGroups = 0;
  int64_t groupBytes = 0;
};

static VectorType getPacketType(Type type) {
  return cast<VectorType>(cast<SimdType>(type).getElementType());
}

static SimdType getPacketElementType(Type type) {
  SimdType packet = cast<SimdType>(type);
  return SimdType::get(type.getContext(), getPacketType(type).getElementType(),
                       packet.getWidth());
}

static SimdType getPacketSliceType(Type type, int64_t elements) {
  SimdType packet = cast<SimdType>(type);
  Type elementType = getPacketType(type).getElementType();
  if (elements > 1)
    elementType = VectorType::get({elements}, elementType);
  return SimdType::get(type.getContext(), elementType, packet.getWidth());
}

static FailureOr<RelationDomain> buildDomain(sym::Store &store,
                                             RedistributeOp op,
                                             CoordinateCache &coordinateCache) {
  int64_t destinationSlots =
      getPacketType(op.getResult().getType()).getNumElements();
  FailureOr<sym::ExprHandle> block = sym::composeExprSym(store, "block");
  FailureOr<sym::ExprHandle> item = sym::composeExprSym(store, "item");
  FailureOr<sym::ExprHandle> slot = sym::composeExprSym(store, "slot");
  FailureOr<sym::PredHandle> blockRange =
      sym::rangeAssumption(store, "block", 0, op.getRelation().getBlocks() - 1);
  FailureOr<sym::PredHandle> itemRange =
      sym::rangeAssumption(store, "item", 0, op.getRelation().getItems() - 1);
  FailureOr<sym::PredHandle> slotRange =
      sym::rangeAssumption(store, "slot", 0, destinationSlots - 1);
  if (failed(block) || failed(item) || failed(slot) || failed(blockRange) ||
      failed(itemRange) || failed(slotRange))
    return failure();
  return RelationDomain{*block,     *item,      *slot,           *blockRange,
                        *itemRange, *slotRange, &coordinateCache};
}

static FailureOr<int64_t> evaluateCoordinate(sym::Analysis &analysis,
                                             sym::ExprHandle expr,
                                             const RelationDomain &domain,
                                             int64_t block, int64_t item,
                                             int64_t slot) {
  assert(domain.coordinateCache && "coordinate cache is missing");
  CoordinateCacheKey key{expr,  domain.block, domain.item, domain.slot,
                         block, item,         slot};
  auto found = domain.coordinateCache->find(key);
  if (found != domain.coordinateCache->end())
    return found->second;

  FailureOr<sym::ExprHandle> blockValue = analysis.composeInteger(block);
  FailureOr<sym::ExprHandle> itemValue = analysis.composeInteger(item);
  FailureOr<sym::ExprHandle> slotValue = analysis.composeInteger(slot);
  if (failed(blockValue) || failed(itemValue) || failed(slotValue))
    return failure();
  std::array<sym::ExprSubstitution, 3> substitutions{
      sym::ExprSubstitution{domain.block, *blockValue},
      sym::ExprSubstitution{domain.item, *itemValue},
      sym::ExprSubstitution{domain.slot, *slotValue}};
  FailureOr<sym::ExprHandle> substituted =
      analysis.substitute(expr, substitutions);
  if (failed(substituted))
    return failure();
  FailureOr<sym::ExprHandle> simplified = analysis.simplify(*substituted);
  if (failed(simplified))
    return failure();
  std::optional<int64_t> value = sym::getIntegerLiteralValue(*simplified);
  if (!value)
    return failure();
  domain.coordinateCache->try_emplace(std::move(key), *value);
  return *value;
}

static FailureOr<SourceCoordinate>
evaluateSourceCoordinate(sym::Analysis &analysis, RedistributeOp op,
                         const RelationDomain &domain, int64_t block,
                         int64_t item, int64_t slot) {
  FailureOr<int64_t> sourceItem = evaluateCoordinate(
      analysis, op.getRelation().getSourceItem(), domain, block, item, slot);
  FailureOr<int64_t> sourceSlot = evaluateCoordinate(
      analysis, op.getRelation().getSourceSlot(), domain, block, item, slot);
  if (failed(sourceItem) || failed(sourceSlot)) {
    op.emitOpError("failed to evaluate verified redistribution relation");
    return failure();
  }
  return SourceCoordinate{*sourceItem, *sourceSlot};
}

static FailureOr<ScratchRelationMap>
buildScratchRelationMap(sym::Store &store, RedistributeOp op,
                        const RelationDomain &domain) {
  FailureOr<std::unique_ptr<sym::Analysis>> analysis =
      sym::Analysis::create(store);
  if (failed(analysis))
    return failure();
  ScratchRelationMap map;
  map.blocks = op.getRelation().getBlocks();
  map.items = op.getRelation().getItems();
  map.sourceSlots = getPacketType(op.getSource().getType()).getNumElements();
  map.resultSlots = getPacketType(op.getResult().getType()).getNumElements();
  map.sources.reserve(map.blocks * map.items * map.resultSlots);
  for (int64_t block : llvm::seq<int64_t>(0, map.blocks)) {
    for (int64_t item : llvm::seq<int64_t>(0, map.items)) {
      for (int64_t slot : llvm::seq<int64_t>(0, map.resultSlots)) {
        FailureOr<SourceCoordinate> source =
            evaluateSourceCoordinate(**analysis, op, domain, block, item, slot);
        if (failed(source))
          return failure();
        map.sources.push_back(*source);
      }
    }
  }
  return map;
}

static const SourceCoordinate &getScratchSource(const ScratchRelationMap &map,
                                                int64_t block, int64_t item,
                                                int64_t slot) {
  int64_t index = (block * map.items + item) * map.resultSlots + slot;
  return map.sources[index];
}

static FailureOr<sym::ExprHandle>
floorDiv(sym::Store &store, sym::ExprHandle value, int64_t divisor) {
  FailureOr<sym::ExprHandle> divisorExpr = sym::composeExprInt(store, divisor);
  if (failed(divisorExpr))
    return failure();
  FailureOr<sym::ExprHandle> divided = sym::composeExprBinary(
      store, value, sym::ExprBinaryOp::Div, *divisorExpr);
  if (failed(divided))
    return failure();
  return sym::composeExprFloor(store, *divided);
}

static FailureOr<sym::ExprHandle>
floorDiv(sym::Analysis &analysis, sym::ExprHandle value, int64_t divisor) {
  FailureOr<sym::ExprHandle> divisorExpr = analysis.composeInteger(divisor);
  if (failed(divisorExpr))
    return failure();
  FailureOr<sym::ExprHandle> divided =
      analysis.compose(value, sym::ExprBinaryOp::Div, *divisorExpr);
  if (failed(divided))
    return failure();
  return analysis.composeFloor(*divided);
}

static FailureOr<sym::ExprHandle>
simplifyForMaterialization(sym::Analysis &analysis, sym::ExprHandle expr) {
  return analysis.simplify(expr);
}

static sym::CheckResult proveSameWave(sym::Analysis &analysis,
                                      sym::ExprHandle sourceItem,
                                      sym::ExprHandle destinationItem,
                                      int64_t waveWidth) {
  FailureOr<sym::ExprHandle> sourceWave =
      floorDiv(analysis, sourceItem, waveWidth);
  FailureOr<sym::ExprHandle> destinationWave =
      floorDiv(analysis, destinationItem, waveWidth);
  if (failed(sourceWave) || failed(destinationWave))
    return sym::CheckResult::Unknown;
  return analysis.equivalent(*sourceWave, *destinationWave);
}

static Movement finishEnumeratedClassification(bool sameBlock, bool sameItem,
                                               bool sameWave,
                                               bool identitySlot) {
  if (!sameBlock)
    return Movement::Cluster;
  if (sameItem && identitySlot)
    return Movement::Alias;
  if (sameItem)
    return Movement::Workitem;
  if (sameWave)
    return Movement::Wave;
  return Movement::Workgroup;
}

static bool redistributionDomainProven(sym::Analysis &analysis,
                                       RedistributeOp op) {
  RedistributionAttr relation = op.getRelation();
  int64_t sourceSlots =
      getPacketType(op.getSource().getType()).getNumElements();
  return analysis.defined(relation.getSourceBlock()) ==
             sym::CheckResult::True &&
         analysis.defined(relation.getSourceItem()) == sym::CheckResult::True &&
         analysis.defined(relation.getSourceSlot()) == sym::CheckResult::True &&
         sym::provablyInRange(analysis, relation.getSourceBlock(), 0,
                              relation.getBlocks() - 1) &&
         sym::provablyInRange(analysis, relation.getSourceItem(), 0,
                              relation.getItems() - 1) &&
         sym::provablyInRange(analysis, relation.getSourceSlot(), 0,
                              sourceSlots - 1);
}

static void emitEnumerationLimit(RedistributeOp op,
                                 EnumerationPurpose purpose) {
  if (purpose == EnumerationPurpose::RelationValidation)
    op.emitOpError(
        "relation needs exhaustive validation beyond the 2^20 point limit");
  else
    op.emitOpError(
        "symbolic movement classification exceeds the 2^20 point limit");
}

static LogicalResult
validateRedistributionPoint(RedistributeOp op, int64_t sourceBlock,
                            int64_t sourceItem, int64_t sourceSlot,
                            int64_t sourceSlots, int64_t destinationBlock,
                            int64_t destinationItem, int64_t destinationSlot) {
  RedistributionAttr relation = op.getRelation();
  if (sourceBlock < 0 || sourceBlock >= relation.getBlocks())
    return op.emitOpError("source block ")
           << sourceBlock << " is out of bounds at destination ("
           << destinationBlock << ", " << destinationItem << ", "
           << destinationSlot << ")";
  if (sourceItem < 0 || sourceItem >= relation.getItems())
    return op.emitOpError("source item ")
           << sourceItem << " is out of bounds at destination ("
           << destinationBlock << ", " << destinationItem << ", "
           << destinationSlot << ")";
  if (sourceSlot < 0 || sourceSlot >= sourceSlots)
    return op.emitOpError("source slot ")
           << sourceSlot << " is out of bounds at destination ("
           << destinationBlock << ", " << destinationItem << ", "
           << destinationSlot << ")";
  return success();
}

static bool fitsRelationPointBudget(RedistributeOp op) {
  int64_t resultSlots =
      getPacketType(op.getResult().getType()).getNumElements();
  std::optional<int64_t> points = llvm::checkedMul(op.getRelation().getBlocks(),
                                                   op.getRelation().getItems());
  if (points)
    points = llvm::checkedMul(*points, resultSlots);
  return points && *points <= kMaxRelationPoints;
}

static FailureOr<Movement> validateAndClassifyByEnumeration(
    sym::Analysis &analysis, RedistributeOp op, const RelationDomain &domain,
    int64_t waveWidth, EnumerationPurpose purpose) {
  int64_t items = op.getRelation().getItems();
  int64_t blocks = op.getRelation().getBlocks();
  int64_t slots = getPacketType(op.getResult().getType()).getNumElements();
  if (!fitsRelationPointBudget(op)) {
    emitEnumerationLimit(op, purpose);
    return failure();
  }

  bool sameBlock = true;
  bool sameItem = true;
  bool sameWave = true;
  bool identitySlot = op.getSource().getType() == op.getResult().getType();
  int64_t sourceSlots =
      getPacketType(op.getSource().getType()).getNumElements();
  for (int64_t block : llvm::seq<int64_t>(0, blocks)) {
    for (int64_t item : llvm::seq<int64_t>(0, items)) {
      for (int64_t slot : llvm::seq<int64_t>(0, slots)) {
        FailureOr<int64_t> sourceBlock =
            evaluateCoordinate(analysis, op.getRelation().getSourceBlock(),
                               domain, block, item, slot);
        FailureOr<int64_t> sourceItem =
            evaluateCoordinate(analysis, op.getRelation().getSourceItem(),
                               domain, block, item, slot);
        FailureOr<int64_t> sourceSlot =
            evaluateCoordinate(analysis, op.getRelation().getSourceSlot(),
                               domain, block, item, slot);
        if (failed(sourceBlock) || failed(sourceItem) || failed(sourceSlot)) {
          op.emitOpError("relation is not total at destination (")
              << block << ", " << item << ", " << slot << ")";
          return failure();
        }
        if (failed(validateRedistributionPoint(op, *sourceBlock, *sourceItem,
                                               *sourceSlot, sourceSlots, block,
                                               item, slot)))
          return failure();
        sameBlock &= *sourceBlock == block;
        sameItem &= *sourceItem == item;
        sameWave &= *sourceItem / waveWidth == item / waveWidth;
        identitySlot &= *sourceSlot == slot;
      }
    }
  }
  return finishEnumeratedClassification(sameBlock, sameItem, sameWave,
                                        identitySlot);
}

static FailureOr<Movement> classifyProvenMovement(sym::Analysis &analysis,
                                                  RedistributeOp op,
                                                  const RelationDomain &domain,
                                                  int64_t waveWidth) {
  sym::CheckResult sameBlock =
      analysis.equivalent(op.getRelation().getSourceBlock(), domain.block);
  if (sameBlock == sym::CheckResult::False)
    return Movement::Cluster;
  if (sameBlock == sym::CheckResult::Unknown)
    return validateAndClassifyByEnumeration(
        analysis, op, domain, waveWidth,
        EnumerationPurpose::MovementClassification);
  sym::CheckResult sameItem =
      analysis.equivalent(op.getRelation().getSourceItem(), domain.item);
  sym::CheckResult identitySlot =
      analysis.equivalent(op.getRelation().getSourceSlot(), domain.slot);
  sym::CheckResult sameWave = proveSameWave(
      analysis, op.getRelation().getSourceItem(), domain.item, waveWidth);

  bool sameType = op.getSource().getType() == op.getResult().getType();
  if (sameType && sameItem == sym::CheckResult::True &&
      identitySlot == sym::CheckResult::True)
    return Movement::Alias;
  if (sameItem == sym::CheckResult::True)
    return Movement::Workitem;
  if (sameWave == sym::CheckResult::True)
    return Movement::Wave;
  if (sameWave == sym::CheckResult::False)
    return Movement::Workgroup;
  return validateAndClassifyByEnumeration(
      analysis, op, domain, waveWidth,
      EnumerationPurpose::MovementClassification);
}

static bool hasSymbol(sym::ExprHandle expr, StringRef needle) {
  bool found = false;
  sym::walkSymbolNames(expr, [&](StringRef name) { found |= name == needle; });
  return found;
}

static BlockLoweringStatus classifyBlockLowering(sym::Analysis &analysis,
                                                 RedistributeOp op,
                                                 Movement movement,
                                                 bool hasDomainFacts) {
  if (movement == Movement::Cluster)
    return BlockLoweringStatus::Cluster;
  if (movement == Movement::Alias || op.getRelation().getBlocks() == 1)
    return BlockLoweringStatus::Legal;
  if (!hasDomainFacts)
    return BlockLoweringStatus::AnalysisFailure;

  for (sym::ExprHandle expr :
       {op.getRelation().getSourceItem(), op.getRelation().getSourceSlot()}) {
    FailureOr<sym::ExprHandle> simplified = analysis.simplify(expr);
    if (failed(simplified))
      return BlockLoweringStatus::SimplificationFailure;
    if (hasSymbol(*simplified, "block"))
      return BlockLoweringStatus::BlockDependent;
  }
  return BlockLoweringStatus::Legal;
}

static FailureOr<RedistributionClassification>
validateAndClassifyMovement(sym::Store &store, RedistributeOp op,
                            const RelationDomain &domain, int64_t waveWidth) {
  std::array<sym::PredHandle, 3> assumptions{
      domain.blockRange, domain.itemRange, domain.slotRange};
  FailureOr<std::unique_ptr<sym::Analysis>> analysis =
      sym::Analysis::create(store, assumptions);
  bool hasDomainFacts = succeeded(analysis);
  if (!hasDomainFacts)
    analysis = sym::Analysis::create(store);
  if (failed(analysis))
    return failure();

  FailureOr<Movement> movement =
      hasDomainFacts && redistributionDomainProven(**analysis, op)
          ? classifyProvenMovement(**analysis, op, domain, waveWidth)
          : validateAndClassifyByEnumeration(
                **analysis, op, domain, waveWidth,
                EnumerationPurpose::RelationValidation);
  if (failed(movement))
    return failure();
  return RedistributionClassification{
      *movement,
      classifyBlockLowering(**analysis, op, *movement, hasDomainFacts)};
}

static LogicalResult validateBlockLowering(RedistributeOp op,
                                           BlockLoweringStatus blockLowering) {
  switch (blockLowering) {
  case BlockLoweringStatus::Legal:
    return success();
  case BlockLoweringStatus::Cluster:
    return op.emitOpError(
        "cross-block redistribution requires cluster/DSM lowering");
  case BlockLoweringStatus::AnalysisFailure:
    return op.emitOpError("failed to analyze redistribution relation");
  case BlockLoweringStatus::SimplificationFailure:
    return op.emitOpError("failed to simplify redistribution relation");
  case BlockLoweringStatus::BlockDependent:
    return op.emitOpError(
        "block-dependent redistribution requires a cluster block coordinate");
  }
  llvm_unreachable("unknown block lowering status");
  return success();
}

static DenseI32ArrayAttr getWorkgroupShape(func::FuncOp func) {
  for (StringRef name : {"wave.workgroup_size", "gpu.known_block_size"}) {
    DenseI32ArrayAttr shape = func->getAttrOfType<DenseI32ArrayAttr>(name);
    if (shape)
      return shape;
  }
  return {};
}

static bool isInsideWhere(RedistributeOp op, func::FuncOp func) {
  for (Operation *parent = op->getParentOp(); parent && parent != func;
       parent = parent->getParentOp())
    if (isa<WhereOp>(parent))
      return true;
  return false;
}

static LogicalResult validateWorkgroup(RedistributeOp op, func::FuncOp func,
                                       int64_t waveWidth) {
  DenseI32ArrayAttr shape = getWorkgroupShape(func);
  if (!shape)
    return op.emitOpError("requires a known workgroup shape");
  ArrayRef<int32_t> dims = shape.asArrayRef();
  if (dims.size() != 3 || dims[1] != 1 || dims[2] != 1)
    return op.emitOpError("requires an X-linear workgroup shape [items, 1, 1]");
  if (dims[0] != op.getRelation().getItems())
    return op.emitOpError("relation item count ")
           << op.getRelation().getItems() << " does not match workgroup size "
           << dims[0];
  if (dims[0] % waveWidth != 0)
    return op.emitOpError("workgroup size must be divisible by SIMD width");
  if (isInsideWhere(op, func))
    return op.emitOpError("requires full-wave execution outside wave.where");
  return success();
}

static SlotOrder getIdentitySlotOrder() { return SlotOrder{}; }

static ScratchVectorizationPlan getScalarScratchVectorization() {
  ScratchVectorizationPlan plan;
  plan.sourceOrder = getIdentitySlotOrder();
  plan.resultOrder = getIdentitySlotOrder();
  return plan;
}

static int64_t logicalToPhysicalSlot(const SlotOrder &order,
                                     int64_t logicalSlot) {
  if (order.logicalBitsByPhysicalBit.empty())
    return logicalSlot;
  uint64_t physicalSlot = 0;
  for (auto [physicalBit, logicalBit] :
       llvm::enumerate(order.logicalBitsByPhysicalBit))
    physicalSlot |= ((static_cast<uint64_t>(logicalSlot) >> logicalBit) & 1)
                    << physicalBit;
  return static_cast<int64_t>(physicalSlot);
}

static int64_t physicalToLogicalSlot(const SlotOrder &order,
                                     int64_t physicalSlot) {
  if (order.logicalBitsByPhysicalBit.empty())
    return physicalSlot;
  uint64_t logicalSlot = 0;
  for (auto [physicalBit, logicalBit] :
       llvm::enumerate(order.logicalBitsByPhysicalBit))
    logicalSlot |= ((static_cast<uint64_t>(physicalSlot) >> physicalBit) & 1)
                   << logicalBit;
  return static_cast<int64_t>(logicalSlot);
}

static SlotOrder getSlotOrder(unsigned slotBits, uint64_t vectorMask) {
  SlotOrder order;
  for (unsigned bit : llvm::seq<unsigned>(0, slotBits))
    if (vectorMask & (uint64_t{1} << bit))
      order.logicalBitsByPhysicalBit.push_back(bit);
  for (unsigned bit : llvm::seq<unsigned>(0, slotBits))
    if (!(vectorMask & (uint64_t{1} << bit)))
      order.logicalBitsByPhysicalBit.push_back(bit);
  return order;
}

static SmallVector<SlotOrder> getSlotOrders(int64_t slots,
                                            int64_t vectorElements) {
  SmallVector<SlotOrder> orders;
  if (vectorElements == 1 || !llvm::isPowerOf2_64(slots) ||
      !llvm::isPowerOf2_64(vectorElements)) {
    orders.push_back(getIdentitySlotOrder());
    return orders;
  }

  unsigned slotBits = llvm::Log2_64(slots);
  unsigned vectorBits = llvm::Log2_64(vectorElements);
  if (slotBits >= 63) {
    orders.push_back(getIdentitySlotOrder());
    return orders;
  }

  uint64_t maskLimit = uint64_t{1} << slotBits;
  for (uint64_t vectorMask = 0; vectorMask < maskLimit; ++vectorMask) {
    if (static_cast<unsigned>(llvm::popcount(vectorMask)) != vectorBits)
      continue;
    orders.push_back(getSlotOrder(slotBits, vectorMask));
  }
  return orders;
}

static FailureOr<bool> supportsVectorAt(sym::Analysis &analysis,
                                        RedistributeOp op,
                                        const RelationDomain &domain,
                                        int64_t block, int64_t item,
                                        int64_t slot, int64_t vectorElements) {
  FailureOr<SourceCoordinate> first =
      evaluateSourceCoordinate(analysis, op, domain, block, item, slot);
  if (failed(first))
    return failure();
  int64_t vectorGroup = first->slot / vectorElements;
  for (int64_t offset : llvm::seq<int64_t>(1, vectorElements)) {
    FailureOr<SourceCoordinate> next = evaluateSourceCoordinate(
        analysis, op, domain, block, item, slot + offset);
    if (failed(next))
      return failure();
    if (next->item != first->item || next->slot / vectorElements != vectorGroup)
      return false;
  }
  return true;
}

static bool supportsOrderedVectorAt(const ScratchRelationMap &map,
                                    int64_t block, int64_t item,
                                    int64_t physicalResultSlot,
                                    const ScratchVectorizationPlan &plan) {
  int64_t destinationSlot =
      physicalToLogicalSlot(plan.resultOrder, physicalResultSlot);
  const SourceCoordinate &first =
      getScratchSource(map, block, item, destinationSlot);
  int64_t sourceGroup =
      logicalToPhysicalSlot(plan.sourceOrder, first.slot) / plan.vectorElements;
  for (int64_t offset : llvm::seq<int64_t>(1, plan.vectorElements)) {
    destinationSlot =
        physicalToLogicalSlot(plan.resultOrder, physicalResultSlot + offset);
    const SourceCoordinate &next =
        getScratchSource(map, block, item, destinationSlot);
    int64_t nextSourceGroup =
        logicalToPhysicalSlot(plan.sourceOrder, next.slot) /
        plan.vectorElements;
    if (next.item != first.item || nextSourceGroup != sourceGroup)
      return false;
  }
  return true;
}

static FailureOr<bool> supportsVectorTransfer(sym::Analysis &analysis,
                                              RedistributeOp op,
                                              const RelationDomain &domain,
                                              int64_t vectorElements) {
  int64_t blocks = op.getRelation().getBlocks();
  int64_t items = op.getRelation().getItems();
  int64_t resultSlots =
      getPacketType(op.getResult().getType()).getNumElements();
  if (!fitsRelationPointBudget(op))
    return false;

  for (int64_t block : llvm::seq<int64_t>(0, blocks)) {
    for (int64_t item : llvm::seq<int64_t>(0, items)) {
      for (int64_t slot = 0; slot < resultSlots; slot += vectorElements) {
        FailureOr<bool> supported = supportsVectorAt(
            analysis, op, domain, block, item, slot, vectorElements);
        if (failed(supported))
          return failure();
        if (!*supported)
          return false;
      }
    }
  }
  return true;
}

static std::optional<bool>
supportsOrderedVectorTransfer(const ScratchRelationMap &map,
                              const ScratchVectorizationPlan &plan,
                              int64_t &remainingPoints) {
  for (int64_t block : llvm::seq<int64_t>(0, map.blocks)) {
    for (int64_t item : llvm::seq<int64_t>(0, map.items)) {
      for (int64_t physicalSlot = 0; physicalSlot < map.resultSlots;
           physicalSlot += plan.vectorElements) {
        if (remainingPoints < plan.vectorElements)
          return std::nullopt;
        remainingPoints -= plan.vectorElements;
        if (!supportsOrderedVectorAt(map, block, item, physicalSlot, plan))
          return false;
      }
    }
  }
  return true;
}

static int64_t
getScratchVectorizationPointBudget(const ScratchRelationMap &map) {
  int64_t relationPoints = static_cast<int64_t>(map.sources.size());
  return std::min(
      kMaxRelationPoints,
      std::max(kMinScratchVectorizationPoints,
               relationPoints * kScratchVectorizationScanMultiplier));
}

static FailureOr<int64_t> selectVectorElements(sym::Analysis &analysis,
                                               RedistributeOp op,
                                               const RelationDomain &domain,
                                               int64_t maxVectorBits) {
  int64_t sourceSlots =
      getPacketType(op.getSource().getType()).getNumElements();
  int64_t resultSlots =
      getPacketType(op.getResult().getType()).getNumElements();
  int64_t elementBits = getPacketType(op.getSource().getType())
                            .getElementType()
                            .getIntOrFloatBitWidth();
  int64_t limit = std::min(sourceSlots, resultSlots);
  if (maxVectorBits)
    limit = std::min(limit, maxVectorBits / elementBits);
  int64_t vectorElements = 1;
  while (vectorElements <= limit / 2)
    vectorElements *= 2;
  for (; vectorElements > 1; vectorElements /= 2) {
    if (sourceSlots % vectorElements || resultSlots % vectorElements)
      continue;
    FailureOr<bool> supported =
        supportsVectorTransfer(analysis, op, domain, vectorElements);
    if (failed(supported))
      return failure();
    if (*supported)
      return vectorElements;
  }
  return 1;
}

static FailureOr<ScratchVectorizationPlan>
selectScratchVectorization(const ScratchRelationMap &map, RedistributeOp op,
                           int64_t maxVectorBits) {
  int64_t sourceSlots =
      getPacketType(op.getSource().getType()).getNumElements();
  int64_t resultSlots =
      getPacketType(op.getResult().getType()).getNumElements();
  int64_t elementBits = getPacketType(op.getSource().getType())
                            .getElementType()
                            .getIntOrFloatBitWidth();
  int64_t limit = std::min(sourceSlots, resultSlots);
  if (maxVectorBits)
    limit = std::min(limit, maxVectorBits / elementBits);
  int64_t vectorElements = 1;
  while (vectorElements <= limit / 2)
    vectorElements *= 2;
  int64_t remainingPoints = getScratchVectorizationPointBudget(map);

  for (; vectorElements > 1; vectorElements /= 2) {
    if (sourceSlots % vectorElements || resultSlots % vectorElements)
      continue;
    SmallVector<SlotOrder> sourceOrders =
        getSlotOrders(sourceSlots, vectorElements);
    SmallVector<SlotOrder> resultOrders =
        getSlotOrders(resultSlots, vectorElements);
    for (const SlotOrder &sourceOrder : sourceOrders) {
      for (const SlotOrder &resultOrder : resultOrders) {
        ScratchVectorizationPlan plan;
        plan.sourceOrder = sourceOrder;
        plan.resultOrder = resultOrder;
        plan.vectorElements = vectorElements;
        std::optional<bool> supported =
            supportsOrderedVectorTransfer(map, plan, remainingPoints);
        if (!supported)
          return getScalarScratchVectorization();
        if (*supported)
          return plan;
      }
    }
  }

  return getScalarScratchVectorization();
}

static FailureOr<std::optional<int64_t>>
inferVectorSelector(sym::Analysis &analysis, RedistributeOp op,
                    const RelationDomain &domain, int64_t destinationSlot,
                    int64_t vectorElements) {
  std::optional<int64_t> selector;
  for (int64_t block : llvm::seq<int64_t>(0, op.getRelation().getBlocks())) {
    for (int64_t item : llvm::seq<int64_t>(0, op.getRelation().getItems())) {
      FailureOr<int64_t> sourceSlot =
          evaluateCoordinate(analysis, op.getRelation().getSourceSlot(), domain,
                             block, item, destinationSlot);
      if (failed(sourceSlot)) {
        op.emitOpError("failed to evaluate verified redistribution relation");
        return failure();
      }
      int64_t current = *sourceSlot % vectorElements;
      if (!selector)
        selector = current;
      else if (*selector != current)
        return std::optional<int64_t>();
    }
  }
  return selector;
}

static FailureOr<SmallVector<std::optional<int64_t>>>
inferVectorSelectors(sym::Analysis &analysis, RedistributeOp op,
                     const RelationDomain &domain, int64_t vectorElements) {
  int64_t resultSlots =
      getPacketType(op.getResult().getType()).getNumElements();
  SmallVector<std::optional<int64_t>> selectors;
  selectors.reserve(resultSlots);
  if (vectorElements == 1) {
    selectors.resize(resultSlots, 0);
    return selectors;
  }
  for (int64_t slot : llvm::seq<int64_t>(0, resultSlots)) {
    FailureOr<std::optional<int64_t>> selector =
        inferVectorSelector(analysis, op, domain, slot, vectorElements);
    if (failed(selector))
      return failure();
    selectors.push_back(*selector);
  }
  return selectors;
}

static std::optional<int64_t>
inferScratchVectorSelector(const ScratchRelationMap &map,
                           int64_t destinationSlot,
                           const ScratchVectorizationPlan &plan) {
  std::optional<int64_t> selector;
  for (int64_t block : llvm::seq<int64_t>(0, map.blocks)) {
    for (int64_t item : llvm::seq<int64_t>(0, map.items)) {
      int64_t sourceSlot =
          getScratchSource(map, block, item, destinationSlot).slot;
      int64_t current = logicalToPhysicalSlot(plan.sourceOrder, sourceSlot) %
                        plan.vectorElements;
      if (!selector)
        selector = current;
      else if (*selector != current)
        return std::optional<int64_t>();
    }
  }
  return selector;
}

static SmallVector<std::optional<int64_t>>
inferScratchVectorSelectors(const ScratchRelationMap &map,
                            const ScratchVectorizationPlan &plan) {
  SmallVector<std::optional<int64_t>> selectors;
  selectors.reserve(map.resultSlots);
  if (plan.vectorElements == 1) {
    selectors.resize(map.resultSlots, 0);
    return selectors;
  }
  for (int64_t slot : llvm::seq<int64_t>(0, map.resultSlots))
    selectors.push_back(inferScratchVectorSelector(map, slot, plan));
  return selectors;
}

static FailureOr<int64_t> getSharedMemoryBankCount(Operation *op) {
  ModuleOp targetModule = waveamdmachine::findAMDGPUTargetModule(op);
  if (!targetModule)
    return 32;
  FailureOr<std::unique_ptr<llvm::MCSubtargetInfo>> sti =
      waveamdmachine::createAMDGPUMCSubtargetInfo(op,
                                                  "wave-lower-redistribute");
  if (failed(sti))
    return failure();
  if (std::optional<waveamdmachine::AMDGPUTargetCapabilities> capabilities =
          waveamdmachine::getAMDGPUTargetCapabilities(**sti))
    return capabilities->localMemoryBankCount;
  FailureOr<llvm::AMDGPU::IsaVersion> isa =
      waveamdmachine::getAMDGPUTargetIsaVersion(op, "wave-lower-redistribute");
  if (failed(isa))
    return failure();
  if (isa->Major == 9 && isa->Minor == 5)
    return 64;
  return 32;
}

static int64_t physicalScratchVectorAddress(const ScratchLayoutPlan &plan,
                                            int64_t items, int64_t item,
                                            int64_t slot) {
  int64_t group = slot / plan.vectorElements;
  int64_t physicalItem = item;
  for (auto [sourceBit, targetBit] : plan.itemXors)
    physicalItem ^= ((static_cast<uint64_t>(item) >> sourceBit) & 1)
                    << targetBit;
  if (plan.phaseBits) {
    int64_t phase =
        (group >> plan.groupShift) & ((int64_t{1} << plan.phaseBits) - 1);
    physicalItem ^= phase << plan.itemShift;
  }
  return (group * items + physicalItem) * plan.vectorElements;
}

static int64_t scoreBankAccesses(ArrayRef<int64_t> addresses,
                                 int64_t vectorElements, int64_t elementBits,
                                 int64_t banks) {
  int64_t vectorBits = vectorElements * elementBits;
  int64_t dwords = std::max<int64_t>(1, (vectorBits + 31) / 32);
  int64_t phaseLanes = std::max<int64_t>(1, banks / dwords);
  int64_t score = 0;
  for (int64_t start = 0; start < static_cast<int64_t>(addresses.size());
       start += phaseLanes) {
    // Same dword is one LDS broadcast.
    DenseSet<int64_t> words;
    SmallVector<int64_t, 64> bankUse(banks, 0);
    int64_t end = std::min<int64_t>(start + phaseLanes, addresses.size());
    for (int64_t address : addresses.slice(start, end - start)) {
      int64_t firstBit = address * elementBits;
      int64_t firstWord = firstBit / 32;
      int64_t lastWord = (firstBit + vectorBits - 1) / 32;
      for (int64_t word : llvm::seq<int64_t>(firstWord, lastWord + 1))
        if (words.insert(word).second)
          ++bankUse[word % banks];
    }
    score += *llvm::max_element(bankUse) - 1;
  }
  return score;
}

static int64_t scoreStoreLayout(const ScratchLayoutPlan &plan, int64_t items,
                                int64_t sourceSlots, int64_t waveWidth,
                                int64_t elementBits, int64_t banks) {
  int64_t score = 0;
  for (int64_t slot = 0; slot < sourceSlots; slot += plan.vectorElements) {
    for (int64_t wave = 0; wave < items; wave += waveWidth) {
      SmallVector<int64_t> addresses;
      addresses.reserve(waveWidth);
      for (int64_t lane : llvm::seq<int64_t>(0, waveWidth))
        addresses.push_back(
            physicalScratchVectorAddress(plan, items, wave + lane, slot));
      score +=
          scoreBankAccesses(addresses, plan.vectorElements, elementBits, banks);
    }
  }
  return score;
}

static ScratchAccessPattern
buildScratchAccessPattern(const ScratchRelationMap &map,
                          const ScratchVectorizationPlan &plan) {
  ScratchAccessPattern pattern;
  pattern.resultGroups = map.resultSlots / plan.vectorElements;
  pattern.loads.reserve(pattern.resultGroups * map.items);
  for (int64_t physicalSlot = 0; physicalSlot < map.resultSlots;
       physicalSlot += plan.vectorElements) {
    int64_t destinationSlot =
        physicalToLogicalSlot(plan.resultOrder, physicalSlot);
    for (int64_t item : llvm::seq<int64_t>(0, map.items)) {
      SourceCoordinate source = getScratchSource(map, 0, item, destinationSlot);
      source.slot = logicalToPhysicalSlot(plan.sourceOrder, source.slot);
      pattern.loads.push_back(source);
    }
  }
  return pattern;
}

struct ScratchRepGeometry {
  int64_t reps;
  int64_t sourceGroupsPerRep;
  int64_t resultGroupsPerRep;
};

static bool supportsScratchRepSlice(
    const ScratchRelationMap &map, const ScratchVectorizationPlan &plan,
    const ScratchRepGeometry &geometry, int64_t block, int64_t item,
    int64_t localResultGroup, int64_t physicalOffset,
    MutableArrayRef<int64_t> sourceRepForResultRep) {
  int64_t referenceItem = 0;
  int64_t referenceSourceGroup = 0;
  int64_t referenceSourceOffset = 0;
  for (int64_t resultRep : llvm::seq<int64_t>(0, geometry.reps)) {
    int64_t physicalResultSlot =
        (resultRep * geometry.resultGroupsPerRep + localResultGroup) *
            plan.vectorElements +
        physicalOffset;
    int64_t destinationSlot =
        physicalToLogicalSlot(plan.resultOrder, physicalResultSlot);
    const SourceCoordinate &source =
        getScratchSource(map, block, item, destinationSlot);
    int64_t physicalSourceSlot =
        logicalToPhysicalSlot(plan.sourceOrder, source.slot);
    int64_t sourceGroup = physicalSourceSlot / plan.vectorElements;
    int64_t sourceRep = sourceGroup / geometry.sourceGroupsPerRep;
    int64_t localSourceGroup = sourceGroup % geometry.sourceGroupsPerRep;
    int64_t sourceOffset = physicalSourceSlot % plan.vectorElements;
    if (sourceRepForResultRep[resultRep] == -1)
      sourceRepForResultRep[resultRep] = sourceRep;
    else if (sourceRepForResultRep[resultRep] != sourceRep)
      return false;

    if (resultRep == 0) {
      referenceItem = source.item;
      referenceSourceGroup = localSourceGroup;
      referenceSourceOffset = sourceOffset;
      continue;
    }
    if (referenceItem != source.item ||
        referenceSourceGroup != localSourceGroup ||
        referenceSourceOffset != sourceOffset)
      return false;
  }
  return true;
}

static bool isScratchRepPermutation(ArrayRef<int64_t> sourceRepForResultRep,
                                    int64_t reps) {
  SmallVector<uint8_t> seenSourceRep(reps, 0);
  for (int64_t sourceRep : sourceRepForResultRep) {
    if (sourceRep < 0 || sourceRep >= reps || seenSourceRep[sourceRep])
      return false;
    seenSourceRep[sourceRep] = 1;
  }
  return true;
}

// Equivalent per-rep gathers can publish each register segment independently.
static bool supportsScratchRepFactor(const ScratchRelationMap &map,
                                     const ScratchVectorizationPlan &plan,
                                     int64_t reps) {
  int64_t sourceGroups = map.sourceSlots / plan.vectorElements;
  int64_t resultGroups = map.resultSlots / plan.vectorElements;
  if (reps <= 1 || sourceGroups % reps || resultGroups % reps)
    return false;
  ScratchRepGeometry geometry{reps, sourceGroups / reps, resultGroups / reps};
  SmallVector<int64_t> sourceRepForResultRep(reps, -1);

  for (int64_t block : llvm::seq<int64_t>(0, map.blocks)) {
    for (int64_t item : llvm::seq<int64_t>(0, map.items)) {
      for (int64_t localResultGroup :
           llvm::seq<int64_t>(0, geometry.resultGroupsPerRep)) {
        for (int64_t physicalOffset :
             llvm::seq<int64_t>(0, plan.vectorElements)) {
          if (!supportsScratchRepSlice(map, plan, geometry, block, item,
                                       localResultGroup, physicalOffset,
                                       sourceRepForResultRep))
            return false;
        }
      }
    }
  }
  return isScratchRepPermutation(sourceRepForResultRep, reps);
}

static int64_t getScratchRepSourceGroups(const ScratchRelationMap &map,
                                         const ScratchVectorizationPlan &plan) {
  int64_t sourceGroups = map.sourceSlots / plan.vectorElements;
  int64_t resultGroups = map.resultSlots / plan.vectorElements;
  int64_t reps = 1;
  while (reps <= std::min(sourceGroups, resultGroups) / 2)
    reps *= 2;
  for (; reps > 1; reps /= 2)
    if (supportsScratchRepFactor(map, plan, reps))
      return sourceGroups / reps;
  return sourceGroups;
}

static int64_t scoreLoadLayout(const ScratchAccessPattern &pattern,
                               const ScratchLayoutPlan &plan, int64_t items,
                               int64_t waveWidth, int64_t elementBits,
                               int64_t banks) {
  int64_t score = 0;
  for (int64_t group : llvm::seq<int64_t>(0, pattern.resultGroups)) {
    for (int64_t wave = 0; wave < items; wave += waveWidth) {
      SmallVector<int64_t> addresses;
      addresses.reserve(waveWidth);
      for (int64_t lane : llvm::seq<int64_t>(0, waveWidth)) {
        int64_t item = wave + lane;
        const SourceCoordinate &source = pattern.loads[group * items + item];
        addresses.push_back(physicalScratchVectorAddress(
            plan, items, source.item, source.slot));
      }
      score +=
          scoreBankAccesses(addresses, plan.vectorElements, elementBits, banks);
    }
  }
  return score;
}

static int64_t scoreScratchLayout(RedistributeOp op,
                                  const ScratchAccessPattern &pattern,
                                  const ScratchLayoutPlan &plan,
                                  int64_t sourceSlots, int64_t waveWidth,
                                  int64_t banks) {
  int64_t elementBits = getPacketType(op.getSource().getType())
                            .getElementType()
                            .getIntOrFloatBitWidth();
  int64_t score = scoreStoreLayout(plan, op.getRelation().getItems(),
                                   sourceSlots, waveWidth, elementBits, banks);
  return score + scoreLoadLayout(pattern, plan, op.getRelation().getItems(),
                                 waveWidth, elementBits, banks);
}

static bool exceedsScratchPlanningBudget(RedistributeOp op,
                                         int64_t vectorElements) {
  int64_t sourceSlots =
      getPacketType(op.getSource().getType()).getNumElements();
  int64_t resultSlots =
      getPacketType(op.getResult().getType()).getNumElements();
  std::optional<int64_t> groups = llvm::checkedAdd(
      sourceSlots / vectorElements, resultSlots / vectorElements);
  std::optional<int64_t> accesses =
      groups ? llvm::checkedMul(*groups, op.getRelation().getItems())
             : std::nullopt;
  return !accesses || *accesses > kMaxRelationPoints;
}

static ScratchLayoutPlan
selectPhaseScratchLayout(RedistributeOp op, const ScratchAccessPattern &pattern,
                         int64_t sourceSlots, int64_t waveWidth, int64_t banks,
                         unsigned groupBits, unsigned itemBits,
                         ScratchLayoutPlan best) {
  for (unsigned groupShift = 0; groupShift < groupBits; ++groupShift) {
    unsigned maxPhaseBits = std::min(groupBits - groupShift, itemBits);
    for (unsigned phaseBits = 1; phaseBits <= maxPhaseBits; ++phaseBits) {
      for (unsigned itemShift = 0; itemShift + phaseBits <= itemBits;
           ++itemShift) {
        ScratchLayoutPlan candidate;
        candidate.vectorElements = best.vectorElements;
        candidate.groupShift = groupShift;
        candidate.phaseBits = phaseBits;
        candidate.itemShift = itemShift;
        candidate.bankConflicts = scoreScratchLayout(
            op, pattern, candidate, sourceSlots, waveWidth, banks);
        if (candidate.bankConflicts < best.bankConflicts)
          best = candidate;
      }
    }
  }
  return best;
}

static ScratchLayoutPlan selectItemXorScratchLayout(
    RedistributeOp op, const ScratchAccessPattern &pattern, int64_t sourceSlots,
    int64_t waveWidth, int64_t banks, unsigned itemBits,
    ScratchLayoutPlan best) {
  bool improved = true;
  while (improved) {
    improved = false;
    ScratchLayoutPlan iterationBest = best;
    for (unsigned sourceBit = 1; sourceBit < itemBits; ++sourceBit) {
      for (unsigned targetBit = 0; targetBit < sourceBit; ++targetBit) {
        std::pair<unsigned, unsigned> itemXor{sourceBit, targetBit};
        if (llvm::is_contained(best.itemXors, itemXor))
          continue;
        ScratchLayoutPlan candidate = best;
        candidate.itemXors.push_back(itemXor);
        candidate.bankConflicts = scoreScratchLayout(
            op, pattern, candidate, sourceSlots, waveWidth, banks);
        if (candidate.bankConflicts < iterationBest.bankConflicts) {
          iterationBest = std::move(candidate);
          improved = true;
        }
      }
    }
    best = std::move(iterationBest);
  }
  return best;
}

static FailureOr<ScratchLayoutPlan>
selectScratchLayout(RedistributeOp op, const ScratchAccessPattern &pattern,
                    int64_t sourceSlots, int64_t vectorElements,
                    int64_t waveWidth) {
  ScratchLayoutPlan best;
  best.vectorElements = vectorElements;
  FailureOr<int64_t> banks = getSharedMemoryBankCount(op);
  if (failed(banks))
    return failure();
  best.bankConflicts =
      scoreScratchLayout(op, pattern, best, sourceSlots, waveWidth, *banks);

  int64_t items = op.getRelation().getItems();
  int64_t groups = sourceSlots / best.vectorElements;
  unsigned groupBits = groups > 1 ? llvm::Log2_64_Ceil(groups) : 0;
  // Low item bits stay inside every aligned power-of-two item tile.
  unsigned itemBits = llvm::countr_zero(static_cast<uint64_t>(items));
  best = selectPhaseScratchLayout(op, pattern, sourceSlots, waveWidth, *banks,
                                  groupBits, itemBits, std::move(best));
  // Upper-triangular item-bit XORs preserve footprint and invertibility.
  return selectItemXorScratchLayout(op, pattern, sourceSlots, waveWidth, *banks,
                                    itemBits, std::move(best));
}

static FailureOr<sym::ExprHandle> composeBinaryInt(sym::Store &store,
                                                   sym::ExprHandle lhs,
                                                   sym::ExprBinaryOp op,
                                                   int64_t rhs) {
  FailureOr<sym::ExprHandle> rhsExpr = sym::composeExprInt(store, rhs);
  if (failed(rhsExpr))
    return failure();
  return sym::composeExprBinary(store, lhs, op, *rhsExpr);
}

static FailureOr<sym::ExprHandle> composeBinaryInt(sym::Analysis &analysis,
                                                   sym::ExprHandle lhs,
                                                   sym::ExprBinaryOp op,
                                                   int64_t rhs) {
  FailureOr<sym::ExprHandle> rhsExpr = analysis.composeInteger(rhs);
  if (failed(rhsExpr))
    return failure();
  return analysis.compose(lhs, op, *rhsExpr);
}

static FailureOr<sym::ExprHandle>
composePhysicalSlot(sym::Store &store, sym::ExprHandle logicalSlot,
                    const SlotOrder &order) {
  if (order.logicalBitsByPhysicalBit.empty())
    return logicalSlot;

  std::optional<sym::ExprHandle> physicalSlot;
  for (auto [physicalBit, logicalBit] :
       llvm::enumerate(order.logicalBitsByPhysicalBit)) {
    FailureOr<sym::ExprHandle> bit =
        floorDiv(store, logicalSlot, int64_t{1} << logicalBit);
    if (failed(bit))
      return failure();
    bit = composeBinaryInt(store, *bit, sym::ExprBinaryOp::Mod, 2);
    if (failed(bit))
      return failure();
    if (physicalBit) {
      bit = composeBinaryInt(store, *bit, sym::ExprBinaryOp::Mul,
                             int64_t{1} << physicalBit);
      if (failed(bit))
        return failure();
    }
    if (!physicalSlot) {
      physicalSlot = *bit;
      continue;
    }
    FailureOr<sym::ExprHandle> sum = sym::composeExprBinary(
        store, *physicalSlot, sym::ExprBinaryOp::Add, *bit);
    if (failed(sum))
      return failure();
    physicalSlot = *sum;
  }
  return *physicalSlot;
}

static FailureOr<sym::ExprHandle>
composeItemXors(sym::Store &store, sym::ExprHandle item,
                const ScratchLayoutPlan &plan) {
  sym::ExprHandle physicalItem = item;
  for (auto [sourceBit, targetBit] : plan.itemXors) {
    FailureOr<sym::ExprHandle> bit =
        floorDiv(store, item, int64_t{1} << sourceBit);
    if (failed(bit))
      return failure();
    bit = composeBinaryInt(store, *bit, sym::ExprBinaryOp::Mod, 2);
    if (failed(bit))
      return failure();
    if (targetBit) {
      bit = composeBinaryInt(store, *bit, sym::ExprBinaryOp::Mul,
                             int64_t{1} << targetBit);
      if (failed(bit))
        return failure();
    }
    FailureOr<sym::ExprHandle> swizzled = sym::composeExprBinary(
        store, physicalItem, sym::ExprBinaryOp::Xor, *bit);
    if (failed(swizzled))
      return failure();
    physicalItem = *swizzled;
  }
  return physicalItem;
}

static FailureOr<sym::ExprHandle>
composePhysicalItem(sym::Store &store, sym::ExprHandle item,
                    sym::ExprHandle group, const ScratchLayoutPlan &plan) {
  FailureOr<sym::ExprHandle> physicalItem = composeItemXors(store, item, plan);
  if (failed(physicalItem))
    return failure();
  if (!plan.phaseBits)
    return *physicalItem;
  FailureOr<sym::ExprHandle> phase =
      floorDiv(store, group, int64_t{1} << plan.groupShift);
  if (failed(phase))
    return failure();
  phase = composeBinaryInt(store, *phase, sym::ExprBinaryOp::Mod,
                           int64_t{1} << plan.phaseBits);
  if (failed(phase))
    return failure();
  FailureOr<sym::ExprHandle> shifted = composeBinaryInt(
      store, *phase, sym::ExprBinaryOp::Mul, int64_t{1} << plan.itemShift);
  if (failed(shifted))
    return failure();
  return sym::composeExprBinary(store, *physicalItem, sym::ExprBinaryOp::Xor,
                                *shifted);
}

static FailureOr<sym::ExprHandle>
composeScratchVectorAddress(sym::Store &store, sym::ExprHandle item,
                            sym::ExprHandle slot, int64_t items,
                            const ScratchLayoutPlan &plan) {
  FailureOr<sym::ExprHandle> group = floorDiv(store, slot, plan.vectorElements);
  if (failed(group))
    return failure();
  FailureOr<sym::ExprHandle> physicalItem =
      composePhysicalItem(store, item, *group, plan);
  if (failed(physicalItem))
    return failure();

  FailureOr<sym::ExprHandle> groupOffset =
      composeBinaryInt(store, *group, sym::ExprBinaryOp::Mul, items);
  if (failed(groupOffset))
    return failure();
  FailureOr<sym::ExprHandle> vector = sym::composeExprBinary(
      store, *groupOffset, sym::ExprBinaryOp::Add, *physicalItem);
  if (failed(vector))
    return failure();
  FailureOr<sym::ExprHandle> address = composeBinaryInt(
      store, *vector, sym::ExprBinaryOp::Mul, plan.vectorElements);
  return address;
}

class RelationMaterializer {
  using MaterializationKey = std::pair<sym::ExprHandle, int64_t>;
  using PreparedEntry =
      std::pair<MaterializationKey, PreparedRelationMaterialization>;

public:
  RelationMaterializer(IRRewriter &rewriter, RedistributeOp op,
                       sym::Store &store, const RelationDomain &domain)
      : rewriter(rewriter), op(op), store(store), domain(domain) {}

  LogicalResult prepare(ArrayRef<RelationMaterializationPoint> points) {
    SmallVector<RelationMaterializationPoint> missing = collectMissing(points);
    if (missing.empty())
      return success();

    std::array<sym::PredHandle, 1> assumptions{domain.itemRange};
    FailureOr<std::unique_ptr<sym::Analysis>> analysis =
        sym::Analysis::create(store, assumptions);
    if (failed(analysis))
      return failure();
    FailureOr<sym::ExprHandle> blockValue = (*analysis)->composeInteger(0);
    if (failed(blockValue))
      return failure();
    SmallVector<PreparedEntry> materializations;
    materializations.reserve(missing.size());
    for (RelationMaterializationPoint point : missing) {
      FailureOr<PreparedEntry> materialization =
          preparePoint(**analysis, *blockValue, point);
      if (failed(materialization))
        return failure();
      materializations.push_back(*materialization);
    }
    for (auto &[key, materialization] : materializations)
      prepared.try_emplace(key, materialization);
    return success();
  }

  FailureOr<MaterializedExpr> materialize(sym::ExprHandle expr,
                                          int64_t destinationSlot) {
    MaterializationKey key{expr, destinationSlot};
    auto found = prepared.find(key);
    if (found == prepared.end())
      return failure();
    const PreparedRelationMaterialization &materialization = found->second;
    if (materialization.literal)
      return MaterializedExpr{Value(), materialization.literal};

    Value item = getItem();
    Type resultType =
        SimdType::get(op.getContext(), rewriter.getIndexType(), getWaveWidth());
    ArrayAttr names = rewriter.getStrArrayAttr({"item"});
    std::array<sym::PredHandle, 1> assumptions{domain.itemRange};
    ArrayAttr predicateAttrs =
        getIndexExprPredArrayAttr(op.getContext(), assumptions);
    Value value = IndexExprOp::create(
        rewriter, op.getLoc(), resultType,
        ExprAttr::get(op.getContext(), materialization.expression),
        predicateAttrs, names, ValueRange{item});
    return MaterializedExpr{value, std::nullopt};
  }

  Value constantIndex(int64_t value, bool simd) {
    Type type = rewriter.getIndexType();
    if (simd)
      type = SimdType::get(op.getContext(), type, getWaveWidth());
    return ConstantOp::create(rewriter, op.getLoc(), type,
                              rewriter.getIndexAttr(value));
  }

private:
  SmallVector<RelationMaterializationPoint>
  collectMissing(ArrayRef<RelationMaterializationPoint> points) const {
    SmallVector<RelationMaterializationPoint> missing;
    DenseSet<MaterializationKey> missingKeys;
    for (RelationMaterializationPoint point : points) {
      MaterializationKey key{point.expression, point.destinationSlot};
      if (!prepared.contains(key) && missingKeys.insert(key).second)
        missing.push_back(point);
    }
    return missing;
  }

  FailureOr<PreparedEntry>
  preparePoint(sym::Analysis &analysis, sym::ExprHandle blockValue,
               RelationMaterializationPoint point) const {
    FailureOr<sym::ExprHandle> slotValue =
        analysis.composeInteger(point.destinationSlot);
    if (failed(slotValue))
      return failure();
    std::array<sym::ExprSubstitution, 2> substitutions{
        sym::ExprSubstitution{domain.block, blockValue},
        sym::ExprSubstitution{domain.slot, *slotValue}};
    FailureOr<sym::ExprHandle> substituted =
        analysis.substitute(point.expression, substitutions);
    if (failed(substituted))
      return failure();
    FailureOr<sym::ExprHandle> simplified =
        simplifyForMaterialization(analysis, *substituted);
    if (failed(simplified))
      return failure();
    std::optional<int64_t> literal = sym::getIntegerLiteralValue(*simplified);
    return PreparedEntry{
        MaterializationKey{point.expression, point.destinationSlot},
        PreparedRelationMaterialization{*simplified, literal},
    };
  }

  int64_t getWaveWidth() {
    return cast<SimdType>(op.getSource().getType()).getWidth();
  }

  Value getItem() {
    if (item)
      return item;
    Type type =
        SimdType::get(op.getContext(), rewriter.getI32Type(), getWaveWidth());
    item = WorkitemIdOp::create(rewriter, op.getLoc(), type, 0);
    return item;
  }

  DenseMap<MaterializationKey, PreparedRelationMaterialization> prepared;
  Value item;
  IRRewriter &rewriter;
  RedistributeOp op;
  sym::Store &store;
  const RelationDomain &domain;
};

static SmallVector<Value> extractComponents(IRRewriter &rewriter,
                                            RedistributeOp op) {
  VectorType packet = getPacketType(op.getSource().getType());
  Type componentType = getPacketElementType(op.getSource().getType());
  SmallVector<Value> components;
  components.reserve(packet.getNumElements());
  for (int64_t index : llvm::seq<int64_t>(0, packet.getNumElements()))
    components.push_back(ExtractOp::create(rewriter, op.getLoc(), componentType,
                                           op.getSource(), index));
  return components;
}

static SmallVector<Value> extractPacketSlices(IRRewriter &rewriter,
                                              RedistributeOp op,
                                              int64_t sliceElements) {
  int64_t packetElements =
      getPacketType(op.getSource().getType()).getNumElements();
  Type sliceType = getPacketSliceType(op.getSource().getType(), sliceElements);
  SmallVector<Value> slices;
  slices.reserve(packetElements / sliceElements);
  for (int64_t index = 0; index < packetElements; index += sliceElements)
    slices.push_back(ExtractOp::create(rewriter, op.getLoc(), sliceType,
                                       op.getSource(), index));
  return slices;
}

static FailureOr<Value> selectComponent(IRRewriter &rewriter, RedistributeOp op,
                                        RelationMaterializer &materializer,
                                        ArrayRef<Value> candidates,
                                        MaterializedExpr selector) {
  if (selector.literal)
    return candidates[*selector.literal];
  if (!selector.value)
    return failure();

  Value result = candidates.front();
  Type selectorType = selector.value.getType();
  int64_t width = cast<SimdType>(selectorType).getWidth();
  Type maskType = MaskType::get(op.getContext(), width);
  for (int64_t index : llvm::seq<int64_t>(1, candidates.size())) {
    Value constant = materializer.constantIndex(index, /*simd=*/true);
    Value equal =
        CmpIOp::create(rewriter, op.getLoc(), maskType,
                       arith::CmpIPredicate::eq, selector.value, constant);
    result = SelectOp::create(rewriter, op.getLoc(), result.getType(), equal,
                              candidates[index], result);
  }
  return result;
}

static FailureOr<Value> selectKeyedCandidate(IRRewriter &rewriter,
                                             RedistributeOp op,
                                             RelationMaterializer &materializer,
                                             ArrayRef<Value> candidates,
                                             ArrayRef<int64_t> keys,
                                             MaterializedExpr selector) {
  assert(candidates.size() == keys.size() && "candidate keys must align");
  if (selector.literal) {
    auto found = llvm::find(keys, *selector.literal);
    if (found == keys.end())
      return failure();
    return candidates[std::distance(keys.begin(), found)];
  }
  if (!selector.value)
    return failure();

  Value result = candidates.front();
  int64_t width = cast<SimdType>(selector.value.getType()).getWidth();
  Type maskType = MaskType::get(op.getContext(), width);
  for (int64_t index : llvm::seq<int64_t>(1, candidates.size())) {
    Value constant = materializer.constantIndex(keys[index], /*simd=*/true);
    Value equal =
        CmpIOp::create(rewriter, op.getLoc(), maskType,
                       arith::CmpIPredicate::eq, selector.value, constant);
    result = SelectOp::create(rewriter, op.getLoc(), result.getType(), equal,
                              candidates[index], result);
  }
  return result;
}

static FailureOr<SmallVector<int64_t>>
collectSourceVectorGroups(sym::Analysis &analysis, RedistributeOp op,
                          const RelationDomain &domain, int64_t destinationSlot,
                          int64_t vectorElements) {
  DenseSet<int64_t> groupSet;
  for (int64_t block : llvm::seq<int64_t>(0, op.getRelation().getBlocks())) {
    for (int64_t item : llvm::seq<int64_t>(0, op.getRelation().getItems())) {
      FailureOr<int64_t> sourceSlot =
          evaluateCoordinate(analysis, op.getRelation().getSourceSlot(), domain,
                             block, item, destinationSlot);
      if (failed(sourceSlot)) {
        op.emitOpError("failed to evaluate verified redistribution relation");
        return failure();
      }
      groupSet.insert(*sourceSlot / vectorElements);
    }
  }
  SmallVector<int64_t> groups(groupSet.begin(), groupSet.end());
  llvm::sort(groups);
  return groups;
}

static LogicalResult lowerWorkitem(IRRewriter &rewriter, RedistributeOp op,
                                   sym::Store &store,
                                   const RelationDomain &domain) {
  RelationMaterializer materializer(rewriter, op, store, domain);
  SmallVector<Value> source = extractComponents(rewriter, op);
  int64_t resultSlots =
      getPacketType(op.getResult().getType()).getNumElements();
  SmallVector<RelationMaterializationPoint> points;
  points.reserve(resultSlots);
  for (int64_t slot : llvm::seq<int64_t>(0, resultSlots))
    points.push_back({op.getRelation().getSourceSlot(), slot});
  if (failed(materializer.prepare(points)))
    return op.emitOpError("failed to prepare source slot expressions");
  SmallVector<Value> result;
  result.reserve(resultSlots);
  for (int64_t slot : llvm::seq<int64_t>(0, resultSlots)) {
    FailureOr<MaterializedExpr> selector =
        materializer.materialize(op.getRelation().getSourceSlot(), slot);
    if (failed(selector))
      return op.emitOpError("failed to materialize source slot expression");
    FailureOr<Value> selected =
        selectComponent(rewriter, op, materializer, source, *selector);
    if (failed(selected))
      return op.emitOpError("failed to select source packet component");
    result.push_back(*selected);
  }
  Value packed =
      PackOp::create(rewriter, op.getLoc(), op.getResult().getType(), result);
  rewriter.replaceOp(op, packed);
  return success();
}

static FailureOr<Value>
materializeWaveScalarSlot(IRRewriter &rewriter, RedistributeOp op,
                          RelationMaterializer &materializer,
                          ArrayRef<Value> source, sym::ExprHandle sourceLane,
                          int64_t destinationSlot) {
  FailureOr<MaterializedExpr> lane =
      materializer.materialize(sourceLane, destinationSlot);
  FailureOr<MaterializedExpr> sourceSlot = materializer.materialize(
      op.getRelation().getSourceSlot(), destinationSlot);
  if (failed(lane) || failed(sourceSlot)) {
    op.emitOpError("failed to materialize same-wave relation");
    return failure();
  }
  Value laneValue =
      lane->literal ? materializer.constantIndex(*lane->literal, /*simd=*/false)
                    : lane->value;

  if (sourceSlot->literal)
    return ShuffleOp::create(rewriter, op.getLoc(),
                             source[*sourceSlot->literal].getType(),
                             source[*sourceSlot->literal], laneValue)
        .getResult();

  SmallVector<Value> shuffled;
  shuffled.reserve(source.size());
  for (Value component : source)
    shuffled.push_back(ShuffleOp::create(
        rewriter, op.getLoc(), component.getType(), component, laneValue));
  FailureOr<Value> selected =
      selectComponent(rewriter, op, materializer, shuffled, *sourceSlot);
  if (failed(selected)) {
    op.emitOpError("failed to select shuffled packet component");
    return failure();
  }
  return *selected;
}

static LogicalResult lowerWaveScalar(IRRewriter &rewriter, RedistributeOp op,
                                     sym::Store &store,
                                     const RelationDomain &domain,
                                     int64_t waveWidth) {
  RelationMaterializer materializer(rewriter, op, store, domain);
  SmallVector<Value> source = extractComponents(rewriter, op);
  FailureOr<sym::ExprHandle> width = sym::composeExprInt(store, waveWidth);
  if (failed(width))
    return op.emitOpError("failed to construct source lane expression");
  FailureOr<sym::ExprHandle> sourceLane = sym::composeExprBinary(
      store, op.getRelation().getSourceItem(), sym::ExprBinaryOp::Mod, *width);
  if (failed(sourceLane))
    return op.emitOpError("failed to construct source lane expression");

  int64_t resultSlots =
      getPacketType(op.getResult().getType()).getNumElements();
  SmallVector<RelationMaterializationPoint> points;
  points.reserve(2 * resultSlots);
  for (int64_t slot : llvm::seq<int64_t>(0, resultSlots)) {
    points.push_back({*sourceLane, slot});
    points.push_back({op.getRelation().getSourceSlot(), slot});
  }
  if (failed(materializer.prepare(points)))
    return op.emitOpError("failed to prepare same-wave relation");
  SmallVector<Value> result;
  result.reserve(resultSlots);
  for (int64_t slot : llvm::seq<int64_t>(0, resultSlots)) {
    FailureOr<Value> selected = materializeWaveScalarSlot(
        rewriter, op, materializer, source, *sourceLane, slot);
    if (failed(selected))
      return failure();
    result.push_back(*selected);
  }
  Value packed =
      PackOp::create(rewriter, op.getLoc(), op.getResult().getType(), result);
  rewriter.replaceOp(op, packed);
  return success();
}

static LogicalResult appendSliceResults(
    IRRewriter &rewriter, RedistributeOp op, RelationMaterializer &materializer,
    Value slice, int64_t destinationSlot, int64_t vectorElements,
    ArrayRef<std::optional<int64_t>> selectors, sym::ExprHandle sourceWithin,
    SmallVectorImpl<Value> &result) {
  if (vectorElements == 1) {
    result.push_back(slice);
    return success();
  }

  Type componentType = getPacketElementType(op.getSource().getType());
  SmallVector<Value> components;
  components.reserve(vectorElements);
  for (int64_t index : llvm::seq<int64_t>(0, vectorElements))
    components.push_back(
        ExtractOp::create(rewriter, op.getLoc(), componentType, slice, index));
  for (int64_t offset : llvm::seq<int64_t>(0, vectorElements)) {
    int64_t slot = destinationSlot + offset;
    if (selectors[slot]) {
      result.push_back(components[*selectors[slot]]);
      continue;
    }
    FailureOr<MaterializedExpr> selector =
        materializer.materialize(sourceWithin, slot);
    if (failed(selector))
      return op.emitOpError("failed to materialize vector selector");
    FailureOr<Value> selected =
        selectComponent(rewriter, op, materializer, components, *selector);
    if (failed(selected))
      return op.emitOpError("failed to select vector component");
    result.push_back(*selected);
  }
  return success();
}

static FailureOr<Value>
materializeWaveSlice(IRRewriter &rewriter, RedistributeOp op,
                     RelationMaterializer &materializer, ArrayRef<Value> source,
                     ArrayRef<int64_t> groups, sym::ExprHandle sourceLane,
                     sym::ExprHandle sourceGroup, int64_t destinationSlot) {
  FailureOr<MaterializedExpr> lane =
      materializer.materialize(sourceLane, destinationSlot);
  if (failed(lane))
    return failure();
  Value laneValue = lane->literal ? materializer.constantIndex(*lane->literal,
                                                               /*simd=*/false)
                                  : lane->value;

  SmallVector<Value> candidates;
  candidates.reserve(groups.size());
  for (int64_t group : groups)
    candidates.push_back(ShuffleOp::create(rewriter, op.getLoc(),
                                           source[group].getType(),
                                           source[group], laneValue));
  if (candidates.size() == 1)
    return candidates.front();

  FailureOr<MaterializedExpr> selector =
      materializer.materialize(sourceGroup, destinationSlot);
  if (failed(selector))
    return failure();
  return selectKeyedCandidate(rewriter, op, materializer, candidates, groups,
                              *selector);
}

struct WavePacketizationPlan {
  SmallVector<SmallVector<int64_t>> sourceGroups;
  SmallVector<std::optional<int64_t>> selectors;
  sym::ExprHandle sourceLane;
  sym::ExprHandle sourceGroup;
  sym::ExprHandle sourceWithin;
  int64_t vectorElements = 1;
};

static FailureOr<WavePacketizationPlan>
buildWavePacketizationPlan(sym::Analysis &analysis, RedistributeOp op,
                           const RelationDomain &domain, int64_t waveWidth) {
  FailureOr<int64_t> vectorElements =
      selectVectorElements(analysis, op, domain, /*maxVectorBits=*/0);
  if (failed(vectorElements))
    return failure();
  FailureOr<SmallVector<std::optional<int64_t>>> selectors =
      inferVectorSelectors(analysis, op, domain, *vectorElements);
  if (failed(selectors))
    return failure();

  FailureOr<sym::ExprHandle> width = analysis.composeInteger(waveWidth);
  if (failed(width)) {
    op.emitOpError("failed to construct source lane expression");
    return failure();
  }
  FailureOr<sym::ExprHandle> sourceLane = analysis.compose(
      op.getRelation().getSourceItem(), sym::ExprBinaryOp::Mod, *width);
  FailureOr<sym::ExprHandle> sourceGroup =
      floorDiv(analysis, op.getRelation().getSourceSlot(), *vectorElements);
  FailureOr<sym::ExprHandle> sourceWithin =
      composeBinaryInt(analysis, op.getRelation().getSourceSlot(),
                       sym::ExprBinaryOp::Mod, *vectorElements);
  if (failed(sourceLane) || failed(sourceGroup) || failed(sourceWithin)) {
    op.emitOpError("failed to construct packetized wave relation");
    return failure();
  }

  WavePacketizationPlan plan;
  plan.selectors = std::move(*selectors);
  plan.sourceLane = *sourceLane;
  plan.sourceGroup = *sourceGroup;
  plan.sourceWithin = *sourceWithin;
  plan.vectorElements = *vectorElements;
  int64_t resultSlots =
      getPacketType(op.getResult().getType()).getNumElements();
  plan.sourceGroups.reserve(resultSlots / plan.vectorElements);
  for (int64_t slot = 0; slot < resultSlots; slot += plan.vectorElements) {
    FailureOr<SmallVector<int64_t>> groups = collectSourceVectorGroups(
        analysis, op, domain, slot, plan.vectorElements);
    if (failed(groups))
      return failure();
    plan.sourceGroups.push_back(std::move(*groups));
  }
  return plan;
}

static LogicalResult
emitWavePacketizedResult(IRRewriter &rewriter, RedistributeOp op,
                         sym::Store &store, const RelationDomain &domain,
                         const WavePacketizationPlan &plan) {
  RelationMaterializer materializer(rewriter, op, store, domain);
  SmallVector<Value> source =
      extractPacketSlices(rewriter, op, plan.vectorElements);
  int64_t resultSlots =
      getPacketType(op.getResult().getType()).getNumElements();
  SmallVector<RelationMaterializationPoint> points;
  points.reserve(3 * resultSlots);
  for (int64_t slot : llvm::seq<int64_t>(0, resultSlots)) {
    points.push_back({plan.sourceLane, slot});
    points.push_back({plan.sourceGroup, slot});
    points.push_back({plan.sourceWithin, slot});
  }
  if (failed(materializer.prepare(points)))
    return op.emitOpError("failed to prepare packetized wave relation");

  SmallVector<Value> result;
  result.reserve(resultSlots);
  for (int64_t slot = 0; slot < resultSlots; slot += plan.vectorElements) {
    ArrayRef<int64_t> groups = plan.sourceGroups[slot / plan.vectorElements];
    FailureOr<Value> selected =
        materializeWaveSlice(rewriter, op, materializer, source, groups,
                             plan.sourceLane, plan.sourceGroup, slot);
    if (failed(selected))
      return op.emitOpError("failed to materialize packetized wave relation");
    if (failed(appendSliceResults(rewriter, op, materializer, *selected, slot,
                                  plan.vectorElements, plan.selectors,
                                  plan.sourceWithin, result)))
      return failure();
  }

  Value packed =
      PackOp::create(rewriter, op.getLoc(), op.getResult().getType(), result);
  rewriter.replaceOp(op, packed);
  return success();
}

static LogicalResult lowerWavePacketized(IRRewriter &rewriter,
                                         RedistributeOp op, sym::Store &store,
                                         const RelationDomain &domain,
                                         int64_t waveWidth) {
  FailureOr<std::unique_ptr<sym::Analysis>> analysis =
      sym::Analysis::create(store);
  if (failed(analysis))
    return failure();
  FailureOr<WavePacketizationPlan> plan =
      buildWavePacketizationPlan(**analysis, op, domain, waveWidth);
  if (failed(plan))
    return failure();
  analysis->reset();
  return emitWavePacketizedResult(rewriter, op, store, domain, *plan);
}

static LogicalResult lowerWave(IRRewriter &rewriter, RedistributeOp op,
                               sym::Store &store, const RelationDomain &domain,
                               int64_t waveWidth) {
  if (!fitsRelationPointBudget(op))
    return lowerWaveScalar(rewriter, op, store, domain, waveWidth);
  return lowerWavePacketized(rewriter, op, store, domain, waveWidth);
}

static FailureOr<Value> buildPointer(IRRewriter &rewriter, RedistributeOp op,
                                     RelationMaterializer &materializer,
                                     Value base, MaterializedExpr offset) {
  Value offsetValue = offset.literal
                          ? materializer.constantIndex(*offset.literal,
                                                       /*simd=*/false)
                          : offset.value;
  if (!offsetValue)
    return failure();
  Type resultType = base.getType();
  if (isa<SimdType>(offsetValue.getType()))
    resultType =
        SimdType::get(op.getContext(), base.getType(),
                      cast<SimdType>(op.getSource().getType()).getWidth());
  return PtrAddOp::create(rewriter, op.getLoc(), resultType, base, offsetValue)
      .getResult();
}

static FailureOr<int64_t> getScratchBytes(RedistributeOp op) {
  Type elementType = getPacketType(op.getSource().getType()).getElementType();
  if (!elementType.isIntOrFloat()) {
    op.emitOpError("cross-wave payload element must be integer or float");
    return failure();
  }
  int64_t bits = elementType.getIntOrFloatBitWidth();
  if (bits != 8 && bits != 16 && bits != 32) {
    op.emitOpError("cross-wave payload element must be 8, 16, or 32 bits wide");
    return failure();
  }
  int64_t sourceSlots =
      getPacketType(op.getSource().getType()).getNumElements();
  std::optional<int64_t> elements =
      llvm::checkedMul(op.getRelation().getItems(), sourceSlots);
  std::optional<int64_t> bytes =
      elements ? llvm::checkedMul(*elements, bits / 8) : std::nullopt;
  if (!bytes || *bytes <= 0) {
    op.emitOpError("cross-wave scratch byte size overflows i64");
    return failure();
  }
  return *bytes;
}

static FailureOr<int64_t> getNonNegativeLDSAttr(func::FuncOp func,
                                                StringRef name) {
  IntegerAttr attr = func->getAttrOfType<IntegerAttr>(name);
  if (!attr)
    return 0;
  int64_t bytes = attr.getInt();
  if (bytes < 0)
    return func.emitError() << name << " must be non-negative";
  return bytes;
}

static FailureOr<int64_t> getScratchLDSCapacity(func::FuncOp func) {
  FailureOr<WaveAMDLocalMemoryLimits> limits =
      getWaveAMDLocalMemoryLimits(func, "wave-lower-redistribute");
  if (failed(limits))
    return failure();

  uint64_t capacity = limits->localMemoryBytes;
  if (limits->addressableLocalMemoryBytes)
    capacity =
        std::min<uint64_t>(capacity, limits->addressableLocalMemoryBytes);
  if (!capacity)
    return func.emitError("wave-lower-redistribute target has no usable LDS");
  return capacity;
}

static FailureOr<int64_t> getNonAllocationLDSBytes(func::FuncOp func) {
  FailureOr<int64_t> dynamic =
      getNonNegativeLDSAttr(func, "wave.dynamic_lds_size");
  FailureOr<int64_t> spill =
      getNonNegativeLDSAttr(func, "waveamdmachine.lds_spill_bytes");
  if (failed(dynamic) || failed(spill))
    return failure();
  std::optional<int64_t> reserved = llvm::checkedAdd(*dynamic, *spill);
  if (!reserved)
    return func.emitError("non-allocation LDS byte count overflows i64");
  return *reserved;
}

static FailureOr<std::optional<int64_t>> getScratchLDSLimit(func::FuncOp func) {
  if (!waveamdmachine::findAMDGPUTargetModule(func))
    return std::optional<int64_t>();
  FailureOr<int64_t> capacity = getScratchLDSCapacity(func);
  FailureOr<int64_t> reserved = getNonAllocationLDSBytes(func);
  if (failed(capacity) || failed(reserved))
    return failure();
  if (*reserved >= *capacity)
    return std::optional<int64_t>(0);
  return std::optional<int64_t>(*capacity - *reserved);
}

static std::pair<int64_t, int64_t>
getSourceGroupRange(const ScratchAccessPattern &pattern, int64_t items,
                    int64_t resultGroup, int64_t vectorElements) {
  int64_t first = std::numeric_limits<int64_t>::max();
  int64_t last = 0;
  for (int64_t item : llvm::seq<int64_t>(0, items)) {
    int64_t sourceGroup =
        pattern.loads[resultGroup * items + item].slot / vectorElements;
    first = std::min(first, sourceGroup);
    last = std::max(last, sourceGroup);
  }
  return {first, last};
}

static std::optional<int64_t>
getConstantScratchAddressDelta(const ScratchAccessPattern &pattern,
                               const ScratchLayoutPlan &layout, int64_t items,
                               int64_t resultGroup, int64_t baseGroup) {
  std::optional<int64_t> delta;
  for (int64_t item : llvm::seq<int64_t>(0, items)) {
    const SourceCoordinate &source = pattern.loads[resultGroup * items + item];
    const SourceCoordinate &base = pattern.loads[baseGroup * items + item];
    int64_t address =
        physicalScratchVectorAddress(layout, items, source.item, source.slot);
    int64_t baseAddress =
        physicalScratchVectorAddress(layout, items, base.item, base.slot);
    int64_t current = address - baseAddress;
    if (!delta)
      delta = current;
    else if (*delta != current)
      return std::nullopt;
  }
  return delta;
}

static uint64_t getUnsignedMagnitude(int64_t value) {
  if (value >= 0)
    return static_cast<uint64_t>(value);
  return static_cast<uint64_t>(-(value + 1)) + 1;
}

static bool isSt64PairDelta(int64_t deltaElements, int64_t elementBytes,
                            int64_t transferBytes) {
  if (transferBytes != 4 && transferBytes != 8)
    return false;
  std::optional<int64_t> deltaBytes =
      llvm::checkedMul(deltaElements, elementBytes);
  if (!deltaBytes || !*deltaBytes)
    return false;
  uint64_t magnitude = getUnsignedMagnitude(*deltaBytes);
  uint64_t stride = 64 * static_cast<uint64_t>(transferBytes);
  return magnitude % stride == 0 && magnitude / stride <= 255;
}

static std::optional<std::pair<int64_t, int64_t>>
findSt64LoadPair(const ScratchAccessPattern &pattern, int64_t items,
                 int64_t elementBytes, int64_t transferBytes,
                 int64_t resultGroup, const ScratchStagePlan &stage) {
  std::optional<std::pair<int64_t, int64_t>> best;
  for (int64_t otherGroup :
       llvm::seq<int64_t>(resultGroup + 1, pattern.resultGroups)) {
    if (stage.loadBaseGroups[otherGroup] != -1)
      continue;
    std::optional<int64_t> delta = getConstantScratchAddressDelta(
        pattern, stage.layout, items, otherGroup, resultGroup);
    if (!delta || !isSt64PairDelta(*delta, elementBytes, transferBytes))
      continue;
    if (!best ||
        getUnsignedMagnitude(*delta) < getUnsignedMagnitude(best->second))
      best = std::make_pair(otherGroup, *delta);
  }
  return best;
}

static void applySt64LoadPair(int64_t resultGroup,
                              std::pair<int64_t, int64_t> pair,
                              ScratchStagePlan &stage,
                              MutableArrayRef<uint8_t> paired) {
  int64_t otherGroup = pair.first;
  int64_t delta = pair.second;
  int64_t baseGroup = delta > 0 ? resultGroup : otherGroup;
  int64_t offsetGroup = delta > 0 ? otherGroup : resultGroup;
  stage.loadBaseGroups[baseGroup] = baseGroup;
  stage.loadBaseGroups[offsetGroup] = baseGroup;
  uint64_t magnitude = getUnsignedMagnitude(delta);
  assert(magnitude <=
         static_cast<uint64_t>(std::numeric_limits<int64_t>::max()));
  stage.loadOffsets[offsetGroup] = static_cast<int64_t>(magnitude);
  stage.rawLoadBases[baseGroup] = 1;
  paired[resultGroup] = 1;
  paired[otherGroup] = 1;
}

static std::optional<std::pair<int64_t, int64_t>>
findReusableLoadBase(const ScratchAccessPattern &pattern, int64_t items,
                     int64_t resultGroup, ArrayRef<uint8_t> paired,
                     const ScratchStagePlan &stage) {
  for (int64_t baseGroup : llvm::seq<int64_t>(0, resultGroup)) {
    if (paired[baseGroup] || stage.loadBaseGroups[baseGroup] != baseGroup)
      continue;
    std::optional<int64_t> delta = getConstantScratchAddressDelta(
        pattern, stage.layout, items, resultGroup, baseGroup);
    if (!delta || *delta < 0)
      continue;
    return std::make_pair(baseGroup, *delta);
  }
  return std::nullopt;
}

static void planScratchLoadBases(const ScratchAccessPattern &pattern,
                                 int64_t items, int64_t elementBytes,
                                 int64_t transferBytes,
                                 ScratchStagePlan &stage) {
  stage.loadBaseGroups.resize(pattern.resultGroups, -1);
  stage.loadOffsets.resize(pattern.resultGroups, 0);
  stage.rawLoadBases.resize(pattern.resultGroups, 0);

  SmallVector<uint8_t> paired(pattern.resultGroups, 0);
  for (int64_t resultGroup : llvm::seq<int64_t>(0, pattern.resultGroups)) {
    if (stage.loadBaseGroups[resultGroup] != -1)
      continue;
    std::optional<std::pair<int64_t, int64_t>> pair = findSt64LoadPair(
        pattern, items, elementBytes, transferBytes, resultGroup, stage);
    if (!pair)
      continue;
    applySt64LoadPair(resultGroup, *pair, stage, paired);
  }

  for (int64_t resultGroup : llvm::seq<int64_t>(0, pattern.resultGroups)) {
    if (stage.loadBaseGroups[resultGroup] != -1)
      continue;
    std::optional<std::pair<int64_t, int64_t>> base =
        findReusableLoadBase(pattern, items, resultGroup, paired, stage);
    if (base) {
      stage.loadBaseGroups[resultGroup] = base->first;
      stage.loadOffsets[resultGroup] = base->second;
      continue;
    }
    stage.loadBaseGroups[resultGroup] = resultGroup;
  }
}

static FailureOr<ScratchStagePlan>
buildScratchStage(RedistributeOp op, const ScratchAccessPattern &pattern,
                  int64_t firstResultGroup, int64_t resultGroupCount,
                  int64_t firstSourceGroup, int64_t sourceGroupCount,
                  int64_t vectorElements, int64_t groupBytes,
                  int64_t waveWidth) {
  int64_t items = op.getRelation().getItems();
  ScratchAccessPattern localPattern;
  localPattern.resultGroups = resultGroupCount;
  localPattern.loads.reserve(resultGroupCount * items);
  for (int64_t resultGroup : llvm::seq<int64_t>(
           firstResultGroup, firstResultGroup + resultGroupCount)) {
    for (int64_t item : llvm::seq<int64_t>(0, items)) {
      SourceCoordinate source = pattern.loads[resultGroup * items + item];
      source.slot -= firstSourceGroup * vectorElements;
      localPattern.loads.push_back(source);
    }
  }

  FailureOr<ScratchLayoutPlan> layout =
      selectScratchLayout(op, localPattern, sourceGroupCount * vectorElements,
                          vectorElements, waveWidth);
  if (failed(layout))
    return failure();
  std::optional<int64_t> scratchBytes =
      llvm::checkedMul(sourceGroupCount, groupBytes);
  if (!scratchBytes)
    return op.emitOpError("cross-wave stage byte size overflows i64");

  ScratchStagePlan stage;
  stage.layout = *layout;
  stage.firstResultGroup = firstResultGroup;
  stage.resultGroupCount = resultGroupCount;
  stage.firstSourceGroup = firstSourceGroup;
  stage.sourceGroupCount = sourceGroupCount;
  stage.scratchBytes = *scratchBytes;
  int64_t elementBytes = getPacketType(op.getSource().getType())
                             .getElementType()
                             .getIntOrFloatBitWidth() /
                         8;
  planScratchLoadBases(localPattern, items, elementBytes,
                       elementBytes * vectorElements, stage);
  return stage;
}

static FailureOr<ScratchGeometry> getScratchGeometry(RedistributeOp op,
                                                     int64_t vectorElements) {
  int64_t sourceSlots =
      getPacketType(op.getSource().getType()).getNumElements();
  int64_t resultSlots =
      getPacketType(op.getResult().getType()).getNumElements();
  int64_t elementBytes = getPacketType(op.getSource().getType())
                             .getElementType()
                             .getIntOrFloatBitWidth() /
                         8;
  std::optional<int64_t> groupElements =
      llvm::checkedMul(op.getRelation().getItems(), vectorElements);
  std::optional<int64_t> groupBytes =
      groupElements ? llvm::checkedMul(*groupElements, elementBytes)
                    : std::nullopt;
  if (!groupBytes)
    return op.emitOpError("cross-wave scratch group byte size overflows i64");
  return ScratchGeometry{sourceSlots / vectorElements,
                         resultSlots / vectorElements, *groupBytes};
}

static FailureOr<ScratchPlan> buildUnscoredScratchPlan(
    RedistributeOp op, const ScratchVectorizationPlan &vectorization,
    int64_t fullScratchBytes, std::optional<int64_t> scratchBudget,
    const ScratchGeometry &geometry,
    SmallVector<std::optional<int64_t>> selectors) {
  if (scratchBudget && fullScratchBytes > *scratchBudget)
    return op.emitOpError(
        "capacity-aware scratch staging exceeds relation planning limit");
  ScratchStagePlan stage;
  stage.layout.vectorElements = vectorization.vectorElements;
  stage.resultGroupCount = geometry.resultGroups;
  stage.sourceGroupCount = geometry.sourceGroups;
  stage.scratchBytes = fullScratchBytes;
  for (int64_t group : llvm::seq<int64_t>(0, geometry.resultGroups)) {
    stage.loadBaseGroups.push_back(group);
    stage.loadOffsets.push_back(0);
    stage.rawLoadBases.push_back(0);
  }
  ScratchPlan plan;
  plan.stages.push_back(stage);
  plan.selectors = std::move(selectors);
  plan.sourceOrder = vectorization.sourceOrder;
  plan.resultOrder = vectorization.resultOrder;
  plan.vectorElements = vectorization.vectorElements;
  plan.scratchBytes = fullScratchBytes;
  return plan;
}

static FailureOr<int64_t>
getMaxScratchSourceGroups(RedistributeOp op, const ScratchGeometry &geometry,
                          std::optional<int64_t> scratchBudget) {
  if (!scratchBudget)
    return geometry.sourceGroups;
  int64_t groups = *scratchBudget / geometry.groupBytes;
  if (!groups)
    return op.emitOpError("remaining target LDS capacity ")
           << *scratchBudget << " bytes cannot hold one " << geometry.groupBytes
           << "-byte scratch vector group";
  return std::min(groups, geometry.sourceGroups);
}

static LogicalResult
appendScratchStage(RedistributeOp op, const ScratchAccessPattern &pattern,
                   int64_t firstResultGroup, int64_t resultGroupCount,
                   int64_t firstSourceGroup, int64_t sourceGroupCount,
                   int64_t vectorElements, const ScratchGeometry &geometry,
                   int64_t waveWidth, ScratchPlan &plan) {
  FailureOr<ScratchStagePlan> stage = buildScratchStage(
      op, pattern, firstResultGroup, resultGroupCount, firstSourceGroup,
      sourceGroupCount, vectorElements, geometry.groupBytes, waveWidth);
  if (failed(stage))
    return failure();
  plan.scratchBytes = std::max(plan.scratchBytes, stage->scratchBytes);
  plan.stages.push_back(*stage);
  return success();
}

static LogicalResult
buildScratchStages(RedistributeOp op, const ScratchAccessPattern &pattern,
                   const ScratchGeometry &geometry, int64_t vectorElements,
                   int64_t maxSourceGroups, int64_t scratchCapacity,
                   int64_t waveWidth, ScratchPlan &plan) {
  int64_t firstResultGroup = 0;
  int64_t firstSourceGroup = 0;
  int64_t lastSourceGroup = -1;
  for (int64_t resultGroup : llvm::seq<int64_t>(0, geometry.resultGroups)) {
    auto [first, last] = getSourceGroupRange(
        pattern, op.getRelation().getItems(), resultGroup, vectorElements);
    int64_t mergedFirst = resultGroup == firstResultGroup
                              ? first
                              : std::min(firstSourceGroup, first);
    int64_t mergedLast = resultGroup == firstResultGroup
                             ? last
                             : std::max(lastSourceGroup, last);
    if (mergedLast - mergedFirst + 1 <= maxSourceGroups) {
      firstSourceGroup = mergedFirst;
      lastSourceGroup = mergedLast;
      continue;
    }
    if (resultGroup == firstResultGroup)
      return op.emitOpError("destination vector group ")
             << resultGroup << " requires "
             << (last - first + 1) * geometry.groupBytes
             << " scratch bytes, exceeding " << scratchCapacity
             << "-byte remaining target LDS capacity";

    if (failed(appendScratchStage(
            op, pattern, firstResultGroup, resultGroup - firstResultGroup,
            firstSourceGroup, lastSourceGroup - firstSourceGroup + 1,
            vectorElements, geometry, waveWidth, plan)))
      return failure();
    firstResultGroup = resultGroup;
    firstSourceGroup = first;
    lastSourceGroup = last;
  }

  return appendScratchStage(
      op, pattern, firstResultGroup, geometry.resultGroups - firstResultGroup,
      firstSourceGroup, lastSourceGroup - firstSourceGroup + 1, vectorElements,
      geometry, waveWidth, plan);
}

static int64_t getMaxScratchVectorBits(RedistributeOp op,
                                       std::optional<int64_t> scratchBudget) {
  constexpr int64_t maxVectorBits = 128;
  if (!scratchBudget)
    return maxVectorBits;
  int64_t elementBits = getPacketType(op.getSource().getType())
                            .getElementType()
                            .getIntOrFloatBitWidth();
  int64_t elementBytes = elementBits / 8;
  std::optional<int64_t> groupElementBytes =
      llvm::checkedMul(op.getRelation().getItems(), elementBytes);
  if (!groupElementBytes || !*groupElementBytes)
    return elementBits;
  int64_t elements = std::min(*scratchBudget / *groupElementBytes,
                              maxVectorBits / elementBits);
  return std::max(elementBits, elements * elementBits);
}

static FailureOr<ScratchPlan>
buildScratchPlan(sym::Store &store, RedistributeOp op,
                 const RelationDomain &domain, int64_t waveWidth,
                 int64_t fullScratchBytes,
                 std::optional<int64_t> scratchBudget) {
  int64_t maxVectorBits = getMaxScratchVectorBits(op, scratchBudget);
  if (!fitsRelationPointBudget(op)) {
    ScratchVectorizationPlan scalar = getScalarScratchVectorization();
    FailureOr<ScratchGeometry> geometry = getScratchGeometry(op, 1);
    if (failed(geometry))
      return failure();
    SmallVector<std::optional<int64_t>> selectors(geometry->resultGroups, 0);
    return buildUnscoredScratchPlan(op, scalar, fullScratchBytes, scratchBudget,
                                    *geometry, std::move(selectors));
  }

  FailureOr<ScratchRelationMap> relation =
      buildScratchRelationMap(store, op, domain);
  if (failed(relation))
    return failure();
  FailureOr<ScratchVectorizationPlan> vectorization =
      selectScratchVectorization(*relation, op, maxVectorBits);
  if (failed(vectorization))
    return failure();
  SmallVector<std::optional<int64_t>> selectors =
      inferScratchVectorSelectors(*relation, *vectorization);
  FailureOr<ScratchGeometry> geometry =
      getScratchGeometry(op, vectorization->vectorElements);
  if (failed(geometry))
    return failure();
  if (exceedsScratchPlanningBudget(op, vectorization->vectorElements))
    return buildUnscoredScratchPlan(op, *vectorization, fullScratchBytes,
                                    scratchBudget, *geometry,
                                    std::move(selectors));

  ScratchAccessPattern pattern =
      buildScratchAccessPattern(*relation, *vectorization);
  FailureOr<int64_t> maxSourceGroups =
      getMaxScratchSourceGroups(op, *geometry, scratchBudget);
  if (failed(maxSourceGroups))
    return failure();
  *maxSourceGroups = std::min(
      *maxSourceGroups, getScratchRepSourceGroups(*relation, *vectorization));
  ScratchPlan plan;
  plan.selectors = std::move(selectors);
  plan.sourceOrder = vectorization->sourceOrder;
  plan.resultOrder = vectorization->resultOrder;
  plan.vectorElements = vectorization->vectorElements;
  int64_t capacity = scratchBudget.value_or(fullScratchBytes);
  if (failed(buildScratchStages(op, pattern, *geometry,
                                vectorization->vectorElements, *maxSourceGroups,
                                capacity, waveWidth, plan)))
    return failure();
  return plan;
}

static Type getScratchTransferType(RedistributeOp op,
                                   const ScratchLayoutPlan &plan) {
  return getPacketSliceType(op.getSource().getType(), plan.vectorElements);
}

static Value buildScratchStoreValue(IRRewriter &rewriter, RedistributeOp op,
                                    ArrayRef<Value> source,
                                    int64_t physicalSlot,
                                    const ScratchPlan &plan,
                                    const ScratchLayoutPlan &layout) {
  SmallVector<Value> values;
  values.reserve(layout.vectorElements);
  for (int64_t offset : llvm::seq<int64_t>(0, layout.vectorElements)) {
    int64_t logicalSlot =
        physicalToLogicalSlot(plan.sourceOrder, physicalSlot + offset);
    values.push_back(source[logicalSlot]);
  }
  if (layout.vectorElements == 1)
    return values.front();
  return PackOp::create(rewriter, op.getLoc(),
                        getScratchTransferType(op, layout), values);
}

static FailureOr<Value>
emitScratchStores(IRRewriter &rewriter, RedistributeOp op,
                  RelationMaterializer &materializer, Value allocation,
                  ArrayRef<Value> source, sym::ExprHandle address,
                  const ScratchStagePlan &stage, const ScratchPlan &plan,
                  Type tokenType, Value dependency) {
  SmallVector<Value> tokens;
  tokens.reserve(stage.sourceGroupCount);
  for (int64_t localGroup : llvm::seq<int64_t>(0, stage.sourceGroupCount)) {
    int64_t localSlot = localGroup * stage.layout.vectorElements;
    int64_t physicalSourceSlot =
        (stage.firstSourceGroup + localGroup) * stage.layout.vectorElements;
    FailureOr<MaterializedExpr> offset =
        materializer.materialize(address, localSlot);
    if (failed(offset)) {
      op.emitOpError("failed to materialize scratch store address");
      return failure();
    }
    FailureOr<Value> pointer =
        buildPointer(rewriter, op, materializer, allocation, *offset);
    if (failed(pointer)) {
      op.emitOpError("failed to build scratch store pointer");
      return failure();
    }
    Value value = buildScratchStoreValue(
        rewriter, op, source, physicalSourceSlot, plan, stage.layout);
    StoreOp store = StoreOp::create(rewriter, op.getLoc(), tokenType, value,
                                    *pointer, dependency, Attribute());
    tokens.push_back(store.getToken());
  }
  return BarrierOp::create(rewriter, op.getLoc(), tokenType, tokens).getToken();
}

struct ScratchValue {
  Value value;
  int64_t slot = 0;
};

struct ScratchLoads {
  SmallVector<ScratchValue> values;
  SmallVector<Value> tokens;
  Value publication;
};

struct ScratchExecution {
  SmallVector<Value> result;
  SmallVector<Value> completionTokens;
  Value analysisCompletion;
};

struct ScratchSequence {
  Value completion;
  Value analysisCompletion;
  Operation *cursor = nullptr;
  WaveLDSRange range;
};

struct ScratchCapacity {
  std::optional<int64_t> limit;
  std::optional<int64_t> stageBytes;
  std::optional<int64_t> overlapBytes;
  Value dependency;
  Value analysisDependency;
};

using ScratchSequenceMap = DenseMap<Block *, ScratchSequence>;

static SmallVector<WaveLDSRange, 4>
collectScratchRanges(Block *block, const ScratchSequenceMap &sequences,
                     bool includeCurrentBlock) {
  SmallVector<WaveLDSRange, 4> ranges;
  for (const auto &[sequenceBlock, sequence] : sequences)
    if (includeCurrentBlock || sequenceBlock != block)
      ranges.push_back(sequence.range);
  llvm::sort(ranges, [](WaveLDSRange lhs, WaveLDSRange rhs) {
    if (lhs.offset != rhs.offset)
      return lhs.offset < rhs.offset;
    return lhs.bytes < rhs.bytes;
  });
  return ranges;
}

static Value findPrecedingBarrier(RedistributeOp op) {
  for (Operation *cursor = op->getPrevNode(); cursor;
       cursor = cursor->getPrevNode())
    if (BarrierOp barrier = dyn_cast<BarrierOp>(cursor))
      return barrier.getToken();
  return {};
}

static Value advanceScratchSequence(IRRewriter &rewriter, RedistributeOp op,
                                    ScratchSequenceMap &sequences) {
  auto it = sequences.find(op->getBlock());
  if (it == sequences.end())
    return findPrecedingBarrier(op);

  Value dependency = it->second.completion;
  Operation *cursor = it->second.cursor->getNextNode();
  for (; cursor != op; cursor = cursor->getNextNode()) {
    assert(cursor && "redistributions must lower in block order");
    BarrierOp barrier = dyn_cast<BarrierOp>(cursor);
    if (!barrier)
      continue;
    SmallVector<Value> dependencies(barrier.getDependencies());
    if (!llvm::is_contained(dependencies, dependency)) {
      dependencies.push_back(dependency);
      rewriter.modifyOpInPlace(barrier, [&] {
        barrier.getDependenciesMutable().assign(dependencies);
      });
    }
    dependency = barrier.getToken();
  }
  return dependency;
}

static Value getScratchAnalysisDependency(RedistributeOp op,
                                          ScratchSequenceMap &sequences) {
  auto it = sequences.find(op->getBlock());
  if (it == sequences.end())
    return findPrecedingBarrier(op);

  Value dependency = it->second.analysisCompletion;
  for (Operation *cursor = it->second.cursor->getNextNode(); cursor != op;
       cursor = cursor->getNextNode()) {
    assert(cursor && "redistributions must lower in block order");
    if (BarrierOp barrier = dyn_cast<BarrierOp>(cursor))
      dependency = barrier.getToken();
  }
  return dependency;
}

static FailureOr<ScratchCapacity>
getScratchCapacity(IRRewriter &rewriter, RedistributeOp op, func::FuncOp func,
                   WaveLDSAllocationAnalysis &analysis,
                   ScratchSequenceMap &sequences) {
  ScratchCapacity capacity;
  capacity.dependency = advanceScratchSequence(rewriter, op, sequences);
  capacity.analysisDependency = getScratchAnalysisDependency(op, sequences);
  FailureOr<std::optional<int64_t>> limit = getScratchLDSLimit(func);
  if (failed(limit))
    return failure();
  capacity.limit = *limit;
  if (!capacity.limit)
    return capacity;
  SmallVector<WaveLDSRange, 4> stageBlocked =
      collectScratchRanges(op->getBlock(), sequences,
                           /*includeCurrentBlock=*/false);
  FailureOr<int64_t> stageBytes = analysis.getLargestFreeRange(
      op, *capacity.limit, capacity.analysisDependency, stageBlocked);
  if (failed(stageBytes))
    return failure();
  capacity.stageBytes = *stageBytes;
  capacity.overlapBytes = *stageBytes;
  auto previous = sequences.find(op->getBlock());
  if (previous == sequences.end())
    return capacity;
  stageBlocked.push_back(previous->second.range);
  FailureOr<int64_t> overlapBytes = analysis.getLargestFreeRange(
      op, *capacity.limit, capacity.analysisDependency, stageBlocked);
  if (failed(overlapBytes))
    return failure();
  capacity.overlapBytes = *overlapBytes;
  return capacity;
}

static FailureOr<Value> getScratchLoadBasePointer(
    IRRewriter &rewriter, RedistributeOp op, RelationMaterializer &materializer,
    Value allocation, sym::ExprHandle address, const ScratchStagePlan &stage,
    const ScratchPlan &plan, int64_t baseGroup,
    MutableArrayRef<Value> basePointers) {
  if (basePointers[baseGroup])
    return basePointers[baseGroup];
  int64_t basePhysicalSlot =
      (stage.firstResultGroup + baseGroup) * stage.layout.vectorElements;
  int64_t baseDestinationSlot =
      physicalToLogicalSlot(plan.resultOrder, basePhysicalSlot);
  FailureOr<MaterializedExpr> baseOffset =
      materializer.materialize(address, baseDestinationSlot);
  if (failed(baseOffset)) {
    op.emitOpError("failed to materialize scratch load address");
    return failure();
  }
  if (stage.rawLoadBases[baseGroup] && baseOffset->value) {
    Type rawType = rewriter.getI32Type();
    if (auto simd = dyn_cast<SimdType>(baseOffset->value.getType()))
      rawType = SimdType::get(op.getContext(), rawType, simd.getWidth());
    baseOffset->value =
        CastOp::create(rewriter, op.getLoc(), rawType, CastKind::IntConvert,
                       baseOffset->value, DictionaryAttr())
            .getResult();
  }
  FailureOr<Value> basePointer =
      buildPointer(rewriter, op, materializer, allocation, *baseOffset);
  if (failed(basePointer)) {
    op.emitOpError("failed to build scratch load base pointer");
    return failure();
  }
  basePointers[baseGroup] = *basePointer;
  return *basePointer;
}

static LogicalResult appendScratchLoadValues(
    IRRewriter &rewriter, RedistributeOp op, RelationMaterializer &materializer,
    Value loaded, sym::ExprHandle sourceWithin, const ScratchLayoutPlan &layout,
    const ScratchPlan &plan, Type componentType, int64_t physicalSlot,
    ScratchLoads &loads) {
  int64_t destinationSlot =
      physicalToLogicalSlot(plan.resultOrder, physicalSlot);
  if (layout.vectorElements == 1) {
    loads.values.push_back({loaded, destinationSlot});
    return success();
  }

  SmallVector<Value> candidates;
  candidates.reserve(layout.vectorElements);
  for (int64_t index : llvm::seq<int64_t>(0, layout.vectorElements))
    candidates.push_back(
        ExtractOp::create(rewriter, op.getLoc(), componentType, loaded, index));
  for (int64_t physicalOffset : llvm::seq<int64_t>(0, layout.vectorElements)) {
    destinationSlot =
        physicalToLogicalSlot(plan.resultOrder, physicalSlot + physicalOffset);
    if (plan.selectors[destinationSlot]) {
      loads.values.push_back(
          {candidates[*plan.selectors[destinationSlot]], destinationSlot});
      continue;
    }
    FailureOr<MaterializedExpr> selector =
        materializer.materialize(sourceWithin, destinationSlot);
    if (failed(selector)) {
      op.emitOpError("failed to materialize scratch vector selector");
      return failure();
    }
    FailureOr<Value> selected =
        selectComponent(rewriter, op, materializer, candidates, *selector);
    if (failed(selected)) {
      op.emitOpError("failed to select scratch vector component");
      return failure();
    }
    loads.values.push_back({*selected, destinationSlot});
  }
  return success();
}

static FailureOr<ScratchLoads>
emitScratchLoads(IRRewriter &rewriter, RedistributeOp op,
                 RelationMaterializer &materializer, Value allocation,
                 sym::ExprHandle address, const ScratchStagePlan &stage,
                 sym::ExprHandle sourceWithin, const ScratchLayoutPlan &layout,
                 const ScratchPlan &plan, Type componentType, Type tokenType,
                 Value published) {
  ScratchLoads loads;
  loads.values.reserve(stage.resultGroupCount * layout.vectorElements);
  loads.tokens.reserve(stage.resultGroupCount);
  Type transferType = getScratchTransferType(op, layout);
  int64_t firstPhysicalResultSlot =
      stage.firstResultGroup * layout.vectorElements;
  int64_t endPhysicalResultSlot =
      firstPhysicalResultSlot + stage.resultGroupCount * layout.vectorElements;
  assert(static_cast<int64_t>(stage.loadBaseGroups.size()) ==
             stage.resultGroupCount &&
         static_cast<int64_t>(stage.loadOffsets.size()) ==
             stage.resultGroupCount &&
         static_cast<int64_t>(stage.rawLoadBases.size()) ==
             stage.resultGroupCount &&
         "scratch load plan must cover every result group");
  SmallVector<Value> basePointers(stage.resultGroupCount);
  for (int64_t physicalSlot = firstPhysicalResultSlot;
       physicalSlot < endPhysicalResultSlot;
       physicalSlot += layout.vectorElements) {
    int64_t localResultGroup =
        physicalSlot / layout.vectorElements - stage.firstResultGroup;
    int64_t baseGroup = stage.loadBaseGroups[localResultGroup];
    FailureOr<Value> basePointer = getScratchLoadBasePointer(
        rewriter, op, materializer, allocation, address, stage, plan, baseGroup,
        basePointers);
    if (failed(basePointer))
      return failure();
    Value pointer = *basePointer;
    int64_t delta = stage.loadOffsets[localResultGroup];
    if (delta)
      pointer =
          PtrAddOp::create(rewriter, op.getLoc(), pointer.getType(), pointer,
                           materializer.constantIndex(delta, /*simd=*/false));
    LoadOp load = LoadOp::create(rewriter, op.getLoc(), transferType, tokenType,
                                 pointer, published, Attribute());
    loads.tokens.push_back(load.getToken());
    if (failed(appendScratchLoadValues(
            rewriter, op, materializer, load.getValue(), sourceWithin, layout,
            plan, componentType, physicalSlot, loads)))
      return failure();
  }
  return loads;
}

static Value retireScratchSequence(IRRewriter &rewriter, RedistributeOp op,
                                   Type tokenType, Value dependency) {
  if (!dependency || dependency.getDefiningOp<BarrierOp>())
    return dependency;
  return BarrierOp::create(rewriter, op.getLoc(), tokenType, dependency)
      .getToken();
}

static bool mustRetireScratch(RedistributeOp op,
                              const ScratchSequenceMap &sequences,
                              std::optional<int64_t> overlapBudget,
                              int64_t scratchBytes) {
  if (!overlapBudget)
    return false;
  auto previous = sequences.find(op->getBlock());
  return previous != sequences.end() && scratchBytes > *overlapBudget;
}

struct ScratchAllocation {
  WaveLDSRange range;
  Value allocation;
  Value dependency;
};

static FailureOr<ScratchAllocation> createScratchAllocation(
    IRRewriter &rewriter, RedistributeOp op, Type elementType, Type tokenType,
    int64_t transferBytes, const ScratchPlan &plan,
    const ScratchCapacity &capacity, WaveLDSAllocationAnalysis &analysis,
    ScratchSequenceMap &sequences) {
  Value dependency = capacity.dependency;
  bool retire = mustRetireScratch(op, sequences, capacity.overlapBytes,
                                  plan.scratchBytes);
  if (retire)
    dependency = retireScratchSequence(rewriter, op, tokenType, dependency);
  SmallVector<WaveLDSRange, 4> blocked = collectScratchRanges(
      op->getBlock(), sequences, /*includeCurrentBlock=*/!retire);
  WaveLDSRange range{0, plan.scratchBytes};
  IntegerAttr fixedOffset;
  if (capacity.limit) {
    FailureOr<int64_t> offset =
        analysis.findFreeOffset(op, *capacity.limit, range.bytes, transferBytes,
                                capacity.analysisDependency, blocked);
    if (failed(offset))
      return failure();
    range.offset = *offset;
    fixedOffset = rewriter.getI64IntegerAttr(*offset);
  }
  PtrType pointerType =
      PtrType::get(op.getContext(), elementType,
                   SharedAddressSpaceAttr::get(op.getContext()));
  AllocOp allocation =
      AllocOp::create(rewriter, op.getLoc(), pointerType,
                      rewriter.getI64IntegerAttr(plan.scratchBytes),
                      rewriter.getI64IntegerAttr(transferBytes), fixedOffset);
  return ScratchAllocation{range, allocation.getResult(), dependency};
}

static FailureOr<ScratchStageExpressions> composeScratchStageExpressions(
    sym::Store &store, RedistributeOp op, const RelationDomain &domain,
    const ScratchStagePlan &stage, const ScratchPlan &plan) {
  FailureOr<sym::ExprHandle> storeAddress =
      composeScratchVectorAddress(store, domain.item, domain.slot,
                                  op.getRelation().getItems(), stage.layout);
  if (failed(storeAddress))
    return op.emitOpError("failed to construct scratch store address");

  FailureOr<sym::ExprHandle> physicalSourceSlot = composePhysicalSlot(
      store, op.getRelation().getSourceSlot(), plan.sourceOrder);
  if (failed(physicalSourceSlot))
    return op.emitOpError("failed to construct physical source slot");
  FailureOr<sym::ExprHandle> localSourceSlot =
      composeBinaryInt(store, *physicalSourceSlot, sym::ExprBinaryOp::Add,
                       -stage.firstSourceGroup * plan.vectorElements);
  if (failed(localSourceSlot))
    return op.emitOpError("failed to construct staged source slot");
  FailureOr<sym::ExprHandle> loadAddress = composeScratchVectorAddress(
      store, op.getRelation().getSourceItem(), *localSourceSlot,
      op.getRelation().getItems(), stage.layout);
  if (failed(loadAddress))
    return op.emitOpError("failed to construct scratch load address");
  return ScratchStageExpressions{*storeAddress, *loadAddress};
}

static void collectScratchMaterializationPoints(
    const ScratchStageExpressions &expressions, sym::ExprHandle sourceWithin,
    const ScratchStagePlan &stage, const ScratchPlan &plan,
    SmallVectorImpl<RelationMaterializationPoint> &points) {
  int64_t vectorElements = stage.layout.vectorElements;
  for (int64_t localGroup : llvm::seq<int64_t>(0, stage.sourceGroupCount))
    points.push_back({expressions.storeAddress, localGroup * vectorElements});

  for (int64_t baseGroup : stage.loadBaseGroups) {
    int64_t basePhysicalSlot =
        (stage.firstResultGroup + baseGroup) * vectorElements;
    int64_t baseDestinationSlot =
        physicalToLogicalSlot(plan.resultOrder, basePhysicalSlot);
    points.push_back({expressions.loadAddress, baseDestinationSlot});
  }
  if (vectorElements == 1)
    return;

  int64_t firstPhysicalSlot = stage.firstResultGroup * vectorElements;
  int64_t endPhysicalSlot =
      firstPhysicalSlot + stage.resultGroupCount * vectorElements;
  for (int64_t physicalSlot :
       llvm::seq<int64_t>(firstPhysicalSlot, endPhysicalSlot)) {
    int64_t destinationSlot =
        physicalToLogicalSlot(plan.resultOrder, physicalSlot);
    if (!plan.selectors[destinationSlot])
      points.push_back({sourceWithin, destinationSlot});
  }
}

static FailureOr<ScratchLoads>
emitScratchStage(IRRewriter &rewriter, RedistributeOp op,
                 RelationMaterializer &materializer, Value allocation,
                 ArrayRef<Value> source, sym::ExprHandle sourceWithin,
                 const ScratchStageExpressions &expressions,
                 const ScratchStagePlan &stage, const ScratchPlan &plan,
                 Type componentType, Type tokenType, Value dependency) {
  FailureOr<Value> published = emitScratchStores(
      rewriter, op, materializer, allocation, source, expressions.storeAddress,
      stage, plan, tokenType, dependency);
  if (failed(published))
    return failure();

  FailureOr<ScratchLoads> loaded = emitScratchLoads(
      rewriter, op, materializer, allocation, expressions.loadAddress, stage,
      sourceWithin, stage.layout, plan, componentType, tokenType, *published);
  if (failed(loaded))
    return failure();
  loaded->publication = *published;
  return loaded;
}

static FailureOr<sym::ExprHandle>
composeScratchSourceWithin(sym::Store &store, RedistributeOp op,
                           const ScratchPlan &plan) {
  FailureOr<sym::ExprHandle> physicalSourceSlot = composePhysicalSlot(
      store, op.getRelation().getSourceSlot(), plan.sourceOrder);
  if (failed(physicalSourceSlot)) {
    op.emitOpError("failed to construct physical source slot");
    return failure();
  }
  FailureOr<sym::ExprHandle> sourceWithin = composeBinaryInt(
      store, *physicalSourceSlot, sym::ExprBinaryOp::Mod, plan.vectorElements);
  if (failed(sourceWithin)) {
    op.emitOpError("failed to construct scratch vector selector");
    return failure();
  }
  return *sourceWithin;
}

struct ScratchLoweringPlan {
  SmallVector<ScratchStageExpressions> stageExpressions;
  SmallVector<RelationMaterializationPoint> materializationPoints;
  ScratchPlan scratch;
  ScratchCapacity capacity;
  sym::ExprHandle sourceWithin;
};

static FailureOr<ScratchLoweringPlan>
buildScratchLoweringPlan(IRRewriter &rewriter, RedistributeOp op,
                         sym::Store &store, const RelationDomain &domain,
                         func::FuncOp func, WaveLDSAllocationAnalysis &analysis,
                         ScratchSequenceMap &sequences) {
  FailureOr<int64_t> scratchBytes = getScratchBytes(op);
  if (failed(scratchBytes))
    return failure();
  FailureOr<ScratchCapacity> capacity =
      getScratchCapacity(rewriter, op, func, analysis, sequences);
  if (failed(capacity))
    return failure();
  int64_t waveWidth = cast<SimdType>(op.getSource().getType()).getWidth();
  FailureOr<ScratchPlan> scratch = buildScratchPlan(
      store, op, domain, waveWidth, *scratchBytes, capacity->stageBytes);
  if (failed(scratch))
    return failure();
  FailureOr<sym::ExprHandle> sourceWithin =
      composeScratchSourceWithin(store, op, *scratch);
  if (failed(sourceWithin))
    return failure();

  ScratchLoweringPlan plan;
  plan.stageExpressions.reserve(scratch->stages.size());
  for (const ScratchStagePlan &stage : scratch->stages) {
    FailureOr<ScratchStageExpressions> expressions =
        composeScratchStageExpressions(store, op, domain, stage, *scratch);
    if (failed(expressions))
      return failure();
    plan.stageExpressions.push_back(*expressions);
    collectScratchMaterializationPoints(*expressions, *sourceWithin, stage,
                                        *scratch, plan.materializationPoints);
  }
  plan.scratch = std::move(*scratch);
  plan.capacity = std::move(*capacity);
  plan.sourceWithin = *sourceWithin;
  return plan;
}

static FailureOr<ScratchExecution> executeScratchPlan(
    IRRewriter &rewriter, RedistributeOp op, RelationMaterializer &materializer,
    ScratchAllocation &allocation, sym::ExprHandle sourceWithin,
    ArrayRef<ScratchStageExpressions> stageExpressions, const ScratchPlan &plan,
    Type componentType, Type tokenType) {
  SmallVector<Value> source = extractComponents(rewriter, op);
  int64_t resultSlots =
      getPacketType(op.getResult().getType()).getNumElements();
  ScratchExecution execution;
  execution.result.resize(resultSlots);
  for (auto [stageIndex, stage] : llvm::enumerate(plan.stages)) {
    FailureOr<ScratchLoads> loaded = emitScratchStage(
        rewriter, op, materializer, allocation.allocation, source, sourceWithin,
        stageExpressions[stageIndex], stage, plan, componentType, tokenType,
        allocation.dependency);
    if (failed(loaded))
      return failure();
    execution.analysisCompletion = loaded->publication;
    for (const ScratchValue &value : loaded->values)
      execution.result[value.slot] = value.value;
    execution.completionTokens = std::move(loaded->tokens);
    if (stageIndex + 1 != plan.stages.size())
      allocation.dependency =
          BarrierOp::create(rewriter, op.getLoc(), tokenType,
                            execution.completionTokens)
              .getToken();
  }
  return execution;
}

static LogicalResult
lowerWorkgroup(IRRewriter &rewriter, RedistributeOp op, sym::Store &store,
               const RelationDomain &domain, func::FuncOp func,
               WaveLDSAllocationAnalysis &analysis,
               ScratchSequenceMap &sequences, TimingScope &timing) {
  TimingScope planTiming = timing.nest("lower_redistribute_workgroup_plan");
  FailureOr<ScratchLoweringPlan> plan = buildScratchLoweringPlan(
      rewriter, op, store, domain, func, analysis, sequences);
  if (failed(plan))
    return failure();
  planTiming.stop();

  TimingScope relationTiming =
      timing.nest("lower_redistribute_workgroup_prepare_relation");
  Type tokenType = MemTokenType::get(op.getContext());
  RelationMaterializer materializer(rewriter, op, store, domain);
  if (failed(materializer.prepare(plan->materializationPoints)))
    return op.emitOpError("failed to prepare scratch relation");
  relationTiming.stop();

  TimingScope allocationTiming =
      timing.nest("lower_redistribute_workgroup_allocate");
  VectorType sourcePacket = getPacketType(op.getSource().getType());
  Type elementType = sourcePacket.getElementType();
  int64_t elementBytes = elementType.getIntOrFloatBitWidth() / 8;
  int64_t transferBytes = elementBytes * plan->scratch.vectorElements;
  FailureOr<ScratchAllocation> scratch = createScratchAllocation(
      rewriter, op, elementType, tokenType, transferBytes, plan->scratch,
      plan->capacity, analysis, sequences);
  if (failed(scratch))
    return failure();
  allocationTiming.stop();

  TimingScope emitTiming = timing.nest("lower_redistribute_workgroup_emit");
  Type componentType = getPacketElementType(op.getSource().getType());
  FailureOr<ScratchExecution> execution = executeScratchPlan(
      rewriter, op, materializer, *scratch, plan->sourceWithin,
      plan->stageExpressions, plan->scratch, componentType, tokenType);
  if (failed(execution))
    return failure();

  Value packed = PackOp::create(rewriter, op.getLoc(), op.getResult().getType(),
                                execution->result);
  Value completed = JoinOp::create(rewriter, op.getLoc(), tokenType,
                                   execution->completionTokens);
  AllocReleaseOp released = AllocReleaseOp::create(
      rewriter, op.getLoc(), tokenType, scratch->allocation, completed,
      rewriter.getUnitAttr());
  sequences[op->getBlock()] = {released.getToken(),
                               execution->analysisCompletion, released,
                               scratch->range};
  rewriter.replaceOp(op, packed);
  return success();
}

static bool canCompose(RedistributeOp previous, RedistributeOp op) {
  return previous->getBlock() == op->getBlock() &&
         previous.getResult().hasOneUse() &&
         previous.getRelation().getBlocks() == op.getRelation().getBlocks() &&
         previous.getRelation().getItems() == op.getRelation().getItems();
}

struct RedistributionComposition {
  SmallVector<RedistributeOp> composed;
  std::array<sym::ExprHandle, 3> sources;
  Value source;
};

static FailureOr<std::array<sym::ExprHandle, 3>>
buildCompositionSymbols(sym::Analysis &analysis, RedistributeOp op) {
  FailureOr<sym::ExprHandle> block = analysis.composeSymbol("block");
  FailureOr<sym::ExprHandle> item = analysis.composeSymbol("item");
  FailureOr<sym::ExprHandle> slot = analysis.composeSymbol("slot");
  if (failed(block) || failed(item) || failed(slot)) {
    op.emitOpError("failed to construct composition symbols");
    return failure();
  }
  return std::array<sym::ExprHandle, 3>{*block, *item, *slot};
}

static FailureOr<std::array<sym::ExprHandle, 3>>
composeRelationStep(sym::Analysis &analysis, RedistributeOp op,
                    RedistributeOp previous,
                    const std::array<sym::ExprHandle, 3> &symbols,
                    const std::array<sym::ExprHandle, 3> &sources) {
  std::array<sym::ExprSubstitution, 3> substitutions{
      sym::ExprSubstitution{symbols[0], sources[0]},
      sym::ExprSubstitution{symbols[1], sources[1]},
      sym::ExprSubstitution{symbols[2], sources[2]}};
  std::array<sym::ExprHandle, 3> next{previous.getRelation().getSourceBlock(),
                                      previous.getRelation().getSourceItem(),
                                      previous.getRelation().getSourceSlot()};
  for (sym::ExprHandle &expression : next) {
    FailureOr<sym::ExprHandle> substituted =
        analysis.substitute(expression, substitutions);
    if (failed(substituted)) {
      op.emitOpError("failed to compose redistribution relations");
      return failure();
    }
    expression = *substituted;
  }
  std::array<sym::ExprHandle, 3> simplified = next;
  if (failed(analysis.simplify(simplified))) {
    op.emitOpError("failed to simplify composed redistribution");
    return failure();
  }
  for (auto [expression, candidate] : llvm::zip(next, simplified))
    if (shouldUseSimplifiedIndexExpr(candidate, expression))
      expression = candidate;
  return next;
}

static FailureOr<RedistributionComposition>
buildRedistributionComposition(sym::Analysis &analysis, RedistributeOp op,
                               RedistributeOp previous,
                               const std::array<sym::ExprHandle, 3> &symbols) {
  RedistributionComposition composition;
  composition.sources = {op.getRelation().getSourceBlock(),
                         op.getRelation().getSourceItem(),
                         op.getRelation().getSourceSlot()};
  composition.source = op.getSource();
  do {
    FailureOr<std::array<sym::ExprHandle, 3>> sources = composeRelationStep(
        analysis, op, previous, symbols, composition.sources);
    if (failed(sources))
      return failure();
    composition.sources = *sources;
    composition.source = previous.getSource();
    composition.composed.push_back(previous);
    previous = composition.source.getDefiningOp<RedistributeOp>();
  } while (previous && canCompose(previous, op));
  return composition;
}

static FailureOr<bool> composeAdjacent(IRRewriter &rewriter, RedistributeOp op,
                                       sym::Store &store,
                                       DenseSet<Operation *> &erased) {
  RedistributeOp previous = op.getSource().getDefiningOp<RedistributeOp>();
  if (!previous || !canCompose(previous, op))
    return false;

  FailureOr<std::unique_ptr<sym::Analysis>> analysis =
      sym::Analysis::create(store);
  if (failed(analysis))
    return op.emitOpError("failed to construct composition analysis");
  FailureOr<std::array<sym::ExprHandle, 3>> symbols =
      buildCompositionSymbols(**analysis, op);
  if (failed(symbols))
    return failure();
  FailureOr<RedistributionComposition> composition =
      buildRedistributionComposition(**analysis, op, previous, *symbols);
  if (failed(composition))
    return failure();

  analysis->reset();
  RedistributionAttr relation = RedistributionAttr::get(
      op.getContext(), op.getRelation().getBlocks(),
      op.getRelation().getItems(), composition->sources[0],
      composition->sources[1], composition->sources[2]);
  op->setOperand(0, composition->source);
  op.setRelationAttr(relation);
  if (failed(op.verify()))
    return failure();
  for (RedistributeOp composedOp : composition->composed) {
    erased.insert(composedOp.getOperation());
    rewriter.eraseOp(composedOp);
  }
  return true;
}

static LogicalResult validateAndClassifyRedistributions(
    ArrayRef<RedistributeOp> ops, func::FuncOp func, WaveDialect &dialect,
    DenseMap<Operation *, RedistributionClassification> &classifications,
    CoordinateCacheMap &coordinateCaches) {
  for (RedistributeOp op : ops) {
    auto coordinateCache = std::make_unique<CoordinateCache>();
    FailureOr<RelationDomain> domain =
        buildDomain(dialect.getSymbolStore(), op, *coordinateCache);
    if (failed(domain))
      return op.emitOpError("failed to construct redistribution domain");
    int64_t width = cast<SimdType>(op.getSource().getType()).getWidth();
    FailureOr<RedistributionClassification> classification =
        validateAndClassifyMovement(dialect.getSymbolStore(), op, *domain,
                                    width);
    if (failed(classification))
      return failure();
    classifications.try_emplace(op.getOperation(), *classification);
    coordinateCaches.try_emplace(op.getOperation(), std::move(coordinateCache));
    if (failed(validateWorkgroup(op, func, width)))
      return failure();
  }
  return success();
}

static LogicalResult composeRedistributions(
    IRRewriter &rewriter, ArrayRef<RedistributeOp> ops, sym::Store &store,
    DenseSet<Operation *> &erased,
    DenseMap<Operation *, RedistributionClassification> &classifications,
    CoordinateCacheMap &coordinateCaches) {
  for (RedistributeOp op : llvm::reverse(ops)) {
    if (erased.contains(op.getOperation()))
      continue;
    FailureOr<bool> changed = composeAdjacent(rewriter, op, store, erased);
    if (failed(changed))
      return failure();
    if (*changed) {
      classifications.erase(op.getOperation());
      coordinateCaches.erase(op.getOperation());
    }
  }
  for (Operation *op : erased) {
    classifications.erase(op);
    coordinateCaches.erase(op);
  }
  return success();
}

static LogicalResult lowerWorkgroupRedistribution(
    IRRewriter &rewriter, RedistributeOp op, WaveDialect &dialect,
    const RelationDomain &domain, func::FuncOp func,
    std::unique_ptr<WaveLDSAllocationAnalysis> &analysis,
    ScratchSequenceMap &sequences, TimingScope &timing) {
  TimingScope analysisTiming =
      timing.nest("lower_redistribute_workgroup_analyze_lds");
  if (!func.getBody().hasOneBlock())
    return op.emitOpError(
        "cross-wave redistribution requires a single-block kernel function");
  if (!analysis) {
    FailureOr<std::unique_ptr<WaveLDSAllocationAnalysis>> created =
        WaveLDSAllocationAnalysis::create(func);
    if (failed(created))
      return failure();
    analysis = std::move(*created);
  }
  analysisTiming.stop();
  return lowerWorkgroup(rewriter, op, dialect.getSymbolStore(), domain, func,
                        *analysis, sequences, timing);
}

static LogicalResult lowerRedistribution(
    IRRewriter &rewriter, RedistributeOp op, WaveDialect &dialect,
    func::FuncOp func, std::unique_ptr<WaveLDSAllocationAnalysis> &analysis,
    ScratchSequenceMap &sequences,
    std::optional<RedistributionClassification> validatedClassification,
    CoordinateCache &coordinateCache, RedistributeStageTiming &timing) {
  TimingScope prepareTiming = timing.nest("lower_redistribute_prepare");
  rewriter.setInsertionPoint(op);
  FailureOr<RelationDomain> domain =
      buildDomain(dialect.getSymbolStore(), op, coordinateCache);
  if (failed(domain))
    return op.emitOpError("failed to construct redistribution domain");
  int64_t width = cast<SimdType>(op.getSource().getType()).getWidth();
  RedistributionClassification classification;
  if (validatedClassification) {
    classification = *validatedClassification;
  } else {
    FailureOr<RedistributionClassification> classified =
        validateAndClassifyMovement(dialect.getSymbolStore(), op, *domain,
                                    width);
    if (failed(classified))
      return failure();
    classification = *classified;
  }
  if (failed(validateBlockLowering(op, classification.blockLowering)))
    return failure();
  prepareTiming.stop();

  switch (classification.movement) {
  case Movement::Alias: {
    TimingScope lowerTiming = timing.nest("lower_redistribute_alias");
    rewriter.replaceOp(op, op.getSource());
    return success();
  }
  case Movement::Workitem: {
    TimingScope lowerTiming = timing.nest("lower_redistribute_workitem");
    return lowerWorkitem(rewriter, op, dialect.getSymbolStore(), *domain);
  }
  case Movement::Wave: {
    TimingScope lowerTiming = timing.nest("lower_redistribute_wave");
    return lowerWave(rewriter, op, dialect.getSymbolStore(), *domain, width);
  }
  case Movement::Workgroup: {
    TimingScope lowerTiming = timing.nest("lower_redistribute_workgroup");
    return lowerWorkgroupRedistribution(rewriter, op, dialect, *domain, func,
                                        analysis, sequences, lowerTiming);
  }
  case Movement::Cluster:
    llvm_unreachable("cluster movement must fail contextual validation");
  }
  llvm_unreachable("unknown redistribution movement");
}

static LogicalResult lowerFunc(func::FuncOp func, WaveDialect &dialect,
                               IRRewriter &rewriter,
                               RedistributeStageTiming &timing) {
  TimingScope collectTiming = timing.nest("lower_redistribute_collect_ops");
  SmallVector<RedistributeOp> ops;
  func.walk([&](RedistributeOp op) { ops.push_back(op); });
  collectTiming.stop();
  if (ops.empty())
    return success();

  TimingScope validationTiming =
      timing.nest("lower_redistribute_validate_classify");
  DenseMap<Operation *, RedistributionClassification> classifications;
  CoordinateCacheMap coordinateCaches;
  if (failed(validateAndClassifyRedistributions(
          ops, func, dialect, classifications, coordinateCaches)))
    return failure();
  validationTiming.stop();

  TimingScope compositionTiming = timing.nest("lower_redistribute_compose");
  DenseSet<Operation *> erased;
  if (failed(composeRedistributions(rewriter, ops, dialect.getSymbolStore(),
                                    erased, classifications, coordinateCaches)))
    return failure();
  compositionTiming.stop();

  ScratchSequenceMap sequences;
  std::unique_ptr<WaveLDSAllocationAnalysis> analysis;
  for (RedistributeOp op : ops) {
    if (erased.contains(op.getOperation()))
      continue;
    Operation *operation = op.getOperation();
    std::optional<RedistributionClassification> classification;
    auto found = classifications.find(operation);
    if (found != classifications.end())
      classification = found->second;
    std::unique_ptr<CoordinateCache> localCoordinateCache;
    auto cache = coordinateCaches.find(operation);
    if (cache == coordinateCaches.end()) {
      localCoordinateCache = std::make_unique<CoordinateCache>();
      cache = coordinateCaches
                  .try_emplace(operation, std::move(localCoordinateCache))
                  .first;
    }
    if (failed(lowerRedistribution(rewriter, op, dialect, func, analysis,
                                   sequences, classification, *cache->second,
                                   timing)))
      return failure();
    coordinateCaches.erase(operation);
    classifications.erase(operation);
  }
  return success();
}

struct WaveLowerRedistributePass
    : public wave::impl::WaveLowerRedistributeBase<WaveLowerRedistributePass> {
  void runOnOperation() override {
    RedistributeStageTiming timing;
    TimingScope setupTiming = timing.nest("lower_redistribute_setup");
    WaveDialect *dialect = getContext().getLoadedDialect<WaveDialect>();
    if (!dialect) {
      getOperation()->emitError("Wave dialect is not loaded");
      return signalPassFailure();
    }
    IRRewriter rewriter(&getContext());
    SmallVector<func::FuncOp> funcs;
    if (auto func = dyn_cast<func::FuncOp>(getOperation()))
      funcs.push_back(func);
    else
      getOperation()->walk([&](func::FuncOp func) { funcs.push_back(func); });
    setupTiming.stop();
    for (func::FuncOp func : funcs)
      if (failed(lowerFunc(func, *dialect, rewriter, timing)))
        return signalPassFailure();
  }
};

} // namespace
