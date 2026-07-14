// RUN: wave-translate --wave-to-amdgpu-asm %s | FileCheck %s
// RUN: wave-translate --wave-to-amdgpu-asm %s \
// RUN:   | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx950 -filetype=obj -o /dev/null

// CHECK-LABEL: symbolic_memory_packet_item_codegen:
// CHECK-COUNT-2: buffer_load_dword
// CHECK: buffer_store_dwordx2
// CHECK: s_endpgm

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @symbolic_memory_packet_item_codegen(
    %src0: !wave.ptr<#wave.global, i32>,
    %src1: !wave.ptr<#wave.global, i32>,
    %dst: !wave.ptr<#wave.global, i32>)
    attributes {wave.kernel,
                wave.workgroup_size = array<i32: 64, 1, 1>,
                wave.waves_per_workgroup = 1 : i64} {
  %item = wave.workitem_id 0 : !wave.simd<i32, 64>
  %one = wave.constant 1 : i32 -> !wave.simd<i32, 64>
  %next = wave.binary addi %item, %one
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
  %indices = wave.pack %item, %next
      : !wave.simd<i32, 64>, !wave.simd<i32, 64>
      -> !wave.simd<vector<2xi32>, 64>
  %value, %read = wave.gather %src0, %src1 mapping
      <base = <"idx - item">, bit_offset = <"32 * item">>
      bindings []() packet_bindings ["idx"](%indices)
      : (!wave.ptr<#wave.global, i32>, !wave.ptr<#wave.global, i32>,
         !wave.simd<vector<2xi32>, 64>)
      -> (!wave.simd<vector<2xi32>, 64>, !wave.mem.token)
  %two = wave.constant 2 : i32 -> !wave.simd<i32, 64>
  %offset = wave.binary muli %item, %two
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
  %out = wave.ptr_add %dst, %offset
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 64>
  %written = wave.store %value -> %out after %read
      : (!wave.simd<vector<2xi32>, 64>,
         !wave.simd<!wave.ptr<#wave.global, i32>, 64>, !wave.mem.token)
      -> !wave.mem.token
  return
}
}
