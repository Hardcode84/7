// RUN: wave-opt --waveamd-reg-alloc %s | FileCheck %s
// RUN: wave-opt --waveamd-reg-alloc %s | wave-opt | FileCheck %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// Two iter_arg slots fed by the same fragment_fill SSA value -- the
// classic wmma accumulator pattern (acc[0] and acc[1] both start at
// zero). The regalloc must materialize a separate copy for slot 1 so
// the two carries don't collapse onto one physical VGPR tuple and
// silently clobber each other.
//
// CHECK-LABEL: func.func @duplicate_vgpr_init
// CHECK: %[[INIT:.+]] = waveamdmachine.v_mov_b32_tuple {{.*}} {registers = 8 : i64} : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 8, {{[0-9]+}}>
// CHECK: %[[DUP:.+]] = waveamdmachine.v_mov_b32_tuple {{.*}} {registers = 8 : i64} : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 8, {{[0-9]+}}>
// CHECK: waveamdmachine.uniform_loop {{.*}} carries(%{{[^,]+}}, %[[INIT]], %[[DUP]] : {{[^)]*}})
func.func @duplicate_vgpr_init() attributes {wave.kernel} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %one = waveamdmachine.imm 1 : !waveamdmachine.imm
  %four = waveamdmachine.imm 4 : !waveamdmachine.imm
  %init_fill = waveamdmachine.v_mov_b32_tuple %zero {registers = 8 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 8>
  %iv = waveamdmachine.s_mov_b32_value %zero
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1>
  %ec = waveamdmachine.s_cmp_lt_i32 %zero, %four
      : (!waveamdmachine.imm, !waveamdmachine.imm) -> !waveamdmachine.reg<scc, 1>
  %results:3 = waveamdmachine.uniform_loop if %ec : !waveamdmachine.reg<scc, 1>
      carries(%iv, %init_fill, %init_fill :
              !waveamdmachine.reg<sgpr, 1>,
              !waveamdmachine.reg<vgpr, 8>,
              !waveamdmachine.reg<vgpr, 8>) {
  ^bb0(%cur_iv: !waveamdmachine.reg<sgpr, 1>,
       %acc0: !waveamdmachine.reg<vgpr, 8>,
       %acc1: !waveamdmachine.reg<vgpr, 8>):
    %niv, %scc = waveamdmachine.s_add_i32 %cur_iv, %one
        : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm)
          -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
    %new_acc0 = waveamdmachine.v_mov_b32_tuple %acc0 {registers = 8 : i64}
        : (!waveamdmachine.reg<vgpr, 8>) -> !waveamdmachine.reg<vgpr, 8>
    %new_acc1 = waveamdmachine.v_mov_b32_tuple %acc1 {registers = 8 : i64}
        : (!waveamdmachine.reg<vgpr, 8>) -> !waveamdmachine.reg<vgpr, 8>
    %bc = waveamdmachine.s_cmp_lt_i32 %niv, %four
        : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm) -> !waveamdmachine.reg<scc, 1>
    waveamdmachine.continue_if %bc : !waveamdmachine.reg<scc, 1>
        carries(%niv, %new_acc0, %new_acc1 :
                !waveamdmachine.reg<sgpr, 1>,
                !waveamdmachine.reg<vgpr, 8>,
                !waveamdmachine.reg<vgpr, 8>)
  } -> !waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<vgpr, 8>, !waveamdmachine.reg<vgpr, 8>
  return
}

