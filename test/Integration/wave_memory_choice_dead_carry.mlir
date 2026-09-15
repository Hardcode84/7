// RUN: wave-opt %s --pass-pipeline='builtin.module(waveamd-to-machine,waveamd-expand-materialization-variants{max-candidates=1},func.func(waveamd-cleanup-materialization-variants))' -o %t.once
// RUN: wave-opt %t.once --waveamd-collapse-materialization-variants | FileCheck %s
// RUN: wave-opt %t.once --pass-pipeline='builtin.module(func.func(waveamd-cleanup-materialization-variants))' -o %t.twice
// RUN: diff %t.once %t.twice

// CHECK-LABEL: func.func @dead_address_carry
// CHECK: waveamdmachine.uniform_loop
// CHECK-SAME: carries({{%[^:]+}} : !waveamdmachine.reg<sgpr, 1>, !waveamdmachine.mem.token)
// CHECK: waveamdmachine.global_store_b32
// CHECK-NOT: waveamdmachine.global_store_b32
// CHECK: waveamdmachine.continue_if
// CHECK-SAME: carries({{%[^:]+}} : !waveamdmachine.reg<sgpr, 1>, !waveamdmachine.mem.token)
// CHECK: waveamdmachine.s_endpgm
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @dead_address_carry(%out: !wave.ptr<#wave.global, i32>, %n: i32) -> !wave.mem.token attributes {wave.kernel} {
  %zero = arith.constant 0 : i32
  %one = arith.constant 1 : i32
  %stride = arith.constant 64 : i32
  %lane = wave.lane_id : !wave.simd<i32, 64>
  %base = wave.ptr_add %out, %lane : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.global, i32>, 64>
  %empty = wave.token : !wave.mem.token
  %loop:2 = scf.for %i = %zero to %n step %one iter_args(%offset = %zero, %dep = %empty) -> (i32, !wave.mem.token) : i32 {
    %scaled = wave.binary muli %i, %stride : i32, i32 -> i32
    %a = wave.ptr_add %base, %scaled : !wave.simd<!wave.ptr<#wave.global, i32>, 64>, i32 -> !wave.simd<!wave.ptr<#wave.global, i32>, 64>
    %b = wave.ptr_add %base, %offset : !wave.simd<!wave.ptr<#wave.global, i32>, 64>, i32 -> !wave.simd<!wave.ptr<#wave.global, i32>, 64>
    %first = wave.store %lane -> %a after %dep : (!wave.simd<i32, 64>, !wave.simd<!wave.ptr<#wave.global, i32>, 64>, !wave.mem.token) -> !wave.mem.token
    %second = wave.store %lane -> %b after %dep : (!wave.simd<i32, 64>, !wave.simd<!wave.ptr<#wave.global, i32>, 64>, !wave.mem.token) -> !wave.mem.token
    %choice = wave.materialization_variants %first, %second : !wave.mem.token
    %next = wave.binary addi %offset, %stride : i32, i32 -> i32
    scf.yield %next, %choice : i32, !wave.mem.token
  }
  return %loop#1 : !wave.mem.token
}
}
