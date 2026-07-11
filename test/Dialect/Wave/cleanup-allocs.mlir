// RUN: wave-opt --split-input-file --wave-cleanup-allocs %s | FileCheck %s

// CHECK-LABEL: func.func @drop_unread_store_dummy_token
// CHECK-NOT: wave.store
func.func @drop_unread_store_dummy_token() -> !wave.mem.token
    attributes {wave.kernel} {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %alloc = wave.alloc() {align = 16 : i64, bytesize = 128 : i64}
      : !wave.ptr<#wave.shared, i32>
  %ptr = wave.ptr_add %alloc, %lane
      : !wave.ptr<#wave.shared, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.shared, i32>, 32>
  // CHECK: [[TOK:%.*]] = wave.token : !wave.mem.token
  %tok = wave.store %lane -> %ptr
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.shared, i32>, 32>)
      -> !wave.mem.token
  // CHECK: return [[TOK]] : !wave.mem.token
  return %tok : !wave.mem.token
}

// -----

// CHECK-LABEL: func.func @drop_unread_store_keep_dependency
// CHECK-NOT: wave.store
func.func @drop_unread_store_keep_dependency() -> !wave.mem.token
    attributes {wave.kernel} {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  // CHECK: [[ROOT:%.*]] = wave.token
  %root = wave.token : !wave.mem.token
  %alloc = wave.alloc() {align = 16 : i64, bytesize = 128 : i64}
      : !wave.ptr<#wave.shared, i32>
  %ptr = wave.ptr_add %alloc, %lane
      : !wave.ptr<#wave.shared, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.shared, i32>, 32>
  %tok = wave.store %lane -> %ptr after %root
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.shared, i32>, 32>,
         !wave.mem.token)
      -> !wave.mem.token
  // CHECK: return [[ROOT]] : !wave.mem.token
  return %tok : !wave.mem.token
}

// -----

// CHECK-LABEL: func.func @keep_read_through_view
// CHECK: wave.store
// CHECK: wave.load
// CHECK: wave.alloc_release
func.func @keep_read_through_view() attributes {wave.kernel} {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %alloc = wave.alloc() {align = 16 : i64, bytesize = 128 : i64}
      : !wave.ptr<#wave.shared, i32>
  %ptr = wave.ptr_add %alloc, %lane
      : !wave.ptr<#wave.shared, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.shared, i32>, 32>
  %tok = wave.store %lane -> %ptr
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.shared, i32>, 32>)
      -> !wave.mem.token
  %value:2 = wave.load %ptr after %tok
      : (!wave.simd<!wave.ptr<#wave.shared, i32>, 32>, !wave.mem.token)
      -> (!wave.simd<i32, 32>, !wave.mem.token)
  %released = wave.alloc_release %alloc after %value#1
      : (!wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
  return
}

// -----

// CHECK-LABEL: func.func @keep_write_through_select_with_live_alloc
// CHECK: wave.store
// CHECK: wave.load
func.func @keep_write_through_select_with_live_alloc(%cond: i1)
    attributes {wave.kernel} {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %dead = wave.alloc() {align = 16 : i64, bytesize = 128 : i64}
      : !wave.ptr<#wave.shared, i32>
  %live = wave.alloc() {align = 16 : i64, bytesize = 128 : i64}
      : !wave.ptr<#wave.shared, i32>
  %dead_ptr = wave.ptr_add %dead, %lane
      : !wave.ptr<#wave.shared, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.shared, i32>, 32>
  %live_ptr = wave.ptr_add %live, %lane
      : !wave.ptr<#wave.shared, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.shared, i32>, 32>
  %selected = wave.select %cond, %dead_ptr, %live_ptr
      : !wave.simd<!wave.ptr<#wave.shared, i32>, 32>
  %tok = wave.store %lane -> %selected
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.shared, i32>, 32>)
      -> !wave.mem.token
  %value:2 = wave.load %live_ptr after %tok
      : (!wave.simd<!wave.ptr<#wave.shared, i32>, 32>, !wave.mem.token)
      -> (!wave.simd<i32, 32>, !wave.mem.token)
  return
}

// -----

// CHECK-LABEL: func.func @unknown_pointer_use_blocks
// CHECK: wave.store
func.func @unknown_pointer_use_blocks()
    -> !wave.ptr<#wave.shared, i32> attributes {wave.kernel} {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %alloc = wave.alloc() {align = 16 : i64, bytesize = 128 : i64}
      : !wave.ptr<#wave.shared, i32>
  %ptr = wave.ptr_add %alloc, %lane
      : !wave.ptr<#wave.shared, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.shared, i32>, 32>
  %tok = wave.store %lane -> %ptr
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.shared, i32>, 32>)
      -> !wave.mem.token
  return %alloc : !wave.ptr<#wave.shared, i32>
}

// -----

