// RUN: wave-translate --wave-to-amdgpu-asm %s | FileCheck %s
// RUN: wave-translate --wave-to-amdgpu-asm %s | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx803 -filetype=obj -o /dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx803"} {
// CHECK: .amdgcn_target "amdgcn-amd-amdhsa--gfx803"

// CHECK-LABEL: legacy_vcc_ops:
func.func @legacy_vcc_ops(%a: !waveamdmachine.reg<vgpr, 1, 0>,
                          %b: !waveamdmachine.reg<vgpr, 1, 1>,
                          %c: !waveamdmachine.reg<vgpr, 1, 2>)
    -> !waveamdmachine.reg<sgpr, 1, 4> {
  // CHECK: v_add_u32
  %sum, %vcc0 = waveamdmachine.v_add_u32_vcc %a, %b
      : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.reg<vgpr, 1, 1>)
        -> (!waveamdmachine.reg<vgpr, 1, 3>, !waveamdmachine.reg<vcc, 1>)
  // CHECK: v_cmp_lt_u32
  // CHECK: s_mov_b32 s4, vcc_lo
  %mask, %vcc1 = waveamdmachine.v_cmp_lt_u32_vcc %sum, %c
      : (!waveamdmachine.reg<vgpr, 1, 3>, !waveamdmachine.reg<vgpr, 1, 2>)
        -> (!waveamdmachine.reg<sgpr, 1, 4>, !waveamdmachine.reg<vcc, 1>)
  return %mask : !waveamdmachine.reg<sgpr, 1, 4>
}

}
