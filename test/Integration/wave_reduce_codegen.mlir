// RUN: wave-opt --wave-lower-redistribute %s \
// RUN:   | FileCheck %s --check-prefix=LOWER
// RUN: wave-translate --wave-to-amdgpu-asm %s | FileCheck %s --check-prefix=ASM
// RUN: wave-translate --wave-to-amdgpu-asm %s \
// RUN:   | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx950 -filetype=obj -o /dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// ASM-LABEL: reduce_ordered_cross_wave:
// ASM: buffer_load_dwordx3
// ASM: ds_write_b32
// ASM: v_xad_u32
// ASM: s_barrier
// ASM: ds_read_b32
// ASM: v_xad_u32
// ASM: v_add3_u32
// ASM: buffer_store_dword
// ASM: .amdhsa_group_segment_fixed_size 512
// LOWER-LABEL: func.func @reduce_ordered_cross_wave(
// LOWER: %[[SOURCE:.*]], %[[READ:.*]] = wave.load
// LOWER-NOT: wave.reduce
// LOWER-NOT: wave.redistribute
// LOWER-NOT: waveamd.
// LOWER: %[[FIRST:.*]] = wave.binary subi
// LOWER-NOT: wave.reduce
// LOWER-NOT: wave.redistribute
// LOWER-NOT: waveamd.
// LOWER: %[[RESULT:.*]] = wave.binary subi %[[FIRST]],
// LOWER-NOT: wave.reduce
// LOWER-NOT: wave.redistribute
// LOWER-NOT: waveamd.
// LOWER: wave.store %[[RESULT]] {{.*}} after %[[READ]]
// LOWER-NOT: wave.reduce
// LOWER-NOT: wave.redistribute
// LOWER-NOT: waveamd.
// LOWER: return
func.func @reduce_ordered_cross_wave(
    %src: !wave.ptr<#wave.global, i32>,
    %dst: !wave.ptr<#wave.global, i32>)
    attributes {wave.kernel,
                wave.workgroup_size = array<i32: 128, 1, 1>,
                wave.waves_per_workgroup = 2 : i64} {
  %item = wave.workitem_id 0 : !wave.simd<i32, 64>
  %src_ptr = wave.ptr_add %src, %item
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 64>
  %source, %read = wave.load %src_ptr
      : (!wave.simd<!wave.ptr<#wave.global, i32>, 64>)
      -> (!wave.simd<vector<3xi32>, 64>, !wave.mem.token)
  %result = wave.reduce %source using
      #wave.redistribution<blocks = 1, items = 128, source_block = "block",
                           source_item = "xor(item, 64 * Mod(reduction, 2))",
                           source_slot = "reduction">
      extent 3 : !wave.simd<vector<3xi32>, 64> -> !wave.simd<i32, 64> {
    ^bb0(%lhs: !wave.simd<i32, 64>, %rhs: !wave.simd<i32, 64>):
      %difference = wave.binary subi %lhs, %rhs
          : !wave.simd<i32, 64>, !wave.simd<i32, 64>
          -> !wave.simd<i32, 64>
      wave.yield %difference : !wave.simd<i32, 64>
    }
  %ptr = wave.ptr_add %dst, %item
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 64>
  %token = wave.store %result -> %ptr after %read
      : (!wave.simd<i32, 64>, !wave.simd<!wave.ptr<#wave.global, i32>, 64>,
         !wave.mem.token)
      -> !wave.mem.token
  return
}

}
