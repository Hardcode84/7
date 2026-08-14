// RUN: wave-opt --wave-lower-redistribute --split-input-file --verify-diagnostics %s

func.func @reduction_specialization_budget(%source: !wave.simd<i32, 32>)
    attributes {wave.workgroup_size = array<i32: 32, 1, 1>} {
  // expected-error @+1 {{reduction specialization requires 1048577 points, exceeding the 2^20 point limit}}
  %result = wave.reduce %source using
      #wave.redistribution<blocks = 1, items = 32, source_block = "block",
                           source_item = "item", source_slot = "0">
      extent 1048577 : !wave.simd<i32, 32> -> !wave.simd<i32, 32> {
    ^bb0(%lhs: !wave.simd<i32, 32>, %rhs: !wave.simd<i32, 32>):
      wave.yield %lhs : !wave.simd<i32, 32>
    }
  return
}

// -----

func.func @nonlinear_slot_map_uses_exact_scalar_factor(
    %source: !wave.simd<vector<128xi8>, 64>)
    attributes {wave.workgroup_size = array<i32: 128, 1, 1>} {
  %result = wave.redistribute %source,
      <blocks = 1, items = 128,
       source_block = "block", source_item = "xor(item, 64)",
       source_slot = "xor(slot, floor(1/127*item)*xor(slot, 2*Mod(slot, 2) + 4*Mod(floor(1/2*slot), 2) + Mod(floor(1/4*slot), 2) + 16*Mod(floor(1/8*slot), 2) + 32*Mod(floor(1/16*slot), 2) + 64*Mod(floor(1/32*slot), 2) + 8*floor(1/64*slot)))">
      : !wave.simd<vector<128xi8>, 64>
     -> !wave.simd<vector<128xi8>, 64>
  return
}

// -----

func.func @reduction_specialization_overflow(
    %source: !wave.simd<vector<2xi32>, 32>)
    attributes {wave.workgroup_size = array<i32: 32, 1, 1>} {
  // expected-error @+1 {{reduction specialization point count overflows i64}}
  %result = wave.reduce %source using
      #wave.redistribution<blocks = 1, items = 32, source_block = "block",
                           source_item = "item", source_slot = "slot">
      extent 9223372036854775807
      : !wave.simd<vector<2xi32>, 32> -> !wave.simd<vector<2xi32>, 32> {
    ^bb0(%lhs: !wave.simd<i32, 32>, %rhs: !wave.simd<i32, 32>):
      wave.yield %lhs : !wave.simd<i32, 32>
    }
  return
}

// -----

func.func @reduction_source_slot_oob(%source: !wave.simd<i32, 32>)
    attributes {wave.workgroup_size = array<i32: 32, 1, 1>} {
  // expected-error @+1 {{relation source slot 1 is outside the source packet at result slot 0, reduction coordinate 1}}
  %result = wave.reduce %source using
      #wave.redistribution<blocks = 1, items = 32, source_block = "block",
                           source_item = "item", source_slot = "reduction">
      extent 2 : !wave.simd<i32, 32> -> !wave.simd<i32, 32> {
    ^bb0(%lhs: !wave.simd<i32, 32>, %rhs: !wave.simd<i32, 32>):
      wave.yield %lhs : !wave.simd<i32, 32>
    }
  return
}

// -----

func.func @source_slot_oob(%source: !wave.simd<vector<2xi32>, 32>)
    attributes {wave.workgroup_size = array<i32: 32, 1, 1>} {
  // expected-error @+1 {{redistribution relation is not provably total, integral, and in bounds}}
  %result = wave.redistribute %source,
      <blocks = 1, items = 32, source_block = "block",
       source_item = "item", source_slot = "2">
      : !wave.simd<vector<2xi32>, 32> -> !wave.simd<vector<2xi32>, 32>
  return
}

// -----

func.func @source_item_oob(%source: !wave.simd<vector<1xi32>, 32>)
    attributes {wave.workgroup_size = array<i32: 32, 1, 1>} {
  // expected-error @+1 {{redistribution relation is not provably total, integral, and in bounds}}
  %result = wave.redistribute %source,
      <blocks = 1, items = 32, source_block = "block",
       source_item = "32", source_slot = "slot">
      : !wave.simd<vector<1xi32>, 32> -> !wave.simd<vector<1xi32>, 32>
  return
}

