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

// ASM-LABEL: reassociable_f32_reduction:
// ASM-COUNT-3: v_pk_add_f32
// ASM: v_add_f32
// ASM: buffer_store_dword
// ASM: s_endpgm
func.func @reassociable_f32_reduction(
    %dst: !wave.ptr<#wave.global, f32>,
    %a: f32, %b: f32, %c: f32, %d: f32,
    %e: f32, %f: f32, %g: f32, %h: f32) attributes {wave.kernel} {
  %range = arith.constant 4096 : i32
  %buffer = waveamd.make_buffer %dst, %range
      : !wave.ptr<#wave.global, f32>, i32
      -> !wave.ptr<#waveamd.buffer, f32>
  %lane = wave.lane_id : !wave.simd<i32, 64>
  %ptr = wave.ptr_add %buffer, %lane
      : !wave.ptr<#waveamd.buffer, f32>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#waveamd.buffer, f32>, 64>
  %va = wave.splat %a : f32 -> !wave.simd<f32, 64>
  %vb = wave.splat %b : f32 -> !wave.simd<f32, 64>
  %vc = wave.splat %c : f32 -> !wave.simd<f32, 64>
  %vd = wave.splat %d : f32 -> !wave.simd<f32, 64>
  %ve = wave.splat %e : f32 -> !wave.simd<f32, 64>
  %vf = wave.splat %f : f32 -> !wave.simd<f32, 64>
  %vg = wave.splat %g : f32 -> !wave.simd<f32, 64>
  %vh = wave.splat %h : f32 -> !wave.simd<f32, 64>
  %s0 = wave.fadd %va, %vb fastmath<reassoc>
      : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
  %s1 = wave.fadd %s0, %vc fastmath<reassoc>
      : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
  %s2 = wave.fadd %s1, %vd fastmath<reassoc>
      : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
  %s3 = wave.fadd %s2, %ve fastmath<reassoc>
      : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
  %s4 = wave.fadd %s3, %vf fastmath<reassoc>
      : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
  %s5 = wave.fadd %s4, %vg fastmath<reassoc>
      : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
  %result = wave.fadd %s5, %vh fastmath<reassoc>
      : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
  %token = wave.store %result -> %ptr
      : (!wave.simd<f32, 64>,
         !wave.simd<!wave.ptr<#waveamd.buffer, f32>, 64>)
      -> !wave.mem.token
  return
}

}
