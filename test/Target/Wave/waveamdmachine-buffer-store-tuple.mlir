// RUN: wave-opt %s | FileCheck %s
// RUN: wave-opt %s | wave-opt | FileCheck %s
// RUN: wave-translate --wave-to-amdgpu-asm %s | FileCheck %s --check-prefix=ASM
// RUN: wave-translate --wave-to-amdgpu-asm %s | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx1100 -filetype=obj -o /dev/null

// `waveamdmachine.buffer_store_tuple_b32` is the single op that covers
// an N-dword tuple store on the buffer path. Backend start decomposes
// it to wide chunks before asm.

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// CHECK-LABEL: func.func @buffer_store_tuple_kernel
// CHECK: waveamdmachine.buffer_store_tuple_b32 %{{.*}}, %{{.*}}, %{{.*}}, %{{.*}}

// ASM-LABEL: buffer_store_tuple_kernel:
// ASM: buffer_store_b128 v{{\[[0-9]+:[0-9]+\]}}, {{v[0-9]+}}, s[{{[0-9]+}}:{{[0-9]+}}], 0 offen{{$}}
// ASM: s_endpgm
func.func @buffer_store_tuple_kernel(%arg0: !wave.ptr<#wave.global, i32>) attributes {wave.kernel} {
  %base = waveamdmachine.arg {index = 0 : i64, pointer = true} : !waveamdmachine.reg<sgpr, 2>
  %off = waveamdmachine.v_mbcnt_lo : !waveamdmachine.reg<vgpr, 1>
  %range = waveamdmachine.imm 128 : !waveamdmachine.imm
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %desc = waveamdmachine.make_buffer_rsrc %base, %range : (!waveamdmachine.reg<sgpr, 2>, !waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 4>
  %tuple = waveamdmachine.v_mov_b32_tuple %off : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 4>
  %t = waveamdmachine.buffer_store_tuple_b32 %off, %tuple, %desc, %zero : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<sgpr, 4>, !waveamdmachine.imm) -> !waveamdmachine.mem.token
  waveamdmachine.s_endpgm
  return
}

}
