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

}
