// RUN: wave-opt --split-input-file %s \
// RUN:   --pass-pipeline='builtin.module(wave-lower-redistribute,waveamd-to-machine,canonicalize,cse,waveamd-form-fused-int,waveamd-cross-lane-peepholes,canonicalize,cse)' \
// RUN:   | FileCheck %s
// RUN: wave-opt --split-input-file --waveamd-cross-lane-peepholes %s \
// RUN:   | FileCheck %s --check-prefix=HIGHBITS

// CHECK-LABEL: func.func @gfx950_exact(
// CHECK: waveamdmachine.v_permlane32_swap_b32_tuple
// CHECK-NOT: waveamdmachine.ds_bpermute_b32
// CHECK-NOT: waveamdmachine.v_cndmask_b32_tuple
// CHECK: return
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @gfx950_exact(%source: !wave.simd<vector<2xi32>, 64>)
    -> !wave.simd<vector<2xi32>, 64>
    attributes {wave.workgroup_size = array<i32: 64, 1, 1>} {
  %result = wave.redistribute %source,
      <blocks = 1, items = 64, source_block = "block",
       source_item = "Mod(item, 32) + 32*slot",
       source_slot = "floor(1/32*item)">
      : !wave.simd<vector<2xi32>, 64>
      -> !wave.simd<vector<2xi32>, 64>
  return %result : !wave.simd<vector<2xi32>, 64>
}
}

// -----

// CHECK-LABEL: func.func @gfx942_fallback(
// CHECK-NOT: waveamdmachine.v_permlane32_swap_b32_tuple
// CHECK: waveamdmachine.ds_bpermute_b32
// CHECK: waveamdmachine.ds_bpermute_b32
// CHECK: waveamdmachine.v_cndmask_b32_tuple
// CHECK: waveamdmachine.ds_bpermute_b32
// CHECK: waveamdmachine.ds_bpermute_b32
// CHECK: waveamdmachine.v_cndmask_b32_tuple
// CHECK: return
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx942"} {
func.func @gfx942_fallback(%source: !wave.simd<vector<2xi32>, 64>)
    -> !wave.simd<vector<2xi32>, 64>
    attributes {wave.workgroup_size = array<i32: 64, 1, 1>} {
  %result = wave.redistribute %source,
      <blocks = 1, items = 64, source_block = "block",
       source_item = "Mod(item, 32) + 32*slot",
       source_slot = "floor(1/32*item)">
      : !wave.simd<vector<2xi32>, 64>
      -> !wave.simd<vector<2xi32>, 64>
  return %result : !wave.simd<vector<2xi32>, 64>
}
}

// -----

// HIGHBITS-LABEL: func.func @high_wave_near_miss(
// HIGHBITS-NOT: waveamdmachine.v_permlane32_swap_b32_tuple
// HIGHBITS: waveamdmachine.ds_bpermute_b32
// HIGHBITS: waveamdmachine.ds_bpermute_b32
// HIGHBITS: waveamdmachine.v_cndmask_b32_tuple
// HIGHBITS: waveamdmachine.ds_bpermute_b32
// HIGHBITS: waveamdmachine.ds_bpermute_b32
// HIGHBITS: waveamdmachine.v_cndmask_b32_tuple
// HIGHBITS: return
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @high_wave_near_miss(
    %a: !waveamdmachine.reg<vgpr, 1>,
    %b: !waveamdmachine.reg<vgpr, 1>)
    -> !waveamdmachine.reg<vgpr, 2>
    attributes {wave.workgroup_size = array<i32: 128, 1, 1>} {
  %workitem = waveamdmachine.v_workitem_id_x
      : !waveamdmachine.reg<vgpr, 1, 0>
  %c31 = waveamdmachine.imm 31 : !waveamdmachine.imm
  %local = waveamdmachine.v_and_b32 %workitem, %c31
      : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.imm)
      -> !waveamdmachine.reg<vgpr, 1>
  %c64 = waveamdmachine.imm 64 : !waveamdmachine.imm
  %wave_bit = waveamdmachine.v_and_b32 %workitem, %c64
      : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.imm)
      -> !waveamdmachine.reg<vgpr, 1>
  %low_lane = waveamdmachine.v_add_u32 %local, %wave_bit
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
      -> !waveamdmachine.reg<vgpr, 1>
  %c2 = waveamdmachine.imm 2 : !waveamdmachine.imm
  %low_addr = waveamdmachine.v_lshlrev_b32 %low_lane, %c2
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
      -> !waveamdmachine.reg<vgpr, 1>
  %a_low = waveamdmachine.ds_bpermute_b32 %low_addr, %a
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
      -> !waveamdmachine.reg<vgpr, 1>
  %b_low = waveamdmachine.ds_bpermute_b32 %low_addr, %b
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
      -> !waveamdmachine.reg<vgpr, 1>
  %c63 = waveamdmachine.imm 63 : !waveamdmachine.imm
  %wave_lane = waveamdmachine.v_and_b32 %workitem, %c63
      : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.imm)
      -> !waveamdmachine.reg<vgpr, 1>
  %c5 = waveamdmachine.imm 5 : !waveamdmachine.imm
  %half = waveamdmachine.v_lshrrev_b32 %wave_lane, %c5
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.imm)
      -> !waveamdmachine.reg<vgpr, 1>
  %c1 = waveamdmachine.imm 1 : !waveamdmachine.imm
  %one = waveamdmachine.s_mov_b32_value %c1
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1>
  %vcc = waveamdmachine.v_cmp_eq_u32_vcc %half, %one
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
      -> !waveamdmachine.reg<vcc, 1>
  %condition = waveamdmachine.s_read_vcc_b64 %vcc
      : (!waveamdmachine.reg<vcc, 1>) -> !waveamdmachine.reg<sgpr, 2>
  %lower = waveamdmachine.v_cndmask_b32_tuple %a_low, %b_low, %condition
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 2>) -> !waveamdmachine.reg<vgpr, 1>
  %c32 = waveamdmachine.imm 32 : !waveamdmachine.imm
  %upper_lane = waveamdmachine.v_add_u32 %low_lane, %c32
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
