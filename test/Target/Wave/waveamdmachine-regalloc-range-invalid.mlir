// RUN: wave-opt --waveamd-reg-alloc -split-input-file -verify-diagnostics %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

func.func @fixed_index_out_of_range() {
  // expected-error @below {{waveamd-reg-alloc fixed register index exceeds supported range}}
  %fixed = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, 4294967296>
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// expected-error @below {{waveamd-reg-alloc register width exceeds supported range}}
func.func @width_out_of_range() {
  %wide = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 4294967296>
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx90a"} {

// expected-error @below {{waveamd-reg-alloc VGPR/AGPR live pressure exceeds target-waves budget}}
func.func @agpr_pressure_aggregate()
    attributes {waveamdmachine.target_waves = 4 : i64} {
  %a = waveamdmachine.uninit : !waveamdmachine.reg<agpr, 64>
  %b = waveamdmachine.uninit : !waveamdmachine.reg<agpr, 64>
  %ra = waveamdmachine.v_accvgpr_read_b32_tuple %a
      : (!waveamdmachine.reg<agpr, 64>) -> !waveamdmachine.reg<vgpr, 64>
  %rb = waveamdmachine.v_accvgpr_read_b32_tuple %b
      : (!waveamdmachine.reg<agpr, 64>) -> !waveamdmachine.reg<vgpr, 64>
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// expected-error @below {{waveamd-reg-alloc VGPR/AGPR live pressure exceeds target-waves budget}}
func.func @default_agpr_pressure_aggregate() {
  %a = waveamdmachine.uninit : !waveamdmachine.reg<agpr, 128>
  %b = waveamdmachine.uninit : !waveamdmachine.reg<agpr, 128>
  %ra = waveamdmachine.v_accvgpr_read_b32_tuple %a
      : (!waveamdmachine.reg<agpr, 128>) -> !waveamdmachine.reg<vgpr, 128>
  %rb = waveamdmachine.v_accvgpr_read_b32_tuple %b
      : (!waveamdmachine.reg<agpr, 128>) -> !waveamdmachine.reg<vgpr, 128>
  return
}

}
