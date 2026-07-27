// REQUIRES: wave-python-bindings
//
// RUN: %python %S/../../examples/wave/streamk_f16_gemm.py \
// RUN:   --chip=gfx950 --m=512 --n=512 --k=256 --workers=2 \
// RUN:   --cta-swizzle-xcds=1 --cta-group-m=1 2>/dev/null \
// RUN:   | wave-opt --pass-pipeline='builtin.module(wave-set-target-attr{chip=gfx950})' \
// RUN:   | wave-translate --wave-to-amdgpu-asm - > %t.aligned.s 2>/dev/null
// RUN: FileCheck %s --check-prefix=ALIGNED --input-file=%t.aligned.s
// RUN: llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx950 \
// RUN:   -filetype=obj %t.aligned.s -o /dev/null
// RUN: %python %S/../../examples/wave/streamk_f16_gemm.py \
// RUN:   --chip=gfx950 --m=512 --n=512 --k=256 --workers=3 \
// RUN:   --cta-swizzle-xcds=1 --cta-group-m=1 2>/dev/null \
// RUN:   | wave-opt --pass-pipeline='builtin.module(wave-set-target-attr{chip=gfx950})' \
// RUN:   | wave-translate --wave-to-amdgpu-asm - > %t.split.s 2>/dev/null
// RUN: FileCheck %s --check-prefix=SPLIT --input-file=%t.split.s
// RUN: llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx950 \
// RUN:   -filetype=obj %t.split.s -o /dev/null
//
// ALIGNED-LABEL: gfx950_f16_streamk_gemm:
// ALIGNED-NOT: global_atomic_add
// ALIGNED: v_mfma_f32_16x16x32_f16
// ALIGNED-NOT: global_atomic_add
// ALIGNED-COUNT-64: buffer_store_dwordx4
// ALIGNED: s_endpgm
//
// SPLIT-LABEL: gfx950_f16_streamk_gemm:
// SPLIT-COUNT-3: global_atomic_add
// SPLIT: s_endpgm
