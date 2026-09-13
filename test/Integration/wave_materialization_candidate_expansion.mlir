// RUN: wave-opt %s --waveamd-to-machine --waveamd-abi-lowering --waveamd-expand-materialization-variants='max-candidates=1' | FileCheck %s --check-prefix=ONE --implicit-check-not=waveamdmachine.materialization_variants
// RUN: wave-opt %s --waveamd-to-machine --waveamd-abi-lowering --waveamd-expand-materialization-variants -o %t.expanded
// RUN: FileCheck %s < %t.expanded
// RUN: not wave-opt %t.expanded --waveamd-prepare-regalloc 2>&1 | FileCheck %s --check-prefix=ALLOC

// ONE-LABEL: func.func @kernel
// ONE: waveamdmachine.materialization_candidates
// ONE: waveamdmachine.s_mul_i32
// ONE: waveamdmachine.global_store_b32
// ONE: waveamdmachine.candidate_yield
// ONE-NOT: waveamdmachine.candidate_yield
// ONE: waveamdmachine.s_endpgm
// CHECK-LABEL: func.func @kernel
// CHECK: waveamdmachine.materialization_candidates
// CHECK: waveamdmachine.s_mul_i32
// CHECK-NOT: waveamdmachine.s_add_i32
// CHECK: waveamdmachine.global_store_b32
// CHECK: waveamdmachine.candidate_yield
// CHECK-NOT: waveamdmachine.s_mul_i32
// CHECK: waveamdmachine.s_add_i32
// CHECK: waveamdmachine.global_store_b32
// CHECK: waveamdmachine.candidate_yield
// CHECK: waveamdmachine.s_endpgm
// CHECK-NEXT: return
// ALLOC: must be resolved before register allocation
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
  func.func @kernel(%out: !wave.ptr<#wave.global, i32>, %x: i32) attributes {wave.kernel} {
    %two = arith.constant 2 : i32
    %mul = wave.binary muli %x, %two : i32, i32 -> i32
    %add = wave.binary addi %x, %x : i32, i32 -> i32
    %choice = wave.materialization_variants %mul, %add : i32
    %value = wave.splat %choice : i32 -> !wave.simd<i32, 32>
    wave.store %value -> %out : (!wave.simd<i32, 32>, !wave.ptr<#wave.global, i32>) -> !wave.mem.token
    return
  }
}

// ONE-LABEL: func.func @loop_kernel
// ONE: waveamdmachine.materialization_candidates
// ONE: waveamdmachine.s_mul_i32
// ONE: waveamdmachine.global_store_b32
// ONE: waveamdmachine.candidate_yield
// ONE-NOT: waveamdmachine.candidate_yield
// ONE: waveamdmachine.s_endpgm
// CHECK-LABEL: func.func @loop_kernel
// CHECK: waveamdmachine.materialization_candidates
// CHECK: waveamdmachine.uniform_loop
// CHECK: waveamdmachine.s_mul_i32
// CHECK: waveamdmachine.continue_if
// CHECK: waveamdmachine.global_store_b32
// CHECK: waveamdmachine.candidate_yield
// CHECK: waveamdmachine.uniform_loop
// CHECK: waveamdmachine.s_add_i32
// CHECK: waveamdmachine.continue_if
// CHECK: waveamdmachine.global_store_b32
// CHECK: waveamdmachine.candidate_yield
// CHECK: waveamdmachine.s_endpgm
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
  func.func @loop_kernel(%out: !wave.ptr<#wave.global, i32>, %x: i32) attributes {wave.kernel} {
    %zero = arith.constant 0 : i32
    %one = arith.constant 1 : i32
    %two = arith.constant 2 : i32
    %four = arith.constant 4 : i32
    %result = scf.for %i = %zero to %four step %one iter_args(%carry = %x) -> i32 : i32 {
      %mul = wave.binary muli %carry, %two : i32, i32 -> i32
      %add = wave.binary addi %carry, %carry : i32, i32 -> i32
      %choice = wave.materialization_variants %mul, %add : i32
      scf.yield %choice : i32
    }
    %value = wave.splat %result : i32 -> !wave.simd<i32, 32>
    wave.store %value -> %out : (!wave.simd<i32, 32>, !wave.ptr<#wave.global, i32>) -> !wave.mem.token
    return
  }
}
