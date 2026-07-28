// RUN: wave-opt --split-input-file --verify-diagnostics %s

func.func @d2_with_extra_groups(
    %d0: vector<4xi32>, %d1: vector<8xi32>,
    %d2: vector<4xi32>, %d3: vector<4xi32>,
    %dependency: !wave.mem.token) {
  // expected-error @below {{d2 requires 0 extra dword groups}}
  %token = waveamd.tdm_load d2 %d0, %d1, %d2, %d3 after %dependency
      : (vector<4xi32>, vector<8xi32>, !wave.mem.token,
         vector<4xi32>, vector<4xi32>) -> !wave.mem.token
  return
}

// -----

func.func @d4_without_extra_groups(
    %d0: vector<4xi32>, %d1: vector<8xi32>,
    %dependency: !wave.mem.token) {
  // expected-error @below {{d4 requires 2 extra dword groups}}
  %token = waveamd.tdm_store d4 %d0, %d1 after %dependency
      : (vector<4xi32>, vector<8xi32>, !wave.mem.token)
        -> !wave.mem.token
  return
}

// -----

func.func @load_store_cache(
    %d0: vector<4xi32>, %d1: vector<8xi32>,
    %dependency: !wave.mem.token) {
  // expected-error @below {{cache must use #waveamd.load_cache}}
  %token = waveamd.tdm_load d2 %d0, %d1 after %dependency
      {cache = #waveamd.store_cache<cs>}
      : (vector<4xi32>, vector<8xi32>, !wave.mem.token)
        -> !wave.mem.token
  return
}

// -----

func.func @store_load_cache(
    %d0: vector<4xi32>, %d1: vector<8xi32>,
    %dependency: !wave.mem.token) {
  // expected-error @below {{cache must use #waveamd.store_cache}}
  %token = waveamd.tdm_store d2 %d0, %d1 after %dependency
      {cache = #waveamd.load_cache<cg>}
      : (vector<4xi32>, vector<8xi32>, !wave.mem.token)
        -> !wave.mem.token
  return
}

// -----

func.func @prefetch_offset_type(
    %d0: vector<4xi32>, %offset: !wave.simd<i64, 32>,
    %dependency: !wave.mem.token) {
  // expected-error @below {{byte offset must have i32 SIMD elements}}
  %token = waveamd.tdm_prefetch regular %d0, %offset after %dependency
      : (vector<4xi32>, !wave.simd<i64, 32>, !wave.mem.token)
        -> !wave.mem.token
  return
}
