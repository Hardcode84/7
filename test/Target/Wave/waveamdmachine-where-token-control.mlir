// RUN: wave-opt --waveamd-to-machine --waveamd-abi-lowering --waveamd-insert-ticket-waits --waveamd-linearize-exec-if %s | FileCheck %s --check-prefix=PIPE
// RUN: wave-translate --wave-to-amdgpu-asm %s | FileCheck %s --check-prefix=ASM
// RUN: wave-translate --wave-to-amdgpu-asm %s | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx1100 -filetype=obj -o /dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// PIPE-LABEL: func.func @masked_load_other_kernel
// PIPE: waveamdmachine.global_load_b32_addr64
// PIPE: waveamdmachine.s_waitcnt
// PIPE-NEXT: waveamdmachine.global_store_b32_addr64
// PIPE: waveamdmachine.label {{".*exec_else.*"}}
// PIPE: waveamdmachine.v_mov_b32_tuple
// PIPE: waveamdmachine.global_store_b32_addr64
// PIPE: waveamdmachine.s_waitcnt_vscnt
// PIPE-NEXT: waveamdmachine.s_endpgm
// ASM-LABEL: masked_load_other_kernel:
// ASM: global_load_b32
// ASM: s_waitcnt vmcnt(0)
// ASM-NEXT: global_store_b32
// ASM: s_and_not1_b32 exec_lo
// ASM: v_mov_b32_e32 {{v[0-9]+}}, 0x40a00000
// ASM-NEXT: global_store_b32
// ASM: s_waitcnt_vscnt null, 0x0
// ASM-NEXT: s_endpgm
func.func @masked_load_other_kernel(
    %src: !wave.ptr<#wave.global, f32>, %dst: !wave.ptr<#wave.global, f32>,
    %limit: i32) attributes {wave.kernel} {
  %c32 = arith.constant 32 : i32
  %five = arith.constant 5.000000e+00 : f32
  %pid = wave.workgroup_id 0
  %base = wave.muli %pid, %c32 : i32, i32 -> i32
  %vbase = wave.splat %base : i32 -> !wave.simd<i32, 32>
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %idx = wave.addi %vbase, %lane
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %vlimit = wave.splat %limit : i32 -> !wave.simd<i32, 32>
  %active = wave.cmpi ult %idx, %vlimit
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %src_off = wave.index_expr <"lid + c32*pid"> ["pid", "c32", "lid"](%pid, %c32, %lane)
      : (i32, i32, !wave.simd<i32, 32>) -> !wave.simd<index, 32>
  %src_ptrs = wave.ptr_add %src, %src_off
      : !wave.ptr<#wave.global, f32>, !wave.simd<index, 32>
      -> !wave.simd<!wave.ptr<#wave.global, f32>, 32>
  %dst_off = wave.index_expr <"lid + c32*pid"> ["pid", "c32", "lid"](%pid, %c32, %lane)
      : (i32, i32, !wave.simd<i32, 32>) -> !wave.simd<index, 32>
  %dst_ptrs = wave.ptr_add %dst, %dst_off
      : !wave.ptr<#wave.global, f32>, !wave.simd<index, 32>
      -> !wave.simd<!wave.ptr<#wave.global, f32>, 32>
  %loaded:2 = wave.where %active {
    %value, %token = wave.load %src_ptrs
        : (!wave.simd<!wave.ptr<#wave.global, f32>, 32>)
        -> (!wave.simd<f32, 32>, !wave.mem.token)
    wave.yield %value, %token : !wave.simd<f32, 32>, !wave.mem.token
  } : !wave.mask<32> -> !wave.simd<f32, 32>, !wave.mem.token
  %stored = wave.where %active {
    %token = wave.store %loaded#0 -> %dst_ptrs after %loaded#1
        : (!wave.simd<f32, 32>, !wave.simd<!wave.ptr<#wave.global, f32>, 32>,
           !wave.mem.token)
        -> !wave.mem.token
    wave.yield %token : !wave.mem.token
  } otherwise {
    %fallback = wave.splat %five : f32 -> !wave.simd<f32, 32>
    %token = wave.store %fallback -> %dst_ptrs
        : (!wave.simd<f32, 32>, !wave.simd<!wave.ptr<#wave.global, f32>, 32>)
        -> !wave.mem.token
    wave.yield %token : !wave.mem.token
  } : !wave.mask<32> -> !wave.mem.token
  return
}

}
