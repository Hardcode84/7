//===- Dialects.cpp - CAPI for Wave dialects ------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "Wave-c/Dialects.h"

#include "mlir/CAPI/IR.h"
#include "mlir/CAPI/Registration.h"
#include "mlir/CAPI/Support.h"
#include "mlir/CAPI/Wrap.h"
#include "mlir/Dialect/Wave/IR/Wave.h"
#include "mlir/Dialect/Wave/IR/WaveAMD.h"
#include "mlir/Dialect/Wave/IR/WaveMeta.h"
#include "mlir/Dialect/Wave/IR/WaveSymbols.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachine.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachineTarget.h"
#include "mlir/Pass/Pass.h"
#include "llvm/MC/MCSubtargetInfo.h"

namespace mlir::wave {
// Python registers the small pass set used by in-process pipeline entrypoints.
std::unique_ptr<::mlir::Pass> createWaveAMDDmaZeroFill();
std::unique_ptr<::mlir::Pass> createWaveLowerSymbolicMemory();
std::unique_ptr<::mlir::Pass> createWaveLowerRedistribute();
std::unique_ptr<::mlir::Pass> createWaveMetaSpecialize();
std::unique_ptr<::mlir::Pass> createWaveOptimizeMasks();
} // namespace mlir::wave
#include "llvm/ADT/StringRef.h"

#include <cassert>

using namespace mlir;

MLIR_DEFINE_CAPI_DIALECT_REGISTRATION(Wave, wave, mlir::wave::WaveDialect)
MLIR_DEFINE_CAPI_DIALECT_REGISTRATION(WaveAMD, waveamd,
                                      mlir::waveamd::WaveAMDDialect)
MLIR_DEFINE_CAPI_DIALECT_REGISTRATION(
    WaveAMDMachine, waveamdmachine, mlir::waveamdmachine::WaveAMDMachineDialect)
MLIR_DEFINE_CAPI_DIALECT_REGISTRATION(WaveMeta, wavemeta,
                                      mlir::wavemeta::WaveMetaDialect)

void mlirRegisterWavePasses(void) {
  ::mlir::registerPass([]() -> std::unique_ptr<::mlir::Pass> {
    return mlir::wave::createWaveMetaSpecialize();
  });
  ::mlir::registerPass([]() -> std::unique_ptr<::mlir::Pass> {
    return mlir::wave::createWaveAMDDmaZeroFill();
  });
  ::mlir::registerPass([]() -> std::unique_ptr<::mlir::Pass> {
    return mlir::wave::createWaveLowerSymbolicMemory();
  });
  ::mlir::registerPass([]() -> std::unique_ptr<::mlir::Pass> {
    return mlir::wave::createWaveLowerRedistribute();
  });
  ::mlir::registerPass([]() -> std::unique_ptr<::mlir::Pass> {
    return mlir::wave::createWaveOptimizeMasks();
  });
}

//===----------------------------------------------------------------------===//
// AMDGPU target capabilities
//===----------------------------------------------------------------------===//

static std::unique_ptr<llvm::MCSubtargetInfo>
createAMDGPUSubtarget(MlirStringRef chipRef, MlirStringRef featuresRef) {
  llvm::StringRef chip(chipRef.data, chipRef.length);
  llvm::StringRef features(featuresRef.data, featuresRef.length);
  waveamdmachine::AMDGPUTarget target;
  target.triple = "amdgcn-amd-amdhsa";
  target.chip = chip.str();
  target.features = features.str();
  target.isa = llvm::AMDGPU::getIsaVersion(chip);
  target.kind = llvm::AMDGPU::parseArchAMDGCN(chip);
  return waveamdmachine::createAMDGPUMCSubtargetInfo(target);
}

