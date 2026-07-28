//===- wave-target-info.cpp - Print Wave AMDGPU target facts -------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "mlir/Dialect/WaveAMDMachine/CostModel/CostModelEnums.h"
#include "mlir/Dialect/WaveAMDMachine/IR/WaveAMDMachineTarget.h"

#include "MCTargetDesc/AMDGPUMCTargetDesc.h"
#include "Utils/AMDGPUBaseInfo.h"
#include "llvm/ADT/ArrayRef.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/MC/MCInst.h"
#include "llvm/MC/MCInstrInfo.h"
#include "llvm/MC/MCSchedule.h"
#include "llvm/MC/MCSubtargetInfo.h"
#include "llvm/MC/TargetRegistry.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/Support/InitLLVM.h"
#include "llvm/Support/JSON.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/TargetParser/AMDGPUTargetParser.h"
#include "llvm/TargetParser/Triple.h"

#include <array>
#include <cstdint>
#include <memory>
#include <optional>
#include <string>

#define GET_AVAILABLE_OPCODE_CHECKER
#include "AMDGPUGenInstrInfo.inc"

using namespace mlir::waveamdmachine;

#include "mlir/Dialect/WaveAMDMachine/CostModel/CostModelEnums.cpp.inc"

static llvm::cl::opt<std::string> chip(llvm::cl::Positional, llvm::cl::Required,
                                       llvm::cl::desc("<AMDGPU processor>"));
static llvm::cl::opt<bool>
    scheduleModel("schedule-model",
                  llvm::cl::desc("print LLVM MC scheduling facts"));
static llvm::cl::opt<bool> json("json",
                                llvm::cl::desc("print schedule model as JSON"));

struct ScheduleResource {
  LLVMProcResource resource;
  unsigned acquireAtCycle;
  unsigned releaseAtCycle;

  bool operator==(const ScheduleResource &other) const {
    return resource == other.resource &&
           acquireAtCycle == other.acquireAtCycle &&
           releaseAtCycle == other.releaseAtCycle;
  }
};

struct OpcodeSchedule {
  int latency = 0;
  int resourceCycles = 0;
  FunctionalUnit functionalUnit = FunctionalUnit::None;
  llvm::SmallVector<ScheduleResource> resources;

  bool operator==(const OpcodeSchedule &other) const {
    return latency == other.latency && resourceCycles == other.resourceCycles &&
           functionalUnit == other.functionalUnit &&
           resources == other.resources;
  }
};

struct ClassSchedule {
  SchedClass schedClass;
  bool supported = false;
  bool waveOwned = false;
  OpcodeSchedule schedule;
  llvm::SmallVector<llvm::StringRef> opcodes;
};

struct ScheduleProbe {
  SchedClass schedClass;
  unsigned opcode;
  unsigned aliasOpcode;
};

