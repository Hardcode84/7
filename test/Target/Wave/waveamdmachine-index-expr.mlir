// RUN: wave-opt --waveamd-to-machine %s | FileCheck %s
// RUN: wave-opt --waveamd-to-machine %s | wave-opt | FileCheck %s
// RUN: wave-opt --waveamd-to-machine %s | wave-opt --waveamd-decompose-mem-tuples | FileCheck %s --check-prefix=DECOMP

// `wave.index_expr` stays symbolic through `wave.ptr_add`; memory
// lowering expands the byte expression, picks V / S / inst-offset
// fields from the target memory-op spec, then materializes the chosen
// fields.

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// 4*lid + K + bounded wgid_y on a global ptr (no S slot).
//   V field: 4*lid scaled by element size -> v_lshlrev_b32(.,4).
//   S term:  wgid_y scaled by element size -> s_lshl_b32(.,2).
//   inst:    K=16, scaled x4 -> offset 64.
//   Global has no soffset slot, so the scaled S contribution folds
//   into V via one final v_add_u32.
// CHECK-LABEL: func.func @mixed_offset
// CHECK: %[[LANE:.*]] = waveamdmachine.v_mbcnt_lo
// CHECK: %[[WGID:.*]] = waveamdmachine.s_workgroup_id_y
// CHECK: %[[SSCALE:[^,]+]], %{{.*}} = waveamdmachine.s_lshl_b32 %[[WGID]],
// CHECK: %[[VSCALE:.*]] = waveamdmachine.v_lshlrev_b32 %[[LANE]],
// CHECK: %[[ADDR:.*]] = waveamdmachine.v_add_u32 %[[SSCALE]], %[[VSCALE]]
// CHECK: waveamdmachine.global_store_b32 %[[ADDR]], {{.*}} offset 64
func.func @mixed_offset(%out: !wave.ptr<#wave.global, i32>, %x: i32) attributes {wave.kernel} {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %wgid_y_raw = wave.workgroup_id 1
  %wgid_y = wave.assume %wgid_y_raw as "x" [#wave.pred<"x >= 0">, #wave.pred<"x <= 1023">] : i32
  %k = arith.constant 16 : i32
  %off = wave.index_expr <"4*lid + K + wgid_y"> ["K", "lid", "wgid_y"] (%k, %lane, %wgid_y) : (i32, !wave.simd<i32, 32>, i32) -> !wave.simd<index, 32>
  %ptrs = wave.ptr_add %out, %off : !wave.ptr<#wave.global, i32>, !wave.simd<index, 32> -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %vx = wave.splat %x : i32 -> !wave.simd<i32, 32>
  %val = wave.binary addi %lane, %vx : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %tok = wave.store %val -> %ptrs : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.global, i32>, 32>) -> !wave.mem.token
  return
}

// Single-symbol passthrough: address planning routes lid straight to
// the voffset slot; the only arith is the byte-scale shift on lid
// and the value-side adder. No spurious `imm 0` / `imm 1` ops, no
// inst_offset on the store.
// CHECK-LABEL: func.func @passthrough
// CHECK: %[[LANE:.*]] = waveamdmachine.v_mbcnt_lo
// CHECK: %[[VOFFSET:.*]] = waveamdmachine.v_lshlrev_b32 %[[LANE]],
// CHECK-NOT: waveamdmachine.v_mul_lo_u32
// CHECK: waveamdmachine.global_store_b32 %[[VOFFSET]],
// CHECK-NOT: offset
func.func @passthrough(%out: !wave.ptr<#wave.global, i32>, %x: i32) attributes {wave.kernel} {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %off = wave.index_expr <"lid"> ["lid"] (%lane) : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
  %ptrs = wave.ptr_add %out, %off : !wave.ptr<#wave.global, i32>, !wave.simd<index, 32> -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %vx = wave.splat %x : i32 -> !wave.simd<i32, 32>
  %val = wave.binary addi %lane, %vx : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %tok = wave.store %val -> %ptrs : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.global, i32>, 32>) -> !wave.mem.token
  return
}

