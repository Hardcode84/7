// RUN: wave-opt %s --canonicalize | FileCheck %s
// RUN: wave-opt %s --canonicalize='top-down=true' | FileCheck %s
// RUN: wave-opt %s --canonicalize -o %t.once
// RUN: wave-opt %t.once --canonicalize -o %t.twice
// RUN: diff %t.once %t.twice

// CHECK-LABEL: func.func @duplicates(
// CHECK: %[[MUL:.*]] = arith.muli
// CHECK: %[[ADD:.*]] = arith.addi
// CHECK: %[[SHIFT:.*]] = arith.shli
// CHECK: %[[CHOICE:.*]] = wave.materialization_variants %[[MUL]], %[[ADD]], %[[SHIFT]] {test.marker = 7 : i64} : i32
// CHECK-NEXT: return %[[CHOICE]]
func.func @duplicates(%x: i32) -> i32 {
  %one = arith.constant 1 : i32
  %two = arith.constant 2 : i32
  %mul = arith.muli %x, %two : i32
  %add = arith.addi %x, %x : i32
  %shift = arith.shli %x, %one : i32
  %choice = wave.materialization_variants %mul, %add, %mul, %shift, %add
      {test.marker = 7 : i64} : i32
  return %choice : i32
}

// CHECK-LABEL: func.func @nested(
// CHECK: %[[MUL:.*]] = arith.muli
// CHECK: %[[ADD:.*]] = arith.addi
// CHECK: %[[SHIFT:.*]] = arith.shli
// CHECK-NEXT: %[[CHOICE:.*]] = wave.materialization_variants %[[MUL]], %[[ADD]], %[[SHIFT]] : i32
// CHECK-NEXT: return %[[CHOICE]]
func.func @nested(%x: i32) -> i32 {
  %one = arith.constant 1 : i32
  %two = arith.constant 2 : i32
  %mul = arith.muli %x, %two : i32
  %add = arith.addi %x, %x : i32
  %shift = arith.shli %x, %one : i32
  %inner = wave.materialization_variants %mul, %add : i32
  %middle = wave.materialization_variants %inner, %shift, %add : i32
  %outer = wave.materialization_variants %middle, %inner, %mul, %shift : i32
  return %outer : i32
}

// CHECK-LABEL: func.func @shared_producer(
// CHECK: %[[MUL:.*]] = arith.muli
// CHECK: %[[ADD:.*]] = arith.addi
// CHECK: %[[SHIFT:.*]] = arith.shli
// CHECK-NEXT: %[[INNER:.*]] = wave.materialization_variants %[[MUL]], %[[ADD]] : i32
// CHECK-NEXT: %[[OUTER:.*]] = wave.materialization_variants %[[SHIFT]], %[[MUL]], %[[ADD]] : i32
// CHECK-NEXT: return %[[INNER]], %[[OUTER]]
func.func @shared_producer(%x: i32) -> (i32, i32) {
  %one = arith.constant 1 : i32
  %two = arith.constant 2 : i32
  %mul = arith.muli %x, %two : i32
  %add = arith.addi %x, %x : i32
  %shift = arith.shli %x, %one : i32
  %inner = wave.materialization_variants %mul, %add : i32
  %outer = wave.materialization_variants %shift, %inner, %mul : i32
  return %inner, %outer : i32, i32
}

// CHECK-LABEL: func.func @collapse(
// CHECK-SAME: %[[X:[^:]+]]:
// CHECK-NEXT: return %[[X]]
func.func @collapse(%x: !wave.simd<i32, 32>) -> !wave.simd<i32, 32> {
  %a = wave.materialization_variants %x, %x : !wave.simd<i32, 32>
  %b = wave.materialization_variants %a, %x, %a : !wave.simd<i32, 32>
  return %b : !wave.simd<i32, 32>
}

