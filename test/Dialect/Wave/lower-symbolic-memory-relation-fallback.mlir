// SPDX-FileCopyrightText: 2026 wave-mlir contributors
//
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
// RUN: wave-opt --wave-lower-symbolic-memory %s | FileCheck %s

// Cross-slot closure proves b >= 0; relation fallback retains adjacency.
// CHECK-LABEL: func.func @ordered_relation_fallback(
// CHECK-NOT: wave.scatter
// CHECK-COUNT-1: wave.store
// CHECK-SAME: !wave.simd<vector<2xf16>, 32>
// CHECK-NOT: wave.scatter
func.func @ordered_relation_fallback(
    %value: !wave.simd<vector<2xf16>, 32>,
    %base: !wave.ptr<#wave.shared, f16>, %b: !wave.simd<i32, 32>,
    %d: !wave.simd<i32, 32>, %l: !wave.simd<i32, 32>) {
  %i0 = wave.index_expr <"Max(0, b) + d + l">
      assuming [#wave.pred<"d == 8">]
      ["b", "d", "l"](%b, %d, %l)
      : (!wave.simd<i32, 32>, !wave.simd<i32, 32>,
         !wave.simd<i32, 32>) -> !wave.simd<index, 32>
  %i1 = wave.index_expr <"1 + b + d + l"> assuming
      [#wave.pred<"b + floor(Mod(l, 8)/d) >= 0">]
      ["b", "d", "l"](%b, %d, %l)
      : (!wave.simd<i32, 32>, !wave.simd<i32, 32>,
         !wave.simd<i32, 32>) -> !wave.simd<index, 32>
  %token = wave.scatter %value to %base mapping
      <bit_offset = <"16 * idx">>
      bindings []() packet_bindings ["idx", "idx"](%i0, %i1)
      : (!wave.simd<vector<2xf16>, 32>, !wave.ptr<#wave.shared, f16>,
         !wave.simd<index, 32>, !wave.simd<index, 32>) -> !wave.mem.token
  return
}

// -----

// Cross-slot closure must survive nonconsecutive logical packet order.
// CHECK-LABEL: func.func @permuted_relation_fallback(
// CHECK-NOT: wave.scatter
// CHECK: wave.store
// CHECK-SAME: !wave.simd<vector<2xf16>, 32>
// CHECK: wave.store
// CHECK-SAME: !wave.simd<f16, 32>
// CHECK-NOT: wave.store
// CHECK-NOT: wave.scatter
func.func @permuted_relation_fallback(
    %value: !wave.simd<vector<3xf16>, 32>,
    %base: !wave.ptr<#wave.shared, f16>, %b: !wave.simd<i32, 32>,
    %d: !wave.simd<i32, 32>, %l: !wave.simd<i32, 32>) {
  %i0 = wave.index_expr <"Max(0, b) + d + l">
      assuming [#wave.pred<"d == 8">]
      ["b", "d", "l"](%b, %d, %l)
      : (!wave.simd<i32, 32>, !wave.simd<i32, 32>,
         !wave.simd<i32, 32>) -> !wave.simd<index, 32>
  %far = wave.index_expr <"100 + b + d + l">
      ["b", "d", "l"](%b, %d, %l)
      : (!wave.simd<i32, 32>, !wave.simd<i32, 32>,
         !wave.simd<i32, 32>) -> !wave.simd<index, 32>
  %i2 = wave.index_expr <"1 + b + d + l"> assuming
      [#wave.pred<"b + floor(Mod(l, 8)/d) >= 0">]
      ["b", "d", "l"](%b, %d, %l)
      : (!wave.simd<i32, 32>, !wave.simd<i32, 32>,
         !wave.simd<i32, 32>) -> !wave.simd<index, 32>
  %token = wave.scatter %value to %base mapping
      <bit_offset = <"16 * idx">>
      bindings []() packet_bindings ["idx", "idx", "idx"](%i0, %far, %i2)
      : (!wave.simd<vector<3xf16>, 32>, !wave.ptr<#wave.shared, f16>,
         !wave.simd<index, 32>, !wave.simd<index, 32>,
         !wave.simd<index, 32>) -> !wave.mem.token
  return
}
