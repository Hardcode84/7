// RUN: wave-translate --wave-to-amdgpu-asm %s | FileCheck %s
// RUN: wave-translate --wave-to-amdgpu-asm %s \
// RUN:   | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx1100 -filetype=obj -o /dev/null

// CHECK-LABEL: def_local_address_arithmetic_codegen:
// CHECK: global_load_b32
// CHECK: s_waitcnt vmcnt(0)
// CHECK: global_store_b32
// CHECK: s_endpgm

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
func.func @def_local_address_arithmetic_codegen(
    %src: !wave.ptr<#wave.global, i32>,
    %dst: !wave.ptr<#wave.global, i32>, %base: i32)
    attributes {wave.kernel, wave.workgroup_size = array<i32: 32, 1, 1>,
                wave.waves_per_workgroup = 1 : i64} {
  %lane = wave.workitem_id 0 : !wave.simd<i32, 32>
  %base_splat = wave.splat %base : i32 -> !wave.simd<i32, 32>
  %c1 = arith.constant 1 : i32
  %c2 = arith.constant 2 : i32
  %one = wave.splat %c1 : i32 -> !wave.simd<i32, 32>
  %two = wave.splat %c2 : i32 -> !wave.simd<i32, 32>
  %scaled = wave.binary muli %lane, %two overflow<nsw>
      : !wave.simd<i32, 32>, !wave.simd<i32, 32>
      -> !wave.simd<i32, 32>
  %shifted = wave.binary shli %scaled, %one overflow<nsw>
      : !wave.simd<i32, 32>, !wave.simd<i32, 32>
      -> !wave.simd<i32, 32>
  %offset = wave.binary addi %base_splat, %shifted overflow<nsw>
      : !wave.simd<i32, 32>, !wave.simd<i32, 32>
      -> !wave.simd<i32, 32>
  %src_ptr = wave.ptr_add %src, %offset
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %value, %read = wave.load %src_ptr
      : (!wave.simd<!wave.ptr<#wave.global, i32>, 32>)
      -> (!wave.simd<i32, 32>, !wave.mem.token)
  %dst_ptr = wave.ptr_add %dst, %offset
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %written = wave.store %value -> %dst_ptr after %read
      : (!wave.simd<i32, 32>,
         !wave.simd<!wave.ptr<#wave.global, i32>, 32>, !wave.mem.token)
      -> !wave.mem.token
  return
}
}
