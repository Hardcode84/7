// REQUIRES: host-supports-amdgpu-gfx950, wave-python-bindings
//
// RUN: %python %S/../../examples/wave/wmma_matmul_tiled.py --chip=%chip --m=16 --n=16 --k=256 --matrix-intrinsic=mfma_gfx950 --input-type=mxfp4 --wave-k-tiles=2 --use-dma-lds --random-data --compare-cpu \
// RUN:   | FileCheck %s
//
// CHECK: CPU comparison passed
