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
#include "mlir/Dialect/Wave/IR/WaveAMDABI.h"
#include "mlir/Dialect/Wave/IR/WaveMeta.h"
#include "mlir/Dialect/Wave/IR/WaveSymbols.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachine.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachineTarget.h"
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
#include "llvm/Support/CheckedArithmetic.h"
#include "llvm/Support/Debug.h"
#include "llvm/Support/ErrorHandling.h"
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

static unsigned bitWidth(Type type) {
  if (auto vecTy = dyn_cast<VectorType>(type)) {
    Type elementType = vecTy.getElementType();
    if (elementType.isIntOrFloat())
      return elementType.getIntOrFloatBitWidth() * vecTy.getNumElements();
  }
  if (type.isIntOrFloat())
    return type.getIntOrFloatBitWidth();
  return 32;
}

static bool isVector2F16(Type type) {
  auto vecTy = dyn_cast<VectorType>(type);
  return vecTy && vecTy.getRank() == 1 && vecTy.getNumElements() == 2 &&
         vecTy.getElementType().isF16();
}

static bool isVector2F32(Type type) {
  auto vecTy = dyn_cast<VectorType>(type);
  return vecTy && vecTy.getRank() == 1 && vecTy.getNumElements() == 2 &&
         vecTy.getElementType().isF32();
}

static bool isSimdF32(Type type) {
  auto simdType = dyn_cast<SimdType>(type);
  return simdType && simdType.getElementType().isF32();
}

static bool isSimdPackedF16(Type type) {
  auto simdType = dyn_cast<SimdType>(type);
  return simdType && isVector2F16(simdType.getElementType());
}

static bool isSimdPackedF32(Type type) {
  auto simdType = dyn_cast<SimdType>(type);
  return simdType && isVector2F32(simdType.getElementType());
}

static FailureOr<llvm::AMDGPU::IsaVersion>
getTargetIsaVersion(Operation *op, StringRef feature) {
  return waveamdmachine::getAMDGPUTargetIsaVersion(op, feature);
}

static LogicalResult requirePackedF16Target(Operation *op, StringRef kind) {
  FailureOr<llvm::AMDGPU::IsaVersion> isa =
      getTargetIsaVersion(op, "packed f16 lowering");
  if (failed(isa))
    return failure();
  if (!waveamdmachine::VPkAddF16Op::isSupportedOnIsa(*isa))
    return op->emitError("packed f16 ") << kind << " lowering requires gfx9+";
  return success();
}

static LogicalResult requirePackedCvtTarget(CastOp op) {
  FailureOr<llvm::AMDGPU::IsaVersion> isa =
      getTargetIsaVersion(op, "packed f32 to f16 lowering");
  if (failed(isa))
    return failure();
  if (!waveamdmachine::VCvtPkRtzF16F32Op::isSupportedOnIsa(*isa))
    return op.emitError("packed f32 to f16 lowering requires gfx10+");
  return success();
}

enum class MmaKind {
  WmmaI32_16x16x16_IU8,
  WmmaF32_16x16x16_F16,
  MfmaF32_16x16x16_F16,
  MfmaF32_16x16x32_F16,
  Unsupported,
};

static MmaKind parseMmaKind(StringRef kind) {
  return llvm::StringSwitch<MmaKind>(kind)
      .Case("wmma.i32.16x16x16.iu8", MmaKind::WmmaI32_16x16x16_IU8)
      .Case("wmma.f32.16x16x16.f16", MmaKind::WmmaF32_16x16x16_F16)
      .Case("mfma.f32.16x16x16.f16", MmaKind::MfmaF32_16x16x16_F16)
      .Case("mfma.f32.16x16x32.f16", MmaKind::MfmaF32_16x16x32_F16)
      .Default(MmaKind::Unsupported);
}

static LogicalResult requireMmaTarget(waveamd::MmaOp op, MmaKind kind,
                                      const llvm::AMDGPU::IsaVersion &isa) {
  auto require = [&](bool supported, StringRef requirement) -> LogicalResult {
    if (supported)
      return success();
    return op.emitError() << op.getKind() << " lowering requires "
                          << requirement;
  };
  switch (kind) {
  case MmaKind::WmmaI32_16x16x16_IU8:
    return require(
        waveamdmachine::WmmaI32_16x16x16_IU8Op::isSupportedOnIsa(isa),
        "gfx11/gfx12");
  case MmaKind::WmmaF32_16x16x16_F16:
    return require(
        waveamdmachine::WmmaF32_16x16x16_F16Op::isSupportedOnIsa(isa),
        "gfx11/gfx12");
  case MmaKind::MfmaF32_16x16x16_F16:
    return require(
        waveamdmachine::MfmaF32_16x16x16_F16Op::isSupportedOnIsa(isa),
        "gfx90a+");
  case MmaKind::MfmaF32_16x16x32_F16:
    return require(
        waveamdmachine::MfmaF32_16x16x32_F16Op::isSupportedOnIsa(isa),
        "gfx950");
  case MmaKind::Unsupported:
    return success();
  }
  llvm_unreachable("unknown MMA kind");
}

static LogicalResult noteWaveWidth(Operation *diagOp,
                                   std::optional<unsigned> &required,
                                   unsigned width) {
  if (width == 0)
    return success();
  if (!required) {
    required = width;
    return success();
  }
  if (*required == width)
    return success();
  return diagOp->emitError("WaveAMDMachine backend requires one wave width per "
                           "function; saw wave")
         << *required << " and wave" << width;
}

static LogicalResult noteTypeWaveWidth(Operation *diagOp, Type type,
                                       std::optional<unsigned> &required) {
  if (auto simd = dyn_cast<SimdType>(type))
    return noteWaveWidth(diagOp, required, simd.getWidth());
  if (auto mask = dyn_cast<MaskType>(type))
    return noteWaveWidth(diagOp, required, mask.getWidth());
  if (auto index = dyn_cast<WaveIndexType>(type))
    return noteWaveWidth(diagOp, required, index.getWidth());
  if (auto fragment = dyn_cast<waveamd::FragmentType>(type))
    return noteWaveWidth(diagOp, required, fragment.getWaveSize());
  if (auto tuple = dyn_cast<TupleType>(type)) {
    for (Type element : tuple.getTypes())
      if (failed(noteTypeWaveWidth(diagOp, element, required)))
        return failure();
  }
  if (auto vector = dyn_cast<VectorType>(type))
    return noteTypeWaveWidth(diagOp, vector.getElementType(), required);
  return success();
}

static LogicalResult noteTypesWaveWidth(Operation *diagOp, TypeRange types,
                                        std::optional<unsigned> &required) {
  for (Type type : types)
    if (failed(noteTypeWaveWidth(diagOp, type, required)))
      return failure();
  return success();
}

