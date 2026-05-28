// RUN: wave-opt --waveamd-machine-schedule='apply-schedule=1' --split-input-file --verify-diagnostics %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
// expected-error @below {{waveamdmachine.target_waves must be positive}}
func.func @zero(%a: !waveamdmachine.reg<vgpr, 1>,
                %b: !waveamdmachine.reg<vgpr, 1>)
    attributes {waveamdmachine.target_waves = 0 : i64} {
  %v = waveamdmachine.v_add_u32 %a, %b : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  return
}
}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
// expected-error @below {{waveamdmachine.target_waves must be an integer attribute}}
func.func @non_integer(%a: !waveamdmachine.reg<vgpr, 1>,
                       %b: !waveamdmachine.reg<vgpr, 1>)
    attributes {waveamdmachine.target_waves = "two"} {
  %v = waveamdmachine.v_add_u32 %a, %b : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  return
}
}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100",
                   waveamdmachine.target_waves = 17 : i64} {
// expected-error @below {{waveamdmachine.target_waves exceeds target wave capacity}}
func.func @too_many(%a: !waveamdmachine.reg<vgpr, 1>,
                    %b: !waveamdmachine.reg<vgpr, 1>) {
  %v = waveamdmachine.v_add_u32 %a, %b : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
  return
}
}
