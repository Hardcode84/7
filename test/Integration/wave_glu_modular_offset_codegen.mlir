// RUN: wave-opt %S/../PerfGolden/Inputs/tlx_glu_optimized.mlir --pass-pipeline='builtin.module(transform-preload-library{transform-library-paths=%wave_pipelines},transform-interpreter{entry-point=waveamd_backend_preschedule})' | FileCheck %s --check-prefix=CHOICE
// RUN: wave-translate %S/../PerfGolden/Inputs/tlx_glu_optimized.mlir --wave-to-amdgpu-asm > %t.s
// RUN: FileCheck %s --check-prefix=ASM < %t.s
// RUN: llvm-mc --triple=amdgcn-amd-amdhsa --mcpu=gfx950 --filetype=obj %t.s -o /dev/null

// CHOICE-LABEL: func.func @tlx_addmm_glu_kernel_optimized
// CHOICE: waveamdmachine.materialization_variants
// ASM-LABEL: tlx_addmm_glu_kernel_optimized:
// ASM: buffer_load_dwordx4
// ASM: s_endpgm
