// RUN: wave-translate --wave-to-amdgpu-asm %s | FileCheck %s
// RUN: wave-translate --wave-to-amdgpu-asm %s | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx803 -filetype=obj -o /dev/null
// RUN: wave-opt --waveamd-machine-cleanup %s | wave-translate --wave-to-amdgpu-asm - | FileCheck %s --check-prefix=CLEANUP

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
  %vcc1 = waveamdmachine.v_cmp_lt_u32_vcc %sum, %c
      : (!waveamdmachine.reg<vgpr, 1, 3>, !waveamdmachine.reg<vgpr, 1, 2>)
        -> !waveamdmachine.reg<vcc, 1>
  %mask = waveamdmachine.s_read_vcc_b32 %vcc1
      : (!waveamdmachine.reg<vcc, 1>) -> !waveamdmachine.reg<sgpr, 1, 4>
  return %mask : !waveamdmachine.reg<sgpr, 1, 4>
}

// CHECK-LABEL: legacy_signed_vcc_cmp:
func.func @legacy_signed_vcc_cmp(%a: !waveamdmachine.reg<vgpr, 1, 0>,
                                 %b: !waveamdmachine.reg<vgpr, 1, 1>)
    -> !waveamdmachine.reg<sgpr, 1, 5> {
  // CHECK: v_cmp_lt_i32
  // CHECK: s_mov_b32 s5, vcc_lo
  %vcc = waveamdmachine.v_cmp_lt_i32_vcc %a, %b
      : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.reg<vgpr, 1, 1>)
        -> !waveamdmachine.reg<vcc, 1>
  %signed_mask = waveamdmachine.s_read_vcc_b32 %vcc
      : (!waveamdmachine.reg<vcc, 1>) -> !waveamdmachine.reg<sgpr, 1, 5>
  return %signed_mask : !waveamdmachine.reg<sgpr, 1, 5>
}

// CHECK-LABEL: legacy_vcc_cndmask:
func.func @legacy_vcc_cndmask(%a: !waveamdmachine.reg<vgpr, 1, 0>,
                              %b: !waveamdmachine.reg<vgpr, 1, 1>,
                              %false: !waveamdmachine.reg<vgpr, 1, 2>,
                              %true: !waveamdmachine.reg<vgpr, 1, 3>)
    -> !waveamdmachine.reg<vgpr, 1, 4> {
  // CHECK: v_cmp_lt_u32_e64 vcc, v0, v1
  // CHECK-NOT: s_mov_b64
  // CHECK: v_cndmask_b32_e32 v4, v2, v3, vcc
  %vcc = waveamdmachine.v_cmp_lt_u32_vcc %a, %b
      : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.reg<vgpr, 1, 1>)
        -> !waveamdmachine.reg<vcc, 1>
  %selected = waveamdmachine.v_cndmask_b32_vcc %false, %true, %vcc
      : (!waveamdmachine.reg<vgpr, 1, 2>, !waveamdmachine.reg<vgpr, 1, 3>,
         !waveamdmachine.reg<vcc, 1>) -> !waveamdmachine.reg<vgpr, 1, 4>
  return %selected : !waveamdmachine.reg<vgpr, 1, 4>
}

// CLEANUP-LABEL: legacy_tuple_cndmask_cleanup:
func.func @legacy_tuple_cndmask_cleanup(%a: !waveamdmachine.reg<vgpr, 1, 0>,
                                        %b: !waveamdmachine.reg<vgpr, 1, 1>,
                                        %false: !waveamdmachine.reg<vgpr, 1, 2>,
                                        %true: !waveamdmachine.reg<vgpr, 1, 3>)
    -> !waveamdmachine.reg<vgpr, 1, 4> {
  // CLEANUP: v_cmp_lt_u32_e64 vcc, v0, v1
  // CLEANUP-NOT: s_mov_b64
  // CLEANUP: v_cndmask_b32_e32 v4, v2, v3, vcc
  %vcc = waveamdmachine.v_cmp_lt_u32_vcc %a, %b
      : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.reg<vgpr, 1, 1>)
        -> !waveamdmachine.reg<vcc, 1>
  %mask = waveamdmachine.s_read_vcc_b64 %vcc
      : (!waveamdmachine.reg<vcc, 1>) -> !waveamdmachine.reg<sgpr, 2, 4>
  %selected = waveamdmachine.v_cndmask_b32_tuple %false, %true, %mask
      : (!waveamdmachine.reg<vgpr, 1, 2>, !waveamdmachine.reg<vgpr, 1, 3>,
         !waveamdmachine.reg<sgpr, 2, 4>) -> !waveamdmachine.reg<vgpr, 1, 4>
  return %selected : !waveamdmachine.reg<vgpr, 1, 4>
}

}
