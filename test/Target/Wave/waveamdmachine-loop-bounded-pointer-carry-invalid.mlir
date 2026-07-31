// RUN: wave-opt --waveamd-to-machine --split-input-file \
// RUN:   --verify-diagnostics %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
func.func @shared_absolute_lane_carry_rejected()
    attributes {wave.kernel, wave.lds_size = 1024 : i64} {
  %c0 = arith.constant 0 : i32
  %c1 = arith.constant 1 : i32
  %c4 = arith.constant 4 : i32
  %lds = wave.shared_memory_base : !wave.ptr<#wave.shared, i32>
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %lane_offset = wave.index_expr <"lane"> ["lane"](%lane)
      : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
  %initial = wave.ptr_add %lds, %lane_offset
      : !wave.ptr<#wave.shared, i32>, !wave.simd<index, 32>
      -> !wave.simd<!wave.ptr<#wave.shared, i32>, 32>
  // expected-error @below {{scf.for absolute pointer carry offset must be uniform}}
  scf.for %i = %c0 to %c4 step %c1 iter_args(%ptr = %initial)
      -> (!wave.simd<!wave.ptr<#wave.shared, i32>, 32>) : i32 {
    %next = wave.ptr_add %lds, %lane_offset
        : !wave.ptr<#wave.shared, i32>, !wave.simd<index, 32>
        -> !wave.simd<!wave.ptr<#wave.shared, i32>, 32>
    scf.yield %next : !wave.simd<!wave.ptr<#wave.shared, i32>, 32>
  }
  return
}
}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
func.func @shared_absolute_unbounded_carry_rejected(%raw: i32)
    attributes {wave.kernel, wave.lds_size = 1024 : i64} {
  %c0 = arith.constant 0 : i32
  %c1 = arith.constant 1 : i32
  %c4 = arith.constant 4 : i32
  %lds = wave.shared_memory_base : !wave.ptr<#wave.shared, i32>
  // expected-error @below {{scf.for absolute pointer carry offset needs explicit unsigned 32-bit bounds}}
  scf.for %i = %c0 to %c4 step %c1 iter_args(%ptr = %lds)
      -> (!wave.ptr<#wave.shared, i32>) : i32 {
    %offset = wave.index_expr <"x"> ["x"](%raw) : (i32) -> index
    %next = wave.ptr_add %lds, %offset
        : !wave.ptr<#wave.shared, i32>, index
        -> !wave.ptr<#wave.shared, i32>
    scf.yield %next : !wave.ptr<#wave.shared, i32>
  }
  return
}
}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
func.func @shared_absolute_negative_carry_rejected(%raw: i32)
    attributes {wave.kernel, wave.lds_size = 1024 : i64} {
  %c0 = arith.constant 0 : i32
  %c1 = arith.constant 1 : i32
  %c4 = arith.constant 4 : i32
  %bounded = wave.assume %raw as "x"
      [#wave.pred<"x >= -4">, #wave.pred<"x <= 4">] : i32
  %lds = wave.shared_memory_base : !wave.ptr<#wave.shared, i32>
  // expected-error @below {{scf.for absolute pointer carry offset may be negative}}
  scf.for %i = %c0 to %c4 step %c1 iter_args(%ptr = %lds)
      -> (!wave.ptr<#wave.shared, i32>) : i32 {
    %offset = wave.index_expr <"x"> ["x"](%bounded) : (i32) -> index
    %next = wave.ptr_add %lds, %offset
        : !wave.ptr<#wave.shared, i32>, index
        -> !wave.ptr<#wave.shared, i32>
    scf.yield %next : !wave.ptr<#wave.shared, i32>
  }
  return
}
}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
func.func @shared_absolute_overflowing_carry_rejected(%raw: i32)
    attributes {wave.kernel, wave.lds_size = 1024 : i64} {
  %c0 = arith.constant 0 : i32
  %c1 = arith.constant 1 : i32
  %c4 = arith.constant 4 : i32
  %bounded = wave.assume %raw as "x"
      [#wave.pred<"x >= 0">, #wave.pred<"x <= 1073741824">] : i32
  %lds = wave.shared_memory_base : !wave.ptr<#wave.shared, i32>
  // expected-error @below {{scf.for absolute pointer carry offset may exceed unsigned 32-bit}}
  scf.for %i = %c0 to %c4 step %c1 iter_args(%ptr = %lds)
      -> (!wave.ptr<#wave.shared, i32>) : i32 {
    %offset = wave.index_expr <"x"> ["x"](%bounded) : (i32) -> index
    %next = wave.ptr_add %lds, %offset
        : !wave.ptr<#wave.shared, i32>, index
        -> !wave.ptr<#wave.shared, i32>
    scf.yield %next : !wave.ptr<#wave.shared, i32>
  }
  return
}
}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
func.func @absolute_base_changing_carry_rejected(
    %first: !wave.ptr<#wave.global, i32>,
    %second: !wave.ptr<#wave.global, i32>) attributes {wave.kernel} {
  %c0 = arith.constant 0 : i32
  %c1 = arith.constant 1 : i32
  %c4 = arith.constant 4 : i32
  // expected-error @below {{scf.for absolute pointer carry must preserve its selected base}}
  scf.for %i = %c0 to %c4 step %c1 iter_args(%ptr = %first)
      -> (!wave.ptr<#wave.global, i32>) : i32 {
    scf.yield %second : !wave.ptr<#wave.global, i32>
  }
  return
}
}

// -----

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
func.func @shared_cross_carry_recurrence_rejected()
    attributes {wave.kernel, wave.lds_size = 1024 : i64} {
  %c0 = arith.constant 0 : i32
  %c1 = arith.constant 1 : i32
  %c4 = arith.constant 4 : i32
  %one = arith.constant 1 : index
  %lds = wave.shared_memory_base : !wave.ptr<#wave.shared, i32>
  %slot1 = wave.ptr_add %lds, %one
      : !wave.ptr<#wave.shared, i32>, index
      -> !wave.ptr<#wave.shared, i32>
  // expected-error @below {{scf.for pointer carry cannot recur through another iter arg}}
  scf.for %i = %c0 to %c4 step %c1
      iter_args(%current = %lds, %next = %slot1)
      -> (!wave.ptr<#wave.shared, i32>, !wave.ptr<#wave.shared, i32>) : i32 {
    %advanced = wave.ptr_add %next, %one
        : !wave.ptr<#wave.shared, i32>, index
        -> !wave.ptr<#wave.shared, i32>
    scf.yield %advanced, %current
        : !wave.ptr<#wave.shared, i32>, !wave.ptr<#wave.shared, i32>
  }
  return
}
}
