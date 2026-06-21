// RUN: wave-opt --waveamd-reg-alloc %s | FileCheck %s --check-prefix=REGALLOC
// RUN: wave-opt --waveamd-reg-alloc %s | wave-translate --wave-to-amdgpu-asm - | FileCheck %s --check-prefix=ASM
// RUN: wave-opt --waveamd-reg-alloc %s | wave-translate --wave-to-amdgpu-asm - | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx950 -filetype=obj -o /dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// REGALLOC-LABEL: func.func @preloaded_sgpr2_to_vgpr2
// REGALLOC: %[[ARG:.*]] = waveamdmachine.kernarg_preload {dword_offset = 0 : i64} : !waveamdmachine.reg<sgpr, 2, 2>
// REGALLOC-NOT: waveamdmachine.tuple_to_elements %[[ARG]]
// REGALLOC: waveamdmachine.v_mov_b32_tuple %[[ARG]] : (!waveamdmachine.reg<sgpr, 2, 2>) -> !waveamdmachine.reg<vgpr, 2,
// ASM-LABEL: preloaded_sgpr2_to_vgpr2:
// ASM: v_mov_b32_e32 v0, s2
// ASM-NEXT: v_mov_b32_e32 v1, s3
// ASM: global_store_dword v[0:1],
func.func @preloaded_sgpr2_to_vgpr2(%out: !wave.ptr<#wave.global, i32>)
    attributes {wave.kernel, waveamdmachine.kernarg_preload_length = 2 : i64} {
  %arg = waveamdmachine.kernarg_preload {dword_offset = 0 : i64}
      : !waveamdmachine.reg<sgpr, 2, 2>
  %copy = waveamdmachine.v_mov_b32_tuple %arg
      : (!waveamdmachine.reg<sgpr, 2, 2>) -> !waveamdmachine.reg<vgpr, 2>
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %value = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %token = waveamdmachine.global_store_b32_addr64 %copy, %value
      : (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vgpr, 1>)
        -> !waveamdmachine.mem.token
  waveamdmachine.s_endpgm
  return
}

}
