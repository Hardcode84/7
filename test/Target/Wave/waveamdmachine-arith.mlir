// RUN: wave-opt --split-input-file --wave-expand-integer-div-rem --waveamd-to-machine --verify-diagnostics %s | FileCheck %s --check-prefix=SELECT

// Width-independent integer arith ops lower per-target based on
// operand uniformity. Uniform-uniform i32 goes to the scalar
// instruction set; any SIMD operand routes through the vector ALU
// with the usual SGPR-in-vsrc0 shuffling for VOP2 ops. i64 add gets
// its own scalar / vector ops (`s_add_u64` is a carry-chain pair,
// `v_add_u64` likewise via vcc_lo on wave32).

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// Uniform i32 add/mul/shl: s_add_i32 / s_mul_i32 / s_lshl_b32.
// SELECT-LABEL: func.func @uniform_i32_arith
// SELECT: waveamdmachine.s_workgroup_id_x
// SELECT: waveamdmachine.s_add_i32 {{.*}} -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
// SELECT: waveamdmachine.s_mul_i32 {{.*}} -> !waveamdmachine.reg<sgpr, 1>
// SELECT: waveamdmachine.s_lshl_b32 {{.*}} -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
// SELECT-NOT: waveamdmachine.v_add_u32
// SELECT-NOT: waveamdmachine.v_mul_lo_u32
func.func @uniform_i32_arith(%out: !wave.ptr<#wave.global, i32>) attributes {wave.kernel} {
  %wgid = wave.workgroup_id 0
  %four = arith.constant 4 : i32
  %sum = wave.binary addi %wgid, %four : i32, i32 -> i32
  %scaled = wave.binary muli %sum, %wgid : i32, i32 -> i32
  %two = arith.constant 2 : i32
  %shifted = wave.binary shli %scaled, %two : i32, i32 -> i32
  // Make the shifted result live so it survives DCE.
  %off = wave.index_expr <"S"> ["S"] (%shifted) : (i32) -> index
  %ptr = wave.ptr_add %out, %off : !wave.ptr<#wave.global, i32>, index -> !wave.ptr<#wave.global, i32>
  return
}

// SELECT-LABEL: func.func @simd_i32_muli_uniform_splats
// SELECT: waveamdmachine.s_mul_i32
// SELECT-NOT: waveamdmachine.v_mul_lo_u32
func.func @simd_i32_muli_uniform_splats(%x: i32, %y: i32)
    attributes {wave.kernel} {
  %vx = wave.splat %x : i32 -> !wave.simd<i32, 32>
  %vy = wave.splat %y : i32 -> !wave.simd<i32, 32>
  %prod = wave.binary muli %vx, %vy
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  return
}

// SELECT-LABEL: func.func @simd_i32_uniform_splats_scalarize
// SELECT-NOT: waveamdmachine.v_add_u32
// SELECT: waveamdmachine.s_add_i32
// SELECT-NOT: waveamdmachine.v_mul_hi_u32
// SELECT: waveamdmachine.s_mul_hi_u32
// SELECT-NOT: waveamdmachine.v_lshlrev_b32
// SELECT: waveamdmachine.s_lshl_b32
// SELECT-NOT: waveamdmachine.v_lshrrev_b32
// SELECT: waveamdmachine.s_lshr_b32
// SELECT-NOT: waveamdmachine.v_and_b32
// SELECT: waveamdmachine.s_and_b32
// SELECT-NOT: waveamdmachine.v_or_b32
// SELECT: waveamdmachine.s_or_b32
// SELECT-NOT: waveamdmachine.v_xor_b32
// SELECT: waveamdmachine.s_xor_b32
func.func @simd_i32_uniform_splats_scalarize(%x: i32, %y: i32)
    attributes {wave.kernel} {
  %vx = wave.splat %x : i32 -> !wave.simd<i32, 32>
  %vy = wave.splat %y : i32 -> !wave.simd<i32, 32>
  %sum = wave.binary addi %vx, %vy
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %hi = wave.binary mulhui %vx, %vy
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %shl = wave.binary shli %vx, %vy
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %shr = wave.binary shrui %vx, %vy
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %and = wave.binary andi %vx, %vy
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %or = wave.binary ori %vx, %vy
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %xor = wave.binary xori %vx, %vy
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  return
}