bool mlirWaveAMDGetTargetCapabilities(MlirStringRef chip,
                                      MlirStringRef features,
                                      MlirWaveAMDTargetCapabilities *out) {
  if (!out)
    return false;
  std::unique_ptr<llvm::MCSubtargetInfo> sti =
      createAMDGPUSubtarget(chip, features);
  if (!sti)
    return false;
  std::optional<waveamdmachine::AMDGPUTargetCapabilities> capabilities =
      waveamdmachine::getAMDGPUTargetCapabilities(*sti);
  if (!capabilities)
    return false;

  out->isaMajor = capabilities->isa.Major;
  out->isaMinor = capabilities->isa.Minor;
  out->isaStepping = capabilities->isa.Stepping;
  out->defaultWavefrontSize = capabilities->defaultWavefrontSize;
  out->addressableSGPRs = capabilities->addressableSGPRs;
  out->addressableVGPRs = capabilities->addressableVGPRs;
  out->addressableAGPRs = capabilities->addressableAGPRs;
  out->vgprAllocationGranule = capabilities->vgprAllocationGranule;
  out->vgprTupleAlignment = capabilities->vgprTupleAlignment;
  out->localMemoryBytes = capabilities->localMemoryBytes;
  out->addressableLocalMemoryBytes = capabilities->addressableLocalMemoryBytes;
  out->localMemoryBankCount = capabilities->localMemoryBankCount;
  out->executionUnitsPerCU = capabilities->executionUnitsPerCU;
  out->maxWavesPerEU = capabilities->maxWavesPerEU;
  out->totalVGPRs = capabilities->totalVGPRs;
  out->scheduleIssueWidth = capabilities->scheduleIssueWidth;
  out->maxUserSGPRs = capabilities->maxUserSGPRs;
  out->bufferResourceBaseBits = capabilities->bufferResourceBaseBits;
  out->bufferResourceNumRecordsBits =
      capabilities->bufferResourceNumRecordsBits;
  out->waitCounterFamily =
      static_cast<uint32_t>(capabilities->waitCounterFamily);
  out->matrixFamily = static_cast<uint32_t>(capabilities->matrixFamily);
  out->supportsWave32 = capabilities->supportsWave32;
  out->supportsWave64 = capabilities->supportsWave64;
  out->architectedFlatScratch = capabilities->architectedFlatScratch;
  out->architectedSGPRs = capabilities->architectedSGPRs;
  out->clusters = capabilities->clusters;
  out->kernargPreload = capabilities->kernargPreload;
  out->requiresInitialUnclausedVmem =
      capabilities->requiresInitialUnclausedVmem;
  out->waitXcnt = capabilities->waitXcnt;
  out->vgprWindowing = capabilities->vgprWindowing;
  out->setregVGPRMSBFixup = capabilities->setregVGPRMSBFixup;
  out->transCoexecutionHazard = capabilities->transCoexecutionHazard;
  out->wmmaCoexecutionHazard = capabilities->wmmaCoexecutionHazard;
  out->scratchBaseForwardingHazard = capabilities->scratchBaseForwardingHazard;
  out->descriptorDX10ClampAndIEEEMode =
      capabilities->kernelDescriptor.dx10ClampAndIEEEMode;
  out->descriptorWGPMode = capabilities->kernelDescriptor.wgpMode;
  out->descriptorSharedVGPRCount =
      capabilities->kernelDescriptor.sharedVGPRCount;
  out->descriptorRoundRobin = capabilities->kernelDescriptor.roundRobin;
  out->descriptorNamedBarrierCount =
      capabilities->kernelDescriptor.namedBarrierCount;
  out->descriptorArchitectedPrivateSegment =
      capabilities->kernelDescriptor.architectedPrivateSegment;
  return true;
}

