// REQUIRES: host-supports-amdgpu-gfx950, wave-python-bindings, host-has-hip-runtime, host-has-hipcc
//
// RUN: %python %S/../../tools/wave-matmul-calibrate/wave-matmul-calibrate.py --chip=%chip --build-dir=%wave_obj_root --kernel-profile=gfx950-f16-256x256-16wave-persistent --m=256 --n=256 --k=128 --variants=scheduled --iters=2 --warmup=1 --repeats=1 --seed=17 \
// RUN:   | FileCheck %s --check-prefix=POLL
// RUN: %python %S/../../tools/wave-matmul-calibrate/wave-matmul-calibrate.py --chip=%chip --build-dir=%wave_obj_root --kernel-profile=gfx950-f16-256x256-16wave-persistent --m=256 --n=256 --k=128 --variants=scheduled --iters=2 --warmup=1 --repeats=1 --hpl --persistent-completion=waitcnt \
// RUN:   | FileCheck %s --check-prefix=WAIT
// RUN: %python %S/../../tools/wave-matmul-calibrate/wave-matmul-calibrate.py --chip=%chip --build-dir=%wave_obj_root --kernel-profile=gfx950-f16-256x256-16wave-persistent-pipelined-k64 --m=256 --n=256 --k=192 --variants=scheduled --iters=2 --warmup=1 --repeats=1 --seed=29 \
// RUN:   | FileCheck %s --check-prefix=K64-RANDOM
// RUN: %python %S/../../tools/wave-matmul-calibrate/wave-matmul-calibrate.py --chip=%chip --build-dir=%wave_obj_root --kernel-profile=gfx950-f16-256x256-16wave-persistent-pipelined-k64 --m=256 --n=256 --k=192 --variants=scheduled --iters=2 --warmup=1 --repeats=1 --hpl \
// RUN:   | FileCheck %s --check-prefix=K64-HPL
//
// POLL: bm=4 bn=4 wave_m_tiles=4 wave_n_tiles=4 wave_k_tiles=1 target_waves=4
// POLL-SAME: input_type=f16 output_type=f16
// POLL-SAME: example=persistent-gemm
// POLL-SAME: seed=17 input_mode=random
// POLL: kernel_arg_trip_count: 3
// POLL: persistent_completion=poll poll_sleep_cycles=1
// POLL: kernel: gfx950_persistent_f16_gemm
// POLL: grid: 1,1,1 block: 1024,1,1 waves_per_workgroup=16
// POLL: output_check: passed mode=strict
// POLL: hw_output_check: passed
//
// WAIT: bm=4 bn=4 wave_m_tiles=4 wave_n_tiles=4 wave_k_tiles=1 target_waves=4
// WAIT-SAME: input_type=f16 output_type=f16
// WAIT-SAME: example=persistent-gemm
// WAIT-SAME: seed=0 input_mode=hpl
// WAIT: kernel_arg_trip_count: 3
// WAIT: persistent_completion=waitcnt poll_sleep_cycles=1
// WAIT: kernel: gfx950_persistent_f16_gemm
// WAIT: grid: 1,1,1 block: 1024,1,1 waves_per_workgroup=16
// WAIT: output_check: passed mode=strict
// WAIT: hw_output_check: passed
//
// K64-RANDOM: seed=29 input_mode=random
// K64-RANDOM: kernel_arg_trip_count: 2
// K64-RANDOM: persistent_completion=waitcnt poll_sleep_cycles=1 consumer_pipeline=True k_slices=2
// K64-RANDOM: loop_trip_count: 2
// K64-RANDOM: output_check: passed mode=strict
// K64-RANDOM: hw_output_check: passed
//
// K64-HPL: seed=0 input_mode=hpl
// K64-HPL: kernel_arg_trip_count: 2
// K64-HPL: persistent_completion=waitcnt poll_sleep_cycles=1 consumer_pipeline=True k_slices=2
// K64-HPL: loop_trip_count: 2
// K64-HPL: output_check: passed mode=strict
// K64-HPL: hw_output_check: passed
