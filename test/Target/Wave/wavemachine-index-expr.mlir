// RUN: wave-opt --waveamd-to-wavemachine %s | FileCheck %s

// `wave.index_expr` lowers by walking the ixsimpl AST and emitting the
// equivalent v_mul_lo_u32 / v_add_u32 chain on the bound operands. The
// AST stores ADD as `coeff + sum(term_coeff[i] * term[i])`, so we use
// the typed accessors (not the generic child iterator) and skip the
// term_coeff materialization when it's 1, and the seed coeff when it's
// 0. The chain feeds `wave.ptr_add` like any other offset.

module attributes {wavemachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// 4*lid + K + wgid_y: one mul (4*lane), two adds (+ K, + wgid_y),
// then the ptr_add scales by element size (lshl by 2 for i32).
// CHECK-LABEL: func.func @mixed_offset
// CHECK: %[[LANE:.*]] = wavemachine.v_mbcnt_lo
// CHECK: %[[WGID:.*]] = wavemachine.s_workgroup_id_y
// CHECK: %[[K:.*]] = wavemachine.imm 16
// CHECK: %[[FOUR:.*]] = wavemachine.imm 4
// CHECK: %[[MUL:.*]] = wavemachine.v_mul_lo_u32 %[[FOUR]], %[[LANE]]
// CHECK: %[[SUM1:.*]] = wavemachine.v_add_u32 %[[K]], %[[MUL]]
// CHECK: %[[SUM2:.*]] = wavemachine.v_add_u32 %[[SUM1]], %[[WGID]]
// CHECK: %[[SHIFT:.*]] = wavemachine.imm 2
// CHECK: %[[BYTE:.*]] = wavemachine.v_lshlrev_b32 %[[SUM2]], %[[SHIFT]]
// CHECK: wavemachine.global_store_b32 %[[BYTE]],
func.func @mixed_offset(%out: !wave.ptr<i32, #wave.global>) attributes {wave.kernel} {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %wgid_y = wave.workgroup_id 1
  %k = arith.constant 16 : i32
  %off = wave.index_expr <"4*lid + K + wgid_y"> ["K", "lid", "wgid_y"] (%k, %lane, %wgid_y) : (i32, !wave.simd<i32, 32>, i32) -> !wave.index<32>
  %ptrs = wave.ptr_add %out, %off : !wave.ptr<i32, #wave.global>, !wave.index<32> -> !wave.simd<!wave.ptr<i32, #wave.global>, 32>
  %c0 = arith.constant 0 : i32
  %v = wave.splat %c0 : i32 -> !wave.simd<i32, 32>
  %tok = wave.store %v -> %ptrs : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<i32, #wave.global>, 32>) -> !wave.mem.token
  return
}

// Single-symbol passthrough: materializer just hands the bound value
// through; no extra arith is emitted. Confirms the trivial-coeff
// skip-path doesn't leak spurious `imm 0` / `imm 1` ops.
// CHECK-LABEL: func.func @passthrough
// CHECK-NOT: wavemachine.v_add_u32
// CHECK-NOT: wavemachine.v_mul_lo_u32
// CHECK: wavemachine.global_store_b32
func.func @passthrough(%out: !wave.ptr<i32, #wave.global>) attributes {wave.kernel} {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %off = wave.index_expr <"lid"> ["lid"] (%lane) : (!wave.simd<i32, 32>) -> !wave.index<32>
  %ptrs = wave.ptr_add %out, %off : !wave.ptr<i32, #wave.global>, !wave.index<32> -> !wave.simd<!wave.ptr<i32, #wave.global>, 32>
  %c0 = arith.constant 0 : i32
  %v = wave.splat %c0 : i32 -> !wave.simd<i32, 32>
  %tok = wave.store %v -> %ptrs : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<i32, #wave.global>, 32>) -> !wave.mem.token
  return
}

}
