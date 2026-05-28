# RUN: %PYTHON %s | FileCheck %s

# Smoke tests for the `wavemeta` Python bindings: the dialect registers,
# `!wavemeta.ptuple` materialises from both `IntegerAttr` (concrete
# width) and `StringAttr` (parameter-named width), and the generated
# op classes build a syntactically valid module that round-trips
# through the printer.

from mlir._mlir_libs._waveDialectsNanobind import (
    PTupleType,
    register_dialects,
)
from mlir.dialects import arith, func, wavemeta
from mlir.ir import (
    Context,
    IndexType,
    InsertionPoint,
    IntegerAttr,
    IntegerType,
    Location,
    Module,
    StringAttr,
)


def run(f):
    print("\nTEST:", f.__name__)
    f()


# CHECK-LABEL: TEST: test_ptuple_type_concrete_and_parametric
@run
def test_ptuple_type_concrete_and_parametric():
    with Context() as ctx, Location.unknown():
        register_dialects(ctx)
        i32 = IntegerType.get_signless(32)
        i64 = IntegerType.get_signless(64)
        # Concrete width: IntegerAttr.
        concrete = PTupleType.get(i32, IntegerAttr.get(i64, 4))
        # Parameter-named width: StringAttr.
        parametric = PTupleType.get(i32, StringAttr.get("n"))
        # CHECK: !wavemeta.ptuple<i32, 4 : i64>
        print(concrete)
        # CHECK: !wavemeta.ptuple<i32, "n">
        print(parametric)
        assert concrete.element_type == i32
        assert IntegerAttr(concrete.width).value == 4
        assert StringAttr(parametric.width).value == "n"


# CHECK-LABEL: TEST: test_param_op_bound_and_unbound
@run
def test_param_op_bound_and_unbound():
    with Context() as ctx, Location.unknown():
        register_dialects(ctx)
        m = Module.create()
        i32 = IntegerType.get_signless(32)
        idx = IndexType.get()
        with InsertionPoint(m.body):
            f = func.FuncOp("params", ([], [idx, i32]))
            block = f.add_entry_block()
            with InsertionPoint(block):
                unbound = wavemeta.ParamOp(idx, "unroll").result
                bound = wavemeta.ParamOp(
                    i32, "tile_m", value=IntegerAttr.get(i32, 64)
                ).result
                func.ReturnOp([unbound, bound])
        # CHECK: func.func @params() -> (index, i32)
        # CHECK: %[[U:.+]] = wavemeta.param "unroll" : index
        # CHECK: %[[B:.+]] = wavemeta.param "tile_m" {value = 64 : i32} : i32
        # CHECK: return %[[U]], %[[B]]
        print(m)


# CHECK-LABEL: TEST: test_static_for_with_iter_args
@run
def test_static_for_with_iter_args():
    with Context() as ctx, Location.unknown():
        register_dialects(ctx)
        m = Module.create()
        i32 = IntegerType.get_signless(32)
        idx = IndexType.get()
        with InsertionPoint(m.body):
            f = func.FuncOp("sum", ([i32], [i32]))
            block = f.add_entry_block()
            with InsertionPoint(block):
                (init,) = block.arguments
                c0 = arith.ConstantOp(idx, IntegerAttr.get(idx, 0)).result
                c4 = arith.ConstantOp(idx, IntegerAttr.get(idx, 4)).result
                c1 = arith.ConstantOp(idx, IntegerAttr.get(idx, 1)).result
                loop = wavemeta.StaticForOp(c0, c4, c1, [init])
                with InsertionPoint(loop.body_block):
                    iv = loop.induction_variable
                    (acc,) = loop.inner_iter_args
                    nxt = arith.AddIOp(
                        acc,
                        arith.IndexCastOp(i32, iv).result,
                    ).result
                    wavemeta.YieldOp([nxt])
                func.ReturnOp([loop.results[0]])
        # CHECK: wavemeta.static_for %{{.+}} to %{{.+}} step %{{.+}} iter_args(%{{.+}} : i32)
        # CHECK: wavemeta.yield %{{.+}} : i32
        print(m)


# CHECK-LABEL: TEST: test_unrolled_for_with_iter_args
@run
def test_unrolled_for_with_iter_args():
    with Context() as ctx, Location.unknown():
        register_dialects(ctx)
        m = Module.create()
        idx = IndexType.get()
        with InsertionPoint(m.body):
            f = func.FuncOp("sum_unrolled", ([idx], [idx]))
            block = f.add_entry_block()
            with InsertionPoint(block):
                (init,) = block.arguments
                c0 = arith.ConstantOp(idx, IntegerAttr.get(idx, 0)).result
                c8 = arith.ConstantOp(idx, IntegerAttr.get(idx, 8)).result
                c1 = arith.ConstantOp(idx, IntegerAttr.get(idx, 1)).result
                c4 = arith.ConstantOp(idx, IntegerAttr.get(idx, 4)).result
                loop = wavemeta.UnrolledForOp(c0, c8, c1, c4, [init])
                with InsertionPoint(loop.body_block):
                    iv = loop.induction_variable
                    (acc,) = loop.inner_iter_args
                    nxt = arith.AddIOp(acc, iv).result
                    wavemeta.YieldOp([nxt])
                func.ReturnOp([loop.results[0]])
        # CHECK: wavemeta.unrolled_for %{{.+}} to %{{.+}} step %{{.+}} unroll %{{.+}} iter_args(%{{.+}} : index)
        # CHECK: wavemeta.yield %{{.+}} : index
        print(m)


# CHECK-LABEL: TEST: test_tuple_make_and_get
@run
def test_tuple_make_and_get():
    with Context() as ctx, Location.unknown():
        register_dialects(ctx)
        m = Module.create()
        i32 = IntegerType.get_signless(32)
        i64 = IntegerType.get_signless(64)
        idx = IndexType.get()
        with InsertionPoint(m.body):
            f = func.FuncOp("pick", ([i32, i32, i32, i32], [i32]))
            block = f.add_entry_block()
            with InsertionPoint(block):
                a, b, c, d = block.arguments
                tuple_t = PTupleType.get(i32, IntegerAttr.get(i64, 4))
                t = wavemeta.TupleMakeOp(tuple_t, [a, b, c, d]).result
                two = arith.ConstantOp(idx, IntegerAttr.get(idx, 2)).result
                v = wavemeta.TupleGetOp(i32, t, two).result
                func.ReturnOp([v])
        # CHECK: %[[T:.+]] = wavemeta.tuple_make
        # CHECK: %[[V:.+]] = wavemeta.tuple_get %[[T]][%{{.+}}] : <i32, 4 : i64> -> i32
        # CHECK: return %[[V]]
        print(m)