static constexpr std::array<ScheduleProbe,
                            static_cast<size_t>(SchedClass::NumSchedClasses)>
    scheduleProbes = {{
        {SchedClass::NoInst, 0, 0},
        {SchedClass::WriteSALU, llvm::AMDGPU::S_ADD_U32_gfx12, 0},
        {SchedClass::Write32Bit, llvm::AMDGPU::V_ADD_F32_e32_gfx12, 0},
        {SchedClass::Write64Bit, llvm::AMDGPU::V_ADD_U64_e32_gfx1250, 0},
        {SchedClass::WriteFloatFMA, llvm::AMDGPU::V_FMA_F32_e64_gfx12, 0},
        {SchedClass::WriteDouble, llvm::AMDGPU::V_MUL_F64_e64_gfx12, 0},
        {SchedClass::WriteTrans32, llvm::AMDGPU::V_EXP_F32_e32_gfx12, 0},
        {SchedClass::WriteSFPU, llvm::AMDGPU::S_CVT_F32_U32_gfx12, 0},
        {SchedClass::Write2PassMAI, 0, 0},
        {SchedClass::Write4PassMAI, 0, 0},
        {SchedClass::Write8PassMAI, 0, 0},
        {SchedClass::Write16PassMAI, 0, 0},
        {SchedClass::WriteXDL2PassWMMA,
         llvm::AMDGPU::V_WMMA_F32_16X16X32_F16_w32_twoaddr_gfx1250,
         llvm::AMDGPU::V_WMMA_F32_16X16X32_BF16_w32_twoaddr_gfx1250},
        {SchedClass::WriteXDL4PassWMMA,
         llvm::AMDGPU::V_WMMA_I32_16X16X64_IU8_w32_twoaddr_gfx1250, 0},
        {SchedClass::Write4PassWMMA,
         llvm::AMDGPU::V_WMMA_F32_16X16X4_F32_w32_twoaddr_gfx1250, 0},
        {SchedClass::Write8PassWMMA, 0, 0},
        {SchedClass::Write16PassWMMA,
         llvm::AMDGPU::V_WMMA_F32_16X16X16_F16_twoaddr_w32,
         llvm::AMDGPU::V_WMMA_F32_16X16X16_BF16_twoaddr_w32},
        {SchedClass::WriteVMEM, llvm::AMDGPU::GLOBAL_LOAD_DWORD_SADDR_gfx12, 0},
        {SchedClass::WriteSMEM, llvm::AMDGPU::S_LOAD_B32_IMM_gfx12, 0},
        {SchedClass::WriteLDS, llvm::AMDGPU::DS_READ_B32_gfx12, 0},
        {SchedClass::WriteBranch, llvm::AMDGPU::S_BRANCH_gfx12, 0},
        {SchedClass::WriteBarrier, llvm::AMDGPU::S_BARRIER_WAIT_gfx12, 0},
        {SchedClass::WriteExport, llvm::AMDGPU::EXP_gfx12, 0},
        {SchedClass::WaitcntPseudo, 0, 0},
    }};

static constexpr bool scheduleProbeOrderIsValid() {
  for (size_t index = 0; index < scheduleProbes.size(); ++index)
    if (static_cast<size_t>(scheduleProbes[index].schedClass) != index)
      return false;
  return true;
}

static_assert(scheduleProbeOrderIsValid());

static llvm::StringRef boolString(bool value) {
  return value ? "true" : "false";
}

static std::optional<FunctionalUnit>
getFunctionalUnit(LLVMProcResource resource) {
  switch (resource) {
  case LLVMProcResource::HWVALU:
    return FunctionalUnit::VALU;
  case LLVMProcResource::HWSALU:
    return FunctionalUnit::SALU;
  case LLVMProcResource::HWVMEM:
    return FunctionalUnit::VMEM;
  case LLVMProcResource::HWLGKM:
    return FunctionalUnit::LGKM;
  case LLVMProcResource::HWXDL:
    return FunctionalUnit::MFMA_XDL;
  case LLVMProcResource::HWTransVALU:
    return FunctionalUnit::TRANS;
  case LLVMProcResource::HWBranch:
    return FunctionalUnit::BRANCH;
  case LLVMProcResource::HWExport:
    return FunctionalUnit::EXPORT;
  case LLVMProcResource::HWRC:
    return std::nullopt;
  }
  llvm_unreachable("bad LLVM processor resource");
}

static bool resolveSchedClass(const llvm::MCSubtargetInfo &sti,
                              const llvm::MCInstrInfo &mcii,
                              const llvm::MCSchedModel &model, unsigned opcode,
                              unsigned &schedClass, std::string &error) {
  llvm::MCInst inst;
  inst.setOpcode(opcode);
  schedClass = mcii.get(opcode).getSchedClass();
  unsigned processor = model.getProcessorID();
  unsigned resolutionCount = 0;
  while (schedClass && model.getSchedClassDesc(schedClass)->isVariant()) {
    if (++resolutionCount > model.NumSchedClasses) {
      error = "cyclic scheduling class for " + mcii.getName(opcode).str();
      return false;
    }
    unsigned resolved =
        sti.resolveVariantSchedClass(schedClass, &inst, &mcii, processor);
    if (!resolved || resolved == schedClass) {
      error = "failed to resolve scheduling class for " +
              mcii.getName(opcode).str();
      return false;
    }
    schedClass = resolved;
  }
  if (!schedClass) {
    error = "missing scheduling class for " + mcii.getName(opcode).str();
    return false;
  }
  return true;
}

