// RUN: wave-opt --split-input-file --wave-optimize-masks --canonicalize %s | FileCheck %s

// CHECK-LABEL: func.func @equivalent_from_assumptions
// CHECK: %[[M1:.*]] = wave.cmpi slt
// CHECK: %[[M16:.*]] = wave.cmpi slt
// CHECK-NOT: wave.cmpi
// CHECK: return %[[M1]], %[[M1]], %[[M16]]
func.func @equivalent_from_assumptions(%base_raw: i32, %limit_raw: i32)
    -> (!wave.mask<64>, !wave.mask<64>, !wave.mask<64>) {
  %base = wave.assume %base_raw as "x"
      [#wave.pred<"Mod(x, 16) == 0">] : i32
  %limit = wave.assume %limit_raw as "x"
      [#wave.pred<"Mod(x, 16) == 0">] : i32
  %base_splat = wave.splat %base : i32 -> !wave.simd<i32, 64>
  %limit_splat = wave.splat %limit : i32 -> !wave.simd<i32, 64>
  %c1 = wave.constant 1 : i32 -> !wave.simd<i32, 64>
  %c7 = wave.constant 7 : i32 -> !wave.simd<i32, 64>
  %c16 = wave.constant 16 : i32 -> !wave.simd<i32, 64>
  %i1 = wave.binary addi %base_splat, %c1
      : !wave.simd<i32, 64>, !wave.simd<i32, 64>
      -> !wave.simd<i32, 64>
  %i7 = wave.binary addi %base_splat, %c7
      : !wave.simd<i32, 64>, !wave.simd<i32, 64>
      -> !wave.simd<i32, 64>
  %i16 = wave.binary addi %base_splat, %c16
      : !wave.simd<i32, 64>, !wave.simd<i32, 64>
      -> !wave.simd<i32, 64>
  %m1 = wave.cmpi slt %i1, %limit_splat
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
  %m7 = wave.cmpi slt %i7, %limit_splat
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
  %m16 = wave.cmpi slt %i16, %limit_splat
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
  return %m1, %m7, %m16
      : !wave.mask<64>, !wave.mask<64>, !wave.mask<64>
}

// -----

// CHECK-LABEL: func.func @equivalent_inside_congruence_bucket
// CHECK: %[[M0:.*]] = wave.cmpi slt
// CHECK: %[[M12:.*]] = wave.cmpi slt
// CHECK-NOT: wave.cmpi
// CHECK: return %[[M0]], %[[M0]], %[[M12]]
func.func @equivalent_inside_congruence_bucket(
    %base_raw: i32, %limit_raw: i32, %toggle_raw: i32)
    -> (!wave.mask<64>, !wave.mask<64>, !wave.mask<64>) {
  %base = wave.assume %base_raw as "x"
      [#wave.pred<"Mod(x, 16) == 0">] : i32
  %limit = wave.assume %limit_raw as "x"
      [#wave.pred<"Mod(x, 16) == 0">] : i32
  %toggle = wave.assume %toggle_raw as "x"
      [#wave.pred<"x >= 0">, #wave.pred<"-1 + x <= 0">] : i32
  %base_splat = wave.splat %base : i32 -> !wave.simd<i32, 64>
  %limit_splat = wave.splat %limit : i32 -> !wave.simd<i32, 64>
  %toggle_splat = wave.splat %toggle : i32 -> !wave.simd<i32, 64>
  %c4 = wave.constant 4 : i32 -> !wave.simd<i32, 64>
  %c8 = wave.constant 8 : i32 -> !wave.simd<i32, 64>
  %c12 = wave.constant 12 : i32 -> !wave.simd<i32, 64>
  %residual = wave.binary muli %toggle_splat, %c4
      : !wave.simd<i32, 64>, !wave.simd<i32, 64>
      -> !wave.simd<i32, 64>
  %i0 = wave.binary addi %base_splat, %residual
      : !wave.simd<i32, 64>, !wave.simd<i32, 64>
      -> !wave.simd<i32, 64>
  %i8 = wave.binary addi %i0, %c8
      : !wave.simd<i32, 64>, !wave.simd<i32, 64>
      -> !wave.simd<i32, 64>
  %i12 = wave.binary addi %i0, %c12
      : !wave.simd<i32, 64>, !wave.simd<i32, 64>
      -> !wave.simd<i32, 64>
  %m0 = wave.cmpi slt %i0, %limit_splat
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
  %m8 = wave.cmpi slt %i8, %limit_splat
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
  %m12 = wave.cmpi slt %i12, %limit_splat
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
  return %m0, %m8, %m12
      : !wave.mask<64>, !wave.mask<64>, !wave.mask<64>
}

// -----

// CHECK-LABEL: func.func @non_strict_predicates
// CHECK: %[[LE:.*]] = wave.cmpi sle
// CHECK: %[[GT:.*]] = wave.cmpi sgt
// CHECK-NOT: wave.cmpi
// CHECK: return %[[LE]], %[[LE]], %[[GT]], %[[GT]]
func.func @non_strict_predicates(%base_raw: i32, %limit_raw: i32)
    -> (!wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>) {
  %base = wave.assume %base_raw as "x"
      [#wave.pred<"Mod(x, 16) == 0">] : i32
  %limit = wave.assume %limit_raw as "x"
      [#wave.pred<"Mod(x, 16) == 0">] : i32
  %base_splat = wave.splat %base : i32 -> !wave.simd<i32, 64>
  %limit_splat = wave.splat %limit : i32 -> !wave.simd<i32, 64>
  %c1 = wave.constant 1 : i32 -> !wave.simd<i32, 64>
  %c7 = wave.constant 7 : i32 -> !wave.simd<i32, 64>
  %i1 = wave.binary addi %base_splat, %c1
      : !wave.simd<i32, 64>, !wave.simd<i32, 64>
      -> !wave.simd<i32, 64>
  %i7 = wave.binary addi %base_splat, %c7
      : !wave.simd<i32, 64>, !wave.simd<i32, 64>
      -> !wave.simd<i32, 64>
  %le1 = wave.cmpi sle %i1, %limit_splat
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
  %le7 = wave.cmpi sle %i7, %limit_splat
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
  %gt1 = wave.cmpi sgt %i1, %limit_splat
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
  %gt7 = wave.cmpi sgt %i7, %limit_splat
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
  return %le1, %le7, %gt1, %gt7
      : !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>
}

// -----

// CHECK-LABEL: func.func @unaligned_boundary
// CHECK-COUNT-2: wave.cmpi slt
func.func @unaligned_boundary(
    %base_raw: i32, %limit: !wave.simd<i32, 64>)
    -> (!wave.mask<64>, !wave.mask<64>) {
  %base = wave.assume %base_raw as "x"
      [#wave.pred<"Mod(x, 16) == 0">] : i32
  %base_splat = wave.splat %base : i32 -> !wave.simd<i32, 64>
  %c1 = wave.constant 1 : i32 -> !wave.simd<i32, 64>
  %c7 = wave.constant 7 : i32 -> !wave.simd<i32, 64>
  %i1 = wave.binary addi %base_splat, %c1
      : !wave.simd<i32, 64>, !wave.simd<i32, 64>
      -> !wave.simd<i32, 64>
  %i7 = wave.binary addi %base_splat, %c7
      : !wave.simd<i32, 64>, !wave.simd<i32, 64>
      -> !wave.simd<i32, 64>
  %m1 = wave.cmpi slt %i1, %limit
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
  %m7 = wave.cmpi slt %i7, %limit
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
  return %m1, %m7 : !wave.mask<64>, !wave.mask<64>
}

// -----

// Result-local assumptions cannot justify sharing a sibling mask.
// CHECK-LABEL: func.func @sibling_packet_facts_stay_local
// CHECK-COUNT-2: wave.cmpi slt
func.func @sibling_packet_facts_stay_local(
    %x: !wave.simd<i32, 32>, %y: !wave.simd<i32, 32>,
    %limit: !wave.simd<i32, 32>) -> (!wave.mask<32>, !wave.mask<32>) {
  %lhs = wave.index_expr <"x"> assuming [#wave.pred<"x - y == 0">]
      ["x", "y"](%x, %y)
      : (!wave.simd<i32, 32>, !wave.simd<i32, 32>)
        -> !wave.simd<index, 32>
  %rhs = wave.index_expr <"y"> ["y"](%y)
      : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
  %bound = wave.index_expr <"limit"> ["limit"](%limit)
      : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
  %left = wave.cmpi slt %lhs, %bound
      : !wave.simd<index, 32>, !wave.simd<index, 32> -> !wave.mask<32>
  %right = wave.cmpi slt %rhs, %bound
      : !wave.simd<index, 32>, !wave.simd<index, 32> -> !wave.mask<32>
  return %left, %right : !wave.mask<32>, !wave.mask<32>
}

// -----

// Adding one alignment unit can wrap at the largest aligned i32 value.
// CHECK-LABEL: func.func @wrapping_add
// CHECK-COUNT-2: wave.cmpi slt
func.func @wrapping_add(%base_raw: i32, %limit_raw: i32)
    -> (!wave.mask<64>, !wave.mask<64>) {
  %base = wave.assume %base_raw as "x"
      [#wave.pred<"Mod(x, 16) == 0">] : i32
  %limit = wave.assume %limit_raw as "x"
      [#wave.pred<"Mod(x, 16) == 0">] : i32
  %base_splat = wave.splat %base : i32 -> !wave.simd<i32, 64>
  %limit_splat = wave.splat %limit : i32 -> !wave.simd<i32, 64>
  %c0 = wave.constant 0 : i32 -> !wave.simd<i32, 64>
  %c16 = wave.constant 16 : i32 -> !wave.simd<i32, 64>
  %i0 = wave.binary addi %base_splat, %c0
      : !wave.simd<i32, 64>, !wave.simd<i32, 64>
      -> !wave.simd<i32, 64>
  %i16 = wave.binary addi %base_splat, %c16
      : !wave.simd<i32, 64>, !wave.simd<i32, 64>
      -> !wave.simd<i32, 64>
  %m0 = wave.cmpi slt %i0, %limit_splat
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
  %m16 = wave.cmpi slt %i16, %limit_splat
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
  return %m0, %m16 : !wave.mask<64>, !wave.mask<64>
}

// -----

// CHECK-LABEL: func.func @constant_from_assumption
// CHECK: %[[TRUE:.*]] = wave.constant true -> !wave.mask<64>
// CHECK-NOT: wave.cmpi
// CHECK: return %[[TRUE]]
func.func @constant_from_assumption(%value_raw: i32) -> !wave.mask<64> {
  %value = wave.assume %value_raw as "x"
      [#wave.pred<"x >= 0">, #wave.pred<"-7 + x <= 0">] : i32
  %value_splat = wave.splat %value : i32 -> !wave.simd<i32, 64>
  %c8 = wave.constant 8 : i32 -> !wave.simd<i32, 64>
  %mask = wave.cmpi slt %value_splat, %c8
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
  return %mask : !wave.mask<64>
}

// -----

// The result contract applies to any refinement of a possibly-poison division.
// CHECK-LABEL: func.func @undefined_predicate_is_not_constant
// CHECK: wave.constant true
// CHECK-NOT: wave.cmpi
func.func @undefined_predicate_is_not_constant(
    %x: !wave.simd<i32, 64>, %d: !wave.simd<i32, 64>) -> !wave.mask<64> {
  %q = wave.binary divsi %x, %d
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
  %bounded = wave.assume %q as "q"
      [#wave.pred<"q >= 0">, #wave.pred<"q <= 7">]
      : !wave.simd<i32, 64>
  %c8_scalar = arith.constant 8 : i32
  %c8 = wave.splat %c8_scalar : i32 -> !wave.simd<i32, 64>
  %mask = wave.cmpi slt %bounded, %c8
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
  return %mask : !wave.mask<64>
}

// -----

// A zero-divisor poison result may refine to the Assume contract.
// CHECK-LABEL: func.func @divsi_zero_divisor_is_not_constant
// CHECK: wave.constant true
// CHECK-NOT: wave.cmpi
func.func @divsi_zero_divisor_is_not_constant(
    %x: i32) -> !wave.mask<64> {
  %zero = arith.constant 0 : i32
  %q = wave.binary divsi %x, %zero : i32, i32 -> i32
  %bounded = wave.assume %q as "q"
      [#wave.pred<"q >= 0">, #wave.pred<"q <= 7">] : i32
  %bounded_splat = wave.splat %bounded : i32 -> !wave.simd<i32, 64>
  %c8 = wave.constant 8 : i32 -> !wave.simd<i32, 64>
  %mask = wave.cmpi slt %bounded_splat, %c8
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
  return %mask : !wave.mask<64>
}

// -----

// Signed remainder by zero is poison and admits the same refinement.
// CHECK-LABEL: func.func @remsi_zero_divisor_is_not_constant
// CHECK: wave.constant true
// CHECK-NOT: wave.cmpi
func.func @remsi_zero_divisor_is_not_constant(
    %x: !wave.simd<i32, 64>) -> !wave.mask<64> {
  %zero = wave.constant 0 : i32 -> !wave.simd<i32, 64>
  %r = wave.binary remsi %x, %zero
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
  %bounded = wave.assume %r as "r"
      [#wave.pred<"r >= 0">, #wave.pred<"r <= 7">]
      : !wave.simd<i32, 64>
  %c8 = wave.constant 8 : i32 -> !wave.simd<i32, 64>
  %mask = wave.cmpi slt %bounded, %c8
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
  return %mask : !wave.mask<64>
}

// -----

// Signed INT_MIN / -1 is poison and may refine to the result contract.
// CHECK-LABEL: func.func @divsi_overflow_is_not_constant
// CHECK: wave.constant true
// CHECK-NOT: wave.cmpi
func.func @divsi_overflow_is_not_constant() -> !wave.mask<64> {
  %min = wave.constant -2147483648 : i32 -> !wave.simd<i32, 64>
  %minus_one = wave.constant -1 : i32 -> !wave.simd<i32, 64>
  %q = wave.binary divsi %min, %minus_one
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
  %bounded = wave.assume %q as "q"
      [#wave.pred<"q >= 0">, #wave.pred<"q <= 7">]
      : !wave.simd<i32, 64>
  %c8 = wave.constant 8 : i32 -> !wave.simd<i32, 64>
  %mask = wave.cmpi slt %bounded, %c8
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
  return %mask : !wave.mask<64>
}

// -----

// Unlike signed division, INT_MIN % -1 is defined and equals zero.
// CHECK-LABEL: func.func @remsi_min_minus_one_folds
// CHECK: %[[TRUE:.*]] = wave.constant true -> !wave.mask<64>
// CHECK-NOT: wave.cmpi
// CHECK: return %[[TRUE]]
func.func @remsi_min_minus_one_folds() -> !wave.mask<64> {
  %min = wave.constant -2147483648 : i32 -> !wave.simd<i32, 64>
  %minus_one = wave.constant -1 : i32 -> !wave.simd<i32, 64>
  %r = wave.binary remsi %min, %minus_one
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
  %one = wave.constant 1 : i32 -> !wave.simd<i32, 64>
  %mask = wave.cmpi slt %r, %one
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
  return %mask : !wave.mask<64>
}

// -----

// Unsigned division and remainder poison likewise admit result refinement.
// CHECK-LABEL: func.func @unsigned_zero_divisor_is_not_constant
// CHECK: %[[TRUE:.*]] = wave.constant true
// CHECK-NOT: wave.cmpi
// CHECK: return %[[TRUE]], %[[TRUE]]
func.func @unsigned_zero_divisor_is_not_constant(
    %x: !wave.simd<i32, 64>) -> (!wave.mask<64>, !wave.mask<64>) {
  %zero = wave.constant 0 : i32 -> !wave.simd<i32, 64>
  %q = wave.binary divui %x, %zero
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
  %r = wave.binary remui %x, %zero
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
  %bounded_q = wave.assume %q as "q"
      [#wave.pred<"q >= 0">, #wave.pred<"q <= 7">]
      : !wave.simd<i32, 64>
  %bounded_r = wave.assume %r as "r"
      [#wave.pred<"r >= 0">, #wave.pred<"r <= 7">]
      : !wave.simd<i32, 64>
  %c8 = wave.constant 8 : i32 -> !wave.simd<i32, 64>
  %q_mask = wave.cmpi slt %bounded_q, %c8
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
  %r_mask = wave.cmpi slt %bounded_r, %c8
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
  return %q_mask, %r_mask : !wave.mask<64>, !wave.mask<64>
}

// -----

// Out-of-range shifts are poison; each result contract remains usable.
// CHECK-LABEL: func.func @unproved_shift_domain_is_not_constant
// CHECK: %[[TRUE:.*]] = wave.constant true
// CHECK-NOT: wave.cmpi
// CHECK: return %[[TRUE]], %[[TRUE]], %[[TRUE]]
func.func @unproved_shift_domain_is_not_constant(
    %x: !wave.simd<i32, 64>, %amount: !wave.simd<i32, 64>)
    -> (!wave.mask<64>, !wave.mask<64>, !wave.mask<64>) {
  %left = wave.binary shli %x, %amount
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
  %logical = wave.binary shrui %x, %amount
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
  %arithmetic = wave.binary shrsi %x, %amount
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
  %bounded_left = wave.assume %left as "left"
      [#wave.pred<"left >= 0">, #wave.pred<"left <= 7">]
      : !wave.simd<i32, 64>
  %bounded_logical = wave.assume %logical as "logical"
      [#wave.pred<"logical >= 0">, #wave.pred<"logical <= 7">]
      : !wave.simd<i32, 64>
  %bounded_arithmetic = wave.assume %arithmetic as "arithmetic"
      [#wave.pred<"arithmetic >= 0">, #wave.pred<"arithmetic <= 7">]
      : !wave.simd<i32, 64>
  %c8 = wave.constant 8 : i32 -> !wave.simd<i32, 64>
  %left_mask = wave.cmpi slt %bounded_left, %c8
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
  %logical_mask = wave.cmpi slt %bounded_logical, %c8
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
  %arithmetic_mask = wave.cmpi slt %bounded_arithmetic, %c8
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
  return %left_mask, %logical_mask, %arithmetic_mask
      : !wave.mask<64>, !wave.mask<64>, !wave.mask<64>
}

// -----

// The result contract folds the inner predicate without changing the retained
// outer guard.
// CHECK-LABEL: func.func @retained_guard_does_not_bound_shuffle_source
// CHECK: wave.constant true
// CHECK: wave.cmpi slt
// CHECK: wave.select
func.func @retained_guard_does_not_bound_shuffle_source(
    %source: !wave.simd<i32, 64>,
    %lane_raw: !wave.simd<i32, 64>) -> !wave.mask<64> {
  %lane = wave.assume %lane_raw as "lane"
      [#wave.pred<"lane >= 0">, #wave.pred<"lane <= 63">]
      : !wave.simd<i32, 64>
  %one = wave.constant 1 : i32 -> !wave.simd<i32, 64>
  %c8 = wave.constant 8 : i32 -> !wave.simd<i32, 64>
  %guard = wave.cmpi slt %source, %c8
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
  %shuffled = wave.shuffle %source from %lane
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
  %increment = wave.binary addi %shuffled, %one overflow<nsw>
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
  %bounded = wave.assume %increment as "bounded"
      [#wave.pred<"bounded >= 0">, #wave.pred<"bounded <= 7">]
      : !wave.simd<i32, 64>
  %inner = wave.cmpi slt %bounded, %c8
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
  %false = wave.constant false -> !wave.mask<64>
  %active = wave.select %guard, %inner, %false
      : !wave.mask<64>, !wave.mask<64>
  return %active : !wave.mask<64>
}

// -----

// Definition-owned input facts prove all division and remainder domains, so
// the result assumptions remain available to mask folding.
// CHECK-LABEL: func.func @proved_divrem_domains_fold
// CHECK: %[[TRUE:.*]] = wave.constant true -> !wave.mask<64>
// CHECK-NOT: wave.cmpi
// CHECK: return %[[TRUE]], %[[TRUE]], %[[TRUE]], %[[TRUE]]
func.func @proved_divrem_domains_fold(
    %lhs_raw: !wave.simd<i32, 64>, %rhs_raw: !wave.simd<i32, 64>)
    -> (!wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>) {
  %lhs = wave.assume %lhs_raw as "lhs"
      [#wave.pred<"lhs >= 0">, #wave.pred<"lhs <= 1024">]
      : !wave.simd<i32, 64>
  %rhs = wave.assume %rhs_raw as "rhs"
      [#wave.pred<"rhs >= 1">, #wave.pred<"rhs <= 31">]
      : !wave.simd<i32, 64>
  %divs = wave.binary divsi %lhs, %rhs
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
  %divu = wave.binary divui %lhs, %rhs
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
  %rems = wave.binary remsi %lhs, %rhs
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
  %remu = wave.binary remui %lhs, %rhs
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
  %bounded_divs = wave.assume %divs as "divs"
      [#wave.pred<"divs >= 0">, #wave.pred<"divs <= 7">]
      : !wave.simd<i32, 64>
  %bounded_divu = wave.assume %divu as "divu"
      [#wave.pred<"divu >= 0">, #wave.pred<"divu <= 7">]
      : !wave.simd<i32, 64>
  %bounded_rems = wave.assume %rems as "rems"
      [#wave.pred<"rems >= 0">, #wave.pred<"rems <= 7">]
      : !wave.simd<i32, 64>
  %bounded_remu = wave.assume %remu as "remu"
      [#wave.pred<"remu >= 0">, #wave.pred<"remu <= 7">]
      : !wave.simd<i32, 64>
  %c8 = wave.constant 8 : i32 -> !wave.simd<i32, 64>
  %divs_mask = wave.cmpi slt %bounded_divs, %c8
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
  %divu_mask = wave.cmpi slt %bounded_divu, %c8
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
  %rems_mask = wave.cmpi slt %bounded_rems, %c8
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
  %remu_mask = wave.cmpi slt %bounded_remu, %c8
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
  return %divs_mask, %divu_mask, %rems_mask, %remu_mask
      : !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>
}

// -----

// A proven shift domain permits the opaque producer fallback used for
// dynamic and otherwise unsupported shift representations.
// CHECK-LABEL: func.func @proved_shift_domain_folds
// CHECK: %[[TRUE:.*]] = wave.constant true -> !wave.mask<64>
// CHECK-NOT: wave.cmpi
// CHECK: return %[[TRUE]], %[[TRUE]], %[[TRUE]]
func.func @proved_shift_domain_folds(
    %x: !wave.simd<i32, 64>, %amount_raw: !wave.simd<i32, 64>)
    -> (!wave.mask<64>, !wave.mask<64>, !wave.mask<64>) {
  %amount = wave.assume %amount_raw as "amount"
      [#wave.pred<"amount >= 0">, #wave.pred<"amount <= 31">]
      : !wave.simd<i32, 64>
  %left = wave.binary shli %x, %amount
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
  %logical = wave.binary shrui %x, %amount
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
  %arithmetic = wave.binary shrsi %x, %amount
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
  %bounded_left = wave.assume %left as "left"
      [#wave.pred<"left >= 0">, #wave.pred<"left <= 7">]
      : !wave.simd<i32, 64>
  %bounded_logical = wave.assume %logical as "logical"
      [#wave.pred<"logical >= 0">, #wave.pred<"logical <= 7">]
      : !wave.simd<i32, 64>
  %bounded_arithmetic = wave.assume %arithmetic as "arithmetic"
      [#wave.pred<"arithmetic >= 0">, #wave.pred<"arithmetic <= 7">]
      : !wave.simd<i32, 64>
  %c8 = wave.constant 8 : i32 -> !wave.simd<i32, 64>
  %left_mask = wave.cmpi slt %bounded_left, %c8
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
  %logical_mask = wave.cmpi slt %bounded_logical, %c8
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
  %arithmetic_mask = wave.cmpi slt %bounded_arithmetic, %c8
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
  return %left_mask, %logical_mask, %arithmetic_mask
      : !wave.mask<64>, !wave.mask<64>, !wave.mask<64>
}

// -----

// A total unsupported producer remains a valid opaque leaf.
// CHECK-LABEL: func.func @total_unsupported_leaf_folds
// CHECK: wave.constant true -> !wave.mask<64>
// CHECK-NOT: wave.cmpi
func.func @total_unsupported_leaf_folds(
    %x: !wave.simd<i32, 64>, %y: !wave.simd<i32, 64>) -> !wave.mask<64> {
  %high = wave.binary mulhui %x, %y
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
  %bounded = wave.assume %high as "high"
      [#wave.pred<"high >= 0">, #wave.pred<"high <= 7">]
      : !wave.simd<i32, 64>
  %c8 = wave.constant 8 : i32 -> !wave.simd<i32, 64>
  %mask = wave.cmpi slt %bounded, %c8
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
  return %mask : !wave.mask<64>
}

// -----

// Poison in an operand does not invalidate the outer result contract.
// CHECK-LABEL: func.func @total_outer_does_not_hide_partial_operand
// CHECK: wave.constant true
// CHECK-NOT: wave.cmpi
func.func @total_outer_does_not_hide_partial_operand(
    %x: !wave.simd<i32, 64>, %y: !wave.simd<i32, 64>) -> !wave.mask<64> {
  %zero = wave.constant 0 : i32 -> !wave.simd<i32, 64>
  %partial = wave.binary divsi %x, %zero
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
  %high = wave.binary mulhui %partial, %y
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
  %bounded = wave.assume %high as "high"
      [#wave.pred<"high >= 0">, #wave.pred<"high <= 7">]
      : !wave.simd<i32, 64>
  %c8 = wave.constant 8 : i32 -> !wave.simd<i32, 64>
  %mask = wave.cmpi slt %bounded, %c8
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
  return %mask : !wave.mask<64>
}

// -----

// The result contract also applies through an unclassified arithmetic wrapper.
// CHECK-LABEL: func.func @arith_wrapper_does_not_hide_partial_operand
// CHECK: wave.constant true
// CHECK-NOT: wave.cmpi
func.func @arith_wrapper_does_not_hide_partial_operand(
    %x: i32) -> !wave.mask<64> {
  %zero = arith.constant 0 : i32
  %one = arith.constant 1 : i32
  %partial = wave.binary divsi %x, %zero : i32, i32 -> i32
  %wrapped = arith.addi %partial, %one : i32
  %bounded = wave.assume %wrapped as "wrapped"
      [#wave.pred<"wrapped >= 0">, #wave.pred<"wrapped <= 7">] : i32
  %bounded_splat = wave.splat %bounded : i32 -> !wave.simd<i32, 64>
  %c8 = wave.constant 8 : i32 -> !wave.simd<i32, 64>
  %mask = wave.cmpi slt %bounded_splat, %c8
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
  return %mask : !wave.mask<64>
}

// -----

// CHECK-LABEL: func.func @constant_false_from_assumption
// CHECK: %[[FALSE:.*]] = wave.constant false -> !wave.mask<64>
// CHECK-NOT: wave.cmpi
// CHECK: return %[[FALSE]]
func.func @constant_false_from_assumption(
    %value_raw: i32) -> !wave.mask<64> {
  %value = wave.assume %value_raw as "x"
      [#wave.pred<"x >= 8">, #wave.pred<"-15 + x <= 0">] : i32
  %value_splat = wave.splat %value : i32 -> !wave.simd<i32, 64>
  %c8 = wave.constant 8 : i32 -> !wave.simd<i32, 64>
  %mask = wave.cmpi slt %value_splat, %c8
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
  return %mask : !wave.mask<64>
}

// -----

// CHECK-LABEL: func.func @integerized_mask_conjunction
// CHECK-DAG: %[[FALSE:.*]] = wave.constant false -> !wave.mask<64>
// CHECK-DAG: %[[LEFT:.*]] = wave.cmpi slt
// CHECK-DAG: %[[RIGHT:.*]] = wave.cmpi slt
// CHECK-NOT: wave.binary andi
// CHECK-NOT: wave.cmpi ne
// CHECK: %[[BOTH:.*]] = wave.select %[[LEFT]], %[[RIGHT]], %[[FALSE]]
// CHECK: return %[[BOTH]]
func.func @integerized_mask_conjunction(
    %x: !wave.simd<i32, 64>, %y: !wave.simd<i32, 64>,
    %limit: !wave.simd<i32, 64>) -> !wave.mask<64> {
  %left = wave.cmpi slt %x, %limit
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
  %right = wave.cmpi slt %y, %limit
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
  %one_scalar = arith.constant 1 : i32
  %zero_scalar = arith.constant 0 : i32
  %one = wave.splat %one_scalar : i32 -> !wave.simd<i32, 64>
  %zero = wave.splat %zero_scalar : i32 -> !wave.simd<i32, 64>
  %left_bits = wave.select %left, %one, %zero
      : !wave.mask<64>, !wave.simd<i32, 64>
  %right_bits = wave.select %right, %one, %zero
      : !wave.mask<64>, !wave.simd<i32, 64>
  %intersection = wave.binary andi %left_bits, %right_bits
      : !wave.simd<i32, 64>, !wave.simd<i32, 64>
      -> !wave.simd<i32, 64>
  %both = wave.cmpi ne %intersection, %zero
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
  return %both : !wave.mask<64>
}

// -----

// CHECK-LABEL: func.func @boolean_packet_alias_predicates
// CHECK-DAG: %[[DIRECT:.*]] = wave.cmpi slt
// CHECK-DAG: %[[INVERSE:.*]] = wave.cmpi sge
// CHECK-DAG: %[[TRUE:.*]] = wave.constant true -> !wave.mask<32>
// CHECK-DAG: %[[FALSE:.*]] = wave.constant false -> !wave.mask<32>
// CHECK-NOT: wave.cmpi
// CHECK: return %[[DIRECT]], %[[INVERSE]], %[[DIRECT]], %[[INVERSE]], %[[TRUE]], %[[FALSE]]
func.func @boolean_packet_alias_predicates(
    %x: !wave.simd<i32, 32>, %limit: !wave.simd<i32, 32>)
    -> (!wave.mask<32>, !wave.mask<32>, !wave.mask<32>, !wave.mask<32>,
        !wave.mask<32>, !wave.mask<32>) {
  %direct = wave.cmpi slt %x, %limit
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %inverse = wave.cmpi sge %x, %limit
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %zero = wave.constant 0 : i32 -> !wave.simd<i32, 32>
  %one = wave.constant 1 : i32 -> !wave.simd<i32, 32>
  %two = wave.constant 2 : i32 -> !wave.simd<i32, 32>
  %encoded = wave.select %direct, %one, %zero
      : !wave.mask<32>, !wave.simd<i32, 32>
  %packet = wave.pack %zero, %encoded, %two
      : !wave.simd<i32, 32>, !wave.simd<i32, 32>, !wave.simd<i32, 32>
      -> !wave.simd<vector<3xi32>, 32>
  %alias = wave.extract %packet[1]
      : !wave.simd<vector<3xi32>, 32> -> !wave.simd<i32, 32>
  %recovered = wave.cmpi ne %alias, %zero
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %recoveredInverse = wave.cmpi eq %zero, %alias
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %alwaysTrue = wave.cmpi ne %alias, %two
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %alwaysFalse = wave.cmpi eq %alias, %two
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  return %direct, %inverse, %recovered, %recoveredInverse, %alwaysTrue,
      %alwaysFalse
      : !wave.mask<32>, !wave.mask<32>, !wave.mask<32>, !wave.mask<32>,
        !wave.mask<32>, !wave.mask<32>
}

// -----

// CHECK-LABEL: func.func @boolean_redistribute_alias_predicate
// CHECK: %[[DIRECT:.*]] = wave.cmpi slt
// CHECK-NOT: wave.cmpi
// CHECK: return %[[DIRECT]], %[[DIRECT]]
func.func @boolean_redistribute_alias_predicate(
    %x: !wave.simd<i32, 32>, %limit: !wave.simd<i32, 32>)
    -> (!wave.mask<32>, !wave.mask<32>) {
  %direct = wave.cmpi slt %x, %limit
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %zero = wave.constant 0 : i32 -> !wave.simd<i32, 32>
  %one = wave.constant 1 : i32 -> !wave.simd<i32, 32>
  %encoded = wave.select %direct, %one, %zero
      : !wave.mask<32>, !wave.simd<i32, 32>
  %packet = wave.pack %zero, %encoded, %zero
      : !wave.simd<i32, 32>, !wave.simd<i32, 32>, !wave.simd<i32, 32>
      -> !wave.simd<vector<3xi32>, 32>
  %broadcast = wave.redistribute %packet,
      <blocks = 1, items = 32, source_block = "block",
       source_item = "item", source_slot = "1">
      : !wave.simd<vector<3xi32>, 32>
      -> !wave.simd<vector<3xi32>, 32>
  %alias = wave.extract %broadcast[2]
      : !wave.simd<vector<3xi32>, 32> -> !wave.simd<i32, 32>
  %recovered = wave.cmpi ne %alias, %zero
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  return %direct, %recovered : !wave.mask<32>, !wave.mask<32>
}

// -----

// CHECK-LABEL: func.func @boolean_packet_alias_unsupported_predicate
// CHECK-COUNT-2: wave.cmpi
func.func @boolean_packet_alias_unsupported_predicate(
    %x: !wave.simd<i32, 32>, %limit: !wave.simd<i32, 32>)
    -> (!wave.mask<32>, !wave.mask<32>) {
  %condition = wave.cmpi slt %x, %limit
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %zero = wave.constant 0 : i32 -> !wave.simd<i32, 32>
  %one = wave.constant 1 : i32 -> !wave.simd<i32, 32>
  %encoded = wave.select %condition, %one, %zero
      : !wave.mask<32>, !wave.simd<i32, 32>
  %packet = wave.pack %zero, %encoded
      : !wave.simd<i32, 32>, !wave.simd<i32, 32>
      -> !wave.simd<vector<2xi32>, 32>
  %alias = wave.extract %packet[1]
      : !wave.simd<vector<2xi32>, 32> -> !wave.simd<i32, 32>
  %unsupported = wave.cmpi ult %alias, %one
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  return %condition, %unsupported : !wave.mask<32>, !wave.mask<32>
}

// -----

// CHECK-LABEL: func.func @boolean_select_nonconstant_arms
// CHECK: wave.cmpi eq
func.func @boolean_select_nonconstant_arms(
    %condition: !wave.mask<32>, %x: !wave.simd<i32, 32>,
    %y: !wave.simd<i32, 32>) -> !wave.mask<32> {
  %zero = wave.constant 0 : i32 -> !wave.simd<i32, 32>
  %selected = wave.select %condition, %x, %y
      : !wave.mask<32>, !wave.simd<i32, 32>
  %packet = wave.pack %zero, %selected
      : !wave.simd<i32, 32>, !wave.simd<i32, 32>
      -> !wave.simd<vector<2xi32>, 32>
  %alias = wave.extract %packet[1]
      : !wave.simd<vector<2xi32>, 32> -> !wave.simd<i32, 32>
  %comparison = wave.cmpi eq %alias, %zero
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  return %comparison : !wave.mask<32>
}

// -----

// CHECK-LABEL: func.func @boolean_alias_type_mismatch
// CHECK: wave.cmpi slt
// CHECK: wave.extract {{.*}}[0]
// CHECK: wave.cmpi ne
func.func @boolean_alias_type_mismatch(
    %x: !wave.simd<i32, 32>, %limit: !wave.simd<i32, 32>)
    -> (!wave.mask<32>, !wave.mask<32>) {
  %condition = wave.cmpi slt %x, %limit
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %zero = wave.constant 0 : i32 -> !wave.simd<i32, 32>
  %one = wave.constant 1 : i32 -> !wave.simd<i32, 32>
  %encoded = wave.select %condition, %one, %zero
      : !wave.mask<32>, !wave.simd<i32, 32>
  %packet = wave.pack %encoded, %zero
      : !wave.simd<i32, 32>, !wave.simd<i32, 32>
      -> !wave.simd<vector<2xi32>, 32>
  %alias = wave.extract %packet[0]
      : !wave.simd<vector<2xi32>, 32> -> !wave.simd<vector<1xi32>, 32>
  %zeroVector = arith.constant dense<0> : vector<1xi32>
  %zeroPacket = wave.splat %zeroVector
      : vector<1xi32> -> !wave.simd<vector<1xi32>, 32>
  %comparison = wave.cmpi ne %alias, %zeroPacket
      : !wave.simd<vector<1xi32>, 32>, !wave.simd<vector<1xi32>, 32>
      -> !wave.mask<32>
  return %condition, %comparison : !wave.mask<32>, !wave.mask<32>
}
