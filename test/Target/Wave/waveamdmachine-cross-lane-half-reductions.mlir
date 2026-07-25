// RUN: wave-opt --split-input-file --waveamd-cross-lane-peepholes %s | FileCheck %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// CHECK-LABEL: func.func @direct_add_bitop3_to_permlane
// CHECK-NOT: waveamdmachine.ds_bpermute_b32
// CHECK-NOT: waveamdmachine.v_lshlrev_b32
// CHECK: [[PAIR:%.*]] = waveamdmachine.v_mov_b32_tuple
// CHECK: [[SWAP:%.*]] = waveamdmachine.v_permlane32_swap_b32_tuple [[PAIR]]
// CHECK: [[WORDS:%.*]]:2 = waveamdmachine.tuple_to_elements [[SWAP]]
// CHECK: [[RESULT:%.*]] = waveamdmachine.v_add_f32 [[WORDS]]#0, [[WORDS]]#1
// CHECK: return [[RESULT]]
func.func @direct_add_bitop3_to_permlane(
    %data: !waveamdmachine.reg<vgpr, 1>)
    -> !waveamdmachine.reg<vgpr, 1>
    attributes {wave.workgroup_size = array<i32: 512, 1, 1>} {
  %workitem = waveamdmachine.v_workitem_id_x
      : !waveamdmachine.reg<vgpr, 1, 0>
  %c63 = waveamdmachine.imm 63 : !waveamdmachine.imm
  %c32 = waveamdmachine.imm 32 : !waveamdmachine.imm
  // (workitem & 63) ^ 32
  %other_lane = waveamdmachine.v_bitop3_b32 %workitem, %c63, %c32
      bitop3 106
      : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.imm,
         !waveamdmachine.imm)
      -> !waveamdmachine.reg<vgpr, 1>
  %c2 = waveamdmachine.imm 2 : !waveamdmachine.imm
  %other_addr = waveamdmachine.v_lshlrev_b32 %other_lane, %c2
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
      -> !waveamdmachine.reg<vgpr, 1>
  %other = waveamdmachine.ds_bpermute_b32 %other_addr, %data
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
      -> !waveamdmachine.reg<vgpr, 1>
  %result = waveamdmachine.v_add_f32 %data, %other
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
      -> !waveamdmachine.reg<vgpr, 1>
  return %result : !waveamdmachine.reg<vgpr, 1>
}

// CHECK-LABEL: func.func @direct_max_reversed_to_permlane
// CHECK-NOT: waveamdmachine.ds_bpermute_b32
// CHECK: [[PAIR:%.*]] = waveamdmachine.v_mov_b32_tuple
// CHECK: [[SWAP:%.*]] = waveamdmachine.v_permlane32_swap_b32_tuple [[PAIR]]
// CHECK: [[WORDS:%.*]]:2 = waveamdmachine.tuple_to_elements [[SWAP]]
// CHECK: [[RESULT:%.*]] = waveamdmachine.v_max_f32 [[WORDS]]#0, [[WORDS]]#1
// CHECK: return [[RESULT]]
func.func @direct_max_reversed_to_permlane(
    %data: !waveamdmachine.reg<vgpr, 1>)
    -> !waveamdmachine.reg<vgpr, 1>
    attributes {wave.workgroup_size = array<i32: 128, 1, 1>} {
  %workitem = waveamdmachine.v_workitem_id_x
      : !waveamdmachine.reg<vgpr, 1, 0>
  %c63 = waveamdmachine.imm 63 : !waveamdmachine.imm
  %lane = waveamdmachine.v_and_b32 %workitem, %c63
      : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.imm)
      -> !waveamdmachine.reg<vgpr, 1>
  %c32 = waveamdmachine.imm 32 : !waveamdmachine.imm
  %other_lane = waveamdmachine.v_xor_b32 %lane, %c32
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
      -> !waveamdmachine.reg<vgpr, 1>
  %c2 = waveamdmachine.imm 2 : !waveamdmachine.imm
  %other_addr = waveamdmachine.v_lshlrev_b32 %other_lane, %c2
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
      -> !waveamdmachine.reg<vgpr, 1>
  %other = waveamdmachine.ds_bpermute_b32 %other_addr, %data
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
      -> !waveamdmachine.reg<vgpr, 1>
  %result = waveamdmachine.v_max_f32 %other, %data
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
      -> !waveamdmachine.reg<vgpr, 1>
  return %result : !waveamdmachine.reg<vgpr, 1>
}

