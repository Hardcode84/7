// RUN: wave-translate --wave-to-amdgpu-asm %s | FileCheck %s --check-prefix=ASM
// RUN: wave-translate --wave-to-amdgpu-asm %s \
// RUN:   | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx950 -filetype=obj -o /dev/null

// ASM-LABEL: symbolic_memory_codegen:
// ASM: buffer_load_dwordx4 {{.*}} lds
// ASM-NOT: ds_write
// ASM: ds_read_b128
// ASM: buffer_store_dwordx4
// ASM: s_endpgm
// ASM: .amdhsa_group_segment_fixed_size 1024

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @symbolic_memory_codegen(%dst: !wave.ptr<#wave.global, i32>)
    attributes {wave.kernel,
                wave.workgroup_size = array<i32: 64, 1, 1>,
                wave.waves_per_workgroup = 1 : i64} {
  %item = wave.workitem_id 0 : !wave.simd<i32, 64>
  %one = wave.constant 1 : i32 -> !wave.simd<i32, 64>
  %two = wave.constant 2 : i32 -> !wave.simd<i32, 64>
  %three = wave.constant 3 : i32 -> !wave.simd<i32, 64>
  %v1 = wave.binary addi %item, %one
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
  %v2 = wave.binary addi %item, %two
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
  %v3 = wave.binary addi %item, %three
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
  %source = wave.pack %item, %v1, %v2, %v3
      : !wave.simd<i32, 64>, !wave.simd<i32, 64>,
        !wave.simd<i32, 64>, !wave.simd<i32, 64>
      -> !wave.simd<vector<4xi32>, 64>

  %input, %input_ready = wave.gather %dst mapping
      <bit_offset = <"32 * idx">>
      bindings []() packet_bindings ["idx"](%source)
      : (!wave.ptr<#wave.global, i32>, !wave.simd<vector<4xi32>, 64>)
      -> (!wave.simd<vector<4xi32>, 64>, !wave.mem.token)

  %scratch = wave.alloc() {align = 16 : i64, bytesize = 1024 : i64}
      : !wave.ptr<#wave.shared, i32>
  %written = wave.scatter %input to %scratch mapping
      <bit_offset = <"32 * (4 * item + slot)">>
      bindings []() packet_bindings []() after %input_ready
      : (!wave.simd<vector<4xi32>, 64>, !wave.ptr<#wave.shared, i32>,
         !wave.mem.token)
      -> !wave.mem.token
  %loaded, %read = wave.gather %scratch mapping
      <bit_offset = <"32 * (4 * item + slot)">>
      bindings []() packet_bindings []() after %written
      : (!wave.ptr<#wave.shared, i32>, !wave.mem.token)
      -> (!wave.simd<vector<4xi32>, 64>, !wave.mem.token)

  %four = wave.constant 4 : i32 -> !wave.simd<i32, 64>
  %offset = wave.binary muli %item, %four
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
  %out = wave.ptr_add %dst, %offset
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 64>
  %stored = wave.store %loaded -> %out after %read
      : (!wave.simd<vector<4xi32>, 64>,
         !wave.simd<!wave.ptr<#wave.global, i32>, 64>, !wave.mem.token)
      -> !wave.mem.token
  return
}
}
