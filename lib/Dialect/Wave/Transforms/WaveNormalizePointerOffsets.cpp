//===- WaveNormalizePointerOffsets.cpp - Byte pointer form -----*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/Wave/Transforms/Passes.h"

#include "mlir/Dialect/Arith/IR/Arith.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/Func/Transforms/FuncConversions.h"
#include "mlir/Dialect/GPU/IR/GPUDialect.h"
#include "mlir/Dialect/SCF/IR/SCF.h"
#include "mlir/Dialect/SCF/Transforms/Patterns.h"
#include "mlir/Dialect/Wave/IR/Wave.h"
#include "mlir/Dialect/Wave/IR/WaveAMD.h"
#include "mlir/IR/BuiltinTypes.h"
#include "mlir/IR/PatternMatch.h"
#include "mlir/Interfaces/FunctionInterfaces.h"
#include "mlir/Transforms/DialectConversion.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/Support/CheckedArithmetic.h"

#include <optional>

namespace mlir::wave {
#define GEN_PASS_DEF_WAVENORMALIZEPOINTEROFFSETS
#include "mlir/Dialect/Wave/Transforms/Passes.h.inc"
} // namespace mlir::wave

using namespace mlir;
using namespace mlir::wave;

namespace {

class PointerOffsetTypeConverter : public TypeConverter {
public:
  PointerOffsetTypeConverter() {
    addConversion([](Type type) { return type; });
    addConversion([](PtrType type) -> Type {
      if (!type.getElementType())
        return type;
      return PtrType::get(type.getContext(), type.getAddressSpace());
    });
    addConversion([this](SimdType type) -> Type {
      Type elementType = convertType(type.getElementType());
      if (!elementType)
        return Type();
      if (elementType == type.getElementType())
        return type;
      return SimdType::get(type.getContext(), elementType, type.getWidth());
    });
  }
};

static FailureOr<int64_t>
getByteAlignedBits(Type type,
                   function_ref<InFlightDiagnostic(const Twine &)> emitError) {
  int64_t bits = 0;
  if (auto vectorType = dyn_cast<VectorType>(type)) {
    Type elementType = vectorType.getElementType();
    if (!elementType.isIntOrFloat())
      return emitError("pointer vector element type must be integer or float");
    std::optional<int64_t> product = llvm::checkedMul(
        vectorType.getNumElements(),
        static_cast<int64_t>(elementType.getIntOrFloatBitWidth()));
    if (!product)
      return emitError("pointer element bit width overflows i64");
    bits = *product;
  } else {
    if (!type.isIntOrFloat())
      return emitError("pointer element type must be integer or float");
    bits = type.getIntOrFloatBitWidth();
  }
  if (bits % 8 != 0)
    return emitError("pointer element type size must be byte-aligned");
  return bits;
}

static FailureOr<int64_t>
getPointerElementBytes(Type type,
                       function_ref<InFlightDiagnostic(const Twine &)> emit) {
  if (auto simdType = dyn_cast<SimdType>(type))
    type = simdType.getElementType();
  auto ptrType = dyn_cast<PtrType>(type);
  if (!ptrType)
    return emit("expected wave pointer type");
  Type elementType = ptrType.getElementType();
  if (!elementType)
    return int64_t{1};
  FailureOr<int64_t> bits = getByteAlignedBits(elementType, emit);
  if (failed(bits))
    return failure();
  return *bits / 8;
}

static FailureOr<Value> scaleOffset(Operation *diagOp, Location loc,
                                    Value offset, int64_t scale,
                                    PatternRewriter &rewriter) {
  if (scale == 1)
    return offset;
  WaveDialect *dialect = offset.getContext()->getLoadedDialect<WaveDialect>();
  if (!dialect)
    return diagOp->emitError("Wave dialect is not loaded");

  FailureOr<sym::ExprHandle> orig =
      sym::composeExprSym(dialect->getSymbolStore(), "orig");
  FailureOr<sym::ExprHandle> scaleExpr =
      sym::composeExprInt(dialect->getSymbolStore(), scale);
  if (failed(orig) || failed(scaleExpr))
    return diagOp->emitError("failed to compose pointer offset scale");
  FailureOr<sym::ExprHandle> expr = sym::composeExprBinary(
      dialect->getSymbolStore(), *orig, sym::ExprBinaryOp::Mul, *scaleExpr);
  if (failed(expr))
    return diagOp->emitError("failed to compose pointer offset scale");

  StringRef name = "orig";
  Type resultType =
      getIndexExprResultType(offset.getContext(), ValueRange{offset});
  return IndexExprOp::create(rewriter, loc, resultType,
                             ExprAttr::get(offset.getContext(), *expr),
                             rewriter.getStrArrayAttr(name), offset)
      .getResult();
}

template <typename OpT> class ConvertNoRegionOp : public ConversionPattern {
public:
  ConvertNoRegionOp(const TypeConverter &converter, MLIRContext *context)
      : ConversionPattern(converter, OpT::getOperationName(), 1, context) {}

  LogicalResult
  matchAndRewrite(Operation *op, ArrayRef<Value> operands,
                  ConversionPatternRewriter &rewriter) const override {
    if (op->getNumRegions() != 0)
      return failure();
    SmallVector<Type> resultTypes;
    if (failed(getTypeConverter()->convertTypes(op->getResultTypes(),
                                                resultTypes)))
      return failure();
    OperationState state(op->getLoc(), op->getName().getStringRef());
    state.addOperands(operands);
    state.addTypes(resultTypes);
    state.addAttributes(op->getAttrs());
    Operation *replacement = rewriter.create(state);
    rewriter.replaceOp(op, replacement->getResults());
    return success();
  }
};

class NormalizePtrAddOp : public OpConversionPattern<PtrAddOp> {
public:
  using OpConversionPattern::OpConversionPattern;

