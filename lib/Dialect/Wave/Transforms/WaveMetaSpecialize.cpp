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
// `wavemeta.params` dict where the name matches; immediately
// materialise the resolved param as `arith.constant` and rewrite uses
// so subsequent fold-based patterns (`StaticForUnroll`'s
// `getConstantIntValue` etc.) see the concrete value without relying
// on the greedy rewriter to re-fire on every visited op. Name-match
// with type-mismatch is an error -- bare "no binding" silenceably
// hides the real cause (autotuners feeding `i64` into an `index`
// param, etc.).
static LogicalResult bindParams(ModuleOp moduleOp) {
  auto dict = moduleOp->getAttrOfType<DictionaryAttr>(
      WaveMetaDialect::getParamsAttrName());
  if (!dict)
    return success();
  SmallVector<ParamOp> resolved;
  WalkResult result = moduleOp.walk([&](ParamOp op) -> WalkResult {
    if (op.getValueAttr()) {
      resolved.push_back(op);
      return WalkResult::advance();
    }
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
    resolved.push_back(op);
    return WalkResult::advance();
  });
  if (result.wasInterrupted())
    return failure();
  for (ParamOp op : resolved) {
    auto typed = op.getValueAttr();
    if (!typed)
      continue;
    OpBuilder builder(op);
    Value constant = arith::ConstantOp::create(builder, op.getLoc(),
                                               op.getResult().getType(), typed)
                         .getResult();
    op.getResult().replaceAllUsesWith(constant);
    op.erase();
  }
  return success();
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

static SmallVector<Value> cloneLoopBody(PatternRewriter &rewriter,
                                        Region &region, Value iv,
                                        ValueRange carriesIn) {
  Block &body = region.front();
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
    for (int64_t i : llvm::seq(tripCount))
      carries = emitForIteration(rewriter, op, *lb + i * *step, carries);
    rewriter.replaceOp(op, carries);
    return success();
  }
};

static Value constantIndex(OpBuilder &builder, Location loc, int64_t value) {
  return arith::ConstantIndexOp::create(builder, loc, value).getResult();
}

static Value addI(OpBuilder &builder, Location loc, Value lhs, Value rhs) {
  return arith::AddIOp::create(builder, loc, lhs, rhs).getResult();
}

static Value subI(OpBuilder &builder, Location loc, Value lhs, Value rhs) {
  return arith::SubIOp::create(builder, loc, lhs, rhs).getResult();
}

static Value mulI(OpBuilder &builder, Location loc, Value lhs, Value rhs) {
  return arith::MulIOp::create(builder, loc, lhs, rhs).getResult();
}

static Value divUI(OpBuilder &builder, Location loc, Value lhs, Value rhs) {
  return arith::DivUIOp::create(builder, loc, lhs, rhs).getResult();
}

static Value buildDynamicMainEnd(OpBuilder &builder, Location loc, Value lower,
                                 Value upper, Value step, Value unroll) {
  Value c0 = constantIndex(builder, loc, 0);
  Value c1 = constantIndex(builder, loc, 1);
  Value span = subI(builder, loc, upper, lower);
  Value stepMinusOne = subI(builder, loc, step, c1);
  Value tripCeil =
      divUI(builder, loc, addI(builder, loc, span, stepMinusOne), step);
  Value hasTrip = arith::CmpIOp::create(builder, loc, arith::CmpIPredicate::slt,
                                        lower, upper)
                      .getResult();
  Value trip =
      arith::SelectOp::create(builder, loc, hasTrip, tripCeil, c0).getResult();
  Value chunks = divUI(builder, loc, trip, unroll);
  Value mainTrip = mulI(builder, loc, chunks, unroll);
  return addI(builder, loc, lower, mulI(builder, loc, mainTrip, step));
}

static Value buildMainEnd(OpBuilder &builder, Location loc, Value lower,
                          Value upper, Value step, Value unroll) {
  std::optional<int64_t> lb = getConstantIntValue(lower);
  std::optional<int64_t> ub = getConstantIntValue(upper);
  std::optional<int64_t> st = getConstantIntValue(step);
  std::optional<int64_t> ur = getConstantIntValue(unroll);
  if (!lb || !ub || !st || !ur || *st <= 0 || *ur <= 0)
    return buildDynamicMainEnd(builder, loc, lower, upper, step, unroll);
  int64_t span = *ub - *lb;
  int64_t trip = span <= 0 ? 0 : (span + *st - 1) / *st;
  int64_t mainTrip = (trip / *ur) * *ur;
  return constantIndex(builder, loc, *lb + mainTrip * *st);
}

