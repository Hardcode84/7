// RUN: wave-opt %s --wave-extract-loop-strides | FileCheck %s --check-prefix=CHOICE
// RUN: wave-opt %s --wave-extract-loop-strides --waveamd-to-machine | FileCheck %s --check-prefix=MACHINE
// RUN: wave-translate %s --wave-to-amdgpu-asm | FileCheck %s --check-prefix=ASM
// RUN: wave-translate %s --wave-to-amdgpu-asm | llvm-mc --triple=amdgcn-amd-amdhsa --mcpu=gfx950 --filetype=obj -o /dev/null

// CHOICE-LABEL: func.func @modular_buffer_offset_codegen
// CHOICE: scf.for {{.*}} iter_args(
// CHOICE: wave.materialization_variants
// CHOICE: wave.load
// CHOICE: wave.store
// MACHINE-LABEL: func.func @modular_buffer_offset_codegen
// MACHINE: waveamdmachine.materialization_variants
// MACHINE: waveamdmachine.buffer_load_u8
// MACHINE: waveamdmachine.buffer_store_b8
// ASM-LABEL: modular_buffer_offset_codegen:
// ASM: buffer_load_ubyte
// ASM: buffer_store_byte
// ASM: s_endpgm

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
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
