// RUN: wave-opt --wave-resolve-allocs --split-input-file %s | FileCheck %s

// CHECK-LABEL: func.func @private_carry_ignores_user_tokens
// CHECK-SAME: wave.lds_size = 16 : i64
// CHECK: [[USER0:%.*]] = wave.token
// CHECK-NEXT: [[USER1:%.*]] = wave.token
// CHECK-NEXT: [[PRIVATE_INIT:%.*]] = wave.token
// CHECK: scf.for {{.*}} iter_args({{.*}}, [[CARRY0:%.*]] = [[USER0]], [[CARRY1:%.*]] = [[USER1]], [[PRIVATE:%.*]] = [[PRIVATE_INIT]])
// CHECK: [[STORED:%.*]] = wave.store {{.*}} after [[PRIVATE]]
// CHECK: [[SAFE:%.*]] = wave.barrier [[STORED]]
// CHECK: scf.yield {{.*}}, [[CARRY0]], [[CARRY1]], [[SAFE]]
func.func @private_carry_ignores_user_tokens(
    %n: index, %source: !wave.simd<i32, 32>) -> !wave.simd<i32, 32>
    attributes {wave.kernel, wave.lds_size = 0 : i64} {
  %c0 = arith.constant 0 : index
  %c1 = arith.constant 1 : index
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %user0 = wave.token : !wave.mem.token
  %user1 = wave.token : !wave.mem.token
  %result:3 = scf.for %i = %c0 to %n step %c1
      iter_args(%value = %source, %carry0 = %user0, %carry1 = %user1)
      -> (!wave.simd<i32, 32>, !wave.mem.token, !wave.mem.token) {
    %alloc = wave.alloc() {align = 16 : i64, bytesize = 16 : i64}
        : !wave.ptr<#wave.shared, i32>
    %ptr = wave.ptr_add %alloc, %lane
        : !wave.ptr<#wave.shared, i32>, !wave.simd<i32, 32>
        -> !wave.simd<!wave.ptr<#wave.shared, i32>, 32>
    %stored = wave.store %value -> %ptr
        : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.shared, i32>, 32>)
        -> !wave.mem.token
    %next = wave.binary addi %value, %lane
        : !wave.simd<i32, 32>, !wave.simd<i32, 32>
        -> !wave.simd<i32, 32>
    %released = wave.alloc_release %alloc after %stored
        value_lifetime(%value -> %next) {workgroup_collective}
        : (!wave.ptr<#wave.shared, i32>, !wave.mem.token,
           !wave.simd<i32, 32>, !wave.simd<i32, 32>) -> !wave.mem.token
    scf.yield %next, %carry0, %carry1
        : !wave.simd<i32, 32>, !wave.mem.token, !wave.mem.token
  }
  return %result#0 : !wave.simd<i32, 32>
}

// -----

