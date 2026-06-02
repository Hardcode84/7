// RUN: wave-opt --waveamd-abi-lowering -split-input-file -verify-diagnostics %s

func.func @missing_pointer_attr() attributes {wave.kernel} {
  // expected-error @below {{'waveamdmachine.arg' op requires attribute 'pointer'}}
  %arg = "waveamdmachine.arg"() {index = 0 : i64} : () -> !waveamdmachine.reg<sgpr, 1>
  return
}

// -----

func.func @bad_kernel_arg_class() attributes {wave.kernel} {
  // expected-error @below {{waveamd-abi-lowering expects kernel arguments to be SGPR WaveAMDMachine registers}}
  %arg = waveamdmachine.arg {index = 0 : i64, pointer = false} : !waveamdmachine.reg<vgpr, 1>
  return
}

// -----

func.func @bad_kernel_arg_width() attributes {wave.kernel} {
  // expected-error @below {{waveamd-abi-lowering found argument register width inconsistent with pointer attribute}}
  %arg = waveamdmachine.arg {index = 0 : i64, pointer = true} : !waveamdmachine.reg<sgpr, 1>
  return
}

// -----

func.func @bad_arg_result_count() attributes {wave.kernel} {
  // expected-error @below {{'waveamdmachine.arg' op requires one result}}
  "waveamdmachine.arg"() {index = 0 : i64, pointer = false} : () -> ()
  return
}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

func.func @zero_length_kernarg_preload_is_noop()
    attributes {wave.kernel, waveamdmachine.kernarg_preload_length = 0 : i64} {
  return
}

// expected-error @below {{waveamd-abi-lowering kernarg preload requires target with kernarg-preload feature}}
func.func @unsupported_kernarg_preload_target()
    attributes {wave.kernel, waveamdmachine.kernarg_preload_length = 1 : i64} {
  return
}

}
