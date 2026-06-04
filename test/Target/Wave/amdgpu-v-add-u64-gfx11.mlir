// RUN: wave-translate --wave-to-amdgpu-asm %s | FileCheck %s --check-prefix=ASM
// RUN: wave-translate --wave-to-amdgpu-asm %s | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx1100 -filetype=obj -o /dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// ASM-LABEL: add64:
// ASM: v_add_co_u32 v4, vcc_lo, v0, v2
// ASM: v_add_co_ci_u32_e64 v5, vcc_lo, v1, v3, vcc_lo
func.func @add64(%x: !waveamdmachine.reg<vgpr, 2, 0>,
                 %y: !waveamdmachine.reg<vgpr, 2, 2>,
                 %data: !waveamdmachine.reg<vgpr, 1, 6>) {
  %sum, %vcc = waveamdmachine.v_add_u64 %x, %y
      : (!waveamdmachine.reg<vgpr, 2, 0>, !waveamdmachine.reg<vgpr, 2, 2>)
        -> (!waveamdmachine.reg<vgpr, 2, 4>, !waveamdmachine.reg<vcc, 1>)
  %token = waveamdmachine.global_store_b32_addr64 %sum, %data
      : (!waveamdmachine.reg<vgpr, 2, 4>, !waveamdmachine.reg<vgpr, 1, 6>)
        -> !waveamdmachine.mem.token
  return
}

}
