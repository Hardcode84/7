// REQUIRES: wave-python-bindings
//
// RUN: %python %S/../../../examples/wave/wmma_matmul_tiled.py --chip=gfx950 --m=32 --n=32 --k=64 --bm=2 --bn=2 --wave-k-tiles=2 --use-dma-lds 2>/dev/null \
// RUN:   | FileCheck %s --check-prefix=IR
// RUN: %python %S/../../../examples/wave/wmma_matmul_tiled.py --chip=gfx950 --m=1024 --n=1024 --k=64 --bm=2 --bn=2 --wave-m-tiles=4 --wave-n-tiles=4 --wave-k-tiles=2 --use-dma-lds --cta-swizzle-xcds=8 --cta-group-m=4 2>/dev/null \
// RUN:   | FileCheck %s --check-prefix=REMAP
// RUN: %python %S/../../../examples/wave/wmma_matmul_tiled.py --chip=gfx950 --m=32 --n=32 --k=64 --bm=2 --bn=2 --wave-k-tiles=2 --use-dma-lds 2>/dev/null \
// RUN:   | wave-opt --pass-pipeline='builtin.module(wave-set-target-attr{chip=gfx950},transform-preload-library{transform-library-paths=%wave_pipelines},transform-interpreter{entry-point=waveamd_backend_unscheduled})' \
// RUN:   | FileCheck %s --check-prefix=PRELOAD
// RUN: %python %S/../../../examples/wave/wmma_matmul_tiled.py --chip=gfx950 --m=128 --n=64 --k=64 --bm=2 --bn=2 --wave-m-tiles=2 --wave-n-tiles=2 --wave-k-tiles=2 --use-dma-lds --dump-asm 2>/dev/null \
// RUN:   | FileCheck %s --check-prefix=ASM
// RUN: %python %S/../../../examples/wave/wmma_matmul_tiled.py --chip=gfx950 --kernel-profile=gfx950-sw-pipeline --m=128 --n=128 --k=64 --dump-asm 2>/dev/null \
// RUN:   | FileCheck %s --check-prefix=ASMBUF
// RUN: %python %S/../../../examples/wave/wmma_matmul_tiled.py --chip=gfx950 --kernel-profile=gfx950-f16-256x256-16wave --m=1024 --n=512 --k=64 2>/dev/null \
// RUN:   | FileCheck %s --check-prefix=PROFILE256
// RUN: %python %S/../../../examples/wave/wmma_matmul_tiled.py --chip=gfx950 --kernel-profile=gfx950-f16-256x256-16wave --m=4096 --n=4096 --k=8192 --kernel-only --enable-split-barriers --dump-asm 2>/dev/null \
// RUN:   | FileCheck %s --check-prefix=F16-PERF-ASM
// RUN: %python %S/../../../examples/wave/wmma_matmul_tiled.py --chip=gfx950 --kernel-profile=gfx950-mxfp4-256x256-4wave --m=1024 --n=1024 --k=256 --kernel-only 2>/dev/null \
// RUN:   | FileCheck %s --check-prefix=PROFILEMXFP4-4W
// RUN: %python %S/../../../examples/wave/wmma_matmul_tiled.py --chip=gfx950 --kernel-profile=gfx950-mxfp4-256x256-4wave --m=1024 --n=1024 --k=1024 --kernel-only --enable-split-barriers --dump-asm 2>/dev/null \
// RUN:   | FileCheck %s --check-prefix=MXFP4-4W-SCALE-ASM
// RUN: %python %S/../../../examples/wave/wmma_matmul_tiled.py --chip=gfx950 --kernel-profile=gfx950-mxfp4-256x256-8wave --m=1024 --n=1024 --k=768 --kernel-only 2>/dev/null \
// RUN:   | FileCheck %s --check-prefix=PROFILEMXFP4-DMA-OVERLAP
// RUN: %python %S/../../../examples/wave/wmma_matmul_tiled.py --chip=gfx950 --kernel-profile=gfx950-mxfp4-256x256-8wave --m=4096 --n=4096 --k=32768 --kernel-only --enable-split-barriers --dump-asm 2>/dev/null \
// RUN:   | FileCheck %s --check-prefix=MXFP4-PERF-ASM
// RUN: %python %S/../../../examples/wave/wmma_matmul_tiled.py --chip=gfx950 --kernel-profile=gfx950-sw-pipeline --m=128 --n=128 --k=192 --enable-split-barriers --dump-asm 2>/dev/null \
// RUN:   | FileCheck %s --check-prefix=ASMPIPE
// RUN: %python %S/../../../examples/wave/wmma_matmul_tiled.py --chip=gfx950 --m=16 --n=16 --k=32 --matrix-intrinsic=mfma_gfx950 --input-type=bf16 --dump-asm 2>/dev/null \
// RUN:   | FileCheck %s --check-prefix=ASMBF16
// RUN: %python %S/../../../examples/wave/wmma_matmul_tiled.py --chip=gfx950 --m=64 --n=64 --k=64 --bm=4 --bn=4 --wave-k-tiles=2 --matrix-intrinsic=mfma_gfx950 --dump-asm 2>/dev/null \
// RUN:   | FileCheck %s --check-prefix=ASMDYN
// RUN: %python %S/../../../examples/wave/wmma_matmul_tiled.py --chip=gfx950 --m=32 --n=32 --k=128 --wave-m-tiles=2 --wave-n-tiles=2 --matrix-intrinsic=mfma_gfx950 --input-type=mxfp4 --dump-asm 2>/dev/null \
// RUN:   | FileCheck %s --check-prefix=ASMMXFP4
// RUN: %python %S/../../../examples/wave/wmma_matmul_tiled.py --chip=gfx950 --m=16 --n=16 --k=256 --matrix-intrinsic=mfma_gfx950 --input-type=mxfp4 --use-dma-lds --dump-asm 2>/dev/null \
// RUN:   | FileCheck %s --check-prefix=ASMMXFP4-DMA
// RUN: %python %S/../../../examples/wave/wmma_matmul_tiled.py --chip=gfx950 --m=16 --n=16 --k=256 --matrix-intrinsic=mfma_gfx950 --input-type=mxfp4 --wave-k-tiles=2 --use-dma-lds --dump-asm 2>/dev/null \
// RUN:   | FileCheck %s --check-prefix=ASMMXFP4-DMA-K2
// RUN: %python %S/../../../examples/wave/wmma_matmul_tiled.py --chip=gfx950 --m=256 --n=256 --k=128 --bm=4 --bn=2 --wave-m-tiles=4 --wave-n-tiles=8 --matrix-intrinsic=mfma_gfx950 --input-type=mxfp4 --output-type=f16 --use-dma-lds --dump-asm 2>/dev/null \
// RUN:   | FileCheck %s --check-prefix=ASMMXFP4-SCALEPACK
// RUN: %python %S/../../../examples/wave/wmma_matmul_tiled.py --chip=gfx950 --m=32 --n=32 --k=256 --bm=1 --bn=1 --wave-m-tiles=2 --wave-n-tiles=2 --wave-k-tiles=2 --matrix-intrinsic=mfma_gfx950 --input-type=mxfp4 --output-type=f16 --use-dma-lds --dump-asm 2>/dev/null \
// RUN:   | FileCheck %s --check-prefix=ASMMXFP4-EPILOGUE
// RUN: %python %S/../../../examples/wave/wmma_matmul_tiled.py --chip=gfx950 --m=16 --n=16 --k=384 --matrix-intrinsic=mfma_gfx950 --input-type=mxfp4 --use-dma-lds --dump-asm 2>/dev/null \
// RUN:   | FileCheck %s --check-prefix=ASMMXFP4-DMA-PIPE
//
// IR: wave.index_expr <{{.*xor.*floor\(1/2\*Mod\(wi, 16\)\).*}}>
// IR: waveamd.dma_load_lds
// IR: waveamd.mma "mfma.f32.16x16x32.f16"
//
// REMAP: wave.index_expr <{{.*wg_m_raw.*wg_n_raw.*}}>
// REMAP: wave.index_expr <{{.*wg_m_raw.*wg_n_raw.*}}>
// REMAP: waveamd.dma_load_lds
//
// PRELOAD-LABEL: func.func @wmma_f16_matmul_tiled
// PRELOAD-SAME: waveamdmachine.kernarg_preload_length = 7 : i64
// PRELOAD: waveamdmachine.kernarg_preload {dword_offset = 0 : i64} : !waveamdmachine.reg<sgpr, 2, 2>
// PRELOAD: waveamdmachine.kernarg_preload {dword_offset = 2 : i64} : !waveamdmachine.reg<sgpr, 2, 4>
// PRELOAD: waveamdmachine.kernarg_preload {dword_offset = 4 : i64} : !waveamdmachine.reg<sgpr, 2, 6>
// PRELOAD-NOT: waveamdmachine.s_load_b
// PRELOAD: waveamdmachine.v_workitem_id_x
//
// ASM: .amdgcn_target "amdgcn-amd-amdhsa--gfx950"
// ASM-LABEL: wmma_f16_matmul_tiled:
// ASM: s_load_dwordx2 s[2:3], s[0:1], 0x0
// ASM: s_load_dwordx2 s[4:5], s[0:1], 0x8
// ASM: s_load_dwordx2 s[6:7], s[0:1], 0x10
// ASM: s_load_dword s8, s[0:1], 0x18
// ASM: s_waitcnt lgkmcnt(0)
// ASM: s_branch [[ENTRY:.*kernarg_preload_entry]]
// ASM: .p2align 8
// ASM: [[ENTRY]]:
// ASM-NOT: s_load_dword
// ASM: v_bitop3_b32 {{.*}} bitop3:0x48
// ASM: global_load_lds_dwordx4
// ASM: v_mfma_f32_16x16x32_f16
// ASM: .amdhsa_user_sgpr_kernarg_preload_length 7
// ASM: .amdhsa_user_sgpr_kernarg_preload_offset 0

