// RUN: wave-opt --waveamd-to-machine %s | FileCheck %s --check-prefix=MACHINE
// RUN: wave-opt --waveamd-to-machine %s | wave-translate --wave-to-amdgpu-asm | FileCheck %s --check-prefix=ASM
// RUN: wave-opt --waveamd-to-machine %s | wave-translate --wave-to-amdgpu-asm | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx950 -filetype=obj -o /dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// MACHINE-LABEL: func.func @transpose_load_i8_i4
// MACHINE: waveamdmachine.ds_read_tr_b64_b8
// MACHINE: waveamdmachine.ds_read_tr_b64_b4

// ASM-LABEL: transpose_load_i8_i4:
// ASM: ds_read_b64_tr_b8 {{v\[[0-9]+:[0-9]+\]}}, {{v[0-9]+}}
// ASM: ds_read_b64_tr_b4 {{v\[[0-9]+:[0-9]+\]}}, {{v[0-9]+}}
// ASM: s_endpgm
func.func @transpose_load_i8_i4()
    attributes {wave.kernel, waveamdmachine.lds_size = 256 : i64} {
  %lds = wave.lds_base : !wave.ptr<#wave.shared, i8>
  %lane = wave.lane_id : !wave.simd<i32, 64>
  %ptr = wave.ptr_add %lds, %lane
      : !wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
  %v8, %tok8 = waveamd.transpose_load %ptr
      : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>)
        -> (!wave.simd<vector<8xi8>, 64>, !wave.mem.token)
  %v4, %tok4 = waveamd.transpose_load %ptr after %tok8
      : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token)
        -> (!wave.simd<vector<16xi4>, 64>, !wave.mem.token)
  return
}

// MACHINE-LABEL: func.func @transpose_load_b16_datatypes
// MACHINE: waveamdmachine.ds_read_tr_b64_b16
// MACHINE: waveamdmachine.ds_read_tr_b64_b16
// MACHINE: waveamdmachine.ds_read_tr_b64_b16

// ASM-LABEL: transpose_load_b16_datatypes:
// ASM: ds_read_b64_tr_b16 {{v\[[0-9]+:[0-9]+\]}}, {{v[0-9]+}}
// ASM: ds_read_b64_tr_b16 {{v\[[0-9]+:[0-9]+\]}}, {{v[0-9]+}}
// ASM: ds_read_b64_tr_b16 {{v\[[0-9]+:[0-9]+\]}}, {{v[0-9]+}}
// ASM: s_endpgm
func.func @transpose_load_b16_datatypes()
    attributes {wave.kernel, waveamdmachine.lds_size = 256 : i64} {
  %lane = wave.lane_id : !wave.simd<i32, 64>
  %lds_i16 = wave.lds_base : !wave.ptr<#wave.shared, i16>
  %ptr_i16 = wave.ptr_add %lds_i16, %lane
      : !wave.ptr<#wave.shared, i16>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#wave.shared, i16>, 64>
  %i16, %tok_i16 = waveamd.transpose_load %ptr_i16
      : (!wave.simd<!wave.ptr<#wave.shared, i16>, 64>)
        -> (!wave.simd<vector<4xi16>, 64>, !wave.mem.token)
  %lds_f16 = wave.lds_base : !wave.ptr<#wave.shared, f16>
  %ptr_f16 = wave.ptr_add %lds_f16, %lane
      : !wave.ptr<#wave.shared, f16>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
  %f16, %tok_f16 = waveamd.transpose_load %ptr_f16 after %tok_i16
      : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token)
        -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
  %lds_bf16 = wave.lds_base : !wave.ptr<#wave.shared, bf16>
  %ptr_bf16 = wave.ptr_add %lds_bf16, %lane
      : !wave.ptr<#wave.shared, bf16>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>
  %bf16, %tok_bf16 = waveamd.transpose_load %ptr_bf16 after %tok_f16
      : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token)
        -> (!wave.simd<vector<4xbf16>, 64>, !wave.mem.token)
  return
}

// MACHINE-LABEL: func.func @transpose_load_opaque_index_expr
// MACHINE: waveamdmachine.ds_read_tr_b64_b8

// ASM-LABEL: transpose_load_opaque_index_expr:
// ASM: ds_read_b64_tr_b8 {{v\[[0-9]+:[0-9]+\]}}, {{v[0-9]+}}
// ASM: s_endpgm
func.func @transpose_load_opaque_index_expr()
    attributes {wave.kernel, waveamdmachine.lds_size = 256 : i64} {
  %lds = wave.lds_base : !wave.ptr<#wave.shared>
  %lane = wave.lane_id : !wave.simd<i32, 64>
  %off = wave.index_expr <"lid"> ["lid"](%lane)
      : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
  %ptr = wave.ptr_add %lds, %off
      : !wave.ptr<#wave.shared>, !wave.simd<index, 64>
      -> !wave.simd<!wave.ptr<#wave.shared>, 64>
  %v, %tok = waveamd.transpose_load %ptr
      : (!wave.simd<!wave.ptr<#wave.shared>, 64>)
        -> (!wave.simd<vector<8xi8>, 64>, !wave.mem.token)
  return
}

// MACHINE-LABEL: func.func @generic_i8_shared_load_store
// MACHINE: waveamdmachine.ds_load_u8
// MACHINE: waveamdmachine.ds_store_b8

// ASM-LABEL: generic_i8_shared_load_store:
// ASM: ds_read_u8 {{v[0-9]+}}, {{v[0-9]+}}
// ASM: ds_{{write|store}}_b8 {{v[0-9]+}}, {{v[0-9]+}}
// ASM: s_endpgm
func.func @generic_i8_shared_load_store()
    attributes {wave.kernel, waveamdmachine.lds_size = 256 : i64} {
  %lds = wave.lds_base : !wave.ptr<#wave.shared, i8>
  %lane = wave.lane_id : !wave.simd<i32, 64>
  %ptr = wave.ptr_add %lds, %lane
      : !wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
  %v, %load_tok = wave.load %ptr
      : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>)
        -> (!wave.simd<i8, 64>, !wave.mem.token)
  %store_tok = wave.store %v -> %ptr after %load_tok
      : (!wave.simd<i8, 64>,
         !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token)
        -> !wave.mem.token
  return
}

}
