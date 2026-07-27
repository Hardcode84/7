// RUN: wave-opt --split-input-file --verify-diagnostics %s

func.func @shared_pointer(
    %ptr: !wave.ptr<#wave.shared, i32>, %value: !wave.simd<i32, 64>) {
  // expected-error @+1 {{atomic pointer must be global}}
  %old, %token = waveamd.global_atomic_add_acq_rel %value to %ptr
      : (!wave.ptr<#wave.shared, i32>, !wave.simd<i32, 64>)
        -> (!wave.simd<i32, 64>, !wave.mem.token)
  return
}

// -----

func.func @pointer_element_type(
    %ptr: !wave.ptr<#wave.global, i64>, %value: !wave.simd<i32, 64>) {
  // expected-error @+1 {{atomic pointer element type must be i32}}
  %old, %token = waveamd.global_atomic_add_acq_rel %value to %ptr
      : (!wave.ptr<#wave.global, i64>, !wave.simd<i32, 64>)
        -> (!wave.simd<i32, 64>, !wave.mem.token)
  return
}

// -----

func.func @value_element_type(
    %ptr: !wave.ptr<#wave.global, i32>, %value: !wave.simd<i64, 64>) {
  // expected-error @+1 {{atomic value must have i32 SIMD elements}}
  %old, %token = waveamd.global_atomic_add_acq_rel %value to %ptr
      : (!wave.ptr<#wave.global, i32>, !wave.simd<i64, 64>)
        -> (!wave.simd<i64, 64>, !wave.mem.token)
  return
}

// -----

func.func @pointer_width(
    %ptr: !wave.simd<!wave.ptr<#wave.global, i32>, 32>,
    %value: !wave.simd<i32, 64>) {
  // expected-error @+1 {{atomic pointer and value SIMD widths must match}}
  %old, %token = waveamd.global_atomic_add_acq_rel %value to %ptr
      : (!wave.simd<!wave.ptr<#wave.global, i32>, 32>, !wave.simd<i32, 64>)
        -> (!wave.simd<i32, 64>, !wave.mem.token)
  return
}

// -----

func.func @result_type(
    %ptr: !wave.ptr<#wave.global, i32>, %value: !wave.simd<i32, 64>) {
  // expected-error @+1 {{result type must match atomic value type}}
  %old, %token = waveamd.global_atomic_add_acq_rel %value to %ptr
      : (!wave.ptr<#wave.global, i32>, !wave.simd<i32, 64>)
        -> (!wave.simd<i32, 32>, !wave.mem.token)
  return
}
