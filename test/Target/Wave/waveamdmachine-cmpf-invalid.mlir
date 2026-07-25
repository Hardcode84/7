// RUN: wave-opt --waveamd-to-machine --verify-diagnostics --split-input-file %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
  func.func @unsupported_element(
      %lhs: !wave.simd<f16, 32>,
      %rhs: !wave.simd<f16, 32>) {
    // expected-error @below {{WaveAMDMachine backend supports only !wave.simd<f32, W> cmpf operands}}
    %mask = wave.cmpf olt %lhs, %rhs
        : !wave.simd<f16, 32>, !wave.simd<f16, 32> -> !wave.mask<32>
    return
  }
}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
  func.func @unsupported_predicate(
      %lhs: !wave.simd<f32, 32>,
      %rhs: !wave.simd<f32, 32>) {
    // expected-error @below {{WaveAMDMachine backend supports only ordered eq/lt/le/gt/ge wave.cmpf predicates}}
    %mask = wave.cmpf une %lhs, %rhs
        : !wave.simd<f32, 32>, !wave.simd<f32, 32> -> !wave.mask<32>
    return
  }
}
