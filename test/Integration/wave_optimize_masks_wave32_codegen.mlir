// RUN: wave-opt %s --pass-pipeline='builtin.module(transform-preload-library{transform-library-paths=%wave_pipelines},transform-interpreter{entry-point=waveamd_backend_lower})' \
// RUN:   | FileCheck %s --check-prefix=MACHINE
// RUN: wave-translate --wave-to-amdgpu-asm %s | FileCheck %s --check-prefix=ASM
// RUN: wave-translate --wave-to-amdgpu-asm %s \
// RUN:   | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx1100 -filetype=obj -o /dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// MACHINE-LABEL: func.func @proven_true_wave32_where
// MACHINE-NOT: waveamdmachine.v_cmp
// MACHINE: waveamdmachine.s_mov_b32_value
// MACHINE: waveamdmachine.exec_if
// MACHINE: waveamdmachine.buffer_store_b32
// ASM-LABEL: proven_true_wave32_where:
// ASM-NOT: v_cmp
// ASM: s_mov_b32 [[COND:s[0-9]+]], -1
// ASM: s_and_saveexec_b32 {{s[0-9]+}}, [[COND]]
func.func @proven_true_wave32_where(%dst: !wave.ptr<#wave.global, i32>)
    attributes {wave.kernel} {
  %range = arith.constant 128 : i32
  %buffer = waveamd.make_buffer %dst, %range
      : !wave.ptr<#wave.global, i32>, i32
      -> !wave.ptr<#waveamd.buffer, i32>
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %c32 = wave.constant 32 : i32 -> !wave.simd<i32, 32>
  %active = wave.cmpi ult %lane, %c32
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %ptrs = wave.ptr_add %buffer, %lane
      : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>
  wave.where %active {
    %token = wave.store %lane -> %ptrs
        : (!wave.simd<i32, 32>,
           !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>)
        -> !wave.mem.token
    wave.yield
  } : !wave.mask<32>
  return
}

// MACHINE-LABEL: func.func @boolean_select_mask_roundtrip
// MACHINE: [[ACTIVE:%.*]] = waveamdmachine.v_cmp_{{.*}}
// MACHINE-NOT: waveamdmachine.v_cndmask
// MACHINE-NOT: waveamdmachine.v_cmp
// MACHINE: waveamdmachine.exec_if [[ACTIVE]]
// ASM-LABEL: boolean_select_mask_roundtrip:
// ASM: v_cmp_{{.*}}
// ASM-NOT: v_cndmask
// ASM-NOT: v_cmp
// ASM: s_and_saveexec_b32
func.func @boolean_select_mask_roundtrip(
    %dst: !wave.ptr<#wave.global, i32>, %limit: i32)
    attributes {wave.kernel} {
  %range = arith.constant 128 : i32
  %buffer = waveamd.make_buffer %dst, %range
      : !wave.ptr<#wave.global, i32>, i32
      -> !wave.ptr<#waveamd.buffer, i32>
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %limit_splat = wave.splat %limit : i32 -> !wave.simd<i32, 32>
  %active = wave.cmpi ult %lane, %limit_splat
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %three = wave.constant 3 : i32 -> !wave.simd<i32, 32>
  %five = wave.constant 5 : i32 -> !wave.simd<i32, 32>
  %seven = wave.constant 7 : i32 -> !wave.simd<i32, 32>
  %encoded = wave.select %active, %seven, %three
      : !wave.mask<32>, !wave.simd<i32, 32>
  %recovered = wave.cmpi sgt %encoded, %five
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %ptrs = wave.ptr_add %buffer, %lane
      : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>
  wave.where %recovered {
    %token = wave.store %lane -> %ptrs
        : (!wave.simd<i32, 32>,
           !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>)
        -> !wave.mem.token
    wave.yield
  } : !wave.mask<32>
  return
}

}
