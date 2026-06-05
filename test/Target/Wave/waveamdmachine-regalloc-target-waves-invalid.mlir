// RUN: wave-opt --waveamd-reg-alloc --split-input-file --verify-diagnostics %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// expected-error @below {{waveamd-reg-alloc waveamdmachine.target_waves must be an integer attribute}}
func.func @bad_target_waves_type()
    attributes {waveamdmachine.target_waves = "four"} {
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// expected-error @below {{waveamd-reg-alloc waveamdmachine.target_waves must be positive}}
func.func @bad_target_waves_zero()
    attributes {waveamdmachine.target_waves = 0 : i64} {
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950",
                   waveamdmachine.target_waves = 100 : i64} {

// expected-error @below {{waveamd-reg-alloc waveamdmachine.target_waves exceeds target wave capacity}}
func.func @bad_target_waves_value() {
  return
}

}
