// RUN: wave-opt %s | FileCheck %s
// RUN: wave-opt %s | wave-opt | FileCheck %s
// RUN: wave-translate --wave-to-amdgpu-asm %s | FileCheck %s --check-prefix=ASM
// RUN: wave-translate --wave-to-amdgpu-asm %s | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx1100 -filetype=obj -o /dev/null

// The MUBUF / GLOBAL memory ops expose explicit address fields:
//   * Global ops: a `inst_offset` I64 attr (folds into the 13-bit
//     signed immediate field). No native `soffset` on gfx11
//     global; address planning folds any S contribution into V.
//   * Buffer ops: an `soffset` SGPR1OrImm operand (use
//     `waveamdmachine.imm 0` for "no S") plus unsigned 12-bit
//     `inst_offset`.
// LDS ops already carry an `offset` immediate attr -- nothing new.

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// CHECK-LABEL: func.func @global_slots
// CHECK: waveamdmachine.global_load_b32 %{{.*}}, %{{.*}} offset 16
// CHECK: waveamdmachine.global_store_b32 %{{.*}}, %{{.*}}, %{{.*}} offset 32

// ASM-LABEL: global_slots:
// ASM: global_load_b32 v{{[0-9]+}}, v{{[0-9]+}}, s[{{[0-9]+}}:{{[0-9]+}}] offset:16
// ASM: global_store_b32 v{{[0-9]+}}, v{{[0-9]+}}, s[{{[0-9]+}}:{{[0-9]+}}] offset:32
func.func @global_slots(%arg0: !wave.ptr<#wave.global, i32>) attributes {wave.kernel} {
  %base = waveamdmachine.arg {index = 0 : i64, pointer = true} : !waveamdmachine.reg<sgpr, 2>
  %off = waveamdmachine.v_mbcnt_lo : !waveamdmachine.reg<vgpr, 1>
  %v, %tok = waveamdmachine.global_load_b32 %off, %base offset 16 : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>) -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %st = waveamdmachine.global_store_b32 %off, %v, %base offset 32 : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>) -> !waveamdmachine.mem.token
  waveamdmachine.s_endpgm
  return
}

// CHECK-LABEL: func.func @buffer_slots
// CHECK: waveamdmachine.buffer_load_b32 %{{.*}}, %{{.*}}, %{{.*}} offset 16
// CHECK: waveamdmachine.buffer_store_b32 %{{.*}}, %{{.*}}, %{{.*}}, %{{.*}} offset 32

// ASM-LABEL: buffer_slots:
// ASM: buffer_load_b32 v{{[0-9]+}}, v{{[0-9]+}}, s[{{[0-9]+}}:{{[0-9]+}}], s{{[0-9]+}} offen offset:16
// ASM: buffer_store_b32 v{{[0-9]+}}, v{{[0-9]+}}, s[{{[0-9]+}}:{{[0-9]+}}], s{{[0-9]+}} offen offset:32
func.func @buffer_slots(%arg0: !wave.ptr<#wave.global, i32>) attributes {wave.kernel} {
  %base = waveamdmachine.arg {index = 0 : i64, pointer = true} : !waveamdmachine.reg<sgpr, 2>
  %off = waveamdmachine.v_mbcnt_lo : !waveamdmachine.reg<vgpr, 1>
  %range = waveamdmachine.imm 128 : !waveamdmachine.imm
  %soff_imm = waveamdmachine.imm 64 : !waveamdmachine.imm
  %soff = waveamdmachine.s_mov_b32_value %soff_imm : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1>
  %desc = waveamdmachine.make_buffer_rsrc %base, %range : (!waveamdmachine.reg<sgpr, 2>, !waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 4>
  %v, %tok = waveamdmachine.buffer_load_b32 %off, %desc, %soff offset 16 : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>, !waveamdmachine.reg<sgpr, 1>) -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
  %st = waveamdmachine.buffer_store_b32 %off, %v, %desc, %soff offset 32 : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>, !waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.mem.token
  waveamdmachine.s_endpgm
  return
}

// ASM-LABEL: update_buffer_rsrc_base_alias:
// ASM: s_mov_b32 s52, s44
// ASM-NEXT: s_mov_b32 s53, s45
// ASM-NEXT: s_mov_b32 s54, 0x80
// ASM-NEXT: s_mov_b32 s55, 0x31016000
// ASM-NEXT: s_mov_b32 s52, s48
// ASM-NEXT: s_mov_b32 s53, s49
// ASM-NEXT: buffer_load_b32 v1, v0, s[52:55], 0 offen
// ASM: buffer_store_b32 v1, v0, s[52:55], 0 offen
func.func @update_buffer_rsrc_base_alias() attributes {wave.kernel} {
  %old_base = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 2, 44>
  %new_base = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 2, 48>
  %off = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, 0>
  %range = waveamdmachine.imm 128 : !waveamdmachine.imm
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %desc0 = waveamdmachine.make_buffer_rsrc %old_base, %range
      : (!waveamdmachine.reg<sgpr, 2, 44>, !waveamdmachine.imm)
        -> !waveamdmachine.reg<sgpr, 4, 52>
  %desc1 = waveamdmachine.update_buffer_rsrc_base %desc0, %new_base
      : (!waveamdmachine.reg<sgpr, 4, 52>, !waveamdmachine.reg<sgpr, 2, 48>)
        -> !waveamdmachine.reg<sgpr, 4, 52>
  %value, %tok = waveamdmachine.buffer_load_b32 %off, %desc1, %zero
      : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.reg<sgpr, 4, 52>,
         !waveamdmachine.imm)
        -> (!waveamdmachine.reg<vgpr, 1, 1>, !waveamdmachine.mem.token)
  %st = waveamdmachine.buffer_store_b32 %off, %value, %desc1, %zero after %tok
      : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.reg<vgpr, 1, 1>,
         !waveamdmachine.reg<sgpr, 4, 52>, !waveamdmachine.imm,
         !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  waveamdmachine.s_endpgm
  return
}

}
