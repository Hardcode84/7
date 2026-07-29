//===- CostModelEnums.td - Wave AMDGPU cost-model enums --------*- tablegen -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef MLIR_DIALECT_WAVEAMDMACHINE_COSTMODEL_COSTMODELENUMS_TD
#define MLIR_DIALECT_WAVEAMDMACHINE_COSTMODEL_COSTMODELENUMS_TD

include "mlir/IR/EnumAttr.td"

def NoInst : I32EnumCase<"NoInst", 0, "NoInst">;
def WriteSALU : I32EnumCase<"WriteSALU", 1, "WriteSALU">;
def Write32Bit : I32EnumCase<"Write32Bit", 2, "Write32Bit">;
def Write64Bit : I32EnumCase<"Write64Bit", 3, "Write64Bit">;
def WriteFloatFMA : I32EnumCase<"WriteFloatFMA", 4, "WriteFloatFMA">;
def WriteDouble : I32EnumCase<"WriteDouble", 5, "WriteDouble">;
def WriteTrans32 : I32EnumCase<"WriteTrans32", 6, "WriteTrans32">;
def WriteSFPU : I32EnumCase<"WriteSFPU", 7, "WriteSFPU">;
def Write2PassMAI : I32EnumCase<"Write2PassMAI", 8, "Write2PassMAI">;
def Write4PassMAI : I32EnumCase<"Write4PassMAI", 9, "Write4PassMAI">;
def Write8PassMAI : I32EnumCase<"Write8PassMAI", 10, "Write8PassMAI">;
def Write16PassMAI : I32EnumCase<"Write16PassMAI", 11, "Write16PassMAI">;
def WriteXDL2PassWMMA :
    I32EnumCase<"WriteXDL2PassWMMA", 12, "WriteXDL2PassWMMA">;
def WriteXDL4PassWMMA :
    I32EnumCase<"WriteXDL4PassWMMA", 13, "WriteXDL4PassWMMA">;
def Write4PassWMMA :
    I32EnumCase<"Write4PassWMMA", 14, "Write4PassWMMA">;
def Write8PassWMMA :
    I32EnumCase<"Write8PassWMMA", 15, "Write8PassWMMA">;
def Write16PassWMMA :
    I32EnumCase<"Write16PassWMMA", 16, "Write16PassWMMA">;
def WriteVMEM : I32EnumCase<"WriteVMEM", 17, "WriteVMEM">;
def WriteSMEM : I32EnumCase<"WriteSMEM", 18, "WriteSMEM">;
def WriteLDS : I32EnumCase<"WriteLDS", 19, "WriteLDS">;
def WriteTDM : I32EnumCase<"WriteTDM", 20, "WriteTDM">;
def WriteBranch : I32EnumCase<"WriteBranch", 21, "WriteBranch">;
def WriteBarrier : I32EnumCase<"WriteBarrier", 22, "WriteBarrier">;
def WriteExport : I32EnumCase<"WriteExport", 23, "WriteExport">;
def WaitcntPseudo : I32EnumCase<"WaitcntPseudo", 24, "WaitcntPseudo">;
def NumSchedClasses :
    I32EnumCase<"NumSchedClasses", 25, "NumSchedClasses">;

def SchedClassEnum : I32Enum<"SchedClass", "AMDGPU scheduling class", [
  NoInst,
  WriteSALU,
  Write32Bit,
  Write64Bit,
  WriteFloatFMA,
  WriteDouble,
  WriteTrans32,
  WriteSFPU,
  Write2PassMAI,
  Write4PassMAI,
  Write8PassMAI,
  Write16PassMAI,
  WriteXDL2PassWMMA,
  WriteXDL4PassWMMA,
  Write4PassWMMA,
  Write8PassWMMA,
  Write16PassWMMA,
  WriteVMEM,
  WriteSMEM,
  WriteLDS,
  WriteTDM,
  WriteBranch,
  WriteBarrier,
  WriteExport,
  WaitcntPseudo,
  NumSchedClasses
]> {
  let cppNamespace = "::mlir::waveamdmachine";
}

def VALU : I32EnumCase<"VALU", 0, "VALU">;
def SALU : I32EnumCase<"SALU", 1, "SALU">;
def VMEM : I32EnumCase<"VMEM", 2, "VMEM">;
def LGKM : I32EnumCase<"LGKM", 3, "LGKM">;
def MFMA_XDL : I32EnumCase<"MFMA_XDL", 4, "MFMA_XDL">;
def TRANS : I32EnumCase<"TRANS", 5, "TRANS">;
def BRANCH : I32EnumCase<"BRANCH", 6, "BRANCH">;
def EXPORT : I32EnumCase<"EXPORT", 7, "EXPORT">;
def NoFunctionalUnit : I32EnumCase<"None", 8, "None">;
def NumFunctionalUnits :
    I32EnumCase<"NumFunctionalUnits", 9, "NumFunctionalUnits">;

def FunctionalUnitEnum :
    I32Enum<"FunctionalUnit", "AMDGPU functional unit", [
      VALU,
      SALU,
      VMEM,
      LGKM,
      MFMA_XDL,
      TRANS,
      BRANCH,
      EXPORT,
      NoFunctionalUnit,
      NumFunctionalUnits
    ]> {
  let cppNamespace = "::mlir::waveamdmachine";
}

