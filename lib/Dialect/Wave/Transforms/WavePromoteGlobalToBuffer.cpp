//===- WavePromoteGlobalToBuffer.cpp - form buffer pointers -----*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/Wave/Transforms/Passes.h"

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
#include "llvm/ADT/STLExtras.h"
#include "llvm/ADT/StringMap.h"
#include "llvm/ADT/StringSet.h"
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

struct ByteOffset {
  struct Binding {
    std::string name;
    Value value;
  };

  SmallVector<sym::PredHandle, 4> assumptions;
  SmallVector<Binding, 4> bindings;
  sym::ExprHandle expr;
};

static bool provablyInRangeWithExpansion(sym::Analysis &analysis,
                                         sym::ExprHandle expr, int64_t lower,
                                         int64_t upper) {
  if (sym::provablyInRange(analysis, expr, lower, upper))
    return true;
  if (FailureOr<sym::ExprHandle> simplified = analysis.simplify(expr);
      succeeded(simplified) &&
      sym::provablyInRange(analysis, *simplified, lower, upper))
    return true;
  FailureOr<sym::ExprHandle> expanded = analysis.expand(expr);
  if (failed(expanded))
    return false;
  if (sym::provablyInRange(analysis, *expanded, lower, upper))
    return true;
  FailureOr<sym::ExprHandle> simplified = analysis.simplify(*expanded);
  return succeeded(simplified) &&
         sym::provablyInRange(analysis, *simplified, lower, upper);
}

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

static bool isWideScalarInteger(Type type) {
  auto intType = dyn_cast<IntegerType>(type);
  return intType && intType.isSignless() && intType.getWidth() > 32;
}

static bool referencesWideScalarInteger(const ByteOffset &offset) {
  if (!offset.expr)
    return false;

  llvm::StringSet<> wideSymbols;
  for (const ByteOffset::Binding &binding : offset.bindings)
    if (isWideScalarInteger(binding.value.getType()))
      wideSymbols.insert(binding.name);

  bool found = false;
  sym::walkSymbolNames(offset.expr, [&](StringRef name) {
    found |= wideSymbols.contains(name);
  });
  return found;
}

static bool isMaterializableBufferBaseOffset(Value value) {
  if (isWideScalarInteger(value.getType()))
    return false;
  if (auto indexExpr = value.getDefiningOp<IndexExprOp>()) {
    FailureOr<SymbolicOffset> symbolic = getIndexExprSymbolicOffset(indexExpr);
    if (failed(symbolic))
      return false;
    return llvm::none_of(symbolic->bindings,
                         [](const SymbolicOffsetBinding &binding) {
                           return isWideScalarInteger(binding.value.getType());
                         });
  }
  return true;
}

static bool isMaterializableBufferBase(Value ptr) {
  if (!isUniformGlobalPointer(ptr.getType()))
    return false;
  if (auto cast = ptr.getDefiningOp<PtrCastOp>())
    return isMaterializableBufferBase(cast.getSource());
  if (auto add = ptr.getDefiningOp<PtrAddOp>())
    return isMaterializableBufferBase(add.getBase()) &&
           isMaterializableBufferBaseOffset(add.getOffset());
  return true;
}

