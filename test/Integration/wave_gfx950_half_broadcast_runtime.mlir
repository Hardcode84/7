// REQUIRES: host-supports-amdgpu-gfx950, host-has-hip-runtime
// RUN: mkdir -p %t.original
// RUN: sed 's/"waveamd-cross-lane-peepholes"/"canonicalize"/' %wave_pipelines > %t.original/pipelines.mlir
// RUN: env WAVE_PIPELINES_DIR=%t.original wave-translate %S/wave_gfx950_half_broadcast_codegen.mlir --wave-to-amdgpu-asm -o %t.original.s
// RUN: FileCheck %s --check-prefix=ORIGINAL < %t.original.s
// RUN: wave-translate %S/wave_gfx950_half_broadcast_codegen.mlir --wave-to-amdgpu-asm -o %t.optimized.s
// RUN: FileCheck %S/wave_gfx950_half_broadcast_codegen.mlir --check-prefix=ASM < %t.optimized.s
// RUN: llvm-mc --triple=amdgcn-amd-amdhsa --mcpu=gfx950 --filetype=obj %t.original.s -o %t.original.o
// RUN: llvm-mc --triple=amdgcn-amd-amdhsa --mcpu=gfx950 --filetype=obj %t.optimized.s -o %t.optimized.o
// RUN: ld.lld --shared %t.original.o -o %t.original.hsaco
// RUN: ld.lld --shared %t.optimized.o -o %t.optimized.hsaco
// RUN: env LD_LIBRARY_PATH=%rocm_lib %python %S/Inputs/half_broadcast_runner.py --hip-lib=%hip_runtime_lib %t.original.hsaco %t.optimized.hsaco | FileCheck %s
// ORIGINAL-NOT: v_permlane32_swap
// ORIGINAL-COUNT-14: ds_bpermute_b32
// ORIGINAL-NOT: ds_bpermute_b32
// ORIGINAL-NOT: v_permlane32_swap
// CHECK: Half broadcasts: 7 kernels, 4 waves, 7168 outputs passed
