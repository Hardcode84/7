// RUN: split-file %s %t
// RUN: wave-opt %t/single.mlir --canonicalize -o %t/clean.mlir
// RUN: wave-translate %t/clean.mlir --wave-to-amdgpu-asm | FileCheck %s --check-prefix=ASM
// RUN: wave-translate %t/clean.mlir --wave-to-amdgpu-asm | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx1100 -filetype=obj -o /dev/null
// RUN: not wave-opt %t/live.mlir --waveamd-prepare-regalloc 2>&1 | FileCheck %s --check-prefix=LIVE
// RUN: wave-translate %t/live.mlir --wave-to-amdgpu-asm | FileCheck %s --check-prefix=LIVEASM

// LIVEASM-LABEL: live:
// LIVEASM: s_mov_b32
// LIVEASM: s_endpgm
// ASM-LABEL: single:
// ASM: s_endpgm
// LIVE: 'waveamdmachine.materialization_variants' op must be resolved before register allocation

//--- single.mlir
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
  func.func @single() attributes {wave.kernel} {
    %one = waveamdmachine.imm 1 : !waveamdmachine.imm
    %x = waveamdmachine.s_mov_b32_value %one : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1>
    %inner = waveamdmachine.materialization_variants %x : !waveamdmachine.reg<sgpr, 1>
    %choice = waveamdmachine.materialization_variants %inner, %x, %inner : !waveamdmachine.reg<sgpr, 1>
    waveamdmachine.s_mov_b32 "s0", %choice : (!waveamdmachine.reg<sgpr, 1>) -> ()
    waveamdmachine.s_endpgm
    return
  }
}

//--- live.mlir
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
  func.func @live() attributes {wave.kernel} {
    %one = waveamdmachine.imm 1 : !waveamdmachine.imm
    %x = waveamdmachine.s_mov_b32_value %one : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1>
    %y = waveamdmachine.s_mov_b32_value %x : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<sgpr, 1>
    %choice = waveamdmachine.materialization_variants %x, %y : !waveamdmachine.reg<sgpr, 1>
    waveamdmachine.s_mov_b32 "s0", %choice : (!waveamdmachine.reg<sgpr, 1>) -> ()
    waveamdmachine.s_endpgm
    return
  }
}
