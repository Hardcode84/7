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

#include <optional>

namespace mlir::wave {
#define GEN_PASS_DEF_WAVECOALESCEMEMORY
#include "mlir/Dialect/Wave/Transforms/Passes.h.inc"
} // namespace mlir::wave

using namespace mlir;
using namespace mlir::wave;

namespace {

struct StoreGroup {
  SmallVector<StoreOp> stores;
  SmallVector<Value> lanes;
  MemoryAddress address;
  Value accessPtr;
  Type scalarElementType;
  StoreOp firstOp;
  StoreOp lastOp;
  int64_t simdWidth = 0;
  unsigned spanElements = 0;
};

static std::optional<PtrType> getPointerType(Type type) {
  if (PtrType ptrType = dyn_cast<PtrType>(type))
    return ptrType;
  SimdType simdType = dyn_cast<SimdType>(type);
  if (!simdType)
    return std::nullopt;
  if (PtrType ptrType = dyn_cast<PtrType>(simdType.getElementType()))
    return ptrType;
  return std::nullopt;
}

static std::optional<unsigned> getPointerElementBits(Type type) {
  std::optional<PtrType> ptrType = getPointerType(type);
  if (!ptrType || !ptrType->getElementType().isIntOrFloat())
    return std::nullopt;
  return ptrType->getElementType().getIntOrFloatBitWidth();
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

static bool tokenUsedOnlyBy(Value token, StoreOp op) {
  if (!token.hasOneUse())
    return false;
  return token.use_begin()->getOwner() == op.getOperation() &&
         op.getDependency() == token;
}

static std::optional<Type> getScalarStoreElementType(StoreOp op) {
  if (!op->getAttrs().empty())
    return std::nullopt;

  SimdType simdType = dyn_cast<SimdType>(op.getValue().getType());
  if (!simdType)
    return std::nullopt;
  Type scalarElementType = simdType.getElementType();
  if (isa<VectorType>(scalarElementType) || !scalarElementType.isIntOrFloat())
    return std::nullopt;
  return scalarElementType;
}

static FailureOr<std::optional<unsigned>>
getStoreSpanElements(StoreOp op, Type scalarElementType) {
  std::optional<unsigned> ptrBits =
      getPointerElementBits(op.getPtr().getType());
  if (!ptrBits || *ptrBits == 0)
    return std::optional<unsigned>{};

  FailureOr<MemoryPayloadShape> shape = getMemoryPayloadShape(
      scalarElementType, [&](const Twine &msg) { return op.emitOpError(msg); });
  if (failed(shape))
    return failure();
  if (shape->payloadBits % *ptrBits != 0)
    return std::optional<unsigned>{};
  return std::optional<unsigned>{shape->payloadBits / *ptrBits};
}

static FailureOr<std::optional<StoreGroup>> getStoreSeed(StoreOp op,
                                                         WaveDialect &dialect) {
  std::optional<Type> scalarElementType = getScalarStoreElementType(op);
  if (!scalarElementType)
    return std::optional<StoreGroup>{};
  FailureOr<std::optional<unsigned>> spanElements =
      getStoreSpanElements(op, *scalarElementType);
  if (failed(spanElements))
    return failure();
  if (!*spanElements)
    return std::optional<StoreGroup>{};
  FailureOr<std::optional<MemoryAddress>> address =
      normalizeMemoryAddress(op.getPtr(), dialect);
  if (failed(address))
    return op.emitOpError("failed to normalize store address");
  if (!*address)
    return std::optional<StoreGroup>{};

  StoreGroup group;
  group.stores.push_back(op);
  group.lanes.push_back(op.getValue());
  group.address = std::move(**address);
  group.accessPtr = op.getPtr();
  group.scalarElementType = *scalarElementType;
  group.firstOp = op;
  group.lastOp = op;
  group.simdWidth = cast<SimdType>(op.getValue().getType()).getWidth();
  group.spanElements = **spanElements;
  return std::optional<StoreGroup>{std::move(group)};
}

static bool compatibleStoreGroups(const StoreGroup &lhs,
                                  const StoreGroup &rhs) {
  return lhs.scalarElementType == rhs.scalarElementType &&
         lhs.simdWidth == rhs.simdWidth && lhs.address.base == rhs.address.base;
}

static bool mergeableStoreGroupWidth(const StoreGroup &lhs,
                                     const StoreGroup &rhs) {
  return lhs.lanes.size() == rhs.lanes.size() &&
         lhs.spanElements == rhs.spanElements;
}

static void appendAddressOrderedLanes(SmallVectorImpl<Value> &dst,
                                      const StoreGroup &group) {
  dst.append(group.lanes);
}

static std::optional<std::pair<const StoreGroup *, const StoreGroup *>>
getTokenOrderedGroups(const StoreGroup &lhs, const StoreGroup &rhs) {
  StoreOp lhsLast = lhs.lastOp;
  StoreOp rhsFirst = rhs.firstOp;
  StoreOp rhsLast = rhs.lastOp;
  StoreOp lhsFirst = lhs.firstOp;
  if (lhsLast->isBeforeInBlock(rhsFirst))
    return std::make_pair(&lhs, &rhs);
  if (rhsLast->isBeforeInBlock(lhsFirst))
    return std::make_pair(&rhs, &lhs);
  return std::nullopt;
}

static FailureOr<std::optional<StoreGroup>>
tryMergeStoreGroups(WaveDialect &dialect, const StoreGroup &lhs,
                    const StoreGroup &rhs) {
  if (!compatibleStoreGroups(lhs, rhs) || !mergeableStoreGroupWidth(lhs, rhs))
    return std::optional<StoreGroup>{};
  std::optional<std::pair<const StoreGroup *, const StoreGroup *>> ordered =
      getTokenOrderedGroups(lhs, rhs);
  if (!ordered)
    return std::optional<StoreGroup>{};
  StoreOp earlierLast = ordered->first->lastOp;
  StoreOp laterFirst = ordered->second->firstOp;
  if (!tokenUsedOnlyBy(earlierLast.getToken(), laterFirst))
    return std::optional<StoreGroup>{};

  FailureOr<std::optional<int64_t>> delta =
      computeConstantMemoryAddressDelta(dialect, rhs.address, lhs.address);
  if (failed(delta))
    return failure();
  if (!*delta)
    return std::optional<StoreGroup>{};

  const StoreGroup *lo = nullptr;
  const StoreGroup *hi = nullptr;
  if (**delta == static_cast<int64_t>(lhs.spanElements)) {
    lo = &lhs;
    hi = &rhs;
  } else if (**delta == -static_cast<int64_t>(rhs.spanElements)) {
    lo = &rhs;
    hi = &lhs;
  } else {
    return std::optional<StoreGroup>{};
  }

  StoreGroup merged;
  merged.stores.append(ordered->first->stores.begin(),
                       ordered->first->stores.end());
  merged.stores.append(ordered->second->stores.begin(),
                       ordered->second->stores.end());
  appendAddressOrderedLanes(merged.lanes, *lo);
  appendAddressOrderedLanes(merged.lanes, *hi);
  merged.address = lo->address;
  merged.accessPtr = lo->accessPtr;
  merged.scalarElementType = lhs.scalarElementType;
  merged.firstOp = ordered->first->firstOp;
  merged.lastOp = ordered->second->lastOp;
  merged.simdWidth = lhs.simdWidth;
  merged.spanElements = lhs.spanElements + rhs.spanElements;
  return std::optional<StoreGroup>{std::move(merged)};
}

static FailureOr<SmallVector<StoreGroup, 8>>
mergeStorePartition(WaveDialect &dialect, SmallVector<StoreGroup, 8> groups) {
  bool changed = true;
  while (changed) {
    changed = false;
    for (unsigned idx : llvm::seq<unsigned>(0, groups.size())) {
      for (unsigned other : llvm::seq<unsigned>(idx + 1, groups.size())) {
        FailureOr<std::optional<StoreGroup>> merged =
            tryMergeStoreGroups(dialect, groups[idx], groups[other]);
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

static LogicalResult mergeStoreSegment(WaveDialect &dialect,
                                       ArrayRef<StoreGroup> segment,
                                       SmallVectorImpl<StoreGroup> &rewrites) {
  if (segment.size() < 2)
    return success();
  SmallVector<SmallVector<StoreGroup, 8>, 8> partitions;
  for (const StoreGroup &group : segment) {
    auto partition = llvm::find_if(partitions, [&](ArrayRef<StoreGroup> part) {
      return compatibleStoreGroups(part.front(), group);
    });
    if (partition == partitions.end()) {
      partitions.push_back({group});
      continue;
    }
    partition->push_back(group);
  }

  for (SmallVector<StoreGroup, 8> &partition : partitions) {
    FailureOr<SmallVector<StoreGroup, 8>> merged =
        mergeStorePartition(dialect, std::move(partition));
    if (failed(merged))
      return failure();
    for (StoreGroup &group : *merged)
      if (group.stores.size() > 1)
        rewrites.push_back(std::move(group));
  }
  return success();
}

static Type getPackedStoreType(MLIRContext *ctx, const StoreGroup &group) {
  auto vectorType = VectorType::get({static_cast<int64_t>(group.lanes.size())},
                                    group.scalarElementType);
  return SimdType::get(ctx, vectorType, group.simdWidth);
}

static void rewriteStoreGroup(IRRewriter &rewriter, StoreGroup &group) {
  StoreOp last = group.lastOp;
  MLIRContext *ctx = last->getContext();
  Type packedType = getPackedStoreType(ctx, group);
  rewriter.setInsertionPoint(last);
  PackOp pack = PackOp::create(rewriter, last.getLoc(), packedType,
                               ValueRange(group.lanes));
  StoreOp store = StoreOp::create(
      rewriter, last.getLoc(), last.getToken().getType(), pack.getResult(),
      group.accessPtr, group.firstOp.getDependency());
  rewriter.replaceAllUsesWith(last.getToken(), store.getToken());
  for (StoreOp op : llvm::reverse(group.stores))
    rewriter.eraseOp(op);
}

static LogicalResult
collectBlockRewrites(Block &block, WaveDialect &dialect,
                     SmallVectorImpl<StoreGroup> &rewrites) {
  SmallVector<StoreGroup, 8> segment;
  auto flush = [&]() -> LogicalResult {
    LogicalResult result = mergeStoreSegment(dialect, segment, rewrites);
    segment.clear();
    return result;
  };

  for (Operation &op : block) {
    if (StoreOp store = dyn_cast<StoreOp>(&op)) {
      FailureOr<std::optional<StoreGroup>> seed = getStoreSeed(store, dialect);
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
  SmallVector<StoreGroup, 8> rewrites;
  if (failed(collectBlockRewrites(block, dialect, rewrites)))
    return failure();
  for (StoreGroup &group : llvm::reverse(rewrites)) {
    rewriteStoreGroup(rewriter, group);
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
