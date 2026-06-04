// RUN: wave-translate --wave-to-amdgpu-asm %s | FileCheck %s
// RUN: wave-translate --wave-to-amdgpu-asm %s | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx1100 -filetype=obj -o /dev/null
// RUN: wave-translate --wave-to-amdgpu-asm %s | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx1100 -filetype=obj -o %t.o
// RUN: ld.lld -shared %t.o -o %t.hsaco
// RUN: llvm-readelf --notes %t.hsaco | FileCheck %s --check-prefix=NOTE

// CHECK: .amdgcn_target "amdgcn-amd-amdhsa--gfx1100"
// CHECK-LABEL: wave_add:
func.func @wave_add(%x: i32) -> i32 {
  // CHECK: wave backend: WaveAMDMachine MLIR pipeline finalized
  // CHECK: v_mbcnt_lo_u32_b32 [[LANE:v[0-9]+]], -1, 0
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %vx = wave.splat %x : i32 -> !wave.simd<i32, 32>
  // CHECK: v_add_nc_u32_e32 [[SUM:v[0-9]+]], [[ARG:s[0-9]+]], [[LANE]]
  %sum = wave.addi %lane, %vx : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  // CHECK: v_readfirstlane_b32 s0, [[SUM]]
  %first = wave.read_first %sum : !wave.simd<i32, 32> -> i32
  // CHECK: s_setpc_b64 s[30:31]
  return %first : i32
}

// CHECK-LABEL: wave_where:
func.func @wave_where(%limit: i32, %out: !wave.ptr<#wave.global, i32>) -> i32 {
  // CHECK: v_mbcnt_lo_u32_b32 [[LANE:v[0-9]+]], -1, 0
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %vlimit = wave.splat %limit : i32 -> !wave.simd<i32, 32>
  %ptrs = wave.ptr_add %out, %lane : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32> -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  // CHECK: v_cmp_lt_u32_e64 [[MASK:s[0-9]+]], [[LANE]], [[ARG:s[0-9]+]]
  %active = wave.cmpi ult %lane, %vlimit : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  // CHECK: s_and_saveexec_b32 [[SAVE:s[0-9]+]], [[MASK]]
  // CHECK: s_cbranch_execz [[END:.Lwave_wave_where_exec_endif_[0-9]+]]
  wave.where %active {
    // CHECK: v_add_nc_u32_e32
    %sum = wave.addi %lane, %vlimit : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
    %t = wave.store %sum -> %ptrs : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.global, i32>, 32>) -> !wave.mem.token
    wave.yield
  } : !wave.mask<32>
  // CHECK: [[END]]:
  // CHECK: s_mov_b32 exec_lo, [[SAVE]]
  %bits = wave.ballot %active : !wave.mask<32> -> i32
  // CHECK: s_mov_b32 s0,
  return %bits : i32
}

// CHECK-LABEL: wave_where_else:
func.func @wave_where_else(%limit: i32, %out: !wave.ptr<#wave.global, i32>) -> i32 {
  // CHECK: v_mbcnt_lo_u32_b32 [[LANE:v[0-9]+]], -1, 0
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %vlimit = wave.splat %limit : i32 -> !wave.simd<i32, 32>
  %ptrs = wave.ptr_add %out, %lane : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32> -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  // CHECK: v_cmp_lt_u32_e64 [[MASK:s[0-9]+]], [[LANE]], [[ARG:s[0-9]+]]
  %active = wave.cmpi ult %lane, %vlimit : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  // CHECK: s_and_saveexec_b32 [[SAVE:s[0-9]+]], [[MASK]]
  // CHECK: s_cbranch_execz [[ELSE:.Lwave_wave_where_else_exec_else_[0-9]+]]
  wave.where %active {
    // CHECK: v_add_nc_u32_e32
    %then = wave.addi %lane, %vlimit : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
    %t0 = wave.store %then -> %ptrs : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.global, i32>, 32>) -> !wave.mem.token
    wave.yield
  } otherwise {
    // CHECK: [[ELSE]]:
    // CHECK: s_and_not1_b32 exec_lo, [[SAVE]], [[MASK]]
    // CHECK: v_xor_b32_e32
    %else = wave.binary "xori" %lane, %vlimit : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
    %t1 = wave.store %else -> %ptrs : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.global, i32>, 32>) -> !wave.mem.token
    wave.yield
  } : !wave.mask<32>
  // CHECK: s_mov_b32 exec_lo, [[SAVE]]
  %bits = wave.ballot %active : !wave.mask<32> -> i32
  return %bits : i32
}

