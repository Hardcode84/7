// RUN: wave-opt --wave-lower-symbolic-memory --split-input-file %s | FileCheck %s --check-prefix=LOWER
// RUN: wave-opt --wave-lower-symbolic-memory --waveamd-dma-zero-fill --split-input-file %s | FileCheck %s --check-prefix=ZF

// A direct group-major physical layout forms one 16-byte DMA transaction. The
// item identity is a raw SSA chain: symbolic-memory preparation, not the
// generate-index pass, recognizes it without requiring a serialized binding.
// Symbolic addresses stay in bits; pointer materialization uses byte pointers.
// LOWER-LABEL: func.func @direct_copy
// LOWER: [[DEP:%.*]] = wave.token
// LOWER-NOT: wave.read_first
// LOWER: [[SOURCE_BYTES:%.*]] = wave.ptr_cast %arg0 : !wave.ptr<#wave.global, i32> -> !wave.ptr<#wave.global, i8>
// LOWER: [[SOURCE_OFFSET:%.*]] = wave.index_expr <"16*source_item">
// LOWER: [[SOURCE:%.*]] = wave.ptr_add [[SOURCE_BYTES]], [[SOURCE_OFFSET]]
// LOWER: [[DEST_BYTES:%.*]] = wave.ptr_cast %arg1 : !wave.ptr<#wave.shared, i32> -> !wave.ptr<#wave.shared, i8>
// LOWER: [[DEST_OFFSET:%.*]] = wave.constant 0 : index
// LOWER: [[DEST_BYTE_PTR:%.*]] = wave.ptr_add [[DEST_BYTES]], [[DEST_OFFSET]]
// LOWER: [[DEST:%.*]] = wave.ptr_cast [[DEST_BYTE_PTR]] : !wave.ptr<#wave.shared, i8> -> !wave.ptr<#wave.shared, i32>
// LOWER: waveamd.dma_load_lds [[SOURCE]] -> [[DEST]] after [[DEP]]
// LOWER-SAME: bytes = 16
// LOWER-NOT: wave.gather
// LOWER-NOT: wave.scatter
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
  func.func @direct_copy(%source: !wave.ptr<#wave.global, i32>,
                         %destination: !wave.ptr<#wave.shared, i32>)
      attributes {wave.workgroup_size = array<i32: 64, 1, 1>} {
    %item = wave.workitem_id 0 : !wave.simd<i32, 64>
    %zero = wave.constant 0 : i32 -> !wave.simd<i32, 64>
    %same_item = wave.binary addi %item, %zero overflow<nsw>
        : !wave.simd<i32, 64>, !wave.simd<i32, 64>
        -> !wave.simd<i32, 64>
    %bounded_item = wave.assume %same_item as "item"
        [#wave.pred<"item >= 0">, #wave.pred<"item <= 63">]
        : !wave.simd<i32, 64>
    %dependency = wave.token : !wave.mem.token
    %value, %loaded = wave.gather %source mapping
        <bit_offset = <"32*(4*item + slot)">>
        bindings ["item"](%bounded_item) after %dependency
        : (!wave.ptr<#wave.global, i32>, !wave.simd<i32, 64>,
           !wave.mem.token)
        -> (!wave.simd<vector<4xi32>, 64>, !wave.mem.token)
    %stored = wave.scatter %value to %destination mapping
        <bit_offset = <"32*(4*item + slot)">>
        bindings ["item"](%bounded_item) after %loaded
        : (!wave.simd<vector<4xi32>, 64>, !wave.ptr<#wave.shared, i32>,
           !wave.simd<i32, 64>, !wave.mem.token) -> !wave.mem.token
    return
  }
}

// -----

// The cyclic alignment span is measured in the wrapped expression's units,
// not in packet slots. Eight f16 elements occupy sixteen such units.
// LOWER-LABEL: func.func @scaled_modulo_f16_copy_forms_dma
// LOWER: waveamd.dma_load_lds
// LOWER-SAME: bytes = 16
// LOWER-NOT: wave.gather
// LOWER-NOT: wave.scatter
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
  func.func @scaled_modulo_f16_copy_forms_dma(
      %source: !wave.ptr<#waveamd.buffer, f16>,
      %destination: !wave.ptr<#wave.shared, f16>)
      attributes {wave.workgroup_size = array<i32: 64, 1, 1>} {
    %item = wave.workitem_id 0 : !wave.simd<i32, 64>
    %bounded_item = wave.assume %item as "item"
        [#wave.pred<"item >= 0">, #wave.pred<"item <= 63">]
        : !wave.simd<i32, 64>
    %value, %loaded = wave.gather %source mapping
        <bit_offset = <"8*Mod(2*(8*item + slot), 4294967296)">>
        bindings ["item"](%bounded_item)
        : (!wave.ptr<#waveamd.buffer, f16>, !wave.simd<i32, 64>)
        -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
    %stored = wave.scatter %value to %destination mapping
        <bit_offset = <"16*(8*item + slot)">>
        bindings ["item"](%bounded_item) after %loaded
        : (!wave.simd<vector<8xf16>, 64>, !wave.ptr<#wave.shared, f16>,
           !wave.simd<i32, 64>, !wave.mem.token) -> !wave.mem.token
    return
  }
}

// -----

// Symbolic-memory preparation analyzes an IndexExpr binding locally, recovers
// workitem ownership, and forms the direct DMA without mutating the packet.
// LOWER-LABEL: func.func @serialized_item_binding_is_analyzed_locally
// LOWER: waveamd.dma_load_lds
// LOWER-SAME: bytes = 16
// LOWER-NOT: wave.gather
// LOWER-NOT: wave.scatter
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
  func.func @serialized_item_binding_is_analyzed_locally(
      %source: !wave.ptr<#wave.global, i32>,
      %destination: !wave.ptr<#wave.shared, i32>)
      attributes {wave.workgroup_size = array<i32: 64, 1, 1>} {
    %item = wave.workitem_id 0 : !wave.simd<i32, 64>
    %zero = wave.constant 0 : i32 -> !wave.simd<i32, 64>
    %same_item = wave.binary addi %item, %zero
        : !wave.simd<i32, 64>, !wave.simd<i32, 64>
        -> !wave.simd<i32, 64>
    %packet = wave.index_expr <"item"> assuming
        [#wave.pred<"item >= 0">, #wave.pred<"item <= 63">]
        ["item"](%same_item)
        : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
    %value, %loaded = wave.gather %source mapping
        <bit_offset = <"32*(4*item + slot)">>
        bindings ["item"](%packet)
        : (!wave.ptr<#wave.global, i32>, !wave.simd<index, 64>)
        -> (!wave.simd<vector<4xi32>, 64>, !wave.mem.token)
    %stored = wave.scatter %value to %destination mapping
        <bit_offset = <"32*(4*item + slot)">>
        bindings ["item"](%packet) after %loaded
        : (!wave.simd<vector<4xi32>, 64>, !wave.ptr<#wave.shared, i32>,
           !wave.simd<index, 64>, !wave.mem.token) -> !wave.mem.token
    return
  }
}

// -----

// A fact-backed product supplies an aligned modular origin for every source
// transaction. The domain includes item=1, stride=-16, whose transaction ends
// exactly at UINT32_MAX.
// LOWER-LABEL: func.func @last_valid_u32_window_forms_dma
// LOWER: waveamd.dma_load_lds
// LOWER-SAME: bytes = 16
// LOWER-NOT: wave.gather
// LOWER-NOT: wave.scatter
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
  func.func @last_valid_u32_window_forms_dma(
      %source: !wave.ptr<#wave.global, i32>,
      %destination: !wave.ptr<#wave.shared, i32>, %stride_raw: i32)
      attributes {wave.workgroup_size = array<i32: 64, 1, 1>} {
    %item = wave.workitem_id 0 : !wave.simd<i32, 64>
    %bounded_item = wave.index_expr <"item"> assuming
        [#wave.pred<"item >= 0">, #wave.pred<"item <= 63">]
        ["item"](%item)
        : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
    %stride = wave.index_expr <"stride"> assuming
        [#wave.pred<"2147483648 + stride >= 0">,
         #wave.pred<"-2147483647 + stride <= 0">,
         #wave.pred<"Mod(stride, 16) == 0">]
        ["stride"](%stride_raw) : (i32) -> index
    %value, %loaded = wave.gather %source mapping
        <bit_offset = <"8*Mod(stride*item, 4294967296) + 32*slot">>
        bindings ["item", "stride"](%bounded_item, %stride)
        : (!wave.ptr<#wave.global, i32>, !wave.simd<index, 64>, index)
        -> (!wave.simd<vector<4xi32>, 64>, !wave.mem.token)
    %stored = wave.scatter %value to %destination mapping
        <bit_offset = <"32*(4*item + slot)">>
        bindings ["item"](%bounded_item) after %loaded
        : (!wave.simd<vector<4xi32>, 64>, !wave.ptr<#wave.shared, i32>,
           !wave.simd<index, 64>, !wave.mem.token) -> !wave.mem.token
    return
  }
}

// -----

// A 16-byte-spaced source grid shifted forward by three bytes makes the final
// transaction wrap the canonical u32 byte-offset domain while its last i32
// element still starts in range. DMA declines and the proven ordinary
// transaction lowering remains.
// LOWER-LABEL: func.func @wrapping_u32_window_falls_back
// LOWER-NOT: waveamd.dma_load_lds
// LOWER: wave.load
// LOWER: wave.store
// LOWER-NOT: wave.gather
// LOWER-NOT: wave.scatter
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
  func.func @wrapping_u32_window_falls_back(
      %source: !wave.ptr<#wave.global, i32>,
      %destination: !wave.ptr<#wave.shared, i32>)
      attributes {wave.workgroup_size = array<i32: 64, 1, 1>} {
    %item = wave.workitem_id 0 : !wave.simd<i32, 64>
    %bounded_item = wave.index_expr <"item"> assuming
        [#wave.pred<"item >= 0">, #wave.pred<"item <= 63">]
        ["item"](%item)
        : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
    %value, %loaded = wave.gather %source mapping
        <bit_offset = <"8*Mod(3 + 16*(item - 64), 4294967296) + 32*slot">>
        bindings ["item"](%bounded_item)
        : (!wave.ptr<#wave.global, i32>, !wave.simd<index, 64>)
        -> (!wave.simd<vector<4xi32>, 64>, !wave.mem.token)
    %stored = wave.scatter %value to %destination mapping
        <bit_offset = <"32*(4*item + slot)">>
        bindings ["item"](%bounded_item) after %loaded
        : (!wave.simd<vector<4xi32>, 64>, !wave.ptr<#wave.shared, i32>,
           !wave.simd<index, 64>, !wave.mem.token) -> !wave.mem.token
    return
  }
}

// -----

// Facts carried by an ordinary SSA binding participate in the direct proof.
// LOWER-LABEL: func.func @fact_proven_destination_forms_dma
// LOWER: wave.read_first
// LOWER: waveamd.dma_load_lds
// LOWER-NOT: wave.gather
// LOWER-NOT: wave.scatter
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
  func.func @fact_proven_destination_forms_dma(
      %source: !wave.ptr<#wave.global, i32>,
      %destination: !wave.ptr<#wave.shared, i32>,
      %bias_raw: !wave.simd<i32, 64>)
      attributes {wave.workgroup_size = array<i32: 256, 1, 1>} {
    %item = wave.workitem_id 0 : !wave.simd<i32, 64>
    %bounded_item = wave.index_expr <"item"> assuming
        [#wave.pred<"item >= 0">, #wave.pred<"item <= 255">]
        ["item"](%item)
        : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
    %bias = wave.index_expr <"bias"> assuming [#wave.pred<"bias == 0">]
        ["bias"](%bias_raw)
        : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
    %value, %loaded = wave.gather %source mapping
        <bit_offset = <"32*(4*item + slot)">>
        bindings ["item"](%bounded_item)
        : (!wave.ptr<#wave.global, i32>, !wave.simd<index, 64>)
        -> (!wave.simd<vector<4xi32>, 64>, !wave.mem.token)
    %stored = wave.scatter %value to %destination mapping
        <bit_offset = <"32*(bias + 4*item + slot)">>
        bindings ["item", "bias"](%bounded_item, %bias)
        after %loaded
        : (!wave.simd<vector<4xi32>, 64>, !wave.ptr<#wave.shared, i32>,
           !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.mem.token)
        -> !wave.mem.token
    return
  }
}

// -----

// A blocked packet is linear across lane and slot rather than within one
// lane's slots. The full-wave quotient/remainder coordinate change is a
// bijection, so source and destination can share one direct transaction.
// LOWER-LABEL: func.func @lane_slot_linearized_copy_forms_dma
// LOWER-NOT: wave.load
// LOWER-NOT: wave.store
// LOWER: [[SOURCE_BYTES:%.*]] = wave.ptr_cast %arg0
// LOWER: [[SOURCE_OFFSET:%.*]] = wave.index_expr <"16*source_item">
// LOWER: [[SOURCE:%.*]] = wave.ptr_add [[SOURCE_BYTES]], [[SOURCE_OFFSET]]
// LOWER: [[DEST_BYTES:%.*]] = wave.ptr_cast %arg1
// LOWER: [[DEST_OFFSET:%.*]] = wave.constant 0 : index
// LOWER: [[DEST:%.*]] = wave.ptr_add [[DEST_BYTES]], [[DEST_OFFSET]]
// LOWER: waveamd.dma_load_lds
// LOWER-SAME: bytes = 16
// LOWER-NOT: wave.load
// LOWER-NOT: wave.store
// LOWER-NOT: wave.gather
// LOWER-NOT: wave.scatter
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
  func.func @lane_slot_linearized_copy_forms_dma(
      %source: !wave.ptr<#wave.global, f16>,
      %destination: !wave.ptr<#wave.shared, f16>)
      attributes {wave.workgroup_size = array<i32: 64, 1, 1>} {
    %item = wave.workitem_id 0 : !wave.simd<i32, 64>
    %bounded_item = wave.index_expr <"item"> assuming
        [#wave.pred<"item >= 0">, #wave.pred<"item <= 63">]
        ["item"](%item)
        : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
    %value, %loaded = wave.gather %source mapping
        <bit_offset = <"16*(item + 64*slot)">>
        bindings ["item"](%bounded_item)
        : (!wave.ptr<#wave.global, f16>, !wave.simd<index, 64>)
        -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
    %stored = wave.scatter %value to %destination mapping
        <bit_offset = <"16*(item + 64*slot)">>
        bindings ["item"](%bounded_item) after %loaded
        : (!wave.simd<vector<8xf16>, 64>, !wave.ptr<#wave.shared, f16>,
           !wave.simd<index, 64>, !wave.mem.token) -> !wave.mem.token
    return
  }
}

// -----

// The shared layout may permute whole lane-sized blocks while preserving one
// contiguous transaction per executing lane. Rank the bounded blocks and
// recover that ownership permutation instead of scalarizing the copy.
// LOWER-LABEL: func.func @bit_permuted_lane_blocks_form_dma
// LOWER-NOT: wave.load
// LOWER-NOT: wave.store
// LOWER: waveamd.dma_load_lds
// LOWER-SAME: bytes = 16
// LOWER-NOT: wave.gather
// LOWER-NOT: wave.scatter
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
  func.func @bit_permuted_lane_blocks_form_dma(
      %source: !wave.ptr<#wave.global, f16>,
      %destination: !wave.ptr<#wave.shared, f16>)
      attributes {wave.workgroup_size = array<i32: 64, 1, 1>} {
    %item = wave.workitem_id 0 : !wave.simd<i32, 64>
    %bounded_item = wave.index_expr <"item"> assuming
        [#wave.pred<"item >= 0">, #wave.pred<"item <= 63">]
        ["item"](%item)
        : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
    %value, %loaded = wave.gather %source mapping
        <bit_offset = <"16*(8*item + slot)">>
        bindings ["item"](%bounded_item)
        : (!wave.ptr<#wave.global, f16>, !wave.simd<index, 64>)
        -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
    %stored = wave.scatter %value to %destination mapping
        <bit_offset = <"16*(8*(xor(Mod(item, 2), Mod(floor(1/2*item), 2)) + 2*floor(1/2*item)) + slot)">>
        bindings ["item"](%bounded_item) after %loaded
        : (!wave.simd<vector<8xf16>, 64>, !wave.ptr<#wave.shared, f16>,
           !wave.simd<index, 64>, !wave.mem.token) -> !wave.mem.token
    return
  }
}

// -----

// A single ownership coordinate must make both sides contiguous. A blocked
// source and lane-major destination have no such transaction in this model.
// LOWER-LABEL: func.func @incompatible_lane_slot_layouts_fall_back
// LOWER-NOT: waveamd.dma_load_lds
// LOWER: wave.load
// LOWER: wave.store
// LOWER-NOT: wave.gather
// LOWER-NOT: wave.scatter
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
  func.func @incompatible_lane_slot_layouts_fall_back(
      %source: !wave.ptr<#wave.global, f16>,
      %destination: !wave.ptr<#wave.shared, f16>)
      attributes {wave.workgroup_size = array<i32: 64, 1, 1>} {
    %item = wave.workitem_id 0 : !wave.simd<i32, 64>
    %bounded_item = wave.index_expr <"item"> assuming
        [#wave.pred<"item >= 0">, #wave.pred<"item <= 63">]
        ["item"](%item)
        : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
    %value, %loaded = wave.gather %source mapping
        <bit_offset = <"16*(item + 64*slot)">>
        bindings ["item"](%bounded_item)
        : (!wave.ptr<#wave.global, f16>, !wave.simd<index, 64>)
        -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
    %stored = wave.scatter %value to %destination mapping
        <bit_offset = <"16*(8*item + slot)">>
        bindings ["item"](%bounded_item) after %loaded
        : (!wave.simd<vector<8xf16>, 64>, !wave.ptr<#wave.shared, f16>,
           !wave.simd<index, 64>, !wave.mem.token) -> !wave.mem.token
    return
  }
}

// -----

// The lane/slot ownership permutation requires a complete executing wave. An
// enclosing divergent region can deactivate lanes which own remapped logical
// points, so the direct pair stays on ordinary predicated memory operations.
// LOWER-LABEL: func.func @lane_slot_copy_inside_where_falls_back
// LOWER: wave.where
// LOWER-NOT: waveamd.dma_load_lds
// LOWER: wave.load
// LOWER: wave.store
// LOWER-NOT: waveamd.dma_load_lds
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
  func.func @lane_slot_copy_inside_where_falls_back(
      %source: !wave.ptr<#wave.global, f16>,
      %destination: !wave.ptr<#wave.shared, f16>, %active: !wave.mask<64>)
      attributes {wave.workgroup_size = array<i32: 64, 1, 1>} {
    %item = wave.workitem_id 0 : !wave.simd<i32, 64>
    %bounded_item = wave.index_expr <"item"> assuming
        [#wave.pred<"item >= 0">, #wave.pred<"item <= 63">]
        ["item"](%item)
        : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
    wave.where %active {
      %value, %loaded = wave.gather %source mapping
          <bit_offset = <"16*(item + 64*slot)">>
          bindings ["item"](%bounded_item)
          : (!wave.ptr<#wave.global, f16>, !wave.simd<index, 64>)
          -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %stored = wave.scatter %value to %destination mapping
          <bit_offset = <"16*(item + 64*slot)">>
          bindings ["item"](%bounded_item) after %loaded
          : (!wave.simd<vector<8xf16>, 64>, !wave.ptr<#wave.shared, f16>,
             !wave.simd<index, 64>, !wave.mem.token) -> !wave.mem.token
      wave.yield
    } : !wave.mask<64>
    return
  }
}

// -----

// A workgroup tail does not supply a complete final wave for the ownership
// permutation, even when the explicit item packet itself has a wave-wide type.
// LOWER-LABEL: func.func @lane_slot_copy_with_partial_wave_falls_back
// LOWER-NOT: waveamd.dma_load_lds
// LOWER: wave.load
// LOWER: wave.store
// LOWER-NOT: waveamd.dma_load_lds
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
  func.func @lane_slot_copy_with_partial_wave_falls_back(
      %source: !wave.ptr<#wave.global, f16>,
      %destination: !wave.ptr<#wave.shared, f16>)
      attributes {wave.workgroup_size = array<i32: 96, 1, 1>} {
    %raw_item = wave.workitem_id 0 : !wave.simd<i32, 64>
    %bounded_item = wave.index_expr <"raw_item"> assuming
        [#wave.pred<"raw_item >= 0">, #wave.pred<"raw_item <= 127">]
        ["raw_item"](%raw_item)
        : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
    %value, %loaded = wave.gather %source mapping
        <bit_offset = <"16*(item + 64*slot)">>
        bindings ["item"](%bounded_item)
        : (!wave.ptr<#wave.global, f16>, !wave.simd<index, 64>)
        -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
    %stored = wave.scatter %value to %destination mapping
        <bit_offset = <"16*(item + 64*slot)">>
        bindings ["item"](%bounded_item) after %loaded
        : (!wave.simd<vector<8xf16>, 64>, !wave.ptr<#wave.shared, f16>,
           !wave.simd<index, 64>, !wave.mem.token) -> !wave.mem.token
    return
  }
}

// -----

// A flat 64-thread workgroup is not a complete axis-0 item domain when its X
// extent is 32. The two Y rows duplicate item IDs 0..31 within one wave.
// LOWER-LABEL: func.func @lane_slot_copy_with_multidimensional_wave_falls_back
// LOWER-NOT: waveamd.dma_load_lds
// LOWER: wave.load
// LOWER: wave.store
// LOWER-NOT: waveamd.dma_load_lds
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
  func.func @lane_slot_copy_with_multidimensional_wave_falls_back(
      %source: !wave.ptr<#wave.global, f16>,
      %destination: !wave.ptr<#wave.shared, f16>)
      attributes {wave.workgroup_size = array<i32: 32, 2, 1>} {
    %raw_item = wave.workitem_id 0 : !wave.simd<i32, 64>
    %bounded_item = wave.index_expr <"raw_item"> assuming
        [#wave.pred<"raw_item >= 0">, #wave.pred<"raw_item <= 63">]
        ["raw_item"](%raw_item)
        : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
    %value, %loaded = wave.gather %source mapping
        <bit_offset = <"16*(item + 64*slot)">>
        bindings ["item"](%bounded_item)
        : (!wave.ptr<#wave.global, f16>, !wave.simd<index, 64>)
        -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
    %stored = wave.scatter %value to %destination mapping
        <bit_offset = <"16*(item + 64*slot)">>
        bindings ["item"](%bounded_item) after %loaded
        : (!wave.simd<vector<8xf16>, 64>, !wave.ptr<#wave.shared, f16>,
           !wave.simd<index, 64>, !wave.mem.token) -> !wave.mem.token
    return
  }
}

// -----

// A free lane-valued binding is not part of the item/slot ownership map. The
// blocked copy must not evaluate that binding at a different logical lane.
// LOWER-LABEL: func.func @lane_slot_copy_with_lane_bias_falls_back
// LOWER-NOT: waveamd.dma_load_lds
// LOWER: wave.load
// LOWER: wave.store
// LOWER-NOT: waveamd.dma_load_lds
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
  func.func @lane_slot_copy_with_lane_bias_falls_back(
      %source: !wave.ptr<#wave.global, f16>,
      %destination: !wave.ptr<#wave.shared, f16>,
      %bias_raw: !wave.simd<i32, 64>)
      attributes {wave.workgroup_size = array<i32: 64, 1, 1>} {
    %item = wave.workitem_id 0 : !wave.simd<i32, 64>
    %bounded_item = wave.index_expr <"item"> assuming
        [#wave.pred<"item >= 0">, #wave.pred<"item <= 63">]
        ["item"](%item)
        : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
    %bias = wave.index_expr <"bias"> assuming
        [#wave.pred<"bias >= 0">, #wave.pred<"bias <= 15">]
        ["bias"](%bias_raw)
        : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
    %value, %loaded = wave.gather %source mapping
        <bit_offset = <"16*(bias + item + 64*slot)">>
        bindings ["item", "bias"](%bounded_item, %bias)
        : (!wave.ptr<#wave.global, f16>, !wave.simd<index, 64>,
           !wave.simd<index, 64>)
        -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
    %stored = wave.scatter %value to %destination mapping
        <bit_offset = <"16*(item + 64*slot)">>
        bindings ["item"](%bounded_item) after %loaded
        : (!wave.simd<vector<8xf16>, 64>, !wave.ptr<#wave.shared, f16>,
           !wave.simd<index, 64>, !wave.mem.token) -> !wave.mem.token
    return
  }
}

// -----

// The workitem intrinsic and launch metadata jointly define the direct DMA
// execution domain.
// LOWER-LABEL: func.func @metadata_only_item_falls_back
// LOWER-NOT: wave.load
// LOWER-NOT: wave.store
// LOWER: waveamd.dma_load_lds
// LOWER-SAME: bytes = 16
// LOWER-NOT: wave.gather
// LOWER-NOT: wave.scatter
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
  func.func @metadata_only_item_falls_back(
      %source: !wave.ptr<#wave.global, i32>,
      %destination: !wave.ptr<#wave.shared, i32>)
      attributes {wave.workgroup_size = array<i32: 64, 1, 1>} {
    %item = wave.workitem_id 0 : !wave.simd<i32, 64>
    %value, %loaded = wave.gather %source mapping
        <bit_offset = <"32*(4*item + slot)">> bindings ["item"](%item)
        : (!wave.ptr<#wave.global, i32>, !wave.simd<i32, 64>)
        -> (!wave.simd<vector<4xi32>, 64>, !wave.mem.token)
    %stored = wave.scatter %value to %destination mapping
        <bit_offset = <"32*(4*item + slot)">> bindings ["item"](%item) after %loaded
        : (!wave.simd<vector<4xi32>, 64>, !wave.ptr<#wave.shared, i32>,
           !wave.simd<i32, 64>, !wave.mem.token) -> !wave.mem.token
    return
  }
}

// -----

// Buffer zero fill is still a direct DMA property of the parent where.
// LOWER-LABEL: func.func @buffer_zero_fill
// LOWER: wave.where
// LOWER: waveamd.dma_load_lds
// LOWER-SAME: bytes = 16
// LOWER-SAME: zero_fill_inactive
// ZF-LABEL: func.func @buffer_zero_fill
// ZF: [[ACTIVE:%.*]] = wave.cmpi slt
// ZF-NOT: wave.where
// ZF: [[SELECTED:%.*]] = wave.select [[ACTIVE]]
// ZF: waveamd.dma_load_lds [[SELECTED]]
// ZF-SAME: bytes = 16
// ZF-NOT: zero_fill_inactive
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
  func.func @buffer_zero_fill(%source: !wave.ptr<#wave.global, i32>,
                              %destination: !wave.ptr<#wave.shared, i32>,
                              %limit_raw: i32)
      attributes {wave.workgroup_size = array<i32: 64, 1, 1>} {
    %item = wave.workitem_id 0 : !wave.simd<i32, 64>
    %bounded_item = wave.index_expr <"item"> assuming
        [#wave.pred<"item >= 0">, #wave.pred<"item <= 63">]
        ["item"](%item)
        : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
    %range = arith.constant 4096 : i32
    %buffer = waveamd.make_buffer %source, %range
        : !wave.ptr<#wave.global, i32>, i32
        -> !wave.ptr<#waveamd.buffer, i32>
    %dependency = wave.token : !wave.mem.token
    %zero = wave.constant 0 : i32 -> !wave.simd<i32, 64>
    %same_item = wave.binary addi %item, %zero overflow<nsw>
        : !wave.simd<i32, 64>, !wave.simd<i32, 64>
        -> !wave.simd<i32, 64>
    %limit = wave.splat %limit_raw : i32 -> !wave.simd<i32, 64>
    %active0 = wave.cmpi slt %item, %limit
        : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
    %active1 = wave.cmpi slt %same_item, %limit
        : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
    %fallback = wave.pack %zero, %zero, %zero, %zero
        : !wave.simd<i32, 64>, !wave.simd<i32, 64>,
          !wave.simd<i32, 64>, !wave.simd<i32, 64>
        -> !wave.simd<vector<4xi32>, 64>
    %copy:2 = wave.where %active0, %active1, %active0, %active1 {
      %value, %loaded = wave.gather %buffer mapping
          <bit_offset = <"32*(4*item + slot)">>
          bindings ["item"](%bounded_item)
          after %dependency
          : (!wave.ptr<#waveamd.buffer, i32>, !wave.simd<index, 64>,
             !wave.mem.token)
          -> (!wave.simd<vector<4xi32>, 64>, !wave.mem.token)
      wave.yield %value, %loaded
          : !wave.simd<vector<4xi32>, 64>, !wave.mem.token
    } otherwise {
      wave.yield %fallback, %dependency
          : !wave.simd<vector<4xi32>, 64>, !wave.mem.token
    } : !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>
        -> !wave.simd<vector<4xi32>, 64>, !wave.mem.token
    %stored = wave.scatter %copy#0 to %destination mapping
        <bit_offset = <"32*(4*item + slot)">>
        bindings ["item"](%bounded_item) after %copy#1
        : (!wave.simd<vector<4xi32>, 64>, !wave.ptr<#wave.shared, i32>,
           !wave.simd<index, 64>, !wave.mem.token) -> !wave.mem.token
    return
  }
}

// -----

// Packet activity may partition a zero-fill copy only at complete hardware
// transaction boundaries. Two four-element i32 domains form two 16-byte DMAs.
// LOWER-LABEL: func.func @aligned_activity_domains_form_dma(
// LOWER-SAME: [[SOURCE_ARG:%.*]]: !wave.ptr<#wave.global, i32>, [[DEST_ARG:%.*]]: !wave.ptr<#wave.shared, i32>, [[FIRST:%.*]]: !wave.mask<64>, [[SECOND:%.*]]: !wave.mask<64>)
// LOWER-NOT: wave.load
// LOWER-NOT: wave.store
// LOWER: [[DOMAIN_DEP:%.*]] = wave.token
// LOWER: [[SOURCE0:%.*]] = wave.ptr_add
// LOWER: [[DEST0:%.*]] = wave.ptr_cast [[DEST_ARG]]
// LOWER: [[DOMAIN0:%.*]] = wave.where [[FIRST]]
// LOWER: [[DMA_DEST0:%.*]] = wave.ptr_cast [[DEST0]]
// LOWER: waveamd.dma_load_lds [[SOURCE0]] -> [[DMA_DEST0]] after [[DOMAIN_DEP]]
// LOWER-SAME: bytes = 16
// LOWER-SAME: zero_fill_inactive
// LOWER: [[SOURCE_DELTA:%.*]] = wave.constant 1024 : index
// LOWER: [[SOURCE1:%.*]] = wave.ptr_add [[SOURCE0]], [[SOURCE_DELTA]]
// LOWER: [[DEST_DELTA:%.*]] = wave.constant 1024 : index
// LOWER: [[DEST1:%.*]] = wave.ptr_add [[DEST0]], [[DEST_DELTA]]
// LOWER: [[DOMAIN1:%.*]] = wave.where [[SECOND]]
// LOWER: [[DMA_DEST1:%.*]] = wave.ptr_cast [[DEST1]]
// LOWER: waveamd.dma_load_lds [[SOURCE1]] -> [[DMA_DEST1]] after [[DOMAIN_DEP]]
// LOWER-SAME: bytes = 16
// LOWER-SAME: zero_fill_inactive
// LOWER: wave.join [[DOMAIN0]], [[DOMAIN1]]
// LOWER-NOT: wave.load
// LOWER-NOT: wave.store
// LOWER-NOT: waveamd.dma_load_lds
// LOWER-NOT: wave.gather
// LOWER-NOT: wave.scatter
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
  func.func @aligned_activity_domains_form_dma(
      %source: !wave.ptr<#wave.global, i32>,
      %destination: !wave.ptr<#wave.shared, i32>,
      %first: !wave.mask<64>, %second: !wave.mask<64>)
      attributes {wave.workgroup_size = array<i32: 64, 1, 1>} {
    %item = wave.workitem_id 0 : !wave.simd<i32, 64>
    %bounded_item = wave.index_expr <"item"> assuming
        [#wave.pred<"item >= 0">, #wave.pred<"item <= 63">]
        ["item"](%item)
        : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
    %range = arith.constant 4096 : i32
    %buffer = waveamd.make_buffer %source, %range
        : !wave.ptr<#wave.global, i32>, i32
        -> !wave.ptr<#waveamd.buffer, i32>
    %dependency = wave.token : !wave.mem.token
    %zero = wave.constant 0 : i32 -> !wave.simd<i32, 64>
    %fallback = wave.pack %zero, %zero, %zero, %zero,
                          %zero, %zero, %zero, %zero
        : !wave.simd<i32, 64>, !wave.simd<i32, 64>,
          !wave.simd<i32, 64>, !wave.simd<i32, 64>,
          !wave.simd<i32, 64>, !wave.simd<i32, 64>,
          !wave.simd<i32, 64>, !wave.simd<i32, 64>
        -> !wave.simd<vector<8xi32>, 64>
    %copy:2 = wave.where %first, %first, %first, %first,
                         %second, %second, %second, %second {
      %value, %loaded = wave.gather %buffer mapping
          <bit_offset = <"32*(4*item + Mod(slot, 4) + 256*floor(slot/4))">>
          bindings ["item"](%bounded_item) after %dependency
          : (!wave.ptr<#waveamd.buffer, i32>, !wave.simd<index, 64>,
             !wave.mem.token)
          -> (!wave.simd<vector<8xi32>, 64>, !wave.mem.token)
      wave.yield %value, %loaded
          : !wave.simd<vector<8xi32>, 64>, !wave.mem.token
    } otherwise {
      wave.yield %fallback, %dependency
          : !wave.simd<vector<8xi32>, 64>, !wave.mem.token
    } : !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>,
        !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>
        -> !wave.simd<vector<8xi32>, 64>, !wave.mem.token
    %stored = wave.scatter %copy#0 to %destination mapping
        <bit_offset = <"32*(4*item + Mod(slot, 4) + 256*floor(slot/4))">>
        bindings ["item"](%bounded_item) after %copy#1
        : (!wave.simd<vector<8xi32>, 64>, !wave.ptr<#wave.shared, i32>,
           !wave.simd<index, 64>, !wave.mem.token) -> !wave.mem.token
    return
  }
}

// -----

// The same copy split after two elements crosses a four-element DMA fiber.
// The entire DMA candidate declines and ordinary lowering remains.
// LOWER-LABEL: func.func @misaligned_activity_domains_fall_back
// LOWER-NOT: waveamd.dma_load_lds
// LOWER: wave.load
// LOWER-NOT: waveamd.dma_load_lds
// LOWER: wave.store
// LOWER-NOT: waveamd.dma_load_lds
// LOWER-NOT: wave.gather
// LOWER-NOT: wave.scatter
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
  func.func @misaligned_activity_domains_fall_back(
      %source: !wave.ptr<#wave.global, i32>,
      %destination: !wave.ptr<#wave.shared, i32>,
      %first: !wave.mask<64>, %second: !wave.mask<64>)
      attributes {wave.workgroup_size = array<i32: 64, 1, 1>} {
    %item = wave.workitem_id 0 : !wave.simd<i32, 64>
    %bounded_item = wave.index_expr <"item"> assuming
        [#wave.pred<"item >= 0">, #wave.pred<"item <= 63">]
        ["item"](%item)
        : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
    %range = arith.constant 4096 : i32
    %buffer = waveamd.make_buffer %source, %range
        : !wave.ptr<#wave.global, i32>, i32
        -> !wave.ptr<#waveamd.buffer, i32>
    %dependency = wave.token : !wave.mem.token
    %zero = wave.constant 0 : i32 -> !wave.simd<i32, 64>
    %fallback = wave.pack %zero, %zero, %zero, %zero,
                          %zero, %zero, %zero, %zero
        : !wave.simd<i32, 64>, !wave.simd<i32, 64>,
          !wave.simd<i32, 64>, !wave.simd<i32, 64>,
          !wave.simd<i32, 64>, !wave.simd<i32, 64>,
          !wave.simd<i32, 64>, !wave.simd<i32, 64>
        -> !wave.simd<vector<8xi32>, 64>
    %copy:2 = wave.where %first, %first, %second, %second,
                         %second, %second, %second, %second {
      %value, %loaded = wave.gather %buffer mapping
          <bit_offset = <"32*(4*item + Mod(slot, 4) + 256*floor(slot/4))">>
          bindings ["item"](%bounded_item) after %dependency
          : (!wave.ptr<#waveamd.buffer, i32>, !wave.simd<index, 64>,
             !wave.mem.token)
          -> (!wave.simd<vector<8xi32>, 64>, !wave.mem.token)
      wave.yield %value, %loaded
          : !wave.simd<vector<8xi32>, 64>, !wave.mem.token
    } otherwise {
      wave.yield %fallback, %dependency
          : !wave.simd<vector<8xi32>, 64>, !wave.mem.token
    } : !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>,
        !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>
        -> !wave.simd<vector<8xi32>, 64>, !wave.mem.token
    %stored = wave.scatter %copy#0 to %destination mapping
        <bit_offset = <"32*(4*item + Mod(slot, 4) + 256*floor(slot/4))">>
        bindings ["item"](%bounded_item) after %copy#1
        : (!wave.simd<vector<8xi32>, 64>, !wave.ptr<#wave.shared, i32>,
           !wave.simd<index, 64>, !wave.mem.token) -> !wave.mem.token
    return
  }
}

// -----

// An unbounded buffer origin cannot satisfy the complete transaction window.
// DMA declines before rewriting and ordinary load/store lowering remains.
// LOWER-LABEL: func.func @unbounded_buffer_origin_falls_back
// LOWER-NOT: waveamd.dma_load_lds
// LOWER: wave.load
// LOWER: wave.store
// LOWER-NOT: wave.gather
// LOWER-NOT: wave.scatter
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
  func.func @unbounded_buffer_origin_falls_back(
      %source: !wave.ptr<#wave.global, i32>,
      %destination: !wave.ptr<#wave.shared, i32>, %bias: i32)
      attributes {wave.workgroup_size = array<i32: 64, 1, 1>} {
    %item = wave.workitem_id 0 : !wave.simd<i32, 64>
    %bounded_item = wave.index_expr <"item"> assuming
        [#wave.pred<"item >= 0">, #wave.pred<"item <= 63">]
        ["item"](%item)
        : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
    %range = arith.constant 4096 : i32
    %buffer = waveamd.make_buffer %source, %range
        : !wave.ptr<#wave.global, i32>, i32
        -> !wave.ptr<#waveamd.buffer, i32>
    %value, %loaded = wave.gather %buffer mapping
        <bit_offset = <"32*(bias + 4*item + slot)">>
        bindings ["item", "bias"](%bounded_item, %bias)
        : (!wave.ptr<#waveamd.buffer, i32>, !wave.simd<index, 64>, i32)
        -> (!wave.simd<vector<4xi32>, 64>, !wave.mem.token)
    %stored = wave.scatter %value to %destination mapping
        <bit_offset = <"32*(4*item + slot)">>
        bindings ["item"](%bounded_item) after %loaded
        : (!wave.simd<vector<4xi32>, 64>, !wave.ptr<#wave.shared, i32>,
           !wave.simd<index, 64>, !wave.mem.token) -> !wave.mem.token
    return
  }
}

// -----

// A parent where is the explicit execution condition and may contain a direct
// DMA pair. No adjacent assume/select operation supplies layout information.
// LOWER-LABEL: func.func @parent_where_copy
// LOWER: wave.where
// LOWER: waveamd.dma_load_lds
// LOWER-NOT: wave.gather
// LOWER-NOT: wave.scatter
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
  func.func @parent_where_copy(%source: !wave.ptr<#wave.global, i32>,
                               %destination: !wave.ptr<#wave.shared, i32>,
                               %active: !wave.mask<64>)
      attributes {wave.workgroup_size = array<i32: 64, 1, 1>} {
    %item = wave.workitem_id 0 : !wave.simd<i32, 64>
    %bounded_item = wave.index_expr <"item"> assuming
        [#wave.pred<"item >= 0">, #wave.pred<"item <= 63">]
        ["item"](%item)
        : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
    wave.where %active {
      %value, %loaded = wave.gather %source mapping
          <bit_offset = <"32*(4*item + slot)">>
          bindings ["item"](%bounded_item)
          : (!wave.ptr<#wave.global, i32>, !wave.simd<index, 64>)
          -> (!wave.simd<vector<4xi32>, 64>, !wave.mem.token)
      %stored = wave.scatter %value to %destination mapping
          <bit_offset = <"32*(4*item + slot)">>
          bindings ["item"](%bounded_item) after %loaded
          : (!wave.simd<vector<4xi32>, 64>, !wave.ptr<#wave.shared, i32>,
             !wave.simd<index, 64>, !wave.mem.token) -> !wave.mem.token
      wave.yield
    } : !wave.mask<64>
    return
  }
}

// -----

// Identically shaped but distinct workitem SSA chains are not aliases.
// LOWER-LABEL: func.func @distinct_item_bindings_fall_back
// LOWER-NOT: waveamd.dma_load_lds
// LOWER: wave.load
// LOWER: wave.store
// LOWER-NOT: wave.gather
// LOWER-NOT: wave.scatter
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
  func.func @distinct_item_bindings_fall_back(
      %source: !wave.ptr<#wave.global, i32>,
      %destination: !wave.ptr<#wave.shared, i32>)
      attributes {wave.workgroup_size = array<i32: 64, 1, 1>} {
    %source_raw = wave.workitem_id 0 : !wave.simd<i32, 64>
    %source_item = wave.index_expr <"item"> assuming
        [#wave.pred<"item >= 0">, #wave.pred<"item <= 63">]
        ["item"](%source_raw)
        : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
    %destination_raw = wave.workitem_id 0 : !wave.simd<i32, 64>
    %destination_item = wave.index_expr <"item"> assuming
        [#wave.pred<"item >= 0">, #wave.pred<"item <= 63">]
        ["item"](%destination_raw)
        : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
    %value, %loaded = wave.gather %source mapping
        <bit_offset = <"32*(4*item + slot)">>
        bindings ["item"](%source_item)
        : (!wave.ptr<#wave.global, i32>, !wave.simd<index, 64>)
        -> (!wave.simd<vector<4xi32>, 64>, !wave.mem.token)
    %stored = wave.scatter %value to %destination mapping
        <bit_offset = <"32*(4*item + slot)">>
        bindings ["item"](%destination_item) after %loaded
        : (!wave.simd<vector<4xi32>, 64>, !wave.ptr<#wave.shared, i32>,
           !wave.simd<index, 64>, !wave.mem.token) -> !wave.mem.token
    return
  }
}

// -----

// The target provider declines DMA on an unsupported architecture, while the
// same direct maps continue through ordinary lowering.
// LOWER-LABEL: func.func @unsupported_target_falls_back
// LOWER-NOT: waveamd.dma_load_lds
// LOWER: wave.load
// LOWER: wave.store
// LOWER-NOT: wave.gather
// LOWER-NOT: wave.scatter
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1250"} {
  func.func @unsupported_target_falls_back(
      %source: !wave.ptr<#wave.global, i32>,
      %destination: !wave.ptr<#wave.shared, i32>)
      attributes {wave.workgroup_size = array<i32: 32, 1, 1>} {
    %item = wave.workitem_id 0 : !wave.simd<i32, 32>
    %bounded_item = wave.assume %item as "item"
        [#wave.pred<"item >= 0">, #wave.pred<"item <= 31">]
        : !wave.simd<i32, 32>
    %value, %loaded = wave.gather %source mapping
        <bit_offset = <"32*(4*item + slot)">>
        bindings ["item"](%bounded_item)
        : (!wave.ptr<#wave.global, i32>, !wave.simd<i32, 32>)
        -> (!wave.simd<vector<4xi32>, 32>, !wave.mem.token)
    %stored = wave.scatter %value to %destination mapping
        <bit_offset = <"32*(4*item + slot)">>
        bindings ["item"](%bounded_item) after %loaded
        : (!wave.simd<vector<4xi32>, 32>, !wave.ptr<#wave.shared, i32>,
           !wave.simd<i32, 32>, !wave.mem.token) -> !wave.mem.token
    return
  }
}
