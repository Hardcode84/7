// RUN: wave-opt --split-input-file --wave-expand-integer-div-rem --canonicalize --cse %s \
// RUN:   | FileCheck %s --implicit-check-not="arith.cmpi slt" \
// RUN:       --implicit-check-not="wave.cmpi slt"

// CHECK-LABEL: func.func @positive_divisor_scalar
// CHECK: [[SIGN:%.*]] = wave.binary shrsi
// CHECK: wave.binary xori {{.*}}, [[SIGN]]
// CHECK: wave.binary subi {{.*}}, [[SIGN]]
// CHECK: wave.urecip
// CHECK: return {{%.*}}, {{%.*}} : i32, i32
func.func @positive_divisor_scalar(%x: i32, %d: i32) -> (i32, i32) {
  %pos = wave.assume %d as "d" [#wave.pred<"d >= 1">] : i32
  %q = wave.binary divsi %x, %pos : i32, i32 -> i32
  %r = wave.binary remsi %x, %pos : i32, i32 -> i32
  return %q, %r : i32, i32
}

// -----

// CHECK-LABEL: func.func @positive_divisor_simd
// CHECK: [[SIGN:%.*]] = wave.binary shrsi
// CHECK: wave.binary xori {{.*}}, [[SIGN]]
// CHECK: wave.binary subi {{.*}}, [[SIGN]]
// CHECK: wave.urecip
// CHECK: return {{%.*}}, {{%.*}} : !wave.simd<i32, 32>, !wave.simd<i32, 32>
func.func @positive_divisor_simd(%x: !wave.simd<i32, 32>, %d: i32)
      -> (!wave.simd<i32, 32>, !wave.simd<i32, 32>) {
  %pos = wave.assume %d as "d" [#wave.pred<"d >= 1">] : i32
  %vp = wave.splat %pos : i32 -> !wave.simd<i32, 32>
  %q = wave.binary divsi %x, %vp
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %r = wave.binary remsi %x, %vp
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  return %q, %r : !wave.simd<i32, 32>, !wave.simd<i32, 32>
}

// -----

// CHECK-LABEL: func.func @positive_divisor_narrow_i64
// CHECK: [[SIGN:%.*]] = wave.binary shrsi
// CHECK: wave.binary xori {{.*}}, [[SIGN]]
// CHECK: wave.binary subi {{.*}}, [[SIGN]]
// CHECK: wave.urecip
// CHECK: return {{%.*}}, {{%.*}} : i32, i32
func.func @positive_divisor_narrow_i64(%x: i64, %d: i64) -> (i32, i32) {
  %bx = wave.assume %x as "x"
      [#wave.pred<"x >= -2147483648">, #wave.pred<"x <= 2147483647">] : i64
  %pos = wave.assume %d as "d"
      [#wave.pred<"d >= 1">, #wave.pred<"d <= 2147483647">] : i64
  %q = wave.binary divsi %bx, %pos : i64, i64 -> i64
  %r = wave.binary remsi %bx, %pos : i64, i64 -> i64
  %qn = wave.cast intconvert %q : i64 -> i32
  %rn = wave.cast intconvert %r : i64 -> i32
  return %qn, %rn : i32, i32
}

// -----

// CHECK-LABEL: func.func @positive_divisor_narrow_index
// CHECK: [[SIGN:%.*]] = wave.binary shrsi
// CHECK: wave.binary xori {{.*}}, [[SIGN]]
// CHECK: wave.binary subi {{.*}}, [[SIGN]]
// CHECK: wave.urecip
// CHECK: return {{%.*}}, {{%.*}} : i32, i32
func.func @positive_divisor_narrow_index(%x: index, %d: index) -> (i32, i32) {
  %bx = wave.assume %x as "x"
      [#wave.pred<"x >= -2147483648">, #wave.pred<"x <= 2147483647">] : index
  %pos = wave.assume %d as "d"
      [#wave.pred<"d >= 1">, #wave.pred<"d <= 2147483647">] : index
  %q = wave.binary divsi %bx, %pos : index, index -> index
  %r = wave.binary remsi %bx, %pos : index, index -> index
  %qn = wave.cast intconvert %q : index -> i32
  %rn = wave.cast intconvert %r : index -> i32
  return %qn, %rn : i32, i32
}

// -----

// CHECK-LABEL: func.func @positive_constant_divisor
// CHECK: [[SIGN:%.*]] = wave.binary shrsi
// CHECK: wave.binary xori {{.*}}, [[SIGN]]
// CHECK: wave.binary subi {{.*}}, [[SIGN]]
// CHECK: wave.binary mulhui
// CHECK: return {{%.*}}, {{%.*}} : i32, i32
func.func @positive_constant_divisor(%x: i32) -> (i32, i32) {
  %three = arith.constant 3 : i32
  %q = wave.binary divsi %x, %three : i32, i32 -> i32
  %r = wave.binary remsi %x, %three : i32, i32 -> i32
  return %q, %r : i32, i32
}
