// RUN: wave-opt %s \
// RUN:   --pass-pipeline='builtin.module(transform-preload-library{transform-library-paths=%wave_pipelines},transform-interpreter{entry-point=waveamd_backend_unscheduled})' \
// RUN:   > %t.mlir
// RUN: FileCheck %s --check-prefix=IR < %t.mlir
// RUN: env WAVE_PIPELINES_DIR=%S/../Target/Wave/Inputs/emit-only-pipeline \
// RUN:   wave-translate --wave-to-amdgpu-asm %t.mlir > %t.s
// RUN: FileCheck %s --check-prefix=ASM \
// RUN:   --implicit-check-not=HW_REG_WAVE_SCHED_MODE < %t.s
// RUN: llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx1250 \
// RUN:   -filetype=obj %t.s -o %t.o 2> %t.mc.err
// RUN: not grep -i warning %t.mc.err
// RUN: ld.lld -shared %t.o -o %t.hsaco
// RUN: llvm-objdump -d --mcpu=gfx1250 %t.hsaco \
// RUN:   | FileCheck %s --check-prefix=DIS \
// RUN:       --implicit-check-not=HW_REG_WAVE_SCHED_MODE

// IR-LABEL: func.func @gfx1250_wmma_f16_threeaddr(
// IR: [[F16:%.*]] = waveamdmachine.wmma_f32_16x16x32_f16
// IR: waveamdmachine.tuple_to_elements [[F16]]
// IR-LABEL: func.func @gfx1250_wmma_bf16_immediate(
// IR: [[BF16:%.*]] = waveamdmachine.wmma_f32_16x16x32_bf16
// IR-SAME: !waveamdmachine.imm
// IR: waveamdmachine.tuple_to_elements [[BF16]]

// ASM-LABEL: gfx1250_wmma_f16_threeaddr:
// ASM: v_wmma_f32_16x16x32_f16 [[F16_D:v\[[0-9]+:[0-9]+\]]], [[F16_A:v\[[0-9]+:[0-9]+\]]], [[F16_B:v\[[0-9]+:[0-9]+\]]], [[F16_C:v\[[0-9]+:[0-9]+\]]]
// ASM: buffer_store_b128
// ASM-LABEL: gfx1250_wmma_bf16_immediate:
// ASM: v_wmma_f32_16x16x32_bf16 [[BF16_D:v\[[0-9]+:[0-9]+\]]], [[BF16_A:v\[[0-9]+:[0-9]+\]]], [[BF16_B:v\[[0-9]+:[0-9]+\]]], 0
// ASM: buffer_store_b32

// DIS-LABEL: <gfx1250_wmma_f16_threeaddr>:
// DIS: v_wmma_f32_16x16x32_f16
// DIS: buffer_store_b128
// DIS-LABEL: <gfx1250_wmma_bf16_immediate>:
// DIS: v_wmma_f32_16x16x32_bf16
// DIS: buffer_store_b32

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1250"} {

func.func @gfx1250_wmma_f16_threeaddr(%out: !wave.ptr<#wave.global, i32>)
    attributes {wave.kernel} {
  %zero = arith.constant 0 : i32
  %b_bits = arith.constant 1006648320 : i32
  %one = arith.constant 1065353216 : i32
  %a = waveamd.fragment_fill %zero
      : i32 -> !waveamd.fragment<0, f16, 16, 16, 32, 8>
  %b = waveamd.fragment_fill %b_bits
      : i32 -> !waveamd.fragment<1, f16, 16, 16, 32, 8>
  %acc = waveamd.fragment_fill %one
      : i32 -> !waveamd.fragment<2, f32, 16, 16, 32, 8>
  %result = waveamd.mma "wmma.f32.16x16x32.f16" %a, %b, %acc
      : !waveamd.fragment<0, f16, 16, 16, 32, 8>,
        !waveamd.fragment<1, f16, 16, 16, 32, 8>,
        !waveamd.fragment<2, f32, 16, 16, 32, 8>
     -> !waveamd.fragment<2, f32, 16, 16, 32, 8>
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %step = arith.constant 8 : i32
  %step_simd = wave.splat %step : i32 -> !wave.simd<i32, 32>
  %offset = wave.binary muli %lane, %step_simd
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %ptrs = wave.ptr_add %out, %offset
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %regs = waveamd.fragment_unpack %result
      : !waveamd.fragment<2, f32, 16, 16, 32, 8>
      -> !wave.simd<vector<8xi32>, 32>
  %stored = wave.store %regs -> %ptrs
      : (!wave.simd<vector<8xi32>, 32>,
         !wave.simd<!wave.ptr<#wave.global, i32>, 32>) -> !wave.mem.token
  return
}

func.func @gfx1250_wmma_bf16_immediate(%out: !wave.ptr<#wave.global, i32>)
    attributes {wave.kernel} {
  %zero = arith.constant 0 : i32
  %a = waveamd.fragment_fill %zero
      : i32 -> !waveamd.fragment<0, bf16, 16, 16, 32, 8>
  %b = waveamd.fragment_fill %zero
      : i32 -> !waveamd.fragment<1, bf16, 16, 16, 32, 8>
  %acc = waveamd.fragment_fill %zero
      : i32 -> !waveamd.fragment<2, f32, 16, 16, 32, 8>
  %result = waveamd.mma "wmma.f32.16x16x32.bf16" %a, %b, %acc
      : !waveamd.fragment<0, bf16, 16, 16, 32, 8>,
        !waveamd.fragment<1, bf16, 16, 16, 32, 8>,
        !waveamd.fragment<2, f32, 16, 16, 32, 8>
     -> !waveamd.fragment<2, f32, 16, 16, 32, 8>
  %regs = waveamd.fragment_unpack %result
      : !waveamd.fragment<2, f32, 16, 16, 32, 8>
      -> !wave.simd<vector<8xi32>, 32>
  %last = wave.extract %regs[7]
      : !wave.simd<vector<8xi32>, 32> -> !wave.simd<i32, 32>
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %ptrs = wave.ptr_add %out, %lane
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %stored = wave.store %last -> %ptrs
      : (!wave.simd<i32, 32>,
         !wave.simd<!wave.ptr<#wave.global, i32>, 32>) -> !wave.mem.token
  return
}

}
