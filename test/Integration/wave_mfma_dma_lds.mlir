// REQUIRES: host-supports-amdgpu-gfx950, wave-python-bindings
//
// RUN: %python %S/../../examples/wave/wmma_matmul_tiled.py --chip=%chip --m=32 --n=32 --k=64 --bm=2 --bn=2 --wave-k-tiles=2 --use-dma-lds --compare-cpu --seed=7 \
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
// RUN: %python %S/../../examples/wave/wmma_matmul_tiled.py --chip=%chip --m=16 --n=16 --k=256 --matrix-intrinsic=mfma_gfx950 --input-type=mxfp4 --use-dma-lds --compare-cpu \
// RUN:   | FileCheck %s --check-prefix=DMA-MXFP4
//
// DMA: CPU comparison passed
// DMA-F16: CPU comparison passed
// DMA-BF16: CPU comparison passed
// DMA-REMAP: CPU comparison passed
// PIPE: CPU comparison passed
// PIPE3: CPU comparison passed
// DMA-MXFP4: CPU comparison passed
