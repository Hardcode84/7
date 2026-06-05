# REQUIRES: host-supports-amdgpu-wave, host-has-hip-runtime
# RUN: wavec -c --offload-arch=%chip -DW=%wave_width \
# RUN:   -o %t.hsaco %S/Inputs/wavec_saxpy_runtime.wave
# RUN: env LD_LIBRARY_PATH=%rocm_lib %python %S/Inputs/wavec_saxpy_ctypes_runner.py \
# RUN:   --hip-lib=%hip_runtime_lib --wave-size=%wave_width --seed=37 \
# RUN:   %t.hsaco saxpy | FileCheck %s

# CHECK: n=0 ok
# CHECK: n=1 ok
# CHECK: saxpy ctypes runner ok