// CHECK-LABEL: func.func @constant_index_offset
// CHECK: %[[LANE:.*]] = waveamdmachine.v_mbcnt_lo
// CHECK: %[[VOFFSET:.*]] = waveamdmachine.v_lshlrev_b32 %[[LANE]],
// CHECK: waveamdmachine.global_store_b32 %[[VOFFSET]], {{.*}} offset 28
func.func @constant_index_offset(%out: !wave.ptr<#wave.global, i32>, %x: i32) attributes {wave.kernel} {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %off = arith.constant 7 : index
  %base = wave.ptr_add %out, %off
      : !wave.ptr<#wave.global, i32>, index -> !wave.ptr<#wave.global, i32>
  %ptrs = wave.ptr_add %base, %lane
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %vx = wave.splat %x : i32 -> !wave.simd<i32, 32>
  %tok = wave.store %vx -> %ptrs
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.global, i32>, 32>)
      -> !wave.mem.token
  return
}

// CHECK-LABEL: func.func @symbolic_index_typed_offset
// CHECK: %[[LANE:.*]] = waveamdmachine.v_mbcnt_lo
// CHECK: %[[VOFFSET:.*]] = waveamdmachine.v_lshlrev_b32 %[[LANE]],
// CHECK: waveamdmachine.global_store_b32 %[[VOFFSET]], {{.*}} offset 64
func.func @symbolic_index_typed_offset(%out: !wave.ptr<#wave.global, i32>, %x: i32) attributes {wave.kernel} {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %k = arith.constant 16 : index
  %off = wave.index_expr <"K + lid"> ["K", "lid"] (%k, %lane)
      : (index, !wave.simd<i32, 32>) -> !wave.simd<index, 32>
  %ptrs = wave.ptr_add %out, %off
      : !wave.ptr<#wave.global, i32>, !wave.simd<index, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %vx = wave.splat %x : i32 -> !wave.simd<i32, 32>
  %tok = wave.store %vx -> %ptrs
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.global, i32>, 32>)
      -> !wave.mem.token
  return
}

// CHECK-LABEL: func.func @raw_simd_index_offset
// CHECK-DAG: %[[IDX:.*]] = waveamdmachine.arg {index = 1 : i64, pointer = false}
// CHECK: %[[VOFFSET:.*]] = waveamdmachine.v_lshlrev_b32 %[[IDX]],
// CHECK: %[[ADDR64:.*]], %{{.*}} = waveamdmachine.v_add_u64
// CHECK: waveamdmachine.global_store_b32_addr64 %[[ADDR64]],
func.func @raw_simd_index_offset(%out: !wave.ptr<#wave.global, i32>,
                                 %idx: !wave.simd<index, 32>,
                                 %x: i32) attributes {wave.kernel} {
  %ptrs = wave.ptr_add %out, %idx
      : !wave.ptr<#wave.global, i32>, !wave.simd<index, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %vx = wave.splat %x : i32 -> !wave.simd<i32, 32>
  %tok = wave.store %vx -> %ptrs
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.global, i32>, 32>)
      -> !wave.mem.token
  return
}

