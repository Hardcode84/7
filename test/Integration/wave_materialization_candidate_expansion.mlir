// RUN: wave-opt %s --pass-pipeline='builtin.module(waveamd-to-machine,waveamd-abi-lowering,waveamd-expand-materialization-variants,func.func(waveamdmachine.materialization_candidates(remove-dead-values,cse,canonicalize)),waveamd-machine-schedule{apply-schedule},waveamd-collapse-materialization-variants,waveamd-prepare-regalloc)' | FileCheck %s --check-prefix=COLLAPSE --implicit-check-not=waveamdmachine.materialization --implicit-check-not=waveamdmachine.candidate_yield
// RUN: wave-translate %s --wave-to-amdgpu-asm -o %t.s
// RUN: FileCheck %s --check-prefix=ASM < %t.s
// RUN: llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx1100 -filetype=obj %t.s -o /dev/null
// RUN: wave-opt %s --waveamd-to-machine --waveamd-abi-lowering --waveamd-expand-materialization-variants --waveamd-machine-schedule="apply-schedule" --waveamd-collapse-materialization-variants --waveamd-prepare-regalloc | FileCheck %s --check-prefix=COLLAPSE --implicit-check-not=waveamdmachine.materialization --implicit-check-not=waveamdmachine.candidate_yield
// RUN: wave-opt %s --waveamd-to-machine --waveamd-abi-lowering --waveamd-expand-materialization-variants --waveamd-machine-schedule='apply-schedule' | FileCheck %s --check-prefix=SCHEDULE
// RUN: wave-opt %s --waveamd-to-machine --waveamd-abi-lowering --waveamd-expand-materialization-variants='max-candidates=1' | FileCheck %s --check-prefix=ONE --implicit-check-not=waveamdmachine.materialization_variants
// RUN: wave-opt %s --waveamd-to-machine --waveamd-abi-lowering --waveamd-expand-materialization-variants -o %t.expanded
// RUN: FileCheck %s < %t.expanded
// RUN: wave-opt %t.expanded --pass-pipeline='builtin.module(func.func(waveamdmachine.materialization_candidates(remove-dead-values,cse,canonicalize)))' -o %t.parallel
// RUN: wave-opt %t.expanded --mlir-disable-threading --pass-pipeline='builtin.module(func.func(waveamdmachine.materialization_candidates(remove-dead-values,cse,canonicalize)))' -o %t.serial
// RUN: diff %t.parallel %t.serial
// RUN: wave-opt %t.parallel --waveamd-machine-schedule='apply-schedule' --waveamd-collapse-materialization-variants | wave-translate --wave-to-amdgpu-asm - | llvm-mc --triple=amdgcn-amd-amdhsa --mcpu=gfx1100 --filetype=obj -o /dev/null
// RUN: not wave-opt %t.expanded --waveamd-prepare-regalloc 2>&1 | FileCheck %s --check-prefix=ALLOC

// ONE-LABEL: func.func @kernel
// ONE: waveamdmachine.materialization_candidates
// ONE: waveamdmachine.s_mul_i32
// ONE: waveamdmachine.global_store_b32
// ONE: waveamdmachine.candidate_yield
// ONE-NOT: waveamdmachine.candidate_yield
// ONE: waveamdmachine.s_endpgm
// SCHEDULE-LABEL: func.func @kernel
// SCHEDULE: waveamdmachine.materialization_candidates
// SCHEDULE: waveamdmachine.candidate_yield {{.*}}cycles = {{[0-9]+}} : i64
// SCHEDULE: waveamdmachine.candidate_yield {{.*}}cycles = {{[0-9]+}} : i64
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
  func.func @kernel(%out: !wave.ptr<#wave.global, i32>, %x: i32) -> !wave.mem.token attributes {wave.kernel} {
    %two = arith.constant 2 : i32
    %mul = wave.binary muli %x, %two : i32, i32 -> i32
    %add = wave.binary addi %x, %x : i32, i32 -> i32
    %choice = wave.materialization_variants %mul, %add : i32
    %value = wave.splat %choice : i32 -> !wave.simd<i32, 32>
    %observed_store_1 = wave.store %value -> %out : (!wave.simd<i32, 32>, !wave.ptr<#wave.global, i32>) -> !wave.mem.token
    return %observed_store_1 : !wave.mem.token
  }

// ONE-LABEL: func.func @loop_kernel
// ONE: waveamdmachine.materialization_candidates
// ONE: waveamdmachine.s_mul_i32
// ONE: waveamdmachine.global_store_b32
// ONE: waveamdmachine.candidate_yield
// ONE-NOT: waveamdmachine.candidate_yield
// ONE: waveamdmachine.s_endpgm
// SCHEDULE-LABEL: func.func @loop_kernel
// SCHEDULE: waveamdmachine.materialization_candidates
// SCHEDULE: waveamdmachine.candidate_yield {{.*}}cycles = {{[0-9]+}} : i64
// SCHEDULE: waveamdmachine.candidate_yield {{.*}}cycles = {{[0-9]+}} : i64
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
  func.func @loop_kernel(%out: !wave.ptr<#wave.global, i32>, %x: i32) -> !wave.mem.token attributes {wave.kernel} {
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
    %observed_store_2 = wave.store %value -> %out : (!wave.simd<i32, 32>, !wave.ptr<#wave.global, i32>) -> !wave.mem.token
    return %observed_store_2 : !wave.mem.token
  }
}

// COLLAPSE-LABEL: func.func @kernel
// COLLAPSE: waveamdmachine.global_store_b32
// COLLAPSE: waveamdmachine.s_endpgm
// COLLAPSE-LABEL: func.func @loop_kernel
// COLLAPSE: waveamdmachine.uniform_loop
// COLLAPSE: waveamdmachine.global_store_b32
// COLLAPSE: waveamdmachine.s_endpgm

// ASM-LABEL: kernel:
// ASM: buffer_store_b32
// ASM: s_endpgm
// ASM-LABEL: loop_kernel:
// ASM: s_cbranch
// ASM: buffer_store_b32
// ASM: s_endpgm

// RUN: wave-opt %s --pass-pipeline='builtin.module(transform-preload-library{transform-library-paths=%wave_pipelines},transform-interpreter{entry-point=waveamd_backend_unscheduled})' | FileCheck %s --check-prefix=BASELINE --implicit-check-not=waveamdmachine.materialization --implicit-check-not=waveamdmachine.candidate_yield
// BASELINE-LABEL: func.func @kernel
// BASELINE: waveamdmachine.s_mul_i32
// BASELINE: waveamdmachine.buffer_store_b32