  LogicalResult
  matchAndRewrite(PtrAddOp op, OpAdaptor adaptor,
                  ConversionPatternRewriter &rewriter) const override {
    Type resultType = getTypeConverter()->convertType(op.getResult().getType());
    if (!resultType)
      return failure();
    Operation *operation = op.getOperation();
    auto emit = [operation](const Twine &msg) {
      return operation->emitOpError(msg);
    };
    FailureOr<int64_t> bytes =
        getPointerElementBytes(op.getBase().getType(), emit);
    if (failed(bytes))
      return failure();

    FailureOr<Value> offset = scaleOffset(
        op.getOperation(), op.getLoc(), adaptor.getOffset(), *bytes, rewriter);
    if (failed(offset))
      return failure();

    PtrAddOp replacement = PtrAddOp::create(rewriter, op.getLoc(), resultType,
                                            adaptor.getBase(), *offset);
    rewriter.replaceOp(op, replacement.getResult());
    return success();
  }
};

class ConvertWhereOp : public OpConversionPattern<WhereOp> {
public:
  using OpConversionPattern::OpConversionPattern;

  LogicalResult
  matchAndRewrite(WhereOp op, OpAdaptor adaptor,
                  ConversionPatternRewriter &rewriter) const override {
    SmallVector<Type> resultTypes;
    if (failed(
            getTypeConverter()->convertTypes(op.getResultTypes(), resultTypes)))
      return failure();

    OperationState state(op.getLoc(), WhereOp::getOperationName());
    state.addOperands(adaptor.getCondition());
    state.addTypes(resultTypes);
    state.addAttributes(op->getAttrs());
    state.addRegion();
    state.addRegion();
    WhereOp replacement = cast<WhereOp>(rewriter.create(state));
    rewriter.inlineRegionBefore(op.getThenRegion(), replacement.getThenRegion(),
                                replacement.getThenRegion().end());
    if (!op.getElseRegion().empty())
      rewriter.inlineRegionBefore(op.getElseRegion(),
                                  replacement.getElseRegion(),
                                  replacement.getElseRegion().end());
    rewriter.replaceOp(op, replacement.getResults());
    return success();
  }
};

static bool hasLegalTypes(const TypeConverter &converter, Operation *op) {
  if (!converter.isLegal(op))
    return false;
  return llvm::all_of(op->getRegions(), [&](Region &region) {
    return converter.isLegal(&region);
  });
}

static void
populatePointerOffsetNormalizationPatterns(RewritePatternSet &patterns,
                                           const TypeConverter &converter) {
  MLIRContext *ctx = patterns.getContext();
  patterns.add<NormalizePtrAddOp, ConvertWhereOp, ConvertNoRegionOp<LdsBaseOp>,
               ConvertNoRegionOp<LoadOp>, ConvertNoRegionOp<StoreOp>,
               ConvertNoRegionOp<SplatOp>, ConvertNoRegionOp<YieldOp>,
               ConvertNoRegionOp<ReadFirstOp>,
               ConvertNoRegionOp<waveamd::MakeBufferOp>,
               ConvertNoRegionOp<waveamd::DmaLoadLdsOp>>(converter, ctx);
  populateAnyFunctionOpInterfaceTypeConversionPattern(patterns, converter);
  populateReturnOpTypeConversionPattern(patterns, converter);
  populateCallOpTypeConversionPattern(patterns, converter);
}

struct WaveNormalizePointerOffsetsPass
    : public wave::impl::WaveNormalizePointerOffsetsBase<
          WaveNormalizePointerOffsetsPass> {
  void runOnOperation() override {
    SmallVector<func::FuncOp> funcs;
    if (auto func = dyn_cast<func::FuncOp>(getOperation())) {
      funcs.push_back(func);
    } else {
      getOperation()->walk([&](func::FuncOp func) {
        if (func->hasAttr("wave.kernel") ||
            func->getParentOfType<gpu::GPUModuleOp>())
          funcs.push_back(func);
      });
    }

    for (func::FuncOp func : funcs)
      if (failed(convertFunc(func)))
        return signalPassFailure();
  }

  LogicalResult convertFunc(func::FuncOp func) {
    MLIRContext *ctx = &getContext();
    PointerOffsetTypeConverter converter;
    RewritePatternSet patterns(ctx);
    ConversionTarget target(*ctx);

    target.markUnknownOpDynamicallyLegal(
        [&](Operation *op) { return hasLegalTypes(converter, op); });
    target.addDynamicallyLegalOp<func::FuncOp>([&](func::FuncOp op) {
      return converter.isSignatureLegal(op.getFunctionType()) &&
             converter.isLegal(&op.getBody());
    });
    target.addDynamicallyLegalOp<func::CallOp>([&](func::CallOp op) {
      return converter.isLegal(op.getOperandTypes()) &&
             converter.isLegal(op.getResultTypes());
    });
    target.addDynamicallyLegalOp<func::ReturnOp>([&](func::ReturnOp op) {
      return converter.isLegal(op.getOperandTypes());
    });

    populatePointerOffsetNormalizationPatterns(patterns, converter);
    scf::populateSCFStructuralTypeConversionsAndLegality(converter, patterns,
                                                         target);

    return applyPartialConversion(func, target, std::move(patterns));
  }
};

} // namespace