// Buffer destination has the soffset slot, so the scaled wgid_x /
// wgid_y terms stay SGPR-side and feed the buffer_store_b32 soffset
// operand. K=8 scaled x4 -> inst_offset = 32. The
// `wave.assume` wrappers bound each workgroup_id so the
// scaled sum provably fits the unsigned 32-bit S slot.
// CHECK-LABEL: func.func @buffer_buckets
// CHECK: %[[LANE:.*]] = waveamdmachine.v_mbcnt_lo
// CHECK: %[[WGX:.*]] = waveamdmachine.s_workgroup_id_x
// CHECK: %[[WGY:.*]] = waveamdmachine.s_workgroup_id_y
// CHECK: %[[VBYTE:.*]] = waveamdmachine.v_lshlrev_b32 %[[LANE]],
// CHECK: %[[SX:[^,]+]], %{{.*}} = waveamdmachine.s_lshl_b32 %[[WGX]],
// CHECK: %[[SY:[^,]+]], %{{.*}} = waveamdmachine.s_lshl_b32 %[[WGY]],
// CHECK: %[[SBYTE:[^,]+]], %{{.*}} = waveamdmachine.s_add_i32 %[[SX]], %[[SY]]
// CHECK: waveamdmachine.buffer_store_b32 %[[VBYTE]],{{.*}}, %[[SBYTE]] offset 32
func.func @buffer_buckets(%out: !wave.ptr<#wave.global, i32>, %x: i32) attributes {wave.kernel} {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %wgid_x_raw = wave.workgroup_id 0
  %wgid_y_raw = wave.workgroup_id 1
  %wgid_x = wave.assume %wgid_x_raw as "x" [#wave.pred<"x >= 0">, #wave.pred<"x <= 1023">] : i32
  %wgid_y = wave.assume %wgid_y_raw as "x" [#wave.pred<"x >= 0">, #wave.pred<"x <= 1023">] : i32
  %k = arith.constant 8 : i32
  %range = arith.constant 256 : i32
  %buf = waveamd.make_buffer %out, %range : !wave.ptr<#wave.global, i32>, i32 -> !wave.ptr<#waveamd.buffer, i32>
  %vx = wave.splat %x : i32 -> !wave.simd<i32, 32>
  %sum = wave.binary addi %lane, %vx : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %off = wave.index_expr <"lid + wgid_x + wgid_y + K"> ["K", "lid", "wgid_x", "wgid_y"] (%k, %lane, %wgid_x, %wgid_y) : (i32, !wave.simd<i32, 32>, i32, i32) -> !wave.simd<index, 32>
  %ptrs = wave.ptr_add %buf, %off : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<index, 32> -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>
  %tok = wave.store %sum -> %ptrs : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>) -> !wave.mem.token
  return
}

// CHECK-LABEL: func.func @buffer_tuple_large_const_reserves_chunk_headroom
// CHECK-NOT: offset 4092
// CHECK: waveamdmachine.buffer_load_tuple_b32
// CHECK-NOT: offset 4092
// CHECK: return
// DECOMP-LABEL: func.func @buffer_tuple_large_const_reserves_chunk_headroom
// DECOMP-NOT: offset 4108
// DECOMP: waveamdmachine.buffer_load_b128
// DECOMP-NOT: offset 4108
// DECOMP: waveamdmachine.buffer_load_b128 {{.*}} offset 16
// DECOMP-NOT: offset 4108
// DECOMP: return
func.func @buffer_tuple_large_const_reserves_chunk_headroom(%in: !wave.ptr<#wave.global, i32>) attributes {wave.kernel} {
  %size = arith.constant 32768 : i32
  %buffer = waveamd.make_buffer %in, %size : !wave.ptr<#wave.global, i32>, i32 -> !wave.ptr<#waveamd.buffer, i32>
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %k = arith.constant 2047 : i32
  %off = wave.index_expr <"K + lid"> ["K", "lid"](%k, %lane) : (i32, !wave.simd<i32, 32>) -> !wave.simd<index, 32>
  %ptr = wave.ptr_add %buffer, %off : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<index, 32> -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>
  %value, %token = wave.load %ptr : (!wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>) -> (!wave.simd<vector<8xi32>, 32>, !wave.mem.token)
  return
}

// Bounded uniform i32 can occupy the unsigned S slot.
// CHECK-LABEL: func.func @buffer_bounded_uniform_arg_uses_soffset
// CHECK-DAG: %[[U:.*]] = waveamdmachine.arg {index = 1 : i64, pointer = false}
// CHECK-DAG: %[[LANE:.*]] = waveamdmachine.v_mbcnt_lo
// CHECK: %[[VBYTE:.*]] = waveamdmachine.v_lshlrev_b32 %[[LANE]],
// CHECK: %[[SBYTE:[^,]+]], %{{.*}} = waveamdmachine.s_lshl_b32 %[[U]],
// CHECK: waveamdmachine.buffer_store_b32 %[[VBYTE]], {{.*}}, {{.*}}, %[[SBYTE]]
func.func @buffer_bounded_uniform_arg_uses_soffset(%out: !wave.ptr<#wave.global, i32>, %u_raw: i32) attributes {wave.kernel} {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %u = wave.assume %u_raw as "x" [#wave.pred<"x >= 0">, #wave.pred<"x <= 1023">] : i32
  %range = arith.constant 4096 : i32
  %buf = waveamd.make_buffer %out, %range
      : !wave.ptr<#wave.global, i32>, i32 -> !wave.ptr<#waveamd.buffer, i32>
  %off = wave.index_expr <"lid + 16*u"> ["lid", "u"] (%lane, %u)
      : (!wave.simd<i32, 32>, i32) -> !wave.simd<index, 32>
  %ptrs = wave.ptr_add %buf, %off
      : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<index, 32>
      -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>
  %tok = wave.store %lane -> %ptrs
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>)
      -> !wave.mem.token
  return
}

