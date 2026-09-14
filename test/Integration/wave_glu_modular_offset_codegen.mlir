// RUN: wave-opt %S/../PerfGolden/Inputs/tlx_glu_optimized.mlir --pass-pipeline='builtin.module(transform-preload-library{transform-library-paths=%wave_pipelines},transform-interpreter{entry-point=waveamd_backend_preschedule})' -o %t.selected
// RUN: FileCheck %s --check-prefix=CHOICE < %t.selected
// RUN: wave-translate %S/../PerfGolden/Inputs/tlx_glu_optimized.mlir --wave-to-amdgpu-asm > %t.s
// RUN: FileCheck %s --check-prefix=ASM < %t.s
// RUN: llvm-mc --triple=amdgcn-amd-amdhsa --mcpu=gfx950 --filetype=obj %t.s -o /dev/null

// CHOICE-LABEL: func.func @tlx_addmm_glu_kernel_optimized
// CHOICE: waveamdmachine.materialization_variants
// ASM-LABEL: tlx_addmm_glu_kernel_optimized:
// ASM: buffer_load_dwordx4
// ASM: s_endpgm

// RUN: wave-opt %t.selected --waveamd-expand-materialization-variants -o %t.expanded
// RUN: wave-opt %t.expanded --pass-pipeline='builtin.module(transform-preload-library{transform-library-paths=%wave_pipelines},transform-interpreter{entry-point=waveamd_cleanup_materialization_variants},waveamd-machine-schedule{apply-schedule})' -o %t.scored
// RUN: FileCheck %s --check-prefix=SCORE < %t.scored
// RUN: wave-opt %t.scored --waveamd-collapse-materialization-variants | FileCheck %s --check-prefix=WINNER --implicit-check-not=waveamdmachine.materialization --implicit-check-not=waveamdmachine.candidate_yield
// RUN: wave-opt %t.selected --pass-pipeline='builtin.module(transform-preload-library{transform-library-paths=%wave_pipelines},transform-interpreter{entry-point=waveamd_select_first_materialization_variants})' | FileCheck %s --check-prefix=WINNER --implicit-check-not=waveamdmachine.materialization --implicit-check-not=waveamdmachine.candidate_yield
// SCORE: waveamdmachine.materialization_candidates
// SCORE: waveamdmachine.candidate_yield {{.*}}cycles = {{[0-9]+}} : i64
// SCORE: waveamdmachine.candidate_yield {{.*}}cycles = {{[0-9]+}} : i64
// WINNER-LABEL: func.func @tlx_addmm_glu_kernel_optimized
// WINNER: waveamdmachine.uniform_loop