// Single-iter-arg + non-duplicate pair: no copy is needed. The pre-pass
// must leave the loop's init list alone (no extra v_mov_b32_tuple
// before it).
//
// CHECK-LABEL: func.func @no_duplicate_inits
// CHECK: %[[A:.+]] = waveamdmachine.v_mov_b32_tuple {{.*}} {registers = 8 : i64}
// CHECK-NEXT: %[[B:.+]] = waveamdmachine.v_mov_b32_tuple {{.*}} {registers = 8 : i64}
// CHECK-NOT: waveamdmachine.v_mov_b32_tuple
// CHECK: waveamdmachine.uniform_loop {{.*}} carries(%{{[^,]+}}, %[[A]], %[[B]] : {{[^)]*}})
func.func @no_duplicate_inits() attributes {wave.kernel} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %one = waveamdmachine.imm 1 : !waveamdmachine.imm
  %four = waveamdmachine.imm 4 : !waveamdmachine.imm
  %init_a = waveamdmachine.v_mov_b32_tuple %zero {registers = 8 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 8>
  %init_b = waveamdmachine.v_mov_b32_tuple %one {registers = 8 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 8>
  %iv = waveamdmachine.s_mov_b32_value %zero
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1>
  %ec = waveamdmachine.s_cmp_lt_i32 %zero, %four
      : (!waveamdmachine.imm, !waveamdmachine.imm) -> !waveamdmachine.reg<scc, 1>
  %results:3 = waveamdmachine.uniform_loop if %ec : !waveamdmachine.reg<scc, 1>
      carries(%iv, %init_a, %init_b :
              !waveamdmachine.reg<sgpr, 1>,
              !waveamdmachine.reg<vgpr, 8>,
              !waveamdmachine.reg<vgpr, 8>) {
  ^bb0(%cur_iv: !waveamdmachine.reg<sgpr, 1>,
       %a: !waveamdmachine.reg<vgpr, 8>,
       %b: !waveamdmachine.reg<vgpr, 8>):
    %niv, %scc = waveamdmachine.s_add_i32 %cur_iv, %one
        : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm)
          -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
    %bc = waveamdmachine.s_cmp_lt_i32 %niv, %four
        : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm) -> !waveamdmachine.reg<scc, 1>
    waveamdmachine.continue_if %bc : !waveamdmachine.reg<scc, 1>
        carries(%niv, %a, %b :
                !waveamdmachine.reg<sgpr, 1>,
                !waveamdmachine.reg<vgpr, 8>,
                !waveamdmachine.reg<vgpr, 8>)
  } -> !waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<vgpr, 8>, !waveamdmachine.reg<vgpr, 8>
  return
}

// SGPR1 duplicate inits also get split. The selector materialises
// the init via `s_mov_b32_value`; the regalloc's split inserts an
// `s_mov_b32_tuple` (registers = 1) rename so the two carry slots
// see distinct SSA values.
//
// CHECK-LABEL: func.func @duplicate_sgpr1_init
// CHECK: %[[SINIT:.+]] = waveamdmachine.s_mov_b32_value {{.*}} : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1, {{[0-9]+}}>
// CHECK: %[[SDUP:.+]] = waveamdmachine.s_mov_b32_tuple %[[SINIT]] {registers = 1 : i64} : (!waveamdmachine.reg<sgpr, 1, {{[0-9]+}}>) -> !waveamdmachine.reg<sgpr, 1, {{[0-9]+}}>
// CHECK: waveamdmachine.uniform_loop {{.*}} carries({{[^,]+}}, %[[SINIT]], %[[SDUP]] : {{[^)]*}})
func.func @duplicate_sgpr1_init() attributes {wave.kernel} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %one = waveamdmachine.imm 1 : !waveamdmachine.imm
  %four = waveamdmachine.imm 4 : !waveamdmachine.imm
  %init = waveamdmachine.s_mov_b32_value %zero
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1>
  %iv = waveamdmachine.s_mov_b32_value %zero
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1>
  %ec = waveamdmachine.s_cmp_lt_i32 %zero, %four
      : (!waveamdmachine.imm, !waveamdmachine.imm) -> !waveamdmachine.reg<scc, 1>
  %results:3 = waveamdmachine.uniform_loop if %ec : !waveamdmachine.reg<scc, 1>
      carries(%iv, %init, %init :
              !waveamdmachine.reg<sgpr, 1>,
              !waveamdmachine.reg<sgpr, 1>,
              !waveamdmachine.reg<sgpr, 1>) {
  ^bb0(%cur_iv: !waveamdmachine.reg<sgpr, 1>,
       %a: !waveamdmachine.reg<sgpr, 1>,
       %b: !waveamdmachine.reg<sgpr, 1>):
    %niv, %scc = waveamdmachine.s_add_i32 %cur_iv, %one
        : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm)
          -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
    %bc = waveamdmachine.s_cmp_lt_i32 %niv, %four
        : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm) -> !waveamdmachine.reg<scc, 1>
    waveamdmachine.continue_if %bc : !waveamdmachine.reg<scc, 1>
        carries(%niv, %a, %b :
                !waveamdmachine.reg<sgpr, 1>,
                !waveamdmachine.reg<sgpr, 1>,
                !waveamdmachine.reg<sgpr, 1>)
  } -> !waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>
  return
}

