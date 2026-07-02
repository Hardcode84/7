// RUN: wave-opt %s --wave-form-packed-math --verify-diagnostics

// expected-error @below {{malformed waveamdmachine.target `amdgcn-amd-amdhsa-gfx1100`; expected `<amdgcn-triple>--<chip>[:sramecc(+|-)][:xnack(+|-)]`}}
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa-gfx1100"} {
func.func @malformed_target(%a: !wave.simd<f16, 32>,
                            %b: !wave.simd<f16, 32>) -> !wave.simd<f16, 32> {
  %sum = wave.fadd %a, %b
      : !wave.simd<f16, 32>, !wave.simd<f16, 32> -> !wave.simd<f16, 32>
  return %sum : !wave.simd<f16, 32>
}
}
