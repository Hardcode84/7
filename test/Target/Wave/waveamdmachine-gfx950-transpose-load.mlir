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
  %lds = wave.shared_memory_base : !wave.ptr<#wave.shared, i8>
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
  %lds_i16 = wave.shared_memory_base : !wave.ptr<#wave.shared, i16>
  %ptr_i16 = wave.ptr_add %lds_i16, %lane
      : !wave.ptr<#wave.shared, i16>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#wave.shared, i16>, 64>
  %i16, %tok_i16 = waveamd.transpose_load %ptr_i16
      : (!wave.simd<!wave.ptr<#wave.shared, i16>, 64>)
        -> (!wave.simd<vector<4xi16>, 64>, !wave.mem.token)
  %lds_f16 = wave.shared_memory_base : !wave.ptr<#wave.shared, f16>
  %ptr_f16 = wave.ptr_add %lds_f16, %lane
      : !wave.ptr<#wave.shared, f16>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
  %f16, %tok_f16 = waveamd.transpose_load %ptr_f16 after %tok_i16
      : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token)
        -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
  %lds_bf16 = wave.shared_memory_base : !wave.ptr<#wave.shared, bf16>
  %ptr_bf16 = wave.ptr_add %lds_bf16, %lane
      : !wave.ptr<#wave.shared, bf16>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>
  %bf16, %tok_bf16 = waveamd.transpose_load %ptr_bf16 after %tok_f16
      : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token)
        -> (!wave.simd<vector<4xbf16>, 64>, !wave.mem.token)
  return
}

// MACHINE-LABEL: func.func @transpose_load_b16_pack_words
// MACHINE: waveamdmachine.ds_read_tr_b64_b16
// MACHINE: waveamdmachine.ds_read_tr_b64_b16
// MACHINE-NOT: waveamdmachine.v_and_b32
// MACHINE-NOT: waveamdmachine.v_lshrrev_b32
// MACHINE-NOT: waveamdmachine.v_or_b32
// MACHINE: waveamdmachine.global_store_tuple_b32
func.func @transpose_load_b16_pack_words(%out: !wave.ptr<#wave.global, f16>)
    attributes {wave.kernel, waveamdmachine.lds_size = 256 : i64} {
  %lane = wave.lane_id : !wave.simd<i32, 64>
  %lds = wave.shared_memory_base : !wave.ptr<#wave.shared, f16>
  %ptr0 = wave.ptr_add %lds, %lane
      : !wave.ptr<#wave.shared, f16>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
  %lo, %tok0 = waveamd.transpose_load %ptr0
      : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>)
        -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
  %c4 = arith.constant 4 : i32
  %step = wave.splat %c4 : i32 -> !wave.simd<i32, 64>
  %ptr1 = wave.ptr_add %ptr0, %step
      : !wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
  %hi, %tok1 = waveamd.transpose_load %ptr1 after %tok0
      : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token)
        -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
  %e0 = wave.extract %lo[0]
      : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
  %e1 = wave.extract %lo[1]
      : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
  %e2 = wave.extract %lo[2]
      : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
  %e3 = wave.extract %lo[3]
      : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
  %e4 = wave.extract %hi[0]
      : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
  %e5 = wave.extract %hi[1]
      : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
  %e6 = wave.extract %hi[2]
      : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
  %e7 = wave.extract %hi[3]
      : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
  %packed = wave.pack %e0, %e1, %e2, %e3, %e4, %e5, %e6, %e7
      : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>,
        !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>,
        !wave.simd<f16, 64>, !wave.simd<f16, 64>
        -> !wave.simd<vector<8xf16>, 64>
  %out_ptr = wave.ptr_add %out, %lane
      : !wave.ptr<#wave.global, f16>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#wave.global, f16>, 64>
  %store = wave.store %packed -> %out_ptr after %tok1
      : (!wave.simd<vector<8xf16>, 64>,
         !wave.simd<!wave.ptr<#wave.global, f16>, 64>, !wave.mem.token)
      -> !wave.mem.token
  return
}

// MACHINE-LABEL: func.func @transpose_load_b96_b6
// MACHINE: waveamdmachine.ds_read_tr_b96_b6

