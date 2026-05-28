//===- WaveAMDMachine.cpp - Wave to WaveAMDMachine backend passes -----*- C++
//-*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/Wave/Transforms/Passes.h"

#include "Utils/AMDGPUBaseInfo.h"
#include "WaveAMDMachineSelector.h"
#include "mlir/Analysis/DataFlow/DeadCodeAnalysis.h"
#include "mlir/Analysis/DataFlow/IntegerRangeAnalysis.h"
#include "mlir/Analysis/DataFlow/Utils.h"
#include "mlir/Analysis/DataFlowFramework.h"
#include "mlir/Dialect/Arith/IR/Arith.h"
#include "mlir/Dialect/Func/IR/FuncOps.h"
#include "mlir/Dialect/SCF/IR/SCF.h"
#include "mlir/Dialect/Wave/IR/Wave.h"
#include "mlir/Dialect/Wave/IR/WaveAMD.h"
#include "mlir/Dialect/Wave/IR/WaveSymbols.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachine.h"
#include "mlir/IR/Builders.h"
#include "mlir/IR/BuiltinOps.h"
#include "mlir/IR/PatternMatch.h"
#include "mlir/Interfaces/InferIntRangeInterface.h"
#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/ADT/StringMap.h"
#include "llvm/ADT/StringSwitch.h"
#include "llvm/ADT/TypeSwitch.h"
#include "llvm/Support/Debug.h"
#include "llvm/Support/MathExtras.h"
#include "llvm/TargetParser/TargetParser.h"
#include <limits>
#include <numeric>
#include <optional>

namespace mlir::wave {
#define GEN_PASS_DEF_CONVERTWAVEAMDTOWAVEAMDMACHINE
#include "mlir/Dialect/Wave/Transforms/Passes.h.inc"
} // namespace mlir::wave

using namespace mlir;
using namespace mlir::wave;
using namespace mlir::waveamd;

