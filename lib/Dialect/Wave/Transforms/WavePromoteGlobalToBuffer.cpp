//===- WavePromoteGlobalToBuffer.cpp - form buffer pointers -----*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/Wave/Transforms/Passes.h"
#include "mlir/Dialect/Wave/Transforms/SymbolicValue.h"

#include "../IR/WaveIndexExpr.h"
#include "mlir/Analysis/DataFlow/IntegerRangeAnalysis.h"
#include "mlir/Analysis/DataFlow/Utils.h"
#include "mlir/Analysis/DataFlowFramework.h"
#include "mlir/Dialect/Arith/IR/Arith.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/Utils/StaticValueUtils.h"
#include "mlir/Dialect/Wave/IR/Wave.h"
#include "mlir/Dialect/Wave/IR/WaveAMD.h"
#include "mlir/Dialect/Wave/IR/WaveSymbols.h"
#include "mlir/IR/PatternMatch.h"
#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/DenseSet.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/ADT/StringMap.h"
#include "llvm/Support/CheckedArithmetic.h"

#include <cstdint>
#include <memory>
#include <optional>
#include <string>

namespace mlir::wave {
#define GEN_PASS_DEF_WAVEPROMOTEGLOBALTOBUFFER
#include "mlir/Dialect/Wave/Transforms/Passes.h.inc"
} // namespace mlir::wave

using namespace mlir;
using namespace mlir::wave;

