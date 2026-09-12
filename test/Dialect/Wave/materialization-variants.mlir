// RUN: wave-opt %s | wave-opt | FileCheck %s --check-prefix=ROUNDTRIP
// RUN: wave-opt %s --canonicalize --cse | FileCheck %s --check-prefix=CLEAN

// ROUNDTRIP-LABEL: func.func @scalar(
// ROUNDTRIP: wave.materialization_variants %{{.*}}, %{{.*}}, %{{.*}} : i32
// CLEAN-LABEL: func.func @scalar(
// CLEAN: wave.materialization_variants
func.func @scalar(%x: i32) -> i32 {
  %two = arith.constant 2 : i32
  %one = arith.constant 1 : i32
  %mul = arith.muli %x, %two : i32
  %add = arith.addi %x, %x : i32
  %shift = arith.shli %x, %one : i32
  %r = wave.materialization_variants %mul, %add, %shift : i32
  return %r : i32
}

// ROUNDTRIP-LABEL: func.func @simd(
// ROUNDTRIP: wave.materialization_variants
// CLEAN-LABEL: func.func @simd(
// CLEAN-SAME: %[[X:[^:]+]]:
// CLEAN-NOT: wave.materialization_variants
// CLEAN: return %[[X]]
func.func @simd(%x: !wave.simd<i32, 32>) -> !wave.simd<i32, 32> {
  %r = "wave.materialization_variants"(%x, %x)
      : (!wave.simd<i32, 32>, !wave.simd<i32, 32>) -> !wave.simd<i32, 32>
  return %r : !wave.simd<i32, 32>
}

// ROUNDTRIP-LABEL: func.func @pointer(
// ROUNDTRIP: wave.materialization_variants
// CLEAN-LABEL: func.func @pointer(
// CLEAN-SAME: %[[X:[^:]+]]:
// CLEAN-NOT: wave.materialization_variants
// CLEAN: return %[[X]]
func.func @pointer(%x: !wave.ptr<#wave.global, f32>) -> !wave.ptr<#wave.global, f32> {
  %r = "wave.materialization_variants"(%x, %x)
      : (!wave.ptr<#wave.global, f32>, !wave.ptr<#wave.global, f32>)
        -> !wave.ptr<#wave.global, f32>
  return %r : !wave.ptr<#wave.global, f32>
}

// ROUNDTRIP-LABEL: func.func @single(
// ROUNDTRIP: wave.materialization_variants
// CLEAN-LABEL: func.func @single(
// CLEAN-SAME: %[[X:[^:]+]]:
// CLEAN-NOT: wave.materialization_variants
// CLEAN: return %[[X]]
func.func @single(%x: i32) -> i32 {
  %r = wave.materialization_variants %x : i32
  return %r : i32
}

// ROUNDTRIP-LABEL: func.func @dead(
// ROUNDTRIP: wave.materialization_variants
// CLEAN-LABEL: func.func @dead(
// CLEAN-NOT: wave.materialization_variants
// CLEAN: return
func.func @dead(%x: i32) {
  %r = wave.materialization_variants %x, %x : i32
  return
}

// ROUNDTRIP-LABEL: func.func @independent(
// ROUNDTRIP: wave.materialization_variants
// ROUNDTRIP: wave.materialization_variants
// CLEAN-LABEL: func.func @independent(
// CLEAN: %[[FIRST:.*]] = wave.materialization_variants
// CLEAN: %[[SECOND:.*]] = wave.materialization_variants
// CLEAN: return %[[FIRST]], %[[SECOND]]
func.func @independent(%x: i32) -> (i32, i32) {
  %two = arith.constant 2 : i32
  %mul = arith.muli %x, %two : i32
  %add = arith.addi %x, %x : i32
  %first = wave.materialization_variants %mul, %add : i32
  %second = wave.materialization_variants %add, %mul : i32
  return %first, %second : i32, i32
}
