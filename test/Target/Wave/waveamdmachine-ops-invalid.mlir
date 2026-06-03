// RUN: wave-opt -split-input-file -verify-diagnostics %s

func.func @bad_v_add_operand_count(%x: !waveamdmachine.reg<vgpr, 1>) {
  // expected-error @below {{'waveamdmachine.v_add_u32' op expected 2 operands}}
  %r = "waveamdmachine.v_add_u32"(%x) : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  return
}

// -----

func.func @bad_v_mbcnt_result_type() {
  // expected-error @below {{result #0 must be WaveAMDMachine scalar VGPR register}}
  %r = "waveamdmachine.v_mbcnt_lo"() : () -> !waveamdmachine.reg<sgpr, 1>
  return
}

// -----

func.func @bad_s_load_result_type(%offset: !waveamdmachine.imm) {
  // expected-error @below {{result #0 must be WaveAMDMachine SGPR pair register}}
  %r = "waveamdmachine.s_load_b64"(%offset) {base = "s[0:1]"} : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1>
  return
}

// -----

func.func @bad_global_store_base(%offset: !waveamdmachine.reg<vgpr, 1>, %value: !waveamdmachine.reg<vgpr, 1>, %base: !waveamdmachine.reg<sgpr, 1>) {
  // expected-error @below {{operand #2 must be WaveAMDMachine SGPR pair register}}
  "waveamdmachine.global_store_b32"(%offset, %value, %base) : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 1>) -> ()
  return
}

// -----

func.func @bad_wmma_width(%a: !waveamdmachine.reg<vgpr, 8>, %b: !waveamdmachine.reg<vgpr, 4>, %acc: !waveamdmachine.reg<vgpr, 8>) {
  // expected-error @below {{A operand must be !waveamdmachine.reg<vgpr, 4>}}
  %r = waveamdmachine.wmma_i32_16x16x16_iu8 %a, %b, %acc : (!waveamdmachine.reg<vgpr, 8>, !waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 8>) -> !waveamdmachine.reg<vgpr, 8>
  return
}

// -----

func.func @tuple_to_elements_wrong_count(%t: !waveamdmachine.reg<vgpr, 8>) {
  // expected-error @below {{element widths sum (4) must match tuple register width (8)}}
  %e:4 = waveamdmachine.tuple_to_elements %t
      : (!waveamdmachine.reg<vgpr, 8>) -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
  return
}

// -----

func.func @tuple_from_elements_wrong_count(%a: !waveamdmachine.reg<vgpr, 1>,
                                           %b: !waveamdmachine.reg<vgpr, 1>,
                                           %c: !waveamdmachine.reg<vgpr, 1>) {
  // expected-error @below {{element widths sum (3) must match tuple register width (8)}}
  %t = waveamdmachine.tuple_from_elements %a, %b, %c
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 8>
  return
}

// -----

func.func @tuple_from_elements_subtuple_width_mismatch(%a: !waveamdmachine.reg<vgpr, 4>,
                                                       %b: !waveamdmachine.reg<vgpr, 2>,
                                                       %c: !waveamdmachine.reg<vgpr, 1>) {
  // expected-error @below {{element widths sum (7) must match tuple register width (8)}}
  %t = waveamdmachine.tuple_from_elements %a, %b, %c
      : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 8>
  return
}

// -----

func.func @tuple_from_elements_mixed_class(%a: !waveamdmachine.reg<vgpr, 2>,
                                           %b: !waveamdmachine.reg<sgpr, 2>) {
  // expected-error @below {{element register class must match tuple's}}
  %t = waveamdmachine.tuple_from_elements %a, %b
      : (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<sgpr, 2>) -> !waveamdmachine.reg<vgpr, 4>
  return
}

// -----

// Memory-token result group is optional, not variadic.
func.func @memop_two_tokens(%off: !waveamdmachine.reg<vgpr, 1>,
                            %base: !waveamdmachine.reg<sgpr, 2>) {
  // expected-error @below {{requires 0 or 1 element, but found 2}}
  %r, %t0, %t1 = waveamdmachine.global_load_b32 %off, %base
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>)
      -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.mem.token, !waveamdmachine.mem.token)
  return
}

// -----

// Covers "registers attribute must match result register width" emitted by
// both v_mov_b32_tuple and s_mov_b32_tuple -- substring match.
func.func @v_mov_b32_tuple_registers_mismatch(%src: !waveamdmachine.imm) {
  // expected-error @below {{registers attribute must match result register width}}
  %r = waveamdmachine.v_mov_b32_tuple %src {registers = 2 : i64}
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 4>
  return
}

// -----