// ASMBUF-LABEL: wmma_f16_matmul_tiled:
// ASMBUF: buffer_load_dwordx4
// ASMBUF: buffer_store_dwordx4

// PROFILE256-LABEL: func.func @wmma_f16_matmul_tiled
// PROFILE256-SAME: wave.dynamic_lds_size = 65536
// PROFILE256: waveamd.make_buffer
// PROFILE256: waveamd.dma_load_lds
// PROFILE256: waveamd.mma "mfma.f32.16x16x32.f16"

// F16-PERF-ASM-LABEL: wmma_f16_matmul_tiled:
// F16-PERF-ASM: .Lwmma_f16_matmul_tiled.loop_exit_0:
// F16-PERF-ASM: ds_add_rtn_u32
// F16-PERF-ASM: v_mfma_f32_16x16x32_f16
// F16-PERF-ASM: [[F16_LOOP:.Lwmma_f16_matmul_tiled.loop_head_[0-9]+]]:
// F16-PERF-ASM: ds_read_b32
// F16-PERF-ASM: s_cbranch_scc1 [[F16_LOOP]]
// F16-PERF-ASM: ds_read_b128

// PROFILEMXFP4-4W-LABEL: func.func @wmma_f16_matmul_tiled
// PROFILEMXFP4-4W-SAME: wave.dynamic_lds_size = 81920
// PROFILEMXFP4-4W-SAME: waveamdmachine.target_waves = 1
// PROFILEMXFP4-4W: waveamd.make_buffer
// PROFILEMXFP4-4W: waveamd.dma_load_lds
// PROFILEMXFP4-4W: waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4"

