// RUN: wave-opt --waveamd-reg-alloc %s | FileCheck %s

module attributes {wavemachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// Two iter_arg slots fed by the same fragment_fill SSA value -- the
// classic wmma accumulator pattern (acc[0] and acc[1] both start at
// zero). The regalloc must materialize a separate copy for slot 1 so
// the two carries don't collapse onto one physical VGPR tuple and
// silently clobber each other.
//
// CHECK-LABEL: func.func @duplicate_vgpr_init
// CHECK: %[[INIT:.+]] = wavemachine.v_mov_b32_tuple {{.*}} {registers = 8 : i64} : (!wavemachine.imm) -> !wavemachine.reg<vgpr, 8, {{[0-9]+}}>
// CHECK: %[[DUP:.+]] = wavemachine.v_mov_b32_tuple %[[INIT]] {registers = 8 : i64} : (!wavemachine.reg<vgpr, 8, {{[0-9]+}}>) -> !wavemachine.reg<vgpr, 8, {{[0-9]+}}>
// CHECK: wavemachine.uniform_loop {{.*}} carries(%{{[^,]+}}, %[[INIT]], %[[DUP]] : {{[^)]*}})
func.func @duplicate_vgpr_init() attributes {wave.kernel} {
  %zero = wavemachine.imm 0 : !wavemachine.imm
  %one = wavemachine.imm 1 : !wavemachine.imm
  %four = wavemachine.imm 4 : !wavemachine.imm
  %init_fill = wavemachine.v_mov_b32_tuple %zero {registers = 8 : i64}
      : (!wavemachine.imm) -> !wavemachine.reg<vgpr, 8>
  %iv = wavemachine.s_mov_b32_value %zero
      : (!wavemachine.imm) -> !wavemachine.reg<sgpr, 1>
  %ec = wavemachine.s_cmp_lt_i32 %zero, %four
      : (!wavemachine.imm, !wavemachine.imm) -> !wavemachine.reg<scc, 1>
  %results:3 = wavemachine.uniform_loop if %ec : !wavemachine.reg<scc, 1>
      carries(%iv, %init_fill, %init_fill :
              !wavemachine.reg<sgpr, 1>,
              !wavemachine.reg<vgpr, 8>,
              !wavemachine.reg<vgpr, 8>) {
  ^bb0(%cur_iv: !wavemachine.reg<sgpr, 1>,
       %acc0: !wavemachine.reg<vgpr, 8>,
       %acc1: !wavemachine.reg<vgpr, 8>):
    %niv, %scc = wavemachine.s_add_i32 %cur_iv, %one
        : (!wavemachine.reg<sgpr, 1>, !wavemachine.imm)
          -> (!wavemachine.reg<sgpr, 1>, !wavemachine.reg<scc, 1>)
    %new_acc0 = wavemachine.v_mov_b32_tuple %acc0 {registers = 8 : i64}
        : (!wavemachine.reg<vgpr, 8>) -> !wavemachine.reg<vgpr, 8>
    %new_acc1 = wavemachine.v_mov_b32_tuple %acc1 {registers = 8 : i64}
        : (!wavemachine.reg<vgpr, 8>) -> !wavemachine.reg<vgpr, 8>
    %bc = wavemachine.s_cmp_lt_i32 %niv, %four
        : (!wavemachine.reg<sgpr, 1>, !wavemachine.imm) -> !wavemachine.reg<scc, 1>
    wavemachine.continue_if %bc : !wavemachine.reg<scc, 1>
        carries(%niv, %new_acc0, %new_acc1 :
                !wavemachine.reg<sgpr, 1>,
                !wavemachine.reg<vgpr, 8>,
                !wavemachine.reg<vgpr, 8>)
  } -> !wavemachine.reg<sgpr, 1>, !wavemachine.reg<vgpr, 8>, !wavemachine.reg<vgpr, 8>
  return
}

// Single-iter-arg + non-duplicate pair: no copy is needed. The pre-pass
// must leave the loop's init list alone (no extra v_mov_b32_tuple
// before it).
//
// CHECK-LABEL: func.func @no_duplicate_inits
// CHECK: %[[A:.+]] = wavemachine.v_mov_b32_tuple {{.*}} {registers = 8 : i64}
// CHECK-NEXT: %[[B:.+]] = wavemachine.v_mov_b32_tuple {{.*}} {registers = 8 : i64}
// CHECK-NOT: wavemachine.v_mov_b32_tuple
// CHECK: wavemachine.uniform_loop {{.*}} carries(%{{[^,]+}}, %[[A]], %[[B]] : {{[^)]*}})
func.func @no_duplicate_inits() attributes {wave.kernel} {
  %zero = wavemachine.imm 0 : !wavemachine.imm
  %one = wavemachine.imm 1 : !wavemachine.imm
  %four = wavemachine.imm 4 : !wavemachine.imm
  %init_a = wavemachine.v_mov_b32_tuple %zero {registers = 8 : i64}
      : (!wavemachine.imm) -> !wavemachine.reg<vgpr, 8>
  %init_b = wavemachine.v_mov_b32_tuple %one {registers = 8 : i64}
      : (!wavemachine.imm) -> !wavemachine.reg<vgpr, 8>
  %iv = wavemachine.s_mov_b32_value %zero
      : (!wavemachine.imm) -> !wavemachine.reg<sgpr, 1>
  %ec = wavemachine.s_cmp_lt_i32 %zero, %four
      : (!wavemachine.imm, !wavemachine.imm) -> !wavemachine.reg<scc, 1>
  %results:3 = wavemachine.uniform_loop if %ec : !wavemachine.reg<scc, 1>
      carries(%iv, %init_a, %init_b :
              !wavemachine.reg<sgpr, 1>,
              !wavemachine.reg<vgpr, 8>,
              !wavemachine.reg<vgpr, 8>) {
  ^bb0(%cur_iv: !wavemachine.reg<sgpr, 1>,
       %a: !wavemachine.reg<vgpr, 8>,
       %b: !wavemachine.reg<vgpr, 8>):
    %niv, %scc = wavemachine.s_add_i32 %cur_iv, %one
        : (!wavemachine.reg<sgpr, 1>, !wavemachine.imm)
          -> (!wavemachine.reg<sgpr, 1>, !wavemachine.reg<scc, 1>)
    %bc = wavemachine.s_cmp_lt_i32 %niv, %four
        : (!wavemachine.reg<sgpr, 1>, !wavemachine.imm) -> !wavemachine.reg<scc, 1>
    wavemachine.continue_if %bc : !wavemachine.reg<scc, 1>
        carries(%niv, %a, %b :
                !wavemachine.reg<sgpr, 1>,
                !wavemachine.reg<vgpr, 8>,
                !wavemachine.reg<vgpr, 8>)
  } -> !wavemachine.reg<sgpr, 1>, !wavemachine.reg<vgpr, 8>, !wavemachine.reg<vgpr, 8>
  return
}

// SGPR1 duplicate inits also get split (via s_mov_b32_value).
//
// CHECK-LABEL: func.func @duplicate_sgpr1_init
// CHECK: %[[SINIT:.+]] = wavemachine.s_mov_b32_value {{.*}} : (!wavemachine.imm) -> !wavemachine.reg<sgpr, 1, {{[0-9]+}}>
// CHECK: %[[SDUP:.+]] = wavemachine.s_mov_b32_value %[[SINIT]] : (!wavemachine.reg<sgpr, 1, {{[0-9]+}}>) -> !wavemachine.reg<sgpr, 1, {{[0-9]+}}>
// CHECK: wavemachine.uniform_loop {{.*}} carries({{[^,]+}}, %[[SINIT]], %[[SDUP]] : {{[^)]*}})
func.func @duplicate_sgpr1_init() attributes {wave.kernel} {
  %zero = wavemachine.imm 0 : !wavemachine.imm
  %one = wavemachine.imm 1 : !wavemachine.imm
  %four = wavemachine.imm 4 : !wavemachine.imm
  %init = wavemachine.s_mov_b32_value %zero
      : (!wavemachine.imm) -> !wavemachine.reg<sgpr, 1>
  %iv = wavemachine.s_mov_b32_value %zero
      : (!wavemachine.imm) -> !wavemachine.reg<sgpr, 1>
  %ec = wavemachine.s_cmp_lt_i32 %zero, %four
      : (!wavemachine.imm, !wavemachine.imm) -> !wavemachine.reg<scc, 1>
  %results:3 = wavemachine.uniform_loop if %ec : !wavemachine.reg<scc, 1>
      carries(%iv, %init, %init :
              !wavemachine.reg<sgpr, 1>,
              !wavemachine.reg<sgpr, 1>,
              !wavemachine.reg<sgpr, 1>) {
  ^bb0(%cur_iv: !wavemachine.reg<sgpr, 1>,
       %a: !wavemachine.reg<sgpr, 1>,
       %b: !wavemachine.reg<sgpr, 1>):
    %niv, %scc = wavemachine.s_add_i32 %cur_iv, %one
        : (!wavemachine.reg<sgpr, 1>, !wavemachine.imm)
          -> (!wavemachine.reg<sgpr, 1>, !wavemachine.reg<scc, 1>)
    %bc = wavemachine.s_cmp_lt_i32 %niv, %four
        : (!wavemachine.reg<sgpr, 1>, !wavemachine.imm) -> !wavemachine.reg<scc, 1>
    wavemachine.continue_if %bc : !wavemachine.reg<scc, 1>
        carries(%niv, %a, %b :
                !wavemachine.reg<sgpr, 1>,
                !wavemachine.reg<sgpr, 1>,
                !wavemachine.reg<sgpr, 1>)
  } -> !wavemachine.reg<sgpr, 1>, !wavemachine.reg<sgpr, 1>, !wavemachine.reg<sgpr, 1>
  return
}

}
