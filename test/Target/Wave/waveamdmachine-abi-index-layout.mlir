// RUN: wave-opt --waveamd-abi-lowering %s | FileCheck %s

// CHECK-LABEL: func.func @arg_index_layout
// CHECK-SAME: waveamdmachine.kernarg_size = 16 : i64
// CHECK: [[OFF4:%.*]] = waveamdmachine.imm 4
// CHECK-NEXT: waveamdmachine.s_load_b64 [[OFF4]], "s[0:1]"
func.func @arg_index_layout(%unused: i32, %wide: i64) attributes {wave.kernel} {
  %arg = waveamdmachine.arg {index = 1 : i64, pointer = false} : !waveamdmachine.reg<sgpr, 2>
  return
}