static Value buildMainStep(OpBuilder &builder, Location loc, Value step,
                           Value unroll) {
  std::optional<int64_t> st = getConstantIntValue(step);
  std::optional<int64_t> ur = getConstantIntValue(unroll);
  if (!st || !ur)
    return mulI(builder, loc, step, unroll);
  return constantIndex(builder, loc, *st * *ur);
}

static void createStaticForBody(PatternRewriter &rewriter, StaticForOp loop,
                                Region &srcBody, Value baseIv, Value step) {
  Location loc = loop.getLoc();
  SmallVector<Type> argTypes;
  argTypes.push_back(rewriter.getIndexType());
  llvm::append_range(argTypes, loop.getResultTypes());
  SmallVector<Location> argLocs(argTypes.size(), loc);
  Block *body = rewriter.createBlock(&loop.getBody(), loop.getBody().end(),
                                     argTypes, argLocs);

  rewriter.setInsertionPointToStart(body);
  Value offset = mulI(rewriter, loc, body->getArgument(0), step);
  Value logicalIv = addI(rewriter, loc, baseIv, offset);
  SmallVector<Value> yielded = cloneLoopBody(rewriter, srcBody, logicalIv,
                                             body->getArguments().drop_front());
  YieldOp::create(rewriter, loc, yielded);
}

struct UnrolledForLower : OpRewritePattern<UnrolledForOp> {
  using OpRewritePattern::OpRewritePattern;
  LogicalResult matchAndRewrite(UnrolledForOp op,
                                PatternRewriter &rewriter) const override {
    std::optional<int64_t> unroll = getConstantIntValue(op.getUnroll());
    std::optional<int64_t> step = getConstantIntValue(op.getStep());
    if (!unroll || *unroll <= 0 || (step && *step <= 0))
      return failure();

    Location loc = op.getLoc();
    Value c0 = constantIndex(rewriter, loc, 0);
    Value c1 = constantIndex(rewriter, loc, 1);
    Value mainEnd =
        buildMainEnd(rewriter, loc, op.getLowerBound(), op.getUpperBound(),
                     op.getStep(), op.getUnroll());
    Value mainStep = buildMainStep(rewriter, loc, op.getStep(), op.getUnroll());

    scf::ForOp mainFor = scf::ForOp::create(
        rewriter, loc, op.getLowerBound(), mainEnd, mainStep, op.getIterArgs());
    rewriter.setInsertionPointToStart(mainFor.getBody());
    StaticForOp staticFor =
        StaticForOp::create(rewriter, loc, op.getResultTypes(), c0,
                            op.getUnroll(), c1, mainFor.getRegionIterArgs());
    createStaticForBody(rewriter, staticFor, op.getBody(),
                        mainFor.getInductionVar(), op.getStep());
    if (!op.getResultTypes().empty()) {
      rewriter.setInsertionPointAfter(staticFor);
      scf::YieldOp::create(rewriter, loc, staticFor.getResults());
    }

    rewriter.setInsertionPointAfter(mainFor);
    scf::ForOp tailFor =
        scf::ForOp::create(rewriter, loc, mainEnd, op.getUpperBound(),
                           op.getStep(), mainFor.getResults());
    rewriter.setInsertionPointToStart(tailFor.getBody());
    SmallVector<Value> yielded =
        cloneLoopBody(rewriter, op.getBody(), tailFor.getInductionVar(),
                      tailFor.getRegionIterArgs());
    if (!yielded.empty())
      scf::YieldOp::create(rewriter, loc, yielded);

    rewriter.replaceOp(op, tailFor.getResults());
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
  patterns.add<StaticIfFold, StaticForUnroll, UnrolledForLower, BroadcastExpand,
               TupleSetFold>(patterns.getContext());
}

//===----------------------------------------------------------------------===//
// Phase 3: type-converter-driven ptuple decomposition.
//===----------------------------------------------------------------------===//

// Converter rule for `!wavemeta.ptuple<T, W>`:
// - Concrete non-negative W: recursively convert T, then emit
//   `W` copies of that decomposed list. Nested
//   `ptuple<ptuple<af, M>, K>` collapses to `K * M` flat scalars in
//   one shot.
// - Parameter-named W: keep as-is so structural ops stay legal; the
//   residual phase will then point at whatever still holds it.
class PTupleTypeConverter : public TypeConverter {
public:
  PTupleTypeConverter() {
    addConversion([](Type t) { return t; });
    addConversion([this](PTupleType t, SmallVectorImpl<Type> &out) {
      return convertPTuple(t, out);
    });
    addSourceMaterialization([this](OpBuilder &builder, PTupleType resTy,
                                    ValueRange inputs, Location loc) {
      return rebuildPTuple(builder, loc, resTy, inputs);
    });
    addTargetMaterialization([this](OpBuilder &builder, TypeRange resTys,
                                    ValueRange inputs, Location loc, Type) {
      return projectPTuple(builder, loc, resTys, inputs);
    });
  }

private:
  LogicalResult convertPTuple(PTupleType t, SmallVectorImpl<Type> &out) const {
    auto width = dyn_cast<IntegerAttr>(t.getWidth());
    if (!width || width.getInt() < 0) {
      out.push_back(t);
      return success();
    }
    SmallVector<Type> elementTypes;
    if (failed(convertType(t.getElementType(), elementTypes)))
      return failure();
    for ([[maybe_unused]] int64_t i : llvm::seq(width.getInt()))
      out.append(elementTypes);
    return success();
  }

