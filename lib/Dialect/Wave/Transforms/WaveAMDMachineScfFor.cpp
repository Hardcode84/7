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
    std::optional<sym::PredHandle> a = S.bindingAssumption(value, name);
    if (a)
      offset.assumptions.push_back(*a);
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
  if (!hasStride(snap.stride) || snap.isBuffer)
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
  if (hasStride(snap.stride) && !snap.isBuffer)
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
    if (snap.isBuffer) {
      assert(isImmediateStride(snap.stride) &&
             "buffer strided carry must use immediate stride");
      Value strideValue = S.mulUniformValues(
          loc, iv, createImm(S.builder, loc, snap.stride.imm));
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

} // namespace

// `wave.nonzero_trip` skips the entry SCC test (post-tested do/while),
// otherwise an `s_cmp_lt_i32 lower, upper` is materialized immediately
// before the loop op.
LogicalResult selectScfFor(WaveAMDMachineSelector &S, scf::ForOp op) {
  Location loc = op.getLoc();
  Value lower = S.ensureSGPR1(loc, S.expect(op.getLowerBound(), op));
  Value upper = S.ensureSGPR1(loc, S.expect(op.getUpperBound(), op));
  Value step = S.ensureSGPR1(loc, S.expect(op.getStep(), op));

  ScfForCarryPlan carryPlan;
  if (failed(planScfForCarries(S, op, carryPlan)))
    return failure();
  SmallVector<CarrySnapshot> &snapshots = carryPlan.snapshots;
  SmallVector<StridedBaseCarry> &stridedBaseGroups =
      carryPlan.stridedBaseGroups;

  Type scc = getSCCType(S.builder.getContext());
  Value entryCond;
  if (!op->hasAttr("wave.nonzero_trip"))
    entryCond =
        waveamdmachine::SCmpLtI32Op::create(S.builder, loc, scc, lower, upper);

  SmallVector<Value> inits;
  inits.push_back(S.materializeSGPR1(loc, lower));
  for (const CarrySnapshot &snap : snapshots)
    inits.push_back(snap.carry);
  for (const StridedBaseCarry &group : stridedBaseGroups)
    inits.push_back(group.base);

  Operation *loop = buildUniformLoopOp(S, loc, entryCond, inits);
  Block &loopBody = loop->getRegion(0).front();
  bindLoopBodyArgs(S, op, loopBody, snapshots, stridedBaseGroups);

  S.builder.setInsertionPointToStart(&loopBody);
  // Strided pointers: globals use carried bases; buffers use IV-derived
  // soffset.
  rebindStridedPointerCarries(S, op, loopBody, snapshots, stridedBaseGroups);
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
  collectStridedBaseCarries(S, loc, stridedBaseGroups, carryOperands);

  Value backCond =
      waveamdmachine::SCmpLtI32Op::create(S.builder, loc, scc, nextIv, upper);
  waveamdmachine::ContinueIfOp::create(S.builder, loc, backCond, carryOperands);

  S.builder.setInsertionPointAfter(loop);
  bindLoopResults(S, op, loop, snapshots, stridedBaseGroups);
  S.eraseIfTopLevel(op);
  return success();
}

} // namespace mlir::wave::wmsel
