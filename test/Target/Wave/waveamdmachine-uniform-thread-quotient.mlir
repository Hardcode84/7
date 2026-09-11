// RUN: wave-opt --split-input-file --waveamd-to-machine %s | FileCheck %s

// CHECK-LABEL: func.func @wave64_floor(
// CHECK: [[FIRST:%.*]] = waveamdmachine.v_readfirstlane_b32
// CHECK: [[SHIFT:%.*]] = waveamdmachine.imm 6
// CHECK: [[QUOT:%[^,]+]], {{%.*}} = waveamdmachine.s_lshr_b32 [[FIRST]], [[SHIFT]]
// CHECK: [[OFFSET:%[^,]+]], {{%.*}} = waveamdmachine.s_lshl_b32 [[QUOT]],
// CHECK: waveamdmachine.buffer_load_b32 {{%.*}}, {{%.*}}, [[OFFSET]] offset 12
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @wave64_floor(%input: !wave.ptr<#wave.global, i32>, %out: !wave.ptr<#wave.global, i32>) attributes {wave.kernel, wave.workgroup_size = array<i32: 256, 1, 1>} {
  %raw = wave.workitem_id 0 : !wave.simd<i32, 64>
  %tid = wave.assume %raw as "x" [#wave.pred<"x >= 0">, #wave.pred<"x <= 255">] : !wave.simd<i32, 64>
  %q = wave.index_expr <"8*floor(1/64*x) + 3"> ["x"](%tid) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
  %size = arith.constant 4096 : i32
  %buffer = waveamd.make_buffer %input, %size : !wave.ptr<#wave.global, i32>, i32 -> !wave.ptr<#waveamd.buffer, i32>
  %src = wave.ptr_add %buffer, %q : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>
  %data, %loaded = wave.load %src : (!wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>) -> (!wave.simd<i32, 64>, !wave.mem.token)
  %dst = wave.ptr_add %out, %tid : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.global, i32>, 64>
  %stored = wave.store %data -> %dst after %loaded : (!wave.simd<i32, 64>, !wave.simd<!wave.ptr<#wave.global, i32>, 64>, !wave.mem.token) -> !wave.mem.token
  return
}
}

// -----

// CHECK-LABEL: func.func @wave32_floor(
// CHECK: [[FIRST:%.*]] = waveamdmachine.v_readfirstlane_b32
// CHECK: [[SHIFT:%.*]] = waveamdmachine.imm 5
// CHECK: [[QUOT:%[^,]+]], {{%.*}} = waveamdmachine.s_lshr_b32 [[FIRST]], [[SHIFT]]
// CHECK: [[OFFSET:%[^,]+]], {{%.*}} = waveamdmachine.s_lshl_b32 [[QUOT]],
// CHECK: waveamdmachine.buffer_load_b32 {{%.*}}, {{%.*}}, [[OFFSET]] offset 12
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {
func.func @wave32_floor(%input: !wave.ptr<#wave.global, i32>, %out: !wave.ptr<#wave.global, i32>) attributes {wave.kernel, wave.workgroup_size = array<i32: 256, 1, 1>} {
  %raw = wave.workitem_id 0 : !wave.simd<i32, 32>
  %tid = wave.assume %raw as "x" [#wave.pred<"x >= 0">, #wave.pred<"x <= 255">] : !wave.simd<i32, 32>
  %q = wave.index_expr <"8*floor(1/32*x) + 3"> ["x"](%tid) : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
  %size = arith.constant 4096 : i32
  %buffer = waveamd.make_buffer %input, %size : !wave.ptr<#wave.global, i32>, i32 -> !wave.ptr<#waveamd.buffer, i32>
  %src = wave.ptr_add %buffer, %q : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<index, 32> -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>
  %data, %loaded = wave.load %src : (!wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>) -> (!wave.simd<i32, 32>, !wave.mem.token)
  %dst = wave.ptr_add %out, %tid : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32> -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %stored = wave.store %data -> %dst after %loaded : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.global, i32>, 32>, !wave.mem.token) -> !wave.mem.token
  return
}
}

// -----

// CHECK-LABEL: func.func @wave64_trunc(
// CHECK: [[FIRST:%.*]] = waveamdmachine.v_readfirstlane_b32
// CHECK: [[SHIFT:%.*]] = waveamdmachine.imm 6
// CHECK: [[QUOT:%[^,]+]], {{%.*}} = waveamdmachine.s_lshr_b32 [[FIRST]], [[SHIFT]]
// CHECK: [[OFFSET:%[^,]+]], {{%.*}} = waveamdmachine.s_lshl_b32 [[QUOT]],
// CHECK: waveamdmachine.buffer_load_b32 {{%.*}}, {{%.*}}, [[OFFSET]] offset 12
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @wave64_trunc(%input: !wave.ptr<#wave.global, i32>, %out: !wave.ptr<#wave.global, i32>) attributes {wave.kernel, wave.workgroup_size = array<i32: 256, 1, 1>} {
  %raw = wave.workitem_id 0 : !wave.simd<i32, 64>
  %tid = wave.assume %raw as "x" [#wave.pred<"x >= 0">, #wave.pred<"x <= 255">] : !wave.simd<i32, 64>
  %q = wave.index_expr <"8*Trunc(1/64*x) + 3"> ["x"](%tid) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
  %size = arith.constant 4096 : i32
  %buffer = waveamd.make_buffer %input, %size : !wave.ptr<#wave.global, i32>, i32 -> !wave.ptr<#waveamd.buffer, i32>
  %src = wave.ptr_add %buffer, %q : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>
  %data, %loaded = wave.load %src : (!wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>) -> (!wave.simd<i32, 64>, !wave.mem.token)
  %dst = wave.ptr_add %out, %tid : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.global, i32>, 64>
  %stored = wave.store %data -> %dst after %loaded : (!wave.simd<i32, 64>, !wave.simd<!wave.ptr<#wave.global, i32>, 64>, !wave.mem.token) -> !wave.mem.token
  return
}
}

// -----

// CHECK-LABEL: func.func @wave64_larger_divisor(
// CHECK: [[FIRST:%.*]] = waveamdmachine.v_readfirstlane_b32
// CHECK: [[SHIFT:%.*]] = waveamdmachine.imm 6
// CHECK: [[WAVE:%[^,]+]], {{%.*}} = waveamdmachine.s_lshr_b32 [[FIRST]], [[SHIFT]]
// CHECK: [[ONE:%.*]] = waveamdmachine.imm 1
// CHECK: [[QUOT:%[^,]+]], {{%.*}} = waveamdmachine.s_lshr_b32 [[WAVE]], [[ONE]]
// CHECK: [[OFFSET:%[^,]+]], {{%.*}} = waveamdmachine.s_lshl_b32 [[QUOT]],
// CHECK: waveamdmachine.buffer_load_b32 {{%.*}}, {{%.*}}, [[OFFSET]] offset 12
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @wave64_larger_divisor(%input: !wave.ptr<#wave.global, i32>, %out: !wave.ptr<#wave.global, i32>) attributes {wave.kernel, wave.workgroup_size = array<i32: 256, 1, 1>} {
  %raw = wave.workitem_id 0 : !wave.simd<i32, 64>
  %tid = wave.assume %raw as "x" [#wave.pred<"x >= 0">, #wave.pred<"x <= 255">] : !wave.simd<i32, 64>
  %q = wave.index_expr <"8*floor(1/128*x) + 3"> ["x"](%tid) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
  %size = arith.constant 4096 : i32
  %buffer = waveamd.make_buffer %input, %size : !wave.ptr<#wave.global, i32>, i32 -> !wave.ptr<#waveamd.buffer, i32>
  %src = wave.ptr_add %buffer, %q : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>
  %data, %loaded = wave.load %src : (!wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>) -> (!wave.simd<i32, 64>, !wave.mem.token)
  %dst = wave.ptr_add %out, %tid : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.global, i32>, 64>
  %stored = wave.store %data -> %dst after %loaded : (!wave.simd<i32, 64>, !wave.simd<!wave.ptr<#wave.global, i32>, 64>, !wave.mem.token) -> !wave.mem.token
  return
}
}

// -----

// CHECK-LABEL: func.func @wave64_partial_wave(
// CHECK: [[FIRST:%.*]] = waveamdmachine.v_readfirstlane_b32
// CHECK: [[SHIFT:%.*]] = waveamdmachine.imm 6
// CHECK: [[QUOT:%[^,]+]], {{%.*}} = waveamdmachine.s_lshr_b32 [[FIRST]], [[SHIFT]]
// CHECK: [[OFFSET:%[^,]+]], {{%.*}} = waveamdmachine.s_lshl_b32 [[QUOT]],
// CHECK: waveamdmachine.buffer_load_b32 {{%.*}}, {{%.*}}, [[OFFSET]] offset 12
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @wave64_partial_wave(%input: !wave.ptr<#wave.global, i32>, %out: !wave.ptr<#wave.global, i32>) attributes {wave.kernel, wave.workgroup_size = array<i32: 96, 1, 1>} {
  %raw = wave.workitem_id 0 : !wave.simd<i32, 64>
  %tid = wave.assume %raw as "x" [#wave.pred<"x >= 0">, #wave.pred<"x <= 255">] : !wave.simd<i32, 64>
  %q = wave.index_expr <"8*floor(1/64*x) + 3"> ["x"](%tid) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
  %size = arith.constant 4096 : i32
  %buffer = waveamd.make_buffer %input, %size : !wave.ptr<#wave.global, i32>, i32 -> !wave.ptr<#waveamd.buffer, i32>
  %src = wave.ptr_add %buffer, %q : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>
  %data, %loaded = wave.load %src : (!wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>) -> (!wave.simd<i32, 64>, !wave.mem.token)
  %dst = wave.ptr_add %out, %tid : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.global, i32>, 64>
  %stored = wave.store %data -> %dst after %loaded : (!wave.simd<i32, 64>, !wave.simd<!wave.ptr<#wave.global, i32>, 64>, !wave.mem.token) -> !wave.mem.token
  return
}
}

// -----

// CHECK-LABEL: func.func @wave64_aligned_rows(
// CHECK: [[FIRST:%.*]] = waveamdmachine.v_readfirstlane_b32
// CHECK: [[SHIFT:%.*]] = waveamdmachine.imm 6
// CHECK: [[QUOT:%[^,]+]], {{%.*}} = waveamdmachine.s_lshr_b32 [[FIRST]], [[SHIFT]]
// CHECK: [[OFFSET:%[^,]+]], {{%.*}} = waveamdmachine.s_lshl_b32 [[QUOT]],
// CHECK: waveamdmachine.buffer_load_b32 {{%.*}}, {{%.*}}, [[OFFSET]] offset 12
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @wave64_aligned_rows(%input: !wave.ptr<#wave.global, i32>, %out: !wave.ptr<#wave.global, i32>) attributes {wave.kernel, wave.workgroup_size = array<i32: 128, 2, 1>} {
  %raw = wave.workitem_id 0 : !wave.simd<i32, 64>
  %tid = wave.assume %raw as "x" [#wave.pred<"x >= 0">, #wave.pred<"x <= 255">] : !wave.simd<i32, 64>
  %q = wave.index_expr <"8*floor(1/64*x) + 3"> ["x"](%tid) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
  %size = arith.constant 4096 : i32
  %buffer = waveamd.make_buffer %input, %size : !wave.ptr<#wave.global, i32>, i32 -> !wave.ptr<#waveamd.buffer, i32>
  %src = wave.ptr_add %buffer, %q : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>
  %data, %loaded = wave.load %src : (!wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>) -> (!wave.simd<i32, 64>, !wave.mem.token)
  %dst = wave.ptr_add %out, %tid : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.global, i32>, 64>
  %stored = wave.store %data -> %dst after %loaded : (!wave.simd<i32, 64>, !wave.simd<!wave.ptr<#wave.global, i32>, 64>, !wave.mem.token) -> !wave.mem.token
  return
}
}

// -----

// CHECK-LABEL: func.func @wave64_unaligned_rows(
// CHECK-NOT: waveamdmachine.v_readfirstlane_b32
// CHECK-NOT: waveamdmachine.s_lshr_b32
// CHECK: waveamdmachine.v_lshrrev_b32
// CHECK: waveamdmachine.buffer_load_b32
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @wave64_unaligned_rows(%input: !wave.ptr<#wave.global, i32>, %out: !wave.ptr<#wave.global, i32>) attributes {wave.kernel, wave.workgroup_size = array<i32: 96, 2, 1>} {
  %raw = wave.workitem_id 0 : !wave.simd<i32, 64>
  %tid = wave.assume %raw as "x" [#wave.pred<"x >= 0">, #wave.pred<"x <= 255">] : !wave.simd<i32, 64>
  %q = wave.index_expr <"8*floor(1/64*x) + 3"> ["x"](%tid) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
  %size = arith.constant 4096 : i32
  %buffer = waveamd.make_buffer %input, %size : !wave.ptr<#wave.global, i32>, i32 -> !wave.ptr<#waveamd.buffer, i32>
  %src = wave.ptr_add %buffer, %q : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>
  %data, %loaded = wave.load %src : (!wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>) -> (!wave.simd<i32, 64>, !wave.mem.token)
  %dst = wave.ptr_add %out, %tid : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.global, i32>, 64>
  %stored = wave.store %data -> %dst after %loaded : (!wave.simd<i32, 64>, !wave.simd<!wave.ptr<#wave.global, i32>, 64>, !wave.mem.token) -> !wave.mem.token
  return
}
}

// -----

// CHECK-LABEL: func.func @wave64_unknown_shape(
// CHECK-NOT: waveamdmachine.v_readfirstlane_b32
// CHECK-NOT: waveamdmachine.s_lshr_b32
// CHECK: waveamdmachine.v_lshrrev_b32
// CHECK: waveamdmachine.buffer_load_b32
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @wave64_unknown_shape(%input: !wave.ptr<#wave.global, i32>, %out: !wave.ptr<#wave.global, i32>) attributes {wave.kernel} {
  %raw = wave.workitem_id 0 : !wave.simd<i32, 64>
  %tid = wave.assume %raw as "x" [#wave.pred<"x >= 0">, #wave.pred<"x <= 255">] : !wave.simd<i32, 64>
  %q = wave.index_expr <"8*floor(1/64*x) + 3"> ["x"](%tid) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
  %size = arith.constant 4096 : i32
  %buffer = waveamd.make_buffer %input, %size : !wave.ptr<#wave.global, i32>, i32 -> !wave.ptr<#waveamd.buffer, i32>
  %src = wave.ptr_add %buffer, %q : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>
  %data, %loaded = wave.load %src : (!wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>) -> (!wave.simd<i32, 64>, !wave.mem.token)
  %dst = wave.ptr_add %out, %tid : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.global, i32>, 64>
  %stored = wave.store %data -> %dst after %loaded : (!wave.simd<i32, 64>, !wave.simd<!wave.ptr<#wave.global, i32>, 64>, !wave.mem.token) -> !wave.mem.token
  return
}
}

// -----

// CHECK-LABEL: func.func @wave64_small_divisor(
// CHECK-NOT: waveamdmachine.v_readfirstlane_b32
// CHECK-NOT: waveamdmachine.s_lshr_b32
// CHECK: waveamdmachine.v_lshrrev_b32
// CHECK: waveamdmachine.buffer_load_b32
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @wave64_small_divisor(%input: !wave.ptr<#wave.global, i32>, %out: !wave.ptr<#wave.global, i32>) attributes {wave.kernel, wave.workgroup_size = array<i32: 256, 1, 1>} {
  %raw = wave.workitem_id 0 : !wave.simd<i32, 64>
  %tid = wave.assume %raw as "x" [#wave.pred<"x >= 0">, #wave.pred<"x <= 255">] : !wave.simd<i32, 64>
  %q = wave.index_expr <"8*floor(1/32*x) + 3"> ["x"](%tid) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
  %size = arith.constant 4096 : i32
  %buffer = waveamd.make_buffer %input, %size : !wave.ptr<#wave.global, i32>, i32 -> !wave.ptr<#waveamd.buffer, i32>
  %src = wave.ptr_add %buffer, %q : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>
  %data, %loaded = wave.load %src : (!wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>) -> (!wave.simd<i32, 64>, !wave.mem.token)
  %dst = wave.ptr_add %out, %tid : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.global, i32>, 64>
  %stored = wave.store %data -> %dst after %loaded : (!wave.simd<i32, 64>, !wave.simd<!wave.ptr<#wave.global, i32>, 64>, !wave.mem.token) -> !wave.mem.token
  return
}
}

// -----

// CHECK-LABEL: func.func @wave64_shifted_numerator(
// CHECK-NOT: waveamdmachine.v_readfirstlane_b32
// CHECK-NOT: waveamdmachine.s_lshr_b32
// CHECK: waveamdmachine.v_lshrrev_b32
// CHECK: waveamdmachine.buffer_load_b32
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @wave64_shifted_numerator(%input: !wave.ptr<#wave.global, i32>, %out: !wave.ptr<#wave.global, i32>) attributes {wave.kernel, wave.workgroup_size = array<i32: 256, 1, 1>} {
  %raw = wave.workitem_id 0 : !wave.simd<i32, 64>
  %tid = wave.assume %raw as "x" [#wave.pred<"x >= 0">, #wave.pred<"x <= 255">] : !wave.simd<i32, 64>
  %q = wave.index_expr <"8*floor(1/64*(x + 1)) + 3"> ["x"](%tid) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
  %size = arith.constant 4096 : i32
  %buffer = waveamd.make_buffer %input, %size : !wave.ptr<#wave.global, i32>, i32 -> !wave.ptr<#waveamd.buffer, i32>
  %src = wave.ptr_add %buffer, %q : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>
  %data, %loaded = wave.load %src : (!wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>) -> (!wave.simd<i32, 64>, !wave.mem.token)
  %dst = wave.ptr_add %out, %tid : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.global, i32>, 64>
  %stored = wave.store %data -> %dst after %loaded : (!wave.simd<i32, 64>, !wave.simd<!wave.ptr<#wave.global, i32>, 64>, !wave.mem.token) -> !wave.mem.token
  return
}
}

// -----

// CHECK-LABEL: func.func @wave64_ceil(
// CHECK-NOT: waveamdmachine.v_readfirstlane_b32
// CHECK-NOT: waveamdmachine.s_lshr_b32
// CHECK: waveamdmachine.v_lshrrev_b32
// CHECK: waveamdmachine.buffer_load_b32
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @wave64_ceil(%input: !wave.ptr<#wave.global, i32>, %out: !wave.ptr<#wave.global, i32>) attributes {wave.kernel, wave.workgroup_size = array<i32: 256, 1, 1>} {
  %raw = wave.workitem_id 0 : !wave.simd<i32, 64>
  %tid = wave.assume %raw as "x" [#wave.pred<"x >= 0">, #wave.pred<"x <= 255">] : !wave.simd<i32, 64>
  %q = wave.index_expr <"8*ceiling(1/64*x) + 3"> ["x"](%tid) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
  %size = arith.constant 4096 : i32
  %buffer = waveamd.make_buffer %input, %size : !wave.ptr<#wave.global, i32>, i32 -> !wave.ptr<#waveamd.buffer, i32>
  %src = wave.ptr_add %buffer, %q : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>
  %data, %loaded = wave.load %src : (!wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>) -> (!wave.simd<i32, 64>, !wave.mem.token)
  %dst = wave.ptr_add %out, %tid : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.global, i32>, 64>
  %stored = wave.store %data -> %dst after %loaded : (!wave.simd<i32, 64>, !wave.simd<!wave.ptr<#wave.global, i32>, 64>, !wave.mem.token) -> !wave.mem.token
  return
}
}

// -----

// CHECK-LABEL: func.func @wave64_nested_floor(
// CHECK: [[FIRST:%.*]] = waveamdmachine.v_readfirstlane_b32
// CHECK: [[SHIFT:%.*]] = waveamdmachine.imm 6
// CHECK: [[QUOT:%[^,]+]], {{%.*}} = waveamdmachine.s_lshr_b32 [[FIRST]], [[SHIFT]]
// CHECK: waveamdmachine.buffer_load_b32
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @wave64_nested_floor(%input: !wave.ptr<#wave.global, i32>, %out: !wave.ptr<#wave.global, i32>) attributes {wave.kernel, wave.workgroup_size = array<i32: 256, 1, 1>} {
  %raw = wave.workitem_id 0 : !wave.simd<i32, 64>
  %tid = wave.assume %raw as "x" [#wave.pred<"x >= 0">, #wave.pred<"x <= 255">] : !wave.simd<i32, 64>
  %q = wave.index_expr <"8*floor(1/2*(floor(1/64*x) + 1)) + 3"> ["x"](%tid) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
  %size = arith.constant 4096 : i32
  %buffer = waveamd.make_buffer %input, %size : !wave.ptr<#wave.global, i32>, i32 -> !wave.ptr<#waveamd.buffer, i32>
  %src = wave.ptr_add %buffer, %q : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>
  %data, %loaded = wave.load %src : (!wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>) -> (!wave.simd<i32, 64>, !wave.mem.token)
  %dst = wave.ptr_add %out, %tid : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.global, i32>, 64>
  %stored = wave.store %data -> %dst after %loaded : (!wave.simd<i32, 64>, !wave.simd<!wave.ptr<#wave.global, i32>, 64>, !wave.mem.token) -> !wave.mem.token
  return
}
}

// -----

// CHECK-LABEL: func.func @wave64_arbitrary_value(
// CHECK-NOT: waveamdmachine.v_readfirstlane_b32
// CHECK-NOT: waveamdmachine.s_lshr_b32
// CHECK: waveamdmachine.v_lshrrev_b32
// CHECK: waveamdmachine.buffer_load_b32
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @wave64_arbitrary_value(%input: !wave.ptr<#wave.global, i32>, %out: !wave.ptr<#wave.global, i32>) attributes {wave.kernel, wave.workgroup_size = array<i32: 256, 1, 1>} {
  %raw = wave.workitem_id 0 : !wave.simd<i32, 64>
  %lane = wave.lane_id : !wave.simd<i32, 64>
  %arbitrary = wave.binary muli %raw, %lane : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
  %tid = wave.assume %arbitrary as "x" [#wave.pred<"x >= 0">, #wave.pred<"x <= 255">] : !wave.simd<i32, 64>
  %q = wave.index_expr <"8*floor(1/64*x) + 3"> ["x"](%tid) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
  %size = arith.constant 4096 : i32
  %buffer = waveamd.make_buffer %input, %size : !wave.ptr<#wave.global, i32>, i32 -> !wave.ptr<#waveamd.buffer, i32>
  %src = wave.ptr_add %buffer, %q : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>
  %data, %loaded = wave.load %src : (!wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>) -> (!wave.simd<i32, 64>, !wave.mem.token)
  %dst = wave.ptr_add %out, %tid : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.global, i32>, 64>
  %stored = wave.store %data -> %dst after %loaded : (!wave.simd<i32, 64>, !wave.simd<!wave.ptr<#wave.global, i32>, 64>, !wave.mem.token) -> !wave.mem.token
  return
}
}

// -----

// CHECK-LABEL: func.func @gfx11_wave64(
// CHECK: [[FIRST:%.*]] = waveamdmachine.v_readfirstlane_b32
// CHECK: [[SHIFT:%.*]] = waveamdmachine.imm 6
// CHECK: [[QUOT:%[^,]+]], {{%.*}} = waveamdmachine.s_lshr_b32 [[FIRST]], [[SHIFT]]
// CHECK: [[OFFSET:%[^,]+]], {{%.*}} = waveamdmachine.s_lshl_b32 [[QUOT]],
// CHECK: waveamdmachine.buffer_load_b32 {{%.*}}, {{%.*}}, [[OFFSET]] offset 12
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100", waveamdmachine.wavefront_size = 64 : i64} {
func.func @gfx11_wave64(%input: !wave.ptr<#wave.global, i32>, %out: !wave.ptr<#wave.global, i32>) attributes {wave.kernel, wave.workgroup_size = array<i32: 256, 1, 1>} {
  %raw = wave.workitem_id 0 : !wave.simd<i32, 64>
  %tid = wave.assume %raw as "x" [#wave.pred<"x >= 0">, #wave.pred<"x <= 255">] : !wave.simd<i32, 64>
  %q = wave.index_expr <"8*floor(1/64*x) + 3"> ["x"](%tid) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
  %size = arith.constant 4096 : i32
  %buffer = waveamd.make_buffer %input, %size : !wave.ptr<#wave.global, i32>, i32 -> !wave.ptr<#waveamd.buffer, i32>
  %src = wave.ptr_add %buffer, %q : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>
  %data, %loaded = wave.load %src : (!wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>) -> (!wave.simd<i32, 64>, !wave.mem.token)
  %dst = wave.ptr_add %out, %tid : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.global, i32>, 64>
  %stored = wave.store %data -> %dst after %loaded : (!wave.simd<i32, 64>, !wave.simd<!wave.ptr<#wave.global, i32>, 64>, !wave.mem.token) -> !wave.mem.token
  return
}
}

// -----

// CHECK-LABEL: func.func @gfx11_wave64_small_divisor(
// CHECK-NOT: waveamdmachine.v_readfirstlane_b32
// CHECK-NOT: waveamdmachine.s_lshr_b32
// CHECK: waveamdmachine.v_lshrrev_b32
// CHECK: waveamdmachine.buffer_load_b32
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100", waveamdmachine.wavefront_size = 64 : i64} {
func.func @gfx11_wave64_small_divisor(%input: !wave.ptr<#wave.global, i32>, %out: !wave.ptr<#wave.global, i32>) attributes {wave.kernel, wave.workgroup_size = array<i32: 256, 1, 1>} {
  %raw = wave.workitem_id 0 : !wave.simd<i32, 64>
  %tid = wave.assume %raw as "x" [#wave.pred<"x >= 0">, #wave.pred<"x <= 255">] : !wave.simd<i32, 64>
  %q = wave.index_expr <"8*floor(1/32*x) + 3"> ["x"](%tid) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
  %size = arith.constant 4096 : i32
  %buffer = waveamd.make_buffer %input, %size : !wave.ptr<#wave.global, i32>, i32 -> !wave.ptr<#waveamd.buffer, i32>
  %src = wave.ptr_add %buffer, %q : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>
  %data, %loaded = wave.load %src : (!wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>) -> (!wave.simd<i32, 64>, !wave.mem.token)
  %dst = wave.ptr_add %out, %tid : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.global, i32>, 64>
  %stored = wave.store %data -> %dst after %loaded : (!wave.simd<i32, 64>, !wave.simd<!wave.ptr<#wave.global, i32>, 64>, !wave.mem.token) -> !wave.mem.token
  return
}
}

// -----

// CHECK-LABEL: func.func @wave64_workitem_y(
// CHECK-NOT: waveamdmachine.v_readfirstlane_b32
// CHECK-NOT: waveamdmachine.s_lshr_b32
// CHECK: waveamdmachine.v_lshrrev_b32
// CHECK: waveamdmachine.buffer_load_b32
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @wave64_workitem_y(%input: !wave.ptr<#wave.global, i32>, %out: !wave.ptr<#wave.global, i32>) attributes {wave.kernel, wave.workgroup_size = array<i32: 3, 128, 1>} {
  %raw = wave.workitem_id 1 : !wave.simd<i32, 64>
  %tid = wave.assume %raw as "x" [#wave.pred<"x >= 0">, #wave.pred<"x <= 255">] : !wave.simd<i32, 64>
  %q = wave.index_expr <"8*floor(1/64*x) + 3"> ["x"](%tid) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
  %size = arith.constant 4096 : i32
  %buffer = waveamd.make_buffer %input, %size : !wave.ptr<#wave.global, i32>, i32 -> !wave.ptr<#waveamd.buffer, i32>
  %src = wave.ptr_add %buffer, %q : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>
  %data, %loaded = wave.load %src : (!wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>) -> (!wave.simd<i32, 64>, !wave.mem.token)
  %dst = wave.ptr_add %out, %tid : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.global, i32>, 64>
  %stored = wave.store %data -> %dst after %loaded : (!wave.simd<i32, 64>, !wave.simd<!wave.ptr<#wave.global, i32>, 64>, !wave.mem.token) -> !wave.mem.token
  return
}
}

// -----

// CHECK-LABEL: func.func @wave64_packed_x(
// CHECK: [[FIRST:%.*]] = waveamdmachine.v_readfirstlane_b32
// CHECK: [[SHIFT:%.*]] = waveamdmachine.imm 6
// CHECK: [[QUOT:%[^,]+]], {{%.*}} = waveamdmachine.s_lshr_b32 [[FIRST]], [[SHIFT]]
// CHECK: [[OFFSET:%[^,]+]], {{%.*}} = waveamdmachine.s_lshl_b32 [[QUOT]],
// CHECK: waveamdmachine.buffer_load_b32 {{%.*}}, {{%.*}}, [[OFFSET]] offset 12
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @wave64_packed_x(%input: !wave.ptr<#wave.global, i32>, %out: !wave.ptr<#wave.global, i32>) attributes {wave.kernel, wave.workgroup_size = array<i32: 128, 2, 1>} {
  %y = wave.workitem_id 1 : !wave.simd<i32, 64>
  %raw = wave.workitem_id 0 : !wave.simd<i32, 64>
  %tid = wave.assume %raw as "x" [#wave.pred<"x >= 0">, #wave.pred<"x <= 255">] : !wave.simd<i32, 64>
  %q = wave.index_expr <"8*floor(1/64*x) + 3"> ["x"](%tid) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
  %size = arith.constant 4096 : i32
  %buffer = waveamd.make_buffer %input, %size : !wave.ptr<#wave.global, i32>, i32 -> !wave.ptr<#waveamd.buffer, i32>
  %src = wave.ptr_add %buffer, %q : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>
  %data, %loaded = wave.load %src : (!wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>) -> (!wave.simd<i32, 64>, !wave.mem.token)
  %dst = wave.ptr_add %out, %tid : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.global, i32>, 64>
  %stored = wave.store %data -> %dst after %loaded : (!wave.simd<i32, 64>, !wave.simd<!wave.ptr<#wave.global, i32>, 64>, !wave.mem.token) -> !wave.mem.token
  return
}
}

// -----

// CHECK-LABEL: func.func @wave64_known_block_size(
// CHECK: [[FIRST:%.*]] = waveamdmachine.v_readfirstlane_b32
// CHECK: [[SHIFT:%.*]] = waveamdmachine.imm 6
// CHECK: [[QUOT:%[^,]+]], {{%.*}} = waveamdmachine.s_lshr_b32 [[FIRST]], [[SHIFT]]
// CHECK: [[OFFSET:%[^,]+]], {{%.*}} = waveamdmachine.s_lshl_b32 [[QUOT]],
// CHECK: waveamdmachine.buffer_load_b32 {{%.*}}, {{%.*}}, [[OFFSET]] offset 12
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @wave64_known_block_size(%input: !wave.ptr<#wave.global, i32>, %out: !wave.ptr<#wave.global, i32>) attributes {wave.kernel, gpu.known_block_size = array<i32: 256, 1, 1>} {
  %raw = wave.workitem_id 0 : !wave.simd<i32, 64>
  %tid = wave.assume %raw as "x" [#wave.pred<"x >= 0">, #wave.pred<"x <= 255">] : !wave.simd<i32, 64>
  %q = wave.index_expr <"8*floor(1/64*x) + 3"> ["x"](%tid) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
  %size = arith.constant 4096 : i32
  %buffer = waveamd.make_buffer %input, %size : !wave.ptr<#wave.global, i32>, i32 -> !wave.ptr<#waveamd.buffer, i32>
  %src = wave.ptr_add %buffer, %q : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>
  %data, %loaded = wave.load %src : (!wave.simd<!wave.ptr<#waveamd.buffer, i32>, 64>) -> (!wave.simd<i32, 64>, !wave.mem.token)
  %dst = wave.ptr_add %out, %tid : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.global, i32>, 64>
  %stored = wave.store %data -> %dst after %loaded : (!wave.simd<i32, 64>, !wave.simd<!wave.ptr<#wave.global, i32>, 64>, !wave.mem.token) -> !wave.mem.token
  return
}
}

// -----

// CHECK-LABEL: func.func @wave64_wide_offset(
// CHECK: [[FIRST:%.*]] = waveamdmachine.v_readfirstlane_b32
// CHECK: [[SHIFT:%.*]] = waveamdmachine.imm 6
// CHECK: [[QUOT:%[^,]+]], {{%.*}} = waveamdmachine.s_lshr_b32 [[FIRST]], [[SHIFT]]
// CHECK-NOT: waveamdmachine.v_lshrrev_b32
// CHECK: waveamdmachine.global_load_b32
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @wave64_wide_offset(%input: !wave.ptr<#wave.global, i32>, %out: !wave.ptr<#wave.global, i32>) attributes {wave.kernel, wave.workgroup_size = array<i32: 256, 1, 1>} {
  %raw = wave.workitem_id 0 : !wave.simd<i32, 64>
  %tid = wave.assume %raw as "x" [#wave.pred<"x >= 0">, #wave.pred<"x <= 255">] : !wave.simd<i32, 64>
  %q = wave.index_expr <"4294967296*floor(1/64*x) + x"> ["x"](%tid) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
  %src = wave.ptr_add %input, %q : !wave.ptr<#wave.global, i32>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.global, i32>, 64>
  %data, %loaded = wave.load %src : (!wave.simd<!wave.ptr<#wave.global, i32>, 64>) -> (!wave.simd<i32, 64>, !wave.mem.token)
  %dst = wave.ptr_add %out, %tid : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.global, i32>, 64>
  %stored = wave.store %data -> %dst after %loaded : (!wave.simd<i32, 64>, !wave.simd<!wave.ptr<#wave.global, i32>, 64>, !wave.mem.token) -> !wave.mem.token
  return
}
}

// -----

// CHECK-LABEL: func.func @wave64_shared_quotient_across_loop(
// CHECK: [[THREAD:%.*]] = waveamdmachine.v_workitem_id_x
// CHECK: [[FIRST:%.*]] = waveamdmachine.v_readfirstlane_b32 [[THREAD]]
// CHECK: [[SHIFT:%.*]] = waveamdmachine.imm 6
// CHECK: [[QUOT:%[^,]+]], {{%.*}} = waveamdmachine.s_lshr_b32 [[FIRST]], [[SHIFT]]
// CHECK-NOT: waveamdmachine.v_readfirstlane_b32
// CHECK: waveamdmachine.uniform_loop
// CHECK-NOT: waveamdmachine.v_readfirstlane_b32
// CHECK: waveamdmachine.s_lshl_b32 [[QUOT]],
// CHECK-NOT: waveamdmachine.v_readfirstlane_b32
// CHECK: [[HALF:%[^,]+]], {{%.*}} = waveamdmachine.s_lshr_b32 [[QUOT]],
// CHECK-NOT: waveamdmachine.v_readfirstlane_b32
// CHECK: waveamdmachine.s_lshl_b32 [[HALF]],
// CHECK-NOT: waveamdmachine.v_readfirstlane_b32
// CHECK: waveamdmachine.s_endpgm
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @wave64_shared_quotient_across_loop(%out: !wave.ptr<#wave.global, i32>, %n: i32)
    attributes {wave.kernel, wave.workgroup_size = array<i32: 256, 1, 1>} {
  %raw = wave.workitem_id 0 : !wave.simd<i32, 64>
  %tid = wave.assume %raw as "x"
      [#wave.pred<"x >= 0">, #wave.pred<"x <= 255">] : !wave.simd<i32, 64>
  %c0 = arith.constant 0 : i32
  %c1 = arith.constant 1 : i32
  %zero = wave.constant 0 : i32 -> !wave.simd<i32, 64>
  %sum = scf.for %i = %c0 to %n step %c1 iter_args(%acc = %zero)
      -> (!wave.simd<i32, 64>) : i32 {
    %q = wave.index_expr <"8*floor(1/64*x) + 3"> ["x"](%tid)
        : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
    %data = wave.cast intconvert %q
        : !wave.simd<index, 64> -> !wave.simd<i32, 64>
    %next = wave.binary addi %acc, %data
        : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
    scf.yield %next : !wave.simd<i32, 64>
  }
  %offset = wave.index_expr <"x + 8*floor(1/128*x)"> ["x"](%tid)
      : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
  %dst = wave.ptr_add %out, %offset
      : !wave.ptr<#wave.global, i32>, !wave.simd<index, 64>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 64>
  %stored = wave.store %sum -> %dst
      : (!wave.simd<i32, 64>, !wave.simd<!wave.ptr<#wave.global, i32>, 64>)
      -> !wave.mem.token
  return
}
}
