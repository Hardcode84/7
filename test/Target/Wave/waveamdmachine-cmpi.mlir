// RUN: wave-opt --waveamd-to-machine --verify-diagnostics --split-input-file %s | FileCheck %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// CHECK-LABEL: func.func @i64_cmpi_gfx1100
// CHECK: waveamdmachine.tuple_to_elements
// CHECK: waveamdmachine.v_cmp_lt_u32
// CHECK: waveamdmachine.v_cmp_eq_u32
// CHECK: waveamdmachine.v_cmp_lt_u32
// CHECK: waveamdmachine.s_and_b32
// CHECK: waveamdmachine.s_or_b32
// CHECK: waveamdmachine.v_cmp_lt_i32
// CHECK: waveamdmachine.v_cmp_eq_u32
// CHECK: waveamdmachine.v_cmp_lt_u32
// CHECK: waveamdmachine.s_and_b32
// CHECK: waveamdmachine.s_or_b32
// CHECK: waveamdmachine.v_cmp_eq_u32
// CHECK: waveamdmachine.v_cmp_eq_u32
// CHECK: waveamdmachine.s_and_b32
// CHECK: waveamdmachine.v_cmp_ne_u32
// CHECK: waveamdmachine.v_cmp_ne_u32
// CHECK: waveamdmachine.s_or_b32
func.func @i64_cmpi_gfx1100(%lhs: i64, %rhs: i64) {
  %vlhs = wave.splat %lhs : i64 -> !wave.simd<i64, 32>
  %vrhs = wave.splat %rhs : i64 -> !wave.simd<i64, 32>
  %ult = wave.cmpi ult %vlhs, %vrhs
      : !wave.simd<i64, 32>, !wave.simd<i64, 32> -> !wave.mask<32>
  %slt = wave.cmpi slt %vlhs, %vrhs
      : !wave.simd<i64, 32>, !wave.simd<i64, 32> -> !wave.mask<32>
  %eq = wave.cmpi eq %vlhs, %vrhs
      : !wave.simd<i64, 32>, !wave.simd<i64, 32> -> !wave.mask<32>
  %ne = wave.cmpi ne %vlhs, %vrhs
      : !wave.simd<i64, 32>, !wave.simd<i64, 32> -> !wave.mask<32>
  return
}

// CHECK-LABEL: func.func @i64_reused_constant_materialization
// CHECK: waveamdmachine.s_mov_b64_imm
// CHECK: waveamdmachine.v_cmp_lt_u32
// CHECK: waveamdmachine.s_add_u64
func.func @i64_reused_constant_materialization(%arg: i64) {
  %c = arith.constant 1311768467750121216 : i64
  %cmp_const = wave.splat %c : i64 -> !wave.simd<i64, 32>
  %varg = wave.splat %arg : i64 -> !wave.simd<i64, 32>
  %mask = wave.cmpi ult %cmp_const, %varg
      : !wave.simd<i64, 32>, !wave.simd<i64, 32> -> !wave.mask<32>
  %add_const = wave.splat %c : i64 -> !wave.simd<i64, 32>
  %sum = wave.binary addi %add_const, %varg
      : !wave.simd<i64, 32>, !wave.simd<i64, 32> -> !wave.simd<i64, 32>
  return
}

// CHECK-LABEL: func.func @signed_cmpi_gfx1100
// CHECK: waveamdmachine.v_cmp_lt_i32
// CHECK: waveamdmachine.v_cmp_le_i32
// CHECK: waveamdmachine.v_cmp_gt_i32
// CHECK: waveamdmachine.v_cmp_ge_i32
func.func @signed_cmpi_gfx1100(%limit: i32) {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %vlimit = wave.splat %limit : i32 -> !wave.simd<i32, 32>
  %slt = wave.cmpi slt %lane, %vlimit
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %sle = wave.cmpi sle %lane, %vlimit
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %sgt = wave.cmpi sgt %lane, %vlimit
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %sge = wave.cmpi sge %lane, %vlimit
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx803"} {

// CHECK-LABEL: func.func @i64_cmpi_gfx803
// CHECK: waveamdmachine.tuple_to_elements
// CHECK: waveamdmachine.v_mov_b32_tuple
// CHECK: waveamdmachine.v_cmp_gt_u32_vcc
// CHECK: waveamdmachine.v_cmp_eq_u32_vcc
// CHECK: waveamdmachine.v_cmp_ge_u32_vcc
// CHECK: waveamdmachine.tuple_to_elements
// CHECK: waveamdmachine.s_and_b32
// CHECK: waveamdmachine.s_or_b32
// CHECK: waveamdmachine.tuple_from_elements
// CHECK: waveamdmachine.v_cmp_gt_i32_vcc
// CHECK: waveamdmachine.v_cmp_eq_u32_vcc
// CHECK: waveamdmachine.v_cmp_ge_u32_vcc
// CHECK: waveamdmachine.tuple_to_elements
// CHECK: waveamdmachine.s_and_b32
// CHECK: waveamdmachine.s_or_b32
// CHECK: waveamdmachine.tuple_from_elements
func.func @i64_cmpi_gfx803(%lhs: i64, %rhs: i64) {
  %vlhs = wave.splat %lhs : i64 -> !wave.simd<i64, 64>
  %vrhs = wave.splat %rhs : i64 -> !wave.simd<i64, 64>
  %uge = wave.cmpi uge %vlhs, %vrhs
      : !wave.simd<i64, 64>, !wave.simd<i64, 64> -> !wave.mask<64>
  %sge = wave.cmpi sge %vlhs, %vrhs
      : !wave.simd<i64, 64>, !wave.simd<i64, 64> -> !wave.mask<64>
  return
}

// CHECK-LABEL: func.func @signed_cmpi_gfx803
// CHECK: waveamdmachine.v_cmp_lt_i32_vcc
// CHECK: waveamdmachine.v_cmp_le_i32_vcc
// CHECK: waveamdmachine.v_cmp_gt_i32_vcc
// CHECK: waveamdmachine.v_cmp_ge_i32_vcc
func.func @signed_cmpi_gfx803(%limit: i32) {
  %lane = wave.lane_id : !wave.simd<i32, 64>
  %vlimit = wave.splat %limit : i32 -> !wave.simd<i32, 64>
  %slt = wave.cmpi slt %lane, %vlimit
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
  %sle = wave.cmpi sle %lane, %vlimit
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
  %sgt = wave.cmpi sgt %lane, %vlimit
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
  %sge = wave.cmpi sge %lane, %vlimit
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
  return
}

}
