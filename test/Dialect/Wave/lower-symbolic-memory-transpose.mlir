// RUN: wave-opt --wave-generate-index-exprs --wave-lower-symbolic-memory \
// RUN:   --split-input-file %s | FileCheck %s

// The gfx950 B8 tile is one direct expression over item and slot.
// CHECK-LABEL: func.func @gfx950_b8_direct_transpose(
// CHECK-NOT: wave.load
// CHECK: waveamd.transpose_load
// CHECK-SAME: !wave.simd<vector<8xi8>, 64>
// CHECK-NOT: waveamd.transpose_load
// CHECK-NOT: wave.gather
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
  func.func @gfx950_b8_direct_transpose(
      %base: !wave.ptr<#wave.shared, i8>)
      -> !wave.simd<vector<8xi8>, 64>
      attributes {wave.workgroup_size = array<i32: 64, 1, 1>} {
    %item = wave.workitem_id 0 : !wave.simd<i32, 64>
    %bounded_item = wave.assume %item as "item"
        [#wave.pred<"item >= 0">, #wave.pred<"item <= 63">]
        : !wave.simd<i32, 64>
    %value, %token = wave.gather %base mapping
        <bit_offset = <"8 * (128 * floor(item / 16) + Mod(item, 16) + 16 * slot)">>
        bindings ["item"](%bounded_item)
        : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>)
        -> (!wave.simd<vector<8xi8>, 64>, !wave.mem.token)
    return %value : !wave.simd<vector<8xi8>, 64>
  }
}

// -----

// MXFP scale gathers use the other legal gfx950 B8 permutation. The hardware
// layout candidate is tried first and rejected by the complete relation; the
// bit-affine candidate then proves the production-shaped map.
// CHECK-LABEL: func.func @gfx950_b8_bit_affine_transpose(
// CHECK-NOT: wave.load
// CHECK: waveamd.transpose_load
// CHECK-SAME: !wave.simd<vector<8xi8>, 64>
// CHECK-NOT: waveamd.transpose_load
// CHECK-NOT: wave.gather
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
  func.func @gfx950_b8_bit_affine_transpose(
      %base: !wave.ptr<#wave.shared, i8>)
      -> !wave.simd<vector<8xi8>, 64>
      attributes {wave.workgroup_size = array<i32: 64, 1, 1>} {
    %item = wave.workitem_id 0 : !wave.simd<i32, 64>
    %bounded_item = wave.assume %item as "item"
        [#wave.pred<"item >= 0">, #wave.pred<"item <= 63">]
        : !wave.simd<i32, 64>
    %value, %token = wave.gather %base mapping
        <bit_offset = <"8 * (1024 * floor(item / 128) + 128 * floor(Mod(item, 64) / 16) + floor(slot / 2) + 4 * Mod(item, 16))">>
        bindings ["item"](%bounded_item)
        : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>)
        -> (!wave.simd<vector<8xi8>, 64>, !wave.mem.token)
    return %value : !wave.simd<vector<8xi8>, 64>
  }
}

// -----

