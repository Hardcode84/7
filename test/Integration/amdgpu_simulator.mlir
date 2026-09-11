// REQUIRES: host-has-amdgpu-simulator
// RUN: %python %S/../../build_tools/amdgpu_simulator.py test --build-dir=%wave_obj_root \
// RUN:   --target=gfx942 --test=wavec_saxpy_runtime --skip-build | FileCheck %s --check-prefix=SUCCESS
// RUN: %python %S/../../build_tools/amdgpu_simulator.py test --build-dir=%wave_obj_root \
// RUN:   --target=gfx1250 --test=wave_gfx1250_tdm_gemm_runtime --skip-build | FileCheck %s --check-prefix=TDM
// RUN: not %python %S/../../build_tools/amdgpu_simulator.py test --build-dir=%wave_obj_root \
// RUN:   --target=gfx942 --test=wave_gfx1250_tdm_gemm_runtime --test=wavec_saxpy_runtime --skip-build 2>&1 \
// RUN:   | FileCheck %s --check-prefix=SKIP

// SUCCESS: PASS: Integration/wavec_saxpy_runtime.mlir
// TDM: PASS: Integration/wave_gfx1250_tdm_gemm_runtime.mlir
// SKIP: FAILED: expected one PASS:
// SKIP: PASS: Integration/wavec_saxpy_runtime.mlir
