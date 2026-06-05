// RUN: wave-opt --split-input-file --wave-combine-pointer-offsets %s | FileCheck %s

// CHECK-LABEL: func.func @raw_and_symbolic
func.func @raw_and_symbolic(%out: !wave.ptr<#wave.global, i32>) attributes {wave.kernel} {
  %c7 = arith.constant 7 : i32
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %base = wave.ptr_add %out, %c7
      : !wave.ptr<#wave.global, i32>, i32 -> !wave.ptr<#wave.global, i32>
  %off = wave.index_expr <"1024 + lid"> ["lid"](%lane)
      : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
  // CHECK: %[[OFF:.*]] = wave.index_expr <"1031 + lid"> ["lid"](%{{.*}}) : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
  // CHECK: wave.ptr_add %arg0, %[[OFF]]
  %ptrs = wave.ptr_add %base, %off
      : !wave.ptr<#wave.global, i32>, !wave.simd<index, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %value, %token = wave.load %ptrs
      : (!wave.simd<!wave.ptr<#wave.global, i32>, 32>)
      -> (!wave.simd<i32, 32>, !wave.mem.token)
  return
}

// -----

// CHECK-LABEL: func.func @raw_wave_arith
func.func @raw_wave_arith(%out: !wave.ptr<#wave.global, i32>) attributes {wave.kernel} {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %c8 = arith.constant 8 : i32
  %stride = wave.splat %c8 : i32 -> !wave.simd<i32, 32>
  %lane_off = wave.binary muli %lane, %stride
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %base = wave.ptr_add %out, %c8
      : !wave.ptr<#wave.global, i32>, i32 -> !wave.ptr<#wave.global, i32>
  // CHECK: %[[OFF:.*]] = wave.index_expr <"8 + 8*raw0"> ["raw0"](%{{.*}}) : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
  // CHECK: wave.ptr_add %arg0, %[[OFF]]
  %ptrs = wave.ptr_add %base, %lane_off
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %value, %token = wave.load %ptrs
      : (!wave.simd<!wave.ptr<#wave.global, i32>, 32>)
      -> (!wave.simd<i32, 32>, !wave.mem.token)
  return
}

// -----

// CHECK-LABEL: func.func @raw_wave_xor
func.func @raw_wave_xor(%out: !wave.ptr<#wave.global, i32>) attributes {wave.kernel} {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %c31 = arith.constant 31 : i32
  %mask = wave.splat %c31 : i32 -> !wave.simd<i32, 32>
  %swizzled = wave.binary xori %lane, %mask
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %base = wave.ptr_add %out, %c31
      : !wave.ptr<#wave.global, i32>, i32 -> !wave.ptr<#wave.global, i32>
  // CHECK: %[[OFF:.*]] = wave.index_expr <"31 + xor(31, raw0)"> ["raw0"](%{{.*}}) : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
  // CHECK: wave.ptr_add %arg0, %[[OFF]]
  %ptrs = wave.ptr_add %base, %swizzled
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %value, %token = wave.load %ptrs
      : (!wave.simd<!wave.ptr<#wave.global, i32>, 32>)
      -> (!wave.simd<i32, 32>, !wave.mem.token)
  return
}

// -----

// CHECK-LABEL: func.func @opaque_raw_skips
func.func @opaque_raw_skips(%out: !wave.ptr<#wave.global, i32>,
                            %a: i32,
                            %b: !wave.simd<i32, 32>) attributes {wave.kernel} {
  %base = wave.ptr_add %out, %a
      : !wave.ptr<#wave.global, i32>, i32 -> !wave.ptr<#wave.global, i32>
  // CHECK: %[[BASE:.*]] = wave.ptr_add %arg0, %arg1
  // CHECK: wave.ptr_add %[[BASE]], %arg2 : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32>
  %ptrs = wave.ptr_add %base, %b
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %value, %token = wave.load %ptrs
      : (!wave.simd<!wave.ptr<#wave.global, i32>, 32>)
      -> (!wave.simd<i32, 32>, !wave.mem.token)
  return
}

// -----

// CHECK-LABEL: func.func @shared_binding_name
func.func @shared_binding_name(%out: !wave.ptr<#wave.global, i32>,
                               %lane: !wave.simd<i32, 32>) attributes {wave.kernel} {
  %off0 = wave.index_expr <"lid"> ["lid"](%lane)
      : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
  %base = wave.ptr_add %out, %off0
      : !wave.ptr<#wave.global, i32>, !wave.simd<index, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %off1 = wave.index_expr <"2*lid"> ["lid"](%lane)
      : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
  // CHECK: %[[OFF:.*]] = wave.index_expr <"3*lid"> ["lid"](%arg1) : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
  // CHECK: wave.ptr_add %arg0, %[[OFF]]
  %ptrs = wave.ptr_add %base, %off1
      : !wave.simd<!wave.ptr<#wave.global, i32>, 32>, !wave.simd<index, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %value, %token = wave.load %ptrs
      : (!wave.simd<!wave.ptr<#wave.global, i32>, 32>)
      -> (!wave.simd<i32, 32>, !wave.mem.token)
  return
}

// -----

// CHECK-LABEL: func.func @name_collision_renames
// CHECK-SAME: ([[OUT:%.*]]: !wave.ptr<#wave.global, i32>,
// CHECK-SAME: [[A:%.*]]: !wave.simd<i32, 32>,
// CHECK-SAME: [[B:%.*]]: !wave.simd<i32, 32>)
func.func @name_collision_renames(%out: !wave.ptr<#wave.global, i32>,
                                  %a: !wave.simd<i32, 32>,
                                  %b: !wave.simd<i32, 32>) attributes {wave.kernel} {
  %off0 = wave.index_expr <"x"> ["x"](%a)
      : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
  %base = wave.ptr_add %out, %off0
      : !wave.ptr<#wave.global, i32>, !wave.simd<index, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %off1 = wave.index_expr <"x"> ["x"](%b)
      : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
  // CHECK: [[OFF:%.*]] = wave.index_expr <"x + x0"> ["x", "x0"]([[A]], [[B]]) : (!wave.simd<i32, 32>, !wave.simd<i32, 32>) -> !wave.simd<index, 32>
  // CHECK: wave.ptr_add [[OUT]], [[OFF]]
  %ptrs = wave.ptr_add %base, %off1
      : !wave.simd<!wave.ptr<#wave.global, i32>, 32>, !wave.simd<index, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %value, %token = wave.load %ptrs
      : (!wave.simd<!wave.ptr<#wave.global, i32>, 32>)
      -> (!wave.simd<i32, 32>, !wave.mem.token)
  return
}

// -----

// CHECK-LABEL: func.func @merge_nested_index_expr
func.func @merge_nested_index_expr(%out: !wave.ptr<#wave.global, i32>,
                                   %k: i32,
                                   %lane: !wave.simd<i32, 32>) attributes {wave.kernel} {
  %inner = wave.index_expr <"1 + lid"> ["lid"](%lane)
      : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
  %outer = wave.index_expr <"K + 4*x"> ["K", "x"](%k, %inner)
      : (i32, !wave.simd<index, 32>) -> !wave.simd<index, 32>
  // CHECK: %[[OFF:.*]] = wave.index_expr <"4 + K + 4*lid"> ["K", "lid"](%arg1, %arg2) : (i32, !wave.simd<i32, 32>) -> !wave.simd<index, 32>
  // CHECK: wave.ptr_add %arg0, %[[OFF]]
  %ptrs = wave.ptr_add %out, %outer
      : !wave.ptr<#wave.global, i32>, !wave.simd<index, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %value, %token = wave.load %ptrs
      : (!wave.simd<!wave.ptr<#wave.global, i32>, 32>)
      -> (!wave.simd<i32, 32>, !wave.mem.token)
  return
}

// -----

// CHECK-LABEL: func.func @merge_nested_index_expr_collision
func.func @merge_nested_index_expr_collision(%out: !wave.ptr<#wave.global, i32>,
                                             %a: !wave.simd<i32, 32>,
                                             %b: !wave.simd<i32, 32>) attributes {wave.kernel} {
  %inner = wave.index_expr <"2*y"> ["y"](%a)
      : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
  %outer = wave.index_expr <"x + y"> ["x", "y"](%inner, %b)
      : (!wave.simd<index, 32>, !wave.simd<i32, 32>)
      -> !wave.simd<index, 32>
  // CHECK: %[[OFF:.*]] = wave.index_expr <"y + 2*y_0"> ["y_0", "y"](%arg1, %arg2) : (!wave.simd<i32, 32>, !wave.simd<i32, 32>) -> !wave.simd<index, 32>
  // CHECK: wave.ptr_add %arg0, %[[OFF]]
  %ptrs = wave.ptr_add %out, %outer
      : !wave.ptr<#wave.global, i32>, !wave.simd<index, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %value, %token = wave.load %ptrs
      : (!wave.simd<!wave.ptr<#wave.global, i32>, 32>)
      -> (!wave.simd<i32, 32>, !wave.mem.token)
  return
}

// -----

// CHECK-LABEL: func.func @merge_nested_index_expr_reuse_binding
func.func @merge_nested_index_expr_reuse_binding(%out: !wave.ptr<#wave.global, i32>,
                                                 %lane: !wave.simd<i32, 32>) attributes {wave.kernel} {
  %inner = wave.index_expr <"2*y"> ["y"](%lane)
      : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
  %outer = wave.index_expr <"x + y"> ["x", "y"](%inner, %lane)
      : (!wave.simd<index, 32>, !wave.simd<i32, 32>)
      -> !wave.simd<index, 32>
  // CHECK: %[[OFF:.*]] = wave.index_expr <"3*y"> ["y"](%arg1) : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
  // CHECK: wave.ptr_add %arg0, %[[OFF]]
  %ptrs = wave.ptr_add %out, %outer
      : !wave.ptr<#wave.global, i32>, !wave.simd<index, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %value, %token = wave.load %ptrs
      : (!wave.simd<!wave.ptr<#wave.global, i32>, 32>)
      -> (!wave.simd<i32, 32>, !wave.mem.token)
  return
}
