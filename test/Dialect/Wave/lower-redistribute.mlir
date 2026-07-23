// RUN: wave-opt --wave-lower-redistribute --split-input-file %s | FileCheck %s

// CHECK-LABEL: func.func @identity(
// CHECK-NOT: wave.redistribute
// CHECK-NEXT: return %{{.*}} : !wave.simd<vector<2xi32>, 32>
func.func @identity(%source: !wave.simd<vector<2xi32>, 32>)
    -> !wave.simd<vector<2xi32>, 32>
    attributes {wave.workgroup_size = array<i32: 32, 1, 1>} {
  %result = wave.redistribute %source,
      <blocks = 1, items = 32, source_block = "block", source_item = "item", source_slot = "slot">
      : !wave.simd<vector<2xi32>, 32> -> !wave.simd<vector<2xi32>, 32>
  return %result : !wave.simd<vector<2xi32>, 32>
}

// -----

// CHECK-LABEL: func.func @reverse_slots(
// CHECK-NOT: wave.shuffle
// CHECK-NOT: wave.alloc
// CHECK: %[[LO:.*]] = wave.extract %{{.*}}[0]
// CHECK: %[[HI:.*]] = wave.extract %{{.*}}[1]
// CHECK: %[[PACK:.*]] = wave.pack %[[HI]], %[[LO]]
// CHECK: return %[[PACK]]
func.func @reverse_slots(%source: !wave.simd<vector<2xf32>, 32>)
    -> !wave.simd<vector<2xf32>, 32>
    attributes {wave.workgroup_size = array<i32: 32, 1, 1>} {
  %result = wave.redistribute %source,
      <blocks = 1, items = 32, source_block = "block", source_item = "item", source_slot = "1 - slot">
      : !wave.simd<vector<2xf32>, 32> -> !wave.simd<vector<2xf32>, 32>
  return %result : !wave.simd<vector<2xf32>, 32>
}

// -----

// CHECK-LABEL: func.func @item_selected_slot(
// CHECK-NOT: wave.shuffle
// CHECK-NOT: wave.alloc
// CHECK: wave.workitem_id 0
// CHECK: wave.index_expr
// CHECK: wave.cmpi eq
// CHECK: wave.select
func.func @item_selected_slot(%source: !wave.simd<vector<2xi32>, 32>)
    -> !wave.simd<vector<1xi32>, 32>
    attributes {wave.workgroup_size = array<i32: 32, 1, 1>} {
  %result = wave.redistribute %source,
      <blocks = 1, items = 32, source_block = "block", source_item = "item", source_slot = "Mod(item, 2)">
      : !wave.simd<vector<2xi32>, 32> -> !wave.simd<vector<1xi32>, 32>
  return %result : !wave.simd<vector<1xi32>, 32>
}

// -----

// CHECK-LABEL: func.func @piecewise_item(
// CHECK-NOT: wave.alloc
// CHECK: wave.shuffle
func.func @piecewise_item(%source: !wave.simd<vector<2xi32>, 32>)
    -> !wave.simd<vector<2xi32>, 32>
    attributes {wave.workgroup_size = array<i32: 32, 1, 1>} {
  %result = wave.redistribute %source,
      <blocks = 1, items = 32,
       source_block = "block", source_item = "Piecewise((item, slot == 0), (xor(item, 1), True))",
       source_slot = "slot">
      : !wave.simd<vector<2xi32>, 32> -> !wave.simd<vector<2xi32>, 32>
  return %result : !wave.simd<vector<2xi32>, 32>
}

// -----

// CHECK-LABEL: func.func @same_wave(
// CHECK-NOT: wave.alloc
// CHECK-NOT: wave.barrier
// CHECK: wave.workitem_id 0
// CHECK: wave.index_expr
// CHECK-COUNT-1: wave.shuffle {{.*}}!wave.simd<vector<2xi32>, 32>
// CHECK: wave.pack
func.func @same_wave(%source: !wave.simd<vector<2xi32>, 32>)
    -> !wave.simd<vector<2xi32>, 32>
    attributes {wave.workgroup_size = array<i32: 64, 1, 1>} {
  %result = wave.redistribute %source,
      <blocks = 1, items = 64, source_block = "block", source_item = "xor(item, 1)", source_slot = "slot">
      : !wave.simd<vector<2xi32>, 32> -> !wave.simd<vector<2xi32>, 32>
  return %result : !wave.simd<vector<2xi32>, 32>
}

// -----