// CHECK-LABEL: func.func @private_carry_through_branch
// CHECK-SAME: wave.lds_size = 16 : i64
// CHECK: [[USER_INIT:%.*]] = wave.token
// CHECK-NEXT: [[INIT:%.*]] = wave.token
// CHECK: scf.for {{.*}} iter_args([[VALUE:%.*]] = {{.*}}, [[USER:%.*]] = [[USER_INIT]], [[PRIVATE:%.*]] = [[INIT]])
// CHECK: [[BRANCH:%.*]]:2 = scf.if {{.*}} -> (!wave.simd<i32, 32>, !wave.mem.token)
// CHECK: [[STORED:%.*]] = wave.store [[VALUE]] {{.*}} after [[PRIVATE]]
// CHECK: scf.yield {{.*}}, [[STORED]]
// CHECK: } else {
// CHECK: scf.yield [[VALUE]], [[PRIVATE]]
// CHECK: [[SAFE:%.*]] = wave.barrier [[BRANCH]]#1
// CHECK: scf.yield [[BRANCH]]#0, [[USER]], [[SAFE]]
func.func @private_carry_through_branch(
    %n: index, %condition: i1, %source: !wave.simd<i32, 32>)
    -> !wave.simd<i32, 32>
    attributes {wave.kernel, wave.lds_size = 0 : i64} {
  %c0 = arith.constant 0 : index
  %c1 = arith.constant 1 : index
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %user = wave.token : !wave.mem.token
  %result:2 = scf.for %i = %c0 to %n step %c1
      iter_args(%value = %source, %user_carry = %user)
      -> (!wave.simd<i32, 32>, !wave.mem.token) {
    %selected = scf.if %condition -> (!wave.simd<i32, 32>) {
      %alloc = wave.alloc() {align = 16 : i64, bytesize = 16 : i64}
          : !wave.ptr<#wave.shared, i32>
      %ptr = wave.ptr_add %alloc, %lane
          : !wave.ptr<#wave.shared, i32>, !wave.simd<i32, 32>
          -> !wave.simd<!wave.ptr<#wave.shared, i32>, 32>
      %stored = wave.store %value -> %ptr
          : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.shared, i32>, 32>)
          -> !wave.mem.token
      %next = wave.binary addi %value, %lane
          : !wave.simd<i32, 32>, !wave.simd<i32, 32>
          -> !wave.simd<i32, 32>
      %released = wave.alloc_release %alloc after %stored
          value_lifetime(%value -> %next) {workgroup_collective}
          : (!wave.ptr<#wave.shared, i32>, !wave.mem.token,
             !wave.simd<i32, 32>, !wave.simd<i32, 32>) -> !wave.mem.token
      scf.yield %next : !wave.simd<i32, 32>
    } else {
      scf.yield %value : !wave.simd<i32, 32>
    }
    scf.yield %selected, %user_carry
        : !wave.simd<i32, 32>, !wave.mem.token
  }
  return %result#0 : !wave.simd<i32, 32>
}

// -----

// CHECK-LABEL: func.func @nested_private_carries
// CHECK-SAME: wave.lds_size = 16 : i64
// CHECK: [[OUTER_INIT:%.*]] = wave.token
// CHECK: scf.for {{.*}} iter_args({{.*}}, [[OUTER_PRIVATE:%.*]] = [[OUTER_INIT]])
// CHECK: [[INNER_INIT:%.*]] = wave.token
// CHECK: [[INNER_LOOP:%.*]]:2 = scf.for {{.*}} iter_args({{.*}}, [[INNER_PRIVATE:%.*]] = [[INNER_INIT]])
// CHECK: [[ENTRY:%.*]] = wave.join [[INNER_PRIVATE]], [[OUTER_PRIVATE]]
// CHECK: [[STORED:%.*]] = wave.store {{.*}} after [[ENTRY]]
// CHECK: [[INNER_SAFE:%.*]] = wave.barrier [[STORED]]
// CHECK: scf.yield {{.*}}, [[INNER_SAFE]]
// CHECK: [[OUTER_SAFE:%.*]] = wave.barrier [[INNER_LOOP]]#1
// CHECK: scf.yield [[INNER_LOOP]]#0, [[OUTER_SAFE]]
func.func @nested_private_carries(
    %m: index, %n: index, %source: !wave.simd<i32, 32>)
    -> !wave.simd<i32, 32>
    attributes {wave.kernel, wave.lds_size = 0 : i64} {
  %c0 = arith.constant 0 : index
  %c1 = arith.constant 1 : index
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %outer = scf.for %i = %c0 to %m step %c1 iter_args(%outer_value = %source)
      -> (!wave.simd<i32, 32>) {
    %inner = scf.for %j = %c0 to %n step %c1 iter_args(%value = %outer_value)
        -> (!wave.simd<i32, 32>) {
      %alloc = wave.alloc() {align = 16 : i64, bytesize = 16 : i64}
          : !wave.ptr<#wave.shared, i32>
      %ptr = wave.ptr_add %alloc, %lane
          : !wave.ptr<#wave.shared, i32>, !wave.simd<i32, 32>
          -> !wave.simd<!wave.ptr<#wave.shared, i32>, 32>
      %stored = wave.store %value -> %ptr
          : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.shared, i32>, 32>)
          -> !wave.mem.token
      %next = wave.binary addi %value, %lane
          : !wave.simd<i32, 32>, !wave.simd<i32, 32>
          -> !wave.simd<i32, 32>
      %released = wave.alloc_release %alloc after %stored
          value_lifetime(%value -> %next) {workgroup_collective}
          : (!wave.ptr<#wave.shared, i32>, !wave.mem.token,
             !wave.simd<i32, 32>, !wave.simd<i32, 32>) -> !wave.mem.token
      scf.yield %next : !wave.simd<i32, 32>
    }
    scf.yield %inner : !wave.simd<i32, 32>
  }
  return %outer : !wave.simd<i32, 32>
}

