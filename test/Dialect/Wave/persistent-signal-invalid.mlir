// RUN: wave-opt --split-input-file --verify-diagnostics %s

func.func @poll_expected_i64(
    %ptr: !wave.ptr<#wave.shared, i32>, %expected: i64) {
  // expected-error @+1 {{expected value must be i32}}
  %token = waveamd.lds_poll_eq %ptr equals %expected
      : (!wave.ptr<#wave.shared, i32>, i64) -> !wave.mem.token
  return
}

// -----

func.func @atomic_value_i64(
    %ptr: !wave.ptr<#wave.shared, i32>, %value: !wave.simd<i64, 64>) {
  // expected-error @+1 {{atomic value must have i32 SIMD elements}}
  %old, %token = waveamd.lds_atomic_add %value to %ptr
      : (!wave.ptr<#wave.shared, i32>, !wave.simd<i64, 64>)
        -> (!wave.simd<i64, 64>, !wave.mem.token)
  return
}

// -----

func.func @atomic_result_mismatch(
    %ptr: !wave.ptr<#wave.shared, i32>, %value: !wave.simd<i32, 64>) {
  // expected-error @+1 {{result type must match atomic value type}}
  %old, %token = waveamd.lds_atomic_add %value to %ptr
      : (!wave.ptr<#wave.shared, i32>, !wave.simd<i32, 64>)
        -> (!wave.simd<i32, 32>, !wave.mem.token)
  return
}
