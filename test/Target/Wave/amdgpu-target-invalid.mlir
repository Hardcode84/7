// RUN: wave-translate --wave-to-amdgpu-asm --split-input-file --verify-diagnostics %s

// expected-error @below {{wave AMDGPU backend does not support target: amdgcn-amd-amdhsa--gfx1200 (supported gfx generations: gfx8, gfx9, gfx11)}}
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1200"} {
  func.func @empty() {
    return
  }
}

// -----

// expected-error @below {{wave AMDGPU backend does not support target: amdgcn-amd-amdhsa--gfx1030 (supported gfx generations: gfx8, gfx9, gfx11)}}
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1030"} {
  func.func @empty() {
    return
  }
}

// -----

// expected-error @below {{unsupported AMDGPU target: amdgcn-amd-amdhsa--gfx1300}}
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1300"} {
  func.func @empty() {
    return
  }
}
