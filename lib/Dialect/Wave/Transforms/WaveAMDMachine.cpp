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
    return op->emitError("packed f16 ")
           << kind << " lowering requires gfx9/gfx11";
  return success();
}

static LogicalResult requirePackedCvtTarget(CastOp op) {
  FailureOr<llvm::AMDGPU::IsaVersion> isa =
      getTargetIsaVersion(op, "packed f32 to f16 lowering");
  if (failed(isa))
    return failure();
  if (!waveamdmachine::VCvtPkRtzF16F32Op::isSupportedOnIsa(*isa))
    return op.emitError("packed f32 to f16 lowering requires gfx11");
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
        waveamdmachine::WmmaI32_16x16x16_IU8Op::isSupportedOnIsa(isa), "gfx11");
  case MmaKind::WmmaF32_16x16x16_F16:
    return require(
        waveamdmachine::WmmaF32_16x16x16_F16Op::isSupportedOnIsa(isa), "gfx11");
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

static LogicalResult
validateMachineSelectionTarget(WaveAMDMachineSelector &selector) {
  func::FuncOp func = selector.func;
  if (!func.getBody().hasOneBlock())
    return func.emitError("WaveAMDMachine selection supports one-block funcs");
  if (failed(validateTargetWaveWidth(func)))
    return failure();
  if (!waveamdmachine::findAMDGPUTargetModule(func))
    return success();
  FailureOr<llvm::AMDGPU::IsaVersion> isa =
      getTargetIsaVersion(func, "WaveAMDMachine selection");
  if (failed(isa))
    return failure();
  selector.targetIsaMajor = isa->Major;
  return success();
}

