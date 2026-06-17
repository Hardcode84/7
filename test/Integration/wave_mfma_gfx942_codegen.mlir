// RUN: wave-opt --waveamd-to-machine --waveamd-abi-lowering --waveamd-reg-alloc --waveamd-resource-info %s \
// RUN:   | wave-translate --wave-to-amdgpu-asm - \
// RUN:   | FileCheck %s --check-prefix=ASM
// RUN: wave-opt --waveamd-to-machine --waveamd-abi-lowering --waveamd-reg-alloc --waveamd-resource-info %s \
// RUN:   | wave-translate --wave-to-amdgpu-asm - \
// RUN:   | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx942 -filetype=obj -o /dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx942"} {

// ASM-LABEL: mfma_gfx942_f16_16x16x16_codegen:
// ASM: v_mfma_f32_16x16x16{{.*}}f16
// ASM: .amdhsa_kernel mfma_gfx942_f16_16x16x16_codegen
func.func @mfma_gfx942_f16_16x16x16_codegen(
    %out: !wave.ptr<#wave.global, i32>) attributes {wave.kernel} {
  %zero = arith.constant 0 : i32
  %a = waveamd.fragment_fill %zero
      : i32 -> !waveamd.fragment<0, f16, 16, 16, 64, 2>
  %b = waveamd.fragment_fill %zero
      : i32 -> !waveamd.fragment<1, f16, 16, 16, 64, 2>
  %acc = waveamd.fragment_fill %zero
      : i32 -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %result = waveamd.mma "mfma.f32.16x16x16.f16" %a, %b, %acc
      : !waveamd.fragment<0, f16, 16, 16, 64, 2>,
        !waveamd.fragment<1, f16, 16, 16, 64, 2>,
        !waveamd.fragment<2, f32, 16, 16, 64, 4>
     -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %lane = wave.lane_id : !wave.simd<i32, 64>
  %step = arith.constant 4 : i32
  %step_simd = wave.splat %step : i32 -> !wave.simd<i32, 64>
  %offset = wave.binary muli %lane, %step_simd
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
  %ptrs = wave.ptr_add %out, %offset
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 64>
  %regs = waveamd.fragment_unpack %result
      : !waveamd.fragment<2, f32, 16, 16, 64, 4>
      -> !wave.simd<vector<4xi32>, 64>
  %token = wave.store %regs -> %ptrs
      : (!wave.simd<vector<4xi32>, 64>,
         !wave.simd<!wave.ptr<#wave.global, i32>, 64>) -> !wave.mem.token
  return
}

// ASM-LABEL: mfma_gfx942_bf16_16x16x16_codegen:
// ASM: v_mfma_f32_16x16x16{{.*}}bf16
// ASM: .amdhsa_kernel mfma_gfx942_bf16_16x16x16_codegen
func.func @mfma_gfx942_bf16_16x16x16_codegen(
    %out: !wave.ptr<#wave.global, i32>) attributes {wave.kernel} {
  %zero = arith.constant 0 : i32
  %a = waveamd.fragment_fill %zero
      : i32 -> !waveamd.fragment<0, bf16, 16, 16, 64, 2>
  %b = waveamd.fragment_fill %zero
      : i32 -> !waveamd.fragment<1, bf16, 16, 16, 64, 2>
  %acc = waveamd.fragment_fill %zero
      : i32 -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %result = waveamd.mma "mfma.f32.16x16x16.bf16" %a, %b, %acc
      : !waveamd.fragment<0, bf16, 16, 16, 64, 2>,
        !waveamd.fragment<1, bf16, 16, 16, 64, 2>,
        !waveamd.fragment<2, f32, 16, 16, 64, 4>
     -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %lane = wave.lane_id : !wave.simd<i32, 64>
  %step = arith.constant 4 : i32
  %step_simd = wave.splat %step : i32 -> !wave.simd<i32, 64>
  %offset = wave.binary muli %lane, %step_simd
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
  %ptrs = wave.ptr_add %out, %offset
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 64>
  %regs = waveamd.fragment_unpack %result
      : !waveamd.fragment<2, f32, 16, 16, 64, 4>
      -> !wave.simd<vector<4xi32>, 64>
  %token = wave.store %regs -> %ptrs
      : (!wave.simd<vector<4xi32>, 64>,
         !wave.simd<!wave.ptr<#wave.global, i32>, 64>) -> !wave.mem.token
  return
}

}
