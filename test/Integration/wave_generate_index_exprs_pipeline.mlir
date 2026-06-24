// RUN: wave-opt --split-input-file --wave-normalize-pointer-offsets \
// RUN:   --wave-generate-index-exprs --wave-combine-pointer-offsets \
// RUN:   --wave-simplify-index-exprs %s | FileCheck %s

// CHECK-LABEL: func.func @generate_after_normalize
// CHECK-SAME: (%{{.*}}: !wave.ptr<#wave.global>, %[[IDX:.*]]: !wave.simd<index, 32>)
func.func @generate_after_normalize(%out: !wave.ptr<#wave.global, f32>,
                                    %idx: !wave.simd<index, 32>)
    attributes {wave.kernel} {
  %c16 = arith.constant 16 : index
  %s16 = wave.splat %c16 : index -> !wave.simd<index, 32>
  %offset = wave.binary addi %idx, %s16 overflow<nsw> : !wave.simd<index, 32>, !wave.simd<index, 32> -> !wave.simd<index, 32>
  // CHECK: wave.index_expr <"64 + 4*raw0"> ["raw0"](%[[IDX]]) : (!wave.simd<index, 32>) -> !wave.simd<index, 32>
  %ptr = wave.ptr_add %out, %offset : !wave.ptr<#wave.global, f32>, !wave.simd<index, 32> -> !wave.simd<!wave.ptr<#wave.global, f32>, 32>
  %cst = arith.constant 0.000000e+00 : f32
  %val = wave.splat %cst : f32 -> !wave.simd<f32, 32>
  %token = wave.store %val -> %ptr : (!wave.simd<f32, 32>, !wave.simd<!wave.ptr<#wave.global, f32>, 32>) -> !wave.mem.token
  return
}

// CHECK-LABEL: func.func @rewrite_nested_splat_leaf_after_normalize
// CHECK-SAME: (%{{.*}}: !wave.ptr<#wave.global>, %[[STRIDE:.*]]: i32, %[[BASE:.*]]: i32)
func.func @rewrite_nested_splat_leaf_after_normalize(
    %out: !wave.ptr<#wave.global, f16>, %stride_raw: i32, %base_raw: i32)
    attributes {wave.kernel, wave.workgroup_size = array<i32: 512, 1, 1>} {
  %zero = arith.constant 0.000000e+00 : f16
  %c6 = arith.constant 6 : i32
  %c8 = arith.constant 8 : i32
  %c63 = arith.constant 63 : i32
  %c255 = arith.constant 255 : i32
  %c256 = arith.constant 256 : i32
  %wi = wave.workitem_id 0 : !wave.simd<i32, 64>
  %s6 = wave.splat %c6 : i32 -> !wave.simd<i32, 64>
  %s8 = wave.splat %c8 : i32 -> !wave.simd<i32, 64>
  %s63 = wave.splat %c63 : i32 -> !wave.simd<i32, 64>
  %s255 = wave.splat %c255 : i32 -> !wave.simd<i32, 64>
  %linear = wave.binary muli %wi, %s8 overflow<nsw>
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
  %lo = wave.binary andi %linear, %s63
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
  %hi0 = wave.binary shrui %linear, %s6
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
  %hi = wave.binary andi %hi0, %s255
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
  %stride = wave.assume %stride_raw as "x" [#wave.pred<"x >= 0">] : i32
  %sstride = wave.splat %stride : i32 -> !wave.simd<i32, 64>
  %base_scaled = wave.binary muli %base_raw, %c256 : i32, i32 -> i32
  %sbase = wave.splat %base_scaled : i32 -> !wave.simd<i32, 64>
  %row = wave.binary muli %hi, %sstride overflow<nsw>
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
  %sum0 = wave.binary addi %lo, %row overflow<nsw>
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
  %base = wave.binary muli %sbase, %sstride overflow<nsw>
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
  %sum = wave.binary addi %sum0, %base overflow<nsw>
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
  %orig = wave.assume %sum as "orig"
      [#wave.pred<"orig >= 0">, #wave.pred<"orig <= 1073741816">]
      : !wave.simd<i32, 64>
  // CHECK: wave.index_expr <{{.*}}Mod({{.*}}> {{.*}} ["raw0", "raw1", "raw2"]
  // CHECK-NOT: 2*orig
  %ptr = wave.ptr_add %out, %orig
      : !wave.ptr<#wave.global, f16>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#wave.global, f16>, 64>
  %val = wave.splat %zero : f16 -> !wave.simd<f16, 64>
  %token = wave.store %val -> %ptr
      : (!wave.simd<f16, 64>, !wave.simd<!wave.ptr<#wave.global, f16>, 64>)
      -> !wave.mem.token
  // CHECK: wave.store
  return
}

// CHECK-LABEL: func.func @generate_divsi_after_normalize
// CHECK-SAME: (%{{.*}}: !wave.ptr<#wave.global>, %[[IDX:.*]]: !wave.simd<i32, 32>)
func.func @generate_divsi_after_normalize(%out: !wave.ptr<#wave.global, f32>,
                                          %idx_raw: !wave.simd<i32, 32>)
    attributes {wave.kernel} {
  %c2 = arith.constant 2 : i32
  %cst = arith.constant 0.000000e+00 : f32
  // CHECK: %[[ASSUME:.*]] = wave.assume %[[IDX]]
  %idx = wave.assume %idx_raw as "x" [#wave.pred<"x >= 0">, #wave.pred<"x <= 31">] : !wave.simd<i32, 32>
  %s2 = wave.splat %c2 : i32 -> !wave.simd<i32, 32>
  %half = wave.binary divsi %idx, %s2
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  // CHECK: wave.index_expr <"4*floor(1/2*raw0)"> assuming [#wave.pred<"raw0 >= 0">, #wave.pred<"-31 + raw0 <= 0">] ["raw0"](%[[ASSUME]]) : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
  %ptr = wave.ptr_add %out, %half
      : !wave.ptr<#wave.global, f32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.global, f32>, 32>
  %val = wave.splat %cst : f32 -> !wave.simd<f32, 32>
  %token = wave.store %val -> %ptr
      : (!wave.simd<f32, 32>, !wave.simd<!wave.ptr<#wave.global, f32>, 32>)
      -> !wave.mem.token
  return
}

// CHECK-LABEL: func.func @rewrite_assumed_offset_after_normalize
// CHECK-SAME: (%{{.*}}: !wave.ptr<#wave.global>, %[[IDX:.*]]: !wave.simd<i32, 32>)
func.func @rewrite_assumed_offset_after_normalize(
    %out: !wave.ptr<#wave.global, f16>, %idx_raw: !wave.simd<i32, 32>)
    attributes {wave.kernel} {
  %c0 = arith.constant 0.000000e+00 : f16
  %c1 = arith.constant 1 : i32
  %c4 = arith.constant 4 : i32
  %c63 = arith.constant 63 : i32
  // CHECK: %[[ASSUME:.*]] = wave.assume %[[IDX]]
  %idx = wave.assume %idx_raw as "x" [#wave.pred<"x >= 0">, #wave.pred<"x <= 31">] : !wave.simd<i32, 32>
  %s1 = wave.splat %c1 : i32 -> !wave.simd<i32, 32>
  %s4 = wave.splat %c4 : i32 -> !wave.simd<i32, 32>
  %s63 = wave.splat %c63 : i32 -> !wave.simd<i32, 32>
  %hi = wave.binary shrui %idx, %s1
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %lo = wave.binary andi %idx, %s63
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %scaled_hi = wave.binary muli %hi, %s4
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %offset = wave.binary addi %lo, %scaled_hi
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %orig = wave.assume %offset as "orig" [#wave.pred<"orig >= 0">, #wave.pred<"orig <= 94">] : !wave.simd<i32, 32>
  // CHECK: wave.index_expr <"2*raw0 + 8*floor(1/2*raw0)"> {{.*}} ["raw0"](%[[ASSUME]]) : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
  // CHECK-NOT: 2*orig
  %ptr = wave.ptr_add %out, %orig
      : !wave.ptr<#wave.global, f16>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.global, f16>, 32>
  %val = wave.splat %c0 : f16 -> !wave.simd<f16, 32>
  %token = wave.store %val -> %ptr
      : (!wave.simd<f16, 32>, !wave.simd<!wave.ptr<#wave.global, f16>, 32>)
      -> !wave.mem.token
  return
}

// CHECK-LABEL: func.func @rewrite_assumed_buffer_offset_after_normalize
// CHECK-SAME: (%{{.*}}: !wave.ptr<#waveamd.buffer>, %[[IDX:.*]]: !wave.simd<i32, 32>)
func.func @rewrite_assumed_buffer_offset_after_normalize(
    %out: !wave.ptr<#waveamd.buffer, f16>, %idx_raw: !wave.simd<i32, 32>)
    -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 32>
    attributes {wave.kernel} {
  %c1 = arith.constant 1 : i32
  %c4 = arith.constant 4 : i32
  %c63 = arith.constant 63 : i32
  // CHECK: %[[BUFFER_ASSUME:.*]] = wave.assume %[[IDX]]
  %idx = wave.assume %idx_raw as "x" [#wave.pred<"x >= 0">, #wave.pred<"x <= 31">] : !wave.simd<i32, 32>
  %s1 = wave.splat %c1 : i32 -> !wave.simd<i32, 32>
  %s4 = wave.splat %c4 : i32 -> !wave.simd<i32, 32>
  %s63 = wave.splat %c63 : i32 -> !wave.simd<i32, 32>
  %hi = wave.binary shrui %idx, %s1
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %lo = wave.binary andi %idx, %s63
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %scaled_hi = wave.binary muli %hi, %s4
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %offset = wave.binary addi %lo, %scaled_hi
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %orig = wave.assume %offset as "orig" [#wave.pred<"orig >= 0">, #wave.pred<"orig <= 94">] : !wave.simd<i32, 32>
  // CHECK: wave.index_expr <"2*raw0 + 8*floor(1/2*raw0)"> {{.*}} ["raw0"](%[[BUFFER_ASSUME]]) : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
  // CHECK-NOT: 2*orig
  %ptr = wave.ptr_add %out, %orig
      : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 32>
  return %ptr : !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 32>
}
