// RUN: wave-opt --loop-invariant-code-motion %s | FileCheck %s

// uniform_loop is LoopLike: canonicalize hoists a loop-invariant body
// op (s_mul of two loop-invariant args) out above the loop, keeping
// inits/args/yield/results in sync.
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
// CHECK-LABEL: func.func @licm
// CHECK: s_mul_i32
// CHECK: uniform_loop
// CHECK-NOT: s_mul_i32
func.func @licm(%a: !waveamdmachine.reg<sgpr, 1>, %n: !waveamdmachine.reg<sgpr, 1>) attributes {wave.kernel} {
  %z = waveamdmachine.imm 0 : !waveamdmachine.imm
  %s = waveamdmachine.imm 1 : !waveamdmachine.imm
  %lo = waveamdmachine.s_mov_b32_value %z : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1>
  %ec = waveamdmachine.s_cmp_lt_i32 %lo, %n : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<scc, 1>
  %r = waveamdmachine.uniform_loop if %ec : !waveamdmachine.reg<scc, 1> carries(%lo : !waveamdmachine.reg<sgpr, 1>) {
  ^bb0(%iv: !waveamdmachine.reg<sgpr, 1>):
    %inv = waveamdmachine.s_mul_i32 %a, %a : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<sgpr, 1>
    %ni, %sc = waveamdmachine.s_add_i32 %inv, %s : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm) -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
    %bc = waveamdmachine.s_cmp_lt_i32 %ni, %n : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<scc, 1>
    waveamdmachine.continue_if %bc : !waveamdmachine.reg<scc, 1> carries(%ni : !waveamdmachine.reg<sgpr, 1>)
  } -> !waveamdmachine.reg<sgpr, 1>
  waveamdmachine.s_endpgm
  return
}
}
