// RUN: wave-opt --wave-generate-index-exprs --wave-lower-symbolic-memory %s \
// RUN:   --split-input-file \
// RUN:   --mlir-timing --mlir-timing-display=tree 2>%t | FileCheck %s
// RUN: FileCheck %s --check-prefix=TIMING < %t
// RUN: wave-opt --wave-lower-symbolic-memory --split-input-file \
// RUN:   %s \
// RUN:   | FileCheck %s --check-prefix=PACKET

// TIMING-DAG: WaveLowerSymbolicMemory

// CHECK-LABEL: func.func @contiguous_gather(
// CHECK-NOT: wave.gather
// CHECK-COUNT-1: wave.load
// CHECK-SAME: -> (!wave.simd<vector<4xf32>, 32>, !wave.mem.token)
func.func @contiguous_gather(%base: !wave.ptr<#wave.shared, f32>,
                             %origin: index)
    -> !wave.simd<vector<4xf32>, 32>
    attributes {wave.workgroup_size = array<i32: 32, 1, 1>} {
  %item = wave.workitem_id 0 : !wave.simd<i32, 32>
  %bounded_item = wave.assume %item as "x"
      [#wave.pred<"x >= 0">, #wave.pred<"x <= 31">]
      : !wave.simd<i32, 32>
  %value, %token = wave.gather %base mapping
      <bit_offset = <"32 * (4 * item + origin + slot)">>
      bindings ["origin", "item"](%origin, %bounded_item)
      : (!wave.ptr<#wave.shared, f32>, index, !wave.simd<i32, 32>)
      -> (!wave.simd<vector<4xf32>, 32>, !wave.mem.token)
  return %value : !wave.simd<vector<4xf32>, 32>
}

// -----

// Unused operands do not constrain the address domain. This matters for
// accesses carried through a zero-trip loop: facts for the induction variable
// are contradictory inside the unreachable body, but the mapping may not use
// that operand at all.
// CHECK-LABEL: func.func @unused_contradictory_binding(
// CHECK-NOT: wave.gather
// CHECK: wave.load
func.func @unused_contradictory_binding(
    %base: !wave.ptr<#wave.shared, i32>, %unused: i32)
    -> !wave.simd<vector<2xi32>, 32> {
  %contradictory = wave.assume %unused as "x"
      [#wave.pred<"x >= 0">, #wave.pred<"x < 0">] : i32
  %value, %token = wave.gather %base mapping
      <bit_offset = <"32 * slot">> bindings ["unused"](%contradictory)
      : (!wave.ptr<#wave.shared, i32>, i32)
      -> (!wave.simd<vector<2xi32>, 32>, !wave.mem.token)
  return %value : !wave.simd<vector<2xi32>, 32>
}

// -----

// CHECK-LABEL: func.func @contiguous_buffer_gather(
// CHECK-SAME: %[[BASE:[^,]+]]: !wave.ptr<#waveamd.buffer, f32>
// CHECK-NOT: wave.gather
// CHECK-NOT: 4294967296
// CHECK: %[[BYTE_BASE:.*]] = wave.ptr_cast %[[BASE]]
// CHECK-SAME: !wave.ptr<#waveamd.buffer, f32> -> !wave.ptr<#waveamd.buffer, i8>
// CHECK: wave.ptr_add %[[BYTE_BASE]]
// CHECK-COUNT-1: wave.load
// CHECK-SAME: !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 32>
// CHECK-SAME: -> (!wave.simd<vector<4xf32>, 32>, !wave.mem.token)
func.func @contiguous_buffer_gather(
    %base: !wave.ptr<#waveamd.buffer, f32>, %origin: index)
    -> !wave.simd<vector<4xf32>, 32>
    attributes {wave.workgroup_size = array<i32: 32, 1, 1>} {
  %item = wave.workitem_id 0 : !wave.simd<i32, 32>
  %bounded_item = wave.assume %item as "x"
      [#wave.pred<"x >= 0">, #wave.pred<"x <= 31">]
      : !wave.simd<i32, 32>
  %value, %token = wave.gather %base mapping
      <bit_offset = <"32 * (4 * item + origin + slot)">>
      bindings ["origin", "item"](%origin, %bounded_item)
      : (!wave.ptr<#waveamd.buffer, f32>, index, !wave.simd<i32, 32>)
      -> (!wave.simd<vector<4xf32>, 32>, !wave.mem.token)
  return %value : !wave.simd<vector<4xf32>, 32>
}

// -----

// A buffer address that is syntactically scaled by one byte is divided
// exactly before the modulo-2^32 address comparison.
// CHECK-LABEL: func.func @scaled_modulo_buffer_gather(
// CHECK-NOT: wave.gather
// CHECK-COUNT-1: wave.load
func.func @scaled_modulo_buffer_gather(
    %base: !wave.ptr<#waveamd.buffer, bf16>)
    -> !wave.simd<vector<2xbf16>, 32>
    attributes {wave.workgroup_size = array<i32: 32, 1, 1>} {
  %item = wave.workitem_id 0 : !wave.simd<i32, 32>
  %bounded_item = wave.assume %item as "x"
      [#wave.pred<"x >= 0">, #wave.pred<"x <= 31">]
      : !wave.simd<i32, 32>
  %value, %token = wave.gather %base mapping
      <bit_offset = <"8*Mod(2*(2*item + slot), 4294967296)">>
      bindings ["item"](%bounded_item)
      : (!wave.ptr<#waveamd.buffer, bf16>, !wave.simd<i32, 32>)
      -> (!wave.simd<vector<2xbf16>, 32>, !wave.mem.token)
  return %value : !wave.simd<vector<2xbf16>, 32>
}

// -----

// Producer facts that are invariant under a slot pullback are available at the
// execution point and do not block the natural wide transaction.
// CHECK-LABEL: func.func @pulled_back_invariant_producer_fact(
// CHECK-NOT: wave.gather
// CHECK: [[SELECTED:%.*]] = wave.select
// CHECK: [[ORIGIN:%.*]] = wave.binary addi [[SELECTED]]
// CHECK: wave.index_expr <"2*origin">
// CHECK-SAME: ["origin"]([[ORIGIN]])
// CHECK: wave.load
// CHECK-SAME: -> (!wave.simd<vector<64xbf16>, 64>, !wave.mem.token)
func.func @pulled_back_invariant_producer_fact(
    %base: !wave.ptr<#waveamd.buffer, bf16>)
    -> !wave.mem.token
    attributes {wave.workgroup_size = array<i32: 64, 1, 1>} {
  %c0 = arith.constant 0 : i32
  %c2 = arith.constant 2 : i32
  %c63 = arith.constant 63 : i32
  %idx0 = arith.constant 0 : index
  %idx1 = arith.constant 1 : index
  %idx63 = arith.constant 63 : index
  %initial = wave.token : !wave.mem.token
  %result = scf.for %iv = %idx0 to %idx63 step %idx1
      iter_args(%dependency = %initial) -> (!wave.mem.token) {
    %iv_i32 = wave.cast intconvert %iv : index -> i32
    %loop_remainder = wave.binary remui %iv_i32, %c63
        : i32, i32 -> i32
    %quotient = wave.binary divui %loop_remainder, %c2 : i32, i32 -> i32
    %remainder = wave.binary remui %loop_remainder, %c2 : i32, i32 -> i32
    %even = arith.cmpi eq, %remainder, %c0 : i32
    %reverse = wave.binary subi %c63, %quotient : i32, i32 -> i32
    %selected = wave.select %even, %quotient, %reverse : i32
    %origin = wave.binary addi %selected, %c2 : i32, i32 -> i32
    %value, %token = wave.gather %base mapping
        <bit_offset = <"16*(origin + slot)">>
        bindings ["origin"](%origin)
        : (!wave.ptr<#waveamd.buffer, bf16>, i32)
        -> (!wave.simd<vector<64xbf16>, 64>, !wave.mem.token)
    scf.yield %token : !wave.mem.token
  }
  return %result : !wave.mem.token
}

// -----

// CHECK-LABEL: func.func @permuted_gather(
// CHECK-COUNT-4: wave.load
// CHECK-SAME: -> (!wave.simd<i32, 32>, !wave.mem.token)
// CHECK: wave.pack
// CHECK-NOT: wave.gather
func.func @permuted_gather(%base: !wave.ptr<#wave.shared, i32>)
    -> !wave.simd<vector<4xi32>, 32>
    attributes {wave.workgroup_size = array<i32: 32, 1, 1>} {
  %item = wave.workitem_id 0 : !wave.simd<i32, 32>
  %bounded_item = wave.assume %item as "x"
      [#wave.pred<"x >= 0">, #wave.pred<"x <= 31">]
      : !wave.simd<i32, 32>
  %value, %token = wave.gather %base mapping
      <bit_offset = <"32 * (4 * item + 2 * Mod(slot, 2) + floor(slot / 2))">>
      bindings ["item"](%bounded_item)
      : (!wave.ptr<#wave.shared, i32>, !wave.simd<i32, 32>)
      -> (!wave.simd<vector<4xi32>, 32>, !wave.mem.token)
  return %value : !wave.simd<vector<4xi32>, 32>
}

// -----

// CHECK-LABEL: func.func @permuted_scatter(
// CHECK-COUNT-4: wave.extract
// CHECK-COUNT-4: wave.store
// CHECK-SAME: !wave.simd<i32, 32>
// CHECK-NOT: wave.scatter
func.func @permuted_scatter(%value: !wave.simd<vector<4xi32>, 32>,
                            %base: !wave.ptr<#wave.shared, i32>)
    attributes {wave.workgroup_size = array<i32: 32, 1, 1>} {
  %item = wave.workitem_id 0 : !wave.simd<i32, 32>
  %bounded_item = wave.assume %item as "x"
      [#wave.pred<"x >= 0">, #wave.pred<"x <= 31">]
      : !wave.simd<i32, 32>
  %token = wave.scatter %value to %base mapping
      <bit_offset = <"32 * (4 * item + 2 * Mod(slot, 2) + floor(slot / 2))">>
      bindings ["item"](%bounded_item)
      : (!wave.simd<vector<4xi32>, 32>, !wave.ptr<#wave.shared, i32>,
         !wave.simd<i32, 32>)
      -> !wave.mem.token
  return
}

// -----

// CHECK-LABEL: func.func @contiguous_buffer_scatter(
// CHECK-SAME: %[[VALUE:[^,]+]]: !wave.simd<vector<4xi32>, 32>, %[[BASE:[^,)]+]]: !wave.ptr<#waveamd.buffer, i32>
// CHECK-NOT: wave.scatter
// CHECK-NOT: 4294967296
// CHECK: %[[BYTE_BASE:.*]] = wave.ptr_cast %[[BASE]]
// CHECK-SAME: !wave.ptr<#waveamd.buffer, i32> -> !wave.ptr<#waveamd.buffer, i8>
// CHECK: wave.ptr_add %[[BYTE_BASE]]
// CHECK-COUNT-1: wave.store
// CHECK-SAME: !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 32>
func.func @contiguous_buffer_scatter(
    %value: !wave.simd<vector<4xi32>, 32>,
    %base: !wave.ptr<#waveamd.buffer, i32>)
    attributes {wave.workgroup_size = array<i32: 32, 1, 1>} {
  %item = wave.workitem_id 0 : !wave.simd<i32, 32>
  %bounded_item = wave.assume %item as "x"
      [#wave.pred<"x >= 0">, #wave.pred<"x <= 31">]
      : !wave.simd<i32, 32>
  %token = wave.scatter %value to %base mapping
      <bit_offset = <"32 * (4 * item + slot)">>
      bindings ["item"](%bounded_item)
      : (!wave.simd<vector<4xi32>, 32>, !wave.ptr<#waveamd.buffer, i32>,
         !wave.simd<i32, 32>)
      -> !wave.mem.token
  return
}

// -----

// A scalarized packet does not promise contiguous register storage. Form each
// dword first, then assemble those registers into the wider transaction.
// CHECK-LABEL: func.func @scalarized_buffer_scatter(
// CHECK-NOT: wave.scatter
// CHECK-COUNT-2: wave.pack {{.*}} : !wave.simd<bf16, 32>, !wave.simd<bf16, 32> -> !wave.simd<vector<2xbf16>, 32>
// CHECK: wave.pack {{.*}} : !wave.simd<vector<2xbf16>, 32>, !wave.simd<vector<2xbf16>, 32> -> !wave.simd<vector<4xbf16>, 32>
// CHECK: wave.store {{.*}} : (!wave.simd<vector<4xbf16>, 32>,
func.func @scalarized_buffer_scatter(
    %v0: !wave.simd<bf16, 32>, %v1: !wave.simd<bf16, 32>,
    %v2: !wave.simd<bf16, 32>, %v3: !wave.simd<bf16, 32>,
    %base: !wave.ptr<#waveamd.buffer, bf16>)
    attributes {wave.workgroup_size = array<i32: 32, 1, 1>} {
  %item = wave.workitem_id 0 : !wave.simd<i32, 32>
  %bounded_item = wave.assume %item as "x"
      [#wave.pred<"x >= 0">, #wave.pred<"x <= 31">]
      : !wave.simd<i32, 32>
  %packet = wave.pack %v0, %v1, %v2, %v3
      : !wave.simd<bf16, 32>, !wave.simd<bf16, 32>,
        !wave.simd<bf16, 32>, !wave.simd<bf16, 32>
      -> !wave.simd<vector<4xbf16>, 32>
  %token = wave.scatter %packet to %base mapping
      <bit_offset = <"16 * (4 * item + slot)">>
      bindings ["item"](%bounded_item)
      : (!wave.simd<vector<4xbf16>, 32>, !wave.ptr<#waveamd.buffer, bf16>,
         !wave.simd<i32, 32>)
      -> !wave.mem.token
  return
}

// -----

// An 80-bit packet factors into the largest legal contiguous payload and its
// scalar tail through the same direct transaction map.
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
  %item = wave.workitem_id 0 : !wave.simd<i32, 32>
  %bounded_item = wave.assume %item as "x"
      [#wave.pred<"x >= 0">, #wave.pred<"x <= 31">]
      : !wave.simd<i32, 32>
  %value, %token = wave.gather %base mapping
      <bit_offset = <"16 * (5 * item + slot)">>
      bindings ["item"](%bounded_item) after %dependency
      : (!wave.ptr<#wave.shared, f16>, !wave.simd<i32, 32>, !wave.mem.token)
      -> (!wave.simd<vector<5xf16>, 32>, !wave.mem.token)
  return %value : !wave.simd<vector<5xf16>, 32>
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
  %item = wave.workitem_id 0 : !wave.simd<i32, 32>
  %bounded_item = wave.assume %item as "x"
      [#wave.pred<"x >= 0">, #wave.pred<"x <= 31">]
      : !wave.simd<i32, 32>
  %value, %token = wave.gather %base mapping
      <bit_offset = <"32 * (2 * item + Mod(slot, 2))">>
      bindings ["item"](%bounded_item)
      : (!wave.ptr<#wave.shared, i32>, !wave.simd<i32, 32>)
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
  %item = wave.workitem_id 0 : !wave.simd<i32, 32>
  %bounded_item = wave.assume %item as "x"
      [#wave.pred<"x >= 0">, #wave.pred<"x <= 31">]
      : !wave.simd<i32, 32>
  %token = wave.scatter %value to %base mapping
      <bit_offset = <"32 * (2 * item + Mod(slot, 2))">>
      bindings ["item"](%bounded_item)
      : (!wave.simd<vector<4xi32>, 32>, !wave.ptr<#wave.shared, i32>,
         !wave.simd<i32, 32>)
      -> !wave.mem.token
  return
}

// -----

// CHECK-LABEL: func.func @second_base(
// CHECK-SAME: [[FIRST:%.*]]: !wave.ptr<#wave.shared, i32>, [[SECOND:%.*]]: !wave.ptr<#wave.shared, i32>
// CHECK-NOT: wave.ptr_cast [[FIRST]]
// CHECK: [[BYTE:%.*]] = wave.ptr_cast [[SECOND]]
// CHECK-COUNT-1: wave.load [[BYTE]]
func.func @second_base(%first: !wave.ptr<#wave.shared, i32>,
                       %second: !wave.ptr<#wave.shared, i32>)
    -> !wave.simd<vector<2xi32>, 32> {
  %value, %token = wave.gather %first, %second mapping
      <base = <"1">, bit_offset = <"32 * slot">>
      bindings []()
      : (!wave.ptr<#wave.shared, i32>, !wave.ptr<#wave.shared, i32>)
      -> (!wave.simd<vector<2xi32>, 32>, !wave.mem.token)
  return %value : !wave.simd<vector<2xi32>, 32>
}

// -----

// CHECK-LABEL: func.func @constant_binding_base(
// CHECK-SAME: [[FIRST:%.*]]: !wave.ptr<#wave.shared, i32>, [[SECOND:%.*]]: !wave.ptr<#wave.shared, i32>
// CHECK-NOT: wave.ptr_cast [[FIRST]]
// CHECK: [[BYTE:%.*]] = wave.ptr_cast [[SECOND]]
// CHECK-COUNT-1: wave.load [[BYTE]]
func.func @constant_binding_base(%first: !wave.ptr<#wave.shared, i32>,
                                 %second: !wave.ptr<#wave.shared, i32>)
    -> !wave.simd<vector<2xi32>, 32> {
  %one = arith.constant 1 : index
  %value, %token = wave.gather %first, %second mapping
      <base = <"which">, bit_offset = <"32 * slot">>
      bindings ["which"](%one)
      : (!wave.ptr<#wave.shared, i32>, !wave.ptr<#wave.shared, i32>, index)
      -> (!wave.simd<vector<2xi32>, 32>, !wave.mem.token)
  return %value : !wave.simd<vector<2xi32>, 32>
}

// -----

// CHECK-LABEL: func.func @solver_exact_binding_base(
// CHECK-SAME: [[FIRST:%.*]]: !wave.ptr<#wave.shared, i32>, [[SECOND:%.*]]: !wave.ptr<#wave.shared, i32>
// CHECK-NOT: wave.ptr_cast [[FIRST]]
// CHECK: [[BYTE:%.*]] = wave.ptr_cast [[SECOND]]
// CHECK-COUNT-1: wave.load [[BYTE]]
func.func @solver_exact_binding_base(%first: !wave.ptr<#wave.shared, i32>,
                                     %second: !wave.ptr<#wave.shared, i32>,
                                     %raw: i32)
    -> !wave.simd<vector<2xi32>, 32> {
  %which = wave.index_expr <"x"> assuming
      [#wave.pred<"x >= 1">, #wave.pred<"x <= 1">] ["x"](%raw)
      : (i32) -> index
  %value, %token = wave.gather %first, %second mapping
      <base = <"which">, bit_offset = <"32 * slot">>
      bindings ["which"](%which)
      : (!wave.ptr<#wave.shared, i32>, !wave.ptr<#wave.shared, i32>, index)
      -> (!wave.simd<vector<2xi32>, 32>, !wave.mem.token)
  return %value : !wave.simd<vector<2xi32>, 32>
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
      <bit_offset = <"16 * floor((slot + 1) / 2)">>
      bindings []()
      : (!wave.simd<vector<4xf16>, 32>, !wave.ptr<#wave.shared, f16>)
      -> !wave.mem.token
  return
}

// -----

// Slot-static partitioning selects each base and stays vectorized.
// CHECK-LABEL: func.func @slot_partition_base(
// CHECK-SAME: [[FIRST:%.*]]: !wave.ptr<#wave.shared, i32>, [[SECOND:%.*]]: !wave.ptr<#wave.shared, i32>
// CHECK: [[FIRST_BYTE:%.*]] = wave.ptr_cast [[FIRST]]
// CHECK: wave.load [[FIRST_BYTE]]
// CHECK: [[SECOND_BYTE:%.*]] = wave.ptr_cast [[SECOND]]
// CHECK: wave.load [[SECOND_BYTE]]
// CHECK: [[FIRST_NEXT:%.*]] = wave.ptr_add [[FIRST_BYTE]],
// CHECK: wave.load [[FIRST_NEXT]]
// CHECK: [[SECOND_NEXT:%.*]] = wave.ptr_add [[SECOND_BYTE]],
// CHECK: wave.load [[SECOND_NEXT]]
// CHECK-SAME: -> (!wave.simd<i32, 32>, !wave.mem.token)
func.func @slot_partition_base(
    %first: !wave.ptr<#wave.shared, i32>,
    %second: !wave.ptr<#wave.shared, i32>)
    -> !wave.simd<vector<4xi32>, 32> {
  %value, %token = wave.gather %first, %second mapping
      <base = <"Mod(slot, 2)">,
       bit_offset = <"32 * floor(slot / 2)">>
      bindings []()
      : (!wave.ptr<#wave.shared, i32>, !wave.ptr<#wave.shared, i32>)
      -> (!wave.simd<vector<4xi32>, 32>, !wave.mem.token)
  return %value : !wave.simd<vector<4xi32>, 32>
}

// -----

// CHECK-LABEL: func.func @explicit_local_block(
// CHECK-COUNT-1: wave.load
func.func @explicit_local_block(%base: !wave.ptr<#wave.shared, i32>)
    -> !wave.simd<vector<2xi32>, 32> {
  %value, %token = wave.gather %base mapping
      <target_block = <"block">, bit_offset = <"32 * slot">>
      bindings []()
      : (!wave.ptr<#wave.shared, i32>)
      -> (!wave.simd<vector<2xi32>, 32>, !wave.mem.token)
  return %value : !wave.simd<vector<2xi32>, 32>
}

// -----

// CHECK-LABEL: func.func @row_major_item(
// CHECK: wave.workitem_id 0
// CHECK: wave.workitem_id 1
// CHECK: wave.binary muli
// CHECK: %[[ITEM:.*]] = wave.binary addi
// CHECK: %[[BOUNDED_ITEM:.*]] = wave.assume %[[ITEM]]
// CHECK: wave.index_expr <"8*item"> assuming
// CHECK-SAME: ["item"](%[[BOUNDED_ITEM]])
// CHECK-COUNT-1: wave.load
func.func @row_major_item(%base: !wave.ptr<#wave.shared, i32>)
    -> !wave.simd<vector<2xi32>, 32>
    attributes {wave.workgroup_size = array<i32: 4, 2, 1>} {
  %item_x = wave.workitem_id 0 : !wave.simd<i32, 32>
  %item_y = wave.workitem_id 1 : !wave.simd<i32, 32>
  %four = wave.constant 4 : i32 -> !wave.simd<i32, 32>
  %scaled_y = wave.binary muli %item_y, %four overflow<nsw>
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %item = wave.binary addi %item_x, %scaled_y overflow<nsw>
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %bounded_item = wave.assume %item as "x"
      [#wave.pred<"x >= 0">, #wave.pred<"x <= 7">]
      : !wave.simd<i32, 32>
  %value, %token = wave.gather %base mapping
      <bit_offset = <"32 * (2 * item + slot)">>
      bindings ["item"](%bounded_item)
      : (!wave.ptr<#wave.shared, i32>, !wave.simd<i32, 32>)
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
  %item = wave.workitem_id 0 : !wave.simd<i32, 32>
  %bounded_item = wave.index_expr <"x"> assuming
      [#wave.pred<"x >= 0">, #wave.pred<"x <= 31">] ["x"](%item)
      : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
  %value, %token = wave.gather %base mapping
      <base = <"floor(item / 32)">, bit_offset = <"32 * slot">>
      bindings ["item"](%bounded_item)
      : (!wave.ptr<#wave.shared, i32>, !wave.simd<index, 32>)
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
  %item_x = wave.workitem_id 0 : !wave.simd<i32, 32>
  %item_y = wave.workitem_id 1 : !wave.simd<i32, 32>
  %item_z = wave.workitem_id 2 : !wave.simd<i32, 32>
  %bounded_item = wave.index_expr <"x + 4*y + 8*z"> assuming
      [#wave.pred<"x >= 0">, #wave.pred<"-2147483647 + x <= 0">,
       #wave.pred<"y >= 0">, #wave.pred<"-2147483647 + y <= 0">,
       #wave.pred<"z >= 0">, #wave.pred<"-2147483647 + z <= 0">,
       #wave.pred<"x + 4*y + 8*z >= 0">,
       #wave.pred<"-15 + x + 4*y + 8*z <= 0">]
      ["x", "y", "z"](%item_x, %item_y, %item_z)
      : (!wave.simd<i32, 32>, !wave.simd<i32, 32>, !wave.simd<i32, 32>)
      -> !wave.simd<index, 32>
  %value, %token = wave.gather %base mapping
      <bit_offset = <"32 * (slot + floor(item / 16))">>
      bindings ["item"](%bounded_item)
      : (!wave.ptr<#wave.shared, i32>, !wave.simd<index, 32>)
      -> (!wave.simd<vector<2xi32>, 32>, !wave.mem.token)
  return %value : !wave.simd<vector<2xi32>, 32>
}

// -----

// CHECK-LABEL: func.func @where_then_control(
// CHECK-COUNT-1: wave.where
// CHECK-COUNT-1: wave.load
// CHECK-SAME: -> (!wave.simd<vector<2xi32>, 32>, !wave.mem.token)
// CHECK-NOT: wave.gather
func.func @where_then_control(%x: !wave.simd<i32, 32>,
                              %base: !wave.ptr<#wave.shared, i32>)
    -> !wave.simd<vector<2xi32>, 32> {
  %limit = wave.constant 16 : i32 -> !wave.simd<i32, 32>
  %active = wave.cmpi slt %x, %limit
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %zero = wave.constant 0 : i32 -> !wave.simd<i32, 32>
  %fallback = wave.pack %zero, %zero
      : !wave.simd<i32, 32>, !wave.simd<i32, 32>
      -> !wave.simd<vector<2xi32>, 32>
  %dependency = wave.token : !wave.mem.token
  %result, %token = wave.where %active {
    %value, %token = wave.gather %base mapping
        <bit_offset = <"32 * slot">>
        bindings []()
        : (!wave.ptr<#wave.shared, i32>)
        -> (!wave.simd<vector<2xi32>, 32>, !wave.mem.token)
    wave.yield %value, %token
        : !wave.simd<vector<2xi32>, 32>, !wave.mem.token
  } otherwise {
    wave.yield %fallback, %dependency
        : !wave.simd<vector<2xi32>, 32>, !wave.mem.token
  } : !wave.mask<32> -> !wave.simd<vector<2xi32>, 32>, !wave.mem.token
  return %result : !wave.simd<vector<2xi32>, 32>
}

// -----

// Identical inactive transactions are assembled once before their sibling
// control regions.
// CHECK-LABEL: func.func @packet_gather_shares_inactive_transaction
// CHECK: [[INACTIVE:%.*]] = wave.pack {{.*}} -> !wave.simd<vector<2xi32>, 32>
// CHECK: wave.where
// CHECK: wave.yield [[INACTIVE]],
// CHECK: wave.where
// CHECK: wave.yield [[INACTIVE]],
// CHECK-NOT: wave.gather
func.func @packet_gather_shares_inactive_transaction(
    %item: !wave.simd<i32, 32>, %limit0: !wave.simd<i32, 32>,
    %limit1: !wave.simd<i32, 32>, %base: !wave.ptr<#wave.shared, i32>)
    -> !wave.simd<vector<4xi32>, 32> {
  %active0 = wave.cmpi slt %item, %limit0
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %active1 = wave.cmpi slt %item, %limit1
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %zero = wave.constant 0 : i32 -> !wave.simd<i32, 32>
  %fallback = wave.pack %zero, %zero, %zero, %zero
      : !wave.simd<i32, 32>, !wave.simd<i32, 32>,
        !wave.simd<i32, 32>, !wave.simd<i32, 32>
      -> !wave.simd<vector<4xi32>, 32>
  %dependency = wave.token : !wave.mem.token
  %result, %token = wave.where %active0, %active0, %active1, %active1 {
    %value, %loaded = wave.gather %base mapping
        <bit_offset = <"32 * slot">>
        bindings []()
        : (!wave.ptr<#wave.shared, i32>)
        -> (!wave.simd<vector<4xi32>, 32>, !wave.mem.token)
    wave.yield %value, %loaded
        : !wave.simd<vector<4xi32>, 32>, !wave.mem.token
  } otherwise {
    wave.yield %fallback, %dependency
        : !wave.simd<vector<4xi32>, 32>, !wave.mem.token
  } : !wave.mask<32>, !wave.mask<32>, !wave.mask<32>, !wave.mask<32>
      -> !wave.simd<vector<4xi32>, 32>, !wave.mem.token
  return %result : !wave.simd<vector<4xi32>, 32>
}

// -----

// A packet domain proven inactive still contributes its fallback result, but
// must not issue a guarded memory transaction.
// CHECK-LABEL: func.func @packet_gather_elides_proven_inactive_transaction
// CHECK-COUNT-1: wave.where
// CHECK-COUNT-1: wave.load
// CHECK-NOT: wave.gather
func.func @packet_gather_elides_proven_inactive_transaction(
    %base: !wave.ptr<#wave.shared, i32>)
    -> !wave.simd<vector<2xi32>, 32> {
  %item = wave.workitem_id 0 : !wave.simd<i32, 32>
  %bounded = wave.assume %item as "x"
      [#wave.pred<"x >= 0">, #wave.pred<"-31 + x <= 0">]
      : !wave.simd<i32, 32>
  %first = wave.index_expr <"item"> ["item"](%bounded)
      : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
  %second = wave.index_expr <"32 + item"> ["item"](%bounded)
      : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
  %one = wave.constant 1 : index -> !wave.simd<index, 32>
  %active0 = wave.cmpi slt %first, %one
      : !wave.simd<index, 32>, !wave.simd<index, 32> -> !wave.mask<32>
  %active1 = wave.cmpi slt %second, %one
      : !wave.simd<index, 32>, !wave.simd<index, 32> -> !wave.mask<32>
  %zero = wave.constant 0 : i32 -> !wave.simd<i32, 32>
  %fallback = wave.pack %zero, %zero
      : !wave.simd<i32, 32>, !wave.simd<i32, 32>
      -> !wave.simd<vector<2xi32>, 32>
  %dependency = wave.token : !wave.mem.token
  %result, %token = wave.where %active0, %active1 {
    %value, %loaded = wave.gather %base mapping
        <bit_offset = <"32 * slot">>
        bindings []() after %dependency
        : (!wave.ptr<#wave.shared, i32>, !wave.mem.token)
        -> (!wave.simd<vector<2xi32>, 32>, !wave.mem.token)
    wave.yield %value, %loaded
        : !wave.simd<vector<2xi32>, 32>, !wave.mem.token
  } otherwise {
    wave.yield %fallback, %dependency
        : !wave.simd<vector<2xi32>, 32>, !wave.mem.token
  } : !wave.mask<32>, !wave.mask<32>
      -> !wave.simd<vector<2xi32>, 32>, !wave.mem.token
  return %result : !wave.simd<vector<2xi32>, 32>
}

// -----

// Different inactive component tuples remain distinct.
// CHECK-LABEL: func.func @packet_gather_keeps_distinct_inactive_transactions
// CHECK: [[LOW:%.*]] = wave.pack {{.*}} -> !wave.simd<vector<2xi32>, 32>
// CHECK: wave.where
// CHECK: wave.yield [[LOW]],
// CHECK: [[HIGH:%.*]] = wave.pack {{.*}} -> !wave.simd<vector<2xi32>, 32>
// CHECK: wave.where
// CHECK: wave.yield [[HIGH]],
// CHECK-NOT: wave.gather
func.func @packet_gather_keeps_distinct_inactive_transactions(
    %item: !wave.simd<i32, 32>, %limit0: !wave.simd<i32, 32>,
    %limit1: !wave.simd<i32, 32>, %base: !wave.ptr<#wave.shared, i32>)
    -> !wave.simd<vector<4xi32>, 32> {
  %active0 = wave.cmpi slt %item, %limit0
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %active1 = wave.cmpi slt %item, %limit1
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %zero = wave.constant 0 : i32 -> !wave.simd<i32, 32>
  %one = wave.constant 1 : i32 -> !wave.simd<i32, 32>
  %fallback = wave.pack %zero, %zero, %one, %one
      : !wave.simd<i32, 32>, !wave.simd<i32, 32>,
        !wave.simd<i32, 32>, !wave.simd<i32, 32>
      -> !wave.simd<vector<4xi32>, 32>
  %dependency = wave.token : !wave.mem.token
  %result, %token = wave.where %active0, %active0, %active1, %active1 {
    %value, %loaded = wave.gather %base mapping
        <bit_offset = <"32 * slot">>
        bindings []()
        : (!wave.ptr<#wave.shared, i32>)
        -> (!wave.simd<vector<4xi32>, 32>, !wave.mem.token)
    wave.yield %value, %loaded
        : !wave.simd<vector<4xi32>, 32>, !wave.mem.token
  } otherwise {
    wave.yield %fallback, %dependency
        : !wave.simd<vector<4xi32>, 32>, !wave.mem.token
  } : !wave.mask<32>, !wave.mask<32>, !wave.mask<32>, !wave.mask<32>
      -> !wave.simd<vector<4xi32>, 32>, !wave.mem.token
  return %result : !wave.simd<vector<4xi32>, 32>
}

// -----

// CHECK-LABEL: func.func @where_else_control(
// CHECK-COUNT-1: wave.where
// CHECK-COUNT-1: wave.load
// CHECK-SAME: -> (!wave.simd<vector<2xi32>, 32>, !wave.mem.token)
// CHECK-NOT: wave.gather
func.func @where_else_control(%x: !wave.simd<i32, 32>,
                              %base: !wave.ptr<#wave.shared, i32>)
    -> !wave.simd<vector<2xi32>, 32> {
  %limit = wave.constant 16 : i32 -> !wave.simd<i32, 32>
  %active = wave.cmpi slt %x, %limit
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %zero = wave.constant 0 : i32 -> !wave.simd<i32, 32>
  %fallback = wave.pack %zero, %zero
      : !wave.simd<i32, 32>, !wave.simd<i32, 32>
      -> !wave.simd<vector<2xi32>, 32>
  %dependency = wave.token : !wave.mem.token
  %result, %token = wave.where %active {
    wave.yield %fallback, %dependency
        : !wave.simd<vector<2xi32>, 32>, !wave.mem.token
  } otherwise {
    %value, %token = wave.gather %base mapping
        <bit_offset = <"32 * slot">>
        bindings []()
        : (!wave.ptr<#wave.shared, i32>)
        -> (!wave.simd<vector<2xi32>, 32>, !wave.mem.token)
    wave.yield %value, %token
        : !wave.simd<vector<2xi32>, 32>, !wave.mem.token
  } : !wave.mask<32> -> !wave.simd<vector<2xi32>, 32>, !wave.mem.token
  return %result : !wave.simd<vector<2xi32>, 32>
}

// -----

// CHECK-LABEL: func.func @where_then_scatter_control(
// CHECK-COUNT-1: wave.where
// CHECK-COUNT-1: wave.store
// CHECK-SAME: !wave.simd<vector<2xi32>, 32>
// CHECK-NOT: wave.scatter
func.func @where_then_scatter_control(
    %value: !wave.simd<vector<2xi32>, 32>, %x: !wave.simd<i32, 32>,
    %base: !wave.ptr<#wave.shared, i32>) {
  %limit = wave.constant 16 : i32 -> !wave.simd<i32, 32>
  %active = wave.cmpi slt %x, %limit
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  wave.where %active {
    %token = wave.scatter %value to %base mapping
        <bit_offset = <"32 * slot">>
        bindings []()
        : (!wave.simd<vector<2xi32>, 32>, !wave.ptr<#wave.shared, i32>)
        -> !wave.mem.token
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
                          %base: !wave.ptr<#wave.shared, i32>)
    -> !wave.simd<vector<2xi32>, 32> {
  %limit = arith.constant 16 : index
  %active = arith.cmpi slt, %x, %limit : index
  %result = scf.if %active -> (!wave.simd<vector<2xi32>, 32>) {
    %value, %token = wave.gather %base mapping
        <bit_offset = <"32 * slot">>
        bindings []()
        : (!wave.ptr<#wave.shared, i32>)
        -> (!wave.simd<vector<2xi32>, 32>, !wave.mem.token)
    scf.yield %value : !wave.simd<vector<2xi32>, 32>
  } else {
    %value, %token = wave.gather %base mapping
        <bit_offset = <"32 * slot">>
        bindings []()
        : (!wave.ptr<#wave.shared, i32>)
        -> (!wave.simd<vector<2xi32>, 32>, !wave.mem.token)
    scf.yield %value : !wave.simd<vector<2xi32>, 32>
  }
  return %result : !wave.simd<vector<2xi32>, 32>
}

// -----

// The exact query starts from the final mapping coordinate; the input packets
// do not need to expose a separate remainder relation.
// CHECK-LABEL: func.func @mapping_remainder_adjacency(
// CHECK-COUNT-1: wave.store
// CHECK-SAME: !wave.simd<vector<2xf16>, 32>
// CHECK-NOT: wave.store {{.*}}!wave.simd<f16, 32>
// PACKET-LABEL: func.func @mapping_remainder_adjacency(
// PACKET-COUNT-1: wave.store
// PACKET-SAME: !wave.simd<vector<2xf16>, 32>
// PACKET-NOT: wave.store {{.*}}!wave.simd<f16, 32>
func.func @mapping_remainder_adjacency(
    %value: !wave.simd<vector<2xf16>, 32>,
    %base: !wave.ptr<#wave.global, f16>,
    %origin: !wave.simd<i32, 32>, %extent: i32) {
  %x = wave.index_expr <"x"> assuming
      [#wave.pred<"x >= 0">, #wave.pred<"x <= 62">]
      ["x"](%origin) : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
  %d = wave.index_expr <"d"> assuming
      [#wave.pred<"d >= 64">, #wave.pred<"d <= 64">]
      ["d"](%extent) : (i32) -> index
  %token = wave.scatter %value to %base mapping
      <bit_offset = <"16 * Mod(x + slot, d)">>
      bindings ["x", "d"](%x, %d)
      : (!wave.simd<vector<2xf16>, 32>, !wave.ptr<#wave.global, f16>,
         !wave.simd<index, 32>, index) -> !wave.mem.token
  return
}

// CHECK-LABEL: func.func @mapping_remainder_wrap_boundary(
// CHECK-COUNT-2: wave.store
// CHECK-SAME: !wave.simd<f16, 32>
// PACKET-LABEL: func.func @mapping_remainder_wrap_boundary(
// PACKET-COUNT-2: wave.store
// PACKET-SAME: !wave.simd<f16, 32>
func.func @mapping_remainder_wrap_boundary(
    %value: !wave.simd<vector<2xf16>, 32>,
    %base: !wave.ptr<#wave.global, f16>,
    %origin: !wave.simd<i32, 32>, %extent: i32) {
  %x = wave.index_expr <"x"> assuming
      [#wave.pred<"x >= 63">, #wave.pred<"x <= 63">]
      ["x"](%origin) : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
  %d = wave.index_expr <"d"> assuming
      [#wave.pred<"d >= 64">, #wave.pred<"d <= 64">]
      ["d"](%extent) : (i32) -> index
  %token = wave.scatter %value to %base mapping
      <bit_offset = <"16 * Mod(x + slot, d)">>
      bindings ["x", "d"](%x, %d)
      : (!wave.simd<vector<2xf16>, 32>, !wave.ptr<#wave.global, f16>,
         !wave.simd<index, 32>, index) -> !wave.mem.token
  return
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
      bindings ["offset"](%offset)
      : (!wave.ptr<#wave.global, f16>, !wave.simd<index, 32>)
      -> (!wave.simd<vector<8xf16>, 32>, !wave.mem.token)
  return %value : !wave.simd<vector<8xf16>, 32>
}

// -----

// Narrow scalar bindings need an index-shaped ptr_add offset.
// CHECK-LABEL: func.func @scalar_i16_binding(
// CHECK-SAME: [[VALUE:%.*]]: !wave.simd<vector<2xi16>, 32>, [[BASE:%.*]]: !wave.ptr<#wave.shared, i16>, [[OFFSET:%.*]]: i16
// CHECK-COUNT-2: wave.extract
// CHECK: [[BYTE:%.*]] = wave.ptr_cast [[BASE]]
// CHECK-SAME: !wave.ptr<#wave.shared, i16> -> !wave.ptr<#wave.shared, i8>
// CHECK: [[INDEX:%.*]] = wave.index_expr <"2*offset">
// CHECK-SAME: ["offset"]([[OFFSET]]) : (i16) -> index
// CHECK: [[PTR:%.*]] = wave.ptr_add [[BYTE]], [[INDEX]]
// CHECK-SAME: !wave.ptr<#wave.shared, i8>, index -> !wave.ptr<#wave.shared, i8>
// CHECK-COUNT-1: wave.store
// CHECK-NOT: wave.scatter
func.func @scalar_i16_binding(
    %value: !wave.simd<vector<2xi16>, 32>,
    %base: !wave.ptr<#wave.shared, i16>,
    %offset: i16) {
  %token = wave.scatter %value to %base mapping
      <bit_offset = <"16 * (offset + slot)">>
      bindings ["offset"](%offset)
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
// CHECK: [[OFFSET:%.*]] = wave.index_expr <"byte">
// CHECK-SAME: ["byte"]([[BYTE]])
// CHECK: [[PTR:%.*]] = wave.ptr_add [[BYTE_BASE]], [[OFFSET]]
// CHECK-SAME: !wave.ptr<#wave.shared, i8>, index -> !wave.ptr<#wave.shared, i8>
// CHECK-COUNT-1: wave.load
// CHECK-NOT: wave.gather
func.func @inexact_element_offset(
    %base: !wave.ptr<#wave.shared, i32>, %byte: i32)
    -> !wave.simd<vector<2xi32>, 32> {
  %value, %token = wave.gather %base mapping
      <bit_offset = <"8 * byte + 32 * slot">>
      bindings ["byte"](%byte)
      : (!wave.ptr<#wave.shared, i32>, i32)
      -> (!wave.simd<vector<2xi32>, 32>, !wave.mem.token)
  return %value : !wave.simd<vector<2xi32>, 32>
}

// -----

// CHECK-LABEL: func.func @materialization_keeps_cheaper_simplification(
// CHECK-SAME: [[BASE:%.*]]: !wave.ptr<#wave.shared, i8>, [[X:%.*]]: !wave.simd<i32, 32>
// CHECK: wave.constant 0
// CHECK: [[OFFSET:%.*]] = wave.index_expr <"x">
// CHECK-SAME: ["x"]([[X]])
// CHECK: wave.ptr_add [[BASE]], [[OFFSET]]
// CHECK-NOT: wave.gather
func.func @materialization_keeps_cheaper_simplification(
    %base: !wave.ptr<#wave.shared, i8>, %x: !wave.simd<i32, 32>)
    -> !wave.simd<vector<1xi8>, 32>
    attributes {wave.workgroup_size = array<i32: 32, 1, 1>} {
  %value, %token = wave.gather %base mapping
      <bit_offset = <"8*(4*floor(1/4*x) + Mod(x, 4))">>
      bindings ["x"](%x)
      : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 32>)
      -> (!wave.simd<vector<1xi8>, 32>, !wave.mem.token)
  return %value : !wave.simd<vector<1xi8>, 32>
}

// -----

// CHECK-LABEL: func.func @materialization_uses_fact_proven_simplification
// CHECK: %[[OFF:.*]] = wave.index_expr <"32 + 4*b + 8*c">
// CHECK: wave.ptr_add %arg0, %[[OFF]]
// CHECK-NOT: wave.gather
func.func @materialization_uses_fact_proven_simplification(
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
      bindings ["b", "c"](%bounded_b, %bounded_c)
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
      bindings ["x", "y", "z"](%x, %y, %z)
      : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 32>,
         !wave.simd<i32, 32>, !wave.simd<i32, 32>)
      -> (!wave.simd<vector<1xi8>, 32>, !wave.mem.token)
  return %value : !wave.simd<vector<1xi8>, 32>
}

// -----

// CHECK-LABEL: func.func @simd_base_byte_address(
// CHECK: [[BASE:%.*]] = wave.ptr_add %arg0, %arg1
// CHECK-SAME: -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
// CHECK: [[BYTE:%.*]] = wave.ptr_cast [[BASE]]
// CHECK-SAME: -> !wave.simd<!wave.ptr<#wave.global, i8>, 32>
// CHECK: [[OFFSET:%.*]] = wave.constant 1
// CHECK: [[PTR:%.*]] = wave.ptr_add [[BYTE]], [[OFFSET]]
// CHECK-SAME: -> !wave.simd<!wave.ptr<#wave.global, i8>, 32>
// CHECK: wave.load [[PTR]]
// CHECK-NOT: wave.gather
func.func @simd_base_byte_address(
    %base: !wave.ptr<#wave.global, i32>, %offset: !wave.simd<i32, 32>)
    -> !wave.simd<vector<2xi32>, 32> {
  %simd_base = wave.ptr_add %base, %offset
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %value, %token = wave.gather %simd_base mapping
      <bit_offset = <"8 + 32*slot">>
      bindings []()
      : (!wave.simd<!wave.ptr<#wave.global, i32>, 32>)
      -> (!wave.simd<vector<2xi32>, 32>, !wave.mem.token)
  return %value : !wave.simd<vector<2xi32>, 32>
}

// -----

// CHECK-LABEL: func.func @packet_predicated_scatter
// CHECK: [[BYTE:%.*]] = wave.ptr_cast
// CHECK-COUNT-1: [[OFFSET:%.*]] = wave.index_expr <"4*item"
// CHECK: [[COMMON:%.*]] = wave.ptr_add [[BYTE]], [[OFFSET]]
// CHECK-NOT: wave.index_expr <"4*item"
// CHECK: {{.*}} = wave.where
// CHECK-NOT: wave.index_expr
// CHECK: wave.store {{.*}} -> [[COMMON]]
// CHECK: [[DELTA:%.*]] = wave.constant 4 : index
// CHECK: [[NEXT:%.*]] = wave.ptr_add [[COMMON]], [[DELTA]]
// CHECK: {{.*}} = wave.where
// CHECK-NOT: wave.index_expr
// CHECK: wave.store {{.*}} -> [[NEXT]]
// CHECK-NOT: wave.index_expr <"4*item"
// CHECK-NOT: wave.scatter
func.func @packet_predicated_scatter(
    %value: !wave.simd<vector<2xi32>, 32>,
    %base: !wave.ptr<#wave.global, i32>, %limit_raw: i32)
    attributes {wave.workgroup_size = array<i32: 32, 1, 1>} {
  %item = wave.workitem_id 0 : !wave.simd<i32, 32>
  %one = wave.constant 1 : i32 -> !wave.simd<i32, 32>
  %zero = wave.constant 0 : i32 -> !wave.simd<i32, 32>
  %next = wave.binary addi %item, %one overflow<nsw>
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %limit = wave.splat %limit_raw : i32 -> !wave.simd<i32, 32>
  %active0 = wave.cmpi slt %item, %limit
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %active1 = wave.cmpi slt %next, %limit
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  wave.where %active0, %active1 {
    %local_item = wave.binary addi %item, %zero overflow<nsw>
        : !wave.simd<i32, 32>, !wave.simd<i32, 32>
        -> !wave.simd<i32, 32>
    %stored = wave.scatter %value to %base mapping
        <bit_offset = <"32*(item + slot)">>
        bindings ["item"](%local_item)
        : (!wave.simd<vector<2xi32>, 32>, !wave.ptr<#wave.global, i32>,
           !wave.simd<i32, 32>) -> !wave.mem.token
    wave.yield
  } : !wave.mask<32>, !wave.mask<32>
  return
}

// -----

// A retained outer guard must not hide the canonical boolean carrier in its
// active predicate. The two packet conditions are equivalent, so they form
// one contiguous vector transaction.
// CHECK-LABEL: func.func @guarded_boolean_carrier_scatter
// CHECK-NOT: wave.scatter
// CHECK-COUNT-1: wave.where
// CHECK-COUNT-1: wave.store
// CHECK-SAME: !wave.simd<vector<2xi32>, 32>
// CHECK-NOT: wave.store
// CHECK-NOT: wave.join
// CHECK-NOT: wave.scatter
func.func @guarded_boolean_carrier_scatter(
    %value: !wave.simd<vector<2xi32>, 32>,
    %base: !wave.ptr<#wave.global, i32>,
    %outer_limit_raw: i32)
    attributes {wave.workgroup_size = array<i32: 32, 1, 1>} {
  %item = wave.workitem_id 0 : !wave.simd<i32, 32>
  %bounded_item = wave.assume %item as "item"
      [#wave.pred<"item >= 0">, #wave.pred<"item <= 31">]
      : !wave.simd<i32, 32>
  %outer_limit = wave.splat %outer_limit_raw
      : i32 -> !wave.simd<i32, 32>
  %zero = wave.constant 0 : i32 -> !wave.simd<i32, 32>
  %one = wave.constant 1 : i32 -> !wave.simd<i32, 32>
  %limit = wave.constant 128 : i32 -> !wave.simd<i32, 32>
  %next = wave.binary addi %bounded_item, %one overflow<nsw>
      : !wave.simd<i32, 32>, !wave.simd<i32, 32>
      -> !wave.simd<i32, 32>
  %outer = wave.cmpi slt %bounded_item, %outer_limit
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %inner0 = wave.cmpi slt %bounded_item, %limit
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %inner1 = wave.cmpi slt %next, %limit
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %false = wave.constant false -> !wave.mask<32>
  %encoded0 = wave.select %inner0, %one, %zero
      : !wave.mask<32>, !wave.simd<i32, 32>
  %encoded1 = wave.select %inner1, %one, %zero
      : !wave.mask<32>, !wave.simd<i32, 32>
  %decoded0 = wave.cmpi ne %encoded0, %zero
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %decoded1 = wave.cmpi ne %encoded1, %zero
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %active0 = wave.select %outer, %decoded0, %false
      : !wave.mask<32>, !wave.mask<32>
  %active1 = wave.select %outer, %decoded1, %false
      : !wave.mask<32>, !wave.mask<32>
  wave.where %active0, %active1 {
    %stored = wave.scatter %value to %base mapping
        <bit_offset = <"32*(2*item + slot)">>
        bindings ["item"](%bounded_item)
        : (!wave.simd<vector<2xi32>, 32>, !wave.ptr<#wave.global, i32>,
           !wave.simd<i32, 32>) -> !wave.mem.token
    wave.yield
  } : !wave.mask<32>, !wave.mask<32>
  return
}

// -----

// A general mask conjunction cannot use the retained-guard shortcut when the
// inner predicate is not implied by the outer one. Decode the whole predicate
// so equivalent conjunctions still form one vector transaction.
// CHECK-LABEL: func.func @equivalent_mask_conjunction_scatter
// CHECK-NOT: wave.scatter
// CHECK: [[PACK:%.*]] = wave.pack
// CHECK-COUNT-1: wave.where
// CHECK-COUNT-1: wave.store [[PACK]]
// CHECK-SAME: !wave.simd<vector<2xi32>, 32>
// CHECK-NOT: wave.store
// CHECK-NOT: wave.scatter
func.func @equivalent_mask_conjunction_scatter(
    %value: !wave.simd<vector<2xi32>, 32>,
    %base: !wave.ptr<#wave.global, i32>,
    %outer_limit_raw: i32, %inner_limit_raw: i32)
    attributes {wave.workgroup_size = array<i32: 32, 1, 1>} {
  %item = wave.workitem_id 0 : !wave.simd<i32, 32>
  %outer_limit = wave.splat %outer_limit_raw
      : i32 -> !wave.simd<i32, 32>
  %inner_limit = wave.splat %inner_limit_raw
      : i32 -> !wave.simd<i32, 32>
  %outer = wave.cmpi slt %item, %outer_limit
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %inner = wave.cmpi slt %item, %inner_limit
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %false = wave.constant false -> !wave.mask<32>
  %active0 = wave.select %outer, %inner, %false
      : !wave.mask<32>, !wave.mask<32>
  %active1 = wave.select %outer, %inner, %false
      : !wave.mask<32>, !wave.mask<32>
  wave.where %active0, %active1 {
    %stored = wave.scatter %value to %base mapping
        <bit_offset = <"32*(2*item + slot)">>
        bindings ["item"](%item)
        : (!wave.simd<vector<2xi32>, 32>, !wave.ptr<#wave.global, i32>,
           !wave.simd<i32, 32>) -> !wave.mem.token
    wave.yield
  } : !wave.mask<32>, !wave.mask<32>
  return
}

// -----

// The retained root guard proves the active signed divisions' nonzero-divisor
// domain; the nonnegative dividends exclude INT_MIN / -1. Both active
// comparisons are true, so the two conditions reduce to that same guard and
// preserve one vector transaction.
// CHECK-LABEL: func.func @guarded_division_domain_scatter
// CHECK-NOT: wave.scatter
// CHECK-COUNT-1: wave.where
// CHECK-COUNT-1: wave.store
// CHECK-SAME: !wave.simd<vector<2xi32>, 32>
// CHECK-NOT: wave.store
// CHECK-NOT: wave.join
// CHECK-NOT: wave.scatter
func.func @guarded_division_domain_scatter(
    %value: !wave.simd<vector<2xi32>, 32>,
    %base: !wave.ptr<#wave.global, i32>, %divisor_raw: i32)
    attributes {wave.workgroup_size = array<i32: 32, 1, 1>} {
  %item = wave.workitem_id 0 : !wave.simd<i32, 32>
  %bounded_item = wave.assume %item as "item"
      [#wave.pred<"item >= 0">, #wave.pred<"item <= 31">]
      : !wave.simd<i32, 32>
  %zero = wave.constant 0 : i32 -> !wave.simd<i32, 32>
  %one = wave.constant 1 : i32 -> !wave.simd<i32, 32>
  %limit = wave.constant 128 : i32 -> !wave.simd<i32, 32>
  %divisor = wave.splat %divisor_raw : i32 -> !wave.simd<i32, 32>
  %next = wave.binary addi %bounded_item, %one overflow<nsw>
      : !wave.simd<i32, 32>, !wave.simd<i32, 32>
      -> !wave.simd<i32, 32>
  %outer = wave.cmpi ne %divisor, %zero
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %div0 = wave.binary divsi %bounded_item, %divisor
      : !wave.simd<i32, 32>, !wave.simd<i32, 32>
      -> !wave.simd<i32, 32>
  %div1 = wave.binary divsi %next, %divisor
      : !wave.simd<i32, 32>, !wave.simd<i32, 32>
      -> !wave.simd<i32, 32>
  %bounded_div0 = wave.assume %div0 as "q"
      [#wave.pred<"q >= 0">, #wave.pred<"q <= 127">]
      : !wave.simd<i32, 32>
  %bounded_div1 = wave.assume %div1 as "q"
      [#wave.pred<"q >= 0">, #wave.pred<"q <= 127">]
      : !wave.simd<i32, 32>
  %inner0 = wave.cmpi slt %bounded_div0, %limit
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %inner1 = wave.cmpi slt %bounded_div1, %limit
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %false = wave.constant false -> !wave.mask<32>
  %active0 = wave.select %outer, %inner0, %false
      : !wave.mask<32>, !wave.mask<32>
  %active1 = wave.select %outer, %inner1, %false
      : !wave.mask<32>, !wave.mask<32>
  wave.where %active0, %active1 {
    %stored = wave.scatter %value to %base mapping
        <bit_offset = <"32*(2*item + slot)">>
        bindings ["item"](%bounded_item)
        : (!wave.simd<vector<2xi32>, 32>, !wave.ptr<#wave.global, i32>,
           !wave.simd<i32, 32>) -> !wave.mem.token
    wave.yield
  } : !wave.mask<32>, !wave.mask<32>
  return
}

// -----

// The retained root guard proves the active unsigned remainders' nonzero-
// divisor domain. Both result contracts make the active comparisons true, so
// the two conditions reduce to that same guard and remain one transaction.
// CHECK-LABEL: func.func @guarded_remainder_domain_scatter
// CHECK-NOT: wave.scatter
// CHECK-COUNT-1: wave.where
// CHECK-COUNT-1: wave.store
// CHECK-SAME: !wave.simd<vector<2xi32>, 32>
// CHECK-NOT: wave.store
// CHECK-NOT: wave.join
// CHECK-NOT: wave.scatter
func.func @guarded_remainder_domain_scatter(
    %value: !wave.simd<vector<2xi32>, 32>,
    %base: !wave.ptr<#wave.global, i32>, %divisor_raw: i32)
    attributes {wave.workgroup_size = array<i32: 32, 1, 1>} {
  %item = wave.workitem_id 0 : !wave.simd<i32, 32>
  %bounded_item = wave.assume %item as "item"
      [#wave.pred<"item >= 0">, #wave.pred<"item <= 31">]
      : !wave.simd<i32, 32>
  %zero = wave.constant 0 : i32 -> !wave.simd<i32, 32>
  %one = wave.constant 1 : i32 -> !wave.simd<i32, 32>
  %limit = wave.constant 128 : i32 -> !wave.simd<i32, 32>
  %divisor = wave.splat %divisor_raw : i32 -> !wave.simd<i32, 32>
  %next = wave.binary addi %bounded_item, %one overflow<nsw>
      : !wave.simd<i32, 32>, !wave.simd<i32, 32>
      -> !wave.simd<i32, 32>
  %outer = wave.cmpi ne %divisor, %zero
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %rem0 = wave.binary remui %bounded_item, %divisor
      : !wave.simd<i32, 32>, !wave.simd<i32, 32>
      -> !wave.simd<i32, 32>
  %rem1 = wave.binary remui %next, %divisor
      : !wave.simd<i32, 32>, !wave.simd<i32, 32>
      -> !wave.simd<i32, 32>
  %bounded_rem0 = wave.assume %rem0 as "r"
      [#wave.pred<"r >= 0">, #wave.pred<"r <= 127">]
      : !wave.simd<i32, 32>
  %bounded_rem1 = wave.assume %rem1 as "r"
      [#wave.pred<"r >= 0">, #wave.pred<"r <= 127">]
      : !wave.simd<i32, 32>
  %inner0 = wave.cmpi slt %bounded_rem0, %limit
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %inner1 = wave.cmpi slt %bounded_rem1, %limit
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %false = wave.constant false -> !wave.mask<32>
  %active0 = wave.select %outer, %inner0, %false
      : !wave.mask<32>, !wave.mask<32>
  %active1 = wave.select %outer, %inner1, %false
      : !wave.mask<32>, !wave.mask<32>
  wave.where %active0, %active1 {
    %stored = wave.scatter %value to %base mapping
        <bit_offset = <"32*(2*item + slot)">>
        bindings ["item"](%bounded_item)
        : (!wave.simd<vector<2xi32>, 32>, !wave.ptr<#wave.global, i32>,
           !wave.simd<i32, 32>) -> !wave.mem.token
    wave.yield
  } : !wave.mask<32>, !wave.mask<32>
  return
}

// -----

// An Assume result owns its range contract. A sibling comparison of the raw
// quotient cannot borrow that contract merely because both conditions retain
// the same nonzero-divisor guard.
// CHECK-LABEL: func.func @assume_facts_do_not_cross_sibling_conditions
// CHECK-NOT: wave.scatter
// CHECK: wave.where
// CHECK: wave.store
// CHECK-SAME: (!wave.simd<i32, 32>,
// CHECK: wave.where
// CHECK: wave.store
// CHECK-SAME: (!wave.simd<i32, 32>,
// CHECK: wave.join
// CHECK-NOT: wave.store
// CHECK-NOT: wave.scatter
func.func @assume_facts_do_not_cross_sibling_conditions(
    %value: !wave.simd<vector<2xi32>, 32>,
    %base: !wave.ptr<#wave.global, i32>,
    %dividend_raw: i32, %divisor_raw: i32)
    attributes {wave.workgroup_size = array<i32: 32, 1, 1>} {
  %item = wave.workitem_id 0 : !wave.simd<i32, 32>
  %bounded_item = wave.assume %item as "item"
      [#wave.pred<"item >= 0">, #wave.pred<"item <= 31">]
      : !wave.simd<i32, 32>
  %zero = wave.constant 0 : i32 -> !wave.simd<i32, 32>
  %limit = wave.constant 128 : i32 -> !wave.simd<i32, 32>
  %dividend = wave.splat %dividend_raw : i32 -> !wave.simd<i32, 32>
  %divisor = wave.splat %divisor_raw : i32 -> !wave.simd<i32, 32>
  %outer = wave.cmpi ne %divisor, %zero
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %quotient = wave.binary divui %dividend, %divisor
      : !wave.simd<i32, 32>, !wave.simd<i32, 32>
      -> !wave.simd<i32, 32>
  %bounded_quotient = wave.assume %quotient as "q"
      [#wave.pred<"q >= 0">, #wave.pred<"q <= 127">]
      : !wave.simd<i32, 32>
  %inner0 = wave.cmpi slt %bounded_quotient, %limit
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %inner1 = wave.cmpi slt %quotient, %limit
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %false = wave.constant false -> !wave.mask<32>
  %active0 = wave.select %outer, %inner0, %false
      : !wave.mask<32>, !wave.mask<32>
  %active1 = wave.select %outer, %inner1, %false
      : !wave.mask<32>, !wave.mask<32>
  wave.where %active0, %active1 {
    %stored = wave.scatter %value to %base mapping
        <bit_offset = <"32*(2*item + slot)">>
        bindings ["item"](%bounded_item)
        : (!wave.simd<vector<2xi32>, 32>, !wave.ptr<#wave.global, i32>,
           !wave.simd<i32, 32>) -> !wave.mem.token
    wave.yield
  } : !wave.mask<32>, !wave.mask<32>
  return
}

// -----

// Reversing the packet slots must not change SSA fact ownership. Visiting the
// raw quotient condition before its Assume-derived sibling still leaves both
// conditions as separate scalar transactions.
// CHECK-LABEL: func.func @assume_facts_do_not_cross_sibling_conditions_reversed
// CHECK-NOT: wave.scatter
// CHECK: wave.where
// CHECK: wave.store
// CHECK-SAME: (!wave.simd<i32, 32>,
// CHECK: wave.where
// CHECK: wave.store
// CHECK-SAME: (!wave.simd<i32, 32>,
// CHECK: wave.join
// CHECK-NOT: wave.store
// CHECK-NOT: wave.scatter
func.func @assume_facts_do_not_cross_sibling_conditions_reversed(
    %value: !wave.simd<vector<2xi32>, 32>,
    %base: !wave.ptr<#wave.global, i32>,
    %dividend_raw: i32, %divisor_raw: i32)
    attributes {wave.workgroup_size = array<i32: 32, 1, 1>} {
  %item = wave.workitem_id 0 : !wave.simd<i32, 32>
  %bounded_item = wave.assume %item as "item"
      [#wave.pred<"item >= 0">, #wave.pred<"item <= 31">]
      : !wave.simd<i32, 32>
  %zero = wave.constant 0 : i32 -> !wave.simd<i32, 32>
  %limit = wave.constant 128 : i32 -> !wave.simd<i32, 32>
  %dividend = wave.splat %dividend_raw : i32 -> !wave.simd<i32, 32>
  %divisor = wave.splat %divisor_raw : i32 -> !wave.simd<i32, 32>
  %outer = wave.cmpi ne %divisor, %zero
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %quotient = wave.binary divui %dividend, %divisor
      : !wave.simd<i32, 32>, !wave.simd<i32, 32>
      -> !wave.simd<i32, 32>
  %bounded_quotient = wave.assume %quotient as "q"
      [#wave.pred<"q >= 0">, #wave.pred<"q <= 127">]
      : !wave.simd<i32, 32>
  %inner0 = wave.cmpi slt %quotient, %limit
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %inner1 = wave.cmpi slt %bounded_quotient, %limit
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %false = wave.constant false -> !wave.mask<32>
  %active0 = wave.select %outer, %inner0, %false
      : !wave.mask<32>, !wave.mask<32>
  %active1 = wave.select %outer, %inner1, %false
      : !wave.mask<32>, !wave.mask<32>
  wave.where %active0, %active1 {
    %stored = wave.scatter %value to %base mapping
        <bit_offset = <"32*(2*item + slot)">>
        bindings ["item"](%bounded_item)
        : (!wave.simd<vector<2xi32>, 32>, !wave.ptr<#wave.global, i32>,
           !wave.simd<i32, 32>) -> !wave.mem.token
    wave.yield
  } : !wave.mask<32>, !wave.mask<32>
  return
}

// -----

// A nonzero contract follows the Assume result through splat into each divui
// producer. Both quotient-result contracts then reduce the conditions to true,
// so the adjacent slots form one vector transaction without a retained guard.
// CHECK-LABEL: func.func @assume_facts_follow_forward_ssa_lineage
// CHECK-NOT: wave.scatter
// CHECK-NOT: wave.where
// CHECK-COUNT-1: wave.store
// CHECK-SAME: !wave.simd<vector<2xi32>, 32>
// CHECK-NOT: wave.store
// CHECK-NOT: wave.join
// CHECK-NOT: wave.scatter
func.func @assume_facts_follow_forward_ssa_lineage(
    %value: !wave.simd<vector<2xi32>, 32>,
    %base: !wave.ptr<#wave.global, i32>, %divisor_raw: i32)
    attributes {wave.workgroup_size = array<i32: 32, 1, 1>} {
  %item = wave.workitem_id 0 : !wave.simd<i32, 32>
  %bounded_item = wave.assume %item as "item"
      [#wave.pred<"item >= 0">, #wave.pred<"item <= 31">]
      : !wave.simd<i32, 32>
  %one = wave.constant 1 : i32 -> !wave.simd<i32, 32>
  %limit = wave.constant 128 : i32 -> !wave.simd<i32, 32>
  %bounded_divisor = wave.assume %divisor_raw as "d"
      [#wave.pred<"d != 0">] : i32
  %divisor = wave.splat %bounded_divisor : i32 -> !wave.simd<i32, 32>
  %next = wave.binary addi %bounded_item, %one overflow<nsw>
      : !wave.simd<i32, 32>, !wave.simd<i32, 32>
      -> !wave.simd<i32, 32>
  %div0 = wave.binary divui %bounded_item, %divisor
      : !wave.simd<i32, 32>, !wave.simd<i32, 32>
      -> !wave.simd<i32, 32>
  %div1 = wave.binary divui %next, %divisor
      : !wave.simd<i32, 32>, !wave.simd<i32, 32>
      -> !wave.simd<i32, 32>
  %bounded_div0 = wave.assume %div0 as "q"
      [#wave.pred<"q >= 0">, #wave.pred<"q <= 127">]
      : !wave.simd<i32, 32>
  %bounded_div1 = wave.assume %div1 as "q"
      [#wave.pred<"q >= 0">, #wave.pred<"q <= 127">]
      : !wave.simd<i32, 32>
  %active0 = wave.cmpi slt %bounded_div0, %limit
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %active1 = wave.cmpi slt %bounded_div1, %limit
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  wave.where %active0, %active1 {
    %stored = wave.scatter %value to %base mapping
        <bit_offset = <"32*(2*item + slot)">>
        bindings ["item"](%bounded_item)
        : (!wave.simd<vector<2xi32>, 32>, !wave.ptr<#wave.global, i32>,
           !wave.simd<i32, 32>) -> !wave.mem.token
    wave.yield
  } : !wave.mask<32>, !wave.mask<32>
  return
}

// -----

// Traversal order is not SSA order. A later Assume still cannot donate facts
// to an earlier division, but a zero divisor is poison and does not block the
// refinement that combines the two slots.
// CHECK-LABEL: func.func @later_assume_cannot_validate_earlier_division
// CHECK-NOT: wave.scatter
// CHECK: wave.where
// CHECK: wave.store
// CHECK-SAME: (!wave.simd<vector<2xi32>, 32>,
// CHECK-NOT: wave.store
// CHECK-NOT: wave.scatter
func.func @later_assume_cannot_validate_earlier_division(
    %value: !wave.simd<vector<2xi32>, 32>,
    %base: !wave.ptr<#wave.global, i32>, %lhs_raw: i32, %rhs_raw: i32,
    %divisor_raw: i32)
    attributes {wave.workgroup_size = array<i32: 32, 1, 1>} {
  %item = wave.workitem_id 0 : !wave.simd<i32, 32>
  %bounded_item = wave.assume %item as "item"
      [#wave.pred<"item >= 0">, #wave.pred<"item <= 31">]
      : !wave.simd<i32, 32>
  %c16 = wave.constant 16 : i32 -> !wave.simd<i32, 32>
  %limit = wave.constant 128 : i32 -> !wave.simd<i32, 32>
  %lhs = wave.splat %lhs_raw : i32 -> !wave.simd<i32, 32>
  %rhs = wave.splat %rhs_raw : i32 -> !wave.simd<i32, 32>
  %divisor = wave.splat %divisor_raw : i32 -> !wave.simd<i32, 32>
  %div0 = wave.binary divui %lhs, %divisor
      : !wave.simd<i32, 32>, !wave.simd<i32, 32>
      -> !wave.simd<i32, 32>
  %div1 = wave.binary divui %rhs, %divisor
      : !wave.simd<i32, 32>, !wave.simd<i32, 32>
      -> !wave.simd<i32, 32>
  %bounded_divisor = wave.assume %divisor_raw as "d"
      [#wave.pred<"d != 0">] : i32
  %late_divisor = wave.splat %bounded_divisor
      : i32 -> !wave.simd<i32, 32>
  %mix0 = wave.binary addi %late_divisor, %div0
      : !wave.simd<i32, 32>, !wave.simd<i32, 32>
      -> !wave.simd<i32, 32>
  %mix1 = wave.binary addi %late_divisor, %div1
      : !wave.simd<i32, 32>, !wave.simd<i32, 32>
      -> !wave.simd<i32, 32>
  %bounded_mix0 = wave.assume %mix0 as "m"
      [#wave.pred<"m >= 0">, #wave.pred<"m <= 127">]
      : !wave.simd<i32, 32>
  %bounded_mix1 = wave.assume %mix1 as "m"
      [#wave.pred<"m >= 0">, #wave.pred<"m <= 127">]
      : !wave.simd<i32, 32>
  %outer = wave.cmpi slt %bounded_item, %c16
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %inner0 = wave.cmpi slt %bounded_mix0, %limit
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %inner1 = wave.cmpi slt %bounded_mix1, %limit
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %false = wave.constant false -> !wave.mask<32>
  %active0 = wave.select %outer, %inner0, %false
      : !wave.mask<32>, !wave.mask<32>
  %active1 = wave.select %outer, %inner1, %false
      : !wave.mask<32>, !wave.mask<32>
  wave.where %active0, %active1 {
    %stored = wave.scatter %value to %base mapping
        <bit_offset = <"32*(2*item + slot)">>
        bindings ["item"](%bounded_item)
        : (!wave.simd<vector<2xi32>, 32>, !wave.ptr<#wave.global, i32>,
           !wave.simd<i32, 32>) -> !wave.mem.token
    wave.yield
  } : !wave.mask<32>, !wave.mask<32>
  return
}

// -----

// Operand order is not fact ownership. Building the earlier partial producer
// before the later Assume-derived operand reaches the same refined transaction
// as the mirrored expression above.
// CHECK-LABEL: func.func @later_assume_cannot_validate_earlier_division_reversed
// CHECK-NOT: wave.scatter
// CHECK: wave.where
// CHECK: wave.store
// CHECK-SAME: (!wave.simd<vector<2xi32>, 32>,
// CHECK-NOT: wave.store
// CHECK-NOT: wave.scatter
func.func @later_assume_cannot_validate_earlier_division_reversed(
    %value: !wave.simd<vector<2xi32>, 32>,
    %base: !wave.ptr<#wave.global, i32>, %lhs_raw: i32, %rhs_raw: i32,
    %divisor_raw: i32)
    attributes {wave.workgroup_size = array<i32: 32, 1, 1>} {
  %item = wave.workitem_id 0 : !wave.simd<i32, 32>
  %bounded_item = wave.assume %item as "item"
      [#wave.pred<"item >= 0">, #wave.pred<"item <= 31">]
      : !wave.simd<i32, 32>
  %c16 = wave.constant 16 : i32 -> !wave.simd<i32, 32>
  %limit = wave.constant 128 : i32 -> !wave.simd<i32, 32>
  %lhs = wave.splat %lhs_raw : i32 -> !wave.simd<i32, 32>
  %rhs = wave.splat %rhs_raw : i32 -> !wave.simd<i32, 32>
  %divisor = wave.splat %divisor_raw : i32 -> !wave.simd<i32, 32>
  %div0 = wave.binary divui %lhs, %divisor
      : !wave.simd<i32, 32>, !wave.simd<i32, 32>
      -> !wave.simd<i32, 32>
  %div1 = wave.binary divui %rhs, %divisor
      : !wave.simd<i32, 32>, !wave.simd<i32, 32>
      -> !wave.simd<i32, 32>
  %bounded_divisor = wave.assume %divisor_raw as "d"
      [#wave.pred<"d != 0">] : i32
  %late_divisor = wave.splat %bounded_divisor
      : i32 -> !wave.simd<i32, 32>
  %mix0 = wave.binary addi %div0, %late_divisor
      : !wave.simd<i32, 32>, !wave.simd<i32, 32>
      -> !wave.simd<i32, 32>
  %mix1 = wave.binary addi %div1, %late_divisor
      : !wave.simd<i32, 32>, !wave.simd<i32, 32>
      -> !wave.simd<i32, 32>
  %bounded_mix0 = wave.assume %mix0 as "m"
      [#wave.pred<"m >= 0">, #wave.pred<"m <= 127">]
      : !wave.simd<i32, 32>
  %bounded_mix1 = wave.assume %mix1 as "m"
      [#wave.pred<"m >= 0">, #wave.pred<"m <= 127">]
      : !wave.simd<i32, 32>
  %outer = wave.cmpi slt %bounded_item, %c16
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %inner0 = wave.cmpi slt %bounded_mix0, %limit
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %inner1 = wave.cmpi slt %bounded_mix1, %limit
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %false = wave.constant false -> !wave.mask<32>
  %active0 = wave.select %outer, %inner0, %false
      : !wave.mask<32>, !wave.mask<32>
  %active1 = wave.select %outer, %inner1, %false
      : !wave.mask<32>, !wave.mask<32>
  wave.where %active0, %active1 {
    %stored = wave.scatter %value to %base mapping
        <bit_offset = <"32*(2*item + slot)">>
        bindings ["item"](%bounded_item)
        : (!wave.simd<vector<2xi32>, 32>, !wave.ptr<#wave.global, i32>,
           !wave.simd<i32, 32>) -> !wave.mem.token
    wave.yield
  } : !wave.mask<32>, !wave.mask<32>
  return
}

// -----

// ReadFirst preserves facts only from its own source chain. A later Assume does
// not rewrite the earlier division, while poison refinement still permits the
// combined transaction.
// CHECK-LABEL: func.func @read_first_before_late_assume_cannot_validate_division
// CHECK-NOT: wave.scatter
// CHECK: wave.where
// CHECK: wave.store
// CHECK-SAME: (!wave.simd<vector<2xi32>, 32>,
// CHECK-NOT: wave.store
// CHECK-NOT: wave.scatter
func.func @read_first_before_late_assume_cannot_validate_division(
    %value: !wave.simd<vector<2xi32>, 32>,
    %base: !wave.ptr<#wave.global, i32>, %lhs_raw: i32, %rhs_raw: i32,
    %divisor_raw: !wave.simd<i32, 32>)
    attributes {wave.workgroup_size = array<i32: 32, 1, 1>} {
  %item = wave.workitem_id 0 : !wave.simd<i32, 32>
  %bounded_item = wave.assume %item as "item"
      [#wave.pred<"item >= 0">, #wave.pred<"item <= 31">]
      : !wave.simd<i32, 32>
  %c16 = wave.constant 16 : i32 -> !wave.simd<i32, 32>
  %limit = wave.constant 128 : i32 -> !wave.simd<i32, 32>
  %lhs = wave.splat %lhs_raw : i32 -> !wave.simd<i32, 32>
  %rhs = wave.splat %rhs_raw : i32 -> !wave.simd<i32, 32>
  %first = wave.read_first %divisor_raw : !wave.simd<i32, 32> -> i32
  %divisor = wave.splat %first : i32 -> !wave.simd<i32, 32>
  %div0 = wave.binary divui %lhs, %divisor
      : !wave.simd<i32, 32>, !wave.simd<i32, 32>
      -> !wave.simd<i32, 32>
  %div1 = wave.binary divui %rhs, %divisor
      : !wave.simd<i32, 32>, !wave.simd<i32, 32>
      -> !wave.simd<i32, 32>
  %bounded_divisor = wave.assume %divisor_raw as "d"
      [#wave.pred<"d != 0">] : !wave.simd<i32, 32>
  %late_first = wave.read_first %bounded_divisor
      : !wave.simd<i32, 32> -> i32
  %late_divisor = wave.splat %late_first : i32 -> !wave.simd<i32, 32>
  %mix0 = wave.binary addi %late_divisor, %div0
      : !wave.simd<i32, 32>, !wave.simd<i32, 32>
      -> !wave.simd<i32, 32>
  %mix1 = wave.binary addi %late_divisor, %div1
      : !wave.simd<i32, 32>, !wave.simd<i32, 32>
      -> !wave.simd<i32, 32>
  %bounded_mix0 = wave.assume %mix0 as "m"
      [#wave.pred<"m >= 0">, #wave.pred<"m <= 127">]
      : !wave.simd<i32, 32>
  %bounded_mix1 = wave.assume %mix1 as "m"
      [#wave.pred<"m >= 0">, #wave.pred<"m <= 127">]
      : !wave.simd<i32, 32>
  %outer = wave.cmpi slt %bounded_item, %c16
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %inner0 = wave.cmpi slt %bounded_mix0, %limit
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %inner1 = wave.cmpi slt %bounded_mix1, %limit
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %false = wave.constant false -> !wave.mask<32>
  %active0 = wave.select %outer, %inner0, %false
      : !wave.mask<32>, !wave.mask<32>
  %active1 = wave.select %outer, %inner1, %false
      : !wave.mask<32>, !wave.mask<32>
  wave.where %active0, %active1 {
    %stored = wave.scatter %value to %base mapping
        <bit_offset = <"32*(2*item + slot)">>
        bindings ["item"](%bounded_item)
        : (!wave.simd<vector<2xi32>, 32>, !wave.ptr<#wave.global, i32>,
           !wave.simd<i32, 32>) -> !wave.mem.token
    wave.yield
  } : !wave.mask<32>, !wave.mask<32>
  return
}

// -----

// Two independent retained guards each prove only their own division domain.
// Their otherwise-true predicates cannot be identified, so adjacent packet
// slots remain two scalar transactions.
// CHECK-LABEL: func.func @distinct_retained_guards_stay_separate
// CHECK-NOT: wave.scatter
// CHECK: wave.where
// CHECK: wave.store
// CHECK-SAME: (!wave.simd<i32, 32>,
// CHECK: wave.where
// CHECK: wave.store
// CHECK-SAME: (!wave.simd<i32, 32>,
// CHECK: wave.join
// CHECK-NOT: wave.store
// CHECK-NOT: wave.scatter
func.func @distinct_retained_guards_stay_separate(
    %value: !wave.simd<vector<2xi32>, 32>,
    %base: !wave.ptr<#wave.global, i32>,
    %divisor0_raw: i32, %divisor1_raw: i32)
    attributes {wave.workgroup_size = array<i32: 32, 1, 1>} {
  %item = wave.workitem_id 0 : !wave.simd<i32, 32>
  %bounded_item = wave.assume %item as "item"
      [#wave.pred<"item >= 0">, #wave.pred<"item <= 31">]
      : !wave.simd<i32, 32>
  %zero = wave.constant 0 : i32 -> !wave.simd<i32, 32>
  %one = wave.constant 1 : i32 -> !wave.simd<i32, 32>
  %limit = wave.constant 128 : i32 -> !wave.simd<i32, 32>
  %next = wave.binary addi %bounded_item, %one overflow<nsw>
      : !wave.simd<i32, 32>, !wave.simd<i32, 32>
      -> !wave.simd<i32, 32>
  %divisor0 = wave.splat %divisor0_raw : i32 -> !wave.simd<i32, 32>
  %divisor1 = wave.splat %divisor1_raw : i32 -> !wave.simd<i32, 32>
  %guard0 = wave.cmpi ne %divisor0, %zero
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %guard1 = wave.cmpi ne %divisor1, %zero
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %div0 = wave.binary divui %bounded_item, %divisor0
      : !wave.simd<i32, 32>, !wave.simd<i32, 32>
      -> !wave.simd<i32, 32>
  %div1 = wave.binary divui %next, %divisor1
      : !wave.simd<i32, 32>, !wave.simd<i32, 32>
      -> !wave.simd<i32, 32>
  %bounded_div0 = wave.assume %div0 as "q"
      [#wave.pred<"q >= 0">, #wave.pred<"q <= 127">]
      : !wave.simd<i32, 32>
  %bounded_div1 = wave.assume %div1 as "q"
      [#wave.pred<"q >= 0">, #wave.pred<"q <= 127">]
      : !wave.simd<i32, 32>
  %inner0 = wave.cmpi slt %bounded_div0, %limit
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %inner1 = wave.cmpi slt %bounded_div1, %limit
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %false = wave.constant false -> !wave.mask<32>
  %active0 = wave.select %guard0, %inner0, %false
      : !wave.mask<32>, !wave.mask<32>
  %active1 = wave.select %guard1, %inner1, %false
      : !wave.mask<32>, !wave.mask<32>
  wave.where %active0, %active1 {
    %stored = wave.scatter %value to %base mapping
        <bit_offset = <"32*(2*item + slot)">>
        bindings ["item"](%bounded_item)
        : (!wave.simd<vector<2xi32>, 32>, !wave.ptr<#wave.global, i32>,
           !wave.simd<i32, 32>) -> !wave.mem.token
    wave.yield
  } : !wave.mask<32>, !wave.mask<32>
  return
}

// -----

// The same partial producer is safe under the divisor guard and unsafe under
// an unrelated guard. Building the safe use first must not cache that proof
// for the second retained Select root.
// CHECK-LABEL: func.func @shared_partial_producer_guard_a_then_b
// CHECK-NOT: wave.scatter
// CHECK: wave.where
// CHECK: wave.store
// CHECK-SAME: (!wave.simd<i32, 32>,
// CHECK: wave.where
// CHECK: wave.store
// CHECK-SAME: (!wave.simd<i32, 32>,
// CHECK: wave.join
// CHECK-NOT: wave.store
// CHECK-NOT: wave.scatter
func.func @shared_partial_producer_guard_a_then_b(
    %value: !wave.simd<vector<2xi32>, 32>,
    %base: !wave.ptr<#wave.global, i32>,
    %dividend_raw: i32, %divisor_raw: i32, %guard_limit_raw: i32)
    attributes {wave.workgroup_size = array<i32: 32, 1, 1>} {
  %item = wave.workitem_id 0 : !wave.simd<i32, 32>
  %bounded_item = wave.assume %item as "item"
      [#wave.pred<"item >= 0">, #wave.pred<"item <= 31">]
      : !wave.simd<i32, 32>
  %zero = wave.constant 0 : i32 -> !wave.simd<i32, 32>
  %limit = wave.constant 128 : i32 -> !wave.simd<i32, 32>
  %dividend = wave.splat %dividend_raw : i32 -> !wave.simd<i32, 32>
  %divisor = wave.splat %divisor_raw : i32 -> !wave.simd<i32, 32>
  %guard_limit = wave.splat %guard_limit_raw : i32 -> !wave.simd<i32, 32>
  %guard_a = wave.cmpi ne %divisor, %zero
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %guard_b = wave.cmpi slt %bounded_item, %guard_limit
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %quotient = wave.binary divui %dividend, %divisor
      : !wave.simd<i32, 32>, !wave.simd<i32, 32>
      -> !wave.simd<i32, 32>
  %bounded_quotient = wave.assume %quotient as "q"
      [#wave.pred<"q >= 0">, #wave.pred<"q <= 127">]
      : !wave.simd<i32, 32>
  %inner0 = wave.cmpi slt %bounded_quotient, %limit
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %inner1 = wave.cmpi slt %bounded_quotient, %limit
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %false = wave.constant false -> !wave.mask<32>
  %active_a = wave.select %guard_a, %inner0, %false
      : !wave.mask<32>, !wave.mask<32>
  %active_b = wave.select %guard_b, %inner1, %false
      : !wave.mask<32>, !wave.mask<32>
  wave.where %active_a, %active_b {
    %stored = wave.scatter %value to %base mapping
        <bit_offset = <"32*(2*item + slot)">>
        bindings ["item"](%bounded_item)
        : (!wave.simd<vector<2xi32>, 32>, !wave.ptr<#wave.global, i32>,
           !wave.simd<i32, 32>) -> !wave.mem.token
    wave.yield
  } : !wave.mask<32>, !wave.mask<32>
  return
}

// -----

// Reversing the packet slots must not let the unrelated guard seed or reuse a
// proof for the same partial producer. The two uses remain separate.
// CHECK-LABEL: func.func @shared_partial_producer_guard_b_then_a
// CHECK-NOT: wave.scatter
// CHECK: wave.where
// CHECK: wave.store
// CHECK-SAME: (!wave.simd<i32, 32>,
// CHECK: wave.where
// CHECK: wave.store
// CHECK-SAME: (!wave.simd<i32, 32>,
// CHECK: wave.join
// CHECK-NOT: wave.store
// CHECK-NOT: wave.scatter
func.func @shared_partial_producer_guard_b_then_a(
    %value: !wave.simd<vector<2xi32>, 32>,
    %base: !wave.ptr<#wave.global, i32>,
    %dividend_raw: i32, %divisor_raw: i32, %guard_limit_raw: i32)
    attributes {wave.workgroup_size = array<i32: 32, 1, 1>} {
  %item = wave.workitem_id 0 : !wave.simd<i32, 32>
  %bounded_item = wave.assume %item as "item"
      [#wave.pred<"item >= 0">, #wave.pred<"item <= 31">]
      : !wave.simd<i32, 32>
  %zero = wave.constant 0 : i32 -> !wave.simd<i32, 32>
  %limit = wave.constant 128 : i32 -> !wave.simd<i32, 32>
  %dividend = wave.splat %dividend_raw : i32 -> !wave.simd<i32, 32>
  %divisor = wave.splat %divisor_raw : i32 -> !wave.simd<i32, 32>
  %guard_limit = wave.splat %guard_limit_raw : i32 -> !wave.simd<i32, 32>
  %guard_a = wave.cmpi ne %divisor, %zero
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %guard_b = wave.cmpi slt %bounded_item, %guard_limit
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %quotient = wave.binary divui %dividend, %divisor
      : !wave.simd<i32, 32>, !wave.simd<i32, 32>
      -> !wave.simd<i32, 32>
  %bounded_quotient = wave.assume %quotient as "q"
      [#wave.pred<"q >= 0">, #wave.pred<"q <= 127">]
      : !wave.simd<i32, 32>
  %inner0 = wave.cmpi slt %bounded_quotient, %limit
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %inner1 = wave.cmpi slt %bounded_quotient, %limit
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %false = wave.constant false -> !wave.mask<32>
  %active_b = wave.select %guard_b, %inner0, %false
      : !wave.mask<32>, !wave.mask<32>
  %active_a = wave.select %guard_a, %inner1, %false
      : !wave.mask<32>, !wave.mask<32>
  wave.where %active_b, %active_a {
    %stored = wave.scatter %value to %base mapping
        <bit_offset = <"32*(2*item + slot)">>
        bindings ["item"](%bounded_item)
        : (!wave.simd<vector<2xi32>, 32>, !wave.ptr<#wave.global, i32>,
           !wave.simd<i32, 32>) -> !wave.mem.token
    wave.yield
  } : !wave.mask<32>, !wave.mask<32>
  return
}

// -----

// A retained root guard may also complete a dynamic shift domain. The global
// lower bound and guarded upper bound together prove [0, 32), allowing both
// active comparisons to reduce to the common guard.
// CHECK-LABEL: func.func @guarded_shift_domain_scatter
// CHECK-NOT: wave.scatter
// CHECK-COUNT-1: wave.where
// CHECK-COUNT-1: wave.store
// CHECK-SAME: !wave.simd<vector<2xi32>, 32>
// CHECK-NOT: wave.store
// CHECK-NOT: wave.join
// CHECK-NOT: wave.scatter
func.func @guarded_shift_domain_scatter(
    %value: !wave.simd<vector<2xi32>, 32>,
    %base: !wave.ptr<#wave.global, i32>, %amount_raw: i32)
    attributes {wave.workgroup_size = array<i32: 32, 1, 1>} {
  %item = wave.workitem_id 0 : !wave.simd<i32, 32>
  %bounded_item = wave.assume %item as "item"
      [#wave.pred<"item >= 0">, #wave.pred<"item <= 31">]
      : !wave.simd<i32, 32>
  %nonnegative_amount = wave.assume %amount_raw as "amount"
      [#wave.pred<"amount >= 0">] : i32
  %amount = wave.splat %nonnegative_amount : i32 -> !wave.simd<i32, 32>
  %one = wave.constant 1 : i32 -> !wave.simd<i32, 32>
  %c32 = wave.constant 32 : i32 -> !wave.simd<i32, 32>
  %limit = wave.constant 128 : i32 -> !wave.simd<i32, 32>
  %next = wave.binary addi %bounded_item, %one overflow<nsw>
      : !wave.simd<i32, 32>, !wave.simd<i32, 32>
      -> !wave.simd<i32, 32>
  %outer = wave.cmpi slt %amount, %c32
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %shifted0 = wave.binary shli %bounded_item, %amount
      : !wave.simd<i32, 32>, !wave.simd<i32, 32>
      -> !wave.simd<i32, 32>
  %shifted1 = wave.binary shli %next, %amount
      : !wave.simd<i32, 32>, !wave.simd<i32, 32>
      -> !wave.simd<i32, 32>
  %bounded_shifted0 = wave.assume %shifted0 as "shifted"
      [#wave.pred<"shifted >= 0">, #wave.pred<"shifted <= 127">]
      : !wave.simd<i32, 32>
  %bounded_shifted1 = wave.assume %shifted1 as "shifted"
      [#wave.pred<"shifted >= 0">, #wave.pred<"shifted <= 127">]
      : !wave.simd<i32, 32>
  %inner0 = wave.cmpi slt %bounded_shifted0, %limit
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %inner1 = wave.cmpi slt %bounded_shifted1, %limit
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %false = wave.constant false -> !wave.mask<32>
  %active0 = wave.select %outer, %inner0, %false
      : !wave.mask<32>, !wave.mask<32>
  %active1 = wave.select %outer, %inner1, %false
      : !wave.mask<32>, !wave.mask<32>
  wave.where %active0, %active1 {
    %stored = wave.scatter %value to %base mapping
        <bit_offset = <"32*(2*item + slot)">>
        bindings ["item"](%bounded_item)
        : (!wave.simd<vector<2xi32>, 32>, !wave.ptr<#wave.global, i32>,
           !wave.simd<i32, 32>) -> !wave.mem.token
    wave.yield
  } : !wave.mask<32>, !wave.mask<32>
  return
}

// -----

// Binding-local address stays under its defining control region.
// CHECK-LABEL: func.func @where_local_address_stays_scoped
// CHECK-NOT: wave.ptr_add
// CHECK: wave.where
// CHECK: [[LOCAL:%.*]] = arith.addi
// CHECK: [[OFFSET:%.*]] = wave.index_expr
// CHECK: [[POINTER:%.*]] = wave.ptr_add {{.*}}, [[OFFSET]]
// CHECK: wave.store {{.*}} -> [[POINTER]]
// CHECK-NOT: wave.scatter
func.func @where_local_address_stays_scoped(
    %value: !wave.simd<vector<2xi32>, 32>,
    %base: !wave.ptr<#wave.global, i32>, %origin: index,
    %active: !wave.mask<32>) {
  wave.where %active {
    %one = arith.constant 1 : index
    %local = arith.addi %origin, %one : index
    %stored = wave.scatter %value to %base mapping
        <bit_offset = <"32*(local + slot)">>
        bindings ["local"](%local)
        : (!wave.simd<vector<2xi32>, 32>, !wave.ptr<#wave.global, i32>, index)
        -> !wave.mem.token
    wave.yield
  } : !wave.mask<32>
  return
}
