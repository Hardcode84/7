// REQUIRES: host-supports-amdgpu-gfx950, wave-python-bindings
//
// RUN: %python %S/../../examples/wave/wmma_matmul_tiled.py --chip=%chip --kernel-profile=gfx950-mxfp4-256x256-8wave --m=1024 --n=512 --k=256 --kernel-only \
// RUN:   | FileCheck %s
//
// CHECK-LABEL: func.func @wmma_f16_matmul_tiled
// CHECK-SAME: wave.workgroup_size = array<i32: 512, 1, 1>
// CHECK: waveamd.dma_load_lds
// CHECK: waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4"
