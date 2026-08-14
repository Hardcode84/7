// RUN: wave-opt --wave-resolve-allocs --split-input-file %s | FileCheck %s

// CHECK-LABEL: func.func @private_carry_ignores_user_tokens
// CHECK-SAME: wave.lds_size = 16 : i64
// CHECK: [[USER0:%.*]] = wave.token
// CHECK-NEXT: [[USER1:%.*]] = wave.token
// CHECK-NEXT: [[PRIVATE_INIT:%.*]] = wave.token
// CHECK: scf.for {{.*}} iter_args({{.*}}, [[CARRY0:%.*]] = [[USER0]], [[CARRY1:%.*]] = [[USER1]], [[PRIVATE:%.*]] = [[PRIVATE_INIT]])
// CHECK: [[STORED:%.*]] = wave.store {{.*}} after [[PRIVATE]]
// CHECK: [[PUBLISHED:%.*]] = wave.barrier [[STORED]]
// CHECK: [[LOADED:%.*]], [[READ:%.*]] = wave.load {{.*}} after [[PUBLISHED]]
// CHECK: [[COMPLETE:%.*]] = wave.barrier [[READ]]
// CHECK: [[RETIRED:%.*]] = wave.barrier [[COMPLETE]]
// CHECK: scf.yield [[LOADED]], [[CARRY0]], [[CARRY1]], [[RETIRED]]
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
    %published = wave.barrier %stored : (!wave.mem.token) -> !wave.mem.token
    %loaded, %read = wave.load %ptr after %published
        : (!wave.simd<!wave.ptr<#wave.shared, i32>, 32>, !wave.mem.token)
        -> (!wave.simd<i32, 32>, !wave.mem.token)
    %complete = wave.barrier %read : (!wave.mem.token) -> !wave.mem.token
    %released = wave.alloc_release %alloc after %complete {workgroup_collective}
        : (!wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
    scf.yield %loaded, %carry0, %carry1
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
// CHECK: [[PUBLISHED:%.*]] = wave.barrier [[STORED]]
// CHECK: [[LOADED:%.*]], [[READ:%.*]] = wave.load {{.*}} after [[PUBLISHED]]
// CHECK: [[COMPLETE:%.*]] = wave.barrier [[READ]]
// CHECK: scf.yield [[LOADED]], [[COMPLETE]]
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
      %published = wave.barrier %stored : (!wave.mem.token) -> !wave.mem.token
      %loaded, %read = wave.load %ptr after %published
          : (!wave.simd<!wave.ptr<#wave.shared, i32>, 32>, !wave.mem.token)
          -> (!wave.simd<i32, 32>, !wave.mem.token)
      %complete = wave.barrier %read : (!wave.mem.token) -> !wave.mem.token
      %released = wave.alloc_release %alloc after %complete
          {workgroup_collective}
          : (!wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      scf.yield %loaded : !wave.simd<i32, 32>
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
// CHECK: [[PUBLISHED:%.*]] = wave.barrier [[STORED]]
// CHECK: [[LOADED:%.*]], [[READ:%.*]] = wave.load {{.*}} after [[PUBLISHED]]
// CHECK: [[COMPLETE:%.*]] = wave.barrier [[READ]]
// CHECK: [[INNER_SAFE:%.*]] = wave.barrier [[COMPLETE]]
// CHECK: scf.yield [[LOADED]], [[INNER_SAFE]]
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
      %published = wave.barrier %stored : (!wave.mem.token) -> !wave.mem.token
      %loaded, %read = wave.load %ptr after %published
          : (!wave.simd<!wave.ptr<#wave.shared, i32>, 32>, !wave.mem.token)
          -> (!wave.simd<i32, 32>, !wave.mem.token)
      %complete = wave.barrier %read : (!wave.mem.token) -> !wave.mem.token
      %released = wave.alloc_release %alloc after %complete
          {workgroup_collective}
          : (!wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      scf.yield %loaded : !wave.simd<i32, 32>
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
// CHECK: [[LOADED_A:%.*]], [[READ_A:%.*]] = wave.load {{.*}} after [[PUBLISHED_A]]
// CHECK: [[COMPLETE_A:%.*]] = wave.barrier [[READ_A]]
// CHECK: [[ENTRY_B:%.*]] = wave.join [[COMPLETE_A]], [[PRIVATE_B]]
// CHECK: [[STORED_B:%.*]] = wave.store {{.*}} after [[ENTRY_B]]
// CHECK: [[PUBLISHED_B:%.*]] = wave.barrier [[STORED_B]]
// CHECK: [[LOADED_B:%.*]], [[READ_B:%.*]] = wave.load {{.*}} after [[PUBLISHED_B]]
// CHECK: [[COMPLETE_B:%.*]] = wave.barrier [[READ_B]]
// CHECK: [[SAFE_A:%.*]] = wave.barrier [[COMPLETE_A]]
// CHECK-NEXT: [[SAFE_B:%.*]] = wave.barrier [[COMPLETE_B]]
// CHECK: scf.yield [[LOADED_B]], [[SAFE_A]], [[SAFE_B]]
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
    %loaded_a, %read_a = wave.load %ap after %safe_a
        : (!wave.simd<!wave.ptr<#wave.shared, i32>, 32>, !wave.mem.token)
        -> (!wave.simd<i32, 32>, !wave.mem.token)
    %complete_a = wave.barrier %read_a : (!wave.mem.token) -> !wave.mem.token
    %released_a = wave.alloc_release %a after %complete_a
        {workgroup_collective}
        : (!wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token

    %b = wave.alloc() {align = 16 : i64, bytesize = 16 : i64}
        : !wave.ptr<#wave.shared, i32>
    %bp = wave.ptr_add %b, %lane
        : !wave.ptr<#wave.shared, i32>, !wave.simd<i32, 32>
        -> !wave.simd<!wave.ptr<#wave.shared, i32>, 32>
    %stored_b = wave.store %loaded_a -> %bp after %released_a
        : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.shared, i32>, 32>,
           !wave.mem.token) -> !wave.mem.token
    %safe_b = wave.barrier %stored_b : (!wave.mem.token) -> !wave.mem.token
    %loaded_b, %read_b = wave.load %bp after %safe_b
        : (!wave.simd<!wave.ptr<#wave.shared, i32>, 32>, !wave.mem.token)
        -> (!wave.simd<i32, 32>, !wave.mem.token)
    %complete_b = wave.barrier %read_b : (!wave.mem.token) -> !wave.mem.token
    %released_b = wave.alloc_release %b after %complete_b
        {workgroup_collective}
        : (!wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
    scf.yield %loaded_b : !wave.simd<i32, 32>
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
// CHECK: {{%.*}}, [[READ_A:%.*]] = wave.load {{.*}} after [[PUBLISHED_A]]
// CHECK: [[COMPLETE_A:%.*]] = wave.barrier [[READ_A]]
// CHECK: [[STORED_B:%.*]] = wave.store {{.*}} after [[COMPLETE_A]]
// CHECK: [[PUBLISHED_B:%.*]] = wave.barrier [[STORED_B]]
// CHECK: {{%.*}}, [[READ_B:%.*]] = wave.load {{.*}} after [[PUBLISHED_B]]
// CHECK: [[COMPLETE_B:%.*]] = wave.barrier [[READ_B]]
// CHECK: [[SAFE:%.*]] = wave.barrier [[COMPLETE_B]]
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
    %loaded_a, %read_a = wave.load %ap after %published_a
        : (!wave.simd<!wave.ptr<#wave.shared, i32>, 32>, !wave.mem.token)
        -> (!wave.simd<i32, 32>, !wave.mem.token)
    %complete_a = wave.barrier %read_a : (!wave.mem.token) -> !wave.mem.token
    %released_a = wave.alloc_release %a after %complete_a
        {workgroup_collective}
        : (!wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token

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
    %loaded_b, %read_b = wave.load %bp after %published_b
        : (!wave.simd<!wave.ptr<#wave.shared, i32>, 32>, !wave.mem.token)
        -> (!wave.simd<i32, 32>, !wave.mem.token)
    %complete_b = wave.barrier %read_b : (!wave.mem.token) -> !wave.mem.token
    %released_b = wave.alloc_release %b after %complete_b
        {workgroup_collective}
        : (!wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
  }
  return
}

// -----

// A completed scratch load may keep its register result live without keeping
// the LDS range live. Explicit access completion orders the overwrite.
// CHECK-LABEL: func.func @completed_pack_component_allows_reuse
// CHECK-SAME: wave.lds_size = 16 : i64
// CHECK-COUNT-2: wave.shared_memory_base : !wave.ptr<#wave.shared, i32>
func.func @completed_pack_component_allows_reuse(
    %condition: i1, %source: !wave.simd<i32, 32>) -> !wave.simd<i32, 32>
    attributes {wave.kernel, wave.lds_size = 0 : i64} {
  %lane_a = wave.lane_id : !wave.simd<i32, 32>
  %a = wave.alloc() {align = 16 : i64, bytesize = 16 : i64}
      : !wave.ptr<#wave.shared, i32>
  %ap = wave.ptr_add %a, %lane_a
      : !wave.ptr<#wave.shared, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.shared, i32>, 32>
  %stored_a = wave.store %source -> %ap
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.shared, i32>, 32>)
      -> !wave.mem.token
  %published_a = wave.barrier %stored_a
      : (!wave.mem.token) -> !wave.mem.token
  %component, %read_a = wave.load %ap after %published_a
      : (!wave.simd<!wave.ptr<#wave.shared, i32>, 32>, !wave.mem.token)
      -> (!wave.simd<i32, 32>, !wave.mem.token)
  %complete_a = wave.barrier %read_a : (!wave.mem.token) -> !wave.mem.token
  %other = wave.binary addi %component, %component
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %packed = wave.pack %component, %other
      : !wave.simd<i32, 32>, !wave.simd<i32, 32>
      -> !wave.simd<vector<2xi32>, 32>
  %released_a = wave.alloc_release %a after %complete_a
      {workgroup_collective}
      : (!wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
  %forwarded = scf.if %condition -> (!wave.simd<vector<2xi32>, 32>) {
    scf.yield %packed : !wave.simd<vector<2xi32>, 32>
  } else {
    scf.yield %packed : !wave.simd<vector<2xi32>, 32>
  }
  %forwarded_component = wave.extract %forwarded[0]
      : !wave.simd<vector<2xi32>, 32> -> !wave.simd<i32, 32>
  %lane_b = wave.lane_id : !wave.simd<i32, 32>
  %b = wave.alloc() {align = 16 : i64, bytesize = 16 : i64}
      : !wave.ptr<#wave.shared, i32>
  %bp = wave.ptr_add %b, %lane_b
      : !wave.ptr<#wave.shared, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.shared, i32>, 32>
  %stored_b = wave.store %source -> %bp after %released_a
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.shared, i32>, 32>,
         !wave.mem.token) -> !wave.mem.token
  %used = wave.binary addi %forwarded_component, %lane_b
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  return %used : !wave.simd<i32, 32>
}

// -----

// CHECK-LABEL: func.func @scalar_pack_does_not_acquire_sibling_lifetime
// CHECK-SAME: wave.lds_size = 16 : i64
// CHECK-COUNT-2: wave.shared_memory_base : !wave.ptr<#wave.shared, i32>
func.func @scalar_pack_does_not_acquire_sibling_lifetime(
    %n: index, %source: !wave.simd<i32, 32>) -> !wave.simd<i32, 32>
    attributes {wave.kernel, wave.lds_size = 0 : i64} {
  %lane_a = wave.lane_id : !wave.simd<i32, 32>
  %sibling = wave.binary addi %source, %source
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %a = wave.alloc() {align = 16 : i64, bytesize = 16 : i64}
      : !wave.ptr<#wave.shared, i32>
  %ap = wave.ptr_add %a, %lane_a
      : !wave.ptr<#wave.shared, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.shared, i32>, 32>
  %stored_a = wave.store %source -> %ap
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.shared, i32>, 32>)
      -> !wave.mem.token
  %published_a = wave.barrier %stored_a
      : (!wave.mem.token) -> !wave.mem.token
  %tracked, %read_a = wave.load %ap after %published_a
      : (!wave.simd<!wave.ptr<#wave.shared, i32>, 32>, !wave.mem.token)
      -> (!wave.simd<i32, 32>, !wave.mem.token)
  %complete_a = wave.barrier %read_a : (!wave.mem.token) -> !wave.mem.token
  %mixed = wave.pack %tracked, %sibling
      : !wave.simd<i32, 32>, !wave.simd<i32, 32>
      -> !wave.simd<vector<2xi32>, 32>
  %released_a = wave.alloc_release %a after %complete_a
      {workgroup_collective}
      : (!wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
  %lane_b = wave.lane_id : !wave.simd<i32, 32>
  %b = wave.alloc() {align = 16 : i64, bytesize = 16 : i64}
      : !wave.ptr<#wave.shared, i32>
  %bp = wave.ptr_add %b, %lane_b
      : !wave.ptr<#wave.shared, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.shared, i32>, 32>
  %stored_b = wave.store %source -> %bp after %released_a
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.shared, i32>, 32>,
         !wave.mem.token) -> !wave.mem.token
  %c0 = arith.constant 0 : index
  %c1 = arith.constant 1 : index
  scf.for %i = %c0 to %n step %c1 {
    %late = wave.binary addi %sibling, %lane_b
        : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
    scf.yield
  }
  return %source : !wave.simd<i32, 32>
}

// -----

// CHECK-LABEL: func.func @dead_pack_components_allow_reuse
// CHECK-SAME: wave.lds_size = 16 : i64
// CHECK: wave.shared_memory_base : !wave.ptr<#wave.shared, i32>
// CHECK-NOT: wave.shared_memory_base
// CHECK: [[FIRST:%.*]], {{%.*}} = wave.load
// CHECK: wave.shared_memory_base : !wave.ptr<#wave.shared, i32>
// CHECK-NOT: wave.shared_memory_base
// CHECK: return
func.func @dead_pack_components_allow_reuse(
    %source: !wave.simd<i32, 32>)
    attributes {wave.kernel, wave.lds_size = 0 : i64} {
  %lane_a = wave.lane_id : !wave.simd<i32, 32>
  %a = wave.alloc() {align = 16 : i64, bytesize = 16 : i64}
      : !wave.ptr<#wave.shared, i32>
  %ap = wave.ptr_add %a, %lane_a
      : !wave.ptr<#wave.shared, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.shared, i32>, 32>
  %stored_a = wave.store %source -> %ap
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.shared, i32>, 32>)
      -> !wave.mem.token
  %published_a = wave.barrier %stored_a
      : (!wave.mem.token) -> !wave.mem.token
  %first, %read_a = wave.load %ap after %published_a
      : (!wave.simd<!wave.ptr<#wave.shared, i32>, 32>, !wave.mem.token)
      -> (!wave.simd<i32, 32>, !wave.mem.token)
  %complete_a = wave.barrier %read_a : (!wave.mem.token) -> !wave.mem.token
  %second = wave.binary addi %first, %first
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %packed = wave.pack %first, %second
      : !wave.simd<i32, 32>, !wave.simd<i32, 32>
      -> !wave.simd<vector<2xi32>, 32>
  %released_a = wave.alloc_release %a after %complete_a
      {workgroup_collective}
      : (!wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
  %lane_b = wave.lane_id : !wave.simd<i32, 32>
  %b = wave.alloc() {align = 16 : i64, bytesize = 16 : i64}
      : !wave.ptr<#wave.shared, i32>
  %bp = wave.ptr_add %b, %lane_b
      : !wave.ptr<#wave.shared, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.shared, i32>, 32>
  %stored_b = wave.store %source -> %bp after %released_a
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.shared, i32>, 32>,
         !wave.mem.token) -> !wave.mem.token
  return
}

// -----

// CHECK-LABEL: func.func @prepack_inner_use_does_not_split_private_carry
// CHECK-SAME: wave.lds_size = 16 : i64
// CHECK: [[INIT:%.*]] = wave.token
// CHECK-NOT: wave.token
// CHECK: scf.for {{.*}} iter_args([[PRIVATE:%.*]] = [[INIT]])
// CHECK: [[STORED_A:%.*]] = wave.store {{.*}} after [[PRIVATE]]
// CHECK: [[PUBLISHED_A:%.*]] = wave.barrier [[STORED_A]]
// CHECK: {{%.*}}, [[READ_A:%.*]] = wave.load {{.*}} after [[PUBLISHED_A]]
// CHECK: [[COMPLETE_A:%.*]] = wave.barrier [[READ_A]]
// CHECK: scf.for
// CHECK: [[STORED_B:%.*]] = wave.store {{.*}} after [[COMPLETE_A]]
// CHECK: [[PUBLISHED_B:%.*]] = wave.barrier [[STORED_B]]
// CHECK: {{%.*}}, [[READ_B:%.*]] = wave.load {{.*}} after [[PUBLISHED_B]]
// CHECK: [[COMPLETE_B:%.*]] = wave.barrier [[READ_B]]
// CHECK: [[SAFE:%.*]] = wave.barrier [[COMPLETE_B]]
// CHECK: scf.yield [[SAFE]]
func.func @prepack_inner_use_does_not_split_private_carry(
    %m: index, %n: index, %source: !wave.simd<i32, 32>)
    attributes {wave.kernel, wave.lds_size = 0 : i64} {
  %c0 = arith.constant 0 : index
  %c1 = arith.constant 1 : index
  %lane = wave.lane_id : !wave.simd<i32, 32>
  scf.for %i = %c0 to %m step %c1 {
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
    %component, %read_a = wave.load %ap after %published_a
        : (!wave.simd<!wave.ptr<#wave.shared, i32>, 32>, !wave.mem.token)
        -> (!wave.simd<i32, 32>, !wave.mem.token)
    %complete_a = wave.barrier %read_a
        : (!wave.mem.token) -> !wave.mem.token

    scf.for %j = %c0 to %n step %c1 {
      %prepack_use = wave.binary addi %component, %lane
          : !wave.simd<i32, 32>, !wave.simd<i32, 32>
          -> !wave.simd<i32, 32>
      scf.yield
    }

    %other = wave.binary addi %component, %component
        : !wave.simd<i32, 32>, !wave.simd<i32, 32>
        -> !wave.simd<i32, 32>
    %packed = wave.pack %component, %other
        : !wave.simd<i32, 32>, !wave.simd<i32, 32>
        -> !wave.simd<vector<2xi32>, 32>
    %released_a = wave.alloc_release %a after %complete_a
        {workgroup_collective}
        : (!wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token

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
    %loaded_b, %read_b = wave.load %bp after %published_b
        : (!wave.simd<!wave.ptr<#wave.shared, i32>, 32>, !wave.mem.token)
        -> (!wave.simd<i32, 32>, !wave.mem.token)
    %complete_b = wave.barrier %read_b : (!wave.mem.token) -> !wave.mem.token
    %released_b = wave.alloc_release %b after %complete_b
        {workgroup_collective}
        : (!wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
  }
  return
}

// -----

// CHECK-LABEL: func.func @completed_region_carrier_allows_reuse
// CHECK-SAME: wave.lds_size = 16 : i64
// CHECK-COUNT-2: wave.shared_memory_base : !wave.ptr<#wave.shared, i32>
func.func @completed_region_carrier_allows_reuse(
    %condition: i1, %source: !wave.simd<i32, 32>) -> !wave.simd<i32, 32>
    attributes {wave.kernel, wave.lds_size = 0 : i64} {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %a = wave.alloc() {align = 16 : i64, bytesize = 16 : i64}
      : !wave.ptr<#wave.shared, i32>
  %ap = wave.ptr_add %a, %lane
      : !wave.ptr<#wave.shared, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.shared, i32>, 32>
  %stored_a = wave.store %source -> %ap
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.shared, i32>, 32>)
      -> !wave.mem.token
  %published_a = wave.barrier %stored_a
      : (!wave.mem.token) -> !wave.mem.token
  %loaded, %read_a = wave.load %ap after %published_a
      : (!wave.simd<!wave.ptr<#wave.shared, i32>, 32>, !wave.mem.token)
      -> (!wave.simd<i32, 32>, !wave.mem.token)
  %complete_a = wave.barrier %read_a
      : (!wave.mem.token) -> !wave.mem.token
  %packed = wave.pack %loaded
      : !wave.simd<i32, 32> -> !wave.simd<vector<1xi32>, 32>
  %released_a = wave.alloc_release %a after %complete_a
      {workgroup_collective}
      : (!wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
  %forwarded = scf.if %condition -> (!wave.simd<vector<1xi32>, 32>) {
    scf.yield %packed : !wave.simd<vector<1xi32>, 32>
  } else {
    scf.yield %packed : !wave.simd<vector<1xi32>, 32>
  }
  %forwarded_value = wave.extract %forwarded[0]
      : !wave.simd<vector<1xi32>, 32> -> !wave.simd<i32, 32>
  %b = wave.alloc() {align = 16 : i64, bytesize = 16 : i64}
      : !wave.ptr<#wave.shared, i32>
  %bp = wave.ptr_add %b, %lane
      : !wave.ptr<#wave.shared, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.shared, i32>, 32>
  %stored_b = wave.store %source -> %bp after %released_a
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.shared, i32>, 32>,
         !wave.mem.token) -> !wave.mem.token
  %result = wave.binary addi %forwarded_value, %lane
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  return %result : !wave.simd<i32, 32>
}

// -----

// A store through a pointer select belongs to both allocations. Source
// frontier recovery must not assign that store to either lifetime endpoint.
// CHECK-LABEL: func.func @ambiguous_store_owner_stays_conservative
// CHECK-SAME: wave.lds_size = 32 : i64
// CHECK-DAG: wave.shared_memory_base : !wave.ptr<#wave.shared, i32>
// CHECK-DAG: wave.shared_memory_base {offset = 16 : i64}
func.func @ambiguous_store_owner_stays_conservative(
    %condition: i1, %source: !wave.simd<i32, 32>)
    attributes {wave.kernel, wave.lds_size = 0 : i64} {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %a = wave.alloc() {align = 16 : i64, bytesize = 16 : i64}
      : !wave.ptr<#wave.shared, i32>
  %b = wave.alloc() {align = 16 : i64, bytesize = 16 : i64}
      : !wave.ptr<#wave.shared, i32>
  %ap = wave.ptr_add %a, %lane
      : !wave.ptr<#wave.shared, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.shared, i32>, 32>
  %bp = wave.ptr_add %b, %lane
      : !wave.ptr<#wave.shared, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.shared, i32>, 32>
  %selected = wave.select %condition, %ap, %bp
      : !wave.simd<!wave.ptr<#wave.shared, i32>, 32>
  %stored = wave.store %source -> %selected
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.shared, i32>, 32>)
      -> !wave.mem.token
  %published = wave.barrier %stored : (!wave.mem.token) -> !wave.mem.token
  %loaded_a, %read_a = wave.load %ap after %published
      : (!wave.simd<!wave.ptr<#wave.shared, i32>, 32>, !wave.mem.token)
      -> (!wave.simd<i32, 32>, !wave.mem.token)
  %loaded_b, %read_b = wave.load %bp after %published
      : (!wave.simd<!wave.ptr<#wave.shared, i32>, 32>, !wave.mem.token)
      -> (!wave.simd<i32, 32>, !wave.mem.token)
  %complete = wave.join %read_a, %read_b
      : !wave.mem.token, !wave.mem.token -> !wave.mem.token
  %released_a = wave.alloc_release %a after %complete {workgroup_collective}
      : (!wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
  %released_b = wave.alloc_release %b after %released_a
      {workgroup_collective}
      : (!wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
  return
}
