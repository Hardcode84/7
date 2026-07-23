// RUN: wave-opt --wave-lower-redistribute --split-input-file --verify-diagnostics %s

func.func @source_slot_oob(%source: !wave.simd<vector<2xi32>, 32>)
    attributes {wave.workgroup_size = array<i32: 32, 1, 1>} {
  // expected-error @+1 {{source slot 2 is out of bounds at destination (0, 0, 0)}}
  %result = wave.redistribute %source,
      <blocks = 1, items = 32, source_block = "block",
       source_item = "item", source_slot = "2">
      : !wave.simd<vector<2xi32>, 32> -> !wave.simd<vector<2xi32>, 32>
  return
}

// -----

func.func @source_item_oob(%source: !wave.simd<vector<1xi32>, 32>)
    attributes {wave.workgroup_size = array<i32: 32, 1, 1>} {
  // expected-error @+1 {{source item 32 is out of bounds at destination (0, 0, 0)}}
  %result = wave.redistribute %source,
      <blocks = 1, items = 32, source_block = "block",
       source_item = "32", source_slot = "slot">
      : !wave.simd<vector<1xi32>, 32> -> !wave.simd<vector<1xi32>, 32>
  return
}

// -----

func.func @partial_piecewise(%source: !wave.simd<vector<2xi32>, 32>)
    attributes {wave.workgroup_size = array<i32: 32, 1, 1>} {
  // expected-error @+1 {{relation is not total at destination (0, 0, 1)}}
  %result = wave.redistribute %source,
      <blocks = 1, items = 32, source_block = "block",
       source_item = "item", source_slot = "Piecewise((0, slot == 0))">
      : !wave.simd<vector<2xi32>, 32> -> !wave.simd<vector<2xi32>, 32>
  return
}

// -----

func.func @partial_division(%source: !wave.simd<vector<2xi32>, 32>)
    attributes {wave.workgroup_size = array<i32: 32, 1, 1>} {
  // expected-error @+1 {{relation is not total at destination (0, 1, 0)}}
  %result = wave.redistribute %source,
      <blocks = 1, items = 32, source_block = "block",
       source_item = "item",
       source_slot = "Mod(floor(1 / (item - 1)), 2)">
      : !wave.simd<vector<2xi32>, 32> -> !wave.simd<vector<2xi32>, 32>
  return
}

// -----

func.func @source_block_oob(%source: !wave.simd<vector<1xi32>, 32>)
    attributes {wave.workgroup_size = array<i32: 32, 1, 1>} {
  // expected-error @+1 {{source block 2 is out of bounds at destination (0, 0, 0)}}
  %result = wave.redistribute %source,
      <blocks = 2, items = 32, source_block = "2",
       source_item = "item", source_slot = "slot">
      : !wave.simd<vector<1xi32>, 32> -> !wave.simd<vector<1xi32>, 32>
  return
}

// -----

func.func @partial_source_block(%source: !wave.simd<vector<1xi32>, 32>)
    attributes {wave.workgroup_size = array<i32: 32, 1, 1>} {
  // expected-error @+1 {{relation is not total at destination (1, 0, 0)}}
  %result = wave.redistribute %source,
      <blocks = 2, items = 32,
       source_block = "Piecewise((block, block == 0))",
       source_item = "item", source_slot = "slot">
      : !wave.simd<vector<1xi32>, 32> -> !wave.simd<vector<1xi32>, 32>
  return
}

// -----

func.func @exhaustive_limit(%source: !wave.simd<vector<1xi32>, 32>)
    attributes {wave.workgroup_size = array<i32: 1048608, 1, 1>} {
  // expected-error @+1 {{symbolic movement classification exceeds the 2^20 point limit}}
  %result = wave.redistribute %source,
      <blocks = 1, items = 1048608, source_block = "block",
       source_item = "Piecewise((item, item >= 0), (0, True))",
       source_slot = "0">
      : !wave.simd<vector<1xi32>, 32> -> !wave.simd<vector<1xi32>, 32>
  return
}

// -----

func.func @unknown_shape(%source: !wave.simd<vector<1xi32>, 32>) {
  // expected-error @+1 {{requires a known workgroup shape}}
  %result = wave.redistribute %source,
      <blocks = 1, items = 32, source_block = "block", source_item = "item", source_slot = "slot">
      : !wave.simd<vector<1xi32>, 32> -> !wave.simd<vector<1xi32>, 32>
  return
}

// -----

func.func @shape_mismatch(%source: !wave.simd<vector<1xi32>, 32>)
    attributes {wave.workgroup_size = array<i32: 64, 1, 1>} {
  // expected-error @+1 {{relation item count 32 does not match workgroup size 64}}
  %result = wave.redistribute %source,
      <blocks = 1, items = 32, source_block = "block", source_item = "item", source_slot = "slot">
      : !wave.simd<vector<1xi32>, 32> -> !wave.simd<vector<1xi32>, 32>
  return
}

