// RUN: wave-opt %s --remove-dead-values --canonicalize -o %t.mlir
// RUN: wave-translate %t.mlir --wave-to-amdgpu-asm | FileCheck %s
// RUN: wave-translate %t.mlir --wave-to-amdgpu-asm | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx950 -filetype=obj -o /dev/null

// CHECK-LABEL: dead_carry_codegen:
// CHECK-NOT: s_mul_i32
// CHECK: s_add_i32
// CHECK-NOT: s_mul_i32
// CHECK: s_cmp_lt_i32
// CHECK-NOT: s_mul_i32
// CHECK: s_cbranch_scc1
// CHECK-NOT: s_mul_i32
// CHECK: s_endpgm

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @dead_carry_codegen() attributes {wave.kernel} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %one = waveamdmachine.imm 1 : !waveamdmachine.imm
  %three = waveamdmachine.imm 3 : !waveamdmachine.imm
  %init = waveamdmachine.s_mov_b32_value %zero : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1>
  %dead = waveamdmachine.s_mov_b32_value %three : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1>
  %token = waveamdmachine.token : !waveamdmachine.mem.token
  %loop:2 = waveamdmachine.uniform_loop carries(%init, %dead : !waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>) {
  ^bb0(%iv: !waveamdmachine.reg<sgpr, 1>, %carry: !waveamdmachine.reg<sgpr, 1>):
    %next:2 = waveamdmachine.s_add_i32 %iv, %one : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm) -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
    %unused = waveamdmachine.s_mul_i32 %carry, %three : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1>
    waveamdmachine.s_barrier %token : (!waveamdmachine.mem.token) -> ()
    %cond = waveamdmachine.s_cmp_lt_i32 %next#0, %three : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm) -> !waveamdmachine.reg<scc, 1>
    waveamdmachine.continue_if %cond : !waveamdmachine.reg<scc, 1> carries(%next#0, %unused : !waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
  } {waveamdmachine.trip_count = 3 : i64} -> !waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>
  waveamdmachine.s_endpgm
  return
}
}
