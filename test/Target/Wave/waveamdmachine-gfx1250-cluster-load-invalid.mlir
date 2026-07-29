// RUN: env WAVE_PIPELINES_DIR=%S/Inputs/emit-only-pipeline \
// RUN:   wave-translate --wave-to-amdgpu-asm --verify-diagnostics \
// RUN:     --split-input-file %s

module attributes {
  waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"
} {

func.func @wrong_target(
    %offset: !waveamdmachine.reg<vgpr, 1, 0>,
    %base: !waveamdmachine.reg<sgpr, 2, 0>,
    %mask: !waveamdmachine.reg<sgpr, 1, 2>) {
  %m0 = waveamdmachine.s_mov_m0 %mask
      : (!waveamdmachine.reg<sgpr, 1, 2>) -> !waveamdmachine.m0
  %root = waveamdmachine.token : !waveamdmachine.mem.token
  // expected-error @below {{gfx1250 cluster load unsupported on target}}
  %value, %loaded = waveamdmachine.cluster_load_b32
      %offset, %base, %m0 after %root
      : (!waveamdmachine.reg<vgpr, 1, 0>,
         !waveamdmachine.reg<sgpr, 2, 0>,
         !waveamdmachine.m0,
         !waveamdmachine.mem.token)
        -> (!waveamdmachine.reg<vgpr, 1, 1>,
            !waveamdmachine.mem.token)
  return
}

}

// -----

// expected-error @below {{wave AMDGPU backend does not support target: amdgcn-amd-amdhsa--gfx1251}}
module attributes {
  waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1251"
} {

func.func @distinct_target(
    %lds: !waveamdmachine.reg<vgpr, 1, 0>,
    %offset: !waveamdmachine.reg<vgpr, 1, 1>,
    %base: !waveamdmachine.reg<sgpr, 2, 0>,
    %mask: !waveamdmachine.reg<sgpr, 1, 2>) {
  %m0 = waveamdmachine.s_mov_m0 %mask
      : (!waveamdmachine.reg<sgpr, 1, 2>) -> !waveamdmachine.m0
  %root = waveamdmachine.token : !waveamdmachine.mem.token
  %loaded = waveamdmachine.cluster_load_async_to_lds_b8
      %lds, %offset, %base, %m0 after %root
      : (!waveamdmachine.reg<vgpr, 1, 0>,
         !waveamdmachine.reg<vgpr, 1, 1>,
         !waveamdmachine.reg<sgpr, 2, 0>,
         !waveamdmachine.m0,
         !waveamdmachine.mem.token)
        -> !waveamdmachine.mem.token
  return
}

}

// -----

module attributes {
  waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1250"
} {

func.func @invalid_offset(
    %offset: !waveamdmachine.reg<vgpr, 1, 0>,
    %base: !waveamdmachine.reg<sgpr, 2, 0>,
    %mask: !waveamdmachine.reg<sgpr, 1, 2>) {
  %m0 = waveamdmachine.s_mov_m0 %mask
      : (!waveamdmachine.reg<sgpr, 1, 2>) -> !waveamdmachine.m0
  %root = waveamdmachine.token : !waveamdmachine.mem.token
  // expected-error @below {{gfx1250 cluster load offset does not fit target flat offset field}}
  %value, %loaded = waveamdmachine.cluster_load_b32
      %offset, %base, %m0 after %root offset 9223372036854775807
      : (!waveamdmachine.reg<vgpr, 1, 0>,
         !waveamdmachine.reg<sgpr, 2, 0>,
         !waveamdmachine.m0,
         !waveamdmachine.mem.token)
        -> (!waveamdmachine.reg<vgpr, 1, 1>,
            !waveamdmachine.mem.token)
  return
}

}
