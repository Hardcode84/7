//===- WaveAMDMachineLoopCarryPlan.cpp - scf.for carry planning -*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "WaveAMDMachineLoopCarryPlan.h"

#include "mlir/Dialect/Utils/StaticValueUtils.h"
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

static std::optional<int64_t> proveU32Upper(WaveAMDMachineSelector &S,
                                            const PointerOffset &offset) {
  if (!offset.expr)
    return int64_t{0};
  if (std::optional<int64_t> upper = sym::inferNonNegativeUpperBound(
          S.symbolStore(), offset.expr, offset.assumptions, u32Max))
    return *upper;
  if (S.slotFitsU32(offset.expr, offset.assumptions))
    return u32Max;
  return std::nullopt;
}

static bool offsetFitsU32(WaveAMDMachineSelector &S,
                          const PointerOffset &offset) {
  return !offset.expr || S.slotFitsU32(offset.expr, offset.assumptions);
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

static FailureOr<sym::ExprHandle>
simplifyStrideExpr(WaveAMDMachineSelector &S, sym::ExprHandle expr,
                   ArrayRef<sym::PredHandle> assumptions) {
  FailureOr<sym::ExprHandle> simplified =
      sym::simplifyExpr(S.symbolStore(), expr, assumptions);
  return succeeded(simplified) ? *simplified : expr;
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
  FailureOr<sym::ExprHandle> expanded =
      sym::expandExpr(S.symbolStore(), *scaled);
  if (failed(expanded))
    return failure();
  FailureOr<sym::ExprHandle> simplified =
      simplifyStrideExpr(S, *expanded, out.assumptions);
  if (failed(simplified))
    return failure();
  out.expr = *simplified;
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
  FailureOr<sym::ExprHandle> simplified =
      simplifyStrideExpr(S, *expr, symbolic.assumptions);
  if (failed(simplified))
    return failure();
  symbolic.expr = *simplified;
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

static TermKind classifyPointerYield(WaveAMDMachineSelector &S, Value value,
                                     Value iterArg, TermKind iterKind) {
  if (value == iterArg)
    return iterKind;
  if (auto add = value.getDefiningOp<PtrAddOp>()) {
    TermKind baseKind =
        classifyPointerYield(S, add.getBase(), iterArg, iterKind);
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
appendExpr(WaveAMDMachineSelector &S, sym::ExprHandle lhs, sym::ExprHandle rhs,
           ArrayRef<sym::PredHandle> assumptions) {
  if (!lhs)
    return rhs;
  FailureOr<sym::ExprHandle> expr =
      sym::composeExprBinary(S.symbolStore(), lhs, sym::ExprBinaryOp::Add, rhs);
  if (failed(expr))
    return failure();
  FailureOr<sym::ExprHandle> simplified =
      sym::simplifyExpr(S.symbolStore(), *expr, assumptions);
  return succeeded(simplified) ? *simplified : *expr;
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
  if (failed(scaled))
    return failure();
  return sym::expandExpr(S.symbolStore(), *scaled);
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
      appendExpr(S, offset.expr, *immExpr, offset.assumptions);
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
      appendExpr(S, offset.expr, *scaled, offset.assumptions);
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

static bool strideFitsU32(WaveAMDMachineSelector &S,
                          const StrideBytes &stride) {
  FailureOr<PointerOffset> offset = buildStrideOffset(S, stride, "ptr_stride");
  return succeeded(offset) && offset->expr &&
         S.slotFitsU32(offset->expr, offset->assumptions);
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
  return appendExpr(S, offset.expr, *advance, assumptions);
}

static bool proveAccumulatingCarryFitsU32(WaveAMDMachineSelector &S,
                                          scf::ForOp op,
                                          const PointerOffset &offset,
                                          int64_t deltaBytes) {
  if (!offsetFitsU32(S, offset))
    return false;
  if (deltaBytes == 0)
    return true;
  if (deltaBytes < 0)
    return false;

  SmallVector<sym::PredHandle, 4> assumptions(offset.assumptions.begin(),
                                              offset.assumptions.end());
  FailureOr<sym::ExprHandle> total =
      buildAccumulatingCarryExpr(S, op, offset, deltaBytes, assumptions);
  return succeeded(total) && S.slotFitsU32(*total, assumptions);
}

static LogicalResult proveLoopCarryFitsU32(WaveAMDMachineSelector &S,
                                           scf::ForOp op,
                                           const PointerOffset &offset,
                                           Value yieldValue, Value iterArg,
                                           CarrySnapshot &snap) {
  std::optional<int64_t> entryUpper = proveU32Upper(S, offset);
  if (!entryUpper)
    return op.emitError(
        "scf.for pointer carry offset must fit proven unsigned 32-bit");

  if (hasStride(snap.stride)) {
    snap.bodyU32Upper = entryUpper;
    snap.resultU32Upper = entryUpper;
    return success();
  }

  std::optional<int64_t> advance =
      constantPtrAdvanceBytes(S, yieldValue, iterArg);
  if (!advance || !proveAccumulatingCarryFitsU32(S, op, offset, *advance))
    return op.emitError("scf.for pointer carry offset must fit proven "
                        "unsigned 32-bit for every iteration");

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

static bool canUseStridedCarry(scf::ForOp op, unsigned idx, bool isBuffer,
                               const StrideBytes &stride) {
  if (!isBuffer)
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
  FailureOr<Value> value = materializePointerOffsetValue(S, user, *offset);
  if (failed(value))
    return failure();
  return S.ensureSGPR1(user->getLoc(), *value);
}

static FailureOr<int64_t>
getStridedBaseGroup(WaveAMDMachineSelector &S, scf::ForOp op,
                    SmallVectorImpl<StridedBaseCarry> &groups, Value base,
                    const StrideBytes &stride) {
  for (auto [idx, group] : llvm::enumerate(groups))
    if (group.base == base && sameStride(group.stride, stride))
      return static_cast<int64_t>(idx);
  Value byteStride;
  if (!isImmediateStride(stride)) {
    FailureOr<Value> materialized = materializeDynamicStride(S, op, stride);
    if (failed(materialized))
      return failure();
    byteStride = *materialized;
  }
  groups.push_back(StridedBaseCarry{stride, base, {}, byteStride});
  return static_cast<int64_t>(groups.size() - 1);
}

static StrideBytes selectStridedCarry(WaveAMDMachineSelector &S, scf::ForOp op,
                                      unsigned idx, Value initArg,
                                      bool isBuffer) {
  if (S.isSharedPointer(initArg.getType()))
    return {};
  std::optional<StrideBytes> stride = stridedCarryBytes(S, op, idx);
  if (!stride || !canUseStridedCarry(op, idx, isBuffer, *stride))
    return {};
  return std::move(*stride);
}

static LogicalResult
attachStridedBaseGroup(WaveAMDMachineSelector &S, scf::ForOp op,
                       SmallVectorImpl<StridedBaseCarry> &groups,
                       CarrySnapshot &snap) {
  if (!hasStride(snap.stride) || snap.isBuffer)
    return success();
  FailureOr<int64_t> group =
      getStridedBaseGroup(S, op, groups, snap.base, snap.stride);
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
  StrideBytes stride = selectStridedCarry(S, op, idx, initArg, isBuffer);
  TermKind yieldKind = hasStride(stride)
                           ? initKind
                           : classifyPointerYield(S, yield.getOperand(idx),
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
  if (failed(attachStridedBaseGroup(S, op, groups, snap)))
    return failure();
  snap.bodyOffsetName = makeLoopSymbol(S, "ptr_body");
  snap.resultOffsetName = makeLoopSymbol(S, "ptr_result");
  snap.strideName = makeLoopSymbol(S, "ptr_stride");
  return proveLoopCarryFitsU32(S, op, offsetIt->second, yield.getOperand(idx),
                               op.getRegionIterArgs()[idx], snap);
}

static LogicalResult
snapshotScfCarries(WaveAMDMachineSelector &S, scf::ForOp op,
                   SmallVectorImpl<CarrySnapshot> &out,
                   SmallVectorImpl<StridedBaseCarry> &groups) {
  out.reserve(op.getInitArgs().size());
  auto yield = cast<scf::YieldOp>(op.getBody()->getTerminator());
  for (auto [idx, initArg] : llvm::enumerate(op.getInitArgs())) {
    if (auto simd = dyn_cast<SimdType>(initArg.getType());
        simd && isa<PtrType>(simd.getElementType())) {
      CarrySnapshot snap;
      if (failed(snapshotPointerScfCarry(
              S, op, yield, static_cast<unsigned>(idx), initArg, groups, snap)))
        return failure();
      out.push_back(std::move(snap));
      continue;
    }
    CarrySnapshot snap;
    snap.kind = CarrySnapshot::Kind::WMValue;
    snap.carry = S.expect(initArg, op);
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
