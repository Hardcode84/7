// RUN: wave-opt %s | FileCheck %s
// RUN: wave-opt %s | wave-opt | FileCheck %s
// RUN: wave-translate --wave-to-amdgpu-asm %s | FileCheck %s --check-prefix=ASM11
// RUN: wave-translate --wave-to-amdgpu-asm %s | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx1100 -filetype=obj -o /dev/null

// New width-parameterised mem ops. Asm emit dispatches the right MC
// opcode per ISA: gfx11 prints the `_b{64,96,128}` syntax, gfx9
// prints the equivalent `_dwordx{2,3,4}`. Same WaveAMDMachine op in
// both cases.

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// CHECK-LABEL: func.func @wide_global_loads
// CHECK: waveamdmachine.global_load_b64
// CHECK: waveamdmachine.global_load_b96
// CHECK: waveamdmachine.global_load_b128

// ASM11-LABEL: wide_global_loads:
// ASM11: global_load_b64
// ASM11: global_load_b96 {{v\[[0-9]+:[0-9]+\]}}, {{v[0-9]+}}, {{s\[[0-9]+:[0-9]+\]}} offset:8
// ASM11: global_load_b128 {{v\[[0-9]+:[0-9]+\]}}, {{v[0-9]+}}, {{s\[[0-9]+:[0-9]+\]}} offset:16
// ASM11: s_endpgm
func.func @wide_global_loads(%arg0: !wave.ptr<i32, #wave.global>) attributes {wave.kernel} {
  %base = waveamdmachine.arg {index = 0 : i64, pointer = true} : !waveamdmachine.reg<sgpr, 2>
  %off = waveamdmachine.v_mbcnt_lo : !waveamdmachine.reg<vgpr, 1>
  %lo64, %tok64 = waveamdmachine.global_load_b64 %off, %base
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>) -> (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.mem.token)
  %lo96, %tok96 = waveamdmachine.global_load_b96 %off, %base offset 8
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>) -> (!waveamdmachine.reg<vgpr, 3>, !waveamdmachine.mem.token)
  %lo128, %tok128 = waveamdmachine.global_load_b128 %off, %base offset 16
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>) -> (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.mem.token)
  waveamdmachine.global_store_b64 %off, %lo64, %base : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<sgpr, 2>) -> ()
  waveamdmachine.global_store_b96 %off, %lo96, %base offset 8 : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 3>, !waveamdmachine.reg<sgpr, 2>) -> ()
  waveamdmachine.global_store_b128 %off, %lo128, %base offset 16 : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<sgpr, 2>) -> ()
  waveamdmachine.s_endpgm
  return
}

// CHECK-LABEL: func.func @wide_global_stores
// CHECK: waveamdmachine.global_store_b64
// CHECK: waveamdmachine.global_store_b96
// CHECK: waveamdmachine.global_store_b128

// ASM11-LABEL: wide_global_stores:
// ASM11: global_store_b64
// ASM11: global_store_b96 {{v[0-9]+}}, {{v\[[0-9]+:[0-9]+\]}}, {{s\[[0-9]+:[0-9]+\]}} offset:8
// ASM11: global_store_b128 {{v[0-9]+}}, {{v\[[0-9]+:[0-9]+\]}}, {{s\[[0-9]+:[0-9]+\]}} offset:16
// ASM11: s_endpgm
func.func @wide_global_stores(%arg0: !wave.ptr<i32, #wave.global>) attributes {wave.kernel} {
  %base = waveamdmachine.arg {index = 0 : i64, pointer = true} : !waveamdmachine.reg<sgpr, 2>
  %off = waveamdmachine.v_mbcnt_lo : !waveamdmachine.reg<vgpr, 1>
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %v2 = waveamdmachine.v_mov_b32_tuple %zero {registers = 2 : i64} : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 2>
  %v3 = waveamdmachine.v_mov_b32_tuple %zero {registers = 3 : i64} : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 3>
  %v4 = waveamdmachine.v_mov_b32_tuple %zero {registers = 4 : i64} : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 4>
  %t1 = waveamdmachine.global_store_b64 %off, %v2, %base
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<sgpr, 2>) -> !waveamdmachine.mem.token
  %t2 = waveamdmachine.global_store_b96 %off, %v3, %base offset 8
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 3>, !waveamdmachine.reg<sgpr, 2>) -> !waveamdmachine.mem.token
  %t3 = waveamdmachine.global_store_b128 %off, %v4, %base offset 16
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<sgpr, 2>) -> !waveamdmachine.mem.token
  waveamdmachine.s_endpgm
  return
}

// CHECK-LABEL: func.func @wide_buffer_traffic
// CHECK: waveamdmachine.buffer_load_b128
// CHECK: waveamdmachine.buffer_store_b128

// ASM11-LABEL: wide_buffer_traffic:
// ASM11: buffer_load_b128 {{v\[[0-9]+:[0-9]+\]}}, {{v[0-9]+}}, s[{{[0-9]+}}:{{[0-9]+}}], 0 offen
// ASM11: buffer_store_b128 {{v\[[0-9]+:[0-9]+\]}}, {{v[0-9]+}}, s[{{[0-9]+}}:{{[0-9]+}}], 0 offen
// ASM11: s_endpgm
func.func @wide_buffer_traffic(%arg0: !wave.ptr<i32, #wave.global>) attributes {wave.kernel} {
  %base = waveamdmachine.arg {index = 0 : i64, pointer = true} : !waveamdmachine.reg<sgpr, 2>
  %range = waveamdmachine.imm 128 : !waveamdmachine.imm
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %desc = waveamdmachine.make_buffer_rsrc %base, %range : (!waveamdmachine.reg<sgpr, 2>, !waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 4>
  %off = waveamdmachine.v_mbcnt_lo : !waveamdmachine.reg<vgpr, 1>
  %v, %tok = waveamdmachine.buffer_load_b128 %off, %desc, %zero
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>, !waveamdmachine.imm) -> (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.mem.token)
  %st = waveamdmachine.buffer_store_b128 %off, %v, %desc, %zero after %tok
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<sgpr, 4>, !waveamdmachine.imm, !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  waveamdmachine.s_endpgm
  return
}

// CHECK-LABEL: func.func @wide_ds_traffic
// CHECK: waveamdmachine.ds_load_b96
// CHECK: waveamdmachine.ds_store_b96

// ASM11-LABEL: wide_ds_traffic:
// ASM11: ds_load_b96 {{v\[[0-9]+:[0-9]+\]}}, {{v[0-9]+}}
// ASM11: ds_store_b96 {{v[0-9]+}}, {{v\[[0-9]+:[0-9]+\]}}
// ASM11: s_endpgm
func.func @wide_ds_traffic() attributes {wave.kernel} {
  %addr = waveamdmachine.v_mbcnt_lo : !waveamdmachine.reg<vgpr, 1>
  %v, %tok = waveamdmachine.ds_load_b96 %addr
      : (!waveamdmachine.reg<vgpr, 1>) -> (!waveamdmachine.reg<vgpr, 3>, !waveamdmachine.mem.token)
  %st = waveamdmachine.ds_store_b96 %addr, %v after %tok
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 3>, !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  waveamdmachine.s_endpgm
  return
}

}
