// RUN: wave-opt --waveamd-resource-info %s | FileCheck %s

// CHECK-LABEL: func.func @dynamic_lds
// CHECK-SAME: wave.dynamic_lds_size = 65536 : i64
// CHECK-SAME: wave.lds_size = 0 : i64
// CHECK-SAME: waveamdmachine.dynamic_lds_size = 65536 : i64
// CHECK-SAME: waveamdmachine.lds_size = 65536 : i64
func.func @dynamic_lds() attributes {
  wave.kernel,
  wave.dynamic_lds_size = 65536 : i64,
  wave.lds_size = 0 : i64
} {
  return
}

// CHECK-LABEL: func.func @mixed_lds
// CHECK-SAME: wave.dynamic_lds_size = 1024 : i64
// CHECK-SAME: wave.lds_size = 512 : i64
// CHECK-SAME: waveamdmachine.dynamic_lds_size = 1024 : i64
// CHECK-SAME: waveamdmachine.lds_size = 1536 : i64
func.func @mixed_lds() attributes {
  wave.kernel,
  wave.dynamic_lds_size = 1024 : i64,
  wave.lds_size = 512 : i64
} {
  return
}
