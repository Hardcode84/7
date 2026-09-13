// RUN: wave-opt %s --wave-extract-loop-strides | FileCheck %s --check-prefix=GROUP
// RUN: wave-opt %s --wave-extract-loop-strides --wave-materialize-memory-variants --waveamd-to-machine | FileCheck %s --check-prefix=MACHINE
// RUN: wave-opt %s --wave-extract-loop-strides --wave-materialize-memory-variants --waveamd-to-machine --waveamd-expand-materialization-variants | FileCheck %s --check-prefix=CANDIDATE
// RUN: wave-opt %s --wave-materialize-memory-variants | FileCheck %s --check-prefix=MULTIROOT
// RUN: wave-translate --wave-to-amdgpu-asm %s | FileCheck %s --check-prefix=ASM
// RUN: wave-translate --wave-to-amdgpu-asm %s \
// RUN:   | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx950 -filetype=obj -o /dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// GROUP-LABEL: func.func @cyclic_offset_group_codegen(
// GROUP: scf.for {{.*}} iter_args(%[[OFF:.*]] = {{.*}})
// GROUP: %[[PEER:.*]] = wave.index_expr <"8192 + offset"> ["offset"](%[[OFF]])
// GROUP: wave.ptr_add %arg0, %[[OFF]]
// GROUP: wave.ptr_add %arg1, %[[PEER]]

