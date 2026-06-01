// RUN: wave-translate --wave-to-amdgpu-asm %s | FileCheck %s
// RUN: wave-translate --wave-to-amdgpu-asm %s | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx950 -filetype=obj -o /dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
// CHECK: .amdgcn_target "amdgcn-amd-amdhsa--gfx950"

// CHECK-LABEL: buffer_store_kernel:
// CHECK: s_load_dwordx2
// CHECK: buffer_store_dword
// CHECK: s_waitcnt
// CHECK: s_endpgm
func.func @buffer_store_kernel(%out: !wave.ptr<#wave.global, i32>)
    attributes {wave.kernel} {
  %range = arith.constant 128 : i32
  %buffer = waveamd.make_buffer %out, %range
      : !wave.ptr<#wave.global, i32>, i32 -> !wave.ptr<#waveamd.buffer, i32>
  %wi_raw = wave.workitem_id 0 : !wave.simd<i32, 64>
  %wi = wave.assume_range %wi_raw, [0, 63] : !wave.simd<i32, 64>
  %ptrs = wave.ptr_add %buffer, %wi
      : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>
  %store_token = wave.store %wi -> %ptrs
      : (!wave.simd<i32, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>)
      -> !wave.mem.token
  return
}
// CHECK: .amdhsa_kernel buffer_store_kernel
// CHECK-NOT: .amdhsa_wavefront_size32
// CHECK: .amdhsa_accum_offset 4

// CHECK-LABEL: lds_echo_kernel:
// CHECK: ds_write_b32
// CHECK: s_barrier
// CHECK: ds_read_b32
// CHECK: .wavefront_size: 64
// CHECK: amdhsa.target:   amdgcn-amd-amdhsa--gfx950
func.func @lds_echo_kernel(%out: !wave.ptr<#wave.global, i32>)
    attributes {wave.kernel, wave.lds_size = 256 : i64} {
  %wi_raw = wave.workitem_id 0 : !wave.simd<i32, 64>
  %wi = wave.assume_range %wi_raw, [0, 63] : !wave.simd<i32, 64>
  %lds = wave.lds_base : !wave.ptr<#wave.shared, i32>
  %lds_ptrs = wave.ptr_add %lds, %wi
      : !wave.ptr<#wave.shared, i32>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#wave.shared, i32>, 64>
  %store_token = wave.store %wi -> %lds_ptrs
      : (!wave.simd<i32, 64>, !wave.simd<!wave.ptr<#wave.shared, i32>, 64>)
      -> !wave.mem.token
  %barrier_token = wave.barrier %store_token : (!wave.mem.token) -> !wave.mem.token
  %loaded:2 = wave.load %lds_ptrs after %barrier_token
      : (!wave.simd<!wave.ptr<#wave.shared, i32>, 64>, !wave.mem.token)
      -> (!wave.simd<i32, 64>, !wave.mem.token)
  %out_ptrs = wave.ptr_add %out, %wi
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 64>
  %final_token = wave.store %loaded#0 -> %out_ptrs after %loaded#1
      : (!wave.simd<i32, 64>, !wave.simd<!wave.ptr<#wave.global, i32>, 64>,
         !wave.mem.token)
      -> !wave.mem.token
  return
}
}
