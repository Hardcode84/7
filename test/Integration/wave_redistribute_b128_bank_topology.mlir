// RUN: wave-opt --wave-lower-redistribute %s | FileCheck %s --check-prefix=LAYOUT
// RUN: wave-translate --wave-to-amdgpu-asm %s > %t.s
// RUN: FileCheck %s --check-prefix=ASM --input-file=%t.s
// RUN: llvm-mc --triple=amdgcn-amd-amdhsa --mcpu=gfx950 --filetype=obj %t.s -o /dev/null

// Lanes 0 and 24 share bank 0 before the scratch permutation.
// LAYOUT-LABEL: func.func @redistribute_b128_bank_topology
// LAYOUT: wave.index_expr <"4*xor(item, 8 & floor(1/8*item))">
// LAYOUT: wave.barrier
// LAYOUT-NOT: wave.redistribute

// ASM-LABEL: redistribute_b128_bank_topology:
// ASM: buffer_load_dwordx4
// ASM: ds_write_b128
// ASM: s_barrier
// ASM: ds_read_b128
// ASM: buffer_store_dwordx4
// ASM: s_endpgm

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
  func.func @redistribute_b128_bank_topology(
      %source: !wave.ptr<#wave.global, f32>,
      %destination: !wave.ptr<#wave.global, f32>) -> !wave.mem.token
      attributes {wave.kernel, wave.workgroup_size = array<i32: 128, 1, 1>,
                  wave.waves_per_workgroup = 2 : i64} {
    %item = wave.workitem_id 0 : !wave.simd<i32, 64>
    %offset = wave.index_expr <"4*item">
        assuming [#wave.pred<"item >= 0 & item <= 127">] ["item"](%item)
        : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
    %input = wave.ptr_add %source, %offset
        : !wave.ptr<#wave.global, f32>, !wave.simd<index, 64>
        -> !wave.simd<!wave.ptr<#wave.global, f32>, 64>
    %value, %read = wave.load %input
        : (!wave.simd<!wave.ptr<#wave.global, f32>, 64>)
        -> (!wave.simd<vector<4xf32>, 64>, !wave.mem.token)
    %moved = wave.redistribute %value,
        <blocks = 1, items = 128, source_block = "block",
         source_item = "xor(item, 72*Mod(floor(item/8) + floor(item/64), 2))",
         source_slot = "slot">
        : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xf32>, 64>
    %output = wave.ptr_add %destination, %offset
        : !wave.ptr<#wave.global, f32>, !wave.simd<index, 64>
        -> !wave.simd<!wave.ptr<#wave.global, f32>, 64>
    %stored = wave.store %moved -> %output after %read
        : (!wave.simd<vector<4xf32>, 64>,
           !wave.simd<!wave.ptr<#wave.global, f32>, 64>, !wave.mem.token)
        -> !wave.mem.token
    return %stored : !wave.mem.token
  }
}
