//===-- WaveAMDMachineTargetEnums.td - AMDGPU target enums ------*- tablegen -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef MLIR_DIALECT_WAVEAMDMACHINE_IR_WAVEAMDMACHINETARGETENUMS_TD
#define MLIR_DIALECT_WAVEAMDMACHINE_IR_WAVEAMDMACHINETARGETENUMS_TD

include "mlir/IR/EnumAttr.td"

def WaveAMDMachine_WaitCounterFamilyLegacy :
    I32EnumCase<"Legacy", 0, "legacy">;
def WaveAMDMachine_WaitCounterFamilyGfx12Split :
    I32EnumCase<"Gfx12Split", 1, "gfx12_split">;

def WaveAMDMachine_WaitCounterFamilyEnum :
    I32Enum<"WaitCounterFamily", "AMDGPU wait-counter family", [
      WaveAMDMachine_WaitCounterFamilyLegacy,
      WaveAMDMachine_WaitCounterFamilyGfx12Split
    ]> {
  let cppNamespace = "::mlir::waveamdmachine";
}

def WaveAMDMachine_MatrixFamilyNone :
    I32EnumCase<"None", 0, "none">;
def WaveAMDMachine_MatrixFamilyGfx1250 :
    I32EnumCase<"Gfx1250", 1, "gfx1250">;
def WaveAMDMachine_MatrixFamilyGfx1251 :
    I32EnumCase<"Gfx1251", 2, "gfx1251">;

def WaveAMDMachine_MatrixFamilyEnum :
    I32Enum<"MatrixFamily", "AMDGPU matrix family", [
      WaveAMDMachine_MatrixFamilyNone,
      WaveAMDMachine_MatrixFamilyGfx1250,
      WaveAMDMachine_MatrixFamilyGfx1251
    ]> {
  let cppNamespace = "::mlir::waveamdmachine";
}

def WaveAMDMachine_ExpertCounterVaRead :
    I32EnumCase<"VaRead", 0, "va_read">;
def WaveAMDMachine_ExpertCounterVaWrite :
    I32EnumCase<"VaWrite", 1, "va_write">;
def WaveAMDMachine_ExpertCounterVmSource :
    I32EnumCase<"VmSource", 2, "vm_source">;

def WaveAMDMachine_ExpertCounterEnum :
    I32Enum<"ExpertCounter", "AMDGPU expert scheduling counter", [
      WaveAMDMachine_ExpertCounterVaRead,
      WaveAMDMachine_ExpertCounterVaWrite,
      WaveAMDMachine_ExpertCounterVmSource
    ]> {
  let cppNamespace = "::mlir::waveamdmachine";
}

def WaveAMDMachine_ExpertEventNone :
    I32BitEnumCaseNone<"None", "none">;
def WaveAMDMachine_ExpertEventCSMACC :
    I32BitEnumCaseBit<"CSMACC", 0, "csmacc">;
def WaveAMDMachine_ExpertEventDPMACC :
    I32BitEnumCaseBit<"DPMACC", 1, "dpmacc">;
def WaveAMDMachine_ExpertEventTrans :
    I32BitEnumCaseBit<"Trans", 2, "trans">;
def WaveAMDMachine_ExpertEventXdl :
    I32BitEnumCaseBit<"Xdl", 3, "xdl">;
def WaveAMDMachine_ExpertEventLds :
    I32BitEnumCaseBit<"Lds", 4, "lds">;
def WaveAMDMachine_ExpertEventFlat :
    I32BitEnumCaseBit<"Flat", 5, "flat">;
def WaveAMDMachine_ExpertEventVmem :
    I32BitEnumCaseBit<"Vmem", 6, "vmem">;

def WaveAMDMachine_ExpertEventEnum :
    I32BitEnum<"ExpertEvent", "AMDGPU expert scheduling event", [
      WaveAMDMachine_ExpertEventNone,
      WaveAMDMachine_ExpertEventCSMACC,
      WaveAMDMachine_ExpertEventDPMACC,
      WaveAMDMachine_ExpertEventTrans,
      WaveAMDMachine_ExpertEventXdl,
      WaveAMDMachine_ExpertEventLds,
      WaveAMDMachine_ExpertEventFlat,
      WaveAMDMachine_ExpertEventVmem
    ]> {
  let cppNamespace = "::mlir::waveamdmachine";
}

#endif // MLIR_DIALECT_WAVEAMDMACHINE_IR_WAVEAMDMACHINETARGETENUMS_TD
