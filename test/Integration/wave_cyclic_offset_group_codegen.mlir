// RUN: wave-opt %s --wave-extract-loop-strides | FileCheck %s --check-prefix=GROUP
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
// GROUP: wave.ptr_add %[[BUFFER]], %[[OFFSET]]
// GROUP: %[[NEXT:.*]] = wave.index_expr <"Mod(offset + 128*x_1, 4294967296)">
// GROUP: scf.yield %[[NEXT]]

// ASM-LABEL: modular_buffer_offset_codegen:
// ASM: buffer_load_ubyte
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

}