static LogicalResult appendExpr(sym::Store &store, ByteOffset &dst,
                                const ByteOffset &src) {
  llvm::append_range(dst.assumptions, src.assumptions);
  llvm::append_range(dst.bindings, src.bindings);
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

static void appendLaneIdRange(sym::Store &store, Value value, StringRef name,
                              SmallVectorImpl<sym::PredHandle> &assumptions) {
  auto laneId = value.getDefiningOp<LaneIdOp>();
  if (!laneId)
    return;
  auto simd = dyn_cast<SimdType>(laneId.getResult().getType());
  if (!simd)
    return;
  FailureOr<sym::PredHandle> range =
      sym::rangeAssumption(store, name, 0, simd.getWidth() - 1);
  if (succeeded(range))
    assumptions.push_back(*range);
}

static std::optional<ConstantIntRanges>
finiteSignedRange(DataFlowSolver &solver, Value value) {
  const dataflow::IntegerValueRangeLattice *lattice =
      solver.lookupState<dataflow::IntegerValueRangeLattice>(value);
  if (!lattice)
    return std::nullopt;
  IntegerValueRange ivr = lattice->getValue();
  if (ivr.isUninitialized())
    return std::nullopt;

  ConstantIntRanges range = ivr.getValue();
  unsigned width = range.smin().getBitWidth();
  if (width == 0 || width > 64)
    return std::nullopt;
  APInt sminBound = APInt::getSignedMinValue(width);
  APInt smaxBound = APInt::getSignedMaxValue(width);
  if (range.smin() == sminBound && range.smax() == smaxBound)
    return std::nullopt;
  return range;
}

static void
appendKnownPredicates(DataFlowSolver &solver, sym::Store &store, Value value,
                      StringRef name,
                      SmallVectorImpl<sym::PredHandle> &assumptions) {
  if (std::optional<ConstantIntRanges> range = finiteSignedRange(solver, value))
    appendRangeAndAssumePredicates(store, value, name, *range, assumptions);
  else
    appendAssumePredicates(store, value, name, assumptions);
  appendLaneIdRange(store, value, name, assumptions);
}

static std::optional<int64_t> payloadBytes(Operation *op, Type elementType) {
  FailureOr<MemoryPayloadShape> shape = getMemoryPayloadShape(
      elementType, [&](const Twine &msg) { return op->emitError(msg); });
  if (failed(shape) || shape->payloadBits % 8 != 0)
    return std::nullopt;
  return shape->payloadBits / 8;
}

static std::optional<int64_t> accessBytes(LoadOp op) {
  SimdType simd = cast<SimdType>(op.getValue().getType());
  return payloadBytes(op.getOperation(), simd.getElementType());
}

static std::optional<int64_t> accessBytes(StoreOp op) {
  SimdType simd = cast<SimdType>(op.getValue().getType());
  return payloadBytes(op.getOperation(), simd.getElementType());
}

class GlobalToBufferPromoter {
public:
  GlobalToBufferPromoter(func::FuncOp func, IRRewriter &rewriter,
                         sym::Store &store, DataFlowSolver &solver)
      : func(func), rewriter(rewriter), store(store), solver(solver) {}

  LogicalResult run() {
    bool changed = false;
    func.walk([&](Operation *op) {
      if (auto load = dyn_cast<LoadOp>(op)) {
        changed |= promoteOperand(load, load.getPtr(), /*operandIndex=*/0,
                                  accessBytes(load));
        return;
      }
      if (auto store = dyn_cast<StoreOp>(op)) {
        changed |= promoteOperand(store, store.getPtr(), /*operandIndex=*/1,
                                  accessBytes(store));
        return;
      }
      if (auto dma = dyn_cast<waveamd::DmaLoadLdsOp>(op))
        changed |= promoteOperand(dma, dma.getSource(), /*operandIndex=*/0,
                                  dma.getBytes());
    });
    if (changed)
      eraseDeadPointerOps();
    return success();
  }

private:
  bool promoteOperand(Operation *op, Value ptr, unsigned operandIndex,
                      std::optional<int64_t> bytes) {
    if (!isGlobalPointerLike(ptr.getType()))
      return false;
    FailureOr<ByteOffset> offset = buildByteOffset(ptr);
    if (failed(offset) || !offsetFitsBuffer(*offset, bytes))
      return false;

    OpBuilder::InsertionGuard guard(rewriter);
    rewriter.setInsertionPoint(op);
    FailureOr<Value> promoted = materializePromotedPointer(ptr);
    if (failed(promoted))
      return false;
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

  bool offsetFitsBuffer(const ByteOffset &offset,
                        std::optional<int64_t> bytes) {
    if (!bytes || *bytes <= 0 || *bytes > kBufferRangeBytes)
      return false;
    if (!offset.expr)
      return true;
    if (referencesWideScalarInteger(offset))
      return false;
    FailureOr<std::unique_ptr<sym::Analysis>> analysis =
        sym::Analysis::create(store, offset.assumptions);
    return succeeded(analysis) &&
           provablyInRangeWithExpansion(**analysis, offset.expr, 0,
                                        kBufferRangeBytes - *bytes);
  }

  FailureOr<ByteOffset> buildByteOffset(Value ptr) {
    if (isMaterializableBufferBase(ptr))
      return ByteOffset{};
    if (auto cast = ptr.getDefiningOp<PtrCastOp>())
      return buildByteOffset(cast.getSource());
    auto add = ptr.getDefiningOp<PtrAddOp>();
    if (!add)
      return failure();

    FailureOr<ByteOffset> base = buildByteOffset(add.getBase());
    if (failed(base))
      return failure();
    std::optional<int64_t> scale =
        getPointerElementBytes(add.getBase().getType());
    if (!scale)
      return failure();
    FailureOr<ByteOffset> added = buildOffset(add.getOffset(), *scale);
    if (failed(added))
      return failure();

    ByteOffset out = *base;
    if (failed(appendExpr(store, out, *added)))
      return failure();
    return out;
  }

  FailureOr<ByteOffset> buildOffset(Value value, int64_t scale) {
    if (std::optional<int64_t> constant = getConstantIntValue(value)) {
      std::optional<int64_t> scaled = llvm::checkedMul(*constant, scale);
      if (!scaled)
        return failure();
      FailureOr<sym::ExprHandle> expr = sym::composeExprInt(store, *scaled);
      if (failed(expr))
        return failure();
      ByteOffset offset;
      offset.expr = *expr;
      return offset;
    }

    if (auto indexExpr = value.getDefiningOp<IndexExprOp>())
      return buildIndexExprOffset(indexExpr, scale);
    return buildRawOffset(value, scale);
  }

  LogicalResult appendIndexExprBindings(
      const SymbolicOffset &symbolic, ByteOffset &offset,
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
      offset.bindings.push_back({name, binding.value});
      appendKnownPredicates(solver, store, binding.value, name,
                            offset.assumptions);
    }
    return success();
  }

  LogicalResult
  appendIndexExprAssumptions(const SymbolicOffset &symbolic, ByteOffset &offset,
                             ArrayRef<sym::ExprSubstitution> substitutions) {
    for (sym::PredHandle pred : symbolic.assumptions) {
      FailureOr<sym::PredHandle> substituted =
          substitutions.empty()
              ? FailureOr<sym::PredHandle>(pred)
              : sym::substitutePred(store, pred, substitutions);
      if (failed(substituted))
        return failure();
      offset.assumptions.push_back(*substituted);
    }
    return success();
  }

  FailureOr<ByteOffset> buildIndexExprOffset(IndexExprOp op, int64_t scale) {
    FailureOr<SymbolicOffset> symbolic = getIndexExprSymbolicOffset(op);
    if (failed(symbolic))
      return failure();

    ByteOffset offset;
    SmallVector<sym::ExprSubstitution, 4> substitutions;
    if (failed(appendIndexExprBindings(*symbolic, offset, substitutions)))
      return failure();
    if (failed(appendIndexExprAssumptions(*symbolic, offset, substitutions)))
      return failure();
    offset.expr = symbolic->expr;
    if (!substitutions.empty()) {
      FailureOr<sym::ExprHandle> substituted =
          sym::substituteExpr(store, offset.expr, substitutions);
      if (failed(substituted))
        return failure();
      offset.expr = *substituted;
    }
    FailureOr<sym::ExprHandle> scaled = scaleExpr(store, offset.expr, scale);
    if (failed(scaled))
      return failure();
    offset.expr = *scaled;
    return offset;
  }

  FailureOr<ByteOffset> buildRawOffset(Value value, int64_t scale) {
    std::string name = getFreshIndexExprBindingName(
        "__wave_buffer_ptr_", reservedSymbols, nextSymbol);
    ByteOffset offset;
    reservedSymbols[name] = value;
    offset.bindings.push_back({name, value});
    appendKnownPredicates(solver, store, value, name, offset.assumptions);
    FailureOr<sym::ExprHandle> expr = sym::composeExprSym(store, name);
    if (failed(expr))
      return failure();
    FailureOr<sym::ExprHandle> scaled = scaleExpr(store, *expr, scale);
    if (failed(scaled))
      return failure();
    offset.expr = *scaled;
    return offset;
  }

  FailureOr<Value> materializePromotedPointer(Value ptr) {
    if (isMaterializableBufferBase(ptr))
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
    Type resultType = getBufferPointerLikeType(add.getResult().getType());
    auto replacement = PtrAddOp::create(rewriter, add.getLoc(), resultType,
                                        *base, add.getOffset());
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
  llvm::StringMap<Value> reservedSymbols;
  func::FuncOp func;
  IRRewriter &rewriter;
  sym::Store &store;
  DataFlowSolver &solver;
  unsigned nextSymbol = 0;
};

struct WavePromoteGlobalToBufferPass
    : public wave::impl::WavePromoteGlobalToBufferBase<
          WavePromoteGlobalToBufferPass> {
  void runOnOperation() override {
    Operation *root = getOperation();
    WaveDialect *dialect = getContext().getLoadedDialect<WaveDialect>();
    if (!dialect)
      return signalPassFailure();

    DataFlowSolver solver;
    dataflow::loadBaselineAnalyses(solver);
    solver.load<dataflow::IntegerRangeAnalysis>();
    if (failed(solver.initializeAndRun(root))) {
      root->emitError("IntegerRangeAnalysis failed for global-to-buffer "
                      "promotion pass");
      return signalPassFailure();
    }

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
      GlobalToBufferPromoter promoter(func, rewriter, dialect->getSymbolStore(),
                                      solver);
      if (failed(promoter.run()))
        return signalPassFailure();
    }
  }
};

} // namespace