bool mlirWaveAMDGetMmaCapabilities(MlirStringRef chip, uint32_t kindValue,
                                   MlirStringRef features,
                                   MlirWaveAMDMmaCapabilities *out) {
  if (!out)
    return false;
  std::optional<waveamd::MmaKind> kind = waveamd::symbolizeMmaKind(kindValue);
  if (!kind)
    return false;
  bool bf16;
  uint32_t operandElementBits;
  switch (*kind) {
  case waveamd::MmaKind::WmmaF32_16x16x32_F16:
    bf16 = false;
    operandElementBits = 16;
    break;
  case waveamd::MmaKind::WmmaF32_16x16x32_BF16:
    bf16 = true;
    operandElementBits = 16;
    break;
  default:
    return false;
  }

  std::unique_ptr<llvm::MCSubtargetInfo> sti =
      createAMDGPUSubtarget(chip, features);
  if (!sti)
    return false;
  std::optional<waveamdmachine::AMDGPUMmaCapabilities> capabilities =
      waveamdmachine::getAMDGPUWmmaCapabilities(*sti, bf16);
  if (!capabilities)
    return false;

  out->kind = kindValue;
  out->operandBank = static_cast<uint32_t>(capabilities->operandBank);
  out->accumulatorBank = static_cast<uint32_t>(capabilities->accumulatorBank);
  out->operandDwords = capabilities->operandDwords;
  out->accumulatorDwords = capabilities->accumulatorDwords;
  out->operandAlignment = capabilities->operandAlignment;
  out->accumulatorAlignment = capabilities->accumulatorAlignment;
  out->mTile = 16;
  out->nTile = 16;
  out->kTile = 32;
  out->laneKElements = capabilities->operandDwords * 32 / operandElementBits;
  return true;
}

//===----------------------------------------------------------------------===//
// Wave types
//===----------------------------------------------------------------------===//

bool mlirWaveTypeIsASimd(MlirType type) {
  return llvm::isa<wave::SimdType>(unwrap(type));
}

MlirType mlirWaveSimdTypeGet(MlirType elementType, int64_t width) {
  Type elt = unwrap(elementType);
  return wrap(wave::SimdType::get(elt.getContext(), elt, width));
}

MlirType mlirWaveSimdTypeGetElementType(MlirType type) {
  return wrap(llvm::cast<wave::SimdType>(unwrap(type)).getElementType());
}

int64_t mlirWaveSimdTypeGetWidth(MlirType type) {
  return llvm::cast<wave::SimdType>(unwrap(type)).getWidth();
}

bool mlirWaveTypeIsAMask(MlirType type) {
  return llvm::isa<wave::MaskType>(unwrap(type));
}

MlirType mlirWaveMaskTypeGet(MlirContext ctx, int64_t width) {
  return wrap(wave::MaskType::get(unwrap(ctx), width));
}

int64_t mlirWaveMaskTypeGetWidth(MlirType type) {
  return llvm::cast<wave::MaskType>(unwrap(type)).getWidth();
}

bool mlirWaveTypeIsAMemToken(MlirType type) {
  return llvm::isa<wave::MemTokenType>(unwrap(type));
}

MlirType mlirWaveMemTokenTypeGet(MlirContext ctx) {
  return wrap(wave::MemTokenType::get(unwrap(ctx)));
}

bool mlirWaveTypeIsAPtr(MlirType type) {
  return llvm::isa<wave::PtrType>(unwrap(type));
}

MlirType mlirWavePtrTypeGet(MlirType elementType, MlirAttribute addressSpace) {
  Type elt = unwrap(elementType);
  return wrap(wave::PtrType::get(elt.getContext(), elt, unwrap(addressSpace)));
}

MlirType mlirWavePtrTypeGetOpaque(MlirContext ctx, MlirAttribute addressSpace) {
  return wrap(wave::PtrType::get(unwrap(ctx), unwrap(addressSpace)));
}

bool mlirWavePtrTypeHasElementType(MlirType type) {
  return static_cast<bool>(
      llvm::cast<wave::PtrType>(unwrap(type)).getElementType());
}

MlirType mlirWavePtrTypeGetElementType(MlirType type) {
  return wrap(llvm::cast<wave::PtrType>(unwrap(type)).getElementType());
}

MlirAttribute mlirWavePtrTypeGetAddressSpace(MlirType type) {
  return wrap(llvm::cast<wave::PtrType>(unwrap(type)).getAddressSpace());
}

//===----------------------------------------------------------------------===//
// Wave symbolic attributes
//===----------------------------------------------------------------------===//

