// RUN: wave-opt --waveamd-verify-machine-operands --verify-diagnostics --split-input-file %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

func.func @bad_vcc_cndmask_true_sgpr(%false: !waveamdmachine.reg<vgpr, 1, 0>,
                                     %true: !waveamdmachine.reg<sgpr, 1, 0>,
                                     %cond: !waveamdmachine.reg<vcc, 1>)
    -> !waveamdmachine.reg<vgpr, 1, 1> {
  // expected-error @below {{v_cndmask_b32_vcc needs value operand in VGPR}}
  %out = waveamdmachine.v_cndmask_b32_vcc %false, %true, %cond
      : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.reg<sgpr, 1, 0>,
         !waveamdmachine.reg<vcc, 1>) -> !waveamdmachine.reg<vgpr, 1, 1>
  return %out : !waveamdmachine.reg<vgpr, 1, 1>
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

func.func @bad_vop2_any_vgpr(%lhs: !waveamdmachine.reg<sgpr, 1, 0>,
                             %rhs: !waveamdmachine.reg<sgpr, 1, 1>)
    -> !waveamdmachine.reg<vgpr, 1, 0> {
  // expected-error @below {{v_and_b32 needs a VGPR operand}}
  %out = waveamdmachine.v_and_b32 %lhs, %rhs
      : (!waveamdmachine.reg<sgpr, 1, 0>, !waveamdmachine.reg<sgpr, 1, 1>)
        -> !waveamdmachine.reg<vgpr, 1, 0>
  return %out : !waveamdmachine.reg<vgpr, 1, 0>
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

func.func @bad_vop2_value_vgpr(%value: !waveamdmachine.reg<sgpr, 1, 0>,
                               %shift: !waveamdmachine.reg<vgpr, 1, 0>)
    -> !waveamdmachine.reg<vgpr, 1, 1> {
  // expected-error @below {{v_lshlrev_b32 needs value operand in VGPR}}
  %out = waveamdmachine.v_lshlrev_b32 %value, %shift
      : (!waveamdmachine.reg<sgpr, 1, 0>, !waveamdmachine.reg<vgpr, 1, 0>)
        -> !waveamdmachine.reg<vgpr, 1, 1>
  return %out : !waveamdmachine.reg<vgpr, 1, 1>
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

func.func @bad_vop3_constant_bus(%lhs: !waveamdmachine.reg<sgpr, 1, 0>,
                                 %rhs: !waveamdmachine.reg<sgpr, 1, 1>,
                                 %lane: !waveamdmachine.reg<vgpr, 1, 0>)
    -> !waveamdmachine.reg<vgpr, 1, 1> {
  // expected-error @below {{v_add3_u32 exceeds constant bus limit}}
  %out = waveamdmachine.v_add3_u32 %lhs, %rhs, %lane
      : (!waveamdmachine.reg<sgpr, 1, 0>, !waveamdmachine.reg<sgpr, 1, 1>,
         !waveamdmachine.reg<vgpr, 1, 0>) -> !waveamdmachine.reg<vgpr, 1, 1>
  return %out : !waveamdmachine.reg<vgpr, 1, 1>
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

func.func @bad_compare_constant_bus(%lhs: !waveamdmachine.reg<sgpr, 1, 0>,
                                    %rhs: !waveamdmachine.reg<sgpr, 1, 1>)
    -> !waveamdmachine.reg<sgpr, 1, 2> {
  // expected-error @below {{v_cmp_eq_u32_vcc exceeds constant bus limit}}
  %out, %vcc = waveamdmachine.v_cmp_eq_u32_vcc %lhs, %rhs
      : (!waveamdmachine.reg<sgpr, 1, 0>, !waveamdmachine.reg<sgpr, 1, 1>)
        -> (!waveamdmachine.reg<sgpr, 1, 2>, !waveamdmachine.reg<vcc, 1>)
  return %out : !waveamdmachine.reg<sgpr, 1, 2>
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

func.func @bad_gfx9_literal(%lane: !waveamdmachine.reg<vgpr, 1, 0>)
    -> !waveamdmachine.reg<vgpr, 1, 1> {
  %lit = waveamdmachine.imm 256 : !waveamdmachine.imm
  // expected-error @below {{v_add3_u32 cannot use non-inline literal on gfx950}}
  %out = waveamdmachine.v_add3_u32 %lit, %lit, %lane
      : (!waveamdmachine.imm, !waveamdmachine.imm,
         !waveamdmachine.reg<vgpr, 1, 0>) -> !waveamdmachine.reg<vgpr, 1, 1>
  return %out : !waveamdmachine.reg<vgpr, 1, 1>
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

func.func @bad_gfx9_vmul_immediates()
    -> !waveamdmachine.reg<vgpr, 1, 0> {
  %lhs = waveamdmachine.imm 1 : !waveamdmachine.imm
  %rhs = waveamdmachine.imm 2 : !waveamdmachine.imm
  // expected-error @below {{v_mul_lo_u32 cannot materialize two immediates}}
  %out = waveamdmachine.v_mul_lo_u32 %lhs, %rhs
      : (!waveamdmachine.imm, !waveamdmachine.imm)
        -> !waveamdmachine.reg<vgpr, 1, 0>
  return %out : !waveamdmachine.reg<vgpr, 1, 0>
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

func.func @bad_gfx9_vmul_literal_result_alias(
    %value: !waveamdmachine.reg<vgpr, 1, 0>)
    -> !waveamdmachine.reg<vgpr, 1, 0> {
  %literal = waveamdmachine.imm 384 : !waveamdmachine.imm
  // expected-error @below {{v_mul_lo_u32 cannot materialize immediate into aliased result}}
  %out = waveamdmachine.v_mul_lo_u32 %literal, %value
      : (!waveamdmachine.imm, !waveamdmachine.reg<vgpr, 1, 0>)
        -> !waveamdmachine.reg<vgpr, 1, 0>
  return %out : !waveamdmachine.reg<vgpr, 1, 0>
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

func.func @bad_gfx11_unique_literals(%lane: !waveamdmachine.reg<vgpr, 1, 0>)
    -> !waveamdmachine.reg<vgpr, 1, 1> {
  %lit0 = waveamdmachine.imm 256 : !waveamdmachine.imm
  %lit1 = waveamdmachine.imm 512 : !waveamdmachine.imm
  // expected-error @below {{v_add3_u32 cannot use multiple non-inline literals}}
  %out = waveamdmachine.v_add3_u32 %lit0, %lit1, %lane
      : (!waveamdmachine.imm, !waveamdmachine.imm,
         !waveamdmachine.reg<vgpr, 1, 0>) -> !waveamdmachine.reg<vgpr, 1, 1>
  return %out : !waveamdmachine.reg<vgpr, 1, 1>
}

}
