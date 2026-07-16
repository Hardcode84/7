// RUN: wave-opt %s --pass-pipeline='builtin.module(transform-preload-library{transform-library-paths=%wave_pipelines},transform-interpreter{entry-point=waveamd_backend})' \
// RUN:   | env WAVE_PIPELINES_DIR=%S/../Target/Wave/Inputs/emit-only-pipeline wave-translate --wave-to-amdgpu-asm - \
// RUN:   | FileCheck %s --check-prefix=ASM
// RUN: wave-opt %s --pass-pipeline='builtin.module(transform-preload-library{transform-library-paths=%wave_pipelines},transform-interpreter{entry-point=waveamd_backend})' \
// RUN:   | env WAVE_PIPELINES_DIR=%S/../Target/Wave/Inputs/emit-only-pipeline wave-translate --wave-to-amdgpu-asm - \
// RUN:   | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx950 -filetype=obj -o /dev/null

module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {

// ASM-LABEL: gfx950_phased_dma_lowering_codegen:
// ASM-COUNT-1: v_readfirstlane_b32
// ASM: s_lshr_b32
// ASM: s_cmp_ge_u32
// ASM: s_cselect_b32
// ASM: s_mov_b32 vcc_lo,
// ASM: buffer_load_dwordx4
// ASM: s_cbranch_vccnz [[SKIP:.Lgfx950_phased_dma_lowering_codegen.dma_issue_delay_0]]
// ASM-NEXT: s_nop 15
// ASM-NEXT: s_nop 0
// ASM-NEXT: [[SKIP]]:
// ASM-NEXT: buffer_load_dwordx4
// ASM: buffer_load_dwordx4
// ASM: s_endpgm
func.func @gfx950_phased_dma_lowering_codegen(
    %in: !wave.ptr<#wave.global, i32>)
    attributes {wave.kernel, wave.lds_size = 2048 : i64,
                wave.workgroup_size = array<i32: 128, 1, 1>,
                waveamdmachine.kernarg_preload_length = 2 : i64} {
  %c0 = arith.constant 0 : index
  %c1 = arith.constant 1 : index
  %c2 = arith.constant 2 : index
  %c256 = arith.constant 256 : index
  %wi_raw = wave.workitem_id 0 : !wave.simd<i32, 64>
  %wi = wave.assume %wi_raw as "w"
      [#wave.pred<"w >= 0">, #wave.pred<"w <= 127">]
      : !wave.simd<i32, 64>
  %lds = wave.shared_memory_base : !wave.ptr<#wave.shared, i32>
  %next_lds = wave.ptr_add %lds, %c256
      : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
  %root = wave.token : !wave.mem.token
  %result = scf.for %i = %c0 to %c2 step %c1 iter_args(%base = %in)
      -> (!wave.ptr<#wave.global, i32>) {
    %src = wave.ptr_add %base, %wi
        : !wave.ptr<#wave.global, i32>, !wave.simd<i32, 64>
        -> !wave.simd<!wave.ptr<#wave.global, i32>, 64>
    %first = waveamd.dma_load_lds %src -> %lds after %root
        {bytes = 16 : i64}
        : (!wave.simd<!wave.ptr<#wave.global, i32>, 64>,
           !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
    %second = waveamd.dma_load_lds %src -> %next_lds after %root
        {bytes = 16 : i64, issue_delay_cycles = 17 : i64,
         issue_delay_overlap_cycles = 3 : i64,
         issue_delay_skip_thread_threshold = 64 : i64}
        : (!wave.simd<!wave.ptr<#wave.global, i32>, 64>,
           !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
    %third = waveamd.dma_load_lds %src -> %next_lds after %root
        {bytes = 16 : i64}
        : (!wave.simd<!wave.ptr<#wave.global, i32>, 64>,
           !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
    scf.yield %base : !wave.ptr<#wave.global, i32>
  }
  return
}

}
