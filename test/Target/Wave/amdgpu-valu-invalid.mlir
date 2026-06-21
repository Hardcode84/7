// RUN: env WAVE_PIPELINES_DIR=%S/Inputs/emit-only-pipeline wave-translate --wave-to-amdgpu-asm --verify-diagnostics --split-input-file %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

func.func @bad_v_mul_lo_u32(%lhs: !waveamdmachine.reg<sgpr, 1, 0>,
                            %rhs: !waveamdmachine.reg<sgpr, 1, 1>)
    -> !waveamdmachine.reg<vgpr, 1, 0> {
  // expected-error @below {{v_mul_lo_u32 exceeds constant bus limit}}
  %out = waveamdmachine.v_mul_lo_u32 %lhs, %rhs
      : (!waveamdmachine.reg<sgpr, 1, 0>, !waveamdmachine.reg<sgpr, 1, 1>)
        -> !waveamdmachine.reg<vgpr, 1, 0>
  return %out : !waveamdmachine.reg<vgpr, 1, 0>
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

func.func @bad_v_add3_u32(%lhs: !waveamdmachine.reg<sgpr, 1, 0>,
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

func.func @bad_v_and_b32(%lhs: !waveamdmachine.reg<sgpr, 1, 0>,
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

func.func @bad_v_lshlrev_b32(%value: !waveamdmachine.reg<sgpr, 1, 0>,
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

func.func @bad_v_cmp_eq_u32(%lhs: !waveamdmachine.reg<sgpr, 1, 0>,
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

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

func.func @bad_v_add3_u32_unique_literals(
    %lane: !waveamdmachine.reg<vgpr, 1, 0>)
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
