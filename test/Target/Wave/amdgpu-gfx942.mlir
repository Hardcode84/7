// RUN: wave-translate --wave-to-amdgpu-asm %s | FileCheck %s
// RUN: wave-translate --wave-to-amdgpu-asm %s | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx942 -filetype=obj -o /dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx942"} {
// CHECK: .amdgcn_target "amdgcn-amd-amdhsa--gfx942"

// CHECK-LABEL: buffer_store_kernel:
// CHECK-NOT: s_load_dword
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
// CHECK: .amdhsa_user_sgpr_kernarg_preload_length 2
// CHECK: .amdhsa_user_sgpr_kernarg_preload_offset 0
// CHECK-NOT: .amdhsa_wavefront_size32
// CHECK: .wavefront_size: 64
// CHECK: amdhsa.target:   amdgcn-amd-amdhsa--gfx942
}
