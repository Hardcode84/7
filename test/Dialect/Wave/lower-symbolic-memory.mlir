// RUN: wave-opt --wave-lower-symbolic-memory --split-input-file %s | FileCheck %s

// CHECK-LABEL: func.func @contiguous_gather(
// CHECK-NOT: wave.gather
// CHECK-COUNT-1: wave.load
// CHECK-SAME: -> (!wave.simd<vector<4xf32>, 32>, !wave.mem.token)
func.func @contiguous_gather(%base: !wave.ptr<#wave.shared, f32>,
                             %origin: index)
    -> !wave.simd<vector<4xf32>, 32>
    attributes {wave.workgroup_size = array<i32: 32, 1, 1>} {
  %value, %token = wave.gather %base mapping
      <bit_offset = <"32 * (4 * item + origin + slot)">>
      bindings ["origin"](%origin) packet_bindings []()
      : (!wave.ptr<#wave.shared, f32>, index)
      -> (!wave.simd<vector<4xf32>, 32>, !wave.mem.token)
  return %value : !wave.simd<vector<4xf32>, 32>
}

// -----

// CHECK-LABEL: func.func @permuted_gather(
// CHECK-COUNT-1: wave.load
// CHECK-SAME: -> (!wave.simd<vector<4xi32>, 32>, !wave.mem.token)
// CHECK: [[P0:%.*]] = wave.extract {{.*}}[0]
// CHECK: [[P1:%.*]] = wave.extract {{.*}}[1]
// CHECK: [[P2:%.*]] = wave.extract {{.*}}[2]
// CHECK: [[P3:%.*]] = wave.extract {{.*}}[3]
// CHECK: wave.pack [[P0]], [[P2]], [[P1]], [[P3]]
// CHECK-NOT: wave.gather
func.func @permuted_gather(%base: !wave.ptr<#wave.shared, i32>)
    -> !wave.simd<vector<4xi32>, 32>
    attributes {wave.workgroup_size = array<i32: 32, 1, 1>} {
  %value, %token = wave.gather %base mapping
      <bit_offset = <"32 * (4 * item + Piecewise((0, slot == 0), (2, slot == 1), (1, slot == 2), (3, True)))">>
      bindings []() packet_bindings []()
      : (!wave.ptr<#wave.shared, i32>)
      -> (!wave.simd<vector<4xi32>, 32>, !wave.mem.token)
  return %value : !wave.simd<vector<4xi32>, 32>
}

// -----

// CHECK-LABEL: func.func @permuted_scatter(
// CHECK: [[V0:%.*]] = wave.extract %arg0[0]
// CHECK: [[V1:%.*]] = wave.extract %arg0[1]
// CHECK: [[V2:%.*]] = wave.extract %arg0[2]
// CHECK: [[V3:%.*]] = wave.extract %arg0[3]
// CHECK: [[PACK:%.*]] = wave.pack [[V0]], [[V2]], [[V1]], [[V3]]
// CHECK-COUNT-1: wave.store [[PACK]]
// CHECK-NOT: wave.scatter
func.func @permuted_scatter(%value: !wave.simd<vector<4xi32>, 32>,
                            %base: !wave.ptr<#wave.shared, i32>)
    attributes {wave.workgroup_size = array<i32: 32, 1, 1>} {
  %token = wave.scatter %value to %base mapping
      <bit_offset = <"32 * (4 * item + Piecewise((0, slot == 0), (2, slot == 1), (1, slot == 2), (3, True)))">>
      bindings []() packet_bindings []()
      : (!wave.simd<vector<4xi32>, 32>, !wave.ptr<#wave.shared, i32>)
      -> !wave.mem.token
  return
}

// -----

// Five f16 slots need one dword-multiple vector access plus one scalar.
// CHECK-LABEL: func.func @odd_f16_chain(
// CHECK-SAME: %arg0: !wave.ptr<#wave.shared, f16>, [[DEP:%.*]]: !wave.mem.token
// CHECK: wave.load {{.*}} after [[DEP]]
// CHECK-SAME: -> (!wave.simd<vector<4xf16>, 32>, !wave.mem.token)
// CHECK: wave.load {{.*}} after [[DEP]]
// CHECK-SAME: -> (!wave.simd<f16, 32>, !wave.mem.token)
// CHECK: wave.join
func.func @odd_f16_chain(%base: !wave.ptr<#wave.shared, f16>,
                         %dependency: !wave.mem.token)
    -> !wave.simd<vector<5xf16>, 32>
    attributes {wave.workgroup_size = array<i32: 32, 1, 1>} {
  %value, %token = wave.gather %base mapping
      <bit_offset = <"16 * (5 * item + slot)">>
      bindings []() packet_bindings []() after %dependency
      : (!wave.ptr<#wave.shared, f16>, !wave.mem.token)
      -> (!wave.simd<vector<5xf16>, 32>, !wave.mem.token)
  return %value : !wave.simd<vector<5xf16>, 32>
}

// -----

// Unrelated runtime indices cannot prove slot adjacency.
// CHECK-LABEL: func.func @packet_index_fallback(
// CHECK-COUNT-4: wave.load
// CHECK-NOT: wave.load {{.*}}vector<
func.func @packet_index_fallback(
    %base: !wave.ptr<#wave.global, i32>,
    %indices: !wave.simd<vector<4xi32>, 32>)
    -> !wave.simd<vector<4xi32>, 32> {
  %value, %token = wave.gather %base mapping
      <bit_offset = <"32 * idx">>
      bindings []() packet_bindings ["idx"](%indices)
      : (!wave.ptr<#wave.global, i32>, !wave.simd<vector<4xi32>, 32>)
      -> (!wave.simd<vector<4xi32>, 32>, !wave.mem.token)
  return %value : !wave.simd<vector<4xi32>, 32>
}

// -----

// Duplicate reads share one transaction; packet aliases remain explicit.
// CHECK-LABEL: func.func @duplicate_gather(
// CHECK-COUNT-1: wave.load
// CHECK-SAME: -> (!wave.simd<vector<2xi32>, 32>, !wave.mem.token)
// CHECK: wave.pack [[D0:%.*]], [[D1:%.*]], [[D0]], [[D1]]
func.func @duplicate_gather(%base: !wave.ptr<#wave.shared, i32>)
    -> !wave.simd<vector<4xi32>, 32>
    attributes {wave.workgroup_size = array<i32: 32, 1, 1>} {
  %value, %token = wave.gather %base mapping
      <bit_offset = <"32 * (2 * item + Piecewise((0, slot == 0), (1, slot == 1), (0, slot == 2), (1, True)))">>
      bindings []() packet_bindings []()
      : (!wave.ptr<#wave.shared, i32>)
      -> (!wave.simd<vector<4xi32>, 32>, !wave.mem.token)
  return %value : !wave.simd<vector<4xi32>, 32>
}

// -----

// Colliding scatter points remain writes, but each physical run stays wide.
// CHECK-LABEL: func.func @duplicate_scatter(
// CHECK: wave.store {{.*}} : (!wave.simd<vector<2xi32>, 32>,
// CHECK: wave.store {{.*}} : (!wave.simd<vector<2xi32>, 32>,
// CHECK-NOT: wave.scatter
func.func @duplicate_scatter(%value: !wave.simd<vector<4xi32>, 32>,
                             %base: !wave.ptr<#wave.shared, i32>)
    attributes {wave.workgroup_size = array<i32: 32, 1, 1>} {
  %token = wave.scatter %value to %base mapping
      <bit_offset = <"32 * (2 * item + Piecewise((0, slot == 0), (1, slot == 1), (0, slot == 2), (1, True)))">>
      bindings []() packet_bindings []()
      : (!wave.simd<vector<4xi32>, 32>, !wave.ptr<#wave.shared, i32>)
      -> !wave.mem.token
  return
}

// -----

// CHECK-LABEL: func.func @second_base(
// CHECK-SAME: [[FIRST:%.*]]: !wave.ptr<#wave.shared, i32>, [[SECOND:%.*]]: !wave.ptr<#wave.shared, i32>
// CHECK: wave.ptr_cast [[SECOND]]
// CHECK-NOT: wave.ptr_cast [[FIRST]]
// CHECK-COUNT-1: wave.load
func.func @second_base(%first: !wave.ptr<#wave.shared, i32>,
                       %second: !wave.ptr<#wave.shared, i32>)
    -> !wave.simd<vector<2xi32>, 32> {
  %value, %token = wave.gather %first, %second mapping
      <base = <"1">, bit_offset = <"32 * slot">>
      bindings []() packet_bindings []()
      : (!wave.ptr<#wave.shared, i32>, !wave.ptr<#wave.shared, i32>)
      -> (!wave.simd<vector<2xi32>, 32>, !wave.mem.token)
  return %value : !wave.simd<vector<2xi32>, 32>
}

// -----

// CHECK-LABEL: func.func @constant_binding_base(
// CHECK-SAME: [[FIRST:%.*]]: !wave.ptr<#wave.shared, i32>, [[SECOND:%.*]]: !wave.ptr<#wave.shared, i32>
// CHECK: wave.ptr_cast [[SECOND]]
// CHECK-NOT: wave.ptr_cast [[FIRST]]
// CHECK-COUNT-1: wave.load
func.func @constant_binding_base(%first: !wave.ptr<#wave.shared, i32>,
                                 %second: !wave.ptr<#wave.shared, i32>)
    -> !wave.simd<vector<2xi32>, 32> {
  %one = arith.constant 1 : index
  %value, %token = wave.gather %first, %second mapping
      <base = <"which">, bit_offset = <"32 * slot">>
      bindings ["which"](%one) packet_bindings []()
      : (!wave.ptr<#wave.shared, i32>, !wave.ptr<#wave.shared, i32>, index)
      -> (!wave.simd<vector<2xi32>, 32>, !wave.mem.token)
  return %value : !wave.simd<vector<2xi32>, 32>
}

// -----

// CHECK-LABEL: func.func @solver_exact_binding_base(
// CHECK-SAME: [[FIRST:%.*]]: !wave.ptr<#wave.shared, i32>, [[SECOND:%.*]]: !wave.ptr<#wave.shared, i32>
// CHECK: wave.ptr_cast [[SECOND]]
// CHECK-NOT: wave.ptr_cast [[FIRST]]
// CHECK-COUNT-1: wave.load
func.func @solver_exact_binding_base(%first: !wave.ptr<#wave.shared, i32>,
                                     %second: !wave.ptr<#wave.shared, i32>,
                                     %raw: i32)
    -> !wave.simd<vector<2xi32>, 32> {
  %which = wave.assume %raw as "x"
      [#wave.pred<"x >= 1">, #wave.pred<"x <= 1">] : i32
  %value, %token = wave.gather %first, %second mapping
      <base = <"which">, bit_offset = <"32 * slot">>
      bindings ["which"](%which) packet_bindings []()
      : (!wave.ptr<#wave.shared, i32>, !wave.ptr<#wave.shared, i32>, i32)
      -> (!wave.simd<vector<2xi32>, 32>, !wave.mem.token)
  return %value : !wave.simd<vector<2xi32>, 32>
}

// -----

// Packet producer algebra survives slot specialization.
// CHECK-LABEL: func.func @affine_packet_producer(
// CHECK-COUNT-1: wave.load
// CHECK-SAME: -> (!wave.simd<vector<4xi32>, 32>, !wave.mem.token)
// CHECK-NOT: wave.gather
func.func @affine_packet_producer(
    %base: !wave.ptr<#wave.global, i32>,
    %raw: !wave.simd<i32, 32>) -> !wave.simd<vector<4xi32>, 32> {
  %origin = wave.assume %raw as "x"
      [#wave.pred<"x >= 0">, #wave.pred<"x <= 1024">]
      : !wave.simd<i32, 32>
  %one = wave.constant 1 : i32 -> !wave.simd<i32, 32>
  %two = wave.constant 2 : i32 -> !wave.simd<i32, 32>
  %three = wave.constant 3 : i32 -> !wave.simd<i32, 32>
  %i1 = wave.binary addi %origin, %one
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %i2 = wave.binary addi %origin, %two
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %i3 = wave.binary addi %origin, %three
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %indices = wave.pack %origin, %i1, %i2, %i3
      : !wave.simd<i32, 32>, !wave.simd<i32, 32>,
        !wave.simd<i32, 32>, !wave.simd<i32, 32>
      -> !wave.simd<vector<4xi32>, 32>
  %value, %token = wave.gather %base mapping
      <bit_offset = <"32 * idx">>
      bindings []() packet_bindings ["idx"](%indices)
      : (!wave.ptr<#wave.global, i32>, !wave.simd<vector<4xi32>, 32>)
      -> (!wave.simd<vector<4xi32>, 32>, !wave.mem.token)
  return %value : !wave.simd<vector<4xi32>, 32>
}

// -----

// CHECK-LABEL: func.func @packet_item_base_selection(
// CHECK-SAME: [[FIRST:%.*]]: !wave.ptr<#wave.shared, i32>, [[SECOND:%.*]]: !wave.ptr<#wave.shared, i32>
// CHECK-COUNT-1: wave.workitem_id 0
// CHECK: wave.ptr_cast [[FIRST]]
// CHECK: wave.load
// CHECK: wave.ptr_cast [[SECOND]]
// CHECK: wave.load
// CHECK-NOT: wave.gather
func.func @packet_item_base_selection(
    %first: !wave.ptr<#wave.shared, i32>,
    %second: !wave.ptr<#wave.shared, i32>)
    -> !wave.simd<vector<2xi32>, 32>
    attributes {wave.workgroup_size = array<i32: 32, 1, 1>} {
  %item = wave.workitem_id 0 : !wave.simd<i32, 32>
  %one = wave.constant 1 : i32 -> !wave.simd<i32, 32>
  %next = wave.binary addi %item, %one
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %indices = wave.pack %item, %next
      : !wave.simd<i32, 32>, !wave.simd<i32, 32>
      -> !wave.simd<vector<2xi32>, 32>
  %value, %token = wave.gather %first, %second mapping
      <base = <"idx - item">, bit_offset = <"32 * slot">>
      bindings []() packet_bindings ["idx"](%indices)
      : (!wave.ptr<#wave.shared, i32>, !wave.ptr<#wave.shared, i32>,
         !wave.simd<vector<2xi32>, 32>)
      -> (!wave.simd<vector<2xi32>, 32>, !wave.mem.token)
  return %value : !wave.simd<vector<2xi32>, 32>
}

// -----

// Internal packet symbols cannot alias declared mapping bindings.
// CHECK-LABEL: func.func @binding_name_collision(
// CHECK: wave.index_expr {{.*}} ["origin", "origin_0"](
// CHECK-COUNT-1: wave.load
func.func @binding_name_collision(
    %base: !wave.ptr<#wave.global, i32>, %bias: index,
    %origin: !wave.simd<i32, 32>)
    -> !wave.simd<vector<4xi32>, 32> {
  %i0 = wave.index_expr <"origin"> ["origin"](%origin)
      : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
  %i1 = wave.index_expr <"1 + origin"> ["origin"](%origin)
      : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
  %i2 = wave.index_expr <"2 + origin"> ["origin"](%origin)
      : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
  %i3 = wave.index_expr <"3 + origin"> ["origin"](%origin)
      : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
  %indices = wave.pack %i0, %i1, %i2, %i3
      : !wave.simd<index, 32>, !wave.simd<index, 32>,
        !wave.simd<index, 32>, !wave.simd<index, 32>
      -> !wave.simd<vector<4xindex>, 32>
  %value, %token = wave.gather %base mapping
      <bit_offset = <"32 * (origin + idx)">>
      bindings ["origin"](%bias) packet_bindings ["idx"](%indices)
      : (!wave.ptr<#wave.global, i32>, index,
         !wave.simd<vector<4xindex>, 32>)
      -> (!wave.simd<vector<4xi32>, 32>, !wave.mem.token)
  return %value : !wave.simd<vector<4xi32>, 32>
}

// -----

// Global cover avoids scalar stores across a branched successor graph.
// CHECK-LABEL: func.func @branched_scatter_cover(
// CHECK: wave.store {{.*}} : (!wave.simd<vector<2xf16>, 32>,
// CHECK: wave.store {{.*}} : (!wave.simd<vector<2xf16>, 32>,
// CHECK-NOT: wave.store {{.*}} : (!wave.simd<f16, 32>,
func.func @branched_scatter_cover(
    %value: !wave.simd<vector<4xf16>, 32>,
    %base: !wave.ptr<#wave.shared, f16>) {
  %token = wave.scatter %value to %base mapping
      <bit_offset = <"16 * Piecewise((0, slot == 0), (1, slot == 1), (1, slot == 2), (2, True))">>
      bindings []() packet_bindings []()
      : (!wave.simd<vector<4xf16>, 32>, !wave.ptr<#wave.shared, f16>)
      -> !wave.mem.token
  return
}

// -----

// Disconnected 18-node run leaves four-node branch on exact cover.
// CHECK-LABEL: func.func @component_exact_cover(
// CHECK-COUNT-2: wave.store {{.*}} : (!wave.simd<vector<2xf16>, 32>,
// CHECK: wave.store {{.*}} : (!wave.simd<vector<18xf16>, 32>,
// CHECK-NOT: wave.store {{.*}} : (!wave.simd<f16, 32>,
// CHECK-NOT: wave.scatter
func.func @component_exact_cover(
    %value: !wave.simd<vector<22xf16>, 32>,
    %base: !wave.ptr<#wave.shared, f16>) {
  %token = wave.scatter %value to %base mapping
      <bit_offset = <"16 * Piecewise((0, slot == 0), (1, slot == 1), (1, slot == 2), (2, slot == 3), (28 + slot, True))">>
      bindings []() packet_bindings []()
      : (!wave.simd<vector<22xf16>, 32>, !wave.ptr<#wave.shared, f16>)
      -> !wave.mem.token
  return
}

// -----

// Slot-static partitioning selects each base and stays vectorized.
// CHECK-LABEL: func.func @slot_partition_base(
// CHECK: wave.ptr_cast %arg0
// CHECK: wave.load
// CHECK-SAME: -> (!wave.simd<vector<2xi32>, 32>, !wave.mem.token)
// CHECK: wave.ptr_cast %arg1
// CHECK: wave.load
// CHECK-SAME: -> (!wave.simd<vector<2xi32>, 32>, !wave.mem.token)
func.func @slot_partition_base(
    %first: !wave.ptr<#wave.shared, i32>,
    %second: !wave.ptr<#wave.shared, i32>)
    -> !wave.simd<vector<4xi32>, 32> {
  %value, %token = wave.gather %first, %second mapping
      <base = <"Mod(slot, 2)">,
       bit_offset = <"32 * floor(slot / 2)">>
      bindings []() packet_bindings []()
      : (!wave.ptr<#wave.shared, i32>, !wave.ptr<#wave.shared, i32>)
      -> (!wave.simd<vector<4xi32>, 32>, !wave.mem.token)
  return %value : !wave.simd<vector<4xi32>, 32>
}

// -----

// CHECK-LABEL: func.func @dead_item_after_slot_specialization(
// CHECK-NOT: wave.workitem_id
// CHECK-COUNT-1: wave.load
// CHECK-SAME: -> (!wave.simd<vector<2xi32>, 32>, !wave.mem.token)
// CHECK-NOT: wave.gather
func.func @dead_item_after_slot_specialization(
    %base: !wave.ptr<#wave.shared, i32>)
    -> !wave.simd<vector<2xi32>, 32> {
  %value, %token = wave.gather %base mapping
      <bit_offset = <"Piecewise((32 * slot, slot < 2), (32 * item, True))">>
      bindings []() packet_bindings []()
      : (!wave.ptr<#wave.shared, i32>)
      -> (!wave.simd<vector<2xi32>, 32>, !wave.mem.token)
  return %value : !wave.simd<vector<2xi32>, 32>
}

// -----

// CHECK-LABEL: func.func @explicit_local_block(
// CHECK-COUNT-1: wave.load
func.func @explicit_local_block(%base: !wave.ptr<#wave.shared, i32>)
    -> !wave.simd<vector<2xi32>, 32> {
  %value, %token = wave.gather %base mapping
      <target_block = <"block">, bit_offset = <"32 * slot">>
      bindings []() packet_bindings []()
      : (!wave.ptr<#wave.shared, i32>)
      -> (!wave.simd<vector<2xi32>, 32>, !wave.mem.token)
  return %value : !wave.simd<vector<2xi32>, 32>
}

// -----

// CHECK-LABEL: func.func @row_major_item(
// CHECK: wave.workitem_id 0
// CHECK: wave.workitem_id 1
// CHECK: wave.binary muli
// CHECK: wave.binary addi
// CHECK: wave.index_expr <"8*item"> assuming [#wave.pred<"item >= 0 & -7 + item <= 0">]
// CHECK-COUNT-1: wave.load
func.func @row_major_item(%base: !wave.ptr<#wave.shared, i32>)
    -> !wave.simd<vector<2xi32>, 32>
    attributes {wave.workgroup_size = array<i32: 4, 2, 1>} {
  %value, %token = wave.gather %base mapping
      <bit_offset = <"32 * (2 * item + slot)">>
      bindings []() packet_bindings []()
      : (!wave.ptr<#wave.shared, i32>)
      -> (!wave.simd<vector<2xi32>, 32>, !wave.mem.token)
  return %value : !wave.simd<vector<2xi32>, 32>
}

// -----

// CHECK-LABEL: func.func @item_range_simplifies_base(
// CHECK-COUNT-1: wave.load
// CHECK-NOT: wave.gather
func.func @item_range_simplifies_base(%base: !wave.ptr<#wave.shared, i32>)
    -> !wave.simd<vector<2xi32>, 32>
    attributes {wave.workgroup_size = array<i32: 32, 1, 1>} {
  %value, %token = wave.gather %base mapping
      <base = <"floor(item / 32)">, bit_offset = <"32 * slot">>
      bindings []() packet_bindings []()
      : (!wave.ptr<#wave.shared, i32>)
      -> (!wave.simd<vector<2xi32>, 32>, !wave.mem.token)
  return %value : !wave.simd<vector<2xi32>, 32>
}

// -----

// CHECK-LABEL: func.func @item_range_proves_defined(
// CHECK-COUNT-1: wave.load
// CHECK-SAME: -> (!wave.simd<vector<2xi32>, 32>, !wave.mem.token)
// CHECK-NOT: wave.gather
func.func @item_range_proves_defined(%base: !wave.ptr<#wave.shared, i32>)
    -> !wave.simd<vector<2xi32>, 32>
    attributes {wave.workgroup_size = array<i32: 4, 2, 2>} {
  %value, %token = wave.gather %base mapping
      <bit_offset = <"Piecewise((32 * slot, item < 16))">>
      bindings []() packet_bindings []()
      : (!wave.ptr<#wave.shared, i32>)
      -> (!wave.simd<vector<2xi32>, 32>, !wave.mem.token)
  return %value : !wave.simd<vector<2xi32>, 32>
}

// -----

// CHECK-LABEL: func.func @where_then_control(
// CHECK: wave.where
// CHECK-COUNT-1: wave.load
// CHECK-SAME: -> (!wave.simd<vector<2xi32>, 32>, !wave.mem.token)
// CHECK-NOT: wave.gather
func.func @where_then_control(%x: !wave.simd<i32, 32>,
                              %base: !wave.ptr<#wave.shared, i32>) {
  %limit = wave.constant 16 : i32 -> !wave.simd<i32, 32>
  %active = wave.cmpi slt %x, %limit
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  wave.where %active {
    %value, %token = wave.gather %base mapping
        <bit_offset = <"Piecewise((32 * slot, x < 16))">>
        bindings ["x"](%x) packet_bindings []()
        : (!wave.ptr<#wave.shared, i32>, !wave.simd<i32, 32>)
        -> (!wave.simd<vector<2xi32>, 32>, !wave.mem.token)
    wave.yield
  } : !wave.mask<32>
  return
}

// -----

// CHECK-LABEL: func.func @where_else_control(
// CHECK: wave.where
// CHECK-COUNT-1: wave.load
// CHECK-SAME: -> (!wave.simd<vector<2xi32>, 32>, !wave.mem.token)
// CHECK-NOT: wave.gather
func.func @where_else_control(%x: !wave.simd<i32, 32>,
                              %base: !wave.ptr<#wave.shared, i32>) {
  %limit = wave.constant 16 : i32 -> !wave.simd<i32, 32>
  %active = wave.cmpi slt %x, %limit
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  wave.where %active {
    wave.yield
  } otherwise {
    %value, %token = wave.gather %base mapping
        <bit_offset = <"Piecewise((32 * slot, x >= 16))">>
        bindings ["x"](%x) packet_bindings []()
        : (!wave.ptr<#wave.shared, i32>, !wave.simd<i32, 32>)
        -> (!wave.simd<vector<2xi32>, 32>, !wave.mem.token)
    wave.yield
  } : !wave.mask<32>
  return
}

// -----

// CHECK-LABEL: func.func @scf_if_control(
// CHECK: scf.if
// CHECK-COUNT-2: wave.load
// CHECK-NOT: wave.gather
func.func @scf_if_control(%x: index,
                          %base: !wave.ptr<#wave.shared, i32>) {
  %limit = arith.constant 16 : index
  %active = arith.cmpi slt, %x, %limit : index
  scf.if %active {
    %value, %token = wave.gather %base mapping
        <bit_offset = <"Piecewise((32 * slot, x < 16))">>
        bindings ["x"](%x) packet_bindings []()
        : (!wave.ptr<#wave.shared, i32>, index)
        -> (!wave.simd<vector<2xi32>, 32>, !wave.mem.token)
  } else {
    %value, %token = wave.gather %base mapping
        <bit_offset = <"Piecewise((32 * slot, x >= 16))">>
        bindings ["x"](%x) packet_bindings []()
        : (!wave.ptr<#wave.shared, i32>, index)
        -> (!wave.simd<vector<2xi32>, 32>, !wave.mem.token)
  }
  return
}