// -----

// CHECK-LABEL: func.func @independent_private_carries
// CHECK-SAME: wave.lds_size = 32 : i64
// CHECK: [[INIT_A:%.*]] = wave.token
// CHECK-NEXT: [[INIT_B:%.*]] = wave.token
// CHECK: scf.for {{.*}} iter_args({{.*}}, [[PRIVATE_A:%.*]] = [[INIT_A]], [[PRIVATE_B:%.*]] = [[INIT_B]])
// CHECK: [[STORED_A:%.*]] = wave.store {{.*}} after [[PRIVATE_A]]
// CHECK: [[PUBLISHED_A:%.*]] = wave.barrier [[STORED_A]]
// CHECK: [[ENTRY_B:%.*]] = wave.join [[PUBLISHED_A]], [[PRIVATE_B]]
// CHECK: [[STORED_B:%.*]] = wave.store {{.*}} after [[ENTRY_B]]
// CHECK: [[PUBLISHED_B:%.*]] = wave.barrier [[STORED_B]]
// CHECK: [[SAFE_A:%.*]] = wave.barrier [[PUBLISHED_A]]
// CHECK-NEXT: [[SAFE_B:%.*]] = wave.barrier [[PUBLISHED_B]]
// CHECK: scf.yield {{.*}}, [[SAFE_A]], [[SAFE_B]]
func.func @independent_private_carries(
    %n: index, %source: !wave.simd<i32, 32>) -> !wave.simd<i32, 32>
    attributes {wave.kernel, wave.lds_size = 0 : i64} {
  %c0 = arith.constant 0 : index
  %c1 = arith.constant 1 : index
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %result = scf.for %i = %c0 to %n step %c1 iter_args(%value = %source)
      -> (!wave.simd<i32, 32>) {
    %a = wave.alloc() {align = 16 : i64, bytesize = 16 : i64}
        : !wave.ptr<#wave.shared, i32>
    %ap = wave.ptr_add %a, %lane
        : !wave.ptr<#wave.shared, i32>, !wave.simd<i32, 32>
        -> !wave.simd<!wave.ptr<#wave.shared, i32>, 32>
    %stored_a = wave.store %value -> %ap
        : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.shared, i32>, 32>)
        -> !wave.mem.token
    %safe_a = wave.barrier %stored_a : (!wave.mem.token) -> !wave.mem.token
    %next_a = wave.binary addi %value, %lane
        : !wave.simd<i32, 32>, !wave.simd<i32, 32>
        -> !wave.simd<i32, 32>
    %released_a = wave.alloc_release %a after %safe_a
        value_lifetime(%value -> %next_a) {workgroup_collective}
        : (!wave.ptr<#wave.shared, i32>, !wave.mem.token,
           !wave.simd<i32, 32>, !wave.simd<i32, 32>) -> !wave.mem.token

    %b = wave.alloc() {align = 16 : i64, bytesize = 16 : i64}
        : !wave.ptr<#wave.shared, i32>
    %bp = wave.ptr_add %b, %lane
        : !wave.ptr<#wave.shared, i32>, !wave.simd<i32, 32>
        -> !wave.simd<!wave.ptr<#wave.shared, i32>, 32>
    %stored_b = wave.store %next_a -> %bp after %released_a
        : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.shared, i32>, 32>,
           !wave.mem.token) -> !wave.mem.token
    %safe_b = wave.barrier %stored_b : (!wave.mem.token) -> !wave.mem.token
    %next_b = wave.binary addi %next_a, %lane
        : !wave.simd<i32, 32>, !wave.simd<i32, 32>
        -> !wave.simd<i32, 32>
    %released_b = wave.alloc_release %b after %safe_b
        value_lifetime(%next_a -> %next_b) {workgroup_collective}
        : (!wave.ptr<#wave.shared, i32>, !wave.mem.token,
           !wave.simd<i32, 32>, !wave.simd<i32, 32>) -> !wave.mem.token
    scf.yield %next_b : !wave.simd<i32, 32>
  }
  return %result : !wave.simd<i32, 32>
}

