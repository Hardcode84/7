// RUN: wave-opt --split-input-file --waveamd-cross-lane-peepholes %s | FileCheck %s --check-prefix=PEEP
// RUN: wave-opt --split-input-file --waveamd-cross-lane-peepholes --waveamd-insert-ticket-waits %s | FileCheck %s --check-prefix=WAIT

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// PEEP-LABEL: func.func @permute_xor_to_swizzle
// PEEP-NOT: waveamdmachine.ds_permute_b32
// PEEP: [[OUT:%.*]] = waveamdmachine.ds_swizzle_b32 {{.*}} offset 16415
// PEEP: waveamdmachine.v_add_u32 [[OUT]],
// WAIT-LABEL: func.func @permute_xor_to_swizzle
// WAIT: [[OUT:%.*]] = waveamdmachine.ds_swizzle_b32
// WAIT-NEXT: waveamdmachine.s_waitcnt lgkmcnt(0)
// WAIT-NEXT: waveamdmachine.v_add_u32 [[OUT]],
func.func @permute_xor_to_swizzle() -> !waveamdmachine.reg<vgpr, 1> {
  %lane = waveamdmachine.v_mbcnt_lo : !waveamdmachine.reg<vgpr, 1>
  %data = waveamdmachine.v_mbcnt_hi %lane
      : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %mask = waveamdmachine.imm 16 : !waveamdmachine.imm
  %dst_lane = waveamdmachine.v_xor_b32 %lane, %mask
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
          -> !waveamdmachine.reg<vgpr, 1>
  %two = waveamdmachine.imm 2 : !waveamdmachine.imm
  %addr = waveamdmachine.v_lshlrev_b32 %dst_lane, %two
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
          -> !waveamdmachine.reg<vgpr, 1>
  %permuted = waveamdmachine.ds_permute_b32 %addr, %data
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
  %use = waveamdmachine.v_add_u32 %permuted, %lane
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
  return %use : !waveamdmachine.reg<vgpr, 1>
}

// PEEP-LABEL: func.func @permute_identity_to_swizzle
// PEEP-NOT: waveamdmachine.ds_permute_b32
// PEEP: [[OUT:%.*]] = waveamdmachine.ds_swizzle_b32 {{.*}} offset 31
// PEEP: return [[OUT]]
func.func @permute_identity_to_swizzle() -> !waveamdmachine.reg<vgpr, 1> {
  %lane = waveamdmachine.v_mbcnt_lo : !waveamdmachine.reg<vgpr, 1>
  %data = waveamdmachine.v_mbcnt_hi %lane
      : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %two = waveamdmachine.imm 2 : !waveamdmachine.imm
  %addr = waveamdmachine.v_lshlrev_b32 %lane, %two
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
          -> !waveamdmachine.reg<vgpr, 1>
  %permuted = waveamdmachine.ds_permute_b32 %addr, %data
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
  return %permuted : !waveamdmachine.reg<vgpr, 1>
}

// PEEP-LABEL: func.func @permute_or_stays_permute
// PEEP: waveamdmachine.v_or_b32
// PEEP: waveamdmachine.ds_permute_b32
// PEEP-NOT: waveamdmachine.ds_swizzle_b32
func.func @permute_or_stays_permute() -> !waveamdmachine.reg<vgpr, 1> {
  %lane = waveamdmachine.v_mbcnt_lo : !waveamdmachine.reg<vgpr, 1>
  %data = waveamdmachine.v_mbcnt_hi %lane
      : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %one = waveamdmachine.imm 1 : !waveamdmachine.imm
  %dst_lane = waveamdmachine.v_or_b32 %lane, %one
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
          -> !waveamdmachine.reg<vgpr, 1>
  %two = waveamdmachine.imm 2 : !waveamdmachine.imm
  %addr = waveamdmachine.v_lshlrev_b32 %dst_lane, %two
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
          -> !waveamdmachine.reg<vgpr, 1>
  %permuted = waveamdmachine.ds_permute_b32 %addr, %data
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
  return %permuted : !waveamdmachine.reg<vgpr, 1>
}

