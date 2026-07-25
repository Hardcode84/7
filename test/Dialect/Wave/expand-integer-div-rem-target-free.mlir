// RUN: not wave-opt --mlir-very-unsafe-disable-verifier-on-parsing \
// RUN:   --verify-each=false \
// RUN:   --pass-pipeline='builtin.module(func.func(wave-expand-integer-div-rem))' \
// RUN:   %s 2>&1 | FileCheck %s

// CHECK-NOT: error: 'wave.cast' op unknown policy field 'target_free'
// CHECK: error: 'wave.cast' op unknown policy field 'target_bearing'
// CHECK: error: 'wave.binary' op integer div/rem expansion supports at most 64-bit elements
// CHECK-NOT: error:

module {
  func.func @target_free() {
    %c = arith.constant 1.000000e+00 : f32
    %r = wave.cast fpconvert %c
        policy {target_free = #wave.cast_rounding<rne>} : f32 -> f16
    return
  }

  func.func @target_bearing(%x: i128, %d: i128) -> i128 {
    %c = arith.constant 1.000000e+00 : f32
    %r = wave.cast fpconvert %c
        policy {target_bearing = #wave.cast_rounding<rne>} : f32 -> f16
    %q = wave.binary divui %x, %d : i128, i128 -> i128
    return %q : i128
  }
}
