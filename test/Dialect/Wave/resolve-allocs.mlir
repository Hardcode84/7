// RUN: wave-opt --split-input-file --wave-resolve-allocs %s | FileCheck %s

// CHECK-LABEL: func.func @reuse_nonoverlap
// CHECK-SAME: wave.lds_size = 64 : i64
// CHECK-NOT: wave.alloc
func.func @reuse_nonoverlap(%out: !wave.ptr<#wave.global, i32>)
    attributes {wave.kernel} {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  // CHECK: %[[A:.*]] = wave.shared_memory_base : !wave.ptr<#wave.shared, i32>
  %a = wave.alloc() {align = 16 : i64, bytesize = 64 : i64}
      : !wave.ptr<#wave.shared, i32>
  %ap = wave.ptr_add %a, %lane
      : !wave.ptr<#wave.shared, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.shared, i32>, 32>
  %ta = wave.store %lane -> %ap
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.shared, i32>, 32>)
      -> !wave.mem.token
  %released = wave.alloc_release %a after %ta
      : (!wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
  // CHECK: %[[SAFE:.*]] = wave.barrier %[[TA:.*]]
  %safe = wave.barrier %released : (!wave.mem.token) -> !wave.mem.token

  // CHECK: %[[B:.*]] = wave.shared_memory_base : !wave.ptr<#wave.shared, i32>
  %b = wave.alloc() {align = 16 : i64, bytesize = 64 : i64}
      : !wave.ptr<#wave.shared, i32>
  %bp = wave.ptr_add %b, %lane
      : !wave.ptr<#wave.shared, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.shared, i32>, 32>
  %tb = wave.store %lane -> %bp after %safe
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.shared, i32>, 32>,
         !wave.mem.token)
      -> !wave.mem.token
  return
}

// -----

// CHECK-LABEL: func.func @reuse_collectively_completed_release
// CHECK-SAME: wave.lds_size = 64 : i64
// CHECK-NOT: wave.alloc
func.func @reuse_collectively_completed_release()
    attributes {wave.kernel} {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %a = wave.alloc() {align = 16 : i64, bytesize = 64 : i64}
      : !wave.ptr<#wave.shared, i32>
  %ap = wave.ptr_add %a, %lane
      : !wave.ptr<#wave.shared, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.shared, i32>, 32>
  %ta = wave.store %lane -> %ap
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.shared, i32>, 32>)
      -> !wave.mem.token
  %safe = wave.barrier %ta : (!wave.mem.token) -> !wave.mem.token
  %released = wave.alloc_release %a after %safe
      : (!wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token

  // CHECK: wave.shared_memory_base : !wave.ptr<#wave.shared, i32>
  %b = wave.alloc() {align = 16 : i64, bytesize = 64 : i64}
      : !wave.ptr<#wave.shared, i32>
  %bp = wave.ptr_add %b, %lane
      : !wave.ptr<#wave.shared, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.shared, i32>, 32>
  %tb = wave.store %lane -> %bp after %released
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.shared, i32>, 32>,
         !wave.mem.token)
      -> !wave.mem.token
  return
}

// -----

// CHECK-LABEL: func.func @token_order_without_collective_barrier
// CHECK-SAME: wave.lds_size = 128 : i64
// CHECK-NOT: wave.alloc
func.func @token_order_without_collective_barrier()
    attributes {wave.kernel} {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %a = wave.alloc() {align = 16 : i64, bytesize = 64 : i64}
      : !wave.ptr<#wave.shared, i32>
  %ap = wave.ptr_add %a, %lane
      : !wave.ptr<#wave.shared, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.shared, i32>, 32>
  %ta = wave.store %lane -> %ap
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.shared, i32>, 32>)
      -> !wave.mem.token
  %released = wave.alloc_release %a after %ta
      : (!wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token

  // CHECK: wave.shared_memory_base {offset = 64 : i64}
  %b = wave.alloc() {align = 16 : i64, bytesize = 64 : i64}
      : !wave.ptr<#wave.shared, i32>
  %bp = wave.ptr_add %b, %lane
      : !wave.ptr<#wave.shared, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.shared, i32>, 32>
  %tb = wave.store %lane -> %bp after %released
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.shared, i32>, 32>,
         !wave.mem.token)
      -> !wave.mem.token
  return
}

