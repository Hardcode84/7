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

// LOWER-LABEL: func.func @symbolic_memory_multiwave_dma_plan_codegen(
// LOWER: [[WAVE_BASE:%.*]] = wave.read_first
// LOWER: wave.index_expr <{{.*}}dma_wave_base{{.*}}> {{.*}}["dma_wave_base"]([[WAVE_BASE]])
// LOWER: waveamd.dma_load_lds
// LOWER-NOT: wave.gather
// LOWER-NOT: wave.scatter

// ASM-LABEL: symbolic_memory_multiwave_dma_plan_codegen:
// ASM: buffer_load_dwordx4 {{.*}} lds
// ASM-NOT: global_load_dword
// ASM: s_endpgm

// LOWER-LABEL: func.func @symbolic_memory_recurrence_dma_codegen(
// LOWER: scf.for
// LOWER: waveamd.dma_load_lds
// LOWER-SAME: bytes = 16
// LOWER-NOT: wave.gather
// LOWER-NOT: wave.scatter

// ASM-LABEL: symbolic_memory_recurrence_dma_codegen:
// ASM: buffer_load_dwordx4 {{.*}} lds
// ASM-NOT: ds_write
// ASM: s_endpgm

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
  func.func @symbolic_memory_dma_plan_codegen(
      %source: !wave.ptr<#wave.global, i32>) -> !wave.mem.token attributes {wave.kernel, wave.lds_size = 1024 : i64,
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
    return %stored : !wave.mem.token
  }

  func.func @symbolic_memory_multiwave_dma_plan_codegen(
      %source: !wave.ptr<#wave.global, i32>) -> !wave.mem.token attributes {wave.kernel, wave.lds_size = 4096 : i64,
                  wave.workgroup_size = array<i32: 256, 1, 1>,
                  wave.waves_per_workgroup = 4 : i64} {
    %destination = wave.shared_memory_base : !wave.ptr<#wave.shared, i32>
    %item = wave.workitem_id 0 : !wave.simd<i32, 64>
    %bounded_item = wave.index_expr <"item"> assuming
        [#wave.pred<"item >= 0">, #wave.pred<"item <= 255">]
        ["item"](%item)
        : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
    %dependency = wave.token : !wave.mem.token
    %value, %loaded = wave.gather %source mapping
        <bit_offset = <"32*(4*Mod(item, 64) + 512*floor(item/64) + slot)">>
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
    return %stored : !wave.mem.token
  }

  func.func @symbolic_memory_recurrence_dma_codegen(
      %source: !wave.ptr<#wave.global, i32>, %raw_stride: i32)
      -> !wave.mem.token attributes {wave.kernel, wave.lds_size = 1024 : i64,
          wave.workgroup_size = array<i32: 64, 1, 1>,
          wave.waves_per_workgroup = 1 : i64} {
    %range = arith.constant 2147483647 : i32
    %src = waveamd.make_buffer %source, %range
        : !wave.ptr<#wave.global, i32>, i32 -> !wave.ptr<#waveamd.buffer, i32>
    %dst = wave.shared_memory_base : !wave.ptr<#wave.shared, i32>
    %zero = arith.constant 0 : i32
    %one = arith.constant 1 : i32
    %four = arith.constant 4 : i32
    %raw_item = wave.workitem_id 0 : !wave.simd<i32, 64>
    %item = wave.assume %raw_item as "item"
        [#wave.pred<"item >= 0">, #wave.pred<"item <= 63">]
        : !wave.simd<i32, 64>
    %scale = wave.constant 4 : i32 -> !wave.simd<i32, 64>
    %offset = wave.binary muli %item, %scale
        : !wave.simd<i32, 64>, !wave.simd<i32, 64>
        -> !wave.simd<i32, 64>
    %aligned = wave.assume %raw_stride as "stride"
        [#wave.pred<"Mod(stride, 4) == 0">] : i32
    %stride = wave.splat %aligned : i32 -> !wave.simd<i32, 64>
    %seed = wave.token : !wave.mem.token
    %result:2 = scf.for %i = %zero to %four step %one
        iter_args(%current = %offset, %dep = %seed)
        -> (!wave.simd<i32, 64>, !wave.mem.token) : i32 {
      %value, %loaded = wave.gather %src mapping
          <bit_offset = <"8*Mod(4*(offset + slot), 4294967296)">>
          bindings ["item", "offset"](%item, %current) after %dep
          : (!wave.ptr<#waveamd.buffer, i32>, !wave.simd<i32, 64>, !wave.simd<i32, 64>,
             !wave.mem.token)
          -> (!wave.simd<vector<4xi32>, 64>, !wave.mem.token)
      %stored = wave.scatter %value to %dst mapping
          <bit_offset = <"32*(4*item + slot)">> bindings ["item"](%item)
          after %loaded
          : (!wave.simd<vector<4xi32>, 64>, !wave.ptr<#wave.shared, i32>,
             !wave.simd<i32, 64>, !wave.mem.token) -> !wave.mem.token
      %next = wave.binary addi %current, %stride
          : !wave.simd<i32, 64>, !wave.simd<i32, 64>
          -> !wave.simd<i32, 64>
      scf.yield %next, %stored : !wave.simd<i32, 64>, !wave.mem.token
    }
    return %result#1 : !wave.mem.token
  }
}
