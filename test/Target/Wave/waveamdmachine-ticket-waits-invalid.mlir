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

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

func.func @tuple_load_not_decomposed(%off: !waveamdmachine.reg<vgpr, 1>,
                                     %base: !waveamdmachine.reg<sgpr, 2>) {
  // expected-error @below {{waveamd-insert-ticket-waits expects tuple memory ops to be decomposed first}}
  %regs, %tok = waveamdmachine.global_load_tuple_b32 %off, %base
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 2>)
        -> (!waveamdmachine.reg<vgpr, 8>, !waveamdmachine.mem.token)
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

func.func @tuple_store_not_decomposed(%off: !waveamdmachine.reg<vgpr, 1>,
                                      %value: !waveamdmachine.reg<vgpr, 8>,
                                      %base: !waveamdmachine.reg<sgpr, 2>) {
  // expected-error @below {{waveamd-insert-ticket-waits expects tuple memory ops to be decomposed first}}
  %tok = waveamdmachine.global_store_tuple_b32 %off, %value, %base
      : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 8>,
         !waveamdmachine.reg<sgpr, 2>) -> !waveamdmachine.mem.token
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1250"} {

func.func @legacy_wait_on_split_target() {
  // expected-error @below {{legacy wait-counter op unsupported on target}}
  waveamdmachine.s_waitcnt vmcnt(0)
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

func.func @split_wait_on_legacy_target() {
  // expected-error @below {{split wait-counter op unsupported on target}}
  waveamdmachine.s_waitcnt_split loadcnt(0)
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

func.func @async_event_on_legacy_target(
    %lds: !waveamdmachine.reg<vgpr, 1>,
    %offset: !waveamdmachine.reg<vgpr, 1>,
    %base: !waveamdmachine.reg<sgpr, 2>) {
  %root = waveamdmachine.token : !waveamdmachine.mem.token
  // expected-error @below {{async wait event unsupported on target}}
  %loaded = waveamdmachine.global_load_async_to_lds_b8
      %lds, %offset, %base after %root
      : (!waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<vgpr, 1>,
         !waveamdmachine.reg<sgpr, 2>,
         !waveamdmachine.mem.token) -> !waveamdmachine.mem.token
  return
}

}
