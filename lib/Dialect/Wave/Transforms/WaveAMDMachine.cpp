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
#include "mlir/Dialect/UB/IR/UBOps.h"
#include "mlir/Dialect/Wave/IR/Wave.h"
#include "mlir/Dialect/Wave/IR/WaveAMD.h"
#include "mlir/Dialect/Wave/IR/WaveAMDABI.h"
#include "mlir/Dialect/Wave/IR/WaveMeta.h"
#include "mlir/Dialect/Wave/IR/WaveSymbols.h"
#include "mlir/Dialect/Wave/Transforms/WaveAMDEntryRegs.h"
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

static bool isLaneVaryingType(Type type) { return isa<SimdType>(type); }

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
  WmmaF32_16x16x16_BF16,
  MfmaF32_16x16x16_F16,
  MfmaF32_16x16x16_BF16,
  MfmaF32_16x16x32_F16,
  MfmaF32_16x16x32_BF16,
  MfmaScaleF32_16x16x128_F4F4,
  Unsupported,
};

static MmaKind parseMmaKind(StringRef kind) {
  return llvm::StringSwitch<MmaKind>(kind)
      .Case("wmma.i32.16x16x16.iu8", MmaKind::WmmaI32_16x16x16_IU8)
      .Case("wmma.f32.16x16x16.f16", MmaKind::WmmaF32_16x16x16_F16)
      .Case("wmma.f32.16x16x16.bf16", MmaKind::WmmaF32_16x16x16_BF16)
      .Case("mfma.f32.16x16x16.f16", MmaKind::MfmaF32_16x16x16_F16)
      .Case("mfma.f32.16x16x16.bf16", MmaKind::MfmaF32_16x16x16_BF16)
      .Case("mfma.f32.16x16x32.f16", MmaKind::MfmaF32_16x16x32_F16)
      .Case("mfma.f32.16x16x32.bf16", MmaKind::MfmaF32_16x16x32_BF16)
      .Case("mfma.scale.f32.16x16x128.f4.f4",
            MmaKind::MfmaScaleF32_16x16x128_F4F4)
      .Default(MmaKind::Unsupported);
}

static bool isMmaTargetSupported(MmaKind kind,
                                 const llvm::AMDGPU::IsaVersion &isa) {
  switch (kind) {
  case MmaKind::WmmaI32_16x16x16_IU8:
    return waveamdmachine::WmmaI32_16x16x16_IU8Op::isSupportedOnIsa(isa);
  case MmaKind::WmmaF32_16x16x16_F16:
    return waveamdmachine::WmmaF32_16x16x16_F16Op::isSupportedOnIsa(isa);
  case MmaKind::WmmaF32_16x16x16_BF16:
    return waveamdmachine::WmmaF32_16x16x16_BF16Op::isSupportedOnIsa(isa);
  case MmaKind::MfmaF32_16x16x16_F16:
    return waveamdmachine::MfmaF32_16x16x16_F16Op::isSupportedOnIsa(isa);
  case MmaKind::MfmaF32_16x16x16_BF16:
    return waveamdmachine::MfmaF32_16x16x16_BF16Op::isSupportedOnIsa(isa);
  case MmaKind::MfmaF32_16x16x32_F16:
    return waveamdmachine::MfmaF32_16x16x32_F16Op::isSupportedOnIsa(isa);
  case MmaKind::MfmaF32_16x16x32_BF16:
    return waveamdmachine::MfmaF32_16x16x32_BF16Op::isSupportedOnIsa(isa);
  case MmaKind::MfmaScaleF32_16x16x128_F4F4:
    return waveamdmachine::MfmaScaleF32_16x16x128_F4F4Op::isSupportedOnIsa(isa);
  case MmaKind::Unsupported:
    return true;
  }
  llvm_unreachable("unknown MMA kind");
}

static StringRef mmaTargetRequirement(MmaKind kind) {
  switch (kind) {
  case MmaKind::WmmaI32_16x16x16_IU8:
  case MmaKind::WmmaF32_16x16x16_F16:
  case MmaKind::WmmaF32_16x16x16_BF16:
    return "gfx11";
  case MmaKind::MfmaF32_16x16x16_F16:
    return "gfx90a+";
  case MmaKind::MfmaF32_16x16x16_BF16:
    return "gfx940+";
  case MmaKind::MfmaF32_16x16x32_F16:
  case MmaKind::MfmaF32_16x16x32_BF16:
  case MmaKind::MfmaScaleF32_16x16x128_F4F4:
    return "gfx950";
  case MmaKind::Unsupported:
    return "";
  }
  llvm_unreachable("unknown MMA kind");
}

static LogicalResult requireMmaTarget(Operation *op, StringRef kindName,
                                      MmaKind kind,
                                      const llvm::AMDGPU::IsaVersion &isa) {
  if (isMmaTargetSupported(kind, isa))
    return success();
  return op->emitError() << kindName << " lowering requires "
                         << mmaTargetRequirement(kind);
}

