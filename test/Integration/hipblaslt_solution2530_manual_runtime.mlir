// REQUIRES: host-supports-amdgpu-gfx950, host-has-hip-runtime, host-has-hipcc
//
// RUN: llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx950 -filetype=obj \
// RUN:   %S/../../docs/PerfReferences/hipblaslt-gfx950-f16-8192-tn-solution2530-manual.s -o %t.o
// RUN: ld.lld -shared %t.o -o %t.hsaco
// RUN: %hipcc -O2 %S/../../tools/wave-matmul-calibrate/wave-matmul-calibrate-runner.cpp \
// RUN:   -Wl,-rpath,%compiler_rocm_lib -o %t.runner
// RUN: %t.runner --m 256 --n 256 --k 512 --bm 2 --bn 2 \
// RUN:   --wave-m-tiles 8 --wave-n-tiles 8 --wave-k-tiles 2 --wave-size 64 \
// RUN:   --input-type f16 --c-type f16 --kernel-abi hipblaslt \
// RUN:   --output-layout column-major --rand-int \
// RUN:   --iters 1 --warmup 0 %t.hsaco \
// RUN:   Custom_Cijk_Alik_Bljk_HHS_BH_MT256x256x64_MI16x16x1_UserArgs_shortname0_gfx950 \
// RUN:   | FileCheck %s
//
// CHECK: kernel_abi=hipblaslt output_layout=column-major
// CHECK: grid: 1,1,1 block: 256,1,1 waves_per_workgroup=4
// CHECK: output_check: passed mode=strict max_abs_diff=0.000000