bool mlirWaveAttributeIsACastExtensionPolicy(MlirAttribute attr) {
  return llvm::isa<wave::CastExtensionPolicyAttr>(unwrap(attr));
}

MlirAttribute mlirWaveCastExtensionPolicyAttrGet(MlirContext ctx,
                                                 uint32_t value) {
  return wrap(wave::CastExtensionPolicyAttr::get(
      unwrap(ctx), static_cast<wave::CastExtension>(value)));
}

uint32_t mlirWaveCastExtensionPolicyAttrGetValue(MlirAttribute attr) {
  return static_cast<uint32_t>(
      llvm::cast<wave::CastExtensionPolicyAttr>(unwrap(attr)).getValue());
}

bool mlirWaveAttributeIsAExpr(MlirAttribute attr) {
  return llvm::isa<wave::ExprAttr>(unwrap(attr));
}

MlirAttribute mlirWaveExprAttrGetFromText(MlirContext ctx, MlirStringRef text) {
  MLIRContext *context = unwrap(ctx);
  // getOrLoad so the call is safe from Python before any other Wave op has
  // forced the dialect to load.
  auto *dialect = context->getOrLoadDialect<wave::WaveDialect>();
  if (!dialect)
    return MlirAttribute{nullptr};
  std::string diagnostic;
  auto handle = wave::sym::parseExpr(dialect->getSymbolStore(),
                                     llvm::StringRef(text.data, text.length),
                                     &diagnostic);
  if (failed(handle)) {
    emitError(UnknownLoc::get(context))
        << "failed to parse wave.expr text: " << diagnostic;
    return MlirAttribute{nullptr};
  }
  return wrap(wave::ExprAttr::get(context, *handle));
}

MlirAttribute mlirWaveExprAttrGetFromNodePtr(MlirContext ctx,
                                             uintptr_t nodePtr) {
  MLIRContext *context = unwrap(ctx);
  auto *dialect = context->getOrLoadDialect<wave::WaveDialect>();
  if (!dialect)
    return MlirAttribute{nullptr};
  std::string diagnostic;
  FailureOr<wave::sym::ExprHandle> handle = wave::sym::importExprFromNodePtr(
      dialect->getSymbolStore(), nodePtr, &diagnostic);
  if (failed(handle)) {
    emitError(UnknownLoc::get(context))
        << "failed to import wave.expr node: " << diagnostic;
    return MlirAttribute{nullptr};
  }
  return wrap(wave::ExprAttr::get(context, *handle));
}

MlirAttribute mlirWaveExprAttrGetFromBytes(MlirContext ctx,
                                           const uint8_t *bytes,
                                           size_t length) {
  MLIRContext *context = unwrap(ctx);
  auto *dialect = context->getOrLoadDialect<wave::WaveDialect>();
  if (!dialect)
    return MlirAttribute{nullptr};
  std::string diagnostic;
  auto handle = wave::sym::deserializeExpr(
      dialect->getSymbolStore(), llvm::ArrayRef<uint8_t>(bytes, length),
      &diagnostic);
  if (failed(handle)) {
    emitError(UnknownLoc::get(context))
        << "failed to materialize wave.expr from bytes: " << diagnostic;
    return MlirAttribute{nullptr};
  }
  return wrap(wave::ExprAttr::get(context, *handle));
}

bool mlirWaveAttributeIsAPred(MlirAttribute attr) {
  return llvm::isa<wave::PredAttr>(unwrap(attr));
}

MlirAttribute mlirWavePredAttrGetFromText(MlirContext ctx, MlirStringRef text) {
  MLIRContext *context = unwrap(ctx);
  auto *dialect = context->getOrLoadDialect<wave::WaveDialect>();
  if (!dialect)
    return MlirAttribute{nullptr};
  std::string diagnostic;
  auto handle = wave::sym::parsePred(dialect->getSymbolStore(),
                                     llvm::StringRef(text.data, text.length),
                                     &diagnostic);
  if (failed(handle)) {
    emitError(UnknownLoc::get(context))
        << "failed to parse wave.pred text: " << diagnostic;
    return MlirAttribute{nullptr};
  }
  return wrap(wave::PredAttr::get(context, *handle));
}