// PEEP-LABEL: func.func @permute_large_xor_mask_stays_permute
// PEEP: waveamdmachine.v_xor_b32
// PEEP: waveamdmachine.ds_permute_b32
// PEEP-NOT: waveamdmachine.ds_swizzle_b32
func.func @permute_large_xor_mask_stays_permute()
    -> !waveamdmachine.reg<vgpr, 1> {
  %lane = waveamdmachine.v_mbcnt_lo : !waveamdmachine.reg<vgpr, 1>
  %data = waveamdmachine.v_mbcnt_hi %lane
      : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %large = waveamdmachine.imm 32 : !waveamdmachine.imm
  %dst_lane = waveamdmachine.v_xor_b32 %lane, %large
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
          -> !waveamdmachine.reg<vgpr, 1>
  %two = waveamdmachine.imm 2 : !waveamdmachine.imm
  %addr = waveamdmachine.v_lshlrev_b32 %dst_lane, %two
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
          -> !waveamdmachine.reg<vgpr, 1>
  %permuted = waveamdmachine.ds_permute_b32 %addr, %data
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
  return %permuted : !waveamdmachine.reg<vgpr, 1>
}

// PEEP-LABEL: func.func @permute_offset_stays_permute
// PEEP: waveamdmachine.ds_permute_b32 {{.*}} offset 4
// PEEP-NOT: waveamdmachine.ds_swizzle_b32
func.func @permute_offset_stays_permute() -> !waveamdmachine.reg<vgpr, 1> {
  %lane = waveamdmachine.v_mbcnt_lo : !waveamdmachine.reg<vgpr, 1>
  %data = waveamdmachine.v_mbcnt_hi %lane
      : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %two = waveamdmachine.imm 2 : !waveamdmachine.imm
  %addr = waveamdmachine.v_lshlrev_b32 %lane, %two
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
          -> !waveamdmachine.reg<vgpr, 1>
  %permuted = waveamdmachine.ds_permute_b32 %addr, %data offset 4
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
  return %permuted : !waveamdmachine.reg<vgpr, 1>
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// PEEP-LABEL: func.func @half_exchange_add_to_permlane
// PEEP-NOT: waveamdmachine.ds_bpermute_b32
// PEEP: [[PAIR:%.*]] = waveamdmachine.v_mov_b32_tuple
// PEEP: [[SWAP:%.*]] = waveamdmachine.v_permlane32_swap_b32_tuple [[PAIR]]
// PEEP: [[WORDS:%.*]]:2 = waveamdmachine.tuple_to_elements [[SWAP]]
// PEEP: [[RESULT:%.*]] = waveamdmachine.v_add_f32 [[WORDS]]#0, [[WORDS]]#1
// PEEP: return [[RESULT]]
func.func @half_exchange_add_to_permlane(
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
  %self_addr = waveamdmachine.v_lshlrev_b32 %lane, %c2
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
      -> !waveamdmachine.reg<vgpr, 1>
  %other_addr = waveamdmachine.v_lshlrev_b32 %other_lane, %c2
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
      -> !waveamdmachine.reg<vgpr, 1>
  %self = waveamdmachine.ds_bpermute_b32 %self_addr, %data
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
      -> !waveamdmachine.reg<vgpr, 1>
  %other = waveamdmachine.ds_bpermute_b32 %other_addr, %data
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
      -> !waveamdmachine.reg<vgpr, 1>
  %result = waveamdmachine.v_add_f32 %self, %other
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
      -> !waveamdmachine.reg<vgpr, 1>
  return %result : !waveamdmachine.reg<vgpr, 1>
}

// PEEP-LABEL: func.func @half_exchange_max_to_permlane
// PEEP-NOT: waveamdmachine.ds_bpermute_b32
// PEEP: waveamdmachine.v_permlane32_swap_b32_tuple
// PEEP: [[RESULT:%.*]] = waveamdmachine.v_max_f32
// PEEP: return [[RESULT]]
func.func @half_exchange_max_to_permlane(
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
  %self_addr = waveamdmachine.v_lshlrev_b32 %lane, %c2
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
      -> !waveamdmachine.reg<vgpr, 1>
  %other_addr = waveamdmachine.v_lshlrev_b32 %other_lane, %c2
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
      -> !waveamdmachine.reg<vgpr, 1>
  %self = waveamdmachine.ds_bpermute_b32 %self_addr, %data
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
      -> !waveamdmachine.reg<vgpr, 1>
  %other = waveamdmachine.ds_bpermute_b32 %other_addr, %data
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
      -> !waveamdmachine.reg<vgpr, 1>
  %result = waveamdmachine.v_max_f32 %other, %self
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
      -> !waveamdmachine.reg<vgpr, 1>
  return %result : !waveamdmachine.reg<vgpr, 1>
}

// PEEP-LABEL: func.func @quarter_exchange_stays_bpermute
// PEEP-NOT: waveamdmachine.v_permlane32_swap_b32_tuple
// PEEP: waveamdmachine.ds_bpermute_b32
// PEEP: waveamdmachine.ds_bpermute_b32
// PEEP: waveamdmachine.v_add_f32
func.func @quarter_exchange_stays_bpermute(
    %data: !waveamdmachine.reg<vgpr, 1>)
    -> !waveamdmachine.reg<vgpr, 1>
    attributes {wave.workgroup_size = array<i32: 64, 1, 1>} {
  %workitem = waveamdmachine.v_workitem_id_x
      : !waveamdmachine.reg<vgpr, 1, 0>
  %c63 = waveamdmachine.imm 63 : !waveamdmachine.imm
  %lane = waveamdmachine.v_and_b32 %workitem, %c63
      : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.imm)
      -> !waveamdmachine.reg<vgpr, 1>
  %c16 = waveamdmachine.imm 16 : !waveamdmachine.imm
  %other_lane = waveamdmachine.v_xor_b32 %lane, %c16
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
      -> !waveamdmachine.reg<vgpr, 1>
  %c2 = waveamdmachine.imm 2 : !waveamdmachine.imm
  %self_addr = waveamdmachine.v_lshlrev_b32 %lane, %c2
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
      -> !waveamdmachine.reg<vgpr, 1>
  %other_addr = waveamdmachine.v_lshlrev_b32 %other_lane, %c2
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
      -> !waveamdmachine.reg<vgpr, 1>
  %self = waveamdmachine.ds_bpermute_b32 %self_addr, %data
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
      -> !waveamdmachine.reg<vgpr, 1>
  %other = waveamdmachine.ds_bpermute_b32 %other_addr, %data
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
      -> !waveamdmachine.reg<vgpr, 1>
  %result = waveamdmachine.v_add_f32 %self, %other
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
      -> !waveamdmachine.reg<vgpr, 1>
  return %result : !waveamdmachine.reg<vgpr, 1>
}

}

