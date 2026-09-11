// RUN: wave-opt %s --pass-pipeline='builtin.module(transform-preload-library{transform-library-paths=%wave_pipelines},transform-interpreter{entry-point=waveamd_backend})' \
// RUN:   | env WAVE_PIPELINES_DIR=%S/../Target/Wave/Inputs/emit-only-pipeline wave-translate --wave-to-amdgpu-asm - \
// RUN:   | FileCheck %s --check-prefix=ASM
// RUN: wave-opt %s --pass-pipeline='builtin.module(transform-preload-library{transform-library-paths=%wave_pipelines},transform-interpreter{entry-point=waveamd_backend})' \
// RUN:   | env WAVE_PIPELINES_DIR=%S/../Target/Wave/Inputs/emit-only-pipeline wave-translate --wave-to-amdgpu-asm - \
// RUN:   | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx950 -filetype=obj -o /dev/null

// ASM-LABEL: uniform_thread_quotient_wave64:
// ASM: v_readfirstlane_b32 [[FIRST:s[0-9]+]],
// ASM: s_lshr_b32 [[QUOT:s[0-9]+]], [[FIRST]], 6
// ASM: s_lshl_b32 [[OFFSET:s[0-9]+]], [[QUOT]], 5
// ASM: buffer_load_{{[a-z0-9]+}} {{.*}}, [[OFFSET]] offen offset:12
// ASM: buffer_store_
// ASM: s_endpgm
module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @uniform_thread_quotient_wave64(%input: !wave.ptr<#wave.global, i32>, %out: !wave.ptr<#wave.global, i32>) attributes {wave.kernel, wave.workgroup_size = array<i32: 256, 1, 1>} {
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
