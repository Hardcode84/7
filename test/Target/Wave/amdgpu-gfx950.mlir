// RUN: wave-translate --wave-to-amdgpu-asm %s | FileCheck %s
// RUN: wave-translate --wave-to-amdgpu-asm %s | FileCheck %s --check-prefix=META
// RUN: wave-translate --wave-to-amdgpu-asm %s | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx950 -filetype=obj -o /dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
// CHECK: .amdgcn_target "amdgcn-amd-amdhsa--gfx950"

// CHECK-LABEL: buffer_store_kernel:
// CHECK: s_load_dwordx2 s[2:3], s[0:1], 0x0
// CHECK: s_waitcnt lgkmcnt(0)
// CHECK: s_branch [[ENTRY:.*kernarg_preload_entry]]
// CHECK: .p2align 8
// CHECK: [[ENTRY]]:
// CHECK-NOT: s_load_dword
// CHECK: buffer_store_dword
// CHECK-NOT: s_waitcnt
// CHECK: s_endpgm
func.func @buffer_store_kernel(%out: !wave.ptr<#wave.global, i32>)
    attributes {wave.kernel} {
  %range = arith.constant 128 : i32
  %buffer = waveamd.make_buffer %out, %range
      : !wave.ptr<#wave.global, i32>, i32 -> !wave.ptr<#waveamd.buffer, i32>
  %wi_raw = wave.workitem_id 0 : !wave.simd<i32, 64>
  %wi = wave.assume %wi_raw as "x" [#wave.pred<"x >= 0">, #wave.pred<"x <= 63">] : !wave.simd<i32, 64>
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
// CHECK: .amdhsa_accum_offset 4

// CHECK-LABEL: large_agpr_descriptor:
// CHECK: v_accvgpr_read_b32 v167, a95
// CHECK: global_store_dword v0, v167, s[0:1]
// CHECK: s_endpgm
// CHECK: .amdhsa_kernel large_agpr_descriptor
// CHECK: .amdhsa_next_free_vgpr 264
// CHECK: .amdhsa_accum_offset 168
// CHECK: .set .Llarge_agpr_descriptor.num_vgpr, 168
// CHECK: .set .Llarge_agpr_descriptor.num_agpr, 96
// META: .max_flat_workgroup_size: 512
// META-NEXT: .name:           large_agpr_descriptor
// META: .vgpr_count:     264
// META-NEXT: .agpr_count:     96
func.func @large_agpr_descriptor()
    attributes {wave.kernel, wave.workgroup_size = array<i32: 512, 1, 1>} {
  %off = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, 0>
  %base = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 2, 0>
  %agpr_hi = waveamdmachine.uninit : !waveamdmachine.reg<agpr, 1, 95>
  %value = waveamdmachine.v_accvgpr_read_b32_tuple %agpr_hi
      : (!waveamdmachine.reg<agpr, 1, 95>) -> !waveamdmachine.reg<vgpr, 1, 167>
  %token = waveamdmachine.global_store_b32 %off, %value, %base
      : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.reg<vgpr, 1, 167>,
         !waveamdmachine.reg<sgpr, 2, 0>) -> !waveamdmachine.mem.token
  waveamdmachine.s_endpgm
  return
}

// CHECK-LABEL: lds_echo_kernel:
// CHECK: ds_write_b32
// CHECK: s_barrier
// CHECK: ds_read_b32
// CHECK: .wavefront_size: 64
// CHECK: amdhsa.target:   amdgcn-amd-amdhsa--gfx950
func.func @lds_echo_kernel(%out: !wave.ptr<#wave.global, i32>)
    attributes {wave.kernel, wave.lds_size = 256 : i64} {
  %wi_raw = wave.workitem_id 0 : !wave.simd<i32, 64>
  %wi = wave.assume %wi_raw as "x" [#wave.pred<"x >= 0">, #wave.pred<"x <= 63">] : !wave.simd<i32, 64>
  %lds = wave.shared_memory_base : !wave.ptr<#wave.shared, i32>
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
