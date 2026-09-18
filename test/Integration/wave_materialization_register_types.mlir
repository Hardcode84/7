// RUN: wave-opt %s --waveamd-to-machine | FileCheck %s
// RUN: wave-translate %s --wave-to-amdgpu-asm | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx1100 -filetype=obj -o /dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
// CHECK-LABEL: func.func @scalar(
// CHECK-NOT: s_cmp_lt_i32
// CHECK: waveamdmachine.materialization_variants {{%.*}}, {{%.*}} : !waveamdmachine.reg<sgpr, 2>
func.func @scalar(%out: !wave.ptr<#wave.global, i32>, %raw: i32) -> !wave.mem.token attributes {wave.kernel} {
  %wide = wave.cast intconvert %raw policy {extension = #wave.cast_extension<zero>} : i32 -> index
  %narrow = wave.index_expr <"Mod(x, 4294967296)"> ["x"](%raw) : (i32) -> index
  %choice = wave.materialization_variants %wide, %narrow : index
  %lanes = wave.splat %choice : index -> !wave.simd<index, 32>
  %value = wave.cast intconvert %lanes : !wave.simd<index, 32> -> !wave.simd<i32, 32>
  %done = wave.store %value -> %out : (!wave.simd<i32, 32>, !wave.ptr<#wave.global, i32>) -> !wave.mem.token
  return %done : !wave.mem.token
}
// CHECK-LABEL: func.func @scalar_reverse(
// CHECK-NOT: s_cmp_lt_i32
// CHECK: waveamdmachine.materialization_variants {{%.*}}, {{%.*}} : !waveamdmachine.reg<sgpr, 2>
func.func @scalar_reverse(%out: !wave.ptr<#wave.global, i32>, %raw: i32) -> !wave.mem.token attributes {wave.kernel} {
  %wide = wave.cast intconvert %raw policy {extension = #wave.cast_extension<zero>} : i32 -> index
  %narrow = wave.index_expr <"Mod(x, 4294967296)"> ["x"](%raw) : (i32) -> index
  %choice = wave.materialization_variants %narrow, %wide : index
  %lanes = wave.splat %choice : index -> !wave.simd<index, 32>
  %value = wave.cast intconvert %lanes : !wave.simd<index, 32> -> !wave.simd<i32, 32>
  %done = wave.store %value -> %out : (!wave.simd<i32, 32>, !wave.ptr<#wave.global, i32>) -> !wave.mem.token
  return %done : !wave.mem.token
}
// CHECK-LABEL: func.func @vector(
// CHECK: waveamdmachine.materialization_variants {{%.*}}, {{%.*}} : !waveamdmachine.reg<vgpr, 2>
func.func @vector(%out: !wave.ptr<#wave.global, i32>, %raw: i32) -> !wave.mem.token attributes {wave.kernel} {
  %x = wave.lane_id : !wave.simd<i32, 32>
  %wide = wave.cast intconvert %x policy {extension = #wave.cast_extension<zero>} : !wave.simd<i32, 32> -> !wave.simd<index, 32>
  %narrow = wave.index_expr <"Mod(x, 4294967296)"> ["x"](%x) : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
  %choice = wave.materialization_variants %wide, %narrow : !wave.simd<index, 32>
  %value = wave.cast intconvert %choice : !wave.simd<index, 32> -> !wave.simd<i32, 32>
  %done = wave.store %value -> %out : (!wave.simd<i32, 32>, !wave.ptr<#wave.global, i32>) -> !wave.mem.token
  return %done : !wave.mem.token
}
// CHECK-LABEL: func.func @mixed_bank(
// CHECK: waveamdmachine.materialization_variants {{%.*}}, {{%.*}} : !waveamdmachine.reg<vgpr, 1>
func.func @mixed_bank(%out: !wave.ptr<#wave.global, i32>, %raw: i32) -> !wave.mem.token attributes {wave.kernel} {
  %uniform = wave.splat %raw : i32 -> !wave.simd<i32, 32>
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %sum = wave.binary addi %uniform, %lane : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %vector = wave.binary subi %sum, %lane : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %choice = wave.materialization_variants %uniform, %vector : !wave.simd<i32, 32>
  %done = wave.store %choice -> %out : (!wave.simd<i32, 32>, !wave.ptr<#wave.global, i32>) -> !wave.mem.token
  return %done : !wave.mem.token
}
// CHECK-LABEL: func.func @negative(
// CHECK: waveamdmachine.uniform_loop
// CHECK: ^bb0([[IV:%.*]]: !waveamdmachine.reg<sgpr, 1>,
// CHECK: [[SIGN:%.*]] = waveamdmachine.s_cmp_lt_i32 [[IV]],
// CHECK: [[HIGH:%.*]] = waveamdmachine.s_cselect_b32 [[SIGN]],
// CHECK: [[WIDE:%.*]] = waveamdmachine.tuple_from_elements [[IV]], [[HIGH]]
// CHECK: [[SIGN2:%.*]] = waveamdmachine.s_cmp_lt_i32 [[IV]],
// CHECK: [[HIGH2:%.*]] = waveamdmachine.s_cselect_b32 [[SIGN2]],
// CHECK: [[WIDE2:%.*]] = waveamdmachine.tuple_from_elements [[IV]], [[HIGH2]]
// CHECK: waveamdmachine.materialization_variants [[WIDE]], [[WIDE2]] : !waveamdmachine.reg<sgpr, 2>
func.func @negative(%out: !wave.ptr<#wave.global, i32>) -> !wave.mem.token attributes {wave.kernel} {
  %lb = arith.constant -3 : index
  %ub = arith.constant 0 : index
  %step = arith.constant 1 : index
  %root = wave.token : !wave.mem.token
  %end = scf.for %i = %lb to %ub step %step iter_args(%token = %root) -> !wave.mem.token {
    %bits = wave.cast intconvert %i : index -> i32
    %wide = wave.cast intconvert %bits policy {extension = #wave.cast_extension<sign>} : i32 -> index
    %choice = wave.materialization_variants %wide, %i : index
    %high = wave.index_expr <"floor(x / 4294967296)"> ["x"](%choice) : (index) -> index
    %word = wave.cast intconvert %high : index -> i32
    %lanes = wave.splat %word : i32 -> !wave.simd<i32, 32>
    %store = wave.store %lanes -> %out after %token : (!wave.simd<i32, 32>, !wave.ptr<#wave.global, i32>, !wave.mem.token) -> !wave.mem.token
    scf.yield %store : !wave.mem.token
  }
  return %end : !wave.mem.token
}
}