// -----

// CHECK-LABEL: func.func @shared_range_uses_one_private_carry
// CHECK-SAME: wave.lds_size = 16 : i64
// CHECK: [[INIT:%.*]] = wave.token
// CHECK-NEXT: scf.for
// CHECK-SAME: iter_args([[PRIVATE:%.*]] = [[INIT]])
// CHECK: [[STORED_A:%.*]] = wave.store {{.*}} after [[PRIVATE]]
// CHECK: [[PUBLISHED_A:%.*]] = wave.barrier [[STORED_A]]
// CHECK: [[STORED_B:%.*]] = wave.store {{.*}} after {{.*}}
// CHECK: [[PUBLISHED_B:%.*]] = wave.barrier [[STORED_B]]
// CHECK: [[SAFE:%.*]] = wave.barrier [[PUBLISHED_B]]
// CHECK: scf.yield [[SAFE]]
func.func @shared_range_uses_one_private_carry(
    %n: index, %source: !wave.simd<i32, 32>)
    attributes {wave.kernel, wave.lds_size = 0 : i64} {
  %c0 = arith.constant 0 : index
  %c1 = arith.constant 1 : index
  %lane = wave.lane_id : !wave.simd<i32, 32>
  scf.for %i = %c0 to %n step %c1 {
    %a = wave.alloc() {align = 16 : i64, bytesize = 16 : i64,
                       offset = 0 : i64}
        : !wave.ptr<#wave.shared, i32>
    %ap = wave.ptr_add %a, %lane
        : !wave.ptr<#wave.shared, i32>, !wave.simd<i32, 32>
        -> !wave.simd<!wave.ptr<#wave.shared, i32>, 32>
    %stored_a = wave.store %source -> %ap
        : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.shared, i32>, 32>)
        -> !wave.mem.token
    %published_a = wave.barrier %stored_a
        : (!wave.mem.token) -> !wave.mem.token
    %result_a = wave.binary addi %source, %lane
        : !wave.simd<i32, 32>, !wave.simd<i32, 32>
        -> !wave.simd<i32, 32>
    %released_a = wave.alloc_release %a after %published_a
        value_lifetime(%source -> %result_a) {workgroup_collective}
        : (!wave.ptr<#wave.shared, i32>, !wave.mem.token,
           !wave.simd<i32, 32>, !wave.simd<i32, 32>) -> !wave.mem.token

    %b = wave.alloc() {align = 16 : i64, bytesize = 16 : i64,
                       offset = 0 : i64}
        : !wave.ptr<#wave.shared, i32>
    %bp = wave.ptr_add %b, %lane
        : !wave.ptr<#wave.shared, i32>, !wave.simd<i32, 32>
        -> !wave.simd<!wave.ptr<#wave.shared, i32>, 32>
    %stored_b = wave.store %source -> %bp after %released_a
        : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.shared, i32>, 32>,
           !wave.mem.token) -> !wave.mem.token
    %published_b = wave.barrier %stored_b
        : (!wave.mem.token) -> !wave.mem.token
    %result_b = wave.binary addi %source, %lane
        : !wave.simd<i32, 32>, !wave.simd<i32, 32>
        -> !wave.simd<i32, 32>
    %released_b = wave.alloc_release %b after %published_b
        value_lifetime(%source -> %result_b) {workgroup_collective}
        : (!wave.ptr<#wave.shared, i32>, !wave.mem.token,
           !wave.simd<i32, 32>, !wave.simd<i32, 32>) -> !wave.mem.token
  }
  return
}