// CHECK-LABEL: wave_kernel:
func.func @wave_kernel(%out: !wave.ptr<#wave.global, i32>, %x: i32) attributes {wave.kernel} {
  // CHECK: s_load_b32 [[X:s[0-9]+]], s[0:1], 0x8
  // CHECK: s_load_b64 [[OUT:s\[[0-9]+:[0-9]+\]]], s[0:1], 0x0
  // CHECK: v_mbcnt_lo_u32_b32 [[LANE:v[0-9]+]], -1, 0
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %vx = wave.splat %x : i32 -> !wave.simd<i32, 32>
  // CHECK: s_waitcnt lgkmcnt(0)
  // CHECK: s_delay_alu instid0(VALU_DEP_1)
  // CHECK: v_add_nc_u32_e32 [[SUM:v[0-9]+]], [[X]], [[LANE]]
  %sum = wave.addi %lane, %vx : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  // CHECK: v_lshlrev_b32_e32 [[OFFSET:v[0-9]+]], 2, [[LANE]]
  // CHECK: global_store_b32 [[OFFSET]], [[SUM]], [[OUT]]
  %ptrs = wave.ptr_add %out, %lane : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32> -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %store_token = wave.store %sum -> %ptrs : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.global, i32>, 32>) -> !wave.mem.token
  // CHECK: s_waitcnt_vscnt null, 0x0
  // CHECK: s_endpgm
  return
}
// CHECK: .amdhsa_kernel wave_kernel

// `wave.binary "shri"` lowers to v_lshrrev_b32 (VOP2; shift goes in
// src0, value in vsrc1 -- mirroring shli). `wave.muli` lowers
// to v_mul_lo_u32 (VOP3, no operand-placement constraints).
// CHECK-LABEL: wave_shri_muli:
func.func @wave_shri_muli(%x: i32) -> i32 {
  // CHECK: v_mbcnt_lo_u32_b32 [[LANE:v[0-9]+]], -1, 0
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %vx = wave.splat %x : i32 -> !wave.simd<i32, 32>
  // CHECK: v_lshrrev_b32_e32 [[SHIFTED:v[0-9]+]],
  %shifted = wave.binary "shri" %lane, %vx : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  // CHECK: v_mul_lo_u32 [[MULLED:v[0-9]+]], [[SHIFTED]],
  %mulled = wave.muli %shifted, %vx : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %first = wave.read_first %mulled : !wave.simd<i32, 32> -> i32
  return %first : i32
}

