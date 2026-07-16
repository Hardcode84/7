// REQUIRES: wave-python-bindings
//
// RUN: %python %S/../../examples/wave/wmma_matmul_tiled.py \
// RUN:   --chip=gfx950 --kernel-profile=gfx950-f16-256x256-8wave \
// RUN:   --m=1024 --n=1024 --k=256 --kernel-only 2>/dev/null \
// RUN:   | FileCheck %s --check-prefix=IR
// RUN: %python %S/../../examples/wave/wmma_matmul_tiled.py \
// RUN:   --chip=gfx950 --kernel-profile=gfx950-f16-256x256-8wave \
// RUN:   --m=1024 --n=1024 --k=256 --kernel-only 2>/dev/null \
// RUN:   | wave-opt --pass-pipeline='builtin.module(wave-set-target-attr{chip=gfx950},transform-preload-library{transform-library-paths=%wave_pipelines},transform-interpreter{entry-point=waveamd_backend_preschedule})' \
// RUN:   | FileCheck %s --check-prefix=MACHINE
// RUN: %python %S/../../examples/wave/wmma_matmul_tiled.py \
// RUN:   --chip=gfx950 --kernel-profile=gfx950-f16-256x256-8wave \
// RUN:   --m=1024 --n=1024 --k=256 --kernel-only --dump-asm 2>/dev/null \
// RUN:   | FileCheck %s --check-prefix=ASM
// RUN: %python %S/../../examples/wave/wmma_matmul_tiled.py \
// RUN:   --chip=gfx950 --kernel-profile=gfx950-f16-256x256-8wave \
// RUN:   --m=1024 --n=1024 --k=256 --kernel-only --dump-asm 2>/dev/null \
// RUN:   | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx950 -filetype=obj -o /dev/null
//
// IR-LABEL: func.func @wmma_f16_matmul_tiled
// IR-SAME: gpu.known_block_size = array<i32: 512, 1, 1>
// IR-SAME: wave.dynamic_lds_size = 131072 : i64
// IR-SAME: waveamdmachine.target_waves = 2 : i64
// IR-COUNT-2: issue_delay_cycles = 68 : i64
// IR: scf.for
// IR: issue_delay_cycles = 46 : i64
// IR-SAME: issue_delay_overlap_cycles = 33 : i64
// IR-SAME: issue_delay_skip_thread_threshold = 256 : i64
// IR: } {waveamdmachine.fetch_alignment = 32 : i64, waveamdmachine.fetch_phase = 16 : i64}
//
// MACHINE-LABEL: func.func @wmma_f16_matmul_tiled
// MACHINE-COUNT-2: cycles = 68 : i64
// MACHINE: waveamdmachine.uniform_loop
// MACHINE: waveamdmachine.dma_issue_delay
// MACHINE-SAME: unless
// MACHINE-SAME: cycles = 46 : i64
// MACHINE-SAME: overlap_cycles = 33 : i64
// MACHINE: } {fetch_alignment = 32 : i64, fetch_phase = 16 : i64}
//
// ASM-LABEL: wmma_f16_matmul_tiled:
// ASM: .p2align{{[[:space:]]+}}5
// ASM-COUNT-4: s_nop 0
// ASM-NEXT: [[LOOP:.Lwmma_f16_matmul_tiled.loop_head_[0-9]+]]:
// ASM: s_cbranch_vccnz [[DELAY:.Lwmma_f16_matmul_tiled.dma_issue_delay_[0-9]+]]
// ASM-NEXT: s_nop 15
// ASM-NEXT: s_nop 15
// ASM-NEXT: s_nop 13
// ASM-NEXT: [[DELAY]]:
// ASM: s_cbranch_scc1 [[LOOP]]
