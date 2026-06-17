// RUN: wave-opt --waveamd-machine-schedule='model-waves=-1' --verify-diagnostics %s

// expected-error @below {{model-waves must be non-negative}}
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
func.func @negative_model_waves() {
  return
}
}
