// RUN: wave-translate --wave-to-amdgpu-asm %s | FileCheck %s --check-prefix=ASM
// RUN: wave-translate --wave-to-amdgpu-asm %s \
// RUN:   | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx1100 -filetype=obj -o /dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// ASM-LABEL: redistribute_same_wave:
// ASM: ds_bpermute_b32
// ASM-NOT: s_barrier
// ASM: buffer_store_b32
func.func @redistribute_same_wave(%dst: !wave.ptr<#wave.global, i32>)
    attributes {wave.kernel,
                wave.workgroup_size = array<i32: 64, 1, 1>,
                wave.waves_per_workgroup = 2 : i64} {
  %item = wave.workitem_id 0 : !wave.simd<i32, 32>
  %source = wave.pack %item, %item
      : !wave.simd<i32, 32>, !wave.simd<i32, 32>
      -> !wave.simd<vector<2xi32>, 32>
  %moved = wave.redistribute %source,
      <items = 64, source_item = "xor(item, 1)", source_slot = "slot">
      : !wave.simd<vector<2xi32>, 32> -> !wave.simd<vector<2xi32>, 32>
  %value = wave.extract %moved[0]
      : !wave.simd<vector<2xi32>, 32> -> !wave.simd<i32, 32>
  %ptr = wave.ptr_add %dst, %item
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %token = wave.store %value -> %ptr
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.global, i32>, 32>)
      -> !wave.mem.token
  return
}

// ASM-LABEL: redistribute_cross_wave:
// ASM: ds_store
// ASM: s_barrier
// ASM: ds_load
// ASM: s_barrier
// ASM: buffer_store_b32
// ASM: .amdhsa_group_segment_fixed_size 512
func.func @redistribute_cross_wave(%dst: !wave.ptr<#wave.global, i32>)
    attributes {wave.kernel,
                wave.workgroup_size = array<i32: 64, 1, 1>,
                wave.waves_per_workgroup = 2 : i64} {
  %item = wave.workitem_id 0 : !wave.simd<i32, 32>
  %one = wave.constant 1 : i32 -> !wave.simd<i32, 32>
  %next = wave.binary addi %item, %one
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %source = wave.pack %item, %next
      : !wave.simd<i32, 32>, !wave.simd<i32, 32>
      -> !wave.simd<vector<2xi32>, 32>
  %moved = wave.redistribute %source,
      <items = 64, source_item = "xor(item, 32)", source_slot = "slot">
      : !wave.simd<vector<2xi32>, 32> -> !wave.simd<vector<2xi32>, 32>
  %value = wave.extract %moved[0]
      : !wave.simd<vector<2xi32>, 32> -> !wave.simd<i32, 32>
  %ptr = wave.ptr_add %dst, %item
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %token = wave.store %value -> %ptr
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.global, i32>, 32>)
      -> !wave.mem.token
  return
}

// ASM-LABEL: redistribute_cross_wave_nested:
// ASM: s_cbranch_scc0
// ASM: ds_store
// ASM: s_barrier
// ASM: ds_load
// ASM: s_barrier
// ASM: buffer_store_b32
// ASM: .amdhsa_group_segment_fixed_size 256
func.func @redistribute_cross_wave_nested(
    %dst: !wave.ptr<#wave.global, i32>, %condition: i1)
    attributes {wave.kernel,
                wave.workgroup_size = array<i32: 64, 1, 1>,
                wave.waves_per_workgroup = 2 : i64} {
  %item = wave.workitem_id 0 : !wave.simd<i32, 32>
  %source = wave.pack %item
      : !wave.simd<i32, 32> -> !wave.simd<vector<1xi32>, 32>
  scf.if %condition {
    %moved = wave.redistribute %source,
        <items = 64, source_item = "xor(item, 32)", source_slot = "slot">
        : !wave.simd<vector<1xi32>, 32> -> !wave.simd<vector<1xi32>, 32>
    %value = wave.extract %moved[0]
        : !wave.simd<vector<1xi32>, 32> -> !wave.simd<i32, 32>
    %ptr = wave.ptr_add %dst, %item
        : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32>
        -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
    %token = wave.store %value -> %ptr
        : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.global, i32>, 32>)
        -> !wave.mem.token
  }
  return
}

}
