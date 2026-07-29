// RUN: wave-opt --waveamd-insert-ticket-waits -split-input-file \
// RUN:   -verify-diagnostics %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// expected-error @+1 {{waveamdmachine.expert_scheduling_mode requires GFX12+ expert scheduling support}}
func.func @unsupported_target() attributes {
    waveamdmachine.expert_scheduling_mode
  } {
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1250"} {

// expected-error @+1 {{waveamdmachine.expert_scheduling_mode must be a unit attribute}}
func.func @wrong_attribute_type() attributes {
    waveamdmachine.expert_scheduling_mode = true
  } {
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1250"} {

func.func @requires_post_regalloc() attributes {
    waveamdmachine.expert_scheduling_mode
  } {
  // expected-error @+1 {{expert scheduling requires allocated VGPR operands and results}}
  %value = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
  return
}

}
