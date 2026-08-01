// RUN: wave-opt --split-input-file --wave-normalize-pointer-offsets %s | FileCheck %s --check-prefix=NORMALIZE
// RUN: wave-opt --split-input-file --wave-normalize-pointer-offsets --wave-normalize-pointer-offsets %s | FileCheck %s --check-prefix=NORMALIZE
// RUN: wave-opt --split-input-file --wave-normalize-pointer-offsets --wave-combine-pointer-offsets --wave-simplify-index-exprs %s | FileCheck %s --check-prefix=COMPOSE

// NORMALIZE-LABEL: func.func @scale_constant
// NORMALIZE-SAME: ([[P:%.*]]: !wave.ptr<#wave.global>) -> !wave.ptr<#wave.global>
// NORMALIZE: [[C3:%.*]] = arith.constant 3 : index
// NORMALIZE: [[OFF:%.*]] = wave.index_expr <"2*orig"> ["orig"]([[C3]]) : (index) -> index
// NORMALIZE: [[Q:%.*]] = wave.ptr_add [[P]], [[OFF]] : !wave.ptr<#wave.global>, index -> !wave.ptr<#wave.global>
// NORMALIZE: return [[Q]] : !wave.ptr<#wave.global>
// COMPOSE-LABEL: func.func @scale_constant
// COMPOSE-SAME: ([[P:%.*]]: !wave.ptr<#wave.global>) -> !wave.ptr<#wave.global>
// COMPOSE: [[OFF:%.*]] = wave.index_expr <"6"> []() : () -> index
// COMPOSE: [[Q:%.*]] = wave.ptr_add [[P]], [[OFF]] : !wave.ptr<#wave.global>, index -> !wave.ptr<#wave.global>
func.func @scale_constant(%p: !wave.ptr<#wave.global, f16>)
    -> !wave.ptr<#wave.global, f16> attributes {wave.kernel} {
  %c3 = arith.constant 3 : index
  %q = wave.ptr_add %p, %c3
      : !wave.ptr<#wave.global, f16>, index -> !wave.ptr<#wave.global, f16>
  return %q : !wave.ptr<#wave.global, f16>
}

// -----

// NORMALIZE-LABEL: func.func @scale_index_expr
// NORMALIZE-SAME: ([[P:%.*]]: !wave.ptr<#wave.global>, [[K:%.*]]: index)
// NORMALIZE: [[LANE:%.*]] = wave.lane_id : !wave.simd<i32, 32>
// NORMALIZE: [[BASE:%.*]] = wave.index_expr <"k + lane"> ["k", "lane"]([[K]], [[LANE]]) : (index, !wave.simd<i32, 32>) -> !wave.simd<index, 32>
// NORMALIZE: [[SCALED:%.*]] = wave.index_expr <"2*orig"> ["orig"]([[BASE]]) : (!wave.simd<index, 32>) -> !wave.simd<index, 32>
// NORMALIZE: wave.ptr_add [[P]], [[SCALED]] : !wave.ptr<#wave.global>, !wave.simd<index, 32> -> !wave.simd<!wave.ptr<#wave.global>, 32>
// COMPOSE-LABEL: func.func @scale_index_expr
// COMPOSE-SAME: ([[P:%.*]]: !wave.ptr<#wave.global>, [[K:%.*]]: index)
// COMPOSE: [[LANE:%.*]] = wave.lane_id : !wave.simd<i32, 32>
// COMPOSE: [[SCALED:%.*]] = wave.index_expr <"2*(k + lane)"> assuming [#wave.pred<"lane >= 0 & -31 + lane <= 0">] ["k", "lane"]([[K]], [[LANE]]) : (index, !wave.simd<i32, 32>) -> !wave.simd<index, 32>
// COMPOSE: wave.ptr_add [[P]], [[SCALED]] : !wave.ptr<#wave.global>, !wave.simd<index, 32> -> !wave.simd<!wave.ptr<#wave.global>, 32>
func.func @scale_index_expr(%p: !wave.ptr<#wave.global, f16>, %k: index)
    -> !wave.simd<!wave.ptr<#wave.global, f16>, 32> attributes {wave.kernel} {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %off = wave.index_expr <"k + lane"> ["k", "lane"](%k, %lane)
      : (index, !wave.simd<i32, 32>) -> !wave.simd<index, 32>
  %q = wave.ptr_add %p, %off
      : !wave.ptr<#wave.global, f16>, !wave.simd<index, 32>
      -> !wave.simd<!wave.ptr<#wave.global, f16>, 32>
  return %q : !wave.simd<!wave.ptr<#wave.global, f16>, 32>
}

// -----

