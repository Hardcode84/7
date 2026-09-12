// RUN: wave-opt %s --waveamd-to-machine | FileCheck %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
// CHECK-LABEL: func.func @scalar
// CHECK: [[A:%.*]] = waveamdmachine.s_mul_i32
// CHECK: [[B:%.*]], {{.*}} = waveamdmachine.s_add_i32
// CHECK: [[R:%.*]] = waveamdmachine.materialization_variants [[A]], [[B]] : !waveamdmachine.reg<sgpr, 1>
// CHECK: waveamdmachine.s_mov_b32 "s0", [[R]]
func.func @scalar(%x: i32) -> i32 {
  %two = arith.constant 2 : i32
  %a = wave.binary muli %x, %two : i32, i32 -> i32
  %b = wave.binary addi %x, %x : i32, i32 -> i32
  %r = wave.materialization_variants %a, %b : i32
  return %r : i32
}

// CHECK-LABEL: func.func @wide
// CHECK: waveamdmachine.materialization_variants {{.*}} : !waveamdmachine.reg<sgpr, 2>
func.func @wide(%x: i64) -> i64 {
  %one = arith.constant 1 : i64
  %sum = wave.binary muli %x, %one : i64, i64 -> i64
  %r = wave.materialization_variants %sum, %x : i64
  return %r : i64
}

// CHECK-LABEL: func.func @index
// CHECK: waveamdmachine.materialization_variants {{.*}} : !waveamdmachine.reg<sgpr, 2>
func.func @index(%x: index) -> index {
  %a = wave.index_expr <"x + 1"> ["x"](%x) : (index) -> index
  %b = wave.index_expr <"1 + x"> ["x"](%x) : (index) -> index
  %r = wave.materialization_variants %a, %b : index
  return %r : index
}

// CHECK-LABEL: func.func @simd
// CHECK: waveamdmachine.materialization_variants {{.*}} : !waveamdmachine.reg<vgpr, 1>
func.func @simd(%out: !wave.ptr<#wave.global, i32>) attributes {wave.kernel} {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %zero = arith.constant 0 : i32
  %a = wave.binary addi %lane, %zero : !wave.simd<i32, 32>, i32 -> !wave.simd<i32, 32>
  %r = wave.materialization_variants %a, %lane : !wave.simd<i32, 32>
  wave.store %r -> %out : (!wave.simd<i32, 32>, !wave.ptr<#wave.global, i32>) -> !wave.mem.token
  return
}

// CHECK-LABEL: func.func @tokens
// CHECK: [[R:%.*]] = waveamdmachine.materialization_variants {{.*}} : !waveamdmachine.mem.token
// CHECK: waveamdmachine.s_barrier [[R]]
func.func @tokens() {
  %a = wave.token : !wave.mem.token
  %b = wave.token : !wave.mem.token
  %r = wave.materialization_variants %a, %b : !wave.mem.token
  wave.barrier %r : (!wave.mem.token) -> !wave.mem.token
  return
}

// CHECK-LABEL: func.func @loop
// CHECK: waveamdmachine.uniform_loop
// CHECK: [[R:%.*]] = waveamdmachine.materialization_variants
// CHECK: waveamdmachine.continue_if {{.*}} carries({{.*}}[[R]]
func.func @loop(%x: i32) -> i32 {
  %zero = arith.constant 0 : index
  %four = arith.constant 4 : index
  %step = arith.constant 1 : index
  %one = arith.constant 1 : i32
  %r = scf.for %i = %zero to %four step %step iter_args(%carry = %x) -> i32 {
    %a = wave.binary addi %carry, %one : i32, i32 -> i32
    %b = wave.binary addi %one, %carry : i32, i32 -> i32
    %choice = wave.materialization_variants %a, %b : i32
    scf.yield %choice : i32
  }
  return %r : i32
}

}
