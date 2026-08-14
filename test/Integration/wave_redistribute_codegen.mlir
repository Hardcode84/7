// RUN: wave-translate --wave-to-amdgpu-asm %s | FileCheck %s --check-prefix=ASM
// RUN: wave-translate --wave-to-amdgpu-asm %s \
// RUN:   | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx1100 -filetype=obj -o /dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// ASM-LABEL: redistribute_same_wave:
// ASM: ds_bpermute_b32
// ASM-NOT: s_barrier
// ASM: buffer_store_b32
func.func @redistribute_same_wave(%dst: !wave.ptr<#wave.global, i32>)
    attributes {wave.kernel,
                wave.workgroup_size = array<i32: 64, 1, 1>,
                wave.waves_per_workgroup = 2 : i64} {
  %item = wave.workitem_id 0 : !wave.simd<i32, 32>
  %bounded_item = wave.assume %item as "x"
      [#wave.pred<"x >= 0">, #wave.pred<"x <= 63">]
      : !wave.simd<i32, 32>
  %source = wave.pack %item, %item
      : !wave.simd<i32, 32>, !wave.simd<i32, 32>
      -> !wave.simd<vector<2xi32>, 32>
  %moved = wave.redistribute %source,
      <blocks = 2, items = 64, source_block = "block", source_item = "xor(item, 1)", source_slot = "slot">
      : !wave.simd<vector<2xi32>, 32> -> !wave.simd<vector<2xi32>, 32>
  %value = wave.extract %moved[0]
      : !wave.simd<vector<2xi32>, 32> -> !wave.simd<i32, 32>
  %ptr = wave.ptr_add %dst, %bounded_item
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %token = wave.store %value -> %ptr
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.global, i32>, 32>)
      -> !wave.mem.token
  return
}

// ASM-LABEL: redistribute_same_wave_scalar:
// ASM: ds_bpermute_b32
// ASM-NOT: s_barrier
// ASM: buffer_store_b32
func.func @redistribute_same_wave_scalar(
    %dst: !wave.ptr<#wave.global, i32>)
    attributes {wave.kernel,
                wave.workgroup_size = array<i32: 64, 1, 1>,
                wave.waves_per_workgroup = 2 : i64} {
  %item = wave.workitem_id 0 : !wave.simd<i32, 32>
  %bounded_item = wave.assume %item as "x"
      [#wave.pred<"x >= 0">, #wave.pred<"x <= 63">]
      : !wave.simd<i32, 32>
  %moved = wave.redistribute %item,
      <blocks = 1, items = 64, source_block = "block", source_item = "xor(item, 1)", source_slot = "slot">
      : !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %ptr = wave.ptr_add %dst, %bounded_item
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %token = wave.store %moved -> %ptr
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.global, i32>, 32>)
      -> !wave.mem.token
  return
}

// ASM-LABEL: redistribute_pointer_load_store:
// ASM: ds_bpermute_b32
// ASM: {{buffer|global}}_load_b32
// ASM: s_waitcnt vmcnt(0)
// ASM: {{buffer|global}}_store_b32
func.func @redistribute_pointer_load_store(
    %src: !wave.ptr<#wave.global, i32>,
    %dst: !wave.ptr<#wave.global, i32>)
    attributes {wave.kernel,
                wave.workgroup_size = array<i32: 32, 1, 1>,
                wave.waves_per_workgroup = 1 : i64} {
  %item = wave.workitem_id 0 : !wave.simd<i32, 32>
  %bounded_item = wave.assume %item as "x"
      [#wave.pred<"x >= 0">, #wave.pred<"x <= 31">]
      : !wave.simd<i32, 32>
  %src_ptr = wave.ptr_add %src, %bounded_item
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %moved = wave.redistribute %src_ptr,
      <blocks = 1, items = 32, source_block = "block",
       source_item = "xor(item, 1)", source_slot = "slot">
      : !wave.simd<!wave.ptr<#wave.global, i32>, 32>
        -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %packet, %read = wave.gather %moved mapping
      <bit_offset = <"0">>
      bindings []()
      : (!wave.simd<!wave.ptr<#wave.global, i32>, 32>)
      -> (!wave.simd<vector<1xi32>, 32>, !wave.mem.token)
  %value = wave.extract %packet[0]
      : !wave.simd<vector<1xi32>, 32> -> !wave.simd<i32, 32>
  %dst_ptr = wave.ptr_add %dst, %bounded_item
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %stored = wave.store %value -> %dst_ptr after %read
      : (!wave.simd<i32, 32>,
         !wave.simd<!wave.ptr<#wave.global, i32>, 32>, !wave.mem.token)
      -> !wave.mem.token
  return
}

// ASM-LABEL: redistribute_same_wave_packet_select:
// ASM-COUNT-8: ds_bpermute_b32
// ASM-COUNT-4: v_cndmask_b32
// ASM-NOT: s_barrier
// ASM-NOT: ds_store
// ASM: buffer_store_b32
func.func @redistribute_same_wave_packet_select(
    %dst: !wave.ptr<#wave.global, i32>)
    attributes {wave.kernel,
                wave.workgroup_size = array<i32: 64, 1, 1>,
                wave.waves_per_workgroup = 2 : i64} {
  %item = wave.workitem_id 0 : !wave.simd<i32, 32>
  %bounded_item = wave.assume %item as "x"
      [#wave.pred<"x >= 0">, #wave.pred<"x <= 63">]
      : !wave.simd<i32, 32>
  %one = wave.constant 1 : i32 -> !wave.simd<i32, 32>
  %v1 = wave.binary addi %item, %one
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %v2 = wave.binary addi %v1, %one
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %v3 = wave.binary addi %v2, %one
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %v4 = wave.binary addi %v3, %one
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %v5 = wave.binary addi %v4, %one
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %v6 = wave.binary addi %v5, %one
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %v7 = wave.binary addi %v6, %one
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %source = wave.pack %item, %v1, %v2, %v3, %v4, %v5, %v6, %v7
      : !wave.simd<i32, 32>, !wave.simd<i32, 32>,
        !wave.simd<i32, 32>, !wave.simd<i32, 32>,
        !wave.simd<i32, 32>, !wave.simd<i32, 32>,
        !wave.simd<i32, 32>, !wave.simd<i32, 32>
      -> !wave.simd<vector<8xi32>, 32>
  %moved = wave.redistribute %source,
      <blocks = 1, items = 64, source_block = "block",
       source_item = "xor(item, 1)",
       source_slot = "4*Mod(item, 2) + slot">
      : !wave.simd<vector<8xi32>, 32> -> !wave.simd<vector<4xi32>, 32>
  %value = wave.extract %moved[0]
      : !wave.simd<vector<4xi32>, 32> -> !wave.simd<i32, 32>
  %ptr = wave.ptr_add %dst, %bounded_item
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %token = wave.store %value -> %ptr
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.global, i32>, 32>)
      -> !wave.mem.token
  return
}

// ASM-LABEL: redistribute_cross_wave:
// ASM: ds_store_b64
// ASM: s_barrier
// ASM: ds_load_b64
// ASM-NOT: s_barrier
// ASM: buffer_store_b32
// ASM: .amdhsa_group_segment_fixed_size 512
func.func @redistribute_cross_wave(%dst: !wave.ptr<#wave.global, i32>)
    attributes {wave.kernel,
                wave.workgroup_size = array<i32: 64, 1, 1>,
                wave.waves_per_workgroup = 2 : i64} {
  %item = wave.workitem_id 0 : !wave.simd<i32, 32>
  %bounded_item = wave.assume %item as "x"
      [#wave.pred<"x >= 0">, #wave.pred<"x <= 63">]
      : !wave.simd<i32, 32>
  %one = wave.constant 1 : i32 -> !wave.simd<i32, 32>
  %next = wave.binary addi %item, %one
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %source = wave.pack %item, %next
      : !wave.simd<i32, 32>, !wave.simd<i32, 32>
      -> !wave.simd<vector<2xi32>, 32>
  %moved = wave.redistribute %source,
      <blocks = 1, items = 64, source_block = "block", source_item = "xor(item, 32)", source_slot = "slot">
      : !wave.simd<vector<2xi32>, 32> -> !wave.simd<vector<2xi32>, 32>
  %value = wave.extract %moved[0]
      : !wave.simd<vector<2xi32>, 32> -> !wave.simd<i32, 32>
  %ptr = wave.ptr_add %dst, %bounded_item
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %token = wave.store %value -> %ptr
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.global, i32>, 32>)
      -> !wave.mem.token
  return
}

// ASM-LABEL: redistribute_cross_wave_scalar:
// ASM: ds_store_b32
// ASM: s_barrier
// ASM: ds_load_b32
// ASM-NOT: s_barrier
// ASM: buffer_store_b32
// ASM: .amdhsa_group_segment_fixed_size 256
func.func @redistribute_cross_wave_scalar(
    %dst: !wave.ptr<#wave.global, i32>)
    attributes {wave.kernel,
                wave.workgroup_size = array<i32: 64, 1, 1>,
                wave.waves_per_workgroup = 2 : i64} {
  %item = wave.workitem_id 0 : !wave.simd<i32, 32>
  %bounded_item = wave.assume %item as "x"
      [#wave.pred<"x >= 0">, #wave.pred<"x <= 63">]
      : !wave.simd<i32, 32>
  %moved = wave.redistribute %item,
      <blocks = 1, items = 64, source_block = "block", source_item = "xor(item, 32)", source_slot = "slot">
      : !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %ptr = wave.ptr_add %dst, %bounded_item
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %token = wave.store %moved -> %ptr
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.global, i32>, 32>)
      -> !wave.mem.token
  return
}

// ASM-LABEL: redistribute_cross_wave_swizzled:
// ASM-DAG: ds_store_b64
// ASM-DAG: ds_store_b64
// ASM-DAG: v_xor_b32_e32 {{.*}}, 8,
// ASM: s_barrier
// ASM: ds_load_b64
// ASM-NOT: s_barrier
// ASM: buffer_store_b32
// ASM: .amdhsa_group_segment_fixed_size 1024
func.func @redistribute_cross_wave_swizzled(
    %dst: !wave.ptr<#wave.global, i32>)
    attributes {wave.kernel,
                wave.workgroup_size = array<i32: 64, 1, 1>,
                wave.waves_per_workgroup = 2 : i64} {
  %item = wave.workitem_id 0 : !wave.simd<i32, 32>
  %bounded_item = wave.assume %item as "x"
      [#wave.pred<"x >= 0">, #wave.pred<"x <= 63">]
      : !wave.simd<i32, 32>
  %one = wave.constant 1 : i32 -> !wave.simd<i32, 32>
  %next = wave.binary addi %item, %one
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %third = wave.binary addi %next, %one
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %fourth = wave.binary addi %third, %one
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %source = wave.pack %item, %next, %third, %fourth
      : !wave.simd<i32, 32>, !wave.simd<i32, 32>,
        !wave.simd<i32, 32>, !wave.simd<i32, 32>
      -> !wave.simd<vector<4xi32>, 32>
  %moved = wave.redistribute %source,
      <blocks = 1, items = 64, source_block = "block",
       source_item = "xor(floor(item / 2), 32)",
       source_slot = "2*Mod(item, 2) + slot">
      : !wave.simd<vector<4xi32>, 32> -> !wave.simd<vector<2xi32>, 32>
  %value = wave.extract %moved[0]
      : !wave.simd<vector<2xi32>, 32> -> !wave.simd<i32, 32>
  %ptr = wave.ptr_add %dst, %bounded_item
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %token = wave.store %value -> %ptr
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.global, i32>, 32>)
      -> !wave.mem.token
  return
}

// ASM-LABEL: redistribute_cross_wave_nested:
// ASM: s_cbranch_scc0
// ASM: ds_store
// ASM: s_barrier
// ASM: ds_load
// ASM-NOT: s_barrier
// ASM: buffer_store_b32
// ASM: .amdhsa_group_segment_fixed_size 256
func.func @redistribute_cross_wave_nested(
    %dst: !wave.ptr<#wave.global, i32>, %condition: i1)
    attributes {wave.kernel,
                wave.workgroup_size = array<i32: 64, 1, 1>,
                wave.waves_per_workgroup = 2 : i64} {
  %item = wave.workitem_id 0 : !wave.simd<i32, 32>
  %bounded_item = wave.assume %item as "x"
      [#wave.pred<"x >= 0">, #wave.pred<"x <= 63">]
      : !wave.simd<i32, 32>
  %source = wave.pack %item
      : !wave.simd<i32, 32> -> !wave.simd<vector<1xi32>, 32>
  scf.if %condition {
    %moved = wave.redistribute %source,
        <blocks = 1, items = 64, source_block = "block", source_item = "xor(item, 32)", source_slot = "slot">
        : !wave.simd<vector<1xi32>, 32> -> !wave.simd<vector<1xi32>, 32>
    %value = wave.extract %moved[0]
        : !wave.simd<vector<1xi32>, 32> -> !wave.simd<i32, 32>
    %ptr = wave.ptr_add %dst, %bounded_item
        : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32>
        -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
    %token = wave.store %value -> %ptr
        : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.global, i32>, 32>)
        -> !wave.mem.token
  }
  return
}

// ASM-LABEL: redistribute_cross_wave_sequence:
// ASM-COUNT-3: s_barrier
// ASM-NOT: s_barrier
// ASM: buffer_store_b32
// ASM: .amdhsa_group_segment_fixed_size 512
func.func @redistribute_cross_wave_sequence(
    %dst: !wave.ptr<#wave.global, i32>)
    attributes {wave.kernel,
                wave.workgroup_size = array<i32: 64, 1, 1>,
                wave.waves_per_workgroup = 2 : i64} {
  %item = wave.workitem_id 0 : !wave.simd<i32, 32>
  %bounded_item = wave.assume %item as "x"
      [#wave.pred<"x >= 0">, #wave.pred<"x <= 63">]
      : !wave.simd<i32, 32>
  %one = wave.constant 1 : i32 -> !wave.simd<i32, 32>
  %next = wave.binary addi %item, %one
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %last = wave.binary addi %next, %one
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %source0 = wave.pack %item
      : !wave.simd<i32, 32> -> !wave.simd<vector<1xi32>, 32>
  %source1 = wave.pack %next
      : !wave.simd<i32, 32> -> !wave.simd<vector<1xi32>, 32>
  %source2 = wave.pack %last
      : !wave.simd<i32, 32> -> !wave.simd<vector<1xi32>, 32>
  %moved0 = wave.redistribute %source0,
      <blocks = 1, items = 64, source_block = "block", source_item = "xor(item, 32)", source_slot = "slot">
      : !wave.simd<vector<1xi32>, 32> -> !wave.simd<vector<1xi32>, 32>
  %moved1 = wave.redistribute %source1,
      <blocks = 1, items = 64, source_block = "block", source_item = "xor(item, 32)", source_slot = "slot">
      : !wave.simd<vector<1xi32>, 32> -> !wave.simd<vector<1xi32>, 32>
  %moved2 = wave.redistribute %source2,
      <blocks = 1, items = 64, source_block = "block", source_item = "xor(item, 32)", source_slot = "slot">
      : !wave.simd<vector<1xi32>, 32> -> !wave.simd<vector<1xi32>, 32>
  %value0 = wave.extract %moved0[0]
      : !wave.simd<vector<1xi32>, 32> -> !wave.simd<i32, 32>
  %value1 = wave.extract %moved1[0]
      : !wave.simd<vector<1xi32>, 32> -> !wave.simd<i32, 32>
  %value2 = wave.extract %moved2[0]
      : !wave.simd<vector<1xi32>, 32> -> !wave.simd<i32, 32>
  %sum01 = wave.binary addi %value0, %value1
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %sum = wave.binary addi %sum01, %value2
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %ptr = wave.ptr_add %dst, %bounded_item
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %token = wave.store %sum -> %ptr
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.global, i32>, 32>)
      -> !wave.mem.token
  return
}

// Allocation resolution keeps lowering-introduced scratch recurrences
// internal to value-only redistributions.
// ASM-LABEL: redistribute_cross_wave_loop_lifetime:
// ASM: ds_store_b32
// ASM: s_barrier
// ASM: ds_load_b32
// ASM: .amdhsa_group_segment_fixed_size 65536
func.func @redistribute_cross_wave_loop_lifetime(
    %dst: !wave.ptr<#wave.global, i32>)
    attributes {wave.kernel,
                wave.lds_size = 65024 : i64,
                wave.workgroup_size = array<i32: 64, 1, 1>,
                wave.waves_per_workgroup = 2 : i64} {
  %item = wave.workitem_id 0 : !wave.simd<i32, 32>
  %bounded_item = wave.assume %item as "x"
      [#wave.pred<"x >= 0">, #wave.pred<"x <= 63">]
      : !wave.simd<i32, 32>
  %source = wave.pack %item
      : !wave.simd<i32, 32> -> !wave.simd<vector<1xi32>, 32>
  %lower = arith.constant 0 : index
  %upper = arith.constant 2 : index
  %step = arith.constant 1 : index
  %done = scf.for %i = %lower to %upper step %step
      iter_args(%acc = %item) -> (!wave.simd<i32, 32>) {
    %moved0 = wave.redistribute %source,
        <blocks = 1, items = 64, source_block = "block", source_item = "xor(item, 32)", source_slot = "slot">
        : !wave.simd<vector<1xi32>, 32> -> !wave.simd<vector<1xi32>, 32>
    %value0 = wave.extract %moved0[0]
        : !wave.simd<vector<1xi32>, 32> -> !wave.simd<i32, 32>
    %moved1 = wave.redistribute %source,
        <blocks = 1, items = 64, source_block = "block", source_item = "xor(item, 32)", source_slot = "slot">
        : !wave.simd<vector<1xi32>, 32> -> !wave.simd<vector<1xi32>, 32>
    %value1 = wave.extract %moved1[0]
        : !wave.simd<vector<1xi32>, 32> -> !wave.simd<i32, 32>
    %moved2 = wave.redistribute %source,
        <blocks = 1, items = 64, source_block = "block", source_item = "xor(item, 32)", source_slot = "slot">
        : !wave.simd<vector<1xi32>, 32> -> !wave.simd<vector<1xi32>, 32>
    %value2 = wave.extract %moved2[0]
        : !wave.simd<vector<1xi32>, 32> -> !wave.simd<i32, 32>
    %moved3 = wave.redistribute %source,
        <blocks = 1, items = 64, source_block = "block", source_item = "xor(item, 32)", source_slot = "slot">
        : !wave.simd<vector<1xi32>, 32> -> !wave.simd<vector<1xi32>, 32>
    %value3 = wave.extract %moved3[0]
        : !wave.simd<vector<1xi32>, 32> -> !wave.simd<i32, 32>
    %sum01 = wave.binary addi %value0, %value1
        : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
    %sum23 = wave.binary addi %value2, %value3
        : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
    %sum = wave.binary addi %sum01, %sum23
        : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
    %next = wave.binary addi %acc, %sum
        : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
    scf.yield %next : !wave.simd<i32, 32>
  }
  %ptr = wave.ptr_add %dst, %bounded_item
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %stored = wave.store %done -> %ptr
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.global, i32>, 32>)
      -> !wave.mem.token
  return
}

// Mutually exclusive non-repetitive lifetimes share the only scratch plane.
// ASM-LABEL: redistribute_exclusive_scratch:
// ASM: ds_store_b32
// ASM: s_barrier
// ASM: ds_load_b32
// ASM: buffer_store_b32
// ASM: .amdhsa_group_segment_fixed_size 65536
func.func @redistribute_exclusive_scratch(
    %dst: !wave.ptr<#wave.global, i32>, %condition: i1)
    attributes {wave.kernel,
                wave.lds_size = 65280 : i64,
                wave.workgroup_size = array<i32: 64, 1, 1>,
                wave.waves_per_workgroup = 2 : i64} {
  %item = wave.workitem_id 0 : !wave.simd<i32, 32>
  %bounded_item = wave.assume %item as "x"
      [#wave.pred<"x >= 0">, #wave.pred<"x <= 63">]
      : !wave.simd<i32, 32>
  %one = wave.constant 1 : i32 -> !wave.simd<i32, 32>
  %next = wave.binary addi %item, %one
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %source0 = wave.pack %item, %item, %item, %item
      : !wave.simd<i32, 32>, !wave.simd<i32, 32>, !wave.simd<i32, 32>,
        !wave.simd<i32, 32> -> !wave.simd<vector<4xi32>, 32>
  %source1 = wave.pack %next, %next, %next, %next
      : !wave.simd<i32, 32>, !wave.simd<i32, 32>, !wave.simd<i32, 32>,
        !wave.simd<i32, 32> -> !wave.simd<vector<4xi32>, 32>
  %moved = scf.if %condition -> (!wave.simd<vector<4xi32>, 32>) {
    %then = wave.redistribute %source0,
        <blocks = 1, items = 64, source_block = "block", source_item = "xor(item, 32)", source_slot = "slot">
        : !wave.simd<vector<4xi32>, 32> -> !wave.simd<vector<4xi32>, 32>
    scf.yield %then : !wave.simd<vector<4xi32>, 32>
  } else {
    %else = wave.redistribute %source1,
        <blocks = 1, items = 64, source_block = "block", source_item = "xor(item, 32)", source_slot = "slot">
        : !wave.simd<vector<4xi32>, 32> -> !wave.simd<vector<4xi32>, 32>
    scf.yield %else : !wave.simd<vector<4xi32>, 32>
  }
  %value = wave.extract %moved[0]
      : !wave.simd<vector<4xi32>, 32> -> !wave.simd<i32, 32>
  %ptr = wave.ptr_add %dst, %bounded_item
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %stored = wave.store %value -> %ptr
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.global, i32>, 32>)
      -> !wave.mem.token
  return
}

}
