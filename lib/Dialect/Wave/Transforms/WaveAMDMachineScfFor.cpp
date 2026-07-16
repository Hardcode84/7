//===- WaveAMDMachineScfFor.cpp - scf.for -> waveamdmachine.uniform_loop
//--------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// scf.for lowering for the Wave-to-WaveAMDMachine selector. Snapshots the
// waveamdmachine "shape" of each iter arg at the loop boundary, builds the
// `waveamdmachine.uniform_loop` op with the carry list [IV, *iterArgs,
// *syntheticBases], recursively selects the loop body, and stitches the
// back-edge IV increment + continue_if so the rest of selection treats
// the loop op like any other CFG block.
//
//===----------------------------------------------------------------------===//

#include "WaveAMDMachineLoopCarryPlan.h"

#include "llvm/Support/CheckedArithmetic.h"
#include "llvm/Support/MathExtras.h"

#include <limits>

using namespace mlir;
using namespace mlir::wave;
using namespace mlir::waveamd;
using namespace mlir::wave::wmsel;

namespace mlir::wave::wmsel {

namespace {

static constexpr int64_t noStridedBaseGroup = -1;

static void addRangeAssumption(WaveAMDMachineSelector &S, PointerOffset &offset,
                               StringRef name, int64_t hi) {
  FailureOr<sym::PredHandle> range =
      sym::rangeAssumption(S.symbolStore(), name, int64_t{0}, hi);
  if (succeeded(range))
    offset.assumptions.push_back(*range);
}

static FailureOr<PointerOffset>
makeSymbolicCarry(WaveAMDMachineSelector &S, StringRef name, Value value,
                  TermKind kind, std::optional<int64_t> hi = {},
                  bool inferValueRange = true) {
  FailureOr<sym::ExprHandle> expr = sym::composeExprSym(S.symbolStore(), name);
  if (failed(expr))
    return failure();
  PointerOffset offset;
  offset.expr = *expr;
  offset.bindings.push_back({name.str(), value, kind});
  if (hi)
    addRangeAssumption(S, offset, name, *hi);
  else if (inferValueRange) {
    S.appendBindingAssumptions(value, name, offset.assumptions);
  }
  return offset;
}

static LogicalResult addSymbolicStride(WaveAMDMachineSelector &S,
                                       PointerOffset &offset, Value strideValue,
                                       StringRef name, Value rangeSource,
                                       int64_t scale) {
  S.values[strideValue] = strideValue;
  FailureOr<PointerOffset> stride =
      makeSymbolicCarry(S, name, strideValue, TermKind::Uniform, std::nullopt,
                        /*inferValueRange=*/false);
  if (failed(stride))
    return failure();
  S.appendBindingAssumptions(rangeSource, name, stride->assumptions, scale);
  FailureOr<sym::ExprHandle> expr =
      offset.expr ? sym::composeExprBinary(S.symbolStore(), offset.expr,
                                           sym::ExprBinaryOp::Add, stride->expr)
                  : FailureOr<sym::ExprHandle>(stride->expr);
  if (failed(expr))
    return failure();
  offset.expr = *expr;
  llvm::append_range(offset.bindings, stride->bindings);
  llvm::append_range(offset.assumptions, stride->assumptions);
  return success();
}

static Value advanceStridedBase(WaveAMDMachineSelector &S, Location loc,
                                Value base, const StridedBaseCarry &group) {
  Type sgpr2 =
      getRegType(S.builder.getContext(), waveamdmachine::RegClass::SGPR, 2);
  Value stride = group.byteStride ? group.byteStride
                                  : createImm(S.builder, loc, group.stride.imm);
  return waveamdmachine::SAddU64U32Op::create(
             S.builder, loc, sgpr2, getSCCType(S.builder.getContext()), base,
             stride)
      .getResult();
}

// Materialize `waveamdmachine.uniform_loop` with optional entry cond.
static Operation *buildUniformLoopOp(WaveAMDMachineSelector &S, Location loc,
                                     Value entryCond, ArrayRef<Value> inits) {
  SmallVector<Type> resultTypes;
  for (Value v : inits)
    resultTypes.push_back(v.getType());
  OperationState state(loc, "waveamdmachine.uniform_loop");
  if (entryCond)
    state.addOperands(entryCond);
  state.addOperands(inits);
  state.addTypes(resultTypes);
  int32_t segs[2] = {entryCond ? 1 : 0, static_cast<int32_t>(inits.size())};
  state.addAttribute("operandSegmentSizes",
                     S.builder.getDenseI32ArrayAttr(segs));
  Region *body = state.addRegion();
  body->emplaceBlock();
  for (Value init : inits)
    body->front().addArgument(init.getType(), loc);
  return S.builder.create(state);
}

// Register the loop body block args back into the selector maps so
// recursive selection inside the body resolves IV / iter args /
// carried pointers correctly.
static void bindLoopBodyArgs(WaveAMDMachineSelector &S, scf::ForOp op,
                             Block &loopBody, ArrayRef<CarrySnapshot> snapshots,
                             SmallVectorImpl<StridedBaseCarry> &groups) {
  S.values[op.getInductionVar()] = loopBody.getArgument(0);
  for (auto [idx, scfArg] : llvm::enumerate(op.getRegionIterArgs())) {
    Value blockCarry = loopBody.getArgument(idx + 1);
    const CarrySnapshot &snap = snapshots[idx];
    if (snap.kind == CarrySnapshot::Kind::Pointer) {
      S.pointerBases[scfArg] = snap.base;
      if (snap.globalBase)
        S.pointerGlobalBases[scfArg] = snap.globalBase;
      S.values[blockCarry] = blockCarry;
      FailureOr<PointerOffset> symbolic =
          makeSymbolicCarry(S, snap.bodyOffsetName, blockCarry, snap.offsetKind,
                            snap.bodyU32Upper);
      if (succeeded(symbolic))
        S.pointerIndexOffsets[scfArg] = *symbolic;
      else
        S.pointerIndexOffsets.erase(scfArg);
      S.pointerBuffers[scfArg] = snap.isBuffer;
      continue;
    }
    S.values[scfArg] = blockCarry;
  }
  unsigned firstBaseArg = 1 + snapshots.size();
  for (auto indexed : llvm::enumerate(groups))
    indexed.value().bodyBase =
        loopBody.getArgument(firstBaseArg + indexed.index());
}

// Recursively select every non-terminator op in the scf.for body. The
// original scf.yield is consumed by the caller.
static LogicalResult selectScfBody(WaveAMDMachineSelector &S, scf::ForOp op) {
  auto savedIP = S.builder.saveInsertionPoint();
  SmallVector<Operation *> bodyOps;
  for (Operation &child :
       llvm::make_early_inc_range(op.getBody()->without_terminator()))
    bodyOps.push_back(&child);
  for (Operation *child : bodyOps) {
    S.builder.restoreInsertionPoint(savedIP);
    if (failed(S.selectOperation(child)))
      return failure();
    savedIP = S.builder.saveInsertionPoint();
  }
  S.builder.restoreInsertionPoint(savedIP);
  return success();
}

static LogicalResult collectPointerYieldCarry(WaveAMDMachineSelector &S,
                                              scf::YieldOp yield, Value y,
                                              const CarrySnapshot &snap,
                                              SmallVectorImpl<Value> &out) {
  if (hasStride(snap.stride)) {
    out.push_back(snap.carry);
    return success();
  }
  auto baseIt = S.pointerBases.find(y);
  auto offsetIt = S.pointerIndexOffsets.find(y);
  if (baseIt == S.pointerBases.end() || offsetIt == S.pointerIndexOffsets.end())
    return yield.emitError(
        "scf.yield pointer carry has no WaveAMDMachine sidecar");
  if (baseIt->second != snap.base)
    return yield.emitError(
        "scf.yield pointer carry must keep loop-invariant base");
  if (snap.globalBase && S.pointerGlobalBases.lookup(y) != snap.globalBase)
    return yield.emitError("scf.yield pointer carry must keep global base");
  FailureOr<Value> carry = materializePointerOffsetCarry(
      S, yield, offsetIt->second, snap.offsetKind);
  if (failed(carry))
    return failure();
  out.push_back(*carry);
  return success();
}

static LogicalResult collectYieldCarries(WaveAMDMachineSelector &S,
                                         scf::YieldOp yield,
                                         ArrayRef<CarrySnapshot> snapshots,
                                         SmallVectorImpl<Value> &out) {
  for (auto [idx, y] : llvm::enumerate(yield.getResults())) {
    const CarrySnapshot &snap = snapshots[idx];
    if (snap.kind == CarrySnapshot::Kind::Pointer) {
      if (failed(collectPointerYieldCarry(S, yield, y, snap, out)))
        return failure();
      continue;
    }
    out.push_back(S.expect(y, yield));
  }
  return success();
}

static Value resultPointerBase(Operation *loop,
                               ArrayRef<CarrySnapshot> snapshots,
                               ArrayRef<StridedBaseCarry> groups,
                               const CarrySnapshot &snap) {
  if (!hasStride(snap.stride) || snap.strideInOffset)
    return snap.base;
  assert(snap.stridedBaseGroup != noStridedBaseGroup &&
         "global strided carry must have base group");
  assert(static_cast<size_t>(snap.stridedBaseGroup) < groups.size() &&
         "global strided carry group out of range");
  unsigned firstBaseResult = 1 + snapshots.size();
  return loop->getResult(firstBaseResult +
                         static_cast<unsigned>(snap.stridedBaseGroup));
}

static void bindPointerLoopResult(WaveAMDMachineSelector &S, Value scfResult,
                                  Value wmResult, Operation *loop,
                                  ArrayRef<CarrySnapshot> snapshots,
                                  ArrayRef<StridedBaseCarry> groups,
                                  const CarrySnapshot &snap) {
  Value base = resultPointerBase(loop, snapshots, groups, snap);
  S.pointerBases[scfResult] = base;
  if (hasStride(snap.stride) && !snap.strideInOffset)
    S.pointerGlobalBases[scfResult] = base;
  else if (snap.globalBase)
    S.pointerGlobalBases[scfResult] = snap.globalBase;
  S.values[wmResult] = wmResult;
  FailureOr<PointerOffset> symbolic = makeSymbolicCarry(
      S, snap.resultOffsetName, wmResult, snap.offsetKind, snap.resultU32Upper);
  if (succeeded(symbolic))
    S.pointerIndexOffsets[scfResult] = *symbolic;
  else
    S.pointerIndexOffsets.erase(scfResult);
  S.pointerBuffers[scfResult] = snap.isBuffer;
}

// Rebind the scf.for results to the waveamdmachine loop op results,
// skipping the synthetic IV carry at slot 0. Pointer carries get
// their sidecar entries reconstructed from the captured base.
static void bindLoopResults(WaveAMDMachineSelector &S, scf::ForOp op,
                            Operation *loop, ArrayRef<CarrySnapshot> snapshots,
                            ArrayRef<StridedBaseCarry> groups) {
  for (auto [idx, scfResult] : llvm::enumerate(op.getResults())) {
    Value wmResult = loop->getResult(idx + 1);
    const CarrySnapshot &snap = snapshots[idx];
    if (snap.kind == CarrySnapshot::Kind::Pointer) {
      bindPointerLoopResult(S, scfResult, wmResult, loop, snapshots, groups,
                            snap);
      continue;
    }
    S.values[scfResult] = wmResult;
  }
}

static bool isWideScalarValue(Value value) {
  auto regType = dyn_cast<waveamdmachine::RegType>(value.getType());
  return regType && regType.getWidth() > 1;
}

static Value multiplyOffsetStride(WaveAMDMachineSelector &S, Location loc,
                                  Value value, int64_t stride) {
  assert(stride > 0 && "offset stride must be positive");
  if (stride == 1)
    return value;
  Value strideValue = createImm(S.builder, loc, stride);
  if (!isWideScalarValue(value))
    return S.mulUniformValues(loc, value, strideValue);

  Type resultType =
      getRegType(S.builder.getContext(), waveamdmachine::RegClass::SGPR, 2);
  if (llvm::isPowerOf2_64(static_cast<uint64_t>(stride)))
    return waveamdmachine::SLshlB64Op::create(
               S.builder, loc, resultType, getSCCType(S.builder.getContext()),
               ensureSGPR2(S, loc, value),
               createImm(S.builder, loc, llvm::Log2_64(stride)))
        .getResult();

  Type scratchType =
      getRegType(S.builder.getContext(), waveamdmachine::RegClass::SGPR, 1);
  return waveamdmachine::SMulU64Op::create(
             S.builder, loc, resultType, scratchType,
             getSCCType(S.builder.getContext()), ensureSGPR2(S, loc, value),
             ensureSGPR2(S, loc, strideValue))
      .getResult();
}

static void rebindStridedPointerCarries(WaveAMDMachineSelector &S,
                                        scf::ForOp op, Block &loopBody,
                                        ArrayRef<CarrySnapshot> snapshots,
                                        ArrayRef<StridedBaseCarry> groups) {
  Location loc = op.getLoc();
  for (auto [idx, snap] : llvm::enumerate(snapshots)) {
    if (snap.kind != CarrySnapshot::Kind::Pointer || !hasStride(snap.stride))
      continue;
    Value scfArg = op.getRegionIterArgs()[idx];
    Value iv = loopBody.getArgument(0);
    if (snap.strideInOffset) {
      assert(isImmediateStride(snap.stride) &&
             "offset-strided carry must use immediate stride");
      Value strideValue = multiplyOffsetStride(S, loc, iv, snap.stride.imm);
      if (auto symIt = S.pointerIndexOffsets.find(scfArg);
          symIt != S.pointerIndexOffsets.end())
        if (failed(addSymbolicStride(S, symIt->second, strideValue,
                                     snap.strideName, op.getInductionVar(),
                                     snap.stride.imm)))
          S.pointerIndexOffsets.erase(scfArg);
      continue;
    }
    assert(snap.stridedBaseGroup != noStridedBaseGroup &&
           "global strided carry must have base group");
    Value bodyBase = groups[snap.stridedBaseGroup].bodyBase;
    S.pointerBases[scfArg] = bodyBase;
    if (snap.globalBase)
      S.pointerGlobalBases[scfArg] = bodyBase;
  }
}

static void collectStridedBaseCarries(WaveAMDMachineSelector &S, Location loc,
                                      ArrayRef<StridedBaseCarry> groups,
                                      SmallVectorImpl<Value> &out) {
  for (const StridedBaseCarry &group : groups)
    out.push_back(advanceStridedBase(S, loc, group.bodyBase, group));
}

static bool needsWideSignedScalarCmp(WaveAMDMachineSelector &S, Value value) {
  if (isWideScalarValue(value))
    return true;
  if (std::optional<int64_t> imm = S.getImmediateValue(value))
    return !llvm::isInt<32>(*imm);
  return false;
}

struct LoopRange64 {
  int64_t lo = 0;
  int64_t hi = 0;
};

static std::optional<LoopRange64> asLoopRange64(ConstantIntRanges range) {
  unsigned w = range.smin().getBitWidth();
  if (w == 0 || w > 64)
    return std::nullopt;
  return LoopRange64{range.smin().getSExtValue(), range.smax().getSExtValue()};
}

static std::optional<LoopRange64>
selectedSignedRange(WaveAMDMachineSelector &S, Value source, Value selected) {
  if (std::optional<int64_t> imm = S.getImmediateValue(selected))
    return LoopRange64{*imm, *imm};
  if (auto mov = selected.getDefiningOp<waveamdmachine::SMovB64ImmOp>()) {
    int64_t value = mov.getValue();
    return LoopRange64{value, value};
  }
  if (std::optional<ConstantIntRanges> range = S.finiteSignedRange(source))
    return asLoopRange64(*range);
  return std::nullopt;
}

static bool loopIvFitsSignedI32(WaveAMDMachineSelector &S, scf::ForOp op,
                                Value lower, Value upper, Value step) {
  std::optional<LoopRange64> lowerRange =
      selectedSignedRange(S, op.getLowerBound(), lower);
  std::optional<LoopRange64> upperRange =
      selectedSignedRange(S, op.getUpperBound(), upper);
  std::optional<LoopRange64> stepRange =
      selectedSignedRange(S, op.getStep(), step);
  if (!lowerRange || !upperRange || !stepRange || stepRange->lo <= 0)
    return false;

  int64_t i32Min = std::numeric_limits<int32_t>::min();
  int64_t i32Max = std::numeric_limits<int32_t>::max();
  if (lowerRange->lo < i32Min || lowerRange->hi > i32Max)
    return false;
  std::optional<int64_t> maxNext =
      llvm::checkedAdd(upperRange->hi, stepRange->hi - 1);
  return maxNext && *maxNext <= i32Max;
}

static bool shouldUseWideLoopIv(WaveAMDMachineSelector &S, scf::ForOp op,
                                Value lower, Value upper, Value step) {
  bool needsWideCompare = needsWideSignedScalarCmp(S, lower) ||
                          needsWideSignedScalarCmp(S, upper) ||
                          needsWideSignedScalarCmp(S, step);
  return needsWideCompare && !loopIvFitsSignedI32(S, op, lower, upper, step);
}

static Value narrowLoopValue(WaveAMDMachineSelector &S, Location loc,
                             Value value) {
  if (isWideScalarValue(value))
    return extractLowDword(S, loc, value);
  return value;
}

static bool isSGPR1Value(Value value) {
  auto regType = dyn_cast<waveamdmachine::RegType>(value.getType());
  return regType && regType.getRegClass() == waveamdmachine::RegClass::SGPR &&
         regType.getWidth() == 1;
}

static bool isPinnedRegValue(Value value) {
  auto regType = dyn_cast<waveamdmachine::RegType>(value.getType());
  return regType && regType.getIndex() >= 0;
}

static waveamdmachine::RegType getVirtualRegType(WaveAMDMachineSelector &S,
                                                 waveamdmachine::RegType type) {
  return getRegType(S.builder.getContext(), type.getRegClass(),
                    type.getWidth());
}

static FailureOr<Value> copyPinnedLoopInit(WaveAMDMachineSelector &S,
                                           scf::ForOp op, Value value) {
  auto type = dyn_cast<waveamdmachine::RegType>(value.getType());
  if (!type || !isPinnedRegValue(value))
    return value;

  Location loc = op.getLoc();
  waveamdmachine::RegType resultType = getVirtualRegType(S, type);
  switch (type.getRegClass()) {
  case waveamdmachine::RegClass::SGPR:
    if (type.getWidth() == 1)
      return waveamdmachine::SMovB32ValueOp::create(S.builder, loc, resultType,
                                                    value)
          .getResult();
    return waveamdmachine::SMovB32TupleOp::create(S.builder, loc, resultType,
                                                  value)
        .getResult();
  case waveamdmachine::RegClass::VGPR:
    return waveamdmachine::VMovB32TupleOp::create(S.builder, loc, resultType,
                                                  value)
        .getResult();
  case waveamdmachine::RegClass::AGPR: {
    Type vgprType = getRegType(S.builder.getContext(),
                               waveamdmachine::RegClass::VGPR, type.getWidth());
    Value vgpr = waveamdmachine::VAccvgprReadB32TupleOp::create(
        S.builder, loc, vgprType, value);
    return waveamdmachine::VAccvgprWriteB32TupleOp::create(S.builder, loc,
                                                           resultType, vgpr)
        .getResult();
  }
  case waveamdmachine::RegClass::SCC:
  case waveamdmachine::RegClass::VCC:
    op.emitError("cannot copy pinned loop carry flag register");
    return failure();
  }
  return failure();
}

static LogicalResult normalizePinnedLoopInits(WaveAMDMachineSelector &S,
                                              scf::ForOp op,
                                              MutableArrayRef<Value> inits) {
  for (Value &init : inits) {
    FailureOr<Value> copy = copyPinnedLoopInit(S, op, init);
    if (failed(copy))
      return failure();
    init = *copy;
  }
  return success();
}

static bool isZeroValue(WaveAMDMachineSelector &S, Value value) {
  if (std::optional<int64_t> imm = S.getImmediateValue(value))
    return *imm == 0;
  if (auto mov = value.getDefiningOp<waveamdmachine::SMovB32ValueOp>())
    return isZeroValue(S, mov.getSource());
  return false;
}

static std::optional<Value> getZeroExtendedLowDword(WaveAMDMachineSelector &S,
                                                    Value value) {
  if (isSGPR1Value(value))
    return value;
  auto tuple = value.getDefiningOp<waveamdmachine::TupleFromElementsOp>();
  if (!tuple || tuple.getElements().size() != 2)
    return std::nullopt;
  Value lo = tuple.getElements().front();
  Value hi = tuple.getElements().back();
  if (isSGPR1Value(lo) && isZeroValue(S, hi))
    return lo;
  return std::nullopt;
}

static Value buildSignedSGPR2(WaveAMDMachineSelector &S, Location loc,
                              Value value) {
  Type sgpr1 =
      getRegType(S.builder.getContext(), waveamdmachine::RegClass::SGPR, 1);
  Value lo = S.materializeSGPR1(loc, value);
  Value negative = waveamdmachine::SCmpLtI32Op::create(
      S.builder, loc, getSCCType(S.builder.getContext()), lo,
      createImm(S.builder, loc, 0));
  Value hi = waveamdmachine::SCSelectB32Op::create(
      S.builder, loc, sgpr1, negative, createImm(S.builder, loc, -1),
      createImm(S.builder, loc, 0));
  Type sgpr2 =
      getRegType(S.builder.getContext(), waveamdmachine::RegClass::SGPR, 2);
  return waveamdmachine::TupleFromElementsOp::create(S.builder, loc, sgpr2,
                                                     ValueRange{lo, hi})
      .getTuple();
}

static Value signExtendSGPR2(WaveAMDMachineSelector &S, Location loc,
                             Value value) {
  if (std::optional<Value> lo = getZeroExtendedLowDword(S, value))
    return buildSignedSGPR2(S, loc, *lo);
  if (isWideScalarValue(value))
    return ensureSGPR2(S, loc, value);
  if (S.getImmediateValue(value))
    return ensureSGPR2(S, loc, value);
  return buildSignedSGPR2(S, loc, value);
}

static Value createLoopLtCmp(WaveAMDMachineSelector &S, Location loc, Value lhs,
                             Value rhs) {
  if (needsWideSignedScalarCmp(S, lhs) || needsWideSignedScalarCmp(S, rhs)) {
    lhs = signExtendSGPR2(S, loc, lhs);
    rhs = signExtendSGPR2(S, loc, rhs);
    return createScalarI64Cmp(S, loc, CmpRelation::Lt, /*signedCmp=*/true, lhs,
                              rhs);
  }
  Type scc = getSCCType(S.builder.getContext());
  return waveamdmachine::SCmpLtI32Op::create(
      S.builder, loc, scc, S.ensureSGPR1(loc, lhs), S.ensureSGPR1(loc, rhs));
}

static Value createLoopIvInit(WaveAMDMachineSelector &S, Location loc,
                              Value lower, bool wideIv) {
  return wideIv ? signExtendSGPR2(S, loc, lower)
                : S.materializeSGPR1(loc, narrowLoopValue(S, loc, lower));
}

static Value createLoopStep(WaveAMDMachineSelector &S, Location loc, Value step,
                            bool wideIv) {
  return wideIv ? signExtendSGPR2(S, loc, step)
                : S.ensureSGPR1(loc, narrowLoopValue(S, loc, step));
}

static Value createLoopNextIv(WaveAMDMachineSelector &S, Location loc, Value iv,
                              Value step, bool wideIv) {
  if (wideIv)
    return waveamdmachine::SAddU64Op::create(
               S.builder, loc,
               getRegType(S.builder.getContext(),
                          waveamdmachine::RegClass::SGPR, 2),
               getSCCType(S.builder.getContext()), iv, step)
        .getResult();
  return waveamdmachine::SAddI32Op::create(
             S.builder, loc,
             getRegType(S.builder.getContext(), waveamdmachine::RegClass::SGPR),
             getSCCType(S.builder.getContext()), iv, step)
      .getResult();
}

static std::optional<ConstantIntRanges>
getLoopBoundRange(WaveAMDMachineSelector &S, Value value) {
  const dataflow::IntegerValueRangeLattice *lattice =
      S.rangeSolver.lookupState<dataflow::IntegerValueRangeLattice>(value);
  if (!lattice)
    return std::nullopt;
  IntegerValueRange ivr = lattice->getValue();
  if (ivr.isUninitialized())
    return std::nullopt;
  ConstantIntRanges range = ivr.getValue();
  unsigned w = range.smin().getBitWidth();
  if (w == 0 || w > 64)
    return std::nullopt;
  return range;
}

static bool rangeProvesLoopEntry(WaveAMDMachineSelector &S, scf::ForOp op) {
  if (op.getUnsignedCmp())
    return false;
  std::optional<ConstantIntRanges> lower =
      getLoopBoundRange(S, op.getLowerBound());
  std::optional<ConstantIntRanges> upper =
      getLoopBoundRange(S, op.getUpperBound());
  return lower && upper && lower->smax().slt(upper->smin());
}

static bool canSkipLoopEntryCheck(WaveAMDMachineSelector &S, scf::ForOp op) {
  if (op->hasAttr("wave.nonzero_trip"))
    return true;
  std::optional<APInt> tripCount = op.getStaticTripCount();
  return (tripCount && !tripCount->isZero()) || rangeProvesLoopEntry(S, op);
}

static bool needsDmaIssueSkipCondition(scf::ForOp loop) {
  bool needed = false;
  loop.walk([&](waveamd::DmaLoadLdsOp dma) {
    if (dma->getParentOfType<scf::ForOp>() == loop &&
        dma->hasAttr("issue_delay_skip_thread_threshold"))
      needed = true;
  });
  return needed;
}

static FailureOr<Value> createDmaIssueSkipCondition(WaveAMDMachineSelector &S,
                                                    scf::ForOp loop) {
  if (!S.dmaIssueSkipFlag)
    return loop.emitError("DMA issue skip condition lacks cohort flag");
  return waveamdmachine::SMovVccB32Op::create(
             S.builder, loop.getLoc(), getVCCType(S.builder.getContext()),
             S.dmaIssueSkipFlag)
      .getResult();
}

static FailureOr<Value> appendDmaIssueSkipInit(WaveAMDMachineSelector &S,
                                               scf::ForOp loop,
                                               SmallVectorImpl<Value> &inits) {
  if (!needsDmaIssueSkipCondition(loop))
    return Value{};
  FailureOr<Value> condition = createDmaIssueSkipCondition(S, loop);
  if (failed(condition))
    return failure();
  inits.push_back(*condition);
  return *condition;
}

static FailureOr<Value>
selectLoopBody(WaveAMDMachineSelector &S, scf::ForOp op, Block &loopBody,
               ArrayRef<CarrySnapshot> snapshots,
               ArrayRef<StridedBaseCarry> stridedBaseGroups,
               Value skipCondition) {
  S.builder.setInsertionPointToStart(&loopBody);
  Value savedSkipCondition = S.dmaIssueSkipCondition;
  if (skipCondition)
    S.dmaIssueSkipCondition = loopBody.getArguments().back();
  // Strided pointers: globals carry bases; buffers use IV-derived soffset.
  rebindStridedPointerCarries(S, op, loopBody, snapshots, stridedBaseGroups);
  LogicalResult result = selectScfBody(S, op);
  Value bodySkipCondition = S.dmaIssueSkipCondition;
  S.dmaIssueSkipCondition = savedSkipCondition;
  if (failed(result))
    return failure();
  return bodySkipCondition;
}

static void appendDmaIssueSkipCarry(Value skipCondition,
                                    Value bodySkipCondition,
                                    SmallVectorImpl<Value> &carries) {
  if (skipCondition)
    carries.push_back(bodySkipCondition);
}

} // namespace

// Wide bounds force wide IV carry; otherwise IV wraps before wide compare.
LogicalResult selectScfFor(WaveAMDMachineSelector &S, scf::ForOp op) {
  Location loc = op.getLoc();
  Value lower = S.expect(op.getLowerBound(), op);
  Value upper = S.expect(op.getUpperBound(), op);
  Value step = S.expect(op.getStep(), op);
  bool wideIv = shouldUseWideLoopIv(S, op, lower, upper, step);
  Value loopStep = createLoopStep(S, loc, step, wideIv);

  ScfForCarryPlan carryPlan;
  if (failed(planScfForCarries(S, op, carryPlan)))
    return failure();
  SmallVector<CarrySnapshot> &snapshots = carryPlan.snapshots;
  SmallVector<StridedBaseCarry> &stridedBaseGroups =
      carryPlan.stridedBaseGroups;

  SmallVector<Value> inits;
  inits.push_back(createLoopIvInit(S, loc, lower, wideIv));
  for (const CarrySnapshot &snap : snapshots)
    inits.push_back(snap.carry);
  for (const StridedBaseCarry &group : stridedBaseGroups)
    inits.push_back(group.base);
  if (failed(normalizePinnedLoopInits(S, op, inits)))
    return failure();

  Value entryCond;
  if (!canSkipLoopEntryCheck(S, op))
    entryCond = createLoopLtCmp(S, loc, lower, upper);

  FailureOr<Value> skipCondition = appendDmaIssueSkipInit(S, op, inits);
  if (failed(skipCondition))
    return failure();

  Operation *loop = buildUniformLoopOp(S, loc, entryCond, inits);
  Block &loopBody = loop->getRegion(0).front();
  bindLoopBodyArgs(S, op, loopBody, snapshots, stridedBaseGroups);

  FailureOr<Value> bodySkipCondition = selectLoopBody(
      S, op, loopBody, snapshots, stridedBaseGroups, *skipCondition);
  if (failed(bodySkipCondition))
    return failure();

  Value nextIv =
      createLoopNextIv(S, loc, loopBody.getArgument(0), loopStep, wideIv);

  SmallVector<Value> carryOperands{nextIv};
  auto yield = cast<scf::YieldOp>(op.getBody()->getTerminator());
  if (failed(collectYieldCarries(S, yield, snapshots, carryOperands)))
    return failure();
  collectStridedBaseCarries(S, loc, stridedBaseGroups, carryOperands);
  appendDmaIssueSkipCarry(*skipCondition, *bodySkipCondition, carryOperands);

  Value backCond = createLoopLtCmp(S, loc, nextIv, upper);
  waveamdmachine::ContinueIfOp::create(S.builder, loc, backCond, carryOperands);

  S.builder.setInsertionPointAfter(loop);
  bindLoopResults(S, op, loop, snapshots, stridedBaseGroups);
  S.eraseIfTopLevel(op);
  return success();
}

} // namespace mlir::wave::wmsel
