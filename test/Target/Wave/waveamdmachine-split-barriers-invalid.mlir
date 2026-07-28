// RUN: wave-opt %s --waveamd-split-barriers --verify-diagnostics

// expected-error @below {{waveamd-split-barriers unsupported target}}
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1250"} {
  func.func @rejects_enabled_split_barriers()
      attributes {wave.kernel, wave.workgroup_size = array<i32: 512, 1, 1>,
                  wave.waves_per_workgroup = 8 : i64,
                  waveamdmachine.enable_split_barriers} {
    %root = waveamdmachine.token : !waveamdmachine.mem.token
    %ready = waveamdmachine.s_barrier %root
        : (!waveamdmachine.mem.token) -> !waveamdmachine.mem.token
    return
  }
}
