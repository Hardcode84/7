// RUN: wave-opt --wave-lower-symbolic-memory --split-input-file %s \
// RUN:   --mlir-timing --mlir-timing-display=tree 2>%t | FileCheck %s
// RUN: FileCheck %s --check-prefix=TIMING < %t
// RUN: wave-opt --canonicalize --wave-lower-symbolic-memory --split-input-file %s | FileCheck %s --check-prefix=CANONICAL

// TIMING-DAG: wave_lower_symbolic_memory_stages
// TIMING-DAG: lower_symbolic_memory_setup
// TIMING-DAG: lower_symbolic_memory_collect_accesses
// TIMING-DAG: lower_symbolic_memory_integer_range_analysis
// TIMING-DAG: lower_symbolic_memory_lower_dma_copies
// TIMING-DAG: lower_symbolic_memory_prepare_mappings
// TIMING-DAG: lower_symbolic_memory_prepare_mapping_setup
// TIMING-DAG: lower_symbolic_memory_prepare_mapping_item
// TIMING-DAG: lower_symbolic_memory_prepare_mapping_components
// TIMING-DAG: lower_symbolic_memory_prepare_mapping_controls
// TIMING-DAG: lower_symbolic_memory_prepare_mapping_slots
// TIMING-DAG: lower_symbolic_memory_prepare_mapping_slot_coordinates
// TIMING-DAG: lower_symbolic_memory_group_mapping_fact_domains
// TIMING-DAG: lower_symbolic_memory_analyze_mapping_slots
// TIMING-DAG: lower_symbolic_memory_create_mapping_analysis
// TIMING-DAG: lower_symbolic_memory_analyze_mapping_coordinates
// TIMING-DAG: lower_symbolic_memory_plan_gather
// TIMING-DAG: lower_symbolic_memory_deduplicate_gather
// TIMING-DAG: lower_symbolic_memory_build_successor_graph
// TIMING-DAG: lower_symbolic_memory_select_transaction_cover
// TIMING-DAG: lower_symbolic_memory_enumerate_provider_gather
// TIMING-DAG: lower_symbolic_memory_emit_gather
// TIMING-DAG: lower_symbolic_memory_plan_scatter
// TIMING-DAG: lower_symbolic_memory_emit_scatter

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