// CHECK-LABEL: func.func @same_block_domain(
// CHECK-NOT: wave.alloc
// CHECK: wave.shuffle
func.func @same_block_domain(%source: !wave.simd<vector<1xi32>, 32>)
    -> !wave.simd<vector<1xi32>, 32>
    attributes {wave.workgroup_size = array<i32: 32, 1, 1>} {
  %result = wave.redistribute %source,
      <blocks = 2, items = 32, source_block = "block", source_item = "xor(item, 1)", source_slot = "slot">
      : !wave.simd<vector<1xi32>, 32> -> !wave.simd<vector<1xi32>, 32>
  return %result : !wave.simd<vector<1xi32>, 32>
}

// -----

// CHECK-LABEL: func.func @same_wave_uniform_if(
// CHECK: scf.if
// CHECK: wave.shuffle
func.func @same_wave_uniform_if(%source: !wave.simd<vector<1xi32>, 32>,
                                %condition: i1)
    attributes {wave.workgroup_size = array<i32: 64, 1, 1>} {
  scf.if %condition {
    %result = wave.redistribute %source,
        <blocks = 1, items = 64, source_block = "block", source_item = "xor(item, 1)", source_slot = "slot">
        : !wave.simd<vector<1xi32>, 32> -> !wave.simd<vector<1xi32>, 32>
  }
  return
}

// -----

// CHECK-LABEL: func.func @cross_wave(
// CHECK: %[[ALLOC:.*]] = wave.alloc()
// CHECK: %[[STOREVAL:.*]] = wave.pack {{.*}} -> !wave.simd<vector<2xi32>, 32>
// CHECK: %[[STORE:.*]] = wave.store %[[STOREVAL]]
// CHECK: %[[PUBLISH:.*]] = wave.barrier %[[STORE]]
// CHECK: %[[LOAD:.*]], %[[LOADTOK:.*]] = wave.load {{.*}} after %[[PUBLISH]] {{.*}} -> (!wave.simd<vector<2xi32>, 32>, !wave.mem.token)
// CHECK: %[[LOAD0:.*]] = wave.extract %[[LOAD]][0]
// CHECK: %[[LOAD1:.*]] = wave.extract %[[LOAD]][1]
// CHECK: %[[PACK:.*]] = wave.pack %[[LOAD0]], %[[LOAD1]]
// CHECK: %[[DONE:.*]] = wave.join %[[LOADTOK]]
// CHECK: wave.alloc_release %[[ALLOC]] after %[[DONE]] {workgroup_collective}
// CHECK-NOT: wave.redistribute
func.func @cross_wave(%source: !wave.simd<vector<2xi32>, 32>)
    -> !wave.simd<vector<2xi32>, 32>
    attributes {wave.workgroup_size = array<i32: 64, 1, 1>} {
  %result = wave.redistribute %source,
      <blocks = 1, items = 64, source_block = "block", source_item = "xor(item, 32)", source_slot = "slot">
      : !wave.simd<vector<2xi32>, 32> -> !wave.simd<vector<2xi32>, 32>
  return %result : !wave.simd<vector<2xi32>, 32>
}

// -----

// CHECK-LABEL: func.func @cross_wave_swizzled_vector(
// CHECK: %[[ALLOC:.*]] = wave.alloc() {align = 8 : i64, bytesize = 1024 : i64}
// CHECK: wave.pack {{.*}} -> !wave.simd<vector<2xi32>, 32>
// CHECK: wave.store {{.*}} : (!wave.simd<vector<2xi32>, 32>
// CHECK: wave.index_expr <"2*(64 + xor(8, item))">
// CHECK: wave.pack {{.*}} -> !wave.simd<vector<2xi32>, 32>
// CHECK: wave.store {{.*}} : (!wave.simd<vector<2xi32>, 32>
// CHECK: %[[PUBLISH:.*]] = wave.barrier
// CHECK: wave.index_expr <"{{.*}}xor{{.*}}">
// CHECK: %[[LOAD:.*]], %[[TOKEN:.*]] = wave.load {{.*}} after %[[PUBLISH]] {{.*}} -> (!wave.simd<vector<2xi32>, 32>, !wave.mem.token)
// CHECK: wave.extract %[[LOAD]][0]
// CHECK: wave.extract %[[LOAD]][1]
// CHECK: wave.join %[[TOKEN]]
func.func @cross_wave_swizzled_vector(
    %source: !wave.simd<vector<4xi32>, 32>)
    -> !wave.simd<vector<2xi32>, 32>
    attributes {wave.workgroup_size = array<i32: 64, 1, 1>} {
  %result = wave.redistribute %source,
      <blocks = 1, items = 64, source_block = "block",
       source_item = "xor(floor(item / 2), 32)",
       source_slot = "2*Mod(item, 2) + slot">
      : !wave.simd<vector<4xi32>, 32> -> !wave.simd<vector<2xi32>, 32>
  return %result : !wave.simd<vector<2xi32>, 32>
}

