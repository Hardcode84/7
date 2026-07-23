// RUN: wave-opt --waveamd-to-machine --waveamd-buffer-rsrc-to-tuples %s \
// RUN:   | wave-translate --wave-to-amdgpu-asm - \
// RUN:   | FileCheck %s --check-prefix=ASM
// RUN: wave-opt --waveamd-to-machine --waveamd-buffer-rsrc-to-tuples %s \
// RUN:   | wave-translate --wave-to-amdgpu-asm - \
// RUN:   | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx1100 -filetype=obj -o /dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// ASM-LABEL: buffer_selected_oob_load_codegen:
// ASM: v_mov_b32_e32 [[LOAD_OOB:v[0-9]+]], 0x80000000
// ASM: v_cndmask_b32_e64 [[LOAD_VOFF:v[0-9]+]], [[LOAD_OOB]], {{v[0-9]+}}, {{s[0-9]+}}
// ASM: buffer_load_b32 {{v[0-9]+}}, [[LOAD_VOFF]], {{s\[[0-9]+:[0-9]+\]}}, 0 offen
func.func @buffer_selected_oob_load_codegen(
    %in: !wave.ptr<#wave.global, i32>, %out: !wave.ptr<#wave.global, i32>,
    %raw: i32) attributes {wave.kernel} {
  %range = arith.constant 128 : i32
  %u = wave.assume %raw as "x" [#wave.pred<"x >= 0">, #wave.pred<"x <= 1023">] : i32
  %buffer = waveamd.make_buffer %in, %range
      : !wave.ptr<#wave.global, i32>, i32 -> !wave.ptr<#waveamd.buffer, i32>
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %limit = arith.constant 16 : i32
  %vlimit = wave.splat %limit : i32 -> !wave.simd<i32, 32>
  %mask = wave.cmpi ult %lane, %vlimit
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %active = wave.index_expr <"u + lid"> ["u", "lid"](%u, %lane)
      : (i32, !wave.simd<i32, 32>) -> !wave.simd<index, 32>
  %oob_source = arith.constant 1073741824 : index
  %oob = wave.index_expr <"floor(1/2*x)">
      assuming [#wave.pred<"x >= 0">] ["x"](%oob_source)
      : (index) -> index
  %oob_simd = wave.splat %oob : index -> !wave.simd<index, 32>
  %active_ptr = wave.ptr_add %buffer, %active
      : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<index, 32>
      -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>
  %oob_ptr = wave.ptr_add %buffer, %oob_simd
      : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<index, 32>
      -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>
  %selected = wave.select %mask, %active_ptr, %oob_ptr
      : !wave.mask<32>, !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>
  %v, %tok = wave.load %selected
      : (!wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>)
      -> (!wave.simd<i32, 32>, !wave.mem.token)
  %optrs = wave.ptr_add %out, %lane
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %store_token = wave.store %v -> %optrs after %tok
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.global, i32>, 32>,
         !wave.mem.token)
      -> !wave.mem.token
  return
}

// ASM-LABEL: buffer_selected_oob_store_codegen:
// ASM: v_mov_b32_e32 [[STORE_OOB:v[0-9]+]], 0x80000000
// ASM: v_cndmask_b32_e64 [[STORE_VOFF:v[0-9]+]], [[STORE_OOB]], {{v[0-9]+}}, {{s[0-9]+}}
// ASM: buffer_store_b32 {{v[0-9]+}}, [[STORE_VOFF]], {{s\[[0-9]+:[0-9]+\]}}, 0 offen
func.func @buffer_selected_oob_store_codegen(
    %out: !wave.ptr<#wave.global, i32>, %raw: i32) attributes {wave.kernel} {
  %range = arith.constant 128 : i32
  %u = wave.assume %raw as "x" [#wave.pred<"x >= 0">, #wave.pred<"x <= 1023">] : i32
  %buffer = waveamd.make_buffer %out, %range
      : !wave.ptr<#wave.global, i32>, i32 -> !wave.ptr<#waveamd.buffer, i32>
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %limit = arith.constant 16 : i32
  %vlimit = wave.splat %limit : i32 -> !wave.simd<i32, 32>
  %mask = wave.cmpi ult %lane, %vlimit
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.mask<32>
  %active = wave.index_expr <"u + lid"> ["u", "lid"](%u, %lane)
      : (i32, !wave.simd<i32, 32>) -> !wave.simd<index, 32>
  %oob = arith.constant 536870912 : index
  %oob_simd = wave.splat %oob : index -> !wave.simd<index, 32>
  %active_ptr = wave.ptr_add %buffer, %active
      : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<index, 32>
      -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>
  %oob_ptr = wave.ptr_add %buffer, %oob_simd
      : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<index, 32>
      -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>
  %selected = wave.select %mask, %active_ptr, %oob_ptr
      : !wave.mask<32>, !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>
  %tok = wave.store %lane -> %selected
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>)
      -> !wave.mem.token
  return
}

}
