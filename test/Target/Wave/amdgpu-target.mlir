// RUN: wave-translate --wave-to-amdgpu-asm %s | FileCheck %s

// CHECK: .amdgcn_target "amdgcn-amd-amdhsa--gfx950"
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
  func.func @empty() {
    return
  }
}
