// RUN: wave-opt --waveamd-to-machine %s | FileCheck %s --check-prefix=SELECT
// RUN: wave-opt --waveamd-to-machine --waveamd-buffer-rsrc-to-tuples %s \
// RUN:   | FileCheck %s --check-prefix=TUPLE
// RUN: wave-opt --waveamd-to-machine %s | sed 's/--gfx950/--gfx942/' \
// RUN:   | not wave-opt --waveamd-buffer-rsrc-to-tuples - 2>&1 \
// RUN:   | FileCheck %s --check-prefix=ERROR

// SELECT-LABEL: func.func @buffer_lane_stride
// SELECT: %[[TID:.*]] = waveamdmachine.make_buffer_rsrc {{.*}} {const_add_tid_enable = true, const_stride = 4 : i64}
// SELECT-NOT: waveamdmachine.make_buffer_rsrc
// SELECT: waveamdmachine.buffer_store_b32 {{.*}}, %[[TID]],

// TUPLE-LABEL: func.func @buffer_lane_stride
// TUPLE: %[[MASK:.*]] = waveamdmachine.s_mov_b64_imm 281474976710655
// TUPLE: %[[BASE:.*]], %{{.*}} = waveamdmachine.s_and_b64 {{.*}}, %[[MASK]]
// TUPLE: %[[STRIDE:.*]] = waveamdmachine.s_mov_b64_imm 1125899906842624
// TUPLE: %[[PACKED:.*]], %{{.*}} = waveamdmachine.s_or_b64 %[[BASE]], %[[STRIDE]]
// TUPLE: %[[FLAGS_IMM:.*]] = waveamdmachine.imm 830496768
// TUPLE: %[[FLAGS:.*]] = waveamdmachine.s_mov_b32_tuple %[[FLAGS_IMM]]
// TUPLE: %[[DESC:.*]] = waveamdmachine.tuple_from_elements %[[PACKED]], {{.*}}, %[[FLAGS]]
// TUPLE: waveamdmachine.buffer_store_b32 {{.*}}, %[[DESC]],

// SELECT-LABEL: func.func @buffer_extended_lane_stride
// SELECT: waveamdmachine.make_buffer_rsrc {{.*}} {const_add_tid_enable = true, const_stride = 262143 : i64}

// TUPLE-LABEL: func.func @buffer_extended_lane_stride
// TUPLE: waveamdmachine.s_mov_b64_imm 4611404543450677248
// TUPLE: waveamdmachine.imm 830988288

// SELECT-LABEL: func.func @buffer_oob_lane_stride
// SELECT: %[[OOB_DESC:.*]] = waveamdmachine.make_buffer_rsrc
// SELECT-NOT: const_add_tid_enable
// SELECT: waveamdmachine.buffer_store_b32 {{.*}}, %[[OOB_DESC]],

// SELECT-LABEL: func.func @buffer_bounded_soffset_lane_stride
// SELECT: %[[SOFFSET_TID:.*]] = waveamdmachine.make_buffer_rsrc {{.*}} {const_add_tid_enable = true, const_stride = 4 : i64}
// SELECT: waveamdmachine.buffer_store_b32 {{.*}}, %[[SOFFSET_TID]],

// SELECT-LABEL: func.func @buffer_soffset_oob_lane_stride
// SELECT: %[[SOFFSET_OOB_DESC:.*]] = waveamdmachine.make_buffer_rsrc
// SELECT-NOT: const_add_tid_enable
// SELECT: waveamdmachine.buffer_store_b32 {{.*}}, %[[SOFFSET_OOB_DESC]],

// ERROR: error: constant TID buffer stride requires a CDNA4 target

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

