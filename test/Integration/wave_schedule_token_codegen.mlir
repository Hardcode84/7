// RUN: wave-translate --wave-to-amdgpu-asm %s | FileCheck %s
// RUN: wave-translate --wave-to-amdgpu-asm %s \
// RUN:   | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx1100 -filetype=obj -o /dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// CHECK-LABEL: schedule_global_load:
// CHECK: buffer_load_b32
// CHECK-NOT: s_waitcnt
// CHECK: s_barrier
// CHECK: s_waitcnt vmcnt(0)
// CHECK: buffer_store_b32
func.func @schedule_global_load(%src: !wave.ptr<#wave.global, i32>,
                                %dst: !wave.ptr<#wave.global, i32>)
    -> !wave.mem.token
    attributes {wave.kernel} {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %src_ptr = wave.ptr_add %src, %lane
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %dst_ptr = wave.ptr_add %dst, %lane
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %value, %read = wave.load %src_ptr
      : (!wave.simd<!wave.ptr<#wave.global, i32>, 32>)
      -> (!wave.simd<i32, 32>, !wave.mem.token)
  %ordered = wave.schedule_token %value
      : !wave.simd<i32, 32> -> !wave.mem.token
  %barrier = wave.barrier %ordered : (!wave.mem.token) -> !wave.mem.token
  %written = wave.store %value -> %dst_ptr after %barrier
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.global, i32>, 32>,
         !wave.mem.token) -> !wave.mem.token
  return %written : !wave.mem.token
}

// CHECK-LABEL: schedule_dead_lds_load:
// CHECK: ds_store_b32
// CHECK: s_barrier
// CHECK: s_endpgm
func.func @schedule_dead_lds_load()
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
  %ordered = wave.schedule_token %value
      : !wave.simd<i32, 32> -> !wave.mem.token
  %barrier = wave.barrier %ordered : (!wave.mem.token) -> !wave.mem.token
  return
}

}