// SELECT-LABEL: func.func @uniform_i32_add_immediates
// SELECT: waveamdmachine.imm 3
// SELECT-NOT: waveamdmachine.s_add_i32
func.func @uniform_i32_add_immediates(%out: !wave.ptr<#wave.global, i32>) attributes {wave.kernel} {
  %one = arith.constant 1 : i32
  %two = arith.constant 2 : i32
  %sum = wave.binary addi %one, %two : i32, i32 -> i32
  %off = wave.index_expr <"S"> ["S"] (%sum) : (i32) -> index
  %ptr = wave.ptr_add %out, %off : !wave.ptr<#wave.global, i32>, index -> !wave.ptr<#wave.global, i32>
  return
}

// SELECT-LABEL: func.func @uniform_i32_add_lhs_immediate
// SELECT: %[[WGID:.*]] = waveamdmachine.s_workgroup_id_x
// SELECT: %[[FOUR:.*]] = waveamdmachine.imm 4
// SELECT: waveamdmachine.s_add_i32 %[[WGID]], %[[FOUR]]
func.func @uniform_i32_add_lhs_immediate(%out: !wave.ptr<#wave.global, i32>) attributes {wave.kernel} {
  %wgid = wave.workgroup_id 0
  %four = arith.constant 4 : i32
  %sum = wave.binary addi %four, %wgid : i32, i32 -> i32
  %off = wave.index_expr <"S"> ["S"] (%sum) : (i32) -> index
  %ptr = wave.ptr_add %out, %off : !wave.ptr<#wave.global, i32>, index -> !wave.ptr<#wave.global, i32>
  return
}

// SELECT-LABEL: func.func @uniform_i32_sub_div_rem
// SELECT: waveamdmachine.s_xor_b32
// SELECT: waveamdmachine.s_add_i32
// SELECT: waveamdmachine.s_lshr_b32
// SELECT: waveamdmachine.s_and_b32
func.func @uniform_i32_sub_div_rem(%out: !wave.ptr<#wave.global, i32>) attributes {wave.kernel} {
  %x = wave.workgroup_id 0
  %y = wave.workgroup_id 1
  %two = arith.constant 2 : i32
  %four = arith.constant 4 : i32
  %diff = wave.binary subi %x, %y : i32, i32 -> i32
  %half = wave.binary divui %diff, %two : i32, i32 -> i32
  %tail = wave.binary remui %diff, %four : i32, i32 -> i32
  %sum = wave.binary addi %half, %tail : i32, i32 -> i32
  %off = wave.index_expr <"S"> ["S"] (%sum) : (i32) -> index
  %ptr = wave.ptr_add %out, %off : !wave.ptr<#wave.global, i32>, index -> !wave.ptr<#wave.global, i32>
  return
}

