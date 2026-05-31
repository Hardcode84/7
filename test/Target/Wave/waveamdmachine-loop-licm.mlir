// RUN: wave-opt --loop-invariant-code-motion %s | FileCheck %s

// uniform_loop is LoopLike: canonicalize hoists a loop-invariant body
// op (s_mul of two loop-invariant args) out above the loop, keeping
// inits/args/yield/results in sync.
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
// CHECK-LABEL: func.func @licm
// CHECK: s_mul_i32
// CHECK: uniform_loop
// CHECK-NOT: s_mul_i32
// CHECK-LABEL: func.func @licm_keeps_singleton_resources
// CHECK: waveamdmachine.uniform_loop
// CHECK: ^bb0
// CHECK: waveamdmachine.s_cmp_lt_i32
// CHECK-NEXT: waveamdmachine.uniform_loop if
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

func.func @licm_keeps_singleton_resources(%a: !waveamdmachine.reg<sgpr, 1>, %n: !waveamdmachine.reg<sgpr, 1>) attributes {wave.kernel} {
  %z = waveamdmachine.imm 0 : !waveamdmachine.imm
  %s = waveamdmachine.imm 1 : !waveamdmachine.imm
  %lo = waveamdmachine.s_mov_b32_value %z : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1>
  %ec = waveamdmachine.s_cmp_lt_i32 %lo, %n : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<scc, 1>
  %r = waveamdmachine.uniform_loop if %ec : !waveamdmachine.reg<scc, 1> carries(%lo : !waveamdmachine.reg<sgpr, 1>) {
  ^bb0(%iv: !waveamdmachine.reg<sgpr, 1>):
    %inner_cond = waveamdmachine.s_cmp_lt_i32 %a, %n : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<scc, 1>
    %inner = waveamdmachine.uniform_loop if %inner_cond : !waveamdmachine.reg<scc, 1> carries(%lo : !waveamdmachine.reg<sgpr, 1>) {
    ^bb0(%j: !waveamdmachine.reg<sgpr, 1>):
      %next_j, %next_j_scc = waveamdmachine.s_add_i32 %j, %s : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm) -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
      %inner_back = waveamdmachine.s_cmp_lt_i32 %next_j, %n : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<scc, 1>
      waveamdmachine.continue_if %inner_back : !waveamdmachine.reg<scc, 1> carries(%next_j : !waveamdmachine.reg<sgpr, 1>)
    } -> !waveamdmachine.reg<sgpr, 1>
    %next_i, %next_i_scc = waveamdmachine.s_add_i32 %iv, %s : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm) -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
    %outer_back = waveamdmachine.s_cmp_lt_i32 %next_i, %n : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<scc, 1>
    waveamdmachine.continue_if %outer_back : !waveamdmachine.reg<scc, 1> carries(%next_i : !waveamdmachine.reg<sgpr, 1>)
  } -> !waveamdmachine.reg<sgpr, 1>
  waveamdmachine.s_endpgm
  return
}
}
