// RUN: wave-translate --wave-to-amdgpu-asm %s | FileCheck %s
// RUN: wave-translate --wave-to-amdgpu-asm %s | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx1100 -filetype=obj -o /dev/null
// RUN: wave-translate --wave-to-amdgpu-asm %s | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx1100 -filetype=obj -o %t.o
// RUN: ld.lld -shared %t.o -o %t.hsaco
// RUN: llvm-readelf --notes %t.hsaco | FileCheck %s --check-prefix=NOTE

// CHECK: .amdgcn_target "amdgcn-amd-amdhsa--gfx1100"
// CHECK-LABEL: wave_add:
func.func @wave_add(%x: i32) -> i32 {
  // CHECK: wave backend: WaveMachine MLIR pipeline finalized
  // CHECK: v_mbcnt_lo_u32_b32 [[LANE:v[0-9]+]], -1, 0
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %vx = wave.splat %x : i32 -> !wave.simd<i32, 32>
  // CHECK: v_add_nc_u32_e32 [[SUM:v[0-9]+]], [[ARG:s[0-9]+]], [[LANE]]
  %sum = wave.binary "addi" %lane, %vx : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  // CHECK: v_readfirstlane_b32 s0, [[SUM]]
  %first = wave.read_first %sum : !wave.simd<i32, 32> -> i32
  // CHECK: s_setpc_b64 s[30:31]
  return %first : i32
}

// CHECK-LABEL: wave_where:
func.func @wave_where(%limit: i32) -> i32 {
  // CHECK: v_mbcnt_lo_u32_b32 [[LANE:v[0-9]+]], -1, 0
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %vlimit = wave.splat %limit : i32 -> !wave.simd<i32, 32>
  // CHECK: v_cmp_lt_u32_e64 [[MASK:s[0-9]+]], [[LANE]], [[ARG:s[0-9]+]]
  %active = wave.cmpi ult %lane, %vlimit : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  // CHECK: s_and_saveexec_b32 [[SAVE:s[0-9]+]], [[MASK]]
  // CHECK: s_cbranch_execz [[END:.Lwave_wave_where_endif_[0-9]+]]
  wave.where %active {
    // CHECK: v_add_nc_u32_e32
    %sum = wave.binary "addi" %lane, %vlimit : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
    wave.yield
  } : !wave.mask<32>
  // CHECK: [[END]]:
  // CHECK: s_mov_b32 exec_lo, [[SAVE]]
  %bits = wave.ballot %active : !wave.mask<32> -> i32
  // CHECK: s_mov_b32 s0,
  return %bits : i32
}

// CHECK-LABEL: wave_where_else:
func.func @wave_where_else(%limit: i32) -> i32 {
  // CHECK: v_mbcnt_lo_u32_b32 [[LANE:v[0-9]+]], -1, 0
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %vlimit = wave.splat %limit : i32 -> !wave.simd<i32, 32>
  // CHECK: v_cmp_lt_u32_e64 [[MASK:s[0-9]+]], [[LANE]], [[ARG:s[0-9]+]]
  %active = wave.cmpi ult %lane, %vlimit : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  // CHECK: s_and_saveexec_b32 [[SAVE:s[0-9]+]], [[MASK]]
  // CHECK: s_cbranch_execz [[ELSE:.Lwave_wave_where_else_else_[0-9]+]]
  wave.where %active {
    // CHECK: v_add_nc_u32_e32
    %then = wave.binary "addi" %lane, %vlimit : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
    wave.yield
  } otherwise {
    // CHECK: s_andn2_b32 exec_lo, [[SAVE]], [[MASK]]
    // CHECK: [[ELSE]]:
    // CHECK: v_xor_b32_e32
    %else = wave.binary "xori" %lane, %vlimit : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
    wave.yield
  } : !wave.mask<32>
  // CHECK: s_mov_b32 exec_lo, [[SAVE]]
  %bits = wave.ballot %active : !wave.mask<32> -> i32
  return %bits : i32
}

