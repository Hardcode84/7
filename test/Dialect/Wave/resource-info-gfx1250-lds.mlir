// RUN: wave-opt --waveamd-resource-info %s | FileCheck %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1250"} {

// CHECK-LABEL: func.func @full_lds
// CHECK-SAME: wave.lds_size = 327680 : i64
// CHECK-SAME: waveamdmachine.lds_size = 327680 : i64
func.func @full_lds() attributes {
  wave.kernel,
  wave.lds_size = 327680 : i64
} {
  return
}

}
