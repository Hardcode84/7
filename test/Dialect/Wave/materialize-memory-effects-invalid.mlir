// RUN: wave-opt %s --wave-materialize-memory-variants --verify-diagnostics

func.func private @effect(!wave.simd<!wave.ptr<#wave.global, i32>, 64>)
func.func @reject_effect_duplication(%out: !wave.ptr<#wave.global, i32>, %a: !wave.simd<i32, 64>, %b: !wave.simd<i32, 64>) {
  %offset = wave.materialization_variants %a, %b : !wave.simd<i32, 64>
  %ptr = wave.ptr_add %out, %offset : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.global, i32>, 64>
  // expected-error @below {{memory alternatives require discardable effects}}
  func.call @effect(%ptr) : (!wave.simd<!wave.ptr<#wave.global, i32>, 64>) -> ()
  return
}
