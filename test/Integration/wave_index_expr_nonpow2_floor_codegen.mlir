// RUN: wave-opt %s --pass-pipeline='builtin.module(transform-preload-library{transform-library-paths=%wave_pipelines},transform-interpreter{entry-point=waveamd_backend})' \
// RUN:   | env WAVE_PIPELINES_DIR=%S/../Target/Wave/Inputs/emit-only-pipeline wave-translate --wave-to-amdgpu-asm - \
// RUN:   | FileCheck %s --check-prefix=ASM
// RUN: wave-opt %s --pass-pipeline='builtin.module(transform-preload-library{transform-library-paths=%wave_pipelines},transform-interpreter{entry-point=waveamd_backend})' \
// RUN:   | env WAVE_PIPELINES_DIR=%S/../Target/Wave/Inputs/emit-only-pipeline wave-translate --wave-to-amdgpu-asm - \
// RUN:   | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx950 -filetype=obj -o /dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// ASM-LABEL: floor_div_3:
// ASM: buffer_load_dword
// ASM: v_mul_hi_u32
// ASM: global_store_dword
// ASM: s_endpgm
func.func @floor_div_3(%input: !wave.ptr<#wave.global, i32>,
    %out: !wave.ptr<#wave.global, i32>) attributes {wave.kernel} {
  %lane = wave.lane_id : !wave.simd<i32, 64>
  %ptrs = wave.ptr_add %input, %lane
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 64>
  %raw, %loaded = wave.load %ptrs
      : (!wave.simd<!wave.ptr<#wave.global, i32>, 64>)
      -> (!wave.simd<i32, 64>, !wave.mem.token)
  %x = wave.assume %raw as "x"
      [#wave.pred<"x >= 0">, #wave.pred<"x <= 2147483647">]
      : !wave.simd<i32, 64>
  %off = wave.index_expr <"floor(1/3*x)"> ["x"](%x)
      : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
  %dest = wave.ptr_add %out, %off
      : !wave.ptr<#wave.global, i32>, !wave.simd<index, 64>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 64>
  %stored = wave.store %raw -> %dest after %loaded
      : (!wave.simd<i32, 64>, !wave.simd<!wave.ptr<#wave.global, i32>, 64>,
         !wave.mem.token) -> !wave.mem.token
  return
}

// ASM-LABEL: floor_div_7:
// ASM: buffer_load_dword
// ASM: v_mul_hi_u32
// ASM: v_xor_b32
// ASM: v_add3_u32
// ASM: v_lshrrev_b32
// ASM: v_add_u32
// ASM: buffer_store_dword
// ASM: s_endpgm
func.func @floor_div_7(%input: !wave.ptr<#wave.global, i32>,
    %out: !wave.ptr<#wave.global, i32>) attributes {wave.kernel} {
  %lane = wave.lane_id : !wave.simd<i32, 64>
  %ptrs = wave.ptr_add %input, %lane
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 64>
  %raw, %loaded = wave.load %ptrs
      : (!wave.simd<!wave.ptr<#wave.global, i32>, 64>)
      -> (!wave.simd<i32, 64>, !wave.mem.token)
  %x = wave.assume %raw as "x"
      [#wave.pred<"x >= 0">, #wave.pred<"x <= 2147483647">]
      : !wave.simd<i32, 64>
  %off = wave.index_expr <"floor(1/7*x)"> ["x"](%x)
      : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
  %dest = wave.ptr_add %out, %off
      : !wave.ptr<#wave.global, i32>, !wave.simd<index, 64>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 64>
  %stored = wave.store %raw -> %dest after %loaded
      : (!wave.simd<i32, 64>, !wave.simd<!wave.ptr<#wave.global, i32>, 64>,
         !wave.mem.token) -> !wave.mem.token
  return
}

// ASM-LABEL: floor_div_14:
// ASM: buffer_load_dword
// ASM: v_lshrrev_b32_e32 {{v[0-9]+}}, 1,
// ASM: v_mul_hi_u32
// ASM: v_lshrrev_b32_e32 {{v[0-9]+}}, 2,
// ASM: buffer_store_dword
// ASM: s_endpgm
func.func @floor_div_14(%input: !wave.ptr<#wave.global, i32>,
    %out: !wave.ptr<#wave.global, i32>) attributes {wave.kernel} {
  %lane = wave.lane_id : !wave.simd<i32, 64>
  %ptrs = wave.ptr_add %input, %lane
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 64>
  %raw, %loaded = wave.load %ptrs
      : (!wave.simd<!wave.ptr<#wave.global, i32>, 64>)
      -> (!wave.simd<i32, 64>, !wave.mem.token)
  %x = wave.assume %raw as "x"
      [#wave.pred<"x >= 0">, #wave.pred<"x <= 2147483647">]
      : !wave.simd<i32, 64>
  %off = wave.index_expr <"floor(1/14*x)"> ["x"](%x)
      : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
  %dest = wave.ptr_add %out, %off
      : !wave.ptr<#wave.global, i32>, !wave.simd<index, 64>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 64>
  %stored = wave.store %raw -> %dest after %loaded
      : (!wave.simd<i32, 64>, !wave.simd<!wave.ptr<#wave.global, i32>, 64>,
         !wave.mem.token) -> !wave.mem.token
  return
}
}