// Pre-pinned fragment carry (vgpr,8 at fixed index) + a pinned
// tuple_to_elements inside the body. Pinned regs get no live
// interval, so loop-entry-carry and tuple coalesce must skip them
// instead of failing "coalesce: primary has no interval". This was
// the WMMA matmul accumulator carry. Just need it to not crash.
// CHECK-LABEL: func.func @pinned_fragment_carry
// CHECK: waveamdmachine.uniform_loop carries
// CHECK: waveamdmachine.tuple_to_elements
func.func @pinned_fragment_carry(%init: !waveamdmachine.reg<vgpr, 8, 16>)
    attributes {wave.kernel} {
  %z = waveamdmachine.imm 0 : !waveamdmachine.imm
  %iv = waveamdmachine.s_mov_b32_value %z
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1>
  %r:2 = waveamdmachine.uniform_loop carries(%iv, %init :
      !waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<vgpr, 8, 16>) {
  ^bb0(%a: !waveamdmachine.reg<sgpr, 1>, %f: !waveamdmachine.reg<vgpr, 8, 16>):
    %e:8 = waveamdmachine.tuple_to_elements %f
        : (!waveamdmachine.reg<vgpr, 8, 16>)
        -> (!waveamdmachine.reg<vgpr, 1, 16>, !waveamdmachine.reg<vgpr, 1, 17>,
            !waveamdmachine.reg<vgpr, 1, 18>, !waveamdmachine.reg<vgpr, 1, 19>,
            !waveamdmachine.reg<vgpr, 1, 20>, !waveamdmachine.reg<vgpr, 1, 21>,
            !waveamdmachine.reg<vgpr, 1, 22>, !waveamdmachine.reg<vgpr, 1, 23>)
    %n:2 = waveamdmachine.s_add_i32 %a, %z
        : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm)
        -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
    waveamdmachine.continue_if %n#1 : !waveamdmachine.reg<scc, 1>
        carries(%n#0, %f : !waveamdmachine.reg<sgpr, 1>,
                !waveamdmachine.reg<vgpr, 8, 16>)
  } -> !waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<vgpr, 8, 16>
  return
}

// Loop-invariant bases used inside the body stay live across the backedge.
// CHECK-LABEL: func.func @external_loop_base_live_across_backedge
// CHECK: %[[ABASE:.+]] = waveamdmachine.s_load_b64 {{.*}} -> !waveamdmachine.reg<sgpr, 2, [[ABASE_REG:[0-9]+]]>
// CHECK: %[[BBASE:.+]] = waveamdmachine.s_load_b64 {{.*}} -> !waveamdmachine.reg<sgpr, 2, {{[0-9]+}}>
// CHECK: waveamdmachine.uniform_loop
// CHECK: %{{.+}}, %{{.*}} = waveamdmachine.s_add_u64_u32 %[[ABASE]],
// CHECK-NOT: waveamdmachine.s_add_u64_u32 {{.*}} -> (!waveamdmachine.reg<sgpr, 2, [[ABASE_REG]]>
// CHECK: %{{.+}}, %{{.*}} = waveamdmachine.s_add_u64_u32 %[[BBASE]],
func.func @external_loop_base_live_across_backedge() attributes {wave.kernel} {
  %z = waveamdmachine.imm 0 : !waveamdmachine.imm
  %one = waveamdmachine.imm 1 : !waveamdmachine.imm
  %five = waveamdmachine.imm 5 : !waveamdmachine.imm
  %eight = waveamdmachine.imm 8 : !waveamdmachine.imm
  %limit = waveamdmachine.imm 4 : !waveamdmachine.imm
  %abase = waveamdmachine.s_load_b64 %z, "s[0:1]"
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 2>
  %bbase = waveamdmachine.s_load_b64 %eight, "s[0:1]"
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 2>
  %off = waveamdmachine.v_workitem_id_x : !waveamdmachine.reg<vgpr, 1>
  %iv = waveamdmachine.s_mov_b32_value %z
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1>
  %ec = waveamdmachine.s_cmp_lt_i32 %z, %limit
      : (!waveamdmachine.imm, !waveamdmachine.imm) -> !waveamdmachine.reg<scc, 1>
  %r = waveamdmachine.uniform_loop if %ec : !waveamdmachine.reg<scc, 1>
      carries(%iv : !waveamdmachine.reg<sgpr, 1>) {
  ^bb0(%cur: !waveamdmachine.reg<sgpr, 1>):
    %step, %shift_scc = waveamdmachine.s_lshl_b32 %cur, %five
        : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm)
          -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
    %ap, %ap_scc = waveamdmachine.s_add_u64_u32 %abase, %step
        : (!waveamdmachine.reg<sgpr, 2>, !waveamdmachine.reg<sgpr, 1>)
          -> (!waveamdmachine.reg<sgpr, 2>, !waveamdmachine.reg<scc, 1>)
    %bp, %bp_scc = waveamdmachine.s_add_u64_u32 %bbase, %step
        : (!waveamdmachine.reg<sgpr, 2>, !waveamdmachine.reg<sgpr, 1>)
          -> (!waveamdmachine.reg<sgpr, 2>, !waveamdmachine.reg<scc, 1>)
    %av, %atok = waveamdmachine.global_load_b32 %off, %ap
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>)
          -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
    %bv, %btok = waveamdmachine.global_load_b32 %off, %bp
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>)
          -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token)
    %next, %add_scc = waveamdmachine.s_add_i32 %cur, %one
        : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm)
          -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
    %bc = waveamdmachine.s_cmp_lt_i32 %next, %limit
        : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm)
          -> !waveamdmachine.reg<scc, 1>
    waveamdmachine.continue_if %bc : !waveamdmachine.reg<scc, 1>
        carries(%next : !waveamdmachine.reg<sgpr, 1>)
  } -> !waveamdmachine.reg<sgpr, 1>
  waveamdmachine.s_endpgm
  return
}

