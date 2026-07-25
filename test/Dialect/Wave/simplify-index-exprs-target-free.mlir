// RUN: wave-opt --mlir-very-unsafe-disable-verifier-on-parsing \
// RUN:   --verify-each=false \
// RUN:   --pass-pipeline='builtin.module(func.func(wave-simplify-index-exprs))' \
// RUN:   %s 2>&1 | FileCheck %s

// CHECK-NOT: error: 'wave.cast' op unknown policy field 'target_free'
// CHECK: error: 'wave.cast' op unknown policy field 'target_bearing'
// CHECK-NOT: error:

module {
  func.func @target_free() {
    %c = arith.constant 1.000000e+00 : f32
    %r = wave.cast fpconvert %c
        policy {target_free = #wave.cast_rounding<rne>} : f32 -> f16
    return
  }

  func.func @target_bearing() {
    %c = arith.constant 1.000000e+00 : f32
    %r = wave.cast fpconvert %c
        policy {target_bearing = #wave.cast_rounding<rne>} : f32 -> f16
    %idx = wave.index_expr <"0"> []() : () -> index
    return
  }
}
