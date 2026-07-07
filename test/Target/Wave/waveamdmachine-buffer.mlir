// RUN: wave-opt --waveamd-to-machine %s | FileCheck %s --check-prefix=SELECT
// RUN: wave-opt --waveamd-to-machine %s | wave-opt | FileCheck %s --check-prefix=SELECT
// RUN: wave-opt %s --pass-pipeline='builtin.module(waveamd-to-machine,waveamd-buffer-rsrc-to-tuples,waveamd-abi-lowering,transform-preload-library{transform-library-paths=%wave_pipelines},transform-interpreter{entry-point=waveamd_regalloc_transform_loop})' | FileCheck %s --check-prefix=PIPELINE
// RUN: wave-opt --waveamd-to-machine --waveamd-buffer-rsrc-to-tuples %s | wave-translate --wave-to-amdgpu-asm - | FileCheck %s --check-prefix=ASM
// RUN: wave-opt --waveamd-to-machine --waveamd-buffer-rsrc-to-tuples %s | wave-translate --wave-to-amdgpu-asm - | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx1100 -filetype=obj -o /dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// SELECT-LABEL: func.func @buffer_store_kernel
// SELECT: waveamdmachine.arg {index = 0 : i64, pointer = true} : !waveamdmachine.reg<sgpr, 2>
// SELECT: waveamdmachine.make_buffer_rsrc
// SELECT: waveamdmachine.buffer_store_b32

// PIPELINE-LABEL: func.func @buffer_store_kernel
// PIPELINE: waveamdmachine.s_load_b64
// PIPELINE: waveamdmachine.tuple_from_elements
// PIPELINE: {{^ *}}%{{.*}} = waveamdmachine.buffer_store_b32
// PIPELINE-SAME: !waveamdmachine.reg<sgpr, 4,

// ASM-LABEL: buffer_store_kernel:
// ASM: s_load_b64
// ASM: s_mov_b32
// ASM: buffer_store_b32 {{v[0-9]+}}, {{v[0-9]+}}, {{s\[[0-9]+:[0-9]+\]}}, 0 offen
func.func @buffer_store_kernel(%out: !wave.ptr<#wave.global, i32>, %x: i32) attributes {wave.kernel} {
  %range = arith.constant 128 : i32
  %buffer = waveamd.make_buffer %out, %range : !wave.ptr<#wave.global, i32>, i32 -> !wave.ptr<#waveamd.buffer, i32>
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %vx = wave.splat %x : i32 -> !wave.simd<i32, 32>
  %sum = wave.binary addi %lane, %vx : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %ptrs = wave.ptr_add %buffer, %lane : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<i32, 32> -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>
  %store_token = wave.store %sum -> %ptrs : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>) -> !wave.mem.token
  return
}

