// RUN: wave-opt --split-input-file --wave-delay-loop-carried-packs %s | FileCheck %s

// CHECK-LABEL: func.func @delay_i8_pack_loop_carry
// CHECK-SAME: (%[[LB:.*]]: i32, %[[UB:.*]]: i32, %[[STEP:.*]]: i32
// CHECK-SAME: %[[I0:.*]]: !wave.simd<i8, 64>, %[[I1:.*]]: !wave.simd<i8, 64>, %[[I2:.*]]: !wave.simd<i8, 64>, %[[I3:.*]]: !wave.simd<i8, 64>
// CHECK-NOT: iter_args(%{{.*}} = %{{.*}}) -> (!wave.simd<vector<4xi8>, 64>)
// CHECK: %[[LOOP:.*]]:4 = scf.for %{{.*}} = %[[LB]] to %[[UB]] step %[[STEP]] iter_args(%[[A0:.*]] = %[[I0]], %[[A1:.*]] = %[[I1]], %[[A2:.*]] = %[[I2]], %[[A3:.*]] = %[[I3]]) -> (!wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>)
// CHECK: arith.addi
// CHECK: %[[BODY_PACK:.*]] = wave.pack %[[A0]], %[[A1]], %[[A2]], %[[A3]] : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<4xi8>, 64>
// CHECK: wave.extract %[[BODY_PACK]][0]
// CHECK-DAG: %[[V0:.*]], %{{.*}} = wave.load
// CHECK-DAG: %[[V1:.*]], %{{.*}} = wave.load
// CHECK-DAG: %[[V2:.*]], %{{.*}} = wave.load
// CHECK-DAG: %[[V3:.*]], %{{.*}} = wave.load
// CHECK: scf.yield %[[V0]], %[[V1]], %[[V2]], %[[V3]] : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>
// CHECK: %[[EXIT_PACK:.*]] = wave.pack %[[LOOP]]#0, %[[LOOP]]#1, %[[LOOP]]#2, %[[LOOP]]#3 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<4xi8>, 64>
// CHECK: return %[[EXIT_PACK]] : !wave.simd<vector<4xi8>, 64>
func.func @delay_i8_pack_loop_carry(
    %lb: i32, %ub: i32, %step: i32,
    %i0: !wave.simd<i8, 64>, %i1: !wave.simd<i8, 64>,
    %i2: !wave.simd<i8, 64>, %i3: !wave.simd<i8, 64>,
    %p0: !wave.simd<!wave.ptr<#wave.global, i8>, 64>,
    %p1: !wave.simd<!wave.ptr<#wave.global, i8>, 64>,
    %p2: !wave.simd<!wave.ptr<#wave.global, i8>, 64>,
    %p3: !wave.simd<!wave.ptr<#wave.global, i8>, 64>)
    -> !wave.simd<vector<4xi8>, 64> {
  %init = wave.pack %i0, %i1, %i2, %i3 : !wave.simd<i8, 64>,
      !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> ->
      !wave.simd<vector<4xi8>, 64>
  %result = scf.for %i = %lb to %ub step %step iter_args(%packed = %init)
      -> (!wave.simd<vector<4xi8>, 64>)  : i32 {
    %unused = arith.addi %i, %i : i32
    %elt = wave.extract %packed[0] : !wave.simd<vector<4xi8>, 64> ->
        !wave.simd<i8, 64>
    %v0, %t0 = wave.load %p0 : (!wave.simd<!wave.ptr<#wave.global, i8>, 64>) ->
        (!wave.simd<i8, 64>, !wave.mem.token)
    %v1, %t1 = wave.load %p1 : (!wave.simd<!wave.ptr<#wave.global, i8>, 64>) ->
        (!wave.simd<i8, 64>, !wave.mem.token)
    %v2, %t2 = wave.load %p2 : (!wave.simd<!wave.ptr<#wave.global, i8>, 64>) ->
        (!wave.simd<i8, 64>, !wave.mem.token)
    %v3, %t3 = wave.load %p3 : (!wave.simd<!wave.ptr<#wave.global, i8>, 64>) ->
        (!wave.simd<i8, 64>, !wave.mem.token)
    %next = wave.pack %v0, %v1, %v2, %v3 : !wave.simd<i8, 64>,
        !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> ->
        !wave.simd<vector<4xi8>, 64>
    scf.yield %next : !wave.simd<vector<4xi8>, 64>
  }
  return %result : !wave.simd<vector<4xi8>, 64>
}
