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
  %bounded_item = wave.assume %item as "x"
      [#wave.pred<"x >= 0">, #wave.pred<"x <= 63">]
      : !wave.simd<i32, 64>
  %input, %input_ready = wave.gather %dst mapping
      <bit_offset = <"32 * (item + slot)">>
      bindings ["item"](%bounded_item)
      : (!wave.ptr<#wave.global, i32>, !wave.simd<i32, 64>)
      -> (!wave.simd<vector<4xi32>, 64>, !wave.mem.token)

  %scratch = wave.alloc() {align = 16 : i64, bytesize = 1024 : i64}
      : !wave.ptr<#wave.shared, i32>
  %written = wave.scatter %input to %scratch mapping
      <bit_offset = <"32 * (4 * item + slot)">>
      bindings ["item"](%bounded_item) after %input_ready
      : (!wave.simd<vector<4xi32>, 64>, !wave.ptr<#wave.shared, i32>,
         !wave.simd<i32, 64>, !wave.mem.token)
      -> !wave.mem.token
  %loaded, %read = wave.gather %scratch mapping
      <bit_offset = <"32 * (4 * item + slot)">>
      bindings ["item"](%bounded_item) after %written
      : (!wave.ptr<#wave.shared, i32>, !wave.simd<i32, 64>, !wave.mem.token)
      -> (!wave.simd<vector<4xi32>, 64>, !wave.mem.token)

  %four = wave.constant 4 : i32 -> !wave.simd<i32, 64>
  %offset = wave.binary muli %bounded_item, %four overflow<nsw>
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
