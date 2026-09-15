// RUN: wave-opt %s --wave-set-target-attr=chip=gfx1100 --wave-promote-global-to-buffer | FileCheck %s --check-prefix=IR
// RUN: wave-opt %s --wave-set-target-attr=chip=gfx1100 | wave-translate --wave-to-amdgpu-asm > %t.s
// RUN: FileCheck %s --check-prefix=ASM < %t.s
// RUN: llvm-mc --triple=amdgcn-amd-amdhsa --mcpu=gfx1100 --filetype=obj %t.s -o /dev/null
// IR-LABEL: func.func @narrow_buffer
// IR: waveamd.make_buffer
// IR: wave.ptr_cast
// IR: wave.index_expr <"lane">
// IR-NOT: Mod(
// IR: wave.store
// ASM-LABEL: narrow_buffer:
// ASM-COUNT-2: buffer_store_b32
// ASM: s_endpgm

module {
func.func @narrow_buffer(%out: !wave.ptr<#wave.global, i32>) -> !wave.mem.token attributes {wave.kernel, wave.workgroup_size = array<i32: 32, 1, 1>} {
  %lane = wave.lane_id : !wave.simd<i32, 32>
  %initial_ptrs = wave.ptr_add %out, %lane
      : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#wave.global, i32>, 32>
  %sentinel = wave.constant -1 : i32 -> !wave.simd<i32, 32>
  %initial = wave.store %sentinel -> %initial_ptrs
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#wave.global, i32>, 32>) -> !wave.mem.token
  %bytes = wave.ptr_cast %out : !wave.ptr<#wave.global, i32> -> !wave.ptr<#wave.global, i8>
  %range = arith.constant 64 : i32
  %buffer = waveamd.make_buffer %bytes, %range
      : !wave.ptr<#wave.global, i8>, i32 -> !wave.ptr<#waveamd.buffer, i8>
  %shift = arith.constant 16 : i32
  %shifted = wave.ptr_add %buffer, %shift
      : !wave.ptr<#waveamd.buffer, i8>, i32 -> !wave.ptr<#waveamd.buffer, i8>
  %words = wave.ptr_cast %shifted : !wave.ptr<#waveamd.buffer, i8> -> !wave.ptr<#waveamd.buffer, i32>
  %offset = wave.index_expr <"lane">
      assuming [#wave.pred<"lane >= 0">, #wave.pred<"lane <= 63">]
      ["lane"](%lane) : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
  %ptrs = wave.ptr_add %words, %offset
      : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<index, 32>
      -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>
  %one = arith.constant 1 : i32
  %value = wave.binary addi %lane, %one : !wave.simd<i32, 32>, i32 -> !wave.simd<i32, 32>
  %done = wave.store %value -> %ptrs after %initial
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>, !wave.mem.token) -> !wave.mem.token
  return %done : !wave.mem.token
}
}