// -----

// A missing piecewise arm is poison and may refine to an in-bounds source.
func.func @poison_piecewise_refines(%source: !wave.simd<vector<2xi32>, 32>)
    attributes {wave.workgroup_size = array<i32: 32, 1, 1>} {
  %result = wave.redistribute %source,
      <blocks = 1, items = 32, source_block = "block",
       source_item = "item", source_slot = "Piecewise((0, slot == 0))">
      : !wave.simd<vector<2xi32>, 32> -> !wave.simd<vector<2xi32>, 32>
  return
}

// -----

// Division by zero is poison and may refine to an in-bounds source slot.
func.func @poison_division_refines(%source: !wave.simd<vector<2xi32>, 32>)
    attributes {wave.workgroup_size = array<i32: 32, 1, 1>} {
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
  // expected-error @+1 {{redistribution relation is not provably total, integral, and in bounds}}
  %result = wave.redistribute %source,
      <blocks = 2, items = 32, source_block = "2",
       source_item = "item", source_slot = "slot">
      : !wave.simd<vector<1xi32>, 32> -> !wave.simd<vector<1xi32>, 32>
  return
}

// -----

// A missing piecewise arm may likewise refine to an in-bounds source block.
func.func @poison_source_block_refines(%source: !wave.simd<vector<1xi32>, 32>)
    attributes {wave.workgroup_size = array<i32: 32, 1, 1>} {
  %result = wave.redistribute %source,
      <blocks = 2, items = 32,
       source_block = "Piecewise((block, block == 0))",
       source_item = "item", source_slot = "slot">
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

func.func @cross_wave_pointer(
    %source: !wave.simd<!wave.ptr<#wave.global, f32>, 32>)
    attributes {wave.workgroup_size = array<i32: 64, 1, 1>} {
  // expected-error @+1 {{cross-wave pointer redistribution is unsupported}}
  %result = wave.redistribute %source,
      <blocks = 1, items = 64, source_block = "block",
       source_item = "xor(item, 32)", source_slot = "slot">
      : !wave.simd<!wave.ptr<#wave.global, f32>, 32>
        -> !wave.simd<!wave.ptr<#wave.global, f32>, 32>
  return
}

// -----

func.func @cross_block(%source: !wave.simd<vector<1xi32>, 32>)
    attributes {wave.workgroup_size = array<i32: 32, 1, 1>} {
  // expected-error @+1 {{cluster/DSM redistribution is unsupported}}
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
      // expected-error @+1 {{remaining target LDS capacity 32 bytes cannot hold one 64-element scratch plane}}
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

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
  func.func @repetitive_sibling_scratch_exceeds_lds(
      %condition: i1, %source0: !wave.simd<vector<4xi32>, 32>,
      %source1: !wave.simd<vector<4xi32>, 32>)
      attributes {wave.kernel, wave.lds_size = 65280 : i64,
                  wave.workgroup_size = array<i32: 64, 1, 1>,
                  wave.waves_per_workgroup = 2 : i64} {
    %lower = arith.constant 0 : index
    %upper = arith.constant 2 : index
    %step = arith.constant 1 : index
    scf.for %i = %lower to %upper step %step {
      %selected = scf.if %condition -> (!wave.simd<vector<4xi32>, 32>) {
        %then = wave.redistribute %source0,
            <blocks = 1, items = 64, source_block = "block",
             source_item = "xor(item, 32)", source_slot = "slot">
            : !wave.simd<vector<4xi32>, 32>
              -> !wave.simd<vector<4xi32>, 32>
        scf.yield %then : !wave.simd<vector<4xi32>, 32>
      } else {
        // expected-error @+1 {{remaining target LDS capacity 0 bytes cannot hold one 64-element scratch plane}}
        %else = wave.redistribute %source1,
            <blocks = 1, items = 64, source_block = "block",
             source_item = "xor(item, 32)", source_slot = "slot">
            : !wave.simd<vector<4xi32>, 32>
              -> !wave.simd<vector<4xi32>, 32>
        scf.yield %else : !wave.simd<vector<4xi32>, 32>
      }
    }
    return
  }
}