// SELECT-LABEL: func.func @buffer_make_buffer_uniform_base_offset
// SELECT: %[[WG:.*]] = waveamdmachine.s_workgroup_id_x
// SELECT: %[[SHIFT:.*]] = waveamdmachine.imm 10 : !waveamdmachine.imm
// SELECT: %[[BASE_OFF:[^,]+]], %{{.*}} = waveamdmachine.s_lshl_b32 %[[WG]], %[[SHIFT]]
// SELECT-NOT: waveamdmachine.tuple_from_elements %[[BASE_OFF]]
// SELECT: %[[SRD_BASE:.*]], %{{.*}} = waveamdmachine.s_add_u64_u32 {{.*}}, %[[BASE_OFF]]
// SELECT: %[[DESC:.*]] = waveamdmachine.make_buffer_rsrc %[[SRD_BASE]]
// SELECT: %[[ZERO:.*]] = waveamdmachine.imm 0
// SELECT: waveamdmachine.buffer_store_b32 {{.*}}, {{.*}}, %[[DESC]], %[[ZERO]]
func.func @buffer_make_buffer_uniform_base_offset(%out: !wave.ptr<#wave.global, i32>)
    attributes {wave.kernel} {
  %range = arith.constant 1024 : i32
  %wg_raw = wave.workgroup_id 0
  %wg = wave.assume %wg_raw as "x" [#wave.pred<"x >= 0">, #wave.pred<"x <= 1023">] : i32
  %tile = wave.index_expr <"256*wg"> ["wg"](%wg) : (i32) -> index
  %base = wave.ptr_add %out, %tile
      : !wave.ptr<#wave.global, i32>, index -> !wave.ptr<#wave.global, i32>
  %buffer = waveamd.make_buffer %base, %range
      : !wave.ptr<#wave.global, i32>, i32 -> !wave.ptr<#waveamd.buffer, i32>
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %ptrs = wave.ptr_add %buffer, %lane
      : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>
  %tok = wave.store %lane -> %ptrs
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>)
      -> !wave.mem.token
  return
}

// SELECT-LABEL: func.func @buffer_make_buffer_wide_base_offset
// SELECT: %[[WIDE_OFF:.*]] = waveamdmachine.s_mov_b64_imm 4294967296
// SELECT-NOT: waveamdmachine.s_add_u64_u32
// SELECT: %[[SRD_BASE:.*]], %{{.*}} = waveamdmachine.s_add_u64 {{.*}}, %[[WIDE_OFF]]
// SELECT: %[[DESC:.*]] = waveamdmachine.make_buffer_rsrc %[[SRD_BASE]]
// SELECT: waveamdmachine.buffer_store_b32 {{.*}}, {{.*}}, %[[DESC]]
func.func @buffer_make_buffer_wide_base_offset(%out: !wave.ptr<#wave.global, i32>)
    attributes {wave.kernel} {
  %range = arith.constant 1024 : i32
  %tile = wave.index_expr <"1073741824"> []() : () -> index
  %base = wave.ptr_add %out, %tile
      : !wave.ptr<#wave.global, i32>, index -> !wave.ptr<#wave.global, i32>
  %buffer = waveamd.make_buffer %base, %range
      : !wave.ptr<#wave.global, i32>, i32 -> !wave.ptr<#waveamd.buffer, i32>
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %ptrs = wave.ptr_add %buffer, %lane
      : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>
  %tok = wave.store %lane -> %ptrs
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>)
      -> !wave.mem.token
  return
}

// SELECT-LABEL: func.func @buffer_bounded_raw_uniform_uses_soffset
// SELECT-DAG: %[[U:.*]] = waveamdmachine.arg {index = 1 : i64, pointer = false}
// SELECT-DAG: %[[LANE:.*]] = waveamdmachine.v_mbcnt_lo
// SELECT: %[[SBYTE:[^,]+]], %{{.*}} = waveamdmachine.s_lshl_b32 %[[U]],
// SELECT: waveamdmachine.buffer_store_b32 %{{.*}}, {{.*}}, {{.*}}, %[[SBYTE]]
func.func @buffer_bounded_raw_uniform_uses_soffset(%out: !wave.ptr<#wave.global, i32>, %u_raw: i32) attributes {wave.kernel} {
  %u = wave.assume %u_raw as "x" [#wave.pred<"x >= 0">, #wave.pred<"x <= 1023">] : i32
  %range = arith.constant 4096 : i32
  %buffer = waveamd.make_buffer %out, %range
      : !wave.ptr<#wave.global, i32>, i32 -> !wave.ptr<#waveamd.buffer, i32>
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %ptr = wave.ptr_add %buffer, %u
      : !wave.ptr<#waveamd.buffer, i32>, i32 -> !wave.ptr<#waveamd.buffer, i32>
  %ptrs = wave.ptr_add %ptr, %lane
      : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>
  %tok = wave.store %lane -> %ptrs
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>)
      -> !wave.mem.token
  return
}

// SELECT-LABEL: func.func @buffer_const_soffset_materializes_sgpr
// SELECT-DAG: %[[SOIMM:.*]] = waveamdmachine.imm 4096 : !waveamdmachine.imm
// SELECT-DAG: %[[SOFFSET:.*]] = waveamdmachine.s_mov_b32_value %[[SOIMM]]
// SELECT: waveamdmachine.buffer_load_b32 {{.*}}, {{.*}}, %[[SOFFSET]]
// SELECT-DAG: %[[SOIMM_STORE:.*]] = waveamdmachine.imm 4096 : !waveamdmachine.imm
// SELECT-DAG: %[[SOFFSET_STORE:.*]] = waveamdmachine.s_mov_b32_value %[[SOIMM_STORE]]
// SELECT: waveamdmachine.buffer_store_b32 {{.*}}, {{.*}}, {{.*}}, %[[SOFFSET_STORE]]

// ASM-LABEL: buffer_const_soffset_materializes_sgpr:
// ASM: s_mov_b32 [[SOFFSET:s[0-9]+]], 0x1000
// ASM: buffer_load_b32 {{v[0-9]+}}, {{v[0-9]+}}, {{s\[[0-9]+:[0-9]+\]}}, [[SOFFSET]] offen
// ASM: buffer_store_b32 {{v[0-9]+}}, {{v[0-9]+}}, {{s\[[0-9]+:[0-9]+\]}}, [[SOFFSET]] offen
func.func @buffer_const_soffset_materializes_sgpr(
    %in: !wave.ptr<#wave.global, i32>, %out: !wave.ptr<#wave.global, i32>)
    attributes {wave.kernel} {
  %range = arith.constant 8192 : i32
  %in_buffer = waveamd.make_buffer %in, %range
      : !wave.ptr<#wave.global, i32>, i32 -> !wave.ptr<#waveamd.buffer, i32>
  %out_buffer = waveamd.make_buffer %out, %range
      : !wave.ptr<#wave.global, i32>, i32 -> !wave.ptr<#waveamd.buffer, i32>
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %off = wave.index_expr <"1024 + lid"> ["lid"](%lane)
      : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
  %in_ptrs = wave.ptr_add %in_buffer, %off
      : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<index, 32>
      -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>
  %v, %tok = wave.load %in_ptrs
      : (!wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>)
      -> (!wave.simd<i32, 32>, !wave.mem.token)
  %out_ptrs = wave.ptr_add %out_buffer, %off
      : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<index, 32>
      -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>
  %store_token = wave.store %v -> %out_ptrs after %tok
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>,
         !wave.mem.token)
      -> !wave.mem.token
  return
}

// Single-dword `wave.load` through a buffer pointer: the selector lowers
// it to `waveamdmachine.buffer_load_b32`, and the AMDGPU printer emits a
// `buffer_load_dword ..., 0 offen` (no offset suffix for component 0).
// SELECT-LABEL: func.func @buffer_load_kernel
// SELECT: waveamdmachine.make_buffer_rsrc
// SELECT: waveamdmachine.buffer_load_b32

// PIPELINE-LABEL: func.func @buffer_load_kernel
// PIPELINE: {{^ *}}%{{.*}} = waveamdmachine.buffer_load_b32
// PIPELINE-SAME: !waveamdmachine.reg<sgpr, 4,
// PIPELINE: waveamdmachine.global_store_b32

// ASM-LABEL: buffer_load_kernel:
// ASM: buffer_load_b32 {{v[0-9]+}}, {{v[0-9]+}}, {{s\[[0-9]+:[0-9]+\]}}, 0 offen
// ASM-NOT: offset:
// ASM: s_waitcnt {{.*}}vmcnt
// ASM: global_store_b32
func.func @buffer_load_kernel(%in: !wave.ptr<#wave.global, i32>, %out: !wave.ptr<#wave.global, i32>) attributes {wave.kernel} {
  %range = arith.constant 128 : i32
  %buffer = waveamd.make_buffer %in, %range : !wave.ptr<#wave.global, i32>, i32 -> !wave.ptr<#waveamd.buffer, i32>
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %iptrs = wave.ptr_add %buffer, %lane : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<i32, 32> -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>
  %v, %tok = wave.load %iptrs : (!wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>) -> (!wave.simd<i32, 32>, !wave.mem.token)
  %optrs = wave.ptr_add %out, %lane : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32> -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %store_token = wave.store %v -> %optrs after %tok : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.global, i32>, 32>, !wave.mem.token) -> !wave.mem.token
  return
}

