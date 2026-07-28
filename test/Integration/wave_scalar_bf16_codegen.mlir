// RUN: wave-opt %s --pass-pipeline='builtin.module(canonicalize{filter-dialects=waveamd},transform-preload-library{transform-library-paths=%wave_pipelines},transform-interpreter{entry-point=waveamd_backend})' \
// RUN:   | env WAVE_PIPELINES_DIR=%S/../Target/Wave/Inputs/emit-only-pipeline wave-translate --wave-to-amdgpu-asm - \
// RUN:   | FileCheck %s --check-prefix=ASM
// RUN: wave-opt %s --pass-pipeline='builtin.module(canonicalize{filter-dialects=waveamd},transform-preload-library{transform-library-paths=%wave_pipelines},transform-interpreter{entry-point=waveamd_backend})' \
// RUN:   | env WAVE_PIPELINES_DIR=%S/../Target/Wave/Inputs/emit-only-pipeline wave-translate --wave-to-amdgpu-asm - \
// RUN:   | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx950 -filetype=obj -o /dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// ASM-LABEL: scalar_bf16_codegen:
// ASM: v_cvt_pk_bf16_f32
// ASM: .amdhsa_kernel scalar_bf16_codegen
func.func @scalar_bf16_codegen(
    %src: !wave.ptr<#wave.global, f32>,
    %dst: !wave.ptr<#wave.global, bf16>) attributes {wave.kernel} {
  %lane = wave.lane_id : !wave.simd<i32, 64>
  %src_ptrs = wave.ptr_add %src, %lane
      : !wave.ptr<#wave.global, f32>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#wave.global, f32>, 64>
  %value, %loaded = wave.load %src_ptrs
      : (!wave.simd<!wave.ptr<#wave.global, f32>, 64>)
      -> (!wave.simd<f32, 64>, !wave.mem.token)
  %bf16 = wave.cast fpconvert %value
      : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
  %dst_ptrs = wave.ptr_add %dst, %lane
      : !wave.ptr<#wave.global, bf16>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#wave.global, bf16>, 64>
  %stored = wave.store %bf16 -> %dst_ptrs after %loaded
      : (!wave.simd<bf16, 64>,
         !wave.simd<!wave.ptr<#wave.global, bf16>, 64>,
         !wave.mem.token) -> !wave.mem.token
  return
}

}
