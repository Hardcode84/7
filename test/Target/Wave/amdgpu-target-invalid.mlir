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

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
  func.func @unsupported_agpr() {
    %off = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1, 1>
    %base = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 2, 6>
    // expected-error @below {{wave-to-amdgpu-asm AGPR registers require target with AGPR support}}
    %agpr = waveamdmachine.uninit : !waveamdmachine.reg<agpr, 1, 0>
    %token = waveamdmachine.global_store_b32 %off, %agpr, %base
        : (!waveamdmachine.reg<vgpr, 1, 1>, !waveamdmachine.reg<agpr, 1, 0>,
           !waveamdmachine.reg<sgpr, 2, 6>) -> !waveamdmachine.mem.token
    return
  }
}
