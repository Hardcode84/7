// RUN: wave-opt --loop-invariant-code-motion %s | FileCheck %s

// uniform_loop is LoopLike: canonicalize hoists a loop-invariant body
// op (s_mul of two loop-invariant args) out above the loop, keeping
// inits/args/yield/results in sync.
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
// CHECK-LABEL: func.func @licm
// CHECK: s_mul_i32
// CHECK: uniform_loop
// CHECK-NOT: s_mul_i32
// CHECK-LABEL: func.func @licm_keeps_scc_reload
// CHECK: waveamdmachine.uniform_loop
// CHECK: ^bb0
// CHECK: waveamdmachine.s_cmp_lg_u32
// CHECK-NEXT: waveamdmachine.uniform_loop if
// CHECK-LABEL: func.func @licm_keeps_copy_tuple_carry_init
// CHECK: waveamdmachine.uniform_loop
// CHECK-NEXT: ^bb0
// CHECK-NEXT: %[[SEED:.+]] = waveamdmachine.copy_tuple
// CHECK-NEXT: waveamdmachine.uniform_loop carries(%[[SEED]]
// CHECK-LABEL: func.func @licm_keeps_smov_carry_init
// CHECK: waveamdmachine.uniform_loop
// CHECK-NEXT: ^bb0
// CHECK-NEXT: %[[INNER_LO:.+]] = waveamdmachine.s_mov_b32_value
// CHECK-NEXT: waveamdmachine.uniform_loop carries(%[[INNER_LO]]
// CHECK-LABEL: func.func @licm_keeps_vmov_tuple_carry_init
// CHECK: waveamdmachine.uniform_loop
// CHECK-NEXT: ^bb0
// CHECK-NEXT: %[[SEED:.+]] = waveamdmachine.v_mov_b32_tuple
// CHECK-NEXT: waveamdmachine.uniform_loop carries(%[[SEED]]
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

func.func @licm_keeps_scc_reload(%a: !waveamdmachine.reg<sgpr, 1>, %n: !waveamdmachine.reg<sgpr, 1>) attributes {wave.kernel} {
  %z = waveamdmachine.imm 0 : !waveamdmachine.imm
  %s = waveamdmachine.imm 1 : !waveamdmachine.imm
  %lo = waveamdmachine.s_mov_b32_value %z : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1>
  %ec = waveamdmachine.s_cmp_lt_i32 %lo, %n : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<scc, 1>
  %r = waveamdmachine.uniform_loop if %ec : !waveamdmachine.reg<scc, 1> carries(%lo : !waveamdmachine.reg<sgpr, 1>) {
  ^bb0(%iv: !waveamdmachine.reg<sgpr, 1>):
    %inner_cond = waveamdmachine.s_cmp_lg_u32 %a, %z : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm) -> !waveamdmachine.reg<scc, 1>
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

func.func @licm_keeps_copy_tuple_carry_init(%n: !waveamdmachine.reg<sgpr, 1>) attributes {wave.kernel} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %one = waveamdmachine.imm 1 : !waveamdmachine.imm
  %zero_v = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %lo = waveamdmachine.s_mov_b32_value %zero
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1>
  %outer_entry = waveamdmachine.s_cmp_lt_i32 %lo, %n
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
      -> !waveamdmachine.reg<scc, 1>
  %outer = waveamdmachine.uniform_loop if %outer_entry
      : !waveamdmachine.reg<scc, 1>
      carries(%lo : !waveamdmachine.reg<sgpr, 1>) {
  ^bb0(%i: !waveamdmachine.reg<sgpr, 1>):
    %seed = waveamdmachine.copy_tuple %zero_v
        : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
    %inner = waveamdmachine.uniform_loop
        carries(%seed : !waveamdmachine.reg<vgpr, 1>) {
    ^bb0(%acc: !waveamdmachine.reg<vgpr, 1>):
      %next_acc = waveamdmachine.v_add_u32 %acc, %acc
          : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
      %inner_back = waveamdmachine.s_cmp_lg_u32 %lo, %lo
          : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
          -> !waveamdmachine.reg<scc, 1>
      waveamdmachine.continue_if %inner_back
          : !waveamdmachine.reg<scc, 1>
          carries(%next_acc : !waveamdmachine.reg<vgpr, 1>)
    } -> !waveamdmachine.reg<vgpr, 1>
    %next_i, %scc = waveamdmachine.s_add_i32 %i, %one
        : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm)
        -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
    %outer_back = waveamdmachine.s_cmp_lt_i32 %next_i, %n
        : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
        -> !waveamdmachine.reg<scc, 1>
    waveamdmachine.continue_if %outer_back
        : !waveamdmachine.reg<scc, 1>
        carries(%next_i : !waveamdmachine.reg<sgpr, 1>)
  } -> !waveamdmachine.reg<sgpr, 1>
  waveamdmachine.s_endpgm
  return
}

