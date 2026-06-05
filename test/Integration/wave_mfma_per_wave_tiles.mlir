// REQUIRES: host-supports-amdgpu-gfx950, wave-python-bindings
//
// RUN: %python %S/../../examples/wave/wmma_matmul_tiled.py --chip=%chip --m=32 --n=32 --k=64 --bm=2 --bn=2 --wave-k-tiles=2 --random-data --compare-cpu --seed=7 \
// RUN:   | FileCheck %s --check-prefix=F32
// RUN: %python %S/../../examples/wave/wmma_matmul_tiled.py --chip=%chip --m=32 --n=32 --k=64 --bm=2 --bn=2 --wave-k-tiles=2 --output-type=f16 --compare-cpu --seed=9 \
// RUN:   | FileCheck %s --check-prefix=F16
// RUN: %python %S/../../examples/wave/wmma_matmul_tiled.py --chip=%chip --m=32 --n=32 --k=64 --bm=2 --bn=2 --wave-k-tiles=2 --input-type=bf16 --compare-cpu --seed=17 \
// RUN:   | FileCheck %s --check-prefix=BF16
// RUN: %python %S/../../examples/wave/wmma_matmul_tiled.py --chip=%chip --m=32 --n=32 --k=128 --wave-m-tiles=2 --wave-n-tiles=2 --input-type=mxfp4 --random-data --compare-cpu \
// RUN:   | FileCheck %s --check-prefix=MXFP4
// RUN: %python %S/../../examples/wave/wmma_matmul_tiled.py --chip=%chip --m=64 --n=64 --k=64 --bm=4 --bn=4 --wave-k-tiles=2 --matrix-intrinsic=mfma_gfx950 --compare-cpu --seed=29 \
// RUN:   | FileCheck %s --check-prefix=DYN
//
// F32: CPU comparison passed
// F16: CPU comparison passed
// BF16: CPU comparison passed
// MXFP4: CPU comparison passed
// DYN: CPU comparison passed
