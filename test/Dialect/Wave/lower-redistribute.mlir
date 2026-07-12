// RUN: wave-opt --wave-lower-redistribute --split-input-file %s | FileCheck %s

// CHECK-LABEL: func.func @identity(
// CHECK-NOT: wave.redistribute
// CHECK-NEXT: return %{{.*}} : !wave.simd<vector<2xi32>, 32>
func.func @identity(%source: !wave.simd<vector<2xi32>, 32>)
    -> !wave.simd<vector<2xi32>, 32>
    attributes {wave.workgroup_size = array<i32: 32, 1, 1>} {
  %result = wave.redistribute %source,
      <items = 32, source_item = "item", source_slot = "slot">
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
      <items = 32, source_item = "item", source_slot = "1 - slot">
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
      <items = 32, source_item = "item", source_slot = "Mod(item, 2)">
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
      <items = 32,
       source_item = "Piecewise((item, slot == 0), (xor(item, 1), True))",
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
// CHECK-COUNT-2: wave.shuffle
// CHECK: wave.pack
func.func @same_wave(%source: !wave.simd<vector<2xi32>, 32>)
    -> !wave.simd<vector<2xi32>, 32>
    attributes {wave.workgroup_size = array<i32: 64, 1, 1>} {
  %result = wave.redistribute %source,
      <items = 64, source_item = "xor(item, 1)", source_slot = "slot">
      : !wave.simd<vector<2xi32>, 32> -> !wave.simd<vector<2xi32>, 32>
  return %result : !wave.simd<vector<2xi32>, 32>
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
        <items = 64, source_item = "xor(item, 1)", source_slot = "slot">
        : !wave.simd<vector<1xi32>, 32> -> !wave.simd<vector<1xi32>, 32>
  }
  return
}

// -----

// CHECK-LABEL: func.func @cross_wave(
// CHECK: %[[ALLOC:.*]] = wave.alloc()
// CHECK-DAG: %[[STORE0:.*]] = wave.store
// CHECK-DAG: %[[STORE1:.*]] = wave.store
// CHECK: %[[PUBLISH:.*]] = wave.barrier %[[STORE0]], %[[STORE1]]
// CHECK-DAG: %[[LOAD0:.*]], %[[LOADTOK0:.*]] = wave.load {{.*}} after %[[PUBLISH]]
// CHECK-DAG: %[[LOAD1:.*]], %[[LOADTOK1:.*]] = wave.load {{.*}} after %[[PUBLISH]]
// CHECK: %[[PACK:.*]] = wave.pack %[[LOAD0]], %[[LOAD1]]
// CHECK: %[[RELEASE:.*]] = wave.barrier %[[LOADTOK0]], %[[LOADTOK1]]
// CHECK: wave.alloc_release %[[ALLOC]] after %[[RELEASE]]
// CHECK-NOT: wave.redistribute
func.func @cross_wave(%source: !wave.simd<vector<2xi32>, 32>)
    -> !wave.simd<vector<2xi32>, 32>
    attributes {wave.workgroup_size = array<i32: 64, 1, 1>} {
  %result = wave.redistribute %source,
      <items = 64, source_item = "xor(item, 32)", source_slot = "slot">
      : !wave.simd<vector<2xi32>, 32> -> !wave.simd<vector<2xi32>, 32>
  return %result : !wave.simd<vector<2xi32>, 32>
}

// -----

// CHECK-LABEL: func.func @broadcast_cross_wave(
// CHECK: %[[ALLOC:.*]] = wave.alloc()
// CHECK: %[[PUBLISH:.*]] = wave.barrier
// CHECK: %[[PTR:.*]] = wave.ptr_add %[[ALLOC]], {{.*}} : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
// CHECK: wave.load %[[PTR]] after %[[PUBLISH]]
// CHECK: wave.alloc_release
func.func @broadcast_cross_wave(%source: !wave.simd<vector<1xi32>, 32>)
    -> !wave.simd<vector<1xi32>, 32>
    attributes {wave.workgroup_size = array<i32: 64, 1, 1>} {
  %result = wave.redistribute %source,
      <items = 64, source_item = "0", source_slot = "0">
      : !wave.simd<vector<1xi32>, 32> -> !wave.simd<vector<1xi32>, 32>
  return %result : !wave.simd<vector<1xi32>, 32>
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
      <items = 32, source_item = "xor(item, 1)", source_slot = "1 - slot">
      : !wave.simd<vector<2xi32>, 32> -> !wave.simd<vector<2xi32>, 32>
  %second = wave.redistribute %first,
      <items = 32, source_item = "xor(item, 1)", source_slot = "1 - slot">
      : !wave.simd<vector<2xi32>, 32> -> !wave.simd<vector<2xi32>, 32>
  return %second : !wave.simd<vector<2xi32>, 32>
}
