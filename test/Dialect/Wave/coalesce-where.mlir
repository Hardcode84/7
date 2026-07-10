// RUN: wave-opt --wave-coalesce-where %s | FileCheck %s

// CHECK-LABEL: func.func @merge_same_mask
// CHECK: %[[WHERE:.*]]:3 = wave.where
// CHECK: %[[T0:.*]] = wave.store
// CHECK: %[[T1:.*]] = wave.store {{.*}} after %[[T0]]
// CHECK: %[[SUM:.*]] = wave.binary addi
// CHECK: %[[T2:.*]] = wave.store %[[SUM]] {{.*}} after %[[T1]]
// CHECK: wave.yield %[[T0]], %[[T1]], %[[T2]]
// CHECK-NOT: wave.where
// CHECK: wave.join %[[WHERE]]#0, %[[WHERE]]#1, %[[WHERE]]#2
func.func @merge_same_mask(
    %mask: !wave.mask<64>,
    %a: !wave.simd<i32, 64>,
    %b: !wave.simd<i32, 64>,
    %p0: !wave.ptr<#wave.global, i32>,
    %p1: !wave.ptr<#wave.global, i32>,
    %p2: !wave.ptr<#wave.global, i32>) {
  %t0, %t1 = wave.where %mask {
    %s0 = wave.store %a -> %p0
        : (!wave.simd<i32, 64>, !wave.ptr<#wave.global, i32>)
        -> !wave.mem.token
    %s1 = wave.store %b -> %p1 after %s0
        : (!wave.simd<i32, 64>, !wave.ptr<#wave.global, i32>,
           !wave.mem.token) -> !wave.mem.token
    wave.yield %s0, %s1 : !wave.mem.token, !wave.mem.token
  } : !wave.mask<64> -> !wave.mem.token, !wave.mem.token
  %sum = wave.binary addi %a, %b
      : !wave.simd<i32, 64>, !wave.simd<i32, 64>
      -> !wave.simd<i32, 64>
  %t2 = wave.where %mask {
    %s2 = wave.store %sum -> %p2 after %t1
        : (!wave.simd<i32, 64>, !wave.ptr<#wave.global, i32>,
           !wave.mem.token) -> !wave.mem.token
    wave.yield %s2 : !wave.mem.token
  } : !wave.mask<64> -> !wave.mem.token
  %joined = wave.join %t0, %t1, %t2
      : !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
  return
}

// -----

// CHECK-LABEL: func.func @keep_different_masks
// CHECK-COUNT-2: wave.where
func.func @keep_different_masks(
    %mask0: !wave.mask<64>,
    %mask1: !wave.mask<64>,
    %value: !wave.simd<i32, 64>,
    %ptr: !wave.ptr<#wave.global, i32>) {
  wave.where %mask0 {
    wave.yield
  } : !wave.mask<64>
  %sum = wave.binary addi %value, %value
      : !wave.simd<i32, 64>, !wave.simd<i32, 64>
      -> !wave.simd<i32, 64>
  wave.where %mask1 {
    %token = wave.store %sum -> %ptr
        : (!wave.simd<i32, 64>, !wave.ptr<#wave.global, i32>)
        -> !wave.mem.token
    wave.yield
  } : !wave.mask<64>
  return
}

// -----

// CHECK-LABEL: func.func @keep_effectful_gap
// CHECK-COUNT-2: wave.where
func.func @keep_effectful_gap(
    %mask: !wave.mask<64>,
    %value: !wave.simd<i32, 64>,
    %ptr: !wave.ptr<#wave.global, i32>) {
  wave.where %mask {
    wave.yield
  } : !wave.mask<64>
  %token = wave.store %value -> %ptr
      : (!wave.simd<i32, 64>, !wave.ptr<#wave.global, i32>)
      -> !wave.mem.token
  wave.where %mask {
    wave.yield
  } : !wave.mask<64>
  return
}

// -----

// CHECK-LABEL: func.func @keep_read_first_gap
// CHECK: wave.where
// CHECK: %[[FIRST:.*]] = wave.read_first
// CHECK: wave.where
func.func @keep_read_first_gap(
    %mask: !wave.mask<64>,
    %value: !wave.simd<i32, 64>,
    %ptr: !wave.ptr<#wave.global, i32>) {
  wave.where %mask {
    wave.yield
  } : !wave.mask<64>
  %first = wave.read_first %value : !wave.simd<i32, 64> -> i32
  %broadcast = wave.splat %first : i32 -> !wave.simd<i32, 64>
  wave.where %mask {
    %token = wave.store %broadcast -> %ptr
        : (!wave.simd<i32, 64>, !wave.ptr<#wave.global, i32>)
        -> !wave.mem.token
    wave.yield
  } : !wave.mask<64>
  return
}

// -----

// CHECK-LABEL: func.func @keep_otherwise
// CHECK-COUNT-2: wave.where
func.func @keep_otherwise(%mask: !wave.mask<64>) {
  wave.where %mask {
    wave.yield
  } otherwise {
    wave.yield
  } : !wave.mask<64>
  wave.where %mask {
    wave.yield
  } : !wave.mask<64>
  return
}

// -----

// CHECK-LABEL: func.func @hoist_escaping_gap_result
// CHECK: %[[SUM:.*]] = wave.binary addi
// CHECK: wave.where
// CHECK-NOT: wave.where
// CHECK: return %[[SUM]] : !wave.simd<i32, 64>
func.func @hoist_escaping_gap_result(
    %mask: !wave.mask<64>,
    %value: !wave.simd<i32, 64>) -> !wave.simd<i32, 64> {
  wave.where %mask {
    wave.yield
  } : !wave.mask<64>
  %sum = wave.binary addi %value, %value
      : !wave.simd<i32, 64>, !wave.simd<i32, 64>
      -> !wave.simd<i32, 64>
  wave.where %mask {
    wave.yield
  } : !wave.mask<64>
  return %sum : !wave.simd<i32, 64>
}

// -----

// CHECK-LABEL: func.func @keep_escape_depending_on_first
// CHECK-COUNT-2: wave.where
func.func @keep_escape_depending_on_first(
    %mask: !wave.mask<64>,
    %value: !wave.simd<i32, 64>) -> !wave.simd<i32, 64> {
  %masked = wave.where %mask {
    %sum = wave.binary addi %value, %value
        : !wave.simd<i32, 64>, !wave.simd<i32, 64>
        -> !wave.simd<i32, 64>
    wave.yield %sum : !wave.simd<i32, 64>
  } : !wave.mask<64> -> !wave.simd<i32, 64>
  %escaping = wave.binary addi %masked, %value
      : !wave.simd<i32, 64>, !wave.simd<i32, 64>
      -> !wave.simd<i32, 64>
  wave.where %mask {
    wave.yield
  } : !wave.mask<64>
  return %escaping : !wave.simd<i32, 64>
}
