// RUN: wave-opt %s --allow-unregistered-dialect --split-input-file --canonicalize | FileCheck %s

// CHECK-LABEL: func.func @unobserved
// CHECK-NEXT: return
func.func @unobserved(%p: !wave.ptr<#wave.global, i32>,
                      %v: !wave.simd<i32, 64>) {
  %written = wave.store %v -> %p
      : (!wave.simd<i32, 64>, !wave.ptr<#wave.global, i32>) -> !wave.mem.token
  %value, %read = wave.load %p after %written
      : (!wave.ptr<#wave.global, i32>, !wave.mem.token)
      -> (!wave.simd<i32, 64>, !wave.mem.token)
  %output = wave.store %value -> %p after %read
      : (!wave.simd<i32, 64>, !wave.ptr<#wave.global, i32>, !wave.mem.token)
      -> !wave.mem.token
  return
}

// -----

// CHECK-LABEL: func.func @observed
// CHECK: [[WRITE:%.*]] = wave.store
// CHECK: [[VALUE:%.*]], [[READ:%.*]] = wave.load {{.*}} after [[WRITE]]
// CHECK: return [[VALUE]]
func.func @observed(%p: !wave.ptr<#wave.global, i32>,
                    %v: !wave.simd<i32, 64>) -> !wave.simd<i32, 64> {
  %written = wave.store %v -> %p
      : (!wave.simd<i32, 64>, !wave.ptr<#wave.global, i32>) -> !wave.mem.token
  %value, %read = wave.load %p after %written
      : (!wave.ptr<#wave.global, i32>, !wave.mem.token)
      -> (!wave.simd<i32, 64>, !wave.mem.token)
  return %value : !wave.simd<i32, 64>
}

// -----

// CHECK-LABEL: func.func @dead_recurrence
// CHECK-NOT: wave.store
// CHECK: return
func.func @dead_recurrence(%p: !wave.ptr<#wave.global, i32>,
                           %v: !wave.simd<i32, 64>, %n: index) {
  %zero = arith.constant 0 : index
  %one = arith.constant 1 : index
  %empty = wave.token : !wave.mem.token
  %done = scf.for %i = %zero to %n step %one iter_args(%dep = %empty)
      -> (!wave.mem.token) {
    %inner = scf.for %j = %zero to %n step %one iter_args(%carry = %dep)
        -> (!wave.mem.token) {
      %write = wave.store %v -> %p after %carry
          : (!wave.simd<i32, 64>, !wave.ptr<#wave.global, i32>, !wave.mem.token)
          -> !wave.mem.token
      scf.yield %write : !wave.mem.token
    }
    scf.yield %inner : !wave.mem.token
  }
  return
}

// -----

// CHECK-LABEL: func.func @live_recurrence
// CHECK: scf.for
// CHECK: wave.store
// CHECK: return
func.func @live_recurrence(%p: !wave.ptr<#wave.global, i32>,
                           %v: !wave.simd<i32, 64>, %n: index) -> !wave.mem.token {
  %zero = arith.constant 0 : index
  %one = arith.constant 1 : index
  %empty = wave.token : !wave.mem.token
  %done = scf.for %i = %zero to %n step %one iter_args(%dep = %empty)
      -> (!wave.mem.token) {
    %write = wave.store %v -> %p after %dep
        : (!wave.simd<i32, 64>, !wave.ptr<#wave.global, i32>, !wave.mem.token)
        -> !wave.mem.token
    scf.yield %write : !wave.mem.token
  }
  return %done : !wave.mem.token
}

// -----

// CHECK-LABEL: func.func @dead_dma
// CHECK-NEXT: return
func.func @dead_dma(%p: !wave.simd<!wave.ptr<#wave.global, i32>, 64>,
                   %lds: !wave.ptr<#wave.shared, i32>) {
  %empty = wave.token : !wave.mem.token
  %copy = waveamd.dma_load_lds %p -> %lds after %empty {bytes = 4 : i64}
      : (!wave.simd<!wave.ptr<#wave.global, i32>, 64>,
         !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
  return
}

// -----

// CHECK-LABEL: func.func @zero_trip
// CHECK: [[WRITE:%.*]] = wave.store
// CHECK-NOT: scf.for
// CHECK: return [[WRITE]]
func.func @zero_trip(%p: !wave.ptr<#wave.global, i32>, %v: !wave.simd<i32, 64>) -> !wave.mem.token {
  %zero = arith.constant 0 : index
  %one = arith.constant 1 : index
  %initial = wave.store %v -> %p : (!wave.simd<i32, 64>, !wave.ptr<#wave.global, i32>) -> !wave.mem.token
  %done = scf.for %i = %zero to %zero step %one iter_args(%dep = %initial) -> (!wave.mem.token) {
    %write = wave.store %v -> %p after %dep : (!wave.simd<i32, 64>, !wave.ptr<#wave.global, i32>, !wave.mem.token) -> !wave.mem.token
    scf.yield %write : !wave.mem.token
  }
  return %done : !wave.mem.token
}

// -----

// CHECK-LABEL: func.func @branch_observed
// CHECK: scf.if
// CHECK: wave.store
// CHECK: else
// CHECK: wave.store
// CHECK: return
func.func @branch_observed(%p: !wave.ptr<#wave.global, i32>, %v: !wave.simd<i32, 64>, %condition: i1) -> !wave.mem.token {
  %done = scf.if %condition -> (!wave.mem.token) {
    %write = wave.store %v -> %p : (!wave.simd<i32, 64>, !wave.ptr<#wave.global, i32>) -> !wave.mem.token
    scf.yield %write : !wave.mem.token
  } else {
    %write = wave.store %v -> %p : (!wave.simd<i32, 64>, !wave.ptr<#wave.global, i32>) -> !wave.mem.token
    scf.yield %write : !wave.mem.token
  }
  return %done : !wave.mem.token
}

// -----

// CHECK-LABEL: func.func @unknown_capture
// CHECK: [[WRITE:%.*]] = wave.store
// CHECK: "opaque.consume"([[WRITE]])
func.func @unknown_capture(%p: !wave.ptr<#wave.global, i32>, %v: !wave.simd<i32, 64>, %n: index) {
  %zero = arith.constant 0 : index
  %one = arith.constant 1 : index
  scf.for %i = %zero to %n step %one {
    %write = wave.store %v -> %p : (!wave.simd<i32, 64>, !wave.ptr<#wave.global, i32>) -> !wave.mem.token
    "opaque.region"() ({
      "opaque.consume"(%write) : (!wave.mem.token) -> ()
    }) : () -> ()
  }
  return
}
