# REQUIRES: host-supports-amdgpu-wave, host-has-hip-runtime
# RUN: wavec -DW=%wave_width -o %t.wave \
# RUN:   %S/Inputs/wavec_saxpy_multiwave_runtime.wave
# RUN: FileCheck %s --check-prefix=WAVE < %t.wave
# RUN: wavec -c --offload-arch=%chip -DW=%wave_width \
# RUN:   -o %t.hsaco %S/Inputs/wavec_saxpy_multiwave_runtime.wave
# RUN: env LD_LIBRARY_PATH=%rocm_lib %python %S/Inputs/wavec_saxpy_ctypes_runner.py \
# RUN:   --hip-lib=%hip_runtime_lib --wave-size=%wave_width --wave-ir=%t.wave \
# RUN:   --seed=53 %t.hsaco saxpy_multi | FileCheck %s --check-prefix=OUT

# WAVE-LABEL: func.func @saxpy_multi
# WAVE-DAG: gpu.known_block_size = array<i32: [[BLOCK:[0-9]+]], 1, 1>
# WAVE-DAG: wave.workgroup_size = array<i32: [[BLOCK]], 1, 1>
# WAVE-DAG: wave.waves_per_workgroup = 2 : i64

# OUT: n=0 ok
# OUT: n=1 ok
# OUT: saxpy ctypes runner ok
