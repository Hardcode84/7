// RUN: wave-translate --wave-to-amdgpu-asm %s | FileCheck %s --check-prefix=ASM
// RUN: wave-translate --wave-to-amdgpu-asm %s \
// RUN:   | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx950 -filetype=obj -o /dev/null

// ASM-LABEL: symbolic_memory_3d:
// ASM: v_and_b32_e32
// ASM: v_bfe_u32
// ASM: v_bfe_u32
// ASM: buffer_load_dword
// ASM: buffer_store_dword
// ASM: .amdhsa_system_vgpr_workitem_id 2

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @symbolic_memory_3d(
    %src: !wave.ptr<#wave.global, i32>,
    %dst: !wave.ptr<#wave.global, i32>)
    attributes {wave.kernel,
                wave.workgroup_size = array<i32: 16, 2, 2>,
                wave.waves_per_workgroup = 1 : i64} {
  %item_x = wave.workitem_id 0 : !wave.simd<i32, 64>
  %item_y = wave.workitem_id 1 : !wave.simd<i32, 64>
  %item_z = wave.workitem_id 2 : !wave.simd<i32, 64>
  %c16 = wave.constant 16 : i32 -> !wave.simd<i32, 64>
  %c32 = wave.constant 32 : i32 -> !wave.simd<i32, 64>
  %item_y_scaled = wave.binary muli %item_y, %c16 overflow<nsw>
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
  %item_z_scaled = wave.binary muli %item_z, %c32 overflow<nsw>
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
  %item_xy = wave.binary addi %item_x, %item_y_scaled overflow<nsw>
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
  %item = wave.binary addi %item_xy, %item_z_scaled overflow<nsw>
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
  %bounded_item = wave.assume %item as "x"
      [#wave.pred<"x >= 0">, #wave.pred<"x <= 63">]
      : !wave.simd<i32, 64>
  %value, %read = wave.gather %src mapping
      <bit_offset = <"32 * item">>
      bindings ["item"](%bounded_item)
      : (!wave.ptr<#wave.global, i32>, !wave.simd<i32, 64>)
      -> (!wave.simd<vector<1xi32>, 64>, !wave.mem.token)
  %written = wave.scatter %value to %dst mapping
      <bit_offset = <"32 * item">>
      bindings ["item"](%bounded_item) after %read
      : (!wave.simd<vector<1xi32>, 64>, !wave.ptr<#wave.global, i32>,
         !wave.simd<i32, 64>, !wave.mem.token)
      -> !wave.mem.token
  return
}
}
