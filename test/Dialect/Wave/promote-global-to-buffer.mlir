// RUN: wave-opt --split-input-file --wave-promote-global-to-buffer %s | FileCheck %s
// RUN: wave-opt --split-input-file --wave-promote-global-to-buffer --waveamd-to-machine %s | FileCheck %s --check-prefix=MACHINE

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// CHECK-LABEL: func.func @promote_load_store
// CHECK-SAME: ([[IN:%[^:]+]]: !wave.ptr<#wave.global, i32>
// CHECK-SAME: [[OUT:%[^:]+]]: !wave.ptr<#wave.global, i32>
// CHECK-DAG: arith.constant -2147483648 : i32
// CHECK-DAG: [[IN_BUF:%.*]] = waveamd.make_buffer [[IN]], {{%.*}} : !wave.ptr<#wave.global, i32>, i32 -> !wave.ptr<#waveamd.buffer, i32>
// CHECK-DAG: [[OUT_BUF:%.*]] = waveamd.make_buffer [[OUT]], {{%.*}} : !wave.ptr<#wave.global, i32>, i32 -> !wave.ptr<#waveamd.buffer, i32>
// CHECK: [[LANE:%.*]] = wave.lane_id : !wave.simd<i32, 32>
// CHECK: [[IN_PTR:%.*]] = wave.ptr_add [[IN_BUF]], [[LANE]] : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<i32, 32> -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>
// CHECK: [[V:%.*]], [[TOK:%.*]] = wave.load [[IN_PTR]]
// CHECK: [[OUT_PTR:%.*]] = wave.ptr_add [[OUT_BUF]], [[LANE]] : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<i32, 32> -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>
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
  %in_ptr = wave.ptr_add %in, %lane
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %out_ptr = wave.ptr_add %out, %lane
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32>
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
  %offset = wave.assume %raw as "x"
      [#wave.pred<"x >= 2147483632">,
       #wave.pred<"x <= 2147483632">] : !wave.simd<index, 32>
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
// CHECK: wave.ptr_add [[BUF]], {{%.*}} : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<i32, 32> -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>
// MACHINE-LABEL: func.func @promote_uniform_pointer_base
// MACHINE: waveamdmachine.make_buffer_rsrc
// MACHINE: waveamdmachine.buffer_load_b32
func.func @promote_uniform_pointer_base(%in: !wave.ptr<#wave.global, i32>,
                                        %raw: i32)
    attributes {wave.kernel} {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %base = wave.ptr_add %in, %raw
      : !wave.ptr<#wave.global, i32>, i32 -> !wave.ptr<#wave.global, i32>
  %ptr = wave.ptr_add %base, %lane
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32>
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
// CHECK: wave.ptr_add [[BUF]], {{%.*}} : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<i32, 32> -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>
// MACHINE-LABEL: func.func @promote_assumed_splat_offset
// MACHINE: waveamdmachine.buffer_store_b32
func.func @promote_assumed_splat_offset(
    %out: !wave.ptr<#wave.global, i32>,
    %raw: i32) attributes {wave.kernel} {
  %u = wave.assume %raw as "x" [#wave.pred<"x >= 0">, #wave.pred<"x <= 1023">] : i32
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %idx = wave.splat %u : i32 -> !wave.simd<i32, 32>
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

// CHECK-LABEL: func.func @promote_dma_load_lds
// CHECK: [[BUF:%.*]] = waveamd.make_buffer
// CHECK: [[SRC:%.*]] = wave.ptr_add [[BUF]], {{%.*}} : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<i32, 32> -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>
// CHECK: waveamd.dma_load_lds [[SRC]]
// MACHINE-LABEL: func.func @promote_dma_load_lds
// MACHINE: waveamdmachine.buffer_load_lds_b32
func.func @promote_dma_load_lds(
    %in: !wave.ptr<#wave.global, i32>)
    attributes {wave.kernel, waveamdmachine.lds_size = 128 : i64} {
  %tok0 = wave.token : !wave.mem.token
  %lds = wave.shared_memory_base : !wave.ptr<#wave.shared, i32>
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %src = wave.ptr_add %in, %lane
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32>
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
// MACHINE-LABEL: func.func @promote_index_expr_offset
// MACHINE: waveamdmachine.buffer_store_b32
func.func @promote_index_expr_offset(
    %out: !wave.ptr<#wave.global, i32>,
    %u_raw: i32) attributes {wave.kernel} {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %u = wave.assume %u_raw as "x" [#wave.pred<"x >= 0">, #wave.pred<"x <= 1023">] : i32
  %off = wave.index_expr <"lid + 16*u"> ["lid", "u"](%lane, %u)
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

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// CHECK-LABEL: func.func @skip_i64_index_binding
// CHECK-NOT: waveamd.make_buffer
// CHECK: wave.store {{%.*}} -> {{%.*}} : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.global, i32>, 32>)
// MACHINE-LABEL: func.func @skip_i64_index_binding
// MACHINE-NOT: waveamdmachine.make_buffer_rsrc
// MACHINE: waveamdmachine.global_store_b32 %{{.*}}, %{{.*}}, %{{.*}} :
func.func @skip_i64_index_binding(
    %out: !wave.ptr<#wave.global, i32>,
    %x_raw: i64) attributes {wave.kernel} {
  %x = wave.assume %x_raw as "x" [#wave.pred<"x >= 0">, #wave.pred<"x <= 1023">] : i64
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %off = wave.index_expr <"x + lid"> ["x", "lid"](%x, %lane)
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
