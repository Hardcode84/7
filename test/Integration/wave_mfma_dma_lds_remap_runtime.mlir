// REQUIRES: host-supports-amdgpu-gfx950, wave-python-bindings
//
// RUN: %python %S/../../examples/wave/wmma_matmul_tiled.py --chip=%chip --m=64 --n=32 --k=64 --bm=1 --bn=1 --wave-k-tiles=2 --use-dma-lds --matrix-intrinsic=mfma_gfx950 --cta-swizzle-xcds=8 --cta-group-m=4 --compare-cpu --seed=23 \
// RUN:   | FileCheck %s
//
// CHECK: CPU comparison passed
