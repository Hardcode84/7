// RUN: wave-opt --split-input-file --waveamd-lower-buffer-predication %s | FileCheck %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// CHECK-LABEL: func.func @zero_fill_buffer_load
// CHECK: [[RANGE:%.*]] = arith.constant 4096 : i32
// CHECK: [[BUFFER:%.*]] = waveamd.make_buffer {{.*}}, [[RANGE]]
// CHECK: [[PTR:%.*]] = wave.ptr_add [[BUFFER]]
// CHECK-NOT: wave.where
// CHECK: [[BYTE_BUFFER:%.*]] = wave.ptr_cast [[BUFFER]]
// CHECK: [[UNSIGNED_RANGE:%.*]] = wave.cast intconvert [[RANGE]] policy {extension = #wave.cast_extension<zero>} : i32 -> index
// CHECK: [[OOB_OFFSET:%.*]] = wave.splat [[UNSIGNED_RANGE]]
// CHECK: [[OOB:%.*]] = wave.ptr_add [[BYTE_BUFFER]], [[OOB_OFFSET]]
// CHECK: [[TYPED_OOB:%.*]] = wave.ptr_cast [[OOB]]
// CHECK: [[SELECTED:%.*]] = wave.select {{%.*}}, [[PTR]], [[TYPED_OOB]]
// CHECK: [[VALUE:%.*]], [[TOKEN:%.*]] = wave.load [[SELECTED]]
// CHECK: return [[VALUE]], [[TOKEN]]
func.func @zero_fill_buffer_load(
    %base: !wave.ptr<#wave.global, f32>, %limit: i32)
    -> (!wave.simd<f32, 64>, !wave.mem.token) {
  %range = arith.constant 4096 : i32
  %buffer = waveamd.make_buffer %base, %range
      : !wave.ptr<#wave.global, f32>, i32 -> !wave.ptr<#waveamd.buffer, f32>
  %lane = wave.lane_id : !wave.simd<i32, 64>
  %ptr = wave.ptr_add %buffer, %lane
      : !wave.ptr<#waveamd.buffer, f32>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#waveamd.buffer, f32>, 64>
  %vlimit = wave.splat %limit : i32 -> !wave.simd<i32, 64>
  %active = wave.cmpi ult %lane, %vlimit
      : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
  %zero = wave.constant 0.0 : f32 -> !wave.simd<f32, 64>
  %dependency = wave.token : !wave.mem.token
  %result:2 = wave.where %active {
    %value, %token = wave.load %ptr after %dependency
        : (!wave.simd<!wave.ptr<#waveamd.buffer, f32>, 64>, !wave.mem.token)
        -> (!wave.simd<f32, 64>, !wave.mem.token)
    wave.yield %value, %token : !wave.simd<f32, 64>, !wave.mem.token
  } otherwise {
    wave.yield %zero, %dependency : !wave.simd<f32, 64>, !wave.mem.token
  } : !wave.mask<64> -> !wave.simd<f32, 64>, !wave.mem.token
  return %result#0, %result#1 : !wave.simd<f32, 64>, !wave.mem.token
}

// CHECK-LABEL: func.func @nonzero_fill_buffer_load
// CHECK-NOT: wave.where
// CHECK: [[SELECTED:%.*]] = wave.select {{%.*}}, {{%.*}}, {{%.*}} : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f32>, 64>
// CHECK: [[LOADED:%.*]], [[TOKEN:%.*]] = wave.load [[SELECTED]]
// CHECK: [[VALUE:%.*]] = wave.select {{%.*}}, [[LOADED]], {{%.*}} : !wave.mask<64>, !wave.simd<f32, 64>
// CHECK: return [[VALUE]], [[TOKEN]]
func.func @nonzero_fill_buffer_load(
    %base: !wave.ptr<#wave.global, f32>, %active: !wave.mask<64>,
    %other: !wave.simd<f32, 64>)
    -> (!wave.simd<f32, 64>, !wave.mem.token) {
  %range = arith.constant 4096 : i32
  %buffer = waveamd.make_buffer %base, %range
      : !wave.ptr<#wave.global, f32>, i32 -> !wave.ptr<#waveamd.buffer, f32>
  %lane = wave.lane_id : !wave.simd<i32, 64>
  %ptr = wave.ptr_add %buffer, %lane
      : !wave.ptr<#waveamd.buffer, f32>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#waveamd.buffer, f32>, 64>
  %dependency = wave.token : !wave.mem.token
  %result:2 = wave.where %active {
    %value, %token = wave.load %ptr after %dependency
        : (!wave.simd<!wave.ptr<#waveamd.buffer, f32>, 64>, !wave.mem.token)
        -> (!wave.simd<f32, 64>, !wave.mem.token)
    wave.yield %value, %token : !wave.simd<f32, 64>, !wave.mem.token
  } otherwise {
    wave.yield %other, %dependency : !wave.simd<f32, 64>, !wave.mem.token
  } : !wave.mask<64> -> !wave.simd<f32, 64>, !wave.mem.token
  return %result#0, %result#1 : !wave.simd<f32, 64>, !wave.mem.token
}

// CHECK-LABEL: func.func @masked_buffer_store
// CHECK-NOT: wave.where
// CHECK: [[SELECTED:%.*]] = wave.select {{%.*}}, {{%.*}}, {{%.*}} : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f32>, 64>
// CHECK: [[TOKEN:%.*]] = wave.store {{%.*}} -> [[SELECTED]]
// CHECK: return [[TOKEN]]
func.func @masked_buffer_store(
    %base: !wave.ptr<#wave.global, f32>, %active: !wave.mask<64>,
    %value: !wave.simd<f32, 64>) -> !wave.mem.token {
  %range = arith.constant 4096 : i32
  %buffer = waveamd.make_buffer %base, %range
      : !wave.ptr<#wave.global, f32>, i32 -> !wave.ptr<#waveamd.buffer, f32>
  %lane = wave.lane_id : !wave.simd<i32, 64>
  %ptr = wave.ptr_add %buffer, %lane
      : !wave.ptr<#waveamd.buffer, f32>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#waveamd.buffer, f32>, 64>
  %dependency = wave.token : !wave.mem.token
  %result = wave.where %active {
    %token = wave.store %value -> %ptr after %dependency
        : (!wave.simd<f32, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, f32>, 64>,
           !wave.mem.token) -> !wave.mem.token
    wave.yield %token : !wave.mem.token
  } otherwise {
    wave.yield %dependency : !wave.mem.token
  } : !wave.mask<64> -> !wave.mem.token
  return %result : !wave.mem.token
}

// CHECK-LABEL: func.func @keep_global_full_address
// CHECK: wave.where
// CHECK: wave.load
func.func @keep_global_full_address(
    %ptr: !wave.simd<!wave.ptr<#wave.global, f32>, 64>,
    %active: !wave.mask<64>, %zero: !wave.simd<f32, 64>)
    -> (!wave.simd<f32, 64>, !wave.mem.token) {
  %dependency = wave.token : !wave.mem.token
  %result:2 = wave.where %active {
    %value, %token = wave.load %ptr after %dependency
        : (!wave.simd<!wave.ptr<#wave.global, f32>, 64>, !wave.mem.token)
        -> (!wave.simd<f32, 64>, !wave.mem.token)
    wave.yield %value, %token : !wave.simd<f32, 64>, !wave.mem.token
  } otherwise {
    wave.yield %zero, %dependency : !wave.simd<f32, 64>, !wave.mem.token
  } : !wave.mask<64> -> !wave.simd<f32, 64>, !wave.mem.token
  return %result#0, %result#1 : !wave.simd<f32, 64>, !wave.mem.token
}

// CHECK-LABEL: func.func @keep_nonidentity_token
// CHECK: wave.where
// CHECK: wave.load
func.func @keep_nonidentity_token(
    %base: !wave.ptr<#wave.global, f32>, %active: !wave.mask<64>,
    %inactive: !wave.mem.token)
    -> (!wave.simd<f32, 64>, !wave.mem.token) {
  %range = arith.constant 4096 : i32
  %buffer = waveamd.make_buffer %base, %range
      : !wave.ptr<#wave.global, f32>, i32 -> !wave.ptr<#waveamd.buffer, f32>
  %lane = wave.lane_id : !wave.simd<i32, 64>
  %ptr = wave.ptr_add %buffer, %lane
      : !wave.ptr<#waveamd.buffer, f32>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#waveamd.buffer, f32>, 64>
  %zero = wave.constant 0.0 : f32 -> !wave.simd<f32, 64>
  %dependency = wave.token : !wave.mem.token
  %result:2 = wave.where %active {
    %value, %token = wave.load %ptr after %dependency
        : (!wave.simd<!wave.ptr<#waveamd.buffer, f32>, 64>, !wave.mem.token)
        -> (!wave.simd<f32, 64>, !wave.mem.token)
    wave.yield %value, %token : !wave.simd<f32, 64>, !wave.mem.token
  } otherwise {
    wave.yield %zero, %inactive : !wave.simd<f32, 64>, !wave.mem.token
  } : !wave.mask<64> -> !wave.simd<f32, 64>, !wave.mem.token
  return %result#0, %result#1 : !wave.simd<f32, 64>, !wave.mem.token
}


func.func private @effect()

// CHECK-LABEL: func.func @computed_fill_buffer_load
// CHECK-NOT: wave.where
// CHECK: [[LOADED:%.*]], [[TOKEN:%.*]] = wave.load
// CHECK: [[OTHER:%.*]] = wave.binary addi
// CHECK: [[RESULT:%.*]] = wave.select {{%.*}}, [[LOADED]], [[OTHER]]
// CHECK: return [[RESULT]], [[TOKEN]]
func.func @computed_fill_buffer_load(
    %base: !wave.ptr<#wave.global, i32>, %active: !wave.mask<64>,
    %other: !wave.simd<i32, 64>)
    -> (!wave.simd<i32, 64>, !wave.mem.token) {
  %range = arith.constant 4096 : i32
  %buffer = waveamd.make_buffer %base, %range
      : !wave.ptr<#wave.global, i32>, i32 -> !wave.ptr<#waveamd.buffer, i32>
  %lane = wave.lane_id : !wave.simd<i32, 64>
  %ptr = wave.ptr_add %buffer, %lane
      : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>
  %dependency = wave.token : !wave.mem.token
  %result:2 = wave.where %active {
    %value, %token = wave.load %ptr after %dependency
        : (!wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>, !wave.mem.token)
        -> (!wave.simd<i32, 64>, !wave.mem.token)
    wave.yield %value, %token : !wave.simd<i32, 64>, !wave.mem.token
  } otherwise {
    %computed = wave.binary addi %other, %other
        : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
    wave.yield %computed, %dependency : !wave.simd<i32, 64>, !wave.mem.token
  } : !wave.mask<64> -> !wave.simd<i32, 64>, !wave.mem.token
  return %result#0, %result#1 : !wave.simd<i32, 64>, !wave.mem.token
}

// CHECK-LABEL: func.func @keep_effectful_otherwise
// CHECK: wave.where
// CHECK: wave.load
// CHECK: } otherwise {
// CHECK-NEXT: call @effect()
// CHECK-NEXT: wave.yield
func.func @keep_effectful_otherwise(
    %base: !wave.ptr<#wave.global, i32>, %active: !wave.mask<64>,
    %other: !wave.simd<i32, 64>)
    -> (!wave.simd<i32, 64>, !wave.mem.token) {
  %range = arith.constant 4096 : i32
  %buffer = waveamd.make_buffer %base, %range
      : !wave.ptr<#wave.global, i32>, i32 -> !wave.ptr<#waveamd.buffer, i32>
  %lane = wave.lane_id : !wave.simd<i32, 64>
  %ptr = wave.ptr_add %buffer, %lane
      : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>
  %dependency = wave.token : !wave.mem.token
  %result:2 = wave.where %active {
    %value, %token = wave.load %ptr after %dependency
        : (!wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>, !wave.mem.token)
        -> (!wave.simd<i32, 64>, !wave.mem.token)
    wave.yield %value, %token : !wave.simd<i32, 64>, !wave.mem.token
  } otherwise {
    func.call @effect() : () -> ()
    wave.yield %other, %dependency : !wave.simd<i32, 64>, !wave.mem.token
  } : !wave.mask<64> -> !wave.simd<i32, 64>, !wave.mem.token
  return %result#0, %result#1 : !wave.simd<i32, 64>, !wave.mem.token
}

// CHECK-LABEL: func.func @keep_nested_otherwise
// CHECK: wave.where
// CHECK: wave.load
// CHECK: } otherwise {
// CHECK: scf.if
// CHECK: call @effect()
// CHECK: wave.yield
func.func @keep_nested_otherwise(
    %base: !wave.ptr<#wave.global, i32>, %active: !wave.mask<64>,
    %other: !wave.simd<i32, 64>, %flag: i1)
    -> (!wave.simd<i32, 64>, !wave.mem.token) {
  %range = arith.constant 4096 : i32
  %buffer = waveamd.make_buffer %base, %range
      : !wave.ptr<#wave.global, i32>, i32 -> !wave.ptr<#waveamd.buffer, i32>
  %lane = wave.lane_id : !wave.simd<i32, 64>
  %ptr = wave.ptr_add %buffer, %lane
      : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>
  %dependency = wave.token : !wave.mem.token
  %result:2 = wave.where %active {
    %value, %token = wave.load %ptr after %dependency
        : (!wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>, !wave.mem.token)
        -> (!wave.simd<i32, 64>, !wave.mem.token)
    wave.yield %value, %token : !wave.simd<i32, 64>, !wave.mem.token
  } otherwise {
    scf.if %flag {
      func.call @effect() : () -> ()
    }
    wave.yield %other, %dependency : !wave.simd<i32, 64>, !wave.mem.token
  } : !wave.mask<64> -> !wave.simd<i32, 64>, !wave.mem.token
  return %result#0, %result#1 : !wave.simd<i32, 64>, !wave.mem.token
}

// CHECK-LABEL: func.func @keep_nonspeculatable_otherwise
// CHECK: wave.where
// CHECK: wave.load
// CHECK: } otherwise {
// CHECK: arith.divsi
// CHECK: wave.splat
// CHECK: wave.yield
func.func @keep_nonspeculatable_otherwise(
    %base: !wave.ptr<#wave.global, i32>, %active: !wave.mask<64>,
    %other: !wave.simd<i32, 64>, %numerator: i32, %denominator: i32)
    -> (!wave.simd<i32, 64>, !wave.mem.token) {
  %range = arith.constant 4096 : i32
  %buffer = waveamd.make_buffer %base, %range
      : !wave.ptr<#wave.global, i32>, i32 -> !wave.ptr<#waveamd.buffer, i32>
  %lane = wave.lane_id : !wave.simd<i32, 64>
  %ptr = wave.ptr_add %buffer, %lane
      : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>
  %dependency = wave.token : !wave.mem.token
  %result:2 = wave.where %active {
    %value, %token = wave.load %ptr after %dependency
        : (!wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>, !wave.mem.token)
        -> (!wave.simd<i32, 64>, !wave.mem.token)
    wave.yield %value, %token : !wave.simd<i32, 64>, !wave.mem.token
  } otherwise {
    %quotient = arith.divsi %numerator, %denominator : i32
    %computed = wave.splat %quotient : i32 -> !wave.simd<i32, 64>
    wave.yield %computed, %dependency : !wave.simd<i32, 64>, !wave.mem.token
  } : !wave.mask<64> -> !wave.simd<i32, 64>, !wave.mem.token
  return %result#0, %result#1 : !wave.simd<i32, 64>, !wave.mem.token
}

}
