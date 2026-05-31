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
// `waveamdmachine.uniform_loop` op with the carry list [IV, *iterArgs],
// recursively selects the loop body, and stitches the back-edge IV
// increment + continue_if so the rest of selection treats the loop op
// like any other CFG block.
//
//===----------------------------------------------------------------------===//

#include "WaveAMDMachineSelector.h"

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
  if (!S.slotFitsU32(offset.expr, offset.assumptions))
    return std::nullopt;
  int64_t lo = 0;
  int64_t hi = u32Max;
  while (lo < hi) {
    int64_t mid = lo + (hi - lo) / 2;
    if (sym::provablyInRange(S.symbolStore(), offset.expr, offset.assumptions,
                             /*lo=*/0, mid)) {
      hi = mid;
      continue;
    }
    lo = mid + 1;
  }
  return hi;
}

static bool offsetFitsU32(WaveAMDMachineSelector &S,
                          const PointerOffset &offset) {
  return !offset.expr || S.slotFitsU32(offset.expr, offset.assumptions);
}

static void addRangeAssumption(WaveAMDMachineSelector &S, PointerOffset &offset,
                               StringRef name, int64_t hi) {
  FailureOr<sym::PredHandle> range =
      sym::rangeAssumption(S.symbolStore(), name, int64_t{0}, hi);
  if (succeeded(range))
    offset.assumptions.push_back(*range);
}

static FailureOr<PointerOffset>
makeSymbolicCarry(WaveAMDMachineSelector &S, StringRef name, Value value,
                  TermKind kind, std::optional<int64_t> hi = {}) {
  FailureOr<sym::ExprHandle> expr = sym::composeExprSym(S.symbolStore(), name);
  if (failed(expr))
    return failure();
  PointerOffset offset;
  offset.expr = *expr;
  offset.bindings.push_back({name.str(), value, kind});
  if (hi)
    addRangeAssumption(S, offset, name, *hi);
  else if (std::optional<sym::PredHandle> a = S.bindingAssumption(value, name))
    offset.assumptions.push_back(*a);
  return offset;
}

