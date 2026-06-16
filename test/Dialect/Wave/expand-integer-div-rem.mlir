// RUN: wave-opt --split-input-file --wave-expand-integer-div-rem --canonicalize --cse %s | FileCheck %s

// CHECK-LABEL: func.func @dynamic_unsigned_i32
// CHECK-SAME: ([[X:%.*]]: i32, [[D:%.*]]: i32)
// CHECK: [[RCP:%.*]] = wave.urecip [[D]]
// CHECK: wave.binary mulhui [[RCP]]
// CHECK: wave.binary mulhui [[X]]
// CHECK: [[TAKE:%.*]] = arith.cmpi uge
// CHECK: wave.select [[TAKE]]
// CHECK-NOT: divui
// CHECK-NOT: remui
func.func @dynamic_unsigned_i32(%x: i32, %d: i32) -> (i32, i32) {
  %q = wave.binary divui %x, %d : i32, i32 -> i32
  %r = wave.binary remui %x, %d : i32, i32 -> i32
  return %q, %r : i32, i32
}

// -----

// CHECK-LABEL: func.func @const_magic_i32
// CHECK-SAME: ([[X:%.*]]: i32)
// CHECK-NOT: arith.cmpi uge
// CHECK: wave.binary muli
// CHECK: wave.binary shrui
// CHECK-NOT: divui
// CHECK-NOT: remui
func.func @const_magic_i32(%x: i32) -> (i32, i32) {
  %ten = arith.constant 10 : i32
  %q = wave.binary divui %x, %ten : i32, i32 -> i32
  %r = wave.binary remui %x, %ten : i32, i32 -> i32
  return %q, %r : i32, i32
}

// -----

// CHECK-LABEL: func.func @signed_simd_i32
// CHECK: wave.cmpi slt
// CHECK: wave.urecip
// CHECK: wave.binary mulhui
// CHECK: wave.cmpi uge
// CHECK: wave.binary xori
// CHECK: wave.select
// CHECK-NOT: divsi
func.func @signed_simd_i32(%x: !wave.simd<i32, 32>, %d: i32)
    -> !wave.simd<i32, 32> {
  %q = wave.binary divsi %x, %d
      : !wave.simd<i32, 32>, i32 -> !wave.simd<i32, 32>
  return %q : !wave.simd<i32, 32>
}

// -----

// CHECK-LABEL: func.func @signed_dynamic_pow2_i64
// CHECK-SAME: ([[X:%.*]]: i64, [[D:%.*]]: i64)
// CHECK: [[NONNEG:%.*]] = wave.assume [[X]]
// CHECK: [[POW2:%.*]] = wave.assume [[D]]
// CHECK: [[SHIFT:%.*]] = wave.ctz [[POW2]]
// CHECK: wave.binary shrui [[NONNEG]], [[SHIFT]]
// CHECK-NOT: wave.urecip
// CHECK-NOT: divsi
func.func @signed_dynamic_pow2_i64(%x: i64, %d: i64) -> i64 {
  %nonneg = wave.assume %x as "x" [#wave.pred<"x >= 0">] : i64
  %pow2 = wave.assume %d as "d" [#wave.pred<"d & (d - 1) == 0">,
                                  #wave.pred<"d > 0">] : i64
  %q = wave.binary divsi %nonneg, %pow2 : i64, i64 -> i64
  return %q : i64
}

// -----

// CHECK-LABEL: func.func @unsigned_dynamic_pow2_rem_simd
// CHECK-DAG: [[ONE_SCALAR:%.*]] = arith.constant 1
// CHECK: [[POW2:%.*]] = wave.assume
// CHECK: [[POW2_SPLAT:%.*]] = wave.splat [[POW2]]
// CHECK: [[ONE:%.*]] = wave.splat [[ONE_SCALAR]]
// CHECK: [[MASK:%.*]] = wave.binary subi [[POW2_SPLAT]], [[ONE]]
// CHECK: wave.binary andi {{.*}}, [[MASK]]
// CHECK-NOT: remui
func.func @unsigned_dynamic_pow2_rem_simd(%x: !wave.simd<i32, 32>, %d: i32)
    -> !wave.simd<i32, 32> {
  %pow2 = wave.assume %d as "d" [#wave.pred<"d & (d - 1) == 0">,
                                  #wave.pred<"d > 0">] : i32
  %splat = wave.splat %pow2 : i32 -> !wave.simd<i32, 32>
  %r = wave.binary remui %x, %splat
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  return %r : !wave.simd<i32, 32>
}

// -----

// CHECK-LABEL: func.func @dynamic_index
// CHECK-SAME: ([[X:%.*]]: index, [[D:%.*]]: index)
// CHECK: wave.binary shrui [[X]]
// CHECK: arith.cmpi uge
// CHECK: wave.select
// CHECK-NOT: divui
func.func @dynamic_index(%x: index, %d: index) -> index {
  %q = wave.binary divui %x, %d : index, index -> index
  return %q : index
}
