// RUN: wave-opt --waveamd-cross-lane-peepholes %s | FileCheck %s

// gfx1250 has permlane16_swap, not the permlane32_swap needed here.
// CHECK-LABEL: func.func @gfx1250_keeps_generic_exchange
// CHECK-NOT: waveamdmachine.v_permlane32_swap_b32_tuple
// CHECK: waveamdmachine.ds_bpermute_b32
// CHECK: waveamdmachine.ds_bpermute_b32
// CHECK: waveamdmachine.v_cndmask_b32_tuple
// CHECK: waveamdmachine.ds_bpermute_b32
// CHECK: waveamdmachine.ds_bpermute_b32
// CHECK: waveamdmachine.v_cndmask_b32_tuple
// CHECK: return
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1250"} {
func.func @gfx1250_keeps_generic_exchange(
    %a: !waveamdmachine.reg<vgpr, 1>,
    %b: !waveamdmachine.reg<vgpr, 1>)
    -> !waveamdmachine.reg<vgpr, 2>
    attributes {wave.workgroup_size = array<i32: 64, 1, 1>} {
  %workitem = waveamdmachine.v_workitem_id_x
      : !waveamdmachine.reg<vgpr, 1, 0>
  %c31 = waveamdmachine.imm 31 : !waveamdmachine.imm
  %local = waveamdmachine.v_and_b32 %workitem, %c31
      : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.imm)
      -> !waveamdmachine.reg<vgpr, 1>
  %c2 = waveamdmachine.imm 2 : !waveamdmachine.imm
  %lower_addr = waveamdmachine.v_lshlrev_b32 %local, %c2
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
      -> !waveamdmachine.reg<vgpr, 1>
  %a_lower = waveamdmachine.ds_bpermute_b32 %lower_addr, %a
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
      -> !waveamdmachine.reg<vgpr, 1>
  %b_lower = waveamdmachine.ds_bpermute_b32 %lower_addr, %b
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
      -> !waveamdmachine.reg<vgpr, 1>
  %c5 = waveamdmachine.imm 5 : !waveamdmachine.imm
  %half = waveamdmachine.v_lshrrev_b32 %workitem, %c5
      : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.imm)
      -> !waveamdmachine.reg<vgpr, 1>
  %c1 = waveamdmachine.imm 1 : !waveamdmachine.imm
  %one = waveamdmachine.s_mov_b32_value %c1
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1>
  %condition, %vcc = waveamdmachine.v_cmp_eq_u32_vcc %half, %one
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
      -> (!waveamdmachine.reg<sgpr, 2>, !waveamdmachine.reg<vcc, 1>)
  %lower = waveamdmachine.v_cndmask_b32_tuple
      %a_lower, %b_lower, %condition
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 2>) -> !waveamdmachine.reg<vgpr, 1>
  %c32 = waveamdmachine.imm 32 : !waveamdmachine.imm
  %upper_lane = waveamdmachine.v_add_u32 %local, %c32
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
      -> !waveamdmachine.reg<vgpr, 1>
  %upper_addr = waveamdmachine.v_lshlrev_b32 %upper_lane, %c2
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
      -> !waveamdmachine.reg<vgpr, 1>
  %a_upper = waveamdmachine.ds_bpermute_b32 %upper_addr, %a
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
      -> !waveamdmachine.reg<vgpr, 1>
  %b_upper = waveamdmachine.ds_bpermute_b32 %upper_addr, %b
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
      -> !waveamdmachine.reg<vgpr, 1>
  %upper = waveamdmachine.v_cndmask_b32_tuple
      %a_upper, %b_upper, %condition
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 2>) -> !waveamdmachine.reg<vgpr, 1>
  %result = waveamdmachine.tuple_from_elements %lower, %upper
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
      -> !waveamdmachine.reg<vgpr, 2>
  return %result : !waveamdmachine.reg<vgpr, 2>
}
}
