// RUN: env WAVE_PIPELINES_DIR=%S/Inputs/emit-only-pipeline \
// RUN:   wave-translate --wave-to-amdgpu-asm --verify-diagnostics \
// RUN:     --split-input-file %s

module attributes {
  waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"
} {

func.func @wrong_target() {
  %lds = waveamdmachine.uninit
      : !waveamdmachine.reg<vgpr, 1, 0>
  %global = waveamdmachine.uninit
      : !waveamdmachine.reg<vgpr, 1, 1>
  %base = waveamdmachine.uninit
      : !waveamdmachine.reg<sgpr, 2, 0>
  %root = waveamdmachine.token : !waveamdmachine.mem.token
  // expected-error @below {{gfx1250 async global-to-LDS load unsupported on target}}
  %loaded = waveamdmachine.global_load_async_to_lds_b8
      %lds, %global, %base after %root
      : (!waveamdmachine.reg<vgpr, 1, 0>,
         !waveamdmachine.reg<vgpr, 1, 1>,
         !waveamdmachine.reg<sgpr, 2, 0>,
         !waveamdmachine.mem.token)
        -> !waveamdmachine.mem.token
  return
}

}

// -----

module attributes {
  waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1250"
} {

func.func @invalid_offset() {
  %lds = waveamdmachine.uninit
      : !waveamdmachine.reg<vgpr, 1, 0>
  %global = waveamdmachine.uninit
      : !waveamdmachine.reg<vgpr, 1, 1>
  %base = waveamdmachine.uninit
      : !waveamdmachine.reg<sgpr, 2, 0>
  %root = waveamdmachine.token : !waveamdmachine.mem.token
  // expected-error @below {{gfx1250 async global-to-LDS load offset does not fit target flat offset field}}
  %loaded = waveamdmachine.global_load_async_to_lds_b8
      %lds, %global, %base after %root offset 9223372036854775807
      : (!waveamdmachine.reg<vgpr, 1, 0>,
         !waveamdmachine.reg<vgpr, 1, 1>,
         !waveamdmachine.reg<sgpr, 2, 0>,
         !waveamdmachine.mem.token)
        -> !waveamdmachine.mem.token
  return
}

}
