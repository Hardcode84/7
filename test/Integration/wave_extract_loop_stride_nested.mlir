// RUN: sed 's/@W@/32/g' %s | wave-opt --wave-extract-loop-strides -o %t.once
// RUN: FileCheck %s < %t.once
// RUN: wave-opt %t.once --wave-extract-loop-strides -o %t.twice
// RUN: diff %t.once %t.twice
// RUN: wave-opt %t.twice --wave-materialize-memory-variants -o %t.memory
// RUN: FileCheck %s --check-prefix=MEMORY < %t.memory
// RUN: wave-opt %t.memory --wave-materialize-memory-variants -o %t.memory.twice
// RUN: diff %t.memory %t.memory.twice

// CHECK-LABEL: func.func @nested_offsets
// CHECK: [[OUTER:%.*]]:2 = scf.for {{.*}} iter_args([[OT:%.*]] = {{%.*}}, [[OC:%.*]] = {{%.*}})
// CHECK: [[ORIGINAL:%.*]] = wave.cast intconvert {{.*}} -> index
// CHECK-NEXT: [[CHOICE:%.*]] = wave.materialization_variants [[ORIGINAL]], [[OC]] : index
// CHECK-NEXT: [[BASE:%.*]] = wave.ptr_add {{%.*}}, [[CHOICE]]
// CHECK: [[INNER:%.*]]:4 = scf.for {{.*}} iter_args([[IT:%.*]] = [[OT]], [[ROW:%.*]] = {{%.*}}, [[AC:%.*]] = {{%.*}}, [[BC:%.*]] = {{%.*}})
// CHECK: [[LOCAL:%.*]] = wave.ptr_add [[BASE]],
// CHECK: waveamd.make_buffer [[LOCAL]],
// CHECK: [[A:%.*]] = wave.cast intconvert {{.*}} -> !wave.simd<index,
// CHECK-NEXT: wave.materialization_variants [[A]], [[AC]]
// CHECK: {{%.*}}, [[READ_A:%.*]] = wave.load {{.*}} after [[IT]]
// CHECK: [[WRITE_A:%.*]] = wave.store {{.*}} after [[READ_A]]
// CHECK: [[B:%.*]] = wave.cast intconvert {{.*}} -> !wave.simd<index,
// CHECK-NEXT: wave.materialization_variants [[B]], [[BC]]
// CHECK: {{%.*}}, [[READ_B:%.*]] = wave.load {{.*}} after [[WRITE_A]]
// CHECK: [[WRITE_B:%.*]] = wave.store {{.*}} after [[READ_B]]
// CHECK: scf.yield [[WRITE_B]], {{.*}} : !wave.mem.token, i32, !wave.simd<index,
// CHECK: scf.yield [[INNER]]#0, {{.*}} : !wave.mem.token, index
// CHECK: return [[OUTER]]#0 : !wave.mem.token
// MEMORY-LABEL: func.func @nested_offsets
// MEMORY: wave.materialization_variants
// MEMORY: %[[VALUE:.*]], %[[TOKEN:.*]] = wave.load
// MEMORY-NEXT: %[[ALT_VALUE:.*]], %[[ALT_TOKEN:.*]] = wave.load {{.*}}
// MEMORY-NEXT: %[[VALUE_CHOICE:.*]] = wave.materialization_variants %[[VALUE]], %[[ALT_VALUE]]
// MEMORY-NEXT: %[[TOKEN_CHOICE:.*]] = wave.materialization_variants %[[TOKEN]], %[[ALT_TOKEN]]
// MEMORY-NEXT: %[[VALUE_2:.*]], %[[TOKEN_2:.*]] = wave.load
// MEMORY-NEXT: %[[VALUE_3:.*]], %[[TOKEN_3:.*]] = wave.load
// MEMORY-NEXT: %[[OTHER_VALUE:.*]] = wave.materialization_variants %[[VALUE_2]], %[[VALUE_3]]
// MEMORY-NEXT: %[[OTHER_TOKEN:.*]] = wave.materialization_variants %[[TOKEN_2]], %[[TOKEN_3]]
// MEMORY-NEXT: %[[ALL_VALUE:.*]] = wave.materialization_variants %[[VALUE_CHOICE]], %[[OTHER_VALUE]]
// MEMORY-NEXT: %[[ALL_TOKEN:.*]] = wave.materialization_variants %[[TOKEN_CHOICE]], %[[OTHER_TOKEN]]
// MEMORY: %[[STORE:.*]] = wave.store {{.*}} after %[[ALL_TOKEN]]
// MEMORY-NEXT: %[[ALT_STORE:.*]] = wave.store {{.*}} after %[[ALL_TOKEN]]
// MEMORY-NEXT: wave.materialization_variants %[[STORE]], %[[ALT_STORE]]
// MEMORY: return
module {
func.func @nested_offsets(%storage: !wave.ptr<#wave.global, i32>,
    %outer_lower: i32, %outer_upper: i32, %outer_step: i32,
    %lower: i32, %upper: i32, %step: i32) -> !wave.mem.token
    attributes {wave.kernel, wave.workgroup_size = array<i32: @W@, 1, 1>, wave.waves_per_workgroup = 1 : i64} {
  %zero = arith.constant 0 : i32
  %one = arith.constant 1 : i32
  %range = arith.constant 1024 : i32
  %bytes = wave.ptr_cast %storage : !wave.ptr<#wave.global, i32> -> !wave.ptr<#wave.global, i8>
  %lane = wave.lane_id : !wave.simd<i32, @W@>
  %root = wave.token : !wave.mem.token
  %done = scf.for %j = %outer_lower to %outer_upper step %outer_step iter_args(%outer_token = %root) -> !wave.mem.token : i32 {
    %outer_math = wave.index_expr <"2048*(j - lower)"> ["j", "lower"](%j, %outer_lower) : (i32, i32) -> index
    %outer_bits = wave.cast intconvert %outer_math : index -> i32
    %outer_offset = wave.cast intconvert %outer_bits policy {extension = #wave.cast_extension<zero>} : i32 -> index
    %outer_base = wave.ptr_add %bytes, %outer_offset : !wave.ptr<#wave.global, i8>, index -> !wave.ptr<#wave.global, i8>
    %inner:2 = scf.for %i = %lower to %upper step %step iter_args(%token = %outer_token, %row = %zero) -> (!wave.mem.token, i32) : i32 {
      %bounded = wave.assume %i as "i" [#wave.pred<"i >= 0">] : i32
      %row_offset = wave.index_expr <"1024*row"> ["row"](%row) : (i32) -> index
      %local_base = wave.ptr_add %outer_base, %row_offset : !wave.ptr<#wave.global, i8>, index -> !wave.ptr<#wave.global, i8>
      %buffer = waveamd.make_buffer %local_base, %range : !wave.ptr<#wave.global, i8>, i32 -> !wave.ptr<#waveamd.buffer, i8>
      %math_a = wave.index_expr <"64*(4 + i) + 4*lane"> ["i", "lane"](%bounded, %lane) : (i32, !wave.simd<i32, @W@>) -> !wave.simd<index, @W@>
      %bits_a = wave.cast intconvert %math_a : !wave.simd<index, @W@> -> !wave.simd<i32, @W@>
      %offset_a = wave.cast intconvert %bits_a policy {extension = #wave.cast_extension<zero>} : !wave.simd<i32, @W@> -> !wave.simd<index, @W@>
      %ptr_bytes_a = wave.ptr_add %buffer, %offset_a : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, @W@> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, @W@>
      %ptr_a = wave.ptr_cast %ptr_bytes_a : !wave.simd<!wave.ptr<#waveamd.buffer, i8>, @W@> -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, @W@>
      %value_a, %read_a = wave.load %ptr_a after %token : (!wave.simd<!wave.ptr<#waveamd.buffer, i32>, @W@>, !wave.mem.token) -> (!wave.simd<i32, @W@>, !wave.mem.token)
      %increment_a = wave.constant 1 : i32 -> !wave.simd<i32, @W@>
      %next_a = wave.binary addi %value_a, %increment_a : !wave.simd<i32, @W@>, !wave.simd<i32, @W@> -> !wave.simd<i32, @W@>
      %stored_a = wave.store %next_a -> %ptr_a after %read_a : (!wave.simd<i32, @W@>, !wave.simd<!wave.ptr<#waveamd.buffer, i32>, @W@>, !wave.mem.token) -> !wave.mem.token
      %math_b = wave.index_expr <"128*(2 + i) + 4*lane + 16"> ["i", "lane"](%bounded, %lane) : (i32, !wave.simd<i32, @W@>) -> !wave.simd<index, @W@>
      %bits_b = wave.cast intconvert %math_b : !wave.simd<index, @W@> -> !wave.simd<i32, @W@>
      %offset_b = wave.cast intconvert %bits_b policy {extension = #wave.cast_extension<zero>} : !wave.simd<i32, @W@> -> !wave.simd<index, @W@>
      %ptr_bytes_b = wave.ptr_add %buffer, %offset_b : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, @W@> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, @W@>
      %ptr_b = wave.ptr_cast %ptr_bytes_b : !wave.simd<!wave.ptr<#waveamd.buffer, i8>, @W@> -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, @W@>
      %value_b, %read_b = wave.load %ptr_b after %stored_a : (!wave.simd<!wave.ptr<#waveamd.buffer, i32>, @W@>, !wave.mem.token) -> (!wave.simd<i32, @W@>, !wave.mem.token)
      %increment_b = wave.constant 7 : i32 -> !wave.simd<i32, @W@>
      %next_b = wave.binary addi %value_b, %increment_b : !wave.simd<i32, @W@>, !wave.simd<i32, @W@> -> !wave.simd<i32, @W@>
      %stored_b = wave.store %next_b -> %ptr_b after %read_b : (!wave.simd<i32, @W@>, !wave.simd<!wave.ptr<#waveamd.buffer, i32>, @W@>, !wave.mem.token) -> !wave.mem.token
      %next_row = wave.binary addi %row, %one : i32, i32 -> i32
      scf.yield %stored_b, %next_row : !wave.mem.token, i32
    }
    scf.yield %inner#0 : !wave.mem.token
  }
  return %done : !wave.mem.token
}
}
