// RUN: wave-opt --split-input-file --waveamd-dma-zero-fill %s | FileCheck %s
// RUN: wave-opt --split-input-file --waveamd-dma-zero-fill --wave-generate-index-exprs --waveamd-to-machine %s | FileCheck %s --check-prefix=MACHINE

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// CHECK-LABEL: func.func @zero_fill_marked_buffer
// CHECK: [[RANGE:%.*]] = arith.constant 2147483647 : i32
// CHECK: [[BUF:%.*]] = waveamd.make_buffer {{.*}}, [[RANGE]]
// CHECK: [[MASK:%.*]] = wave.cmpi
// CHECK: [[SRC:%.*]] = wave.ptr_add [[BUF]]
// CHECK-NOT: wave.where
// CHECK: [[BYTE_BUF:%.*]] = wave.ptr_cast [[BUF]] : !wave.ptr<#waveamd.buffer, i32> -> !wave.ptr<#waveamd.buffer, i8>
// CHECK: [[OOB_OFF:%.*]] = wave.splat [[RANGE]] : i32 -> !wave.simd<i32, 32>
// CHECK: [[OOB:%.*]] = wave.ptr_add [[BYTE_BUF]], [[OOB_OFF]] : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<i32, 32> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 32>
// CHECK: [[TYPED_OOB:%.*]] = wave.ptr_cast [[OOB]] : !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 32> -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>
// CHECK: [[SELECTED:%.*]] = wave.select [[MASK]], [[SRC]], [[TYPED_OOB]]
// CHECK: [[TOK:%.*]] = waveamd.dma_load_lds [[SELECTED]]
// CHECK: wave.barrier [[TOK]]
// MACHINE-LABEL: func.func @zero_fill_marked_buffer
// MACHINE: %[[ACTIVE_BYTES:.*]] = waveamdmachine.v_lshlrev_b32
// MACHINE: %[[OOB_IMM:.*]] = waveamdmachine.imm 2147483647
// MACHINE-NEXT: %[[OOB:.*]] = waveamdmachine.v_mov_b32_tuple %[[OOB_IMM]]
// MACHINE: %[[SELECTED:.*]] = waveamdmachine.v_cndmask_b32_tuple %[[OOB]], %[[ACTIVE_BYTES]]
// MACHINE: waveamdmachine.buffer_load_lds_b128 %[[SELECTED]]
func.func @zero_fill_marked_buffer(%in: !wave.ptr<#wave.global, i32>,
                                   %limit: i32)
    attributes {wave.kernel, wave.lds_size = 128 : i64} {
  %range = arith.constant 2147483647 : i32
  %buf = waveamd.make_buffer %in, %range
      : !wave.ptr<#wave.global, i32>, i32
      -> !wave.ptr<#waveamd.buffer, i32>
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %vlimit = wave.splat %limit : i32 -> !wave.simd<i32, 32>
  %active = wave.cmpi ult %lane, %vlimit
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %src = wave.ptr_add %buf, %lane
      : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>
  %lds = wave.shared_memory_base : !wave.ptr<#wave.shared, i32>
  %tok0 = wave.token : !wave.mem.token
  %tok = wave.where %active {
    %tok1 = waveamd.dma_load_lds %src -> %lds after %tok0
        {bytes = 16 : i64, zero_fill_inactive}
        : (!wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>,
           !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
    wave.yield %tok1 : !wave.mem.token
  } : !wave.mask<32> -> !wave.mem.token
  %bar = wave.barrier %tok : (!wave.mem.token) -> !wave.mem.token
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// An explicit inactive path that returns the DMA dependency has the same token
// semantics as the implicit inactive path. Buffer OOB zero-fill makes the DMA
// unconditional, so its completion token replaces the Where result.
// CHECK-LABEL: func.func @flatten_identity_else
// CHECK: [[MASK:%.*]] = wave.cmpi
// CHECK: [[DEP:%.*]] = wave.token
// CHECK-NOT: wave.where
// CHECK: [[SELECTED:%.*]] = wave.select [[MASK]]
// CHECK: [[DMA:%.*]] = waveamd.dma_load_lds [[SELECTED]]
// CHECK-NOT: zero_fill_inactive
// CHECK: wave.barrier [[DMA]]
func.func @flatten_identity_else(%in: !wave.ptr<#wave.global, i32>,
                                 %limit: i32)
    attributes {wave.kernel, wave.lds_size = 128 : i64} {
  %range = arith.constant 4096 : i32
  %buf = waveamd.make_buffer %in, %range
      : !wave.ptr<#wave.global, i32>, i32
      -> !wave.ptr<#waveamd.buffer, i32>
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %vlimit = wave.splat %limit : i32 -> !wave.simd<i32, 32>
  %active = wave.cmpi ult %lane, %vlimit
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %src = wave.ptr_add %buf, %lane
      : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>
  %lds = wave.shared_memory_base : !wave.ptr<#wave.shared, i32>
  %dependency = wave.token : !wave.mem.token
  %token = wave.where %active {
    %loaded = waveamd.dma_load_lds %src -> %lds after %dependency
        {bytes = 16 : i64, zero_fill_inactive}
        : (!wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>,
           !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
    wave.yield %loaded : !wave.mem.token
  } otherwise {
    wave.yield %dependency : !wave.mem.token
  } : !wave.mask<32> -> !wave.mem.token
  %complete = wave.barrier %token : (!wave.mem.token) -> !wave.mem.token
  return
}

// A different inactive token, an inactive operation, or an unrelated active
// result is not an identity completion path. Each such Where remains intact.
// CHECK-LABEL: func.func @keep_nonidentity_else
// CHECK-NOT: wave.select
// CHECK: wave.where
// CHECK-NOT: wave.select
// CHECK: waveamd.dma_load_lds
// CHECK-NOT: wave.select
// CHECK: wave.where
// CHECK-NOT: wave.select
// CHECK: waveamd.dma_load_lds
// CHECK-NOT: wave.select
// CHECK: wave.where
// CHECK-NOT: wave.select
// CHECK: waveamd.dma_load_lds
// CHECK-NOT: wave.select
func.func @keep_nonidentity_else(%in: !wave.ptr<#wave.global, i32>,
                                 %limit: i32)
    attributes {wave.kernel, wave.lds_size = 128 : i64} {
  %range = arith.constant 4096 : i32
  %buf = waveamd.make_buffer %in, %range
      : !wave.ptr<#wave.global, i32>, i32
      -> !wave.ptr<#waveamd.buffer, i32>
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %vlimit = wave.splat %limit : i32 -> !wave.simd<i32, 32>
  %active = wave.cmpi ult %lane, %vlimit
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %src = wave.ptr_add %buf, %lane
      : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>
  %lds = wave.shared_memory_base : !wave.ptr<#wave.shared, i32>
  %dependency = wave.token : !wave.mem.token
  %other = wave.token : !wave.mem.token
  %wrong_inactive = wave.where %active {
    %loaded = waveamd.dma_load_lds %src -> %lds after %dependency
        {bytes = 16 : i64, zero_fill_inactive}
        : (!wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>,
           !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
    wave.yield %loaded : !wave.mem.token
  } otherwise {
    wave.yield %other : !wave.mem.token
  } : !wave.mask<32> -> !wave.mem.token
  %active_else = wave.where %active {
    %loaded = waveamd.dma_load_lds %src -> %lds after %dependency
        {bytes = 16 : i64, zero_fill_inactive}
        : (!wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>,
           !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
    wave.yield %loaded : !wave.mem.token
  } otherwise {
    %issued = wave.issue_token %dependency
        : !wave.mem.token -> !wave.mem.token
    wave.yield %dependency : !wave.mem.token
  } : !wave.mask<32> -> !wave.mem.token
  %wrong_active = wave.where %active {
    %loaded = waveamd.dma_load_lds %src -> %lds after %dependency
        {bytes = 16 : i64, zero_fill_inactive}
        : (!wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>,
           !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
    wave.yield %other : !wave.mem.token
  } otherwise {
    wave.yield %dependency : !wave.mem.token
  } : !wave.mask<32> -> !wave.mem.token
  %joined = wave.join %wrong_inactive, %active_else, %wrong_active
      : !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
  %complete = wave.barrier %joined : (!wave.mem.token) -> !wave.mem.token
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// Consume zero-fill only across the immediate inner scope.  The scoped Assume
// dominates that inner scope, but must not escape its enclosing outer Where.
// CHECK-LABEL: func.func @nested_zero_fill_keeps_outer_scope
// CHECK: wave.where
// CHECK: [[SCOPED:%.*]] = wave.assume
// CHECK-NOT: wave.where
// CHECK: [[SELECTED:%.*]] = wave.select
// CHECK: waveamd.dma_load_lds [[SELECTED]]
// CHECK-NOT: zero_fill_inactive
// CHECK-NOT: wave.where
// CHECK: wave.yield
// CHECK: return
// MACHINE-LABEL: func.func @nested_zero_fill_keeps_outer_scope
// MACHINE: waveamdmachine.exec_if
// MACHINE: waveamdmachine.buffer_load_lds_b128
func.func @nested_zero_fill_keeps_outer_scope(
    %in: !wave.ptr<#wave.global, i32>, %outer_limit: i32, %inner_limit: i32)
    attributes {wave.kernel, wave.lds_size = 128 : i64} {
  %range = arith.constant 2147483647 : i32
  %buf = waveamd.make_buffer %in, %range
      : !wave.ptr<#wave.global, i32>, i32
      -> !wave.ptr<#waveamd.buffer, i32>
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %outer_vlimit = wave.splat %outer_limit : i32 -> !wave.simd<i32, 32>
  %outer_active = wave.cmpi ult %lane, %outer_vlimit
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %inner_vlimit = wave.splat %inner_limit : i32 -> !wave.simd<i32, 32>
  %inner_active = wave.cmpi ult %lane, %inner_vlimit
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %lds = wave.shared_memory_base : !wave.ptr<#wave.shared, i32>
  %tok0 = wave.token : !wave.mem.token
  %tok = wave.where %outer_active {
    %scoped_lane = wave.assume %lane as "x"
        [#wave.pred<"x >= 0">, #wave.pred<"x <= 31">]
        : !wave.simd<i32, 32>
    %src = wave.ptr_add %buf, %scoped_lane
        : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<i32, 32>
        -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>
    %inner_tok = wave.where %inner_active {
      %loaded = waveamd.dma_load_lds %src -> %lds after %tok0
          {bytes = 16 : i64, zero_fill_inactive}
          : (!wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>,
             !wave.ptr<#wave.shared, i32>, !wave.mem.token)
          -> !wave.mem.token
      wave.yield %loaded : !wave.mem.token
    } : !wave.mask<32> -> !wave.mem.token
    wave.yield %inner_tok : !wave.mem.token
  } : !wave.mask<32> -> !wave.mem.token
  %bar = wave.barrier %tok : (!wave.mem.token) -> !wave.mem.token
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// CHECK-LABEL: func.func @keep_unmarked_dma
// CHECK: wave.where
// CHECK: waveamd.dma_load_lds
// CHECK-NOT: wave.select
func.func @keep_unmarked_dma(%in: !wave.ptr<#wave.global, i32>,
                             %limit: i32)
    attributes {wave.kernel, wave.lds_size = 128 : i64} {
  %range = arith.constant 4096 : i32
  %buf = waveamd.make_buffer %in, %range
      : !wave.ptr<#wave.global, i32>, i32
      -> !wave.ptr<#waveamd.buffer, i32>
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %vlimit = wave.splat %limit : i32 -> !wave.simd<i32, 32>
  %active = wave.cmpi ult %lane, %vlimit
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %src = wave.ptr_add %buf, %lane
      : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>
  %lds = wave.shared_memory_base : !wave.ptr<#wave.shared, i32>
  %tok0 = wave.token : !wave.mem.token
  %tok = wave.where %active {
    %tok1 = waveamd.dma_load_lds %src -> %lds after %tok0 {bytes = 16 : i64}
        : (!wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>,
           !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
    wave.yield %tok1 : !wave.mem.token
  } : !wave.mask<32> -> !wave.mem.token
  %bar = wave.barrier %tok : (!wave.mem.token) -> !wave.mem.token
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// CHECK-LABEL: func.func @keep_global_source
// CHECK: wave.where
// CHECK: waveamd.dma_load_lds
// CHECK-NOT: wave.select
func.func @keep_global_source(%in: !wave.ptr<#wave.global, i32>,
                              %limit: i32)
    attributes {wave.kernel, wave.lds_size = 128 : i64} {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %vlimit = wave.splat %limit : i32 -> !wave.simd<i32, 32>
  %active = wave.cmpi ult %lane, %vlimit
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %src = wave.ptr_add %in, %lane
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %lds = wave.shared_memory_base : !wave.ptr<#wave.shared, i32>
  %tok0 = wave.token : !wave.mem.token
  %tok = wave.where %active {
    %tok1 = waveamd.dma_load_lds %src -> %lds after %tok0
        {bytes = 16 : i64, zero_fill_inactive}
        : (!wave.simd<!wave.ptr<#wave.global, i32>, 32>,
           !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
    wave.yield %tok1 : !wave.mem.token
  } : !wave.mask<32> -> !wave.mem.token
  %bar = wave.barrier %tok : (!wave.mem.token) -> !wave.mem.token
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// CHECK-LABEL: func.func @keep_non_dma_side_effect
// CHECK: wave.where
// CHECK: waveamd.dma_load_lds
// CHECK: wave.store
// CHECK-NOT: wave.select
func.func @keep_non_dma_side_effect(%in: !wave.ptr<#wave.global, i32>,
                                    %out: !wave.ptr<#wave.global, i32>,
                                    %limit: i32)
    attributes {wave.kernel, wave.lds_size = 128 : i64} {
  %range = arith.constant 4096 : i32
  %buf = waveamd.make_buffer %in, %range
      : !wave.ptr<#wave.global, i32>, i32
      -> !wave.ptr<#waveamd.buffer, i32>
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %vlimit = wave.splat %limit : i32 -> !wave.simd<i32, 32>
  %active = wave.cmpi ult %lane, %vlimit
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %src = wave.ptr_add %buf, %lane
      : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>
  %dst = wave.ptr_add %out, %lane
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %lds = wave.shared_memory_base : !wave.ptr<#wave.shared, i32>
  %tok0 = wave.token : !wave.mem.token
  wave.where %active {
    %tok1 = waveamd.dma_load_lds %src -> %lds after %tok0
        {bytes = 16 : i64, zero_fill_inactive}
        : (!wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>,
           !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
    %tok2 = wave.store %lane -> %dst after %tok1
        : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.global, i32>, 32>,
           !wave.mem.token) -> !wave.mem.token
    wave.yield
  } : !wave.mask<32>
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// A modulo-2^32 buffer offset is range proof for the machine voffset.  Its
// low dword is evaluated with native i32 arithmetic even when the exact layout
// coordinate contains rational bit extraction.
// MACHINE-LABEL: func.func @wrapped_layout_offset_uses_i32
// MACHINE-NOT: waveamdmachine.v_mul_u64
// MACHINE-NOT: waveamdmachine.v_add_u64
// MACHINE: waveamdmachine.v_mul_lo_u32
// MACHINE: waveamdmachine.buffer_load_lds_b128
func.func @wrapped_layout_offset_uses_i32(
    %in: !wave.ptr<#wave.global, i32>, %base: i32, %stride: i32,
    %limit: i32) attributes {wave.kernel, wave.lds_size = 128 : i64} {
  %range = arith.constant 2147483647 : i32
  %buffer = waveamd.make_buffer %in, %range
      : !wave.ptr<#wave.global, i32>, i32
      -> !wave.ptr<#waveamd.buffer, i32>
  %item = wave.lane_id : !wave.simd<i32, 32>
  %offset = wave.index_expr
      <"Mod(2*(base + stride*xor(Mod(floor(1/8*item), 2), 2*Mod(floor(1/16*item), 2), 4*Mod(floor(1/4*item), 2), Mod(item, 4))), 4294967296)">
      assuming [#wave.pred<"item >= 0 & -31 + item <= 0">]
      ["base", "item", "stride"](%base, %item, %stride)
      : (i32, !wave.simd<i32, 32>, i32) -> !wave.simd<index, 32>
  %byte_buffer = wave.ptr_cast %buffer
      : !wave.ptr<#waveamd.buffer, i32> -> !wave.ptr<#waveamd.buffer, i8>
  %bytes = wave.ptr_add %byte_buffer, %offset
      : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 32>
      -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 32>
  %source = wave.ptr_cast %bytes
      : !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 32>
      -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>
  %vlimit = wave.splat %limit : i32 -> !wave.simd<i32, 32>
  %active = wave.cmpi ult %item, %vlimit
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %lds = wave.shared_memory_base : !wave.ptr<#wave.shared, i32>
  %dependency = wave.token : !wave.mem.token
  %token = wave.where %active {
    %loaded = waveamd.dma_load_lds %source -> %lds after %dependency
        {bytes = 16 : i64, zero_fill_inactive}
        : (!wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>,
           !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
    wave.yield %loaded : !wave.mem.token
  } : !wave.mask<32> -> !wave.mem.token
  %complete = wave.barrier %token : (!wave.mem.token) -> !wave.mem.token
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// Address-field selection precedes zero-fill pointer selection.  The active
// scalar field remains an instruction soffset; only the lane field is selected
// against the rebased OOB address.
// CHECK-LABEL: func.func @selected_buffer_preserves_soffset
// CHECK: wave.select
// MACHINE-LABEL: func.func @selected_buffer_preserves_soffset
// MACHINE: %[[SELECTED:.*]] = waveamdmachine.v_cndmask_b32_tuple {{.*}} : (!waveamdmachine.reg<vgpr, 1>,
// MACHINE: waveamdmachine.buffer_load_lds_b128 %[[SELECTED]], {{[^:]+}} : (!waveamdmachine.reg<vgpr, 1>, !waveamdmachine.reg<sgpr, 4>, !waveamdmachine.reg<sgpr, 1>,
func.func @selected_buffer_preserves_soffset(
    %in: !wave.ptr<#wave.global, i32>, %base: i32, %limit: i32)
    attributes {wave.kernel, wave.lds_size = 128 : i64} {
  %range = arith.constant 2147483647 : i32
  %buffer = waveamd.make_buffer %in, %range
      : !wave.ptr<#wave.global, i32>, i32 -> !wave.ptr<#waveamd.buffer, i32>
  %item = wave.lane_id : !wave.simd<i32, 32>
  %offset = wave.index_expr
      <"Mod(2*base, 1073741824) + Mod(item, 1073741824)">
      assuming [#wave.pred<"item >= 0 & -31 + item <= 0">]
      ["base", "item"](%base, %item)
      : (i32, !wave.simd<i32, 32>) -> !wave.simd<index, 32>
  %source = wave.ptr_add %buffer, %offset
      : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<index, 32>
      -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>
  %vlimit = wave.splat %limit : i32 -> !wave.simd<i32, 32>
  %active = wave.cmpi ult %item, %vlimit
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %lds = wave.shared_memory_base : !wave.ptr<#wave.shared, i32>
  %dependency = wave.token : !wave.mem.token
  %token = wave.where %active {
    %loaded = waveamd.dma_load_lds %source -> %lds after %dependency
        {bytes = 16 : i64, zero_fill_inactive}
        : (!wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>,
           !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
    wave.yield %loaded : !wave.mem.token
  } : !wave.mask<32> -> !wave.mem.token
  %complete = wave.barrier %token : (!wave.mem.token) -> !wave.mem.token
  return
}

}
