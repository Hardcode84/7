// REQUIRES: host-supports-amdgpu-gfx950, wave-python-bindings
//
// RUN: %python %S/../../examples/wave/wmma_matmul_tiled.py --chip=%chip --m=32 --n=32 --k=64 --bm=2 --bn=2 --wave-k-tiles=2 --use-dma-lds --compare-cpu --seed=7 \
// RUN:   | FileCheck %s --check-prefix=DMA
// RUN: %python %S/../../examples/wave/wmma_matmul_tiled.py --chip=%chip --m=32 --n=32 --k=64 --bm=2 --bn=2 --wave-k-tiles=2 --use-dma-lds --output-type=f16 --compare-cpu --seed=9 \
// RUN:   | FileCheck %s --check-prefix=DMA-F16
// RUN: %python %S/../../examples/wave/wmma_matmul_tiled.py --chip=%chip --kernel-profile=gfx950-sw-pipeline --m=128 --n=128 --k=64 --compare-cpu --seed=3 \
// RUN:   | FileCheck %s --check-prefix=PIPE
//
// DMA: CPU comparison passed
// DMA-F16: CPU comparison passed
// PIPE: CPU comparison passed
