// REQUIRES: wave-python-bindings
//
// RUN: %python %S/../../examples/wave/wmma_matmul_tiled.py \
// RUN:   --chip=gfx950 --kernel-profile=gfx950-f16-256x256-8wave \
// RUN:   --m=1024 --n=1024 --k=8192 --kernel-only 2>/dev/null \
// RUN:   | FileCheck %s --check-prefix=IR
// RUN: %python %S/../../examples/wave/wmma_matmul_tiled.py \
// RUN:   --chip=gfx950 --kernel-profile=gfx950-f16-256x256-8wave \
// RUN:   --m=1024 --n=1024 --k=8192 --kernel-only --dump-asm 2>/dev/null \
// RUN:   | FileCheck %s --check-prefix=ASM
// RUN: %python %S/../../examples/wave/wmma_matmul_tiled.py \
// RUN:   --chip=gfx950 --kernel-profile=gfx950-f16-256x256-8wave \
// RUN:   --m=1024 --n=1024 --k=8192 --kernel-only --dump-asm 2>/dev/null \
// RUN:   | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx950 -filetype=obj -o /dev/null
//
// IR-LABEL: func.func @wmma_f16_matmul_tiled
// IR-SAME: gpu.known_block_size = array<i32: 512, 1, 1>
// IR-SAME: wave.lds_size = 0 : i64
// IR-SAME: waveamdmachine.target_waves = 2 : i64
// IR-COUNT-2: wave.alloc() {align = 16 : i64, bytesize = 65536 : i64}
// IR: issue_delay_cycles = 68 : i64
// IR: scf.if
// IR: scf.for
// IR: scf.if
//
// ASM-LABEL: wmma_f16_matmul_tiled:
// ASM: s_cmp_ge_u32
// ASM: s_cbranch_scc0 [[HIGH_END:.Lwmma_f16_matmul_tiled.if_end_[0-9]+]]
// ASM-NEXT: s_barrier
// ASM-NEXT: [[HIGH_END]]:
// ASM: .p2align{{[[:space:]]+}}5
// ASM-COUNT-4: s_nop 0
// ASM-NEXT: [[LOOP:.Lwmma_f16_matmul_tiled.loop_head_[0-9]+]]:
// ASM: s_setprio 0
// ASM-NEXT: s_waitcnt vmcnt(10) lgkmcnt(0)
// ASM-NEXT: s_barrier
// ASM-COUNT-16: v_mfma_f32_16x16x32_f16
// ASM-NEXT: s_setprio 1
// ASM-NEXT: s_barrier
// ASM: buffer_load_dwordx4
// ASM: ds_read_b128
// ASM: s_cbranch_scc1 [[LOOP]]