def UnsupportedWaveIssueArbitration :
    I32EnumCase<"Unsupported", 0, "Unsupported">;
def RoundRobinWaveIssueArbitration :
    I32EnumCase<"RoundRobin", 1, "RoundRobin">;

def WaveIssueArbitrationEnum :
    I32Enum<"WaveIssueArbitration", "ready-wave issue arbitration", [
      UnsupportedWaveIssueArbitration,
      RoundRobinWaveIssueArbitration
    ]> {
  let cppNamespace = "::mlir::waveamdmachine";
}

def LLVMHWVALU : I32EnumCase<"HWVALU", 0, "HWVALU">;
def LLVMHWSALU : I32EnumCase<"HWSALU", 1, "HWSALU">;
def LLVMHWVMEM : I32EnumCase<"HWVMEM", 2, "HWVMEM">;
def LLVMHWLGKM : I32EnumCase<"HWLGKM", 3, "HWLGKM">;
def LLVMHWXDL : I32EnumCase<"HWXDL", 4, "HWXDL">;
def LLVMHWTransVALU :
    I32EnumCase<"HWTransVALU", 5, "HWTransVALU">;
def LLVMHWBranch : I32EnumCase<"HWBranch", 6, "HWBranch">;
def LLVMHWExport : I32EnumCase<"HWExport", 7, "HWExport">;
def LLVMHWRC : I32EnumCase<"HWRC", 8, "HWRC">;

def LLVMProcResourceEnum :
    I32Enum<"LLVMProcResource", "LLVM AMDGPU processor resource", [
      LLVMHWVALU,
      LLVMHWSALU,
      LLVMHWVMEM,
      LLVMHWLGKM,
      LLVMHWXDL,
      LLVMHWTransVALU,
      LLVMHWBranch,
      LLVMHWExport,
      LLVMHWRC
    ]> {
  let cppNamespace = "::mlir::waveamdmachine";
}

def MemoryCounterNone : I32EnumCase<"None", 0, "none">;
def MemoryCounterVmem : I32EnumCase<"Vmem", 1, "vmem">;
def MemoryCounterLgkm : I32EnumCase<"Lgkm", 2, "lgkm">;
def MemoryCounterVscnt : I32EnumCase<"Vscnt", 3, "vscnt">;
def MemoryCounterTensor : I32EnumCase<"Tensor", 4, "tensor">;
def MemoryCounterAsync : I32EnumCase<"Async", 5, "async">;

def MemoryCounterKindEnum :
    I32Enum<"MemoryCounterKind", "memory completion counter", [
      MemoryCounterNone,
      MemoryCounterVmem,
      MemoryCounterLgkm,
      MemoryCounterVscnt,
      MemoryCounterTensor,
      MemoryCounterAsync
    ]> {
  let cppNamespace = "::mlir::waveamdmachine";
}

def InstructionWaitCounterNone : I32EnumCase<"None", 0, "none">;
def InstructionWaitCounterVmem : I32EnumCase<"Vmem", 1, "vmem">;
def InstructionWaitCounterLgkm : I32EnumCase<"Lgkm", 2, "lgkm">;
def InstructionWaitCounterVscnt : I32EnumCase<"Vscnt", 3, "vscnt">;
def InstructionWaitCounterExpcnt : I32EnumCase<"Expcnt", 4, "expcnt">;
def InstructionWaitCounterTensor : I32EnumCase<"Tensor", 5, "tensor">;
def InstructionWaitCounterAsync : I32EnumCase<"Async", 6, "async">;

def InstructionWaitCounterKindEnum :
    I32Enum<"InstructionWaitCounterKind", "instruction wait counter", [
      InstructionWaitCounterNone,
      InstructionWaitCounterVmem,
      InstructionWaitCounterLgkm,
      InstructionWaitCounterVscnt,
      InstructionWaitCounterExpcnt,
      InstructionWaitCounterTensor,
      InstructionWaitCounterAsync
    ]> {
  let cppNamespace = "::mlir::waveamdmachine";
}

def InstructionEventNone : I32EnumCase<"None", 0, "none">;
def InstructionEventVmemLoad :
    I32EnumCase<"VmemLoad", 1, "vmem_load">;
def InstructionEventVmemStore :
    I32EnumCase<"VmemStore", 2, "vmem_store">;
def InstructionEventLdsDs : I32EnumCase<"LdsDs", 3, "lds_ds">;
def InstructionEventSmem : I32EnumCase<"Smem", 4, "smem">;
def InstructionEventMessage : I32EnumCase<"Message", 5, "message">;
def InstructionEventExport : I32EnumCase<"Export", 6, "export">;
def InstructionEventTensor : I32EnumCase<"Tensor", 7, "tensor">;
def InstructionEventAsync : I32EnumCase<"Async", 8, "async">;

def InstructionEventClassEnum :
    I32Enum<"InstructionEventClass", "instruction completion event class", [
      InstructionEventNone,
      InstructionEventVmemLoad,
      InstructionEventVmemStore,
      InstructionEventLdsDs,
      InstructionEventSmem,
      InstructionEventMessage,
      InstructionEventExport,
      InstructionEventTensor,
      InstructionEventAsync
    ]> {
  let cppNamespace = "::mlir::waveamdmachine";
}

#endif // MLIR_DIALECT_WAVEAMDMACHINE_COSTMODEL_COSTMODELENUMS_TD
