// REQUIRES: host-supports-amdgpu-wave, host-has-hip-runtime
// RUN: sed -e 's/CHIP/%chip/g' -e 's/WAVE_WIDTH/%wave_width/g' %s > %t.mlir
// RUN: wave-translate --wave-to-amdgpu-asm %t.mlir > %t.s
// RUN: llvm-mc --triple=amdgcn-amd-amdhsa --mcpu=%chip --filetype=obj %t.s -o %t.o
// RUN: ld.lld --shared %t.o -o %t.hsaco
// RUN: env LD_LIBRARY_PATH=%rocm_lib %python %S/Inputs/symbolic_offsets_runner.py \
// RUN:   --hip-lib=%hip_runtime_lib --kernel=equal_cost_symbolic_offsets --stride=4 %t.hsaco | FileCheck %s

// CHECK: equal_cost_symbolic_offsets: 3072 output and guard values passed

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--CHIP"} {
func.func @equal_cost_symbolic_offsets(%input: !wave.ptr<#wave.global, i32>,
    %out: !wave.ptr<#wave.global, i32>, %k_raw: i32) -> !wave.mem.token
    attributes {wave.kernel, wave.workgroup_size = array<i32: 64, 1, 1>} {
  %tid = wave.workitem_id 0 : !wave.simd<i32, WAVE_WIDTH>
  %src = wave.ptr_add %input, %tid : !wave.ptr<#wave.global, i32>, !wave.simd<i32, WAVE_WIDTH> -> !wave.simd<!wave.ptr<#wave.global, i32>, WAVE_WIDTH>
  %raw, %read = wave.load %src : (!wave.simd<!wave.ptr<#wave.global, i32>, WAVE_WIDTH>) -> (!wave.simd<i32, WAVE_WIDTH>, !wave.mem.token)
  %x = wave.assume %raw as "x" [#wave.pred<"x >= 0">, #wave.pred<"x <= 63">] : !wave.simd<i32, WAVE_WIDTH>
  %k = wave.assume %k_raw as "k" [#wave.pred<"k >= 0">, #wave.pred<"k <= 31">] : i32
  %twice = wave.binary addi %x, %x overflow<nsw> : !wave.simd<i32, WAVE_WIDTH>, !wave.simd<i32, WAVE_WIDTH> -> !wave.simd<i32, WAVE_WIDTH>
  %half = arith.constant 512 : index
  %second = wave.ptr_add %out, %half : !wave.ptr<#wave.global, i32>, index -> !wave.ptr<#wave.global, i32>
  %factored = wave.index_expr <"4*(K + x)"> ["K", "x"](%k, %x) : (i32, !wave.simd<i32, WAVE_WIDTH>) -> !wave.simd<index, WAVE_WIDTH>
  %expanded = wave.index_expr <"4*K + 4*x"> ["K", "x"](%k, %x) : (i32, !wave.simd<i32, WAVE_WIDTH>) -> !wave.simd<index, WAVE_WIDTH>
  %a = wave.ptr_add %out, %factored : !wave.ptr<#wave.global, i32>, !wave.simd<index, WAVE_WIDTH> -> !wave.simd<!wave.ptr<#wave.global, i32>, WAVE_WIDTH>
  %b = wave.ptr_add %second, %expanded : !wave.ptr<#wave.global, i32>, !wave.simd<index, WAVE_WIDTH> -> !wave.simd<!wave.ptr<#wave.global, i32>, WAVE_WIDTH>
  %first_write = wave.store %x -> %a after %read : (!wave.simd<i32, WAVE_WIDTH>, !wave.simd<!wave.ptr<#wave.global, i32>, WAVE_WIDTH>, !wave.mem.token) -> !wave.mem.token
  %second_write = wave.store %twice -> %b after %first_write : (!wave.simd<i32, WAVE_WIDTH>, !wave.simd<!wave.ptr<#wave.global, i32>, WAVE_WIDTH>, !wave.mem.token) -> !wave.mem.token
  return %second_write : !wave.mem.token
}
}
