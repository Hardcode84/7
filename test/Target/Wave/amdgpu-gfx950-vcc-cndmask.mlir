// RUN: wave-opt --waveamd-machine-cleanup %s | wave-translate --wave-to-amdgpu-asm - | FileCheck %s
// RUN: wave-opt --waveamd-machine-cleanup %s | wave-translate --wave-to-amdgpu-asm - | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx950 -filetype=obj -o /dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
// CHECK-LABEL: shared_mask_tuple_cndmask_cleanup:
func.func @shared_mask_tuple_cndmask_cleanup(
    %a: !waveamdmachine.reg<vgpr, 1, 0>,
    %b: !waveamdmachine.reg<vgpr, 1, 1>,
    %false0: !waveamdmachine.reg<vgpr, 1, 2>,
    %true0: !waveamdmachine.reg<vgpr, 1, 3>,
    %false1: !waveamdmachine.reg<vgpr, 1, 4>,
    %true1: !waveamdmachine.reg<vgpr, 1, 5>)
    -> (!waveamdmachine.reg<vgpr, 1, 6>, !waveamdmachine.reg<vgpr, 1, 7>) {
  // CHECK: v_cmp_lt_i32_e64 vcc, v0, v1
  // CHECK-NOT: s_mov_b64
  // CHECK: v_cndmask_b32_e32 v6, v2, v3, vcc
  // CHECK-NEXT: v_cndmask_b32_e32 v7, v4, v5, vcc
  %mask, %vcc = waveamdmachine.v_cmp_lt_i32_vcc %a, %b
      : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.reg<vgpr, 1, 1>)
        -> (!waveamdmachine.reg<sgpr, 2, 4>, !waveamdmachine.reg<vcc, 1>)
  %selected0 = waveamdmachine.v_cndmask_b32_tuple %false0, %true0, %mask
      : (!waveamdmachine.reg<vgpr, 1, 2>, !waveamdmachine.reg<vgpr, 1, 3>,
         !waveamdmachine.reg<sgpr, 2, 4>) -> !waveamdmachine.reg<vgpr, 1, 6>
  %selected1 = waveamdmachine.v_cndmask_b32_tuple %false1, %true1, %mask
      : (!waveamdmachine.reg<vgpr, 1, 4>, !waveamdmachine.reg<vgpr, 1, 5>,
         !waveamdmachine.reg<sgpr, 2, 4>) -> !waveamdmachine.reg<vgpr, 1, 7>
  return %selected0, %selected1
      : !waveamdmachine.reg<vgpr, 1, 6>, !waveamdmachine.reg<vgpr, 1, 7>
}
}
