// RUN: wave-translate --wave-to-amdgpu-asm %s | FileCheck %s
// RUN: wave-translate --wave-to-amdgpu-asm %s | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx950 -filetype=obj -o /dev/null

module attributes {wavemachine.target = "amdgcn-amd-amdhsa--gfx950"} {
// CHECK: .amdgcn_target "amdgcn-amd-amdhsa--gfx950"

// CHECK-LABEL: buffer_store_kernel:
// CHECK: s_load_dwordx2
// CHECK: v_mbcnt_lo_u32_b32
// CHECK: buffer_store_dword
// CHECK: s_waitcnt
// CHECK: s_endpgm
func.func @buffer_store_kernel(%out: !wave.ptr<i32, #wave.global>)
    attributes {wave.kernel} {
  %range = arith.constant 128 : i32
  %buffer = waveamd.make_buffer %out, %range
      : !wave.ptr<i32, #wave.global>, i32 -> !wave.ptr<i32, #waveamd.buffer>
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %ptrs = wave.ptr_add %buffer, %lane
      : !wave.ptr<i32, #waveamd.buffer>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<i32, #waveamd.buffer>, 32>
  %store_token = wave.store %lane -> %ptrs
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<i32, #waveamd.buffer>, 32>)
      -> !wave.mem.token
  return
}
// CHECK: .amdhsa_kernel buffer_store_kernel
// CHECK-NOT: .amdhsa_wavefront_size32
// CHECK: .amdhsa_accum_offset 4

// CHECK-LABEL: masked_store_kernel:
// CHECK: v_cmp_lt_u32
// CHECK: s_mov_b32 {{s[0-9]+}}, vcc_lo
// CHECK: s_mov_b32 {{s[0-9]+}}, exec_lo
// CHECK: s_and_b32 exec_lo, exec_lo,
// CHECK: s_cbranch_execz
func.func @masked_store_kernel(%out: !wave.ptr<i32, #wave.global>, %limit: i32)
    attributes {wave.kernel} {
  %range = arith.constant 128 : i32
  %buffer = waveamd.make_buffer %out, %range
      : !wave.ptr<i32, #wave.global>, i32 -> !wave.ptr<i32, #waveamd.buffer>
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %vlimit = wave.splat %limit : i32 -> !wave.simd<i32, 32>
  %active = wave.cmpi ult %lane, %vlimit
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %ptrs = wave.ptr_add %buffer, %lane
      : !wave.ptr<i32, #waveamd.buffer>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<i32, #waveamd.buffer>, 32>
  wave.where %active {
    %store_token = wave.store %lane -> %ptrs
        : (!wave.simd<i32, 32>,
           !wave.simd<!wave.ptr<i32, #waveamd.buffer>, 32>)
        -> !wave.mem.token
    wave.yield
  } : !wave.mask<32>
  return
}

// CHECK-LABEL: lds_echo_kernel:
// CHECK: ds_write_b32
// CHECK: s_barrier
// CHECK: ds_read_b32
// CHECK: amdhsa.target:   amdgcn-amd-amdhsa--gfx950
func.func @lds_echo_kernel(%out: !wave.ptr<i32, #wave.global>)
    attributes {wave.kernel, wave.lds_size = 128 : i64} {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %lds = wave.lds_base : !wave.ptr<i32, #wave.shared>
  %lds_ptrs = wave.ptr_add %lds, %lane
      : !wave.ptr<i32, #wave.shared>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<i32, #wave.shared>, 32>
  %store_token = wave.store %lane -> %lds_ptrs
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<i32, #wave.shared>, 32>)
      -> !wave.mem.token
  %barrier_token = wave.barrier %store_token : (!wave.mem.token) -> !wave.mem.token
  %loaded:2 = wave.load %lds_ptrs after %barrier_token
      : (!wave.simd<!wave.ptr<i32, #wave.shared>, 32>, !wave.mem.token)
      -> (!wave.simd<i32, 32>, !wave.mem.token)
  %out_ptrs = wave.ptr_add %out, %lane
      : !wave.ptr<i32, #wave.global>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<i32, #wave.global>, 32>
  %final_token = wave.store %loaded#0 -> %out_ptrs after %loaded#1
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<i32, #wave.global>, 32>,
         !wave.mem.token)
      -> !wave.mem.token
  return
}
}