// Expanded uniform polynomial must stay SGPR-side; otherwise the
// buffer soffset path collapses into voffset.
// CHECK-LABEL: func.func @nested_uniform_summand_stays_sgpr
// CHECK: %[[LANE:.*]] = waveamdmachine.v_mbcnt_lo
// CHECK: %[[WGX:.*]] = waveamdmachine.s_workgroup_id_x
// CHECK: %[[WGY:.*]] = waveamdmachine.s_workgroup_id_y
// CHECK: %[[VBYTE:.*]] = waveamdmachine.v_lshlrev_b32 %[[LANE]],
// CHECK: %[[SX:[^,]+]], %{{.*}} = waveamdmachine.s_lshl_b32 %[[WGX]],
// CHECK: %[[SY:[^,]+]], %{{.*}} = waveamdmachine.s_lshl_b32 %[[WGY]],
// CHECK: %[[S0:[^,]+]], %{{.*}} = waveamdmachine.s_add_i32 %[[SX]], %[[SY]]
// CHECK: %[[SXY:.*]] = waveamdmachine.s_mul_i32 %[[WGX]], %[[WGY]]
// CHECK: %[[SXY4:[^,]+]], %{{.*}} = waveamdmachine.s_lshl_b32 %[[SXY]],
// CHECK: %[[SBYTE:[^,]+]], %{{.*}} = waveamdmachine.s_add_i32 %[[S0]], %[[SXY4]]
// CHECK: waveamdmachine.buffer_store_b32 %[[VBYTE]], %[[LANE]], {{.*}}, %[[SBYTE]] offset 8
func.func @nested_uniform_summand_stays_sgpr(%out: !wave.ptr<#wave.global, i32>) attributes {wave.kernel} {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %wgid_x_raw = wave.workgroup_id 0
  %wgid_y_raw = wave.workgroup_id 1
  %wgid_x = wave.assume %wgid_x_raw as "x" [#wave.pred<"x >= 0">, #wave.pred<"x <= 15">] : i32
  %wgid_y = wave.assume %wgid_y_raw as "x" [#wave.pred<"x >= 0">, #wave.pred<"x <= 15">] : i32
  %range = arith.constant 4096 : i32
  %buf = waveamd.make_buffer %out, %range
      : !wave.ptr<#wave.global, i32>, i32 -> !wave.ptr<#waveamd.buffer, i32>
  %off = wave.index_expr <"lid + (wgid_x + 1)*(wgid_y + 2)">
      ["lid", "wgid_x", "wgid_y"] (%lane, %wgid_x, %wgid_y)
      : (!wave.simd<i32, 32>, i32, i32) -> !wave.simd<index, 32>
  %ptrs = wave.ptr_add %buf, %off
      : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<index, 32>
      -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>
  %tok = wave.store %lane -> %ptrs
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>)
      -> !wave.mem.token
  return
}

// IntRangeAnalysis-driven fold: `wave.assume` pins `%a` to a
// provable point range `[16, 16]`. Selection runs IntegerRangeAnalysis
// over the body and builds ixsimpl assumptions per binding; `ixs_simplify`
// then collapses `K + lid` to `lid + 16` even though `K` is bound to a
// runtime SGPR. Address planning routes the const summand to `offset`.
// CHECK-LABEL: func.func @range_drives_const_fold
// CHECK: %[[LANE:.*]] = waveamdmachine.v_mbcnt_lo
// CHECK-NOT: waveamdmachine.s_add_i32
// CHECK: %[[VBYTE:.*]] = waveamdmachine.v_lshlrev_b32 %[[LANE]],
// CHECK: waveamdmachine.global_store_b32 %[[VBYTE]], {{.*}} offset 64
func.func @range_drives_const_fold(%out: !wave.ptr<#wave.global, i32>, %x: i32, %v: i32) attributes {wave.kernel} {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %a = wave.assume %x as "x" [#wave.pred<"x >= 16">, #wave.pred<"x <= 16">] : i32
  %off = wave.index_expr <"K + lid"> ["K", "lid"] (%a, %lane) : (i32, !wave.simd<i32, 32>) -> !wave.simd<index, 32>
  %ptrs = wave.ptr_add %out, %off : !wave.ptr<#wave.global, i32>, !wave.simd<index, 32> -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %vv = wave.splat %v : i32 -> !wave.simd<i32, 32>
  %val = wave.binary addi %lane, %vv : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %tok = wave.store %val -> %ptrs : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.global, i32>, 32>) -> !wave.mem.token
  return
}

