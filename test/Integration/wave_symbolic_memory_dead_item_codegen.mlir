// RUN: wave-translate --wave-to-amdgpu-asm %s | FileCheck %s
// RUN: wave-translate --wave-to-amdgpu-asm %s \
// RUN:   | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx950 -filetype=obj -o /dev/null

// CHECK-LABEL: symbolic_memory_dead_item_codegen:
// CHECK: buffer_load_dwordx2
// CHECK: buffer_store_dwordx2
// CHECK: s_endpgm

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @symbolic_memory_dead_item_codegen(
    %src: !wave.ptr<#wave.global, i32>,
    %dst: !wave.ptr<#wave.global, i32>)
    attributes {wave.kernel, wave.waves_per_workgroup = 1 : i64} {
  %item = wave.workitem_id 0 : !wave.simd<i32, 64>
  %bounded_item = wave.assume %item as "x"
      [#wave.pred<"x >= 0">, #wave.pred<"x <= 63">]
      : !wave.simd<i32, 64>
  %value, %read = wave.gather %src mapping
      <bit_offset = <"Piecewise((32 * slot, slot < 2), (32 * item, True))">>
      bindings ["item"](%bounded_item)
      : (!wave.ptr<#wave.global, i32>, !wave.simd<i32, 64>)
      -> (!wave.simd<vector<2xi32>, 64>, !wave.mem.token)
  %zero = wave.constant 0 : i32 -> !wave.simd<i32, 64>
  %out = wave.ptr_add %dst, %zero
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 64>
  %written = wave.store %value -> %out after %read
      : (!wave.simd<vector<2xi32>, 64>,
         !wave.simd<!wave.ptr<#wave.global, i32>, 64>, !wave.mem.token)
      -> !wave.mem.token
  return
}
}
