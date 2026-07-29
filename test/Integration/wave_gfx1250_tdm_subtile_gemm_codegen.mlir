// REQUIRES: wave-python-bindings
//
// RUN: %python %S/../../examples/wave/gfx1250_tdm_matmul.py \
// RUN:   --chip=gfx1250 --four-wave --kernel-only \
// RUN:   --m=128 --n=128 --k=128 2>/dev/null > %t.mlir
// RUN: FileCheck %s --check-prefix=IR < %t.mlir
//
// RUN: %python %S/../../examples/wave/gfx1250_tdm_matmul.py \
// RUN:   --chip=gfx1250 --four-wave --kernel-only \
// RUN:   --m=128 --n=128 --k=128 \
// RUN:   --dump-asm --wave-translate=wave-translate \
// RUN:   2>/dev/null > %t.s
// RUN: FileCheck %s --check-prefix=ASM < %t.s
// RUN: llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx1250 \
// RUN:   -filetype=obj %t.s -o %t.o
// RUN: llvm-objdump -d --mcpu=gfx1250 %t.o \
// RUN:   | FileCheck %s --check-prefix=DIS

// IR-LABEL: func.func @gfx1250_tdm_f16_gemm(
// IR-SAME: wave.lds_size = 98304
// IR-SAME: wave.workgroup_size = array<i32: 128, 1, 1>
// IR: wave.read_first
// IR: waveamd.tdm_prefetch regular
// IR: waveamd.tdm_prefetch regular
// IR: [[A_LOADED:%.*]] = waveamd.tdm_load
// IR: [[A_ISSUED:%.*]] = wave.issue_token [[A_LOADED]]
// IR: [[B_LOADED:%.*]] = waveamd.tdm_load {{.*}} after [[A_ISSUED]]
// IR: [[B_ISSUED:%.*]] = wave.issue_token [[B_LOADED]]
// IR: wave.after [[A_LOADED]], [[B_ISSUED]]
// IR-COUNT-16: waveamd.mma "wmma.f32.16x16x32.f16"
// IR: waveamd.tdm_store

// ASM-LABEL: gfx1250_tdm_f16_gemm:
// ASM: global_prefetch_b8
// ASM: tensor_load_to_lds
// ASM-NEXT: tensor_load_to_lds
// ASM-NEXT: s_wait_tensorcnt 0x1
// ASM: ds_load_b128
// ASM: s_wait_tensorcnt 0x0
// ASM: ds_load_b128
// ASM-COUNT-16: v_wmma_f32_16x16x32_f16
// ASM: s_barrier_signal -1
// ASM-NEXT: s_barrier_wait -1
// ASM: tensor_store_from_lds
// ASM-NEXT: s_wait_tensorcnt 0x0
// ASM-NEXT: s_barrier_signal -1
// ASM-NEXT: s_barrier_wait -1
// ASM: .amdhsa_group_segment_fixed_size 98304

// DIS-LABEL: <gfx1250_tdm_f16_gemm>:
// DIS: global_prefetch_b8
// DIS: tensor_load_to_lds
// DIS: tensor_load_to_lds
// DIS: s_wait_tensorcnt 0x1
// DIS: v_wmma_f32_16x16x32_f16
// DIS: tensor_store_from_lds
