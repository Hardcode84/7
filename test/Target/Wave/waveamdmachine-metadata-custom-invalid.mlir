// RUN: wave-translate --wave-to-amdgpu-asm --verify-diagnostics --split-input-file %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
  // expected-error @below {{duplicate waveamdmachine.metadata entry `wave.dup`}}
  func.func @duplicate_custom_metadata()
      attributes {wave.kernel,
                  waveamdmachine.metadata = [
                    {name = "wave.dup", value = 1 : i64},
                    {name = "wave.dup", value = 2 : i64}]} {
    waveamdmachine.s_endpgm
    return
  }
}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
  // expected-error @below {{waveamdmachine.metadata entry `.sgpr_count` uses reserved HSA metadata key namespace}}
  func.func @reserved_custom_metadata()
      attributes {wave.kernel,
                  waveamdmachine.metadata = [
                    {name = ".sgpr_count", value = 7 : i64}]} {
    waveamdmachine.s_endpgm
    return
  }
}
