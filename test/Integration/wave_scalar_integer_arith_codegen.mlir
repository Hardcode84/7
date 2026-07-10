// RUN: wave-opt --wave-strength-reduce-modulo --wave-expand-integer-div-rem \
// RUN:   --waveamd-to-machine %s \
// RUN:   | wave-translate --wave-to-amdgpu-asm - \
// RUN:   | FileCheck %s --check-prefix=ASM
// RUN: wave-opt --wave-strength-reduce-modulo --wave-expand-integer-div-rem \
// RUN:   --waveamd-to-machine %s \
// RUN:   | wave-translate --wave-to-amdgpu-asm - \
// RUN:   | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx1100 -filetype=obj -o /dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// ASM-LABEL: scalar_integer_arith_codegen:
// ASM: s_xor_b32
// ASM: s_lshr_b32
// ASM: s_and_b32
// ASM: s_add_i32
// ASM: s_cmp_lt_i32
// ASM-NEXT: s_cselect_b32
// ASM: global_store_b32
func.func @scalar_integer_arith_codegen(%out: !wave.ptr<#wave.global, i32>,
                                        %x: i32, %y: i32)
    attributes {wave.kernel} {
  %two = arith.constant 2 : i32
  %four = arith.constant 4 : i32
  %diff = wave.binary subi %x, %y : i32, i32 -> i32
  %half = wave.binary divui %diff, %two : i32, i32 -> i32
  %tail = wave.binary remui %diff, %four : i32, i32 -> i32
  %cond = arith.cmpi slt, %half, %tail : i32
  %clobber = wave.binary addi %half, %tail : i32, i32 -> i32
  %pick = wave.select %cond, %clobber, %tail : i32
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %ptrs = wave.ptr_add %out, %lane
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %v = wave.splat %pick : i32 -> !wave.simd<i32, 32>
  %tok = wave.store %v -> %ptrs
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.global, i32>, 32>)
      -> !wave.mem.token
  return
}

