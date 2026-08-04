// RUN: wave-opt %s --pass-pipeline='builtin.module(transform-preload-library{transform-library-paths=%wave_pipelines},transform-interpreter{entry-point=waveamd_backend})' \
// RUN:   | env WAVE_PIPELINES_DIR=%S/../Target/Wave/Inputs/emit-only-pipeline wave-translate --wave-to-amdgpu-asm - \
// RUN:   | FileCheck %s --check-prefix=ASM
// RUN: wave-opt %s --pass-pipeline='builtin.module(transform-preload-library{transform-library-paths=%wave_pipelines},transform-interpreter{entry-point=waveamd_backend})' \
// RUN:   | env WAVE_PIPELINES_DIR=%S/../Target/Wave/Inputs/emit-only-pipeline wave-translate --wave-to-amdgpu-asm - \
// RUN:   | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx950 -filetype=obj -o /dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// ASM-LABEL: index_expr_bitwise_codegen:
// ASM: buffer_load_dword [[LHS:v[0-9]+]],
// ASM: buffer_load_dword [[RHS:v[0-9]+]],
// ASM-DAG: v_and_b32_e32 {{v[0-9]+}}, [[LHS]], [[RHS]]
// ASM-DAG: v_or_b32_e32 {{v[0-9]+}}, [[LHS]], [[RHS]]
// ASM-DAG: global_store_dword {{.*}}, [[LHS]], off
// ASM-DAG: global_store_dword {{.*}}, [[RHS]], off
// ASM: s_endpgm
func.func @index_expr_bitwise_codegen(
    %lhs_in: !wave.ptr<#wave.global, i32>,
    %rhs_in: !wave.ptr<#wave.global, i32>,
    %out: !wave.ptr<#wave.global, i32>) attributes {wave.kernel} {
  %lane = wave.lane_id : !wave.simd<i32, 64>
  %lhs_ptrs = wave.ptr_add %lhs_in, %lane
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 64>
  %rhs_ptrs = wave.ptr_add %rhs_in, %lane
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 64>
  %lhs, %lhs_loaded = wave.load %lhs_ptrs
      : (!wave.simd<!wave.ptr<#wave.global, i32>, 64>)
      -> (!wave.simd<i32, 64>, !wave.mem.token)
  %rhs, %rhs_loaded = wave.load %rhs_ptrs after %lhs_loaded
      : (!wave.simd<!wave.ptr<#wave.global, i32>, 64>, !wave.mem.token)
      -> (!wave.simd<i32, 64>, !wave.mem.token)
  %and = wave.binary andi %lhs, %rhs
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
  %or = wave.binary ori %lhs, %rhs
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
  %and_ptrs = wave.ptr_add %out, %and
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 64>
  %and_stored = wave.store %lhs -> %and_ptrs after %rhs_loaded
      : (!wave.simd<i32, 64>, !wave.simd<!wave.ptr<#wave.global, i32>, 64>,
         !wave.mem.token) -> !wave.mem.token
  %or_ptrs = wave.ptr_add %out, %or
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 64>
  %or_stored = wave.store %rhs -> %or_ptrs after %and_stored
      : (!wave.simd<i32, 64>, !wave.simd<!wave.ptr<#wave.global, i32>, 64>,
         !wave.mem.token) -> !wave.mem.token
  return
}

}
