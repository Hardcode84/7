// RUN: wave-opt --waveamd-reg-alloc -split-input-file -verify-diagnostics %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

func.func @fixed_alias_conflict() {
  %fixed = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, 0>
  // expected-error @below {{waveamd-reg-alloc found incompatible fixed alias registers}}
  %tuple = waveamdmachine.tuple_from_elements %fixed
      : (!waveamdmachine.reg<vgpr, 1, 0>) -> !waveamdmachine.reg<vgpr, 1, 1>
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

func.func @wrong_reserved_sgpr_slot() attributes {wave.kernel} {
  // expected-error @below {{waveamd-reg-alloc found SGPR value allocated in reserved kernel ABI registers}}
  %bad_y = waveamdmachine.s_workgroup_id_y : !waveamdmachine.reg<sgpr, 1, 0>
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// expected-error @below {{waveamd-reg-alloc fixed VGPR register range exceeds addressable namespace}}
func.func @fixed_out_of_range() {
  %fixed = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, 9999>
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// expected-error @below {{waveamd-reg-alloc found interfering fixed VGPR register live ranges}}
func.func @fixed_interference() {
  %a = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, 0>
  %b = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, 0>
  %use = waveamdmachine.v_add_u32 %a, %b
      : (!waveamdmachine.reg<vgpr, 1, 0>, !waveamdmachine.reg<vgpr, 1, 0>)
      -> !waveamdmachine.reg<vgpr, 1>
  return
}

}
