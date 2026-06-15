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
  %offset = wave.binary addi %idx, %s16 : !wave.simd<index, 32>, !wave.simd<index, 32> -> !wave.simd<index, 32>
  // CHECK: wave.index_expr <"64 + 4*raw0"> ["raw0"](%[[IDX]]) : (!wave.simd<index, 32>) -> !wave.simd<index, 32>
  %ptr = wave.ptr_add %out, %offset : !wave.ptr<#wave.global, f32>, !wave.simd<index, 32> -> !wave.simd<!wave.ptr<#wave.global, f32>, 32>
  %cst = arith.constant 0.000000e+00 : f32
  %val = wave.splat %cst : f32 -> !wave.simd<f32, 32>
  %token = wave.store %val -> %ptr : (!wave.simd<f32, 32>, !wave.simd<!wave.ptr<#wave.global, f32>, 32>) -> !wave.mem.token
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
  // CHECK: wave.index_expr <"4*floor(1/2*raw0)"> ["raw0"](%[[ASSUME]]) : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
  %ptr = wave.ptr_add %out, %half
      : !wave.ptr<#wave.global, f32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.global, f32>, 32>
  %val = wave.splat %cst : f32 -> !wave.simd<f32, 32>
  %token = wave.store %val -> %ptr
      : (!wave.simd<f32, 32>, !wave.simd<!wave.ptr<#wave.global, f32>, 32>)
      -> !wave.mem.token
  return
}
