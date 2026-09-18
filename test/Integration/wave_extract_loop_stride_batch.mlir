// RUN: wave-opt %s --wave-extract-loop-strides -o %t.once
// RUN: FileCheck %s < %t.once
// RUN: wave-opt %t.once --wave-extract-loop-strides -o %t.twice
// RUN: diff %t.once %t.twice
// RUN: wave-translate %t.once --wave-to-amdgpu-asm -o %t.s
// RUN: llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx950 -filetype=obj %t.s -o /dev/null

// CHECK-LABEL: func.func @shared_offset
// CHECK: scf.for {{.*}} iter_args([[TOKEN:%.*]] = {{%.*}}, [[CARRY_A:%.*]] = {{%.*}}, [[CARRY_B:%.*]] = {{%.*}})
// CHECK: [[OFFSET:%.*]] = wave.cast intconvert {{.*}} -> !wave.simd<index, 64>
// CHECK-NEXT: [[CHOICE_A:%.*]] = wave.materialization_variants [[OFFSET]], [[CARRY_A]]
// CHECK-NEXT: [[PTR_A:%.*]] = wave.ptr_add {{%.*}}, [[CHOICE_A]]
// CHECK-NEXT: [[CHOICE_B:%.*]] = wave.materialization_variants [[OFFSET]], [[CARRY_B]]
// CHECK-NEXT: [[PTR_B:%.*]] = wave.ptr_add {{%.*}}, [[CHOICE_B]]
// CHECK-NEXT: [[BITS:%.*]] = wave.cast intconvert [[OFFSET]]
// CHECK: [[VALUE:%.*]], [[READ:%.*]] = wave.load [[PTR_A]] after [[TOKEN]]
// CHECK: [[SUM:%.*]] = wave.binary addi [[VALUE]], [[BITS]]
// CHECK: [[STORED:%.*]] = wave.store [[SUM]] -> [[PTR_B]] after [[READ]]
// CHECK: scf.yield [[STORED]], {{%.*}}, {{%.*}}
// CHECK: return {{%.*}}#0 : !wave.mem.token
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @shared_offset(%input: !wave.ptr<#wave.global, i32>,
    %output: !wave.ptr<#wave.global, i32>, %n: i32) -> !wave.mem.token
    attributes {wave.kernel} {
  %c0 = arith.constant 0 : i32
  %c1 = arith.constant 1 : i32
  %range = arith.constant 4096 : i32
  %in = waveamd.make_buffer %input, %range : !wave.ptr<#wave.global, i32>, i32 -> !wave.ptr<#waveamd.buffer, i32>
  %out = waveamd.make_buffer %output, %range : !wave.ptr<#wave.global, i32>, i32 -> !wave.ptr<#waveamd.buffer, i32>
  %lane = wave.lane_id : !wave.simd<i32, 64>
  %root = wave.token : !wave.mem.token
  %done = scf.for %i = %c0 to %n step %c1 iter_args(%token = %root) -> !wave.mem.token : i32 {
    %math = wave.index_expr <"64*(4+i) + lane"> ["i", "lane"](%i, %lane) : (i32, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
    %bits = wave.cast intconvert %math : !wave.simd<index, 64> -> !wave.simd<i32, 64>
    %offset = wave.cast intconvert %bits policy {extension = #wave.cast_extension<zero>} : !wave.simd<i32, 64> -> !wave.simd<index, 64>
    %a = wave.ptr_add %in, %offset : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>
    %b = wave.ptr_add %out, %offset : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>
    %data = wave.cast intconvert %offset : !wave.simd<index, 64> -> !wave.simd<i32, 64>
    %value, %read = wave.load %a after %token : (!wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>, !wave.mem.token) -> (!wave.simd<i32, 64>, !wave.mem.token)
    %sum = wave.binary addi %value, %data : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
    %stored = wave.store %sum -> %b after %read : (!wave.simd<i32, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>, !wave.mem.token) -> !wave.mem.token
    scf.yield %stored : !wave.mem.token
  }
  return %done : !wave.mem.token
}
}
