// RUN: wave-translate --wave-to-amdgpu-asm --split-input-file --verify-diagnostics %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx942"} {

// expected-error @below {{wave-to-amdgpu-asm kernarg preload offset must be less than 1024 dwords}}
func.func @bad_preload_offset()
    attributes {wave.kernel, waveamdmachine.kernarg_preload_length = 1 : i64,
                waveamdmachine.kernarg_preload_offset = 1024 : i64} {
  waveamdmachine.s_endpgm
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx942"} {

// expected-error @below {{wave-to-amdgpu-asm kernarg preload consumes 34 user SGPRs, but target supports}}
func.func @too_many_preload_sgprs()
    attributes {wave.kernel, waveamdmachine.kernarg_preload_length = 32 : i64} {
  waveamdmachine.s_endpgm
  return
}

}