// MXFP4-4W-SCALE-ASM-LABEL: wmma_f16_matmul_tiled:
// MXFP4-4W-SCALE-ASM: [[MXFP4_4W_LOOP:.Lwmma_f16_matmul_tiled.loop_head_[0-9]+]]:
// MXFP4-4W-SCALE-ASM: ds_read_b64_tr_b8
// MXFP4-4W-SCALE-ASM: ds_read_b64_tr_b8 {{.*}} offset:2560
// MXFP4-4W-SCALE-ASM: ds_read_b64_tr_b8 {{.*}} offset:6656
// MXFP4-4W-SCALE-ASM: v_mfma_scale_f32_16x16x128_f8f6f4
// MXFP4-4W-SCALE-ASM: buffer_load_dwordx4 {{.*}} lds
// MXFP4-4W-SCALE-ASM: ds_read_b128
// MXFP4-4W-SCALE-ASM: s_cbranch_scc1 [[MXFP4_4W_LOOP]]

// PROFILEMXFP4-DMA-OVERLAP-LABEL: func.func @wmma_f16_matmul_tiled
// PROFILEMXFP4-DMA-OVERLAP-SAME: wave.workgroup_size = array<i32: 512, 1, 1>
// PROFILEMXFP4-DMA-OVERLAP: [[ONE:%.*]] = arith.constant 1 : i32
// PROFILEMXFP4-DMA-OVERLAP: wave.binary ori
// PROFILEMXFP4-DMA-OVERLAP: wave.where
// PROFILEMXFP4-DMA-OVERLAP: waveamd.dma_load_lds
// PROFILEMXFP4-DMA-OVERLAP: wave.join
// PROFILEMXFP4-DMA-OVERLAP: otherwise
// PROFILEMXFP4-DMA-OVERLAP: wave.token
// PROFILEMXFP4-DMA-OVERLAP: wave.yield
// PROFILEMXFP4-DMA-OVERLAP: wave.binary ori
// PROFILEMXFP4-DMA-OVERLAP: wave.where
// PROFILEMXFP4-DMA-OVERLAP: waveamd.dma_load_lds
// PROFILEMXFP4-DMA-OVERLAP: wave.join
// PROFILEMXFP4-DMA-OVERLAP: otherwise
// PROFILEMXFP4-DMA-OVERLAP: wave.token
// PROFILEMXFP4-DMA-OVERLAP: wave.yield
// PROFILEMXFP4-DMA-OVERLAP: scf.for {{%.*}} = {{%.*}} to [[ONE]] step [[ONE]]
// PROFILEMXFP4-DMA-OVERLAP: [[SCALE_READY:%.*]] = wave.join {{%.*}}, {{%.*}} : !wave.mem.token, !wave.mem.token -> !wave.mem.token
// PROFILEMXFP4-DMA-OVERLAP: wave.barrier [[SCALE_READY]]
// PROFILEMXFP4-DMA-OVERLAP: waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4"
// PROFILEMXFP4-DMA-OVERLAP: waveamd.dma_load_lds
// PROFILEMXFP4-DMA-OVERLAP: wave.join
// PROFILEMXFP4-DMA-OVERLAP: wave.barrier
// PROFILEMXFP4-DMA-OVERLAP: wave.load
// PROFILEMXFP4-DMA-OVERLAP: waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4"