// -----

func.func @multidimensional(%source: !wave.simd<vector<1xi32>, 32>)
    attributes {wave.workgroup_size = array<i32: 32, 2, 1>} {
  // expected-error @+1 {{requires an X-linear workgroup shape [items, 1, 1]}}
  %result = wave.redistribute %source,
      <blocks = 1, items = 64, source_block = "block", source_item = "item", source_slot = "slot">
      : !wave.simd<vector<1xi32>, 32> -> !wave.simd<vector<1xi32>, 32>
  return
}

// -----

func.func @partial_wave(%source: !wave.simd<vector<1xi32>, 32>)
    attributes {wave.workgroup_size = array<i32: 48, 1, 1>} {
  // expected-error @+1 {{workgroup size must be divisible by SIMD width}}
  %result = wave.redistribute %source,
      <blocks = 1, items = 48, source_block = "block", source_item = "item", source_slot = "slot">
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
        <blocks = 1, items = 32, source_block = "block", source_item = "item", source_slot = "slot">
        : !wave.simd<vector<1xi32>, 32> -> !wave.simd<vector<1xi32>, 32>
  } : !wave.mask<32>
  return
}

// -----

func.func @cross_wave_i64(%source: !wave.simd<vector<1xi64>, 32>)
    attributes {wave.workgroup_size = array<i32: 64, 1, 1>} {
  // expected-error @+1 {{cross-wave payload element must be 8, 16, or 32 bits wide}}
  %result = wave.redistribute %source,
      <blocks = 1, items = 64, source_block = "block", source_item = "xor(item, 32)", source_slot = "slot">
      : !wave.simd<vector<1xi64>, 32> -> !wave.simd<vector<1xi64>, 32>
  return
}

// -----

func.func @cross_block(%source: !wave.simd<vector<1xi32>, 32>)
    attributes {wave.workgroup_size = array<i32: 32, 1, 1>} {
  // expected-error @+1 {{cross-block redistribution requires cluster/DSM lowering}}
  %result = wave.redistribute %source,
      <blocks = 2, items = 32, source_block = "xor(block, 1)", source_item = "item", source_slot = "slot">
      : !wave.simd<vector<1xi32>, 32> -> !wave.simd<vector<1xi32>, 32>
  return
}

// -----

func.func @block_dependent_local(%source: !wave.simd<vector<1xi32>, 32>)
    attributes {wave.workgroup_size = array<i32: 32, 1, 1>} {
  // expected-error @+1 {{block-dependent redistribution requires a cluster block coordinate}}
  %result = wave.redistribute %source,
      <blocks = 2, items = 32, source_block = "block", source_item = "xor(item, block)", source_slot = "slot">
      : !wave.simd<vector<1xi32>, 32> -> !wave.simd<vector<1xi32>, 32>
  return
}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
  func.func @nested_scratch_exceeds_lds(%condition: i1)
      attributes {wave.kernel, wave.lds_size = 65440 : i64,
                  wave.workgroup_size = array<i32: 64, 1, 1>,
                  wave.waves_per_workgroup = 2 : i64} {
    %zero = wave.constant 0 : i8 -> !wave.simd<i8, 32>
    %source = wave.pack %zero
        : !wave.simd<i8, 32> -> !wave.simd<vector<1xi8>, 32>
    %first = scf.if %condition -> (!wave.simd<vector<1xi8>, 32>) {
      %moved = wave.redistribute %source,
          <blocks = 1, items = 64, source_block = "block",
           source_item = "xor(item, 32)", source_slot = "slot">
          : !wave.simd<vector<1xi8>, 32> -> !wave.simd<vector<1xi8>, 32>
      scf.yield %moved : !wave.simd<vector<1xi8>, 32>
    } else {
      scf.yield %source : !wave.simd<vector<1xi8>, 32>
    }
    %second = scf.if %condition -> (!wave.simd<vector<1xi8>, 32>) {
      // expected-error @+1 {{remaining target LDS capacity 32 bytes cannot hold one 64-byte scratch vector group}}
      %moved = wave.redistribute %first,
          <blocks = 1, items = 64, source_block = "block",
           source_item = "xor(item, 32)", source_slot = "slot">
          : !wave.simd<vector<1xi8>, 32> -> !wave.simd<vector<1xi8>, 32>
      scf.yield %moved : !wave.simd<vector<1xi8>, 32>
    } else {
      scf.yield %first : !wave.simd<vector<1xi8>, 32>
    }
    return
  }
}
