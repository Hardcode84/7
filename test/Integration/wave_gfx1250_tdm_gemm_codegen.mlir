// REQUIRES: wave-python-bindings
//
// RUN: %python %S/../../examples/wave/gfx1250_tdm_matmul.py \
// RUN:   --chip=gfx1250 --m=16 --n=16 --k=64 \
// RUN:   --dump-asm --wave-translate=wave-translate 2>/dev/null > %t.s
// RUN: FileCheck %s < %t.s
// RUN: llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx1250 \
// RUN:   -filetype=obj %t.s -o /dev/null

// CHECK-LABEL: gfx1250_tdm_f16_gemm:
// CHECK: tensor_load_to_lds
// CHECK: tensor_load_to_lds
// CHECK: s_wait_tensorcnt 0x0
// CHECK: ds_load_b128
// CHECK: v_wmma_f32_16x16x32_f16
// CHECK: tensor_store_from_lds
// CHECK: s_wait_tensorcnt 0x0
// CHECK: .amdhsa_group_segment_fixed_size 3072