// CHECK-LABEL: func.func @contiguous_buffer_gather(
// CHECK-NOT: wave.gather
// CHECK-COUNT-1: wave.load
// CHECK-SAME: !wave.simd<!wave.ptr<#waveamd.buffer, f32>, 32>
// CHECK-SAME: -> (!wave.simd<vector<4xf32>, 32>, !wave.mem.token)
func.func @contiguous_buffer_gather(
    %base: !wave.ptr<#waveamd.buffer, f32>, %origin: index)
    -> !wave.simd<vector<4xf32>, 32>
    attributes {wave.workgroup_size = array<i32: 32, 1, 1>} {
  %value, %token = wave.gather %base mapping
      <bit_offset = <"32 * (4 * item + origin + slot)">>
      bindings ["origin"](%origin) packet_bindings []()
      : (!wave.ptr<#waveamd.buffer, f32>, index)
      -> (!wave.simd<vector<4xf32>, 32>, !wave.mem.token)
  return %value : !wave.simd<vector<4xf32>, 32>
}

// -----

// Transaction planning may expand an i32 packet relation, but address
// materialization must retain the original i32 value and its wrapping width.
// CHECK-LABEL: func.func @buffer_packet_i32_gather(
// CHECK-SAME: %[[BASE:.*]]: !wave.ptr<#waveamd.buffer, f16>, %[[ORIGIN:.*]]: !wave.simd<i32, 32>
// CHECK: wave.ptr_add %[[BASE]], %[[ORIGIN]]
// CHECK-NOT: wave.index_expr
// CHECK-COUNT-1: wave.load
// CHECK-SAME: -> (!wave.simd<vector<4xf16>, 32>, !wave.mem.token)
// CHECK-NOT: wave.gather
func.func @buffer_packet_i32_gather(
    %base: !wave.ptr<#waveamd.buffer, f16>,
    %origin: !wave.simd<i32, 32>) -> !wave.simd<vector<4xf16>, 32> {
  %one = wave.constant 1 : i32 -> !wave.simd<i32, 32>
  %two = wave.constant 2 : i32 -> !wave.simd<i32, 32>
  %three = wave.constant 3 : i32 -> !wave.simd<i32, 32>
  %i1 = wave.binary addi %origin, %one overflow<nsw>
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %i2 = wave.binary addi %origin, %two overflow<nsw>
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %i3 = wave.binary addi %origin, %three overflow<nsw>
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %indices = wave.pack %origin, %i1, %i2, %i3
      : !wave.simd<i32, 32>, !wave.simd<i32, 32>,
        !wave.simd<i32, 32>, !wave.simd<i32, 32>
      -> !wave.simd<vector<4xi32>, 32>
  %value, %token = wave.gather %base mapping
      <bit_offset = <"16 * offset">>
      bindings []() packet_bindings ["offset"](%indices)
      : (!wave.ptr<#waveamd.buffer, f16>, !wave.simd<vector<4xi32>, 32>)
      -> (!wave.simd<vector<4xf16>, 32>, !wave.mem.token)
  return %value : !wave.simd<vector<4xf16>, 32>
}

// -----

// Packet index components remain ordinary SSA values; they do not require an
// impossible builtin vector<index> carrier or a narrowing cast.
// CHECK-LABEL: func.func @buffer_packet_index_component_gather(
// CHECK-COUNT-4: wave.load
// CHECK-NOT: wave.gather
func.func @buffer_packet_index_component_gather(
    %base: !wave.ptr<#waveamd.buffer, f16>,
    %i0: !wave.simd<index, 32>, %i1: !wave.simd<index, 32>,
    %i2: !wave.simd<index, 32>, %i3: !wave.simd<index, 32>)
    -> !wave.simd<vector<4xf16>, 32> {
  %value, %token = wave.gather %base mapping
      <bit_offset = <"16 * offset">>
      bindings []() packet_bindings
      ["offset", "offset", "offset", "offset"](%i0, %i1, %i2, %i3)
      : (!wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 32>,
         !wave.simd<index, 32>, !wave.simd<index, 32>,
         !wave.simd<index, 32>)
      -> (!wave.simd<vector<4xf16>, 32>, !wave.mem.token)
  return %value : !wave.simd<vector<4xf16>, 32>
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

// CHECK-LABEL: func.func @contiguous_buffer_scatter(
// CHECK-NOT: wave.scatter
// CHECK-COUNT-1: wave.store
// CHECK-SAME: !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>
func.func @contiguous_buffer_scatter(
    %value: !wave.simd<vector<4xi32>, 32>,
    %base: !wave.ptr<#waveamd.buffer, i32>)
    attributes {wave.workgroup_size = array<i32: 32, 1, 1>} {
  %token = wave.scatter %value to %base mapping
      <bit_offset = <"32 * (4 * item + slot)">>
      bindings []() packet_bindings []()
      : (!wave.simd<vector<4xi32>, 32>, !wave.ptr<#waveamd.buffer, i32>)
      -> !wave.mem.token
  return
}

// -----

// Wrap happens before halving. Negative i32 lanes cannot collapse to the raw
// signed index.
// CHECK-LABEL: func.func @predicated_wrapping_buffer_scatter(
// CHECK-SAME: %[[BASE:.*]]: !wave.ptr<#waveamd.buffer, f16>
// CHECK: wave.where
// CHECK: wave.index_expr <"1/2*Mod(2*raw0, 4294967296)">
// CHECK: wave.ptr_add %[[BASE]]
// CHECK: wave.where
// CHECK: wave.index_expr <"1/2*Mod(2*raw0_0, 4294967296)">
// CHECK: wave.ptr_add %[[BASE]]
// CHECK-NOT: wave.scatter
func.func @predicated_wrapping_buffer_scatter(
    %base: !wave.ptr<#waveamd.buffer, f16>,
    %input: !wave.simd<vector<2xf16>, 32>,
    %i0: !wave.simd<i32, 32>, %i1: !wave.simd<i32, 32>,
    %m0: !wave.mask<32>, %m1: !wave.mask<32>) {
  %indices = wave.pack %i0, %i1
      : !wave.simd<i32, 32>, !wave.simd<i32, 32>
      -> !wave.simd<vector<2xi32>, 32>
  %initial = wave.token : !wave.mem.token
  %result = wave.where %m0, %m1 {
    %stored = wave.scatter %input to %base mapping
        <bit_offset = <"8*Mod(2*idx, 4294967296)">>
        bindings []() packet_bindings ["idx"](%indices)
        : (!wave.simd<vector<2xf16>, 32>, !wave.ptr<#waveamd.buffer, f16>,
           !wave.simd<vector<2xi32>, 32>) -> !wave.mem.token
    wave.yield %stored : !wave.mem.token
  } otherwise {
    wave.yield %initial : !wave.mem.token
  } : !wave.mask<32>, !wave.mask<32> -> !wave.mem.token
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

// Aligned bounds make all packet predicates equivalent.
// CHECK-LABEL: func.func @aligned_packet_predicated_gather(
// CHECK-COUNT-1: wave.where
// CHECK-COUNT-1: wave.load
// CHECK-SAME: -> (!wave.simd<vector<4xi32>, 32>, !wave.mem.token)
// CHECK-NOT: wave.gather
func.func @aligned_packet_predicated_gather(
    %base: !wave.ptr<#wave.global, i32>,
    %rawOrigin: !wave.simd<i32, 32>,
    %rawLimit: !wave.simd<i32, 32>)
    -> !wave.simd<vector<4xi32>, 32> {
  %limit = wave.assume %rawLimit as "limit"
      [#wave.pred<"Mod(limit, 8) == 0">] : !wave.simd<i32, 32>
  %four = wave.constant 4 : i32 -> !wave.simd<i32, 32>
  %origin = wave.binary muli %rawOrigin, %four overflow<nsw>
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %one = wave.constant 1 : i32 -> !wave.simd<i32, 32>
  %two = wave.constant 2 : i32 -> !wave.simd<i32, 32>
  %three = wave.constant 3 : i32 -> !wave.simd<i32, 32>
  %i1 = wave.binary addi %origin, %one overflow<nsw>
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %i2 = wave.binary addi %origin, %two overflow<nsw>
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %i3 = wave.binary addi %origin, %three overflow<nsw>
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %m0 = wave.cmpi slt %origin, %limit
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %m1 = wave.cmpi slt %i1, %limit
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %m2 = wave.cmpi slt %i2, %limit
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %m3 = wave.cmpi slt %i3, %limit
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %indices = wave.pack %origin, %i1, %i2, %i3
      : !wave.simd<i32, 32>, !wave.simd<i32, 32>,
        !wave.simd<i32, 32>, !wave.simd<i32, 32>
      -> !wave.simd<vector<4xi32>, 32>
  %zero = wave.constant 0 : i32 -> !wave.simd<i32, 32>
  %fallback = wave.pack %zero, %zero, %zero, %zero
      : !wave.simd<i32, 32>, !wave.simd<i32, 32>,
        !wave.simd<i32, 32>, !wave.simd<i32, 32>
      -> !wave.simd<vector<4xi32>, 32>
  %initial = wave.token : !wave.mem.token
  %result, %token = wave.where %m0, %m1, %m2, %m3 {
    %value, %loaded = wave.gather %base mapping
        <bit_offset = <"32 * idx">>
        bindings []() packet_bindings ["idx"](%indices)
        : (!wave.ptr<#wave.global, i32>, !wave.simd<vector<4xi32>, 32>)
        -> (!wave.simd<vector<4xi32>, 32>, !wave.mem.token)
    wave.yield %value, %loaded
        : !wave.simd<vector<4xi32>, 32>, !wave.mem.token
  } otherwise {
    wave.yield %fallback, %initial
        : !wave.simd<vector<4xi32>, 32>, !wave.mem.token
  } : !wave.mask<32>, !wave.mask<32>, !wave.mask<32>, !wave.mask<32>
      -> !wave.simd<vector<4xi32>, 32>, !wave.mem.token
  return %result : !wave.simd<vector<4xi32>, 32>
}

// -----

// Unknown bound alignment preserves independent predicates.
// CHECK-LABEL: func.func @unaligned_packet_predicated_gather(
// CHECK: wave.where
// CHECK-COUNT-4: wave.load
// CHECK-NOT: wave.load {{.*}}vector<
// CHECK-NOT: wave.gather
func.func @unaligned_packet_predicated_gather(
    %base: !wave.ptr<#wave.global, i32>,
    %rawOrigin: !wave.simd<i32, 32>,
    %limit: !wave.simd<i32, 32>)
    -> !wave.simd<vector<4xi32>, 32> {
  %origin = wave.assume %rawOrigin as "origin"
      [#wave.pred<"Mod(origin, 4) == 0">] : !wave.simd<i32, 32>
  %one = wave.constant 1 : i32 -> !wave.simd<i32, 32>
  %two = wave.constant 2 : i32 -> !wave.simd<i32, 32>
  %three = wave.constant 3 : i32 -> !wave.simd<i32, 32>
  %i1 = wave.binary addi %origin, %one overflow<nsw>
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %i2 = wave.binary addi %origin, %two overflow<nsw>
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %i3 = wave.binary addi %origin, %three overflow<nsw>
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %m0 = wave.cmpi slt %origin, %limit
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %m1 = wave.cmpi slt %i1, %limit
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %m2 = wave.cmpi slt %i2, %limit
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %m3 = wave.cmpi slt %i3, %limit
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %indices = wave.pack %origin, %i1, %i2, %i3
      : !wave.simd<i32, 32>, !wave.simd<i32, 32>,
        !wave.simd<i32, 32>, !wave.simd<i32, 32>
      -> !wave.simd<vector<4xi32>, 32>
  %zero = wave.constant 0 : i32 -> !wave.simd<i32, 32>
  %fallback = wave.pack %zero, %zero, %zero, %zero
      : !wave.simd<i32, 32>, !wave.simd<i32, 32>,
        !wave.simd<i32, 32>, !wave.simd<i32, 32>
      -> !wave.simd<vector<4xi32>, 32>
  %initial = wave.token : !wave.mem.token
  %result, %token = wave.where %m0, %m1, %m2, %m3 {
    %value, %loaded = wave.gather %base mapping
        <bit_offset = <"32 * idx">>
        bindings []() packet_bindings ["idx"](%indices)
        : (!wave.ptr<#wave.global, i32>, !wave.simd<vector<4xi32>, 32>)
        -> (!wave.simd<vector<4xi32>, 32>, !wave.mem.token)
    wave.yield %value, %loaded
        : !wave.simd<vector<4xi32>, 32>, !wave.mem.token
  } otherwise {
    wave.yield %fallback, %initial
        : !wave.simd<vector<4xi32>, 32>, !wave.mem.token
  } : !wave.mask<32>, !wave.mask<32>, !wave.mask<32>, !wave.mask<32>
      -> !wave.simd<vector<4xi32>, 32>, !wave.mem.token
  return %result : !wave.simd<vector<4xi32>, 32>
}

// -----

// A possibly-zero divisor keeps discrete-cut predicates non-equivalent.
// CHECK-LABEL: func.func @partial_packet_predicates(
// CHECK-COUNT-3: wave.load
// CHECK-NOT: wave.load {{.*}}vector<
// CHECK-NOT: wave.gather
func.func @partial_packet_predicates(
    %base: !wave.ptr<#wave.global, i32>,
    %x: !wave.simd<i32, 32>,
    %d: !wave.simd<i32, 32>)
    -> !wave.simd<vector<3xi32>, 32> {
  %q = wave.index_expr <"floor(x/d)"> ["x", "d"](%x, %d)
      : (!wave.simd<i32, 32>, !wave.simd<i32, 32>)
      -> !wave.simd<index, 32>
  %c8 = wave.constant 8 : index -> !wave.simd<index, 32>
  %c7 = wave.constant 7 : index -> !wave.simd<index, 32>
  %m0 = wave.cmpi slt %q, %c8
      : !wave.simd<index, 32>, !wave.simd<index, 32> -> !wave.mask<32>
  %mSame = wave.cmpi slt %q, %c8
      : !wave.simd<index, 32>, !wave.simd<index, 32> -> !wave.mask<32>
  %m1 = wave.cmpi sle %q, %c7
      : !wave.simd<index, 32>, !wave.simd<index, 32> -> !wave.mask<32>
  %zero = wave.constant 0 : i32 -> !wave.simd<i32, 32>
  %one = wave.constant 1 : i32 -> !wave.simd<i32, 32>
  %two = wave.constant 2 : i32 -> !wave.simd<i32, 32>
  %indices = wave.pack %zero, %one, %two
      : !wave.simd<i32, 32>, !wave.simd<i32, 32>, !wave.simd<i32, 32>
      -> !wave.simd<vector<3xi32>, 32>
  %fallback = wave.pack %zero, %zero, %zero
      : !wave.simd<i32, 32>, !wave.simd<i32, 32>, !wave.simd<i32, 32>
      -> !wave.simd<vector<3xi32>, 32>
  %initial = wave.token : !wave.mem.token
  %result, %token = wave.where %m0, %mSame, %m1 {
    %value, %loaded = wave.gather %base mapping
        <bit_offset = <"32 * idx">>
        bindings []() packet_bindings ["idx"](%indices)
        : (!wave.ptr<#wave.global, i32>, !wave.simd<vector<3xi32>, 32>)
        -> (!wave.simd<vector<3xi32>, 32>, !wave.mem.token)
    wave.yield %value, %loaded
        : !wave.simd<vector<3xi32>, 32>, !wave.mem.token
  } otherwise {
    wave.yield %fallback, %initial
        : !wave.simd<vector<3xi32>, 32>, !wave.mem.token
  } : !wave.mask<32>, !wave.mask<32>, !wave.mask<32>
      -> !wave.simd<vector<3xi32>, 32>, !wave.mem.token
  return %result : !wave.simd<vector<3xi32>, 32>
}

// -----

// CHECK-LABEL: func.func @aligned_packet_predicated_scatter(
// CHECK-COUNT-1: wave.where
// CHECK-COUNT-1: wave.store
// CHECK-SAME: !wave.simd<vector<4xi32>, 32>
// CHECK-NOT: wave.scatter
func.func @aligned_packet_predicated_scatter(
    %input: !wave.simd<vector<4xi32>, 32>,
    %base: !wave.ptr<#wave.global, i32>,
    %rawOrigin: !wave.simd<i32, 32>,
    %rawLimit: !wave.simd<i32, 32>) {
  %origin = wave.assume %rawOrigin as "origin"
      [#wave.pred<"Mod(origin, 4) == 0">] : !wave.simd<i32, 32>
  %limit = wave.assume %rawLimit as "limit"
      [#wave.pred<"Mod(limit, 4) == 0">] : !wave.simd<i32, 32>
  %one = wave.constant 1 : i32 -> !wave.simd<i32, 32>
  %two = wave.constant 2 : i32 -> !wave.simd<i32, 32>
  %three = wave.constant 3 : i32 -> !wave.simd<i32, 32>
  %i1 = wave.binary addi %origin, %one overflow<nsw>
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %i2 = wave.binary addi %origin, %two overflow<nsw>
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %i3 = wave.binary addi %origin, %three overflow<nsw>
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %m0 = wave.cmpi slt %origin, %limit
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %m1 = wave.cmpi slt %i1, %limit
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %m2 = wave.cmpi slt %i2, %limit
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %m3 = wave.cmpi slt %i3, %limit
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %indices = wave.pack %origin, %i1, %i2, %i3
      : !wave.simd<i32, 32>, !wave.simd<i32, 32>,
        !wave.simd<i32, 32>, !wave.simd<i32, 32>
      -> !wave.simd<vector<4xi32>, 32>
  %initial = wave.token : !wave.mem.token
  %result = wave.where %m0, %m1, %m2, %m3 {
    %stored = wave.scatter %input to %base mapping
        <bit_offset = <"32 * idx">>
        bindings []() packet_bindings ["idx"](%indices)
        : (!wave.simd<vector<4xi32>, 32>, !wave.ptr<#wave.global, i32>,
           !wave.simd<vector<4xi32>, 32>) -> !wave.mem.token
    wave.yield %stored : !wave.mem.token
  } otherwise {
    wave.yield %initial : !wave.mem.token
  } : !wave.mask<32>, !wave.mask<32>, !wave.mask<32>, !wave.mask<32>
      -> !wave.mem.token
  return
}

// -----

// A common outer predicate must not hide alignment-equivalent packet masks.
// CHECK-LABEL: func.func @nested_aligned_packet_predicated_scatter(
// CHECK-COUNT-1: wave.where
// CHECK-COUNT-1: wave.store
// CHECK-SAME: !wave.simd<vector<4xi32>, 32>
// CHECK-NOT: wave.scatter
func.func @nested_aligned_packet_predicated_scatter(
    %input: !wave.simd<vector<4xi32>, 32>,
    %base: !wave.ptr<#wave.global, i32>,
    %rawOrigin: !wave.simd<i32, 32>,
    %rawLimit: !wave.simd<i32, 32>,
    %row: !wave.simd<i32, 32>,
    %rowLimit: !wave.simd<i32, 32>) {
  %origin = wave.assume %rawOrigin as "origin"
      [#wave.pred<"Mod(origin, 4) == 0">] : !wave.simd<i32, 32>
  %limit = wave.assume %rawLimit as "limit"
      [#wave.pred<"Mod(limit, 4) == 0">] : !wave.simd<i32, 32>
  %one = wave.constant 1 : i32 -> !wave.simd<i32, 32>
  %two = wave.constant 2 : i32 -> !wave.simd<i32, 32>
  %three = wave.constant 3 : i32 -> !wave.simd<i32, 32>
  %i1 = wave.binary addi %origin, %one overflow<nsw>
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %i2 = wave.binary addi %origin, %two overflow<nsw>
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %i3 = wave.binary addi %origin, %three overflow<nsw>
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %rowActive = wave.cmpi slt %row, %rowLimit
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %m0 = wave.cmpi slt %origin, %limit
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %m1 = wave.cmpi slt %i1, %limit
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %m2 = wave.cmpi slt %i2, %limit
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %m3 = wave.cmpi slt %i3, %limit
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %false = wave.constant false -> !wave.mask<32>
  %a0 = wave.select %rowActive, %m0, %false
      : !wave.mask<32>, !wave.mask<32>
  %a1 = wave.select %rowActive, %m1, %false
      : !wave.mask<32>, !wave.mask<32>
  %a2 = wave.select %rowActive, %m2, %false
      : !wave.mask<32>, !wave.mask<32>
  %a3 = wave.select %rowActive, %m3, %false
      : !wave.mask<32>, !wave.mask<32>
  %indices = wave.pack %origin, %i1, %i2, %i3
      : !wave.simd<i32, 32>, !wave.simd<i32, 32>,
        !wave.simd<i32, 32>, !wave.simd<i32, 32>
      -> !wave.simd<vector<4xi32>, 32>
  %initial = wave.token : !wave.mem.token
  %result = wave.where %a0, %a1, %a2, %a3 {
    %stored = wave.scatter %input to %base mapping
        <bit_offset = <"32 * idx">>
        bindings []() packet_bindings ["idx"](%indices)
        : (!wave.simd<vector<4xi32>, 32>, !wave.ptr<#wave.global, i32>,
           !wave.simd<vector<4xi32>, 32>) -> !wave.mem.token
    wave.yield %stored : !wave.mem.token
  } otherwise {
    wave.yield %initial : !wave.mem.token
  } : !wave.mask<32>, !wave.mask<32>, !wave.mask<32>, !wave.mask<32>
      -> !wave.mem.token
  return
}

// -----

// Packet mask relations use i32 modular arithmetic even when the source ops
// do not promise no-overflow. Disjoint layout XORs must not hide the common
// aligned mask boundary.
// CHECK-LABEL: func.func @wrapping_xor_packet_predicated_scatter(
// CHECK-COUNT-1: wave.where
// CHECK-COUNT-1: wave.store
// CHECK-SAME: !wave.simd<vector<4xi32>, 32>
// CHECK-NOT: wave.scatter
func.func @wrapping_xor_packet_predicated_scatter(
    %input: !wave.simd<vector<4xi32>, 32>,
    %base: !wave.ptr<#wave.global, i32>,
    %rawLane: !wave.simd<i32, 32>,
    %rawTile: !wave.simd<i32, 32>,
    %rawLimit: !wave.simd<i32, 32>) {
  %lane = wave.assume %rawLane as "lane"
      [#wave.pred<"lane >= 0">, #wave.pred<"lane <= 31">]
      : !wave.simd<i32, 32>
  %limit = wave.assume %rawLimit as "limit"
      [#wave.pred<"Mod(limit, 4) == 0">] : !wave.simd<i32, 32>
  %four = wave.constant 4 : i32 -> !wave.simd<i32, 32>
  %addr0 = wave.binary muli %lane, %four overflow<nsw>
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %one = wave.constant 1 : i32 -> !wave.simd<i32, 32>
  %two = wave.constant 2 : i32 -> !wave.simd<i32, 32>
  %three = wave.constant 3 : i32 -> !wave.simd<i32, 32>
  %addr1 = wave.binary addi %addr0, %one overflow<nsw>
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %addr2 = wave.binary addi %addr0, %two overflow<nsw>
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %addr3 = wave.binary addi %addr0, %three overflow<nsw>
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %c128 = wave.constant 128 : i32 -> !wave.simd<i32, 32>
  %laneHigh = wave.binary muli %lane, %c128 overflow<nsw>
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %c64 = wave.constant 64 : i32 -> !wave.simd<i32, 32>
  %c65 = wave.constant 65 : i32 -> !wave.simd<i32, 32>
  %c66 = wave.constant 66 : i32 -> !wave.simd<i32, 32>
  %c67 = wave.constant 67 : i32 -> !wave.simd<i32, 32>
  %layout0 = wave.binary xori %laneHigh, %c64
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %layout1 = wave.binary xori %laneHigh, %c65
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %layout2 = wave.binary xori %laneHigh, %c66
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %layout3 = wave.binary xori %laneHigh, %c67
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %c256 = wave.constant 256 : i32 -> !wave.simd<i32, 32>
  %tileBase = wave.binary muli %rawTile, %c256
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %coord0 = wave.binary addi %tileBase, %layout0
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %coord1 = wave.binary addi %tileBase, %layout1
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %coord2 = wave.binary addi %tileBase, %layout2
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %coord3 = wave.binary addi %tileBase, %layout3
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %m0 = wave.cmpi slt %coord0, %limit
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %m1 = wave.cmpi slt %coord1, %limit
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %m2 = wave.cmpi slt %coord2, %limit
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %m3 = wave.cmpi slt %coord3, %limit
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %indices = wave.pack %addr0, %addr1, %addr2, %addr3
      : !wave.simd<i32, 32>, !wave.simd<i32, 32>,
        !wave.simd<i32, 32>, !wave.simd<i32, 32>
      -> !wave.simd<vector<4xi32>, 32>
  %initial = wave.token : !wave.mem.token
  %result = wave.where %m0, %m1, %m2, %m3 {
    %stored = wave.scatter %input to %base mapping
        <bit_offset = <"32 * idx">>
        bindings []() packet_bindings ["idx"](%indices)
        : (!wave.simd<vector<4xi32>, 32>, !wave.ptr<#wave.global, i32>,
           !wave.simd<vector<4xi32>, 32>) -> !wave.mem.token
    wave.yield %stored : !wave.mem.token
  } otherwise {
    wave.yield %initial : !wave.mem.token
  } : !wave.mask<32>, !wave.mask<32>, !wave.mask<32>, !wave.mask<32>
      -> !wave.mem.token
  return
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
// CHECK: wave.ptr_add [[SECOND]]
// CHECK-NOT: wave.ptr_add [[FIRST]]
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
// CHECK: wave.ptr_add [[SECOND]]
// CHECK-NOT: wave.ptr_add [[FIRST]]
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
// CHECK: wave.ptr_add [[SECOND]]
// CHECK-NOT: wave.ptr_add [[FIRST]]
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
// CHECK: wave.ptr_add [[FIRST]]
// CHECK: wave.load
// CHECK: wave.ptr_add [[SECOND]]
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
  %value, %token = wave.gather %base mapping
      <bit_offset = <"32 * (origin + idx)">>
      bindings ["origin"](%bias) packet_bindings
      ["idx", "idx", "idx", "idx"](%i0, %i1, %i2, %i3)
      : (!wave.ptr<#wave.global, i32>, index, !wave.simd<index, 32>,
         !wave.simd<index, 32>, !wave.simd<index, 32>,
         !wave.simd<index, 32>)
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
// CHECK-SAME: [[FIRST:%.*]]: !wave.ptr<#wave.shared, i32>, [[SECOND:%.*]]: !wave.ptr<#wave.shared, i32>
// CHECK: wave.ptr_add [[FIRST]]
// CHECK: wave.load
// CHECK-SAME: -> (!wave.simd<vector<2xi32>, 32>, !wave.mem.token)
// CHECK: wave.ptr_add [[SECOND]]
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
// CHECK: wave.index_expr <"2*item"> assuming [#wave.pred<"item >= 0 & -7 + item <= 0">]
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

// -----

// Pre-divide before integer packet substitution; rational xor stays integral.
// CHECK-LABEL: func.func @predivide_packet_binding(
// CHECK-COUNT-1: wave.store
// CHECK-NOT: wave.scatter
func.func @predivide_packet_binding(
    %value: !wave.simd<vector<1xf16>, 32>,
    %base: !wave.ptr<#wave.shared, f16>,
    %raw: !wave.simd<i32, 32>) {
  %index = wave.index_expr
      <"xor(1/8*(8*Mod(raw0, 2) + 32*Mod(floor(1/4*raw0), 2) + 16*Mod(floor(1/2*raw0), 2)), Mod(floor(1/16*raw0), 8))">
      ["raw0"](%raw)
      : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
  %token = wave.scatter %value to %base mapping
      <bit_offset = <"16 * idx">>
      bindings []() packet_bindings ["idx"](%index)
      : (!wave.simd<vector<1xf16>, 32>, !wave.ptr<#wave.shared, f16>,
         !wave.simd<index, 32>) -> !wave.mem.token
  return
}

// -----

// Expand equivalent integer packet expressions before adjacency proofs.
// CHECK-LABEL: func.func @expanded_packet_adjacency(
// CHECK-COUNT-1: wave.store
// CHECK-SAME: !wave.simd<vector<2xf16>, 32>
// CHECK-NOT: wave.store {{.*}}!wave.simd<f16, 32>
func.func @expanded_packet_adjacency(
    %value: !wave.simd<vector<2xf16>, 32>,
    %base: !wave.ptr<#wave.shared, f16>,
    %raw: !wave.simd<i32, 32>) {
  %i0 = wave.index_expr
      <"64*floor(1/8*raw0) + 8*xor(1/8*(8*Mod(raw0, 2) + 32*Mod(floor(1/4*raw0), 2) + 16*Mod(floor(1/2*raw0), 2)), Mod(floor(1/16*raw0), 8))">
      ["raw0"](%raw)
      : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
  %i1 = wave.index_expr
      <"1 + 64*floor(1/8*raw0) + 8*xor(Mod(raw0, 2) + 4*Mod(floor(1/4*raw0), 2) + 2*Mod(floor(1/2*raw0), 2), Mod(floor(1/16*raw0), 8))">
      ["raw0"](%raw)
      : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
  %token = wave.scatter %value to %base mapping
      <bit_offset = <"16 * idx">>
      bindings []() packet_bindings ["idx", "idx"](%i0, %i1)
      : (!wave.simd<vector<2xf16>, 32>, !wave.ptr<#wave.shared, f16>,
         !wave.simd<index, 32>, !wave.simd<index, 32>) -> !wave.mem.token
  return
}

// -----

// Analyze signed remainder packet relations without rematerializing them.
// CHECK-LABEL: func.func @dynamic_signed_remainder_adjacency(
// CHECK-COUNT-1: wave.store
// CHECK-SAME: !wave.simd<vector<8xf16>, 32>
// CHECK-NOT: wave.store {{.*}}!wave.simd<f16, 32>
func.func @dynamic_signed_remainder_adjacency(
    %value: !wave.simd<vector<8xf16>, 32>,
    %base: !wave.ptr<#wave.global, f16>,
    %origin_raw: !wave.simd<i32, 32>, %extent_raw: i32) {
  %origin = wave.assume %origin_raw as "x"
      [#wave.pred<"x >= 0">, #wave.pred<"x <= 1073741816">,
       #wave.pred<"Mod(x, 8) == 0">] : !wave.simd<i32, 32>
  %extent = wave.assume %extent_raw as "d"
      [#wave.pred<"Mod(d, 16) == 0">] : i32
  %extent_splat = wave.splat %extent : i32 -> !wave.simd<i32, 32>
  %one = wave.constant 1 : i32 -> !wave.simd<i32, 32>
  %two = wave.constant 2 : i32 -> !wave.simd<i32, 32>
  %three = wave.constant 3 : i32 -> !wave.simd<i32, 32>
  %four = wave.constant 4 : i32 -> !wave.simd<i32, 32>
  %five = wave.constant 5 : i32 -> !wave.simd<i32, 32>
  %six = wave.constant 6 : i32 -> !wave.simd<i32, 32>
  %seven = wave.constant 7 : i32 -> !wave.simd<i32, 32>
  %i1 = wave.binary addi %origin, %one overflow<nsw>
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %i2 = wave.binary addi %origin, %two overflow<nsw>
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %i3 = wave.binary addi %origin, %three overflow<nsw>
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %i4 = wave.binary addi %origin, %four overflow<nsw>
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %i5 = wave.binary addi %origin, %five overflow<nsw>
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %i6 = wave.binary addi %origin, %six overflow<nsw>
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %i7 = wave.binary addi %origin, %seven overflow<nsw>
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %r0 = wave.binary remsi %origin, %extent_splat
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %r1 = wave.binary remsi %i1, %extent_splat
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %r2 = wave.binary remsi %i2, %extent_splat
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %r3 = wave.binary remsi %i3, %extent_splat
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %r4 = wave.binary remsi %i4, %extent_splat
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %r5 = wave.binary remsi %i5, %extent_splat
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %r6 = wave.binary remsi %i6, %extent_splat
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %r7 = wave.binary remsi %i7, %extent_splat
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %indices = wave.pack %r0, %r1, %r2, %r3, %r4, %r5, %r6, %r7
      : !wave.simd<i32, 32>, !wave.simd<i32, 32>,
        !wave.simd<i32, 32>, !wave.simd<i32, 32>,
        !wave.simd<i32, 32>, !wave.simd<i32, 32>,
        !wave.simd<i32, 32>, !wave.simd<i32, 32>
      -> !wave.simd<vector<8xi32>, 32>
  %token = wave.scatter %value to %base mapping
      <bit_offset = <"16 * idx">>
      bindings []() packet_bindings ["idx"](%indices)
      : (!wave.simd<vector<8xf16>, 32>, !wave.ptr<#wave.global, f16>,
         !wave.simd<vector<8xi32>, 32>) -> !wave.mem.token
  return
}

// -----

// A dead packet binding is visited first. The later remainder binding still
// proves the known-positive-divisor successor.
// CHECK-LABEL: func.func @signed_remainder_later_binding_candidate(
// CHECK-COUNT-1: wave.store
// CHECK-SAME: !wave.simd<vector<2xf16>, 32>
// CHECK-NOT: wave.store {{.*}}!wave.simd<f16, 32>
func.func @signed_remainder_later_binding_candidate(
    %value: !wave.simd<vector<2xf16>, 32>,
    %base: !wave.ptr<#wave.global, f16>,
    %origin_raw: !wave.simd<i32, 32>, %extent_raw: i32) {
  %origin = wave.assume %origin_raw as "x"
      [#wave.pred<"x >= 0">, #wave.pred<"x <= 1073741822">,
       #wave.pred<"Mod(x, 2) == 0">] : !wave.simd<i32, 32>
  %extent = wave.assume %extent_raw as "d"
      [#wave.pred<"d >= 4">, #wave.pred<"d <= 1073741824">,
       #wave.pred<"Mod(d, 4) == 0">] : i32
  %extent_splat = wave.splat %extent : i32 -> !wave.simd<i32, 32>
  %one = wave.constant 1 : i32 -> !wave.simd<i32, 32>
  %next = wave.binary addi %origin, %one overflow<nsw>
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %junk0 = wave.binary remsi %origin, %extent_splat
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %junk = wave.index_expr <"x"> ["x"](%junk0)
      : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
  %r0 = wave.binary remsi %origin, %extent_splat
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %r1 = wave.binary remsi %next, %extent_splat
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %indices = wave.pack %r0, %r1
      : !wave.simd<i32, 32>, !wave.simd<i32, 32>
      -> !wave.simd<vector<2xi32>, 32>
  %token = wave.scatter %value to %base mapping
      <bit_offset = <"8 * junk + 16 * idx">>
      bindings []() packet_bindings
      ["junk", "junk", "idx"](%junk, %junk, %indices)
      : (!wave.simd<vector<2xf16>, 32>, !wave.ptr<#wave.global, f16>,
         !wave.simd<index, 32>, !wave.simd<index, 32>,
         !wave.simd<vector<2xi32>, 32>) -> !wave.mem.token
  return
}

// -----

// CHECK-LABEL: func.func @negative_divisor_signed_remainder_adjacency(
// CHECK-COUNT-1: wave.store
// CHECK-SAME: !wave.simd<vector<2xf16>, 32>
// CHECK-NOT: wave.store {{.*}}!wave.simd<f16, 32>
func.func @negative_divisor_signed_remainder_adjacency(
    %value: !wave.simd<vector<2xf16>, 32>,
    %base: !wave.ptr<#wave.global, f16>,
    %origin_raw: !wave.simd<i32, 32>, %extent_raw: i32) {
  %origin = wave.assume %origin_raw as "x"
      [#wave.pred<"x >= 0">, #wave.pred<"x <= 1073741822">,
       #wave.pred<"Mod(x, 2) == 0">] : !wave.simd<i32, 32>
  %extent = wave.assume %extent_raw as "d"
      [#wave.pred<"d >= -4">, #wave.pred<"d <= -4">] : i32
  %extent_splat = wave.splat %extent : i32 -> !wave.simd<i32, 32>
  %one = wave.constant 1 : i32 -> !wave.simd<i32, 32>
  %next = wave.binary addi %origin, %one overflow<nsw>
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %r0 = wave.binary remsi %origin, %extent_splat
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %r1 = wave.binary remsi %next, %extent_splat
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %indices = wave.pack %r0, %r1
      : !wave.simd<i32, 32>, !wave.simd<i32, 32>
      -> !wave.simd<vector<2xi32>, 32>
  %token = wave.scatter %value to %base mapping
      <bit_offset = <"16 * idx">>
      bindings []() packet_bindings ["idx"](%indices)
      : (!wave.simd<vector<2xf16>, 32>, !wave.ptr<#wave.global, f16>,
         !wave.simd<vector<2xi32>, 32>) -> !wave.mem.token
  return
}

// -----

// Facts attached to another SSA use still describe the producer value. The
// memory planner discovers them from the remainder component itself; operation
// order and dominance are irrelevant for declarative assumptions.
// CHECK-LABEL: func.func @signed_remainder_adjacency_from_ssa_use(
// CHECK-COUNT-1: wave.store
// CHECK-SAME: !wave.simd<vector<2xf16>, 32>
// CHECK-NOT: wave.store {{.*}}!wave.simd<f16, 32>
func.func @signed_remainder_adjacency_from_ssa_use(
    %value: !wave.simd<vector<2xf16>, 32>,
    %base: !wave.ptr<#wave.global, f16>,
    %origin_raw: !wave.simd<i32, 32>, %extent_raw: i32) {
  %origin = wave.assume %origin_raw as "x"
      [#wave.pred<"Mod(x, 2) == 0">] : !wave.simd<i32, 32>
  %extent = wave.assume %extent_raw as "d"
      [#wave.pred<"Mod(d, 4) == 0">] : i32
  %extent_splat = wave.splat %extent : i32 -> !wave.simd<i32, 32>
  %one = wave.constant 1 : i32 -> !wave.simd<i32, 32>
  %next = wave.binary addi %origin, %one overflow<nsw>
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %r0 = wave.binary remsi %origin, %extent_splat
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %r1 = wave.binary remsi %next, %extent_splat
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %indices = wave.pack %r0, %r1
      : !wave.simd<i32, 32>, !wave.simd<i32, 32>
      -> !wave.simd<vector<2xi32>, 32>
  %token = wave.scatter %value to %base mapping
      <bit_offset = <"16 * idx">>
      bindings []() packet_bindings ["idx"](%indices)
      : (!wave.simd<vector<2xf16>, 32>, !wave.ptr<#wave.global, f16>,
         !wave.simd<vector<2xi32>, 32>) -> !wave.mem.token
  %proof0 = wave.assume %r0 as "x" [#wave.pred<"x >= 0">]
      : !wave.simd<i32, 32>
  %proof1 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">]
      ["x"](%r1) : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
  return
}

// -----

// Signed remainder is not modulo for negative dividends. Without an SSA fact
// ruling out the negative wrap, the planner must retain scalar transactions.
// CHECK-LABEL: func.func @signed_remainder_unknown_sign(
// CHECK-COUNT-2: wave.store
// CHECK-SAME: !wave.simd<f16, 32>
func.func @signed_remainder_unknown_sign(
    %value: !wave.simd<vector<2xf16>, 32>,
    %base: !wave.ptr<#wave.global, f16>,
    %origin_raw: !wave.simd<i32, 32>, %extent_raw: i32) {
  %origin = wave.assume %origin_raw as "x"
      [#wave.pred<"Mod(x, 2) == 0">] : !wave.simd<i32, 32>
  %extent = wave.assume %extent_raw as "d"
      [#wave.pred<"Mod(d, 4) == 0">] : i32
  %extent_splat = wave.splat %extent : i32 -> !wave.simd<i32, 32>
  %one = wave.constant 1 : i32 -> !wave.simd<i32, 32>
  %next = wave.binary addi %origin, %one overflow<nsw>
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %r0 = wave.binary remsi %origin, %extent_splat
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %r1 = wave.binary remsi %next, %extent_splat
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %indices = wave.pack %r0, %r1
      : !wave.simd<i32, 32>, !wave.simd<i32, 32>
      -> !wave.simd<vector<2xi32>, 32>
  %token = wave.scatter %value to %base mapping
      <bit_offset = <"16 * idx">>
      bindings []() packet_bindings ["idx"](%indices)
      : (!wave.simd<vector<2xf16>, 32>, !wave.ptr<#wave.global, f16>,
         !wave.simd<vector<2xi32>, 32>) -> !wave.mem.token
  return
}

// -----

// CHECK-LABEL: func.func @dynamic_unsigned_remainder_adjacency(
// CHECK-COUNT-1: wave.store
// CHECK-SAME: !wave.simd<vector<2xf16>, 32>
// CHECK-NOT: wave.store {{.*}}!wave.simd<f16, 32>
func.func @dynamic_unsigned_remainder_adjacency(
    %value: !wave.simd<vector<2xf16>, 32>,
    %base: !wave.ptr<#wave.global, f16>,
    %origin_raw: !wave.simd<i32, 32>, %extent_raw: i32) {
  %origin = wave.assume %origin_raw as "x"
      [#wave.pred<"x >= 0">, #wave.pred<"x <= 1073741822">,
       #wave.pred<"Mod(x, 2) == 0">] : !wave.simd<i32, 32>
  %extent = wave.assume %extent_raw as "d"
      [#wave.pred<"d >= 4">, #wave.pred<"d <= 1073741824">,
       #wave.pred<"Mod(d, 4) == 0">] : i32
  %extent_splat = wave.splat %extent : i32 -> !wave.simd<i32, 32>
  %one = wave.constant 1 : i32 -> !wave.simd<i32, 32>
  %next = wave.binary addi %origin, %one overflow<nsw>
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %r0 = wave.binary remui %origin, %extent_splat
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %r1 = wave.binary remui %next, %extent_splat
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %indices = wave.pack %r0, %r1
      : !wave.simd<i32, 32>, !wave.simd<i32, 32>
      -> !wave.simd<vector<2xi32>, 32>
  %token = wave.scatter %value to %base mapping
      <bit_offset = <"16 * idx">>
      bindings []() packet_bindings ["idx"](%indices)
      : (!wave.simd<vector<2xf16>, 32>, !wave.ptr<#wave.global, f16>,
         !wave.simd<vector<2xi32>, 32>) -> !wave.mem.token
  return
}

// -----

// Successor crossing divisor boundary is not contiguous.
// CHECK-LABEL: func.func @unsigned_remainder_wrap_boundary(
// CHECK-COUNT-2: wave.store
// CHECK-SAME: !wave.simd<f16, 32>
func.func @unsigned_remainder_wrap_boundary(
    %value: !wave.simd<vector<2xf16>, 32>,
    %base: !wave.ptr<#wave.global, f16>,
    %origin_raw: !wave.simd<i32, 32>, %extent_raw: i32) {
  %origin = wave.assume %origin_raw as "x"
      [#wave.pred<"x >= 3">, #wave.pred<"x <= 3">,
       #wave.pred<"Mod(x, 4) == 3">] : !wave.simd<i32, 32>
  %extent = wave.assume %extent_raw as "d"
      [#wave.pred<"d >= 4">, #wave.pred<"d <= 4">,
       #wave.pred<"Mod(d, 4) == 0">] : i32
  %extent_splat = wave.splat %extent : i32 -> !wave.simd<i32, 32>
  %one = wave.constant 1 : i32 -> !wave.simd<i32, 32>
  %next = wave.binary addi %origin, %one overflow<nsw>
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %r0 = wave.binary remui %origin, %extent_splat
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %r1 = wave.binary remui %next, %extent_splat
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %indices = wave.pack %r0, %r1
      : !wave.simd<i32, 32>, !wave.simd<i32, 32>
      -> !wave.simd<vector<2xi32>, 32>
  %token = wave.scatter %value to %base mapping
      <bit_offset = <"16 * idx">>
      bindings []() packet_bindings ["idx"](%indices)
      : (!wave.simd<vector<2xf16>, 32>, !wave.ptr<#wave.global, f16>,
         !wave.simd<vector<2xi32>, 32>) -> !wave.mem.token
  return
}

// -----

// Packet assertions hold lane-wise. A workitem-period and first-iteration
// projection isolates the invariant remainder sign.
// CHECK-LABEL: func.func @signed_remainder_projected_from_packet_index(
// CHECK-COUNT-1: wave.load
// CHECK-SAME: !wave.simd<vector<2xf16>, 32>
// CHECK-NOT: wave.load {{.*}}!wave.simd<f16, 32>
// CANONICAL-LABEL: func.func @signed_remainder_projected_from_packet_index(
// CANONICAL-COUNT-1: wave.load
// CANONICAL-SAME: !wave.simd<vector<2xf16>, 32>
// CANONICAL-NOT: wave.load {{.*}}!wave.simd<f16, 32>
func.func @signed_remainder_projected_from_packet_index(
    %base: !wave.ptr<#wave.global, f16>, %origin_raw: i32,
    %extent_raw: i32, %stride_raw: i32,
    %initial_value: !wave.simd<vector<2xf16>, 32>)
    -> !wave.simd<vector<2xf16>, 32> attributes {
      wave.workgroup_size = array<i32: 32, 1, 1>
    } {
  %origin = wave.assume %origin_raw as "x"
      [#wave.pred<"Mod(x, 2) == 0">] : i32
  %extent = wave.assume %extent_raw as "d"
      [#wave.pred<"Mod(d, 4) == 0">] : i32
  %stride = wave.assume %stride_raw as "s"
      [#wave.pred<"s >= 1">] : i32
  %origin_splat = wave.splat %origin : i32 -> !wave.simd<i32, 32>
  %extent_splat = wave.splat %extent : i32 -> !wave.simd<i32, 32>
  %stride_splat = wave.splat %stride : i32 -> !wave.simd<i32, 32>
  %wi = wave.workitem_id 0 : !wave.simd<i32, 32>
  %c8_i32 = arith.constant 8 : i32
  %c2_i32 = arith.constant 2 : i32
  %c1_i32 = arith.constant 1 : i32
  %eight = wave.splat %c8_i32 : i32 -> !wave.simd<i32, 32>
  %two = wave.splat %c2_i32 : i32 -> !wave.simd<i32, 32>
  %one = wave.splat %c1_i32 : i32 -> !wave.simd<i32, 32>
  %lane = wave.binary remui %wi, %eight
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %lane_pair = wave.binary muli %lane, %two overflow<nsw>
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %dividend0 = wave.binary addi %origin_splat, %lane_pair overflow<nsw>
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %dividend1 = wave.binary addi %dividend0, %one overflow<nsw>
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %remainder0 = wave.binary remsi %dividend0, %extent_splat
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %remainder1 = wave.binary remsi %dividend1, %extent_splat
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %group = wave.binary divui %wi, %eight
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %group_offset = wave.binary muli %group, %stride_splat overflow<nsw>
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %initial0 = wave.binary addi %group_offset, %remainder0 overflow<nsw>
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %initial1 = wave.binary addi %group_offset, %remainder1 overflow<nsw>
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %c0 = arith.constant 0 : index
  %c2 = arith.constant 2 : index
  %c1 = arith.constant 1 : index
  %result:3 = scf.for %iv = %c0 to %c2 step %c1
      iter_args(%index0 = %initial0, %index1 = %initial1,
                %last_value = %initial_value)
      -> (!wave.simd<i32, 32>, !wave.simd<i32, 32>,
          !wave.simd<vector<2xf16>, 32>) {
    %offset0 = wave.index_expr <"x"> assuming
        [#wave.pred<"x >= 0">, #wave.pred<"x <= 2147483647">]
        ["x"](%index0) : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
    %offset1 = wave.index_expr <"x"> assuming
        [#wave.pred<"x >= 0">, #wave.pred<"x <= 2147483647">]
        ["x"](%index1) : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
    %value, %token = wave.gather %base mapping <bit_offset = <"16*offset">>
        bindings []() packet_bindings ["offset", "offset"](%offset0, %offset1)
        : (!wave.ptr<#wave.global, f16>, !wave.simd<index, 32>,
           !wave.simd<index, 32>)
        -> (!wave.simd<vector<2xf16>, 32>, !wave.mem.token)
    %next0 = wave.binary addi %index0, %stride_splat overflow<nsw>
        : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
    %next1 = wave.binary addi %index1, %stride_splat overflow<nsw>
        : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
    scf.yield %next0, %next1, %value
        : !wave.simd<i32, 32>, !wave.simd<i32, 32>,
          !wave.simd<vector<2xf16>, 32>
  }
  return %result#2 : !wave.simd<vector<2xf16>, 32>
}

// -----

// Projection must preserve both remainder operands.
// CHECK-LABEL: func.func @signed_remainder_changed_by_projection(
// CHECK-COUNT-2: wave.load
// CHECK-SAME: !wave.simd<f16, 32>
// CANONICAL-LABEL: func.func @signed_remainder_changed_by_projection(
// CANONICAL-COUNT-2: wave.load
// CANONICAL-SAME: !wave.simd<f16, 32>
func.func @signed_remainder_changed_by_projection(
    %base: !wave.ptr<#wave.global, f16>, %origin_raw: i32,
    %extent_raw: i32, %stride_raw: i32,
    %initial_value: !wave.simd<vector<2xf16>, 32>)
    -> !wave.simd<vector<2xf16>, 32> attributes {
      wave.workgroup_size = array<i32: 32, 1, 1>
    } {
  %origin = wave.assume %origin_raw as "x"
      [#wave.pred<"Mod(x, 2) == 0">] : i32
  %extent = wave.assume %extent_raw as "d"
      [#wave.pred<"Mod(d, 4) == 0">] : i32
  %stride = wave.assume %stride_raw as "s"
      [#wave.pred<"s >= 1">] : i32
  %origin_splat = wave.splat %origin : i32 -> !wave.simd<i32, 32>
  %extent_splat = wave.splat %extent : i32 -> !wave.simd<i32, 32>
  %stride_splat = wave.splat %stride : i32 -> !wave.simd<i32, 32>
  %wi = wave.workitem_id 0 : !wave.simd<i32, 32>
  %c8_i32 = arith.constant 8 : i32
  %c2_i32 = arith.constant 2 : i32
  %c1_i32 = arith.constant 1 : i32
  %eight = wave.splat %c8_i32 : i32 -> !wave.simd<i32, 32>
  %two = wave.splat %c2_i32 : i32 -> !wave.simd<i32, 32>
  %one = wave.splat %c1_i32 : i32 -> !wave.simd<i32, 32>
  %lane_pair = wave.binary muli %wi, %two overflow<nsw>
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %dividend0 = wave.binary addi %origin_splat, %lane_pair overflow<nsw>
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %dividend1 = wave.binary addi %dividend0, %one overflow<nsw>
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %remainder0 = wave.binary remsi %dividend0, %extent_splat
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %remainder1 = wave.binary remsi %dividend1, %extent_splat
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %group = wave.binary divui %wi, %eight
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %group_offset = wave.binary muli %group, %stride_splat overflow<nsw>
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %initial0 = wave.binary addi %group_offset, %remainder0 overflow<nsw>
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %initial1 = wave.binary addi %group_offset, %remainder1 overflow<nsw>
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %c0 = arith.constant 0 : index
  %c2 = arith.constant 2 : index
  %c1 = arith.constant 1 : index
  %result:3 = scf.for %iv = %c0 to %c2 step %c1
      iter_args(%index0 = %initial0, %index1 = %initial1,
                %last_value = %initial_value)
      -> (!wave.simd<i32, 32>, !wave.simd<i32, 32>,
          !wave.simd<vector<2xf16>, 32>) {
    %offset0 = wave.index_expr <"x"> assuming
        [#wave.pred<"x >= 0">, #wave.pred<"x <= 2147483647">]
        ["x"](%index0) : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
    %offset1 = wave.index_expr <"x"> assuming
        [#wave.pred<"x >= 0">, #wave.pred<"x <= 2147483647">]
        ["x"](%index1) : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
    %value, %token = wave.gather %base mapping <bit_offset = <"16*offset">>
        bindings []() packet_bindings ["offset", "offset"](%offset0, %offset1)
        : (!wave.ptr<#wave.global, f16>, !wave.simd<index, 32>,
           !wave.simd<index, 32>)
        -> (!wave.simd<vector<2xf16>, 32>, !wave.mem.token)
    %next0 = wave.binary addi %index0, %stride_splat overflow<nsw>
        : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
    %next1 = wave.binary addi %index1, %stride_splat overflow<nsw>
        : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
    scf.yield %next0, %next1, %value
        : !wave.simd<i32, 32>, !wave.simd<i32, 32>,
          !wave.simd<vector<2xf16>, 32>
  }
  return %result#2 : !wave.simd<vector<2xf16>, 32>
}

// -----

// Expand an affine bit offset before rejecting exact byte division.
// CHECK-LABEL: func.func @expanded_exact_byte_division(
// CHECK-COUNT-1: wave.load
// CHECK-SAME: -> (!wave.simd<vector<8xf16>, 32>, !wave.mem.token)
// CHECK-NOT: wave.gather
func.func @expanded_exact_byte_division(
    %base: !wave.ptr<#wave.global, f16>,
    %offset: !wave.simd<index, 32>)
    -> !wave.simd<vector<8xf16>, 32> {
  %value, %token = wave.gather %base mapping
      <bit_offset = <"16 * offset + 16 * slot">>
      bindings ["offset"](%offset) packet_bindings []()
      : (!wave.ptr<#wave.global, f16>, !wave.simd<index, 32>)
      -> (!wave.simd<vector<8xf16>, 32>, !wave.mem.token)
  return %value : !wave.simd<vector<8xf16>, 32>
}

// -----

// Narrow scalar bindings need an index-shaped ptr_add offset.
// CHECK-LABEL: func.func @scalar_i16_binding(
// CHECK-SAME: [[VALUE:%.*]]: !wave.simd<vector<2xi16>, 32>, [[BASE:%.*]]: !wave.ptr<#wave.shared, i16>, [[OFFSET:%.*]]: i16
// CHECK: [[INDEX:%.*]] = wave.index_expr <"offset">
// CHECK-SAME: ["offset"]([[OFFSET]]) : (i16) -> index
// CHECK: [[PTR:%.*]] = wave.ptr_add [[BASE]], [[INDEX]]
// CHECK-SAME: !wave.ptr<#wave.shared, i16>, index -> !wave.ptr<#wave.shared, i16>
// CHECK-COUNT-1: wave.store
// CHECK-NOT: wave.scatter
func.func @scalar_i16_binding(
    %value: !wave.simd<vector<2xi16>, 32>,
    %base: !wave.ptr<#wave.shared, i16>,
    %offset: i16) {
  %token = wave.scatter %value to %base mapping
      <bit_offset = <"16 * (offset + slot)">>
      bindings ["offset"](%offset) packet_bindings []()
      : (!wave.simd<vector<2xi16>, 32>, !wave.ptr<#wave.shared, i16>, i16)
      -> !wave.mem.token
  return
}

// -----

// Non-element-aligned offsets stay byte-addressed.
// CHECK-LABEL: func.func @inexact_element_offset(
// CHECK-SAME: [[BASE:%.*]]: !wave.ptr<#wave.shared, i32>, [[BYTE:%.*]]: i32
// CHECK: [[BYTE_BASE:%.*]] = wave.ptr_cast [[BASE]]
// CHECK-SAME: !wave.ptr<#wave.shared, i32> -> !wave.ptr<#wave.shared, i8>
// CHECK: [[PTR:%.*]] = wave.ptr_add [[BYTE_BASE]], [[BYTE]]
// CHECK-SAME: !wave.ptr<#wave.shared, i8>, i32 -> !wave.ptr<#wave.shared, i8>
// CHECK-COUNT-1: wave.load
// CHECK-NOT: wave.gather
func.func @inexact_element_offset(
    %base: !wave.ptr<#wave.shared, i32>, %byte: i32)
    -> !wave.simd<vector<2xi32>, 32> {
  %value, %token = wave.gather %base mapping
      <bit_offset = <"8 * byte + 32 * slot">>
      bindings ["byte"](%byte) packet_bindings []()
      : (!wave.ptr<#wave.shared, i32>, i32)
      -> (!wave.simd<vector<2xi32>, 32>, !wave.mem.token)
  return %value : !wave.simd<vector<2xi32>, 32>
}

// -----

// CHECK-LABEL: func.func @materialization_keeps_cheaper_simplification
// CHECK: wave.ptr_add %arg0, %arg1
// CHECK-NOT: wave.index_expr
// CHECK-NOT: wave.gather
func.func @materialization_keeps_cheaper_simplification(
    %base: !wave.ptr<#wave.shared, i8>, %x: !wave.simd<i32, 32>)
    -> !wave.simd<vector<1xi8>, 32>
    attributes {wave.workgroup_size = array<i32: 32, 1, 1>} {
  %value, %token = wave.gather %base mapping
      <bit_offset = <"8*(4*floor(1/4*x) + Mod(x, 4))">>
      bindings ["x"](%x) packet_bindings []()
      : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 32>)
      -> (!wave.simd<vector<1xi8>, 32>, !wave.mem.token)
  return %value : !wave.simd<vector<1xi8>, 32>
}

// -----

// CHECK-LABEL: func.func @materialization_rejects_equal_cost_simplification
// CHECK: %[[OFF:.*]] = wave.index_expr <"xor(32 + 4*b, 8*c)">
// CHECK: wave.ptr_add %arg0, %[[OFF]]
// CHECK-NOT: wave.gather
func.func @materialization_rejects_equal_cost_simplification(
    %base: !wave.ptr<#wave.shared, i8>,
    %b: !wave.simd<i32, 32>, %c: !wave.simd<i32, 32>)
    -> !wave.simd<vector<1xi8>, 32>
    attributes {wave.workgroup_size = array<i32: 32, 1, 1>} {
  %bounded_b = wave.assume %b as "x"
      [#wave.pred<"x >= 0 & -1 + x <= 0">] : !wave.simd<i32, 32>
  %bounded_c = wave.assume %c as "x"
      [#wave.pred<"x >= 0 & -1 + x <= 0">] : !wave.simd<i32, 32>
  %value, %token = wave.gather %base mapping
      <bit_offset = <"8*xor(32 + 4*b, 8*c)">>
      bindings ["b", "c"](%bounded_b, %bounded_c) packet_bindings []()
      : (!wave.ptr<#wave.shared, i8>,
         !wave.simd<i32, 32>, !wave.simd<i32, 32>)
      -> (!wave.simd<vector<1xi8>, 32>, !wave.mem.token)
  return %value : !wave.simd<vector<1xi8>, 32>
}

// -----

// CHECK-LABEL: func.func @exact_division_keeps_factored_materialization
// CHECK: %[[OFF:.*]] = wave.index_expr <"x*(y + z)">
// CHECK-NOT: wave.index_expr <"x*y + x*z">
// CHECK: wave.ptr_add %arg0, %[[OFF]]
// CHECK-NOT: wave.gather
func.func @exact_division_keeps_factored_materialization(
    %base: !wave.ptr<#wave.shared, i8>,
    %x: !wave.simd<i32, 32>, %y: !wave.simd<i32, 32>,
    %z: !wave.simd<i32, 32>) -> !wave.simd<vector<1xi8>, 32> {
  %value, %token = wave.gather %base mapping
      <bit_offset = <"8*(x*(y + z))">>
      bindings ["x", "y", "z"](%x, %y, %z) packet_bindings []()
      : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 32>,
         !wave.simd<i32, 32>, !wave.simd<i32, 32>)
      -> (!wave.simd<vector<1xi8>, 32>, !wave.mem.token)
  return %value : !wave.simd<vector<1xi8>, 32>
}

// -----

// Inactive slots keep packet order and the fallback token.
// CHECK-LABEL: func.func @statically_inactive_packet_lanes(
// CHECK: [[DEP:%.*]] = wave.token
// CHECK: [[ZERO:%.*]] = wave.constant 0.000000e+00
// CHECK-NOT: wave.gather
// CHECK: [[ACTIVE:%.*]]:2 = wave.where
// CHECK: wave.load {{.*}} after [[DEP]]
// CHECK: wave.pack [[ZERO]], [[ACTIVE]]#0, [[ZERO]]
// CHECK: wave.join [[DEP]], [[ACTIVE]]#1
func.func @statically_inactive_packet_lanes(
    %base: !wave.ptr<#waveamd.buffer, f32>)
    -> !wave.simd<vector<3xf32>, 32>
    attributes {wave.workgroup_size = array<i32: 32, 1, 1>} {
  %item = wave.workitem_id 0 : !wave.simd<i32, 32>
  %one = wave.constant 1 : i32 -> !wave.simd<i32, 32>
  %two = wave.constant 2 : i32 -> !wave.simd<i32, 32>
  %offset0 = wave.binary addi %item, %one
      : !wave.simd<i32, 32>, !wave.simd<i32, 32>
      -> !wave.simd<i32, 32>
  %offset2 = wave.binary addi %item, %two
      : !wave.simd<i32, 32>, !wave.simd<i32, 32>
      -> !wave.simd<i32, 32>
  %active0 = wave.cmpi slt %offset0, %one
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %active1 = wave.cmpi slt %item, %one
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %active2 = wave.cmpi slt %offset2, %one
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %dependency = wave.token : !wave.mem.token
  %zero = wave.constant 0.0 : f32 -> !wave.simd<f32, 32>
  %fallback = wave.pack %zero, %zero, %zero
      : !wave.simd<f32, 32>, !wave.simd<f32, 32>, !wave.simd<f32, 32>
      -> !wave.simd<vector<3xf32>, 32>
  %result:2 = wave.where %active0, %active1, %active2 {
    %value, %token = wave.gather %base mapping
        <bit_offset = <"32*offset">> bindings []()
        packet_bindings ["offset", "offset", "offset"]
                        (%offset0, %item, %offset2)
        after %dependency
        : (!wave.ptr<#waveamd.buffer, f32>,
           !wave.simd<i32, 32>, !wave.simd<i32, 32>,
           !wave.simd<i32, 32>, !wave.mem.token)
        -> (!wave.simd<vector<3xf32>, 32>, !wave.mem.token)
    wave.yield %value, %token
        : !wave.simd<vector<3xf32>, 32>, !wave.mem.token
  } otherwise {
    wave.yield %fallback, %dependency
        : !wave.simd<vector<3xf32>, 32>, !wave.mem.token
  } : !wave.mask<32>, !wave.mask<32>, !wave.mask<32>
      -> !wave.simd<vector<3xf32>, 32>, !wave.mem.token
  return %result#0 : !wave.simd<vector<3xf32>, 32>
}

// -----

// Inactive stores keep the incoming dependency.
// CHECK-LABEL: func.func @statically_inactive_packet_store(
// CHECK: [[DEP:%.*]] = wave.token
// CHECK-NOT: wave.scatter
// CHECK: [[ACTIVE:%.*]] = wave.where
// CHECK-COUNT-1: wave.store {{.*}} after [[DEP]]
// CHECK: wave.join [[ACTIVE]], [[DEP]]
func.func @statically_inactive_packet_store(
    %input: !wave.simd<vector<2xf32>, 32>,
    %base: !wave.ptr<#waveamd.buffer, f32>)
    attributes {wave.workgroup_size = array<i32: 32, 1, 1>} {
  %item = wave.workitem_id 0 : !wave.simd<i32, 32>
  %one = wave.constant 1 : i32 -> !wave.simd<i32, 32>
  %offset1 = wave.binary addi %item, %one
      : !wave.simd<i32, 32>, !wave.simd<i32, 32>
      -> !wave.simd<i32, 32>
  %active0 = wave.cmpi slt %item, %one
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %active1 = wave.cmpi slt %offset1, %one
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %dependency = wave.token : !wave.mem.token
  %result = wave.where %active0, %active1 {
    %stored = wave.scatter %input to %base mapping
        <bit_offset = <"32*offset">> bindings []()
        packet_bindings ["offset", "offset"](%item, %offset1)
        after %dependency
        : (!wave.simd<vector<2xf32>, 32>,
           !wave.ptr<#waveamd.buffer, f32>,
           !wave.simd<i32, 32>, !wave.simd<i32, 32>,
           !wave.mem.token)
        -> !wave.mem.token
    wave.yield %stored : !wave.mem.token
  } otherwise {
    wave.yield %dependency : !wave.mem.token
  } : !wave.mask<32>, !wave.mask<32> -> !wave.mem.token
  return
}

// -----

// CHECK-LABEL: func.func @finite_item_enumeration(
// CHECK: [[DEP:%.*]] = wave.token
// CHECK-NOT: wave.gather
// CHECK-COUNT-1: wave.load {{.*}} after [[DEP]]
// CHECK-SAME: !wave.simd<vector<2xf32>, 32>
func.func @finite_item_enumeration(
    %base: !wave.ptr<#wave.shared, f32>)
    -> !wave.simd<vector<2xf32>, 32>
    attributes {wave.workgroup_size = array<i32: 4, 1, 1>} {
  %dependency = wave.token : !wave.mem.token
  %value, %token = wave.gather %base mapping
      <bit_offset =
        <"32*Piecewise((slot, item*(item - 1)*(item - 2)*(item - 3) == 0), (2*slot, True))">>
      bindings []() packet_bindings []() after %dependency
      : (!wave.ptr<#wave.shared, f32>, !wave.mem.token)
      -> (!wave.simd<vector<2xf32>, 32>, !wave.mem.token)
  return %value : !wave.simd<vector<2xf32>, 32>
}

// -----

// CHECK-LABEL: func.func @finite_item_proof_failure(
// CHECK: [[DEP:%.*]] = wave.token
// CHECK-NOT: wave.gather
// CHECK-COUNT-2: wave.load {{.*}} after [[DEP]] {{.*}} -> (!wave.simd<f32, 32>,
func.func @finite_item_proof_failure(
    %base: !wave.ptr<#wave.shared, f32>)
    -> !wave.simd<vector<2xf32>, 32>
    attributes {wave.workgroup_size = array<i32: 5, 1, 1>} {
  %dependency = wave.token : !wave.mem.token
  %value, %token = wave.gather %base mapping
      <bit_offset =
        <"32*Piecewise((slot, item*(item - 1)*(item - 2)*(item - 3) == 0), (2*slot, True))">>
      bindings []() packet_bindings []() after %dependency
      : (!wave.ptr<#wave.shared, f32>, !wave.mem.token)
      -> (!wave.simd<vector<2xf32>, 32>, !wave.mem.token)
  return %value : !wave.simd<vector<2xf32>, 32>
}

// -----

// CHECK-LABEL: func.func @bounded_item_enumeration_fallback(
// CHECK: [[DEP:%.*]] = wave.token
// CHECK-NOT: wave.gather
// CHECK-COUNT-2: wave.load {{.*}} after [[DEP]] {{.*}} -> (!wave.simd<f32, 32>,
func.func @bounded_item_enumeration_fallback(
    %base: !wave.ptr<#wave.shared, f32>)
    -> !wave.simd<vector<2xf32>, 32>
    attributes {wave.workgroup_size = array<i32: 4097, 1, 1>} {
  %dependency = wave.token : !wave.mem.token
  %value, %token = wave.gather %base mapping
      <bit_offset =
        <"32*Piecewise((slot, item*(item - 1)*(item - 2)*(item - 3) == 0), (2*slot, True))">>
      bindings []() packet_bindings []() after %dependency
      : (!wave.ptr<#wave.shared, f32>, !wave.mem.token)
      -> (!wave.simd<vector<2xf32>, 32>, !wave.mem.token)
  return %value : !wave.simd<vector<2xf32>, 32>
}