// CHECK-LABEL: func.func @divisibility_drives_const_fold
// CHECK: %[[LANE:.*]] = waveamdmachine.v_mbcnt_lo
// CHECK-NOT: waveamdmachine.s_add_i32
// CHECK: %[[VBYTE:.*]] = waveamdmachine.v_lshlrev_b32 %[[LANE]],
// CHECK: waveamdmachine.global_store_b32 %[[VBYTE]], {{.*}} offset 16
func.func @divisibility_drives_const_fold(%out: !wave.ptr<#wave.global, i32>, %u_raw: i32, %x: i32) attributes {wave.kernel} {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %u = wave.assume %u_raw as "x" [#wave.pred<"Mod(x, 16) == 0">] : i32
  %off = wave.index_expr <"lid + Mod(U, 8) + 4"> ["U", "lid"] (%u, %lane) : (i32, !wave.simd<i32, 32>) -> !wave.simd<index, 32>
  %ptrs = wave.ptr_add %out, %off : !wave.ptr<#wave.global, i32>, !wave.simd<index, 32> -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %vx = wave.splat %x : i32 -> !wave.simd<i32, 32>
  %tok = wave.store %vx -> %ptrs : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.global, i32>, 32>) -> !wave.mem.token
  return
}

// CHECK-LABEL: func.func @floor_fractional_add_global
// CHECK: %[[LANE:.*]] = waveamdmachine.v_mbcnt_lo
// CHECK: %[[NUM:.*]] = waveamdmachine.v_add_u32 %{{.*}}, %[[LANE]]
// CHECK: %[[FLOOR:.*]] = waveamdmachine.v_lshrrev_b32 %[[NUM]],
// CHECK: %[[BYTE:.*]] = waveamdmachine.v_lshlrev_b32 %[[FLOOR]],
// CHECK: waveamdmachine.global_store_b32 %[[BYTE]],
func.func @floor_fractional_add_global(%out: !wave.ptr<#wave.global, i32>, %x: i32) attributes {wave.kernel} {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %off = wave.index_expr <"floor(1/2 + 1/4*lid)"> ["lid"](%lane)
      : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
  %ptrs = wave.ptr_add %out, %off
      : !wave.ptr<#wave.global, i32>, !wave.simd<index, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %vx = wave.splat %x : i32 -> !wave.simd<i32, 32>
  %tok = wave.store %vx -> %ptrs
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.global, i32>, 32>)
      -> !wave.mem.token
  return
}

// CHECK-LABEL: func.func @ceil_nested_floor_global
// CHECK: %[[LANE:.*]] = waveamdmachine.v_mbcnt_lo
// CHECK: %[[INNER:.*]] = waveamdmachine.v_lshrrev_b32 %[[LANE]],
// CHECK: %[[BIASED:.*]] = waveamdmachine.v_add_u32 {{.*}}%[[INNER]]
// CHECK: %[[CEIL:.*]] = waveamdmachine.v_lshrrev_b32 %[[BIASED]],
// CHECK: %[[BYTE:.*]] = waveamdmachine.v_lshlrev_b32 %[[CEIL]],
// CHECK: waveamdmachine.global_store_b32 %[[BYTE]],
func.func @ceil_nested_floor_global(%out: !wave.ptr<#wave.global, i32>, %x: i32) attributes {wave.kernel} {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %off = wave.index_expr <"ceiling(1/2*floor(1/4*lid))"> ["lid"](%lane)
      : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
  %ptrs = wave.ptr_add %out, %off
      : !wave.ptr<#wave.global, i32>, !wave.simd<index, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %vx = wave.splat %x : i32 -> !wave.simd<i32, 32>
  %tok = wave.store %vx -> %ptrs
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.global, i32>, 32>)
      -> !wave.mem.token
  return
}