// -----

// CHECK-LABEL: func.func @reuse_unmarked_lexical_lifetimes
// CHECK-SAME: wave.lds_size = 32 : i64
// CHECK-NOT: wave.alloc
func.func @reuse_unmarked_lexical_lifetimes() attributes {wave.kernel} {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  // CHECK: wave.shared_memory_base : !wave.ptr<#wave.shared, i32>
  %a = wave.alloc() {align = 16 : i64, bytesize = 32 : i64}
      : !wave.ptr<#wave.shared, i32>
  %ap = wave.ptr_add %a, %lane
      : !wave.ptr<#wave.shared, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.shared, i32>, 32>
  %ta = wave.store %lane -> %ap
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.shared, i32>, 32>)
      -> !wave.mem.token

  // CHECK: wave.shared_memory_base : !wave.ptr<#wave.shared, i32>
  %b = wave.alloc() {align = 16 : i64, bytesize = 32 : i64}
      : !wave.ptr<#wave.shared, i32>
  %bp = wave.ptr_add %b, %lane
      : !wave.ptr<#wave.shared, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.shared, i32>, 32>
  %tb = wave.store %lane -> %bp
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.shared, i32>, 32>)
      -> !wave.mem.token
  return
}

// -----

// CHECK-LABEL: func.func @missing_release_to_reuse_edge
// CHECK-SAME: wave.lds_size = 128 : i64
// CHECK-NOT: wave.alloc
func.func @missing_release_to_reuse_edge() attributes {wave.kernel} {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %a = wave.alloc() {align = 16 : i64, bytesize = 64 : i64}
      : !wave.ptr<#wave.shared, i32>
  %ap = wave.ptr_add %a, %lane
      : !wave.ptr<#wave.shared, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.shared, i32>, 32>
  %ta = wave.store %lane -> %ap
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.shared, i32>, 32>)
      -> !wave.mem.token
  %released = wave.alloc_release %a after %ta
      : (!wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token

  // CHECK: wave.shared_memory_base {offset = 64 : i64}
  %b = wave.alloc() {align = 16 : i64, bytesize = 64 : i64}
      : !wave.ptr<#wave.shared, i32>
  %bp = wave.ptr_add %b, %lane
      : !wave.ptr<#wave.shared, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.shared, i32>, 32>
  %tb = wave.store %lane -> %bp
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.shared, i32>, 32>)
      -> !wave.mem.token
  return
}

// -----

// CHECK-LABEL: func.func @view_chain_overlap
// CHECK-SAME: wave.lds_size = 128 : i64
// CHECK-NOT: wave.alloc
func.func @view_chain_overlap(%out: !wave.ptr<#wave.global, i32>)
    attributes {wave.kernel} {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  // CHECK: %[[A:.*]] = wave.shared_memory_base : !wave.ptr<#wave.shared, i32>
  %a = wave.alloc() {align = 16 : i64, bytesize = 64 : i64}
      : !wave.ptr<#wave.shared, i32>
  // CHECK: wave.ptr_add %[[A]]
  %ap0 = wave.ptr_add %a, %lane
      : !wave.ptr<#wave.shared, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.shared, i32>, 32>

  // CHECK: %[[B:.*]] = wave.shared_memory_base {offset = 64 : i64} : !wave.ptr<#wave.shared, i32>
  %b = wave.alloc() {align = 16 : i64, bytesize = 64 : i64}
      : !wave.ptr<#wave.shared, i32>
  %bp = wave.ptr_add %b, %lane
      : !wave.ptr<#wave.shared, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.shared, i32>, 32>
  %ap1 = wave.ptr_add %ap0, %lane
      : !wave.simd<!wave.ptr<#wave.shared, i32>, 32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.shared, i32>, 32>
  %ta = wave.store %lane -> %ap1
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.shared, i32>, 32>)
      -> !wave.mem.token
  %tb = wave.store %lane -> %bp after %ta
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.shared, i32>, 32>,
         !wave.mem.token)
      -> !wave.mem.token
  return
}

