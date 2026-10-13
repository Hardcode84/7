// RUN: wave-opt --wave-lower-symbolic-memory --split-input-file %s | FileCheck %s

// CHECK-LABEL: func.func @aligned_recurrence
// CHECK: scf.for
// CHECK: waveamd.dma_load_lds
// CHECK-SAME: bytes = 16
// CHECK-NOT: wave.gather
// CHECK-NOT: wave.scatter

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
  func.func @aligned_recurrence(%src: !wave.ptr<#waveamd.buffer, i32>,
      %dst: !wave.ptr<#wave.shared, i32>, %raw_stride: i32)
      attributes {wave.workgroup_size = array<i32: 64, 1, 1>} {
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
    return
  }
}

// -----

// Assume facts belong to its result, not sibling uses of the raw stride.
// CHECK-LABEL: func.func @sibling_assume
// CHECK: scf.for
// CHECK-NOT: waveamd.dma_load_lds
// CHECK: wave.load
// CHECK: wave.store
// CHECK-NOT: wave.gather
// CHECK-NOT: wave.scatter

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
  func.func @sibling_assume(%src: !wave.ptr<#waveamd.buffer, i32>,
      %dst: !wave.ptr<#wave.shared, i32>, %raw_stride: i32)
      attributes {wave.workgroup_size = array<i32: 64, 1, 1>} {
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
    %stride = wave.splat %raw_stride : i32 -> !wave.simd<i32, 64>
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
    return
  }
}