static LogicalResult addSymbolicStride(WaveAMDMachineSelector &S,
                                       PointerOffset &offset, Value strideValue,
                                       StringRef name, Value rangeSource,
                                       int64_t scale) {
  S.values[strideValue] = strideValue;
  FailureOr<PointerOffset> stride =
      makeSymbolicCarry(S, name, strideValue, TermKind::Uniform);
  if (failed(stride))
    return failure();
  if (std::optional<sym::PredHandle> a =
          S.bindingAssumption(rangeSource, name, scale))
    stride->assumptions.push_back(*a);
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

static bool isLaneVaryingValue(Type type) {
  if (isa<SimdType>(type))
    return true;
  if (auto idx = dyn_cast<WaveIndexType>(type))
    return idx.getWidth() != 0;
  return false;
}

static TermKind loopCarryKind(TermKind kind) {
  return kind == TermKind::Lane ? TermKind::Lane : TermKind::Uniform;
}

static TermKind classifyIndexExprResult(WaveAMDMachineSelector &S,
                                        IndexExprOp op) {
  PointerOffset offset;
  for (auto [nameAttr, binding] : llvm::zip(op.getNames(), op.getBindings())) {
    StringRef key = cast<StringAttr>(nameAttr).getValue();
    TermKind kind = isLaneVaryingValue(binding.getType()) ? TermKind::Lane
                                                          : TermKind::Uniform;
    offset.bindings.push_back({key.str(), binding, kind});
    if (std::optional<sym::PredHandle> a = S.bindingAssumption(binding, key))
      offset.assumptions.push_back(*a);
  }
  sym::ExprHandle expr = op.getExpr().getValue();
  FailureOr<sym::ExprHandle> simplified =
      sym::simplifyExpr(S.symbolStore(), expr, offset.assumptions);
  offset.expr = succeeded(simplified) ? *simplified : expr;
  return classifyPointerOffset(S, offset);
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
    std::optional<int64_t> off = getConstantIntValue(add.getOffset());
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
  if (std::optional<sym::PredHandle> range =
          S.bindingAssumption(op.getUpperBound(), name)) {
    assumptions.push_back(*range);
    return success();
  }
  return failure();
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

static bool isNormalizedUnitLoop(scf::ForOp op) {
  std::optional<int64_t> lo = getConstantIntValue(op.getLowerBound());
  std::optional<int64_t> step = getConstantIntValue(op.getStep());
  return lo && *lo == 0 && step && *step == 1;
}

static FailureOr<sym::ExprHandle>
buildAccumulatingCarryExpr(WaveAMDMachineSelector &S, scf::ForOp op,
                           const PointerOffset &offset, int64_t deltaBytes,
                           SmallVectorImpl<sym::PredHandle> &assumptions) {
  std::string tripName = makeLoopSymbol(S, "ptr_trip");
  if (failed(addTripCountAssumption(S, op, tripName, assumptions)))
    return failure();
  FailureOr<sym::ExprHandle> trip =
      sym::composeExprSym(S.symbolStore(), tripName);
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
  if (!isNormalizedUnitLoop(op))
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

  if (snap.strideBytes != 0) {
    snap.bodyU32Upper = entryUpper;
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

// Wave-uniform per-iter advance (bytes) for global carry `i` the body
// may march on the scalar base, else 0. Eligible: normalized loop, dead
// post-loop result, constant-offset ptr_add chain back to the iter arg.
static int64_t stridedCarryBytes(WaveAMDMachineSelector &S, scf::ForOp op,
                                 unsigned i) {
  std::optional<int64_t> lo = getConstantIntValue(op.getLowerBound());
  std::optional<int64_t> step = getConstantIntValue(op.getStep());
  if (!lo || *lo != 0 || !step || *step != 1 || !op.getResult(i).use_empty())
    return 0;
  Value arg = op.getRegionIterArgs()[i];
  Value y = cast<scf::YieldOp>(op.getBody()->getTerminator()).getOperand(i);
  std::optional<int64_t> bytes = constantPtrAdvanceBytes(S, y, arg);
  return bytes && *bytes != 0 ? *bytes : 0;
}

// `base + iv * strideBytes` as an SGPR pair: scale the IV in the scalar
// domain and fold it into the 64-bit base via `s_add_u64_u32`. Pure
// ops, so cse folds the recompute shared by sibling loads off the same
// base. The scaled offset must not share an SSA value with the loop
// carries (a shared const-0 high word would fight the carry coalescer),
// hence the zero-extend lives inside the op as an immediate.
static Value recomputeStridedBase(WaveAMDMachineSelector &S, Location loc,
                                  Value base, Value iv, int64_t strideBytes) {
  Value scaled =
      S.mulUniformValues(loc, iv, createImm(S.builder, loc, strideBytes));
  Value offset = S.materializeSGPR1(loc, scaled);
  Type sgpr2 =
      getRegType(S.builder.getContext(), waveamdmachine::RegClass::SGPR, 2);
  return waveamdmachine::SAddU64U32Op::create(
             S.builder, loc, sgpr2, getSCCType(S.builder.getContext()), base,
             offset)
      .getResult();
}

// Capture waveamdmachine shape for every `scf.for` iter arg.
LogicalResult snapshotScfCarries(WaveAMDMachineSelector &S, scf::ForOp op,
                                 SmallVectorImpl<CarrySnapshot> &out) {
  out.reserve(op.getInitArgs().size());
  auto yield = cast<scf::YieldOp>(op.getBody()->getTerminator());
  for (auto [idx, initArg] : llvm::enumerate(op.getInitArgs())) {
    if (auto simd = dyn_cast<SimdType>(initArg.getType());
        simd && isa<PtrType>(simd.getElementType())) {
      auto baseIt = S.pointerBases.find(initArg);
      auto offsetIt = S.pointerIndexOffsets.find(initArg);
      if (baseIt == S.pointerBases.end() ||
          offsetIt == S.pointerIndexOffsets.end())
        return op.emitError(
            "scf.for pointer iter arg has no WaveAMDMachine sidecar");
      TermKind initKind = classifyPointerOffset(S, offsetIt->second);
      int64_t stride = !S.isSharedPointer(initArg.getType())
                           ? stridedCarryBytes(S, op, idx)
                           : 0;
      TermKind yieldKind =
          stride != 0 ? initKind
                      : classifyPointerYield(S, yield.getOperand(idx),
                                             op.getRegionIterArgs()[idx],
                                             loopCarryKind(initKind));
      TermKind carryKind = loopCarryKind(std::max(initKind, yieldKind));
      FailureOr<Value> carry =
          materializePointerOffsetCarry(S, op, offsetIt->second, carryKind);
      if (failed(carry))
        return failure();
      bool isBuffer = S.pointerBuffers.lookup(initArg);
      Value globalBase = S.pointerGlobalBases.lookup(initArg);
      // shared base is a const 0; global marches the SGPR base, buffer
      // marches soffset. LDS skipped.
      CarrySnapshot snap;
      snap.kind = CarrySnapshot::Kind::Pointer;
      snap.carry = *carry;
      snap.base = baseIt->second;
      snap.globalBase = globalBase;
      snap.strideBytes = stride;
      snap.offsetKind = carryKind;
      snap.isBuffer = isBuffer;
      snap.bodyOffsetName = makeLoopSymbol(S, "ptr_body");
      snap.resultOffsetName = makeLoopSymbol(S, "ptr_result");
      snap.strideName = makeLoopSymbol(S, "ptr_stride");
      if (failed(proveLoopCarryFitsU32(S, op, offsetIt->second,
                                       yield.getOperand(idx),
                                       op.getRegionIterArgs()[idx], snap)))
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

// Materialize `waveamdmachine.uniform_loop` with an optional entry
// condition and init carries [IV, *iterArgCarries].
Operation *buildUniformLoopOp(WaveAMDMachineSelector &S, Location loc,
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
void bindLoopBodyArgs(WaveAMDMachineSelector &S, scf::ForOp op, Block &loopBody,
                      ArrayRef<CarrySnapshot> snapshots) {
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
}

// Recursively select every non-terminator op in the scf.for body. The
// original scf.yield is consumed by the caller.
LogicalResult selectScfBody(WaveAMDMachineSelector &S, scf::ForOp op) {
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
  if (snap.strideBytes != 0) {
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

LogicalResult collectYieldCarries(WaveAMDMachineSelector &S, scf::YieldOp yield,
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

// Rebind the scf.for results to the waveamdmachine loop op results,
// skipping the synthetic IV carry at slot 0. Pointer carries get
// their sidecar entries reconstructed from the captured base.
void bindLoopResults(WaveAMDMachineSelector &S, scf::ForOp op, Operation *loop,
                     ArrayRef<CarrySnapshot> snapshots) {
  for (auto [idx, scfResult] : llvm::enumerate(op.getResults())) {
    Value wmResult = loop->getResult(idx + 1);
    const CarrySnapshot &snap = snapshots[idx];
    if (snap.kind == CarrySnapshot::Kind::Pointer) {
      S.pointerBases[scfResult] = snap.base;
      if (snap.globalBase)
        S.pointerGlobalBases[scfResult] = snap.globalBase;
      S.values[wmResult] = wmResult;
      FailureOr<PointerOffset> symbolic =
          makeSymbolicCarry(S, snap.resultOffsetName, wmResult, snap.offsetKind,
                            snap.resultU32Upper);
      if (succeeded(symbolic))
        S.pointerIndexOffsets[scfResult] = *symbolic;
      else
        S.pointerIndexOffsets.erase(scfResult);
      S.pointerBuffers[scfResult] = snap.isBuffer;
      continue;
    }
    S.values[scfResult] = wmResult;
  }
}

static void rebindStridedPointerCarries(WaveAMDMachineSelector &S,
                                        scf::ForOp op, Block &loopBody,
                                        ArrayRef<CarrySnapshot> snapshots) {
  Location loc = op.getLoc();
  for (auto [idx, snap] : llvm::enumerate(snapshots)) {
    if (snap.kind != CarrySnapshot::Kind::Pointer || snap.strideBytes == 0)
      continue;
    Value scfArg = op.getRegionIterArgs()[idx];
    Value iv = loopBody.getArgument(0);
    if (snap.isBuffer) {
      Value strideValue = S.mulUniformValues(
          loc, iv, createImm(S.builder, loc, snap.strideBytes));
      if (auto symIt = S.pointerIndexOffsets.find(scfArg);
          symIt != S.pointerIndexOffsets.end())
        if (failed(addSymbolicStride(S, symIt->second, strideValue,
                                     snap.strideName, op.getInductionVar(),
                                     snap.strideBytes)))
          S.pointerIndexOffsets.erase(scfArg);
      continue;
    }
    Value stridedBase =
        recomputeStridedBase(S, loc, snap.base, iv, snap.strideBytes);
    S.pointerBases[scfArg] = stridedBase;
    if (snap.globalBase)
      S.pointerGlobalBases[scfArg] = stridedBase;
  }
}

} // namespace

// `wave.nonzero_trip` skips the entry SCC test (post-tested do/while),
// otherwise an `s_cmp_lt_i32 lower, upper` is materialized immediately
// before the loop op.
LogicalResult selectScfFor(WaveAMDMachineSelector &S, scf::ForOp op) {
  Location loc = op.getLoc();
  Value lower = S.ensureSGPR1(loc, S.expect(op.getLowerBound(), op));
  Value upper = S.ensureSGPR1(loc, S.expect(op.getUpperBound(), op));
  Value step = S.ensureSGPR1(loc, S.expect(op.getStep(), op));

  SmallVector<CarrySnapshot> snapshots;
  if (failed(snapshotScfCarries(S, op, snapshots)))
    return failure();

  Type scc = getSCCType(S.builder.getContext());
  Value entryCond;
  if (!op->hasAttr("wave.nonzero_trip"))
    entryCond =
        waveamdmachine::SCmpLtI32Op::create(S.builder, loc, scc, lower, upper);

  SmallVector<Value> inits;
  inits.push_back(S.materializeSGPR1(loc, lower));
  for (const CarrySnapshot &snap : snapshots)
    inits.push_back(snap.carry);

  Operation *loop = buildUniformLoopOp(S, loc, entryCond, inits);
  Block &loopBody = loop->getRegion(0).front();
  bindLoopBodyArgs(S, op, loopBody, snapshots);

  S.builder.setInsertionPointToStart(&loopBody);
  // Strided pointers: rebind the base to `base + iv*stride` so body
  // loads address through the advancing scalar base instead of a
  // per-lane voffset add. bindLoopBodyArgs already pinned the
  // loop-invariant voffset carry.
  rebindStridedPointerCarries(S, op, loopBody, snapshots);
  if (failed(selectScfBody(S, op)))
    return failure();

  Type sgpr1 =
      getRegType(S.builder.getContext(), waveamdmachine::RegClass::SGPR, 1);
  auto add = waveamdmachine::SAddI32Op::create(S.builder, loc, sgpr1, scc,
                                               loopBody.getArgument(0), step);
  Value nextIv = add.getResult();

  SmallVector<Value> carryOperands{nextIv};
  auto yield = cast<scf::YieldOp>(op.getBody()->getTerminator());
  if (failed(collectYieldCarries(S, yield, snapshots, carryOperands)))
    return failure();

  Value backCond =
      waveamdmachine::SCmpLtI32Op::create(S.builder, loc, scc, nextIv, upper);
  waveamdmachine::ContinueIfOp::create(S.builder, loc, backCond, carryOperands);

  S.builder.setInsertionPointAfter(loop);
  bindLoopResults(S, op, loop, snapshots);
  S.eraseIfTopLevel(op);
  return success();
}

} // namespace mlir::wave::wmsel
