// RUN: wave-opt %s | FileCheck %s
// RUN: wave-opt %s | wave-opt | FileCheck %s
// RUN: wave-translate --wave-to-amdgpu-asm %s | FileCheck %s --check-prefix=ASM
// RUN: wave-translate --wave-to-amdgpu-asm %s | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx1100 -filetype=obj -o /dev/null

// The MUBUF / GLOBAL memory ops now expose explicit slots that the
// bucketed offset lowering can populate:
//   * Global ops: a `inst_offset` I64 attr (folds into the MUBUF
//     12/13-bit signed immediate field). No native `soffset` on gfx11
//     global; the bucketizer folds any S contribution into V.
//   * Buffer ops: an `soffset` SGPR1OrImm operand (use
//     `wavemachine.imm 0` for "no S") plus the same `inst_offset`
//     attr.
// LDS ops already carry an `offset` immediate attr -- nothing new.

module attributes {wavemachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// CHECK-LABEL: func.func @global_slots
// CHECK: wavemachine.global_load_b32 %{{.*}}, %{{.*}} offset 16
// CHECK: wavemachine.global_store_b32 %{{.*}}, %{{.*}}, %{{.*}} offset 32

// ASM-LABEL: global_slots:
// ASM: global_load_b32 v{{[0-9]+}}, v{{[0-9]+}}, s[{{[0-9]+}}:{{[0-9]+}}] offset:16
// ASM: global_store_b32 v{{[0-9]+}}, v{{[0-9]+}}, s[{{[0-9]+}}:{{[0-9]+}}] offset:32
func.func @global_slots(%arg0: !wave.ptr<i32, #wave.global>) attributes {wave.kernel} {
  %base = wavemachine.arg {index = 0 : i64, pointer = true} : !wavemachine.reg<sgpr, 2>
  %off = wavemachine.v_mbcnt_lo : !wavemachine.reg<vgpr, 1>
  %v, %tok = wavemachine.global_load_b32 %off, %base offset 16 : (!wavemachine.reg<vgpr, 1>, !wavemachine.reg<sgpr, 2>) -> (!wavemachine.reg<vgpr, 1>, !wavemachine.mem.token)
  %st = wavemachine.global_store_b32 %off, %v, %base offset 32 : (!wavemachine.reg<vgpr, 1>, !wavemachine.reg<vgpr, 1>, !wavemachine.reg<sgpr, 2>) -> !wavemachine.mem.token
  wavemachine.s_endpgm
  return
}

// CHECK-LABEL: func.func @buffer_slots
// CHECK: wavemachine.buffer_load_b32 %{{.*}}, %{{.*}}, %{{.*}} offset 16
// CHECK: wavemachine.buffer_store_b32 %{{.*}}, %{{.*}}, %{{.*}}, %{{.*}} offset 32

// ASM-LABEL: buffer_slots:
// ASM: buffer_load_b32 v{{[0-9]+}}, v{{[0-9]+}}, s[{{[0-9]+}}:{{[0-9]+}}], s{{[0-9]+}} offen offset:16
// ASM: buffer_store_b32 v{{[0-9]+}}, v{{[0-9]+}}, s[{{[0-9]+}}:{{[0-9]+}}], s{{[0-9]+}} offen offset:32
func.func @buffer_slots(%arg0: !wave.ptr<i32, #wave.global>) attributes {wave.kernel} {
  %base = wavemachine.arg {index = 0 : i64, pointer = true} : !wavemachine.reg<sgpr, 2>
  %off = wavemachine.v_mbcnt_lo : !wavemachine.reg<vgpr, 1>
  %range = wavemachine.imm 128 : !wavemachine.imm
  %soff_imm = wavemachine.imm 64 : !wavemachine.imm
  %soff = wavemachine.s_mov_b32_value %soff_imm : (!wavemachine.imm) -> !wavemachine.reg<sgpr, 1>
  %desc = wavemachine.make_buffer_rsrc %base, %range : (!wavemachine.reg<sgpr, 2>, !wavemachine.imm) -> !wavemachine.reg<sgpr, 4>
  %v, %tok = wavemachine.buffer_load_b32 %off, %desc, %soff offset 16 : (!wavemachine.reg<vgpr, 1>, !wavemachine.reg<sgpr, 4>, !wavemachine.reg<sgpr, 1>) -> (!wavemachine.reg<vgpr, 1>, !wavemachine.mem.token)
  %st = wavemachine.buffer_store_b32 %off, %v, %desc, %soff offset 32 : (!wavemachine.reg<vgpr, 1>, !wavemachine.reg<vgpr, 1>, !wavemachine.reg<sgpr, 4>, !wavemachine.reg<sgpr, 1>) -> !wavemachine.mem.token
  wavemachine.s_endpgm
  return
}

}
