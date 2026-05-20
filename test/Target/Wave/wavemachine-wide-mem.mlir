// RUN: wave-opt %s | FileCheck %s
// RUN: wave-opt %s | wave-opt | FileCheck %s
// RUN: wave-translate --wave-to-amdgpu-asm %s | FileCheck %s --check-prefix=ASM11
// RUN: wave-translate --wave-to-amdgpu-asm %s | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx1100 -filetype=obj -o /dev/null

// New width-parameterised mem ops. Asm emit dispatches the right MC
// opcode per ISA: gfx11 prints the `_b{64,96,128}` syntax, gfx9
// prints the equivalent `_dwordx{2,3,4}`. Same WaveMachine op in
// both cases.

module attributes {wavemachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// CHECK-LABEL: func.func @wide_global_loads
// CHECK: wavemachine.global_load_b64
// CHECK: wavemachine.global_load_b96
// CHECK: wavemachine.global_load_b128

// ASM11-LABEL: wide_global_loads:
// ASM11: global_load_b64
// ASM11: global_load_b96 {{v\[[0-9]+:[0-9]+\]}}, {{v[0-9]+}}, {{s\[[0-9]+:[0-9]+\]}} offset:8
// ASM11: global_load_b128 {{v\[[0-9]+:[0-9]+\]}}, {{v[0-9]+}}, {{s\[[0-9]+:[0-9]+\]}} offset:16
// ASM11: s_endpgm
func.func @wide_global_loads(%arg0: !wave.ptr<i32, #wave.global>) attributes {wave.kernel} {
  %base = wavemachine.arg {index = 0 : i64, pointer = true} : !wavemachine.reg<sgpr, 2>
  %off = wavemachine.v_mbcnt_lo : !wavemachine.reg<vgpr, 1>
  %lo64, %tok64 = wavemachine.global_load_b64 %off, %base
      : (!wavemachine.reg<vgpr, 1>, !wavemachine.reg<sgpr, 2>) -> (!wavemachine.reg<vgpr, 2>, !wavemachine.mem.token)
  %lo96, %tok96 = wavemachine.global_load_b96 %off, %base offset 8
      : (!wavemachine.reg<vgpr, 1>, !wavemachine.reg<sgpr, 2>) -> (!wavemachine.reg<vgpr, 3>, !wavemachine.mem.token)
  %lo128, %tok128 = wavemachine.global_load_b128 %off, %base offset 16
      : (!wavemachine.reg<vgpr, 1>, !wavemachine.reg<sgpr, 2>) -> (!wavemachine.reg<vgpr, 4>, !wavemachine.mem.token)
  wavemachine.s_endpgm
  return
}

// CHECK-LABEL: func.func @wide_global_stores
// CHECK: wavemachine.global_store_b64
// CHECK: wavemachine.global_store_b96
// CHECK: wavemachine.global_store_b128

// ASM11-LABEL: wide_global_stores:
// ASM11: global_store_b64
// ASM11: global_store_b96 {{v[0-9]+}}, {{v\[[0-9]+:[0-9]+\]}}, {{s\[[0-9]+:[0-9]+\]}} offset:8
// ASM11: global_store_b128 {{v[0-9]+}}, {{v\[[0-9]+:[0-9]+\]}}, {{s\[[0-9]+:[0-9]+\]}} offset:16
// ASM11: s_endpgm
func.func @wide_global_stores(%arg0: !wave.ptr<i32, #wave.global>) attributes {wave.kernel} {
  %base = wavemachine.arg {index = 0 : i64, pointer = true} : !wavemachine.reg<sgpr, 2>
  %off = wavemachine.v_mbcnt_lo : !wavemachine.reg<vgpr, 1>
  %zero = wavemachine.imm 0 : !wavemachine.imm
  %v2 = wavemachine.v_mov_b32_tuple %zero {registers = 2 : i64} : (!wavemachine.imm) -> !wavemachine.reg<vgpr, 2>
  %v3 = wavemachine.v_mov_b32_tuple %zero {registers = 3 : i64} : (!wavemachine.imm) -> !wavemachine.reg<vgpr, 3>
  %v4 = wavemachine.v_mov_b32_tuple %zero {registers = 4 : i64} : (!wavemachine.imm) -> !wavemachine.reg<vgpr, 4>
  %t1 = wavemachine.global_store_b64 %off, %v2, %base
      : (!wavemachine.reg<vgpr, 1>, !wavemachine.reg<vgpr, 2>, !wavemachine.reg<sgpr, 2>) -> !wavemachine.mem.token
  %t2 = wavemachine.global_store_b96 %off, %v3, %base offset 8
      : (!wavemachine.reg<vgpr, 1>, !wavemachine.reg<vgpr, 3>, !wavemachine.reg<sgpr, 2>) -> !wavemachine.mem.token
  %t3 = wavemachine.global_store_b128 %off, %v4, %base offset 16
      : (!wavemachine.reg<vgpr, 1>, !wavemachine.reg<vgpr, 4>, !wavemachine.reg<sgpr, 2>) -> !wavemachine.mem.token
  wavemachine.s_endpgm
  return
}

// CHECK-LABEL: func.func @wide_buffer_traffic
// CHECK: wavemachine.buffer_load_b128
// CHECK: wavemachine.buffer_store_b128

// ASM11-LABEL: wide_buffer_traffic:
// ASM11: buffer_load_b128 {{v\[[0-9]+:[0-9]+\]}}, {{v[0-9]+}}, s[{{[0-9]+}}:{{[0-9]+}}], 0 offen
// ASM11: buffer_store_b128 {{v\[[0-9]+:[0-9]+\]}}, {{v[0-9]+}}, s[{{[0-9]+}}:{{[0-9]+}}], 0 offen
// ASM11: s_endpgm
func.func @wide_buffer_traffic(%arg0: !wave.ptr<i32, #wave.global>) attributes {wave.kernel} {
  %base = wavemachine.arg {index = 0 : i64, pointer = true} : !wavemachine.reg<sgpr, 2>
  %range = wavemachine.imm 128 : !wavemachine.imm
  %zero = wavemachine.imm 0 : !wavemachine.imm
  %desc = wavemachine.make_buffer_rsrc %base, %range : (!wavemachine.reg<sgpr, 2>, !wavemachine.imm) -> !wavemachine.reg<sgpr, 4>
  %off = wavemachine.v_mbcnt_lo : !wavemachine.reg<vgpr, 1>
  %v, %tok = wavemachine.buffer_load_b128 %off, %desc, %zero
      : (!wavemachine.reg<vgpr, 1>, !wavemachine.reg<sgpr, 4>, !wavemachine.imm) -> (!wavemachine.reg<vgpr, 4>, !wavemachine.mem.token)
  %st = wavemachine.buffer_store_b128 %off, %v, %desc, %zero after %tok
      : (!wavemachine.reg<vgpr, 1>, !wavemachine.reg<vgpr, 4>, !wavemachine.reg<sgpr, 4>, !wavemachine.imm, !wavemachine.mem.token) -> !wavemachine.mem.token
  wavemachine.s_endpgm
  return
}

// CHECK-LABEL: func.func @wide_ds_traffic
// CHECK: wavemachine.ds_load_b96
// CHECK: wavemachine.ds_store_b96

// ASM11-LABEL: wide_ds_traffic:
// ASM11: ds_load_b96 {{v\[[0-9]+:[0-9]+\]}}, {{v[0-9]+}}
// ASM11: ds_store_b96 {{v[0-9]+}}, {{v\[[0-9]+:[0-9]+\]}}
// ASM11: s_endpgm
func.func @wide_ds_traffic() attributes {wave.kernel} {
  %addr = wavemachine.v_mbcnt_lo : !wavemachine.reg<vgpr, 1>
  %v, %tok = wavemachine.ds_load_b96 %addr
      : (!wavemachine.reg<vgpr, 1>) -> (!wavemachine.reg<vgpr, 3>, !wavemachine.mem.token)
  %st = wavemachine.ds_store_b96 %addr, %v after %tok
      : (!wavemachine.reg<vgpr, 1>, !wavemachine.reg<vgpr, 3>, !wavemachine.mem.token) -> !wavemachine.mem.token
  wavemachine.s_endpgm
  return
}

}