namespace {

// Unsigned descriptor range covers nonnegative signed-i32 byte offsets.
static constexpr int64_t kBufferRangeBytes = int64_t{1} << 31;

struct ByteOffsetPacket {
  SmallVector<sym::PredHandle, 4> assumptions;
  sym::ExprHandle expr;
};

static std::optional<PtrType> getPointerType(Type type) {
  if (auto simd = dyn_cast<SimdType>(type))
    type = simd.getElementType();
  if (auto ptr = dyn_cast<PtrType>(type))
    return ptr;
  return std::nullopt;
}

static bool isGlobalPointerLike(Type type) {
  std::optional<PtrType> ptr = getPointerType(type);
  return ptr && isa<GlobalAddressSpaceAttr>(ptr->getAddressSpace());
}

static bool isUniformGlobalPointer(Type type) {
  auto ptr = dyn_cast<PtrType>(type);
  return ptr && isa<GlobalAddressSpaceAttr>(ptr.getAddressSpace());
}

static Type getBufferPointerLikeType(Type type) {
  MLIRContext *ctx = type.getContext();
  auto toBuffer = [&](PtrType ptr) {
    return PtrType::get(ctx, ptr.getElementType(),
                        waveamd::BufferAddressSpaceAttr::get(ctx));
  };
  if (auto simd = dyn_cast<SimdType>(type)) {
    auto ptr = cast<PtrType>(simd.getElementType());
    return SimdType::get(ctx, toBuffer(ptr), simd.getWidth());
  }
  return toBuffer(cast<PtrType>(type));
}

static std::optional<int64_t> getPointerElementBytes(Type type) {
  std::optional<PtrType> ptr = getPointerType(type);
  if (!ptr)
    return std::nullopt;
  Type elementType = ptr->getElementType();
  if (!elementType)
    return int64_t{1};
  int64_t bits = 0;
  if (auto vectorType = dyn_cast<VectorType>(elementType)) {
    Type scalarType = vectorType.getElementType();
    if (!scalarType.isIntOrFloat())
      return std::nullopt;
    std::optional<int64_t> product = llvm::checkedMul(
        vectorType.getNumElements(),
        static_cast<int64_t>(scalarType.getIntOrFloatBitWidth()));
    if (!product)
      return std::nullopt;
    bits = *product;
  } else {
    if (!elementType.isIntOrFloat())
      return std::nullopt;
    bits = elementType.getIntOrFloatBitWidth();
  }
  if (bits % 8 != 0)
    return std::nullopt;
  return bits / 8;
}

static FailureOr<sym::ExprHandle>
scaleExpr(sym::Store &store, sym::ExprHandle expr, int64_t scale) {
  if (!expr || scale == 1)
    return expr;
  FailureOr<sym::ExprHandle> scaleExpr = sym::composeExprInt(store, scale);
  if (failed(scaleExpr))
    return failure();
  return sym::composeExprBinary(store, expr, sym::ExprBinaryOp::Mul,
                                *scaleExpr);
}

static bool isIndexExprBindingType(Type type) {
  if (type.isIndex())
    return true;
  if (auto integer = dyn_cast<IntegerType>(type))
    return integer.isSignless();
  auto simd = dyn_cast<SimdType>(type);
  return simd && (simd.getElementType().isIndex() ||
                  simd.getElementType().isInteger(32));
}

static std::optional<std::pair<int64_t, int64_t>>
getFiniteSignedRange(DataFlowSolver &solver, Value value) {
  const dataflow::IntegerValueRangeLattice *lattice =
      solver.lookupState<dataflow::IntegerValueRangeLattice>(value);
  if (!lattice)
    return std::nullopt;
  IntegerValueRange valueRange = lattice->getValue();
  if (valueRange.isUninitialized())
    return std::nullopt;
  ConstantIntRanges range = valueRange.getValue();
  unsigned width = range.smin().getBitWidth();
  if (width == 0 || !range.smin().isSignedIntN(64) ||
      !range.smax().isSignedIntN(64))
    return std::nullopt;
  if (range.smin() == APInt::getSignedMinValue(width) &&
      range.smax() == APInt::getSignedMaxValue(width))
    return std::nullopt;
  return std::pair<int64_t, int64_t>{range.smin().getSExtValue(),
                                     range.smax().getSExtValue()};
}

static LogicalResult appendAnalyzedBindingRanges(sym::Store &store,
                                                 DataFlowSolver &solver,
                                                 SymbolicOffset &offset) {
  for (const SymbolicOffsetBinding &binding : offset.bindings) {
    std::optional<std::pair<int64_t, int64_t>> range =
        getFiniteSignedRange(solver, binding.value);
    if (!range)
      continue;
    StringRef name = sym::ExprView(binding.name).getSymbolName();
    FailureOr<sym::PredHandle> assumption =
        sym::rangeAssumption(store, name, range->first, range->second);
    if (failed(assumption))
      return failure();
    if (!llvm::is_contained(offset.assumptions, *assumption))
      offset.assumptions.push_back(*assumption);
  }
  return success();
}

static std::optional<SymbolicOffset>
getSerializableSymbolicOffset(const SymbolicOffset &offset) {
  llvm::DenseSet<StringRef> requiredSymbols;
  collectIndexExprRequiredSymbols(offset.expr, offset.assumptions,
                                  requiredSymbols);

  SymbolicOffset serializable;
  serializable.expr = offset.expr;
  serializable.laneWidth = offset.laneWidth;
  serializable.assumptions =
      filterIndexExprPredicatesBySymbols(offset.assumptions, requiredSymbols);
  if (llvm::any_of(serializable.assumptions, [](sym::PredHandle predicate) {
        return sym::PredView(predicate).getKind() == sym::PredKind::False;
      }))
    return std::nullopt;

  llvm::StringMap<Value> byName;
  for (const SymbolicOffsetBinding &binding : offset.bindings) {
    StringRef name = sym::ExprView(binding.name).getSymbolName();
    auto [it, inserted] = byName.try_emplace(name, binding.value);
    assert(inserted || it->second == binding.value);
    if (!inserted || !requiredSymbols.contains(name))
      continue;
    if (!isIndexExprBindingType(binding.value.getType()))
      return std::nullopt;
    serializable.bindings.push_back(binding);
  }
  assert(llvm::all_of(requiredSymbols,
                      [&](StringRef name) { return byName.contains(name); }));
  return serializable;
}

static FailureOr<Value> materializeIndexExpr(Operation *diagOp, Location loc,
                                             const SymbolicOffset &offset,
                                             IRRewriter &rewriter) {
  llvm::DenseSet<StringRef> requiredSymbols;
  collectIndexExprRequiredSymbols(offset.expr, offset.assumptions,
                                  requiredSymbols);

  SmallVector<StringRef> names;
  SmallVector<Value> bindings;
  llvm::StringMap<Value> byName;
  auto appendBinding = [&](const SymbolicOffsetBinding &binding) {
    StringRef name = sym::ExprView(binding.name).getSymbolName();
    if (name.empty())
      return failure();
    auto [it, inserted] = byName.try_emplace(name, binding.value);
    if (!inserted)
      return success(it->second == binding.value);
    if (!requiredSymbols.contains(name))
      return success();
    names.push_back(name);
    bindings.push_back(binding.value);
    return success();
  };
  for (const SymbolicOffsetBinding &binding : offset.bindings)
    if (failed(appendBinding(binding)))
      return diagOp->emitError(
          "symbolic offset binding namespace is inconsistent");

  MLIRContext *ctx = rewriter.getContext();
  SmallVector<sym::PredHandle> assumptions =
      filterIndexExprPredicatesBySymbols(offset.assumptions, requiredSymbols);
  Type resultType = getIndexExprResultType(ctx, bindings);
  Type targetType = getSymbolicOffsetResultType(ctx, offset.laneWidth);
  auto targetSimd = dyn_cast<SimdType>(targetType);
  bool needsSplat = targetSimd && targetSimd.getElementType() == resultType;
  if (resultType != targetType && !needsSplat)
    return diagOp->emitError(
        "promoted pointer offset changed symbolic lane shape");

  IndexExprOp index = IndexExprOp::create(
      rewriter, loc, resultType, ExprAttr::get(ctx, offset.expr),
      getIndexExprPredArrayAttr(ctx, assumptions),
      rewriter.getStrArrayAttr(names), bindings);
  if (resultType == targetType)
    return index.getResult();
  return SplatOp::create(rewriter, loc, targetType, index.getResult())
      .getResult();
}

static bool isWideScalarInteger(Type type) {
  auto intType = dyn_cast<IntegerType>(type);
  return intType && intType.isSignless() && intType.getWidth() > 32;
}

static FailureOr<bool> isMaterializableBufferBaseOffset(Value value) {
  if (isWideScalarInteger(value.getType()))
    return false;
  if (auto indexExpr = value.getDefiningOp<IndexExprOp>()) {
    FailureOr<SymbolicOffset> symbolic = getIndexExprSymbolicOffset(indexExpr);
    if (failed(symbolic))
      return failure();
    // Descriptor-base formation is a target materialization decision, not a
    // byte-range proof.  Uniform IndexExpr offsets are legal scalar address
    // arithmetic as long as every scalar leaf fits that target path.
    return llvm::none_of(symbolic->bindings,
                         [](const SymbolicOffsetBinding &binding) {
                           return isWideScalarInteger(binding.value.getType());
                         });
  }
  return true;
}

static FailureOr<bool> isMaterializableBufferBase(Value ptr) {
  if (!isUniformGlobalPointer(ptr.getType()))
    return false;
  if (auto cast = ptr.getDefiningOp<PtrCastOp>())
    return isMaterializableBufferBase(cast.getSource());
  if (auto add = ptr.getDefiningOp<PtrAddOp>()) {
    FailureOr<bool> base = isMaterializableBufferBase(add.getBase());
    if (failed(base) || !*base)
      return base;
    return isMaterializableBufferBaseOffset(add.getOffset());
  }
  return true;
}

static LogicalResult appendPacket(sym::Store &store, ByteOffsetPacket &dst,
                                  const ByteOffsetPacket &src) {
  llvm::append_range(dst.assumptions, src.assumptions);
  if (!src.expr)
    return success();
  if (!dst.expr) {
    dst.expr = src.expr;
    return success();
  }
  FailureOr<sym::ExprHandle> sum =
      sym::composeExprBinary(store, dst.expr, sym::ExprBinaryOp::Add, src.expr);
  if (failed(sum))
    return failure();
  dst.expr = *sum;
  return success();
}

static FailureOr<int64_t> payloadBytes(Operation *op, Type elementType) {
  FailureOr<MemoryPayloadShape> shape = getMemoryPayloadShape(
      elementType, [&](const Twine &msg) { return op->emitError(msg); });
  if (failed(shape))
    return failure();
  if (shape->payloadBits % 8 != 0)
    return op->emitError("memory payload must be byte-aligned");
  return shape->payloadBits / 8;
}

static FailureOr<int64_t> accessBytes(LoadOp op) {
  SimdType simd = cast<SimdType>(op.getValue().getType());
  return payloadBytes(op.getOperation(), simd.getElementType());
}

static FailureOr<int64_t> accessBytes(StoreOp op) {
  SimdType simd = cast<SimdType>(op.getValue().getType());
  return payloadBytes(op.getOperation(), simd.getElementType());
}

class GlobalToBufferPromoter {
public:
  GlobalToBufferPromoter(func::FuncOp func, IRRewriter &rewriter,
                         WaveDialect &dialect, DataFlowSolver &rangeSolver)
      : func(func), rewriter(rewriter), dialect(dialect),
        store(dialect.getSymbolStore()), rangeSolver(rangeSolver) {}

