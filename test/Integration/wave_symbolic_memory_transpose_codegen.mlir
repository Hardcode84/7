// RUN: wave-translate --wave-to-amdgpu-asm %s | FileCheck %s --check-prefix=ASM
// RUN: wave-translate --wave-to-amdgpu-asm %s \
// RUN:   | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx950 -filetype=obj -o /dev/null

// ASM-LABEL: symbolic_memory_transpose_codegen:
// ASM-COUNT-1: ds_read_b64_tr_b8
// ASM: s_endpgm
// ASM-LABEL: symbolic_memory_strided_transpose_codegen:
// ASM-COUNT-1: ds_read_b64_tr_b8
// ASM: s_endpgm
// ASM-LABEL: symbolic_memory_b16_transpose_codegen:
// ASM-COUNT-1: ds_read_b64_tr_b16
// ASM: s_endpgm
// ASM-LABEL: symbolic_memory_b16_xor_origin_codegen:
// ASM-COUNT-1: ds_read_b64_tr_b16
// ASM: s_endpgm

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
  func.func @symbolic_memory_transpose_codegen(
      %dst: !wave.ptr<#wave.global, i8>)
      attributes {wave.kernel,
                  wave.workgroup_size = array<i32: 64, 1, 1>,
                  wave.waves_per_workgroup = 1 : i64} {
    %lds = wave.alloc() {align = 16 : i64, bytesize = 512 : i64}
        : !wave.ptr<#wave.shared, i8>
    %value, %token = wave.gather %lds mapping
        <bit_offset = <"8 * (128 * floor(Mod(item, 64) / 16) + 4 * Mod(item, 16) + floor(slot / 2))">>
        bindings []() packet_bindings []()
        : (!wave.ptr<#wave.shared, i8>)
        -> (!wave.simd<vector<8xi8>, 64>, !wave.mem.token)
    %first = wave.extract %value[0]
        : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
    %item = wave.workitem_id 0 : !wave.simd<i32, 64>
    %out = wave.ptr_add %dst, %item
        : !wave.ptr<#wave.global, i8>, !wave.simd<i32, 64>
        -> !wave.simd<!wave.ptr<#wave.global, i8>, 64>
    %stored = wave.store %first -> %out after %token
        : (!wave.simd<i8, 64>, !wave.simd<!wave.ptr<#wave.global, i8>, 64>,
           !wave.mem.token) -> !wave.mem.token
    return
  }

  func.func @symbolic_memory_strided_transpose_codegen(
      %dst: !wave.ptr<#wave.global, i8>)
      attributes {wave.kernel,
                  wave.workgroup_size = array<i32: 64, 1, 1>,
                  wave.waves_per_workgroup = 1 : i64} {
    %lds = wave.alloc() {align = 16 : i64, bytesize = 1024 : i64}
        : !wave.ptr<#wave.shared, i8>
    %value, %token = wave.gather %lds mapping
        <bit_offset = <"8 * (256 * floor(Mod(item, 64) / 16) + 16 * floor(Mod(item, 16) / 2) + 4 * Mod(item, 2) + floor(slot / 2))">>
        bindings []() packet_bindings []()
        : (!wave.ptr<#wave.shared, i8>)
        -> (!wave.simd<vector<8xi8>, 64>, !wave.mem.token)
    %first = wave.extract %value[0]
        : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
    %item = wave.workitem_id 0 : !wave.simd<i32, 64>
    %out = wave.ptr_add %dst, %item
        : !wave.ptr<#wave.global, i8>, !wave.simd<i32, 64>
        -> !wave.simd<!wave.ptr<#wave.global, i8>, 64>
    %stored = wave.store %first -> %out after %token
        : (!wave.simd<i8, 64>, !wave.simd<!wave.ptr<#wave.global, i8>, 64>,
           !wave.mem.token) -> !wave.mem.token
    return
  }

  func.func @symbolic_memory_b16_transpose_codegen(
      %dst: !wave.ptr<#wave.global, f16>)
      attributes {wave.kernel,
                  wave.workgroup_size = array<i32: 64, 1, 1>,
                  wave.waves_per_workgroup = 1 : i64} {
    %lds = wave.alloc() {align = 16 : i64, bytesize = 1024 : i64}
        : !wave.ptr<#wave.shared, f16>
    %value, %token = wave.gather %lds mapping
        <bit_offset = <"16 * (8 * (item - Mod(item, 64) + 16 * floor(Mod(item, 64) / 16) + floor(Mod(item, 16) / 4) + 4 * slot) + Mod(item, 4))">>
        bindings []() packet_bindings []()
        : (!wave.ptr<#wave.shared, f16>)
        -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
    %first = wave.extract %value[0]
        : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
    %item = wave.workitem_id 0 : !wave.simd<i32, 64>
    %out = wave.ptr_add %dst, %item
        : !wave.ptr<#wave.global, f16>, !wave.simd<i32, 64>
        -> !wave.simd<!wave.ptr<#wave.global, f16>, 64>
    %stored = wave.store %first -> %out after %token
        : (!wave.simd<f16, 64>, !wave.simd<!wave.ptr<#wave.global, f16>, 64>,
           !wave.mem.token) -> !wave.mem.token
    return
  }

  func.func @symbolic_memory_b16_xor_origin_codegen(
      %dst: !wave.ptr<#wave.global, f16>, %origin: i32)
      attributes {wave.kernel,
                  wave.workgroup_size = array<i32: 64, 1, 1>,
                  wave.waves_per_workgroup = 1 : i64} {
    %lds = wave.alloc() {align = 16 : i64, bytesize = 1024 : i64}
        : !wave.ptr<#wave.shared, f16>
    %value, %token = wave.gather %lds mapping
        <bit_offset = <"16 * (origin + xor(item - Mod(item, 64) + 16 * floor(Mod(item, 64) / 16) + floor(Mod(item, 16) / 4) + 4 * slot, floor((item - Mod(item, 64) + 16 * floor(Mod(item, 64) / 16) + floor(Mod(item, 16) / 4) + 4 * slot) / 2)) + Mod(item, 4))">>
        bindings ["origin"](%origin) packet_bindings []()
        : (!wave.ptr<#wave.shared, f16>, i32)
        -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
    %first = wave.extract %value[0]
        : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
    %item = wave.workitem_id 0 : !wave.simd<i32, 64>
    %out = wave.ptr_add %dst, %item
        : !wave.ptr<#wave.global, f16>, !wave.simd<i32, 64>
        -> !wave.simd<!wave.ptr<#wave.global, f16>, 64>
    %stored = wave.store %first -> %out after %token
        : (!wave.simd<f16, 64>, !wave.simd<!wave.ptr<#wave.global, f16>, 64>,
           !wave.mem.token) -> !wave.mem.token
    return
  }
}
