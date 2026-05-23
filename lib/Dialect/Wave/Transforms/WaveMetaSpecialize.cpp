//===- WaveMetaSpecialize.cpp - WaveMeta specialiser ------*- C++ -*-===//
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
#include "mlir/Dialect/SCF/IR/SCF.h"
#include "mlir/Dialect/SCF/Transforms/Patterns.h"
#include "mlir/Dialect/Utils/StaticValueUtils.h"
#include "mlir/Dialect/Wave/IR/WaveMeta.h"
#include "mlir/IR/AttrTypeSubElements.h"
#include "mlir/IR/BuiltinOps.h"
#include "mlir/IR/IRMapping.h"
#include "mlir/IR/Matchers.h"
#include "mlir/IR/PatternMatch.h"
#include "mlir/Interfaces/FunctionInterfaces.h"
#include "mlir/Transforms/DialectConversion.h"
#include "mlir/Transforms/GreedyPatternRewriteDriver.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/ADT/SmallVector.h"

namespace mlir::wave {
#define GEN_PASS_DEF_WAVEMETASPECIALIZE
#include "mlir/Dialect/Wave/Transforms/Passes.h.inc"
} // namespace mlir::wave

using namespace mlir;
using namespace mlir::wavemeta;

namespace {

//===----------------------------------------------------------------------===//
// Phase 1: bind module-scope params.
//===----------------------------------------------------------------------===//

// Resolve `!wavemeta.ptuple<T, "name">` to `!wavemeta.ptuple<T, N>` by
// reading `wavemeta.params[name]` and substituting the concrete int.
// Lets the matmul-style "K-tile worth of frags rides through scf.for
// iter_args" pattern shrink under `bind_param` instead of staying
// stuck at the build-time max. After this phase, every surviving
// parametric width is an unresolved one (no dict entry / non-int
// entry) and the residual phase will flag it.
static void substituteParametricWidths(ModuleOp moduleOp) {
  auto params = moduleOp->getAttrOfType<DictionaryAttr>(
      WaveMetaDialect::getParamsAttrName());
  if (!params)
    return;
  AttrTypeReplacer replacer;
  replacer.addReplacement([&](PTupleType t) -> std::optional<Type> {
    auto sw = dyn_cast<StringAttr>(t.getWidth());
    if (!sw)
      return std::nullopt;
    auto bound = dyn_cast_or_null<IntegerAttr>(params.get(sw.getValue()));
    if (!bound)
      return std::nullopt;
    return PTupleType::get(t.getContext(), t.getElementType(), bound);
  });
  replacer.recursivelyReplaceElementsIn(moduleOp, /*replaceAttrs=*/true,
                                        /*replaceLocs=*/false,
                                        /*replaceTypes=*/true);
}

// Walk every ParamOp once and attach `$value` from the module's
// `wavemeta.params` dict where the name matches. Name-match with
// type-mismatch is an error -- bare "no binding" silenceably hides
// the real cause (autotuners feeding `i64` into an `index` param,
// etc.).
static LogicalResult bindParams(ModuleOp moduleOp) {
  auto dict = moduleOp->getAttrOfType<DictionaryAttr>(
      WaveMetaDialect::getParamsAttrName());
  if (!dict)
    return success();
  WalkResult result = moduleOp.walk([&](ParamOp op) -> WalkResult {
    if (op.getValueAttr())
      return WalkResult::advance();
    Attribute bound = dict.get(op.getName());
    if (!bound)
      return WalkResult::advance();
    auto typed = dyn_cast<TypedAttr>(bound);
    if (!typed)
      return op.emitOpError()
             << "wavemeta.params['" << op.getName()
             << "'] is not a typed attribute (got " << bound << ")";
    if (typed.getType() != op.getResult().getType())
      return op.emitOpError()
             << "wavemeta.params['" << op.getName() << "'] has type "
             << typed.getType() << ", expected " << op.getResult().getType();
    op.setValueAttr(typed);
    return WalkResult::advance();
  });
  return failure(result.wasInterrupted());
}

//===----------------------------------------------------------------------===//
// Phase 2: greedy rewriter patterns.
//===----------------------------------------------------------------------===//

// `wavemeta.static_if` with a constant condition: inline the taken
// region in place, replace results with its yield operands. Untaken
// region is dropped by the rewriter when the op is erased.
struct StaticIfFold : OpRewritePattern<StaticIfOp> {
  using OpRewritePattern::OpRewritePattern;
  LogicalResult matchAndRewrite(StaticIfOp op,
                                PatternRewriter &rewriter) const override {
    BoolAttr condAttr;
    if (!matchPattern(op.getCondition(), m_Constant(&condAttr)))
      return failure();
    bool takenIsThen = condAttr.getValue();
    Region &taken = takenIsThen ? op.getThenRegion() : op.getElseRegion();
    if (taken.empty()) {
      // Verifier enforces: else may be empty only when op has no results.
      rewriter.eraseOp(op);
      return success();
    }
    Block &block = taken.front();
    auto yield = cast<YieldOp>(block.getTerminator());
    SmallVector<Value> yielded(yield.getValues());
    rewriter.eraseOp(yield);
    rewriter.inlineBlockBefore(&block, op);
    rewriter.replaceOp(op, yielded);
    return success();
  }
};

// Materialise one unrolled iteration body. Returns the carry values
// produced by the iteration's yield (mapped through the local clones).
static SmallVector<Value> emitForIteration(PatternRewriter &rewriter,
                                           StaticForOp op, int64_t ivValue,
                                           ValueRange carriesIn) {
  Block &body = op.getBody().front();
  Location loc = op.getLoc();
  Value iv = arith::ConstantIndexOp::create(rewriter, loc, ivValue);
  IRMapping map;
  map.map(body.getArgument(0), iv);
  for (auto [bbArg, carry] :
       llvm::zip(body.getArguments().drop_front(), carriesIn))
    map.map(bbArg, carry);
  for (Operation &bodyOp : body.without_terminator())
    rewriter.clone(bodyOp, map);
  auto yield = cast<YieldOp>(body.getTerminator());
  SmallVector<Value> next;
  next.reserve(yield.getValues().size());
  for (Value v : yield.getValues())
    next.push_back(map.lookupOrDefault(v));
  return next;
}

// `wavemeta.static_for` with constant bounds: unroll by cloning the
// body trip-count times, threading the iter-arg carries through.
// Step <= 0 is rejected here and surfaces in phase 4 as a residual.
struct StaticForUnroll : OpRewritePattern<StaticForOp> {
  using OpRewritePattern::OpRewritePattern;
  LogicalResult matchAndRewrite(StaticForOp op,
                                PatternRewriter &rewriter) const override {
    std::optional<int64_t> lb = getConstantIntValue(op.getLowerBound());
    std::optional<int64_t> ub = getConstantIntValue(op.getUpperBound());
    std::optional<int64_t> step = getConstantIntValue(op.getStep());
    if (!lb || !ub || !step || *step <= 0)
      return failure();

    int64_t span = *ub - *lb;
    int64_t tripCount = span <= 0 ? 0 : (span + *step - 1) / *step;
    if (tripCount == 0) {
      rewriter.replaceOp(op, op.getIterArgs());
      return success();
    }

    SmallVector<Value> carries(op.getIterArgs());
    for (int64_t i = 0; i < tripCount; ++i)
      carries = emitForIteration(rewriter, op, *lb + i * *step, carries);
    rewriter.replaceOp(op, carries);
    return success();
  }
};

// Broadcast with concrete width N expands to a `tuple_make` of N
// copies. Parameter-named widths leave the broadcast alive for the
// residual phase.
struct BroadcastExpand : OpRewritePattern<TupleMakeBroadcastOp> {
  using OpRewritePattern::OpRewritePattern;
  LogicalResult matchAndRewrite(TupleMakeBroadcastOp op,
                                PatternRewriter &rewriter) const override {
    auto resTy = cast<PTupleType>(op.getResult().getType());
    auto widthAttr = dyn_cast<IntegerAttr>(resTy.getWidth());
    if (!widthAttr || widthAttr.getInt() < 0)
      return failure();
    SmallVector<Value> elems(widthAttr.getInt(), op.getInit());
    auto make = TupleMakeOp::create(rewriter, op.getLoc(), resTy, elems);
    rewriter.replaceOp(op, make.getResult());
    return success();
  }
};

// `tuple_set` against a concrete `tuple_make` with a constant index
// rebuilds the tuple with one slot replaced.
struct TupleSetFold : OpRewritePattern<TupleSetOp> {
  using OpRewritePattern::OpRewritePattern;
  LogicalResult matchAndRewrite(TupleSetOp op,
                                PatternRewriter &rewriter) const override {
    std::optional<int64_t> idx = getConstantIntValue(op.getIndex());
    if (!idx)
      return failure();
    auto make = op.getTuple().getDefiningOp<TupleMakeOp>();
    if (!make)
      return failure();
    int64_t n = static_cast<int64_t>(make.getElements().size());
    if (*idx < 0 || *idx >= n)
      return failure();
    SmallVector<Value> elems(make.getElements());
    elems[*idx] = op.getValue();
    auto newMake = TupleMakeOp::create(rewriter, op.getLoc(),
                                       make.getResult().getType(), elems);
    rewriter.replaceOp(op, newMake.getResult());
    return success();
  }
};

static void populatePhase2Patterns(RewritePatternSet &patterns) {
  patterns.add<StaticIfFold, StaticForUnroll, BroadcastExpand, TupleSetFold>(
      patterns.getContext());
}

//===----------------------------------------------------------------------===//
// Phase 3: type-converter-driven ptuple decomposition.
//===----------------------------------------------------------------------===//

// Converter rule for `!wavemeta.ptuple<T, W>`:
// - Concrete non-negative W: expand to W copies of T.
// - Parameter-named W: keep as-is so structural ops stay legal; the
//   residual phase will then point at whatever still holds it.
class PTupleTypeConverter : public TypeConverter {
public:
  PTupleTypeConverter() {
    addConversion([](Type t) { return t; });
    addConversion(
        [](PTupleType t, SmallVectorImpl<Type> &out) -> LogicalResult {
          auto width = dyn_cast<IntegerAttr>(t.getWidth());
          if (!width || width.getInt() < 0) {
            out.push_back(t);
            return success();
          }
          out.append(width.getInt(), t.getElementType());
          return success();
        });
    // Source materialisation: rebuild ptuple from scalars on the fly
    // (used when a converted value flows into an unconverted use).
    addSourceMaterialization([](OpBuilder &builder, PTupleType resTy,
                                ValueRange inputs, Location loc) -> Value {
      return TupleMakeOp::create(builder, loc, resTy, inputs).getResult();
    });
    // Target materialisation: project a still-ptuple value to its
    // scalar slots via constant-index `tuple_get`s.
    addTargetMaterialization([](OpBuilder &builder, TypeRange resTys,
                                ValueRange inputs,
                                Location loc) -> SmallVector<Value> {
      assert(inputs.size() == 1 &&
             "ptuple target materialisation expects one input");
      Value tuple = inputs.front();
      auto tupleTy = cast<PTupleType>(tuple.getType());
      SmallVector<Value> out;
      out.reserve(resTys.size());
      for (size_t i = 0, e = resTys.size(); i < e; ++i) {
        Value idx = arith::ConstantIndexOp::create(builder, loc,
                                                   static_cast<int64_t>(i));
        out.push_back(TupleGetOp::create(builder, loc, tupleTy.getElementType(),
                                         tuple, idx)
                          .getResult());
      }
      return out;
    });
  }
};

// `tuple_make`: 1-to-N rewrite. Each operand is already a scalar; the
// op's single result expands to N scalars equal to the operand list.
struct TupleMakeDecompose : OpConversionPattern<TupleMakeOp> {
  using OpConversionPattern::OpConversionPattern;
  LogicalResult
  matchAndRewrite(TupleMakeOp op, OneToNOpAdaptor adaptor,
                  ConversionPatternRewriter &rewriter) const override {
    auto resTy = cast<PTupleType>(op.getResult().getType());
    auto width = dyn_cast<IntegerAttr>(resTy.getWidth());
    if (!width || width.getInt() < 0)
      return failure();
    SmallVector<Value> replacements;
    for (ValueRange r : adaptor.getElements())
      llvm::append_range(replacements, r);
    rewriter.replaceOpWithMultiple(op, {replacements});
    return success();
  }
};

// Broadcast with concrete width: same as Phase 2's BroadcastExpand
// but emits scalars directly. Survives only if phase 2 left it alive
// because of a parametric width -- then this also bails.
struct BroadcastDecompose : OpConversionPattern<TupleMakeBroadcastOp> {
  using OpConversionPattern::OpConversionPattern;
  LogicalResult
  matchAndRewrite(TupleMakeBroadcastOp op, OneToNOpAdaptor adaptor,
                  ConversionPatternRewriter &rewriter) const override {
    auto resTy = cast<PTupleType>(op.getResult().getType());
    auto width = dyn_cast<IntegerAttr>(resTy.getWidth());
    if (!width || width.getInt() < 0)
      return failure();
    ValueRange initScalars = adaptor.getInit();
    if (initScalars.size() != 1)
      return failure();
    SmallVector<Value> replacements(width.getInt(), initScalars.front());
    rewriter.replaceOpWithMultiple(op, {replacements});
    return success();
  }
};

// `tuple_get` whose tuple crossed a boundary: pick the scalar at the
// constant index from the adaptor's flattened operand list.
struct TupleGetDecompose : OpConversionPattern<TupleGetOp> {
  using OpConversionPattern::OpConversionPattern;
  LogicalResult
  matchAndRewrite(TupleGetOp op, OneToNOpAdaptor adaptor,
                  ConversionPatternRewriter &rewriter) const override {
    std::optional<int64_t> idx = getConstantIntValue(op.getIndex());
    if (!idx)
      return failure();
    ValueRange tupleScalars = adaptor.getTuple();
    int64_t n = static_cast<int64_t>(tupleScalars.size());
    if (*idx < 0 || *idx >= n)
      return failure();
    rewriter.replaceOp(op, tupleScalars[*idx]);
    return success();
  }
};

// `tuple_set`: replicate the scalar list with one slot updated.
struct TupleSetDecompose : OpConversionPattern<TupleSetOp> {
  using OpConversionPattern::OpConversionPattern;
  LogicalResult
  matchAndRewrite(TupleSetOp op, OneToNOpAdaptor adaptor,
                  ConversionPatternRewriter &rewriter) const override {
    std::optional<int64_t> idx = getConstantIntValue(op.getIndex());
    if (!idx)
      return failure();
    ValueRange tupleScalars = adaptor.getTuple();
    ValueRange valueScalars = adaptor.getValue();
    if (valueScalars.size() != 1)
      return failure();
    int64_t n = static_cast<int64_t>(tupleScalars.size());
    if (*idx < 0 || *idx >= n)
      return failure();
    SmallVector<Value> replacements(tupleScalars.begin(), tupleScalars.end());
    replacements[*idx] = valueScalars.front();
    rewriter.replaceOpWithMultiple(op, {replacements});
    return success();
  }
};

static void populatePhase3Patterns(RewritePatternSet &patterns,
                                   const TypeConverter &converter) {
  patterns.add<TupleMakeDecompose, BroadcastDecompose, TupleGetDecompose,
               TupleSetDecompose>(converter, patterns.getContext());
  populateAnyFunctionOpInterfaceTypeConversionPattern(patterns, converter);
  populateReturnOpTypeConversionPattern(patterns, converter);
  populateCallOpTypeConversionPattern(patterns, converter);
}

//===----------------------------------------------------------------------===//
// Phase 4: residual diagnostics.
//===----------------------------------------------------------------------===//

// Emit the diagnostic for a single wavemeta residual op. Returns true
// if the op was identified as a primary residual; false if it should
// fall through to generic checks. TupleMakeOp / YieldOp are silenced
// because they ride along with a sibling residual that already speaks.
static bool diagnoseWavemetaResidual(Operation *op) {
  if (auto p = dyn_cast<ParamOp>(op)) {
    if (p.getValueAttr())
      return false;
    p.emitOpError() << "parameter '" << p.getName() << "' has no binding";
    return true;
  }
  if (isa<StaticIfOp>(op)) {
    op->emitOpError("static_if condition does not fold to a constant");
    return true;
  }
  if (isa<StaticForOp>(op)) {
    op->emitOpError("static_for bounds do not fold to constants");
    return true;
  }
  if (isa<TupleGetOp, TupleSetOp>(op)) {
    op->emitOpError("tuple operation depends on a non-constant index or "
                    "parametric width");
    return true;
  }
  if (isa<TupleMakeBroadcastOp>(op)) {
    op->emitOpError("broadcast has parameter-named width that did not resolve");
    return true;
  }
  return false;
}

static bool isSilentResidualKind(Operation *op) {
  return isa<TupleMakeOp, YieldOp>(op);
}

static bool hasUnresolvedPTupleResult(Operation *op) {
  return llvm::any_of(op->getResultTypes(),
                      [](Type t) { return isa<PTupleType>(t); });
}

static bool diagnoseFunctionSignature(FunctionOpInterface fn) {
  auto hasPTuple = [](TypeRange ts) {
    return llvm::any_of(ts, [](Type t) { return isa<PTupleType>(t); });
  };
  if (!hasPTuple(fn.getArgumentTypes()) && !hasPTuple(fn.getResultTypes()))
    return false;
  fn.emitOpError("function signature retains unresolved parametric tuple type");
  return true;
}

static LogicalResult diagnoseResiduals(ModuleOp moduleOp) {
  bool anyResidual = false;
  moduleOp.walk([&](Operation *op) {
    if (diagnoseWavemetaResidual(op)) {
      anyResidual = true;
      return;
    }
    if (isSilentResidualKind(op))
      return;
    if (hasUnresolvedPTupleResult(op)) {
      op->emitOpError("result has unresolved parametric tuple type");
      anyResidual = true;
    }
  });
  moduleOp.walk([&](FunctionOpInterface fn) {
    if (diagnoseFunctionSignature(fn))
      anyResidual = true;
  });
  return success(!anyResidual);
}

//===----------------------------------------------------------------------===//
// Pass.
//===----------------------------------------------------------------------===//

struct WaveMetaSpecializePass
    : public mlir::wave::impl::WaveMetaSpecializeBase<WaveMetaSpecializePass> {
  using WaveMetaSpecializeBase::WaveMetaSpecializeBase;

  void runOnOperation() override {
    ModuleOp moduleOp = getOperation();
    MLIRContext *ctx = &getContext();

    if (failed(bindParams(moduleOp)))
      return signalPassFailure();
    substituteParametricWidths(moduleOp);

    {
      RewritePatternSet patterns(ctx);
      populatePhase2Patterns(patterns);
      if (failed(applyPatternsGreedily(moduleOp, std::move(patterns))))
        return signalPassFailure();
    }

    {
      PTupleTypeConverter converter;
      RewritePatternSet patterns(ctx);
      ConversionTarget target(*ctx);
      target.markUnknownOpDynamicallyLegal(
          [&](Operation *op) { return converter.isLegal(op); });
      target.addDynamicallyLegalOp<func::FuncOp>([&](func::FuncOp f) {
        return converter.isSignatureLegal(f.getFunctionType()) &&
               converter.isLegal(&f.getBody());
      });
      target.addDynamicallyLegalOp<func::CallOp>([&](func::CallOp c) {
        return converter.isLegal(c.getOperandTypes()) &&
               converter.isLegal(c.getResultTypes());
      });
      target.addDynamicallyLegalOp<func::ReturnOp>([&](func::ReturnOp r) {
        return converter.isLegal(r.getOperandTypes());
      });
      // Tuple ops that the patterns can't rewrite (non-constant index,
      // parametric width) stay dynamically legal so partial conversion
      // doesn't error out -- phase 4 diagnoses them.
      target.addDynamicallyLegalOp<TupleGetOp>([](TupleGetOp op) {
        return !getConstantIntValue(op.getIndex()).has_value();
      });
      target.addDynamicallyLegalOp<TupleSetOp>([](TupleSetOp op) {
        return !getConstantIntValue(op.getIndex()).has_value();
      });
      target.addDynamicallyLegalOp<TupleMakeBroadcastOp>(
          [](TupleMakeBroadcastOp op) {
            auto width = dyn_cast<IntegerAttr>(
                cast<PTupleType>(op.getResult().getType()).getWidth());
            return !width;
          });
      populatePhase3Patterns(patterns, converter);
      scf::populateSCFStructuralTypeConversionsAndLegality(converter, patterns,
                                                           target);
      if (failed(applyPartialConversion(moduleOp, target, std::move(patterns))))
        return signalPassFailure();
    }

    // Safety net: a second greedy sweep mops up anything the type
    // conversion exposed (e.g. constant tuple_get on a freshly
    // flattened operand list).
    {
      RewritePatternSet patterns(ctx);
      populatePhase2Patterns(patterns);
      if (failed(applyPatternsGreedily(moduleOp, std::move(patterns))))
        return signalPassFailure();
    }

    if (errorOnResidual && failed(diagnoseResiduals(moduleOp)))
      return signalPassFailure();
  }
};

} // namespace
