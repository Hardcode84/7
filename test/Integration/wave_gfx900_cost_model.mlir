// SPDX-FileCopyrightText: 2026 wave-mlir contributors
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
// RUN: not wave-translate --wave-to-amdgpu-asm %s 2>&1 | FileCheck %s --check-prefix=ERROR
// RUN: not wave-opt --waveamd-mfma-packed-peephole %s 2>&1 | FileCheck %s --check-prefix=ERROR
// RUN: env WAVE_PIPELINE_ENTRY_POINT=waveamd_backend_emit_only wave-translate --wave-to-amdgpu-asm %s > %t.s
// RUN: FileCheck %s --check-prefix=ASM < %t.s
// RUN: llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx900 -filetype=obj %t.s -o %t.o

// ERROR: waveamd-mfma-packed-peephole requires a cost model for ISA 9.0.0

// ASM-LABEL: mul_lo_left:
// ASM: v_mul_lo_u32
// ASM-LABEL: mul_lo_right:
// ASM: v_mul_lo_u32
// ASM-LABEL: mul_hi_left:
// ASM: v_mul_hi_u32
// ASM-LABEL: mul_hi_right:
// ASM: v_mul_hi_u32

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx900"} {
func.func @mul_lo_left(%v: !waveamdmachine.reg<vgpr, 1, 0>) -> !waveamdmachine.reg<vgpr, 1, 1> {
  %imm = waveamdmachine.imm 1024 : !waveamdmachine.imm
  %r = waveamdmachine.v_mul_lo_u32 %imm, %v : (!waveamdmachine.imm, !waveamdmachine.reg<vgpr, 1, 0>) -> !waveamdmachine.reg<vgpr, 1, 1>
  return %r : !waveamdmachine.reg<vgpr, 1, 1>
}
func.func @mul_lo_right(%v: !waveamdmachine.reg<vgpr, 1, 0>) -> !waveamdmachine.reg<vgpr, 1, 1> {
  %imm = waveamdmachine.imm 1024 : !waveamdmachine.imm
  %r = waveamdmachine.v_mul_lo_u32 %v, %imm : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1, 1>
  return %r : !waveamdmachine.reg<vgpr, 1, 1>
}
func.func @mul_hi_left(%v: !waveamdmachine.reg<vgpr, 1, 0>) -> !waveamdmachine.reg<vgpr, 1, 1> {
  %imm = waveamdmachine.imm 1024 : !waveamdmachine.imm
  %r = waveamdmachine.v_mul_hi_u32 %imm, %v : (!waveamdmachine.imm, !waveamdmachine.reg<vgpr, 1, 0>) -> !waveamdmachine.reg<vgpr, 1, 1>
  return %r : !waveamdmachine.reg<vgpr, 1, 1>
}
func.func @mul_hi_right(%v: !waveamdmachine.reg<vgpr, 1, 0>) -> !waveamdmachine.reg<vgpr, 1, 1> {
  %imm = waveamdmachine.imm 1024 : !waveamdmachine.imm
  %r = waveamdmachine.v_mul_hi_u32 %v, %imm : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1, 1>
  return %r : !waveamdmachine.reg<vgpr, 1, 1>
}
}
