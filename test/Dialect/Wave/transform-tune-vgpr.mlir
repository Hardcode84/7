// End-to-end autotune: vary `k_unroll`, run the real wave backend
// stages (specialize -> reg-alloc with mark-overflow -> resource-info),
// score by `waveamdmachine.vgpr_count_max`, pick the largest unroll
// that fits the per-trial VGPR budget. Models the prefetch-K-loads
// shape of a matmul K-loop: each trial materialises `k_unroll`
// independent VGPRs alive simultaneously past the loop.
//
// Tuple widths are part of the type, and `wavemeta-specialize` only
// resolves scalar values -- type-level parameter substitution is not
// wired up -- so the tuple width is committed at the kernel's max
// supported unroll (8 here). `k_unroll` controls how many slots
// hold fresh v_movs; the rest stay aliased to a single seed.

// RUN: wave-opt %s --pass-pipeline='builtin.module(transform-interpreter)' --verify-diagnostics | FileCheck %s

// All prefetch slots fill the same imm0 seed: v_mov_b32_tuple is
// Pure, so CSE collapses every unroll to one shared VGPR. Trials
// all fit; tune picks the largest unroll, scoring
// `waveamdmachine.vgpr_count_max = 1`. (Distinct loads -- which is
// the real case -- would not fold; that needs a non-const seed.)

// CHECK-LABEL: module
// CHECK-SAME: waveamdmachine.vgpr_count_max = 1 : i64
// CHECK-SAME: wavemeta.params = {k_unroll = 1 : index}
// CHECK-LABEL: func.func @vary_vgprs
// CHECK-NOT: wavemeta.
module attributes {transform.with_named_sequence,
                   waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
  func.func @vary_vgprs() attributes {wave.kernel} {
    %unroll = wavemeta.param "k_unroll" : index
    %c0 = arith.constant 0 : index
    %c1 = arith.constant 1 : index
    %c8 = arith.constant 8 : index
    %seed = waveamdmachine.imm 0 : !waveamdmachine.imm
    %init_v = waveamdmachine.v_mov_b32_tuple %seed {registers = 1 : i64}
        : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
    %init_t = wavemeta.tuple_make_broadcast %init_v
        : !waveamdmachine.reg<vgpr, 1>
        -> !wavemeta.ptuple<!waveamdmachine.reg<vgpr, 1>, 8>
    // K fresh v_movs slotted into the first `k_unroll` tuple positions.
    %final = wavemeta.static_for %c0 to %unroll step %c1
        iter_args(%init_t : !wavemeta.ptuple<!waveamdmachine.reg<vgpr, 1>, 8>) {
      ^bb0(%iv: index,
           %acc: !wavemeta.ptuple<!waveamdmachine.reg<vgpr, 1>, 8>):
        %v = waveamdmachine.v_mov_b32_tuple %seed {registers = 1 : i64}
            : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1>
        %na = wavemeta.tuple_set %acc[%iv], %v
            : !wavemeta.ptuple<!waveamdmachine.reg<vgpr, 1>, 8>,
              !waveamdmachine.reg<vgpr, 1>
        wavemeta.yield %na : !wavemeta.ptuple<!waveamdmachine.reg<vgpr, 1>, 8>
    } -> !wavemeta.ptuple<!waveamdmachine.reg<vgpr, 1>, 8>
    // Pressure barrier: read all 8 slots and v_mov each. After
    // tuple decompose this becomes 8 v_movs whose sources are either
    // the fresh per-iter v_movs (slots 0..k_unroll-1) or the shared
    // seed (slots k_unroll..7). Live count just before the first
    // extract = k_unroll + 1 distinct VGPRs.
    wavemeta.static_for %c0 to %c8 step %c1 {
      ^bb0(%iv: index):
        %r = wavemeta.tuple_get %final[%iv]
            : !wavemeta.ptuple<!waveamdmachine.reg<vgpr, 1>, 8>
            -> !waveamdmachine.reg<vgpr, 1>
        %x = waveamdmachine.v_mov_b32_tuple %r {registers = 1 : i64}
            : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
        wavemeta.yield
    }
    return
  }

  // Per-trial pipeline. `mark-overflow=true` keeps regalloc from
  // failing the pass on a too-tight budget; the body reads the
  // count attr afterwards and silenceably skips the trial via
  // `match.param.cmpi`. `resource-info` only runs on trials that
  // fit, so the score's `get_int_attr` always finds a value.
  transform.named_sequence @body(
      %mod: !transform.any_op {transform.consumed},
      %k: !transform.param<i64> {transform.readonly}) {
    wave.transform.bind_param %mod "k_unroll" = %k as index
        : (!transform.any_op, !transform.param<i64>) -> ()
    %m1 = transform.apply_registered_pass "wavemeta-specialize" to %mod
        : (!transform.any_op) -> !transform.any_op
    %m2 = transform.apply_registered_pass "waveamd-reg-alloc" with
        options = { "mark-overflow" = true, "vgpr-limit" = 6 }
        to %m1 : (!transform.any_op) -> !transform.any_op
    %overflowed = wave.transform.get_int_attr
        "waveamdmachine.regalloc_overflowed_count" from %m2
        : (!transform.any_op) -> !transform.param<i64>
    %zero = transform.param.constant 0 : i64 -> !transform.param<i64>
    transform.match.param.cmpi eq %overflowed, %zero
        : !transform.param<i64>
    %m3 = transform.apply_registered_pass "waveamd-resource-info" to %m2
        : (!transform.any_op) -> !transform.any_op
    transform.yield
  }

  transform.named_sequence @score(
      %mod: !transform.any_op {transform.readonly},
      %k: !transform.param<i64> {transform.readonly})
      -> !transform.param<i64> {
    %vgprs = wave.transform.get_int_attr
        "waveamdmachine.vgpr_count_max" from %mod
        : (!transform.any_op) -> !transform.param<i64>
    transform.yield %vgprs : !transform.param<i64>
  }

  transform.named_sequence @__transform_main(
      %root: !transform.any_op {transform.consumed}) {
    %w, %s = wave.transform.tune %root body = @body score = @score {
      variables = {k_unroll = #wave.tune_enum<[1, 2, 4, 8]>}
    } : (!transform.any_op) -> (!transform.any_op, !transform.param<i64>)
    transform.yield
  }
}
