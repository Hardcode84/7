// REQUIRES: wave-python-bindings
//
// RUN: %python %S/../../examples/wave/flash_attention_gfx950.py \
// RUN:   --batch=1 --heads=1 --sequence=256 --xcds=1 --waves=4 \
// RUN:   --dump-asm --wave-translate=wave-translate 2>/dev/null \
// RUN:   | FileCheck %s --check-prefix=CHECK-4W
// RUN: %python %S/../../examples/wave/flash_attention_gfx950.py \
// RUN:   --batch=1 --heads=1 --sequence=256 --xcds=1 --waves=4 \
// RUN:   --dump-asm --wave-translate=wave-translate 2>/dev/null \
// RUN:   | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx950 \
// RUN:       -filetype=obj -o /dev/null
// RUN: %python %S/../../examples/wave/flash_attention_gfx950.py \
// RUN:   --batch=1 --heads=1 --sequence=256 --xcds=1 --waves=8 \
// RUN:   --dump-asm --wave-translate=wave-translate 2>/dev/null \
// RUN:   | FileCheck %s --check-prefix=CHECK-8W
// RUN: %python %S/../../examples/wave/flash_attention_gfx950.py \
// RUN:   --batch=1 --heads=1 --sequence=256 --xcds=1 --waves=8 \
// RUN:   --dump-asm --wave-translate=wave-translate 2>/dev/null \
// RUN:   | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx950 \
// RUN:       -filetype=obj -o /dev/null
// RUN: %python %S/../../examples/wave/flash_attention_gfx950.py \
// RUN:   --batch=1 --heads=1 --sequence=256 --xcds=1 --waves=4 2>/dev/null \
// RUN:   | FileCheck %s --check-prefix=IR-4W
// RUN: %python %S/../../examples/wave/flash_attention_gfx950.py \
// RUN:   --batch=1 --heads=1 --sequence=256 --xcds=1 --waves=8 2>/dev/null \
// RUN:   | FileCheck %s --check-prefix=IR-8W
// RUN: not %python %S/../../examples/wave/flash_attention_gfx950.py \
// RUN:   --batch=1 --heads=1 --sequence=384 --xcds=1 --waves=8 2>&1 \
// RUN:   | FileCheck %s --check-prefix=INVALID-SEQUENCE
// RUN: not %python %S/../../examples/wave/flash_attention_gfx950.py \
// RUN:   --batch=1 --heads=1 --sequence=256 --xcds=3 --waves=8 2>&1 \
// RUN:   | FileCheck %s --check-prefix=INVALID-XCDS
//
// IR-4W: func.func @flash_attention_bf16_gfx950
// IR-4W-SAME: gpu.known_block_size = array<i32: 256, 1, 1>
// IR-4W-SAME: wave.dynamic_lds_size = 68096 : i64
// IR-4W-SAME: waveamdmachine.target_waves = 1 : i64
// IR-4W: [[K_READY:%.*]] = wave.join
// IR-4W: [[LDS_READY:%.*]] = wave.barrier [[K_READY]], %{{.*}}, %{{.*}}
// IR-4W: wave.load {{.*}} after [[LDS_READY]]
//
// IR-8W: func.func @flash_attention_bf16_gfx950
// IR-8W-SAME: gpu.known_block_size = array<i32: 512, 1, 1>
// IR-8W-SAME: wave.dynamic_lds_size = 68096 : i64
// IR-8W-SAME: waveamdmachine.target_waves = 2 : i64
//
// INVALID-SEQUENCE: sequence must be a multiple of 256; got 384
// INVALID-XCDS: xcds must be 1, 2, 4, or 8; got 3
//
// CHECK-4W-LABEL: flash_attention_bf16_gfx950:
// CHECK-4W: buffer_load_dwordx4 {{.*}} lds
// CHECK-4W: s_waitcnt vmcnt(0)
// CHECK-4W-NEXT: s_barrier
// CHECK-4W: ds_read_
// CHECK-4W: s_waitcnt lgkmcnt(0)
// CHECK-4W-NEXT: s_barrier
// CHECK-4W: v_mfma_f32_32x32x16_bf16
// CHECK-4W: v_exp_f32
// CHECK-4W: v_pk_add_f32
// CHECK-4W: v_rcp_f32
// CHECK-4W: .amdhsa_next_free_vgpr 416
// CHECK-4W: .amdhsa_next_free_sgpr 28
//
// CHECK-8W-LABEL: flash_attention_bf16_gfx950:
// CHECK-8W: buffer_load_dwordx4 {{.*}} lds
// CHECK-8W: s_waitcnt vmcnt(0)
// CHECK-8W-NEXT: s_barrier
// CHECK-8W: ds_read_
// CHECK-8W: s_waitcnt lgkmcnt(0)
// CHECK-8W-NEXT: s_barrier
// CHECK-8W: v_mfma_f32_32x32x16_bf16
// CHECK-8W: v_exp_f32
// CHECK-8W: v_pk_add_f32
// CHECK-8W: v_rcp_f32
// CHECK-8W: .amdhsa_next_free_vgpr 240
// CHECK-8W: .amdhsa_next_free_sgpr 28
