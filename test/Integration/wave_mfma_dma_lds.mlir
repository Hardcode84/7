// REQUIRES: host-supports-amdgpu-gfx950, wave-python-bindings
//
// RUN: %python %S/../../examples/wave/wmma_matmul_tiled.py --chip=%chip --m=32 --n=32 --k=64 --bm=2 --bn=2 --wave-k-tiles=2 --use-dma-lds --random-data --compare-cpu --seed=7 \
// RUN:   | FileCheck %s --check-prefix=DMA
// RUN: %python %S/../../examples/wave/wmma_matmul_tiled.py --chip=%chip --m=32 --n=32 --k=64 --bm=2 --bn=2 --wave-k-tiles=2 --use-dma-lds --output-type=f16 --compare-cpu --seed=9 \
// RUN:   | FileCheck %s --check-prefix=DMA-F16
// RUN: %python %S/../../examples/wave/wmma_matmul_tiled.py --chip=%chip --m=32 --n=32 --k=64 --bm=2 --bn=2 --wave-k-tiles=2 --use-dma-lds --input-type=bf16 --compare-cpu --seed=19 \
// RUN:   | FileCheck %s --check-prefix=DMA-BF16
// RUN: %python %S/../../examples/wave/wmma_matmul_tiled.py --chip=%chip --m=64 --n=32 --k=64 --bm=1 --bn=1 --wave-k-tiles=2 --use-dma-lds --matrix-intrinsic=mfma_gfx950 --cta-swizzle-xcds=8 --cta-group-m=4 --compare-cpu --seed=23 \
// RUN:   | FileCheck %s --check-prefix=DMA-REMAP
// RUN: %python %S/../../examples/wave/wmma_matmul_tiled.py --chip=%chip --kernel-profile=gfx950-sw-pipeline --m=128 --n=128 --k=64 --compare-cpu --seed=3 \
// RUN:   | FileCheck %s --check-prefix=PIPE
// RUN: %python %S/../../examples/wave/wmma_matmul_tiled.py --chip=%chip --kernel-profile=gfx950-sw-pipeline --m=128 --n=128 --k=192 --compare-cpu --seed=3 \
// RUN:   | FileCheck %s --check-prefix=PIPE3
// RUN: %python %S/../../examples/wave/wmma_matmul_tiled.py --chip=%chip --kernel-profile=gfx950-f16-256x256-16wave --m=256 --n=256 --k=64 --cta-swizzle-xcds=1 --cta-group-m=1 --compare-cpu --seed=5 \
// RUN:   | FileCheck %s --check-prefix=PROFILE256
// RUN: %python %S/../../examples/wave/wmma_matmul_tiled.py --chip=%chip --m=16 --n=16 --k=256 --matrix-intrinsic=mfma_gfx950 --input-type=mxfp4 --use-dma-lds --random-data --compare-cpu \
// RUN:   | FileCheck %s --check-prefix=DMA-MXFP4
// RUN: %python %S/../../examples/wave/wmma_matmul_tiled.py --chip=%chip --m=16 --n=16 --k=256 --matrix-intrinsic=mfma_gfx950 --input-type=mxfp4 --wave-k-tiles=2 --use-dma-lds --random-data --compare-cpu \
// RUN:   | FileCheck %s --check-prefix=DMA-MXFP4-K2
// RUN: %python %S/../../examples/wave/wmma_matmul_tiled.py --chip=%chip --kernel-profile=gfx950-mxfp4-256x256-8wave --m=1024 --n=512 --k=256 --kernel-only \
// RUN:   | FileCheck %s --check-prefix=PROFILE-MXFP4
// RUN: %python %S/../../examples/wave/wmma_matmul_tiled.py --chip=%chip --kernel-profile=gfx950-mxfp4-256x256-4wave --m=1024 --n=512 --k=256 --kernel-only \
// RUN:   | FileCheck %s --check-prefix=PROFILE-MXFP4-4W
//
// DMA: CPU comparison passed
// DMA-F16: CPU comparison passed
// DMA-BF16: CPU comparison passed
// DMA-REMAP: CPU comparison passed
// PIPE: CPU comparison passed
// PIPE3: CPU comparison passed
// PROFILE256: CPU comparison passed
// DMA-MXFP4: CPU comparison passed
// DMA-MXFP4-K2: CPU comparison passed
// PROFILE-MXFP4-LABEL: func.func @wmma_f16_matmul_tiled
// PROFILE-MXFP4-SAME: wave.workgroup_size = array<i32: 512, 1, 1>
// PROFILE-MXFP4: waveamd.dma_load_lds
// PROFILE-MXFP4: waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4"
// PROFILE-MXFP4-4W-LABEL: func.func @wmma_f16_matmul_tiled
// PROFILE-MXFP4-4W-SAME: wave.workgroup_size = array<i32: 256, 1, 1>
// PROFILE-MXFP4-4W-SAME: waveamdmachine.target_waves = 1
// PROFILE-MXFP4-4W: waveamd.dma_load_lds
// PROFILE-MXFP4-4W: waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4"