// -----

// CHECK-LABEL: func.func @mixed_fixed_base_prefix
// CHECK-SAME: wave.lds_size = 160 : i64
// CHECK-NOT: wave.alloc
func.func @mixed_fixed_base_prefix()
    attributes {wave.kernel, wave.lds_size = 128 : i64} {
  // CHECK: wave.shared_memory_base : !wave.ptr<#wave.shared, i8>
  %base = wave.shared_memory_base : !wave.ptr<#wave.shared, i8>
  // CHECK: wave.shared_memory_base {offset = 128 : i64} : !wave.ptr<#wave.shared, i8>
  %a = wave.alloc() {align = 64 : i64, bytesize = 32 : i64}
      : !wave.ptr<#wave.shared, i8>
  return
}

// -----

// CHECK-LABEL: func.func @scf_nested_alloc_overlaps_outer
// CHECK-SAME: wave.lds_size = 64 : i64
// CHECK-NOT: wave.alloc
func.func @scf_nested_alloc_overlaps_outer(%out: !wave.ptr<#wave.global, i32>)
    attributes {wave.kernel} {
  %c0 = arith.constant 0 : index
  %c1 = arith.constant 1 : index
  %c4 = arith.constant 4 : index
  %lane = wave.lane_id : !wave.simd<i32, 32>
  // CHECK: wave.shared_memory_base : !wave.ptr<#wave.shared, i32>
  %outer = wave.alloc() {align = 16 : i64, bytesize = 32 : i64}
      : !wave.ptr<#wave.shared, i32>
  scf.for %i = %c0 to %c4 step %c1 {
    %outer_p = wave.ptr_add %outer, %lane
        : !wave.ptr<#wave.shared, i32>, !wave.simd<i32, 32>
        -> !wave.simd<!wave.ptr<#wave.shared, i32>, 32>
    // CHECK: wave.shared_memory_base {offset = 32 : i64} : !wave.ptr<#wave.shared, i32>
    %inner = wave.alloc() {align = 16 : i64, bytesize = 32 : i64}
        : !wave.ptr<#wave.shared, i32>
    %inner_p = wave.ptr_add %inner, %lane
        : !wave.ptr<#wave.shared, i32>, !wave.simd<i32, 32>
        -> !wave.simd<!wave.ptr<#wave.shared, i32>, 32>
    %t0 = wave.store %lane -> %outer_p
        : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.shared, i32>, 32>)
        -> !wave.mem.token
    %t1 = wave.store %lane -> %inner_p after %t0
        : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.shared, i32>, 32>,
           !wave.mem.token)
        -> !wave.mem.token
  }
  return
}

// -----

// CHECK-LABEL: func.func @scf_if_result_extends_view
// CHECK-SAME: wave.lds_size = 64 : i64
// CHECK-NOT: wave.alloc
func.func @scf_if_result_extends_view(%cond: i1)
    attributes {wave.kernel} {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  // CHECK: %[[A:.*]] = wave.shared_memory_base : !wave.ptr<#wave.shared, i32>
  %a = wave.alloc() {align = 16 : i64, bytesize = 32 : i64}
      : !wave.ptr<#wave.shared, i32>
  %p = scf.if %cond -> (!wave.ptr<#wave.shared, i8>) {
    // CHECK: wave.ptr_cast %[[A]] : !wave.ptr<#wave.shared, i32> -> !wave.ptr<#wave.shared, i8>
    %a8 = wave.ptr_cast %a
        : !wave.ptr<#wave.shared, i32> -> !wave.ptr<#wave.shared, i8>
    scf.yield %a8 : !wave.ptr<#wave.shared, i8>
  } else {
    %a8 = wave.ptr_cast %a
        : !wave.ptr<#wave.shared, i32> -> !wave.ptr<#wave.shared, i8>
    scf.yield %a8 : !wave.ptr<#wave.shared, i8>
  }
  // CHECK: wave.shared_memory_base {offset = 32 : i64} : !wave.ptr<#wave.shared, i8>
  %b = wave.alloc() {align = 16 : i64, bytesize = 32 : i64}
      : !wave.ptr<#wave.shared, i8>
  %bp = wave.ptr_add %b, %lane
      : !wave.ptr<#wave.shared, i8>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.shared, i8>, 32>
  %ap = wave.ptr_add %p, %lane
      : !wave.ptr<#wave.shared, i8>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.shared, i8>, 32>
  return
}

