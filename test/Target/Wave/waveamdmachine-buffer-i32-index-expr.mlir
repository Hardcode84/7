// RUN: wave-opt --wave-generate-index-exprs --waveamd-to-machine %s | FileCheck %s

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1100"} {

// CHECK-LABEL: func.func @generated_bounded_buffer_xor
// CHECK: waveamdmachine.buffer_store_b32
func.func @generated_bounded_buffer_xor(%out: !wave.ptr<#wave.global, i32>,
                                        %raw_idx: !wave.simd<i32, 32>)
    attributes {wave.kernel} {
  %range = arith.constant 4096 : i32
  %buf = waveamd.make_buffer %out, %range
      : !wave.ptr<#wave.global, i32>, i32 -> !wave.ptr<#waveamd.buffer, i32>
  %idx = wave.assume %raw_idx as "x" [#wave.pred<"x >= 0">, #wave.pred<"x <= 31">]
      : !wave.simd<i32, 32>
  %c1 = arith.constant 1 : i32
  %s1 = wave.splat %c1 : i32 -> !wave.simd<i32, 32>
  %off = wave.binary xori %idx, %s1
      : !wave.simd<i32, 32>, !wave.simd<i32, 32> -> !wave.simd<i32, 32>
  %ptrs = wave.ptr_add %buf, %off
      : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<i32, 32>
      -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>
  %tok = wave.store %idx -> %ptrs
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>)
      -> !wave.mem.token
  return
}

// CHECK-LABEL: func.func @identity_bounded_buffer_offset
// CHECK: waveamdmachine.buffer_store_b32
func.func @identity_bounded_buffer_offset(%out: !wave.ptr<#wave.global, i32>,
                                          %raw: !wave.simd<i32, 32>)
    attributes {wave.kernel} {
  %range = arith.constant 4096 : i32
  %buf = waveamd.make_buffer %out, %range
      : !wave.ptr<#wave.global, i32>, i32 -> !wave.ptr<#waveamd.buffer, i32>
  %off = wave.index_expr <"raw0"> assuming [#wave.pred<"raw0 >= 0 & -31 + raw0 <= 0">] ["raw0"](%raw)
      : (!wave.simd<i32, 32>) -> !wave.simd<index, 32>
  %ptrs = wave.ptr_add %buf, %off
      : !wave.ptr<#waveamd.buffer, i32>, !wave.simd<index, 32>
      -> !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>
  %tok = wave.store %raw -> %ptrs
      : (!wave.simd<i32, 32>, !wave.simd<!wave.ptr<#waveamd.buffer, i32>, 32>)
      -> !wave.mem.token
  return
}

}