  LogicalResult run() {
    bool changed = false;
    WalkResult walkResult = func.walk([&](Operation *op) -> WalkResult {
      FailureOr<bool> promoted = false;
      if (auto load = dyn_cast<LoadOp>(op)) {
        FailureOr<int64_t> bytes = accessBytes(load);
        if (failed(bytes))
          return WalkResult::interrupt();
        promoted =
            promoteOperand(load, load.getPtr(), /*operandIndex=*/0, *bytes);
      } else if (auto store = dyn_cast<StoreOp>(op)) {
        FailureOr<int64_t> bytes = accessBytes(store);
        if (failed(bytes))
          return WalkResult::interrupt();
        promoted =
            promoteOperand(store, store.getPtr(), /*operandIndex=*/1, *bytes);
      } else if (auto dma = dyn_cast<waveamd::DmaLoadLdsOp>(op)) {
        promoted = promoteOperand(dma, dma.getSource(), /*operandIndex=*/0,
                                  dma.getBytes());
      }
      if (failed(promoted)) {
        op->emitError(
            "failed to construct or analyze global-to-buffer offset packet");
        return WalkResult::interrupt();
      }
      changed |= *promoted;
      return WalkResult::advance();
    });
    if (walkResult.wasInterrupted())
      return failure();
    if (changed)
      eraseDeadPointerOps();
    return success();
  }

private:
  FailureOr<bool> promoteOperand(Operation *op, Value ptr,
                                 unsigned operandIndex, int64_t bytes) {
    if (!isGlobalPointerLike(ptr.getType()))
      return false;
    FailureOr<std::optional<ByteOffsetPacket>> packet =
        buildByteOffsetPacket(ptr);
    if (failed(packet))
      return failure();
    if (!*packet)
      return false;
    FailureOr<bool> fits = packetFitsBuffer(**packet, bytes);
    if (failed(fits))
      return failure();
    if (!*fits)
      return false;

    OpBuilder::InsertionGuard guard(rewriter);
    rewriter.setInsertionPoint(op);
    FailureOr<Value> promoted = materializePromotedPointer(ptr);
    if (failed(promoted))
      return failure();
    op->setOperand(operandIndex, *promoted);
    return true;
  }

