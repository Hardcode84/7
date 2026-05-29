// RUN: wave-opt --waveamd-metadata -split-input-file -verify-diagnostics %s

// expected-error @below {{waveamd-metadata requires a waveamdmachine.target module attribute}}
module {
func.func @missing_target() attributes {wave.kernel} {
  return
}
}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// expected-error @below {{waveamd-metadata requires ABI and resource attributes on kernels}}
func.func @missing_kernel_metadata_inputs() attributes {wave.kernel} {
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// expected-error @below {{waveamd-metadata cannot consume overflowed register allocation}}
func.func @overflowed()
    attributes {wave.kernel,
                waveamdmachine.kernarg_size = 0 : i64,
                waveamdmachine.regalloc_overflowed = 1 : i64,
                waveamdmachine.sgpr_count = 6 : i64,
                waveamdmachine.vgpr_count = 1 : i64} {
  return
}

}
