// REQUIRES: host-supports-amdgpu-wave, wave-python-bindings, host-has-hip-runtime, host-has-hipcc
//
// RUN: %python %S/../../tools/wave-matmul-calibrate/wave-matmul-calibrate.py --chip=%chip --build-dir=%wave_obj_root --m=32 --n=64 --k=32 --bm=1 --bn=2 --wave-m-tiles=2 --input-type=f16 --variants=baseline --iters=2 --warmup=1 --repeats=1 --sim-trip-count=0 --rand-int \
// RUN:   | FileCheck %s --check-prefix=ROW
// RUN: %python %S/../../tools/wave-matmul-calibrate/wave-matmul-calibrate.py --chip=%chip --build-dir=%wave_obj_root --m=32 --n=64 --k=32 --bm=1 --bn=2 --wave-m-tiles=2 --input-type=f16 --output-layout=column-major --variants=baseline --iters=2 --warmup=1 --repeats=1 --sim-trip-count=0 --rand-int \
// RUN:   | FileCheck %s --check-prefix=COLUMN
// RUN: %python %S/../../tools/wave-matmul-calibrate/wave-matmul-calibrate.py --chip=%chip --build-dir=%wave_obj_root --m=32 --n=64 --k=32 --bm=1 --bn=2 --wave-m-tiles=2 --input-type=bf16 --output-layout=tile-packed --variants=baseline --iters=2 --warmup=1 --repeats=1 --sim-trip-count=0 --rand-int \
// RUN:   | FileCheck %s --check-prefix=TILE
//
// ROW: m=32 n=64 k=32 bm=1 bn=2 wave_m_tiles=2
// ROW: input_type=f16
// ROW-SAME: input_mode=rand-int
// ROW: kernel_abi=matmul output_layout=row-major
// ROW: output_check: passed mode=strict layout=row-major elements=2048
// ROW: hw_output_check: passed
// COLUMN: m=32 n=64 k=32 bm=1 bn=2 wave_m_tiles=2
// COLUMN: input_type=f16
// COLUMN-SAME: input_mode=rand-int
// COLUMN: kernel_abi=matmul output_layout=column-major
// COLUMN: output_check: passed mode=strict
// COLUMN: hw_output_check: passed
// TILE: m=32 n=64 k=32 bm=1 bn=2 wave_m_tiles=2
// TILE: input_type=bf16
// TILE-SAME: input_mode=rand-int
// TILE: kernel_abi=matmul output_layout=tile-packed
// TILE: output_check: passed mode=strict layout=tile-packed
// TILE: hw_output_check: passed
