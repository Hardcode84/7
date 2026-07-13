// RUN: wave-translate --wave-to-amdgpu-asm %s | FileCheck %s --check-prefix=ASM
// RUN: wave-translate --wave-to-amdgpu-asm %s \
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
}
