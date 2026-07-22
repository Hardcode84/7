// RUN: wave-opt --waveamd-cross-lane-peepholes %s \
// RUN:   | wave-translate --wave-to-amdgpu-asm - | FileCheck %s --check-prefix=ASM
// RUN: wave-opt --waveamd-cross-lane-peepholes %s \
// RUN:   | wave-translate --wave-to-amdgpu-asm - \
// RUN:   | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx950 -filetype=obj -o /dev/null

// ASM-LABEL: redistribute_permlane32:
// ASM-NOT: ds_
// ASM-NOT: v_cndmask
// ASM-NOT: s_barrier
// ASM: v_add_u32_e32 [[HI:v[0-9]+]], 1, [[ITEM:v[0-9]+]]
// ASM: v_mov_b32_e32 [[LO:v[0-9]+]], [[ITEM]]
// ASM: v_permlane32_swap_b32_e32 [[LO]], [[HI]]
// ASM-NOT: v_permlane32_swap_b32_e32
// ASM-NOT: ds_
// ASM-NOT: v_cndmask
// ASM-NOT: s_barrier
// ASM: buffer_store_dwordx2
// ASM: s_endpgm
// ASM: .amdhsa_group_segment_fixed_size 0
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @redistribute_permlane32(%dst: !wave.ptr<#wave.global, i32>)
    attributes {wave.kernel,
                wave.workgroup_size = array<i32: 64, 1, 1>,
                wave.waves_per_workgroup = 1 : i64} {
  %item = wave.workitem_id 0 : !wave.simd<i32, 64>
  %one = wave.constant 1 : i32 -> !wave.simd<i32, 64>
  %next = wave.binary addi %item, %one
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
  %source = wave.pack %item, %next
      : !wave.simd<i32, 64>, !wave.simd<i32, 64>
      -> !wave.simd<vector<2xi32>, 64>
  %result = wave.redistribute %source,
      <blocks = 1, items = 64, source_block = "block",
       source_item = "Mod(item, 32) + 32*slot",
       source_slot = "floor(1/32*item)">
      : !wave.simd<vector<2xi32>, 64>
      -> !wave.simd<vector<2xi32>, 64>
  %two = wave.constant 2 : i32 -> !wave.simd<i32, 64>
  %offset = wave.binary muli %item, %two
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
  %ptr = wave.ptr_add %dst, %offset
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 64>
  %token = wave.store %result -> %ptr
      : (!wave.simd<vector<2xi32>, 64>,
         !wave.simd<!wave.ptr<#wave.global, i32>, 64>) -> !wave.mem.token
  return
}

// ASM-LABEL: half_exchange_reduction_permlane32:
// ASM-NOT: ds_bpermute
// ASM: v_permlane32_swap_b32_e32
// ASM-NOT: ds_bpermute
// ASM: v_add_f32_e32
// ASM: buffer_store_dword
// ASM: s_endpgm
func.func @half_exchange_reduction_permlane32() attributes {
    wave.kernel,
    wave.workgroup_size = array<i32: 64, 1, 1>,
    wave.waves_per_workgroup = 1 : i64} {
  %data = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
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
  %offset = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
  %desc = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 4>
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %token = waveamdmachine.buffer_store_b32 %offset, %result, %desc, %zero
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 4>, !waveamdmachine.imm)
      -> !waveamdmachine.mem.token
  waveamdmachine.s_endpgm
  return
}
}