static bool appendScheduleResource(const llvm::MCSchedModel &model,
                                   const llvm::MCInstrInfo &mcii,
                                   unsigned opcode,
                                   const llvm::MCWriteProcResEntry &resource,
                                   OpcodeSchedule &schedule,
                                   std::optional<FunctionalUnit> &primaryUnit,
                                   std::string &error) {
  const llvm::MCProcResourceDesc *descriptor =
      model.getProcResource(resource.ProcResourceIdx);
  llvm::StringRef resourceName(descriptor->Name);
  std::optional<LLVMProcResource> resourceKind =
      symbolizeLLVMProcResource(resourceName);
  if (!resourceKind) {
    error = "unknown LLVM processor resource `" + resourceName.str() +
            "` for " + mcii.getName(opcode).str();
    return false;
  }
  if (resource.ReleaseAtCycle < resource.AcquireAtCycle) {
    error =
        "invalid processor resource interval for " + mcii.getName(opcode).str();
    return false;
  }
  schedule.resources.push_back(
      {*resourceKind, resource.AcquireAtCycle, resource.ReleaseAtCycle});
  if (primaryUnit)
    return true;
  primaryUnit = getFunctionalUnit(*resourceKind);
  if (!primaryUnit)
    return true;
  schedule.functionalUnit = *primaryUnit;
  schedule.resourceCycles = resource.ReleaseAtCycle - resource.AcquireAtCycle;
  return true;
}

static bool queryOpcodeSchedule(const llvm::MCSubtargetInfo &sti,
                                const llvm::MCInstrInfo &mcii, unsigned opcode,
                                OpcodeSchedule &schedule, std::string &error) {
  const llvm::MCSchedModel &model = sti.getSchedModel();
  if (!model.hasInstrSchedModel()) {
    error = "target has no LLVM instruction scheduling model";
    return false;
  }
  unsigned schedClass = 0;
  if (!resolveSchedClass(sti, mcii, model, opcode, schedClass, error))
    return false;
  const llvm::MCSchedClassDesc *descriptor =
      model.getSchedClassDesc(schedClass);
  if (!descriptor || !descriptor->isValid()) {
    error = "invalid scheduling class for " + mcii.getName(opcode).str();
    return false;
  }
  schedule.latency = llvm::MCSchedModel::computeInstrLatency(sti, *descriptor);
  if (schedule.latency < 0) {
    error = "invalid latency for " + mcii.getName(opcode).str();
    return false;
  }

  const llvm::MCWriteProcResEntry *resource =
      sti.getWriteProcResBegin(descriptor);
  const llvm::MCWriteProcResEntry *resourceEnd =
      sti.getWriteProcResEnd(descriptor);
  std::optional<FunctionalUnit> primaryUnit;
  for (; resource != resourceEnd; ++resource)
    if (!appendScheduleResource(model, mcii, opcode, *resource, schedule,
                                primaryUnit, error))
      return false;
  if (!primaryUnit) {
    error =
        "missing primary processor resource for " + mcii.getName(opcode).str();
    return false;
  }
  return true;
}

static bool isWaveOwnedSchedClass(SchedClass schedClass) {
  return schedClass == SchedClass::NoInst ||
         schedClass == SchedClass::WaitcntPseudo;
}

static bool areProbeOpcodesAvailable(const ScheduleProbe &probe,
                                     const llvm::FeatureBitset &features) {
  if (!llvm::AMDGPU_MC::isOpcodeAvailable(probe.opcode, features))
    return false;
  return !probe.aliasOpcode ||
         llvm::AMDGPU_MC::isOpcodeAvailable(probe.aliasOpcode, features);
}

static bool queryAliasSchedule(const llvm::MCSubtargetInfo &sti,
                               const llvm::MCInstrInfo &mcii,
                               const ScheduleProbe &probe,
                               ClassSchedule &result, std::string &error) {
  if (!probe.aliasOpcode)
    return true;
  OpcodeSchedule aliasSchedule;
  if (!queryOpcodeSchedule(sti, mcii, probe.aliasOpcode, aliasSchedule, error))
    return false;
  if (!(aliasSchedule == result.schedule)) {
    error = "schedule aliases disagree for " +
            stringifySchedClass(probe.schedClass).str();
    return false;
  }
  result.opcodes.push_back(mcii.getName(probe.aliasOpcode));
  return true;
}

