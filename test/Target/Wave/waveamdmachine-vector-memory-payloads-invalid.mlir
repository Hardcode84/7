// RUN: wave-opt --waveamd-to-machine -split-input-file -verify-diagnostics %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

func.func @scalable_i8_singleton_pack(%value: !wave.simd<i8, 32>) {
  // expected-error @below {{vector payload must be 16 bits or a multiple of 32 bits}}
  %packet = wave.pack %value
      : !wave.simd<i8, 32> -> !wave.simd<vector<[1]xi8>, 32>
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

func.func @scalable_i8_singleton_extract(
    %packet: !wave.simd<vector<[1]xi8>, 32>) -> !wave.simd<i8, 32> {
  // expected-error @below {{vector payload must be 16 bits or a multiple of 32 bits}}
  %value = wave.extract %packet[0]
      : !wave.simd<vector<[1]xi8>, 32> -> !wave.simd<i8, 32>
  return %value : !wave.simd<i8, 32>
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

func.func @fixed_i4_singleton_pack(%value: !wave.simd<i4, 32>) {
  // expected-error @below {{vector payload must be 16 bits or a multiple of 32 bits}}
  %packet = wave.pack %value
      : !wave.simd<i4, 32> -> !wave.simd<vector<1xi4>, 32>
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

func.func @fixed_rank2_singleton_pack(%value: !wave.simd<i8, 32>) {
  // expected-error @below {{must be 1-D vector or wave SIMD of 1-D vector}}
  %packet = wave.pack %value
      : !wave.simd<i8, 32> -> !wave.simd<vector<1x1xi8>, 32>
  return
}

}