// -----

// CHECK-LABEL: func.func @cross_wave_swizzled_64_banks(
// CHECK: wave.index_expr <"2*(64 + xor(16, item))">
module attributes {
  waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"
} {
  func.func @cross_wave_swizzled_64_banks(
      %source: !wave.simd<vector<4xi32>, 32>)
      -> !wave.simd<vector<2xi32>, 32>
      attributes {wave.workgroup_size = array<i32: 64, 1, 1>} {
    %result = wave.redistribute %source,
        <blocks = 1, items = 64, source_block = "block",
         source_item = "xor(floor(item / 2), 32)",
         source_slot = "2*Mod(item, 2) + slot">
        : !wave.simd<vector<4xi32>, 32> -> !wave.simd<vector<2xi32>, 32>
    return %result : !wave.simd<vector<2xi32>, 32>
  }
}

// -----

// CHECK-LABEL: func.func @cross_wave_vector_select(
// CHECK: %[[LOAD:.*]], %[[LOAD_TOKEN:.*]] = wave.load {{.*}} -> (!wave.simd<vector<2xi32>, 32>, !wave.mem.token)
// CHECK: %[[LO:.*]] = wave.extract %[[LOAD]][0]
// CHECK: %[[HI:.*]] = wave.extract %[[LOAD]][1]
// CHECK-COUNT-2: wave.select {{.*}}, %[[HI]], %[[LO]]
func.func @cross_wave_vector_select(
    %source: !wave.simd<vector<4xi32>, 32>)
    -> !wave.simd<vector<2xi32>, 32>
    attributes {wave.workgroup_size = array<i32: 64, 1, 1>} {
  %result = wave.redistribute %source,
      <blocks = 1, items = 64, source_block = "block",
       source_item = "xor(item, 32)",
       source_slot = "2*Mod(item, 2) + xor(slot, Mod(item, 2))">
      : !wave.simd<vector<4xi32>, 32> -> !wave.simd<vector<2xi32>, 32>
  return %result : !wave.simd<vector<2xi32>, 32>
}

// -----

// CHECK-LABEL: func.func @cross_wave_nested_if(
// CHECK: scf.if
// CHECK: wave.alloc
// CHECK-COUNT-1: wave.barrier
// CHECK: wave.load
// CHECK: wave.join
// CHECK: wave.alloc_release
func.func @cross_wave_nested_if(%source: !wave.simd<vector<1xi32>, 32>,
                                %condition: i1)
    attributes {wave.workgroup_size = array<i32: 64, 1, 1>} {
  scf.if %condition {
    %result = wave.redistribute %source,
        <blocks = 1, items = 64, source_block = "block", source_item = "xor(item, 32)", source_slot = "slot">
        : !wave.simd<vector<1xi32>, 32> -> !wave.simd<vector<1xi32>, 32>
  }
  return
}

// -----

// CHECK-LABEL: func.func @broadcast_cross_wave(
// CHECK: %[[ALLOC:.*]] = wave.alloc()
// CHECK: %[[PUBLISH:.*]] = wave.barrier
// CHECK: %[[PTR:.*]] = wave.ptr_add %[[ALLOC]], {{.*}} : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
// CHECK: wave.load %[[PTR]] after %[[PUBLISH]]
// CHECK: wave.join
// CHECK: wave.alloc_release
func.func @broadcast_cross_wave(%source: !wave.simd<vector<1xi32>, 32>)
    -> !wave.simd<vector<1xi32>, 32>
    attributes {wave.workgroup_size = array<i32: 64, 1, 1>} {
  %result = wave.redistribute %source,
      <blocks = 1, items = 64, source_block = "block", source_item = "0", source_slot = "0">
      : !wave.simd<vector<1xi32>, 32> -> !wave.simd<vector<1xi32>, 32>
  return %result : !wave.simd<vector<1xi32>, 32>
}

// -----

