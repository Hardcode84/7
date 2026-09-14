// REQUIRES: host-supports-amdgpu-gfx950, host-has-hip-runtime
// RUN: wave-translate %S/../PerfGolden/Inputs/tlx_glu_optimized.mlir --wave-to-amdgpu-asm -o %t.s
// RUN: llvm-mc --triple=amdgcn-amd-amdhsa --mcpu=gfx950 --filetype=obj %t.s -o %t.o
// RUN: ld.lld --shared %t.o -o %t.hsaco
// RUN: env LD_LIBRARY_PATH=%rocm_lib %python %S/Inputs/glu_materialization_runner.py --hip-lib=%hip_runtime_lib %t.hsaco | FileCheck %s

// RUN: wave-opt %S/../PerfGolden/Inputs/tlx_glu_optimized.mlir --pass-pipeline='builtin.module(transform-preload-library{transform-library-paths=%wave_pipelines},transform-interpreter{entry-point=waveamd_backend_unscheduled})' -o %t.baseline.mlir
// RUN: env WAVE_PIPELINES_DIR=%S/../Target/Wave/Inputs/emit-only-pipeline wave-translate %t.baseline.mlir --wave-to-amdgpu-asm -o %t.baseline.s
// RUN: llvm-mc --triple=amdgcn-amd-amdhsa --mcpu=gfx950 --filetype=obj %t.baseline.s -o %t.baseline.o
// RUN: ld.lld --shared %t.baseline.o -o %t.baseline.hsaco
// RUN: env LD_LIBRARY_PATH=%rocm_lib %python %S/Inputs/glu_materialization_runner.py --hip-lib=%hip_runtime_lib %t.baseline.hsaco | FileCheck %s

// CHECK: GLU materialization: 32768 outputs passed
