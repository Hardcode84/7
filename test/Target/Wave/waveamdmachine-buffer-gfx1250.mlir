// RUN: wave-opt --waveamd-to-machine --waveamd-buffer-rsrc-to-tuples %s \
// RUN:   | FileCheck %s
// RUN: wave-opt --wave-promote-global-to-buffer --waveamd-to-machine \
// RUN:   --waveamd-buffer-rsrc-to-tuples %s | FileCheck %s \
// RUN:   --check-prefix=PROMOTE

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1250"} {

// CHECK-LABEL: func.func @buffer_i64_range(
// CHECK: %[[RANGE:.*]] = waveamdmachine.arg {index = 1 : i64, pointer = false} : !waveamdmachine.reg<sgpr, 2>
// CHECK: %[[MASK:.*]] = waveamdmachine.s_mov_b64_imm 35184372088831
// CHECK: %[[MASKED:.*]], %{{.*}} = waveamdmachine.s_and_b64 %[[RANGE]], %[[MASK]]
// CHECK: waveamdmachine.s_lshl_b64 %[[MASKED]]
// CHECK: waveamdmachine.s_lshr_b64 %[[MASKED]]
// CHECK: waveamdmachine.tuple_from_elements
// CHECK: waveamdmachine.buffer_store_b32
func.func @buffer_i64_range(
    %out: !wave.ptr<#wave.global, i32>, %range: i64)
    attributes {wave.kernel} {
  %buffer = waveamd.make_buffer %out, %range
      : !wave.ptr<#wave.global, i32>, i64
        -> !wave.ptr<#waveamd.buffer, i32>
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %ptrs = wave.ptr_add %buffer, %lane
      : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<i32, 32>
        -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>
  %token = wave.store %lane -> %ptrs
      : (!wave.simd<i32, 32>,
         !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>)
        -> !wave.mem.token
  return
}

// CHECK-LABEL: func.func @buffer_i32_range(
// CHECK: %[[RANGE:.*]] = waveamdmachine.arg {index = 1 : i64, pointer = false} : !waveamdmachine.reg<sgpr, 1>
// CHECK: %[[ZERO_IMM:.*]] = waveamdmachine.imm 0
// CHECK: %[[ZERO:.*]] = waveamdmachine.s_mov_b32_tuple %[[ZERO_IMM]]
// CHECK: %[[RANGE_WIDE:.*]] = waveamdmachine.tuple_from_elements %[[RANGE]], %[[ZERO]]
// CHECK: waveamdmachine.s_and_b64 %[[RANGE_WIDE]]
func.func @buffer_i32_range(
    %out: !wave.ptr<#wave.global, i32>, %range: i32)
    attributes {wave.kernel} {
  %buffer = waveamd.make_buffer %out, %range
      : !wave.ptr<#wave.global, i32>, i32
        -> !wave.ptr<#waveamd.buffer, i32>
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %ptrs = wave.ptr_add %buffer, %lane
      : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<i32, 32>
        -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>
  %token = wave.store %lane -> %ptrs
      : (!wave.simd<i32, 32>,
         !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>)
        -> !wave.mem.token
  return
}

// PROMOTE-LABEL: func.func @promoted_i32_range(
// PROMOTE: waveamdmachine.imm -2147483648
// PROMOTE: %[[RANGE:.*]] = waveamdmachine.imm 2147483648
// PROMOTE: %[[WIDE:.*]] = waveamdmachine.s_mov_b64_imm 2147483648
// PROMOTE: waveamdmachine.s_and_b64 %[[WIDE]]
// PROMOTE: waveamdmachine.buffer_store_b32
func.func @promoted_i32_range(
    %out: !wave.ptr<#wave.global, i32>)
    attributes {wave.kernel} {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %ptrs = wave.ptr_add %out, %lane
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32>
        -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %token = wave.store %lane -> %ptrs
      : (!wave.simd<i32, 32>,
         !wave.simd<!wave.ptr<#wave.global, i32>, 32>)
        -> !wave.mem.token
  return
}

}
