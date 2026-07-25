// REQUIRES: host-supports-amdgpu-gfx950, wave-python-bindings
//
// RUN: %python %S/../../examples/wave/wmma_matmul_tiled.py --chip=%chip --kernel-profile=gfx950-f16-256x256-4wave --m=1024 --n=512 --k=256 --kernel-only --multi-wave-specialize \
// RUN:   | FileCheck %s
// RUN: %python %S/../../examples/wave/wmma_matmul_tiled.py --chip=%chip --kernel-profile=gfx950-f16-256x256-4wave --m=1024 --n=512 --k=256 --kernel-only \
// RUN:   | FileCheck %s --check-prefix=CACHE
// RUN: %python %S/../../examples/wave/wmma_matmul_tiled.py --chip=%chip --kernel-profile=gfx950-f16-256x256-4wave --m=1024 --n=512 --k=256 --kernel-only 2>/dev/null \
// RUN:   | wave-opt --pass-pipeline='builtin.module(wave-set-target-attr{chip=%chip},transform-preload-library{transform-library-paths=%wave_pipelines},transform-interpreter{entry-point=waveamd_backend_preschedule})' \
// RUN:   | FileCheck %s --check-prefix=MACHINE
// RUN: %python %S/../../examples/wave/wmma_matmul_tiled.py --chip=%chip --kernel-profile=gfx950-f16-256x256-4wave --m=1024 --n=512 --k=256 --kernel-only --multi-wave-specialize 2>/dev/null \
// RUN:   | wave-opt --pass-pipeline='builtin.module(wave-set-target-attr{chip=%chip})' \
// RUN:   | wave-translate --wave-to-amdgpu-asm \
// RUN:   | FileCheck %s --check-prefix=SPECIALIZED-ASM
//
// CHECK-LABEL: func.func @wmma_f16_matmul_tiled
// CHECK-SAME: wave.workgroup_size = array<i32: 256, 1, 1>
// CHECK-SAME: waveamdmachine.enable_multi_wave_specialization
// CHECK-SAME: waveamdmachine.target_waves = 1
// CHECK: [[A0:%.*]] = wave.join {{.*}} -> !wave.mem.token
// CHECK: [[A1:%.*]] = wave.join {{.*}} -> !wave.mem.token
// CHECK: [[B0:%.*]] = wave.join {{.*}} -> !wave.mem.token
// CHECK: [[B1:%.*]] = wave.join {{.*}} -> !wave.mem.token
// CHECK: wave.barrier [[A0]], [[A1]], [[B0]], [[B1]]
// CHECK: scf.for
// CHECK: wave.barrier {{.*}} : (!wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
// CHECK: waveamd.mma "mfma.f32.16x16x32.f16"
// CHECK: } {waveamdmachine.fetch_alignment = 32 : i64, waveamdmachine.fetch_phase = 12 : i64}
// CHECK-COUNT-64: waveamd.fragment_unpack
// CHECK-COUNT-32: wave.pack {{.*}} -> !wave.simd<vector<8xf16>, 64>

// CACHE-COUNT-32: wave.store {{.*}} {cache = #waveamd.store_cache<cs>}

// MACHINE-LABEL: func.func @wmma_f16_matmul_tiled
// MACHINE-NOT: waveamdmachine.reg_after
// MACHINE: waveamdmachine.uniform_loop
// MACHINE: [[ANEXT:%.*]], {{%.*}} = waveamdmachine.s_add_u64_u32
// MACHINE: [[BNEXT:%.*]], {{%.*}} = waveamdmachine.s_add_u64_u32
// MACHINE: waveamdmachine.update_tuple {{%.*}}, [[ANEXT]] {offsets = [0]}
// MACHINE: waveamdmachine.update_tuple {{%.*}}, [[BNEXT]] {offsets = [0]}
// MACHINE: } {fetch_alignment = 32 : i64, fetch_phase = 12 : i64}

// SPECIALIZED-ASM-LABEL: wmma_f16_matmul_tiled:
// SPECIALIZED-ASM: v_readfirstlane_b32 [[FIRST:s[0-9]+]], {{v[0-9]+}}
// SPECIALIZED-ASM: s_lshr_b32 [[ORDINAL:s[0-9]+]], [[FIRST]], 6
// SPECIALIZED-ASM: s_and_b32 [[PARITY:s[0-9]+]], [[ORDINAL]], 1
// SPECIALIZED-ASM: s_cmp_eq_u32 [[PARITY]], 0
// SPECIALIZED-ASM-COUNT-32: buffer_store_dwordx4 {{.*}} sc0 nt
