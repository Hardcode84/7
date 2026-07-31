// RUN: wave-opt --wave-lower-redistribute %s \
// RUN:   | FileCheck %s --check-prefix=LOWER
// RUN: wave-translate --wave-to-amdgpu-asm %s | FileCheck %s --check-prefix=ASM
// RUN: wave-translate --wave-to-amdgpu-asm %s \
// RUN:   | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx1100 -filetype=obj -o /dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// ASM-LABEL: reduce_ordered_cross_wave:
// ASM: ds_store_b32
// ASM: s_barrier
// ASM: ds_load_b32
// ASM: v_xad_u32
// ASM: v_add3_u32
// ASM: buffer_store_b32
// ASM: .amdhsa_group_segment_fixed_size 256
// LOWER-LABEL: func.func @reduce_ordered_cross_wave(
// LOWER-NOT: wave.reduce
// LOWER-NOT: wave.redistribute
// LOWER-NOT: waveamd.
// LOWER: %[[FIRST:.*]] = wave.binary subi
// LOWER-NOT: wave.reduce
// LOWER-NOT: wave.redistribute
// LOWER-NOT: waveamd.
// LOWER: wave.binary subi %[[FIRST]],
// LOWER-NOT: wave.reduce
// LOWER-NOT: wave.redistribute
// LOWER-NOT: waveamd.
// LOWER: wave.store
// LOWER-NOT: wave.reduce
// LOWER-NOT: wave.redistribute
// LOWER-NOT: waveamd.
// LOWER: return
func.func @reduce_ordered_cross_wave(
    %dst: !wave.ptr<#wave.global, i32>)
    attributes {wave.kernel,
                wave.workgroup_size = array<i32: 64, 1, 1>,
                wave.waves_per_workgroup = 2 : i64} {
  %item = wave.workitem_id 0 : !wave.simd<i32, 32>
  %one = wave.constant 1 : i32 -> !wave.simd<i32, 32>
  %next = wave.binary addi %item, %one
      : !wave.simd<i32, 32>, !wave.simd<i32, 32>
      -> !wave.simd<i32, 32>
  %last = wave.binary addi %next, %one
      : !wave.simd<i32, 32>, !wave.simd<i32, 32>
      -> !wave.simd<i32, 32>
  %source = wave.pack %item, %next, %last
      : !wave.simd<i32, 32>, !wave.simd<i32, 32>, !wave.simd<i32, 32>
      -> !wave.simd<vector<3xi32>, 32>
  %result = wave.reduce %source using [
      #wave.redistribution<blocks = 1, items = 64, source_block = "block",
                           source_item = "item", source_slot = "0">,
      #wave.redistribution<blocks = 1, items = 64, source_block = "block",
                           source_item = "xor(item, 32)", source_slot = "1">,
      #wave.redistribution<blocks = 1, items = 64, source_block = "block",
                           source_item = "item", source_slot = "2">
    ] : !wave.simd<vector<3xi32>, 32> -> !wave.simd<i32, 32> {
    ^bb0(%lhs: !wave.simd<i32, 32>, %rhs: !wave.simd<i32, 32>):
      %difference = wave.binary subi %lhs, %rhs
          : !wave.simd<i32, 32>, !wave.simd<i32, 32>
          -> !wave.simd<i32, 32>
      wave.yield %difference : !wave.simd<i32, 32>
    }
  %ptr = wave.ptr_add %dst, %item
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %token = wave.store %result -> %ptr
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.global, i32>, 32>)
      -> !wave.mem.token
  return
}

}