// MXFP4-PERF-ASM-LABEL: wmma_f16_matmul_tiled:
// MXFP4-PERF-ASM-DAG: v_lshlrev_b32_e32 v{{[0-9]+}}, 12, v{{[0-9]+}}
// MXFP4-PERF-ASM-DAG: v_lshl_add_u32 [[MXFP4_ADDR:v[0-9]+]], s{{[0-9]+}}, 18, v{{[0-9]+}}
// MXFP4-PERF-ASM-DAG: v_lshl_add_u32 [[MXFP4_ADDR]], v{{[0-9]+}}, 4, [[MXFP4_ADDR]]
// MXFP4-PERF-ASM: [[MXFP4_LOOP:.Lwmma_f16_matmul_tiled.loop_head_[0-9]+]]:
// MXFP4-PERF-ASM: s_barrier
// MXFP4-PERF-ASM: ds_read_b64_tr_b8
// MXFP4-PERF-ASM: ds_read_b64_tr_b8 {{.*}} offset:4096
// MXFP4-PERF-ASM: ds_read_b64_tr_b8 {{.*}} offset:6656
// MXFP4-PERF-ASM: v_mfma_scale_f32_16x16x128_f8f6f4
// MXFP4-PERF-ASM: ds_add_rtn_u32
// MXFP4-PERF-ASM: [[MXFP4_WAIT:.Lwmma_f16_matmul_tiled.loop_head_[0-9]+]]:
// MXFP4-PERF-ASM: ds_read_b32
// MXFP4-PERF-ASM: s_cbranch_scc1 [[MXFP4_WAIT]]
// MXFP4-PERF-ASM: buffer_load_dwordx4 {{.*}} lds
// MXFP4-PERF-ASM: v_mfma_scale_f32_16x16x128_f8f6f4

// ASMPIPE-LABEL: wmma_f16_matmul_tiled:
// ASMPIPE: s_barrier
// ASMPIPE: ds_read_b128
// ASMPIPE: v_mfma_f32_16x16x32_f16

// ASMBF16-LABEL: wmma_f16_matmul_tiled:
// ASMBF16: v_mfma_f32_16x16x32_bf16

// ASMDYN-LABEL: wmma_f16_matmul_tiled:
// ASMDYN: .amdhsa_group_segment_fixed_size 0

