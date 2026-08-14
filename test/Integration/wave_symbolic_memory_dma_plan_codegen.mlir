// RUN: wave-opt --wave-lower-symbolic-memory %s \
// RUN:   | FileCheck %s --check-prefix=LOWER
// RUN: wave-translate --wave-to-amdgpu-asm %s \
// RUN:   | FileCheck %s --check-prefix=ASM
// RUN: wave-translate --wave-to-amdgpu-asm %s \
// RUN:   | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx950 -filetype=obj -o /dev/null

// LOWER-LABEL: func.func @symbolic_memory_dma_plan_codegen(
// LOWER: [[SHARED:%.*]] = wave.shared_memory_base
// LOWER-COUNT-1: wave.index_expr <"16*source_item">
// LOWER-NOT: #wave.pred<"16*source_item >= 0">
// LOWER: [[DEST:%.*]] = wave.ptr_cast [[SHARED]]
// LOWER: [[ZERO:%.*]] = wave.constant 0 : index
// LOWER: wave.ptr_add [[DEST]], [[ZERO]]
// LOWER-COUNT-1: waveamd.dma_load_lds
// LOWER-NOT: wave.gather
// LOWER-NOT: wave.scatter

// ASM-LABEL: symbolic_memory_dma_plan_codegen:
// ASM-COUNT-1: buffer_load_dwordx4 {{.*}} lds
// ASM-NOT: global_load_dword
// ASM: s_endpgm

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
  func.func @symbolic_memory_dma_plan_codegen(
      %source: !wave.ptr<#wave.global, i32>)
      attributes {wave.kernel, wave.lds_size = 1024 : i64,
                  wave.workgroup_size = array<i32: 64, 1, 1>,
                  wave.waves_per_workgroup = 1 : i64} {
    %destination = wave.shared_memory_base : !wave.ptr<#wave.shared, i32>
    %item = wave.workitem_id 0 : !wave.simd<i32, 64>
    %bounded_item = wave.index_expr <"item"> assuming
        [#wave.pred<"item >= 0">, #wave.pred<"item <= 63">]
        ["item"](%item)
        : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
    %dependency = wave.token : !wave.mem.token
    %value, %loaded = wave.gather %source mapping
        <bit_offset = <"32*(4*item + slot)">>
        bindings ["item"](%bounded_item)
        after %dependency
        : (!wave.ptr<#wave.global, i32>, !wave.simd<index, 64>,
           !wave.mem.token)
        -> (!wave.simd<vector<4xi32>, 64>, !wave.mem.token)
    %stored = wave.scatter %value to %destination mapping
        <bit_offset = <"32*(4*item + slot)">>
        bindings ["item"](%bounded_item) after %loaded
        : (!wave.simd<vector<4xi32>, 64>, !wave.ptr<#wave.shared, i32>,
           !wave.simd<index, 64>, !wave.mem.token) -> !wave.mem.token
    return
  }
}
