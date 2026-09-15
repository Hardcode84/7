// SPDX-FileCopyrightText: 2026 wave-mlir contributors
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// RUN: wave-translate %s --wave-to-amdgpu-asm -o %t.s
// RUN: FileCheck %s < %t.s
// RUN: llvm-mc --triple=amdgcn-amd-amdhsa --mcpu=gfx950 --filetype=obj %t.s -o /dev/null

// Lane address outside both loops; outer offset outside inner loop.
// CHECK-LABEL: lds_loop_address:
// CHECK: v_lshlrev_b32_e32 [[LANE:v[0-9]+]], 2, {{v[0-9]+}}
// CHECK: [[OUTER:.Llds_loop_address.loop_head_[0-9]+]]:
// CHECK: s_lshl_b32 [[OUTER_OFFSET:s[0-9]+]], {{s[0-9]+}}, 8
// CHECK: v_add_u32_e32 [[PARTIAL:v[0-9]+]], [[OUTER_OFFSET]], [[LANE]]
// CHECK: [[INNER:.Llds_loop_address.loop_head_[0-9]+]]:
// CHECK: s_lshl_b32 [[INNER_OFFSET:s[0-9]+]], {{s[0-9]+}}, 10
// CHECK: v_add_u32_e32 [[ADDRESS:v[0-9]+]], [[INNER_OFFSET]], [[PARTIAL]]
// CHECK: ds_write_b32 [[ADDRESS]], {{v[0-9]+}}
// CHECK-NOT: v_add
// CHECK: s_cbranch_scc1 [[INNER]]
// CHECK: s_cbranch_scc1 [[OUTER]]
// CHECK: ds_read_b32
// CHECK: buffer_store_dword
// CHECK: s_endpgm

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @lds_loop_address(%out: !wave.ptr<#wave.global, i32>, %limit: i32) -> !wave.mem.token
    attributes {wave.kernel, wave.workgroup_size = array<i32: 64, 1, 1>} {
  %bounded_limit = wave.assume %limit as "n" [#wave.pred<"n >= 1">, #wave.pred<"n <= 4">] : i32
  %zero = arith.constant 0 : i32
  %one = arith.constant 1 : i32
  %four = arith.constant 4 : i32
  %scratch = wave.alloc() {align = 16 : i64, bytesize = 4096 : i64} : !wave.ptr<#wave.shared, i32>
  %lane = wave.workitem_id 0 : !wave.simd<i32, 64>
  %root = wave.token : !wave.mem.token
  %done = scf.for %outer = %zero to %four step %one iter_args(%previous = %root) -> !wave.mem.token : i32 {
    %written = scf.for %inner = %zero to %bounded_limit step %one iter_args(%dep = %previous) -> !wave.mem.token : i32 {
      %address = wave.index_expr <"lane + 64*outer + 256*inner"> ["lane", "outer", "inner"](%lane, %outer, %inner)
          : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %ptr = wave.ptr_add %scratch, %address : !wave.ptr<#wave.shared, i32>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i32>, 64>
      %t = wave.store %lane -> %ptr after %dep : (!wave.simd<i32, 64>, !wave.simd<!wave.ptr<#wave.shared, i32>, 64>, !wave.mem.token) -> !wave.mem.token
      scf.yield %t : !wave.mem.token
    }
    scf.yield %written : !wave.mem.token
  }
  %ptr = wave.ptr_add %scratch, %lane : !wave.ptr<#wave.shared, i32>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, i32>, 64>
  %value, %read = wave.load %ptr after %done : (!wave.simd<!wave.ptr<#wave.shared, i32>, 64>, !wave.mem.token) -> (!wave.simd<i32, 64>, !wave.mem.token)
  %dst = wave.ptr_add %out, %lane : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.global, i32>, 64>
  %stored = wave.store %value -> %dst after %read : (!wave.simd<i32, 64>, !wave.simd<!wave.ptr<#wave.global, i32>, 64>, !wave.mem.token) -> !wave.mem.token
  return %stored : !wave.mem.token
}
}
