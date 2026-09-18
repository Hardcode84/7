// REQUIRES: host-supports-amdgpu-gfx942 || host-supports-amdgpu-gfx950
// REQUIRES: host-has-hip-runtime
// RUN: wave-opt %S/Inputs/wide_dma.mlir --wave-set-target-attr=chip=%chip -o %t.input
// RUN: wave-opt %t.input --waveamd-dma-zero-fill --wave-extract-loop-strides -o %t.before
// RUN: wave-opt %t.input --wave-extract-loop-strides --waveamd-dma-zero-fill -o %t.after
// RUN: FileCheck %s --check-prefix=IR < %t.before
// RUN: FileCheck %s --check-prefix=IR < %t.after
// RUN: diff %t.before %t.after
// RUN: wave-opt %t.input --waveamd-to-machine | wave-translate --wave-to-amdgpu-asm -o %t.baseline.s
// RUN: wave-translate %t.before --wave-to-amdgpu-asm -o %t.before.s
// RUN: wave-translate %t.after --wave-to-amdgpu-asm -o %t.after.s
// RUN: diff %t.before.s %t.after.s
// RUN: FileCheck %s --check-prefix=ASM < %t.before.s
// RUN: llvm-mc --triple=amdgcn-amd-amdhsa --mcpu=%chip --filetype=obj %t.baseline.s -o %t.baseline.o
// RUN: llvm-mc --triple=amdgcn-amd-amdhsa --mcpu=%chip --filetype=obj %t.before.s -o %t.before.o
// RUN: ld.lld --shared %t.baseline.o -o %t.baseline.hsaco
// RUN: ld.lld --shared %t.before.o -o %t.before.hsaco
// RUN: env LD_LIBRARY_PATH=%rocm_lib %python %S/Inputs/wide_dma_runner.py --hip-lib=%hip_runtime_lib %t.baseline.hsaco %t.before.hsaco | FileCheck %s
// IR: scf.for
// IR: wave.where
// IR: waveamd.dma_load_lds {{.*}}zero_fill_inactive
// IR: otherwise
// IR: scf.yield
// IR: return
// ASM: s_and_saveexec_b64
// ASM-NOT: buffer_load
// ASM: global_load{{.*}}lds
// ASM: s_{{(or|mov)}}_b64 exec
// CHECK: Wide DMA: 2 forms, 16 cases, 128 words passed
