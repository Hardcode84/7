//===- WaveCoalesceMemory.cpp - Wave memory coalescing ----------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/Wave/Transforms/Passes.h"

#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/Wave/IR/Wave.h"
#include "mlir/IR/Builders.h"
#include "mlir/IR/PatternMatch.h"
#include "mlir/Interfaces/SideEffectInterfaces.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/ADT/StringRef.h"

#include <optional>

namespace mlir::wave {
#define GEN_PASS_DEF_WAVECOALESCEMEMORY
#include "mlir/Dialect/Wave/Transforms/Passes.h.inc"
} // namespace mlir::wave

using namespace mlir;
using namespace mlir::wave;

namespace {

static constexpr llvm::StringLiteral kMemoryCacheAttrName = "cache";

enum class MemoryGroupKind { Load, Store };

struct MemoryGroup {
  SmallVector<Operation *> ops;
  SmallVector<Value> payloads;
  MemoryAddress address;
  Value accessPtr;
  Type scalarElementType;
  Attribute cache;
  Operation *firstOp = nullptr;
  Operation *lastOp = nullptr;
  int64_t simdWidth = 0;
  unsigned spanElements = 0;
  MemoryGroupKind kind;
};

struct AddressOrderedGroups {
  const MemoryGroup *lo;
  const MemoryGroup *hi;
};

static std::optional<PtrType> getPointerType(Type type) {
  return getWavePointerType(type);
}

static std::optional<unsigned> getPointerElementBits(Type type) {
  std::optional<PtrType> ptrType = getPointerType(type);
  if (!ptrType)
    return std::nullopt;
  Type elementType = ptrType->getElementType();
  if (!elementType)
    return 8;
  if (!elementType.isIntOrFloat())
    return std::nullopt;
  return elementType.getIntOrFloatBitWidth();
}

static bool hasNoEffects(Operation *op) {
  if (op->hasTrait<OpTrait::IsTerminator>() || op->getNumRegions() != 0)
    return false;
  MemoryEffectOpInterface iface = dyn_cast<MemoryEffectOpInterface>(op);
  if (!iface)
    return false;
  SmallVector<MemoryEffects::EffectInstance> effects;
  iface.getEffects(effects);
  return effects.empty();
}

static Value getMemoryPtr(Operation *op) {
  if (LoadOp load = dyn_cast<LoadOp>(op))
    return load.getPtr();
  return cast<StoreOp>(op).getPtr();
}

static Value getMemoryPayload(Operation *op) {
  if (LoadOp load = dyn_cast<LoadOp>(op))
    return load.getValue();
  return cast<StoreOp>(op).getValue();
}

static Value getMemoryDependency(Operation *op) {
  if (LoadOp load = dyn_cast<LoadOp>(op))
    return load.getDependency();
  return cast<StoreOp>(op).getDependency();
}

static Attribute getMemoryCache(Operation *op) {
  return op->getAttr(kMemoryCacheAttrName);
}

static Value getMemoryToken(Operation *op) {
  if (LoadOp load = dyn_cast<LoadOp>(op))
    return load.getToken();
  return cast<StoreOp>(op).getToken();
}

static MemoryGroupKind getMemoryGroupKind(Operation *op) {
  if (isa<LoadOp>(op))
    return MemoryGroupKind::Load;
  return MemoryGroupKind::Store;
}

static bool tokenUsedOnlyBy(Value token, Operation *op) {
  if (!token.hasOneUse())
    return false;
  return token.use_begin()->getOwner() == op &&
         getMemoryDependency(op) == token;
}

static JoinOp getOnlyJoinUser(Value token) {
  if (!token.hasOneUse())
    return {};
  return dyn_cast<JoinOp>(token.use_begin()->getOwner());
}

static std::optional<JoinOp> getCommonJoinUser(const MemoryGroup &group) {
  JoinOp join;
  for (Operation *op : group.ops) {
    JoinOp tokenJoin = getOnlyJoinUser(getMemoryToken(op));
    if (!tokenJoin)
      return std::nullopt;
    if (!join) {
      join = tokenJoin;
      continue;
    }
    if (join != tokenJoin)
      return std::nullopt;
  }
  if (join->getBlock() != group.firstOp->getBlock())
    return std::nullopt;
  if (!group.lastOp->isBeforeInBlock(join))
    return std::nullopt;
  return join;
}

static bool tokensUsedOnlyBySameJoin(const MemoryGroup &lhs,
                                     const MemoryGroup &rhs) {
  if (getMemoryDependency(lhs.firstOp) != getMemoryDependency(rhs.firstOp))
    return false;

  std::optional<JoinOp> lhsJoin = getCommonJoinUser(lhs);
  if (!lhsJoin)
    return false;
  std::optional<JoinOp> rhsJoin = getCommonJoinUser(rhs);
  return rhsJoin && *lhsJoin == *rhsJoin;
}

static bool tokensMergeable(const MemoryGroup &before,
                            const MemoryGroup &after) {
  if (tokenUsedOnlyBy(getMemoryToken(before.lastOp), after.firstOp))
    return true;
  return tokensUsedOnlyBySameJoin(before, after);
}

static bool valueAvailableBefore(Value value, Operation *op) {
  Operation *def = value.getDefiningOp();
  if (!def)
    return true;
  if (def->getBlock() != op->getBlock())
    return true;
  return def->isBeforeInBlock(op);
}

static bool hasOnlyMergeableAttrs(Operation *op) {
  for (NamedAttribute attr : op->getAttrs())
    if (attr.getName().getValue() != kMemoryCacheAttrName)
      return false;
  return true;
}

static std::optional<Type> getScalarElementType(Operation *op) {
  if (!hasOnlyMergeableAttrs(op))
    return std::nullopt;

  SimdType simdType = dyn_cast<SimdType>(getMemoryPayload(op).getType());
  if (!simdType)
    return std::nullopt;
  Type scalarElementType = simdType.getElementType();
  if (isa<VectorType>(scalarElementType) || !scalarElementType.isIntOrFloat())
    return std::nullopt;
  return scalarElementType;
}

static FailureOr<std::optional<unsigned>>
getSpanElements(Operation *op, Type scalarElementType) {
  std::optional<unsigned> ptrBits =
      getPointerElementBits(getMemoryPtr(op).getType());
  if (!ptrBits || *ptrBits == 0)
    return std::optional<unsigned>{};

  FailureOr<MemoryPayloadShape> shape =
      getMemoryPayloadShape(scalarElementType, [&](const Twine &msg) {
        return op->emitOpError(msg);
      });
  if (failed(shape))
    return failure();
  if (shape->payloadBits % *ptrBits != 0)
    return std::optional<unsigned>{};
  return std::optional<unsigned>{shape->payloadBits / *ptrBits};
}

static FailureOr<std::optional<MemoryGroup>>
getMemorySeed(Operation *op, WaveDialect &dialect) {
  std::optional<Type> scalarElementType = getScalarElementType(op);
  if (!scalarElementType)
    return std::optional<MemoryGroup>{};
  FailureOr<std::optional<unsigned>> spanElements =
      getSpanElements(op, *scalarElementType);
  if (failed(spanElements))
    return failure();
  if (!*spanElements)
    return std::optional<MemoryGroup>{};
  FailureOr<std::optional<MemoryAddress>> address =
      normalizeMemoryAddress(getMemoryPtr(op), dialect);
  if (failed(address))
    return op->emitOpError("failed to normalize memory address");
  if (!*address)
    return std::optional<MemoryGroup>{};

  MemoryGroup group;
  group.ops.push_back(op);
  group.payloads.push_back(getMemoryPayload(op));
  group.address = std::move(**address);
  group.accessPtr = getMemoryPtr(op);
  group.scalarElementType = *scalarElementType;
  group.cache = getMemoryCache(op);
  group.firstOp = op;
  group.lastOp = op;
  group.simdWidth = cast<SimdType>(getMemoryPayload(op).getType()).getWidth();
  group.spanElements = **spanElements;
  group.kind = getMemoryGroupKind(op);
  return std::optional<MemoryGroup>{std::move(group)};
}

static bool compatibleGroups(const MemoryGroup &lhs, const MemoryGroup &rhs) {
  return lhs.kind == rhs.kind &&
         lhs.scalarElementType == rhs.scalarElementType &&
         lhs.simdWidth == rhs.simdWidth &&
         lhs.address.base == rhs.address.base && lhs.cache == rhs.cache;
}

static bool mergeableGroupWidth(const MemoryGroup &lhs,
                                const MemoryGroup &rhs) {
  return lhs.payloads.size() == rhs.payloads.size() &&
         lhs.spanElements == rhs.spanElements;
}

static std::optional<std::pair<const MemoryGroup *, const MemoryGroup *>>
getTokenOrderedGroups(const MemoryGroup &lhs, const MemoryGroup &rhs) {
  if (lhs.lastOp->isBeforeInBlock(rhs.firstOp))
    return std::make_pair(&lhs, &rhs);
  if (rhs.lastOp->isBeforeInBlock(lhs.firstOp))
    return std::make_pair(&rhs, &lhs);
  return std::nullopt;
}

static FailureOr<std::optional<AddressOrderedGroups>>
getAddressOrderedGroups(WaveDialect &dialect, const MemoryGroup &lhs,
                        const MemoryGroup &rhs) {
  FailureOr<std::optional<int64_t>> delta =
      computeConstantMemoryAddressDelta(dialect, rhs.address, lhs.address);
  if (failed(delta))
    return failure();
  if (!*delta)
    return std::optional<AddressOrderedGroups>{};

  if (**delta == static_cast<int64_t>(lhs.spanElements))
    return std::optional<AddressOrderedGroups>{
        AddressOrderedGroups{&lhs, &rhs}};
  if (**delta == -static_cast<int64_t>(rhs.spanElements))
    return std::optional<AddressOrderedGroups>{
        AddressOrderedGroups{&rhs, &lhs}};
  return std::optional<AddressOrderedGroups>{};
}

static MemoryGroup
buildMergedGroup(std::pair<const MemoryGroup *, const MemoryGroup *> ordered,
                 AddressOrderedGroups addressOrdered) {
  MemoryGroup merged;
  merged.ops.append(ordered.first->ops);
  merged.ops.append(ordered.second->ops);
  merged.payloads.append(addressOrdered.lo->payloads);
  merged.payloads.append(addressOrdered.hi->payloads);
  merged.address = addressOrdered.lo->address;
  merged.accessPtr = addressOrdered.lo->accessPtr;
  merged.scalarElementType = ordered.first->scalarElementType;
  merged.cache = ordered.first->cache;
  merged.firstOp = ordered.first->firstOp;
  merged.lastOp = ordered.second->lastOp;
  merged.simdWidth = ordered.first->simdWidth;
  merged.spanElements =
      ordered.first->spanElements + ordered.second->spanElements;
  merged.kind = ordered.first->kind;
  return merged;
}

static FailureOr<std::optional<MemoryGroup>>
tryMergeGroups(WaveDialect &dialect, const MemoryGroup &lhs,
               const MemoryGroup &rhs) {
  if (!compatibleGroups(lhs, rhs) || !mergeableGroupWidth(lhs, rhs))
    return std::optional<MemoryGroup>{};
  std::optional<std::pair<const MemoryGroup *, const MemoryGroup *>> ordered =
      getTokenOrderedGroups(lhs, rhs);
  if (!ordered)
    return std::optional<MemoryGroup>{};
  if (!tokensMergeable(*ordered->first, *ordered->second))
    return std::optional<MemoryGroup>{};

  FailureOr<std::optional<AddressOrderedGroups>> addressOrdered =
      getAddressOrderedGroups(dialect, lhs, rhs);
  if (failed(addressOrdered))
    return failure();
  if (!*addressOrdered)
    return std::optional<MemoryGroup>{};

  const MemoryGroup *lo = (**addressOrdered).lo;
  if (lo->kind == MemoryGroupKind::Load &&
      !valueAvailableBefore(lo->accessPtr, ordered->first->firstOp))
    return std::optional<MemoryGroup>{};
  return std::optional<MemoryGroup>{
      buildMergedGroup(*ordered, **addressOrdered)};
}

static FailureOr<SmallVector<MemoryGroup, 8>>
mergePartition(WaveDialect &dialect, SmallVector<MemoryGroup, 8> groups) {
  bool changed = true;
  while (changed) {
    changed = false;
    for (unsigned idx : llvm::seq<unsigned>(0, groups.size())) {
      for (unsigned other : llvm::seq<unsigned>(idx + 1, groups.size())) {
        FailureOr<std::optional<MemoryGroup>> merged =
            tryMergeGroups(dialect, groups[idx], groups[other]);
        if (failed(merged))
          return failure();
        if (*merged) {
          groups[idx] = std::move(**merged);
          groups.erase(groups.begin() + other);
          changed = true;
          break;
        }
      }
      if (changed)
        break;
    }
  }
  return groups;
}

static LogicalResult mergeSegment(WaveDialect &dialect,
                                  ArrayRef<MemoryGroup> segment,
                                  SmallVectorImpl<MemoryGroup> &rewrites) {
  if (segment.size() < 2)
    return success();

  SmallVector<SmallVector<MemoryGroup, 8>, 8> partitions;
  for (const MemoryGroup &group : segment) {
    SmallVector<SmallVector<MemoryGroup, 8>, 8>::iterator partition =
        llvm::find_if(partitions, [&](ArrayRef<MemoryGroup> part) {
          return compatibleGroups(part.front(), group);
        });
    if (partition == partitions.end()) {
      partitions.push_back({group});
      continue;
    }
    partition->push_back(group);
  }

  for (SmallVector<MemoryGroup, 8> &partition : partitions) {
    FailureOr<SmallVector<MemoryGroup, 8>> merged =
        mergePartition(dialect, std::move(partition));
    if (failed(merged))
      return failure();
    for (MemoryGroup &group : *merged)
      if (group.ops.size() > 1)
        rewrites.push_back(std::move(group));
  }
  return success();
}

static Type getPackedType(MLIRContext *ctx, const MemoryGroup &group) {
  auto vectorType = VectorType::get(
      {static_cast<int64_t>(group.payloads.size())}, group.scalarElementType);
  return SimdType::get(ctx, vectorType, group.simdWidth);
}

static void replaceGroupTokens(IRRewriter &rewriter, const MemoryGroup &group,
                               Value token) {
  for (Operation *op : group.ops)
    rewriter.replaceAllUsesWith(getMemoryToken(op), token);
}

static void rewriteStoreGroup(IRRewriter &rewriter, MemoryGroup &group) {
  StoreOp last = cast<StoreOp>(group.lastOp);
  MLIRContext *ctx = last->getContext();
  Type packedType = getPackedType(ctx, group);
  rewriter.setInsertionPoint(last);
  PackOp pack = PackOp::create(rewriter, last.getLoc(), packedType,
                               ValueRange(group.payloads));
  StoreOp store = StoreOp::create(
      rewriter, last.getLoc(), last.getToken().getType(), pack.getResult(),
      group.accessPtr, getMemoryDependency(group.firstOp), group.cache);
  replaceGroupTokens(rewriter, group, store.getToken());
  for (Operation *op : llvm::reverse(group.ops))
    rewriter.eraseOp(op);
}

static void rewriteLoadGroup(IRRewriter &rewriter, MemoryGroup &group) {
  LoadOp first = cast<LoadOp>(group.firstOp);
  MLIRContext *ctx = first->getContext();
  Type packedType = getPackedType(ctx, group);
  rewriter.setInsertionPoint(first);
  LoadOp load = LoadOp::create(rewriter, first.getLoc(), packedType,
                               first.getToken().getType(), group.accessPtr,
                               getMemoryDependency(group.firstOp), group.cache);

  rewriter.setInsertionPointAfter(load);
  for (auto [idx, oldValue] : llvm::enumerate(group.payloads)) {
    Value extracted = ExtractOp::create(
        rewriter, first.getLoc(), oldValue.getType(), load.getValue(),
        rewriter.getI64IntegerAttr(static_cast<int64_t>(idx)));
    rewriter.replaceAllUsesWith(oldValue, extracted);
  }
  replaceGroupTokens(rewriter, group, load.getToken());
  for (Operation *op : llvm::reverse(group.ops))
    rewriter.eraseOp(op);
}

static LogicalResult
collectBlockRewrites(Block &block, WaveDialect &dialect,
                     SmallVectorImpl<MemoryGroup> &rewrites) {
  SmallVector<MemoryGroup, 8> segment;
  auto flush = [&]() -> LogicalResult {
    LogicalResult result = mergeSegment(dialect, segment, rewrites);
    segment.clear();
    return result;
  };

  for (Operation &op : block) {
    // Tokens define memory order; unchained opposite-kind ops keep segment
    // open.
    if (isa<LoadOp, StoreOp>(&op)) {
      FailureOr<std::optional<MemoryGroup>> seed = getMemorySeed(&op, dialect);
      if (failed(seed))
        return failure();
      if (!*seed) {
        if (failed(flush()))
          return failure();
        continue;
      }
      segment.push_back(std::move(**seed));
      continue;
    }

    if (!hasNoEffects(&op) && failed(flush()))
      return failure();
  }
  return flush();
}

static LogicalResult coalesceBlock(Block &block, WaveDialect &dialect,
                                   IRRewriter &rewriter, bool &changed) {
  SmallVector<MemoryGroup, 8> rewrites;
  if (failed(collectBlockRewrites(block, dialect, rewrites)))
    return failure();
  for (MemoryGroup &group : llvm::reverse(rewrites)) {
    if (group.kind != MemoryGroupKind::Store)
      continue;
    rewriteStoreGroup(rewriter, group);
    changed = true;
  }
  for (MemoryGroup &group : llvm::reverse(rewrites)) {
    if (group.kind != MemoryGroupKind::Load)
      continue;
    rewriteLoadGroup(rewriter, group);
    changed = true;
  }
  return success();
}

static LogicalResult coalesceRegion(Region &region, WaveDialect &dialect,
                                    IRRewriter &rewriter, bool &changed) {
  for (Block &block : region) {
    if (failed(coalesceBlock(block, dialect, rewriter, changed)))
      return failure();
    for (Operation &op : llvm::make_early_inc_range(block))
      for (Region &nested : op.getRegions())
        if (failed(coalesceRegion(nested, dialect, rewriter, changed)))
          return failure();
  }
  return success();
}

struct WaveCoalesceMemoryPass
    : public wave::impl::WaveCoalesceMemoryBase<WaveCoalesceMemoryPass> {
  void runOnOperation() override {
    WaveDialect *dialect = getContext().getLoadedDialect<WaveDialect>();
    if (!dialect) {
      getOperation()->emitError("Wave dialect is not loaded");
      return signalPassFailure();
    }

    IRRewriter rewriter(&getContext());
    bool changed = false;
    for (Region &region : getOperation()->getRegions())
      if (failed(coalesceRegion(region, *dialect, rewriter, changed)))
        return signalPassFailure();
  }
};

} // namespace
