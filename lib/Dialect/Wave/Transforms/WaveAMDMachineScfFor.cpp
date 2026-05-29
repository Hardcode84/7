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

using namespace mlir;
using namespace mlir::wave;
using namespace mlir::waveamd;
using namespace mlir::wave::wmsel;

namespace mlir::wave::wmsel {

namespace {

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
  Value cur = cast<scf::YieldOp>(op.getBody()->getTerminator()).getOperand(i);
  int64_t elems = 0;
  while (auto add = cur.getDefiningOp<PtrAddOp>()) {
    std::optional<int64_t> off = getConstantIntValue(add.getOffset());
    if (!off)
      return 0;
    elems += *off;
    cur = add.getBase();
  }
  return cur == arg && elems ? elems * S.elementSizeBytes(arg.getType()) : 0;
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

// Capture the waveamdmachine "shape" for every `scf.for` iter arg. Wave
// SimdPtr inits resolve through the pointer sidecars (base/offset),
// everything else through the standard `values` map. Pointer carries
// collapse the triple to one VGPR at the loop boundary -- S / inst
// contributions outside the loop bake in here, and the bucketizer
// re-derives them inside the body for each fresh PtrAdd.
LogicalResult snapshotScfCarries(WaveAMDMachineSelector &S, scf::ForOp op,
                                 SmallVectorImpl<CarrySnapshot> &out) {
  out.reserve(op.getInitArgs().size());
  for (auto [idx, initArg] : llvm::enumerate(op.getInitArgs())) {
    if (auto simd = dyn_cast<SimdType>(initArg.getType());
        simd && isa<PtrType>(simd.getElementType())) {
      auto baseIt = S.pointerBases.find(initArg);
      auto offsetIt = S.pointerOffsets.find(initArg);
      if (baseIt == S.pointerBases.end() || offsetIt == S.pointerOffsets.end())
        return op.emitError(
            "scf.for pointer iter arg has no WaveAMDMachine sidecar");
      Value flat = S.collapseTriple(op.getLoc(), offsetIt->second);
      bool isBuffer = S.pointerBuffers.lookup(initArg);
      Value globalBase = S.pointerGlobalBases.lookup(initArg);
      // shared base is a const 0; global marches the SGPR base, buffer
      // marches soffset. LDS skipped.
      int64_t stride = !S.isSharedPointer(initArg.getType())
                           ? stridedCarryBytes(S, op, idx)
                           : 0;
      out.push_back({CarrySnapshot::Kind::Pointer, flat, baseIt->second,
                     globalBase, isBuffer, stride});
      continue;
    }
    out.push_back({CarrySnapshot::Kind::WMValue, S.expect(initArg, op),
                   /*base=*/Value{}, /*globalBase=*/Value{},
                   /*isBuffer=*/false, /*strideBytes=*/0});
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
      OffsetTriple triple;
      triple.voffset = blockCarry;
      triple.addr64Voffset = blockCarry;
      S.pointerOffsets[scfArg] = triple;
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

// Build the `continue_if` carry operand list from the scf.yield
// results, looking up pointer offsets through the sidecars and
// enforcing that pointer carries preserve their loop-invariant base.
LogicalResult collectYieldCarries(WaveAMDMachineSelector &S, scf::YieldOp yield,
                                  ArrayRef<CarrySnapshot> snapshots,
                                  SmallVectorImpl<Value> &out) {
  for (auto [idx, y] : llvm::enumerate(yield.getResults())) {
    const CarrySnapshot &snap = snapshots[idx];
    if (snap.kind == CarrySnapshot::Kind::Pointer) {
      // Strided base lives in the IV recompute; the voffset carry is
      // loop-invariant, so feed the init straight back and let the
      // body's now-dead advance ptr_add fold away.
      if (snap.strideBytes != 0) {
        out.push_back(snap.carry);
        continue;
      }
      auto baseIt = S.pointerBases.find(y);
      auto offsetIt = S.pointerOffsets.find(y);
      if (baseIt == S.pointerBases.end() || offsetIt == S.pointerOffsets.end())
        return yield.emitError(
            "scf.yield pointer carry has no WaveAMDMachine sidecar");
      if (baseIt->second != snap.base)
        return yield.emitError(
            "scf.yield pointer carry must keep loop-invariant base");
      if (snap.globalBase && S.pointerGlobalBases.lookup(y) != snap.globalBase)
        return yield.emitError("scf.yield pointer carry must keep global base");
      out.push_back(S.collapseTriple(yield.getLoc(), offsetIt->second));
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
      OffsetTriple triple;
      triple.voffset = wmResult;
      triple.addr64Voffset = wmResult;
      S.pointerOffsets[scfResult] = triple;
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
      // soffset bucket exists on buffer ops: march there, base SRD fixed.
      S.pointerOffsets[scfArg].soffset = S.mulUniformValues(
          loc, iv, createImm(S.builder, loc, snap.strideBytes));
      S.pointerOffsets[scfArg].addr64Soffset = S.pointerOffsets[scfArg].soffset;
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

  Type scc = getSCCType(S.builder.getContext());
  Value entryCond;
  if (!op->hasAttr("wave.nonzero_trip"))
    entryCond =
        waveamdmachine::SCmpLtI32Op::create(S.builder, loc, scc, lower, upper);

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
  Value backCond =
      waveamdmachine::SCmpLtI32Op::create(S.builder, loc, scc, nextIv, upper);

  SmallVector<Value> contOperands{backCond, nextIv};
  auto yield = cast<scf::YieldOp>(op.getBody()->getTerminator());
  if (failed(collectYieldCarries(S, yield, snapshots, contOperands)))
    return failure();
  waveamdmachine::ContinueIfOp::create(
      S.builder, loc, backCond, ArrayRef<Value>(contOperands).drop_front());

  S.builder.setInsertionPointAfter(loop);
  bindLoopResults(S, op, loop, snapshots);
  S.eraseIfTopLevel(op);
  return success();
}

} // namespace mlir::wave::wmsel
