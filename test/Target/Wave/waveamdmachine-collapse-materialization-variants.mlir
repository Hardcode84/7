// RUN: wave-opt %s --waveamd-collapse-materialization-variants | FileCheck %s --implicit-check-not=waveamdmachine.materialization_candidates --implicit-check-not=waveamdmachine.candidate_yield

// CHECK-LABEL: func.func @minimum
// CHECK-SAME: %[[X:.*]]: i32
// CHECK: %[[V:.*]] = arith.constant 11 :
// CHECK-NEXT: return %[[V]], %[[X]]
func.func @minimum(%x: i32) -> (i32, i32) {
  %a, %b = waveamdmachine.materialization_candidates %x : i32 -> i32, i32 {
  ^bb0(%arg: i32):
    %v = arith.constant 10 : i32
    waveamdmachine.candidate_yield %v, %arg : i32, i32 {cycles = 8 : i64}
  }, {
  ^bb0(%arg: i32):
    %v = arith.constant 11 : i32
    waveamdmachine.candidate_yield %v, %arg : i32, i32 {cycles = 2 : i64}
  }, {
  ^bb0(%arg: i32):
    %v = arith.constant 12 : i32
    waveamdmachine.candidate_yield %v, %arg : i32, i32 {cycles = 4 : i64}
  }
  return %a, %b : i32, i32
}

// CHECK-LABEL: func.func @tie
// CHECK-SAME: %[[X:.*]]: i32
// CHECK: %[[V:.*]] = arith.constant 10 :
// CHECK-NEXT: return %[[V]], %[[X]]
func.func @tie(%x: i32) -> (i32, i32) {
  %a, %b = waveamdmachine.materialization_candidates %x : i32 -> i32, i32 {
  ^bb0(%arg: i32):
    %v = arith.constant 10 : i32
    waveamdmachine.candidate_yield %v, %arg : i32, i32 {cycles = 2 : i64}
  }, {
  ^bb0(%arg: i32):
    %v = arith.constant 11 : i32
    waveamdmachine.candidate_yield %v, %arg : i32, i32 {cycles = 2 : i64}
  }, {
  ^bb0(%arg: i32):
    %v = arith.constant 12 : i32
    waveamdmachine.candidate_yield %v, %arg : i32, i32 {cycles = 4 : i64}
  }
  return %a, %b : i32, i32
}

// CHECK-LABEL: func.func @single
// CHECK-SAME: %[[X:.*]]: i32
// CHECK: %[[V:.*]] = arith.constant 10 :
// CHECK-NEXT: return %[[V]], %[[X]]
func.func @single(%x: i32) -> (i32, i32) {
  %a, %b = waveamdmachine.materialization_candidates %x : i32 -> i32, i32 {
  ^bb0(%arg: i32):
    %v = arith.constant 10 : i32
    waveamdmachine.candidate_yield %v, %arg : i32, i32 {cycles = 1 : i64}
  }
  return %a, %b : i32, i32
}

// CHECK-LABEL: func.func @effects
// CHECK-NEXT: waveamdmachine.s_barrier
// CHECK-NEXT: return
func.func @effects() {
  waveamdmachine.materialization_candidates {
    waveamdmachine.s_barrier : () -> ()
    waveamdmachine.s_barrier : () -> ()
    waveamdmachine.candidate_yield {cycles = 4 : i64}
  }, {
    waveamdmachine.s_barrier : () -> ()
    waveamdmachine.candidate_yield {cycles = 2 : i64}
  }
  return
}

// CHECK-LABEL: func.func @single_without_score
// CHECK-SAME: %[[X:.*]]: i32
// CHECK-NEXT: return %[[X]] : i32
func.func @single_without_score(%x: i32) -> i32 {
  %r = waveamdmachine.materialization_candidates %x : i32 -> i32 {
  ^bb0(%arg: i32):
    waveamdmachine.candidate_yield %arg : i32
  }
  return %r : i32
}