// CHECK-LABEL: func.func @xor_lane_swizzle_global
// CHECK: %[[LANE:.*]] = waveamdmachine.v_mbcnt_lo
// CHECK: %[[MASK:.*]] = waveamdmachine.imm 31
// CHECK: %[[XOR:.*]] = waveamdmachine.v_xor_b32 %[[MASK]], %[[LANE]]
// CHECK: %[[VOFFSET:.*]] = waveamdmachine.v_lshlrev_b32 %[[XOR]],
// CHECK: waveamdmachine.global_store_b32 %[[VOFFSET]],
func.func @xor_lane_swizzle_global(%out: !wave.ptr<#wave.global, i32>, %x: i32) attributes {wave.kernel} {
  %lane_raw = wave.lane_id : !wave.simd<i32, 32>
  %lane = wave.assume %lane_raw as "x" [#wave.pred<"x >= 0">, #wave.pred<"x <= 31">] : !wave.simd<i32, 32>
  %off = wave.index_expr <"xor(lid, 31)"> ["lid"](%lane)
      : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
  %ptrs = wave.ptr_add %out, %off
      : !wave.ptr<#wave.global, i32>, !wave.simd<index, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %vx = wave.splat %x : i32 -> !wave.simd<i32, 32>
  %tok = wave.store %vx -> %ptrs
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.global, i32>, 32>)
      -> !wave.mem.token
  return
}

// CHECK-LABEL: func.func @xor_uniform_buffer_soffset
// CHECK-DAG: %[[U:.*]] = waveamdmachine.arg {index = 1 : i64, pointer = false}
// CHECK-DAG: %[[LANE:.*]] = waveamdmachine.v_mbcnt_lo
// CHECK: %[[VBYTE:.*]] = waveamdmachine.v_lshlrev_b32 %[[LANE]],
// CHECK: %[[SXOR:[^,]+]], %{{.*}} = waveamdmachine.s_xor_b32 {{.*}}, %[[U]]
// CHECK: %[[SOFFSET:[^,]+]], %{{.*}} = waveamdmachine.s_lshl_b32 %[[SXOR]],
// CHECK: waveamdmachine.buffer_store_b32 %[[VBYTE]], {{.*}}, {{.*}}, %[[SOFFSET]]
func.func @xor_uniform_buffer_soffset(%out: !wave.ptr<#wave.global, i32>, %u_raw: i32) attributes {wave.kernel} {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %u = wave.assume %u_raw as "x" [#wave.pred<"x >= 0">, #wave.pred<"x <= 31">] : i32
  %range = arith.constant 1024 : i32
  %buf = waveamd.make_buffer %out, %range
      : !wave.ptr<#wave.global, i32>, i32 -> !wave.ptr<#waveamd.buffer, i32>
  %off = wave.index_expr <"lid + xor(u, 31)"> ["lid", "u"](%lane, %u)
      : (!wave.simd<i32, 32>, i32) -> !wave.simd<index, 32>
  %ptrs = wave.ptr_add %buf, %off
      : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<index, 32>
      -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>
  %vx = wave.splat %u : i32 -> !wave.simd<i32, 32>
  %tok = wave.store %vx -> %ptrs
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>)
      -> !wave.mem.token
  return
}

