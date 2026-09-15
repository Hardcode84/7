// REQUIRES: host-supports-amdgpu-gfx950, wave-python-bindings
// RUN: %python %S/wave_token_observed_dma.py run | FileCheck %s
// CHECK: Both observation sets passed
