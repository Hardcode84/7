// RUN: wave-translate --wave-to-amdgpu-asm --verify-diagnostics --split-input-file %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx942"} {

func.func @bad_ds_read_tr_b4() attributes {wave.kernel} {
  %addr = waveamdmachine.v_mbcnt_lo : !waveamdmachine.reg<vgpr, 1>
  // expected-error @below {{ds_read_tr_b64_b4 requires gfx950}}
  %v, %tok = waveamdmachine.ds_read_tr_b64_b4 %addr
      : (!waveamdmachine.reg<vgpr, 1>)
        -> (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.mem.token)
  waveamdmachine.s_endpgm
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx942"} {

func.func @bad_ds_read_tr_b8() attributes {wave.kernel} {
  %addr = waveamdmachine.v_mbcnt_lo : !waveamdmachine.reg<vgpr, 1>
  // expected-error @below {{ds_read_tr_b64_b8 requires gfx950}}
  %v, %tok = waveamdmachine.ds_read_tr_b64_b8 %addr
      : (!waveamdmachine.reg<vgpr, 1>)
        -> (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.mem.token)
  waveamdmachine.s_endpgm
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx942"} {

func.func @bad_ds_read_tr_b16() attributes {wave.kernel} {
  %addr = waveamdmachine.v_mbcnt_lo : !waveamdmachine.reg<vgpr, 1>
  // expected-error @below {{ds_read_tr_b64_b16 requires gfx950}}
  %v, %tok = waveamdmachine.ds_read_tr_b64_b16 %addr
      : (!waveamdmachine.reg<vgpr, 1>)
        -> (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.mem.token)
  waveamdmachine.s_endpgm
  return
}

}