// CHECK-LABEL: func.func @buffer_subset_packs_uniform_slots
// CHECK-DAG: %[[U:.*]] = waveamdmachine.arg {index = 1 : i64, pointer = false}
// CHECK-DAG: %[[V:.*]] = waveamdmachine.arg {index = 2 : i64, pointer = false}
// CHECK-DAG: %[[LANE:.*]] = waveamdmachine.v_mbcnt_lo
// CHECK: %[[VSCALE:[^,]+]], %{{.*}} = waveamdmachine.s_lshl_b32 %[[V]],
// CHECK: %[[VBYTE:.*]] = waveamdmachine.v_lshlrev_b32 %[[LANE]],
// CHECK: %[[VOFFSET:.*]] = waveamdmachine.v_add_u32 %[[VSCALE]], %[[VBYTE]]
// CHECK: %[[USCALE:[^,]+]], %{{.*}} = waveamdmachine.s_lshl_b32 %[[U]],
// CHECK: waveamdmachine.buffer_store_b32 %[[VOFFSET]], {{.*}}, {{.*}}, %[[USCALE]]
func.func @buffer_subset_packs_uniform_slots(%out: !wave.ptr<#wave.global, i32>,
                                             %u_raw: i32, %v_raw: i32) attributes {wave.kernel} {
  %lane_raw = wave.lane_id : !wave.simd<i32, 32>
  %lane = wave.assume %lane_raw as "x" [#wave.pred<"x >= 0">, #wave.pred<"x <= 31">] : !wave.simd<i32, 32>
  %u = wave.assume %u_raw as "x" [#wave.pred<"x >= 0">, #wave.pred<"x <= 1073741823">] : i32
  %v = wave.assume %v_raw as "x" [#wave.pred<"x >= 0">, #wave.pred<"x <= 1073741791">] : i32
  %range = arith.constant 4096 : i32
  %buf = waveamd.make_buffer %out, %range
      : !wave.ptr<#wave.global, i32>, i32 -> !wave.ptr<#waveamd.buffer, i32>
  %off = wave.index_expr <"lid + u + v"> ["lid", "u", "v"](%lane, %u, %v)
      : (!wave.simd<i32, 32>, i32, i32) -> !wave.simd<index, 32>
  %ptrs = wave.ptr_add %buf, %off
      : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<index, 32>
      -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>
  %vx = wave.splat %u : i32 -> !wave.simd<i32, 32>
  %tok = wave.store %vx -> %ptrs
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>)
      -> !wave.mem.token
  return
}

// CHECK-LABEL: func.func @uniform_depth_order
// CHECK-DAG: %[[OUTER:.*]] = waveamdmachine.arg {index = 1 : i64, pointer = false}
// CHECK: %[[LOOP:.*]] = waveamdmachine.uniform_loop
// CHECK: ^bb0(%[[IV:.*]]: !waveamdmachine.reg<sgpr, 1>):
// CHECK: %[[VBYTE:.*]] = waveamdmachine.v_lshlrev_b32
// CHECK: %[[OUTER_BYTE:[^,]+]], %{{.*}} = waveamdmachine.s_lshl_b32 %[[OUTER]],
// CHECK: %[[IV_BYTE:[^,]+]], %{{.*}} = waveamdmachine.s_lshl_b32 %[[IV]],
// CHECK: %[[SOFFSET:[^,]+]], %{{.*}} = waveamdmachine.s_add_i32 %[[OUTER_BYTE]], %[[IV_BYTE]]
// CHECK: waveamdmachine.buffer_store_b32 %[[VBYTE]], {{.*}}, {{.*}}, %[[SOFFSET]]
func.func @uniform_depth_order(%out: !wave.ptr<#wave.global, i32>,
                               %outer_raw: i32, %n: i32) attributes {wave.kernel} {
  %c0 = arith.constant 0 : i32
  %c1 = arith.constant 1 : i32
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %outer = wave.assume %outer_raw as "x" [#wave.pred<"x >= 0">, #wave.pred<"x <= 1023">] : i32
  %range = arith.constant 4096 : i32
  %buf = waveamd.make_buffer %out, %range
      : !wave.ptr<#wave.global, i32>, i32 -> !wave.ptr<#waveamd.buffer, i32>
  scf.for %i = %c0 to %n step %c1 : i32 {
    %iv = wave.assume %i as "x" [#wave.pred<"x >= 0">, #wave.pred<"x <= 1023">] : i32
    %off = wave.index_expr <"lid + iv + outer"> ["iv", "lid", "outer"](%iv, %lane, %outer)
        : (i32, !wave.simd<i32, 32>, i32) -> !wave.simd<index, 32>
    %ptrs = wave.ptr_add %buf, %off
        : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<index, 32>
        -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>
    %tok = wave.store %lane -> %ptrs
        : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>)
        -> !wave.mem.token
  }
  return
}

}
