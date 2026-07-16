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

// CHECK-LABEL: func.func @gfx950_b16_xor_transpose(
// CHECK-NOT: wave.load
// CHECK: wave.ptr_cast
// CHECK: wave.index_expr
// CHECK: wave.ptr_add
// CHECK: wave.ptr_cast
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
