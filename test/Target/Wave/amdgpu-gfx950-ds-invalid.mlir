// RUN: env WAVE_PIPELINES_DIR=%S/Inputs/emit-only-pipeline wave-translate --wave-to-amdgpu-asm --verify-diagnostics --split-input-file %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx942"} {

func.func @bad_ds_read_tr_b4() attributes {wave.kernel} {
  %addr = waveamdmachine.v_mbcnt_lo : !waveamdmachine.reg<vgpr, 1, 0>
  // expected-error @below {{ds_read_tr_b64_b4 requires gfx950}}
  %v, %tok = waveamdmachine.ds_read_tr_b64_b4 %addr
      : (!waveamdmachine.reg<vgpr, 1, 0>)
        -> (!waveamdmachine.reg<vgpr, 2, 2>, !waveamdmachine.mem.token)
  waveamdmachine.s_endpgm
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx942"} {

func.func @bad_ds_read_tr_b8() attributes {wave.kernel} {
  %addr = waveamdmachine.v_mbcnt_lo : !waveamdmachine.reg<vgpr, 1, 0>
  // expected-error @below {{ds_read_tr_b64_b8 requires gfx950}}
  %v, %tok = waveamdmachine.ds_read_tr_b64_b8 %addr
      : (!waveamdmachine.reg<vgpr, 1, 0>)
        -> (!waveamdmachine.reg<vgpr, 2, 2>, !waveamdmachine.mem.token)
  waveamdmachine.s_endpgm
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx942"} {

func.func @bad_ds_read_tr_b16() attributes {wave.kernel} {
  %addr = waveamdmachine.v_mbcnt_lo : !waveamdmachine.reg<vgpr, 1, 0>
  // expected-error @below {{ds_read_tr_b64_b16 requires gfx950}}
  %v, %tok = waveamdmachine.ds_read_tr_b64_b16 %addr
      : (!waveamdmachine.reg<vgpr, 1, 0>)
        -> (!waveamdmachine.reg<vgpr, 2, 2>, !waveamdmachine.mem.token)
  waveamdmachine.s_endpgm
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx942"} {

func.func @bad_ds_read_tr_b6() attributes {wave.kernel} {
  %addr = waveamdmachine.v_mbcnt_lo : !waveamdmachine.reg<vgpr, 1, 0>
  // expected-error @below {{ds_read_tr_b96_b6 requires gfx950}}
  %v, %tok = waveamdmachine.ds_read_tr_b96_b6 %addr
      : (!waveamdmachine.reg<vgpr, 1, 0>)
        -> (!waveamdmachine.reg<vgpr, 3, 4>, !waveamdmachine.mem.token)
  waveamdmachine.s_endpgm
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

func.func @mixed_bank_ds_store2_b32() attributes {wave.kernel} {
  %addr = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, 0>
  %vgpr = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, 1>
  %agpr = waveamdmachine.uninit : !waveamdmachine.reg<agpr, 1, 0>
  %root = waveamdmachine.token : !waveamdmachine.mem.token
  // expected-error @below {{paired DS store values must use the same bank}}
  %token = waveamdmachine.ds_store2_b32 %addr, %vgpr, %agpr after %root
      offsets(0, 1)
      : (!waveamdmachine.reg<vgpr, 1, 0>,
         !waveamdmachine.reg<vgpr, 1, 1>,
         !waveamdmachine.reg<agpr, 1, 0>, !waveamdmachine.mem.token)
        -> !waveamdmachine.mem.token
  waveamdmachine.s_endpgm
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx908"} {

func.func @unsupported_agpr_ds_store2_b32() attributes {wave.kernel} {
  %addr = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, 0>
  %value0 = waveamdmachine.uninit : !waveamdmachine.reg<agpr, 1, 0>
  %value1 = waveamdmachine.uninit : !waveamdmachine.reg<agpr, 1, 1>
  %root = waveamdmachine.token : !waveamdmachine.mem.token
  // expected-error @below {{paired DS AGPR store unsupported on target}}
  %token = waveamdmachine.ds_store2_b32 %addr, %value0, %value1 after %root
      offsets(0, 1)
      : (!waveamdmachine.reg<vgpr, 1, 0>,
         !waveamdmachine.reg<agpr, 1, 0>,
         !waveamdmachine.reg<agpr, 1, 1>, !waveamdmachine.mem.token)
        -> !waveamdmachine.mem.token
  waveamdmachine.s_endpgm
  return
}

}
