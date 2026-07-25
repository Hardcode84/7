// RUN: wave-opt %s --pass-pipeline='builtin.module(transform-preload-library{transform-library-paths=%wave_pipelines},transform-interpreter{entry-point=waveamd_backend})' \
// RUN:   | env WAVE_PIPELINES_DIR=%S/../Target/Wave/Inputs/emit-only-pipeline wave-translate --wave-to-amdgpu-asm - \
// RUN:   | FileCheck %s --check-prefix=ASM
// RUN: wave-opt %s --pass-pipeline='builtin.module(transform-preload-library{transform-library-paths=%wave_pipelines},transform-interpreter{entry-point=waveamd_backend})' \
// RUN:   | env WAVE_PIPELINES_DIR=%S/../Target/Wave/Inputs/emit-only-pipeline wave-translate --wave-to-amdgpu-asm - \
// RUN:   | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx950 -filetype=obj -o /dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// ASM-LABEL: vcc_exec_mask_codegen:
// ASM: v_cmp_lt_i32_e64 vcc,
// ASM-NEXT: s_and_saveexec_b64 [[SAVE:s\[[0-9]+:[0-9]+\]]], vcc
// ASM-NOT: s_mov_b64 {{.*}}, vcc
// ASM: buffer_store_dword
// ASM: s_mov_b64 exec, [[SAVE]]
// ASM: s_endpgm
func.func @vcc_exec_mask_codegen(
    %out: !wave.ptr<#wave.global, i32>,
    %limit: i32) attributes {wave.kernel} {
  %range = arith.constant 4096 : i32
  %buffer = waveamd.make_buffer %out, %range
      : !wave.ptr<#wave.global, i32>, i32
      -> !wave.ptr<#waveamd.buffer, i32>
  %lane = wave.lane_id : !wave.simd<i32, 64>
  %vlimit = wave.splat %limit : i32 -> !wave.simd<i32, 64>
  %active = wave.cmpi slt %lane, %vlimit
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
  %ptr = wave.ptr_add %buffer, %lane
      : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>
  wave.where %active {
    %stored = wave.store %lane -> %ptr
        : (!wave.simd<i32, 64>,
           !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>)
        -> !wave.mem.token
    wave.yield
  } : !wave.mask<64>
  return
}

// ASM-LABEL: direct_compare_mask_chain_codegen:
// ASM-DAG: v_cmp_lt_i32_e64 [[MASK0:s\[[0-9]+:[0-9]+\]]],
// ASM-DAG: v_cmp_ge_i32_e64 [[MASK1:s\[[0-9]+:[0-9]+\]]],
// ASM: s_and_b64 [[COMBINED:s\[[0-9]+:[0-9]+\]]], [[MASK0]], [[MASK1]]
// ASM-NOT: s_mov_b64 {{.*}}, vcc
// ASM: s_and_saveexec_b64 {{.*}}, [[COMBINED]]
// ASM: buffer_store_dword
// ASM: s_endpgm
func.func @direct_compare_mask_chain_codegen(
    %out: !wave.ptr<#wave.global, i32>,
    %lower: i32,
    %upper: i32) attributes {wave.kernel} {
  %range = arith.constant 4096 : i32
  %buffer = waveamd.make_buffer %out, %range
      : !wave.ptr<#wave.global, i32>, i32
      -> !wave.ptr<#waveamd.buffer, i32>
  %lane = wave.lane_id : !wave.simd<i32, 64>
  %vlower = wave.splat %lower : i32 -> !wave.simd<i32, 64>
  %vupper = wave.splat %upper : i32 -> !wave.simd<i32, 64>
  %below_upper = wave.cmpi slt %lane, %vupper
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
  %at_or_above_lower = wave.cmpi sge %lane, %vlower
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
  %false = wave.constant false -> !wave.mask<64>
  %active = wave.select %below_upper, %at_or_above_lower, %false
      : !wave.mask<64>, !wave.mask<64>
  %ptr = wave.ptr_add %buffer, %lane
      : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>
  wave.where %active {
    %stored = wave.store %lane -> %ptr
        : (!wave.simd<i32, 64>,
           !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>)
        -> !wave.mem.token
    wave.yield
  } : !wave.mask<64>
  return
}

// ASM-LABEL: ordered_f32_compare_codegen:
// ASM: v_cmp_lt_f32_e64 vcc,
// ASM-NEXT: s_and_saveexec_b64 [[FLOAT_SAVE:s\[[0-9]+:[0-9]+\]]], vcc
// ASM-NOT: s_mov_b64 {{.*}}, vcc
// ASM: buffer_store_dword
// ASM: s_mov_b64 exec, [[FLOAT_SAVE]]
// ASM: s_endpgm
func.func @ordered_f32_compare_codegen(
    %out: !wave.ptr<#wave.global, i32>,
    %lhs: f32,
    %rhs: f32) attributes {wave.kernel} {
  %range = arith.constant 4096 : i32
  %buffer = waveamd.make_buffer %out, %range
      : !wave.ptr<#wave.global, i32>, i32
      -> !wave.ptr<#waveamd.buffer, i32>
  %vlhs = wave.splat %lhs : f32 -> !wave.simd<f32, 64>
  %vrhs = wave.splat %rhs : f32 -> !wave.simd<f32, 64>
  %active = wave.cmpf olt %vlhs, %vrhs
      : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.mask<64>
  %lane = wave.lane_id : !wave.simd<i32, 64>
  %ptr = wave.ptr_add %buffer, %lane
      : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>
  wave.where %active {
    %stored = wave.store %lane -> %ptr
        : (!wave.simd<i32, 64>,
           !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>)
        -> !wave.mem.token
    wave.yield
  } : !wave.mask<64>
  return
}

}