// CHECK-LABEL: func.func @keep_write_through_scf_if_with_live_alloc
// CHECK: wave.store
// CHECK: wave.load
func.func @keep_write_through_scf_if_with_live_alloc(%cond: i1)
    attributes {wave.kernel} {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %dead = wave.alloc() {align = 16 : i64, bytesize = 128 : i64}
      : !wave.ptr<#wave.shared, i32>
  %live = wave.alloc() {align = 16 : i64, bytesize = 128 : i64}
      : !wave.ptr<#wave.shared, i32>
  %selected = scf.if %cond -> (!wave.ptr<#wave.shared, i32>) {
    scf.yield %dead : !wave.ptr<#wave.shared, i32>
  } else {
    scf.yield %live : !wave.ptr<#wave.shared, i32>
  }
  %selected_ptr = wave.ptr_add %selected, %lane
      : !wave.ptr<#wave.shared, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.shared, i32>, 32>
  %tok = wave.store %lane -> %selected_ptr
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.shared, i32>, 32>)
      -> !wave.mem.token
  %live_ptr = wave.ptr_add %live, %lane
      : !wave.ptr<#wave.shared, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.shared, i32>, 32>
  %value:2 = wave.load %live_ptr after %tok
      : (!wave.simd<!wave.ptr<#wave.shared, i32>, 32>, !wave.mem.token)
      -> (!wave.simd<i32, 32>, !wave.mem.token)
  return
}

// -----

// CHECK-LABEL: func.func @drop_write_through_scf_for_result
// CHECK-NOT: wave.store
func.func @drop_write_through_scf_for_result() -> !wave.mem.token
    attributes {wave.kernel} {
  %c0 = arith.constant 0 : index
  %c1 = arith.constant 1 : index
  %c4 = arith.constant 4 : index
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %alloc = wave.alloc() {align = 16 : i64, bytesize = 128 : i64}
      : !wave.ptr<#wave.shared, i32>
  %carried = scf.for %i = %c0 to %c4 step %c1 iter_args(%ptr = %alloc)
      -> (!wave.ptr<#wave.shared, i32>) {
    scf.yield %ptr : !wave.ptr<#wave.shared, i32>
  }
  %view = wave.ptr_add %carried, %lane
      : !wave.ptr<#wave.shared, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.shared, i32>, 32>
  // CHECK: [[TOK:%.*]] = wave.token : !wave.mem.token
  %tok = wave.store %lane -> %view
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.shared, i32>, 32>)
      -> !wave.mem.token
  // CHECK: return [[TOK]] : !wave.mem.token
  return %tok : !wave.mem.token
}

// -----

// CHECK-LABEL: func.func @drop_write_through_scf_if_result
// CHECK-NOT: wave.store
func.func @drop_write_through_scf_if_result(%cond: i1) -> !wave.mem.token
    attributes {wave.kernel} {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %alloc = wave.alloc() {align = 16 : i64, bytesize = 128 : i64}
      : !wave.ptr<#wave.shared, i32>
  %selected = scf.if %cond -> (!wave.ptr<#wave.shared, i32>) {
    scf.yield %alloc : !wave.ptr<#wave.shared, i32>
  } else {
    scf.yield %alloc : !wave.ptr<#wave.shared, i32>
  }
  %view = wave.ptr_add %selected, %lane
      : !wave.ptr<#wave.shared, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.shared, i32>, 32>
  // CHECK: [[TOK:%.*]] = wave.token : !wave.mem.token
  %tok = wave.store %lane -> %view
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.shared, i32>, 32>)
      -> !wave.mem.token
  // CHECK: return [[TOK]] : !wave.mem.token
  return %tok : !wave.mem.token
}

// -----

// CHECK-LABEL: func.func @drop_dma_dest_write
// CHECK-NOT: waveamd.dma_load_lds
func.func @drop_dma_dest_write(%src: !wave.ptr<#wave.global, i32>)
    -> !wave.mem.token attributes {wave.kernel} {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %srcs = wave.ptr_add %src, %lane
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  // CHECK: [[ROOT:%.*]] = wave.token
  %root = wave.token : !wave.mem.token
  %alloc = wave.alloc() {align = 16 : i64, bytesize = 128 : i64}
      : !wave.ptr<#wave.shared, i32>
  %tok = waveamd.dma_load_lds %srcs -> %alloc after %root
      {bytes = 4 : i64} : (!wave.simd<!wave.ptr<#wave.global, i32>, 32>,
      !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
  // CHECK: return [[ROOT]] : !wave.mem.token
  return %tok : !wave.mem.token
}

// -----

// CHECK-LABEL: func.func @keep_transpose_read
// CHECK: wave.store
// CHECK: waveamd.transpose_load
func.func @keep_transpose_read() attributes {wave.kernel} {
  %lane = wave.lane_id : !wave.simd<i32, 64>
  %alloc = wave.alloc() {align = 16 : i64, bytesize = 512 : i64}
      : !wave.ptr<#wave.shared, i8>
  %ptr = wave.ptr_add %alloc, %lane
      : !wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>
      -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
  %tok = wave.store %lane -> %ptr
      : (!wave.simd<i32, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>)
      -> !wave.mem.token
  %value:2 = waveamd.transpose_load %alloc after %tok
      : (!wave.ptr<#wave.shared, i8>, !wave.mem.token)
      -> (!wave.simd<vector<8xi8>, 64>, !wave.mem.token)
  return
}
