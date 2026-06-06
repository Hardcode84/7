// RUN: wave-opt --waveamd-reg-alloc -split-input-file -verify-diagnostics %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

func.func @overlapping_scc_live_range_in_loop(%iv0: !waveamdmachine.reg<sgpr, 1>,
                                              %n: !waveamdmachine.reg<sgpr, 1>) {
  %ec = waveamdmachine.s_cmp_lt_i32 %iv0, %n
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
        -> !waveamdmachine.reg<scc, 1>
  %r = waveamdmachine.uniform_loop if %ec : !waveamdmachine.reg<scc, 1>
      carries(%iv0 : !waveamdmachine.reg<sgpr, 1>) {
  ^bb0(%iv: !waveamdmachine.reg<sgpr, 1>):
    %scc = waveamdmachine.s_cmp_lt_i32 %iv, %n
        : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
          -> !waveamdmachine.reg<scc, 1>
    // expected-error @below {{waveamd-reg-alloc found overlapping SCC live range after hardware-register preservation}}
    %next, %next_scc = waveamdmachine.s_add_i32 %iv, %iv
        : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
          -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
    waveamdmachine.continue_if %scc : !waveamdmachine.reg<scc, 1>
        carries(%next : !waveamdmachine.reg<sgpr, 1>)
  } -> !waveamdmachine.reg<sgpr, 1>
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

func.func @overlapping_scc_live_range(%a: !waveamdmachine.reg<sgpr, 1>,
                                      %b: !waveamdmachine.reg<sgpr, 1>) {
  %scc = waveamdmachine.s_cmp_lt_i32 %a, %b
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
        -> !waveamdmachine.reg<scc, 1>
  // expected-error @below {{waveamd-reg-alloc found overlapping SCC live range after hardware-register preservation}}
  %sum, %sum_scc = waveamdmachine.s_add_i32 %a, %b
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
        -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
  waveamdmachine.s_cbranch_scc1 %scc : !waveamdmachine.reg<scc, 1>, "taken"
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

func.func @overlapping_scc_live_range_s_lshl_b64(%a: !waveamdmachine.reg<sgpr, 2>,
                                                 %shift: !waveamdmachine.reg<sgpr, 2>,
                                                 %x: !waveamdmachine.reg<sgpr, 1>,
                                                 %y: !waveamdmachine.reg<sgpr, 1>) {
  %scc = waveamdmachine.s_cmp_lt_i32 %x, %y
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
        -> !waveamdmachine.reg<scc, 1>
  // expected-error @below {{waveamd-reg-alloc found overlapping SCC live range after hardware-register preservation}}
  %shifted, %shift_scc = waveamdmachine.s_lshl_b64 %a, %shift
      : (!waveamdmachine.reg<sgpr, 2>, !waveamdmachine.reg<sgpr, 2>)
        -> (!waveamdmachine.reg<sgpr, 2>, !waveamdmachine.reg<scc, 1>)
  waveamdmachine.s_cbranch_scc1 %scc : !waveamdmachine.reg<scc, 1>, "taken"
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

func.func @overlapping_scc_live_range_saveexec(%mask: !waveamdmachine.reg<sgpr, 1>,
                                               %x: !waveamdmachine.reg<sgpr, 1>,
                                               %y: !waveamdmachine.reg<sgpr, 1>) {
  %scc = waveamdmachine.s_cmp_lt_i32 %x, %y
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
        -> !waveamdmachine.reg<scc, 1>
  // expected-error @below {{waveamd-reg-alloc found overlapping SCC live range after hardware-register preservation}}
  %saved, %save_scc = waveamdmachine.s_and_saveexec_b32 %mask
      : (!waveamdmachine.reg<sgpr, 1>)
        -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<scc, 1>)
  waveamdmachine.s_cbranch_scc1 %scc : !waveamdmachine.reg<scc, 1>, "taken"
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

func.func @overlapping_scc_live_range_andn2_exec(%saved: !waveamdmachine.reg<sgpr, 1>,
                                                 %mask: !waveamdmachine.reg<sgpr, 1>,
                                                 %x: !waveamdmachine.reg<sgpr, 1>,
                                                 %y: !waveamdmachine.reg<sgpr, 1>) {
  %scc = waveamdmachine.s_cmp_lt_i32 %x, %y
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
        -> !waveamdmachine.reg<scc, 1>
  // expected-error @below {{waveamd-reg-alloc found overlapping SCC live range after hardware-register preservation}}
  %exec_scc = waveamdmachine.s_andn2_exec_b32 %saved, %mask
      : (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<sgpr, 1>)
        -> !waveamdmachine.reg<scc, 1>
  waveamdmachine.s_cbranch_scc1 %scc : !waveamdmachine.reg<scc, 1>, "taken"
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

func.func @overlapping_vcc_live_range(%a: !waveamdmachine.reg<vgpr, 2>,
                                      %b: !waveamdmachine.reg<vgpr, 2>,
                                      %c: !waveamdmachine.reg<vgpr, 2>,
                                      %d: !waveamdmachine.reg<vgpr, 2>)
    -> !waveamdmachine.reg<vcc, 1> {
  %sum0, %vcc0 = waveamdmachine.v_add_u64 %a, %b
      : (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vgpr, 2>)
        -> (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vcc, 1>)
  // expected-error @below {{waveamd-reg-alloc found overlapping VCC live range after hardware-register preservation}}
  %sum1, %vcc1 = waveamdmachine.v_add_u64 %c, %d
      : (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vgpr, 2>)
        -> (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vcc, 1>)
  return %vcc0 : !waveamdmachine.reg<vcc, 1>
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

func.func @overlapping_vcc_live_range_v_add_u32_vcc(%a: !waveamdmachine.reg<vgpr, 2>,
                                                    %b: !waveamdmachine.reg<vgpr, 2>,
                                                    %c: !waveamdmachine.reg<vgpr, 1>,
                                                    %d: !waveamdmachine.reg<vgpr, 1>)
    -> !waveamdmachine.reg<vcc, 1> {
  %sum0, %vcc0 = waveamdmachine.v_add_u64 %a, %b
      : (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vgpr, 2>)
        -> (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vcc, 1>)
  // expected-error @below {{waveamd-reg-alloc found overlapping VCC live range after hardware-register preservation}}
  %sum1, %vcc1 = waveamdmachine.v_add_u32_vcc %c, %d
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vcc, 1>)
  return %vcc0 : !waveamdmachine.reg<vcc, 1>
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

func.func @overlapping_vcc_live_range_v_cmp_u32_vcc(%a: !waveamdmachine.reg<vgpr, 2>,
                                                    %b: !waveamdmachine.reg<vgpr, 2>,
                                                    %c: !waveamdmachine.reg<vgpr, 1>,
                                                    %d: !waveamdmachine.reg<vgpr, 1>)
    -> !waveamdmachine.reg<vcc, 1> {
  %sum0, %vcc0 = waveamdmachine.v_add_u64 %a, %b
      : (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vgpr, 2>)
        -> (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vcc, 1>)
  // expected-error @below {{waveamd-reg-alloc found overlapping VCC live range after hardware-register preservation}}
  %mask, %vcc1 = waveamdmachine.v_cmp_lt_u32_vcc %c, %d
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
        -> (!waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<vcc, 1>)
  return %vcc0 : !waveamdmachine.reg<vcc, 1>
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

func.func @reserved_vgpr_pin_rejected() attributes {wave.kernel} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  // expected-error @below {{waveamd-reg-alloc found VGPR value allocated in reserved kernel ABI registers}}
  %reg = waveamdmachine.v_mov_b32_tuple %zero
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 1, 0>
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

func.func @reserved_sgpr_pin_rejected() attributes {wave.kernel} {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  // expected-error @below {{waveamd-reg-alloc found SGPR value allocated in reserved kernel ABI registers}}
  %reg = waveamdmachine.s_mov_b32_value %zero
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1, 0>
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// expected-error @below {{waveamd-reg-alloc AGPR registers require target with AGPR support}}
func.func @unsupported_register_class() {
  %reg = waveamdmachine.arg {index = 0 : i64, pointer = false} : !waveamdmachine.reg<agpr, 1>
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// expected-error @below {{waveamd-reg-alloc ran out of VGPR registers at position 1}}
func.func @too_many_vgprs() {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %reg = waveamdmachine.v_mov_b32_tuple %zero {registers = 257 : i64} : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 257>
  return
}

}

// -----

// expected-error @below {{waveamd-reg-alloc requires a waveamdmachine.target attribute}}
module {
  func.func @missing_target() {
    return
  }
}
