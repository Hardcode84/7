// RUN: wave-opt %s | FileCheck %s --check-prefix=ROUNDTRIP
// RUN: wave-opt %s | wave-opt | FileCheck %s --check-prefix=ROUNDTRIP
// RUN: wave-opt --waveamd-buffer-rsrc-to-tuples %s | wave-translate --wave-to-amdgpu-asm - | FileCheck %s --check-prefix=ASM
// RUN: wave-opt --waveamd-buffer-rsrc-to-tuples %s | wave-translate --wave-to-amdgpu-asm - | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx1100 -filetype=obj -o /dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// ROUNDTRIP-LABEL: func.func @byte_global_saddr
// ROUNDTRIP: %[[U:.*]], %[[UTOK:.*]] = waveamdmachine.global_load_u8
// ROUNDTRIP: %[[I:.*]], %[[ITOK:.*]] = waveamdmachine.global_load_i8
// ROUNDTRIP: %[[STORE:.*]] = waveamdmachine.global_store_b8

// ASM-LABEL: byte_global_saddr:
// ASM: global_load_u8 {{v[0-9]+}}, {{v[0-9]+}}, {{s\[[0-9]+:[0-9]+\]}} offset:1
// ASM: global_load_i8 {{v[0-9]+}}, {{v[0-9]+}}, {{s\[[0-9]+:[0-9]+\]}} offset:2
// ASM: global_store_b8 {{v[0-9]+}}, {{v[0-9]+}}, {{s\[[0-9]+:[0-9]+\]}} offset:3
// ASM: s_endpgm
func.func @byte_global_saddr(%arg0: !wave.ptr<#wave.global, i32>)
    attributes {wave.kernel} {
  %base = waveamdmachine.arg {index = 0 : i64, pointer = true}
      : !waveamdmachine.reg<sgpr, 2>
  %off = waveamdmachine.v_mbcnt_lo : !waveamdmachine.reg<vgpr, 1>
  %u, %utok = waveamdmachine.global_load_u8 %off, %base offset 1
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %i, %itok = waveamdmachine.global_load_i8 %off, %base after %utok offset 2
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.mem.token)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %store = waveamdmachine.global_store_b8 %off, %i, %base after %itok offset 3
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 2>, !waveamdmachine.mem.token)
        -> !waveamdmachine.mem.token
  waveamdmachine.s_endpgm
  return
}

// ROUNDTRIP-LABEL: func.func @byte_global_addr64
// ROUNDTRIP: %[[ADDR:.*]] = waveamdmachine.v_mov_b32_tuple
// ROUNDTRIP: %[[U:.*]], %[[UTOK:.*]] = waveamdmachine.global_load_u8_addr64
// ROUNDTRIP: %[[I:.*]], %[[ITOK:.*]] = waveamdmachine.global_load_i8_addr64
// ROUNDTRIP: %[[STORE:.*]] = waveamdmachine.global_store_b8_addr64

// ASM-LABEL: byte_global_addr64:
// ASM: global_load_u8 {{v[0-9]+}}, {{v\[[0-9]+:[0-9]+\]}}, off offset:4
// ASM: global_load_i8 {{v[0-9]+}}, {{v\[[0-9]+:[0-9]+\]}}, off offset:5
// ASM: global_store_b8 {{v\[[0-9]+:[0-9]+\]}}, {{v[0-9]+}}, off offset:6
// ASM: s_endpgm
func.func @byte_global_addr64() attributes {wave.kernel} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %addr = waveamdmachine.v_mov_b32_tuple %zero {registers = 2 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 2>
  %u, %utok = waveamdmachine.global_load_u8_addr64 %addr offset 4
      : (!waveamdmachine.reg<vgpr, 2>)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %i, %itok = waveamdmachine.global_load_i8_addr64 %addr after %utok offset 5
      : (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.mem.token)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %store = waveamdmachine.global_store_b8_addr64 %addr, %i after %itok offset 6
      : (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.mem.token)
        -> !waveamdmachine.mem.token
  waveamdmachine.s_endpgm
  return
}