LogicalResult WaveAMDMachineSelector::run() {
  if (failed(validateMachineSelectionTarget(*this)))
    return failure();

  // Range facts become ixsimpl assumptions for address planning.
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

struct IntRange64 {
  int64_t lo = 0;
  int64_t hi = 0;
};

static std::optional<ConstantIntRanges>
finiteSignedRange(WaveAMDMachineSelector &S, Value binding) {
  const dataflow::IntegerValueRangeLattice *lattice =
      S.rangeSolver.lookupState<dataflow::IntegerValueRangeLattice>(binding);
  if (!lattice)
    return std::nullopt;
  IntegerValueRange ivr = lattice->getValue();
  if (ivr.isUninitialized())
    return std::nullopt;
  ConstantIntRanges range = ivr.getValue();
  unsigned w = range.smin().getBitWidth();
  if (w == 0 || w > 64)
    return std::nullopt;
  APInt sminBound = APInt::getSignedMinValue(w);
  APInt smaxBound = APInt::getSignedMaxValue(w);
  if (range.smin() == sminBound && range.smax() == smaxBound)
    return std::nullopt;
  return range;
}

static std::optional<IntRange64> scaleRange64(ConstantIntRanges range,
                                              int64_t scale) {
  if (scale == 0)
    return IntRange64{0, 0};
  std::optional<int64_t> lo =
      llvm::checkedMul(range.smin().getSExtValue(), scale);
  std::optional<int64_t> hi =
      llvm::checkedMul(range.smax().getSExtValue(), scale);
  if (!lo || !hi)
    return std::nullopt;
  if (scale < 0)
    std::swap(lo, hi);
  return IntRange64{*lo, *hi};
}

std::optional<sym::PredHandle>
WaveAMDMachineSelector::bindingAssumption(Value binding, StringRef name,
                                          int64_t scale) {
  std::optional<ConstantIntRanges> range = finiteSignedRange(*this, binding);
  if (!range)
    return std::nullopt;
  std::optional<IntRange64> scaled = scaleRange64(*range, scale);
  if (!scaled)
    return std::nullopt;
  auto handle =
      sym::rangeAssumption(symbolStore(), name, scaled->lo, scaled->hi);
  if (failed(handle))
    return std::nullopt;
  return *handle;
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

sym::Store &WaveAMDMachineSelector::symbolStore() {
  return func.getContext()->getLoadedDialect<WaveDialect>()->getSymbolStore();
}

bool WaveAMDMachineSelector::slotFitsU32(
    sym::ExprHandle expr, ArrayRef<sym::PredHandle> assumptions) {
  return sym::provablyFitsU32(symbolStore(), expr, assumptions);
}

static std::optional<int64_t> staticIntLiteral(sym::ExprHandle expr) {
  return sym::getIntegerLiteralValue(expr);
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
materializeWideIndexExprNode(WaveAMDMachineSelector &S, sym::ExprHandle expr,
                             Operation *user,
                             ArrayRef<std::pair<std::string, Value>> bindings);

static FailureOr<Value>
materializeWideAddTerm(WaveAMDMachineSelector &S, sym::AddTerm addTerm,
                       Operation *user,
                       ArrayRef<std::pair<std::string, Value>> bindings) {
  FailureOr<Value> term =
      materializeWideIndexExprNode(S, addTerm.term, user, bindings);
  if (failed(term))
    return failure();
  std::optional<int64_t> coeffInt = staticIntLiteral(addTerm.coefficient);
  if (coeffInt && *coeffInt == 1)
    return *term;
  FailureOr<Value> coeffValue =
      materializeWideIndexExprNode(S, addTerm.coefficient, user, bindings);
  if (failed(coeffValue))
    return failure();
  return mulWide(S, user->getLoc(), *coeffValue, *term);
}

static FailureOr<Value>
materializeWideAdd(WaveAMDMachineSelector &S, sym::ExprHandle expr,
                   Operation *user,
                   ArrayRef<std::pair<std::string, Value>> bindings) {
  Location loc = user->getLoc();
  sym::ExprView view(expr);
  std::optional<Value> acc;
  sym::ExprHandle coeff = view.getAddConstant();
  std::optional<int64_t> coeffInt = staticIntLiteral(coeff);
  if (!coeffInt || *coeffInt != 0) {
    FailureOr<Value> seed =
        materializeWideIndexExprNode(S, coeff, user, bindings);
    if (failed(seed))
      return failure();
    acc = *seed;
  }
  uint32_t n = view.getAddTermCount();
  for (uint32_t i = 0; i < n; ++i) {
    FailureOr<Value> term =
        materializeWideAddTerm(S, view.getAddTerm(i), user, bindings);
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
materializeWideMulFactor(WaveAMDMachineSelector &S, sym::MulFactor factor,
                         Operation *user,
                         ArrayRef<std::pair<std::string, Value>> bindings) {
  int32_t exp = factor.exponent;
  if (exp <= 0)
    return user->emitError(
        "full-address index_expr rejects non-positive mul exponent");
  FailureOr<Value> base =
      materializeWideIndexExprNode(S, factor.base, user, bindings);
  if (failed(base))
    return failure();
  Value pow = *base;
  for (int32_t e = 1; e < exp; ++e)
    pow = mulWide(S, user->getLoc(), pow, *base);
  return pow;
}

static FailureOr<Value>
materializeWideMul(WaveAMDMachineSelector &S, sym::ExprHandle expr,
                   Operation *user,
                   ArrayRef<std::pair<std::string, Value>> bindings) {
  Location loc = user->getLoc();
  sym::ExprView view(expr);
  std::optional<Value> acc;
  sym::ExprHandle coeff = view.getMulCoefficient();
  std::optional<int64_t> coeffInt = staticIntLiteral(coeff);
  if (!coeffInt || *coeffInt != 1) {
    FailureOr<Value> seed =
        materializeWideIndexExprNode(S, coeff, user, bindings);
    if (failed(seed))
      return failure();
    acc = *seed;
  }
  uint32_t n = view.getMulFactorCount();
  for (uint32_t i = 0; i < n; ++i) {
    FailureOr<Value> factor =
        materializeWideMulFactor(S, view.getMulFactor(i), user, bindings);
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
materializeWideSymbol(WaveAMDMachineSelector &S, sym::ExprHandle expr,
                      Operation *user,
                      ArrayRef<std::pair<std::string, Value>> bindings) {
  StringRef name = sym::ExprView(expr).getSymbolName();
  for (const auto &binding : bindings)
    if (binding.first == name)
      return ensureVGPR2(S, user->getLoc(), binding.second);
  return user->emitError("full-address index_expr leaf '")
         << name << "' has no binding";
}

static Value createWideImm(WaveAMDMachineSelector &S, Location loc,
                           int64_t value) {
  Type sgpr2 =
      getRegType(S.builder.getContext(), waveamdmachine::RegClass::SGPR, 2);
  return waveamdmachine::SMovB64ImmOp::create(
             S.builder, loc, sgpr2, S.builder.getI64IntegerAttr(value))
      .getResult();
}

static FailureOr<Value> materializeWideRational(WaveAMDMachineSelector &S,
                                                sym::ExprHandle expr,
                                                Operation *user) {
  std::optional<sym::RationalLiteral> rational =
      sym::ExprView(expr).getRational();
  if (!rational || rational->denominator != 1)
    return user->emitError(
        "full-address index_expr rejects non-integer rational");
  return createWideImm(S, user->getLoc(), rational->numerator);
}

static FailureOr<Value>
materializeWideIndexExprNode(WaveAMDMachineSelector &S, sym::ExprHandle expr,
                             Operation *user,
                             ArrayRef<std::pair<std::string, Value>> bindings) {
  sym::ExprView view(expr);
  switch (view.getKind()) {
  case sym::ExprKind::Integer:
    if (std::optional<int64_t> value = view.getInt())
      return createWideImm(S, user->getLoc(), *value);
    break;
  case sym::ExprKind::Rational:
    return materializeWideRational(S, expr, user);
  case sym::ExprKind::Symbol:
    return materializeWideSymbol(S, expr, user, bindings);
  case sym::ExprKind::Add:
    return materializeWideAdd(S, expr, user, bindings);
  case sym::ExprKind::Mul:
    return materializeWideMul(S, expr, user, bindings);
  case sym::ExprKind::Floor:
  case sym::ExprKind::Ceil:
  case sym::ExprKind::Mod:
    return user->emitError(
        "full-address index_expr supports only add/mul expressions");
  default:
    break;
  }
  return user->emitError("full-address index_expr unsupported expression kind ")
         << static_cast<int>(view.getKind());
}

static Value sgprPairToVGPRPair(WaveAMDMachineSelector &S, Location loc,
                                Value pair) {
  return ensureVGPR2(S, loc, pair);
}

FailureOr<Value> materializePointerOffsetValue(WaveAMDMachineSelector &S,
                                               Operation *user,
                                               const PointerOffset &offset) {
  if (!offset.expr)
    return createImm(S.builder, user->getLoc(), 0);
  llvm::StringMap<Value> subs;
  for (const PointerOffsetBinding &binding : offset.bindings)
    subs[binding.name] = S.expect(binding.value, user);
  return materializeIndexExprNode(S, offset.expr, user, subs);
}

FailureOr<Value> materializePointerOffsetVGPR(WaveAMDMachineSelector &S,
                                              Operation *user,
                                              const PointerOffset &offset) {
  FailureOr<Value> value = materializePointerOffsetValue(S, user, offset);
  if (failed(value))
    return failure();
  return S.ensureVGPRForVSrc1(user->getLoc(), *value);
}

TermKind classifyPointerOffset(WaveAMDMachineSelector &S,
                               const PointerOffset &offset) {
  if (!offset.expr)
    return TermKind::Const;
  llvm::StringMap<TermKind> symKinds;
  for (const PointerOffsetBinding &binding : offset.bindings)
    symKinds[binding.name] = binding.kind;
  return classifyTerm(S, offset.expr, symKinds);
}

namespace {

struct AddressPlanBindings {
  llvm::StringMap<Value> narrow;
  SmallVector<std::pair<std::string, Value>, 4> wide;
};

static AddressPlanBindings
materializeAddressPlanBindings(WaveAMDMachineSelector &S, Operation *user,
                               const AddressPlan &plan) {
  AddressPlanBindings out;
  for (const PointerOffsetBinding &binding : plan.bindings) {
    Value mapped = S.expect(binding.value, user);
    out.narrow[binding.name] = mapped;
    out.wide.push_back({binding.name, mapped});
  }
  return out;
}

static FailureOr<sym::ExprHandle>
appendAddressExpr(WaveAMDMachineSelector &S, sym::ExprHandle lhs,
                  sym::ExprHandle rhs, ArrayRef<sym::PredHandle> assumptions) {
  if (!lhs)
    return rhs;
  if (!rhs)
    return lhs;
  FailureOr<sym::ExprHandle> expr =
      sym::composeExprBinary(S.symbolStore(), lhs, sym::ExprBinaryOp::Add, rhs);
  if (failed(expr))
    return failure();
  FailureOr<sym::ExprHandle> simplified =
      sym::simplifyExpr(S.symbolStore(), *expr, assumptions);
  return succeeded(simplified) ? *simplified : *expr;
}

static TermKind classifyPlanExpr(WaveAMDMachineSelector &S,
                                 const AddressPlan &plan,
                                 sym::ExprHandle expr) {
  llvm::StringMap<TermKind> symKinds;
  for (const PointerOffsetBinding &binding : plan.bindings)
    symKinds[binding.name] = binding.kind;
  return classifyTerm(S, expr, symKinds);
}

static FailureOr<bool> tryAppendRemainderToSlot(WaveAMDMachineSelector &S,
                                                AddressPlan &plan,
                                                sym::ExprHandle &slot) {
  FailureOr<sym::ExprHandle> joined = appendAddressExpr(
      S, slot, plan.fullAddressRemainderExpr, plan.assumptions);
  if (failed(joined))
    return failure();
  if (!S.slotFitsU32(*joined, plan.assumptions))
    return false;
  slot = *joined;
  plan.fullAddressRemainderExpr = {};
  return true;
}

static LogicalResult
demotePlanRemainderToFields(WaveAMDMachineSelector &S, AddressPlan &plan,
                            const waveamdmachine::AddressFieldSpec &spec) {
  if (!plan.fullAddressRemainderExpr)
    return success();
  TermKind remainderKind =
      classifyPlanExpr(S, plan, plan.fullAddressRemainderExpr);
  if (spec.hasSoffset && remainderKind != TermKind::Lane) {
    FailureOr<bool> tookSoffset =
        tryAppendRemainderToSlot(S, plan, plan.soffsetExpr);
    if (failed(tookSoffset))
      return failure();
    if (*tookSoffset)
      return success();
  }
  FailureOr<bool> tookVoffset =
      tryAppendRemainderToSlot(S, plan, plan.voffsetExpr);
  return failed(tookVoffset) ? failure() : success();
}

static FailureOr<Value>
materializePlanExpr(WaveAMDMachineSelector &S, Operation *user,
                    sym::ExprHandle expr, const AddressPlanBindings &bindings) {
  return materializeIndexExprNode(S, expr, user, bindings.narrow);
}

static FailureOr<sym::ExprHandle>
planCompleteAddressExpr(WaveAMDMachineSelector &S, const AddressPlan &plan) {
  sym::ExprHandle expr = plan.fullAddressRemainderExpr;
  if (plan.instOffset != 0) {
    FailureOr<sym::ExprHandle> inst =
        sym::composeExprInt(S.symbolStore(), plan.instOffset);
    if (failed(inst))
      return failure();
    FailureOr<sym::ExprHandle> withInst =
        appendAddressExpr(S, expr, *inst, plan.assumptions);
    if (failed(withInst))
      return failure();
    expr = *withInst;
  }
  FailureOr<sym::ExprHandle> withVoffset =
      appendAddressExpr(S, expr, plan.voffsetExpr, plan.assumptions);
  if (failed(withVoffset))
    return failure();
  return appendAddressExpr(S, *withVoffset, plan.soffsetExpr, plan.assumptions);
}

} // namespace

FailureOr<AddressPlan>
planMemoryAddress(WaveAMDMachineSelector &S, Operation *user,
                  const PointerOffset &offset,
                  const waveamdmachine::AddressFieldSpec &spec) {
  FailureOr<AddressPlan> plan = planAddressFields(S, offset, spec);
  if (failed(plan))
    return user->emitError("failed to plan memory address fields");
  if (failed(demotePlanRemainderToFields(S, *plan, spec)))
    return user->emitError("failed to demote memory address remainder");
  return *plan;
}

FailureOr<WaveAMDMachineSelector::BucketedOperands>
materializePlanBuckets(WaveAMDMachineSelector &S, Operation *user,
                       const AddressPlan &plan,
                       const waveamdmachine::AddressFieldSpec &spec) {
  AddressPlanBindings bindings = materializeAddressPlanBindings(S, user, plan);
  WaveAMDMachineSelector::BucketedOperands out;
  Value vraw;
  if (plan.voffsetExpr) {
    FailureOr<Value> voffset =
        materializePlanExpr(S, user, plan.voffsetExpr, bindings);
    if (failed(voffset))
      return failure();
    vraw = *voffset;
  } else {
    vraw = createImm(S.builder, user->getLoc(), 0);
  }
  out.voffset = S.ensureVGPRForVSrc1(user->getLoc(), vraw);
  if (spec.hasSoffset) {
    if (plan.soffsetExpr) {
      FailureOr<Value> soffset =
          materializePlanExpr(S, user, plan.soffsetExpr, bindings);
      if (failed(soffset))
        return failure();
      out.soffset = S.ensureSGPR1(user->getLoc(), *soffset);
    } else {
      out.soffset = createImm(S.builder, user->getLoc(), 0);
    }
  }
  out.instOffset = plan.instOffset;
  return out;
}

static FailureOr<Value>
materializeUniformPointerOffsetCarry(WaveAMDMachineSelector &S, Operation *user,
                                     const PointerOffset &offset) {
  if (classifyPointerOffset(S, offset) == TermKind::Lane)
    return user->emitError("uniform pointer carry became lane-varying");
  FailureOr<Value> value = materializePointerOffsetValue(S, user, offset);
  if (failed(value))
    return failure();
  return S.materializeSGPR1(user->getLoc(), *value);
}

static FailureOr<AddressPlan>
planLanePointerOffsetCarry(WaveAMDMachineSelector &S, Operation *user,
                           const PointerOffset &offset) {
  waveamdmachine::AddressFieldSpec spec{/*instOffsetBits=*/32,
                                        /*instOffsetSigned=*/true,
                                        /*hasSoffset=*/true};
  FailureOr<AddressPlan> plan = planAddressFields(S, offset, spec);
  if (failed(plan))
    return user->emitError("failed to plan pointer carry offset");
  return *plan;
}

static FailureOr<Value>
materializeLanePointerOffsetCarry(WaveAMDMachineSelector &S, Operation *user,
                                  const PointerOffset &offset) {
  FailureOr<AddressPlan> plan = planLanePointerOffsetCarry(S, user, offset);
  if (failed(plan))
    return failure();
  AddressPlanBindings bindings = materializeAddressPlanBindings(S, user, *plan);
  Location loc = user->getLoc();
  Value carry;
  if (plan->voffsetExpr) {
    FailureOr<Value> voffset =
        materializePlanExpr(S, user, plan->voffsetExpr, bindings);
    if (failed(voffset))
      return failure();
    carry = *voffset;
  } else {
    carry = createImm(S.builder, loc, 0);
  }
  carry = S.ensureVGPRForVSrc1(loc, carry);
  auto append = [&](Value value) {
    if (value)
      carry = S.addByteOffsets(loc, carry, value);
  };
  if (plan->soffsetExpr) {
    FailureOr<Value> soffset =
        materializePlanExpr(S, user, plan->soffsetExpr, bindings);
    if (failed(soffset))
      return failure();
    append(S.ensureSGPR1(loc, *soffset));
  }
  if (plan->instOffset != 0)
    append(createImm(S.builder, loc, plan->instOffset));
  if (plan->fullAddressRemainderExpr) {
    FailureOr<Value> remainder =
        materializePlanExpr(S, user, plan->fullAddressRemainderExpr, bindings);
    if (failed(remainder))
      return failure();
    append(*remainder);
  }
  return carry;
}

FailureOr<Value> materializePointerOffsetCarry(WaveAMDMachineSelector &S,
                                               Operation *user,
                                               const PointerOffset &offset,
                                               TermKind carryKind) {
  if (carryKind != TermKind::Lane)
    return materializeUniformPointerOffsetCarry(S, user, offset);
  return materializeLanePointerOffsetCarry(S, user, offset);
}

FailureOr<Value> materializeFullPlanAddress(WaveAMDMachineSelector &S,
                                            Operation *user, Value base,
                                            const AddressPlan &plan) {
  AddressPlanBindings bindings = materializeAddressPlanBindings(S, user, plan);
  FailureOr<sym::ExprHandle> expr = planCompleteAddressExpr(S, plan);
  if (failed(expr))
    return failure();
  Value addr = base;
  if (*expr) {
    FailureOr<Value> offset =
        materializeWideIndexExprNode(S, *expr, user, bindings.wide);
    if (failed(offset))
      return failure();
    if (isWideVGPR(*offset))
      addr = addWide(S, user->getLoc(),
                     sgprPairToVGPRPair(S, user->getLoc(), addr), *offset);
    else
      addr = addWide(S, user->getLoc(), addr, *offset);
  }
  return isWideVGPR(addr) ? addr : sgprPairToVGPRPair(S, user->getLoc(), addr);
}

// Empty attr list keeps the printer from spelling `offset 0`.
SmallVector<NamedAttribute>
WaveAMDMachineSelector::instOffsetAttrs(int64_t value, StringRef attrName) {
  SmallVector<NamedAttribute> attrs;
  if (value != 0)
    attrs.push_back(
        builder.getNamedAttr(attrName, builder.getI64IntegerAttr(value)));
  return attrs;
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
  pointerIndexOffsets[arg] = PointerOffset{};
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
    result = waveamdmachine::SLshlB64Op::create(
                 builder, op.getLoc(), resultType, getSCCType(op.getContext()),
                 lhs, rhs)
                 .getResult();
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

enum class U32CmpKind { Eq, Ne, Lt, Le, Gt, Ge };

static std::optional<U32CmpKind> getU32CmpKind(arith::CmpIPredicate predicate) {
  switch (predicate) {
  case arith::CmpIPredicate::eq:
    return U32CmpKind::Eq;
  case arith::CmpIPredicate::ne:
    return U32CmpKind::Ne;
  case arith::CmpIPredicate::ult:
    return U32CmpKind::Lt;
  case arith::CmpIPredicate::ule:
    return U32CmpKind::Le;
  case arith::CmpIPredicate::ugt:
    return U32CmpKind::Gt;
  case arith::CmpIPredicate::uge:
    return U32CmpKind::Ge;
  default:
    return std::nullopt;
  }
}

static Value createVCmpU32(OpBuilder &builder, Location loc, U32CmpKind kind,
                           Type resultType, Value lhs, Value rhs) {
  switch (kind) {
  case U32CmpKind::Eq:
    return waveamdmachine::VCmpEqU32Op::create(builder, loc, resultType, lhs,
                                               rhs);
  case U32CmpKind::Ne:
    return waveamdmachine::VCmpNeU32Op::create(builder, loc, resultType, lhs,
                                               rhs);
  case U32CmpKind::Lt:
    return waveamdmachine::VCmpLtU32Op::create(builder, loc, resultType, lhs,
                                               rhs);
  case U32CmpKind::Le:
    return waveamdmachine::VCmpLeU32Op::create(builder, loc, resultType, lhs,
                                               rhs);
  case U32CmpKind::Gt:
    return waveamdmachine::VCmpGtU32Op::create(builder, loc, resultType, lhs,
                                               rhs);
  case U32CmpKind::Ge:
    return waveamdmachine::VCmpGeU32Op::create(builder, loc, resultType, lhs,
                                               rhs);
  }
  llvm_unreachable("handled U32 compare kind");
}

static Value createVCmpU32Vcc(OpBuilder &builder, Location loc, U32CmpKind kind,
                              Type resultType, Type vccType, Value lhs,
                              Value rhs) {
  switch (kind) {
  case U32CmpKind::Eq:
    return waveamdmachine::VCmpEqU32VccOp::create(builder, loc, resultType,
                                                  vccType, lhs, rhs)
        .getResult();
  case U32CmpKind::Ne:
    return waveamdmachine::VCmpNeU32VccOp::create(builder, loc, resultType,
                                                  vccType, lhs, rhs)
        .getResult();
  case U32CmpKind::Lt:
    return waveamdmachine::VCmpLtU32VccOp::create(builder, loc, resultType,
                                                  vccType, lhs, rhs)
        .getResult();
  case U32CmpKind::Le:
    return waveamdmachine::VCmpLeU32VccOp::create(builder, loc, resultType,
                                                  vccType, lhs, rhs)
        .getResult();
  case U32CmpKind::Gt:
    return waveamdmachine::VCmpGtU32VccOp::create(builder, loc, resultType,
                                                  vccType, lhs, rhs)
        .getResult();
  case U32CmpKind::Ge:
    return waveamdmachine::VCmpGeU32VccOp::create(builder, loc, resultType,
                                                  vccType, lhs, rhs)
        .getResult();
  }
  llvm_unreachable("handled U32 compare kind");
}

static bool usesLegacyVCmpVcc(const WaveAMDMachineSelector &selector) {
  return selector.targetIsaMajor && *selector.targetIsaMajor < 10;
}

LogicalResult WaveAMDMachineSelector::selectCmp(CmpIOp op) {
  auto maskType = cast<MaskType>(op.getType());
  if (maskType.getWidth() != 32)
    return op.emitError("WaveAMDMachine backend supports only !wave.mask<32>");
  std::optional<U32CmpKind> kind = getU32CmpKind(op.getPredicate());
  if (!kind)
    return op.emitError("unsupported wave.cmpi predicate");
  Type sgprType = getRegType(op.getContext(), waveamdmachine::RegClass::SGPR);
  Value lhs = expect(op.getLhs(), op);
  Value rhs = expect(op.getRhs(), op);
  Value result =
      usesLegacyVCmpVcc(*this)
          ? createVCmpU32Vcc(builder, op.getLoc(), *kind, sgprType,
                             getVCCType(op.getContext()), lhs, rhs)
          : createVCmpU32(builder, op.getLoc(), *kind, sgprType, lhs, rhs);
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

static Value createVAddU32(WaveAMDMachineSelector &selector, Location loc,
                           Value lhs, Value rhs) {
  Type vgprType =
      getRegType(selector.builder.getContext(), waveamdmachine::RegClass::VGPR);
  if (selector.targetIsaMajor && *selector.targetIsaMajor == 8)
    return waveamdmachine::VAddU32VccOp::create(
               selector.builder, loc, vgprType,
               getVCCType(selector.builder.getContext()), lhs, rhs)
        .getResult();
  return waveamdmachine::VAddU32Op::create(selector.builder, loc, vgprType, lhs,
                                           rhs);
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
  return createVAddU32(*this, loc, lhs, rhs);
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

static Value tryMulIndexPow2(WaveAMDMachineSelector &S, Location loc, Value lhs,
                             Value rhs, std::optional<int64_t> lhsImm,
                             std::optional<int64_t> rhsImm) {
  std::optional<int64_t> pow2 = lhsImm ? lhsImm : rhsImm;
  if (!pow2 || *pow2 <= 0 || (*pow2 & (*pow2 - 1)) != 0)
    return Value{};
  Value value = lhsImm ? rhs : lhs;
  if (S.isUniformValue(value))
    return S.mulUniformValues(loc, lhs, rhs);
  return waveamdmachine::VLshlrevB32Op::create(
             S.builder, loc,
             getRegType(S.builder.getContext(), waveamdmachine::RegClass::VGPR),
             S.ensureVGPRForVSrc1(loc, value),
             createImm(S.builder, loc, llvm::Log2_64(*pow2)))
      .getResult();
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
  if (Value shifted = tryMulIndexPow2(*this, loc, lhs, rhs, lhsImm, rhsImm))
    return shifted;
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

// SGPR-domain multiply for uniform address/index expressions.
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

// Uniform-side value: immediate or SGPR1.
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
  PointerOffset pointerOffset;
  for (auto [nameAttr, binding] : llvm::zip(op.getNames(), op.getBindings())) {
    StringRef key = cast<StringAttr>(nameAttr).getValue();
    TermKind kind = isLaneVaryingType(binding.getType()) ? TermKind::Lane
                                                         : TermKind::Uniform;
    pointerOffset.bindings.push_back({key.str(), binding, kind});
    if (std::optional<sym::PredHandle> a = bindingAssumption(binding, key))
      pointerOffset.assumptions.push_back(*a);
  }
  sym::ExprHandle exprHandle = op.getExpr().getValue();
  FailureOr<sym::ExprHandle> simplified =
      sym::simplifyExpr(symbolStore(), exprHandle, pointerOffset.assumptions);
  pointerOffset.expr = succeeded(simplified) ? *simplified : exprHandle;
  bool needsValue =
      llvm::any_of(op.getResult().getUsers(),
                   [](Operation *user) { return !isa<PtrAddOp>(user); });
  indexOffsets[op.getResult()] = pointerOffset;
  if (needsValue) {
    FailureOr<Value> value =
        materializePointerOffsetValue(*this, op, pointerOffset);
    if (failed(value))
      return failure();
    values[op.getResult()] = *value;
  }
  eraseIfTopLevel(op);
  return success();
}

static bool samePointerBinding(const PointerOffsetBinding &lhs,
                               const PointerOffsetBinding &rhs) {
  return lhs.name == rhs.name && lhs.value == rhs.value && lhs.kind == rhs.kind;
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
simplifyPointerOffset(WaveAMDMachineSelector &S, sym::ExprHandle expr,
                      ArrayRef<sym::PredHandle> assumptions) {
  FailureOr<sym::ExprHandle> simplified =
      sym::simplifyExpr(S.symbolStore(), expr, assumptions);
  return succeeded(simplified) ? *simplified : expr;
}

static FailureOr<PointerOffset> scalePointerOffset(WaveAMDMachineSelector &S,
                                                   const PointerOffset &offset,
                                                   unsigned size) {
  PointerOffset out = offset;
  if (!out.expr || size == 1)
    return out;
  FailureOr<sym::ExprHandle> scale = sym::composeExprInt(S.symbolStore(), size);
  if (failed(scale))
    return failure();
  FailureOr<sym::ExprHandle> scaled = sym::composeExprBinary(
      S.symbolStore(), out.expr, sym::ExprBinaryOp::Mul, *scale);
  if (failed(scaled))
    return failure();
  FailureOr<sym::ExprHandle> expanded =
      sym::expandExpr(S.symbolStore(), *scaled);
  if (failed(expanded))
    return failure();
  FailureOr<sym::ExprHandle> simplified =
      simplifyPointerOffset(S, *expanded, out.assumptions);
  if (failed(simplified))
    return failure();
  out.expr = *simplified;
  return out;
}

static FailureOr<PointerOffset> mergePointerOffsets(WaveAMDMachineSelector &S,
                                                    const PointerOffset &base,
                                                    const PointerOffset &add) {
  PointerOffset out = base;
  if (failed(appendPointerBindings(out, add)))
    return failure();
  if (!out.expr) {
    out.expr = add.expr;
    return out;
  }
  if (!add.expr)
    return out;
  FailureOr<sym::ExprHandle> expr = sym::composeExprBinary(
      S.symbolStore(), out.expr, sym::ExprBinaryOp::Add, add.expr);
  if (failed(expr))
    return failure();
  FailureOr<sym::ExprHandle> simplified =
      simplifyPointerOffset(S, *expr, out.assumptions);
  if (failed(simplified))
    return failure();
  out.expr = *simplified;
  return out;
}

static FailureOr<PointerOffset>
planRawPtrAddByteOffset(WaveAMDMachineSelector &S, PtrAddOp op, unsigned size) {
  Value source = op.getOffset();
  Value raw = S.expect(source, op);
  TermKind kind =
      isLaneVaryingType(source.getType()) ? TermKind::Lane : TermKind::Uniform;
  FailureOr<Value> scaled = kind == TermKind::Uniform
                                ? scaleSOffset(S, op.getLoc(), raw, size)
                                : scaleVOffset(S, op.getLoc(), raw, size);
  if (failed(scaled)) {
    op.emitError("pointer offset byte scale overflows i64");
    return failure();
  }
  S.values[*scaled] = *scaled;
  std::string name = (Twine("__wave_raw_ptr_") + Twine(S.nextLabel++)).str();
  FailureOr<sym::ExprHandle> expr = sym::composeExprSym(S.symbolStore(), name);
  if (failed(expr)) {
    op.emitError("failed to compose raw pointer offset");
    return failure();
  }
  PointerOffset offset;
  offset.expr = *expr;
  offset.bindings.push_back({name, *scaled, kind});
  if (std::optional<sym::PredHandle> a =
          S.bindingAssumption(source, name, size))
    offset.assumptions.push_back(*a);
  return offset;
}

static FailureOr<PointerOffset> planPtrAddOffset(WaveAMDMachineSelector &S,
                                                 PtrAddOp op, unsigned size) {
  auto baseIt = S.pointerIndexOffsets.find(op.getBase());
  if (baseIt == S.pointerIndexOffsets.end()) {
    op.emitError("WaveAMDMachine backend expects selected pointer offset");
    return failure();
  }
  PointerOffset offset;
  if (auto offsetIt = S.indexOffsets.find(op.getOffset());
      offsetIt != S.indexOffsets.end()) {
    offset = offsetIt->second;
  } else if (std::optional<int64_t> raw = getConstantIntValue(op.getOffset())) {
    FailureOr<sym::ExprHandle> expr =
        sym::composeExprInt(S.symbolStore(), *raw);
    if (failed(expr)) {
      op.emitError("failed to compose raw pointer offset");
      return failure();
    }
    offset.expr = *expr;
  } else {
    FailureOr<PointerOffset> scaled = planRawPtrAddByteOffset(S, op, size);
    if (failed(scaled))
      return failure();
    FailureOr<PointerOffset> merged =
        mergePointerOffsets(S, baseIt->second, *scaled);
    if (failed(merged))
      op.emitError("failed to merge pointer offset symbols");
    return merged;
  }
  FailureOr<PointerOffset> scaled = scalePointerOffset(S, offset, size);
  if (failed(scaled)) {
    op.emitError("pointer offset byte scale overflows i64");
    return failure();
  }
  FailureOr<PointerOffset> merged =
      mergePointerOffsets(S, baseIt->second, *scaled);
  if (failed(merged))
    op.emitError("failed to merge pointer offset symbols");
  return merged;
}

struct PtrAddBase {
  Value baseValue;
  Value globalBase;
  unsigned size = 0;
};

static FailureOr<PtrAddBase> lookupPtrAddBase(WaveAMDMachineSelector &S,
                                              PtrAddOp op) {
  auto baseIt = S.pointerBases.find(op.getBase());
  auto offsetIt = S.pointerIndexOffsets.find(op.getBase());
  if (baseIt == S.pointerBases.end() || offsetIt == S.pointerIndexOffsets.end())
    return op.emitError("WaveAMDMachine backend expects selected base pointer");
  return PtrAddBase{baseIt->second, S.pointerGlobalBases.lookup(op.getBase()),
                    S.elementSizeBytes(op.getBase().getType())};
}

LogicalResult WaveAMDMachineSelector::selectPtrAdd(PtrAddOp op) {
  FailureOr<PtrAddBase> base = lookupPtrAddBase(*this, op);
  if (failed(base))
    return failure();
  FailureOr<PointerOffset> symbolic = planPtrAddOffset(*this, op, base->size);
  if (failed(symbolic))
    return failure();

  pointerBases[op.getResult()] = base->baseValue;
  if (base->globalBase)
    pointerGlobalBases[op.getResult()] = base->globalBase;
  pointerIndexOffsets[op.getResult()] = std::move(*symbolic);
  pointerBuffers[op.getResult()] = pointerBuffers.lookup(op.getBase());
  values[op.getResult()] = base->baseValue;
  eraseIfTopLevel(op);
  return success();
}

LogicalResult
WaveAMDMachineSelector::selectMakeBuffer(waveamd::MakeBufferOp op) {
  auto baseIt = pointerBases.find(op.getBase());
  auto offsetIt = pointerIndexOffsets.find(op.getBase());
  if (baseIt == pointerBases.end() || offsetIt == pointerIndexOffsets.end())
    return op.emitError("WaveAMDMachine backend expects selected base pointer");
  // DenseMap insert can rehash.
  Value baseValue = baseIt->second;
  Value globalBase = pointerGlobalBases.lookup(op.getBase());
  PointerOffset baseOffset = offsetIt->second;
  Value descriptor = waveamdmachine::MakeBufferRsrcOp::create(
      builder, op.getLoc(),
      getRegType(op.getContext(), waveamdmachine::RegClass::SGPR, 4), baseValue,
      expect(op.getRange(), op));
  pointerBases[op.getResult()] = descriptor;
  pointerGlobalBases[op.getResult()] = globalBase ? globalBase : baseValue;
  pointerIndexOffsets[op.getResult()] = std::move(baseOffset);
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
  PointerOffset offset;
  FailureOr<sym::ExprHandle> expr =
      sym::composeExprInt(symbolStore(), static_cast<int64_t>(op.getOffset()));
  if (succeeded(expr))
    offset.expr = *expr;
  pointerIndexOffsets[op.getResult()] = offset;
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

struct DmaPointers {
  PointerOffset srcOffset;
  PointerOffset dstOffset;
  Value srcBase;
  Value dstBase;
};

static FailureOr<DmaPointers> lookupDmaPointers(WaveAMDMachineSelector &S,
                                                waveamd::DmaLoadLdsOp op) {
  auto srcBaseIt = S.pointerBases.find(op.getSource());
  auto srcOffsetIt = S.pointerIndexOffsets.find(op.getSource());
  auto dstBaseIt = S.pointerBases.find(op.getDest());
  auto dstOffsetIt = S.pointerIndexOffsets.find(op.getDest());
  if (srcBaseIt == S.pointerBases.end() ||
      srcOffsetIt == S.pointerIndexOffsets.end() ||
      dstBaseIt == S.pointerBases.end() ||
      dstOffsetIt == S.pointerIndexOffsets.end())
    return op.emitError("WaveAMDMachine backend expects selected DMA pointers");
  return DmaPointers{srcOffsetIt->second, dstOffsetIt->second,
                     srcBaseIt->second, dstBaseIt->second};
}

static LogicalResult requireUniformDmaDest(WaveAMDMachineSelector &S,
                                           waveamd::DmaLoadLdsOp op,
                                           const PointerOffset &offset) {
  if (!offset.expr)
    return success();
  llvm::StringMap<TermKind> symKinds;
  for (const PointerOffsetBinding &binding : offset.bindings)
    symKinds[binding.name] = binding.kind;
  TermKind kind = classifyTerm(S, offset.expr, symKinds);
  if (kind == TermKind::Lane)
    return op.emitError("DMA LDS destination must be uniform");
  return success();
}

static FailureOr<Value> materializeDmaM0(WaveAMDMachineSelector &S,
                                         waveamd::DmaLoadLdsOp op,
                                         Value dstBase,
                                         const PointerOffset &dstOffset) {
  if (failed(requireUniformDmaDest(S, op, dstOffset)))
    return failure();
  waveamdmachine::AddressFieldSpec spec{/*instOffsetBits=*/32,
                                        /*instOffsetSigned=*/true,
                                        /*hasSoffset=*/true};
  FailureOr<AddressPlan> plan = planAddressFields(S, dstOffset, spec);
  if (failed(plan))
    return op.emitError("failed to plan DMA LDS destination");
  AddressPlanBindings bindings = materializeAddressPlanBindings(S, op, *plan);
  if (plan->voffsetExpr)
    return op.emitError("DMA LDS destination must be uniform");
  Value dstAddr = dstBase;
  Location loc = op.getLoc();
  auto appendExpr = [&](sym::ExprHandle expr) -> LogicalResult {
    if (!expr)
      return success();
    FailureOr<Value> value = materializePlanExpr(S, op, expr, bindings);
    if (failed(value))
      return failure();
    dstAddr = S.addUniformBytes(loc, dstAddr, S.ensureSGPR1(loc, *value));
    return success();
  };
  if (failed(appendExpr(plan->soffsetExpr)) ||
      failed(appendExpr(plan->fullAddressRemainderExpr)))
    return failure();
  if (plan->instOffset != 0)
    dstAddr = S.addUniformBytes(loc, dstAddr,
                                createImm(S.builder, loc, plan->instOffset));
  Value m0Src = S.materializeSGPR1(op.getLoc(), dstAddr);
  return Value{waveamdmachine::SMovM0Op::create(
      S.builder, op.getLoc(), waveamdmachine::M0Type::get(op.getContext()),
      m0Src)};
}

static waveamdmachine::AddressFieldSpec dmaAddressSpec(bool isBuffer,
                                                       int64_t bytes);

static FailureOr<WaveAMDMachineSelector::BucketedOperands>
materializeDmaSourceBuckets(WaveAMDMachineSelector &S, waveamd::DmaLoadLdsOp op,
                            const PointerOffset &offset, bool isBuffer) {
  waveamdmachine::AddressFieldSpec spec =
      dmaAddressSpec(isBuffer, op.getBytes());
  FailureOr<AddressPlan> plan = planMemoryAddress(S, op, offset, spec);
  if (failed(plan))
    return failure();
  if (plan->fullAddressRemainderExpr) {
    if (isBuffer)
      return emitBufferAddressFieldError(op.getOperation());
    FailureOr<sym::ExprHandle> voffset =
        appendAddressExpr(S, plan->voffsetExpr, plan->fullAddressRemainderExpr,
                          plan->assumptions);
    if (failed(voffset))
      return failure();
    plan->voffsetExpr = *voffset;
    plan->fullAddressRemainderExpr = {};
  }
  return materializePlanBuckets(S, op, *plan, spec);
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
  FailureOr<DmaPointers> ptrs = lookupDmaPointers(*this, op);
  if (failed(ptrs))
    return failure();
  FailureOr<Value> m0 =
      materializeDmaM0(*this, op, ptrs->dstBase, ptrs->dstOffset);
  if (failed(m0))
    return failure();

  bool isBuffer = pointerBuffers.lookup(op.getSource());
  FailureOr<BucketedOperands> buckets =
      materializeDmaSourceBuckets(*this, op, ptrs->srcOffset, isBuffer);
  if (failed(buckets))
    return failure();
  BucketedOperands b = *buckets;
  IntegerAttr instOffsetAttr = builder.getI64IntegerAttr(b.instOffset);
  IntegerAttr auxAttr = op.getAux() != 0 ? op.getAuxAttr() : IntegerAttr{};
  Type tokenType = getMemTokenType(op.getContext());
  Value dep = expect(op.getDependency(), op);
  Value token;
  if (isBuffer) {
    if (op.getBytes() == 16)
      token = waveamdmachine::BufferLoadLdsB128Op::create(
          builder, op.getLoc(), tokenType, b.voffset, ptrs->srcBase, b.soffset,
          *m0, dep, instOffsetAttr, auxAttr);
    else
      token = waveamdmachine::BufferLoadLdsB32Op::create(
          builder, op.getLoc(), tokenType, b.voffset, ptrs->srcBase, b.soffset,
          *m0, dep, instOffsetAttr, auxAttr);
  } else {
    if (op.getBytes() == 16)
      token = waveamdmachine::GlobalLoadLdsB128Op::create(
          builder, op.getLoc(), tokenType, b.voffset, ptrs->srcBase, *m0, dep,
          instOffsetAttr, auxAttr);
    else
      token = waveamdmachine::GlobalLoadLdsB32Op::create(
          builder, op.getLoc(), tokenType, b.voffset, ptrs->srcBase, *m0, dep,
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

static LogicalResult validateWhereMaskWidth(WhereOp op, unsigned maskWidth) {
  if (maskWidth != 32 && maskWidth != 64)
    return op.emitError("WaveAMDMachine backend supports only wave32/wave64 "
                        "wave.where masks");
  if (!waveamdmachine::findAMDGPUTargetModule(op))
    return success();
  FailureOr<unsigned> targetWidth =
      waveamdmachine::getAMDGPUDefaultWavefrontSize(
          op, "WaveAMDMachine wave.where lowering");
  if (failed(targetWidth))
    return failure();
  if (maskWidth != *targetWidth)
    return op.emitError("wave.where mask width ")
           << maskWidth << " does not match target wave" << *targetWidth;
  return success();
}

static Value saveExecMask(OpBuilder &builder, Location loc, Value condition,
                          unsigned maskWidth) {
  MLIRContext *context = builder.getContext();
  if (maskWidth == 64) {
    waveamdmachine::SAndSaveexecB64Op saveExec =
        waveamdmachine::SAndSaveexecB64Op::create(
            builder, loc,
            getRegType(context, waveamdmachine::RegClass::SGPR, 2),
            getSCCType(context), condition);
    return saveExec.getSavedExec();
  }
  waveamdmachine::SAndSaveexecB32Op saveExec =
      waveamdmachine::SAndSaveexecB32Op::create(
          builder, loc, getRegType(context, waveamdmachine::RegClass::SGPR),
          getSCCType(context), condition);
  return saveExec.getSavedExec();
}

static void selectElseExecMask(OpBuilder &builder, Location loc,
                               Value savedExec, Value condition,
                               unsigned maskWidth) {
  if (maskWidth == 64) {
    waveamdmachine::SAndn2ExecB64Op::create(
        builder, loc, getSCCType(builder.getContext()), savedExec, condition);
    return;
  }
  waveamdmachine::SAndn2ExecB32Op::create(
      builder, loc, getSCCType(builder.getContext()), savedExec, condition);
}

static void restoreExecMask(OpBuilder &builder, Location loc, Value savedExec,
                            unsigned maskWidth) {
  if (maskWidth == 64) {
    waveamdmachine::SMovExecB64Op::create(builder, loc, savedExec);
    return;
  }
  waveamdmachine::SMovExecLoOp::create(builder, loc, savedExec);
}

LogicalResult WaveAMDMachineSelector::selectWhere(WhereOp op) {
  auto maskType = cast<MaskType>(op.getCondition().getType());
  unsigned maskWidth = maskType.getWidth();
  if (failed(validateWhereMaskWidth(op, maskWidth)))
    return failure();

  std::string endLabel = makeLabel("endif");
  std::string elseLabel =
      op.getElseRegion().empty() ? endLabel : makeLabel("else");
  Value condition = expect(op.getCondition(), op);
  Value savedExec = saveExecMask(builder, op.getLoc(), condition, maskWidth);
  waveamdmachine::SCBranchExeczOp::create(builder, op.getLoc(), elseLabel);
  if (failed(selectRegion(op.getThenRegion())))
    return failure();
  if (!op.getElseRegion().empty()) {
    selectElseExecMask(builder, op.getLoc(), savedExec, condition, maskWidth);
    waveamdmachine::SCBranchExeczOp::create(builder, op.getLoc(), endLabel);
    waveamdmachine::LabelOp::create(builder, op.getLoc(), elseLabel);
    if (failed(selectRegion(op.getElseRegion())))
      return failure();
  }
  waveamdmachine::LabelOp::create(builder, op.getLoc(), endLabel);
  restoreExecMask(builder, op.getLoc(), savedExec, maskWidth);
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

static bool isSupportedFragmentType(waveamd::FragmentType type) {
  int64_t role = type.getRole();
  int64_t waveSize = type.getWaveSize();
  return (role == 0 || role == 1 || role == 2) &&
         type.getElementType().isIntOrFloat() && type.getRows() > 0 &&
         type.getColumns() > 0 && (waveSize == 32 || waveSize == 64) &&
         type.getRegisters() > 0;
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
  if (auto fragmentType = dyn_cast<waveamd::FragmentType>(type))
    return isSupportedFragmentType(fragmentType);
  return isa<MemTokenType>(type);
}

static bool isSupportedMachineRegType(waveamdmachine::RegType type) {
  int64_t width = type.getWidth();
  int64_t index = type.getIndex();
  if (width <= 0 || index < -1)
    return false;
  waveamdmachine::RegClass regClass = type.getRegClass();
  if (regClass != waveamdmachine::RegClass::SCC &&
      regClass != waveamdmachine::RegClass::VCC)
    return true;
  return width == 1 && index == -1;
}

static bool isSupportedMachineType(Type type) {
  if (auto regType = dyn_cast<waveamdmachine::RegType>(type))
    return isSupportedMachineRegType(regType);
  return isa<waveamdmachine::ImmType, waveamdmachine::MemTokenType,
             waveamdmachine::M0Type>(type);
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
