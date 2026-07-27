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

#endif // MLIR_DIALECT_WAVEAMDMACHINE_IR_WAVEAMDMACHINETARGETENUMS_TD
