// RUN: wave-opt %s --wave-set-target-attr=chip=gfx1100 -o %t.mlir
// RUN: wave-translate %t.mlir --wave-to-amdgpu-asm -o %t.s
// RUN: FileCheck %s < %t.s
// RUN: llvm-mc --triple=amdgcn-amd-amdhsa --mcpu=gfx1100 --filetype=obj %t.s -o /dev/null
// CHECK-LABEL: preserve_effects:
// CHECK-COUNT-3: buffer_store_b32
// CHECK-NOT: buffer_store_b32
// CHECK: s_endpgm

// Loads read the same untouched range; both preceding stores remain required.
module {
func.func @preserve_effects(%out: !wave.ptr<#wave.global, i32>) -> (!wave.mem.token, !wave.mem.token, !wave.mem.token) attributes {wave.kernel, wave.workgroup_size = array<i32: 32, 1, 1>, wave.waves_per_workgroup = 1 : i64} {
 %lane = wave.lane_id : !wave.simd<i32, 32>
 %offA = wave.index_expr <"x"> ["x"](%lane) : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
 %offB = wave.index_expr <"64 + x"> ["x"](%lane) : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
 %offR = wave.index_expr <"128 + x"> ["x"](%lane) : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
 %offO = wave.index_expr <"192 + x"> ["x"](%lane) : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
 %a = wave.ptr_add %out, %offA : !wave.ptr<#wave.global, i32>, !wave.simd<index, 32> -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
 %b = wave.ptr_add %out, %offB : !wave.ptr<#wave.global, i32>, !wave.simd<index, 32> -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
 %r = wave.ptr_add %out, %offR : !wave.ptr<#wave.global, i32>, !wave.simd<index, 32> -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
 %o = wave.ptr_add %out, %offO : !wave.ptr<#wave.global, i32>, !wave.simd<index, 32> -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
 %sa = wave.store %lane -> %a : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.global, i32>, 32>) -> !wave.mem.token
 %va, %ta = wave.load %r after %sa : (!wave.simd<!wave.ptr<#wave.global, i32>, 32>, !wave.mem.token) -> (!wave.simd<i32, 32>, !wave.mem.token)
 %sb = wave.store %lane -> %b : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.global, i32>, 32>) -> !wave.mem.token
 %vb, %tb = wave.load %r after %sb : (!wave.simd<!wave.ptr<#wave.global, i32>, 32>, !wave.mem.token) -> (!wave.simd<i32, 32>, !wave.mem.token)
 %choice = wave.materialization_variants %va, %vb : !wave.simd<i32, 32>
 %done = wave.store %choice -> %o : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.global, i32>, 32>) -> !wave.mem.token
 return %sa, %sb, %done : !wave.mem.token, !wave.mem.token, !wave.mem.token
}
}