// CHECK-LABEL: func.func @computation_boundary(
// CHECK: %[[MUL:.*]] = arith.muli
// CHECK: %[[ADD:.*]] = arith.addi
// CHECK: %[[INNER:.*]] = wave.materialization_variants %[[MUL]], %[[ADD]] : i32
// CHECK: %[[COMPUTED:.*]] = arith.addi %[[INNER]],
// CHECK: %[[OTHER:.*]] = arith.addi %[[MUL]],
// CHECK: %[[OUTER:.*]] = wave.materialization_variants %[[COMPUTED]], %[[OTHER]] : i32
// CHECK-NEXT: return %[[OUTER]]
func.func @computation_boundary(%x: i32) -> i32 {
  %one = arith.constant 1 : i32
  %two = arith.constant 2 : i32
  %mul = arith.muli %x, %two : i32
  %add = arith.addi %x, %x : i32
  %inner = wave.materialization_variants %mul, %add : i32
  %computed = arith.addi %inner, %one : i32
  %other = arith.addi %mul, %one : i32
  %outer = wave.materialization_variants %computed, %other : i32
  return %outer : i32
}

// CHECK-LABEL: func.func @shared_dag(
// CHECK: %[[MUL:.*]] = arith.muli
// CHECK: %[[ADD:.*]] = arith.addi
// CHECK-NEXT: %[[CHOICE:.*]] = wave.materialization_variants %[[MUL]], %[[ADD]] : i32
// CHECK-NEXT: return %[[CHOICE]]
func.func @shared_dag(%x: i32) -> i32 {
  %two = arith.constant 2 : i32
  %mul = arith.muli %x, %two : i32
  %add = arith.addi %x, %x : i32
  %v0 = wave.materialization_variants %mul, %add : i32
  %v1 = wave.materialization_variants %v0, %v0 : i32
  %v2 = wave.materialization_variants %v1, %v1 : i32
  %v3 = wave.materialization_variants %v2, %v2 : i32
  %v4 = wave.materialization_variants %v3, %v3 : i32
  %v5 = wave.materialization_variants %v4, %v4 : i32
  %v6 = wave.materialization_variants %v5, %v5 : i32
  %v7 = wave.materialization_variants %v6, %v6 : i32
  %v8 = wave.materialization_variants %v7, %v7 : i32
  %v9 = wave.materialization_variants %v8, %v8 : i32
  %v10 = wave.materialization_variants %v9, %v9 : i32
  %v11 = wave.materialization_variants %v10, %v10 : i32
  %v12 = wave.materialization_variants %v11, %v11 : i32
  %v13 = wave.materialization_variants %v12, %v12 : i32
  %v14 = wave.materialization_variants %v13, %v13 : i32
  %v15 = wave.materialization_variants %v14, %v14 : i32
  %v16 = wave.materialization_variants %v15, %v15 : i32
  %v17 = wave.materialization_variants %v16, %v16 : i32
  %v18 = wave.materialization_variants %v17, %v17 : i32
  %v19 = wave.materialization_variants %v18, %v18 : i32
  %v20 = wave.materialization_variants %v19, %v19 : i32
  %v21 = wave.materialization_variants %v20, %v20 : i32
  %v22 = wave.materialization_variants %v21, %v21 : i32
  %v23 = wave.materialization_variants %v22, %v22 : i32
  %v24 = wave.materialization_variants %v23, %v23 : i32
  %v25 = wave.materialization_variants %v24, %v24 : i32
  %v26 = wave.materialization_variants %v25, %v25 : i32
  %v27 = wave.materialization_variants %v26, %v26 : i32
  %v28 = wave.materialization_variants %v27, %v27 : i32
  %v29 = wave.materialization_variants %v28, %v28 : i32
  %v30 = wave.materialization_variants %v29, %v29 : i32
  %v31 = wave.materialization_variants %v30, %v30 : i32
  %v32 = wave.materialization_variants %v31, %v31 : i32
  return %v32 : i32
}
