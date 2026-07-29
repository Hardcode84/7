//===- WaveAMDMachineTarget.h - AMDGPU target helpers ----------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef MLIR_DIALECT_WAVEAMDMACHINE_IR_WAVEAMDMACHINETARGET_H
#define MLIR_DIALECT_WAVEAMDMACHINE_IR_WAVEAMDMACHINETARGET_H

#include "mlir/IR/BuiltinOps.h"
#include "mlir/IR/Diagnostics.h"
#include "mlir/Support/LLVM.h"
#include "mlir/Support/LogicalResult.h"
#include "llvm/ADT/STLFunctionalExtras.h"
#include "llvm/ADT/StringRef.h"
#include "llvm/TargetParser/AMDGPUTargetParser.h"
#include "llvm/TargetParser/SubtargetFeature.h"

#include <cstdint>
#include <memory>
#include <optional>
#include <string>

namespace llvm {
class MCRegisterInfo;
class MCSubtargetInfo;
} // namespace llvm

#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachineTargetEnums.h.inc"

namespace mlir::waveamdmachine {

enum class RegClass : uint32_t;

struct AMDGPUTarget {
  std::string triple;
  std::string chip;
  std::string features;
  llvm::AMDGPU::IsaVersion isa = {0, 0, 0};
  llvm::AMDGPU::GPUKind kind = llvm::AMDGPU::GK_NONE;
};

struct AMDGPUKernelDescriptorCapabilities {
  bool dx10ClampAndIEEEMode = false;
  bool wgpMode = false;
  bool sharedVGPRCount = false;
  bool roundRobin = false;
  bool namedBarrierCount = false;
  bool architectedPrivateSegment = false;
};

struct AMDGPUTargetCapabilities {
  llvm::AMDGPU::IsaVersion isa = {0, 0, 0};
  unsigned defaultWavefrontSize = 0;
  unsigned addressableSGPRs = 0;
  unsigned addressableVGPRs = 0;
  unsigned addressableAGPRs = 0;
  unsigned vgprAllocationGranule = 0;
  unsigned vgprTupleAlignment = 0;
  unsigned localMemoryBytes = 0;
  unsigned addressableLocalMemoryBytes = 0;
  unsigned localMemoryBankCount = 0;
  unsigned executionUnitsPerCU = 0;
  unsigned maxWavesPerEU = 0;
  unsigned totalVGPRs = 0;
  unsigned scheduleIssueWidth = 0;
  unsigned maxUserSGPRs = 0;
  unsigned bufferResourceBaseBits = 0;
  unsigned bufferResourceNumRecordsBits = 0;
  AMDGPUKernelDescriptorCapabilities kernelDescriptor;
  WaitCounterFamily waitCounterFamily = WaitCounterFamily::Legacy;
  MatrixFamily matrixFamily = MatrixFamily::None;
  bool supportsWave32 = false;
  bool supportsWave64 = false;
  bool architectedFlatScratch = false;
  bool architectedSGPRs = false;
  bool clusters = false;
  bool kernargPreload = false;
  bool requiresInitialUnclausedVmem = false;
  bool waitXcnt = false;
  bool vgprWindowing = false;
  bool setregVGPRMSBFixup = false;
  bool setPrioIncWg = false;
  bool transCoexecutionHazard = false;
  bool wmmaCoexecutionHazard = false;
  bool scratchBaseForwardingHazard = false;
};

struct AMDGPUMmaCapabilities {
  RegClass operandBank;
  RegClass accumulatorBank;
  unsigned operandDwords = 0;
  unsigned accumulatorDwords = 0;
  unsigned operandAlignment = 0;
  unsigned accumulatorAlignment = 0;
  unsigned negLoMask = 0;
  unsigned negHiMask = 0;
};

llvm::StringRef getExpertSchedulingModeAttrName();

std::optional<AMDGPUTarget> parseAMDGPUTargetAttr(llvm::StringRef value);

FailureOr<AMDGPUTarget>
parseAMDGPUTargetAttr(llvm::StringRef value,
                      llvm::function_ref<InFlightDiagnostic()> emitError);

ModuleOp findAMDGPUTargetModule(Operation *op);

FailureOr<AMDGPUTarget> getAMDGPUTarget(Operation *op,
                                        llvm::StringRef consumer);

FailureOr<llvm::AMDGPU::IsaVersion>
getAMDGPUTargetIsaVersion(Operation *op, llvm::StringRef consumer);

std::unique_ptr<llvm::MCSubtargetInfo>
createAMDGPUMCSubtargetInfo(const AMDGPUTarget &target,
                            std::string *error = nullptr);

FailureOr<std::unique_ptr<llvm::MCSubtargetInfo>>
createAMDGPUMCSubtargetInfo(Operation *op, llvm::StringRef consumer);

std::optional<AMDGPUTargetCapabilities>
getAMDGPUTargetCapabilities(const llvm::MCSubtargetInfo &sti);

void forEachAMDGPUAllocatableSGPRTuple(
    const llvm::MCRegisterInfo &mri, unsigned addressableSGPRs,
    llvm::function_ref<void(unsigned width, unsigned base, unsigned mcRegister)>
        callback);

std::optional<AMDGPUMmaCapabilities>
getAMDGPUWmmaCapabilities(const llvm::MCSubtargetInfo &sti, bool bf16);

std::optional<AMDGPUMmaCapabilities>
getAMDGPUGfx1250WmmaCapabilities(bool bf16);

bool isAMDGPUOpcodeAvailable(unsigned opcode,
                             const llvm::FeatureBitset &features);

unsigned getAMDGPULocalMemoryBankCount(const llvm::MCSubtargetInfo &sti);

unsigned getAMDGPUAddressableAGPRs(const llvm::MCSubtargetInfo &sti);

bool supportsAGPRs(const llvm::AMDGPU::IsaVersion &isa);

bool supportsCvtPkF16F32Inst(const llvm::AMDGPU::IsaVersion &isa);

bool supportsCvtPkBF16F32Inst(const llvm::AMDGPU::IsaVersion &isa);

unsigned getAMDGPUTensorcntBitMask(const llvm::AMDGPU::IsaVersion &isa);

std::optional<unsigned> getAMDGPUDefaultWavefrontSize(llvm::StringRef chip);

FailureOr<unsigned> getAMDGPUDefaultWavefrontSize(Operation *op,
                                                  llvm::StringRef consumer);

FailureOr<unsigned> getAMDGPUWavefrontSize(Operation *op,
                                           llvm::StringRef consumer);

FailureOr<unsigned> getAMDGPUWavefrontSize(Operation *op,
                                           const AMDGPUTarget &target,
                                           llvm::StringRef consumer);

FailureOr<unsigned> getAMDGPUWavefrontSize(Operation *op,
                                           const AMDGPUTarget &target,
                                           const llvm::MCSubtargetInfo &sti,
                                           llvm::StringRef consumer);

FailureOr<bool> getAMDGPUD16PreservesUnusedBits(Operation *op,
                                                llvm::StringRef consumer);

FailureOr<std::string> getAMDGPUAssemblerFeatures(Operation *op,
                                                  llvm::StringRef features,
                                                  llvm::StringRef consumer);

} // namespace mlir::waveamdmachine

#endif // MLIR_DIALECT_WAVEAMDMACHINE_IR_WAVEAMDMACHINETARGET_H
