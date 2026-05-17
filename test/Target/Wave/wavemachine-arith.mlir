// RUN: wave-opt --waveamd-to-wavemachine %s | FileCheck %s --check-prefix=SELECT

// Width-independent integer arith ops lower per-target based on
// operand uniformity. Uniform-uniform i32 goes to the scalar
// instruction set; any SIMD operand routes through the vector ALU
// with the usual SGPR-in-vsrc0 shuffling for VOP2 ops.

module attributes {wavemachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// Uniform i32 add/mul/shl: s_add_i32 / s_mul_i32 / s_lshl_b32.
// SELECT-LABEL: func.func @uniform_i32_arith
// SELECT: wavemachine.s_workgroup_id_x
// SELECT: wavemachine.s_add_i32 {{.*}} -> (!wavemachine.reg<sgpr, 1>, !wavemachine.reg<scc, 1>)
// SELECT: wavemachine.s_mul_i32 {{.*}} -> !wavemachine.reg<sgpr, 1>
// SELECT: wavemachine.s_lshl_b32 {{.*}} -> !wavemachine.reg<sgpr, 1>
// SELECT-NOT: wavemachine.v_add_u32
// SELECT-NOT: wavemachine.v_mul_lo_u32
func.func @uniform_i32_arith(%out: !wave.ptr<i32, #wave.global>) attributes {wave.kernel} {
  %wgid = wave.workgroup_id 0
  %four = arith.constant 4 : i32
  %sum = wave.addi %wgid, %four : i32, i32 -> i32
  %scaled = wave.muli %sum, %wgid : i32, i32 -> i32
  %two = arith.constant 2 : i32
  %shifted = wave.shli %scaled, %two : i32, i32 -> i32
  // Make the shifted result live so it survives DCE.
  %off = wave.index_expr <"S"> ["S"] (%shifted) : (i32) -> !wave.index
  %ptr = wave.ptr_add %out, %off : !wave.ptr<i32, #wave.global>, !wave.index -> !wave.ptr<i32, #wave.global>
  return
}

// Mixed uniform/SIMD i32 add: SIMD operand routes through v_add_u32
// with the usual SGPR-in-vsrc0 shuffle.
// SELECT-LABEL: func.func @mixed_i32_addi
// SELECT: %[[LANE:.*]] = wavemachine.v_mbcnt_lo
// SELECT: %[[WGID:.*]] = wavemachine.s_workgroup_id_x
// SELECT: %[[ADD:.*]] = wavemachine.v_add_u32 %[[WGID]], %[[LANE]]
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

}