  void eraseDeadPointerOps() {
    bool changed = false;
    do {
      changed = false;
      SmallVector<Operation *> dead;
      func.walk([&](Operation *op) {
        if (isa<PtrAddOp, PtrCastOp>(op) && op->use_empty())
          dead.push_back(op);
      });
      for (Operation *op : llvm::reverse(dead)) {
        if (!op->use_empty())
          continue;
        op->erase();
        changed = true;
      }
    } while (changed);
  }

  static FailureOr<bool> checkProven(sym::Analysis &analysis,
                                     sym::PredHandle predicate) {
    FailureOr<sym::CheckResult> checked = analysis.check(predicate);
    if (failed(checked))
      return failure();
    return *checked == sym::CheckResult::True;
  }

  static FailureOr<std::array<sym::PredHandle, 2>>
  buildBufferBounds(sym::Analysis &analysis, sym::ExprHandle expression,
                    int64_t bytes) {
    FailureOr<sym::ExprHandle> zero = analysis.composeInteger(0);
    FailureOr<sym::ExprHandle> upper =
        analysis.composeInteger(kBufferRangeBytes - bytes);
    if (failed(zero) || failed(upper))
      return failure();
    FailureOr<sym::PredHandle> lowerBound =
        analysis.compare(expression, sym::PredCmpOp::Ge, *zero);
    FailureOr<sym::PredHandle> upperBound =
        analysis.compare(expression, sym::PredCmpOp::Le, *upper);
    if (failed(lowerBound) || failed(upperBound))
      return failure();
    return std::array<sym::PredHandle, 2>{*lowerBound, *upperBound};
  }