static Value createMachineMma(MmaKind kind, OpBuilder &builder, Location loc,
                              Type resultType, Value a, Value b, Value acc) {
  switch (kind) {
  case MmaKind::WmmaI32_16x16x16_IU8:
    return waveamdmachine::WmmaI32_16x16x16_IU8Op::create(builder, loc,
                                                          resultType, a, b, acc)
        .getResult();
  case MmaKind::WmmaF32_16x16x16_F16:
    return waveamdmachine::WmmaF32_16x16x16_F16Op::create(builder, loc,
                                                          resultType, a, b, acc)
        .getResult();
  case MmaKind::WmmaF32_16x16x16_BF16:
    return waveamdmachine::WmmaF32_16x16x16_BF16Op::create(
               builder, loc, resultType, a, b, acc)
        .getResult();
  case MmaKind::MfmaF32_16x16x16_F16:
    return waveamdmachine::MfmaF32_16x16x16_F16Op::create(builder, loc,
                                                          resultType, a, b, acc)
        .getResult();
  case MmaKind::MfmaF32_16x16x16_BF16:
    return waveamdmachine::MfmaF32_16x16x16_BF16Op::create(
               builder, loc, resultType, a, b, acc)
        .getResult();
  case MmaKind::MfmaF32_16x16x32_F16:
    return waveamdmachine::MfmaF32_16x16x32_F16Op::create(builder, loc,
                                                          resultType, a, b, acc)
        .getResult();
  case MmaKind::MfmaF32_16x16x32_BF16:
    return waveamdmachine::MfmaF32_16x16x32_BF16Op::create(
               builder, loc, resultType, a, b, acc)
        .getResult();
  case MmaKind::MfmaScaleF32_16x16x128_F4F4:
  case MmaKind::Unsupported:
    return {};
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
      waveamdmachine::getAMDGPUWavefrontSize(func, "WaveAMDMachine selection");
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

void WaveAMDMachineSelector::appendBindingAssumptions(
    Value binding, StringRef name,
    SmallVectorImpl<sym::PredHandle> &assumptions, int64_t scale) {
  std::optional<ConstantIntRanges> range = finiteSignedRange(*this, binding);
  if (range) {
    std::optional<IntRange64> scaled = scaleRange64(*range, scale);
    if (scaled) {
      FailureOr<sym::PredHandle> handle =
          sym::rangeAssumption(symbolStore(), name, scaled->lo, scaled->hi);
      if (succeeded(handle))
        assumptions.push_back(*handle);
    }
  }
  if (scale == 1)
    appendAssumePredicates(symbolStore(), binding, name, assumptions);
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

static std::optional<uint64_t> checkedAddU32Bound(uint64_t lhs, uint64_t rhs) {
  constexpr uint64_t u32Max = (uint64_t{1} << 32) - 1;
  if (lhs > u32Max || rhs > u32Max || lhs > u32Max - rhs)
    return std::nullopt;
  return lhs + rhs;
}

static std::optional<uint64_t> checkedMulU32Bound(uint64_t lhs, uint64_t rhs) {
  constexpr uint64_t u32Max = (uint64_t{1} << 32) - 1;
  if (lhs != 0 && rhs > u32Max / lhs)
    return std::nullopt;
  return lhs * rhs;
}

static std::optional<uint64_t>
exprU32UpperBound(WaveAMDMachineSelector &S, sym::ExprHandle expr,
                  ArrayRef<sym::PredHandle> assumptions);

static std::optional<uint64_t>
addExprU32UpperBound(WaveAMDMachineSelector &S, sym::ExprHandle expr,
                     ArrayRef<sym::PredHandle> assumptions) {
  uint64_t bound = 0;
  sym::ExprView view(expr);
  if (std::optional<int64_t> constant =
          sym::getIntegerLiteralValue(view.getAddConstant())) {
    if (*constant < 0)
      return std::nullopt;
    bound = static_cast<uint64_t>(*constant);
  } else {
    return std::nullopt;
  }
  for (uint32_t index = 0, n = view.getAddTermCount(); index < n; ++index) {
    sym::AddTerm addTerm = view.getAddTerm(index);
    std::optional<int64_t> coeff =
        sym::getIntegerLiteralValue(addTerm.coefficient);
    if (!coeff || *coeff < 0)
      return std::nullopt;
    std::optional<uint64_t> term =
        exprU32UpperBound(S, addTerm.term, assumptions);
    if (!term)
      return std::nullopt;
    std::optional<uint64_t> scaled =
        checkedMulU32Bound(static_cast<uint64_t>(*coeff), *term);
    if (!scaled)
      return std::nullopt;
    std::optional<uint64_t> next = checkedAddU32Bound(bound, *scaled);
    if (!next)
      return std::nullopt;
    bound = *next;
  }
  return bound;
}

static std::optional<uint64_t>
mulExprU32UpperBound(WaveAMDMachineSelector &S, sym::ExprHandle expr,
                     ArrayRef<sym::PredHandle> assumptions) {
  sym::ExprView view(expr);
  std::optional<int64_t> coeff =
      sym::getIntegerLiteralValue(view.getMulCoefficient());
  if (!coeff || *coeff < 0)
    return std::nullopt;
  uint64_t bound = static_cast<uint64_t>(*coeff);
  for (uint32_t index = 0, n = view.getMulFactorCount(); index < n; ++index) {
    sym::MulFactor factor = view.getMulFactor(index);
    if (factor.exponent <= 0)
      return std::nullopt;
    std::optional<uint64_t> factorBound =
        exprU32UpperBound(S, factor.base, assumptions);
    if (!factorBound)
      return std::nullopt;
    for (int32_t exp = 0; exp < factor.exponent; ++exp) {
      std::optional<uint64_t> next = checkedMulU32Bound(bound, *factorBound);
      if (!next)
        return std::nullopt;
      bound = *next;
    }
  }
  return bound;
}

static std::optional<uint64_t>
xorExprU32UpperBound(WaveAMDMachineSelector &S, sym::ExprHandle expr,
                     ArrayRef<sym::PredHandle> assumptions) {
  sym::ExprView view(expr);
  std::optional<uint64_t> lhs =
      exprU32UpperBound(S, view.getBinaryLhs(), assumptions);
  std::optional<uint64_t> rhs =
      exprU32UpperBound(S, view.getBinaryRhs(), assumptions);
  if (!lhs || !rhs)
    return std::nullopt;
  uint64_t maxOperand = std::max(*lhs, *rhs);
  if (maxOperand == 0)
    return uint64_t{0};
  return llvm::PowerOf2Ceil(maxOperand + 1) - 1;
}

static std::optional<uint64_t>
exprU32UpperBound(WaveAMDMachineSelector &S, sym::ExprHandle expr,
                  ArrayRef<sym::PredHandle> assumptions) {
  constexpr uint64_t u32Max = (uint64_t{1} << 32) - 1;
  if (std::optional<int64_t> value = sym::getIntegerLiteralValue(expr)) {
    if (*value < 0 || static_cast<uint64_t>(*value) > u32Max)
      return std::nullopt;
    return static_cast<uint64_t>(*value);
  }
  if (std::optional<int64_t> upper = sym::inferNonNegativeUpperBound(
          S.symbolStore(), expr, assumptions, static_cast<int64_t>(u32Max)))
    return static_cast<uint64_t>(*upper);
  sym::ExprView view(expr);
  switch (view.getKind()) {
  case sym::ExprKind::Add:
    return addExprU32UpperBound(S, expr, assumptions);
  case sym::ExprKind::Mul:
    return mulExprU32UpperBound(S, expr, assumptions);
  case sym::ExprKind::Xor:
    return xorExprU32UpperBound(S, expr, assumptions);
  default:
    break;
  }
  return std::nullopt;
}

static bool exprFitsU32ByUpperBound(WaveAMDMachineSelector &S,
                                    sym::ExprHandle expr,
                                    ArrayRef<sym::PredHandle> assumptions) {
  if (std::optional<uint64_t> bound = exprU32UpperBound(S, expr, assumptions))
    return *bound <= (uint64_t{1} << 32) - 1;
  return false;
}

bool WaveAMDMachineSelector::slotFitsU32(
    sym::ExprHandle expr, ArrayRef<sym::PredHandle> assumptions) {
  return exprFitsU32ByUpperBound(*this, expr, assumptions);
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

static bool isOneDwordReg(Value v) {
  auto rt = dyn_cast<waveamdmachine::RegType>(v.getType());
  return rt && rt.getWidth() == 1;
}

static bool isWideVGPR(Value v) {
  auto rt = dyn_cast<waveamdmachine::RegType>(v.getType());
  return rt && rt.getRegClass() == waveamdmachine::RegClass::VGPR &&
         rt.getWidth() == 2;
}

static bool isLocalZero(WaveAMDMachineSelector &S, Value v) {
  if (std::optional<int64_t> imm = S.getImmediateValue(v))
    return *imm == 0;
  if (auto mov = v.getDefiningOp<waveamdmachine::SMovB32ValueOp>())
    return isLocalZero(S, mov.getSource());
  if (auto mov = v.getDefiningOp<waveamdmachine::SMovB32TupleOp>())
    return isLocalZero(S, mov.getSource());
  if (auto mov = v.getDefiningOp<waveamdmachine::VMovB32TupleOp>())
    return isLocalZero(S, mov.getSource());
  return false;
}

static bool fitsUnsigned32(int64_t value) {
  return value >= 0 && static_cast<uint64_t>(value) <= (uint64_t{1} << 32) - 1;
}

static std::optional<Value> zeroExtendedLowDword(WaveAMDMachineSelector &S,
                                                 Value v) {
  if (std::optional<int64_t> imm = S.getImmediateValue(v)) {
    if (fitsUnsigned32(*imm))
      return v;
    return std::nullopt;
  }
  if (isOneDwordReg(v))
    return v;
  auto tuple = v.getDefiningOp<waveamdmachine::TupleFromElementsOp>();
  if (!tuple || tuple.getElements().size() != 2)
    return std::nullopt;
  Value lo = tuple.getElements().front();
  Value hi = tuple.getElements().back();
  if (!isOneDwordReg(lo) || !isLocalZero(S, hi))
    return std::nullopt;
  return lo;
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
  if (isSGPR2(v))
    return waveamdmachine::VMovB32TupleOp::create(
               S.builder, loc,
               getRegType(S.builder.getContext(),
                          waveamdmachine::RegClass::VGPR, 2),
               v)
        .getResult();
  Value lo = S.ensureVGPRForVSrc1(loc, v);
  Value hi = S.ensureVGPRForVSrc1(loc, createImm(S.builder, loc, 0));
  return tuple2(S, loc, waveamdmachine::RegClass::VGPR, lo, hi);
}

static Value extractLowDword(WaveAMDMachineSelector &S, Location loc, Value v,
                             Value source = {}) {
  if (std::optional<int64_t> imm = S.getImmediateValue(v)) {
    uint64_t lo = static_cast<uint64_t>(*imm) & 0xffffffffull;
    return createImm(S.builder, loc, static_cast<int64_t>(lo));
  }
  if (auto mov = v.getDefiningOp<waveamdmachine::SMovB64ImmOp>()) {
    int64_t value = mov.getValue();
    if (source && source.hasOneUse() && v.use_empty())
      S.opsToErase.push_back(mov);
    uint64_t lo = static_cast<uint64_t>(value) & 0xffffffffull;
    return createImm(S.builder, loc, static_cast<int64_t>(lo));
  }
  if (std::optional<Value> low = zeroExtendedLowDword(S, v))
    return *low;
  auto rt = dyn_cast<waveamdmachine::RegType>(v.getType());
  if (!rt || rt.getWidth() == 1)
    return v;
  Type elementType = getRegType(S.builder.getContext(), rt.getRegClass(), 1);
  SmallVector<Type, 2> elementTypes(rt.getWidth(), elementType);
  auto split = waveamdmachine::TupleToElementsOp::create(S.builder, loc,
                                                         elementTypes, v);
  return split.getElements().front();
}

static Value extractHighDword(WaveAMDMachineSelector &S, Location loc,
                              Value v) {
  if (std::optional<int64_t> imm = S.getImmediateValue(v)) {
    uint64_t hi = static_cast<uint64_t>(*imm) >> 32;
    return createImm(S.builder, loc, static_cast<int64_t>(hi));
  }
  if (auto mov = v.getDefiningOp<waveamdmachine::SMovB64ImmOp>()) {
    uint64_t hi = static_cast<uint64_t>(mov.getValue()) >> 32;
    return createImm(S.builder, loc, static_cast<int64_t>(hi));
  }
  if (zeroExtendedLowDword(S, v))
    return createImm(S.builder, loc, 0);
  auto rt = dyn_cast<waveamdmachine::RegType>(v.getType());
  if (!rt || rt.getWidth() == 1)
    return createImm(S.builder, loc, 0);
  Type elementType = getRegType(S.builder.getContext(), rt.getRegClass(), 1);
  SmallVector<Type, 2> elementTypes(rt.getWidth(), elementType);
  auto split = waveamdmachine::TupleToElementsOp::create(S.builder, loc,
                                                         elementTypes, v);
  return split.getElements()[1];
}

static Value addWideU32(WaveAMDMachineSelector &S, Location loc, Value base,
                        Value offset) {
  Type resultType =
      getRegType(S.builder.getContext(), waveamdmachine::RegClass::SGPR, 2);
  return waveamdmachine::SAddU64U32Op::create(
             S.builder, loc, resultType, getSCCType(S.builder.getContext()),
             ensureSGPR2(S, loc, base), offset)
      .getResult();
}

static Value addWide(WaveAMDMachineSelector &S, Location loc, Value lhs,
                     Value rhs) {
  if (isVGPR(lhs) || isVGPR(rhs)) {
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

static Value xorWide(WaveAMDMachineSelector &S, Location loc, Value lhs,
                     Value rhs) {
  if (isWideVGPR(lhs) || isWideVGPR(rhs)) {
    Type resultType =
        getRegType(S.builder.getContext(), waveamdmachine::RegClass::VGPR, 2);
    return waveamdmachine::VXorB64Op::create(S.builder, loc, resultType,
                                             ensureVGPR2(S, loc, lhs),
                                             ensureVGPR2(S, loc, rhs));
  }
  Type resultType =
      getRegType(S.builder.getContext(), waveamdmachine::RegClass::SGPR, 2);
  return waveamdmachine::SXorB64Op::create(
             S.builder, loc, resultType, getSCCType(S.builder.getContext()),
             ensureSGPR2(S, loc, lhs), ensureSGPR2(S, loc, rhs))
      .getResult();
}

static Value createWideImm(WaveAMDMachineSelector &S, Location loc,
                           int64_t value);

static Value lshrWidePow2(WaveAMDMachineSelector &S, Location loc, Value v,
                          unsigned log2Den) {
  if (log2Den == 0)
    return v;
  if (waveamdmachine::SMovB64ImmOp mov =
          v.getDefiningOp<waveamdmachine::SMovB64ImmOp>()) {
    uint64_t shifted = static_cast<uint64_t>(mov.getValue()) >> log2Den;
    return createWideImm(S, loc, static_cast<int64_t>(shifted));
  }
  Value shift = createImm(S.builder, loc, log2Den);
  if (isVGPR(v))
    return waveamdmachine::VLshrrevB64Op::create(
        S.builder, loc,
        getRegType(S.builder.getContext(), waveamdmachine::RegClass::VGPR, 2),
        shift, ensureVGPR2(S, loc, v));
  return waveamdmachine::SLshrB64Op::create(
             S.builder, loc,
             getRegType(S.builder.getContext(), waveamdmachine::RegClass::SGPR,
                        2),
             getSCCType(S.builder.getContext()), ensureSGPR2(S, loc, v), shift)
      .getResult();
}

static FailureOr<Value> materializeWideIndexExprNode(
    WaveAMDMachineSelector &S, sym::ExprHandle expr, Operation *user,
    ArrayRef<std::pair<std::string, Value>> bindings,
    ArrayRef<sym::PredHandle> assumptions, bool symbolsAreUniform = false);

struct WideRationalValue {
  Value numerator;
  int64_t denominator = 1;
};

static FailureOr<WideRationalValue> materializeWideRationalIndexExprNode(
    WaveAMDMachineSelector &S, sym::ExprHandle expr, Operation *user,
    ArrayRef<std::pair<std::string, Value>> bindings,
    ArrayRef<sym::PredHandle> assumptions, bool symbolsAreUniform = false);

static FailureOr<Value> materializeWideAddTerm(
    WaveAMDMachineSelector &S, sym::AddTerm addTerm, Operation *user,
    ArrayRef<std::pair<std::string, Value>> bindings,
    ArrayRef<sym::PredHandle> assumptions, bool symbolsAreUniform) {
  FailureOr<Value> term = materializeWideIndexExprNode(
      S, addTerm.term, user, bindings, assumptions, symbolsAreUniform);
  if (failed(term))
    return failure();
  std::optional<int64_t> coeffInt = staticIntLiteral(addTerm.coefficient);
  if (coeffInt && *coeffInt == 1)
    return *term;
  FailureOr<Value> coeffValue = materializeWideIndexExprNode(
      S, addTerm.coefficient, user, bindings, assumptions, symbolsAreUniform);
  if (failed(coeffValue))
    return failure();
  return mulWide(S, user->getLoc(), *coeffValue, *term);
}

static FailureOr<Value> materializeWideAdd(
    WaveAMDMachineSelector &S, sym::ExprHandle expr, Operation *user,
    ArrayRef<std::pair<std::string, Value>> bindings,
    ArrayRef<sym::PredHandle> assumptions, bool symbolsAreUniform) {
  Location loc = user->getLoc();
  sym::ExprView view(expr);
  std::optional<Value> acc;
  sym::ExprHandle coeff = view.getAddConstant();
  std::optional<int64_t> coeffInt = staticIntLiteral(coeff);
  if (!coeffInt || *coeffInt != 0) {
    FailureOr<Value> seed = materializeWideIndexExprNode(
        S, coeff, user, bindings, assumptions, symbolsAreUniform);
    if (failed(seed))
      return failure();
    acc = *seed;
  }
  uint32_t n = view.getAddTermCount();
  for (uint32_t i = 0; i < n; ++i) {
    FailureOr<Value> term = materializeWideAddTerm(
        S, view.getAddTerm(i), user, bindings, assumptions, symbolsAreUniform);
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

static FailureOr<Value> materializeWideMulFactor(
    WaveAMDMachineSelector &S, sym::MulFactor factor, Operation *user,
    ArrayRef<std::pair<std::string, Value>> bindings,
    ArrayRef<sym::PredHandle> assumptions, bool symbolsAreUniform) {
  int32_t exp = factor.exponent;
  if (exp <= 0)
    return user->emitError(
        "full-address index_expr rejects non-positive mul exponent");
  FailureOr<Value> base = materializeWideIndexExprNode(
      S, factor.base, user, bindings, assumptions, symbolsAreUniform);
  if (failed(base))
    return failure();
  Value pow = *base;
  for (int32_t e = 1; e < exp; ++e)
    pow = mulWide(S, user->getLoc(), pow, *base);
  return pow;
}

static FailureOr<Value> materializeWideMul(
    WaveAMDMachineSelector &S, sym::ExprHandle expr, Operation *user,
    ArrayRef<std::pair<std::string, Value>> bindings,
    ArrayRef<sym::PredHandle> assumptions, bool symbolsAreUniform) {
  Location loc = user->getLoc();
  sym::ExprView view(expr);
  std::optional<Value> acc;
  sym::ExprHandle coeff = view.getMulCoefficient();
  std::optional<int64_t> coeffInt = staticIntLiteral(coeff);
  if (!coeffInt || *coeffInt != 1) {
    FailureOr<Value> seed = materializeWideIndexExprNode(
        S, coeff, user, bindings, assumptions, symbolsAreUniform);
    if (failed(seed))
      return failure();
    acc = *seed;
  }
  uint32_t n = view.getMulFactorCount();
  for (uint32_t i = 0; i < n; ++i) {
    FailureOr<Value> factor =
        materializeWideMulFactor(S, view.getMulFactor(i), user, bindings,
                                 assumptions, symbolsAreUniform);
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

static FailureOr<Value> materializeWideSymbol(
    WaveAMDMachineSelector &S, sym::ExprHandle expr, Operation *user,
    ArrayRef<std::pair<std::string, Value>> bindings, bool symbolsAreUniform) {
  StringRef name = sym::ExprView(expr).getSymbolName();
  for (const auto &binding : bindings) {
    if (binding.first != name)
      continue;
    if (symbolsAreUniform)
      return ensureSGPR2(S, user->getLoc(), binding.second);
    return ensureVGPR2(S, user->getLoc(), binding.second);
  }
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

static FailureOr<Value> materializeWideXor(
    WaveAMDMachineSelector &S, sym::ExprHandle expr, Operation *user,
    ArrayRef<std::pair<std::string, Value>> bindings,
    ArrayRef<sym::PredHandle> assumptions, bool symbolsAreUniform) {
  sym::ExprView view(expr);
  FailureOr<Value> lhs = materializeWideIndexExprNode(
      S, view.getBinaryLhs(), user, bindings, assumptions, symbolsAreUniform);
  FailureOr<Value> rhs = materializeWideIndexExprNode(
      S, view.getBinaryRhs(), user, bindings, assumptions, symbolsAreUniform);
  if (failed(lhs) || failed(rhs))
    return failure();
  return xorWide(S, user->getLoc(), *lhs, *rhs);
}

static std::optional<int64_t> checkedLCM64(int64_t lhs, int64_t rhs) {
  int64_t gcd = std::gcd(lhs, rhs);
  return llvm::checkedMul(lhs / gcd, rhs);
}

static FailureOr<WideRationalValue>
addWideRational(WaveAMDMachineSelector &S, Location loc, WideRationalValue lhs,
                WideRationalValue rhs, Operation *user) {
  std::optional<int64_t> denominator =
      checkedLCM64(lhs.denominator, rhs.denominator);
  if (!denominator)
    return user->emitError("full-address index_expr denominator overflows i64");
  int64_t lhsScale = *denominator / lhs.denominator;
  int64_t rhsScale = *denominator / rhs.denominator;
  Value lhsNumerator = lhsScale == 1 ? lhs.numerator
                                     : mulWide(S, loc, lhs.numerator,
                                               createWideImm(S, loc, lhsScale));
  Value rhsNumerator = rhsScale == 1 ? rhs.numerator
                                     : mulWide(S, loc, rhs.numerator,
                                               createWideImm(S, loc, rhsScale));
  return WideRationalValue{addWide(S, loc, lhsNumerator, rhsNumerator),
                           *denominator};
}

static FailureOr<WideRationalValue>
mulWideRational(WaveAMDMachineSelector &S, Location loc, WideRationalValue lhs,
                WideRationalValue rhs, Operation *user) {
  std::optional<int64_t> denominator =
      llvm::checkedMul(lhs.denominator, rhs.denominator);
  if (!denominator)
    return user->emitError("full-address index_expr denominator overflows i64");
  return WideRationalValue{mulWide(S, loc, lhs.numerator, rhs.numerator),
                           *denominator};
}

static FailureOr<WideRationalValue> materializeWideRationalAdd(
    WaveAMDMachineSelector &S, sym::ExprHandle expr, Operation *user,
    ArrayRef<std::pair<std::string, Value>> bindings,
    ArrayRef<sym::PredHandle> assumptions, bool symbolsAreUniform) {
  Location loc = user->getLoc();
  sym::ExprView view(expr);
  FailureOr<WideRationalValue> constant = materializeWideRationalIndexExprNode(
      S, view.getAddConstant(), user, bindings, assumptions, symbolsAreUniform);
  if (failed(constant))
    return failure();
  WideRationalValue acc = *constant;
  for (uint32_t i : llvm::seq<uint32_t>(0, view.getAddTermCount())) {
    sym::AddTerm term = view.getAddTerm(i);
    FailureOr<WideRationalValue> coefficient =
        materializeWideRationalIndexExprNode(S, term.coefficient, user,
                                             bindings, assumptions,
                                             symbolsAreUniform);
    FailureOr<WideRationalValue> value = materializeWideRationalIndexExprNode(
        S, term.term, user, bindings, assumptions, symbolsAreUniform);
    if (failed(coefficient) || failed(value))
      return failure();
    FailureOr<WideRationalValue> product =
        mulWideRational(S, loc, *coefficient, *value, user);
    if (failed(product))
      return failure();
    FailureOr<WideRationalValue> sum =
        addWideRational(S, loc, acc, *product, user);
    if (failed(sum))
      return failure();
    acc = *sum;
  }
  return acc;
}

static FailureOr<WideRationalValue> materializeWideRationalMul(
    WaveAMDMachineSelector &S, sym::ExprHandle expr, Operation *user,
    ArrayRef<std::pair<std::string, Value>> bindings,
    ArrayRef<sym::PredHandle> assumptions, bool symbolsAreUniform) {
  Location loc = user->getLoc();
  sym::ExprView view(expr);
  FailureOr<WideRationalValue> coefficient =
      materializeWideRationalIndexExprNode(S, view.getMulCoefficient(), user,
                                           bindings, assumptions,
                                           symbolsAreUniform);
  if (failed(coefficient))
    return failure();
  WideRationalValue acc = *coefficient;
  for (uint32_t i : llvm::seq<uint32_t>(0, view.getMulFactorCount())) {
    sym::MulFactor factor = view.getMulFactor(i);
    if (factor.exponent <= 0)
      return user->emitError("full-address index_expr rational rejects "
                             "non-positive mul exponent");
    FailureOr<WideRationalValue> base = materializeWideRationalIndexExprNode(
        S, factor.base, user, bindings, assumptions, symbolsAreUniform);
    if (failed(base))
      return failure();
    WideRationalValue pow = *base;
    for ([[maybe_unused]] int32_t e : llvm::seq<int32_t>(1, factor.exponent)) {
      FailureOr<WideRationalValue> next =
          mulWideRational(S, loc, pow, *base, user);
      if (failed(next))
        return failure();
      pow = *next;
    }
    FailureOr<WideRationalValue> product =
        mulWideRational(S, loc, acc, pow, user);
    if (failed(product))
      return failure();
    acc = *product;
  }
  return acc;
}

static FailureOr<WideRationalValue> materializeWideIntegerRational(
    WaveAMDMachineSelector &S, sym::ExprHandle expr, Operation *user,
    ArrayRef<std::pair<std::string, Value>> bindings,
    ArrayRef<sym::PredHandle> assumptions, bool symbolsAreUniform) {
  FailureOr<Value> value = materializeWideIndexExprNode(
      S, expr, user, bindings, assumptions, symbolsAreUniform);
  if (failed(value))
    return failure();
  return WideRationalValue{*value, 1};
}

static FailureOr<WideRationalValue> materializeWideRationalPrimitive(
    WaveAMDMachineSelector &S, sym::ExprHandle expr, Operation *user,
    ArrayRef<std::pair<std::string, Value>> bindings, bool symbolsAreUniform) {
  sym::ExprView view(expr);
  switch (view.getKind()) {
  case sym::ExprKind::Integer:
    if (std::optional<int64_t> value = view.getInt())
      return WideRationalValue{createWideImm(S, user->getLoc(), *value), 1};
    break;
  case sym::ExprKind::Rational: {
    std::optional<sym::RationalLiteral> rational = view.getRational();
    if (!rational || rational->denominator <= 0)
      return user->emitError("full-address index_expr has invalid rational");
    return WideRationalValue{
        createWideImm(S, user->getLoc(), rational->numerator),
        rational->denominator};
  }
  case sym::ExprKind::Symbol: {
    FailureOr<Value> value =
        materializeWideSymbol(S, expr, user, bindings, symbolsAreUniform);
    if (failed(value))
      return failure();
    return WideRationalValue{*value, 1};
  }
  default:
    return user->emitError("full-address index_expr rational unsupported "
                           "expression kind ")
           << static_cast<int>(view.getKind());
  }
  return user->emitError("full-address index_expr rational unsupported "
                         "expression kind ")
         << static_cast<int>(view.getKind());
}

static FailureOr<WideRationalValue> materializeWideRationalCompound(
    WaveAMDMachineSelector &S, sym::ExprHandle expr, Operation *user,
    ArrayRef<std::pair<std::string, Value>> bindings,
    ArrayRef<sym::PredHandle> assumptions, bool symbolsAreUniform) {
  sym::ExprView view(expr);
  switch (view.getKind()) {
  case sym::ExprKind::Add:
    return materializeWideRationalAdd(S, expr, user, bindings, assumptions,
                                      symbolsAreUniform);
  case sym::ExprKind::Mul:
    return materializeWideRationalMul(S, expr, user, bindings, assumptions,
                                      symbolsAreUniform);
  case sym::ExprKind::Xor:
  case sym::ExprKind::Floor:
  case sym::ExprKind::Ceil:
    return materializeWideIntegerRational(S, expr, user, bindings, assumptions,
                                          symbolsAreUniform);
  default:
    break;
  }
  return user->emitError("full-address index_expr rational unsupported "
                         "expression kind ")
         << static_cast<int>(view.getKind());
}

static FailureOr<WideRationalValue> materializeWideRationalIndexExprNode(
    WaveAMDMachineSelector &S, sym::ExprHandle expr, Operation *user,
    ArrayRef<std::pair<std::string, Value>> bindings,
    ArrayRef<sym::PredHandle> assumptions, bool symbolsAreUniform) {
  sym::ExprKind kind = sym::ExprView(expr).getKind();
  if (kind == sym::ExprKind::Integer || kind == sym::ExprKind::Rational ||
      kind == sym::ExprKind::Symbol)
    return materializeWideRationalPrimitive(S, expr, user, bindings,
                                            symbolsAreUniform);
  return materializeWideRationalCompound(S, expr, user, bindings, assumptions,
                                         symbolsAreUniform);
}

static bool hasNonNegativeLowerBound(const sym::InferredRange &range) {
  return range.lower && range.lower->denominator > 0 &&
         range.lower->numerator >= 0;
}

static bool hasNonNegativeBoundedRange(WaveAMDMachineSelector &S,
                                       sym::ExprHandle expr,
                                       ArrayRef<sym::PredHandle> assumptions) {
  std::optional<sym::InferredRange> range =
      sym::inferRange(S.symbolStore(), expr, assumptions);
  return range && hasNonNegativeLowerBound(*range) && range->upper &&
         range->upper->denominator > 0;
}

static bool
isProvablyNonNegativeForWideShift(WaveAMDMachineSelector &S,
                                  sym::ExprHandle expr,
                                  ArrayRef<sym::PredHandle> assumptions);

static bool isNonNegativeLiteral(sym::ExprHandle expr) {
  sym::ExprView view(expr);
  if (std::optional<int64_t> value = view.getInt())
    return *value >= 0;
  if (std::optional<sym::RationalLiteral> rational = view.getRational())
    return rational->denominator > 0 && rational->numerator >= 0;
  return false;
}

static bool isNonNegativeAddExpr(WaveAMDMachineSelector &S,
                                 sym::ExprHandle expr,
                                 ArrayRef<sym::PredHandle> assumptions) {
  sym::ExprView view(expr);
  if (!isProvablyNonNegativeForWideShift(S, view.getAddConstant(), assumptions))
    return false;
  for (uint32_t i : llvm::seq<uint32_t>(0, view.getAddTermCount())) {
    sym::AddTerm term = view.getAddTerm(i);
    if (!isProvablyNonNegativeForWideShift(S, term.coefficient, assumptions) ||
        !isProvablyNonNegativeForWideShift(S, term.term, assumptions))
      return false;
  }
  return true;
}

static bool isNonNegativeMulExpr(WaveAMDMachineSelector &S,
                                 sym::ExprHandle expr,
                                 ArrayRef<sym::PredHandle> assumptions) {
  sym::ExprView view(expr);
  if (!isProvablyNonNegativeForWideShift(S, view.getMulCoefficient(),
                                         assumptions))
    return false;
  for (uint32_t i : llvm::seq<uint32_t>(0, view.getMulFactorCount())) {
    sym::MulFactor factor = view.getMulFactor(i);
    if (factor.exponent <= 0 ||
        !isProvablyNonNegativeForWideShift(S, factor.base, assumptions))
      return false;
  }
  return true;
}

static bool isNonNegativeXorExpr(WaveAMDMachineSelector &S,
                                 sym::ExprHandle expr,
                                 ArrayRef<sym::PredHandle> assumptions) {
  sym::ExprView view(expr);
  return hasNonNegativeBoundedRange(S, view.getBinaryLhs(), assumptions) &&
         hasNonNegativeBoundedRange(S, view.getBinaryRhs(), assumptions);
}

static bool
isProvablyNonNegativeForWideShift(WaveAMDMachineSelector &S,
                                  sym::ExprHandle expr,
                                  ArrayRef<sym::PredHandle> assumptions) {
  std::optional<sym::InferredRange> range =
      sym::inferRange(S.symbolStore(), expr, assumptions);
  if (range && hasNonNegativeLowerBound(*range))
    return true;

  sym::ExprView view(expr);
  switch (view.getKind()) {
  case sym::ExprKind::Integer:
  case sym::ExprKind::Rational:
    return isNonNegativeLiteral(expr);
  case sym::ExprKind::Add:
    return isNonNegativeAddExpr(S, expr, assumptions);
  case sym::ExprKind::Mul:
    return isNonNegativeMulExpr(S, expr, assumptions);
  case sym::ExprKind::Xor:
    return isNonNegativeXorExpr(S, expr, assumptions);
  case sym::ExprKind::Floor:
  case sym::ExprKind::Ceil:
    return isProvablyNonNegativeForWideShift(S, view.getUnaryArg(),
                                             assumptions);
  default:
    return false;
  }
}

static LogicalResult requireWideNonNegativeRoundedExpr(
    WaveAMDMachineSelector &S, sym::ExprHandle sourceExpr, Operation *user,
    ArrayRef<sym::PredHandle> assumptions, StringRef opName) {
  std::optional<sym::InferredRange> range =
      sym::inferRange(S.symbolStore(), sourceExpr, assumptions);
  if (range && hasNonNegativeLowerBound(*range))
    return success();
  if (isProvablyNonNegativeForWideShift(S, sourceExpr, assumptions))
    return success();
  return user->emitError("full-address index_expr ")
         << opName << " shift lowering needs nonnegative operand";
}

static FailureOr<Value>
materializeWideRounded(WaveAMDMachineSelector &S, sym::ExprHandle expr,
                       Operation *user,
                       ArrayRef<std::pair<std::string, Value>> bindings,
                       ArrayRef<sym::PredHandle> assumptions, bool isCeil,
                       bool symbolsAreUniform) {
  sym::ExprHandle childExpr = sym::ExprView(expr).getUnaryArg();
  FailureOr<WideRationalValue> child = materializeWideRationalIndexExprNode(
      S, childExpr, user, bindings, assumptions, symbolsAreUniform);
  if (failed(child))
    return failure();
  int64_t den = child->denominator;
  if (den == 1)
    return child->numerator;
  if (den <= 0 || (den & (den - 1)) != 0)
    return user->emitError(
               "full-address index_expr rounded denominator must be a "
               "power of two (got ")
           << den << ")";
  StringRef opName = isCeil ? "ceil" : "floor";
  if (failed(requireWideNonNegativeRoundedExpr(S, childExpr, user, assumptions,
                                               opName)))
    return failure();
  Value numerator = child->numerator;
  if (isCeil)
    numerator = addWide(S, user->getLoc(), numerator,
                        createWideImm(S, user->getLoc(), den - 1));
  return lshrWidePow2(S, user->getLoc(), numerator, llvm::Log2_64(den));
}

static FailureOr<Value> materializeWidePrimitiveIndexExprNode(
    WaveAMDMachineSelector &S, sym::ExprHandle expr, Operation *user,
    ArrayRef<std::pair<std::string, Value>> bindings, bool symbolsAreUniform) {
  sym::ExprView view(expr);
  switch (view.getKind()) {
  case sym::ExprKind::Integer:
    if (std::optional<int64_t> value = view.getInt())
      return createWideImm(S, user->getLoc(), *value);
    break;
  case sym::ExprKind::Rational:
    return materializeWideRational(S, expr, user);
  case sym::ExprKind::Symbol:
    return materializeWideSymbol(S, expr, user, bindings, symbolsAreUniform);
  default:
    break;
  }
  return user->emitError("full-address index_expr leaf unsupported expression "
                         "kind ")
         << static_cast<int>(view.getKind());
}

static FailureOr<Value> materializeWideCompoundIndexExprNode(
    WaveAMDMachineSelector &S, sym::ExprHandle expr, Operation *user,
    ArrayRef<std::pair<std::string, Value>> bindings,
    ArrayRef<sym::PredHandle> assumptions, bool symbolsAreUniform) {
  sym::ExprView view(expr);
  switch (view.getKind()) {
  case sym::ExprKind::Add:
    return materializeWideAdd(S, expr, user, bindings, assumptions,
                              symbolsAreUniform);
  case sym::ExprKind::Mul:
    return materializeWideMul(S, expr, user, bindings, assumptions,
                              symbolsAreUniform);
  case sym::ExprKind::Xor:
    return materializeWideXor(S, expr, user, bindings, assumptions,
                              symbolsAreUniform);
  case sym::ExprKind::Floor:
    return materializeWideRounded(S, expr, user, bindings, assumptions,
                                  /*isCeil=*/false, symbolsAreUniform);
  case sym::ExprKind::Ceil:
    return materializeWideRounded(S, expr, user, bindings, assumptions,
                                  /*isCeil=*/true, symbolsAreUniform);
  case sym::ExprKind::Mod:
    return user->emitError("full-address index_expr supports only add/mul/xor "
                           "and floor/ceil expressions");
  default:
    break;
  }
  return user->emitError("full-address index_expr unsupported expression kind ")
         << static_cast<int>(view.getKind());
}

static FailureOr<Value> materializeWideIndexExprNode(
    WaveAMDMachineSelector &S, sym::ExprHandle expr, Operation *user,
    ArrayRef<std::pair<std::string, Value>> bindings,
    ArrayRef<sym::PredHandle> assumptions, bool symbolsAreUniform) {
  sym::ExprKind kind = sym::ExprView(expr).getKind();
  if (kind == sym::ExprKind::Integer || kind == sym::ExprKind::Rational ||
      kind == sym::ExprKind::Symbol)
    return materializeWidePrimitiveIndexExprNode(S, expr, user, bindings,
                                                 symbolsAreUniform);
  return materializeWideCompoundIndexExprNode(S, expr, user, bindings,
                                              assumptions, symbolsAreUniform);
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
  return materializeIndexExprNode(S, offset.expr, user, subs,
                                  offset.assumptions);
}

static FailureOr<Value>
materializePointerOffsetWideValue(WaveAMDMachineSelector &S, Operation *user,
                                  const PointerOffset &offset) {
  if (!offset.expr)
    return createWideImm(S, user->getLoc(), 0);
  SmallVector<std::pair<std::string, Value>, 4> bindings;
  for (const PointerOffsetBinding &binding : offset.bindings)
    bindings.push_back({binding.name, S.expect(binding.value, user)});
  return materializeWideIndexExprNode(S, offset.expr, user, bindings,
                                      offset.assumptions);
}

static FailureOr<Value> materializeUniformPointerOffsetWideValue(
    WaveAMDMachineSelector &S, Operation *user, const PointerOffset &offset) {
  if (!offset.expr)
    return createWideImm(S, user->getLoc(), 0);
  SmallVector<std::pair<std::string, Value>, 4> bindings;
  for (const PointerOffsetBinding &binding : offset.bindings)
    bindings.push_back({binding.name, S.expect(binding.value, user)});
  return materializeWideIndexExprNode(S, offset.expr, user, bindings,
                                      offset.assumptions,
                                      /*symbolsAreUniform=*/true);
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
  if (needsWideAddressMaterialization(*joined, plan))
    return false;
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
                    sym::ExprHandle expr, const AddressPlanBindings &bindings,
                    ArrayRef<sym::PredHandle> assumptions) {
  return materializeIndexExprNode(S, expr, user, bindings.narrow, assumptions);
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

static Value
materializeSoffsetImmPolicy(WaveAMDMachineSelector &S, Location loc,
                            Value soffset,
                            const waveamdmachine::AddressFieldSpec &spec) {
  if (spec.soffsetImmPolicy != waveamdmachine::SOffsetImmPolicy::ZeroImmOnly)
    return soffset;
  std::optional<int64_t> imm = S.getImmediateValue(soffset);
  if (!imm || *imm == 0)
    return soffset;
  return S.materializeSGPR1(loc, soffset);
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
    FailureOr<Value> voffset = materializePlanExpr(S, user, plan.voffsetExpr,
                                                   bindings, plan.assumptions);
    if (failed(voffset))
      return failure();
    vraw = *voffset;
  } else {
    vraw = createImm(S.builder, user->getLoc(), 0);
  }
  out.voffset = S.ensureVGPRForVSrc1(user->getLoc(), vraw);
  if (spec.hasSoffset) {
    if (plan.soffsetExpr) {
      FailureOr<Value> soffset = materializePlanExpr(
          S, user, plan.soffsetExpr, bindings, plan.assumptions);
      if (failed(soffset))
        return failure();
      out.soffset = S.ensureSGPR1(user->getLoc(), *soffset);
    } else {
      out.soffset = createImm(S.builder, user->getLoc(), 0);
    }
    out.soffset =
        materializeSoffsetImmPolicy(S, user->getLoc(), out.soffset, spec);
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
    FailureOr<Value> voffset = materializePlanExpr(S, user, plan->voffsetExpr,
                                                   bindings, plan->assumptions);
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
    FailureOr<Value> soffset = materializePlanExpr(S, user, plan->soffsetExpr,
                                                   bindings, plan->assumptions);
    if (failed(soffset))
      return failure();
    append(S.ensureSGPR1(loc, *soffset));
  }
  if (plan->instOffset != 0)
    append(createImm(S.builder, loc, plan->instOffset));
  if (plan->fullAddressRemainderExpr) {
    FailureOr<Value> remainder = materializePlanExpr(
        S, user, plan->fullAddressRemainderExpr, bindings, plan->assumptions);
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
    FailureOr<Value> offset = materializeWideIndexExprNode(
        S, *expr, user, bindings.wide, plan.assumptions);
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
      .Case<ub::PoisonOp>([&](auto o) { return selectPoison(o); })
      .Case<LaneIdOp>([&](auto o) { return selectLaneId(o); })
      .Case<ReadCyclesOp>([&](auto o) { return selectReadCycles(o); })
      .Case<WorkgroupIdOp>([&](auto o) { return selectWorkgroupId(o); })
      .Case<WorkitemIdOp>([&](auto o) { return selectWorkitemId(o); })
      .Case<SplatOp>([&](auto o) { return selectSplat(o); })
      .Case<AssumeOp>([&](auto o) { return selectAssume(o); })
      .Case<BinaryOp>([&](auto o) { return selectBinary(o); })
      .Case<PackOp>([&](auto o) { return selectPack(o); })
      .Case<ExtractOp>([&](auto o) { return selectExtract(o); })
      .Case<CastOp>([&](auto o) { return selectCast(o); })
      .Case<FAddOp>([&](auto o) { return selectFAdd(o); })
      .Case<FSubOp>([&](auto o) { return selectFSub(o); })
      .Case<FMulOp>([&](auto o) { return selectFMul(o); })
      .Case<FMaxOp>([&](auto o) { return selectFMax(o); })
      .Case<FmaOp>([&](auto o) { return selectFma(o); })
      .Case<FExp2Op>([&](auto o) { return selectFExp2(o); })
      .Case<FRcpOp>([&](auto o) { return selectFRcp(o); })
      .Case<IndexExprOp>([&](auto o) { return selectIndexExpr(o); })
      .Case<arith::CmpIOp>([&](auto o) { return selectArithCmp(o); })
      .Case<CmpIOp>([&](auto o) { return selectCmp(o); })
      .Case<SelectOp>([&](auto o) { return selectSelect(o); })
      .Case<BallotOp>([&](auto o) { return selectBallot(o); })
      .Case<ReadFirstOp>([&](auto o) { return selectReadFirst(o); })
      .Case<PtrCastOp>([&](auto o) { return selectPtrCast(o); })
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
      .Case<waveamd::MmaScaleOp>([&](auto o) { return selectMmaScale(o); })
      .Case<waveamd::TransposeLoadOp>(
          [&](auto o) { return selectTransposeLoad(o); })
      .Case<waveamd::DmaLoadLdsOp>([&](auto o) { return selectDmaLoadLds(o); })
      .Case<waveamd::FragmentUnpackOp>(
          [&](auto o) { return selectFragmentUnpack(o); })
      .Case<func::ReturnOp>([&](auto o) { return selectReturn(o); })
      .Case<scf::ForOp>([&](auto o) { return selectScfFor(*this, o); })
      .Case<scf::IfOp>([&](auto o) { return selectScfIf(o); })
      .Case<scf::YieldOp>([&](auto) {
        // scf.yield is consumed by structured-control selection.
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
  if (IntegerAttr attr = dyn_cast<IntegerAttr>(op.getValue())) {
    if (!op.getType().isIndex())
      return op.emitError("unsupported arith.constant integer attribute");
    if (!attr.getValue().isSignedIntN(64))
      return op.emitError("index constant must fit signed 64-bit");
    values[op.getResult()] =
        createImm(builder, op.getLoc(), attr.getValue().getSExtValue());
    eraseIfTopLevel(op);
    return success();
  }

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

static FailureOr<unsigned>
getRegisterPayloadBits(Type type,
                       function_ref<InFlightDiagnostic()> emitError) {
  if (auto simdType = dyn_cast<SimdType>(type))
    type = simdType.getElementType();
  if (auto vectorType = dyn_cast<VectorType>(type)) {
    if (vectorType.getRank() != 1 || vectorType.isScalable())
      return emitError() << "unsupported register payload type " << type;
    FailureOr<unsigned> elementBits =
        getRegisterPayloadBits(vectorType.getElementType(), emitError);
    if (failed(elementBits))
      return failure();
    return *elementBits * vectorType.getNumElements();
  }
  if (type.isIndex())
    return 32;
  if (auto intType = dyn_cast<IntegerType>(type)) {
    if (!intType.isSignless())
      return emitError() << "unsupported register payload type " << type;
    return intType.getWidth();
  }
  if (auto floatType = dyn_cast<FloatType>(type))
    return floatType.getWidth();
  return emitError() << "unsupported register payload type " << type;
}

static FailureOr<unsigned>
getRegisterPayloadWidth(Type type,
                        function_ref<InFlightDiagnostic()> emitError) {
  FailureOr<unsigned> bits = getRegisterPayloadBits(type, emitError);
  if (failed(bits))
    return failure();
  return std::max<unsigned>(1, llvm::divideCeil(*bits, 32u));
}

static Value materializeUninitGPR(OpBuilder &builder, Location loc,
                                  waveamdmachine::RegClass regClass,
                                  unsigned width) {
  return waveamdmachine::UninitOp::create(
      builder, loc, getRegType(builder.getContext(), regClass, width));
}

LogicalResult WaveAMDMachineSelector::selectPoison(ub::PoisonOp op) {
  Type type = op.getType();
  if (auto maskType = dyn_cast<MaskType>(type)) {
    unsigned width = maskType.getWidth() / 32;
    values[op.getResult()] = materializeUninitGPR(
        builder, op.getLoc(), waveamdmachine::RegClass::SGPR, width);
    eraseIfTopLevel(op);
    return success();
  }

  if (isa<MemTokenType>(type)) {
    values[op.getResult()] = waveamdmachine::TokenOp::create(
        builder, op.getLoc(), getMemTokenType(op.getContext()));
    eraseIfTopLevel(op);
    return success();
  }

  FailureOr<unsigned> width =
      getRegisterPayloadWidth(type, [&]() { return op.emitError(); });
  if (failed(width))
    return failure();

  if (isa<SimdType>(type)) {
    values[op.getResult()] = materializeUninitGPR(
        builder, op.getLoc(), waveamdmachine::RegClass::VGPR, *width);
  } else {
    values[op.getResult()] = materializeUninitGPR(
        builder, op.getLoc(), waveamdmachine::RegClass::SGPR, *width);
  }
  eraseIfTopLevel(op);
  return success();
}

LogicalResult WaveAMDMachineSelector::selectLaneId(LaneIdOp op) {
  auto simdType = cast<SimdType>(op.getType());
  if (!simdType.getElementType().isInteger(32) ||
      (simdType.getWidth() != 32 && simdType.getWidth() != 64))
    return op.emitError(
        "WaveAMDMachine backend supports only !wave.simd<i32, 32/64> lane_id");
  Value lane = waveamdmachine::VMbcntLoOp::create(
      builder, op.getLoc(),
      getRegType(op.getContext(), waveamdmachine::RegClass::VGPR));
  if (simdType.getWidth() == 64)
    lane = waveamdmachine::VMbcntHiOp::create(
        builder, op.getLoc(),
        getRegType(op.getContext(), waveamdmachine::RegClass::VGPR), lane);
  values[op.getResult()] = lane;
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
  unsigned axis = op.getAxis();
  if (axis > 2)
    return op.emitError("workgroup_id axis must be 0, 1, or 2");
  WaveAMDKernelEntryRegs entryRegs = getWaveAMDKernelEntryRegs(func);
  unsigned sgprIndex = entryRegs.workgroupIdSGPR(axis);
  Type pinned =
      getPinnedRegType(op.getContext(), waveamdmachine::RegClass::SGPR,
                       /*width=*/1, sgprIndex);
  Value result;
  switch (axis) {
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
                       /*width=*/1,
                       getWaveAMDKernelEntryRegs(func).workitemIdXVGPR));
  eraseIfTopLevel(op);
  return success();
}

LogicalResult WaveAMDMachineSelector::selectSplat(SplatOp op) {
  values[op.getResult()] = expect(op.getSource(), op);
  eraseIfTopLevel(op);
  return success();
}

// `wave.assume` is a producer-side proof, not a runtime check.
// The selected value passes straight through.
LogicalResult WaveAMDMachineSelector::selectAssume(AssumeOp op) {
  values[op.getResult()] = expect(op.getValue(), op);
  eraseIfTopLevel(op);
  return success();
}

static bool isBinarySimd(BinaryOp op) {
  return isa<SimdType>(op.getResult().getType());
}

static Value buildVectorBinaryI32(OpBuilder &builder, Location loc,
                                  Type resultType, BinaryKind kind, Value lhs,
                                  Value rhs) {
  if (kind == BinaryKind::AndI)
    return waveamdmachine::VAndB32Op::create(builder, loc, resultType, lhs,
                                             rhs);
  if (kind == BinaryKind::OrI)
    return waveamdmachine::VOrB32Op::create(builder, loc, resultType, lhs, rhs);
  if (kind == BinaryKind::XOrI)
    return waveamdmachine::VXorB32Op::create(builder, loc, resultType, lhs,
                                             rhs);
  if (kind == BinaryKind::ShRUI)
    return waveamdmachine::VLshrrevB32Op::create(builder, loc, resultType, lhs,
                                                 rhs);
  return Value{};
}

static Value buildScalarBinaryI32(OpBuilder &builder, Location loc,
                                  Type resultType, BinaryKind kind, Value lhs,
                                  Value rhs) {
  Type scc = getSCCType(builder.getContext());
  if (kind == BinaryKind::AndI)
    return waveamdmachine::SAndB32Op::create(builder, loc, resultType, scc, lhs,
                                             rhs)
        .getResult();
  if (kind == BinaryKind::OrI)
    return waveamdmachine::SOrB32Op::create(builder, loc, resultType, scc, lhs,
                                            rhs)
        .getResult();
  if (kind == BinaryKind::XOrI)
    return waveamdmachine::SXorB32Op::create(builder, loc, resultType, scc, lhs,
                                             rhs)
        .getResult();
  if (kind == BinaryKind::ShRUI)
    return waveamdmachine::SLshrB32Op::create(builder, loc, resultType, scc,
                                              lhs, rhs)
        .getResult();
  return Value{};
}

static void prepareVectorBinaryI32Operands(WaveAMDMachineSelector &S,
                                           BinaryOp op, BinaryKind kind,
                                           Value &lhs, Value &rhs) {
  if (kind == BinaryKind::ShRUI) {
    lhs = S.ensureVGPRForVSrc1(op.getLoc(), lhs);
    return;
  }
  if (isImm(rhs))
    rhs = S.ensureVGPRForVSrc1(op.getLoc(), rhs);
  if (!isVGPR(lhs) && !isVGPR(rhs))
    lhs = S.ensureVGPRForVSrc1(op.getLoc(), lhs);
}

// Element bit-width of an iN/index or !wave.simd<iN/index, W> type.
unsigned WaveAMDMachineSelector::waveArithElementBits(Type type) {
  if (auto simd = dyn_cast<SimdType>(type))
    type = simd.getElementType();
  if (type.isIndex())
    return 64;
  return cast<IntegerType>(type).getWidth();
}

LogicalResult WaveAMDMachineSelector::selectBinaryAddI32(BinaryOp op) {
  Value lhs = expect(op.getLhs(), op);
  Value rhs = expect(op.getRhs(), op);
  if (!isBinarySimd(op)) {
    values[op.getResult()] = addUniformBytes(op.getLoc(), lhs, rhs);
    eraseIfTopLevel(op);
    return success();
  }
  values[op.getResult()] = addByteOffsets(op.getLoc(), lhs, rhs);
  eraseIfTopLevel(op);
  return success();
}

LogicalResult WaveAMDMachineSelector::selectBinaryAddI64(BinaryOp op) {
  Value lhs = expect(op.getLhs(), op);
  Value rhs = expect(op.getRhs(), op);
  values[op.getResult()] = addWide(*this, op.getLoc(), lhs, rhs);
  eraseIfTopLevel(op);
  return success();
}

LogicalResult WaveAMDMachineSelector::selectBinaryMulI32(BinaryOp op) {
  Value lhs = expect(op.getLhs(), op);
  Value rhs = expect(op.getRhs(), op);
  if (!isBinarySimd(op)) {
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

LogicalResult WaveAMDMachineSelector::selectBinaryMulI64(BinaryOp op) {
  Value lhs = expect(op.getLhs(), op);
  Value rhs = expect(op.getRhs(), op);
  values[op.getResult()] = mulWide(*this, op.getLoc(), lhs, rhs);
  eraseIfTopLevel(op);
  return success();
}

LogicalResult WaveAMDMachineSelector::selectBinaryShLI32(BinaryOp op) {
  Value lhs = expect(op.getLhs(), op);
  Value rhs = expect(op.getRhs(), op);
  if (!isBinarySimd(op)) {
    values[op.getResult()] =
        waveamdmachine::SLshlB32Op::create(
            builder, op.getLoc(),
            getRegType(op.getContext(), waveamdmachine::RegClass::SGPR),
            getSCCType(op.getContext()), lhs, rhs)
            .getResult();
    eraseIfTopLevel(op);
    return success();
  }
  lhs = ensureVGPRForVSrc1(op.getLoc(), lhs);
  values[op.getResult()] = waveamdmachine::VLshlrevB32Op::create(
      builder, op.getLoc(),
      getRegType(op.getContext(), waveamdmachine::RegClass::VGPR), rhs, lhs);
  eraseIfTopLevel(op);
  return success();
}

LogicalResult WaveAMDMachineSelector::selectBinaryShLI64(BinaryOp op) {
  Value lhs = expect(op.getLhs(), op);
  Value rhs = expect(op.getRhs(), op);
  if (!isBinarySimd(op)) {
    Type resultType =
        getRegType(op.getContext(), waveamdmachine::RegClass::SGPR, 2);
    Value shift = extractLowDword(*this, op.getLoc(), rhs, op.getRhs());
    values[op.getResult()] =
        waveamdmachine::SLshlB64Op::create(builder, op.getLoc(), resultType,
                                           getSCCType(op.getContext()),
                                           ensureSGPR2(*this, op.getLoc(), lhs),
                                           ensureSGPR1(op.getLoc(), shift))
            .getResult();
    eraseIfTopLevel(op);
    return success();
  }
  Type resultType =
      getRegType(op.getContext(), waveamdmachine::RegClass::VGPR, 2);
  Value shift = extractLowDword(*this, op.getLoc(), rhs, op.getRhs());
  values[op.getResult()] = waveamdmachine::VLshlrevB64Op::create(
      builder, op.getLoc(), resultType, shift,
      ensureVGPR2(*this, op.getLoc(), lhs));
  eraseIfTopLevel(op);
  return success();
}

static std::optional<int64_t> getSignedImmediate(WaveAMDMachineSelector &S,
                                                 Value value) {
  if (std::optional<int64_t> imm = S.getImmediateValue(value))
    return *imm;
  if (auto mov = value.getDefiningOp<waveamdmachine::SMovB64ImmOp>())
    return mov.getValue();
  return std::nullopt;
}

static std::optional<uint64_t> getWideImmediate(WaveAMDMachineSelector &S,
                                                Value value) {
  if (std::optional<int64_t> imm = getSignedImmediate(S, value))
    return static_cast<uint64_t>(*imm);
  return std::nullopt;
}

static uint64_t maskToWidth(uint64_t value, unsigned bits) {
  if (bits >= 64)
    return value;
  return value & ((uint64_t{1} << bits) - 1);
}

static std::optional<uint64_t>
getUnsignedImmediate(WaveAMDMachineSelector &S, Value value, unsigned bits) {
  if (std::optional<uint64_t> imm = getWideImmediate(S, value))
    return maskToWidth(*imm, bits);
  return std::nullopt;
}

static bool isPositivePowerOfTwo(uint64_t value) {
  return value != 0 && (value & (value - 1)) == 0;
}

static bool isSignedDivRem(BinaryKind kind) {
  return kind == BinaryKind::DivSI || kind == BinaryKind::RemSI;
}

struct DynamicDivisorQuery {
  SmallVector<sym::PredHandle, 4> assumptions;
  sym::ExprHandle expr;
};

class DynamicDivisorQueryBuilder {
public:
  explicit DynamicDivisorQueryBuilder(WaveAMDMachineSelector &S) : S(S) {}

  FailureOr<DynamicDivisorQuery> build(Value value) {
    FailureOr<sym::ExprHandle> expr = buildValueExpr(value);
    if (failed(expr))
      return failure();
    return DynamicDivisorQuery{std::move(assumptions), *expr};
  }

private:
  FailureOr<sym::ExprHandle> buildValueExpr(Value value, unsigned depth = 0) {
    if (depth > 8)
      return failure();
    if (std::optional<int64_t> constant = getConstantIntValue(value))
      return sym::composeExprInt(S.symbolStore(), *constant);
    if (SplatOp splat = value.getDefiningOp<SplatOp>())
      return buildValueExpr(splat.getSource(), depth + 1);
    if (BinaryOp binary = value.getDefiningOp<BinaryOp>())
      return buildBinaryExpr(binary, depth + 1);
    return bindSymbol(value);
  }

  FailureOr<sym::ExprHandle> buildBinaryExpr(BinaryOp op, unsigned depth) {
    if (op.getKind() == BinaryKind::ShLI)
      return buildShiftExpr(op, depth);
    std::optional<sym::ExprBinaryOp> kind = convertBinaryKind(op);
    if (!kind)
      return failure();
    FailureOr<sym::ExprHandle> lhs = buildValueExpr(op.getLhs(), depth);
    FailureOr<sym::ExprHandle> rhs = buildValueExpr(op.getRhs(), depth);
    if (failed(lhs) || failed(rhs))
      return failure();
    return sym::composeExprBinary(S.symbolStore(), *lhs, *kind, *rhs);
  }

  FailureOr<sym::ExprHandle> buildShiftExpr(BinaryOp op, unsigned depth) {
    if (!op.hasNoSignedWrap())
      return failure();
    std::optional<int64_t> shift = getConstantIntValue(op.getRhs());
    if (!shift || *shift < 0 || *shift >= 63)
      return failure();
    FailureOr<sym::ExprHandle> lhs = buildValueExpr(op.getLhs(), depth);
    if (failed(lhs))
      return failure();
    FailureOr<sym::ExprHandle> scale =
        sym::composeExprInt(S.symbolStore(), int64_t{1} << *shift);
    if (failed(scale))
      return failure();
    return sym::composeExprBinary(S.symbolStore(), *lhs, sym::ExprBinaryOp::Mul,
                                  *scale);
  }

  std::optional<sym::ExprBinaryOp> convertBinaryKind(BinaryOp op) {
    switch (op.getKind()) {
    case BinaryKind::AddI:
      return op.hasNoSignedWrap()
                 ? std::optional<sym::ExprBinaryOp>(sym::ExprBinaryOp::Add)
                 : std::nullopt;
    case BinaryKind::SubI:
      return op.hasNoSignedWrap()
                 ? std::optional<sym::ExprBinaryOp>(sym::ExprBinaryOp::Sub)
                 : std::nullopt;
    case BinaryKind::MulI:
      return op.hasNoSignedWrap()
                 ? std::optional<sym::ExprBinaryOp>(sym::ExprBinaryOp::Mul)
                 : std::nullopt;
    case BinaryKind::XOrI:
      return sym::ExprBinaryOp::Xor;
    default:
      return std::nullopt;
    }
  }

  FailureOr<sym::ExprHandle> bindSymbol(Value value) {
    StringRef stem = "d";
    if (auto assume = value.getDefiningOp<AssumeOp>())
      stem = assume.getName();
    StringRef name =
        reserveIndexExprBindingName(stem, value, reserved, byValue);
    FailureOr<sym::ExprHandle> expr =
        sym::composeExprSym(S.symbolStore(), name);
    if (failed(expr))
      return failure();
    S.appendBindingAssumptions(value, name, assumptions);
    return *expr;
  }

  WaveAMDMachineSelector &S;
  SmallVector<sym::PredHandle, 4> assumptions;
  llvm::StringMap<Value> reserved;
  llvm::DenseMap<Value, StringRef> byValue;
};

static bool isProvenPositivePow2(WaveAMDMachineSelector &S, Value source) {
  FailureOr<DynamicDivisorQuery> query =
      DynamicDivisorQueryBuilder(S).build(source);
  if (failed(query))
    return false;
  return sym::getPow2Fact(S.symbolStore(), query->expr, query->assumptions) ==
         sym::Pow2Fact::Positive;
}

static std::optional<uint64_t>
getStaticPowerOfTwoDivisor(WaveAMDMachineSelector &S, BinaryOp op) {
  Value rhs = S.expect(op.getRhs(), op);
  if (isSignedDivRem(op.getKind())) {
    std::optional<int64_t> divisor = getSignedImmediate(S, rhs);
    if (!divisor || *divisor <= 0 ||
        !isPositivePowerOfTwo(static_cast<uint64_t>(*divisor)))
      return std::nullopt;
    return static_cast<uint64_t>(*divisor);
  }
  unsigned bits = S.waveArithElementBits(op.getResult().getType());
  std::optional<uint64_t> divisor = getUnsignedImmediate(S, rhs, bits);
  if (!divisor || !isPositivePowerOfTwo(*divisor))
    return std::nullopt;
  return *divisor;
}

static LogicalResult emitPowerOfTwoDivisorError(BinaryOp op) {
  if (op.getKind() == BinaryKind::DivSI)
    return op.emitOpError("needs positive power-of-two static divisor or "
                          "proven positive power-of-two dynamic divisor");
  if (isSignedDivRem(op.getKind()))
    return op.emitOpError("needs positive power-of-two static divisor");
  return op.emitOpError("needs power-of-two static divisor");
}

static bool isProvenNonNegative(WaveAMDMachineSelector &S, Value source,
                                Value selected) {
  if (std::optional<int64_t> imm = S.getImmediateValue(selected))
    return *imm >= 0;
  if (auto mov = selected.getDefiningOp<waveamdmachine::SMovB64ImmOp>())
    return static_cast<int64_t>(mov.getValue()) >= 0;
  std::optional<ConstantIntRanges> range = finiteSignedRange(S, source);
  if (!range)
    range = finiteSignedRange(S, selected);
  return range && !range->smin().isNegative();
}

static LogicalResult requireNonNegativeDividend(WaveAMDMachineSelector &S,
                                                BinaryOp op) {
  BinaryKind kind = op.getKind();
  if (!isSignedDivRem(kind))
    return success();
  if (isProvenNonNegative(S, op.getLhs(), S.expect(op.getLhs(), op)))
    return success();
  return op.emitOpError("signed power-of-two div/rem requires nonnegative "
                        "dividend");
}

LogicalResult WaveAMDMachineSelector::selectBinarySubI32(BinaryOp op) {
  Value lhs = expect(op.getLhs(), op);
  Value rhs = expect(op.getRhs(), op);
  Value notRhs;
  if (!isBinarySimd(op)) {
    if (std::optional<int64_t> rhsImm = getImmediateValue(rhs))
      notRhs = createImm(builder, op.getLoc(), ~*rhsImm);
    else
      notRhs = buildScalarBinaryI32(
          builder, op.getLoc(),
          getRegType(op.getContext(), waveamdmachine::RegClass::SGPR),
          BinaryKind::XOrI, rhs, createImm(builder, op.getLoc(), -1));
    Value negRhs = addUniformBytes(op.getLoc(), notRhs,
                                   createImm(builder, op.getLoc(), 1));
    values[op.getResult()] = addUniformBytes(op.getLoc(), lhs, negRhs);
    eraseIfTopLevel(op);
    return success();
  }
  rhs = ensureVGPRForVSrc1(op.getLoc(), rhs);
  notRhs = buildVectorBinaryI32(
      builder, op.getLoc(),
      getRegType(op.getContext(), waveamdmachine::RegClass::VGPR),
      BinaryKind::XOrI, rhs, createImm(builder, op.getLoc(), -1));
  Value negRhs =
      addByteOffsets(op.getLoc(), notRhs, createImm(builder, op.getLoc(), 1));
  values[op.getResult()] = addByteOffsets(op.getLoc(), lhs, negRhs);
  eraseIfTopLevel(op);
  return success();
}

LogicalResult WaveAMDMachineSelector::selectBinarySubI64(BinaryOp op) {
  Value lhs = expect(op.getLhs(), op);
  Value rhs = expect(op.getRhs(), op);
  Value notRhs =
      xorWide(*this, op.getLoc(), rhs, createWideImm(*this, op.getLoc(), -1));
  Value negRhs =
      addWide(*this, op.getLoc(), notRhs, createWideImm(*this, op.getLoc(), 1));
  values[op.getResult()] = addWide(*this, op.getLoc(), lhs, negRhs);
  eraseIfTopLevel(op);
  return success();
}

static Value shrWidePow2(WaveAMDMachineSelector &S, Location loc, Value value,
                         unsigned log2Den) {
  if (log2Den == 0)
    return value;
  if (std::optional<uint64_t> imm = getWideImmediate(S, value))
    return createWideImm(S, loc, static_cast<int64_t>(*imm >> log2Den));
  Value shift = createImm(S.builder, loc, log2Den);
  if (isWideVGPR(value)) {
    Type resultType =
        getRegType(S.builder.getContext(), waveamdmachine::RegClass::VGPR, 2);
    return waveamdmachine::VLshrrevB64Op::create(S.builder, loc, resultType,
                                                 shift, value);
  }
  Type resultType =
      getRegType(S.builder.getContext(), waveamdmachine::RegClass::SGPR, 2);
  return waveamdmachine::SLshrB64Op::create(
             S.builder, loc, resultType, getSCCType(S.builder.getContext()),
             ensureSGPR2(S, loc, value), S.ensureSGPR1(loc, shift))
      .getResult();
}

static Value ctzDynamicI32(WaveAMDMachineSelector &S, Location loc,
                           Value divisor) {
  if (S.isUniformValue(divisor))
    return waveamdmachine::SFf1I32B32Op::create(
        S.builder, loc,
        getRegType(S.builder.getContext(), waveamdmachine::RegClass::SGPR),
        S.materializeSGPR1(loc, divisor));
  return waveamdmachine::VFfblB32Op::create(
      S.builder, loc,
      getRegType(S.builder.getContext(), waveamdmachine::RegClass::VGPR),
      S.ensureVGPRForVSrc1(loc, divisor));
}

static Value shrDynamicPow2I32(WaveAMDMachineSelector &S, Location loc,
                               Value value, Value shift) {
  if (S.isUniformValue(value) && S.isUniformValue(shift))
    return waveamdmachine::SLshrB32Op::create(
               S.builder, loc,
               getRegType(S.builder.getContext(),
                          waveamdmachine::RegClass::SGPR),
               getSCCType(S.builder.getContext()),
               S.materializeSGPR1(loc, value), S.ensureSGPR1(loc, shift))
        .getResult();
  return waveamdmachine::VLshrrevB32Op::create(
      S.builder, loc,
      getRegType(S.builder.getContext(), waveamdmachine::RegClass::VGPR),
      S.ensureVGPRForVSrc1(loc, value), shift);
}

static Value ctzDynamicI64(WaveAMDMachineSelector &S, Location loc,
                           Value divisor) {
  if (isWideVGPR(divisor))
    return {};
  return waveamdmachine::SFf1I32B64Op::create(
      S.builder, loc,
      getRegType(S.builder.getContext(), waveamdmachine::RegClass::SGPR),
      ensureSGPR2(S, loc, divisor));
}

static Value shrDynamicPow2I64(WaveAMDMachineSelector &S, Location loc,
                               Value value, Value shift) {
  if (!isWideVGPR(value) && S.isUniformValue(shift))
    return waveamdmachine::SLshrB64Op::create(
               S.builder, loc,
               getRegType(S.builder.getContext(),
                          waveamdmachine::RegClass::SGPR, 2),
               getSCCType(S.builder.getContext()), ensureSGPR2(S, loc, value),
               S.ensureSGPR1(loc, shift))
        .getResult();
  return waveamdmachine::VLshrrevB64Op::create(
      S.builder, loc,
      getRegType(S.builder.getContext(), waveamdmachine::RegClass::VGPR, 2),
      shift, ensureVGPR2(S, loc, value));
}

static Value materializeOneDword(WaveAMDMachineSelector &S, Location loc,
                                 Value value,
                                 waveamdmachine::RegClass regClass) {
  if (regClass == waveamdmachine::RegClass::VGPR)
    return S.ensureVGPRForVSrc1(loc, value);
  return S.materializeSGPR1(loc, value);
}

static Value andWideMask(WaveAMDMachineSelector &S, Location loc, Value value,
                         uint64_t mask) {
  if (std::optional<uint64_t> imm = getWideImmediate(S, value))
    return createWideImm(S, loc, static_cast<int64_t>(*imm & mask));

  bool vgpr = isWideVGPR(value);
  waveamdmachine::RegClass regClass =
      vgpr ? waveamdmachine::RegClass::VGPR : waveamdmachine::RegClass::SGPR;
  Type elementType = getRegType(S.builder.getContext(), regClass, 1);
  uint32_t loMask = static_cast<uint32_t>(mask);
  uint32_t hiMask = static_cast<uint32_t>(mask >> 32);
  Value lo = extractLowDword(S, loc, value);
  Value hi = extractHighDword(S, loc, value);
  Value loImm = createImm(S.builder, loc, loMask);
  Value hiImm = createImm(S.builder, loc, hiMask);
  if (vgpr) {
    lo = waveamdmachine::VAndB32Op::create(
        S.builder, loc, elementType, S.ensureVGPRForVSrc1(loc, lo), loImm);
    hi = waveamdmachine::VAndB32Op::create(
        S.builder, loc, elementType, S.ensureVGPRForVSrc1(loc, hi), hiImm);
  } else {
    lo = waveamdmachine::SAndB32Op::create(S.builder, loc, elementType,
                                           getSCCType(S.builder.getContext()),
                                           S.materializeSGPR1(loc, lo), loImm)
             .getResult();
    hi = waveamdmachine::SAndB32Op::create(S.builder, loc, elementType,
                                           getSCCType(S.builder.getContext()),
                                           S.materializeSGPR1(loc, hi), hiImm)
             .getResult();
  }
  return tuple2(S, loc, regClass, materializeOneDword(S, loc, lo, regClass),
                materializeOneDword(S, loc, hi, regClass));
}

static LogicalResult selectBinaryDivRemI32(WaveAMDMachineSelector &S,
                                           BinaryOp op) {
  if (failed(requireNonNegativeDividend(S, op)))
    return failure();
  Value lhs = S.expect(op.getLhs(), op);
  BinaryKind kind = op.getKind();
  if (std::optional<uint64_t> divisor = getStaticPowerOfTwoDivisor(S, op)) {
    unsigned log2Den = llvm::Log2_64(*divisor);
    S.values[op.getResult()] =
        kind == BinaryKind::DivUI || kind == BinaryKind::DivSI
            ? S.shrPow2(op.getLoc(), lhs, log2Den)
            : S.andMask(op.getLoc(), lhs, static_cast<int64_t>(*divisor - 1));
    S.eraseIfTopLevel(op);
    return success();
  }
  if (kind == BinaryKind::DivSI && isProvenPositivePow2(S, op.getRhs())) {
    Value shift = ctzDynamicI32(S, op.getLoc(), S.expect(op.getRhs(), op));
    S.values[op.getResult()] = shrDynamicPow2I32(S, op.getLoc(), lhs, shift);
    S.eraseIfTopLevel(op);
    return success();
  }
  return emitPowerOfTwoDivisorError(op);
}

static LogicalResult selectBinaryDivRemI64(WaveAMDMachineSelector &S,
                                           BinaryOp op) {
  if (failed(requireNonNegativeDividend(S, op)))
    return failure();
  Value lhs = S.expect(op.getLhs(), op);
  BinaryKind kind = op.getKind();
  if (std::optional<uint64_t> divisor = getStaticPowerOfTwoDivisor(S, op)) {
    unsigned log2Den = llvm::Log2_64(*divisor);
    S.values[op.getResult()] =
        kind == BinaryKind::DivUI || kind == BinaryKind::DivSI
            ? shrWidePow2(S, op.getLoc(), lhs, log2Den)
            : andWideMask(S, op.getLoc(), lhs, *divisor - 1);
    S.eraseIfTopLevel(op);
    return success();
  }
  if (kind == BinaryKind::DivSI && isProvenPositivePow2(S, op.getRhs())) {
    Value shift = ctzDynamicI64(S, op.getLoc(), S.expect(op.getRhs(), op));
    if (!shift)
      return op.emitOpError("i64 dynamic power-of-two divisor must be uniform");
    S.values[op.getResult()] = shrDynamicPow2I64(S, op.getLoc(), lhs, shift);
    S.eraseIfTopLevel(op);
    return success();
  }
  return emitPowerOfTwoDivisorError(op);
}

static bool isDivRem(BinaryKind kind) {
  return kind == BinaryKind::DivUI || kind == BinaryKind::DivSI ||
         kind == BinaryKind::RemUI || kind == BinaryKind::RemSI;
}

static bool isBitwiseOrLogicalShiftI32(BinaryKind kind) {
  return kind == BinaryKind::AndI || kind == BinaryKind::OrI ||
         kind == BinaryKind::XOrI || kind == BinaryKind::ShRUI;
}

static LogicalResult selectBinaryBitwiseOrShiftI32(WaveAMDMachineSelector &S,
                                                   BinaryOp op) {
  BinaryKind kind = op.getKind();
  Value lhs = S.expect(op.getLhs(), op);
  Value rhs = S.expect(op.getRhs(), op);
  Type resultType = getRegType(
      op.getContext(), isBinarySimd(op) ? waveamdmachine::RegClass::VGPR
                                        : waveamdmachine::RegClass::SGPR);
  if (!isBinarySimd(op)) {
    S.values[op.getResult()] = buildScalarBinaryI32(S.builder, op.getLoc(),
                                                    resultType, kind, lhs, rhs);
    S.eraseIfTopLevel(op);
    return success();
  }
  prepareVectorBinaryI32Operands(S, op, kind, lhs, rhs);
  S.values[op.getResult()] =
      buildVectorBinaryI32(S.builder, op.getLoc(), resultType, kind, lhs, rhs);
  S.eraseIfTopLevel(op);
  return success();
}

static LogicalResult selectBinaryI32(WaveAMDMachineSelector &S, BinaryOp op) {
  BinaryKind kind = op.getKind();
  if (kind == BinaryKind::AddI)
    return S.selectBinaryAddI32(op);
  if (kind == BinaryKind::SubI)
    return S.selectBinarySubI32(op);
  if (kind == BinaryKind::MulI)
    return S.selectBinaryMulI32(op);
  if (kind == BinaryKind::ShLI)
    return S.selectBinaryShLI32(op);
  if (isDivRem(kind))
    return selectBinaryDivRemI32(S, op);
  if (isBitwiseOrLogicalShiftI32(kind))
    return selectBinaryBitwiseOrShiftI32(S, op);
  return op.emitOpError("unsupported i32 wave.binary kind ")
         << stringifyBinaryKind(kind);
}

static LogicalResult selectBinaryI64(WaveAMDMachineSelector &S, BinaryOp op) {
  BinaryKind kind = op.getKind();
  if (kind == BinaryKind::AddI)
    return S.selectBinaryAddI64(op);
  if (kind == BinaryKind::SubI)
    return S.selectBinarySubI64(op);
  if (kind == BinaryKind::MulI)
    return S.selectBinaryMulI64(op);
  if (kind == BinaryKind::ShLI)
    return S.selectBinaryShLI64(op);
  if (isDivRem(kind))
    return selectBinaryDivRemI64(S, op);
  if (kind == BinaryKind::XOrI) {
    Value lhs = S.expect(op.getLhs(), op);
    Value rhs = S.expect(op.getRhs(), op);
    S.values[op.getResult()] = xorWide(S, op.getLoc(), lhs, rhs);
    S.eraseIfTopLevel(op);
    return success();
  }
  return op.emitOpError("unsupported i64 wave.binary kind ")
         << stringifyBinaryKind(kind);
}

LogicalResult WaveAMDMachineSelector::selectBinary(BinaryOp op) {
  unsigned bits = waveArithElementBits(op.getResult().getType());
  if (bits == 32)
    return selectBinaryI32(*this, op);
  if (bits == 64)
    return selectBinaryI64(*this, op);
  return op.emitError("WaveAMDMachine backend only supports i32 / i64 "
                      "wave.binary (got i")
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

static FailureOr<MemoryPayloadShape>
getSimdVectorPayloadShape(Operation *op, Type type, StringRef kind) {
  auto simdType = dyn_cast<SimdType>(type);
  if (!simdType || !isa<VectorType>(simdType.getElementType()))
    return op->emitError("WaveAMDMachine ")
           << kind << " lowering supports only SIMD vector memory payloads";
  return getMemoryPayloadShape(
      simdType.getElementType(),
      [&](const Twine &msg) { return op->emitError(msg); });
}

static Value maskLowBits(WaveAMDMachineSelector &S, Location loc, Value value,
                         unsigned bits) {
  if (bits == 32)
    return value;
  Type vgprType =
      getRegType(S.builder.getContext(), waveamdmachine::RegClass::VGPR);
  Value mask = createImm(S.builder, loc, (int64_t{1} << bits) - 1);
  return waveamdmachine::VAndB32Op::create(S.builder, loc, vgprType, value,
                                           mask);
}

LogicalResult WaveAMDMachineSelector::selectPack(PackOp op) {
  FailureOr<MemoryPayloadShape> shape =
      getSimdVectorPayloadShape(op, op.getResult().getType(), "pack");
  if (failed(shape))
    return failure();

  Location loc = op.getLoc();
  Type vgprType = getRegType(op.getContext(), waveamdmachine::RegClass::VGPR);
  SmallVector<Value> words(shape->registers);
  for (auto [index, input] : llvm::enumerate(op.getInputs())) {
    unsigned bitOffset = index * shape->elementBits;
    unsigned wordIndex = bitOffset / 32;
    unsigned wordShift = bitOffset % 32;
    Value value = ensureVGPRForVSrc1(loc, expect(input, op));
    value = maskLowBits(*this, loc, value, shape->elementBits);
    if (wordShift)
      value = waveamdmachine::VLshlrevB32Op::create(
          builder, loc, vgprType, value, createImm(builder, loc, wordShift));
    if (!words[wordIndex]) {
      words[wordIndex] = value;
      continue;
    }
    words[wordIndex] = waveamdmachine::VOrB32Op::create(
        builder, loc, vgprType, words[wordIndex], value);
  }

  if (words.size() == 1) {
    values[op.getResult()] = words.front();
  } else {
    Type tupleType = getRegType(op.getContext(), waveamdmachine::RegClass::VGPR,
                                shape->registers);
    values[op.getResult()] = waveamdmachine::TupleFromElementsOp::create(
        builder, loc, tupleType, words);
  }
  eraseIfTopLevel(op);
  return success();
}

LogicalResult WaveAMDMachineSelector::selectExtract(ExtractOp op) {
  FailureOr<MemoryPayloadShape> shape =
      getSimdVectorPayloadShape(op, op.getSource().getType(), "extract");
  if (failed(shape))
    return failure();

  Location loc = op.getLoc();
  Type vgprType = getRegType(op.getContext(), waveamdmachine::RegClass::VGPR);
  Value word = expect(op.getSource(), op);
  unsigned bitOffset = op.getIndex() * shape->elementBits;
  unsigned wordIndex = bitOffset / 32;
  unsigned wordShift = bitOffset % 32;
  if (shape->registers != 1) {
    SmallVector<Type> elementTypes(shape->registers, vgprType);
    auto split = waveamdmachine::TupleToElementsOp::create(builder, loc,
                                                           elementTypes, word);
    word = split.getElements()[wordIndex];
  }
  if (wordShift)
    word = waveamdmachine::VLshrrevB32Op::create(
        builder, loc, vgprType, word, createImm(builder, loc, wordShift));
  values[op.getResult()] = maskLowBits(*this, loc, word, shape->elementBits);
  eraseIfTopLevel(op);
  return success();
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

enum class CmpRelation { Eq, Ne, Lt, Le, Gt, Ge };

static bool isSignedCmpPredicate(arith::CmpIPredicate predicate) {
  switch (predicate) {
  case arith::CmpIPredicate::slt:
  case arith::CmpIPredicate::sle:
  case arith::CmpIPredicate::sgt:
  case arith::CmpIPredicate::sge:
    return true;
  default:
    return false;
  }
}

static arith::CmpIPredicate normalizeSignedCmp(arith::CmpIPredicate predicate) {
  switch (predicate) {
  case arith::CmpIPredicate::slt:
    return arith::CmpIPredicate::ult;
  case arith::CmpIPredicate::sle:
    return arith::CmpIPredicate::ule;
  case arith::CmpIPredicate::sgt:
    return arith::CmpIPredicate::ugt;
  case arith::CmpIPredicate::sge:
    return arith::CmpIPredicate::uge;
  default:
    return predicate;
  }
}

static std::optional<CmpRelation>
getCmpRelation(arith::CmpIPredicate predicate) {
  switch (normalizeSignedCmp(predicate)) {
  case arith::CmpIPredicate::eq:
    return CmpRelation::Eq;
  case arith::CmpIPredicate::ne:
    return CmpRelation::Ne;
  case arith::CmpIPredicate::ult:
    return CmpRelation::Lt;
  case arith::CmpIPredicate::ule:
    return CmpRelation::Le;
  case arith::CmpIPredicate::ugt:
    return CmpRelation::Gt;
  case arith::CmpIPredicate::uge:
    return CmpRelation::Ge;
  default:
    return std::nullopt;
  }
}

static Value createVCmpU32(OpBuilder &builder, Location loc,
                           CmpRelation relation, Type resultType, Value lhs,
                           Value rhs) {
  switch (relation) {
  case CmpRelation::Eq:
    return waveamdmachine::VCmpEqU32Op::create(builder, loc, resultType, lhs,
                                               rhs);
  case CmpRelation::Ne:
    return waveamdmachine::VCmpNeU32Op::create(builder, loc, resultType, lhs,
                                               rhs);
  case CmpRelation::Lt:
    return waveamdmachine::VCmpLtU32Op::create(builder, loc, resultType, lhs,
                                               rhs);
  case CmpRelation::Le:
    return waveamdmachine::VCmpLeU32Op::create(builder, loc, resultType, lhs,
                                               rhs);
  case CmpRelation::Gt:
    return waveamdmachine::VCmpGtU32Op::create(builder, loc, resultType, lhs,
                                               rhs);
  case CmpRelation::Ge:
    return waveamdmachine::VCmpGeU32Op::create(builder, loc, resultType, lhs,
                                               rhs);
  }
  llvm_unreachable("handled unsigned compare relation");
}

static Value createVCmpI32(OpBuilder &builder, Location loc,
                           CmpRelation relation, Type resultType, Value lhs,
                           Value rhs) {
  switch (relation) {
  case CmpRelation::Lt:
    return waveamdmachine::VCmpLtI32Op::create(builder, loc, resultType, lhs,
                                               rhs);
  case CmpRelation::Le:
    return waveamdmachine::VCmpLeI32Op::create(builder, loc, resultType, lhs,
                                               rhs);
  case CmpRelation::Gt:
    return waveamdmachine::VCmpGtI32Op::create(builder, loc, resultType, lhs,
                                               rhs);
  case CmpRelation::Ge:
    return waveamdmachine::VCmpGeI32Op::create(builder, loc, resultType, lhs,
                                               rhs);
  case CmpRelation::Eq:
  case CmpRelation::Ne:
    llvm_unreachable("signed eq/ne compare uses unsigned compare op");
  }
  llvm_unreachable("handled signed compare relation");
}

static Value createVCmpU32Vcc(OpBuilder &builder, Location loc,
                              CmpRelation relation, Type resultType,
                              Type vccType, Value lhs, Value rhs) {
  switch (relation) {
  case CmpRelation::Eq:
    return waveamdmachine::VCmpEqU32VccOp::create(builder, loc, resultType,
                                                  vccType, lhs, rhs)
        .getResult();
  case CmpRelation::Ne:
    return waveamdmachine::VCmpNeU32VccOp::create(builder, loc, resultType,
                                                  vccType, lhs, rhs)
        .getResult();
  case CmpRelation::Lt:
    return waveamdmachine::VCmpLtU32VccOp::create(builder, loc, resultType,
                                                  vccType, lhs, rhs)
        .getResult();
  case CmpRelation::Le:
    return waveamdmachine::VCmpLeU32VccOp::create(builder, loc, resultType,
                                                  vccType, lhs, rhs)
        .getResult();
  case CmpRelation::Gt:
    return waveamdmachine::VCmpGtU32VccOp::create(builder, loc, resultType,
                                                  vccType, lhs, rhs)
        .getResult();
  case CmpRelation::Ge:
    return waveamdmachine::VCmpGeU32VccOp::create(builder, loc, resultType,
                                                  vccType, lhs, rhs)
        .getResult();
  }
  llvm_unreachable("handled unsigned compare relation");
}

static Value createVCmpI32Vcc(OpBuilder &builder, Location loc,
                              CmpRelation relation, Type resultType,
                              Type vccType, Value lhs, Value rhs) {
  switch (relation) {
  case CmpRelation::Lt:
    return waveamdmachine::VCmpLtI32VccOp::create(builder, loc, resultType,
                                                  vccType, lhs, rhs)
        .getResult();
  case CmpRelation::Le:
    return waveamdmachine::VCmpLeI32VccOp::create(builder, loc, resultType,
                                                  vccType, lhs, rhs)
        .getResult();
  case CmpRelation::Gt:
    return waveamdmachine::VCmpGtI32VccOp::create(builder, loc, resultType,
                                                  vccType, lhs, rhs)
        .getResult();
  case CmpRelation::Ge:
    return waveamdmachine::VCmpGeI32VccOp::create(builder, loc, resultType,
                                                  vccType, lhs, rhs)
        .getResult();
  case CmpRelation::Eq:
  case CmpRelation::Ne:
    llvm_unreachable("signed eq/ne compare uses unsigned compare op");
  }
  llvm_unreachable("handled signed compare relation");
}

static Value createVCmp(OpBuilder &builder, Location loc, CmpRelation relation,
                        bool signedCmp, Type resultType, Value lhs, Value rhs) {
  if (signedCmp)
    return createVCmpI32(builder, loc, relation, resultType, lhs, rhs);
  return createVCmpU32(builder, loc, relation, resultType, lhs, rhs);
}

static Value createVCmpVcc(OpBuilder &builder, Location loc,
                           CmpRelation relation, bool signedCmp,
                           Type resultType, Type vccType, Value lhs,
                           Value rhs) {
  if (signedCmp)
    return createVCmpI32Vcc(builder, loc, relation, resultType, vccType, lhs,
                            rhs);
  return createVCmpU32Vcc(builder, loc, relation, resultType, vccType, lhs,
                          rhs);
}

static bool usesLegacyVCmpVcc(const WaveAMDMachineSelector &selector) {
  return selector.targetIsaMajor && *selector.targetIsaMajor < 10;
}

struct I64Dwords {
  Value lo;
  Value hi;
};

static I64Dwords splitI64Dwords(WaveAMDMachineSelector &S, Location loc,
                                Value value) {
  return {extractLowDword(S, loc, value), extractHighDword(S, loc, value)};
}

static SmallVector<Value, 2> splitMaskWords(WaveAMDMachineSelector &S,
                                            Location loc, Value mask) {
  waveamdmachine::RegType regType =
      cast<waveamdmachine::RegType>(mask.getType());
  assert(regType.getRegClass() == waveamdmachine::RegClass::SGPR &&
         "compare mask must be SGPR");
  assert((regType.getWidth() == 1 || regType.getWidth() == 2) &&
         "compare mask must be SGPR1/2");
  if (regType.getWidth() == 1)
    return {mask};
  Type sgpr1 =
      getRegType(S.builder.getContext(), waveamdmachine::RegClass::SGPR, 1);
  SmallVector<Type, 2> elementTypes(regType.getWidth(), sgpr1);
  auto split = waveamdmachine::TupleToElementsOp::create(S.builder, loc,
                                                         elementTypes, mask);
  SmallVector<Value, 2> words;
  llvm::append_range(words, split.getElements());
  return words;
}

static Value gatherMaskWords(WaveAMDMachineSelector &S, Location loc,
                             ArrayRef<Value> words) {
  if (words.size() == 1)
    return words.front();
  Type resultType = getRegType(S.builder.getContext(),
                               waveamdmachine::RegClass::SGPR, words.size());
  return waveamdmachine::TupleFromElementsOp::create(S.builder, loc, resultType,
                                                     words)
      .getTuple();
}

enum class MaskCombiner { And, Or };

static Value combineMasks(WaveAMDMachineSelector &S, Location loc, Value lhs,
                          Value rhs, MaskCombiner combiner) {
  SmallVector<Value, 2> lhsWords = splitMaskWords(S, loc, lhs);
  SmallVector<Value, 2> rhsWords = splitMaskWords(S, loc, rhs);
  assert(lhsWords.size() == rhsWords.size() && "mask word counts must match");
  Type sgpr1 =
      getRegType(S.builder.getContext(), waveamdmachine::RegClass::SGPR, 1);
  Type scc = getSCCType(S.builder.getContext());
  SmallVector<Value, 2> words;
  for (auto [lhsWord, rhsWord] : llvm::zip_equal(lhsWords, rhsWords)) {
    if (combiner == MaskCombiner::And) {
      words.push_back(waveamdmachine::SAndB32Op::create(S.builder, loc, sgpr1,
                                                        scc, lhsWord, rhsWord)
                          .getResult());
      continue;
    }
    words.push_back(waveamdmachine::SOrB32Op::create(S.builder, loc, sgpr1, scc,
                                                     lhsWord, rhsWord)
                        .getResult());
  }
  return gatherMaskWords(S, loc, words);
}

static Value andMasks(WaveAMDMachineSelector &S, Location loc, Value lhs,
                      Value rhs) {
  return combineMasks(S, loc, lhs, rhs, MaskCombiner::And);
}

static Value orMasks(WaveAMDMachineSelector &S, Location loc, Value lhs,
                     Value rhs) {
  return combineMasks(S, loc, lhs, rhs, MaskCombiner::Or);
}

static Value createWordCmp(WaveAMDMachineSelector &S, Location loc,
                           CmpRelation relation, bool signedCmp,
                           Type resultType, Value lhs, Value rhs) {
  bool legacyVcc = usesLegacyVCmpVcc(S);
  if (legacyVcc) {
    if (isa<waveamdmachine::ImmType>(lhs.getType()))
      lhs = S.materializeSGPR1(loc, lhs);
    if (isa<waveamdmachine::ImmType>(rhs.getType()))
      rhs = S.materializeSGPR1(loc, rhs);
    if (!isVGPR(lhs) && !isVGPR(rhs))
      lhs = S.ensureVGPRForVSrc1(loc, lhs);
    return createVCmpVcc(S.builder, loc, relation, signedCmp, resultType,
                         getVCCType(S.builder.getContext()), lhs, rhs);
  }
  if (isa<waveamdmachine::ImmType>(lhs.getType()) &&
      isa<waveamdmachine::ImmType>(rhs.getType()))
    lhs = S.materializeSGPR1(loc, lhs);
  return createVCmp(S.builder, loc, relation, signedCmp, resultType, lhs, rhs);
}

static CmpRelation strictHighRelation(CmpRelation relation) {
  if (relation == CmpRelation::Le)
    return CmpRelation::Lt;
  if (relation == CmpRelation::Ge)
    return CmpRelation::Gt;
  return relation;
}

static Value createI64EqMask(WaveAMDMachineSelector &S, Location loc,
                             Type resultType, I64Dwords lhs, I64Dwords rhs) {
  Value hiEq =
      createWordCmp(S, loc, CmpRelation::Eq, false, resultType, lhs.hi, rhs.hi);
  Value loEq =
      createWordCmp(S, loc, CmpRelation::Eq, false, resultType, lhs.lo, rhs.lo);
  return andMasks(S, loc, hiEq, loEq);
}

static Value createI64NeMask(WaveAMDMachineSelector &S, Location loc,
                             Type resultType, I64Dwords lhs, I64Dwords rhs) {
  Value hiNe =
      createWordCmp(S, loc, CmpRelation::Ne, false, resultType, lhs.hi, rhs.hi);
  Value loNe =
      createWordCmp(S, loc, CmpRelation::Ne, false, resultType, lhs.lo, rhs.lo);
  return orMasks(S, loc, hiNe, loNe);
}

static Value createI64RelMask(WaveAMDMachineSelector &S, Location loc,
                              CmpRelation relation, bool signedCmp,
                              Type resultType, I64Dwords lhs, I64Dwords rhs) {
  Value hiCmp = createWordCmp(S, loc, strictHighRelation(relation), signedCmp,
                              resultType, lhs.hi, rhs.hi);
  Value hiEq =
      createWordCmp(S, loc, CmpRelation::Eq, false, resultType, lhs.hi, rhs.hi);
  Value loCmp =
      createWordCmp(S, loc, relation, false, resultType, lhs.lo, rhs.lo);
  return orMasks(S, loc, hiCmp, andMasks(S, loc, hiEq, loCmp));
}

static Value createI64Cmp(WaveAMDMachineSelector &S, Location loc,
                          CmpRelation relation, bool signedCmp, Type resultType,
                          Value lhs, Value rhs) {
  I64Dwords lhsDwords = splitI64Dwords(S, loc, lhs);
  I64Dwords rhsDwords = splitI64Dwords(S, loc, rhs);
  if (relation == CmpRelation::Eq)
    return createI64EqMask(S, loc, resultType, lhsDwords, rhsDwords);
  if (relation == CmpRelation::Ne)
    return createI64NeMask(S, loc, resultType, lhsDwords, rhsDwords);
  return createI64RelMask(S, loc, relation, signedCmp, resultType, lhsDwords,
                          rhsDwords);
}

static Value createScalarUnsignedWordCmp(WaveAMDMachineSelector &S,
                                         Location loc, CmpRelation relation,
                                         Type scc, Value lhs, Value rhs) {
  switch (relation) {
  case CmpRelation::Eq:
    return waveamdmachine::SCmpEqU32Op::create(S.builder, loc, scc, lhs, rhs);
  case CmpRelation::Ne:
    return waveamdmachine::SCmpLgU32Op::create(S.builder, loc, scc, lhs, rhs);
  case CmpRelation::Lt:
    return waveamdmachine::SCmpLtU32Op::create(S.builder, loc, scc, lhs, rhs);
  case CmpRelation::Le:
    return waveamdmachine::SCmpLeU32Op::create(S.builder, loc, scc, lhs, rhs);
  case CmpRelation::Gt:
    return waveamdmachine::SCmpGtU32Op::create(S.builder, loc, scc, lhs, rhs);
  case CmpRelation::Ge:
    return waveamdmachine::SCmpGeU32Op::create(S.builder, loc, scc, lhs, rhs);
  }
  llvm_unreachable("handled unsigned scalar compare relation");
}

static Value createScalarSignedWordRelCmp(WaveAMDMachineSelector &S,
                                          Location loc, CmpRelation relation,
                                          Type scc, Value lhs, Value rhs) {
  switch (relation) {
  case CmpRelation::Lt:
    return waveamdmachine::SCmpLtI32Op::create(S.builder, loc, scc, lhs, rhs);
  case CmpRelation::Le:
    return waveamdmachine::SCmpLeI32Op::create(S.builder, loc, scc, lhs, rhs);
  case CmpRelation::Gt:
    return waveamdmachine::SCmpGtI32Op::create(S.builder, loc, scc, lhs, rhs);
  case CmpRelation::Ge:
    return waveamdmachine::SCmpGeI32Op::create(S.builder, loc, scc, lhs, rhs);
  case CmpRelation::Eq:
  case CmpRelation::Ne:
    llvm_unreachable("signed eq/ne uses unsigned compare");
  }
  llvm_unreachable("handled signed scalar compare relation");
}

static bool isEqualityCmp(CmpRelation relation) {
  return relation == CmpRelation::Eq || relation == CmpRelation::Ne;
}

static Value createScalarWordCmp(WaveAMDMachineSelector &S, Location loc,
                                 CmpRelation relation, bool signedCmp,
                                 Value lhs, Value rhs) {
  lhs = S.ensureSGPR1(loc, lhs);
  rhs = S.ensureSGPR1(loc, rhs);
  if (isImm(lhs) && isImm(rhs))
    lhs = S.materializeSGPR1(loc, lhs);
  Type scc = getSCCType(S.builder.getContext());
  if (signedCmp && !isEqualityCmp(relation))
    return createScalarSignedWordRelCmp(S, loc, relation, scc, lhs, rhs);
  return createScalarUnsignedWordCmp(S, loc, relation, scc, lhs, rhs);
}

static Value materializeSCCBool(WaveAMDMachineSelector &S, Location loc,
                                Value scc) {
  Type sgpr1 =
      getRegType(S.builder.getContext(), waveamdmachine::RegClass::SGPR, 1);
  Value one = S.materializeSGPR1(loc, createImm(S.builder, loc, 1));
  Value zero = createImm(S.builder, loc, 0);
  return waveamdmachine::SCSelectB32Op::create(S.builder, loc, sgpr1, scc, one,
                                               zero)
      .getResult();
}

static Value boolToSCC(WaveAMDMachineSelector &S, Location loc, Value value) {
  if (isa<waveamdmachine::ImmType>(value.getType()))
    value = S.materializeSGPR1(loc, value);
  return waveamdmachine::SCmpLgU32Op::create(
             S.builder, loc, getSCCType(S.builder.getContext()), value,
             createImm(S.builder, loc, 0))
      .getResult();
}

static Value combineScalarBools(WaveAMDMachineSelector &S, Location loc,
                                Value lhs, Value rhs, MaskCombiner combiner) {
  Type sgpr1 =
      getRegType(S.builder.getContext(), waveamdmachine::RegClass::SGPR, 1);
  Type scc = getSCCType(S.builder.getContext());
  if (combiner == MaskCombiner::And)
    return waveamdmachine::SAndB32Op::create(S.builder, loc, sgpr1, scc, lhs,
                                             rhs)
        .getResult();
  return waveamdmachine::SOrB32Op::create(S.builder, loc, sgpr1, scc, lhs, rhs)
      .getResult();
}

static Value createScalarI64Cmp(WaveAMDMachineSelector &S, Location loc,
                                CmpRelation relation, bool signedCmp, Value lhs,
                                Value rhs) {
  I64Dwords lhsDwords = splitI64Dwords(S, loc, lhs);
  I64Dwords rhsDwords = splitI64Dwords(S, loc, rhs);
  if (relation == CmpRelation::Eq || relation == CmpRelation::Ne) {
    Value hi =
        materializeSCCBool(S, loc,
                           createScalarWordCmp(S, loc, relation, false,
                                               lhsDwords.hi, rhsDwords.hi));
    Value lo =
        materializeSCCBool(S, loc,
                           createScalarWordCmp(S, loc, relation, false,
                                               lhsDwords.lo, rhsDwords.lo));
    MaskCombiner combiner =
        relation == CmpRelation::Eq ? MaskCombiner::And : MaskCombiner::Or;
    return boolToSCC(S, loc, combineScalarBools(S, loc, hi, lo, combiner));
  }
  Value hiCmp = materializeSCCBool(
      S, loc,
      createScalarWordCmp(S, loc, strictHighRelation(relation), signedCmp,
                          lhsDwords.hi, rhsDwords.hi));
  Value hiEq =
      materializeSCCBool(S, loc,
                         createScalarWordCmp(S, loc, CmpRelation::Eq, false,
                                             lhsDwords.hi, rhsDwords.hi));
  Value loCmp = materializeSCCBool(
      S, loc,
      createScalarWordCmp(S, loc, relation, false, lhsDwords.lo, rhsDwords.lo));
  Value tail = combineScalarBools(S, loc, hiEq, loCmp, MaskCombiner::And);
  return boolToSCC(S, loc,
                   combineScalarBools(S, loc, hiCmp, tail, MaskCombiner::Or));
}

LogicalResult WaveAMDMachineSelector::selectArithCmp(arith::CmpIOp op) {
  Type operandType = op.getLhs().getType();
  IntegerType integerType = dyn_cast<IntegerType>(operandType);
  if (!operandType.isIndex() && !integerType)
    return op.emitError(
        "WaveAMDMachine backend supports only scalar integer/index arith.cmpi");
  unsigned bits = operandType.isIndex() ? 64 : integerType.getWidth();
  if (bits != 32 && bits != 64)
    return op.emitError(
        "WaveAMDMachine backend supports only scalar i32/i64/index arith.cmpi");
  arith::CmpIPredicate predicate = op.getPredicate();
  std::optional<CmpRelation> relation = getCmpRelation(predicate);
  if (!relation)
    return op.emitError("unsupported arith.cmpi predicate");
  bool signedCmp = isSignedCmpPredicate(predicate);
  Value lhs = expect(op.getLhs(), op);
  Value rhs = expect(op.getRhs(), op);
  Value scc = bits == 64 ? createScalarI64Cmp(*this, op.getLoc(), *relation,
                                              signedCmp, lhs, rhs)
                         : createScalarWordCmp(*this, op.getLoc(), *relation,
                                               signedCmp, lhs, rhs);
  values[op.getResult()] = materializeSCCBool(*this, op.getLoc(), scc);
  eraseIfTopLevel(op);
  return success();
}

LogicalResult WaveAMDMachineSelector::selectCmp(CmpIOp op) {
  auto simdType = cast<SimdType>(op.getLhs().getType());
  IntegerType elementType = dyn_cast<IntegerType>(simdType.getElementType());
  if (!elementType ||
      (elementType.getWidth() != 32 && elementType.getWidth() != 64))
    return op.emitError(
        "WaveAMDMachine backend supports only !wave.simd<i32/i64, W> cmpi "
        "operands");
  auto maskType = cast<MaskType>(op.getType());
  if (maskType.getWidth() != 32 && maskType.getWidth() != 64)
    return op.emitError(
        "WaveAMDMachine backend supports only !wave.mask<32/64>");
  arith::CmpIPredicate predicate = op.getPredicate();
  std::optional<CmpRelation> relation = getCmpRelation(predicate);
  if (!relation)
    return op.emitError("unsupported wave.cmpi predicate");
  bool signedCmp = isSignedCmpPredicate(predicate);
  Type sgprType = getRegType(op.getContext(), waveamdmachine::RegClass::SGPR,
                             maskType.getWidth() / 32);
  Value lhs = expect(op.getLhs(), op);
  Value rhs = expect(op.getRhs(), op);
  Value result = elementType.getWidth() == 64
                     ? createI64Cmp(*this, op.getLoc(), *relation, signedCmp,
                                    sgprType, lhs, rhs)
                     : createWordCmp(*this, op.getLoc(), *relation, signedCmp,
                                     sgprType, lhs, rhs);
  values[op.getResult()] = result;
  eraseIfTopLevel(op);
  return success();
}

static bool isMachineImm(Value value) {
  return isa<waveamdmachine::ImmType>(value.getType());
}

static FailureOr<unsigned> getMachineWordWidth(Operation *op, Value value) {
  if (auto regType = dyn_cast<waveamdmachine::RegType>(value.getType()))
    return regType.getWidth();
  if (isMachineImm(value))
    return 1;
  op->emitError("select source must be a machine register or immediate");
  return failure();
}

static FailureOr<SmallVector<Value, 2>>
splitSGPRWords(WaveAMDMachineSelector &S, Operation *op, Value value,
               unsigned width) {
  if (width == 1)
    return SmallVector<Value, 2>{S.ensureSGPR1(op->getLoc(), value)};
  if (width == 2 && isMachineImm(value))
    value = ensureSGPR2(S, op->getLoc(), value);
  auto regType = dyn_cast<waveamdmachine::RegType>(value.getType());
  if (!regType || regType.getRegClass() != waveamdmachine::RegClass::SGPR ||
      regType.getWidth() != width)
    return op->emitError("wide scalar select source must be an SGPR tuple");
  Type sgpr1 = getRegType(op->getContext(), waveamdmachine::RegClass::SGPR, 1);
  SmallVector<Type, 2> elementTypes(width, sgpr1);
  auto split = waveamdmachine::TupleToElementsOp::create(
      S.builder, op->getLoc(), elementTypes, value);
  SmallVector<Value, 2> elements;
  llvm::append_range(elements, split.getElements());
  return elements;
}

static Value gatherSGPRWords(WaveAMDMachineSelector &S, Location loc,
                             ArrayRef<Value> words) {
  if (words.size() == 1)
    return words.front();
  Type resultType = getRegType(S.builder.getContext(),
                               waveamdmachine::RegClass::SGPR, words.size());
  return waveamdmachine::TupleFromElementsOp::create(S.builder, loc, resultType,
                                                     words)
      .getTuple();
}

static Value createSCCFromI1(WaveAMDMachineSelector &S, SelectOp op) {
  Value condition = S.expect(op.getCondition(), op);
  if (auto rt = dyn_cast<waveamdmachine::RegType>(condition.getType()))
    if (rt.getRegClass() == waveamdmachine::RegClass::SCC)
      return condition;
  condition = S.ensureSGPR1(op.getLoc(), condition);
  return waveamdmachine::SCmpLgU32Op::create(
             S.builder, op.getLoc(), getSCCType(op.getContext()), condition,
             createImm(S.builder, op.getLoc(), 0))
      .getResult();
}

static FailureOr<Value> createScalarSelect(WaveAMDMachineSelector &S,
                                           Operation *op, Value scc,
                                           Value trueValue, Value falseValue,
                                           unsigned width) {
  FailureOr<SmallVector<Value, 2>> trueWords =
      splitSGPRWords(S, op, trueValue, width);
  FailureOr<SmallVector<Value, 2>> falseWords =
      splitSGPRWords(S, op, falseValue, width);
  if (failed(trueWords) || failed(falseWords))
    return failure();
  SmallVector<Value, 2> resultWords;
  Type sgpr1 = getRegType(op->getContext(), waveamdmachine::RegClass::SGPR, 1);
  for (auto [trueWord, falseWord] : llvm::zip_equal(*trueWords, *falseWords)) {
    if (isMachineImm(trueWord) && isMachineImm(falseWord))
      trueWord = S.materializeSGPR1(op->getLoc(), trueWord);
    resultWords.push_back(
        waveamdmachine::SCSelectB32Op::create(S.builder, op->getLoc(), sgpr1,
                                              scc, trueWord, falseWord)
            .getResult());
  }
  return gatherSGPRWords(S, op->getLoc(), resultWords);
}

static FailureOr<Value> createFullMaskFromSCC(WaveAMDMachineSelector &S,
                                              Operation *op, Value scc,
                                              unsigned width) {
  return createScalarSelect(S, op, scc, createImm(S.builder, op->getLoc(), -1),
                            createImm(S.builder, op->getLoc(), 0), width);
}

static FailureOr<Value> ensureLaneSelectVGPR(WaveAMDMachineSelector &S,
                                             Operation *op, Value value,
                                             unsigned width) {
  Type resultType =
      getRegType(op->getContext(), waveamdmachine::RegClass::VGPR, width);
  waveamdmachine::RegType regType =
      dyn_cast<waveamdmachine::RegType>(value.getType());
  if (!regType) {
    if (!isMachineImm(value))
      return op->emitError("lane select source must be register or immediate");
    return waveamdmachine::VMovB32TupleOp::create(S.builder, op->getLoc(),
                                                  resultType, value)
        .getResult();
  }

  if (regType.getRegClass() == waveamdmachine::RegClass::VGPR &&
      regType.getWidth() == width)
    return value;
  if (regType.getRegClass() == waveamdmachine::RegClass::SGPR &&
      regType.getWidth() == width)
    return waveamdmachine::VMovB32TupleOp::create(S.builder, op->getLoc(),
                                                  resultType, value)
        .getResult();
  return op->emitError("lane select source width/register class mismatch");
}

static FailureOr<Value> createLaneSelect(WaveAMDMachineSelector &S,
                                         Operation *op, Value condition,
                                         Value trueValue, Value falseValue,
                                         unsigned width) {
  FailureOr<Value> falseVGPR = ensureLaneSelectVGPR(S, op, falseValue, width);
  FailureOr<Value> trueVGPR = ensureLaneSelectVGPR(S, op, trueValue, width);
  if (failed(falseVGPR) || failed(trueVGPR))
    return failure();
  Type resultType =
      getRegType(op->getContext(), waveamdmachine::RegClass::VGPR, width);
  return waveamdmachine::VCndmaskB32TupleOp::create(S.builder, op->getLoc(),
                                                    resultType, *falseVGPR,
                                                    *trueVGPR, condition)
      .getResult();
}

static FailureOr<Value> createMaskSelect(WaveAMDMachineSelector &S, SelectOp op,
                                         Value condition, Value trueValue,
                                         Value falseValue, unsigned width) {
  FailureOr<SmallVector<Value, 2>> condWords =
      splitSGPRWords(S, op, condition, width);
  FailureOr<SmallVector<Value, 2>> trueWords =
      splitSGPRWords(S, op, trueValue, width);
  FailureOr<SmallVector<Value, 2>> falseWords =
      splitSGPRWords(S, op, falseValue, width);
  if (failed(condWords) || failed(trueWords) || failed(falseWords))
    return failure();
  SmallVector<Value, 2> resultWords;
  Type sgpr1 = getRegType(op.getContext(), waveamdmachine::RegClass::SGPR, 1);
  Type scc = getSCCType(op.getContext());
  for (auto [condWord, trueWord, falseWord] :
       llvm::zip_equal(*condWords, *trueWords, *falseWords)) {
    Value diff = waveamdmachine::SXorB32Op::create(
                     S.builder, op.getLoc(), sgpr1, scc, trueWord, falseWord)
                     .getResult();
    Value selectedDiff = waveamdmachine::SAndB32Op::create(
                             S.builder, op.getLoc(), sgpr1, scc, condWord, diff)
                             .getResult();
    resultWords.push_back(
        waveamdmachine::SXorB32Op::create(S.builder, op.getLoc(), sgpr1, scc,
                                          falseWord, selectedDiff)
            .getResult());
  }
  return gatherSGPRWords(S, op.getLoc(), resultWords);
}

static FailureOr<Value>
materializePointerSelectOffsetWideVGPR(WaveAMDMachineSelector &S, SelectOp op,
                                       const PointerOffset &offset) {
  Value value;
  if (offset.expr) {
    SmallVector<std::pair<std::string, Value>, 4> bindings;
    for (const PointerOffsetBinding &binding : offset.bindings)
      bindings.push_back({binding.name, S.expect(binding.value, op)});
    FailureOr<Value> wide = materializeWideIndexExprNode(
        S, offset.expr, op, bindings, offset.assumptions);
    if (failed(wide))
      return failure();
    value = *wide;
  } else {
    value = createWideImm(S, op.getLoc(), 0);
  }
  return ensureVGPR2(S, op.getLoc(), value);
}

static FailureOr<Value>
materializePointerSelectOffset(WaveAMDMachineSelector &S, SelectOp op,
                               const PointerOffset &offset, TermKind kind,
                               bool offsetFitsU32) {
  if (kind == TermKind::Lane) {
    if (offsetFitsU32)
      return materializePointerOffsetVGPR(S, op.getOperation(), offset);
    return materializePointerSelectOffsetWideVGPR(S, op, offset);
  }
  if (offsetFitsU32)
    return materializeUniformPointerOffsetCarry(S, op.getOperation(), offset);
  FailureOr<Value> value =
      materializePointerOffsetValue(S, op.getOperation(), offset);
  if (failed(value))
    return failure();
  return ensureSGPR2(S, op.getLoc(), *value);
}

struct PointerSelectMetadata {
  Value base;
  Value globalBase;
  PointerOffset offset;
  bool isBuffer = false;
};

static FailureOr<PointerSelectMetadata>
lookupPointerSelectMetadata(WaveAMDMachineSelector &S, SelectOp op,
                            Value pointer, StringRef arm) {
  auto baseIt = S.pointerBases.find(pointer);
  auto offsetIt = S.pointerIndexOffsets.find(pointer);
  if (baseIt == S.pointerBases.end() || offsetIt == S.pointerIndexOffsets.end())
    return op.emitError(arm) << " pointer is missing address metadata";
  return PointerSelectMetadata{
      baseIt->second, S.pointerGlobalBases.lookup(pointer), offsetIt->second,
      S.pointerBuffers.lookup(pointer)};
}

static bool pointerSelectOffsetFitsU32(WaveAMDMachineSelector &S,
                                       const PointerOffset &offset) {
  return !offset.expr || S.slotFitsU32(offset.expr, offset.assumptions);
}

static LogicalResult requireSamePointerSelectBase(SelectOp op, Value lhs,
                                                  Value rhs, StringRef name) {
  if (lhs == rhs)
    return success();
  return op.emitError("lane pointer select requires matching ") << name;
}

static FailureOr<Value>
createUniformPointerBaseSelect(WaveAMDMachineSelector &S, SelectOp op,
                               Value scc, Value trueBase, Value falseBase) {
  if (trueBase == falseBase)
    return trueBase;
  FailureOr<unsigned> trueWidth = getMachineWordWidth(op, trueBase);
  FailureOr<unsigned> falseWidth = getMachineWordWidth(op, falseBase);
  if (failed(trueWidth) || failed(falseWidth))
    return failure();
  if (*trueWidth != *falseWidth) {
    op.emitError("pointer select base width mismatch");
    return failure();
  }
  return createScalarSelect(S, op, scc, trueBase, falseBase, *trueWidth);
}

static LogicalResult addSelectedPointerOffset(WaveAMDMachineSelector &S,
                                              SelectOp op,
                                              PointerOffset &offset,
                                              Value selected, TermKind kind,
                                              bool offsetFitsU32) {
  std::string name = (Twine("__wave_select_ptr_") + Twine(S.nextLabel++)).str();
  FailureOr<sym::ExprHandle> expr = sym::composeExprSym(S.symbolStore(), name);
  if (failed(expr))
    return op.emitError("failed to compose wave.select pointer offset");
  offset.expr = *expr;
  offset.bindings.push_back({name, selected, kind});
  if (!offsetFitsU32) {
    S.values[selected] = selected;
    return success();
  }
  FailureOr<sym::PredHandle> range =
      sym::rangeAssumption(S.symbolStore(), name, 0, (int64_t{1} << 32) - 1);
  if (failed(range))
    return op.emitError("failed to compose wave.select pointer offset range");
  offset.assumptions.push_back(*range);
  S.values[selected] = selected;
  return success();
}

struct PointerSelectCondition {
  Value laneCondition;
  Value scc;
};

static FailureOr<PointerSelectCondition>
buildPointerSelectCondition(WaveAMDMachineSelector &S, SelectOp op,
                            bool maskCondition, bool resultIsLane,
                            const PointerSelectMetadata &trueMetadata,
                            const PointerSelectMetadata &falseMetadata) {
  if (maskCondition) {
    if (failed(requireSamePointerSelectBase(
            op, trueMetadata.base, falseMetadata.base, "pointer bases")) ||
        failed(requireSamePointerSelectBase(op, trueMetadata.globalBase,
                                            falseMetadata.globalBase,
                                            "global bases")))
      return failure();
    return PointerSelectCondition{S.expect(op.getCondition(), op), Value()};
  }

  Value scc = createSCCFromI1(S, op);
  Value condition;
  if (resultIsLane) {
    unsigned maskWidth = cast<SimdType>(op.getType()).getWidth() / 32;
    FailureOr<Value> fullMask = createFullMaskFromSCC(S, op, scc, maskWidth);
    if (failed(fullMask))
      return failure();
    condition = *fullMask;
  }
  return PointerSelectCondition{condition, scc};
}

struct PointerSelectBase {
  Value base;
  Value globalBase;
};

static FailureOr<PointerSelectBase>
selectPointerBases(WaveAMDMachineSelector &S, SelectOp op, bool maskCondition,
                   Value scc, const PointerSelectMetadata &trueMetadata,
                   const PointerSelectMetadata &falseMetadata) {
  if (maskCondition)
    return PointerSelectBase{trueMetadata.base, trueMetadata.globalBase};

  FailureOr<Value> selectedBase = createUniformPointerBaseSelect(
      S, op, scc, trueMetadata.base, falseMetadata.base);
  if (failed(selectedBase))
    return failure();

  Value globalBase = trueMetadata.globalBase;
  if (trueMetadata.globalBase || falseMetadata.globalBase) {
    if (!trueMetadata.globalBase || !falseMetadata.globalBase) {
      op.emitError("pointer select requires matching global bases");
      return failure();
    }
    FailureOr<Value> selectedGlobalBase = createUniformPointerBaseSelect(
        S, op, scc, trueMetadata.globalBase, falseMetadata.globalBase);
    if (failed(selectedGlobalBase))
      return failure();
    globalBase = *selectedGlobalBase;
  }
  return PointerSelectBase{*selectedBase, globalBase};
}

static FailureOr<Value> selectPointerOffset(
    WaveAMDMachineSelector &S, SelectOp op, TermKind kind, Value laneCondition,
    Value scc, const PointerSelectMetadata &trueMetadata,
    const PointerSelectMetadata &falseMetadata, bool offsetFitsU32) {
  FailureOr<Value> trueOffset = materializePointerSelectOffset(
      S, op, trueMetadata.offset, kind, offsetFitsU32);
  FailureOr<Value> falseOffset = materializePointerSelectOffset(
      S, op, falseMetadata.offset, kind, offsetFitsU32);
  if (failed(trueOffset) || failed(falseOffset))
    return failure();

  FailureOr<unsigned> trueWidth = getMachineWordWidth(op, *trueOffset);
  FailureOr<unsigned> falseWidth = getMachineWordWidth(op, *falseOffset);
  if (failed(trueWidth) || failed(falseWidth))
    return failure();
  if (*trueWidth != *falseWidth) {
    op.emitError("pointer select offset width mismatch");
    return failure();
  }

  if (kind == TermKind::Lane)
    return createLaneSelect(S, op, laneCondition, *trueOffset, *falseOffset,
                            *trueWidth);
  return createScalarSelect(S, op, scc, *trueOffset, *falseOffset, *trueWidth);
}

static LogicalResult bindSelectedPointer(WaveAMDMachineSelector &S, SelectOp op,
                                         const PointerSelectBase &base,
                                         const PointerSelectMetadata &metadata,
                                         TermKind offsetKind,
                                         Value selectedOffset,
                                         bool offsetFitsU32) {
  PointerOffset offset;
  if (failed(addSelectedPointerOffset(S, op, offset, selectedOffset, offsetKind,
                                      offsetFitsU32)))
    return failure();
  Value result = op.getResult();
  S.values[result] = base.base;
  S.pointerBases[result] = base.base;
  if (base.globalBase)
    S.pointerGlobalBases[result] = base.globalBase;
  S.pointerIndexOffsets[result] = std::move(offset);
  S.pointerBuffers[result] = metadata.isBuffer;
  return success();
}

static LogicalResult selectPointer(WaveAMDMachineSelector &S, SelectOp op,
                                   bool maskCondition) {
  FailureOr<PointerSelectMetadata> trueMetadata =
      lookupPointerSelectMetadata(S, op, op.getTrueValue(), "true");
  FailureOr<PointerSelectMetadata> falseMetadata =
      lookupPointerSelectMetadata(S, op, op.getFalseValue(), "false");
  if (failed(trueMetadata) || failed(falseMetadata))
    return failure();
  if (trueMetadata->isBuffer != falseMetadata->isBuffer)
    return op.emitError("pointer select requires matching pointer kinds");

  bool resultIsLane = isa<SimdType>(op.getType());
  TermKind offsetKind = resultIsLane ? TermKind::Lane : TermKind::Uniform;
  FailureOr<PointerSelectCondition> condition = buildPointerSelectCondition(
      S, op, maskCondition, resultIsLane, *trueMetadata, *falseMetadata);
  if (failed(condition))
    return failure();

  FailureOr<PointerSelectBase> base = selectPointerBases(
      S, op, maskCondition, condition->scc, *trueMetadata, *falseMetadata);
  if (failed(base))
    return failure();

  bool offsetFitsU32 = pointerSelectOffsetFitsU32(S, trueMetadata->offset) &&
                       pointerSelectOffsetFitsU32(S, falseMetadata->offset);
  FailureOr<Value> selectedOffset = selectPointerOffset(
      S, op, offsetKind, condition->laneCondition, condition->scc,
      *trueMetadata, *falseMetadata, offsetFitsU32);
  if (failed(selectedOffset))
    return failure();

  return bindSelectedPointer(S, op, *base, *trueMetadata, offsetKind,
                             *selectedOffset, offsetFitsU32);
}

static LogicalResult selectMaskValue(WaveAMDMachineSelector &S, SelectOp op,
                                     bool maskCondition, Value trueValue,
                                     Value falseValue, MaskType resultType) {
  unsigned width = resultType.getWidth() / 32;
  FailureOr<Value> selected =
      maskCondition ? createMaskSelect(S, op, S.expect(op.getCondition(), op),
                                       trueValue, falseValue, width)
                    : createScalarSelect(S, op, createSCCFromI1(S, op),
                                         trueValue, falseValue, width);
  if (failed(selected))
    return failure();
  S.values[op.getResult()] = *selected;
  return success();
}

static LogicalResult selectRegisterValue(WaveAMDMachineSelector &S, SelectOp op,
                                         bool maskCondition, Value trueValue,
                                         Value falseValue, Type resultType) {
  FailureOr<unsigned> width =
      getRegisterPayloadWidth(resultType, [&]() { return op.emitError(); });
  if (failed(width))
    return failure();
  if (maskCondition) {
    FailureOr<Value> selected = createLaneSelect(
        S, op, S.expect(op.getCondition(), op), trueValue, falseValue, *width);
    if (failed(selected))
      return failure();
    S.values[op.getResult()] = *selected;
    return success();
  }

  Value scc = createSCCFromI1(S, op);
  if (isa<SimdType>(resultType)) {
    unsigned maskWidth = cast<SimdType>(resultType).getWidth() / 32;
    FailureOr<Value> condition = createFullMaskFromSCC(S, op, scc, maskWidth);
    if (failed(condition))
      return failure();
    FailureOr<Value> selected =
        createLaneSelect(S, op, *condition, trueValue, falseValue, *width);
    if (failed(selected))
      return failure();
    S.values[op.getResult()] = *selected;
  } else {
    FailureOr<Value> selected =
        createScalarSelect(S, op, scc, trueValue, falseValue, *width);
    if (failed(selected))
      return failure();
    S.values[op.getResult()] = *selected;
  }
  return success();
}

LogicalResult WaveAMDMachineSelector::selectSelect(SelectOp op) {
  bool maskCondition = isa<MaskType>(op.getCondition().getType());
  Type resultType = op.getType();
  if (isWavePointerLikeType(resultType)) {
    if (failed(selectPointer(*this, op, maskCondition)))
      return failure();
    eraseIfTopLevel(op);
    return success();
  }

  Value trueValue = expect(op.getTrueValue(), op);
  Value falseValue = expect(op.getFalseValue(), op);
  LogicalResult result =
      llvm::TypeSwitch<Type, LogicalResult>(resultType)
          .Case<MaskType>([&](MaskType maskType) {
            return selectMaskValue(*this, op, maskCondition, trueValue,
                                   falseValue, maskType);
          })
          .Default([&](Type type) {
            return selectRegisterValue(*this, op, maskCondition, trueValue,
                                       falseValue, type);
          });
  if (failed(result))
    return failure();
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
  if (auto ptr = dyn_cast<PtrType>(type)) {
    if (!ptr.getElementType())
      return 1;
    type = ptr.getElementType();
  }
  if (auto simd = dyn_cast<SimdType>(type)) {
    auto ptr = cast<PtrType>(simd.getElementType());
    if (!ptr.getElementType())
      return 1;
    type = ptr.getElementType();
  }
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
    return createImm(
        builder, loc,
        static_cast<int64_t>(static_cast<uint32_t>(*imm) >> log2Den));
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

static bool isIndexValueType(Type type) {
  if (auto simd = dyn_cast<SimdType>(type))
    type = simd.getElementType();
  return type.isIndex();
}

static bool needsWideIndexExprValue(WaveAMDMachineSelector &S, IndexExprOp op,
                                    const PointerOffset &offset) {
  return offset.expr && isIndexValueType(op.getResult().getType()) &&
         !S.slotFitsU32(offset.expr, offset.assumptions);
}

LogicalResult WaveAMDMachineSelector::selectIndexExpr(IndexExprOp op) {
  FailureOr<PointerOffset> pointerOffset = makePointerOffset(*this, op);
  if (failed(pointerOffset))
    return failure();
  bool needsValue =
      llvm::any_of(op.getResult().getUsers(),
                   [](Operation *user) { return !isa<PtrAddOp>(user); });
  indexOffsets[op.getResult()] = *pointerOffset;
  if (needsValue) {
    FailureOr<Value> value =
        needsWideIndexExprValue(*this, op, *pointerOffset)
            ? materializePointerOffsetWideValue(*this, op, *pointerOffset)
            : materializePointerOffsetValue(*this, op, *pointerOffset);
    if (failed(value))
      return failure();
    values[op.getResult()] = *value;
  }
  eraseIfTopLevel(op);
  return success();
}

static TermKind convertBindingKind(SymbolicOffsetBindingKind kind) {
  if (kind == SymbolicOffsetBindingKind::Uniform)
    return TermKind::Uniform;
  return TermKind::Lane;
}

FailureOr<PointerOffset> makePointerOffset(WaveAMDMachineSelector &S,
                                           const SymbolicOffset &offset) {
  PointerOffset pointerOffset;
  pointerOffset.assumptions = offset.assumptions;
  pointerOffset.expr = offset.expr;
  for (const SymbolicOffsetBinding &binding : offset.bindings) {
    StringRef name = sym::ExprView(binding.name).getSymbolName();
    if (name.empty())
      return failure();
    pointerOffset.bindings.push_back(
        {name.str(), binding.value, convertBindingKind(binding.kind)});
    S.appendBindingAssumptions(binding.value, name, pointerOffset.assumptions);
  }
  if (!pointerOffset.expr)
    return pointerOffset;
  FailureOr<sym::ExprHandle> simplified = sym::simplifyExpr(
      S.symbolStore(), pointerOffset.expr, pointerOffset.assumptions);
  pointerOffset.expr = succeeded(simplified) ? *simplified : pointerOffset.expr;
  return pointerOffset;
}

FailureOr<PointerOffset> makePointerOffset(WaveAMDMachineSelector &S,
                                           IndexExprOp op) {
  FailureOr<SymbolicOffset> offset = getIndexExprSymbolicOffset(op);
  if (failed(offset))
    return failure();
  FailureOr<PointerOffset> pointerOffset = makePointerOffset(S, *offset);
  if (failed(pointerOffset))
    return op.emitError("failed to build symbolic pointer offset");
  return pointerOffset;
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
  S.appendBindingAssumptions(source, name, offset.assumptions, size);
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

LogicalResult WaveAMDMachineSelector::selectPtrCast(PtrCastOp op) {
  auto baseIt = pointerBases.find(op.getSource());
  auto offsetIt = pointerIndexOffsets.find(op.getSource());
  if (baseIt == pointerBases.end() || offsetIt == pointerIndexOffsets.end())
    return op.emitError(
        "WaveAMDMachine backend expects selected source pointer");

  Value baseValue = baseIt->second;
  Value globalBase = pointerGlobalBases.lookup(op.getSource());
  PointerOffset offset = offsetIt->second;
  bool isBuffer = pointerBuffers.lookup(op.getSource());
  pointerBases[op.getResult()] = baseValue;
  if (globalBase)
    pointerGlobalBases[op.getResult()] = globalBase;
  pointerIndexOffsets[op.getResult()] = std::move(offset);
  pointerBuffers[op.getResult()] = isBuffer;
  values[op.getResult()] = baseValue;
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
  if (baseOffset.expr &&
      classifyPointerOffset(*this, baseOffset) != TermKind::Lane) {
    FailureOr<Value> offset =
        materializePointerOffsetValue(*this, op.getOperation(), baseOffset);
    if (failed(offset))
      return failure();
    if (slotFitsU32(baseOffset.expr, baseOffset.assumptions))
      baseValue = addWideU32(*this, op.getLoc(), baseValue, *offset);
    else
      baseValue = addWide(*this, op.getLoc(), baseValue, *offset);
    globalBase = baseValue;
    baseOffset = {};
  }
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
  if (failed(requireMmaTarget(op.getOperation(), kind, mmaKind, *isa)))
    return failure();
  auto resultType = cast<waveamd::FragmentType>(op.getResult().getType());
  Type vgprTuple = getRegType(op.getContext(), waveamdmachine::RegClass::VGPR,
                              resultType.getRegisters());
  Value a = expect(op.getA(), op);
  Value b = expect(op.getB(), op);
  Value acc = expect(op.getAcc(), op);
  Value result =
      createMachineMma(mmaKind, builder, op.getLoc(), vgprTuple, a, b, acc);
  if (!result)
    return op.emitError("unsupported WaveAMDMachine matrix operation kind");
  values[op.getResult()] = result;
  eraseIfTopLevel(op);
  return success();
}

LogicalResult WaveAMDMachineSelector::selectMmaScale(waveamd::MmaScaleOp op) {
  MmaKind mmaKind = parseMmaKind(op.getKind());
  if (mmaKind != MmaKind::MfmaScaleF32_16x16x128_F4F4)
    return op.emitError("unsupported WaveAMDMachine scaled matrix operation "
                        "kind");
  FailureOr<llvm::AMDGPU::IsaVersion> isa =
      getTargetIsaVersion(op, "scaled matrix lowering");
  if (failed(isa))
    return failure();
  if (failed(requireMmaTarget(op.getOperation(), op.getKind(), mmaKind, *isa)))
    return failure();

  waveamd::FragmentType resultType =
      cast<waveamd::FragmentType>(op.getResult().getType());
  Type vgprTuple = getRegType(op.getContext(), waveamdmachine::RegClass::VGPR,
                              resultType.getRegisters());
  DenseMap<Value, Value> splitScaleElements;
  auto getScale = [&](Value scale) -> Value {
    Value raw = expect(scale, op);
    SimdType simdType = cast<SimdType>(scale.getType());
    VectorType vecType = dyn_cast<VectorType>(simdType.getElementType());
    if (!vecType)
      return ensureVGPRForVSrc1(op.getLoc(), raw);
    waveamdmachine::RegType rawType =
        cast<waveamdmachine::RegType>(raw.getType());
    if (rawType.getRegClass() != waveamdmachine::RegClass::VGPR)
      return ensureVGPRForVSrc1(op.getLoc(), raw);
    if (Value element = splitScaleElements.lookup(raw))
      return element;
    Type vgpr1 = getRegType(op.getContext(), waveamdmachine::RegClass::VGPR);
    SmallVector<Type, 4> elementTypes(rawType.getWidth(), vgpr1);
    waveamdmachine::TupleToElementsOp split =
        waveamdmachine::TupleToElementsOp::create(builder, op.getLoc(),
                                                  elementTypes, raw);
    Value element = split.getElements().front();
    splitScaleElements[raw] = element;
    return element;
  };
  Value result = waveamdmachine::MfmaScaleF32_16x16x128_F4F4Op::create(
                     builder, op.getLoc(), vgprTuple, expect(op.getA(), op),
                     expect(op.getB(), op), expect(op.getAcc(), op),
                     getScale(op.getAScale()), getScale(op.getBScale()),
                     op.getScaleIdxA(), op.getScaleIdxB())
                     .getResult();
  values[op.getResult()] = result;
  eraseIfTopLevel(op);
  return success();
}

static FailureOr<WaveAMDMachineSelector::BucketedOperands>
materializeLdsAddress(WaveAMDMachineSelector &S, Operation *op,
                      const PointerOffset &offset,
                      waveamdmachine::AddressFieldSpec spec) {
  FailureOr<AddressPlan> plan = planMemoryAddress(S, op, offset, spec);
  if (failed(plan))
    return failure();
  if (plan->fullAddressRemainderExpr)
    return op->emitError("LDS memory op offset exceeds address fields");
  return materializePlanBuckets(S, op, *plan, spec);
}

static FailureOr<std::pair<Value, PointerOffset>>
lookupLdsPointer(WaveAMDMachineSelector &S, Value ptr, Operation *op) {
  auto baseIt = S.pointerBases.find(ptr);
  auto offsetIt = S.pointerIndexOffsets.find(ptr);
  if (baseIt == S.pointerBases.end() || offsetIt == S.pointerIndexOffsets.end())
    return op->emitError("WaveAMDMachine backend expects selected LDS pointer");
  return std::make_pair(baseIt->second, offsetIt->second);
}

static LogicalResult selectDsReadTr(WaveAMDMachineSelector &S, Operation *op,
                                    Value source, Value dependency,
                                    Value valueResult, Value tokenResult) {
  FailureOr<std::pair<Value, PointerOffset>> ptr =
      lookupLdsPointer(S, source, op);
  if (failed(ptr))
    return failure();
  SimdType simdType = cast<SimdType>(valueResult.getType());
  VectorType vectorType = cast<VectorType>(simdType.getElementType());
  bool useB8Op = vectorType.getElementType().isInteger(8);
  FailureOr<llvm::AMDGPU::IsaVersion> isa =
      getTargetIsaVersion(op, "transpose load lowering");
  if (failed(isa))
    return failure();
  bool supported =
      useB8Op ? waveamdmachine::DsReadTrB64B8Op::isSupportedOnIsa(*isa)
              : waveamdmachine::DsReadTrB64B4Op::isSupportedOnIsa(*isa);
  if (!supported)
    return op->emitError("transpose load lowering requires gfx950");
  waveamdmachine::AddressFieldSpec spec =
      useB8Op ? waveamdmachine::DsReadTrB64B8Op::getAddressFieldSpec()
              : waveamdmachine::DsReadTrB64B4Op::getAddressFieldSpec();
  FailureOr<WaveAMDMachineSelector::BucketedOperands> buckets =
      materializeLdsAddress(S, op, ptr->second, spec);
  if (failed(buckets))
    return failure();
  Value addr = S.ensureVGPRForVSrc1(
      op->getLoc(),
      S.addByteOffsets(op->getLoc(), ptr->first, buckets->voffset));
  Type regType =
      getRegType(op->getContext(), waveamdmachine::RegClass::VGPR, 2);
  Type tokenType = getMemTokenType(op->getContext());
  Value dep = dependency ? S.expect(dependency, op) : Value{};
  Operation *load = nullptr;
  if (useB8Op) {
    load = waveamdmachine::DsReadTrB64B8Op::create(S.builder, op->getLoc(),
                                                   regType, tokenType, addr,
                                                   dep, buckets->instOffset);
  } else {
    load = waveamdmachine::DsReadTrB64B4Op::create(S.builder, op->getLoc(),
                                                   regType, tokenType, addr,
                                                   dep, buckets->instOffset);
  }
  S.values[valueResult] = load->getResult(0);
  S.values[tokenResult] = load->getResult(1);
  S.eraseIfTopLevel(op);
  return success();
}

LogicalResult
WaveAMDMachineSelector::selectTransposeLoad(waveamd::TransposeLoadOp op) {
  return selectDsReadTr(*this, op.getOperation(), op.getSource(),
                        op.getDependency(), op.getValue(), op.getToken());
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
    FailureOr<Value> value =
        materializePlanExpr(S, op, expr, bindings, plan->assumptions);
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
  if (isBuffer && plan->soffsetExpr) {
    // Buffer-to-LDS with SGPR soffset takes the slow dynamic-offset path.
    // Keep soffset inline zero when the whole source address fits vaddr.
    FailureOr<sym::ExprHandle> voffset = appendAddressExpr(
        S, plan->voffsetExpr, plan->soffsetExpr, plan->assumptions);
    if (failed(voffset))
      return failure();
    if (!needsWideAddressMaterialization(*voffset, *plan) &&
        S.slotFitsU32(*voffset, plan->assumptions)) {
      plan->voffsetExpr = *voffset;
      plan->soffsetExpr = {};
    }
  }
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
  FailureOr<unsigned> targetWidth = waveamdmachine::getAMDGPUWavefrontSize(
      op, "WaveAMDMachine wave.where lowering");
  if (failed(targetWidth))
    return failure();
  if (maskWidth != *targetWidth)
    return op.emitError("wave.where mask width ")
           << maskWidth << " does not match target wave" << *targetWidth;
  return success();
}

static bool isPointerLikeWhereResult(Type type) {
  if (isa<PtrType>(type))
    return true;
  if (auto simdType = dyn_cast<SimdType>(type))
    return isa<PtrType>(simdType.getElementType());
  return false;
}

static LogicalResult validateWhereMergeSource(WhereOp op, Value value,
                                              unsigned width, StringRef name) {
  waveamdmachine::RegType regType =
      dyn_cast<waveamdmachine::RegType>(value.getType());
  if (!regType) {
    if (isa<waveamdmachine::ImmType>(value.getType()) && width == 1)
      return success();
    return op.emitError(name) << " yield cannot be merged as a SIMD value";
  }
  if (regType.getWidth() != width)
    return op.emitError(name) << " yield register width " << regType.getWidth()
                              << " does not match result width " << width;
  if (regType.getRegClass() != waveamdmachine::RegClass::VGPR &&
      regType.getRegClass() != waveamdmachine::RegClass::SGPR)
    return op.emitError(name) << " yield must be VGPR or SGPR";
  return success();
}

struct SelectedWhereRegion {
  Region region;
  SmallVector<Value> sourceYields;
  SmallVector<Value> machineYields;
};

static LogicalResult selectMachineWhereRegion(WaveAMDMachineSelector &S,
                                              Region &src,
                                              SelectedWhereRegion &selected) {
  selected.region.emplaceBlock();
  auto savedIP = S.builder.saveInsertionPoint();
  S.builder.setInsertionPointToStart(&selected.region.front());
  if (failed(S.selectRegion(src))) {
    S.builder.restoreInsertionPoint(savedIP);
    return failure();
  }
  YieldOp yield = cast<YieldOp>(src.front().getTerminator());
  for (Value value : yield.getValues()) {
    selected.sourceYields.push_back(value);
    selected.machineYields.push_back(S.expect(value, yield));
  }
  S.builder.restoreInsertionPoint(savedIP);
  return success();
}

static void appendMachineYield(WaveAMDMachineSelector &S,
                               SelectedWhereRegion &selected, Location loc,
                               ArrayRef<Value> values) {
  auto savedIP = S.builder.saveInsertionPoint();
  S.builder.setInsertionPointToEnd(&selected.region.front());
  waveamdmachine::YieldOp::create(S.builder, loc, values);
  S.builder.restoreInsertionPoint(savedIP);
}

struct PointerWhereBinding {
  unsigned sourceIndex = 0;
  Value commonBase;
  Value commonGlobalBase;
  std::optional<unsigned> baseResult;
  std::optional<unsigned> globalBaseResult;
  unsigned offsetResult = 0;
  bool offsetFitsU32 = true;
  bool isBuffer = false;
};

struct WhereResultBinding {
  std::optional<unsigned> valueResult;
  std::optional<PointerWhereBinding> pointer;
};

struct WhereResultPlan {
  SmallVector<Type> resultTypes;
  SmallVector<Value> thenValues;
  SmallVector<Value> elseValues;
  SmallVector<WhereResultBinding> bindings;

  unsigned addResult(Type type, Value thenValue, Value elseValue = {}) {
    unsigned index = resultTypes.size();
    resultTypes.push_back(type);
    thenValues.push_back(thenValue);
    if (elseValue)
      elseValues.push_back(elseValue);
    return index;
  }
};

struct PointerWhereMetadata {
  Value base;
  Value globalBase;
  PointerOffset offset;
  bool isBuffer = false;
};

static FailureOr<PointerWhereMetadata>
lookupPointerWhereMetadata(WaveAMDMachineSelector &S, WhereOp op, Value pointer,
                           StringRef arm) {
  auto baseIt = S.pointerBases.find(pointer);
  auto offsetIt = S.pointerIndexOffsets.find(pointer);
  if (baseIt == S.pointerBases.end() || offsetIt == S.pointerIndexOffsets.end())
    return op.emitError(arm) << " pointer yield is missing address metadata";
  return PointerWhereMetadata{
      baseIt->second, S.pointerGlobalBases.lookup(pointer), offsetIt->second,
      S.pointerBuffers.lookup(pointer)};
}

static bool pointerWhereOffsetFitsU32(WaveAMDMachineSelector &S,
                                      const PointerOffset &offset) {
  return !offset.expr || S.slotFitsU32(offset.expr, offset.assumptions);
}

static FailureOr<Value>
materializePointerWhereOffsetWide(WaveAMDMachineSelector &S, WhereOp op,
                                  const PointerOffset &offset) {
  Value value;
  if (offset.expr) {
    SmallVector<std::pair<std::string, Value>, 4> bindings;
    for (const PointerOffsetBinding &binding : offset.bindings)
      bindings.push_back({binding.name, S.expect(binding.value, op)});
    FailureOr<Value> wide = materializeWideIndexExprNode(
        S, offset.expr, op, bindings, offset.assumptions);
    if (failed(wide))
      return failure();
    value = *wide;
  } else {
    value = createWideImm(S, op.getLoc(), 0);
  }
  return ensureVGPR2(S, op.getLoc(), value);
}

static FailureOr<Value>
materializePointerWhereOffset(WaveAMDMachineSelector &S, WhereOp op,
                              SelectedWhereRegion &selected,
                              const PointerOffset &offset, bool offsetFitsU32) {
  auto savedIP = S.builder.saveInsertionPoint();
  S.builder.setInsertionPointToEnd(&selected.region.front());
  FailureOr<Value> value =
      offsetFitsU32 ? materializePointerOffsetVGPR(S, op.getOperation(), offset)
                    : materializePointerWhereOffsetWide(S, op, offset);
  S.builder.restoreInsertionPoint(savedIP);
  return value;
}

static bool isNestedInRegion(Region *parent, Region &region) {
  while (parent) {
    if (parent == &region)
      return true;
    Operation *parentOp = parent->getParentOp();
    parent = parentOp ? parentOp->getParentRegion() : nullptr;
  }
  return false;
}

static bool isDefinedInRegion(Value value, Region &region) {
  if (BlockArgument arg = dyn_cast<BlockArgument>(value))
    return isNestedInRegion(arg.getOwner()->getParent(), region);
  Operation *def = value.getDefiningOp();
  return def && isNestedInRegion(def->getParentRegion(), region);
}

static LogicalResult addSelectedPointerOffset(WaveAMDMachineSelector &S,
                                              WhereOp op, PointerOffset &offset,
                                              Value selected,
                                              bool offsetFitsU32) {
  std::string name = (Twine("__wave_where_ptr_") + Twine(S.nextLabel++)).str();
  FailureOr<sym::ExprHandle> expr = sym::composeExprSym(S.symbolStore(), name);
  if (failed(expr))
    return op.emitError("failed to compose wave.where pointer offset");
  offset.expr = *expr;
  offset.bindings.push_back({name, selected, TermKind::Lane});
  if (!offsetFitsU32) {
    S.values[selected] = selected;
    return success();
  }
  FailureOr<sym::PredHandle> range =
      sym::rangeAssumption(S.symbolStore(), name, 0, (int64_t{1} << 32) - 1);
  if (failed(range))
    return op.emitError("failed to compose wave.where pointer offset range");
  offset.assumptions.push_back(*range);
  S.values[selected] = selected;
  return success();
}

static LogicalResult addNoElsePointerResult(WaveAMDMachineSelector &S,
                                            WhereOp op, unsigned idx,
                                            SelectedWhereRegion &thenRegion,
                                            WhereResultPlan &plan) {
  FailureOr<PointerWhereMetadata> metadata =
      lookupPointerWhereMetadata(S, op, thenRegion.sourceYields[idx], "then");
  if (failed(metadata))
    return failure();
  bool offsetFitsU32 = pointerWhereOffsetFitsU32(S, metadata->offset);
  FailureOr<Value> offset = materializePointerWhereOffset(
      S, op, thenRegion, metadata->offset, offsetFitsU32);
  if (failed(offset))
    return failure();

  PointerWhereBinding pointer;
  pointer.sourceIndex = idx;
  if (isDefinedInRegion(metadata->base, thenRegion.region))
    pointer.baseResult =
        plan.addResult(metadata->base.getType(), metadata->base);
  else
    pointer.commonBase = metadata->base;
  if (metadata->globalBase) {
    if (isDefinedInRegion(metadata->globalBase, thenRegion.region))
      pointer.globalBaseResult =
          plan.addResult(metadata->globalBase.getType(), metadata->globalBase);
    else
      pointer.commonGlobalBase = metadata->globalBase;
  }
  pointer.offsetResult = plan.addResult((*offset).getType(), *offset);
  pointer.offsetFitsU32 = offsetFitsU32;
  pointer.isBuffer = metadata->isBuffer;
  plan.bindings.push_back({std::nullopt, pointer});
  return success();
}

static LogicalResult requireMatchingPointerWhereBase(WhereOp op, Value lhs,
                                                     Value rhs,
                                                     StringRef name) {
  if (lhs == rhs)
    return success();
  return op.emitError("wave.where pointer otherwise requires matching ")
         << name;
}

static LogicalResult addOtherwisePointerResult(WaveAMDMachineSelector &S,
                                               WhereOp op, unsigned idx,
                                               SelectedWhereRegion &thenRegion,
                                               SelectedWhereRegion &elseRegion,
                                               WhereResultPlan &plan) {
  FailureOr<PointerWhereMetadata> thenMetadata =
      lookupPointerWhereMetadata(S, op, thenRegion.sourceYields[idx], "then");
  FailureOr<PointerWhereMetadata> elseMetadata =
      lookupPointerWhereMetadata(S, op, elseRegion.sourceYields[idx], "else");
  if (failed(thenMetadata) || failed(elseMetadata))
    return failure();
  if (thenMetadata->isBuffer != elseMetadata->isBuffer)
    return op.emitError(
        "wave.where pointer otherwise requires matching pointer kinds");
  if (failed(requireMatchingPointerWhereBase(
          op, thenMetadata->base, elseMetadata->base, "pointer bases")) ||
      failed(requireMatchingPointerWhereBase(op, thenMetadata->globalBase,
                                             elseMetadata->globalBase,
                                             "global bases")))
    return failure();

  bool offsetFitsU32 = pointerWhereOffsetFitsU32(S, thenMetadata->offset) &&
                       pointerWhereOffsetFitsU32(S, elseMetadata->offset);
  FailureOr<Value> thenOffset = materializePointerWhereOffset(
      S, op, thenRegion, thenMetadata->offset, offsetFitsU32);
  FailureOr<Value> elseOffset = materializePointerWhereOffset(
      S, op, elseRegion, elseMetadata->offset, offsetFitsU32);
  if (failed(thenOffset) || failed(elseOffset))
    return failure();

  PointerWhereBinding pointer;
  pointer.sourceIndex = idx;
  pointer.commonBase = thenMetadata->base;
  pointer.commonGlobalBase = thenMetadata->globalBase;
  pointer.offsetResult =
      plan.addResult((*thenOffset).getType(), *thenOffset, *elseOffset);
  pointer.offsetFitsU32 = offsetFitsU32;
  pointer.isBuffer = thenMetadata->isBuffer;
  plan.bindings.push_back({std::nullopt, pointer});
  return success();
}

static LogicalResult addPointerResult(WaveAMDMachineSelector &S, WhereOp op,
                                      unsigned idx,
                                      SelectedWhereRegion &thenRegion,
                                      SelectedWhereRegion &elseRegion,
                                      WhereResultPlan &plan) {
  if (op.getElseRegion().empty())
    return addNoElsePointerResult(S, op, idx, thenRegion, plan);
  return addOtherwisePointerResult(S, op, idx, thenRegion, elseRegion, plan);
}

static LogicalResult addDataResult(WhereOp op, unsigned idx,
                                   SelectedWhereRegion &thenRegion,
                                   SelectedWhereRegion &elseRegion,
                                   WhereResultPlan &plan) {
  Value result = op.getResult(idx);
  Value thenValue = thenRegion.machineYields[idx];
  if (op.getElseRegion().empty()) {
    unsigned resultIndex = plan.addResult(thenValue.getType(), thenValue);
    plan.bindings.push_back({resultIndex, std::nullopt});
    return success();
  }
  Value elseValue = elseRegion.machineYields[idx];
  Type resultType = result.getType();
  if (isa<MemTokenType>(resultType)) {
    unsigned resultIndex =
        plan.addResult(getMemTokenType(op.getContext()), thenValue, elseValue);
    plan.bindings.push_back({resultIndex, std::nullopt});
    return success();
  }
  if (!isa<SimdType>(resultType))
    return op.emitError(
        "WaveAMDMachine lowering supports result-bearing wave.where "
        "with otherwise only for SIMD data, pointers, or memory tokens");
  FailureOr<unsigned> width =
      getRegisterPayloadWidth(resultType, [&]() { return op.emitError(); });
  if (failed(width))
    return failure();
  if (failed(validateWhereMergeSource(op, thenValue, *width, "then")) ||
      failed(validateWhereMergeSource(op, elseValue, *width, "else")))
    return failure();
  Type type =
      getRegType(op.getContext(), waveamdmachine::RegClass::VGPR, *width);
  unsigned resultIndex = plan.addResult(type, thenValue, elseValue);
  plan.bindings.push_back({resultIndex, std::nullopt});
  return success();
}

static LogicalResult buildWhereResultPlan(WaveAMDMachineSelector &S, WhereOp op,
                                          SelectedWhereRegion &thenRegion,
                                          SelectedWhereRegion &elseRegion,
                                          WhereResultPlan &plan) {
  for (auto [idx, result] : llvm::enumerate(op.getResults())) {
    if (isPointerLikeWhereResult(result.getType())) {
      if (failed(addPointerResult(S, op, idx, thenRegion, elseRegion, plan)))
        return failure();
      continue;
    }
    if (failed(addDataResult(op, idx, thenRegion, elseRegion, plan)))
      return failure();
  }
  return success();
}

static waveamdmachine::ExecIfOp
createExecIf(WaveAMDMachineSelector &S, Location loc, Value condition,
             TypeRange resultTypes, Region &thenRegion, Region &elseRegion) {
  OperationState state(loc, "waveamdmachine.exec_if");
  state.addOperands(condition);
  state.addTypes(resultTypes);
  state.addRegion()->takeBody(thenRegion);
  state.addRegion()->takeBody(elseRegion);
  return cast<waveamdmachine::ExecIfOp>(S.builder.create(state));
}

static LogicalResult
bindPointerWhereResult(WaveAMDMachineSelector &S, WhereOp op,
                       waveamdmachine::ExecIfOp execIf,
                       const PointerWhereBinding &pointer) {
  Value sourceResult = op.getResult(pointer.sourceIndex);
  Value base = pointer.commonBase;
  if (!base)
    base = execIf.getResult(*pointer.baseResult);
  assert(base && "pointer where base missing");
  Value globalBase = pointer.commonGlobalBase;
  if (!globalBase && pointer.globalBaseResult)
    globalBase = execIf.getResult(*pointer.globalBaseResult);
  Value offset = execIf.getResult(pointer.offsetResult);
  S.values[sourceResult] = base;
  S.pointerBases[sourceResult] = base;
  if (globalBase)
    S.pointerGlobalBases[sourceResult] = globalBase;
  PointerOffset selectedOffset;
  if (failed(addSelectedPointerOffset(S, op, selectedOffset, offset,
                                      pointer.offsetFitsU32)))
    return failure();
  S.pointerIndexOffsets[sourceResult] = std::move(selectedOffset);
  S.pointerBuffers[sourceResult] = pointer.isBuffer;
  return success();
}

static LogicalResult bindWhereResults(WaveAMDMachineSelector &S, WhereOp op,
                                      waveamdmachine::ExecIfOp execIf,
                                      const WhereResultPlan &plan) {
  for (auto [sourceResult, binding] :
       llvm::zip_equal(op.getResults(), plan.bindings)) {
    if (binding.pointer) {
      if (failed(bindPointerWhereResult(S, op, execIf, *binding.pointer)))
        return failure();
      continue;
    }
    Value selected = execIf.getResult(*binding.valueResult);
    S.values[sourceResult] = selected;
    S.values[selected] = selected;
  }
  return success();
}

static LogicalResult validateWhereResultCount(WhereOp op,
                                              SelectedWhereRegion &thenRegion,
                                              SelectedWhereRegion &elseRegion) {
  if (thenRegion.sourceYields.size() != op.getNumResults())
    return op.emitError("then yield count must match result count");
  if (!op.getElseRegion().empty() &&
      elseRegion.sourceYields.size() != op.getNumResults())
    return op.emitError("else yield count must match result count");
  return success();
}

static LogicalResult prepareExecIfRegions(WaveAMDMachineSelector &S, WhereOp op,
                                          SelectedWhereRegion &thenRegion,
                                          SelectedWhereRegion &elseRegion) {
  if (failed(selectMachineWhereRegion(S, op.getThenRegion(), thenRegion)))
    return failure();
  if (!op.getElseRegion().empty() &&
      failed(selectMachineWhereRegion(S, op.getElseRegion(), elseRegion)))
    return failure();
  return validateWhereResultCount(op, thenRegion, elseRegion);
}

static LogicalResult createStructuredWhere(WaveAMDMachineSelector &S,
                                           WhereOp op, Value condition) {
  SelectedWhereRegion thenRegion;
  SelectedWhereRegion elseRegion;
  if (failed(prepareExecIfRegions(S, op, thenRegion, elseRegion)))
    return failure();
  WhereResultPlan plan;
  if (failed(buildWhereResultPlan(S, op, thenRegion, elseRegion, plan)))
    return failure();
  appendMachineYield(S, thenRegion, op.getLoc(), plan.thenValues);
  if (!op.getElseRegion().empty())
    appendMachineYield(S, elseRegion, op.getLoc(), plan.elseValues);
  waveamdmachine::ExecIfOp execIf =
      createExecIf(S, op.getLoc(), condition, plan.resultTypes,
                   thenRegion.region, elseRegion.region);
  if (failed(bindWhereResults(S, op, execIf, plan)))
    return failure();
  S.builder.setInsertionPointAfter(execIf);
  return success();
}

struct SelectedScfIfRegion {
  Region region;
  SmallVector<Value> sourceYields;
  SmallVector<Value> machineYields;
};

static LogicalResult selectMachineScfIfRegion(WaveAMDMachineSelector &S,
                                              Region &src,
                                              SelectedScfIfRegion &selected) {
  if (src.empty())
    return success();
  selected.region.emplaceBlock();
  auto savedIP = S.builder.saveInsertionPoint();
  S.builder.setInsertionPointToStart(&selected.region.front());
  if (failed(S.selectRegion(src))) {
    S.builder.restoreInsertionPoint(savedIP);
    return failure();
  }
  scf::YieldOp yield = cast<scf::YieldOp>(src.front().getTerminator());
  for (Value value : yield.getResults()) {
    selected.sourceYields.push_back(value);
    selected.machineYields.push_back(S.expect(value, yield));
  }
  S.builder.restoreInsertionPoint(savedIP);
  return success();
}

static void appendMachineYield(WaveAMDMachineSelector &S,
                               SelectedScfIfRegion &selected, Location loc,
                               ArrayRef<Value> values) {
  auto savedIP = S.builder.saveInsertionPoint();
  S.builder.setInsertionPointToEnd(&selected.region.front());
  waveamdmachine::YieldOp::create(S.builder, loc, values);
  S.builder.restoreInsertionPoint(savedIP);
}

struct PointerScfIfBinding {
  unsigned sourceIndex = 0;
  Value commonBase;
  Value commonGlobalBase;
  std::optional<unsigned> baseResult;
  std::optional<unsigned> globalBaseResult;
  unsigned offsetResult = 0;
  TermKind offsetKind = TermKind::Uniform;
  bool offsetFitsU32 = true;
  bool isBuffer = false;
};

struct ScfIfResultBinding {
  std::optional<unsigned> valueResult;
  std::optional<PointerScfIfBinding> pointer;
};

struct ScfIfResultPlan {
  SmallVector<Type> resultTypes;
  SmallVector<Value> thenValues;
  SmallVector<Value> elseValues;
  SmallVector<ScfIfResultBinding> bindings;

  unsigned addResult(Type type, Value thenValue, Value elseValue) {
    unsigned index = resultTypes.size();
    resultTypes.push_back(type);
    thenValues.push_back(thenValue);
    elseValues.push_back(elseValue);
    return index;
  }
};

struct PointerScfIfMetadata {
  Value base;
  Value globalBase;
  PointerOffset offset;
  bool isBuffer = false;
};

static FailureOr<PointerScfIfMetadata>
lookupPointerScfIfMetadata(WaveAMDMachineSelector &S, scf::IfOp op,
                           Value pointer, StringRef arm) {
  auto baseIt = S.pointerBases.find(pointer);
  auto offsetIt = S.pointerIndexOffsets.find(pointer);
  if (baseIt == S.pointerBases.end() || offsetIt == S.pointerIndexOffsets.end())
    return op.emitError(arm) << " pointer yield is missing address metadata";
  return PointerScfIfMetadata{
      baseIt->second, S.pointerGlobalBases.lookup(pointer), offsetIt->second,
      S.pointerBuffers.lookup(pointer)};
}

static bool pointerScfIfOffsetFitsU32(WaveAMDMachineSelector &S,
                                      const PointerOffset &offset) {
  return !offset.expr || S.slotFitsU32(offset.expr, offset.assumptions);
}

static FailureOr<Value> materializePointerScfIfOffset(
    WaveAMDMachineSelector &S, scf::IfOp op, SelectedScfIfRegion &selected,
    const PointerOffset &offset, TermKind kind, bool offsetFitsU32) {
  auto savedIP = S.builder.saveInsertionPoint();
  S.builder.setInsertionPointToEnd(&selected.region.front());
  FailureOr<Value> value = failure();
  if (kind == TermKind::Lane) {
    if (offsetFitsU32) {
      value = materializePointerOffsetVGPR(S, op.getOperation(), offset);
    } else {
      FailureOr<Value> wide =
          materializePointerOffsetWideValue(S, op.getOperation(), offset);
      if (succeeded(wide))
        value = ensureVGPR2(S, op.getLoc(), *wide);
    }
  } else if (offsetFitsU32) {
    value = materializeUniformPointerOffsetCarry(S, op.getOperation(), offset);
  } else {
    FailureOr<Value> wide =
        materializeUniformPointerOffsetWideValue(S, op.getOperation(), offset);
    if (succeeded(wide))
      value = ensureSGPR2(S, op.getLoc(), *wide);
  }
  S.builder.restoreInsertionPoint(savedIP);
  return value;
}

static FailureOr<Type> getScfIfDataResultType(scf::IfOp op, Type sourceType) {
  MLIRContext *context = op.getContext();
  if (isa<MemTokenType>(sourceType))
    return getMemTokenType(context);
  waveamdmachine::RegClass regClass = isa<SimdType>(sourceType)
                                          ? waveamdmachine::RegClass::VGPR
                                          : waveamdmachine::RegClass::SGPR;
  unsigned width = 0;
  if (auto maskType = dyn_cast<MaskType>(sourceType)) {
    width = maskType.getWidth() / 32;
  } else {
    FailureOr<unsigned> payloadWidth =
        getRegisterPayloadWidth(sourceType, [&]() { return op.emitError(); });
    if (failed(payloadWidth))
      return failure();
    width = *payloadWidth;
  }
  return getRegType(context, regClass, width);
}

static FailureOr<Value> materializeScfIfSGPRYield(WaveAMDMachineSelector &S,
                                                  scf::IfOp op, Value value,
                                                  unsigned width) {
  Location loc = op.getLoc();
  if (width == 1)
    return S.materializeSGPR1(loc, value);
  if (width == 2)
    return ensureSGPR2(S, loc, value);
  if (auto regType = dyn_cast<waveamdmachine::RegType>(value.getType()))
    if (regType.getRegClass() != waveamdmachine::RegClass::SGPR)
      return op.emitError("uniform_if SGPR yield source must be SGPR");
  Type resultType =
      getRegType(op.getContext(), waveamdmachine::RegClass::SGPR, width);
  auto mov =
      waveamdmachine::SMovB32TupleOp::create(S.builder, loc, resultType, value);
  mov->setAttr("registers", S.builder.getI64IntegerAttr(width));
  return mov.getResult();
}

static FailureOr<Value> materializeScfIfDataYield(WaveAMDMachineSelector &S,
                                                  scf::IfOp op, Value value,
                                                  Type resultType) {
  if (value.getType() == resultType)
    return value;
  if (isa<MemTokenType>(resultType))
    return op.emitError("uniform_if token yield type mismatch");
  auto regType = cast<waveamdmachine::RegType>(resultType);
  if (regType.getRegClass() == waveamdmachine::RegClass::VGPR)
    return ensureLaneSelectVGPR(S, op.getOperation(), value,
                                regType.getWidth());
  return materializeScfIfSGPRYield(S, op, value, regType.getWidth());
}

static LogicalResult addScfIfDataResult(WaveAMDMachineSelector &S, scf::IfOp op,
                                        unsigned idx,
                                        SelectedScfIfRegion &thenRegion,
                                        SelectedScfIfRegion &elseRegion,
                                        ScfIfResultPlan &plan) {
  FailureOr<Type> resultType =
      getScfIfDataResultType(op, op.getResult(idx).getType());
  if (failed(resultType))
    return failure();
  FailureOr<Value> thenValue = materializeScfIfDataYield(
      S, op, thenRegion.machineYields[idx], *resultType);
  FailureOr<Value> elseValue = materializeScfIfDataYield(
      S, op, elseRegion.machineYields[idx], *resultType);
  if (failed(thenValue) || failed(elseValue))
    return failure();
  unsigned resultIndex = plan.addResult(*resultType, *thenValue, *elseValue);
  plan.bindings.push_back({resultIndex, std::nullopt});
  return success();
}

static LogicalResult addScfIfPointerComponent(scf::IfOp op, StringRef name,
                                              Value thenValue, Value elseValue,
                                              Value &commonValue,
                                              std::optional<unsigned> &result,
                                              ScfIfResultPlan &plan) {
  if (!thenValue && !elseValue)
    return success();
  if (!thenValue || !elseValue)
    return op.emitError("scf.if pointer yields require matching ")
           << name << " presence";
  if (thenValue == elseValue) {
    commonValue = thenValue;
    return success();
  }
  if (thenValue.getType() != elseValue.getType())
    return op.emitError("scf.if pointer yields require matching ")
           << name << " types";
  result = plan.addResult(thenValue.getType(), thenValue, elseValue);
  return success();
}

static LogicalResult addScfIfPointerResult(WaveAMDMachineSelector &S,
                                           scf::IfOp op, unsigned idx,
                                           SelectedScfIfRegion &thenRegion,
                                           SelectedScfIfRegion &elseRegion,
                                           ScfIfResultPlan &plan) {
  FailureOr<PointerScfIfMetadata> thenMetadata =
      lookupPointerScfIfMetadata(S, op, thenRegion.sourceYields[idx], "then");
  FailureOr<PointerScfIfMetadata> elseMetadata =
      lookupPointerScfIfMetadata(S, op, elseRegion.sourceYields[idx], "else");
  if (failed(thenMetadata) || failed(elseMetadata))
    return failure();
  if (thenMetadata->isBuffer != elseMetadata->isBuffer)
    return op.emitError("scf.if pointer yields require matching pointer kinds");

  Type resultType = op.getResult(idx).getType();
  TermKind offsetKind =
      isa<SimdType>(resultType) ? TermKind::Lane : TermKind::Uniform;
  bool offsetFitsU32 = pointerScfIfOffsetFitsU32(S, thenMetadata->offset) &&
                       pointerScfIfOffsetFitsU32(S, elseMetadata->offset);
  FailureOr<Value> thenOffset = materializePointerScfIfOffset(
      S, op, thenRegion, thenMetadata->offset, offsetKind, offsetFitsU32);
  FailureOr<Value> elseOffset = materializePointerScfIfOffset(
      S, op, elseRegion, elseMetadata->offset, offsetKind, offsetFitsU32);
  if (failed(thenOffset) || failed(elseOffset))
    return failure();

  PointerScfIfBinding pointer;
  pointer.sourceIndex = idx;
  pointer.offsetKind = offsetKind;
  pointer.offsetFitsU32 = offsetFitsU32;
  pointer.isBuffer = thenMetadata->isBuffer;
  if (failed(addScfIfPointerComponent(op, "base", thenMetadata->base,
                                      elseMetadata->base, pointer.commonBase,
                                      pointer.baseResult, plan)))
    return failure();
  if (failed(addScfIfPointerComponent(
          op, "global base", thenMetadata->globalBase, elseMetadata->globalBase,
          pointer.commonGlobalBase, pointer.globalBaseResult, plan)))
    return failure();
  pointer.offsetResult =
      plan.addResult((*thenOffset).getType(), *thenOffset, *elseOffset);
  plan.bindings.push_back({std::nullopt, pointer});
  return success();
}

static LogicalResult buildScfIfResultPlan(WaveAMDMachineSelector &S,
                                          scf::IfOp op,
                                          SelectedScfIfRegion &thenRegion,
                                          SelectedScfIfRegion &elseRegion,
                                          ScfIfResultPlan &plan) {
  if (op.getElseRegion().empty() && op.getNumResults() != 0)
    return op.emitError("result-bearing scf.if requires else region");
  for (auto [idx, result] : llvm::enumerate(op.getResults())) {
    if (isPointerLikeWhereResult(result.getType())) {
      if (failed(
              addScfIfPointerResult(S, op, idx, thenRegion, elseRegion, plan)))
        return failure();
      continue;
    }
    if (failed(addScfIfDataResult(S, op, idx, thenRegion, elseRegion, plan)))
      return failure();
  }
  return success();
}

static waveamdmachine::UniformIfOp
createUniformIf(WaveAMDMachineSelector &S, Location loc, Value condition,
                TypeRange resultTypes, Region &thenRegion, Region &elseRegion) {
  OperationState state(loc, "waveamdmachine.uniform_if");
  state.addOperands(condition);
  state.addTypes(resultTypes);
  state.addRegion()->takeBody(thenRegion);
  state.addRegion()->takeBody(elseRegion);
  return cast<waveamdmachine::UniformIfOp>(S.builder.create(state));
}

static LogicalResult
addSelectedScfIfPointerOffset(WaveAMDMachineSelector &S, scf::IfOp op,
                              PointerOffset &offset, Value selected,
                              TermKind kind, bool offsetFitsU32) {
  std::string name = (Twine("__wave_if_ptr_") + Twine(S.nextLabel++)).str();
  FailureOr<sym::ExprHandle> expr = sym::composeExprSym(S.symbolStore(), name);
  if (failed(expr))
    return op.emitError("failed to compose scf.if pointer offset");
  offset.expr = *expr;
  offset.bindings.push_back({name, selected, kind});
  if (!offsetFitsU32) {
    S.values[selected] = selected;
    return success();
  }
  FailureOr<sym::PredHandle> range =
      sym::rangeAssumption(S.symbolStore(), name, 0, (int64_t{1} << 32) - 1);
  if (failed(range))
    return op.emitError("failed to compose scf.if pointer offset range");
  offset.assumptions.push_back(*range);
  S.values[selected] = selected;
  return success();
}

static LogicalResult
bindScfIfPointerResult(WaveAMDMachineSelector &S, scf::IfOp op,
                       waveamdmachine::UniformIfOp uniformIf,
                       const PointerScfIfBinding &pointer) {
  Value sourceResult = op.getResult(pointer.sourceIndex);
  Value base = pointer.commonBase;
  if (!base)
    base = uniformIf.getResult(*pointer.baseResult);
  assert(base && "pointer scf.if base missing");
  Value globalBase = pointer.commonGlobalBase;
  if (!globalBase && pointer.globalBaseResult)
    globalBase = uniformIf.getResult(*pointer.globalBaseResult);
  Value offset = uniformIf.getResult(pointer.offsetResult);
  S.values[sourceResult] = base;
  S.pointerBases[sourceResult] = base;
  if (globalBase)
    S.pointerGlobalBases[sourceResult] = globalBase;
  PointerOffset selectedOffset;
  if (failed(addSelectedScfIfPointerOffset(S, op, selectedOffset, offset,
                                           pointer.offsetKind,
                                           pointer.offsetFitsU32)))
    return failure();
  S.pointerIndexOffsets[sourceResult] = std::move(selectedOffset);
  S.pointerBuffers[sourceResult] = pointer.isBuffer;
  return success();
}

static LogicalResult bindScfIfResults(WaveAMDMachineSelector &S, scf::IfOp op,
                                      waveamdmachine::UniformIfOp uniformIf,
                                      const ScfIfResultPlan &plan) {
  for (auto [sourceResult, binding] :
       llvm::zip_equal(op.getResults(), plan.bindings)) {
    if (binding.pointer) {
      if (failed(bindScfIfPointerResult(S, op, uniformIf, *binding.pointer)))
        return failure();
      continue;
    }
    Value selected = uniformIf.getResult(*binding.valueResult);
    S.values[sourceResult] = selected;
    S.values[selected] = selected;
  }
  return success();
}

static LogicalResult validateScfIfResultCount(scf::IfOp op,
                                              SelectedScfIfRegion &thenRegion,
                                              SelectedScfIfRegion &elseRegion) {
  if (thenRegion.sourceYields.size() != op.getNumResults())
    return op.emitError("then yield count must match result count");
  if (!op.getElseRegion().empty() &&
      elseRegion.sourceYields.size() != op.getNumResults())
    return op.emitError("else yield count must match result count");
  return success();
}

static LogicalResult prepareUniformIfRegions(WaveAMDMachineSelector &S,
                                             scf::IfOp op,
                                             SelectedScfIfRegion &thenRegion,
                                             SelectedScfIfRegion &elseRegion) {
  if (failed(selectMachineScfIfRegion(S, op.getThenRegion(), thenRegion)))
    return failure();
  if (!op.getElseRegion().empty() &&
      failed(selectMachineScfIfRegion(S, op.getElseRegion(), elseRegion)))
    return failure();
  return validateScfIfResultCount(op, thenRegion, elseRegion);
}

static LogicalResult createStructuredScfIf(WaveAMDMachineSelector &S,
                                           scf::IfOp op, Value condition) {
  SelectedScfIfRegion thenRegion;
  SelectedScfIfRegion elseRegion;
  if (failed(prepareUniformIfRegions(S, op, thenRegion, elseRegion)))
    return failure();
  ScfIfResultPlan plan;
  if (failed(buildScfIfResultPlan(S, op, thenRegion, elseRegion, plan)))
    return failure();
  appendMachineYield(S, thenRegion, op.getLoc(), plan.thenValues);
  if (!op.getElseRegion().empty())
    appendMachineYield(S, elseRegion, op.getLoc(), plan.elseValues);
  waveamdmachine::UniformIfOp uniformIf =
      createUniformIf(S, op.getLoc(), condition, plan.resultTypes,
                      thenRegion.region, elseRegion.region);
  if (failed(bindScfIfResults(S, op, uniformIf, plan)))
    return failure();
  S.builder.setInsertionPointAfter(uniformIf);
  return success();
}

LogicalResult WaveAMDMachineSelector::selectWhere(WhereOp op) {
  auto maskType = cast<MaskType>(op.getCondition().getType());
  unsigned maskWidth = maskType.getWidth();
  if (failed(validateWhereMaskWidth(op, maskWidth)))
    return failure();

  Value condition = expect(op.getCondition(), op);
  if (failed(createStructuredWhere(*this, op, condition)))
    return failure();
  eraseIfTopLevel(op);
  return success();
}

LogicalResult WaveAMDMachineSelector::selectScfIf(scf::IfOp op) {
  Value condition =
      boolToSCC(*this, op.getLoc(), expect(op.getCondition(), op));
  if (failed(createStructuredScfIf(*this, op, condition)))
    return failure();
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

static bool isSupportedFragmentType(waveamd::FragmentType type) {
  int64_t role = type.getRole();
  int64_t waveSize = type.getWaveSize();
  return (role == 0 || role == 1 || role == 2) &&
         type.getElementType().isIntOrFloat() && type.getRows() > 0 &&
         type.getColumns() > 0 && (waveSize == 32 || waveSize == 64) &&
         type.getRegisters() > 0;
}

static bool isSupportedWaveType(Type type) {
  if (auto ptrType = dyn_cast<PtrType>(type)) {
    if (!ptrType.getElementType())
      return true;
    return isSupportedBoundaryType(ptrType.getElementType());
  }
  if (auto simdType = dyn_cast<SimdType>(type))
    return isSupportedSimdPayloadType(simdType);
  if (auto maskType = dyn_cast<MaskType>(type))
    return maskType.getWidth() == 32 || maskType.getWidth() == 64;
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

static LogicalResult runRangeAnalysis(Operation *root,
                                      DataFlowSolver &rangeSolver) {
  dataflow::loadBaselineAnalyses(rangeSolver);
  rangeSolver.load<dataflow::IntegerRangeAnalysis>();
  if (failed(rangeSolver.initializeAndRun(root)))
    return root->emitError("IntegerRangeAnalysis failed for WaveAMDMachine "
                           "lowering");
  return success();
}

static bool reachesWaveDialect(func::FuncOp func) {
  WalkResult walk = func.walk([&](Operation *op) {
    if (isa<wave::WaveDialect, waveamd::WaveAMDDialect>(op->getDialect()))
      return WalkResult::interrupt();
    return WalkResult::advance();
  });
  return walk.wasInterrupted();
}

static void
collectMachineSelectionTargets(Operation *root,
                               SmallVectorImpl<func::FuncOp> &targets) {
  root->walk([&](func::FuncOp func) {
    if (func.isExternal())
      return;
    if (func->hasAttr(wave::WaveDialect::getKernelAttrName()) ||
        reachesWaveDialect(func))
      targets.push_back(func);
  });
}

static LogicalResult
diagnoseMachineSelectionTargets(ArrayRef<func::FuncOp> targets) {
  bool foundUnsupported = false;
  for (func::FuncOp func : targets)
    if (failed(diagnoseWaveAMDMachineBoundary(func)))
      foundUnsupported = true;
  return success(!foundUnsupported);
}

struct ConvertWaveAMDToWaveAMDMachinePass
    : public wave::impl::ConvertWaveAMDToWaveAMDMachineBase<
          ConvertWaveAMDToWaveAMDMachinePass> {
  void runOnOperation() override {
    Operation *root = getOperation();
    SmallVector<func::FuncOp> targets;
    collectMachineSelectionTargets(root, targets);

    if (failed(diagnoseMachineSelectionTargets(targets)))
      return signalPassFailure();

    DataFlowSolver rangeSolver;
    if (failed(runRangeAnalysis(root, rangeSolver)))
      return signalPassFailure();

    for (func::FuncOp func : targets) {
      if (failed(wave::wmsel::WaveAMDMachineSelector(func, rangeSolver).run()))
        return signalPassFailure();
    }
  }
};

} // namespace
