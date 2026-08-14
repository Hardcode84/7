// RUN: wave-opt --mlir-very-unsafe-disable-verifier-on-parsing \
// RUN:   --verify-each=false \
// RUN:   --pass-pipeline='builtin.module(func.func(wave-optimize-masks))' \
// RUN:   %s 2>&1 | FileCheck %s

// CHECK-NOT: error:
// CHECK: func.func @target_bearing
// CHECK-NOT: error:

module {
  func.func @target_free() {
    %c = arith.constant 1.000000e+00 : f32
    %r = wave.cast fpconvert %c
        policy {target_free = #wave.cast_rounding<rne>} : f32 -> f16
    return
  }

  func.func @target_bearing(
      %lhs: !wave.simd<i32, 32>, %rhs: !wave.simd<i32, 32>)
      -> !wave.mask<32> {
    %c = arith.constant 1.000000e+00 : f32
    %r = wave.cast fpconvert %c
        policy {target_bearing = #wave.cast_rounding<rne>} : f32 -> f16
    %mask = wave.cmpi slt %lhs, %rhs
        : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
    return %mask : !wave.mask<32>
  }
}