func.func @v_cndmask_immediate_wide_result(%src: !waveamdmachine.reg<vgpr, 2>,
                                           %cond: !waveamdmachine.reg<sgpr, 1>) {
  %imm = waveamdmachine.imm 7 : !waveamdmachine.imm
  // expected-error @below {{immediate source requires width-1 result}}
  %r = waveamdmachine.v_cndmask_b32_tuple %imm, %src, %cond
      : (!waveamdmachine.imm, !waveamdmachine.reg<vgpr, 2>,
         !waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<vgpr, 2>
  return
}

// -----

func.func @v_cndmask_source_width_mismatch(%narrow: !waveamdmachine.reg<vgpr, 1>,
                                           %wide: !waveamdmachine.reg<vgpr, 2>,
                                           %cond: !waveamdmachine.reg<sgpr, 1>) {
  // expected-error @below {{source width 1 must match result width 2}}
  %r = waveamdmachine.v_cndmask_b32_tuple %narrow, %wide, %cond
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 2>,
         !waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<vgpr, 2>
  return
}

// -----

func.func @v_cndmask_flag_source(%flag: !waveamdmachine.reg<vcc, 1>,
                                 %src: !waveamdmachine.reg<vgpr, 1>,
                                 %cond: !waveamdmachine.reg<sgpr, 1>) {
  // expected-error @below {{source must be VGPR or SGPR}}
  %r = waveamdmachine.v_cndmask_b32_tuple %flag, %src, %cond
      : (!waveamdmachine.reg<vcc, 1>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  return
}

// -----

func.func @v_cndmask_bad_condition_width(%false: !waveamdmachine.reg<vgpr, 1>,
                                         %true: !waveamdmachine.reg<vgpr, 1>,
                                         %cond: !waveamdmachine.reg<sgpr, 4>) {
  // expected-error @below {{condition width must be 1 or 2}}
  %r = waveamdmachine.v_cndmask_b32_tuple %false, %true, %cond
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 4>) -> !waveamdmachine.reg<vgpr, 1>
  return
}

// -----

// Zero-width tuples die in RegType verification before op checks.
func.func @global_load_tuple_b32_zero_width(%off: !waveamdmachine.reg<vgpr, 1>,
                                            %base: !waveamdmachine.reg<sgpr, 2>) {
  %r, %t = waveamdmachine.global_load_tuple_b32 %off, %base
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>)
      // expected-error @below {{register width must be positive}}
      -> (!waveamdmachine.reg<vgpr, 0>, !waveamdmachine.mem.token)
  return
}

// -----

func.func @uniform_loop_block_arg_count_mismatch(%init: !waveamdmachine.reg<sgpr, 1>,
                                                  %sc: !waveamdmachine.reg<scc, 1>) {
  // expected-error @below {{body block must have one argument per init carry}}
  %r = waveamdmachine.uniform_loop carries(%init : !waveamdmachine.reg<sgpr, 1>) {
  ^bb0(%iv: !waveamdmachine.reg<sgpr, 1>, %extra: !waveamdmachine.reg<sgpr, 1>):
    waveamdmachine.continue_if %sc : !waveamdmachine.reg<scc, 1> carries(%iv : !waveamdmachine.reg<sgpr, 1>)
  } -> !waveamdmachine.reg<sgpr, 1>
  return
}

// -----

func.func @uniform_loop_block_arg_type_mismatch(%init: !waveamdmachine.reg<sgpr, 1>,
                                                 %sc: !waveamdmachine.reg<scc, 1>,
                                                 %v: !waveamdmachine.reg<vgpr, 1>) {
  // expected-error @below {{init carry types must match body block argument types}}
  %r = waveamdmachine.uniform_loop carries(%init : !waveamdmachine.reg<sgpr, 1>) {
  ^bb0(%iv: !waveamdmachine.reg<vgpr, 1>):
    waveamdmachine.continue_if %sc : !waveamdmachine.reg<scc, 1> carries(%v : !waveamdmachine.reg<vgpr, 1>)
  } -> !waveamdmachine.reg<sgpr, 1>
  return
}

// -----

func.func @uniform_loop_results_count_mismatch(%init: !waveamdmachine.reg<sgpr, 1>,
                                                %sc: !waveamdmachine.reg<scc, 1>) {
  // expected-error @below {{results count must match inits count}}
  waveamdmachine.uniform_loop carries(%init : !waveamdmachine.reg<sgpr, 1>) {
  ^bb0(%iv: !waveamdmachine.reg<sgpr, 1>):
    waveamdmachine.continue_if %sc : !waveamdmachine.reg<scc, 1> carries(%iv : !waveamdmachine.reg<sgpr, 1>)
  }
  return
}

// -----

func.func @uniform_loop_result_type_mismatch(%init: !waveamdmachine.reg<sgpr, 1>,
                                              %sc: !waveamdmachine.reg<scc, 1>) {
  // expected-error @below {{init carry types must match result types}}
  %r = waveamdmachine.uniform_loop carries(%init : !waveamdmachine.reg<sgpr, 1>) {
  ^bb0(%iv: !waveamdmachine.reg<sgpr, 1>):
    waveamdmachine.continue_if %sc : !waveamdmachine.reg<scc, 1> carries(%iv : !waveamdmachine.reg<sgpr, 1>)
  } -> !waveamdmachine.reg<vgpr, 1>
  return
}

// -----

func.func @uniform_loop_bad_terminator(%init: !waveamdmachine.reg<sgpr, 1>) {
  // expected-error @below {{body must be terminated by a waveamdmachine.continue_if}}
  %r = waveamdmachine.uniform_loop carries(%init : !waveamdmachine.reg<sgpr, 1>) {
  ^bb0(%iv: !waveamdmachine.reg<sgpr, 1>):
    waveamdmachine.label "foo"
  } -> !waveamdmachine.reg<sgpr, 1>
  return
}