  // Rebuild a (possibly nested) ptuple from already-flat scalars by
  // chunking by the inner-converted size and recursing.
  Value rebuildPTuple(OpBuilder &builder, Location loc, PTupleType resTy,
                      ValueRange inputs) const {
    auto width = dyn_cast<IntegerAttr>(resTy.getWidth());
    if (!width || width.getInt() < 0)
      return Value();
    int64_t n = width.getInt();
    Type elementType = resTy.getElementType();
    auto innerPt = dyn_cast<PTupleType>(elementType);
    if (!innerPt) {
      if (static_cast<int64_t>(inputs.size()) != n)
        return Value();
      return TupleMakeOp::create(builder, loc, resTy, inputs).getResult();
    }
    SmallVector<Type> innerDecomp;
    if (failed(convertType(elementType, innerDecomp)))
      return Value();
    int64_t innerSize = static_cast<int64_t>(innerDecomp.size());
    if (innerSize == 0 || static_cast<int64_t>(inputs.size()) != n * innerSize)
      return Value();
    SmallVector<Value> innerPtuples;
    innerPtuples.reserve(n);
    for (int64_t i : llvm::seq(n)) {
      Value inner = materializeSourceConversion(
          builder, loc, innerPt, inputs.slice(i * innerSize, innerSize));
      if (!inner)
        return Value();
      innerPtuples.push_back(inner);
    }
    return TupleMakeOp::create(builder, loc, resTy, innerPtuples).getResult();
  }

  // Project a still-ptuple value to its converted slots: one level
  // of `tuple_get`s, then recurse on any still-ptuple inner type.
  // Emit one level of `tuple_get`s extracting all `n` slots.
  SmallVector<Value> projectOneLevel(OpBuilder &builder, Location loc,
                                     Value tuple, Type elementType,
                                     int64_t n) const {
    SmallVector<Value> out;
    out.reserve(n);
    for (int64_t i : llvm::seq(n)) {
      Value idx = arith::ConstantIndexOp::create(builder, loc, i);
      out.push_back(TupleGetOp::create(builder, loc, elementType, tuple, idx)
                        .getResult());
    }
    return out;
  }

  // Project each still-ptuple value to its further decomposed scalars
  // via recursive target materialisation; flatten the result.
  SmallVector<Value> projectNested(OpBuilder &builder, Location loc,
                                   ValueRange firstLevel,
                                   TypeRange innerDecomp) const {
    SmallVector<Value> out;
    out.reserve(firstLevel.size() * innerDecomp.size());
    for (Value v : firstLevel) {
      SmallVector<Value> sub =
          materializeTargetConversion(builder, loc, innerDecomp, ValueRange{v});
      if (sub.empty())
        return {};
      out.append(sub);
    }
    return out;
  }

