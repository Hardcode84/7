# REQUIRES: wave-python-bindings
# RUN: %python %s | FileCheck %s

from mlir.dialects import wave_dsl as w

with w.module() as mod:
    with mod.function("explicit", [w.ptr_type(w.i32())]) as f:
        value = f.splat(f.constant(w.i32(), 7), width=64)
        f.observe(f.store(value, f.args[0]))
        f.return_()
    assert mod.module.operation.verify()
    print(mod.module)

# CHECK-LABEL: func.func @explicit
# CHECK: [[TOKEN:%.*]] = wave.store
# CHECK-NEXT: return [[TOKEN]] : !wave.mem.token

with w.module() as mod, mod.function("invalid", []) as f:
    try:
        f.observe(f.constant(w.i32(), 0))
    except ValueError as error:
        assert "memory tokens" in str(error)
    else:
        raise AssertionError("non-token observation accepted")
