// RUN: wave-opt --waveamd-to-machine %s | FileCheck %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// CHECK-LABEL: func.func @loop_vgpr_carry_init_distinct_from_invariant_use
// CHECK: %[[STEP:.+]] = waveamdmachine.arg {{.*}} : !waveamdmachine.reg<vgpr, 1>
// CHECK: %[[COPY:.+]] = waveamdmachine.copy_tuple %[[STEP]] : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
// CHECK: waveamdmachine.uniform_loop carries({{.*}}, %[[COPY]]
// CHECK: waveamdmachine.v_add_u32 {{.*}}, %[[STEP]]
func.func @loop_vgpr_carry_init_distinct_from_invariant_use(
    %step: !wave.simd<i32, 32>) attributes {wave.kernel} {
  %lo = arith.constant 0 : i32
  %hi = arith.constant 4 : i32
  %one = arith.constant 1 : i32
  %res = scf.for %i = %lo to %hi step %one iter_args(%base = %step)
      -> (!wave.simd<i32, 32>) : i32 {
    %next = wave.binary addi %base, %step
        : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
    scf.yield %next : !wave.simd<i32, 32>
  }
  return
}

// CHECK-LABEL: func.func @loop_assume_carry_init_distinct_from_source_use
// CHECK: %[[RAW:.+]] = waveamdmachine.arg {{.*}} : !waveamdmachine.reg<vgpr, 1>
// CHECK: %[[STEP:.+]] = waveamdmachine.v_add_u32 {{.*}}%[[RAW]]
// CHECK: %[[COPY:.+]] = waveamdmachine.copy_tuple %[[STEP]] : (!waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 1>
// CHECK: waveamdmachine.uniform_loop carries({{.*}}, %[[COPY]]
// CHECK: waveamdmachine.v_add_u32 {{.*}}, %[[STEP]]
func.func @loop_assume_carry_init_distinct_from_source_use(
    %step_raw: !wave.simd<i32, 32>) attributes {wave.kernel} {
  %lo = arith.constant 0 : i32
  %hi = arith.constant 4 : i32
  %one = arith.constant 1 : i32
  %ones = wave.splat %one : i32 -> !wave.simd<i32, 32>
  %step = wave.binary addi %step_raw, %ones
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %init = wave.assume %step as "x"
      [#wave.pred<"x >= 0">, #wave.pred<"x <= 16">] : !wave.simd<i32, 32>
  %res = scf.for %i = %lo to %hi step %one iter_args(%base = %init)
      -> (!wave.simd<i32, 32>) : i32 {
    %next = wave.binary addi %base, %step
        : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
    scf.yield %next : !wave.simd<i32, 32>
  }
  return
}

// CHECK-LABEL: func.func @workitem_id_loop_carry
// CHECK: %[[WI:.+]] = waveamdmachine.v_workitem_id_x : !waveamdmachine.reg<vgpr, 1, 0>
// CHECK: %[[INIT:.+]] = waveamdmachine.v_mov_b32_tuple %[[WI]] : (!waveamdmachine.reg<vgpr, 1, 0>) -> !waveamdmachine.reg<vgpr, 1>
// CHECK: waveamdmachine.uniform_loop {{.*}} carries({{.*}}, %[[INIT]] : !waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
// CHECK: ^bb0(%{{.*}}: !waveamdmachine.reg<sgpr, 1>, %[[CARRY:.*]]: !waveamdmachine.reg<vgpr, 1>):
// CHECK: %[[NEXT:.+]] = waveamdmachine.v_add_u32 {{.*}}, %[[CARRY]]
// CHECK: waveamdmachine.continue_if {{.*}} carries({{.*}}, %[[NEXT]] : !waveamdmachine.reg<sgpr, 1>, !waveamdmachine.reg<vgpr, 1>)
func.func @workitem_id_loop_carry(%n: i32) attributes {wave.kernel} {
  %c0 = arith.constant 0 : i32
  %c1 = arith.constant 1 : i32
  %wi = wave.workitem_id 0 : !wave.simd<i32, 32>
  %one = wave.splat %c1 : i32 -> !wave.simd<i32, 32>
  %res = scf.for %i = %c0 to %n step %c1 iter_args(%base = %wi)
      -> (!wave.simd<i32, 32>) : i32 {
    %next = wave.binary addi %base, %one
        : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
    scf.yield %next : !wave.simd<i32, 32>
  }
  return
}

}