  FailureOr<bool> packetFitsBuffer(const ByteOffsetPacket &packet,
                                   int64_t bytes) {
    if (bytes <= 0 || bytes > kBufferRangeBytes)
      return false;
    if (!packet.expr)
      return true;
    FailureOr<std::unique_ptr<sym::Analysis>> analysis =
        createClosedIndexExprAnalysis(store, packet.assumptions);
    if (failed(analysis))
      return failure();
    FailureOr<std::array<sym::PredHandle, 2>> bounds =
        buildBufferBounds(**analysis, packet.expr, bytes);
    if (failed(bounds))
      return failure();
    FailureOr<bool> lowerChecked = checkProven(**analysis, (*bounds)[0]);
    if (failed(lowerChecked))
      return failure();
    if (!*lowerChecked)
      return false;
    return checkProven(**analysis, (*bounds)[1]);
  }

  FailureOr<std::optional<ByteOffsetPacket>> buildByteOffsetPacket(Value ptr) {
    FailureOr<bool> materializable = isMaterializableBufferBase(ptr);
    if (failed(materializable))
      return failure();
    if (*materializable)
      return std::optional<ByteOffsetPacket>{ByteOffsetPacket{}};
    if (auto cast = ptr.getDefiningOp<PtrCastOp>())
      return buildByteOffsetPacket(cast.getSource());
    auto add = ptr.getDefiningOp<PtrAddOp>();
    if (!add)
      return std::optional<ByteOffsetPacket>{};
    return buildPtrAddByteOffsetPacket(add);
  }

  FailureOr<std::optional<ByteOffsetPacket>>
  buildPtrAddByteOffsetPacket(PtrAddOp add) {
    FailureOr<std::optional<ByteOffsetPacket>> base =
        buildByteOffsetPacket(add.getBase());
    if (failed(base))
      return failure();
    if (!*base)
      return std::optional<ByteOffsetPacket>{};
    std::optional<int64_t> scale =
        getPointerElementBytes(add.getBase().getType());
    if (!scale)
      return std::optional<ByteOffsetPacket>{};
    FailureOr<std::optional<ByteOffsetPacket>> added =
        buildOffsetPacket(add.getOffset(), *scale);
    if (failed(added))
      return failure();
    if (!*added)
      return std::optional<ByteOffsetPacket>{};

    ByteOffsetPacket out = std::move(**base);
    if (failed(appendPacket(store, out, **added)))
      return failure();
    return std::optional<ByteOffsetPacket>{std::move(out)};
  }

