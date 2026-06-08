// RUN: wave-translate --wave-to-amdgpu-asm %s | FileCheck %s --check-prefix=ASM
// RUN: wave-translate --wave-to-amdgpu-asm %s | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx1100 -filetype=obj -o /dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// ASM-LABEL: sadd64u32:
// ASM: s_add_u32 s4, s0, s2
// ASM: s_addc_u32 s5, s1, 0
func.func @sadd64u32(%base: !waveamdmachine.reg<sgpr, 2, 0>,
                     %offset: !waveamdmachine.reg<sgpr, 1, 2>,
                     %data: !waveamdmachine.reg<vgpr, 1, 8>) {
  %sum, %scc = waveamdmachine.s_add_u64_u32 %base, %offset
      : (!waveamdmachine.reg<sgpr, 2, 0>, !waveamdmachine.reg<sgpr, 1, 2>)
        -> (!waveamdmachine.reg<sgpr, 2, 4>, !waveamdmachine.reg<scc, 1>)
  %addr = waveamdmachine.v_mov_b32_tuple %sum
      : (!waveamdmachine.reg<sgpr, 2, 4>) -> !waveamdmachine.reg<vgpr, 2, 6>
  %token = waveamdmachine.global_store_b32_addr64 %addr, %data
      : (!waveamdmachine.reg<vgpr, 2, 6>, !waveamdmachine.reg<vgpr, 1, 8>)
        -> !waveamdmachine.mem.token
  return
}

}
