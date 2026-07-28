// RUN: wave-opt %s --pass-pipeline='builtin.module(transform-preload-library{transform-library-paths=%wave_pipelines},transform-interpreter{entry-point=waveamd_backend})' \
// RUN:   | env WAVE_PIPELINES_DIR=%S/../Target/Wave/Inputs/emit-only-pipeline wave-translate --wave-to-amdgpu-asm - \
// RUN:   | FileCheck %s --check-prefix=ASM
// RUN: wave-opt %s --pass-pipeline='builtin.module(transform-preload-library{transform-library-paths=%wave_pipelines},transform-interpreter{entry-point=waveamd_backend})' \
// RUN:   | env WAVE_PIPELINES_DIR=%S/../Target/Wave/Inputs/emit-only-pipeline wave-translate --wave-to-amdgpu-asm - \
// RUN:   | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx950 -filetype=obj -o /dev/null

module attributes {
  waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950",
  wavemeta.params = {}
} {

// ASM-LABEL: sched_barrier_packed_math:
// ASM-NOT: v_pk_add_f32
// ASM-COUNT-3: v_add_f32
// ASM: buffer_store_dword
// ASM: s_endpgm
func.func @sched_barrier_packed_math(
    %dst: !wave.ptr<#wave.global, f32>,
    %a0: f32, %a1: f32, %b0: f32, %b1: f32)
    attributes {wave.kernel, wave.workgroup_size = array<i32: 64, 1, 1>} {
  %range = arith.constant 256 : i32
  %buffer = waveamd.make_buffer %dst, %range
      : !wave.ptr<#wave.global, f32>, i32
      -> !wave.ptr<#waveamd.buffer, f32>
  %lane = wave.lane_id : !wave.simd<i32, 64>
  %ptr = wave.ptr_add %buffer, %lane
      : !wave.ptr<#waveamd.buffer, f32>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#waveamd.buffer, f32>, 64>
  %va0 = wave.splat %a0 : f32 -> !wave.simd<f32, 64>
  %va1 = wave.splat %a1 : f32 -> !wave.simd<f32, 64>
  %vb0 = wave.splat %b0 : f32 -> !wave.simd<f32, 64>
  %vb1 = wave.splat %b1 : f32 -> !wave.simd<f32, 64>
  %left = wave.fadd %va0, %vb0
      : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
  wave.sched_barrier
  %right = wave.fadd %va1, %vb1
      : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
  %sum = wave.fadd %left, %right
      : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
  %token = wave.store %sum -> %ptr
      : (!wave.simd<f32, 64>,
         !wave.simd<!wave.ptr<#waveamd.buffer, f32>, 64>)
      -> !wave.mem.token
  return
}

}
