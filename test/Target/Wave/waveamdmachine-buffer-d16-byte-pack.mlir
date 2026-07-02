// RUN: wave-opt --waveamd-to-machine --canonicalize --cse %s | FileCheck %s --check-prefix=SELECT
// RUN: wave-opt --waveamd-to-machine --canonicalize --cse --waveamd-machine-cleanup %s | FileCheck %s --check-prefix=CLEANUP

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// SELECT-LABEL: func.func @buffer_i8_pack_d16
// SELECT-NOT: waveamdmachine.buffer_load_u8_d16
// SELECT: waveamdmachine.v_and_b32
// SELECT: waveamdmachine.v_or_b32
// SELECT-NOT: waveamdmachine.buffer_load_u8_d16
// CLEANUP-LABEL: func.func @buffer_i8_pack_d16
// CLEANUP: %[[EVEN_LO:.*]], %{{.*}} = waveamdmachine.buffer_load_u8_d16
// CLEANUP: %[[ODD_LO:.*]], %{{.*}} = waveamdmachine.buffer_load_u8_d16
// CLEANUP: %[[ZERO0:.*]] = waveamdmachine.v_mov_b32_tuple
// CLEANUP: %[[EVEN_HI:.*]], %{{.*}} = waveamdmachine.buffer_load_u8_d16_hi {{.*}}, %[[ZERO0]],
// CLEANUP: %[[ZERO1:.*]] = waveamdmachine.v_mov_b32_tuple
// CLEANUP: %[[ODD_HI:.*]], %{{.*}} = waveamdmachine.buffer_load_u8_d16_hi {{.*}}, %[[ZERO1]],
// CLEANUP: %[[ODD:.*]] = waveamdmachine.v_or_b32 %[[ODD_LO]], %[[ODD_HI]]
// CLEANUP: %[[SHIFTED:.*]] = waveamdmachine.v_lshlrev_b32 %[[ODD]]
// CLEANUP: waveamdmachine.v_or3_b32 %[[EVEN_LO]], %[[EVEN_HI]], %[[SHIFTED]]
func.func @buffer_i8_pack_d16(%in: !wave.ptr<#wave.global, i8>,
                              %out: !wave.ptr<#wave.global, i8>)
    attributes {wave.kernel} {
  %range = arith.constant 4096 : i32
  %buffer = waveamd.make_buffer %in, %range
      : !wave.ptr<#wave.global, i8>, i32 -> !wave.ptr<#waveamd.buffer, i8>
  %lane = wave.lane_id : !wave.simd<i32, 64>
  %c1 = arith.constant 1 : i32
  %c2 = arith.constant 2 : i32
  %c3 = arith.constant 3 : i32
  %one = wave.splat %c1 : i32 -> !wave.simd<i32, 64>
  %two = wave.splat %c2 : i32 -> !wave.simd<i32, 64>
  %three = wave.splat %c3 : i32 -> !wave.simd<i32, 64>
  %lane1 = wave.binary addi %lane, %one
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
  %lane2 = wave.binary addi %lane, %two
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
  %lane3 = wave.binary addi %lane, %three
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
  %p0 = wave.ptr_add %buffer, %lane
      : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
  %p1 = wave.ptr_add %buffer, %lane1
      : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
  %p2 = wave.ptr_add %buffer, %lane2
      : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
  %p3 = wave.ptr_add %buffer, %lane3
      : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
  %v0, %t0 = wave.load %p0
      : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>)
      -> (!wave.simd<i8, 64>, !wave.mem.token)
  %v1, %t1 = wave.load %p1
      : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>)
      -> (!wave.simd<i8, 64>, !wave.mem.token)
  %v2, %t2 = wave.load %p2
      : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>)
      -> (!wave.simd<i8, 64>, !wave.mem.token)
  %v3, %t3 = wave.load %p3
      : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>)
      -> (!wave.simd<i8, 64>, !wave.mem.token)
  %packed = wave.pack %v0, %v1, %v2, %v3
      : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>,
        !wave.simd<i8, 64> -> !wave.simd<vector<4xi8>, 64>
  %op = wave.ptr_add %out, %lane
      : !wave.ptr<#wave.global, i8>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#wave.global, i8>, 64>
  %st = wave.store %packed -> %op
      : (!wave.simd<vector<4xi8>, 64>,
         !wave.simd<!wave.ptr<#wave.global, i8>, 64>)
      -> !wave.mem.token
  return
}

