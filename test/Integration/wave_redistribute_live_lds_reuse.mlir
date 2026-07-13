// RUN: wave-translate --wave-to-amdgpu-asm %s | FileCheck %s --check-prefix=ASM
// RUN: wave-translate --wave-to-amdgpu-asm %s \
// RUN:   | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx1100 -filetype=obj -o /dev/null

// ASM-LABEL: redistribute_after_released_lds:
// ASM: ds_store_b32
// ASM: ds_load_b32
// ASM-COUNT-2: s_barrier
// ASM: ds_load_b128
// ASM: .amdhsa_group_segment_fixed_size 65280
// ASM-LABEL: redistribute_after_implicit_lds_lifetime:
// ASM: ds_store_b32
// ASM: ds_load_b32
// ASM-COUNT-2: s_barrier
// ASM: ds_load_b128
// ASM: .amdhsa_group_segment_fixed_size 65280
// ASM-LABEL: redistribute_sequence_after_implicit_lds_lifetime:
// ASM: ds_store_b32
// ASM: ds_load_b32
// ASM: ds_store_b128
// ASM: ds_load_b128
// ASM: .amdhsa_group_segment_fixed_size 65280

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
func.func @redistribute_after_released_lds(
    %dst: !wave.ptr<#wave.global, i32>)
    attributes {wave.kernel,
                wave.workgroup_size = array<i32: 64, 1, 1>,
                wave.waves_per_workgroup = 2 : i64} {
  %lane = wave.workitem_id 0 : !wave.simd<i32, 32>
  %one = wave.constant 1 : i32 -> !wave.simd<i32, 32>
  %two = wave.constant 2 : i32 -> !wave.simd<i32, 32>
  %three = wave.constant 3 : i32 -> !wave.simd<i32, 32>
  %allocation = wave.alloc() {align = 16 : i64, bytesize = 65280 : i64}
      : !wave.ptr<#wave.shared, i32>
  %allocation_ptr = wave.ptr_add %allocation, %lane
      : !wave.ptr<#wave.shared, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.shared, i32>, 32>
  %stored = wave.store %lane -> %allocation_ptr
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.shared, i32>, 32>)
      -> !wave.mem.token
  %loaded, %loaded_token = wave.load %allocation_ptr after %stored
      : (!wave.simd<!wave.ptr<#wave.shared, i32>, 32>, !wave.mem.token)
      -> (!wave.simd<i32, 32>, !wave.mem.token)
  %released = wave.alloc_release %allocation after %loaded_token {workgroup_collective}
      : (!wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
  %ready = wave.barrier %released : (!wave.mem.token) -> !wave.mem.token
  %source = wave.pack %lane, %one, %two, %three
      : !wave.simd<i32, 32>, !wave.simd<i32, 32>, !wave.simd<i32, 32>,
        !wave.simd<i32, 32> -> !wave.simd<vector<4xi32>, 32>
  %moved = wave.redistribute %source,
      <blocks = 1, items = 64, source_block = "block",
       source_item = "xor(item, 32)", source_slot = "slot">
      : !wave.simd<vector<4xi32>, 32> -> !wave.simd<vector<4xi32>, 32>
  %value = wave.extract %moved[0]
      : !wave.simd<vector<4xi32>, 32> -> !wave.simd<i32, 32>
  %sum = wave.binary addi %value, %loaded
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %dst_ptr = wave.ptr_add %dst, %lane
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %done = wave.store %sum -> %dst_ptr after %ready
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.global, i32>, 32>,
         !wave.mem.token) -> !wave.mem.token
  return
}

func.func @redistribute_after_implicit_lds_lifetime(
    %dst: !wave.ptr<#wave.global, i32>)
    attributes {wave.kernel,
                wave.workgroup_size = array<i32: 64, 1, 1>,
                wave.waves_per_workgroup = 2 : i64} {
  %lane = wave.workitem_id 0 : !wave.simd<i32, 32>
  %one = wave.constant 1 : i32 -> !wave.simd<i32, 32>
  %two = wave.constant 2 : i32 -> !wave.simd<i32, 32>
  %three = wave.constant 3 : i32 -> !wave.simd<i32, 32>
  %allocation = wave.alloc() {align = 16 : i64, bytesize = 65280 : i64}
      : !wave.ptr<#wave.shared, i32>
  %allocation_ptr = wave.ptr_add %allocation, %lane
      : !wave.ptr<#wave.shared, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.shared, i32>, 32>
  %stored = wave.store %lane -> %allocation_ptr
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.shared, i32>, 32>)
      -> !wave.mem.token
  %loaded, %loaded_token = wave.load %allocation_ptr after %stored
      : (!wave.simd<!wave.ptr<#wave.shared, i32>, 32>, !wave.mem.token)
      -> (!wave.simd<i32, 32>, !wave.mem.token)
  %ready = wave.barrier %loaded_token : (!wave.mem.token) -> !wave.mem.token
  %source = wave.pack %lane, %one, %two, %three
      : !wave.simd<i32, 32>, !wave.simd<i32, 32>, !wave.simd<i32, 32>,
        !wave.simd<i32, 32> -> !wave.simd<vector<4xi32>, 32>
  %moved = wave.redistribute %source,
      <blocks = 1, items = 64, source_block = "block",
       source_item = "xor(item, 32)", source_slot = "slot">
      : !wave.simd<vector<4xi32>, 32> -> !wave.simd<vector<4xi32>, 32>
  %value = wave.extract %moved[0]
      : !wave.simd<vector<4xi32>, 32> -> !wave.simd<i32, 32>
  %sum = wave.binary addi %value, %loaded
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %dst_ptr = wave.ptr_add %dst, %lane
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %done = wave.store %sum -> %dst_ptr after %ready
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.global, i32>, 32>,
         !wave.mem.token) -> !wave.mem.token
  return
}

func.func @redistribute_sequence_after_implicit_lds_lifetime(
    %dst: !wave.ptr<#wave.global, i32>)
    attributes {wave.kernel,
                wave.workgroup_size = array<i32: 64, 1, 1>,
                wave.waves_per_workgroup = 2 : i64} {
  %lane = wave.workitem_id 0 : !wave.simd<i32, 32>
  %one = wave.constant 1 : i32 -> !wave.simd<i32, 32>
  %two = wave.constant 2 : i32 -> !wave.simd<i32, 32>
  %three = wave.constant 3 : i32 -> !wave.simd<i32, 32>
  %allocation = wave.alloc() {align = 16 : i64, bytesize = 65280 : i64}
      : !wave.ptr<#wave.shared, i32>
  %allocation_ptr = wave.ptr_add %allocation, %lane
      : !wave.ptr<#wave.shared, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.shared, i32>, 32>
  %stored = wave.store %lane -> %allocation_ptr
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.shared, i32>, 32>)
      -> !wave.mem.token
  %loaded, %loaded_token = wave.load %allocation_ptr after %stored
      : (!wave.simd<!wave.ptr<#wave.shared, i32>, 32>, !wave.mem.token)
      -> (!wave.simd<i32, 32>, !wave.mem.token)
  %ready = wave.barrier %loaded_token : (!wave.mem.token) -> !wave.mem.token
  %source = wave.pack %lane, %one, %two, %three
      : !wave.simd<i32, 32>, !wave.simd<i32, 32>, !wave.simd<i32, 32>,
        !wave.simd<i32, 32> -> !wave.simd<vector<4xi32>, 32>
  %first = wave.redistribute %source,
      <blocks = 1, items = 64, source_block = "block",
       source_item = "xor(item, 32)", source_slot = "slot">
      : !wave.simd<vector<4xi32>, 32> -> !wave.simd<vector<4xi32>, 32>
  %first_value = wave.extract %first[0]
      : !wave.simd<vector<4xi32>, 32> -> !wave.simd<i32, 32>
  %second_source = wave.pack %first_value, %one, %two, %three
      : !wave.simd<i32, 32>, !wave.simd<i32, 32>, !wave.simd<i32, 32>,
        !wave.simd<i32, 32> -> !wave.simd<vector<4xi32>, 32>
  %second = wave.redistribute %second_source,
      <blocks = 1, items = 64, source_block = "block",
       source_item = "xor(item, 32)", source_slot = "slot">
      : !wave.simd<vector<4xi32>, 32> -> !wave.simd<vector<4xi32>, 32>
  %value = wave.extract %second[0]
      : !wave.simd<vector<4xi32>, 32> -> !wave.simd<i32, 32>
  %sum = wave.binary addi %value, %loaded
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %dst_ptr = wave.ptr_add %dst, %lane
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %done = wave.store %sum -> %dst_ptr after %ready
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.global, i32>, 32>,
         !wave.mem.token) -> !wave.mem.token
  return
}
}
