// RUN: wave-opt --split-input-file --waveamd-to-machine --verify-diagnostics %s | FileCheck %s --check-prefix=SELECT

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
func.func @uniform_i32_arith(%out: !wave.ptr<i32, #wave.global>) attributes {wave.kernel} {
  %wgid = wave.workgroup_id 0
  %four = arith.constant 4 : i32
  %sum = wave.addi %wgid, %four : i32, i32 -> i32
  %scaled = wave.muli %sum, %wgid : i32, i32 -> i32
  %two = arith.constant 2 : i32
  %shifted = wave.shli %scaled, %two : i32, i32 -> i32
  // Make the shifted result live so it survives DCE.
  %off = wave.index_expr <"S"> ["S"] (%shifted) : (i32) -> index
  %ptr = wave.ptr_add %out, %off : !wave.ptr<i32, #wave.global>, index -> !wave.ptr<i32, #wave.global>
  return
}

// Mixed uniform/SIMD i32 add: SIMD operand routes through v_add_u32
// with the usual SGPR-in-vsrc0 shuffle.
// SELECT-LABEL: func.func @mixed_i32_addi
// SELECT: %[[LANE:.*]] = waveamdmachine.v_mbcnt_lo
// SELECT: %[[WGID:.*]] = waveamdmachine.s_workgroup_id_x
// SELECT: %[[ADD:.*]] = waveamdmachine.v_add_u32 %[[WGID]], %[[LANE]]
func.func @mixed_i32_addi(%out: !wave.ptr<i32, #wave.global>) attributes {wave.kernel} {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %wgid = wave.workgroup_id 0
  %off = wave.addi %wgid, %lane : i32, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %ptrs = wave.ptr_add %out, %off : !wave.ptr<i32, #wave.global>, !wave.simd<i32, 32> -> !wave.simd<!wave.ptr<i32, #wave.global>, 32>
  %c0 = arith.constant 0 : i32
  %v = wave.splat %c0 : i32 -> !wave.simd<i32, 32>
  %tok = wave.store %v -> %ptrs : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<i32, #wave.global>, 32>) -> !wave.mem.token
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
  %sum = wave.addi %a, %b : i64, i64 -> i64
  return
}

// SIMD i64 add. Operand widths come from the function-arg materializer
// once it sees a `!wave.simd<i64, W>` type; this kernel is unreachable
// through the ABI pass today (it rejects width-2 non-pointer args), so
// we exercise only the selection pass here.
// SELECT-LABEL: func.func @simd_i64_add
// SELECT: waveamdmachine.v_add_u64 {{.*}} : (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vgpr, 2>) -> (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vcc, 1>)
func.func @simd_i64_add(%a: !wave.simd<i64, 32>, %b: !wave.simd<i64, 32>) attributes {wave.kernel} {
  %sum = wave.addi %a, %b : !wave.simd<i64, 32>, !wave.simd<i64, 32> -> !wave.simd<i64, 32>
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
  %p = wave.muli %a, %b : i64, i64 -> i64
  return
}

// SIMD-i64 multiply: same shape on the vector side, scratch is a
// width-1 VGPR.
// SELECT-LABEL: func.func @simd_i64_mul
// SELECT: waveamdmachine.v_mul_u64 {{.*}} : (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vgpr, 2>) -> (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vgpr, 1>)
func.func @simd_i64_mul(%a: !wave.simd<i64, 32>, %b: !wave.simd<i64, 32>) attributes {wave.kernel} {
  %p = wave.muli %a, %b : !wave.simd<i64, 32>, !wave.simd<i64, 32> -> !wave.simd<i64, 32>
  return
}

// Uniform i64 shift: single-instruction s_lshl_b64. The 64-bit shift
// operand is allocated as a 2-wide SGPR even though the hardware only
// reads the low 32 bits; the asm printer extracts the low component.
// SELECT-LABEL: func.func @uniform_i64_shl
// SELECT: waveamdmachine.s_lshl_b64 {{.*}} : (!waveamdmachine.reg<sgpr, 2>, !waveamdmachine.reg<sgpr, 2>) -> (!waveamdmachine.reg<sgpr, 2>, !waveamdmachine.reg<scc, 1>)
func.func @uniform_i64_shl() attributes {wave.kernel} {
  %a = arith.constant 5 : i64
  %b = arith.constant 3 : i64
  %s = wave.shli %a, %b : i64, i64 -> i64
  return
}

// SIMD i64 shift: single-instruction v_lshlrev_b64 in `rev` form
// (shift first, then value).
// SELECT-LABEL: func.func @simd_i64_shl
// SELECT: waveamdmachine.v_lshlrev_b64 {{.*}} : (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vgpr, 2>) -> !waveamdmachine.reg<vgpr, 2>
func.func @simd_i64_shl(%a: !wave.simd<i64, 32>, %b: !wave.simd<i64, 32>) attributes {wave.kernel} {
  %s = wave.shli %a, %b : !wave.simd<i64, 32>, !wave.simd<i64, 32> -> !wave.simd<i64, 32>
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx803"} {

// gfx8 v_add_u32 writes VCC; keep that clobber explicit in machine IR.
// SELECT-LABEL: func.func @gfx8_simd_i32_addi
// SELECT: waveamdmachine.v_add_u32_vcc {{.*}} : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vcc, 1>)
func.func @gfx8_simd_i32_addi(%a: !wave.simd<i32, 64>,
                              %b: !wave.simd<i32, 64>) attributes {wave.kernel} {
  %sum = wave.addi %a, %b : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
  return
}

}

// -----

// Mixed uniform / SIMD i64 add is not yet lowered (would need an
// SGPR2->VGPR2 promotion path; the only producer of SIMD i64 today
// would be such a splat).
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
func.func @mixed_i64_addi(%a: i64, %b: !wave.simd<i64, 32>) attributes {wave.kernel} {
  // expected-error @+1 {{i64 wave.addi with mixed uniform/SIMD operands is not yet supported}}
  %sum = wave.addi %a, %b : i64, !wave.simd<i64, 32> -> !wave.simd<i64, 32>
  return
}
}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
func.func @mixed_i64_muli(%a: i64, %b: !wave.simd<i64, 32>) attributes {wave.kernel} {
  // expected-error @+1 {{i64 wave.muli with mixed uniform/SIMD operands is not yet supported}}
  %p = wave.muli %a, %b : i64, !wave.simd<i64, 32> -> !wave.simd<i64, 32>
  return
}
}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
func.func @mixed_i64_shli(%a: i64, %b: !wave.simd<i64, 32>) attributes {wave.kernel} {
  // expected-error @+1 {{i64 wave.shli with mixed uniform/SIMD operands is not yet supported}}
  %s = wave.shli %a, %b : i64, !wave.simd<i64, 32> -> !wave.simd<i64, 32>
  return
}
}
