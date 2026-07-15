# REQUIRES: wave-python-bindings
# RUN: %python %s | wave-opt - --verify-diagnostics | FileCheck %s

from mlir.dialects import wave_dsl as w

with w.module() as m:
    with m.function(
        "symbolic_memory_python_builder",
        [
            w.ptr_type(w.i32()),
            w.index_type(),
            w.simd_type(w.vector_type(4, w.index_type()), 32),
        ],
        kernel=True,
        workgroup_size=[32, 1, 1],
    ) as f:
        base, origin_value, index_packet = f.args
        origin = w.sym("origin")
        index = w.sym("index")
        packet = w.simd_type(w.vector_type(4, w.i32()), 32)
        loaded, read = f.gather(
            base,
            packet,
            bit_offset=32 * (origin + index),
            bindings={origin: origin_value},
            packet_bindings={index: index_packet},
        )
        f.scatter(
            loaded,
            base,
            bit_offset=32 * (origin + index),
            bindings={origin: origin_value},
            packet_bindings={index: index_packet},
            after=read,
        )

    w.PassManager.parse("builtin.module(wave-lower-symbolic-memory)").run(
        m.module.operation
    )
    print(m.module)

# CHECK-LABEL: func.func @symbolic_memory_python_builder
# CHECK-NOT: wave.gather
# CHECK-NOT: wave.scatter
# CHECK: wave.load
# CHECK: wave.store
