// REQUIRES: linux, host-supports-amdgpu-gfx950, wave-python-bindings, host-has-hip-runtime, host-has-hipcc
//
// RUN: %hipcc -O2 %S/../../tools/wave-matmul-calibrate/wave-matmul-calibrate-runner.cpp -o %t.runner
// RUN: %python %S/../../tools/wave-matmul-calibrate/wave-matmul-calibrate.py \
// RUN:   --chip=%chip --build-dir=%wave_obj_root \
// RUN:   --kernel-profile=gfx950-f16-256x256-4wave-streamk \
// RUN:   --m=512 --n=512 --k=256 --streamk-workers=5 \
// RUN:   --cta-swizzle-xcds=4 --cta-group-m=2 --variants=scheduled \
// RUN:   --emit-hsaco=%t.split.hsaco
// RUN: %python %S/../../tools/wave-matmul-calibrate/wave-matmul-calibrate.py \
// RUN:   --chip=%chip --build-dir=%wave_obj_root \
// RUN:   --kernel-profile=gfx950-f16-256x256-4wave-streamk \
// RUN:   --m=512 --n=512 --k=256 --streamk-workers=2 \
// RUN:   --cta-swizzle-xcds=4 --cta-group-m=2 --variants=scheduled \
// RUN:   --emit-hsaco=%t.aligned.hsaco
// RUN: timeout --signal=KILL 180s \
// RUN:   %python %S/../../tools/wave-matmul-calibrate/wave-matmul-calibrate.py \
// RUN:   --chip=%chip --build-dir=%wave_obj_root \
// RUN:   --kernel-profile=gfx950-f16-256x256-4wave-streamk \
// RUN:   --m=512 --n=512 --k=256 --streamk-workers=5 \
// RUN:   --cta-swizzle-xcds=4 --cta-group-m=2 --variants=scheduled \
// RUN:   --iters=1000 --warmup=3 --repeats=1 --seed=17 \
// RUN:   --runner=%t.runner --run-hsaco=%t.split.hsaco \
// RUN:   | FileCheck %s --check-prefix=SPLIT-RANDOM
// RUN: timeout --signal=KILL 180s \
// RUN:   %python %S/../../tools/wave-matmul-calibrate/wave-matmul-calibrate.py \
// RUN:   --chip=%chip --build-dir=%wave_obj_root \
// RUN:   --kernel-profile=gfx950-f16-256x256-4wave-streamk \
// RUN:   --m=512 --n=512 --k=256 --streamk-workers=5 \
// RUN:   --cta-swizzle-xcds=4 --cta-group-m=2 --variants=scheduled \
// RUN:   --iters=8 --warmup=3 --repeats=1 --hpl \
// RUN:   --runner=%t.runner --run-hsaco=%t.split.hsaco \
// RUN:   | FileCheck %s --check-prefix=SPLIT-HPL
// RUN: timeout --signal=KILL 180s \
// RUN:   %python %S/../../tools/wave-matmul-calibrate/wave-matmul-calibrate.py \
// RUN:   --chip=%chip --build-dir=%wave_obj_root \
// RUN:   --kernel-profile=gfx950-f16-256x256-4wave-streamk \
// RUN:   --m=512 --n=512 --k=256 --streamk-workers=2 \
// RUN:   --cta-swizzle-xcds=4 --cta-group-m=2 --variants=scheduled \
// RUN:   --iters=8 --warmup=3 --repeats=1 --seed=23 \
// RUN:   --runner=%t.runner --run-hsaco=%t.aligned.hsaco \
// RUN:   | FileCheck %s --check-prefix=ALIGNED-RANDOM
// RUN: timeout --signal=KILL 180s \
// RUN:   %python %S/../../tools/wave-matmul-calibrate/wave-matmul-calibrate.py \
// RUN:   --chip=%chip --build-dir=%wave_obj_root \
// RUN:   --kernel-profile=gfx950-f16-256x256-4wave-streamk \
// RUN:   --m=512 --n=512 --k=256 --streamk-workers=2 \
// RUN:   --cta-swizzle-xcds=4 --cta-group-m=2 --variants=scheduled \
// RUN:   --iters=8 --warmup=3 --repeats=1 --hpl \
// RUN:   --runner=%t.runner --run-hsaco=%t.aligned.hsaco \
// RUN:   | FileCheck %s --check-prefix=ALIGNED-HPL
//
// SPLIT-RANDOM: example=streamk-gemm
// SPLIT-RANDOM-SAME: kernel_abi=streamk seed=17 input_mode=random
// SPLIT-RANDOM: streamk_workers=5
// SPLIT-RANDOM: kernel: gfx950_f16_streamk_gemm
// SPLIT-RANDOM: grid: 5,1,1 block: 256,1,1 waves_per_workgroup=4
// SPLIT-RANDOM: iters: 1000
// SPLIT-RANDOM: output_check: passed mode=strict
// SPLIT-RANDOM: streamk_counter_check: passed
// SPLIT-RANDOM: hw_output_check: passed
//
// SPLIT-HPL: example=streamk-gemm
// SPLIT-HPL-SAME: kernel_abi=streamk seed=0 input_mode=hpl
// SPLIT-HPL: streamk_workers=5
// SPLIT-HPL: output_check: passed mode=strict
// SPLIT-HPL: streamk_counter_check: passed
// SPLIT-HPL: hw_output_check: passed
//
// ALIGNED-RANDOM: example=streamk-gemm
// ALIGNED-RANDOM-SAME: kernel_abi=streamk seed=23 input_mode=random
// ALIGNED-RANDOM: streamk_workers=2
// ALIGNED-RANDOM: grid: 2,1,1 block: 256,1,1 waves_per_workgroup=4
// ALIGNED-RANDOM: output_check: passed mode=strict
// ALIGNED-RANDOM: streamk_counter_check: passed
// ALIGNED-RANDOM: hw_output_check: passed
//
// ALIGNED-HPL: example=streamk-gemm
// ALIGNED-HPL-SAME: kernel_abi=streamk seed=0 input_mode=hpl
// ALIGNED-HPL: streamk_workers=2
// ALIGNED-HPL: output_check: passed mode=strict
// ALIGNED-HPL: streamk_counter_check: passed
// ALIGNED-HPL: hw_output_check: passed
