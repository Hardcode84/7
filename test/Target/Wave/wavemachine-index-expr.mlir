// RUN: wave-opt --waveamd-to-wavemachine %s | FileCheck %s

// `wave.index_expr` bucketizes the top-level ixsimpl ADD summands
// into a V / S / inst-offset triple before lowering. Lane-varying
// terms stay on the VGPR side; uniform SGPR symbols accumulate in
// the S slot; constants collapse into the `inst_offset` attr.
// `wave.ptr_add` scales each slot by element size, and the destination
// memory op routes the triple through its AddressFieldsOpInterface
// spec (folding S into V when the target lacks an soffset slot).

module attributes {wavemachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// 4*lid + K + wgid_y on a global ptr (no S slot).
//   V bucket: 4*lid -> v_mul_lo_u32, scaled x4 -> v_lshlrev_b32(.,2).
//   S bucket: wgid_y, scaled x4 -> s_lshl_b32(.,2).
//   inst:    K=16, scaled x4 -> offset 64.
//   Global has no soffset slot, so the scaled S contribution folds
//   into V via one final v_add_u32.
// CHECK-LABEL: func.func @mixed_offset
// CHECK: %[[LANE:.*]] = wavemachine.v_mbcnt_lo
// CHECK: %[[WGID:.*]] = wavemachine.s_workgroup_id_y
// CHECK: %[[FOUR:.*]] = wavemachine.imm 4
// CHECK: %[[MUL:.*]] = wavemachine.v_mul_lo_u32 %[[FOUR]], %[[LANE]]
// CHECK: %[[VSCALE:.*]] = wavemachine.v_lshlrev_b32 %[[MUL]],
// CHECK: %[[SSCALE:.*]] = wavemachine.s_lshl_b32 %[[WGID]],
// CHECK: %[[ADDR:.*]] = wavemachine.v_add_u32 %[[VSCALE]], %[[SSCALE]]
// CHECK: wavemachine.global_store_b32 %[[ADDR]], {{.*}} offset 64
func.func @mixed_offset(%out: !wave.ptr<i32, #wave.global>, %x: i32) attributes {wave.kernel} {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %wgid_y = wave.workgroup_id 1
  %k = arith.constant 16 : i32
  %off = wave.index_expr <"4*lid + K + wgid_y"> ["K", "lid", "wgid_y"] (%k, %lane, %wgid_y) : (i32, !wave.simd<i32, 32>, i32) -> !wave.index<32>
  %ptrs = wave.ptr_add %out, %off : !wave.ptr<i32, #wave.global>, !wave.index<32> -> !wave.simd<!wave.ptr<i32, #wave.global>, 32>
  %vx = wave.splat %x : i32 -> !wave.simd<i32, 32>
  %val = wave.addi %lane, %vx : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %tok = wave.store %val -> %ptrs : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<i32, #wave.global>, 32>) -> !wave.mem.token
  return
}

// Single-symbol passthrough: the bucketizer routes lid straight to
// the voffset slot; the only arith is the byte-scale shift on lid
// and the value-side adder. No spurious `imm 0` / `imm 1` ops, no
// inst_offset on the store.
// CHECK-LABEL: func.func @passthrough
// CHECK: %[[LANE:.*]] = wavemachine.v_mbcnt_lo
// CHECK: %[[VOFFSET:.*]] = wavemachine.v_lshlrev_b32 %[[LANE]],
// CHECK-NOT: wavemachine.v_mul_lo_u32
// CHECK: wavemachine.global_store_b32 %[[VOFFSET]],
// CHECK-NOT: offset
func.func @passthrough(%out: !wave.ptr<i32, #wave.global>, %x: i32) attributes {wave.kernel} {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %off = wave.index_expr <"lid"> ["lid"] (%lane) : (!wave.simd<i32, 32>) -> !wave.index<32>
  %ptrs = wave.ptr_add %out, %off : !wave.ptr<i32, #wave.global>, !wave.index<32> -> !wave.simd<!wave.ptr<i32, #wave.global>, 32>
  %vx = wave.splat %x : i32 -> !wave.simd<i32, 32>
  %val = wave.addi %lane, %vx : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %tok = wave.store %val -> %ptrs : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<i32, #wave.global>, 32>) -> !wave.mem.token
  return
}

// Buffer destination has the soffset slot, so wgid_x + wgid_y collapse
// onto the S side via one `s_add_i32` and feed the buffer_store_b32
// soffset operand. K=8 scaled x4 -> inst_offset = 32.
// CHECK-LABEL: func.func @buffer_buckets
// CHECK: %[[LANE:.*]] = wavemachine.v_mbcnt_lo
// CHECK: %[[WGX:.*]] = wavemachine.s_workgroup_id_x
// CHECK: %[[WGY:.*]] = wavemachine.s_workgroup_id_y
// CHECK: %[[SSUM:.*]], %{{.*}} = wavemachine.s_add_i32 %[[WGX]], %[[WGY]]
// CHECK: %[[VBYTE:.*]] = wavemachine.v_lshlrev_b32 %[[LANE]],
// CHECK: %[[SBYTE:.*]] = wavemachine.s_lshl_b32 %[[SSUM]],
// CHECK: wavemachine.buffer_store_b32 %[[VBYTE]],{{.*}}, %[[SBYTE]] offset 32
func.func @buffer_buckets(%out: !wave.ptr<i32, #wave.global>, %x: i32) attributes {wave.kernel} {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %wgid_x = wave.workgroup_id 0
  %wgid_y = wave.workgroup_id 1
  %k = arith.constant 8 : i32
  %range = arith.constant 256 : i32
  %buf = waveamd.make_buffer %out, %range : !wave.ptr<i32, #wave.global>, i32 -> !wave.ptr<i32, #waveamd.buffer>
  %vx = wave.splat %x : i32 -> !wave.simd<i32, 32>
  %sum = wave.addi %lane, %vx : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %off = wave.index_expr <"lid + wgid_x + wgid_y + K"> ["K", "lid", "wgid_x", "wgid_y"] (%k, %lane, %wgid_x, %wgid_y) : (i32, !wave.simd<i32, 32>, i32, i32) -> !wave.index<32>
  %ptrs = wave.ptr_add %buf, %off : !wave.ptr<i32, #waveamd.buffer>, !wave.index<32> -> !wave.simd<!wave.ptr<i32, #waveamd.buffer>, 32>
  %tok = wave.store %sum -> %ptrs : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<i32, #waveamd.buffer>, 32>) -> !wave.mem.token
  return
}

// IntRangeAnalysis-driven fold: `wave.assume_range` pins `%a` to a
// provable point range `[16, 16]`. Selection runs IntegerRangeAnalysis
// over the body and builds ixsimpl assumptions per binding; `ixs_simplify`
// then collapses `K + lid` to `lid + 16` even though `K` is bound to a
// runtime SGPR. The bucketizer sees the const summand and routes it
// to `offset` instead of an `s_add_i32` into the soffset slot.
// CHECK-LABEL: func.func @range_drives_const_fold
// CHECK: %[[LANE:.*]] = wavemachine.v_mbcnt_lo
// CHECK-NOT: wavemachine.s_add_i32
// CHECK: %[[VBYTE:.*]] = wavemachine.v_lshlrev_b32 %[[LANE]],
// CHECK: wavemachine.global_store_b32 %[[VBYTE]], {{.*}} offset 64
func.func @range_drives_const_fold(%out: !wave.ptr<i32, #wave.global>, %x: i32, %v: i32) attributes {wave.kernel} {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %a = wave.assume_range %x, [16, 16] : i32
  %off = wave.index_expr <"K + lid"> ["K", "lid"] (%a, %lane) : (i32, !wave.simd<i32, 32>) -> !wave.index<32>
  %ptrs = wave.ptr_add %out, %off : !wave.ptr<i32, #wave.global>, !wave.index<32> -> !wave.simd<!wave.ptr<i32, #wave.global>, 32>
  %vv = wave.splat %v : i32 -> !wave.simd<i32, 32>
  %val = wave.addi %lane, %vv : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %tok = wave.store %val -> %ptrs : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<i32, #wave.global>, 32>) -> !wave.mem.token
  return
}

}