// SELECT-LABEL: func.func @uniform_i32_signed_div_range
// SELECT: waveamdmachine.s_cmp_lt_i32
// SELECT: waveamdmachine.s_cselect_b32
// SELECT: waveamdmachine.s_lshr_b32
func.func @uniform_i32_signed_div_range(%x: i32) attributes {wave.kernel} {
  %a = wave.assume %x as "x" [#wave.pred<"x >= 0">, #wave.pred<"x <= 1024">] : i32
  %two = arith.constant 2 : i32
  %half = wave.binary divsi %a, %two : i32, i32 -> i32
  return
}

// SELECT-LABEL: func.func @uniform_i32_signed_div_lower_only_range
// SELECT: waveamdmachine.s_cmp_lt_i32
// SELECT: waveamdmachine.s_cselect_b32
// SELECT: waveamdmachine.s_lshr_b32
func.func @uniform_i32_signed_div_lower_only_range(%x: i32) attributes {wave.kernel} {
  %nonneg = wave.assume %x as "x" [#wave.pred<"x >= 0">] : i32
  %thirty_two = arith.constant 32 : i32
  %quot = wave.binary divsi %nonneg, %thirty_two : i32, i32 -> i32
  return
}

// SELECT-LABEL: func.func @uniform_i32_signed_div_chained_range
// SELECT: waveamdmachine.s_cmp_lt_i32
// SELECT: waveamdmachine.s_cselect_b32
// SELECT: waveamdmachine.s_lshr_b32
func.func @uniform_i32_signed_div_chained_range(%x: i32) attributes {wave.kernel} {
  %lo = wave.assume %x as "x" [#wave.pred<"x >= 0">] : i32
  %bounded = wave.assume %lo as "x" [#wave.pred<"-2147483647 + x <= 0">] : i32
  %thirty_two = arith.constant 32 : i32
  %quot = wave.binary divsi %bounded, %thirty_two : i32, i32 -> i32
  return
}

// SELECT-LABEL: func.func @uniform_i32_signed_div_dynamic_pow2
// SELECT-DAG: %[[X:.*]] = waveamdmachine.arg
// SELECT-DAG: %[[D:.*]] = waveamdmachine.arg
// SELECT: waveamdmachine.s_ff1_i32_b32 %[[D]]
// SELECT: waveamdmachine.s_lshr_b32 %[[X]]
func.func @uniform_i32_signed_div_dynamic_pow2(%x: i32, %d: i32) attributes {wave.kernel} {
  %nonneg = wave.assume %x as "x" [#wave.pred<"x >= 0">] : i32
  %pow2 = wave.assume %d as "d" [#wave.pred<"d & (d - 1) == 0">, #wave.pred<"d > 0">] : i32
  %quot = wave.binary divsi %nonneg, %pow2 : i32, i32 -> i32
  return
}

// SELECT-LABEL: func.func @simd_i32_signed_div_splat_dynamic_pow2
// SELECT-DAG: %[[D:.*]] = waveamdmachine.arg
// SELECT-DAG: %[[LANE:.*]] = waveamdmachine.v_mbcnt_lo
// SELECT: %[[SHIFT:.*]] = waveamdmachine.s_ff1_i32_b32 %[[D]]
// SELECT: waveamdmachine.v_lshrrev_b32 %[[LANE]], %[[SHIFT]]
func.func @simd_i32_signed_div_splat_dynamic_pow2(%d: i32) attributes {wave.kernel} {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %pow2 = wave.assume %d as "d" [#wave.pred<"d & (d - 1) == 0">, #wave.pred<"d > 0">] : i32
  %splat = wave.splat %pow2 : i32 -> !wave.simd<i32, 32>
  %quot = wave.binary divsi %lane, %splat : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  return
}

// SELECT-LABEL: func.func @uniform_i64_signed_div_dynamic_pow2
// SELECT-DAG: %[[X:.*]] = waveamdmachine.arg
// SELECT-DAG: %[[D:.*]] = waveamdmachine.arg
// SELECT: %[[SHIFT:.*]] = waveamdmachine.s_ff1_i32_b64 %[[D]]
// SELECT: waveamdmachine.s_lshr_b64 %[[X]], %[[SHIFT]]
func.func @uniform_i64_signed_div_dynamic_pow2(%x: i64, %d: i64) attributes {wave.kernel} {
  %nonneg = wave.assume %x as "x" [#wave.pred<"x >= 0">] : i64
  %pow2 = wave.assume %d as "d" [#wave.pred<"d & (d - 1) == 0">, #wave.pred<"d > 0">] : i64
  %quot = wave.binary divsi %nonneg, %pow2 : i64, i64 -> i64
  return
}

// SELECT-LABEL: func.func @uniform_index_signed_div_dynamic_pow2_wide_index_expr
// SELECT-NOT: waveamdmachine.v_mov_b32_tuple
// SELECT: %[[SHIFT:.*]] = waveamdmachine.s_ff1_i32_b64
// SELECT: waveamdmachine.s_lshr_b64 {{.*}}, %[[SHIFT]]
func.func @uniform_index_signed_div_dynamic_pow2_wide_index_expr(%x: i32, %d: i32) attributes {wave.kernel} {
  %num = wave.index_expr <"x"> ["x"](%x) : (i32) -> index
  %nonneg = wave.assume %num as "x" [#wave.pred<"x >= 0">] : index
  %divisor = wave.index_expr <"d"> ["d"](%d) : (i32) -> index
  %pow2 = wave.assume %divisor as "d" [#wave.pred<"d & (d - 1) == 0">, #wave.pred<"d > 0">] : index
  %quot = wave.binary divsi %nonneg, %pow2 : index, index -> index
  return
}

// SELECT-LABEL: func.func @uniform_index_product_signed_div_bounded_range
// SELECT-NOT: waveamdmachine.s_mul_i32
// SELECT: waveamdmachine.s_mul_u64
// SELECT: waveamdmachine.s_lshr_b64
// SELECT: waveamdmachine.s_and_b32
func.func @uniform_index_product_signed_div_bounded_range(%m: index, %n: index) attributes {wave.kernel} {
  %a = wave.assume %m as "x" [#wave.pred<"x >= 0">, #wave.pred<"x <= 4000000">] : index
  %b = wave.assume %n as "x" [#wave.pred<"x >= 0">, #wave.pred<"x <= 4000000">] : index
  %prod = wave.index_expr <"a*b"> ["a", "b"](%a, %b) : (index, index) -> index
  %thirty_two = arith.constant 32 : index
  %quot = wave.binary divsi %prod, %thirty_two : index, index -> index
  return
}

// SELECT-LABEL: func.func @uniform_index_dynamic_div_bounded_i32_path
// SELECT-NOT: waveamdmachine.s_mul_u64
// SELECT: waveamdmachine.v_rcp_iflag_f32
// SELECT: waveamdmachine.s_mul_hi_u32
// SELECT-NOT: waveamdmachine.s_mul_u64
func.func @uniform_index_dynamic_div_bounded_i32_path(%x: index, %d: index)
    attributes {wave.kernel} {
  %bx = wave.assume %x as "x" [#wave.pred<"x >= 0">,
                                #wave.pred<"x <= 1024">] : index
  %bd = wave.assume %d as "d" [#wave.pred<"d >= 1">,
                                #wave.pred<"d <= 1024">] : index
  %quot = wave.binary divui %bx, %bd : index, index -> index
  return
}

// SELECT-LABEL: func.func @simd_i64_dynamic_rem_bounded_i32_path
// SELECT-NOT: waveamdmachine.v_lshrrev_b64
// SELECT: waveamdmachine.v_rcp_iflag_f32
// SELECT: waveamdmachine.v_mul_hi_u32
// SELECT: waveamdmachine.tuple_from_elements
// SELECT-NOT: waveamdmachine.v_lshrrev_b64
func.func @simd_i64_dynamic_rem_bounded_i32_path(
    %x: !wave.simd<i64, 32>, %d: !wave.simd<i64, 32>)
    attributes {wave.kernel} {
  %bx = wave.assume %x as "x" [#wave.pred<"x >= 0">,
                                #wave.pred<"x <= 1024">]
      : !wave.simd<i64, 32>
  %bd = wave.assume %d as "d" [#wave.pred<"d >= 1">,
                                #wave.pred<"d <= 1024">]
      : !wave.simd<i64, 32>
  %rem = wave.binary remui %bx, %bd
      : !wave.simd<i64, 32>, !wave.simd<i64, 32> -> !wave.simd<i64, 32>
  return
}

// SELECT-LABEL: func.func @uniform_index_expr_i32_sign_ext
// SELECT: %[[X:.*]] = waveamdmachine.arg
// SELECT: %[[NEG:.*]] = waveamdmachine.s_cmp_lt_i32 %[[X]],
// SELECT: %[[HI:.*]] = waveamdmachine.s_cselect_b32 %[[NEG]],
// SELECT: waveamdmachine.tuple_from_elements %[[X]], %[[HI]]
func.func @uniform_index_expr_i32_sign_ext(%x: i32) -> index {
  %idx = wave.index_expr <"x"> ["x"](%x) : (i32) -> index
  return %idx : index
}

// SELECT-LABEL: func.func @uniform_index_expr_i32_nonnegative_zero_ext
// SELECT-NOT: waveamdmachine.s_cmp_lt_i32
// SELECT: waveamdmachine.tuple_from_elements
// SELECT-NOT: waveamdmachine.s_cmp_lt_i32
func.func @uniform_index_expr_i32_nonnegative_zero_ext(%x: i32) -> index {
  %nonneg = wave.assume %x as "x" [#wave.pred<"x >= 0">] : i32
  %idx = wave.index_expr <"x"> ["x"](%nonneg) : (i32) -> index
  return %idx : index
}

// SELECT-LABEL: func.func @uniform_index_expr_square_stays_sgpr
// SELECT-NOT: waveamdmachine.v_mul_lo_u32
// SELECT: waveamdmachine.s_mul_i32
// SELECT-NOT: waveamdmachine.v_mul_lo_u32
func.func @uniform_index_expr_square_stays_sgpr(%x: i32) -> index {
  %bounded = wave.assume %x as "x" [#wave.pred<"x >= 0">,
                                     #wave.pred<"x <= 1024">] : i32
  %idx = wave.index_expr <"x*x"> ["x"](%bounded) : (i32) -> index
  return %idx : index
}

// SELECT-LABEL: func.func @uniform_index_expr_ceil_stays_sgpr
// SELECT-NOT: waveamdmachine.v_add_u32
// SELECT: waveamdmachine.s_add_i32
// SELECT: waveamdmachine.s_lshr_b32
// SELECT-NOT: waveamdmachine.v_add_u32
func.func @uniform_index_expr_ceil_stays_sgpr(%x: i32) -> index {
  %nonneg = wave.assume %x as "x" [#wave.pred<"x >= 0">] : i32
  %idx = wave.index_expr <"ceiling(1/2*x)"> ["x"](%nonneg)
      : (i32) -> index
  return %idx : index
}

// SELECT-LABEL: func.func @simd_index_expr_i32_sign_ext_read_first
// SELECT: waveamdmachine.v_cmp_lt_i32
// SELECT: waveamdmachine.v_cndmask_b32_tuple
// SELECT: waveamdmachine.tuple_from_elements
// SELECT: waveamdmachine.v_readfirstlane_b32
// SELECT: waveamdmachine.v_readfirstlane_b32
func.func @simd_index_expr_i32_sign_ext_read_first(%x: !wave.simd<i32, 32>)
    -> index {
  %idx = wave.index_expr <"x"> ["x"](%x)
      : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
  %first = wave.read_first %idx : !wave.simd<index, 32> -> index
  return %first : index
}

// SELECT-LABEL: func.func @uniform_i32_unsigned_high_bit_div_rem
// SELECT: waveamdmachine.imm 31
// SELECT: waveamdmachine.s_lshr_b32
// SELECT: waveamdmachine.imm 2147483647
// SELECT: waveamdmachine.s_and_b32
func.func @uniform_i32_unsigned_high_bit_div_rem(%out: !wave.ptr<#wave.global, i32>) attributes {wave.kernel} {
  %x = wave.workgroup_id 0
  %high = arith.constant -2147483648 : i32
  %quot = wave.binary divui %x, %high : i32, i32 -> i32
  %rem = wave.binary remui %x, %high : i32, i32 -> i32
  %sum = wave.binary addi %quot, %rem : i32, i32 -> i32
  %off = wave.index_expr <"S"> ["S"] (%sum) : (i32) -> index
  %ptr = wave.ptr_add %out, %off : !wave.ptr<#wave.global, i32>, index -> !wave.ptr<#wave.global, i32>
  return
}

// SELECT-LABEL: func.func @simd_i32_sub_div_rem
// SELECT: waveamdmachine.v_xor_b32
// SELECT: waveamdmachine.v_add_u32
// SELECT: waveamdmachine.v_lshrrev_b32
// SELECT: waveamdmachine.v_and_b32
func.func @simd_i32_sub_div_rem(%out: !wave.ptr<#wave.global, i32>) attributes {wave.kernel} {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %two = arith.constant 2 : i32
  %four = arith.constant 4 : i32
  %v2 = wave.splat %two : i32 -> !wave.simd<i32, 32>
  %v4 = wave.splat %four : i32 -> !wave.simd<i32, 32>
  %diff = wave.binary subi %lane, %v4 : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %half = wave.binary divui %diff, %v2 : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %tail = wave.binary remui %diff, %v4 : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %sum = wave.binary addi %half, %tail : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %ptrs = wave.ptr_add %out, %sum : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32> -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %zero = arith.constant 0 : i32
  %v = wave.splat %zero : i32 -> !wave.simd<i32, 32>
  %tok = wave.store %v -> %ptrs : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.global, i32>, 32>) -> !wave.mem.token
  return
}

// Mixed uniform/SIMD i32 add: SIMD operand routes through v_add_u32
// with the usual SGPR-in-vsrc0 shuffle.
// SELECT-LABEL: func.func @mixed_i32_addi
// SELECT: %[[LANE:.*]] = waveamdmachine.v_mbcnt_lo
// SELECT: %[[WGID:.*]] = waveamdmachine.s_workgroup_id_x
// SELECT: %[[ADD:.*]] = waveamdmachine.v_add_u32 %[[WGID]], %[[LANE]]
func.func @mixed_i32_addi(%out: !wave.ptr<#wave.global, i32>) attributes {wave.kernel} {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %wgid = wave.workgroup_id 0
  %off = wave.binary addi %wgid, %lane : i32, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %ptrs = wave.ptr_add %out, %off : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32> -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %c0 = arith.constant 0 : i32
  %v = wave.splat %c0 : i32 -> !wave.simd<i32, 32>
  %tok = wave.store %v -> %ptrs : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.global, i32>, 32>) -> !wave.mem.token
  return
}

// Uniform i64 add: i64 constants land as `s_mov_b64_imm` and the add
// becomes `s_add_u64`, which the asm printer later expands into the
// `s_add_u32` / `s_addc_u32` carry-chain pair.
// SELECT-LABEL: func.func @uniform_i64_add
// SELECT: waveamdmachine.s_mov_b64_imm 100
// SELECT: waveamdmachine.s_mov_b64_imm 200
// SELECT: waveamdmachine.s_add_u64 {{.*}} : (!waveamdmachine.reg<sgpr, 2>, !waveamdmachine.reg<sgpr, 2>) -> (!waveamdmachine.reg<sgpr, 2>, !waveamdmachine.reg<scc, 1>)
func.func @uniform_i64_add() attributes {wave.kernel} {
  %a = arith.constant 100 : i64
  %b = arith.constant 200 : i64
  %sum = wave.binary addi %a, %b : i64, i64 -> i64
  return
}

// SIMD i64 add. Operand widths come from the function-arg materializer
// once it sees a `!wave.simd<i64, W>` type; this kernel is unreachable
// through the ABI pass today (it rejects width-2 non-pointer args), so
// we exercise only the selection pass here.
// SELECT-LABEL: func.func @simd_i64_add
// SELECT: waveamdmachine.v_add_u64 {{.*}} : (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vgpr, 2>) -> (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vcc, 1>)
func.func @simd_i64_add(%a: !wave.simd<i64, 32>, %b: !wave.simd<i64, 32>) attributes {wave.kernel} {
  %sum = wave.binary addi %a, %b : !wave.simd<i64, 32>, !wave.simd<i64, 32> -> !wave.simd<i64, 32>
  return
}

// Uniform i64 multiply: gfx11 has no native u64 mul, so the lowering
// emits `s_mul_u64` with a scratch SGPR for cross-product temporaries.
// The asm printer later expands that single op into the 4-mul + 2-add
// sequence (s_mul_i32, s_mul_hi_u32, ...).
// SELECT-LABEL: func.func @uniform_i64_mul
// SELECT: waveamdmachine.s_mul_u64 {{.*}} : (!waveamdmachine.reg<sgpr, 2>, !waveamdmachine.reg<sgpr, 2>) -> (!waveamdmachine.reg<sgpr, 2>, !waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
func.func @uniform_i64_mul() attributes {wave.kernel} {
  %a = arith.constant 5 : i64
  %b = arith.constant 7 : i64
  %p = wave.binary muli %a, %b : i64, i64 -> i64
  return
}

// SIMD-i64 multiply: same shape on the vector side, scratch is a
// width-1 VGPR.
// SELECT-LABEL: func.func @simd_i64_mul
// SELECT: waveamdmachine.v_mul_u64 {{.*}} : (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vgpr, 2>) -> (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vgpr, 1>)
func.func @simd_i64_mul(%a: !wave.simd<i64, 32>, %b: !wave.simd<i64, 32>) attributes {wave.kernel} {
  %p = wave.binary muli %a, %b : !wave.simd<i64, 32>, !wave.simd<i64, 32> -> !wave.simd<i64, 32>
  return
}

// Uniform i64 shift: single-instruction s_lshl_b64 with a 32-bit count.
// SELECT-LABEL: func.func @uniform_i64_shl
// SELECT: waveamdmachine.s_lshl_b64 {{.*}} : (!waveamdmachine.reg<sgpr, 2>, !waveamdmachine.imm) -> (!waveamdmachine.reg<sgpr, 2>, !waveamdmachine.reg<scc, 1>)
func.func @uniform_i64_shl() attributes {wave.kernel} {
  %a = arith.constant 5 : i64
  %b = arith.constant 3 : i64
  %s = wave.binary shli %a, %b : i64, i64 -> i64
  return
}

// SIMD i64 shift: single-instruction v_lshlrev_b64 in `rev` form
// (shift first, then value).
// SELECT-LABEL: func.func @simd_i64_shl
// SELECT: waveamdmachine.v_lshlrev_b64 {{.*}} : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 2>) -> !waveamdmachine.reg<vgpr, 2>
func.func @simd_i64_shl(%a: !wave.simd<i64, 32>, %b: !wave.simd<i64, 32>) attributes {wave.kernel} {
  %s = wave.binary shli %a, %b : !wave.simd<i64, 32>, !wave.simd<i64, 32> -> !wave.simd<i64, 32>
  return
}

// SELECT-LABEL: func.func @simd_i64_uniform_splat_shift
// SELECT: waveamdmachine.s_lshl_b64
// SELECT-NOT: waveamdmachine.v_lshlrev_b64
// SELECT: waveamdmachine.s_lshr_b64
// SELECT-NOT: waveamdmachine.v_lshrrev_b64
// SELECT: return
func.func @simd_i64_uniform_splat_shift(%a: i64, %b: i64) attributes {wave.kernel} {
  %va = wave.splat %a : i64 -> !wave.simd<i64, 32>
  %vb = wave.splat %b : i64 -> !wave.simd<i64, 32>
  %shl = wave.binary shli %va, %vb : !wave.simd<i64, 32>, !wave.simd<i64, 32> -> !wave.simd<i64, 32>
  %shr = wave.binary shrui %va, %vb : !wave.simd<i64, 32>, !wave.simd<i64, 32> -> !wave.simd<i64, 32>
  return
}

// SIMD i64 xor lowers as a 64-bit vector op, not two truncated i32 values.
// SELECT-LABEL: func.func @simd_i64_xor
// SELECT: waveamdmachine.v_xor_b64 {{.*}} : (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vgpr, 2>) -> !waveamdmachine.reg<vgpr, 2>
func.func @simd_i64_xor(%a: !wave.simd<i64, 32>, %b: !wave.simd<i64, 32>) attributes {wave.kernel} {
  %x = wave.binary xori %a, %b : !wave.simd<i64, 32>, !wave.simd<i64, 32> -> !wave.simd<i64, 32>
  return
}

// SELECT-LABEL: func.func @uniform_index_sub_div_rem
// SELECT: waveamdmachine.s_add_u64
// SELECT: waveamdmachine.s_lshr_b64
// SELECT: waveamdmachine.s_and_b32
// SELECT: waveamdmachine.tuple_from_elements
func.func @uniform_index_sub_div_rem() attributes {wave.kernel} {
  %a = arith.constant 4096 : index
  %b = arith.constant 64 : index
  %two = arith.constant 2 : index
  %eight = arith.constant 8 : index
  %diff = wave.binary subi %a, %b : index, index -> index
  %half = wave.binary divui %diff, %two : index, index -> index
  %tail = wave.binary remui %diff, %eight : index, index -> index
  %sum = wave.binary addi %half, %tail : index, index -> index
  return
}

// SELECT-LABEL: func.func @simd_i64_div_rem_pow2
// SELECT: waveamdmachine.v_lshrrev_b64
// SELECT: waveamdmachine.v_and_b32
// SELECT: waveamdmachine.tuple_from_elements
func.func @simd_i64_div_rem_pow2(%a: !wave.simd<i64, 32>) attributes {wave.kernel} {
  %two = arith.constant 2 : i64
  %eight = arith.constant 8 : i64
  %half = wave.binary divui %a, %two : !wave.simd<i64, 32>, i64 -> !wave.simd<i64, 32>
  %tail = wave.binary remui %a, %eight : !wave.simd<i64, 32>, i64 -> !wave.simd<i64, 32>
  %sum = wave.binary addi %half, %tail : !wave.simd<i64, 32>, !wave.simd<i64, 32> -> !wave.simd<i64, 32>
  return
}

// SELECT-LABEL: func.func @scalar_arith_cmpi_select
// SELECT: %[[CMP:.*]] = waveamdmachine.s_cmp_lt_i32
// SELECT: %[[CMP_BOOL:.*]] = waveamdmachine.s_cselect_b32 %[[CMP]]
// SELECT: waveamdmachine.s_add_i32
// SELECT: %[[RELOAD:.*]] = waveamdmachine.s_cmp_lg_u32 %[[CMP_BOOL]]
// SELECT-NEXT: waveamdmachine.s_cselect_b32 %[[RELOAD]]
// SELECT: waveamdmachine.s_cmp_lt_i32
// SELECT: waveamdmachine.s_cselect_b32
func.func @scalar_arith_cmpi_select(%a: i32, %b: i32, %x: index, %y: index) -> i32 {
  %i32cond = arith.cmpi slt, %a, %b : i32
  %clobber = wave.binary addi %a, %b : i32, i32 -> i32
  %i32min = wave.select %i32cond, %clobber, %b : i32
  %idxcond = arith.cmpi slt, %x, %y : index
  %c1 = arith.constant 1 : i32
  %c2 = arith.constant 2 : i32
  %pick = wave.select %idxcond, %c1, %c2 : i32
  %sum = wave.binary addi %i32min, %pick : i32, i32 -> i32
  return %sum : i32
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx803"} {

// gfx8 v_add_u32 writes VCC; keep that clobber explicit in machine IR.
// SELECT-LABEL: func.func @gfx8_simd_i32_addi
// SELECT: waveamdmachine.v_add_u32_vcc {{.*}} : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vcc, 1>)
func.func @gfx8_simd_i32_addi(%a: !wave.simd<i32, 64>,
                              %b: !wave.simd<i32, 64>) attributes {wave.kernel} {
  %sum = wave.binary addi %a, %b : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
// SELECT-LABEL: func.func @mixed_i64_addi
// SELECT: waveamdmachine.v_add_u64 {{.*}} : (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vgpr, 2>) -> (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vcc, 1>)
func.func @mixed_i64_addi(%a: i64, %b: !wave.simd<i64, 32>) attributes {wave.kernel} {
  %sum = wave.binary addi %a, %b : i64, !wave.simd<i64, 32> -> !wave.simd<i64, 32>
  return
}
}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
// SELECT-LABEL: func.func @mixed_i64_muli
// SELECT: waveamdmachine.v_mul_u64 {{.*}} : (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vgpr, 2>) -> (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vgpr, 1>)
func.func @mixed_i64_muli(%a: i64, %b: !wave.simd<i64, 32>) attributes {wave.kernel} {
  %p = wave.binary muli %a, %b : i64, !wave.simd<i64, 32> -> !wave.simd<i64, 32>
  return
}
}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
// SELECT-LABEL: func.func @mixed_i64_shli
// SELECT: waveamdmachine.v_lshlrev_b64 {{.*}} : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 2>) -> !waveamdmachine.reg<vgpr, 2>
func.func @mixed_i64_shli(%a: i64, %b: !wave.simd<i64, 32>) attributes {wave.kernel} {
  %s = wave.binary shli %a, %b : i64, !wave.simd<i64, 32> -> !wave.simd<i64, 32>
  return
}
}
