// RUN: wave-opt --split-input-file --wave-coalesce-memory %s | FileCheck %s

// CHECK-LABEL: func.func @store_pair
// CHECK-SAME: ([[OUT:%.*]]: !wave.ptr<#wave.global, f16>, [[A:%.*]]: !wave.simd<f16, 32>, [[B:%.*]]: !wave.simd<f16, 32>)
func.func @store_pair(%out: !wave.ptr<#wave.global, f16>,
                      %a: !wave.simd<f16, 32>,
                      %b: !wave.simd<f16, 32>)
    attributes {wave.kernel} {
  %c1 = arith.constant 1 : i32
  %p1 = wave.ptr_add %out, %c1
      : !wave.ptr<#wave.global, f16>, i32 -> !wave.ptr<#wave.global, f16>
  // CHECK: [[PACK:%.*]] = wave.pack [[A]], [[B]] : !wave.simd<f16, 32>, !wave.simd<f16, 32> -> !wave.simd<vector<2xf16>, 32>
  // CHECK: wave.store [[PACK]] -> [[OUT]] : (!wave.simd<vector<2xf16>, 32>, !wave.ptr<#wave.global, f16>) -> !wave.mem.token
  // CHECK-NOT: wave.store {{.*}} -> %{{.*}} : (!wave.simd<f16, 32>
  %t0 = wave.store %a -> %out
      : (!wave.simd<f16, 32>, !wave.ptr<#wave.global, f16>)
      -> !wave.mem.token
  %t1 = wave.store %b -> %p1 after %t0
      : (!wave.simd<f16, 32>, !wave.ptr<#wave.global, f16>,
         !wave.mem.token)
      -> !wave.mem.token
  return
}

// -----

// CHECK-LABEL: func.func @store_quad_recursive
// CHECK-SAME: ([[OUT:%.*]]: !wave.ptr<#wave.global, i16>, [[A0:%.*]]: !wave.simd<i16, 32>, [[A1:%.*]]: !wave.simd<i16, 32>, [[A2:%.*]]: !wave.simd<i16, 32>, [[A3:%.*]]: !wave.simd<i16, 32>)
func.func @store_quad_recursive(%out: !wave.ptr<#wave.global, i16>,
                                %a0: !wave.simd<i16, 32>,
                                %a1: !wave.simd<i16, 32>,
                                %a2: !wave.simd<i16, 32>,
                                %a3: !wave.simd<i16, 32>)
    attributes {wave.kernel} {
  %c1 = arith.constant 1 : i32
  %c2 = arith.constant 2 : i32
  %c3 = arith.constant 3 : i32
  %p1 = wave.ptr_add %out, %c1
      : !wave.ptr<#wave.global, i16>, i32 -> !wave.ptr<#wave.global, i16>
  %p2 = wave.ptr_add %out, %c2
      : !wave.ptr<#wave.global, i16>, i32 -> !wave.ptr<#wave.global, i16>
  %p3 = wave.ptr_add %out, %c3
      : !wave.ptr<#wave.global, i16>, i32 -> !wave.ptr<#wave.global, i16>
  // CHECK: [[PACK:%.*]] = wave.pack [[A0]], [[A1]], [[A2]], [[A3]] : !wave.simd<i16, 32>, !wave.simd<i16, 32>, !wave.simd<i16, 32>, !wave.simd<i16, 32> -> !wave.simd<vector<4xi16>, 32>
  // CHECK: wave.store [[PACK]] -> [[OUT]]
  %t0 = wave.store %a0 -> %out
      : (!wave.simd<i16, 32>, !wave.ptr<#wave.global, i16>)
      -> !wave.mem.token
  %t1 = wave.store %a1 -> %p1 after %t0
      : (!wave.simd<i16, 32>, !wave.ptr<#wave.global, i16>,
         !wave.mem.token)
      -> !wave.mem.token
  %t2 = wave.store %a2 -> %p2 after %t1
      : (!wave.simd<i16, 32>, !wave.ptr<#wave.global, i16>,
         !wave.mem.token)
      -> !wave.mem.token
  %t3 = wave.store %a3 -> %p3 after %t2
      : (!wave.simd<i16, 32>, !wave.ptr<#wave.global, i16>,
         !wave.mem.token)
      -> !wave.mem.token
  return
}

// -----

// CHECK-LABEL: func.func @reversed_source_order
// CHECK-SAME: ([[OUT:%.*]]: !wave.ptr<#wave.global, f16>, [[LO:%.*]]: !wave.simd<f16, 32>, [[HI:%.*]]: !wave.simd<f16, 32>)
func.func @reversed_source_order(%out: !wave.ptr<#wave.global, f16>,
                                 %lo: !wave.simd<f16, 32>,
                                 %hi: !wave.simd<f16, 32>)
    attributes {wave.kernel} {
  %c1 = arith.constant 1 : i32
  %p1 = wave.ptr_add %out, %c1
      : !wave.ptr<#wave.global, f16>, i32 -> !wave.ptr<#wave.global, f16>
  // CHECK: [[PACK:%.*]] = wave.pack [[LO]], [[HI]] : !wave.simd<f16, 32>, !wave.simd<f16, 32> -> !wave.simd<vector<2xf16>, 32>
  // CHECK: wave.store [[PACK]] -> [[OUT]]
  %t0 = wave.store %hi -> %p1
      : (!wave.simd<f16, 32>, !wave.ptr<#wave.global, f16>)
      -> !wave.mem.token
  %t1 = wave.store %lo -> %out after %t0
      : (!wave.simd<f16, 32>, !wave.ptr<#wave.global, f16>,
         !wave.mem.token)
      -> !wave.mem.token
  return
}

// -----

// CHECK-LABEL: func.func @symbolic_delta_and_token_rewrite
// CHECK-SAME: ([[OUT:%.*]]: !wave.ptr<#wave.global, f32>, [[A:%.*]]: !wave.simd<f32, 32>, [[B:%.*]]: !wave.simd<f32, 32>)
func.func @symbolic_delta_and_token_rewrite(%out: !wave.ptr<#wave.global, f32>,
                                            %a: !wave.simd<f32, 32>,
                                            %b: !wave.simd<f32, 32>)
    attributes {wave.kernel} {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %off0 = wave.index_expr <"lid"> ["lid"](%lane)
      : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
  %off1 = wave.index_expr <"lid + 1"> ["lid"](%lane)
      : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
  %p0 = wave.ptr_add %out, %off0
      : !wave.ptr<#wave.global, f32>, !wave.simd<index, 32>
      -> !wave.simd<!wave.ptr<#wave.global, f32>, 32>
  %p1 = wave.ptr_add %out, %off1
      : !wave.ptr<#wave.global, f32>, !wave.simd<index, 32>
      -> !wave.simd<!wave.ptr<#wave.global, f32>, 32>
  // CHECK: [[PACK:%.*]] = wave.pack [[A]], [[B]] : !wave.simd<f32, 32>, !wave.simd<f32, 32> -> !wave.simd<vector<2xf32>, 32>
  // CHECK: [[TOK:%.*]] = wave.store [[PACK]] -> %{{.*}} : (!wave.simd<vector<2xf32>, 32>, !wave.simd<!wave.ptr<#wave.global, f32>, 32>) -> !wave.mem.token
  // CHECK: wave.load [[OUT]] after [[TOK]]
  %t0 = wave.store %a -> %p0
      : (!wave.simd<f32, 32>,
         !wave.simd<!wave.ptr<#wave.global, f32>, 32>)
      -> !wave.mem.token
  %t1 = wave.store %b -> %p1 after %t0
      : (!wave.simd<f32, 32>,
         !wave.simd<!wave.ptr<#wave.global, f32>, 32>, !wave.mem.token)
      -> !wave.mem.token
  %v, %lt = wave.load %out after %t1
      : (!wave.ptr<#wave.global, f32>, !wave.mem.token)
      -> (!wave.simd<f32, 32>, !wave.mem.token)
  return
}

// -----

// CHECK-LABEL: func.func @bf16_pair
// CHECK-SAME: ([[OUT:%.*]]: !wave.ptr<#wave.global, bf16>, [[A:%.*]]: !wave.simd<bf16, 32>, [[B:%.*]]: !wave.simd<bf16, 32>)
func.func @bf16_pair(%out: !wave.ptr<#wave.global, bf16>,
                     %a: !wave.simd<bf16, 32>,
                     %b: !wave.simd<bf16, 32>)
    attributes {wave.kernel} {
  %c1 = arith.constant 1 : i32
  %p1 = wave.ptr_add %out, %c1
      : !wave.ptr<#wave.global, bf16>, i32 -> !wave.ptr<#wave.global, bf16>
  // CHECK: [[PACK:%.*]] = wave.pack [[A]], [[B]] : !wave.simd<bf16, 32>, !wave.simd<bf16, 32> -> !wave.simd<vector<2xbf16>, 32>
  // CHECK: wave.store [[PACK]] -> [[OUT]]
  %t0 = wave.store %a -> %out
      : (!wave.simd<bf16, 32>, !wave.ptr<#wave.global, bf16>)
      -> !wave.mem.token
  %t1 = wave.store %b -> %p1 after %t0
      : (!wave.simd<bf16, 32>, !wave.ptr<#wave.global, bf16>,
         !wave.mem.token)
      -> !wave.mem.token
  return
}

// -----

// CHECK-LABEL: func.func @intervening_independent_store_can_cross
// CHECK-SAME: ([[OUT:%.*]]: !wave.ptr<#wave.global, f16>, [[OTHER:%.*]]: !wave.ptr<#wave.global, f32>, [[A:%.*]]: !wave.simd<f16, 32>, [[B:%.*]]: !wave.simd<f16, 32>, [[M:%.*]]: !wave.simd<f32, 32>)
func.func @intervening_independent_store_can_cross(%out: !wave.ptr<#wave.global, f16>,
                                                   %other: !wave.ptr<#wave.global, f32>,
                                                   %a: !wave.simd<f16, 32>,
                                                   %b: !wave.simd<f16, 32>,
                                                   %m: !wave.simd<f32, 32>)
    attributes {wave.kernel} {
  %c1 = arith.constant 1 : i32
  %p1 = wave.ptr_add %out, %c1
      : !wave.ptr<#wave.global, f16>, i32 -> !wave.ptr<#wave.global, f16>
  // CHECK: wave.store [[M]] -> [[OTHER]]
  // CHECK: [[PACK:%.*]] = wave.pack [[A]], [[B]] : !wave.simd<f16, 32>, !wave.simd<f16, 32> -> !wave.simd<vector<2xf16>, 32>
  // CHECK: wave.store [[PACK]] -> [[OUT]]
  %t0 = wave.store %a -> %out
      : (!wave.simd<f16, 32>, !wave.ptr<#wave.global, f16>)
      -> !wave.mem.token
  %tm = wave.store %m -> %other
      : (!wave.simd<f32, 32>, !wave.ptr<#wave.global, f32>)
      -> !wave.mem.token
  %t1 = wave.store %b -> %p1 after %t0
      : (!wave.simd<f16, 32>, !wave.ptr<#wave.global, f16>,
         !wave.mem.token)
      -> !wave.mem.token
  return
}

// -----

// CHECK-LABEL: func.func @escaped_intermediate_token_stays
// CHECK-NOT: wave.pack
// CHECK: wave.store
// CHECK: wave.store
// CHECK: wave.load
func.func @escaped_intermediate_token_stays(%out: !wave.ptr<#wave.global, f16>,
                                            %a: !wave.simd<f16, 32>,
                                            %b: !wave.simd<f16, 32>)
    attributes {wave.kernel} {
  %c1 = arith.constant 1 : i32
  %p1 = wave.ptr_add %out, %c1
      : !wave.ptr<#wave.global, f16>, i32 -> !wave.ptr<#wave.global, f16>
  %t0 = wave.store %a -> %out
      : (!wave.simd<f16, 32>, !wave.ptr<#wave.global, f16>)
      -> !wave.mem.token
  %t1 = wave.store %b -> %p1 after %t0
      : (!wave.simd<f16, 32>, !wave.ptr<#wave.global, f16>,
         !wave.mem.token)
      -> !wave.mem.token
  %v, %lt = wave.load %out after %t0
      : (!wave.ptr<#wave.global, f16>, !wave.mem.token)
      -> (!wave.simd<f16, 32>, !wave.mem.token)
  return
}

// -----

// CHECK-LABEL: func.func @forked_store_token_stays
// CHECK-NOT: wave.pack
// CHECK: wave.store
// CHECK: wave.store
// CHECK: wave.store
func.func @forked_store_token_stays(%out: !wave.ptr<#wave.global, f16>,
                                    %other: !wave.ptr<#wave.global, f32>,
                                    %a: !wave.simd<f16, 32>,
                                    %b: !wave.simd<f16, 32>,
                                    %m: !wave.simd<f32, 32>)
    attributes {wave.kernel} {
  %c1 = arith.constant 1 : i32
  %p1 = wave.ptr_add %out, %c1
      : !wave.ptr<#wave.global, f16>, i32 -> !wave.ptr<#wave.global, f16>
  %t0 = wave.store %a -> %out
      : (!wave.simd<f16, 32>, !wave.ptr<#wave.global, f16>)
      -> !wave.mem.token
  %tm = wave.store %m -> %other after %t0
      : (!wave.simd<f32, 32>, !wave.ptr<#wave.global, f32>,
         !wave.mem.token)
      -> !wave.mem.token
  %t1 = wave.store %b -> %p1 after %t0
      : (!wave.simd<f16, 32>, !wave.ptr<#wave.global, f16>,
         !wave.mem.token)
      -> !wave.mem.token
  return
}

// -----

// CHECK-LABEL: func.func @intervening_store_token_chain_stays
// CHECK-NOT: wave.pack
// CHECK: wave.store
// CHECK: wave.store
// CHECK: wave.store
func.func @intervening_store_token_chain_stays(%out: !wave.ptr<#wave.global, f16>,
                                               %other: !wave.ptr<#wave.global, f32>,
                                               %a: !wave.simd<f16, 32>,
                                               %b: !wave.simd<f16, 32>,
                                               %m: !wave.simd<f32, 32>)
    attributes {wave.kernel} {
  %c1 = arith.constant 1 : i32
  %p1 = wave.ptr_add %out, %c1
      : !wave.ptr<#wave.global, f16>, i32 -> !wave.ptr<#wave.global, f16>
  %t0 = wave.store %a -> %out
      : (!wave.simd<f16, 32>, !wave.ptr<#wave.global, f16>)
      -> !wave.mem.token
  %tm = wave.store %m -> %other after %t0
      : (!wave.simd<f32, 32>, !wave.ptr<#wave.global, f32>,
         !wave.mem.token)
      -> !wave.mem.token
  %t1 = wave.store %b -> %p1 after %tm
      : (!wave.simd<f16, 32>, !wave.ptr<#wave.global, f16>,
         !wave.mem.token)
      -> !wave.mem.token
  return
}

// -----

// CHECK-LABEL: func.func @non_adjacent_address_stays
// CHECK-NOT: wave.pack
// CHECK: wave.store
// CHECK: wave.store
func.func @non_adjacent_address_stays(%out: !wave.ptr<#wave.global, f16>,
                                      %a: !wave.simd<f16, 32>,
                                      %b: !wave.simd<f16, 32>)
    attributes {wave.kernel} {
  %c2 = arith.constant 2 : i32
  %p2 = wave.ptr_add %out, %c2
      : !wave.ptr<#wave.global, f16>, i32 -> !wave.ptr<#wave.global, f16>
  %t0 = wave.store %a -> %out
      : (!wave.simd<f16, 32>, !wave.ptr<#wave.global, f16>)
      -> !wave.mem.token
  %t1 = wave.store %b -> %p2 after %t0
      : (!wave.simd<f16, 32>, !wave.ptr<#wave.global, f16>,
         !wave.mem.token)
      -> !wave.mem.token
  return
}

// -----

// CHECK-LABEL: func.func @mismatched_type_stays
// CHECK-NOT: wave.pack
// CHECK: wave.store
// CHECK: wave.store
func.func @mismatched_type_stays(%out: !wave.ptr<#wave.global, f16>,
                                 %a: !wave.simd<f16, 32>,
                                 %b: !wave.simd<i16, 32>)
    attributes {wave.kernel} {
  %c1 = arith.constant 1 : i32
  %p1 = wave.ptr_add %out, %c1
      : !wave.ptr<#wave.global, f16>, i32 -> !wave.ptr<#wave.global, f16>
  %t0 = wave.store %a -> %out
      : (!wave.simd<f16, 32>, !wave.ptr<#wave.global, f16>)
      -> !wave.mem.token
  %t1 = wave.store %b -> %p1 after %t0
      : (!wave.simd<i16, 32>, !wave.ptr<#wave.global, f16>,
         !wave.mem.token)
      -> !wave.mem.token
  return
}

// -----

// CHECK-LABEL: func.func @mismatched_symbol_binding_stays
// CHECK-NOT: wave.pack
// CHECK: wave.store
// CHECK: wave.store
func.func @mismatched_symbol_binding_stays(%out: !wave.ptr<#wave.global, f32>,
                                           %a: !wave.simd<i32, 32>,
                                           %b: !wave.simd<i32, 32>,
                                           %v0: !wave.simd<f32, 32>,
                                           %v1: !wave.simd<f32, 32>)
    attributes {wave.kernel} {
  %off0 = wave.index_expr <"x"> ["x"](%a)
      : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
  %off1 = wave.index_expr <"x + 1"> ["x"](%b)
      : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
  %p0 = wave.ptr_add %out, %off0
      : !wave.ptr<#wave.global, f32>, !wave.simd<index, 32>
      -> !wave.simd<!wave.ptr<#wave.global, f32>, 32>
  %p1 = wave.ptr_add %out, %off1
      : !wave.ptr<#wave.global, f32>, !wave.simd<index, 32>
      -> !wave.simd<!wave.ptr<#wave.global, f32>, 32>
  %t0 = wave.store %v0 -> %p0
      : (!wave.simd<f32, 32>,
         !wave.simd<!wave.ptr<#wave.global, f32>, 32>)
      -> !wave.mem.token
  %t1 = wave.store %v1 -> %p1 after %t0
      : (!wave.simd<f32, 32>,
         !wave.simd<!wave.ptr<#wave.global, f32>, 32>, !wave.mem.token)
      -> !wave.mem.token
  return
}
