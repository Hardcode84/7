# REQUIRES: host-supports-amdgpu-wmma, host-has-hip-runtime
# RUN: wavec -DW=32 -DM=32 -DN=32 -DK=32 -DK_TILES=2 -DN_TILES=2 \
# RUN:   %S/../../examples/wavec/wmma_f16_matmul.wave \
# RUN:   | wave-opt | FileCheck %s --check-prefix=WAVE
# RUN: wavec -c --offload-arch=%chip -DW=32 -DM=32 -DN=32 -DK=32 \
# RUN:   -DK_TILES=2 -DN_TILES=2 \
# RUN:   -o %t.hsaco %S/../../examples/wavec/wmma_f16_matmul.wave
# RUN: env LD_LIBRARY_PATH=%rocm_lib %python %S/Inputs/wavec_wmma_matmul_ctypes_runner.py \
# RUN:   --hip-lib=%hip_runtime_lib --m=32 --n=32 --k=32 --seed=73 \
# RUN:   %t.hsaco wavec_wmma_f16_matmul | FileCheck %s --check-prefix=OUT

# WAVE-LABEL: func.func @wavec_wmma_f16_matmul
# WAVE: wave.ptr_cast
# WAVE: waveamd.fragment_pack
# WAVE: waveamd.mma "wmma.f32.16x16x16.f16"
# WAVE: waveamd.fragment_unpack

# OUT: max_abs_error=
# OUT: wavec WMMA matmul random ok
