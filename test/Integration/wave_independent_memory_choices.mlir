// RUN: wave-opt %s --wave-materialize-memory-variants -o %t.once
// RUN: wave-opt %t.once --wave-materialize-memory-variants -o %t.twice
// RUN: diff %t.once %t.twice
// RUN: FileCheck %s < %t.once
// RUN: wave-opt %t.once --waveamd-to-machine --waveamd-expand-materialization-variants=max-candidates=1 \
// RUN:   --waveamd-collapse-materialization-variants --canonicalize | FileCheck %s --check-prefix=CLEAN
// CLEAN-LABEL: func.func @independent_address_dependencies
// CLEAN-COUNT-2: waveamdmachine.buffer_store_b32
// CLEAN-NOT: waveamdmachine.buffer_store_b32
// CLEAN: waveamdmachine.s_endpgm
// RUN: wave-opt %s --wave-materialize-memory-variants --canonicalize --cse --waveamd-to-machine \
// RUN:   --waveamd-abi-lowering --waveamd-buffer-rsrc-to-tuples --canonicalize --cse --waveamd-expand-materialization-variants --canonicalize --cse \
// RUN:   -o %t.expanded
// RUN: FileCheck %s --check-prefix=EXPAND-STORES \
// RUN:   --implicit-check-not=materialization_variants < %t.expanded
// RUN: FileCheck %s --check-prefix=EXPAND-CANDIDATES < %t.expanded

// RUN: wave-opt %t.expanded --waveamd-machine-schedule=apply-schedule --waveamd-collapse-materialization-variants -o %t.winner
// RUN: wave-translate %t.winner --wave-to-amdgpu-asm -o %t.s
// RUN: FileCheck %s --check-prefix=ASM < %t.s
// RUN: llvm-mc --triple=amdgcn-amd-amdhsa --mcpu=gfx1100 --filetype=obj %t.s -o /dev/null
// ASM-COUNT-2: buffer_store_b32
// ASM-NOT: buffer_store_b32
// ASM: s_endpgm

// CHECK-LABEL: func.func @independent_address_dependencies
// CHECK: [[FIRST_STORE:%.*]] = wave.store
// CHECK-NEXT: [[FIRST_ALT:%.*]] = wave.store {{.*}}
// CHECK-NEXT: [[FIRST:%.*]] = wave.materialization_variants [[FIRST_STORE]], [[FIRST_ALT]]
// CHECK: [[SECOND_STORE:%.*]] = wave.store {{.*}} after [[FIRST]]
// CHECK-NEXT: [[SECOND_ALT:%.*]] = wave.store {{.*}} after [[FIRST]]
// CHECK-NEXT: [[SECOND:%.*]] = wave.materialization_variants [[SECOND_STORE]], [[SECOND_ALT]]
// CHECK: return [[SECOND]]
// EXPAND-STORES-COUNT-8: waveamdmachine.buffer_store_b32
// EXPAND-CANDIDATES-COUNT-4: waveamdmachine.candidate_yield
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
func.func @independent_address_dependencies(
    %out: !wave.ptr<#wave.global, i32>) -> !wave.mem.token attributes {wave.kernel} {
  %range = arith.constant 4096 : i32
  %buffer = waveamd.make_buffer %out, %range
      : !wave.ptr<#wave.global, i32>, i32
      -> !wave.ptr<#waveamd.buffer, i32>
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %two = arith.constant 2 : i32
  %four = arith.constant 4 : i32
  %a0 = wave.binary muli %lane, %two
      : !wave.simd<i32, 32>, i32 -> !wave.simd<i32, 32>
  %a1 = wave.binary addi %lane, %lane
      : !wave.simd<i32, 32>, !wave.simd<i32, 32>
      -> !wave.simd<i32, 32>
  %a = wave.materialization_variants %a0, %a1 : !wave.simd<i32, 32>
  %b0 = wave.binary muli %lane, %four
      : !wave.simd<i32, 32>, i32 -> !wave.simd<i32, 32>
  %b1 = wave.binary shli %lane, %two
      : !wave.simd<i32, 32>, i32 -> !wave.simd<i32, 32>
  %b = wave.materialization_variants %b0, %b1 : !wave.simd<i32, 32>
  %first_ptr = wave.ptr_add %buffer, %a
      : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>
  %first = wave.store %lane -> %first_ptr
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>)
      -> !wave.mem.token
  %second_ptr = wave.ptr_add %buffer, %b
      : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>
  %second = wave.store %lane -> %second_ptr after %first
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>,
         !wave.mem.token) -> !wave.mem.token
  return %second : !wave.mem.token
}
}
