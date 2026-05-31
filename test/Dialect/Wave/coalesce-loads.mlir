// RUN: wave-opt --split-input-file --wave-coalesce-memory %s | FileCheck %s

// CHECK-LABEL: func.func @load_pair
// CHECK-SAME: ([[IN:%.*]]: !wave.ptr<f16, #wave.global>)
func.func @load_pair(%in: !wave.ptr<f16, #wave.global>)
    -> (!wave.simd<f16, 32>, !wave.simd<f16, 32>)
    attributes {wave.kernel} {
  %c1 = arith.constant 1 : i32
  %p1 = wave.ptr_add %in, %c1
      : !wave.ptr<f16, #wave.global>, i32 -> !wave.ptr<f16, #wave.global>
  // CHECK: [[LOAD:%.*]], {{%.*}} = wave.load [[IN]] : (!wave.ptr<f16, #wave.global>) -> (!wave.simd<vector<2xf16>, 32>, !wave.mem.token)
  // CHECK: [[LO:%.*]] = wave.extract [[LOAD]][0] : !wave.simd<vector<2xf16>, 32> -> !wave.simd<f16, 32>
  // CHECK: [[HI:%.*]] = wave.extract [[LOAD]][1] : !wave.simd<vector<2xf16>, 32> -> !wave.simd<f16, 32>
  // CHECK: return [[LO]], [[HI]]
  %v0, %t0 = wave.load %in
      : (!wave.ptr<f16, #wave.global>)
      -> (!wave.simd<f16, 32>, !wave.mem.token)
  %v1, %t1 = wave.load %p1 after %t0
      : (!wave.ptr<f16, #wave.global>, !wave.mem.token)
      -> (!wave.simd<f16, 32>, !wave.mem.token)
  return %v0, %v1 : !wave.simd<f16, 32>, !wave.simd<f16, 32>
}

// -----

// CHECK-LABEL: func.func @load_quad_recursive
// CHECK-SAME: ([[IN:%.*]]: !wave.ptr<i16, #wave.global>)
func.func @load_quad_recursive(%in: !wave.ptr<i16, #wave.global>)
    -> (!wave.simd<i16, 32>, !wave.simd<i16, 32>,
        !wave.simd<i16, 32>, !wave.simd<i16, 32>)
    attributes {wave.kernel} {
  %c1 = arith.constant 1 : i32
  %c2 = arith.constant 2 : i32
  %c3 = arith.constant 3 : i32
  %p1 = wave.ptr_add %in, %c1
      : !wave.ptr<i16, #wave.global>, i32 -> !wave.ptr<i16, #wave.global>
  %p2 = wave.ptr_add %in, %c2
      : !wave.ptr<i16, #wave.global>, i32 -> !wave.ptr<i16, #wave.global>
  %p3 = wave.ptr_add %in, %c3
      : !wave.ptr<i16, #wave.global>, i32 -> !wave.ptr<i16, #wave.global>
  // CHECK: [[LOAD:%.*]], {{%.*}} = wave.load [[IN]] : (!wave.ptr<i16, #wave.global>) -> (!wave.simd<vector<4xi16>, 32>, !wave.mem.token)
  // CHECK: [[V0:%.*]] = wave.extract [[LOAD]][0]
  // CHECK: [[V1:%.*]] = wave.extract [[LOAD]][1]
  // CHECK: [[V2:%.*]] = wave.extract [[LOAD]][2]
  // CHECK: [[V3:%.*]] = wave.extract [[LOAD]][3]
  // CHECK: return [[V0]], [[V1]], [[V2]], [[V3]]
  %v0, %t0 = wave.load %in
      : (!wave.ptr<i16, #wave.global>)
      -> (!wave.simd<i16, 32>, !wave.mem.token)
  %v1, %t1 = wave.load %p1 after %t0
      : (!wave.ptr<i16, #wave.global>, !wave.mem.token)
      -> (!wave.simd<i16, 32>, !wave.mem.token)
  %v2, %t2 = wave.load %p2 after %t1
      : (!wave.ptr<i16, #wave.global>, !wave.mem.token)
      -> (!wave.simd<i16, 32>, !wave.mem.token)
  %v3, %t3 = wave.load %p3 after %t2
      : (!wave.ptr<i16, #wave.global>, !wave.mem.token)
      -> (!wave.simd<i16, 32>, !wave.mem.token)
  return %v0, %v1, %v2, %v3
      : !wave.simd<i16, 32>, !wave.simd<i16, 32>,
        !wave.simd<i16, 32>, !wave.simd<i16, 32>
}

// -----

// CHECK-LABEL: func.func @reversed_source_order
// CHECK-SAME: ([[IN:%.*]]: !wave.ptr<f16, #wave.global>)
func.func @reversed_source_order(%in: !wave.ptr<f16, #wave.global>)
    -> (!wave.simd<f16, 32>, !wave.simd<f16, 32>)
    attributes {wave.kernel} {
  %c1 = arith.constant 1 : i32
  %p1 = wave.ptr_add %in, %c1
      : !wave.ptr<f16, #wave.global>, i32 -> !wave.ptr<f16, #wave.global>
  // CHECK: [[LOAD:%.*]], {{%.*}} = wave.load [[IN]]
  // CHECK: [[LO:%.*]] = wave.extract [[LOAD]][0]
  // CHECK: [[HI:%.*]] = wave.extract [[LOAD]][1]
  // CHECK: return [[LO]], [[HI]]
  %hi, %t0 = wave.load %p1
      : (!wave.ptr<f16, #wave.global>)
      -> (!wave.simd<f16, 32>, !wave.mem.token)
  %lo, %t1 = wave.load %in after %t0
      : (!wave.ptr<f16, #wave.global>, !wave.mem.token)
      -> (!wave.simd<f16, 32>, !wave.mem.token)
  return %lo, %hi : !wave.simd<f16, 32>, !wave.simd<f16, 32>
}

// -----

// CHECK-LABEL: func.func @symbolic_delta_and_token_rewrite
// CHECK-SAME: ([[IN:%.*]]: !wave.ptr<f32, #wave.global>, [[OUT:%.*]]: !wave.ptr<f32, #wave.global>)
func.func @symbolic_delta_and_token_rewrite(%in: !wave.ptr<f32, #wave.global>,
                                            %out: !wave.ptr<f32, #wave.global>)
    attributes {wave.kernel} {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %off0 = wave.index_expr <"lid"> ["lid"](%lane)
      : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
  %off1 = wave.index_expr <"lid + 1"> ["lid"](%lane)
      : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
  %p0 = wave.ptr_add %in, %off0
      : !wave.ptr<f32, #wave.global>, !wave.simd<index, 32>
      -> !wave.simd<!wave.ptr<f32, #wave.global>, 32>
  %p1 = wave.ptr_add %in, %off1
      : !wave.ptr<f32, #wave.global>, !wave.simd<index, 32>
      -> !wave.simd<!wave.ptr<f32, #wave.global>, 32>
  // CHECK: [[LOAD:%.*]], [[TOK:%.*]] = wave.load %{{.*}} : (!wave.simd<!wave.ptr<f32, #wave.global>, 32>) -> (!wave.simd<vector<2xf32>, 32>, !wave.mem.token)
  // CHECK: [[V0:%.*]] = wave.extract [[LOAD]][0]
  // CHECK: wave.store [[V0]] -> [[OUT]] after [[TOK]]
  %v0, %t0 = wave.load %p0
      : (!wave.simd<!wave.ptr<f32, #wave.global>, 32>)
      -> (!wave.simd<f32, 32>, !wave.mem.token)
  %v1, %t1 = wave.load %p1 after %t0
      : (!wave.simd<!wave.ptr<f32, #wave.global>, 32>, !wave.mem.token)
      -> (!wave.simd<f32, 32>, !wave.mem.token)
  %t2 = wave.store %v0 -> %out after %t1
      : (!wave.simd<f32, 32>, !wave.ptr<f32, #wave.global>,
         !wave.mem.token)
      -> !wave.mem.token
  return
}

// -----

// CHECK-LABEL: func.func @bf16_pair
// CHECK-SAME: ([[IN:%.*]]: !wave.ptr<bf16, #wave.global>)
func.func @bf16_pair(%in: !wave.ptr<bf16, #wave.global>)
    -> (!wave.simd<bf16, 32>, !wave.simd<bf16, 32>)
    attributes {wave.kernel} {
  %c1 = arith.constant 1 : i32
  %p1 = wave.ptr_add %in, %c1
      : !wave.ptr<bf16, #wave.global>, i32 -> !wave.ptr<bf16, #wave.global>
  // CHECK: [[LOAD:%.*]], {{%.*}} = wave.load [[IN]] : (!wave.ptr<bf16, #wave.global>) -> (!wave.simd<vector<2xbf16>, 32>, !wave.mem.token)
  %v0, %t0 = wave.load %in
      : (!wave.ptr<bf16, #wave.global>)
      -> (!wave.simd<bf16, 32>, !wave.mem.token)
  %v1, %t1 = wave.load %p1 after %t0
      : (!wave.ptr<bf16, #wave.global>, !wave.mem.token)
      -> (!wave.simd<bf16, 32>, !wave.mem.token)
  return %v0, %v1 : !wave.simd<bf16, 32>, !wave.simd<bf16, 32>
}

// -----

// CHECK-LABEL: func.func @escaped_intermediate_token_stays
// CHECK-NOT: vector<2xf16>
// CHECK: wave.load
// CHECK: wave.load
// CHECK: wave.store
func.func @escaped_intermediate_token_stays(%in: !wave.ptr<f16, #wave.global>,
                                            %out: !wave.ptr<f16, #wave.global>)
    attributes {wave.kernel} {
  %c1 = arith.constant 1 : i32
  %p1 = wave.ptr_add %in, %c1
      : !wave.ptr<f16, #wave.global>, i32 -> !wave.ptr<f16, #wave.global>
  %v0, %t0 = wave.load %in
      : (!wave.ptr<f16, #wave.global>)
      -> (!wave.simd<f16, 32>, !wave.mem.token)
  %v1, %t1 = wave.load %p1 after %t0
      : (!wave.ptr<f16, #wave.global>, !wave.mem.token)
      -> (!wave.simd<f16, 32>, !wave.mem.token)
  %t2 = wave.store %v0 -> %out after %t0
      : (!wave.simd<f16, 32>, !wave.ptr<f16, #wave.global>,
         !wave.mem.token)
      -> !wave.mem.token
  return
}

// -----

// CHECK-LABEL: func.func @non_adjacent_address_stays
// CHECK-NOT: vector<2xf16>
// CHECK: wave.load
// CHECK: wave.load
func.func @non_adjacent_address_stays(%in: !wave.ptr<f16, #wave.global>)
    -> (!wave.simd<f16, 32>, !wave.simd<f16, 32>)
    attributes {wave.kernel} {
  %c2 = arith.constant 2 : i32
  %p2 = wave.ptr_add %in, %c2
      : !wave.ptr<f16, #wave.global>, i32 -> !wave.ptr<f16, #wave.global>
  %v0, %t0 = wave.load %in
      : (!wave.ptr<f16, #wave.global>)
      -> (!wave.simd<f16, 32>, !wave.mem.token)
  %v1, %t1 = wave.load %p2 after %t0
      : (!wave.ptr<f16, #wave.global>, !wave.mem.token)
      -> (!wave.simd<f16, 32>, !wave.mem.token)
  return %v0, %v1 : !wave.simd<f16, 32>, !wave.simd<f16, 32>
}

// -----

// CHECK-LABEL: func.func @mismatched_type_stays
// CHECK-NOT: vector<2x
// CHECK: wave.load
// CHECK: wave.load
func.func @mismatched_type_stays(%in: !wave.ptr<f16, #wave.global>)
    -> (!wave.simd<f16, 32>, !wave.simd<i16, 32>)
    attributes {wave.kernel} {
  %c1 = arith.constant 1 : i32
  %p1 = wave.ptr_add %in, %c1
      : !wave.ptr<f16, #wave.global>, i32 -> !wave.ptr<f16, #wave.global>
  %v0, %t0 = wave.load %in
      : (!wave.ptr<f16, #wave.global>)
      -> (!wave.simd<f16, 32>, !wave.mem.token)
  %v1, %t1 = wave.load %p1 after %t0
      : (!wave.ptr<f16, #wave.global>, !wave.mem.token)
      -> (!wave.simd<i16, 32>, !wave.mem.token)
  return %v0, %v1 : !wave.simd<f16, 32>, !wave.simd<i16, 32>
}

// -----

// CHECK-LABEL: func.func @mismatched_symbol_binding_stays
// CHECK-NOT: vector<2xi32>
// CHECK: wave.load
// CHECK: wave.load
func.func @mismatched_symbol_binding_stays(%in: !wave.ptr<i32, #wave.global>,
                                           %a: !wave.simd<i32, 32>,
                                           %b: !wave.simd<i32, 32>)
    -> (!wave.simd<i32, 32>, !wave.simd<i32, 32>)
    attributes {wave.kernel} {
  %off0 = wave.index_expr <"x"> ["x"](%a)
      : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
  %off1 = wave.index_expr <"x + 1"> ["x"](%b)
      : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
  %p0 = wave.ptr_add %in, %off0
      : !wave.ptr<i32, #wave.global>, !wave.simd<index, 32>
      -> !wave.simd<!wave.ptr<i32, #wave.global>, 32>
  %p1 = wave.ptr_add %in, %off1
      : !wave.ptr<i32, #wave.global>, !wave.simd<index, 32>
      -> !wave.simd<!wave.ptr<i32, #wave.global>, 32>
  %v0, %t0 = wave.load %p0
      : (!wave.simd<!wave.ptr<i32, #wave.global>, 32>)
      -> (!wave.simd<i32, 32>, !wave.mem.token)
  %v1, %t1 = wave.load %p1 after %t0
      : (!wave.simd<!wave.ptr<i32, #wave.global>, 32>, !wave.mem.token)
      -> (!wave.simd<i32, 32>, !wave.mem.token)
  return %v0, %v1 : !wave.simd<i32, 32>, !wave.simd<i32, 32>
}

// -----

// CHECK-LABEL: func.func @unsafe_insertion_point_stays
// CHECK-NOT: vector<2xf16>
// CHECK: wave.load
// CHECK: wave.load
func.func @unsafe_insertion_point_stays(%in: !wave.ptr<f16, #wave.global>)
    -> (!wave.simd<f16, 32>, !wave.simd<f16, 32>)
    attributes {wave.kernel} {
  %c1 = arith.constant 1 : i32
  %p1 = wave.ptr_add %in, %c1
      : !wave.ptr<f16, #wave.global>, i32 -> !wave.ptr<f16, #wave.global>
  %hi, %t0 = wave.load %p1
      : (!wave.ptr<f16, #wave.global>)
      -> (!wave.simd<f16, 32>, !wave.mem.token)
  %c0 = arith.constant 0 : i32
  %p0 = wave.ptr_add %in, %c0
      : !wave.ptr<f16, #wave.global>, i32 -> !wave.ptr<f16, #wave.global>
  %lo, %t1 = wave.load %p0 after %t0
      : (!wave.ptr<f16, #wave.global>, !wave.mem.token)
      -> (!wave.simd<f16, 32>, !wave.mem.token)
  return %lo, %hi : !wave.simd<f16, 32>, !wave.simd<f16, 32>
}