// A barrier with no dependencies emits a bare `s_barrier`. With
// dependencies on prior LDS stores the waitcnt pass inserts an
// `s_waitcnt lgkmcnt(0)` ahead of the barrier.
// CHECK-LABEL: wave_lds_echo:
func.func @wave_lds_echo(%out: !wave.ptr<#wave.global, i32>)
    attributes {wave.kernel, wave.lds_size = 128 : i64} {
  // CHECK: v_mbcnt_lo_u32_b32 [[LANE:v[0-9]+]], -1, 0
  %lane = wave.lane_id : !wave.simd<i32, 32>
  // CHECK: v_lshlrev_b32_e32 [[BYTE:v[0-9]+]], 2, [[LANE]]
  %lds = wave.lds_base : !wave.ptr<#wave.shared, i32>
  %lds_ptrs = wave.ptr_add %lds, %lane : !wave.ptr<#wave.shared, i32>, !wave.simd<i32, 32> -> !wave.simd<!wave.ptr<#wave.shared, i32>, 32>
  // CHECK: ds_store_b32 [[BYTE]], [[LANE]]
  %store_token = wave.store %lane -> %lds_ptrs : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.shared, i32>, 32>) -> !wave.mem.token
  // CHECK: s_waitcnt lgkmcnt(0)
  // CHECK: s_barrier
  %barrier_token = wave.barrier %store_token : (!wave.mem.token) -> !wave.mem.token
  // CHECK: ds_load_b32 [[VAL:v[0-9]+]], [[BYTE]]
  %loaded:2 = wave.load %lds_ptrs after %barrier_token : (!wave.simd<!wave.ptr<#wave.shared, i32>, 32>, !wave.mem.token) -> (!wave.simd<i32, 32>, !wave.mem.token)
  // CHECK: global_store_b32 [[BYTE]], [[VAL]]
  %out_ptrs = wave.ptr_add %out, %lane : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32> -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %final_token = wave.store %loaded#0 -> %out_ptrs : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.global, i32>, 32>) -> !wave.mem.token
  return
}
// CHECK: .amdhsa_kernel wave_lds_echo
// CHECK: .amdhsa_group_segment_fixed_size 128

// Tuple-width shared memory lowers to wide chunks with byte offsets
// folded into each instruction.
// CHECK-LABEL: wave_lds_tuple_echo:
func.func @wave_lds_tuple_echo(%in: !wave.ptr<#wave.global, i32>,
                               %out: !wave.ptr<#wave.global, i32>)
    attributes {wave.kernel, wave.lds_size = 1024 : i64} {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %ip = wave.ptr_add %in, %lane : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32> -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  // CHECK: global_load_b128
  // CHECK: global_load_b128
  %v, %tok = wave.load %ip : (!wave.simd<!wave.ptr<#wave.global, i32>, 32>) -> (!wave.simd<vector<8xi32>, 32>, !wave.mem.token)
  %lds = wave.lds_base : !wave.ptr<#wave.shared, i32>
  %lds_ptrs = wave.ptr_add %lds, %lane : !wave.ptr<#wave.shared, i32>, !wave.simd<i32, 32> -> !wave.simd<!wave.ptr<#wave.shared, i32>, 32>
  // CHECK: ds_store_b128 {{v[0-9]+}}, {{v\[[0-9]+:[0-9]+\]}}
  // CHECK: ds_store_b128 {{v[0-9]+}}, {{v\[[0-9]+:[0-9]+\]}} offset:16
  %store_token = wave.store %v -> %lds_ptrs after %tok : (!wave.simd<vector<8xi32>, 32>, !wave.simd<!wave.ptr<#wave.shared, i32>, 32>, !wave.mem.token) -> !wave.mem.token
  // CHECK: s_waitcnt lgkmcnt(0)
  // CHECK: s_barrier
  %barrier_token = wave.barrier %store_token : (!wave.mem.token) -> !wave.mem.token
  // CHECK: ds_load_b128 {{v\[[0-9]+:[0-9]+\]}}, {{v[0-9]+}}
  // CHECK: ds_load_b128 {{v\[[0-9]+:[0-9]+\]}}, {{v[0-9]+}} offset:16
  %loaded:2 = wave.load %lds_ptrs after %barrier_token : (!wave.simd<!wave.ptr<#wave.shared, i32>, 32>, !wave.mem.token) -> (!wave.simd<vector<8xi32>, 32>, !wave.mem.token)
  %op = wave.ptr_add %out, %lane : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32> -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %frag = waveamd.fragment_pack %loaded#0 : !wave.simd<vector<8xi32>, 32> -> !waveamd.fragment<2, f32, 16, 16, 32, 8>
  %r = arith.constant 8 : i32
  %r_simd = wave.splat %r : i32 -> !wave.simd<i32, 32>
  %lane_off = wave.muli %lane, %r_simd : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %tuple_op = wave.ptr_add %op, %lane_off : !wave.simd<!wave.ptr<#wave.global, i32>, 32>, !wave.simd<i32, 32> -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %regs = waveamd.fragment_unpack %frag : !waveamd.fragment<2, f32, 16, 16, 32, 8> -> !wave.simd<vector<8xi32>, 32>
  %final_token = wave.store %regs -> %tuple_op after %loaded#1 : (!wave.simd<vector<8xi32>, 32>, !wave.simd<!wave.ptr<#wave.global, i32>, 32>, !wave.mem.token) -> !wave.mem.token
  return
}
// CHECK: .amdhsa_kernel wave_lds_tuple_echo
// CHECK: .amdhsa_group_segment_fixed_size 1024

// A tuple-width wave.load through a buffer pointer lowers to N
// consecutive buffer_load_dword instructions sharing the same VGPR
// vaddr and SGPR descriptor, with `offset:i*4` folded into each.
// CHECK-LABEL: wave_buffer_tuple_load:
func.func @wave_buffer_tuple_load(%in: !wave.ptr<#wave.global, i32>,
                                  %out: !wave.ptr<#wave.global, i32>)
    attributes {wave.kernel} {
  %range = arith.constant 1024 : i32
  %buffer = waveamd.make_buffer %in, %range : !wave.ptr<#wave.global, i32>, i32 -> !wave.ptr<#waveamd.buffer, i32>
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %iptrs = wave.ptr_add %buffer, %lane : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<i32, 32> -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>
  // CHECK: buffer_load_b128 v{{\[[0-9]+:[0-9]+\]}}, {{v[0-9]+}}, {{s\[[0-9]+:[0-9]+\]}}, 0 offen{{$}}
  // CHECK: buffer_load_b128 v{{\[[0-9]+:[0-9]+\]}}, {{v[0-9]+}}, {{s\[[0-9]+:[0-9]+\]}}, 0 offen offset:16
  %v, %tok = wave.load %iptrs : (!wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>) -> (!wave.simd<vector<8xi32>, 32>, !wave.mem.token)
  %optrs = wave.ptr_add %out, %lane : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32> -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %frag = waveamd.fragment_pack %v : !wave.simd<vector<8xi32>, 32> -> !waveamd.fragment<2, f32, 16, 16, 32, 8>
  %r = arith.constant 8 : i32
  %r_simd = wave.splat %r : i32 -> !wave.simd<i32, 32>
  %lane_off = wave.muli %lane, %r_simd : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %tuple_optrs = wave.ptr_add %optrs, %lane_off : !wave.simd<!wave.ptr<#wave.global, i32>, 32>, !wave.simd<i32, 32> -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %regs = waveamd.fragment_unpack %frag : !waveamd.fragment<2, f32, 16, 16, 32, 8> -> !wave.simd<vector<8xi32>, 32>
  %final_token = wave.store %regs -> %tuple_optrs after %tok : (!wave.simd<vector<8xi32>, 32>, !wave.simd<!wave.ptr<#wave.global, i32>, 32>, !wave.mem.token) -> !wave.mem.token
  return
}

// Two back-to-back global tuple loads followed by two LDS stores must
// emit nonzero `vmcnt` before the first `ds_store_b128`, leaving the
// second load's chunks in flight while the first drains.
//
// The post-emission cleanup must also collapse the run of waitcnts
// the per-op emission inserts: each block of 8 dword issues from a
// tuple gets *one* `s_waitcnt` ahead of it, never one per dword. The
// schedule below pins exactly four s_waitcnt lines in the kernel
// body (lgkmcnt(0), vmcnt(2), vmcnt(0), and the trailing
// vscnt flush), so any future regression that re-introduces a
// per-dword `s_waitcnt lgkmcnt(N)` between the 8 `ds_store_b32`s
// will surface here.
// CHECK-LABEL: wave_two_tuple_loads_overlap:
func.func @wave_two_tuple_loads_overlap(%a_in: !wave.ptr<#wave.global, i32>,
                                        %b_in: !wave.ptr<#wave.global, i32>)
    attributes {wave.kernel, wave.lds_size = 2048 : i64} {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %ap = wave.ptr_add %a_in, %lane : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32> -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %bp = wave.ptr_add %b_in, %lane : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32> -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %lds = wave.lds_base : !wave.ptr<#wave.shared, i32>
  %slot_a = wave.ptr_add %lds, %lane : !wave.ptr<#wave.shared, i32>, !wave.simd<i32, 32> -> !wave.simd<!wave.ptr<#wave.shared, i32>, 32>
  %c256 = arith.constant 256 : i32
  %c256v = wave.splat %c256 : i32 -> !wave.simd<i32, 32>
  %slot_b_off = wave.addi %lane, %c256v : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %slot_b = wave.ptr_add %lds, %slot_b_off : !wave.ptr<#wave.shared, i32>, !wave.simd<i32, 32> -> !wave.simd<!wave.ptr<#wave.shared, i32>, 32>
  // CHECK: s_waitcnt lgkmcnt(0)
  // CHECK-NEXT: global_load_b128 {{v\[[0-9]+:[0-9]+\], v[0-9]+, s\[6:7\]$}}
  // CHECK-NEXT: global_load_b128 {{.*}} s[6:7] offset
  // CHECK-NEXT: global_load_b128 {{v\[[0-9]+:[0-9]+\], v[0-9]+, s\[8:9\]$}}
  // CHECK-NEXT: global_load_b128 {{.*}} s[8:9] offset
  // CHECK-NOT: ds_store_b128
  // CHECK: s_waitcnt vmcnt(2)
  %a_regs, %a_tok = wave.load %ap : (!wave.simd<!wave.ptr<#wave.global, i32>, 32>) -> (!wave.simd<vector<8xi32>, 32>, !wave.mem.token)
  %b_regs, %b_tok = wave.load %bp : (!wave.simd<!wave.ptr<#wave.global, i32>, 32>) -> (!wave.simd<vector<8xi32>, 32>, !wave.mem.token)
  // CHECK-NEXT: ds_store_b128 {{v[0-9]+, v\[[0-9]+:[0-9]+\]$}}
  // CHECK-NEXT: ds_store_b128 {{v[0-9]+, v\[[0-9]+:[0-9]+\]}} offset
  // CHECK-NEXT: s_waitcnt vmcnt(0)
  %a_st = wave.store %a_regs -> %slot_a after %a_tok : (!wave.simd<vector<8xi32>, 32>, !wave.simd<!wave.ptr<#wave.shared, i32>, 32>, !wave.mem.token) -> !wave.mem.token
  // CHECK-NEXT: ds_store_b128 {{v[0-9]+, v\[[0-9]+:[0-9]+\]$}}
  // CHECK-NEXT: ds_store_b128 {{v[0-9]+, v\[[0-9]+:[0-9]+\]}} offset
  %b_st = wave.store %b_regs -> %slot_b after %b_tok : (!wave.simd<vector<8xi32>, 32>, !wave.simd<!wave.ptr<#wave.shared, i32>, 32>, !wave.mem.token) -> !wave.mem.token
  return
}

// NOTE: NT_AMDGPU_METADATA
// NOTE: amdhsa.kernels:
// NOTE: .name:           wave_kernel
// NOTE: .symbol:         wave_kernel.kd
// NOTE: amdhsa.target:   amdgcn-amd-amdhsa--gfx1100