// CHECK-LABEL: func.func @bitop3_same_half_stays_bpermute
// CHECK-NOT: waveamdmachine.v_permlane32_swap_b32_tuple
// CHECK: waveamdmachine.v_bitop3_b32
// CHECK-SAME: bitop3 8
// CHECK: waveamdmachine.ds_bpermute_b32
// CHECK: waveamdmachine.v_add_f32
func.func @bitop3_same_half_stays_bpermute(
    %data: !waveamdmachine.reg<vgpr, 1>)
    -> !waveamdmachine.reg<vgpr, 1>
    attributes {wave.workgroup_size = array<i32: 512, 1, 1>} {
  %workitem = waveamdmachine.v_workitem_id_x
      : !waveamdmachine.reg<vgpr, 1, 0>
  %c63 = waveamdmachine.imm 63 : !waveamdmachine.imm
  %c32 = waveamdmachine.imm 32 : !waveamdmachine.imm
  // workitem & 31
  %same_half_lane = waveamdmachine.v_bitop3_b32 %c32, %workitem, %c63
      bitop3 8
      : (!waveamdmachine.imm, !waveamdmachine.reg<vgpr, 1, 0>,
         !waveamdmachine.imm)
      -> !waveamdmachine.reg<vgpr, 1>
  %c2 = waveamdmachine.imm 2 : !waveamdmachine.imm
  %addr = waveamdmachine.v_lshlrev_b32 %same_half_lane, %c2
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
      -> !waveamdmachine.reg<vgpr, 1>
  %permuted = waveamdmachine.ds_bpermute_b32 %addr, %data
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
      -> !waveamdmachine.reg<vgpr, 1>
  %result = waveamdmachine.v_add_f32 %data, %permuted
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
      -> !waveamdmachine.reg<vgpr, 1>
  return %result : !waveamdmachine.reg<vgpr, 1>
}

// CHECK-LABEL: func.func @distinct_source_stays_bpermute
// CHECK-NOT: waveamdmachine.v_permlane32_swap_b32_tuple
// CHECK: waveamdmachine.ds_bpermute_b32
// CHECK: waveamdmachine.v_add_f32
func.func @distinct_source_stays_bpermute(
    %direct: !waveamdmachine.reg<vgpr, 1>,
    %source: !waveamdmachine.reg<vgpr, 1>)
    -> !waveamdmachine.reg<vgpr, 1>
    attributes {wave.workgroup_size = array<i32: 64, 1, 1>} {
  %workitem = waveamdmachine.v_workitem_id_x
      : !waveamdmachine.reg<vgpr, 1, 0>
  %c63 = waveamdmachine.imm 63 : !waveamdmachine.imm
  %lane = waveamdmachine.v_and_b32 %workitem, %c63
      : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.imm)
      -> !waveamdmachine.reg<vgpr, 1>
  %c32 = waveamdmachine.imm 32 : !waveamdmachine.imm
  %other_lane = waveamdmachine.v_xor_b32 %lane, %c32
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
      -> !waveamdmachine.reg<vgpr, 1>
  %c2 = waveamdmachine.imm 2 : !waveamdmachine.imm
  %addr = waveamdmachine.v_lshlrev_b32 %other_lane, %c2
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
      -> !waveamdmachine.reg<vgpr, 1>
  %permuted = waveamdmachine.ds_bpermute_b32 %addr, %source
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
      -> !waveamdmachine.reg<vgpr, 1>
  %result = waveamdmachine.v_add_f32 %direct, %permuted
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
      -> !waveamdmachine.reg<vgpr, 1>
  return %result : !waveamdmachine.reg<vgpr, 1>
}

// CHECK-LABEL: func.func @nonzero_offset_stays_bpermute
// CHECK-NOT: waveamdmachine.v_permlane32_swap_b32_tuple
// CHECK: waveamdmachine.ds_bpermute_b32 {{.*}} offset 4
// CHECK: waveamdmachine.v_add_f32
func.func @nonzero_offset_stays_bpermute(
    %data: !waveamdmachine.reg<vgpr, 1>)
    -> !waveamdmachine.reg<vgpr, 1>
    attributes {wave.workgroup_size = array<i32: 64, 1, 1>} {
  %workitem = waveamdmachine.v_workitem_id_x
      : !waveamdmachine.reg<vgpr, 1, 0>
  %c63 = waveamdmachine.imm 63 : !waveamdmachine.imm
  %lane = waveamdmachine.v_and_b32 %workitem, %c63
      : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.imm)
      -> !waveamdmachine.reg<vgpr, 1>
  %c32 = waveamdmachine.imm 32 : !waveamdmachine.imm
  %other_lane = waveamdmachine.v_xor_b32 %lane, %c32
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
      -> !waveamdmachine.reg<vgpr, 1>
  %c2 = waveamdmachine.imm 2 : !waveamdmachine.imm
  %addr = waveamdmachine.v_lshlrev_b32 %other_lane, %c2
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
      -> !waveamdmachine.reg<vgpr, 1>
  %permuted = waveamdmachine.ds_bpermute_b32 %addr, %data offset 4
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
      -> !waveamdmachine.reg<vgpr, 1>
  %result = waveamdmachine.v_add_f32 %data, %permuted
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
      -> !waveamdmachine.reg<vgpr, 1>
  return %result : !waveamdmachine.reg<vgpr, 1>
}

