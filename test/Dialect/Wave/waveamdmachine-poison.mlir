// RUN: wave-opt %s --canonicalize | FileCheck %s

// CHECK-LABEL: func.func @machine_poison
// CHECK: %[[TOKEN:.*]] = waveamdmachine.token
// CHECK: %[[SCALAR:.*]] = waveamdmachine.uninit : !waveamdmachine.reg<sgpr, 2>
// CHECK: %[[VECTOR:.*]] = waveamdmachine.uninit : !waveamdmachine.reg<vgpr, 1>
// CHECK: %[[ACC:.*]] = waveamdmachine.uninit : !waveamdmachine.reg<agpr, 4>
// CHECK-NOT: ub.poison
// CHECK: return %[[TOKEN]], %[[SCALAR]], %[[VECTOR]], %[[ACC]]
func.func @machine_poison() -> (!waveamdmachine.mem.token,
    !waveamdmachine.reg<sgpr, 2>, !waveamdmachine.reg<vgpr, 1>,
    !waveamdmachine.reg<agpr, 4>) {
  %token = ub.poison : !waveamdmachine.mem.token
  %scalar = ub.poison : !waveamdmachine.reg<sgpr, 2>
  %vector = ub.poison : !waveamdmachine.reg<vgpr, 1>
  %acc = ub.poison : !waveamdmachine.reg<agpr, 4>
  return %token, %scalar, %vector, %acc
      : !waveamdmachine.mem.token, !waveamdmachine.reg<sgpr, 2>,
        !waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<agpr, 4>
}

// CHECK-LABEL: func.func @source_poison
// CHECK: %[[POISON:.*]] = ub.poison : i32
// CHECK: return %[[POISON]]
func.func @source_poison() -> i32 {
  %poison = ub.poison : i32
  return %poison : i32
}
