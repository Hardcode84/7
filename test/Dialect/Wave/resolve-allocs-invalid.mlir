// RUN: wave-opt --split-input-file --wave-resolve-allocs --verify-diagnostics %s

func.func @release_dependency_misses_access() attributes {wave.kernel} {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %root = wave.token : !wave.mem.token
  %alloc = wave.alloc() {align = 16 : i64, bytesize = 64 : i64}
      : !wave.ptr<#wave.shared, i32>
  %ptr = wave.ptr_add %alloc, %lane
      : !wave.ptr<#wave.shared, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.shared, i32>, 32>
  %stored = wave.store %lane -> %ptr after %root
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.shared, i32>, 32>,
         !wave.mem.token)
      -> !wave.mem.token
  // expected-error @+1 {{dependency does not cover every allocation access token}}
  %released = wave.alloc_release %alloc after %root
      : (!wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
  return
}

// -----

func.func @release_non_allocation(
    %base: !wave.ptr<#wave.shared, i32>, %dependency: !wave.mem.token) {
  // expected-error @+1 {{allocation must be a direct wave.alloc result}}
  %released = wave.alloc_release %base after %dependency
      : (!wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
  return
}

// -----

func.func @release_allocation_alias(%dependency: !wave.mem.token) {
  %alloc = wave.alloc() {align = 16 : i64, bytesize = 64 : i64}
      : !wave.ptr<#wave.shared, i32>
  %alias = wave.ptr_cast %alloc
      : !wave.ptr<#wave.shared, i32> -> !wave.ptr<#wave.shared, i8>
  // expected-error @+1 {{allocation must be a direct wave.alloc result}}
  %released = wave.alloc_release %alias after %dependency
      : (!wave.ptr<#wave.shared, i8>, !wave.mem.token) -> !wave.mem.token
  return
}

// -----

func.func @release_twice(%dependency: !wave.mem.token) {
  %alloc = wave.alloc() {align = 16 : i64, bytesize = 64 : i64}
      : !wave.ptr<#wave.shared, i32>
  %first = wave.alloc_release %alloc after %dependency
      : (!wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
  // expected-error @+1 {{allocation already has a wave.alloc_release}}
  %second = wave.alloc_release %alloc after %first
      : (!wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
  return
}

// -----

func.func @release_with_pointer_escape(%dependency: !wave.mem.token)
    -> !wave.ptr<#wave.shared, i32> {
  %alloc = wave.alloc() {align = 16 : i64, bytesize = 64 : i64}
      : !wave.ptr<#wave.shared, i32>
  // expected-error @+1 {{cannot release an allocation with an untracked pointer use}}
  %released = wave.alloc_release %alloc after %dependency
      : (!wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
  return %alloc : !wave.ptr<#wave.shared, i32>
}

// -----

func.func @divergent_repeated_release(%mask: !wave.mask<32>, %n: index)
    attributes {wave.kernel} {
  %c0 = arith.constant 0 : index
  %c1 = arith.constant 1 : index
  %lane = wave.lane_id : !wave.simd<i32, 32>
  scf.for %i = %c0 to %n step %c1 {
    wave.where %mask {
      %alloc = wave.alloc() {align = 16 : i64, bytesize = 128 : i64}
          : !wave.ptr<#wave.shared, i32>
      %ptr = wave.ptr_add %alloc, %lane
          : !wave.ptr<#wave.shared, i32>, !wave.simd<i32, 32>
          -> !wave.simd<!wave.ptr<#wave.shared, i32>, 32>
      %stored = wave.store %lane -> %ptr
          : (!wave.simd<i32, 32>,
             !wave.simd<!wave.ptr<#wave.shared, i32>, 32>)
          -> !wave.mem.token
      // expected-error @+1 {{repeated lifetime requires workgroup_collective before barrier synthesis}}
      %released = wave.alloc_release %alloc after %stored
          : (!wave.ptr<#wave.shared, i32>, !wave.mem.token)
          -> !wave.mem.token
      wave.yield
    } : !wave.mask<32>
  }
  return
}

// -----

func.func @overlapping_fixed_allocations()
    attributes {wave.kernel, wave.lds_size = 0 : i64} {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %a = wave.alloc() {align = 16 : i64, bytesize = 64 : i64,
                     offset = 0 : i64}
      : !wave.ptr<#wave.shared, i32>
  // expected-error @+1 {{fixed offset overlaps live LDS storage}}
  %b = wave.alloc() {align = 16 : i64, bytesize = 64 : i64,
                     offset = 32 : i64}
      : !wave.ptr<#wave.shared, i32>
  %ap = wave.ptr_add %a, %lane
      : !wave.ptr<#wave.shared, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.shared, i32>, 32>
  %bp = wave.ptr_add %b, %lane
      : !wave.ptr<#wave.shared, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.shared, i32>, 32>
  return
}
