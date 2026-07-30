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

// ASM-LABEL: fp_fusion_fastmath:
// ASM: v_fma_f32
// ASM-NOT: v_mul_f32
// ASM: buffer_store_dword
// ASM: s_endpgm
func.func @fp_fusion_fastmath(
    %dst: !wave.ptr<#wave.global, f32>,
    %a: f32, %b: f32, %c: f32)
    attributes {
      wave.kernel,
      wave.workgroup_size = array<i32: 64, 1, 1>
    } {
  %range = arith.constant 256 : i32
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
  %product = wave.fmul %va, %vb fastmath<contract>
      : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
  %result = wave.fadd %product, %vc fastmath<contract>
      : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
  %token = wave.store %result -> %ptr
      : (!wave.simd<f32, 64>,
         !wave.simd<!wave.ptr<#waveamd.buffer, f32>, 64>)
      -> !wave.mem.token
  return
}

}