// -----

// CHECK-LABEL: func.func @scf_for_iter_arg_extends_alloc
// CHECK-SAME: wave.lds_size = 64 : i64
// CHECK-NOT: wave.alloc
func.func @scf_for_iter_arg_extends_alloc()
    attributes {wave.kernel} {
  %c0 = arith.constant 0 : index
  %c1 = arith.constant 1 : index
  %c4 = arith.constant 4 : index
  %lane = wave.lane_id : !wave.simd<i32, 32>
  // CHECK: %[[A:.*]] = wave.shared_memory_base : !wave.ptr<#wave.shared, i32>
  %a = wave.alloc() {align = 16 : i64, bytesize = 32 : i64}
      : !wave.ptr<#wave.shared, i32>
  %carried = scf.for %i = %c0 to %c4 step %c1 iter_args(%ptr = %a)
      -> (!wave.ptr<#wave.shared, i32>) {
    // CHECK: wave.shared_memory_base {offset = 32 : i64} : !wave.ptr<#wave.shared, i32>
    %inner = wave.alloc() {align = 16 : i64, bytesize = 32 : i64}
        : !wave.ptr<#wave.shared, i32>
    %inner_p = wave.ptr_add %inner, %lane
        : !wave.ptr<#wave.shared, i32>, !wave.simd<i32, 32>
        -> !wave.simd<!wave.ptr<#wave.shared, i32>, 32>
    scf.yield %ptr : !wave.ptr<#wave.shared, i32>
  }
  // CHECK: wave.shared_memory_base {offset = 32 : i64} : !wave.ptr<#wave.shared, i32>
  %after = wave.alloc() {align = 16 : i64, bytesize = 32 : i64}
      : !wave.ptr<#wave.shared, i32>
  %after_p = wave.ptr_add %after, %lane
      : !wave.ptr<#wave.shared, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.shared, i32>, 32>
  %carried_p = wave.ptr_add %carried, %lane
      : !wave.ptr<#wave.shared, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.shared, i32>, 32>
  return
}

// -----

// CHECK-LABEL: func.func @loop_entry_use_overlaps_later_alloc
// CHECK-SAME: wave.lds_size = 32 : i64
// CHECK-NOT: wave.alloc
func.func @loop_entry_use_overlaps_later_alloc(%n: index)
    attributes {wave.kernel} {
  %c0 = arith.constant 0 : index
  %c1 = arith.constant 1 : index
  %lane = wave.lane_id : !wave.simd<i32, 32>
  // CHECK: wave.shared_memory_base : !wave.ptr<#wave.shared, i32>
  %outer = wave.alloc() {align = 16 : i64, bytesize = 16 : i64}
      : !wave.ptr<#wave.shared, i32>
  scf.for %i = %c0 to %n step %c1 {
    %outer_p = wave.ptr_add %outer, %lane
        : !wave.ptr<#wave.shared, i32>, !wave.simd<i32, 32>
        -> !wave.simd<!wave.ptr<#wave.shared, i32>, 32>
    %t0 = wave.store %lane -> %outer_p
        : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.shared, i32>, 32>)
        -> !wave.mem.token
    // CHECK: wave.shared_memory_base {offset = 16 : i64} : !wave.ptr<#wave.shared, i32>
    %inner = wave.alloc() {align = 16 : i64, bytesize = 16 : i64}
        : !wave.ptr<#wave.shared, i32>
    %inner_p = wave.ptr_add %inner, %lane
        : !wave.ptr<#wave.shared, i32>, !wave.simd<i32, 32>
        -> !wave.simd<!wave.ptr<#wave.shared, i32>, 32>
    %t1 = wave.store %lane -> %inner_p after %t0
        : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.shared, i32>, 32>,
           !wave.mem.token)
        -> !wave.mem.token
  }
  return
}

// -----

