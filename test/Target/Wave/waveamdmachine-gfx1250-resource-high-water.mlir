// RUN: wave-opt --waveamd-resource-info %s | FileCheck %s

module attributes {
  waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1250"
} {
  // CHECK-LABEL: func.func @v1023_high_water
  // CHECK-SAME: waveamdmachine.vgpr_count = 1024 : i64
  func.func @v1023_high_water(
      %last: !waveamdmachine.reg<vgpr, 1, 1023>) {
    return
  }
}