// SELECT-LABEL: func.func @buffer_i8_pack_shared_load_keeps_scalar
// SELECT-NOT: waveamdmachine.buffer_load_u8_d16
// SELECT: waveamdmachine.buffer_load_u8
// SELECT-NOT: waveamdmachine.buffer_load_u8_d16
// SELECT: waveamdmachine.v_and_b32
// SELECT-NOT: waveamdmachine.buffer_load_u8_d16
// SELECT: waveamdmachine.v_or_b32
// CLEANUP-LABEL: func.func @buffer_i8_pack_shared_load_keeps_scalar
// CLEANUP-NOT: waveamdmachine.buffer_load_u8_d16
// CLEANUP: waveamdmachine.buffer_load_u8
// CLEANUP-NOT: waveamdmachine.buffer_load_u8_d16
// CLEANUP: waveamdmachine.v_and_b32
// CLEANUP-NOT: waveamdmachine.buffer_load_u8_d16
// CLEANUP: waveamdmachine.v_or_b32
func.func @buffer_i8_pack_shared_load_keeps_scalar(
    %in: !wave.ptr<#wave.global, i8>, %out: !wave.ptr<#wave.global, i8>)
    attributes {wave.kernel} {
  %range = arith.constant 4096 : i32
  %buffer = waveamd.make_buffer %in, %range
      : !wave.ptr<#wave.global, i8>, i32 -> !wave.ptr<#waveamd.buffer, i8>
  %lane = wave.lane_id : !wave.simd<i32, 64>
  %c1 = arith.constant 1 : i32
  %c2 = arith.constant 2 : i32
  %c3 = arith.constant 3 : i32
  %one = wave.splat %c1 : i32 -> !wave.simd<i32, 64>
  %two = wave.splat %c2 : i32 -> !wave.simd<i32, 64>
  %three = wave.splat %c3 : i32 -> !wave.simd<i32, 64>
  %lane1 = wave.binary addi %lane, %one
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
  %lane2 = wave.binary addi %lane, %two
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
  %lane3 = wave.binary addi %lane, %three
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
  %p0 = wave.ptr_add %buffer, %lane
      : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
  %p1 = wave.ptr_add %buffer, %lane1
      : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
  %p2 = wave.ptr_add %buffer, %lane2
      : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
  %p3 = wave.ptr_add %buffer, %lane3
      : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
  %v0, %t0 = wave.load %p0
      : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>)
      -> (!wave.simd<i8, 64>, !wave.mem.token)
  %v1, %t1 = wave.load %p1
      : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>)
      -> (!wave.simd<i8, 64>, !wave.mem.token)
  %v2, %t2 = wave.load %p2
      : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>)
      -> (!wave.simd<i8, 64>, !wave.mem.token)
  %v3, %t3 = wave.load %p3
      : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>)
      -> (!wave.simd<i8, 64>, !wave.mem.token)
  %packed = wave.pack %v0, %v1, %v2, %v3
      : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>,
        !wave.simd<i8, 64> -> !wave.simd<vector<4xi8>, 64>
  %op = wave.ptr_add %out, %lane
      : !wave.ptr<#wave.global, i8>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#wave.global, i8>, 64>
  %packed_store = wave.store %packed -> %op
      : (!wave.simd<vector<4xi8>, 64>,
         !wave.simd<!wave.ptr<#wave.global, i8>, 64>)
      -> !wave.mem.token
  %scalar_store = wave.store %v0 -> %op
      : (!wave.simd<i8, 64>, !wave.simd<!wave.ptr<#wave.global, i8>, 64>)
      -> !wave.mem.token
  return
}

}