static bool queryClassSchedule(const llvm::MCSubtargetInfo &sti,
                               const llvm::MCInstrInfo &mcii,
                               const llvm::FeatureBitset &features,
                               const ScheduleProbe &probe,
                               ClassSchedule &result, std::string &error) {
  result.schedClass = probe.schedClass;
  if (isWaveOwnedSchedClass(probe.schedClass)) {
    result.supported = true;
    result.waveOwned = true;
    return true;
  }
  if (!probe.opcode)
    return true;
  if (!areProbeOpcodesAvailable(probe, features))
    return true;
  if (!queryOpcodeSchedule(sti, mcii, probe.opcode, result.schedule, error))
    return false;
  result.supported = true;
  result.opcodes.push_back(mcii.getName(probe.opcode));
  return queryAliasSchedule(sti, mcii, probe, result, error);
}

static bool queryClassSchedules(const llvm::MCSubtargetInfo &sti,
                                const llvm::MCInstrInfo &mcii,
                                llvm::SmallVectorImpl<ClassSchedule> &schedules,
                                std::string &error) {
  llvm::FeatureBitset features = sti.getFeatureBits();
  unsigned wavefrontSize = llvm::AMDGPU::IsaInfo::getWavefrontSize(sti);
  features.set(wavefrontSize == 32 ? llvm::AMDGPU::FeatureWavefrontSize32
                                   : llvm::AMDGPU::FeatureWavefrontSize64);
  for (const ScheduleProbe &probe : scheduleProbes) {
    ClassSchedule result;
    if (!queryClassSchedule(sti, mcii, features, probe, result, error))
      return false;
    schedules.push_back(std::move(result));
  }
  return true;
}

static void printScheduleModelJSON(llvm::StringRef target,
                                   const llvm::MCSchedModel &model,
                                   llvm::ArrayRef<ClassSchedule> schedules) {
  llvm::json::OStream output(llvm::outs(), /*IndentSize=*/2);
  output.object([&]() {
    output.attribute("target", target);
    output.attribute("issue_width", static_cast<int64_t>(model.IssueWidth));
    output.attributeArray("classes", [&]() {
      for (const ClassSchedule &entry : schedules) {
        output.object([&]() {
          output.attribute("name", stringifySchedClass(entry.schedClass));
          output.attribute("supported", entry.supported);
          output.attribute("source",
                           entry.waveOwned ? "wave-pseudo" : "llvm-mc");
          if (!entry.supported)
            return;
          output.attribute("latency",
                           static_cast<int64_t>(entry.schedule.latency));
          output.attribute("resource_cycles",
                           static_cast<int64_t>(entry.schedule.resourceCycles));
          output.attribute(
              "functional_unit",
              stringifyFunctionalUnit(entry.schedule.functionalUnit));
          output.attributeArray("opcodes", [&]() {
            for (llvm::StringRef opcode : entry.opcodes)
              output.value(opcode);
          });
          output.attributeArray("resources", [&]() {
            for (const ScheduleResource &resource : entry.schedule.resources) {
              output.object([&]() {
                output.attribute("name",
                                 stringifyLLVMProcResource(resource.resource));
                output.attribute("acquire",
                                 static_cast<int64_t>(resource.acquireAtCycle));
                output.attribute("release",
                                 static_cast<int64_t>(resource.releaseAtCycle));
              });
            }
          });
        });
      }
    });
  });
  llvm::outs() << '\n';
}