namespace mlir::wave::wmsel {

// Lane-varying iff the binding is a SIMD value or a lane-pinned
// !wave.index<W>; uniform iff !wave.index<0> or any scalar.
static bool isLaneVaryingType(Type type) {
  if (isa<SimdType>(type))
    return true;
  if (auto idx = dyn_cast<WaveIndexType>(type))
    return idx.getWidth() != 0;
  return false;
}

LogicalResult WaveAMDMachineSelector::run() {
  if (!func.getBody().hasOneBlock())
    return func.emitError("WaveAMDMachine selection supports one-block funcs");

  // Run IntegerRangeAnalysis once over the wave-level body so the
  // bucketizer can convert proven ranges on `wave.index_expr`
  // bindings into ixsimpl assumptions and simplify the AST before
  // routing summands to V / S / inst-offset slots.
  dataflow::loadBaselineAnalyses(rangeSolver);
  rangeSolver.load<dataflow::IntegerRangeAnalysis>();
  if (failed(rangeSolver.initializeAndRun(func)))
    return func.emitError("IntegerRangeAnalysis failed on wave kernel");

  Block &block = func.getBody().front();
  builder.setInsertionPointToStart(&block);
  for (auto [index, arg] : llvm::enumerate(func.getArguments()))
    materializeArgument(arg, index);

  SmallVector<Operation *> topLevelOps;
  for (Operation &op : llvm::make_early_inc_range(block))
    if (!isWaveAMDMachineOp(&op))
      topLevelOps.push_back(&op);

  for (Operation *op : topLevelOps)
    if (failed(selectOperation(op)))
      return failure();

  for (Operation *op : llvm::reverse(opsToErase))
    op->erase();

  auto oldType = func.getFunctionType();
  func.setType(
      FunctionType::get(func.getContext(), oldType.getInputs(), TypeRange{}));
  return success();
}

// Look up the proven signed integer range of `binding` and convert
// it into an ixsimpl `name in [lo, hi]` assumption. Returns
// `nullopt` for SIMD bindings whose lattice is unset, or for
// bindings whose lattice is the trivial `maxRange` (no info).
std::optional<sym::PredHandle>
WaveAMDMachineSelector::bindingAssumption(Value binding, StringRef name) {
  const dataflow::IntegerValueRangeLattice *lattice =
      rangeSolver.lookupState<dataflow::IntegerValueRangeLattice>(binding);
  if (!lattice)
    return std::nullopt;
  IntegerValueRange ivr = lattice->getValue();
  if (ivr.isUninitialized())
    return std::nullopt;
  ConstantIntRanges range = ivr.getValue();
  unsigned w = range.smin().getBitWidth();
  if (w == 0)
    return std::nullopt;
  APInt sminBound = APInt::getSignedMinValue(w);
  APInt smaxBound = APInt::getSignedMaxValue(w);
  if (range.smin() == sminBound && range.smax() == smaxBound)
    return std::nullopt;
  auto handle =
      sym::rangeAssumption(symbolStore(), name, range.smin().getSExtValue(),
                           range.smax().getSExtValue());
  if (failed(handle))
    return std::nullopt;
  return *handle;
}

// Sum the triple into a single VGPR voffset value.
Value WaveAMDMachineSelector::collapseTriple(Location loc,
                                             const OffsetTriple &t) {
  Value v = t.voffset;
  if (t.soffset)
    v = v ? addByteOffsets(loc, v, t.soffset) : t.soffset;
  if (t.instOffset != 0) {
    Value imm = createImm(builder, loc, t.instOffset);
    v = v ? addByteOffsets(loc, v, imm) : imm;
  }
  return v ? v : createImm(builder, loc, 0);
}

// Multiply each slot of `t` by `size`. Used by selectPtrAdd to
// convert element offsets into byte offsets without losing the
// V / S / inst split. Power-of-two `size` lowers to shifts; the
// imm fast paths in the V / S adders fold size==1 / instOffset==0
// upstream.
OffsetTriple WaveAMDMachineSelector::scaleTriple(Location loc, OffsetTriple t,
                                                 unsigned size) {
  if (size == 1)
    return t;
  OffsetTriple out;
  out.instOffset = t.instOffset * static_cast<int64_t>(size);
  Type vgprType =
      getRegType(builder.getContext(), waveamdmachine::RegClass::VGPR);
  Type sgprType =
      getRegType(builder.getContext(), waveamdmachine::RegClass::SGPR);
  if (t.voffset) {
    if (std::optional<int64_t> imm = getImmediateValue(t.voffset)) {
      out.voffset = createImm(builder, loc, *imm * size);
    } else {
      out.voffset = waveamdmachine::VLshlrevB32Op::create(
          builder, loc, vgprType, t.voffset,
          createImm(builder, loc, llvm::Log2_32(size)));
    }
  }
  if (t.soffset) {
    if (std::optional<int64_t> imm = getImmediateValue(t.soffset)) {
      out.soffset = createImm(builder, loc, *imm * size);
    } else if ((size & (size - 1)) == 0) {
      out.soffset = waveamdmachine::SLshlB32Op::create(
          builder, loc, sgprType, t.soffset,
          createImm(builder, loc, llvm::Log2_32(size)));
    } else {
      out.soffset = waveamdmachine::SMulI32Op::create(
          builder, loc, sgprType, createImm(builder, loc, size), t.soffset);
    }
  }
  // Scale the symbolic forms too so the emit-time width check sees
  // the final byte-offset range, not the pre-scale element range.
  if (t.voffsetExpr || t.soffsetExpr) {
    auto sizeExpr = sym::composeExprInt(symbolStore(), size);
    if (succeeded(sizeExpr)) {
      out.voffsetExpr = scaleBucketExpr(t.voffsetExpr, sizeExpr->raw());
      out.soffsetExpr = scaleBucketExpr(t.soffsetExpr, sizeExpr->raw());
    }
  }
  out.assumptions = t.assumptions;
  return out;
}

// Push `imm` into soffset when the spec has the slot; otherwise
// into voffset. The sink threads through the index engine: the
// constant's IXS_INT term is appended to the destination slot's
// symbolic expression so range proofs and emit-time peels see the
// same content as the Value chain.
void WaveAMDMachineSelector::sinkImmIntoRemainingSlot(Location loc,
                                                      OffsetTriple &t,
                                                      Value imm,
                                                      bool hasSoffset) {
  std::optional<int64_t> immValue = getImmediateValue(imm);
  FailureOr<sym::ExprHandle> immExpr =
      immValue ? sym::composeExprInt(symbolStore(), *immValue)
               : FailureOr<sym::ExprHandle>{failure()};
  if (hasSoffset) {
    t.soffset = addUniformBytes(loc, t.soffset, imm);
    if (succeeded(immExpr))
      t.soffsetExpr = appendBucketExpr(t.soffsetExpr, immExpr->raw());
    return;
  }
  t.voffset = t.voffset ? addByteOffsets(loc, t.voffset, imm) : imm;
  if (succeeded(immExpr))
    t.voffsetExpr = appendBucketExpr(t.voffsetExpr, immExpr->raw());
}

// True when `t.instOffset` won't fit `spec`'s inst-offset slot
// (covers both an absent slot and an out-of-range value).
bool WaveAMDMachineSelector::instOffsetOverflows(
    const OffsetTriple &t, const waveamdmachine::AddressFieldSpec &spec) {
  if (spec.instOffsetBits == 0)
    return t.instOffset != 0;
  std::pair<int64_t, int64_t> range = waveamdmachine::instOffsetRange(spec);
  return t.instOffset < range.first || t.instOffset > range.second;
}

sym::Store &WaveAMDMachineSelector::symbolStore() {
  return func.getContext()->getLoadedDialect<WaveDialect>()->getSymbolStore();
}

// True iff `expr` provably stays in unsigned 32-bit (`[0, 2^32 - 1]`)
// under the triple's assumption set, or there is nothing symbolic to
// check. A null `expr` means the slot is empty / imm-only and is
// already safe.
bool WaveAMDMachineSelector::slotFitsU32(
    const ::ixs_node *expr, ArrayRef<sym::PredHandle> assumptions) {
  if (!expr)
    return true;
  return sym::provablyInRange(symbolStore(), sym::ExprHandle(expr), assumptions,
                              int64_t{0}, (int64_t{1} << 32) - 1);
}

// Push out-of-range / unsupported inst_offset and an unsupported or
// overwide soffset into the slots `spec` actually has. soffset is
// demoted to voffset when (a) the spec has no S slot, or (b) the
// soffset bucket's proven range overflows 32-bit. voffset is the
// catch-all; an overflow there is a real correctness issue that
// needs a 64-bit lowering, but the bucketizer can't synthesize one
// today and the practical kernels stay well below 2^32, so the
// overflow check stops at soffset.
void WaveAMDMachineSelector::demoteToFitSpec(
    Location loc, OffsetTriple &t,
    const waveamdmachine::AddressFieldSpec &spec) {
  if (instOffsetOverflows(t, spec)) {
    sinkImmIntoRemainingSlot(loc, t, createImm(builder, loc, t.instOffset),
                             spec.hasSoffset);
    t.instOffset = 0;
  }
  bool soffsetFits = slotFitsU32(t.soffsetExpr, t.assumptions);
  if ((!spec.hasSoffset || !soffsetFits) && t.soffset) {
    t.voffset =
        t.voffset ? addByteOffsets(loc, t.voffset, t.soffset) : t.soffset;
    t.voffsetExpr = appendBucketExpr(t.voffsetExpr, t.soffsetExpr);
    t.soffset = Value{};
    t.soffsetExpr = nullptr;
  }
}

WaveAMDMachineSelector::BucketedOperands WaveAMDMachineSelector::bucketForSpec(
    Location loc, OffsetTriple t,
    const waveamdmachine::AddressFieldSpec &spec) {
  demoteToFitSpec(loc, t, spec);
  BucketedOperands out;
  Value vraw = t.voffset ? t.voffset : createImm(builder, loc, 0);
  out.voffset = ensureVGPRForVSrc1(loc, vraw);
  if (spec.hasSoffset)
    out.soffset = t.soffset ? t.soffset : createImm(builder, loc, 0);
  out.instOffset = t.instOffset;
  return out;
}

// Build the `offset` attribute list for a bucketed emit. Empty
// when the inst_offset is zero so the printer continues to elide
// the `offset 0` clause.
SmallVector<NamedAttribute>
WaveAMDMachineSelector::instOffsetAttrs(int64_t value, StringRef attrName) {
  SmallVector<NamedAttribute> attrs;
  if (value != 0)
    attrs.push_back(
        builder.getNamedAttr(attrName, builder.getI64IntegerAttr(value)));
  return attrs;
}

// ixsimpl ADD of two bucket sub-expressions; null slots pass the
// non-null counterpart through verbatim. Failure returns whichever
// side composed successfully (the bucket Value is still correct;
// we just lose the symbolic form for the width check).
const ::ixs_node *
WaveAMDMachineSelector::appendBucketExpr(const ::ixs_node *acc,
                                         const ::ixs_node *add) {
  if (!acc)
    return add;
  if (!add)
    return acc;
  FailureOr<sym::ExprHandle> handle =
      sym::composeExprBinary(symbolStore(), sym::ExprHandle(acc),
                             sym::ExprBinaryOp::Add, sym::ExprHandle(add));
  if (failed(handle))
    return acc;
  return handle->raw();
}

// ixsimpl MUL of `coeff * value`, returning `value` when `coeff` is
// trivially the integer literal 1.
const ::ixs_node *
WaveAMDMachineSelector::scaleBucketExpr(const ::ixs_node *value,
                                        const ::ixs_node *coeff) {
  if (!coeff)
    return value;
  ::ixs_node *c = const_cast<::ixs_node *>(coeff);
  if (ixs_node_tag(c) == IXS_INT && ixs_node_int_val(c) == 1)
    return value;
  if (ixs_node_tag(c) == IXS_RAT && ixs_node_rat_den(c) == 1 &&
      ixs_node_rat_num(c) == 1)
    return value;
  FailureOr<sym::ExprHandle> handle =
      sym::composeExprBinary(symbolStore(), sym::ExprHandle(coeff),
                             sym::ExprBinaryOp::Mul, sym::ExprHandle(value));
  if (failed(handle))
    return value;
  return handle->raw();
}

// Field-wise sum of two triples. Null slots pass the non-null
// operand through verbatim, so the result keeps each slot in its
// natural class (V/S/imm) instead of forcing through a VGPR add.
// Symbolic forms and the assumption set merge alongside the Values
// so the emit-time width check sees the full picture.
OffsetTriple WaveAMDMachineSelector::mergeTriples(Location loc, OffsetTriple a,
                                                  OffsetTriple b) {
  OffsetTriple out;
  out.voffset = !a.voffset   ? b.voffset
                : !b.voffset ? a.voffset
                             : addByteOffsets(loc, a.voffset, b.voffset);
  out.soffset = !a.soffset   ? b.soffset
                : !b.soffset ? a.soffset
                             : addUniformBytes(loc, a.soffset, b.soffset);
  out.instOffset = a.instOffset + b.instOffset;
  out.voffsetExpr = appendBucketExpr(a.voffsetExpr, b.voffsetExpr);
  out.soffsetExpr = appendBucketExpr(a.soffsetExpr, b.soffsetExpr);
  out.assumptions = a.assumptions;
  llvm::append_range(out.assumptions, b.assumptions);
  return out;
}

bool WaveAMDMachineSelector::isBufferPointer(Type type) {
  if (auto simd = dyn_cast<SimdType>(type))
    type = simd.getElementType();
  auto ptr = dyn_cast<PtrType>(type);
  return ptr && isa<waveamd::BufferAddressSpaceAttr>(ptr.getAddressSpace());
}

bool WaveAMDMachineSelector::isSharedPointer(Type type) {
  if (auto simd = dyn_cast<SimdType>(type))
    type = simd.getElementType();
  auto ptr = dyn_cast<PtrType>(type);
  return ptr && isa<SharedAddressSpaceAttr>(ptr.getAddressSpace());
}

unsigned WaveAMDMachineSelector::pointerBaseWidth(Type type) {
  return isBufferPointer(type) ? 4 : 2;
}

// Register-tuple width for a non-pointer arg type: round the element
// bit-width up to whole 32-bit dwords. i32 -> 1, i64 -> 2.
unsigned WaveAMDMachineSelector::nonPointerArgWidth(Type type) {
  Type elt = type;
  if (auto simd = dyn_cast<SimdType>(type))
    elt = simd.getElementType();
  if (elt.isIntOrFloat())
    return (elt.getIntOrFloatBitWidth() + 31) / 32;
  return 1;
}

void WaveAMDMachineSelector::materializeArgument(BlockArgument arg,
                                                 size_t index) {
  Type type = arg.getType();
  bool isPtr = isa<PtrType>(type);
  waveamdmachine::RegClass regClass = isa<SimdType>(type)
                                          ? waveamdmachine::RegClass::VGPR
                                          : waveamdmachine::RegClass::SGPR;
  unsigned width = isPtr ? pointerBaseWidth(type) : nonPointerArgWidth(type);
  auto argOp = waveamdmachine::ArgOp::create(
      builder, func.getLoc(), getRegType(func.getContext(), regClass, width),
      builder.getI64IntegerAttr(index), builder.getBoolAttr(isPtr));
  values[arg] = argOp;
  if (!isPtr)
    return;
  pointerBases[arg] = argOp;
  pointerOffsets[arg] = OffsetTriple{};
  pointerBuffers[arg] = isBufferPointer(type);
}

std::string WaveAMDMachineSelector::makeLabel(StringRef stem) {
  return (Twine(".Lwave_") + func.getSymName() + "_" + stem + "_" +
          Twine(nextLabel++))
      .str();
}

Value WaveAMDMachineSelector::expect(Value value, Operation *user) {
  auto it = values.find(value);
  if (it != values.end())
    return it->second;
  user->emitError("value has no WaveAMDMachine location");
  return createImm(builder, user->getLoc(), 0);
}

void WaveAMDMachineSelector::eraseIfTopLevel(Operation *op) {
  if (op->getBlock()->getParentOp() == func)
    opsToErase.push_back(op);
}

LogicalResult WaveAMDMachineSelector::selectOperation(Operation *op) {
  // Reset the insertion point only when stepping into a fresh top-level
  // op (either directly inside the function body, or inside a
  // structured loop body whose pre/post layout we are rebuilding from
  // scratch).
  Operation *parentOp = op->getBlock()->getParentOp();
  if (parentOp == func || isa<waveamdmachine::UniformLoopOp>(parentOp))
    builder.setInsertionPoint(op);
  return llvm::TypeSwitch<Operation *, LogicalResult>(op)
      .Case<arith::ConstantIntOp>([&](auto o) { return selectConstant(o); })
      .Case<LaneIdOp>([&](auto o) { return selectLaneId(o); })
      .Case<ReadCyclesOp>([&](auto o) { return selectReadCycles(o); })
      .Case<WorkgroupIdOp>([&](auto o) { return selectWorkgroupId(o); })
      .Case<WorkitemIdOp>([&](auto o) { return selectWorkitemId(o); })
      .Case<SplatOp>([&](auto o) { return selectSplat(o); })
      .Case<AssumeRangeOp>([&](auto o) { return selectAssumeRange(o); })
      .Case<BinaryOp>([&](auto o) { return selectBinary(o); })
      .Case<AddiOp>([&](auto o) { return selectAddi(o); })
      .Case<MuliOp>([&](auto o) { return selectMuli(o); })
      .Case<ShliOp>([&](auto o) { return selectShli(o); })
      .Case<FAddOp>([&](auto o) { return selectFAdd(o); })
      .Case<FSubOp>([&](auto o) { return selectFSub(o); })
      .Case<FMulOp>([&](auto o) { return selectFMul(o); })
      .Case<FMaxOp>([&](auto o) { return selectFMax(o); })
      .Case<FExp2Op>([&](auto o) { return selectFExp2(o); })
      .Case<FRcpOp>([&](auto o) { return selectFRcp(o); })
      .Case<IndexExprOp>([&](auto o) { return selectIndexExpr(o); })
      .Case<CmpIOp>([&](auto o) { return selectCmp(o); })
      .Case<BallotOp>([&](auto o) { return selectBallot(o); })
      .Case<ReadFirstOp>([&](auto o) { return selectReadFirst(o); })
      .Case<PtrAddOp>([&](auto o) { return selectPtrAdd(o); })
      .Case<waveamd::MakeBufferOp>([&](auto o) { return selectMakeBuffer(o); })
      .Case<TokenOp>([&](auto o) { return selectToken(o); })
      .Case<AfterOp, JoinOp>([&](auto o) { return selectTokenJoin(o); })
      .Case<WaitOp>([&](auto o) { return selectWait(o); })
      .Case<WhereOp>([&](auto o) { return selectWhere(o); })
      .Case<StoreOp>([&](auto o) { return selectStore(*this, o); })
      .Case<LoadOp>([&](auto o) { return selectLoad(*this, o); })
      .Case<LdsBaseOp>([&](auto o) { return selectLdsBase(o); })
      .Case<BarrierOp>([&](auto o) { return selectBarrier(o); })
      .Case<waveamd::FragmentFillOp>(
          [&](auto o) { return selectFragmentFill(o); })
      .Case<waveamd::FragmentPackOp>(
          [&](auto o) { return selectFragmentPack(o); })
      .Case<waveamd::MmaOp>([&](auto o) { return selectMma(o); })
      .Case<waveamd::DmaLoadLdsOp>([&](auto o) { return selectDmaLoadLds(o); })
      .Case<waveamd::FragmentUnpackOp>(
          [&](auto o) { return selectFragmentUnpack(o); })
      .Case<func::ReturnOp>([&](auto o) { return selectReturn(o); })
      .Case<scf::ForOp>([&](auto o) { return selectScfFor(*this, o); })
      .Case<scf::YieldOp>([&](auto) {
        // scf.yield is consumed by selectScfFor; we drop it here.
        return success();
      })
      .Case<YieldOp>([&](auto) { return success(); })
      .Default([&](auto) {
        return op->emitError(
            "unsupported operation in WaveAMDMachine selection");
      });
}

LogicalResult WaveAMDMachineSelector::selectConstant(arith::ConstantIntOp op) {
  unsigned bits = op.getType().getIntOrFloatBitWidth();
  if (bits == 64) {
    // i64 constants land in an SGPR pair; the asm printer expands
    // them into two `s_mov_b32` instructions for the halves.
    auto mov = waveamdmachine::SMovB64ImmOp::create(
        builder, op.getLoc(),
        getRegType(op.getContext(), waveamdmachine::RegClass::SGPR, /*w=*/2),
        builder.getI64IntegerAttr(op.value()));
    values[op.getResult()] = mov;
    eraseIfTopLevel(op);
    return success();
  }
  values[op.getResult()] = createImm(builder, op.getLoc(), op.value());
  eraseIfTopLevel(op);
  return success();
}

LogicalResult WaveAMDMachineSelector::selectLaneId(LaneIdOp op) {
  auto simdType = cast<SimdType>(op.getType());
  if (!simdType.getElementType().isInteger(32) || simdType.getWidth() != 32)
    return op.emitError(
        "WaveAMDMachine backend supports only !wave.simd<i32, 32> lane_id");
  values[op.getResult()] = waveamdmachine::VMbcntLoOp::create(
      builder, op.getLoc(),
      getRegType(op.getContext(), waveamdmachine::RegClass::VGPR));
  eraseIfTopLevel(op);
  return success();
}

// Lowers to s_getreg_shader_cycles on gfx11. The op's archPredicate
// rejects construction on other archs; if it returns a null Value we
// surface that with a clean error rather than letting downstream
// emission blow up.
LogicalResult WaveAMDMachineSelector::selectReadCycles(ReadCyclesOp op) {
  Value v = waveamdmachine::SGetregShaderCyclesOp::create(
      builder, op.getLoc(),
      getRegType(op.getContext(), waveamdmachine::RegClass::SGPR));
  if (!v)
    return op.emitError(
        "wave.read_cycles is only wired for gfx11 (HW_REG_SHADER_CYCLES)");
  values[op.getResult()] = v;
  eraseIfTopLevel(op);
  return success();
}

LogicalResult WaveAMDMachineSelector::selectWorkgroupId(WorkgroupIdOp op) {
  int64_t sgprIndex;
  switch (op.getAxis()) {
  case 0:
    sgprIndex = 2;
    break;
  case 1:
    sgprIndex = 3;
    break;
  case 2:
    sgprIndex = 4;
    break;
  default:
    return op.emitError("workgroup_id axis must be 0, 1, or 2");
  }
  Type pinned =
      getPinnedRegType(op.getContext(), waveamdmachine::RegClass::SGPR,
                       /*width=*/1, sgprIndex);
  Value result;
  switch (op.getAxis()) {
  case 0:
    result =
        waveamdmachine::SWorkgroupIdXOp::create(builder, op.getLoc(), pinned);
    break;
  case 1:
    result =
        waveamdmachine::SWorkgroupIdYOp::create(builder, op.getLoc(), pinned);
    break;
  default:
    result =
        waveamdmachine::SWorkgroupIdZOp::create(builder, op.getLoc(), pinned);
    break;
  }
  values[op.getResult()] = result;
  eraseIfTopLevel(op);
  return success();
}

LogicalResult WaveAMDMachineSelector::selectWorkitemId(WorkitemIdOp op) {
  if (op.getAxis() != 0)
    return op.emitError(
        "WaveAMDMachine backend supports only workitem_id along axis 0 (x)");
  values[op.getResult()] = waveamdmachine::VWorkitemIdXOp::create(
      builder, op.getLoc(),
      getPinnedRegType(op.getContext(), waveamdmachine::RegClass::VGPR,
                       /*width=*/1, /*index=*/0));
  eraseIfTopLevel(op);
  return success();
}

LogicalResult WaveAMDMachineSelector::selectSplat(SplatOp op) {
  values[op.getResult()] = expect(op.getSource(), op);
  eraseIfTopLevel(op);
  return success();
}

// `wave.assume_range` is identity at runtime: the asserted range is
// a producer-side hint for IntRangeAnalysis, not a runtime check.
// The selected value passes straight through.
LogicalResult WaveAMDMachineSelector::selectAssumeRange(AssumeRangeOp op) {
  values[op.getResult()] = expect(op.getValue(), op);
  eraseIfTopLevel(op);
  return success();
}

// Build the matching `v_*` op for a (legacy) `wave.binary` kind.
// Returns nullptr if `kind` is no longer carried by the binary op
// (addi / muli / shli migrated to their typed siblings).
static Value buildWaveBinary(OpBuilder &builder, Location loc, Type resultType,
                             StringRef kind, Value lhs, Value rhs) {
  if (kind == "andi")
    return waveamdmachine::VAndB32Op::create(builder, loc, resultType, lhs,
                                             rhs);
  if (kind == "ori")
    return waveamdmachine::VOrB32Op::create(builder, loc, resultType, lhs, rhs);
  if (kind == "xori")
    return waveamdmachine::VXorB32Op::create(builder, loc, resultType, lhs,
                                             rhs);
  if (kind == "shri")
    return waveamdmachine::VLshrrevB32Op::create(builder, loc, resultType, lhs,
                                                 rhs);
  return Value{};
}

LogicalResult WaveAMDMachineSelector::selectBinary(BinaryOp op) {
  // addi / muli / shli have moved to dedicated wave.addi / muli / shli
  // ops with full uniform-and-SIMD support; reject those kinds here so
  // stragglers fail loudly instead of silently going through the old
  // SIMD-only path.
  StringRef kind = op.getKind();
  if (kind != "shri" && kind != "andi" && kind != "ori" && kind != "xori")
    return op.emitError("unsupported wave.binary kind '")
           << kind
           << "' (addi/muli/shli migrated to wave.addi/wave.muli/wave.shli)";
  Value lhs = expect(op.getLhs(), op);
  Value rhs = expect(op.getRhs(), op);
  // VOP2 shift / commutative ops require `vsrc1` to be a VGPR.
  if (kind == "shri") {
    lhs = ensureVGPRForVSrc1(op.getLoc(), lhs);
  } else {
    if (isImm(rhs))
      rhs = ensureVGPRForVSrc1(op.getLoc(), rhs);
    if (!isVGPR(lhs) && !isVGPR(rhs))
      lhs = ensureVGPRForVSrc1(op.getLoc(), lhs);
  }
  Type vgprType = getRegType(op.getContext(), waveamdmachine::RegClass::VGPR);
  values[op.getResult()] =
      buildWaveBinary(builder, op.getLoc(), vgprType, kind, lhs, rhs);
  eraseIfTopLevel(op);
  return success();
}

// Element bit-width of an iN or !wave.simd<iN, W> type. Caller has
// already verified the type is one of these via the op verifier.
unsigned WaveAMDMachineSelector::waveArithElementBits(Type type) {
  if (auto simd = dyn_cast<SimdType>(type))
    return simd.getElementType().getIntOrFloatBitWidth();
  return cast<IntegerType>(type).getWidth();
}

LogicalResult WaveAMDMachineSelector::selectAddiI32(AddiOp op) {
  Value lhs = expect(op.getLhs(), op);
  Value rhs = expect(op.getRhs(), op);
  if (!isa<SimdType>(op.getResult().getType())) {
    // Uniform i32 add: s_add_i32 (with a dead SCC result).
    auto added = waveamdmachine::SAddI32Op::create(
        builder, op.getLoc(),
        getRegType(op.getContext(), waveamdmachine::RegClass::SGPR),
        getSCCType(op.getContext()), lhs, rhs);
    values[op.getResult()] = added.getResult();
    eraseIfTopLevel(op);
    return success();
  }
  // SIMD or mixed: v_add_u32 with the existing SGPR-in-vsrc0 shuffle.
  values[op.getResult()] = addByteOffsets(op.getLoc(), lhs, rhs);
  eraseIfTopLevel(op);
  return success();
}

LogicalResult WaveAMDMachineSelector::selectAddiI64(AddiOp op) {
  bool lhsSimd = isa<SimdType>(op.getLhs().getType());
  bool rhsSimd = isa<SimdType>(op.getRhs().getType());
  if (lhsSimd != rhsSimd)
    return op.emitOpError(
        "i64 wave.addi with mixed uniform/SIMD operands is not yet "
        "supported");
  Value lhs = expect(op.getLhs(), op);
  Value rhs = expect(op.getRhs(), op);
  waveamdmachine::RegClass cls =
      lhsSimd ? waveamdmachine::RegClass::VGPR : waveamdmachine::RegClass::SGPR;
  Type resultType = getRegType(op.getContext(), cls, /*width=*/2);
  Value result;
  if (lhsSimd)
    result = waveamdmachine::VAddU64Op::create(builder, op.getLoc(), resultType,
                                               lhs, rhs);
  else
    result = waveamdmachine::SAddU64Op::create(builder, op.getLoc(), resultType,
                                               lhs, rhs);
  values[op.getResult()] = result;
  eraseIfTopLevel(op);
  return success();
}

LogicalResult WaveAMDMachineSelector::selectAddi(AddiOp op) {
  unsigned bits = waveArithElementBits(op.getResult().getType());
  if (bits == 32)
    return selectAddiI32(op);
  if (bits == 64)
    return selectAddiI64(op);
  return op.emitError(
             "WaveAMDMachine backend only supports i32 / i64 wave.addi (got i")
         << bits << ")";
}

LogicalResult WaveAMDMachineSelector::selectMuliI32(MuliOp op) {
  Value lhs = expect(op.getLhs(), op);
  Value rhs = expect(op.getRhs(), op);
  if (!isa<SimdType>(op.getResult().getType())) {
    values[op.getResult()] = waveamdmachine::SMulI32Op::create(
        builder, op.getLoc(),
        getRegType(op.getContext(), waveamdmachine::RegClass::SGPR), lhs, rhs);
    eraseIfTopLevel(op);
    return success();
  }
  // v_mul_lo_u32 is VOP3, operand placement is unconstrained.
  values[op.getResult()] = waveamdmachine::VMulLoU32Op::create(
      builder, op.getLoc(),
      getRegType(op.getContext(), waveamdmachine::RegClass::VGPR), lhs, rhs);
  eraseIfTopLevel(op);
  return success();
}

LogicalResult WaveAMDMachineSelector::selectMuliI64(MuliOp op) {
  bool lhsSimd = isa<SimdType>(op.getLhs().getType());
  bool rhsSimd = isa<SimdType>(op.getRhs().getType());
  if (lhsSimd != rhsSimd)
    return op.emitOpError(
        "i64 wave.muli with mixed uniform/SIMD operands is not yet "
        "supported");
  Value lhs = expect(op.getLhs(), op);
  Value rhs = expect(op.getRhs(), op);
  waveamdmachine::RegClass cls =
      lhsSimd ? waveamdmachine::RegClass::VGPR : waveamdmachine::RegClass::SGPR;
  // Multi-result op: [0] is the i64 product, [1] is a scratch
  // register the asm-printer uses for cross-product temporaries.
  Type productType = getRegType(op.getContext(), cls, /*width=*/2);
  Type scratchType = getRegType(op.getContext(), cls, /*width=*/1);
  Value product;
  if (lhsSimd)
    product = waveamdmachine::VMulU64Op::create(
                  builder, op.getLoc(), productType, scratchType, lhs, rhs)
                  .getResult();
  else
    product = waveamdmachine::SMulU64Op::create(
                  builder, op.getLoc(), productType, scratchType, lhs, rhs)
                  .getResult();
  values[op.getResult()] = product;
  eraseIfTopLevel(op);
  return success();
}

LogicalResult WaveAMDMachineSelector::selectMuli(MuliOp op) {
  unsigned bits = waveArithElementBits(op.getResult().getType());
  if (bits == 32)
    return selectMuliI32(op);
  if (bits == 64)
    return selectMuliI64(op);
  return op.emitError(
             "WaveAMDMachine backend only supports i32 / i64 wave.muli (got i")
         << bits << ")";
}

LogicalResult WaveAMDMachineSelector::selectShliI32(ShliOp op) {
  Value lhs = expect(op.getLhs(), op);
  Value rhs = expect(op.getRhs(), op);
  if (!isa<SimdType>(op.getResult().getType())) {
    values[op.getResult()] = waveamdmachine::SLshlB32Op::create(
        builder, op.getLoc(),
        getRegType(op.getContext(), waveamdmachine::RegClass::SGPR), lhs, rhs);
    eraseIfTopLevel(op);
    return success();
  }
  // VOP2 v_lshlrev_b32: shift amount in src0, value (vsrc1) must be VGPR.
  lhs = ensureVGPRForVSrc1(op.getLoc(), lhs);
  values[op.getResult()] = waveamdmachine::VLshlrevB32Op::create(
      builder, op.getLoc(),
      getRegType(op.getContext(), waveamdmachine::RegClass::VGPR), rhs, lhs);
  eraseIfTopLevel(op);
  return success();
}

LogicalResult WaveAMDMachineSelector::selectShliI64(ShliOp op) {
  bool lhsSimd = isa<SimdType>(op.getLhs().getType());
  bool rhsSimd = isa<SimdType>(op.getRhs().getType());
  if (lhsSimd != rhsSimd)
    return op.emitOpError(
        "i64 wave.shli with mixed uniform/SIMD operands is not yet "
        "supported");
  Value lhs = expect(op.getLhs(), op);
  Value rhs = expect(op.getRhs(), op);
  waveamdmachine::RegClass cls =
      lhsSimd ? waveamdmachine::RegClass::VGPR : waveamdmachine::RegClass::SGPR;
  Type resultType = getRegType(op.getContext(), cls, /*width=*/2);
  // s_lshl_b64 order is (value, shift); v_lshlrev_b64 (rev) flips it
  // to (shift, value). Both extract the low 32 of the i64 shift
  // amount inside the asm printer.
  Value result;
  if (lhsSimd)
    result = waveamdmachine::VLshlrevB64Op::create(builder, op.getLoc(),
                                                   resultType, rhs, lhs);
  else
    result = waveamdmachine::SLshlB64Op::create(builder, op.getLoc(),
                                                resultType, lhs, rhs);
  values[op.getResult()] = result;
  eraseIfTopLevel(op);
  return success();
}

LogicalResult WaveAMDMachineSelector::selectShli(ShliOp op) {
  unsigned bits = waveArithElementBits(op.getResult().getType());
  if (bits == 32)
    return selectShliI32(op);
  if (bits == 64)
    return selectShliI64(op);
  return op.emitError(
             "WaveAMDMachine backend only supports i32 / i64 wave.shli (got i")
         << bits << ")";
}

template <typename MachineOp, typename WaveOp, typename... OperandValues>
static LogicalResult selectF32(WaveAMDMachineSelector &S, WaveOp op,
                               OperandValues... operands) {
  auto toVGPR = [&](Value operand) {
    return S.ensureVGPRForVSrc1(op.getLoc(), S.expect(operand, op));
  };
  S.values[op.getResult()] = MachineOp::create(
      S.builder, op.getLoc(),
      getRegType(S.builder.getContext(), waveamdmachine::RegClass::VGPR),
      toVGPR(operands)...);
  S.eraseIfTopLevel(op);
  return success();
}

LogicalResult WaveAMDMachineSelector::selectFAdd(FAddOp op) {
  return selectF32<waveamdmachine::VAddF32Op>(*this, op, op.getLhs(),
                                              op.getRhs());
}

LogicalResult WaveAMDMachineSelector::selectFSub(FSubOp op) {
  return selectF32<waveamdmachine::VSubF32Op>(*this, op, op.getLhs(),
                                              op.getRhs());
}

LogicalResult WaveAMDMachineSelector::selectFMul(FMulOp op) {
  return selectF32<waveamdmachine::VMulF32Op>(*this, op, op.getLhs(),
                                              op.getRhs());
}

LogicalResult WaveAMDMachineSelector::selectFMax(FMaxOp op) {
  return selectF32<waveamdmachine::VMaxF32Op>(*this, op, op.getLhs(),
                                              op.getRhs());
}

LogicalResult WaveAMDMachineSelector::selectFExp2(FExp2Op op) {
  return selectF32<waveamdmachine::VExpF32Op>(*this, op, op.getSource());
}

LogicalResult WaveAMDMachineSelector::selectFRcp(FRcpOp op) {
  return selectF32<waveamdmachine::VRcpF32Op>(*this, op, op.getSource());
}

// Materialize an SGPR or immediate value into a fresh VGPR so it can be
// used in a position that the AMDGPU e32 encoding restricts to VGPR_32
// (typically `vsrc1` on commutative VALU ops or the value operand of
// `v_lshlrev_b32`). VGPR sources are returned as-is.
Value WaveAMDMachineSelector::ensureVGPRForVSrc1(Location loc, Value v) {
  if (isVGPR(v))
    return v;
  return waveamdmachine::VMovB32TupleOp::create(
      builder, loc,
      getRegType(builder.getContext(), waveamdmachine::RegClass::VGPR,
                 /*width=*/1),
      v);
}

LogicalResult WaveAMDMachineSelector::selectCmp(CmpIOp op) {
  auto maskType = cast<MaskType>(op.getType());
  if (maskType.getWidth() != 32)
    return op.emitError("WaveAMDMachine backend supports only !wave.mask<32>");
  Type sgprType = getRegType(op.getContext(), waveamdmachine::RegClass::SGPR);
  Value lhs = expect(op.getLhs(), op);
  Value rhs = expect(op.getRhs(), op);
  Value result;
  StringRef predicate = stringifyCmpIPredicate(op.getPredicate());
  if (predicate == "eq")
    result = waveamdmachine::VCmpEqU32Op::create(builder, op.getLoc(), sgprType,
                                                 lhs, rhs);
  else if (predicate == "ne")
    result = waveamdmachine::VCmpNeU32Op::create(builder, op.getLoc(), sgprType,
                                                 lhs, rhs);
  else if (predicate == "ult")
    result = waveamdmachine::VCmpLtU32Op::create(builder, op.getLoc(), sgprType,
                                                 lhs, rhs);
  else if (predicate == "ule")
    result = waveamdmachine::VCmpLeU32Op::create(builder, op.getLoc(), sgprType,
                                                 lhs, rhs);
  else if (predicate == "ugt")
    result = waveamdmachine::VCmpGtU32Op::create(builder, op.getLoc(), sgprType,
                                                 lhs, rhs);
  else if (predicate == "uge")
    result = waveamdmachine::VCmpGeU32Op::create(builder, op.getLoc(), sgprType,
                                                 lhs, rhs);
  else
    return op.emitError("unsupported wave.cmpi predicate");
  values[op.getResult()] = result;
  eraseIfTopLevel(op);
  return success();
}

LogicalResult WaveAMDMachineSelector::selectBallot(BallotOp op) {
  values[op.getResult()] = expect(op.getMask(), op);
  eraseIfTopLevel(op);
  return success();
}

LogicalResult WaveAMDMachineSelector::selectReadFirst(ReadFirstOp op) {
  Value src = expect(op.getSource(), op);
  if (auto regType = dyn_cast<waveamdmachine::RegType>(src.getType());
      regType && regType.getRegClass() == waveamdmachine::RegClass::SGPR) {
    values[op.getResult()] = src;
    eraseIfTopLevel(op);
    return success();
  }
  values[op.getResult()] = waveamdmachine::VReadfirstlaneB32Op::create(
      builder, op.getLoc(),
      getRegType(op.getContext(), waveamdmachine::RegClass::SGPR), src);
  eraseIfTopLevel(op);
  return success();
}

unsigned WaveAMDMachineSelector::elementSizeBytes(Type type) {
  if (auto ptr = dyn_cast<PtrType>(type))
    type = ptr.getElementType();
  if (auto simd = dyn_cast<SimdType>(type))
    type = cast<PtrType>(simd.getElementType()).getElementType();
  if (type.isInteger(8))
    return 1;
  if (type.isInteger(16) || type.isF16())
    return 2;
  if (type.isIntOrFloat() && type.getIntOrFloatBitWidth() == 32)
    return 4;
  return 4;
}

std::optional<int64_t> WaveAMDMachineSelector::getImmediateValue(Value value) {
  auto imm = value.getDefiningOp<waveamdmachine::ImmOp>();
  if (!imm)
    return std::nullopt;
  return imm->getAttrOfType<IntegerAttr>("value").getInt();
}

Value WaveAMDMachineSelector::addByteOffsets(Location loc, Value lhs,
                                             Value rhs) {
  std::optional<int64_t> lhsImm = getImmediateValue(lhs);
  std::optional<int64_t> rhsImm = getImmediateValue(rhs);
  if (lhsImm && rhsImm)
    return createImm(builder, loc, *lhsImm + *rhsImm);
  if (lhsImm && *lhsImm == 0)
    return rhs;
  if (rhsImm && *rhsImm == 0)
    return lhs;
  // v_add_nc_u32_e32 lays operands out as `vdst, vsrc0, vsrc1`, and the
  // VOP2 encoding only allows SGPR/literal in vsrc0 (vsrc1 must be a
  // VGPR). Hoist literals out of the rhs slot the same way
  // `selectBinary` does, otherwise the asm printer will produce
  // `v_add_nc_u32_e32 v, v, <literal>` which the assembler rejects.
  if (isImm(rhs))
    rhs = ensureVGPRForVSrc1(loc, rhs);
  if (!isVGPR(lhs) && !isVGPR(rhs))
    lhs = ensureVGPRForVSrc1(loc, lhs);
  return waveamdmachine::VAddU32Op::create(
      builder, loc,
      getRegType(builder.getContext(), waveamdmachine::RegClass::VGPR), lhs,
      rhs);
}

std::optional<Value>
WaveAMDMachineSelector::foldImmMul(Location loc, std::optional<int64_t> lhsImm,
                                   std::optional<int64_t> rhsImm) {
  if (lhsImm && rhsImm)
    return createImm(builder, loc, *lhsImm * *rhsImm);
  if ((lhsImm && *lhsImm == 0) || (rhsImm && *rhsImm == 0))
    return createImm(builder, loc, 0);
  return std::nullopt;
}

Value WaveAMDMachineSelector::mulIndexValues(Location loc, Value lhs,
                                             Value rhs) {
  std::optional<int64_t> lhsImm = getImmediateValue(lhs);
  std::optional<int64_t> rhsImm = getImmediateValue(rhs);
  if (auto folded = foldImmMul(loc, lhsImm, rhsImm))
    return *folded;
  if (lhsImm && *lhsImm == 1)
    return rhs;
  if (rhsImm && *rhsImm == 1)
    return lhs;
  // v_mul_lo_u32 is VOP3, so SGPR/literal in either slot is legal.
  return waveamdmachine::VMulLoU32Op::create(
      builder, loc,
      getRegType(builder.getContext(), waveamdmachine::RegClass::VGPR), lhs,
      rhs);
}

// Power-of-two * SGPR1 lowers to `s_lshl_b32`. Returns the lowered
// Value or null when neither operand is a power-of-two literal.
Value WaveAMDMachineSelector::tryLshlPow2(Location loc,
                                          std::optional<int64_t> lhsImm,
                                          Value lhs,
                                          std::optional<int64_t> rhsImm,
                                          Value rhs) {
  std::optional<int64_t> immFactor = lhsImm ? lhsImm : rhsImm;
  if (!immFactor || *immFactor <= 0 || (*immFactor & (*immFactor - 1)) != 0)
    return Value{};
  Value sgpr = lhsImm ? rhs : lhs;
  return waveamdmachine::SLshlB32Op::create(
      builder, loc,
      getRegType(builder.getContext(), waveamdmachine::RegClass::SGPR), sgpr,
      createImm(builder, loc, llvm::Log2_32(*immFactor)));
}

// SGPR-domain multiply for the bucketizer's uniform path. Used when
// both operands are uniform-side values (SGPR1 / imm), so the
// product can land in the soffset slot instead of getting forced
// through `v_mul_lo_u32` into a VGPR.
Value WaveAMDMachineSelector::mulUniformValues(Location loc, Value lhs,
                                               Value rhs) {
  std::optional<int64_t> lhsImm = getImmediateValue(lhs);
  std::optional<int64_t> rhsImm = getImmediateValue(rhs);
  if (auto folded = foldImmMul(loc, lhsImm, rhsImm))
    return *folded;
  if (lhsImm && *lhsImm == 1)
    return rhs;
  if (rhsImm && *rhsImm == 1)
    return lhs;
  if (Value shifted = tryLshlPow2(loc, lhsImm, lhs, rhsImm, rhs))
    return shifted;
  return waveamdmachine::SMulI32Op::create(
      builder, loc,
      getRegType(builder.getContext(), waveamdmachine::RegClass::SGPR), lhs,
      rhs);
}

// SGPR-or-VGPR power-of-two right shift (logical). Picks the
// register class that matches `v`'s domain so a uniform value stays
// uniform.
Value WaveAMDMachineSelector::shrPow2(Location loc, Value v, unsigned log2Den) {
  if (log2Den == 0)
    return v;
  Value shiftAmt = createImm(builder, loc, log2Den);
  if (std::optional<int64_t> imm = getImmediateValue(v))
    return createImm(builder, loc, *imm >> log2Den);
  if (isUniformValue(v))
    return waveamdmachine::SLshrB32Op::create(
        builder, loc,
        getRegType(builder.getContext(), waveamdmachine::RegClass::SGPR), v,
        shiftAmt);
  Value vgpr = ensureVGPRForVSrc1(loc, v);
  return waveamdmachine::VLshrrevB32Op::create(
      builder, loc,
      getRegType(builder.getContext(), waveamdmachine::RegClass::VGPR), vgpr,
      shiftAmt);
}

// SGPR-or-VGPR bitwise AND with a literal mask, for power-of-two
// modulo. `mask` is `divisor - 1`.
Value WaveAMDMachineSelector::andMask(Location loc, Value v, int64_t mask) {
  Value m = createImm(builder, loc, mask);
  if (std::optional<int64_t> imm = getImmediateValue(v))
    return createImm(builder, loc, *imm & mask);
  if (isUniformValue(v))
    return waveamdmachine::SAndB32Op::create(
        builder, loc,
        getRegType(builder.getContext(), waveamdmachine::RegClass::SGPR), v, m);
  Value vgpr = ensureVGPRForVSrc1(loc, v);
  return waveamdmachine::VAndB32Op::create(
      builder, loc,
      getRegType(builder.getContext(), waveamdmachine::RegClass::VGPR), vgpr,
      m);
}

// True iff `v` is a uniform-side value: an immediate, or an SGPR1
// register. Used by the bucketizer to recognize when a materialized
// summand can land in the `soffset` slot without an SGPR /
// VGPR demotion.
bool WaveAMDMachineSelector::isUniformValue(Value v) {
  if (!v)
    return false;
  if (isImm(v))
    return true;
  auto rt = dyn_cast<waveamdmachine::RegType>(v.getType());
  return rt && rt.getRegClass() == waveamdmachine::RegClass::SGPR &&
         rt.getWidth() == 1;
}

// Imm-fold path for SGPR-side adds: imm+imm collapses to one imm,
// imm-zero on either side returns the other operand. Returns null
// when the inputs need a real s_add_i32.
Value WaveAMDMachineSelector::foldImmAdd(Location loc, Value lhs, Value rhs) {
  std::optional<int64_t> lhsImm = getImmediateValue(lhs);
  std::optional<int64_t> rhsImm = getImmediateValue(rhs);
  if (lhsImm && rhsImm)
    return createImm(builder, loc, *lhsImm + *rhsImm);
  if (lhsImm && *lhsImm == 0)
    return rhs;
  if (rhsImm && *rhsImm == 0)
    return lhs;
  return Value{};
}

// Append `add` to the SGPR-side accumulator. Imm pairs collapse via
// `foldImmAdd`; otherwise emits `s_add_i32`, swapping operands when
// needed because the lhs must be an SGPR1, not an imm.
Value WaveAMDMachineSelector::addUniformBytes(Location loc, Value acc,
                                              Value add) {
  if (!acc)
    return add;
  if (!add)
    return acc;
  if (Value folded = foldImmAdd(loc, acc, add))
    return folded;
  if (isImm(acc) && !isImm(add))
    std::swap(acc, add);
  auto sum = waveamdmachine::SAddI32Op::create(
      builder, loc,
      getRegType(builder.getContext(), waveamdmachine::RegClass::SGPR),
      getSCCType(builder.getContext()), acc, add);
  return sum.getResult();
}

LogicalResult WaveAMDMachineSelector::selectIndexExpr(IndexExprOp op) {
  llvm::StringMap<Value> substitution;
  llvm::StringMap<TermKind> symKinds;
  llvm::SmallVector<sym::PredHandle> assumptions;
  for (auto [nameAttr, binding] : llvm::zip(op.getNames(), op.getBindings())) {
    StringRef key = cast<StringAttr>(nameAttr).getValue();
    substitution[key] = expect(binding, op);
    symKinds[key] = isLaneVaryingType(binding.getType()) ? TermKind::Lane
                                                         : TermKind::Uniform;
    if (std::optional<sym::PredHandle> a = bindingAssumption(binding, key))
      assumptions.push_back(*a);
  }
  sym::ExprHandle exprHandle{op.getExpr().getNode()};
  FailureOr<sym::ExprHandle> simplified =
      sym::simplifyExpr(symbolStore(), exprHandle, assumptions);
  ::ixs_node *root = const_cast<::ixs_node *>(
      succeeded(simplified) ? simplified->raw() : exprHandle.raw());
  OffsetTriple triple{};
  triple.assumptions.assign(assumptions.begin(), assumptions.end());
  if (failed(bucketize(*this, root, op, substitution, symKinds, triple)))
    return failure();
  indexTriples[op.getResult()] = triple;
  // selectPtrAdd reads the bucketed triple directly; everyone else
  // (wave.binary, debug printers) goes through the `values` map and
  // needs a single collapsed VGPR. Skip the collapse when the only
  // users are wave.ptr_add to keep the trivial bucketed lowering
  // free of dead voffset / soffset adders.
  bool needsCollapse =
      llvm::any_of(op.getResult().getUsers(),
                   [](Operation *user) { return !isa<PtrAddOp>(user); });
  if (needsCollapse)
    values[op.getResult()] = collapseTriple(op.getLoc(), triple);
  eraseIfTopLevel(op);
  return success();
}

LogicalResult WaveAMDMachineSelector::selectPtrAdd(PtrAddOp op) {
  auto baseIt = pointerBases.find(op.getBase());
  auto offsetIt = pointerOffsets.find(op.getBase());
  if (baseIt == pointerBases.end() || offsetIt == pointerOffsets.end())
    return op.emitError("WaveAMDMachine backend expects selected base pointer");
  // Snapshot mapped values before mutating any of the maps below; inserting
  // into a DenseMap can rehash and invalidate live iterators.
  Value baseValue = baseIt->second;
  OffsetTriple baseTriple = offsetIt->second;

  OffsetTriple offsetTriple;
  auto tit = indexTriples.find(op.getOffset());
  if (tit != indexTriples.end()) {
    offsetTriple = tit->second;
  } else {
    Value offset = expect(op.getOffset(), op);
    offsetTriple = OffsetTriple{offset, Value{}, 0};
  }
  unsigned size = elementSizeBytes(op.getBase().getType());
  OffsetTriple scaled = scaleTriple(op.getLoc(), offsetTriple, size);
  OffsetTriple merged = mergeTriples(op.getLoc(), baseTriple, scaled);

  pointerBases[op.getResult()] = baseValue;
  pointerOffsets[op.getResult()] = merged;
  pointerBuffers[op.getResult()] = pointerBuffers.lookup(op.getBase());
  values[op.getResult()] = baseValue;
  eraseIfTopLevel(op);
  return success();
}

LogicalResult
WaveAMDMachineSelector::selectMakeBuffer(waveamd::MakeBufferOp op) {
  auto baseIt = pointerBases.find(op.getBase());
  auto offsetIt = pointerOffsets.find(op.getBase());
  if (baseIt == pointerBases.end() || offsetIt == pointerOffsets.end())
    return op.emitError("WaveAMDMachine backend expects selected base pointer");
  // See selectPtrAdd: snapshot before any DenseMap insertion.
  Value baseValue = baseIt->second;
  OffsetTriple baseTriple = offsetIt->second;
  Value descriptor = waveamdmachine::MakeBufferRsrcOp::create(
      builder, op.getLoc(),
      getRegType(op.getContext(), waveamdmachine::RegClass::SGPR, 4), baseValue,
      expect(op.getRange(), op));
  pointerBases[op.getResult()] = descriptor;
  pointerOffsets[op.getResult()] = baseTriple;
  pointerBuffers[op.getResult()] = true;
  values[op.getResult()] = descriptor;
  eraseIfTopLevel(op);
  return success();
}

LogicalResult WaveAMDMachineSelector::selectToken(TokenOp op) {
  values[op.getResult()] = waveamdmachine::TokenOp::create(
      builder, op.getLoc(), getMemTokenType(op.getContext()));
  eraseIfTopLevel(op);
  return success();
}

LogicalResult WaveAMDMachineSelector::selectTokenJoin(Operation *op) {
  SmallVector<Value> operands;
  for (Value dependency : op->getOperands())
    operands.push_back(expect(dependency, op));
  values[op->getResult(0)] = waveamdmachine::TokenJoinOp::create(
      builder, op->getLoc(), getMemTokenType(op->getContext()), operands);
  eraseIfTopLevel(op);
  return success();
}

LogicalResult WaveAMDMachineSelector::selectWait(WaitOp op) {
  SmallVector<Value> operands;
  for (Value dependency : op.getDependencies())
    operands.push_back(expect(dependency, op));
  waveamdmachine::WaitOp::create(builder, op.getLoc(), operands);
  eraseIfTopLevel(op);
  return success();
}

LogicalResult
WaveAMDMachineSelector::selectFragmentFill(waveamd::FragmentFillOp op) {
  auto fragmentType = cast<waveamd::FragmentType>(op.getResult().getType());
  Value source = expect(op.getSource(), op);
  auto fill = waveamdmachine::VMovB32TupleOp::create(
      builder, op.getLoc(),
      getRegType(op.getContext(), waveamdmachine::RegClass::VGPR,
                 fragmentType.getRegisters()),
      source);
  fill->setAttr("registers",
                builder.getI64IntegerAttr(fragmentType.getRegisters()));
  values[op.getResult()] = fill;
  eraseIfTopLevel(op);
  return success();
}

// FragmentPack is a no-op rename at the WaveAMDMachine level: the per-lane
// register tuple selected for the source SIMD value already has the
// exact register width required by the destination fragment.
LogicalResult
WaveAMDMachineSelector::selectFragmentPack(waveamd::FragmentPackOp op) {
  values[op.getResult()] = expect(op.getRegisters(), op);
  eraseIfTopLevel(op);
  return success();
}

// FragmentUnpack is the inverse rename: the fragment's VGPR tuple
// gets routed through the value map as a SIMD-of-vector value so the
// downstream `wave.store` (or LDS pipeline) treats it like any other
// per-lane register tuple.
LogicalResult
WaveAMDMachineSelector::selectFragmentUnpack(waveamd::FragmentUnpackOp op) {
  values[op.getResult()] = expect(op.getFragment(), op);
  eraseIfTopLevel(op);
  return success();
}

LogicalResult WaveAMDMachineSelector::selectLdsBase(LdsBaseOp op) {
  Value baseValue = createImm(builder, op.getLoc(), 0);
  pointerBases[op.getResult()] = baseValue;
  pointerOffsets[op.getResult()] =
      OffsetTriple{Value{}, Value{}, static_cast<int64_t>(op.getOffset())};
  values[op.getResult()] = baseValue;
  eraseIfTopLevel(op);
  return success();
}

LogicalResult WaveAMDMachineSelector::selectBarrier(BarrierOp op) {
  SmallVector<Value> operands;
  for (Value dependency : op.getDependencies())
    operands.push_back(expect(dependency, op));
  auto barrier = waveamdmachine::SBarrierOp::create(
      builder, op.getLoc(), getMemTokenType(op.getContext()), operands);
  values[op.getToken()] = barrier->getResult(0);
  eraseIfTopLevel(op);
  return success();
}

LogicalResult WaveAMDMachineSelector::selectMma(waveamd::MmaOp op) {
  StringRef kind = op.getKind();
  auto resultType = cast<waveamd::FragmentType>(op.getResult().getType());
  Type vgprTuple = getRegType(op.getContext(), waveamdmachine::RegClass::VGPR,
                              resultType.getRegisters());
  Value a = expect(op.getA(), op);
  Value b = expect(op.getB(), op);
  Value acc = expect(op.getAcc(), op);
  Value result;
  if (kind == "wmma.i32.16x16x16.iu8")
    result = waveamdmachine::WmmaI32_16x16x16_IU8Op::create(
        builder, op.getLoc(), vgprTuple, a, b, acc);
  else if (kind == "wmma.f32.16x16x16.f16")
    result = waveamdmachine::WmmaF32_16x16x16_F16Op::create(
        builder, op.getLoc(), vgprTuple, a, b, acc);
  else if (kind == "mfma.f32.16x16x16.f16")
    result = waveamdmachine::MfmaF32_16x16x16_F16Op::create(
        builder, op.getLoc(), vgprTuple, a, b, acc);
  else if (kind == "mfma.f32.16x16x32.f16")
    result = waveamdmachine::MfmaF32_16x16x32_F16Op::create(
        builder, op.getLoc(), vgprTuple, a, b, acc);
  else
    return op.emitError("unsupported WaveAMDMachine matrix operation kind");
  values[op.getResult()] = result;
  eraseIfTopLevel(op);
  return success();
}

static FailureOr<std::tuple<Value, OffsetTriple, Value, OffsetTriple>>
lookupDmaPointers(WaveAMDMachineSelector &S, waveamd::DmaLoadLdsOp op) {
  auto srcBaseIt = S.pointerBases.find(op.getSource());
  auto srcOffsetIt = S.pointerOffsets.find(op.getSource());
  auto dstBaseIt = S.pointerBases.find(op.getDest());
  auto dstOffsetIt = S.pointerOffsets.find(op.getDest());
  if (srcBaseIt == S.pointerBases.end() ||
      srcOffsetIt == S.pointerOffsets.end() ||
      dstBaseIt == S.pointerBases.end() ||
      dstOffsetIt == S.pointerOffsets.end())
    return op.emitError("WaveAMDMachine backend expects selected DMA pointers");
  return std::make_tuple(srcBaseIt->second, srcOffsetIt->second,
                         dstBaseIt->second, dstOffsetIt->second);
}

static FailureOr<Value> materializeDmaM0(WaveAMDMachineSelector &S,
                                         waveamd::DmaLoadLdsOp op,
                                         Value dstBase,
                                         OffsetTriple dstTriple) {
  if (dstTriple.voffset)
    return op.emitError("DMA LDS destination must be uniform");
  Value dstAddr = dstBase;
  if (dstTriple.soffset)
    dstAddr = S.addUniformBytes(op.getLoc(), dstAddr, dstTriple.soffset);
  if (dstTriple.instOffset != 0)
    dstAddr = S.addUniformBytes(
        op.getLoc(), dstAddr,
        createImm(S.builder, op.getLoc(), dstTriple.instOffset));
  Value m0Src = S.materializeSGPR1(op.getLoc(), dstAddr);
  return Value{waveamdmachine::SMovM0Op::create(
      S.builder, op.getLoc(), waveamdmachine::M0Type::get(op.getContext()),
      m0Src)};
}

static waveamdmachine::AddressFieldSpec dmaAddressSpec(bool isBuffer,
                                                       int64_t bytes) {
  if (isBuffer)
    return bytes == 16
               ? waveamdmachine::BufferLoadLdsB128Op::getAddressFieldSpec()
               : waveamdmachine::BufferLoadLdsB32Op::getAddressFieldSpec();
  return bytes == 16
             ? waveamdmachine::GlobalLoadLdsB128Op::getAddressFieldSpec()
             : waveamdmachine::GlobalLoadLdsB32Op::getAddressFieldSpec();
}

LogicalResult
WaveAMDMachineSelector::selectDmaLoadLds(waveamd::DmaLoadLdsOp op) {
  if (op.getBytes() != 4 && op.getBytes() != 16)
    return op.emitError("WaveAMDMachine backend supports only bytes = 4 or 16");
  FailureOr<std::tuple<Value, OffsetTriple, Value, OffsetTriple>> ptrs =
      lookupDmaPointers(*this, op);
  if (failed(ptrs))
    return failure();
  auto [srcBase, srcTriple, dstBase, dstTriple] = *ptrs;
  FailureOr<Value> m0 = materializeDmaM0(*this, op, dstBase, dstTriple);
  if (failed(m0))
    return failure();

  bool isBuffer = pointerBuffers.lookup(op.getSource());
  auto b = bucketForSpec(op.getLoc(), srcTriple,
                         dmaAddressSpec(isBuffer, op.getBytes()));
  IntegerAttr instOffsetAttr = builder.getI64IntegerAttr(b.instOffset);
  IntegerAttr auxAttr = op.getAux() != 0 ? op.getAuxAttr() : IntegerAttr{};
  Type tokenType = getMemTokenType(op.getContext());
  Value dep = expect(op.getDependency(), op);
  Value token;
  if (isBuffer) {
    if (op.getBytes() == 16)
      token = waveamdmachine::BufferLoadLdsB128Op::create(
          builder, op.getLoc(), tokenType, b.voffset, srcBase, b.soffset, *m0,
          dep, instOffsetAttr, auxAttr);
    else
      token = waveamdmachine::BufferLoadLdsB32Op::create(
          builder, op.getLoc(), tokenType, b.voffset, srcBase, b.soffset, *m0,
          dep, instOffsetAttr, auxAttr);
  } else {
    if (op.getBytes() == 16)
      token = waveamdmachine::GlobalLoadLdsB128Op::create(
          builder, op.getLoc(), tokenType, b.voffset, srcBase, *m0, dep,
          instOffsetAttr, auxAttr);
    else
      token = waveamdmachine::GlobalLoadLdsB32Op::create(
          builder, op.getLoc(), tokenType, b.voffset, srcBase, *m0, dep,
          instOffsetAttr, auxAttr);
  }
  values[op.getToken()] = token;
  eraseIfTopLevel(op);
  return success();
}

// Ensure `v` is an SGPR1 by inserting a v_readfirstlane_b32 if it is
// currently a VGPR. Imm values pass through as-is. Caller is
// responsible for handling the SIMD lifting (we don't expect SIMD
// here because scf.for operands are index/i32 scalars).
Value WaveAMDMachineSelector::ensureSGPR1(Location loc, Value v) {
  if (auto rt = dyn_cast<waveamdmachine::RegType>(v.getType())) {
    if (rt.getRegClass() == waveamdmachine::RegClass::SGPR &&
        rt.getWidth() == 1)
      return v;
    if (rt.getRegClass() == waveamdmachine::RegClass::VGPR &&
        rt.getWidth() == 1)
      return waveamdmachine::VReadfirstlaneB32Op::create(
          builder, loc,
          getRegType(builder.getContext(), waveamdmachine::RegClass::SGPR), v);
  }
  // Imm passes through; the WaveAMDMachine_SGPR1OrImm constraint accepts it.
  return v;
}

// Strict variant of `ensureSGPR1`: also lifts immediates into a
// freshly allocated SGPR via `s_mov_b32_value`. Required when the
// destination operand constraint is plain WaveAMDMachine_Reg (e.g. a
// `uniform_loop` init carry).
Value WaveAMDMachineSelector::materializeSGPR1(Location loc, Value v) {
  v = ensureSGPR1(loc, v);
  if (isa<waveamdmachine::ImmType>(v.getType()))
    return waveamdmachine::SMovB32ValueOp::create(
        builder, loc,
        getRegType(builder.getContext(), waveamdmachine::RegClass::SGPR), v);
  return v;
}

LogicalResult WaveAMDMachineSelector::selectWhere(WhereOp op) {
  std::string endLabel = makeLabel("endif");
  std::string elseLabel =
      op.getElseRegion().empty() ? endLabel : makeLabel("else");
  Value condition = expect(op.getCondition(), op);
  Value savedExec = waveamdmachine::SAndSaveexecB32Op::create(
      builder, op.getLoc(),
      getRegType(op.getContext(), waveamdmachine::RegClass::SGPR), condition);
  waveamdmachine::SCBranchExeczOp::create(builder, op.getLoc(), elseLabel);
  if (failed(selectRegion(op.getThenRegion())))
    return failure();
  if (!op.getElseRegion().empty()) {
    waveamdmachine::SAndn2ExecB32Op::create(builder, op.getLoc(), savedExec,
                                            condition);
    waveamdmachine::SCBranchExeczOp::create(builder, op.getLoc(), endLabel);
    waveamdmachine::LabelOp::create(builder, op.getLoc(), elseLabel);
    if (failed(selectRegion(op.getElseRegion())))
      return failure();
  }
  waveamdmachine::LabelOp::create(builder, op.getLoc(), endLabel);
  waveamdmachine::SMovExecLoOp::create(builder, op.getLoc(), savedExec);
  eraseIfTopLevel(op);
  return success();
}

LogicalResult WaveAMDMachineSelector::selectRegion(Region &region) {
  if (!region.hasOneBlock())
    return failure();
  for (Operation &op : llvm::make_early_inc_range(region.front())) {
    if (failed(selectOperation(&op)))
      return failure();
  }
  return success();
}

LogicalResult WaveAMDMachineSelector::selectReturn(func::ReturnOp op) {
  if (op.getNumOperands() > 1)
    return op.emitError(
        "WaveAMDMachine backend supports at most one return value");
  if (func->hasAttr(wave::WaveDialect::getKernelAttrName())) {
    if (op.getNumOperands() != 0)
      return op.emitError("kernel functions must return void");
    waveamdmachine::SEndpgmOp::create(builder, op.getLoc());
    op.getOperandsMutable().clear();
    return success();
  }

  if (op.getNumOperands() == 1) {
    Value ret = expect(op.getOperand(0), op);
    auto regType = dyn_cast<waveamdmachine::RegType>(ret.getType());
    if (regType && regType.getRegClass() == waveamdmachine::RegClass::VGPR)
      ret = waveamdmachine::VReadfirstlaneB32Op::create(
          builder, op.getLoc(),
          getRegType(op.getContext(), waveamdmachine::RegClass::SGPR), ret);
    waveamdmachine::SMovB32Op::create(builder, op.getLoc(), "s0", ret);
  }
  waveamdmachine::SSetpcB64Op::create(builder, op.getLoc());
  op.getOperandsMutable().clear();
  return success();
}

} // namespace mlir::wave::wmsel