// ASM-LABEL: scalar_i32_dynamic_pow2_divsi_codegen:
// ASM: s_ctz_i32_b32
// ASM: s_lshr_b32
// ASM: global_store_b32
func.func @scalar_i32_dynamic_pow2_divsi_codegen(
    %out: !wave.ptr<#wave.global, i32>, %x: i32, %d: i32)
    attributes {wave.kernel} {
  %nonneg = wave.assume %x as "x" [#wave.pred<"x >= 0">] : i32
  %pow2 = wave.assume %d as "d" [#wave.pred<"d & (d - 1) == 0">,
                                  #wave.pred<"d > 0">] : i32
  %quot = wave.binary divsi %nonneg, %pow2 : i32, i32 -> i32
  %v = wave.splat %quot : i32 -> !wave.simd<i32, 32>
  %tok = wave.store %v -> %out
      : (!wave.simd<i32, 32>, !wave.ptr<#wave.global, i32>)
      -> !wave.mem.token
  return
}

// ASM-LABEL: scalar_i32_const_pow2_divsi_codegen:
// ASM: s_cmp_lt_i32
// ASM: s_cselect_b32
// ASM: s_add_i32
// ASM: s_ashr_i32
// ASM: global_store_b32
func.func @scalar_i32_const_pow2_divsi_codegen(
    %out: !wave.ptr<#wave.global, i32>, %x: i32)
    attributes {wave.kernel} {
  %thirty_two = arith.constant 32 : i32
  %quot = wave.binary divsi %x, %thirty_two : i32, i32 -> i32
  %v = wave.splat %quot : i32 -> !wave.simd<i32, 32>
  %tok = wave.store %v -> %out
      : (!wave.simd<i32, 32>, !wave.ptr<#wave.global, i32>)
      -> !wave.mem.token
  return
}

// ASM-LABEL: scalar_i32_const_signed_rem3_codegen:
// ASM: s_mul_hi_u32
// ASM: global_store_b32
func.func @scalar_i32_const_signed_rem3_codegen(
    %out: !wave.ptr<#wave.global, i32>, %x: i32)
    attributes {wave.kernel} {
  %three = arith.constant 3 : i32
  %rem = wave.binary remsi %x, %three : i32, i32 -> i32
  %v = wave.splat %rem : i32 -> !wave.simd<i32, 32>
  %tok = wave.store %v -> %out
      : (!wave.simd<i32, 32>, !wave.ptr<#wave.global, i32>)
      -> !wave.mem.token
  return
}

// ASM-LABEL: simd_i32_const_signed_rem3_codegen:
// ASM: v_mul_hi_u32
// ASM: global_store_b32
func.func @simd_i32_const_signed_rem3_codegen(
    %out: !wave.ptr<#wave.global, i32>, %bias: i32)
    attributes {wave.kernel} {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %vbias = wave.splat %bias : i32 -> !wave.simd<i32, 32>
  %numerator = wave.binary subi %lane, %vbias
      : !wave.simd<i32, 32>, !wave.simd<i32, 32>
      -> !wave.simd<i32, 32>
  %minus_three = arith.constant -3 : i32
  %divisor = wave.splat %minus_three : i32 -> !wave.simd<i32, 32>
  %rem = wave.binary remsi %numerator, %divisor
      : !wave.simd<i32, 32>, !wave.simd<i32, 32>
      -> !wave.simd<i32, 32>
  %tok = wave.store %rem -> %out
      : (!wave.simd<i32, 32>, !wave.ptr<#wave.global, i32>)
      -> !wave.mem.token
  return
}

// ASM-LABEL: scalar_i64_div_rem_codegen:
// ASM: s_lshr_b64
// ASM: s_and_b32
// ASM: s_cmp_lt_u32
// ASM: s_cmp_eq_u32
// ASM: s_cmp_lt_u32
// ASM: s_or_b32
// ASM: global_store_b32
func.func @scalar_i64_div_rem_codegen(%out: !wave.ptr<#wave.global, i32>,
                                      %wide: i64)
    attributes {wave.kernel} {
  %two64 = arith.constant 2 : i64
  %eight64 = arith.constant 8 : i64
  %wide_half = wave.binary divui %wide, %two64 : i64, i64 -> i64
  %wide_tail = wave.binary remui %wide, %eight64 : i64, i64 -> i64
  %vhalf = wave.splat %wide_half : i64 -> !wave.simd<i64, 32>
  %vtail = wave.splat %wide_tail : i64 -> !wave.simd<i64, 32>
  %mask = wave.cmpi ult %vhalf, %vtail
      : !wave.simd<i64, 32>, !wave.simd<i64, 32> -> !wave.mask<32>
  %bits = wave.ballot %mask : !wave.mask<32> -> i32
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %ptrs = wave.ptr_add %out, %lane
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %v = wave.splat %bits : i32 -> !wave.simd<i32, 32>
  %tok = wave.store %v -> %ptrs
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.global, i32>, 32>)
      -> !wave.mem.token
  return
}

// ASM-LABEL: scalar_i64_dynamic_pow2_divsi_codegen:
// ASM: s_ctz_i32_b64
// ASM: s_lshr_b64
// ASM: global_store_b32
func.func @scalar_i64_dynamic_pow2_divsi_codegen(
    %out: !wave.ptr<#wave.global, i32>, %x: i64, %d: i64)
    attributes {wave.kernel} {
  %nonneg = wave.assume %x as "x" [#wave.pred<"x >= 0">] : i64
  %pow2 = wave.assume %d as "d" [#wave.pred<"d & (d - 1) == 0">,
                                  #wave.pred<"d > 0">] : i64
  %quot = wave.binary divsi %nonneg, %pow2 : i64, i64 -> i64
  %zero = arith.constant 0 : i64
  %vquot = wave.splat %quot : i64 -> !wave.simd<i64, 32>
  %vzero = wave.splat %zero : i64 -> !wave.simd<i64, 32>
  %mask = wave.cmpi ne %vquot, %vzero
      : !wave.simd<i64, 32>, !wave.simd<i64, 32> -> !wave.mask<32>
  %value = wave.ballot %mask : !wave.mask<32> -> i32
  %v = wave.splat %value : i32 -> !wave.simd<i32, 32>
  %tok = wave.store %v -> %out
      : (!wave.simd<i32, 32>, !wave.ptr<#wave.global, i32>)
      -> !wave.mem.token
  return
}

// ASM-LABEL: scalar_i32_loop_rem5_recurrence_codegen:
// ASM: .Lscalar_i32_loop_rem5_recurrence_codegen.loop_head_0:
// ASM-NOT: s_mul_i32
// ASM: s_cmp_ge_u32
// ASM-NEXT: s_cselect_b32
// ASM-NOT: s_mul_i32
// ASM: s_cmp_ge_u32
// ASM-NEXT: s_cselect_b32
// ASM-NOT: s_mul_i32
// ASM: s_cbranch_scc1 .Lscalar_i32_loop_rem5_recurrence_codegen.loop_head_0
func.func @scalar_i32_loop_rem5_recurrence_codegen(
    %out: !wave.ptr<#wave.global, i32>, %trip: i32)
    attributes {wave.kernel} {
  %c0 = arith.constant 0 : i32
  %c1 = arith.constant 1 : i32
  %c2 = arith.constant 2 : i32
  %c5 = arith.constant 5 : i32
  %c7 = arith.constant 7 : i32
  %sum = scf.for unsigned %i = %c7 to %trip step %c1
      iter_args(%acc = %c0) -> i32 : i32 {
    %base = wave.binary remui %i, %c5 : i32, i32 -> i32
    %shifted = wave.binary addi %i, %c2 overflow<nuw> : i32, i32 -> i32
    %derived = wave.binary remui %shifted, %c5 : i32, i32 -> i32
    %next = wave.binary addi %acc, %derived : i32, i32 -> i32
    scf.yield %next : i32
  }
  %value = wave.splat %sum : i32 -> !wave.simd<i32, 32>
  %tok = wave.store %value -> %out
      : (!wave.simd<i32, 32>, !wave.ptr<#wave.global, i32>)
      -> !wave.mem.token
  return
}

}
