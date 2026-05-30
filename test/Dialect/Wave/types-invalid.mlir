// RUN: wave-opt --split-input-file --verify-diagnostics %s

// expected-error @below {{wave SIMD width must be 32 or 64}}
func.func @bad_simd_width(%x: !wave.simd<i32, 7>) {
  return
}

// -----

// expected-error @below {{wave mask width must be 32 or 64}}
func.func @bad_mask_width(%x: !wave.mask<0>) {
  return
}

// -----

// expected-error @below {{fragment role must be 0 (A), 1 (B), or 2 (acc)}}
func.func @bad_fragment_role(%x: !waveamd.fragment<99, f16, 16, 16, 32, 8>) {
  return
}

// -----

// expected-error @below {{fragment register count must be positive}}
func.func @bad_fragment_registers(%x: !waveamd.fragment<0, f16, 16, 16, 32, -5>) {
  return
}

// -----

// expected-error @below {{register width must be positive}}
func.func @bad_machine_reg_width(%x: !waveamdmachine.reg<vgpr, -3>) {
  return
}

// -----

// expected-error @below {{SCC/VCC register width must be 1}}
func.func @bad_machine_flag_width(%x: !waveamdmachine.reg<scc, 2>) {
  return
}

// -----

// expected-error @below {{SCC/VCC registers cannot have a physical index}}
func.func @bad_machine_flag_index(%x: !waveamdmachine.reg<vcc, 1, 0>) {
  return
}