namespace {

struct ConvertWaveAMDToWaveAMDMachinePass
    : public wave::impl::ConvertWaveAMDToWaveAMDMachineBase<
          ConvertWaveAMDToWaveAMDMachinePass> {
  void runOnOperation() override {
    ModuleOp m = getOperation();
    SmallVector<func::FuncOp> targets;
    m.walk([&](func::FuncOp f) {
      if (f.isExternal())
        return;
      // Pull in funcs that either carry the kernel attribute (the
      // production path -- they live inside `gpu.module`) or contain
      // wave / waveamd ops at any nesting (the test path -- synthetic
      // top-level funcs used to pin selector behaviour). Host glue
      // and runtime helpers fall through untouched.
      if (f->hasAttr(wave::WaveDialect::getKernelAttrName())) {
        targets.push_back(f);
        return;
      }
      bool reachesWave = false;
      f.walk([&](Operation *op) {
        if (isa<wave::WaveDialect, waveamd::WaveAMDDialect>(op->getDialect())) {
          reachesWave = true;
          return WalkResult::interrupt();
        }
        return WalkResult::advance();
      });
      if (reachesWave)
        targets.push_back(f);
    });
    for (func::FuncOp func : targets) {
      if (failed(wave::wmsel::WaveAMDMachineSelector(func).run()))
        return signalPassFailure();
    }
  }
};

} // namespace
