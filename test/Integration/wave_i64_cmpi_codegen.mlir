// RUN: wave-opt %s --pass-pipeline='builtin.module(waveamd-to-machine,waveamd-abi-lowering,transform-preload-library{transform-library-paths=%wave_pipelines},transform-interpreter{entry-point=waveamd_regalloc_transform_loop},waveamd-resource-info)' \
// RUN:   | env WAVE_PIPELINES_DIR=%S/../Target/Wave/Inputs/emit-only-pipeline wave-translate --wave-to-amdgpu-asm - \
// RUN:   | FileCheck %s --check-prefix=ASM
// RUN: wave-opt %s --pass-pipeline='builtin.module(waveamd-to-machine,waveamd-abi-lowering,transform-preload-library{transform-library-paths=%wave_pipelines},transform-interpreter{entry-point=waveamd_regalloc_transform_loop},waveamd-resource-info)' \
// RUN:   | env WAVE_PIPELINES_DIR=%S/../Target/Wave/Inputs/emit-only-pipeline wave-translate --wave-to-amdgpu-asm - \
// RUN:   | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx1100 -filetype=obj -o /dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// ASM-LABEL: i64_cmpi_codegen:
// ASM: s_cmp_lt_u32
// ASM: s_cmp_eq_u32
// ASM: s_cmp_lt_u32
// ASM: s_and_b32
// ASM: s_or_b32
// ASM: s_cmp_gt_i32
// ASM: s_cmp_ge_u32
// ASM: s_and_b32
// ASM: s_or_b32
// ASM: s_or_b32
// ASM: global_store_b32
func.func @i64_cmpi_codegen(%out: !wave.ptr<#wave.global, i32>,
                            %lhs: i64, %rhs: i64)
    attributes {wave.kernel} {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %vlhs = wave.splat %lhs : i64 -> !wave.simd<i64, 32>
  %vrhs = wave.splat %rhs : i64 -> !wave.simd<i64, 32>
  %ult = wave.cmpi ult %vlhs, %vrhs
      : !wave.simd<i64, 32>, !wave.simd<i64, 32> -> !wave.mask<32>
  %sge = wave.cmpi sge %vlhs, %vrhs
      : !wave.simd<i64, 32>, !wave.simd<i64, 32> -> !wave.mask<32>
  %ubits = wave.ballot %ult : !wave.mask<32> -> i32
  %sbits = wave.ballot %sge : !wave.mask<32> -> i32
  %bits = wave.binary ori %ubits, %sbits : i32, i32 -> i32
  %vbits = wave.splat %bits : i32 -> !wave.simd<i32, 32>
  %ptrs = wave.ptr_add %out, %lane
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %token = wave.store %vbits -> %ptrs
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.global, i32>, 32>)
      -> !wave.mem.token
  return
}

// ASM-LABEL: i64_eq_codegen:
// ASM-NOT: s_cmp_eq_u32
// ASM-NOT: s_and_b32
// ASM-NOT: s_or_b32
// ASM: s_cmp_eq_u64
// ASM: s_cselect_b32
// ASM: s_cmp_lg_u64
// ASM: s_cselect_b32
// ASM-NOT: s_cmp_eq_u32
// ASM-NOT: s_and_b32
// ASM-NOT: s_or_b32
// ASM: global_store_b32
func.func @i64_eq_codegen(%out: !wave.ptr<#wave.global, i32>,
                          %lhs: i64, %rhs: i64, %other: i64)
    attributes {wave.kernel} {
  %eq = arith.cmpi eq, %lhs, %rhs : i64
  %ne = arith.cmpi ne, %lhs, %other : i64
  %zero = arith.constant 0 : i32
  %one = arith.constant 1 : i32
  %eq_value = wave.select %eq, %one, %zero : i32
  %ne_value = wave.select %ne, %one, %zero : i32
  %value = wave.binary addi %eq_value, %ne_value : i32, i32 -> i32
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %values = wave.splat %value : i32 -> !wave.simd<i32, 32>
  %ptrs = wave.ptr_add %out, %lane
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %token = wave.store %values -> %ptrs
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.global, i32>, 32>)
      -> !wave.mem.token
  return
}

// ASM-LABEL: i64_cmpi_literal_codegen:
// ASM: s_mov_b32
// ASM: s_cmp_lt_u32
// ASM: s_cmp_eq_u32
// ASM: s_mov_b32
// ASM: s_cmp_lt_u32
// ASM: s_and_b32
// ASM: s_or_b32
// ASM: s_cmp_lg_u32
// ASM: v_mov_b32
// ASM: global_store_b32
func.func @i64_cmpi_literal_codegen(%out: !wave.ptr<#wave.global, i32>)
    attributes {wave.kernel} {
  %lhs_c = arith.constant 1311768467750121216 : i64
  %rhs_c = arith.constant -7373874951294615808 : i64
  %lhs = wave.splat %lhs_c : i64 -> !wave.simd<i64, 32>
  %rhs = wave.splat %rhs_c : i64 -> !wave.simd<i64, 32>
  %mask = wave.cmpi ult %lhs, %rhs
      : !wave.simd<i64, 32>, !wave.simd<i64, 32> -> !wave.mask<32>
  %bits = wave.ballot %mask : !wave.mask<32> -> i32
  %vbits = wave.splat %bits : i32 -> !wave.simd<i32, 32>
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %ptrs = wave.ptr_add %out, %lane
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %token = wave.store %vbits -> %ptrs
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.global, i32>, 32>)
      -> !wave.mem.token
  return
}

}
