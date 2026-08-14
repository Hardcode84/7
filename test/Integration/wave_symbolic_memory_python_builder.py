# REQUIRES: wave-python-bindings
# RUN: %python %s | wave-opt - --verify-diagnostics | FileCheck %s

from mlir.dialects import wave_dsl as w

with w.module() as m:
    with m.function(
        "symbolic_memory_python_builder",
        [
            w.ptr_type(w.i32()),
            w.index_type(),
        ],
        kernel=True,
        workgroup_size=[32, 1, 1],
    ) as f:
        base, origin_value = f.args
        origin = w.sym("origin")
        slot = w.sym("slot")
        packet = w.simd_type(w.vector_type(4, w.i32()), 32)
        loaded, read = f.gather(
            base,
            packet,
            bit_offset=32 * (origin + slot),
            bindings={origin: origin_value},
        )
        f.scatter(
            loaded,
            base,
            bit_offset=32 * (origin + slot),
            bindings={origin: origin_value},
            after=read,
        )

    packet = w.simd_type(w.vector_type(4, w.i32()), 32)
    mask = w.mask_type(32)
    with m.function(
        "packet_predicated_symbolic_memory_python_builder",
        [
            w.ptr_type(w.i32()),
            packet,
            mask,
            mask,
            mask,
            mask,
        ],
        kernel=True,
        workgroup_size=[32, 1, 1],
    ) as f:
        base, fallback, m0, m1, m2, m3 = f.args
        slot = w.sym("slot")
        inactive = f.token()
        with f.where([m0, m1, m2, m3], [packet, w.mem_token_type()]) as active:
            loaded, read = f.gather(
                base,
                packet,
                bit_offset=32 * slot,
            )
            f.yield_([loaded, read])
            with active.otherwise():
                f.yield_([fallback, inactive])

    w.PassManager.parse("builtin.module(wave-lower-symbolic-memory)").run(
        m.module.operation
    )
    print(m.module)

# CHECK-LABEL: func.func @symbolic_memory_python_builder
# CHECK-NOT: wave.gather
# CHECK-NOT: wave.scatter
# CHECK: wave.load
# CHECK: wave.store
# CHECK-LABEL: func.func @packet_predicated_symbolic_memory_python_builder
# CHECK-NOT: wave.gather
# CHECK: wave.where
# CHECK: wave.load
# CHECK: wave.where
# CHECK: wave.load
# CHECK: wave.where
# CHECK: wave.load
# CHECK: wave.where
# CHECK: wave.load