// ASM-LABEL: cyclic_offset_group_codegen:
// ASM-COUNT-2: buffer_load_dword
func.func @cyclic_offset_group_codegen(
    %a: !wave.ptr<#wave.global, i32>, %b: !wave.ptr<#wave.global, i32>)
    attributes {wave.kernel} {
  %c0 = arith.constant 0 : i32
  %c1 = arith.constant 1 : i32
  %c8 = arith.constant 8 : i32
  scf.for %i = %c0 to %c8 step %c1 : i32 {
    %aoff = wave.index_expr <"32768*Mod(i, 4)"> ["i"](%i) : (i32) -> index
    %boff = wave.index_expr <"8192 + 32768*Mod(i, 4)"> ["i"](%i)
        : (i32) -> index
    %ap = wave.ptr_add %a, %aoff
        : !wave.ptr<#wave.global, i32>, index -> !wave.ptr<#wave.global, i32>
    %bp = wave.ptr_add %b, %boff
        : !wave.ptr<#wave.global, i32>, index -> !wave.ptr<#wave.global, i32>
    %av, %at = wave.load %ap
        : (!wave.ptr<#wave.global, i32>) -> (!wave.simd<i32, 64>, !wave.mem.token)
    %bv, %bt = wave.load %bp
        : (!wave.ptr<#wave.global, i32>) -> (!wave.simd<i32, 64>, !wave.mem.token)
    %ast = wave.store %av -> %ap after %at
        : (!wave.simd<i32, 64>, !wave.ptr<#wave.global, i32>, !wave.mem.token)
          -> !wave.mem.token
    %bst = wave.store %bv -> %bp after %bt
        : (!wave.simd<i32, 64>, !wave.ptr<#wave.global, i32>, !wave.mem.token)
          -> !wave.mem.token
  }
  return
}

// GROUP-LABEL: func.func @modular_buffer_offset_codegen(
// GROUP: %[[BUFFER:.*]] = waveamd.make_buffer
// GROUP: %[[BASE:.*]] = wave.index_expr <"Mod(lane, 4294967296)">
// GROUP: scf.for {{.*}} iter_args(%[[OFFSET:.*]] = %[[BASE]])
// GROUP: %[[REMAT:.*]] = wave.index_expr <"Mod(lane + 128*x, 4294967296)">
// GROUP: %[[CHOICE:.*]] = wave.materialization_variants %[[REMAT]], %[[OFFSET]]
// GROUP: wave.ptr_add %[[BUFFER]], %[[CHOICE]]
// GROUP: %[[NEXT:.*]] = wave.index_expr <"Mod(offset + 128*x_1, 4294967296)">
// GROUP: scf.yield %[[NEXT]]

// ASM-LABEL: modular_buffer_offset_codegen:
// ASM: buffer_load_ubyte
// MACHINE-LABEL: func.func @modular_buffer_offset_codegen
// MACHINE-COUNT-2: waveamdmachine.buffer_load_u8
// MACHINE: waveamdmachine.materialization_variants {{.*}} {materialization_choice_group = 0 : i64} : !waveamdmachine.reg<vgpr, 1>
// MACHINE: waveamdmachine.materialization_variants {{.*}} {materialization_choice_group = 0 : i64} : !waveamdmachine.mem.token
// MACHINE-COUNT-2: waveamdmachine.buffer_store_b8
// MACHINE: waveamdmachine.materialization_variants {{.*}} {materialization_choice_group = 0 : i64} : !waveamdmachine.mem.token
// CANDIDATE-LABEL: func.func @modular_buffer_offset_codegen
// CANDIDATE: waveamdmachine.materialization_candidates
// CANDIDATE: waveamdmachine.buffer_load_u8
// CANDIDATE-NOT: waveamdmachine.buffer_load_u8
// CANDIDATE: waveamdmachine.buffer_store_b8
// CANDIDATE: waveamdmachine.candidate_yield
// CANDIDATE: waveamdmachine.buffer_load_u8
// CANDIDATE-NOT: waveamdmachine.buffer_load_u8
// CANDIDATE: waveamdmachine.buffer_store_b8
// CANDIDATE: waveamdmachine.candidate_yield
func.func @modular_buffer_offset_codegen(
    %a: !wave.ptr<#wave.global, i8>, %stride: i32)
    attributes {wave.kernel} {
  %c0 = arith.constant 0 : i32
  %c1 = arith.constant 1 : i32
  %c4 = arith.constant 4 : i32
  %range = arith.constant 4294967295 : i32
  %buffer = waveamd.make_buffer %a, %range
      : !wave.ptr<#wave.global, i8>, i32 -> !wave.ptr<#waveamd.buffer, i8>
  %lane = wave.lane_id : !wave.simd<i32, 64>
  scf.for %i = %c0 to %c4 step %c1 : i32 {
    %scaled = wave.binary muli %i, %stride : i32, i32 -> i32
    %off = wave.index_expr <"Mod(128*x + lane, 4294967296)"> ["x", "lane"]
        (%scaled, %lane)
        : (i32, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
    %p = wave.ptr_add %buffer, %off
        : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64>
        -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
    %value, %token = wave.load %p
        : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>)
        -> (!wave.simd<i8, 64>, !wave.mem.token)
    %stored = wave.store %value -> %p after %token
        : (!wave.simd<i8, 64>,
           !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.mem.token)
        -> !wave.mem.token
  }
  return
}

// GROUP-LABEL: func.func @independent_modular_offsets(
// GROUP-COUNT-2: wave.materialization_variants
func.func @independent_modular_offsets(
    %a: !wave.ptr<#wave.global, i8>, %b: !wave.ptr<#wave.global, i8>)
    attributes {wave.kernel} {
  %c0 = arith.constant 0 : i32
  %c1 = arith.constant 1 : i32
  %c4 = arith.constant 4 : i32
  %range = arith.constant 4294967295 : i32
  %ab = waveamd.make_buffer %a, %range
      : !wave.ptr<#wave.global, i8>, i32 -> !wave.ptr<#waveamd.buffer, i8>
  %bb = waveamd.make_buffer %b, %range
      : !wave.ptr<#wave.global, i8>, i32 -> !wave.ptr<#waveamd.buffer, i8>
  %lane = wave.lane_id : !wave.simd<i32, 64>
  scf.for %i = %c0 to %c4 step %c1 : i32 {
    %aoff = wave.index_expr <"Mod(128*i + lane, 4294967296)">
        ["i", "lane"](%i, %lane)
        : (i32, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
    %boff = wave.index_expr <"Mod(256*i + lane, 4294967296)">
        ["i", "lane"](%i, %lane)
        : (i32, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
    %ap = wave.ptr_add %ab, %aoff
        : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64>
        -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
    %bp = wave.ptr_add %bb, %boff
        : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64>
        -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
    %av, %at = wave.load %ap
        : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>)
        -> (!wave.simd<i8, 64>, !wave.mem.token)
    %bv, %bt = wave.load %bp
        : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>)
        -> (!wave.simd<i8, 64>, !wave.mem.token)
  }
  return
}

// MULTIROOT-LABEL: func.func @shared_choice_address_roots
// MULTIROOT-COUNT-4: wave.ptr_add
// MULTIROOT-COUNT-2: wave.load
// MULTIROOT-COUNT-2: wave.materialization_variants
// MULTIROOT-COUNT-2: wave.store
// MULTIROOT: wave.materialization_variants
// MULTIROOT: return
func.func @shared_choice_address_roots(
    %src: !wave.ptr<#wave.global, i32>, %dst: !wave.ptr<#wave.global, i32>)
    attributes {wave.kernel} {
  %range = arith.constant 4294967295 : i32
  %src_buffer = waveamd.make_buffer %src, %range
      : !wave.ptr<#wave.global, i32>, i32 -> !wave.ptr<#waveamd.buffer, i32>
  %dst_buffer = waveamd.make_buffer %dst, %range
      : !wave.ptr<#wave.global, i32>, i32 -> !wave.ptr<#waveamd.buffer, i32>
  %lane = wave.lane_id : !wave.simd<i32, 64>
  %lane_offset = wave.index_expr <"lane"> ["lane"](%lane)
      : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
  %next_offset = wave.index_expr <"lane + 4"> ["lane"](%lane)
      : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
  %offset = wave.materialization_variants %lane_offset, %next_offset
      : !wave.simd<index, 64>
  %srcp = wave.ptr_add %src_buffer, %offset
      : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<index, 64>
      -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>
  %dstp = wave.ptr_add %dst_buffer, %offset
      : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<index, 64>
      -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>
  %value, %loaded = wave.load %srcp
      : (!wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>)
      -> (!wave.simd<i32, 64>, !wave.mem.token)
  %stored = wave.store %value -> %dstp after %loaded
      : (!wave.simd<i32, 64>,
         !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>, !wave.mem.token)
      -> !wave.mem.token
  return
}

}
