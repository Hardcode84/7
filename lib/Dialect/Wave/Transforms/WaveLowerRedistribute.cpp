//===- WaveLowerRedistribute.cpp - symbolic packet movement -----*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/Wave/Transforms/Passes.h"

#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/Wave/IR/Wave.h"
#include "mlir/Dialect/Wave/IR/WaveSymbols.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachineTarget.h"
#include "mlir/IR/BuiltinAttributes.h"
#include "mlir/IR/PatternMatch.h"
#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/DenseSet.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/Support/CheckedArithmetic.h"
#include "llvm/Support/ErrorHandling.h"
#include "llvm/Support/MathExtras.h"

#include <array>
#include <optional>

namespace mlir::wave {
#define GEN_PASS_DEF_WAVELOWERREDISTRIBUTE
#include "mlir/Dialect/Wave/Transforms/Passes.h.inc"
} // namespace mlir::wave

using namespace mlir;
using namespace mlir::wave;

namespace {

static constexpr int64_t kMaxRelationPoints = int64_t{1} << 20;

enum class Movement { Alias, Workitem, Wave, Workgroup, Cluster };

struct RelationDomain {
  sym::ExprHandle block;
  sym::ExprHandle item;
  sym::ExprHandle slot;
  sym::PredHandle blockRange;
  sym::PredHandle itemRange;
  sym::PredHandle slotRange;
};

struct MaterializedExpr {
  Value value;
  std::optional<int64_t> literal;
};

struct ScratchLayoutPlan {
  int64_t vectorElements = 1;
  int64_t groupShift = 0;
  int64_t phaseBits = 0;
  int64_t itemShift = 0;
  int64_t bankConflicts = 0;
};

struct SourceCoordinate {
  int64_t item;
  int64_t slot;
};

struct ScratchAccessPattern {
  SmallVector<SourceCoordinate> loads;
  int64_t resultGroups;
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
                                             RedistributeOp op) {
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
  return RelationDomain{*block,      *item,      *slot,
                        *blockRange, *itemRange, *slotRange};
}

static FailureOr<int64_t> evaluateCoordinate(sym::Store &store,
                                             sym::ExprHandle expr,
                                             const RelationDomain &domain,
                                             int64_t block, int64_t item,
                                             int64_t slot) {
  FailureOr<sym::ExprHandle> blockValue = sym::composeExprInt(store, block);
  FailureOr<sym::ExprHandle> itemValue = sym::composeExprInt(store, item);
  FailureOr<sym::ExprHandle> slotValue = sym::composeExprInt(store, slot);
  if (failed(blockValue) || failed(itemValue) || failed(slotValue))
    return failure();
  std::array<sym::ExprSubstitution, 3> substitutions{
      sym::ExprSubstitution{domain.block, *blockValue},
      sym::ExprSubstitution{domain.item, *itemValue},
      sym::ExprSubstitution{domain.slot, *slotValue}};
  FailureOr<sym::ExprHandle> substituted =
      sym::substituteExpr(store, expr, substitutions);
  if (failed(substituted))
    return failure();
  FailureOr<sym::ExprHandle> simplified =
      sym::simplifyExpr(store, *substituted);
  if (failed(simplified))
    return failure();
  std::optional<int64_t> value = sym::getIntegerLiteralValue(*simplified);
  if (!value)
    return failure();
  return *value;
}

static FailureOr<SourceCoordinate>
evaluateSourceCoordinate(sym::Store &store, RedistributeOp op,
                         const RelationDomain &domain, int64_t block,
                         int64_t item, int64_t slot) {
  FailureOr<int64_t> sourceItem = evaluateCoordinate(
      store, op.getRelation().getSourceItem(), domain, block, item, slot);
  FailureOr<int64_t> sourceSlot = evaluateCoordinate(
      store, op.getRelation().getSourceSlot(), domain, block, item, slot);
  if (failed(sourceItem) || failed(sourceSlot)) {
    op.emitOpError("failed to evaluate verified redistribution relation");
    return failure();
  }
  return SourceCoordinate{*sourceItem, *sourceSlot};
}

static sym::CheckResult proveEqual(sym::Store &store, sym::ExprHandle lhs,
                                   sym::ExprHandle rhs,
                                   ArrayRef<sym::PredHandle> assumptions) {
  FailureOr<sym::PredHandle> equal =
      sym::composePredCmp(store, lhs, sym::PredCmpOp::Eq, rhs);
  if (failed(equal))
    return sym::CheckResult::Unknown;
  return sym::checkPredicate(store, *equal, assumptions);
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

static sym::CheckResult proveSameWave(sym::Store &store,
                                      sym::ExprHandle sourceItem,
                                      sym::ExprHandle destinationItem,
                                      int64_t waveWidth,
                                      ArrayRef<sym::PredHandle> assumptions) {
  FailureOr<sym::ExprHandle> sourceWave =
      floorDiv(store, sourceItem, waveWidth);
  FailureOr<sym::ExprHandle> destinationWave =
      floorDiv(store, destinationItem, waveWidth);
  if (failed(sourceWave) || failed(destinationWave))
    return sym::CheckResult::Unknown;
  return proveEqual(store, *sourceWave, *destinationWave, assumptions);
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

static FailureOr<Movement> classifyByEnumeration(sym::Store &store,
                                                 RedistributeOp op,
                                                 const RelationDomain &domain,
                                                 int64_t waveWidth) {
  int64_t items = op.getRelation().getItems();
  int64_t blocks = op.getRelation().getBlocks();
  int64_t slots = getPacketType(op.getResult().getType()).getNumElements();
  std::optional<int64_t> points = llvm::checkedMul(blocks, items);
  if (points)
    points = llvm::checkedMul(*points, slots);
  if (!points) {
    op.emitOpError(
        "symbolic movement classification exceeds the 2^20 point limit");
    return failure();
  }
  if (*points > kMaxRelationPoints) {
    op.emitOpError(
        "symbolic movement classification exceeds the 2^20 point limit");
    return failure();
  }

  bool sameBlock = true;
  bool sameItem = true;
  bool sameWave = true;
  bool identitySlot = op.getSource().getType() == op.getResult().getType();
  for (int64_t block : llvm::seq<int64_t>(0, blocks)) {
    for (int64_t item : llvm::seq<int64_t>(0, items)) {
      for (int64_t slot : llvm::seq<int64_t>(0, slots)) {
        FailureOr<int64_t> sourceBlock =
            evaluateCoordinate(store, op.getRelation().getSourceBlock(), domain,
                               block, item, slot);
        FailureOr<int64_t> sourceItem = evaluateCoordinate(
            store, op.getRelation().getSourceItem(), domain, block, item, slot);
        FailureOr<int64_t> sourceSlot = evaluateCoordinate(
            store, op.getRelation().getSourceSlot(), domain, block, item, slot);
        if (failed(sourceBlock) || failed(sourceItem) || failed(sourceSlot)) {
          op.emitOpError("failed to evaluate verified redistribution relation");
          return failure();
        }
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

static FailureOr<Movement> classifyMovement(sym::Store &store,
                                            RedistributeOp op,
                                            const RelationDomain &domain,
                                            int64_t waveWidth) {
  std::array<sym::PredHandle, 3> assumptions{
      domain.blockRange, domain.itemRange, domain.slotRange};
  sym::CheckResult sameBlock = proveEqual(
      store, op.getRelation().getSourceBlock(), domain.block, assumptions);
  if (sameBlock == sym::CheckResult::False)
    return Movement::Cluster;
  if (sameBlock == sym::CheckResult::Unknown)
    return classifyByEnumeration(store, op, domain, waveWidth);
  sym::CheckResult sameItem = proveEqual(
      store, op.getRelation().getSourceItem(), domain.item, assumptions);
  sym::CheckResult identitySlot = proveEqual(
      store, op.getRelation().getSourceSlot(), domain.slot, assumptions);
  sym::CheckResult sameWave =
      proveSameWave(store, op.getRelation().getSourceItem(), domain.item,
                    waveWidth, assumptions);

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
  return classifyByEnumeration(store, op, domain, waveWidth);
}

static bool hasSymbol(sym::ExprHandle expr, StringRef needle) {
  bool found = false;
  sym::walkSymbolNames(expr, [&](StringRef name) { found |= name == needle; });
  return found;
}

static FailureOr<sym::ExprHandle>
simplifyRelationExpr(sym::Store &store, sym::ExprHandle expr,
                     const RelationDomain &domain) {
  std::array<sym::PredHandle, 3> assumptions{
      domain.blockRange, domain.itemRange, domain.slotRange};
  return sym::simplifyExpr(store, expr, assumptions);
}

static LogicalResult validateBlockLowering(RedistributeOp op, sym::Store &store,
                                           const RelationDomain &domain,
                                           Movement movement) {
  if (movement == Movement::Cluster)
    return op.emitOpError(
        "cross-block redistribution requires cluster/DSM lowering");
  if (movement == Movement::Alias || op.getRelation().getBlocks() == 1)
    return success();

  for (sym::ExprHandle expr :
       {op.getRelation().getSourceItem(), op.getRelation().getSourceSlot()}) {
    FailureOr<sym::ExprHandle> simplified =
        simplifyRelationExpr(store, expr, domain);
    if (failed(simplified))
      return op.emitOpError("failed to simplify redistribution relation");
    if (hasSymbol(*simplified, "block"))
      return op.emitOpError(
          "block-dependent redistribution requires a cluster block coordinate");
  }
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

static FailureOr<bool> supportsVectorAt(sym::Store &store, RedistributeOp op,
                                        const RelationDomain &domain,
                                        int64_t block, int64_t item,
                                        int64_t slot, int64_t vectorElements) {
  FailureOr<SourceCoordinate> first =
      evaluateSourceCoordinate(store, op, domain, block, item, slot);
  if (failed(first))
    return failure();
  int64_t vectorGroup = first->slot / vectorElements;
  for (int64_t offset : llvm::seq<int64_t>(1, vectorElements)) {
    FailureOr<SourceCoordinate> next =
        evaluateSourceCoordinate(store, op, domain, block, item, slot + offset);
    if (failed(next))
      return failure();
    if (next->item != first->item || next->slot / vectorElements != vectorGroup)
      return false;
  }
  return true;
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

static FailureOr<bool> supportsVectorTransfer(sym::Store &store,
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
            store, op, domain, block, item, slot, vectorElements);
        if (failed(supported))
          return failure();
        if (!*supported)
          return false;
      }
    }
  }
  return true;
}

static FailureOr<int64_t> selectVectorElements(sym::Store &store,
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
        supportsVectorTransfer(store, op, domain, vectorElements);
    if (failed(supported))
      return failure();
    if (*supported)
      return vectorElements;
  }
  return 1;
}

static FailureOr<std::optional<int64_t>>
inferVectorSelector(sym::Store &store, RedistributeOp op,
                    const RelationDomain &domain, int64_t destinationSlot,
                    int64_t vectorElements) {
  std::optional<int64_t> selector;
  for (int64_t block : llvm::seq<int64_t>(0, op.getRelation().getBlocks())) {
    for (int64_t item : llvm::seq<int64_t>(0, op.getRelation().getItems())) {
      FailureOr<int64_t> sourceSlot =
          evaluateCoordinate(store, op.getRelation().getSourceSlot(), domain,
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
inferVectorSelectors(sym::Store &store, RedistributeOp op,
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
        inferVectorSelector(store, op, domain, slot, vectorElements);
    if (failed(selector))
      return failure();
    selectors.push_back(*selector);
  }
  return selectors;
}

static int64_t getSharedMemoryBankCount(Operation *op) {
  ModuleOp targetModule = waveamdmachine::findAMDGPUTargetModule(op);
  if (!targetModule)
    return 32;
  StringAttr targetAttr =
      targetModule->getAttrOfType<StringAttr>("waveamdmachine.target");
  if (!targetAttr)
    return 32;
  std::optional<waveamdmachine::AMDGPUTarget> target =
      waveamdmachine::parseAMDGPUTargetAttr(targetAttr.getValue());
  if (!target)
    return 32;
  llvm::AMDGPU::IsaVersion isa = llvm::AMDGPU::getIsaVersion(target->chip);
  if ((isa.Major == 9 && isa.Minor == 5) || (isa.Major == 12 && isa.Minor == 5))
    return 64;
  return 32;
}

static int64_t physicalScratchVectorAddress(const ScratchLayoutPlan &plan,
                                            int64_t items, int64_t item,
                                            int64_t slot) {
  int64_t group = slot / plan.vectorElements;
  int64_t physicalItem = item;
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

static FailureOr<ScratchAccessPattern>
buildScratchAccessPattern(sym::Store &store, RedistributeOp op,
                          const RelationDomain &domain,
                          int64_t vectorElements) {
  int64_t items = op.getRelation().getItems();
  int64_t resultSlots =
      getPacketType(op.getResult().getType()).getNumElements();
  ScratchAccessPattern pattern;
  pattern.resultGroups = resultSlots / vectorElements;
  pattern.loads.reserve(pattern.resultGroups * items);
  for (int64_t slot = 0; slot < resultSlots; slot += vectorElements) {
    for (int64_t item : llvm::seq<int64_t>(0, items)) {
      FailureOr<SourceCoordinate> source =
          evaluateSourceCoordinate(store, op, domain, 0, item, slot);
      if (failed(source))
        return failure();
      pattern.loads.push_back(*source);
    }
  }
  return pattern;
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
                                  int64_t waveWidth, int64_t banks) {
  int64_t sourceSlots =
      getPacketType(op.getSource().getType()).getNumElements();
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

static FailureOr<ScratchLayoutPlan>
selectScratchLayout(sym::Store &store, RedistributeOp op,
                    const RelationDomain &domain, int64_t waveWidth) {
  FailureOr<int64_t> vectorElements =
      selectVectorElements(store, op, domain, /*maxVectorBits=*/128);
  if (failed(vectorElements))
    return failure();
  ScratchLayoutPlan best;
  best.vectorElements = *vectorElements;
  if (exceedsScratchPlanningBudget(op, best.vectorElements))
    return best;
  FailureOr<ScratchAccessPattern> pattern =
      buildScratchAccessPattern(store, op, domain, best.vectorElements);
  if (failed(pattern))
    return failure();
  int64_t banks = getSharedMemoryBankCount(op);
  best.bankConflicts = scoreScratchLayout(op, *pattern, best, waveWidth, banks);

  int64_t items = op.getRelation().getItems();
  int64_t sourceSlots =
      getPacketType(op.getSource().getType()).getNumElements();
  int64_t groups = sourceSlots / best.vectorElements;
  unsigned groupBits = groups > 1 ? llvm::Log2_64_Ceil(groups) : 0;
  // Low item bits stay inside every aligned power-of-two item tile.
  unsigned itemBits = llvm::countr_zero(static_cast<uint64_t>(items));
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
        candidate.bankConflicts =
            scoreScratchLayout(op, *pattern, candidate, waveWidth, banks);
        if (candidate.bankConflicts < best.bankConflicts)
          best = candidate;
      }
    }
  }
  return best;
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

static FailureOr<sym::ExprHandle>
composePhysicalItem(sym::Store &store, sym::ExprHandle item,
                    sym::ExprHandle group, const ScratchLayoutPlan &plan) {
  if (!plan.phaseBits)
    return item;
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
  return sym::composeExprBinary(store, item, sym::ExprBinaryOp::Xor, *shifted);
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
public:
  RelationMaterializer(IRRewriter &rewriter, RedistributeOp op,
                       sym::Store &store, const RelationDomain &domain)
      : rewriter(rewriter), op(op), store(store), domain(domain) {}

  FailureOr<MaterializedExpr> materialize(sym::ExprHandle expr,
                                          int64_t destinationSlot) {
    FailureOr<sym::ExprHandle> slotValue =
        sym::composeExprInt(store, destinationSlot);
    if (failed(slotValue))
      return failure();
    FailureOr<sym::ExprHandle> blockValue = sym::composeExprInt(store, 0);
    if (failed(blockValue))
      return failure();
    std::array<sym::ExprSubstitution, 2> substitutions{
        sym::ExprSubstitution{domain.block, *blockValue},
        sym::ExprSubstitution{domain.slot, *slotValue}};
    FailureOr<sym::ExprHandle> substituted =
        sym::substituteExpr(store, expr, substitutions);
    if (failed(substituted))
      return failure();
    std::array<sym::PredHandle, 1> assumptions{domain.itemRange};
    FailureOr<sym::ExprHandle> simplified =
        sym::simplifyExpr(store, *substituted, assumptions);
    if (failed(simplified))
      return failure();
    if (std::optional<int64_t> literal =
            sym::getIntegerLiteralValue(*simplified))
      return MaterializedExpr{Value(), literal};

    Value item = getItem();
    Type resultType =
        SimdType::get(op.getContext(), rewriter.getIndexType(), getWaveWidth());
    ArrayAttr names = rewriter.getStrArrayAttr({"item"});
    ArrayAttr predicateAttrs =
        getIndexExprPredArrayAttr(op.getContext(), assumptions);
    Value value =
        IndexExprOp::create(rewriter, op.getLoc(), resultType,
                            ExprAttr::get(op.getContext(), *simplified),
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

  IRRewriter &rewriter;
  RedistributeOp op;
  sym::Store &store;
  const RelationDomain &domain;
  Value item;
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
collectSourceVectorGroups(sym::Store &store, RedistributeOp op,
                          const RelationDomain &domain, int64_t destinationSlot,
                          int64_t vectorElements) {
  DenseSet<int64_t> groupSet;
  for (int64_t block : llvm::seq<int64_t>(0, op.getRelation().getBlocks())) {
    for (int64_t item : llvm::seq<int64_t>(0, op.getRelation().getItems())) {
      FailureOr<int64_t> sourceSlot =
          evaluateCoordinate(store, op.getRelation().getSourceSlot(), domain,
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
  SmallVector<Value> result;
  result.reserve(resultSlots);
  for (int64_t slot : llvm::seq<int64_t>(0, resultSlots)) {
    FailureOr<MaterializedExpr> lane =
        materializer.materialize(*sourceLane, slot);
    FailureOr<MaterializedExpr> sourceSlot =
        materializer.materialize(op.getRelation().getSourceSlot(), slot);
    if (failed(lane) || failed(sourceSlot))
      return op.emitOpError("failed to materialize same-wave relation");
    Value laneValue = lane->literal ? materializer.constantIndex(*lane->literal,
                                                                 /*simd=*/false)
                                    : lane->value;

    if (sourceSlot->literal) {
      Value shuffled = ShuffleOp::create(
          rewriter, op.getLoc(), source[*sourceSlot->literal].getType(),
          source[*sourceSlot->literal], laneValue);
      result.push_back(shuffled);
      continue;
    }

    SmallVector<Value> shuffled;
    shuffled.reserve(source.size());
    for (Value component : source)
      shuffled.push_back(ShuffleOp::create(
          rewriter, op.getLoc(), component.getType(), component, laneValue));
    FailureOr<Value> selected =
        selectComponent(rewriter, op, materializer, shuffled, *sourceSlot);
    if (failed(selected))
      return op.emitOpError("failed to select shuffled packet component");
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
materializeWaveSlice(IRRewriter &rewriter, RedistributeOp op, sym::Store &store,
                     const RelationDomain &domain,
                     RelationMaterializer &materializer, ArrayRef<Value> source,
                     sym::ExprHandle sourceLane, sym::ExprHandle sourceGroup,
                     int64_t destinationSlot, int64_t vectorElements) {
  FailureOr<SmallVector<int64_t>> groups = collectSourceVectorGroups(
      store, op, domain, destinationSlot, vectorElements);
  FailureOr<MaterializedExpr> lane =
      materializer.materialize(sourceLane, destinationSlot);
  if (failed(groups) || failed(lane))
    return failure();
  Value laneValue = lane->literal ? materializer.constantIndex(*lane->literal,
                                                               /*simd=*/false)
                                  : lane->value;

  SmallVector<Value> candidates;
  candidates.reserve(groups->size());
  for (int64_t group : *groups)
    candidates.push_back(ShuffleOp::create(rewriter, op.getLoc(),
                                           source[group].getType(),
                                           source[group], laneValue));
  if (candidates.size() == 1)
    return candidates.front();

  FailureOr<MaterializedExpr> selector =
      materializer.materialize(sourceGroup, destinationSlot);
  if (failed(selector))
    return failure();
  return selectKeyedCandidate(rewriter, op, materializer, candidates, *groups,
                              *selector);
}

static LogicalResult lowerWavePacketized(IRRewriter &rewriter,
                                         RedistributeOp op, sym::Store &store,
                                         const RelationDomain &domain,
                                         int64_t waveWidth) {
  FailureOr<int64_t> vectorElements =
      selectVectorElements(store, op, domain, /*maxVectorBits=*/0);
  if (failed(vectorElements))
    return failure();
  FailureOr<SmallVector<std::optional<int64_t>>> selectors =
      inferVectorSelectors(store, op, domain, *vectorElements);
  if (failed(selectors))
    return failure();

  FailureOr<sym::ExprHandle> width = sym::composeExprInt(store, waveWidth);
  if (failed(width))
    return op.emitOpError("failed to construct source lane expression");
  FailureOr<sym::ExprHandle> sourceLane = sym::composeExprBinary(
      store, op.getRelation().getSourceItem(), sym::ExprBinaryOp::Mod, *width);
  FailureOr<sym::ExprHandle> sourceGroup =
      floorDiv(store, op.getRelation().getSourceSlot(), *vectorElements);
  FailureOr<sym::ExprHandle> sourceWithin =
      composeBinaryInt(store, op.getRelation().getSourceSlot(),
                       sym::ExprBinaryOp::Mod, *vectorElements);
  if (failed(sourceLane) || failed(sourceGroup) || failed(sourceWithin))
    return op.emitOpError("failed to construct packetized wave relation");

  RelationMaterializer materializer(rewriter, op, store, domain);
  SmallVector<Value> source =
      extractPacketSlices(rewriter, op, *vectorElements);
  int64_t resultSlots =
      getPacketType(op.getResult().getType()).getNumElements();
  SmallVector<Value> result;
  result.reserve(resultSlots);
  for (int64_t slot = 0; slot < resultSlots; slot += *vectorElements) {
    FailureOr<Value> selected =
        materializeWaveSlice(rewriter, op, store, domain, materializer, source,
                             *sourceLane, *sourceGroup, slot, *vectorElements);
    if (failed(selected))
      return op.emitOpError("failed to materialize packetized wave relation");
    if (failed(appendSliceResults(rewriter, op, materializer, *selected, slot,
                                  *vectorElements, *selectors, *sourceWithin,
                                  result)))
      return failure();
  }

  Value packed =
      PackOp::create(rewriter, op.getLoc(), op.getResult().getType(), result);
  rewriter.replaceOp(op, packed);
  return success();
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

static Type getScratchTransferType(RedistributeOp op,
                                   const ScratchLayoutPlan &plan) {
  return getPacketSliceType(op.getSource().getType(), plan.vectorElements);
}

static Value buildScratchStoreValue(IRRewriter &rewriter, RedistributeOp op,
                                    ArrayRef<Value> source, int64_t slot,
                                    const ScratchLayoutPlan &plan) {
  if (plan.vectorElements == 1)
    return source[slot];
  return PackOp::create(rewriter, op.getLoc(), getScratchTransferType(op, plan),
                        source.slice(slot, plan.vectorElements));
}

static FailureOr<Value> emitScratchStores(
    IRRewriter &rewriter, RedistributeOp op, RelationMaterializer &materializer,
    Value allocation, ArrayRef<Value> source, sym::ExprHandle address,
    const ScratchLayoutPlan &plan, Type tokenType, Value dependency) {
  SmallVector<Value> tokens;
  tokens.reserve(source.size() / plan.vectorElements);
  for (int64_t slot = 0; slot < static_cast<int64_t>(source.size());
       slot += plan.vectorElements) {
    FailureOr<MaterializedExpr> offset =
        materializer.materialize(address, slot);
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
    Value value = buildScratchStoreValue(rewriter, op, source, slot, plan);
    StoreOp store = StoreOp::create(rewriter, op.getLoc(), tokenType, value,
                                    *pointer, dependency, Attribute());
    tokens.push_back(store.getToken());
  }
  return BarrierOp::create(rewriter, op.getLoc(), tokenType, tokens).getToken();
}

struct ScratchLoads {
  SmallVector<Value> values;
  SmallVector<Value> tokens;
};

struct ScratchSequence {
  Value completion;
  Operation *cursor = nullptr;
};

using ScratchSequenceMap = DenseMap<Block *, ScratchSequence>;

static Value advanceScratchSequence(IRRewriter &rewriter, RedistributeOp op,
                                    ScratchSequenceMap &sequences) {
  auto it = sequences.find(op->getBlock());
  if (it == sequences.end())
    return {};

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

static FailureOr<ScratchLoads>
emitScratchLoads(IRRewriter &rewriter, RedistributeOp op,
                 RelationMaterializer &materializer, Value allocation,
                 sym::ExprHandle address, int64_t resultSlots,
                 sym::ExprHandle sourceWithin, const ScratchLayoutPlan &plan,
                 ArrayRef<std::optional<int64_t>> selectors, Type componentType,
                 Type tokenType, Value published) {
  ScratchLoads loads;
  loads.values.reserve(resultSlots);
  loads.tokens.reserve(resultSlots / plan.vectorElements);
  Type transferType = getScratchTransferType(op, plan);
  for (int64_t slot = 0; slot < resultSlots; slot += plan.vectorElements) {
    FailureOr<MaterializedExpr> offset =
        materializer.materialize(address, slot);
    if (failed(offset)) {
      op.emitOpError("failed to materialize scratch load address");
      return failure();
    }
    FailureOr<Value> pointer =
        buildPointer(rewriter, op, materializer, allocation, *offset);
    if (failed(pointer)) {
      op.emitOpError("failed to build scratch load pointer");
      return failure();
    }
    LoadOp load = LoadOp::create(rewriter, op.getLoc(), transferType, tokenType,
                                 *pointer, published, Attribute());
    loads.tokens.push_back(load.getToken());
    if (plan.vectorElements == 1) {
      loads.values.push_back(load.getValue());
      continue;
    }

    SmallVector<Value> candidates;
    candidates.reserve(plan.vectorElements);
    for (int64_t index : llvm::seq<int64_t>(0, plan.vectorElements))
      candidates.push_back(ExtractOp::create(
          rewriter, op.getLoc(), componentType, load.getValue(), index));
    for (int64_t offset : llvm::seq<int64_t>(0, plan.vectorElements)) {
      int64_t destinationSlot = slot + offset;
      if (selectors[destinationSlot]) {
        loads.values.push_back(candidates[*selectors[destinationSlot]]);
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
      loads.values.push_back(*selected);
    }
  }
  return loads;
}

static LogicalResult lowerWorkgroup(IRRewriter &rewriter, RedistributeOp op,
                                    sym::Store &store,
                                    const RelationDomain &domain,
                                    func::FuncOp func,
                                    ScratchSequenceMap &sequences) {
  if (!func.getBody().hasOneBlock())
    return op.emitOpError(
        "cross-wave redistribution requires a single-block kernel function");

  FailureOr<int64_t> scratchBytes = getScratchBytes(op);
  if (failed(scratchBytes))
    return failure();
  int64_t waveWidth = cast<SimdType>(op.getSource().getType()).getWidth();
  FailureOr<ScratchLayoutPlan> layout =
      selectScratchLayout(store, op, domain, waveWidth);
  if (failed(layout))
    return failure();
  FailureOr<SmallVector<std::optional<int64_t>>> selectors =
      inferVectorSelectors(store, op, domain, layout->vectorElements);
  if (failed(selectors))
    return failure();
  VectorType sourcePacket = getPacketType(op.getSource().getType());
  Type elementType = sourcePacket.getElementType();
  int64_t elementBytes = elementType.getIntOrFloatBitWidth() / 8;
  int64_t transferBytes = elementBytes * layout->vectorElements;
  PtrType pointerType =
      PtrType::get(op.getContext(), elementType,
                   SharedAddressSpaceAttr::get(op.getContext()));
  Value allocation = AllocOp::create(rewriter, op.getLoc(), pointerType,
                                     static_cast<uint64_t>(*scratchBytes),
                                     static_cast<uint64_t>(transferBytes));
  RelationMaterializer materializer(rewriter, op, store, domain);
  SmallVector<Value> source = extractComponents(rewriter, op);

  FailureOr<sym::ExprHandle> storeAddress = composeScratchVectorAddress(
      store, domain.item, domain.slot, op.getRelation().getItems(), *layout);
  if (failed(storeAddress))
    return op.emitOpError("failed to construct scratch store address");
  Type tokenType = MemTokenType::get(op.getContext());
  Value dependency = advanceScratchSequence(rewriter, op, sequences);
  FailureOr<Value> published =
      emitScratchStores(rewriter, op, materializer, allocation, source,
                        *storeAddress, *layout, tokenType, dependency);
  if (failed(published))
    return failure();
  FailureOr<sym::ExprHandle> loadAddress = composeScratchVectorAddress(
      store, op.getRelation().getSourceItem(), op.getRelation().getSourceSlot(),
      op.getRelation().getItems(), *layout);
  if (failed(loadAddress))
    return op.emitOpError("failed to construct scratch load address");
  FailureOr<sym::ExprHandle> sourceWithin =
      composeBinaryInt(store, op.getRelation().getSourceSlot(),
                       sym::ExprBinaryOp::Mod, layout->vectorElements);
  if (failed(sourceWithin))
    return op.emitOpError("failed to construct scratch vector selector");

  int64_t resultSlots =
      getPacketType(op.getResult().getType()).getNumElements();
  Type componentType = getPacketElementType(op.getSource().getType());
  FailureOr<ScratchLoads> loaded = emitScratchLoads(
      rewriter, op, materializer, allocation, *loadAddress, resultSlots,
      *sourceWithin, *layout, *selectors, componentType, tokenType, *published);
  if (failed(loaded))
    return failure();

  Value packed = PackOp::create(rewriter, op.getLoc(), op.getResult().getType(),
                                loaded->values);
  Value completed =
      JoinOp::create(rewriter, op.getLoc(), tokenType, loaded->tokens);
  AllocReleaseOp released =
      AllocReleaseOp::create(rewriter, op.getLoc(), tokenType, allocation,
                             completed, rewriter.getUnitAttr());
  sequences[op->getBlock()] = {released.getToken(), released};
  rewriter.replaceOp(op, packed);
  return success();
}

static bool canCompose(RedistributeOp previous, RedistributeOp op) {
  return previous->getBlock() == op->getBlock() &&
         previous.getResult().hasOneUse() &&
         previous.getRelation().getBlocks() == op.getRelation().getBlocks() &&
         previous.getRelation().getItems() == op.getRelation().getItems();
}

static LogicalResult composeOne(RedistributeOp previous, RedistributeOp op,
                                sym::Store &store) {
  FailureOr<sym::ExprHandle> block = sym::composeExprSym(store, "block");
  FailureOr<sym::ExprHandle> item = sym::composeExprSym(store, "item");
  FailureOr<sym::ExprHandle> slot = sym::composeExprSym(store, "slot");
  if (failed(block) || failed(item) || failed(slot))
    return op.emitOpError("failed to construct composition symbols");
  std::array<sym::ExprSubstitution, 3> substitutions{
      sym::ExprSubstitution{*block, op.getRelation().getSourceBlock()},
      sym::ExprSubstitution{*item, op.getRelation().getSourceItem()},
      sym::ExprSubstitution{*slot, op.getRelation().getSourceSlot()}};
  FailureOr<sym::ExprHandle> sourceBlock = sym::substituteExpr(
      store, previous.getRelation().getSourceBlock(), substitutions);
  FailureOr<sym::ExprHandle> sourceItem = sym::substituteExpr(
      store, previous.getRelation().getSourceItem(), substitutions);
  FailureOr<sym::ExprHandle> sourceSlot = sym::substituteExpr(
      store, previous.getRelation().getSourceSlot(), substitutions);
  if (failed(sourceBlock) || failed(sourceItem) || failed(sourceSlot))
    return op.emitOpError("failed to compose redistribution relations");
  sourceBlock = sym::simplifyExpr(store, *sourceBlock);
  sourceItem = sym::simplifyExpr(store, *sourceItem);
  sourceSlot = sym::simplifyExpr(store, *sourceSlot);
  if (failed(sourceBlock) || failed(sourceItem) || failed(sourceSlot))
    return op.emitOpError("failed to simplify composed redistribution");

  RedistributionAttr relation = RedistributionAttr::get(
      op.getContext(), op.getRelation().getBlocks(),
      op.getRelation().getItems(), *sourceBlock, *sourceItem, *sourceSlot);
  op->setOperand(0, previous.getSource());
  op.setRelationAttr(relation);
  return op.verify();
}

static LogicalResult composeAdjacent(IRRewriter &rewriter, RedistributeOp op,
                                     sym::Store &store,
                                     DenseSet<Operation *> &erased) {
  while (RedistributeOp previous =
             op.getSource().getDefiningOp<RedistributeOp>()) {
    if (!canCompose(previous, op))
      break;
    if (failed(composeOne(previous, op, store)))
      return failure();
    erased.insert(previous.getOperation());
    rewriter.eraseOp(previous);
  }
  return success();
}

static LogicalResult validateRedistributions(ArrayRef<RedistributeOp> ops,
                                             func::FuncOp func) {
  for (RedistributeOp op : ops) {
    int64_t width = cast<SimdType>(op.getSource().getType()).getWidth();
    if (failed(validateWorkgroup(op, func, width)))
      return failure();
  }
  return success();
}

static LogicalResult composeRedistributions(IRRewriter &rewriter,
                                            ArrayRef<RedistributeOp> ops,
                                            sym::Store &store,
                                            DenseSet<Operation *> &erased) {
  for (RedistributeOp op : llvm::reverse(ops)) {
    if (erased.contains(op.getOperation()))
      continue;
    if (failed(composeAdjacent(rewriter, op, store, erased)))
      return failure();
  }
  return success();
}

static LogicalResult lowerRedistribution(IRRewriter &rewriter,
                                         RedistributeOp op,
                                         WaveDialect &dialect,
                                         func::FuncOp func,
                                         ScratchSequenceMap &sequences) {
  rewriter.setInsertionPoint(op);
  FailureOr<RelationDomain> domain = buildDomain(dialect.getSymbolStore(), op);
  if (failed(domain))
    return op.emitOpError("failed to construct redistribution domain");
  int64_t width = cast<SimdType>(op.getSource().getType()).getWidth();
  FailureOr<Movement> movement =
      classifyMovement(dialect.getSymbolStore(), op, *domain, width);
  if (failed(movement))
    return failure();
  if (failed(validateBlockLowering(op, dialect.getSymbolStore(), *domain,
                                   *movement)))
    return failure();

  switch (*movement) {
  case Movement::Alias:
    rewriter.replaceOp(op, op.getSource());
    return success();
  case Movement::Workitem:
    return lowerWorkitem(rewriter, op, dialect.getSymbolStore(), *domain);
  case Movement::Wave:
    return lowerWave(rewriter, op, dialect.getSymbolStore(), *domain, width);
  case Movement::Workgroup:
    return lowerWorkgroup(rewriter, op, dialect.getSymbolStore(), *domain, func,
                          sequences);
  case Movement::Cluster:
    llvm_unreachable("cluster movement must fail contextual validation");
  }
  llvm_unreachable("unknown redistribution movement");
}

static LogicalResult lowerFunc(func::FuncOp func, WaveDialect &dialect,
                               IRRewriter &rewriter) {
  SmallVector<RedistributeOp> ops;
  func.walk([&](RedistributeOp op) { ops.push_back(op); });
  if (ops.empty())
    return success();
  if (failed(validateRedistributions(ops, func)))
    return failure();

  DenseSet<Operation *> erased;
  if (failed(composeRedistributions(rewriter, ops, dialect.getSymbolStore(),
                                    erased)))
    return failure();

  ScratchSequenceMap sequences;
  for (RedistributeOp op : ops) {
    if (erased.contains(op.getOperation()))
      continue;
    if (failed(lowerRedistribution(rewriter, op, dialect, func, sequences)))
      return failure();
  }
  return success();
}

struct WaveLowerRedistributePass
    : public wave::impl::WaveLowerRedistributeBase<WaveLowerRedistributePass> {
  void runOnOperation() override {
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
    for (func::FuncOp func : funcs)
      if (failed(lowerFunc(func, *dialect, rewriter)))
        return signalPassFailure();
  }
};

} // namespace
