// REQUIRES: host-supports-amdgpu-gfx950, wave-python-bindings
//
// RUN: %python %S/../../examples/wave/wmma_matmul_tiled.py --chip=%chip --kernel-profile=gfx950-mxfp4-256x256-8wave --m=1024 --n=512 --k=256 --kernel-only \
// RUN:   | FileCheck %s
// RUN: %python %S/../../examples/wave/wmma_matmul_tiled.py --chip=%chip --kernel-profile=gfx950-mxfp4-256x256-8wave --m=1024 --n=512 --k=1024 --kernel-only 2>/dev/null \
// RUN:   | wave-opt --pass-pipeline='builtin.module(wave-set-target-attr{chip=%chip},transform-preload-library{transform-library-paths=%wave_pipelines},transform-interpreter{entry-point=waveamd_backend_preschedule})' \
// RUN:   | FileCheck %s --check-prefix=MACHINE
//
// CHECK-LABEL: func.func @wmma_f16_matmul_tiled
// CHECK-SAME: wave.workgroup_size = array<i32: 512, 1, 1>
// CHECK: waveamd.dma_load_lds
// CHECK: waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4"

// MACHINE-LABEL: func.func @wmma_f16_matmul_tiled
// MACHINE: waveamdmachine.uniform_loop
// MACHINE: [[ABASE:%.*]] = waveamdmachine.reg_after {{%.*}} after {{%.*}}
// MACHINE: waveamdmachine.s_add_u64_u32 [[ABASE]], {{%.*}}
// MACHINE: [[BBASE:%.*]] = waveamdmachine.reg_after {{%.*}} after {{%.*}}
// MACHINE: waveamdmachine.s_add_u64_u32 [[BBASE]], {{%.*}}
