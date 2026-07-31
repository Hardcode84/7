//===- WaveAMDMachineLoopCarryPlan.cpp - scf.for carry planning -*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "WaveAMDMachineLoopCarryPlan.h"

#include "mlir/Dialect/Utils/StaticValueUtils.h"
#include "llvm/ADT/DenseSet.h"
#include "llvm/Support/CheckedArithmetic.h"

using namespace mlir;
using namespace mlir::wave;
using namespace mlir::waveamd;
using namespace mlir::wave::wmsel;

namespace mlir::wave::wmsel {

namespace {

static std::string makeLoopSymbol(WaveAMDMachineSelector &S, StringRef stem) {
  return (Twine("__wave_loop_") + stem + "_" + Twine(S.nextLabel++)).str();
}

static constexpr int64_t u32Max = (int64_t{1} << 32) - 1;

static bool cachedSlotFitsU32(WaveAMDMachineSelector &S,
                              sym::Analysis &analysis, sym::ExprHandle expr,
                              ArrayRef<sym::PredHandle> assumptions) {
  SlotFitsU32CacheKey key = {
      expr, llvm::hash_combine_range(assumptions.begin(), assumptions.end())};
  SmallVector<SlotFitsU32CacheEntry, 1> &entries = S.slotFitsU32Cache[key];
  for (const SlotFitsU32CacheEntry &entry : entries)
    if (llvm::equal(entry.assumptions, assumptions))
      return entry.fits;

  bool fits = S.slotFitsU32(analysis, expr);
  SlotFitsU32CacheEntry &entry = entries.emplace_back();
  llvm::append_range(entry.assumptions, assumptions);
  entry.fits = fits;
  return fits;
}

static std::optional<int64_t> proveU32Upper(WaveAMDMachineSelector &S,
                                            sym::Analysis &analysis,
                                            const PointerOffset &offset) {
  if (!offset.expr)
    return int64_t{0};
  std::optional<sym::InferredRange> range = analysis.range(offset.expr);
  if (range && range->lower && range->upper &&
      sym::compareEndpointToInteger(*range->lower, 0) >= 0 &&
      sym::compareEndpointToInteger(*range->upper, u32Max) <= 0)
    if (std::optional<int64_t> upper = sym::ceilEndpoint(*range->upper))
      return *upper;
  if (cachedSlotFitsU32(S, analysis, offset.expr, offset.assumptions))
    return u32Max;
  return std::nullopt;
}

static bool isDefinedInside(Operation *scope, Value value) {
  if (Operation *def = value.getDefiningOp())
    return scope->isAncestor(def);
  Region *region = cast<BlockArgument>(value).getOwner()->getParent();
  while (region) {
    Operation *parent = region->getParentOp();
    if (!parent)
      return false;
    if (parent == scope)
      return true;
    region = parent->getParentRegion();
  }
  return false;
}

static bool isLaneVaryingValue(Type type) { return isa<SimdType>(type); }

static LogicalResult appendStrideImm(StrideBytes &stride, int64_t value) {
  std::optional<int64_t> sum = llvm::checkedAdd(stride.imm, value);
  if (!sum)
    return failure();
  stride.imm = *sum;
  return success();
}

static LogicalResult appendStrideTerm(StrideBytes &stride, Value value,
                                      int64_t scale) {
  for (StrideTerm &term : stride.terms) {
    if (term.value != value)
      continue;
    std::optional<int64_t> sum = llvm::checkedAdd(term.scale, scale);
    if (!sum)
      return failure();
    term.scale = *sum;
    return success();
  }
  stride.terms.push_back({value, scale});
  return success();
}

static bool samePointerBinding(const PointerOffsetBinding &lhs,
                               const PointerOffsetBinding &rhs) {
  return lhs.name == rhs.name && lhs.value == rhs.value && lhs.kind == rhs.kind;
}

static bool samePointerBindings(ArrayRef<PointerOffsetBinding> lhs,
                                ArrayRef<PointerOffsetBinding> rhs) {
  return lhs.size() == rhs.size() &&
         llvm::all_of(llvm::zip(lhs, rhs), [](auto pair) {
           return samePointerBinding(std::get<0>(pair), std::get<1>(pair));
         });
}

static bool samePreds(ArrayRef<sym::PredHandle> lhs,
                      ArrayRef<sym::PredHandle> rhs) {
  return lhs.size() == rhs.size() &&
         llvm::all_of(llvm::zip(lhs, rhs), [](auto pair) {
           return std::get<0>(pair) == std::get<1>(pair);
         });
}

static bool samePointerOffset(const PointerOffset *lhs,
                              const PointerOffset *rhs) {
  if (static_cast<bool>(lhs) != static_cast<bool>(rhs))
    return false;
  return !lhs || (lhs->expr == rhs->expr &&
                  samePointerBindings(lhs->bindings, rhs->bindings) &&
                  samePreds(lhs->assumptions, rhs->assumptions));
}

static bool sameStrideTerms(ArrayRef<StrideTerm> lhs,
                            ArrayRef<StrideTerm> rhs) {
  return lhs.size() == rhs.size() &&
         llvm::all_of(llvm::zip(lhs, rhs), [](auto pair) {
           const StrideTerm &l = std::get<0>(pair);
           const StrideTerm &r = std::get<1>(pair);
           return l.value == r.value && l.scale == r.scale;
         });
}

static bool sameStride(const StrideBytes &lhs, const StrideBytes &rhs) {
  return lhs.imm == rhs.imm &&
         samePointerOffset(lhs.symbolic.get(), rhs.symbolic.get()) &&
         sameStrideTerms(lhs.terms, rhs.terms);
}

static LogicalResult appendPointerBindings(PointerOffset &dst,
                                           const PointerOffset &src) {
  for (const PointerOffsetBinding &binding : src.bindings) {
    auto it = llvm::find_if(dst.bindings, [&](const PointerOffsetBinding &old) {
      return old.name == binding.name;
    });
    if (it != dst.bindings.end()) {
      if (!samePointerBinding(*it, binding))
        return failure();
      continue;
    }
    dst.bindings.push_back(binding);
  }
  llvm::append_range(dst.assumptions, src.assumptions);
  return success();
}

static FailureOr<PointerOffset> scaleSymbolicStride(WaveAMDMachineSelector &S,
                                                    const PointerOffset &offset,
                                                    int64_t scale) {
  PointerOffset out = offset;
  if (!out.expr || scale == 1)
    return out;
  FailureOr<sym::ExprHandle> scaleExpr =
      sym::composeExprInt(S.symbolStore(), scale);
  if (failed(scaleExpr))
    return failure();
  FailureOr<sym::ExprHandle> scaled = sym::composeExprBinary(
      S.symbolStore(), out.expr, sym::ExprBinaryOp::Mul, *scaleExpr);
  if (failed(scaled))
    return failure();
  out.expr = *scaled;
  return out;
}

static PointerOffset &getSymbolicStride(StrideBytes &stride) {
  if (!stride.symbolic)
    stride.symbolic = std::make_shared<PointerOffset>();
  return *stride.symbolic;
}

static LogicalResult appendSymbolicStride(WaveAMDMachineSelector &S,
                                          StrideBytes &stride,
                                          const PointerOffset &offset) {
  PointerOffset &symbolic = getSymbolicStride(stride);
  if (failed(appendPointerBindings(symbolic, offset)))
    return failure();
  if (!offset.expr)
    return success();
  if (!symbolic.expr) {
    symbolic.expr = offset.expr;
    return success();
  }
  FailureOr<sym::ExprHandle> expr = sym::composeExprBinary(
      S.symbolStore(), symbolic.expr, sym::ExprBinaryOp::Add, offset.expr);
  if (failed(expr))
    return failure();
  symbolic.expr = *expr;
  return success();
}

static LogicalResult appendSymbolicStrideOffset(WaveAMDMachineSelector &S,
                                                StrideBytes &stride,
                                                const PointerOffset &offset,
                                                int64_t scale) {
  if (classifyPointerOffset(S, offset) == TermKind::Lane)
    return failure();
  FailureOr<PointerOffset> scaled = scaleSymbolicStride(S, offset, scale);
  if (failed(scaled))
    return failure();
  return appendSymbolicStride(S, stride, *scaled);
}

static std::optional<int64_t>
constantPtrOffsetElements(WaveAMDMachineSelector &S, Value source) {
  if (std::optional<int64_t> raw = getConstantIntValue(source))
    return raw;
  auto it = S.indexOffsets.find(source);
  if (it == S.indexOffsets.end() || !it->second.expr ||
      !it->second.bindings.empty())
    return std::nullopt;
  return sym::getIntegerLiteralValue(it->second.expr);
}

static LogicalResult appendPtrStrideOffset(WaveAMDMachineSelector &S,
                                           scf::ForOp op, StrideBytes &stride,
                                           Value source, int64_t scale) {
  if (std::optional<int64_t> raw = constantPtrOffsetElements(S, source)) {
    std::optional<int64_t> bytes = llvm::checkedMul(*raw, scale);
    if (!bytes)
      return failure();
    return appendStrideImm(stride, *bytes);
  }
  if (isLaneVaryingValue(source.getType()) || isDefinedInside(op, source))
    return failure();
  auto it = S.indexOffsets.find(source);
  if (it != S.indexOffsets.end())
    return appendSymbolicStrideOffset(S, stride, it->second, scale);
  return appendStrideTerm(stride, source, scale);
}

static TermKind loopCarryKind(TermKind kind) {
  return kind == TermKind::Lane ? TermKind::Lane : TermKind::Uniform;
}

static TermKind classifyIndexExprResult(WaveAMDMachineSelector &S,
                                        IndexExprOp op) {
  FailureOr<PointerOffset> offset = makePointerOffset(S, op);
  if (failed(offset))
    return TermKind::Lane;
  return classifyPointerOffset(S, *offset);
}

static Value getLoopCarryInit(scf::ForOp op, Value value) {
  for (auto [idx, iterArg] : llvm::enumerate(op.getRegionIterArgs()))
    if (value == iterArg)
      return op.getInitArgs()[idx];
  return {};
}

static TermKind classifyPointerYield(WaveAMDMachineSelector &S, scf::ForOp op,
                                     Value value, Value iterArg,
                                     TermKind iterKind) {
  if (value == iterArg)
    return iterKind;
  if (Value init = getLoopCarryInit(op, value)) {
    auto it = S.pointerIndexOffsets.find(init);
    return it == S.pointerIndexOffsets.end()
               ? TermKind::Lane
               : classifyPointerOffset(S, it->second);
  }
  if (auto cast = value.getDefiningOp<PtrCastOp>())
    return classifyPointerYield(S, op, cast.getSource(), iterArg, iterKind);
  if (auto add = value.getDefiningOp<PtrAddOp>()) {
    TermKind baseKind =
        classifyPointerYield(S, op, add.getBase(), iterArg, iterKind);
    TermKind offsetKind = isLaneVaryingValue(add.getOffset().getType())
                              ? TermKind::Lane
                              : TermKind::Uniform;
    if (auto index = add.getOffset().getDefiningOp<IndexExprOp>())
      offsetKind = classifyIndexExprResult(S, index);
    return std::max(baseKind, offsetKind);
  }
  auto it = S.pointerIndexOffsets.find(value);
  if (it != S.pointerIndexOffsets.end())
    return classifyPointerOffset(S, it->second);
  return TermKind::Lane;
}

static std::optional<int64_t>
constantPtrAdvanceBytes(WaveAMDMachineSelector &S, Value value, Value iterArg) {
  Value cur = value;
  int64_t elems = 0;
  while (auto add = cur.getDefiningOp<PtrAddOp>()) {
    std::optional<int64_t> off = constantPtrOffsetElements(S, add.getOffset());
    if (!off)
      return std::nullopt;
    std::optional<int64_t> next = llvm::checkedAdd(elems, *off);
    if (!next)
      return std::nullopt;
    elems = *next;
    cur = add.getBase();
  }
  if (cur != iterArg)
    return std::nullopt;
  return llvm::checkedMul(
      elems, static_cast<int64_t>(S.elementSizeBytes(iterArg.getType())));
}

struct AbsolutePointerOffset {
  PointerOffset byteOffset;
  Value base;
};

enum class AbsolutePointerFailure {
  None,
  Unsupported,
  CrossCarry,
  BaseMismatch,
  LaneVarying,
  Unbounded,
  Negative,
  Overflow,
};

struct AbsolutePointerProof {
  std::optional<int64_t> upper;
  AbsolutePointerFailure failure = AbsolutePointerFailure::Unsupported;
};

static FailureOr<PointerOffset>
getPointerElementOffset(WaveAMDMachineSelector &S, Value value) {
  if (auto it = S.indexOffsets.find(value); it != S.indexOffsets.end())
    return it->second;
  if (auto indexExpr = value.getDefiningOp<IndexExprOp>())
    return makePointerOffset(S, indexExpr);
  std::optional<int64_t> constant = getConstantIntValue(value);
  if (!constant)
    return failure();
  FailureOr<sym::ExprHandle> expr =
      sym::composeExprInt(S.symbolStore(), *constant);
  if (failed(expr))
    return failure();
  PointerOffset offset;
  offset.expr = *expr;
  return offset;
}

static std::optional<AbsolutePointerOffset>
getSelectedAbsolutePointerOffset(WaveAMDMachineSelector &S, Value value) {
  auto baseIt = S.pointerBases.find(value);
  auto offsetIt = S.pointerIndexOffsets.find(value);
  if (baseIt == S.pointerBases.end() || offsetIt == S.pointerIndexOffsets.end())
    return std::nullopt;
  return AbsolutePointerOffset{offsetIt->second, baseIt->second};
}

static FailureOr<AbsolutePointerOffset>
getAbsolutePointerOffset(WaveAMDMachineSelector &S, scf::ForOp op, Value value,
                         Value expectedIterArg, bool &crossCarry,
                         bool allowLoopCarryInit = true);

static FailureOr<AbsolutePointerOffset>
getAbsolutePointerAddOffset(WaveAMDMachineSelector &S, scf::ForOp op,
                            PtrAddOp add, Value expectedIterArg,
                            bool &crossCarry) {
  FailureOr<AbsolutePointerOffset> base = getAbsolutePointerOffset(
      S, op, add.getBase(), expectedIterArg, crossCarry, false);
  FailureOr<PointerOffset> elements =
      getPointerElementOffset(S, add.getOffset());
  if (failed(base) || failed(elements))
    return failure();
  FailureOr<PointerOffset> bytes = scalePointerOffset(
      S, *elements, S.elementSizeBytes(add.getBase().getType()));
  if (failed(bytes))
    return failure();
  FailureOr<PointerOffset> merged =
      mergePointerOffsets(S, base->byteOffset, *bytes);
  if (failed(merged))
    return failure();
  return AbsolutePointerOffset{std::move(*merged), base->base};
}

static FailureOr<AbsolutePointerOffset>
getAbsolutePointerOffset(WaveAMDMachineSelector &S, scf::ForOp op, Value value,
                         Value expectedIterArg, bool &crossCarry,
                         bool allowLoopCarryInit) {
  if (std::optional<AbsolutePointerOffset> selected =
          getSelectedAbsolutePointerOffset(S, value))
    return std::move(*selected);

  if (Value init = getLoopCarryInit(op, value)) {
    if (!allowLoopCarryInit) {
      crossCarry = value != expectedIterArg;
      return failure();
    }
    return getAbsolutePointerOffset(S, op, init, expectedIterArg, crossCarry,
                                    false);
  }

  if (auto cast = value.getDefiningOp<PtrCastOp>())
    return getAbsolutePointerOffset(S, op, cast.getSource(), expectedIterArg,
                                    crossCarry, allowLoopCarryInit);

  auto add = value.getDefiningOp<PtrAddOp>();
  if (!add)
    return failure();
  return getAbsolutePointerAddOffset(S, op, add, expectedIterArg, crossCarry);
}

static AbsolutePointerFailure
classifyAbsolutePointerRangeFailure(sym::Analysis &analysis,
                                    sym::ExprHandle expr) {
  std::optional<sym::InferredRange> range = analysis.range(expr);
  if (range && range->lower &&
      sym::compareEndpointToInteger(*range->lower, 0) < 0)
    return AbsolutePointerFailure::Negative;
  if (range && range->upper &&
      sym::compareEndpointToInteger(*range->upper, u32Max) > 0)
    return AbsolutePointerFailure::Overflow;
  return AbsolutePointerFailure::Unbounded;
}

static AbsolutePointerProof
proveResolvedAbsolutePointerOffsetU32(WaveAMDMachineSelector &S,
                                      const AbsolutePointerOffset &absolute,
                                      Value expectedBase) {
  if (absolute.base != expectedBase)
    return {{}, AbsolutePointerFailure::BaseMismatch};
  if (classifyPointerOffset(S, absolute.byteOffset) == TermKind::Lane)
    return {{}, AbsolutePointerFailure::LaneVarying};
  if (!absolute.byteOffset.expr)
    return {int64_t{0}, AbsolutePointerFailure::None};
  FailureOr<std::unique_ptr<sym::Analysis>> analysis =
      sym::Analysis::create(S.symbolStore(), absolute.byteOffset.assumptions);
  if (failed(analysis))
    return {{}, AbsolutePointerFailure::Unbounded};
  if (std::optional<int64_t> upper =
          proveU32Upper(S, **analysis, absolute.byteOffset))
    return {upper, AbsolutePointerFailure::None};
  return {{},
          classifyAbsolutePointerRangeFailure(**analysis,
                                              absolute.byteOffset.expr)};
}

static AbsolutePointerProof
proveAbsolutePointerOffsetU32(WaveAMDMachineSelector &S, scf::ForOp op,
                              Value value, Value iterArg, Value expectedBase) {
  bool crossCarry = false;
  FailureOr<AbsolutePointerOffset> absolute =
      getAbsolutePointerOffset(S, op, value, iterArg, crossCarry);
  if (failed(absolute))
    return {{},
            crossCarry ? AbsolutePointerFailure::CrossCarry
                       : AbsolutePointerFailure::Unsupported};
  return proveResolvedAbsolutePointerOffsetU32(S, *absolute, expectedBase);
}

static InFlightDiagnostic
emitAbsolutePointerFailure(scf::ForOp op, AbsolutePointerFailure failure) {
  switch (failure) {
  case AbsolutePointerFailure::CrossCarry:
    return op.emitError(
        "scf.for pointer carry cannot recur through another iter arg");
  case AbsolutePointerFailure::BaseMismatch:
    return op.emitError(
        "scf.for absolute pointer carry must preserve its selected base");
  case AbsolutePointerFailure::LaneVarying:
    return op.emitError(
        "scf.for absolute pointer carry offset must be uniform");
  case AbsolutePointerFailure::Negative:
    return op.emitError(
        "scf.for absolute pointer carry offset may be negative");
  case AbsolutePointerFailure::Overflow:
    return op.emitError(
        "scf.for absolute pointer carry offset may exceed unsigned 32-bit");
  case AbsolutePointerFailure::Unbounded:
    return op.emitError("scf.for absolute pointer carry offset needs explicit "
                        "unsigned 32-bit bounds");
  case AbsolutePointerFailure::None:
  case AbsolutePointerFailure::Unsupported:
    return op.emitError("scf.for pointer carry offset must fit proven "
                        "unsigned 32-bit for every iteration");
  }
  llvm_unreachable("unknown absolute pointer failure");
}

static LogicalResult
addTripCountAssumption(WaveAMDMachineSelector &S, scf::ForOp op, StringRef name,
                       SmallVectorImpl<sym::PredHandle> &assumptions) {
  if (std::optional<int64_t> upper = getConstantIntValue(op.getUpperBound())) {
    FailureOr<sym::PredHandle> range =
        sym::rangeAssumption(S.symbolStore(), name, *upper, *upper);
    if (failed(range))
      return failure();
    assumptions.push_back(*range);
    return success();
  }
  size_t oldSize = assumptions.size();
  S.appendBindingAssumptions(op.getUpperBound(), name, assumptions);
  if (assumptions.size() != oldSize)
    return success();
  return failure();
}

static std::optional<int64_t> constantTripCountUpper(scf::ForOp op) {
  std::optional<llvm::APInt> trip = op.getStaticTripCount();
  if (!trip || trip->getActiveBits() > 63)
    return std::nullopt;
  return static_cast<int64_t>(trip->getZExtValue());
}

static FailureOr<sym::ExprHandle>
appendStructuralExpr(WaveAMDMachineSelector &S, sym::ExprHandle lhs,
                     sym::ExprHandle rhs) {
  if (!lhs)
    return rhs;
  return sym::composeExprBinary(S.symbolStore(), lhs, sym::ExprBinaryOp::Add,
                                rhs);
}

static FailureOr<sym::ExprHandle> scaleStrideTerm(WaveAMDMachineSelector &S,
                                                  sym::ExprHandle expr,
                                                  int64_t scale) {
  if (scale == 1)
    return expr;
  FailureOr<sym::ExprHandle> scaleExpr =
      sym::composeExprInt(S.symbolStore(), scale);
  if (failed(scaleExpr))
    return failure();
  FailureOr<sym::ExprHandle> scaled = sym::composeExprBinary(
      S.symbolStore(), expr, sym::ExprBinaryOp::Mul, *scaleExpr);
  return scaled;
}

static LogicalResult appendStrideImmOffset(WaveAMDMachineSelector &S,
                                           PointerOffset &offset, int64_t imm) {
  if (imm == 0)
    return success();
  FailureOr<sym::ExprHandle> immExpr =
      sym::composeExprInt(S.symbolStore(), imm);
  if (failed(immExpr))
    return failure();
  FailureOr<sym::ExprHandle> expr =
      appendStructuralExpr(S, offset.expr, *immExpr);
  if (failed(expr))
    return failure();
  offset.expr = *expr;
  return success();
}

static LogicalResult appendStrideTermOffset(WaveAMDMachineSelector &S,
                                            PointerOffset &offset,
                                            const StrideTerm &term,
                                            StringRef nameStem) {
  std::string name = makeLoopSymbol(S, nameStem);
  FailureOr<sym::ExprHandle> sym = sym::composeExprSym(S.symbolStore(), name);
  if (failed(sym))
    return failure();
  offset.bindings.push_back({name, term.value, TermKind::Uniform});
  S.appendBindingAssumptions(term.value, name, offset.assumptions);
  FailureOr<sym::ExprHandle> scaled = scaleStrideTerm(S, *sym, term.scale);
  if (failed(scaled))
    return failure();
  FailureOr<sym::ExprHandle> expr =
      appendStructuralExpr(S, offset.expr, *scaled);
  if (failed(expr))
    return failure();
  offset.expr = *expr;
  return success();
}

static LogicalResult ensureStrideOffsetExpr(WaveAMDMachineSelector &S,
                                            PointerOffset &offset) {
  if (offset.expr)
    return success();
  FailureOr<sym::ExprHandle> zero =
      sym::composeExprInt(S.symbolStore(), int64_t{0});
  if (failed(zero))
    return failure();
  offset.expr = *zero;
  return success();
}

static FailureOr<PointerOffset> buildStrideOffset(WaveAMDMachineSelector &S,
                                                  const StrideBytes &stride,
                                                  StringRef nameStem) {
  PointerOffset offset;
  if (stride.symbolic)
    offset = *stride.symbolic;
  if (failed(appendStrideImmOffset(S, offset, stride.imm)))
    return failure();
  for (const StrideTerm &term : stride.terms)
    if (failed(appendStrideTermOffset(S, offset, term, nameStem)))
      return failure();
  if (failed(ensureStrideOffsetExpr(S, offset)))
    return failure();
  return offset;
}

enum class StrideExprForm { Proof, Materialization };

static LogicalResult selectStrideOffsetExpr(PointerOffset &offset,
                                            StrideExprForm form,
                                            sym::Analysis &analysis) {
  sym::ExprHandle materialization = offset.expr;
  FailureOr<sym::ExprHandle> expanded = analysis.expand(materialization);
  if (failed(expanded))
    return failure();
  sym::ExprHandle proof = *expanded;
  if (FailureOr<sym::ExprHandle> simplified = analysis.simplify(*expanded);
      succeeded(simplified))
    proof = *simplified;
  offset.expr = form == StrideExprForm::Proof ||
                        shouldUseSimplifiedIndexExpr(proof, materialization)
                    ? proof
                    : materialization;
  return success();
}

static bool strideFitsU32(WaveAMDMachineSelector &S,
                          const StrideBytes &stride) {
  FailureOr<PointerOffset> offset = buildStrideOffset(S, stride, "ptr_stride");
  if (failed(offset))
    return false;
  FailureOr<std::unique_ptr<sym::Analysis>> analysis =
      sym::Analysis::create(S.symbolStore(), offset->assumptions);
  return succeeded(analysis) &&
         succeeded(selectStrideOffsetExpr(*offset, StrideExprForm::Proof,
                                          **analysis)) &&
         offset->expr &&
         cachedSlotFitsU32(S, **analysis, offset->expr, offset->assumptions);
}

static bool isNormalizedUnitLoop(scf::ForOp op) {
  std::optional<int64_t> lo = getConstantIntValue(op.getLowerBound());
  std::optional<int64_t> step = getConstantIntValue(op.getStep());
  return lo && *lo == 0 && step && *step == 1;
}

static FailureOr<sym::ExprHandle>
buildTripCountUpperExpr(WaveAMDMachineSelector &S, scf::ForOp op,
                        SmallVectorImpl<sym::PredHandle> &assumptions) {
  if (std::optional<int64_t> trip = constantTripCountUpper(op))
    return sym::composeExprInt(S.symbolStore(), *trip);
  if (!isNormalizedUnitLoop(op))
    return failure();
  std::string tripName = makeLoopSymbol(S, "ptr_trip");
  if (failed(addTripCountAssumption(S, op, tripName, assumptions)))
    return failure();
  return sym::composeExprSym(S.symbolStore(), tripName);
}

static FailureOr<sym::ExprHandle>
buildAccumulatingCarryExpr(WaveAMDMachineSelector &S, scf::ForOp op,
                           const PointerOffset &offset, int64_t deltaBytes,
                           SmallVectorImpl<sym::PredHandle> &assumptions) {
  FailureOr<sym::ExprHandle> trip = buildTripCountUpperExpr(S, op, assumptions);
  FailureOr<sym::ExprHandle> delta =
      sym::composeExprInt(S.symbolStore(), deltaBytes);
  if (failed(trip) || failed(delta))
    return failure();
  FailureOr<sym::ExprHandle> advance = sym::composeExprBinary(
      S.symbolStore(), *trip, sym::ExprBinaryOp::Mul, *delta);
  if (failed(advance))
    return failure();
  return appendStructuralExpr(S, offset.expr, *advance);
}

static sym::Analysis *
getAccumulatingAnalysis(WaveAMDMachineSelector &S, const PointerOffset &offset,
                        sym::Analysis *analysis,
                        std::unique_ptr<sym::Analysis> &ownedAnalysis) {
  if (analysis)
    return analysis;
  FailureOr<std::unique_ptr<sym::Analysis>> created =
      sym::Analysis::create(S.symbolStore(), offset.assumptions);
  if (failed(created))
    return nullptr;
  ownedAnalysis = std::move(*created);
  return ownedAnalysis.get();
}

static bool entryOffsetFitsU32(WaveAMDMachineSelector &S,
                               const PointerOffset &offset,
                               sym::Analysis &analysis) {
  return !offset.expr ||
         cachedSlotFitsU32(S, analysis, offset.expr, offset.assumptions);
}

static bool accumulatedOffsetFitsU32(WaveAMDMachineSelector &S,
                                     const PointerOffset &offset,
                                     sym::Analysis &analysis,
                                     sym::ExprHandle total,
                                     ArrayRef<sym::PredHandle> assumptions) {
  if (failed(
          analysis.assume(assumptions.drop_front(offset.assumptions.size()))))
    return false;

  sym::ExprHandle proof = total;
  if (offset.expr)
    if (FailureOr<sym::ExprHandle> simplified = analysis.simplify(proof);
        succeeded(simplified))
      proof = *simplified;
  return cachedSlotFitsU32(S, analysis, proof, assumptions);
}

static bool proveAccumulatingCarryFitsU32(WaveAMDMachineSelector &S,
                                          scf::ForOp op,
                                          const PointerOffset &offset,
                                          int64_t deltaBytes,
                                          sym::Analysis *analysis) {
  if (!offset.expr && deltaBytes <= 0)
    return deltaBytes == 0;

  SmallVector<sym::PredHandle, 4> assumptions(offset.assumptions.begin(),
                                              offset.assumptions.end());
  FailureOr<sym::ExprHandle> total = failure();
  if (deltaBytes > 0) {
    total = buildAccumulatingCarryExpr(S, op, offset, deltaBytes, assumptions);
    if (failed(total))
      return false;
  }

  std::unique_ptr<sym::Analysis> ownedAnalysis;
  analysis = getAccumulatingAnalysis(S, offset, analysis, ownedAnalysis);
  if (!analysis)
    return false;
  if (!entryOffsetFitsU32(S, offset, *analysis))
    return false;
  if (deltaBytes <= 0)
    return deltaBytes == 0;
  return accumulatedOffsetFitsU32(S, offset, *analysis, *total, assumptions);
}

static LogicalResult proveLoopCarryFitsU32(WaveAMDMachineSelector &S,
                                           scf::ForOp op,
                                           const PointerOffset &offset,
                                           Value yieldValue, Value iterArg,
                                           CarrySnapshot &snap) {
  std::unique_ptr<sym::Analysis> analysis;
  std::optional<int64_t> entryUpper = int64_t{0};
  if (offset.expr) {
    FailureOr<std::unique_ptr<sym::Analysis>> created =
        sym::Analysis::create(S.symbolStore(), offset.assumptions);
    if (succeeded(created)) {
      analysis = std::move(*created);
      entryUpper = proveU32Upper(S, *analysis, offset);
    } else {
      entryUpper = std::nullopt;
    }
  }
  if (!entryUpper)
    return op.emitError(
        "scf.for pointer carry offset must fit proven unsigned 32-bit");

  if (hasStride(snap.stride)) {
    snap.bodyU32Upper = entryUpper;
    snap.resultU32Upper = entryUpper;
    return success();
  }

  AbsolutePointerProof absolute =
      proveAbsolutePointerOffsetU32(S, op, yieldValue, iterArg, snap.base);
  if (absolute.upper) {
    int64_t carryUpper = std::max(*entryUpper, *absolute.upper);
    snap.bodyU32Upper = carryUpper;
    snap.resultU32Upper = carryUpper;
    return success();
  }

  std::optional<int64_t> advance =
      constantPtrAdvanceBytes(S, yieldValue, iterArg);
  if (!advance ||
      !proveAccumulatingCarryFitsU32(S, op, offset, *advance, analysis.get()))
    return emitAbsolutePointerFailure(op, absolute.failure);

  snap.bodyU32Upper = u32Max;
  snap.resultU32Upper = u32Max;
  return success();
}

static std::optional<StrideBytes> stridedCarryBytes(WaveAMDMachineSelector &S,
                                                    scf::ForOp op, unsigned i) {
  Value arg = op.getRegionIterArgs()[i];
  Value y = cast<scf::YieldOp>(op.getBody()->getTerminator()).getOperand(i);
  if (std::optional<int64_t> bytes = constantPtrAdvanceBytes(S, y, arg))
    if (*bytes > 0 && *bytes <= u32Max) {
      StrideBytes stride;
      stride.imm = *bytes;
      return stride;
    }
  int64_t scale = static_cast<int64_t>(S.elementSizeBytes(arg.getType()));
  StrideBytes stride;
  while (auto add = y.getDefiningOp<PtrAddOp>()) {
    if (failed(appendPtrStrideOffset(S, op, stride, add.getOffset(), scale)))
      return std::nullopt;
    y = add.getBase();
  }
  if (y != arg || !hasStride(stride) || !strideFitsU32(S, stride))
    return std::nullopt;
  return stride;
}

static bool canUseStridedCarry(scf::ForOp op, unsigned idx, bool strideInOffset,
                               const StrideBytes &stride) {
  if (!strideInOffset)
    return true;
  if (!isImmediateStride(stride))
    return false;
  return isNormalizedUnitLoop(op) && op.getResult(idx).use_empty();
}

static FailureOr<Value> materializeDynamicStride(WaveAMDMachineSelector &S,
                                                 Operation *user,
                                                 const StrideBytes &stride) {
  FailureOr<PointerOffset> offset =
      buildStrideOffset(S, stride, "ptr_stride_value");
  if (failed(offset))
    return failure();
  FailureOr<std::unique_ptr<sym::Analysis>> analysis =
      sym::Analysis::create(S.symbolStore(), offset->assumptions);
  if (failed(analysis) ||
      failed(selectStrideOffsetExpr(*offset, StrideExprForm::Materialization,
                                    **analysis)))
    return failure();
  FailureOr<Value> value = materializePointerOffsetValue(S, user, *offset);
  if (failed(value))
    return failure();
  return S.ensureSGPR1(user->getLoc(), *value);
}

static FailureOr<int64_t>
getStridedBaseGroup(WaveAMDMachineSelector &S, scf::ForOp op,
                    SmallVectorImpl<StridedBaseCarry> &groups, Value base,
                    Value pointerBase, const StrideBytes &stride) {
  for (auto [idx, group] : llvm::enumerate(groups))
    if (group.base == base && group.pointerBase == pointerBase &&
        sameStride(group.stride, stride))
      return static_cast<int64_t>(idx);
  Value byteStride;
  if (!isImmediateStride(stride)) {
    FailureOr<Value> materialized = materializeDynamicStride(S, op, stride);
    if (failed(materialized))
      return failure();
    byteStride = *materialized;
  }
  groups.push_back(StridedBaseCarry{
      stride, base, pointerBase, {}, {}, {}, {}, {}, byteStride});
  return static_cast<int64_t>(groups.size() - 1);
}

static StrideBytes selectStridedCarry(WaveAMDMachineSelector &S, scf::ForOp op,
                                      unsigned idx, Value initArg,
                                      bool strideInOffset) {
  std::optional<StrideBytes> stride = stridedCarryBytes(S, op, idx);
  if (!stride || !canUseStridedCarry(op, idx, strideInOffset, *stride))
    return {};
  return std::move(*stride);
}

static bool reachesDmaLoadLds(Value pointer) {
  SmallVector<Value, 8> pending = {pointer};
  llvm::DenseSet<Value> visited;
  while (!pending.empty()) {
    Value current = pending.pop_back_val();
    if (!visited.insert(current).second)
      continue;
    for (Operation *user : current.getUsers()) {
      if (auto dma = dyn_cast<waveamd::DmaLoadLdsOp>(user)) {
        if (dma.getSource() == current)
          return true;
        continue;
      }
      if (auto add = dyn_cast<PtrAddOp>(user)) {
        if (add.getBase() == current)
          pending.push_back(add.getResult());
        continue;
      }
      if (auto cast = dyn_cast<PtrCastOp>(user))
        if (cast.getSource() == current)
          pending.push_back(cast.getResult());
    }
  }
  return false;
}

static LogicalResult
attachStridedBaseGroup(WaveAMDMachineSelector &S, scf::ForOp op,
                       SmallVectorImpl<StridedBaseCarry> &groups,
                       CarrySnapshot &snap) {
  if (!hasStride(snap.stride) || snap.strideInOffset)
    return success();
  Value base = snap.isBuffer ? snap.globalBase : snap.base;
  Value pointerBase = snap.isBuffer ? snap.base : Value{};
  FailureOr<int64_t> group =
      getStridedBaseGroup(S, op, groups, base, pointerBase, snap.stride);
  if (failed(group))
    return failure();
  snap.stridedBaseGroup = *group;
  return success();
}

static LogicalResult
snapshotPointerScfCarry(WaveAMDMachineSelector &S, scf::ForOp op,
                        scf::YieldOp yield, unsigned idx, Value initArg,
                        SmallVectorImpl<StridedBaseCarry> &groups,
                        CarrySnapshot &snap) {
  auto baseIt = S.pointerBases.find(initArg);
  auto offsetIt = S.pointerIndexOffsets.find(initArg);
  if (baseIt == S.pointerBases.end() || offsetIt == S.pointerIndexOffsets.end())
    return op.emitError(
        "scf.for pointer iter arg has no WaveAMDMachine sidecar");
  TermKind initKind = classifyPointerOffset(S, offsetIt->second);
  bool isBuffer = S.pointerBuffers.lookup(initArg);
  bool dmaBufferBaseCarry = isBuffer && S.pointerGlobalBases.lookup(initArg) &&
                            reachesDmaLoadLds(op.getRegionIterArgs()[idx]);
  bool strideInOffset =
      S.isSharedPointer(initArg.getType()) || (isBuffer && !dmaBufferBaseCarry);
  StrideBytes stride = selectStridedCarry(S, op, idx, initArg, strideInOffset);
  TermKind yieldKind = hasStride(stride)
                           ? initKind
                           : classifyPointerYield(S, op, yield.getOperand(idx),
                                                  op.getRegionIterArgs()[idx],
                                                  loopCarryKind(initKind));
  TermKind carryKind = loopCarryKind(std::max(initKind, yieldKind));
  FailureOr<Value> carry =
      materializePointerOffsetCarry(S, op, offsetIt->second, carryKind);
  if (failed(carry))
    return failure();

  snap.kind = CarrySnapshot::Kind::Pointer;
  snap.carry = *carry;
  snap.base = baseIt->second;
  snap.globalBase = S.pointerGlobalBases.lookup(initArg);
  snap.stride = std::move(stride);
  snap.offsetKind = carryKind;
  snap.isBuffer = isBuffer;
  snap.strideInOffset = strideInOffset;
  if (failed(attachStridedBaseGroup(S, op, groups, snap)))
    return failure();
  snap.bodyOffsetName = makeLoopSymbol(S, "ptr_body");
  snap.resultOffsetName = makeLoopSymbol(S, "ptr_result");
  snap.strideName = makeLoopSymbol(S, "ptr_stride");
  return proveLoopCarryFitsU32(S, op, offsetIt->second, yield.getOperand(idx),
                               op.getRegionIterArgs()[idx], snap);
}

static std::optional<bool> indexOffsetCarryFitsU32(WaveAMDMachineSelector &S,
                                                   Value source) {
  auto it = S.indexOffsets.find(source);
  PointerOffset offset;
  if (it != S.indexOffsets.end()) {
    offset = it->second;
  } else if (IndexExprOp indexExpr = source.getDefiningOp<IndexExprOp>()) {
    FailureOr<PointerOffset> built = makePointerOffset(S, indexExpr);
    if (failed(built))
      return std::nullopt;
    offset = std::move(*built);
  } else {
    return std::nullopt;
  }
  return !offset.expr || S.slotFitsU32(offset.expr, offset.assumptions);
}

static bool needsWideImmediateCarry(WaveAMDMachineSelector &S, Value initArg,
                                    Value yielded) {
  Type type = initArg.getType();
  if (type.isIndex()) {
    if (std::optional<bool> fits = indexOffsetCarryFitsU32(S, initArg))
      return !*fits;
    if (std::optional<bool> fits = indexOffsetCarryFitsU32(S, yielded))
      return !*fits;
    return true;
  }
  if (IntegerType intType = dyn_cast<IntegerType>(type))
    return intType.getWidth() > 32;
  if (FloatType floatType = dyn_cast<FloatType>(type))
    return floatType.getWidth() > 32;
  if (waveamdmachine::RegType regType = dyn_cast<waveamdmachine::RegType>(type))
    return regType.getWidth() > 1;
  return false;
}

static bool hasNonInitUseInLoopBody(scf::ForOp op, Value value) {
  SmallVector<Value, 4> worklist{value};
  llvm::DenseSet<Value> visited;
  while (!worklist.empty()) {
    Value current = worklist.pop_back_val();
    if (!visited.insert(current).second)
      continue;
    if (AssumeOp assume = current.getDefiningOp<AssumeOp>())
      worklist.push_back(assume.getValue());
    for (OpOperand &use : current.getUses()) {
      Operation *user = use.getOwner();
      if (user == op.getOperation())
        continue;
      if (op.getBodyRegion().isAncestor(user->getParentRegion()))
        return true;
      if (AssumeOp assume = dyn_cast<AssumeOp>(user))
        worklist.push_back(assume.getResult());
    }
  }
  return false;
}

static Value copyDistinctLoopCarry(WaveAMDMachineSelector &S, Location loc,
                                   Value carry) {
  waveamdmachine::RegType regType =
      dyn_cast<waveamdmachine::RegType>(carry.getType());
  if (!regType)
    return carry;
  if (regType.getRegClass() != waveamdmachine::RegClass::SGPR &&
      regType.getRegClass() != waveamdmachine::RegClass::VGPR)
    return carry;
  Type resultType = getRegType(S.builder.getContext(), regType.getRegClass(),
                               regType.getWidth());
  return waveamdmachine::CopyTupleOp::create(S.builder, loc, resultType, carry)
      .getResult();
}

static Value materializeWMCarryInit(WaveAMDMachineSelector &S, scf::ForOp op,
                                    Value initArg, Value yielded) {
  Value carry = S.expect(initArg, op);
  if (needsWideImmediateCarry(S, initArg, yielded))
    carry = ensureSGPR2(S, op.getLoc(), carry);
  else if (isa<waveamdmachine::ImmType>(carry.getType()))
    carry = S.materializeSGPR1(op.getLoc(), carry);
  if (isa<SimdType>(initArg.getType())) {
    waveamdmachine::RegType regType =
        dyn_cast<waveamdmachine::RegType>(carry.getType());
    if (regType && regType.getRegClass() == waveamdmachine::RegClass::SGPR) {
      Type vgprType =
          getRegType(S.builder.getContext(), waveamdmachine::RegClass::VGPR,
                     regType.getWidth());
      carry = waveamdmachine::VMovB32TupleOp::create(S.builder, op.getLoc(),
                                                     vgprType, carry);
    }
  }
  if (hasNonInitUseInLoopBody(op, initArg))
    return copyDistinctLoopCarry(S, op.getLoc(), carry);
  return carry;
}

static LogicalResult
snapshotScfCarries(WaveAMDMachineSelector &S, scf::ForOp op,
                   SmallVectorImpl<CarrySnapshot> &out,
                   SmallVectorImpl<StridedBaseCarry> &groups) {
  out.reserve(op.getInitArgs().size());
  auto yield = cast<scf::YieldOp>(op.getBody()->getTerminator());
  for (auto [idx, initArg] : llvm::enumerate(op.getInitArgs())) {
    if (getWavePointerType(initArg.getType())) {
      CarrySnapshot snap;
      if (failed(snapshotPointerScfCarry(
              S, op, yield, static_cast<unsigned>(idx), initArg, groups, snap)))
        return failure();
      out.push_back(std::move(snap));
      continue;
    }
    CarrySnapshot snap;
    snap.kind = CarrySnapshot::Kind::WMValue;
    snap.carry = materializeWMCarryInit(S, op, initArg, yield.getOperand(idx));
    out.push_back(std::move(snap));
  }
  return success();
}

} // namespace

LogicalResult planScfForCarries(WaveAMDMachineSelector &S, scf::ForOp op,
                                ScfForCarryPlan &plan) {
  plan.snapshots.clear();
  plan.stridedBaseGroups.clear();
  return snapshotScfCarries(S, op, plan.snapshots, plan.stridedBaseGroups);
}

} // namespace mlir::wave::wmsel