static void printScheduleModelText(llvm::StringRef target,
                                   const llvm::MCSchedModel &model,
                                   llvm::ArrayRef<ClassSchedule> schedules) {
  llvm::outs() << "schedule_target: " << target << '\n';
  llvm::outs() << "schedule_issue_width: " << model.IssueWidth << '\n';
  for (const ClassSchedule &entry : schedules) {
    llvm::outs() << "class: " << stringifySchedClass(entry.schedClass) << '\n';
    llvm::outs() << "  supported: " << boolString(entry.supported) << '\n';
    if (!entry.supported)
      continue;
    llvm::outs() << "  source: "
                 << (entry.waveOwned ? "wave-pseudo" : "llvm-mc") << '\n';
    llvm::outs() << "  latency: " << entry.schedule.latency << '\n';
    llvm::outs() << "  resource_cycles: " << entry.schedule.resourceCycles
                 << '\n';
    llvm::outs() << "  functional_unit: "
                 << stringifyFunctionalUnit(entry.schedule.functionalUnit)
                 << '\n';
    for (llvm::StringRef opcode : entry.opcodes)
      llvm::outs() << "  opcode: " << opcode << '\n';
    for (const ScheduleResource &resource : entry.schedule.resources)
      llvm::outs() << "  resource: "
                   << stringifyLLVMProcResource(resource.resource)
                   << " acquire=" << resource.acquireAtCycle
                   << " release=" << resource.releaseAtCycle << '\n';
  }
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
  llvm::outs() << "execution_units_per_cu: " << capabilities.executionUnitsPerCU
               << '\n';
  llvm::outs() << "max_waves_per_eu: " << capabilities.maxWavesPerEU << '\n';
  llvm::outs() << "total_vgprs: " << capabilities.totalVGPRs << '\n';
  llvm::outs() << "schedule_issue_width: " << capabilities.scheduleIssueWidth
               << '\n';
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
  llvm::outs() << "trans_coexecution_hazard: "
               << boolString(capabilities.transCoexecutionHazard) << '\n';
  llvm::outs() << "wmma_coexecution_hazard: "
               << boolString(capabilities.wmmaCoexecutionHazard) << '\n';
  llvm::outs() << "scratch_base_forwarding_hazard: "
               << boolString(capabilities.scratchBaseForwardingHazard) << '\n';
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

static std::optional<AMDGPUTarget> parseTarget() {
  AMDGPUTarget target;
  target.triple = "amdgcn-amd-amdhsa";
  target.chip = chip;
  target.isa = llvm::AMDGPU::getIsaVersion(chip);
  target.kind = llvm::AMDGPU::parseArchAMDGCN(chip);
  if (target.kind == llvm::AMDGPU::GK_NONE || target.isa.Major == 0)
    return std::nullopt;
  return target;
}

static int reportScheduleModel(const AMDGPUTarget &target,
                               const llvm::MCSubtargetInfo &sti,
                               std::string &error) {
  llvm::Triple triple(target.triple);
  const llvm::Target *llvmTarget =
      llvm::TargetRegistry::lookupTarget(triple, error);
  if (!llvmTarget) {
    llvm::errs() << error << '\n';
    return 1;
  }
  std::unique_ptr<llvm::MCInstrInfo> mcii(llvmTarget->createMCInstrInfo());
  if (!mcii) {
    llvm::errs() << "failed to create AMDGPU instruction info\n";
    return 1;
  }
  llvm::SmallVector<ClassSchedule> schedules;
  if (!queryClassSchedules(sti, *mcii, schedules, error)) {
    llvm::errs() << error << '\n';
    return 1;
  }
  if (json)
    printScheduleModelJSON(chip, sti.getSchedModel(), schedules);
  else
    printScheduleModelText(chip, sti.getSchedModel(), schedules);
  return 0;
}

static int reportCapabilities(const llvm::MCSubtargetInfo &sti) {
  if (json) {
    llvm::errs() << "--json requires --schedule-model\n";
    return 1;
  }
  std::optional<AMDGPUTargetCapabilities> capabilities =
      getAMDGPUTargetCapabilities(sti);
  if (!capabilities) {
    llvm::errs() << "no Wave capability contract for target: " << chip << '\n';
    return 1;
  }
  printCapabilities(*capabilities);
  return 0;
}

int main(int argc, char **argv) {
  llvm::InitLLVM x(argc, argv);
  llvm::cl::ParseCommandLineOptions(argc, argv,
                                    "Print Wave AMDGPU target facts.\n");

  std::optional<AMDGPUTarget> target = parseTarget();
  if (!target) {
    llvm::errs() << "unsupported AMDGPU processor: " << chip << '\n';
    return 1;
  }
  std::string error;
  std::unique_ptr<llvm::MCSubtargetInfo> sti =
      createAMDGPUMCSubtargetInfo(*target, &error);
  if (!sti) {
    llvm::errs() << error << '\n';
    return 1;
  }
  if (scheduleModel)
    return reportScheduleModel(*target, *sti, error);
  return reportCapabilities(*sti);
}