// ASMMXFP4: .amdgcn_target "amdgcn-amd-amdhsa--gfx950"
// ASMMXFP4-LABEL: wmma_f16_matmul_tiled:
// ASMMXFP4: s_load_dwordx2 s{{\[}}[[A:[0-9]+]]:[[A1:[0-9]+]]{{\]}}, s[0:1], 0x0
// ASMMXFP4: s_load_dwordx2 s{{\[}}[[B:[0-9]+]]:[[B1:[0-9]+]]{{\]}}, s[0:1], 0x8
// ASMMXFP4: s_load_dwordx2 s{{\[}}[[C:[0-9]+]]:[[C1:[0-9]+]]{{\]}}, s[0:1], 0x10
// ASMMXFP4: s_load_dwordx2 s{{\[}}[[SA:[0-9]+]]:[[SA1:[0-9]+]]{{\]}}, s[0:1], 0x18
// ASMMXFP4: s_load_dwordx2 s{{\[}}[[SB:[0-9]+]]:[[SB1:[0-9]+]]{{\]}}, s[0:1], 0x20
// ASMMXFP4: s_load_dword s{{[0-9]+}}, s[0:1], 0x28
// ASMMXFP4: buffer_load_dwordx4 v{{\[[0-9]+:[0-9]+\]}}, v{{[0-9]+}}, s{{\[[0-9]+:[0-9]+\]}}, 0 offen
// ASMMXFP4: buffer_load_dwordx4 v{{\[[0-9]+:[0-9]+\]}}, v{{[0-9]+}}, s{{\[[0-9]+:[0-9]+\]}}, 0 offen offset:1024
// ASMMXFP4: buffer_load_dwordx4 v{{\[[0-9]+:[0-9]+\]}}, v{{[0-9]+}}, s{{\[[0-9]+:[0-9]+\]}}, 0 offen
// ASMMXFP4: buffer_load_dwordx4 v{{\[[0-9]+:[0-9]+\]}}, v{{[0-9]+}}, s{{\[[0-9]+:[0-9]+\]}}, 0 offen offset:1024
// ASMMXFP4: buffer_load_dwordx4 v{{\[[0-9]+:[0-9]+\]}}, v{{[0-9]+}}, s{{\[[0-9]+:[0-9]+\]}}, 0 offen
// ASMMXFP4: buffer_load_dwordx4 v{{\[[0-9]+:[0-9]+\]}}, v{{[0-9]+}}, s{{\[[0-9]+:[0-9]+\]}}, 0 offen offset:16
// ASMMXFP4: buffer_load_dwordx4 v{{\[[0-9]+:[0-9]+\]}}, v{{[0-9]+}}, s{{\[[0-9]+:[0-9]+\]}}, 0 offen
// ASMMXFP4: buffer_load_dwordx4 v{{\[[0-9]+:[0-9]+\]}}, v{{[0-9]+}}, s{{\[[0-9]+:[0-9]+\]}}, 0 offen offset:16
// ASMMXFP4: ds_write_b128 {{v[0-9]+}}, {{v\[[0-9]+:[0-9]+\]}} offset:4096
// ASMMXFP4: ds_write_b128 {{v[0-9]+}}, {{v\[[0-9]+:[0-9]+\]}} offset:5632
// ASMMXFP4: ds_read_b64_tr_b8 {{v\[[0-9]+:[0-9]+\]}}, {{v[0-9]+}} offset:4096
// ASMMXFP4: ds_read_b64_tr_b8 {{v\[[0-9]+:[0-9]+\]}}, {{v[0-9]+}} offset:5632
// ASMMXFP4: v_mfma_scale_f32_16x16x128_f8f6f4 v{{\[[0-9]+:[0-9]+\]}}, v{{\[[0-9]+:[0-9]+\]}}, v{{\[[0-9]+:[0-9]+\]}}, v{{\[[0-9]+:[0-9]+\]}}, v{{[0-9]+}}, v{{[0-9]+}} op_sel_hi:[0,0,0] cbsz:4 blgp:4
// ASMMXFP4: .amdhsa_group_segment_fixed_size 6144
// ASMMXFP4: .amdhsa_kernarg_size 48
// ASMMXFP4: .amdhsa_user_sgpr_kernarg_preload_length 11

