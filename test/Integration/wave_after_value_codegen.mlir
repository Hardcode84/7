// RUN: wave-translate --wave-to-amdgpu-asm %s | FileCheck %s
// RUN: wave-translate --wave-to-amdgpu-asm %s \
// RUN:   | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx1100 -filetype=obj -o /dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// CHECK-LABEL: after_global_value:
// CHECK: buffer_load_b32
// CHECK: s_waitcnt vmcnt(0)
// CHECK-NEXT: s_barrier
func.func @after_global_value(%src: !wave.ptr<#wave.global, i32>)
    attributes {wave.kernel} {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %ptr = wave.ptr_add %src, %lane
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %value, %read = wave.load %ptr
      : (!wave.simd<!wave.ptr<#wave.global, i32>, 32>)
      -> (!wave.simd<i32, 32>, !wave.mem.token)
  %ordered = wave.after %value : !wave.simd<i32, 32> -> !wave.mem.token
  %ready = wave.barrier %ordered : (!wave.mem.token) -> !wave.mem.token
  return
}

// CHECK-LABEL: after_lds_value:
// CHECK: ds_store_b32
// CHECK: ds_load_b32
// CHECK: s_waitcnt lgkmcnt(0)
// CHECK-NEXT: s_barrier
func.func @after_lds_value()
    attributes {wave.kernel, wave.lds_size = 128 : i64} {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %base = wave.shared_memory_base : !wave.ptr<#wave.shared, i32>
  %ptr = wave.ptr_add %base, %lane
      : !wave.ptr<#wave.shared, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.shared, i32>, 32>
  %written = wave.store %lane -> %ptr
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.shared, i32>, 32>)
      -> !wave.mem.token
  %value, %read = wave.load %ptr after %written
      : (!wave.simd<!wave.ptr<#wave.shared, i32>, 32>, !wave.mem.token)
      -> (!wave.simd<i32, 32>, !wave.mem.token)
  %ordered = wave.after %value : !wave.simd<i32, 32> -> !wave.mem.token
  %ready = wave.barrier %ordered : (!wave.mem.token) -> !wave.mem.token
  return
}
}
