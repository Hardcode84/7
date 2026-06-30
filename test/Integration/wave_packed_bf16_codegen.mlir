// RUN: wave-opt %s --pass-pipeline='builtin.module(canonicalize{filter-dialects=waveamd},transform-preload-library{transform-library-paths=%wave_pipelines},transform-interpreter{entry-point=waveamd_backend})' \
// RUN:   | env WAVE_PIPELINES_DIR=%S/../Target/Wave/Inputs/emit-only-pipeline wave-translate --wave-to-amdgpu-asm - \
// RUN:   | FileCheck %s --check-prefix=ASM
// RUN: wave-opt %s --pass-pipeline='builtin.module(canonicalize{filter-dialects=waveamd},transform-preload-library{transform-library-paths=%wave_pipelines},transform-interpreter{entry-point=waveamd_backend})' \
// RUN:   | env WAVE_PIPELINES_DIR=%S/../Target/Wave/Inputs/emit-only-pipeline wave-translate --wave-to-amdgpu-asm - \
// RUN:   | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx950 -filetype=obj -o /dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// ASM-LABEL: packed_bf16_codegen:
// ASM: v_cvt_pk_bf16_f32
// ASM: .amdhsa_kernel packed_bf16_codegen
func.func @packed_bf16_codegen(%out: !wave.ptr<#wave.global, bf16>)
    attributes {wave.kernel} {
  %c1f = arith.constant 1.000000e+00 : f32
  %c2f = arith.constant 2.000000e+00 : f32
  %a = wave.splat %c1f : f32 -> !wave.simd<f32, 64>
  %b = wave.splat %c2f : f32 -> !wave.simd<f32, 64>
  %src = wave.pack %a, %b
      : !wave.simd<f32, 64>, !wave.simd<f32, 64>
      -> !wave.simd<vector<2xf32>, 64>
  %bf16 = wave.cast fpconvert %src
      : !wave.simd<vector<2xf32>, 64> -> !wave.simd<vector<2xbf16>, 64>
  %lane = wave.lane_id : !wave.simd<i32, 64>
  %ptrs = wave.ptr_add %out, %lane
      : !wave.ptr<#wave.global, bf16>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#wave.global, bf16>, 64>
  %token = wave.store %bf16 -> %ptrs
      : (!wave.simd<vector<2xbf16>, 64>,
         !wave.simd<!wave.ptr<#wave.global, bf16>, 64>) -> !wave.mem.token
  return
}

}
