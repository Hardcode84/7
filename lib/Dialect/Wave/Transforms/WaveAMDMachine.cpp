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
#include "llvm/ADT/DenseSet.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/ADT/SmallPtrSet.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/ADT/StringMap.h"
#include "llvm/ADT/StringSwitch.h"
#include "llvm/ADT/TypeSwitch.h"
#include "llvm/Support/CheckedArithmetic.h"
#include "llvm/Support/Debug.h"
#include "llvm/Support/ErrorHandling.h"
#include "llvm/Support/MathExtras.h"
#include "llvm/TargetParser/TargetParser.h"
#include <array>
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

static constexpr StringLiteral kScheduleInputAttr =
    "waveamdmachine.schedule_input";
static constexpr StringLiteral kDmaIssueAfterDelayAttr =
    "waveamdmachine.dma_issue_after_delay";

namespace mlir::wave::wmsel {

static bool isLaneVaryingType(Type type) {
  return isa<SimdType, waveamd::FragmentType>(type);
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

static bool isSimdF32(Type type) {
  SimdType simdType = dyn_cast<SimdType>(type);
  return simdType && simdType.getElementType().isF32();
}

static std::optional<unsigned> getPow2VectorLength(Type type,
                                                   Type elementType) {
  VectorType vectorType = dyn_cast<VectorType>(type);
  if (!vectorType || vectorType.getRank() != 1 || vectorType.isScalable() ||
      vectorType.getElementType() != elementType)
    return std::nullopt;
  int64_t length = vectorType.getNumElements();
  if (length <= 0 || !llvm::isPowerOf2_64(static_cast<uint64_t>(length)))
    return std::nullopt;
  return static_cast<unsigned>(length);
}

static std::optional<unsigned> getSimdPow2VectorLength(Type type,
                                                       Type elementType) {
  SimdType simdType = dyn_cast<SimdType>(type);
  if (!simdType)
    return std::nullopt;
  return getPow2VectorLength(simdType.getElementType(), elementType);
}

static bool isSimdVectorElement(Type type, Type elementType) {
  SimdType simdType = dyn_cast<SimdType>(type);
  if (!simdType)
    return false;
  VectorType vectorType = dyn_cast<VectorType>(simdType.getElementType());
  return vectorType && vectorType.getRank() == 1 && !vectorType.isScalable() &&
         vectorType.getElementType() == elementType;
}

static bool isSimdScalarElement(Type type, Type elementType) {
  SimdType simdType = dyn_cast<SimdType>(type);
  return simdType && simdType.getElementType() == elementType;
}

static std::optional<unsigned> getSimdPackedF16Length(Type type) {
  return getSimdPow2VectorLength(type, Float16Type::get(type.getContext()));
}

static std::optional<unsigned> getSimdPackedBF16Length(Type type) {
  return getSimdPow2VectorLength(type, BFloat16Type::get(type.getContext()));
}

static std::optional<unsigned> getSimdPackedF32Length(Type type) {
  return getSimdPow2VectorLength(type, Float32Type::get(type.getContext()));
}

static bool isSimdPackedF16(Type type) {
  return getSimdPackedF16Length(type).has_value();
}

static bool isSimdPackedF32(Type type) {
  return getSimdPackedF32Length(type).has_value();
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

static LogicalResult requirePackedF32Target(Operation *op, StringRef kind) {
  FailureOr<llvm::AMDGPU::IsaVersion> isa =
      getTargetIsaVersion(op, "packed f32 lowering");
  if (failed(isa))
    return failure();
  if (!waveamdmachine::VPkAddF32Op::isSupportedOnIsa(*isa))
    return op->emitError("packed f32 ")
           << kind << " lowering requires gfx8/gfx9/gfx12";
  return success();
}

static LogicalResult requirePackedRtzCvtTarget(CastOp op) {
  FailureOr<llvm::AMDGPU::IsaVersion> isa =
      getTargetIsaVersion(op, "packed f32 to f16 lowering");
  if (failed(isa))
    return failure();
  if (!waveamdmachine::VCvtPkRtzF16F32Op::isSupportedOnIsa(*isa))
    return op.emitError(
        "packed rtz f32 to f16 lowering requires gfx8/gfx9/gfx11");
  return success();
}

static FailureOr<bool> supportsPackedRneCvtTarget(CastOp op) {
  FailureOr<llvm::AMDGPU::IsaVersion> isa =
      getTargetIsaVersion(op, "packed f32 to f16 lowering");
  if (failed(isa))
    return failure();
  return waveamdmachine::VCvtPkF16F32Op::isSupportedOnIsa(*isa);
}

enum class MmaKind {
  WmmaI32_16x16x16_IU8,
  WmmaF32_16x16x16_F16,
  WmmaF32_16x16x16_BF16,
  MfmaF32_16x16x16_F16,
  MfmaF32_16x16x16_BF16,
  MfmaF32_16x16x32_F16,
  MfmaF32_16x16x32_BF16,
  MfmaF32_32x32x16_F16,
  MfmaF32_32x32x16_BF16,
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
      .Case("mfma.f32.32x32x16.f16", MmaKind::MfmaF32_32x32x16_F16)
      .Case("mfma.f32.32x32x16.bf16", MmaKind::MfmaF32_32x32x16_BF16)
      .Case("mfma.scale.f32.16x16x128.f4.f4",
            MmaKind::MfmaScaleF32_16x16x128_F4F4)
      .Default(MmaKind::Unsupported);
}

using MmaSupportFn = bool (*)(const llvm::AMDGPU::IsaVersion &);
using MmaCreateFn = Value (*)(OpBuilder &, Location, Type, Value, Value, Value);

template <typename Op>
static bool isMmaOpSupportedOnIsa(const llvm::AMDGPU::IsaVersion &isa) {
  return Op::isSupportedOnIsa(isa);
}

template <typename Op>
static Value createMmaMachineOp(OpBuilder &builder, Location loc,
                                Type resultType, Value a, Value b, Value acc) {
  return Op::create(builder, loc, resultType, a, b, acc).getResult();
}

struct MmaKindInfo {
  MmaKind kind;
  MmaSupportFn isSupported;
  MmaCreateFn create;
  const char *requirement;
};

static constexpr std::array<MmaKindInfo, 10> kMmaKindInfos = {{
    {MmaKind::WmmaI32_16x16x16_IU8,
     isMmaOpSupportedOnIsa<waveamdmachine::WmmaI32_16x16x16_IU8Op>,
     createMmaMachineOp<waveamdmachine::WmmaI32_16x16x16_IU8Op>, "gfx11"},
    {MmaKind::WmmaF32_16x16x16_F16,
     isMmaOpSupportedOnIsa<waveamdmachine::WmmaF32_16x16x16_F16Op>,
     createMmaMachineOp<waveamdmachine::WmmaF32_16x16x16_F16Op>, "gfx11"},
    {MmaKind::WmmaF32_16x16x16_BF16,
     isMmaOpSupportedOnIsa<waveamdmachine::WmmaF32_16x16x16_BF16Op>,
     createMmaMachineOp<waveamdmachine::WmmaF32_16x16x16_BF16Op>, "gfx11"},
    {MmaKind::MfmaF32_16x16x16_F16,
     isMmaOpSupportedOnIsa<waveamdmachine::MfmaF32_16x16x16_F16Op>,
     createMmaMachineOp<waveamdmachine::MfmaF32_16x16x16_F16Op>, "gfx90a+"},
    {MmaKind::MfmaF32_16x16x16_BF16,
     isMmaOpSupportedOnIsa<waveamdmachine::MfmaF32_16x16x16_BF16Op>,
     createMmaMachineOp<waveamdmachine::MfmaF32_16x16x16_BF16Op>, "gfx940+"},
    {MmaKind::MfmaF32_16x16x32_F16,
     isMmaOpSupportedOnIsa<waveamdmachine::MfmaF32_16x16x32_F16Op>,
     createMmaMachineOp<waveamdmachine::MfmaF32_16x16x32_F16Op>, "gfx950"},
    {MmaKind::MfmaF32_16x16x32_BF16,
     isMmaOpSupportedOnIsa<waveamdmachine::MfmaF32_16x16x32_BF16Op>,
     createMmaMachineOp<waveamdmachine::MfmaF32_16x16x32_BF16Op>, "gfx950"},
    {MmaKind::MfmaF32_32x32x16_F16,
     isMmaOpSupportedOnIsa<waveamdmachine::MfmaF32_32x32x16_F16Op>,
     createMmaMachineOp<waveamdmachine::MfmaF32_32x32x16_F16Op>, "gfx950"},
    {MmaKind::MfmaF32_32x32x16_BF16,
     isMmaOpSupportedOnIsa<waveamdmachine::MfmaF32_32x32x16_BF16Op>,
     createMmaMachineOp<waveamdmachine::MfmaF32_32x32x16_BF16Op>, "gfx950"},
    {MmaKind::MfmaScaleF32_16x16x128_F4F4,
     isMmaOpSupportedOnIsa<waveamdmachine::MfmaScaleF32_16x16x128_F4F4Op>,
     nullptr, "gfx950"},
}};

static const MmaKindInfo *lookupMmaKindInfo(MmaKind kind) {
  for (const MmaKindInfo &info : kMmaKindInfos)
    if (info.kind == kind)
      return &info;
  return nullptr;
}

static bool isMmaTargetSupported(MmaKind kind,
                                 const llvm::AMDGPU::IsaVersion &isa) {
  const MmaKindInfo *info = lookupMmaKindInfo(kind);
  return !info || info->isSupported(isa);
}

static StringRef mmaTargetRequirement(MmaKind kind) {
  const MmaKindInfo *info = lookupMmaKindInfo(kind);
  return info ? info->requirement : "";
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
  const MmaKindInfo *info = lookupMmaKindInfo(kind);
  if (!info || !info->create)
    return {};
  return info->create(builder, loc, resultType, a, b, acc);
}

static Value matchZeroMmaAccumulatorMaterialization(
    Value value, SmallVectorImpl<Operation *> &materializations);

static Value
matchZeroMmaAccumulatorCopy(Operation *op, Value source,
                            SmallVectorImpl<Operation *> &materializations) {
  SmallVector<Operation *> nested;
  Value zero = matchZeroMmaAccumulatorMaterialization(source, nested);
  if (!zero)
    return {};
  llvm::append_range(materializations, nested);
  materializations.push_back(op);
  return zero;
}

static Value
matchZeroMmaAccumulatorTuple(waveamdmachine::TupleFromElementsOp tuple,
                             SmallVectorImpl<Operation *> &materializations) {
  if (tuple.getElements().empty())
    return {};
  SmallVector<Operation *> nested;
  Value zero;
  for (Value element : tuple.getElements()) {
    Value elementZero = matchZeroMmaAccumulatorMaterialization(element, nested);
    if (!elementZero)
      return {};
    if (!zero)
      zero = elementZero;
  }
  llvm::append_range(materializations, nested);
  materializations.push_back(tuple);
  return zero;
}

static Value matchZeroMmaAccumulatorMaterialization(
    Value value, SmallVectorImpl<Operation *> &materializations) {
  if (waveamdmachine::ImmOp imm = value.getDefiningOp<waveamdmachine::ImmOp>())
    return imm.getValue() == 0 ? value : Value{};

  if (waveamdmachine::VMovB32TupleOp mov =
          value.getDefiningOp<waveamdmachine::VMovB32TupleOp>())
    return matchZeroMmaAccumulatorCopy(mov, mov.getSource(), materializations);
  if (waveamdmachine::SMovB32TupleOp mov =
          value.getDefiningOp<waveamdmachine::SMovB32TupleOp>())
    return matchZeroMmaAccumulatorCopy(mov, mov.getSource(), materializations);
  if (waveamdmachine::SMovB32ValueOp mov =
          value.getDefiningOp<waveamdmachine::SMovB32ValueOp>())
    return matchZeroMmaAccumulatorCopy(mov, mov.getSource(), materializations);

  waveamdmachine::TupleFromElementsOp tuple =
      value.getDefiningOp<waveamdmachine::TupleFromElementsOp>();
  if (!tuple)
    return {};
  return matchZeroMmaAccumulatorTuple(tuple, materializations);
}

static Value
foldZeroMmaAccumulator(Value selectedAcc,
                       SmallVectorImpl<Operation *> &foldedMaterializations) {
  SmallVector<Operation *> materializations;
  Value zero =
      matchZeroMmaAccumulatorMaterialization(selectedAcc, materializations);
  if (!zero)
    return selectedAcc;
  llvm::append_range(foldedMaterializations, materializations);
  return zero;
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

struct MachineSelectionFunctionFacts {
  std::optional<unsigned> requiredWaveWidth;
  unsigned maxWorkitemIdAxis = 0;
};

static FailureOr<MachineSelectionFunctionFacts>
collectMachineSelectionFunctionFacts(func::FuncOp func) {
  MachineSelectionFunctionFacts facts;
  FunctionType type = func.getFunctionType();
  if (failed(
          noteTypesWaveWidth(func, type.getInputs(), facts.requiredWaveWidth)))
    return failure();
  if (failed(
          noteTypesWaveWidth(func, type.getResults(), facts.requiredWaveWidth)))
    return failure();

  WalkResult walk = func.walk([&](Operation *op) {
    if (failed(noteOpWaveWidth(op, facts.requiredWaveWidth)))
      return WalkResult::interrupt();
    if (auto workitemId = dyn_cast<WorkitemIdOp>(op))
      facts.maxWorkitemIdAxis = std::max(
          facts.maxWorkitemIdAxis, static_cast<unsigned>(workitemId.getAxis()));
    return WalkResult::advance();
  });
  if (walk.wasInterrupted())
    return failure();
  return facts;
}

static unsigned getMaxWorkitemIdAxis(func::FuncOp func) {
  unsigned maxAxis = 0;
  func.walk([&](WorkitemIdOp op) {
    maxAxis = std::max(maxAxis, static_cast<unsigned>(op.getAxis()));
  });
  return maxAxis;
}

static LogicalResult
validateTargetWaveWidth(func::FuncOp func, unsigned targetWidth,
                        std::optional<unsigned> requiredWaveWidth) {
  if (!requiredWaveWidth || *requiredWaveWidth == targetWidth)
    return success();
  FailureOr<waveamdmachine::AMDGPUTarget> target =
      waveamdmachine::getAMDGPUTarget(func, "WaveAMDMachine selection");
  if (failed(target))
    return failure();
  return func.emitError("WaveAMDMachine backend target ")
         << target->chip << " uses wave" << targetWidth
         << " but function requires wave" << *requiredWaveWidth;
}

static LogicalResult
validateMachineSelectionTarget(WaveAMDMachineSelector &selector) {
  func::FuncOp func = selector.func;
  if (!func.getBody().hasOneBlock())
    return func.emitError("WaveAMDMachine selection supports one-block funcs");
  ModuleOp targetModule = waveamdmachine::findAMDGPUTargetModule(func);
  if (!targetModule) {
    selector.maxWorkitemIdAxis = getMaxWorkitemIdAxis(func);
    // Targetless selection follows the backend's packed default target.
    selector.packedWorkitemIds = selector.maxWorkitemIdAxis != 0;
    return success();
  }
  FailureOr<unsigned> targetWidth =
      waveamdmachine::getAMDGPUWavefrontSize(func, "WaveAMDMachine selection");
  if (failed(targetWidth))
    return failure();
  FailureOr<MachineSelectionFunctionFacts> facts =
      collectMachineSelectionFunctionFacts(func);
  if (failed(facts))
    return failure();
  if (failed(validateTargetWaveWidth(func, *targetWidth,
                                     facts->requiredWaveWidth)))
    return failure();
  selector.maxWorkitemIdAxis = facts->maxWorkitemIdAxis;
  FailureOr<llvm::AMDGPU::IsaVersion> isa =
      getTargetIsaVersion(func, "WaveAMDMachine selection");
  if (failed(isa))
    return failure();
  selector.targetIsaMajor = isa->Major;
  if (selector.maxWorkitemIdAxis != 0) {
    FailureOr<bool> packed =
        hasWaveAMDPackedTID(func, "WaveAMDMachine workitem id selection");
    if (failed(packed))
      return failure();
    selector.packedWorkitemIds = *packed;
  }
  return success();
}

struct DmaIssueDelayConfig {
  std::optional<int64_t> skipThreadThreshold;
  bool enabled = false;
};

static FailureOr<DmaIssueDelayConfig>
getDmaIssueDelayConfig(func::FuncOp func) {
  DmaIssueDelayConfig config;
  WalkResult walk = func.walk([&](waveamd::DmaLoadLdsOp op) {
    if (op->hasAttr("issue_delay_cycles"))
      config.enabled = true;
    IntegerAttr threshold =
        op->getAttrOfType<IntegerAttr>("issue_delay_skip_thread_threshold");
    if (!threshold)
      return WalkResult::advance();
    if (config.skipThreadThreshold &&
        *config.skipThreadThreshold != threshold.getInt()) {
      op.emitOpError("all DMA issue delays must use one skip threshold");
      return WalkResult::interrupt();
    }
    config.skipThreadThreshold = threshold.getInt();
    return WalkResult::advance();
  });
  if (walk.wasInterrupted())
    return failure();
  return config;
}

static void eraseDeadFoldedMmaAccumulatorMaterializations(
    ArrayRef<Operation *> materializations) {
  SmallPtrSet<Operation *, 8> seen;
  for (Operation *op : llvm::reverse(materializations)) {
    if (seen.contains(op) || !op->use_empty())
      continue;
    seen.insert(op);
    op->erase();
  }
}

LogicalResult WaveAMDMachineSelector::run() {
  if (failed(validateMachineSelectionTarget(*this)))
    return failure();
  FailureOr<DmaIssueDelayConfig> delayConfig = getDmaIssueDelayConfig(func);
  if (failed(delayConfig))
    return failure();
  dmaIssueTimingEnabled = delayConfig->enabled;
  dmaIssueSkipThreadThreshold = delayConfig->skipThreadThreshold;

  Block &block = func.getBody().front();
  builder.setInsertionPointToStart(&block);
  for (auto [index, arg] : llvm::enumerate(func.getArguments()))
    materializeArgument(arg, index);

  SmallVector<Operation *> topLevelOps;
  for (Operation &op : llvm::make_early_inc_range(block))
    if (!waveamdmachine::isWaveAMDMachineOp(&op))
      topLevelOps.push_back(&op);

  for (Operation *op : topLevelOps)
    if (failed(selectOperation(op)))
      return failure();

  for (Operation *op : llvm::reverse(opsToErase))
    op->erase();

  eraseDeadFoldedMmaAccumulatorMaterializations(
      foldedMmaAccumulatorMaterializations);

  auto oldType = func.getFunctionType();
  func.setType(
      FunctionType::get(func.getContext(), oldType.getInputs(), TypeRange{}));
  return success();
}

struct IntRange64 {
  int64_t lo = 0;
  int64_t hi = 0;
};

std::optional<ConstantIntRanges>
WaveAMDMachineSelector::finiteSignedRange(Value binding) {
  const dataflow::IntegerValueRangeLattice *lattice =
      rangeSolver.lookupState<dataflow::IntegerValueRangeLattice>(binding);
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

static std::optional<IntRange64> scaleRange64(IntRange64 range, int64_t scale) {
  if (scale == 0)
    return IntRange64{0, 0};
  std::optional<int64_t> lo = llvm::checkedMul(range.lo, scale);
  std::optional<int64_t> hi = llvm::checkedMul(range.hi, scale);
  if (!lo || !hi)
    return std::nullopt;
  if (scale < 0)
    std::swap(lo, hi);
  return IntRange64{*lo, *hi};
}

void WaveAMDMachineSelector::appendBindingAssumptions(
    Value binding, StringRef name,
    SmallVectorImpl<sym::PredHandle> &assumptions, int64_t scale) {
  std::optional<ConstantIntRanges> range = finiteSignedRange(binding);
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
  if (size == 1)
    return extractLowDword(S, loc, value);
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
  if ((size & (size - 1)) == 0) {
    value = S.ensureVGPRForVSrc1(loc, value);
    return waveamdmachine::VLshlrevB32Op::create(
               S.builder, loc, vgprType, value,
               createImm(S.builder, loc, llvm::Log2_32(size)))
        .getResult();
  }
  return waveamdmachine::VMulLoU32Op::create(S.builder, loc, vgprType, value,
                                             createImm(S.builder, loc, size))
      .getResult();
}

static FailureOr<Value> scaleSOffset(WaveAMDMachineSelector &S, Location loc,
                                     Value value, unsigned size) {
  if (!value)
    return Value{};
  if (size == 1)
    return extractLowDword(S, loc, value);
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
  value = S.ensureSGPR1(loc, value);
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

bool WaveAMDMachineSelector::slotFitsU32(sym::Analysis &analysis,
                                         sym::ExprHandle expr) {
  constexpr int64_t max = (int64_t{1} << 32) - 1;
  if (sym::provablyInRange(analysis, expr, 0, max))
    return true;
  FailureOr<sym::ExprHandle> simplified = analysis.simplify(expr);
  return succeeded(simplified) &&
         sym::provablyInRange(analysis, *simplified, 0, max);
}

bool WaveAMDMachineSelector::slotFitsU32(
    sym::ExprHandle expr, ArrayRef<sym::PredHandle> assumptions) {
  SlotFitsU32CacheKey key = {
      expr, llvm::hash_combine_range(assumptions.begin(), assumptions.end())};
  SmallVector<SlotFitsU32CacheEntry, 1> &entries = slotFitsU32Cache[key];
  for (const SlotFitsU32CacheEntry &entry : entries)
    if (llvm::equal(entry.assumptions, assumptions))
      return entry.fits;

  FailureOr<std::unique_ptr<sym::Analysis>> analysis =
      sym::Analysis::create(symbolStore(), assumptions);
  bool fits = succeeded(analysis) && slotFitsU32(**analysis, expr);
  SlotFitsU32CacheEntry &entry = entries.emplace_back();
  llvm::append_range(entry.assumptions, assumptions);
  entry.fits = fits;
  return fits;
}

static bool positiveAddendsFitU32(WaveAMDMachineSelector &S,
                                  sym::ExprHandle expr,
                                  ArrayRef<sym::PredHandle> assumptions) {
  return sym::positiveAddendsFitU32(S.symbolStore(), expr, assumptions);
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
  auto copyFixed = [&](Value v) {
    waveamdmachine::RegType rt = dyn_cast<waveamdmachine::RegType>(v.getType());
    if (!rt || rt.getIndex() < 0 || rt.getWidth() != 1)
      return v;
    if (cls == waveamdmachine::RegClass::VGPR)
      return Value{waveamdmachine::VMovB32TupleOp::create(
          S.builder, loc,
          getRegType(S.builder.getContext(), waveamdmachine::RegClass::VGPR),
          v)};
    if (cls == waveamdmachine::RegClass::SGPR)
      return Value{waveamdmachine::SMovB32ValueOp::create(
          S.builder, loc,
          getRegType(S.builder.getContext(), waveamdmachine::RegClass::SGPR),
          v)};
    return v;
  };
  return waveamdmachine::TupleFromElementsOp::create(
             S.builder, loc, resultType,
             ValueRange{copyFixed(lo), copyFixed(hi)})
      .getTuple();
}

static Value signExtendSGPR2(WaveAMDMachineSelector &S, Location loc, Value v);
static Value signExtendVGPR2(WaveAMDMachineSelector &S, Location loc,
                             Value source, Value selected);

Value ensureSGPR2(WaveAMDMachineSelector &S, Location loc, Value v) {
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
  if (std::optional<int64_t> imm = S.getImmediateValue(v)) {
    uint64_t value = static_cast<uint64_t>(*imm);
    Value lo = S.ensureVGPRForVSrc1(
        loc,
        createImm(S.builder, loc, static_cast<int64_t>(value & 0xffffffffull)));
    Value hi = S.ensureVGPRForVSrc1(
        loc, createImm(S.builder, loc, static_cast<int64_t>(value >> 32)));
    return tuple2(S, loc, waveamdmachine::RegClass::VGPR, lo, hi);
  }
  Value lo = S.ensureVGPRForVSrc1(loc, v);
  Value hi = S.ensureVGPRForVSrc1(loc, createImm(S.builder, loc, 0));
  return tuple2(S, loc, waveamdmachine::RegClass::VGPR, lo, hi);
}

static Value signExtendSGPR2(WaveAMDMachineSelector &S, Location loc, Value v) {
  if (std::optional<int64_t> imm = S.getImmediateValue(v))
    return ensureSGPR2(S, loc, v);
  if (std::optional<Value> lo = zeroExtendedLowDword(S, v))
    v = *lo;
  else if (isSGPR2(v))
    return v;
  Type sgpr1 =
      getRegType(S.builder.getContext(), waveamdmachine::RegClass::SGPR, 1);
  Value lo = S.materializeSGPR1(loc, v);
  Value negative = waveamdmachine::SCmpLtI32Op::create(
      S.builder, loc, getSCCType(S.builder.getContext()), lo,
      createImm(S.builder, loc, 0));
  Value hi = waveamdmachine::SCSelectB32Op::create(
      S.builder, loc, sgpr1, negative, createImm(S.builder, loc, -1),
      createImm(S.builder, loc, 0));
  return tuple2(S, loc, waveamdmachine::RegClass::SGPR, lo, hi);
}

static Value readFirstLane(WaveAMDMachineSelector &S, Location loc,
                           Value value) {
  waveamdmachine::RegType regType =
      dyn_cast<waveamdmachine::RegType>(value.getType());
  if (!regType || regType.getRegClass() != waveamdmachine::RegClass::VGPR)
    return value;
  Type sgpr1 =
      getRegType(S.builder.getContext(), waveamdmachine::RegClass::SGPR, 1);
  if (regType.getWidth() == 1)
    return waveamdmachine::VReadfirstlaneB32Op::create(S.builder, loc, sgpr1,
                                                       value);

  Type vgpr1 =
      getRegType(S.builder.getContext(), waveamdmachine::RegClass::VGPR, 1);
  SmallVector<Type, 2> elementTypes(regType.getWidth(), vgpr1);
  auto split = waveamdmachine::TupleToElementsOp::create(S.builder, loc,
                                                         elementTypes, value);
  SmallVector<Value, 2> words;
  for (Value word : split.getElements())
    words.push_back(waveamdmachine::VReadfirstlaneB32Op::create(S.builder, loc,
                                                                sgpr1, word));
  Type resultType = getRegType(S.builder.getContext(),
                               waveamdmachine::RegClass::SGPR, words.size());
  return waveamdmachine::TupleFromElementsOp::create(S.builder, loc, resultType,
                                                     words)
      .getTuple();
}

Value createWordCmp(WaveAMDMachineSelector &S, Location loc,
                    CmpRelation relation, bool signedCmp, Type resultType,
                    Value lhs, Value rhs);
static Value createVAddU32(WaveAMDMachineSelector &selector, Location loc,
                           Value lhs, Value rhs);

Value extractLowDword(WaveAMDMachineSelector &S, Location loc, Value v,
                      Value source) {
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

static Value createWideBitwiseWord(WaveAMDMachineSelector &S, Location loc,
                                   BinaryKind kind, Type resultType, Value lhs,
                                   Value rhs, bool vgpr) {
  if (vgpr) {
    lhs = S.ensureVGPRForVSrc1(loc, lhs);
    rhs = S.ensureVGPRForVSrc1(loc, rhs);
    if (kind == BinaryKind::AndI)
      return waveamdmachine::VAndB32Op::create(S.builder, loc, resultType, lhs,
                                               rhs);
    return waveamdmachine::VOrB32Op::create(S.builder, loc, resultType, lhs,
                                            rhs);
  }

  Type scc = getSCCType(S.builder.getContext());
  lhs = S.materializeSGPR1(loc, lhs);
  rhs = S.ensureSGPR1(loc, rhs);
  if (kind == BinaryKind::AndI)
    return waveamdmachine::SAndB32Op::create(S.builder, loc, resultType, scc,
                                             lhs, rhs)
        .getResult();
  return waveamdmachine::SOrB32Op::create(S.builder, loc, resultType, scc, lhs,
                                          rhs)
      .getResult();
}

static Value bitwiseWide(WaveAMDMachineSelector &S, Location loc,
                         BinaryKind kind, Value lhs, Value rhs) {
  bool vgpr = isVGPR(lhs) || isVGPR(rhs);
  if (!vgpr) {
    Type resultType =
        getRegType(S.builder.getContext(), waveamdmachine::RegClass::SGPR, 2);
    Type scc = getSCCType(S.builder.getContext());
    lhs = ensureSGPR2(S, loc, lhs);
    rhs = ensureSGPR2(S, loc, rhs);
    if (kind == BinaryKind::AndI)
      return waveamdmachine::SAndB64Op::create(S.builder, loc, resultType, scc,
                                               lhs, rhs)
          .getResult();
    return waveamdmachine::SOrB64Op::create(S.builder, loc, resultType, scc,
                                            lhs, rhs)
        .getResult();
  }

  waveamdmachine::RegClass regClass =
      vgpr ? waveamdmachine::RegClass::VGPR : waveamdmachine::RegClass::SGPR;
  Type wordType = getRegType(S.builder.getContext(), regClass, 1);
  Value lo = createWideBitwiseWord(S, loc, kind, wordType,
                                   extractLowDword(S, loc, lhs),
                                   extractLowDword(S, loc, rhs), vgpr);
  Value hi = createWideBitwiseWord(S, loc, kind, wordType,
                                   extractHighDword(S, loc, lhs),
                                   extractHighDword(S, loc, rhs), vgpr);
  return tuple2(S, loc, regClass, lo, hi);
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

static Value andWideMask(WaveAMDMachineSelector &S, Location loc, Value v,
                         int64_t mask) {
  if (std::optional<int64_t> imm = S.getImmediateValue(v)) {
    uint64_t value = static_cast<uint64_t>(*imm) & static_cast<uint64_t>(mask);
    return createWideImm(S, loc, static_cast<int64_t>(value));
  }
  if (auto mov = v.getDefiningOp<waveamdmachine::SMovB64ImmOp>()) {
    uint64_t value =
        static_cast<uint64_t>(mov.getValue()) & static_cast<uint64_t>(mask);
    return createWideImm(S, loc, static_cast<int64_t>(value));
  }
  bool vgpr = isVGPR(v);
  waveamdmachine::RegClass regClass =
      vgpr ? waveamdmachine::RegClass::VGPR : waveamdmachine::RegClass::SGPR;
  Type wordType = getRegType(S.builder.getContext(), regClass, 1);
  uint64_t maskBits = static_cast<uint64_t>(mask);
  Value loMask =
      createImm(S.builder, loc, static_cast<int64_t>(maskBits & 0xffffffffull));
  Value hiMask =
      createImm(S.builder, loc, static_cast<int64_t>(maskBits >> 32));
  Value lo = createWideBitwiseWord(S, loc, BinaryKind::AndI, wordType,
                                   extractLowDword(S, loc, v), loMask, vgpr);
  Value hi = createWideBitwiseWord(S, loc, BinaryKind::AndI, wordType,
                                   extractHighDword(S, loc, v), hiMask, vgpr);
  return tuple2(S, loc, regClass, lo, hi);
}

struct WideSymbolBinding {
  std::string name;
  Value source;
  Value selected;
};

static TermKind wideMaterializationKind(sym::ExprHandle expr,
                                        ArrayRef<WideSymbolBinding> bindings,
                                        bool symbolsAreUniform);

static unsigned
wideMaterializationLoopDepth(sym::ExprHandle expr, Operation *user,
                             ArrayRef<WideSymbolBinding> bindings);

static bool isHoistScope(Operation *op) { return isa<LoopLikeOpInterface>(op); }

static Operation *scopeOp(Value value) {
  if (Operation *def = value.getDefiningOp())
    return def;
  return cast<BlockArgument>(value).getOwner()->getParentOp();
}

static unsigned valueLoopDepth(Value value, Operation *) {
  Operation *scope = scopeOp(value);
  if (!scope)
    return 0;
  unsigned depth = 0;
  for (Operation *cur = scope; cur; cur = cur->getParentOp())
    if (isHoistScope(cur))
      ++depth;
  return depth;
}

static TermKind
wideSymbolMaterializationKind(sym::ExprHandle expr,
                              ArrayRef<WideSymbolBinding> bindings,
                              bool symbolsAreUniform) {
  StringRef name = sym::ExprView(expr).getSymbolName();
  for (const WideSymbolBinding &binding : bindings)
    if (binding.name == name)
      return symbolsAreUniform ? TermKind::Uniform : TermKind::Lane;
  return TermKind::Lane;
}

static TermKind wideAddMaterializationKind(sym::ExprHandle expr,
                                           ArrayRef<WideSymbolBinding> bindings,
                                           bool symbolsAreUniform) {
  sym::ExprView view(expr);
  TermKind kind = wideMaterializationKind(view.getAddConstant(), bindings,
                                          symbolsAreUniform);
  for (uint32_t i : llvm::seq<uint32_t>(0, view.getAddTermCount())) {
    sym::AddTerm term = view.getAddTerm(i);
    kind = std::max(kind, wideMaterializationKind(term.coefficient, bindings,
                                                  symbolsAreUniform));
    kind = std::max(
        kind, wideMaterializationKind(term.term, bindings, symbolsAreUniform));
  }
  return kind;
}

static TermKind wideMulMaterializationKind(sym::ExprHandle expr,
                                           ArrayRef<WideSymbolBinding> bindings,
                                           bool symbolsAreUniform) {
  sym::ExprView view(expr);
  TermKind kind = wideMaterializationKind(view.getMulCoefficient(), bindings,
                                          symbolsAreUniform);
  for (uint32_t i : llvm::seq<uint32_t>(0, view.getMulFactorCount()))
    kind = std::max(kind, wideMaterializationKind(view.getMulFactor(i).base,
                                                  bindings, symbolsAreUniform));
  return kind;
}

static TermKind wideMaterializationKind(sym::ExprHandle expr,
                                        ArrayRef<WideSymbolBinding> bindings,
                                        bool symbolsAreUniform) {
  sym::ExprView view(expr);
  switch (view.getKind()) {
  case sym::ExprKind::Integer:
  case sym::ExprKind::Rational:
    return TermKind::Const;
  case sym::ExprKind::Symbol:
    return wideSymbolMaterializationKind(expr, bindings, symbolsAreUniform);
  case sym::ExprKind::Add:
    return wideAddMaterializationKind(expr, bindings, symbolsAreUniform);
  case sym::ExprKind::Mul:
    return wideMulMaterializationKind(expr, bindings, symbolsAreUniform);
  case sym::ExprKind::Floor:
  case sym::ExprKind::Ceil:
    return wideMaterializationKind(view.getUnaryArg(), bindings,
                                   symbolsAreUniform);
  case sym::ExprKind::Mod:
  case sym::ExprKind::Xor:
    return std::max(wideMaterializationKind(view.getBinaryLhs(), bindings,
                                            symbolsAreUniform),
                    wideMaterializationKind(view.getBinaryRhs(), bindings,
                                            symbolsAreUniform));
  default:
    return TermKind::Lane;
  }
}

static unsigned
wideSymbolMaterializationLoopDepth(sym::ExprHandle expr, Operation *user,
                                   ArrayRef<WideSymbolBinding> bindings) {
  StringRef name = sym::ExprView(expr).getSymbolName();
  for (const WideSymbolBinding &binding : bindings)
    if (binding.name == name)
      return valueLoopDepth(binding.selected, user);
  return std::numeric_limits<unsigned>::max();
}

static unsigned
wideAddMaterializationLoopDepth(sym::ExprHandle expr, Operation *user,
                                ArrayRef<WideSymbolBinding> bindings) {
  sym::ExprView view(expr);
  unsigned depth =
      wideMaterializationLoopDepth(view.getAddConstant(), user, bindings);
  for (uint32_t i : llvm::seq<uint32_t>(0, view.getAddTermCount())) {
    sym::AddTerm term = view.getAddTerm(i);
    depth = std::max(
        depth, wideMaterializationLoopDepth(term.coefficient, user, bindings));
    depth = std::max(depth,
                     wideMaterializationLoopDepth(term.term, user, bindings));
  }
  return depth;
}

static unsigned
wideMulMaterializationLoopDepth(sym::ExprHandle expr, Operation *user,
                                ArrayRef<WideSymbolBinding> bindings) {
  sym::ExprView view(expr);
  unsigned depth =
      wideMaterializationLoopDepth(view.getMulCoefficient(), user, bindings);
  for (uint32_t i : llvm::seq<uint32_t>(0, view.getMulFactorCount()))
    depth = std::max(depth, wideMaterializationLoopDepth(
                                view.getMulFactor(i).base, user, bindings));
  return depth;
}

static unsigned
wideMaterializationLoopDepth(sym::ExprHandle expr, Operation *user,
                             ArrayRef<WideSymbolBinding> bindings) {
  sym::ExprView view(expr);
  switch (view.getKind()) {
  case sym::ExprKind::Integer:
  case sym::ExprKind::Rational:
    return 0;
  case sym::ExprKind::Symbol:
    return wideSymbolMaterializationLoopDepth(expr, user, bindings);
  case sym::ExprKind::Add:
    return wideAddMaterializationLoopDepth(expr, user, bindings);
  case sym::ExprKind::Mul:
    return wideMulMaterializationLoopDepth(expr, user, bindings);
  case sym::ExprKind::Floor:
  case sym::ExprKind::Ceil:
    return wideMaterializationLoopDepth(view.getUnaryArg(), user, bindings);
  case sym::ExprKind::Mod:
  case sym::ExprKind::Xor:
    return std::max(
        wideMaterializationLoopDepth(view.getBinaryLhs(), user, bindings),
        wideMaterializationLoopDepth(view.getBinaryRhs(), user, bindings));
  default:
    return std::numeric_limits<unsigned>::max();
  }
}

struct OrderedWideAddTerm {
  sym::AddTerm term;
  TermKind kind = TermKind::Lane;
  unsigned loopDepth = 0;
};

struct OrderedWideMulFactor {
  sym::MulFactor factor;
  TermKind kind = TermKind::Lane;
  unsigned loopDepth = 0;
};

static unsigned termKindRank(TermKind kind, IndexExprAddOrder addOrder) {
  if (addOrder == IndexExprAddOrder::UniformFirst)
    return static_cast<unsigned>(kind);
  switch (kind) {
  case TermKind::Lane:
    return 0;
  case TermKind::Const:
    return 1;
  case TermKind::Uniform:
    return 2;
  }
  llvm_unreachable("unknown term kind");
}

static bool orderedBefore(TermKind lhsKind, unsigned lhsDepth, TermKind rhsKind,
                          unsigned rhsDepth, IndexExprAddOrder addOrder) {
  unsigned lhsRank = termKindRank(lhsKind, addOrder);
  unsigned rhsRank = termKindRank(rhsKind, addOrder);
  if (lhsRank != rhsRank)
    return lhsRank < rhsRank;
  if (lhsDepth != rhsDepth)
    return lhsDepth < rhsDepth;
  return false;
}

static SmallVector<OrderedWideAddTerm, 8>
collectOrderedWideAddTerms(sym::ExprHandle expr, Operation *user,
                           ArrayRef<WideSymbolBinding> bindings,
                           bool symbolsAreUniform, IndexExprAddOrder addOrder) {
  sym::ExprView view(expr);
  SmallVector<OrderedWideAddTerm, 8> terms;
  terms.reserve(view.getAddTermCount());
  for (uint32_t i : llvm::seq<uint32_t>(0, view.getAddTermCount())) {
    sym::AddTerm term = view.getAddTerm(i);
    TermKind kind = std::max(
        wideMaterializationKind(term.coefficient, bindings, symbolsAreUniform),
        wideMaterializationKind(term.term, bindings, symbolsAreUniform));
    unsigned depth =
        std::max(wideMaterializationLoopDepth(term.coefficient, user, bindings),
                 wideMaterializationLoopDepth(term.term, user, bindings));
    terms.push_back({term, kind, depth});
  }
  llvm::stable_sort(terms, [addOrder](const OrderedWideAddTerm &lhs,
                                      const OrderedWideAddTerm &rhs) {
    return orderedBefore(lhs.kind, lhs.loopDepth, rhs.kind, rhs.loopDepth,
                         addOrder);
  });
  return terms;
}

static SmallVector<OrderedWideMulFactor, 8>
collectOrderedWideMulFactors(sym::ExprHandle expr, Operation *user,
                             ArrayRef<WideSymbolBinding> bindings,
                             bool symbolsAreUniform) {
  sym::ExprView view(expr);
  SmallVector<OrderedWideMulFactor, 8> factors;
  factors.reserve(view.getMulFactorCount());
  for (uint32_t i : llvm::seq<uint32_t>(0, view.getMulFactorCount())) {
    sym::MulFactor factor = view.getMulFactor(i);
    factors.push_back(
        {factor,
         wideMaterializationKind(factor.base, bindings, symbolsAreUniform),
         wideMaterializationLoopDepth(factor.base, user, bindings)});
  }
  llvm::stable_sort(factors, [](const OrderedWideMulFactor &lhs,
                                const OrderedWideMulFactor &rhs) {
    return orderedBefore(lhs.kind, lhs.loopDepth, rhs.kind, rhs.loopDepth,
                         IndexExprAddOrder::UniformFirst);
  });
  return factors;
}

struct WideMaterializationContext {
  WideMaterializationContext(WaveAMDMachineSelector &selector,
                             ArrayRef<sym::PredHandle> assumptions)
      : assumptions(assumptions), selector(selector) {}

  std::unique_ptr<sym::Analysis> analysis;
  ArrayRef<sym::PredHandle> assumptions;
  WaveAMDMachineSelector &selector;

  sym::Analysis *getAnalysis() {
    if (analysis)
      return analysis.get();
    FailureOr<std::unique_ptr<sym::Analysis>> created =
        sym::Analysis::create(selector.symbolStore(), assumptions);
    if (failed(created))
      return nullptr;
    analysis = std::move(*created);
    return analysis.get();
  }

  void resetAnalysis() { analysis.reset(); }
};

static FailureOr<Value> materializeWideIndexExprNode(
    WaveAMDMachineSelector &S, WideMaterializationContext &context,
    sym::ExprHandle expr, Operation *user, ArrayRef<WideSymbolBinding> bindings,
    bool symbolsAreUniform = false,
    IndexExprAddOrder addOrder = IndexExprAddOrder::UniformFirst);

static FailureOr<Value> materializeWideIndexExprNode(
    WaveAMDMachineSelector &S, sym::ExprHandle expr, Operation *user,
    ArrayRef<WideSymbolBinding> bindings, ArrayRef<sym::PredHandle> assumptions,
    bool symbolsAreUniform = false,
    IndexExprAddOrder addOrder = IndexExprAddOrder::UniformFirst);

struct WideRationalValue {
  Value numerator;
  int64_t denominator = 1;
};

static FailureOr<WideRationalValue> materializeWideRationalIndexExprNode(
    WaveAMDMachineSelector &S, WideMaterializationContext &context,
    sym::ExprHandle expr, Operation *user, ArrayRef<WideSymbolBinding> bindings,
    bool symbolsAreUniform = false);

static FailureOr<Value> materializeWideAddTerm(
    WaveAMDMachineSelector &S, WideMaterializationContext &context,
    sym::AddTerm addTerm, Operation *user, ArrayRef<WideSymbolBinding> bindings,
    bool symbolsAreUniform, IndexExprAddOrder addOrder) {
  FailureOr<Value> term = materializeWideIndexExprNode(
      S, context, addTerm.term, user, bindings, symbolsAreUniform, addOrder);
  if (failed(term))
    return failure();
  std::optional<int64_t> coeffInt = staticIntLiteral(addTerm.coefficient);
  if (coeffInt && *coeffInt == 1)
    return *term;
  FailureOr<Value> coeffValue =
      materializeWideIndexExprNode(S, context, addTerm.coefficient, user,
                                   bindings, symbolsAreUniform, addOrder);
  if (failed(coeffValue))
    return failure();
  return mulWide(S, user->getLoc(), *coeffValue, *term);
}

static void appendWideAdd(WaveAMDMachineSelector &S, Location loc, Value value,
                          std::optional<Value> &acc) {
  acc = acc ? addWide(S, loc, *acc, value) : value;
}

static Value createWideZero(WaveAMDMachineSelector &S, Location loc) {
  return waveamdmachine::SMovB64ImmOp::create(
             S.builder, loc,
             getRegType(S.builder.getContext(), waveamdmachine::RegClass::SGPR,
                        2),
             S.builder.getI64IntegerAttr(0))
      .getResult();
}

static LogicalResult materializeWideLaneFirstAddConstant(
    WaveAMDMachineSelector &S, WideMaterializationContext &context,
    Operation *user, sym::ExprHandle coeff,
    ArrayRef<WideSymbolBinding> bindings, bool symbolsAreUniform,
    std::optional<Value> &uniformAcc) {
  std::optional<int64_t> coeffInt = staticIntLiteral(coeff);
  if (!coeffInt || *coeffInt != 0) {
    FailureOr<Value> seed = materializeWideIndexExprNode(
        S, context, coeff, user, bindings, symbolsAreUniform,
        IndexExprAddOrder::LaneFirst);
    if (failed(seed))
      return failure();
    appendWideAdd(S, user->getLoc(), *seed, uniformAcc);
  }
  return success();
}

static LogicalResult appendWideLaneFirstAddTerm(
    WaveAMDMachineSelector &S, WideMaterializationContext &context,
    Operation *user, const OrderedWideAddTerm &ordered,
    ArrayRef<WideSymbolBinding> bindings, bool symbolsAreUniform,
    std::optional<Value> &laneAcc, std::optional<Value> &uniformAcc) {
  FailureOr<Value> term =
      materializeWideAddTerm(S, context, ordered.term, user, bindings,
                             symbolsAreUniform, IndexExprAddOrder::LaneFirst);
  if (failed(term))
    return failure();
  if (ordered.kind == TermKind::Lane)
    appendWideAdd(S, user->getLoc(), *term, laneAcc);
  else
    appendWideAdd(S, user->getLoc(), *term, uniformAcc);
  return success();
}

static Value finalizeWideLaneFirstAdd(WaveAMDMachineSelector &S, Location loc,
                                      std::optional<Value> laneAcc,
                                      std::optional<Value> uniformAcc) {
  if (laneAcc && uniformAcc)
    return addWide(S, loc, *uniformAcc, *laneAcc);
  if (laneAcc)
    return *laneAcc;
  if (uniformAcc)
    return *uniformAcc;
  return createWideZero(S, loc);
}

static FailureOr<Value> materializeWideAddLaneFirst(
    WaveAMDMachineSelector &S, WideMaterializationContext &context,
    sym::ExprHandle expr, Operation *user, ArrayRef<WideSymbolBinding> bindings,
    bool symbolsAreUniform) {
  sym::ExprView view(expr);
  std::optional<Value> laneAcc;
  std::optional<Value> uniformAcc;
  if (failed(materializeWideLaneFirstAddConstant(
          S, context, user, view.getAddConstant(), bindings, symbolsAreUniform,
          uniformAcc)))
    return failure();
  SmallVector<OrderedWideAddTerm, 8> terms = collectOrderedWideAddTerms(
      expr, user, bindings, symbolsAreUniform, IndexExprAddOrder::LaneFirst);
  for (const OrderedWideAddTerm &ordered : terms)
    if (failed(appendWideLaneFirstAddTerm(S, context, user, ordered, bindings,
                                          symbolsAreUniform, laneAcc,
                                          uniformAcc)))
      return failure();
  return finalizeWideLaneFirstAdd(S, user->getLoc(), laneAcc, uniformAcc);
}

static FailureOr<Value> materializeWideAddUniformFirst(
    WaveAMDMachineSelector &S, WideMaterializationContext &context,
    sym::ExprHandle expr, Operation *user, ArrayRef<WideSymbolBinding> bindings,
    bool symbolsAreUniform) {
  Location loc = user->getLoc();
  sym::ExprView view(expr);
  std::optional<Value> acc;
  sym::ExprHandle coeff = view.getAddConstant();
  std::optional<int64_t> coeffInt = staticIntLiteral(coeff);
  if (!coeffInt || *coeffInt != 0) {
    FailureOr<Value> seed = materializeWideIndexExprNode(
        S, context, coeff, user, bindings, symbolsAreUniform);
    if (failed(seed))
      return failure();
    acc = *seed;
  }
  SmallVector<OrderedWideAddTerm, 8> terms = collectOrderedWideAddTerms(
      expr, user, bindings, symbolsAreUniform, IndexExprAddOrder::UniformFirst);
  for (const OrderedWideAddTerm &ordered : terms) {
    FailureOr<Value> term = materializeWideAddTerm(
        S, context, ordered.term, user, bindings, symbolsAreUniform,
        IndexExprAddOrder::UniformFirst);
    if (failed(term))
      return failure();
    acc = acc ? addWide(S, loc, *acc, *term) : std::optional<Value>{*term};
  }
  if (acc)
    return *acc;
  return createWideZero(S, loc);
}

static FailureOr<Value>
materializeWideAdd(WaveAMDMachineSelector &S,
                   WideMaterializationContext &context, sym::ExprHandle expr,
                   Operation *user, ArrayRef<WideSymbolBinding> bindings,
                   bool symbolsAreUniform, IndexExprAddOrder addOrder) {
  if (addOrder == IndexExprAddOrder::LaneFirst)
    return materializeWideAddLaneFirst(S, context, expr, user, bindings,
                                       symbolsAreUniform);
  return materializeWideAddUniformFirst(S, context, expr, user, bindings,
                                        symbolsAreUniform);
}

static FailureOr<Value>
materializeWideMulFactor(WaveAMDMachineSelector &S,
                         WideMaterializationContext &context,
                         sym::MulFactor factor, Operation *user,
                         ArrayRef<WideSymbolBinding> bindings,
                         bool symbolsAreUniform, IndexExprAddOrder addOrder) {
  int32_t exp = factor.exponent;
  if (exp <= 0)
    return user->emitError(
        "full-address index_expr rejects non-positive mul exponent");
  FailureOr<Value> base = materializeWideIndexExprNode(
      S, context, factor.base, user, bindings, symbolsAreUniform, addOrder);
  if (failed(base))
    return failure();
  Value pow = *base;
  for (int32_t e = 1; e < exp; ++e)
    pow = mulWide(S, user->getLoc(), pow, *base);
  return pow;
}

static FailureOr<Value>
materializeWideMul(WaveAMDMachineSelector &S,
                   WideMaterializationContext &context, sym::ExprHandle expr,
                   Operation *user, ArrayRef<WideSymbolBinding> bindings,
                   bool symbolsAreUniform, IndexExprAddOrder addOrder) {
  Location loc = user->getLoc();
  sym::ExprView view(expr);
  std::optional<Value> acc;
  sym::ExprHandle coeff = view.getMulCoefficient();
  std::optional<int64_t> coeffInt = staticIntLiteral(coeff);
  if (!coeffInt || *coeffInt != 1) {
    FailureOr<Value> seed = materializeWideIndexExprNode(
        S, context, coeff, user, bindings, symbolsAreUniform, addOrder);
    if (failed(seed))
      return failure();
    acc = *seed;
  }
  SmallVector<OrderedWideMulFactor, 8> factors =
      collectOrderedWideMulFactors(expr, user, bindings, symbolsAreUniform);
  for (const OrderedWideMulFactor &ordered : factors) {
    FailureOr<Value> factor =
        materializeWideMulFactor(S, context, ordered.factor, user, bindings,
                                 symbolsAreUniform, addOrder);
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

static bool isWideBindingNonNegative(WaveAMDMachineSelector &S,
                                     const WideSymbolBinding &binding) {
  if (std::optional<int64_t> imm = S.getImmediateValue(binding.selected))
    return *imm >= 0;
  if (auto mov = binding.selected.getDefiningOp<waveamdmachine::SMovB64ImmOp>())
    return static_cast<int64_t>(mov.getValue()) >= 0;
  std::optional<ConstantIntRanges> range = S.finiteSignedRange(binding.source);
  return range && !range->smin().isNegative();
}

static bool isSignedNarrowBinding(Value source) {
  Type type = source.getType();
  if (auto simd = dyn_cast<SimdType>(type))
    type = simd.getElementType();
  if (type.isIndex())
    return true;
  auto intType = dyn_cast<IntegerType>(type);
  return intType && intType.isSignless() && intType.getWidth() < 64;
}

static FailureOr<Value> materializeWideBinding(WaveAMDMachineSelector &S,
                                               Location loc,
                                               const WideSymbolBinding &binding,
                                               bool symbolsAreUniform) {
  if (!isSignedNarrowBinding(binding.source) ||
      isWideBindingNonNegative(S, binding)) {
    if (symbolsAreUniform)
      return ensureSGPR2(S, loc, binding.selected);
    return ensureVGPR2(S, loc, binding.selected);
  }
  if (symbolsAreUniform)
    return signExtendSGPR2(S, loc, binding.selected);
  return signExtendVGPR2(S, loc, binding.source, binding.selected);
}

static FailureOr<Value>
materializeWideSymbol(WaveAMDMachineSelector &S, sym::ExprHandle expr,
                      Operation *user, ArrayRef<WideSymbolBinding> bindings,
                      bool symbolsAreUniform) {
  StringRef name = sym::ExprView(expr).getSymbolName();
  for (const WideSymbolBinding &binding : bindings)
    if (binding.name == name)
      return materializeWideBinding(S, user->getLoc(), binding,
                                    symbolsAreUniform);
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

static std::optional<int64_t> getStaticWideInt(WaveAMDMachineSelector &S,
                                               Value value) {
  if (std::optional<int64_t> imm = S.getImmediateValue(value))
    return imm;
  if (auto mov = value.getDefiningOp<waveamdmachine::SMovB64ImmOp>())
    return mov.getValue();
  return std::nullopt;
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
materializeWideXor(WaveAMDMachineSelector &S,
                   WideMaterializationContext &context, sym::ExprHandle expr,
                   Operation *user, ArrayRef<WideSymbolBinding> bindings,
                   bool symbolsAreUniform, IndexExprAddOrder addOrder) {
  sym::ExprView view(expr);
  FailureOr<Value> lhs =
      materializeWideIndexExprNode(S, context, view.getBinaryLhs(), user,
                                   bindings, symbolsAreUniform, addOrder);
  FailureOr<Value> rhs =
      materializeWideIndexExprNode(S, context, view.getBinaryRhs(), user,
                                   bindings, symbolsAreUniform, addOrder);
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

static bool isPositivePowerOfTwo(int64_t value) {
  return value > 0 && (value & (value - 1)) == 0;
}

static FailureOr<WideRationalValue> materializeWideRationalAdd(
    WaveAMDMachineSelector &S, WideMaterializationContext &context,
    sym::ExprHandle expr, Operation *user, ArrayRef<WideSymbolBinding> bindings,
    bool symbolsAreUniform) {
  Location loc = user->getLoc();
  sym::ExprView view(expr);
  FailureOr<WideRationalValue> constant = materializeWideRationalIndexExprNode(
      S, context, view.getAddConstant(), user, bindings, symbolsAreUniform);
  if (failed(constant))
    return failure();
  WideRationalValue acc = *constant;
  for (uint32_t i : llvm::seq<uint32_t>(0, view.getAddTermCount())) {
    sym::AddTerm term = view.getAddTerm(i);
    FailureOr<WideRationalValue> coefficient =
        materializeWideRationalIndexExprNode(S, context, term.coefficient, user,
                                             bindings, symbolsAreUniform);
    FailureOr<WideRationalValue> value = materializeWideRationalIndexExprNode(
        S, context, term.term, user, bindings, symbolsAreUniform);
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
    WaveAMDMachineSelector &S, WideMaterializationContext &context,
    sym::ExprHandle expr, Operation *user, ArrayRef<WideSymbolBinding> bindings,
    bool symbolsAreUniform) {
  Location loc = user->getLoc();
  sym::ExprView view(expr);
  FailureOr<WideRationalValue> coefficient =
      materializeWideRationalIndexExprNode(S, context, view.getMulCoefficient(),
                                           user, bindings, symbolsAreUniform);
  if (failed(coefficient))
    return failure();
  WideRationalValue acc = *coefficient;
  for (uint32_t i : llvm::seq<uint32_t>(0, view.getMulFactorCount())) {
    sym::MulFactor factor = view.getMulFactor(i);
    if (factor.exponent <= 0)
      return user->emitError("full-address index_expr rational rejects "
                             "non-positive mul exponent");
    FailureOr<WideRationalValue> base = materializeWideRationalIndexExprNode(
        S, context, factor.base, user, bindings, symbolsAreUniform);
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

static FailureOr<int64_t> getStaticWideModDivisor(WaveAMDMachineSelector &S,
                                                  WideRationalValue lhs,
                                                  WideRationalValue rhs,
                                                  Operation *user) {
  std::optional<int64_t> rhsNum = getStaticWideInt(S, rhs.numerator);
  if (rhs.denominator != 1 || !rhsNum)
    return user->emitError(
        "full-address index_expr mod needs a static integer divisor");
  std::optional<int64_t> divisor = llvm::checkedMul(lhs.denominator, *rhsNum);
  if (!divisor || *divisor <= 0)
    return user->emitError(
        "full-address index_expr mod needs a positive static integer divisor");
  return *divisor;
}

static FailureOr<Value> materializeNarrowModAsWide(
    WaveAMDMachineSelector &S, WideMaterializationContext &context,
    sym::ExprHandle expr, Operation *user, ArrayRef<WideSymbolBinding> bindings,
    bool symbolsAreUniform, IndexExprAddOrder addOrder) {
  llvm::DenseSet<StringRef> liveSymbols;
  sym::walkSymbolNames(expr, [&](StringRef name) { liveSymbols.insert(name); });
  llvm::StringMap<Value> subs;
  for (const WideSymbolBinding &binding : bindings) {
    if (!liveSymbols.contains(binding.name))
      continue;
    std::optional<Value> low = zeroExtendedLowDword(S, binding.selected);
    if (!low)
      return user->emitError("full-address index_expr non-power-of-two mod "
                             "needs 32-bit bindings");
    subs[binding.name] = *low;
  }
  context.resetAnalysis();
  FailureOr<Value> value = materializeIndexExprNode(
      S, expr, user, subs, context.assumptions, addOrder);
  if (failed(value))
    return failure();
  if (symbolsAreUniform)
    return ensureSGPR2(S, user->getLoc(), *value);
  return ensureVGPR2(S, user->getLoc(), *value);
}

static FailureOr<WideRationalValue> materializeWideRationalMod(
    WaveAMDMachineSelector &S, WideMaterializationContext &context,
    sym::ExprHandle expr, Operation *user, ArrayRef<WideSymbolBinding> bindings,
    bool symbolsAreUniform) {
  sym::ExprView view(expr);
  FailureOr<WideRationalValue> lhs = materializeWideRationalIndexExprNode(
      S, context, view.getBinaryLhs(), user, bindings, symbolsAreUniform);
  FailureOr<WideRationalValue> rhs = materializeWideRationalIndexExprNode(
      S, context, view.getBinaryRhs(), user, bindings, symbolsAreUniform);
  if (failed(lhs) || failed(rhs))
    return failure();
  FailureOr<int64_t> divisor = getStaticWideModDivisor(S, *lhs, *rhs, user);
  if (failed(divisor))
    return failure();
  if (!isPositivePowerOfTwo(*divisor)) {
    if (lhs->denominator != 1)
      return user->emitError("full-address index_expr non-power-of-two mod "
                             "needs an integer-valued lhs");
    FailureOr<Value> value = materializeNarrowModAsWide(
        S, context, expr, user, bindings, symbolsAreUniform,
        IndexExprAddOrder::UniformFirst);
    if (failed(value))
      return failure();
    return WideRationalValue{*value, 1};
  }
  Value numerator =
      andWideMask(S, user->getLoc(), lhs->numerator, *divisor - 1);
  return WideRationalValue{numerator, lhs->denominator};
}

static FailureOr<WideRationalValue> materializeWideIntegerRational(
    WaveAMDMachineSelector &S, WideMaterializationContext &context,
    sym::ExprHandle expr, Operation *user, ArrayRef<WideSymbolBinding> bindings,
    bool symbolsAreUniform) {
  FailureOr<Value> value = materializeWideIndexExprNode(
      S, context, expr, user, bindings, symbolsAreUniform);
  if (failed(value))
    return failure();
  return WideRationalValue{*value, 1};
}

static FailureOr<WideRationalValue> materializeWideRationalPrimitive(
    WaveAMDMachineSelector &S, sym::ExprHandle expr, Operation *user,
    ArrayRef<WideSymbolBinding> bindings, bool symbolsAreUniform) {
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
    WaveAMDMachineSelector &S, WideMaterializationContext &context,
    sym::ExprHandle expr, Operation *user, ArrayRef<WideSymbolBinding> bindings,
    bool symbolsAreUniform) {
  sym::ExprView view(expr);
  switch (view.getKind()) {
  case sym::ExprKind::Add:
    return materializeWideRationalAdd(S, context, expr, user, bindings,
                                      symbolsAreUniform);
  case sym::ExprKind::Mul:
    return materializeWideRationalMul(S, context, expr, user, bindings,
                                      symbolsAreUniform);
  case sym::ExprKind::Mod:
    return materializeWideRationalMod(S, context, expr, user, bindings,
                                      symbolsAreUniform);
  case sym::ExprKind::Xor:
  case sym::ExprKind::Floor:
  case sym::ExprKind::Ceil:
    return materializeWideIntegerRational(S, context, expr, user, bindings,
                                          symbolsAreUniform);
  default:
    break;
  }
  return user->emitError("full-address index_expr rational unsupported "
                         "expression kind ")
         << static_cast<int>(view.getKind());
}

static FailureOr<WideRationalValue> materializeWideRationalIndexExprNode(
    WaveAMDMachineSelector &S, WideMaterializationContext &context,
    sym::ExprHandle expr, Operation *user, ArrayRef<WideSymbolBinding> bindings,
    bool symbolsAreUniform) {
  sym::ExprKind kind = sym::ExprView(expr).getKind();
  if (kind == sym::ExprKind::Integer || kind == sym::ExprKind::Rational ||
      kind == sym::ExprKind::Symbol)
    return materializeWideRationalPrimitive(S, expr, user, bindings,
                                            symbolsAreUniform);
  return materializeWideRationalCompound(S, context, expr, user, bindings,
                                         symbolsAreUniform);
}

static bool hasNonNegativeLowerBound(const sym::InferredRange &range) {
  return range.lower && range.lower->denominator > 0 &&
         range.lower->numerator >= 0;
}

static bool isProvablyNonNegativeForWideShift(sym::Analysis &analysis,
                                              sym::ExprHandle expr) {
  std::optional<sym::InferredRange> range = analysis.range(expr);
  if (range && hasNonNegativeLowerBound(*range))
    return true;
  FailureOr<sym::ExprHandle> zero = analysis.composeInteger(0);
  if (failed(zero))
    return false;
  FailureOr<sym::PredHandle> nonNegative =
      analysis.compare(expr, sym::PredCmpOp::Ge, *zero);
  return succeeded(nonNegative) &&
         analysis.check(*nonNegative) == sym::CheckResult::True;
}

static LogicalResult
requireWideNonNegativeRoundedExpr(WideMaterializationContext &context,
                                  sym::ExprHandle sourceExpr, Operation *user,
                                  StringRef opName) {
  sym::Analysis *analysis = context.getAnalysis();
  if (analysis && isProvablyNonNegativeForWideShift(*analysis, sourceExpr))
    return success();
  return user->emitError("full-address index_expr ")
         << opName << " shift lowering needs nonnegative operand";
}

static FailureOr<Value> materializeWideRounded(
    WaveAMDMachineSelector &S, WideMaterializationContext &context,
    sym::ExprHandle expr, Operation *user, ArrayRef<WideSymbolBinding> bindings,
    bool isCeil, bool symbolsAreUniform) {
  sym::ExprHandle childExpr = sym::ExprView(expr).getUnaryArg();
  FailureOr<WideRationalValue> child = materializeWideRationalIndexExprNode(
      S, context, childExpr, user, bindings, symbolsAreUniform);
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
  if (failed(
          requireWideNonNegativeRoundedExpr(context, childExpr, user, opName)))
    return failure();
  Value numerator = child->numerator;
  if (isCeil)
    numerator = addWide(S, user->getLoc(), numerator,
                        createWideImm(S, user->getLoc(), den - 1));
  return lshrWidePow2(S, user->getLoc(), numerator, llvm::Log2_64(den));
}

static FailureOr<Value>
materializeWideMod(WaveAMDMachineSelector &S,
                   WideMaterializationContext &context, sym::ExprHandle expr,
                   Operation *user, ArrayRef<WideSymbolBinding> bindings,
                   bool symbolsAreUniform, IndexExprAddOrder addOrder) {
  sym::ExprView view(expr);
  FailureOr<WideRationalValue> lhs = materializeWideRationalIndexExprNode(
      S, context, view.getBinaryLhs(), user, bindings, symbolsAreUniform);
  FailureOr<WideRationalValue> rhs = materializeWideRationalIndexExprNode(
      S, context, view.getBinaryRhs(), user, bindings, symbolsAreUniform);
  if (failed(lhs) || failed(rhs))
    return failure();
  FailureOr<int64_t> divisor = getStaticWideModDivisor(S, *lhs, *rhs, user);
  if (failed(divisor))
    return failure();
  if (!isPositivePowerOfTwo(*divisor))
    return materializeNarrowModAsWide(S, context, expr, user, bindings,
                                      symbolsAreUniform, addOrder);
  sym::Analysis *analysis = context.getAnalysis();
  if (!analysis ||
      analysis->integerValued(view.getBinaryLhs()) != sym::CheckResult::True)
    return user->emitError(
        "full-address index_expr mod needs an integer-valued lhs");
  Value numerator =
      andWideMask(S, user->getLoc(), lhs->numerator, *divisor - 1);
  return lshrWidePow2(S, user->getLoc(), numerator,
                      llvm::Log2_64(lhs->denominator));
}

static FailureOr<Value> materializeWidePrimitiveIndexExprNode(
    WaveAMDMachineSelector &S, sym::ExprHandle expr, Operation *user,
    ArrayRef<WideSymbolBinding> bindings, bool symbolsAreUniform) {
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
    WaveAMDMachineSelector &S, WideMaterializationContext &context,
    sym::ExprHandle expr, Operation *user, ArrayRef<WideSymbolBinding> bindings,
    bool symbolsAreUniform, IndexExprAddOrder addOrder) {
  sym::ExprView view(expr);
  switch (view.getKind()) {
  case sym::ExprKind::Add:
    return materializeWideAdd(S, context, expr, user, bindings,
                              symbolsAreUniform, addOrder);
  case sym::ExprKind::Mul:
    return materializeWideMul(S, context, expr, user, bindings,
                              symbolsAreUniform, addOrder);
  case sym::ExprKind::Xor:
    return materializeWideXor(S, context, expr, user, bindings,
                              symbolsAreUniform, addOrder);
  case sym::ExprKind::Floor:
    return materializeWideRounded(S, context, expr, user, bindings,
                                  /*isCeil=*/false, symbolsAreUniform);
  case sym::ExprKind::Ceil:
    return materializeWideRounded(S, context, expr, user, bindings,
                                  /*isCeil=*/true, symbolsAreUniform);
  case sym::ExprKind::Mod:
    return materializeWideMod(S, context, expr, user, bindings,
                              symbolsAreUniform, addOrder);
  default:
    break;
  }
  return user->emitError("full-address index_expr unsupported expression kind ")
         << static_cast<int>(view.getKind());
}

static FailureOr<Value> materializeWideIndexExprNode(
    WaveAMDMachineSelector &S, WideMaterializationContext &context,
    sym::ExprHandle expr, Operation *user, ArrayRef<WideSymbolBinding> bindings,
    bool symbolsAreUniform, IndexExprAddOrder addOrder) {
  sym::ExprKind kind = sym::ExprView(expr).getKind();
  if (kind == sym::ExprKind::Integer || kind == sym::ExprKind::Rational ||
      kind == sym::ExprKind::Symbol)
    return materializeWidePrimitiveIndexExprNode(S, expr, user, bindings,
                                                 symbolsAreUniform);
  return materializeWideCompoundIndexExprNode(S, context, expr, user, bindings,
                                              symbolsAreUniform, addOrder);
}

static FailureOr<Value> materializeWideIndexExprNode(
    WaveAMDMachineSelector &S, sym::ExprHandle expr, Operation *user,
    ArrayRef<WideSymbolBinding> bindings, ArrayRef<sym::PredHandle> assumptions,
    bool symbolsAreUniform, IndexExprAddOrder addOrder) {
  WideMaterializationContext context(S, assumptions);
  return materializeWideIndexExprNode(S, context, expr, user, bindings,
                                      symbolsAreUniform, addOrder);
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
  SmallVector<WideSymbolBinding, 4> bindings;
  for (const PointerOffsetBinding &binding : offset.bindings)
    bindings.push_back(
        {binding.name, binding.value, S.expect(binding.value, user)});
  return materializeWideIndexExprNode(S, offset.expr, user, bindings,
                                      offset.assumptions);
}

static FailureOr<Value> materializeUniformPointerOffsetWideValue(
    WaveAMDMachineSelector &S, Operation *user, const PointerOffset &offset) {
  if (!offset.expr)
    return createWideImm(S, user->getLoc(), 0);
  SmallVector<WideSymbolBinding, 4> bindings;
  for (const PointerOffsetBinding &binding : offset.bindings)
    bindings.push_back(
        {binding.name, binding.value, S.expect(binding.value, user)});
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
  SmallVector<WideSymbolBinding, 4> wide;
};

static AddressPlanBindings
materializeAddressPlanBindings(WaveAMDMachineSelector &S, Operation *user,
                               const AddressPlan &plan) {
  AddressPlanBindings out;
  for (const PointerOffsetBinding &binding : plan.bindings) {
    Value mapped = S.expect(binding.value, user);
    out.narrow[binding.name] = mapped;
    out.wide.push_back({binding.name, binding.value, mapped});
  }
  return out;
}

static FailureOr<sym::ExprHandle> appendAddressExpr(WaveAMDMachineSelector &S,
                                                    sym::ExprHandle lhs,
                                                    sym::ExprHandle rhs) {
  if (!lhs)
    return rhs;
  if (!rhs)
    return lhs;
  FailureOr<sym::ExprHandle> expr =
      sym::composeExprBinary(S.symbolStore(), lhs, sym::ExprBinaryOp::Add, rhs);
  return expr;
}

static FailureOr<sym::ExprHandle> appendAddressExpr(sym::Analysis &analysis,
                                                    sym::ExprHandle lhs,
                                                    sym::ExprHandle rhs) {
  if (!lhs)
    return rhs;
  if (!rhs)
    return lhs;
  FailureOr<sym::ExprHandle> expr =
      analysis.compose(lhs, sym::ExprBinaryOp::Add, rhs);
  if (failed(expr))
    return failure();
  FailureOr<sym::ExprHandle> simplified = analysis.simplify(*expr);
  return succeeded(simplified) &&
                 shouldUseSimplifiedIndexExpr(*simplified, *expr)
             ? *simplified
             : *expr;
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
                                                sym::ExprHandle &slot,
                                                bool &slotNeedsWide) {
  FailureOr<std::unique_ptr<sym::Analysis>> analysis =
      sym::Analysis::create(S.symbolStore(), plan.assumptions);
  if (failed(analysis))
    return failure();
  FailureOr<sym::ExprHandle> joined =
      appendAddressExpr(**analysis, slot, plan.fullAddressRemainderExpr);
  if (failed(joined))
    return failure();
  if (!S.slotFitsU32(**analysis, *joined))
    return false;
  slot = *joined;
  slotNeedsWide = needsWideAddressMaterialization(*joined, plan);
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
    FailureOr<bool> tookSoffset = tryAppendRemainderToSlot(
        S, plan, plan.soffsetExpr, plan.soffsetNeedsWide);
    if (failed(tookSoffset))
      return failure();
    if (*tookSoffset)
      return success();
  }
  FailureOr<bool> tookVoffset = tryAppendRemainderToSlot(
      S, plan, plan.voffsetExpr, plan.voffsetNeedsWide);
  return failed(tookVoffset) ? failure() : success();
}

static FailureOr<Value> materializePlanExpr(
    WaveAMDMachineSelector &S, Operation *user, sym::ExprHandle expr,
    const AddressPlanBindings &bindings, ArrayRef<sym::PredHandle> assumptions,
    IndexExprAddOrder addOrder = IndexExprAddOrder::UniformFirst) {
  return materializeIndexExprNode(S, expr, user, bindings.narrow, assumptions,
                                  addOrder);
}

static FailureOr<sym::ExprHandle>
planCompleteAddressExpr(WaveAMDMachineSelector &S, const AddressPlan &plan) {
  sym::ExprHandle expr = plan.fullAddressRemainderExpr;
  if (plan.instOffset != 0) {
    FailureOr<sym::ExprHandle> inst =
        sym::composeExprInt(S.symbolStore(), plan.instOffset);
    if (failed(inst))
      return failure();
    FailureOr<sym::ExprHandle> withInst = appendAddressExpr(S, expr, *inst);
    if (failed(withInst))
      return failure();
    expr = *withInst;
  }
  FailureOr<sym::ExprHandle> withVoffset =
      appendAddressExpr(S, expr, plan.voffsetExpr);
  if (failed(withVoffset))
    return failure();
  FailureOr<sym::ExprHandle> materialization =
      appendAddressExpr(S, *withVoffset, plan.soffsetExpr);
  if (failed(materialization))
    return failure();
  if (!*materialization)
    return *materialization;
  FailureOr<sym::ExprHandle> simplified =
      sym::simplifyExpr(S.symbolStore(), *materialization, plan.assumptions);
  return succeeded(simplified) &&
                 shouldUseSimplifiedIndexExpr(*simplified, *materialization)
             ? *simplified
             : *materialization;
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

static IndexExprAddOrder
indexExprAddOrder(waveamdmachine::VOffsetAddOrder order) {
  if (order == waveamdmachine::VOffsetAddOrder::LaneFirst)
    return IndexExprAddOrder::LaneFirst;
  return IndexExprAddOrder::UniformFirst;
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

static FailureOr<Value> materializePlanLowDword(
    WaveAMDMachineSelector &S, Operation *user, sym::ExprHandle expr,
    const AddressPlanBindings &bindings, ArrayRef<sym::PredHandle> assumptions,
    bool useWide, bool symbolsAreUniform = false,
    IndexExprAddOrder addOrder = IndexExprAddOrder::UniformFirst);

FailureOr<WaveAMDMachineSelector::BucketedOperands>
materializePlanBuckets(WaveAMDMachineSelector &S, Operation *user,
                       const AddressPlan &plan,
                       const waveamdmachine::AddressFieldSpec &spec) {
  AddressPlanBindings bindings = materializeAddressPlanBindings(S, user, plan);
  WaveAMDMachineSelector::BucketedOperands out;
  Value vraw;
  if (plan.voffsetExpr) {
    IndexExprAddOrder addOrder = indexExprAddOrder(spec.voffsetAddOrder);
    FailureOr<Value> voffset =
        materializePlanLowDword(S, user, plan.voffsetExpr, bindings,
                                plan.assumptions, plan.voffsetNeedsWide,
                                /*symbolsAreUniform=*/false, addOrder);
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
          materializePlanLowDword(S, user, plan.soffsetExpr, bindings,
                                  plan.assumptions, plan.soffsetNeedsWide,
                                  /*symbolsAreUniform=*/true);
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
    FailureOr<Value> voffset =
        materializePlanLowDword(S, user, plan->voffsetExpr, bindings,
                                plan->assumptions, plan->voffsetNeedsWide);
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
        materializePlanLowDword(S, user, plan->soffsetExpr, bindings,
                                plan->assumptions, plan->soffsetNeedsWide,
                                /*symbolsAreUniform=*/true);
    if (failed(soffset))
      return failure();
    append(S.ensureSGPR1(loc, *soffset));
  }
  if (plan->instOffset != 0)
    append(createImm(S.builder, loc, plan->instOffset));
  if (plan->fullAddressRemainderExpr) {
    bool useWide =
        needsWideAddressMaterialization(plan->fullAddressRemainderExpr, *plan);
    bool isUniform =
        classifyPlanExpr(S, *plan, plan->fullAddressRemainderExpr) !=
        TermKind::Lane;
    FailureOr<Value> remainder = materializePlanLowDword(
        S, user, plan->fullAddressRemainderExpr, bindings, plan->assumptions,
        useWide, isUniform);
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

static FailureOr<Value>
materializeFullAddressLowDword(WaveAMDMachineSelector &S, Operation *user,
                               Value base, const AddressPlan &plan) {
  AddressPlanBindings bindings = materializeAddressPlanBindings(S, user, plan);
  Value addr = extractLowDword(S, user->getLoc(), base);

  auto appendExpr = [&](sym::ExprHandle expr, bool useWide) -> LogicalResult {
    if (!expr)
      return success();
    bool isUniform = classifyPlanExpr(S, plan, expr) != TermKind::Lane;
    FailureOr<Value> offset = materializePlanLowDword(
        S, user, expr, bindings, plan.assumptions, useWide, isUniform);
    if (failed(offset))
      return failure();
    addr = S.addByteOffsets(user->getLoc(), addr, *offset);
    return success();
  };

  if (failed(appendExpr(plan.voffsetExpr, plan.voffsetNeedsWide)) ||
      failed(appendExpr(plan.soffsetExpr, plan.soffsetNeedsWide)))
    return failure();
  if (plan.fullAddressRemainderExpr) {
    bool useWide =
        needsWideAddressMaterialization(plan.fullAddressRemainderExpr, plan);
    if (failed(appendExpr(plan.fullAddressRemainderExpr, useWide)))
      return failure();
  }
  return addr;
}

FailureOr<MaterializedLdsAddress>
materializeLdsAddress(WaveAMDMachineSelector &S, Operation *user, Value base,
                      const PointerOffset &offset,
                      const waveamdmachine::AddressFieldSpec &spec) {
  FailureOr<AddressPlan> plan = planMemoryAddress(S, user, offset, spec);
  if (failed(plan))
    return failure();
  if (plan->fullAddressRemainderExpr) {
    FailureOr<Value> lowAddr =
        materializeFullAddressLowDword(S, user, base, *plan);
    if (failed(lowAddr))
      return failure();
    Value addr = S.ensureVGPRForVSrc1(user->getLoc(), *lowAddr);
    return MaterializedLdsAddress{addr, plan->instOffset};
  }
  FailureOr<WaveAMDMachineSelector::BucketedOperands> buckets =
      materializePlanBuckets(S, user, *plan, spec);
  if (failed(buckets))
    return failure();
  Value lowAddress = buckets->voffset;
  if (!isLocalZero(S, base))
    lowAddress = S.addByteOffsets(user->getLoc(), base, buckets->voffset);
  Value addr = S.ensureVGPRForVSrc1(user->getLoc(), lowAddress);
  return MaterializedLdsAddress{addr, buckets->instOffset};
}

static FailureOr<Value>
materializeUniformFullPlanAddress(WaveAMDMachineSelector &S, Operation *user,
                                  Value base, const AddressPlan &plan) {
  AddressPlanBindings bindings = materializeAddressPlanBindings(S, user, plan);
  FailureOr<sym::ExprHandle> expr = planCompleteAddressExpr(S, plan);
  if (failed(expr))
    return failure();
  Value addr = ensureSGPR2(S, user->getLoc(), base);
  if (*expr) {
    FailureOr<Value> offset = materializeWideIndexExprNode(
        S, *expr, user, bindings.wide, plan.assumptions,
        /*symbolsAreUniform=*/true);
    if (failed(offset))
      return failure();
    addr = addWide(S, user->getLoc(), addr, *offset);
  }
  return addr;
}

static FailureOr<Value>
materializeUniformFullAddressLowDword(WaveAMDMachineSelector &S,
                                      Operation *user, Value base,
                                      const AddressPlan &plan) {
  FailureOr<Value> addr =
      materializeUniformFullPlanAddress(S, user, base, plan);
  if (failed(addr))
    return failure();
  return extractLowDword(S, user->getLoc(), *addr);
}

static FailureOr<Value> materializePlanLowDword(
    WaveAMDMachineSelector &S, Operation *user, sym::ExprHandle expr,
    const AddressPlanBindings &bindings, ArrayRef<sym::PredHandle> assumptions,
    bool useWide, bool symbolsAreUniform, IndexExprAddOrder addOrder) {
  if (useWide) {
    FailureOr<Value> wide = materializeWideIndexExprNode(
        S, expr, user, bindings.wide, assumptions, symbolsAreUniform, addOrder);
    if (failed(wide))
      return failure();
    return extractLowDword(S, user->getLoc(), *wide);
  }
  return materializePlanExpr(S, user, expr, bindings, assumptions, addOrder);
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
      .Case<ConstantOp>([&](auto o) { return selectConstant(o); })
      .Case<ub::PoisonOp>([&](auto o) { return selectPoison(o); })
      .Case<LaneIdOp>([&](auto o) { return selectLaneId(o); })
      .Case<ReadCyclesOp>([&](auto o) { return selectReadCycles(o); })
      .Case<WorkgroupIdOp>([&](auto o) { return selectWorkgroupId(o); })
      .Case<WorkitemIdOp>([&](auto o) { return selectWorkitemId(o); })
      .Case<SplatOp>([&](auto o) { return selectSplat(o); })
      .Case<AssumeOp>([&](auto o) { return selectAssume(o); })
      .Case<URecipOp>([&](auto o) { return selectURecip(o); })
      .Case<CtzOp>([&](auto o) { return selectCtz(o); })
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
      .Case<CmpFOp>([&](auto o) { return selectCmpF(o); })
      .Case<SelectOp>([&](auto o) { return selectSelect(o); })
      .Case<BallotOp>([&](auto o) { return selectBallot(o); })
      .Case<ReadFirstOp>([&](auto o) { return selectReadFirst(o); })
      .Case<ShuffleOp>([&](auto o) { return selectShuffle(o); })
      .Case<PtrCastOp>([&](auto o) { return selectPtrCast(o); })
      .Case<PtrAddOp>([&](auto o) { return selectPtrAdd(o); })
      .Case<waveamd::SetPriorityOp>(
          [&](auto o) { return selectSetPriority(o); })
      .Case<waveamd::GlobalAtomicAddAcqRelOp>(
          [&](auto o) { return selectGlobalAtomicAddAcqRel(*this, o); })
      .Case<waveamd::MakeBufferOp>([&](auto o) { return selectMakeBuffer(o); })
      .Case<SchedBarrierOp>([&](auto o) { return selectSchedBarrier(o); })
      .Case<TokenOp>([&](auto o) { return selectToken(o); })
      .Case<IssueTokenOp>([&](auto o) { return selectIssueToken(o); })
      .Case<AfterOp, JoinOp>([&](auto o) { return selectTokenJoin(o); })
      .Case<WhereOp>([&](auto o) { return selectWhere(o); })
      .Case<StoreOp>([&](auto o) { return selectStore(*this, o); })
      .Case<LoadOp>([&](auto o) { return selectLoad(*this, o); })
      .Case<SharedMemoryBaseOp>(
          [&](auto o) { return selectSharedMemoryBase(o); })
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

static LogicalResult selectWaveMaskConstant(WaveAMDMachineSelector &S,
                                            ConstantOp op, MaskType maskType) {
  IntegerAttr attr = dyn_cast<IntegerAttr>(op.getValue());
  if (!attr || cast<IntegerType>(attr.getType()).getWidth() != 1)
    return op.emitError("mask constant must use an i1 integer attribute");
  int64_t mask = attr.getValue().isZero() ? 0 : -1;
  S.values[op.getResult()] = maskType.getWidth() == 64
                                 ? createWideImm(S, op.getLoc(), mask)
                                 : createImm(S.builder, op.getLoc(), mask);
  S.eraseIfTopLevel(op);
  return success();
}

static Type getWaveMachineConstantPayloadType(Type type) {
  if (SimdType simdType = dyn_cast<SimdType>(type))
    return simdType.getElementType();
  return type;
}

static LogicalResult selectWaveIntegerConstant(WaveAMDMachineSelector &S,
                                               ConstantOp op, Type type,
                                               IntegerAttr attr) {
  if (!attr.getValue().isSignedIntN(64))
    return op.emitError("integer constant must fit signed 64-bit");
  int64_t raw = attr.getValue().getSExtValue();
  if (type.isIndex()) {
    S.values[op.getResult()] = createImm(S.builder, op.getLoc(), raw);
    S.eraseIfTopLevel(op);
    return success();
  }
  IntegerType intType = dyn_cast<IntegerType>(type);
  if (!intType)
    return op.emitError("unsupported integer constant result type");
  S.values[op.getResult()] = intType.getWidth() == 64
                                 ? createWideImm(S, op.getLoc(), raw)
                                 : createImm(S.builder, op.getLoc(), raw);
  S.eraseIfTopLevel(op);
  return success();
}

static LogicalResult selectWaveFloatConstant(WaveAMDMachineSelector &S,
                                             ConstantOp op, Type type,
                                             FloatAttr attr) {
  FloatType floatType = dyn_cast<FloatType>(type);
  if (!floatType)
    return op.emitError("unsupported floating constant result type");
  unsigned bits = floatType.getWidth();
  if (bits != 16 && bits != 32)
    return op.emitError("floating constant must be 16 or 32 bits wide");
  S.values[op.getResult()] = createImm(
      S.builder, op.getLoc(), attr.getValue().bitcastToAPInt().getZExtValue());
  S.eraseIfTopLevel(op);
  return success();
}

LogicalResult WaveAMDMachineSelector::selectConstant(ConstantOp op) {
  if (MaskType maskType = dyn_cast<MaskType>(op.getType()))
    return selectWaveMaskConstant(*this, op, maskType);

  Type type = getWaveMachineConstantPayloadType(op.getType());
  if (IntegerAttr attr = dyn_cast<IntegerAttr>(op.getValue()))
    return selectWaveIntegerConstant(*this, op, type, attr);
  if (FloatAttr attr = dyn_cast<FloatAttr>(op.getValue()))
    return selectWaveFloatConstant(*this, op, type, attr);
  return op.emitError("unsupported wave.constant attribute");
}

static FailureOr<unsigned>
getScalarRegisterPayloadBits(Type type,
                             function_ref<InFlightDiagnostic()> emitError) {
  if (type.isIndex())
    return 64;
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
getRegisterPayloadBits(Type type,
                       function_ref<InFlightDiagnostic()> emitError) {
  if (auto fragmentType = dyn_cast<waveamd::FragmentType>(type))
    return fragmentType.getRegisters() * 32;
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
  return getScalarRegisterPayloadBits(type, emitError);
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

  if (isLaneVaryingType(type)) {
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

static LogicalResult materializeDmaIssueSkipFlag(WaveAMDMachineSelector &S,
                                                 WorkitemIdOp op, unsigned axis,
                                                 Value result) {
  if (axis != 0 || !S.dmaIssueSkipThreadThreshold || S.dmaIssueSkipFlag)
    return success();
  FailureOr<unsigned> wavefrontSize = waveamdmachine::getAMDGPUWavefrontSize(
      S.func, "waveamd-machine-selector");
  if (failed(wavefrontSize))
    return failure();
  int64_t threshold = *S.dmaIssueSkipThreadThreshold;
  if (threshold <= 0 || threshold % *wavefrontSize != 0)
    return op.emitOpError("DMA issue skip threshold must be wave-aligned");
  Value firstThread = waveamdmachine::VReadfirstlaneB32Op::create(
      S.builder, op.getLoc(),
      getRegType(S.builder.getContext(), waveamdmachine::RegClass::SGPR),
      result);
  waveamdmachine::SLshrB32Op waveId = waveamdmachine::SLshrB32Op::create(
      S.builder, op.getLoc(),
      getRegType(S.builder.getContext(), waveamdmachine::RegClass::SGPR),
      getSCCType(S.builder.getContext()), firstThread,
      createImm(S.builder, op.getLoc(), llvm::Log2_32(*wavefrontSize)));
  Value highCohort = waveamdmachine::SCmpGeU32Op::create(
      S.builder, op.getLoc(), getSCCType(S.builder.getContext()),
      waveId.getResult(),
      createImm(S.builder, op.getLoc(), threshold / *wavefrontSize));
  S.dmaIssueSkipFlag = waveamdmachine::SCSelectB32Op::create(
      S.builder, op.getLoc(),
      getRegType(S.builder.getContext(), waveamdmachine::RegClass::SGPR),
      highCohort, createImm(S.builder, op.getLoc(), 1),
      createImm(S.builder, op.getLoc(), 0));
  return success();
}

LogicalResult WaveAMDMachineSelector::selectWorkitemId(WorkitemIdOp op) {
  unsigned axis = op.getAxis();
  if (axis > 2)
    return op.emitError("workitem_id axis must be 0, 1, or 2");

  WaveAMDKernelEntryRegs entryRegs = getWaveAMDKernelEntryRegs(func);
  Type pinned =
      getPinnedRegType(op.getContext(), waveamdmachine::RegClass::VGPR,
                       /*width=*/1, entryRegs.workitemIdVGPR(axis));
  Value result;
  if (!packedWorkitemIds) {
    if (axis == 0)
      result =
          waveamdmachine::VWorkitemIdXOp::create(builder, op.getLoc(), pinned);
    else if (axis == 1)
      result =
          waveamdmachine::VWorkitemIdYOp::create(builder, op.getLoc(), pinned);
    else
      result =
          waveamdmachine::VWorkitemIdZOp::create(builder, op.getLoc(), pinned);
  } else {
    Type rawType =
        getPinnedRegType(op.getContext(), waveamdmachine::RegClass::VGPR,
                         /*width=*/1, entryRegs.workitemIdVGPR(0));
    waveamdmachine::VWorkitemIdXOp raw =
        waveamdmachine::VWorkitemIdXOp::create(builder, op.getLoc(), rawType);
    raw->setAttr(getWaveAMDWorkitemIdAxisAttrName(),
                 builder.getI64IntegerAttr(axis));
    Type resultType =
        getRegType(op.getContext(), waveamdmachine::RegClass::VGPR);
    if (axis == 0) {
      if (maxWorkitemIdAxis == 0)
        result = raw;
      else
        result = waveamdmachine::VAndB32Op::create(
            builder, op.getLoc(), resultType, raw,
            createImm(builder, op.getLoc(), 0x3ff));
    } else {
      Value offset = createImm(builder, op.getLoc(), axis * 10);
      Value width = createImm(builder, op.getLoc(), 10);
      result = waveamdmachine::VBfeU32Op::create(
          builder, op.getLoc(), resultType, raw, offset, width);
    }
  }
  if (failed(materializeDmaIssueSkipFlag(*this, op, axis, result)))
    return failure();
  values[op.getResult()] = result;
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
  if (kind == BinaryKind::ShRSI)
    return waveamdmachine::VAshrrevI32Op::create(builder, loc, resultType, lhs,
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
  if (kind == BinaryKind::ShRSI)
    return waveamdmachine::SAshrI32Op::create(builder, loc, resultType, scc,
                                              lhs, rhs)
        .getResult();
  return Value{};
}

static Value subUniformI32(WaveAMDMachineSelector &S, Location loc, Value lhs,
                           Value rhs) {
  Value notRhs;
  lhs = S.ensureSGPR1(loc, lhs);
  rhs = S.ensureSGPR1(loc, rhs);
  if (std::optional<int64_t> rhsImm = S.getImmediateValue(rhs))
    notRhs = createImm(S.builder, loc, ~*rhsImm);
  else
    notRhs = buildScalarBinaryI32(
        S.builder, loc,
        getRegType(S.builder.getContext(), waveamdmachine::RegClass::SGPR),
        BinaryKind::XOrI, rhs, createImm(S.builder, loc, -1));
  Value negRhs = S.addUniformBytes(loc, notRhs, createImm(S.builder, loc, 1));
  return S.addUniformBytes(loc, lhs, negRhs);
}

enum class VALUOperandShape { AnyVGPR, VOP2Commutative, ValueVGPR };

static TermKind valuOperandKind(Value value) {
  if (isImm(value))
    return TermKind::Const;
  waveamdmachine::RegType regType =
      dyn_cast<waveamdmachine::RegType>(value.getType());
  if (regType && regType.getRegClass() == waveamdmachine::RegClass::SGPR)
    return TermKind::Uniform;
  return TermKind::Lane;
}

static bool prefersMaterializingLhs(Value lhs, Value rhs, Operation *user) {
  TermKind lhsKind = valuOperandKind(lhs);
  TermKind rhsKind = valuOperandKind(rhs);
  unsigned lhsDepth = valueLoopDepth(lhs, user);
  unsigned rhsDepth = valueLoopDepth(rhs, user);
  if (orderedBefore(lhsKind, lhsDepth, rhsKind, rhsDepth,
                    IndexExprAddOrder::UniformFirst))
    return true;
  if (orderedBefore(rhsKind, rhsDepth, lhsKind, lhsDepth,
                    IndexExprAddOrder::UniformFirst))
    return false;
  return true;
}

static void materializeHoistableOperandAsVGPR(WaveAMDMachineSelector &S,
                                              Location loc, Operation *user,
                                              Value &lhs, Value &rhs) {
  if (prefersMaterializingLhs(lhs, rhs, user))
    lhs = S.ensureVGPRForVSrc1(loc, lhs);
  else
    rhs = S.ensureVGPRForVSrc1(loc, rhs);
}

static void shapeVALUOperands(WaveAMDMachineSelector &S, Location loc,
                              Operation *user, VALUOperandShape shape,
                              Value &lhs, Value &rhs) {
  if (shape == VALUOperandShape::ValueVGPR) {
    lhs = S.ensureVGPRForVSrc1(loc, lhs);
    return;
  }

  if (!isVGPR(lhs) && !isVGPR(rhs))
    materializeHoistableOperandAsVGPR(S, loc, user, lhs, rhs);

  if (shape == VALUOperandShape::VOP2Commutative)
    waveamdmachine::putVGPROperandLast(lhs, rhs);
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
  if (!isBinarySimd(op) || (isUniformValue(lhs) && isUniformValue(rhs))) {
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
    lhs = ensureSGPR1(op.getLoc(), lhs);
    rhs = ensureSGPR1(op.getLoc(), rhs);
    values[op.getResult()] = waveamdmachine::SMulI32Op::create(
        builder, op.getLoc(),
        getRegType(op.getContext(), waveamdmachine::RegClass::SGPR), lhs, rhs);
    eraseIfTopLevel(op);
    return success();
  }
  if (isUniformValue(lhs) && isUniformValue(rhs)) {
    values[op.getResult()] = mulUniformValues(op.getLoc(), lhs, rhs);
    eraseIfTopLevel(op);
    return success();
  }
  shapeVALUOperands(*this, op.getLoc(), op, VALUOperandShape::AnyVGPR, lhs,
                    rhs);
  values[op.getResult()] = waveamdmachine::VMulLoU32Op::create(
      builder, op.getLoc(),
      getRegType(op.getContext(), waveamdmachine::RegClass::VGPR), lhs, rhs);
  eraseIfTopLevel(op);
  return success();
}

static LogicalResult selectBinaryMulHUI32(WaveAMDMachineSelector &S,
                                          BinaryOp op) {
  Value lhs = S.expect(op.getLhs(), op);
  Value rhs = S.expect(op.getRhs(), op);
  if (!isBinarySimd(op)) {
    lhs = S.ensureSGPR1(op.getLoc(), lhs);
    rhs = S.ensureSGPR1(op.getLoc(), rhs);
    S.values[op.getResult()] = waveamdmachine::SMulHiU32Op::create(
        S.builder, op.getLoc(),
        getRegType(op.getContext(), waveamdmachine::RegClass::SGPR), lhs, rhs);
    S.eraseIfTopLevel(op);
    return success();
  }
  if (S.isUniformValue(lhs) && S.isUniformValue(rhs)) {
    S.values[op.getResult()] = waveamdmachine::SMulHiU32Op::create(
        S.builder, op.getLoc(),
        getRegType(op.getContext(), waveamdmachine::RegClass::SGPR), lhs, rhs);
    S.eraseIfTopLevel(op);
    return success();
  }
  shapeVALUOperands(S, op.getLoc(), op, VALUOperandShape::AnyVGPR, lhs, rhs);
  S.values[op.getResult()] = waveamdmachine::VMulHiU32Op::create(
      S.builder, op.getLoc(),
      getRegType(op.getContext(), waveamdmachine::RegClass::VGPR), lhs, rhs);
  S.eraseIfTopLevel(op);
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
    lhs = ensureSGPR1(op.getLoc(), lhs);
    rhs = ensureSGPR1(op.getLoc(), rhs);
    values[op.getResult()] =
        waveamdmachine::SLshlB32Op::create(
            builder, op.getLoc(),
            getRegType(op.getContext(), waveamdmachine::RegClass::SGPR),
            getSCCType(op.getContext()), lhs, rhs)
            .getResult();
    eraseIfTopLevel(op);
    return success();
  }
  if (isUniformValue(lhs) && isUniformValue(rhs)) {
    values[op.getResult()] =
        waveamdmachine::SLshlB32Op::create(
            builder, op.getLoc(),
            getRegType(op.getContext(), waveamdmachine::RegClass::SGPR),
            getSCCType(op.getContext()), lhs, rhs)
            .getResult();
    eraseIfTopLevel(op);
    return success();
  }
  shapeVALUOperands(*this, op.getLoc(), op, VALUOperandShape::ValueVGPR, lhs,
                    rhs);
  values[op.getResult()] = waveamdmachine::VLshlrevB32Op::create(
      builder, op.getLoc(),
      getRegType(op.getContext(), waveamdmachine::RegClass::VGPR), lhs, rhs);
  eraseIfTopLevel(op);
  return success();
}

static bool isUniformPayloadValue(Value value, unsigned width) {
  if (isImm(value))
    return true;
  auto regType = dyn_cast<waveamdmachine::RegType>(value.getType());
  if (!regType || regType.getRegClass() != waveamdmachine::RegClass::SGPR)
    return false;
  return regType.getWidth() == width || (width == 2 && regType.getWidth() == 1);
}

LogicalResult WaveAMDMachineSelector::selectBinaryShLI64(BinaryOp op) {
  Value lhs = expect(op.getLhs(), op);
  Value rhs = expect(op.getRhs(), op);
  Value shift = extractLowDword(*this, op.getLoc(), rhs, op.getRhs());
  if (!isBinarySimd(op)) {
    Type resultType =
        getRegType(op.getContext(), waveamdmachine::RegClass::SGPR, 2);
    values[op.getResult()] =
        waveamdmachine::SLshlB64Op::create(builder, op.getLoc(), resultType,
                                           getSCCType(op.getContext()),
                                           ensureSGPR2(*this, op.getLoc(), lhs),
                                           ensureSGPR1(op.getLoc(), shift))
            .getResult();
    eraseIfTopLevel(op);
    return success();
  }
  if (isUniformPayloadValue(lhs, 2) && isUniformValue(shift)) {
    Type resultType =
        getRegType(op.getContext(), waveamdmachine::RegClass::SGPR, 2);
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
  values[op.getResult()] = waveamdmachine::VLshlrevB64Op::create(
      builder, op.getLoc(), resultType, shift,
      ensureVGPR2(*this, op.getLoc(), lhs));
  eraseIfTopLevel(op);
  return success();
}

LogicalResult WaveAMDMachineSelector::selectBinarySubI32(BinaryOp op) {
  Value lhs = expect(op.getLhs(), op);
  Value rhs = expect(op.getRhs(), op);
  if (!isBinarySimd(op)) {
    values[op.getResult()] = subUniformI32(*this, op.getLoc(), lhs, rhs);
    eraseIfTopLevel(op);
    return success();
  }
  if (isUniformValue(lhs) && isUniformValue(rhs)) {
    values[op.getResult()] = subUniformI32(*this, op.getLoc(), lhs, rhs);
    eraseIfTopLevel(op);
    return success();
  }
  rhs = ensureVGPRForVSrc1(op.getLoc(), rhs);
  Value notRhs = buildVectorBinaryI32(
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

static LogicalResult selectBinaryDivRemI32(WaveAMDMachineSelector &,
                                           BinaryOp op) {
  return op.emitOpError("must be expanded before WaveAMDMachine selection; "
                        "run --wave-expand-integer-div-rem");
}

static LogicalResult selectBinaryDivRemI64(WaveAMDMachineSelector &,
                                           BinaryOp op) {
  return op.emitOpError("must be expanded before WaveAMDMachine selection; "
                        "run --wave-expand-integer-div-rem");
}

static bool isDivRem(BinaryKind kind) {
  return kind == BinaryKind::DivUI || kind == BinaryKind::DivSI ||
         kind == BinaryKind::RemUI || kind == BinaryKind::RemSI;
}

static bool isBitwiseOrLogicalShiftI32(BinaryKind kind) {
  return kind == BinaryKind::AndI || kind == BinaryKind::OrI ||
         kind == BinaryKind::XOrI || kind == BinaryKind::ShRUI ||
         kind == BinaryKind::ShRSI;
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
    lhs = S.ensureSGPR1(op.getLoc(), lhs);
    rhs = S.ensureSGPR1(op.getLoc(), rhs);
    S.values[op.getResult()] = buildScalarBinaryI32(S.builder, op.getLoc(),
                                                    resultType, kind, lhs, rhs);
    S.eraseIfTopLevel(op);
    return success();
  }
  if (S.isUniformValue(lhs) && S.isUniformValue(rhs)) {
    Type scalarType =
        getRegType(op.getContext(), waveamdmachine::RegClass::SGPR);
    S.values[op.getResult()] = buildScalarBinaryI32(S.builder, op.getLoc(),
                                                    scalarType, kind, lhs, rhs);
    S.eraseIfTopLevel(op);
    return success();
  }
  VALUOperandShape shape =
      (kind == BinaryKind::ShRUI || kind == BinaryKind::ShRSI)
          ? VALUOperandShape::ValueVGPR
          : VALUOperandShape::VOP2Commutative;
  shapeVALUOperands(S, op.getLoc(), op, shape, lhs, rhs);
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
  if (kind == BinaryKind::MulHUI)
    return selectBinaryMulHUI32(S, op);
  if (kind == BinaryKind::ShLI)
    return S.selectBinaryShLI32(op);
  if (isDivRem(kind))
    return selectBinaryDivRemI32(S, op);
  if (isBitwiseOrLogicalShiftI32(kind))
    return selectBinaryBitwiseOrShiftI32(S, op);
  return op.emitOpError("unsupported i32 wave.binary kind ")
         << stringifyBinaryKind(kind);
}

static LogicalResult selectBinaryShRUI64(WaveAMDMachineSelector &S,
                                         BinaryOp op) {
  Value lhs = S.expect(op.getLhs(), op);
  Value rhs = S.expect(op.getRhs(), op);
  Value shift = extractLowDword(S, op.getLoc(), rhs, op.getRhs());
  if (!isBinarySimd(op)) {
    Type resultType =
        getRegType(op.getContext(), waveamdmachine::RegClass::SGPR, 2);
    S.values[op.getResult()] =
        waveamdmachine::SLshrB64Op::create(
            S.builder, op.getLoc(), resultType, getSCCType(op.getContext()),
            ensureSGPR2(S, op.getLoc(), lhs), S.ensureSGPR1(op.getLoc(), shift))
            .getResult();
    S.eraseIfTopLevel(op);
    return success();
  }
  if (isUniformPayloadValue(lhs, 2) && S.isUniformValue(shift)) {
    Type resultType =
        getRegType(op.getContext(), waveamdmachine::RegClass::SGPR, 2);
    S.values[op.getResult()] =
        waveamdmachine::SLshrB64Op::create(
            S.builder, op.getLoc(), resultType, getSCCType(op.getContext()),
            ensureSGPR2(S, op.getLoc(), lhs), S.ensureSGPR1(op.getLoc(), shift))
            .getResult();
    S.eraseIfTopLevel(op);
    return success();
  }
  Type resultType =
      getRegType(op.getContext(), waveamdmachine::RegClass::VGPR, 2);
  S.values[op.getResult()] = waveamdmachine::VLshrrevB64Op::create(
      S.builder, op.getLoc(), resultType, shift,
      ensureVGPR2(S, op.getLoc(), lhs));
  S.eraseIfTopLevel(op);
  return success();
}

static LogicalResult selectBinaryShRSI64(WaveAMDMachineSelector &S,
                                         BinaryOp op) {
  Value lhs = S.expect(op.getLhs(), op);
  Value rhs = S.expect(op.getRhs(), op);
  Value shift = extractLowDword(S, op.getLoc(), rhs, op.getRhs());
  if (!isBinarySimd(op)) {
    Type resultType =
        getRegType(op.getContext(), waveamdmachine::RegClass::SGPR, 2);
    S.values[op.getResult()] =
        waveamdmachine::SAshrI64Op::create(
            S.builder, op.getLoc(), resultType, getSCCType(op.getContext()),
            ensureSGPR2(S, op.getLoc(), lhs), S.ensureSGPR1(op.getLoc(), shift))
            .getResult();
    S.eraseIfTopLevel(op);
    return success();
  }
  if (isUniformPayloadValue(lhs, 2) && S.isUniformValue(shift)) {
    Type resultType =
        getRegType(op.getContext(), waveamdmachine::RegClass::SGPR, 2);
    S.values[op.getResult()] =
        waveamdmachine::SAshrI64Op::create(
            S.builder, op.getLoc(), resultType, getSCCType(op.getContext()),
            ensureSGPR2(S, op.getLoc(), lhs), S.ensureSGPR1(op.getLoc(), shift))
            .getResult();
    S.eraseIfTopLevel(op);
    return success();
  }
  Type resultType =
      getRegType(op.getContext(), waveamdmachine::RegClass::VGPR, 2);
  S.values[op.getResult()] = waveamdmachine::VAshrrevI64Op::create(
      S.builder, op.getLoc(), resultType, shift,
      ensureVGPR2(S, op.getLoc(), lhs));
  S.eraseIfTopLevel(op);
  return success();
}

static LogicalResult selectBinaryBitwiseI64(WaveAMDMachineSelector &S,
                                            BinaryOp op) {
  BinaryKind kind = op.getKind();
  Value lhs = S.expect(op.getLhs(), op);
  Value rhs = S.expect(op.getRhs(), op);
  S.values[op.getResult()] = kind == BinaryKind::XOrI
                                 ? xorWide(S, op.getLoc(), lhs, rhs)
                                 : bitwiseWide(S, op.getLoc(), kind, lhs, rhs);
  S.eraseIfTopLevel(op);
  return success();
}

static bool isShiftI64(BinaryKind kind) {
  return kind == BinaryKind::ShLI || kind == BinaryKind::ShRUI ||
         kind == BinaryKind::ShRSI;
}

static LogicalResult selectBinaryShiftI64(WaveAMDMachineSelector &S,
                                          BinaryOp op) {
  BinaryKind kind = op.getKind();
  if (kind == BinaryKind::ShLI)
    return S.selectBinaryShLI64(op);
  if (kind == BinaryKind::ShRUI)
    return selectBinaryShRUI64(S, op);
  return selectBinaryShRSI64(S, op);
}

static bool isBitwiseI64(BinaryKind kind) {
  return kind == BinaryKind::AndI || kind == BinaryKind::OrI ||
         kind == BinaryKind::XOrI;
}

static LogicalResult selectBinaryI64(WaveAMDMachineSelector &S, BinaryOp op) {
  BinaryKind kind = op.getKind();
  if (kind == BinaryKind::AddI)
    return S.selectBinaryAddI64(op);
  if (kind == BinaryKind::SubI)
    return S.selectBinarySubI64(op);
  if (kind == BinaryKind::MulI)
    return S.selectBinaryMulI64(op);
  if (isShiftI64(kind))
    return selectBinaryShiftI64(S, op);
  if (isDivRem(kind))
    return selectBinaryDivRemI64(S, op);
  if (isBitwiseI64(kind))
    return selectBinaryBitwiseI64(S, op);
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

static FailureOr<SmallVector<Value>>
splitVGPRMaterializedWords(WaveAMDMachineSelector &S, Operation *op,
                           Value value, unsigned words, StringRef name) {
  waveamdmachine::RegType regType =
      dyn_cast<waveamdmachine::RegType>(value.getType());
  if (isa<waveamdmachine::ImmType>(value.getType())) {
    if (words != 1)
      return op->emitError(name)
             << " must lower to " << words << " dword machine value";
    return SmallVector<Value>{S.ensureVGPRForVSrc1(op->getLoc(), value)};
  }
  if (!regType || regType.getWidth() != words)
    return op->emitError(name)
           << " must lower to " << words << " dword machine value";

  SmallVector<Value> rawWords;
  if (words == 1) {
    rawWords.push_back(value);
  } else {
    Type elementType =
        getRegType(S.builder.getContext(), regType.getRegClass());
    SmallVector<Type> elementTypes(words, elementType);
    waveamdmachine::TupleToElementsOp split =
        waveamdmachine::TupleToElementsOp::create(S.builder, op->getLoc(),
                                                  elementTypes, value);
    rawWords.append(split.getElements().begin(), split.getElements().end());
  }

  SmallVector<Value> vgprWords;
  vgprWords.reserve(rawWords.size());
  for (Value word : rawWords)
    vgprWords.push_back(S.ensureVGPRForVSrc1(op->getLoc(), word));
  return vgprWords;
}

static Value joinVGPRWords(WaveAMDMachineSelector &S, Location loc,
                           ArrayRef<Value> words) {
  assert(!words.empty() && "expected at least one VGPR word");
  if (words.size() == 1)
    return words.front();
  Type resultType = getRegType(S.builder.getContext(),
                               waveamdmachine::RegClass::VGPR, words.size());
  return waveamdmachine::TupleFromElementsOp::create(S.builder, loc, resultType,
                                                     words)
      .getTuple();
}

static unsigned getPackedF16WordCount(unsigned vectorLength) {
  return (vectorLength + 1) / 2;
}

static unsigned getPackedF32PairCount(unsigned vectorLength) {
  return (vectorLength + 1) / 2;
}

static FailureOr<SmallVector<Value>>
splitVGPRMaterializedDwordPairs(WaveAMDMachineSelector &S, Operation *op,
                                Value value, unsigned pairCount,
                                StringRef name) {
  FailureOr<SmallVector<Value>> words =
      splitVGPRMaterializedWords(S, op, value, pairCount * 2, name);
  if (failed(words))
    return failure();

  SmallVector<Value> pairs;
  pairs.reserve(pairCount);
  for (unsigned index : llvm::seq<unsigned>(0, pairCount))
    pairs.push_back(joinVGPRWords(
        S, op->getLoc(), ArrayRef<Value>{words->data() + index * 2, 2}));
  return pairs;
}

static Value joinVGPRDwordPairs(WaveAMDMachineSelector &S, Location loc,
                                ArrayRef<Value> pairs) {
  assert(!pairs.empty() && "expected at least one VGPR pair");
  if (pairs.size() == 1)
    return pairs.front();

  SmallVector<Value> words;
  words.reserve(pairs.size() * 2);
  for (Value pair : pairs) {
    auto regType = cast<waveamdmachine::RegType>(pair.getType());
    assert(regType.getRegClass() == waveamdmachine::RegClass::VGPR &&
           regType.getWidth() == 2 && "expected VGPR2 pair");
    Type elementType =
        getRegType(S.builder.getContext(), waveamdmachine::RegClass::VGPR);
    SmallVector<Type> elementTypes(2, elementType);
    waveamdmachine::TupleToElementsOp split =
        waveamdmachine::TupleToElementsOp::create(S.builder, loc, elementTypes,
                                                  pair);
    words.append(split.getElements().begin(), split.getElements().end());
  }
  return joinVGPRWords(S, loc, words);
}

template <typename MachineOp, typename WaveOp>
static LogicalResult selectPackedF16Binary(WaveAMDMachineSelector &S, WaveOp op,
                                           StringRef kind, Value lhs,
                                           Value rhs) {
  if (failed(requirePackedF16Target(op.getOperation(), kind)))
    return failure();

  std::optional<unsigned> vectorLength =
      getSimdPackedF16Length(op.getResult().getType());
  if (!vectorLength)
    return op.emitError("packed f16 ")
           << kind << " lowering requires !wave.simd<vector<2^nxf16>, W>";
  unsigned words = getPackedF16WordCount(*vectorLength);
  FailureOr<SmallVector<Value>> lhsWords = splitVGPRMaterializedWords(
      S, op.getOperation(), S.expect(lhs, op), words, "lhs");
  if (failed(lhsWords))
    return failure();
  FailureOr<SmallVector<Value>> rhsWords = splitVGPRMaterializedWords(
      S, op.getOperation(), S.expect(rhs, op), words, "rhs");
  if (failed(rhsWords))
    return failure();

  Type vgprType =
      getRegType(S.builder.getContext(), waveamdmachine::RegClass::VGPR);
  SmallVector<Value> resultWords;
  resultWords.reserve(words);
  for (unsigned index : llvm::seq<unsigned>(0, words)) {
    Value selected =
        MachineOp::create(S.builder, op.getLoc(), vgprType, (*lhsWords)[index],
                          (*rhsWords)[index], false, 0, 3)
            .getResult();
    resultWords.push_back(selected);
  }
  S.values[op.getResult()] = joinVGPRWords(S, op.getLoc(), resultWords);
  S.eraseIfTopLevel(op);
  return success();
}

template <typename MachineOp, typename WaveOp>
static LogicalResult selectPackedF32Binary(WaveAMDMachineSelector &S, WaveOp op,
                                           StringRef kind, Value lhs,
                                           Value rhs) {
  if (failed(requirePackedF32Target(op.getOperation(), kind)))
    return failure();

  std::optional<unsigned> vectorLength =
      getSimdPackedF32Length(op.getResult().getType());
  if (!vectorLength || *vectorLength < 2)
    return op.emitError("packed f32 ")
           << kind << " lowering requires !wave.simd<vector<2^nxf32>, W> "
           << "with at least two elements";
  unsigned pairCount = getPackedF32PairCount(*vectorLength);
  FailureOr<SmallVector<Value>> lhsPairs = splitVGPRMaterializedDwordPairs(
      S, op.getOperation(), S.expect(lhs, op), pairCount, "lhs");
  if (failed(lhsPairs))
    return failure();
  FailureOr<SmallVector<Value>> rhsPairs = splitVGPRMaterializedDwordPairs(
      S, op.getOperation(), S.expect(rhs, op), pairCount, "rhs");
  if (failed(rhsPairs))
    return failure();

  Type vgpr2Type =
      getRegType(S.builder.getContext(), waveamdmachine::RegClass::VGPR, 2);
  SmallVector<Value> resultPairs;
  resultPairs.reserve(pairCount);
  bool contract = isa<FMulOp>(op.getOperation()) &&
                  arith::bitEnumContainsAll(op.getFastmath(),
                                            arith::FastMathFlags::contract);
  for (unsigned index : llvm::seq<unsigned>(0, pairCount)) {
    Value selected =
        MachineOp::create(S.builder, op.getLoc(), vgpr2Type, (*lhsPairs)[index],
                          (*rhsPairs)[index], false, 0, 3, contract)
            .getResult();
    resultPairs.push_back(selected);
  }
  S.values[op.getResult()] = joinVGPRDwordPairs(S, op.getLoc(), resultPairs);
  S.eraseIfTopLevel(op);
  return success();
}

template <typename MachineOp, typename WaveOp>
static LogicalResult selectPackedF16Ternary(WaveAMDMachineSelector &S,
                                            WaveOp op, StringRef kind, Value a,
                                            Value b, Value c) {
  if (failed(requirePackedF16Target(op.getOperation(), kind)))
    return failure();

  std::optional<unsigned> vectorLength =
      getSimdPackedF16Length(op.getResult().getType());
  if (!vectorLength)
    return op.emitError("packed f16 ")
           << kind << " lowering requires !wave.simd<vector<2^nxf16>, W>";
  unsigned words = getPackedF16WordCount(*vectorLength);
  FailureOr<SmallVector<Value>> aWords = splitVGPRMaterializedWords(
      S, op.getOperation(), S.expect(a, op), words, "lhs");
  if (failed(aWords))
    return failure();
  FailureOr<SmallVector<Value>> bWords = splitVGPRMaterializedWords(
      S, op.getOperation(), S.expect(b, op), words, "rhs");
  if (failed(bWords))
    return failure();
  FailureOr<SmallVector<Value>> cWords = splitVGPRMaterializedWords(
      S, op.getOperation(), S.expect(c, op), words, "acc");
  if (failed(cWords))
    return failure();

  Type vgprType =
      getRegType(S.builder.getContext(), waveamdmachine::RegClass::VGPR);
  SmallVector<Value> resultWords;
  resultWords.reserve(words);
  for (unsigned index : llvm::seq<unsigned>(0, words)) {
    Value selected =
        MachineOp::create(S.builder, op.getLoc(), vgprType, (*aWords)[index],
                          (*bWords)[index], (*cWords)[index], false, 0, 7)
            .getResult();
    resultWords.push_back(selected);
  }
  S.values[op.getResult()] = joinVGPRWords(S, op.getLoc(), resultWords);
  S.eraseIfTopLevel(op);
  return success();
}

template <typename MachineOp, typename WaveOp>
static LogicalResult selectPackedF32Ternary(WaveAMDMachineSelector &S,
                                            WaveOp op, StringRef kind, Value a,
                                            Value b, Value c) {
  if (failed(requirePackedF32Target(op.getOperation(), kind)))
    return failure();

  std::optional<unsigned> vectorLength =
      getSimdPackedF32Length(op.getResult().getType());
  if (!vectorLength || *vectorLength < 2)
    return op.emitError("packed f32 ")
           << kind << " lowering requires !wave.simd<vector<2^nxf32>, W> "
           << "with at least two elements";
  unsigned pairCount = getPackedF32PairCount(*vectorLength);
  FailureOr<SmallVector<Value>> aPairs = splitVGPRMaterializedDwordPairs(
      S, op.getOperation(), S.expect(a, op), pairCount, "lhs");
  if (failed(aPairs))
    return failure();
  FailureOr<SmallVector<Value>> bPairs = splitVGPRMaterializedDwordPairs(
      S, op.getOperation(), S.expect(b, op), pairCount, "rhs");
  if (failed(bPairs))
    return failure();
  FailureOr<SmallVector<Value>> cPairs = splitVGPRMaterializedDwordPairs(
      S, op.getOperation(), S.expect(c, op), pairCount, "acc");
  if (failed(cPairs))
    return failure();

  Type vgpr2Type =
      getRegType(S.builder.getContext(), waveamdmachine::RegClass::VGPR, 2);
  SmallVector<Value> resultPairs;
  resultPairs.reserve(pairCount);
  for (unsigned index : llvm::seq<unsigned>(0, pairCount)) {
    Value selected =
        MachineOp::create(S.builder, op.getLoc(), vgpr2Type, (*aPairs)[index],
                          (*bPairs)[index], (*cPairs)[index], false, 0, 7, 0, 0)
            .getResult();
    resultPairs.push_back(selected);
  }
  S.values[op.getResult()] = joinVGPRDwordPairs(S, op.getLoc(), resultPairs);
  S.eraseIfTopLevel(op);
  return success();
}

template <typename F32MachineOp, typename PackedF16MachineOp,
          typename PackedF32MachineOp, typename WaveOp>
static LogicalResult selectFloatBinary(WaveAMDMachineSelector &S, WaveOp op,
                                       StringRef kind) {
  Type resultType = op.getResult().getType();
  if (isSimdF32(resultType))
    return selectF32<F32MachineOp>(S, op, op.getLhs(), op.getRhs());
  if (isSimdPackedF16(resultType))
    return selectPackedF16Binary<PackedF16MachineOp>(S, op, kind, op.getLhs(),
                                                     op.getRhs());
  if (isSimdPackedF32(resultType))
    return selectPackedF32Binary<PackedF32MachineOp>(S, op, kind, op.getLhs(),
                                                     op.getRhs());
  return op.emitError("WaveAMDMachine ")
         << kind << " lowering supports only !wave.simd<f32, W> or "
         << "!wave.simd<vector<2^nxf16>, W> or "
         << "!wave.simd<vector<2^nxf32>, W>";
}

LogicalResult WaveAMDMachineSelector::selectFAdd(FAddOp op) {
  return selectFloatBinary<waveamdmachine::VAddF32Op,
                           waveamdmachine::VPkAddF16Op,
                           waveamdmachine::VPkAddF32Op>(*this, op, "fadd");
}

LogicalResult WaveAMDMachineSelector::selectFSub(FSubOp op) {
  return selectF32<waveamdmachine::VSubF32Op>(*this, op, op.getLhs(),
                                              op.getRhs());
}

LogicalResult WaveAMDMachineSelector::selectFMul(FMulOp op) {
  return selectFloatBinary<waveamdmachine::VMulF32Op,
                           waveamdmachine::VPkMulF16Op,
                           waveamdmachine::VPkMulF32Op>(*this, op, "fmul");
}

LogicalResult WaveAMDMachineSelector::selectFMax(FMaxOp op) {
  if (isSimdPackedF16(op.getResult().getType()))
    return op.emitError("packed f16 fmax lowering is not implemented");
  return selectF32<waveamdmachine::VMaxF32Op>(*this, op, op.getLhs(),
                                              op.getRhs());
}

LogicalResult WaveAMDMachineSelector::selectFma(FmaOp op) {
  Type resultType = op.getResult().getType();
  if (isSimdF32(resultType))
    return selectF32<waveamdmachine::VFmaF32Op>(*this, op, op.getLhs(),
                                                op.getRhs(), op.getAcc());
  if (isSimdPackedF16(resultType))
    return selectPackedF16Ternary<waveamdmachine::VPkFmaF16Op>(
        *this, op, "fma", op.getLhs(), op.getRhs(), op.getAcc());
  if (isSimdPackedF32(resultType))
    return selectPackedF32Ternary<waveamdmachine::VPkFmaF32Op>(
        *this, op, "fma", op.getLhs(), op.getRhs(), op.getAcc());
  return op.emitError("WaveAMDMachine fma lowering supports only "
                      "!wave.simd<f32, W> or "
                      "!wave.simd<vector<2^nxf16>, W> or "
                      "!wave.simd<vector<2^nxf32>, W>");
}

LogicalResult WaveAMDMachineSelector::selectFExp2(FExp2Op op) {
  return selectF32<waveamdmachine::VExpF32Op>(*this, op, op.getSource());
}

LogicalResult WaveAMDMachineSelector::selectFRcp(FRcpOp op) {
  return selectF32<waveamdmachine::VRcpF32Op>(*this, op, op.getSource());
}

LogicalResult WaveAMDMachineSelector::selectURecip(URecipOp op) {
  Value source = expect(op.getSource(), op);
  Location loc = op.getLoc();
  Type vgprType = getRegType(op.getContext(), waveamdmachine::RegClass::VGPR);
  Value vgprSource = ensureVGPRForVSrc1(loc, source);
  Value fp =
      waveamdmachine::VCvtF32U32Op::create(builder, loc, vgprType, vgprSource);
  Value rcp =
      waveamdmachine::VRcpIFlagF32Op::create(builder, loc, vgprType, fp);
  Value scale = ensureVGPRForVSrc1(loc, createImm(builder, loc, 0x4f7ffffe));
  Value scaled =
      waveamdmachine::VMulF32Op::create(builder, loc, vgprType, scale, rcp);
  Value estimate =
      waveamdmachine::VCvtU32F32Op::create(builder, loc, vgprType, scaled);
  values[op.getResult()] = isa<SimdType>(op.getResult().getType())
                               ? estimate
                               : readFirstLane(*this, loc, estimate);
  eraseIfTopLevel(op);
  return success();
}

LogicalResult WaveAMDMachineSelector::selectCtz(CtzOp op) {
  Value source = expect(op.getSource(), op);
  Location loc = op.getLoc();
  unsigned bits = waveArithElementBits(op.getResult().getType());
  bool simd = isa<SimdType>(op.getResult().getType());
  if (bits == 32) {
    if (!simd) {
      values[op.getResult()] = waveamdmachine::SFf1I32B32Op::create(
          builder, loc,
          getRegType(op.getContext(), waveamdmachine::RegClass::SGPR),
          materializeSGPR1(loc, source));
      eraseIfTopLevel(op);
      return success();
    }
    values[op.getResult()] = waveamdmachine::VFfblB32Op::create(
        builder, loc,
        getRegType(op.getContext(), waveamdmachine::RegClass::VGPR),
        ensureVGPRForVSrc1(loc, source));
    eraseIfTopLevel(op);
    return success();
  }

  if (!simd) {
    Value count = waveamdmachine::SFf1I32B64Op::create(
        builder, loc,
        getRegType(op.getContext(), waveamdmachine::RegClass::SGPR),
        ensureSGPR2(*this, loc, source));
    values[op.getResult()] = ensureSGPR2(*this, loc, count);
    eraseIfTopLevel(op);
    return success();
  }

  Type vgprType = getRegType(op.getContext(), waveamdmachine::RegClass::VGPR);
  auto simdType = cast<SimdType>(op.getResult().getType());
  Type maskType = getRegType(op.getContext(), waveamdmachine::RegClass::SGPR,
                             simdType.getWidth() / 32);
  Value wide = ensureVGPR2(*this, loc, source);
  Value lo = extractLowDword(*this, loc, wide, op.getSource());
  Value hi = extractHighDword(*this, loc, wide);
  Value loCount = waveamdmachine::VFfblB32Op::create(
      builder, loc, vgprType, ensureVGPRForVSrc1(loc, lo));
  Value hiCount = waveamdmachine::VFfblB32Op::create(
      builder, loc, vgprType, ensureVGPRForVSrc1(loc, hi));
  Value hiCountPlus32 =
      createVAddU32(*this, loc, hiCount, createImm(builder, loc, 32));
  Value lowIsZero = createWordCmp(*this, loc, CmpRelation::Eq,
                                  /*signedCmp=*/false, maskType, lo,
                                  createImm(builder, loc, 0));
  Value count = waveamdmachine::VCndmaskB32TupleOp::create(
      builder, loc, vgprType, loCount, hiCountPlus32, lowIsZero);
  values[op.getResult()] = ensureVGPR2(*this, loc, count);
  eraseIfTopLevel(op);
  return success();
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

static std::optional<VectorType> getSimdVectorTypeNoDiag(Type type) {
  auto simdType = dyn_cast<SimdType>(type);
  if (!simdType)
    return std::nullopt;
  auto vecType = dyn_cast<VectorType>(simdType.getElementType());
  if (!vecType || vecType.getRank() != 1)
    return std::nullopt;
  return vecType;
}

static bool isScalarMemoryPayloadElementBits(unsigned bits) {
  return bits == 8 || bits == 16 || bits == 32;
}

static bool hasFixedSingletonSimdVectorPayload(Type type) {
  std::optional<VectorType> vector = getSimdVectorTypeNoDiag(type);
  if (!vector || vector->isScalable() || vector->getNumElements() != 1)
    return false;
  Type elementType = vector->getElementType();
  return elementType.isIntOrFloat() &&
         isScalarMemoryPayloadElementBits(elementType.getIntOrFloatBitWidth());
}

static bool isMemoryPayloadElementBits(unsigned bits) {
  return bits == 4 || isScalarMemoryPayloadElementBits(bits);
}

static std::optional<unsigned> getVectorPayloadBits(VectorType vecType,
                                                    unsigned elementBits) {
  uint64_t payloadBits = vecType.getNumElements() * elementBits;
  if (payloadBits != 16 && payloadBits % 32 != 0)
    return std::nullopt;
  return static_cast<unsigned>(payloadBits);
}

static std::optional<MemoryPayloadShape>
getSimdVectorPayloadShapeNoDiag(Type type) {
  std::optional<VectorType> vecType = getSimdVectorTypeNoDiag(type);
  if (!vecType)
    return std::nullopt;
  Type elementType = vecType->getElementType();
  if (!elementType.isIntOrFloat())
    return std::nullopt;
  unsigned elementBits = elementType.getIntOrFloatBitWidth();
  if (!isMemoryPayloadElementBits(elementBits))
    return std::nullopt;
  std::optional<unsigned> payloadBits =
      getVectorPayloadBits(*vecType, elementBits);
  if (!payloadBits)
    return std::nullopt;
  return MemoryPayloadShape{elementBits, *payloadBits,
                            *payloadBits <= 32 ? 1 : *payloadBits / 32,
                            *payloadBits == 8, *payloadBits == 16};
}

static Value maskLowBits(WaveAMDMachineSelector &S, Location loc, Value value,
                         unsigned bits) {
  if (bits == 32)
    return value;
  Type vgprType =
      getRegType(S.builder.getContext(), waveamdmachine::RegClass::VGPR);
  Value mask = createImm(S.builder, loc, (int64_t{1} << bits) - 1);
  value = S.ensureVGPRForVSrc1(loc, value);
  return waveamdmachine::VAndB32Op::create(S.builder, loc, vgprType, value,
                                           mask);
}

static Value orWord(WaveAMDMachineSelector &S, Location loc, Value lhs,
                    Value rhs) {
  Type vgprType =
      getRegType(S.builder.getContext(), waveamdmachine::RegClass::VGPR);
  return waveamdmachine::VOrB32Op::create(S.builder, loc, vgprType, lhs, rhs);
}

static Value shiftWordLeft(WaveAMDMachineSelector &S, Location loc, Value value,
                           unsigned bits) {
  if (bits == 0)
    return value;
  Type vgprType =
      getRegType(S.builder.getContext(), waveamdmachine::RegClass::VGPR);
  return waveamdmachine::VLshlrevB32Op::create(S.builder, loc, vgprType, value,
                                               createImm(S.builder, loc, bits));
}

static Value shiftWordRight(WaveAMDMachineSelector &S, Location loc,
                            Value value, unsigned bits) {
  if (bits == 0)
    return value;
  Type vgprType =
      getRegType(S.builder.getContext(), waveamdmachine::RegClass::VGPR);
  return waveamdmachine::VLshrrevB32Op::create(S.builder, loc, vgprType, value,
                                               createImm(S.builder, loc, bits));
}

struct WordAlignedExtractPackWord {
  Value source;
  unsigned sourceWordIndex;
  unsigned sourceRegisters;
};

static std::optional<SmallVector<WordAlignedExtractPackWord>>
matchWordAlignedExtractPack(PackOp op);
static FailureOr<bool> canSkipF16ExtractForCasts(ExtractOp op);

static bool isExtractFrom(Value value, Value source, unsigned index) {
  ExtractOp extract = value.getDefiningOp<ExtractOp>();
  return extract && extract.getSource() == source &&
         extract.getIndex() == index;
}

static bool hasSequentialExtracts(ValueRange inputs, unsigned inputIndex,
                                  unsigned elementsPerWord, Value source,
                                  unsigned firstSourceElement) {
  for (unsigned element = 1; element < elementsPerWord; ++element)
    if (!isExtractFrom(inputs[inputIndex + element], source,
                       firstSourceElement + element))
      return false;
  return true;
}

static std::optional<WordAlignedExtractPackWord>
matchWordAlignedExtractPackWord(PackOp op, const MemoryPayloadShape &shape,
                                unsigned wordIndex, unsigned elementsPerWord) {
  unsigned inputIndex = wordIndex * elementsPerWord;
  ExtractOp firstExtract =
      op.getInputs()[inputIndex].getDefiningOp<ExtractOp>();
  if (!firstExtract)
    return std::nullopt;

  Value source = firstExtract.getSource();
  std::optional<MemoryPayloadShape> sourceShape =
      getSimdVectorPayloadShapeNoDiag(source.getType());
  if (!sourceShape || sourceShape->elementBits != shape.elementBits)
    return std::nullopt;

  unsigned firstSourceElement = firstExtract.getIndex();
  if (firstSourceElement % elementsPerWord != 0)
    return std::nullopt;
  unsigned sourceWordIndex = firstSourceElement / elementsPerWord;
  if (sourceWordIndex >= sourceShape->registers)
    return std::nullopt;
  if (!hasSequentialExtracts(op.getInputs(), inputIndex, elementsPerWord,
                             source, firstSourceElement))
    return std::nullopt;
  return WordAlignedExtractPackWord{source, sourceWordIndex,
                                    sourceShape->registers};
}

static std::optional<SmallVector<WordAlignedExtractPackWord>>
matchWordAlignedExtractPack(PackOp op) {
  std::optional<MemoryPayloadShape> shape =
      getSimdVectorPayloadShapeNoDiag(op.getResult().getType());
  if (!shape || shape->elementBits == 0 || 32 % shape->elementBits != 0)
    return std::nullopt;
  unsigned elementsPerWord = 32 / shape->elementBits;
  if (op.getInputs().size() != shape->registers * elementsPerWord)
    return std::nullopt;

  SmallVector<WordAlignedExtractPackWord> words;
  words.reserve(shape->registers);
  for (unsigned wordIndex = 0; wordIndex < shape->registers; ++wordIndex) {
    std::optional<WordAlignedExtractPackWord> word =
        matchWordAlignedExtractPackWord(op, *shape, wordIndex, elementsPerWord);
    if (!word)
      return std::nullopt;
    words.push_back(*word);
  }
  return words;
}

static bool isUsedOnlyByWordAlignedExtractPacks(ExtractOp op) {
  for (Operation *user : op.getResult().getUsers()) {
    PackOp pack = dyn_cast<PackOp>(user);
    if (!pack || !matchWordAlignedExtractPack(pack))
      return false;
  }
  return true;
}

static FailureOr<bool> canDeferExtractSelection(ExtractOp op) {
  if (isUsedOnlyByWordAlignedExtractPacks(op))
    return true;
  return canSkipF16ExtractForCasts(op);
}

static FailureOr<std::optional<SmallVector<Value>>>
trySelectWordAlignedExtractPack(WaveAMDMachineSelector &S, PackOp op,
                                const MemoryPayloadShape &) {
  std::optional<SmallVector<WordAlignedExtractPackWord>> matched =
      matchWordAlignedExtractPack(op);
  if (!matched)
    return std::optional<SmallVector<Value>>();

  SmallVector<Value> words;
  words.reserve(matched->size());
  DenseMap<Value, SmallVector<Value>> sourceWordCache;
  for (WordAlignedExtractPackWord word : *matched) {
    auto [it, inserted] = sourceWordCache.try_emplace(word.source);
    if (inserted) {
      FailureOr<SmallVector<Value>> sourceWords = splitVGPRMaterializedWords(
          S, op, S.expect(word.source, op), word.sourceRegisters,
          "pack extract source");
      if (failed(sourceWords))
        return failure();
      it->second = std::move(*sourceWords);
    }
    words.push_back(it->second[word.sourceWordIndex]);
  }
  return std::optional<SmallVector<Value>>(std::move(words));
}

static Value extractBitsToWord(WaveAMDMachineSelector &S, Location loc,
                               ArrayRef<Value> sourceWords,
                               unsigned sourceBitOffset, unsigned bits) {
  assert(bits > 0 && bits <= 32 && "extract word chunk must fit in a dword");
  unsigned sourceWordIndex = sourceBitOffset / 32;
  unsigned sourceWordShift = sourceBitOffset % 32;
  assert(sourceWordIndex < sourceWords.size() &&
         "source bit offset out of bounds");
  Value word =
      shiftWordRight(S, loc, sourceWords[sourceWordIndex], sourceWordShift);
  unsigned lowBits = std::min(bits, 32 - sourceWordShift);
  word = maskLowBits(S, loc, word, lowBits);
  if (lowBits == bits)
    return word;

  assert(sourceWordIndex + 1 < sourceWords.size() &&
         "cross-word extract missing high word");
  Value high =
      maskLowBits(S, loc, sourceWords[sourceWordIndex + 1], bits - lowBits);
  high = shiftWordLeft(S, loc, high, lowBits);
  return orWord(S, loc, word, high);
}

static SmallVector<Value> extractPayloadWords(WaveAMDMachineSelector &S,
                                              Location loc,
                                              ArrayRef<Value> sourceWords,
                                              unsigned sourceBitOffset,
                                              unsigned payloadBits) {
  SmallVector<Value> resultWords;
  for (unsigned bit = 0; bit < payloadBits; bit += 32) {
    unsigned bits = std::min(32u, payloadBits - bit);
    resultWords.push_back(
        extractBitsToWord(S, loc, sourceWords, sourceBitOffset + bit, bits));
  }
  return resultWords;
}

static FailureOr<std::optional<SmallVector<Value>>>
trySelectVectorChunkPack(WaveAMDMachineSelector &S, PackOp op,
                         const MemoryPayloadShape &shape) {
  ValueRange inputs = op.getInputs();
  std::optional<MemoryPayloadShape> inputShape =
      getSimdVectorPayloadShapeNoDiag(inputs.front().getType());
  if (!inputShape)
    return std::optional<SmallVector<Value>>();
  if (inputShape->elementBits != shape.elementBits)
    return op.emitError("pack input chunk element bits must match result");
  if (inputShape->payloadBits * inputs.size() != shape.payloadBits)
    return op.emitError("pack input chunk bits must match result");

  Location loc = op.getLoc();
  SmallVector<Value> words(shape.registers);
  for (auto [inputIndex, input] : llvm::enumerate(inputs)) {
    FailureOr<SmallVector<Value>> inputWords = splitVGPRMaterializedWords(
        S, op, S.expect(input, op), inputShape->registers, "pack chunk input");
    if (failed(inputWords))
      return failure();
    unsigned baseBit = inputIndex * inputShape->payloadBits;
    for (unsigned bit = 0; bit < inputShape->payloadBits; bit += 32) {
      unsigned bits = std::min(32u, inputShape->payloadBits - bit);
      unsigned resultBit = baseBit + bit;
      unsigned resultWordIndex = resultBit / 32;
      unsigned resultWordShift = resultBit % 32;
      assert(resultWordIndex < words.size() &&
             "pack chunk exceeds result words");
      Value word = maskLowBits(S, loc, (*inputWords)[bit / 32], bits);
      word = shiftWordLeft(S, loc, word, resultWordShift);
      if (!words[resultWordIndex]) {
        words[resultWordIndex] = word;
        continue;
      }
      words[resultWordIndex] = orWord(S, loc, words[resultWordIndex], word);
    }
  }
  return std::optional<SmallVector<Value>>(std::move(words));
}

template <typename InputRange>
static SmallVector<Value>
packScalarInputsIntoWords(WaveAMDMachineSelector &S, Location loc,
                          InputRange inputs, unsigned inputCount,
                          unsigned elementBits, unsigned registers,
                          Operation *user) {
  Type vgprType =
      getRegType(S.builder.getContext(), waveamdmachine::RegClass::VGPR);
  SmallVector<Value> words(registers);
  for (auto [index, input] : llvm::enumerate(inputs)) {
    if (index == inputCount)
      break;
    unsigned bitOffset = index * elementBits;
    unsigned wordIndex = bitOffset / 32;
    unsigned wordShift = bitOffset % 32;
    assert(wordIndex < words.size() && "packed input exceeds result words");
    Value value = S.ensureVGPRForVSrc1(loc, S.expect(input, user));
    value = maskLowBits(S, loc, value, elementBits);
    if (wordShift)
      value = waveamdmachine::VLshlrevB32Op::create(
          S.builder, loc, vgprType, value,
          createImm(S.builder, loc, wordShift));
    if (!words[wordIndex]) {
      words[wordIndex] = value;
      continue;
    }
    words[wordIndex] = waveamdmachine::VOrB32Op::create(
        S.builder, loc, vgprType, words[wordIndex], value);
  }
  return words;
}

static bool isI8TransposeScalePack(PackOp op) {
  auto simdType = dyn_cast<SimdType>(op.getResult().getType());
  if (!simdType || simdType.getWidth() != 64)
    return false;
  auto vecType = dyn_cast<VectorType>(simdType.getElementType());
  return vecType && vecType.getRank() == 1 && !vecType.isScalable() &&
         vecType.getNumElements() == 8 &&
         vecType.getElementType().isInteger(8) && op.getInputs().size() == 8;
}

static bool isMmaScaleScaleUse(OpOperand &use) {
  if (!isa<waveamd::MmaScaleOp>(use.getOwner()))
    return false;
  unsigned operandNumber = use.getOperandNumber();
  return operandNumber == 1 || operandNumber == 3;
}

static bool canPackMmaScaleLowDword(WaveAMDMachineSelector &S, PackOp op) {
  if (!isI8TransposeScalePack(op) || op.getResult().use_empty())
    return false;
  for (OpOperand &use : op.getResult().getUses())
    if (!isMmaScaleScaleUse(use))
      return false;
  for (Value input : llvm::drop_begin(op.getInputs(), 4)) {
    auto it = S.values.find(input);
    if (it == S.values.end() || !isLocalZero(S, it->second))
      return false;
  }
  return true;
}

LogicalResult WaveAMDMachineSelector::selectPack(PackOp op) {
  if (op.getInputs().size() == 1 &&
      hasFixedSingletonSimdVectorPayload(op.getResult().getType())) {
    values[op.getResult()] = expect(op.getInputs().front(), op);
    eraseIfTopLevel(op);
    return success();
  }

  FailureOr<MemoryPayloadShape> shape =
      getSimdVectorPayloadShape(op, op.getResult().getType(), "pack");
  if (failed(shape))
    return failure();

  Location loc = op.getLoc();
  FailureOr<std::optional<SmallVector<Value>>> directWords =
      trySelectWordAlignedExtractPack(*this, op, *shape);
  if (failed(directWords))
    return failure();
  if (*directWords) {
    values[op.getResult()] = joinVGPRWords(*this, loc, **directWords);
    eraseIfTopLevel(op);
    return success();
  }

  FailureOr<std::optional<SmallVector<Value>>> chunkWords =
      trySelectVectorChunkPack(*this, op, *shape);
  if (failed(chunkWords))
    return failure();
  if (*chunkWords) {
    values[op.getResult()] = joinVGPRWords(*this, loc, **chunkWords);
    eraseIfTopLevel(op);
    return success();
  }

  if (canPackMmaScaleLowDword(*this, op)) {
    values[op.getResult()] = packScalarInputsIntoWords(
        *this, loc, op.getInputs(), 4, shape->elementBits, 1, op)[0];
    eraseIfTopLevel(op);
    return success();
  }

  SmallVector<Value> words = packScalarInputsIntoWords(
      *this, loc, op.getInputs(), op.getInputs().size(), shape->elementBits,
      shape->registers, op);
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

static Value extractScalarPayload(WaveAMDMachineSelector &S, ExtractOp op,
                                  const MemoryPayloadShape &shape) {
  Location loc = op.getLoc();
  Type vgprType = getRegType(op.getContext(), waveamdmachine::RegClass::VGPR);
  Value word = S.expect(op.getSource(), op);
  unsigned bitOffset = op.getIndex() * shape.elementBits;
  unsigned wordIndex = bitOffset / 32;
  unsigned wordShift = bitOffset % 32;
  if (shape.registers != 1) {
    SmallVector<Type> elementTypes(shape.registers, vgprType);
    auto split = waveamdmachine::TupleToElementsOp::create(S.builder, loc,
                                                           elementTypes, word);
    word = split.getElements()[wordIndex];
  }
  if (wordShift) {
    word = S.ensureVGPRForVSrc1(loc, word);
    word = waveamdmachine::VLshrrevB32Op::create(
        S.builder, loc, vgprType, word, createImm(S.builder, loc, wordShift));
  }
  return maskLowBits(S, loc, word, shape.elementBits);
}

LogicalResult WaveAMDMachineSelector::selectExtract(ExtractOp op) {
  FailureOr<bool> defer = canDeferExtractSelection(op);
  if (failed(defer))
    return failure();
  if (*defer) {
    eraseIfTopLevel(op);
    return success();
  }

  if (op.getIndex() == 0 &&
      hasFixedSingletonSimdVectorPayload(op.getSource().getType())) {
    values[op.getResult()] = expect(op.getSource(), op);
    eraseIfTopLevel(op);
    return success();
  }

  FailureOr<MemoryPayloadShape> shape =
      getSimdVectorPayloadShape(op, op.getSource().getType(), "extract");
  if (failed(shape))
    return failure();

  Location loc = op.getLoc();
  if (std::optional<VectorType> resultVec =
          getSimdVectorTypeNoDiag(op.getResult().getType())) {
    FailureOr<MemoryPayloadShape> resultShape = getSimdVectorPayloadShape(
        op, op.getResult().getType(), "extract result");
    if (failed(resultShape))
      return failure();
    if (resultShape->elementBits != shape->elementBits)
      return op.emitError("extract result element bits must match source");
    Value source = expect(op.getSource(), op);
    FailureOr<SmallVector<Value>> sourceWords = splitVGPRMaterializedWords(
        *this, op, source, shape->registers, "extract source");
    if (failed(sourceWords))
      return failure();
    unsigned bitOffset = op.getIndex() * shape->elementBits;
    SmallVector<Value> resultWords = extractPayloadWords(
        *this, loc, *sourceWords, bitOffset, resultShape->payloadBits);
    values[op.getResult()] = joinVGPRWords(*this, loc, resultWords);
    eraseIfTopLevel(op);
    return success();
  }

  values[op.getResult()] = extractScalarPayload(*this, op, *shape);
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

static std::optional<CastExtension> getIntConvertExtension(CastOp op) {
  std::optional<DictionaryAttr> policy = op.getPolicy();
  if (!policy)
    return std::nullopt;
  Attribute attr = policy->get("extension");
  if (!attr)
    return std::nullopt;
  return cast<CastExtensionPolicyAttr>(attr).getValue();
}

static Type castElementType(Type type) {
  if (auto simd = dyn_cast<SimdType>(type))
    return simd.getElementType();
  return type;
}

static bool hasI32Element(Type type) {
  return castElementType(type).isInteger(32);
}

static bool has64BitIntElement(Type type) {
  Type elementType = castElementType(type);
  return elementType.isIndex() || elementType.isInteger(64);
}

static LogicalResult selectI32I64IntConvert(WaveAMDMachineSelector &S,
                                            CastOp op) {
  Type sourceType = op.getSource().getType();
  Type resultType = op.getResult().getType();
  Value source = S.expect(op.getSource(), op);
  if (has64BitIntElement(sourceType) && hasI32Element(resultType)) {
    S.values[op.getResult()] =
        extractLowDword(S, op.getLoc(), source, op.getSource());
    S.eraseIfTopLevel(op);
    return success();
  }
  if (hasI32Element(sourceType) && has64BitIntElement(resultType)) {
    if (getIntConvertExtension(op) != CastExtension::Zero)
      return op.emitError(
          "WaveAMDMachine i32 to 64-bit intconvert requires zero extension");
    if (isa<SimdType>(resultType) && !S.isUniformValue(source))
      S.values[op.getResult()] = ensureVGPR2(S, op.getLoc(), source);
    else
      S.values[op.getResult()] = ensureSGPR2(S, op.getLoc(), source);
    S.eraseIfTopLevel(op);
    return success();
  }
  return op.emitError(
      "WaveAMDMachine intconvert lowering supports only i32 <-> 64-bit "
      "integer/index casts");
}

static FailureOr<unsigned> getPackedF32ToF16VectorLength(CastOp op) {
  std::optional<unsigned> sourceLength =
      getSimdPackedF32Length(op.getSource().getType());
  std::optional<unsigned> resultLength =
      getSimdPackedF16Length(op.getResult().getType());
  if (!sourceLength || !resultLength || *sourceLength != *resultLength)
    return op.emitError("packed f32 to f16 lowering requires matching "
                        "!wave.simd<vector<2^nxf32>, W> to "
                        "!wave.simd<vector<2^nxf16>, W>");
  return *sourceLength;
}

static FailureOr<unsigned> getPackedF32ToBF16VectorLength(CastOp op) {
  std::optional<unsigned> sourceLength =
      getSimdPackedF32Length(op.getSource().getType());
  std::optional<unsigned> resultLength =
      getSimdPackedBF16Length(op.getResult().getType());
  if (!sourceLength || !resultLength || *sourceLength != *resultLength)
    return op.emitError("packed f32 to bf16 lowering requires matching "
                        "!wave.simd<vector<2^nxf32>, W> to "
                        "!wave.simd<vector<2^nxbf16>, W>");
  return *sourceLength;
}

static FailureOr<unsigned> getPackedF16ToF32VectorLength(CastOp op) {
  std::optional<unsigned> sourceLength =
      getSimdPackedF16Length(op.getSource().getType());
  std::optional<unsigned> resultLength =
      getSimdPackedF32Length(op.getResult().getType());
  if (!sourceLength || !resultLength || *sourceLength != *resultLength)
    return op.emitError("packed f16 to f32 lowering requires matching "
                        "!wave.simd<vector<2^nxf16>, W> to "
                        "!wave.simd<vector<2^nxf32>, W>");
  return *sourceLength;
}

static bool supportsF16ToF32HalfSelect(const llvm::AMDGPU::IsaVersion &isa) {
  return isa.Major == 8 || isa.Major == 9;
}

static Value createUninitVGPR1(WaveAMDMachineSelector &S, Location loc) {
  return materializeUninitGPR(S.builder, loc, waveamdmachine::RegClass::VGPR,
                              1);
}

template <typename CvtOp>
static Value emitPackedF32ToF16Cvt(WaveAMDMachineSelector &S, Location loc,
                                   ArrayRef<Value> sourceWords,
                                   unsigned vectorLength) {
  Type vgprType =
      getRegType(S.builder.getContext(), waveamdmachine::RegClass::VGPR);
  SmallVector<Value> resultWords;
  resultWords.reserve(getPackedF16WordCount(vectorLength));
  for (unsigned index = 0; index < vectorLength; index += 2) {
    Value hi = index + 1 < vectorLength ? sourceWords[index + 1]
                                        : createUninitVGPR1(S, loc);
    Value word = CvtOp::create(S.builder, loc, vgprType, sourceWords[index], hi)
                     .getResult();
    resultWords.push_back(word);
  }
  return joinVGPRWords(S, loc, resultWords);
}

static Value emitPackedF32ToBF16Cvt(WaveAMDMachineSelector &S, Location loc,
                                    ArrayRef<Value> sourceWords,
                                    unsigned vectorLength) {
  Type vgprType =
      getRegType(S.builder.getContext(), waveamdmachine::RegClass::VGPR);
  SmallVector<Value> resultWords;
  resultWords.reserve(getPackedF16WordCount(vectorLength));
  for (unsigned index = 0; index < vectorLength; index += 2) {
    Value hi = index + 1 < vectorLength ? sourceWords[index + 1]
                                        : createUninitVGPR1(S, loc);
    Value word = waveamdmachine::VCvtPkBF16F32Op::create(
                     S.builder, loc, vgprType, sourceWords[index], hi)
                     .getResult();
    resultWords.push_back(word);
  }
  return joinVGPRWords(S, loc, resultWords);
}

static Value emitScalarF32ToF16Pack(WaveAMDMachineSelector &S, Location loc,
                                    ArrayRef<Value> sourceWords,
                                    unsigned vectorLength) {
  Type vgprType =
      getRegType(S.builder.getContext(), waveamdmachine::RegClass::VGPR);
  SmallVector<Value> resultWords;
  resultWords.reserve(getPackedF16WordCount(vectorLength));
  for (unsigned index = 0; index < vectorLength; index += 2) {
    Value lo = waveamdmachine::VCvtF16F32Op::create(S.builder, loc, vgprType,
                                                    sourceWords[index]);
    lo = maskLowBits(S, loc, lo, 16);
    if (index + 1 == vectorLength) {
      resultWords.push_back(lo);
      continue;
    }
    Value hi = waveamdmachine::VCvtF16F32Op::create(S.builder, loc, vgprType,
                                                    sourceWords[index + 1]);
    hi = maskLowBits(S, loc, hi, 16);
    hi = waveamdmachine::VLshlrevB32Op::create(S.builder, loc, vgprType, hi,
                                               createImm(S.builder, loc, 16));
    resultWords.push_back(
        waveamdmachine::VOrB32Op::create(S.builder, loc, vgprType, lo, hi));
  }
  return joinVGPRWords(S, loc, resultWords);
}

static LogicalResult selectPackedF32ToF16Cast(WaveAMDMachineSelector &S,
                                              CastOp op,
                                              CastRounding rounding) {
  if (rounding != CastRounding::RNE && rounding != CastRounding::RTZ)
    return op.emitError(
        "packed f32 to f16 lowering supports only rne or rtz rounding");

  FailureOr<unsigned> vectorLength = getPackedF32ToF16VectorLength(op);
  if (failed(vectorLength))
    return failure();
  FailureOr<SmallVector<Value>> sourceWords = splitVGPRMaterializedWords(
      S, op.getOperation(), S.expect(op.getSource(), op), *vectorLength,
      "source");
  if (failed(sourceWords))
    return failure();

  if (rounding == CastRounding::RTZ) {
    if (failed(requirePackedRtzCvtTarget(op)))
      return failure();
    S.values[op.getResult()] =
        emitPackedF32ToF16Cvt<waveamdmachine::VCvtPkRtzF16F32Op>(
            S, op.getLoc(), *sourceWords, *vectorLength);
  } else {
    FailureOr<bool> usePacked = supportsPackedRneCvtTarget(op);
    if (failed(usePacked))
      return failure();
    S.values[op.getResult()] =
        *usePacked ? emitPackedF32ToF16Cvt<waveamdmachine::VCvtPkF16F32Op>(
                         S, op.getLoc(), *sourceWords, *vectorLength)
                   : emitScalarF32ToF16Pack(S, op.getLoc(), *sourceWords,
                                            *vectorLength);
  }
  S.eraseIfTopLevel(op);
  return success();
}

static LogicalResult selectPackedF32ToBF16Cast(WaveAMDMachineSelector &S,
                                               CastOp op,
                                               CastRounding rounding) {
  if (rounding != CastRounding::RNE)
    return op.emitError(
        "packed f32 to bf16 lowering supports only rne rounding");

  FailureOr<llvm::AMDGPU::IsaVersion> isa =
      getTargetIsaVersion(op, "packed f32 to bf16 lowering");
  if (failed(isa))
    return failure();
  if (!waveamdmachine::VCvtPkBF16F32Op::isSupportedOnIsa(*isa))
    return op.emitError("v_cvt_pk_bf16_f32 unsupported on target");

  FailureOr<unsigned> vectorLength = getPackedF32ToBF16VectorLength(op);
  if (failed(vectorLength))
    return failure();
  FailureOr<SmallVector<Value>> sourceWords = splitVGPRMaterializedWords(
      S, op.getOperation(), S.expect(op.getSource(), op), *vectorLength,
      "source");
  if (failed(sourceWords))
    return failure();

  S.values[op.getResult()] =
      emitPackedF32ToBF16Cvt(S, op.getLoc(), *sourceWords, *vectorLength);
  S.eraseIfTopLevel(op);
  return success();
}

static LogicalResult selectPackedF16ToF32Cast(WaveAMDMachineSelector &S,
                                              CastOp op,
                                              CastRounding rounding) {
  if (rounding != CastRounding::RNE)
    return op.emitError(
        "packed f16 to f32 lowering supports only rne rounding");

  FailureOr<unsigned> vectorLength = getPackedF16ToF32VectorLength(op);
  if (failed(vectorLength))
    return failure();
  unsigned sourceWordCount = getPackedF16WordCount(*vectorLength);
  FailureOr<SmallVector<Value>> sourceWords = splitVGPRMaterializedWords(
      S, op.getOperation(), S.expect(op.getSource(), op), sourceWordCount,
      "source");
  if (failed(sourceWords))
    return failure();
  FailureOr<llvm::AMDGPU::IsaVersion> isa =
      getTargetIsaVersion(op, "packed f16 to f32 lowering");
  if (failed(isa))
    return failure();

  Type vgprType =
      getRegType(S.builder.getContext(), waveamdmachine::RegClass::VGPR);
  SmallVector<Value> resultWords;
  resultWords.reserve(*vectorLength);
  bool useSdwaHalfSelect = supportsF16ToF32HalfSelect(*isa);
  for (unsigned index : llvm::seq<unsigned>(0, *vectorLength)) {
    Value lane = (*sourceWords)[index / 2];
    if (useSdwaHalfSelect) {
      if (index % 2)
        resultWords.push_back(waveamdmachine::VCvtF32F16SdwaOp::create(
            S.builder, op.getLoc(), vgprType, lane,
            S.builder.getI64IntegerAttr(5)));
      else
        resultWords.push_back(waveamdmachine::VCvtF32F16E32Op::create(
            S.builder, op.getLoc(), vgprType, lane));
      continue;
    }
    if (index % 2)
      lane = waveamdmachine::VLshrrevB32Op::create(
          S.builder, op.getLoc(), vgprType, lane,
          createImm(S.builder, op.getLoc(), 16));
    lane = maskLowBits(S, op.getLoc(), lane, 16);
    resultWords.push_back(waveamdmachine::VCvtF32F16Op::create(
        S.builder, op.getLoc(), vgprType, lane));
  }
  S.values[op.getResult()] = joinVGPRWords(S, op.getLoc(), resultWords);
  S.eraseIfTopLevel(op);
  return success();
}

static bool isF16ToF32Cast(CastOp op) {
  Type f16Type = Float16Type::get(op.getContext());
  Type f32Type = Float32Type::get(op.getContext());
  return getFpConvertRounding(op) == CastRounding::RNE &&
         isSimdScalarElement(op.getSource().getType(), f16Type) &&
         isSimdScalarElement(op.getResult().getType(), f32Type);
}

static bool isUsedOnlyByF16ToF32Casts(ExtractOp op) {
  for (Operation *user : op.getResult().getUsers()) {
    CastOp cast = dyn_cast<CastOp>(user);
    if (!cast || !isF16ToF32Cast(cast))
      return false;
  }
  return !op.getResult().use_empty();
}

static FailureOr<bool> canSkipF16ExtractForCasts(ExtractOp op) {
  if (!isUsedOnlyByF16ToF32Casts(op))
    return false;
  FailureOr<llvm::AMDGPU::IsaVersion> isa =
      getTargetIsaVersion(op, "packed f16 extract cast lowering");
  if (failed(isa))
    return failure();
  return supportsF16ToF32HalfSelect(*isa);
}

static FailureOr<std::optional<Value>>
trySelectPackedF16ExtractToF32Cast(WaveAMDMachineSelector &S, CastOp op,
                                   const llvm::AMDGPU::IsaVersion &isa) {
  if (!supportsF16ToF32HalfSelect(isa))
    return std::optional<Value>();
  ExtractOp extract = op.getSource().getDefiningOp<ExtractOp>();
  if (!extract)
    return std::optional<Value>();
  FailureOr<MemoryPayloadShape> shape = getSimdVectorPayloadShape(
      extract, extract.getSource().getType(), "packed f16 scalar cast source");
  if (failed(shape))
    return failure();
  if (shape->elementBits != 16)
    return std::optional<Value>();

  unsigned bitOffset = extract.getIndex() * shape->elementBits;
  unsigned wordIndex = bitOffset / 32;
  if (wordIndex >= shape->registers)
    return op.emitError("packed f16 scalar cast source index out of range");
  FailureOr<SmallVector<Value>> sourceWords = splitVGPRMaterializedWords(
      S, op.getOperation(), S.expect(extract.getSource(), op), shape->registers,
      "packed f16 scalar cast source");
  if (failed(sourceWords))
    return failure();

  Value word = (*sourceWords)[wordIndex];
  Type vgprType = getRegType(op.getContext(), waveamdmachine::RegClass::VGPR);
  if ((bitOffset % 32) == 0)
    return std::optional<Value>(waveamdmachine::VCvtF32F16E32Op::create(
        S.builder, op.getLoc(), vgprType, word));
  return std::optional<Value>(waveamdmachine::VCvtF32F16SdwaOp::create(
      S.builder, op.getLoc(), vgprType, word, S.builder.getI64IntegerAttr(5)));
}

static LogicalResult selectScalarFpConvert(WaveAMDMachineSelector &S, CastOp op,
                                           Type sourceElement,
                                           Type resultElement,
                                           CastRounding rounding) {
  if (rounding != CastRounding::RNE)
    return op.emitError(
        "WaveAMDMachine fpconvert lowering supports only rne rounding");

  Type vgprType = getRegType(op.getContext(), waveamdmachine::RegClass::VGPR);
  if (sourceElement.isF32() && resultElement.isF16()) {
    Value source =
        S.ensureVGPRForVSrc1(op.getLoc(), S.expect(op.getSource(), op));
    S.values[op.getResult()] = waveamdmachine::VCvtF16F32Op::create(
        S.builder, op.getLoc(), vgprType, source);
    S.eraseIfTopLevel(op);
    return success();
  }
  if (sourceElement.isF16() && resultElement.isF32()) {
    FailureOr<llvm::AMDGPU::IsaVersion> isa =
        getTargetIsaVersion(op, "scalar f16 to f32 lowering");
    if (failed(isa))
      return failure();
    FailureOr<std::optional<Value>> packedExtract =
        trySelectPackedF16ExtractToF32Cast(S, op, *isa);
    if (failed(packedExtract))
      return failure();
    if (*packedExtract)
      S.values[op.getResult()] = **packedExtract;
    else {
      Value source =
          S.ensureVGPRForVSrc1(op.getLoc(), S.expect(op.getSource(), op));
      S.values[op.getResult()] =
          supportsF16ToF32HalfSelect(*isa)
              ? waveamdmachine::VCvtF32F16E32Op::create(S.builder, op.getLoc(),
                                                        vgprType, source)
                    .getResult()
              : waveamdmachine::VCvtF32F16Op::create(S.builder, op.getLoc(),
                                                     vgprType, source)
                    .getResult();
    }
    S.eraseIfTopLevel(op);
    return success();
  }
  return op.emitError(
      "WaveAMDMachine fpconvert lowering supports only f32/f16 SIMD, "
      "vector<2^nxf32> to vector<2^nxf16> SIMD, or vector<2^nxf32> to "
      "vector<2^nxbf16> SIMD");
}

static std::optional<LogicalResult>
selectPackedFpConvert(WaveAMDMachineSelector &S, CastOp op,
                      CastRounding rounding) {
  Type f16Type = Float16Type::get(op.getContext());
  Type bf16Type = BFloat16Type::get(op.getContext());
  Type f32Type = Float32Type::get(op.getContext());

  if (isSimdVectorElement(op.getSource().getType(), f32Type) &&
      isSimdVectorElement(op.getResult().getType(), f16Type))
    return selectPackedF32ToF16Cast(S, op, rounding);
  if (isSimdVectorElement(op.getSource().getType(), f32Type) &&
      isSimdVectorElement(op.getResult().getType(), bf16Type))
    return selectPackedF32ToBF16Cast(S, op, rounding);
  if (isSimdVectorElement(op.getSource().getType(), f16Type) &&
      isSimdVectorElement(op.getResult().getType(), f32Type))
    return selectPackedF16ToF32Cast(S, op, rounding);
  return std::nullopt;
}

LogicalResult WaveAMDMachineSelector::selectCast(CastOp op) {
  if (op.getKind() == CastKind::IntConvert)
    return selectI32I64IntConvert(*this, op);
  if (op.getKind() != CastKind::FpConvert)
    return op.emitError(
        "WaveAMDMachine backend only supports fpconvert and scalar "
        "index/i32 intconvert wave.cast");
  SimdType sourceType = dyn_cast<SimdType>(op.getSource().getType());
  SimdType resultType = dyn_cast<SimdType>(op.getResult().getType());
  if (!sourceType || !resultType)
    return op.emitError("WaveAMDMachine backend only supports SIMD wave.cast");
  Type sourceElement = sourceType.getElementType();
  Type resultElement = resultType.getElementType();
  CastRounding rounding = getFpConvertRounding(op);
  std::optional<LogicalResult> packed =
      selectPackedFpConvert(*this, op, rounding);
  if (packed)
    return *packed;
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

static std::optional<CmpRelation>
getOrderedCmpRelation(arith::CmpFPredicate predicate) {
  switch (predicate) {
  case arith::CmpFPredicate::OEQ:
    return CmpRelation::Eq;
  case arith::CmpFPredicate::OLT:
    return CmpRelation::Lt;
  case arith::CmpFPredicate::OLE:
    return CmpRelation::Le;
  case arith::CmpFPredicate::OGT:
    return CmpRelation::Gt;
  case arith::CmpFPredicate::OGE:
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

static Value createVCmpF32(OpBuilder &builder, Location loc,
                           CmpRelation relation, Type resultType, Value lhs,
                           Value rhs) {
  switch (relation) {
  case CmpRelation::Eq:
    return waveamdmachine::VCmpEqF32Op::create(builder, loc, resultType, lhs,
                                               rhs);
  case CmpRelation::Lt:
    return waveamdmachine::VCmpLtF32Op::create(builder, loc, resultType, lhs,
                                               rhs);
  case CmpRelation::Le:
    return waveamdmachine::VCmpLeF32Op::create(builder, loc, resultType, lhs,
                                               rhs);
  case CmpRelation::Gt:
    return waveamdmachine::VCmpGtF32Op::create(builder, loc, resultType, lhs,
                                               rhs);
  case CmpRelation::Ge:
    return waveamdmachine::VCmpGeF32Op::create(builder, loc, resultType, lhs,
                                               rhs);
  case CmpRelation::Ne:
    llvm_unreachable("ordered f32 not-equal compare is unsupported");
  }
  llvm_unreachable("handled ordered f32 compare relation");
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

static Value createVCmpF32Vcc(OpBuilder &builder, Location loc,
                              CmpRelation relation, Type resultType,
                              Type vccType, Value lhs, Value rhs) {
  switch (relation) {
  case CmpRelation::Eq:
    return waveamdmachine::VCmpEqF32VccOp::create(builder, loc, resultType,
                                                  vccType, lhs, rhs)
        .getResult();
  case CmpRelation::Lt:
    return waveamdmachine::VCmpLtF32VccOp::create(builder, loc, resultType,
                                                  vccType, lhs, rhs)
        .getResult();
  case CmpRelation::Le:
    return waveamdmachine::VCmpLeF32VccOp::create(builder, loc, resultType,
                                                  vccType, lhs, rhs)
        .getResult();
  case CmpRelation::Gt:
    return waveamdmachine::VCmpGtF32VccOp::create(builder, loc, resultType,
                                                  vccType, lhs, rhs)
        .getResult();
  case CmpRelation::Ge:
    return waveamdmachine::VCmpGeF32VccOp::create(builder, loc, resultType,
                                                  vccType, lhs, rhs)
        .getResult();
  case CmpRelation::Ne:
    llvm_unreachable("ordered f32 not-equal compare is unsupported");
  }
  llvm_unreachable("handled ordered f32 compare relation");
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

static SmallVector<Value, 2> splitStaticMaskWords(WaveAMDMachineSelector &S,
                                                  Location loc, int64_t bits,
                                                  unsigned width) {
  assert((width == 1 || width == 2) && "immediate mask width required");
  SmallVector<Value, 2> words;
  uint64_t raw = static_cast<uint64_t>(bits);
  words.push_back(
      createImm(S.builder, loc, static_cast<int64_t>(raw & 0xffffffffull)));
  if (width == 2)
    words.push_back(createImm(S.builder, loc, static_cast<int64_t>(raw >> 32)));
  return words;
}

static SmallVector<Value, 2>
splitRegisterMaskWords(WaveAMDMachineSelector &S, Location loc, Value mask,
                       waveamdmachine::RegType regType, unsigned width) {
  assert(regType.getRegClass() == waveamdmachine::RegClass::SGPR &&
         "compare mask must be SGPR");
  assert((regType.getWidth() == 1 || regType.getWidth() == 2) &&
         "compare mask must be SGPR1/2");
  assert((width == 0 || width == regType.getWidth()) &&
         "mask word count mismatch");
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

static SmallVector<Value, 2> splitMaskWords(WaveAMDMachineSelector &S,
                                            Location loc, Value mask,
                                            unsigned width = 0) {
  if (auto regType = dyn_cast<waveamdmachine::RegType>(mask.getType()))
    return splitRegisterMaskWords(S, loc, mask, regType, width);
  std::optional<int64_t> bits = getStaticWideInt(S, mask);
  assert(bits && "mask must be a register or static value");
  return splitStaticMaskWords(S, loc, *bits, width);
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

static unsigned getRegisterWidth(Value value) {
  waveamdmachine::RegType type =
      dyn_cast<waveamdmachine::RegType>(value.getType());
  return type ? type.getWidth() : 0;
}

static Value combineMasks(WaveAMDMachineSelector &S, Location loc, Value lhs,
                          Value rhs, MaskCombiner combiner,
                          unsigned width = 0) {
  unsigned maskWidth =
      width ? width : std::max(getRegisterWidth(lhs), getRegisterWidth(rhs));
  if (maskWidth == 2)
    return bitwiseWide(S, loc,
                       combiner == MaskCombiner::And ? BinaryKind::AndI
                                                     : BinaryKind::OrI,
                       lhs, rhs);

  SmallVector<Value, 2> lhsWords = splitMaskWords(S, loc, lhs, width);
  SmallVector<Value, 2> rhsWords = splitMaskWords(S, loc, rhs, width);
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
                      Value rhs, unsigned width = 0) {
  return combineMasks(S, loc, lhs, rhs, MaskCombiner::And, width);
}

static Value orMasks(WaveAMDMachineSelector &S, Location loc, Value lhs,
                     Value rhs, unsigned width = 0) {
  return combineMasks(S, loc, lhs, rhs, MaskCombiner::Or, width);
}

Value createWordCmp(WaveAMDMachineSelector &S, Location loc,
                    CmpRelation relation, bool signedCmp, Type resultType,
                    Value lhs, Value rhs) {
  bool legacyVcc = usesLegacyVCmpVcc(S);
  if (legacyVcc) {
    if (isa<waveamdmachine::ImmType>(lhs.getType()))
      lhs = S.materializeSGPR1(loc, lhs);
    if (isa<waveamdmachine::ImmType>(rhs.getType()))
      rhs = S.materializeSGPR1(loc, rhs);
    shapeVALUOperands(S, loc, /*user=*/nullptr, VALUOperandShape::AnyVGPR, lhs,
                      rhs);
    return createVCmpVcc(S.builder, loc, relation, signedCmp, resultType,
                         getVCCType(S.builder.getContext()), lhs, rhs);
  }
  if (isa<waveamdmachine::ImmType>(lhs.getType()) &&
      isa<waveamdmachine::ImmType>(rhs.getType()))
    lhs = S.materializeSGPR1(loc, lhs);
  shapeVALUOperands(S, loc, /*user=*/nullptr, VALUOperandShape::AnyVGPR, lhs,
                    rhs);
  return createVCmp(S.builder, loc, relation, signedCmp, resultType, lhs, rhs);
}

static Value createF32Cmp(WaveAMDMachineSelector &S, Location loc,
                          CmpRelation relation, Type resultType, Value lhs,
                          Value rhs) {
  bool legacyVcc = usesLegacyVCmpVcc(S);
  if (legacyVcc) {
    if (isa<waveamdmachine::ImmType>(lhs.getType()))
      lhs = S.materializeSGPR1(loc, lhs);
    if (isa<waveamdmachine::ImmType>(rhs.getType()))
      rhs = S.materializeSGPR1(loc, rhs);
    shapeVALUOperands(S, loc, /*user=*/nullptr, VALUOperandShape::AnyVGPR, lhs,
                      rhs);
    return createVCmpF32Vcc(S.builder, loc, relation, resultType,
                            getVCCType(S.builder.getContext()), lhs, rhs);
  }
  if (isa<waveamdmachine::ImmType>(lhs.getType()) &&
      isa<waveamdmachine::ImmType>(rhs.getType()))
    lhs = S.materializeSGPR1(loc, lhs);
  shapeVALUOperands(S, loc, /*user=*/nullptr, VALUOperandShape::AnyVGPR, lhs,
                    rhs);
  return createVCmpF32(S.builder, loc, relation, resultType, lhs, rhs);
}

static Value signExtendVGPR2(WaveAMDMachineSelector &S, Location loc,
                             Value source, Value selected) {
  if (!isa<SimdType>(source.getType()))
    return ensureVGPR2(S, loc, signExtendSGPR2(S, loc, selected));
  if (std::optional<int64_t> imm = S.getImmediateValue(selected))
    return ensureVGPR2(S, loc, selected);
  if (std::optional<Value> lo = zeroExtendedLowDword(S, selected))
    selected = *lo;
  else if (isVGPR2(selected))
    return selected;
  else if (isSGPR2(selected))
    return ensureVGPR2(S, loc, selected);

  auto simdType = cast<SimdType>(source.getType());
  Type maskType =
      getRegType(S.builder.getContext(), waveamdmachine::RegClass::SGPR,
                 simdType.getWidth() / 32);
  Type vgpr1 =
      getRegType(S.builder.getContext(), waveamdmachine::RegClass::VGPR, 1);
  Value lo = S.ensureVGPRForVSrc1(loc, selected);
  Value negative = createWordCmp(S, loc, CmpRelation::Lt, /*signedCmp=*/true,
                                 maskType, lo, createImm(S.builder, loc, 0));
  Value hi = waveamdmachine::VCndmaskB32TupleOp::create(
                 S.builder, loc, vgpr1, createImm(S.builder, loc, 0),
                 createImm(S.builder, loc, -1), negative)
                 .getResult();
  return tuple2(S, loc, waveamdmachine::RegClass::VGPR, lo, hi);
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

Value createI64Cmp(WaveAMDMachineSelector &S, Location loc,
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

Value createScalarI64Cmp(WaveAMDMachineSelector &S, Location loc,
                         CmpRelation relation, bool signedCmp, Value lhs,
                         Value rhs) {
  if (relation == CmpRelation::Eq || relation == CmpRelation::Ne) {
    Type scc = getSCCType(S.builder.getContext());
    lhs = ensureSGPR2(S, loc, lhs);
    rhs = ensureSGPR2(S, loc, rhs);
    if (relation == CmpRelation::Eq)
      return waveamdmachine::SCmpEqU64Op::create(S.builder, loc, scc, lhs, rhs);
    return waveamdmachine::SCmpLgU64Op::create(S.builder, loc, scc, lhs, rhs);
  }

  I64Dwords lhsDwords = splitI64Dwords(S, loc, lhs);
  I64Dwords rhsDwords = splitI64Dwords(S, loc, rhs);
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

static unsigned getIndexCmpValueBits(WaveAMDMachineSelector &S, Value value,
                                     bool signedCmp) {
  if (auto regType = dyn_cast<waveamdmachine::RegType>(value.getType())) {
    if (regType.getWidth() <= 1)
      return 32;
    return regType.getWidth() * 32;
  }
  if (std::optional<int64_t> imm = S.getImmediateValue(value)) {
    if (signedCmp)
      return llvm::isInt<32>(*imm) ? 32 : 64;
    return llvm::isInt<32>(*imm) || llvm::isUInt<32>(*imm) ? 32 : 64;
  }
  return 64;
}

static FailureOr<unsigned> getCmpElementBits(WaveAMDMachineSelector &S,
                                             CmpIOp op, Value lhs, Value rhs,
                                             bool signedCmp) {
  auto simdType = cast<SimdType>(op.getLhs().getType());
  Type elementType = simdType.getElementType();
  if (elementType.isIndex())
    return std::max(getIndexCmpValueBits(S, lhs, signedCmp),
                    getIndexCmpValueBits(S, rhs, signedCmp));

  IntegerType integerType = dyn_cast<IntegerType>(elementType);
  if (integerType &&
      (integerType.getWidth() == 32 || integerType.getWidth() == 64))
    return integerType.getWidth();

  op.emitError("WaveAMDMachine backend supports only "
               "!wave.simd<i32/i64/index, W> cmpi operands");
  return failure();
}

static FailureOr<Value> createFullMaskFromSCC(WaveAMDMachineSelector &S,
                                              Operation *op, Value scc,
                                              unsigned width);

static bool hasUniformCmpPayload(Value lhs, Value rhs, unsigned bits) {
  unsigned valueWidth = bits / 32;
  return isUniformPayloadValue(lhs, valueWidth) &&
         isUniformPayloadValue(rhs, valueWidth);
}

static Value createScalarCmpSCC(WaveAMDMachineSelector &S, CmpIOp op,
                                CmpRelation relation, bool signedCmp, Value lhs,
                                Value rhs, unsigned bits) {
  if (bits == 64)
    return createScalarI64Cmp(S, op.getLoc(), relation, signedCmp, lhs, rhs);
  return createScalarWordCmp(S, op.getLoc(), relation, signedCmp, lhs, rhs);
}

LogicalResult WaveAMDMachineSelector::selectCmp(CmpIOp op) {
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
  FailureOr<unsigned> bits = getCmpElementBits(*this, op, lhs, rhs, signedCmp);
  if (failed(bits))
    return failure();
  if (*bits != 32 && *bits != 64)
    return op.emitError("unsupported wave.cmpi operand register width");
  if (hasUniformCmpPayload(lhs, rhs, *bits)) {
    Value scc =
        createScalarCmpSCC(*this, op, *relation, signedCmp, lhs, rhs, *bits);
    FailureOr<Value> result =
        createFullMaskFromSCC(*this, op, scc, maskType.getWidth() / 32);
    if (failed(result))
      return failure();
    values[op.getResult()] = *result;
    eraseIfTopLevel(op);
    return success();
  }
  Value result = *bits == 64 ? createI64Cmp(*this, op.getLoc(), *relation,
                                            signedCmp, sgprType, lhs, rhs)
                             : createWordCmp(*this, op.getLoc(), *relation,
                                             signedCmp, sgprType, lhs, rhs);
  values[op.getResult()] = result;
  eraseIfTopLevel(op);
  return success();
}

LogicalResult WaveAMDMachineSelector::selectCmpF(CmpFOp op) {
  MaskType maskType = cast<MaskType>(op.getType());
  if (maskType.getWidth() != 32 && maskType.getWidth() != 64)
    return op.emitError(
        "WaveAMDMachine backend supports only !wave.mask<32/64>");
  SimdType operandType = cast<SimdType>(op.getLhs().getType());
  if (!operandType.getElementType().isF32())
    return op.emitError(
        "WaveAMDMachine backend supports only !wave.simd<f32, W> cmpf "
        "operands");
  std::optional<CmpRelation> relation =
      getOrderedCmpRelation(op.getPredicate());
  if (!relation)
    return op.emitError("WaveAMDMachine backend supports only ordered "
                        "eq/lt/le/gt/ge wave.cmpf predicates");
  Type sgprType = getRegType(op.getContext(), waveamdmachine::RegClass::SGPR,
                             maskType.getWidth() / 32);
  Value lhs = expect(op.getLhs(), op);
  Value rhs = expect(op.getRhs(), op);
  values[op.getResult()] =
      createF32Cmp(*this, op.getLoc(), *relation, sgprType, lhs, rhs);
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
  if (width == 2) {
    auto regType = dyn_cast<waveamdmachine::RegType>(value.getType());
    if (isMachineImm(value) ||
        (regType && regType.getRegClass() == waveamdmachine::RegClass::SGPR &&
         regType.getWidth() == 1))
      value = ensureSGPR2(S, op->getLoc(), value);
  }
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

static FailureOr<Value> ensureImmLaneSelectVGPR(WaveAMDMachineSelector &S,
                                                Operation *op, Value value,
                                                unsigned width,
                                                Type resultType) {
  if (!isMachineImm(value))
    return op->emitError("lane select source must be register or immediate");
  if (width == 2)
    return ensureVGPR2(S, op->getLoc(), value);
  return waveamdmachine::VMovB32TupleOp::create(S.builder, op->getLoc(),
                                                resultType, value)
      .getResult();
}

static FailureOr<Value>
ensureRegLaneSelectVGPR(WaveAMDMachineSelector &S, Operation *op, Value value,
                        unsigned width, Type resultType,
                        waveamdmachine::RegType regType) {
  if (regType.getRegClass() == waveamdmachine::RegClass::VGPR &&
      regType.getWidth() == width)
    return value;
  if (width == 2 && regType.getWidth() == 1 &&
      (regType.getRegClass() == waveamdmachine::RegClass::VGPR ||
       regType.getRegClass() == waveamdmachine::RegClass::SGPR))
    return ensureVGPR2(S, op->getLoc(), value);
  if (regType.getRegClass() == waveamdmachine::RegClass::SGPR &&
      regType.getWidth() == width)
    return waveamdmachine::VMovB32TupleOp::create(S.builder, op->getLoc(),
                                                  resultType, value)
        .getResult();
  return op->emitError("lane select source width/register class mismatch");
}

static FailureOr<Value> ensureLaneSelectVGPR(WaveAMDMachineSelector &S,
                                             Operation *op, Value value,
                                             unsigned width) {
  Type resultType =
      getRegType(op->getContext(), waveamdmachine::RegClass::VGPR, width);
  waveamdmachine::RegType regType =
      dyn_cast<waveamdmachine::RegType>(value.getType());
  if (!regType)
    return ensureImmLaneSelectVGPR(S, op, value, width, resultType);
  return ensureRegLaneSelectVGPR(S, op, value, width, resultType, regType);
}

FailureOr<Value> createLaneSelect(WaveAMDMachineSelector &S, Operation *op,
                                  Value condition, Value trueValue,
                                  Value falseValue, unsigned width) {
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

static std::optional<int64_t> getStaticMaskBits(WaveAMDMachineSelector &S,
                                                Value value) {
  if (std::optional<int64_t> imm = S.getImmediateValue(value))
    return imm;
  if (auto mov = value.getDefiningOp<waveamdmachine::SMovB64ImmOp>())
    return mov.getValue();
  return std::nullopt;
}

static bool isZeroMaskBits(WaveAMDMachineSelector &S, Value value,
                           unsigned width) {
  std::optional<int64_t> bits = getStaticMaskBits(S, value);
  if (!bits)
    return false;
  return width == 1 ? static_cast<uint32_t>(*bits) == 0
                    : static_cast<uint64_t>(*bits) == 0;
}

static bool isAllOnesMaskBits(WaveAMDMachineSelector &S, Value value,
                              unsigned width) {
  std::optional<int64_t> bits = getStaticMaskBits(S, value);
  if (!bits)
    return false;
  return width == 1 ? static_cast<uint32_t>(*bits) == ~uint32_t{0}
                    : static_cast<uint64_t>(*bits) == ~uint64_t{0};
}

static std::optional<Value>
foldMaskSelectCondition(WaveAMDMachineSelector &S, Value condition,
                        Value trueValue, Value falseValue, unsigned width) {
  if (isZeroMaskBits(S, condition, width))
    return falseValue;
  if (isAllOnesMaskBits(S, condition, width))
    return trueValue;
  return std::nullopt;
}

static Value createMaskSelectWithFalseZero(WaveAMDMachineSelector &S,
                                           Location loc, Value condition,
                                           Value trueValue, Value falseValue,
                                           unsigned width) {
  if (isZeroMaskBits(S, trueValue, width))
    return falseValue;
  if (trueValue == condition || isAllOnesMaskBits(S, trueValue, width))
    return condition;
  return andMasks(S, loc, condition, trueValue, width);
}

static Value createMaskSelectWithTrueOnes(WaveAMDMachineSelector &S,
                                          Location loc, Value condition,
                                          Value trueValue, Value falseValue,
                                          unsigned width) {
  if (isAllOnesMaskBits(S, falseValue, width))
    return trueValue;
  if (falseValue == condition)
    return condition;
  return orMasks(S, loc, condition, falseValue, width);
}

static FailureOr<Value> createMaskSelect(WaveAMDMachineSelector &S, SelectOp op,
                                         Value condition, Value trueValue,
                                         Value falseValue, unsigned width) {
  if (trueValue == falseValue)
    return trueValue;
  if (std::optional<Value> folded =
          foldMaskSelectCondition(S, condition, trueValue, falseValue, width))
    return *folded;
  if (isZeroMaskBits(S, falseValue, width))
    return createMaskSelectWithFalseZero(S, op.getLoc(), condition, trueValue,
                                         falseValue, width);
  if (isAllOnesMaskBits(S, trueValue, width))
    return createMaskSelectWithTrueOnes(S, op.getLoc(), condition, trueValue,
                                        falseValue, width);

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
    SmallVector<WideSymbolBinding, 4> bindings;
    for (const PointerOffsetBinding &binding : offset.bindings)
      bindings.push_back(
          {binding.name, binding.value, S.expect(binding.value, op)});
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

static LogicalResult
selectScalarConditionRegisterValue(WaveAMDMachineSelector &S, SelectOp op,
                                   Value trueValue, Value falseValue,
                                   Type resultType, unsigned width) {
  Value scc = createSCCFromI1(S, op);
  if (isUniformPayloadValue(trueValue, width) &&
      isUniformPayloadValue(falseValue, width)) {
    FailureOr<Value> selected =
        createScalarSelect(S, op, scc, trueValue, falseValue, width);
    if (failed(selected))
      return failure();
    S.values[op.getResult()] = *selected;
    return success();
  }
  if (isa<SimdType>(resultType)) {
    unsigned maskWidth = cast<SimdType>(resultType).getWidth() / 32;
    FailureOr<Value> condition = createFullMaskFromSCC(S, op, scc, maskWidth);
    if (failed(condition))
      return failure();
    FailureOr<Value> selected =
        createLaneSelect(S, op, *condition, trueValue, falseValue, width);
    if (failed(selected))
      return failure();
    S.values[op.getResult()] = *selected;
    return success();
  }
  FailureOr<Value> selected =
      createScalarSelect(S, op, scc, trueValue, falseValue, width);
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
  return selectScalarConditionRegisterValue(S, op, trueValue, falseValue,
                                            resultType, *width);
}

LogicalResult WaveAMDMachineSelector::selectSelect(SelectOp op) {
  bool maskCondition = isa<MaskType>(op.getCondition().getType());
  Type resultType = op.getType();
  if (isa<MemTokenType>(resultType))
    return selectTokenSelect(op);
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
  values[op.getResult()] = readFirstLane(*this, op.getLoc(), src);
  eraseIfTopLevel(op);
  return success();
}

static FailureOr<Value> materializeShuffleByteAddress(WaveAMDMachineSelector &S,
                                                      ShuffleOp op,
                                                      Value sourceLane) {
  Location loc = op.getLoc();
  Value lane = extractLowDword(S, loc, sourceLane, op.getSourceLane());
  if (std::optional<int64_t> imm = S.getImmediateValue(lane)) {
    std::optional<int64_t> byteOffset = llvm::checkedMul(*imm, int64_t{4});
    if (!byteOffset)
      return op.emitError("shuffle source lane byte address overflows i64");
    return S.ensureVGPRForVSrc1(loc, createImm(S.builder, loc, *byteOffset));
  }
  lane = S.ensureVGPRForVSrc1(loc, lane);
  return waveamdmachine::VLshlrevB32Op::create(
             S.builder, loc,
             getRegType(S.builder.getContext(), waveamdmachine::RegClass::VGPR),
             lane, createImm(S.builder, loc, 2))
      .getResult();
}

LogicalResult WaveAMDMachineSelector::selectShuffle(ShuffleOp op) {
  FailureOr<unsigned> words = getRegisterPayloadWidth(
      op.getResult().getType(), [&]() { return op.emitError(); });
  if (failed(words))
    return failure();

  FailureOr<SmallVector<Value>> sourceWords = splitVGPRMaterializedWords(
      *this, op.getOperation(), expect(op.getSource(), op), *words,
      "shuffle source");
  if (failed(sourceWords))
    return failure();

  Value sourceLane = expect(op.getSourceLane(), op);
  FailureOr<Value> addr = materializeShuffleByteAddress(*this, op, sourceLane);
  if (failed(addr))
    return failure();

  Type vgprType = getRegType(op.getContext(), waveamdmachine::RegClass::VGPR);
  SmallVector<Value> resultWords;
  resultWords.reserve(sourceWords->size());
  for (Value word : *sourceWords)
    resultWords.push_back(waveamdmachine::DsBpermuteB32Op::create(
        builder, op.getLoc(), vgprType, *addr, word));
  values[op.getResult()] = joinVGPRWords(*this, op.getLoc(), resultWords);
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
  // VOP2 vsrc1 must be VGPR. Put SGPR/literal in vsrc0 when possible.
  shapeVALUOperands(*this, loc, /*user=*/nullptr,
                    VALUOperandShape::VOP2Commutative, lhs, rhs);
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
  Value shift = createImm(S.builder, loc, llvm::Log2_64(*pow2));
  shapeVALUOperands(S, loc, /*user=*/nullptr, VALUOperandShape::ValueVGPR,
                    value, shift);
  return waveamdmachine::VLshlrevB32Op::create(
             S.builder, loc,
             getRegType(S.builder.getContext(), waveamdmachine::RegClass::VGPR),
             value, shift)
      .getResult();
}

static Value foldIndexMul(WaveAMDMachineSelector &S, Location loc, Value lhs,
                          Value rhs, std::optional<int64_t> lhsImm,
                          std::optional<int64_t> rhsImm) {
  if (std::optional<Value> folded = S.foldImmMul(loc, lhsImm, rhsImm))
    return *folded;
  if (lhsImm && *lhsImm == 1)
    return rhs;
  if (rhsImm && *rhsImm == 1)
    return lhs;
  return {};
}

Value WaveAMDMachineSelector::mulIndexValues(Location loc, Value lhs,
                                             Value rhs) {
  std::optional<int64_t> lhsImm = getImmediateValue(lhs);
  std::optional<int64_t> rhsImm = getImmediateValue(rhs);
  if (Value folded = foldIndexMul(*this, loc, lhs, rhs, lhsImm, rhsImm))
    return folded;
  if (isUniformValue(lhs) && isUniformValue(rhs))
    return mulUniformValues(loc, lhs, rhs);
  if (Value shifted = tryMulIndexPow2(*this, loc, lhs, rhs, lhsImm, rhsImm))
    return shifted;
  shapeVALUOperands(*this, loc, /*user=*/nullptr, VALUOperandShape::AnyVGPR,
                    lhs, rhs);
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
  acc = ensureSGPR1(loc, acc);
  add = ensureSGPR1(loc, add);
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

static bool valueRangeFitsU32(WaveAMDMachineSelector &S, Value value) {
  std::optional<ConstantIntRanges> range = S.finiteSignedRange(value);
  return range && !range->smin().isNegative() &&
         range->smax().getActiveBits() <= 32;
}

static bool needsWideIndexExprValue(WaveAMDMachineSelector &S, IndexExprOp op,
                                    const PointerOffset &offset) {
  return offset.expr && isIndexValueType(op.getResult().getType()) &&
         !S.slotFitsU32(offset.expr, offset.assumptions) &&
         !valueRangeFitsU32(S, op.getResult());
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
    FailureOr<Value> value = failure();
    if (needsWideIndexExprValue(*this, op, *pointerOffset)) {
      value =
          op.getResult().getType().isIndex()
              ? materializeUniformPointerOffsetWideValue(*this, op,
                                                         *pointerOffset)
              : materializePointerOffsetWideValue(*this, op, *pointerOffset);
    } else {
      value = materializePointerOffsetValue(*this, op, *pointerOffset);
    }
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
  if (succeeded(simplified) &&
      shouldUseSimplifiedIndexExpr(*simplified, pointerOffset.expr))
    pointerOffset.expr = *simplified;
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

static std::optional<IntRange64>
inferPointerOffsetRange(WaveAMDMachineSelector &S, const PointerOffset &offset);

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
  if (std::optional<IntRange64> range = inferPointerOffsetRange(S, offset);
      range && !scaleRange64(*range, size) &&
      failed(sym::expandExpr(S.symbolStore(), *scaled)))
    return failure();
  out.expr = *scaled;
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
  out.expr = *expr;
  return out;
}

static std::optional<IntRange64>
inferPointerOffsetRange(WaveAMDMachineSelector &S,
                        const PointerOffset &offset) {
  if (!offset.expr)
    return IntRange64{0, 0};
  std::optional<sym::InferredRange> range =
      sym::inferRange(S.symbolStore(), offset.expr, offset.assumptions);
  if (!range || !range->lower || !range->upper)
    return std::nullopt;
  std::optional<int64_t> lo = sym::floorEndpoint(*range->lower);
  std::optional<int64_t> hi = sym::ceilEndpoint(*range->upper);
  if (!lo || !hi)
    return std::nullopt;
  return IntRange64{*lo, *hi};
}

static LogicalResult appendScaledPointerOffsetRange(
    WaveAMDMachineSelector &S, const PointerOffset &source, StringRef name,
    int64_t scale, SmallVectorImpl<sym::PredHandle> &assumptions) {
  std::optional<IntRange64> range = inferPointerOffsetRange(S, source);
  if (!range)
    return success();
  std::optional<IntRange64> scaled = scaleRange64(*range, scale);
  if (!scaled)
    return success();
  FailureOr<sym::PredHandle> handle =
      sym::rangeAssumption(S.symbolStore(), name, scaled->lo, scaled->hi);
  if (failed(handle))
    return failure();
  assumptions.push_back(*handle);
  return success();
}

static FailureOr<PointerOffset>
planRawPtrAddByteOffset(WaveAMDMachineSelector &S, PtrAddOp op, unsigned size,
                        Value source = {},
                        const PointerOffset *sourceOffset = nullptr) {
  if (!source)
    source = op.getOffset();
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
  if (sourceOffset && failed(appendScaledPointerOffsetRange(
                          S, *sourceOffset, name, size, offset.assumptions)))
    return failure();
  return offset;
}

static bool isSignlessI32StorageType(Type type) {
  if (auto simd = dyn_cast<SimdType>(type))
    type = simd.getElementType();
  auto intType = dyn_cast<IntegerType>(type);
  return intType && intType.isSignless() && intType.getWidth() == 32;
}

static bool isIdentityI32Offset(const PointerOffset &offset, Value &source) {
  if (!offset.expr || offset.bindings.size() != 1)
    return false;
  const PointerOffsetBinding &binding = offset.bindings.front();
  sym::ExprView view(offset.expr);
  if (view.getKind() != sym::ExprKind::Symbol ||
      view.getSymbolName() != binding.name)
    return false;
  if (!isSignlessI32StorageType(binding.value.getType()))
    return false;
  source = binding.value;
  return true;
}

static bool hasGlobalPointerBase(PtrAddOp op) {
  std::optional<PtrType> ptr = getWavePointerType(op.getBase().getType());
  return ptr && isa<GlobalAddressSpaceAttr>(ptr->getAddressSpace());
}

static FailureOr<PointerOffset>
mergePtrAddOffsetOrError(WaveAMDMachineSelector &S, PtrAddOp op,
                         const PointerOffset &base, const PointerOffset &add) {
  FailureOr<PointerOffset> merged = mergePointerOffsets(S, base, add);
  if (failed(merged))
    op.emitError("failed to merge pointer offset symbols");
  return merged;
}

static FailureOr<std::optional<PointerOffset>>
planIdentityI32PtrAddOffset(WaveAMDMachineSelector &S, PtrAddOp op,
                            unsigned size, const PointerOffset &base,
                            const PointerOffset &offset) {
  Value rawSource;
  if (hasGlobalPointerBase(op) || !isIdentityI32Offset(offset, rawSource))
    return std::optional<PointerOffset>{};
  FailureOr<PointerOffset> scaled =
      planRawPtrAddByteOffset(S, op, size, rawSource, &offset);
  if (failed(scaled))
    return failure();
  FailureOr<PointerOffset> merged =
      mergePtrAddOffsetOrError(S, op, base, *scaled);
  if (failed(merged))
    return failure();
  return std::optional<PointerOffset>{std::move(*merged)};
}

static FailureOr<PointerOffset>
planRawMergedPtrAddOffset(WaveAMDMachineSelector &S, PtrAddOp op, unsigned size,
                          const PointerOffset &base) {
  FailureOr<PointerOffset> scaled = planRawPtrAddByteOffset(S, op, size);
  if (failed(scaled))
    return failure();
  return mergePtrAddOffsetOrError(S, op, base, *scaled);
}

static FailureOr<PointerOffset>
scaleAndMergePtrAddOffset(WaveAMDMachineSelector &S, PtrAddOp op, unsigned size,
                          const PointerOffset &base,
                          const PointerOffset &offset) {
  FailureOr<PointerOffset> scaled = scalePointerOffset(S, offset, size);
  if (failed(scaled)) {
    op.emitError("pointer offset byte scale overflows i64");
    return failure();
  }
  return mergePtrAddOffsetOrError(S, op, base, *scaled);
}

static FailureOr<PointerOffset> planPtrAddOffset(WaveAMDMachineSelector &S,
                                                 PtrAddOp op, unsigned size) {
  auto baseIt = S.pointerIndexOffsets.find(op.getBase());
  if (baseIt == S.pointerIndexOffsets.end()) {
    op.emitError("WaveAMDMachine backend expects selected pointer offset");
    return failure();
  }
  if (auto offsetIt = S.indexOffsets.find(op.getOffset());
      offsetIt != S.indexOffsets.end()) {
    FailureOr<std::optional<PointerOffset>> identity =
        planIdentityI32PtrAddOffset(S, op, size, baseIt->second,
                                    offsetIt->second);
    if (failed(identity))
      return failure();
    if (*identity)
      return std::move(**identity);
    return scaleAndMergePtrAddOffset(S, op, size, baseIt->second,
                                     offsetIt->second);
  } else if (std::optional<int64_t> raw = getConstantIntValue(op.getOffset())) {
    FailureOr<sym::ExprHandle> expr =
        sym::composeExprInt(S.symbolStore(), *raw);
    if (failed(expr)) {
      op.emitError("failed to compose raw pointer offset");
      return failure();
    }
    PointerOffset offset;
    offset.expr = *expr;
    return scaleAndMergePtrAddOffset(S, op, size, baseIt->second, offset);
  }
  return planRawMergedPtrAddOffset(S, op, size, baseIt->second);
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
  if (preselectedPointerAdds.erase(op.getResult())) {
    eraseIfTopLevel(op);
    return success();
  }
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

LogicalResult WaveAMDMachineSelector::selectSchedBarrier(SchedBarrierOp op) {
  waveamdmachine::SchedBarrierOp::create(builder, op.getLoc());
  eraseIfTopLevel(op);
  return success();
}

LogicalResult
WaveAMDMachineSelector::selectSetPriority(waveamd::SetPriorityOp op) {
  Value priority = createImm(builder, op.getLoc(), op.getPriority());
  waveamdmachine::SSetprioOp::create(builder, op.getLoc(), priority);
  eraseIfTopLevel(op);
  return success();
}

LogicalResult WaveAMDMachineSelector::selectIssueToken(IssueTokenOp op) {
  SmallVector<Value> operands;
  for (Value dependency : op.getDependencies())
    operands.push_back(expect(dependency, op));
  values[op.getResult()] = waveamdmachine::IssueTokenOp::create(
      builder, op.getLoc(), getMemTokenType(op.getContext()), operands);
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

LogicalResult WaveAMDMachineSelector::selectTokenSelect(SelectOp op) {
  std::array<Value, 2> dependencies{expect(op.getTrueValue(), op),
                                    expect(op.getFalseValue(), op)};
  values[op.getResult()] = waveamdmachine::TokenJoinOp::create(
      builder, op.getLoc(), getMemTokenType(op.getContext()), dependencies);
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

LogicalResult
WaveAMDMachineSelector::selectFragmentPack(waveamd::FragmentPackOp op) {
  Value registers = expect(op.getRegisters(), op);
  if (op.getRegisters().getDefiningOp<waveamd::FragmentUnpackOp>()) {
    // Preserve explicit round-trip as arm-local storage identity.
    values[op.getResult()] = waveamdmachine::UpdateTupleOp::create(
        builder, op.getLoc(), registers.getType(), registers, ValueRange{},
        builder.getArrayAttr({}));
  } else {
    values[op.getResult()] = registers;
  }
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

LogicalResult
WaveAMDMachineSelector::selectSharedMemoryBase(SharedMemoryBaseOp op) {
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
  Value acc = foldZeroMmaAccumulator(expect(op.getAcc(), op),
                                     foldedMmaAccumulatorMaterializations);
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
    if (rawType.getWidth() == 1)
      return raw;
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

static FailureOr<std::pair<Value, PointerOffset>>
lookupLdsPointer(WaveAMDMachineSelector &S, Value ptr, Operation *op) {
  auto baseIt = S.pointerBases.find(ptr);
  auto offsetIt = S.pointerIndexOffsets.find(ptr);
  if (baseIt == S.pointerBases.end() || offsetIt == S.pointerIndexOffsets.end())
    return op->emitError("WaveAMDMachine backend expects selected LDS pointer");
  return std::make_pair(baseIt->second, offsetIt->second);
}

enum class DsReadTrKind { B4, B6, B8, B16 };

static bool isDsReadTrB16Element(Type elementType) {
  return elementType.isInteger(16) || elementType.isF16() ||
         elementType.isBF16();
}

static FailureOr<DsReadTrKind> getDsReadTrKind(Operation *op,
                                               VectorType vectorType) {
  Type elementType = vectorType.getElementType();
  if (elementType.isInteger(4) && vectorType.getNumElements() == 16)
    return DsReadTrKind::B4;
  if (elementType.isInteger(8) && vectorType.getNumElements() == 8)
    return DsReadTrKind::B8;
  if (elementType.isInteger(32) && vectorType.getNumElements() == 3)
    return DsReadTrKind::B6;
  if (isDsReadTrB16Element(elementType) && vectorType.getNumElements() == 4)
    return DsReadTrKind::B16;
  return op->emitError("unsupported transpose load result type");
}

static bool isDsReadTrSupportedOnIsa(DsReadTrKind kind,
                                     llvm::AMDGPU::IsaVersion isa) {
  switch (kind) {
  case DsReadTrKind::B4:
    return waveamdmachine::DsReadTrB64B4Op::isSupportedOnIsa(isa);
  case DsReadTrKind::B6:
    return waveamdmachine::DsReadTrB96B6Op::isSupportedOnIsa(isa);
  case DsReadTrKind::B8:
    return waveamdmachine::DsReadTrB64B8Op::isSupportedOnIsa(isa);
  case DsReadTrKind::B16:
    return waveamdmachine::DsReadTrB64B16Op::isSupportedOnIsa(isa);
  }
  llvm_unreachable("unknown transpose load kind");
}

static waveamdmachine::AddressFieldSpec
getDsReadTrAddressFieldSpec(DsReadTrKind kind) {
  switch (kind) {
  case DsReadTrKind::B4:
    return waveamdmachine::DsReadTrB64B4Op::getAddressFieldSpec();
  case DsReadTrKind::B6:
    return waveamdmachine::DsReadTrB96B6Op::getAddressFieldSpec();
  case DsReadTrKind::B8:
    return waveamdmachine::DsReadTrB64B8Op::getAddressFieldSpec();
  case DsReadTrKind::B16:
    return waveamdmachine::DsReadTrB64B16Op::getAddressFieldSpec();
  }
  llvm_unreachable("unknown transpose load kind");
}

static Operation *createDsReadTr(WaveAMDMachineSelector &S, Operation *op,
                                 DsReadTrKind kind, Type regType,
                                 Type tokenType, Value addr, Value dep,
                                 int64_t offset) {
  switch (kind) {
  case DsReadTrKind::B4:
    return waveamdmachine::DsReadTrB64B4Op::create(
        S.builder, op->getLoc(), regType, tokenType, addr, dep, offset);
  case DsReadTrKind::B6:
    return waveamdmachine::DsReadTrB96B6Op::create(
        S.builder, op->getLoc(), regType, tokenType, addr, dep, offset);
  case DsReadTrKind::B8:
    return waveamdmachine::DsReadTrB64B8Op::create(
        S.builder, op->getLoc(), regType, tokenType, addr, dep, offset);
  case DsReadTrKind::B16:
    return waveamdmachine::DsReadTrB64B16Op::create(
        S.builder, op->getLoc(), regType, tokenType, addr, dep, offset);
  }
  llvm_unreachable("unknown transpose load kind");
}

static unsigned getDsReadTrRegisterWidth(DsReadTrKind kind) {
  if (kind == DsReadTrKind::B6)
    return 3;
  return 2;
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
  FailureOr<DsReadTrKind> kind = getDsReadTrKind(op, vectorType);
  if (failed(kind))
    return failure();
  FailureOr<llvm::AMDGPU::IsaVersion> isa =
      getTargetIsaVersion(op, "transpose load lowering");
  if (failed(isa))
    return failure();
  if (!isDsReadTrSupportedOnIsa(*kind, *isa))
    return op->emitError("transpose load lowering requires gfx950");
  waveamdmachine::AddressFieldSpec spec = getDsReadTrAddressFieldSpec(*kind);
  FailureOr<MaterializedLdsAddress> address =
      materializeLdsAddress(S, op, ptr->first, ptr->second, spec);
  if (failed(address))
    return failure();
  Type regType = getRegType(op->getContext(), waveamdmachine::RegClass::VGPR,
                            getDsReadTrRegisterWidth(*kind));
  Type tokenType = getMemTokenType(op->getContext());
  Value dep = dependency ? S.expect(dependency, op) : Value{};
  Operation *load = createDsReadTr(S, op, *kind, regType, tokenType,
                                   address->addr, dep, address->instOffset);
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

struct DmaSourceAddress {
  WaveAMDMachineSelector::BucketedOperands buckets;
  Value base;
};

struct DmaFallbackLoad {
  SmallVector<Value, 4> values;
  Value token;
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

static bool haveSameDmaOffsetBindings(const PointerOffset &lhs,
                                      const PointerOffset &rhs) {
  if (lhs.bindings.size() != rhs.bindings.size())
    return false;
  return llvm::all_of(lhs.bindings, [&](const PointerOffsetBinding &binding) {
    return llvm::any_of(rhs.bindings, [&](const PointerOffsetBinding &other) {
      return samePointerBinding(binding, other);
    });
  });
}

static std::optional<int64_t>
getConstantDmaDestinationDelta(WaveAMDMachineSelector &S,
                               const PointerOffset &previous,
                               const PointerOffset &current) {
  if (!haveSameDmaOffsetBindings(previous, current))
    return std::nullopt;
  FailureOr<sym::ExprHandle> zero = sym::composeExprInt(S.symbolStore(), 0);
  if (failed(zero))
    return std::nullopt;
  sym::ExprHandle previousExpr = previous.expr ? previous.expr : *zero;
  sym::ExprHandle currentExpr = current.expr ? current.expr : *zero;
  SmallVector<sym::PredHandle> assumptions;
  llvm::append_range(assumptions, previous.assumptions);
  llvm::append_range(assumptions, current.assumptions);
  FailureOr<std::unique_ptr<sym::Analysis>> analysis =
      sym::Analysis::create(S.symbolStore(), assumptions);
  if (failed(analysis))
    return std::nullopt;
  return (*analysis)->constantDifference(currentExpr, previousExpr);
}

static waveamdmachine::AddressFieldSpec
dmaFallbackStoreSpec(waveamd::DmaLoadLdsOp op) {
  if (op.getBytes() == 4)
    return waveamdmachine::DsStoreB32Op::getAddressFieldSpec();
  waveamdmachine::AddressFieldSpec spec =
      waveamdmachine::DsStoreTupleB32Op::getAddressFieldSpec();
  spec.instOffsetHeadroom = static_cast<unsigned>(op.getBytes() - 4);
  return spec;
}

static FailureOr<MaterializedLdsAddress>
materializeDmaFallbackLdsAddress(WaveAMDMachineSelector &S,
                                 waveamd::DmaLoadLdsOp op, Value dstBase,
                                 const PointerOffset &dstOffset) {
  if (failed(requireUniformDmaDest(S, op, dstOffset)))
    return failure();
  FailureOr<MaterializedLdsAddress> address = materializeLdsAddress(
      S, op.getOperation(), dstBase, dstOffset, dmaFallbackStoreSpec(op));
  if (failed(address))
    return failure();
  auto simdType = dyn_cast<SimdType>(op.getSource().getType());
  if (!simdType || (simdType.getWidth() != 32 && simdType.getWidth() != 64))
    return op.emitError(
        "addr64 DMA LDS fallback expects 32/64-wide SIMD source");
  Type vgprType =
      getRegType(S.builder.getContext(), waveamdmachine::RegClass::VGPR);
  Value lane =
      waveamdmachine::VMbcntLoOp::create(S.builder, op.getLoc(), vgprType);
  if (simdType.getWidth() == 64)
    lane = waveamdmachine::VMbcntHiOp::create(S.builder, op.getLoc(), vgprType,
                                              lane);
  FailureOr<Value> laneBytes =
      scaleVOffset(S, op.getLoc(), lane, static_cast<unsigned>(op.getBytes()));
  if (failed(laneBytes))
    return failure();
  address->addr = S.addByteOffsets(op.getLoc(), address->addr, *laneBytes);
  return *address;
}

static FailureOr<DmaFallbackLoad>
materializeDmaFallbackGlobalLoads(WaveAMDMachineSelector &S,
                                  waveamd::DmaLoadLdsOp op, Value srcBase,
                                  const AddressPlan &srcPlan) {
  FailureOr<Value> addr =
      materializeFullPlanAddress(S, op.getOperation(), srcBase, srcPlan);
  if (failed(addr))
    return failure();
  Value dep = S.expect(op.getDependency(), op);
  Type tokenType = getMemTokenType(op.getContext());
  Type vgpr1 = getRegType(op.getContext(), waveamdmachine::RegClass::VGPR, 1);
  DmaFallbackLoad out;
  SmallVector<Value, 4> tokens;
  unsigned dwords = static_cast<unsigned>(op.getBytes() / 4);
  for (unsigned idx : llvm::seq<unsigned>(0, dwords)) {
    Operation *load = waveamdmachine::GlobalLoadB32Addr64Op::create(
        S.builder, op.getLoc(), vgpr1, tokenType, *addr, dep,
        static_cast<int64_t>(idx) * 4);
    out.values.push_back(load->getResult(0));
    tokens.push_back(load->getResult(1));
  }
  out.token = tokens.size() == 1
                  ? tokens.front()
                  : waveamdmachine::TokenJoinOp::create(S.builder, op.getLoc(),
                                                        tokenType, tokens)
                        .getResult();
  return out;
}

static FailureOr<Value> materializeDmaFallbackLdsStore(
    WaveAMDMachineSelector &S, waveamd::DmaLoadLdsOp op,
    const MaterializedLdsAddress &dst, ArrayRef<Value> values, Value dep) {
  Type tokenType = getMemTokenType(op.getContext());
  if (values.size() == 1) {
    Value value = S.ensureVGPRForVSrc1(op.getLoc(), values.front());
    return waveamdmachine::DsStoreB32Op::create(S.builder, op.getLoc(),
                                                tokenType, dst.addr, value, dep,
                                                dst.instOffset)
        .getResult(0);
  }
  Type tupleType = getRegType(op.getContext(), waveamdmachine::RegClass::VGPR,
                              values.size());
  Value tuple = waveamdmachine::TupleFromElementsOp::create(
                    S.builder, op.getLoc(), tupleType, values)
                    .getTuple();
  return waveamdmachine::DsStoreTupleB32Op::create(S.builder, op.getLoc(),
                                                   tokenType, dst.addr, tuple,
                                                   dep, dst.instOffset)
      .getResult(0);
}

static bool isZeroImm(WaveAMDMachineSelector &S, Value value) {
  std::optional<int64_t> imm = S.getImmediateValue(value);
  return imm && *imm == 0;
}

static Value createDmaM0Move(WaveAMDMachineSelector &S, Location loc,
                             Value source) {
  Value m0Src = S.materializeSGPR1(loc, source);
  return Value{waveamdmachine::SMovM0Op::create(
      S.builder, loc, waveamdmachine::M0Type::get(S.builder.getContext()),
      m0Src)};
}

static Value createDmaM0Add(WaveAMDMachineSelector &S, Location loc, Value lhs,
                            Value rhs) {
  if (Value folded = S.foldImmAdd(loc, lhs, rhs))
    return createDmaM0Move(S, loc, folded);
  if (isImm(lhs) && !isImm(rhs))
    std::swap(lhs, rhs);
  lhs = S.materializeSGPR1(loc, lhs);
  rhs = S.ensureSGPR1(loc, rhs);
  return waveamdmachine::SAddM0I32Op::create(
             S.builder, loc,
             waveamdmachine::M0Type::get(S.builder.getContext()),
             getSCCType(S.builder.getContext()), lhs, rhs)
      .getM0();
}

static Value materializeDmaM0Parts(WaveAMDMachineSelector &S, Location loc,
                                   ArrayRef<Value> parts) {
  SmallVector<Value, 4> nonZeroParts;
  for (Value part : parts)
    if (!isZeroImm(S, part))
      nonZeroParts.push_back(part);
  if (nonZeroParts.empty()) {
    Value zero = parts.empty() ? createImm(S.builder, loc, 0) : parts.front();
    return createDmaM0Move(S, loc, zero);
  }
  if (nonZeroParts.size() == 1)
    return createDmaM0Move(S, loc, nonZeroParts.front());

  Value rhs = nonZeroParts.pop_back_val();
  Value acc = nonZeroParts.front();
  for (Value part : llvm::drop_begin(nonZeroParts))
    acc = S.addUniformBytes(loc, acc, part);
  return createDmaM0Add(S, loc, acc, rhs);
}

static FailureOr<Value> materializeDmaM0FieldPlan(WaveAMDMachineSelector &S,
                                                  waveamd::DmaLoadLdsOp op,
                                                  Value dstBase,
                                                  const AddressPlan &plan) {
  AddressPlanBindings bindings = materializeAddressPlanBindings(S, op, plan);
  SmallVector<Value, 4> parts;
  if (dstBase)
    parts.push_back(dstBase);
  Location loc = op.getLoc();
  auto appendExpr = [&](sym::ExprHandle expr, bool useWide) -> LogicalResult {
    if (!expr)
      return success();
    FailureOr<Value> value = materializePlanLowDword(
        S, op, expr, bindings, plan.assumptions, useWide,
        /*symbolsAreUniform=*/true);
    if (failed(value))
      return failure();
    parts.push_back(S.ensureSGPR1(loc, *value));
    return success();
  };
  bool remainderNeedsWide =
      needsWideAddressMaterialization(plan.fullAddressRemainderExpr, plan);
  if (failed(appendExpr(plan.soffsetExpr, plan.soffsetNeedsWide)) ||
      failed(appendExpr(plan.fullAddressRemainderExpr, remainderNeedsWide)))
    return failure();
  if (plan.instOffset != 0)
    parts.push_back(createImm(S.builder, loc, plan.instOffset));
  return materializeDmaM0Parts(S, loc, parts);
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
  if (plan->voffsetExpr)
    return op.emitError("DMA LDS destination must be uniform");
  if (plan->fullAddressRemainderExpr) {
    FailureOr<Value> low =
        materializeUniformFullAddressLowDword(S, op, dstBase, *plan);
    if (failed(low))
      return failure();
    Value m0Src = S.materializeSGPR1(op.getLoc(), *low);
    return Value{waveamdmachine::SMovM0Op::create(
        S.builder, op.getLoc(), waveamdmachine::M0Type::get(op.getContext()),
        m0Src)};
  }
  return materializeDmaM0FieldPlan(S, op, dstBase, *plan);
}

static waveamdmachine::AddressFieldSpec dmaAddressSpec(bool isBuffer,
                                                       int64_t bytes);

static FailureOr<AddressPlan>
planDmaSourceAddress(WaveAMDMachineSelector &S, waveamd::DmaLoadLdsOp op,
                     const PointerOffset &offset, bool isBuffer,
                     const waveamdmachine::AddressFieldSpec &spec) {
  FailureOr<AddressPlan> plan = planMemoryAddress(S, op, offset, spec);
  if (failed(plan))
    return failure();
  if (isBuffer && plan->fullAddressRemainderExpr)
    if (failed(foldBufferAddressFieldsIntoVOffset(S, *plan,
                                                  /*includeInstOffset=*/false)))
      return failure();
  return *plan;
}

static FailureOr<DmaSourceAddress> materializeGlobalDmaUniformSourceAddress(
    WaveAMDMachineSelector &S, waveamd::DmaLoadLdsOp op, Value base,
    AddressPlan &plan, const waveamdmachine::AddressFieldSpec &spec) {
  AddressPlan basePlan = plan;
  basePlan.voffsetExpr = {};
  basePlan.soffsetExpr = {};
  basePlan.voffsetNeedsWide = false;
  basePlan.soffsetNeedsWide = false;
  basePlan.instOffset = 0;
  FailureOr<Value> adjustedBase =
      materializeUniformFullPlanAddress(S, op, base, basePlan);
  if (failed(adjustedBase))
    return failure();
  plan.fullAddressRemainderExpr = {};
  FailureOr<WaveAMDMachineSelector::BucketedOperands> buckets =
      materializePlanBuckets(S, op, plan, spec);
  if (failed(buckets))
    return failure();
  return DmaSourceAddress{*buckets, *adjustedBase};
}

static FailureOr<DmaSourceAddress>
materializeGlobalDmaLaneSourceAddress(WaveAMDMachineSelector &S,
                                      waveamd::DmaLoadLdsOp op, Value base,
                                      AddressPlan &plan) {
  FailureOr<sym::ExprHandle> expr = planCompleteAddressExpr(S, plan);
  if (failed(expr))
    return failure();
  bool useWide = needsWideAddressMaterialization(*expr, plan);
  if (!S.slotFitsU32(*expr, plan.assumptions) &&
      (useWide || !positiveAddendsFitU32(S, *expr, plan.assumptions)))
    return op.emitError("global DMA LDS source offset must fit proven "
                        "unsigned 32-bit voffset field");
  AddressPlanBindings bindings = materializeAddressPlanBindings(S, op, plan);
  FailureOr<Value> voffset = materializePlanLowDword(S, op, *expr, bindings,
                                                     plan.assumptions, useWide);
  if (failed(voffset))
    return failure();
  WaveAMDMachineSelector::BucketedOperands out;
  out.voffset = S.ensureVGPRForVSrc1(op.getLoc(), *voffset);
  return DmaSourceAddress{out, base};
}

static FailureOr<bool> needsGlobalDmaAddr64Fallback(WaveAMDMachineSelector &S,
                                                    waveamd::DmaLoadLdsOp op,
                                                    const AddressPlan &plan) {
  if (!plan.fullAddressRemainderExpr)
    return false;
  if (classifyPlanExpr(S, plan, plan.fullAddressRemainderExpr) !=
      TermKind::Lane)
    return false;
  FailureOr<sym::ExprHandle> expr = planCompleteAddressExpr(S, plan);
  if (failed(expr))
    return failure();
  bool useWide = needsWideAddressMaterialization(*expr, plan);
  return !S.slotFitsU32(*expr, plan.assumptions) &&
         (useWide || !positiveAddendsFitU32(S, *expr, plan.assumptions));
}

static LogicalResult selectDmaLoadLdsAddr64Fallback(
    WaveAMDMachineSelector &S, waveamd::DmaLoadLdsOp op, Value srcBase,
    Value dstBase, const AddressPlan &srcPlan, const PointerOffset &dstOffset) {
  FailureOr<MaterializedLdsAddress> dst =
      materializeDmaFallbackLdsAddress(S, op, dstBase, dstOffset);
  if (failed(dst))
    return failure();
  FailureOr<DmaFallbackLoad> load =
      materializeDmaFallbackGlobalLoads(S, op, srcBase, srcPlan);
  if (failed(load))
    return failure();
  FailureOr<Value> token =
      materializeDmaFallbackLdsStore(S, op, *dst, load->values, load->token);
  if (failed(token))
    return failure();
  S.lastDmaM0 = {};
  S.lastDmaToken = {};
  S.lastDmaDstBase = {};
  S.lastDmaDstOffset = {};
  S.lastDmaHadIssueDelay = false;
  S.values[op.getToken()] = *token;
  S.eraseIfTopLevel(op);
  return success();
}

static FailureOr<bool> selectDmaLoadLdsAddr64FallbackIfNeeded(
    WaveAMDMachineSelector &S, waveamd::DmaLoadLdsOp op,
    const DmaPointers &ptrs, const AddressPlan &srcPlan, bool isBuffer) {
  if (isBuffer)
    return false;
  FailureOr<bool> useFallback = needsGlobalDmaAddr64Fallback(S, op, srcPlan);
  if (failed(useFallback))
    return failure();
  if (!*useFallback)
    return false;
  if (op.getAux() != 0) {
    op.emitError("addr64 DMA LDS fallback does not support nonzero aux");
    return failure();
  }
  if (failed(selectDmaLoadLdsAddr64Fallback(S, op, ptrs.srcBase, ptrs.dstBase,
                                            srcPlan, ptrs.dstOffset)))
    return failure();
  return true;
}

static FailureOr<DmaSourceAddress> materializeGlobalDmaFullSourceAddress(
    WaveAMDMachineSelector &S, waveamd::DmaLoadLdsOp op, Value base,
    AddressPlan &plan, const waveamdmachine::AddressFieldSpec &spec) {
  TermKind remainderKind =
      classifyPlanExpr(S, plan, plan.fullAddressRemainderExpr);
  if (remainderKind != TermKind::Lane)
    return materializeGlobalDmaUniformSourceAddress(S, op, base, plan, spec);
  return materializeGlobalDmaLaneSourceAddress(S, op, base, plan);
}

static FailureOr<DmaSourceAddress>
materializeDmaSourceAddress(WaveAMDMachineSelector &S, waveamd::DmaLoadLdsOp op,
                            Value base, AddressPlan &plan, bool isBuffer,
                            const waveamdmachine::AddressFieldSpec &spec) {
  if (plan.fullAddressRemainderExpr) {
    if (isBuffer)
      return emitBufferAddressFieldError(op.getOperation());
    return materializeGlobalDmaFullSourceAddress(S, op, base, plan, spec);
  }
  FailureOr<WaveAMDMachineSelector::BucketedOperands> buckets =
      materializePlanBuckets(S, op, plan, spec);
  if (failed(buckets))
    return failure();
  return DmaSourceAddress{*buckets, base};
}

static bool isZeroSOffset(WaveAMDMachineSelector &S,
                          const WaveAMDMachineSelector::BucketedOperands &b) {
  return !b.soffset || isZeroImm(S, b.soffset);
}

static FailureOr<DmaSourceAddress> materializeBufferDmaSourceAddress(
    WaveAMDMachineSelector &S, waveamd::DmaLoadLdsOp op,
    const BufferSelectedSourcePointer &source,
    const waveamdmachine::AddressFieldSpec &spec) {
  FailureOr<AddressPlan> plan =
      planDmaSourceAddress(S, op, source.offset, /*isBuffer=*/true, spec);
  if (failed(plan))
    return failure();
  if (failed(foldBufferAddressFieldsIntoVOffset(S, *plan,
                                                /*includeInstOffset=*/false)))
    return failure();
  return materializeDmaSourceAddress(S, op, source.base, *plan,
                                     /*isBuffer=*/true, spec);
}

static FailureOr<std::optional<DmaSourceAddress>>
materializeSelectedBufferDmaSourceAddress(
    WaveAMDMachineSelector &S, waveamd::DmaLoadLdsOp op,
    const waveamdmachine::AddressFieldSpec &spec) {
  if (!op.getZeroFillInactive().value_or(false))
    return std::optional<DmaSourceAddress>{};

  FailureOr<std::optional<SelectedBufferSources>> pointers =
      matchSelectedBufferSources(S, op, op.getSource(),
                                 /*requirePtrAdd=*/false);
  if (failed(pointers))
    return failure();
  if (!*pointers)
    return std::optional<DmaSourceAddress>{};

  FailureOr<DmaSourceAddress> activeSource =
      materializeBufferDmaSourceAddress(S, op, (*pointers)->active, spec);
  FailureOr<DmaSourceAddress> inactiveSource =
      materializeBufferDmaSourceAddress(S, op, (*pointers)->inactive, spec);
  if (failed(activeSource) || failed(inactiveSource))
    return failure();
  if (inactiveSource->buckets.instOffset != 0 ||
      !isZeroSOffset(S, inactiveSource->buckets))
    return std::optional<DmaSourceAddress>{};

  FailureOr<Value> selectedVOffset = createLaneSelect(
      S, op, S.expect((*pointers)->select.getCondition(), op),
      activeSource->buckets.voffset, inactiveSource->buckets.voffset,
      /*width=*/1);
  if (failed(selectedVOffset))
    return failure();
  activeSource->buckets.voffset = *selectedVOffset;
  return std::optional<DmaSourceAddress>{*activeSource};
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

static Value createBufferDmaLoadLdsMachineOp(WaveAMDMachineSelector &S,
                                             waveamd::DmaLoadLdsOp op,
                                             const DmaSourceAddress &source,
                                             Value m0) {
  WaveAMDMachineSelector::BucketedOperands b = source.buckets;
  IntegerAttr instOffsetAttr = S.builder.getI64IntegerAttr(b.instOffset);
  IntegerAttr auxAttr = op.getAux() != 0 ? op.getAuxAttr() : IntegerAttr{};
  Type tokenType = getMemTokenType(op.getContext());
  Value dep = S.expect(op.getDependency(), op);
  if (op.getBytes() == 16)
    return waveamdmachine::BufferLoadLdsB128Op::create(
        S.builder, op.getLoc(), tokenType, b.voffset, source.base, b.soffset,
        m0, dep, instOffsetAttr, auxAttr);
  return waveamdmachine::BufferLoadLdsB32Op::create(
      S.builder, op.getLoc(), tokenType, b.voffset, source.base, b.soffset, m0,
      dep, instOffsetAttr, auxAttr);
}

static Value createGlobalDmaLoadLdsMachineOp(WaveAMDMachineSelector &S,
                                             waveamd::DmaLoadLdsOp op,
                                             const DmaSourceAddress &source,
                                             Value m0) {
  WaveAMDMachineSelector::BucketedOperands b = source.buckets;
  IntegerAttr instOffsetAttr = S.builder.getI64IntegerAttr(b.instOffset);
  IntegerAttr auxAttr = op.getAux() != 0 ? op.getAuxAttr() : IntegerAttr{};
  Type tokenType = getMemTokenType(op.getContext());
  Value dep = S.expect(op.getDependency(), op);
  if (op.getBytes() == 16)
    return waveamdmachine::GlobalLoadLdsB128Op::create(
        S.builder, op.getLoc(), tokenType, b.voffset, source.base, m0, dep,
        instOffsetAttr, auxAttr);
  return waveamdmachine::GlobalLoadLdsB32Op::create(
      S.builder, op.getLoc(), tokenType, b.voffset, source.base, m0, dep,
      instOffsetAttr, auxAttr);
}

static Value createDmaLoadLdsMachineOp(WaveAMDMachineSelector &S,
                                       waveamd::DmaLoadLdsOp op,
                                       const DmaSourceAddress &source, Value m0,
                                       bool isBuffer) {
  if (isBuffer)
    return createBufferDmaLoadLdsMachineOp(S, op, source, m0);
  return createGlobalDmaLoadLdsMachineOp(S, op, source, m0);
}

static FailureOr<Value> materializeDmaLoadLdsM0(WaveAMDMachineSelector &S,
                                                waveamd::DmaLoadLdsOp op,
                                                const DmaPointers &ptrs) {
  Operation *previousDma =
      S.lastDmaToken ? S.lastDmaToken.getDefiningOp() : nullptr;
  if (S.lastDmaM0 && previousDma &&
      previousDma->getBlock() == S.builder.getInsertionBlock() &&
      S.lastDmaDstBase == ptrs.dstBase) {
    std::optional<int64_t> delta =
        getConstantDmaDestinationDelta(S, S.lastDmaDstOffset, ptrs.dstOffset);
    if (delta && *delta != 0 && llvm::isInt<32>(*delta)) {
      Value immediate = createImm(S.builder, op.getLoc(), *delta);
      return waveamdmachine::SAddM0I32Op::create(
                 S.builder, op.getLoc(),
                 waveamdmachine::M0Type::get(op.getContext()),
                 getSCCType(op.getContext()), S.lastDmaM0, immediate)
          .getM0();
    }
  }
  return materializeDmaM0(S, op, ptrs.dstBase, ptrs.dstOffset);
}

static FailureOr<Value> materializeDmaIssueDelay(WaveAMDMachineSelector &S,
                                                 waveamd::DmaLoadLdsOp op,
                                                 Value m0) {
  IntegerAttr cycles = op->getAttrOfType<IntegerAttr>("issue_delay_cycles");
  if (!cycles)
    return m0;
  if (!S.lastDmaToken)
    return op.emitOpError("issue delay requires a preceding DMA");

  Value condition;
  IntegerAttr threshold =
      op->getAttrOfType<IntegerAttr>("issue_delay_skip_thread_threshold");
  if (threshold) {
    if (!S.dmaIssueSkipCondition)
      return op.emitOpError("issue delay skip condition was not materialized");
    condition = S.dmaIssueSkipCondition;
  }
  IntegerAttr overlap =
      op->getAttrOfType<IntegerAttr>("issue_delay_overlap_cycles");
  if (!overlap)
    overlap = S.builder.getI64IntegerAttr(0);
  waveamdmachine::DmaIssueDelayOp delay =
      waveamdmachine::DmaIssueDelayOp::create(
          S.builder, op.getLoc(), waveamdmachine::M0Type::get(op.getContext()),
          S.lastDmaToken, m0, condition, cycles, overlap);
  return delay.getDelayedM0();
}

static void recordDmaM0(WaveAMDMachineSelector &S, waveamd::DmaLoadLdsOp op,
                        const DmaPointers &ptrs, Value m0, Value token) {
  if (!S.dmaIssueTimingEnabled)
    return;
  Operation *dma = token.getDefiningOp();
  Operation *previousDma =
      S.lastDmaToken ? S.lastDmaToken.getDefiningOp() : nullptr;
  if (S.lastDmaHadIssueDelay && previousDma &&
      previousDma->getBlock() == dma->getBlock())
    dma->setAttr(kDmaIssueAfterDelayAttr, S.builder.getUnitAttr());
  S.lastDmaM0 = m0;
  S.lastDmaToken = token;
  S.lastDmaDstBase = ptrs.dstBase;
  S.lastDmaDstOffset = ptrs.dstOffset;
  S.lastDmaHadIssueDelay = op->hasAttr("issue_delay_cycles");
}

static void bindDmaLoadLdsToken(WaveAMDMachineSelector &S,
                                waveamd::DmaLoadLdsOp op, Value token) {
  S.values[op.getToken()] = token;
  S.eraseIfTopLevel(op);
}

static FailureOr<std::optional<Value>>
trySelectBufferDmaLoadLds(WaveAMDMachineSelector &S, waveamd::DmaLoadLdsOp op,
                          const DmaPointers &ptrs,
                          const waveamdmachine::AddressFieldSpec &spec,
                          bool isBuffer) {
  if (!isBuffer)
    return std::optional<Value>{};
  FailureOr<std::optional<DmaSourceAddress>> selectedSource =
      materializeSelectedBufferDmaSourceAddress(S, op, spec);
  if (failed(selectedSource))
    return failure();
  if (!*selectedSource)
    return std::optional<Value>{};
  FailureOr<Value> m0 = materializeDmaLoadLdsM0(S, op, ptrs);
  if (failed(m0))
    return failure();
  m0 = materializeDmaIssueDelay(S, op, *m0);
  if (failed(m0))
    return failure();
  Value token =
      createDmaLoadLdsMachineOp(S, op, **selectedSource, *m0, isBuffer);
  recordDmaM0(S, op, ptrs, *m0, token);
  return std::optional<Value>{token};
}

static LogicalResult
selectPlannedDmaLoadLds(WaveAMDMachineSelector &S, waveamd::DmaLoadLdsOp op,
                        const DmaPointers &ptrs, AddressPlan &sourcePlan,
                        const waveamdmachine::AddressFieldSpec &spec,
                        bool isBuffer) {
  FailureOr<Value> m0 = materializeDmaLoadLdsM0(S, op, ptrs);
  if (failed(m0))
    return failure();
  m0 = materializeDmaIssueDelay(S, op, *m0);
  if (failed(m0))
    return failure();
  FailureOr<DmaSourceAddress> source = materializeDmaSourceAddress(
      S, op, ptrs.srcBase, sourcePlan, isBuffer, spec);
  if (failed(source))
    return failure();
  Value token = createDmaLoadLdsMachineOp(S, op, *source, *m0, isBuffer);
  recordDmaM0(S, op, ptrs, *m0, token);
  bindDmaLoadLdsToken(S, op, token);
  return success();
}

LogicalResult
WaveAMDMachineSelector::selectDmaLoadLds(waveamd::DmaLoadLdsOp op) {
  if (op.getBytes() != 4 && op.getBytes() != 16)
    return op.emitError("WaveAMDMachine backend supports only bytes = 4 or 16");
  FailureOr<DmaPointers> ptrs = lookupDmaPointers(*this, op);
  if (failed(ptrs))
    return failure();
  bool isBuffer = pointerBuffers.lookup(op.getSource());
  waveamdmachine::AddressFieldSpec spec =
      dmaAddressSpec(isBuffer, op.getBytes());
  FailureOr<std::optional<Value>> selectedToken =
      trySelectBufferDmaLoadLds(*this, op, *ptrs, spec, isBuffer);
  if (failed(selectedToken))
    return failure();
  if (*selectedToken) {
    bindDmaLoadLdsToken(*this, op, **selectedToken);
    return success();
  }

  FailureOr<AddressPlan> sourcePlan =
      planDmaSourceAddress(*this, op, ptrs->srcOffset, isBuffer, spec);
  if (failed(sourcePlan))
    return failure();
  FailureOr<bool> selectedFallback = selectDmaLoadLdsAddr64FallbackIfNeeded(
      *this, op, *ptrs, *sourcePlan, isBuffer);
  if (failed(selectedFallback))
    return failure();
  if (*selectedFallback) {
    if (op->hasAttr("issue_delay_cycles"))
      return op.emitOpError("issue delay requires direct-to-LDS lowering");
    return success();
  }
  return selectPlannedDmaLoadLds(*this, op, *ptrs, *sourcePlan, spec, isBuffer);
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
    SmallVector<WideSymbolBinding, 4> bindings;
    for (const PointerOffsetBinding &binding : offset.bindings)
      bindings.push_back(
          {binding.name, binding.value, S.expect(binding.value, op)});
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

static FailureOr<Value> materializeWhereDataYield(WaveAMDMachineSelector &S,
                                                  WhereOp op, Value value,
                                                  Type resultType) {
  if (isa<MemTokenType>(resultType)) {
    if (isa<waveamdmachine::MemTokenType>(value.getType()))
      return value;
    return op.emitError("wave.where token yield type mismatch");
  }
  if (!isa<SimdType>(resultType))
    return op.emitError("WaveAMDMachine lowering supports result-bearing "
                        "wave.where only for SIMD data, pointers, or memory "
                        "tokens");
  FailureOr<unsigned> width =
      getRegisterPayloadWidth(resultType, [&]() { return op.emitError(); });
  if (failed(width))
    return failure();
  return ensureLaneSelectVGPR(S, op.getOperation(), value, *width);
}

static FailureOr<Value>
materializeWhereDataYieldInRegion(WaveAMDMachineSelector &S, WhereOp op,
                                  SelectedWhereRegion &selected, Value value,
                                  Type resultType) {
  auto savedIP = S.builder.saveInsertionPoint();
  S.builder.setInsertionPointToEnd(&selected.region.front());
  FailureOr<Value> result = materializeWhereDataYield(S, op, value, resultType);
  S.builder.restoreInsertionPoint(savedIP);
  return result;
}

static LogicalResult addDataResult(WaveAMDMachineSelector &S, WhereOp op,
                                   unsigned idx,
                                   SelectedWhereRegion &thenRegion,
                                   SelectedWhereRegion &elseRegion,
                                   WhereResultPlan &plan) {
  Value result = op.getResult(idx);
  Type resultType = result.getType();
  FailureOr<Value> thenValue = materializeWhereDataYieldInRegion(
      S, op, thenRegion, thenRegion.machineYields[idx], resultType);
  if (failed(thenValue))
    return failure();
  if (op.getElseRegion().empty()) {
    unsigned resultIndex = plan.addResult((*thenValue).getType(), *thenValue);
    plan.bindings.push_back({resultIndex, std::nullopt});
    return success();
  }
  FailureOr<Value> elseValue = materializeWhereDataYieldInRegion(
      S, op, elseRegion, elseRegion.machineYields[idx], resultType);
  if (failed(elseValue))
    return failure();
  unsigned resultIndex =
      plan.addResult((*thenValue).getType(), *thenValue, *elseValue);
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
    if (failed(addDataResult(S, op, idx, thenRegion, elseRegion, plan)))
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
  waveamdmachine::RegClass regClass = isLaneVaryingType(sourceType)
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

static FailureOr<Value>
materializeScfIfDataYieldInRegion(WaveAMDMachineSelector &S, scf::IfOp op,
                                  SelectedScfIfRegion &selected, Value value,
                                  Type resultType) {
  auto savedIP = S.builder.saveInsertionPoint();
  S.builder.setInsertionPointToEnd(&selected.region.front());
  FailureOr<Value> result = materializeScfIfDataYield(S, op, value, resultType);
  S.builder.restoreInsertionPoint(savedIP);
  return result;
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
  FailureOr<Value> thenValue = materializeScfIfDataYieldInRegion(
      S, op, thenRegion, thenRegion.machineYields[idx], *resultType);
  FailureOr<Value> elseValue = materializeScfIfDataYieldInRegion(
      S, op, elseRegion, elseRegion.machineYields[idx], *resultType);
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
  if (op.getConditions().size() != 1)
    return op.emitOpError(
        "multi-condition where requires symbolic memory lowering");
  auto maskType = cast<MaskType>(op.getCondition().getType());
  unsigned maskWidth = maskType.getWidth();
  if (failed(validateWhereMaskWidth(op, maskWidth)))
    return failure();

  Value condition = expect(op.getCondition(), op);
  if (isImm(condition))
    condition = materializeSGPR1(op.getLoc(), condition);
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
    FailureOr<unsigned> width = getRegisterPayloadWidth(
        op.getOperand(0).getType(), [&]() { return op.emitError(); });
    if (failed(width))
      return failure();
    ret = readFirstLane(*this, op.getLoc(), ret);
    if (*width == 2)
      ret = ensureSGPR2(*this, op.getLoc(), ret);
    FailureOr<SmallVector<Value, 2>> words =
        splitSGPRWords(*this, op, ret, *width);
    if (failed(words))
      return failure();
    for (auto [idx, word] : llvm::enumerate(*words))
      waveamdmachine::SMovB32Op::create(builder, op.getLoc(),
                                        (Twine("s") + Twine(idx)).str(), word);
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
                               SmallVectorImpl<func::FuncOp> &targets,
                               SmallVectorImpl<func::FuncOp> &scheduleInputs) {
  root->walk([&](func::FuncOp func) {
    if (func.isExternal())
      return;
    bool isKernel = func->hasAttr(wave::WaveDialect::getKernelAttrName());
    bool reachesWave = reachesWaveDialect(func);
    if (!isKernel && !reachesWave)
      return;
    targets.push_back(func);
    if (isKernel && reachesWave)
      scheduleInputs.push_back(func);
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
    root->walk([](func::FuncOp func) { func->removeAttr(kScheduleInputAttr); });

    SmallVector<func::FuncOp> targets;
    SmallVector<func::FuncOp> scheduleInputs;
    collectMachineSelectionTargets(root, targets, scheduleInputs);

    if (failed(diagnoseMachineSelectionTargets(targets)))
      return signalPassFailure();

    DataFlowSolver rangeSolver;
    if (failed(runRangeAnalysis(root, rangeSolver)))
      return signalPassFailure();

    auto scheduleInputIt = scheduleInputs.begin();
    for (func::FuncOp func : targets) {
      bool scheduleInput =
          scheduleInputIt != scheduleInputs.end() && *scheduleInputIt == func;
      if (failed(wave::wmsel::WaveAMDMachineSelector(func, rangeSolver).run()))
        return signalPassFailure();
      if (scheduleInput) {
        func->setAttr(kScheduleInputAttr, UnitAttr::get(func.getContext()));
        ++scheduleInputIt;
      }
    }
  }
};

} // namespace
