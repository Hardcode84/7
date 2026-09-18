// RUN: wave-opt %s --pass-pipeline='builtin.module(transform-preload-library{transform-library-paths=%wave_pipelines},transform-interpreter{entry-point=waveamd_backend_lower})' \
// RUN:   | FileCheck %s --check-prefix=MACHINE
// RUN: wave-translate --wave-to-amdgpu-asm %s | FileCheck %s --check-prefix=ASM
// RUN: wave-translate --wave-to-amdgpu-asm %s \
// RUN:   | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx1100 -filetype=obj -o /dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// MACHINE-LABEL: func.func @proven_true_wave32_where
// MACHINE-NOT: waveamdmachine.v_cmp
// MACHINE-NOT: waveamdmachine.exec_if
// MACHINE: waveamdmachine.buffer_store_b32
// ASM-LABEL: proven_true_wave32_where:
// ASM-NOT: v_cmp
// ASM-NOT: s_and_saveexec_b32
// ASM: buffer_store_b32
func.func @proven_true_wave32_where(%dst: !wave.ptr<#wave.global, i32>) -> !wave.mem.token attributes {wave.kernel} {
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
  %observe_seed_1 = wave.token : !wave.mem.token
  %observe_region_2 = wave.where %active {
    %token = wave.store %lane -> %ptrs
        : (!wave.simd<i32, 32>,
           !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>)
        -> !wave.mem.token
    wave.yield %token : !wave.mem.token
  } otherwise {
    wave.yield %observe_seed_1 : !wave.mem.token
  } : !wave.mask<32> -> !wave.mem.token
  return %observe_region_2 : !wave.mem.token
}

// MACHINE-LABEL: func.func @boolean_select_mask_roundtrip
// MACHINE: [[ACTIVE:%.*]] = waveamdmachine.v_cmp_{{.*}}
// MACHINE: waveamdmachine.v_cndmask
// MACHINE-NOT: waveamdmachine.v_cmp
// MACHINE-NOT: waveamdmachine.exec_if
// ASM-LABEL: boolean_select_mask_roundtrip:
// ASM: v_cmp_{{.*}}
// ASM: v_cndmask
// ASM-NOT: v_cmp
// ASM-NOT: s_and_saveexec_b32
func.func @boolean_select_mask_roundtrip(
    %dst: !wave.ptr<#wave.global, i32>, %limit: i32) -> !wave.mem.token attributes {wave.kernel} {
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
  %observe_seed_5 = wave.token : !wave.mem.token
  %observe_region_6 = wave.where %recovered {
    %token = wave.store %lane -> %ptrs
        : (!wave.simd<i32, 32>,
           !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>)
        -> !wave.mem.token
    wave.yield %token : !wave.mem.token
  } otherwise {
    wave.yield %observe_seed_5 : !wave.mem.token
  } : !wave.mask<32> -> !wave.mem.token
  return %observe_region_6 : !wave.mem.token
}

}
