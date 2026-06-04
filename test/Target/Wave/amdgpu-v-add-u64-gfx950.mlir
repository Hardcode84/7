// RUN: wave-translate --wave-to-amdgpu-asm %s | FileCheck %s --check-prefix=ASM
// RUN: wave-translate --wave-to-amdgpu-asm %s | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx950 -filetype=obj -o /dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// ASM-LABEL: add64:
// ASM: v_add_co_u32_e64 v4, vcc, v0, v2
// ASM: v_addc_co_u32_e64 v5, vcc, v1, v3, vcc
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
