//===-- WaveAMDMachineWaitEnums.td - wait enums -------------*- tablegen -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef MLIR_DIALECT_WAVEAMDMACHINE_IR_WAVEAMDMACHINEWAITENUMS_TD
#define MLIR_DIALECT_WAVEAMDMACHINE_IR_WAVEAMDMACHINEWAITENUMS_TD

include "mlir/IR/EnumAttr.td"

def WaveAMDMachine_WaitcntCounterNone :
    I32EnumCase<"None", 0, "none">;
def WaveAMDMachine_WaitcntCounterVmem :
    I32EnumCase<"Vmem", 1, "vmem">;
def WaveAMDMachine_WaitcntCounterLgkm :
    I32EnumCase<"Lgkm", 2, "lgkm">;
def WaveAMDMachine_WaitcntCounterVscnt :
    I32EnumCase<"Vscnt", 3, "vscnt">;
def WaveAMDMachine_WaitcntCounterLoad :
    I32EnumCase<"Load", 4, "load">;
def WaveAMDMachine_WaitcntCounterStore :
    I32EnumCase<"Store", 5, "store">;
def WaveAMDMachine_WaitcntCounterDs :
    I32EnumCase<"Ds", 6, "ds">;
def WaveAMDMachine_WaitcntCounterKm :
    I32EnumCase<"Km", 7, "km">;
def WaveAMDMachine_WaitcntCounterX :
    I32EnumCase<"X", 8, "x">;
def WaveAMDMachine_WaitcntCounterTensor :
    I32EnumCase<"Tensor", 9, "tensor">;
def WaveAMDMachine_WaitcntCounterAsync :
    I32EnumCase<"Async", 10, "async">;

def WaveAMDMachine_WaitcntCounterEnum :
    I32Enum<"WaitcntCounter", "AMDGPU physical wait counter", [
      WaveAMDMachine_WaitcntCounterNone,
      WaveAMDMachine_WaitcntCounterVmem,
      WaveAMDMachine_WaitcntCounterLgkm,
      WaveAMDMachine_WaitcntCounterVscnt,
      WaveAMDMachine_WaitcntCounterLoad,
      WaveAMDMachine_WaitcntCounterStore,
      WaveAMDMachine_WaitcntCounterDs,
      WaveAMDMachine_WaitcntCounterKm,
      WaveAMDMachine_WaitcntCounterX,
      WaveAMDMachine_WaitcntCounterTensor,
      WaveAMDMachine_WaitcntCounterAsync
    ]> {
  let cppNamespace = "::mlir::waveamdmachine";
}

def WaveAMDMachine_WaitcntEventNone :
    I32BitEnumCaseNone<"None", "none">;
def WaveAMDMachine_WaitcntEventVmem :
    I32BitEnumCaseBit<"Vmem", 0, "vmem">;
def WaveAMDMachine_WaitcntEventVmemStore :
    I32BitEnumCaseBit<"VmemStore", 1, "vmem_store">;
def WaveAMDMachine_WaitcntEventLds :
    I32BitEnumCaseBit<"Lds", 2, "lds">;
def WaveAMDMachine_WaitcntEventSmem :
    I32BitEnumCaseBit<"Smem", 3, "smem">;
def WaveAMDMachine_WaitcntEventFlat :
    I32BitEnumCaseBit<"Flat", 4, "flat">;
def WaveAMDMachine_WaitcntEventGds :
    I32BitEnumCaseBit<"Gds", 5, "gds">;
def WaveAMDMachine_WaitcntEventMessage :
    I32BitEnumCaseBit<"Message", 6, "message">;
def WaveAMDMachine_WaitcntEventScratchStore :
    I32BitEnumCaseBit<"ScratchStore", 7, "scratch_store">;
def WaveAMDMachine_WaitcntEventAsync :
    I32BitEnumCaseBit<"Async", 8, "async">;
def WaveAMDMachine_WaitcntEventTensor :
    I32BitEnumCaseBit<"Tensor", 9, "tensor">;

def WaveAMDMachine_WaitcntEventEnum :
    I32BitEnum<"WaitcntEvent", "AMDGPU semantic wait event", [
      WaveAMDMachine_WaitcntEventNone,
      WaveAMDMachine_WaitcntEventVmem,
      WaveAMDMachine_WaitcntEventVmemStore,
      WaveAMDMachine_WaitcntEventLds,
      WaveAMDMachine_WaitcntEventSmem,
      WaveAMDMachine_WaitcntEventFlat,
      WaveAMDMachine_WaitcntEventGds,
      WaveAMDMachine_WaitcntEventMessage,
      WaveAMDMachine_WaitcntEventScratchStore,
      WaveAMDMachine_WaitcntEventAsync,
      WaveAMDMachine_WaitcntEventTensor
    ]> {
  let cppNamespace = "::mlir::waveamdmachine";
}

#endif // MLIR_DIALECT_WAVEAMDMACHINE_IR_WAVEAMDMACHINEWAITENUMS_TD