static LogicalResult
noteRegionArgsWaveWidth(Operation *diagOp, MutableArrayRef<Region> regions,
                        std::optional<unsigned> &required) {
  for (Region &region : regions) {
    for (Block &block : region) {
      for (BlockArgument arg : block.getArguments()) {
        if (failed(noteTypeWaveWidth(diagOp, arg.getType(), required)))
          return failure();
      }
    }
  }
  return success();
}

static LogicalResult noteOpWaveWidth(Operation *op,
                                     std::optional<unsigned> &required) {
  if (failed(noteTypesWaveWidth(op, op->getOperandTypes(), required)))
    return failure();
  if (failed(noteTypesWaveWidth(op, op->getResultTypes(), required)))
    return failure();
  return noteRegionArgsWaveWidth(op, op->getRegions(), required);
}

static FailureOr<std::optional<unsigned>>
getFunctionWaveWidth(func::FuncOp func) {
  std::optional<unsigned> required;
  FunctionType type = func.getFunctionType();
  if (failed(noteTypesWaveWidth(func, type.getInputs(), required)))
    return failure();
  if (failed(noteTypesWaveWidth(func, type.getResults(), required)))
    return failure();

  WalkResult walk = func.walk([&](Operation *op) {
    return failed(noteOpWaveWidth(op, required)) ? WalkResult::interrupt()
                                                 : WalkResult::advance();
  });
  if (walk.wasInterrupted())
    return failure();
  return required;
}

static LogicalResult validateTargetWaveWidth(func::FuncOp func) {
  if (!waveamdmachine::findAMDGPUTargetModule(func))
    return success();

  FailureOr<unsigned> targetWidth =
      waveamdmachine::getAMDGPUDefaultWavefrontSize(func,
                                                    "WaveAMDMachine selection");
  if (failed(targetWidth))
    return failure();

  FailureOr<std::optional<unsigned>> required = getFunctionWaveWidth(func);
  if (failed(required))
    return failure();
  if (!*required || **required == *targetWidth)
    return success();
  FailureOr<waveamdmachine::AMDGPUTarget> target =
      waveamdmachine::getAMDGPUTarget(func, "WaveAMDMachine selection");
  if (failed(target))
    return failure();
  return func.emitError("WaveAMDMachine backend target ")
         << target->chip << " uses wave" << *targetWidth
         << " but function requires wave" << **required;
}