// -----

module attributes {
  waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100",
  waveamdmachine.wavefront_size = 64 : i64
} {

// PEEP-LABEL: func.func @wave64_bare_mbcnt_lo_stays_permute
// PEEP: waveamdmachine.v_xor_b32
// PEEP: waveamdmachine.ds_permute_b32
// PEEP-NOT: waveamdmachine.ds_swizzle_b32
func.func @wave64_bare_mbcnt_lo_stays_permute()
    -> !waveamdmachine.reg<vgpr, 1> {
  %lo = waveamdmachine.v_mbcnt_lo : !waveamdmachine.reg<vgpr, 1>
  %data = waveamdmachine.v_mbcnt_hi %lo
      : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %mask = waveamdmachine.imm 16 : !waveamdmachine.imm
  %dst_lane = waveamdmachine.v_xor_b32 %lo, %mask
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
          -> !waveamdmachine.reg<vgpr, 1>
  %two = waveamdmachine.imm 2 : !waveamdmachine.imm
  %addr = waveamdmachine.v_lshlrev_b32 %dst_lane, %two
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
          -> !waveamdmachine.reg<vgpr, 1>
  %permuted = waveamdmachine.ds_permute_b32 %addr, %data
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
  return %permuted : !waveamdmachine.reg<vgpr, 1>
}

// PEEP-LABEL: func.func @wave64_full_lane_xor_to_swizzle
// PEEP-NOT: waveamdmachine.ds_permute_b32
// PEEP: [[OUT:%.*]] = waveamdmachine.ds_swizzle_b32 {{.*}} offset 16415
// PEEP: return [[OUT]]
func.func @wave64_full_lane_xor_to_swizzle()
    -> !waveamdmachine.reg<vgpr, 1> {
  %lo = waveamdmachine.v_mbcnt_lo : !waveamdmachine.reg<vgpr, 1>
  %lane = waveamdmachine.v_mbcnt_hi %lo
      : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %data = waveamdmachine.v_mbcnt_hi %lo
      : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  %mask = waveamdmachine.imm 16 : !waveamdmachine.imm
  %dst_lane = waveamdmachine.v_xor_b32 %lane, %mask
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
          -> !waveamdmachine.reg<vgpr, 1>
  %two = waveamdmachine.imm 2 : !waveamdmachine.imm
  %addr = waveamdmachine.v_lshlrev_b32 %dst_lane, %two
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
          -> !waveamdmachine.reg<vgpr, 1>
  %permuted = waveamdmachine.ds_permute_b32 %addr, %data
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
  return %permuted : !waveamdmachine.reg<vgpr, 1>
}

}
