//===- WaveMachineScfFor.cpp - scf.for -> wavemachine.uniform_loop --------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// scf.for lowering for the Wave-to-WaveMachine selector. Snapshots the
// wavemachine "shape" of each iter arg at the loop boundary, builds the
// `wavemachine.uniform_loop` op with the carry list [IV, *iterArgs],
// recursively selects the loop body, and stitches the back-edge IV
// increment + continue_if so the rest of selection treats the loop op
// like any other CFG block.
//
//===----------------------------------------------------------------------===//

#include "WaveMachineSelector.h"

using namespace mlir;
using namespace mlir::wave;
using namespace mlir::waveamd;
using namespace mlir::wave::wmsel;

namespace mlir::wave::wmsel {

namespace {

// Capture the wavemachine "shape" for every `scf.for` iter arg. Wave
// SimdPtr inits resolve through the pointer sidecars (base/offset),
// everything else through the standard `values` map. Pointer carries
// collapse the triple to one VGPR at the loop boundary -- S / inst
// contributions outside the loop bake in here, and the bucketizer
// re-derives them inside the body for each fresh PtrAdd.
LogicalResult snapshotScfCarries(WaveMachineSelector &S, scf::ForOp op,
                                 SmallVectorImpl<CarrySnapshot> &out) {
  out.reserve(op.getInitArgs().size());
  for (Value initArg : op.getInitArgs()) {
    if (auto simd = dyn_cast<SimdType>(initArg.getType());
        simd && isa<PtrType>(simd.getElementType())) {
      auto baseIt = S.pointerBases.find(initArg);
      auto offsetIt = S.pointerOffsets.find(initArg);
      if (baseIt == S.pointerBases.end() || offsetIt == S.pointerOffsets.end())
        return op.emitError(
            "scf.for pointer iter arg has no WaveMachine sidecar");
      Value flat = S.collapseTriple(op.getLoc(), offsetIt->second);
      out.push_back({CarrySnapshot::Kind::Pointer, flat, baseIt->second,
                     S.pointerBuffers.lookup(initArg)});
      continue;
    }
    out.push_back({CarrySnapshot::Kind::WMValue, S.expect(initArg, op),
                   /*base=*/Value{}, /*isBuffer=*/false});
  }
  return success();
}

// Materialize `wavemachine.uniform_loop` with an optional entry
// condition and init carries [IV, *iterArgCarries].
Operation *buildUniformLoopOp(WaveMachineSelector &S, Location loc,
                              Value entryCond, ArrayRef<Value> inits) {
  SmallVector<Type> resultTypes;
  for (Value v : inits)
    resultTypes.push_back(v.getType());
  OperationState state(loc, "wavemachine.uniform_loop");
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
void bindLoopBodyArgs(WaveMachineSelector &S, scf::ForOp op, Block &loopBody,
                      ArrayRef<CarrySnapshot> snapshots) {
  S.values[op.getInductionVar()] = loopBody.getArgument(0);
  for (auto [idx, scfArg] : llvm::enumerate(op.getRegionIterArgs())) {
    Value blockCarry = loopBody.getArgument(idx + 1);
    const CarrySnapshot &snap = snapshots[idx];
    if (snap.kind == CarrySnapshot::Kind::Pointer) {
      S.pointerBases[scfArg] = snap.base;
      S.pointerOffsets[scfArg] = OffsetTriple{blockCarry, Value{}, 0};
      S.pointerBuffers[scfArg] = snap.isBuffer;
      continue;
    }
    S.values[scfArg] = blockCarry;
  }
}

// Recursively select every non-terminator op in the scf.for body. The
// original scf.yield is consumed by the caller.
LogicalResult selectScfBody(WaveMachineSelector &S, scf::ForOp op) {
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

// Build the `continue_if` carry operand list from the scf.yield
// results, looking up pointer offsets through the sidecars and
// enforcing that pointer carries preserve their loop-invariant base.
LogicalResult collectYieldCarries(WaveMachineSelector &S, scf::YieldOp yield,
                                  ArrayRef<CarrySnapshot> snapshots,
                                  SmallVectorImpl<Value> &out) {
  for (auto [idx, y] : llvm::enumerate(yield.getResults())) {
    const CarrySnapshot &snap = snapshots[idx];
    if (snap.kind == CarrySnapshot::Kind::Pointer) {
      auto baseIt = S.pointerBases.find(y);
      auto offsetIt = S.pointerOffsets.find(y);
      if (baseIt == S.pointerBases.end() || offsetIt == S.pointerOffsets.end())
        return yield.emitError(
            "scf.yield pointer carry has no WaveMachine sidecar");
      if (baseIt->second != snap.base)
        return yield.emitError(
            "scf.yield pointer carry must keep loop-invariant base");
      out.push_back(S.collapseTriple(yield.getLoc(), offsetIt->second));
      continue;
    }
    out.push_back(S.expect(y, yield));
  }
  return success();
}

// Rebind the scf.for results to the wavemachine loop op results,
// skipping the synthetic IV carry at slot 0. Pointer carries get
// their sidecar entries reconstructed from the captured base.
void bindLoopResults(WaveMachineSelector &S, scf::ForOp op, Operation *loop,
                     ArrayRef<CarrySnapshot> snapshots) {
  for (auto [idx, scfResult] : llvm::enumerate(op.getResults())) {
    Value wmResult = loop->getResult(idx + 1);
    const CarrySnapshot &snap = snapshots[idx];
    if (snap.kind == CarrySnapshot::Kind::Pointer) {
      S.pointerBases[scfResult] = snap.base;
      S.pointerOffsets[scfResult] = OffsetTriple{wmResult, Value{}, 0};
      S.pointerBuffers[scfResult] = snap.isBuffer;
      continue;
    }
    S.values[scfResult] = wmResult;
  }
}

} // namespace

// `wave.nonzero_trip` skips the entry SCC test (post-tested do/while),
// otherwise an `s_cmp_lt_i32 lower, upper` is materialized immediately
// before the loop op.
LogicalResult selectScfFor(WaveMachineSelector &S, scf::ForOp op) {
  Location loc = op.getLoc();
  Value lower = S.ensureSGPR1(loc, S.expect(op.getLowerBound(), op));
  Value upper = S.ensureSGPR1(loc, S.expect(op.getUpperBound(), op));
  Value step = S.ensureSGPR1(loc, S.expect(op.getStep(), op));

  Type scc = getSCCType(S.builder.getContext());
  Value entryCond;
  if (!op->hasAttr("wave.nonzero_trip"))
    entryCond =
        createInstr(S.builder, loc, "s_cmp_lt_i32", {lower, upper}, scc);

  SmallVector<CarrySnapshot> snapshots;
  if (failed(snapshotScfCarries(S, op, snapshots)))
    return failure();

  SmallVector<Value> inits;
  inits.push_back(S.materializeSGPR1(loc, lower));
  for (const CarrySnapshot &snap : snapshots)
    inits.push_back(snap.carry);

  Operation *loop = buildUniformLoopOp(S, loc, entryCond, inits);
  Block &loopBody = loop->getRegion(0).front();
  bindLoopBodyArgs(S, op, loopBody, snapshots);

  S.builder.setInsertionPointToStart(&loopBody);
  if (failed(selectScfBody(S, op)))
    return failure();

  Type sgpr1 =
      getRegType(S.builder.getContext(), wavemachine::RegClass::SGPR, 1);
  Operation *add =
      createWMOp(S.builder, loc, "s_add_i32", {loopBody.getArgument(0), step},
                 TypeRange{sgpr1, scc});
  Value nextIv = add->getResult(0);
  Value backCond =
      createInstr(S.builder, loc, "s_cmp_lt_i32", {nextIv, upper}, scc);

  SmallVector<Value> contOperands{backCond, nextIv};
  auto yield = cast<scf::YieldOp>(op.getBody()->getTerminator());
  if (failed(collectYieldCarries(S, yield, snapshots, contOperands)))
    return failure();
  createWMOp(S.builder, loc, "continue_if", contOperands, TypeRange{});

  S.builder.setInsertionPointAfter(loop);
  bindLoopResults(S, op, loop, snapshots);
  S.eraseIfTopLevel(op);
  return success();
}

} // namespace mlir::wave::wmsel