  FailureOr<std::optional<ByteOffsetPacket>> buildOffsetPacket(Value value,
                                                               int64_t scale) {
    if (std::optional<int64_t> constant = getSplatOrConstantInt(value))
      return buildConstantOffsetPacket(*constant, scale);

    auto cached = analyzedOffsets.find(value);
    if (cached == analyzedOffsets.end()) {
      FailureOr<std::optional<SymbolicOffset>> symbolic =
          buildSymbolicIntegerPacket(value, dialect);
      if (failed(symbolic))
        return failure();
      if (!*symbolic)
        return std::optional<ByteOffsetPacket>{};
      if (failed(appendAnalyzedBindingRanges(store, rangeSolver, **symbolic)))
        return failure();
      std::optional<SymbolicOffset> serializable =
          getSerializableSymbolicOffset(**symbolic);
      if (!serializable)
        return std::optional<ByteOffsetPacket>{};
      bool alreadySerialized = value.getDefiningOp<IndexExprOp>();
      if (auto splat = value.getDefiningOp<SplatOp>())
        alreadySerialized = splat.getSource().getDefiningOp<IndexExprOp>();
      if (!alreadySerialized)
        cached =
            analyzedOffsets.try_emplace(value, std::move(*serializable)).first;
      else
        return buildSymbolicOffsetPacket(*serializable, scale);
    }
    return buildSymbolicOffsetPacket(cached->second, scale);
  }

  FailureOr<std::optional<ByteOffsetPacket>>
  buildConstantOffsetPacket(int64_t constant, int64_t scale) {
    std::optional<int64_t> scaled = llvm::checkedMul(constant, scale);
    if (!scaled)
      return std::optional<ByteOffsetPacket>{};
    FailureOr<sym::ExprHandle> expr = sym::composeExprInt(store, *scaled);
    if (failed(expr))
      return failure();
    ByteOffsetPacket packet;
    packet.expr = *expr;
    return std::optional<ByteOffsetPacket>{std::move(packet)};
  }

  LogicalResult appendIndexExprBindings(
      const SymbolicOffset &symbolic,
      SmallVectorImpl<sym::ExprSubstitution> &substitutions) {
    for (const SymbolicOffsetBinding &binding : symbolic.bindings) {
      if (sym::ExprView(binding.name).getSymbolName().empty())
        return failure();
      std::string name = getFreshIndexExprBindingName(
          "__wave_buffer_idx_", reservedSymbols, nextSymbol);
      FailureOr<sym::ExprHandle> replacement = sym::composeExprSym(store, name);
      if (failed(replacement))
        return failure();
      reservedSymbols[name] = binding.value;
      substitutions.push_back({binding.name, *replacement});
    }
    return success();
  }

  LogicalResult
  appendIndexExprAssumptions(const SymbolicOffset &symbolic,
                             ByteOffsetPacket &packet,
                             ArrayRef<sym::ExprSubstitution> substitutions) {
    for (sym::PredHandle pred : symbolic.assumptions) {
      FailureOr<sym::PredHandle> substituted =
          substitutions.empty()
              ? FailureOr<sym::PredHandle>(pred)
              : sym::substitutePred(store, pred, substitutions);
      if (failed(substituted))
        return failure();
      packet.assumptions.push_back(*substituted);
    }
    return success();
  }

  FailureOr<std::optional<ByteOffsetPacket>>
  buildSymbolicOffsetPacket(const SymbolicOffset &symbolic, int64_t scale) {
    ByteOffsetPacket packet;
    SmallVector<sym::ExprSubstitution, 4> substitutions;
    if (failed(appendIndexExprBindings(symbolic, substitutions)))
      return failure();
    if (failed(appendIndexExprAssumptions(symbolic, packet, substitutions)))
      return failure();
    packet.expr = symbolic.expr;
    if (!substitutions.empty()) {
      FailureOr<sym::ExprHandle> substituted =
          sym::substituteExpr(store, packet.expr, substitutions);
      if (failed(substituted))
        return failure();
      packet.expr = *substituted;
    }
    FailureOr<sym::ExprHandle> scaled = scaleExpr(store, packet.expr, scale);
    if (failed(scaled))
      return failure();
    packet.expr = *scaled;
    return std::optional<ByteOffsetPacket>{std::move(packet)};
  }

