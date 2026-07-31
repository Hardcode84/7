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
