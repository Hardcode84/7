// RUN: wave-opt --waveamd-reg-alloc -split-input-file -verify-diagnostics %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

func.func @unsupported_register_class() {
  // expected-error @below {{waveamd-reg-alloc supports only SGPR and VGPR register classes}}
  %reg = waveamdmachine.arg {index = 0 : i64, pointer = false} : !waveamdmachine.reg<agpr, 1>
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// expected-error @below {{WaveAMDMachine register allocator ran out of registers}}
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