// CHECK-LABEL: func.func @cross_wave_sequence(
// CHECK: %[[ALLOC0:.*]] = wave.alloc()
// CHECK: %[[STORE0:.*]] = wave.store
// CHECK: %[[PUBLISH0:.*]] = wave.barrier %[[STORE0]]
// CHECK: %[[LOAD0:.*]], %[[LOADTOK0:.*]] = wave.load {{.*}} after %[[PUBLISH0]]
// CHECK: %[[DONE0:.*]] = wave.join %[[LOADTOK0]]
// CHECK: %[[RELEASE0:.*]] = wave.alloc_release %[[ALLOC0]] after %[[DONE0]] {workgroup_collective}
// CHECK: %[[ALLOC1:.*]] = wave.alloc()
// CHECK: %[[STORE1:.*]] = wave.store {{.*}} after %[[RELEASE0]]
// CHECK: %[[PUBLISH1:.*]] = wave.barrier %[[STORE1]]
// CHECK: %[[LOAD1:.*]], %[[LOADTOK1:.*]] = wave.load {{.*}} after %[[PUBLISH1]]
// CHECK: %[[DONE1:.*]] = wave.join %[[LOADTOK1]]
// CHECK: %[[RELEASE1:.*]] = wave.alloc_release %[[ALLOC1]] after %[[DONE1]] {workgroup_collective}
// CHECK: %[[ALLOC2:.*]] = wave.alloc()
// CHECK: wave.store {{.*}} after %[[RELEASE1]]
func.func @cross_wave_sequence(
    %source0: !wave.simd<vector<1xi32>, 32>,
    %source1: !wave.simd<vector<1xi32>, 32>,
    %source2: !wave.simd<vector<1xi32>, 32>)
    attributes {wave.workgroup_size = array<i32: 64, 1, 1>} {
  %result0 = wave.redistribute %source0,
      <blocks = 1, items = 64, source_block = "block", source_item = "xor(item, 32)", source_slot = "slot">
      : !wave.simd<vector<1xi32>, 32> -> !wave.simd<vector<1xi32>, 32>
  %result1 = wave.redistribute %source1,
      <blocks = 1, items = 64, source_block = "block", source_item = "xor(item, 32)", source_slot = "slot">
      : !wave.simd<vector<1xi32>, 32> -> !wave.simd<vector<1xi32>, 32>
  %result2 = wave.redistribute %source2,
      <blocks = 1, items = 64, source_block = "block", source_item = "xor(item, 32)", source_slot = "slot">
      : !wave.simd<vector<1xi32>, 32> -> !wave.simd<vector<1xi32>, 32>
  return
}

// -----

// CHECK-LABEL: func.func @cross_wave_existing_barrier(
// CHECK: %[[ALLOC0:.*]] = wave.alloc()
// CHECK: %[[DONE0:.*]] = wave.join
// CHECK: %[[RELEASE0:.*]] = wave.alloc_release %[[ALLOC0]] after %[[DONE0]] {workgroup_collective}
// CHECK: %[[ROOT:.*]] = wave.token
// CHECK: %[[SYNC:.*]] = wave.barrier %[[ROOT]], %[[RELEASE0]]
// CHECK: wave.alloc
// CHECK: wave.store {{.*}} after %[[SYNC]]
func.func @cross_wave_existing_barrier(
    %source0: !wave.simd<vector<1xi32>, 32>,
    %source1: !wave.simd<vector<1xi32>, 32>)
    attributes {wave.workgroup_size = array<i32: 64, 1, 1>} {
  %result0 = wave.redistribute %source0,
      <blocks = 1, items = 64, source_block = "block", source_item = "xor(item, 32)", source_slot = "slot">
      : !wave.simd<vector<1xi32>, 32> -> !wave.simd<vector<1xi32>, 32>
  %root = wave.token : !wave.mem.token
  %sync = wave.barrier %root : (!wave.mem.token) -> !wave.mem.token
  %result1 = wave.redistribute %source1,
      <blocks = 1, items = 64, source_block = "block", source_item = "xor(item, 32)", source_slot = "slot">
      : !wave.simd<vector<1xi32>, 32> -> !wave.simd<vector<1xi32>, 32>
  return
}

// -----

