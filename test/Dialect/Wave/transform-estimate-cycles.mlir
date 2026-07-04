// RUN: wave-opt %s --pass-pipeline='builtin.module(transform-interpreter)' --verify-diagnostics --split-input-file | FileCheck %s

// Tiny SALU-only kernel on gfx1100. WriteSALU latency = 2
// (GFX11SpeedModel:446). Two s_add_i32 in a dependent chain:
// op A issues at 0, completes at 2. op B waits for op A's
// result (2 cycles), issues at 2, completes at 4. Total = 4.
//
// imm ops are NoMachineInst -> NoInst class, 0 cycles, no
// issue slot.

module attributes {transform.with_named_sequence,
                   waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
  func.func @two_dep_salu(%init: !waveamdmachine.reg<sgpr, 1>) {
    %step = waveamdmachine.imm 1 : !waveamdmachine.imm
    %a:2 = waveamdmachine.s_add_i32 %init, %step :
        (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm) ->
        (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
    %b:2 = waveamdmachine.s_add_i32 %a#0, %step :
        (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm) ->
        (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
    return
  }

  transform.named_sequence @__transform_main(
      %root: !transform.any_op {transform.readonly}) {
    %c = wave.transform.estimate_cycles from %root
        : (!transform.any_op) -> !transform.param<i64>
    %k = transform.param.constant 4 : i64 -> !transform.param<i64>
    transform.match.param.cmpi eq %c, %k : !transform.param<i64>
    transform.yield
  }
}

// -----

// Same two ops on gfx942 use CDNA SALU timing. Total = 8.

module attributes {transform.with_named_sequence,
                   waveamdmachine.target = "amdgcn-amd-amdhsa--gfx942"} {
  func.func @two_dep_salu_cdna(%init: !waveamdmachine.reg<sgpr, 1>) {
    %step = waveamdmachine.imm 1 : !waveamdmachine.imm
    %a:2 = waveamdmachine.s_add_i32 %init, %step :
        (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm) ->
        (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
    %b:2 = waveamdmachine.s_add_i32 %a#0, %step :
        (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm) ->
        (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
    return
  }

  transform.named_sequence @__transform_main(
      %root: !transform.any_op {transform.readonly}) {
    %c = wave.transform.estimate_cycles from %root
        : (!transform.any_op) -> !transform.param<i64>
    %k = transform.param.constant 8 : i64 -> !transform.param<i64>
    transform.match.param.cmpi eq %c, %k : !transform.param<i64>
    transform.yield
  }
}

// -----

// Empty function: no waveamdmachine ops, cycles = 0.

module attributes {transform.with_named_sequence,
                   waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
  func.func @empty() {
    return
  }

  transform.named_sequence @__transform_main(
      %root: !transform.any_op {transform.readonly}) {
    %c = wave.transform.estimate_cycles from %root
        : (!transform.any_op) -> !transform.param<i64>
    %k = transform.param.constant 0 : i64 -> !transform.param<i64>
    transform.match.param.cmpi eq %c, %k : !transform.param<i64>
    transform.yield
  }
}

// -----

// uniform_loop with explicit trip_count attribute uses one live state.
// Three dependent SALU loop iterations complete at cycles 2, 4, 6.

module attributes {transform.with_named_sequence,
                   waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
  func.func @trip_count_loop(%init: !waveamdmachine.reg<sgpr, 1>) {
    %step = waveamdmachine.imm 1 : !waveamdmachine.imm
    %r = waveamdmachine.uniform_loop carries(%init : !waveamdmachine.reg<sgpr, 1>) {
    ^bb0(%iv: !waveamdmachine.reg<sgpr, 1>):
      %next:2 = waveamdmachine.s_add_i32 %iv, %step :
          (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm) ->
          (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
      waveamdmachine.continue_if %next#1 :
          !waveamdmachine.reg<scc, 1>
          carries(%next#0 : !waveamdmachine.reg<sgpr, 1>)
    } { waveamdmachine.trip_count = 3 : i64 } -> !waveamdmachine.reg<sgpr, 1>
    return
  }

  transform.named_sequence @__transform_main(
      %root: !transform.any_op {transform.readonly}) {
    %c = wave.transform.estimate_cycles from %root
        : (!transform.any_op) -> !transform.param<i64>
    %k = transform.param.constant 6 : i64 -> !transform.param<i64>
    transform.match.param.cmpi eq %c, %k : !transform.param<i64>
    transform.yield
  }
}

// -----

// Same body, trip_count = 1: should give exactly C1 = 2 (no
// steady-state iter).

module attributes {transform.with_named_sequence,
                   waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
  func.func @trip_count_one(%init: !waveamdmachine.reg<sgpr, 1>) {
    %step = waveamdmachine.imm 1 : !waveamdmachine.imm
    %r = waveamdmachine.uniform_loop carries(%init : !waveamdmachine.reg<sgpr, 1>) {
    ^bb0(%iv: !waveamdmachine.reg<sgpr, 1>):
      %next:2 = waveamdmachine.s_add_i32 %iv, %step :
          (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm) ->
          (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
      waveamdmachine.continue_if %next#1 :
          !waveamdmachine.reg<scc, 1>
          carries(%next#0 : !waveamdmachine.reg<sgpr, 1>)
    } { waveamdmachine.trip_count = 1 : i64 } -> !waveamdmachine.reg<sgpr, 1>
    return
  }

  transform.named_sequence @__transform_main(
      %root: !transform.any_op {transform.readonly}) {
    %c = wave.transform.estimate_cycles from %root
        : (!transform.any_op) -> !transform.param<i64>
    %k = transform.param.constant 2 : i64 -> !transform.param<i64>
    transform.match.param.cmpi eq %c, %k : !transform.param<i64>
    transform.yield
  }
}

// -----

// pressure_report attaches the per-FU dict to the module.
// Two s_add_i32 -> SALU=2 issue cycles (one cycle per op).

// CHECK: wave.pressure_report = {SALU = 2 : i64}
module attributes {transform.with_named_sequence,
                   waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
  func.func @salu_pressure(%init: !waveamdmachine.reg<sgpr, 1>) {
    %step = waveamdmachine.imm 1 : !waveamdmachine.imm
    %a:2 = waveamdmachine.s_add_i32 %init, %step :
        (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm) ->
        (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
    %b:2 = waveamdmachine.s_add_i32 %a#0, %step :
        (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm) ->
        (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
    return
  }

  transform.named_sequence @__transform_main(
      %root: !transform.any_op {transform.readonly}) {
    wave.transform.pressure_report from %root
        : (!transform.any_op) -> ()
    transform.yield
  }
}

// -----

// uniform_if: estimate uses the slower arm, pressure_report counts
// static issue slots in both arms, and yield terminators are free.

// CHECK: wave.pressure_report = {SALU = 3 : i64}
module attributes {transform.with_named_sequence,
                   waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
  func.func @uniform_if_cycles(%cond: !waveamdmachine.reg<scc, 1>,
                               %init: !waveamdmachine.reg<sgpr, 1>) {
    %step = waveamdmachine.imm 1 : !waveamdmachine.imm
    waveamdmachine.uniform_if %cond {
      %a:2 = waveamdmachine.s_add_i32 %init, %step :
          (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm) ->
          (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
      waveamdmachine.yield
    } otherwise {
      %b:2 = waveamdmachine.s_add_i32 %init, %step :
          (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm) ->
          (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
      %c:2 = waveamdmachine.s_add_i32 %b#0, %step :
          (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm) ->
          (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
      waveamdmachine.yield
    } : !waveamdmachine.reg<scc, 1>
    return
  }

  transform.named_sequence @__transform_main(
      %root: !transform.any_op {transform.readonly}) {
    %c = wave.transform.estimate_cycles from %root
        : (!transform.any_op) -> !transform.param<i64>
    %k = transform.param.constant 4 : i64 -> !transform.param<i64>
    transform.match.param.cmpi eq %c, %k : !transform.param<i64>
    wave.transform.pressure_report from %root
        : (!transform.any_op) -> ()
    transform.yield
  }
}

// -----

// uniform_if inside uniform_loop contributes to C1/Ss trip costing.

module attributes {transform.with_named_sequence,
                   waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
  func.func @uniform_if_in_trip_loop(%cond: !waveamdmachine.reg<scc, 1>,
                                     %init: !waveamdmachine.reg<sgpr, 1>) {
    %step = waveamdmachine.imm 1 : !waveamdmachine.imm
    %r = waveamdmachine.uniform_loop
        carries(%init : !waveamdmachine.reg<sgpr, 1>) {
    ^bb0(%iv: !waveamdmachine.reg<sgpr, 1>):
      waveamdmachine.uniform_if %cond {
        %a:2 = waveamdmachine.s_add_i32 %iv, %step :
            (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm) ->
            (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
        waveamdmachine.yield
      } otherwise {
        %b:2 = waveamdmachine.s_add_i32 %iv, %step :
            (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm) ->
            (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
        %c:2 = waveamdmachine.s_add_i32 %b#0, %step :
            (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm) ->
            (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
        waveamdmachine.yield
      } : !waveamdmachine.reg<scc, 1>
      %next:2 = waveamdmachine.s_add_i32 %iv, %step :
          (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.imm) ->
          (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
      waveamdmachine.continue_if %next#1 :
          !waveamdmachine.reg<scc, 1>
          carries(%next#0 : !waveamdmachine.reg<sgpr, 1>)
    } { waveamdmachine.trip_count = 3 : i64 } -> !waveamdmachine.reg<sgpr, 1>
    return
  }

  transform.named_sequence @__transform_main(
      %root: !transform.any_op {transform.readonly}) {
    %c = wave.transform.estimate_cycles from %root
        : (!transform.any_op) -> !transform.param<i64>
    %k = transform.param.constant 15 : i64 -> !transform.param<i64>
    transform.match.param.cmpi eq %c, %k : !transform.param<i64>
    transform.yield
  }
}

// -----

// Missing target attr -> definite failure.

module attributes {transform.with_named_sequence} {
  func.func @no_target() {
    return
  }

  transform.named_sequence @__transform_main(
      %root: !transform.any_op {transform.readonly}) {
    // expected-error @below {{target has no enclosing module with `waveamdmachine.target` or arch is unsupported}}
    %c = wave.transform.estimate_cycles from %root
        : (!transform.any_op) -> !transform.param<i64>
    transform.yield
  }
}

// -----

// Unsupported arch -> definite failure.

module attributes {transform.with_named_sequence,
                   waveamdmachine.target = "amdgcn-amd-amdhsa--gfx900"} {
  func.func @unsupported() {
    return
  }

  transform.named_sequence @__transform_main(
      %root: !transform.any_op {transform.readonly}) {
    // expected-error @below {{target has no enclosing module with `waveamdmachine.target` or arch is unsupported}}
    %c = wave.transform.estimate_cycles from %root
        : (!transform.any_op) -> !transform.param<i64>
    transform.yield
  }
}
