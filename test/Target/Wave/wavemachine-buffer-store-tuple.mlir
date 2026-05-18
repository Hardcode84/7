// RUN: wave-opt %s | FileCheck %s
// RUN: wave-opt %s | wave-opt | FileCheck %s
// RUN: wave-translate --wave-to-amdgpu-asm %s | FileCheck %s --check-prefix=ASM
// RUN: wave-translate --wave-to-amdgpu-asm %s | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx1100 -filetype=obj -o /dev/null

// `wavemachine.buffer_store_tuple_b32` completes the memory-op
// matrix (global / buffer / lds x load / store x single / tuple) by
// filling in the previously-missing buffer-tuple-store slot. Per-
// component IR ops mirror `global_store_tuple_b32` so each dword
// store can carry its own memory token through the selector loop
// in `selectFragmentStore` once that path lands.

module attributes {wavemachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// CHECK-LABEL: func.func @buffer_store_tuple_kernel
// CHECK: wavemachine.buffer_store_tuple_b32 %{{.*}}, %{{.*}}, %{{.*}}, %{{.*}} {component = 0 : i64}
// CHECK: wavemachine.buffer_store_tuple_b32 %{{.*}}, %{{.*}}, %{{.*}}, %{{.*}} {component = 3 : i64}

// ASM-LABEL: buffer_store_tuple_kernel:
// ASM: buffer_store_b32 {{v[0-9]+}}, {{v[0-9]+}}, s[{{[0-9]+}}:{{[0-9]+}}], 0 offen
// ASM: buffer_store_b32 {{v[0-9]+}}, {{v[0-9]+}}, s[{{[0-9]+}}:{{[0-9]+}}], 0 offen offset:12
// ASM: s_endpgm
func.func @buffer_store_tuple_kernel(%arg0: !wave.ptr<i32, #wave.global>) attributes {wave.kernel} {
  %base = wavemachine.arg {index = 0 : i64, pointer = true} : !wavemachine.reg<sgpr, 2>
  %off = wavemachine.v_mbcnt_lo : !wavemachine.reg<vgpr, 1>
  %range = wavemachine.imm 128 : !wavemachine.imm
  %zero = wavemachine.imm 0 : !wavemachine.imm
  %desc = wavemachine.make_buffer_rsrc %base, %range : (!wavemachine.reg<sgpr, 2>, !wavemachine.imm) -> !wavemachine.reg<sgpr, 4>
  %tuple = wavemachine.v_mov_b32_tuple %off : (!wavemachine.reg<vgpr, 1>) -> !wavemachine.reg<vgpr, 4>
  %t0 = wavemachine.buffer_store_tuple_b32 %off, %tuple, %desc, %zero {component = 0 : i64} : (!wavemachine.reg<vgpr, 1>, !wavemachine.reg<vgpr, 4>, !wavemachine.reg<sgpr, 4>, !wavemachine.imm) -> !wavemachine.mem.token
  %t1 = wavemachine.buffer_store_tuple_b32 %off, %tuple, %desc, %zero {component = 3 : i64} : (!wavemachine.reg<vgpr, 1>, !wavemachine.reg<vgpr, 4>, !wavemachine.reg<sgpr, 4>, !wavemachine.imm) -> !wavemachine.mem.token
  wavemachine.s_endpgm
  return
}

}
