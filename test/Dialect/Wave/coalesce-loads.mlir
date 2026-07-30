// RUN: wave-opt --split-input-file --wave-coalesce-memory %s | FileCheck %s

// CHECK-LABEL: func.func @load_pair
// CHECK-SAME: ([[IN:%.*]]: !wave.ptr<#wave.global, f16>)
func.func @load_pair(%in: !wave.ptr<#wave.global, f16>)
    -> (!wave.simd<f16, 32>, !wave.simd<f16, 32>)
    attributes {wave.kernel} {
  %c1 = arith.constant 1 : i32
  %p1 = wave.ptr_add %in, %c1
      : !wave.ptr<#wave.global, f16>, i32 -> !wave.ptr<#wave.global, f16>
  // CHECK: [[LOAD:%.*]], {{%.*}} = wave.load [[IN]] : (!wave.ptr<#wave.global, f16>) -> (!wave.simd<vector<2xf16>, 32>, !wave.mem.token)
  // CHECK: [[LO:%.*]] = wave.extract [[LOAD]][0] : !wave.simd<vector<2xf16>, 32> -> !wave.simd<f16, 32>
  // CHECK: [[HI:%.*]] = wave.extract [[LOAD]][1] : !wave.simd<vector<2xf16>, 32> -> !wave.simd<f16, 32>
  // CHECK: return [[LO]], [[HI]]
  %v0, %t0 = wave.load %in
      : (!wave.ptr<#wave.global, f16>)
      -> (!wave.simd<f16, 32>, !wave.mem.token)
  %v1, %t1 = wave.load %p1 after %t0
      : (!wave.ptr<#wave.global, f16>, !wave.mem.token)
      -> (!wave.simd<f16, 32>, !wave.mem.token)
  return %v0, %v1 : !wave.simd<f16, 32>, !wave.simd<f16, 32>
}

// -----

// CHECK-LABEL: func.func @dead_load_tokens_stay
// CHECK-NOT: vector<2xf16>
// CHECK: wave.load
// CHECK: wave.load
func.func @dead_load_tokens_stay(
    %in: !wave.ptr<#wave.global, f16>, %dep: !wave.mem.token)
    -> (!wave.simd<f16, 32>, !wave.simd<f16, 32>)
    attributes {wave.kernel} {
  %c1 = arith.constant 1 : i32
  %p1 = wave.ptr_add %in, %c1
      : !wave.ptr<#wave.global, f16>, i32 -> !wave.ptr<#wave.global, f16>
  %v0, %t0 = wave.load %in after %dep
      : (!wave.ptr<#wave.global, f16>, !wave.mem.token)
      -> (!wave.simd<f16, 32>, !wave.mem.token)
  %v1, %t1 = wave.load %p1 after %dep
      : (!wave.ptr<#wave.global, f16>, !wave.mem.token)
      -> (!wave.simd<f16, 32>, !wave.mem.token)
  return %v0, %v1 : !wave.simd<f16, 32>, !wave.simd<f16, 32>
}

// -----

// CHECK-LABEL: func.func @load_quad_recursive
// CHECK-SAME: ([[IN:%.*]]: !wave.ptr<#wave.global, i16>)
func.func @load_quad_recursive(%in: !wave.ptr<#wave.global, i16>)
    -> (!wave.simd<i16, 32>, !wave.simd<i16, 32>,
        !wave.simd<i16, 32>, !wave.simd<i16, 32>)
    attributes {wave.kernel} {
  %c1 = arith.constant 1 : i32
  %c2 = arith.constant 2 : i32
  %c3 = arith.constant 3 : i32
  %p1 = wave.ptr_add %in, %c1
      : !wave.ptr<#wave.global, i16>, i32 -> !wave.ptr<#wave.global, i16>
  %p2 = wave.ptr_add %in, %c2
      : !wave.ptr<#wave.global, i16>, i32 -> !wave.ptr<#wave.global, i16>
  %p3 = wave.ptr_add %in, %c3
      : !wave.ptr<#wave.global, i16>, i32 -> !wave.ptr<#wave.global, i16>
  // CHECK: [[LOAD:%.*]], {{%.*}} = wave.load [[IN]] : (!wave.ptr<#wave.global, i16>) -> (!wave.simd<vector<4xi16>, 32>, !wave.mem.token)
  // CHECK: [[V0:%.*]] = wave.extract [[LOAD]][0]
  // CHECK: [[V1:%.*]] = wave.extract [[LOAD]][1]
  // CHECK: [[V2:%.*]] = wave.extract [[LOAD]][2]
  // CHECK: [[V3:%.*]] = wave.extract [[LOAD]][3]
  // CHECK: return [[V0]], [[V1]], [[V2]], [[V3]]
  %v0, %t0 = wave.load %in
      : (!wave.ptr<#wave.global, i16>)
      -> (!wave.simd<i16, 32>, !wave.mem.token)
  %v1, %t1 = wave.load %p1 after %t0
      : (!wave.ptr<#wave.global, i16>, !wave.mem.token)
      -> (!wave.simd<i16, 32>, !wave.mem.token)
  %v2, %t2 = wave.load %p2 after %t1
      : (!wave.ptr<#wave.global, i16>, !wave.mem.token)
      -> (!wave.simd<i16, 32>, !wave.mem.token)
  %v3, %t3 = wave.load %p3 after %t2
      : (!wave.ptr<#wave.global, i16>, !wave.mem.token)
      -> (!wave.simd<i16, 32>, !wave.mem.token)
  return %v0, %v1, %v2, %v3
      : !wave.simd<i16, 32>, !wave.simd<i16, 32>,
        !wave.simd<i16, 32>, !wave.simd<i16, 32>
}

// -----

// CHECK-LABEL: func.func @reversed_source_order
// CHECK-SAME: ([[IN:%.*]]: !wave.ptr<#wave.global, f16>)
func.func @reversed_source_order(%in: !wave.ptr<#wave.global, f16>)
    -> (!wave.simd<f16, 32>, !wave.simd<f16, 32>)
    attributes {wave.kernel} {
  %c1 = arith.constant 1 : i32
  %p1 = wave.ptr_add %in, %c1
      : !wave.ptr<#wave.global, f16>, i32 -> !wave.ptr<#wave.global, f16>
  // CHECK: [[LOAD:%.*]], {{%.*}} = wave.load [[IN]]
  // CHECK: [[LO:%.*]] = wave.extract [[LOAD]][0]
  // CHECK: [[HI:%.*]] = wave.extract [[LOAD]][1]
  // CHECK: return [[LO]], [[HI]]
  %hi, %t0 = wave.load %p1
      : (!wave.ptr<#wave.global, f16>)
      -> (!wave.simd<f16, 32>, !wave.mem.token)
  %lo, %t1 = wave.load %in after %t0
      : (!wave.ptr<#wave.global, f16>, !wave.mem.token)
      -> (!wave.simd<f16, 32>, !wave.mem.token)
  return %lo, %hi : !wave.simd<f16, 32>, !wave.simd<f16, 32>
}

// -----

// CHECK-LABEL: func.func @symbolic_delta_and_token_rewrite
// CHECK-SAME: ([[IN:%.*]]: !wave.ptr<#wave.global, f32>, [[OUT:%.*]]: !wave.ptr<#wave.global, f32>)
func.func @symbolic_delta_and_token_rewrite(%in: !wave.ptr<#wave.global, f32>,
                                            %out: !wave.ptr<#wave.global, f32>)
    attributes {wave.kernel} {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %off0 = wave.index_expr <"lid"> ["lid"](%lane)
      : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
  %off1 = wave.index_expr <"lid + 1"> ["lid"](%lane)
      : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
  %p0 = wave.ptr_add %in, %off0
      : !wave.ptr<#wave.global, f32>, !wave.simd<index, 32>
      -> !wave.simd<!wave.ptr<#wave.global, f32>, 32>
  %p1 = wave.ptr_add %in, %off1
      : !wave.ptr<#wave.global, f32>, !wave.simd<index, 32>
      -> !wave.simd<!wave.ptr<#wave.global, f32>, 32>
  // CHECK: [[LOAD:%.*]], [[TOK:%.*]] = wave.load %{{.*}} : (!wave.simd<!wave.ptr<#wave.global, f32>, 32>) -> (!wave.simd<vector<2xf32>, 32>, !wave.mem.token)
  // CHECK: [[V0:%.*]] = wave.extract [[LOAD]][0]
  // CHECK: wave.store [[V0]] -> [[OUT]] after [[TOK]]
  %v0, %t0 = wave.load %p0
      : (!wave.simd<!wave.ptr<#wave.global, f32>, 32>)
      -> (!wave.simd<f32, 32>, !wave.mem.token)
  %v1, %t1 = wave.load %p1 after %t0
      : (!wave.simd<!wave.ptr<#wave.global, f32>, 32>, !wave.mem.token)
      -> (!wave.simd<f32, 32>, !wave.mem.token)
  %t2 = wave.store %v0 -> %out after %t1
      : (!wave.simd<f32, 32>, !wave.ptr<#wave.global, f32>,
         !wave.mem.token)
      -> !wave.mem.token
  return
}

// -----

// CHECK-LABEL: func.func @fact_backed_symbolic_delta
// CHECK: wave.load {{.*}} -> (!wave.simd<vector<2xf32>, 32>, !wave.mem.token)
func.func @fact_backed_symbolic_delta(
    %in: !wave.ptr<#wave.global, f32>, %x: !wave.simd<i32, 32>,
    %i: !wave.simd<i32, 32>)
    -> (!wave.simd<f32, 32>, !wave.simd<f32, 32>)
    attributes {wave.kernel} {
  %off0 = wave.index_expr <"x + 4*i"> assuming [#wave.pred<"x == 0">]
      ["x", "i"](%x, %i)
      : (!wave.simd<i32, 32>, !wave.simd<i32, 32>)
      -> !wave.simd<index, 32>
  %off1 = wave.index_expr <"4*j + 1"> ["j"](%i)
      : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
  %p0 = wave.ptr_add %in, %off0
      : !wave.ptr<#wave.global, f32>, !wave.simd<index, 32>
      -> !wave.simd<!wave.ptr<#wave.global, f32>, 32>
  %p1 = wave.ptr_add %in, %off1
      : !wave.ptr<#wave.global, f32>, !wave.simd<index, 32>
      -> !wave.simd<!wave.ptr<#wave.global, f32>, 32>
  %v0, %t0 = wave.load %p0
      : (!wave.simd<!wave.ptr<#wave.global, f32>, 32>)
      -> (!wave.simd<f32, 32>, !wave.mem.token)
  %v1, %t1 = wave.load %p1 after %t0
      : (!wave.simd<!wave.ptr<#wave.global, f32>, 32>, !wave.mem.token)
      -> (!wave.simd<f32, 32>, !wave.mem.token)
  return %v0, %v1 : !wave.simd<f32, 32>, !wave.simd<f32, 32>
}

// -----

// CHECK-LABEL: func.func @missing_delta_fact_stays
// CHECK-NOT: vector<2xf32>
// CHECK: wave.load
// CHECK: wave.load
func.func @missing_delta_fact_stays(
    %in: !wave.ptr<#wave.global, f32>, %x: !wave.simd<i32, 32>,
    %i: !wave.simd<i32, 32>)
    -> (!wave.simd<f32, 32>, !wave.simd<f32, 32>)
    attributes {wave.kernel} {
  %off0 = wave.index_expr <"x + 4*i"> ["x", "i"](%x, %i)
      : (!wave.simd<i32, 32>, !wave.simd<i32, 32>)
      -> !wave.simd<index, 32>
  %off1 = wave.index_expr <"4*j + 1"> ["j"](%i)
      : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
  %p0 = wave.ptr_add %in, %off0
      : !wave.ptr<#wave.global, f32>, !wave.simd<index, 32>
      -> !wave.simd<!wave.ptr<#wave.global, f32>, 32>
  %p1 = wave.ptr_add %in, %off1
      : !wave.ptr<#wave.global, f32>, !wave.simd<index, 32>
      -> !wave.simd<!wave.ptr<#wave.global, f32>, 32>
  %v0, %t0 = wave.load %p0
      : (!wave.simd<!wave.ptr<#wave.global, f32>, 32>)
      -> (!wave.simd<f32, 32>, !wave.mem.token)
  %v1, %t1 = wave.load %p1 after %t0
      : (!wave.simd<!wave.ptr<#wave.global, f32>, 32>, !wave.mem.token)
      -> (!wave.simd<f32, 32>, !wave.mem.token)
  return %v0, %v1 : !wave.simd<f32, 32>, !wave.simd<f32, 32>
}

// -----

// CHECK-LABEL: func.func @contradictory_delta_facts_stay
// CHECK-NOT: vector<2xf32>
// CHECK: wave.load
// CHECK: wave.load
func.func @contradictory_delta_facts_stay(
    %in: !wave.ptr<#wave.global, f32>, %x: !wave.simd<i32, 32>,
    %i: !wave.simd<i32, 32>)
    -> (!wave.simd<f32, 32>, !wave.simd<f32, 32>)
    attributes {wave.kernel} {
  %off0 = wave.index_expr <"x + 4*i"> assuming [#wave.pred<"x == 0">]
      ["x", "i"](%x, %i)
      : (!wave.simd<i32, 32>, !wave.simd<i32, 32>)
      -> !wave.simd<index, 32>
  %off1 = wave.index_expr <"4*j + y">
      assuming [#wave.pred<"y == 1">] ["j", "y"](%i, %x)
      : (!wave.simd<i32, 32>, !wave.simd<i32, 32>)
      -> !wave.simd<index, 32>
  %p0 = wave.ptr_add %in, %off0
      : !wave.ptr<#wave.global, f32>, !wave.simd<index, 32>
      -> !wave.simd<!wave.ptr<#wave.global, f32>, 32>
  %p1 = wave.ptr_add %in, %off1
      : !wave.ptr<#wave.global, f32>, !wave.simd<index, 32>
      -> !wave.simd<!wave.ptr<#wave.global, f32>, 32>
  %v0, %t0 = wave.load %p0
      : (!wave.simd<!wave.ptr<#wave.global, f32>, 32>)
      -> (!wave.simd<f32, 32>, !wave.mem.token)
  %v1, %t1 = wave.load %p1 after %t0
      : (!wave.simd<!wave.ptr<#wave.global, f32>, 32>, !wave.mem.token)
      -> (!wave.simd<f32, 32>, !wave.mem.token)
  return %v0, %v1 : !wave.simd<f32, 32>, !wave.simd<f32, 32>
}

// -----

// CHECK-LABEL: func.func @same_dependency_join_tokens
// CHECK-SAME: ([[IN:%.*]]: !wave.ptr<#wave.global, f16>)
func.func @same_dependency_join_tokens(%in: !wave.ptr<#wave.global, f16>)
    -> (!wave.simd<f16, 32>, !wave.simd<f16, 32>)
    attributes {wave.kernel} {
  %c1 = arith.constant 1 : i32
  %p1 = wave.ptr_add %in, %c1
      : !wave.ptr<#wave.global, f16>, i32 -> !wave.ptr<#wave.global, f16>
  %root = wave.token : !wave.mem.token
  // CHECK: [[ROOT:%.*]] = wave.token
  // CHECK: [[LOAD:%.*]], [[TOK:%.*]] = wave.load [[IN]] after [[ROOT]] : (!wave.ptr<#wave.global, f16>, !wave.mem.token) -> (!wave.simd<vector<2xf16>, 32>, !wave.mem.token)
  // CHECK: [[V0:%.*]] = wave.extract [[LOAD]][0]
  // CHECK: [[V1:%.*]] = wave.extract [[LOAD]][1]
  // CHECK: wave.join [[TOK]], [[TOK]]
  // CHECK: return [[V0]], [[V1]]
  %v0, %t0 = wave.load %in after %root
      : (!wave.ptr<#wave.global, f16>, !wave.mem.token)
      -> (!wave.simd<f16, 32>, !wave.mem.token)
  %v1, %t1 = wave.load %p1 after %root
      : (!wave.ptr<#wave.global, f16>, !wave.mem.token)
      -> (!wave.simd<f16, 32>, !wave.mem.token)
  %joined = wave.join %t0, %t1
      : !wave.mem.token, !wave.mem.token -> !wave.mem.token
  %bar = wave.barrier %joined : (!wave.mem.token) -> !wave.mem.token
  return %v0, %v1 : !wave.simd<f16, 32>, !wave.simd<f16, 32>
}

// -----

// CHECK-LABEL: func.func @same_dependency_split_join_stays
// CHECK-NOT: vector<2xf16>
// CHECK: wave.load
// CHECK: wave.load
// CHECK: wave.join
// CHECK: wave.join
func.func @same_dependency_split_join_stays(%in: !wave.ptr<#wave.global, f16>)
    -> (!wave.simd<f16, 32>, !wave.simd<f16, 32>)
    attributes {wave.kernel} {
  %c1 = arith.constant 1 : i32
  %p1 = wave.ptr_add %in, %c1
      : !wave.ptr<#wave.global, f16>, i32 -> !wave.ptr<#wave.global, f16>
  %root = wave.token : !wave.mem.token
  %v0, %t0 = wave.load %in after %root
      : (!wave.ptr<#wave.global, f16>, !wave.mem.token)
      -> (!wave.simd<f16, 32>, !wave.mem.token)
  %v1, %t1 = wave.load %p1 after %root
      : (!wave.ptr<#wave.global, f16>, !wave.mem.token)
      -> (!wave.simd<f16, 32>, !wave.mem.token)
  %j0 = wave.join %t0 : !wave.mem.token -> !wave.mem.token
  %j1 = wave.join %t1 : !wave.mem.token -> !wave.mem.token
  %bar = wave.barrier %j0, %j1
      : (!wave.mem.token, !wave.mem.token) -> !wave.mem.token
  return %v0, %v1 : !wave.simd<f16, 32>, !wave.simd<f16, 32>
}

// -----

// CHECK-LABEL: func.func @bf16_pair
// CHECK-SAME: ([[IN:%.*]]: !wave.ptr<#wave.global, bf16>)
func.func @bf16_pair(%in: !wave.ptr<#wave.global, bf16>)
    -> (!wave.simd<bf16, 32>, !wave.simd<bf16, 32>)
    attributes {wave.kernel} {
  %c1 = arith.constant 1 : i32
  %p1 = wave.ptr_add %in, %c1
      : !wave.ptr<#wave.global, bf16>, i32 -> !wave.ptr<#wave.global, bf16>
  // CHECK: [[LOAD:%.*]], {{%.*}} = wave.load [[IN]] : (!wave.ptr<#wave.global, bf16>) -> (!wave.simd<vector<2xbf16>, 32>, !wave.mem.token)
  %v0, %t0 = wave.load %in
      : (!wave.ptr<#wave.global, bf16>)
      -> (!wave.simd<bf16, 32>, !wave.mem.token)
  %v1, %t1 = wave.load %p1 after %t0
      : (!wave.ptr<#wave.global, bf16>, !wave.mem.token)
      -> (!wave.simd<bf16, 32>, !wave.mem.token)
  return %v0, %v1 : !wave.simd<bf16, 32>, !wave.simd<bf16, 32>
}

// -----

// CHECK-LABEL: func.func @escaped_intermediate_token_stays
// CHECK-NOT: vector<2xf16>
// CHECK: wave.load
// CHECK: wave.load
// CHECK: wave.store
func.func @escaped_intermediate_token_stays(%in: !wave.ptr<#wave.global, f16>,
                                            %out: !wave.ptr<#wave.global, f16>)
    attributes {wave.kernel} {
  %c1 = arith.constant 1 : i32
  %p1 = wave.ptr_add %in, %c1
      : !wave.ptr<#wave.global, f16>, i32 -> !wave.ptr<#wave.global, f16>
  %v0, %t0 = wave.load %in
      : (!wave.ptr<#wave.global, f16>)
      -> (!wave.simd<f16, 32>, !wave.mem.token)
  %v1, %t1 = wave.load %p1 after %t0
      : (!wave.ptr<#wave.global, f16>, !wave.mem.token)
      -> (!wave.simd<f16, 32>, !wave.mem.token)
  %t2 = wave.store %v0 -> %out after %t0
      : (!wave.simd<f16, 32>, !wave.ptr<#wave.global, f16>,
         !wave.mem.token)
      -> !wave.mem.token
  return
}

// -----

// CHECK-LABEL: func.func @non_adjacent_address_stays
// CHECK-NOT: vector<2xf16>
// CHECK: wave.load
// CHECK: wave.load
func.func @non_adjacent_address_stays(%in: !wave.ptr<#wave.global, f16>)
    -> (!wave.simd<f16, 32>, !wave.simd<f16, 32>)
    attributes {wave.kernel} {
  %c2 = arith.constant 2 : i32
  %p2 = wave.ptr_add %in, %c2
      : !wave.ptr<#wave.global, f16>, i32 -> !wave.ptr<#wave.global, f16>
  %v0, %t0 = wave.load %in
      : (!wave.ptr<#wave.global, f16>)
      -> (!wave.simd<f16, 32>, !wave.mem.token)
  %v1, %t1 = wave.load %p2 after %t0
      : (!wave.ptr<#wave.global, f16>, !wave.mem.token)
      -> (!wave.simd<f16, 32>, !wave.mem.token)
  return %v0, %v1 : !wave.simd<f16, 32>, !wave.simd<f16, 32>
}

// -----

// CHECK-LABEL: func.func @mismatched_type_stays
// CHECK-NOT: vector<2x
// CHECK: wave.load
// CHECK: wave.load
func.func @mismatched_type_stays(%in: !wave.ptr<#wave.global, f16>)
    -> (!wave.simd<f16, 32>, !wave.simd<i16, 32>)
    attributes {wave.kernel} {
  %c1 = arith.constant 1 : i32
  %p1 = wave.ptr_add %in, %c1
      : !wave.ptr<#wave.global, f16>, i32 -> !wave.ptr<#wave.global, f16>
  %v0, %t0 = wave.load %in
      : (!wave.ptr<#wave.global, f16>)
      -> (!wave.simd<f16, 32>, !wave.mem.token)
  %v1, %t1 = wave.load %p1 after %t0
      : (!wave.ptr<#wave.global, f16>, !wave.mem.token)
      -> (!wave.simd<i16, 32>, !wave.mem.token)
  return %v0, %v1 : !wave.simd<f16, 32>, !wave.simd<i16, 32>
}

// -----

// CHECK-LABEL: func.func @mismatched_symbol_binding_stays
// CHECK-NOT: vector<2xi32>
// CHECK: wave.load
// CHECK: wave.load
func.func @mismatched_symbol_binding_stays(%in: !wave.ptr<#wave.global, i32>,
                                           %a: !wave.simd<i32, 32>,
                                           %b: !wave.simd<i32, 32>)
    -> (!wave.simd<i32, 32>, !wave.simd<i32, 32>)
    attributes {wave.kernel} {
  %off0 = wave.index_expr <"x"> ["x"](%a)
      : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
  %off1 = wave.index_expr <"x + 1"> ["x"](%b)
      : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
  %p0 = wave.ptr_add %in, %off0
      : !wave.ptr<#wave.global, i32>, !wave.simd<index, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %p1 = wave.ptr_add %in, %off1
      : !wave.ptr<#wave.global, i32>, !wave.simd<index, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %v0, %t0 = wave.load %p0
      : (!wave.simd<!wave.ptr<#wave.global, i32>, 32>)
      -> (!wave.simd<i32, 32>, !wave.mem.token)
  %v1, %t1 = wave.load %p1 after %t0
      : (!wave.simd<!wave.ptr<#wave.global, i32>, 32>, !wave.mem.token)
      -> (!wave.simd<i32, 32>, !wave.mem.token)
  return %v0, %v1 : !wave.simd<i32, 32>, !wave.simd<i32, 32>
}

// -----

// CHECK-LABEL: func.func @unsafe_insertion_point_stays
// CHECK-NOT: vector<2xf16>
// CHECK: wave.load
// CHECK: wave.load
func.func @unsafe_insertion_point_stays(%in: !wave.ptr<#wave.global, f16>)
    -> (!wave.simd<f16, 32>, !wave.simd<f16, 32>)
    attributes {wave.kernel} {
  %c1 = arith.constant 1 : i32
  %p1 = wave.ptr_add %in, %c1
      : !wave.ptr<#wave.global, f16>, i32 -> !wave.ptr<#wave.global, f16>
  %hi, %t0 = wave.load %p1
      : (!wave.ptr<#wave.global, f16>)
      -> (!wave.simd<f16, 32>, !wave.mem.token)
  %c0 = arith.constant 0 : i32
  %p0 = wave.ptr_add %in, %c0
      : !wave.ptr<#wave.global, f16>, i32 -> !wave.ptr<#wave.global, f16>
  %lo, %t1 = wave.load %p0 after %t0
      : (!wave.ptr<#wave.global, f16>, !wave.mem.token)
      -> (!wave.simd<f16, 32>, !wave.mem.token)
  return %lo, %hi : !wave.simd<f16, 32>, !wave.simd<f16, 32>
}

// -----

// CHECK-LABEL: func.func @load_pair_same_cache
// CHECK-SAME: ([[IN:%.*]]: !wave.ptr<#wave.global, f16>)
// CHECK: [[LOAD:%.*]], {{%.*}} = wave.load [[IN]] {cache = #waveamd.load_cache<cg>} : (!wave.ptr<#wave.global, f16>) -> (!wave.simd<vector<2xf16>, 32>, !wave.mem.token)
// CHECK: [[LO:%.*]] = wave.extract [[LOAD]][0]
// CHECK: [[HI:%.*]] = wave.extract [[LOAD]][1]
// CHECK: return [[LO]], [[HI]]
func.func @load_pair_same_cache(%in: !wave.ptr<#wave.global, f16>)
    -> (!wave.simd<f16, 32>, !wave.simd<f16, 32>)
    attributes {wave.kernel} {
  %c1 = arith.constant 1 : i32
  %p1 = wave.ptr_add %in, %c1
      : !wave.ptr<#wave.global, f16>, i32 -> !wave.ptr<#wave.global, f16>
  %v0, %t0 = wave.load %in {cache = #waveamd.load_cache<cg>}
      : (!wave.ptr<#wave.global, f16>)
      -> (!wave.simd<f16, 32>, !wave.mem.token)
  %v1, %t1 = wave.load %p1 after %t0 {cache = #waveamd.load_cache<cg>}
      : (!wave.ptr<#wave.global, f16>, !wave.mem.token)
      -> (!wave.simd<f16, 32>, !wave.mem.token)
  return %v0, %v1 : !wave.simd<f16, 32>, !wave.simd<f16, 32>
}

// -----

// CHECK-LABEL: func.func @load_pair_mismatched_cache_stays
// CHECK-NOT: vector<2xf16>
// CHECK: wave.load {{.*}} {cache = #waveamd.load_cache<cg>}
// CHECK: wave.load {{.*}} {cache = #waveamd.load_cache<cs>}
func.func @load_pair_mismatched_cache_stays(%in: !wave.ptr<#wave.global, f16>)
    -> (!wave.simd<f16, 32>, !wave.simd<f16, 32>)
    attributes {wave.kernel} {
  %c1 = arith.constant 1 : i32
  %p1 = wave.ptr_add %in, %c1
      : !wave.ptr<#wave.global, f16>, i32 -> !wave.ptr<#wave.global, f16>
  %v0, %t0 = wave.load %in {cache = #waveamd.load_cache<cg>}
      : (!wave.ptr<#wave.global, f16>)
      -> (!wave.simd<f16, 32>, !wave.mem.token)
  %v1, %t1 = wave.load %p1 after %t0 {cache = #waveamd.load_cache<cs>}
      : (!wave.ptr<#wave.global, f16>, !wave.mem.token)
      -> (!wave.simd<f16, 32>, !wave.mem.token)
  return %v0, %v1 : !wave.simd<f16, 32>, !wave.simd<f16, 32>
}
