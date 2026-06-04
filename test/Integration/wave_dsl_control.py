# REQUIRES: wave-python-bindings
# RUN: %python %s | wave-opt - --verify-diagnostics | FileCheck %s

from mlir.dialects import wave_dsl as w

with (
    w.module() as m,
    m.function("dsl_control_kernel", [w.ptr_type(w.i32()), w.i32()]) as f,
):
    _out, limit = f.args
    lane = f.lane_id()
    vlimit = f.splat(limit)
    active = f.cmpi("ult", lane, vlimit)
    with f.where(active, [w.simd_type(w.i32())]) as where:
        f.yield_([lane])
        with where.otherwise():
            fallback = f.splat(f.constant(w.i32(), 7))
            f.yield_([fallback])
    _masked = where.results[0]

    cond = f.constant(w.i1(), 1)
    lhs = f.constant(w.i32(), 11)
    rhs = f.constant(w.i32(), 22)
    with f.if_(cond, [w.i32()], otherwise=True) as ifop:
        f.yield_([lhs])
        with ifop.otherwise():
            f.yield_([rhs])
    _uniform = ifop.results[0]

print(m.module)

# CHECK-LABEL: func.func @dsl_control_kernel
# CHECK: wave.where
# CHECK: otherwise
# CHECK: scf.if
# CHECK: else
