# REQUIRES: wave-python-bindings
# RUN: %python %s | FileCheck %s

from mlir.dialects import wave_dsl as w

with (
    w.module() as m,
    m.gpu_module("kernels") as gmod,
    gmod.kernel(
        "shape_attrs",
        [],
        lds_size=256,
        workgroup_size=[128, 1, 1],
        attrs={"waveamdmachine.target_waves": w.i64_attr(2)},
    ),
):
    pass

print(m.module)

# CHECK-LABEL: func.func @shape_attrs
# CHECK-SAME: gpu.kernel
# CHECK-SAME: gpu.known_block_size = array<i32: 128, 1, 1>
# CHECK-SAME: wave.kernel
# CHECK-SAME: wave.lds_size = 256 : i64
# CHECK-SAME: wave.workgroup_size = array<i32: 128, 1, 1>
# CHECK-SAME: waveamdmachine.target_waves = 2 : i64
