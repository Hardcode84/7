// RUN: wave-opt --split-input-file --wave-strength-reduce-modulo \
// RUN:   --wave-expand-integer-div-rem --canonicalize --cse %s | FileCheck %s
// RUN: wave-opt --split-input-file --wave-normalize-integer-div-rem %s \
// RUN:   | FileCheck %s --check-prefix=NORMALIZE

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
// NORMALIZE-LABEL: func.func @signed_dynamic_i32_nonnegative_positive
// NORMALIZE: wave.binary divui
// NORMALIZE-NOT: wave.binary divsi
func.func @signed_dynamic_i32_nonnegative_positive(%x: i32, %d: i32)
    -> i32 {
  %nonneg = wave.assume %x as "x" [#wave.pred<"x >= 0">] : i32
  %pos = wave.assume %d as "d" [#wave.pred<"d >= 1">] : i32
  %q = wave.binary divsi %nonneg, %pos : i32, i32 -> i32
  return %q : i32
}

// -----

// CHECK-LABEL: func.func @signed_const_i32_rem3_nonnegative
// CHECK-SAME: ([[X:%.*]]: i32)
// CHECK: [[NONNEG:%.*]] = wave.assume [[X]]
// CHECK-NOT: arith.cmpi slt
// CHECK: wave.binary mulhui [[NONNEG]]
// CHECK-NOT: remsi
// NORMALIZE-LABEL: func.func @signed_const_i32_rem3_nonnegative
// NORMALIZE: wave.binary remui
// NORMALIZE-NOT: wave.binary remsi
func.func @signed_const_i32_rem3_nonnegative(%x: i32) -> i32 {
  %nonneg = wave.assume %x as "x" [#wave.pred<"x >= 0">] : i32
  %three = arith.constant 3 : i32
  %r = wave.binary remsi %nonneg, %three : i32, i32 -> i32
  return %r : i32
}

// -----

// CHECK-LABEL: func.func @signed_const_i32_divrem_unknown_sign
// CHECK-SAME: ([[X:%.*]]: i32)
// CHECK: [[NEG:%.*]] = arith.cmpi slt, [[X]]
// CHECK: [[ABS:%.*]] = wave.select [[NEG]]
// CHECK-NOT: wave.binary andi
// CHECK: [[HI:%.*]] = wave.binary mulhui [[ABS]]
// CHECK-NOT: wave.binary andi
// CHECK: return
// CHECK-NOT: divsi
// CHECK-NOT: remsi
// NORMALIZE-LABEL: func.func @signed_const_i32_divrem_unknown_sign
// NORMALIZE: wave.binary divsi
// NORMALIZE: wave.binary remsi
func.func @signed_const_i32_divrem_unknown_sign(%x: i32) -> (i32, i32) {
  %three = arith.constant 3 : i32
  %q = wave.binary divsi %x, %three : i32, i32 -> i32
  %r = wave.binary remsi %x, %three : i32, i32 -> i32
  return %q, %r : i32, i32
}

// -----

// CHECK-LABEL: func.func @signed_const_simd_i32_rem_negative_divisor
// CHECK-SAME: ([[X:%.*]]: !wave.simd<i32, 32>)
// CHECK: [[NEG:%.*]] = wave.cmpi slt [[X]]
// CHECK: [[ABS:%.*]] = wave.select [[NEG]]
// CHECK-NOT: wave.binary andi
// CHECK: [[HI:%.*]] = wave.binary mulhui [[ABS]]
// CHECK-NOT: wave.binary andi
// CHECK: return
// CHECK-NOT: remsi
// NORMALIZE-LABEL: func.func @signed_const_simd_i32_rem_negative_divisor
// NORMALIZE: wave.binary remsi
// NORMALIZE-NOT: wave.binary remui
// NORMALIZE: return
func.func @signed_const_simd_i32_rem_negative_divisor(
    %x: !wave.simd<i32, 32>) -> !wave.simd<i32, 32> {
  %minus_three = arith.constant -3 : i32
  %divisor = wave.splat %minus_three : i32 -> !wave.simd<i32, 32>
  %r = wave.binary remsi %x, %divisor
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  return %r : !wave.simd<i32, 32>
}

// -----

// NORMALIZE-LABEL: func.func @signed_dynamic_nonpositive_divisor
// NORMALIZE: wave.binary divsi
// NORMALIZE: wave.binary remsi
// NORMALIZE-NOT: wave.binary divui
// NORMALIZE-NOT: wave.binary remui
// NORMALIZE: return
func.func @signed_dynamic_nonpositive_divisor(%x: i32, %d: i32)
    -> (i32, i32) {
  %nonneg = wave.assume %x as "x" [#wave.pred<"x >= 0">] : i32
  %nonpos = wave.assume %d as "d" [#wave.pred<"d <= 0">] : i32
  %q = wave.binary divsi %nonneg, %nonpos : i32, i32 -> i32
  %r = wave.binary remsi %nonneg, %nonpos : i32, i32 -> i32
  return %q, %r : i32, i32
}

// -----

// CHECK-LABEL: func.func @signed_const_i32_negative_numerator
// CHECK-NOT: wave.select
// CHECK: [[QUOT:%.*]] = wave.constant -2 : i32
// CHECK: [[REM:%.*]] = wave.constant -1 : i32
// CHECK: return [[QUOT]], [[REM]] : i32, i32
func.func @signed_const_i32_negative_numerator() -> (i32, i32) {
  %minus_seven = arith.constant -7 : i32
  %three = arith.constant 3 : i32
  %q = wave.binary divsi %minus_seven, %three : i32, i32 -> i32
  %r = wave.binary remsi %minus_seven, %three : i32, i32 -> i32
  return %q, %r : i32, i32
}

// -----

// CHECK-LABEL: func.func @signed_const_i32_int_min_ones
// CHECK: [[MIN:%.*]] = arith.constant -2147483648 : i32
// CHECK: [[ZERO:%.*]] = arith.constant 0 : i32
// CHECK: [[WAVE_MIN:%.*]] = wave.constant -2147483648 : i32
// CHECK: [[WAVE_ZERO:%.*]] = wave.constant 0 : i32
// CHECK-NOT: wave.select
// CHECK: return [[MIN]], [[ZERO]], [[WAVE_MIN]], [[WAVE_ZERO]]
func.func @signed_const_i32_int_min_ones() -> (i32, i32, i32, i32) {
  %min = arith.constant -2147483648 : i32
  %one = arith.constant 1 : i32
  %minus_one = arith.constant -1 : i32
  %quot_one = wave.binary divsi %min, %one : i32, i32 -> i32
  %rem_one = wave.binary remsi %min, %one : i32, i32 -> i32
  %quot_minus_one = wave.binary divsi %min, %minus_one : i32, i32 -> i32
  %rem_minus_one = wave.binary remsi %min, %minus_one : i32, i32 -> i32
  return %quot_one, %rem_one, %quot_minus_one, %rem_minus_one
      : i32, i32, i32, i32
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

// CHECK-LABEL: func.func @signed_loop_index_rem3_nonnegative
// CHECK: [[LOOP:%.*]]:2 = scf.for [[IV:%[^ ]+]] =
// CHECK-SAME: iter_args([[ACC:%.*]] = {{%.*}}, [[RESIDUE:%.*]] = {{%.*}})
// CHECK: [[BOUNDED:%.*]] = wave.assume [[RESIDUE]] as "r"
// CHECK-SAME: #wave.pred<"r >= 0 & -2 + r <= 0">
// CHECK: [[NEXT:%.*]] = arith.addi [[ACC]], [[BOUNDED]]
// CHECK: [[WRAP:%.*]] = arith.cmpi sge, [[RESIDUE]],
// CHECK: [[NEXT_RESIDUE:%.*]] = wave.select [[WRAP]],
// CHECK: scf.yield [[NEXT]], [[NEXT_RESIDUE]]
// CHECK-NOT: wave.binary mulhui
// CHECK-NOT: remsi
// CHECK: return [[LOOP]]#0
func.func @signed_loop_index_rem3_nonnegative(%ub: index) -> index {
  %c0 = arith.constant 0 : index
  %c1 = arith.constant 1 : index
  %c3 = arith.constant 3 : index
  %sum = scf.for %i = %c0 to %ub step %c1 iter_args(%acc = %c0) -> index {
    %r = wave.binary remsi %i, %c3 : index, index -> index
    %next = arith.addi %acc, %r : index
    scf.yield %next : index
  }
  return %sum : index
}

// -----

// CHECK-LABEL: func.func @unsigned_loop_i32_rem5_nonzero_lower
// CHECK: [[INIT:%.*]] = wave.constant 2 : i32
// CHECK: [[LOOP:%.*]]:2 = scf.for unsigned [[IV:%[^ ]+]] =
// CHECK-SAME: iter_args([[ACC:%.*]] = {{%.*}}, [[RESIDUE:%.*]] = [[INIT]])
// CHECK: [[BOUNDED:%.*]] = wave.assume [[RESIDUE]] as "r"
// CHECK-SAME: #wave.pred<"r >= 0 & -4 + r <= 0">
// CHECK: [[DERIVED_WRAP:%.*]] = arith.cmpi uge, [[BOUNDED]],
// CHECK: [[DERIVED:%.*]] = wave.select [[DERIVED_WRAP]],
// CHECK: [[NEXT:%.*]] = arith.addi {{%.*}}, [[DERIVED]]
// CHECK: [[CARRY_WRAP:%.*]] = arith.cmpi uge, [[RESIDUE]],
// CHECK: [[NEXT_RESIDUE:%.*]] = wave.select [[CARRY_WRAP]],
// CHECK: scf.yield [[NEXT]], [[NEXT_RESIDUE]]
// CHECK-NOT: wave.binary mulhui
// CHECK-NOT: remui
// CHECK: return [[LOOP]]#0
func.func @unsigned_loop_i32_rem5_nonzero_lower(%ub: i32) -> i32 {
  %c0 = arith.constant 0 : i32
  %c1 = arith.constant 1 : i32
  %c2 = arith.constant 2 : i32
  %c5 = arith.constant 5 : i32
  %c7 = arith.constant 7 : i32
  %sum = scf.for unsigned %i = %c7 to %ub step %c1
      iter_args(%acc = %c0) -> i32 : i32 {
    %base = wave.binary remui %i, %c5 : i32, i32 -> i32
    %shifted = wave.binary addi %i, %c2 overflow<nuw> : i32, i32 -> i32
    %derived = wave.binary remui %shifted, %c5 : i32, i32 -> i32
    %next = arith.addi %acc, %derived : i32
    scf.yield %next : i32
  }
  return %sum : i32
}

// -----

// CHECK-LABEL: func.func @unsigned_loop_i32_rem7_step2_nonzero_lower
// CHECK: [[INIT:%.*]] = arith.constant 4 : i32
// CHECK: [[LOOP:%.*]]:2 = scf.for unsigned [[IV:%[^ ]+]] =
// CHECK-SAME: iter_args([[ACC:%.*]] = {{%.*}}, [[RESIDUE:%.*]] = [[INIT]])
// CHECK: [[BOUNDED:%.*]] = wave.assume [[RESIDUE]] as "r"
// CHECK-SAME: #wave.pred<"r >= 0 & -6 + r <= 0">
// CHECK: [[NEXT:%.*]] = arith.addi [[ACC]], [[BOUNDED]]
// CHECK: [[WRAP:%.*]] = arith.cmpi uge, [[RESIDUE]],
// CHECK: [[NEXT_RESIDUE:%.*]] = wave.select [[WRAP]],
// CHECK: scf.yield [[NEXT]], [[NEXT_RESIDUE]]
// CHECK-NOT: wave.binary mulhui
// CHECK-NOT: remui
// CHECK: return [[LOOP]]#0
func.func @unsigned_loop_i32_rem7_step2_nonzero_lower(%ub: i32) -> i32 {
  %c0 = arith.constant 0 : i32
  %c2 = arith.constant 2 : i32
  %c4 = arith.constant 4 : i32
  %c7 = arith.constant 7 : i32
  %sum = scf.for unsigned %i = %c4 to %ub step %c2
      iter_args(%acc = %c0) -> i32 : i32 {
    %residue = wave.binary remui %i, %c7 : i32, i32 -> i32
    %next = arith.addi %acc, %residue : i32
    scf.yield %next : i32
  }
  return %sum : i32
}

// -----

// CHECK-LABEL: func.func @unsigned_remainder_signed_loop_crosses_zero
// CHECK: [[LOOP:%.*]] = scf.for [[IV:%[^ ]+]] =
// CHECK: wave.binary andi [[IV]],
// CHECK: wave.binary muli
// CHECK-NOT: remui
// CHECK: return [[LOOP]]
func.func @unsigned_remainder_signed_loop_crosses_zero() -> i32 {
  %c_minus2 = arith.constant -2 : i32
  %c0 = arith.constant 0 : i32
  %c1 = arith.constant 1 : i32
  %c2 = arith.constant 2 : i32
  %c3 = arith.constant 3 : i32
  %sum = scf.for %i = %c_minus2 to %c2 step %c1
      iter_args(%acc = %c0) -> i32 : i32 {
    %residue = wave.binary remui %i, %c3 : i32, i32 -> i32
    %next = arith.addi %acc, %residue : i32
    scf.yield %next : i32
  }
  return %sum : i32
}

// -----

// CHECK-LABEL: func.func @signed_loop_i32_index_cast_rem3_nonnegative
// CHECK: scf.for [[IV:%[^ ]+]] =
// CHECK: arith.index_cast [[IV]]
// CHECK-NOT: arith.cmpi slt
// CHECK: wave.binary mulhui
// CHECK-NOT: remsi
func.func @signed_loop_i32_index_cast_rem3_nonnegative(%trip: i32) -> i32 {
  %c0 = arith.constant 0 : index
  %c1 = arith.constant 1 : index
  %c3 = arith.constant 3 : i32
  %trip_idx = arith.index_cast %trip : i32 to index
  %sum = scf.for %i = %c0 to %trip_idx step %c1
      iter_args(%acc = %trip) -> i32 {
    %i32 = arith.index_cast %i : index to i32
    %r = wave.binary remsi %i32, %c3 : i32, i32 -> i32
    %next = arith.addi %acc, %r : i32
    scf.yield %next : i32
  }
  return %sum : i32
}

// -----

// CHECK-LABEL: func.func @signed_unsigned_loop_i32_rem3_bounded_nonnegative
// CHECK: [[LOOP:%.*]]:2 = scf.for unsigned [[IV:%[^ ]+]] =
// CHECK-SAME: iter_args([[ACC:%.*]] = {{%.*}}, [[RESIDUE:%.*]] = {{%.*}})
// CHECK: [[BOUNDED:%.*]] = wave.assume [[RESIDUE]] as "r"
// CHECK-SAME: #wave.pred<"r >= 0 & -2 + r <= 0">
// CHECK: [[NEXT:%.*]] = arith.addi [[ACC]], [[BOUNDED]]
// CHECK: [[WRAP:%.*]] = arith.cmpi sge, [[RESIDUE]],
// CHECK: [[NEXT_RESIDUE:%.*]] = wave.select [[WRAP]],
// CHECK: scf.yield [[NEXT]], [[NEXT_RESIDUE]]
// CHECK-NOT: wave.binary mulhui
// CHECK-NOT: remsi
// CHECK: return [[LOOP]]#0
func.func @signed_unsigned_loop_i32_rem3_bounded_nonnegative() -> i32 {
  %c0 = arith.constant 0 : i32
  %c1 = arith.constant 1 : i32
  %c3 = arith.constant 3 : i32
  %c42 = arith.constant 42 : i32
  %sum = scf.for unsigned %i = %c0 to %c42 step %c1
      iter_args(%acc = %c0) -> i32 : i32 {
    %r = wave.binary remsi %i, %c3 : i32, i32 -> i32
    %next = arith.addi %acc, %r : i32
    scf.yield %next : i32
  }
  return %sum : i32
}

// -----

// CHECK-LABEL: func.func @signed_unsigned_loop_i32_rem3_high_unsigned_bound
// CHECK: scf.for unsigned [[IV:%[^ ]+]] =
// CHECK: arith.cmpi slt
// CHECK-NOT: remsi
func.func @signed_unsigned_loop_i32_rem3_high_unsigned_bound() -> i32 {
  %c0 = arith.constant 0 : i32
  %c1 = arith.constant 1 : i32
  %c3 = arith.constant 3 : i32
  %c_minus1 = arith.constant -1 : i32
  %sum = scf.for unsigned %i = %c0 to %c_minus1 step %c1
      iter_args(%acc = %c0) -> i32 : i32 {
    %r = wave.binary remsi %i, %c3 : i32, i32 -> i32
    %next = arith.addi %acc, %r : i32
    scf.yield %next : i32
  }
  return %sum : i32
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

// A signed-i32 range permits the same narrowing even when either operand may
// be negative. The i32 signed div/rem expansion is total on poison inputs, and
// the mathematical index result is sign-extended for remaining wide users.
// CHECK-LABEL: func.func @signed_i32_range_index_uses_i32
// CHECK: [[X32:%.*]] = wave.cast intconvert {{.*}} : index -> i32
// CHECK: [[D32:%.*]] = wave.cast intconvert {{.*}} : index -> i32
// CHECK: wave.urecip {{.*}} : i32 -> i32
// CHECK: wave.cast intconvert {{.*}} policy {extension = #wave.cast_extension<sign>} : i32 -> index
// CHECK-NOT: wave.binary divsi
// CHECK-NOT: wave.binary remsi
func.func @signed_i32_range_index_uses_i32(%x: index, %d: index)
    -> (index, index) {
  %bx = wave.assume %x as "x"
      [#wave.pred<"2147483648 + x >= 0">,
       #wave.pred<"-2147483647 + x <= 0">] : index
  %bd = wave.assume %d as "d"
      [#wave.pred<"2147483648 + d >= 0">,
       #wave.pred<"-2147483647 + d <= 0">] : index
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

// -----

// NORMALIZE-LABEL: func.func @normalize_workgroup_divrem
// NORMALIZE: %[[WG:.*]] = wave.workgroup_id 0
// NORMALIZE: %[[DIV:.*]] = wave.binary divui %[[WG]]
// NORMALIZE: %[[REM:.*]] = wave.binary remui %[[WG]]
// NORMALIZE-NOT: wave.binary divsi
// NORMALIZE-NOT: wave.binary remsi
func.func @normalize_workgroup_divrem() -> (i32, i32) {
  %wg = wave.workgroup_id 0
  %eight = arith.constant 8 : i32
  %q = wave.binary divsi %wg, %eight : i32, i32 -> i32
  %r = wave.binary remsi %wg, %eight : i32, i32 -> i32
  return %q, %r : i32, i32
}
