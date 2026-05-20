// RUN: wave-opt --waveamd-insert-ticket-waits -split-input-file -verify-diagnostics %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

func.func @kernel_arg_not_abi_lowered() attributes {wave.kernel} {
  // expected-error @below {{waveamd-insert-ticket-waits expects ABI-lowered kernel arguments}}
  %arg = waveamdmachine.arg {index = 0 : i64, pointer = false} : !waveamdmachine.reg<sgpr, 1>
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

func.func @missing_smem_base() {
  %offset = waveamdmachine.imm 0 : !waveamdmachine.imm
  // expected-error @below {{'waveamdmachine.s_load_b32' op requires attribute 'base'}}
  %load = "waveamdmachine.s_load_b32"(%offset) : (!waveamdmachine.imm) -> !waveamdmachine.reg<sgpr, 1>
  return
}

}