func.func @licm_keeps_smov_carry_init(%n: !waveamdmachine.reg<sgpr, 1>) attributes {wave.kernel} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %one = waveamdmachine.imm 1 : !waveamdmachine.imm
  %lo = waveamdmachine.s_mov_b32_value %zero
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1>
  %outer_entry = waveamdmachine.s_cmp_lt_i32 %lo, %n
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
      -> !waveamdmachine.reg<scc, 1>
  %outer = waveamdmachine.uniform_loop if %outer_entry
      : !waveamdmachine.reg<scc, 1>
      carries(%lo : !waveamdmachine.reg<sgpr, 1>) {
  ^bb0(%i: !waveamdmachine.reg<sgpr, 1>):
    %inner_lo = waveamdmachine.s_mov_b32_value %zero
        : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1>
    %inner = waveamdmachine.uniform_loop
        carries(%inner_lo : !waveamdmachine.reg<sgpr, 1>) {
    ^bb0(%j: !waveamdmachine.reg<sgpr, 1>):
      %next_j, %next_j_scc = waveamdmachine.s_add_i32 %j, %one
          : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm)
          -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
      %inner_back = waveamdmachine.s_cmp_lg_u32 %j, %j
          : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
          -> !waveamdmachine.reg<scc, 1>
      waveamdmachine.continue_if %inner_back
          : !waveamdmachine.reg<scc, 1>
          carries(%next_j : !waveamdmachine.reg<sgpr, 1>)
    } -> !waveamdmachine.reg<sgpr, 1>
    %next_i, %scc = waveamdmachine.s_add_i32 %i, %one
        : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm)
        -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
    %outer_back = waveamdmachine.s_cmp_lt_i32 %next_i, %n
        : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
        -> !waveamdmachine.reg<scc, 1>
    waveamdmachine.continue_if %outer_back
        : !waveamdmachine.reg<scc, 1>
        carries(%next_i : !waveamdmachine.reg<sgpr, 1>)
  } -> !waveamdmachine.reg<sgpr, 1>
  waveamdmachine.s_endpgm
  return
}

func.func @licm_keeps_vmov_tuple_carry_init(%n: !waveamdmachine.reg<sgpr, 1>) attributes {wave.kernel} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %one = waveamdmachine.imm 1 : !waveamdmachine.imm
  %lo = waveamdmachine.s_mov_b32_value %zero
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1>
  %outer_entry = waveamdmachine.s_cmp_lt_i32 %lo, %n
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
      -> !waveamdmachine.reg<scc, 1>
  %outer = waveamdmachine.uniform_loop if %outer_entry
      : !waveamdmachine.reg<scc, 1>
      carries(%lo : !waveamdmachine.reg<sgpr, 1>) {
  ^bb0(%i: !waveamdmachine.reg<sgpr, 1>):
    %seed = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
        : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
    %inner = waveamdmachine.uniform_loop
        carries(%seed : !waveamdmachine.reg<vgpr, 1>) {
    ^bb0(%acc: !waveamdmachine.reg<vgpr, 1>):
      %next_acc = waveamdmachine.v_add_u32 %acc, %acc
          : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
      %inner_back = waveamdmachine.s_cmp_lg_u32 %lo, %lo
          : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
          -> !waveamdmachine.reg<scc, 1>
      waveamdmachine.continue_if %inner_back
          : !waveamdmachine.reg<scc, 1>
          carries(%next_acc : !waveamdmachine.reg<vgpr, 1>)
    } -> !waveamdmachine.reg<vgpr, 1>
    %next_i, %scc = waveamdmachine.s_add_i32 %i, %one
        : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm)
        -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
    %outer_back = waveamdmachine.s_cmp_lt_i32 %next_i, %n
        : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
        -> !waveamdmachine.reg<scc, 1>
    waveamdmachine.continue_if %outer_back
        : !waveamdmachine.reg<scc, 1>
        carries(%next_i : !waveamdmachine.reg<sgpr, 1>)
  } -> !waveamdmachine.reg<sgpr, 1>
  waveamdmachine.s_endpgm
  return
}
}
