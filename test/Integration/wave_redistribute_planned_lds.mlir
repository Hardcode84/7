// RUN: wave-translate --wave-to-amdgpu-asm %s | FileCheck %s --check-prefix=ASM
// RUN: wave-translate --wave-to-amdgpu-asm %s \
// RUN:   | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx1100 -filetype=obj -o /dev/null

// ASM-LABEL: redistribute_before_aligned_alloc:
// ASM: ds_store_b8 {{.*}} offset:65312
// ASM: ds_load_u8 {{.*}} offset:65312
// ASM: ds_store_b8 {{.*}} offset:65280
// ASM: .amdhsa_group_segment_fixed_size 65376

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
  func.func @redistribute_before_aligned_alloc(
      %src: !wave.ptr<#wave.global, i8>,
      %dst: !wave.ptr<#wave.global, i8>)
      attributes {wave.kernel, wave.lds_size = 65248 : i64,
                  wave.workgroup_size = array<i32: 64, 1, 1>,
                  wave.waves_per_workgroup = 2 : i64} {
    %lane = wave.lane_id : !wave.simd<i32, 32>
    %src_ptr = wave.ptr_add %src, %lane
        : !wave.ptr<#wave.global, i8>, !wave.simd<i32, 32>
        -> !wave.simd<!wave.ptr<#wave.global, i8>, 32>
    %input, %loaded = wave.load %src_ptr
        : (!wave.simd<!wave.ptr<#wave.global, i8>, 32>)
        -> (!wave.simd<i8, 32>, !wave.mem.token)
    %source = wave.pack %input
        : !wave.simd<i8, 32> -> !wave.simd<vector<1xi8>, 32>
    %moved = wave.redistribute %source,
        <blocks = 1, items = 64, source_block = "block",
         source_item = "xor(item, 32)", source_slot = "slot">
        : !wave.simd<vector<1xi8>, 32> -> !wave.simd<vector<1xi8>, 32>
    %value = wave.extract %moved[0]
        : !wave.simd<vector<1xi8>, 32> -> !wave.simd<i8, 32>
    %future = wave.alloc() {align = 256 : i64, bytesize = 32 : i64}
        : !wave.ptr<#wave.shared, i8>
    %future_ptr = wave.ptr_add %future, %lane
        : !wave.ptr<#wave.shared, i8>, !wave.simd<i32, 32>
        -> !wave.simd<!wave.ptr<#wave.shared, i8>, 32>
    %future_stored = wave.store %value -> %future_ptr
        : (!wave.simd<i8, 32>, !wave.simd<!wave.ptr<#wave.shared, i8>, 32>)
        -> !wave.mem.token
    %future_value, %future_loaded =
        wave.load %future_ptr after %future_stored
        : (!wave.simd<!wave.ptr<#wave.shared, i8>, 32>, !wave.mem.token)
        -> (!wave.simd<i8, 32>, !wave.mem.token)
    %dst_ptr = wave.ptr_add %dst, %lane
        : !wave.ptr<#wave.global, i8>, !wave.simd<i32, 32>
        -> !wave.simd<!wave.ptr<#wave.global, i8>, 32>
    %done = wave.store %future_value -> %dst_ptr after %future_loaded
        : (!wave.simd<i8, 32>, !wave.simd<!wave.ptr<#wave.global, i8>, 32>,
           !wave.mem.token) -> !wave.mem.token
    return
  }
}