LogicalResult WaveAMDMachineSelector::run() {
  if (!func.getBody().hasOneBlock())
    return func.emitError("WaveAMDMachine selection supports one-block funcs");
  if (failed(validateTargetWaveWidth(func)))
    return failure();

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

static void scaleTripleExprs(WaveAMDMachineSelector &S, OffsetTriple &out,
                             const OffsetTriple &t, unsigned size) {
  if (!t.voffsetExpr && !t.soffsetExpr && !t.fullExpr)
    return;
  FailureOr<sym::ExprHandle> sizeExpr =
      sym::composeExprInt(S.symbolStore(), size);
  if (failed(sizeExpr))
    return;
  out.voffsetExpr = S.scaleBucketExpr(t.voffsetExpr, sizeExpr->raw());
  out.soffsetExpr = S.scaleBucketExpr(t.soffsetExpr, sizeExpr->raw());
  out.fullExpr = S.scaleBucketExpr(t.fullExpr, sizeExpr->raw());
}

static std::optional<int64_t> checkedAddImm(std::optional<int64_t> lhs,
                                            std::optional<int64_t> rhs) {
  if (!lhs || !rhs)
    return std::nullopt;
  return llvm::checkedAdd(*lhs, *rhs);
}

static std::optional<int64_t> checkedMulImm(std::optional<int64_t> lhs,
                                            std::optional<int64_t> rhs) {
  if (!lhs || !rhs)
    return std::nullopt;
  return llvm::checkedMul(*lhs, *rhs);
}

static FailureOr<Value> scaleVOffset(WaveAMDMachineSelector &S, Location loc,
                                     Value value, unsigned size) {
  if (!value)
    return Value{};
  std::optional<int64_t> imm = S.getImmediateValue(value);
  if (imm) {
    std::optional<int64_t> scaled =
        llvm::checkedMul(*imm, static_cast<int64_t>(size));
    if (!scaled)
      return failure();
    return createImm(S.builder, loc, *scaled);
  }
  Type vgprType =
      getRegType(S.builder.getContext(), waveamdmachine::RegClass::VGPR);
  if ((size & (size - 1)) == 0)
    return waveamdmachine::VLshlrevB32Op::create(
               S.builder, loc, vgprType, value,
               createImm(S.builder, loc, llvm::Log2_32(size)))
        .getResult();
  return waveamdmachine::VMulLoU32Op::create(S.builder, loc, vgprType, value,
                                             createImm(S.builder, loc, size))
      .getResult();
}

static FailureOr<Value> scaleSOffset(WaveAMDMachineSelector &S, Location loc,
                                     Value value, unsigned size) {
  if (!value)
    return Value{};
  std::optional<int64_t> imm = S.getImmediateValue(value);
  if (imm) {
    std::optional<int64_t> scaled =
        llvm::checkedMul(*imm, static_cast<int64_t>(size));
    if (!scaled)
      return failure();
    return createImm(S.builder, loc, *scaled);
  }
  Type sgprType =
      getRegType(S.builder.getContext(), waveamdmachine::RegClass::SGPR);
  if ((size & (size - 1)) == 0)
    return waveamdmachine::SLshlB32Op::create(
               S.builder, loc, sgprType, getSCCType(S.builder.getContext()),
               value, createImm(S.builder, loc, llvm::Log2_32(size)))
        .getResult();
  return waveamdmachine::SMulI32Op::create(
             S.builder, loc, sgprType, createImm(S.builder, loc, size), value)
      .getResult();
}

// Multiply each slot of `t` by `size`. Used by selectPtrAdd to
// convert element offsets into byte offsets without losing the
// V / S / inst split. Power-of-two `size` lowers to shifts; the
// imm fast paths in the V / S adders fold size==1 / instOffset==0
// upstream.
FailureOr<OffsetTriple> WaveAMDMachineSelector::scaleTriple(Location loc,
                                                            OffsetTriple t,
                                                            unsigned size) {
  if (size == 1)
    return t;
  OffsetTriple out;
  std::optional<int64_t> instOffset =
      llvm::checkedMul(t.instOffset, static_cast<int64_t>(size));
  if (!instOffset)
    return failure();
  out.instOffset = *instOffset;
  FailureOr<Value> voffset = scaleVOffset(*this, loc, t.voffset, size);
  FailureOr<Value> soffset = scaleSOffset(*this, loc, t.soffset, size);
  if (failed(voffset) || failed(soffset))
    return failure();
  out.voffset = *voffset;
  out.soffset = *soffset;
  // Scale the symbolic forms too so the emit-time width check sees
  // the final byte-offset range, not the pre-scale element range.
  scaleTripleExprs(*this, out, t, size);
  out.assumptions = t.assumptions;
  out.bindings = t.bindings;
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

bool WaveAMDMachineSelector::needsFullAddressForSpec(
    const OffsetTriple &t, const waveamdmachine::AddressFieldSpec &spec) {
  const ::ixs_node *vExpr = t.voffsetExpr;
  const ::ixs_node *sExpr = t.soffsetExpr;
  if (instOffsetOverflows(t, spec)) {
    FailureOr<sym::ExprHandle> immExpr =
        sym::composeExprInt(symbolStore(), t.instOffset);
    if (succeeded(immExpr)) {
      if (spec.hasSoffset)
        sExpr = appendBucketExpr(sExpr, immExpr->raw());
      else
        vExpr = appendBucketExpr(vExpr, immExpr->raw());
    }
  }
  if (!spec.hasSoffset || !slotFitsU32(sExpr, t.assumptions))
    vExpr = appendBucketExpr(vExpr, sExpr);
  return !slotFitsU32(vExpr, t.assumptions);
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

// Push out-of-range / unsupported inst_offset and unsupported or
// overwide soffset into the slots `spec` has. Callers route overwide
// final voffset through addr64 before reaching this helper.
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

static std::optional<int64_t> staticIntLiteral(::ixs_node *node) {
  switch (ixs_node_tag(node)) {
  case IXS_INT:
    return ixs_node_int_val(node);
  case IXS_RAT:
    if (ixs_node_rat_den(node) == 1)
      return ixs_node_rat_num(node);
    return std::nullopt;
  default:
    return std::nullopt;
  }
}

static bool isReg(Value v, waveamdmachine::RegClass cls, unsigned width) {
  auto rt = dyn_cast<waveamdmachine::RegType>(v.getType());
  return rt && rt.getRegClass() == cls && rt.getWidth() == width;
}

static bool isVGPR2(Value v) {
  return isReg(v, waveamdmachine::RegClass::VGPR, 2);
}

static bool isSGPR2(Value v) {
  return isReg(v, waveamdmachine::RegClass::SGPR, 2);
}

static bool isWideVGPR(Value v) {
  auto rt = dyn_cast<waveamdmachine::RegType>(v.getType());
  return rt && rt.getRegClass() == waveamdmachine::RegClass::VGPR &&
         rt.getWidth() == 2;
}

static Value tuple2(WaveAMDMachineSelector &S, Location loc,
                    waveamdmachine::RegClass cls, Value lo, Value hi) {
  Type resultType = getRegType(S.builder.getContext(), cls, 2);
  return waveamdmachine::TupleFromElementsOp::create(S.builder, loc, resultType,
                                                     ValueRange{lo, hi})
      .getTuple();
}

static Value ensureSGPR2(WaveAMDMachineSelector &S, Location loc, Value v) {
  if (isSGPR2(v))
    return v;
  if (std::optional<int64_t> imm = S.getImmediateValue(v))
    return waveamdmachine::SMovB64ImmOp::create(
               S.builder, loc,
               getRegType(S.builder.getContext(),
                          waveamdmachine::RegClass::SGPR, 2),
               S.builder.getI64IntegerAttr(*imm))
        .getResult();
  Value lo = S.materializeSGPR1(loc, v);
  Value hi = S.materializeSGPR1(loc, createImm(S.builder, loc, 0));
  return tuple2(S, loc, waveamdmachine::RegClass::SGPR, lo, hi);
}

static Value ensureVGPR2(WaveAMDMachineSelector &S, Location loc, Value v) {
  if (isVGPR2(v))
    return v;
  if (isSGPR2(v)) {
    Type sgpr1 =
        getRegType(S.builder.getContext(), waveamdmachine::RegClass::SGPR, 1);
    auto split = waveamdmachine::TupleToElementsOp::create(
        S.builder, loc, TypeRange{sgpr1, sgpr1}, v);
    Value lo = S.ensureVGPRForVSrc1(loc, split.getElements()[0]);
    Value hi = S.ensureVGPRForVSrc1(loc, split.getElements()[1]);
    return tuple2(S, loc, waveamdmachine::RegClass::VGPR, lo, hi);
  }
  Value lo = S.ensureVGPRForVSrc1(loc, v);
  Value hi = S.ensureVGPRForVSrc1(loc, createImm(S.builder, loc, 0));
  return tuple2(S, loc, waveamdmachine::RegClass::VGPR, lo, hi);
}

static Value addWide(WaveAMDMachineSelector &S, Location loc, Value lhs,
                     Value rhs) {
  if (isWideVGPR(lhs) || isWideVGPR(rhs)) {
    Type resultType =
        getRegType(S.builder.getContext(), waveamdmachine::RegClass::VGPR, 2);
    return waveamdmachine::VAddU64Op::create(
               S.builder, loc, resultType, getVCCType(S.builder.getContext()),
               ensureVGPR2(S, loc, lhs), ensureVGPR2(S, loc, rhs))
        .getResult();
  }
  Type resultType =
      getRegType(S.builder.getContext(), waveamdmachine::RegClass::SGPR, 2);
  return waveamdmachine::SAddU64Op::create(
             S.builder, loc, resultType, getSCCType(S.builder.getContext()),
             ensureSGPR2(S, loc, lhs), ensureSGPR2(S, loc, rhs))
      .getResult();
}

static Value mulWide(WaveAMDMachineSelector &S, Location loc, Value lhs,
                     Value rhs) {
  if (isWideVGPR(lhs) || isWideVGPR(rhs)) {
    Type pairType =
        getRegType(S.builder.getContext(), waveamdmachine::RegClass::VGPR, 2);
    Type scratchType =
        getRegType(S.builder.getContext(), waveamdmachine::RegClass::VGPR, 1);
    return waveamdmachine::VMulU64Op::create(
               S.builder, loc, pairType, scratchType, ensureVGPR2(S, loc, lhs),
               ensureVGPR2(S, loc, rhs))
        .getResult();
  }
  Type pairType =
      getRegType(S.builder.getContext(), waveamdmachine::RegClass::SGPR, 2);
  Type scratchType =
      getRegType(S.builder.getContext(), waveamdmachine::RegClass::SGPR, 1);
  return waveamdmachine::SMulU64Op::create(
             S.builder, loc, pairType, scratchType,
             getSCCType(S.builder.getContext()), ensureSGPR2(S, loc, lhs),
             ensureSGPR2(S, loc, rhs))
      .getResult();
}

static FailureOr<Value>
materializeWideIndexExprNode(WaveAMDMachineSelector &S, const ::ixs_node *cnode,
                             Operation *user,
                             ArrayRef<std::pair<std::string, Value>> bindings);

static FailureOr<Value>
materializeWideAddTerm(WaveAMDMachineSelector &S, ::ixs_node *node, uint32_t i,
                       Operation *user,
                       ArrayRef<std::pair<std::string, Value>> bindings) {
  FailureOr<Value> term = materializeWideIndexExprNode(
      S, ixs_node_add_term(node, i), user, bindings);
  if (failed(term))
    return failure();
  ::ixs_node *coeff = ixs_node_add_term_coeff(node, i);
  std::optional<int64_t> coeffInt = staticIntLiteral(coeff);
  if (coeffInt && *coeffInt == 1)
    return *term;
  FailureOr<Value> coeffValue =
      materializeWideIndexExprNode(S, coeff, user, bindings);
  if (failed(coeffValue))
    return failure();
  return mulWide(S, user->getLoc(), *coeffValue, *term);
}

static FailureOr<Value>
materializeWideAdd(WaveAMDMachineSelector &S, ::ixs_node *node, Operation *user,
                   ArrayRef<std::pair<std::string, Value>> bindings) {
  Location loc = user->getLoc();
  std::optional<Value> acc;
  ::ixs_node *coeff = ixs_node_add_coeff(node);
  std::optional<int64_t> coeffInt = staticIntLiteral(coeff);
  if (!coeffInt || *coeffInt != 0) {
    FailureOr<Value> seed =
        materializeWideIndexExprNode(S, coeff, user, bindings);
    if (failed(seed))
      return failure();
    acc = *seed;
  }
  uint32_t n = ixs_node_add_nterms(node);
  for (uint32_t i = 0; i < n; ++i) {
    FailureOr<Value> term = materializeWideAddTerm(S, node, i, user, bindings);
    if (failed(term))
      return failure();
    acc = acc ? addWide(S, loc, *acc, *term) : std::optional<Value>{*term};
  }
  if (acc)
    return *acc;
  return waveamdmachine::SMovB64ImmOp::create(
             S.builder, loc,
             getRegType(S.builder.getContext(), waveamdmachine::RegClass::SGPR,
                        2),
             S.builder.getI64IntegerAttr(0))
      .getResult();
}

static FailureOr<Value>
materializeWideMulFactor(WaveAMDMachineSelector &S, ::ixs_node *node,
                         uint32_t i, Operation *user,
                         ArrayRef<std::pair<std::string, Value>> bindings) {
  int32_t exp = ixs_node_mul_factor_exp(node, i);
  if (exp <= 0)
    return user->emitError(
        "full-address index_expr rejects non-positive mul exponent");
  FailureOr<Value> base = materializeWideIndexExprNode(
      S, ixs_node_mul_factor_base(node, i), user, bindings);
  if (failed(base))
    return failure();
  Value pow = *base;
  for (int32_t e = 1; e < exp; ++e)
    pow = mulWide(S, user->getLoc(), pow, *base);
  return pow;
}

static FailureOr<Value>
materializeWideMul(WaveAMDMachineSelector &S, ::ixs_node *node, Operation *user,
                   ArrayRef<std::pair<std::string, Value>> bindings) {
  Location loc = user->getLoc();
  std::optional<Value> acc;
  ::ixs_node *coeff = ixs_node_mul_coeff(node);
  std::optional<int64_t> coeffInt = staticIntLiteral(coeff);
  if (!coeffInt || *coeffInt != 1) {
    FailureOr<Value> seed =
        materializeWideIndexExprNode(S, coeff, user, bindings);
    if (failed(seed))
      return failure();
    acc = *seed;
  }
  uint32_t n = ixs_node_mul_nfactors(node);
  for (uint32_t i = 0; i < n; ++i) {
    FailureOr<Value> factor =
        materializeWideMulFactor(S, node, i, user, bindings);
    if (failed(factor))
      return failure();
    acc = acc ? mulWide(S, loc, *acc, *factor) : std::optional<Value>{*factor};
  }
  if (acc)
    return *acc;
  return waveamdmachine::SMovB64ImmOp::create(
             S.builder, loc,
             getRegType(S.builder.getContext(), waveamdmachine::RegClass::SGPR,
                        2),
             S.builder.getI64IntegerAttr(1))
      .getResult();
}

static FailureOr<Value>
materializeWideSymbol(WaveAMDMachineSelector &S, ::ixs_node *node,
                      Operation *user,
                      ArrayRef<std::pair<std::string, Value>> bindings) {
  StringRef name = ixs_node_sym_name(node);
  for (const auto &binding : bindings)
    if (binding.first == name)
      return isReg(binding.second, waveamdmachine::RegClass::VGPR, 1) ||
                     isVGPR2(binding.second)
                 ? ensureVGPR2(S, user->getLoc(), binding.second)
                 : ensureSGPR2(S, user->getLoc(), binding.second);
  return user->emitError("full-address index_expr leaf '")
         << name << "' has no binding";
}

static FailureOr<Value>
materializeWideIndexExprNode(WaveAMDMachineSelector &S, const ::ixs_node *cnode,
                             Operation *user,
                             ArrayRef<std::pair<std::string, Value>> bindings) {
  auto *node = const_cast<::ixs_node *>(cnode);
  Location loc = user->getLoc();
  switch (ixs_node_tag(node)) {
  case IXS_INT:
    return waveamdmachine::SMovB64ImmOp::create(
               S.builder, loc,
               getRegType(S.builder.getContext(),
                          waveamdmachine::RegClass::SGPR, 2),
               S.builder.getI64IntegerAttr(ixs_node_int_val(node)))
        .getResult();
  case IXS_RAT: {
    if (ixs_node_rat_den(node) != 1)
      return user->emitError(
          "full-address index_expr rejects non-integer rational");
    return waveamdmachine::SMovB64ImmOp::create(
               S.builder, loc,
               getRegType(S.builder.getContext(),
                          waveamdmachine::RegClass::SGPR, 2),
               S.builder.getI64IntegerAttr(ixs_node_rat_num(node)))
        .getResult();
  }
  case IXS_SYM:
    return materializeWideSymbol(S, node, user, bindings);
  case IXS_ADD:
    return materializeWideAdd(S, node, user, bindings);
  case IXS_MUL:
    return materializeWideMul(S, node, user, bindings);
  case IXS_FLOOR:
  case IXS_CEIL:
  case IXS_MOD:
    return user->emitError(
        "full-address index_expr supports only add/mul expressions");
  default:
    return user->emitError("full-address index_expr unsupported node tag ")
           << static_cast<int>(ixs_node_tag(node));
  }
}

static Value sgprPairToVGPRPair(WaveAMDMachineSelector &S, Location loc,
                                Value pair) {
  return ensureVGPR2(S, loc, pair);
}

FailureOr<Value> WaveAMDMachineSelector::materializeGlobalAddress(
    Location loc, Value base, const OffsetTriple &t, Operation *user) {
  Value addr = base;
  if (t.fullExpr) {
    FailureOr<Value> offset =
        materializeWideIndexExprNode(*this, t.fullExpr, user, t.bindings);
    if (failed(offset))
      return failure();
    if (isWideVGPR(*offset))
      return addWide(*this, loc, sgprPairToVGPRPair(*this, loc, addr), *offset);
    addr = addWide(*this, loc, addr, *offset);
    return sgprPairToVGPRPair(*this, loc, addr);
  }
  if (t.instOffset != 0) {
    Value imm =
        waveamdmachine::SMovB64ImmOp::create(
            builder, loc,
            getRegType(builder.getContext(), waveamdmachine::RegClass::SGPR, 2),
            builder.getI64IntegerAttr(t.instOffset))
            .getResult();
    addr = addWide(*this, loc, addr, imm);
  }
  if (t.soffset)
    addr =
        waveamdmachine::SAddU64U32Op::create(
            builder, loc,
            getRegType(builder.getContext(), waveamdmachine::RegClass::SGPR, 2),
            getSCCType(builder.getContext()), addr,
            materializeSGPR1(loc, t.soffset))
            .getResult();
  Value vaddr = sgprPairToVGPRPair(*this, loc, addr);
  if (!t.voffset)
    return vaddr;
  Value lo = ensureVGPRForVSrc1(loc, t.voffset);
  Value hi = ensureVGPRForVSrc1(loc, createImm(builder, loc, 0));
  Value voffset = tuple2(*this, loc, waveamdmachine::RegClass::VGPR, lo, hi);
  return addWide(*this, loc, vaddr, voffset);
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
FailureOr<OffsetTriple> WaveAMDMachineSelector::mergeTriples(Location loc,
                                                             OffsetTriple a,
                                                             OffsetTriple b) {
  OffsetTriple out;
  out.voffset = !a.voffset   ? b.voffset
                : !b.voffset ? a.voffset
                             : addByteOffsets(loc, a.voffset, b.voffset);
  out.soffset = !a.soffset   ? b.soffset
                : !b.soffset ? a.soffset
                             : addUniformBytes(loc, a.soffset, b.soffset);
  std::optional<int64_t> instOffset =
      llvm::checkedAdd(a.instOffset, b.instOffset);
  if (!instOffset)
    return failure();
  out.instOffset = *instOffset;
  out.voffsetExpr = appendBucketExpr(a.voffsetExpr, b.voffsetExpr);
  out.soffsetExpr = appendBucketExpr(a.soffsetExpr, b.soffsetExpr);
  out.fullExpr = appendBucketExpr(a.fullExpr, b.fullExpr);
  out.assumptions = a.assumptions;
  llvm::append_range(out.assumptions, b.assumptions);
  out.bindings = a.bindings;
  llvm::append_range(out.bindings, b.bindings);
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
  return waveamd::getKernargRegisterWidth(type);
}

unsigned WaveAMDMachineSelector::nonPointerArgWidth(Type type) {
  return waveamd::getKernargRegisterWidth(type);
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
  if (!isBufferPointer(type) && !isSharedPointer(type))
    pointerGlobalBases[arg] = argOp;
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
      .Case<arith::ConstantOp>([&](auto o) { return selectConstant(o); })
      .Case<LaneIdOp>([&](auto o) { return selectLaneId(o); })
      .Case<ReadCyclesOp>([&](auto o) { return selectReadCycles(o); })
      .Case<WorkgroupIdOp>([&](auto o) { return selectWorkgroupId(o); })
      .Case<WorkitemIdOp>([&](auto o) { return selectWorkitemId(o); })
      .Case<SplatOp>([&](auto o) { return selectSplat(o); })
      .Case<AssumeRangeOp>([&](auto o) { return selectAssumeRange(o); })
      .Case<BinaryOp>([&](auto o) { return selectBinary(o); })
      .Case<PackOp>([&](auto o) { return selectPack(o); })
      .Case<ExtractOp>([&](auto o) { return selectExtract(o); })
      .Case<CastOp>([&](auto o) { return selectCast(o); })
      .Case<AddiOp>([&](auto o) { return selectAddi(o); })
      .Case<MuliOp>([&](auto o) { return selectMuli(o); })
      .Case<ShliOp>([&](auto o) { return selectShli(o); })
      .Case<FAddOp>([&](auto o) { return selectFAdd(o); })
      .Case<FSubOp>([&](auto o) { return selectFSub(o); })
      .Case<FMulOp>([&](auto o) { return selectFMul(o); })
      .Case<FMaxOp>([&](auto o) { return selectFMax(o); })
      .Case<FmaOp>([&](auto o) { return selectFma(o); })
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

LogicalResult WaveAMDMachineSelector::selectConstant(arith::ConstantOp op) {
  FloatAttr attr = dyn_cast<FloatAttr>(op.getValue());
  if (!attr)
    return op.emitError("unsupported arith.constant attribute");
  unsigned bits = op.getType().getIntOrFloatBitWidth();
  if (bits != 16 && bits != 32)
    return op.emitError("floating constant must be 16 or 32 bits wide");
  values[op.getResult()] = createImm(
      builder, op.getLoc(), attr.getValue().bitcastToAPInt().getZExtValue());
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
    result =
        waveamdmachine::VAddU64Op::create(builder, op.getLoc(), resultType,
                                          getVCCType(op.getContext()), lhs, rhs)
            .getResult();
  else
    result =
        waveamdmachine::SAddU64Op::create(builder, op.getLoc(), resultType,
                                          getSCCType(op.getContext()), lhs, rhs)
            .getResult();
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
                  builder, op.getLoc(), productType, scratchType,
                  getSCCType(op.getContext()), lhs, rhs)
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
    values[op.getResult()] =
        waveamdmachine::SLshlB32Op::create(
            builder, op.getLoc(),
            getRegType(op.getContext(), waveamdmachine::RegClass::SGPR),
            getSCCType(op.getContext()), lhs, rhs)
            .getResult();
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
  if (!isSimdF32(op.getResult().getType()))
    return op.emitError(
        "WaveAMDMachine f32 lowering supports only !wave.simd<f32, W>");
  auto toVGPR = [&](Value operand) {
    return S.ensureVGPRForVSrc1(op.getLoc(), S.expect(operand, op));
  };
  auto selected = MachineOp::create(
      S.builder, op.getLoc(),
      getRegType(S.builder.getContext(), waveamdmachine::RegClass::VGPR),
      toVGPR(operands)...);
  S.values[op.getResult()] = selected.getResult();
  S.eraseIfTopLevel(op);
  return success();
}

template <typename MachineOp, typename WaveOp>
static LogicalResult selectPackedF16Binary(WaveAMDMachineSelector &S, WaveOp op,
                                           StringRef kind, Value lhs,
                                           Value rhs) {
  if (failed(requirePackedF16Target(op.getOperation(), kind)))
    return failure();
  auto toVGPR = [&](Value operand) {
    return S.ensureVGPRForVSrc1(op.getLoc(), S.expect(operand, op));
  };
  auto selected = MachineOp::create(
      S.builder, op.getLoc(),
      getRegType(S.builder.getContext(), waveamdmachine::RegClass::VGPR),
      toVGPR(lhs), toVGPR(rhs), false, 0, 3);
  S.values[op.getResult()] = selected.getResult();
  S.eraseIfTopLevel(op);
  return success();
}

template <typename MachineOp, typename WaveOp>
static LogicalResult selectPackedF16Ternary(WaveAMDMachineSelector &S,
                                            WaveOp op, StringRef kind, Value a,
                                            Value b, Value c) {
  if (failed(requirePackedF16Target(op.getOperation(), kind)))
    return failure();
  auto toVGPR = [&](Value operand) {
    return S.ensureVGPRForVSrc1(op.getLoc(), S.expect(operand, op));
  };
  auto selected = MachineOp::create(
      S.builder, op.getLoc(),
      getRegType(S.builder.getContext(), waveamdmachine::RegClass::VGPR),
      toVGPR(a), toVGPR(b), toVGPR(c), false, 0, 7);
  S.values[op.getResult()] = selected.getResult();
  S.eraseIfTopLevel(op);
  return success();
}

template <typename F32MachineOp, typename PackedMachineOp, typename WaveOp>
static LogicalResult selectFloatBinary(WaveAMDMachineSelector &S, WaveOp op,
                                       StringRef kind) {
  Type resultType = op.getResult().getType();
  if (isSimdF32(resultType))
    return selectF32<F32MachineOp>(S, op, op.getLhs(), op.getRhs());
  if (isSimdPackedF16(resultType))
    return selectPackedF16Binary<PackedMachineOp>(S, op, kind, op.getLhs(),
                                                  op.getRhs());
  return op.emitError("WaveAMDMachine ")
         << kind << " lowering supports only !wave.simd<f32, W> or "
         << "!wave.simd<vector<2xf16>, W>";
}

LogicalResult WaveAMDMachineSelector::selectFAdd(FAddOp op) {
  return selectFloatBinary<waveamdmachine::VAddF32Op,
                           waveamdmachine::VPkAddF16Op>(*this, op, "fadd");
}

LogicalResult WaveAMDMachineSelector::selectFSub(FSubOp op) {
  return selectF32<waveamdmachine::VSubF32Op>(*this, op, op.getLhs(),
                                              op.getRhs());
}

LogicalResult WaveAMDMachineSelector::selectFMul(FMulOp op) {
  return selectFloatBinary<waveamdmachine::VMulF32Op,
                           waveamdmachine::VPkMulF16Op>(*this, op, "fmul");
}

LogicalResult WaveAMDMachineSelector::selectFMax(FMaxOp op) {
  if (isSimdPackedF16(op.getResult().getType()))
    return op.emitError("packed f16 fmax lowering is not implemented");
  return selectF32<waveamdmachine::VMaxF32Op>(*this, op, op.getLhs(),
                                              op.getRhs());
}

LogicalResult WaveAMDMachineSelector::selectFma(FmaOp op) {
  if (!isSimdPackedF16(op.getResult().getType()))
    return op.emitError("WaveAMDMachine fma lowering supports only "
                        "!wave.simd<vector<2xf16>, W>");
  return selectPackedF16Ternary<waveamdmachine::VPkFmaF16Op>(
      *this, op, "fma", op.getLhs(), op.getRhs(), op.getAcc());
}

LogicalResult WaveAMDMachineSelector::selectFExp2(FExp2Op op) {
  return selectF32<waveamdmachine::VExpF32Op>(*this, op, op.getSource());
}

LogicalResult WaveAMDMachineSelector::selectFRcp(FRcpOp op) {
  return selectF32<waveamdmachine::VRcpF32Op>(*this, op, op.getSource());
}

LogicalResult WaveAMDMachineSelector::selectPack(PackOp op) {
  Type resultType = op.getResult().getType();
  Type vgprType = getRegType(op.getContext(), waveamdmachine::RegClass::VGPR);
  if (isSimdPackedF32(resultType)) {
    SmallVector<Value, 2> elements;
    for (Value input : op.getInputs())
      elements.push_back(ensureVGPRForVSrc1(op.getLoc(), expect(input, op)));
    values[op.getResult()] = waveamdmachine::TupleFromElementsOp::create(
        builder, op.getLoc(),
        getRegType(op.getContext(), waveamdmachine::RegClass::VGPR,
                   /*width=*/2),
        elements);
    eraseIfTopLevel(op);
    return success();
  }
  if (isSimdPackedF16(resultType)) {
    Value lo = ensureVGPRForVSrc1(op.getLoc(), expect(op.getInputs()[0], op));
    Value hi = ensureVGPRForVSrc1(op.getLoc(), expect(op.getInputs()[1], op));
    Value mask = createImm(builder, op.getLoc(), 0xffff);
    Value shift = createImm(builder, op.getLoc(), 16);
    Value loMasked = waveamdmachine::VAndB32Op::create(builder, op.getLoc(),
                                                       vgprType, lo, mask);
    Value hiShifted = waveamdmachine::VLshlrevB32Op::create(
        builder, op.getLoc(), vgprType, hi, shift);
    values[op.getResult()] = waveamdmachine::VOrB32Op::create(
        builder, op.getLoc(), vgprType, loMasked, hiShifted);
    eraseIfTopLevel(op);
    return success();
  }
  return op.emitError(
      "WaveAMDMachine pack lowering supports only SIMD vector<2xf32/f16>");
}

LogicalResult WaveAMDMachineSelector::selectExtract(ExtractOp op) {
  Type sourceType = op.getSource().getType();
  Value source = expect(op.getSource(), op);
  Type vgprType = getRegType(op.getContext(), waveamdmachine::RegClass::VGPR);
  if (isSimdPackedF32(sourceType)) {
    SmallVector<Type, 2> elementTypes = {vgprType, vgprType};
    auto split = waveamdmachine::TupleToElementsOp::create(
        builder, op.getLoc(), elementTypes, source);
    values[op.getResult()] = split.getElements()[op.getIndex()];
    eraseIfTopLevel(op);
    return success();
  }
  if (isSimdPackedF16(sourceType)) {
    Value shiftOrMask =
        createImm(builder, op.getLoc(), op.getIndex() == 0 ? 0xffff : 16);
    if (op.getIndex() == 0) {
      values[op.getResult()] = waveamdmachine::VAndB32Op::create(
          builder, op.getLoc(), vgprType, source, shiftOrMask);
    } else {
      values[op.getResult()] = waveamdmachine::VLshrrevB32Op::create(
          builder, op.getLoc(), vgprType, source, shiftOrMask);
    }
    eraseIfTopLevel(op);
    return success();
  }
  return op.emitError(
      "WaveAMDMachine extract lowering supports only SIMD vector<2xf32/f16>");
}

static CastRounding getFpConvertRounding(CastOp op) {
  std::optional<DictionaryAttr> policy = op.getPolicy();
  if (!policy)
    return CastRounding::RNE;
  Attribute attr = policy->get("rounding");
  if (!attr)
    return CastRounding::RNE;
  return cast<CastRoundingPolicyAttr>(attr).getValue();
}

static LogicalResult selectPackedF32ToF16Cast(WaveAMDMachineSelector &S,
                                              CastOp op,
                                              CastRounding rounding) {
  if (rounding != CastRounding::RTZ)
    return op.emitError(
        "packed f32 to f16 lowering supports only rtz rounding");
  if (failed(requirePackedCvtTarget(op)))
    return failure();
  Value source = S.expect(op.getSource(), op);
  auto sourceReg = dyn_cast<waveamdmachine::RegType>(source.getType());
  if (!sourceReg || sourceReg.getRegClass() != waveamdmachine::RegClass::VGPR ||
      sourceReg.getWidth() != 2)
    return op.emitError("packed f32 source must lower to a VGPR pair");
  Type vgprType = getRegType(op.getContext(), waveamdmachine::RegClass::VGPR);
  SmallVector<Type, 2> elementTypes = {vgprType, vgprType};
  auto split = waveamdmachine::TupleToElementsOp::create(S.builder, op.getLoc(),
                                                         elementTypes, source);
  SmallVector<Value, 2> elements(split.getElements().begin(),
                                 split.getElements().end());
  auto cvt = waveamdmachine::VCvtPkRtzF16F32Op::create(
      S.builder, op.getLoc(), vgprType, elements[0], elements[1]);
  S.values[op.getResult()] = cvt.getResult();
  S.eraseIfTopLevel(op);
  return success();
}

static LogicalResult selectScalarFpConvert(WaveAMDMachineSelector &S, CastOp op,
                                           Type sourceElement,
                                           Type resultElement,
                                           CastRounding rounding) {
  if (rounding != CastRounding::RNE)
    return op.emitError(
        "WaveAMDMachine fpconvert lowering supports only rne rounding");

  Value source =
      S.ensureVGPRForVSrc1(op.getLoc(), S.expect(op.getSource(), op));
  Type vgprType = getRegType(op.getContext(), waveamdmachine::RegClass::VGPR);
  if (sourceElement.isF32() && resultElement.isF16()) {
    S.values[op.getResult()] = waveamdmachine::VCvtF16F32Op::create(
        S.builder, op.getLoc(), vgprType, source);
    S.eraseIfTopLevel(op);
    return success();
  }
  if (sourceElement.isF16() && resultElement.isF32()) {
    S.values[op.getResult()] = waveamdmachine::VCvtF32F16Op::create(
        S.builder, op.getLoc(), vgprType, source);
    S.eraseIfTopLevel(op);
    return success();
  }
  return op.emitError(
      "WaveAMDMachine fpconvert lowering supports only f32/f16 SIMD or "
      "vector<2xf32> to vector<2xf16> SIMD");
}

LogicalResult WaveAMDMachineSelector::selectCast(CastOp op) {
  if (op.getKind() != CastKind::FpConvert)
    return op.emitError(
        "WaveAMDMachine backend only supports fpconvert wave.cast");
  SimdType sourceType = dyn_cast<SimdType>(op.getSource().getType());
  SimdType resultType = dyn_cast<SimdType>(op.getResult().getType());
  if (!sourceType || !resultType)
    return op.emitError("WaveAMDMachine backend only supports SIMD wave.cast");
  Type sourceElement = sourceType.getElementType();
  Type resultElement = resultType.getElementType();
  CastRounding rounding = getFpConvertRounding(op);

  if (isSimdPackedF32(op.getSource().getType()) &&
      isSimdPackedF16(op.getResult().getType()))
    return selectPackedF32ToF16Cast(*this, op, rounding);
  return selectScalarFpConvert(*this, op, sourceElement, resultElement,
                               rounding);
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
  return (bitWidth(type) + 7) / 8;
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
  if (std::optional<int64_t> sum = checkedAddImm(lhsImm, rhsImm))
    return createImm(builder, loc, *sum);
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
  if (std::optional<int64_t> product = checkedMulImm(lhsImm, rhsImm))
    return createImm(builder, loc, *product);
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
  if (isImm(lhs) && isImm(rhs))
    rhs = ensureVGPRForVSrc1(loc, rhs);
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
             getRegType(builder.getContext(), waveamdmachine::RegClass::SGPR),
             getSCCType(builder.getContext()), sgpr,
             createImm(builder, loc, llvm::Log2_32(*immFactor)))
      .getResult();
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
  if (isImm(lhs) && isImm(rhs))
    lhs = materializeSGPR1(loc, lhs);
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
               getRegType(builder.getContext(), waveamdmachine::RegClass::SGPR),
               getSCCType(builder.getContext()), v, shiftAmt)
        .getResult();
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
               getRegType(builder.getContext(), waveamdmachine::RegClass::SGPR),
               getSCCType(builder.getContext()), v, m)
        .getResult();
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
  if (std::optional<int64_t> sum = checkedAddImm(lhsImm, rhsImm))
    return createImm(builder, loc, *sum);
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
  if (isImm(acc) && isImm(add))
    acc = materializeSGPR1(loc, acc);
  else if (isImm(acc))
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
  triple.fullExpr = root;
  for (const auto &binding : substitution)
    triple.bindings.push_back({binding.getKey().str(), binding.getValue()});
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
  Value globalBase = pointerGlobalBases.lookup(op.getBase());
  OffsetTriple baseTriple = offsetIt->second;

  OffsetTriple offsetTriple;
  auto tit = indexTriples.find(op.getOffset());
  if (tit != indexTriples.end()) {
    offsetTriple = tit->second;
  } else {
    Value offset = expect(op.getOffset(), op);
    offsetTriple.voffset = offset;
  }
  unsigned size = elementSizeBytes(op.getBase().getType());
  FailureOr<OffsetTriple> scaled = scaleTriple(op.getLoc(), offsetTriple, size);
  if (failed(scaled))
    return op.emitError("pointer offset byte scale overflows i64");
  FailureOr<OffsetTriple> merged =
      mergeTriples(op.getLoc(), baseTriple, *scaled);
  if (failed(merged))
    return op.emitError("pointer offset accumulation overflows i64");

  pointerBases[op.getResult()] = baseValue;
  if (globalBase)
    pointerGlobalBases[op.getResult()] = globalBase;
  pointerOffsets[op.getResult()] = *merged;
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
  Value globalBase = pointerGlobalBases.lookup(op.getBase());
  OffsetTriple baseTriple = offsetIt->second;
  Value descriptor = waveamdmachine::MakeBufferRsrcOp::create(
      builder, op.getLoc(),
      getRegType(op.getContext(), waveamdmachine::RegClass::SGPR, 4), baseValue,
      expect(op.getRange(), op));
  pointerBases[op.getResult()] = descriptor;
  pointerGlobalBases[op.getResult()] = globalBase ? globalBase : baseValue;
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
  pointerOffsets[op.getResult()] = OffsetTriple{};
  pointerOffsets[op.getResult()].instOffset =
      static_cast<int64_t>(op.getOffset());
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
  MmaKind mmaKind = parseMmaKind(kind);
  FailureOr<llvm::AMDGPU::IsaVersion> isa =
      getTargetIsaVersion(op, "matrix lowering");
  if (failed(isa))
    return failure();
  if (failed(requireMmaTarget(op, mmaKind, *isa)))
    return failure();
  auto resultType = cast<waveamd::FragmentType>(op.getResult().getType());
  Type vgprTuple = getRegType(op.getContext(), waveamdmachine::RegClass::VGPR,
                              resultType.getRegisters());
  Value a = expect(op.getA(), op);
  Value b = expect(op.getB(), op);
  Value acc = expect(op.getAcc(), op);
  Value result;
  switch (mmaKind) {
  case MmaKind::WmmaI32_16x16x16_IU8:
    result = waveamdmachine::WmmaI32_16x16x16_IU8Op::create(
        builder, op.getLoc(), vgprTuple, a, b, acc);
    break;
  case MmaKind::WmmaF32_16x16x16_F16:
    result = waveamdmachine::WmmaF32_16x16x16_F16Op::create(
        builder, op.getLoc(), vgprTuple, a, b, acc);
    break;
  case MmaKind::MfmaF32_16x16x16_F16:
    result = waveamdmachine::MfmaF32_16x16x16_F16Op::create(
        builder, op.getLoc(), vgprTuple, a, b, acc);
    break;
  case MmaKind::MfmaF32_16x16x32_F16:
    result = waveamdmachine::MfmaF32_16x16x32_F16Op::create(
        builder, op.getLoc(), vgprTuple, a, b, acc);
    break;
  case MmaKind::Unsupported:
    return op.emitError("unsupported WaveAMDMachine matrix operation kind");
  }
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

static bool isSupportedBoundaryType(Type type);

static bool isSupportedScalarPayloadType(Type type) {
  if (type.isIndex())
    return true;
  if (auto intType = dyn_cast<IntegerType>(type))
    return intType.isSignless() && intType.getWidth() <= 64;
  if (auto floatType = dyn_cast<FloatType>(type))
    return floatType.getWidth() == 16 || floatType.getWidth() == 32;
  return false;
}

static bool isSupportedVectorPayloadType(VectorType type) {
  return type.getRank() == 1 &&
         isSupportedScalarPayloadType(type.getElementType());
}

static bool isSupportedTuplePayloadType(TupleType type) {
  return llvm::all_of(type.getTypes(), isSupportedBoundaryType);
}

static bool isSupportedSimdPayloadType(SimdType type) {
  int64_t width = type.getWidth();
  return (width == 32 || width == 64) &&
         isSupportedBoundaryType(type.getElementType());
}

static bool isSupportedWaveIndexType(WaveIndexType type) {
  int64_t width = type.getWidth();
  return width == 0 || width == 32 || width == 64;
}

static bool isSupportedWaveType(Type type) {
  if (auto ptrType = dyn_cast<PtrType>(type))
    return isSupportedBoundaryType(ptrType.getElementType());
  if (auto simdType = dyn_cast<SimdType>(type))
    return isSupportedSimdPayloadType(simdType);
  if (auto maskType = dyn_cast<MaskType>(type))
    return maskType.getWidth() == 32 || maskType.getWidth() == 64;
  if (auto indexType = dyn_cast<WaveIndexType>(type))
    return isSupportedWaveIndexType(indexType);
  return isa<MemTokenType, waveamd::FragmentType>(type);
}

static bool isSupportedMachineType(Type type) {
  return isa<waveamdmachine::RegType, waveamdmachine::ImmType,
             waveamdmachine::MemTokenType, waveamdmachine::M0Type>(type);
}

static bool isSupportedBoundaryType(Type type) {
  if (isSupportedScalarPayloadType(type))
    return true;
  if (auto vectorType = dyn_cast<VectorType>(type))
    return isSupportedVectorPayloadType(vectorType);
  if (auto tupleType = dyn_cast<TupleType>(type))
    return isSupportedTuplePayloadType(tupleType);
  return isSupportedWaveType(type) || isSupportedMachineType(type);
}

static LogicalResult diagnoseUnsupportedBoundaryType(Operation *op, Type type) {
  if (isSupportedBoundaryType(type))
    return success();
  return op->emitError("unsupported type for WaveAMDMachine lowering: ")
         << type;
}

static LogicalResult diagnoseUnsupportedBoundaryTypes(Operation *op) {
  for (Type type : op->getOperandTypes())
    if (failed(diagnoseUnsupportedBoundaryType(op, type)))
      return failure();
  for (Type type : op->getResultTypes())
    if (failed(diagnoseUnsupportedBoundaryType(op, type)))
      return failure();
  for (Region &region : op->getRegions()) {
    for (Block &block : region) {
      for (BlockArgument arg : block.getArguments())
        if (failed(diagnoseUnsupportedBoundaryType(op, arg.getType())))
          return failure();
    }
  }
  return success();
}

static LogicalResult diagnoseFunctionResultTypes(func::FuncOp func) {
  for (Type type : func.getFunctionType().getResults())
    if (failed(diagnoseUnsupportedBoundaryType(func, type)))
      return failure();
  return success();
}

static LogicalResult diagnoseWaveAMDMachineBoundary(func::FuncOp func) {
  bool foundUnsupported = failed(diagnoseFunctionResultTypes(func));
  func.walk([&](Operation *op) {
    if (op->getDialect() && isa<wavemeta::WaveMetaDialect>(op->getDialect())) {
      op->emitOpError("WaveAMDMachine lowering requires wavemeta-specialize; "
                      "residual wavemeta operation remains");
      foundUnsupported = true;
      return;
    }
    if (failed(diagnoseUnsupportedBoundaryTypes(op)))
      foundUnsupported = true;
  });
  return success(!foundUnsupported);
}

struct ConvertWaveAMDToWaveAMDMachinePass
    : public wave::impl::ConvertWaveAMDToWaveAMDMachineBase<
          ConvertWaveAMDToWaveAMDMachinePass> {
  void runOnOperation() override {
    Operation *root = getOperation();
    SmallVector<func::FuncOp> targets;
    root->walk([&](func::FuncOp f) {
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
    bool foundUnsupported = false;
    for (func::FuncOp func : targets)
      if (failed(diagnoseWaveAMDMachineBoundary(func)))
        foundUnsupported = true;
    if (foundUnsupported)
      return signalPassFailure();
    for (func::FuncOp func : targets) {
      if (failed(wave::wmsel::WaveAMDMachineSelector(func).run()))
        return signalPassFailure();
    }
  }
};

} // namespace
