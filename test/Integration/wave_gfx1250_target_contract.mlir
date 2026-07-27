// RUN: wave-opt --waveamd-to-machine --split-input-file --verify-diagnostics %s | FileCheck %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1250"} {

  // CHECK-LABEL: func.func @default_wave32
  // CHECK: waveamdmachine.v_cvt_pk_f16_f32
  func.func @default_wave32(%src: !wave.simd<vector<2xf32>, 32>) {
    %rne = wave.cast fpconvert %src
        : !wave.simd<vector<2xf32>, 32> -> !wave.simd<vector<2xf16>, 32>
    return
  }

}

// -----

// expected-error @below {{WaveAMDMachine selection target gfx1250 does not support wave64}}
module attributes {
  waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1250",
  waveamdmachine.wavefront_size = 64 : i64
} {
  func.func @reject_wave64(%x: i32) {
    %v = wave.splat %x : i32 -> !wave.simd<i32, 64>
    return
  }
}