// NORMALIZE-LABEL: func.func @memory_ops
// NORMALIZE-SAME: ([[P:%.*]]: !wave.ptr<#wave.global>
// NORMALIZE: [[BUF:%.*]] = waveamd.make_buffer [[P]], {{%.*}} : !wave.ptr<#wave.global>, i32 -> !wave.ptr<#waveamd.buffer>
// NORMALIZE: [[OFF:%.*]] = wave.index_expr <"4*orig"> ["orig"]({{%.*}}) : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
// NORMALIZE: [[PTR:%.*]] = wave.ptr_add [[BUF]], [[OFF]] : !wave.ptr<#waveamd.buffer>, !wave.simd<index, 32> -> !wave.simd<!wave.ptr<#waveamd.buffer>, 32>
// NORMALIZE: wave.load [[PTR]] : (!wave.simd<!wave.ptr<#waveamd.buffer>, 32>) -> (!wave.simd<i32, 32>, !wave.mem.token)
// NORMALIZE: wave.store {{%.*}} -> [[PTR]]
func.func @memory_ops(%p: !wave.ptr<#wave.global, i32>)
    -> !wave.mem.token attributes {wave.kernel} {
  %range = arith.constant 128 : i32
  %buffer = waveamd.make_buffer %p, %range
      : !wave.ptr<#wave.global, i32>, i32 -> !wave.ptr<#waveamd.buffer, i32>
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %ptrs = wave.ptr_add %buffer, %lane
      : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>
  %value, %tok0 = wave.load %ptrs
      : (!wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>)
      -> (!wave.simd<i32, 32>, !wave.mem.token)
  %tok1 = wave.store %value -> %ptrs after %tok0
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>,
         !wave.mem.token) -> !wave.mem.token
  return %tok1 : !wave.mem.token
}

// -----

// NORMALIZE-LABEL: func.func @pointer_shuffle_chain
// NORMALIZE-SAME: ([[P:%.*]]: !wave.ptr<#wave.global>)
// NORMALIZE: [[LANE:%.*]] = wave.lane_id : !wave.simd<i32, 32>
// NORMALIZE: [[MOVED_ITEM0:%.*]] = wave.shuffle [[LANE]] from [[LANE]] : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
// NORMALIZE: [[MOVED_ITEM1:%.*]] = wave.shuffle [[MOVED_ITEM0]] from [[LANE]] : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
// NORMALIZE: [[MOVED_OFFSET:%.*]] = wave.index_expr <"4*orig"> ["orig"]([[MOVED_ITEM1]]) : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
// NORMALIZE: [[MOVED:%.*]] = wave.ptr_add [[P]], [[MOVED_OFFSET]] : !wave.ptr<#wave.global>, !wave.simd<index, 32> -> !wave.simd<!wave.ptr<#wave.global>, 32>
// NORMALIZE: return [[MOVED]] : !wave.simd<!wave.ptr<#wave.global>, 32>
func.func @pointer_shuffle_chain(%p: !wave.ptr<#wave.global, i32>)
    -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
    attributes {wave.kernel} {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %source = wave.ptr_add %p, %lane
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %moved = wave.shuffle %source from %lane
      : !wave.simd<!wave.ptr<#wave.global, i32>, 32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %moved_again = wave.shuffle %moved from %lane
      : !wave.simd<!wave.ptr<#wave.global, i32>, 32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  return %moved_again : !wave.simd<!wave.ptr<#wave.global, i32>, 32>
}

// -----

// NORMALIZE-LABEL: func.func @allocation_release
// NORMALIZE: [[ALLOC:%.*]] = wave.alloc() {align = 16 : i64, bytesize = 128 : i64} : !wave.ptr<#wave.shared>
// NORMALIZE: wave.alloc_release [[ALLOC]] after {{%.*}} {workgroup_collective} : (!wave.ptr<#wave.shared>, !wave.mem.token) -> !wave.mem.token
func.func @allocation_release() attributes {wave.kernel} {
  %alloc = wave.alloc() {align = 16 : i64, bytesize = 128 : i64}
      : !wave.ptr<#wave.shared, i32>
  %dependency = wave.token : !wave.mem.token
  %released = wave.alloc_release %alloc after %dependency {workgroup_collective}
      : (!wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
  return
}

// -----

// NORMALIZE-LABEL: func.func @loop_carry
// NORMALIZE-SAME: ([[P:%.*]]: !wave.ptr<#wave.global>, [[N:%.*]]: index)
// NORMALIZE: [[R:%.*]] = scf.for {{%.*}} = {{%.*}} to [[N]] step {{%.*}} iter_args([[CARRY:%.*]] = [[P]]) -> (!wave.ptr<#wave.global>)
// NORMALIZE: scf.yield [[CARRY]] : !wave.ptr<#wave.global>
// NORMALIZE: return [[R]] : !wave.ptr<#wave.global>
func.func @loop_carry(%p: !wave.ptr<#wave.global, i32>, %n: index)
    -> !wave.ptr<#wave.global, i32> attributes {wave.kernel} {
  %c0 = arith.constant 0 : index
  %c1 = arith.constant 1 : index
  %r = scf.for %i = %c0 to %n step %c1 iter_args(%carry = %p)
      -> (!wave.ptr<#wave.global, i32>) {
    scf.yield %carry : !wave.ptr<#wave.global, i32>
  }
  return %r : !wave.ptr<#wave.global, i32>
}