  SmallVector<Value> projectPTuple(OpBuilder &builder, Location loc,
                                   TypeRange resTys, ValueRange inputs) const {
    if (inputs.size() != 1)
      return {};
    Value tuple = inputs.front();
    auto tupleTy = dyn_cast<PTupleType>(tuple.getType());
    auto width =
        tupleTy ? dyn_cast<IntegerAttr>(tupleTy.getWidth()) : IntegerAttr();
    if (!width || width.getInt() < 0)
      return {};
    int64_t n = width.getInt();
    Type elementType = tupleTy.getElementType();
    SmallVector<Value> firstLevel =
        projectOneLevel(builder, loc, tuple, elementType, n);
    if (!isa<PTupleType>(elementType))
      return static_cast<int64_t>(resTys.size()) == n ? firstLevel
                                                      : SmallVector<Value>{};
    SmallVector<Type> innerDecomp;
    if (failed(convertType(elementType, innerDecomp)) ||
        static_cast<int64_t>(resTys.size()) !=
            n * static_cast<int64_t>(innerDecomp.size()))
      return {};
    return projectNested(builder, loc, firstLevel, innerDecomp);
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

// `tuple_get` whose tuple crossed a boundary: pick the slice at the
// constant index from the adaptor's flattened operand list. For
// nested ptuples the source decomposes to `width * inner_count`
// scalars and the result decomposes to `inner_count` scalars; slice
// `[idx * inner_count, (idx + 1) * inner_count)` and replace 1-to-N.
struct TupleGetDecompose : OpConversionPattern<TupleGetOp> {
  using OpConversionPattern::OpConversionPattern;
  LogicalResult
  matchAndRewrite(TupleGetOp op, OneToNOpAdaptor adaptor,
                  ConversionPatternRewriter &rewriter) const override {
    std::optional<int64_t> idx = getConstantIntValue(op.getIndex());
    if (!idx)
      return failure();
    auto tupleTy = cast<PTupleType>(op.getTuple().getType());
    auto width = dyn_cast<IntegerAttr>(tupleTy.getWidth());
    if (!width || width.getInt() < 0)
      return failure();
    int64_t n = width.getInt();
    if (*idx < 0 || *idx >= n)
      return failure();
    ValueRange tupleScalars = adaptor.getTuple();
    int64_t totalScalars = static_cast<int64_t>(tupleScalars.size());
    if (totalScalars == 0 || totalScalars % n != 0)
      return failure();
    int64_t inner = totalScalars / n;
    ValueRange slice = tupleScalars.slice(*idx * inner, inner);
    rewriter.replaceOpWithMultiple(op, {slice});
    return success();
  }
};

// `tuple_set`: replicate the scalar list with one slot updated. For
// nested ptuples the slot itself decomposes to `inner` scalars, so
// splice the converted value's scalar range into the matching window
// of the carried tuple.
struct TupleSetDecompose : OpConversionPattern<TupleSetOp> {
  using OpConversionPattern::OpConversionPattern;
  LogicalResult
  matchAndRewrite(TupleSetOp op, OneToNOpAdaptor adaptor,
                  ConversionPatternRewriter &rewriter) const override {
    std::optional<int64_t> idx = getConstantIntValue(op.getIndex());
    if (!idx)
      return failure();
    auto tupleTy = cast<PTupleType>(op.getTuple().getType());
    auto width = dyn_cast<IntegerAttr>(tupleTy.getWidth());
    if (!width || width.getInt() < 0)
      return failure();
    int64_t n = width.getInt();
    if (*idx < 0 || *idx >= n)
      return failure();
    ValueRange tupleScalars = adaptor.getTuple();
    ValueRange valueScalars = adaptor.getValue();
    int64_t total = static_cast<int64_t>(tupleScalars.size());
    if (total == 0 || total % n != 0)
      return failure();
    int64_t inner = total / n;
    if (static_cast<int64_t>(valueScalars.size()) != inner)
      return failure();
    SmallVector<Value> replacements(tupleScalars.begin(), tupleScalars.end());
    for (int64_t k = 0; k < inner; ++k)
      replacements[*idx * inner + k] = valueScalars[k];
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
  if (isa<UnrolledForOp>(op)) {
    op->emitOpError("unrolled_for needs a positive constant unroll factor");
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