MlirAttribute mlirWavePredAttrGetFromNodePtr(MlirContext ctx,
                                             uintptr_t nodePtr) {
  MLIRContext *context = unwrap(ctx);
  auto *dialect = context->getOrLoadDialect<wave::WaveDialect>();
  if (!dialect)
    return MlirAttribute{nullptr};
  std::string diagnostic;
  FailureOr<wave::sym::PredHandle> handle = wave::sym::importPredFromNodePtr(
      dialect->getSymbolStore(), nodePtr, &diagnostic);
  if (failed(handle)) {
    emitError(UnknownLoc::get(context))
        << "failed to import wave.pred node: " << diagnostic;
    return MlirAttribute{nullptr};
  }
  return wrap(wave::PredAttr::get(context, *handle));
}

MlirAttribute mlirWavePredAttrGetFromBytes(MlirContext ctx,
                                           const uint8_t *bytes,
                                           size_t length) {
  MLIRContext *context = unwrap(ctx);
  auto *dialect = context->getOrLoadDialect<wave::WaveDialect>();
  if (!dialect)
    return MlirAttribute{nullptr};
  std::string diagnostic;
  auto handle = wave::sym::deserializePred(
      dialect->getSymbolStore(), llvm::ArrayRef<uint8_t>(bytes, length),
      &diagnostic);
  if (failed(handle)) {
    emitError(UnknownLoc::get(context))
        << "failed to materialize wave.pred from bytes: " << diagnostic;
    return MlirAttribute{nullptr};
  }
  return wrap(wave::PredAttr::get(context, *handle));
}

bool mlirWaveAttributeIsARedistribution(MlirAttribute attr) {
  return llvm::isa<wave::RedistributionAttr>(unwrap(attr));
}

MlirAttribute mlirWaveRedistributionAttrGet(int64_t blocks, int64_t items,
                                            MlirAttribute sourceBlock,
                                            MlirAttribute sourceItem,
                                            MlirAttribute sourceSlot) {
  wave::ExprAttr block = llvm::cast<wave::ExprAttr>(unwrap(sourceBlock));
  wave::ExprAttr item = llvm::cast<wave::ExprAttr>(unwrap(sourceItem));
  wave::ExprAttr slot = llvm::cast<wave::ExprAttr>(unwrap(sourceSlot));
  assert(block.getContext() == item.getContext() &&
         item.getContext() == slot.getContext() &&
         "redistribution expressions must share an MLIR context");
  return wrap(wave::RedistributionAttr::get(item.getContext(), blocks, items,
                                            block.getValue(), item.getValue(),
                                            slot.getValue()));
}

int64_t mlirWaveRedistributionAttrGetBlocks(MlirAttribute attr) {
  return llvm::cast<wave::RedistributionAttr>(unwrap(attr)).getBlocks();
}

int64_t mlirWaveRedistributionAttrGetItems(MlirAttribute attr) {
  return llvm::cast<wave::RedistributionAttr>(unwrap(attr)).getItems();
}

MlirAttribute mlirWaveRedistributionAttrGetSourceBlock(MlirAttribute attr) {
  wave::RedistributionAttr relation =
      llvm::cast<wave::RedistributionAttr>(unwrap(attr));
  return wrap(
      wave::ExprAttr::get(relation.getContext(), relation.getSourceBlock()));
}

MlirAttribute mlirWaveRedistributionAttrGetSourceItem(MlirAttribute attr) {
  wave::RedistributionAttr relation =
      llvm::cast<wave::RedistributionAttr>(unwrap(attr));
  return wrap(
      wave::ExprAttr::get(relation.getContext(), relation.getSourceItem()));
}

