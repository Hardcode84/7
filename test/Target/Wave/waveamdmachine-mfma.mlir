// RUN: wave-opt --waveamd-to-machine %s | FileCheck %s --check-prefix=SELECT
// RUN: wave-opt --waveamd-to-machine %s | wave-opt | FileCheck %s --check-prefix=SELECT
// RUN: wave-opt --waveamd-to-machine --waveamd-abi-lowering --waveamd-reg-alloc %s | FileCheck %s --check-prefix=PIPELINE
// RUN: wave-translate --wave-to-amdgpu-asm %s | FileCheck %s --check-prefix=ASM
// RUN: wave-translate --wave-to-amdgpu-asm %s | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx950 -filetype=obj -o /dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// SELECT-LABEL: func.func @mfma_gfx950_f16xf32_kernel
// SELECT: waveamdmachine.mfma_f32_16x16x32_f16{{.*}} : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>) -> !waveamdmachine.reg<vgpr, 4>

// PIPELINE-LABEL: func.func @mfma_gfx950_f16xf32_kernel
// PIPELINE: waveamdmachine.mfma_f32_16x16x32_f16{{.*}} -> !waveamdmachine.reg<vgpr, 4,

// ASM-LABEL: mfma_gfx950_f16xf32_kernel:
// ASM: v_mfma_f32_16x16x32_f16 [[DST:v\[[0-9]+:[0-9]+\]]], [[A:v\[[0-9]+:[0-9]+\]]], [[B:v\[[0-9]+:[0-9]+\]]], [[C:v\[[0-9]+:[0-9]+\]]]
func.func @mfma_gfx950_f16xf32_kernel(%out: !wave.ptr<#wave.global, i32>)
    attributes {wave.kernel} {
  %zero = arith.constant 0 : i32
  %a = waveamd.fragment_fill %zero
      : i32 -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
  %b = waveamd.fragment_fill %zero
      : i32 -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
  %acc = waveamd.fragment_fill %zero
      : i32 -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %result = waveamd.mma "mfma.f32.16x16x32.f16" %a, %b, %acc
      : !waveamd.fragment<0, f16, 16, 16, 64, 4>,
        !waveamd.fragment<1, f16, 16, 16, 64, 4>,
        !waveamd.fragment<2, f32, 16, 16, 64, 4>
     -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %wi = wave.workitem_id 0 : !wave.simd<i32, 64>
  %mask = arith.constant 63 : i32
  %mask_simd = wave.splat %mask : i32 -> !wave.simd<i32, 64>
  %lane = wave.binary "andi" %wi, %mask_simd
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
  %r = arith.constant 4 : i32
  %r_simd = wave.splat %r : i32 -> !wave.simd<i32, 64>
  %lane_off = wave.muli %lane, %r_simd
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
  %tuple_ptr = wave.ptr_add %out, %lane_off
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 64>
  %regs = waveamd.fragment_unpack %result
      : !waveamd.fragment<2, f32, 16, 16, 64, 4>
      -> !wave.simd<vector<4xi32>, 64>
  %store_token = wave.store %regs -> %tuple_ptr
      : (!wave.simd<vector<4xi32>, 64>,
         !wave.simd<!wave.ptr<#wave.global, i32>, 64>) -> !wave.mem.token
  return
}

// ASM-LABEL: gfx950_literal_mul_kernel:
// ASM: v_mov_b32_e32 [[IMM:v[0-9]+]], 0x100
// ASM: v_mul_lo_u32 [[MUL:v[0-9]+]], [[IMM]], {{[vs][0-9]+}}
func.func @gfx950_literal_mul_kernel(%out: !wave.ptr<#wave.global, i32>)
    attributes {wave.kernel} {
  %wi_raw = wave.workitem_id 0 : !wave.simd<i32, 64>
  %wi = wave.assume_range %wi_raw, [0, 63] : !wave.simd<i32, 64>
  %c256 = arith.constant 256 : i32
  %v256 = wave.splat %c256 : i32 -> !wave.simd<i32, 64>
  %value = wave.muli %v256, %wi
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
  %ptrs = wave.ptr_add %out, %wi
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 64>
  %store_token = wave.store %value -> %ptrs
      : (!wave.simd<i32, 64>, !wave.simd<!wave.ptr<#wave.global, i32>, 64>)
      -> !wave.mem.token
  return
}

}
