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
#include "mlir/IR/BuiltinAttributes.h"
#include "mlir/IR/PatternMatch.h"
#include "llvm/ADT/DenseSet.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/Support/CheckedArithmetic.h"
#include "llvm/Support/ErrorHandling.h"

#include <array>
#include <optional>

namespace mlir::wave {
#define GEN_PASS_DEF_WAVELOWERREDISTRIBUTE
#include "mlir/Dialect/Wave/Transforms/Passes.h.inc"
} // namespace mlir::wave

using namespace mlir;
using namespace mlir::wave;

namespace {

enum class Movement { Alias, Workitem, Wave, Workgroup };

struct RelationDomain {
  sym::ExprHandle item;
  sym::ExprHandle slot;
  sym::PredHandle itemRange;
  sym::PredHandle slotRange;
};

struct MaterializedExpr {
  Value value;
  std::optional<int64_t> literal;
};

static VectorType getPacketType(Type type) {
  return cast<VectorType>(cast<SimdType>(type).getElementType());
}

static SimdType getPacketElementType(Type type) {
  SimdType packet = cast<SimdType>(type);
  return SimdType::get(type.getContext(), getPacketType(type).getElementType(),
                       packet.getWidth());
}

static FailureOr<RelationDomain> buildDomain(sym::Store &store,
                                             RedistributeOp op) {
  int64_t destinationSlots =
      getPacketType(op.getResult().getType()).getNumElements();
  FailureOr<sym::ExprHandle> item = sym::composeExprSym(store, "item");
  FailureOr<sym::ExprHandle> slot = sym::composeExprSym(store, "slot");
  FailureOr<sym::PredHandle> itemRange =
      sym::rangeAssumption(store, "item", 0, op.getRelation().getItems() - 1);
  FailureOr<sym::PredHandle> slotRange =
      sym::rangeAssumption(store, "slot", 0, destinationSlots - 1);
  if (failed(item) || failed(slot) || failed(itemRange) || failed(slotRange))
    return failure();
  return RelationDomain{*item, *slot, *itemRange, *slotRange};
}

static FailureOr<int64_t> evaluateCoordinate(sym::Store &store,
                                             sym::ExprHandle expr,
                                             const RelationDomain &domain,
                                             int64_t item, int64_t slot) {
  FailureOr<sym::ExprHandle> itemValue = sym::composeExprInt(store, item);
  FailureOr<sym::ExprHandle> slotValue = sym::composeExprInt(store, slot);
  if (failed(itemValue) || failed(slotValue))
    return failure();
  std::array<sym::ExprSubstitution, 2> substitutions{
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

static Movement finishEnumeratedClassification(bool sameItem, bool sameWave,
                                               bool identitySlot) {
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
  int64_t slots = getPacketType(op.getResult().getType()).getNumElements();
  std::optional<int64_t> points = llvm::checkedMul(items, slots);
  constexpr int64_t maxPoints = int64_t{1} << 20;
  if (!points) {
    op.emitOpError(
        "symbolic movement classification exceeds the 2^20 point limit");
    return failure();
  }
  if (*points > maxPoints) {
    op.emitOpError(
        "symbolic movement classification exceeds the 2^20 point limit");
    return failure();
  }

  bool sameItem = true;
  bool sameWave = true;
  bool identitySlot = op.getSource().getType() == op.getResult().getType();
  for (int64_t item : llvm::seq<int64_t>(0, items)) {
    for (int64_t slot : llvm::seq<int64_t>(0, slots)) {
      FailureOr<int64_t> sourceItem = evaluateCoordinate(
          store, op.getRelation().getSourceItem(), domain, item, slot);
      if (failed(sourceItem)) {
        op.emitOpError("failed to evaluate verified redistribution relation");
        return failure();
      }
      FailureOr<int64_t> sourceSlot = evaluateCoordinate(
          store, op.getRelation().getSourceSlot(), domain, item, slot);
      if (failed(sourceSlot)) {
        op.emitOpError("failed to evaluate verified redistribution relation");
        return failure();
      }
      sameItem &= *sourceItem == item;
      sameWave &= *sourceItem / waveWidth == item / waveWidth;
      identitySlot &= *sourceSlot == slot;
    }
  }
  return finishEnumeratedClassification(sameItem, sameWave, identitySlot);
}

static FailureOr<Movement> classifyMovement(sym::Store &store,
                                            RedistributeOp op,
                                            const RelationDomain &domain,
                                            int64_t waveWidth) {
  std::array<sym::PredHandle, 2> assumptions{domain.itemRange,
                                             domain.slotRange};
  sym::CheckResult sameItem = proveEqual(
      store, op.getRelation().getSourceItem(), domain.item, assumptions);
  sym::CheckResult identitySlot = proveEqual(
      store, op.getRelation().getSourceSlot(), domain.slot, assumptions);
  FailureOr<sym::ExprHandle> sourceWave =
      floorDiv(store, op.getRelation().getSourceItem(), waveWidth);
  FailureOr<sym::ExprHandle> destinationWave =
      floorDiv(store, domain.item, waveWidth);
  sym::CheckResult sameWave = sym::CheckResult::Unknown;
  if (succeeded(sourceWave) && succeeded(destinationWave))
    sameWave = proveEqual(store, *sourceWave, *destinationWave, assumptions);

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

static FailureOr<sym::ExprHandle> composeAddress(sym::Store &store,
                                                 sym::ExprHandle item,
                                                 sym::ExprHandle slot,
                                                 int64_t sourceSlots) {
  FailureOr<sym::ExprHandle> stride = sym::composeExprInt(store, sourceSlots);
  if (failed(stride))
    return failure();
  FailureOr<sym::ExprHandle> row =
      sym::composeExprBinary(store, item, sym::ExprBinaryOp::Mul, *stride);
  if (failed(row))
    return failure();
  return sym::composeExprBinary(store, *row, sym::ExprBinaryOp::Add, slot);
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
    std::array<sym::ExprSubstitution, 1> substitution{
        sym::ExprSubstitution{domain.slot, *slotValue}};
    FailureOr<sym::ExprHandle> substituted =
        sym::substituteExpr(store, expr, substitution);
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

static LogicalResult lowerWave(IRRewriter &rewriter, RedistributeOp op,
                               sym::Store &store, const RelationDomain &domain,
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

static FailureOr<Value>
emitScratchStores(IRRewriter &rewriter, RedistributeOp op,
                  RelationMaterializer &materializer, Value allocation,
                  ArrayRef<Value> source, sym::ExprHandle address,
                  Type tokenType) {
  SmallVector<Value> tokens;
  tokens.reserve(source.size());
  for (int64_t slot : llvm::seq<int64_t>(0, source.size())) {
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
    StoreOp store =
        StoreOp::create(rewriter, op.getLoc(), tokenType, source[slot],
                        *pointer, Value(), Attribute());
    tokens.push_back(store.getToken());
  }
  return BarrierOp::create(rewriter, op.getLoc(), tokenType, tokens).getToken();
}

struct ScratchLoads {
  SmallVector<Value> values;
  SmallVector<Value> tokens;
};

static FailureOr<ScratchLoads>
emitScratchLoads(IRRewriter &rewriter, RedistributeOp op,
                 RelationMaterializer &materializer, Value allocation,
                 sym::ExprHandle address, int64_t resultSlots,
                 Type componentType, Type tokenType, Value published) {
  ScratchLoads loads;
  loads.values.reserve(resultSlots);
  loads.tokens.reserve(resultSlots);
  for (int64_t slot : llvm::seq<int64_t>(0, resultSlots)) {
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
    LoadOp load = LoadOp::create(rewriter, op.getLoc(), componentType,
                                 tokenType, *pointer, published, Attribute());
    loads.values.push_back(load.getValue());
    loads.tokens.push_back(load.getToken());
  }
  return loads;
}

static LogicalResult lowerWorkgroup(IRRewriter &rewriter, RedistributeOp op,
                                    sym::Store &store,
                                    const RelationDomain &domain,
                                    func::FuncOp func) {
  if (!func.getBody().hasOneBlock() || op->getParentOp() != func)
    return op.emitOpError(
        "cross-wave redistribution requires straight-line kernel control");

  FailureOr<int64_t> scratchBytes = getScratchBytes(op);
  if (failed(scratchBytes))
    return failure();
  VectorType sourcePacket = getPacketType(op.getSource().getType());
  Type elementType = sourcePacket.getElementType();
  int64_t elementBytes = elementType.getIntOrFloatBitWidth() / 8;
  PtrType pointerType =
      PtrType::get(op.getContext(), elementType,
                   SharedAddressSpaceAttr::get(op.getContext()));
  Value allocation = AllocOp::create(rewriter, op.getLoc(), pointerType,
                                     static_cast<uint64_t>(*scratchBytes),
                                     static_cast<uint64_t>(elementBytes));
  RelationMaterializer materializer(rewriter, op, store, domain);
  SmallVector<Value> source = extractComponents(rewriter, op);

  FailureOr<sym::ExprHandle> storeAddress = composeAddress(
      store, domain.item, domain.slot, sourcePacket.getNumElements());
  if (failed(storeAddress))
    return op.emitOpError("failed to construct scratch store address");
  Type tokenType = MemTokenType::get(op.getContext());
  FailureOr<Value> published = emitScratchStores(
      rewriter, op, materializer, allocation, source, *storeAddress, tokenType);
  if (failed(published))
    return failure();
  FailureOr<sym::ExprHandle> loadAddress = composeAddress(
      store, op.getRelation().getSourceItem(), op.getRelation().getSourceSlot(),
      sourcePacket.getNumElements());
  if (failed(loadAddress))
    return op.emitOpError("failed to construct scratch load address");

  int64_t resultSlots =
      getPacketType(op.getResult().getType()).getNumElements();
  Type componentType = getPacketElementType(op.getSource().getType());
  FailureOr<ScratchLoads> loaded =
      emitScratchLoads(rewriter, op, materializer, allocation, *loadAddress,
                       resultSlots, componentType, tokenType, *published);
  if (failed(loaded))
    return failure();

  Value packed = PackOp::create(rewriter, op.getLoc(), op.getResult().getType(),
                                loaded->values);
  Value released =
      BarrierOp::create(rewriter, op.getLoc(), tokenType, loaded->tokens);
  AllocReleaseOp::create(rewriter, op.getLoc(), tokenType, allocation,
                         released);
  rewriter.replaceOp(op, packed);
  return success();
}

static bool canCompose(RedistributeOp previous, RedistributeOp op) {
  return previous->getBlock() == op->getBlock() &&
         previous.getResult().hasOneUse() &&
         previous.getRelation().getItems() == op.getRelation().getItems();
}

static LogicalResult composeOne(RedistributeOp previous, RedistributeOp op,
                                sym::Store &store) {
  FailureOr<sym::ExprHandle> item = sym::composeExprSym(store, "item");
  FailureOr<sym::ExprHandle> slot = sym::composeExprSym(store, "slot");
  if (failed(item) || failed(slot))
    return op.emitOpError("failed to construct composition symbols");
  std::array<sym::ExprSubstitution, 2> substitutions{
      sym::ExprSubstitution{*item, op.getRelation().getSourceItem()},
      sym::ExprSubstitution{*slot, op.getRelation().getSourceSlot()}};
  FailureOr<sym::ExprHandle> sourceItem = sym::substituteExpr(
      store, previous.getRelation().getSourceItem(), substitutions);
  FailureOr<sym::ExprHandle> sourceSlot = sym::substituteExpr(
      store, previous.getRelation().getSourceSlot(), substitutions);
  if (failed(sourceItem) || failed(sourceSlot))
    return op.emitOpError("failed to compose redistribution relations");
  sourceItem = sym::simplifyExpr(store, *sourceItem);
  sourceSlot = sym::simplifyExpr(store, *sourceSlot);
  if (failed(sourceItem) || failed(sourceSlot))
    return op.emitOpError("failed to simplify composed redistribution");

  RedistributionAttr relation = RedistributionAttr::get(
      op.getContext(), op.getRelation().getItems(), *sourceItem, *sourceSlot);
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
                                         func::FuncOp func) {
  rewriter.setInsertionPoint(op);
  FailureOr<RelationDomain> domain = buildDomain(dialect.getSymbolStore(), op);
  if (failed(domain))
    return op.emitOpError("failed to construct redistribution domain");
  int64_t width = cast<SimdType>(op.getSource().getType()).getWidth();
  FailureOr<Movement> movement =
      classifyMovement(dialect.getSymbolStore(), op, *domain, width);
  if (failed(movement))
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
    return lowerWorkgroup(rewriter, op, dialect.getSymbolStore(), *domain,
                          func);
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

  for (RedistributeOp op : ops) {
    if (erased.contains(op.getOperation()))
      continue;
    if (failed(lowerRedistribution(rewriter, op, dialect, func)))
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
