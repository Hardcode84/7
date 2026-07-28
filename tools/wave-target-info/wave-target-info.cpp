//===- wave-target-info.cpp - Print Wave AMDGPU target facts -------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachineTarget.h"

#include "llvm/MC/MCSubtargetInfo.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/Support/InitLLVM.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/TargetParser/AMDGPUTargetParser.h"

using namespace mlir::waveamdmachine;

static llvm::cl::opt<std::string> chip(llvm::cl::Positional, llvm::cl::Required,
                                       llvm::cl::desc("<AMDGPU processor>"));

static llvm::StringRef boolString(bool value) {
  return value ? "true" : "false";
}

static void printCapabilities(const AMDGPUTargetCapabilities &capabilities) {
  llvm::outs() << "isa: " << static_cast<unsigned>(capabilities.isa.Major)
               << '.' << static_cast<unsigned>(capabilities.isa.Minor) << '.'
               << static_cast<unsigned>(capabilities.isa.Stepping) << '\n';
  llvm::outs() << "default_wavefront_size: "
               << capabilities.defaultWavefrontSize << '\n';
  llvm::outs() << "supports_wave32: " << boolString(capabilities.supportsWave32)
               << '\n';
  llvm::outs() << "supports_wave64: " << boolString(capabilities.supportsWave64)
               << '\n';
  llvm::outs() << "addressable_sgprs: " << capabilities.addressableSGPRs
               << '\n';
  llvm::outs() << "addressable_vgprs: " << capabilities.addressableVGPRs
               << '\n';
  llvm::outs() << "addressable_agprs: " << capabilities.addressableAGPRs
               << '\n';
  llvm::outs() << "vgpr_allocation_granule: "
               << capabilities.vgprAllocationGranule << '\n';
  llvm::outs() << "vgpr_tuple_alignment: " << capabilities.vgprTupleAlignment
               << '\n';
  llvm::outs() << "local_memory_bytes: " << capabilities.localMemoryBytes
               << '\n';
  llvm::outs() << "addressable_local_memory_bytes: "
               << capabilities.addressableLocalMemoryBytes << '\n';
  llvm::outs() << "local_memory_banks: " << capabilities.localMemoryBankCount
               << '\n';
  llvm::outs() << "max_waves_per_eu: " << capabilities.maxWavesPerEU << '\n';
  llvm::outs() << "max_user_sgprs: " << capabilities.maxUserSGPRs << '\n';
  llvm::outs() << "buffer_resource_base_bits: "
               << capabilities.bufferResourceBaseBits << '\n';
  llvm::outs() << "buffer_resource_num_records_bits: "
               << capabilities.bufferResourceNumRecordsBits << '\n';
  llvm::outs() << "wait_counter_family: "
               << stringifyWaitCounterFamily(capabilities.waitCounterFamily)
               << '\n';
  llvm::outs() << "matrix_family: "
               << stringifyMatrixFamily(capabilities.matrixFamily) << '\n';
  llvm::outs() << "architected_flat_scratch: "
               << boolString(capabilities.architectedFlatScratch) << '\n';
  llvm::outs() << "architected_sgprs: "
               << boolString(capabilities.architectedSGPRs) << '\n';
  llvm::outs() << "clusters: " << boolString(capabilities.clusters) << '\n';
  llvm::outs() << "kernarg_preload: " << boolString(capabilities.kernargPreload)
               << '\n';
  llvm::outs() << "requires_initial_unclaused_vmem: "
               << boolString(capabilities.requiresInitialUnclausedVmem) << '\n';
  llvm::outs() << "wait_xcnt: " << boolString(capabilities.waitXcnt) << '\n';
  llvm::outs() << "vgpr_windowing: " << boolString(capabilities.vgprWindowing)
               << '\n';
  llvm::outs() << "setreg_vgpr_msb_fixup: "
               << boolString(capabilities.setregVGPRMSBFixup) << '\n';
  llvm::outs() << "descriptor_dx10_ieee: "
               << boolString(capabilities.kernelDescriptor.dx10ClampAndIEEEMode)
               << '\n';
  llvm::outs() << "descriptor_wgp_mode: "
               << boolString(capabilities.kernelDescriptor.wgpMode) << '\n';
  llvm::outs() << "descriptor_shared_vgpr_count: "
               << boolString(capabilities.kernelDescriptor.sharedVGPRCount)
               << '\n';
  llvm::outs() << "descriptor_round_robin: "
               << boolString(capabilities.kernelDescriptor.roundRobin) << '\n';
  llvm::outs() << "descriptor_named_barrier_count: "
               << boolString(capabilities.kernelDescriptor.namedBarrierCount)
               << '\n';
  llvm::outs() << "descriptor_architected_private_segment: "
               << boolString(
                      capabilities.kernelDescriptor.architectedPrivateSegment)
               << '\n';
}

int main(int argc, char **argv) {
  llvm::InitLLVM x(argc, argv);
  llvm::cl::ParseCommandLineOptions(argc, argv,
                                    "Print Wave AMDGPU target facts.\n");

  AMDGPUTarget target;
  target.triple = "amdgcn-amd-amdhsa";
  target.chip = chip;
  target.isa = llvm::AMDGPU::getIsaVersion(chip);
  target.kind = llvm::AMDGPU::parseArchAMDGCN(chip);
  if (target.kind == llvm::AMDGPU::GK_NONE || target.isa.Major == 0) {
    llvm::errs() << "unsupported AMDGPU processor: " << chip << '\n';
    return 1;
  }
  std::string error;
  std::unique_ptr<llvm::MCSubtargetInfo> sti =
      createAMDGPUMCSubtargetInfo(target, &error);
  if (!sti) {
    llvm::errs() << error << '\n';
    return 1;
  }
  std::optional<AMDGPUTargetCapabilities> capabilities =
      getAMDGPUTargetCapabilities(*sti);
  if (!capabilities) {
    llvm::errs() << "no Wave capability contract for target: " << chip << '\n';
    return 1;
  }
  printCapabilities(*capabilities);
  return 0;
}
