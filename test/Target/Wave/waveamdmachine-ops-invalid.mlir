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