// Back-edge copy must happen after old carry's last use.
// CHECK-LABEL: func.func @backedge_copy_after_old_use
// CHECK: waveamdmachine.uniform_loop
// CHECK: %[[NEXT:.+]] = waveamdmachine.v_add_f32
// CHECK: waveamdmachine.v_sub_f32 {{.*}}, %[[NEXT]]
// CHECK: %[[COPY:.+]] = waveamdmachine.v_mov_b32_tuple %[[NEXT]]
// CHECK: waveamdmachine.continue_if {{.*}}carries({{[^,]+}}, %[[COPY]]
func.func @backedge_copy_after_old_use() attributes {wave.kernel} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %one = waveamdmachine.imm 1 : !waveamdmachine.imm
  %four = waveamdmachine.imm 4 : !waveamdmachine.imm
  %init = waveamdmachine.v_mov_b32_tuple %zero {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %stepv = waveamdmachine.v_mov_b32_tuple %one {registers = 1 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
  %iv = waveamdmachine.s_mov_b32_value %zero
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1>
  %ec = waveamdmachine.s_cmp_lt_i32 %zero, %four
      : (!waveamdmachine.imm, !waveamdmachine.imm) -> !waveamdmachine.reg<scc, 1>
  %results:2 = waveamdmachine.uniform_loop if %ec : !waveamdmachine.reg<scc, 1>
      carries(%iv, %init :
              !waveamdmachine.reg<sgpr, 1>,
              !waveamdmachine.reg<vgpr, 1>) {
  ^bb0(%cur_iv: !waveamdmachine.reg<sgpr, 1>,
       %cur: !waveamdmachine.reg<vgpr, 1>):
    %next = waveamdmachine.v_add_f32 %cur, %stepv
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
    %old_use = waveamdmachine.v_sub_f32 %cur, %next
        : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
          -> !waveamdmachine.reg<vgpr, 1>
    %niv, %scc = waveamdmachine.s_add_i32 %cur_iv, %one
        : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm)
          -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
    %bc = waveamdmachine.s_cmp_lt_i32 %niv, %four
        : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm)
          -> !waveamdmachine.reg<scc, 1>
    waveamdmachine.continue_if %bc : !waveamdmachine.reg<scc, 1>
        carries(%niv, %next :
                !waveamdmachine.reg<sgpr, 1>,
                !waveamdmachine.reg<vgpr, 1>)
  } -> !waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<vgpr, 1>
  waveamdmachine.s_endpgm
  return
}

}
