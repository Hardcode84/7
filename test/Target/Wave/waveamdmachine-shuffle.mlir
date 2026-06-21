// RUN: wave-opt --waveamd-to-machine --verify-diagnostics --split-input-file %s | FileCheck %s --check-prefix=SELECT
// RUN: wave-opt --waveamd-to-machine --waveamd-abi-lowering --waveamd-insert-ticket-waits --split-input-file %s | FileCheck %s --check-prefix=WAIT
// RUN: wave-opt --waveamd-to-machine --waveamd-abi-lowering --waveamd-preserve-hw-regs --waveamd-reg-alloc --waveamd-decompose-mem-tuples --waveamd-insert-ticket-waits --waveamd-insert-hazard-waits --split-input-file %s | wave-translate --wave-to-amdgpu-asm --split-input-file - | FileCheck %s --check-prefix=ASM
// RUN: wave-opt --waveamd-to-machine --waveamd-abi-lowering --waveamd-preserve-hw-regs --waveamd-reg-alloc --waveamd-decompose-mem-tuples --waveamd-insert-ticket-waits --waveamd-insert-hazard-waits --split-input-file %s | wave-translate --wave-to-amdgpu-asm --split-input-file - | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx1100 -filetype=obj -o /dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// SELECT-LABEL: func.func @shuffle_i32
// SELECT: [[LANE:%.*]] = waveamdmachine.v_mbcnt_lo
// SELECT: [[ADDR:%.*]] = waveamdmachine.v_lshlrev_b32 [[LANE]]
// SELECT: waveamdmachine.ds_bpermute_b32 [[ADDR]], [[LANE]]
// WAIT-LABEL: func.func @shuffle_i32
// WAIT: [[SHUFFLED:%.*]] = waveamdmachine.ds_bpermute_b32
// WAIT: waveamdmachine.s_waitcnt lgkmcnt(0)
// WAIT-NEXT: {{%.*}} = waveamdmachine.global_store_b32 {{.*}}, [[SHUFFLED]],
// ASM-LABEL: shuffle_i32:
// ASM: v_lshlrev_b32_e32 [[ADDR:v[0-9]+]], 2, [[LANE:v[0-9]+]]
// ASM: ds_bpermute_b32 {{v[0-9]+}}, [[ADDR]], [[LANE]]
func.func @shuffle_i32(%out: !wave.ptr<#wave.global, i32>)
    attributes {wave.kernel} {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %shuffled = wave.shuffle %lane from %lane
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %ptrs = wave.ptr_add %out, %lane
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %tok = wave.store %shuffled -> %ptrs
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.global, i32>, 32>)
      -> !wave.mem.token
  return
}

// SELECT-LABEL: func.func @shuffle_scalar_lane
// SELECT: [[SRC:%.*]] = waveamdmachine.arg {{.*}} : !waveamdmachine.reg<sgpr, 1>
// SELECT: [[LANEARG:%.*]] = waveamdmachine.arg {{.*}}index = 2{{.*}} : !waveamdmachine.reg<sgpr, 1>
// SELECT: [[ADDRSRC:%.*]] = waveamdmachine.v_mov_b32_tuple [[LANEARG]]
// SELECT: [[ADDR:%.*]] = waveamdmachine.v_lshlrev_b32 [[ADDRSRC]]
// SELECT: waveamdmachine.ds_bpermute_b32 [[ADDR]],
func.func @shuffle_scalar_lane(%out: !wave.ptr<#wave.global, i32>,
                               %src: i32, %source_lane: i32)
    attributes {wave.kernel} {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %vsrc = wave.splat %src : i32 -> !wave.simd<i32, 32>
  %shuffled = wave.shuffle %vsrc from %source_lane
      : !wave.simd<i32, 32>, i32 -> !wave.simd<i32, 32>
  %ptrs = wave.ptr_add %out, %lane
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %tok = wave.store %shuffled -> %ptrs
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.global, i32>, 32>)
      -> !wave.mem.token
  return
}

// SELECT-LABEL: func.func @shuffle_i64_unroll
// SELECT: [[SRC:%.*]] = waveamdmachine.arg {{.*}} : !waveamdmachine.reg<sgpr, 2>
// SELECT: [[WORDS:%.*]]:2 = waveamdmachine.tuple_to_elements [[SRC]]
// SELECT: [[ADDR:%.*]] = waveamdmachine.v_lshlrev_b32
// SELECT: [[LO:%.*]] = waveamdmachine.ds_bpermute_b32 [[ADDR]],
// SELECT: [[HI:%.*]] = waveamdmachine.ds_bpermute_b32 [[ADDR]],
// SELECT: waveamdmachine.tuple_from_elements [[LO]], [[HI]]
func.func @shuffle_i64_unroll(%src: i64) {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %vsrc = wave.splat %src : i64 -> !wave.simd<i64, 32>
  %shuffled = wave.shuffle %vsrc from %lane
      : !wave.simd<i64, 32>, !wave.simd<i32, 32> -> !wave.simd<i64, 32>
  return
}

}