// ASMMXFP4-DMA-LABEL: wmma_f16_matmul_tiled:
// ASMMXFP4-DMA: global_load_lds_dwordx4
// ASMMXFP4-DMA: global_load_lds_dwordx4
// ASMMXFP4-DMA: global_load_lds_dwordx4
// ASMMXFP4-DMA: global_load_lds_dwordx4
// ASMMXFP4-DMA: ds_read_b64_tr_b8 {{v\[[0-9]+:[0-9]+\]}}, {{v[0-9]+}} offset:4096
// ASMMXFP4-DMA: ds_read_b64_tr_b8 {{v\[[0-9]+:[0-9]+\]}}, {{v[0-9]+}} offset:4608
// ASMMXFP4-DMA: v_mfma_scale_f32_16x16x128_f8f6f4
// ASMMXFP4-DMA: ds_read_b64_tr_b8 {{v\[[0-9]+:[0-9]+\]}}, {{v[0-9]+}} offset:5120
// ASMMXFP4-DMA: ds_read_b64_tr_b8 {{v\[[0-9]+:[0-9]+\]}}, {{v[0-9]+}} offset:5632
// ASMMXFP4-DMA: v_mfma_scale_f32_16x16x128_f8f6f4
// ASMMXFP4-DMA: .amdhsa_group_segment_fixed_size 6144

// ASMMXFP4-DMA-K2-LABEL: wmma_f16_matmul_tiled:
// ASMMXFP4-DMA-K2-COUNT-4: global_load_lds_dwordx4
// ASMMXFP4-DMA-K2-COUNT-4: buffer_load_dwordx4 {{.*}} lds
// ASMMXFP4-DMA-K2: ds_read_b64_tr_b8 {{v\[[0-9]+:[0-9]+\]}}, {{v[0-9]+}} offset:4096
// ASMMXFP4-DMA-K2: ds_read_b64_tr_b8 {{v\[[0-9]+:[0-9]+\]}}, {{v[0-9]+}} offset:4608
// ASMMXFP4-DMA-K2: ds_read_b64_tr_b8 {{v\[[0-9]+:[0-9]+\]}}, {{v[0-9]+}} offset:5120
// ASMMXFP4-DMA-K2: ds_read_b64_tr_b8 {{v\[[0-9]+:[0-9]+\]}}, {{v[0-9]+}} offset:5632
// ASMMXFP4-DMA-K2: s_waitcnt lgkmcnt(2)
// ASMMXFP4-DMA-K2-NEXT: v_mfma_scale_f32_16x16x128_f8f6f4
// ASMMXFP4-DMA-K2: s_waitcnt lgkmcnt(0)
// ASMMXFP4-DMA-K2: v_mfma_scale_f32_16x16x128_f8f6f4
// ASMMXFP4-DMA-K2: .amdhsa_group_segment_fixed_size 8192

// ASMMXFP4-SCALEPACK-LABEL: wmma_f16_matmul_tiled:
// ASMMXFP4-SCALEPACK-COUNT-3: ds_read_b64_tr_b8
// ASMMXFP4-SCALEPACK-COUNT-32: v_mfma_scale_f32_16x16x128_f8f6f4
// ASMMXFP4-SCALEPACK: op_sel:[1,0,0] op_sel_hi:[1,1,0]

// ASMMXFP4-EPILOGUE-LABEL: wmma_f16_matmul_tiled:
// ASMMXFP4-EPILOGUE: v_mfma_scale_f32_16x16x128_f8f6f4
// ASMMXFP4-EPILOGUE: ds_write{{.*}}_b64
// ASMMXFP4-EPILOGUE: ds_read_b128
// ASMMXFP4-EPILOGUE: buffer_store_dwordx4
// ASMMXFP4-EPILOGUE: v_mfma_scale_f32_16x16x128_f8f6f4
// ASMMXFP4-EPILOGUE: ds_write{{.*}}_b64
// ASMMXFP4-EPILOGUE: ds_read_b128
// ASMMXFP4-EPILOGUE: buffer_store_dwordx4

// ASMMXFP4-DMA-PIPE-LABEL: wmma_f16_matmul_tiled:
// ASMMXFP4-DMA-PIPE: ds_read_b64_tr_b8
// ASMMXFP4-DMA-PIPE: global_load_lds_dwordx4
// ASMMXFP4-DMA-PIPE: v_mfma_scale_f32_16x16x128_f8f6f4

// ASMPIPE: ds_read_b128
// ASMPIPE: v_mfma_f32_16x16x32_f16
