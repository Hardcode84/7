// RUN: wave-opt --waveamd-to-wavemachine %s | FileCheck %s --check-prefix=SELECT
// RUN: wave-opt --waveamd-to-wavemachine --waveamd-abi-lowering --waveamd-reg-alloc %s | FileCheck %s --check-prefix=PIPELINE
// RUN: wave-translate --wave-to-amdgpu-asm %s | FileCheck %s --check-prefix=ASM
// RUN: wave-translate --wave-to-amdgpu-asm %s | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx950 -filetype=obj -o /dev/null

module attributes {wavemachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// SELECT-LABEL: func.func @mfma_f16xf32_kernel
// SELECT: wavemachine.mfma_f32_16x16x16_f16{{.*}} : (!wavemachine.reg<vgpr, 2>, !wavemachine.reg<vgpr, 2>, !wavemachine.reg<vgpr, 4>) -> !wavemachine.reg<vgpr, 4>

// PIPELINE-LABEL: func.func @mfma_f16xf32_kernel
// PIPELINE: wavemachine.mfma_f32_16x16x16_f16{{.*}} -> !wavemachine.reg<vgpr, 4,

// ASM-LABEL: mfma_f16xf32_kernel:
// ASM: v_mfma_f32_16x16x16_f16 [[DST:v\[[0-9]+:[0-9]+\]]], [[A:v\[[0-9]+:[0-9]+\]]], [[B:v\[[0-9]+:[0-9]+\]]], [[C:v\[[0-9]+:[0-9]+\]]]
// ASM: v_lshlrev_b32_e32 {{v[0-9]+}}, 4, {{v[0-9]+}}
// ASM: global_store_dword {{v[0-9]+}}, {{v[0-9]+}}, {{s\[[0-9]+:[0-9]+\]$}}
// ASM: global_store_dword {{v[0-9]+}}, {{v[0-9]+}}, {{s\[[0-9]+:[0-9]+\]}} offset:4
// ASM: global_store_dword {{v[0-9]+}}, {{v[0-9]+}}, {{s\[[0-9]+:[0-9]+\]}} offset:8
// ASM: global_store_dword {{v[0-9]+}}, {{v[0-9]+}}, {{s\[[0-9]+:[0-9]+\]}} offset:12
// ASM-NOT: offset:16
func.func @mfma_f16xf32_kernel(%out: !wave.ptr<i32, #wave.global>)
    attributes {wave.kernel} {
  %zero = arith.constant 0 : i32
  %a = waveamd.fragment_fill %zero
      : i32 -> !waveamd.fragment<0, f16, 16, 16, 32, 2>
  %b = waveamd.fragment_fill %zero
      : i32 -> !waveamd.fragment<1, f16, 16, 16, 32, 2>
  %acc = waveamd.fragment_fill %zero
      : i32 -> !waveamd.fragment<2, f32, 16, 16, 32, 4>
  %result = waveamd.mma "mfma.f32.16x16x16.f16" %a, %b, %acc
      : !waveamd.fragment<0, f16, 16, 16, 32, 2>,
        !waveamd.fragment<1, f16, 16, 16, 32, 2>,
        !waveamd.fragment<2, f32, 16, 16, 32, 4>
     -> !waveamd.fragment<2, f32, 16, 16, 32, 4>
  %store_token = waveamd.fragment_store %result -> %out
      : (!waveamd.fragment<2, f32, 16, 16, 32, 4>,
         !wave.ptr<i32, #wave.global>) -> !wave.mem.token
  return
}

// ASM-LABEL: gfx950_literal_mul_kernel:
// ASM: v_mov_b32_e32 [[IMM:v[0-9]+]], 0x100
// ASM: v_mul_lo_u32 [[MUL:v[0-9]+]], [[IMM]], {{[vs][0-9]+}}
func.func @gfx950_literal_mul_kernel(%out: !wave.ptr<i32, #wave.global>)
    attributes {wave.kernel} {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %c256 = arith.constant 256 : i32
  %v256 = wave.splat %c256 : i32 -> !wave.simd<i32, 32>
  %value = wave.muli %v256, %lane
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %ptrs = wave.ptr_add %out, %lane
      : !wave.ptr<i32, #wave.global>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<i32, #wave.global>, 32>
  %store_token = wave.store %value -> %ptrs
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<i32, #wave.global>, 32>)
      -> !wave.mem.token
  return
}

}
