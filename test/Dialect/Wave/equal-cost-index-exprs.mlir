// RUN: wave-opt --wave-simplify-index-exprs --canonicalize --cse %s > %t.once
// RUN: FileCheck %s < %t.once
// RUN: wave-opt --wave-simplify-index-exprs --canonicalize --cse %t.once > %t.twice
// RUN: diff %t.once %t.twice

// CHECK-LABEL: func.func @equal_forms
// CHECK: %[[SHARED:.*]] = wave.index_expr <"256*K + 4*lid">
// CHECK-NOT: wave.index_expr
// CHECK: return %[[SHARED]], %[[SHARED]]
func.func @equal_forms(%k: i32, %lane: !wave.simd<i32, 32>) -> (!wave.simd<index, 32>, !wave.simd<index, 32>) {
  %a = wave.index_expr <"4*(64*K + lid)"> ["K", "lid"](%k, %lane) : (i32, !wave.simd<i32, 32>) -> !wave.simd<index, 32>
  %b = wave.index_expr <"256*K + 4*lid"> ["K", "lid"](%k, %lane) : (i32, !wave.simd<i32, 32>) -> !wave.simd<index, 32>
  return %a, %b : !wave.simd<index, 32>, !wave.simd<index, 32>
}