// CHECK-LABEL: wave_kernel:
func.func @wave_kernel(%out: !wave.ptr<i32, #wave.global>, %x: i32) attributes {wave.kernel} {
  // CHECK: s_load_b64 [[OUT:s\[[0-9]+:[0-9]+\]]], s[0:1], 0x0
  // CHECK: s_load_b32 [[X:s[0-9]+]], s[0:1], 0x8
  // CHECK: v_mbcnt_lo_u32_b32 [[LANE:v[0-9]+]], -1, 0
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %vx = wave.splat %x : i32 -> !wave.simd<i32, 32>
  // CHECK: s_waitcnt lgkmcnt(0)
  // CHECK: s_delay_alu instid0(VALU_DEP_1)
  // CHECK: v_add_nc_u32_e32 [[SUM:v[0-9]+]], [[X]], [[LANE]]
  %sum = wave.binary "addi" %lane, %vx : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  // CHECK: v_lshlrev_b32_e32 [[OFFSET:v[0-9]+]], 2, [[LANE]]
  // CHECK: global_store_b32 [[OFFSET]], [[SUM]], [[OUT]]
  %ptrs = wave.ptr_add %out, %lane : !wave.ptr<i32, #wave.global>, !wave.simd<i32, 32> -> !wave.simd<!wave.ptr<i32, #wave.global>, 32>
  %store_token = wave.store %sum -> %ptrs : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<i32, #wave.global>, 32>) -> !wave.mem.token
  // CHECK: s_waitcnt_vscnt null, 0x0
  // CHECK: s_endpgm
  return
}
// CHECK: .amdhsa_kernel wave_kernel

// `wave.binary "shri"` lowers to v_lshrrev_b32 (VOP2; shift goes in
// src0, value in vsrc1 -- mirroring shli). `wave.binary "muli"` lowers
// to v_mul_lo_u32 (VOP3, no operand-placement constraints).
// CHECK-LABEL: wave_shri_muli:
func.func @wave_shri_muli(%x: i32) -> i32 {
  // CHECK: v_mbcnt_lo_u32_b32 [[LANE:v[0-9]+]], -1, 0
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %vx = wave.splat %x : i32 -> !wave.simd<i32, 32>
  // CHECK: v_lshrrev_b32_e32 [[SHIFTED:v[0-9]+]],
  %shifted = wave.binary "shri" %lane, %vx : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  // CHECK: v_mul_lo_u32 [[MULLED:v[0-9]+]], [[SHIFTED]],
  %mulled = wave.binary "muli" %shifted, %vx : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %first = wave.read_first %mulled : !wave.simd<i32, 32> -> i32
  return %first : i32
}

// A barrier with no dependencies emits a bare `s_barrier`. With
// dependencies on prior LDS stores the waitcnt pass inserts an
// `s_waitcnt lgkmcnt(0)` ahead of the barrier.
// CHECK-LABEL: wave_lds_echo:
func.func @wave_lds_echo(%out: !wave.ptr<i32, #wave.global>)
    attributes {wave.kernel, wave.lds_size = 128 : i64} {
  // CHECK: v_mbcnt_lo_u32_b32 [[LANE:v[0-9]+]], -1, 0
  %lane = wave.lane_id : !wave.simd<i32, 32>
  // CHECK: v_lshlrev_b32_e32 [[BYTE:v[0-9]+]], 2, [[LANE]]
  %lds = wave.lds_base : !wave.ptr<i32, #wave.shared>
  %lds_ptrs = wave.ptr_add %lds, %lane : !wave.ptr<i32, #wave.shared>, !wave.simd<i32, 32> -> !wave.simd<!wave.ptr<i32, #wave.shared>, 32>
  // CHECK: ds_store_b32 [[BYTE]], [[LANE]]
  %store_token = wave.store %lane -> %lds_ptrs : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<i32, #wave.shared>, 32>) -> !wave.mem.token
  // CHECK: s_waitcnt lgkmcnt(0)
  // CHECK: s_barrier
  %barrier_token = wave.barrier %store_token : (!wave.mem.token) -> !wave.mem.token
  // CHECK: ds_load_b32 [[VAL:v[0-9]+]], [[BYTE]]
  %loaded:2 = wave.load %lds_ptrs after %barrier_token : (!wave.simd<!wave.ptr<i32, #wave.shared>, 32>, !wave.mem.token) -> (!wave.simd<i32, 32>, !wave.mem.token)
  // CHECK: global_store_b32 [[BYTE]], [[VAL]]
  %out_ptrs = wave.ptr_add %out, %lane : !wave.ptr<i32, #wave.global>, !wave.simd<i32, 32> -> !wave.simd<!wave.ptr<i32, #wave.global>, 32>
  %final_token = wave.store %loaded#0 -> %out_ptrs : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<i32, #wave.global>, 32>) -> !wave.mem.token
  return
}
// CHECK: .amdhsa_kernel wave_lds_echo
// CHECK: .amdhsa_group_segment_fixed_size 128

// NOTE: NT_AMDGPU_METADATA
// NOTE: amdhsa.kernels:
// NOTE: .name:           wave_kernel
// NOTE: .symbol:         wave_kernel.kd
// NOTE: amdhsa.target:   amdgcn-amd-amdhsa--gfx1100
