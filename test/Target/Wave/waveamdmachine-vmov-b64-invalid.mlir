// RUN: wave-opt -split-input-file -verify-diagnostics %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

func.func @odd_result() {
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  // expected-error @below {{result must be 64-bit aligned}}
  %wide = waveamdmachine.v_mov_b64_tuple %zero
      : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 2, 3>
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

func.func @narrow_source(%src: !waveamdmachine.reg<vgpr, 1, 2>) {
  // expected-error @below {{register source must be two dwords}}
  %wide = waveamdmachine.v_mov_b64_tuple %src
      : (!waveamdmachine.reg<vgpr, 1, 2>) -> !waveamdmachine.reg<vgpr, 2, 4>
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

func.func @odd_source(%src: !waveamdmachine.reg<sgpr, 2, 1>) {
  // expected-error @below {{source must be 64-bit aligned}}
  %wide = waveamdmachine.v_mov_b64_tuple %src
      : (!waveamdmachine.reg<sgpr, 2, 1>) -> !waveamdmachine.reg<vgpr, 2, 4>
  return
}

}