// CHECK-LABEL: func.func @compose_to_identity(
// CHECK-NOT: wave.redistribute
// CHECK-NOT: wave.extract
// CHECK-NEXT: return %{{.*}} : !wave.simd<vector<2xi32>, 32>
func.func @compose_to_identity(%source: !wave.simd<vector<2xi32>, 32>)
    -> !wave.simd<vector<2xi32>, 32>
    attributes {wave.workgroup_size = array<i32: 32, 1, 1>} {
  %first = wave.redistribute %source,
      <blocks = 1, items = 32, source_block = "block", source_item = "xor(item, 1)", source_slot = "1 - slot">
      : !wave.simd<vector<2xi32>, 32> -> !wave.simd<vector<2xi32>, 32>
  %second = wave.redistribute %first,
      <blocks = 1, items = 32, source_block = "block", source_item = "xor(item, 1)", source_slot = "1 - slot">
      : !wave.simd<vector<2xi32>, 32> -> !wave.simd<vector<2xi32>, 32>
  return %second : !wave.simd<vector<2xi32>, 32>
}

// -----

// CHECK-LABEL: func.func @compose_cross_block_to_identity(
// CHECK-NOT: wave.redistribute
// CHECK-NOT: wave.extract
// CHECK-NEXT: return %{{.*}} : !wave.simd<vector<1xi32>, 32>
func.func @compose_cross_block_to_identity(
    %source: !wave.simd<vector<1xi32>, 32>)
    -> !wave.simd<vector<1xi32>, 32>
    attributes {wave.workgroup_size = array<i32: 32, 1, 1>} {
  %first = wave.redistribute %source,
      <blocks = 2, items = 32, source_block = "xor(block, 1)", source_item = "item", source_slot = "slot">
      : !wave.simd<vector<1xi32>, 32> -> !wave.simd<vector<1xi32>, 32>
  %second = wave.redistribute %first,
      <blocks = 2, items = 32, source_block = "xor(block, 1)", source_item = "item", source_slot = "slot">
      : !wave.simd<vector<1xi32>, 32> -> !wave.simd<vector<1xi32>, 32>
  return %second : !wave.simd<vector<1xi32>, 32>
}

// -----

// CHECK-LABEL: func.func @compose_cross_block_chain_to_identity(
// CHECK-NOT: wave.redistribute
// CHECK-NOT: wave.extract
// CHECK-NEXT: return %{{.*}} : !wave.simd<vector<1xi32>, 32>
func.func @compose_cross_block_chain_to_identity(
    %source: !wave.simd<vector<1xi32>, 32>)
    -> !wave.simd<vector<1xi32>, 32>
    attributes {wave.workgroup_size = array<i32: 32, 1, 1>} {
  %first = wave.redistribute %source,
      <blocks = 2, items = 32, source_block = "xor(block, 1)", source_item = "item", source_slot = "slot">
      : !wave.simd<vector<1xi32>, 32> -> !wave.simd<vector<1xi32>, 32>
  %second = wave.redistribute %first,
      <blocks = 2, items = 32, source_block = "xor(block, 1)", source_item = "item", source_slot = "slot">
      : !wave.simd<vector<1xi32>, 32> -> !wave.simd<vector<1xi32>, 32>
  %third = wave.redistribute %second,
      <blocks = 2, items = 32, source_block = "xor(block, 1)", source_item = "item", source_slot = "slot">
      : !wave.simd<vector<1xi32>, 32> -> !wave.simd<vector<1xi32>, 32>
  %fourth = wave.redistribute %third,
      <blocks = 2, items = 32, source_block = "xor(block, 1)", source_item = "item", source_slot = "slot">
      : !wave.simd<vector<1xi32>, 32> -> !wave.simd<vector<1xi32>, 32>
  return %fourth : !wave.simd<vector<1xi32>, 32>
}

// -----

// CHECK-LABEL: func.func @capacity_reduces_vector_width(
// CHECK: wave.alloc() {align = 4 : i64, bytesize = 256 : i64, offset = 65280 : i64}
// CHECK: wave.store
// CHECK-COUNT-7: wave.barrier
// CHECK: wave.load
// CHECK: return
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
func.func @capacity_reduces_vector_width(
    %source: !wave.simd<vector<4xi32>, 32>)
    -> !wave.simd<vector<4xi32>, 32>
    attributes {wave.lds_size = 65280 : i64,
                wave.workgroup_size = array<i32: 64, 1, 1>} {
  %result = wave.redistribute %source,
      <blocks = 1, items = 64, source_block = "block", source_item = "xor(item, 32)", source_slot = "slot">
      : !wave.simd<vector<4xi32>, 32> -> !wave.simd<vector<4xi32>, 32>
  return %result : !wave.simd<vector<4xi32>, 32>
}
}