MlirAttribute mlirWaveRedistributionAttrGetSourceSlot(MlirAttribute attr) {
  wave::RedistributionAttr relation =
      llvm::cast<wave::RedistributionAttr>(unwrap(attr));
  return wrap(
      wave::ExprAttr::get(relation.getContext(), relation.getSourceSlot()));
}

bool mlirWaveAttributeIsAMemoryMapping(MlirAttribute attr) {
  return llvm::isa<wave::MemoryMappingAttr>(unwrap(attr));
}

MlirAttribute mlirWaveMemoryMappingAttrGet(MlirContext ctx,
                                           MlirAttribute bitOffset,
                                           MlirAttribute base,
                                           MlirAttribute targetBlock) {
  MLIRContext *context = unwrap(ctx);
  wave::ExprAttr bitOffsetAttr = llvm::cast<wave::ExprAttr>(unwrap(bitOffset));
  wave::ExprAttr baseAttr;
  wave::ExprAttr targetBlockAttr;
  if (base.ptr)
    baseAttr = llvm::cast<wave::ExprAttr>(unwrap(base));
  if (targetBlock.ptr)
    targetBlockAttr = llvm::cast<wave::ExprAttr>(unwrap(targetBlock));
  assert(bitOffsetAttr.getContext() == context &&
         (!baseAttr || baseAttr.getContext() == context) &&
         (!targetBlockAttr || targetBlockAttr.getContext() == context) &&
         "memory mapping expressions must share an MLIR context");
  return wrap(wave::MemoryMappingAttr::get(context, baseAttr, targetBlockAttr,
                                           bitOffsetAttr));
}

MlirAttribute mlirWaveMemoryMappingAttrGetBase(MlirAttribute attr) {
  wave::ExprAttr base =
      llvm::cast<wave::MemoryMappingAttr>(unwrap(attr)).getBase();
  return base ? wrap(base) : MlirAttribute{nullptr};
}

MlirAttribute mlirWaveMemoryMappingAttrGetTargetBlock(MlirAttribute attr) {
  wave::ExprAttr target =
      llvm::cast<wave::MemoryMappingAttr>(unwrap(attr)).getTargetBlock();
  return target ? wrap(target) : MlirAttribute{nullptr};
}

MlirAttribute mlirWaveMemoryMappingAttrGetBitOffset(MlirAttribute attr) {
  return wrap(llvm::cast<wave::MemoryMappingAttr>(unwrap(attr)).getBitOffset());
}

//===----------------------------------------------------------------------===//
// Wave address-space attributes
//===----------------------------------------------------------------------===//

bool mlirWaveAttributeIsAGlobalAddressSpace(MlirAttribute attr) {
  return llvm::isa<wave::GlobalAddressSpaceAttr>(unwrap(attr));
}

MlirAttribute mlirWaveGlobalAddressSpaceAttrGet(MlirContext ctx) {
  return wrap(wave::GlobalAddressSpaceAttr::get(unwrap(ctx)));
}

bool mlirWaveAttributeIsASharedAddressSpace(MlirAttribute attr) {
  return llvm::isa<wave::SharedAddressSpaceAttr>(unwrap(attr));
}

MlirAttribute mlirWaveSharedAddressSpaceAttrGet(MlirContext ctx) {
  return wrap(wave::SharedAddressSpaceAttr::get(unwrap(ctx)));
}

bool mlirWaveAttributeIsAPrivateAddressSpace(MlirAttribute attr) {
  return llvm::isa<wave::PrivateAddressSpaceAttr>(unwrap(attr));
}

MlirAttribute mlirWavePrivateAddressSpaceAttrGet(MlirContext ctx) {
  return wrap(wave::PrivateAddressSpaceAttr::get(unwrap(ctx)));
}

//===----------------------------------------------------------------------===//
// WaveAMD types and attributes
//===----------------------------------------------------------------------===//

bool mlirWaveAMDTypeIsAFragment(MlirType type) {
  return llvm::isa<waveamd::FragmentType>(unwrap(type));
}