// CHECK-LABEL: func.func @non_wave_multiple_stays_bpermute
// CHECK-NOT: waveamdmachine.v_permlane32_swap_b32_tuple
// CHECK: waveamdmachine.ds_bpermute_b32
// CHECK: waveamdmachine.v_add_f32
func.func @non_wave_multiple_stays_bpermute(
    %data: !waveamdmachine.reg<vgpr, 1>)
    -> !waveamdmachine.reg<vgpr, 1>
    attributes {wave.workgroup_size = array<i32: 96, 1, 1>} {
  %workitem = waveamdmachine.v_workitem_id_x
      : !waveamdmachine.reg<vgpr, 1, 0>
  %c63 = waveamdmachine.imm 63 : !waveamdmachine.imm
  %lane = waveamdmachine.v_and_b32 %workitem, %c63
      : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.imm)
      -> !waveamdmachine.reg<vgpr, 1>
  %c32 = waveamdmachine.imm 32 : !waveamdmachine.imm
  %other_lane = waveamdmachine.v_xor_b32 %lane, %c32
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
      -> !waveamdmachine.reg<vgpr, 1>
  %c2 = waveamdmachine.imm 2 : !waveamdmachine.imm
  %addr = waveamdmachine.v_lshlrev_b32 %other_lane, %c2
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
      -> !waveamdmachine.reg<vgpr, 1>
  %permuted = waveamdmachine.ds_bpermute_b32 %addr, %data
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
      -> !waveamdmachine.reg<vgpr, 1>
  %result = waveamdmachine.v_add_f32 %data, %permuted
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
      -> !waveamdmachine.reg<vgpr, 1>
  return %result : !waveamdmachine.reg<vgpr, 1>
}

// CHECK-LABEL: func.func @live_bpermute_keeps_address
// CHECK: waveamdmachine.v_xor_b32
// CHECK: waveamdmachine.v_lshlrev_b32
// CHECK: [[OTHER:%.*]] = waveamdmachine.ds_bpermute_b32
// CHECK: waveamdmachine.v_permlane32_swap_b32_tuple
// CHECK: [[RESULT:%.*]] = waveamdmachine.v_add_f32
// CHECK: return [[RESULT]], [[OTHER]]
func.func @live_bpermute_keeps_address(
    %data: !waveamdmachine.reg<vgpr, 1>)
    -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
    attributes {wave.workgroup_size = array<i32: 64, 1, 1>} {
  %workitem = waveamdmachine.v_workitem_id_x
      : !waveamdmachine.reg<vgpr, 1, 0>
  %c63 = waveamdmachine.imm 63 : !waveamdmachine.imm
  %lane = waveamdmachine.v_and_b32 %workitem, %c63
      : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.imm)
      -> !waveamdmachine.reg<vgpr, 1>
  %c32 = waveamdmachine.imm 32 : !waveamdmachine.imm
  %other_lane = waveamdmachine.v_xor_b32 %lane, %c32
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
      -> !waveamdmachine.reg<vgpr, 1>
  %c2 = waveamdmachine.imm 2 : !waveamdmachine.imm
  %addr = waveamdmachine.v_lshlrev_b32 %other_lane, %c2
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
      -> !waveamdmachine.reg<vgpr, 1>
  %other = waveamdmachine.ds_bpermute_b32 %addr, %data
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
      -> !waveamdmachine.reg<vgpr, 1>
  %result = waveamdmachine.v_add_f32 %data, %other
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
      -> !waveamdmachine.reg<vgpr, 1>
  return %result, %other
      : !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>
}

}

// -----

// CHECK-LABEL: func.func @unsupported_isa_stays_bpermute
// CHECK-NOT: waveamdmachine.v_permlane32_swap_b32_tuple
// CHECK: waveamdmachine.ds_bpermute_b32
// CHECK: waveamdmachine.v_add_f32
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx942"} {
func.func @unsupported_isa_stays_bpermute(
    %data: !waveamdmachine.reg<vgpr, 1>)
    -> !waveamdmachine.reg<vgpr, 1>
    attributes {wave.workgroup_size = array<i32: 64, 1, 1>} {
  %workitem = waveamdmachine.v_workitem_id_x
      : !waveamdmachine.reg<vgpr, 1, 0>
  %c63 = waveamdmachine.imm 63 : !waveamdmachine.imm
  %lane = waveamdmachine.v_and_b32 %workitem, %c63
      : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.imm)
      -> !waveamdmachine.reg<vgpr, 1>
  %c32 = waveamdmachine.imm 32 : !waveamdmachine.imm
  %other_lane = waveamdmachine.v_xor_b32 %lane, %c32
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
      -> !waveamdmachine.reg<vgpr, 1>
  %c2 = waveamdmachine.imm 2 : !waveamdmachine.imm
  %addr = waveamdmachine.v_lshlrev_b32 %other_lane, %c2
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
      -> !waveamdmachine.reg<vgpr, 1>
  %permuted = waveamdmachine.ds_bpermute_b32 %addr, %data
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
      -> !waveamdmachine.reg<vgpr, 1>
  %result = waveamdmachine.v_add_f32 %data, %permuted
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
      -> !waveamdmachine.reg<vgpr, 1>
  return %result : !waveamdmachine.reg<vgpr, 1>
}
}