// Tuple `wave.load` (8 dwords) through a buffer pointer: the selector
// folds it into a single `waveamdmachine.buffer_load_tuple_b32`, which the
// AMDGPU printer expands into eight consecutive `buffer_load_dword`
// instructions with `offset:i*4` immediates.
// SELECT-LABEL: func.func @buffer_load_tuple_kernel
// SELECT: waveamdmachine.make_buffer_rsrc
// SELECT: waveamdmachine.buffer_load_tuple_b32

// ASM-LABEL: buffer_load_tuple_kernel:
// ASM: buffer_load_b128 v{{\[[0-9]+:[0-9]+\]}}, {{v[0-9]+}}, {{s\[[0-9]+:[0-9]+\]}}, 0 offen{{$}}
// ASM: buffer_load_b128 v{{\[[0-9]+:[0-9]+\]}}, {{v[0-9]+}}, {{s\[[0-9]+:[0-9]+\]}}, 0 offen offset:16
// ASM: s_waitcnt {{.*}}vmcnt
func.func @buffer_load_tuple_kernel(%in: !wave.ptr<#wave.global, i32>, %out: !wave.ptr<#wave.global, i32>) attributes {wave.kernel} {
  %range = arith.constant 1024 : i32
  %buffer = waveamd.make_buffer %in, %range : !wave.ptr<#wave.global, i32>, i32 -> !wave.ptr<#waveamd.buffer, i32>
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %iptrs = wave.ptr_add %buffer, %lane : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<i32, 32> -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>
  %v, %tok = wave.load %iptrs : (!wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>) -> (!wave.simd<vector<8xi32>, 32>, !wave.mem.token)
  %optrs = wave.ptr_add %out, %lane : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32> -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %frag = waveamd.fragment_pack %v : !wave.simd<vector<8xi32>, 32> -> !waveamd.fragment<2, f32, 16, 16, 32, 8>
  %r = arith.constant 8 : i32
  %r_simd = wave.splat %r : i32 -> !wave.simd<i32, 32>
  %lane_off = wave.binary muli %lane, %r_simd : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %tuple_ptr = wave.ptr_add %optrs, %lane_off : !wave.simd<!wave.ptr<#wave.global, i32>, 32>, !wave.simd<i32, 32> -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %regs = waveamd.fragment_unpack %frag : !waveamd.fragment<2, f32, 16, 16, 32, 8> -> !wave.simd<vector<8xi32>, 32>
  %store_token = wave.store %regs -> %tuple_ptr after %tok : (!wave.simd<vector<8xi32>, 32>, !wave.simd<!wave.ptr<#wave.global, i32>, 32>, !wave.mem.token) -> !wave.mem.token
  return
}

// SELECT-LABEL: func.func @buffer_selected_oob_load
// SELECT: %[[MASK:.*]] = waveamdmachine.v_cmp_lt_u32
// SELECT: %[[OOB_IMM:.*]] = waveamdmachine.imm 2147483648
// SELECT: %[[ACTIVE:.*]] = waveamdmachine.v_add_u32
// SELECT: %[[OOB:.*]] = waveamdmachine.v_mov_b32_tuple %[[OOB_IMM]]
// SELECT: %[[VOFF:.*]] = waveamdmachine.v_cndmask_b32_tuple %[[OOB]], %[[ACTIVE]], %[[MASK]]
// SELECT-NOT: waveamdmachine.v_cndmask_b32_tuple
// SELECT: %[[ZERO:.*]] = waveamdmachine.imm 0
// SELECT: waveamdmachine.buffer_load_b32 %[[VOFF]], {{.*}}, %[[ZERO]]

// ASM-LABEL: buffer_selected_oob_load:
// ASM: v_mov_b32_e32 [[OOB:v[0-9]+]], 0x80000000
// ASM: v_cndmask_b32_e64 [[VOFF:v[0-9]+]], [[OOB]], [[ACTIVE:v[0-9]+]], {{s[0-9]+}}
// ASM: buffer_load_b32 {{v[0-9]+}}, [[VOFF]], {{s\[[0-9]+:[0-9]+\]}}, 0 offen
func.func @buffer_selected_oob_load(
    %in: !wave.ptr<#wave.global, i32>, %out: !wave.ptr<#wave.global, i32>,
    %raw: i32) attributes {wave.kernel} {
  %range = arith.constant 128 : i32
  %u = wave.assume %raw as "x" [#wave.pred<"x >= 0">, #wave.pred<"x <= 1023">] : i32
  %buffer = waveamd.make_buffer %in, %range
      : !wave.ptr<#wave.global, i32>, i32 -> !wave.ptr<#waveamd.buffer, i32>
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %limit = arith.constant 16 : i32
  %vlimit = wave.splat %limit : i32 -> !wave.simd<i32, 32>
  %mask = wave.cmpi ult %lane, %vlimit
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %active = wave.index_expr <"u + lid"> ["u", "lid"](%u, %lane)
      : (i32, !wave.simd<i32, 32>) -> !wave.simd<index, 32>
  %oob = arith.constant 536870912 : index
  %oob_simd = wave.splat %oob : index -> !wave.simd<index, 32>
  %active_ptr = wave.ptr_add %buffer, %active
      : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<index, 32>
      -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>
  %oob_ptr = wave.ptr_add %buffer, %oob_simd
      : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<index, 32>
      -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>
  %selected = wave.select %mask, %active_ptr, %oob_ptr
      : !wave.mask<32>, !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>
  %v, %tok = wave.load %selected
      : (!wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>)
      -> (!wave.simd<i32, 32>, !wave.mem.token)
  %optrs = wave.ptr_add %out, %lane
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %store_token = wave.store %v -> %optrs after %tok
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.global, i32>, 32>,
         !wave.mem.token)
      -> !wave.mem.token
  return
}

// SELECT-LABEL: func.func @buffer_selected_oob_store
// SELECT: %[[MASK:.*]] = waveamdmachine.v_cmp_lt_u32
// SELECT: %[[OOB_IMM:.*]] = waveamdmachine.imm 2147483648
// SELECT: %[[ACTIVE:.*]] = waveamdmachine.v_add_u32
// SELECT: %[[OOB:.*]] = waveamdmachine.v_mov_b32_tuple %[[OOB_IMM]]
// SELECT: %[[VOFF:.*]] = waveamdmachine.v_cndmask_b32_tuple %[[OOB]], %[[ACTIVE]], %[[MASK]]
// SELECT-NOT: waveamdmachine.v_cndmask_b32_tuple
// SELECT: %[[ZERO:.*]] = waveamdmachine.imm 0
// SELECT: waveamdmachine.buffer_store_b32 %[[VOFF]], {{.*}}, {{.*}}, %[[ZERO]]

// ASM-LABEL: buffer_selected_oob_store:
// ASM: v_mov_b32_e32 [[OOB:v[0-9]+]], 0x80000000
// ASM: v_cndmask_b32_e64 [[VOFF:v[0-9]+]], [[OOB]], [[ACTIVE:v[0-9]+]], {{s[0-9]+}}
// ASM: buffer_store_b32 {{v[0-9]+}}, [[VOFF]], {{s\[[0-9]+:[0-9]+\]}}, 0 offen
func.func @buffer_selected_oob_store(%out: !wave.ptr<#wave.global, i32>,
                                     %raw: i32) attributes {wave.kernel} {
  %range = arith.constant 128 : i32
  %u = wave.assume %raw as "x" [#wave.pred<"x >= 0">, #wave.pred<"x <= 1023">] : i32
  %buffer = waveamd.make_buffer %out, %range
      : !wave.ptr<#wave.global, i32>, i32 -> !wave.ptr<#waveamd.buffer, i32>
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %limit = arith.constant 16 : i32
  %vlimit = wave.splat %limit : i32 -> !wave.simd<i32, 32>
  %mask = wave.cmpi ult %lane, %vlimit
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %active = wave.index_expr <"u + lid"> ["u", "lid"](%u, %lane)
      : (i32, !wave.simd<i32, 32>) -> !wave.simd<index, 32>
  %oob = arith.constant 536870912 : index
  %oob_simd = wave.splat %oob : index -> !wave.simd<index, 32>
  %active_ptr = wave.ptr_add %buffer, %active
      : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<index, 32>
      -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>
  %oob_ptr = wave.ptr_add %buffer, %oob_simd
      : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<index, 32>
      -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>
  %selected = wave.select %mask, %active_ptr, %oob_ptr
      : !wave.mask<32>, !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>
  %tok = wave.store %lane -> %selected
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>)
      -> !wave.mem.token
  return
}

}
