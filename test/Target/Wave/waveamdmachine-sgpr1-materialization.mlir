// RUN: wave-opt --split-input-file --waveamd-to-machine --verify-diagnostics %s | FileCheck %s --check-prefix=SELECT

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// SELECT-LABEL: func.func @scalar_i32_arith_read_first_operands
// SELECT-DAG: %[[X:.*]] = waveamdmachine.arg {index = 0 : i64, pointer = false}
// SELECT: %[[FIRST:.*]] = waveamdmachine.v_readfirstlane_b32
// SELECT: %[[MUL:.*]] = waveamdmachine.s_mul_i32 %[[FIRST]], %[[X]]
// SELECT: %[[SHL:[^,]+]], %{{.*}} = waveamdmachine.s_lshl_b32 %[[MUL]],
// SELECT: %[[XOR:[^,]+]], %{{.*}} = waveamdmachine.s_xor_b32 %[[SHL]],
// SELECT: %[[NEG:[^,]+]], %{{.*}} = waveamdmachine.s_add_i32
// SELECT: %[[SUB:[^,]+]], %{{.*}} = waveamdmachine.s_add_i32 %[[XOR]], %[[NEG]]
// SELECT: waveamdmachine.s_mul_hi_u32 %[[SUB]], %[[X]]
func.func @scalar_i32_arith_read_first_operands(%x: i32)
    attributes {wave.kernel} {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %vx = wave.splat %x : i32 -> !wave.simd<i32, 32>
  %active = wave.cmpi ult %lane, %vx
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %chosen = wave.select %active, %lane, %vx
      : !wave.mask<32>, !wave.simd<i32, 32>
  %first = wave.read_first %chosen : !wave.simd<i32, 32> -> i32
  %prod = wave.binary muli %first, %x : i32, i32 -> i32
  %two = arith.constant 2 : i32
  %shl = wave.binary shli %prod, %two : i32, i32 -> i32
  %seven = arith.constant 7 : i32
  %xor = wave.binary xori %shl, %seven : i32, i32 -> i32
  %diff = wave.binary subi %xor, %x : i32, i32 -> i32
  %hi = wave.binary mulhui %diff, %x : i32, i32 -> i32
  return
}

// SELECT-LABEL: func.func @raw_i24_read_first_offset_uses_sgpr_scale
// SELECT: %[[FIRST:.*]] = waveamdmachine.v_readfirstlane_b32
// SELECT: %[[THREE:.*]] = waveamdmachine.imm 3
// SELECT: waveamdmachine.s_mul_i32 %[[THREE]], %[[FIRST]]
func.func @raw_i24_read_first_offset_uses_sgpr_scale(
    %out: !wave.ptr<#wave.global, i24>, %limit: i32)
    attributes {wave.kernel} {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %vlimit = wave.splat %limit : i32 -> !wave.simd<i32, 32>
  %active = wave.cmpi ult %lane, %vlimit
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %chosen = wave.select %active, %lane, %vlimit
      : !wave.mask<32>, !wave.simd<i32, 32>
  %first = wave.read_first %chosen : !wave.simd<i32, 32> -> i32
  %ptr = wave.ptr_add %out, %first
      : !wave.ptr<#wave.global, i24>, i32 -> !wave.ptr<#wave.global, i24>
  return
}

}