// Facts on the bound SSA chain prove a uniform origin without any packet tuple.
// CHECK-LABEL: func.func @gfx950_b8_fact_transpose(
// CHECK-NOT: wave.load
// CHECK: wave.index_expr
// CHECK-SAME: #wave.pred<"Mod(origin, 4) == 0">
// CHECK: waveamd.transpose_load
// CHECK-NOT: wave.gather
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
  func.func @gfx950_b8_fact_transpose(
      %base: !wave.ptr<#wave.shared, i8>, %origin_raw: index)
      -> !wave.simd<vector<8xi8>, 64>
      attributes {wave.workgroup_size = array<i32: 64, 1, 1>} {
    %origin = wave.assume %origin_raw as "origin"
        [#wave.pred<"Mod(origin, 4) == 0">] : index
    %item = wave.workitem_id 0 : !wave.simd<i32, 64>
    %bounded_item = wave.assume %item as "item"
        [#wave.pred<"item >= 0">, #wave.pred<"item <= 63">]
        : !wave.simd<i32, 64>
    %value, %token = wave.gather %base mapping
        <bit_offset = <"8 * (origin + 128 * floor(item / 16) + Mod(item, 16) + 16 * slot + Mod(origin * item, 4))">>
        bindings ["origin", "item"](%origin, %bounded_item)
        : (!wave.ptr<#wave.shared, i8>, index, !wave.simd<i32, 64>)
        -> (!wave.simd<vector<8xi8>, 64>, !wave.mem.token)
    return %value : !wave.simd<vector<8xi8>, 64>
  }
}

// -----

// The B16 tile is proved directly. Canonical byte materialization casts the
// typed base to i8 for pointer arithmetic, then back for the target operation.
// CHECK-LABEL: func.func @gfx950_b16_direct_transpose(
// CHECK-NOT: wave.load
// CHECK: [[BYTES:%.*]] = wave.ptr_cast %arg0 : !wave.ptr<#wave.shared, f16> -> !wave.ptr<#wave.shared, i8>
// CHECK: [[BYTE_PTR:%.*]] = wave.ptr_add [[BYTES]],
// CHECK: wave.ptr_cast [[BYTE_PTR]] : !wave.simd<!wave.ptr<#wave.shared, i8>, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
// CHECK: waveamd.transpose_load
// CHECK-SAME: !wave.simd<vector<4xf16>, 64>
// CHECK-NOT: wave.gather
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
  func.func @gfx950_b16_direct_transpose(
      %base: !wave.ptr<#wave.shared, f16>)
      -> !wave.simd<vector<4xf16>, 64>
      attributes {wave.workgroup_size = array<i32: 64, 1, 1>} {
    %item = wave.workitem_id 0 : !wave.simd<i32, 64>
    %bounded_item = wave.assume %item as "item"
        [#wave.pred<"item >= 0">, #wave.pred<"item <= 63">]
        : !wave.simd<i32, 64>
    %value, %token = wave.gather %base mapping
        <bit_offset = <"16 * (8 * (item - Mod(item, 64) + 16 * floor(Mod(item, 64) / 16) + floor(Mod(item, 16) / 4) + 4 * slot) + Mod(item, 4))">>
        bindings ["item"](%bounded_item)
        : (!wave.ptr<#wave.shared, f16>, !wave.simd<i32, 64>)
        -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
    return %value : !wave.simd<vector<4xf16>, 64>
  }
}

// -----

// Two complete B16 transactions share the same direct layout family.
// CHECK-LABEL: func.func @gfx950_b16_wide_transpose(
// CHECK-NOT: wave.load
// CHECK: %{{.*}}, [[TOKEN0:%.*]] = waveamd.transpose_load
// CHECK: %{{.*}}, [[TOKEN1:%.*]] = waveamd.transpose_load
// CHECK-NOT: waveamd.transpose_load
// CHECK: wave.pack
// CHECK-NEXT: wave.join [[TOKEN0]], [[TOKEN1]]
// CHECK-NOT: wave.gather
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
  func.func @gfx950_b16_wide_transpose(
      %base: !wave.ptr<#wave.shared, f16>)
      -> !wave.simd<vector<8xf16>, 64>
      attributes {wave.workgroup_size = array<i32: 320, 1, 1>} {
    %item = wave.workitem_id 0 : !wave.simd<i32, 64>
    %bounded_item = wave.assume %item as "item"
        [#wave.pred<"item >= 0">, #wave.pred<"item <= 319">]
        : !wave.simd<i32, 64>
    %value, %token = wave.gather %base mapping
        <bit_offset = <"16 * (8 * (item - Mod(item, 64) + 16 * floor(Mod(item, 64) / 16) + floor(Mod(item, 16) / 4) + 4 * slot) + Mod(item, 4))">>
        bindings ["item"](%bounded_item)
        : (!wave.ptr<#wave.shared, f16>, !wave.simd<i32, 64>)
        -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
    return %value : !wave.simd<vector<8xf16>, 64>
  }
}

// -----

// A canonical distributed-to-swizzled local-memory relation need not contain
// the transpose load's supplied address as one of its packet points. The
// provider derives and verifies both four-slot addresses from the relation.
// CHECK-LABEL: func.func @gfx950_b16_swizzled_layout_transpose(
// CHECK-NOT: wave.load
// CHECK-COUNT-2: waveamd.transpose_load
// CHECK-NOT: waveamd.transpose_load
// CHECK-NOT: wave.gather
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
  func.func @gfx950_b16_swizzled_layout_transpose(
      %base: !wave.ptr<#wave.shared, f16>)
      -> !wave.simd<vector<8xf16>, 64>
      attributes {wave.workgroup_size = array<i32: 256, 1, 1>} {
    %item = wave.workitem_id 0 : !wave.simd<i32, 64>
    %bounded_item = wave.assume %item as "item"
        [#wave.pred<"item >= 0">, #wave.pred<"item <= 255">]
        : !wave.simd<i32, 64>
    %value, %token = wave.gather %base mapping
        <bit_offset = <"16*xor(2*Mod(floor(item/2),2),4*Mod(floor(item/4),2),8*xor(Mod(slot,2),Mod(floor(item/8),2)),16*xor(Mod(floor(item/64),2),Mod(floor(slot/2),2)),32*xor(Mod(floor(slot/16),2),Mod(floor(slot/4),2)),64*xor(Mod(floor(slot/32),2),Mod(floor(item/16),2)),128*Mod(slot,2),256*Mod(floor(slot/2),2),512*Mod(floor(slot/4),2),1024*Mod(floor(item/16),2),2048*Mod(floor(item/32),2),4096*Mod(floor(slot/8),2),Mod(item,2))">>
        bindings ["item"](%bounded_item)
        : (!wave.ptr<#wave.shared, f16>, !wave.simd<i32, 64>)
        -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
    return %value : !wave.simd<vector<8xf16>, 64>
  }
}

// -----

// The generic prover handles the XOR layout algebra without a second layout
// representation or a sampled inverse.
// CHECK-LABEL: func.func @gfx950_b16_xor_transpose(
// CHECK-NOT: wave.load
// CHECK: wave.ptr_cast %arg0 : !wave.ptr<#wave.shared, f16> -> !wave.ptr<#wave.shared, i8>
// CHECK: wave.index_expr
// CHECK: waveamd.transpose_load
// CHECK-NOT: wave.gather
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
  func.func @gfx950_b16_xor_transpose(
      %base: !wave.ptr<#wave.shared, f16>)
      -> !wave.simd<vector<4xf16>, 64>
      attributes {wave.workgroup_size = array<i32: 64, 1, 1>} {
    %item = wave.workitem_id 0 : !wave.simd<i32, 64>
    %bounded_item = wave.assume %item as "item"
        [#wave.pred<"item >= 0">, #wave.pred<"item <= 63">]
        : !wave.simd<i32, 64>
    %value, %token = wave.gather %base mapping
        <bit_offset = <"16 * (xor(item - Mod(item, 64) + 16 * floor(Mod(item, 64) / 16) + floor(Mod(item, 16) / 4) + 4 * slot, floor((item - Mod(item, 64) + 16 * floor(Mod(item, 64) / 16) + floor(Mod(item, 16) / 4) + 4 * slot) / 2)) + Mod(item, 4))">>
        bindings ["item"](%bounded_item)
        : (!wave.ptr<#wave.shared, f16>, !wave.simd<i32, 64>)
        -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
    return %value : !wave.simd<vector<4xf16>, 64>
  }
}

// -----

// Group zero matches the B8 tile, but group one has an extra within-dependent
// term. The whole-domain target proof must fail; no partial subset is emitted.
// CHECK-LABEL: func.func @gfx950_b8_full_domain_mismatch_falls_back(
// CHECK-NOT: waveamd.transpose_load
// CHECK-COUNT-16: wave.load
// CHECK-NOT: waveamd.transpose_load
// CHECK-NOT: wave.gather
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
  func.func @gfx950_b8_full_domain_mismatch_falls_back(
      %base: !wave.ptr<#wave.shared, i8>)
      -> !wave.simd<vector<16xi8>, 64>
      attributes {wave.workgroup_size = array<i32: 64, 1, 1>} {
    %item = wave.workitem_id 0 : !wave.simd<i32, 64>
    %bounded_item = wave.assume %item as "item"
        [#wave.pred<"item >= 0">, #wave.pred<"item <= 63">]
        : !wave.simd<i32, 64>
    %value, %token = wave.gather %base mapping
        <bit_offset = <"8 * (128 * floor(item / 16) + Mod(item, 16) + 16 * Mod(slot, 8) + 1024 * floor(slot / 8) + 512 * item * floor(slot / 8))">>
        bindings ["item"](%bounded_item)
        : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>)
        -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
    return %value : !wave.simd<vector<16xi8>, 64>
  }
}

// -----

// A different low-bit relation is ordinary memory, not a transpose special
// case. At item=1, slot=0 the bit-affine candidate predicts A(0,0)+32b, while
// this map requires 40b. The complete proof rejects that candidate; its exact
// two-slot output fibers share four scalar loads.
// CHECK-LABEL: func.func @gfx950_b8_strided_layout_falls_back(
// CHECK-NOT: waveamd.transpose_load
// CHECK-COUNT-4: wave.load
// CHECK-COUNT-1: wave.pack
// CHECK-NOT: waveamd.transpose_load
// CHECK-NOT: wave.gather
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
  func.func @gfx950_b8_strided_layout_falls_back(
      %base: !wave.ptr<#wave.shared, i8>)
      -> !wave.simd<vector<8xi8>, 64>
      attributes {wave.workgroup_size = array<i32: 64, 1, 1>} {
    %item = wave.workitem_id 0 : !wave.simd<i32, 64>
    %bounded_item = wave.assume %item as "item"
        [#wave.pred<"item >= 0">, #wave.pred<"item <= 63">]
        : !wave.simd<i32, 64>
    %value, %token = wave.gather %base mapping
        <bit_offset = <"8 * (256 * floor(Mod(item, 64) / 16) + 16 * floor(Mod(item, 16) / 2) + 5 * Mod(item, 2) + floor(slot / 2))">>
        bindings ["item"](%bounded_item)
        : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>)
        -> (!wave.simd<vector<8xi8>, 64>, !wave.mem.token)
    return %value : !wave.simd<vector<8xi8>, 64>
  }
}

// -----

// Wrong B16 lane stride fails the same full-domain target query.
// CHECK-LABEL: func.func @wrong_b16_relation(
// CHECK-NOT: waveamd.transpose_load
// CHECK-COUNT-4: wave.load
// CHECK: wave.pack
// CHECK-NOT: waveamd.transpose_load
// CHECK-NOT: wave.gather
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
  func.func @wrong_b16_relation(
      %base: !wave.ptr<#wave.shared, f16>)
      -> !wave.simd<vector<4xf16>, 64>
      attributes {wave.workgroup_size = array<i32: 64, 1, 1>} {
    %item = wave.workitem_id 0 : !wave.simd<i32, 64>
    %bounded_item = wave.assume %item as "item"
        [#wave.pred<"item >= 0">, #wave.pred<"item <= 63">]
        : !wave.simd<i32, 64>
    %value, %token = wave.gather %base mapping
        <bit_offset = <"16 * (8 * (item - Mod(item, 64) + 16 * floor(Mod(item, 64) / 16) + floor(Mod(item, 16) / 4) + 4 * slot) + 2 * Mod(item, 4))">>
        bindings ["item"](%bounded_item)
        : (!wave.ptr<#wave.shared, f16>, !wave.simd<i32, 64>)
        -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
    return %value : !wave.simd<vector<4xf16>, 64>
  }
}

// -----

// The target provider declines on gfx942; the same direct map lowers normally.
// CHECK-LABEL: func.func @unsupported_target(
// CHECK-NOT: waveamd.transpose_load
// CHECK-COUNT-8: wave.load
// CHECK-NOT: wave.gather
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx942"} {
  func.func @unsupported_target(%base: !wave.ptr<#wave.shared, i8>)
      -> !wave.simd<vector<8xi8>, 64>
      attributes {wave.workgroup_size = array<i32: 64, 1, 1>} {
    %item = wave.workitem_id 0 : !wave.simd<i32, 64>
    %bounded_item = wave.assume %item as "item"
        [#wave.pred<"item >= 0">, #wave.pred<"item <= 63">]
        : !wave.simd<i32, 64>
    %value, %token = wave.gather %base mapping
        <bit_offset = <"8 * (128 * floor(item / 16) + Mod(item, 16) + 16 * slot)">>
        bindings ["item"](%bounded_item)
        : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>)
        -> (!wave.simd<vector<8xi8>, 64>, !wave.mem.token)
    return %value : !wave.simd<vector<8xi8>, 64>
  }
}

// -----

// A partial hardware row is not closed under the target supplier section and
// remains ordinary.
// CHECK-LABEL: func.func @partial_hardware_row(
// CHECK-NOT: waveamd.transpose_load
// CHECK-COUNT-8: wave.load
// CHECK: wave.pack
// CHECK-NOT: waveamd.transpose_load
// CHECK-NOT: wave.gather
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
  func.func @partial_hardware_row(%base: !wave.ptr<#wave.shared, i8>)
      -> !wave.simd<vector<8xi8>, 64>
      attributes {wave.workgroup_size = array<i32: 8, 1, 1>} {
    %item = wave.workitem_id 0 : !wave.simd<i32, 64>
    %bounded_item = wave.assume %item as "item"
        [#wave.pred<"item >= 0">, #wave.pred<"item <= 7">]
        : !wave.simd<i32, 64>
    %value, %token = wave.gather %base mapping
        <bit_offset = <"8 * (128 * floor(item / 16) + Mod(item, 16) + 16 * slot)">>
        bindings ["item"](%bounded_item)
        : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>)
        -> (!wave.simd<vector<8xi8>, 64>, !wave.mem.token)
    return %value : !wave.simd<vector<8xi8>, 64>
  }
}
