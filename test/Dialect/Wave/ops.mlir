// RUN: wave-opt %s | FileCheck %s
// RUN: wave-opt %s | wave-opt | FileCheck %s

// CHECK-LABEL: func.func @wave_ops
func.func @wave_ops(%pred: i1, %value: i32, %out: !wave.ptr<i32, #wave.global>) -> i32 {
  // CHECK: wave.lane_id : !wave.simd<i32, 32>
  %lane = wave.lane_id : !wave.simd<i32, 32>
  // CHECK: wave.splat
  %vvalue = wave.splat %value : i32 -> !wave.simd<i32, 32>
  // CHECK: wave.binary
  %sum = wave.binary "addi" %lane, %vvalue : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  // CHECK: wave.cmpi
  %mask = wave.cmpi ult %lane, %vvalue : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  // CHECK: wave.subgroup_id
  %subgroup = wave.subgroup_id
  // CHECK: wave.subgroup_size
  %size = wave.subgroup_size
  // CHECK: wave.ballot {{.*}} : !wave.mask<32> -> i32
  %bits = wave.ballot %mask : !wave.mask<32> -> i32
  // CHECK: wave.read_first {{.*}} : !wave.simd<i32, 32> -> i32
  %first = wave.read_first %sum : !wave.simd<i32, 32> -> i32
  // CHECK: wave.store
  %tok = wave.store %sum -> %out : (!wave.simd<i32, 32>, !wave.ptr<i32, #wave.global>) -> !wave.mem.token

  // CHECK: wave.where
  wave.where %mask {
    wave.yield
  } otherwise {
    wave.yield
  } : !wave.mask<32>

  func.return %first : i32
}