// ASM-LABEL: transpose_load_b96_b6:
// ASM: ds_read_b96_tr_b6 {{v\[[0-9]+:[0-9]+\]}}, {{v[0-9]+}}
// ASM: s_endpgm
func.func @transpose_load_b96_b6()
    attributes {wave.kernel, waveamdmachine.lds_size = 256 : i64} {
  %lane = wave.lane_id : !wave.simd<i32, 64>
  %lds = wave.shared_memory_base : !wave.ptr<#wave.shared, i32>
  %ptr = wave.ptr_add %lds, %lane
      : !wave.ptr<#wave.shared, i32>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#wave.shared, i32>, 64>
  %v, %tok = waveamd.transpose_load %ptr
      : (!wave.simd<!wave.ptr<#wave.shared, i32>, 64>)
        -> (!wave.simd<vector<3xi32>, 64>, !wave.mem.token)
  return
}

// MACHINE-LABEL: func.func @transpose_load_offsets
// MACHINE: waveamdmachine.ds_read_tr_b64_b8 {{.*}} offset 16
// MACHINE: waveamdmachine.ds_read_tr_b64_b4 {{.*}} offset 32
// MACHINE: waveamdmachine.ds_read_tr_b96_b6 {{.*}} offset 48
// MACHINE: waveamdmachine.ds_read_tr_b64_b16 {{.*}} offset 64

// ASM-LABEL: transpose_load_offsets:
// ASM: ds_read_b64_tr_b8 {{v\[[0-9]+:[0-9]+\]}}, {{v[0-9]+}} offset:16
// ASM: ds_read_b64_tr_b4 {{v\[[0-9]+:[0-9]+\]}}, {{v[0-9]+}} offset:32
// ASM: ds_read_b96_tr_b6 {{v\[[0-9]+:[0-9]+\]}}, {{v[0-9]+}} offset:48
// ASM: ds_read_b64_tr_b16 {{v\[[0-9]+:[0-9]+\]}}, {{v[0-9]+}} offset:64
// ASM: s_endpgm
func.func @transpose_load_offsets()
    attributes {wave.kernel, waveamdmachine.lds_size = 256 : i64} {
  %lds = wave.shared_memory_base : !wave.ptr<#wave.shared>
  %lane = wave.lane_id : !wave.simd<i32, 64>
  %off8 = wave.index_expr <"16 + lid"> ["lid"](%lane)
      : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
  %ptr8 = wave.ptr_add %lds, %off8
      : !wave.ptr<#wave.shared>, !wave.simd<index, 64>
      -> !wave.simd<!wave.ptr<#wave.shared>, 64>
  %v8, %tok8 = waveamd.transpose_load %ptr8
      : (!wave.simd<!wave.ptr<#wave.shared>, 64>)
        -> (!wave.simd<vector<8xi8>, 64>, !wave.mem.token)
  %off4 = wave.index_expr <"32 + lid"> ["lid"](%lane)
      : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
  %ptr4 = wave.ptr_add %lds, %off4
      : !wave.ptr<#wave.shared>, !wave.simd<index, 64>
      -> !wave.simd<!wave.ptr<#wave.shared>, 64>
  %v4, %tok4 = waveamd.transpose_load %ptr4 after %tok8
      : (!wave.simd<!wave.ptr<#wave.shared>, 64>, !wave.mem.token)
        -> (!wave.simd<vector<16xi4>, 64>, !wave.mem.token)
  %off6 = wave.index_expr <"48 + lid"> ["lid"](%lane)
      : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
  %ptr6 = wave.ptr_add %lds, %off6
      : !wave.ptr<#wave.shared>, !wave.simd<index, 64>
      -> !wave.simd<!wave.ptr<#wave.shared>, 64>
  %v6, %tok6 = waveamd.transpose_load %ptr6 after %tok4
      : (!wave.simd<!wave.ptr<#wave.shared>, 64>, !wave.mem.token)
        -> (!wave.simd<vector<3xi32>, 64>, !wave.mem.token)
  %off16 = wave.index_expr <"64 + lid"> ["lid"](%lane)
      : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
  %ptr16 = wave.ptr_add %lds, %off16
      : !wave.ptr<#wave.shared>, !wave.simd<index, 64>
      -> !wave.simd<!wave.ptr<#wave.shared>, 64>
  %v16, %tok16 = waveamd.transpose_load %ptr16 after %tok6
      : (!wave.simd<!wave.ptr<#wave.shared>, 64>, !wave.mem.token)
        -> (!wave.simd<vector<4xi16>, 64>, !wave.mem.token)
  return
}

// MACHINE-LABEL: func.func @transpose_load_large_const_offset
// MACHINE: waveamdmachine.ds_read_tr_b64_b8 {{.*}} offset 2048

// ASM-LABEL: transpose_load_large_const_offset:
// ASM-NOT: 0x20800
// ASM: ds_read_b64_tr_b8 {{v\[[0-9]+:[0-9]+\]}}, {{v[0-9]+}} offset:2048
// ASM: s_endpgm
func.func @transpose_load_large_const_offset()
    attributes {wave.kernel, waveamdmachine.lds_size = 262144 : i64} {
  %lds = wave.shared_memory_base : !wave.ptr<#wave.shared>
  %lane = wave.lane_id : !wave.simd<i32, 64>
  %off = wave.index_expr <"133120 + lid"> ["lid"](%lane)
      : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
  %ptr = wave.ptr_add %lds, %off
      : !wave.ptr<#wave.shared>, !wave.simd<index, 64>
      -> !wave.simd<!wave.ptr<#wave.shared>, 64>
  %v, %tok = waveamd.transpose_load %ptr
      : (!wave.simd<!wave.ptr<#wave.shared>, 64>)
        -> (!wave.simd<vector<8xi8>, 64>, !wave.mem.token)
  return
}

// MACHINE-LABEL: func.func @transpose_load_opaque_index_expr
// MACHINE: waveamdmachine.ds_read_tr_b64_b8

// ASM-LABEL: transpose_load_opaque_index_expr:
// ASM: ds_read_b64_tr_b8 {{v\[[0-9]+:[0-9]+\]}}, {{v[0-9]+}}
// ASM: s_endpgm
func.func @transpose_load_opaque_index_expr()
    attributes {wave.kernel, waveamdmachine.lds_size = 256 : i64} {
  %lds = wave.shared_memory_base : !wave.ptr<#wave.shared>
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
  %lds = wave.shared_memory_base : !wave.ptr<#wave.shared, i8>
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
