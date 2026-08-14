// RUN: wave-opt --split-input-file --wave-promote-global-to-buffer %s | FileCheck %s
// RUN: wave-opt --split-input-file --wave-promote-global-to-buffer --waveamd-to-machine %s | FileCheck %s --check-prefix=MACHINE
// RUN: wave-opt --split-input-file --wave-generate-index-exprs --wave-promote-global-to-buffer %s | FileCheck %s --check-prefix=COMPOSED
// RUN: wave-opt --split-input-file --wave-promote-global-to-buffer %s | FileCheck %s --check-prefix=DIRECT

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// CHECK-LABEL: func.func @promote_load_store
// CHECK-SAME: ([[IN:%[^:]+]]: !wave.ptr<#wave.global, i32>
// CHECK-SAME: [[OUT:%[^:]+]]: !wave.ptr<#wave.global, i32>
// CHECK-DAG: arith.constant -2147483648 : i32
// CHECK-DAG: [[IN_BUF:%.*]] = waveamd.make_buffer [[IN]], {{%.*}} : !wave.ptr<#wave.global, i32>, i32 -> !wave.ptr<#waveamd.buffer, i32>
// CHECK-DAG: [[OUT_BUF:%.*]] = waveamd.make_buffer [[OUT]], {{%.*}} : !wave.ptr<#wave.global, i32>, i32 -> !wave.ptr<#waveamd.buffer, i32>
// CHECK: [[LANE:%.*]] = wave.lane_id : !wave.simd<i32, 32>
// CHECK: [[LANE_OFFSET:%.*]] = wave.index_expr
// CHECK: [[IN_PTR:%.*]] = wave.ptr_add [[IN_BUF]], [[LANE_OFFSET]] : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<index, 32> -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>
// CHECK: [[V:%.*]], [[TOK:%.*]] = wave.load [[IN_PTR]]
// CHECK: [[OUT_PTR:%.*]] = wave.ptr_add [[OUT_BUF]], [[LANE_OFFSET]] : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<index, 32> -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>
// CHECK: wave.store [[V]] -> [[OUT_PTR]] after [[TOK]]
// MACHINE-LABEL: func.func @promote_load_store
// MACHINE: waveamdmachine.make_buffer_rsrc
// MACHINE: waveamdmachine.buffer_load_b32
// MACHINE: waveamdmachine.buffer_store_b32
func.func @promote_load_store(
    %in: !wave.ptr<#wave.global, i32>,
    %out: !wave.ptr<#wave.global, i32>)
    attributes {wave.kernel} {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %lane_offset = wave.index_expr <"lane">
      assuming [#wave.pred<"lane >= 0">, #wave.pred<"lane <= 31">]
      ["lane"](%lane)
      : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
  %in_ptr = wave.ptr_add %in, %lane_offset
      : !wave.ptr<#wave.global, i32>, !wave.simd<index, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %out_ptr = wave.ptr_add %out, %lane_offset
      : !wave.ptr<#wave.global, i32>, !wave.simd<index, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %value, %tok0 = wave.load %in_ptr
      : (!wave.simd<!wave.ptr<#wave.global, i32>, 32>)
      -> (!wave.simd<i32, 32>, !wave.mem.token)
  %tok1 = wave.store %value -> %out_ptr after %tok0
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.global, i32>, 32>,
         !wave.mem.token) -> !wave.mem.token
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// Access ending at signed-i32 max fits the descriptor range.
// CHECK-LABEL: func.func @promote_access_ending_at_signed_i32_max
// CHECK: waveamd.make_buffer
// CHECK: wave.load {{.*}}!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 32>
// MACHINE-LABEL: func.func @promote_access_ending_at_signed_i32_max
// MACHINE: waveamdmachine.buffer_load_tuple_b32
func.func @promote_access_ending_at_signed_i32_max(
    %in: !wave.ptr<#wave.global, i8>,
    %raw: !wave.simd<index, 32>) attributes {wave.kernel} {
  %offset = wave.index_expr <"x">
      assuming [#wave.pred<"x >= 2147483632">,
                #wave.pred<"x <= 2147483632">]
      ["x"](%raw) : (!wave.simd<index, 32>) -> !wave.simd<index, 32>
  %ptr = wave.ptr_add %in, %offset
      : !wave.ptr<#wave.global, i8>, !wave.simd<index, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i8>, 32>
  %value, %token = wave.load %ptr
      : (!wave.simd<!wave.ptr<#wave.global, i8>, 32>)
      -> (!wave.simd<vector<16xi8>, 32>, !wave.mem.token)
  return
}

// Expanded assumptions prove the factored byte offset.
// CHECK-LABEL: func.func @promote_factored_byte_offset
// CHECK: waveamd.make_buffer
// CHECK: wave.load {{.*}}!wave.simd<!wave.ptr<#waveamd.buffer>, 32>
// DIRECT-LABEL: func.func @promote_factored_byte_offset
// DIRECT: waveamd.make_buffer
// DIRECT: wave.load {{.*}}!wave.simd<!wave.ptr<#waveamd.buffer>, 32>
// MACHINE-LABEL: func.func @promote_factored_byte_offset
// MACHINE: waveamdmachine.buffer_load_tuple_b32
func.func @promote_factored_byte_offset(
    %in: !wave.ptr<#wave.global>,
    %wi: !wave.simd<i32, 32>,
    %s: i32,
    %a: i32,
    %b: i32,
    %c: i32) attributes {wave.kernel} {
  %offset = wave.index_expr <"2*(128 + 256*c + 256*s*(4*a + b) + s*Mod(wi, 2))">
      assuming [#wave.pred<"256 + 512*c + 2048*a*s + 512*b*s + 2*s*Mod(wi, 2) >= 0 & -2147483640 + 256 + 512*c + 2048*a*s + 512*b*s + 2*s*Mod(wi, 2) <= 0">]
      ["wi", "s", "a", "b", "c"](%wi, %s, %a, %b, %c)
      : (!wave.simd<i32, 32>, i32, i32, i32, i32)
      -> !wave.simd<index, 32>
  %ptr = wave.ptr_add %in, %offset
      : !wave.ptr<#wave.global>, !wave.simd<index, 32>
      -> !wave.simd<!wave.ptr<#wave.global>, 32>
  %value, %token = wave.load %ptr
      : (!wave.simd<!wave.ptr<#wave.global>, 32>)
      -> (!wave.simd<vector<4xf16>, 32>, !wave.mem.token)
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// CHECK-LABEL: func.func @promote_uniform_pointer_base
// CHECK: [[BASE:%.*]] = wave.ptr_add {{%.*}}, {{%.*}} : !wave.ptr<#wave.global, i32>, i32 -> !wave.ptr<#wave.global, i32>
// CHECK: [[BUF:%.*]] = waveamd.make_buffer [[BASE]], {{%.*}} : !wave.ptr<#wave.global, i32>, i32 -> !wave.ptr<#waveamd.buffer, i32>
// CHECK: wave.ptr_add [[BUF]], {{%.*}} : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<index, 32> -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>
// MACHINE-LABEL: func.func @promote_uniform_pointer_base
// MACHINE: waveamdmachine.make_buffer_rsrc
// MACHINE: waveamdmachine.buffer_load_b32
func.func @promote_uniform_pointer_base(%in: !wave.ptr<#wave.global, i32>,
                                        %raw: i32)
    attributes {wave.kernel} {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %lane_offset = wave.index_expr <"lane">
      assuming [#wave.pred<"lane >= 0">, #wave.pred<"lane <= 31">]
      ["lane"](%lane)
      : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
  %base = wave.ptr_add %in, %raw
      : !wave.ptr<#wave.global, i32>, i32 -> !wave.ptr<#wave.global, i32>
  %ptr = wave.ptr_add %base, %lane_offset
      : !wave.ptr<#wave.global, i32>, !wave.simd<index, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %value, %tok = wave.load %ptr
      : (!wave.simd<!wave.ptr<#wave.global, i32>, 32>)
      -> (!wave.simd<i32, 32>, !wave.mem.token)
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// A uniform IndexExpr is target-materializable descriptor-base arithmetic;
// its unbounded range is not part of the vector buffer-offset proof.
// CHECK-LABEL: func.func @promote_uniform_index_expr_pointer_base
// CHECK: [[BASE_OFFSET:%.*]] = wave.index_expr
// CHECK: [[BASE:%.*]] = wave.ptr_add {{%.*}}, [[BASE_OFFSET]] : !wave.ptr<#wave.global, i32>, index -> !wave.ptr<#wave.global, i32>
// CHECK: [[BUF:%.*]] = waveamd.make_buffer [[BASE]], {{%.*}} : !wave.ptr<#wave.global, i32>, i32 -> !wave.ptr<#waveamd.buffer, i32>
// CHECK: wave.ptr_add [[BUF]], {{%.*}} : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<index, 32> -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>
// MACHINE-LABEL: func.func @promote_uniform_index_expr_pointer_base
// MACHINE: waveamdmachine.make_buffer_rsrc
// MACHINE: waveamdmachine.buffer_load_b32
func.func @promote_uniform_index_expr_pointer_base(
    %in: !wave.ptr<#wave.global, i32>, %raw: i32)
    attributes {wave.kernel} {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %base_offset = wave.index_expr <"x"> ["x"](%raw) : (i32) -> index
  %lane_offset = wave.index_expr <"lane">
      assuming [#wave.pred<"lane >= 0">, #wave.pred<"lane <= 31">]
      ["lane"](%lane)
      : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
  %base = wave.ptr_add %in, %base_offset
      : !wave.ptr<#wave.global, i32>, index -> !wave.ptr<#wave.global, i32>
  %ptr = wave.ptr_add %base, %lane_offset
      : !wave.ptr<#wave.global, i32>, !wave.simd<index, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %value, %tok = wave.load %ptr
      : (!wave.simd<!wave.ptr<#wave.global, i32>, 32>)
      -> (!wave.simd<i32, 32>, !wave.mem.token)
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// CHECK-LABEL: func.func @skip_unbounded_lane_offset
// CHECK-NOT: waveamd.make_buffer
// CHECK: wave.store {{%.*}} -> {{%.*}} : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.global, i32>, 32>)
// MACHINE-LABEL: func.func @skip_unbounded_lane_offset
// MACHINE-NOT: waveamdmachine.make_buffer_rsrc
// MACHINE: waveamdmachine.global_store_b32_addr64
func.func @skip_unbounded_lane_offset(
    %out: !wave.ptr<#wave.global, i32>,
    %raw: i32) attributes {wave.kernel} {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %idx = wave.splat %raw : i32 -> !wave.simd<i32, 32>
  %ptr = wave.ptr_add %out, %idx
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %tok = wave.store %lane -> %ptr
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.global, i32>, 32>)
      -> !wave.mem.token
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// CHECK-LABEL: func.func @promote_assumed_splat_offset
// CHECK: [[BUF:%.*]] = waveamd.make_buffer
// CHECK: wave.ptr_add [[BUF]], {{%.*}} : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<index, 32> -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>
// MACHINE-LABEL: func.func @promote_assumed_splat_offset
// MACHINE: waveamdmachine.buffer_store_b32
func.func @promote_assumed_splat_offset(
    %out: !wave.ptr<#wave.global, i32>,
    %raw: i32) attributes {wave.kernel} {
  %u = wave.assume %raw as "x" [#wave.pred<"x >= 0">, #wave.pred<"x <= 1023">] : i32
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %scalar_offset = wave.index_expr <"x">
      assuming [#wave.pred<"x >= 0">, #wave.pred<"x <= 1023">]
      ["x"](%u) : (i32) -> index
  %offset = wave.splat %scalar_offset : index -> !wave.simd<index, 32>
  %ptr = wave.ptr_add %out, %offset
      : !wave.ptr<#wave.global, i32>, !wave.simd<index, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %tok = wave.store %lane -> %ptr
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.global, i32>, 32>)
      -> !wave.mem.token
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// Literal SIMD offsets are closed without a symbolic packet.
// CHECK-LABEL: func.func @promote_simd_constant_offset
// CHECK: [[BUF:%.*]] = waveamd.make_buffer
// CHECK: wave.ptr_add [[BUF]], {{%.*}} : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<i32, 32> -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>
// MACHINE-LABEL: func.func @promote_simd_constant_offset
// MACHINE: waveamdmachine.buffer_store_b32
func.func @promote_simd_constant_offset(
    %out: !wave.ptr<#wave.global, i32>) attributes {wave.kernel} {
  %zero = wave.constant 0 : i32 -> !wave.simd<i32, 32>
  %ptr = wave.ptr_add %out, %zero
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %tok = wave.store %zero -> %ptr
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.global, i32>, 32>)
      -> !wave.mem.token
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// CHECK-LABEL: func.func @promote_dma_load_lds
// CHECK: [[BUF:%.*]] = waveamd.make_buffer
// CHECK: [[SRC:%.*]] = wave.ptr_add [[BUF]], {{%.*}} : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<index, 32> -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>
// CHECK: waveamd.dma_load_lds [[SRC]]
// MACHINE-LABEL: func.func @promote_dma_load_lds
// MACHINE: waveamdmachine.buffer_load_lds_b32
func.func @promote_dma_load_lds(
    %in: !wave.ptr<#wave.global, i32>)
    attributes {wave.kernel, waveamdmachine.lds_size = 128 : i64} {
  %tok0 = wave.token : !wave.mem.token
  %lds = wave.shared_memory_base : !wave.ptr<#wave.shared, i32>
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %lane_offset = wave.index_expr <"lane">
      assuming [#wave.pred<"lane >= 0">, #wave.pred<"lane <= 31">]
      ["lane"](%lane)
      : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
  %src = wave.ptr_add %in, %lane_offset
      : !wave.ptr<#wave.global, i32>, !wave.simd<index, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %tok1 = waveamd.dma_load_lds %src -> %lds after %tok0 {bytes = 4 : i64}
      : (!wave.simd<!wave.ptr<#wave.global, i32>, 32>,
         !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// CHECK-LABEL: func.func @promote_index_expr_offset
// CHECK: waveamd.make_buffer
// CHECK: wave.ptr_add {{%.*}}, {{%.*}} : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<index, 32> -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>
// DIRECT-LABEL: func.func @promote_index_expr_offset
// DIRECT: waveamd.make_buffer
// DIRECT: wave.ptr_add {{%.*}}, {{%.*}} : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<index, 32> -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>
// MACHINE-LABEL: func.func @promote_index_expr_offset
// MACHINE: waveamdmachine.buffer_store_b32
func.func @promote_index_expr_offset(
    %out: !wave.ptr<#wave.global, i32>,
    %u_raw: i32) attributes {wave.kernel} {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %u = wave.assume %u_raw as "x" [#wave.pred<"x >= 0">, #wave.pred<"x <= 1023">] : i32
  %off = wave.index_expr <"lid + 16*u">
      assuming [#wave.pred<"lid >= 0">, #wave.pred<"lid <= 31">,
                #wave.pred<"u >= 0">, #wave.pred<"u <= 1023">]
      ["lid", "u"](%lane, %u)
      : (!wave.simd<i32, 32>, i32) -> !wave.simd<index, 32>
  %ptr = wave.ptr_add %out, %off
      : !wave.ptr<#wave.global, i32>, !wave.simd<index, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %tok = wave.store %lane -> %ptr
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.global, i32>, 32>)
      -> !wave.mem.token
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// Promotion owns the range proof for a raw pointer offset and serializes that
// exact packet for instruction selection.
// DIRECT-LABEL: func.func @promote_raw_assume_offset
// DIRECT: [[BUFFER:%.*]] = waveamd.make_buffer
// DIRECT: [[PACKET:%.*]] = wave.index_expr
// DIRECT: [[OFFSET:%.*]] = wave.splat [[PACKET]]
// DIRECT: wave.ptr_add [[BUFFER]], [[OFFSET]] : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<index, 32>
// MACHINE-LABEL: func.func @promote_raw_assume_offset
// MACHINE: waveamdmachine.buffer_store_b32
func.func @promote_raw_assume_offset(
    %out: !wave.ptr<#wave.global, i32>,
    %raw: i32) attributes {wave.kernel} {
  %bounded = wave.assume %raw as "x"
      [#wave.pred<"x >= 0">, #wave.pred<"x <= 1023">] : i32
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %offset = wave.splat %bounded : i32 -> !wave.simd<i32, 32>
  %ptr = wave.ptr_add %out, %offset
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %token = wave.store %lane -> %ptr
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.global, i32>, 32>)
      -> !wave.mem.token
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// Promotion's local analysis composes facts through a nested IndexExpr without
// making GenerateIndexExprs own that analysis.
// DIRECT-LABEL: func.func @nested_packet_fact_is_query_local
// DIRECT: waveamd.make_buffer
// DIRECT: wave.ptr_add {{%.*}}, {{%.*}} : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<index, 32>
// COMPOSED-LABEL: func.func @nested_packet_fact_is_query_local
// COMPOSED: waveamd.make_buffer
// COMPOSED: wave.ptr_add {{%.*}}, {{%.*}} : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<index, 32>
func.func @nested_packet_fact_is_query_local(
    %out: !wave.ptr<#wave.global, i32>,
    %raw: !wave.simd<i32, 32>,
    %value: !wave.simd<i32, 32>) attributes {wave.kernel} {
  %inner = wave.index_expr <"x">
      assuming [#wave.pred<"x >= 0">, #wave.pred<"x <= 1023">]
      ["x"](%raw)
      : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
  %outer = wave.index_expr <"y"> ["y"](%inner)
      : (!wave.simd<index, 32>) -> !wave.simd<index, 32>
  %ptr = wave.ptr_add %out, %outer
      : !wave.ptr<#wave.global, i32>, !wave.simd<index, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %token = wave.store %value -> %ptr
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.global, i32>, 32>)
      -> !wave.mem.token
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// The packet's final byte range, not the storage width of one leaf, decides
// whether the access fits the buffer descriptor.
// CHECK-LABEL: func.func @promote_bounded_i64_index_binding
// CHECK: waveamd.make_buffer
// CHECK: wave.store {{%.*}} -> {{%.*}} : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>)
// DIRECT-LABEL: func.func @promote_bounded_i64_index_binding
// DIRECT: waveamd.make_buffer
// MACHINE-LABEL: func.func @promote_bounded_i64_index_binding
// MACHINE: waveamdmachine.buffer_store_b32
func.func @promote_bounded_i64_index_binding(
    %out: !wave.ptr<#wave.global, i32>,
    %x_raw: i64) attributes {wave.kernel} {
  %x = wave.assume %x_raw as "x" [#wave.pred<"x >= 0">, #wave.pred<"x <= 1023">] : i64
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %off = wave.index_expr <"x + lid">
      assuming [#wave.pred<"x >= 0">, #wave.pred<"x <= 1023">,
                #wave.pred<"lid >= 0">, #wave.pred<"lid <= 31">]
      ["x", "lid"](%x, %lane)
      : (i64, !wave.simd<i32, 32>) -> !wave.simd<index, 32>
  %ptr = wave.ptr_add %out, %off
      : !wave.ptr<#wave.global, i32>, !wave.simd<index, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %tok = wave.store %lane -> %ptr
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.global, i32>, 32>)
      -> !wave.mem.token
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// A wide leaf still stays global when the final byte-offset range is outside
// the descriptor window.
// CHECK-LABEL: func.func @skip_out_of_range_i64_index_binding
// CHECK-NOT: waveamd.make_buffer
// CHECK: wave.store {{%.*}} -> {{%.*}} : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.global, i32>, 32>)
// MACHINE-LABEL: func.func @skip_out_of_range_i64_index_binding
// MACHINE-NOT: waveamdmachine.make_buffer_rsrc
// MACHINE: waveamdmachine.global_store_b32
func.func @skip_out_of_range_i64_index_binding(
    %out: !wave.ptr<#wave.global, i32>,
    %x_raw: i64) attributes {wave.kernel} {
  %x = wave.assume %x_raw as "x"
      [#wave.pred<"x >= 536870912">,
       #wave.pred<"x <= 536870912">] : i64
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %off = wave.index_expr <"x + lid">
      assuming [#wave.pred<"x >= 536870912">,
                #wave.pred<"x <= 536870912">,
                #wave.pred<"lid >= 0">, #wave.pred<"lid <= 31">]
      ["x", "lid"](%x, %lane)
      : (i64, !wave.simd<i32, 32>) -> !wave.simd<index, 32>
  %ptr = wave.ptr_add %out, %off
      : !wave.ptr<#wave.global, i32>, !wave.simd<index, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %tok = wave.store %lane -> %ptr
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.global, i32>, 32>)
      -> !wave.mem.token
  return
}

}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// Promotion owns range analysis for values merged through control flow.
// CHECK-LABEL: func.func @promote_scf_if_result
// CHECK: waveamd.make_buffer
// CHECK: wave.store {{.*}}!wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>
// DIRECT-LABEL: func.func @promote_scf_if_result
// DIRECT: waveamd.make_buffer
// DIRECT: wave.store {{.*}}!wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>
// COMPOSED-LABEL: func.func @promote_scf_if_result
// COMPOSED: waveamd.make_buffer
// COMPOSED: wave.store {{.*}}!wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>
// MACHINE-LABEL: func.func @promote_scf_if_result
// MACHINE: waveamdmachine.buffer_store_b32
func.func @promote_scf_if_result(
    %out: !wave.ptr<#wave.global, i32>, %a: i32, %b: i32, %cond: i1)
    attributes {wave.kernel} {
  %a_bounded = wave.assume %a as "x"
      [#wave.pred<"x >= 0">, #wave.pred<"x <= 31">] : i32
  %b_bounded = wave.assume %b as "x"
      [#wave.pred<"x >= 32">, #wave.pred<"x <= 63">] : i32
  %selected = scf.if %cond -> (i32) {
    scf.yield %a_bounded : i32
  } else {
    scf.yield %b_bounded : i32
  }
  %offset = wave.splat %selected : i32 -> !wave.simd<i32, 32>
  %ptr = wave.ptr_add %out, %offset
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %value = wave.lane_id : !wave.simd<i32, 32>
  %token = wave.store %value -> %ptr
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.global, i32>, 32>)
      -> !wave.mem.token
  return
}

}