MlirType mlirWaveAMDFragmentTypeGet(MlirContext ctx, int64_t role,
                                    MlirType elementType, int64_t rows,
                                    int64_t columns, int64_t waveSize,
                                    int64_t registers) {
  return wrap(waveamd::FragmentType::get(unwrap(ctx), role, unwrap(elementType),
                                         rows, columns, waveSize, registers));
}

int64_t mlirWaveAMDFragmentTypeGetRole(MlirType type) {
  return llvm::cast<waveamd::FragmentType>(unwrap(type)).getRole();
}

MlirType mlirWaveAMDFragmentTypeGetElementType(MlirType type) {
  return wrap(llvm::cast<waveamd::FragmentType>(unwrap(type)).getElementType());
}

int64_t mlirWaveAMDFragmentTypeGetRows(MlirType type) {
  return llvm::cast<waveamd::FragmentType>(unwrap(type)).getRows();
}

int64_t mlirWaveAMDFragmentTypeGetColumns(MlirType type) {
  return llvm::cast<waveamd::FragmentType>(unwrap(type)).getColumns();
}

int64_t mlirWaveAMDFragmentTypeGetWaveSize(MlirType type) {
  return llvm::cast<waveamd::FragmentType>(unwrap(type)).getWaveSize();
}

int64_t mlirWaveAMDFragmentTypeGetRegisters(MlirType type) {
  return llvm::cast<waveamd::FragmentType>(unwrap(type)).getRegisters();
}

bool mlirWaveAMDAttributeIsABufferAddressSpace(MlirAttribute attr) {
  return llvm::isa<waveamd::BufferAddressSpaceAttr>(unwrap(attr));
}

MlirAttribute mlirWaveAMDBufferAddressSpaceAttrGet(MlirContext ctx) {
  return wrap(waveamd::BufferAddressSpaceAttr::get(unwrap(ctx)));
}

bool mlirWaveAMDAttributeIsALoadCache(MlirAttribute attr) {
  return llvm::isa<waveamd::LoadCacheAttr>(unwrap(attr));
}

MlirAttribute mlirWaveAMDLoadCacheAttrGet(MlirContext ctx, uint32_t value) {
  return wrap(waveamd::LoadCacheAttr::get(
      unwrap(ctx), static_cast<waveamd::LoadCacheKind>(value)));
}

uint32_t mlirWaveAMDLoadCacheAttrGetValue(MlirAttribute attr) {
  return static_cast<uint32_t>(
      llvm::cast<waveamd::LoadCacheAttr>(unwrap(attr)).getValue());
}

bool mlirWaveAMDAttributeIsAStoreCache(MlirAttribute attr) {
  return llvm::isa<waveamd::StoreCacheAttr>(unwrap(attr));
}

MlirAttribute mlirWaveAMDStoreCacheAttrGet(MlirContext ctx, uint32_t value) {
  return wrap(waveamd::StoreCacheAttr::get(
      unwrap(ctx), static_cast<waveamd::StoreCacheKind>(value)));
}

uint32_t mlirWaveAMDStoreCacheAttrGetValue(MlirAttribute attr) {
  return static_cast<uint32_t>(
      llvm::cast<waveamd::StoreCacheAttr>(unwrap(attr)).getValue());
}

//===----------------------------------------------------------------------===//
// WaveMeta types
//===----------------------------------------------------------------------===//

bool mlirWaveMetaTypeIsAPTuple(MlirType type) {
  return llvm::isa<wavemeta::PTupleType>(unwrap(type));
}

MlirType mlirWaveMetaPTupleTypeGet(MlirType elementType, MlirAttribute width) {
  Type elt = unwrap(elementType);
  return wrap(wavemeta::PTupleType::get(elt.getContext(), elt, unwrap(width)));
}

MlirType mlirWaveMetaPTupleTypeGetElementType(MlirType type) {
  return wrap(llvm::cast<wavemeta::PTupleType>(unwrap(type)).getElementType());
}

MlirAttribute mlirWaveMetaPTupleTypeGetWidth(MlirType type) {
  return wrap(llvm::cast<wavemeta::PTupleType>(unwrap(type)).getWidth());
}
