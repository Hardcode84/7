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

// CHECK-LABEL: func.func @signed_dynamic_i32_nonnegative_positive
// CHECK-SAME: ([[X:%.*]]: i32, [[D:%.*]]: i32)
// CHECK: [[NONNEG:%.*]] = wave.assume [[X]]
// CHECK: [[POS:%.*]] = wave.assume [[D]]
// CHECK-NOT: arith.cmpi slt
// CHECK: [[RCP:%.*]] = wave.urecip [[POS]]
// CHECK: wave.binary mulhui [[NONNEG]]
// CHECK-NOT: divsi
func.func @signed_dynamic_i32_nonnegative_positive(%x: i32, %d: i32)
    -> i32 {
  %nonneg = wave.assume %x as "x" [#wave.pred<"x >= 0">] : i32
  %pos = wave.assume %d as "d" [#wave.pred<"d >= 1">] : i32
  %q = wave.binary divsi %nonneg, %pos : i32, i32 -> i32
  return %q : i32
}

// -----

// CHECK-LABEL: func.func @signed_const_pow2_i32_nonnegative
// CHECK-SAME: ([[X:%.*]]: i32)
// CHECK: [[NONNEG:%.*]] = wave.assume [[X]]
// CHECK-NOT: arith.cmpi slt
// CHECK: wave.binary shrui [[NONNEG]]
// CHECK-NOT: wave.binary shrsi
// CHECK-NOT: divsi
func.func @signed_const_pow2_i32_nonnegative(%x: i32) -> i32 {
  %nonneg = wave.assume %x as "x" [#wave.pred<"x >= 0">] : i32
  %c32 = arith.constant 32 : i32
  %q = wave.binary divsi %nonneg, %c32 : i32, i32 -> i32
  return %q : i32
}

// -----

// CHECK-LABEL: func.func @signed_const_pow2_i32
// CHECK-SAME: ([[X:%.*]]: i32)
// CHECK: arith.cmpi slt, [[X]]
// CHECK: wave.select
// CHECK: wave.binary addi [[X]]
// CHECK: wave.binary shrsi
// CHECK-NOT: wave.binary shrui
// CHECK-NOT: divsi
func.func @signed_const_pow2_i32(%x: i32) -> i32 {
  %c32 = arith.constant 32 : i32
  %q = wave.binary divsi %x, %c32 : i32, i32 -> i32
  return %q : i32
}

// -----

// CHECK-LABEL: func.func @signed_const_one_simd_result_preserves_type
// CHECK-SAME: ([[X:%.*]]: i32)
// CHECK: [[SPLAT:%.*]] = wave.splat [[X]] : i32 -> !wave.simd<i32, 32>
// CHECK: return [[SPLAT]] : !wave.simd<i32, 32>
// CHECK-NOT: divsi
func.func @signed_const_one_simd_result_preserves_type(%x: i32)
    -> !wave.simd<i32, 32> {
  %one = arith.constant 1 : i32
  %ones = wave.splat %one : i32 -> !wave.simd<i32, 32>
  %q = wave.binary divsi %x, %ones
      : i32, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  return %q : !wave.simd<i32, 32>
}

// -----

// CHECK-LABEL: func.func @signed_const_pow2_i32_rem
// CHECK-SAME: ([[X:%.*]]: i32)
// CHECK: arith.cmpi slt, [[X]]
// CHECK: wave.binary shrsi
// CHECK: wave.binary shli
// CHECK: wave.binary subi [[X]]
// CHECK-NOT: remsi
func.func @signed_const_pow2_i32_rem(%x: i32) -> i32 {
  %c32 = arith.constant 32 : i32
  %r = wave.binary remsi %x, %c32 : i32, i32 -> i32
  return %r : i32
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

// CHECK-LABEL: func.func @signed_dynamic_pow2_scalar_lhs_simd_rhs
// CHECK-SAME: ([[X:%.*]]: i32, [[D:%.*]]: i32)
// CHECK: [[NONNEG:%.*]] = wave.assume [[X]]
// CHECK: [[POW2:%.*]] = wave.assume [[D]]
// CHECK: [[LHS:%.*]] = wave.splat [[NONNEG]] : i32 -> !wave.simd<i32, 32>
// CHECK: [[SHIFT:%.*]] = wave.ctz [[POW2]] : i32 -> i32
// CHECK: wave.binary shrui [[LHS]], [[SHIFT]]
// CHECK-NOT: divsi
func.func @signed_dynamic_pow2_scalar_lhs_simd_rhs(%x: i32, %d: i32)
    -> !wave.simd<i32, 32> {
  %nonneg = wave.assume %x as "x" [#wave.pred<"x >= 0">] : i32
  %pow2 = wave.assume %d as "d" [#wave.pred<"d & (d - 1) == 0">,
                                  #wave.pred<"d > 0">] : i32
  %splat = wave.splat %pow2 : i32 -> !wave.simd<i32, 32>
  %q = wave.binary divsi %nonneg, %splat
      : i32, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  return %q : !wave.simd<i32, 32>
}

// -----

// CHECK-LABEL: func.func @unsigned_dynamic_pow2_rem_simd
// CHECK-DAG: [[ONE:%.*]] = wave.constant 1 : i32 -> !wave.simd<i32, 32>
// CHECK: [[POW2:%.*]] = wave.assume
// CHECK: [[POW2_SPLAT:%.*]] = wave.splat [[POW2]]
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

// -----

// CHECK-LABEL: func.func @bounded_dynamic_index_uses_i32
// CHECK-SAME: ([[X:%.*]]: index, [[D:%.*]]: index)
// CHECK: [[BX:%.*]] = wave.assume [[X]]
// CHECK: [[BD:%.*]] = wave.assume [[D]]
// CHECK: [[X32:%.*]] = wave.cast intconvert [[BX]] : index -> i32
// CHECK: [[D32:%.*]] = wave.cast intconvert [[BD]] : index -> i32
// CHECK: [[RCP:%.*]] = wave.urecip [[D32]]
// CHECK: wave.binary mulhui [[RCP]]
// CHECK: wave.binary mulhui [[X32]]
// CHECK: wave.cast intconvert {{.*}} policy {extension = #wave.cast_extension<zero>} : i32 -> index
// CHECK-NOT: divui
// CHECK-NOT: remui
func.func @bounded_dynamic_index_uses_i32(%x: index, %d: index)
    -> (index, index) {
  %bx = wave.assume %x as "x" [#wave.pred<"x >= 0">,
                                #wave.pred<"x <= 1024">] : index
  %bd = wave.assume %d as "d" [#wave.pred<"d >= 1">,
                                #wave.pred<"d <= 1024">] : index
  %q = wave.binary divui %bx, %bd : index, index -> index
  %r = wave.binary remui %bx, %bd : index, index -> index
  return %q, %r : index, index
}

// -----

// CHECK-LABEL: func.func @bounded_dynamic_signed_index_uses_i32
// CHECK-SAME: ([[X:%.*]]: index, [[D:%.*]]: index)
// CHECK: [[BX:%.*]] = wave.assume [[X]]
// CHECK: [[BD:%.*]] = wave.assume [[D]]
// CHECK: [[X32:%.*]] = wave.cast intconvert [[BX]] : index -> i32
// CHECK: [[D32:%.*]] = wave.cast intconvert [[BD]] : index -> i32
// CHECK: wave.urecip {{.*}} : i32 -> i32
// CHECK: wave.binary mulhui {{.*}} : i32, i32 -> i32
// CHECK: wave.cast intconvert {{.*}} policy {extension = #wave.cast_extension<zero>} : i32 -> index
// CHECK-NOT: divsi
// CHECK-NOT: remsi
func.func @bounded_dynamic_signed_index_uses_i32(%x: index, %d: index)
    -> (index, index) {
  %bx = wave.assume %x as "x" [#wave.pred<"x >= 0">,
                                #wave.pred<"x <= 1024">] : index
  %bd = wave.assume %d as "d" [#wave.pred<"d >= 1">,
                                #wave.pred<"d <= 1024">] : index
  %q = wave.binary divsi %bx, %bd : index, index -> index
  %r = wave.binary remsi %bx, %bd : index, index -> index
  return %q, %r : index, index
}

// -----

// CHECK-LABEL: func.func @bounded_dynamic_simd_i64_rem_uses_i32
// CHECK-SAME: ([[X:%.*]]: !wave.simd<i64, 32>, [[D:%.*]]: !wave.simd<i64, 32>)
// CHECK: [[BX:%.*]] = wave.assume [[X]]
// CHECK: [[BD:%.*]] = wave.assume [[D]]
// CHECK: [[X32:%.*]] = wave.cast intconvert [[BX]] : !wave.simd<i64, 32> -> !wave.simd<i32, 32>
// CHECK: [[D32:%.*]] = wave.cast intconvert [[BD]] : !wave.simd<i64, 32> -> !wave.simd<i32, 32>
// CHECK: [[RCP:%.*]] = wave.urecip [[D32]]
// CHECK: wave.binary mulhui [[RCP]]
// CHECK: wave.binary mulhui [[X32]]
// CHECK: wave.cast intconvert {{.*}} policy {extension = #wave.cast_extension<zero>} : !wave.simd<i32, 32> -> !wave.simd<i64, 32>
// CHECK-NOT: remui
func.func @bounded_dynamic_simd_i64_rem_uses_i32(
    %x: !wave.simd<i64, 32>, %d: !wave.simd<i64, 32>)
    -> !wave.simd<i64, 32> {
  %bx = wave.assume %x as "x" [#wave.pred<"x >= 0">,
                                #wave.pred<"x <= 1024">]
      : !wave.simd<i64, 32>
  %bd = wave.assume %d as "d" [#wave.pred<"d >= 1">,
                                #wave.pred<"d <= 1024">]
      : !wave.simd<i64, 32>
  %r = wave.binary remui %bx, %bd
      : !wave.simd<i64, 32>, !wave.simd<i64, 32> -> !wave.simd<i64, 32>
  return %r : !wave.simd<i64, 32>
}

// -----

// CHECK-LABEL: func.func @bounded_dynamic_simd_index_rem_uses_i32
// CHECK-SAME: ([[X:%.*]]: !wave.simd<index, 32>, [[D:%.*]]: !wave.simd<index, 32>)
// CHECK: [[BX:%.*]] = wave.assume [[X]]
// CHECK: [[BD:%.*]] = wave.assume [[D]]
// CHECK: [[X32:%.*]] = wave.cast intconvert [[BX]] : !wave.simd<index, 32> -> !wave.simd<i32, 32>
// CHECK: [[D32:%.*]] = wave.cast intconvert [[BD]] : !wave.simd<index, 32> -> !wave.simd<i32, 32>
// CHECK: wave.urecip [[D32]]
// CHECK: wave.cast intconvert {{.*}} policy {extension = #wave.cast_extension<zero>} : !wave.simd<i32, 32> -> !wave.simd<index, 32>
// CHECK-NOT: remui
func.func @bounded_dynamic_simd_index_rem_uses_i32(
    %x: !wave.simd<index, 32>, %d: !wave.simd<index, 32>)
    -> !wave.simd<index, 32> {
  %bx = wave.assume %x as "x" [#wave.pred<"x >= 0">,
                                #wave.pred<"x <= 1024">]
      : !wave.simd<index, 32>
  %bd = wave.assume %d as "d" [#wave.pred<"d >= 1">,
                                #wave.pred<"d <= 1024">]
      : !wave.simd<index, 32>
  %r = wave.binary remui %bx, %bd
      : !wave.simd<index, 32>, !wave.simd<index, 32>
      -> !wave.simd<index, 32>
  return %r : !wave.simd<index, 32>
}
