// RUN: wave-opt --wave-lower-symbolic-memory --split-input-file %s | FileCheck %s

// CHECK-LABEL: func.func @gfx950_b8_transpose(
// CHECK-NOT: wave.load
// CHECK: [[ITEM:%.*]] = wave.workitem_id 0
// CHECK: [[OFFSET:%.*]] = wave.index_expr <"1024*floor(1/128*item) + 8*Mod(item, 64)">
// CHECK: [[PTR:%.*]] = wave.ptr_add %arg0, [[OFFSET]]
// CHECK: [[VALUE:%.*]], %{{.*}} = waveamd.transpose_load [[PTR]]
// CHECK-NOT: wave.gather
// CHECK: return [[VALUE]]
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
  func.func @gfx950_b8_transpose(%base: !wave.ptr<#wave.shared, i8>)
      -> !wave.simd<vector<8xi8>, 64>
      attributes {wave.workgroup_size = array<i32: 256, 1, 1>} {
    %value, %token = wave.gather %base mapping
        <bit_offset = <"8 * (1024 * floor(item / 128) + 128 * floor(Mod(item, 64) / 16) + 4 * Mod(item, 16) + floor(slot / 2))">>
        bindings []() packet_bindings []()
        : (!wave.ptr<#wave.shared, i8>)
        -> (!wave.simd<vector<8xi8>, 64>, !wave.mem.token)
    return %value : !wave.simd<vector<8xi8>, 64>
  }
}

// -----

// Packet binding hides workitem ID behind a generated symbol.
// CHECK-LABEL: func.func @gfx950_b8_packet_bound_transpose(
// CHECK-NOT: wave.load
// CHECK: [[ITEM:%.*]] = wave.workitem_id 0
// CHECK: [[OFFSET:%.*]] = wave.index_expr <"8*raw0">
// CHECK-SAME: ["raw0"]([[ITEM]])
// CHECK: [[PTR:%.*]] = wave.ptr_add %arg0, [[OFFSET]]
// CHECK: waveamd.transpose_load [[PTR]]
// CHECK-NOT: wave.gather
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
  func.func @gfx950_b8_packet_bound_transpose(
      %base: !wave.ptr<#wave.shared, i8>)
      -> !wave.simd<vector<8xi8>, 64>
      attributes {wave.workgroup_size = array<i32: 64, 1, 1>} {
    %item = wave.workitem_id 0 : !wave.simd<i32, 64>
    %c16 = wave.constant 16 : i32 -> !wave.simd<i32, 64>
    %c128 = wave.constant 128 : i32 -> !wave.simd<i32, 64>
    %lane = wave.binary remui %item, %c16
        : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
    %group = wave.binary divui %item, %c16
        : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
    %group_offset = wave.binary muli %group, %c128 overflow<nsw>
        : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
    %offset0 = wave.binary addi %group_offset, %lane overflow<nsw>
        : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
    %offset1 = wave.binary addi %offset0, %c16 overflow<nsw>
        : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
    %offset2 = wave.binary addi %offset1, %c16 overflow<nsw>
        : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
    %offset3 = wave.binary addi %offset2, %c16 overflow<nsw>
        : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
    %offset4 = wave.binary addi %offset3, %c16 overflow<nsw>
        : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
    %offset5 = wave.binary addi %offset4, %c16 overflow<nsw>
        : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
    %offset6 = wave.binary addi %offset5, %c16 overflow<nsw>
        : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
    %offset7 = wave.binary addi %offset6, %c16 overflow<nsw>
        : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
    %offsets = wave.pack %offset0, %offset1, %offset2, %offset3,
        %offset4, %offset5, %offset6, %offset7
        : !wave.simd<i32, 64>, !wave.simd<i32, 64>,
          !wave.simd<i32, 64>, !wave.simd<i32, 64>,
          !wave.simd<i32, 64>, !wave.simd<i32, 64>,
          !wave.simd<i32, 64>, !wave.simd<i32, 64>
        -> !wave.simd<vector<8xi32>, 64>
    %value, %token = wave.gather %base mapping
        <bit_offset = <"8 * offset">>
        bindings []() packet_bindings ["offset"](%offsets)
        : (!wave.ptr<#wave.shared, i8>, !wave.simd<vector<8xi32>, 64>)
        -> (!wave.simd<vector<8xi8>, 64>, !wave.mem.token)
    return %value : !wave.simd<vector<8xi8>, 64>
  }
}

// -----

// Failed packet proof keeps generic lowering.
// CHECK-LABEL: func.func @gfx950_b8_packet_bound_wrong_relation(
// CHECK-NOT: waveamd.transpose_load
// CHECK: wave.load
// CHECK-NOT: waveamd.transpose_load
// CHECK-NOT: wave.gather
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
  func.func @gfx950_b8_packet_bound_wrong_relation(
      %base: !wave.ptr<#wave.shared, i8>)
      -> !wave.simd<vector<8xi8>, 64>
      attributes {wave.workgroup_size = array<i32: 64, 1, 1>} {
    %item = wave.workitem_id 0 : !wave.simd<i32, 64>
    %square = wave.binary muli %item, %item
        : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
    %offsets = wave.pack %item, %item, %item, %item,
        %item, %item, %item, %square
        : !wave.simd<i32, 64>, !wave.simd<i32, 64>,
          !wave.simd<i32, 64>, !wave.simd<i32, 64>,
          !wave.simd<i32, 64>, !wave.simd<i32, 64>,
          !wave.simd<i32, 64>, !wave.simd<i32, 64>
        -> !wave.simd<vector<8xi32>, 64>
    %value, %token = wave.gather %base mapping
        <bit_offset = <"8 * offset">>
        bindings []() packet_bindings ["offset"](%offsets)
        : (!wave.ptr<#wave.shared, i8>, !wave.simd<vector<8xi32>, 64>)
        -> (!wave.simd<vector<8xi8>, 64>, !wave.mem.token)
    return %value : !wave.simd<vector<8xi8>, 64>
  }
}

// -----

// CHECK-LABEL: func.func @gfx950_b16_wide_transpose(
// CHECK-NOT: wave.load
// CHECK: %{{.*}}, [[TOKEN0:%.*]] = waveamd.transpose_load
// CHECK-SAME: !wave.simd<vector<4xf16>, 64>
// CHECK: %{{.*}}, [[TOKEN1:%.*]] = waveamd.transpose_load
// CHECK-SAME: !wave.simd<vector<4xf16>, 64>
// CHECK-NOT: waveamd.transpose_load
// CHECK: wave.pack
// CHECK-NEXT: wave.join [[TOKEN0]], [[TOKEN1]]
// CHECK-NOT: wave.gather
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
  func.func @gfx950_b16_wide_transpose(
      %base: !wave.ptr<#wave.shared, f16>)
      -> !wave.simd<vector<8xf16>, 64>
      attributes {wave.workgroup_size = array<i32: 64, 1, 1>} {
    %value, %token = wave.gather %base mapping
        <bit_offset = <"16 * (8 * (item - Mod(item, 64) + 16 * floor(Mod(item, 64) / 16) + floor(Mod(item, 16) / 4) + 4 * slot) + Mod(item, 4))">>
        bindings []() packet_bindings []()
        : (!wave.ptr<#wave.shared, f16>)
        -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
    return %value : !wave.simd<vector<8xf16>, 64>
  }
}

// -----

// CHECK-LABEL: func.func @gfx950_b16_interleaved_transpose(
// CHECK-NOT: wave.load
// CHECK: %{{.*}}, [[TOKEN0:%.*]] = waveamd.transpose_load
// CHECK: %{{.*}}, [[TOKEN1:%.*]] = waveamd.transpose_load
// CHECK-NOT: waveamd.transpose_load
// CHECK: wave.pack
// CHECK-NEXT: wave.join [[TOKEN0]], [[TOKEN1]]
// CHECK-NOT: wave.gather
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
  func.func @gfx950_b16_interleaved_transpose(
      %base: !wave.ptr<#wave.shared, f16>)
      -> !wave.simd<vector<8xf16>, 64>
      attributes {wave.workgroup_size = array<i32: 64, 1, 1>} {
    %value, %token = wave.gather %base mapping
        <bit_offset = <"16 * (1024 * Mod(slot, 2) + 8 * (item - Mod(item, 64) + 16 * floor(Mod(item, 64) / 16) + floor(Mod(item, 16) / 4) + 4 * floor(slot / 2)) + Mod(item, 4))">>
        bindings []() packet_bindings []()
        : (!wave.ptr<#wave.shared, f16>)
        -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
    return %value : !wave.simd<vector<8xf16>, 64>
  }
}

// -----

// CHECK-LABEL: func.func @gfx950_b8_strided_transpose(
// CHECK-NOT: wave.load
// CHECK: wave.index_expr <"16*item">
// CHECK: waveamd.transpose_load
// CHECK-NOT: wave.gather
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
  func.func @gfx950_b8_strided_transpose(
      %base: !wave.ptr<#wave.shared, i8>)
      -> !wave.simd<vector<8xi8>, 64>
      attributes {wave.workgroup_size = array<i32: 64, 1, 1>} {
    %value, %token = wave.gather %base mapping
        <bit_offset = <"8 * (256 * floor(Mod(item, 64) / 16) + 16 * floor(Mod(item, 16) / 2) + 4 * Mod(item, 2) + floor(slot / 2))">>
        bindings []() packet_bindings []()
        : (!wave.ptr<#wave.shared, i8>)
        -> (!wave.simd<vector<8xi8>, 64>, !wave.mem.token)
    return %value : !wave.simd<vector<8xi8>, 64>
  }
}

// -----

// CHECK-LABEL: func.func @gfx950_b8_fact_transpose(
// CHECK-NOT: wave.load
// CHECK: wave.index_expr <"16*item + origin">
// CHECK-SAME: ["origin", "item"]
// CHECK: waveamd.transpose_load
// CHECK-NOT: wave.gather
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
  func.func @gfx950_b8_fact_transpose(
      %base: !wave.ptr<#wave.shared, i8>, %origin_raw: index)
      -> !wave.simd<vector<8xi8>, 64>
      attributes {wave.workgroup_size = array<i32: 64, 1, 1>} {
    %origin = wave.assume %origin_raw as "origin"
        [#wave.pred<"Mod(origin, 4) == 0">] : index
    %value, %token = wave.gather %base mapping
        <bit_offset = <"8 * (origin + 256 * floor(Mod(item, 64) / 16) + 16 * floor(Mod(item, 16) / 2) + 4 * Mod(item, 2) + floor(slot / 2) + Mod(origin * slot, 4))">>
        bindings ["origin"](%origin) packet_bindings []()
        : (!wave.ptr<#wave.shared, i8>, index)
        -> (!wave.simd<vector<8xi8>, 64>, !wave.mem.token)
    return %value : !wave.simd<vector<8xi8>, 64>
  }
}

// -----

// CHECK-LABEL: func.func @gfx950_b8_insufficient_fact(
// CHECK-NOT: waveamd.transpose_load
// CHECK: wave.load
// CHECK-NOT: wave.gather
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
  func.func @gfx950_b8_insufficient_fact(
      %base: !wave.ptr<#wave.shared, i8>, %origin_raw: index)
      -> !wave.simd<vector<8xi8>, 64>
      attributes {wave.workgroup_size = array<i32: 64, 1, 1>} {
    %origin = wave.assume %origin_raw as "origin"
        [#wave.pred<"Mod(origin, 2) == 0">] : index
    %value, %token = wave.gather %base mapping
        <bit_offset = <"8 * (origin + 256 * floor(Mod(item, 64) / 16) + 16 * floor(Mod(item, 16) / 2) + 4 * Mod(item, 2) + floor(slot / 2) + Mod(origin * slot, 4))">>
        bindings ["origin"](%origin) packet_bindings []()
        : (!wave.ptr<#wave.shared, i8>, index)
        -> (!wave.simd<vector<8xi8>, 64>, !wave.mem.token)
    return %value : !wave.simd<vector<8xi8>, 64>
  }
}

// -----

// CHECK-LABEL: func.func @gfx950_b8_contradicting_fact(
// CHECK-NOT: waveamd.transpose_load
// CHECK: wave.load
// CHECK-NOT: wave.gather
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
  func.func @gfx950_b8_contradicting_fact(
      %base: !wave.ptr<#wave.shared, i8>, %origin_raw: index)
      -> !wave.simd<vector<8xi8>, 64>
      attributes {wave.workgroup_size = array<i32: 64, 1, 1>} {
    %origin = wave.assume %origin_raw as "origin"
        [#wave.pred<"Mod(origin, 4) == 1">] : index
    %value, %token = wave.gather %base mapping
        <bit_offset = <"8 * (origin + 256 * floor(Mod(item, 64) / 16) + 16 * floor(Mod(item, 16) / 2) + 4 * Mod(item, 2) + floor(slot / 2) + Mod(origin * slot, 4))">>
        bindings ["origin"](%origin) packet_bindings []()
        : (!wave.ptr<#wave.shared, i8>, index)
        -> (!wave.simd<vector<8xi8>, 64>, !wave.mem.token)
    return %value : !wave.simd<vector<8xi8>, 64>
  }
}

// -----

// CHECK-LABEL: func.func @gfx950_b8_fact_keeps_xor_base(
// CHECK-NOT: wave.load
// CHECK: wave.index_expr <"origin + 8*Mod(item, 64) + xor(32 + 4*b, 8*c)">
// CHECK: waveamd.transpose_load
// CHECK-NOT: wave.gather
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
  func.func @gfx950_b8_fact_keeps_xor_base(
      %base: !wave.ptr<#wave.shared, i8>, %origin_raw: index,
      %b: index, %c: index)
      -> !wave.simd<vector<8xi8>, 64>
      attributes {wave.workgroup_size = array<i32: 128, 1, 1>} {
    %origin = wave.assume %origin_raw as "origin"
        [#wave.pred<"Mod(origin, 4) == 0">] : index
    %bounded_b = wave.assume %b as "x"
        [#wave.pred<"x >= 0 & -1 + x <= 0">] : index
    %bounded_c = wave.assume %c as "x"
        [#wave.pred<"x >= 0 & -1 + x <= 0">] : index
    %value, %token = wave.gather %base mapping
        <bit_offset = <"8 * (origin + xor(32 + 4*b, 8*c) + 128 * floor(Mod(item, 64) / 16) + 4 * Mod(item, 16) + floor(slot / 2) + Mod(origin * slot, 4))">>
        bindings ["origin", "b", "c"](%origin, %bounded_b, %bounded_c)
        packet_bindings []()
        : (!wave.ptr<#wave.shared, i8>, index, index, index)
        -> (!wave.simd<vector<8xi8>, 64>, !wave.mem.token)
    return %value : !wave.simd<vector<8xi8>, 64>
  }
}

// -----

// CHECK-LABEL: func.func @gfx950_b16_transpose(
// CHECK-NOT: wave.load
// CHECK: wave.index_expr <"8*item">
// CHECK: waveamd.transpose_load
// CHECK-SAME: !wave.simd<vector<4xf16>, 64>
// CHECK-NOT: wave.gather
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
  func.func @gfx950_b16_transpose(
      %base: !wave.ptr<#wave.shared, f16>)
      -> !wave.simd<vector<4xf16>, 64>
      attributes {wave.workgroup_size = array<i32: 64, 1, 1>} {
    %value, %token = wave.gather %base mapping
        <bit_offset = <"16 * (8 * (item - Mod(item, 64) + 16 * floor(Mod(item, 64) / 16) + floor(Mod(item, 16) / 4) + 4 * slot) + Mod(item, 4))">>
        bindings []() packet_bindings []()
        : (!wave.ptr<#wave.shared, f16>)
        -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
    return %value : !wave.simd<vector<4xf16>, 64>
  }
}

// -----

// CHECK-LABEL: func.func @gfx950_b16_grouped_add_transpose(
// CHECK-NOT: wave.load
// CHECK: wave.index_expr <"1024*floor(1/64*item) + 8*Mod(item, 64)">
// CHECK: waveamd.transpose_load
// CHECK-NOT: wave.gather
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
  func.func @gfx950_b16_grouped_add_transpose(
      %base: !wave.ptr<#wave.shared, f16>)
      -> !wave.simd<vector<4xf16>, 64>
      attributes {wave.workgroup_size = array<i32: 256, 1, 1>} {
    %value, %token = wave.gather %base mapping
        <bit_offset = <"16 * (1024 * floor((item - Mod(item, 64) + 16 * floor(Mod(item, 64) / 16) + floor(Mod(item, 16) / 4) + 4 * slot) / 64) + 8 * Mod(item - Mod(item, 64) + 16 * floor(Mod(item, 64) / 16) + floor(Mod(item, 16) / 4) + 4 * slot, 64) + Mod(item, 4))">>
        bindings []() packet_bindings []()
        : (!wave.ptr<#wave.shared, f16>)
        -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
    return %value : !wave.simd<vector<4xf16>, 64>
  }
}

// -----

// CHECK-LABEL: func.func @gfx950_b16_xor_transpose(
// CHECK-NOT: wave.load
// CHECK: wave.index_expr <"xor(
// CHECK-SAME: Mod(floor(1/8*item), 2)
// CHECK-SAME: Mod(floor(1/16*item), 2)
// CHECK: wave.ptr_add
// CHECK: waveamd.transpose_load
// CHECK-NOT: wave.gather
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
  func.func @gfx950_b16_xor_transpose(
      %base: !wave.ptr<#wave.shared, f16>)
      -> !wave.simd<vector<4xf16>, 64>
      attributes {wave.workgroup_size = array<i32: 64, 1, 1>} {
    %value, %token = wave.gather %base mapping
        <bit_offset = <"16 * (xor(item - Mod(item, 64) + 16 * floor(Mod(item, 64) / 16) + floor(Mod(item, 16) / 4) + 4 * slot, floor((item - Mod(item, 64) + 16 * floor(Mod(item, 64) / 16) + floor(Mod(item, 16) / 4) + 4 * slot) / 2)) + Mod(item, 4))">>
        bindings []() packet_bindings []()
        : (!wave.ptr<#wave.shared, f16>)
        -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
    return %value : !wave.simd<vector<4xf16>, 64>
  }
}

// -----

// CHECK-LABEL: func.func @gfx950_b16_xor_origin_transpose(
// CHECK-SAME: [[BASE:%.*]]: !wave.ptr<#wave.shared, f16>, [[ORIGIN:%.*]]: index)
// CHECK-NOT: wave.load
// CHECK: [[ITEM:%.*]] = wave.workitem_id 0
// CHECK: [[OFFSET:%.*]] = wave.index_expr <"origin + xor(
// CHECK-SAME: ["origin", "item"]([[ORIGIN]], [[ITEM]])
// CHECK: waveamd.transpose_load
// CHECK-NOT: wave.gather
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
  func.func @gfx950_b16_xor_origin_transpose(
      %base: !wave.ptr<#wave.shared, f16>, %origin: index)
      -> !wave.simd<vector<4xf16>, 64>
      attributes {wave.workgroup_size = array<i32: 64, 1, 1>} {
    %value, %token = wave.gather %base mapping
        <bit_offset = <"16 * (origin + xor(item - Mod(item, 64) + 16 * floor(Mod(item, 64) / 16) + floor(Mod(item, 16) / 4) + 4 * slot, floor((item - Mod(item, 64) + 16 * floor(Mod(item, 64) / 16) + floor(Mod(item, 16) / 4) + 4 * slot) / 2)) + Mod(item, 4))">>
        bindings ["origin"](%origin) packet_bindings []()
        : (!wave.ptr<#wave.shared, f16>, index)
        -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
    return %value : !wave.simd<vector<4xf16>, 64>
  }
}

// -----

// CHECK-LABEL: func.func @gfx950_b16_fact_transpose(
// CHECK-NOT: wave.load
// CHECK: waveamd.transpose_load
// CHECK-NOT: wave.gather
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
  func.func @gfx950_b16_fact_transpose(
      %base: !wave.ptr<#wave.shared, f16>, %origin_raw: index)
      -> !wave.simd<vector<4xf16>, 64>
      attributes {wave.workgroup_size = array<i32: 64, 1, 1>} {
    %origin = wave.assume %origin_raw as "origin"
        [#wave.pred<"Mod(origin, 4) == 0">] : index
    %value, %token = wave.gather %base mapping
        <bit_offset = <"16 * (origin + 8 * (item - Mod(item, 64) + 16 * floor(Mod(item, 64) / 16) + floor(Mod(item, 16) / 4) + 4 * slot) + Mod(item, 4) + Mod(origin * slot, 4))">>
        bindings ["origin"](%origin) packet_bindings []()
        : (!wave.ptr<#wave.shared, f16>, index)
        -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
    return %value : !wave.simd<vector<4xf16>, 64>
  }
}

// -----

// Missing divisibility fact keeps generic lowering.
// CHECK-LABEL: func.func @gfx950_b16_missing_fact(
// CHECK-NOT: waveamd.transpose_load
// CHECK: wave.load
// CHECK-NOT: wave.gather
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
  func.func @gfx950_b16_missing_fact(
      %base: !wave.ptr<#wave.shared, f16>, %origin: index)
      -> !wave.simd<vector<4xf16>, 64>
      attributes {wave.workgroup_size = array<i32: 64, 1, 1>} {
    %value, %token = wave.gather %base mapping
        <bit_offset = <"16 * (origin + 8 * (item - Mod(item, 64) + 16 * floor(Mod(item, 64) / 16) + floor(Mod(item, 16) / 4) + 4 * slot) + Mod(item, 4) + Mod(origin * slot, 4))">>
        bindings ["origin"](%origin) packet_bindings []()
        : (!wave.ptr<#wave.shared, f16>, index)
        -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
    return %value : !wave.simd<vector<4xf16>, 64>
  }
}

// -----

// Wrong B16 destination-lane stride keeps generic lowering.
// CHECK-LABEL: func.func @wrong_b16_relation(
// CHECK-NOT: waveamd.transpose_load
// CHECK: wave.load
// CHECK-NOT: wave.gather
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
  func.func @wrong_b16_relation(
      %base: !wave.ptr<#wave.shared, f16>)
      -> !wave.simd<vector<4xf16>, 64>
      attributes {wave.workgroup_size = array<i32: 64, 1, 1>} {
    %value, %token = wave.gather %base mapping
        <bit_offset = <"16 * (8 * (item - Mod(item, 64) + 16 * floor(Mod(item, 64) / 16) + floor(Mod(item, 16) / 4) + 4 * slot) + 2 * Mod(item, 4))">>
        bindings []() packet_bindings []()
        : (!wave.ptr<#wave.shared, f16>)
        -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
    return %value : !wave.simd<vector<4xf16>, 64>
  }
}

// -----

// CHECK-LABEL: func.func @gfx950_wave_id_tile(
// CHECK-NOT: wave.load
// CHECK: wave.index_expr <"2048 + 8*Mod(item, 64) + 1024*Mod(floor(1/64*item), 2)">
// CHECK: waveamd.transpose_load
// CHECK-NOT: wave.gather
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
  func.func @gfx950_wave_id_tile(%base: !wave.ptr<#wave.shared, i8>)
      -> !wave.simd<vector<8xi8>, 64>
      attributes {wave.workgroup_size = array<i32: 256, 1, 1>} {
    %value, %token = wave.gather %base mapping
        <bit_offset = <"8 * (2048 + 1024 * Mod(floor(item / 64), 2) + 128 * floor(Mod(item, 64) / 16) + 4 * Mod(item, 16) + floor(slot / 2))">>
        bindings []() packet_bindings []()
        : (!wave.ptr<#wave.shared, i8>)
        -> (!wave.simd<vector<8xi8>, 64>, !wave.mem.token)
    return %value : !wave.simd<vector<8xi8>, 64>
  }
}

// -----

// Wrong slot replication keeps generic lowering.
// CHECK-LABEL: func.func @wrong_b8_relation(
// CHECK-NOT: waveamd.transpose_load
// CHECK: wave.load
// CHECK-NOT: wave.gather
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
  func.func @wrong_b8_relation(%base: !wave.ptr<#wave.shared, i8>)
      -> !wave.simd<vector<8xi8>, 64>
      attributes {wave.workgroup_size = array<i32: 64, 1, 1>} {
    %value, %token = wave.gather %base mapping
        <bit_offset = <"8 * (128 * floor(Mod(item, 64) / 16) + 4 * Mod(item, 16) + slot)">>
        bindings []() packet_bindings []()
        : (!wave.ptr<#wave.shared, i8>)
        -> (!wave.simd<vector<8xi8>, 64>, !wave.mem.token)
    return %value : !wave.simd<vector<8xi8>, 64>
  }
}

// -----

// Nonuniform tile bases violate transpose cross-lane semantics.
// CHECK-LABEL: func.func @nonuniform_tile_base(
// CHECK-NOT: waveamd.transpose_load
// CHECK: wave.load
// CHECK-NOT: wave.gather
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
  func.func @nonuniform_tile_base(%base: !wave.ptr<#wave.shared, i8>)
      -> !wave.simd<vector<8xi8>, 64>
      attributes {wave.workgroup_size = array<i32: 64, 1, 1>} {
    %value, %token = wave.gather %base mapping
        <bit_offset = <"8 * (512 * item + 128 * floor(Mod(item, 64) / 16) + 4 * Mod(item, 16) + floor(slot / 2))">>
        bindings []() packet_bindings []()
        : (!wave.ptr<#wave.shared, i8>)
        -> (!wave.simd<vector<8xi8>, 64>, !wave.mem.token)
    return %value : !wave.simd<vector<8xi8>, 64>
  }
}

// -----

// CHECK-LABEL: func.func @unsupported_target(
// CHECK-NOT: waveamd.transpose_load
// CHECK: wave.load
// CHECK-SAME: -> (!wave.simd<vector<4xi8>, 64>, !wave.mem.token)
// CHECK-NOT: wave.gather
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx942"} {
  func.func @unsupported_target(%base: !wave.ptr<#wave.shared, i8>)
      -> !wave.simd<vector<8xi8>, 64>
      attributes {wave.workgroup_size = array<i32: 64, 1, 1>} {
    %value, %token = wave.gather %base mapping
        <bit_offset = <"8 * (128 * floor(Mod(item, 64) / 16) + 4 * Mod(item, 16) + floor(slot / 2))">>
        bindings []() packet_bindings []()
        : (!wave.ptr<#wave.shared, i8>)
        -> (!wave.simd<vector<8xi8>, 64>, !wave.mem.token)
    return %value : !wave.simd<vector<8xi8>, 64>
  }
}

// -----

// A short final wave cannot execute the transpose instruction.
// CHECK-LABEL: func.func @partial_wave(
// CHECK-NOT: waveamd.transpose_load
// CHECK: wave.load
// CHECK-NOT: wave.gather
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
  func.func @partial_wave(%base: !wave.ptr<#wave.shared, i8>)
      -> !wave.simd<vector<8xi8>, 64>
      attributes {wave.workgroup_size = array<i32: 32, 1, 1>} {
    %value, %token = wave.gather %base mapping
        <bit_offset = <"8 * (128 * floor(Mod(item, 64) / 16) + 4 * Mod(item, 16) + floor(slot / 2))">>
        bindings []() packet_bindings []()
        : (!wave.ptr<#wave.shared, i8>)
        -> (!wave.simd<vector<8xi8>, 64>, !wave.mem.token)
    return %value : !wave.simd<vector<8xi8>, 64>
  }
}

// -----

// Partial EXEC keeps generic lowering.
// CHECK-LABEL: func.func @inside_where(
// CHECK: wave.where
// CHECK-NOT: waveamd.transpose_load
// CHECK: wave.load
// CHECK-NOT: wave.gather
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
  func.func @inside_where(%base: !wave.ptr<#wave.shared, i8>)
      attributes {wave.workgroup_size = array<i32: 64, 1, 1>} {
    %item = wave.workitem_id 0 : !wave.simd<i32, 64>
    %limit = wave.constant 32 : i32 -> !wave.simd<i32, 64>
    %active = wave.cmpi slt %item, %limit
        : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
    wave.where %active {
      %value, %token = wave.gather %base mapping
          <bit_offset = <"8 * (128 * floor(Mod(item, 64) / 16) + 4 * Mod(item, 16) + floor(slot / 2))">>
          bindings []() packet_bindings []()
          : (!wave.ptr<#wave.shared, i8>)
          -> (!wave.simd<vector<8xi8>, 64>, !wave.mem.token)
      wave.yield
    } : !wave.mask<64>
    return
  }
}
