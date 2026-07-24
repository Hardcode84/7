// RUN: wave-opt %s --pass-pipeline='builtin.module(transform-preload-library{transform-library-paths=%wave_pipelines},transform-interpreter{entry-point=waveamd_backend_lower})' \
// RUN:   | FileCheck %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// CHECK-LABEL: func.func @equivalent_mask_codegen
// CHECK-COUNT-1: waveamdmachine.s_cmp_lt_i32
// CHECK: waveamdmachine.buffer_store_b32
func.func @equivalent_mask_codegen(
    %out: !wave.ptr<#wave.global, i32>, %base_raw: i32, %limit_raw: i32)
    attributes {
      wave.kernel,
      wave.workgroup_size = array<i32: 256, 1, 1>,
      wave.waves_per_workgroup = 4 : i64
    } {
  %range = arith.constant 1024 : i32
  %buffer = waveamd.make_buffer %out, %range
      : !wave.ptr<#wave.global, i32>, i32
      -> !wave.ptr<#waveamd.buffer, i32>
  %base = wave.assume %base_raw as "x"
      [#wave.pred<"Mod(x, 16) == 0">] : i32
  %limit = wave.assume %limit_raw as "x"
      [#wave.pred<"Mod(x, 16) == 0">] : i32
  %base_splat = wave.splat %base : i32 -> !wave.simd<i32, 64>
  %limit_splat = wave.splat %limit : i32 -> !wave.simd<i32, 64>
  %c1 = wave.constant 1 : i32 -> !wave.simd<i32, 64>
  %c7 = wave.constant 7 : i32 -> !wave.simd<i32, 64>
  %zero = wave.constant 0 : i32 -> !wave.simd<i32, 64>
  %wi = wave.workitem_id 0 : !wave.simd<i32, 64>
  %i1 = wave.binary addi %base_splat, %c1
      : !wave.simd<i32, 64>, !wave.simd<i32, 64>
      -> !wave.simd<i32, 64>
  %i7 = wave.binary addi %base_splat, %c7
      : !wave.simd<i32, 64>, !wave.simd<i32, 64>
      -> !wave.simd<i32, 64>
  %m1 = wave.cmpi slt %i1, %limit_splat
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
  %m7 = wave.cmpi slt %i7, %limit_splat
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
  %v1 = wave.select %m1, %wi, %zero
      : !wave.mask<64>, !wave.simd<i32, 64>
  %v7 = wave.select %m7, %wi, %zero
      : !wave.mask<64>, !wave.simd<i32, 64>
  %sum = wave.binary addi %v1, %v7
      : !wave.simd<i32, 64>, !wave.simd<i32, 64>
      -> !wave.simd<i32, 64>
  %ptr = wave.ptr_add %buffer, %wi
      : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>
  %token = wave.store %sum -> %ptr
      : (!wave.simd<i32, 64>,
         !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>)
      -> !wave.mem.token
  return
}

}
