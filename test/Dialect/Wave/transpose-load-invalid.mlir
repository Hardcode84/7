// RUN: wave-opt --split-input-file --verify-diagnostics %s

func.func @transpose_load_global(%p: !wave.ptr<#wave.global, i8>) {
  // expected-error @+1 {{source pointer must be shared}}
  %v, %tok = waveamd.transpose_load %p
      : (!wave.ptr<#wave.global, i8>)
        -> (!wave.simd<vector<8xi8>, 64>, !wave.mem.token)
  return
}

// -----

func.func @transpose_load_bad_source_width(%p: !wave.simd<!wave.ptr<#wave.shared, i8>, 32>) {
  // expected-error @+1 {{source SIMD width must be 64}}
  %v, %tok = waveamd.transpose_load %p
      : (!wave.simd<!wave.ptr<#wave.shared, i8>, 32>)
        -> (!wave.simd<vector<8xi8>, 64>, !wave.mem.token)
  return
}

// -----

func.func @transpose_load_bad_ptr_element(%p: !wave.ptr<#wave.shared, i32>) {
  // expected-error @+1 {{source pointer element type must be i8 for i4/i8 transpose load}}
  %v, %tok = waveamd.transpose_load %p
      : (!wave.ptr<#wave.shared, i32>)
        -> (!wave.simd<vector<8xi8>, 64>, !wave.mem.token)
  return
}

// -----

func.func @transpose_load_bad_i8_count(%p: !wave.ptr<#wave.shared, i8>) {
  // expected-error @+1 {{i8 transpose load result must have 8 elements}}
  %v, %tok = waveamd.transpose_load %p
      : (!wave.ptr<#wave.shared, i8>)
        -> (!wave.simd<vector<4xi8>, 64>, !wave.mem.token)
  return
}

// -----

func.func @transpose_load_bad_i4_count(%p: !wave.ptr<#wave.shared, i8>) {
  // expected-error @+1 {{i4 transpose load result must have 16 elements}}
  %v, %tok = waveamd.transpose_load %p
      : (!wave.ptr<#wave.shared, i8>)
        -> (!wave.simd<vector<8xi4>, 64>, !wave.mem.token)
  return
}

// -----

func.func @transpose_load_bad_b16_count(%p: !wave.ptr<#wave.shared, f16>) {
  // expected-error @+1 {{16-bit transpose load result must have 4 elements}}
  %v, %tok = waveamd.transpose_load %p
      : (!wave.ptr<#wave.shared, f16>)
        -> (!wave.simd<vector<2xf16>, 64>, !wave.mem.token)
  return
}

// -----

func.func @transpose_load_bad_b16_ptr_element(%p: !wave.ptr<#wave.shared, i8>) {
  // expected-error @+1 {{source pointer element type must be i16, f16, or bf16 for 16-bit transpose load}}
  %v, %tok = waveamd.transpose_load %p
      : (!wave.ptr<#wave.shared, i8>)
        -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
  return
}

// -----

func.func @transpose_load_bad_element(%p: !wave.ptr<#wave.shared, i8>) {
  // expected-error @+1 {{transpose load result element type must be i4, i8, i16, f16, or bf16}}
  %v, %tok = waveamd.transpose_load %p
      : (!wave.ptr<#wave.shared, i8>)
        -> (!wave.simd<vector<4xf32>, 64>, !wave.mem.token)
  return
}

// -----

func.func @transpose_load_bad_result_width(%p: !wave.ptr<#wave.shared, i8>) {
  // expected-error @+1 {{result SIMD width must be 64}}
  %v, %tok = waveamd.transpose_load %p
      : (!wave.ptr<#wave.shared, i8>)
        -> (!wave.simd<vector<8xi8>, 32>, !wave.mem.token)
  return
}