// CHECK-LABEL: func.func @same_loop_sequential_allocs
// CHECK-SAME: wave.lds_size = 32 : i64
// CHECK-NOT: wave.alloc
func.func @same_loop_sequential_allocs(%n: index)
    attributes {wave.kernel, wave.lds_size = 0 : i64} {
  %c0 = arith.constant 0 : index
  %c1 = arith.constant 1 : index
  %lane = wave.lane_id : !wave.simd<i32, 32>
  scf.for %i = %c0 to %n step %c1 {
    // CHECK: wave.shared_memory_base : !wave.ptr<#wave.shared, i32>
    %a = wave.alloc() {align = 16 : i64, bytesize = 16 : i64}
        : !wave.ptr<#wave.shared, i32>
    %ap = wave.ptr_add %a, %lane
        : !wave.ptr<#wave.shared, i32>, !wave.simd<i32, 32>
        -> !wave.simd<!wave.ptr<#wave.shared, i32>, 32>
    %ta = wave.store %lane -> %ap
        : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.shared, i32>, 32>)
        -> !wave.mem.token
    %a_released = wave.alloc_release %a after %ta
        : (!wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
    // CHECK: %[[A_SAFE:.*]] = wave.barrier %[[TA:.*]]

    // CHECK: wave.shared_memory_base {offset = 16 : i64} : !wave.ptr<#wave.shared, i32>
    %b = wave.alloc() {align = 16 : i64, bytesize = 16 : i64}
        : !wave.ptr<#wave.shared, i32>
    %bp = wave.ptr_add %b, %lane
        : !wave.ptr<#wave.shared, i32>, !wave.simd<i32, 32>
        -> !wave.simd<!wave.ptr<#wave.shared, i32>, 32>
    %tb = wave.store %lane -> %bp after %a_released
        : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.shared, i32>, 32>,
           !wave.mem.token)
        -> !wave.mem.token
  }
  return
}

// -----

// CHECK-LABEL: func.func @same_loop_reuse_with_backedge
// CHECK-SAME: wave.lds_size = 16 : i64
// CHECK-NOT: wave.alloc
func.func @same_loop_reuse_with_backedge(%n: index)
    attributes {wave.kernel, wave.lds_size = 0 : i64} {
  %c0 = arith.constant 0 : index
  %c1 = arith.constant 1 : index
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %initial = wave.token : !wave.mem.token
  %final = scf.for %i = %c0 to %n step %c1
      iter_args(%ready = %initial) -> (!wave.mem.token) {
    // CHECK: wave.shared_memory_base : !wave.ptr<#wave.shared, i32>
    %a = wave.alloc() {align = 16 : i64, bytesize = 16 : i64}
        : !wave.ptr<#wave.shared, i32>
    %ap = wave.ptr_add %a, %lane
        : !wave.ptr<#wave.shared, i32>, !wave.simd<i32, 32>
        -> !wave.simd<!wave.ptr<#wave.shared, i32>, 32>
    %ta = wave.store %lane -> %ap after %ready
        : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.shared, i32>, 32>,
           !wave.mem.token)
        -> !wave.mem.token
    %a_released = wave.alloc_release %a after %ta
        : (!wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
    // CHECK: %[[A_SAFE:.*]] = wave.barrier %[[TA:.*]]

    // CHECK: wave.shared_memory_base : !wave.ptr<#wave.shared, i32>
    %b = wave.alloc() {align = 16 : i64, bytesize = 16 : i64}
        : !wave.ptr<#wave.shared, i32>
    %bp = wave.ptr_add %b, %lane
        : !wave.ptr<#wave.shared, i32>, !wave.simd<i32, 32>
        -> !wave.simd<!wave.ptr<#wave.shared, i32>, 32>
    %tb = wave.store %lane -> %bp after %a_released
        : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.shared, i32>, 32>,
           !wave.mem.token)
        -> !wave.mem.token
    %b_released = wave.alloc_release %b after %tb
        : (!wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
    // CHECK: %[[B_SAFE:.*]] = wave.barrier %[[TB:.*]]
    scf.yield %b_released : !wave.mem.token
  }
  return
}
