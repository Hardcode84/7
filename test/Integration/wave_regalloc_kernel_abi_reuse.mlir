// RUN: wave-opt --waveamd-reg-alloc --waveamd-resource-info %s \
// RUN:   | env WAVE_PIPELINES_DIR=%S/../Target/Wave/Inputs/emit-only-pipeline wave-translate --wave-to-amdgpu-asm - \
// RUN:   | FileCheck %s --check-prefix=ASM
// RUN: wave-opt --waveamd-reg-alloc --waveamd-resource-info %s \
// RUN:   | env WAVE_PIPELINES_DIR=%S/../Target/Wave/Inputs/emit-only-pipeline wave-translate --wave-to-amdgpu-asm - \
// RUN:   | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx950 -filetype=obj -o /dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// ASM-LABEL: regalloc_kernel_abi_reuse:
// ASM: s_load_dwordx2 s[2:3], s[0:1], 0x0
// ASM: s_mov_b32 s0, 0
// ASM: v_mov_b32_e32 {{v[0-9]+}}, s0
// ASM: global_store_dword {{v[0-9]+}}, {{v[0-9]+}}, s[2:3]
// ASM: s_endpgm
func.func @regalloc_kernel_abi_reuse() attributes {wave.kernel} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %base = waveamdmachine.s_load_b64 %zero, "s[0:1]"
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 2>
  %late = waveamdmachine.s_mov_b32_value %zero
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1>
  %offset = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %value = waveamdmachine.v_mov_b32_tuple %late {registers = 1 : i64}
      : (!waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %token = waveamdmachine.global_store_b32 %offset, %value, %base
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 2>) -> !waveamdmachine.mem.token
  waveamdmachine.s_endpgm
  return
}

}
