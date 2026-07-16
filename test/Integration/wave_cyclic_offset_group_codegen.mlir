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

}
