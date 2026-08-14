// SPDX-FileCopyrightText: 2026 wave-mlir contributors
//
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
// RUN: wave-opt --wave-lower-symbolic-memory --split-input-file %s | FileCheck %s

// The direct slot expression is the complete packet relation. The transaction
// proof checks that relation over the whole slot domain before vectorizing.
// CHECK-LABEL: func.func @direct_relation_adjacency(
// CHECK-SAME: %[[VALUE:[^,]+]]: !wave.simd<vector<4xf16>, 32>, %[[BASE:[^,]+]]: !wave.ptr<#wave.shared, f16>
// CHECK: %[[BYTE:.*]] = wave.ptr_cast %[[BASE]]
// CHECK-SAME: !wave.ptr<#wave.shared, f16> -> !wave.ptr<#wave.shared, i8>
// CHECK-COUNT-1: wave.store
// CHECK-SAME: !wave.simd<vector<4xf16>, 32>
// CHECK-NOT: wave.scatter
func.func @direct_relation_adjacency(
    %value: !wave.simd<vector<4xf16>, 32>,
    %base: !wave.ptr<#wave.shared, f16>, %origin: index) {
  %token = wave.scatter %value to %base mapping
      <bit_offset = <"16 * (origin + slot)">>
      bindings ["origin"](%origin)
      : (!wave.simd<vector<4xf16>, 32>, !wave.ptr<#wave.shared, f16>, index)
      -> !wave.mem.token
  return
}

// -----

// A non-contiguous relation is still lowered through the identical direct
// layout model at width one; it is not reconstructed from sampled points.
// CHECK-LABEL: func.func @direct_relation_width_one(
// CHECK-COUNT-2: wave.load
// CHECK-SAME: -> (!wave.simd<f32, 32>, !wave.mem.token)
// CHECK: wave.pack
// CHECK-NOT: wave.gather
func.func @direct_relation_width_one(
    %base: !wave.ptr<#wave.global, f32>, %origin: index)
    -> !wave.simd<vector<2xf32>, 32> {
  %value, %token = wave.gather %base mapping
      <bit_offset = <"32 * (origin + 2 * slot)">>
      bindings ["origin"](%origin)
      : (!wave.ptr<#wave.global, f32>, index)
      -> (!wave.simd<vector<2xf32>, 32>, !wave.mem.token)
  return %value : !wave.simd<vector<2xf32>, 32>
}

// -----

// Raw access bindings are analyzed here, not by GenerateIndexExprs. Preserve
// the zero-extension semantics when the imported relation becomes a byte
// pointer offset.
// CHECK-LABEL: func.func @raw_zero_extended_gather_binding(
// CHECK: %[[OFFSET:.*]] = wave.index_expr <"4*Mod(raw0, 4294967296)">
// CHECK: %[[POINTER:.*]] = wave.ptr_add {{.*}}, %[[OFFSET]]
// CHECK: wave.load %[[POINTER]]
// CHECK-NOT: wave.gather
func.func @raw_zero_extended_gather_binding(
    %base: !wave.ptr<#wave.global, i32>, %raw: !wave.simd<i32, 32>)
    -> !wave.simd<vector<1xi32>, 32> {
  %wide = wave.cast intconvert %raw
      policy {extension = #wave.cast_extension<zero>}
      : !wave.simd<i32, 32> -> !wave.simd<index, 32>
  %value, %token = wave.gather %base mapping
      <bit_offset = <"32*(offset + slot)">> bindings ["offset"](%wide)
      : (!wave.ptr<#wave.global, i32>, !wave.simd<index, 32>)
      -> (!wave.simd<vector<1xi32>, 32>, !wave.mem.token)
  return %value : !wave.simd<vector<1xi32>, 32>
}

// -----

// CHECK-LABEL: func.func @raw_zero_extended_scatter_binding(
// CHECK: %[[OFFSET:.*]] = wave.index_expr <"4*Mod(raw0, 4294967296)">
// CHECK: %[[POINTER:.*]] = wave.ptr_add {{.*}}, %[[OFFSET]]
// CHECK: wave.store {{.*}} -> %[[POINTER]]
// CHECK-NOT: wave.scatter
func.func @raw_zero_extended_scatter_binding(
    %value: !wave.simd<vector<1xi32>, 32>,
    %base: !wave.ptr<#wave.global, i32>, %raw: !wave.simd<i32, 32>) {
  %wide = wave.cast intconvert %raw
      policy {extension = #wave.cast_extension<zero>}
      : !wave.simd<i32, 32> -> !wave.simd<index, 32>
  %token = wave.scatter %value to %base mapping
      <bit_offset = <"32*(offset + slot)">> bindings ["offset"](%wide)
      : (!wave.simd<vector<1xi32>, 32>, !wave.ptr<#wave.global, i32>,
         !wave.simd<index, 32>) -> !wave.mem.token
  return
}

// -----

// A common dynamic divisor is distributed across a normalized floor. Rebuild
// the numerator at the symbolic-memory boundary and lower the remainder with
// integer arithmetic; a zero divisor is poison and needs no definedness fact.
// CHECK-LABEL: func.func @normalized_dynamic_remainder(
// CHECK: wave.binary remsi
// CHECK-NOT: wave.gather
func.func @normalized_dynamic_remainder(
    %base: !wave.ptr<#waveamd.buffer, i32>, %divisor: i32)
    -> !wave.simd<vector<2xi32>, 32>
    attributes {wave.workgroup_size = array<i32: 32, 1, 1>} {
  %item = wave.workitem_id 0 : !wave.simd<i32, 32>
  %bounded_item = wave.assume %item as "x"
      [#wave.pred<"x >= 0">, #wave.pred<"x <= 31">]
      : !wave.simd<i32, 32>
  %bounded_divisor = wave.assume %divisor as "d"
      [#wave.pred<"d >= 0">, #wave.pred<"d <= 256">] : i32
  %value, %token = wave.gather %base mapping
      <bit_offset = <"32*(item + slot - d*floor(1/d*item + 1/d*slot))">>
      bindings ["item", "d"](%bounded_item, %bounded_divisor)
      : (!wave.ptr<#waveamd.buffer, i32>, !wave.simd<i32, 32>, i32)
      -> (!wave.simd<vector<2xi32>, 32>, !wave.mem.token)
  return %value : !wave.simd<vector<2xi32>, 32>
}

// -----

// Keep the dynamic quotient wide, then truncate only the explicitly wrapped
// result. The buffer pointer conversion zero-extends those exact low 32 bits.
// CHECK-LABEL: func.func @wrapped_dynamic_remainder_is_i32
// CHECK: wave.binary remsi
// CHECK: %[[LOW:.*]] = wave.cast intconvert {{.*}} : !wave.simd<index, 32> -> !wave.simd<i32, 32>
// CHECK: %[[OFFSET:.*]] = wave.cast intconvert %[[LOW]] policy {extension = #wave.cast_extension<zero>} : !wave.simd<i32, 32> -> !wave.simd<index, 32>
// CHECK: %[[POINTER:.*]] = wave.ptr_add {{.*}}, %[[OFFSET]]
// CHECK: wave.load %[[POINTER]]
// CHECK-NOT: wave.gather
func.func @wrapped_dynamic_remainder_is_i32(
    %base: !wave.ptr<#waveamd.buffer, f16>, %origin: i32, %divisor: i32)
    -> !wave.simd<vector<1xf16>, 32>
    attributes {wave.workgroup_size = array<i32: 32, 1, 1>} {
  %item = wave.workitem_id 0 : !wave.simd<i32, 32>
  %bounded_item = wave.assume %item as "item"
      [#wave.pred<"item >= 0">, #wave.pred<"item <= 31">]
      : !wave.simd<i32, 32>
  %value, %token = wave.gather %base mapping
      <bit_offset = <"8*Mod(2*(origin - divisor*Trunc(1/divisor*(origin + item)) + item + slot), 4294967296)">>
      bindings ["item", "origin", "divisor"]
      (%bounded_item, %origin, %divisor)
      : (!wave.ptr<#waveamd.buffer, f16>, !wave.simd<i32, 32>, i32, i32)
      -> (!wave.simd<vector<1xf16>, 32>, !wave.mem.token)
  return %value : !wave.simd<vector<1xf16>, 32>
}

// -----

// Project an additive loop-uniform term to a scalar buffer-pointer add before
// lowering the lane-varying remainder. The remainder stays grouped so it is
// still emitted as one signed remainder rather than quotient arithmetic.
// CHECK-LABEL: func.func @wrapped_dynamic_remainder_projects_uniform_field
// CHECK: %[[UNIFORM_EXPR:.*]] = wave.index_expr {{.*}}(%arg3) : (i32) -> index
// CHECK: %[[UNIFORM_I32:.*]] = wave.cast intconvert %[[UNIFORM_EXPR]] : index -> i32
// CHECK: %[[UNIFORM:.*]] = wave.cast intconvert %[[UNIFORM_I32]] policy {extension = #wave.cast_extension<zero>} : i32 -> index
// CHECK: %[[SCALAR_BASE:.*]] = wave.ptr_add {{.*}}, %[[UNIFORM]] : !wave.ptr<#waveamd.buffer, i8>, index -> !wave.ptr<#waveamd.buffer, i8>
// CHECK: wave.binary remsi
// CHECK: %[[POINTER:.*]] = wave.ptr_add %[[SCALAR_BASE]], {{.*}} : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 32> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 32>
// CHECK: wave.load %[[POINTER]]
// CHECK-NOT: wave.gather
func.func @wrapped_dynamic_remainder_projects_uniform_field(
    %base: !wave.ptr<#waveamd.buffer, f16>, %origin: i32, %divisor: i32,
    %loop_offset: i32) -> !wave.simd<vector<1xf16>, 32>
    attributes {wave.workgroup_size = array<i32: 32, 1, 1>} {
  %item = wave.workitem_id 0 : !wave.simd<i32, 32>
  %bounded_item = wave.assume %item as "item"
      [#wave.pred<"item >= 0">, #wave.pred<"item <= 31">]
      : !wave.simd<i32, 32>
  %value, %token = wave.gather %base mapping
      <bit_offset = <"8*Mod(2*(loop_offset + origin - divisor*Trunc(1/divisor*(origin + item)) + item + slot), 4294967296)">>
      bindings ["item", "origin", "divisor", "loop_offset"]
      (%bounded_item, %origin, %divisor, %loop_offset)
      : (!wave.ptr<#waveamd.buffer, f16>, !wave.simd<i32, 32>, i32, i32, i32)
      -> (!wave.simd<vector<1xf16>, 32>, !wave.mem.token)
  return %value : !wave.simd<vector<1xf16>, 32>
}

// -----

// Explicit signed-i32 boundaries make the narrow quotient an exact
// materialization, including wrapping of the numerator before division.
// CHECK-LABEL: func.func @signed_i32_wrapped_remainder_is_narrow(
// CHECK: wave.index_expr <"-2147483648 + Mod(2147483648 + item + origin, 4294967296)"> assuming
// CHECK: wave.binary remsi {{.*}} : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
// CHECK-NOT: wave.binary remsi {{.*}}!wave.simd<index, 32>
// CHECK-NOT: wave.gather
func.func @signed_i32_wrapped_remainder_is_narrow(
    %base: !wave.ptr<#waveamd.buffer, f16>, %origin: i32, %divisor: i32)
    -> !wave.simd<vector<1xf16>, 32>
    attributes {wave.workgroup_size = array<i32: 32, 1, 1>} {
  %item = wave.workitem_id 0 : !wave.simd<i32, 32>
  %bounded_item = wave.assume %item as "item"
      [#wave.pred<"item >= 0">, #wave.pred<"item <= 31">]
      : !wave.simd<i32, 32>
  %value, %token = wave.gather %base mapping
      <bit_offset = <"8*Mod(2*(-2147483648 + Mod(2147483648 + origin + item, 4294967296) - (-2147483648 + Mod(2147483648 + divisor, 4294967296))*Trunc((-2147483648 + Mod(2147483648 + origin + item, 4294967296))/(-2147483648 + Mod(2147483648 + divisor, 4294967296))) + slot), 4294967296)">>
      bindings ["item", "origin", "divisor"]
      (%bounded_item, %origin, %divisor)
      : (!wave.ptr<#waveamd.buffer, f16>, !wave.simd<i32, 32>, i32, i32)
      -> (!wave.simd<vector<1xf16>, 32>, !wave.mem.token)
  return %value : !wave.simd<vector<1xf16>, 32>
}