func.func @buffer_lane_stride(%out: !wave.ptr<#wave.global, i32>, %x: i32)
    attributes {wave.kernel} {
  %range = arith.constant 256 : i32
  %buffer = waveamd.make_buffer %out, %range
      : !wave.ptr<#wave.global, i32>, i32 -> !wave.ptr<#waveamd.buffer, i32>
  %lane = wave.lane_id : !wave.simd<i32, 64>
  %value = wave.splat %x : i32 -> !wave.simd<i32, 64>
  %ptrs = wave.ptr_add %buffer, %lane
      : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>
  %token = wave.store %value -> %ptrs
      : (!wave.simd<i32, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>)
      -> !wave.mem.token
  return
}

func.func @buffer_extended_lane_stride(
    %out: !wave.ptr<#wave.global, i8>, %x: i8) attributes {wave.kernel} {
  %range = arith.constant -2147483648 : i32
  %buffer = waveamd.make_buffer %out, %range
      : !wave.ptr<#wave.global, i8>, i32 -> !wave.ptr<#waveamd.buffer, i8>
  %lane = wave.lane_id : !wave.simd<i32, 64>
  %offset = wave.index_expr <"262143*lane"> ["lane"](%lane)
      : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
  %value = wave.splat %x : i8 -> !wave.simd<i8, 64>
  %ptrs = wave.ptr_add %buffer, %offset
      : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64>
      -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
  %token = wave.store %value -> %ptrs
      : (!wave.simd<i8, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>)
      -> !wave.mem.token
  return
}

func.func @buffer_oob_lane_stride(
    %out: !wave.ptr<#wave.global, i32>, %x: i32) attributes {wave.kernel} {
  %range = arith.constant 4 : i32
  %buffer = waveamd.make_buffer %out, %range
      : !wave.ptr<#wave.global, i32>, i32 -> !wave.ptr<#waveamd.buffer, i32>
  %lane = wave.lane_id : !wave.simd<i32, 64>
  %value = wave.splat %x : i32 -> !wave.simd<i32, 64>
  %ptrs = wave.ptr_add %buffer, %lane
      : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>
  %token = wave.store %value -> %ptrs
      : (!wave.simd<i32, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>)
      -> !wave.mem.token
  return
}

func.func @buffer_bounded_soffset_lane_stride(
    %out: !wave.ptr<#wave.global, i32>, %x: i32, %u_raw: i32)
    attributes {wave.kernel} {
  %u = wave.assume %u_raw as "u"
      [#wave.pred<"u >= 0">, #wave.pred<"u <= 15">] : i32
  %range = arith.constant 512 : i32
  %buffer = waveamd.make_buffer %out, %range
      : !wave.ptr<#wave.global, i32>, i32 -> !wave.ptr<#waveamd.buffer, i32>
  %lane = wave.lane_id : !wave.simd<i32, 64>
  %value = wave.splat %x : i32 -> !wave.simd<i32, 64>
  %ptr = wave.ptr_add %buffer, %u
      : !wave.ptr<#waveamd.buffer, i32>, i32 -> !wave.ptr<#waveamd.buffer, i32>
  %ptrs = wave.ptr_add %ptr, %lane
      : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>
  %token = wave.store %value -> %ptrs
      : (!wave.simd<i32, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>)
      -> !wave.mem.token
  return
}

func.func @buffer_soffset_oob_lane_stride(
    %out: !wave.ptr<#wave.global, i32>, %x: i32, %u_raw: i32)
    attributes {wave.kernel} {
  %u = wave.assume %u_raw as "u"
      [#wave.pred<"u >= 0">, #wave.pred<"u <= 1023">] : i32
  %range = arith.constant 4096 : i32
  %buffer = waveamd.make_buffer %out, %range
      : !wave.ptr<#wave.global, i32>, i32 -> !wave.ptr<#waveamd.buffer, i32>
  %lane = wave.lane_id : !wave.simd<i32, 64>
  %value = wave.splat %x : i32 -> !wave.simd<i32, 64>
  %ptr = wave.ptr_add %buffer, %u
      : !wave.ptr<#waveamd.buffer, i32>, i32 -> !wave.ptr<#waveamd.buffer, i32>
  %ptrs = wave.ptr_add %ptr, %lane
      : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>
  %token = wave.store %value -> %ptrs
      : (!wave.simd<i32, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>)
      -> !wave.mem.token
  return
}

}
