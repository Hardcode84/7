// RUN: wave-translate --wave-to-amdgpu-asm %s | FileCheck %s
// RUN: wave-translate --wave-to-amdgpu-asm %s | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx950 -filetype=obj -o /dev/null

// CHECK: .amdgcn_target "amdgcn-amd-amdhsa--gfx950"
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
  func.func @empty() {
    return
  }
}
