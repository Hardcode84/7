// RUN: wave-opt --waveamd-lower-buffer-predication %s | FileCheck %s

// CHECK-LABEL: func.func @bounded_i64
// CHECK-NOT: wave.where
// CHECK: wave.cast intconvert {{.*}} : i64 -> index
// CHECK: wave.select
// CHECK: wave.store
// CHECK-NOT: wave.where
// CHECK: return
func.func @bounded_i64(
    %out: !wave.ptr<#wave.global, i32>,
    %limit: i32, %raw: i64, %raw32: i32) -> !wave.mem.token attributes {wave.kernel} {
  %range = wave.assume %raw as "r" [#wave.pred<"r >= 0">, #wave.pred<"r <= 4294967295">] : i64
  %buffer = waveamd.make_buffer %out, %range
      : !wave.ptr<#wave.global, i32>, i64
      -> !wave.ptr<#waveamd.buffer, i32>
  %lane = wave.lane_id : !wave.simd<i32, 64>
  %vlimit = wave.splat %limit : i32 -> !wave.simd<i32, 64>
  %active = wave.cmpi slt %lane, %vlimit
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
  %ptr = wave.ptr_add %buffer, %lane
      : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>
  %dependency = wave.token : !wave.mem.token
  %result = wave.where %active {
    %stored = wave.store %lane -> %ptr
        : (!wave.simd<i32, 64>,
           !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>)
        -> !wave.mem.token
    wave.yield %stored : !wave.mem.token
  } otherwise {
    wave.yield %dependency : !wave.mem.token
  } : !wave.mask<64> -> !wave.mem.token
  return %result : !wave.mem.token
}

// CHECK-LABEL: func.func @unsigned_extension
// CHECK-NOT: wave.where
// CHECK: wave.cast intconvert {{.*}} : i64 -> index
// CHECK: wave.select
// CHECK: wave.store
// CHECK-NOT: wave.where
// CHECK: return
func.func @unsigned_extension(
    %out: !wave.ptr<#wave.global, i32>,
    %limit: i32, %raw: i64, %raw32: i32) -> !wave.mem.token attributes {wave.kernel} {
  %range = arith.extui %raw32 : i32 to i64
  %buffer = waveamd.make_buffer %out, %range
      : !wave.ptr<#wave.global, i32>, i64
      -> !wave.ptr<#waveamd.buffer, i32>
  %lane = wave.lane_id : !wave.simd<i32, 64>
  %vlimit = wave.splat %limit : i32 -> !wave.simd<i32, 64>
  %active = wave.cmpi slt %lane, %vlimit
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
  %ptr = wave.ptr_add %buffer, %lane
      : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>
  %dependency = wave.token : !wave.mem.token
  %result = wave.where %active {
    %stored = wave.store %lane -> %ptr
        : (!wave.simd<i32, 64>,
           !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>)
        -> !wave.mem.token
    wave.yield %stored : !wave.mem.token
  } otherwise {
    wave.yield %dependency : !wave.mem.token
  } : !wave.mask<64> -> !wave.mem.token
  return %result : !wave.mem.token
}

// CHECK-LABEL: func.func @unknown_i64
// CHECK-NOT: wave.select
// CHECK: wave.where
// CHECK: wave.store
// CHECK-NOT: wave.select
// CHECK: return
func.func @unknown_i64(
    %out: !wave.ptr<#wave.global, i32>,
    %limit: i32, %raw: i64, %raw32: i32) -> !wave.mem.token attributes {wave.kernel} {
  %range = arith.addi %raw, %raw : i64
  %buffer = waveamd.make_buffer %out, %range
      : !wave.ptr<#wave.global, i32>, i64
      -> !wave.ptr<#waveamd.buffer, i32>
  %lane = wave.lane_id : !wave.simd<i32, 64>
  %vlimit = wave.splat %limit : i32 -> !wave.simd<i32, 64>
  %active = wave.cmpi slt %lane, %vlimit
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
  %ptr = wave.ptr_add %buffer, %lane
      : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>
  %dependency = wave.token : !wave.mem.token
  %result = wave.where %active {
    %stored = wave.store %lane -> %ptr
        : (!wave.simd<i32, 64>,
           !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>)
        -> !wave.mem.token
    wave.yield %stored : !wave.mem.token
  } otherwise {
    wave.yield %dependency : !wave.mem.token
  } : !wave.mask<64> -> !wave.mem.token
  return %result : !wave.mem.token
}

// CHECK-LABEL: func.func @negative_i64
// CHECK-NOT: wave.select
// CHECK: wave.where
// CHECK: wave.store
// CHECK-NOT: wave.select
// CHECK: return
func.func @negative_i64(
    %out: !wave.ptr<#wave.global, i32>,
    %limit: i32, %raw: i64, %raw32: i32) -> !wave.mem.token attributes {wave.kernel} {
  %range = wave.assume %raw as "r" [#wave.pred<"r >= -1">, #wave.pred<"r <= 4096">] : i64
  %buffer = waveamd.make_buffer %out, %range
      : !wave.ptr<#wave.global, i32>, i64
      -> !wave.ptr<#waveamd.buffer, i32>
  %lane = wave.lane_id : !wave.simd<i32, 64>
  %vlimit = wave.splat %limit : i32 -> !wave.simd<i32, 64>
  %active = wave.cmpi slt %lane, %vlimit
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
  %ptr = wave.ptr_add %buffer, %lane
      : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>
  %dependency = wave.token : !wave.mem.token
  %result = wave.where %active {
    %stored = wave.store %lane -> %ptr
        : (!wave.simd<i32, 64>,
           !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>)
        -> !wave.mem.token
    wave.yield %stored : !wave.mem.token
  } otherwise {
    wave.yield %dependency : !wave.mem.token
  } : !wave.mask<64> -> !wave.mem.token
  return %result : !wave.mem.token
}

// CHECK-LABEL: func.func @too_wide_i64
// CHECK-NOT: wave.select
// CHECK: wave.where
// CHECK: wave.store
// CHECK-NOT: wave.select
// CHECK: return
func.func @too_wide_i64(
    %out: !wave.ptr<#wave.global, i32>,
    %limit: i32, %raw: i64, %raw32: i32) -> !wave.mem.token attributes {wave.kernel} {
  %range = wave.assume %raw as "r" [#wave.pred<"r >= 0">, #wave.pred<"r <= 4294967296">] : i64
  %buffer = waveamd.make_buffer %out, %range
      : !wave.ptr<#wave.global, i32>, i64
      -> !wave.ptr<#waveamd.buffer, i32>
  %lane = wave.lane_id : !wave.simd<i32, 64>
  %vlimit = wave.splat %limit : i32 -> !wave.simd<i32, 64>
  %active = wave.cmpi slt %lane, %vlimit
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
  %ptr = wave.ptr_add %buffer, %lane
      : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>
  %dependency = wave.token : !wave.mem.token
  %result = wave.where %active {
    %stored = wave.store %lane -> %ptr
        : (!wave.simd<i32, 64>,
           !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>)
        -> !wave.mem.token
    wave.yield %stored : !wave.mem.token
  } otherwise {
    wave.yield %dependency : !wave.mem.token
  } : !wave.mask<64> -> !wave.mem.token
  return %result : !wave.mem.token
}

// CHECK-LABEL: func.func @sibling_assumption
// CHECK-NOT: wave.select
// CHECK: wave.where
// CHECK: wave.store
// CHECK-NOT: wave.select
// CHECK: return
func.func @sibling_assumption(
    %out: !wave.ptr<#wave.global, i32>,
    %limit: i32, %raw: i64, %raw32: i32) -> !wave.mem.token attributes {wave.kernel} {
  %sibling = wave.assume %raw as "r" [#wave.pred<"r >= 0">, #wave.pred<"r <= 4096">] : i64
  %buffer = waveamd.make_buffer %out, %raw
      : !wave.ptr<#wave.global, i32>, i64
      -> !wave.ptr<#waveamd.buffer, i32>
  %lane = wave.lane_id : !wave.simd<i32, 64>
  %vlimit = wave.splat %limit : i32 -> !wave.simd<i32, 64>
  %active = wave.cmpi slt %lane, %vlimit
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
  %ptr = wave.ptr_add %buffer, %lane
      : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>
  %dependency = wave.token : !wave.mem.token
  %result = wave.where %active {
    %stored = wave.store %lane -> %ptr
        : (!wave.simd<i32, 64>,
           !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>)
        -> !wave.mem.token
    wave.yield %stored : !wave.mem.token
  } otherwise {
    wave.yield %dependency : !wave.mem.token
  } : !wave.mask<64> -> !wave.mem.token
  return %result : !wave.mem.token
}
