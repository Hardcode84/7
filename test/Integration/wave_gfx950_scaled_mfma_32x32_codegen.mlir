// RUN: wave-opt %s --pass-pipeline='builtin.module(transform-preload-library{transform-library-paths=%wave_pipelines},transform-interpreter{entry-point=waveamd_backend})' \
// RUN:   | env WAVE_PIPELINES_DIR=%S/../Target/Wave/Inputs/emit-only-pipeline wave-translate --wave-to-amdgpu-asm - \
// RUN:   | FileCheck %s --check-prefix=ASM
// RUN: wave-opt %s --pass-pipeline='builtin.module(transform-preload-library{transform-library-paths=%wave_pipelines},transform-interpreter{entry-point=waveamd_backend})' \
// RUN:   | env WAVE_PIPELINES_DIR=%S/../Target/Wave/Inputs/emit-only-pipeline wave-translate --wave-to-amdgpu-asm - \
// RUN:   | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx950 -filetype=obj -o /dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// ASM-LABEL: scaled_mfma_32x32_codegen:
// ASM: v_mfma_scale_f32_32x32x64_f8f6f4
// ASM: .amdhsa_kernel scaled_mfma_32x32_codegen
func.func @scaled_mfma_32x32_codegen(
    %out: !wave.ptr<#wave.global, i32>) attributes {wave.kernel} {
  %zero = arith.constant 0 : i32
  %scale_bits = arith.constant 2139062143 : i32
  %scale = wave.splat %scale_bits : i32 -> !wave.simd<i32, 64>
  %a = waveamd.fragment_fill %zero
      : i32 -> !waveamd.fragment<0, i8, 32, 32, 64, 4>
  %b = waveamd.fragment_fill %zero
      : i32 -> !waveamd.fragment<1, i8, 32, 32, 64, 4>
  %acc = waveamd.fragment_fill %zero
      : i32 -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
  %result = waveamd.mma_scale "mfma.scale.f32.32x32x64.f4.f4"
      %a, %scale, %b, %scale, %acc
      {scale_idx_a = 2 : i64, scale_idx_b = 3 : i64}
      : !waveamd.fragment<0, i8, 32, 32, 64, 4>,
        !wave.simd<i32, 64>,
        !waveamd.fragment<1, i8, 32, 32, 64, 4>,
        !wave.simd<i32, 64>,
        !waveamd.fragment<2, f32, 32, 32, 64, 16>
     -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
  %lane = wave.lane_id : !wave.simd<i32, 64>
  %sixteen = arith.constant 16 : i32
  %sixteen_simd = wave.splat %sixteen : i32 -> !wave.simd<i32, 64>
  %lane_off = wave.binary muli %lane, %sixteen_simd
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
  %tuple_ptr = wave.ptr_add %out, %lane_off
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 64>
  %regs = waveamd.fragment_unpack %result
      : !waveamd.fragment<2, f32, 32, 32, 64, 16>
      -> !wave.simd<vector<16xi32>, 64>
  %store_token = wave.store %regs -> %tuple_ptr
      : (!wave.simd<vector<16xi32>, 64>,
         !wave.simd<!wave.ptr<#wave.global, i32>, 64>) -> !wave.mem.token
  return
}

}
