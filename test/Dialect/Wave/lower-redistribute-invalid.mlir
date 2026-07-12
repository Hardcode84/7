// RUN: wave-opt --wave-lower-redistribute --split-input-file --verify-diagnostics %s

func.func @unknown_shape(%source: !wave.simd<vector<1xi32>, 32>) {
  // expected-error @+1 {{requires a known workgroup shape}}
  %result = wave.redistribute %source,
      <items = 32, source_item = "item", source_slot = "slot">
      : !wave.simd<vector<1xi32>, 32> -> !wave.simd<vector<1xi32>, 32>
  return
}

// -----

func.func @shape_mismatch(%source: !wave.simd<vector<1xi32>, 32>)
    attributes {wave.workgroup_size = array<i32: 64, 1, 1>} {
  // expected-error @+1 {{relation item count 32 does not match workgroup size 64}}
  %result = wave.redistribute %source,
      <items = 32, source_item = "item", source_slot = "slot">
      : !wave.simd<vector<1xi32>, 32> -> !wave.simd<vector<1xi32>, 32>
  return
}

// -----

func.func @multidimensional(%source: !wave.simd<vector<1xi32>, 32>)
    attributes {wave.workgroup_size = array<i32: 32, 2, 1>} {
  // expected-error @+1 {{requires an X-linear workgroup shape [items, 1, 1]}}
  %result = wave.redistribute %source,
      <items = 64, source_item = "item", source_slot = "slot">
      : !wave.simd<vector<1xi32>, 32> -> !wave.simd<vector<1xi32>, 32>
  return
}

// -----

func.func @partial_wave(%source: !wave.simd<vector<1xi32>, 32>)
    attributes {wave.workgroup_size = array<i32: 48, 1, 1>} {
  // expected-error @+1 {{workgroup size must be divisible by SIMD width}}
  %result = wave.redistribute %source,
      <items = 48, source_item = "item", source_slot = "slot">
      : !wave.simd<vector<1xi32>, 32> -> !wave.simd<vector<1xi32>, 32>
  return
}

// -----

func.func @masked(%source: !wave.simd<vector<1xi32>, 32>,
                  %condition: !wave.mask<32>)
    attributes {wave.workgroup_size = array<i32: 32, 1, 1>} {
  wave.where %condition {
    // expected-error @+1 {{requires full-wave execution outside wave.where}}
    %result = wave.redistribute %source,
        <items = 32, source_item = "item", source_slot = "slot">
        : !wave.simd<vector<1xi32>, 32> -> !wave.simd<vector<1xi32>, 32>
  } : !wave.mask<32>
  return
}

// -----

func.func @cross_wave_i64(%source: !wave.simd<vector<1xi64>, 32>)
    attributes {wave.workgroup_size = array<i32: 64, 1, 1>} {
  // expected-error @+1 {{cross-wave payload element must be 8, 16, or 32 bits wide}}
  %result = wave.redistribute %source,
      <items = 64, source_item = "xor(item, 32)", source_slot = "slot">
      : !wave.simd<vector<1xi64>, 32> -> !wave.simd<vector<1xi64>, 32>
  return
}
