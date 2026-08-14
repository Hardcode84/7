// REQUIRES: linux, host-supports-amdgpu-gfx950, host-has-hip-runtime, host-has-hipcc
//
// RUN: wave-translate --wave-to-amdgpu-asm %s > %t.s
// RUN: llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx950 \
// RUN:   -filetype=obj %t.s -o %t.o
// RUN: ld.lld -shared %t.o -o %t.hsaco
// RUN: %hipcc -O2 %S/../../tools/wave-microbench/wave-microbench-runner.cpp \
// RUN:   -o %t.runner
// RUN: env LD_LIBRARY_PATH=%rocm_lib %t.runner --iters 1 --warmup 1 \
// RUN:   --grid 1,1,1 --block 64,1,1 --buf-elems 128 --dump-out 2 \
// RUN:   %t.hsaco index_binding_wide_immediate_runtime \
// RUN:   | FileCheck %s --check-prefix=RUNTIME
// RUN: env LD_LIBRARY_PATH=%rocm_lib %t.runner --iters 1 --warmup 1 \
// RUN:   --grid 1,1,1 --block 64,1,1 --buf-elems 128 --dump-out 2 \
// RUN:   %t.hsaco index_binding_narrow_u32_runtime \
// RUN:   | FileCheck %s --check-prefix=NARROW

// RUNTIME: out[0]: 1
// RUNTIME-NEXT: out[1]: -1
// NARROW: out[0]: 0
// NARROW-NEXT: out[1]: 0

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @index_binding_wide_immediate_runtime(
    %out: !wave.ptr<#wave.global, i32>)
    attributes {wave.kernel,
                wave.workgroup_size = array<i32: 64, 1, 1>,
                wave.waves_per_workgroup = 1 : i64} {
  %positive = arith.constant 4294967296 : index
  %negative = arith.constant -4294967296 : index
  %negative_splat = wave.splat %negative
      : index -> !wave.simd<index, 64>

  %positive_high = wave.index_expr <"floor(1/4294967296*x)">
      ["x"](%positive) : (index) -> index
  %negative_high = wave.index_expr <"floor(1/4294967296*x)">
      ["x"](%negative_splat)
      : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
  %positive_i32 = arith.index_cast %positive_high : index to i32
  %negative_i32 = wave.cast intconvert %negative_high
      : !wave.simd<index, 64> -> !wave.simd<i32, 64>
  %positive_values = wave.splat %positive_i32
      : i32 -> !wave.simd<i32, 64>

  %lane = wave.lane_id : !wave.simd<i32, 64>
  %two = wave.constant 2 : i32 -> !wave.simd<i32, 64>
  %one = wave.constant 1 : i32 -> !wave.simd<i32, 64>
  %even = wave.binary muli %lane, %two overflow<nsw>
      : !wave.simd<i32, 64>, !wave.simd<i32, 64>
      -> !wave.simd<i32, 64>
  %odd = wave.binary addi %even, %one overflow<nsw>
      : !wave.simd<i32, 64>, !wave.simd<i32, 64>
      -> !wave.simd<i32, 64>
  %positive_ptrs = wave.ptr_add %out, %even
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 64>
  %negative_ptrs = wave.ptr_add %out, %odd
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 64>
  %positive_written = wave.store %positive_values -> %positive_ptrs
      : (!wave.simd<i32, 64>,
         !wave.simd<!wave.ptr<#wave.global, i32>, 64>)
      -> !wave.mem.token
  %negative_written = wave.store %negative_i32 -> %negative_ptrs
      after %positive_written
      : (!wave.simd<i32, 64>,
         !wave.simd<!wave.ptr<#wave.global, i32>, 64>, !wave.mem.token)
      -> !wave.mem.token
  return
}

func.func @index_binding_narrow_u32_runtime(
    %out: !wave.ptr<#wave.global, i32>)
    attributes {wave.kernel,
                wave.workgroup_size = array<i32: 64, 1, 1>,
                wave.waves_per_workgroup = 1 : i64} {
  %wgid = wave.workgroup_id 0
  %lane = wave.lane_id : !wave.simd<i32, 64>
  %scalar_inner = wave.index_expr <"2147483648 + x"> assuming
      [#wave.pred<"x >= 0">, #wave.pred<"x <= 0">]
      ["x"](%wgid) : (i32) -> index
  %lane_inner = wave.index_expr <"2147483648 + lane"> assuming
      [#wave.pred<"lane >= 0">, #wave.pred<"lane <= 63">]
      ["lane"](%lane)
      : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
  %scalar_high = wave.index_expr <"floor(1/4294967296*x)">
      ["x"](%scalar_inner) : (index) -> index
  %lane_high = wave.index_expr <"floor(1/4294967296*x)">
      ["x"](%lane_inner)
      : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
  %scalar_i32 = arith.index_cast %scalar_high : index to i32
  %lane_i32 = wave.cast intconvert %lane_high
      : !wave.simd<index, 64> -> !wave.simd<i32, 64>
  %scalar_values = wave.splat %scalar_i32
      : i32 -> !wave.simd<i32, 64>

  %two = wave.constant 2 : i32 -> !wave.simd<i32, 64>
  %one = wave.constant 1 : i32 -> !wave.simd<i32, 64>
  %even = wave.binary muli %lane, %two overflow<nsw>
      : !wave.simd<i32, 64>, !wave.simd<i32, 64>
      -> !wave.simd<i32, 64>
  %odd = wave.binary addi %even, %one overflow<nsw>
      : !wave.simd<i32, 64>, !wave.simd<i32, 64>
      -> !wave.simd<i32, 64>
  %scalar_ptrs = wave.ptr_add %out, %even
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 64>
  %lane_ptrs = wave.ptr_add %out, %odd
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 64>
  %scalar_written = wave.store %scalar_values -> %scalar_ptrs
      : (!wave.simd<i32, 64>,
         !wave.simd<!wave.ptr<#wave.global, i32>, 64>)
      -> !wave.mem.token
  %lane_written = wave.store %lane_i32 -> %lane_ptrs after %scalar_written
      : (!wave.simd<i32, 64>,
         !wave.simd<!wave.ptr<#wave.global, i32>, 64>, !wave.mem.token)
      -> !wave.mem.token
  return
}
}
