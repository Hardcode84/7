// RUN: wave-opt --wave-lower-symbolic-memory --split-input-file %s | FileCheck %s --check-prefix=LOWER
// RUN: wave-opt --wave-lower-symbolic-memory --waveamd-dma-zero-fill --split-input-file %s | FileCheck %s --check-prefix=ZF

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// LOWER-LABEL: func.func @direct_copy
// LOWER: [[DEP:%.*]] = wave.token
// LOWER: [[WIDTH:%.*]] = wave.constant 64
// LOWER: [[LANE:%.*]] = wave.binary remui {{%.*}}, [[WIDTH]]
// LOWER: [[BASE:%.*]] = wave.binary subi {{%.*}}, [[LANE]]
// LOWER: [[FIRST:%.*]] = wave.read_first [[BASE]]
// LOWER: [[DMA:%.*]] = waveamd.dma_load_lds
// LOWER-SAME: after [[DEP]]
// LOWER-SAME: bytes = 16
// LOWER-NOT: wave.gather
// LOWER-NOT: wave.scatter
func.func @direct_copy(%source: !wave.ptr<#wave.global, i32>,
                       %destination: !wave.ptr<#wave.shared, i32>)
    attributes {wave.workgroup_size = array<i32: 64, 1, 1>} {
  %dependency = wave.token : !wave.mem.token
  %value, %loaded = wave.gather %source mapping
      <bit_offset = <"32*(4*item + slot)">>
      bindings []() packet_bindings []() after %dependency
      : (!wave.ptr<#wave.global, i32>, !wave.mem.token)
      -> (!wave.simd<vector<4xi32>, 64>, !wave.mem.token)
  %stored = wave.scatter %value to %destination mapping
      <bit_offset = <"32*(4*item + slot)">>
      bindings []() packet_bindings []() after %loaded
      : (!wave.simd<vector<4xi32>, 64>,
         !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// LOWER-LABEL: func.func @repacked_copy
// LOWER-NOT: wave.gather
// LOWER-NOT: wave.scatter
// LOWER-COUNT-1: waveamd.dma_load_lds
// LOWER-SAME: bytes = 16
func.func @repacked_copy(%source: !wave.ptr<#wave.global, f16>,
                         %destination: !wave.ptr<#wave.shared, f16>)
    attributes {wave.workgroup_size = array<i32: 64, 1, 1>} {
  %value, %loaded = wave.gather %source mapping
      <bit_offset = <"16*(item + 64*slot)">>
      bindings []() packet_bindings []()
      : (!wave.ptr<#wave.global, f16>)
      -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
  %stored = wave.scatter %value to %destination mapping
      <bit_offset =
        <"16*xor(32*Mod(floor(1/32*item), 2), xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(2*Mod(floor(1/2*item), 2), xor(64*Mod(slot, 2) + 256*Mod(floor(1/4*slot), 2) + 128*Mod(floor(1/2*slot), 2), Mod(item, 2)))))))">>
      bindings []() packet_bindings []() after %loaded
      : (!wave.simd<vector<8xf16>, 64>,
         !wave.ptr<#wave.shared, f16>, !wave.mem.token) -> !wave.mem.token
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// LOWER-LABEL: func.func @repacked_buffer_zero_fill
// LOWER-NOT: wave.gather
// LOWER-NOT: wave.scatter
// LOWER-COUNT-1: wave.where
// LOWER-COUNT-1: waveamd.dma_load_lds
// LOWER-SAME: bytes = 16
// LOWER-SAME: zero_fill_inactive
// ZF-LABEL: func.func @repacked_buffer_zero_fill
// ZF-NOT: wave.where
// ZF: wave.select
// ZF: waveamd.dma_load_lds
func.func @repacked_buffer_zero_fill(
    %source: !wave.ptr<#wave.global, f16>,
    %destination: !wave.ptr<#wave.shared, f16>, %limit_raw: i32)
    attributes {wave.workgroup_size = array<i32: 64, 1, 1>} {
  %range = arith.constant 1024 : i32
  %buffer = waveamd.make_buffer %source, %range
      : !wave.ptr<#wave.global, f16>, i32
      -> !wave.ptr<#waveamd.buffer, f16>
  %limit = wave.assume %limit_raw as "limit"
      [#wave.pred<"limit >= 0 & -512 + limit <= 0">,
       #wave.pred<"Mod(limit, 16) == 0">] : i32
  %limit_index = wave.index_expr <"limit"> ["limit"](%limit)
      : (i32) -> index
  %limit_packet = wave.splat %limit_index
      : index -> !wave.simd<index, 64>
  %item = wave.workitem_id 0 : !wave.simd<i32, 64>
  %assumed_item = wave.assume %item as "x"
      [#wave.pred<"x >= 0">, #wave.pred<"-63 + x <= 0">]
      : !wave.simd<i32, 64>
  %offset0 = wave.index_expr <"item">
      assuming [#wave.pred<"item >= 0 & -63 + item <= 0">]
      ["item"](%item) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
  %offset1 = wave.index_expr <"64 + item">
      assuming [#wave.pred<"item >= 0 & -63 + item <= 0">]
      ["item"](%item) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
  %offset2 = wave.index_expr <"128 + item">
      assuming [#wave.pred<"item >= 0 & -63 + item <= 0">]
      ["item"](%item) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
  %offset3 = wave.index_expr <"192 + item">
      assuming [#wave.pred<"item >= 0 & -63 + item <= 0">]
      ["item"](%item) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
  %offset4 = wave.index_expr <"256 + item">
      assuming [#wave.pred<"item >= 0 & -63 + item <= 0">]
      ["item"](%item) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
  %offset5 = wave.index_expr <"320 + item">
      assuming [#wave.pred<"item >= 0 & -63 + item <= 0">]
      ["item"](%item) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
  %offset6 = wave.index_expr <"384 + item">
      assuming [#wave.pred<"item >= 0 & -63 + item <= 0">]
      ["item"](%item) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
  %offset7 = wave.index_expr <"448 + item">
      assuming [#wave.pred<"item >= 0 & -63 + item <= 0">]
      ["item"](%item) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
  %mask0 = wave.cmpi slt %offset0, %limit_packet
      : !wave.simd<index, 64>, !wave.simd<index, 64> -> !wave.mask<64>
  %mask1 = wave.cmpi slt %offset1, %limit_packet
      : !wave.simd<index, 64>, !wave.simd<index, 64> -> !wave.mask<64>
  %mask2 = wave.cmpi slt %offset2, %limit_packet
      : !wave.simd<index, 64>, !wave.simd<index, 64> -> !wave.mask<64>
  %mask3 = wave.cmpi slt %offset3, %limit_packet
      : !wave.simd<index, 64>, !wave.simd<index, 64> -> !wave.mask<64>
  %mask4 = wave.cmpi slt %offset4, %limit_packet
      : !wave.simd<index, 64>, !wave.simd<index, 64> -> !wave.mask<64>
  %mask5 = wave.cmpi slt %offset5, %limit_packet
      : !wave.simd<index, 64>, !wave.simd<index, 64> -> !wave.mask<64>
  %mask6 = wave.cmpi slt %offset6, %limit_packet
      : !wave.simd<index, 64>, !wave.simd<index, 64> -> !wave.mask<64>
  %mask7 = wave.cmpi slt %offset7, %limit_packet
      : !wave.simd<index, 64>, !wave.simd<index, 64> -> !wave.mask<64>
  %dependency = wave.token : !wave.mem.token
  %zero = wave.constant 0.0 : f16 -> !wave.simd<f16, 64>
  %fallback = wave.pack %zero, %zero, %zero, %zero,
      %zero, %zero, %zero, %zero
      : !wave.simd<f16, 64>, !wave.simd<f16, 64>,
        !wave.simd<f16, 64>, !wave.simd<f16, 64>,
        !wave.simd<f16, 64>, !wave.simd<f16, 64>,
        !wave.simd<f16, 64>, !wave.simd<f16, 64>
      -> !wave.simd<vector<8xf16>, 64>
  %copy:2 = wave.where %mask0, %mask1, %mask2, %mask3,
      %mask4, %mask5, %mask6, %mask7 {
    %bounded_item = wave.assume %assumed_item as "x"
        [#wave.pred<"x >= 0">, #wave.pred<"x <= 1073741823">]
        : !wave.simd<i32, 64>
    %zero_offset = wave.constant 0 : i32 -> !wave.simd<i32, 64>
    %bounded_offset = wave.binary addi %bounded_item, %zero_offset overflow<nsw>
        : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
    %value, %loaded = wave.gather %buffer mapping
        <bit_offset = <"16*offset">> bindings []()
        packet_bindings ["offset", "offset", "offset", "offset",
                         "offset", "offset", "offset", "offset"]
                        (%bounded_offset, %offset1, %offset2, %offset3,
                         %offset4, %offset5, %offset6, %offset7)
        after %dependency
        : (!wave.ptr<#waveamd.buffer, f16>,
           !wave.simd<i32, 64>, !wave.simd<index, 64>,
           !wave.simd<index, 64>, !wave.simd<index, 64>,
           !wave.simd<index, 64>, !wave.simd<index, 64>,
           !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.mem.token)
        -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
    wave.yield %value, %loaded
        : !wave.simd<vector<8xf16>, 64>, !wave.mem.token
  } otherwise {
    wave.yield %fallback, %dependency
        : !wave.simd<vector<8xf16>, 64>, !wave.mem.token
  } : !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>,
      !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>
      -> !wave.simd<vector<8xf16>, 64>, !wave.mem.token
  %stored = wave.scatter %copy#0 to %destination mapping
      <bit_offset =
        <"16*xor(32*Mod(floor(1/32*item), 2), xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(2*Mod(floor(1/2*item), 2), xor(64*Mod(slot, 2) + 256*Mod(floor(1/4*slot), 2) + 128*Mod(floor(1/2*slot), 2), Mod(item, 2)))))))">>
      bindings []() packet_bindings []() after %copy#1
      : (!wave.simd<vector<8xf16>, 64>,
         !wave.ptr<#wave.shared, f16>, !wave.mem.token) -> !wave.mem.token
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// LOWER-LABEL: func.func @buffer_zero_fill
// LOWER-NOT: wave.gather
// LOWER-NOT: wave.scatter
// LOWER: wave.where
// LOWER: waveamd.dma_load_lds
// LOWER-SAME: bytes = 16
// LOWER-SAME: zero_fill_inactive
// ZF-LABEL: func.func @buffer_zero_fill
// ZF-NOT: wave.where
// ZF: wave.select
// ZF: waveamd.dma_load_lds
func.func @buffer_zero_fill(%source: !wave.ptr<#wave.global, i32>,
                            %destination: !wave.ptr<#wave.shared, i32>,
                            %active: !wave.mask<64>)
    attributes {wave.workgroup_size = array<i32: 64, 1, 1>} {
  %range = arith.constant 4096 : i32
  %buffer = waveamd.make_buffer %source, %range
      : !wave.ptr<#wave.global, i32>, i32
      -> !wave.ptr<#waveamd.buffer, i32>
  %dependency = wave.token : !wave.mem.token
  %zero = wave.constant 0 : i32 -> !wave.simd<i32, 64>
  %fallback = wave.pack %zero, %zero, %zero, %zero
      : !wave.simd<i32, 64>, !wave.simd<i32, 64>,
        !wave.simd<i32, 64>, !wave.simd<i32, 64>
      -> !wave.simd<vector<4xi32>, 64>
  %copy:2 = wave.where %active {
    %value, %loaded = wave.gather %buffer mapping
        <bit_offset = <"32*(4*item + slot)">>
        bindings []() packet_bindings []() after %dependency
        : (!wave.ptr<#waveamd.buffer, i32>, !wave.mem.token)
        -> (!wave.simd<vector<4xi32>, 64>, !wave.mem.token)
    wave.yield %value, %loaded
        : !wave.simd<vector<4xi32>, 64>, !wave.mem.token
  } otherwise {
    wave.yield %fallback, %dependency
        : !wave.simd<vector<4xi32>, 64>, !wave.mem.token
  } : !wave.mask<64> -> !wave.simd<vector<4xi32>, 64>, !wave.mem.token
  %stored = wave.scatter %copy#0 to %destination mapping
      <bit_offset = <"32*(4*item + slot)">>
      bindings []() packet_bindings []() after %copy#1
      : (!wave.simd<vector<4xi32>, 64>,
         !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// LOWER-LABEL: func.func @global_zero_fallback
// LOWER-NOT: waveamd.dma_load_lds
// LOWER: [[ZERO:%.*]] = wave.constant 0
// LOWER: [[FALLBACK:%.*]] = wave.pack [[ZERO]]
// LOWER: [[COPY:%.*]]:2 = wave.where
// LOWER: wave.load
// LOWER: otherwise
// LOWER: wave.yield [[FALLBACK]]
// LOWER: wave.extract [[COPY]]#0
// LOWER: wave.store
func.func @global_zero_fallback(
    %source: !wave.ptr<#wave.global, i32>,
    %destination: !wave.ptr<#wave.shared, i32>,
    %active: !wave.mask<64>)
    attributes {wave.workgroup_size = array<i32: 64, 1, 1>} {
  %dependency = wave.token : !wave.mem.token
  %zero = wave.constant 0 : i32 -> !wave.simd<i32, 64>
  %fallback = wave.pack %zero, %zero, %zero, %zero
      : !wave.simd<i32, 64>, !wave.simd<i32, 64>,
        !wave.simd<i32, 64>, !wave.simd<i32, 64>
      -> !wave.simd<vector<4xi32>, 64>
  %copy:2 = wave.where %active {
    %value, %loaded = wave.gather %source mapping
        <bit_offset = <"32*(4*item + slot)">>
        bindings []() packet_bindings []() after %dependency
        : (!wave.ptr<#wave.global, i32>, !wave.mem.token)
        -> (!wave.simd<vector<4xi32>, 64>, !wave.mem.token)
    wave.yield %value, %loaded
        : !wave.simd<vector<4xi32>, 64>, !wave.mem.token
  } otherwise {
    wave.yield %fallback, %dependency
        : !wave.simd<vector<4xi32>, 64>, !wave.mem.token
  } : !wave.mask<64> -> !wave.simd<vector<4xi32>, 64>, !wave.mem.token
  %stored = wave.scatter %copy#0 to %destination mapping
      <bit_offset = <"32*(4*item + slot)">>
      bindings []() packet_bindings []() after %copy#1
      : (!wave.simd<vector<4xi32>, 64>,
         !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// LOWER-LABEL: func.func @buffer_without_sentinel
// LOWER-NOT: waveamd.dma_load_lds
// LOWER: [[ZERO:%.*]] = wave.constant 0
// LOWER: [[FALLBACK:%.*]] = wave.pack [[ZERO]]
// LOWER: [[COPY:%.*]]:2 = wave.where
// LOWER: wave.load
// LOWER: otherwise
// LOWER: wave.yield [[FALLBACK]]
// LOWER: wave.extract [[COPY]]#0
// LOWER: wave.store
func.func @buffer_without_sentinel(
    %source: !wave.ptr<#waveamd.buffer, i32>,
    %destination: !wave.ptr<#wave.shared, i32>,
    %active: !wave.mask<64>)
    attributes {wave.workgroup_size = array<i32: 64, 1, 1>} {
  %dependency = wave.token : !wave.mem.token
  %zero = wave.constant 0 : i32 -> !wave.simd<i32, 64>
  %fallback = wave.pack %zero, %zero, %zero, %zero
      : !wave.simd<i32, 64>, !wave.simd<i32, 64>,
        !wave.simd<i32, 64>, !wave.simd<i32, 64>
      -> !wave.simd<vector<4xi32>, 64>
  %copy:2 = wave.where %active {
    %value, %loaded = wave.gather %source mapping
        <bit_offset = <"32*(4*item + slot)">>
        bindings []() packet_bindings []() after %dependency
        : (!wave.ptr<#waveamd.buffer, i32>, !wave.mem.token)
        -> (!wave.simd<vector<4xi32>, 64>, !wave.mem.token)
    wave.yield %value, %loaded
        : !wave.simd<vector<4xi32>, 64>, !wave.mem.token
  } otherwise {
    wave.yield %fallback, %dependency
        : !wave.simd<vector<4xi32>, 64>, !wave.mem.token
  } : !wave.mask<64> -> !wave.simd<vector<4xi32>, 64>, !wave.mem.token
  %stored = wave.scatter %copy#0 to %destination mapping
      <bit_offset = <"32*(4*item + slot)">>
      bindings []() packet_bindings []() after %copy#1
      : (!wave.simd<vector<4xi32>, 64>,
         !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// LOWER-LABEL: func.func @nested_predicated_buffer_copy
// LOWER: wave.where
// LOWER: [[LANE:%.*]] = wave.binary remui
// LOWER: [[BASE:%.*]] = wave.binary subi {{%.*}}, [[LANE]]
// LOWER: wave.read_first [[BASE]]
// LOWER: wave.where
// LOWER: waveamd.dma_load_lds
// LOWER-SAME: zero_fill_inactive
// ZF-LABEL: func.func @nested_predicated_buffer_copy
// ZF-COUNT-1: wave.where
// ZF: wave.select
// ZF: waveamd.dma_load_lds
func.func @nested_predicated_buffer_copy(
    %source: !wave.ptr<#wave.global, i32>,
    %destination: !wave.ptr<#wave.shared, i32>,
    %outer: !wave.mask<64>, %copy_active: !wave.mask<64>)
    attributes {wave.workgroup_size = array<i32: 64, 1, 1>} {
  %range = arith.constant 4096 : i32
  %buffer = waveamd.make_buffer %source, %range
      : !wave.ptr<#wave.global, i32>, i32
      -> !wave.ptr<#waveamd.buffer, i32>
  %dependency = wave.token : !wave.mem.token
  %zero = wave.constant 0 : i32 -> !wave.simd<i32, 64>
  %fallback = wave.pack %zero, %zero, %zero, %zero
      : !wave.simd<i32, 64>, !wave.simd<i32, 64>,
        !wave.simd<i32, 64>, !wave.simd<i32, 64>
      -> !wave.simd<vector<4xi32>, 64>
  wave.where %outer {
    %copy:2 = wave.where %copy_active {
      %value, %loaded = wave.gather %buffer mapping
          <bit_offset = <"32*(4*item + slot)">>
          bindings []() packet_bindings []() after %dependency
          : (!wave.ptr<#waveamd.buffer, i32>, !wave.mem.token)
          -> (!wave.simd<vector<4xi32>, 64>, !wave.mem.token)
      wave.yield %value, %loaded
          : !wave.simd<vector<4xi32>, 64>, !wave.mem.token
    } otherwise {
      wave.yield %fallback, %dependency
          : !wave.simd<vector<4xi32>, 64>, !wave.mem.token
    } : !wave.mask<64> -> !wave.simd<vector<4xi32>, 64>, !wave.mem.token
    %stored = wave.scatter %copy#0 to %destination mapping
        <bit_offset = <"32*(4*item + slot)">>
        bindings []() packet_bindings []() after %copy#1
        : (!wave.simd<vector<4xi32>, 64>,
           !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
    wave.yield
  } : !wave.mask<64>
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// LOWER-LABEL: func.func @partial_exec_copy
// LOWER: wave.where
// LOWER: [[LANE:%.*]] = wave.binary remui
// LOWER: [[BASE:%.*]] = wave.binary subi {{%.*}}, [[LANE]]
// LOWER: wave.read_first [[BASE]]
// LOWER: waveamd.dma_load_lds
func.func @partial_exec_copy(%source: !wave.ptr<#wave.global, i32>,
                             %destination: !wave.ptr<#wave.shared, i32>,
                             %active: !wave.mask<64>)
    attributes {wave.workgroup_size = array<i32: 64, 1, 1>} {
  wave.where %active {
    %value, %loaded = wave.gather %source mapping
        <bit_offset = <"32*(4*item + slot)">>
        bindings []() packet_bindings []()
        : (!wave.ptr<#wave.global, i32>)
        -> (!wave.simd<vector<4xi32>, 64>, !wave.mem.token)
    %stored = wave.scatter %value to %destination mapping
        <bit_offset = <"32*(4*item + slot)">>
        bindings []() packet_bindings []() after %loaded
        : (!wave.simd<vector<4xi32>, 64>,
           !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
    wave.yield
  } : !wave.mask<64>
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1250"} {

// LOWER-LABEL: func.func @gfx1250_fallback
// LOWER-NOT: waveamd.dma_load_lds
// LOWER: wave.load
// LOWER: wave.store
func.func @gfx1250_fallback(%source: !wave.ptr<#wave.global, i32>,
                            %destination: !wave.ptr<#wave.shared, i32>)
    attributes {wave.workgroup_size = array<i32: 32, 1, 1>} {
  %value, %loaded = wave.gather %source mapping
      <bit_offset = <"32*(4*item + slot)">>
      bindings []() packet_bindings []()
      : (!wave.ptr<#wave.global, i32>)
      -> (!wave.simd<vector<4xi32>, 32>, !wave.mem.token)
  %stored = wave.scatter %value to %destination mapping
      <bit_offset = <"32*(4*item + slot)">>
      bindings []() packet_bindings []() after %loaded
      : (!wave.simd<vector<4xi32>, 32>,
         !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// LOWER-LABEL: func.func @simd_base_copy_fallback
// LOWER-NOT: waveamd.dma_load_lds
// LOWER: [[DEP:%.*]] = wave.token
// LOWER: [[VALUE:%.*]], [[READ:%.*]] = wave.load {{%.*}} after [[DEP]]
// LOWER: wave.store {{%.*}} -> {{%.*}} after [[READ]]
// LOWER-NOT: wave.gather
// LOWER-NOT: wave.scatter
func.func @simd_base_copy_fallback(
    %source: !wave.ptr<#wave.global, i32>,
    %destination: !wave.ptr<#wave.shared, i32>) {
  %item = wave.workitem_id 0 : !wave.simd<i32, 64>
  %source_base = wave.ptr_add %source, %item
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 64>
  %destination_base = wave.ptr_add %destination, %item
      : !wave.ptr<#wave.shared, i32>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#wave.shared, i32>, 64>
  %dependency = wave.token : !wave.mem.token
  %value, %loaded = wave.gather %source_base mapping
      <bit_offset = <"32*slot">>
      bindings []() packet_bindings []() after %dependency
      : (!wave.simd<!wave.ptr<#wave.global, i32>, 64>, !wave.mem.token)
      -> (!wave.simd<vector<4xi32>, 64>, !wave.mem.token)
  %stored = wave.scatter %value to %destination_base mapping
      <bit_offset = <"32*slot">>
      bindings []() packet_bindings []() after %loaded
      : (!wave.simd<vector<4xi32>, 64>,
         !wave.simd<!wave.ptr<#wave.shared, i32>, 64>, !wave.mem.token)
      -> !wave.mem.token
  return
}

}
