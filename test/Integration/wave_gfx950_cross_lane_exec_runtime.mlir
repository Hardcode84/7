// REQUIRES: host-supports-amdgpu-gfx950, host-has-hip-runtime
// RUN: %python %S/Inputs/cross_lane_exec.py --emit-mlir > %t.mlir
// RUN: mkdir -p %t.original
// RUN: sed 's/"waveamd-cross-lane-peepholes"/"canonicalize"/' %wave_pipelines > %t.original/pipelines.mlir
// RUN: env WAVE_PIPELINES_DIR=%t.original wave-translate %t.mlir --wave-to-amdgpu-asm -o %t.original.s
// RUN: wave-translate %t.mlir --wave-to-amdgpu-asm -o %t.optimized.s
// RUN: llvm-mc --triple=amdgcn-amd-amdhsa --mcpu=gfx950 --filetype=obj %t.original.s -o %t.original.o
// RUN: llvm-mc --triple=amdgcn-amd-amdhsa --mcpu=gfx950 --filetype=obj %t.optimized.s -o %t.optimized.o
// RUN: ld.lld --shared %t.original.o -o %t.original.hsaco
// RUN: ld.lld --shared %t.optimized.o -o %t.optimized.hsaco
// RUN: env LD_LIBRARY_PATH=%rocm_lib %python %S/Inputs/cross_lane_exec_runner.py --hip-lib=%hip_runtime_lib %t.original.hsaco %t.optimized.hsaco | FileCheck %s
// CHECK: Cross-lane EXEC: 50 kernels, 4 waves, 51200 outputs passed
