// REQUIRES: host-supports-amdgpu-gfx950, wave-python-bindings
//
// RUN: %python %S/../../examples/wave/wmma_matmul_tiled.py --chip=%chip --m=32 --n=32 --k=64 --bm=2 --bn=2 --wave-k-tiles=2 --compare-cpu --seed=7 \
// RUN:   | FileCheck %s --check-prefix=F32
// RUN: %python %S/../../examples/wave/wmma_matmul_tiled.py --chip=%chip --m=32 --n=32 --k=64 --bm=2 --bn=2 --wave-k-tiles=2 --output-type=f16 --compare-cpu --seed=9 \
// RUN:   | FileCheck %s --check-prefix=F16
// RUN: %python %S/../../examples/wave/wmma_matmul_tiled.py --chip=%chip --m=32 --n=32 --k=64 --bm=2 --bn=2 --wave-k-tiles=2 --input-type=bf16 --compare-cpu --seed=17 \
// RUN:   | FileCheck %s --check-prefix=BF16
// RUN: %python %S/../../examples/wave/wmma_matmul_tiled.py --chip=%chip --m=16 --n=16 --k=128 --input-type=mxfp4 --compare-cpu \
// RUN:   | FileCheck %s --check-prefix=MXFP4
//
// F32: CPU comparison passed
// F16: CPU comparison passed
// BF16: CPU comparison passed
// MXFP4: CPU comparison passed