  FailureOr<Value> materializePromotedPointer(Value ptr) {
    FailureOr<bool> materializable = isMaterializableBufferBase(ptr);
    if (failed(materializable))
      return failure();
    if (*materializable)
      return getOrCreateBaseBuffer(ptr);
    if (auto cast = ptr.getDefiningOp<PtrCastOp>()) {
      FailureOr<Value> source = materializePromotedPointer(cast.getSource());
      if (failed(source))
        return failure();
      Type resultType = getBufferPointerLikeType(cast.getResult().getType());
      auto replacement =
          PtrCastOp::create(rewriter, cast.getLoc(), resultType, *source);
      replacement->setAttrs(cast->getAttrs());
      return replacement.getResult();
    }
    auto add = ptr.getDefiningOp<PtrAddOp>();
    if (!add)
      return failure();
    FailureOr<Value> base = materializePromotedPointer(add.getBase());
    if (failed(base))
      return failure();
    Value offset = add.getOffset();
    if (auto analyzed = analyzedOffsets.find(offset);
        analyzed != analyzedOffsets.end()) {
      FailureOr<Value> packet = materializeIndexExpr(
          add.getOperation(), add.getLoc(), analyzed->second, rewriter);
      if (failed(packet))
        return failure();
      offset = *packet;
    }
    Type resultType = getBufferPointerLikeType(add.getResult().getType());
    auto replacement =
        PtrAddOp::create(rewriter, add.getLoc(), resultType, *base, offset);
    replacement->setAttrs(add->getAttrs());
    return replacement.getResult();
  }

  Value getOrCreateBaseBuffer(Value base) {
    if (Value existing = baseBuffers.lookup(base))
      return existing;
    OpBuilder::InsertionGuard guard(rewriter);
    if (BlockArgument arg = dyn_cast<BlockArgument>(base))
      rewriter.setInsertionPointToStart(arg.getOwner());
    else
      rewriter.setInsertionPointAfter(base.getDefiningOp());
    Value range = arith::ConstantIntOp::create(
        rewriter, base.getLoc(), rewriter.getI32Type(), kBufferRangeBytes);
    Type bufferType = getBufferPointerLikeType(base.getType());
    Value buffer = waveamd::MakeBufferOp::create(rewriter, base.getLoc(),
                                                 bufferType, base, range);
    baseBuffers[base] = buffer;
    return buffer;
  }

  DenseMap<Value, Value> baseBuffers;
  DenseMap<Value, SymbolicOffset> analyzedOffsets;
  llvm::StringMap<Value> reservedSymbols;
  func::FuncOp func;
  IRRewriter &rewriter;
  WaveDialect &dialect;
  sym::Store &store;
  DataFlowSolver &rangeSolver;
  unsigned nextSymbol = 0;
};

struct WavePromoteGlobalToBufferPass
    : public wave::impl::WavePromoteGlobalToBufferBase<
          WavePromoteGlobalToBufferPass> {
  void runOnOperation() override {
    Operation *root = getOperation();
    DataFlowSolver rangeSolver;
    dataflow::loadBaselineAnalyses(rangeSolver);
    rangeSolver.load<dataflow::IntegerRangeAnalysis>();
    if (failed(rangeSolver.initializeAndRun(root))) {
      root->emitError(
          "IntegerRangeAnalysis failed for global-to-buffer promotion");
      return signalPassFailure();
    }
    WaveDialect *dialect = getContext().getLoadedDialect<WaveDialect>();
    if (!dialect)
      return signalPassFailure();

    SmallVector<func::FuncOp> funcs;
    if (auto func = dyn_cast<func::FuncOp>(root)) {
      funcs.push_back(func);
    } else {
      root->walk([&](func::FuncOp func) { funcs.push_back(func); });
    }

    IRRewriter rewriter(&getContext());
    for (func::FuncOp func : funcs) {
      if (func.isExternal())
        continue;
      GlobalToBufferPromoter promoter(func, rewriter, *dialect, rangeSolver);
      if (failed(promoter.run()))
        return signalPassFailure();
    }
  }
};

} // namespace