// ROUNDTRIP-LABEL: func.func @byte_buffer
// ROUNDTRIP: %[[U:.*]], %[[UTOK:.*]] = waveamdmachine.buffer_load_u8
// ROUNDTRIP: %[[I:.*]], %[[ITOK:.*]] = waveamdmachine.buffer_load_i8
// ROUNDTRIP: %[[STORE:.*]] = waveamdmachine.buffer_store_b8

// ASM-LABEL: byte_buffer:
// ASM: buffer_load_u8 {{v[0-9]+}}, {{v[0-9]+}}, {{s\[[0-9]+:[0-9]+\]}}, 0 offen offset:7
// ASM: buffer_load_i8 {{v[0-9]+}}, {{v[0-9]+}}, {{s\[[0-9]+:[0-9]+\]}}, 0 offen offset:8
// ASM: buffer_store_b8 {{v[0-9]+}}, {{v[0-9]+}}, {{s\[[0-9]+:[0-9]+\]}}, 0 offen offset:9
// ASM: s_endpgm
func.func @byte_buffer(%arg0: !wave.ptr<#wave.global, i32>)
    attributes {wave.kernel} {
  %base = waveamdmachine.arg {index = 0 : i64, pointer = true}
      : !waveamdmachine.reg<sgpr, 2>
  %range = waveamdmachine.imm 128 : !waveamdmachine.imm
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %desc = waveamdmachine.make_buffer_rsrc %base, %range
      : (!waveamdmachine.reg<sgpr, 2>, !waveamdmachine.imm)
        -> !waveamdmachine.reg<sgpr, 4>
  %off = waveamdmachine.v_mbcnt_lo : !waveamdmachine.reg<vgpr, 1>
  %u, %utok = waveamdmachine.buffer_load_u8 %off, %desc, %zero offset 7
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
         !waveamdmachine.imm)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %i, %itok = waveamdmachine.buffer_load_i8 %off, %desc, %zero after %utok offset 8
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>,
         !waveamdmachine.imm, !waveamdmachine.mem.token)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %store = waveamdmachine.buffer_store_b8 %off, %i, %desc, %zero after %itok offset 9
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 4>, !waveamdmachine.imm,
         !waveamdmachine.mem.token)
        -> !waveamdmachine.mem.token
  waveamdmachine.s_endpgm
  return
}

// ROUNDTRIP-LABEL: func.func @byte_ds
// ROUNDTRIP: %[[ADDR:.*]] = waveamdmachine.v_mbcnt_lo
// ROUNDTRIP: %[[U:.*]], %[[UTOK:.*]] = waveamdmachine.ds_load_u8
// ROUNDTRIP: %[[I:.*]], %[[ITOK:.*]] = waveamdmachine.ds_load_i8
// ROUNDTRIP: %[[STORE:.*]] = waveamdmachine.ds_store_b8

// ASM-LABEL: byte_ds:
// ASM: ds_load_u8 {{v[0-9]+}}, {{v[0-9]+}} offset:10
// ASM: ds_load_i8 {{v[0-9]+}}, {{v[0-9]+}} offset:11
// ASM: ds_{{write|store}}_b8 {{v[0-9]+}}, {{v[0-9]+}} offset:12
// ASM: s_endpgm
func.func @byte_ds() attributes {wave.kernel, waveamdmachine.lds_size = 256 : i64} {
  %addr = waveamdmachine.v_mbcnt_lo : !waveamdmachine.reg<vgpr, 1>
  %u, %utok = waveamdmachine.ds_load_u8 %addr offset 10
      : (!waveamdmachine.reg<vgpr, 1>)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %i, %itok = waveamdmachine.ds_load_i8 %addr after %utok offset 11
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %store = waveamdmachine.ds_store_b8 %addr, %i after %itok offset 12
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.mem.token)
        -> !waveamdmachine.mem.token
  waveamdmachine.s_endpgm
  return
}

}
